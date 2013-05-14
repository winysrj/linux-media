Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:15421 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753005Ab3ENLuv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 May 2013 07:50:51 -0400
From: George Joseph <george.jp@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: s.nawrocki@samsung.com, a.hajda@samsung.com, ym.song@samsung.com
Subject: [RFC PATCH 1/3] [media] s5p-jpeg: Add support for Exynos4x12 and 5250
Date: Tue, 14 May 2013 17:23:38 +0530
Message-id: <1368532420-21555-2-git-send-email-george.jp@samsung.com>
In-reply-to: <1368532420-21555-1-git-send-email-george.jp@samsung.com>
References: <1368532420-21555-1-git-send-email-george.jp@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: George Joseph Palathingal <george.jp@samsung.com>

Refactored the s5p-jpeg driver and added support for Exynos4x12 and 5250

Signed-off-by: George Joseph Palathingal <george.jp@samsung.com>
---
 drivers/media/platform/s5p-jpeg/Makefile       |    4 +-
 drivers/media/platform/s5p-jpeg/jpeg-core.c    | 2009 ++++++++++--------------
 drivers/media/platform/s5p-jpeg/jpeg-core.h    |  428 +++--
 drivers/media/platform/s5p-jpeg/jpeg-dec.c     |  489 ++++++
 drivers/media/platform/s5p-jpeg/jpeg-enc.c     |  521 ++++++
 drivers/media/platform/s5p-jpeg/jpeg-hw-v1.h   |  528 +++++++
 drivers/media/platform/s5p-jpeg/jpeg-hw-v2.c   |  614 ++++++++
 drivers/media/platform/s5p-jpeg/jpeg-hw-v2.h   |   47 +
 drivers/media/platform/s5p-jpeg/jpeg-hw.h      |  357 -----
 drivers/media/platform/s5p-jpeg/jpeg-regs-v1.h |  171 ++
 drivers/media/platform/s5p-jpeg/jpeg-regs-v2.h |  191 +++
 drivers/media/platform/s5p-jpeg/jpeg-regs.h    |  170 --
 12 files changed, 3734 insertions(+), 1795 deletions(-)
 create mode 100644 drivers/media/platform/s5p-jpeg/jpeg-dec.c
 create mode 100644 drivers/media/platform/s5p-jpeg/jpeg-enc.c
 create mode 100644 drivers/media/platform/s5p-jpeg/jpeg-hw-v1.h
 create mode 100644 drivers/media/platform/s5p-jpeg/jpeg-hw-v2.c
 create mode 100644 drivers/media/platform/s5p-jpeg/jpeg-hw-v2.h
 delete mode 100644 drivers/media/platform/s5p-jpeg/jpeg-hw.h
 create mode 100644 drivers/media/platform/s5p-jpeg/jpeg-regs-v1.h
 create mode 100644 drivers/media/platform/s5p-jpeg/jpeg-regs-v2.h
 delete mode 100644 drivers/media/platform/s5p-jpeg/jpeg-regs.h

diff --git a/drivers/media/platform/s5p-jpeg/Makefile b/drivers/media/platform/s5p-jpeg/Makefile
index ddc2900..e564fc0 100644
--- a/drivers/media/platform/s5p-jpeg/Makefile
+++ b/drivers/media/platform/s5p-jpeg/Makefile
@@ -1,2 +1,1 @@
-s5p-jpeg-objs := jpeg-core.o
-obj-$(CONFIG_VIDEO_SAMSUNG_S5P_JPEG) := s5p-jpeg.o
+obj-$(CONFIG_VIDEO_SAMSUNG_S5P_JPEG)	+= jpeg-core.o jpeg-enc.o jpeg-dec.o jpeg-hw-v2.o
diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index 15d2396..f964566 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -1,7 +1,7 @@
 /* linux/drivers/media/platform/s5p-jpeg/jpeg-core.c
  *
  * Copyright (c) 2011 Samsung Electronics Co., Ltd.
- *		http://www.samsung.com
+ *              http://www.samsung.com
  *
  * Author: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
  *
@@ -10,865 +10,441 @@
  * published by the Free Software Foundation.
  */
 
-#include <linux/clk.h>
-#include <linux/err.h>
-#include <linux/gfp.h>
+#include <asm/page.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/version.h>
+#include <linux/errno.h>
+#include <linux/fs.h>
+#include <linux/irq.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/platform_device.h>
-#include <linux/pm_runtime.h>
 #include <linux/slab.h>
-#include <linux/spinlock.h>
-#include <linux/string.h>
-#include <media/v4l2-mem2mem.h>
-#include <media/v4l2-ioctl.h>
-#include <media/videobuf2-core.h>
+#include <linux/err.h>
+#include <linux/miscdevice.h>
+#include <linux/platform_device.h>
+#include <linux/mm.h>
+#include <linux/init.h>
+#include <linux/poll.h>
+#include <linux/signal.h>
+#include <linux/ioport.h>
+#include <linux/kmod.h>
+#include <linux/vmalloc.h>
+#include <linux/time.h>
+#include <linux/clk.h>
+#include <linux/semaphore.h>
+#include <linux/vmalloc.h>
+#include <linux/workqueue.h>
+#include <linux/pm.h>
+#include <linux/of.h>
+#include <mach/irqs.h>
 #include <media/videobuf2-dma-contig.h>
+#include <media/v4l2-ioctl.h>
 
 #include "jpeg-core.h"
-#include "jpeg-hw.h"
-
-static struct s5p_jpeg_fmt formats_enc[] = {
-	{
-		.name		= "JPEG JFIF",
-		.fourcc		= V4L2_PIX_FMT_JPEG,
-		.colplanes	= 1,
-		.types		= MEM2MEM_CAPTURE,
-	},
-	{
-		.name		= "YUV 4:2:2 packed, YCbYCr",
-		.fourcc		= V4L2_PIX_FMT_YUYV,
-		.depth		= 16,
-		.colplanes	= 1,
-		.types		= MEM2MEM_OUTPUT,
-	},
-	{
-		.name		= "RGB565",
-		.fourcc		= V4L2_PIX_FMT_RGB565,
-		.depth		= 16,
-		.colplanes	= 1,
-		.types		= MEM2MEM_OUTPUT,
-	},
-};
-#define NUM_FORMATS_ENC ARRAY_SIZE(formats_enc)
-
-static struct s5p_jpeg_fmt formats_dec[] = {
-	{
-		.name		= "YUV 4:2:0 planar, YCbCr",
-		.fourcc		= V4L2_PIX_FMT_YUV420,
-		.depth		= 12,
-		.colplanes	= 3,
-		.h_align	= 4,
-		.v_align	= 4,
-		.types		= MEM2MEM_CAPTURE,
-	},
-	{
-		.name		= "YUV 4:2:2 packed, YCbYCr",
-		.fourcc		= V4L2_PIX_FMT_YUYV,
-		.depth		= 16,
-		.colplanes	= 1,
-		.h_align	= 4,
-		.v_align	= 3,
-		.types		= MEM2MEM_CAPTURE,
-	},
-	{
-		.name		= "JPEG JFIF",
-		.fourcc		= V4L2_PIX_FMT_JPEG,
-		.colplanes	= 1,
-		.types		= MEM2MEM_OUTPUT,
-	},
-};
-#define NUM_FORMATS_DEC ARRAY_SIZE(formats_dec)
-
-static const unsigned char qtbl_luminance[4][64] = {
-	{/* level 1 - high quality */
-		 8,  6,  6,  8, 12, 14, 16, 17,
-		 6,  6,  6,  8, 10, 13, 12, 15,
-		 6,  6,  7,  8, 13, 14, 18, 24,
-		 8,  8,  8, 14, 13, 19, 24, 35,
-		12, 10, 13, 13, 20, 26, 34, 39,
-		14, 13, 14, 19, 26, 34, 39, 39,
-		16, 12, 18, 24, 34, 39, 39, 39,
-		17, 15, 24, 35, 39, 39, 39, 39
-	},
-	{/* level 2 */
-		12,  8,  8, 12, 17, 21, 24, 23,
-		 8,  9,  9, 11, 15, 19, 18, 23,
-		 8,  9, 10, 12, 19, 20, 27, 36,
-		12, 11, 12, 21, 20, 28, 36, 53,
-		17, 15, 19, 20, 30, 39, 51, 59,
-		21, 19, 20, 28, 39, 51, 59, 59,
-		24, 18, 27, 36, 51, 59, 59, 59,
-		23, 23, 36, 53, 59, 59, 59, 59
-	},
-	{/* level 3 */
-		16, 11, 11, 16, 23, 27, 31, 30,
-		11, 12, 12, 15, 20, 23, 23, 30,
-		11, 12, 13, 16, 23, 26, 35, 47,
-		16, 15, 16, 23, 26, 37, 47, 64,
-		23, 20, 23, 26, 39, 51, 64, 64,
-		27, 23, 26, 37, 51, 64, 64, 64,
-		31, 23, 35, 47, 64, 64, 64, 64,
-		30, 30, 47, 64, 64, 64, 64, 64
-	},
-	{/*level 4 - low quality */
-		20, 16, 25, 39, 50, 46, 62, 68,
-		16, 18, 23, 38, 38, 53, 65, 68,
-		25, 23, 31, 38, 53, 65, 68, 68,
-		39, 38, 38, 53, 65, 68, 68, 68,
-		50, 38, 53, 65, 68, 68, 68, 68,
-		46, 53, 65, 68, 68, 68, 68, 68,
-		62, 65, 68, 68, 68, 68, 68, 68,
-		68, 68, 68, 68, 68, 68, 68, 68
-	}
-};
-
-static const unsigned char qtbl_chrominance[4][64] = {
-	{/* level 1 - high quality */
-		 9,  8,  9, 11, 14, 17, 19, 24,
-		 8, 10,  9, 11, 14, 13, 17, 22,
-		 9,  9, 13, 14, 13, 15, 23, 26,
-		11, 11, 14, 14, 15, 20, 26, 33,
-		14, 14, 13, 15, 20, 24, 33, 39,
-		17, 13, 15, 20, 24, 32, 39, 39,
-		19, 17, 23, 26, 33, 39, 39, 39,
-		24, 22, 26, 33, 39, 39, 39, 39
-	},
-	{/* level 2 */
-		13, 11, 13, 16, 20, 20, 29, 37,
-		11, 14, 14, 14, 16, 20, 26, 32,
-		13, 14, 15, 17, 20, 23, 35, 40,
-		16, 14, 17, 21, 23, 30, 40, 50,
-		20, 16, 20, 23, 30, 37, 50, 59,
-		20, 20, 23, 30, 37, 48, 59, 59,
-		29, 26, 35, 40, 50, 59, 59, 59,
-		37, 32, 40, 50, 59, 59, 59, 59
-	},
-	{/* level 3 */
-		17, 15, 17, 21, 20, 26, 38, 48,
-		15, 19, 18, 17, 20, 26, 35, 43,
-		17, 18, 20, 22, 26, 30, 46, 53,
-		21, 17, 22, 28, 30, 39, 53, 64,
-		20, 20, 26, 30, 39, 48, 64, 64,
-		26, 26, 30, 39, 48, 63, 64, 64,
-		38, 35, 46, 53, 64, 64, 64, 64,
-		48, 43, 53, 64, 64, 64, 64, 64
-	},
-	{/*level 4 - low quality */
-		21, 25, 32, 38, 54, 68, 68, 68,
-		25, 28, 24, 38, 54, 68, 68, 68,
-		32, 24, 32, 43, 66, 68, 68, 68,
-		38, 38, 43, 53, 68, 68, 68, 68,
-		54, 54, 66, 68, 68, 68, 68, 68,
-		68, 68, 68, 68, 68, 68, 68, 68,
-		68, 68, 68, 68, 68, 68, 68, 68,
-		68, 68, 68, 68, 68, 68, 68, 68
-	}
-};
+#include "jpeg-hw-v1.h"
+#include "jpeg-hw-v2.h"
+#include "jpeg-regs-v1.h"
+#include "jpeg-regs-v2.h"
 
-static const unsigned char hdctbl0[16] = {
-	0, 1, 5, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0
-};
-
-static const unsigned char hdctblg0[12] = {
-	0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 0xa, 0xb
-};
-static const unsigned char hactbl0[16] = {
-	0, 2, 1, 3, 3, 2, 4, 3, 5, 5, 4, 4, 0, 0, 1, 0x7d
-};
-static const unsigned char hactblg0[162] = {
-	0x01, 0x02, 0x03, 0x00, 0x04, 0x11, 0x05, 0x12,
-	0x21, 0x31, 0x41, 0x06, 0x13, 0x51, 0x61, 0x07,
-	0x22, 0x71, 0x14, 0x32, 0x81, 0x91, 0xa1, 0x08,
-	0x23, 0x42, 0xb1, 0xc1, 0x15, 0x52, 0xd1, 0xf0,
-	0x24, 0x33, 0x62, 0x72, 0x82, 0x09, 0x0a, 0x16,
-	0x17, 0x18, 0x19, 0x1a, 0x25, 0x26, 0x27, 0x28,
-	0x29, 0x2a, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39,
-	0x3a, 0x43, 0x44, 0x45, 0x46, 0x47, 0x48, 0x49,
-	0x4a, 0x53, 0x54, 0x55, 0x56, 0x57, 0x58, 0x59,
-	0x5a, 0x63, 0x64, 0x65, 0x66, 0x67, 0x68, 0x69,
-	0x6a, 0x73, 0x74, 0x75, 0x76, 0x77, 0x78, 0x79,
-	0x7a, 0x83, 0x84, 0x85, 0x86, 0x87, 0x88, 0x89,
-	0x8a, 0x92, 0x93, 0x94, 0x95, 0x96, 0x97, 0x98,
-	0x99, 0x9a, 0xa2, 0xa3, 0xa4, 0xa5, 0xa6, 0xa7,
-	0xa8, 0xa9, 0xaa, 0xb2, 0xb3, 0xb4, 0xb5, 0xb6,
-	0xb7, 0xb8, 0xb9, 0xba, 0xc2, 0xc3, 0xc4, 0xc5,
-	0xc6, 0xc7, 0xc8, 0xc9, 0xca, 0xd2, 0xd3, 0xd4,
-	0xd5, 0xd6, 0xd7, 0xd8, 0xd9, 0xda, 0xe1, 0xe2,
-	0xe3, 0xe4, 0xe5, 0xe6, 0xe7, 0xe8, 0xe9, 0xea,
-	0xf1, 0xf2, 0xf3, 0xf4, 0xf5, 0xf6, 0xf7, 0xf8,
-	0xf9, 0xfa
-};
-
-static inline struct s5p_jpeg_ctx *ctrl_to_ctx(struct v4l2_ctrl *c)
+void jpeg_watchdog(unsigned long arg)
 {
-	return container_of(c->handler, struct s5p_jpeg_ctx, ctrl_handler);
-}
-
-static inline struct s5p_jpeg_ctx *fh_to_ctx(struct v4l2_fh *fh)
-{
-	return container_of(fh, struct s5p_jpeg_ctx, fh);
-}
-
-static inline void jpeg_set_qtbl(void __iomem *regs, const unsigned char *qtbl,
-		   unsigned long tab, int len)
-{
-	int i;
+	struct jpeg_dev *dev = (struct jpeg_dev *)arg;
 
-	for (i = 0; i < len; i++)
-		writel((unsigned int)qtbl[i], regs + tab + (i * 0x04));
-}
-
-static inline void jpeg_set_qtbl_lum(void __iomem *regs, int quality)
-{
-	/* this driver fills quantisation table 0 with data for luma */
-	jpeg_set_qtbl(regs, qtbl_luminance[quality], S5P_JPG_QTBL_CONTENT(0),
-		      ARRAY_SIZE(qtbl_luminance[quality]));
-}
-
-static inline void jpeg_set_qtbl_chr(void __iomem *regs, int quality)
-{
-	/* this driver fills quantisation table 1 with data for chroma */
-	jpeg_set_qtbl(regs, qtbl_chrominance[quality], S5P_JPG_QTBL_CONTENT(1),
-		      ARRAY_SIZE(qtbl_chrominance[quality]));
-}
-
-static inline void jpeg_set_htbl(void __iomem *regs, const unsigned char *htbl,
-		   unsigned long tab, int len)
-{
-	int i;
-
-	for (i = 0; i < len; i++)
-		writel((unsigned int)htbl[i], regs + tab + (i * 0x04));
-}
-
-static inline void jpeg_set_hdctbl(void __iomem *regs)
-{
-	/* this driver fills table 0 for this component */
-	jpeg_set_htbl(regs, hdctbl0, S5P_JPG_HDCTBL(0), ARRAY_SIZE(hdctbl0));
-}
+	dev_dbg(&dev->plat_dev->dev, "jpeg_watchdog\n");
+	if (test_bit(0, &dev->hw_run)) {
+		atomic_inc(&dev->watchdog_cnt);
+		dev_dbg(&dev->plat_dev->dev, "jpeg_watchdog_count\n");
+	}
 
-static inline void jpeg_set_hdctblg(void __iomem *regs)
-{
-	/* this driver fills table 0 for this component */
-	jpeg_set_htbl(regs, hdctblg0, S5P_JPG_HDCTBLG(0), ARRAY_SIZE(hdctblg0));
-}
+	if (atomic_read(&dev->watchdog_cnt) >= JPEG_WATCHDOG_CNT)
+		queue_work(dev->watchdog_workqueue, &dev->watchdog_work);
 
-static inline void jpeg_set_hactbl(void __iomem *regs)
-{
-	/* this driver fills table 0 for this component */
-	jpeg_set_htbl(regs, hactbl0, S5P_JPG_HACTBL(0), ARRAY_SIZE(hactbl0));
+	dev->watchdog_timer.expires = jiffies +
+		msecs_to_jiffies(JPEG_WATCHDOG_INTERVAL);
+	add_timer(&dev->watchdog_timer);
 }
 
