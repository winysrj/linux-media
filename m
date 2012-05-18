Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:46217 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964842Ab2ERSsu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 May 2012 14:48:50 -0400
Received: by mail-bk0-f46.google.com with SMTP id ji2so2596772bkc.19
        for <linux-media@vger.kernel.org>; Fri, 18 May 2012 11:48:49 -0700 (PDT)
From: Thomas Mair <thomas.mair86@googlemail.com>
To: linux-media@vger.kernel.org
Cc: crope@iki.fi, pomidorabelisima@gmail.com,
	Thomas Mair <thomas.mair86@googlemail.com>,
	Hans-Frieder Vogt <hfvogt@gmx.net>
Subject: [PATCH v5 5/5] rtl28xxu: support Terratec Noxon DAB/DAB+ stick
Date: Fri, 18 May 2012 20:47:44 +0200
Message-Id: <1337366864-1256-6-git-send-email-thomas.mair86@googlemail.com>
In-Reply-To: <1337366864-1256-1-git-send-email-thomas.mair86@googlemail.com>
References: <1>
 <1337366864-1256-1-git-send-email-thomas.mair86@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Hans-Frieder Vogt <hfvogt@gmx.net>
Signed-off-by: Thomas Mair <thomas.mair86@googlemail.com>
---
 drivers/media/dvb/dvb-usb/dvb-usb-ids.h |    1 +
 drivers/media/dvb/dvb-usb/rtl28xxu.c    |   11 ++++++++++-
 2 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/dvb-usb-ids.h b/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
index 360f6b7..26c4481 100644
--- a/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
+++ b/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
@@ -247,6 +247,7 @@
 #define USB_PID_TERRATEC_H7_2				0x10a3
 #define USB_PID_TERRATEC_T3				0x10a0
 #define USB_PID_TERRATEC_T5				0x10a1
+#define USB_PID_NOXON_DAB_STICK				0x00b3
 #define USB_PID_PINNACLE_EXPRESSCARD_320CX		0x022e
 #define USB_PID_PINNACLE_PCTV2000E			0x022c
 #define USB_PID_PINNACLE_PCTV_DVB_T_FLASH		0x0228
diff --git a/drivers/media/dvb/dvb-usb/rtl28xxu.c b/drivers/media/dvb/dvb-usb/rtl28xxu.c
index b2c8f67..0cac6fb 100644
--- a/drivers/media/dvb/dvb-usb/rtl28xxu.c
+++ b/drivers/media/dvb/dvb-usb/rtl28xxu.c
@@ -1153,6 +1153,7 @@ enum rtl28xxu_usb_table_entry {
 	RTL2831U_14AA_0161,
 	RTL2832U_0CCD_00A9,
 	RTL2832U_1F4D_B803,
+	RTL2832U_0CCD_00B3,
 };
 
 static struct usb_device_id rtl28xxu_table[] = {
@@ -1169,6 +1170,8 @@ static struct usb_device_id rtl28xxu_table[] = {
 		USB_DEVICE(USB_VID_TERRATEC, USB_PID_TERRATEC_CINERGY_T_STICK_BLACK_REV1)},
 	[RTL2832U_1F4D_B803] = {
 		USB_DEVICE(USB_VID_GTEK, USB_PID_DELOCK_USB2_DVBT)},
+	[RTL2832U_0CCD_00B3] = {
+		USB_DEVICE(USB_VID_TERRATEC, USB_PID_NOXON_DAB_STICK)},
 	{} /* terminating entry */
 };
 
@@ -1282,7 +1285,7 @@ static struct dvb_usb_device_properties rtl28xxu_properties[] = {
 
 		.i2c_algo = &rtl28xxu_i2c_algo,
 
-		.num_device_descs = 2,
+		.num_device_descs = 3,
 		.devices = {
 			{
 				.name = "Terratec Cinergy T Stick Black",
@@ -1296,6 +1299,12 @@ static struct dvb_usb_device_properties rtl28xxu_properties[] = {
 					&rtl28xxu_table[RTL2832U_1F4D_B803],
 				},
 			},
+			{
+				.name = "NOXON DAB/DAB+ USB dongle",
+				.warm_ids = {
+					&rtl28xxu_table[RTL2832U_0CCD_00B3],
+				},
+			},
 		}
 	},
 
-- 
1.7.7.6

