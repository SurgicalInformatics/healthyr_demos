#!/bin/bash
# changing name of output file, need to add both --to and --put arguments
quarto render 08_exporting.qmd --to pdf --output exporting.pdf
# render teacher version
quarto render 08_exporting.qmd --to pdf --output exporting_teacher.pdf --profile teacher
