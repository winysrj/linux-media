Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:43784 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755038Ab2ATXH0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Jan 2012 18:07:26 -0500
Received: by wics10 with SMTP id s10so847806wic.19
        for <linux-media@vger.kernel.org>; Fri, 20 Jan 2012 15:07:25 -0800 (PST)
Message-ID: <1327100838.4284.2.camel@tvbox>
Subject: [PATCH] it913x v1.23 use it913x_config.chip_ver to select firmware.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Date: Fri, 20 Jan 2012 23:07:18 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As recommended by Jason at ITE, the chip version should select firmware.

However, to continue to support IT9137 firmware with different configuration
the driver will use udev->descriptor.idVendor to select the difference
between IT9135 and IT9137.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/media/dvb/dvb-usb/it913x.c |   19 +++++++------------
 1 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/it913x.c b/drivers/media/dvb/dvb-usb/it913x.c
index 654aa7c..59eb23c 100644
--- a/drivers/media/dvb/dvb-usb/it913x.c
+++ b/drivers/media/dvb/dvb-usb/it913x.c
@@ -388,19 +388,12 @@ static int ite_firmware_select(struct usb_device *udev,
 {
 	int sw;
 	/* auto switch */
-	if (le16_to_cpu(udev->descriptor.idProduct) ==
-			USB_PID_ITETECH_IT9135)
-		sw = IT9135_V1_FW;
-	else if (le16_to_cpu(udev->descriptor.idProduct) ==
-			USB_PID_ITETECH_IT9135_9005)
+	if (le16_to_cpu(udev->descriptor.idVendor) == USB_VID_KWORLD_2)
+		sw = IT9137_FW;
+	else if (it913x_config.chip_ver == 1)
 		sw = IT9135_V1_FW;
-	else if (le16_to_cpu(udev->descriptor.idProduct) ==
-			USB_PID_ITETECH_IT9135_9006) {
+	else
 		sw = IT9135_V2_FW;
-		if (it913x_config.tuner_id_0 == 0)
-			it913x_config.tuner_id_0 = IT9135_60;
-	} else
-		sw = IT9137_FW;
 
 	/* force switch */
 	if (dvb_usb_it913x_firmware != IT9135_AUTO)
@@ -416,6 +409,8 @@ static int ite_firmware_select(struct usb_device *udev,
 		it913x_config.firmware_ver = 1;
 		it913x_config.adc_x2 = 1;
 		props->firmware = fw_it9135_v2;
+		if (it913x_config.tuner_id_0 == 0)
+			it913x_config.tuner_id_0 = IT9135_60;
 		break;
 	case IT9137_FW:
 	default:
@@ -842,5 +837,5 @@ module_exit(it913x_module_exit);
 
 MODULE_AUTHOR("Malcolm Priestley <tvboxspy@gmail.com>");
 MODULE_DESCRIPTION("it913x USB 2 Driver");
-MODULE_VERSION("1.22");
+MODULE_VERSION("1.23");
 MODULE_LICENSE("GPL");
-- 
1.7.8.3


