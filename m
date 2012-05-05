Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:45740 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755824Ab2EEQRv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 May 2012 12:17:51 -0400
Received: by gglu4 with SMTP id u4so24117ggl.19
        for <linux-media@vger.kernel.org>; Sat, 05 May 2012 09:17:48 -0700 (PDT)
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: mchehab@infradead.org
Cc: crope@iki.fi, gennarone@gmail.com, linux-media@vger.kernel.org,
	Ezequiel Garcia <elezegarcia@gmail.com>
Subject: [PATCH] em28xx: Remove unused wait_queue's
Date: Sat,  5 May 2012 13:17:33 -0300
Message-Id: <1336234653-24456-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Nobody ever waits on any of these wait_queue's,
so this patch removes them completely.
Tested by compilation only.

Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 drivers/media/video/em28xx/em28xx-cards.c |    7 -------
 drivers/media/video/em28xx/em28xx-video.c |    1 -
 drivers/media/video/em28xx/em28xx.h       |    1 -
 3 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/drivers/media/video/em28xx/em28xx-cards.c b/drivers/media/video/em28xx/em28xx-cards.c
index eea90b0..c59e198 100644
--- a/drivers/media/video/em28xx/em28xx-cards.c
+++ b/drivers/media/video/em28xx/em28xx-cards.c
@@ -3007,9 +3007,6 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
 	dev->udev = udev;
 	mutex_init(&dev->ctrl_urb_lock);
 	spin_lock_init(&dev->slock);
-	init_waitqueue_head(&dev->open);
-	init_waitqueue_head(&dev->wait_frame);
-	init_waitqueue_head(&dev->wait_stream);
 
 	dev->em28xx_write_regs = em28xx_write_regs;
 	dev->em28xx_read_reg = em28xx_read_reg;
@@ -3447,8 +3444,6 @@ static void em28xx_usb_disconnect(struct usb_interface *interface)
 	   resources */
 	mutex_lock(&dev->lock);
 
-	wake_up_interruptible_all(&dev->open);
-
 	v4l2_device_disconnect(&dev->v4l2_dev);
 
 	if (dev->users) {
@@ -3460,8 +3455,6 @@ static void em28xx_usb_disconnect(struct usb_interface *interface)
 		dev->state |= DEV_MISCONFIGURED;
 		em28xx_uninit_isoc(dev, dev->mode);
 		dev->state |= DEV_DISCONNECTED;
-		wake_up_interruptible(&dev->wait_frame);
-		wake_up_interruptible(&dev->wait_stream);
 	} else {
 		dev->state |= DEV_DISCONNECTED;
 		em28xx_release_resources(dev);
diff --git a/drivers/media/video/em28xx/em28xx-video.c b/drivers/media/video/em28xx/em28xx-video.c
index 324b695..8404ec4 100644
--- a/drivers/media/video/em28xx/em28xx-video.c
+++ b/drivers/media/video/em28xx/em28xx-video.c
@@ -2286,7 +2286,6 @@ static int em28xx_v4l2_close(struct file *filp)
 	videobuf_mmap_free(&fh->vb_vbiq);
 	kfree(fh);
 	dev->users--;
-	wake_up_interruptible_nr(&dev->open, 1);
 	return 0;
 }
 
diff --git a/drivers/media/video/em28xx/em28xx.h b/drivers/media/video/em28xx/em28xx.h
index b5bac9c..b19422e 100644
--- a/drivers/media/video/em28xx/em28xx.h
+++ b/drivers/media/video/em28xx/em28xx.h
@@ -583,7 +583,6 @@ struct em28xx {
 	struct mutex ctrl_urb_lock;	/* protects urb_buf */
 	/* spinlock_t queue_lock; */
 	struct list_head inqueue, outqueue;
-	wait_queue_head_t open, wait_frame, wait_stream;
 	struct video_device *vbi_dev;
 	struct video_device *radio_dev;
 
-- 
1.7.3.4

