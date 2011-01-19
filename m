Return-path: <mchehab@pedra>
Received: from gateway11.websitewelcome.com ([67.18.72.139]:58323 "HELO
	gateway11.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752488Ab1ASUvW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Jan 2011 15:51:22 -0500
Message-ID: <4D374C89.4050004@sensoray.com>
Date: Wed, 19 Jan 2011 12:41:45 -0800
From: Sensoray Linux Development <linux-dev@sensoray.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] s2255drv: firmware re-loading changes
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Change for firmware re-loading and updated firmware versions.

Signed-off-by: Dean Anderson <linux-dev@sensoray.com>


diff --git a/drivers/media/video/s2255drv.c b/drivers/media/video/s2255drv.c
index b63f8ca..561909b 100644
--- a/drivers/media/video/s2255drv.c
+++ b/drivers/media/video/s2255drv.c
@@ -57,7 +57,7 @@
 #include <linux/usb.h>
 
 #define S2255_MAJOR_VERSION	1
-#define S2255_MINOR_VERSION	20
+#define S2255_MINOR_VERSION	21
 #define S2255_RELEASE		0
 #define S2255_VERSION		KERNEL_VERSION(S2255_MAJOR_VERSION, \
 					       S2255_MINOR_VERSION, \
@@ -312,9 +312,9 @@ struct s2255_fh {
 };
 
 /* current cypress EEPROM firmware version */
-#define S2255_CUR_USB_FWVER	((3 << 8) | 6)
+#define S2255_CUR_USB_FWVER	((3 << 8) | 11)
 /* current DSP FW version */
-#define S2255_CUR_DSP_FWVER     8
+#define S2255_CUR_DSP_FWVER     10102
 /* Need DSP version 5+ for video status feature */
 #define S2255_MIN_DSP_STATUS      5
 #define S2255_MIN_DSP_COLORFILTER 8
@@ -492,9 +492,11 @@ static void planar422p_to_yuv_packed(const unsigned char *in,
 
 static void s2255_reset_dsppower(struct s2255_dev *dev)
 {
-	s2255_vendor_req(dev, 0x40, 0x0b0b, 0x0b0b, NULL, 0, 1);
+	s2255_vendor_req(dev, 0x40, 0x0b0b, 0x0b01, NULL, 0, 1);
 	msleep(10);
 	s2255_vendor_req(dev, 0x50, 0x0000, 0x0000, NULL, 0, 1);
+	msleep(600);
+	s2255_vendor_req(dev, 0x10, 0x0000, 0x0000, NULL, 0, 1);
 	return;
 }
 


