Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f171.google.com ([209.85.215.171]:39436 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbaALQXx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Jan 2014 11:23:53 -0500
Received: by mail-ea0-f171.google.com with SMTP id h10so2869543eak.16
        for <linux-media@vger.kernel.org>; Sun, 12 Jan 2014 08:23:52 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: m.chehab@samsung.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [RFT/RFC PATCH 8/8] em28xx-v4l: fix the freeing of the video devices memory
Date: Sun, 12 Jan 2014 17:24:25 +0100
Message-Id: <1389543865-2534-9-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1389543865-2534-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1389543865-2534-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove some dead code from em28xx_v4l2_fini() and fix the leaking of the video, 
vbi and radio video_device struct memories.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-video.c |   56 +++++++++++++++++--------------
 1 Datei geändert, 30 Zeilen hinzugefügt(+), 26 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 87b140f..a643adda 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -1899,29 +1899,19 @@ static int em28xx_v4l2_fini(struct em28xx *dev)
 	em28xx_uninit_usb_xfer(dev, EM28XX_ANALOG_MODE);
 
 	if (dev->radio_dev) {
-		if (video_is_registered(dev->radio_dev))
-			video_unregister_device(dev->radio_dev);
-		else
-			video_device_release(dev->radio_dev);
-		dev->radio_dev = NULL;
+		em28xx_info("V4L2 device %s deregistered\n",
+			    video_device_node_name(dev->radio_dev));
+		video_unregister_device(dev->radio_dev);
 	}
 	if (dev->vbi_dev) {
 		em28xx_info("V4L2 device %s deregistered\n",
 			    video_device_node_name(dev->vbi_dev));
-		if (video_is_registered(dev->vbi_dev))
-			video_unregister_device(dev->vbi_dev);
-		else
-			video_device_release(dev->vbi_dev);
-		dev->vbi_dev = NULL;
+		video_unregister_device(dev->vbi_dev);
 	}
 	if (dev->vdev) {
 		em28xx_info("V4L2 device %s deregistered\n",
 			    video_device_node_name(dev->vdev));
-		if (video_is_registered(dev->vdev))
-			video_unregister_device(dev->vdev);
-		else
-			video_device_release(dev->vdev);
-		dev->vdev = NULL;
+		video_unregister_device(dev->vdev);
 	}
 
 	v4l2_ctrl_handler_free(&dev->ctrl_handler);
@@ -1955,9 +1945,7 @@ static int em28xx_v4l2_close(struct file *filp)
 	mutex_lock(&dev->lock);
 
 	if (dev->users == 1) {
-		/* the device is already disconnect,
-		   free the remaining resources */
-
+		/* free the remaining resources if device is disconnected */
 		if (dev->disconnected) {
 			kfree(dev->alt_max_pkt_size_isoc);
 			goto exit;
@@ -1985,6 +1973,23 @@ exit:
 	return 0;
 }
 
+/*
+ * em28xx_videodevice_release()
+ * called when the last user of the video device exits and frees the memeory
+ */
+static void em28xx_videodevice_release(struct video_device *vdev)
+{
+	struct em28xx *dev = video_get_drvdata(vdev);
+
+	video_device_release(vdev);
+	if (vdev == dev->vdev)
+		dev->vdev = NULL;
+	else if (vdev == dev->vbi_dev)
+		dev->vbi_dev = NULL;
+	else if (vdev == dev->radio_dev)
+		dev->radio_dev = NULL;
+}
+
 static const struct v4l2_file_operations em28xx_v4l_fops = {
 	.owner         = THIS_MODULE,
 	.open          = em28xx_v4l2_open,
@@ -2039,11 +2044,10 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 };
 
 static const struct video_device em28xx_video_template = {
-	.fops                       = &em28xx_v4l_fops,
-	.release                    = video_device_release_empty,
-	.ioctl_ops 		    = &video_ioctl_ops,
-
-	.tvnorms                    = V4L2_STD_ALL,
+	.fops		= &em28xx_v4l_fops,
+	.ioctl_ops	= &video_ioctl_ops,
+	.release	= em28xx_videodevice_release,
+	.tvnorms	= V4L2_STD_ALL,
 };
 
 static const struct v4l2_file_operations radio_fops = {
@@ -2069,9 +2073,9 @@ static const struct v4l2_ioctl_ops radio_ioctl_ops = {
 };
 
 static struct video_device em28xx_radio_template = {
-	.name                 = "em28xx-radio",
-	.fops                 = &radio_fops,
-	.ioctl_ops 	      = &radio_ioctl_ops,
+	.fops		= &radio_fops,
+	.ioctl_ops	= &radio_ioctl_ops,
+	.release	= em28xx_videodevice_release,
 };
 
 /* I2C possible address to saa7115, tvp5150, msp3400, tvaudio */
-- 
1.7.10.4

