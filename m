Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:1485 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759657Ab3DHK7W (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Apr 2013 06:59:22 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Janne Grunau <j@jannau.net>, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 08/12] hdpvr: register the video node at the end of probe.
Date: Mon,  8 Apr 2013 12:58:37 +0200
Message-Id: <1365418721-23859-9-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1365418721-23859-1-git-send-email-hverkuil@xs4all.nl>
References: <1365418721-23859-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Video nodes can be used at once after registration, so make sure the full
initialization is done before registering them.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/hdpvr/hdpvr-core.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/media/usb/hdpvr/hdpvr-core.c b/drivers/media/usb/hdpvr/hdpvr-core.c
index 73195fe..248835b 100644
--- a/drivers/media/usb/hdpvr/hdpvr-core.c
+++ b/drivers/media/usb/hdpvr/hdpvr-core.c
@@ -386,12 +386,6 @@ static int hdpvr_probe(struct usb_interface *interface,
 	}
 	mutex_unlock(&dev->io_mutex);
 
-	if (hdpvr_register_videodev(dev, &interface->dev,
-				    video_nr[atomic_inc_return(&dev_nr)])) {
-		v4l2_err(&dev->v4l2_dev, "registering videodev failed\n");
-		goto error;
-	}
-
 #if IS_ENABLED(CONFIG_I2C)
 	retval = hdpvr_register_i2c_adapter(dev);
 	if (retval < 0) {
@@ -414,6 +408,13 @@ static int hdpvr_probe(struct usb_interface *interface,
 	}
 #endif
 
+	retval = hdpvr_register_videodev(dev, &interface->dev,
+				    video_nr[atomic_inc_return(&dev_nr)]);
+	if (retval < 0) {
+		v4l2_err(&dev->v4l2_dev, "registering videodev failed\n");
+		goto error;
+	}
+
 	/* let the user know what node this device is now attached to */
 	v4l2_info(&dev->v4l2_dev, "device now attached to %s\n",
 		  video_device_node_name(dev->video_dev));
-- 
1.7.10.4

