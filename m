Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:49637 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759700Ab2CNJWY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Mar 2012 05:22:24 -0400
Received: from epcpsbgm1.samsung.com (mailout2.samsung.com [203.254.224.25])
 by mailout2.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0M0V00MR2BCLYH80@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 14 Mar 2012 18:22:07 +0900 (KST)
Received: from localhost.localdomain ([107.108.73.106])
 by mmp2.samsung.com (Oracle Communications Messaging Exchange Server 7u4-19.01
 64bit (built Sep  7 2010)) with ESMTPA id <0M0V003VSBBEHAB0@mmp2.samsung.com>
 for linux-media@vger.kernel.org; Wed, 14 Mar 2012 18:22:10 +0900 (KST)
From: Ajay Kumar <ajaykumar.rs@samsung.com>
To: linux-media@vger.kernel.org, k.debski@samsung.com,
	kgene.kim@samsung.com
Cc: kyungmin.park@samsung.com, s.nawrocki@samsung.com,
	es10.choi@samsung.com, sachin.kamat@linaro.org
Subject: [PATCH 1/1] media: video: s5p-g2d: Add support for FIMG2D v4 H/W logic
Date: Wed, 14 Mar 2012 15:03:40 +0530
Message-id: <1331717620-30200-2-git-send-email-ajaykumar.rs@samsung.com>
In-reply-to: <1331717620-30200-1-git-send-email-ajaykumar.rs@samsung.com>
References: <1331717620-30200-1-git-send-email-ajaykumar.rs@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Modify the G2D driver(which initially supported only FIMG2D v3 style H/W)
to support FIMG2D v4 style hardware present on Exynos4x12 and Exynos52x0 SOC.

	-- Set the SRC and DST type to 'memory' instead of using reset values.
	-- FIMG2D v4 H/W uses different logic for stretching(scaling).
	-- Use CACHECTL_REG only with FIMG2D v3.
	-- No Source clock for G2D on EXYNOS5.
	   Only gating clock to be used.

Signed-off-by: Ajay Kumar <ajaykumar.rs@samsung.com>
---
 drivers/media/video/s5p-g2d/g2d-hw.c   |   54 ++++++++++++++++++++++++++--
 drivers/media/video/s5p-g2d/g2d-regs.h |    4 ++
 drivers/media/video/s5p-g2d/g2d.c      |   61 +++++++++++++++++++++++---------
 drivers/media/video/s5p-g2d/g2d.h      |   10 +++++-
 4 files changed, 107 insertions(+), 22 deletions(-)

