Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:63878 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018Ab3AGGwi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Jan 2013 01:52:38 -0500
Received: by mail-pa0-f53.google.com with SMTP id hz1so10482154pad.12
        for <linux-media@vger.kernel.org>; Sun, 06 Jan 2013 22:52:38 -0800 (PST)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: ajaykumar.rs@samsung.com, s.nawrocki@samsung.com,
	sachin.kamat@linaro.org, patches@linaro.org,
	Kamil Debski <k.debski@samsung.com>
Subject: [PATCH] s5p-g2d: Add support for G2D H/W Rev.4.1
Date: Mon,  7 Jan 2013 12:14:29 +0530
Message-Id: <1357541069-7898-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Modified the G2D driver (which initially supported only H/W Rev.3)
to support H/W Rev.4.1 present on Exynos4x12 and Exynos52x0 SOCs.

-- Set the SRC and DST type to 'memory' instead of using reset values.
-- FIMG2D v4.1 H/W uses different logic for stretching(scaling).
-- Use CACHECTL_REG only with FIMG2D v3.

Signed-off-by: Ajay Kumar <ajaykumar.rs@samsung.com>
Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Kamil Debski <k.debski@samsung.com>
---
Earlier attempts at adding this support can be found at:
http://patchwork.linuxtv.org/patch/10833/
This version addresses all the previous comments.
---
 drivers/media/platform/s5p-g2d/g2d-hw.c   |   16 ++++++++---
 drivers/media/platform/s5p-g2d/g2d-regs.h |    8 +++++
 drivers/media/platform/s5p-g2d/g2d.c      |   43 +++++++++++++++++++++++++++-
 drivers/media/platform/s5p-g2d/g2d.h      |   13 ++++++---
 4 files changed, 70 insertions(+), 10 deletions(-)