-static inline void jpeg_set_hactblg(void __iomem *regs)
-{
-	/* this driver fills table 0 for this component */
-	jpeg_set_htbl(regs, hactblg0, S5P_JPG_HACTBLG(0), ARRAY_SIZE(hactblg0));
-}
-
-/*
- * ============================================================================
- * Device file operations
- * ============================================================================
- */
-
-static int queue_init(void *priv, struct vb2_queue *src_vq,
-		      struct vb2_queue *dst_vq);
-static struct s5p_jpeg_fmt *s5p_jpeg_find_format(unsigned int mode,
-						 __u32 pixelformat);
-static int s5p_jpeg_controls_create(struct s5p_jpeg_ctx *ctx);
-
-static int s5p_jpeg_open(struct file *file)
+static void jpeg_watchdog_worker(struct work_struct *work)
 {
-	struct s5p_jpeg *jpeg = video_drvdata(file);
-	struct video_device *vfd = video_devdata(file);
-	struct s5p_jpeg_ctx *ctx;
-	struct s5p_jpeg_fmt *out_fmt;
-	int ret = 0;
+	struct jpeg_dev *dev;
+	struct jpeg_ctx *ctx;
+	unsigned long flags;
+	struct vb2_buffer *src_vb, *dst_vb;
 
-	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
-	if (!ctx)
-		return -ENOMEM;
+	dev_dbg(&dev->plat_dev->dev, "jpeg_watch_worker\n");
+	dev = container_of(work, struct jpeg_dev, watchdog_work);
 
-	if (mutex_lock_interruptible(&jpeg->lock)) {
-		ret = -ERESTARTSYS;
-		goto free;
-	}
+	spin_lock_irqsave(&dev->slock, flags);
+	clear_bit(0, &dev->hw_run);
+	if (dev->mode == ENCODING)
+		ctx = v4l2_m2m_get_curr_priv(dev->m2m_dev_enc);
+	else
+		ctx = v4l2_m2m_get_curr_priv(dev->m2m_dev_dec);
 
-	v4l2_fh_init(&ctx->fh, vfd);
-	/* Use separate control handler per file handle */
-	ctx->fh.ctrl_handler = &ctx->ctrl_handler;
-	file->private_data = &ctx->fh;
-	v4l2_fh_add(&ctx->fh);
+	if (ctx) {
+		src_vb = v4l2_m2m_src_buf_remove(ctx->m2m_ctx);
+		dst_vb = v4l2_m2m_dst_buf_remove(ctx->m2m_ctx);
 
-	ctx->jpeg = jpeg;
-	if (vfd == jpeg->vfd_encoder) {
-		ctx->mode = S5P_JPEG_ENCODE;
-		out_fmt = s5p_jpeg_find_format(ctx->mode, V4L2_PIX_FMT_RGB565);
+		v4l2_m2m_buf_done(src_vb, VB2_BUF_STATE_ERROR);
+		v4l2_m2m_buf_done(dst_vb, VB2_BUF_STATE_ERROR);
+		if (dev->mode == ENCODING)
+			v4l2_m2m_job_finish(dev->m2m_dev_enc, ctx->m2m_ctx);
+		else
+			v4l2_m2m_job_finish(dev->m2m_dev_dec, ctx->m2m_ctx);
 	} else {
-		ctx->mode = S5P_JPEG_DECODE;
-		out_fmt = s5p_jpeg_find_format(ctx->mode, V4L2_PIX_FMT_JPEG);
+		dev_err(&dev->plat_dev->dev, "watchdog_ctx is NULL\n");
 	}
 
-	ret = s5p_jpeg_controls_create(ctx);
-	if (ret < 0)
-		goto error;
-
-	ctx->m2m_ctx = v4l2_m2m_ctx_init(jpeg->m2m_dev, ctx, queue_init);
-	if (IS_ERR(ctx->m2m_ctx)) {
-		ret = PTR_ERR(ctx->m2m_ctx);
-		goto error;
-	}
-
-	ctx->out_q.fmt = out_fmt;
-	ctx->cap_q.fmt = s5p_jpeg_find_format(ctx->mode, V4L2_PIX_FMT_YUYV);
-	mutex_unlock(&jpeg->lock);
-	return 0;
-
-error:
-	v4l2_fh_del(&ctx->fh);
-	v4l2_fh_exit(&ctx->fh);
-	mutex_unlock(&jpeg->lock);
-free:
-	kfree(ctx);
-	return ret;
+	spin_unlock_irqrestore(&dev->slock, flags);
 }
 
-static int s5p_jpeg_release(struct file *file)
+static int jpeg_dec_queue_setup(struct vb2_queue *vq,
+		const struct v4l2_format *fmt, unsigned int *num_buffers,
+		unsigned int *num_planes, unsigned int sizes[],
+		void *allocators[])
 {
-	struct s5p_jpeg *jpeg = video_drvdata(file);
-	struct s5p_jpeg_ctx *ctx = fh_to_ctx(file->private_data);
-
-	mutex_lock(&jpeg->lock);
-	v4l2_m2m_ctx_release(ctx->m2m_ctx);
-	mutex_unlock(&jpeg->lock);
-	v4l2_ctrl_handler_free(&ctx->ctrl_handler);
-	v4l2_fh_del(&ctx->fh);
-	v4l2_fh_exit(&ctx->fh);
-	kfree(ctx);
+	struct jpeg_ctx *ctx = vb2_get_drv_priv(vq);
 
+	int i;
+	if (vq->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+		*num_planes = ctx->param.dec_param.in_plane;
+		for (i = 0; i < ctx->param.dec_param.in_plane; i++) {
+			sizes[i] = ctx->param.dec_param.mem_size;
+			allocators[i] = ctx->dev->alloc_ctx;
+		}
+	} else if (vq->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
+		*num_planes = ctx->param.dec_param.out_plane;
+		for (i = 0; i < ctx->param.dec_param.out_plane; i++) {
+			sizes[i] = (ctx->param.dec_param.out_width *
+				ctx->param.dec_param.out_height *
+				ctx->param.dec_param.out_depth[i]) / 8;
+			allocators[i] = ctx->dev->alloc_ctx;
+		}
+	}
 	return 0;
 }
 
-static unsigned int s5p_jpeg_poll(struct file *file,
-				 struct poll_table_struct *wait)
+static int jpeg_dec_buf_prepare(struct vb2_buffer *vb)
 {
-	struct s5p_jpeg *jpeg = video_drvdata(file);
-	struct s5p_jpeg_ctx *ctx = fh_to_ctx(file->private_data);
-	unsigned int res;
-
-	mutex_lock(&jpeg->lock);
-	res = v4l2_m2m_poll(file, ctx->m2m_ctx, wait);
-	mutex_unlock(&jpeg->lock);
-	return res;
-}
+	int i;
+	int num_plane = 0;
+	struct jpeg_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
+
+	if (vb->vb2_queue->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+		num_plane = ctx->param.dec_param.in_plane;
+		if (ctx->input_cacheable == 1)
+			ctx->dev->vb2->cache_flush(vb, num_plane);
+	} else if (vb->vb2_queue->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
+		num_plane = ctx->param.dec_param.out_plane;
+		if (ctx->output_cacheable == 1)
+			ctx->dev->vb2->cache_flush(vb, num_plane);
+	}
 
-static int s5p_jpeg_mmap(struct file *file, struct vm_area_struct *vma)
-{
-	struct s5p_jpeg *jpeg = video_drvdata(file);
-	struct s5p_jpeg_ctx *ctx = fh_to_ctx(file->private_data);
-	int ret;
+	for (i = 0; i < num_plane; i++)
+		vb2_set_plane_payload(vb, i, ctx->payload[i]);
 
-	if (mutex_lock_interruptible(&jpeg->lock))
-		return -ERESTARTSYS;
-	ret = v4l2_m2m_mmap(file, ctx->m2m_ctx, vma);
-	mutex_unlock(&jpeg->lock);
-	return ret;
+	return 0;
 }
 
-static const struct v4l2_file_operations s5p_jpeg_fops = {
-	.owner		= THIS_MODULE,
-	.open		= s5p_jpeg_open,
-	.release	= s5p_jpeg_release,
-	.poll		= s5p_jpeg_poll,
-	.unlocked_ioctl	= video_ioctl2,
-	.mmap		= s5p_jpeg_mmap,
-};
-
-/*
- * ============================================================================
- * video ioctl operations
- * ============================================================================
- */
-
-static int get_byte(struct s5p_jpeg_buffer *buf)
+static void jpeg_dec_buf_queue(struct vb2_buffer *vb)
 {
-	if (buf->curr >= buf->size)
-		return -1;
+	struct jpeg_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
 
-	return ((unsigned char *)buf->data)[buf->curr++];
+	if (ctx->m2m_ctx)
+		v4l2_m2m_buf_queue(ctx->m2m_ctx, vb);
 }
 
-static int get_word_be(struct s5p_jpeg_buffer *buf, unsigned int *word)
+static void jpeg_dec_lock(struct vb2_queue *vq)
 {
-	unsigned int temp;
-	int byte;
-
-	byte = get_byte(buf);
-	if (byte == -1)
-		return -1;
-	temp = byte << 8;
-	byte = get_byte(buf);
-	if (byte == -1)
-		return -1;
-	*word = (unsigned int)byte | temp;
-	return 0;
+	struct jpeg_ctx *ctx = vb2_get_drv_priv(vq);
+	mutex_lock(&ctx->dev->lock);
 }
 
-static void skip(struct s5p_jpeg_buffer *buf, long len)
+static void jpeg_dec_unlock(struct vb2_queue *vq)
 {
-	if (len <= 0)
-		return;
-
-	while (len--)
-		get_byte(buf);
+	struct jpeg_ctx *ctx = vb2_get_drv_priv(vq);
+	mutex_unlock(&ctx->dev->lock);
 }
 
-static bool s5p_jpeg_parse_hdr(struct s5p_jpeg_q_data *result,
-			       unsigned long buffer, unsigned long size)
+static int jpeg_enc_queue_setup(struct vb2_queue *vq,
+		 const struct v4l2_format *fmt, unsigned int *num_buffers,
+		 unsigned int *num_planes, unsigned int sizes[],
+		 void *allocators[])
 {
-	int c, components, notfound;
-	unsigned int height, width, word;
-	long length;
-	struct s5p_jpeg_buffer jpeg_buffer;
-
-	jpeg_buffer.size = size;
-	jpeg_buffer.data = buffer;
-	jpeg_buffer.curr = 0;
-
-	notfound = 1;
-	while (notfound) {
-		c = get_byte(&jpeg_buffer);
-		if (c == -1)
-			break;
-		if (c != 0xff)
-			continue;
-		do
-			c = get_byte(&jpeg_buffer);
-		while (c == 0xff);
-		if (c == -1)
-			break;
-		if (c == 0)
-			continue;
-		length = 0;
-		switch (c) {
-		/* SOF0: baseline JPEG */
-		case SOF0:
-			if (get_word_be(&jpeg_buffer, &word))
-				break;
-			if (get_byte(&jpeg_buffer) == -1)
-				break;
-			if (get_word_be(&jpeg_buffer, &height))
-				break;
-			if (get_word_be(&jpeg_buffer, &width))
-				break;
-			components = get_byte(&jpeg_buffer);
-			if (components == -1)
-				break;
-			notfound = 0;
-
-			skip(&jpeg_buffer, components * 3);
-			break;
+	struct jpeg_ctx *ctx = vb2_get_drv_priv(vq);
 
-		/* skip payload-less markers */
-		case RST ... RST + 7:
-		case SOI:
-		case EOI:
-		case TEM:
-			break;
+	int i;
+	if (vq->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+		*num_planes = ctx->param.enc_param.in_plane;
+		for (i = 0; i < ctx->param.enc_param.in_plane; i++) {
+			sizes[i] = (ctx->param.enc_param.in_width *
+				ctx->param.enc_param.in_height *
+				ctx->param.enc_param.in_depth[i]) / 8;
+			allocators[i] = ctx->dev->alloc_ctx;
+		}
 
-		/* skip uninteresting payload markers */
-		default:
-			if (get_word_be(&jpeg_buffer, &word))
-				break;
-			length = (long)word - 2;
-			skip(&jpeg_buffer, length);
-			break;
+	} else if (vq->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
+		*num_planes = ctx->param.enc_param.out_plane;
+		for (i = 0; i < ctx->param.enc_param.in_plane; i++) {
+			sizes[i] = (ctx->param.enc_param.out_width *
+				ctx->param.enc_param.out_height *
+				ctx->param.enc_param.out_depth) / 8;
+			allocators[i] = ctx->dev->alloc_ctx;
 		}
 	}
-	result->w = width;
-	result->h = height;
-	result->size = components;
-	return !notfound;
-}
-
-static int s5p_jpeg_querycap(struct file *file, void *priv,
-			   struct v4l2_capability *cap)
-{
-	struct s5p_jpeg_ctx *ctx = fh_to_ctx(priv);
 
-	if (ctx->mode == S5P_JPEG_ENCODE) {
-		strlcpy(cap->driver, S5P_JPEG_M2M_NAME " encoder",
-			sizeof(cap->driver));
-		strlcpy(cap->card, S5P_JPEG_M2M_NAME " encoder",
-			sizeof(cap->card));
-	} else {
-		strlcpy(cap->driver, S5P_JPEG_M2M_NAME " decoder",
-			sizeof(cap->driver));
-		strlcpy(cap->card, S5P_JPEG_M2M_NAME " decoder",
-			sizeof(cap->card));
-	}
-	cap->bus_info[0] = 0;
-	/*
-	 * This is only a mem-to-mem video device. The capture and output
-	 * device capability flags are left only for backward compatibility
-	 * and are scheduled for removal.
-	 */
-	cap->capabilities = V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_M2M |
-			    V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_VIDEO_OUTPUT;
 	return 0;
 }
 
-static int enum_fmt(struct s5p_jpeg_fmt *formats, int n,
-		    struct v4l2_fmtdesc *f, u32 type)
+static int jpeg_enc_buf_prepare(struct vb2_buffer *vb)
 {
-	int i, num = 0;
-
-	for (i = 0; i < n; ++i) {
-		if (formats[i].types & type) {
-			/* index-th format of type type found ? */
-			if (num == f->index)
-				break;
-			/* Correct type but haven't reached our index yet,
-			 * just increment per-type index */
-			++num;
-		}
+	int i;
+	int num_plane = 0;
+
+	struct jpeg_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
+
+	if (vb->vb2_queue->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+		num_plane = ctx->param.enc_param.in_plane;
+		if (ctx->input_cacheable == 1)
+			ctx->dev->vb2->cache_flush(vb, num_plane);
+	} else if (vb->vb2_queue->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
+		num_plane = ctx->param.enc_param.out_plane;
+		if (ctx->output_cacheable == 1)
+			ctx->dev->vb2->cache_flush(vb, num_plane);
 	}
 
-	/* Format not found */
-	if (i >= n)
-		return -EINVAL;
-
-	strlcpy(f->description, formats[i].name, sizeof(f->description));
-	f->pixelformat = formats[i].fourcc;
+	for (i = 0; i < num_plane; i++)
+		vb2_set_plane_payload(vb, i, ctx->payload[i]);
 
 	return 0;
 }
 
-static int s5p_jpeg_enum_fmt_vid_cap(struct file *file, void *priv,
-				   struct v4l2_fmtdesc *f)
+static void jpeg_enc_buf_queue(struct vb2_buffer *vb)
 {
-	struct s5p_jpeg_ctx *ctx = fh_to_ctx(priv);
-
-	if (ctx->mode == S5P_JPEG_ENCODE)
-		return enum_fmt(formats_enc, NUM_FORMATS_ENC, f,
-				MEM2MEM_CAPTURE);
-
-	return enum_fmt(formats_dec, NUM_FORMATS_DEC, f, MEM2MEM_CAPTURE);
+	struct jpeg_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
+	if (ctx->m2m_ctx)
+		v4l2_m2m_buf_queue(ctx->m2m_ctx, vb);
 }
 
-static int s5p_jpeg_enum_fmt_vid_out(struct file *file, void *priv,
-				   struct v4l2_fmtdesc *f)
+static void jpeg_enc_lock(struct vb2_queue *vq)
 {
-	struct s5p_jpeg_ctx *ctx = fh_to_ctx(priv);
-
-	if (ctx->mode == S5P_JPEG_ENCODE)
-		return enum_fmt(formats_enc, NUM_FORMATS_ENC, f,
-				MEM2MEM_OUTPUT);
-
-	return enum_fmt(formats_dec, NUM_FORMATS_DEC, f, MEM2MEM_OUTPUT);
+	struct jpeg_ctx *ctx = vb2_get_drv_priv(vq);
+	mutex_lock(&ctx->dev->lock);
 }
 
-static struct s5p_jpeg_q_data *get_q_data(struct s5p_jpeg_ctx *ctx,
-					  enum v4l2_buf_type type)
+static void jpeg_enc_unlock(struct vb2_queue *vq)
 {
-	if (type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
-		return &ctx->out_q;
-	if (type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		return &ctx->cap_q;
-
-	return NULL;
+	struct jpeg_ctx *ctx = vb2_get_drv_priv(vq);
+	mutex_unlock(&ctx->dev->lock);
 }
 
-static int s5p_jpeg_g_fmt(struct file *file, void *priv, struct v4l2_format *f)
-{
-	struct vb2_queue *vq;
-	struct s5p_jpeg_q_data *q_data = NULL;
-	struct v4l2_pix_format *pix = &f->fmt.pix;
-	struct s5p_jpeg_ctx *ct = fh_to_ctx(priv);
-
-	vq = v4l2_m2m_get_vq(ct->m2m_ctx, f->type);
-	if (!vq)
-		return -EINVAL;
-
-	if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE &&
-	    ct->mode == S5P_JPEG_DECODE && !ct->hdr_parsed)
-		return -EINVAL;
-	q_data = get_q_data(ct, f->type);
-	BUG_ON(q_data == NULL);
-
-	pix->width = q_data->w;
-	pix->height = q_data->h;
-	pix->field = V4L2_FIELD_NONE;
-	pix->pixelformat = q_data->fmt->fourcc;
-	pix->bytesperline = 0;
-	if (q_data->fmt->fourcc != V4L2_PIX_FMT_JPEG) {
-		u32 bpl = q_data->w;
-		if (q_data->fmt->colplanes == 1)
-			bpl = (bpl * q_data->fmt->depth) >> 3;
-		pix->bytesperline = bpl;
-	}
-	pix->sizeimage = q_data->size;
+static struct vb2_ops jpeg_enc_vb2_qops = {
+	.queue_setup		= jpeg_enc_queue_setup,
+	.buf_prepare		= jpeg_enc_buf_prepare,
+	.buf_queue		= jpeg_enc_buf_queue,
+	.wait_prepare		= jpeg_enc_lock,
+	.wait_finish		= jpeg_enc_unlock,
+};
 
-	return 0;
-}
+static struct vb2_ops jpeg_dec_vb2_qops = {
+	.queue_setup		= jpeg_dec_queue_setup,
+	.buf_prepare		= jpeg_dec_buf_prepare,
+	.buf_queue		= jpeg_dec_buf_queue,
+	.wait_prepare		= jpeg_dec_lock,
+	.wait_finish		= jpeg_dec_unlock,
+};
 
-static struct s5p_jpeg_fmt *s5p_jpeg_find_format(unsigned int mode,
-						 u32 pixelformat)
+static inline enum jpeg_node_type jpeg_get_node_type(struct file *file)
 {
-	unsigned int k;
-	struct s5p_jpeg_fmt *formats;
-	int n;
-
-	if (mode == S5P_JPEG_ENCODE) {
-		formats = formats_enc;
-		n = NUM_FORMATS_ENC;
-	} else {
-		formats = formats_dec;
-		n = NUM_FORMATS_DEC;
-	}
+	struct video_device *vdev = video_devdata(file);
 
-	for (k = 0; k < n; k++) {
-		struct s5p_jpeg_fmt *fmt = &formats[k];
-		if (fmt->fourcc == pixelformat)
-			return fmt;
+	if (!vdev) {
+		jpeg_err("failed to get video_device\n");
+		return JPEG_NODE_INVALID;
 	}
 
-	return NULL;
+	jpeg_dbg("video_device index: %d\n", vdev->num);
 
+	if (!strcmp(vdev->name, JPEG_DEC_NAME))
+		return JPEG_NODE_DECODER;
+	else if (!strcmp(vdev->name, JPEG_ENC_NAME))
+		return JPEG_NODE_ENCODER;
+	else
+		return JPEG_NODE_INVALID;
 }
 
-static void jpeg_bound_align_image(u32 *w, unsigned int wmin, unsigned int wmax,
-				   unsigned int walign,
-				   u32 *h, unsigned int hmin, unsigned int hmax,
-				   unsigned int halign)
+static int queue_init_dec(void *priv, struct vb2_queue *src_vq,
+		      struct vb2_queue *dst_vq)
 {
-	int width, height, w_step, h_step;
-
-	width = *w;
-	height = *h;
-
-	w_step = 1 << walign;
-	h_step = 1 << halign;
-	v4l_bound_align_image(w, wmin, wmax, walign, h, hmin, hmax, halign, 0);
+	struct jpeg_ctx *ctx = priv;
+	int ret;
 
-	if (*w < width && (*w + w_step) < wmax)
-		*w += w_step;
-	if (*h < height && (*h + h_step) < hmax)
-		*h += h_step;
+	memset(src_vq, 0, sizeof(*src_vq));
+	src_vq->type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
+	src_vq->io_modes = VB2_MMAP | VB2_USERPTR;
+	src_vq->drv_priv = ctx;
+	src_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
+	src_vq->ops = &jpeg_dec_vb2_qops;
+	src_vq->mem_ops = &vb2_dma_contig_memops;
+	src_vq->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_COPY;
+	ret = vb2_queue_init(src_vq);
+	if (ret)
+		return ret;
 
+	memset(dst_vq, 0, sizeof(*dst_vq));
+	dst_vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
+	dst_vq->io_modes = VB2_MMAP | VB2_USERPTR;
+	dst_vq->drv_priv = ctx;
+	dst_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
+	dst_vq->ops = &jpeg_dec_vb2_qops;
+	dst_vq->mem_ops = &vb2_dma_contig_memops;
+	dst_vq->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_COPY;
+	return vb2_queue_init(dst_vq);
 }
 
-static int vidioc_try_fmt(struct v4l2_format *f, struct s5p_jpeg_fmt *fmt,
-			  struct s5p_jpeg_ctx *ctx, int q_type)
+static int queue_init_enc(void *priv, struct vb2_queue *src_vq,
+		      struct vb2_queue *dst_vq)
 {
-	struct v4l2_pix_format *pix = &f->fmt.pix;
-
-	if (pix->field == V4L2_FIELD_ANY)
-		pix->field = V4L2_FIELD_NONE;
-	else if (pix->field != V4L2_FIELD_NONE)
-		return -EINVAL;
-
-	/* V4L2 specification suggests the driver corrects the format struct
-	 * if any of the dimensions is unsupported */
-	if (q_type == MEM2MEM_OUTPUT)
-		jpeg_bound_align_image(&pix->width, S5P_JPEG_MIN_WIDTH,
-				       S5P_JPEG_MAX_WIDTH, 0,
-				       &pix->height, S5P_JPEG_MIN_HEIGHT,
-				       S5P_JPEG_MAX_HEIGHT, 0);
-	else
-		jpeg_bound_align_image(&pix->width, S5P_JPEG_MIN_WIDTH,
-				       S5P_JPEG_MAX_WIDTH, fmt->h_align,
-				       &pix->height, S5P_JPEG_MIN_HEIGHT,
-				       S5P_JPEG_MAX_HEIGHT, fmt->v_align);
-
-	if (fmt->fourcc == V4L2_PIX_FMT_JPEG) {
-		if (pix->sizeimage <= 0)
-			pix->sizeimage = PAGE_SIZE;
-		pix->bytesperline = 0;
-	} else {
-		u32 bpl = pix->bytesperline;
+	struct jpeg_ctx *ctx = priv;
+	int ret;
 
-		if (fmt->colplanes > 1 && bpl < pix->width)
-			bpl = pix->width; /* planar */
+	memset(src_vq, 0, sizeof(*src_vq));
+	src_vq->type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
+	src_vq->io_modes = VB2_MMAP | VB2_USERPTR;
+	src_vq->drv_priv = ctx;
+	src_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
+	src_vq->ops = &jpeg_enc_vb2_qops;
+	src_vq->mem_ops = &vb2_dma_contig_memops;
+	src_vq->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_COPY;
 
-		if (fmt->colplanes == 1 && /* packed */
-		    (bpl << 3) * fmt->depth < pix->width)
-			bpl = (pix->width * fmt->depth) >> 3;
+	ret = vb2_queue_init(src_vq);
+	if (ret)
+		return ret;
 
-		pix->bytesperline = bpl;
-		pix->sizeimage = (pix->width * pix->height * fmt->depth) >> 3;
-	}
+	memset(dst_vq, 0, sizeof(*dst_vq));
+	dst_vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
+	dst_vq->io_modes = VB2_MMAP | VB2_USERPTR;
+	dst_vq->drv_priv = ctx;
+	dst_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
+	dst_vq->ops = &jpeg_enc_vb2_qops;
+	dst_vq->mem_ops = &vb2_dma_contig_memops;
+	dst_vq->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_COPY;
 
-	return 0;
+	return vb2_queue_init(dst_vq);
 }
 
-static int s5p_jpeg_try_fmt_vid_cap(struct file *file, void *priv,
-				  struct v4l2_format *f)
+static int s5p_jpeg_controls_create(struct jpeg_ctx *ctx);
+
+static int jpeg_m2m_open(struct file *file)
 {
-	struct s5p_jpeg_ctx *ctx = fh_to_ctx(priv);
-	struct s5p_jpeg_fmt *fmt;
-
-	fmt = s5p_jpeg_find_format(ctx->mode, f->fmt.pix.pixelformat);
-	if (!fmt || !(fmt->types & MEM2MEM_CAPTURE)) {
-		v4l2_err(&ctx->jpeg->v4l2_dev,
-			 "Fourcc format (0x%08x) invalid.\n",
-			 f->fmt.pix.pixelformat);
-		return -EINVAL;
-	}
+	struct jpeg_dev *dev = video_drvdata(file);
+	struct jpeg_ctx *ctx = NULL;
+	int ret = 0;
+	enum jpeg_node_type node;
 
-	return vidioc_try_fmt(f, fmt, ctx, MEM2MEM_CAPTURE);
-}
+	node = jpeg_get_node_type(file);
 
-static int s5p_jpeg_try_fmt_vid_out(struct file *file, void *priv,
-				  struct v4l2_format *f)
-{
-	struct s5p_jpeg_ctx *ctx = fh_to_ctx(priv);
-	struct s5p_jpeg_fmt *fmt;
-
-	fmt = s5p_jpeg_find_format(ctx->mode, f->fmt.pix.pixelformat);
-	if (!fmt || !(fmt->types & MEM2MEM_OUTPUT)) {
-		v4l2_err(&ctx->jpeg->v4l2_dev,
-			 "Fourcc format (0x%08x) invalid.\n",
-			 f->fmt.pix.pixelformat);
-		return -EINVAL;
+	if (node == JPEG_NODE_INVALID) {
+		jpeg_err("cannot specify node type\n");
+		ret = -ENOENT;
+		goto err_node_type;
 	}
 
-	return vidioc_try_fmt(f, fmt, ctx, MEM2MEM_OUTPUT);
-}
-
-static int s5p_jpeg_s_fmt(struct s5p_jpeg_ctx *ct, struct v4l2_format *f)
-{
-	struct vb2_queue *vq;
-	struct s5p_jpeg_q_data *q_data = NULL;
-	struct v4l2_pix_format *pix = &f->fmt.pix;
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
+	if (!ctx)
+		return -ENOMEM;
 
-	vq = v4l2_m2m_get_vq(ct->m2m_ctx, f->type);
-	if (!vq)
-		return -EINVAL;
+	file->private_data = ctx;
+	ctx->dev = dev;
 
-	q_data = get_q_data(ct, f->type);
-	BUG_ON(q_data == NULL);
+	spin_lock_init(&ctx->slock);
 
-	if (vb2_is_busy(vq)) {
-		v4l2_err(&ct->jpeg->v4l2_dev, "%s queue busy\n", __func__);
-		return -EBUSY;
+	ret = s5p_jpeg_controls_create(ctx);
+	if (ret < 0) {
+		dev_err(&dev->plat_dev->dev, "Failed to create jpeg controls\n");
+		return ret;
 	}
 
-	q_data->fmt = s5p_jpeg_find_format(ct->mode, pix->pixelformat);
-	q_data->w = pix->width;
-	q_data->h = pix->height;
-	if (q_data->fmt->fourcc != V4L2_PIX_FMT_JPEG)
-		q_data->size = q_data->w * q_data->h * q_data->fmt->depth >> 3;
+	if (node == JPEG_NODE_DECODER)
+			ctx->m2m_ctx =
+			v4l2_m2m_ctx_init(dev->m2m_dev_dec, ctx,
+				queue_init_dec);
 	else
-		q_data->size = pix->sizeimage;
-
-	return 0;
-}
+			ctx->m2m_ctx =
+			v4l2_m2m_ctx_init(dev->m2m_dev_enc, ctx,
+				queue_init_enc);
 
-static int s5p_jpeg_s_fmt_vid_cap(struct file *file, void *priv,
-				struct v4l2_format *f)
-{
-	int ret;
+	if (IS_ERR(ctx->m2m_ctx)) {
+		ret = PTR_ERR(ctx->m2m_ctx);
+		goto err_node_type;
+	}
+	clk_enable(dev->clk);
 
-	ret = s5p_jpeg_try_fmt_vid_cap(file, priv, f);
-	if (ret)
-		return ret;
+	return 0;
 
-	return s5p_jpeg_s_fmt(fh_to_ctx(priv), f);
+err_node_type:
+	kfree(ctx);
+	return ret;
 }
 
-static int s5p_jpeg_s_fmt_vid_out(struct file *file, void *priv,
-				struct v4l2_format *f)
+static int jpeg_m2m_release(struct file *file)
 {
-	int ret;
+	struct jpeg_ctx *ctx = file->private_data;
 
-	ret = s5p_jpeg_try_fmt_vid_out(file, priv, f);
-	if (ret)
-		return ret;
+	if (test_bit(0, &ctx->dev->hw_run) == 0)
+		del_timer_sync(&ctx->dev->watchdog_timer);
 
-	return s5p_jpeg_s_fmt(fh_to_ctx(priv), f);
-}
-
-static int s5p_jpeg_reqbufs(struct file *file, void *priv,
-			  struct v4l2_requestbuffers *reqbufs)
-{
-	struct s5p_jpeg_ctx *ctx = fh_to_ctx(priv);
+	v4l2_m2m_ctx_release(ctx->m2m_ctx);
+	v4l2_ctrl_handler_free(&ctx->ctrl_handler);
+	clk_disable(ctx->dev->clk);
+	kfree(ctx);
 
-	return v4l2_m2m_reqbufs(file, ctx->m2m_ctx, reqbufs);
+	return 0;
 }
 
-static int s5p_jpeg_querybuf(struct file *file, void *priv,
-			   struct v4l2_buffer *buf)
+static unsigned int jpeg_m2m_poll(struct file *file,
+				     struct poll_table_struct *wait)
 {
-	struct s5p_jpeg_ctx *ctx = fh_to_ctx(priv);
-
-	return v4l2_m2m_querybuf(file, ctx->m2m_ctx, buf);
+	struct jpeg_ctx *ctx = file->private_data;
+	return v4l2_m2m_poll(file, ctx->m2m_ctx, wait);
 }
 
-static int s5p_jpeg_qbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
-{
-	struct s5p_jpeg_ctx *ctx = fh_to_ctx(priv);
-
-	return v4l2_m2m_qbuf(file, ctx->m2m_ctx, buf);
-}
 
-static int s5p_jpeg_dqbuf(struct file *file, void *priv,
-			  struct v4l2_buffer *buf)
+static int jpeg_m2m_mmap(struct file *file, struct vm_area_struct *vma)
 {
-	struct s5p_jpeg_ctx *ctx = fh_to_ctx(priv);
-
-	return v4l2_m2m_dqbuf(file, ctx->m2m_ctx, buf);
+	struct jpeg_ctx *ctx = file->private_data;
+	return v4l2_m2m_mmap(file, ctx->m2m_ctx, vma);
 }
 
-static int s5p_jpeg_streamon(struct file *file, void *priv,
-			   enum v4l2_buf_type type)
-{
-	struct s5p_jpeg_ctx *ctx = fh_to_ctx(priv);
-
-	return v4l2_m2m_streamon(file, ctx->m2m_ctx, type);
-}
+static const struct v4l2_file_operations jpeg_fops = {
+	.owner		= THIS_MODULE,
+	.open		= jpeg_m2m_open,
+	.release	= jpeg_m2m_release,
+	.poll		= jpeg_m2m_poll,
+	.unlocked_ioctl = video_ioctl2,
+	.mmap		= jpeg_m2m_mmap,
+};
 
-static int s5p_jpeg_streamoff(struct file *file, void *priv,
-			    enum v4l2_buf_type type)
-{
-	struct s5p_jpeg_ctx *ctx = fh_to_ctx(priv);
+static struct video_device jpeg_enc_videodev = {
+	.name		= JPEG_ENC_NAME,
+	.fops		= &jpeg_fops,
+	.release	= video_device_release,
+	.vfl_dir	= VFL_DIR_M2M,
+	.vfl_type	= VFL_TYPE_GRABBER,
+};
 
-	return v4l2_m2m_streamoff(file, ctx->m2m_ctx, type);
-}
+static struct video_device jpeg_dec_videodev = {
+	.name		= JPEG_DEC_NAME,
+	.fops		= &jpeg_fops,
+	.release	= video_device_release,
+	.vfl_dir	= VFL_DIR_M2M,
+	.vfl_type	= VFL_TYPE_GRABBER,
+};
 
-static int s5p_jpeg_g_selection(struct file *file, void *priv,
-			 struct v4l2_selection *s)
+static inline struct jpeg_ctx *ctrl_to_ctx(struct v4l2_ctrl *c)
 {
-	struct s5p_jpeg_ctx *ctx = fh_to_ctx(priv);
-
-	if (s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT &&
-	    s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		return -EINVAL;
-
-	/* For JPEG blob active == default == bounds */
-	switch (s->target) {
-	case V4L2_SEL_TGT_CROP:
-	case V4L2_SEL_TGT_CROP_BOUNDS:
-	case V4L2_SEL_TGT_CROP_DEFAULT:
-	case V4L2_SEL_TGT_COMPOSE:
-	case V4L2_SEL_TGT_COMPOSE_DEFAULT:
-		s->r.width = ctx->out_q.w;
-		s->r.height = ctx->out_q.h;
-		break;
-	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
-	case V4L2_SEL_TGT_COMPOSE_PADDED:
-		s->r.width = ctx->cap_q.w;
-		s->r.height = ctx->cap_q.h;
-		break;
-	default:
-		return -EINVAL;
-	}
-	s->r.left = 0;
-	s->r.top = 0;
-	return 0;
+	return container_of(c->handler, struct jpeg_ctx, ctrl_handler);
 }
 
 /*
@@ -877,8 +453,8 @@ static int s5p_jpeg_g_selection(struct file *file, void *priv,
 
 static int s5p_jpeg_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
 {
-	struct s5p_jpeg_ctx *ctx = ctrl_to_ctx(ctrl);
-	struct s5p_jpeg *jpeg = ctx->jpeg;
+	struct jpeg_ctx *ctx = ctrl_to_ctx(ctrl);
+	struct jpeg_dev *jpeg = ctx->dev;
 	unsigned long flags;
 
 	switch (ctrl->id) {
@@ -899,14 +475,14 @@ static int s5p_jpeg_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
 
 static int s5p_jpeg_s_ctrl(struct v4l2_ctrl *ctrl)
 {
-	struct s5p_jpeg_ctx *ctx = ctrl_to_ctx(ctrl);
+	struct jpeg_ctx *ctx = ctrl_to_ctx(ctrl);
 	unsigned long flags;
 
-	spin_lock_irqsave(&ctx->jpeg->slock, flags);
+	spin_lock_irqsave(&ctx->dev->slock, flags);
 
 	switch (ctrl->id) {
 	case V4L2_CID_JPEG_COMPRESSION_QUALITY:
-		ctx->compr_quality = S5P_JPEG_COMPR_QUAL_WORST - ctrl->val;
+		ctx->compr_quality = QUALITY_LEVEL_4 - ctrl->val;
 		break;
 	case V4L2_CID_JPEG_RESTART_INTERVAL:
 		ctx->restart_interval = ctrl->val;
@@ -916,7 +492,7 @@ static int s5p_jpeg_s_ctrl(struct v4l2_ctrl *ctrl)
 		break;
 	}
 
-	spin_unlock_irqrestore(&ctx->jpeg->slock, flags);
+	spin_unlock_irqrestore(&ctx->dev->slock, flags);
 	return 0;
 }
 
@@ -925,14 +501,14 @@ static const struct v4l2_ctrl_ops s5p_jpeg_ctrl_ops = {
 	.s_ctrl			= s5p_jpeg_s_ctrl,
 };
 
-static int s5p_jpeg_controls_create(struct s5p_jpeg_ctx *ctx)
+static int s5p_jpeg_controls_create(struct jpeg_ctx *ctx)
 {
 	unsigned int mask = ~0x27; /* 444, 422, 420, GRAY */
 	struct v4l2_ctrl *ctrl;
 
 	v4l2_ctrl_handler_init(&ctx->ctrl_handler, 3);
 
-	if (ctx->mode == S5P_JPEG_ENCODE) {
+	if (ctx->dev->mode == ENCODING) {
 		v4l2_ctrl_new_std(&ctx->ctrl_handler, &s5p_jpeg_ctrl_ops,
 				  V4L2_CID_JPEG_COMPRESSION_QUALITY,
 				  0, 3, 1, 3);
@@ -951,49 +527,17 @@ static int s5p_jpeg_controls_create(struct s5p_jpeg_ctx *ctx)
 	if (ctx->ctrl_handler.error)
 		return ctx->ctrl_handler.error;
 
-	if (ctx->mode == S5P_JPEG_DECODE)
+	if (ctx->dev->mode == DECODING)
 		ctrl->flags |= V4L2_CTRL_FLAG_VOLATILE |
 			V4L2_CTRL_FLAG_READ_ONLY;
 	return 0;
 }
 
-static const struct v4l2_ioctl_ops s5p_jpeg_ioctl_ops = {
-	.vidioc_querycap		= s5p_jpeg_querycap,
-
-	.vidioc_enum_fmt_vid_cap	= s5p_jpeg_enum_fmt_vid_cap,
-	.vidioc_enum_fmt_vid_out	= s5p_jpeg_enum_fmt_vid_out,
-
-	.vidioc_g_fmt_vid_cap		= s5p_jpeg_g_fmt,
-	.vidioc_g_fmt_vid_out		= s5p_jpeg_g_fmt,
-
-	.vidioc_try_fmt_vid_cap		= s5p_jpeg_try_fmt_vid_cap,
-	.vidioc_try_fmt_vid_out		= s5p_jpeg_try_fmt_vid_out,
-
-	.vidioc_s_fmt_vid_cap		= s5p_jpeg_s_fmt_vid_cap,
-	.vidioc_s_fmt_vid_out		= s5p_jpeg_s_fmt_vid_out,
 
-	.vidioc_reqbufs			= s5p_jpeg_reqbufs,
-	.vidioc_querybuf		= s5p_jpeg_querybuf,
-
-	.vidioc_qbuf			= s5p_jpeg_qbuf,
-	.vidioc_dqbuf			= s5p_jpeg_dqbuf,
-
-	.vidioc_streamon		= s5p_jpeg_streamon,
-	.vidioc_streamoff		= s5p_jpeg_streamoff,
-
-	.vidioc_g_selection		= s5p_jpeg_g_selection,
-};
-
-/*
- * ============================================================================
- * mem2mem callbacks
- * ============================================================================
- */
-
-static void s5p_jpeg_device_run(void *priv)
+static void jpeg_device_enc_run_v1(void *priv)
 {
-	struct s5p_jpeg_ctx *ctx = priv;
-	struct s5p_jpeg *jpeg = ctx->jpeg;
+	struct jpeg_ctx *ctx = priv;
+	struct jpeg_dev *dev = ctx->dev;
 	struct vb2_buffer *src_buf, *dst_buf;
 	unsigned long src_addr, dst_addr;
 
@@ -1002,260 +546,349 @@ static void s5p_jpeg_device_run(void *priv)
 	src_addr = vb2_dma_contig_plane_dma_addr(src_buf, 0);
 	dst_addr = vb2_dma_contig_plane_dma_addr(dst_buf, 0);
 
-	jpeg_reset(jpeg->regs);
-	jpeg_poweron(jpeg->regs);
-	jpeg_proc_mode(jpeg->regs, ctx->mode);
-	if (ctx->mode == S5P_JPEG_ENCODE) {
-		if (ctx->out_q.fmt->fourcc == V4L2_PIX_FMT_RGB565)
-			jpeg_input_raw_mode(jpeg->regs, S5P_JPEG_RAW_IN_565);
+	dev->mode = ENCODING;
+
+	jpeg_reset(dev->reg_base);
+	jpeg_poweron(dev->reg_base);
+	jpeg_proc_mode(dev->reg_base, S5P_PROC_MODE_COMPR);
+
+		if (ctx->param.enc_param.in_fmt == YCBYCR_422_1P)
+			jpeg_input_raw_mode(dev->reg_base, S5P_JPEG_RAW_IN_422);
 		else
-			jpeg_input_raw_mode(jpeg->regs, S5P_JPEG_RAW_IN_422);
-		jpeg_subsampling_mode(jpeg->regs, ctx->subsampling);
-		jpeg_dri(jpeg->regs, ctx->restart_interval);
-		jpeg_x(jpeg->regs, ctx->out_q.w);
-		jpeg_y(jpeg->regs, ctx->out_q.h);
-		jpeg_imgadr(jpeg->regs, src_addr);
-		jpeg_jpgadr(jpeg->regs, dst_addr);
+			jpeg_input_raw_mode(dev->reg_base, S5P_JPEG_RAW_IN_565);
+
+		jpeg_subsampling_mode(dev->reg_base, ctx->subsampling);
+
+		jpeg_dri(dev->reg_base, ctx->restart_interval);
+		jpeg_x(dev->reg_base, ctx->param.enc_param.in_width);
+		jpeg_y(dev->reg_base, ctx->param.enc_param.in_height);
+		jpeg_imgadr(dev->reg_base, src_addr);
+		jpeg_jpgadr(dev->reg_base, dst_addr);
 
 		/* ultimately comes from sizeimage from userspace */
-		jpeg_enc_stream_int(jpeg->regs, ctx->cap_q.size);
+		jpeg_enc_stream_int(dev->reg_base, ctx->param.enc_param.size);
 
 		/* JPEG RGB to YCbCr conversion matrix */
-		jpeg_coef(jpeg->regs, 1, 1, S5P_JPEG_COEF11);
-		jpeg_coef(jpeg->regs, 1, 2, S5P_JPEG_COEF12);
-		jpeg_coef(jpeg->regs, 1, 3, S5P_JPEG_COEF13);
-		jpeg_coef(jpeg->regs, 2, 1, S5P_JPEG_COEF21);
-		jpeg_coef(jpeg->regs, 2, 2, S5P_JPEG_COEF22);
-		jpeg_coef(jpeg->regs, 2, 3, S5P_JPEG_COEF23);
-		jpeg_coef(jpeg->regs, 3, 1, S5P_JPEG_COEF31);
-		jpeg_coef(jpeg->regs, 3, 2, S5P_JPEG_COEF32);
-		jpeg_coef(jpeg->regs, 3, 3, S5P_JPEG_COEF33);
+		jpeg_coef(dev->reg_base, 1, 1, S5P_JPEG_COEF11);
+		jpeg_coef(dev->reg_base, 1, 2, S5P_JPEG_COEF12);
+		jpeg_coef(dev->reg_base, 1, 3, S5P_JPEG_COEF13);
+		jpeg_coef(dev->reg_base, 2, 1, S5P_JPEG_COEF21);
+		jpeg_coef(dev->reg_base, 2, 2, S5P_JPEG_COEF22);
+		jpeg_coef(dev->reg_base, 2, 3, S5P_JPEG_COEF23);
+		jpeg_coef(dev->reg_base, 3, 1, S5P_JPEG_COEF31);
+		jpeg_coef(dev->reg_base, 3, 2, S5P_JPEG_COEF32);
+		jpeg_coef(dev->reg_base, 3, 3, S5P_JPEG_COEF33);
 
 		/*
 		 * JPEG IP allows storing 4 quantization tables
 		 * We fill table 0 for luma and table 1 for chroma
 		 */
-		jpeg_set_qtbl_lum(jpeg->regs, ctx->compr_quality);
-		jpeg_set_qtbl_chr(jpeg->regs, ctx->compr_quality);
+		jpeg_set_qtbl_lum(dev->reg_base, ctx->compr_quality);
+		jpeg_set_qtbl_chr(dev->reg_base, ctx->compr_quality);
+
 		/* use table 0 for Y */
-		jpeg_qtbl(jpeg->regs, 1, 0);
+		jpeg_qtbl(dev->reg_base, 1, 0);
 		/* use table 1 for Cb and Cr*/
-		jpeg_qtbl(jpeg->regs, 2, 1);
-		jpeg_qtbl(jpeg->regs, 3, 1);
+		jpeg_qtbl(dev->reg_base, 2, 1);
+		jpeg_qtbl(dev->reg_base, 3, 1);
 
 		/* Y, Cb, Cr use Huffman table 0 */
-		jpeg_htbl_ac(jpeg->regs, 1);
-		jpeg_htbl_dc(jpeg->regs, 1);
-		jpeg_htbl_ac(jpeg->regs, 2);
-		jpeg_htbl_dc(jpeg->regs, 2);
-		jpeg_htbl_ac(jpeg->regs, 3);
-		jpeg_htbl_dc(jpeg->regs, 3);
-	} else { /* S5P_JPEG_DECODE */
-		jpeg_rst_int_enable(jpeg->regs, true);
-		jpeg_data_num_int_enable(jpeg->regs, true);
-		jpeg_final_mcu_num_int_enable(jpeg->regs, true);
-		if (ctx->cap_q.fmt->fourcc == V4L2_PIX_FMT_YUYV)
-			jpeg_outform_raw(jpeg->regs, S5P_JPEG_RAW_OUT_422);
-		else
-			jpeg_outform_raw(jpeg->regs, S5P_JPEG_RAW_OUT_420);
-		jpeg_jpgadr(jpeg->regs, src_addr);
-		jpeg_imgadr(jpeg->regs, dst_addr);
-	}
-
-	jpeg_start(jpeg->regs);
+		jpeg_htbl_ac(dev->reg_base, 1);
+		jpeg_htbl_dc(dev->reg_base, 1);
+		jpeg_htbl_ac(dev->reg_base, 2);
+		jpeg_htbl_dc(dev->reg_base, 2);
+		jpeg_htbl_ac(dev->reg_base, 3);
+		jpeg_htbl_dc(dev->reg_base, 3);
+
+	jpeg_start(dev->reg_base);
 }
 
-static int s5p_jpeg_job_ready(void *priv)
+static void jpeg_device_dec_run_v1(void *priv)
 {
-	struct s5p_jpeg_ctx *ctx = priv;
-
-	if (ctx->mode == S5P_JPEG_DECODE)
-		return ctx->hdr_parsed;
-	return 1;
-}
+	struct jpeg_ctx *ctx = priv;
+	struct jpeg_dev *dev = ctx->dev;
+	struct vb2_buffer *src_buf, *dst_buf;
+	unsigned long src_addr, dst_addr;
 
-static void s5p_jpeg_job_abort(void *priv)
-{
-}
+	dev->mode = DECODING;
 
-static struct v4l2_m2m_ops s5p_jpeg_m2m_ops = {
-	.device_run	= s5p_jpeg_device_run,
-	.job_ready	= s5p_jpeg_job_ready,
-	.job_abort	= s5p_jpeg_job_abort,
-};
+	src_buf = v4l2_m2m_next_src_buf(ctx->m2m_ctx);
+	dst_buf = v4l2_m2m_next_dst_buf(ctx->m2m_ctx);
+	src_addr = vb2_dma_contig_plane_dma_addr(src_buf, 0);
+	dst_addr = vb2_dma_contig_plane_dma_addr(dst_buf, 0);
 
-/*
- * ============================================================================
- * Queue operations
- * ============================================================================
- */
+	jpeg_reset(dev->reg_base);
+	jpeg_poweron(dev->reg_base);
+	jpeg_proc_mode(dev->reg_base, S5P_PROC_MODE_DECOMPR);
 
-static int s5p_jpeg_queue_setup(struct vb2_queue *vq,
-			   const struct v4l2_format *fmt,
-			   unsigned int *nbuffers, unsigned int *nplanes,
-			   unsigned int sizes[], void *alloc_ctxs[])
-{
-	struct s5p_jpeg_ctx *ctx = vb2_get_drv_priv(vq);
-	struct s5p_jpeg_q_data *q_data = NULL;
-	unsigned int size, count = *nbuffers;
+		jpeg_rst_int_enable(dev->reg_base, true);
+		jpeg_data_num_int_enable(dev->reg_base, true);
+		jpeg_final_mcu_num_int_enable(dev->reg_base, true);
+		if (ctx->param.dec_param.out_fmt == YCBYCR_422_1P)
+			jpeg_outform_raw(dev->reg_base, S5P_JPEG_RAW_OUT_422);
+		else
+			jpeg_outform_raw(dev->reg_base, S5P_JPEG_RAW_OUT_420);
+		jpeg_jpgadr(dev->reg_base, src_addr);
+		jpeg_imgadr(dev->reg_base, dst_addr);
 
-	q_data = get_q_data(ctx, vq->type);
-	BUG_ON(q_data == NULL);
+	jpeg_start(dev->reg_base);
+}
 
-	size = q_data->size;
 
-	/*
-	 * header is parsed during decoding and parsed information stored
-	 * in the context so we do not allow another buffer to overwrite it
-	 */
-	if (ctx->mode == S5P_JPEG_DECODE)
-		count = 1;
+static void jpeg_device_enc_run_v2(void *priv)
+{
+	struct jpeg_ctx *ctx = priv;
+	struct jpeg_dev *dev = ctx->dev;
+	struct jpeg_enc_param enc_param;
+	struct vb2_buffer *vb = NULL;
+	unsigned long src_addr = 0, dst_addr = 0, src_addr2 = 0, src_addr3 = 0;
+	unsigned long flags;
 
-	*nbuffers = count;
-	*nplanes = 1;
-	sizes[0] = size;
-	alloc_ctxs[0] = ctx->jpeg->alloc_ctx;
+	dev = ctx->dev;
+	spin_lock_irqsave(&ctx->slock, flags);
+
+	dev->mode = ENCODING;
+	enc_param = ctx->param.enc_param;
+
+	jpeg_sw_reset(dev->reg_base);
+	jpeg_set_interrupt(dev->reg_base);
+	jpeg_set_huf_table_enable(dev->reg_base, 1);
+	jpeg_set_enc_tbl(dev->reg_base);
+	jpeg_set_encode_tbl_select(dev->reg_base, enc_param.quality);
+	jpeg_set_stream_size(dev->reg_base,
+		enc_param.in_width, enc_param.in_height);
+	jpeg_set_enc_out_fmt(dev->reg_base, enc_param.out_fmt);
+	jpeg_set_enc_in_fmt(dev->reg_base, enc_param.in_fmt);
+	vb = v4l2_m2m_next_dst_buf(ctx->m2m_ctx);
+	dst_addr = vb2_dma_contig_plane_dma_addr(vb, 0);
+	jpeg_set_stream_buf_address(dev->reg_base, dst_addr);
+
+	vb = v4l2_m2m_next_src_buf(ctx->m2m_ctx);
+	src_addr = vb2_dma_contig_plane_dma_addr(vb, 0);
+	if (enc_param.in_plane == 1) {
+		src_addr2 = src_addr + enc_param.in_width*enc_param.in_height;
+			/*Here src_addr2 is the start address of U/V-component
+			of 420_1P image. Because JPEGv2x supports only 420_2P
+			and 420_3P, We are processing 420_1P as a 420_2P image.
+			Address of U/V-component will go as the
+			Address of 2nd Plane*/
+		jpeg_set_frame_buf_address(dev->reg_base,
+			enc_param.in_fmt, src_addr, src_addr2, 0);
+	} else if (enc_param.in_plane == 2) {
+		src_addr2 = vb2_dma_contig_plane_dma_addr(vb, 1);
+		jpeg_set_frame_buf_address(dev->reg_base,
+			enc_param.in_fmt, src_addr, src_addr2, 0);
+	} else if (enc_param.in_plane == 3) {
+		src_addr2 = vb2_dma_contig_plane_dma_addr(vb, 1);
+		src_addr3 = vb2_dma_contig_plane_dma_addr(vb, 2);
+		jpeg_set_frame_buf_address(dev->reg_base,
+			enc_param.in_fmt, src_addr, src_addr2, src_addr3);
+	}
 
-	return 0;
+	jpeg_set_encode_hoff_cnt(dev->reg_base, enc_param.out_fmt);
+	jpeg_set_enc_dec_mode(dev->reg_base, ENCODING);
+	spin_unlock_irqrestore(&ctx->slock, flags);
 }
 
-static int s5p_jpeg_buf_prepare(struct vb2_buffer *vb)
+static void jpeg_device_dec_run_v2(void *priv)
 {
-	struct s5p_jpeg_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
-	struct s5p_jpeg_q_data *q_data = NULL;
+	struct jpeg_ctx *ctx = priv;
+	struct jpeg_dev *dev = ctx->dev;
+	struct jpeg_dec_param dec_param;
+	struct vb2_buffer *vb = NULL;
+	unsigned long flags;
 
-	q_data = get_q_data(ctx, vb->vb2_queue->type);
-	BUG_ON(q_data == NULL);
+	dev = ctx->dev;
+	spin_lock_irqsave(&ctx->slock, flags);
+	dev_dbg(&dev->plat_dev->dev, "dec_run.\n");
 
-	if (vb2_plane_size(vb, 0) < q_data->size) {
-		pr_err("%s data will not fit into plane (%lu < %lu)\n",
-				__func__, vb2_plane_size(vb, 0),
-				(long)q_data->size);
-		return -EINVAL;
+	if (timer_pending(&ctx->dev->watchdog_timer) == 0) {
+		ctx->dev->watchdog_timer.expires = jiffies +
+			msecs_to_jiffies(JPEG_WATCHDOG_INTERVAL);
+		add_timer(&ctx->dev->watchdog_timer);
+	}
+	set_bit(0, &ctx->dev->hw_run);
+
+	dev->mode = DECODING;
+	dec_param = ctx->param.dec_param;
+
+	jpeg_sw_reset(dev->reg_base);
+	jpeg_set_interrupt(dev->reg_base);
+
+	jpeg_set_encode_tbl_select(dev->reg_base, 0);
+
+	vb = v4l2_m2m_next_src_buf(ctx->m2m_ctx);
+	jpeg_set_stream_buf_address(dev->reg_base, dev->vb2->plane_addr(vb, 0));
+
+	vb = v4l2_m2m_next_dst_buf(ctx->m2m_ctx);
+	if (dec_param.out_plane == 1)
+		jpeg_set_frame_buf_address(dev->reg_base,
+			dec_param.out_fmt, dev->vb2->plane_addr(vb, 0), 0, 0);
+	else if (dec_param.out_plane == 2)
+		jpeg_set_frame_buf_address(dev->reg_base,
+		dec_param.out_fmt, dev->vb2->plane_addr(vb, 0),
+			 dev->vb2->plane_addr(vb, 1), 0);
+	else if (dec_param.out_plane == 3)
+		jpeg_set_frame_buf_address(dev->reg_base,
+			dec_param.out_fmt, dev->vb2->plane_addr(vb, 0),
+			dev->vb2->plane_addr(vb, 1),
+						 dev->vb2->plane_addr(vb, 2));
+
+	if (dec_param.out_width > 0 && dec_param.out_height > 0) {
+		if ((dec_param.out_width * 2 == dec_param.in_width) &&
+			(dec_param.out_height * 2 == dec_param.in_height))
+			jpeg_set_dec_scaling(dev->reg_base, JPEG_SCALE_2,
+								 JPEG_SCALE_2);
+		else if ((dec_param.out_width * 4 == dec_param.in_width) &&
+			(dec_param.out_height * 4 == dec_param.in_height))
+			jpeg_set_dec_scaling(dev->reg_base, JPEG_SCALE_4,
+								 JPEG_SCALE_4);
+		else
+			jpeg_set_dec_scaling(dev->reg_base,
+				 JPEG_SCALE_NORMAL, JPEG_SCALE_NORMAL);
 	}
 
-	vb2_set_plane_payload(vb, 0, q_data->size);
+	jpeg_set_dec_out_fmt(dev->reg_base, dec_param.out_fmt);
 
-	return 0;
+	jpeg_set_dec_bitstream_size(dev->reg_base, dec_param.size);
+
+	jpeg_set_enc_dec_mode(dev->reg_base, DECODING);
+
+	spin_unlock_irqrestore(&ctx->slock, flags);
 }
 
-static void s5p_jpeg_buf_queue(struct vb2_buffer *vb)
+static void jpeg_job_enc_abort(void *priv)
 {
-	struct s5p_jpeg_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
-
-	if (ctx->mode == S5P_JPEG_DECODE &&
-	    vb->vb2_queue->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
-		struct s5p_jpeg_q_data tmp, *q_data;
-		ctx->hdr_parsed = s5p_jpeg_parse_hdr(&tmp,
-		     (unsigned long)vb2_plane_vaddr(vb, 0),
-		     min((unsigned long)ctx->out_q.size,
-			 vb2_get_plane_payload(vb, 0)));
-		if (!ctx->hdr_parsed) {
-			vb2_buffer_done(vb, VB2_BUF_STATE_ERROR);
-			return;
-		}
+}
 
-		q_data = &ctx->out_q;
-		q_data->w = tmp.w;
-		q_data->h = tmp.h;
+static void jpeg_job_dec_abort(void *priv)
+{
+}
 
-		q_data = &ctx->cap_q;
-		q_data->w = tmp.w;
-		q_data->h = tmp.h;
 
-		jpeg_bound_align_image(&q_data->w, S5P_JPEG_MIN_WIDTH,
-				       S5P_JPEG_MAX_WIDTH, q_data->fmt->h_align,
-				       &q_data->h, S5P_JPEG_MIN_HEIGHT,
-				       S5P_JPEG_MAX_HEIGHT, q_data->fmt->v_align
-				      );
-		q_data->size = q_data->w * q_data->h * q_data->fmt->depth >> 3;
-	}
-	if (ctx->m2m_ctx)
-		v4l2_m2m_buf_queue(ctx->m2m_ctx, vb);
-}
+static struct v4l2_m2m_ops *jpeg_m2m_enc_ops;
 
-static void s5p_jpeg_wait_prepare(struct vb2_queue *vq)
-{
-	struct s5p_jpeg_ctx *ctx = vb2_get_drv_priv(vq);
+static struct v4l2_m2m_ops *jpeg_m2m_dec_ops;
 
-	mutex_unlock(&ctx->jpeg->lock);
-}
+static struct v4l2_m2m_ops jpeg_m2m_enc_ops_v1 = {
+	.device_run	= jpeg_device_enc_run_v1,
+	.job_abort	= jpeg_job_enc_abort,
+};
 
-static void s5p_jpeg_wait_finish(struct vb2_queue *vq)
-{
-	struct s5p_jpeg_ctx *ctx = vb2_get_drv_priv(vq);
+static struct v4l2_m2m_ops jpeg_m2m_dec_ops_v1 = {
+	.device_run	= jpeg_device_dec_run_v1,
+	.job_abort	= jpeg_job_dec_abort,
+};
+
+static struct v4l2_m2m_ops jpeg_m2m_enc_ops_v2 = {
+	.device_run	= jpeg_device_enc_run_v2,
+	.job_abort	= jpeg_job_enc_abort,
+};
 
-	mutex_lock(&ctx->jpeg->lock);
+static struct v4l2_m2m_ops jpeg_m2m_dec_ops_v2 = {
+	.device_run	= jpeg_device_dec_run_v2,
+	.job_abort	= jpeg_job_dec_abort,
+};
+
+void s5p_jpeg_init_hw_ops(struct jpeg_dev *dev)
+{
+	if (dev->variant->version == JPEG_V2) {
+		jpeg_m2m_dec_ops = &jpeg_m2m_dec_ops_v2;
+		jpeg_m2m_enc_ops = &jpeg_m2m_enc_ops_v2;
+	} else {
+		jpeg_m2m_dec_ops = &jpeg_m2m_dec_ops_v1;
+		jpeg_m2m_enc_ops = &jpeg_m2m_enc_ops_v1;
+	}
 }
 
-static int s5p_jpeg_start_streaming(struct vb2_queue *q, unsigned int count)
+int jpeg_int_pending(struct jpeg_dev *ctrl)
 {
-	struct s5p_jpeg_ctx *ctx = vb2_get_drv_priv(q);
-	int ret;
+	unsigned int	int_status;
 
-	ret = pm_runtime_get_sync(ctx->jpeg->dev);
+	int_status = jpeg_get_int_status(ctrl->reg_base);
+	jpeg_dbg("state(%d)\n", int_status);
 
-	return ret > 0 ? 0 : ret;
+	return int_status;
 }
 
-static int s5p_jpeg_stop_streaming(struct vb2_queue *q)
+static irqreturn_t jpeg_irq_v2(int irq, void *priv)
 {
-	struct s5p_jpeg_ctx *ctx = vb2_get_drv_priv(q);
+	unsigned int int_status;
+	struct vb2_buffer *src_vb, *dst_vb;
+	struct jpeg_dev *ctrl = priv;
+	struct jpeg_ctx *ctx;
+	unsigned long payload_size = 0;
 
-	pm_runtime_put(ctx->jpeg->dev);
+	spin_lock(&ctrl->slock);
 
-	return 0;
-}
+	if (ctrl->mode == ENCODING)
+		ctx = v4l2_m2m_get_curr_priv(ctrl->m2m_dev_enc);
+	else
+		ctx = v4l2_m2m_get_curr_priv(ctrl->m2m_dev_dec);
 
-static struct vb2_ops s5p_jpeg_qops = {
-	.queue_setup		= s5p_jpeg_queue_setup,
-	.buf_prepare		= s5p_jpeg_buf_prepare,
-	.buf_queue		= s5p_jpeg_buf_queue,
-	.wait_prepare		= s5p_jpeg_wait_prepare,
-	.wait_finish		= s5p_jpeg_wait_finish,
-	.start_streaming	= s5p_jpeg_start_streaming,
-	.stop_streaming		= s5p_jpeg_stop_streaming,
-};
+	if (ctx == 0) {
+		dev_err(&ctrl->plat_dev->dev, "ctx is null.\n");
+		int_status = jpeg_int_pending(ctrl);
+		jpeg_sw_reset(ctrl->reg_base);
+		goto ctx_err;
+	}
 
-static int queue_init(void *priv, struct vb2_queue *src_vq,
-		      struct vb2_queue *dst_vq)
-{
-	struct s5p_jpeg_ctx *ctx = priv;
-	int ret;
+	src_vb = v4l2_m2m_src_buf_remove(ctx->m2m_ctx);
+	dst_vb = v4l2_m2m_dst_buf_remove(ctx->m2m_ctx);
 
-	src_vq->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
-	src_vq->io_modes = VB2_MMAP | VB2_USERPTR;
-	src_vq->drv_priv = ctx;
-	src_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
-	src_vq->ops = &s5p_jpeg_qops;
-	src_vq->mem_ops = &vb2_dma_contig_memops;
-	src_vq->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_COPY;
+	int_status = jpeg_int_pending(ctrl);
 
-	ret = vb2_queue_init(src_vq);
-	if (ret)
-		return ret;
+	if (int_status) {
+		switch (int_status & 0x1f) {
+		case 0x1:
+			ctrl->irq_ret = ERR_PROT;
+			break;
+		case 0x2:
+			ctrl->irq_ret = OK_ENC_OR_DEC;
+			break;
+		case 0x4:
+			ctrl->irq_ret = ERR_DEC_INVALID_FORMAT;
+			break;
+		case 0x8:
+			ctrl->irq_ret = ERR_MULTI_SCAN;
+			break;
+		case 0x10:
+			ctrl->irq_ret = ERR_FRAME;
+			break;
+		default:
+			ctrl->irq_ret = ERR_UNKNOWN;
+			break;
+		}
+	} else {
+		ctrl->irq_ret = ERR_UNKNOWN;
+	}
 
-	dst_vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-	dst_vq->io_modes = VB2_MMAP | VB2_USERPTR;
-	dst_vq->drv_priv = ctx;
-	dst_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
-	dst_vq->ops = &s5p_jpeg_qops;
-	dst_vq->mem_ops = &vb2_dma_contig_memops;
-	dst_vq->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_COPY;
+	if (ctrl->irq_ret == OK_ENC_OR_DEC) {
+		if (ctrl->mode == ENCODING) {
+			payload_size = jpeg_get_stream_size(ctrl->reg_base);
+			vb2_set_plane_payload(dst_vb, 0, payload_size);
+		}
+		v4l2_m2m_buf_done(src_vb, VB2_BUF_STATE_DONE);
+		v4l2_m2m_buf_done(dst_vb, VB2_BUF_STATE_DONE);
+	} else {
+		v4l2_m2m_buf_done(src_vb, VB2_BUF_STATE_ERROR);
+		v4l2_m2m_buf_done(dst_vb, VB2_BUF_STATE_ERROR);
+	}
 
-	return vb2_queue_init(dst_vq);
+	clear_bit(0, &ctx->dev->hw_run);
+	if (ctrl->mode == ENCODING)
+		v4l2_m2m_job_finish(ctrl->m2m_dev_enc, ctx->m2m_ctx);
+	else
+		v4l2_m2m_job_finish(ctrl->m2m_dev_dec, ctx->m2m_ctx);
+ctx_err:
+	spin_unlock(&ctrl->slock);
+	return IRQ_HANDLED;
 }
 
-/*
- * ============================================================================
- * ISR
- * ============================================================================
- */
-
-static irqreturn_t s5p_jpeg_irq(int irq, void *dev_id)
+static irqreturn_t jpeg_irq_v1(int irq, void *dev_id)
 {
-	struct s5p_jpeg *jpeg = dev_id;
-	struct s5p_jpeg_ctx *curr_ctx;
+	struct jpeg_dev *jpeg = dev_id;
+	struct jpeg_ctx *curr_ctx;
 	struct vb2_buffer *src_buf, *dst_buf;
 	unsigned long payload_size = 0;
 	enum vb2_buffer_state state = VB2_BUF_STATE_DONE;
@@ -1265,267 +898,355 @@ static irqreturn_t s5p_jpeg_irq(int irq, void *dev_id)
 
 	spin_lock(&jpeg->slock);
 
-	curr_ctx = v4l2_m2m_get_curr_priv(jpeg->m2m_dev);
+	if (jpeg->mode == ENCODING)
+		curr_ctx = v4l2_m2m_get_curr_priv(jpeg->m2m_dev_dec);
+
+	else
+		curr_ctx = v4l2_m2m_get_curr_priv(jpeg->m2m_dev_dec);
+
+
+	if (curr_ctx == 0) {
+		dev_err(&jpeg->plat_dev->dev, "The ctx is null\n");
+		goto ctx_err;
+	}
+
 
 	src_buf = v4l2_m2m_src_buf_remove(curr_ctx->m2m_ctx);
 	dst_buf = v4l2_m2m_dst_buf_remove(curr_ctx->m2m_ctx);
 
-	if (curr_ctx->mode == S5P_JPEG_ENCODE)
-		enc_jpeg_too_large = jpeg_enc_stream_stat(jpeg->regs);
-	timer_elapsed = jpeg_timer_stat(jpeg->regs);
-	op_completed = jpeg_result_stat_ok(jpeg->regs);
-	if (curr_ctx->mode == S5P_JPEG_DECODE)
-		op_completed = op_completed && jpeg_stream_stat_ok(jpeg->regs);
+	if (jpeg->mode == ENCODING)
+		enc_jpeg_too_large = jpeg_enc_stream_stat(jpeg->reg_base);
+	timer_elapsed = jpeg_timer_stat(jpeg->reg_base);
+	op_completed = jpeg_result_stat_ok(jpeg->reg_base);
+	if (jpeg->mode == DECODING)
+		op_completed =
+			 op_completed && jpeg_stream_stat_ok(jpeg->reg_base);
 
 	if (enc_jpeg_too_large) {
 		state = VB2_BUF_STATE_ERROR;
-		jpeg_clear_enc_stream_stat(jpeg->regs);
+		jpeg_clear_enc_stream_stat(jpeg->reg_base);
 	} else if (timer_elapsed) {
 		state = VB2_BUF_STATE_ERROR;
-		jpeg_clear_timer_stat(jpeg->regs);
+		jpeg_clear_timer_stat(jpeg->reg_base);
 	} else if (!op_completed) {
 		state = VB2_BUF_STATE_ERROR;
 	} else {
-		payload_size = jpeg_compressed_size(jpeg->regs);
+		payload_size = jpeg_compressed_size(jpeg->reg_base);
 	}
 
-	dst_buf->v4l2_buf.timecode = src_buf->v4l2_buf.timecode;
-	dst_buf->v4l2_buf.timestamp = src_buf->v4l2_buf.timestamp;
-
 	v4l2_m2m_buf_done(src_buf, state);
-	if (curr_ctx->mode == S5P_JPEG_ENCODE)
+	if (jpeg->mode == ENCODING)
 		vb2_set_plane_payload(dst_buf, 0, payload_size);
 	v4l2_m2m_buf_done(dst_buf, state);
-	v4l2_m2m_job_finish(jpeg->m2m_dev, curr_ctx->m2m_ctx);
 
-	curr_ctx->subsampling = jpeg_get_subsampling_mode(jpeg->regs);
+	if (jpeg->mode == ENCODING)
+		v4l2_m2m_job_finish(jpeg->m2m_dev_enc, curr_ctx->m2m_ctx);
+	else
+		v4l2_m2m_job_finish(jpeg->m2m_dev_dec, curr_ctx->m2m_ctx);
+
+	curr_ctx->subsampling = jpeg_get_subsampling_mode(jpeg->reg_base);
 	spin_unlock(&jpeg->slock);
 
-	jpeg_clear_int(jpeg->regs);
+	jpeg_clear_int(jpeg->reg_base);
 
 	return IRQ_HANDLED;
+ctx_err:
+	spin_unlock(&jpeg->slock);
+	return IRQ_HANDLED;
 }
 
-/*
- * ============================================================================
- * Driver basic infrastructure
- * ============================================================================
- */
+static int jpeg_setup_controller(struct jpeg_dev *ctrl)
+{
+	mutex_init(&ctrl->lock);
+	init_waitqueue_head(&ctrl->wq);
+
+	return 0;
+}
 
-static int s5p_jpeg_probe(struct platform_device *pdev)
+const struct jpeg_vb2 jpeg_vb2_dma = {
+	.ops		= &vb2_dma_contig_memops,
+	.init		= vb2_dma_contig_init_ctx,
+	.cleanup	= vb2_dma_contig_cleanup_ctx,
+	.plane_addr	= vb2_dma_contig_plane_dma_addr,
+};
+
+static int jpeg_probe(struct platform_device *pdev)
 {
-	struct s5p_jpeg *jpeg;
+	struct jpeg_dev *dev;
+	struct video_device *vfd;
 	struct resource *res;
 	int ret;
-
-	/* JPEG IP abstraction struct */
-	jpeg = devm_kzalloc(&pdev->dev, sizeof(struct s5p_jpeg), GFP_KERNEL);
-	if (!jpeg)
+	/* global structure */
+	dev = devm_kzalloc(&pdev->dev, sizeof(*dev), GFP_KERNEL);
+	if (!dev)
 		return -ENOMEM;
 
-	mutex_init(&jpeg->lock);
-	spin_lock_init(&jpeg->slock);
-	jpeg->dev = &pdev->dev;
+	dev->plat_dev = pdev;
+	dev->variant = (struct s5p_jpeg_variant *)
+				platform_get_device_id(pdev)->driver_data;
+	spin_lock_init(&dev->slock);
 
-	/* memory-mapped registers */
+	/* setup jpeg control */
+	ret = jpeg_setup_controller(dev);
+	if (ret) {
+		jpeg_err("failed to setup controller\n");
+		goto err_setup;
+	}
+
+	/* memory region */
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		jpeg_err("failed to get jpeg memory region resource\n");
+		ret = -ENOENT;
+		goto err_res;
+	}
 
-	jpeg->regs = devm_ioremap_resource(&pdev->dev, res);
-	if (IS_ERR(jpeg->regs))
-		return PTR_ERR(jpeg->regs);
+	/* ioremap */
+	dev->reg_base = devm_ioremap_resource(&pdev->dev, res);
+	if (!dev->reg_base) {
+		jpeg_err("failed to remap jpeg io region\n");
+		ret = -ENOENT;
+		goto err_map;
+	}
 
-	/* interrupt service routine registration */
-	jpeg->irq = ret = platform_get_irq(pdev, 0);
-	if (ret < 0) {
-		dev_err(&pdev->dev, "cannot find IRQ\n");
-		return ret;
+	/* irq */
+	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (!res) {
+		jpeg_err("failed to request jpeg irq resource\n");
+		ret = -ENOENT;
+		goto err_irq;
 	}
 
-	ret = devm_request_irq(&pdev->dev, jpeg->irq, s5p_jpeg_irq, 0,
-			dev_name(&pdev->dev), jpeg);
-	if (ret) {
-		dev_err(&pdev->dev, "cannot claim IRQ %d\n", jpeg->irq);
-		return ret;
+	dev->irq_no = res->start;
+	ret = devm_request_irq(&pdev->dev, dev->irq_no,
+		 (void *)dev->variant->jpeg_irq, IRQF_DISABLED,
+			 pdev->name, dev);
+	if (ret != 0) {
+		jpeg_err("failed to jpeg request irq\n");
+		ret = -ENOENT;
+		goto err_irq;
 	}
 
-	/* clocks */
-	jpeg->clk = clk_get(&pdev->dev, "jpeg");
-	if (IS_ERR(jpeg->clk)) {
-		dev_err(&pdev->dev, "cannot get clock\n");
-		ret = PTR_ERR(jpeg->clk);
-		return ret;
+	/* clock */
+	dev->clk = clk_get(&pdev->dev, "jpeg");
+	if (IS_ERR(dev->clk)) {
+		jpeg_err("failed to find jpeg clock source\n");
+		ret = -ENXIO;
+		goto err_clk;
 	}
-	dev_dbg(&pdev->dev, "clock source %p\n", jpeg->clk);
-	clk_prepare_enable(jpeg->clk);
 
-	/* v4l2 device */
-	ret = v4l2_device_register(&pdev->dev, &jpeg->v4l2_dev);
+	/* clock enable */
+	ret = clk_prepare_enable(dev->clk);
 	if (ret) {
-		dev_err(&pdev->dev, "Failed to register v4l2 device\n");
-		goto clk_get_rollback;
+		jpeg_err("failed to enable jpeg clock source\n");
+		ret = -ENOENT;
+		goto err_clk;
 	}
 
-	/* mem2mem device */
-	jpeg->m2m_dev = v4l2_m2m_init(&s5p_jpeg_m2m_ops);
-	if (IS_ERR(jpeg->m2m_dev)) {
-		v4l2_err(&jpeg->v4l2_dev, "Failed to init mem2mem device\n");
-		ret = PTR_ERR(jpeg->m2m_dev);
-		goto device_register_rollback;
+	ret = v4l2_device_register(&pdev->dev, &dev->v4l2_dev);
+	if (ret) {
+		v4l2_err(&dev->v4l2_dev, "Failed to register v4l2 device\n");
+		goto err_v4l2;
 	}
 
-	jpeg->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
-	if (IS_ERR(jpeg->alloc_ctx)) {
-		v4l2_err(&jpeg->v4l2_dev, "Failed to init memory allocator\n");
-		ret = PTR_ERR(jpeg->alloc_ctx);
-		goto m2m_init_rollback;
-	}
+	s5p_jpeg_init_hw_ops(dev);
 
-	/* JPEG encoder /dev/videoX node */
-	jpeg->vfd_encoder = video_device_alloc();
-	if (!jpeg->vfd_encoder) {
-		v4l2_err(&jpeg->v4l2_dev, "Failed to allocate video device\n");
+	/* encoder */
+	vfd = video_device_alloc();
+	if (!vfd) {
+		v4l2_err(&dev->v4l2_dev, "Failed to allocate video device\n");
 		ret = -ENOMEM;
-		goto vb2_allocator_rollback;
+		goto err_vd_alloc_enc;
 	}
-	strlcpy(jpeg->vfd_encoder->name, S5P_JPEG_M2M_NAME,
-		sizeof(jpeg->vfd_encoder->name));
-	jpeg->vfd_encoder->fops		= &s5p_jpeg_fops;
-	jpeg->vfd_encoder->ioctl_ops	= &s5p_jpeg_ioctl_ops;
-	jpeg->vfd_encoder->minor	= -1;
-	jpeg->vfd_encoder->release	= video_device_release;
-	jpeg->vfd_encoder->lock		= &jpeg->lock;
-	jpeg->vfd_encoder->v4l2_dev	= &jpeg->v4l2_dev;
-	jpeg->vfd_encoder->vfl_dir	= VFL_DIR_M2M;
-
-	ret = video_register_device(jpeg->vfd_encoder, VFL_TYPE_GRABBER, -1);
+
+	*vfd = jpeg_enc_videodev;
+	vfd->ioctl_ops = get_jpeg_enc_v4l2_ioctl_ops();
+	ret = video_register_device(vfd, VFL_TYPE_GRABBER, -1);
 	if (ret) {
-		v4l2_err(&jpeg->v4l2_dev, "Failed to register video device\n");
-		goto enc_vdev_alloc_rollback;
+		v4l2_err(&dev->v4l2_dev,
+			 "%s(): failed to register video device\n", __func__);
+		video_device_release(vfd);
+		goto err_vd_alloc_enc;
 	}
+	v4l2_info(&dev->v4l2_dev,
+		"JPEG encoder is registered to /dev/video%d\n", vfd->num);
+
+	dev->vfd_enc = vfd;
+	dev->m2m_dev_enc = v4l2_m2m_init(jpeg_m2m_enc_ops);
+	if (IS_ERR(dev->m2m_dev_enc)) {
+		v4l2_err(&dev->v4l2_dev,
+			"failed to initialize v4l2-m2m device\n");
+		ret = PTR_ERR(dev->m2m_dev_enc);
+		goto err_m2m_init_enc;
+	}
+	video_set_drvdata(vfd, dev);
 
-	video_set_drvdata(jpeg->vfd_encoder, jpeg);
-	v4l2_info(&jpeg->v4l2_dev,
-		  "encoder device registered as /dev/video%d\n",
-		  jpeg->vfd_encoder->num);
-
-	/* JPEG decoder /dev/videoX node */
-	jpeg->vfd_decoder = video_device_alloc();
-	if (!jpeg->vfd_decoder) {
-		v4l2_err(&jpeg->v4l2_dev, "Failed to allocate video device\n");
+	/* decoder */
+	vfd = video_device_alloc();
+	if (!vfd) {
+		v4l2_err(&dev->v4l2_dev, "Failed to allocate video device\n");
 		ret = -ENOMEM;
-		goto enc_vdev_register_rollback;
+		goto err_vd_alloc_dec;
 	}
-	strlcpy(jpeg->vfd_decoder->name, S5P_JPEG_M2M_NAME,
-		sizeof(jpeg->vfd_decoder->name));
-	jpeg->vfd_decoder->fops		= &s5p_jpeg_fops;
-	jpeg->vfd_decoder->ioctl_ops	= &s5p_jpeg_ioctl_ops;
-	jpeg->vfd_decoder->minor	= -1;
-	jpeg->vfd_decoder->release	= video_device_release;
-	jpeg->vfd_decoder->lock		= &jpeg->lock;
-	jpeg->vfd_decoder->v4l2_dev	= &jpeg->v4l2_dev;
-
-	ret = video_register_device(jpeg->vfd_decoder, VFL_TYPE_GRABBER, -1);
+
+	*vfd = jpeg_dec_videodev;
+	vfd->ioctl_ops = get_jpeg_dec_v4l2_ioctl_ops();
+	ret = video_register_device(vfd, VFL_TYPE_GRABBER, -1);
 	if (ret) {
-		v4l2_err(&jpeg->v4l2_dev, "Failed to register video device\n");
-		goto dec_vdev_alloc_rollback;
+		v4l2_err(&dev->v4l2_dev,
+			 "%s(): failed to register video device\n", __func__);
+		video_device_release(vfd);
+		goto err_vd_alloc_dec;
 	}
 
-	video_set_drvdata(jpeg->vfd_decoder, jpeg);
-	v4l2_info(&jpeg->v4l2_dev,
-		  "decoder device registered as /dev/video%d\n",
-		  jpeg->vfd_decoder->num);
+	v4l2_info(&dev->v4l2_dev,
+		"JPEG decoder is registered to /dev/video%d\n", vfd->num);
 
-	/* final statements & power management */
-	platform_set_drvdata(pdev, jpeg);
+	dev->vfd_dec = vfd;
+	dev->m2m_dev_dec = v4l2_m2m_init(jpeg_m2m_dec_ops);
+	if (IS_ERR(dev->m2m_dev_dec)) {
+		v4l2_err(&dev->v4l2_dev,
+			"failed to initialize v4l2-m2m device\n");
+		ret = PTR_ERR(dev->m2m_dev_dec);
+		goto err_m2m_init_dec;
+	}
+	video_set_drvdata(vfd, dev);
 
-	pm_runtime_enable(&pdev->dev);
+	platform_set_drvdata(pdev, dev);
 
-	v4l2_info(&jpeg->v4l2_dev, "Samsung S5P JPEG codec\n");
+	dev->vb2 = &jpeg_vb2_dma;
 
-	return 0;
+	dev->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
 
-dec_vdev_alloc_rollback:
-	video_device_release(jpeg->vfd_decoder);
+	if (IS_ERR(dev->alloc_ctx)) {
+		ret = PTR_ERR(dev->alloc_ctx);
+		goto err_video_reg;
+	}
 
-enc_vdev_register_rollback:
-	video_unregister_device(jpeg->vfd_encoder);
+	dev->watchdog_workqueue = create_singlethread_workqueue(JPEG_NAME);
+	INIT_WORK(&dev->watchdog_work, jpeg_watchdog_worker);
+	atomic_set(&dev->watchdog_cnt, 0);
+	init_timer(&dev->watchdog_timer);
+	dev->watchdog_timer.data = (unsigned long)dev;
+	dev->watchdog_timer.function = jpeg_watchdog;
+	clk_disable(dev->clk);
 
-enc_vdev_alloc_rollback:
-	video_device_release(jpeg->vfd_encoder);
+	return 0;
 
-vb2_allocator_rollback:
-	vb2_dma_contig_cleanup_ctx(jpeg->alloc_ctx);
+err_video_reg:
+	v4l2_m2m_release(dev->m2m_dev_dec);
+err_m2m_init_dec:
+	video_unregister_device(dev->vfd_dec);
+	video_device_release(dev->vfd_dec);
+err_vd_alloc_dec:
+	v4l2_m2m_release(dev->m2m_dev_enc);
+err_m2m_init_enc:
+	video_unregister_device(dev->vfd_enc);
+	video_device_release(dev->vfd_enc);
+err_vd_alloc_enc:
+	v4l2_device_unregister(&dev->v4l2_dev);
+err_v4l2:
+	clk_disable_unprepare(dev->clk);
+err_clk:
+	free_irq(dev->irq_no, NULL);
+err_irq:
+	iounmap(dev->reg_base);
+err_map:
+	kfree(res);
+err_res:
+	mutex_destroy(&dev->lock);
+err_setup:
+	kfree(dev);
+	return ret;
+}
 
-m2m_init_rollback:
-	v4l2_m2m_release(jpeg->m2m_dev);
+static int jpeg_remove(struct platform_device *pdev)
+{
+	struct jpeg_dev *dev = platform_get_drvdata(pdev);
 
-device_register_rollback:
-	v4l2_device_unregister(&jpeg->v4l2_dev);
+	del_timer_sync(&dev->watchdog_timer);
+	flush_workqueue(dev->watchdog_workqueue);
+	destroy_workqueue(dev->watchdog_workqueue);
 
-clk_get_rollback:
-	clk_disable_unprepare(jpeg->clk);
-	clk_put(jpeg->clk);
+	v4l2_m2m_release(dev->m2m_dev_enc);
+	video_unregister_device(dev->vfd_enc);
 
-	return ret;
-}
+	v4l2_m2m_release(dev->m2m_dev_dec);
+	video_unregister_device(dev->vfd_dec);
 
-static int s5p_jpeg_remove(struct platform_device *pdev)
-{
-	struct s5p_jpeg *jpeg = platform_get_drvdata(pdev);
+	v4l2_device_unregister(&dev->v4l2_dev);
 
-	pm_runtime_disable(jpeg->dev);
+	dev->vb2->cleanup(dev->alloc_ctx);
 
-	video_unregister_device(jpeg->vfd_decoder);
-	video_device_release(jpeg->vfd_decoder);
-	video_unregister_device(jpeg->vfd_encoder);
-	video_device_release(jpeg->vfd_encoder);
-	vb2_dma_contig_cleanup_ctx(jpeg->alloc_ctx);
-	v4l2_m2m_release(jpeg->m2m_dev);
-	v4l2_device_unregister(&jpeg->v4l2_dev);
+	free_irq(dev->irq_no, pdev);
+	mutex_destroy(&dev->lock);
+	iounmap(dev->reg_base);
 
-	clk_disable_unprepare(jpeg->clk);
-	clk_put(jpeg->clk);
+	clk_disable_unprepare(dev->clk);
+	clk_put(dev->clk);
 
+	kfree(dev);
 	return 0;
 }
 
-static int s5p_jpeg_runtime_suspend(struct device *dev)
+static int jpeg_suspend(struct platform_device *pdev, pm_message_t state)
 {
+	struct jpeg_dev *dev = platform_get_drvdata(pdev);
+
+	/* clock disable */
+	clk_disable(dev->clk);
 	return 0;
 }
 
-static int s5p_jpeg_runtime_resume(struct device *dev)
+static int jpeg_resume(struct platform_device *pdev)
 {
-	struct s5p_jpeg *jpeg = dev_get_drvdata(dev);
-	/*
-	 * JPEG IP allows storing two Huffman tables for each component
-	 * We fill table 0 for each component
-	 */
-	jpeg_set_hdctbl(jpeg->regs);
-	jpeg_set_hdctblg(jpeg->regs);
-	jpeg_set_hactbl(jpeg->regs);
-	jpeg_set_hactblg(jpeg->regs);
+	struct jpeg_dev *dev = platform_get_drvdata(pdev);
+
+	/* clock enable */
+	clk_enable(dev->clk);
 	return 0;
 }
 
-static const struct dev_pm_ops s5p_jpeg_pm_ops = {
-	.runtime_suspend = s5p_jpeg_runtime_suspend,
-	.runtime_resume	 = s5p_jpeg_runtime_resume,
+static struct s5p_jpeg_variant jpeg_drvdata_v1 = {
+	.version	= JPEG_V1,
+	.jpeg_irq	= jpeg_irq_v1,
+};
+
+static struct s5p_jpeg_variant jpeg_drvdata_v2 = {
+	.version	= JPEG_V2,
+	.jpeg_irq	= jpeg_irq_v2,
+};
+
+static struct platform_device_id jpeg_driver_ids[] = {
+	{
+	.name = "s5p-jpeg",                 /*For backward compatibility*/
+	.driver_data = (unsigned long)&jpeg_drvdata_v1,
+	}, {
+	.name = "s5pv210-jpeg",
+	.driver_data = (unsigned long)&jpeg_drvdata_v1,
+	}, {
+	.name = "exynos4212-jpeg",
+	.driver_data = (unsigned long)&jpeg_drvdata_v2,
+	}
 };
 
-static struct platform_driver s5p_jpeg_driver = {
-	.probe = s5p_jpeg_probe,
-	.remove = s5p_jpeg_remove,
-	.driver = {
-		.owner = THIS_MODULE,
-		.name = S5P_JPEG_M2M_NAME,
-		.pm = &s5p_jpeg_pm_ops,
+MODULE_DEVICE_TABLE(platform, jpeg_driver_ids);
+
+static struct platform_driver jpeg_driver = {
+	.probe		= jpeg_probe,
+	.remove		= jpeg_remove,
+	.suspend	= jpeg_suspend,
+	.resume		= jpeg_resume,
+	.id_table	= jpeg_driver_ids,
+	.driver	= {
+		.owner			= THIS_MODULE,
+		.name			= JPEG_NAME,
+		.pm			= NULL,
 	},
 };
 
-module_platform_driver(s5p_jpeg_driver);
+module_platform_driver(jpeg_driver);
 
 MODULE_AUTHOR("Andrzej Pietrasiewicz <andrzej.p@samsung.com>");
 MODULE_DESCRIPTION("Samsung JPEG codec driver");
 MODULE_LICENSE("GPL");
-
diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.h b/drivers/media/platform/s5p-jpeg/jpeg-core.h
index 8a4013e..50dc2c9 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.h
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.h
@@ -1,7 +1,7 @@
 /* linux/drivers/media/platform/s5p-jpeg/jpeg-core.h
  *
  * Copyright (c) 2011 Samsung Electronics Co., Ltd.
- *		http://www.samsung.com
+ *              http://www.samsung.com
  *
  * Author: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
  *
@@ -10,141 +10,324 @@
  * published by the Free Software Foundation.
  */
 
-#ifndef JPEG_CORE_H_
-#define JPEG_CORE_H_
+#ifndef __JPEG_CORE_H__
+#define __JPEG_CORE_H__
 
+#include <linux/mutex.h>
+#include <linux/types.h>
+#include <linux/clk.h>
+#include <linux/interrupt.h>
+#include <linux/spinlock.h>
+#include <linux/sched.h>
+
+#include <linux/videodev2.h>
 #include <media/v4l2-device.h>
-#include <media/v4l2-fh.h>
+#include <media/v4l2-mem2mem.h>
+#include <media/v4l2-mediabus.h>
+#include <media/v4l2-ioctl.h>
 #include <media/v4l2-ctrls.h>
+#include <media/videobuf2-core.h>
+
+#define INT_TIMEOUT		1000
+#define JPEG_NAME		"s5p-jpeg"
+#define JPEG_ENC_NAME		"s5p-jpeg-enc"
+#define JPEG_DEC_NAME		"s5p-jpeg-dec"
+
+#define JPEG_WATCHDOG_CNT	10
+#define JPEG_WATCHDOG_INTERVAL  1000
 
-#define S5P_JPEG_M2M_NAME		"s5p-jpeg"
+#define JPEG_NUM_INST		4
+#define JPEG_MAX_PLANE		3
 
-/* JPEG compression quality setting */
-#define S5P_JPEG_COMPR_QUAL_BEST	0
-#define S5P_JPEG_COMPR_QUAL_WORST	3
+#define MAX_JPEG_WIDTH		3264
+#define MAX_JPEG_HEIGHT		2448
 
 /* JPEG RGB to YCbCr conversion matrix coefficients */
-#define S5P_JPEG_COEF11			0x4d
-#define S5P_JPEG_COEF12			0x97
-#define S5P_JPEG_COEF13			0x1e
-#define S5P_JPEG_COEF21			0x2c
-#define S5P_JPEG_COEF22			0x57
-#define S5P_JPEG_COEF23			0x83
-#define S5P_JPEG_COEF31			0x83
-#define S5P_JPEG_COEF32			0x6e
-#define S5P_JPEG_COEF33			0x13
+#define S5P_JPEG_COEF11		0x4d
+#define S5P_JPEG_COEF12		0x97
+#define S5P_JPEG_COEF13		0x1e
+#define S5P_JPEG_COEF21		0x2c
+#define S5P_JPEG_COEF22		0x57
+#define S5P_JPEG_COEF23		0x83
+#define S5P_JPEG_COEF31		0x83
+#define S5P_JPEG_COEF32		0x6e
+#define S5P_JPEG_COEF33		0x13
 
 /* a selection of JPEG markers */
-#define TEM				0x01
-#define SOF0				0xc0
-#define RST				0xd0
-#define SOI				0xd8
-#define EOI				0xd9
-#define DHP				0xde
-
-/* Flags that indicate a format can be used for capture/output */
-#define MEM2MEM_CAPTURE			(1 << 0)
-#define MEM2MEM_OUTPUT			(1 << 1)
-
-/**
- * struct s5p_jpeg - JPEG IP abstraction
- * @lock:		the mutex protecting this structure
- * @slock:		spinlock protecting the device contexts
- * @v4l2_dev:		v4l2 device for mem2mem mode
- * @vfd_encoder:	video device node for encoder mem2mem mode
- * @vfd_decoder:	video device node for decoder mem2mem mode
- * @m2m_dev:		v4l2 mem2mem device data
- * @regs:		JPEG IP registers mapping
- * @irq:		JPEG IP irq
- * @clk:		JPEG IP clock
- * @dev:		JPEG IP struct device
- * @alloc_ctx:		videobuf2 memory allocator's context
- */
-struct s5p_jpeg {
-	struct mutex		lock;
-	spinlock_t		slock;
+#define TEM			0x01
+#define SOF0			0xc0
+#define RST			0xd0
+#define SOI			0xd8
+#define EOI			0xd9
+#define DHP			0xde
 
-	struct v4l2_device	v4l2_dev;
-	struct video_device	*vfd_encoder;
-	struct video_device	*vfd_decoder;
-	struct v4l2_m2m_dev	*m2m_dev;
+/* JPEG specific V4L2 formats */
 
-	void __iomem		*regs;
-	unsigned int		irq;
-	struct clk		*clk;
-	struct device		*dev;
-	void			*alloc_ctx;
-};
-
-/**
- * struct jpeg_fmt - driver's internal color format data
- * @name:	format descritpion
- * @fourcc:	the fourcc code, 0 if not applicable
- * @depth:	number of bits per pixel
- * @colplanes:	number of color planes (1 for packed formats)
- * @h_align:	horizontal alignment order (align to 2^h_align)
- * @v_align:	vertical alignment order (align to 2^v_align)
- * @types:	types of queue this format is applicable to
- */
-struct s5p_jpeg_fmt {
-	char	*name;
-	u32	fourcc;
-	int	depth;
-	int	colplanes;
-	int	h_align;
-	int	v_align;
-	u32	types;
-};
-
-/**
- * s5p_jpeg_q_data - parameters of one queue
- * @fmt:	driver-specific format of this queue
- * @w:		image width
- * @h:		image height
- * @size:	image buffer size in bytes
- */
-struct s5p_jpeg_q_data {
-	struct s5p_jpeg_fmt	*fmt;
-	u32			w;
-	u32			h;
-	u32			size;
-};
-
-/**
- * s5p_jpeg_ctx - the device context data
- * @jpeg:		JPEG IP device for this context
- * @mode:		compression (encode) operation or decompression (decode)
- * @compr_quality:	destination image quality in compression (encode) mode
- * @m2m_ctx:		mem2mem device context
- * @out_q:		source (output) queue information
- * @cap_fmt:		destination (capture) queue queue information
- * @hdr_parsed:		set if header has been parsed during decompression
- * @ctrl_handler:	controls handler
- */
-struct s5p_jpeg_ctx {
-	struct s5p_jpeg		*jpeg;
-	unsigned int		mode;
-	unsigned short		compr_quality;
-	unsigned short		restart_interval;
-	unsigned short		subsampling;
+/* yuv444 of JFIF JPEG     */
+#define V4L2_PIX_FMT_JPEG_444     v4l2_fourcc('J', 'P', 'G', '4')
+
+/* yuv422 of JFIF JPEG     */
+#define V4L2_PIX_FMT_JPEG_422     v4l2_fourcc('J', 'P', 'G', '2')
+
+/* yuv420 of JFIF JPEG     */
+#define V4L2_PIX_FMT_JPEG_420     v4l2_fourcc('J', 'P', 'G', '0')
+
+/* grey of JFIF JPEG */
+#define V4L2_PIX_FMT_JPEG_GRAY    v4l2_fourcc('J', 'P', 'G', 'G')
+
+/* two planes -- one Y, one Cr + Cb interleaved  */
+#define V4L2_PIX_FMT_YUV444_2P v4l2_fourcc('Y', 'U', '2', 'P') /* 24  Y/CbCr */
+#define V4L2_PIX_FMT_YVU444_2P v4l2_fourcc('Y', 'V', '2', 'P') /* 24  Y/CrCb */
+
+/* three planes -- one Y, one Cr, one Cb */
+#define V4L2_PIX_FMT_YUV444_3P v4l2_fourcc('Y', 'U', '3', 'P') /* 24  Y/Cb/Cr */
+
+/*Version numbers*/
+#define JPEG_V1 1
+#define JPEG_V2 2
+
+enum jpeg_state {
+	JPEG_IDLE,
+	JPEG_SRC_ADDR,
+	JPEG_DST_ADDR,
+	JPEG_ISR,
+	JPEG_STREAM,
+};
+
+enum jpeg_mode {
+	ENCODING,
+	DECODING,
+};
+
+enum jpeg_result {
+	OK_ENC_OR_DEC,
+	ERR_PROT,
+	ERR_DEC_INVALID_FORMAT,
+	ERR_MULTI_SCAN,
+	ERR_FRAME,
+	ERR_UNKNOWN,
+};
+
+enum  jpeg_img_quality_level {
+	QUALITY_LEVEL_1 = 0,	/* high */
+	QUALITY_LEVEL_2,
+	QUALITY_LEVEL_3,
+	QUALITY_LEVEL_4,	/* low */
+};
+
+/* raw data image format */
+enum jpeg_frame_format {
+	YCRCB_444_2P,
+	YCBCR_444_2P,
+	YCBCR_444_3P,
+	YCBYCR_422_1P,
+	YCRYCB_422_1P,
+	CBYCRY_422_1P,
+	CRYCBY_422_1P,
+	YCBCR_422_2P,
+	YCRCB_422_2P,
+	YCBYCR_422_3P,
+	YCBCR_420_3P,
+	YCBCR_420_2P,
+	YCRCB_420_2P,
+	YCBCR_420_2P_M,
+	YCRCB_420_2P_M,
+	RGB_565,
+	RGB_888,
+	GRAY,
+	YCBCR_420_1P,
+	YCRCB_420_1P,
+};
+
+/* jpeg data format */
+enum jpeg_stream_format {
+	JPEG_422,	/* decode input, encode output */
+	JPEG_420,	/* decode input, encode output */
+	JPEG_444,	/* decode input*/
+	JPEG_GRAY,	/* decode input*/
+	JPEG_RESERVED,
+};
+
+enum jpeg_scale_value {
+	JPEG_SCALE_NORMAL,
+	JPEG_SCALE_2,
+	JPEG_SCALE_4,
+};
+
+enum jpeg_interface {
+	M2M_OUTPUT,
+	M2M_CAPTURE,
+};
+
+enum jpeg_node_type {
+	JPEG_NODE_INVALID = -1,
+	JPEG_NODE_DECODER = 15,
+	JPEG_NODE_ENCODER = 14,
+};
+
+struct jpeg_fmt {
+	char			*name;
+	unsigned int			fourcc;
+	int			depth[JPEG_MAX_PLANE];
+	int			color;
+	int			memplanes;
+	int			colplanes;
+	enum jpeg_interface	types;
+};
+
+struct jpeg_dec_param {
+	unsigned int in_width;
+	unsigned int in_height;
+	unsigned int out_width;
+	unsigned int out_height;
+	unsigned int size;
+	unsigned int mem_size;
+	unsigned int in_plane;
+	unsigned int out_plane;
+	unsigned int in_depth;
+	unsigned int out_depth[JPEG_MAX_PLANE];
+
+	enum jpeg_stream_format in_fmt;
+	enum jpeg_frame_format out_fmt;
+};
+
+struct jpeg_enc_param {
+	unsigned int in_width;
+	unsigned int in_height;
+	unsigned int out_width;
+	unsigned int out_height;
+	unsigned int size;
+	unsigned int in_plane;
+	unsigned int out_plane;
+	unsigned int in_depth[JPEG_MAX_PLANE];
+	unsigned int out_depth;
+
+	enum jpeg_frame_format in_fmt;
+	enum jpeg_stream_format out_fmt;
+	enum jpeg_img_quality_level quality;
+};
+
+struct jpeg_ctx {
+	spinlock_t			slock;
+	struct jpeg_dev		*dev;
 	struct v4l2_m2m_ctx	*m2m_ctx;
-	struct s5p_jpeg_q_data	out_q;
-	struct s5p_jpeg_q_data	cap_q;
-	struct v4l2_fh		fh;
-	bool			hdr_parsed;
+
+	union {
+		struct jpeg_dec_param	dec_param;
+		struct jpeg_enc_param	enc_param;
+	} param;
+
+	unsigned short compr_quality;
+	unsigned short restart_interval;
+	unsigned short subsampling;
 	struct v4l2_ctrl_handler ctrl_handler;
+
+	int			index;
+	unsigned long		payload[VIDEO_MAX_PLANES];
+	bool			input_cacheable;
+	bool			output_cacheable;
 };
 
-/**
- * s5p_jpeg_buffer - description of memory containing input JPEG data
- * @size:	buffer size
- * @curr:	current position in the buffer
- * @data:	pointer to the data
- */
-struct s5p_jpeg_buffer {
-	unsigned long size;
-	unsigned long curr;
-	unsigned long data;
+struct jpeg_vb2 {
+	const struct vb2_mem_ops *ops;
+	void *(*init)(struct device *dev);
+	void (*cleanup)(void *alloc_ctx);
+
+	dma_addr_t (*plane_addr)(struct vb2_buffer *vb, u32 plane_no);
+
+	void (*resume)(void *alloc_ctx);
+	void (*suspend)(void *alloc_ctx);
+
+	int (*cache_flush)(struct vb2_buffer *vb, u32 num_planes);
+	void (*set_cacheable)(void *alloc_ctx, bool cacheable);
+};
+
+struct jpeg_dev {
+	spinlock_t		slock;
+	struct v4l2_device	v4l2_dev;
+	struct video_device	*vfd_enc;
+	struct video_device	*vfd_dec;
+	struct v4l2_m2m_dev	*m2m_dev_enc;
+	struct v4l2_m2m_dev	*m2m_dev_dec;
+	struct jpeg_ctx		*ctx;
+	struct vb2_alloc_ctx	*alloc_ctx;
+
+	struct platform_device	*plat_dev;
+
+	struct clk		*clk;
+
+	struct mutex		lock;
+
+	int			irq_no;
+	enum jpeg_result	irq_ret;
+	wait_queue_head_t	 wq;
+	void __iomem		*reg_base;	/* register i/o */
+	enum jpeg_mode		mode;
+	const struct jpeg_vb2	*vb2;
+
+	unsigned long		hw_run;
+	atomic_t		watchdog_cnt;
+	struct timer_list	watchdog_timer;
+	struct workqueue_struct	*watchdog_workqueue;
+	struct work_struct	watchdog_work;
+	struct device			*bus_dev;
+	struct s5p_jpeg_variant *variant;
+};
+
+enum jpeg_log {
+	JPEG_LOG_DEBUG		= 0x1000,
+	JPEG_LOG_INFO		= 0x0100,
+	JPEG_LOG_WARN		= 0x0010,
+	JPEG_LOG_ERR		= 0x0001,
+};
+
+struct s5p_jpeg_variant {
+	unsigned int	version;
+	irqreturn_t	(*jpeg_irq)(int irq, void *priv);
 };
 
-#endif /* JPEG_CORE_H */
+/* debug macro */
+#define JPEG_LOG_DEFAULT       (JPEG_LOG_WARN | JPEG_LOG_ERR)
+
+#define JPEG_DEBUG(fmt, ...)						\
+	do {								\
+		if (JPEG_LOG_DEFAULT & JPEG_LOG_DEBUG)			\
+			pr_debug("%s: "			\
+				fmt, __func__, ##__VA_ARGS__);		\
+	} while (0)
+
+#define JPEG_INFO(fmt, ...)						\
+	do {								\
+		if (JPEG_LOG_DEFAULT & JPEG_LOG_INFO)			\
+			pr_debug("%s: "				\
+				fmt, __func__, ##__VA_ARGS__);		\
+	} while (0)
+
+#define JPEG_WARN(fmt, ...)						\
+	do {								\
+		if (JPEG_LOG_DEFAULT & JPEG_LOG_WARN)			\
+			pr_debug("%s: "			\
+				fmt, __func__, ##__VA_ARGS__);		\
+	} while (0)
+
+
+#define JPEG_ERROR(fmt, ...)						\
+	do {								\
+		if (JPEG_LOG_DEFAULT & JPEG_LOG_ERR)			\
+			pr_debug("%s: "				\
+				fmt, __func__, ##__VA_ARGS__);		\
+	} while (0)
+
+
+#define jpeg_dbg(fmt, ...)		JPEG_DEBUG(fmt, ##__VA_ARGS__)
+#define jpeg_info(fmt, ...)		JPEG_INFO(fmt, ##__VA_ARGS__)
+#define jpeg_warn(fmt, ...)		JPEG_WARN(fmt, ##__VA_ARGS__)
+#define jpeg_err(fmt, ...)		JPEG_ERROR(fmt, ##__VA_ARGS__)
+
+/*=====================================================================*/
+const struct v4l2_ioctl_ops *get_jpeg_dec_v4l2_ioctl_ops(void);
+const struct v4l2_ioctl_ops *get_jpeg_enc_v4l2_ioctl_ops(void);
+
+int jpeg_int_pending(struct jpeg_dev *ctrl);
+
+#endif /*__JPEG_CORE_H__*/
diff --git a/drivers/media/platform/s5p-jpeg/jpeg-dec.c b/drivers/media/platform/s5p-jpeg/jpeg-dec.c
new file mode 100644
index 0000000..7c42eb85
--- /dev/null
+++ b/drivers/media/platform/s5p-jpeg/jpeg-dec.c
@@ -0,0 +1,489 @@
+/* Copyright (c) 2013 Samsung Electronics Co., Ltd.
+ * http://www.samsung.com/
+ *
+ * Decoder core file for Samsung JPEG Interface driver
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+#include <asm/page.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/version.h>
+#include <linux/errno.h>
+#include <linux/fs.h>
+#include <linux/irq.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/slab.h>
+#include <linux/err.h>
+#include <linux/miscdevice.h>
+#include <linux/platform_device.h>
+#include <linux/mm.h>
+#include <linux/init.h>
+#include <linux/poll.h>
+#include <linux/signal.h>
+#include <linux/ioport.h>
+#include <linux/kmod.h>
+#include <linux/vmalloc.h>
+#include <linux/time.h>
+#include <linux/clk.h>
+#include <linux/semaphore.h>
+#include <linux/vmalloc.h>
+#include <linux/workqueue.h>
+#include <linux/videodev2.h>
+#include <mach/irqs.h>
+#include <media/v4l2-ioctl.h>
+
+#include "jpeg-core.h"
+#include "jpeg-hw-v2.h"
+#include "jpeg-regs-v2.h"
+
+static struct jpeg_fmt formats[] = {
+	{
+	.name           = "JPEG compressed format",
+	.fourcc         = V4L2_PIX_FMT_JPEG_444,
+	.depth          = {8},
+	.color          = JPEG_444,
+	.memplanes      = 1,
+	.types          = M2M_OUTPUT,
+	}, {
+	.name           = "JPEG compressed format",
+	.fourcc         = V4L2_PIX_FMT_JPEG_422,
+	.depth          = {8},
+	.color          = JPEG_422,
+	.memplanes      = 1,
+	.types          = M2M_OUTPUT,
+	}, {
+	.name           = "JPEG compressed format",
+	.fourcc         = V4L2_PIX_FMT_JPEG_420,
+	.depth          = {8},
+	.color          = JPEG_420,
+	.memplanes      = 1,
+	.types          = M2M_OUTPUT,
+	}, {
+	.name           = "JPEG compressed format",
+	.fourcc         = V4L2_PIX_FMT_JPEG_GRAY,
+	.depth          = {8},
+	.color          = JPEG_GRAY,
+	.memplanes      = 1,
+	.types          = M2M_OUTPUT,
+	}, {
+	.name           = "RGB565",
+	.fourcc         = V4L2_PIX_FMT_RGB565X,
+	.depth          = {16},
+	.color          = RGB_565,
+	.memplanes      = 1,
+	.types          = M2M_CAPTURE,
+	}, {
+	.name           = "XRGB-8-8-8-8, 32 bpp",
+	.fourcc         = V4L2_PIX_FMT_RGB32,
+	.depth          = {32},
+	.color          = RGB_888,
+	.memplanes      = 1,
+	.types          = M2M_CAPTURE,
+	}, {
+	.name           = "YUV 4:4:4 packed, Y/CbCr",
+	.fourcc         = V4L2_PIX_FMT_YUV444_2P,
+	.depth          = {8, 16},
+	.color          = YCBCR_444_2P,
+	.memplanes      = 2,
+	.types          = M2M_CAPTURE,
+	}, {
+	.name           = "YUV 4:4:4 packed, Y/CrCb",
+	.fourcc         = V4L2_PIX_FMT_YVU444_2P,
+	.depth          = {8, 16},
+	.color          = YCRCB_444_2P,
+	.memplanes      = 2,
+	.types          = M2M_CAPTURE,
+	}, {
+	.name           = "YUV 4:4:4 packed, Y/Cb/Cr",
+	.fourcc         = V4L2_PIX_FMT_YUV444_3P,
+	.depth          = {8, 8, 8},
+	.color          = YCBCR_444_3P,
+	.memplanes      = 3,
+	.types          = M2M_CAPTURE,
+	}, {
+	.name           = "YUV 4:2:2 packed, YCbYCr",
+	.fourcc         = V4L2_PIX_FMT_YUYV,
+	.depth          = {16},
+	.color          = YCBYCR_422_1P,
+	.memplanes      = 1,
+	.types          = M2M_CAPTURE,
+	}, {
+	.name           = "YUV 4:2:2 planar, Y/CrCb",
+	.fourcc         = V4L2_PIX_FMT_NV61,
+	.depth          = {8, 8},
+	.color          = YCRCB_422_2P,
+	.memplanes      = 2,
+	.types          = M2M_CAPTURE,
+	}, {
+	.name           = "YUV 4:2:2 planar, Y/CbCr",
+	.fourcc         = V4L2_PIX_FMT_NV16,
+	.depth          = {8, 8},
+	.color          = YCBCR_422_2P,
+	.memplanes      = 2,
+	.types          = M2M_CAPTURE,
+	}, {
+	.name           = "YUV 4:2:0 planar, Y/CbCr",
+	.fourcc         = V4L2_PIX_FMT_NV12,
+	.depth          = {8, 4},
+	.color          = YCBCR_420_2P,
+	.memplanes      = 2,
+	.types          = M2M_CAPTURE,
+	}, {
+	.name           = "YUV 4:2:0 planar, Y/CrCb",
+	.fourcc         = V4L2_PIX_FMT_NV21,
+	.depth          = {8, 4},
+	.color          = YCRCB_420_2P,
+	.memplanes      = 2,
+	.types          = M2M_CAPTURE,
+	}, {
+	.name           = "YUV 4:2:0 contiguous 3-planar, Y/Cr/Cb",
+	.fourcc         = V4L2_PIX_FMT_YUV420,
+	.depth          = {8, 2, 2},
+	.color          = YCBCR_420_3P,
+	.memplanes      = 3,
+	.types          = M2M_CAPTURE,
+	}, {
+	.name           = "Gray",
+	.fourcc         = V4L2_PIX_FMT_GREY,
+	.depth          = {8},
+	.color          = GRAY,
+	.memplanes      = 1,
+	.types          = M2M_CAPTURE,
+	},
+};
+
+static struct jpeg_fmt *find_format(struct v4l2_format *f)
+{
+	struct jpeg_fmt *fmt;
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(formats); ++i) {
+		fmt = &formats[i];
+		if (fmt->fourcc == f->fmt.pix_mp.pixelformat)
+			break;
+	}
+
+	return (i == ARRAY_SIZE(formats)) ? NULL : fmt;
+}
+
+static int jpeg_dec_vidioc_querycap(struct file *file, void *priv,
+			   struct v4l2_capability *cap)
+{
+	struct jpeg_ctx *ctx = file->private_data;
+	struct jpeg_dev *dev = ctx->dev;
+
+	strncpy(cap->driver, dev->plat_dev->name, sizeof(cap->driver) - 1);
+	strncpy(cap->card, dev->plat_dev->name, sizeof(cap->card) - 1);
+	cap->bus_info[0] = 0;
+	cap->version = KERNEL_VERSION(1, 0, 0);
+	cap->capabilities = V4L2_CAP_STREAMING |
+		V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_VIDEO_OUTPUT |
+		V4L2_CAP_VIDEO_CAPTURE_MPLANE | V4L2_CAP_VIDEO_OUTPUT_MPLANE;
+	return 0;
+}
+
+int jpeg_dec_vidioc_enum_fmt(struct file *file, void *priv,
+				struct v4l2_fmtdesc *f)
+{
+	struct jpeg_fmt *fmt;
+
+	if (f->index >= ARRAY_SIZE(formats))
+		return -EINVAL;
+
+	fmt = &formats[f->index];
+	strncpy(f->description, fmt->name, sizeof(f->description) - 1);
+	f->pixelformat = fmt->color;
+
+	return 0;
+}
+
+int jpeg_dec_vidioc_g_fmt(struct file *file, void *priv,
+			     struct v4l2_format *f)
+{
+	struct jpeg_ctx *ctx = priv;
+	struct v4l2_pix_format_mplane *pixm;
+	struct jpeg_dec_param *dec_param = &ctx->param.dec_param;
+	unsigned int width, height;
+
+	pixm = &f->fmt.pix_mp;
+
+	pixm->field	= V4L2_FIELD_NONE;
+
+	if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+		pixm->pixelformat = dec_param->in_fmt;
+		pixm->num_planes = dec_param->in_plane;
+
+		pixm->width = dec_param->in_width;
+		pixm->height = dec_param->in_height;
+	} else if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
+
+		jpeg_get_frame_size(ctx->dev->reg_base, &width, &height);
+		pixm->pixelformat =
+			dec_param->out_fmt;
+		pixm->num_planes = dec_param->out_plane;
+		pixm->width = width;
+		pixm->height = height;
+	} else {
+		v4l2_err(&ctx->dev->v4l2_dev,
+			"Wrong buffer/video queue type (%d)\n", f->type);
+	}
+
+	return 0;
+}
+
+static int jpeg_dec_vidioc_try_fmt(struct file *file, void *priv,
+			       struct v4l2_format *f)
+{
+	struct jpeg_fmt *fmt;
+	struct v4l2_pix_format_mplane *pix = &f->fmt.pix_mp;
+	struct jpeg_ctx *ctx = priv;
+	int i;
+
+	if (f->type != V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE &&
+		f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
+			return -EINVAL;
+
+	fmt = find_format(f);
+
+	if (!fmt) {
+		v4l2_err(&ctx->dev->v4l2_dev,
+			 "Fourcc format (0x%08x) invalid.\n",
+			 f->fmt.pix.pixelformat);
+		return -EINVAL;
+	}
+
+	if (pix->field == V4L2_FIELD_ANY)
+		pix->field = V4L2_FIELD_NONE;
+	else if (V4L2_FIELD_NONE != pix->field)
+		return -EINVAL;
+
+	pix->num_planes = fmt->memplanes;
+
+	for (i = 0; i < pix->num_planes; ++i) {
+		int bpl = pix->plane_fmt[i].bytesperline;
+
+		jpeg_dbg("[%d] bpl: %d, depth: %d, w: %d, h: %d",
+		    i, bpl, fmt->depth[i], pix->width, pix->height);
+		if (!bpl || (bpl * 8 / fmt->depth[i]) > pix->width)
+			bpl = (pix->width * fmt->depth[i]) >> 3;
+
+		if (!pix->plane_fmt[i].sizeimage)
+			pix->plane_fmt[i].sizeimage = pix->height * bpl;
+
+		pix->plane_fmt[i].bytesperline = bpl;
+
+		jpeg_dbg("[%d]: bpl: %d, sizeimage: %d",
+		    i, pix->plane_fmt[i].bytesperline,
+		    pix->plane_fmt[i].sizeimage);
+	}
+
+	if (f->fmt.pix.height > MAX_JPEG_HEIGHT)
+		f->fmt.pix.height = MAX_JPEG_HEIGHT;
+
+	if (f->fmt.pix.width > MAX_JPEG_WIDTH)
+		f->fmt.pix.width = MAX_JPEG_WIDTH;
+
+	return 0;
+}
+
+static int jpeg_dec_vidioc_s_fmt_cap(struct file *file, void *priv,
+				struct v4l2_format *f)
+{
+	struct jpeg_ctx *ctx = priv;
+	struct vb2_queue *vq;
+	struct v4l2_pix_format_mplane *pix;
+	struct jpeg_fmt *fmt;
+	int ret;
+	int i;
+
+	ret = jpeg_dec_vidioc_try_fmt(file, priv, f);
+	if (ret)
+		return ret;
+
+	vq = v4l2_m2m_get_vq(ctx->m2m_ctx, f->type);
+	if (!vq)
+		return -EINVAL;
+
+	if (vb2_is_busy(vq)) {
+		v4l2_err(&ctx->dev->v4l2_dev, "queue (%d) busy\n", f->type);
+		return -EBUSY;
+	}
+
+	pix = &f->fmt.pix_mp;
+	fmt = find_format(f);
+	if (!fmt) {
+		v4l2_err(&ctx->dev->v4l2_dev,
+			"Fourcc format (0x%08x) invalid.\n",
+				f->fmt.pix.pixelformat);
+		return -EINVAL;
+	}
+
+	for (i = 0; i < fmt->memplanes; i++) {
+		ctx->payload[i] =
+			pix->plane_fmt[i].bytesperline * pix->height;
+		ctx->param.dec_param.out_depth[i] = fmt->depth[i];
+	}
+
+	ctx->param.dec_param.out_width = pix->width;
+	ctx->param.dec_param.out_height = pix->height;
+	ctx->param.dec_param.out_plane = fmt->memplanes;
+	ctx->param.dec_param.out_fmt = fmt->color;
+
+	return 0;
+}
+
+static int jpeg_dec_vidioc_s_fmt_out(struct file *file, void *priv,
+			struct v4l2_format *f)
+{
+	struct jpeg_ctx *ctx = priv;
+	struct vb2_queue *vq;
+	struct v4l2_pix_format_mplane *pix;
+	struct jpeg_fmt *fmt;
+	int ret;
+	int i;
+
+	ret = jpeg_dec_vidioc_try_fmt(file, priv, f);
+	if (ret)
+		return ret;
+
+	vq = v4l2_m2m_get_vq(ctx->m2m_ctx, f->type);
+	if (!vq)
+		return -EINVAL;
+
+	if (vb2_is_busy(vq)) {
+		v4l2_err(&ctx->dev->v4l2_dev, "queue (%d) busy\n", f->type);
+		return -EBUSY;
+	}
+
+	pix = &f->fmt.pix_mp;
+	fmt = find_format(f);
+	if (!fmt) {
+		v4l2_err(&ctx->dev->v4l2_dev,
+			"Fourcc format (0x%08x) invalid.\n",
+				f->fmt.pix.pixelformat);
+		return -EINVAL;
+	}
+
+	for (i = 0; i < fmt->memplanes; i++)
+		ctx->payload[i] =
+			pix->plane_fmt[i].bytesperline * pix->height;
+
+	ctx->param.dec_param.in_width = pix->width;
+	ctx->param.dec_param.in_height = pix->height;
+	ctx->param.dec_param.in_plane = fmt->memplanes;
+	ctx->param.dec_param.in_depth = fmt->depth[0];
+	ctx->param.dec_param.in_fmt = fmt->color;
+
+	if ((pix->plane_fmt[0].sizeimage % 32) == 0)
+		ctx->param.dec_param.size = (pix->plane_fmt[0].sizeimage / 32);
+	else
+		ctx->param.dec_param.size =
+				 (pix->plane_fmt[0].sizeimage / 32) + 1;
+	ctx->param.dec_param.mem_size = pix->plane_fmt[0].sizeimage;
+
+	return 0;
+}
+
+static int jpeg_dec_m2m_reqbufs(struct file *file, void *priv,
+			  struct v4l2_requestbuffers *reqbufs)
+{
+	struct jpeg_ctx *ctx = priv;
+	struct vb2_queue *vq;
+
+	vq = v4l2_m2m_get_vq(ctx->m2m_ctx, reqbufs->type);
+	return v4l2_m2m_reqbufs(file, ctx->m2m_ctx, reqbufs);
+}
+
+static int jpeg_dec_m2m_querybuf(struct file *file, void *priv,
+			   struct v4l2_buffer *buf)
+{
+	struct jpeg_ctx *ctx = priv;
+	return v4l2_m2m_querybuf(file, ctx->m2m_ctx, buf);
+}
+
+static int jpeg_dec_m2m_qbuf(struct file *file, void *priv,
+			  struct v4l2_buffer *buf)
+{
+	struct jpeg_ctx *ctx = priv;
+	return v4l2_m2m_qbuf(file, ctx->m2m_ctx, buf);
+}
+
+static int jpeg_dec_m2m_dqbuf(struct file *file, void *priv,
+			   struct v4l2_buffer *buf)
+{
+	struct jpeg_ctx *ctx = priv;
+	return v4l2_m2m_dqbuf(file, ctx->m2m_ctx, buf);
+}
+
+static int jpeg_dec_m2m_streamon(struct file *file, void *priv,
+			   enum v4l2_buf_type type)
+{
+	struct jpeg_ctx *ctx = priv;
+	return v4l2_m2m_streamon(file, ctx->m2m_ctx, type);
+}
+
+static int jpeg_dec_m2m_streamoff(struct file *file, void *priv,
+			    enum v4l2_buf_type type)
+{
+	struct jpeg_ctx *ctx = priv;
+	return v4l2_m2m_streamoff(file, ctx->m2m_ctx, type);
+}
+
+static int vidioc_dec_s_jpegcomp(struct file *file, void *priv,
+			const struct v4l2_jpegcompression *jpegcomp)
+{
+	struct jpeg_ctx *ctx = priv;
+	ctx->param.enc_param.quality = jpegcomp->quality;
+	return 0;
+}
+
+static int jpeg_dec_vidioc_s_ctrl(struct file *file, void *priv,
+			struct v4l2_control *ctrl)
+{
+	struct jpeg_ctx *ctx = priv;
+/*
+*	0 : input/output noncacheable
+*	1 : input/output cacheable
+*	2 : input cacheable / output noncacheable
+*	3 : input noncacheable / output cacheable
+*/
+	switch (ctrl->id) {
+	default:
+		v4l2_err(&ctx->dev->v4l2_dev, "Invalid control\n");
+		break;
+	}
+
+	return 0;
+}
+
+static const struct v4l2_ioctl_ops jpeg_dec_ioctl_ops = {
+	.vidioc_querycap		= jpeg_dec_vidioc_querycap,
+
+	.vidioc_enum_fmt_vid_cap_mplane	= jpeg_dec_vidioc_enum_fmt,
+	.vidioc_enum_fmt_vid_out_mplane	= jpeg_dec_vidioc_enum_fmt,
+
+	.vidioc_g_fmt_vid_cap_mplane	= jpeg_dec_vidioc_g_fmt,
+	.vidioc_g_fmt_vid_out_mplane	= jpeg_dec_vidioc_g_fmt,
+
+	.vidioc_try_fmt_vid_cap_mplane		= jpeg_dec_vidioc_try_fmt,
+	.vidioc_try_fmt_vid_out_mplane		= jpeg_dec_vidioc_try_fmt,
+	.vidioc_s_fmt_vid_cap_mplane		= jpeg_dec_vidioc_s_fmt_cap,
+	.vidioc_s_fmt_vid_out_mplane		= jpeg_dec_vidioc_s_fmt_out,
+
+	.vidioc_reqbufs		    = jpeg_dec_m2m_reqbufs,
+	.vidioc_querybuf		= jpeg_dec_m2m_querybuf,
+	.vidioc_qbuf			= jpeg_dec_m2m_qbuf,
+	.vidioc_dqbuf			= jpeg_dec_m2m_dqbuf,
+	.vidioc_streamon		= jpeg_dec_m2m_streamon,
+	.vidioc_streamoff		= jpeg_dec_m2m_streamoff,
+	.vidioc_s_jpegcomp		= vidioc_dec_s_jpegcomp,
+	.vidioc_s_ctrl			= jpeg_dec_vidioc_s_ctrl,
+};
+const struct v4l2_ioctl_ops *get_jpeg_dec_v4l2_ioctl_ops(void)
+{
+	return &jpeg_dec_ioctl_ops;
+}
diff --git a/drivers/media/platform/s5p-jpeg/jpeg-enc.c b/drivers/media/platform/s5p-jpeg/jpeg-enc.c
new file mode 100644
index 0000000..436a18a
--- /dev/null
+++ b/drivers/media/platform/s5p-jpeg/jpeg-enc.c
@@ -0,0 +1,521 @@
+/* Copyright (c) 2013 Samsung Electronics Co., Ltd.
+ * http://www.samsung.com/
+ *
+ * Encoder Core file for Samsung JPEG Interface driver
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/version.h>
+#include <linux/errno.h>
+#include <linux/fs.h>
+#include <linux/irq.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/slab.h>
+#include <linux/err.h>
+#include <linux/miscdevice.h>
+#include <linux/platform_device.h>
+#include <linux/mm.h>
+#include <linux/init.h>
+#include <linux/poll.h>
+#include <linux/signal.h>
+#include <linux/ioport.h>
+#include <linux/kmod.h>
+#include <linux/vmalloc.h>
+#include <linux/time.h>
+#include <linux/clk.h>
+#include <linux/semaphore.h>
+#include <linux/vmalloc.h>
+#include <linux/workqueue.h>
+#include <linux/videodev2.h>
+#include <mach/irqs.h>
+
+#include <media/v4l2-ioctl.h>
+#include <asm/page.h>
+
+#include "jpeg-core.h"
+#include "jpeg-hw-v2.h"
+#include "jpeg-regs-v2.h"
+
+static struct jpeg_fmt formats[] = {
+	{
+	.name           = "JPEG compressed format",
+	.fourcc         = V4L2_PIX_FMT_JPEG_444,
+	.depth          = {8},
+	.color          = JPEG_444,
+	.memplanes      = 1,
+	.types          = M2M_CAPTURE,
+	}, {
+	.name           = "JPEG compressed format",
+	.fourcc         = V4L2_PIX_FMT_JPEG_422,
+	.depth          = {8},
+	.color          = JPEG_422,
+	.memplanes      = 1,
+	.types          = M2M_CAPTURE,
+	}, {
+	.name           = "JPEG compressed format",
+	.fourcc         = V4L2_PIX_FMT_JPEG_420,
+	.depth          = {8},
+	.color          = JPEG_420,
+	.memplanes      = 1,
+	.types          = M2M_CAPTURE,
+	}, {
+	.name           = "JPEG compressed format",
+	.fourcc         = V4L2_PIX_FMT_JPEG_GRAY,
+	.depth          = {8},
+	.color          = JPEG_GRAY,
+	.memplanes      = 1,
+	.types          = M2M_CAPTURE,
+	}, {
+	.name           = "RGB565",
+	.fourcc         = V4L2_PIX_FMT_RGB565X,
+	.depth          = {16},
+	.color          = RGB_565,
+	.memplanes      = 1,
+	.types          = M2M_OUTPUT,
+	}, {
+	.name           = "YUV 4:4:4 packed, Y/CbCr",
+	.fourcc         = V4L2_PIX_FMT_YUV444_2P,
+	.depth          = {8, 16},
+	.color          = YCBCR_444_2P,
+	.memplanes      = 2,
+	.types          = M2M_OUTPUT,
+	}, {
+	.name           = "YUV 4:4:4 packed, Y/CrCb",
+	.fourcc         = V4L2_PIX_FMT_YVU444_2P,
+	.depth          = {8, 16},
+	.color          = YCRCB_444_2P,
+	.memplanes      = 2,
+	.types          = M2M_OUTPUT,
+	}, {
+	.name           = "YUV 4:4:4 packed, Y/Cb/Cr",
+	.fourcc         = V4L2_PIX_FMT_YUV444_3P,
+	.depth          = {8, 8, 8},
+	.color          = YCBCR_444_3P,
+	.memplanes      = 2,
+	.types          = M2M_OUTPUT,
+	}, {
+	.name           = "XRGB-8-8-8-8, 32 bpp",
+	.fourcc         = V4L2_PIX_FMT_RGB32,
+	.depth          = {32},
+	.color          = RGB_888,
+	.memplanes      = 1,
+	.types          = M2M_OUTPUT,
+	}, {
+	.name           = "YUV 4:2:2 packed, YCbYCr",
+	.fourcc         = V4L2_PIX_FMT_YUYV,
+	.depth          = {16},
+	.color          = YCBYCR_422_1P,
+	.memplanes      = 1,
+	.types          = M2M_OUTPUT,
+	}, {
+	.name           = "YUV 4:2:2 planar, Y/CrCb",
+	.fourcc         = V4L2_PIX_FMT_NV61,
+	.depth          = {8, 8},
+	.color          = YCRCB_422_2P,
+	.memplanes      = 2,
+	.types          = M2M_OUTPUT,
+	}, {
+	.name           = "YUV 4:2:2 planar, Y/CbCr",
+	.fourcc         = V4L2_PIX_FMT_NV16,
+	.depth          = {8, 8},
+	.color          = YCBCR_422_2P,
+	.memplanes      = 2,
+	.types          = M2M_OUTPUT,
+	}, {
+	.name           = "YUV 4:2:0 planar, Y/CbCr",
+	.fourcc         = V4L2_PIX_FMT_NV12,
+	.depth          = {8, 4},
+	.color          = YCBCR_420_2P,
+	.memplanes      = 2,
+	.types          = M2M_OUTPUT,
+	}, {
+	.name           = "YUV 4:2:0 planar, Y/CrCb",
+	.fourcc         = V4L2_PIX_FMT_NV21,
+	.depth          = {8, 4},
+	.color          = YCRCB_420_2P,
+	.memplanes      = 2,
+	.types          = M2M_OUTPUT,
+	}, {
+	.name           = "YUV 4:2:0 contiguous 3-planar, Y/Cb/Cr",
+	.fourcc         = V4L2_PIX_FMT_YUV420,
+	.depth          = {8, 2, 2},
+	.color          = YCBCR_420_3P,
+	.memplanes      = 3,
+	.types          = M2M_OUTPUT,
+	}, {
+	.name           = "Gray",
+	.fourcc         = V4L2_PIX_FMT_GREY,
+	.depth          = {8},
+	.color          = GRAY,
+	.memplanes      = 1,
+	.types          = M2M_OUTPUT,
+	},
+};
+
+static struct jpeg_fmt *find_format(struct v4l2_format *f)
+{
+	struct jpeg_fmt *fmt;
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(formats); ++i) {
+		fmt = &formats[i];
+		if (fmt->fourcc == f->fmt.pix_mp.pixelformat)
+			break;
+	}
+
+	return (i == ARRAY_SIZE(formats)) ? NULL : fmt;
+}
+
+static int jpeg_enc_vidioc_querycap(struct file *file, void *priv,
+			   struct v4l2_capability *cap)
+{
+	struct jpeg_ctx *ctx = file->private_data;
+	struct jpeg_dev *dev = ctx->dev;
+
+	strncpy(cap->driver, dev->plat_dev->name, sizeof(cap->driver) - 1);
+	strncpy(cap->card, dev->plat_dev->name, sizeof(cap->card) - 1);
+	cap->bus_info[0] = 0;
+	cap->version = KERNEL_VERSION(1, 0, 0);
+	cap->capabilities = V4L2_CAP_STREAMING |
+		V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_VIDEO_OUTPUT |
+		V4L2_CAP_VIDEO_CAPTURE_MPLANE | V4L2_CAP_VIDEO_OUTPUT_MPLANE;
+	return 0;
+}
+
+int jpeg_enc_vidioc_enum_fmt(struct file *file, void *priv,
+				struct v4l2_fmtdesc *f)
+{
+	struct jpeg_fmt *fmt;
+
+	if (f->index >= ARRAY_SIZE(formats))
+		return -EINVAL;
+
+	fmt = &formats[f->index];
+	strncpy(f->description, fmt->name, sizeof(f->description) - 1);
+	f->pixelformat = fmt->fourcc;
+
+	return 0;
+}
+
+int jpeg_enc_vidioc_g_fmt(struct file *file, void *priv,
+			     struct v4l2_format *f)
+{
+	struct jpeg_ctx *ctx = priv;
+	struct v4l2_pix_format_mplane *pixm;
+	struct jpeg_enc_param *enc_param = &ctx->param.enc_param;
+
+	pixm = &f->fmt.pix_mp;
+
+	pixm->field	= V4L2_FIELD_NONE;
+
+	if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
+		pixm->pixelformat =
+			enc_param->in_fmt;
+		pixm->num_planes =
+			enc_param->in_plane;
+		pixm->width =
+			enc_param->in_width;
+		pixm->height =
+			enc_param->in_height;
+	} else if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
+		pixm->pixelformat =
+			enc_param->out_fmt;
+		pixm->num_planes =
+			enc_param->out_plane;
+		pixm->width =
+			enc_param->out_width;
+		pixm->height =
+			enc_param->out_height;
+	} else {
+		v4l2_err(&ctx->dev->v4l2_dev,
+			"Wrong buffer/video queue type (%d)\n", f->type);
+	}
+
+	return 0;
+}
+
+static int jpeg_enc_vidioc_try_fmt(struct file *file, void *priv,
+			       struct v4l2_format *f)
+{
+	struct jpeg_fmt *fmt;
+	struct v4l2_pix_format_mplane *pix = &f->fmt.pix_mp;
+	struct jpeg_ctx *ctx = priv;
+	int i;
+
+	if (f->type != V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE &&
+		f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE &&
+		f->type != V4L2_BUF_TYPE_VIDEO_OUTPUT &&
+		f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
+	fmt = find_format(f);
+
+	if (!fmt) {
+		v4l2_err(&ctx->dev->v4l2_dev,
+			"Fourcc format (0x%08x) invalid.\n",
+				f->fmt.pix.pixelformat);
+		return -EINVAL;
+	}
+
+	if (pix->field == V4L2_FIELD_ANY)
+		pix->field = V4L2_FIELD_NONE;
+	else if (V4L2_FIELD_NONE != pix->field)
+		return -EINVAL;
+
+
+	pix->num_planes = fmt->memplanes;
+
+	for (i = 0; i < pix->num_planes; ++i) {
+		int bpl = pix->plane_fmt[i].bytesperline;
+
+		jpeg_dbg("[%d] bpl: %d, depth: %d, w: %d, h: %d",
+		    i, bpl, fmt->depth[i], pix->width, pix->height);
+
+		if (!bpl || (bpl * 8 / fmt->depth[i]) > pix->width)
+			bpl = (pix->width * fmt->depth[i]) >> 3;
+
+		if (!pix->plane_fmt[i].sizeimage)
+			pix->plane_fmt[i].sizeimage = pix->height * bpl;
+
+		pix->plane_fmt[i].bytesperline = bpl;
+
+		jpeg_dbg("[%d]: bpl: %d, sizeimage: %d",
+		    i, pix->plane_fmt[i].bytesperline,
+		    pix->plane_fmt[i].sizeimage);
+	}
+
+	if (f->fmt.pix.height > MAX_JPEG_HEIGHT)
+		f->fmt.pix.height = MAX_JPEG_HEIGHT;
+
+	if (f->fmt.pix.width > MAX_JPEG_WIDTH)
+		f->fmt.pix.width = MAX_JPEG_WIDTH;
+
+	return 0;
+}
+
+static int jpeg_enc_vidioc_s_fmt_cap(struct file *file, void *priv,
+				struct v4l2_format *f)
+{
+	struct jpeg_ctx *ctx = priv;
+	struct vb2_queue *vq;
+	struct v4l2_pix_format_mplane *pix;
+	struct jpeg_fmt *fmt;
+	int ret;
+	int i;
+
+	ret = jpeg_enc_vidioc_try_fmt(file, priv, f);
+	if (ret)
+		return ret;
+
+	vq = v4l2_m2m_get_vq(ctx->m2m_ctx, f->type);
+	if (!vq)
+		return -EINVAL;
+
+	if (vb2_is_busy(vq)) {
+		v4l2_err(&ctx->dev->v4l2_dev, "queue (%d) busy\n", f->type);
+		return -EBUSY;
+	}
+
+	pix = &f->fmt.pix_mp;
+	fmt = find_format(f);
+	if (!fmt) {
+		v4l2_err(&ctx->dev->v4l2_dev,
+			"Fourcc format (0x%08x) invalid.\n",
+				f->fmt.pix.pixelformat);
+		return -EINVAL;
+	}
+
+
+	for (i = 0; i < fmt->memplanes; i++)
+		ctx->payload[i] =
+			pix->plane_fmt[i].bytesperline * pix->height;
+
+	ctx->param.enc_param.out_width = pix->height;
+	ctx->param.enc_param.out_height = pix->width;
+	ctx->param.enc_param.out_plane = fmt->memplanes;
+	ctx->param.enc_param.out_depth = fmt->depth[0];
+	ctx->param.enc_param.out_fmt = fmt->color;
+	ctx->param.enc_param.size = pix->plane_fmt[0].sizeimage;
+	return 0;
+}
+
+static int jpeg_enc_vidioc_s_fmt_out(struct file *file, void *priv,
+			struct v4l2_format *f)
+{
+	struct jpeg_ctx *ctx = priv;
+	struct vb2_queue *vq;
+	struct v4l2_pix_format_mplane *pix;
+	struct jpeg_fmt *fmt;
+	int ret;
+	int i;
+
+	ret = jpeg_enc_vidioc_try_fmt(file, priv, f);
+	if (ret)
+		return ret;
+
+	vq = v4l2_m2m_get_vq(ctx->m2m_ctx, f->type);
+	if (!vq)
+		return -EINVAL;
+
+	if (vb2_is_busy(vq)) {
+		v4l2_err(&ctx->dev->v4l2_dev, "queue (%d) busy\n", f->type);
+		return -EBUSY;
+	}
+
+	pix = &f->fmt.pix_mp;
+	fmt = find_format(f);
+	if (!fmt) {
+		v4l2_err(&ctx->dev->v4l2_dev,
+			"Fourcc format (0x%08x) invalid.\n",
+				f->fmt.pix.pixelformat);
+		return -EINVAL;
+	}
+
+
+	for (i = 0; i < fmt->memplanes; i++) {
+		ctx->payload[i] =
+			pix->plane_fmt[i].bytesperline * pix->height;
+		ctx->param.enc_param.in_depth[i] = fmt->depth[i];
+	}
+	ctx->param.enc_param.in_width = pix->width;
+	ctx->param.enc_param.in_height = pix->height;
+	ctx->param.enc_param.in_plane = fmt->memplanes;
+	ctx->param.enc_param.in_fmt = fmt->color;
+
+	return 0;
+}
+
+static int jpeg_enc_m2m_reqbufs(struct file *file, void *priv,
+			  struct v4l2_requestbuffers *reqbufs)
+{
+	struct jpeg_ctx *ctx = priv;
+
+	return v4l2_m2m_reqbufs(file, ctx->m2m_ctx, reqbufs);
+}
+
+static int jpeg_enc_m2m_querybuf(struct file *file, void *priv,
+			   struct v4l2_buffer *buf)
+{
+	struct jpeg_ctx *ctx = priv;
+	return v4l2_m2m_querybuf(file, ctx->m2m_ctx, buf);
+}
+
+static int jpeg_enc_m2m_qbuf(struct file *file, void *priv,
+			  struct v4l2_buffer *buf)
+{
+	struct jpeg_ctx *ctx = priv;
+
+	return v4l2_m2m_qbuf(file, ctx->m2m_ctx, buf);
+}
+
+static int jpeg_enc_m2m_dqbuf(struct file *file, void *priv,
+			   struct v4l2_buffer *buf)
+{
+	struct jpeg_ctx *ctx = priv;
+	return v4l2_m2m_dqbuf(file, ctx->m2m_ctx, buf);
+}
+
+static int jpeg_enc_m2m_streamon(struct file *file, void *priv,
+			   enum v4l2_buf_type type)
+{
+	struct jpeg_ctx *ctx = priv;
+	return v4l2_m2m_streamon(file, ctx->m2m_ctx, type);
+}
+
+static int jpeg_enc_m2m_streamoff(struct file *file, void *priv,
+			    enum v4l2_buf_type type)
+{
+	struct jpeg_ctx *ctx = priv;
+	return v4l2_m2m_streamoff(file, ctx->m2m_ctx, type);
+}
+
+static int jpeg_enc_vidioc_g_ctrl(struct file *file, void *priv,
+			    struct v4l2_control *ctrl)
+{
+	switch (ctrl->id) {
+	default:
+		break;
+	}
+	return ctrl->value;
+}
+
+static int vidioc_enc_s_jpegcomp(struct file *file, void *priv,
+			const struct v4l2_jpegcompression *jpegcomp)
+{
+	struct jpeg_ctx *ctx = priv;
+
+	ctx->param.enc_param.quality = jpegcomp->quality;
+	return 0;
+}
+
+static int vidioc_enc_g_jpegcomp(struct file *file, void *priv,
+			struct v4l2_jpegcompression *jpegcomp)
+{
+	struct jpeg_ctx *ctx = priv;
+
+	jpegcomp->quality = ctx->param.enc_param.quality;
+	return 0;
+}
+
+static int jpeg_enc_vidioc_s_ctrl(struct file *file, void *priv,
+			struct v4l2_control *ctrl)
+{
+	struct jpeg_ctx *ctx = priv;
+/*
+*	0 : input/output noncacheable
+*	1 : input/output cacheable
+*	2 : input cacheable / output noncacheable
+*	3 : input noncacheable / output cacheable
+*/
+	switch (ctrl->id) {
+	default:
+		v4l2_err(&ctx->dev->v4l2_dev, "Invalid control\n");
+		break;
+	}
+
+	return 0;
+}
+
+static const struct v4l2_ioctl_ops jpeg_enc_ioctl_ops = {
+	.vidioc_querycap		= jpeg_enc_vidioc_querycap,
+
+	.vidioc_enum_fmt_vid_cap_mplane	= jpeg_enc_vidioc_enum_fmt,
+	.vidioc_enum_fmt_vid_cap	= jpeg_enc_vidioc_enum_fmt,
+	.vidioc_enum_fmt_vid_out_mplane	= jpeg_enc_vidioc_enum_fmt,
+	.vidioc_enum_fmt_vid_out	= jpeg_enc_vidioc_enum_fmt,
+
+	.vidioc_g_fmt_vid_cap_mplane	= jpeg_enc_vidioc_g_fmt,
+	.vidioc_g_fmt_vid_cap	= jpeg_enc_vidioc_g_fmt,
+	.vidioc_g_fmt_vid_out_mplane	= jpeg_enc_vidioc_g_fmt,
+	.vidioc_g_fmt_vid_out	= jpeg_enc_vidioc_g_fmt,
+
+	.vidioc_try_fmt_vid_cap_mplane		= jpeg_enc_vidioc_try_fmt,
+	.vidioc_try_fmt_vid_cap		= jpeg_enc_vidioc_try_fmt,
+	.vidioc_try_fmt_vid_out_mplane		= jpeg_enc_vidioc_try_fmt,
+	.vidioc_try_fmt_vid_out		= jpeg_enc_vidioc_try_fmt,
+	.vidioc_s_fmt_vid_cap_mplane		= jpeg_enc_vidioc_s_fmt_cap,
+	.vidioc_s_fmt_vid_cap		= jpeg_enc_vidioc_s_fmt_cap,
+	.vidioc_s_fmt_vid_out_mplane		= jpeg_enc_vidioc_s_fmt_out,
+	.vidioc_s_fmt_vid_out		= jpeg_enc_vidioc_s_fmt_out,
+
+	.vidioc_reqbufs		= jpeg_enc_m2m_reqbufs,
+	.vidioc_querybuf		= jpeg_enc_m2m_querybuf,
+	.vidioc_qbuf			= jpeg_enc_m2m_qbuf,
+	.vidioc_dqbuf			= jpeg_enc_m2m_dqbuf,
+	.vidioc_streamon		= jpeg_enc_m2m_streamon,
+	.vidioc_streamoff		= jpeg_enc_m2m_streamoff,
+	.vidioc_g_ctrl			= jpeg_enc_vidioc_g_ctrl,
+	.vidioc_g_jpegcomp		= vidioc_enc_g_jpegcomp,
+	.vidioc_s_jpegcomp		= vidioc_enc_s_jpegcomp,
+	.vidioc_s_ctrl			= jpeg_enc_vidioc_s_ctrl,
+};
+const struct v4l2_ioctl_ops *get_jpeg_enc_v4l2_ioctl_ops(void)
+{
+	return &jpeg_enc_ioctl_ops;
+}
diff --git a/drivers/media/platform/s5p-jpeg/jpeg-hw-v1.h b/drivers/media/platform/s5p-jpeg/jpeg-hw-v1.h
new file mode 100644
index 0000000..893c4fb
--- /dev/null
+++ b/drivers/media/platform/s5p-jpeg/jpeg-hw-v1.h
@@ -0,0 +1,528 @@
+/* linux/drivers/media/platform/s5p-jpeg/jpeg-hw-v1.h
+ *
+ * Copyright (c) 2011 Samsung Electronics Co., Ltd.
+ *              http://www.samsung.com
+ *
+ * Author: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef JPEG_HW_H_
+#define JPEG_HW_H_
+
+#include <linux/io.h>
+#include <linux/videodev2.h>
+
+#include "jpeg-regs-v1.h"
+
+#define S5P_JPEG_MIN_WIDTH		32
+#define S5P_JPEG_MIN_HEIGHT		32
+#define S5P_JPEG_MAX_WIDTH		8192
+#define S5P_JPEG_MAX_HEIGHT		8192
+#define S5P_JPEG_RAW_IN_565		0
+#define S5P_JPEG_RAW_IN_422		1
+#define S5P_JPEG_RAW_OUT_422		0
+#define S5P_JPEG_RAW_OUT_420		1
+
+/* Quantization and Huffman tables for S5P-JPEG-V1(Exynos 4210) IP */
+static const unsigned char qtbl_luminance[4][64] = {
+	{/* level 1 - high quality */
+		 8,  6,  6,  8, 12, 14, 16, 17,
+		 6,  6,  6,  8, 10, 13, 12, 15,
+		 6,  6,  7,  8, 13, 14, 18, 24,
+		 8,  8,  8, 14, 13, 19, 24, 35,
+		12, 10, 13, 13, 20, 26, 34, 39,
+		14, 13, 14, 19, 26, 34, 39, 39,
+		16, 12, 18, 24, 34, 39, 39, 39,
+		17, 15, 24, 35, 39, 39, 39, 39
+	},
+	{/* level 2 */
+		12,  8,  8, 12, 17, 21, 24, 23,
+		 8,  9,  9, 11, 15, 19, 18, 23,
+		 8,  9, 10, 12, 19, 20, 27, 36,
+		12, 11, 12, 21, 20, 28, 36, 53,
+		17, 15, 19, 20, 30, 39, 51, 59,
+		21, 19, 20, 28, 39, 51, 59, 59,
+		24, 18, 27, 36, 51, 59, 59, 59,
+		23, 23, 36, 53, 59, 59, 59, 59
+	},
+	{/* level 3 */
+		16, 11, 11, 16, 23, 27, 31, 30,
+		11, 12, 12, 15, 20, 23, 23, 30,
+		11, 12, 13, 16, 23, 26, 35, 47,
+		16, 15, 16, 23, 26, 37, 47, 64,
+		23, 20, 23, 26, 39, 51, 64, 64,
+		27, 23, 26, 37, 51, 64, 64, 64,
+		31, 23, 35, 47, 64, 64, 64, 64,
+		30, 30, 47, 64, 64, 64, 64, 64
+	},
+	{/*level 4 - low quality */
+		20, 16, 25, 39, 50, 46, 62, 68,
+		16, 18, 23, 38, 38, 53, 65, 68,
+		25, 23, 31, 38, 53, 65, 68, 68,
+		39, 38, 38, 53, 65, 68, 68, 68,
+		50, 38, 53, 65, 68, 68, 68, 68,
+		46, 53, 65, 68, 68, 68, 68, 68,
+		62, 65, 68, 68, 68, 68, 68, 68,
+		68, 68, 68, 68, 68, 68, 68, 68
+	}
+};
+
+static const unsigned char qtbl_chrominance[4][64] = {
+	{/* level 1 - high quality */
+		 9,  8,  9, 11, 14, 17, 19, 24,
+		 8, 10,  9, 11, 14, 13, 17, 22,
+		 9,  9, 13, 14, 13, 15, 23, 26,
+		11, 11, 14, 14, 15, 20, 26, 33,
+		14, 14, 13, 15, 20, 24, 33, 39,
+		17, 13, 15, 20, 24, 32, 39, 39,
+		19, 17, 23, 26, 33, 39, 39, 39,
+		24, 22, 26, 33, 39, 39, 39, 39
+	},
+	{/* level 2 */
+		13, 11, 13, 16, 20, 20, 29, 37,
+		11, 14, 14, 14, 16, 20, 26, 32,
+		13, 14, 15, 17, 20, 23, 35, 40,
+		16, 14, 17, 21, 23, 30, 40, 50,
+		20, 16, 20, 23, 30, 37, 50, 59,
+		20, 20, 23, 30, 37, 48, 59, 59,
+		29, 26, 35, 40, 50, 59, 59, 59,
+		37, 32, 40, 50, 59, 59, 59, 59
+	},
+	{/* level 3 */
+		17, 15, 17, 21, 20, 26, 38, 48,
+		15, 19, 18, 17, 20, 26, 35, 43,
+		17, 18, 20, 22, 26, 30, 46, 53,
+		21, 17, 22, 28, 30, 39, 53, 64,
+		20, 20, 26, 30, 39, 48, 64, 64,
+		26, 26, 30, 39, 48, 63, 64, 64,
+		38, 35, 46, 53, 64, 64, 64, 64,
+		48, 43, 53, 64, 64, 64, 64, 64
+	},
+	{/*level 4 - low quality */
+		21, 25, 32, 38, 54, 68, 68, 68,
+		25, 28, 24, 38, 54, 68, 68, 68,
+		32, 24, 32, 43, 66, 68, 68, 68,
+		38, 38, 43, 53, 68, 68, 68, 68,
+		54, 54, 66, 68, 68, 68, 68, 68,
+		68, 68, 68, 68, 68, 68, 68, 68,
+		68, 68, 68, 68, 68, 68, 68, 68,
+		68, 68, 68, 68, 68, 68, 68, 68
+	}
+};
+
+static const unsigned char hdctbl0[16] = {
+	0, 1, 5, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0
+};
+
+static const unsigned char hdctblg0[12] = {
+	0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 0xa, 0xb
+};
+static const unsigned char hactbl0[16] = {
+	0, 2, 1, 3, 3, 2, 4, 3, 5, 5, 4, 4, 0, 0, 1, 0x7d
+};
+static const unsigned char hactblg0[162] = {
+	0x01, 0x02, 0x03, 0x00, 0x04, 0x11, 0x05, 0x12,
+	0x21, 0x31, 0x41, 0x06, 0x13, 0x51, 0x61, 0x07,
+	0x22, 0x71, 0x14, 0x32, 0x81, 0x91, 0xa1, 0x08,
+	0x23, 0x42, 0xb1, 0xc1, 0x15, 0x52, 0xd1, 0xf0,
+	0x24, 0x33, 0x62, 0x72, 0x82, 0x09, 0x0a, 0x16,
+	0x17, 0x18, 0x19, 0x1a, 0x25, 0x26, 0x27, 0x28,
+	0x29, 0x2a, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39,
+	0x3a, 0x43, 0x44, 0x45, 0x46, 0x47, 0x48, 0x49,
+	0x4a, 0x53, 0x54, 0x55, 0x56, 0x57, 0x58, 0x59,
+	0x5a, 0x63, 0x64, 0x65, 0x66, 0x67, 0x68, 0x69,
+	0x6a, 0x73, 0x74, 0x75, 0x76, 0x77, 0x78, 0x79,
+	0x7a, 0x83, 0x84, 0x85, 0x86, 0x87, 0x88, 0x89,
+	0x8a, 0x92, 0x93, 0x94, 0x95, 0x96, 0x97, 0x98,
+	0x99, 0x9a, 0xa2, 0xa3, 0xa4, 0xa5, 0xa6, 0xa7,
+	0xa8, 0xa9, 0xaa, 0xb2, 0xb3, 0xb4, 0xb5, 0xb6,
+	0xb7, 0xb8, 0xb9, 0xba, 0xc2, 0xc3, 0xc4, 0xc5,
+	0xc6, 0xc7, 0xc8, 0xc9, 0xca, 0xd2, 0xd3, 0xd4,
+	0xd5, 0xd6, 0xd7, 0xd8, 0xd9, 0xda, 0xe1, 0xe2,
+	0xe3, 0xe4, 0xe5, 0xe6, 0xe7, 0xe8, 0xe9, 0xea,
+	0xf1, 0xf2, 0xf3, 0xf4, 0xf5, 0xf6, 0xf7, 0xf8,
+	0xf9, 0xfa
+};
+
+
+static inline void jpeg_set_qtbl(void __iomem *regs, const unsigned char *qtbl,
+		   unsigned long tab, int len)
+{
+	int i;
+
+	for (i = 0; i < len; i++)
+		writel((unsigned int)qtbl[i], regs + tab + (i * 0x04));
+}
+
+static inline void jpeg_set_qtbl_lum(void __iomem *regs, int quality)
+{
+	/* this driver fills quantisation table 0 with data for luma */
+	jpeg_set_qtbl(regs, qtbl_luminance[quality], S5P_JPG_QTBL_CONTENT(0),
+		      ARRAY_SIZE(qtbl_luminance[quality]));
+}
+
+static inline void jpeg_set_qtbl_chr(void __iomem *regs, int quality)
+{
+	/* this driver fills quantisation table 1 with data for chroma */
+	jpeg_set_qtbl(regs, qtbl_chrominance[quality], S5P_JPG_QTBL_CONTENT(1),
+		      ARRAY_SIZE(qtbl_chrominance[quality]));
+}
+
+static inline void jpeg_set_htbl(void __iomem *regs, const unsigned char *htbl,
+		   unsigned long tab, int len)
+{
+	int i;
+
+	for (i = 0; i < len; i++)
+		writel((unsigned int)htbl[i], regs + tab + (i * 0x04));
+}
+
+static inline void jpeg_set_hdctbl(void __iomem *regs)
+{
+	/* this driver fills table 0 for this component */
+	jpeg_set_htbl(regs, hdctbl0, S5P_JPG_HDCTBL(0), ARRAY_SIZE(hdctbl0));
+}
+
+static inline void jpeg_set_hdctblg(void __iomem *regs)
+{
+	/* this driver fills table 0 for this component */
+	jpeg_set_htbl(regs, hdctblg0, S5P_JPG_HDCTBLG(0), ARRAY_SIZE(hdctblg0));
+}
+
+static inline void jpeg_set_hactbl(void __iomem *regs)
+{
+	/* this driver fills table 0 for this component */
+	jpeg_set_htbl(regs, hactbl0, S5P_JPG_HACTBL(0), ARRAY_SIZE(hactbl0));
+}
+
+static inline void jpeg_set_hactblg(void __iomem *regs)
+{
+	/* this driver fills table 0 for this component */
+	jpeg_set_htbl(regs, hactblg0, S5P_JPG_HACTBLG(0), ARRAY_SIZE(hactblg0));
+}
+
+static inline void jpeg_reset(void __iomem *regs)
+{
+	unsigned long reg;
+
+	writel(1, regs + S5P_JPG_SW_RESET);
+	reg = readl(regs + S5P_JPG_SW_RESET);
+	/* no other way but polling for when JPEG IP becomes operational */
+	while (reg != 0) {
+		cpu_relax();
+		reg = readl(regs + S5P_JPG_SW_RESET);
+	}
+}
+
+static inline void jpeg_poweron(void __iomem *regs)
+{
+	writel(S5P_POWER_ON, regs + S5P_JPGCLKCON);
+}
+
+static inline void jpeg_input_raw_mode(void __iomem *regs, unsigned long mode)
+{
+	unsigned long reg, m;
+
+	m = S5P_MOD_SEL_565;
+	if (mode == S5P_JPEG_RAW_IN_565)
+		m = S5P_MOD_SEL_565;
+	else if (mode == S5P_JPEG_RAW_IN_422)
+		m = S5P_MOD_SEL_422;
+
+	reg = readl(regs + S5P_JPGCMOD);
+	reg &= ~S5P_MOD_SEL_MASK;
+	reg |= m;
+	writel(reg, regs + S5P_JPGCMOD);
+}
+
+static inline void jpeg_input_raw_y16(void __iomem *regs, bool y16)
+{
+	unsigned long reg;
+
+	reg = readl(regs + S5P_JPGCMOD);
+	if (y16)
+		reg |= S5P_MODE_Y16;
+	else
+		reg &= ~S5P_MODE_Y16_MASK;
+	writel(reg, regs + S5P_JPGCMOD);
+}
+
+static inline void jpeg_proc_mode(void __iomem *regs, unsigned long mode)
+{
+	unsigned long reg;
+
+	reg = readl(regs + S5P_JPGMOD);
+	reg &= ~S5P_PROC_MODE_MASK;
+	reg |= mode;
+	writel(reg, regs + S5P_JPGMOD);
+}
+
+static inline void jpeg_subsampling_mode(void __iomem *regs, unsigned int mode)
+{
+	unsigned long reg, m;
+
+	if (mode == V4L2_JPEG_CHROMA_SUBSAMPLING_420)
+		m = S5P_SUBSAMPLING_MODE_420;
+	else
+		m = S5P_SUBSAMPLING_MODE_422;
+
+	reg = readl(regs + S5P_JPGMOD);
+	reg &= ~S5P_SUBSAMPLING_MODE_MASK;
+	reg |= m;
+	writel(reg, regs + S5P_JPGMOD);
+}
+
+static inline unsigned int jpeg_get_subsampling_mode(void __iomem *regs)
+{
+	return readl(regs + S5P_JPGMOD) & S5P_SUBSAMPLING_MODE_MASK;
+}
+
+static inline void jpeg_dri(void __iomem *regs, unsigned int dri)
+{
+	unsigned long reg;
+
+	reg = readl(regs + S5P_JPGDRI_U);
+	reg &= ~0xff;
+	reg |= (dri >> 8) & 0xff;
+	writel(reg, regs + S5P_JPGDRI_U);
+
+	reg = readl(regs + S5P_JPGDRI_L);
+	reg &= ~0xff;
+	reg |= dri & 0xff;
+	writel(reg, regs + S5P_JPGDRI_L);
+}
+
+static inline void jpeg_qtbl(void __iomem *regs, unsigned int t, unsigned int n)
+{
+	unsigned long reg;
+
+	reg = readl(regs + S5P_JPG_QTBL);
+	reg &= ~S5P_QT_NUMt_MASK(t);
+	reg |= (n << S5P_QT_NUMt_SHIFT(t)) & S5P_QT_NUMt_MASK(t);
+	writel(reg, regs + S5P_JPG_QTBL);
+}
+
+static inline void jpeg_htbl_ac(void __iomem *regs, unsigned int t)
+{
+	unsigned long reg;
+
+	reg = readl(regs + S5P_JPG_HTBL);
+	reg &= ~S5P_HT_NUMt_AC_MASK(t);
+	/* this driver uses table 0 for all color components */
+	reg |= (0 << S5P_HT_NUMt_AC_SHIFT(t)) & S5P_HT_NUMt_AC_MASK(t);
+	writel(reg, regs + S5P_JPG_HTBL);
+}
+
+static inline void jpeg_htbl_dc(void __iomem *regs, unsigned int t)
+{
+	unsigned long reg;
+
+	reg = readl(regs + S5P_JPG_HTBL);
+	reg &= ~S5P_HT_NUMt_DC_MASK(t);
+	/* this driver uses table 0 for all color components */
+	reg |= (0 << S5P_HT_NUMt_DC_SHIFT(t)) & S5P_HT_NUMt_DC_MASK(t);
+	writel(reg, regs + S5P_JPG_HTBL);
+}
+
+static inline void jpeg_y(void __iomem *regs, unsigned int y)
+{
+	unsigned long reg;
+
+	reg = readl(regs + S5P_JPGY_U);
+	reg &= ~0xff;
+	reg |= (y >> 8) & 0xff;
+	writel(reg, regs + S5P_JPGY_U);
+
+	reg = readl(regs + S5P_JPGY_L);
+	reg &= ~0xff;
+	reg |= y & 0xff;
+	writel(reg, regs + S5P_JPGY_L);
+}
+
+static inline void jpeg_x(void __iomem *regs, unsigned int x)
+{
+	unsigned long reg;
+
+	reg = readl(regs + S5P_JPGX_U);
+	reg &= ~0xff;
+	reg |= (x >> 8) & 0xff;
+	writel(reg, regs + S5P_JPGX_U);
+
+	reg = readl(regs + S5P_JPGX_L);
+	reg &= ~0xff;
+	reg |= x & 0xff;
+	writel(reg, regs + S5P_JPGX_L);
+}
+
+static inline void jpeg_rst_int_enable(void __iomem *regs, bool enable)
+{
+	unsigned long reg;
+
+	reg = readl(regs + S5P_JPGINTSE);
+	reg &= ~S5P_RSTm_INT_EN_MASK;
+	if (enable)
+		reg |= S5P_RSTm_INT_EN;
+	writel(reg, regs + S5P_JPGINTSE);
+}
+
+static inline void jpeg_data_num_int_enable(void __iomem *regs, bool enable)
+{
+	unsigned long reg;
+
+	reg = readl(regs + S5P_JPGINTSE);
+	reg &= ~S5P_DATA_NUM_INT_EN_MASK;
+	if (enable)
+		reg |= S5P_DATA_NUM_INT_EN;
+	writel(reg, regs + S5P_JPGINTSE);
+}
+
+static inline void jpeg_final_mcu_num_int_enable(void __iomem *regs, bool enbl)
+{
+	unsigned long reg;
+
+	reg = readl(regs + S5P_JPGINTSE);
+	reg &= ~S5P_FINAL_MCU_NUM_INT_EN_MASK;
+	if (enbl)
+		reg |= S5P_FINAL_MCU_NUM_INT_EN;
+	writel(reg, regs + S5P_JPGINTSE);
+}
+
+static inline void jpeg_timer_enable(void __iomem *regs, unsigned long val)
+{
+	unsigned long reg;
+
+	reg = readl(regs + S5P_JPG_TIMER_SE);
+	reg |= S5P_TIMER_INT_EN;
+	reg &= ~S5P_TIMER_INIT_MASK;
+	reg |= val & S5P_TIMER_INIT_MASK;
+	writel(reg, regs + S5P_JPG_TIMER_SE);
+}
+
+static inline void jpeg_timer_disable(void __iomem *regs)
+{
+	unsigned long reg;
+
+	reg = readl(regs + S5P_JPG_TIMER_SE);
+	reg &= ~S5P_TIMER_INT_EN_MASK;
+	writel(reg, regs + S5P_JPG_TIMER_SE);
+}
+
+static inline int jpeg_timer_stat(void __iomem *regs)
+{
+	return (int)((readl(regs + S5P_JPG_TIMER_ST) & S5P_TIMER_INT_STAT_MASK)
+		     >> S5P_TIMER_INT_STAT_SHIFT);
+}
+
+static inline void jpeg_clear_timer_stat(void __iomem *regs)
+{
+	unsigned long reg;
+
+	reg = readl(regs + S5P_JPG_TIMER_SE);
+	reg &= ~S5P_TIMER_INT_STAT_MASK;
+	writel(reg, regs + S5P_JPG_TIMER_SE);
+}
+
+static inline void jpeg_enc_stream_int(void __iomem *regs, unsigned long size)
+{
+	unsigned long reg;
+
+	reg = readl(regs + S5P_JPG_ENC_STREAM_INTSE);
+	reg &= ~S5P_ENC_STREAM_BOUND_MASK;
+	reg |= S5P_ENC_STREAM_INT_EN;
+	reg |= size & S5P_ENC_STREAM_BOUND_MASK;
+	writel(reg, regs + S5P_JPG_ENC_STREAM_INTSE);
+}
+
+static inline int jpeg_enc_stream_stat(void __iomem *regs)
+{
+	return (int)(readl(regs + S5P_JPG_ENC_STREAM_INTST) &
+		     S5P_ENC_STREAM_INT_STAT_MASK);
+}
+
+static inline void jpeg_clear_enc_stream_stat(void __iomem *regs)
+{
+	unsigned long reg;
+
+	reg = readl(regs + S5P_JPG_ENC_STREAM_INTSE);
+	reg &= ~S5P_ENC_STREAM_INT_MASK;
+	writel(reg, regs + S5P_JPG_ENC_STREAM_INTSE);
+}
+
+static inline void jpeg_outform_raw(void __iomem *regs, unsigned long format)
+{
+	unsigned long reg, f;
+
+	f = S5P_DEC_OUT_FORMAT_422;
+	if (format == S5P_JPEG_RAW_OUT_422)
+		f = S5P_DEC_OUT_FORMAT_422;
+	else if (format == S5P_JPEG_RAW_OUT_420)
+		f = S5P_DEC_OUT_FORMAT_420;
+	reg = readl(regs + S5P_JPG_OUTFORM);
+	reg &= ~S5P_DEC_OUT_FORMAT_MASK;
+	reg |= f;
+	writel(reg, regs + S5P_JPG_OUTFORM);
+}
+
+static inline void jpeg_jpgadr(void __iomem *regs, unsigned long addr)
+{
+	writel(addr, regs + S5P_JPG_JPGADR);
+}
+
+static inline void jpeg_imgadr(void __iomem *regs, unsigned long addr)
+{
+	writel(addr, regs + S5P_JPG_IMGADR);
+}
+
+static inline void jpeg_coef(void __iomem *regs, unsigned int i,
+			     unsigned int j, unsigned int coef)
+{
+	unsigned long reg;
+
+	reg = readl(regs + S5P_JPG_COEF(i));
+	reg &= ~S5P_COEFn_MASK(j);
+	reg |= (coef << S5P_COEFn_SHIFT(j)) & S5P_COEFn_MASK(j);
+	writel(reg, regs + S5P_JPG_COEF(i));
+}
+
+static inline void jpeg_start(void __iomem *regs)
+{
+	writel(1, regs + S5P_JSTART);
+}
+
+static inline int jpeg_result_stat_ok(void __iomem *regs)
+{
+	return (int)((readl(regs + S5P_JPGINTST) & S5P_RESULT_STAT_MASK)
+		     >> S5P_RESULT_STAT_SHIFT);
+}
+
+static inline int jpeg_stream_stat_ok(void __iomem *regs)
+{
+	return !(int)((readl(regs + S5P_JPGINTST) & S5P_STREAM_STAT_MASK)
+		      >> S5P_STREAM_STAT_SHIFT);
+}
+
+static inline void jpeg_clear_int(void __iomem *regs)
+{
+	unsigned long reg;
+
+	reg = readl(regs + S5P_JPGINTST);
+	writel(S5P_INT_RELEASE, regs + S5P_JPGCOM);
+	reg = readl(regs + S5P_JPGOPR);
+}
+
+static inline unsigned int jpeg_compressed_size(void __iomem *regs)
+{
+	unsigned long jpeg_size = 0;
+
+	jpeg_size |= (readl(regs + S5P_JPGCNT_U) & 0xff) << 16;
+	jpeg_size |= (readl(regs + S5P_JPGCNT_M) & 0xff) << 8;
+	jpeg_size |= (readl(regs + S5P_JPGCNT_L) & 0xff);
+
+	return (unsigned int)jpeg_size;
+}
+
+#endif /* JPEG_HW_H_ */
diff --git a/drivers/media/platform/s5p-jpeg/jpeg-hw-v2.c b/drivers/media/platform/s5p-jpeg/jpeg-hw-v2.c
new file mode 100644
index 0000000..61f6fda
--- /dev/null
+++ b/drivers/media/platform/s5p-jpeg/jpeg-hw-v2.c
@@ -0,0 +1,614 @@
+/* Copyright (c) 2013 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com/
+ *
+ * Register interface file for JPEG driver on Exynos4x12 and 5250.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+#include <linux/io.h>
+#include <linux/delay.h>
+
+#include "jpeg-hw-v2.h"
+#include "jpeg-regs-v2.h"
+
+/* Q-table for S5P-JPEG-V2*/
+/*  ITU standard Q-table */
+const unsigned int ITU_Q_tbl[4][16] = {
+	{
+	0x100a0b10, 0x3d332818, 0x130e0c0c, 0x373c3a1a,	/*  table 0 */
+	0x18100d0e, 0x38453928, 0x1d16110e, 0x3e505733,
+	0x38251612, 0x4d676d44, 0x40372318, 0x5c716851,
+	0x574e4031, 0x65787967, 0x625f5c48, 0x63676470
+	} , {
+	0x2f181211, 0x63636363, 0x421a1512, 0x63636363,	/* table 1 */
+	0x63381a18, 0x63636363, 0x6363422f, 0x63636363,
+	0x63636363, 0x63636363, 0x63636363, 0x63636363,
+	0x63636363, 0x63636363, 0x63636363, 0x63636363
+	} , {
+	0x100a0b10, 0x3d332818, 0x130e0c0c, 0x373c3a1a,	/* table 2 */
+	0x18100d0e, 0x38453928, 0x1d16110e, 0x3e505733,
+	0x38251612, 0x4d676d44, 0x40372318, 0x5c716851,
+	0x574e4031, 0x65787967, 0x625f5c48, 0x63676470
+	} , {
+	0x2f181211, 0x63636363, 0x421a1512, 0x63636363,	/* table 3 */
+	0x63381a18, 0x63636363, 0x6363422f, 0x63636363,
+	0x63636363, 0x63636363, 0x63636363, 0x63636363,
+	0x63636363, 0x63636363, 0x63636363, 0x63636363
+	}
+};
+
+/* ITU Luminace Huffman Table */
+static unsigned int itu_h_tbl_len_dc_luminance[4] = {
+	0x00000000, 0x00000000, 0x00000000, 0x00000c00
+};
+static unsigned int itu_h_tbl_val_dc_luminance[3] = {
+	0x03020100, 0x07060504, 0x0b0a0908
+};
+
+/* ITU Chrominace Huffman Table */
+static unsigned int itu_h_tbl_len_dc_chrominance[4] = {
+	0x00000000, 0x00000000, 0x00000000, 0x000c0000
+};
+static unsigned int itu_h_tbl_val_dc_chrominance[3] = {
+	0x03020100, 0x07060504, 0x0b0a0908
+};
+static unsigned int itu_h_tbl_len_ac_luminance[4] = {
+	0x00000000, 0x00000000, 0x00000000, 0xa2000000
+};
+
+static unsigned int itu_h_tbl_val_ac_luminance[41] = {
+	0x00030201, 0x12051104, 0x06413121, 0x07615113,
+	0x32147122, 0x08a19181, 0xc1b14223, 0xf0d15215,
+	0x72623324, 0x160a0982, 0x1a191817, 0x28272625,
+	0x35342a29, 0x39383736, 0x4544433a, 0x49484746,
+	0x5554534a, 0x59585756, 0x6564635a, 0x69686766,
+	0x7574736a, 0x79787776, 0x8584837a, 0x89888786,
+	0x9493928a, 0x98979695, 0xa3a29a99, 0xa7a6a5a4,
+	0xb2aaa9a8, 0xb6b5b4b3, 0xbab9b8b7, 0xc5c4c3c2,
+	0xc9c8c7c6, 0xd4d3d2ca, 0xd8d7d6d5, 0xe2e1dad9,
+	0xe6e5e4e3, 0xeae9e8e7, 0xf4f3f2f1, 0xf8f7f6f5,
+	0x0000faf9
+};
+
+static u32 itu_h_tbl_len_ac_chrominance[4] = {
+	0x00000000, 0x00000000, 0x51000000, 0x00000051
+};
+static u32 itu_h_tbl_val_ac_chrominance[41] = {
+	0x00030201, 0x12051104, 0x06413121, 0x07615113,
+	0x32147122, 0x08a19181, 0xc1b14223, 0xf0d15215,
+	0x72623324, 0x160a0982, 0x1a191817, 0x28272625,
+	0x35342a29, 0x39383736, 0x4544433a, 0x49484746,
+	0x5554534a, 0x59585756, 0x6564635a, 0x69686766,
+	0x7574736a, 0x79787776, 0x8584837a, 0x89888786,
+	0x9493928a, 0x98979695, 0xa3a29a99, 0xa7a6a5a4,
+	0xb2aaa9a8, 0xb6b5b4b3, 0xbab9b8b7, 0xc5c4c3c2,
+	0xc9c8c7c6, 0xd4d3d2ca, 0xd8d7d6d5, 0xe2e1dad9,
+	0xe6e5e4e3, 0xeae9e8e7, 0xf4f3f2f1, 0xf8f7f6f5,
+	0x0000faf9
+};
+
+void jpeg_sw_reset(void __iomem *base)
+{
+	unsigned int reg;
+
+	reg = readl(base + S5P_JPEG_CNTL_REG);
+	writel(reg & ~S5P_JPEG_SOFT_RESET_HI,
+			base + S5P_JPEG_CNTL_REG);
+
+	ndelay(100000);
+
+	writel(reg | S5P_JPEG_SOFT_RESET_HI,
+			base + S5P_JPEG_CNTL_REG);
+}
+
+void jpeg_set_enc_dec_mode(void __iomem *base, enum jpeg_mode mode)
+{
+	unsigned int reg;
+
+	reg = readl(base + S5P_JPEG_CNTL_REG);
+	/* set jpeg mod register */
+	if (mode == DECODING) {
+		writel((reg & S5P_JPEG_ENC_DEC_MODE_MASK) | S5P_JPEG_DEC_MODE,
+			base + S5P_JPEG_CNTL_REG);
+	} else {/* encode */
+		writel((reg & S5P_JPEG_ENC_DEC_MODE_MASK) | S5P_JPEG_ENC_MODE,
+			base + S5P_JPEG_CNTL_REG);
+	}
+}
+
+void jpeg_set_dec_out_fmt(void __iomem *base,
+					enum jpeg_frame_format out_fmt)
+{
+	unsigned int reg = 0;
+
+	writel(0, base + S5P_JPEG_IMG_FMT_REG); /* clear */
+
+	/* set jpeg deocde ouput format register */
+	switch (out_fmt) {
+	case GRAY:
+		reg = S5P_JPEG_DEC_GRAY_IMG  |
+				S5P_JPEG_GRAY_IMG_IP;
+		break;
+
+	case RGB_888:
+		reg = S5P_JPEG_DEC_RGB_IMG |
+				S5P_JPEG_RGB_IP_RGB_32BIT_IMG;
+		break;
+
+	case RGB_565:
+		reg = S5P_JPEG_DEC_RGB_IMG |
+				S5P_JPEG_RGB_IP_RGB_16BIT_IMG;
+		break;
+
+	case YCRCB_444_2P:
+		reg = S5P_JPEG_DEC_YUV_444_IMG |
+				S5P_JPEG_YUV_444_IP_YUV_444_2P_IMG |
+				S5P_JPEG_SWAP_CHROMA_CrCb;
+		break;
+
+	case YCBCR_444_2P:
+		reg = S5P_JPEG_DEC_YUV_444_IMG |
+				S5P_JPEG_YUV_444_IP_YUV_444_2P_IMG |
+				S5P_JPEG_SWAP_CHROMA_CbCr;
+		break;
+
+	case YCBCR_444_3P:
+		reg = S5P_JPEG_DEC_YUV_444_IMG |
+			S5P_JPEG_YUV_444_IP_YUV_444_3P_IMG;
+		break;
+
+	case YCRYCB_422_1P:
+		reg = S5P_JPEG_DEC_YUV_422_IMG |
+				S5P_JPEG_YUV_422_IP_YUV_422_1P_IMG |
+				S5P_JPEG_SWAP_CHROMA_CrCb;
+		break;
+
+	case YCBYCR_422_1P:
+		reg = S5P_JPEG_DEC_YUV_422_IMG |
+				S5P_JPEG_YUV_422_IP_YUV_422_1P_IMG |
+				S5P_JPEG_SWAP_CHROMA_CbCr;
+		break;
+
+	case YCRCB_422_2P:
+		reg = S5P_JPEG_DEC_YUV_422_IMG |
+				S5P_JPEG_YUV_422_IP_YUV_422_2P_IMG |
+				S5P_JPEG_SWAP_CHROMA_CrCb;
+		break;
+
+	case YCBCR_422_2P:
+		reg = S5P_JPEG_DEC_YUV_422_IMG |
+				S5P_JPEG_YUV_422_IP_YUV_422_2P_IMG |
+				S5P_JPEG_SWAP_CHROMA_CbCr;
+		break;
+
+	case YCBYCR_422_3P:
+		reg = S5P_JPEG_DEC_YUV_422_IMG |
+				S5P_JPEG_YUV_422_IP_YUV_422_3P_IMG;
+		break;
+
+	case YCRCB_420_1P:
+	case YCRCB_420_2P:
+		reg = S5P_JPEG_DEC_YUV_420_IMG |
+				S5P_JPEG_YUV_420_IP_YUV_420_2P_IMG |
+				S5P_JPEG_SWAP_CHROMA_CrCb;
+		break;
+
+	case YCBCR_420_1P:
+	case YCBCR_420_2P:
+		reg = S5P_JPEG_DEC_YUV_420_IMG |
+				S5P_JPEG_YUV_420_IP_YUV_420_2P_IMG |
+				S5P_JPEG_SWAP_CHROMA_CbCr;
+		break;
+
+	case YCBCR_420_3P:
+		reg = S5P_JPEG_DEC_YUV_420_IMG |
+				S5P_JPEG_YUV_420_IP_YUV_420_3P_IMG;
+		break;
+
+	default:
+		break;
+	}
+
+	writel(reg, base + S5P_JPEG_IMG_FMT_REG);
+}
+
+void jpeg_set_enc_in_fmt(void __iomem *base,
+					enum jpeg_frame_format in_fmt)
+{
+	unsigned int reg;
+
+	reg = readl(base + S5P_JPEG_IMG_FMT_REG) &
+			S5P_JPEG_ENC_IN_FMT_MASK; /* clear except enc format */
+
+	switch (in_fmt) {
+	case GRAY:
+		reg = reg | S5P_JPEG_ENC_GRAY_IMG | S5P_JPEG_GRAY_IMG_IP;
+		break;
+
+	case RGB_888:
+		reg = reg | S5P_JPEG_ENC_RGB_IMG |
+				S5P_JPEG_RGB_IP_RGB_32BIT_IMG;
+		break;
+
+	case RGB_565:
+		reg = reg | S5P_JPEG_ENC_RGB_IMG |
+				S5P_JPEG_RGB_IP_RGB_16BIT_IMG;
+		break;
+
+	case YCRCB_444_2P:
+		reg = reg | S5P_JPEG_ENC_YUV_444_IMG |
+				S5P_JPEG_YUV_444_IP_YUV_444_2P_IMG |
+				S5P_JPEG_SWAP_CHROMA_CrCb;
+		break;
+
+	case YCBCR_444_2P:
+		reg = reg | S5P_JPEG_ENC_YUV_444_IMG |
+				S5P_JPEG_YUV_444_IP_YUV_444_2P_IMG |
+				S5P_JPEG_SWAP_CHROMA_CbCr;
+		break;
+
+	case YCBCR_444_3P:
+		reg = reg | S5P_JPEG_ENC_YUV_444_IMG |
+				S5P_JPEG_YUV_444_IP_YUV_444_3P_IMG;
+		break;
+
+	case YCRYCB_422_1P:
+		reg = reg | S5P_JPEG_DEC_YUV_422_IMG |
+				S5P_JPEG_YUV_422_IP_YUV_422_1P_IMG |
+				S5P_JPEG_SWAP_CHROMA_CrCb;
+		break;
+
+	case YCBYCR_422_1P:
+		reg = reg | S5P_JPEG_DEC_YUV_422_IMG |
+				S5P_JPEG_YUV_422_IP_YUV_422_1P_IMG |
+				S5P_JPEG_SWAP_CHROMA_CbCr;
+		break;
+
+	case YCRCB_422_2P:
+		reg = reg | S5P_JPEG_DEC_YUV_422_IMG |
+				S5P_JPEG_YUV_422_IP_YUV_422_2P_IMG |
+				S5P_JPEG_SWAP_CHROMA_CrCb;
+		break;
+
+	case YCBCR_422_2P:
+		reg = reg | S5P_JPEG_DEC_YUV_422_IMG |
+				S5P_JPEG_YUV_422_IP_YUV_422_2P_IMG |
+				S5P_JPEG_SWAP_CHROMA_CbCr;
+		break;
+
+	case YCBYCR_422_3P:
+		reg = reg | S5P_JPEG_DEC_YUV_422_IMG |
+				S5P_JPEG_YUV_422_IP_YUV_422_3P_IMG;
+		break;
+
+	case YCRCB_420_1P:
+	case YCRCB_420_2P:
+		reg = reg | S5P_JPEG_DEC_YUV_420_IMG |
+				S5P_JPEG_YUV_420_IP_YUV_420_2P_IMG |
+				S5P_JPEG_SWAP_CHROMA_CrCb;
+		break;
+
+	case YCBCR_420_1P:
+	case YCBCR_420_2P:
+		reg = reg | S5P_JPEG_DEC_YUV_420_IMG |
+				S5P_JPEG_YUV_420_IP_YUV_420_2P_IMG |
+				S5P_JPEG_SWAP_CHROMA_CbCr;
+		break;
+
+	case YCBCR_420_3P:
+		reg = reg | S5P_JPEG_DEC_YUV_420_IMG |
+				S5P_JPEG_YUV_420_IP_YUV_420_3P_IMG;
+		break;
+
+	default:
+		break;
+
+	}
+
+	writel(reg, base + S5P_JPEG_IMG_FMT_REG);
+
+}
+
+void jpeg_set_enc_out_fmt(void __iomem *base,
+					enum jpeg_stream_format out_fmt)
+{
+	unsigned int reg;
+
+	reg = readl(base + S5P_JPEG_IMG_FMT_REG) &
+			~S5P_JPEG_ENC_FMT_MASK; /* clear enc format */
+
+	switch (out_fmt) {
+	case JPEG_GRAY:
+		reg = reg | S5P_JPEG_ENC_FMT_GRAY;
+		break;
+
+	case JPEG_444:
+		reg = reg | S5P_JPEG_ENC_FMT_YUV_444;
+		break;
+
+	case JPEG_422:
+		reg = reg | S5P_JPEG_ENC_FMT_YUV_422;
+		break;
+
+	case JPEG_420:
+		reg = reg | S5P_JPEG_ENC_FMT_YUV_420;
+		break;
+
+	default:
+		break;
+	}
+
+	writel(reg, base + S5P_JPEG_IMG_FMT_REG);
+}
+
+void jpeg_set_enc_tbl(void __iomem *base)
+{
+	int i;
+
+	for (i = 0; i < 16; i++) {
+		writel((unsigned int)ITU_Q_tbl[0][i],
+			base + S5P_JPEG_QUAN_TBL_ENTRY_REG + (i*0x04));
+	}
+
+	for (i = 0; i < 16; i++) {
+		writel((unsigned int)ITU_Q_tbl[1][i],
+			base + S5P_JPEG_QUAN_TBL_ENTRY_REG + 0x40 + (i*0x04));
+	}
+
+	for (i = 0; i < 16; i++) {
+		writel((unsigned int)ITU_Q_tbl[2][i],
+			base + S5P_JPEG_QUAN_TBL_ENTRY_REG + 0x80 + (i*0x04));
+	}
+
+	for (i = 0; i < 16; i++) {
+		writel((unsigned int)ITU_Q_tbl[3][i],
+			base + S5P_JPEG_QUAN_TBL_ENTRY_REG + 0xc0 + (i*0x04));
+	}
+
+	for (i = 0; i < 4; i++) {
+		writel((unsigned int)itu_h_tbl_len_dc_luminance[i],
+			base + S5P_JPEG_HUFF_TBL_ENTRY_REG + (i*0x04));
+	}
+
+	for (i = 0; i < 3; i++) {
+		writel((unsigned int)itu_h_tbl_val_dc_luminance[i],
+			base + S5P_JPEG_HUFF_TBL_ENTRY_REG + 0x10 + (i*0x04));
+	}
+
+	for (i = 0; i < 4; i++) {
+		writel((unsigned int)itu_h_tbl_len_dc_chrominance[i],
+			base + S5P_JPEG_HUFF_TBL_ENTRY_REG + 0x20 + (i*0x04));
+	}
+
+	for (i = 0; i < 3; i++) {
+		writel((unsigned int)itu_h_tbl_val_dc_chrominance[i],
+			base + S5P_JPEG_HUFF_TBL_ENTRY_REG + 0x30 + (i*0x04));
+	}
+
+	for (i = 0; i < 4; i++) {
+		writel((unsigned int)itu_h_tbl_len_ac_luminance[i],
+			base + S5P_JPEG_HUFF_TBL_ENTRY_REG + 0x40 + (i*0x04));
+	}
+
+	for (i = 0; i < 41; i++) {
+		writel((unsigned int)itu_h_tbl_val_ac_luminance[i],
+			base + S5P_JPEG_HUFF_TBL_ENTRY_REG + 0x50 + (i*0x04));
+	}
+
+	for (i = 0; i < 4; i++) {
+		writel((unsigned int)itu_h_tbl_len_ac_chrominance[i],
+			base + S5P_JPEG_HUFF_TBL_ENTRY_REG + 0x100 + (i*0x04));
+	}
+
+	for (i = 0; i < 41; i++) {
+		writel((unsigned int)itu_h_tbl_val_ac_chrominance[i],
+			base + S5P_JPEG_HUFF_TBL_ENTRY_REG + 0x110 + (i*0x04));
+	}
+
+}
+
+void jpeg_set_interrupt(void __iomem *base)
+{
+	unsigned int reg;
+
+	reg = readl(base + S5P_JPEG_INT_EN_REG) & ~S5P_JPEG_INT_EN_MASK;
+	writel(S5P_JPEG_INT_EN_ALL, base + S5P_JPEG_INT_EN_REG);
+}
+
+unsigned int jpeg_get_int_status(void __iomem *base)
+{
+	unsigned int	int_status;
+
+	int_status = readl(base + S5P_JPEG_INT_STATUS_REG);
+
+	return int_status;
+}
+
+void jpeg_set_huf_table_enable(void __iomem *base, int value)
+{
+	unsigned int	reg;
+
+	reg = readl(base + S5P_JPEG_CNTL_REG) & ~S5P_JPEG_HUF_TBL_EN;
+
+	if (value == 1)
+		writel(reg | S5P_JPEG_HUF_TBL_EN, base + S5P_JPEG_CNTL_REG);
+	else
+		writel(reg | ~S5P_JPEG_HUF_TBL_EN, base + S5P_JPEG_CNTL_REG);
+}
+
+void jpeg_set_dec_scaling(void __iomem *base,
+		enum jpeg_scale_value x_value, enum jpeg_scale_value y_value)
+{
+	unsigned int	reg;
+
+	reg = readl(base + S5P_JPEG_CNTL_REG) &
+			~(S5P_JPEG_HOR_SCALING_MASK |
+				S5P_JPEG_VER_SCALING_MASK);
+
+	writel(reg | S5P_JPEG_HOR_SCALING(x_value) |
+			S5P_JPEG_VER_SCALING(y_value),
+				base + S5P_JPEG_CNTL_REG);
+}
+
+void jpeg_set_sys_int_enable(void __iomem *base, int value)
+{
+	unsigned int	reg;
+
+	reg = readl(base + S5P_JPEG_CNTL_REG) & ~(S5P_JPEG_SYS_INT_EN);
+
+	if (value == 1)
+		writel(S5P_JPEG_SYS_INT_EN, base + S5P_JPEG_CNTL_REG);
+	else
+		writel(~S5P_JPEG_SYS_INT_EN, base + S5P_JPEG_CNTL_REG);
+}
+
+void jpeg_set_stream_buf_address(void __iomem *base, unsigned int address)
+{
+	writel(address, base + S5P_JPEG_OUT_MEM_BASE_REG);
+}
+
+void jpeg_set_stream_size(void __iomem *base,
+		unsigned int x_value, unsigned int y_value)
+{
+	writel(0x0, base + S5P_JPEG_IMG_SIZE_REG); /* clear */
+	writel(S5P_JPEG_X_SIZE(x_value) | S5P_JPEG_Y_SIZE(y_value),
+			base + S5P_JPEG_IMG_SIZE_REG);
+}
+
+void jpeg_set_frame_buf_address(void __iomem *base,
+		enum jpeg_frame_format fmt, unsigned int address_1p,
+		unsigned int address_2p, unsigned int address_3p)
+{
+	switch (fmt) {
+	case GRAY:
+	case RGB_565:
+	case RGB_888:
+	case YCRYCB_422_1P:
+	case YCBYCR_422_1P:
+		writel(address_1p, base + S5P_JPEG_IMG_BA_PLANE_1_REG);
+		writel(0, base + S5P_JPEG_IMG_BA_PLANE_2_REG);
+		writel(0, base + S5P_JPEG_IMG_BA_PLANE_3_REG);
+		break;
+	case YCBCR_444_2P:
+	case YCRCB_444_2P:
+	case YCRCB_422_2P:
+	case YCBCR_422_2P:
+	case YCBCR_420_2P:
+	case YCRCB_420_2P:
+	case YCBCR_420_1P:
+	case YCRCB_420_1P:
+		writel(address_1p, base + S5P_JPEG_IMG_BA_PLANE_1_REG);
+		writel(address_2p, base + S5P_JPEG_IMG_BA_PLANE_2_REG);
+		writel(0, base + S5P_JPEG_IMG_BA_PLANE_3_REG);
+		break;
+	case YCBCR_444_3P:
+		writel(address_1p, base + S5P_JPEG_IMG_BA_PLANE_1_REG);
+		writel(address_2p, base + S5P_JPEG_IMG_BA_PLANE_2_REG);
+		writel(address_3p, base + S5P_JPEG_IMG_BA_PLANE_3_REG);
+		break;
+	case YCBYCR_422_3P:
+		writel(address_1p, base + S5P_JPEG_IMG_BA_PLANE_1_REG);
+		writel(address_2p, base + S5P_JPEG_IMG_BA_PLANE_2_REG);
+		writel(address_3p, base + S5P_JPEG_IMG_BA_PLANE_3_REG);
+		break;
+	case YCBCR_420_3P:
+		writel(address_1p, base + S5P_JPEG_IMG_BA_PLANE_1_REG);
+		writel(address_2p, base + S5P_JPEG_IMG_BA_PLANE_2_REG);
+		writel(address_3p, base + S5P_JPEG_IMG_BA_PLANE_3_REG);
+		break;
+	default:
+		break;
+	}
+}
+void jpeg_set_encode_tbl_select(void __iomem *base,
+		enum jpeg_img_quality_level level)
+{
+	unsigned int	reg;
+
+	switch (level) {
+	case QUALITY_LEVEL_1:
+		reg = S5P_JPEG_Q_TBL_COMP1_0 | S5P_JPEG_Q_TBL_COMP2_0 |
+			S5P_JPEG_Q_TBL_COMP3_0 |
+			S5P_JPEG_HUFF_TBL_COMP1_AC_0_DC_1 |
+			S5P_JPEG_HUFF_TBL_COMP2_AC_0_DC_0 |
+			S5P_JPEG_HUFF_TBL_COMP3_AC_1_DC_1;
+		break;
+	case QUALITY_LEVEL_2:
+		reg = S5P_JPEG_Q_TBL_COMP1_1 | S5P_JPEG_Q_TBL_COMP2_1 |
+			S5P_JPEG_Q_TBL_COMP3_1 |
+			S5P_JPEG_HUFF_TBL_COMP1_AC_0_DC_1 |
+			S5P_JPEG_HUFF_TBL_COMP2_AC_0_DC_0 |
+			S5P_JPEG_HUFF_TBL_COMP3_AC_1_DC_1;
+		break;
+	case QUALITY_LEVEL_3:
+		reg = S5P_JPEG_Q_TBL_COMP1_2 | S5P_JPEG_Q_TBL_COMP2_2 |
+			S5P_JPEG_Q_TBL_COMP3_2 |
+			S5P_JPEG_HUFF_TBL_COMP1_AC_0_DC_1 |
+			S5P_JPEG_HUFF_TBL_COMP2_AC_0_DC_0 |
+			S5P_JPEG_HUFF_TBL_COMP3_AC_1_DC_1;
+		break;
+	case QUALITY_LEVEL_4:
+		reg = S5P_JPEG_Q_TBL_COMP1_3 | S5P_JPEG_Q_TBL_COMP2_3 |
+			S5P_JPEG_Q_TBL_COMP3_3 |
+			S5P_JPEG_HUFF_TBL_COMP1_AC_0_DC_1 |
+			S5P_JPEG_HUFF_TBL_COMP2_AC_0_DC_0 |
+			S5P_JPEG_HUFF_TBL_COMP3_AC_1_DC_1;
+		break;
+	default:
+		reg = S5P_JPEG_Q_TBL_COMP1_0 | S5P_JPEG_Q_TBL_COMP2_0 |
+			S5P_JPEG_Q_TBL_COMP3_1 |
+			S5P_JPEG_HUFF_TBL_COMP1_AC_0_DC_1 |
+			S5P_JPEG_HUFF_TBL_COMP2_AC_0_DC_0 |
+			S5P_JPEG_HUFF_TBL_COMP3_AC_1_DC_1;
+		break;
+	}
+	writel(reg, base + S5P_JPEG_TBL_SEL_REG);
+}
+
+void jpeg_set_encode_hoff_cnt(void __iomem *base, enum jpeg_stream_format fmt)
+{
+	if (fmt == JPEG_GRAY)
+		writel(0xd2, base + S5P_JPEG_HUFF_CNT_REG);
+	else
+		writel(0x1a2, base + S5P_JPEG_HUFF_CNT_REG);
+}
+
+unsigned int jpeg_get_stream_size(void __iomem *base)
+{
+	unsigned int size;
+
+	size = readl(base + S5P_JPEG_BITSTREAM_SIZE_REG);
+	return size;
+}
+
+void jpeg_set_dec_bitstream_size(void __iomem *base, unsigned int size)
+{
+	writel(size, base + S5P_JPEG_BITSTREAM_SIZE_REG);
+}
+
+void jpeg_get_frame_size(void __iomem *base,
+			unsigned int *width, unsigned int *height)
+{
+	*width = (readl(base + S5P_JPEG_DECODE_XY_SIZE_REG) &
+				S5P_JPEG_DECODED_SIZE_MASK);
+	*height = (readl(base + S5P_JPEG_DECODE_XY_SIZE_REG) >> 16) &
+				S5P_JPEG_DECODED_SIZE_MASK;
+}
+
+enum jpeg_stream_format jpeg_get_frame_fmt(void __iomem *base)
+{
+	unsigned int	reg;
+	enum jpeg_stream_format out_format;
+
+	reg = readl(base + S5P_JPEG_DECODE_IMG_FMT_REG);
+
+	out_format =
+		((reg & 0x03) == 0x01) ? JPEG_444 :
+		((reg & 0x03) == 0x02) ? JPEG_422 :
+		((reg & 0x03) == 0x03) ? JPEG_420 :
+		((reg & 0x03) == 0x00) ? JPEG_GRAY : JPEG_RESERVED;
+
+	return out_format;
+}
diff --git a/drivers/media/platform/s5p-jpeg/jpeg-hw-v2.h b/drivers/media/platform/s5p-jpeg/jpeg-hw-v2.h
new file mode 100644
index 0000000..4e36061
--- /dev/null
+++ b/drivers/media/platform/s5p-jpeg/jpeg-hw-v2.h
@@ -0,0 +1,47 @@
+/* Copyright (c) 2013 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com/
+ *
+ * Header file of the register interface for JPEG driver on Exynos4x12 and 5250.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+#ifndef __JPEG_REGS_H__
+#define __JPEG_REGS_H__
+
+#include "jpeg-core.h"
+
+void jpeg_sw_reset(void __iomem *base);
+void jpeg_set_enc_dec_mode(void __iomem *base, enum jpeg_mode mode);
+void jpeg_set_dec_out_fmt(void __iomem *base,
+					enum jpeg_frame_format out_fmt);
+void jpeg_set_enc_in_fmt(void __iomem *base,
+					enum jpeg_frame_format in_fmt);
+void jpeg_set_enc_out_fmt(void __iomem *base,
+					enum jpeg_stream_format out_fmt);
+void jpeg_set_enc_tbl(void __iomem *base);
+void jpeg_set_interrupt(void __iomem *base);
+unsigned int jpeg_get_int_status(void __iomem *base);
+void jpeg_set_huf_table_enable(void __iomem *base, int value);
+void jpeg_set_dec_scaling(void __iomem *base,
+		enum jpeg_scale_value x_value, enum jpeg_scale_value y_value);
+void jpeg_set_sys_int_enable(void __iomem *base, int value);
+void jpeg_set_stream_buf_address(void __iomem *base, unsigned int address);
+void jpeg_set_stream_size(void __iomem *base,
+		unsigned int x_value, unsigned int y_value);
+void jpeg_set_frame_buf_address(void __iomem *base,
+		enum jpeg_frame_format fmt, unsigned int address,
+		unsigned int address_2p, unsigned int address_3p);
+void jpeg_set_encode_tbl_select(void __iomem *base,
+		enum jpeg_img_quality_level level);
+void jpeg_set_encode_hoff_cnt(void __iomem *base, enum jpeg_stream_format fmt);
+void jpeg_set_dec_bitstream_size(void __iomem *base, unsigned int size);
+unsigned int jpeg_get_stream_size(void __iomem *base);
+void jpeg_get_frame_size(void __iomem *base,
+			unsigned int *width, unsigned int *height);
+
+enum jpeg_stream_format jpeg_get_frame_fmt(void __iomem *base);
+
+#endif /* __JPEG_REGS_H__ */
diff --git a/drivers/media/platform/s5p-jpeg/jpeg-hw.h b/drivers/media/platform/s5p-jpeg/jpeg-hw.h
deleted file mode 100644
index b47e887..0000000
--- a/drivers/media/platform/s5p-jpeg/jpeg-hw.h
+++ /dev/null
@@ -1,357 +0,0 @@
-/* linux/drivers/media/platform/s5p-jpeg/jpeg-hw.h
- *
- * Copyright (c) 2011 Samsung Electronics Co., Ltd.
- *		http://www.samsung.com
- *
- * Author: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-#ifndef JPEG_HW_H_
-#define JPEG_HW_H_
-
-#include <linux/io.h>
-#include <linux/videodev2.h>
-
-#include "jpeg-hw.h"
-#include "jpeg-regs.h"
-
-#define S5P_JPEG_MIN_WIDTH		32
-#define S5P_JPEG_MIN_HEIGHT		32
-#define S5P_JPEG_MAX_WIDTH		8192
-#define S5P_JPEG_MAX_HEIGHT		8192
-#define S5P_JPEG_ENCODE			0
-#define S5P_JPEG_DECODE			1
-#define S5P_JPEG_RAW_IN_565		0
-#define S5P_JPEG_RAW_IN_422		1
-#define S5P_JPEG_RAW_OUT_422		0
-#define S5P_JPEG_RAW_OUT_420		1
-
-static inline void jpeg_reset(void __iomem *regs)
-{
-	unsigned long reg;
-
-	writel(1, regs + S5P_JPG_SW_RESET);
-	reg = readl(regs + S5P_JPG_SW_RESET);
-	/* no other way but polling for when JPEG IP becomes operational */
-	while (reg != 0) {
-		cpu_relax();
-		reg = readl(regs + S5P_JPG_SW_RESET);
-	}
-}
-
-static inline void jpeg_poweron(void __iomem *regs)
-{
-	writel(S5P_POWER_ON, regs + S5P_JPGCLKCON);
-}
-
-static inline void jpeg_input_raw_mode(void __iomem *regs, unsigned long mode)
-{
-	unsigned long reg, m;
-
-	m = S5P_MOD_SEL_565;
-	if (mode == S5P_JPEG_RAW_IN_565)
-		m = S5P_MOD_SEL_565;
-	else if (mode == S5P_JPEG_RAW_IN_422)
-		m = S5P_MOD_SEL_422;
-
-	reg = readl(regs + S5P_JPGCMOD);
-	reg &= ~S5P_MOD_SEL_MASK;
-	reg |= m;
-	writel(reg, regs + S5P_JPGCMOD);
-}
-
-static inline void jpeg_input_raw_y16(void __iomem *regs, bool y16)
-{
-	unsigned long reg;
-
-	reg = readl(regs + S5P_JPGCMOD);
-	if (y16)
-		reg |= S5P_MODE_Y16;
-	else
-		reg &= ~S5P_MODE_Y16_MASK;
-	writel(reg, regs + S5P_JPGCMOD);
-}
-
-static inline void jpeg_proc_mode(void __iomem *regs, unsigned long mode)
-{
-	unsigned long reg, m;
-
-	m = S5P_PROC_MODE_DECOMPR;
-	if (mode == S5P_JPEG_ENCODE)
-		m = S5P_PROC_MODE_COMPR;
-	else
-		m = S5P_PROC_MODE_DECOMPR;
-	reg = readl(regs + S5P_JPGMOD);
-	reg &= ~S5P_PROC_MODE_MASK;
-	reg |= m;
-	writel(reg, regs + S5P_JPGMOD);
-}
-
-static inline void jpeg_subsampling_mode(void __iomem *regs, unsigned int mode)
-{
-	unsigned long reg, m;
-
-	if (mode == V4L2_JPEG_CHROMA_SUBSAMPLING_420)
-		m = S5P_SUBSAMPLING_MODE_420;
-	else
-		m = S5P_SUBSAMPLING_MODE_422;
-
-	reg = readl(regs + S5P_JPGMOD);
-	reg &= ~S5P_SUBSAMPLING_MODE_MASK;
-	reg |= m;
-	writel(reg, regs + S5P_JPGMOD);
-}
-
-static inline unsigned int jpeg_get_subsampling_mode(void __iomem *regs)
-{
-	return readl(regs + S5P_JPGMOD) & S5P_SUBSAMPLING_MODE_MASK;
-}
-
-static inline void jpeg_dri(void __iomem *regs, unsigned int dri)
-{
-	unsigned long reg;
-
-	reg = readl(regs + S5P_JPGDRI_U);
-	reg &= ~0xff;
-	reg |= (dri >> 8) & 0xff;
-	writel(reg, regs + S5P_JPGDRI_U);
-
-	reg = readl(regs + S5P_JPGDRI_L);
-	reg &= ~0xff;
-	reg |= dri & 0xff;
-	writel(reg, regs + S5P_JPGDRI_L);
-}
-
-static inline void jpeg_qtbl(void __iomem *regs, unsigned int t, unsigned int n)
-{
-	unsigned long reg;
-
-	reg = readl(regs + S5P_JPG_QTBL);
-	reg &= ~S5P_QT_NUMt_MASK(t);
-	reg |= (n << S5P_QT_NUMt_SHIFT(t)) & S5P_QT_NUMt_MASK(t);
-	writel(reg, regs + S5P_JPG_QTBL);
-}
-
-static inline void jpeg_htbl_ac(void __iomem *regs, unsigned int t)
-{
-	unsigned long reg;
-
-	reg = readl(regs + S5P_JPG_HTBL);
-	reg &= ~S5P_HT_NUMt_AC_MASK(t);
-	/* this driver uses table 0 for all color components */
-	reg |= (0 << S5P_HT_NUMt_AC_SHIFT(t)) & S5P_HT_NUMt_AC_MASK(t);
-	writel(reg, regs + S5P_JPG_HTBL);
-}
-
-static inline void jpeg_htbl_dc(void __iomem *regs, unsigned int t)
-{
-	unsigned long reg;
-
-	reg = readl(regs + S5P_JPG_HTBL);
-	reg &= ~S5P_HT_NUMt_DC_MASK(t);
-	/* this driver uses table 0 for all color components */
-	reg |= (0 << S5P_HT_NUMt_DC_SHIFT(t)) & S5P_HT_NUMt_DC_MASK(t);
-	writel(reg, regs + S5P_JPG_HTBL);
-}
-
-static inline void jpeg_y(void __iomem *regs, unsigned int y)
-{
-	unsigned long reg;
-
-	reg = readl(regs + S5P_JPGY_U);
-	reg &= ~0xff;
-	reg |= (y >> 8) & 0xff;
-	writel(reg, regs + S5P_JPGY_U);
-
-	reg = readl(regs + S5P_JPGY_L);
-	reg &= ~0xff;
-	reg |= y & 0xff;
-	writel(reg, regs + S5P_JPGY_L);
-}
-
-static inline void jpeg_x(void __iomem *regs, unsigned int x)
-{
-	unsigned long reg;
-
-	reg = readl(regs + S5P_JPGX_U);
-	reg &= ~0xff;
-	reg |= (x >> 8) & 0xff;
-	writel(reg, regs + S5P_JPGX_U);
-
-	reg = readl(regs + S5P_JPGX_L);
-	reg &= ~0xff;
-	reg |= x & 0xff;
-	writel(reg, regs + S5P_JPGX_L);
-}
-
-static inline void jpeg_rst_int_enable(void __iomem *regs, bool enable)
-{
-	unsigned long reg;
-
-	reg = readl(regs + S5P_JPGINTSE);
-	reg &= ~S5P_RSTm_INT_EN_MASK;
-	if (enable)
-		reg |= S5P_RSTm_INT_EN;
-	writel(reg, regs + S5P_JPGINTSE);
-}
-
-static inline void jpeg_data_num_int_enable(void __iomem *regs, bool enable)
-{
-	unsigned long reg;
-
-	reg = readl(regs + S5P_JPGINTSE);
-	reg &= ~S5P_DATA_NUM_INT_EN_MASK;
-	if (enable)
-		reg |= S5P_DATA_NUM_INT_EN;
-	writel(reg, regs + S5P_JPGINTSE);
-}
-
-static inline void jpeg_final_mcu_num_int_enable(void __iomem *regs, bool enbl)
-{
-	unsigned long reg;
-
-	reg = readl(regs + S5P_JPGINTSE);
-	reg &= ~S5P_FINAL_MCU_NUM_INT_EN_MASK;
-	if (enbl)
-		reg |= S5P_FINAL_MCU_NUM_INT_EN;
-	writel(reg, regs + S5P_JPGINTSE);
-}
-
-static inline void jpeg_timer_enable(void __iomem *regs, unsigned long val)
-{
-	unsigned long reg;
-
-	reg = readl(regs + S5P_JPG_TIMER_SE);
-	reg |= S5P_TIMER_INT_EN;
-	reg &= ~S5P_TIMER_INIT_MASK;
-	reg |= val & S5P_TIMER_INIT_MASK;
-	writel(reg, regs + S5P_JPG_TIMER_SE);
-}
-
-static inline void jpeg_timer_disable(void __iomem *regs)
-{
-	unsigned long reg;
-
-	reg = readl(regs + S5P_JPG_TIMER_SE);
-	reg &= ~S5P_TIMER_INT_EN_MASK;
-	writel(reg, regs + S5P_JPG_TIMER_SE);
-}
-
-static inline int jpeg_timer_stat(void __iomem *regs)
-{
-	return (int)((readl(regs + S5P_JPG_TIMER_ST) & S5P_TIMER_INT_STAT_MASK)
-		     >> S5P_TIMER_INT_STAT_SHIFT);
-}
-
-static inline void jpeg_clear_timer_stat(void __iomem *regs)
-{
-	unsigned long reg;
-
-	reg = readl(regs + S5P_JPG_TIMER_SE);
-	reg &= ~S5P_TIMER_INT_STAT_MASK;
-	writel(reg, regs + S5P_JPG_TIMER_SE);
-}
-
-static inline void jpeg_enc_stream_int(void __iomem *regs, unsigned long size)
-{
-	unsigned long reg;
-
-	reg = readl(regs + S5P_JPG_ENC_STREAM_INTSE);
-	reg &= ~S5P_ENC_STREAM_BOUND_MASK;
-	reg |= S5P_ENC_STREAM_INT_EN;
-	reg |= size & S5P_ENC_STREAM_BOUND_MASK;
-	writel(reg, regs + S5P_JPG_ENC_STREAM_INTSE);
-}
-
-static inline int jpeg_enc_stream_stat(void __iomem *regs)
-{
-	return (int)(readl(regs + S5P_JPG_ENC_STREAM_INTST) &
-		     S5P_ENC_STREAM_INT_STAT_MASK);
-}
-
-static inline void jpeg_clear_enc_stream_stat(void __iomem *regs)
-{
-	unsigned long reg;
-
-	reg = readl(regs + S5P_JPG_ENC_STREAM_INTSE);
-	reg &= ~S5P_ENC_STREAM_INT_MASK;
-	writel(reg, regs + S5P_JPG_ENC_STREAM_INTSE);
-}
-
-static inline void jpeg_outform_raw(void __iomem *regs, unsigned long format)
-{
-	unsigned long reg, f;
-
-	f = S5P_DEC_OUT_FORMAT_422;
-	if (format == S5P_JPEG_RAW_OUT_422)
-		f = S5P_DEC_OUT_FORMAT_422;
-	else if (format == S5P_JPEG_RAW_OUT_420)
-		f = S5P_DEC_OUT_FORMAT_420;
-	reg = readl(regs + S5P_JPG_OUTFORM);
-	reg &= ~S5P_DEC_OUT_FORMAT_MASK;
-	reg |= f;
-	writel(reg, regs + S5P_JPG_OUTFORM);
-}
-
-static inline void jpeg_jpgadr(void __iomem *regs, unsigned long addr)
-{
-	writel(addr, regs + S5P_JPG_JPGADR);
-}
-
-static inline void jpeg_imgadr(void __iomem *regs, unsigned long addr)
-{
-	writel(addr, regs + S5P_JPG_IMGADR);
-}
-
-static inline void jpeg_coef(void __iomem *regs, unsigned int i,
-			     unsigned int j, unsigned int coef)
-{
-	unsigned long reg;
-
-	reg = readl(regs + S5P_JPG_COEF(i));
-	reg &= ~S5P_COEFn_MASK(j);
-	reg |= (coef << S5P_COEFn_SHIFT(j)) & S5P_COEFn_MASK(j);
-	writel(reg, regs + S5P_JPG_COEF(i));
-}
-
-static inline void jpeg_start(void __iomem *regs)
-{
-	writel(1, regs + S5P_JSTART);
-}
-
-static inline int jpeg_result_stat_ok(void __iomem *regs)
-{
-	return (int)((readl(regs + S5P_JPGINTST) & S5P_RESULT_STAT_MASK)
-		     >> S5P_RESULT_STAT_SHIFT);
-}
-
-static inline int jpeg_stream_stat_ok(void __iomem *regs)
-{
-	return !(int)((readl(regs + S5P_JPGINTST) & S5P_STREAM_STAT_MASK)
-		      >> S5P_STREAM_STAT_SHIFT);
-}
-
-static inline void jpeg_clear_int(void __iomem *regs)
-{
-	unsigned long reg;
-
-	reg = readl(regs + S5P_JPGINTST);
-	writel(S5P_INT_RELEASE, regs + S5P_JPGCOM);
-	reg = readl(regs + S5P_JPGOPR);
-}
-
-static inline unsigned int jpeg_compressed_size(void __iomem *regs)
-{
-	unsigned long jpeg_size = 0;
-
-	jpeg_size |= (readl(regs + S5P_JPGCNT_U) & 0xff) << 16;
-	jpeg_size |= (readl(regs + S5P_JPGCNT_M) & 0xff) << 8;
-	jpeg_size |= (readl(regs + S5P_JPGCNT_L) & 0xff);
-
-	return (unsigned int)jpeg_size;
-}
-
-#endif /* JPEG_HW_H_ */
diff --git a/drivers/media/platform/s5p-jpeg/jpeg-regs-v1.h b/drivers/media/platform/s5p-jpeg/jpeg-regs-v1.h
new file mode 100644
index 0000000..54a0925
--- /dev/null
+++ b/drivers/media/platform/s5p-jpeg/jpeg-regs-v1.h
@@ -0,0 +1,169 @@
+/* linux/drivers/media/platform/s5p-jpeg/jpeg-regs-v1.h
+ *
+ * Register definition file for Samsung JPEG codec driver on Exynos4210.
+ *
+ * Copyright (c) 2011 Samsung Electronics Co., Ltd.
+ *              http://www.samsung.com
+ *
+ * Author: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef JPEG_REGS_H_
+#define JPEG_REGS_H_
+
+/* JPEG mode register */
+#define S5P_JPGMOD			0x00
+#define S5P_PROC_MODE_MASK		(0x1 << 3)
+#define S5P_PROC_MODE_DECOMPR		(0x1 << 3)
+#define S5P_PROC_MODE_COMPR		(0x0 << 3)
+#define S5P_SUBSAMPLING_MODE_MASK	0x7
+#define S5P_SUBSAMPLING_MODE_444	(0x0 << 0)
+#define S5P_SUBSAMPLING_MODE_422	(0x1 << 0)
+#define S5P_SUBSAMPLING_MODE_420	(0x2 << 0)
+#define S5P_SUBSAMPLING_MODE_GRAY	(0x3 << 0)
+
+/* JPEG operation status register */
+#define S5P_JPGOPR			0x04
+
+/* Quantization tables*/
+#define S5P_JPG_QTBL			0x08
+#define S5P_QT_NUMt_SHIFT(t)		(((t) - 1) << 1)
+#define S5P_QT_NUMt_MASK(t)		(0x3 << S5P_QT_NUMt_SHIFT(t))
+
+/* Huffman tables */
+#define S5P_JPG_HTBL			0x0c
+#define S5P_HT_NUMt_AC_SHIFT(t)		(((t) << 1) - 1)
+#define S5P_HT_NUMt_AC_MASK(t)		(0x1 << S5P_HT_NUMt_AC_SHIFT(t))
+
+#define S5P_HT_NUMt_DC_SHIFT(t)		(((t) - 1) << 1)
+#define S5P_HT_NUMt_DC_MASK(t)		(0x1 << S5P_HT_NUMt_DC_SHIFT(t))
+
+/* JPEG restart interval register upper byte */
+#define S5P_JPGDRI_U			0x10
+
+/* JPEG restart interval register lower byte */
+#define S5P_JPGDRI_L			0x14
+
+/* JPEG vertical resolution register upper byte */
+#define S5P_JPGY_U			0x18
+
+/* JPEG vertical resolution register lower byte */
+#define S5P_JPGY_L			0x1c
+
+/* JPEG horizontal resolution register upper byte */
+#define S5P_JPGX_U			0x20
+
+/* JPEG horizontal resolution register lower byte */
+#define S5P_JPGX_L			0x24
+
+/* JPEG byte count register upper byte */
+#define S5P_JPGCNT_U			0x28
+
+/* JPEG byte count register middle byte */
+#define S5P_JPGCNT_M			0x2c
+
+/* JPEG byte count register lower byte */
+#define S5P_JPGCNT_L			0x30
+
+/* JPEG interrupt setting register */
+#define S5P_JPGINTSE			0x34
+#define S5P_RSTm_INT_EN_MASK		(0x1 << 7)
+#define S5P_RSTm_INT_EN			(0x1 << 7)
+#define S5P_DATA_NUM_INT_EN_MASK	(0x1 << 6)
+#define S5P_DATA_NUM_INT_EN		(0x1 << 6)
+#define S5P_FINAL_MCU_NUM_INT_EN_MASK	(0x1 << 5)
+#define S5P_FINAL_MCU_NUM_INT_EN	(0x1 << 5)
+
+/* JPEG interrupt status register */
+#define S5P_JPGINTST			0x38
+#define S5P_RESULT_STAT_SHIFT		6
+#define S5P_RESULT_STAT_MASK		(0x1 << S5P_RESULT_STAT_SHIFT)
+#define S5P_STREAM_STAT_SHIFT		5
+#define S5P_STREAM_STAT_MASK		(0x1 << S5P_STREAM_STAT_SHIFT)
+
+/* JPEG command register */
+#define S5P_JPGCOM			0x4c
+#define S5P_INT_RELEASE			(0x1 << 2)
+
+/* Raw image data r/w address register */
+#define S5P_JPG_IMGADR			0x50
+
+/* JPEG file r/w address register */
+#define S5P_JPG_JPGADR			0x58
+
+/* Coefficient for RGB-to-YCbCr converter register */
+#define S5P_JPG_COEF(n)			(0x5c + (((n) - 1) << 2))
+#define S5P_COEFn_SHIFT(j)		((3 - (j)) << 3)
+#define S5P_COEFn_MASK(j)		(0xff << S5P_COEFn_SHIFT(j))
+
+/* JPEG color mode register */
+#define S5P_JPGCMOD			0x68
+#define S5P_MOD_SEL_MASK		(0x7 << 5)
+#define S5P_MOD_SEL_422			(0x1 << 5)
+#define S5P_MOD_SEL_565			(0x2 << 5)
+#define S5P_MODE_Y16_MASK		(0x1 << 1)
+#define S5P_MODE_Y16			(0x1 << 1)
+
+/* JPEG clock control register */
+#define S5P_JPGCLKCON			0x6c
+#define S5P_CLK_DOWN_READY		(0x1 << 1)
+#define S5P_POWER_ON			(0x1 << 0)
+
+/* JPEG start register */
+#define S5P_JSTART			0x70
+
+/* JPEG SW reset register */
+#define S5P_JPG_SW_RESET		0x78
+
+/* JPEG timer setting register */
+#define S5P_JPG_TIMER_SE		0x7c
+#define S5P_TIMER_INT_EN_MASK		(0x1 << 31)
+#define S5P_TIMER_INT_EN		(0x1 << 31)
+#define S5P_TIMER_INIT_MASK		0x7fffffff
+
+/* JPEG timer status register */
+#define S5P_JPG_TIMER_ST		0x80
+#define S5P_TIMER_INT_STAT_SHIFT	31
+#define S5P_TIMER_INT_STAT_MASK		(0x1 << S5P_TIMER_INT_STAT_SHIFT)
+#define S5P_TIMER_CNT_SHIFT		0
+#define S5P_TIMER_CNT_MASK		0x7fffffff
+
+/* JPEG decompression output format register */
+#define S5P_JPG_OUTFORM			0x88
+#define S5P_DEC_OUT_FORMAT_MASK		(0x1 << 0)
+#define S5P_DEC_OUT_FORMAT_422		(0x0 << 0)
+#define S5P_DEC_OUT_FORMAT_420		(0x1 << 0)
+
+/* JPEG version register */
+#define S5P_JPG_VERSION			0x8c
+
+/* JPEG compressed stream size interrupt setting register */
+#define S5P_JPG_ENC_STREAM_INTSE	0x98
+#define S5P_ENC_STREAM_INT_MASK		(0x1 << 24)
+#define S5P_ENC_STREAM_INT_EN		(0x1 << 24)
+#define S5P_ENC_STREAM_BOUND_MASK	0xffffff
+
+/* JPEG compressed stream size interrupt status register */
+#define S5P_JPG_ENC_STREAM_INTST	0x9c
+#define S5P_ENC_STREAM_INT_STAT_MASK	0x1
+
+/* JPEG quantizer table register */
+#define S5P_JPG_QTBL_CONTENT(n)		(0x400 + (n) * 0x100)
+
+/* JPEG DC Huffman table register */
+#define S5P_JPG_HDCTBL(n)		(0x800 + (n) * 0x400)
+
+/* JPEG DC Huffman table register */
+#define S5P_JPG_HDCTBLG(n)		(0x840 + (n) * 0x400)
+
+/* JPEG AC Huffman table register */
+#define S5P_JPG_HACTBL(n)		(0x880 + (n) * 0x400)
+
+/* JPEG AC Huffman table register */
+#define S5P_JPG_HACTBLG(n)		(0x8c0 + (n) * 0x400)
+
+#endif /* JPEG_REGS_H_ */
diff --git a/drivers/media/platform/s5p-jpeg/jpeg-regs-v2.h b/drivers/media/platform/s5p-jpeg/jpeg-regs-v2.h
new file mode 100644
index 0000000..00ff2f7
--- /dev/null
+++ b/drivers/media/platform/s5p-jpeg/jpeg-regs-v2.h
@@ -0,0 +1,191 @@
+/* Copyright (c) 2013 Samsung Electronics Co., Ltd.
+ * http://www.samsung.com/
+ *
+ * Register definition file for Samsung JPEG driver on Exynos4x12 and 5250.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+#ifndef __ASM_ARM_REGS_S5P_JPEG_H
+#define __ASM_ARM_REGS_S5P_JPEG_H
+
+/* JPEG Registers part */
+
+/* JPEG Codec Control Registers */
+#define S5P_JPEG_CNTL_REG		0x00
+#define S5P_JPEG_INT_EN_REG		0x04
+/*#define S5P_JPEG_QTBL_REG		0x08*Reserved*/
+#define S5P_JPEG_INT_STATUS_REG		0x0c
+#define S5P_JPEG_OUT_MEM_BASE_REG	0x10
+#define S5P_JPEG_IMG_SIZE_REG		0x14
+#define S5P_JPEG_IMG_BA_PLANE_1_REG	0x18
+#define S5P_JPEG_IMG_SO_PLANE_1_REG	0x1c
+#define S5P_JPEG_IMG_PO_PLANE_1_REG	0x20
+#define S5P_JPEG_IMG_BA_PLANE_2_REG	0x24
+#define S5P_JPEG_IMG_SO_PLANE_2_REG	0x28
+#define S5P_JPEG_IMG_PO_PLANE_2_REG	0x2c
+#define S5P_JPEG_IMG_BA_PLANE_3_REG	0x30
+#define S5P_JPEG_IMG_SO_PLANE_3_REG	0x34
+#define S5P_JPEG_IMG_PO_PLANE_3_REG	0x38
+
+#define S5P_JPEG_TBL_SEL_REG		0x3c
+
+#define S5P_JPEG_IMG_FMT_REG		0x40
+
+#define S5P_JPEG_BITSTREAM_SIZE_REG	0x44
+#define S5P_JPEG_PADDING_REG		0x48
+#define S5P_JPEG_HUFF_CNT_REG		0x4c
+#define S5P_JPEG_FIFO_STATUS_REG	0x50
+#define S5P_JPEG_DECODE_XY_SIZE_REG	0x54
+#define S5P_JPEG_DECODE_IMG_FMT_REG	0x58
+
+#define S5P_JPEG_QUAN_TBL_ENTRY_REG	0x100
+#define S5P_JPEG_HUFF_TBL_ENTRY_REG	0x200
+
+
+/****************************************************************/
+/* Bit definition part						*/
+/****************************************************************/
+
+/* JPEG CNTL Register bit */
+#define S5P_JPEG_ENC_DEC_MODE_MASK	(0xfffffffc << 0)
+#define S5P_JPEG_DEC_MODE		(1 << 0)
+#define S5P_JPEG_ENC_MODE		(1 << 1)
+#define S5P_JPEG_AUTO_RST_MARKER	(1 << 2)
+#define S5P_JPEG_RST_INTERVAL_SHIFT	3
+#define S5P_JPEG_RST_INTERVAL(x) (((x) & 0xffff) << S5P_JPEG_RST_INTERVAL_SHIFT)
+#define S5P_JPEG_HUF_TBL_EN		(1 << 19)
+#define S5P_JPEG_HOR_SCALING_SHIFT	20
+#define S5P_JPEG_HOR_SCALING_MASK	(3 << S5P_JPEG_HOR_SCALING_SHIFT)
+#define S5P_JPEG_HOR_SCALING(x)	(((x) & 0x3) << S5P_JPEG_HOR_SCALING_SHIFT)
+#define S5P_JPEG_VER_SCALING_SHIFT	22
+#define S5P_JPEG_VER_SCALING_MASK	(3 << S5P_JPEG_VER_SCALING_SHIFT)
+#define S5P_JPEG_VER_SCALING(x)	(((x) & 0x3) << S5P_JPEG_VER_SCALING_SHIFT)
+#define S5P_JPEG_PADDING		(1 << 27)
+#define S5P_JPEG_SYS_INT_EN		(1 << 28)
+#define S5P_JPEG_SOFT_RESET_HI		(1 << 29)
+
+/* JPEG INT Register bit */
+#define S5P_JPEG_INT_EN_MASK			(0x1f << 0)
+#define S5P_JPEG_PROT_ERR_INT_EN		(1 << 0)
+#define S5P_JPEG_IMG_COMPLETION_INT_EN		(1 << 1)
+#define S5P_JPEG_DEC_INVALID_FORMAT_EN		(1 << 2)
+#define S5P_JPEG_MULTI_SCAN_ERROR_EN		(1 << 3)
+#define S5P_JPEG_FRAME_ERR_EN			(1 << 4)
+#define S5P_JPEG_INT_EN_ALL			(0x1f << 0)
+
+#define S5P_JPEG_MOD_REG_PROC_ENC		(0 << 3)
+#define S5P_JPEG_MOD_REG_PROC_DEC		(1 << 3)
+
+#define S5P_JPEG_MOD_REG_SUBSAMPLE_444		(0 << 0)
+#define S5P_JPEG_MOD_REG_SUBSAMPLE_422		(1 << 0)
+#define S5P_JPEG_MOD_REG_SUBSAMPLE_420		(2 << 0)
+#define S5P_JPEG_MOD_REG_SUBSAMPLE_GRAY		(3 << 0)
+
+
+/* JPEG IMAGE SIZE Register bit */
+#define S5P_JPEG_X_SIZE_SHIFT	0
+#define S5P_JPEG_X_SIZE_MASK	(0xffff << S5P_JPEG_X_SIZE_SHIFT)
+#define S5P_JPEG_X_SIZE(x)	(((x) & 0xffff) << S5P_JPEG_X_SIZE_SHIFT)
+#define S5P_JPEG_Y_SIZE_SHIFT	16
+#define S5P_JPEG_Y_SIZE_MASK	(0xffff << S5P_JPEG_Y_SIZE_SHIFT)
+#define S5P_JPEG_Y_SIZE(x)	(((x) & 0xffff) << S5P_JPEG_Y_SIZE_SHIFT)
+
+/* JPEG IMAGE FORMAT Register bit */
+#define S5P_JPEG_ENC_IN_FMT_MASK	0xffff0000
+#define S5P_JPEG_ENC_GRAY_IMG		(0 << 0)
+#define S5P_JPEG_ENC_RGB_IMG		(1 << 0)
+#define S5P_JPEG_ENC_YUV_444_IMG	(2 << 0)
+#define S5P_JPEG_ENC_YUV_422_IMG	(3 << 0)
+#define S5P_JPEG_ENC_YUV_440_IMG	(4 << 0)
+
+#define S5P_JPEG_DEC_GRAY_IMG		(0 << 0)
+#define S5P_JPEG_DEC_RGB_IMG		(1 << 0)
+#define S5P_JPEG_DEC_YUV_444_IMG	(2 << 0)
+#define S5P_JPEG_DEC_YUV_422_IMG	(3 << 0)
+#define S5P_JPEG_DEC_YUV_420_IMG	(4 << 0)
+
+#define S5P_JPEG_GRAY_IMG_IP_SHIFT	3
+#define S5P_JPEG_GRAY_IMG_IP_MASK	(7 << S5P_JPEG_GRAY_IMG_IP_SHIFT)
+#define S5P_JPEG_GRAY_IMG_IP		(4 << S5P_JPEG_GRAY_IMG_IP_SHIFT)
+
+#define S5P_JPEG_RGB_IP_SHIFT			6
+#define S5P_JPEG_RGB_IP_MASK			(7 << S5P_JPEG_RGB_IP_SHIFT)
+#define S5P_JPEG_RGB_IP_RGB_16BIT_IMG		(4 << S5P_JPEG_RGB_IP_SHIFT)
+#define S5P_JPEG_RGB_IP_RGB_32BIT_IMG		(5 << S5P_JPEG_RGB_IP_SHIFT)
+
+#define S5P_JPEG_YUV_444_IP_SHIFT		9
+#define S5P_JPEG_YUV_444_IP_MASK		(7 << S5P_JPEG_YUV_444_IP_SHIFT)
+#define S5P_JPEG_YUV_444_IP_YUV_444_2P_IMG	(4 << S5P_JPEG_YUV_444_IP_SHIFT)
+#define S5P_JPEG_YUV_444_IP_YUV_444_3P_IMG	(5 << S5P_JPEG_YUV_444_IP_SHIFT)
+
+#define S5P_JPEG_YUV_422_IP_SHIFT		12
+#define S5P_JPEG_YUV_422_IP_MASK		(7 << S5P_JPEG_YUV_422_IP_SHIFT)
+#define S5P_JPEG_YUV_422_IP_YUV_422_1P_IMG	(4 << S5P_JPEG_YUV_422_IP_SHIFT)
+#define S5P_JPEG_YUV_422_IP_YUV_422_2P_IMG	(5 << S5P_JPEG_YUV_422_IP_SHIFT)
+#define S5P_JPEG_YUV_422_IP_YUV_422_3P_IMG	(6 << S5P_JPEG_YUV_422_IP_SHIFT)
+
+#define S5P_JPEG_YUV_420_IP_SHIFT		15
+#define S5P_JPEG_YUV_420_IP_MASK		(7 << S5P_JPEG_YUV_420_IP_SHIFT)
+#define S5P_JPEG_YUV_420_IP_YUV_420_2P_IMG	(4 << S5P_JPEG_YUV_420_IP_SHIFT)
+#define S5P_JPEG_YUV_420_IP_YUV_420_3P_IMG	(5 << S5P_JPEG_YUV_420_IP_SHIFT)
+
+#define S5P_JPEG_ENC_FMT_SHIFT			24
+#define S5P_JPEG_ENC_FMT_MASK			(3 << S5P_JPEG_ENC_FMT_SHIFT)
+#define S5P_JPEG_ENC_FMT_GRAY			(0 << S5P_JPEG_ENC_FMT_SHIFT)
+#define S5P_JPEG_ENC_FMT_YUV_444		(1 << S5P_JPEG_ENC_FMT_SHIFT)
+#define S5P_JPEG_ENC_FMT_YUV_422		(2 << S5P_JPEG_ENC_FMT_SHIFT)
+#define S5P_JPEG_ENC_FMT_YUV_420		(3 << S5P_JPEG_ENC_FMT_SHIFT)
+
+#define S5P_JPEG_SWAP_CHROMA_CrCb		(1 << 26)
+#define S5P_JPEG_SWAP_CHROMA_CbCr		(0 << 26)
+
+/* JPEG HUFF count Register bit */
+#define S5P_JPEG_HUFF_COUNT_MASK		0xffff
+
+/* JPEG Decoded_img_x_y_size Register bit */
+#define S5P_JPEG_DECODED_SIZE_MASK		0x0000ffff
+
+/* JPEG Decoded image format Register bit */
+#define S5P_JPEG_DECODED_IMG_FMT_MASK		0x3
+
+/* JPEG TBL SEL Register bit */
+#define S5P_JPEG_Q_TBL_COMP1_SHIFT	    0
+#define S5P_JPEG_Q_TBL_COMP1_0		    (0 << S5P_JPEG_Q_TBL_COMP1_SHIFT)
+#define S5P_JPEG_Q_TBL_COMP1_1		    (1 << S5P_JPEG_Q_TBL_COMP1_SHIFT)
+#define S5P_JPEG_Q_TBL_COMP1_2		    (2 << S5P_JPEG_Q_TBL_COMP1_SHIFT)
+#define S5P_JPEG_Q_TBL_COMP1_3		    (3 << S5P_JPEG_Q_TBL_COMP1_SHIFT)
+
+#define S5P_JPEG_Q_TBL_COMP2_SHIFT	    2
+#define S5P_JPEG_Q_TBL_COMP2_0		    (0 << S5P_JPEG_Q_TBL_COMP2_SHIFT)
+#define S5P_JPEG_Q_TBL_COMP2_1		    (1 << S5P_JPEG_Q_TBL_COMP2_SHIFT)
+#define S5P_JPEG_Q_TBL_COMP2_2		    (2 << S5P_JPEG_Q_TBL_COMP2_SHIFT)
+#define S5P_JPEG_Q_TBL_COMP2_3		    (3 << S5P_JPEG_Q_TBL_COMP2_SHIFT)
+
+#define S5P_JPEG_Q_TBL_COMP3_SHIFT          4
+#define S5P_JPEG_Q_TBL_COMP3_0		    (0 << S5P_JPEG_Q_TBL_COMP3_SHIFT)
+#define S5P_JPEG_Q_TBL_COMP3_1		    (1 << S5P_JPEG_Q_TBL_COMP2_SHIFT)
+#define S5P_JPEG_Q_TBL_COMP3_2		    (2 << S5P_JPEG_Q_TBL_COMP2_SHIFT)
+#define S5P_JPEG_Q_TBL_COMP3_3		    (3 << S5P_JPEG_Q_TBL_COMP2_SHIFT)
+
+#define S5P_JPEG_HUFF_TBL_COMP1_SHIFT	    6
+#define S5P_JPEG_HUFF_TBL_COMP1_AC_0_DC_0   (0 << S5P_JPEG_HUFF_TBL_COMP1_SHIFT)
+#define S5P_JPEG_HUFF_TBL_COMP1_AC_0_DC_1   (1 << S5P_JPEG_HUFF_TBL_COMP1_SHIFT)
+#define S5P_JPEG_HUFF_TBL_COMP1_AC_1_DC_0   (2 << S5P_JPEG_HUFF_TBL_COMP1_SHIFT)
+#define S5P_JPEG_HUFF_TBL_COMP1_AC_1_DC_1   (3 << S5P_JPEG_HUFF_TBL_COMP1_SHIFT)
+
+#define S5P_JPEG_HUFF_TBL_COMP2_SHIFT	    8
+#define S5P_JPEG_HUFF_TBL_COMP2_AC_0_DC_0   (0 << S5P_JPEG_HUFF_TBL_COMP2_SHIFT)
+#define S5P_JPEG_HUFF_TBL_COMP2_AC_0_DC_1   (1 << S5P_JPEG_HUFF_TBL_COMP2_SHIFT)
+#define S5P_JPEG_HUFF_TBL_COMP2_AC_1_DC_0   (2 << S5P_JPEG_HUFF_TBL_COMP2_SHIFT)
+#define S5P_JPEG_HUFF_TBL_COMP2_AC_1_DC_1   (3 << S5P_JPEG_HUFF_TBL_COMP2_SHIFT)
+
+#define S5P_JPEG_HUFF_TBL_COMP3_SHIFT	    10
+#define S5P_JPEG_HUFF_TBL_COMP3_AC_0_DC_0   (0 << S5P_JPEG_HUFF_TBL_COMP3_SHIFT)
+#define S5P_JPEG_HUFF_TBL_COMP3_AC_0_DC_1   (1 << S5P_JPEG_HUFF_TBL_COMP3_SHIFT)
+#define S5P_JPEG_HUFF_TBL_COMP3_AC_1_DC_0   (2 << S5P_JPEG_HUFF_TBL_COMP3_SHIFT)
+#define S5P_JPEG_HUFF_TBL_COMP3_AC_1_DC_1   (3 << S5P_JPEG_HUFF_TBL_COMP3_SHIFT)
+
+#endif /* __ASM_ARM_REGS_S5P_JPEG_H */
diff --git a/drivers/media/platform/s5p-jpeg/jpeg-regs.h b/drivers/media/platform/s5p-jpeg/jpeg-regs.h
deleted file mode 100644
index 38e5081..0000000
--- a/drivers/media/platform/s5p-jpeg/jpeg-regs.h
+++ /dev/null
@@ -1,170 +0,0 @@
-/* linux/drivers/media/platform/s5p-jpeg/jpeg-regs.h
- *
- * Register definition file for Samsung JPEG codec driver
- *
- * Copyright (c) 2011 Samsung Electronics Co., Ltd.
- *		http://www.samsung.com
- *
- * Author: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#ifndef JPEG_REGS_H_
-#define JPEG_REGS_H_
-
-/* JPEG mode register */
-#define S5P_JPGMOD			0x00
-#define S5P_PROC_MODE_MASK		(0x1 << 3)
-#define S5P_PROC_MODE_DECOMPR		(0x1 << 3)
-#define S5P_PROC_MODE_COMPR		(0x0 << 3)
-#define S5P_SUBSAMPLING_MODE_MASK	0x7
-#define S5P_SUBSAMPLING_MODE_444	(0x0 << 0)
-#define S5P_SUBSAMPLING_MODE_422	(0x1 << 0)
-#define S5P_SUBSAMPLING_MODE_420	(0x2 << 0)
-#define S5P_SUBSAMPLING_MODE_GRAY	(0x3 << 0)
-
-/* JPEG operation status register */
-#define S5P_JPGOPR			0x04
-
-/* Quantization tables*/
-#define S5P_JPG_QTBL			0x08
-#define S5P_QT_NUMt_SHIFT(t)		(((t) - 1) << 1)
-#define S5P_QT_NUMt_MASK(t)		(0x3 << S5P_QT_NUMt_SHIFT(t))
-
-/* Huffman tables */
-#define S5P_JPG_HTBL			0x0c
-#define S5P_HT_NUMt_AC_SHIFT(t)		(((t) << 1) - 1)
-#define S5P_HT_NUMt_AC_MASK(t)		(0x1 << S5P_HT_NUMt_AC_SHIFT(t))
-
-#define S5P_HT_NUMt_DC_SHIFT(t)		(((t) - 1) << 1)
-#define S5P_HT_NUMt_DC_MASK(t)		(0x1 << S5P_HT_NUMt_DC_SHIFT(t))
-
-/* JPEG restart interval register upper byte */
-#define S5P_JPGDRI_U			0x10
-
-/* JPEG restart interval register lower byte */
-#define S5P_JPGDRI_L			0x14
-
-/* JPEG vertical resolution register upper byte */
-#define S5P_JPGY_U			0x18
-
-/* JPEG vertical resolution register lower byte */
-#define S5P_JPGY_L			0x1c
-
-/* JPEG horizontal resolution register upper byte */
-#define S5P_JPGX_U			0x20
-
-/* JPEG horizontal resolution register lower byte */
-#define S5P_JPGX_L			0x24
-
-/* JPEG byte count register upper byte */
-#define S5P_JPGCNT_U			0x28
-
-/* JPEG byte count register middle byte */
-#define S5P_JPGCNT_M			0x2c
-
-/* JPEG byte count register lower byte */
-#define S5P_JPGCNT_L			0x30
-
-/* JPEG interrupt setting register */
-#define S5P_JPGINTSE			0x34
-#define S5P_RSTm_INT_EN_MASK		(0x1 << 7)
-#define S5P_RSTm_INT_EN			(0x1 << 7)
-#define S5P_DATA_NUM_INT_EN_MASK	(0x1 << 6)
-#define S5P_DATA_NUM_INT_EN		(0x1 << 6)
-#define S5P_FINAL_MCU_NUM_INT_EN_MASK	(0x1 << 5)
-#define S5P_FINAL_MCU_NUM_INT_EN	(0x1 << 5)
-
-/* JPEG interrupt status register */
-#define S5P_JPGINTST			0x38
-#define S5P_RESULT_STAT_SHIFT		6
-#define S5P_RESULT_STAT_MASK		(0x1 << S5P_RESULT_STAT_SHIFT)
-#define S5P_STREAM_STAT_SHIFT		5
-#define S5P_STREAM_STAT_MASK		(0x1 << S5P_STREAM_STAT_SHIFT)
-
-/* JPEG command register */
-#define S5P_JPGCOM			0x4c
-#define S5P_INT_RELEASE			(0x1 << 2)
-
-/* Raw image data r/w address register */
-#define S5P_JPG_IMGADR			0x50
-
-/* JPEG file r/w address register */
-#define S5P_JPG_JPGADR			0x58
-
-/* Coefficient for RGB-to-YCbCr converter register */
-#define S5P_JPG_COEF(n)			(0x5c + (((n) - 1) << 2))
-#define S5P_COEFn_SHIFT(j)		((3 - (j)) << 3)
-#define S5P_COEFn_MASK(j)		(0xff << S5P_COEFn_SHIFT(j))
-
-/* JPEG color mode register */
-#define S5P_JPGCMOD			0x68
-#define S5P_MOD_SEL_MASK		(0x7 << 5)
-#define S5P_MOD_SEL_422			(0x1 << 5)
-#define S5P_MOD_SEL_565			(0x2 << 5)
-#define S5P_MODE_Y16_MASK		(0x1 << 1)
-#define S5P_MODE_Y16			(0x1 << 1)
-
-/* JPEG clock control register */
-#define S5P_JPGCLKCON			0x6c
-#define S5P_CLK_DOWN_READY		(0x1 << 1)
-#define S5P_POWER_ON			(0x1 << 0)
-
-/* JPEG start register */
-#define S5P_JSTART			0x70
-
-/* JPEG SW reset register */
-#define S5P_JPG_SW_RESET		0x78
-
-/* JPEG timer setting register */
-#define S5P_JPG_TIMER_SE		0x7c
-#define S5P_TIMER_INT_EN_MASK		(0x1 << 31)
-#define S5P_TIMER_INT_EN		(0x1 << 31)
-#define S5P_TIMER_INIT_MASK		0x7fffffff
-
-/* JPEG timer status register */
-#define S5P_JPG_TIMER_ST		0x80
-#define S5P_TIMER_INT_STAT_SHIFT	31
-#define S5P_TIMER_INT_STAT_MASK		(0x1 << S5P_TIMER_INT_STAT_SHIFT)
-#define S5P_TIMER_CNT_SHIFT		0
-#define S5P_TIMER_CNT_MASK		0x7fffffff
-
-/* JPEG decompression output format register */
-#define S5P_JPG_OUTFORM			0x88
-#define S5P_DEC_OUT_FORMAT_MASK		(0x1 << 0)
-#define S5P_DEC_OUT_FORMAT_422		(0x0 << 0)
-#define S5P_DEC_OUT_FORMAT_420		(0x1 << 0)
-
-/* JPEG version register */
-#define S5P_JPG_VERSION			0x8c
-
-/* JPEG compressed stream size interrupt setting register */
-#define S5P_JPG_ENC_STREAM_INTSE	0x98
-#define S5P_ENC_STREAM_INT_MASK		(0x1 << 24)
-#define S5P_ENC_STREAM_INT_EN		(0x1 << 24)
-#define S5P_ENC_STREAM_BOUND_MASK	0xffffff
-
-/* JPEG compressed stream size interrupt status register */
-#define S5P_JPG_ENC_STREAM_INTST	0x9c
-#define S5P_ENC_STREAM_INT_STAT_MASK	0x1
-
-/* JPEG quantizer table register */
-#define S5P_JPG_QTBL_CONTENT(n)		(0x400 + (n) * 0x100)
-
-/* JPEG DC Huffman table register */
-#define S5P_JPG_HDCTBL(n)		(0x800 + (n) * 0x400)
-
-/* JPEG DC Huffman table register */
-#define S5P_JPG_HDCTBLG(n)		(0x840 + (n) * 0x400)
-
-/* JPEG AC Huffman table register */
-#define S5P_JPG_HACTBL(n)		(0x880 + (n) * 0x400)
-
-/* JPEG AC Huffman table register */
-#define S5P_JPG_HACTBLG(n)		(0x8c0 + (n) * 0x400)
-
-#endif /* JPEG_REGS_H_ */
-
-- 
1.7.9.5

