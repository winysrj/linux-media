Return-path: <linux-media-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:39763 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676AbZHHRqD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Aug 2009 13:46:03 -0400
Received: by ey-out-2122.google.com with SMTP id 9so676556eyd.37
        for <linux-media@vger.kernel.org>; Sat, 08 Aug 2009 10:46:03 -0700 (PDT)
Subject: [patch review 3/6] radio-mr800: no need to pass curfreq value to
 amradio_setfreq()
From: Alexey Klimov <klimov.linux@gmail.com>
To: Douglas Schilling Landgraf <dougsland@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain
Date: Sat, 08 Aug 2009 21:46:04 +0400
Message-Id: <1249753564.15160.248.camel@tux.localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Small cleanup of amradio_setfreq(). No need to pass radio->curfreq value
to this function.

Signed-off-by: Alexey Klimov <klimov.linux@gmail.com>

--
diff -r 5f3329bebfe4 linux/drivers/media/radio/radio-mr800.c
--- a/linux/drivers/media/radio/radio-mr800.c	Wed Jul 29 12:36:46 2009 +0400
+++ b/linux/drivers/media/radio/radio-mr800.c	Wed Jul 29 12:41:51 2009 +0400
@@ -202,11 +202,11 @@
 }
 
 /* set a frequency, freq is defined by v4l's TUNER_LOW, i.e. 1/16th kHz */
-static int amradio_setfreq(struct amradio_device *radio, int freq)
+static int amradio_setfreq(struct amradio_device *radio)
 {
 	int retval;
 	int size;
-	unsigned short freq_send = 0x10 + (freq >> 3) / 25;
+	unsigned short freq_send = 0x10 + (radio->curfreq >> 3) / 25;
 
 	/* safety check */
 	if (radio->removed)
@@ -413,7 +413,7 @@
 	radio->curfreq = f->frequency;
 	mutex_unlock(&radio->lock);
 
-	retval = amradio_setfreq(radio, radio->curfreq);
+	retval = amradio_setfreq(radio);
 	if (retval < 0)
 		amradio_dev_warn(&radio->videodev->dev,
 			"set frequency failed\n");



-- 
Best regards, Klimov Alexey

