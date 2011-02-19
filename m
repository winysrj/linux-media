Return-path: <mchehab@pedra>
Received: from mail-out.m-online.net ([212.18.0.10]:55464 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407Ab1BSUdZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 19 Feb 2011 15:33:25 -0500
From: Anatolij Gustschin <agust@denx.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Anatolij Gustschin <agust@denx.de>
Subject: [PATCH] fsl-viu: replace .ioctl by .unlocked_ioctl
Date: Sat, 19 Feb 2011 21:33:18 +0100
Message-Id: <1298147598-2944-1-git-send-email-agust@denx.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Use the core-assisted locking in fsl-viu driver and switch
to .unlocked_ioctl.

Signed-off-by: Anatolij Gustschin <agust@denx.de>
---
 drivers/media/video/fsl-viu.c |   20 +++++++++++++-------
 1 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/media/video/fsl-viu.c b/drivers/media/video/fsl-viu.c
index e4bba88..a20b166 100644
--- a/drivers/media/video/fsl-viu.c
+++ b/drivers/media/video/fsl-viu.c
@@ -825,13 +825,11 @@ static int vidioc_s_fmt_overlay(struct file *file, void *priv,
 	if (err)
 		return err;
 
-	mutex_lock(&dev->lock);
 	fh->win = f->fmt.win;
 
 	spin_lock_irqsave(&dev->slock, flags);
 	viu_start_preview(dev, fh);
 	spin_unlock_irqrestore(&dev->slock, flags);
-	mutex_unlock(&dev->lock);
 	return 0;
 }
 
@@ -1311,7 +1309,8 @@ static int viu_open(struct file *file)
 	videobuf_queue_dma_contig_init(&fh->vb_vidq, &viu_video_qops,
 				       dev->dev, &fh->vbq_lock,
 				       fh->type, V4L2_FIELD_INTERLACED,
-				       sizeof(struct viu_buf), fh, NULL);
+				       sizeof(struct viu_buf), fh,
+				       &fh->dev->lock);
 	return 0;
 }
 
@@ -1401,7 +1400,7 @@ static struct v4l2_file_operations viu_fops = {
 	.release	= viu_release,
 	.read		= viu_read,
 	.poll		= viu_poll,
-	.ioctl		= video_ioctl2, /* V4L2 ioctl handler */
+	.unlocked_ioctl	= video_ioctl2, /* V4L2 ioctl handler */
 	.mmap		= viu_mmap,
 };
 
@@ -1499,9 +1498,6 @@ static int __devinit viu_of_probe(struct platform_device *op,
 	INIT_LIST_HEAD(&viu_dev->vidq.active);
 	INIT_LIST_HEAD(&viu_dev->vidq.queued);
 
-	/* initialize locks */
-	mutex_init(&viu_dev->lock);
-
 	snprintf(viu_dev->v4l2_dev.name,
 		 sizeof(viu_dev->v4l2_dev.name), "%s", "VIU");
 	ret = v4l2_device_register(viu_dev->dev, &viu_dev->v4l2_dev);
@@ -1532,8 +1528,15 @@ static int __devinit viu_of_probe(struct platform_device *op,
 
 	viu_dev->vdev = vdev;
 
+	/* initialize locks */
+	mutex_init(&viu_dev->lock);
+	viu_dev->vdev->lock = &viu_dev->lock;
+	spin_lock_init(&viu_dev->slock);
+
 	video_set_drvdata(viu_dev->vdev, viu_dev);
 
+	mutex_lock(&viu_dev->lock);
+
 	ret = video_register_device(viu_dev->vdev, VFL_TYPE_GRABBER, -1);
 	if (ret < 0) {
 		video_device_release(viu_dev->vdev);
@@ -1560,6 +1563,8 @@ static int __devinit viu_of_probe(struct platform_device *op,
 		goto err_irq;
 	}
 
+	mutex_unlock(&viu_dev->lock);
+
 	dev_info(&op->dev, "Freescale VIU Video Capture Board\n");
 	return ret;
 
@@ -1569,6 +1574,7 @@ err_irq:
 err_clk:
 	video_unregister_device(viu_dev->vdev);
 err_vdev:
+	mutex_unlock(&viu_dev->lock);
 	i2c_put_adapter(ad);
 	v4l2_device_unregister(&viu_dev->v4l2_dev);
 err:
-- 
1.7.1

