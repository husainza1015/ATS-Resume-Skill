---
name: ats-resume
description: Build or convert a resume/CV into a clean, ATS-friendly PDF using RenderCV (Python). Two modes — interview the user to build from scratch, or convert an existing Word/PDF resume into the ATS format. Use when someone wants to create a resume, make a resume ATS-friendly, reformat a CV, or mentions RenderCV / applicant tracking systems.
---

# ATS Resume Builder

Build a clean, single-column, **ATS-friendly** resume PDF from human-editable YAML using **RenderCV**. Two ways to start:

- **Build from scratch** — interview the user, then generate the resume.
- **Convert an existing resume** — read the user's Word/PDF and restructure it into the ATS format.

The source stays as a small YAML file, so future updates are a one-line change and a re-render.

> **ATS (Applicant Tracking System):** software employers use to parse and rank resumes. ATS parsers choke on multi-column layouts, tables, text boxes, headers/footers, and text-inside-images. This skill produces a single-column, selectable-text PDF that parses cleanly.

---

## 0. Prerequisites (one-time setup)

Verify the toolchain, install what's missing:

- **Python 3.10+** and `pip`.
- **RenderCV:** `pip install "rendercv[full]"` — bundles the Typst rendering engine (no LaTeX needed).
- **To read Word docs:** `pip install docx2txt` (or have `pandoc` available).

Confirm with `python -m rendercv --version`.

**Windows note:** before every `python -m rendercv ...` call, set `PYTHONIOENCODING=utf-8` — the default console encoding otherwise errors on RenderCV's ✓ output glyphs.

---

## 1. Choose the mode

Ask the user (or infer from context): are they **starting fresh**, or do they have an **existing resume** (Word/PDF) to convert? If they attach or point to a file, use **Convert mode (2B)**.

---

## 2A. Build from scratch — interview the user

Collect the following **conversationally, a few topics at a time** — don't dump 30 questions at once. Skip sections that don't apply.

1. **Header:** full name; a one-line professional headline/title; location (city/region — *not* a full street address); email; phone; relevant links (LinkedIn, GitHub, portfolio, and ORCID/Google Scholar for academics).
2. **Summary:** a 2–4 sentence professional summary. Offer to draft it from their experience and let them edit.
3. **Experience** (most recent first): for each role — title, company, location, start/end dates, and 3–6 bullets. Coach toward **quantified, outcome-first** bullets: *action verb → what you did → measurable impact*.
4. **Education:** degree, field, institution, location, dates.
5. **Skills:** grouped as `label → comma-separated list` (e.g., Languages, Frameworks, Tools, Domain).
6. **Optional sections** as relevant: projects, publications, patents, certifications, awards, volunteer work, talks.

Then write the YAML (Section 3) and render (Section 4).

---

## 2B. Convert an existing resume (Word/PDF)

1. **Extract the text.**
   - **PDF:** read it directly.
   - **Word (.docx):** `python -c "import docx2txt,sys; print(docx2txt.process(sys.argv[1]))" path.docx` (or `pandoc path.docx -t markdown`).
2. **Parse** into structured sections (header, summary, experience, education, skills, …).
3. **Integrity rules — never fabricate.** Preserve the user's facts exactly: dates, titles, employers, metrics, credentials. You **may** reorder to reverse-chronological, tighten wording, fix grammar, standardize formatting, and group skills. You **may not** invent achievements, numbers, tools, or credentials. If something is ambiguous or missing, **ask** — don't guess. If a claim looks inflated or inconsistent, surface it for the user to confirm rather than restating it.
4. **Map** the content into the YAML (Section 3) and render (Section 4).
5. **Report changes.** Give the user a short summary of substantive edits you made (reordering, rewording, anything dropped) so nothing changes silently.

---

## 3. Write the RenderCV YAML

Start from `examples/example.yaml` in this skill (copy it, then replace the content). The shape:

