Return-path: <linux-media-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:39763 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680AbZHHRqG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Aug 2009 13:46:06 -0400
Received: by ey-out-2122.google.com with SMTP id 9so676556eyd.37
        for <linux-media@vger.kernel.org>; Sat, 08 Aug 2009 10:46:07 -0700 (PDT)
Subject: [patch review 4/6] radio-mr800: make radio->status variable
From: Alexey Klimov <klimov.linux@gmail.com>
To: Douglas Schilling Landgraf <dougsland@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain
Date: Sat, 08 Aug 2009 21:46:08 +0400
Message-Id: <1249753568.15160.249.camel@tux.localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove radio->muted and radio->removed variables from amradio_device
structure. Instead patch creates radio->status variable and updates
code.

Signed-off-by: Alexey Klimov <klimov.linux@gmail.com>

--
diff -r a1ccdea5a182 linux/drivers/media/radio/radio-mr800.c
--- a/linux/drivers/media/radio/radio-mr800.c	Wed Jul 29 12:42:06 2009 +0400
+++ b/linux/drivers/media/radio/radio-mr800.c	Sat Aug 08 17:24:05 2009 +0400
@@ -108,6 +108,8 @@
 #define AMRADIO_START		0x00
 #define AMRADIO_STOP		0x01
 
+#define DISCONNECTED		-1
+
 /* Comfortable defines for amradio_set_stereo */
 #define WANT_STEREO		0x00
 #define WANT_MONO		0x01
@@ -135,11 +137,10 @@
 
 	unsigned char *buffer;
 	struct mutex lock;	/* buffer locking */
+	int status;
 	int curfreq;
 	int stereo;
 	int users;
-	int removed;
-	int muted;
 };
 
 /* USB Device ID List */
@@ -172,7 +173,7 @@
 	int size;
 
 	/* safety check */
-	if (radio->removed)
+	if (unlikely(radio->status == DISCONNECTED))
 		return -EIO;
 
 	mutex_lock(&radio->lock);
@@ -194,7 +195,7 @@
 		return retval;
 	}
 
-	radio->muted = argument;
+	radio->status = argument;
 
 	mutex_unlock(&radio->lock);
 
@@ -209,7 +210,7 @@
 	unsigned short freq_send = 0x10 + (radio->curfreq >> 3) / 25;
 
 	/* safety check */
-	if (radio->removed)
+	if (unlikely(radio->status == DISCONNECTED))
 		return -EIO;
 
 	mutex_lock(&radio->lock);
@@ -259,7 +260,7 @@
 	int size;
 
 	/* safety check */
-	if (radio->removed)
+	if (unlikely(radio->status == DISCONNECTED))
 		return -EIO;
 
 	mutex_lock(&radio->lock);
@@ -299,7 +300,7 @@
 	struct amradio_device *radio = usb_get_intfdata(intf);
 
 	mutex_lock(&radio->lock);
-	radio->removed = 1;
+	radio->status = DISCONNECTED;
 	mutex_unlock(&radio->lock);
 
 	usb_set_intfdata(intf, NULL);
@@ -329,7 +330,7 @@
 	int retval;
 
 	/* safety check */
-	if (radio->removed)
+	if (unlikely(radio->status == DISCONNECTED))
 		return -EIO;
 
 	if (v->index > 0)
@@ -371,7 +372,7 @@
 	int retval;
 
 	/* safety check */
-	if (radio->removed)
+	if (unlikely(radio->status == DISCONNECTED))
 		return -EIO;
 
 	if (v->index > 0)
@@ -406,7 +407,7 @@
 	int retval;
 
 	/* safety check */
-	if (radio->removed)
+	if (unlikely(radio->status == DISCONNECTED))
 		return -EIO;
 
 	mutex_lock(&radio->lock);
@@ -427,7 +428,7 @@
 	struct amradio_device *radio = video_get_drvdata(video_devdata(file));
 
 	/* safety check */
-	if (radio->removed)
+	if (unlikely(radio->status == DISCONNECTED))
 		return -EIO;
 
 	f->type = V4L2_TUNER_RADIO;
@@ -454,12 +455,12 @@
 	struct amradio_device *radio = video_get_drvdata(video_devdata(file));
 
 	/* safety check */
-	if (radio->removed)
+	if (unlikely(radio->status == DISCONNECTED))
 		return -EIO;
 
 	switch (ctrl->id) {
 	case V4L2_CID_AUDIO_MUTE:
-		ctrl->value = radio->muted;
+		ctrl->value = radio->status;
 		return 0;
 	}
 	return -EINVAL;
@@ -473,7 +474,7 @@
 	int retval;
 
 	/* safety check */
-	if (radio->removed)
+	if (unlikely(radio->status == DISCONNECTED))
 		return -EIO;
 
 	switch (ctrl->id) {
@@ -540,7 +541,6 @@
 	struct amradio_device *radio = video_get_drvdata(video_devdata(file));
 
 	radio->users = 1;
-	radio->muted = 1;
 
 	return 0;
 }
@@ -674,7 +674,7 @@
 	radio->videodev->ioctl_ops = &usb_amradio_ioctl_ops;
 	radio->videodev->release = usb_amradio_video_device_release;
 
-	radio->removed = 0;
+	radio->status = AMRADIO_STOP;
 	radio->users = 0;
 	radio->usbdev = interface_to_usbdev(intf);
 	radio->curfreq = 95.16 * FREQ_MUL;


-- 
Best regards, Klimov Alexey

