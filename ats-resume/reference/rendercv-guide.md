# RenderCV reference (for the ats-resume skill)

A condensed map of the RenderCV input format. The canonical, version-pinned schema is referenced at the top of every input file:
`# yaml-language-server: $schema=https://raw.githubusercontent.com/rendercv/rendercv/refs/tags/v2.8/schema.json`

To regenerate a fresh, fully-commented starter at any time:
`PYTHONIOENCODING=utf-8 python -m rendercv new "Full Name" --theme engineeringresumes`

## Top-level keys

```yaml
cv:        { ... }   # the content (required)
design:    { ... }   # theme + look
locale:    { ... }   # language / date words
settings:  { ... }   # current_date, pdf_title, bold_keywords
```

## cv

- `name`, `headline`, `location`, `email`, `phone`, `photo` (omit for ATS).
- `social_networks:` — list of `{ network, username }`. Valid networks include: LinkedIn, GitHub, GitLab, ORCID, Google Scholar, ResearchGate, StackOverflow, YouTube, X, Instagram, Telegram, Mastodon. URLs are built automatically (e.g. Google Scholar username = the `user=` id).
- `custom_connections:` — list of `{ fontawesome_icon, placeholder, url }`. Use these for **clean header labels** ("LinkedIn", "Google Scholar") instead of long raw URLs. `placeholder` is the visible text.
- `sections:` — a map of `Section Title: [entries]`. Titles are arbitrary; RenderCV infers each entry's **type** from the fields present.

## Entry types (inferred from fields)

| Type | Use for | Key fields |
|---|---|---|
| **ExperienceEntry** | jobs, consulting | `company`, `position`, `start_date`, `end_date`, `location`, `summary`, `highlights` |
| **EducationEntry** | degrees | `institution`, `area`, `degree`, `start_date`, `end_date`, `location`, `highlights` |
| **NormalEntry** | generic dated items, projects | `name`, `start_date`/`end_date` or `date`, `location`, `summary`, `highlights` |
| **PublicationEntry** | papers | `title`, `authors` (list), `journal`, `date`, `doi`, `url` |
| **OneLineEntry** | skills | `label`, `details` |
| **BulletEntry** | plain bullets | `bullet` |
| **NumberedEntry** | numbered list | `number` |
| **ReversedNumberedEntry** | reverse-numbered | `reversed_number` |
| **TextEntry** | a paragraph | a bare string item (e.g. a summary) |

**Dates:** `YYYY`, `YYYY-MM`, or `YYYY-MM-DD`; `end_date: present` for ongoing. Year-only renders as "2019 – 2023"; month precision renders "Jun 2019 – Aug 2023".

**Authors:** in a publication's `authors` list, wrap the subject's name in asterisks to emphasize it (`'*Last F*'`). To compress a long list cleanly, use an ellipsis element rather than a mid-list "et al.": `['First A', 'Second B', '...', '*Subject S*', 'et al.']`.

## design

```yaml
design:
  theme: engineeringresumes        # ATS-clean default. Others: classic, sb2nov, moderncv, engineeringclassic
  page: { size: us-letter }        # or a4
  colors:                          # set all to rgb(0,0,0) for monochrome/ATS
    body: rgb(0, 0, 0)
    name: rgb(0, 0, 0)
    headline: rgb(0, 0, 0)
    connections: rgb(0, 0, 0)
    section_titles: rgb(0, 0, 0)
    links: rgb(0, 0, 0)
  links: { underline: true, show_external_link_icon: false }
  section_titles: { type: with_full_line }   # underlined section headers
  header: { alignment: center }
```

Run `python -m rendercv new "Name" --theme engineeringresumes` and read the generated file to see every available design option (typography, spacing, entry templates) as commented YAML.

## settings

```yaml
settings:
  current_date: today              # auto-dates the "Last updated" footer; or a fixed 'YYYY-MM-DD'
  pdf_title: Full Name - Resume
  bold_keywords: []                # words to auto-bold across the document
```

**Do NOT add a `render_command:` block here.** In RenderCV 2.8 its presence silently breaks `python -m rendercv render` (it prints "Rendering…", writes no files, and exits 0). Control output (PDF-only, custom filename) with the build scripts in `scripts/` instead.

## Rendering outputs

`python -m rendercv render input.yaml` creates `rendercv_output/` containing the PDF **plus** Markdown, HTML, PNG (one per page), and Typst copies. The build scripts copy the PDF out under your chosen name and delete the rest.

## Common pitfalls

- Windows console: export `PYTHONIOENCODING=utf-8` first.
- Long raw URLs in the header can wrap to a second line — prefer `custom_connections` labels.
- A bare string under a section becomes a paragraph (good for summaries); a `{label, details}` becomes a one-line skill row.
- Keep the YAML in version control; treat the PDF as a build artifact.
