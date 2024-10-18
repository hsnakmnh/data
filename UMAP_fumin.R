
# 加载必要的库
library(SingleCellExperiment)
library(ggplot2)
library(RColorBrewer)

# 提取 UMAP 降维数据
umap_data <- reducedDim(sce, "X_umap")

# 将 UMAP 降维数据转换为数据框
umap_df <- as.data.frame(umap_data)
colnames(umap_df) <- c("UMAP1", "UMAP2")

# 从 colData 中提取 celltype 信息
celltypes <- colData(sce)$cell_type

# 确保 celltypes 和 umap_df 的行数一致
if (nrow(umap_data) != length(celltypes)) {
  stop("The number of cells in the UMAP data and the number of cell types do not match.")
}

# 将 celltype 信息添加到 umap_df 中
umap_df$celltype <- celltypes

# 加载 RColorBrewer 库
library(RColorBrewer)

# 使用 colorRampPalette 生成颜色
colourCount <- length(unique(umap_df$celltype))
colors <- colorRampPalette(brewer.pal(8, "Set2"))(colourCount)

# 创建 UMAP 图
p11 <- ggplot(umap_df, aes(x = UMAP1, y = UMAP2, color = factor(celltype))) +  # 使用 factor 确保正确映射颜色
  geom_point(alpha = 1) +
  scale_color_manual(values = colors) +
  coord_cartesian(xlim = c(min(umap_df$UMAP1), max(umap_df$UMAP1)),
                  ylim = c(min(umap_df$UMAP2), max(umap_df$UMAP2))) +
  ggtitle("BC") +
  labs(color = "Cell Type")  # 添加图例标题

# 显示图形
print(p11)
