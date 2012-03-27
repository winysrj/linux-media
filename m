Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:49603 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752771Ab2C0KpP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Mar 2012 06:45:15 -0400
Received: by wibhq7 with SMTP id hq7so5351528wib.1
        for <linux-media@vger.kernel.org>; Tue, 27 Mar 2012 03:45:13 -0700 (PDT)
Message-ID: <4F719A35.30508@gmail.com>
Date: Tue, 27 Mar 2012 12:45:09 +0200
From: Gianluca Gennari <gennarone@gmail.com>
Reply-To: gennarone@gmail.com
MIME-Version: 1.0
To: Sril <willy_the_cat@yahoo.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re : AverTV Volar HD PRO : a return case.
References: <1332797739.83006.YahooMailNeo@web171403.mail.ir2.yahoo.com>
In-Reply-To: <1332797739.83006.YahooMailNeo@web171403.mail.ir2.yahoo.com>
Content-Type: multipart/mixed;
 boundary="------------000504050102020105050001"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------000504050102020105050001
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Il 26/03/2012 23:35, Sril ha scritto:
> Hi,
> 
> Ianswer to mysel to say that I finally have a "working" 07ca:a835 under 3.0.26 kernel with xgazza_af9035 patch.
> The one for 3.2.x crash part of kernel and I still have I2C regs that can not be read.
> 
> So, what tools must do I work on : patch for v4l (build_media) or patch for kernel from xgazza or af903x driver or whatever ?
> Which one is under active building ?
> 
> Thanks for reply.
> 
> Best regards.
> See ya.

Hi Sril,
the only af9035 driver currently under active development is the one
from Hans-Frieder Vogt (af903x).

The patch in attachment is a quick port of the support for the tda18218
tuner (and hence the a835/b835 dongles) from the old drivers that are
floating around (all derived from the xgazza patch).

The problem with the xgazza patch is that it uses the tuner
initialization script and the firmware of another stick (with a
different tuner, the TUA 9001) so it is not working optimally. I have a
07ca:b835 and it works surprisingly well on my systems, but there are
many users (like you) who report I2C errors.

We need to extract a proper firmware and/or initialization script for
the tda18218 from the Windows driver to solve this problems.

There is also a small patch for the tda18218 that is needed to tune VHF
frequencies (with 7MHz bandwidth).

Best regards,
Gianluca

--------------000504050102020105050001
Content-Type: text/x-patch;
 name="dvb-usb-af903x-added-support-for-tda18218-tuner.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dvb-usb-af903x-added-support-for-tda18218-tuner.patch"

dvb-usb-af903x: add support for devices using the tda18218 tuner
Avermedia AVerTV Volar HD (PRO) / A835

Signed-off-by: Gianluca Gennari <gennarone@gmail.com>
---
 drivers/media/dvb/dvb-usb/Kconfig          |    1 +
 drivers/media/dvb/dvb-usb/af903x-devices.c |   19 +++++-
 drivers/media/dvb/dvb-usb/af903x-fe.c      |   27 +++++++
 drivers/media/dvb/dvb-usb/af903x-tuners.c  |  114 ++++++++++++++++++++++++++++
 drivers/media/dvb/dvb-usb/dvb-usb-ids.h    |    2 +
 5 files changed, 162 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/Kconfig b/drivers/media/dvb/dvb-usb/Kconfig
index ad57a93..f854266 100644
--- a/drivers/media/dvb/dvb-usb/Kconfig
+++ b/drivers/media/dvb/dvb-usb/Kconfig
@@ -344,6 +344,7 @@ config DVB_USB_AF903X
 	depends on DVB_USB && EXPERIMENTAL
 	select MEDIA_TUNER_FC0012   if !MEDIA_TUNER_CUSTOMISE
 	select MEDIA_TUNER_MXL5007T if !MEDIA_TUNER_CUSTOMISE
+	select MEDIA_TUNER_TDA18218 if !MEDIA_TUNER_CUSTOMISE
 	help
 	  Say Y here to support the Afatech AF903X based DVB-T USB2.0 receiver
 
