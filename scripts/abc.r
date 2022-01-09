library("arrow")
library("abc")
library("optparse")



main <- function(opt){
    print(opt)
    df_true_ss <- read_f(input=opt$df_true_ss)
    df_simu_space_knn_params <- read_f(input=opt$df_simu_space_knn_params)
    df_simu_space_knn_ss <- read_f(input=opt$df_simu_space_knn_ss)
    df_knn <- abc(
        target = df_true_ss,
        param = df_simu_space_knn_params, 
        sumstat = df_simu_space_knn_ss, 
        tol = 1, 
        method = opt$reg_model, 
        transf = opt$transf, 
        hcorr = opt$hcorr, 
        kernel = opt$kernel, 
        sizenet = 1)$adj.values
    write_f(df=df_knn, output=opt$output)
}


read_f <- function(input) {
    print(input)
    df <- read_feather(file = input, as_data_frame = TRUE)
    print(dim(df))
    return(df)
}


write_f <- function(df, output) {
    write_feather(x = as.data.frame(df),sink = output, version=2)
}


option_list = list(
    make_option("--reg_model", type="character", default=NULL,help="--reg_model", metavar="character"),
    make_option("--hcorr", type="character", default=NULL,  help="--hcorr", metavar="character"),
    make_option("--kernel", type="character", default=NULL, help="--kernel", metavar="character"),
    make_option("--transf", type="character", default=NULL, help="--transf", metavar="character"),
    make_option("--output", type="character", default=NULL, help="--output", metavar="character"),
    make_option("--df_true_ss", type="character", default=NULL, help="--df_true_ss", metavar="character"),
    make_option("--df_simu_space_knn_params", type="character", default=NULL,  help="--df_simu_space_knn_params", metavar="character"),
    make_option("--df_simu_space_knn_ss", type="character", default=NULL, help="--df_simu_space_knn_ss", metavar="character")
)
opt_parser = OptionParser(option_list=option_list)
opt = parse_args(opt_parser)

if (is.null(opt$reg_model)){
  print_help(opt_parser)
   stop("", call.=FALSE)
}

main(opt=opt)





