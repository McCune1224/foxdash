# Phoenix FIT File Reader - Beginner-Friendly Project Guide

## 🎯 Project Goal
Build a fun Phoenix web app that lets you upload Garmin .fit files and see cool charts and stats about your workouts! This is a learning project to get comfortable with Phoenix, Elixir, and web development.

## 🚀 What We're Building
- A simple web page where you can drag-and-drop .fit files
- Some basic charts showing your heart rate, pace, and route
- A list of your uploaded activities
- Maybe some fun stats like "fastest mile" or "highest heart rate"

## 📚 What You'll Learn
- **Phoenix Framework**: How to build web apps with Elixir
- **File Uploads**: Handle user file uploads safely
- **Data Processing**: Parse binary files and extract useful information
- **Charts & Visualization**: Display data in a user-friendly way
- **Real-time Features**: Show progress while files are processing

## 🛠️ Simple Tech Stack
- **Phoenix** - The web framework (like Rails for Ruby)
- **PostgreSQL** - Database to store your workout data
- **LiveView** - Makes pages update automatically (no JavaScript needed!)
- **ExtFit** - Library that reads .fit files
- **Chart.js** - Simple charts for your data

## 📋 Step-by-Step Plan

### Phase 1: Get Started (Weekend 1)
**Goal: Get a Phoenix app running with file upload**

1. **Create the project**
   ```bash
   mix phx.new fit_reader --live
   cd fit_reader
   mix ecto.create
   ```

2. **Add basic file upload page**
   - One page where you can select a .fit file
   - Show "File uploaded!" message
   - Don't worry about processing yet

3. **Success criteria**: You can visit the app and upload a file

### Phase 2: Parse FIT Files (Weekend 2-3)
**Goal: Actually read the .fit file and show some basic info**

1. **Add ExtFit library** to mix.exs
2. **Create simple parser** that extracts:
   - Activity type (running, cycling, etc.)
   - Duration
   - Distance (if available)
   - Basic stats

3. **Success criteria**: Upload a file and see "Your 45-minute run covered 5.2 miles"

### Phase 3: Store Data (Weekend 4)
**Goal: Save activities to database so you can see them later**

1. **Create simple database table** for activities
2. **Save parsed data** after upload
3. **Show list of activities** on main page

3. **Success criteria**: Your activities are remembered between visits

### Phase 4: Make It Pretty (Weekend 5-6)
**Goal: Add charts and make it look nice**

1. **Add simple charts** showing:
   - Heart rate over time
   - Pace/speed over time
   - Maybe elevation if available

2. **Improve the design** with some CSS
3. **Success criteria**: You have pretty charts of your workout data!

## 📁 Simple Project Structure
```
lib/
  fit_reader/
    activities.ex          # Functions to save/load activities
    fit_parser.ex          # Parse .fit files
  fit_reader_web/
    live/
      activity_live.ex     # Main page showing activities
      upload_live.ex       # File upload page
```

## 🗃️ Basic Database Design
Keep it simple! Just one table to start:

```sql
-- activities table
CREATE TABLE activities (
  id SERIAL PRIMARY KEY,
  filename VARCHAR(255),
  sport VARCHAR(50),         -- "running", "cycling", etc.
  duration INTEGER,          -- seconds
  distance DECIMAL(8,2),     -- miles/km
  avg_heart_rate INTEGER,
  max_heart_rate INTEGER,
  calories INTEGER,
  uploaded_at TIMESTAMP DEFAULT NOW()
);
```

Later, if you want more detail, add a second table for the time-series data (heart rate every second, GPS points, etc.).

## 💡 Learning Tips

### Start Small
- Don't try to build everything at once
- Get one simple thing working, then add to it
- It's okay if your first version is ugly!

### Phoenix Learning Resources
- [Phoenix Guides](https://hexdocs.pm/phoenix/overview.html) - Official documentation
- [Programming Phoenix LiveView](https://pragprog.com/titles/liveview/programming-phoenix-liveview/) - Great book
- [Phoenix LiveView Examples](https://github.com/chrismccord/phoenix_live_view_example)

### When You Get Stuck
- Try the simpler approach first
- Google the error message
- Ask questions on [Elixir Forum](https://elixirforum.com/)
- Remember: every expert was once a beginner!

## 🎨 Fun Ideas to Add Later
Once you have the basics working, here are some fun additions:

- **Personal Records**: Track your best times/distances
- **Simple Maps**: Show where you ran/rode (if GPS data exists)
- **Activity Calendar**: See which days you worked out
- **Export Feature**: Download your data as CSV
- **Activity Comparison**: Compare two similar workouts
- **Simple Goals**: "You ran 3 times this week!"

## 🚨 Things to Keep Simple (For Now)
Don't worry about these until your basic app works:

- ~~Background job processing~~ → Process files immediately for now
- ~~Complex user authentication~~ → Maybe add later if you want
- ~~Advanced analytics~~ → Basic stats are fine to start
- ~~Mobile responsive design~~ → Desktop first is okay
- ~~Error handling~~ → Handle the happy path first, add error handling later

## 🔧 Basic Code Examples

### Simple FIT file parser
```elixir
defmodule FitReader.FitParser do
  def parse_file(file_path) do
    case ExtFit.parse(file_path) do
      {:ok, data} ->
        %{
          sport: extract_sport(data),
          duration: extract_duration(data),
          distance: extract_distance(data),
          heart_rate: extract_heart_rate(data)
        }
      
      {:error, _reason} ->
        {:error, "Could not read FIT file"}
    end
  end
  
  # Helper functions to extract data...
end
```

### Simple LiveView for upload
```elixir
defmodule FitReaderWeb.UploadLive do
  use FitReaderWeb, :live_view
  
  def mount(_params, _session, socket) do
    socket = allow_upload(socket, :fit_file, accept: ~w(.fit), max_entries: 1)
    {:ok, socket}
  end
  
  def handle_event("save", _params, socket) do
    # Process uploaded file
    # Save to database
    # Show success message
    {:noreply, socket}
  end
end
```

## 🎯 Success Milestones
- [ ] Phoenix app starts and I can visit it
- [ ] I can upload a .fit file without errors
- [ ] The app shows basic info about my workout
- [ ] Activities are saved and I can see a list
- [ ] I have at least one chart showing my data
- [ ] The app looks decent (not amazing, just decent!)

## 📖 What This Teaches You
By building this project, you'll learn:
- How Phoenix apps are structured
- Working with file uploads in web apps
- Processing binary data formats
- Basic database operations
- Creating interactive web pages with LiveView
- Turning raw data into user-friendly information

Remember: This is supposed to be fun! Don't stress if things don't work perfectly right away. Every time you fix a bug or add a feature, you're learning something new.

The goal isn't to build the next Strava - it's to build something cool that works and helps you understand Phoenix and Elixir better. Start simple, get it working, then make it better!