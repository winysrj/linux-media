Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:49787 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754679Ab2EFVXX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 May 2012 17:23:23 -0400
From: "Hans-Frieder Vogt" <hfvogt@gmx.net>
To: linux-media@vger.kernel.org,
	Thomas Mair <thomas.mair86@googlemail.com>
Subject: [PATCH] rtl28xxu: support Terratec Noxon DAB/DAB+ stick
Date: Sun, 6 May 2012 23:23:15 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201205062323.16020.hfvogt@gmx.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Support for Terratec Noxon DAB/DAB+ USB stick in RTL28xxU driver.
Requires FC0013 patch sent today.
Additionally this patch makes the RTL28xxU driver compatible with the FC0012
tuner driver version 0.5 sent also earlier today (extra parameter in fc0012_attach call).

Signed-off-by: Hans-Frieder Vogt <hfvogt@gmx.net>

 drivers/media/dvb/dvb-usb/Kconfig       |    2 ++
 drivers/media/dvb/dvb-usb/dvb-usb-ids.h |    1 +
 drivers/media/dvb/dvb-usb/rtl28xxu.c    |   30 ++++++++++++++++++++++++++----
 3 files changed, 29 insertions(+), 4 deletions(-)

diff -up --new-file --recursive a/drivers/media/dvb/dvb-usb/dvb-usb-ids.h b/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
--- a/drivers/media/dvb/dvb-usb/dvb-usb-ids.h	2012-05-06 22:17:28.745347455 +0200
+++ b/drivers/media/dvb/dvb-usb/dvb-usb-ids.h	2012-05-06 23:06:53.491962266 +0200
@@ -244,6 +244,7 @@
 #define USB_PID_TERRATEC_H7_2				0x10a3
 #define USB_PID_TERRATEC_T3				0x10a0
 #define USB_PID_TERRATEC_T5				0x10a1
+#define USB_PID_NOXON_DAB_STICK				0x00b3
 #define USB_PID_PINNACLE_EXPRESSCARD_320CX		0x022e
 #define USB_PID_PINNACLE_PCTV2000E			0x022c
 #define USB_PID_PINNACLE_PCTV_DVB_T_FLASH		0x0228
diff -up --new-file --recursive a/drivers/media/dvb/dvb-usb/Kconfig b/drivers/media/dvb/dvb-usb/Kconfig
--- a/drivers/media/dvb/dvb-usb/Kconfig	2012-04-10 05:45:26.000000000 +0200
+++ b/drivers/media/dvb/dvb-usb/Kconfig	2012-05-06 23:08:08.371228938 +0200
@@ -420,6 +420,8 @@ config DVB_USB_RTL28XXU
 	select MEDIA_TUNER_QT1010 if !MEDIA_TUNER_CUSTOMISE
 	select MEDIA_TUNER_MT2060 if !MEDIA_TUNER_CUSTOMISE
 	select MEDIA_TUNER_MXL5005S if !MEDIA_TUNER_CUSTOMISE
+	select MEDIA_TUNER_FC0012 if !MEDIA_TUNER_CUSTOMISE
+	select MEDIA_TUNER_FC0013 if !MEDIA_TUNER_CUSTOMISE
 	help
 	  Say Y here to support the Realtek RTL28xxU DVB USB receiver.
 
diff -up --new-file --recursive a/drivers/media/dvb/dvb-usb/rtl28xxu.c b/drivers/media/dvb/dvb-usb/rtl28xxu.c
--- a/drivers/media/dvb/dvb-usb/rtl28xxu.c	2012-05-06 22:17:28.748680762 +0200
+++ b/drivers/media/dvb/dvb-usb/rtl28xxu.c	2012-05-06 23:17:15.889787522 +0200
@@ -30,6 +30,7 @@
 #include "mt2060.h"
 #include "mxl5005s.h"
 #include "fc0012.h"
+#include "fc0013.h"
 
 
 static int dvb_usb_rtl28xxu_debug;
@@ -390,6 +391,12 @@ static struct rtl2832_config rtl28xxu_rt
 	.tuner = TUNER_RTL28XX_FC0012
 };
 
