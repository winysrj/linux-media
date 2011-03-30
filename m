Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.8]:53998 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754152Ab1C3Hk6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Mar 2011 03:40:58 -0400
Date: Wed, 30 Mar 2011 09:40:56 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Paolo Santinelli <paolo.santinelli@unimore.it>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH/DRAFT 2/2] V4L: sh_mobile_ceu_camera: implement live cropping
In-Reply-To: <Pine.LNX.4.64.1103300932050.4695@axis700.grange>
Message-ID: <Pine.LNX.4.64.1103300937150.4695@axis700.grange>
References: <AANLkTinVP6CePBY6g9Dn2aKXM0ovwmpqMd5G4ucz44EH@mail.gmail.com>
 <Pine.LNX.4.64.1103292357270.13285@axis700.grange>
 <AANLkTimhP_YoqKRKyPzRbM6gw5jXVNV2D3pveRqqH0W_@mail.gmail.com>
 <AANLkTimuV6Mjvp5K+mUOOBgvRsw+vWtYqPb_Vqr8-tDo@mail.gmail.com>
 <Pine.LNX.4.64.1103300932050.4695@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

PRELIMINARY: break out spinlock changes; consider multiple completing
feames, causing multiple complete() calles.

Add live crop support to the sh_mobile_ceu driver.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

As I mentioned in the introductory mail, this is just a draft, that at the 
very least has to be split into 2 or three individual patches. The parts 
in this patch, relevant to live-crop are the addition of the 
.set_livecrop() method itself, of course, the addition of a completion, 
the "frozen" flag and changed to sh_mobile_ceu_capture().

 drivers/media/video/sh_mobile_ceu_camera.c |  143 ++++++++++++++++++++++++----
 1 files changed, 125 insertions(+), 18 deletions(-)

diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
index 8ff3683..d1446ad 100644
--- a/drivers/media/video/sh_mobile_ceu_camera.c
+++ b/drivers/media/video/sh_mobile_ceu_camera.c
@@ -17,6 +17,7 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/io.h>
+#include <linux/completion.h>
 #include <linux/delay.h>
 #include <linux/dma-mapping.h>
 #include <linux/errno.h>
@@ -106,6 +107,7 @@ struct sh_mobile_ceu_dev {
 	struct vb2_alloc_ctx *alloc_ctx;
 
 	struct sh_mobile_ceu_info *pdata;
+	struct completion complete;
 
 	u32 cflcr;
 
@@ -114,6 +116,7 @@ struct sh_mobile_ceu_dev {
 
 	unsigned int image_mode:1;
 	unsigned int is_16bit:1;
+	unsigned int frozen:1;
 };
 
 struct sh_mobile_ceu_cam {
@@ -273,7 +276,8 @@ static int sh_mobile_ceu_capture(struct sh_mobile_ceu_dev *pcdev)
 	ceu_write(pcdev, CEIER, ceu_read(pcdev, CEIER) & ~CEU_CEIER_MASK);
 	status = ceu_read(pcdev, CETCR);
 	ceu_write(pcdev, CETCR, ~status & CEU_CETCR_MAGIC);
-	ceu_write(pcdev, CEIER, ceu_read(pcdev, CEIER) | CEU_CEIER_MASK);
+	if (!pcdev->frozen)
+		ceu_write(pcdev, CEIER, ceu_read(pcdev, CEIER) | CEU_CEIER_MASK);
 	ceu_write(pcdev, CAPCR, ceu_read(pcdev, CAPCR) & ~CEU_CAPCR_CTNCP);
 	ceu_write(pcdev, CETCR, CEU_CETCR_MAGIC ^ CEU_CETCR_IGRW);
 
@@ -287,6 +291,11 @@ static int sh_mobile_ceu_capture(struct sh_mobile_ceu_dev *pcdev)
 		ret = -EIO;
 	}
 
+	if (pcdev->frozen) {
+		complete(&pcdev->complete);
+		return ret;
+	}
+
 	if (!pcdev->active)
 		return ret;
 
@@ -378,12 +387,11 @@ static void sh_mobile_ceu_videobuf_queue(struct vb2_buffer *vb)
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 	struct sh_mobile_ceu_dev *pcdev = ici->priv;
 	struct sh_mobile_ceu_buffer *buf = to_ceu_vb(vb);
-	unsigned long flags;
 
 	dev_dbg(icd->dev.parent, "%s (vb=0x%p) 0x%p %lu\n", __func__,
 		vb, vb2_plane_vaddr(vb, 0), vb2_get_plane_payload(vb, 0));
 
-	spin_lock_irqsave(&pcdev->lock, flags);
+	spin_lock_irq(&pcdev->lock);
 	list_add_tail(&buf->queue, &pcdev->capture);
 
 	if (!pcdev->active) {
@@ -395,7 +403,7 @@ static void sh_mobile_ceu_videobuf_queue(struct vb2_buffer *vb)
 		pcdev->active = vb;
 		sh_mobile_ceu_capture(pcdev);
 	}
-	spin_unlock_irqrestore(&pcdev->lock, flags);
+	spin_unlock_irq(&pcdev->lock);
 }
 
 static void sh_mobile_ceu_videobuf_release(struct vb2_buffer *vb)
