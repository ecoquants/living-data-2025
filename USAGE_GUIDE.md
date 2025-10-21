# Living Data 2025 - App Usage Guide

## 🎨 Visual Walkthrough

This guide shows you exactly how to use the Shiny app to build your conference schedule.

---

## 📱 App Interface Overview

```
┌─────────────────────────────────────────────────────────┐
│  Living Data 2025 - Personal Schedule Builder           │
├──────────────┬──────────────────────────────────────────┤
│              │                                           │
│  SIDEBAR     │           MAIN CONTENT AREA              │
│              │                                           │
│  [Filters]   │  Tab 1: Browse Schedule                 │
│  - Day       │  Tab 2: Concurrent Events               │
│  - Location  │  Tab 3: My Schedule                     │
│  - Type      │  Tab 4: Mobile View                     │
│              │                                           │
│  [Actions]   │  [Data table or view appears here]      │
│  - Download  │                                           │
│  - Mobile    │                                           │
│  - Clear     │                                           │
│              │                                           │
└──────────────┴──────────────────────────────────────────┘
```

---

## 🔍 Step-by-Step Usage

### Step 1: Launch the App
```r
source("start_app.R")
```
→ Browser opens automatically with the app

### Step 2: Browse & Filter
**Location**: Tab 1 "Browse Schedule"

**What you see**:
- Table with all 273 conference events
- Columns: id, day, time_beg, time_end, location, type, title, speaker

**Sidebar filters**:
```
┌─ Filters ──────────┐
│ Day: [All Days ▼]  │
│ Location: [All ▼]  │
│ Type:              │
│ ☑ oral            │
│ ☑ symposium       │
│ ☑ workshop        │
│ ☐ panel           │
└────────────────────┘
```

**Actions**:
- Click dropdown to filter by day (Tuesday/Wednesday/Thursday/Friday)
- Select specific location (Ballroom A, Caldas, etc.)
- Uncheck types you're not interested in

**Select events**:
- Click any row to add to your schedule
- Selected rows turn GREEN
- Selection count updates in sidebar

---

### Step 3: Handle Concurrent Sessions
**Location**: Tab 2 "Concurrent Events"

**What you see**:
```
Select Time Slot: [Tuesday - 11:15 ▼]

┌─────────────────────────────────────────────┐
│  Events happening at Tuesday 11:15          │
├─────────────────────────────────────────────┤
│  Event 1: Topic A in Ballroom A            │
│  Event 2: Topic B in Ballroom B1           │
│  Event 3: Topic C in Caldas                │
└─────────────────────────────────────────────┘
```

**Actions**:
1. Choose a time slot from dropdown
2. See ALL events happening simultaneously
3. Click to select the one you want to attend
4. Previous selection for that time is automatically removed

**Use case**: 
"I see 3 interesting talks at 2:30pm. Which should I attend?"

---

### Step 4: Review Your Schedule
**Location**: Tab 3 "My Schedule"

**What you see**:
```
Your Personal Schedule (sorted by time)

Day         Time        Location    Title              Speaker
Tuesday     11:15-11:25 Ballroom A  Data Integration   John Doe
Tuesday     11:30-11:40 Ballroom A  Remote Sensing     Jane Smith
Wednesday   09:00-09:10 Ballroom    Keynote Talk       Dr. Lee

Conflicts Section:
┌─────────────────────────────────────────────┐
│  No conflicts detected! ✓                   │
└─────────────────────────────────────────────┘
```

**OR if conflicts exist**:
```
Conflicts:
┌─────────────────────────────────────────────┐
│ 11:30-11:40: Event A (Room 1)              │
│              Event B (Room 2)               │
│ → You can't attend both!                   │
└─────────────────────────────────────────────┘
```

**Features**:
- All selected events in chronological order
- Clickable links to view full abstracts
- Automatic conflict detection
- Clear visualization of your day

---

### Step 5: Generate Mobile View
**Location**: Tab 4 "Mobile View" OR click button in sidebar

