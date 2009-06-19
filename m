Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.wellnetcz.com ([212.24.148.102]:40505 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753171AbZFSUad (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Jun 2009 16:30:33 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: mchehab@infradead.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 3/4] V4L: hdpvr, fix lock imbalances
Date: Fri, 19 Jun 2009 22:30:06 +0200
Message-Id: <1245443407-17410-3-git-send-email-jirislaby@gmail.com>
In-Reply-To: <1245443407-17410-1-git-send-email-jirislaby@gmail.com>
References: <1245443407-17410-1-git-send-email-jirislaby@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are many lock imbalances in this driver. Fix all found.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/media/video/hdpvr/hdpvr-core.c  |   12 ++++++------
 drivers/media/video/hdpvr/hdpvr-video.c |    6 ++++--
 2 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/media/video/hdpvr/hdpvr-core.c b/drivers/media/video/hdpvr/hdpvr-core.c
index 188bd5a..1c9bc94 100644
--- a/drivers/media/video/hdpvr/hdpvr-core.c
+++ b/drivers/media/video/hdpvr/hdpvr-core.c
@@ -126,7 +126,7 @@ static int device_authorization(struct hdpvr_device *dev)
 	char *print_buf = kzalloc(5*buf_size+1, GFP_KERNEL);
 	if (!print_buf) {
 		v4l2_err(&dev->v4l2_dev, "Out of memory\n");
-		goto error;
+		return retval;
 	}
 #endif
 
@@ -140,7 +140,7 @@ static int device_authorization(struct hdpvr_device *dev)
 	if (ret != 46) {
 		v4l2_err(&dev->v4l2_dev,
 			 "unexpected answer of status request, len %d\n", ret);
-		goto error;
+		goto unlock;
 	}
 #ifdef HDPVR_DEBUG
 	else {
@@ -163,7 +163,7 @@ static int device_authorization(struct hdpvr_device *dev)
 		v4l2_err(&dev->v4l2_dev, "unknown firmware version 0x%x\n",
 			dev->usbc_buf[1]);
 		ret = -EINVAL;
-		goto error;
+		goto unlock;
 	}
 
 	response = dev->usbc_buf+38;
@@ -188,10 +188,10 @@ static int device_authorization(struct hdpvr_device *dev)
 			      10000);
 	v4l2_dbg(MSG_INFO, hdpvr_debug, &dev->v4l2_dev,
 		 "magic request returned %d\n", ret);
-	mutex_unlock(&dev->usbc_mutex);
 
 	retval = ret != 8;
-error:
+unlock:
+	mutex_unlock(&dev->usbc_mutex);
 	return retval;
 }
 
@@ -350,6 +350,7 @@ static int hdpvr_probe(struct usb_interface *interface,
 
 	mutex_lock(&dev->io_mutex);
 	if (hdpvr_alloc_buffers(dev, NUM_BUFFERS)) {
+		mutex_unlock(&dev->io_mutex);
 		v4l2_err(&dev->v4l2_dev,
 			 "allocating transfer buffers failed\n");
 		goto error;
@@ -381,7 +382,6 @@ static int hdpvr_probe(struct usb_interface *interface,
 
 error:
 	if (dev) {
-		mutex_unlock(&dev->io_mutex);
 		/* this frees allocated memory */
 		hdpvr_delete(dev);
 	}
diff --git a/drivers/media/video/hdpvr/hdpvr-video.c b/drivers/media/video/hdpvr/hdpvr-video.c
index ccd47f5..5937de2 100644
--- a/drivers/media/video/hdpvr/hdpvr-video.c
+++ b/drivers/media/video/hdpvr/hdpvr-video.c
@@ -375,6 +375,7 @@ static int hdpvr_open(struct file *file)
 	 * in resumption */
 	mutex_lock(&dev->io_mutex);
 	dev->open_count++;
+	mutex_unlock(&dev->io_mutex);
 
 	fh->dev = dev;
 
@@ -383,7 +384,6 @@ static int hdpvr_open(struct file *file)
 
 	retval = 0;
 err:
-	mutex_unlock(&dev->io_mutex);
 	return retval;
 }
 
@@ -519,8 +519,10 @@ static unsigned int hdpvr_poll(struct file *filp, poll_table *wait)
 
 	mutex_lock(&dev->io_mutex);
 
-	if (video_is_unregistered(dev->video_dev))
+	if (video_is_unregistered(dev->video_dev)) {
+		mutex_unlock(&dev->io_mutex);
 		return -EIO;
+	}
 
 	if (dev->status == STATUS_IDLE) {
 		if (hdpvr_start_streaming(dev)) {
-- 
1.6.3.2