@@ -404,9 +412,8 @@ static void sh_mobile_ceu_videobuf_release(struct vb2_buffer *vb)
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 	struct sh_mobile_ceu_buffer *buf = to_ceu_vb(vb);
 	struct sh_mobile_ceu_dev *pcdev = ici->priv;
-	unsigned long flags;
 
-	spin_lock_irqsave(&pcdev->lock, flags);
+	spin_lock_irq(&pcdev->lock);
 
 	if (pcdev->active == vb) {
 		/* disable capture (release DMA buffer), reset */
@@ -417,7 +424,7 @@ static void sh_mobile_ceu_videobuf_release(struct vb2_buffer *vb)
 	/* Doesn't hurt also if the list is empty */
 	list_del_init(&buf->queue);
 
-	spin_unlock_irqrestore(&pcdev->lock, flags);
+	spin_unlock_irq(&pcdev->lock);
 }
 
 static int sh_mobile_ceu_videobuf_init(struct vb2_buffer *vb)
@@ -433,16 +440,15 @@ static int sh_mobile_ceu_stop_streaming(struct vb2_queue *q)
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 	struct sh_mobile_ceu_dev *pcdev = ici->priv;
 	struct list_head *buf_head, *tmp;
-	unsigned long flags;
 
-	spin_lock_irqsave(&pcdev->lock, flags);
+	spin_lock_irq(&pcdev->lock);
 
 	pcdev->active = NULL;
 
 	list_for_each_safe(buf_head, tmp, &pcdev->capture)
 		list_del_init(buf_head);
 
-	spin_unlock_irqrestore(&pcdev->lock, flags);
+	spin_unlock_irq(&pcdev->lock);
 
 	return sh_mobile_ceu_soft_reset(pcdev);
 }