+static struct rtl2832_config rtl28xxu_rtl2832_fc0013_config = {
+	.i2c_addr = 0x10, /* 0x20 */
+	.xtal = 28800000,
+	.if_dvbt = 0,
+	.tuner = TUNER_RTL28XX_FC0013
+};
 
 static int rtl2832u_fc0012_tuner_callback(struct dvb_usb_device *d,
 		int cmd, int arg)
@@ -399,7 +406,7 @@ static int rtl2832u_fc0012_tuner_callbac
 
 	deb_info("%s cmd=%d arg=%d", __func__, cmd, arg);
 	switch (cmd) {
-	case FC0012_FE_CALLBACK_VHF_ENABLE:
+	case FC_FE_CALLBACK_VHF_ENABLE:
 		/* set output values */
 
 		ret = rtl28xx_rd_reg(d, SYS_GPIO_DIR, &val);
@@ -456,6 +463,7 @@ static int rtl2832u_tuner_callback(struc
 
 	switch (priv->tuner) {
 	case TUNER_RTL28XX_FC0012:
+	case TUNER_RTL28XX_FC0013:
 		return rtl2832u_fc0012_tuner_callback(d, cmd, arg);
 	default:
 		break;
@@ -542,7 +550,7 @@ static int rtl2832u_frontend_attach(stru
 	ret = rtl28xxu_ctrl_msg(adap->dev, &req_fc0013);
 	if (ret == 0 && buf[0] == 0xa3) {
 		priv->tuner = TUNER_RTL28XX_FC0013;
-		rtl2832_config = &rtl28xxu_rtl2832_fc0012_config;
+		rtl2832_config = &rtl28xxu_rtl2832_fc0013_config;
 		info("%s: FC0013 tuner found", __func__);
 		goto found;
 	}
@@ -733,7 +741,12 @@ static int rtl2832u_tuner_attach(struct
 	switch (priv->tuner) {
 	case TUNER_RTL28XX_FC0012:
 		fe = dvb_attach(fc0012_attach, adap->fe_adap[0].fe,
-			&adap->dev->i2c_adap, 0xc6>>1, FC_XTAL_28_8_MHZ);
+			&adap->dev->i2c_adap, 0xc6>>1, 0, FC_XTAL_28_8_MHZ);
+		return 0;
+		break;
+	case TUNER_RTL28XX_FC0013:
+		fe = dvb_attach(fc0013_attach, adap->fe_adap[0].fe,
+			&adap->dev->i2c_adap, 0xc6>>1, 0, FC_XTAL_28_8_MHZ);
 		return 0;
 		break;
 	default:
@@ -1147,6 +1160,7 @@ enum rtl28xxu_usb_table_entry {
 	RTL2831U_14AA_0161,
 	RTL2832U_0CCD_00A9,
 	RTL2832U_1F4D_B803,
+	RTL2832U_0CCD_00B3,
 };
 
 static struct usb_device_id rtl28xxu_table[] = {
@@ -1163,6 +1177,8 @@ static struct usb_device_id rtl28xxu_tab
 		USB_DEVICE(USB_VID_TERRATEC, USB_PID_TERRATEC_CINERGY_T_STICK_BLACK_REV1)},
 	[RTL2832U_1F4D_B803] = {
 		USB_DEVICE(USB_VID_GTEK, USB_PID_GTEK)},
+	[RTL2832U_0CCD_00B3] = {
+		USB_DEVICE(USB_VID_TERRATEC, USB_PID_NOXON_DAB_STICK)},
 	{} /* terminating entry */
 };
 
@@ -1276,7 +1292,7 @@ static struct dvb_usb_device_properties
 
 		.i2c_algo = &rtl28xxu_i2c_algo,
 
-		.num_device_descs = 2,
+		.num_device_descs = 3,
 		.devices = {
 			{
 				.name = "Terratec Cinergy T Stick Black",
@@ -1290,6 +1306,12 @@ static struct dvb_usb_device_properties
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
 

Hans-Frieder Vogt                       e-mail: hfvogt <at> gmx .dot. net
