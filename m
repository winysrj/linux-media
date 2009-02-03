Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:44655 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753614AbZBCBJE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Feb 2009 20:09:04 -0500
Received: by fg-out-1718.google.com with SMTP id 16so763430fgg.17
        for <linux-media@vger.kernel.org>; Mon, 02 Feb 2009 17:09:04 -0800 (PST)
Subject: [patch review 7/8] radio-mr800: add few lost mutex locks
From: Alexey Klimov <klimov.linux@gmail.com>
To: Douglas Schilling Landgraf <dougsland@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain
Date: Tue, 03 Feb 2009 04:09:00 +0300
Message-Id: <1233623340.17456.263.camel@tux.localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Patch adds two lost mutex locks.

Signed-off-by: Alexey Klimov <klimov.linux@gmail.com>

--
diff -r 5f3bbcc00bcf linux/drivers/media/radio/radio-mr800.c
--- a/linux/drivers/media/radio/radio-mr800.c	Tue Feb 03 03:05:09 2009 +0300
+++ b/linux/drivers/media/radio/radio-mr800.c	Tue Feb 03 03:06:20 2009 +0300
@@ -434,7 +434,10 @@
 	if (radio->removed)
 		return -EIO;
 
+	mutex_lock(&radio->lock);
 	radio->curfreq = f->frequency;
+	mutex_unlock(&radio->lock);
+
 	retval = amradio_setfreq(radio, radio->curfreq);
 	if (retval < 0)
 		amradio_dev_warn(&radio->videodev->dev,
@@ -602,7 +605,9 @@
 	if (!radio)
 		return -ENODEV;
 
+	mutex_lock(&radio->lock);
 	radio->users = 0;
+	mutex_unlock(&radio->lock);
 
 	if (!radio->removed) {
 		retval = amradio_set_mute(radio, AMRADIO_STOP);


-- 
Best regards, Klimov Alexey

