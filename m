Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f214.google.com ([209.85.219.214]:51190 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809AbZHHRp7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Aug 2009 13:45:59 -0400
Received: by mail-ew0-f214.google.com with SMTP id 10so2174216ewy.37
        for <linux-media@vger.kernel.org>; Sat, 08 Aug 2009 10:46:00 -0700 (PDT)
Subject: [patch review 2/6] radio-mr800: cleanup of usb_amradio_open/close
From: Alexey Klimov <klimov.linux@gmail.com>
To: Douglas Schilling Landgraf <dougsland@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain
Date: Sat, 08 Aug 2009 21:46:00 +0400
Message-Id: <1249753560.15160.247.camel@tux.localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Patch removes functions that shouldn't be in usb_amradio_open/close:
amradio_set_mute(), amradio_set_stereo(), amradio_setfreq().

Signed-off-by: Alexey Klimov <klimov.linux@gmail.com>

--
diff -r 34b4e5c9d5c2 linux/drivers/media/radio/radio-mr800.c
--- a/linux/drivers/media/radio/radio-mr800.c	Wed Jul 29 10:44:51 2009 +0400
+++ b/linux/drivers/media/radio/radio-mr800.c	Wed Jul 29 12:36:37 2009 +0400
@@ -538,29 +538,10 @@
 static int usb_amradio_open(struct file *file)
 {
 	struct amradio_device *radio = video_get_drvdata(video_devdata(file));
-	int retval;
 
 	radio->users = 1;
 	radio->muted = 1;
 
-	retval = amradio_set_mute(radio, AMRADIO_START);
-	if (retval < 0) {
-		amradio_dev_warn(&radio->videodev->dev,
-			"radio did not start up properly\n");
-		radio->users = 0;
-		return -EIO;
-	}
-
-	retval = amradio_set_stereo(radio, WANT_STEREO);
-	if (retval < 0)
-		amradio_dev_warn(&radio->videodev->dev,
-			"set stereo failed\n");
-
-	retval = amradio_setfreq(radio, radio->curfreq);
-	if (retval < 0)
-		amradio_dev_warn(&radio->videodev->dev,
-			"set frequency failed\n");
-
 	return 0;
 }
 
@@ -568,7 +549,6 @@
 static int usb_amradio_close(struct file *file)
 {
 	struct amradio_device *radio = video_get_drvdata(video_devdata(file));
-	int retval;
 
 	if (!radio)
 		return -ENODEV;
@@ -577,13 +557,6 @@
 	radio->users = 0;
 	mutex_unlock(&radio->lock);
 
-	if (!radio->removed) {
-		retval = amradio_set_mute(radio, AMRADIO_STOP);
-		if (retval < 0)
-			amradio_dev_warn(&radio->videodev->dev,
-				"amradio_stop failed\n");
-	}
-
 	return 0;
 }
 


-- 
Best regards, Klimov Alexey

