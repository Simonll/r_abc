library("arrow")
library("abc")
library("optparse")

method = "loclinear"
transf = "none"
hcorr  = "TRUE"
kernel = "epanechnikov"

option_list = list(
    make_option("--reg_model", type="character", default=NULL,help="--reg_model", metavar="character"),
    make_option("--method", type="character", default=NULL, help="--method", metavar="character"),
    make_option("--hcorr", type="character", default=NULL,  help="--hcorr", metavar="character"),
    make_option("--kernel", type="character", default=NULL, help="--kernel", metavar="character"),
    make_option("--transf", type="character", default=NULL, help="--transf", metavar="character"),
    make_option("--df_true_ss", type="character", default=NULL, help="--df_true_ss", metavar="character"),
    make_option("--df_simu_space_knn_params", type="character", default=NULL,  help="--df_simu_space_knn_params", metavar="character"),
    make_option("--df_simu_space_knn_ss", type="character", default=NULL, help="--df_simu_space_knn_ss", metavar="character"),
    make_option("--output_dir", type="character", default=NULL, help="--output_dir", metavar="character")
)
 
opt_parser = OptionParser(option_list=option_list)
opt = parse_args(opt_parser)

if (is.null(opt$reg_model)){
  print_help(opt_parser)
   stop("", call.=FALSE)
}

main <- function(opt){
    df_knn <- abc(
        target = read_f(filename=opt$df_true_ss),
        param = read_f(filename=opt$df_simu_space_knn_params), 
        sumstat = read_f(filename=opt$df_simu_space_knn_ss), 
        tol = 1, 
        method = opt$method, 
        transf = opt$transf, 
        hcorr = opt$hcorr, 
        kernel = opt$kernel, 
        sizenet = 1)$adj.values

    write_feather(x=as.data.frame(df_knn),sink = paste0("/data/", "df_knn.feather",version = 2))
}

read_f <- function(filename) {

    df <- as.data.frame(read_feather(paste0("/data/", filename)))
    return df

}

