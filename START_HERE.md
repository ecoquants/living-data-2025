# 🎯 Living Data 2025 - START HERE!

## Welcome! 👋

You now have a complete conference schedule system with an interactive R Shiny app.

---

## ⚡ Quick Start (30 seconds)

1. **Make sure all files are in one folder** ✓
2. **Open R or RStudio**
3. **Run this command:**
   ```r
   source("start_app.R")
   ```
4. **App opens in browser** → Start selecting events!

---

## 📚 Documentation Guide

Read files in this order:

```
1. START_HERE.md ← You are here!
2. QUICKSTART.md (2 min read)
3. Start using the app
4. USAGE_GUIDE.md (when you need help)
5. README.md (full reference)
```

---

## 📦 What You Have

### Essential Files
- ✅ `start_app.R` - Launch script
- ✅ `app.R` - The Shiny application  
- ✅ `living_data_schedule.csv` - Complete schedule (273 events)

### Documentation
- 📖 `QUICKSTART.md` - Get started in 3 steps
- 📖 `USAGE_GUIDE.md` - Detailed app walkthrough
- 📖 `README.md` - Full documentation
- 📖 `FILE_INVENTORY.md` - What each file does

### Examples & Data
- 📄 `living_data_schedule.json` - Data in JSON format
- 🌐 `sample_mobile_schedule.html` - Example output
- 📊 `SCHEDULE_PREVIEW.txt` - Sample data

---

## 🎓 What This App Does

### 4 Powerful Features:

**1. Browse Schedule** 📅
- View all 273 conference events
- Filter by day, location, type
- Click rows to select

**2. Concurrent Events** ⏰  
- See what's happening simultaneously
- Choose between competing sessions
- Automatic conflict resolution

**3. My Schedule** ✅
- Your personalized agenda
- Conflict warnings
- Download as CSV

**4. Mobile View** 📱
- Phone-friendly display
- Perfect for use at conference
- Links to all abstracts

---

## 📊 Conference Overview

**Living Data 2025**
- 📍 Bogotá, Colombia
- 📅 October 21-24, 2025
- 🎤 273 events
- 🏢 Multiple venues
- 🌐 Four networks, one conference

**Event Breakdown:**
- Tuesday: 66 events
- Wednesday: 73 events
- Thursday: 94 events
- Friday: 40 events

**Types:**
- Oral presentations (264)
- Symposia (2)
- Workshops (3)
- Lightning talks (3)
- Panel (1)

---

## 🎯 Your Mission

Build the perfect conference schedule:
1. ✅ Select events you want to attend
2. ✅ Resolve time conflicts  
3. ✅ Generate mobile-friendly view
4. ✅ Download your schedule
5. ✅ Enjoy the conference!

---

## 🆘 Need Help?

**Can't launch app?**
```r
# Install packages first:
install.packages(c("shiny", "DT", "dplyr", "tidyr", 
                   "readr", "lubridate", "stringr", "bslib"))

# Then launch:
source("start_app.R")
```

**Still stuck?**
- Check QUICKSTART.md
- Read USAGE_GUIDE.md
- Verify all files are in same folder
- Make sure R version 4.0+

---

## 🔗 Useful Links

- 🌐 Conference: https://www.livingdata2025.com
- 📋 Full Program: https://www.livingdata2025.com/program.html
- 📧 Questions: info@livingdata2025.com

---

## ✨ Special Features

### Smart Conflict Detection
The app automatically warns you if you've selected overlapping events.

### Abstract Links
Every event links directly to its full abstract:
```
https://www.livingdata2025.com/program.html?abstract={ID}
```

### Multiple Export Options
- CSV for spreadsheets
- Mobile HTML view
- Printable schedules

### Offline Ready
Generate mobile view before conference → Use without internet!

---

## 🎉 Ready? Let's Go!

```r
# Copy/paste this into R:
source("start_app.R")
```

**That's it! The app will open automatically.**

---

## 💡 Pro Tips

1. ⭐ Select generously first, narrow down later
2. 🕐 Use "Concurrent Events" to compare time slots
3. 📱 Screenshot your mobile view for offline access
4. 💾 Download CSV as backup
5. 🗓️ Import CSV into your calendar app

---

## 🎊 About Living Data 2025

Four networks, one conference:
- **TDWG** - Biodiversity Information Standards
- **OBIS** - Ocean Biodiversity Information System
- **GEO BON** - Group on Earth Observations Biodiversity Observation Network
- **GBIF** - Global Biodiversity Information Facility

Hosted by: Instituto Humboldt Colombia 🇨🇴

---

**Questions? Check README.md**

**Ready to build your schedule? Run start_app.R!**

**See you at the conference! 🚀**

