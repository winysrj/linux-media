Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f185.google.com ([209.85.221.185]:34967 "EHLO
	mail-qy0-f185.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754131AbZIMD3i (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Sep 2009 23:29:38 -0400
Received: by mail-qy0-f185.google.com with SMTP id 15so1729687qyk.15
        for <linux-media@vger.kernel.org>; Sat, 12 Sep 2009 20:29:41 -0700 (PDT)
Message-ID: <4AAC659C.8040004@gmail.com>
Date: Sat, 12 Sep 2009 23:23:08 -0400
From: David Ellingsworth <david@identd.dyndns.org>
Reply-To: david@identd.dyndns.org
MIME-Version: 1.0
To: linux-media@vger.kernel.org, klimov.linux@gmail.com
Subject: [RFC/RFT 13/14] radio-mr800: simplify device warnings
Content-Type: multipart/mixed;
 boundary="------------060005090205080303030506"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060005090205080303030506
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

 From 8c441616f67011244cb15bc1a3dda6fd8706ecd2 Mon Sep 17 00:00:00 2001
From: David Ellingsworth <david@identd.dyndns.org>
Date: Sat, 12 Sep 2009 16:04:44 -0400
Subject: [PATCH 08/14] mr800: fix potential use after free

Signed-off-by: David Ellingsworth <david@identd.dyndns.org>
---
 drivers/media/radio/radio-mr800.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/media/radio/radio-mr800.c 
b/drivers/media/radio/radio-mr800.c
index 9fd2342..87b58e3 100644
--- a/drivers/media/radio/radio-mr800.c
+++ b/drivers/media/radio/radio-mr800.c
@@ -274,7 +274,6 @@ static void usb_amradio_disconnect(struct 
usb_interface *intf)
 
     usb_set_intfdata(intf, NULL);
     video_unregister_device(&radio->videodev);
-    v4l2_device_disconnect(&radio->v4l2_dev);
 }
 
 /* vidioc_querycap - query device capabilities */
-- 
1.6.3.3


--------------060005090205080303030506
Content-Type: text/x-diff;
 name="0013-mr800-simplify-device-warnings.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0013-mr800-simplify-device-warnings.patch"

>From af0aeff199bfba73db6cfcf540936c4c9279aad1 Mon Sep 17 00:00:00 2001
From: David Ellingsworth <david@identd.dyndns.org>
Date: Sat, 12 Sep 2009 22:03:16 -0400
Subject: [PATCH 13/14] mr800: simplify device warnings

Signed-off-by: David Ellingsworth <david@identd.dyndns.org>
---
 drivers/media/radio/radio-mr800.c |   78 ++++++++++++------------------------
 1 files changed, 26 insertions(+), 52 deletions(-)

diff --git a/drivers/media/radio/radio-mr800.c b/drivers/media/radio/radio-mr800.c
index ed734bb..4d955aa 100644
--- a/drivers/media/radio/radio-mr800.c
+++ b/drivers/media/radio/radio-mr800.c
@@ -186,8 +186,10 @@ static int amradio_set_mute(struct amradio_device *radio, char argument)
 	retval = usb_bulk_msg(radio->usbdev, usb_sndintpipe(radio->usbdev, 2),
 		(void *) (radio->buffer), BUFFER_LENGTH, &size, USB_TIMEOUT);
 
-	if (retval < 0 || size != BUFFER_LENGTH)
+	if (retval < 0 || size != BUFFER_LENGTH) {
+		amradio_dev_warn(&radio->videodev.dev, "set mute failed\n");
 		return retval;
+	}
 
 	radio->muted = argument;
 
@@ -216,7 +218,7 @@ static int amradio_setfreq(struct amradio_device *radio, int freq)
 		(void *) (radio->buffer), BUFFER_LENGTH, &size, USB_TIMEOUT);
 
 	if (retval < 0 || size != BUFFER_LENGTH)
-		return retval;
+		goto out_err;
 
 	/* frequency is calculated from freq_send and placed in first 2 bytes */
 	radio->buffer[0] = (freq_send >> 8) & 0xff;
@@ -230,6 +232,14 @@ static int amradio_setfreq(struct amradio_device *radio, int freq)
 	retval = usb_bulk_msg(radio->usbdev, usb_sndintpipe(radio->usbdev, 2),
 		(void *) (radio->buffer), BUFFER_LENGTH, &size, USB_TIMEOUT);
 
+	if (retval < 0 || size != BUFFER_LENGTH)
+		goto out_err;
+
+	goto out;
+
+out_err:
+	amradio_dev_warn(&radio->videodev.dev, "set frequency failed\n");
+out:
 	return retval;
 }
 
@@ -252,8 +262,10 @@ static int amradio_set_stereo(struct amradio_device *radio, char argument)
 	retval = usb_bulk_msg(radio->usbdev, usb_sndintpipe(radio->usbdev, 2),
 		(void *) (radio->buffer), BUFFER_LENGTH, &size, USB_TIMEOUT);
 
-	if (retval < 0 || size != BUFFER_LENGTH)
+	if (retval < 0 || size != BUFFER_LENGTH) {
+		amradio_dev_warn(&radio->videodev.dev, "set stereo failed\n");
 		return retval;
+	}
 
 	if (argument == WANT_STEREO)
 		radio->stereo = 1;
