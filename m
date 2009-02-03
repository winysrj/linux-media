Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:44655 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752918AbZBCBIJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Feb 2009 20:08:09 -0500
Received: by fg-out-1718.google.com with SMTP id 16so763430fgg.17
        for <linux-media@vger.kernel.org>; Mon, 02 Feb 2009 17:08:07 -0800 (PST)
Subject: [patch review 2/8] radio-mr800: place dev_err instead of dev_warn
From: Alexey Klimov <klimov.linux@gmail.com>
To: Douglas Schilling Landgraf <dougsland@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain
Date: Tue, 03 Feb 2009 04:08:02 +0300
Message-Id: <1233623282.17456.254.camel@tux.localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There should be dev_err message if video_register_device() fails.
Correct this situation.

Signed-off-by: Alexey Klimov <klimov.linux@gmail.com>

--
diff -r ed1aa70cfdfa linux/drivers/media/radio/radio-mr800.c
--- a/linux/drivers/media/radio/radio-mr800.c	Mon Feb 02 02:29:52 2009 +0300
+++ b/linux/drivers/media/radio/radio-mr800.c	Mon Feb 02 02:52:52 2009 +0300
@@ -672,7 +672,7 @@
 	video_set_drvdata(radio->videodev, radio);
 	retval = video_register_device(radio->videodev,	VFL_TYPE_RADIO,	radio_nr);
 	if (retval < 0) {
-		dev_warn(&intf->dev, "could not register video device\n");
+		dev_err(&intf->dev, "could not register video device\n");
 		video_device_release(radio->videodev);
 		kfree(radio->buffer);
 		kfree(radio);


-- 
Best regards, Klimov Alexey

