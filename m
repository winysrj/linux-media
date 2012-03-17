Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:44780 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756860Ab2CQLJK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Mar 2012 07:09:10 -0400
Received: from epcpsbgm1.samsung.com (mailout4.samsung.com [203.254.224.34])
 by mailout4.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0M11009EH0B9ABC0@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Sat, 17 Mar 2012 20:09:10 +0900 (KST)
Received: from localhost.localdomain ([107.108.73.106])
 by mmp2.samsung.com (Oracle Communications Messaging Exchange Server 7u4-19.01
 64bit (built Sep  7 2010)) with ESMTPA id <0M1100JOJ0B86920@mmp2.samsung.com>
 for linux-media@vger.kernel.org; Sat, 17 Mar 2012 20:09:18 +0900 (KST)
From: Ajay Kumar <ajaykumar.rs@samsung.com>
To: linux-media@vger.kernel.org, k.debski@samsung.com
Cc: kyungmin.park@samsung.com, s.nawrocki@samsung.com,
	es10.choi@samsung.com
Subject: [PATCH v2 1/1] media: video: s5p-g2d: Add support for FIMG2D v41 H/W
 logic
Date: Sat, 17 Mar 2012 16:52:14 +0530
Message-id: <1331983334-18934-2-git-send-email-ajaykumar.rs@samsung.com>
In-reply-to: <1331983334-18934-1-git-send-email-ajaykumar.rs@samsung.com>
References: <1331983334-18934-1-git-send-email-ajaykumar.rs@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Modify the G2D driver(which initially supported only FIMG2D v3 style H/W)
to support FIMG2D v41 style hardware present on Exynos4x12 and Exynos52x0 SOC.

	-- Set the SRC and DST type to 'memory' instead of using reset values.
	-- FIMG2D v41 H/W uses different logic for stretching(scaling).
	-- Use CACHECTL_REG only with FIMG2D v3.

Signed-off-by: Ajay Kumar <ajaykumar.rs@samsung.com>
---
 drivers/media/video/s5p-g2d/g2d-hw.c   |   39 ++++++++++++++++++++++++++++---
 drivers/media/video/s5p-g2d/g2d-regs.h |    6 +++++
 drivers/media/video/s5p-g2d/g2d.c      |   23 +++++++++++++++++-
 drivers/media/video/s5p-g2d/g2d.h      |    9 ++++++-
 4 files changed, 70 insertions(+), 7 deletions(-)

diff --git a/drivers/media/video/s5p-g2d/g2d-hw.c b/drivers/media/video/s5p-g2d/g2d-hw.c
index 5b86cbe..f8225b8 100644
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
@@ -82,10 +86,36 @@ void g2d_set_flip(struct g2d_dev *d, u32 r)
 	w(r, SRC_MSK_DIRECT_REG);
 }
 
-u32 g2d_cmd_stretch(u32 e)
+/**
+ * g2d_calc_scale_factor - convert scale factor to fixed pint 16
+ * @n: numerator
+ * @d: denominator
+ */
+static unsigned long g2d_calc_scale_factor(int n, int d)
+{
+	return (n << 16) / d;
+}
+
+void g2d_set_v41_stretch(struct g2d_dev *d, struct g2d_frame *src,
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
+	wcfg = g2d_calc_scale_factor(src_w, dst_w);
+	hcfg = g2d_calc_scale_factor(src_h, dst_h);
+
+	w(wcfg, SRC_XSCALE_REG);
+	w(hcfg, SRC_YSCALE_REG);
 }
 
 void g2d_set_cmd(struct g2d_dev *d, u32 c)
@@ -96,7 +126,8 @@ void g2d_set_cmd(struct g2d_dev *d, u32 c)
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
index 02e1cf5..14c681f 100644
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
@@ -112,4 +115,7 @@
 
 #define DEFAULT_WIDTH		100
 #define DEFAULT_HEIGHT		100
+#define DEFAULT_SCALE_MODE	(2 << 0)
 
+/* Command mode register values */
+#define CMD_V3_ENABLE_STRETCH	(1 << 4)
diff --git a/drivers/media/video/s5p-g2d/g2d.c b/drivers/media/video/s5p-g2d/g2d.c
index 789de74..8924f7e 100644
--- a/drivers/media/video/s5p-g2d/g2d.c
+++ b/drivers/media/video/s5p-g2d/g2d.c
@@ -582,8 +582,13 @@ static void device_run(void *prv)
 	g2d_set_flip(dev, ctx->flip);
 
 	if (ctx->in.c_width != ctx->out.c_width ||
-		ctx->in.c_height != ctx->out.c_height)
-		cmd |= g2d_cmd_stretch(1);
+		ctx->in.c_height != ctx->out.c_height) {
+		if (dev->device_type == TYPE_G2D_3X)
+			cmd |= CMD_V3_ENABLE_STRETCH;
+		else
+			g2d_set_v41_stretch(dev, &ctx->in, &ctx->out);
+	}
+
 	g2d_set_cmd(dev, cmd);
 	g2d_start(dev);
 
@@ -783,6 +788,8 @@ static int g2d_probe(struct platform_device *pdev)
 
 	def_frame.stride = (def_frame.width * def_frame.fmt->depth) >> 3;
 
+	dev->device_type = platform_get_device_id(pdev)->driver_data;
+
 	return 0;
 
 unreg_video_dev:
@@ -832,9 +839,21 @@ static int g2d_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static struct platform_device_id g2d_driver_ids[] = {
+	{
+		.name		= "s5p-g2d",
+		.driver_data	= TYPE_G2D_3X,
+	}, {
+		.name		= "s5p-g2d41x",
+		.driver_data	= TYPE_G2D_41X,
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
index 1b82065..009b37d 100644
--- a/drivers/media/video/s5p-g2d/g2d.h
+++ b/drivers/media/video/s5p-g2d/g2d.h
@@ -15,6 +15,11 @@
 
 #define G2D_NAME "s5p-g2d"
 
+enum g2d_type {
+	TYPE_G2D_3X,
+	TYPE_G2D_41X,
+};
+
 struct g2d_dev {
 	struct v4l2_device	v4l2_dev;
 	struct v4l2_m2m_dev	*m2m_dev;
@@ -30,6 +35,7 @@ struct g2d_dev {
 	struct g2d_ctx		*curr;
 	int irq;
 	wait_queue_head_t	irq_queue;
+	enum g2d_type		device_type;
 };
 
 struct g2d_frame {
@@ -81,7 +87,8 @@ void g2d_start(struct g2d_dev *d);
 void g2d_clear_int(struct g2d_dev *d);
 void g2d_set_rop4(struct g2d_dev *d, u32 r);
 void g2d_set_flip(struct g2d_dev *d, u32 r);
-u32 g2d_cmd_stretch(u32 e);
+void g2d_set_v41_stretch(struct g2d_dev *d,
+			struct g2d_frame *src, struct g2d_frame *dst);
 void g2d_set_cmd(struct g2d_dev *d, u32 c);
 
 
-- 
1.7.0.4

