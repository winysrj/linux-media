Return-path: <mchehab@pedra>
Received: from mail-out.m-online.net ([212.18.0.9]:40719 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754411Ab1EDUTY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 May 2011 16:19:24 -0400
From: Anatolij Gustschin <agust@denx.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] fsl_viu: add VIDIOC_OVERLAY ioctl
Date: Wed,  4 May 2011 22:19:28 +0200
Message-Id: <1304540368-6818-1-git-send-email-agust@denx.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Currently the driver enables overlay when running
VIDIOC_S_FMT ioctl with fmt type V4L2_BUF_TYPE_VIDEO_OVERLAY.
Actually, this is wrong. Add proper VIDIOC_OVERLAY support
instead of using VIDIOC_S_FMT for overlay enable.

Signed-off-by: Anatolij Gustschin <agust@denx.de>
---
 drivers/media/video/fsl-viu.c |   32 +++++++++++++++++++++++++-------
 1 files changed, 25 insertions(+), 7 deletions(-)

diff --git a/drivers/media/video/fsl-viu.c b/drivers/media/video/fsl-viu.c
index ab05a09..908d701 100644
--- a/drivers/media/video/fsl-viu.c
+++ b/drivers/media/video/fsl-viu.c
@@ -766,7 +766,7 @@ inline void viu_activate_overlay(struct viu_reg *viu_reg)
 	out_be32(&vr->picture_count, reg_val.picture_count);
 }
 
-static int viu_start_preview(struct viu_dev *dev, struct viu_fh *fh)
+static int viu_setup_preview(struct viu_dev *dev, struct viu_fh *fh)
 {
 	int bpp;
 
@@ -805,11 +805,6 @@ static int viu_start_preview(struct viu_dev *dev, struct viu_fh *fh)
 	/* setup the base address of the overlay buffer */
 	reg_val.field_base_addr = (u32)dev->ovbuf.base;
 
-	dev->ovenable = 1;
-	viu_activate_overlay(dev->vr);
-
-	/* start dma */
-	viu_start_dma(dev);
 	return 0;
 }
 
@@ -828,7 +823,7 @@ static int vidioc_s_fmt_overlay(struct file *file, void *priv,
 	fh->win = f->fmt.win;
 
 	spin_lock_irqsave(&dev->slock, flags);
-	viu_start_preview(dev, fh);
+	viu_setup_preview(dev, fh);
 	spin_unlock_irqrestore(&dev->slock, flags);
 	return 0;
 }
@@ -839,6 +834,28 @@ static int vidioc_try_fmt_overlay(struct file *file, void *priv,
 	return 0;
 }
 
+static int vidioc_overlay(struct file *file, void *priv, unsigned int on)
+{
+	struct viu_fh  *fh  = priv;
+	struct viu_dev *dev = (struct viu_dev *)fh->dev;
+	unsigned long  flags;
+
+	if (on) {
+		spin_lock_irqsave(&dev->slock, flags);
+		viu_activate_overlay(dev->vr);
+		dev->ovenable = 1;
+
+		/* start dma */
+		viu_start_dma(dev);
+		spin_unlock_irqrestore(&dev->slock, flags);
+	} else {
+		viu_stop_dma(dev);
+		dev->ovenable = 0;
+	}
+
+	return 0;
+}
+
 int vidioc_g_fbuf(struct file *file, void *priv, struct v4l2_framebuffer *arg)
 {
 	struct viu_fh  *fh = priv;
@@ -1418,6 +1435,7 @@ static const struct v4l2_ioctl_ops viu_ioctl_ops = {
 	.vidioc_g_fmt_vid_overlay = vidioc_g_fmt_overlay,
 	.vidioc_try_fmt_vid_overlay = vidioc_try_fmt_overlay,
 	.vidioc_s_fmt_vid_overlay = vidioc_s_fmt_overlay,
+	.vidioc_overlay	      = vidioc_overlay,
 	.vidioc_g_fbuf	      = vidioc_g_fbuf,
 	.vidioc_s_fbuf	      = vidioc_s_fbuf,
 	.vidioc_reqbufs       = vidioc_reqbufs,
-- 
1.7.1

