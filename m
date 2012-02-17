Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:59153 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712Ab2BQPET (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Feb 2012 10:04:19 -0500
Received: from euspt2 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LZJ008UGLV5YF@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 17 Feb 2012 15:04:17 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LZJ00K9BLV4UZ@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 17 Feb 2012 15:04:17 +0000 (GMT)
Date: Fri, 17 Feb 2012 16:04:13 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 2/2] s5p-jpeg: Add JPEG controls support
In-reply-to: <1329491053-3071-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, s.nawrocki@samsung.com,
	Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1329491053-3071-3-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1329491053-3071-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch replaces VIDIOC_S/G_JPEGCOMP ioctl handlers with V4L2_CID_JPEG_QUALITY
control. Additionally it enables JPEG subsampling and the restart interval
configuration through V4L2_CID_JPEG_SUBSAMPLING and V4L2_CID_JPEG_RESTART_INTERVAL
controls. For the decoder video node only V4L2_CID_JPEG_SUBSAMPLING control
is available and it is read-only.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-jpeg/jpeg-core.c |  117 +++++++++++++++++++++++-------
 drivers/media/video/s5p-jpeg/jpeg-core.h |    9 ++-
 drivers/media/video/s5p-jpeg/jpeg-hw.h   |   18 +++--
 3 files changed, 111 insertions(+), 33 deletions(-)

diff --git a/drivers/media/video/s5p-jpeg/jpeg-core.c b/drivers/media/video/s5p-jpeg/jpeg-core.c
index c368c4f..c104aeb 100644
--- a/drivers/media/video/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/video/s5p-jpeg/jpeg-core.c
@@ -203,6 +203,11 @@ static const unsigned char hactblg0[162] = {
 	0xf9, 0xfa
 };
 
+static inline struct s5p_jpeg_ctx *ctrl_to_ctx(struct v4l2_ctrl *c)
+{
+	return container_of(c->handler, struct s5p_jpeg_ctx, ctrl_handler);
+}
+
 static inline struct s5p_jpeg_ctx *fh_to_ctx(struct v4l2_fh *fh)
 {
 	return container_of(fh, struct s5p_jpeg_ctx, fh);
@@ -274,6 +279,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 		      struct vb2_queue *dst_vq);
 static struct s5p_jpeg_fmt *s5p_jpeg_find_format(unsigned int mode,
 						 __u32 pixelformat);
+static int s5p_jpeg_controls_create(struct s5p_jpeg_ctx *ctx);
 
 static int s5p_jpeg_open(struct file *file)
 {
@@ -288,6 +294,8 @@ static int s5p_jpeg_open(struct file *file)
 		return -ENOMEM;
 
 	v4l2_fh_init(&ctx->fh, vfd);
+	/* Use separate control handler per file handle */
+	ctx->fh.ctrl_handler = &ctx->ctrl_handler;
 	file->private_data = &ctx->fh;
 	v4l2_fh_add(&ctx->fh);
 
@@ -300,6 +308,10 @@ static int s5p_jpeg_open(struct file *file)
 		out_fmt = s5p_jpeg_find_format(ctx->mode, V4L2_PIX_FMT_JPEG);
 	}
 
