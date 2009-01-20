Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:6896 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756834AbZATWSO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Jan 2009 17:18:14 -0500
Received: by fg-out-1718.google.com with SMTP id 19so1662856fgg.17
        for <linux-media@vger.kernel.org>; Tue, 20 Jan 2009 14:18:12 -0800 (PST)
Subject: [PATCH] v4l/dvb: use usb_make_path in usb-radio drivers
From: Alexey Klimov <klimov.linux@gmail.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Douglas Schilling Landgraf <dougsland@gmail.com>,
	Tobias Lorenz <tobias.lorenz@gmx.net>
Content-Type: text/plain
Date: Wed, 21 Jan 2009 01:18:26 +0300
Message-Id: <1232489906.30506.10.camel@tux.localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Place usb_make_path in dsbr100.c, radio-mr800.c, radio-si470x.c that
used when reporting bus_info information in vidioc_querycap.


Signed-off-by: Alexey Klimov <klimov.linux@gmail.com>

--
diff -r f4d7d0b84940 linux/drivers/media/radio/dsbr100.c
--- a/linux/drivers/media/radio/dsbr100.c	Sun Jan 18 10:55:38 2009 +0000
+++ b/linux/drivers/media/radio/dsbr100.c	Wed Jan 21 01:07:34 2009 +0300
@@ -393,9 +393,11 @@
 static int vidioc_querycap(struct file *file, void *priv,
 					struct v4l2_capability *v)
 {
+	struct dsbr100_device *radio = video_drvdata(file);
+
 	strlcpy(v->driver, "dsbr100", sizeof(v->driver));
 	strlcpy(v->card, "D-Link R-100 USB FM Radio", sizeof(v->card));
-	sprintf(v->bus_info, "USB");
+	usb_make_path(radio->usbdev, v->bus_info, sizeof(v->bus_info));
 	v->version = RADIO_VERSION;
 	v->capabilities = V4L2_CAP_TUNER;
 	return 0;
diff -r f4d7d0b84940 linux/drivers/media/radio/radio-mr800.c
--- a/linux/drivers/media/radio/radio-mr800.c	Sun Jan 18 10:55:38 2009 +0000
+++ b/linux/drivers/media/radio/radio-mr800.c	Wed Jan 21 01:07:34 2009 +0300
@@ -316,9 +316,11 @@
 static int vidioc_querycap(struct file *file, void *priv,
 					struct v4l2_capability *v)
 {
+	struct amradio_device *radio = video_drvdata(file);
+
 	strlcpy(v->driver, "radio-mr800", sizeof(v->driver));
 	strlcpy(v->card, "AverMedia MR 800 USB FM Radio", sizeof(v->card));
-	sprintf(v->bus_info, "USB");
+	usb_make_path(radio->usbdev, v->bus_info, sizeof(v->bus_info));
 	v->version = RADIO_VERSION;
 	v->capabilities = V4L2_CAP_TUNER;
 	return 0;
diff -r f4d7d0b84940 linux/drivers/media/radio/radio-si470x.c
--- a/linux/drivers/media/radio/radio-si470x.c	Sun Jan 18 10:55:38 2009 +0000
+++ b/linux/drivers/media/radio/radio-si470x.c	Wed Jan 21 01:07:34 2009 +0300
@@ -1202,9 +1202,11 @@
 static int si470x_vidioc_querycap(struct file *file, void *priv,
 		struct v4l2_capability *capability)
 {
+	struct si470x_device *radio = video_drvdata(file);
+
 	strlcpy(capability->driver, DRIVER_NAME, sizeof(capability->driver));
 	strlcpy(capability->card, DRIVER_CARD, sizeof(capability->card));
-	sprintf(capability->bus_info, "USB");
+	usb_make_path(radio->usbdev, capability->bus_info, sizeof(capability->bus_info));
 	capability->version = DRIVER_KERNEL_VERSION;
 	capability->capabilities = V4L2_CAP_HW_FREQ_SEEK |
 		V4L2_CAP_TUNER | V4L2_CAP_RADIO;


-- 
Best regards, Klimov Alexey

