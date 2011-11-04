Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:55809 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932185Ab1KDOUM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Nov 2011 10:20:12 -0400
Date: Fri, 04 Nov 2011 15:20:00 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 6/8] s5p-fimc: Adjust pixel height alignments according to the
 IP revision
In-reply-to: <1320416402-22883-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: samsung-soc@vger.kernel.org, m.szyprowski@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	s.nawrocki@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1320416402-22883-7-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1320416402-22883-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Minimum vertical pixel size alignment for input and output DMA and
the scaler depend on color format, rotation, the IP instance and revision.

Make vertical pixel size of format and crop better fit for each SoC
revision and the IP instance by adding min_vsize_align attribute to
the FIMC variant data structure. It's now common for the DMA engines
and the scaler.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-capture.c |    2 +-
 drivers/media/video/s5p-fimc/fimc-core.c    |   16 +++++++++++-----
 drivers/media/video/s5p-fimc/fimc-core.h    |    2 ++
 3 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index 70f741f..82d9ab6 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -526,7 +526,7 @@ static struct fimc_fmt *fimc_capture_try_format(struct fimc_ctx *ctx,
 	max_w = rotation ? pl->out_rot_en_w : pl->out_rot_dis_w;
 	min_w = ctx->state & FIMC_DST_CROP ? dst->width : var->min_out_pixsize;
 	min_h = ctx->state & FIMC_DST_CROP ? dst->height : var->min_out_pixsize;
-	if (fimc->id == 1 && var->pix_hoff)
+	if (var->min_vsize_align == 1 && !rotation)
 		align_h = fimc_fmt_is_rgb(ffmt->color) ? 0 : 1;
 
 	depth = fimc_get_format_depth(ffmt);
diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index 9c3a8c5..7c22d78 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -1038,12 +1038,11 @@ static int fimc_try_fmt_mplane(struct fimc_ctx *ctx, struct v4l2_format *f)
 		mod_x = 6; /* 64 x 32 pixels tile */
 		mod_y = 5;
 	} else {
-		if (fimc->id == 1 && variant->pix_hoff)
+		if (variant->min_vsize_align == 1)
 			mod_y = fimc_fmt_is_rgb(fmt->color) ? 0 : 1;
 		else
-			mod_y = mod_x;
+			mod_y = ffs(variant->min_vsize_align) - 1;
 	}
-	dbg("mod_x: %d, mod_y: %d, max_w: %d", mod_x, mod_y, max_w);
 
 	v4l_bound_align_image(&pix->width, 16, max_w, mod_x,
 		&pix->height, 8, variant->pix_limit->scaler_dis_w, mod_y, 0);
@@ -1226,10 +1225,10 @@ static int fimc_m2m_try_crop(struct fimc_ctx *ctx, struct v4l2_crop *cr)
 		fimc->variant->min_inp_pixsize : fimc->variant->min_out_pixsize;
 
 	/* Get pixel alignment constraints. */
-	if (fimc->id == 1 && fimc->variant->pix_hoff)
+	if (fimc->variant->min_vsize_align == 1)
 		halign = fimc_fmt_is_rgb(f->fmt->color) ? 0 : 1;
 	else
-		halign = ffs(min_size) - 1;
+		halign = ffs(fimc->variant->min_vsize_align) - 1;
 
 	for (i = 0; i < f->fmt->colplanes; i++)
 		depth += f->fmt->depth[i];
@@ -1834,6 +1833,7 @@ static struct samsung_fimc_variant fimc0_variant_s5p = {
 	.min_inp_pixsize = 16,
 	.min_out_pixsize = 16,
 	.hor_offs_align	 = 8,
+	.min_vsize_align = 16,
 	.out_buf_count	 = 4,
 	.pix_limit	 = &s5p_pix_limit[0],
 };
@@ -1843,6 +1843,7 @@ static struct samsung_fimc_variant fimc2_variant_s5p = {
 	.min_inp_pixsize = 16,
 	.min_out_pixsize = 16,
 	.hor_offs_align	 = 8,
+	.min_vsize_align = 16,
 	.out_buf_count	 = 4,
 	.pix_limit = &s5p_pix_limit[1],
 };
@@ -1855,6 +1856,7 @@ static struct samsung_fimc_variant fimc0_variant_s5pv210 = {
 	.min_inp_pixsize = 16,
 	.min_out_pixsize = 16,
 	.hor_offs_align	 = 8,
+	.min_vsize_align = 16,
 	.out_buf_count	 = 4,
 	.pix_limit	 = &s5p_pix_limit[1],
 };
@@ -1868,6 +1870,7 @@ static struct samsung_fimc_variant fimc1_variant_s5pv210 = {
 	.min_inp_pixsize = 16,
 	.min_out_pixsize = 16,
 	.hor_offs_align	 = 1,
+	.min_vsize_align = 1,
 	.out_buf_count	 = 4,
 	.pix_limit	 = &s5p_pix_limit[2],
 };
@@ -1878,6 +1881,7 @@ static struct samsung_fimc_variant fimc2_variant_s5pv210 = {
 	.min_inp_pixsize = 16,
 	.min_out_pixsize = 16,
 	.hor_offs_align	 = 8,
+	.min_vsize_align = 16,
 	.out_buf_count	 = 4,
 	.pix_limit	 = &s5p_pix_limit[2],
 };
@@ -1892,6 +1896,7 @@ static struct samsung_fimc_variant fimc0_variant_exynos4 = {
 	.min_inp_pixsize = 16,
 	.min_out_pixsize = 16,
 	.hor_offs_align	 = 2,
+	.min_vsize_align = 1,
 	.out_buf_count	 = 32,
 	.pix_limit	 = &s5p_pix_limit[1],
 };
@@ -1904,6 +1909,7 @@ static struct samsung_fimc_variant fimc3_variant_exynos4 = {
 	.min_inp_pixsize = 16,
 	.min_out_pixsize = 16,
 	.hor_offs_align	 = 2,
+	.min_vsize_align = 1,
 	.out_buf_count	 = 32,
 	.pix_limit	 = &s5p_pix_limit[3],
 };
diff --git a/drivers/media/video/s5p-fimc/fimc-core.h b/drivers/media/video/s5p-fimc/fimc-core.h
index a6936da..c7f01c4 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.h
+++ b/drivers/media/video/s5p-fimc/fimc-core.h
@@ -377,6 +377,7 @@ struct fimc_pix_limit {
  * @min_inp_pixsize: minimum input pixel size
  * @min_out_pixsize: minimum output pixel size
  * @hor_offs_align: horizontal pixel offset aligment
+ * @min_vsize_align: minimum vertical pixel size alignment
  * @out_buf_count: the number of buffers in output DMA sequence
  */
 struct samsung_fimc_variant {
@@ -390,6 +391,7 @@ struct samsung_fimc_variant {
 	u16		min_inp_pixsize;
 	u16		min_out_pixsize;
 	u16		hor_offs_align;
+	u16		min_vsize_align;
 	u16		out_buf_count;
 };
 
-- 
1.7.7.1

