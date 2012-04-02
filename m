Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:60145 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370Ab2DBV0k (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Apr 2012 17:26:40 -0400
Received: by mail-wi0-f172.google.com with SMTP id hj6so3023786wib.1
        for <linux-media@vger.kernel.org>; Mon, 02 Apr 2012 14:26:39 -0700 (PDT)
From: Gianluca Gennari <gennarone@gmail.com>
To: linux-media@vger.kernel.org, crope@iki.fi
Cc: m@bues.ch, hfvogt@gmx.net, mchehab@redhat.com,
	Gianluca Gennari <gennarone@gmail.com>
Subject: [PATCH 2/5] af9035: add support for the tda18218 tuner
Date: Mon,  2 Apr 2012 23:25:14 +0200
Message-Id: <1333401917-27203-3-git-send-email-gennarone@gmail.com>
In-Reply-To: <1333401917-27203-1-git-send-email-gennarone@gmail.com>
References: <1333401917-27203-1-git-send-email-gennarone@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add basic support for the tda18218 tuner and the AVerMedia A835 devices.

Signed-off-by: Gianluca Gennari <gennarone@gmail.com>
---
 drivers/media/dvb/dvb-usb/Kconfig         |    1 +
 drivers/media/dvb/dvb-usb/af9035.c        |   26 +++++++++++++++++++++-
 drivers/media/dvb/dvb-usb/dvb-usb-ids.h   |    2 +
 drivers/media/dvb/frontends/af9033.c      |    4 +++
 drivers/media/dvb/frontends/af9033.h      |    1 +
 drivers/media/dvb/frontends/af9033_priv.h |   34 +++++++++++++++++++++++++++++
 6 files changed, 67 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/Kconfig b/drivers/media/dvb/dvb-usb/Kconfig
index f53fb3c..be1db75 100644
--- a/drivers/media/dvb/dvb-usb/Kconfig
+++ b/drivers/media/dvb/dvb-usb/Kconfig
@@ -430,6 +430,7 @@ config DVB_USB_AF9035
 	select MEDIA_TUNER_TUA9001 if !MEDIA_TUNER_CUSTOMISE
 	select MEDIA_TUNER_FC0011 if !MEDIA_TUNER_CUSTOMISE
 	select MEDIA_TUNER_MXL5007T if !MEDIA_TUNER_CUSTOMISE
+	select MEDIA_TUNER_TDA18218 if !MEDIA_TUNER_CUSTOMISE
 	help
 	  Say Y here to support the Afatech AF9035 based DVB USB receiver.
 
diff --git a/drivers/media/dvb/dvb-usb/af9035.c b/drivers/media/dvb/dvb-usb/af9035.c
index 6f73cdf..f943c57 100644
--- a/drivers/media/dvb/dvb-usb/af9035.c
+++ b/drivers/media/dvb/dvb-usb/af9035.c
@@ -24,6 +24,7 @@
 #include "tua9001.h"
 #include "fc0011.h"
 #include "mxl5007t.h"
+#include "tda18218.h"
 
 DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 static DEFINE_MUTEX(af9035_usb_mutex);
@@ -502,6 +503,7 @@ static int af9035_read_mac_address(struct dvb_usb_device *d, u8 mac[6])
 		case AF9033_TUNER_TUA9001:
 		case AF9033_TUNER_FC0011:
 		case AF9033_TUNER_MXL5007T:
+		case AF9033_TUNER_TDA18218:
 			af9035_af9033_config[i].spec_inv = 1;
 			break;
 		default:
@@ -678,6 +680,11 @@ static struct mxl5007t_config af9035_mxl5007t_config = {
 	.clk_out_amp = MxL_CLKOUT_AMP_0_94V,
 };
 
+static struct tda18218_config af9035_tda18218_config = {
+	.i2c_address = 0x60,
+	.i2c_wr_max = 21,
+};
+
 static int af9035_tuner_attach(struct dvb_usb_adapter *adap)
 {
 	int ret;
@@ -772,6 +779,11 @@ static int af9035_tuner_attach(struct dvb_usb_adapter *adap)
 		fe = dvb_attach(mxl5007t_attach, adap->fe_adap[0].fe,
 				&adap->dev->i2c_adap, 0x60, &af9035_mxl5007t_config);
 		break;
+	case AF9033_TUNER_TDA18218:
+		/* attach tuner */
+		fe = dvb_attach(tda18218_attach, adap->fe_adap[0].fe,
+				&adap->dev->i2c_adap, &af9035_tda18218_config);
+		break;
 	default:
 		fe = NULL;
 	}
@@ -793,6 +805,8 @@ enum af9035_id_entry {
 	AF9035_0CCD_0093,
 	AF9035_15A4_9035,
 	AF9035_15A4_1001,
+	AF9035_07CA_A835,
+	AF9035_07CA_B835,
 	AF9035_07CA_1867,
 	AF9035_07CA_A867,
 };
@@ -804,6 +818,10 @@ static struct usb_device_id af9035_id[] = {
 		USB_DEVICE(USB_VID_AFATECH, USB_PID_AFATECH_AF9035)},
 	[AF9035_15A4_1001] = {
 		USB_DEVICE(USB_VID_AFATECH, USB_PID_AFATECH_AF9035_2)},
+	[AF9035_07CA_A835] = {
+		USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_A835)},
+	[AF9035_07CA_B835] = {
+		USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_B835)},
 	[AF9035_07CA_1867] = {
 		USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_1867)},
 	[AF9035_07CA_A867] = {
@@ -850,7 +868,7 @@ static struct dvb_usb_device_properties af9035_properties[] = {
 
 		.i2c_algo = &af9035_i2c_algo,
 
-		.num_device_descs = 3,
+		.num_device_descs = 4,
 		.devices = {
 			{
 				.name = "TerraTec Cinergy T Stick",
@@ -864,6 +882,12 @@ static struct dvb_usb_device_properties af9035_properties[] = {
 					&af9035_id[AF9035_15A4_1001],
 				},
 			}, {
+				.name = "AVerMedia AVerTV Volar HD/PRO (A835)",
+				.cold_ids = {
+					&af9035_id[AF9035_07CA_A835],
+					&af9035_id[AF9035_07CA_B835],
+				},
+			}, {
 				.name = "AVerMedia HD Volar (A867)",
 				.cold_ids = {
 					&af9035_id[AF9035_07CA_1867],
diff --git a/drivers/media/dvb/dvb-usb/dvb-usb-ids.h b/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
index 3cf002b..6a761c5 100644
--- a/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
+++ b/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
@@ -224,6 +224,8 @@
 #define USB_PID_AVERMEDIA_A850T				0x850b
 #define USB_PID_AVERMEDIA_A805				0xa805
 #define USB_PID_AVERMEDIA_A815M				0x815a
+#define USB_PID_AVERMEDIA_A835				0xa835
+#define USB_PID_AVERMEDIA_B835				0xb835
 #define USB_PID_AVERMEDIA_1867				0x1867
 #define USB_PID_AVERMEDIA_A867				0xa867
 #define USB_PID_TECHNOTREND_CONNECT_S2400               0x3006
diff --git a/drivers/media/dvb/frontends/af9033.c b/drivers/media/dvb/frontends/af9033.c
index 8c0f4a3..5fadee7 100644
--- a/drivers/media/dvb/frontends/af9033.c
+++ b/drivers/media/dvb/frontends/af9033.c
@@ -305,6 +305,10 @@ static int af9033_init(struct dvb_frontend *fe)
 		len = ARRAY_SIZE(tuner_init_mxl5007t);
 		init = tuner_init_mxl5007t;
 		break;
+	case AF9033_TUNER_TDA18218:
+		len = ARRAY_SIZE(tuner_init_tda18218);
+		init = tuner_init_tda18218;
+		break;
 	default:
 		pr_debug("%s: unsupported tuner ID=%d\n", __func__,
 				state->cfg.tuner);
diff --git a/drivers/media/dvb/frontends/af9033.h b/drivers/media/dvb/frontends/af9033.h
index dcf7e29..9e302c3 100644
--- a/drivers/media/dvb/frontends/af9033.h
+++ b/drivers/media/dvb/frontends/af9033.h
@@ -41,6 +41,7 @@ struct af9033_config {
 #define AF9033_TUNER_TUA9001     0x27 /* Infineon TUA 9001 */
 #define AF9033_TUNER_FC0011      0x28 /* Fitipower FC0011 */
 #define AF9033_TUNER_MXL5007T    0xa0 /* MaxLinear MxL5007T */
+#define AF9033_TUNER_TDA18218    0xa1 /* NXP TDA 18218HN */
 	u8 tuner;
 
 	/*
diff --git a/drivers/media/dvb/frontends/af9033_priv.h b/drivers/media/dvb/frontends/af9033_priv.h
index e6041bc..0b783b9 100644
--- a/drivers/media/dvb/frontends/af9033_priv.h
+++ b/drivers/media/dvb/frontends/af9033_priv.h
@@ -432,5 +432,39 @@ static const struct reg_val tuner_init_mxl5007t[] = {
 	{ 0x80f1e6, 0x00 },
 };
 
+/* NXP TDA 18218HN tuner init
+   AF9033_TUNER_TDA18218    = 0xa1 */
+static const struct reg_val tuner_init_tda18218[] = {
+	{0x800046, 0xa1},
+	{0x800057, 0x01},
+	{0x800058, 0x01},
+	{0x80005f, 0x00},
+	{0x800060, 0x00},
+	{0x800071, 0x05},
+	{0x800072, 0x02},
+	{0x800074, 0x01},
+	{0x800079, 0x01},
+	{0x800093, 0x00},
+	{0x800094, 0x00},
+	{0x800095, 0x00},
+	{0x800096, 0x00},
+	{0x8000b3, 0x01},
+	{0x8000c3, 0x01},
+	{0x8000c4, 0x00},
+	{0x80f007, 0x00},
+	{0x80f00c, 0x19},
+	{0x80f00d, 0x1a},
+	{0x80f012, 0xda},
+	{0x80f013, 0x00},
+	{0x80f014, 0x00},
+	{0x80f015, 0x02},
+	{0x80f01f, 0x82},
+	{0x80f020, 0x00},
+	{0x80f029, 0x82},
+	{0x80f02a, 0x00},
+	{0x80f077, 0x02},
+	{0x80f1e6, 0x00},
+};
+
 #endif /* AF9033_PRIV_H */
 
-- 
1.7.5.4