```yaml
cv:
  name: Full Name
  headline: One-line professional title
  location: City, Region
  email: name@email.com
  phone: +1-555-555-5555
  custom_connections:                 # clean header links (labels, not raw URLs)
    - fontawesome_icon: fa-brands fa-linkedin
      placeholder: LinkedIn
      url: https://www.linkedin.com/in/username/
  sections:
    summary:
      - One to three sentences. A lone string renders as a paragraph.
    experience:
      - company: Company
        position: Title
        location: City, Region
        start_date: 2021-03          # YYYY, YYYY-MM, or YYYY-MM-DD; end_date: present
        end_date: present
        highlights:
          - Action-verb bullet with a quantified outcome.
    education:
      - institution: University
        area: Field of Study
        degree: BS                   # or MS, PhD, etc.
        location: City, Region
        start_date: 2014
        end_date: 2018
    skills:
      - label: Languages
        details: Python, SQL, JavaScript
    # Optional: projects, publications, patents (see reference/rendercv-guide.md)
design:
  theme: engineeringresumes          # recommended: single-column, ATS-clean
  colors: { body: rgb(0,0,0), name: rgb(0,0,0), section_titles: rgb(0,0,0), links: rgb(0,0,0) }
  links: { underline: true, show_external_link_icon: false }
locale:
  language: english
settings:
  current_date: today                # auto-dates the "Last updated" footer
```

Section names under `cv.sections` are arbitrary labels; RenderCV infers the entry type from the fields you provide. See `reference/rendercv-guide.md` for every entry type (experience, education, publication, one-line, bullet, numbered) and the full design options. **Do not** add a `render_command:` block to the YAML (see Gotchas).

---

## 4. Render (PDF only)

Use the build script (it renders, names the PDF, and removes the non-PDF intermediates):

- **macOS/Linux:** `bash scripts/build_cv.sh resume.yaml "First_Last_Resume"`
- **Windows:** `pwsh scripts/build_cv.ps1 resume.yaml "First_Last_Resume"`

The second argument is the output filename (without `.pdf`); it defaults to `resume_<YYYY-MM>`.

Or render directly: `python -m rendercv render resume.yaml` → `rendercv_output/<Name>_CV.pdf` (plus Markdown/HTML/PNG/Typst copies you can ignore or delete).

---

## 5. Review and iterate

Inspect the PDF (or the page PNGs in `rendercv_output/`). Check: header fits on one line, dates align, no overflow, sensible page breaks. One page is ideal for early-career; two+ is fine for senior/academic profiles. Edit the YAML and re-run the build. Keep iterating with the user until they approve.

---

## ATS best practices (apply by default)

- **Single column.** No tables, text boxes, or multi-column layouts.
- **Standard section headings:** Experience, Education, Skills, Projects, Publications.
- **Selectable text only** — never put words inside images.
- **Standard fonts, minimal color** (the default theme is near-monochrome — good).
- **Keywords + acronyms:** spell out then abbreviate on first use, e.g., "Applicant Tracking System (ATS)"; mirror the job description's terminology where it's truthful.
- **Reverse-chronological**, action-verb-first bullets, **quantified** impact.
- **Deliver as PDF** with selectable text (this skill does that).

---

## Gotchas

- **Never add a `render_command:` block to the YAML.** It silently breaks RenderCV (prints "Rendering…", writes nothing, exits 0). Control PDF-only output via the build script instead.
- **Windows:** always set `PYTHONIOENCODING=utf-8` before rendering.
- **Header links:** use `custom_connections` for clean "LinkedIn" / "GitHub" / "Google Scholar" labels rather than long raw URLs (which can wrap the header onto a second line). Built-in `social_networks` work too but display the URL/username.
- **Themes:** `engineeringresumes` is the recommended ATS-clean default; `classic`, `sb2nov`, `moderncv`, and `engineeringclassic` are alternatives.
- `current_date: today` auto-updates the "Last updated" footer on every render.
- Keep the YAML as the source of truth and commit it; the PDF is a build artifact.
