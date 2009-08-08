Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f214.google.com ([209.85.219.214]:51190 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752729AbZHHRqL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Aug 2009 13:46:11 -0400
Received: by mail-ew0-f214.google.com with SMTP id 10so2174216ewy.37
        for <linux-media@vger.kernel.org>; Sat, 08 Aug 2009 10:46:11 -0700 (PDT)
Subject: [patch review 5/6] radio-mr800: update suspend/resume procedure
From: Alexey Klimov <klimov.linux@gmail.com>
To: Douglas Schilling Landgraf <dougsland@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain
Date: Sat, 08 Aug 2009 21:46:12 +0400
Message-Id: <1249753572.15160.250.camel@tux.localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Patch fixes suspend/resume procedure.

Signed-off-by: Alexey Klimov <klimov.linux@gmail.com>

--
diff -r 05754a500f80 linux/drivers/media/radio/radio-mr800.c
--- a/linux/drivers/media/radio/radio-mr800.c	Sat Aug 08 20:06:36 2009 +0400
+++ b/linux/drivers/media/radio/radio-mr800.c	Sat Aug 08 20:22:05 2009 +0400
@@ -564,11 +564,23 @@
 static int usb_amradio_suspend(struct usb_interface *intf, pm_message_t message)
 {
 	struct amradio_device *radio = usb_get_intfdata(intf);
-	int retval;
 
-	retval = amradio_set_mute(radio, AMRADIO_STOP);
-	if (retval < 0)
-		dev_warn(&intf->dev, "amradio_stop failed\n");
+	if (radio->status == AMRADIO_START) {
+		int retval;
+		retval = amradio_set_mute(radio, AMRADIO_STOP);
+		if (retval < 0)
+			dev_warn(&intf->dev, "amradio_stop failed\n");
+
+		/* After stopping radio status set to AMRADIO_STOP.
+		 * If we want driver to start radio on resume
+		 * we set status equal to AMRADIO_START.
+		 * On resume we will check status and run radio if needed.
+		 */
+
+		mutex_lock(&radio->lock);
+		radio->status = AMRADIO_START;
+		mutex_unlock(&radio->lock);
+	}
 
 	dev_info(&intf->dev, "going into suspend..\n");
 
@@ -579,11 +591,24 @@
 static int usb_amradio_resume(struct usb_interface *intf)
 {
 	struct amradio_device *radio = usb_get_intfdata(intf);
-	int retval;
 
-	retval = amradio_set_mute(radio, AMRADIO_START);
-	if (retval < 0)
-		dev_warn(&intf->dev, "amradio_start failed\n");
+	if (radio->status == AMRADIO_START) {
+		int retval;
+		retval = amradio_set_mute(radio, AMRADIO_START);
+		if (retval < 0)
+			dev_warn(&intf->dev, "amradio_start failed\n");
+		retval = amradio_setfreq(radio);
+		if (retval < 0)
+			dev_warn(&intf->dev,
+				"set frequency failed\n");
+
+		if (radio->stereo) {
+			retval = amradio_set_stereo(radio, WANT_STEREO);
+			if (retval < 0)
+			dev_warn(&intf->dev, "set stereo failed\n");
+		}
+
+	}
 
 	dev_info(&intf->dev, "coming out of suspend..\n");
 


-- 
Best regards, Klimov Alexey

