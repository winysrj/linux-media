Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f172.google.com ([209.85.221.172]:50386 "EHLO
	mail-qy0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754520AbZILOt2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Sep 2009 10:49:28 -0400
Received: by mail-qy0-f172.google.com with SMTP id 2so1629968qyk.21
        for <linux-media@vger.kernel.org>; Sat, 12 Sep 2009 07:49:32 -0700 (PDT)
Message-ID: <4AABB4E8.7030507@gmail.com>
Date: Sat, 12 Sep 2009 10:49:12 -0400
From: David Ellingsworth <david@identd.dyndns.org>
Reply-To: david@identd.dyndns.org
MIME-Version: 1.0
To: linux-media@vger.kernel.org, klimov.linux@gmail.com
Subject: [RFC/RFT 03/10] radio-mr800: simplify error paths in usb probe callback
Content-Type: multipart/mixed;
 boundary="------------030309010907030200000300"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------030309010907030200000300
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

 From 0cdbd79a6e87a8a2862a6c1309c8fdf83c80ba61 Mon Sep 17 00:00:00 2001
From: David Ellingsworth <david@identd.dyndns.org>
Date: Sat, 12 Sep 2009 00:13:16 -0400
Subject: [PATCH 03/10] mr800: simplify error paths in usb probe callback

Signed-off-by: David Ellingsworth <david@identd.dyndns.org>
---
 drivers/media/radio/radio-mr800.c |   27 ++++++++++++++++-----------
 1 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/drivers/media/radio/radio-mr800.c 
b/drivers/media/radio/radio-mr800.c
index 3129692..d01b96c 100644
--- a/drivers/media/radio/radio-mr800.c
+++ b/drivers/media/radio/radio-mr800.c
@@ -689,30 +689,29 @@ static int usb_amradio_probe(struct usb_interface 
*intf,
 {
     struct amradio_device *radio;
     struct v4l2_device *v4l2_dev;
-    int retval;
+    int retval = 0;
 
     radio = kzalloc(sizeof(struct amradio_device), GFP_KERNEL);
 
     if (!radio) {
         dev_err(&intf->dev, "kmalloc for amradio_device failed\n");
-        return -ENOMEM;
+        retval = -ENOMEM;
+        goto err;
     }
 
     radio->buffer = kmalloc(BUFFER_LENGTH, GFP_KERNEL);
 
     if (!radio->buffer) {
         dev_err(&intf->dev, "kmalloc for radio->buffer failed\n");
-        kfree(radio);
-        return -ENOMEM;
+        retval = -ENOMEM;
+        goto err_nobuf;
     }
 
     v4l2_dev = &radio->v4l2_dev;
     retval = v4l2_device_register(&intf->dev, v4l2_dev);
     if (retval < 0) {
         dev_err(&intf->dev, "couldn't register v4l2_device\n");
-        kfree(radio->buffer);
-        kfree(radio);
-        return retval;
+        goto err_v4l2;
     }
 
     strlcpy(radio->videodev.name, v4l2_dev->name,
@@ -736,14 +735,20 @@ static int usb_amradio_probe(struct usb_interface 
*intf,
                     radio_nr);
     if (retval < 0) {
         dev_err(&intf->dev, "could not register video device\n");
-        v4l2_device_unregister(v4l2_dev);
-        kfree(radio->buffer);
-        kfree(radio);
-        return -EIO;
+        goto err_vdev;
     }
 
     usb_set_intfdata(intf, radio);
     return 0;
+
+err_vdev:
+    v4l2_device_unregister(v4l2_dev);
+err_v4l2:
+    kfree(radio->buffer);
+err_nobuf:
+    kfree(radio);
+err:
+    return retval;
 }
 
 static int __init amradio_init(void)
-- 
1.6.3.3


--------------030309010907030200000300
Content-Type: text/x-diff;
 name="0003-mr800-simplify-error-paths-in-usb-probe-callback.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0003-mr800-simplify-error-paths-in-usb-probe-callback.patch"

>From 0cdbd79a6e87a8a2862a6c1309c8fdf83c80ba61 Mon Sep 17 00:00:00 2001
From: David Ellingsworth <david@identd.dyndns.org>
Date: Sat, 12 Sep 2009 00:13:16 -0400
Subject: [PATCH 03/10] mr800: simplify error paths in usb probe callback

Signed-off-by: David Ellingsworth <david@identd.dyndns.org>
---
 drivers/media/radio/radio-mr800.c |   27 ++++++++++++++++-----------
 1 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/drivers/media/radio/radio-mr800.c b/drivers/media/radio/radio-mr800.c
index 3129692..d01b96c 100644
--- a/drivers/media/radio/radio-mr800.c
+++ b/drivers/media/radio/radio-mr800.c
@@ -689,30 +689,29 @@ static int usb_amradio_probe(struct usb_interface *intf,
 {
 	struct amradio_device *radio;
 	struct v4l2_device *v4l2_dev;
-	int retval;
+	int retval = 0;
 
 	radio = kzalloc(sizeof(struct amradio_device), GFP_KERNEL);
 
 	if (!radio) {
 		dev_err(&intf->dev, "kmalloc for amradio_device failed\n");
-		return -ENOMEM;
+		retval = -ENOMEM;
+		goto err;
 	}
 
 	radio->buffer = kmalloc(BUFFER_LENGTH, GFP_KERNEL);
 
 	if (!radio->buffer) {
 		dev_err(&intf->dev, "kmalloc for radio->buffer failed\n");
-		kfree(radio);
-		return -ENOMEM;
+		retval = -ENOMEM;
+		goto err_nobuf;
 	}
 
 	v4l2_dev = &radio->v4l2_dev;
 	retval = v4l2_device_register(&intf->dev, v4l2_dev);
 	if (retval < 0) {
 		dev_err(&intf->dev, "couldn't register v4l2_device\n");
-		kfree(radio->buffer);
-		kfree(radio);
-		return retval;
+		goto err_v4l2;
 	}
 
 	strlcpy(radio->videodev.name, v4l2_dev->name,
@@ -736,14 +735,20 @@ static int usb_amradio_probe(struct usb_interface *intf,
 					radio_nr);
 	if (retval < 0) {
 		dev_err(&intf->dev, "could not register video device\n");
-		v4l2_device_unregister(v4l2_dev);
-		kfree(radio->buffer);
-		kfree(radio);
-		return -EIO;
+		goto err_vdev;
 	}
 
 	usb_set_intfdata(intf, radio);
 	return 0;
+
+err_vdev:
+	v4l2_device_unregister(v4l2_dev);
+err_v4l2:
+	kfree(radio->buffer);
+err_nobuf:
+	kfree(radio);
+err:
+	return retval;
 }
 
 static int __init amradio_init(void)
-- 
1.6.3.3


--------------030309010907030200000300--
