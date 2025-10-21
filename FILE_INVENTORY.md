# Living Data 2025 - File Inventory

## 📦 Complete Package Contents

### Core Application Files

1. **app.R** (12 KB)
   - Main R Shiny application
   - Interactive schedule builder
   - 4 tabs: Browse, Concurrent Events, My Schedule, Mobile View
   - Automatic conflict detection
   - CSV download functionality

2. **start_app.R** (2 KB)  
   - Quick launch script
   - Automatically installs required packages
   - One-click app startup
   - **USE THIS to get started!**

### Data Files

3. **living_data_schedule.csv** (37 KB)
   - Complete conference schedule
   - 273 events across 4 days
   - Fields: id, title, time_beg, time_end, date, day, location, type, speaker, session_id
   - Ready to import into any spreadsheet or database

4. **living_data_schedule.json** (84 KB)
   - Same data in JSON format
   - For developers and custom applications

### Documentation

5. **README.md** (6 KB)
   - Complete documentation
   - Feature descriptions
   - Installation instructions
   - Troubleshooting guide
   - Conference information

6. **QUICKSTART.md** (2 KB)
   - Get started in 3 steps
   - Essential tips
   - Common issues solved
   - **READ THIS FIRST!**

7. **SCHEDULE_PREVIEW.txt** (2 KB)
   - Sample of the CSV data
   - Shows data structure
   - Quick reference

8. **FILE_INVENTORY.md** (This file)
   - Complete file listing
   - Size information
   - Usage instructions

### Examples

9. **sample_mobile_schedule.html** (varies)
   - Example mobile-friendly schedule output
   - Shows what the app generates
   - Can be customized and styled
   - Open in any web browser

---

## 🎯 What Each File Does

| File | Purpose | When to Use |
|------|---------|-------------|
| start_app.R | Launch the app | First time & every time! |
| app.R | The actual application | Auto-launched by start_app.R |
| living_data_schedule.csv | Schedule data | App needs this in same folder |
| QUICKSTART.md | Getting started | Read before anything else |
| README.md | Full documentation | When you need details |
| sample_mobile_schedule.html | Example output | See what you'll get |

---

## ✅ Setup Checklist

- [ ] All 9 files in the same folder
- [ ] R installed (version 4.0+)
- [ ] RStudio installed (optional but recommended)
- [ ] Double-checked file locations
- [ ] Ready to run start_app.R

---

## 🚀 Next Steps

1. Put all files in one folder
2. Open R or RStudio
3. Run: `source("start_app.R")`
4. Start building your schedule!

---

## 📊 Data Overview

**Conference**: Living Data 2025  
**Location**: Bogotá, Colombia  
**Dates**: October 21-24, 2025  
**Total Events**: 273

**Breakdown**:
- Tuesday: 66 events
- Wednesday: 73 events
- Thursday: 94 events  
- Friday: 40 events

**Event Types**:
- Oral presentations (264)
- Workshops (3)
- Lightning talks (3)
- Symposia (2)
- Panel (1)

**Locations**: Multiple rooms and venues
- Ballroom (A, B1, B2)
- Regional rooms (Caldas, Cauca, Tolima, Valle, Huila)
- And more...

---

## 🔗 Useful Links

- Conference website: https://www.livingdata2025.com
- Full program: https://www.livingdata2025.com/program.html
- Abstract URL pattern: https://www.livingdata2025.com/program.html?abstract={ID}

---

## 💡 Pro Tips

1. **Keep files together**: All files must be in the same folder
2. **Use start_app.R**: Easiest way to launch
3. **Check the sample**: Look at sample_mobile_schedule.html to see output
4. **Bookmark abstracts**: App provides direct links
5. **Export early**: Download your schedule before the conference starts

---

**All set! Run start_app.R and enjoy the conference! 🎉**

