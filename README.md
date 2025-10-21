# Living Data 2025 - Personal Schedule Builder

## 📋 Overview

This package includes a comprehensive schedule for the Living Data 2025 conference (October 21-24, 2025, Bogotá, Colombia) and an R Shiny app to help you build your personal schedule.

## 📦 Files Included

1. **living_data_schedule.csv** - Complete schedule with 273 events
   - Fields: id, title, time_beg, time_end, date, day, location, type, speaker, session_id
   
2. **living_data_schedule.json** - Same data in JSON format

3. **app.R** - R Shiny application for interactive schedule building

4. **README.md** - This file

## 🎯 Features

### The Shiny App Provides:

1. **Browse Schedule** - View all conference events with filtering options
   - Filter by day, location, and event type
   - Click rows to add to your personal schedule

2. **Concurrent Events** - See what's happening at the same time
   - Choose between competing sessions
   - Helps resolve scheduling conflicts

3. **My Schedule** - Your personalized agenda
   - View all selected events
   - Automatic conflict detection
   - Download as CSV

4. **Mobile View** - Clean, phone-friendly schedule
   - Organized by day
   - Quick reference for on-the-go
   - Direct links to abstracts

## 🚀 Quick Start

### Prerequisites

You need R (version 4.0+) installed. Then install required packages:

```r
install.packages(c("shiny", "DT", "dplyr", "tidyr", "readr", 
                   "lubridate", "stringr", "bslib"))
```

### Running the App

**Option 1: From R Console**
```r
# Set working directory to where you saved the files
setwd("path/to/your/files")

# Run the app
shiny::runApp("app.R")
```

**Option 2: From Command Line**
```bash
cd path/to/your/files
R -e "shiny::runApp('app.R')"
```

**Option 3: Using RStudio**
1. Open `app.R` in RStudio
2. Click the "Run App" button

The app will open in your default web browser, typically at http://127.0.0.1:XXXX

## 📱 How to Use

### Building Your Schedule

1. **Filter Events**
   - Use sidebar filters to narrow down events by day, location, or type
   - Event types include: oral, symposium, workshop, panel, poster, plenary, lightning

2. **Select Events**
   - In "Browse Schedule" tab, click on rows to select events
   - Selected events are highlighted in green
   - Selected count updates in the sidebar

3. **Handle Conflicts**
   - Go to "Concurrent Events" tab
   - Select a time slot to see all events happening simultaneously
   - Choose which one to attend
   - The app automatically handles your selection

4. **Review Your Schedule**
   - Check "My Schedule" tab
   - See your selected events sorted by time
   - View any conflicts detected
   - Click links to view abstracts online

5. **Mobile View**
   - Click "Generate Mobile View" button
   - Get a clean, day-by-day schedule
   - Save this view to your phone for easy conference access
   - Each event includes a direct link to its abstract

6. **Download**
   - Click "Download My Schedule" to get a CSV file
   - Import into your calendar app or keep as reference

## 📊 Schedule Statistics

- **Total Events**: 273
- **Days**: Tuesday-Friday (Oct 21-24)
- **Event Distribution**:
  - Tuesday: 66 events
  - Wednesday: 73 events  
  - Thursday: 94 events
  - Friday: 40 events

- **Event Types**:
  - Oral presentations: 264
  - Workshops: 3
  - Lightning talks: 3
  - Symposia: 2
  - Panel: 1

## 🔗 Abstract Links

Each event has a direct link to its full abstract using the pattern:
```
https://www.livingdata2025.com/program.html?abstract={id}
```

For example, event ID 7021007 links to:
https://www.livingdata2025.com/program.html?abstract=7021007

## 📝 Data Structure

### CSV Fields:

- **id**: Unique event identifier (7-digit number)
- **title**: Event title
- **time_beg**: Start time (HH:MM format)
- **time_end**: End time (HH:MM format)
- **date**: Event date (YYYY-MM-DD)
- **day**: Day of week
- **location**: Room/venue name
- **type**: Event type (oral, symposium, workshop, etc.)
- **speaker**: Presenter name
- **session_id**: Parent session ID (if applicable)

## 💡 Tips

1. **Start Early**: Review the full schedule before the conference
2. **Plan Breaks**: Don't schedule back-to-back sessions without breaks
3. **Check Locations**: Some venues may require travel time
4. **Use Mobile View**: Screenshot or save the mobile view for offline access
5. **Bookmark Abstracts**: The app provides direct links to read full abstracts

## 🐛 Troubleshooting

**App won't start?**
- Ensure all required packages are installed
- Check that you're in the correct working directory
- Verify that `living_data_schedule.csv` is in the same folder as `app.R`

**Can't see all events?**
- Check your filters in the sidebar
- Try "All Days" and "All Locations"
- Ensure all event types are checked

**Mobile view not showing?**
- You need to select at least one event first
- Click "Generate Mobile View" after selecting events

## 📧 Conference Info

- **Website**: https://www.livingdata2025.com
- **Dates**: October 21-24, 2025
- **Location**: Bogotá, Colombia
- **Email**: info@livingdata2025.com

## ⚠️ Important Notes

- This schedule was extracted from the PDF program and may not reflect last-minute changes
- Times are estimated based on typical session durations:
  - Oral presentations: 10 minutes
  - Lightning talks: 5 minutes
  - Symposia/Workshops: 120 minutes
  - Plenary: 45 minutes
- Always check the official conference website for updates
- The online schedule at livingdata2025.com/program.html may have more current information

## 🙏 Acknowledgments

Data extracted from Living Data 2025 Conference Program PDF.
Conference organized by TDWG, OBIS, GEO BON, GBIF, and Instituto Humboldt Colombia.

---

**Enjoy the conference! 🎉**

For the latest updates, visit: https://www.livingdata2025.com/program.html
