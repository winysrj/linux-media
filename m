Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:56843 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754857AbZE1Uop (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 May 2009 16:44:45 -0400
Received: by fg-out-1718.google.com with SMTP id d23so1612889fga.17
        for <linux-media@vger.kernel.org>; Thu, 28 May 2009 13:44:47 -0700 (PDT)
Subject: [patch review 3/4] dsbr100: no need to pass curfreq value to
 dsbr100_setfreq()
From: Alexey Klimov <klimov.linux@gmail.com>
To: Linux Media <linux-media@vger.kernel.org>
Cc: Douglas Schilling Landgraf <dougsland@gmail.com>
Content-Type: text/plain
Date: Fri, 29 May 2009 00:44:45 +0400
Message-Id: <1243543485.6713.43.camel@tux.localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Small cleanup of dsbr100_setfreq(). No need to pass radio->curfreq value
to this function.

Signed-off-by: Alexey Klimov <klimov.linux@gmail.com>

--
diff -r d7322837a62c linux/drivers/media/radio/dsbr100.c
--- a/linux/drivers/media/radio/dsbr100.c	Tue May 19 15:18:56 2009 +0400
+++ b/linux/drivers/media/radio/dsbr100.c	Tue May 19 15:59:39 2009 +0400
@@ -258,12 +258,12 @@
 }
 
 /* set a frequency, freq is defined by v4l's TUNER_LOW, i.e. 1/16th kHz */
-static int dsbr100_setfreq(struct dsbr100_device *radio, int freq)
+static int dsbr100_setfreq(struct dsbr100_device *radio)
 {
 	int retval;
 	int request;
+	int freq = (radio->curfreq / 16 * 80) / 1000 + 856;
 
-	freq = (freq / 16 * 80) / 1000 + 856;
 	mutex_lock(&radio->lock);
 
 	retval = usb_control_msg(radio->usbdev,
@@ -431,7 +431,7 @@
 	radio->curfreq = f->frequency;
 	mutex_unlock(&radio->lock);
 
-	retval = dsbr100_setfreq(radio, radio->curfreq);
+	retval = dsbr100_setfreq(radio);
 	if (retval < 0)
 		dev_warn(&radio->usbdev->dev, "Set frequency failed\n");
 	return 0;



-- 
Best regards, Klimov Alexey