diff --git a/drivers/media/platform/s5p-g2d/g2d-hw.c b/drivers/media/platform/s5p-g2d/g2d-hw.c
index 5b86cbe..e87bd93 100644
--- a/drivers/media/platform/s5p-g2d/g2d-hw.c
+++ b/drivers/media/platform/s5p-g2d/g2d-hw.c
@@ -28,6 +28,7 @@ void g2d_set_src_size(struct g2d_dev *d, struct g2d_frame *f)
 {
 	u32 n;
 
+	w(0, SRC_SELECT_REG);
 	w(f->stride & 0xFFFF, SRC_STRIDE_REG);
 
 	n = f->o_height & 0xFFF;
@@ -52,6 +53,7 @@ void g2d_set_dst_size(struct g2d_dev *d, struct g2d_frame *f)
 {
 	u32 n;
 
+	w(0, DST_SELECT_REG);
 	w(f->stride & 0xFFFF, DST_STRIDE_REG);
 
 	n = f->o_height & 0xFFF;
@@ -82,10 +84,14 @@ void g2d_set_flip(struct g2d_dev *d, u32 r)
 	w(r, SRC_MSK_DIRECT_REG);
 }
 
-u32 g2d_cmd_stretch(u32 e)
+void g2d_set_v41_stretch(struct g2d_dev *d, struct g2d_frame *src,
+					struct g2d_frame *dst)
 {
-	e &= 1;
-	return e << 4;
+	w(DEFAULT_SCALE_MODE, SRC_SCALE_CTRL_REG);
+
+	/* inversed scaling factor: src is numerator */
+	w((src->c_width << 16) / dst->c_width, SRC_XSCALE_REG);
+	w((src->c_height << 16) / dst->c_height, SRC_YSCALE_REG);
 }
 
 void g2d_set_cmd(struct g2d_dev *d, u32 c)
@@ -96,7 +102,9 @@ void g2d_set_cmd(struct g2d_dev *d, u32 c)
 void g2d_start(struct g2d_dev *d)
 {
 	/* Clear cache */
-	w(0x7, CACHECTL_REG);
+	if (d->variant->hw_rev == TYPE_G2D_3X)
+		w(0x7, CACHECTL_REG);
+
 	/* Enable interrupt */
 	w(1, INTEN_REG);
 	/* Start G2D engine */
diff --git a/drivers/media/platform/s5p-g2d/g2d-regs.h b/drivers/media/platform/s5p-g2d/g2d-regs.h
index 02e1cf5..950c742 100644
--- a/drivers/media/platform/s5p-g2d/g2d-regs.h
+++ b/drivers/media/platform/s5p-g2d/g2d-regs.h
@@ -35,6 +35,9 @@
 #define SRC_COLOR_MODE_REG	0x030C	/* Src Image Color Mode reg */
 #define SRC_LEFT_TOP_REG	0x0310	/* Src Left Top Coordinate reg */
 #define SRC_RIGHT_BOTTOM_REG	0x0314	/* Src Right Bottom Coordinate reg */
+#define SRC_SCALE_CTRL_REG	0x0328	/* Src Scaling type select */
+#define SRC_XSCALE_REG		0x032c	/* Src X Scaling ratio */
+#define SRC_YSCALE_REG		0x0330	/* Src Y Scaling ratio */
 
 /* Parameter Setting Registers (Dest) */
 #define DST_SELECT_REG		0x0400	/* Dest Image Selection reg */
@@ -113,3 +116,8 @@
 #define DEFAULT_WIDTH		100
 #define DEFAULT_HEIGHT		100
 
+#define DEFAULT_SCALE_MODE	(2 << 0)
+
+/* Command mode register values */
+#define CMD_V3_ENABLE_STRETCH	(1 << 4)
+
diff --git a/drivers/media/platform/s5p-g2d/g2d.c b/drivers/media/platform/s5p-g2d/g2d.c
index 1bfbc32..6c9a589 100644
--- a/drivers/media/platform/s5p-g2d/g2d.c
+++ b/drivers/media/platform/s5p-g2d/g2d.c
@@ -604,8 +604,13 @@ static void device_run(void *prv)
 	g2d_set_flip(dev, ctx->flip);
 
 	if (ctx->in.c_width != ctx->out.c_width ||
-		ctx->in.c_height != ctx->out.c_height)
-		cmd |= g2d_cmd_stretch(1);
+		ctx->in.c_height != ctx->out.c_height) {
+		if (dev->variant->hw_rev == TYPE_G2D_3X)
+			cmd |= CMD_V3_ENABLE_STRETCH;
+		else
+			g2d_set_v41_stretch(dev, &ctx->in, &ctx->out);
+	}
+
 	g2d_set_cmd(dev, cmd);
 	g2d_start(dev);
 
@@ -690,6 +695,8 @@ static struct v4l2_m2m_ops g2d_m2m_ops = {
 	.unlock		= g2d_unlock,
 };
 
+static void *g2d_get_drv_data(struct platform_device *pdev);
+
 static int g2d_probe(struct platform_device *pdev)
 {
 	struct g2d_dev *dev;
@@ -791,6 +798,7 @@ static int g2d_probe(struct platform_device *pdev)
 	}
 
 	def_frame.stride = (def_frame.width * def_frame.fmt->depth) >> 3;
+	dev->variant = g2d_get_drv_data(pdev);
 
 	return 0;
 
@@ -830,9 +838,40 @@ static int g2d_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static void *g2d_get_drv_data(struct platform_device *pdev)
+{
+	struct g2d_variant *driver_data = NULL;
+
+	driver_data = (struct g2d_variant *)
+		platform_get_device_id(pdev)->driver_data;
+
+	return driver_data;
+}
+
+struct g2d_variant g2d_drvdata_v3x = {
+	.hw_rev = TYPE_G2D_3X,
+};
+
+struct g2d_variant g2d_drvdata_v4x = {
+	.hw_rev = TYPE_G2D_4X, /* Revision 4.1 for Exynos4X12 and Exynos5 */
+};
+
+static struct platform_device_id g2d_driver_ids[] = {
+	{
+		.name = "s5p-g2d",
+		.driver_data = (unsigned long)&g2d_drvdata_v3x,
+	}, {
+		.name = "s5p-g2d-v4x",
+		.driver_data = (unsigned long)&g2d_drvdata_v4x,
+	},
+	{},
+};
+MODULE_DEVICE_TABLE(platform, g2d_driver_ids);
+
 static struct platform_driver g2d_pdrv = {
 	.probe		= g2d_probe,
 	.remove		= g2d_remove,
+	.id_table	= g2d_driver_ids,
 	.driver		= {
 		.name = G2D_NAME,
 		.owner = THIS_MODULE,
diff --git a/drivers/media/platform/s5p-g2d/g2d.h b/drivers/media/platform/s5p-g2d/g2d.h
index 6b765b0..3fb4555 100644
--- a/drivers/media/platform/s5p-g2d/g2d.h
+++ b/drivers/media/platform/s5p-g2d/g2d.h
@@ -14,6 +14,8 @@
 #include <media/v4l2-ctrls.h>
 
 #define G2D_NAME "s5p-g2d"
+#define TYPE_G2D_3X 3
+#define TYPE_G2D_4X 4
 
 struct g2d_dev {
 	struct v4l2_device	v4l2_dev;
@@ -27,6 +29,7 @@ struct g2d_dev {
 	struct clk		*clk;
 	struct clk		*gate;
 	struct g2d_ctx		*curr;
+	struct g2d_variant	*variant;
 	int irq;
 	wait_queue_head_t	irq_queue;
 };
@@ -53,7 +56,7 @@ struct g2d_frame {
 struct g2d_ctx {
 	struct v4l2_fh fh;
 	struct g2d_dev		*dev;
-	struct v4l2_m2m_ctx     *m2m_ctx;
+	struct v4l2_m2m_ctx	*m2m_ctx;
 	struct g2d_frame	in;
 	struct g2d_frame	out;
 	struct v4l2_ctrl	*ctrl_hflip;
@@ -70,6 +73,9 @@ struct g2d_fmt {
 	u32	hw;
 };
 
+struct g2d_variant {
+	unsigned short hw_rev;
+};
 
 void g2d_reset(struct g2d_dev *d);
 void g2d_set_src_size(struct g2d_dev *d, struct g2d_frame *f);
@@ -80,7 +86,6 @@ void g2d_start(struct g2d_dev *d);
 void g2d_clear_int(struct g2d_dev *d);
 void g2d_set_rop4(struct g2d_dev *d, u32 r);
 void g2d_set_flip(struct g2d_dev *d, u32 r);
-u32 g2d_cmd_stretch(u32 e);
+void g2d_set_v41_stretch(struct g2d_dev *d,
+			struct g2d_frame *src, struct g2d_frame *dst);
 void g2d_set_cmd(struct g2d_dev *d, u32 c);
-
-
-- 
1.7.4.1

