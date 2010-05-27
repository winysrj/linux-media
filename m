Return-path: <linux-media-owner@vger.kernel.org>
Received: from 99-34-136-231.lightspeed.bcvloh.sbcglobal.net ([99.34.136.231]:41824
	"EHLO desource.dyndns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757186Ab0E0Qku (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 May 2010 12:40:50 -0400
From: David Ellingsworth <david@identd.dyndns.org>
To: linux-media@vger.kernel.org
Cc: Markus Demleitner <msdemlei@tucana.harvard.edu>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	David Ellingsworth <david@identd.dyndns.org>
Subject: [PATCH/RFC v2 7/8] dsbr100: cleanup usb probe routine
Date: Thu, 27 May 2010 12:39:15 -0400
Message-Id: <1274978356-25836-8-git-send-email-david@identd.dyndns.org>
In-Reply-To: <[PATCH/RFC 0/7] dsbr100: driver cleanup>
References: <[PATCH/RFC 0/7] dsbr100: driver cleanup>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch simplifies the error paths within the
usb_dsbr100_probe routine. It also removes an unnecessary
local variable.

Signed-off-by: David Ellingsworth <david@identd.dyndns.org>
---
 drivers/media/radio/dsbr100.c |   39 ++++++++++++++++++++-------------------
 1 files changed, 20 insertions(+), 19 deletions(-)

diff --git a/drivers/media/radio/dsbr100.c b/drivers/media/radio/dsbr100.c
index 96e6128..81e6aa5 100644
--- a/drivers/media/radio/dsbr100.c
+++ b/drivers/media/radio/dsbr100.c
@@ -645,33 +645,28 @@ static int usb_dsbr100_probe(struct usb_interface *intf,
 				const struct usb_device_id *id)
 {
 	struct dsbr100_device *radio;
-	struct v4l2_device *v4l2_dev;
 	int retval;
 
 	radio = kzalloc(sizeof(struct dsbr100_device), GFP_KERNEL);
-
 	if (!radio)
 		return -ENOMEM;
 
 	radio->transfer_buffer = kmalloc(TB_LEN, GFP_KERNEL);
-
 	if (!(radio->transfer_buffer)) {
-		kfree(radio);
-		return -ENOMEM;
+		retval = -ENOMEM;
+		goto err_nobuf;
 	}
 
-	v4l2_dev = &radio->v4l2_dev;
-
-	retval = v4l2_device_register(&intf->dev, v4l2_dev);
+	retval = v4l2_device_register(&intf->dev, &radio->v4l2_dev);
 	if (retval < 0) {
-		v4l2_err(v4l2_dev, "couldn't register v4l2_device\n");
-		kfree(radio->transfer_buffer);
-		kfree(radio);
-		return retval;
+		v4l2_err(&radio->v4l2_dev, "couldn't register v4l2_device\n");
+		goto err_v4l2;
 	}
 
-	strlcpy(radio->videodev.name, v4l2_dev->name, sizeof(radio->videodev.name));
-	radio->videodev.v4l2_dev = v4l2_dev;
+	strlcpy(radio->videodev.name, radio->v4l2_dev.name,
+		sizeof(radio->videodev.name));
+
+	radio->videodev.v4l2_dev = &radio->v4l2_dev;
 	radio->videodev.fops = &usb_dsbr100_fops;
 	radio->videodev.ioctl_ops = &usb_dsbr100_ioctl_ops;
 	radio->videodev.release = usb_dsbr100_video_device_release;
@@ -685,14 +680,20 @@ static int usb_dsbr100_probe(struct usb_interface *intf,
 
 	retval = video_register_device(&radio->videodev, VFL_TYPE_RADIO, radio_nr);
 	if (retval < 0) {
-		v4l2_err(v4l2_dev, "couldn't register video device\n");
-		v4l2_device_unregister(v4l2_dev);
-		kfree(radio->transfer_buffer);
-		kfree(radio);
-		return -EIO;
+		v4l2_err(&radio->v4l2_dev, "couldn't register video device\n");
+		goto err_vdev;
 	}
+
 	usb_set_intfdata(intf, radio);
 	return 0;
+
+err_vdev:
+	v4l2_device_unregister(&radio->v4l2_dev);
+err_v4l2:
+	kfree(radio->transfer_buffer);
+err_nobuf:
+	kfree(radio);
+	return retval;
 }
 
 static int __init dsbr100_init(void)
-- 
1.7.1