diff --git a/drivers/media/video/s5p-g2d/g2d-hw.c b/drivers/media/video/s5p-g2d/g2d-hw.c
index 5b86cbe..7631756 100644
--- a/drivers/media/video/s5p-g2d/g2d-hw.c
+++ b/drivers/media/video/s5p-g2d/g2d-hw.c
@@ -28,6 +28,8 @@ void g2d_set_src_size(struct g2d_dev *d, struct g2d_frame *f)
 {
 	u32 n;
 
+	w(0, SRC_SELECT_REG);
+
 	w(f->stride & 0xFFFF, SRC_STRIDE_REG);
 
 	n = f->o_height & 0xFFF;
@@ -52,6 +54,8 @@ void g2d_set_dst_size(struct g2d_dev *d, struct g2d_frame *f)
 {
 	u32 n;
 
+	w(0, DST_SELECT_REG);
+
 	w(f->stride & 0xFFFF, DST_STRIDE_REG);
 
 	n = f->o_height & 0xFFF;
@@ -82,10 +86,51 @@ void g2d_set_flip(struct g2d_dev *d, u32 r)
 	w(r, SRC_MSK_DIRECT_REG);
 }
 
-u32 g2d_cmd_stretch(u32 e)
+/**
+ * scale_factor_to_fixed16 - convert scale factor to fixed pint 16
+ * @n: numerator
+ * @d: denominator
+ */
+static unsigned long scale_factor_to_fixed16(int n, int d)
+{
+	int i;
+	u32 fixed16;
+
+	fixed16 = (n/d) << 16;
+	n %= d;
+
+	for (i = 0; i < 16; i++) {
+		if (!n)
+			break;
+		n <<= 1;
+		if (n/d)
+			fixed16 |= 1 << (15-i);
+		n %= d;
+	}
+
+	return fixed16;
+}
+
+void g2d_cmd_stretch(struct g2d_dev *d, struct g2d_frame *src,
+					struct g2d_frame *dst)
 {
-	e &= 1;
-	return e << 4;
+	int src_w, src_h, dst_w, dst_h;
+	u32 wcfg, hcfg;
+
+	w(DEFAULT_SCALE_MODE, SRC_SCALE_CTRL_REG);
+
+	src_w = src->c_width;
+	src_h = src->c_height;
+
+	dst_w = dst->c_width;
+	dst_h = dst->c_height;
+
+	/* inversed scaling factor: src is numerator */
+	wcfg = scale_factor_to_fixed16(src_w, dst_w);
+	hcfg = scale_factor_to_fixed16(src_h, dst_h);
+
+	w(wcfg, SRC_XSCALE_REG);
+	w(hcfg, SRC_YSCALE_REG);
 }
 
 void g2d_set_cmd(struct g2d_dev *d, u32 c)
@@ -96,7 +141,8 @@ void g2d_set_cmd(struct g2d_dev *d, u32 c)
 void g2d_start(struct g2d_dev *d)
 {
 	/* Clear cache */
-	w(0x7, CACHECTL_REG);
+	if (d->device_type == TYPE_G2D_3X)
+		w(0x7, CACHECTL_REG);
 	/* Enable interrupt */
 	w(1, INTEN_REG);
 	/* Start G2D engine */
diff --git a/drivers/media/video/s5p-g2d/g2d-regs.h b/drivers/media/video/s5p-g2d/g2d-regs.h
index 02e1cf5..619eb9c 100644
--- a/drivers/media/video/s5p-g2d/g2d-regs.h
+++ b/drivers/media/video/s5p-g2d/g2d-regs.h
@@ -35,6 +35,9 @@
 #define SRC_COLOR_MODE_REG	0x030C	/* Src Image Color Mode reg */
 #define SRC_LEFT_TOP_REG	0x0310	/* Src Left Top Coordinate reg */
 #define SRC_RIGHT_BOTTOM_REG	0x0314	/* Src Right Bottom Coordinate reg */
+#define SRC_SCALE_CTRL_REG	0x0328	/* Src Scaling type select */
+#define SRC_XSCALE_REG		0x032c	/* Src X Scaling ratio */
+#define SRC_YSCALE_REG		0x0330	/* Src Y Scaling ratio */
 
 /* Parameter Setting Registers (Dest) */
 #define DST_SELECT_REG		0x0400	/* Dest Image Selection reg */
@@ -112,4 +115,5 @@
 
 #define DEFAULT_WIDTH		100
 #define DEFAULT_HEIGHT		100
+#define DEFAULT_SCALE_MODE	(2 << 0)
 
diff --git a/drivers/media/video/s5p-g2d/g2d.c b/drivers/media/video/s5p-g2d/g2d.c
index 789de74..4bdc227 100644
--- a/drivers/media/video/s5p-g2d/g2d.c
+++ b/drivers/media/video/s5p-g2d/g2d.c
@@ -582,8 +582,13 @@ static void device_run(void *prv)
 	g2d_set_flip(dev, ctx->flip);
 
 	if (ctx->in.c_width != ctx->out.c_width ||
-		ctx->in.c_height != ctx->out.c_height)
-		cmd |= g2d_cmd_stretch(1);
+		ctx->in.c_height != ctx->out.c_height) {
+		if (dev->device_type == TYPE_G2D_3X)
+			cmd |= (1 << 4);
+		else
+			g2d_cmd_stretch(dev, &ctx->in, &ctx->out);
+	}
+
 	g2d_set_cmd(dev, cmd);
 	g2d_start(dev);
 
@@ -705,17 +710,20 @@ static int g2d_probe(struct platform_device *pdev)
 		goto rel_res_regs;
 	}
 
