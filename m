Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:32810 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932505Ab2HGCry (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Aug 2012 22:47:54 -0400
Received: by mail-vc0-f174.google.com with SMTP id fk26so3432645vcb.19
        for <linux-media@vger.kernel.org>; Mon, 06 Aug 2012 19:47:54 -0700 (PDT)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: [PATCH 08/24] au0828: fix race condition that causes xc5000 to not bind for digital
Date: Mon,  6 Aug 2012 22:46:58 -0400
Message-Id: <1344307634-11673-9-git-send-email-dheitmueller@kernellabs.com>
In-Reply-To: <1344307634-11673-1-git-send-email-dheitmueller@kernellabs.com>
References: <1344307634-11673-1-git-send-email-dheitmueller@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In some cases users would see the xc5000_attach() call failing for the
digital side of the tuner on initialization.  This is because of udev
running v4l-id while the digital side of the board is still coming up.

This is the exact same race condition which was present in em28xx (not
surprising since I copied all the locking logic from that driver when I
added analog support).  Reproduce Mauro's fix from the em28xx driver in
au0828.

Reported-by: Rick Harding <rharding@mitechie.com>
Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
---
 drivers/media/video/au0828/au0828-core.c  |    5 +++++
 drivers/media/video/au0828/au0828-video.c |   21 ++++++++-------------
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/media/video/au0828/au0828-core.c b/drivers/media/video/au0828/au0828-core.c
index 1e4ce50..b2c4254 100644
--- a/drivers/media/video/au0828/au0828-core.c
+++ b/drivers/media/video/au0828/au0828-core.c
@@ -205,6 +205,8 @@ static int au0828_usb_probe(struct usb_interface *interface,
 		return -ENOMEM;
 	}
 
+	mutex_init(&dev->lock);
+	mutex_lock(&dev->lock);
 	mutex_init(&dev->mutex);
 	mutex_init(&dev->dvb.lock);
 	dev->usbdev = usbdev;
@@ -215,6 +217,7 @@ static int au0828_usb_probe(struct usb_interface *interface,
 	if (retval) {
 		printk(KERN_ERR "%s() v4l2_device_register failed\n",
 		       __func__);
+		mutex_unlock(&dev->lock);
 		kfree(dev);
 		return -EIO;
 	}
@@ -245,6 +248,8 @@ static int au0828_usb_probe(struct usb_interface *interface,
 	printk(KERN_INFO "Registered device AU0828 [%s]\n",
 		dev->board.name == NULL ? "Unset" : dev->board.name);
 
+	mutex_unlock(&dev->lock);
+
 	return 0;
 }
 
diff --git a/drivers/media/video/au0828/au0828-video.c b/drivers/media/video/au0828/au0828-video.c
index 6e30c09..b1f8d18 100644
--- a/drivers/media/video/au0828/au0828-video.c
+++ b/drivers/media/video/au0828/au0828-video.c
@@ -864,17 +864,15 @@ static int res_get(struct au0828_fh *fh, unsigned int bit)
 		return 1;
 
 	/* is it free? */
-	mutex_lock(&dev->lock);
 	if (dev->resources & bit) {
 		/* no, someone else uses it */
-		mutex_unlock(&dev->lock);
 		return 0;
 	}
 	/* it's free, grab it */
 	fh->resources  |= bit;
 	dev->resources |= bit;
 	dprintk(1, "res: get %d\n", bit);
-	mutex_unlock(&dev->lock);
+
 	return 1;
 }
 
@@ -894,11 +892,9 @@ static void res_free(struct au0828_fh *fh, unsigned int bits)
 
 	BUG_ON((fh->resources & bits) != bits);
 
-	mutex_lock(&dev->lock);
 	fh->resources  &= ~bits;
 	dev->resources &= ~bits;
 	dprintk(1, "res: put %d\n", bits);
-	mutex_unlock(&dev->lock);
 }
 
 static int get_ressource(struct au0828_fh *fh)
@@ -1023,7 +1019,8 @@ static int au0828_v4l2_open(struct file *filp)
 				    NULL, &dev->slock,
 				    V4L2_BUF_TYPE_VIDEO_CAPTURE,
 				    V4L2_FIELD_INTERLACED,
-				    sizeof(struct au0828_buffer), fh, NULL);
+				    sizeof(struct au0828_buffer), fh,
+				    &dev->lock);
 
 	/* VBI Setup */
 	dev->vbi_width = 720;
@@ -1032,8 +1029,8 @@ static int au0828_v4l2_open(struct file *filp)
 				    NULL, &dev->slock,
 				    V4L2_BUF_TYPE_VBI_CAPTURE,
 				    V4L2_FIELD_SEQ_TB,
-				    sizeof(struct au0828_buffer), fh, NULL);
-
+				    sizeof(struct au0828_buffer), fh,
+				    &dev->lock);
 	return ret;
 }
 
@@ -1312,8 +1309,6 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 	if (rc < 0)
 		return rc;
 
-	mutex_lock(&dev->lock);
-
 	if (videobuf_queue_is_busy(&fh->vb_vidq)) {
 		printk(KERN_INFO "%s queue busy\n", __func__);
 		rc = -EBUSY;
@@ -1322,7 +1317,6 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 
 	rc = au0828_set_format(dev, VIDIOC_S_FMT, f);
 out:
-	mutex_unlock(&dev->lock);
 	return rc;
 }
 
@@ -1832,7 +1826,7 @@ static struct v4l2_file_operations au0828_v4l_fops = {
 	.read       = au0828_v4l2_read,
 	.poll       = au0828_v4l2_poll,
 	.mmap       = au0828_v4l2_mmap,
-	.ioctl      = video_ioctl2,
+	.unlocked_ioctl = video_ioctl2,
 };
 
 static const struct v4l2_ioctl_ops video_ioctl_ops = {
@@ -1922,7 +1916,6 @@ int au0828_analog_register(struct au0828_dev *dev,
 
 	init_waitqueue_head(&dev->open);
 	spin_lock_init(&dev->slock);
-	mutex_init(&dev->lock);
 
 	/* init video dma queues */
 	INIT_LIST_HEAD(&dev->vidq.active);
@@ -1963,11 +1956,13 @@ int au0828_analog_register(struct au0828_dev *dev,
 	/* Fill the video capture device struct */
 	*dev->vdev = au0828_video_template;
 	dev->vdev->parent = &dev->usbdev->dev;
+	dev->vdev->lock = &dev->lock;
 	strcpy(dev->vdev->name, "au0828a video");
 
 	/* Setup the VBI device */
 	*dev->vbi_dev = au0828_video_template;
 	dev->vbi_dev->parent = &dev->usbdev->dev;
+	dev->vbi_dev->lock = &dev->lock;
 	strcpy(dev->vbi_dev->name, "au0828a vbi");
 
 	/* Register the v4l2 device */
-- 
1.7.1

