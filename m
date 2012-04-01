Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:56436 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752343Ab2DARP4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Apr 2012 13:15:56 -0400
From: "Hans-Frieder Vogt" <hfvogt@gmx.net>
To: Antti Palosaari <crope@iki.fi>
Subject: [PATCH][GIT PULL FOR 3.5] AF9035/AF9033/TUA9001 support for AverTV A867R (mxl5007t tuner)
Date: Sun, 1 Apr 2012 19:15:47 +0200
Cc: linux-media@vger.kernel.org
References: <4F75A7FE.8090405@iki.fi> <20120331185217.2c82c4ad@milhouse> <4F77DED5.2040103@iki.fi>
In-Reply-To: <4F77DED5.2040103@iki.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201204011915.47265.hfvogt@gmx.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Support of AVerMedia AVerTV HD Volar, with tuner MxL5007t (needs the i2c read bug fixed patch send earlier).

Signed-off-by: Hans-Frieder Vogt <hfvogt@gmx.net>

 drivers/media/dvb/dvb-usb/af9033.c      |   36 +++++++++++---
 drivers/media/dvb/dvb-usb/af9033.h      |    6 ++
 drivers/media/dvb/dvb-usb/af9033_priv.h |   35 ++++++++++++++
 drivers/media/dvb/dvb-usb/af9035.c      |   78 +++++++++++++++++++++++++++++---
 drivers/media/dvb/dvb-usb/af9035.h      |   31 +++++++-----
 drivers/media/dvb/dvb-usb/dvb-usb-ids.h |    1 
 6 files changed, 158 insertions(+), 29 deletions(-)

