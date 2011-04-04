Return-path: <mchehab@pedra>
Received: from gateway07.websitewelcome.com ([69.56.159.26]:59797 "HELO
	gateway07.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751450Ab1DDRSR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Apr 2011 13:18:17 -0400
Message-ID: <4D99FB18.90604@sensoray.com>
Date: Mon, 04 Apr 2011 10:08:40 -0700
From: Sensoray Linux Development <linux-dev@sensoray.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] [media] s2255drv: firmware version update, vendor request
 change
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

removes obsolete comments. updates firmware versions. firmware vendor request simplified.

Signed-off-by: Dean Anderson <linux-dev@sensoray.com>
---
 drivers/media/video/s2255drv.c |   22 +++++++---------------
 1 files changed, 7 insertions(+), 15 deletions(-)

diff --git a/drivers/media/video/s2255drv.c b/drivers/media/video/s2255drv.c
index 561909b..2aecdfa 100644
--- a/drivers/media/video/s2255drv.c
+++ b/drivers/media/video/s2255drv.c
@@ -16,15 +16,10 @@
  * Example maximum bandwidth utilization:
  *
  * -full size, color mode YUYV or YUV422P: 2 channels at once
- *
  * -full or half size Grey scale: all 4 channels at once
- *
  * -half size, color mode YUYV or YUV422P: all 4 channels at once
- *
  * -full size, color mode YUYV or YUV422P 1/2 frame rate: all 4 channels
  *  at once.
- *  (TODO: Incorporate videodev2 frame rate(FR) enumeration,
- *  which is currently experimental.)
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -57,7 +52,7 @@
 #include <linux/usb.h>
 
 #define S2255_MAJOR_VERSION	1
-#define S2255_MINOR_VERSION	21
+#define S2255_MINOR_VERSION	22
 #define S2255_RELEASE		0
 #define S2255_VERSION		KERNEL_VERSION(S2255_MAJOR_VERSION, \
 					       S2255_MINOR_VERSION, \
@@ -126,7 +121,7 @@
 #define MASK_COLOR       0x000000ff
 #define MASK_JPG_QUALITY 0x0000ff00
 #define MASK_INPUT_TYPE  0x000f0000
-/* frame decimation. Not implemented by V4L yet(experimental in V4L) */
+/* frame decimation. */
 #define FDEC_1		1	/* capture every frame. default */
 #define FDEC_2		2	/* capture every 2nd frame */
 #define FDEC_3		3	/* capture every 3rd frame */
@@ -312,9 +307,9 @@ struct s2255_fh {
 };
 
 /* current cypress EEPROM firmware version */
-#define S2255_CUR_USB_FWVER	((3 << 8) | 11)
+#define S2255_CUR_USB_FWVER	((3 << 8) | 12)
 /* current DSP FW version */
-#define S2255_CUR_DSP_FWVER     10102
+#define S2255_CUR_DSP_FWVER     10104
 /* Need DSP version 5+ for video status feature */
 #define S2255_MIN_DSP_STATUS      5
 #define S2255_MIN_DSP_COLORFILTER 8
@@ -492,7 +487,7 @@ static void planar422p_to_yuv_packed(const unsigned char *in,
 
 static void s2255_reset_dsppower(struct s2255_dev *dev)
 {
-	s2255_vendor_req(dev, 0x40, 0x0b0b, 0x0b01, NULL, 0, 1);
+	s2255_vendor_req(dev, 0x40, 0x0000, 0x0001, NULL, 0, 1);
 	msleep(10);
 	s2255_vendor_req(dev, 0x50, 0x0000, 0x0000, NULL, 0, 1);
 	msleep(600);
@@ -2285,15 +2280,12 @@ static int s2255_board_init(struct s2255_dev *dev)
 	/* query the firmware */
 	fw_ver = s2255_get_fx2fw(dev);
 
-	printk(KERN_INFO "2255 usb firmware version %d.%d\n",
+	printk(KERN_INFO "s2255: usb firmware version %d.%d\n",
 	       (fw_ver >> 8) & 0xff,
 	       fw_ver & 0xff);
 
 	if (fw_ver < S2255_CUR_USB_FWVER)
-		dev_err(&dev->udev->dev,
-			"usb firmware not up to date %d.%d\n",
-			(fw_ver >> 8) & 0xff,
-			fw_ver & 0xff);
+		printk(KERN_INFO "s2255: newer USB firmware available\n");
 
 	for (j = 0; j < MAX_CHANNELS; j++) {
 		struct s2255_channel *channel = &dev->channel[j];
-- 
1.7.0.4

