# Weekend 1: Get Your Phoenix FIT Reader Started! 

## 🎯 This Weekend's Goal
By Sunday evening, you'll have a working Phoenix app that can accept .fit file uploads. That's it! Simple but exciting.

## ⏱️ Time Estimate: 3-4 hours

## 🛠️ Prerequisites
- Elixir installed ([Installation Guide](https://elixir-lang.org/install.html))
- PostgreSQL running locally
- A code editor (VS Code is great for beginners)
- One .fit file from your Garmin watch (or download a sample online)

## 📋 Step-by-Step Tutorial

### Step 1: Create Your Phoenix Project (15 minutes)
```bash
# Create the project
mix phx.new fit_reader --live
cd fit_reader

# Install dependencies
mix deps.get

# Create your database
mix ecto.create

# Start the server to make sure it works
mix phx.server
```

Visit http://localhost:4000 - you should see the Phoenix welcome page! 🎉

### Step 2: Add ExtFit Dependency (5 minutes)
In `mix.exs`, add ExtFit to your dependencies:

```elixir
defp deps do
  [
    # ... existing dependencies ...
    {:ext_fit, "~> 0.1.0"}   # Add this line
  ]
end
```

Then run:
```bash
mix deps.get
```

### Step 3: Create Your First LiveView (30 minutes)
Create `lib/fit_reader_web/live/upload_live.ex`:

```elixir
defmodule FitReaderWeb.UploadLive do
  use FitReaderWeb, :live_view

  def mount(_params, _session, socket) do
    socket = 
      socket
      |> assign(:message, "Upload a .fit file to get started!")
      |> assign(:uploaded_files, [])
      |> allow_upload(:fit_files, 
           accept: ~w(.fit), 
           max_entries: 1, 
           max_file_size: 10_000_000)  # 10MB limit

    {:ok, socket}
  end

  def handle_event("validate", _params, socket) do
    # This runs when user selects a file
    {:noreply, socket}
  end

  def handle_event("upload", _params, socket) do
    # This runs when user clicks upload button
    uploaded_files = 
      consume_uploaded_entries(socket, :fit_files, fn %{path: path}, entry ->
        # For now, just save the filename
        {:ok, %{name: entry.client_name, size: entry.client_size}}
      end)

    message = case uploaded_files do
      [] -> "No files uploaded"
      files -> "Uploaded: #{Enum.map(files, & &1.name) |> Enum.join(", ")}"
    end

    socket = 
      socket
      |> assign(:message, message)
      |> assign(:uploaded_files, uploaded_files)

    {:noreply, socket}
  end
end
```

### Step 4: Create the Template (20 minutes)
Create `lib/fit_reader_web/live/upload_live.html.heex`:

```heex
<div class="max-w-2xl mx-auto mt-10 p-6">
  <h1 class="text-3xl font-bold text-gray-900 mb-8">FIT File Reader</h1>
  
  <div class="bg-white shadow-md rounded-lg p-6">
    <h2 class="text-xl font-semibold mb-4">Upload Your Garmin File</h2>
    
    <form id="upload-form" phx-submit="upload" phx-change="validate">
      <div class="mb-4">
        <.live_file_input upload={@uploads.fit_files} class="block w-full text-sm text-gray-500 file:mr-4 file:py-2 file:px-4 file:rounded-full file:border-0 file:text-sm file:font-semibold file:bg-blue-50 file:text-blue-700 hover:file:bg-blue-100" />
        
        <!-- Show any upload errors -->
        <%= for entry <- @uploads.fit_files.entries do %>
          <%= for err <- upload_errors(@uploads.fit_files, entry) do %>
            <p class="mt-2 text-red-600 text-sm"><%= error_to_string(err) %></p>
          <% end %>
        <% end %>
      </div>
      
      <button type="submit" 
              class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded"
              disabled={@uploads.fit_files.entries == []}>
        Upload and Process
      </button>
    </form>

    <!-- Show upload status -->
    <div class="mt-6 p-4 bg-gray-100 rounded">
      <p class="font-medium text-gray-700"><%= @message %></p>
      
      <!-- Show uploaded files -->
      <%= for file <- @uploaded_files do %>
        <div class="mt-2 text-sm text-gray-600">
          📁 <%= file.name %> (<%= format_bytes(file.size) %>)
        </div>
      <% end %>
    </div>
  </div>
</div>
```

### Step 5: Add Helper Functions (10 minutes)
Add these helper functions at the bottom of your `upload_live.ex`:

```elixir
# Add these private functions to your UploadLive module

defp error_to_string(:too_large), do: "File too large (max 10MB)"
defp error_to_string(:not_accepted), do: "Only .fit files allowed"
defp error_to_string(:too_many_files), do: "Only one file at a time"
defp error_to_string(err), do: "Upload error: #{err}"

defp format_bytes(bytes) do
  cond do
    bytes >= 1_000_000 -> "#{Float.round(bytes / 1_000_000, 1)} MB"
    bytes >= 1_000 -> "#{Float.round(bytes / 1_000, 1)} KB"
    true -> "#{bytes} bytes"
  end
end
```

### Step 6: Add the Route (5 minutes)
In `lib/fit_reader_web/router.ex`, replace the existing scope with:

```elixir
scope "/", FitReaderWeb do
  pipe_through :browser

  live "/", UploadLive, :index  # Change this line
end
```

### Step 7: Test It Out! (15 minutes)
1. Start your server: `mix phx.server`
2. Visit http://localhost:4000
3. Try uploading a .fit file
4. You should see the filename appear after upload!

## 🎉 Success! What You've Accomplished

- ✅ Created a working Phoenix LiveView app
- ✅ Handled file uploads with validation
- ✅ Built a responsive web interface
- ✅ Used real-time updates (LiveView magic!)
- ✅ Processed user interactions without writing JavaScript

## 🐛 Common Issues & Fixes

### "Mix phx.new not found"
- Make sure Elixir is installed: `elixir --version`
- Install Phoenix: `mix archive.install hex phx_new`

### "Database connection failed"
- Make sure PostgreSQL is running
- Check your database config in `config/dev.exs`
- Try creating the database manually: `createdb fit_reader_dev`

### "File upload not working"
- Check the file extension is `.fit`
- Make sure file is under 10MB
- Try a different .fit file

### "Page looks weird"
- Phoenix includes Tailwind CSS by default
- If styles aren't working, try: `mix assets.deploy`

## 🚀 Next Weekend: Parse the FIT File!

This weekend was about getting the basic plumbing working. Next weekend, we'll make it actually read the .fit file and show you some stats about your workout!

Here's a sneak peek of what we'll add:
```elixir
# Coming next weekend...
def parse_fit_file(file_path) do
  case ExtFit.parse(file_path) do
    {:ok, data} -> 
      %{
        sport: "running",           # We'll extract this from the file
        duration: 2847,             # seconds
        distance: 5.2,              # miles
        avg_heart_rate: 152         # beats per minute
      }
    {:error, _} -> 
      {:error, "Could not read file"}
  end
end
```

## 💡 What You Learned

- **Phoenix Project Structure**: How Phoenix organizes files
- **LiveView Basics**: Real-time web pages without JavaScript
- **File Uploads**: Handling user file uploads safely
- **Pattern Matching**: Basic Elixir syntax with `case` statements
- **Debugging**: How to read error messages and fix them

You're doing great! Building web applications is complex, but you just created something that actually works. That's a real accomplishment! 

Take a screenshot of your working upload page - you built that! 📸

## 📚 Optional Reading

If you want to understand more about what you just built:
- [Phoenix LiveView Docs](https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.html)
- [File Uploads Guide](https://hexdocs.pm/phoenix_live_view/uploads.html)
- [Elixir Pattern Matching](https://elixir-lang.org/getting-started/pattern-matching.html)

But honestly? You can dive into that later. For now, just enjoy the fact that you have a working Phoenix app! 🎊