+	ret = s5p_jpeg_controls_create(ctx);
+	if (ret < 0)
+		goto error;
+
 	ctx->m2m_ctx = v4l2_m2m_ctx_init(jpeg->m2m_dev, ctx, queue_init);
 	if (IS_ERR(ctx->m2m_ctx)) {
 		ret = PTR_ERR(ctx->m2m_ctx);
@@ -322,6 +334,7 @@ static int s5p_jpeg_release(struct file *file)
 	struct s5p_jpeg_ctx *ctx = fh_to_ctx(file->private_data);
 
 	v4l2_m2m_ctx_release(ctx->m2m_ctx);
+	v4l2_ctrl_handler_free(&ctx->ctrl_handler);
 	v4l2_fh_del(&ctx->fh);
 	v4l2_fh_exit(&ctx->fh);
 	kfree(ctx);
@@ -833,33 +846,89 @@ int s5p_jpeg_g_selection(struct file *file, void *priv,
 	return 0;
 }
 
-static int s5p_jpeg_g_jpegcomp(struct file *file, void *priv,
-			       struct v4l2_jpegcompression *compr)
+/*
+ * V4L2 controls
+ */
+
+static int s5p_jpeg_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
 {
-	struct s5p_jpeg_ctx *ctx = priv;
+	struct s5p_jpeg_ctx *ctx = ctrl_to_ctx(ctrl);
+	struct s5p_jpeg *jpeg = ctx->jpeg;
+	unsigned long flags;
 
-	if (ctx->mode == S5P_JPEG_DECODE)
-		return -ENOTTY;
+	switch (ctrl->id) {
+	case V4L2_CID_JPEG_CHROMA_SUBSAMPLING:
+		spin_lock_irqsave(&jpeg->slock, flags);
 
-	memset(compr, 0, sizeof(*compr));
-	compr->quality = ctx->compr_quality;
+		WARN_ON(ctx->subsampling > S5P_SUBSAMPLING_MODE_GRAY);
+		if (ctx->subsampling > 2)
+			ctrl->val = V4L2_JPEG_CHROMA_SUBSAMPLING_GRAY;
+		else
+			ctrl->val = ctx->subsampling;
+		spin_unlock_irqrestore(&jpeg->slock, flags);
+		break;
+	}
 
 	return 0;
 }
 
-static int s5p_jpeg_s_jpegcomp(struct file *file, void *priv,
-			       struct v4l2_jpegcompression *compr)
+static int s5p_jpeg_s_ctrl(struct v4l2_ctrl *ctrl)
 {
-	struct s5p_jpeg_ctx *ctx = priv;
+	struct s5p_jpeg_ctx *ctx = ctrl_to_ctx(ctrl);
+	unsigned long flags;
 
-	if (ctx->mode == S5P_JPEG_DECODE)
-		return -ENOTTY;
+	spin_lock_irqsave(&ctx->jpeg->slock, flags);
 
-	compr->quality = clamp(compr->quality, S5P_JPEG_COMPR_QUAL_BEST,
-			       S5P_JPEG_COMPR_QUAL_WORST);
+	switch (ctrl->id) {
+	case V4L2_CID_JPEG_COMPRESSION_QUALITY:
+		ctx->compr_quality = S5P_JPEG_COMPR_QUAL_WORST - ctrl->val;
+		break;
+	case V4L2_CID_JPEG_RESTART_INTERVAL:
+		ctx->restart_interval = ctrl->val;
+		break;
+	case V4L2_CID_JPEG_CHROMA_SUBSAMPLING:
+		ctx->subsampling = ctrl->val;
+		break;
+	}
+
+	spin_unlock_irqrestore(&ctx->jpeg->slock, flags);
+	return 0;
+}
+
+static const struct v4l2_ctrl_ops s5p_jpeg_ctrl_ops = {
+	.g_volatile_ctrl	= s5p_jpeg_g_volatile_ctrl,
+	.s_ctrl			= s5p_jpeg_s_ctrl,
+};
+
+static int s5p_jpeg_controls_create(struct s5p_jpeg_ctx *ctx)
+{
+	unsigned int mask = ~0x27; /* 444, 422, 420, GRAY */
+	struct v4l2_ctrl *ctrl;
+
+	v4l2_ctrl_handler_init(&ctx->ctrl_handler, 3);
 
-	ctx->compr_quality = S5P_JPEG_COMPR_QUAL_WORST - compr->quality;
+	if (ctx->mode == S5P_JPEG_ENCODE) {
+		v4l2_ctrl_new_std(&ctx->ctrl_handler, &s5p_jpeg_ctrl_ops,
+				  V4L2_CID_JPEG_COMPRESSION_QUALITY,
+				  0, 3, 1, 3);
+
+		v4l2_ctrl_new_std(&ctx->ctrl_handler, &s5p_jpeg_ctrl_ops,
+				  V4L2_CID_JPEG_RESTART_INTERVAL,
+				  0, 3, 0xffff, 0);
+		mask = ~0x06; /* 422, 420 */
+	}
+
+	ctrl = v4l2_ctrl_new_std_menu(&ctx->ctrl_handler, &s5p_jpeg_ctrl_ops,
+				      V4L2_CID_JPEG_CHROMA_SUBSAMPLING,
+				      V4L2_JPEG_CHROMA_SUBSAMPLING_GRAY, mask,
+				      V4L2_JPEG_CHROMA_SUBSAMPLING_422);
 
+	if (ctx->ctrl_handler.error)
+		return ctx->ctrl_handler.error;
+
+	if (ctx->mode == S5P_JPEG_DECODE)
+		ctrl->flags |= V4L2_CTRL_FLAG_VOLATILE |
+			V4L2_CTRL_FLAG_READ_ONLY;
 	return 0;
 }
 
@@ -888,9 +957,6 @@ static const struct v4l2_ioctl_ops s5p_jpeg_ioctl_ops = {
 	.vidioc_streamoff		= s5p_jpeg_streamoff,
 
 	.vidioc_g_selection		= s5p_jpeg_g_selection,
-
-	.vidioc_g_jpegcomp		= s5p_jpeg_g_jpegcomp,
-	.vidioc_s_jpegcomp		= s5p_jpeg_s_jpegcomp,
 };
 
 /*
@@ -919,13 +985,8 @@ static void s5p_jpeg_device_run(void *priv)
 			jpeg_input_raw_mode(jpeg->regs, S5P_JPEG_RAW_IN_565);
 		else
 			jpeg_input_raw_mode(jpeg->regs, S5P_JPEG_RAW_IN_422);
-		if (ctx->cap_q.fmt->fourcc == V4L2_PIX_FMT_YUYV)
-			jpeg_subsampling_mode(jpeg->regs,
-					      S5P_JPEG_SUBSAMPLING_422);
-		else
-			jpeg_subsampling_mode(jpeg->regs,
-					      S5P_JPEG_SUBSAMPLING_420);
-		jpeg_dri(jpeg->regs, 0);
+		jpeg_subsampling_mode(jpeg->regs, ctx->subsampling);
+		jpeg_dri(jpeg->regs, ctx->restart_interval);
 		jpeg_x(jpeg->regs, ctx->out_q.w);
 		jpeg_y(jpeg->regs, ctx->out_q.h);
 		jpeg_imgadr(jpeg->regs, src_addr);
@@ -972,6 +1033,7 @@ static void s5p_jpeg_device_run(void *priv)
 		jpeg_jpgadr(jpeg->regs, src_addr);
 		jpeg_imgadr(jpeg->regs, dst_addr);
 	}
+
 	jpeg_start(jpeg->regs);
 }
 
@@ -1173,6 +1235,8 @@ static irqreturn_t s5p_jpeg_irq(int irq, void *dev_id)
 	bool timer_elapsed = false;
 	bool op_completed = false;
 
+	spin_lock(&jpeg->slock);
+
 	curr_ctx = v4l2_m2m_get_curr_priv(jpeg->m2m_dev);
 
 	src_buf = v4l2_m2m_src_buf_remove(curr_ctx->m2m_ctx);
@@ -1203,6 +1267,8 @@ static irqreturn_t s5p_jpeg_irq(int irq, void *dev_id)
 	v4l2_m2m_buf_done(dst_buf, state);
 	v4l2_m2m_job_finish(jpeg->m2m_dev, curr_ctx->m2m_ctx);
 
+	curr_ctx->subsampling = jpeg_get_subsampling_mode(jpeg->regs);
+	spin_unlock(&jpeg->slock);
 	jpeg_clear_int(jpeg->regs);
 
 	return IRQ_HANDLED;
@@ -1226,6 +1292,7 @@ static int s5p_jpeg_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	mutex_init(&jpeg->lock);
+	spin_lock_init(&jpeg->slock);
 	jpeg->dev = &pdev->dev;
 
 	/* memory-mapped registers */
diff --git a/drivers/media/video/s5p-jpeg/jpeg-core.h b/drivers/media/video/s5p-jpeg/jpeg-core.h
index 4dd705f..38d7367 100644
--- a/drivers/media/video/s5p-jpeg/jpeg-core.h
+++ b/drivers/media/video/s5p-jpeg/jpeg-core.h
@@ -15,6 +15,7 @@
 
 #include <media/v4l2-device.h>
 #include <media/v4l2-fh.h>
+#include <media/v4l2-ctrls.h>
 
 #define S5P_JPEG_M2M_NAME		"s5p-jpeg"
 
@@ -48,6 +49,7 @@
 /**
  * struct s5p_jpeg - JPEG IP abstraction
  * @lock:		the mutex protecting this structure
+ * @slock:		spinlock protecting the device contexts
  * @v4l2_dev:		v4l2 device for mem2mem mode
  * @vfd_encoder:	video device node for encoder mem2mem mode
  * @vfd_decoder:	video device node for decoder mem2mem mode
@@ -61,6 +63,7 @@
  */
 struct s5p_jpeg {
 	struct mutex		lock;
+	struct spinlock		slock;
 
 	struct v4l2_device	v4l2_dev;
 	struct video_device	*vfd_encoder;
@@ -118,16 +121,20 @@ struct s5p_jpeg_q_data {
  * @out_q:		source (output) queue information
  * @cap_fmt:		destination (capture) queue queue information
  * @hdr_parsed:		set if header has been parsed during decompression
+ * @ctrl_handler:	controls handler
  */
 struct s5p_jpeg_ctx {
 	struct s5p_jpeg		*jpeg;
 	unsigned int		mode;
-	unsigned int		compr_quality;
+	unsigned short		compr_quality;
+	unsigned short		restart_interval;
+	unsigned short		subsampling;
 	struct v4l2_m2m_ctx	*m2m_ctx;
 	struct s5p_jpeg_q_data	out_q;
 	struct s5p_jpeg_q_data	cap_q;
 	struct v4l2_fh		fh;
 	bool			hdr_parsed;
+	struct v4l2_ctrl_handler ctrl_handler;
 };
 
 /**
diff --git a/drivers/media/video/s5p-jpeg/jpeg-hw.h b/drivers/media/video/s5p-jpeg/jpeg-hw.h
index e10c744..f12f0fd 100644
--- a/drivers/media/video/s5p-jpeg/jpeg-hw.h
+++ b/drivers/media/video/s5p-jpeg/jpeg-hw.h
@@ -13,6 +13,7 @@
 #define JPEG_HW_H_
 
 #include <linux/io.h>
+#include <linux/videodev2.h>
 
 #include "jpeg-hw.h"
 #include "jpeg-regs.h"
@@ -25,8 +26,6 @@
 #define S5P_JPEG_DECODE			1
 #define S5P_JPEG_RAW_IN_565		0
 #define S5P_JPEG_RAW_IN_422		1
-#define S5P_JPEG_SUBSAMPLING_422	0
-#define S5P_JPEG_SUBSAMPLING_420	1
 #define S5P_JPEG_RAW_OUT_422		0
 #define S5P_JPEG_RAW_OUT_420		1
 
@@ -91,21 +90,26 @@ static inline void jpeg_proc_mode(void __iomem *regs, unsigned long mode)
 	writel(reg, regs + S5P_JPGMOD);
 }
 
-static inline void jpeg_subsampling_mode(void __iomem *regs, unsigned long mode)
+static inline void jpeg_subsampling_mode(void __iomem *regs, unsigned int mode)
 {
 	unsigned long reg, m;
 
-	m = S5P_SUBSAMPLING_MODE_422;
-	if (mode == S5P_JPEG_SUBSAMPLING_422)
-		m = S5P_SUBSAMPLING_MODE_422;
-	else if (mode == S5P_JPEG_SUBSAMPLING_420)
+	if (mode == V4L2_JPEG_CHROMA_SUBSAMPLING_420)
 		m = S5P_SUBSAMPLING_MODE_420;
+	else
+		m = S5P_SUBSAMPLING_MODE_422;
+
 	reg = readl(regs + S5P_JPGMOD);
 	reg &= ~S5P_SUBSAMPLING_MODE_MASK;
 	reg |= m;
 	writel(reg, regs + S5P_JPGMOD);
 }
 
+static inline unsigned int jpeg_get_subsampling_mode(void __iomem *regs)
+{
+	return readl(regs + S5P_JPGMOD) & S5P_SUBSAMPLING_MODE_MASK;
+}
+
 static inline void jpeg_dri(void __iomem *regs, unsigned int dri)
 {
 	unsigned long reg;
-- 
1.7.9

