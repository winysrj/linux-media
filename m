Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:24249 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755007AbZBDU4O (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Feb 2009 15:56:14 -0500
Received: by fg-out-1718.google.com with SMTP id 16so1346367fgg.17
        for <linux-media@vger.kernel.org>; Wed, 04 Feb 2009 12:56:09 -0800 (PST)
Subject: [patch review 9/8] radio-mr800: fix checking of retval after
 usb_bulk_msg
From: Alexey Klimov <klimov.linux@gmail.com>
To: Douglas Schilling Landgraf <dougsland@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain
Date: Wed, 04 Feb 2009 23:56:13 +0300
Message-Id: <1233780973.2038.254.camel@tux.localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Patch corrects checking of returned value after usb_bulk_msg. Now we
also check if number of transferred bytes equals to BUFFER_LENGTH.

Signed-off-by: Alexey Klimov <klimov.linux@gmail.com>

--
diff -r 2876e91adef9 linux/drivers/media/radio/radio-mr800.c
--- a/linux/drivers/media/radio/radio-mr800.c	Wed Feb 04 21:38:46 2009 +0300
+++ b/linux/drivers/media/radio/radio-mr800.c	Wed Feb 04 22:52:15 2009 +0300
@@ -217,7 +217,7 @@
 	retval = usb_bulk_msg(radio->usbdev, usb_sndintpipe(radio->usbdev, 2),
 		(void *) (radio->buffer), BUFFER_LENGTH, &size, USB_TIMEOUT);
 
-	if (retval) {
+	if (retval < 0 || size != BUFFER_LENGTH) {
 		mutex_unlock(&radio->lock);
 		return retval;
 	}
@@ -254,7 +254,7 @@
 	retval = usb_bulk_msg(radio->usbdev, usb_sndintpipe(radio->usbdev, 2),
 		(void *) (radio->buffer), BUFFER_LENGTH, &size, USB_TIMEOUT);
 
-	if (retval) {
+	if (retval < 0 || size != BUFFER_LENGTH) {
 		mutex_unlock(&radio->lock);
 		return retval;
 	}
@@ -271,7 +271,7 @@
 	retval = usb_bulk_msg(radio->usbdev, usb_sndintpipe(radio->usbdev, 2),
 		(void *) (radio->buffer), BUFFER_LENGTH, &size, USB_TIMEOUT);
 
-	if (retval) {
+	if (retval < 0 || size != BUFFER_LENGTH) {
 		mutex_unlock(&radio->lock);
 		return retval;
 	}



-- 
Best regards, Klimov Alexey

