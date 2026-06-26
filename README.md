# ATS Resume Builder — a Claude Code skill

A [Claude Code](https://claude.com/claude-code) skill that turns a conversation (or an existing Word/PDF resume) into a clean, **ATS-friendly** resume PDF — single-column, selectable text, standard headings, no tables or graphics that break applicant-tracking parsers.

It runs on [**RenderCV**](https://github.com/rendercv/rendercv): your resume lives as a small YAML file and renders to a typeset PDF. Updating it later is a one-line edit and a re-render.

## What it does

Two modes — Claude picks based on what you give it:

- **Build from scratch.** Claude interviews you (contact, summary, experience, education, skills, …) and writes the resume, coaching you toward quantified, outcome-first bullets.
- **Convert an existing resume.** Point Claude at your `.docx` or `.pdf`; it extracts the content, restructures it into the ATS format, and **never invents facts** — it preserves your dates, titles, and metrics, and asks when something's unclear.

Output is a single PDF with selectable text that ATS software can parse.

## Install

Copy the `ats-resume/` folder into your skills directory:

```bash
# user-level (available in every project)
cp -r ats-resume ~/.claude/skills/

# or project-level
mkdir -p .claude/skills && cp -r ats-resume .claude/skills/
```

One-time toolchain (Claude can also do this for you):

```bash
pip install "rendercv[full]"   # bundles the Typst engine; no LaTeX needed
pip install docx2txt           # only needed for converting Word docs
```

## Use

In Claude Code, just ask:

- “Help me build a resume.”
- “Convert this resume to an ATS-friendly version.” *(attach or point to your .docx/.pdf)*
- Or invoke it directly: `/ats-resume`

Claude follows the skill, writes a `resume.yaml`, and renders it:

```bash
bash ats-resume/scripts/build_cv.sh resume.yaml "First_Last_Resume"     # macOS/Linux
pwsh ats-resume/scripts/build_cv.ps1 resume.yaml "First_Last_Resume"    # Windows
```

You get `First_Last_Resume.pdf`. Edit the YAML and re-run to update.

## What's in here

```
ats-resume/
├── SKILL.md                     # the skill (instructions Claude follows)
├── scripts/
│   ├── build_cv.sh              # render → PDF only (macOS/Linux)
│   └── build_cv.ps1             # render → PDF only (Windows)
├── reference/
│   └── rendercv-guide.md        # condensed RenderCV format reference
└── examples/
    └── example.yaml             # a complete, fictional sample to copy from
```

## Notes

- **ATS-friendly by design:** single column, standard section titles, selectable text, minimal color, reverse-chronological, quantified bullets.
- Your YAML is the source of truth — commit it; the PDF is a build artifact.
- Themes: `engineeringresumes` (default, ATS-clean) plus `classic`, `sb2nov`, `moderncv`.
- Windows: scripts set `PYTHONIOENCODING=utf-8` for you.

## Credits & license

Built on [RenderCV](https://github.com/rendercv/rendercv) (MIT). This skill is released under the [MIT License](LICENSE). Not affiliated with the RenderCV project or any ATS vendor.
