# Build Your First AI Project in 60 Minutes: Growth Challenge Asset

Landing page + referral tracker for a free workshop aimed at 500 final-year engineering students.

## Features
- Registration form with phone validation and duplicate blocking
- Personal referral code and ready-to-send WhatsApp message generator
- Live progress bar toward 500 registrations
- Referrer and college leaderboard

## Run locally
Open `index.html` in a browser. No build step.

## Deploy
Vercel: import this repo, framework preset "Other", no build command, output directory `.`

## Backend (Supabase, free tier)
1. Create a project at supabase.com.
2. SQL Editor: paste and run `supabase.sql`.
3. Project Settings > API: copy the Project URL and the `anon` public key into `SUPA_URL` and `SUPA_KEY` at the top of the script in `index.html`.
4. Commit, push, and Vercel redeploys.

Registrations then persist in the database. Phone numbers are not readable from the browser; the page only calls three functions (`register`, `create_code`, `stats`). Until the keys are filled in, the page falls back to browser storage.