@@ -313,9 +325,6 @@ static int vidioc_g_tuner(struct file *file, void *priv,
  * amradio_set_stereo shouldn't be here
  */
 	retval = amradio_set_stereo(radio, WANT_STEREO);
-	if (retval < 0)
-		amradio_dev_warn(&radio->videodev.dev,
-			"set stereo failed\n");
 
 	strcpy(v->name, "FM");
 	v->type = V4L2_TUNER_RADIO;
@@ -347,15 +356,9 @@ static int vidioc_s_tuner(struct file *file, void *priv,
 	switch (v->audmode) {
 	case V4L2_TUNER_MODE_MONO:
 		retval = amradio_set_stereo(radio, WANT_MONO);
-		if (retval < 0)
-			amradio_dev_warn(&radio->videodev.dev,
-				"set mono failed\n");
 		break;
 	case V4L2_TUNER_MODE_STEREO:
 		retval = amradio_set_stereo(radio, WANT_STEREO);
-		if (retval < 0)
-			amradio_dev_warn(&radio->videodev.dev,
-				"set stereo failed\n");
 		break;
 	}
 
@@ -372,9 +375,6 @@ static int vidioc_s_frequency(struct file *file, void *priv,
 	radio->curfreq = f->frequency;
 
 	retval = amradio_setfreq(radio, radio->curfreq);
-	if (retval < 0)
-		amradio_dev_warn(&radio->videodev.dev,
-			"set frequency failed\n");
 
 	return retval;
 }
@@ -427,19 +427,11 @@ static int vidioc_s_ctrl(struct file *file, void *priv,
 
 	switch (ctrl->id) {
 	case V4L2_CID_AUDIO_MUTE:
-		if (ctrl->value) {
+		if (ctrl->value)
 			retval = amradio_set_mute(radio, AMRADIO_STOP);
-			if (retval < 0) {
-				amradio_dev_warn(&radio->videodev.dev,
-					"amradio_stop failed\n");
-			}
-		} else {
+		else
 			retval = amradio_set_mute(radio, AMRADIO_START);
-			if (retval < 0) {
-				amradio_dev_warn(&radio->videodev.dev,
-					"amradio_start failed\n");
-			}
-		}
+
 		break;
 	}
 
@@ -487,16 +479,12 @@ static int usb_amradio_init(struct amradio_device *radio)
 	int retval;
 
 	retval = amradio_set_mute(radio, AMRADIO_STOP);
-	if (retval < 0) {
-		amradio_dev_warn(&radio->videodev.dev, "amradio_stop failed\n");
+	if (retval)
 		goto out_err;
-	}
 
 	retval = amradio_set_stereo(radio, WANT_STEREO);
-	if (retval < 0) {
-		amradio_dev_warn(&radio->videodev.dev, "set stereo failed\n");
+	if (retval)
 		goto out_err;
-	}
 
 	radio->initialized = 1;
 	goto out;
@@ -569,14 +557,11 @@ unlock:
 static int usb_amradio_suspend(struct usb_interface *intf, pm_message_t message)
 {
 	struct amradio_device *radio = usb_get_intfdata(intf);
-	int retval;
 
 	mutex_lock(&radio->lock);
 
 	if (!radio->muted && radio->initialized) {
-		retval = amradio_set_mute(radio, AMRADIO_STOP);
-		if (retval < 0)
-			dev_warn(&intf->dev, "amradio_stop failed\n");
+		amradio_set_mute(radio, AMRADIO_STOP);
 		radio->muted = 0;
 	}
 
@@ -590,7 +575,6 @@ static int usb_amradio_suspend(struct usb_interface *intf, pm_message_t message)
 static int usb_amradio_resume(struct usb_interface *intf)
 {
 	struct amradio_device *radio = usb_get_intfdata(intf);
-	int retval;
 
 	mutex_lock(&radio->lock);
 
@@ -598,24 +582,14 @@ static int usb_amradio_resume(struct usb_interface *intf)
 		goto unlock;
 
 	if (radio->stereo)
-		retval = amradio_set_stereo(radio, WANT_STEREO);
+		amradio_set_stereo(radio, WANT_STEREO);
 	else
-		retval = amradio_set_stereo(radio, WANT_MONO);
+		amradio_set_stereo(radio, WANT_MONO);
 
-	if (retval < 0)
-		amradio_dev_warn(&radio->videodev.dev, "set stereo failed\n");
+	amradio_setfreq(radio, radio->curfreq);
 
-	retval = amradio_setfreq(radio, radio->curfreq);
-	if (retval < 0)
-		amradio_dev_warn(&radio->videodev.dev,
-			"set frequency failed\n");
-
-	if (!radio->muted) {
-		retval = amradio_set_mute(radio, AMRADIO_START);
-		if (retval < 0)
-			dev_warn(&radio->videodev.dev,
-				"amradio_start failed\n");
-	}
+	if (!radio->muted)
+		amradio_set_mute(radio, AMRADIO_START);
 
 unlock:
 	dev_info(&intf->dev, "coming out of suspend..\n");
-- 
1.6.3.3


--------------060005090205080303030506--
