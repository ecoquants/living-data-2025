# Living Data 2025 - Quick Start Guide

## 🚀 Get Started in 3 Steps

### Step 1: Open R or RStudio

Make sure you have R installed on your computer. If not, download it from: https://www.r-project.org/

### Step 2: Run the Start Script

**Option A: Double-click**
- On Windows: Double-click `start_app.R`
- On Mac/Linux: Open terminal, navigate to folder, run: `Rscript start_app.R`

**Option B: From R Console**
```r
source("start_app.R")
```

### Step 3: Use the App

The app will open in your browser automatically. Start selecting sessions!

---

## 📱 What You'll Get

### 4 Main Features:

1. **Browse Schedule** 📅
   - All 273 conference events
   - Filter by day, location, type
   - Click to select

2. **Concurrent Events** ⏰
   - See what's happening at the same time
   - Make choices between competing sessions

3. **My Schedule** ✅
   - Your personalized agenda
   - Conflict detection
   - Download as CSV

4. **Mobile View** 📱
   - Clean, phone-friendly display
   - Perfect for using at the conference
   - Links to all abstracts

---

## 💾 Files You Have

- `app.R` - The Shiny application
- `living_data_schedule.csv` - Complete schedule (273 events)
- `living_data_schedule.json` - Schedule in JSON format
- `start_app.R` - Quick launch script (use this!)
- `sample_mobile_schedule.html` - Example of mobile output
- `README.md` - Full documentation
- `QUICKSTART.md` - This file

---

## 🎯 Quick Tips

✅ **DO**: Select events as you browse
✅ **DO**: Use "Concurrent Events" to resolve time conflicts  
✅ **DO**: Generate mobile view before the conference
✅ **DO**: Download your schedule as backup

❌ **DON'T**: Forget to check the conflicts tab
❌ **DON'T**: Schedule back-to-back without breaks
❌ **DON'T**: Miss the plenary sessions!

---

## 🆘 Need Help?

**App won't start?**
```r
# Install packages manually:
install.packages(c("shiny", "DT", "dplyr", "tidyr", 
                   "readr", "lubridate", "stringr", "bslib"))
```

**Still stuck?**
- Check that all files are in the same folder
- Make sure you're using R version 4.0 or later
- Try opening `app.R` directly in RStudio

---

## 📊 Schedule Stats

- **273 total events**
- **4 days** (Oct 21-24)
- **Multiple tracks** running simultaneously
- **Various formats**: Oral, Symposia, Workshops, Panels

---

**Ready? Run `start_app.R` and start planning! 🎉**

Conference website: https://www.livingdata2025.com
