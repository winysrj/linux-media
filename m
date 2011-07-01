Return-path: <mchehab@pedra>
Received: from mail-fx0-f52.google.com ([209.85.161.52]:53664 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755698Ab1GAKU0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Jul 2011 06:20:26 -0400
Received: by fxd18 with SMTP id 18so3140602fxd.11
        for <linux-media@vger.kernel.org>; Fri, 01 Jul 2011 03:20:24 -0700 (PDT)
From: Frank Schaefer <fschaefer.oss@googlemail.com>
To: brijohn@gmail.com
Cc: linux-media@vger.kernel.org,
	Frank Schaefer <fschaefer.oss@googlemail.com>,
	stable@kernel.org
Subject: [PATCH] gspca_sn9c20x: device 0c45:62b3: fix status LED
Date: Fri,  1 Jul 2011 12:19:58 +0200
Message-Id: <1309515598-14669-1-git-send-email-fschaefer.oss@googlemail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Tested with webcam "SilverCrest WC2130".

Signed-off-by: Frank Schaefer <fschaefer.oss@googlemail.com>

Cc: stable@kernel.org
---
 drivers/media/video/gspca/sn9c20x.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/gspca/sn9c20x.c b/drivers/media/video/gspca/sn9c20x.c
index c431900..af9cd50 100644
--- a/drivers/media/video/gspca/sn9c20x.c
+++ b/drivers/media/video/gspca/sn9c20x.c
@@ -2513,7 +2513,7 @@ static const struct usb_device_id device_table[] = {
 	{USB_DEVICE(0x0c45, 0x628f), SN9C20X(OV9650, 0x30, 0)},
 	{USB_DEVICE(0x0c45, 0x62a0), SN9C20X(OV7670, 0x21, 0)},
 	{USB_DEVICE(0x0c45, 0x62b0), SN9C20X(MT9VPRB, 0x00, 0)},
-	{USB_DEVICE(0x0c45, 0x62b3), SN9C20X(OV9655, 0x30, 0)},
+	{USB_DEVICE(0x0c45, 0x62b3), SN9C20X(OV9655, 0x30, LED_REVERSE)},
 	{USB_DEVICE(0x0c45, 0x62bb), SN9C20X(OV7660, 0x21, LED_REVERSE)},
 	{USB_DEVICE(0x0c45, 0x62bc), SN9C20X(HV7131R, 0x11, 0)},
 	{USB_DEVICE(0x045e, 0x00f4), SN9C20X(OV9650, 0x30, 0)},
-- 
1.7.3.4

