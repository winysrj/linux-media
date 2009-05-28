Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:56843 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753588AbZE1Uof (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 May 2009 16:44:35 -0400
Received: by fg-out-1718.google.com with SMTP id d23so1612889fga.17
        for <linux-media@vger.kernel.org>; Thu, 28 May 2009 13:44:35 -0700 (PDT)
Subject: [patch review 1/4] dsbr100: remove radio->users counter
From: Alexey Klimov <klimov.linux@gmail.com>
To: Linux Media <linux-media@vger.kernel.org>
Cc: Douglas Schilling Landgraf <dougsland@gmail.com>
Content-Type: text/plain
Date: Fri, 29 May 2009 00:44:33 +0400
Message-Id: <1243543473.6713.41.camel@tux.localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Patch removes radio->users counter because it is not in use.

Signed-off-by: Alexey Klimov <klimov.linux@gmail.com>

--
diff -r 315bc4b65b4f linux/drivers/media/radio/dsbr100.c
--- a/linux/drivers/media/radio/dsbr100.c	Sun May 17 12:28:55 2009 +0000
+++ b/linux/drivers/media/radio/dsbr100.c	Tue May 19 15:05:02 2009 +0400
@@ -146,7 +146,6 @@
 	struct mutex lock;	/* buffer locking */
 	int curfreq;
 	int stereo;
-	int users;
 	int removed;
 	int muted;
 };
@@ -552,14 +551,12 @@
 	int retval;
 
 	lock_kernel();
-	radio->users = 1;
 	radio->muted = 1;
 
 	retval = dsbr100_start(radio);
 	if (retval < 0) {
 		dev_warn(&radio->usbdev->dev,
 			 "Radio did not start up properly\n");
-		radio->users = 0;
 		unlock_kernel();
 		return -EIO;
 	}
@@ -581,10 +578,6 @@
 	if (!radio)
 		return -ENODEV;
 
-	mutex_lock(&radio->lock);
-	radio->users = 0;
-	mutex_unlock(&radio->lock);
-
 	if (!radio->removed) {
 		retval = dsbr100_stop(radio);
 		if (retval < 0) {
@@ -698,7 +691,6 @@
 	mutex_init(&radio->lock);
 
 	radio->removed = 0;
-	radio->users = 0;
 	radio->usbdev = interface_to_usbdev(intf);
 	radio->curfreq = FREQ_MIN * FREQ_MUL;
 


-- 
Best regards, Klimov Alexey

