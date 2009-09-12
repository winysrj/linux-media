Return-path: <linux-media-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.27]:15620 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754545AbZILOth (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Sep 2009 10:49:37 -0400
Received: by qw-out-2122.google.com with SMTP id 9so632979qwb.37
        for <linux-media@vger.kernel.org>; Sat, 12 Sep 2009 07:49:40 -0700 (PDT)
Message-ID: <4AABB4FB.4050102@gmail.com>
Date: Sat, 12 Sep 2009 10:49:31 -0400
From: David Ellingsworth <david@identd.dyndns.org>
Reply-To: david@identd.dyndns.org
MIME-Version: 1.0
To: linux-media@vger.kernel.org, klimov.linux@gmail.com
Subject: [RFC/RFT 04/10] radio-mr800: remove unnecessary local variable
Content-Type: multipart/mixed;
 boundary="------------050006090900090606050406"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------050006090900090606050406
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

 From f2fdb83ce649e9e69413ab533ec4a84d96850ed4 Mon Sep 17 00:00:00 2001
From: David Ellingsworth <david@identd.dyndns.org>
Date: Sat, 12 Sep 2009 00:19:48 -0400
Subject: [PATCH 04/10] mr800: remove unnecessary local variable

Signed-off-by: David Ellingsworth <david@identd.dyndns.org>
---
 drivers/media/radio/radio-mr800.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/media/radio/radio-mr800.c 
b/drivers/media/radio/radio-mr800.c
index d01b96c..fb99c6b 100644
--- a/drivers/media/radio/radio-mr800.c
+++ b/drivers/media/radio/radio-mr800.c
@@ -688,7 +688,6 @@ static int usb_amradio_probe(struct usb_interface *intf,
                 const struct usb_device_id *id)
 {
     struct amradio_device *radio;
-    struct v4l2_device *v4l2_dev;
     int retval = 0;
 
     radio = kzalloc(sizeof(struct amradio_device), GFP_KERNEL);
@@ -707,16 +706,15 @@ static int usb_amradio_probe(struct usb_interface 
*intf,
         goto err_nobuf;
     }
 
-    v4l2_dev = &radio->v4l2_dev;
-    retval = v4l2_device_register(&intf->dev, v4l2_dev);
+    retval = v4l2_device_register(&intf->dev, &radio->v4l2_dev);
     if (retval < 0) {
         dev_err(&intf->dev, "couldn't register v4l2_device\n");
         goto err_v4l2;
     }
 
-    strlcpy(radio->videodev.name, v4l2_dev->name,
+    strlcpy(radio->videodev.name, radio->v4l2_dev.name,
         sizeof(radio->videodev.name));
-    radio->videodev.v4l2_dev = v4l2_dev;
+    radio->videodev.v4l2_dev = &radio->v4l2_dev;
     radio->videodev.fops = &usb_amradio_fops;
     radio->videodev.ioctl_ops = &usb_amradio_ioctl_ops;
     radio->videodev.release = usb_amradio_video_device_release;
@@ -742,7 +740,7 @@ static int usb_amradio_probe(struct usb_interface *intf,
     return 0;
 
 err_vdev:
-    v4l2_device_unregister(v4l2_dev);
+    v4l2_device_unregister(&radio->v4l2_dev);
 err_v4l2:
     kfree(radio->buffer);
 err_nobuf:
-- 
1.6.3.3


--------------050006090900090606050406
Content-Type: text/x-diff;
 name="0004-mr800-remove-unnecessary-local-variable.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0004-mr800-remove-unnecessary-local-variable.patch"

>From f2fdb83ce649e9e69413ab533ec4a84d96850ed4 Mon Sep 17 00:00:00 2001
From: David Ellingsworth <david@identd.dyndns.org>
Date: Sat, 12 Sep 2009 00:19:48 -0400
Subject: [PATCH 04/10] mr800: remove unnecessary local variable

Signed-off-by: David Ellingsworth <david@identd.dyndns.org>
---
 drivers/media/radio/radio-mr800.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/media/radio/radio-mr800.c b/drivers/media/radio/radio-mr800.c
index d01b96c..fb99c6b 100644
--- a/drivers/media/radio/radio-mr800.c
+++ b/drivers/media/radio/radio-mr800.c
@@ -688,7 +688,6 @@ static int usb_amradio_probe(struct usb_interface *intf,
 				const struct usb_device_id *id)
 {
 	struct amradio_device *radio;
-	struct v4l2_device *v4l2_dev;
 	int retval = 0;
 
 	radio = kzalloc(sizeof(struct amradio_device), GFP_KERNEL);
@@ -707,16 +706,15 @@ static int usb_amradio_probe(struct usb_interface *intf,
 		goto err_nobuf;
 	}
 
-	v4l2_dev = &radio->v4l2_dev;
-	retval = v4l2_device_register(&intf->dev, v4l2_dev);
+	retval = v4l2_device_register(&intf->dev, &radio->v4l2_dev);
 	if (retval < 0) {
 		dev_err(&intf->dev, "couldn't register v4l2_device\n");
 		goto err_v4l2;
 	}
 
-	strlcpy(radio->videodev.name, v4l2_dev->name,
+	strlcpy(radio->videodev.name, radio->v4l2_dev.name,
 		sizeof(radio->videodev.name));
-	radio->videodev.v4l2_dev = v4l2_dev;
+	radio->videodev.v4l2_dev = &radio->v4l2_dev;
 	radio->videodev.fops = &usb_amradio_fops;
 	radio->videodev.ioctl_ops = &usb_amradio_ioctl_ops;
 	radio->videodev.release = usb_amradio_video_device_release;
@@ -742,7 +740,7 @@ static int usb_amradio_probe(struct usb_interface *intf,
 	return 0;
 
 err_vdev:
-	v4l2_device_unregister(v4l2_dev);
+	v4l2_device_unregister(&radio->v4l2_dev);
 err_v4l2:
 	kfree(radio->buffer);
 err_nobuf:
-- 
1.6.3.3


--------------050006090900090606050406--