**What you see**:
```
┌─────────────────────────┐
│  My Schedule            │
│                         │
│  === Tuesday ===        │
│  ⏰ 11:15-11:25        │
│  📍 Ballroom A         │
│  📄 Data Integration   │
│  👤 John Doe           │
│  [View Abstract →]     │
│  ───────────────────   │
│  ⏰ 11:30-11:40        │
│  📍 Ballroom B1        │
│  📄 Remote Sensing     │
│  👤 Jane Smith         │
│  [View Abstract →]     │
│                         │
│  === Wednesday ===      │
│  ...                    │
└─────────────────────────┘
```

**Perfect for**:
- Viewing on your phone at the conference
- Taking screenshots to save offline
- Quick reference during the day
- Sharing with colleagues

**Features**:
- Clean, minimal design
- Optimized for small screens
- Direct links to abstracts
- Day-by-day organization
- Time-sorted within each day

---

## 🎯 Key Features Explained

### 1. Smart Selection
- Click once = Add to schedule
- Click again = Remove from schedule
- Selected rows are highlighted GREEN

### 2. Conflict Detection
```
✓ No overlaps = Green light!
⚠ Time conflict = Warning shown
```

### 3. Filtering Power
Combine filters for precision:
```
Day = "Tuesday"
+ Location = "Ballroom A"  
+ Type = "oral"
= Only Tuesday morning orals in Ballroom A
```

### 4. Download Options
```
Button: [Download My Schedule]
↓
Saves: living_data_2025_my_schedule_YYYY-MM-DD.csv
↓
Contains: All your selected events
↓
Use for: Import to calendar, backup, sharing
```

---

## 💡 Pro Tips & Tricks

### Tip 1: Start Broad, Then Narrow
```
1. Browse all events (no filters)
2. Star interesting ones
3. Then filter by day to resolve conflicts
```

### Tip 2: Use Concurrent Events Wisely
```
Best practice:
1. Go through one time slot at a time
2. Pick your favorite from each set
3. Move to next time slot
```

### Tip 3: Check Conflicts Early
```
After every 5-10 selections:
→ Check "My Schedule" tab
→ Review conflicts section
→ Adjust as needed
```

### Tip 4: Mobile View Strategy
```
Before conference:
1. Generate mobile view
2. Screenshot each day
3. Save to phone photos
4. Access offline at venue
```

### Tip 5: Export Multiple Versions
```
Try different scenarios:
- "Focus on AI" schedule
- "Networking opportunities" schedule  
- "Backup plan" schedule
Download each as separate CSV
```

---

## 🎨 Color Coding

| Color | Meaning |
|-------|---------|
| 🟢 Green row | Event selected |
| ⚪ White row | Not selected |
| 🟡 Yellow box | Information/warning |
| 🔵 Blue button | Primary action |
| 🟠 Orange button | Caution action |

---

## 📋 Workflow Example

**Goal**: Plan Tuesday schedule focusing on biodiversity topics

```
1. Filter: Day = "Tuesday"
   → Shows 66 events

2. Filter: Type = Check "oral" and "symposium"
   → Narrows to relevant formats

3. Browse and click interesting titles
   → 8 events selected

4. Check "Concurrent Events" for 2:00 PM
   → 3 options, pick best one

5. Go to "My Schedule"
   → Review, see 1 conflict at 3:00 PM

6. Fix conflict:
   → Go back, deselect one event

7. Generate "Mobile View"
   → Take screenshot

8. Download CSV
   → Import to Google Calendar
```

---

## 🆘 Troubleshooting

### Nothing happens when I click rows
- Make sure you're in "Browse Schedule" or "Concurrent Events" tab
- Try refreshing the browser
- Check R console for errors

### Selected events not showing in "My Schedule"
- They should appear automatically
- Try clicking "My Schedule" tab
- If empty, re-select events

### Can't see mobile view
- You must select at least 1 event first
- Click "Generate Mobile View" button in sidebar
- Or manually click "Mobile View" tab

### Filters not working
- Click inside the filter dropdown/checkbox
- Some combinations may return 0 results
- Try resetting to "All"

---

## 🎉 Ready to Start!

1. Launch: `source("start_app.R")`
2. Browse events
3. Select favorites  
4. Handle conflicts
5. Generate mobile view
6. Download schedule
7. Enjoy the conference!

---

**Questions? Check README.md for detailed documentation**

**Happy scheduling! 🗓️**
