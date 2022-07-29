# Report

The report was written using LaTex, and the source can be compiled into the report by using the following command.

```
pdflatex main.tex
bibtex main
# Additional calls to fix the references
pdflatex main.tex
pdflatex main.tex
```

> **Note**: `pdflatex` is required to build the report, and is bundled with `texlive`.
