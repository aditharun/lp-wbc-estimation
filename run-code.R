system('Rscript estimate-wbc.R --br="3000000" --bw="46000" --zr="1500" --zw="60" --outfile="example.rds" ')
system('Rscript plot.R example.rds')