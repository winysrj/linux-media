Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:40506 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415Ab2ELSKD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 May 2012 14:10:03 -0400
Received: by mail-bk0-f46.google.com with SMTP id ji2so2938614bkc.19
        for <linux-media@vger.kernel.org>; Sat, 12 May 2012 11:10:02 -0700 (PDT)
From: Thomas Mair <thomas.mair86@googlemail.com>
To: linux-media@vger.kernel.org
Cc: Thomas Mair <thomas.mair86@googlemail.com>
Subject: [PATCH 4/5] rtl28xxu: support G-Tek Electronics Group Lifeview LV5TDLX DVB-T
Date: Sat, 12 May 2012 20:08:28 +0200
Message-Id: <1336846109-30070-5-git-send-email-thomas.mair86@googlemail.com>
In-Reply-To: <1336846109-30070-1-git-send-email-thomas.mair86@googlemail.com>
References: <1336846109-30070-1-git-send-email-thomas.mair86@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Thomas Mair <thomas.mair86@googlemail.com>
---
 drivers/media/dvb/dvb-usb/dvb-usb-ids.h |    1 +
 drivers/media/dvb/dvb-usb/rtl28xxu.c    |   11 ++++++++++-
 2 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/dvb-usb-ids.h b/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
index fd37be0..b0a86e9 100644
--- a/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
+++ b/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
@@ -135,6 +135,7 @@
 #define USB_PID_GENIUS_TVGO_DVB_T03			0x4012
 #define USB_PID_GRANDTEC_DVBT_USB_COLD			0x0fa0
 #define USB_PID_GRANDTEC_DVBT_USB_WARM			0x0fa1
+#define USB_PID_GTEK					0xb803
 #define USB_PID_INTEL_CE9500				0x9500
 #define USB_PID_ITETECH_IT9135				0x9135
 #define USB_PID_ITETECH_IT9135_9005			0x9005
diff --git a/drivers/media/dvb/dvb-usb/rtl28xxu.c b/drivers/media/dvb/dvb-usb/rtl28xxu.c
index 86304c6..699da68 100644
--- a/drivers/media/dvb/dvb-usb/rtl28xxu.c
+++ b/drivers/media/dvb/dvb-usb/rtl28xxu.c
@@ -1135,6 +1135,7 @@ enum rtl28xxu_usb_table_entry {
 	RTL2831U_14AA_0160,
 	RTL2831U_14AA_0161,
 	RTL2832U_0CCD_00A9,
+	RTL2832U_1F4D_B803,
 };
 
 static struct usb_device_id rtl28xxu_table[] = {
@@ -1149,6 +1150,8 @@ static struct usb_device_id rtl28xxu_table[] = {
 	/* RTL2832U */
 	[RTL2832U_0CCD_00A9] = {
 		USB_DEVICE(USB_VID_TERRATEC, USB_PID_TERRATEC_CINERGY_T_STICK_BLACK_REV1)},
+	[RTL2832U_1F4D_B803] = {
+		USB_DEVICE(USB_VID_GTEK, USB_PID_GTEK)},
 	{} /* terminating entry */
 };
 
@@ -1262,7 +1265,7 @@ static struct dvb_usb_device_properties rtl28xxu_properties[] = {
 
 		.i2c_algo = &rtl28xxu_i2c_algo,
 
-		.num_device_descs = 1,
+		.num_device_descs = 2,
 		.devices = {
 			{
 				.name = "Terratec Cinergy T Stick Black",
@@ -1270,6 +1273,12 @@ static struct dvb_usb_device_properties rtl28xxu_properties[] = {
 					&rtl28xxu_table[RTL2832U_0CCD_00A9],
 				},
 			},
+			{
+				.name = "G-Tek Electronics Group Lifeview LV5TDLX DVB-T [RTL2832U]",
+				.warm_ids = {
+					&rtl28xxu_table[RTL2832U_1F4D_B803],
+				},
+			},
 		}
 	},
 
-- 
1.7.7.6

