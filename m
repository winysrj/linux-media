Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.155]:39192 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752672AbZBHN2W (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Feb 2009 08:28:22 -0500
Received: by fg-out-1718.google.com with SMTP id 16so881205fgg.17
        for <linux-media@vger.kernel.org>; Sun, 08 Feb 2009 05:28:20 -0800 (PST)
Subject: [patch] dsbr100: add few lost mutex locks
From: Alexey Klimov <klimov.linux@gmail.com>
To: Douglas Schilling Landgraf <dougsland@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain
Date: Sun, 08 Feb 2009 16:28:27 +0300
Message-Id: <1234099707.10910.2.camel@tux.localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Patch adds two lost mutex locks.

Signed-off-by: Alexey Klimov <klimov.linux@gmail.com>

--
diff -r 71e5a36634ea linux/drivers/media/radio/dsbr100.c
--- a/linux/drivers/media/radio/dsbr100.c	Mon Feb 02 10:33:31 2009 +0100
+++ b/linux/drivers/media/radio/dsbr100.c	Sun Feb 08 16:24:34 2009 +0300
@@ -455,7 +455,10 @@
 	if (radio->removed)
 		return -EIO;
 
+	mutex_lock(&radio->lock);
 	radio->curfreq = f->frequency;
+	mutex_unlock(&radio->lock);
+
 	retval = dsbr100_setfreq(radio, radio->curfreq);
 	if (retval < 0)
 		dev_warn(&radio->usbdev->dev, "Set frequency failed\n");
@@ -606,7 +609,10 @@
 	if (!radio)
 		return -ENODEV;
 
+	mutex_lock(&radio->lock);
 	radio->users = 0;
+	mutex_unlock(&radio->lock);
+
 	if (!radio->removed) {
 		retval = dsbr100_stop(radio);
 		if (retval < 0) {



-- 
Best regards, Klimov Alexey

