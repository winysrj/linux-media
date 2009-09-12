Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f172.google.com ([209.85.221.172]:50386 "EHLO
	mail-qy0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754544AbZILOtJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Sep 2009 10:49:09 -0400
Received: by qyk2 with SMTP id 2so1629968qyk.21
        for <linux-media@vger.kernel.org>; Sat, 12 Sep 2009 07:49:12 -0700 (PDT)
Message-ID: <4AABB4E0.2080000@gmail.com>
Date: Sat, 12 Sep 2009 10:49:04 -0400
From: David Ellingsworth <david@identd.dyndns.org>
Reply-To: david@identd.dyndns.org
MIME-Version: 1.0
To: linux-media@vger.kernel.org, klimov.linux@gmail.com
Subject: [RFC/RFT 02/10] radio-mr800: simplify video_device allocation
Content-Type: multipart/mixed;
 boundary="------------000205000107020804060508"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------000205000107020804060508
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

 From 2839cd94e21123151c0fe6683991f5a3c88fa877 Mon Sep 17 00:00:00 2001
From: David Ellingsworth <david@identd.dyndns.org>
Date: Fri, 11 Sep 2009 23:59:22 -0400
Subject: [PATCH 02/10] mr800: simplify video_device allocation

Signed-off-by: David Ellingsworth <david@identd.dyndns.org>
---
 drivers/media/radio/radio-mr800.c |   53 
++++++++++++++----------------------
 1 files changed, 21 insertions(+), 32 deletions(-)

diff --git a/drivers/media/radio/radio-mr800.c 
b/drivers/media/radio/radio-mr800.c
index 8e96c8a..3129692 100644
--- a/drivers/media/radio/radio-mr800.c
+++ b/drivers/media/radio/radio-mr800.c
@@ -129,7 +129,7 @@ static int usb_amradio_resume(struct usb_interface 
*intf);
 struct amradio_device {
     /* reference to USB and video device */
     struct usb_device *usbdev;
-    struct video_device *videodev;
+    struct video_device videodev;
     struct v4l2_device v4l2_dev;
 
     unsigned char *buffer;
@@ -272,7 +272,7 @@ static void usb_amradio_disconnect(struct 
usb_interface *intf)
     mutex_unlock(&radio->lock);
 
     usb_set_intfdata(intf, NULL);
-    video_unregister_device(radio->videodev);
+    video_unregister_device(&radio->videodev);
     v4l2_device_disconnect(&radio->v4l2_dev);
 }
 
@@ -320,7 +320,7 @@ static int vidioc_g_tuner(struct file *file, void *priv,
  */
     retval = amradio_set_stereo(radio, WANT_STEREO);
     if (retval < 0)
-        amradio_dev_warn(&radio->videodev->dev,
+        amradio_dev_warn(&radio->videodev.dev,
             "set stereo failed\n");
 
     strcpy(v->name, "FM");
@@ -366,13 +366,13 @@ static int vidioc_s_tuner(struct file *file, void 
*priv,
     case V4L2_TUNER_MODE_MONO:
         retval = amradio_set_stereo(radio, WANT_MONO);
         if (retval < 0)
-            amradio_dev_warn(&radio->videodev->dev,
+            amradio_dev_warn(&radio->videodev.dev,
                 "set mono failed\n");
         break;
     case V4L2_TUNER_MODE_STEREO:
         retval = amradio_set_stereo(radio, WANT_STEREO);
         if (retval < 0)
-            amradio_dev_warn(&radio->videodev->dev,
+            amradio_dev_warn(&radio->videodev.dev,
                 "set stereo failed\n");
         break;
     default:
@@ -403,7 +403,7 @@ static int vidioc_s_frequency(struct file *file, 
void *priv,
 
     retval = amradio_setfreq(radio, radio->curfreq);
     if (retval < 0)
-        amradio_dev_warn(&radio->videodev->dev,
+        amradio_dev_warn(&radio->videodev.dev,
             "set frequency failed\n");
 
 unlock:
@@ -493,13 +493,13 @@ static int vidioc_s_ctrl(struct file *file, void 
*priv,
         if (ctrl->value) {
             retval = amradio_set_mute(radio, AMRADIO_STOP);
             if (retval < 0) {
-                amradio_dev_warn(&radio->videodev->dev,
+                amradio_dev_warn(&radio->videodev.dev,
                     "amradio_stop failed\n");
             }
         } else {
             retval = amradio_set_mute(radio, AMRADIO_START);
             if (retval < 0) {
-                amradio_dev_warn(&radio->videodev->dev,
+                amradio_dev_warn(&radio->videodev.dev,
                     "amradio_start failed\n");
             }
         }
@@ -565,7 +565,7 @@ static int usb_amradio_open(struct file *file)
 
     retval = amradio_set_mute(radio, AMRADIO_START);
     if (retval < 0) {
-        amradio_dev_warn(&radio->videodev->dev,
+        amradio_dev_warn(&radio->videodev.dev,
             "radio did not start up properly\n");
         radio->users = 0;
         goto unlock;
@@ -573,12 +573,12 @@ static int usb_amradio_open(struct file *file)
 
     retval = amradio_set_stereo(radio, WANT_STEREO);
     if (retval < 0)
-        amradio_dev_warn(&radio->videodev->dev,
+        amradio_dev_warn(&radio->videodev.dev,
             "set stereo failed\n");
 
     retval = amradio_setfreq(radio, radio->curfreq);
     if (retval < 0)
-        amradio_dev_warn(&radio->videodev->dev,
+        amradio_dev_warn(&radio->videodev.dev,
             "set frequency failed\n");
 
 unlock:
@@ -604,7 +604,7 @@ static int usb_amradio_close(struct file *file)
     if (!radio->removed) {
         retval = amradio_set_mute(radio, AMRADIO_STOP);
         if (retval < 0)
-            amradio_dev_warn(&radio->videodev->dev,
+            amradio_dev_warn(&radio->videodev.dev,
                 "amradio_stop failed\n");
     }
 
@@ -676,9 +676,6 @@ static void usb_amradio_video_device_release(struct 
video_device *videodev)
 {
     struct amradio_device *radio = video_get_drvdata(videodev);
 
-    /* we call v4l to free radio->videodev */
-    video_device_release(videodev);
-
     v4l2_device_unregister(&radio->v4l2_dev);
 
     /* free rest memory */
@@ -718,20 +715,12 @@ static int usb_amradio_probe(struct usb_interface 
*intf,
         return retval;
     }
 
-    radio->videodev = video_device_alloc();
-
-    if (!radio->videodev) {
-        dev_err(&intf->dev, "video_device_alloc failed\n");
-        kfree(radio->buffer);
-        kfree(radio);
-        return -ENOMEM;
-    }
-
-    strlcpy(radio->videodev->name, v4l2_dev->name, 
sizeof(radio->videodev->name));
-    radio->videodev->v4l2_dev = v4l2_dev;
-    radio->videodev->fops = &usb_amradio_fops;
-    radio->videodev->ioctl_ops = &usb_amradio_ioctl_ops;
-    radio->videodev->release = usb_amradio_video_device_release;
+    strlcpy(radio->videodev.name, v4l2_dev->name,
+        sizeof(radio->videodev.name));
+    radio->videodev.v4l2_dev = v4l2_dev;
+    radio->videodev.fops = &usb_amradio_fops;
+    radio->videodev.ioctl_ops = &usb_amradio_ioctl_ops;
+    radio->videodev.release = usb_amradio_video_device_release;
 
     radio->removed = 0;
     radio->users = 0;
@@ -741,12 +730,12 @@ static int usb_amradio_probe(struct usb_interface 
*intf,
 
     mutex_init(&radio->lock);
 
-    video_set_drvdata(radio->videodev, radio);
+    video_set_drvdata(&radio->videodev, radio);
 
-    retval = video_register_device(radio->videodev,   
 VFL_TYPE_RADIO,    radio_nr);
+    retval = video_register_device(&radio->videodev, VFL_TYPE_RADIO,
+                    radio_nr);
     if (retval < 0) {
         dev_err(&intf->dev, "could not register video device\n");
-        video_device_release(radio->videodev);
         v4l2_device_unregister(v4l2_dev);
         kfree(radio->buffer);
         kfree(radio);
-- 
1.6.3.3


--------------000205000107020804060508
Content-Type: text/x-diff;
 name="0002-mr800-simplify-video_device-allocation.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0002-mr800-simplify-video_device-allocation.patch"

>From 2839cd94e21123151c0fe6683991f5a3c88fa877 Mon Sep 17 00:00:00 2001
From: David Ellingsworth <david@identd.dyndns.org>
Date: Fri, 11 Sep 2009 23:59:22 -0400
Subject: [PATCH 02/10] mr800: simplify video_device allocation

Signed-off-by: David Ellingsworth <david@identd.dyndns.org>
---
 drivers/media/radio/radio-mr800.c |   53 ++++++++++++++----------------------
 1 files changed, 21 insertions(+), 32 deletions(-)

diff --git a/drivers/media/radio/radio-mr800.c b/drivers/media/radio/radio-mr800.c
index 8e96c8a..3129692 100644
--- a/drivers/media/radio/radio-mr800.c
+++ b/drivers/media/radio/radio-mr800.c
@@ -129,7 +129,7 @@ static int usb_amradio_resume(struct usb_interface *intf);
 struct amradio_device {
 	/* reference to USB and video device */
 	struct usb_device *usbdev;
-	struct video_device *videodev;
+	struct video_device videodev;
 	struct v4l2_device v4l2_dev;
 
 	unsigned char *buffer;
@@ -272,7 +272,7 @@ static void usb_amradio_disconnect(struct usb_interface *intf)
 	mutex_unlock(&radio->lock);
 
 	usb_set_intfdata(intf, NULL);
-	video_unregister_device(radio->videodev);
+	video_unregister_device(&radio->videodev);
 	v4l2_device_disconnect(&radio->v4l2_dev);
 }
 
@@ -320,7 +320,7 @@ static int vidioc_g_tuner(struct file *file, void *priv,
  */
 	retval = amradio_set_stereo(radio, WANT_STEREO);
 	if (retval < 0)
-		amradio_dev_warn(&radio->videodev->dev,
+		amradio_dev_warn(&radio->videodev.dev,
 			"set stereo failed\n");
 
 	strcpy(v->name, "FM");
@@ -366,13 +366,13 @@ static int vidioc_s_tuner(struct file *file, void *priv,
 	case V4L2_TUNER_MODE_MONO:
 		retval = amradio_set_stereo(radio, WANT_MONO);
 		if (retval < 0)
-			amradio_dev_warn(&radio->videodev->dev,
+			amradio_dev_warn(&radio->videodev.dev,
 				"set mono failed\n");
 		break;
 	case V4L2_TUNER_MODE_STEREO:
 		retval = amradio_set_stereo(radio, WANT_STEREO);
 		if (retval < 0)
-			amradio_dev_warn(&radio->videodev->dev,
+			amradio_dev_warn(&radio->videodev.dev,
 				"set stereo failed\n");
 		break;
 	default:
@@ -403,7 +403,7 @@ static int vidioc_s_frequency(struct file *file, void *priv,
 
 	retval = amradio_setfreq(radio, radio->curfreq);
 	if (retval < 0)
-		amradio_dev_warn(&radio->videodev->dev,
+		amradio_dev_warn(&radio->videodev.dev,
 			"set frequency failed\n");
 
 unlock:
@@ -493,13 +493,13 @@ static int vidioc_s_ctrl(struct file *file, void *priv,
 		if (ctrl->value) {
 			retval = amradio_set_mute(radio, AMRADIO_STOP);
 			if (retval < 0) {
-				amradio_dev_warn(&radio->videodev->dev,
+				amradio_dev_warn(&radio->videodev.dev,
 					"amradio_stop failed\n");
 			}
 		} else {
 			retval = amradio_set_mute(radio, AMRADIO_START);
 			if (retval < 0) {
-				amradio_dev_warn(&radio->videodev->dev,
+				amradio_dev_warn(&radio->videodev.dev,
 					"amradio_start failed\n");
 			}
 		}
@@ -565,7 +565,7 @@ static int usb_amradio_open(struct file *file)
 
 	retval = amradio_set_mute(radio, AMRADIO_START);
 	if (retval < 0) {
-		amradio_dev_warn(&radio->videodev->dev,
+		amradio_dev_warn(&radio->videodev.dev,
 			"radio did not start up properly\n");
 		radio->users = 0;
 		goto unlock;
@@ -573,12 +573,12 @@ static int usb_amradio_open(struct file *file)
 
 	retval = amradio_set_stereo(radio, WANT_STEREO);
 	if (retval < 0)
-		amradio_dev_warn(&radio->videodev->dev,
+		amradio_dev_warn(&radio->videodev.dev,
 			"set stereo failed\n");
 
 	retval = amradio_setfreq(radio, radio->curfreq);
 	if (retval < 0)
-		amradio_dev_warn(&radio->videodev->dev,
+		amradio_dev_warn(&radio->videodev.dev,
 			"set frequency failed\n");
 
 unlock:
@@ -604,7 +604,7 @@ static int usb_amradio_close(struct file *file)
 	if (!radio->removed) {
 		retval = amradio_set_mute(radio, AMRADIO_STOP);
 		if (retval < 0)
-			amradio_dev_warn(&radio->videodev->dev,
+			amradio_dev_warn(&radio->videodev.dev,
 				"amradio_stop failed\n");
 	}
 
@@ -676,9 +676,6 @@ static void usb_amradio_video_device_release(struct video_device *videodev)
 {
 	struct amradio_device *radio = video_get_drvdata(videodev);
 
-	/* we call v4l to free radio->videodev */
-	video_device_release(videodev);
-
 	v4l2_device_unregister(&radio->v4l2_dev);
 
 	/* free rest memory */
@@ -718,20 +715,12 @@ static int usb_amradio_probe(struct usb_interface *intf,
 		return retval;
 	}
 
-	radio->videodev = video_device_alloc();
-
-	if (!radio->videodev) {
-		dev_err(&intf->dev, "video_device_alloc failed\n");
-		kfree(radio->buffer);
-		kfree(radio);
-		return -ENOMEM;
-	}
-
-	strlcpy(radio->videodev->name, v4l2_dev->name, sizeof(radio->videodev->name));
-	radio->videodev->v4l2_dev = v4l2_dev;
-	radio->videodev->fops = &usb_amradio_fops;
-	radio->videodev->ioctl_ops = &usb_amradio_ioctl_ops;
-	radio->videodev->release = usb_amradio_video_device_release;
+	strlcpy(radio->videodev.name, v4l2_dev->name,
+		sizeof(radio->videodev.name));
+	radio->videodev.v4l2_dev = v4l2_dev;
+	radio->videodev.fops = &usb_amradio_fops;
+	radio->videodev.ioctl_ops = &usb_amradio_ioctl_ops;
+	radio->videodev.release = usb_amradio_video_device_release;
 
 	radio->removed = 0;
 	radio->users = 0;
@@ -741,12 +730,12 @@ static int usb_amradio_probe(struct usb_interface *intf,
 
 	mutex_init(&radio->lock);
 
-	video_set_drvdata(radio->videodev, radio);
+	video_set_drvdata(&radio->videodev, radio);
 
-	retval = video_register_device(radio->videodev,	VFL_TYPE_RADIO,	radio_nr);
+	retval = video_register_device(&radio->videodev, VFL_TYPE_RADIO,
+					radio_nr);
 	if (retval < 0) {
 		dev_err(&intf->dev, "could not register video device\n");
-		video_device_release(radio->videodev);
 		v4l2_device_unregister(v4l2_dev);
 		kfree(radio->buffer);
 		kfree(radio);
-- 
1.6.3.3


--------------000205000107020804060508--