diff --git a/drivers/media/dvb/dvb-usb/af903x-devices.c b/drivers/media/dvb/dvb-usb/af903x-devices.c
index 737eea1..112ac88 100644
--- a/drivers/media/dvb/dvb-usb/af903x-devices.c
+++ b/drivers/media/dvb/dvb-usb/af903x-devices.c
@@ -262,6 +262,7 @@ exit:
 extern struct tuner_desc tuner_af9007;
 extern struct tuner_desc tuner_fc0012;
 extern struct tuner_desc tuner_mxl5007t;
+extern struct tuner_desc tuner_tda18218;
 
 static int af903x_set_bus_tuner(struct af903x_dev_ctx *ctx, u16 tuner_id)
 {
@@ -279,6 +280,9 @@ static int af903x_set_bus_tuner(struct af903x_dev_ctx *ctx, u16 tuner_id)
 	case TUNER_MXL5007T:
 		ctx->tuner_desc = &tuner_mxl5007t;
 		break;
+	case TUNER_TDA18218:
+		ctx->tuner_desc = &tuner_tda18218;
+		break;
 	default:
 		err("requested tuner id %d not enabled", tuner_id);
 		ret = -EINVAL;
@@ -682,6 +686,7 @@ static int af903x_identify_state(struct usb_device *udev,
 		props->firmware = "dvb-usb-af9035-04.fw";
 		break;
 	case TUNER_FC0012:
+	case TUNER_TDA18218:
 	default:
 		props->firmware = "dvb-usb-af9035-03.fw";
 		break;
@@ -1105,6 +1110,8 @@ enum af903x_table_entry {
 	AVERMEDIA_0867,
 	AVERMEDIA_F337,
 	AVERMEDIA_3867,
+	AVERMEDIA_VOLAR_HD,     /* Avermedia AVerTV HD / A835 */
+	AVERMEDIA_VOLAR_HD_PRO, /* Avermedia AVerTV HD PRO / A835 */
 };
 
 struct usb_device_id af903x_usb_table[] = {
@@ -1140,6 +1147,10 @@ struct usb_device_id af903x_usb_table[] = {
 				USB_PID_AVERMEDIA_F337)},
 	[AVERMEDIA_3867] = {USB_DEVICE(USB_VID_AVERMEDIA,
 				USB_PID_AVERMEDIA_3867)},
+	[AVERMEDIA_VOLAR_HD] = {USB_DEVICE(USB_VID_AVERMEDIA,
+				USB_PID_AVERMEDIA_A835)},
+	[AVERMEDIA_VOLAR_HD_PRO] = {USB_DEVICE(USB_VID_AVERMEDIA,
+				USB_PID_AVERMEDIA_B835)},
 	{ 0},		/* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, af903x_usb_table);
@@ -1222,7 +1233,7 @@ struct dvb_usb_device_properties af903x_properties[] = {
 			.rc_codes	= NULL, /* will be set in
 						   af903x_identify_state */
 		},
-		.num_device_descs =6,
+		.num_device_descs = 7,
 		.devices =  {
 			{
 				"ITEtech AF903x USB2.0 DVB-T Recevier",
@@ -1249,6 +1260,12 @@ struct dvb_usb_device_properties af903x_properties[] = {
 				{ NULL },
 			},
 			{
+				"Avermedia AverTV Volar HD & HD PRO (A835)",
+				{ &af903x_usb_table[AVERMEDIA_VOLAR_HD],
+				  &af903x_usb_table[AVERMEDIA_VOLAR_HD_PRO], NULL},
+				{ NULL },
+			},
+			{
 				"AVerMedia A333 DVB-T Receiver",
 				{ &af903x_usb_table[AVERMEDIA_A333],
 				  &af903x_usb_table[AVERMEDIA_B867], NULL},
diff --git a/drivers/media/dvb/dvb-usb/af903x-fe.c b/drivers/media/dvb/dvb-usb/af903x-fe.c
index 71b775d..0e81b5f 100644
--- a/drivers/media/dvb/dvb-usb/af903x-fe.c
+++ b/drivers/media/dvb/dvb-usb/af903x-fe.c
@@ -30,6 +30,7 @@
 #include "dvb_frontend.h"
 #include "fc0012.h"
 #include "mxl5007t.h"
+#include "tda18218.h"
 
 #define AF903X_FE_FREQ_MIN 44250000
 #define AF903X_FE_FREQ_MAX 867250000
@@ -1967,6 +1968,16 @@ static struct mxl5007t_config af903x_mxl5007t_config[] = {
 	}
 };
 
+static struct tda18218_config af903x_tda18218_config[] = {
+	{
+		.i2c_address = 0xc0,
+		.i2c_wr_max = 21, /* max wr bytes AF9015 I2C adap can handle at once */
+	} , {
+		.i2c_address = 0xc1,
+		.i2c_wr_max = 21, /* max wr bytes AF9015 I2C adap can handle at once */
+	}
+};
+
 static struct dvb_frontend_ops af903x_ops;
 struct dvb_frontend *af903x_fe_attach(struct i2c_adapter *i2c_adap, int id,
 	struct af903x_dev_ctx *ctx)
@@ -2016,6 +2027,22 @@ struct dvb_frontend *af903x_fe_attach(struct i2c_adapter *i2c_adap, int id,
 			ctx->tuner_desc->tuner_addr + 1,
 			&af903x_mxl5007t_config[id]) == NULL ? -ENODEV : 0;
 		break;
+	case TUNER_TDA18218:
+		if (id == 0) {
+			ret = af9035_wr_reg(udev, 0, PRO_LINK, GPIOT2_EN, 1);
+			ret = af9035_wr_reg(udev, 0, PRO_LINK, GPIOT2_ON, 1);
+			ret = af9035_wr_reg(udev, 0, PRO_LINK, GPIOT3_EN, 1);
+			ret = af9035_wr_reg(udev, 0, PRO_LINK, GPIOT3_ON, 1);
+			/* reset tuner */
+			ret = af9035_wr_reg(udev, 0, PRO_LINK, GPIOT3_O, 0);
+			msleep(1);
+			ret = af9035_wr_reg(udev, 0, PRO_LINK, GPIOT3_O, 1);
+			/* activate tuner - TODO: do that like I2C gate control */
+			ret = af9035_wr_reg(udev, 0, PRO_LINK, GPIOT2_O, 1);
+		}
+		ret = dvb_attach(tda18218_attach, frontend, i2c_adap,
+			&af903x_tda18218_config[id]) == NULL ? -ENODEV : 0;
+		break;
 	default:
 		err("tuner 0x%02x currently not supported!",
 			ctx->tuner_desc->tunerId);
diff --git a/drivers/media/dvb/dvb-usb/af903x-tuners.c b/drivers/media/dvb/dvb-usb/af903x-tuners.c
index 0f4864b..6e59d12 100644
--- a/drivers/media/dvb/dvb-usb/af903x-tuners.c
+++ b/drivers/media/dvb/dvb-usb/af903x-tuners.c
@@ -445,3 +445,117 @@ struct tuner_desc tuner_mxl5007t = {
 	true,			/* spectrum inverse */
 	TUNER_MXL5007T,		/* tuner id */
 };
+
+static u16 tda18218_script_sets[] = {
+	0x24
+};
+
+static struct af903x_val_set tda18218_scripts[] = {
+        {0x0046, 0x27},	/* TUNER_ID */
+        {0x0071, 0x05},
+        {0x0072, 0x02},
+        {0x0074, 0x01},
+        {0x0075, 0x03},
+        {0x0076, 0x02},
+        {0x0077, 0x00},
+        {0x0078, 0x01},
+        {0x007a, 0x7e},
+        {0x007b, 0x3e},
+        {0x0098, 0x0a},
+        {0x00b3, 0x00},
+        {0xf007, 0x00},
+        {0xf01f, 0x82},
+        {0xf020, 0x00},
+        {0xf047, 0x00},
+        {0xf077, 0x01},
+        {0xf1e6, 0x00},
+        {0x0057, 0x00},
+        {0x0058, 0x01},
+        {0x005f, 0x00},
+        {0x0060, 0x00},
+        {0x006d, 0x00},
+        {0x0079, 0x00},
+        {0x0093, 0x00},
+        {0x0094, 0x01},
+        {0x0095, 0x02},
+        {0x0096, 0x01},
+        {0x009b, 0x05},
+        {0x009c, 0x80},
+        {0x00c1, 0x01},
+        {0x00c2, 0x00},
+        {0xf029, 0x82},
+        {0xf02a, 0x00},
+        {0xf054, 0x00},
+        {0xf055, 0x00},
+};
+
+static int af903x_tda18218_init(struct af903x_dev_ctx *ctx, int chip)
+{
+	int ret = 0;
+	struct dvb_frontend *fe = ctx->fe[chip];
+
+	/* no special treatment here ? */
+	if (ctx->tuner_init)
+		ret = ctx->tuner_init(fe);
+
+        return ret;
+}
+
+static int af903x_tda18218_sleep(struct af903x_dev_ctx *ctx, int chip)
+{
+	int ret = 0;
+	struct dvb_frontend *fe = ctx->fe[chip];
+
+	/* no special treatment here ? */
+	if (ctx->tuner_sleep)
+		ret = ctx->tuner_sleep(fe);
+
+        return ret;
+}
+
+static int af903x_tda18218_set(struct af903x_dev_ctx *ctx, int chip,
+	u32 bandwidth, u32 frequency)
+{
+	int ret = 0;
+	struct dvb_frontend *fe = ctx->fe[chip];
+#ifdef V4L2_ONLY_DVB_V5
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
+
+	p->frequency = frequency;
+	p->bandwidth_hz = bandwidth;
+
+	if (fe->ops.tuner_ops.set_params)
+		ret = fe->ops.tuner_ops.set_params(fe);
+#else
+	struct dvb_frontend_parameters params;
+
+	params.frequency = frequency;
+	switch (bandwidth) {
+	case 6000000:
+		params.u.ofdm.bandwidth = BANDWIDTH_6_MHZ;
+		break;
+	case 7000000:
+		params.u.ofdm.bandwidth = BANDWIDTH_7_MHZ;
+		break;
+	default:
+		params.u.ofdm.bandwidth = BANDWIDTH_8_MHZ;
+		break;
+	}
+	if (fe->ops.tuner_ops.set_params)
+		ret = fe->ops.tuner_ops.set_params(fe, &params);
+#endif
+	return ret;
+}
+
+struct tuner_desc tuner_tda18218 = {
+	af903x_tda18218_init,
+	af903x_tda18218_sleep,
+	af903x_tda18218_set,
+	tda18218_scripts,
+	tda18218_script_sets,
+	0xc0,			/* tuner i2c address */
+	1,			/* length of tuner register address */
+	4570000,		/* tuner if */
+	true,			/* spectrum inverse */
+	TUNER_TDA18218,		/* tuner id */
+};
diff --git a/drivers/media/dvb/dvb-usb/dvb-usb-ids.h b/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
index 3b92563..806b18f 100644
--- a/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
+++ b/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
@@ -227,6 +227,8 @@
 #define USB_PID_AVERMEDIA_A805				0xa805
 #define USB_PID_AVERMEDIA_A815M				0x815a
 #define USB_PID_AVERMEDIA_A825				0x0825
+#define USB_PID_AVERMEDIA_A835				0xa835
+#define USB_PID_AVERMEDIA_B835				0xb835
 #define USB_PID_AVERMEDIA_A333				0xa333
 #define USB_PID_AVERMEDIA_B867				0xb867
 #define USB_PID_AVERMEDIA_1867				0x1867
-- 
1.7.5.4


--------------000504050102020105050001
Content-Type: text/x-patch;
 name="tda18218-fixed-IF-frequency-for-7-MHz-bandwidth-channels.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="tda18218-fixed-IF-frequency-for-7-MHz-bandwidth-channels.pat";
 filename*1="ch"

tda18218: fixed IF frequency for 7 MHz bandwidth channels

Signed-off-by: Gianluca Gennari <gennarone@gmail.com>
---
 drivers/media/common/tuners/tda18218.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/common/tuners/tda18218.c b/drivers/media/common/tuners/tda18218.c
index dfb3a83..b079696 100644
--- a/drivers/media/common/tuners/tda18218.c
+++ b/drivers/media/common/tuners/tda18218.c
@@ -144,7 +144,7 @@ static int tda18218_set_params(struct dvb_frontend *fe)
 		priv->if_frequency = 3000000;
 	} else if (bw <= 7000000) {
 		LP_Fc = 1;
-		priv->if_frequency = 3500000;
+		priv->if_frequency = 4000000;
 	} else {
 		LP_Fc = 2;
 		priv->if_frequency = 4000000;
-- 
1.7.0.4


--------------000504050102020105050001--
