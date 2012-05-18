Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:46217 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964842Ab2ERSsq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 May 2012 14:48:46 -0400
Received: by mail-bk0-f46.google.com with SMTP id ji2so2596772bkc.19
        for <linux-media@vger.kernel.org>; Fri, 18 May 2012 11:48:45 -0700 (PDT)
From: Thomas Mair <thomas.mair86@googlemail.com>
To: linux-media@vger.kernel.org
Cc: crope@iki.fi, pomidorabelisima@gmail.com,
	Thomas Mair <thomas.mair86@googlemail.com>
Subject: [PATCH v5 4/5] rtl28xxu: support Delock USB 2.0 DVB-T
Date: Fri, 18 May 2012 20:47:43 +0200
Message-Id: <1337366864-1256-5-git-send-email-thomas.mair86@googlemail.com>
In-Reply-To: <1337366864-1256-1-git-send-email-thomas.mair86@googlemail.com>
References: <1>
 <1337366864-1256-1-git-send-email-thomas.mair86@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Thomas Mair <thomas.mair86@googlemail.com>
---
 drivers/media/dvb/dvb-usb/dvb-usb-ids.h |    1 +
 drivers/media/dvb/dvb-usb/rtl28xxu.c    |   11 ++++++++++-
 2 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/dvb-usb-ids.h b/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
index cd9254c..360f6b7 100644
--- a/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
+++ b/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
@@ -100,6 +100,7 @@
 #define USB_PID_CONCEPTRONIC_CTVDIGRCU			0xe397
 #define USB_PID_CONEXANT_D680_DMB			0x86d6
 #define USB_PID_CREATIX_CTX1921				0x1921
+#define USB_PID_DELOCK_USB2_DVBT			0xb803
 #define USB_PID_DIBCOM_HOOK_DEFAULT			0x0064
 #define USB_PID_DIBCOM_HOOK_DEFAULT_REENUM		0x0065
 #define USB_PID_DIBCOM_MOD3000_COLD			0x0bb8
diff --git a/drivers/media/dvb/dvb-usb/rtl28xxu.c b/drivers/media/dvb/dvb-usb/rtl28xxu.c
index 5586715..b2c8f67 100644
--- a/drivers/media/dvb/dvb-usb/rtl28xxu.c
+++ b/drivers/media/dvb/dvb-usb/rtl28xxu.c
@@ -1152,6 +1152,7 @@ enum rtl28xxu_usb_table_entry {
 	RTL2831U_14AA_0160,
 	RTL2831U_14AA_0161,
 	RTL2832U_0CCD_00A9,
+	RTL2832U_1F4D_B803,
 };
 
 static struct usb_device_id rtl28xxu_table[] = {
@@ -1166,6 +1167,8 @@ static struct usb_device_id rtl28xxu_table[] = {
 	/* RTL2832U */
 	[RTL2832U_0CCD_00A9] = {
 		USB_DEVICE(USB_VID_TERRATEC, USB_PID_TERRATEC_CINERGY_T_STICK_BLACK_REV1)},
+	[RTL2832U_1F4D_B803] = {
+		USB_DEVICE(USB_VID_GTEK, USB_PID_DELOCK_USB2_DVBT)},
 	{} /* terminating entry */
 };
 
@@ -1279,7 +1282,7 @@ static struct dvb_usb_device_properties rtl28xxu_properties[] = {
 
 		.i2c_algo = &rtl28xxu_i2c_algo,
 
-		.num_device_descs = 1,
+		.num_device_descs = 2,
 		.devices = {
 			{
 				.name = "Terratec Cinergy T Stick Black",
@@ -1287,6 +1290,12 @@ static struct dvb_usb_device_properties rtl28xxu_properties[] = {
 					&rtl28xxu_table[RTL2832U_0CCD_00A9],
 				},
 			},
+			{
+				.name = "G-Tek Electronics Group Lifeview LV5TDLX DVB-T",
+				.warm_ids = {
+					&rtl28xxu_table[RTL2832U_1F4D_B803],
+				},
+			},
 		}
 	},
 
-- 
1.7.7.6

