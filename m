Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f214.google.com ([209.85.219.214]:51190 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752716AbZHHRqO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Aug 2009 13:46:14 -0400
Received: by mail-ew0-f214.google.com with SMTP id 10so2174216ewy.37
        for <linux-media@vger.kernel.org>; Sat, 08 Aug 2009 10:46:15 -0700 (PDT)
Subject: [patch review 6/6] radio-mr800: redesign radio->users counter
From: Alexey Klimov <klimov.linux@gmail.com>
To: Douglas Schilling Landgraf <dougsland@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain
Date: Sat, 08 Aug 2009 21:46:16 +0400
Message-Id: <1249753576.15160.251.camel@tux.localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Redesign radio->users counter. Don't allow more that 5 users on radio in
usb_amradio_open() and don't stop radio device if other userspace
application uses it in usb_amradio_close().

Signed-off-by: Alexey Klimov <klimov.linux@gmail.com>

--
diff -r c2dd9da28106 linux/drivers/media/radio/radio-mr800.c
--- a/linux/drivers/media/radio/radio-mr800.c	Sat Aug 08 17:28:18 2009 +0400
+++ b/linux/drivers/media/radio/radio-mr800.c	Sat Aug 08 18:12:01 2009 +0400
@@ -540,7 +540,13 @@
 {
 	struct amradio_device *radio = video_get_drvdata(video_devdata(file));
 
-	radio->users = 1;
+	/* don't allow more than 5 users on radio */
+	if (radio->users > 4)
+		return -EBUSY;
+
+	mutex_lock(&radio->lock);
+	radio->users++;
+	mutex_unlock(&radio->lock);
 
 	return 0;
 }
@@ -554,9 +560,20 @@
 		return -ENODEV;
 
 	mutex_lock(&radio->lock);
-	radio->users = 0;
+	radio->users--;
 	mutex_unlock(&radio->lock);
 
+	/* In case several userspace applications opened the radio
+	 * and one of them closes and stops it,
+	 * we check if others use it and if they do we start the radio again. */
+	if (radio->users && radio->status == AMRADIO_STOP) {
+		int retval;
+		retval = amradio_set_mute(radio, AMRADIO_START);
+		if (retval < 0)
+			dev_warn(&radio->videodev->dev,
+				"amradio_start failed\n");
+	}
+
 	return 0;
 }
 


-- 
Best regards, Klimov Alexey

