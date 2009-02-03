Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:44655 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752918AbZBCBIU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Feb 2009 20:08:20 -0500
Received: by fg-out-1718.google.com with SMTP id 16so763430fgg.17
        for <linux-media@vger.kernel.org>; Mon, 02 Feb 2009 17:08:19 -0800 (PST)
Subject: [patch review 3/8] radio-mr800: add more dev_err messages in probe
From: Alexey Klimov <klimov.linux@gmail.com>
To: Douglas Schilling Landgraf <dougsland@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain
Date: Tue, 03 Feb 2009 04:08:16 +0300
Message-Id: <1233623296.17456.255.camel@tux.localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Patch adds 3 dev_err messages in usb_amradio_probe() function.

Signed-off-by: Alexey Klimov <klimov.linux@gmail.com>

--
diff -r c9f51bda84de linux/drivers/media/radio/radio-mr800.c
--- a/linux/drivers/media/radio/radio-mr800.c	Mon Feb 02 02:53:50 2009 +0300
+++ b/linux/drivers/media/radio/radio-mr800.c	Mon Feb 02 03:08:13 2009 +0300
@@ -641,19 +641,23 @@
 
 	radio = kmalloc(sizeof(struct amradio_device), GFP_KERNEL);
 
-	if (!radio)
+	if (!radio) {
+		dev_err(&intf->dev, "kmalloc for amradio_device failed\n");
 		return -ENOMEM;
+	}
 
 	radio->buffer = kmalloc(BUFFER_LENGTH, GFP_KERNEL);
 
-	if (!(radio->buffer)) {
+	if (!radio->buffer) {
+		dev_err(&intf->dev, "kmalloc for radio->buffer failed\n");
 		kfree(radio);
 		return -ENOMEM;
 	}
 
 	radio->videodev = video_device_alloc();
 
-	if (!(radio->videodev)) {
+	if (!radio->videodev) {
+		dev_err(&intf->dev, "video_device_alloc failed\n");
 		kfree(radio->buffer);
 		kfree(radio);
 		return -ENOMEM;


-- 
Best regards, Klimov Alexey

