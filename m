Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:52075 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735Ab1K3VQR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Nov 2011 16:16:17 -0500
Received: by eaak14 with SMTP id k14so1229920eaa.19
        for <linux-media@vger.kernel.org>; Wed, 30 Nov 2011 13:16:16 -0800 (PST)
Message-ID: <1322687769.2476.9.camel@tvbox>
Subject: [PATCH 2/3] [for 3.3] add support for IT9135 9005 devices.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Date: Wed, 30 Nov 2011 21:16:09 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Support add for IT9135 9005 devices

With this patch IT9135 devices now move to using
dvb-usb-it9135-01.fw firmware
IT9137 remain on previous firmware.

IT9135 devices seem more stable on this firmware.

If the user wishes to remain on it9137 firmware they can change
back using firmware=1 module option.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/media/dvb/dvb-usb/dvb-usb-ids.h |    1 +
 drivers/media/dvb/dvb-usb/it913x.c      |   26 ++++++++++++++++++++++++--
 2 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/dvb-usb-ids.h b/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
index 18be4b1..3cce13b 100644
--- a/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
+++ b/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
@@ -131,6 +131,7 @@
 #define USB_PID_GRANDTEC_DVBT_USB_WARM			0x0fa1
 #define USB_PID_INTEL_CE9500				0x9500
 #define USB_PID_ITETECH_IT9135				0x9135
+#define USB_PID_ITETECH_IT9135_9005			0x9005
 #define USB_PID_KWORLD_399U				0xe399
 #define USB_PID_KWORLD_399U_2				0xe400
 #define USB_PID_KWORLD_395U				0xe396
diff --git a/drivers/media/dvb/dvb-usb/it913x.c b/drivers/media/dvb/dvb-usb/it913x.c
index c7bf03c..d7c86c2 100644
--- a/drivers/media/dvb/dvb-usb/it913x.c
+++ b/drivers/media/dvb/dvb-usb/it913x.c
@@ -52,6 +52,11 @@ static int pid_filter;
 module_param_named(pid, pid_filter, int, 0644);
 MODULE_PARM_DESC(pid, "set default 0=on 1=off");
 
+static int dvb_usb_it913x_firmware;
+module_param_named(firmware, dvb_usb_it913x_firmware, int, 0644);
+MODULE_PARM_DESC(firmware, "set firmware 0=auto 1=IT9137 2=IT9135V1");
+
+
 int cmd_counter;
 
 DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
@@ -340,6 +345,10 @@ static int it913x_rc_query(struct dvb_usb_device *d)
 	return ret;
 }
 
+/* Firmware sets raw */
+const char fw_it9135_v1[] = "dvb-usb-it9135-01.fw";
+const char fw_it9137[] = "dvb-usb-it9137-01.fw";
+
 static int ite_firmware_select(struct usb_device *udev,
 	struct dvb_usb_device_properties *props)
 {
@@ -348,18 +357,27 @@ static int ite_firmware_select(struct usb_device *udev,
 	if (le16_to_cpu(udev->descriptor.idProduct) ==
 			USB_PID_ITETECH_IT9135)
 		sw = IT9135_V1_FW;
+	else if (le16_to_cpu(udev->descriptor.idProduct) ==
+			USB_PID_ITETECH_IT9135_9005)
+		sw = IT9135_V1_FW;
 	else
 		sw = IT9137_FW;
 
+	/* force switch */
+	if (dvb_usb_it913x_firmware != IT9135_AUTO)
+		sw = dvb_usb_it913x_firmware;
+
 	switch (sw) {
 	case IT9135_V1_FW:
-		it913x_config.firmware_ver = 0;
+		it913x_config.firmware_ver = 1;
 		it913x_config.adc_x2 = 1;
+		props->firmware = fw_it9135_v1;
 		break;
 	case IT9137_FW:
 	default:
 		it913x_config.firmware_ver = 0;
 		it913x_config.adc_x2 = 0;
+		props->firmware = fw_it9137;
 	}
 
 	return 0;
@@ -636,6 +654,7 @@ static struct usb_device_id it913x_table[] = {
 	{ USB_DEVICE(USB_VID_KWORLD_2, USB_PID_KWORLD_UB499_2T_T09) },
 	{ USB_DEVICE(USB_VID_ITETECH, USB_PID_ITETECH_IT9135) },
 	{ USB_DEVICE(USB_VID_KWORLD_2, USB_PID_SVEON_STV22_IT9137) },
+	{ USB_DEVICE(USB_VID_ITETECH, USB_PID_ITETECH_IT9135_9005) },
 	{}		/* Terminating entry */
 };
 
@@ -722,6 +741,9 @@ static struct dvb_usb_device_properties it913x_properties = {
 		{   "Sveon STV22 Dual DVB-T HDTV(IT9137)",
 			{ &it913x_table[2], NULL },
 			},
+		{   "ITE 9135(9005) Generic",
+			{ &it913x_table[3], NULL },
+			},
 	}
 };
 
@@ -755,5 +777,5 @@ module_exit(it913x_module_exit);
 
 MODULE_AUTHOR("Malcolm Priestley <tvboxspy@gmail.com>");
 MODULE_DESCRIPTION("it913x USB 2 Driver");
-MODULE_VERSION("1.11");
+MODULE_VERSION("1.14");
 MODULE_LICENSE("GPL");
-- 
1.7.7.1



