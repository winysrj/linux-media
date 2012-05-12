Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:40506 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752532Ab2ELSKM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 May 2012 14:10:12 -0400
Received: by mail-bk0-f46.google.com with SMTP id ji2so2938614bkc.19
        for <linux-media@vger.kernel.org>; Sat, 12 May 2012 11:10:11 -0700 (PDT)
From: Thomas Mair <thomas.mair86@googlemail.com>
To: linux-media@vger.kernel.org
Cc: Thomas Mair <thomas.mair86@googlemail.com>,
	Hans-Frieder Vogt <hfvogt@gmx.net>
Subject: [PATCH 5/5] rtl28xxu: support Terratec Noxon DAB/DAB+ stick
Date: Sat, 12 May 2012 20:08:29 +0200
Message-Id: <1336846109-30070-6-git-send-email-thomas.mair86@googlemail.com>
In-Reply-To: <1336846109-30070-1-git-send-email-thomas.mair86@googlemail.com>
References: <1336846109-30070-1-git-send-email-thomas.mair86@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Hans-Frieder Vogt <hfvogt@gmx.net>
Signed-off-by: Thomas Mair <thomas.mair86@googlemail.com>
---
 drivers/media/dvb/dvb-usb/dvb-usb-ids.h |    1 +
 drivers/media/dvb/dvb-usb/rtl28xxu.c    |   27 ++++++++++++++++++++++++++-
 2 files changed, 27 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/dvb-usb-ids.h b/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
index b0a86e9..95c9c14 100644
--- a/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
+++ b/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
@@ -244,6 +244,7 @@
 #define USB_PID_TERRATEC_H7_2				0x10a3
 #define USB_PID_TERRATEC_T3				0x10a0
 #define USB_PID_TERRATEC_T5				0x10a1
+#define USB_PID_NOXON_DAB_STICK				0x00b3
 #define USB_PID_PINNACLE_EXPRESSCARD_320CX		0x022e
 #define USB_PID_PINNACLE_PCTV2000E			0x022c
 #define USB_PID_PINNACLE_PCTV_DVB_T_FLASH		0x0228
diff --git a/drivers/media/dvb/dvb-usb/rtl28xxu.c b/drivers/media/dvb/dvb-usb/rtl28xxu.c
index 699da68..bacc783 100644
--- a/drivers/media/dvb/dvb-usb/rtl28xxu.c
+++ b/drivers/media/dvb/dvb-usb/rtl28xxu.c
@@ -29,6 +29,7 @@
 #include "mt2060.h"
 #include "mxl5005s.h"
 #include "fc0012.h"
+#include "fc0013.h"
 
 /* debug */
 static int dvb_usb_rtl28xxu_debug;
@@ -388,6 +389,12 @@ static struct rtl2832_config rtl28xxu_rtl2832_fc0012_config = {
 	.tuner = TUNER_RTL2832_FC0012
 };
 
+static struct rtl2832_config rtl28xxu_rtl2832_fc0013_config = {
+	.i2c_addr = 0x10, /* 0x20 */
+	.xtal = 28800000,
+	.if_dvbt = 0,
+	.tuner = TUNER_RTL2832_FC0013
+};
 
 static int rtl2832u_fc0012_tuner_callback(struct dvb_usb_device *d,
 		int cmd, int arg)
@@ -553,6 +560,7 @@ static int rtl2832u_frontend_attach(struct dvb_usb_adapter *adap)
 	ret = rtl28xxu_ctrl_msg(adap->dev, &req_fc0013);
 	if (ret == 0 && buf[0] == 0xa3) {
 		priv->tuner = TUNER_RTL2832_FC0013;
+		rtl2832_config = &rtl28xxu_rtl2832_fc0013_config;
 		info("%s: FC0013 tuner found\n", __func__);
 		goto found;
 	}
@@ -750,6 +758,14 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
				fe->ops.tuner_ops.get_rf_strength;
		return 0;
 		break;
+	case TUNER_RTL2832_FC0013:
+		fe = dvb_attach(fc0013_attach, adap->fe_adap[0].fe,
+			&adap->dev->i2c_adap, 0xc6>>1, 0, FC_XTAL_28_8_MHZ);
+
+		/* fc0013 also supports signal strength reading */
+		adap->fe_adap[0].fe->ops.read_signal_strength = adap->fe_adap[0]
+			.fe->ops.tuner_ops.get_rf_strength;
+		return 0;
 	default:
 		fe = NULL;
 		err("unknown tuner=%d", priv->tuner);
@@ -1136,6 +1152,7 @@ enum rtl28xxu_usb_table_entry {
 	RTL2831U_14AA_0161,
 	RTL2832U_0CCD_00A9,
 	RTL2832U_1F4D_B803,
+	RTL2832U_0CCD_00B3,
 };
 
 static struct usb_device_id rtl28xxu_table[] = {
@@ -1152,6 +1169,8 @@ static struct usb_device_id rtl28xxu_table[] = {
 		USB_DEVICE(USB_VID_TERRATEC, USB_PID_TERRATEC_CINERGY_T_STICK_BLACK_REV1)},
 	[RTL2832U_1F4D_B803] = {
 		USB_DEVICE(USB_VID_GTEK, USB_PID_GTEK)},
+	[RTL2832U_0CCD_00B3] = {
+		USB_DEVICE(USB_VID_TERRATEC, USB_PID_NOXON_DAB_STICK)},
 	{} /* terminating entry */
 };
 
@@ -1265,7 +1284,7 @@ static struct dvb_usb_device_properties rtl28xxu_properties[] = {
 
 		.i2c_algo = &rtl28xxu_i2c_algo,
 
-		.num_device_descs = 2,
+		.num_device_descs = 3,
 		.devices = {
 			{
 				.name = "Terratec Cinergy T Stick Black",
@@ -1279,6 +1298,12 @@ static struct dvb_usb_device_properties rtl28xxu_properties[] = {
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

