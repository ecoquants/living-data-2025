librarian::shelf(
  bsicons, bslib, dplyr, DT, glue, here, jsonlite, lubridate, readr,
  shiny, shinyauthr, sodium, stringr, tidyr, quiet = T)

# user credentials ----
user_base <- data.frame(
  user      = c("ben", "erin"),
  password  = c("p@ss", "p@ss"),
  password_hash = sapply(c("p@ss", "p@ss"), sodium::password_store),
  permissions  = c("admin", "admin"),
  name      = c("Ben", "Erin"),
  stringsAsFactors = FALSE)

# Read both JSON files
abstracts <- fromJSON(here("data/Abstracts.json"))
sessions  <- fromJSON(here("data/Sessions.json"))

# add sessions without abstracts (Panel, Plenary, Workshop) ----
sessions_without_abstracts <- sessions |>
  filter(
    Session_Type %in% c("Panel", "Plenary", "Workshop"),
    !Session_ID %in% abstracts$Session_ID) |>
  mutate(
    Presentation_Time = Start_Time,
    Talk_Duration    = as.numeric(difftime(
      ymd_hms(paste(Date, End_Time)),
      ymd_hms(paste(Date, Start_Time)),
      units = "mins")),
    Abstract_Title   = Session_Title,
    Presenter_Name   = sapply(Session_Organizers, function(x) {
      if (is.null(x) || length(x) == 0) return(NA_character_)
      if (length(x) > 1) paste(unlist(x), collapse = ", ")
      else as.character(x)
    }),
    Presentation_Type = Session_Type,
    Organization     = NA_character_,
    Country          = NA_character_,
    Language         = "en",
    Abstract_Body    = ifelse(
      is.na(Session_Abstract) | Session_Abstract == "null" | Session_Abstract == "",
      "", Session_Abstract)) |>
  select(
    Session_ID, Presentation_Time, Talk_Duration,
    Abstract_Title, Presenter_Name, Presentation_Type,
    Organization, Country, Language, Abstract_Body)

# combine abstracts with sessions without abstracts
abstracts_combined <- bind_rows(abstracts, sessions_without_abstracts)

# Prepare sessions data
sessions_clean <- sessions |>
  select(
    Session_ID,
    session_title = Session_Title,
    session_type = Session_Type,
    session_abstract = Session_Abstract,
    Date,
    Start_Time,
    End_Time,
    room_name = Room_Name,
    Session_Organizers,
    Theme,
    Organisation_theme)

# Join abstracts with sessions
schedule <- abstracts_combined |>
  left_join(sessions_clean, by = "Session_ID") |>
  mutate(
    # Create datetime from session date and presentation time
    datetime = ymd_hms(paste(Date, Presentation_Time)),

    # Calculate duration
    minutes = as.numeric(Talk_Duration),

    # Create day of week + time string
    day = wday(datetime, label = TRUE, abbr = FALSE),
    time_beg = format(datetime, "%H:%M"),
    time = paste0(
      str_sub(wday(datetime, label = TRUE, abbr = TRUE), 1, 3), " ",
      format(datetime, "%H:%M")),

    # Use Abstract_ID as primary ID (use Session_ID if Abstract_ID is null)
    id = ifelse(is.na(Abstract_ID), paste0("session_", Session_ID), as.character(Abstract_ID)),

    # Title and presenter info
    title     = Abstract_Title,
    presenter = Presenter_Name,
    location  = room_name,
    type      = Presentation_Type,

    # Organization and country
    organization = Organization,
    country      = Country,
    language     = Language,

    # Session organizers
    session_organizers = sapply(Session_Organizers, function(x) {
      if (is.null(x) || length(x) == 0) return(NA_character_)
      if (is.list(x)) paste(unlist(x), collapse = ", ")
      else as.character(x)
    }),

    # Abstract handling
    abstract_text = ifelse(is.na(Abstract_Body) | Abstract_Body == "null" | Abstract_Body == "",
                           "", Abstract_Body),
    has_abstract = !is.na(Abstract_Body) & Abstract_Body != "" & Abstract_Body != "null",

    # Date
    date = Date,

    display_title = str_trunc(paste0(
      ifelse(!is.na(presenter), paste0(presenter, ": "), ""),
      title
    ), 80)
  ) |>
  # Remove entries without a presentation time
  filter(!is.na(datetime)) |>
  select(
    id, time, minutes, location, type, title, presenter, organization,
    country, language, session_title, session_type, session_organizers,
    abstract_text, session_abstract, has_abstract, date, day, time_beg,
    datetime, display_title, Session_ID)