@@ -521,7 +527,6 @@ static void sh_mobile_ceu_remove_device(struct soc_camera_device *icd)
 {
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 	struct sh_mobile_ceu_dev *pcdev = ici->priv;
-	unsigned long flags;
 
 	BUG_ON(icd != pcdev->icd);
 
@@ -530,13 +535,13 @@ static void sh_mobile_ceu_remove_device(struct soc_camera_device *icd)
 	sh_mobile_ceu_soft_reset(pcdev);
 
 	/* make sure active buffer is canceled */
-	spin_lock_irqsave(&pcdev->lock, flags);
+	spin_lock_irq(&pcdev->lock);
 	if (pcdev->active) {
 		list_del_init(&to_ceu_vb(pcdev->active)->queue);
 		vb2_buffer_done(pcdev->active, VB2_BUF_STATE_ERROR);
 		pcdev->active = NULL;
 	}
-	spin_unlock_irqrestore(&pcdev->lock, flags);
+	spin_unlock_irq(&pcdev->lock);
 
 	pm_runtime_put_sync(ici->v4l2_dev.dev);
 
@@ -1351,7 +1356,7 @@ static int client_scale(struct soc_camera_device *icd,
 /*
  * CEU can scale and crop, but we don't want to waste bandwidth and kill the
  * framerate by always requesting the maximum image from the client. See
- * Documentation/video4linux/sh_mobile_camera_ceu.txt for a description of
+ * Documentation/video4linux/sh_mobile_ceu_camera.txt for a description of
  * scaling and cropping algorithms and for the meaning of referenced here steps.
  */
 static int sh_mobile_ceu_set_crop(struct soc_camera_device *icd,
@@ -1398,10 +1403,6 @@ static int sh_mobile_ceu_set_crop(struct soc_camera_device *icd,
 	if (mf.width > 2560 || mf.height > 1920)
 		return -EINVAL;
 
-	/* Cache camera output window */
-	cam->width	= mf.width;
-	cam->height	= mf.height;
-
 	/* 4. Calculate camera scales */
 	scale_cam_h	= calc_generic_scale(cam_rect->width, mf.width);
 	scale_cam_v	= calc_generic_scale(cam_rect->height, mf.height);
@@ -1410,6 +1411,39 @@ static int sh_mobile_ceu_set_crop(struct soc_camera_device *icd,
 	interm_width	= scale_down(rect->width, scale_cam_h);
 	interm_height	= scale_down(rect->height, scale_cam_v);
 
+	if (interm_width < icd->user_width) {
+		u32 new_scale_h;
+
+		new_scale_h = calc_generic_scale(rect->width, icd->user_width);
+
+		mf.width = scale_down(cam_rect->width, new_scale_h);
+	}
+
+	if (interm_height < icd->user_height) {
+		u32 new_scale_v;
+
+		new_scale_v = calc_generic_scale(rect->height, icd->user_height);
+
+		mf.height = scale_down(cam_rect->height, new_scale_v);
+	}
+
+	if (interm_width < icd->user_width || interm_height < icd->user_height) {
+		ret = v4l2_device_call_until_err(sd->v4l2_dev, (int)icd, video,
+						 s_mbus_fmt, &mf);
+		if (ret < 0)
+			return ret;
+
+		dev_geo(dev, "New camera output %ux%u\n", mf.width, mf.height);
+		scale_cam_h	= calc_generic_scale(cam_rect->width, mf.width);
+		scale_cam_v	= calc_generic_scale(cam_rect->height, mf.height);
+		interm_width	= scale_down(rect->width, scale_cam_h);
+		interm_height	= scale_down(rect->height, scale_cam_v);
+	}
+
+	/* Cache camera output window */
+	cam->width	= mf.width;
+	cam->height	= mf.height;
+
 	if (pcdev->image_mode) {
 		out_width	= min(interm_width, icd->user_width);
 		out_height	= min(interm_height, icd->user_height);
@@ -1725,6 +1759,78 @@ static int sh_mobile_ceu_try_fmt(struct soc_camera_device *icd,
 	return ret;
 }
 
+static int sh_mobile_ceu_set_livecrop(struct soc_camera_device *icd,
+				      struct v4l2_crop *a)
+{
+	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct sh_mobile_ceu_dev *pcdev = ici->priv;
+	u32 out_width = icd->user_width, out_height = icd->user_height;
+	int ret;
+
+	init_completion(&pcdev->complete);
+
+	/* Freeze queue */
+	pcdev->frozen = 1;
+
+	/* Wait for frame */
+	if (pcdev->active) {
+		/*
+		 * No race: if an interrupt hits here, ->frozen is already set
+		 * and the completion will be signalled
+		 */
+		ret = wait_for_completion_interruptible(&pcdev->complete);
+		if (ret < 0) {
+			/* This includes -EINTR */
+			pcdev->frozen = 0;
+			return ret;
+		}
+	}
+
+	/* Stop the client */
+	ret = v4l2_subdev_call(sd, video, s_stream, 0);
+	if (ret < 0)
+		dev_warn(icd->dev.parent,
+			 "Client failed to stop the stream: %d\n", ret);
+	else
+		/* Do the crop, if it fails, there's nothing more we can do */
+		sh_mobile_ceu_set_crop(icd, a);
+
+	dev_geo(icd->dev.parent, "Output after crop: %ux%u\n", icd->user_width, icd->user_height);
+
+	if (icd->user_width != out_width || icd->user_height != out_height) {
+		struct v4l2_format f = {
+			.type	= V4L2_BUF_TYPE_VIDEO_CAPTURE,
+			.fmt.pix	= {
+				.width		= out_width,
+				.height		= out_height,
+				.pixelformat	= icd->current_fmt->host_fmt->fourcc,
+				.field		= pcdev->field,
+				.colorspace	= icd->colorspace,
+			},
+		};
+		ret = sh_mobile_ceu_set_fmt(icd, &f);
+		if (!ret && (out_width != f.fmt.pix.width ||
+			     out_height != f.fmt.pix.height))
+			ret = -EINVAL;
+		if (!ret) {
+			icd->user_width		= out_width;
+			icd->user_height	= out_height;
+			ret = sh_mobile_ceu_set_bus_param(icd,
+					icd->current_fmt->host_fmt->fourcc);
+		}
+	}
+
+	/* Thaw the queue */
+	pcdev->frozen = 0;
+	spin_lock_irq(&pcdev->lock);
+	sh_mobile_ceu_capture(pcdev);
+	spin_unlock_irq(&pcdev->lock);
+	/* Start the client */
+	ret = v4l2_subdev_call(sd, video, s_stream, 1);
+	return ret;
+}
+
 static unsigned int sh_mobile_ceu_poll(struct file *file, poll_table *pt)
 {
 	struct soc_camera_device *icd = file->private_data;
@@ -1811,6 +1917,7 @@ static struct soc_camera_host_ops sh_mobile_ceu_host_ops = {
 	.put_formats	= sh_mobile_ceu_put_formats,
 	.get_crop	= sh_mobile_ceu_get_crop,
 	.set_crop	= sh_mobile_ceu_set_crop,
+	.set_livecrop	= sh_mobile_ceu_set_livecrop,
 	.set_fmt	= sh_mobile_ceu_set_fmt,
 	.try_fmt	= sh_mobile_ceu_try_fmt,
 	.set_ctrl	= sh_mobile_ceu_set_ctrl,
-- 
1.7.2.5

