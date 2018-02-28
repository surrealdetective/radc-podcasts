# radc-podcasts
Everything you need need to edit radc podcasts.

## Contents
* See unedited audio clips
* Identify what needs editing
* Editing instructions & resources
# Publishing instructions

## See unedited audio clips
```
// open terminal app
git clone git@github.com:surrealdetective/radc-podcasts.git radc-podcasts
cd radc-podcasts
ruby make-list--unedited.rb
cat list--unedited.md
```

## Identify what needs editing

To view only unedited files & manually claimed files:
```
ruby make-list--unedited.rb
cat list--unedited.md
cat list--claimed.md
```
* Notation notes: [] means the file still needs editing; [x] means file is edited

Or you can view all files & manually claimed files:
```
ruby make-list--unedited.rb
cat list--all.md
cat list-claimed.md
```

## Editing instructions & resources
1. Identify a file to edit. Prefer later clips to earlier ones or w/e is of personal interest.
2. Share your claim (file name, date, your name) so others don't edit the same file
  a. First find your file name
  ```
  ls 008-gen-
  // press tab to autocomplete 
  ls meetings/001-gen-model-minority-myth-pre-1940s/unedited/001-
  // press tab to autocomplete
  ```
  b. Next copy and paste that line
  (higlight meetings/001-gen-model-minority-myth-pre-1940s/unedited/001-recap-coolies-vs-upstanding.mp3)

  c. Record that you're working on this
  ```
  echo "alex 2/28/2018 meetings/001-gen-model-minority-myth-pre-1940s/unedited/001-recap-coolies-vs-upstanding.mp3" >> list-claimed.md
  ```
3. Open the open-and-closer.aud file in /edit-resources with audacity
4. Save the file on your local computer outside of the radc-podcasts folder (audacity files are just too big, we don't need it, we can always edit the mp3 directly, even if you don't finish editing as long as you export)
5. Edit the discussion using these instructions:
6. Export the audio file as an mp3 to the appropriate place: meetings/[meeting-folder]/edited/[001]-[your-description-of-the-file].mp3 (Important: remember to use the 001 convention. You can call the file w/e you like, but the num is used to update what needs to be edited. Please rename any files that don't match this convention if you come across them)
7. Edit list-claimed.md so that you remove your claim.
## Publishing instructions