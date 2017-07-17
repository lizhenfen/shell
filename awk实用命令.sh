不打印第一行数据:
    awk -F' ' 'NR>1{print }'
    
打印最后一列:
    awk -F' ' '{print $NF}'