-	dev->clk = clk_get(&pdev->dev, "sclk_fimg2d");
-	if (IS_ERR_OR_NULL(dev->clk)) {
-		dev_err(&pdev->dev, "failed to get g2d clock\n");
-		ret = -ENXIO;
-		goto unmap_regs;
-	}
-
-	ret = clk_prepare(dev->clk);
-	if (ret) {
-		dev_err(&pdev->dev, "failed to prepare g2d clock\n");
-		goto put_clk;
+	dev->device_type = platform_get_device_id(pdev)->driver_data;
+	if (dev->device_type != TYPE_G2D_4_1X) {
+		dev->clk = clk_get(&pdev->dev, "sclk_fimg2d");
+		if (IS_ERR_OR_NULL(dev->clk)) {
+			dev_err(&pdev->dev, "failed to get g2d clock\n");
+			ret = -ENXIO;
+			goto unmap_regs;
+		}
+
+		ret = clk_prepare(dev->clk);
+		if (ret) {
+			dev_err(&pdev->dev, "failed to prepare g2d clock\n");
+			goto put_clk;
+		}
 	}
 
 	dev->gate = clk_get(&pdev->dev, "fimg2d");
@@ -800,9 +808,11 @@ unprep_clk_gate:
 put_clk_gate:
 	clk_put(dev->gate);
 unprep_clk:
-	clk_unprepare(dev->clk);
+	if (dev->device_type != TYPE_G2D_4_1X)
+		clk_unprepare(dev->clk);
 put_clk:
-	clk_put(dev->clk);
+	if (dev->device_type != TYPE_G2D_4_1X)
+		clk_put(dev->clk);
 unmap_regs:
 	iounmap(dev->regs);
 rel_res_regs:
@@ -824,17 +834,34 @@ static int g2d_remove(struct platform_device *pdev)
 	free_irq(dev->irq, dev);
 	clk_unprepare(dev->gate);
 	clk_put(dev->gate);
-	clk_unprepare(dev->clk);
-	clk_put(dev->clk);
+	if (dev->device_type != TYPE_G2D_4_1X) {
+		clk_unprepare(dev->clk);
+		clk_put(dev->clk);
+	}
 	iounmap(dev->regs);
 	release_resource(dev->res_regs);
 	kfree(dev);
 	return 0;
 }
 
+static struct platform_device_id g2d_driver_ids[] = {
+	{
+		.name		= "s5p-g2d",
+		.driver_data	= TYPE_G2D_3X,
+	}, {
+		.name		= "s5p-g2d4x",
+		.driver_data	= TYPE_G2D_4X,
+	}, {
+		.name		= "s5p-g2d41x",
+		.driver_data	= TYPE_G2D_4_1X,
+	}, { },
+};
+MODULE_DEVICE_TABLE(platform, s3c24xx_driver_ids);
+
 static struct platform_driver g2d_pdrv = {
 	.probe		= g2d_probe,
 	.remove		= g2d_remove,
+	.id_table	= g2d_driver_ids,
 	.driver		= {
 		.name = G2D_NAME,
 		.owner = THIS_MODULE,
diff --git a/drivers/media/video/s5p-g2d/g2d.h b/drivers/media/video/s5p-g2d/g2d.h
index 1b82065..4ee9341 100644
--- a/drivers/media/video/s5p-g2d/g2d.h
+++ b/drivers/media/video/s5p-g2d/g2d.h
@@ -15,6 +15,12 @@
 
 #define G2D_NAME "s5p-g2d"
 
+enum g2d_type {
+	TYPE_G2D_3X,
+	TYPE_G2D_4X,
+	TYPE_G2D_4_1X,
+};
+
 struct g2d_dev {
 	struct v4l2_device	v4l2_dev;
 	struct v4l2_m2m_dev	*m2m_dev;
@@ -30,6 +36,7 @@ struct g2d_dev {
 	struct g2d_ctx		*curr;
 	int irq;
 	wait_queue_head_t	irq_queue;
+	enum g2d_type		device_type;
 };
 
 struct g2d_frame {
@@ -81,7 +88,8 @@ void g2d_start(struct g2d_dev *d);
 void g2d_clear_int(struct g2d_dev *d);
 void g2d_set_rop4(struct g2d_dev *d, u32 r);
 void g2d_set_flip(struct g2d_dev *d, u32 r);
-u32 g2d_cmd_stretch(u32 e);
+void g2d_cmd_stretch(struct g2d_dev *d,
+			struct g2d_frame *src, struct g2d_frame *dst);
 void g2d_set_cmd(struct g2d_dev *d, u32 c);
 
 
-- 
1.7.0.4