# ui ----
ui <- fluidPage(
  theme = bslib::bs_theme(version = 5, bootswatch = "cosmo"),

  # login panel from shinyauthr
  shinyauthr::loginUI(id = "login"),

  # Add custom CSS and JavaScript for modal
  tags$head(
    tags$style(HTML("
      .abstract-link {
        color: #2c5aa0;
        cursor: pointer;
        text-decoration: underline;
      }
      .abstract-link:hover {
        color: #1a3a70;
      }
      .star-icon {
        cursor: pointer;
        font-size: 20px;
        user-select: none;
        display: inline-block;
        transition: all 0.2s ease;
      }
      .star-icon:hover {
        transform: scale(1.3);
      }
      .star-unselected {
        color: #ccc;
      }
      .star-selected {
        color: #ffd700;
        text-shadow: 0 0 3px rgba(255, 215, 0, 0.5);
      }" )),
    tags$script(HTML("
      // Update star icon when toggle_selection changes
      $(document).on('shiny:inputchanged', function(event) {
        if (event.name === 'toggle_selection') {
          var clickedId = event.value;
          // Find the star that was clicked and toggle its appearance
          $('.star-icon').each(function() {
            var onclick = $(this).attr('onclick');
            if (onclick && onclick.includes(clickedId)) {
              if ($(this).hasClass('star-selected')) {
                // Change from selected to unselected
                $(this).removeClass('star-selected').addClass('star-unselected');
                $(this).text('☆');
              } else {
                // Change from unselected to selected
                $(this).removeClass('star-unselected').addClass('star-selected');
                $(this).text('★');
              }
            }
          });
        }
      });
    "))
  ),

  # main content (only visible when logged in)
  uiOutput("main_content")
)

# main_ui ----
main_ui <- tagList(
  titlePanel("Living Data 2025 - Personal Schedule Builder"),

  bslib::page_sidebar(
    sidebar = bslib::sidebar(
      width = 275,

      bslib::accordion(
        id = "filters_accordion",
        open = c("filters", "schedule"),
        multiple = TRUE,

        bslib::accordion_panel(
          "Filters",
          value = "filters",
          icon = bsicons::bs_icon("funnel"),

          selectInput(
            "day_filter", "Day:",
            choices = c("All Days" = "all", as.character(unique(schedule$day)) ),
            selected = "all"),

          selectInput(
            "location_filter", "Room:",
            choices = c("All Rooms" = "all", sort(unique(schedule$location[!is.na(schedule$location)]))),
            selected = "all"),

          checkboxGroupInput(
            "type_filter", "Presentation Type:",
            choices = sort(unique(schedule$type[!is.na(schedule$type) & schedule$type != ""])),
            selected = sort(unique(schedule$type[!is.na(schedule$type) & schedule$type != ""]))),

          selectInput(
            "language_filter", "Language:",
            choices = c("All Languages" = "all", "English" = "en", "Español" = "es"),
            selected = "all"),

          checkboxInput("include_past", "Include Past Events", value = FALSE)
        ),

        bslib::accordion_panel(
          "Your Schedule",
          value = "schedule",
          icon = bsicons::bs_icon("calendar-check"),

          textOutput("selected_count"), br(),
          downloadButton("download_schedule", "Download My Schedule", class = "w-100"), br(), br(),
          actionButton("clear_selection", "Clear All Selections", class = "btn-warning w-100"), br(), br(),
          shinyauthr::logoutUI(id = "logout")
        )
      )
    ),

    tabsetPanel(
      id = "main_tabs",

      tabPanel(
        "Browse Schedule",
        br(),
        h4("Conference Schedule"),
        p(
          strong("How to use:"), br(),
          "• Click the ", strong("★ star"), " to add/remove a talk from your schedule (☆ = not selected, ★ = selected)", br(),
          "• Click ", strong("View"), " to read the abstract"
        ),
        DTOutput("schedule_table")
      ),

      tabPanel(
        "My Schedule",
        br(),
        div(
          id = "mobile_view",
          style = "max-width: 400px; margin: auto; background: white; padding: 20px; border: 1px solid #ddd;",
          uiOutput("mobile_schedule")
        )
      )
    )
  )
)

server <- function(input, output, session) {

  # authentication ----
  credentials <- shinyauthr::loginServer(
    id = "login",
    data = user_base,
    user_col = user,
    pwd_col = password_hash,
    sodium_hashed = TRUE,
    log_out = reactive(logout_init()))

  logout_init <- shinyauthr::logoutServer(
    id = "logout",
    active = reactive(credentials()$user_auth))

  # render main content only when logged in ----
  output$main_content <- renderUI({
    req(credentials()$user_auth)
    main_ui
  })

  # Reactive values
  # saved_file (user-specific) ----
  saved_file <- reactive({
    req(credentials()$user_auth)
    here(glue("data/{credentials()$info$user}_schedule.rds"))
  })

  initial_selection <- reactive({
    req(credentials()$user_auth)
    if (file.exists(saved_file())) {
      readRDS(saved_file())
    } else {
      c()
    }
  })

  selected_events <- reactiveVal(c())

  # initialize selected_events when user logs in
  observe({
    req(credentials()$user_auth)
    selected_events(initial_selection())
  })

  # filtered_schedule ----
  filtered_schedule <- reactive({
    df <- schedule |>
      tibble() |>
      arrange(datetime)

    # browser()
    df$datetime

    # Filter past events (older than 15 minutes ago) unless include_past is checked
    if (!input$include_past) {
      # cutoff_time <- now(tzone = "America/Bogota") - minutes(15)
      cutoff_time <- now(tzone = "UTC") - hours(5) - minutes(15)
      df <- df %>% filter(datetime >= cutoff_time) |> arrange(datetime)
    }

    if (input$day_filter != "all") {
      df <- df %>% filter(day == input$day_filter)
    }

    if (input$location_filter != "all") {
      df <- df %>% filter(location == input$location_filter)
    }

    if (input$language_filter != "all") {
      df <- df %>% filter(language == input$language_filter)
    }

    df <- df %>% filter(type %in% input$type_filter)

    df %>%
      arrange(datetime) %>%
      select(id, time, minutes, location, type, title, presenter, organization,
             country, language, session_title, has_abstract, abstract_text, session_abstract)
  })

  # schedule_table ----
  output$schedule_table <- renderDT({
    df <- filtered_schedule()

    # Use isolate() to read selected_events without creating reactive dependency
    # This prevents table from refreshing when stars are clicked
    current_selections <- isolate(selected_events())

    # Add star selection column and format display
    df_display <- df |>
      mutate(
        is_selected = id %in% current_selections,
        star = ifelse(
          is_selected,
          sprintf('<span class="star-icon star-selected" onclick="Shiny.setInputValue(\'toggle_selection\', \'%s\', {priority: \'event\'})">★</span>', id),
          sprintf('<span class="star-icon star-unselected" onclick="Shiny.setInputValue(\'toggle_selection\', \'%s\', {priority: \'event\'})">☆</span>', id)
        ),
        lang_flag = case_when(
          language == "es" ~ "🇪🇸",
          language == "en" ~ "🇬🇧",
          TRUE ~ ""),
        presenter_info = case_when(
          !is.na(presenter) ~ presenter,
          TRUE ~ ""),
        abstract_link = ifelse(
          has_abstract,
          sprintf('<a href="#" class="abstract-link" onclick="event.stopPropagation(); Shiny.setInputValue(\'view_abstract\', \'%s\', {priority: \'event\'}); return false;">View</a>', id),
          ""),
        talk = glue(
          "{title}<br>
           <small>- {presenter_info}<br>
           [{session_title}]</small>")) %>%
      select(
        star,
        time,
        talk,
        location, type, lang_flag, abstract_link, id)

    dt <- df_display |>
      select(-id) |>
      datatable(
      selection = 'none',  # Disable row selection
      options = list(
        pageLength = 25,
        lengthMenu = list(c(25, 50, 100, -1), c('25', '50', '100', 'All')),
        scrollX = TRUE,
        dom = 'Blfrtip',  # Added 'l' for length menu
        buttons = c('copy', 'csv', 'excel'),
        columnDefs = list(
          list(width = '30px', targets = 0, orderable = FALSE, className = 'dt-center'),   # star
          list(width = '50px', targets = 1),   # time
          list(width = '100%', targets = 2),   # talk
          list(width = '50px', targets = 3),   # location
          list(width = '40px', targets = 4),   # type
          list(width = '20px', targets = 5),   # language
          list(width = '30px', targets = 6)    # abstract
        )
      ),
      rownames = FALSE,
      escape = FALSE,
      colnames = c('', 'Time', 'Talk', 'Room', 'Type', 'Lang', 'Abstract'))

    dt
  })

  # observe toggle_selection (star clicks) ----
  observeEvent(input$toggle_selection, {
    clicked_id <- input$toggle_selection
    current_selection <- selected_events()

    if (clicked_id %in% current_selection) {
      # Remove from selection
      selected_events(setdiff(current_selection, clicked_id))
    } else {
      # Add to selection
      selected_events(c(current_selection, clicked_id))
    }
  })

  # observe input$view_abstract ----
  observeEvent(input$view_abstract, {
    talk_data <- schedule %>%
      filter(id == input$view_abstract)

    if (nrow(talk_data) > 0) {
      talk <- talk_data[1, ]

      # Build presenter info
      presenter_html <- ""
      if (!is.na(talk$presenter) && talk$presenter != "") {
        presenter_html <- paste0("<p><strong>Presenter:</strong> ", talk$presenter)
        if (!is.na(talk$organization) && talk$organization != "") {
          presenter_html <- paste0(presenter_html, " (", talk$organization)
          if (!is.na(talk$country) && talk$country != "") {
            presenter_html <- paste0(presenter_html, ", ", talk$country)
          }
          presenter_html <- paste0(presenter_html, ")")
        }
        presenter_html <- paste0(presenter_html, "</p>")
      }

      # Language badge
      lang_badge <- ""
      if (!is.na(talk$language) && talk$language != "") {
        lang_icon <- ifelse(talk$language == "es", "🇪🇸 Español", "🇬🇧 English")
        lang_badge <- paste0(
          "<span style='background: #e9ecef; padding: 4px 8px; border-radius: 4px; font-size: 12px; margin-left: 10px;'>",
          lang_icon, "</span>"
        )
      }

      # Build modal content
      modal_content <- paste0(
        "<div style='margin: 20px;'>",

        # Talk metadata
        "<div style='background: #f8f9fa; padding: 15px; border-radius: 5px; margin-bottom: 20px;'>",
        "<p><strong>Presentation Type:</strong> ", ifelse(is.na(talk$type), "", talk$type), lang_badge, "</p>",
        "<p><strong>Time:</strong> ", talk$time_beg, " (", talk$minutes, " minutes)</p>",
        "<p><strong>Location:</strong> ", talk$location, "</p>",
        presenter_html,
        "</div>",

        # Talk abstract
        if (!is.na(talk$abstract_text) && talk$abstract_text != "") {
          paste0(
            "<h5>Abstract</h5>",
            "<div style='text-align: justify; margin-bottom: 20px; line-height: 1.6;'>",
            talk$abstract_text,
            "</div>"
          )
        } else "",

        # Session context
        if (!is.na(talk$session_title) && talk$session_title != "") {
          paste0(
            "<hr>",
            "<h5>Session: ", talk$session_title, "</h5>",
            "<p><strong>Type:</strong> ", ifelse(is.na(talk$session_type), "", talk$session_type), "</p>",
            if (!is.na(talk$session_organizers) && talk$session_organizers != "") {
              paste0("<p><strong>Session Organizers:</strong> ", talk$session_organizers, "</p>")
            } else "",
            if (!is.na(talk$session_abstract) && talk$session_abstract != "" && talk$session_abstract != "null") {
              paste0(
                "<h6>Session Abstract</h6>",
                "<div style='text-align: justify; font-size: 0.9em; color: #666; line-height: 1.6;'>",
                talk$session_abstract,
                "</div>"
              )
            } else ""
          )
        } else "",

        "</div>"
      )

      showModal(modalDialog(
        title = talk$title,
        HTML(modal_content),
        size = "l",
        easyClose = TRUE,
        footer = modalButton("Close")
      ))
    }
  })

  # Selected count
  output$selected_count <- renderText({
    paste("Talks selected:", length(selected_events()))
  })

  # mobile_schedule ----
  output$mobile_schedule <- renderUI({
    req(length(selected_events()) > 0)

    my_schedule <- schedule %>%
      filter(id %in% selected_events()) %>%
      arrange(datetime) %>%
      mutate(
        datetime_end = datetime + minutes(minutes),
        time_end_display = format(datetime_end, "%H:%M")
      )

    if (!input$include_past) {
      # cutoff_time <- now(tzone = "America/Bogota") - minutes(15)
      cutoff_time <- now(tzone = "UTC") - hours(5) - minutes(15)
      my_schedule <- my_schedule %>% filter(datetime >= cutoff_time) |> arrange(datetime)
    }

    # Group by day
    days <- split(my_schedule, my_schedule$day)


    html_content <- tags$div(
      tags$h3("My Living Data 2025 Schedule",
              style = "text-align: center; color: #2c5aa0;"),
      tags$hr(),

      lapply(names(days), function(day_name) {
        day_events <- days[[day_name]]

        if (nrow(day_events) == 0)
          return("")

        tags$div(
          tags$h4(day_name,
                  style = "background: #2c5aa0; color: white; padding: 10px; margin-top: 20px;"),

          lapply(1:nrow(day_events), function(i) {
            event <- day_events[i, ]

            # Language badge
            lang_badge <- ""
            if (!is.na(event$language) && event$language != "") {
              lang_badge <- ifelse(event$language == "es", "🇪🇸", "🇬🇧")
            }

            tags$div(
              style = "border: 1px solid #ddd; margin: 10px 0; padding: 10px; border-radius: 5px;",

              tags$div(
                style = "background: #f8f9fa; padding: 5px; font-weight: bold; margin-bottom: 5px;",
                paste(event$time_beg, "-", event$time_end_display, lang_badge)
              ),

              tags$div(
                style = "font-size: 14px; font-weight: bold; margin-bottom: 5px;",
                event$title
              ),

              if (isTRUE(!is.na(event$presenter) && event$presenter != "")) {
                tags$div(
                  style = "font-size: 12px; color: #666; margin-bottom: 3px;",
                  paste("Presenter:", event$presenter),
                  if (isTRUE(!is.na(event$organization) && event$organization != "")) {
                    tags$span(
                      style = "font-style: italic;",
                      paste0(" (", event$organization, ")")
                    )
                  }
                )
              },

              tags$div(
                style = "font-size: 12px; color: #666; margin-bottom: 3px;",
                paste("Room:", event$location),
                tags$span(
                  style = "margin-left: 10px; padding: 2px 6px; background: #e9ecef; border-radius: 3px; font-size: 11px;",
                  event$type
                )
              ),

              if (isTRUE(!is.na(event$session_title) && event$session_title != "")) {
                tags$div(
                  style = "font-size: 11px; color: #888; margin-top: 3px; font-style: italic;",
                  paste("Session:", event$session_title)
                )
              },

              if (isTRUE(event$has_abstract)) {
                tags$div(
                  style = "margin-top: 5px;",
                  tags$div(
                    style = "font-size: 12px; color: #2c5aa0; cursor: pointer;",
                    onclick = sprintf("event.stopPropagation(); Shiny.setInputValue('view_abstract', '%s', {priority: 'event'}); return false;", event$id),
                    "View Abstract →"
                  )
                )
              }
            )
          })
        )
      })
    )

    html_content
  })

  # download_schedule ----
  output$download_schedule <- downloadHandler(
    filename = function() {
      paste0("living_data_2025_my_schedule_", Sys.Date(), ".csv")
    },
    content = function(file) {
      my_schedule <- schedule %>%
        filter(id %in% selected_events()) %>%
        arrange(datetime) %>%
        mutate(
          datetime_end = datetime + minutes(minutes),
          time_end_display = format(datetime_end, "%H:%M")
        ) %>%
        select(
          day, date, time_beg, time_end_display, minutes, location,
          presenter, organization, country, title, type, language,
          session_title, session_type, abstract_text)

      write_csv(my_schedule, file)
    }
  )

  # Auto-save selection whenever it changes
  observeEvent(selected_events(), {
    req(credentials()$user_auth)
    saveRDS(selected_events(), saved_file())
  }, ignoreNULL = FALSE)  # Allow saving empty selections

  # Clear selection
  observeEvent(input$clear_selection, {
    selected_events(c())
  })
}

# Run the app
shinyApp(ui = ui, server = server)
