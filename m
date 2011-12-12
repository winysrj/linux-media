Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59457 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753918Ab1LLTxN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Dec 2011 14:53:13 -0500
Received: by faar15 with SMTP id r15so1637563faa.19
        for <linux-media@vger.kernel.org>; Mon, 12 Dec 2011 11:53:12 -0800 (PST)
Message-ID: <1323719580.2235.3.camel@tvbox>
Subject: [PATCH] it913x add support for IT9135 9006 devices
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Date: Mon, 12 Dec 2011 19:53:00 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Support for IT1935 9006 devices.

9006 have version 2 type chip.

9006 devices should use dvb-usb-it9135-02.fw firmware.

On the device tested the tuner id was set to 0 which meant
the driver used tuner id 0x38. The device functioned normally.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/media/dvb/dvb-usb/dvb-usb-ids.h |    1 +
 drivers/media/dvb/dvb-usb/it913x.c      |   17 +++++++++++++++--
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/dvb-usb-ids.h b/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
index 3cce13b..d390dda 100644
--- a/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
+++ b/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
@@ -132,6 +132,7 @@
 #define USB_PID_INTEL_CE9500				0x9500
 #define USB_PID_ITETECH_IT9135				0x9135
 #define USB_PID_ITETECH_IT9135_9005			0x9005
+#define USB_PID_ITETECH_IT9135_9006			0x9006
 #define USB_PID_KWORLD_399U				0xe399
 #define USB_PID_KWORLD_399U_2				0xe400
 #define USB_PID_KWORLD_395U				0xe396
diff --git a/drivers/media/dvb/dvb-usb/it913x.c b/drivers/media/dvb/dvb-usb/it913x.c
index 3ddf82a..6f6072b 100644
--- a/drivers/media/dvb/dvb-usb/it913x.c
+++ b/drivers/media/dvb/dvb-usb/it913x.c
@@ -387,6 +387,7 @@ static int it913x_rc_query(struct dvb_usb_device *d)
 
 /* Firmware sets raw */
 const char fw_it9135_v1[] = "dvb-usb-it9135-01.fw";
+const char fw_it9135_v2[] = "dvb-usb-it9135-02.fw";
 const char fw_it9137[] = "dvb-usb-it9137-01.fw";
 
 static int ite_firmware_select(struct usb_device *udev,
@@ -400,6 +401,9 @@ static int ite_firmware_select(struct usb_device *udev,
 	else if (le16_to_cpu(udev->descriptor.idProduct) ==
 			USB_PID_ITETECH_IT9135_9005)
 		sw = IT9135_V1_FW;
+	else if (le16_to_cpu(udev->descriptor.idProduct) ==
+			USB_PID_ITETECH_IT9135_9006)
+		sw = IT9135_V2_FW;
 	else
 		sw = IT9137_FW;
 
@@ -413,6 +417,11 @@ static int ite_firmware_select(struct usb_device *udev,
 		it913x_config.adc_x2 = 1;
 		props->firmware = fw_it9135_v1;
 		break;
+	case IT9135_V2_FW:
+		it913x_config.firmware_ver = 1;
+		it913x_config.adc_x2 = 1;
+		props->firmware = fw_it9135_v2;
+		break;
 	case IT9137_FW:
 	default:
 		it913x_config.firmware_ver = 0;
@@ -701,6 +710,7 @@ static struct usb_device_id it913x_table[] = {
 	{ USB_DEVICE(USB_VID_ITETECH, USB_PID_ITETECH_IT9135) },
 	{ USB_DEVICE(USB_VID_KWORLD_2, USB_PID_SVEON_STV22_IT9137) },
 	{ USB_DEVICE(USB_VID_ITETECH, USB_PID_ITETECH_IT9135_9005) },
+	{ USB_DEVICE(USB_VID_ITETECH, USB_PID_ITETECH_IT9135_9006) },
 	{}		/* Terminating entry */
 };
 
@@ -776,7 +786,7 @@ static struct dvb_usb_device_properties it913x_properties = {
 		.rc_codes	= RC_MAP_MSI_DIGIVOX_III,
 	},
 	.i2c_algo         = &it913x_i2c_algo,
-	.num_device_descs = 4,
+	.num_device_descs = 5,
 	.devices = {
 		{   "Kworld UB499-2T T09(IT9137)",
 			{ &it913x_table[0], NULL },
@@ -790,6 +800,9 @@ static struct dvb_usb_device_properties it913x_properties = {
 		{   "ITE 9135(9005) Generic",
 			{ &it913x_table[3], NULL },
 			},
+		{   "ITE 9135(9006) Generic",
+			{ &it913x_table[4], NULL },
+			},
 	}
 };
 
@@ -823,5 +836,5 @@ module_exit(it913x_module_exit);
 
 MODULE_AUTHOR("Malcolm Priestley <tvboxspy@gmail.com>");
 MODULE_DESCRIPTION("it913x USB 2 Driver");
-MODULE_VERSION("1.14");
+MODULE_VERSION("1.17");
 MODULE_LICENSE("GPL");
-- 
1.7.7.3


