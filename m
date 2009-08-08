Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f214.google.com ([209.85.219.214]:58910 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802AbZHHRpe (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Aug 2009 13:45:34 -0400
Received: by ewy10 with SMTP id 10so2174232ewy.37
        for <linux-media@vger.kernel.org>; Sat, 08 Aug 2009 10:45:34 -0700 (PDT)
Subject: [patch review 1/6] radio-mr800: remove redundant lock/unlock_kernel
From: Alexey Klimov <klimov.linux@gmail.com>
To: Douglas Schilling Landgraf <dougsland@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain
Date: Sat, 08 Aug 2009 21:45:33 +0400
Message-Id: <1249753533.15160.241.camel@tux.localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove redundant lock/unlock_kernel() calls from usb_amradio_open/close
functions.

Signed-off-by: Alexey Klimov <klimov.linux@gmail.com>

--
diff -r ee6cf88cb5d3 linux/drivers/media/radio/radio-mr800.c
--- a/linux/drivers/media/radio/radio-mr800.c	Wed Jul 29 01:42:02 2009 -0300
+++ b/linux/drivers/media/radio/radio-mr800.c	Wed Jul 29 10:44:02 2009 +0400
@@ -540,8 +540,6 @@
 	struct amradio_device *radio = video_get_drvdata(video_devdata(file));
 	int retval;
 
-	lock_kernel();
-
 	radio->users = 1;
 	radio->muted = 1;
 
@@ -550,7 +548,6 @@
 		amradio_dev_warn(&radio->videodev->dev,
 			"radio did not start up properly\n");
 		radio->users = 0;
-		unlock_kernel();
 		return -EIO;
 	}
 
@@ -564,7 +561,6 @@
 		amradio_dev_warn(&radio->videodev->dev,
 			"set frequency failed\n");
 
-	unlock_kernel();
 	return 0;
 }
 


-- 
Best regards, Klimov Alexey