diff -Nupr a/drivers/media/dvb/dvb-usb/af9033.c b/drivers/media/dvb/dvb-usb/af9033.c
--- a/drivers/media/dvb/dvb-usb/af9033.c	2012-03-31 17:41:11.584990674 +0200
+++ b/drivers/media/dvb/dvb-usb/af9033.c	2012-04-01 19:03:01.119522845 +0200
@@ -297,6 +297,10 @@ static int af9033_init(struct dvb_fronte
 		len = ARRAY_SIZE(tuner_init_tua9001);
 		init = tuner_init_tua9001;
 		break;
+	case AF9033_TUNER_MXL5007T:
+		len = ARRAY_SIZE(tuner_init_mxl5007t);
+		init = tuner_init_mxl5007t;
+		break;
 	default:
 		pr_debug("%s: unsupported tuner ID=%d\n", __func__,
 				state->cfg.tuner);
@@ -387,9 +391,9 @@ static int af9033_set_frontend(struct dv
 {
 	struct af9033_state *state = fe->demodulator_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
-	int ret, i;
+	int ret, i, spec_inv;
 	u8 tmp, buf[3], bandwidth_reg_val;
-	u32 if_frequency, freq_cw;
+	u32 if_frequency, freq_cw, adc_freq;
 
 	pr_debug("%s: frequency=%d bandwidth_hz=%d\n", __func__, c->frequency,
 			c->bandwidth_hz);
@@ -429,22 +433,36 @@ static int af9033_set_frontend(struct dv
 
 	/* program frequency control */
 	if (c->bandwidth_hz != state->bandwidth_hz) {
+		spec_inv = state->cfg.spec_inv ? -1 : 1;
+		adc_freq = state->cfg.adc_clock;
+
 		/* get used IF frequency */
 		if (fe->ops.tuner_ops.get_if_frequency)
 			fe->ops.tuner_ops.get_if_frequency(fe, &if_frequency);
 		else
 			if_frequency = 0;
 
-		/* FIXME: we support only Zero-IF currently */
-		if (if_frequency != 0) {
-			pr_debug("%s: only Zero-IF supported currently\n",
-				__func__);
+		while (if_frequency > (adc_freq / 2))
+			if_frequency -= adc_freq;
+
+		if (if_frequency >= 0)
+			spec_inv *= -1;
+		else
+			if_frequency *= -1;
+
+		freq_cw = af9033_div(if_frequency, adc_freq, 23ul);
+
+		if (spec_inv == -1)
+			freq_cw *= -1;
 
-			ret = -ENODEV;
+		/* get adc multiplies */
+		ret = af9033_rd_reg(state, 0x800045, &tmp);
+		if (ret < 0)
 			goto err;
-		}
 
-		freq_cw = 0;
+		if (tmp == 1)
+			freq_cw /= 2;
+
 		buf[0] = (freq_cw >>  0) & 0xff;
 		buf[1] = (freq_cw >>  8) & 0xff;
 		buf[2] = (freq_cw >> 16) & 0x7f;
diff -Nupr a/drivers/media/dvb/dvb-usb/af9033.h b/drivers/media/dvb/dvb-usb/af9033.h
--- a/drivers/media/dvb/dvb-usb/af9033.h	2012-03-31 17:41:11.584990674 +0200
+++ b/drivers/media/dvb/dvb-usb/af9033.h	2012-04-01 17:52:42.851767290 +0200
@@ -36,10 +36,16 @@ struct af9033_config {
 	u32 clock;
 
 	/*
+	 * ADC clock Hz
+	 */
+	u32 adc_clock;
+
+	/*
 	 * tuner
 	 */
 #define AF9033_TUNER_TUA9001     0x27 /* Infineon TUA 9001 */
 #define AF9033_TUNER_FC0011      0x28 /* Fitipower FC0011 */
+#define AF9033_TUNER_MXL5007T    0xa0 /* MaxLinear MxL5007T */
 	u8 tuner;
 
 	/*
diff -Nupr a/drivers/media/dvb/dvb-usb/af9033_priv.h b/drivers/media/dvb/dvb-usb/af9033_priv.h
--- a/drivers/media/dvb/dvb-usb/af9033_priv.h	2012-03-31 17:41:11.584990674 +0200
+++ b/drivers/media/dvb/dvb-usb/af9033_priv.h	2012-04-01 17:30:34.989592418 +0200
@@ -238,5 +238,40 @@ static const struct reg_val tuner_init_t
 	{ 0x80f1e6, 0x00 },
 };
 
+/* MaxLinear MxL5007T tuner init
+   AF9033_TUNER_MXL5007T    = 0xa0 */
+static const struct reg_val tuner_init_mxl5007t[] = {
+	{ 0x800046, 0x1b },
+	{ 0x800057, 0x01 },
+	{ 0x800058, 0x01 },
+	{ 0x80005f, 0x00 },
+	{ 0x800060, 0x00 },
+	{ 0x800068, 0x96 },
+	{ 0x800071, 0x05 },
+	{ 0x800072, 0x02 },
+	{ 0x800074, 0x01 },
+	{ 0x800079, 0x01 },
+	{ 0x800093, 0x00 },
+	{ 0x800094, 0x00 },
+	{ 0x800095, 0x00 },
+	{ 0x800096, 0x00 },
+	{ 0x8000b3, 0x01 },
+	{ 0x8000c1, 0x01 },
+	{ 0x8000c2, 0x00 },
+	{ 0x80f007, 0x00 },
+	{ 0x80f00c, 0x19 },
+	{ 0x80f00d, 0x1a },
+	{ 0x80f012, 0xda },
+	{ 0x80f013, 0x00 },
+	{ 0x80f014, 0x00 },
+	{ 0x80f015, 0x02 },
+	{ 0x80f01f, 0x82 },
+	{ 0x80f020, 0x00 },
+	{ 0x80f029, 0x82 },
+	{ 0x80f02a, 0x00 },
+	{ 0x80f077, 0x02 },
+	{ 0x80f1e6, 0x00 },
+};
+
 #endif /* AF9033_PRIV_H */
 
diff -Nupr a/drivers/media/dvb/dvb-usb/af9035.c b/drivers/media/dvb/dvb-usb/af9035.c
--- a/drivers/media/dvb/dvb-usb/af9035.c	2012-04-01 18:22:25.026930784 +0200
+++ b/drivers/media/dvb/dvb-usb/af9035.c	2012-04-01 19:03:21.796053677 +0200
@@ -22,6 +22,7 @@
 #include "af9035.h"
 #include "af9033.h"
 #include "tua9001.h"
+#include "mxl5007t.h"
 
 DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 static DEFINE_MUTEX(af9035_usb_mutex);
@@ -214,8 +215,8 @@ static int af9035_i2c_master_xfer(struct
 					buf, msg[1].len, msg[1].buf };
 			buf[0] = msg[1].len;
 			buf[1] = msg[0].addr << 1;
-			buf[2] = 0x01;
-			buf[3] = 0x00;
+			buf[2] = 0x01;	/* address size */
+			buf[3] = 0x00;	/* high byte of reg. address */
 			memcpy(&buf[4], msg[0].buf, msg[0].len);
 			ret = af9035_ctrl_msg(d->udev, &req);
 		}
@@ -236,8 +237,8 @@ static int af9035_i2c_master_xfer(struct
 					0, NULL };
 			buf[0] = msg[0].len;
 			buf[1] = msg[0].addr << 1;
-			buf[2] = 0x01;
-			buf[3] = 0x00;
+			buf[2] = 0x01;	/* address size */
+			buf[3] = 0x00;	/* high byte of reg. address */
 			memcpy(&buf[4], msg[0].buf, msg[0].len);
 			ret = af9035_ctrl_msg(d->udev, &req);
 		}
@@ -471,6 +472,7 @@ static int af9035_read_mac_address(struc
 
 		switch (tmp) {
 		case AF9033_TUNER_TUA9001:
+		case AF9033_TUNER_MXL5007T:
 			af9035_af9033_config[i].spec_inv = 1;
 			break;
 		default:
@@ -504,8 +506,10 @@ static int af9035_read_mac_address(struc
 
 	tmp = (tmp >> 0) & 0x0f;
 
-	for (i = 0; i < af9035_properties[0].num_adapters; i++)
-		af9035_af9033_config[i].clock = clock_lut[tmp];
+	for (i = 0; i < af9035_properties[0].num_adapters; i++) {
+		af9035_af9033_config[i].clock = clock_lut[tmp].crystal;
+		af9035_af9033_config[i].adc_clock = clock_lut[tmp].adc;
+	}
 
 	return 0;
 
@@ -556,6 +560,15 @@ static struct tua9001_config af9035_tua9
 	.i2c_addr = 0x60,
 };
 
+static struct mxl5007t_config af9035_mxl5007t_config = {
+	.xtal_freq_hz = MxL_XTAL_24_MHZ,
+	.if_freq_hz = MxL_IF_4_57_MHZ,
+	.invert_if = 0,
+	.loop_thru_enable = 0,
+	.clk_out_enable = 0,
+	.clk_out_amp = MxL_CLKOUT_AMP_0_94V,
+};
+
 static int af9035_tuner_attach(struct dvb_usb_adapter *adap)
 {
 	int ret;
@@ -604,6 +617,48 @@ static int af9035_tuner_attach(struct dv
 		fe = dvb_attach(tua9001_attach, adap->fe_adap[0].fe,
 				&adap->dev->i2c_adap, &af9035_tua9001_config);
 		break;
+	case AF9033_TUNER_MXL5007T:
+		ret = af9035_wr_reg(adap->dev, 0x00d8e0, 1);
+		if (ret < 0)
+			goto err;
+		ret = af9035_wr_reg(adap->dev, 0x00d8e1, 1);
+		if (ret < 0)
+			goto err;
+		ret = af9035_wr_reg(adap->dev, 0x00d8df, 0);
+		if (ret < 0)
+			goto err;
+
+		msleep(30);
+
+		ret = af9035_wr_reg(adap->dev, 0x00d8df, 1);
+		if (ret < 0)
+			goto err;
+
+		msleep(300);
+
+		ret = af9035_wr_reg(adap->dev, 0x00d8c0, 1);
+		if (ret < 0)
+			goto err;
+		ret = af9035_wr_reg(adap->dev, 0x00d8c1, 1);
+		if (ret < 0)
+			goto err;
+		ret = af9035_wr_reg(adap->dev, 0x00d8bf, 0);
+		if (ret < 0)
+			goto err;
+		ret = af9035_wr_reg(adap->dev, 0x00d8b4, 1);
+		if (ret < 0)
+			goto err;
+		ret = af9035_wr_reg(adap->dev, 0x00d8b5, 1);
+		if (ret < 0)
+			goto err;
+		ret = af9035_wr_reg(adap->dev, 0x00d8b3, 1);
+		if (ret < 0)
+			goto err;
+
+		/* attach tuner */
+		fe = dvb_attach(mxl5007t_attach, adap->fe_adap[0].fe,
+				&adap->dev->i2c_adap, 0x60, &af9035_mxl5007t_config);
+		break;
 	default:
 		fe = NULL;
 	}
@@ -623,11 +678,14 @@ err:
 
 enum af9035_id_entry {
 	AF9035_0CCD_0093,
+	AF9035_07CA_1867,
 };
 
 static struct usb_device_id af9035_id[] = {
 	[AF9035_0CCD_0093] = {
 		USB_DEVICE(USB_VID_TERRATEC, USB_PID_TERRATEC_CINERGY_T_STICK)},
+	[AF9035_07CA_1867] = {
+		USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_1867)},
 	{},
 };
 
@@ -670,7 +728,7 @@ static struct dvb_usb_device_properties
 
 		.i2c_algo = &af9035_i2c_algo,
 
-		.num_device_descs = 1,
+		.num_device_descs = 2,
 		.devices = {
 			{
 				.name = "TerraTec Cinergy T Stick",
@@ -678,6 +736,12 @@ static struct dvb_usb_device_properties
 					&af9035_id[AF9035_0CCD_0093],
 				},
 			},
+			{
+				.name = "AVerMedia HD Volar",
+				.cold_ids = {
+					&af9035_id[AF9035_07CA_1867],
+				},
+			},
 		}
 	},
 };
diff -Nupr a/drivers/media/dvb/dvb-usb/af9035.h b/drivers/media/dvb/dvb-usb/af9035.h
--- a/drivers/media/dvb/dvb-usb/af9035.h	2012-04-01 16:42:16.680606002 +0200
+++ b/drivers/media/dvb/dvb-usb/af9035.h	2012-04-01 17:51:37.739010279 +0200
@@ -66,19 +66,24 @@ struct fw_header {
 	struct fw_segment segment[SEGMENT_MAX_COUNT];
 };
 
-u32 clock_lut[] = {
-	20480000, /*      FPGA */
-	16384000, /* 16.38 MHz */
-	20480000, /* 20.48 MHz */
-	36000000, /* 36.00 MHz */
-	30000000, /* 30.00 MHz */
-	26000000, /* 26.00 MHz */
-	28000000, /* 28.00 MHz */
-	32000000, /* 32.00 MHz */
-	34000000, /* 34.00 MHz */
-	24000000, /* 24.00 MHz */
-	22000000, /* 22.00 MHz */
-	12000000, /* 12.00 MHz */
+struct af9035_clock {
+	u32 crystal;
+	u32 adc;
+};
+
+struct af9035_clock clock_lut[] = {
+	{ 20480000, 20480000 }, /*      FPGA */
+	{ 16384000, 20480000 }, /* 16.38 MHz */
+	{ 20480000, 20480000 }, /* 20.48 MHz */
+	{ 36000000, 20250000 }, /* 36.00 MHz */
+	{ 30000000, 20156250 }, /* 30.00 MHz */
+	{ 26000000, 20583333 }, /* 26.00 MHz */
+	{ 28000000, 20416667 }, /* 28.00 MHz */
+	{ 32000000, 20500000 }, /* 32.00 MHz */
+	{ 34000000, 20187500 }, /* 34.00 MHz */
+	{ 24000000, 20500000 }, /* 24.00 MHz */
+	{ 22000000, 20625000 }, /* 22.00 MHz */
+	{ 12000000, 20250000 }  /* 12.00 MHz */
 };
 
 /* EEPROM locations */
diff -Nupr a/drivers/media/dvb/dvb-usb/dvb-usb-ids.h b/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
--- a/drivers/media/dvb/dvb-usb/dvb-usb-ids.h	2012-03-09 05:45:19.000000000 +0100
+++ b/drivers/media/dvb/dvb-usb/dvb-usb-ids.h	2012-04-01 18:42:11.646802238 +0200
@@ -221,6 +221,7 @@
 #define USB_PID_AVERMEDIA_A850T				0x850b
 #define USB_PID_AVERMEDIA_A805				0xa805
 #define USB_PID_AVERMEDIA_A815M				0x815a
+#define USB_PID_AVERMEDIA_1867				0x1867
 #define USB_PID_TECHNOTREND_CONNECT_S2400               0x3006
 #define USB_PID_TECHNOTREND_CONNECT_CT3650		0x300d
 #define USB_PID_TERRATEC_CINERGY_DT_XS_DIVERSITY	0x005a


Hans-Frieder Vogt                       e-mail: hfvogt <at> gmx .dot. net
