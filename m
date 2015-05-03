Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f53.google.com ([209.85.215.53]:33691 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340AbbECNBA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 May 2015 09:01:00 -0400
Received: by layy10 with SMTP id y10so88946135lay.0
        for <linux-media@vger.kernel.org>; Sun, 03 May 2015 06:00:58 -0700 (PDT)
From: Olli Salonen <olli.salonen@iki.fi>
To: linux-media@vger.kernel.org
Cc: Olli Salonen <olli.salonen@iki.fi>
Subject: [PATCH v3 6/6] rtl2832: add support for GoTView MasterHD 3 USB tuner
Date: Sun,  3 May 2015 16:00:23 +0300
Message-Id: <1430658023-17579-4-git-send-email-olli.salonen@iki.fi>
In-Reply-To: <1430658023-17579-1-git-send-email-olli.salonen@iki.fi>
References: <1430658023-17579-1-git-send-email-olli.salonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

GoTView MasterHD 3 is a DVB-T2/C USB 2.0 tuner.

It's based on the following components:
- USB bridge: RTL2832P (contains also DVB-T demodulator)
- Demodulator: Si2168-A30
- Tuner: Si2148-A20

The demodulator and the tuner will need firmwares. The Si2148 uses Si2158
firmware. Antti has the firmwares available for download:
http://palosaari.fi/linux/v4l-dvb/firmware/

Do note that for DVB-T either of the demodulators can be used. DVB-C and
DVB-T2 are only supported by the Si2168 demodulator. The driver will
register 2 frontends for the same adapter. Frontend 0 will be the RTL2832
demodulator and frontend 1 will be the Si2168 demodulator. The same
tuner is used for both.

As a consequence of the above, it's recommended to use application that
does implement proper DVBv5 support.

For some reason, the old I2C write method sporadically fails. Thus the
need for an option to only use the new I2C write method supported by the
RTL2832.

Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
---
 drivers/media/dvb-frontends/rtl2832.c      |   4 +
 drivers/media/dvb-frontends/rtl2832.h      |   1 +
 drivers/media/dvb-frontends/rtl2832_priv.h |  25 ++++++
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c    | 117 ++++++++++++++++++++++++++++-
 drivers/media/usb/dvb-usb-v2/rtl28xxu.h    |   5 ++
 5 files changed, 149 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb-frontends/rtl2832.c b/drivers/media/dvb-frontends/rtl2832.c
index 20fa245..08558eb 100644
--- a/drivers/media/dvb-frontends/rtl2832.c
+++ b/drivers/media/dvb-frontends/rtl2832.c
@@ -376,6 +376,10 @@ static int rtl2832_init(struct dvb_frontend *fe)
 		len = ARRAY_SIZE(rtl2832_tuner_init_r820t);
 		init = rtl2832_tuner_init_r820t;
 		break;
+	case RTL2832_TUNER_SI2157:
+		len = ARRAY_SIZE(rtl2832_tuner_init_si2157);
+		init = rtl2832_tuner_init_si2157;
+		break;
 	default:
 		ret = -EINVAL;
 		goto err;
diff --git a/drivers/media/dvb-frontends/rtl2832.h b/drivers/media/dvb-frontends/rtl2832.h
index a8e912e..c6cdcc4 100644
--- a/drivers/media/dvb-frontends/rtl2832.h
+++ b/drivers/media/dvb-frontends/rtl2832.h
@@ -47,6 +47,7 @@ struct rtl2832_platform_data {
 #define RTL2832_TUNER_FC0013    0x29
 #define RTL2832_TUNER_R820T     0x2a
 #define RTL2832_TUNER_R828D     0x2b
+#define RTL2832_TUNER_SI2157    0x2c
 	u8 tuner;
 
 	struct dvb_frontend* (*get_dvb_frontend)(struct i2c_client *);
diff --git a/drivers/media/dvb-frontends/rtl2832_priv.h b/drivers/media/dvb-frontends/rtl2832_priv.h
index c3a922c..a973b8a 100644
--- a/drivers/media/dvb-frontends/rtl2832_priv.h
+++ b/drivers/media/dvb-frontends/rtl2832_priv.h
@@ -377,4 +377,29 @@ static const struct rtl2832_reg_value rtl2832_tuner_init_r820t[] = {
 	{DVBT_SPEC_INV,                  0x1},
 };
 
+static const struct rtl2832_reg_value rtl2832_tuner_init_si2157[] = {
+	{DVBT_DAGC_TRG_VAL,             0x39},
+	{DVBT_AGC_TARG_VAL_0,            0x0},
+	{DVBT_AGC_TARG_VAL_8_1,         0x40},
+	{DVBT_AAGC_LOOP_GAIN,           0x16},
+	{DVBT_LOOP_GAIN2_3_0,            0x8},
+	{DVBT_LOOP_GAIN2_4,              0x1},
+	{DVBT_LOOP_GAIN3,               0x18},
+	{DVBT_VTOP1,                    0x35},
+	{DVBT_VTOP2,                    0x21},
+	{DVBT_VTOP3,                    0x21},
+	{DVBT_KRF1,                      0x0},
+	{DVBT_KRF2,                     0x40},
+	{DVBT_KRF3,                     0x10},
+	{DVBT_KRF4,                     0x10},
+	{DVBT_IF_AGC_MIN,               0x80},
+	{DVBT_IF_AGC_MAX,               0x7f},
+	{DVBT_RF_AGC_MIN,               0x80},
+	{DVBT_RF_AGC_MAX,               0x7f},
+	{DVBT_POLAR_RF_AGC,              0x0},
+	{DVBT_POLAR_IF_AGC,              0x0},
+	{DVBT_AD7_SETTING,            0xe9f4},
+	{DVBT_SPEC_INV,                  0x0},
+};
+
 #endif /* RTL2832_PRIV_H */
diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index 5e0c015..5cc2f12 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -217,7 +217,7 @@ static int rtl28xxu_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 				req.data = &msg[0].buf[1];
 				ret = rtl28xxu_ctrl_msg(d, &req);
 			}
-		} else if (msg[0].len < 23) {
+		} else if ((msg[0].len < 23) && (!dev->new_i2c_write)) {
 			/* method 2 - old I2C */
 			req.value = (msg[0].buf[0] << 8) | (msg[0].addr << 1);
 			req.index = CMD_I2C_WR;
@@ -363,6 +363,8 @@ static int rtl2832u_read_config(struct dvb_usb_device *d)
 	struct rtl28xxu_req req_r828d = {0x0074, CMD_I2C_RD, 1, buf};
 	struct rtl28xxu_req req_mn88472 = {0xff38, CMD_I2C_RD, 1, buf};
 	struct rtl28xxu_req req_mn88473 = {0xff38, CMD_I2C_RD, 1, buf};
+	struct rtl28xxu_req req_si2157 = {0x00c0, CMD_I2C_RD, 1, buf};
+	struct rtl28xxu_req req_si2168 = {0x00c8, CMD_I2C_RD, 1, buf};
 
 	dev_dbg(&d->intf->dev, "\n");
 
@@ -483,6 +485,35 @@ static int rtl2832u_read_config(struct dvb_usb_device *d)
 		goto tuner_found;
 	}
 
+	/* GPIO0 and GPIO5 to reset Si2157/Si2168 tuner and demod */
+	ret = rtl28xxu_wr_reg_mask(d, SYS_GPIO_OUT_VAL, 0x00, 0x21);
+	if (ret)
+		goto err;
+
+	ret = rtl28xxu_wr_reg_mask(d, SYS_GPIO_OUT_EN, 0x00, 0x21);
+	if (ret)
+		goto err;
+
+	msleep(50);
+
+	ret = rtl28xxu_wr_reg_mask(d, SYS_GPIO_OUT_VAL, 0x21, 0x21);
+	if (ret)
+		goto err;
+
+	ret = rtl28xxu_wr_reg_mask(d, SYS_GPIO_OUT_EN, 0x21, 0x21);
+	if (ret)
+		goto err;
+
+	msleep(50);
+
+	/* check Si2157 ID register; reg=c0 val=80 */
+	ret = rtl28xxu_ctrl_msg(d, &req_si2157);
+	if (ret == 0 && ((buf[0] & 0x80) == 0x80)) {
+		dev->tuner = TUNER_RTL2832_SI2157;
+		dev->tuner_name = "SI2157";
+		goto tuner_found;
+	}
+
 tuner_found:
 	dev_dbg(&d->intf->dev, "tuner=%s\n", dev->tuner_name);
 
@@ -516,6 +547,15 @@ tuner_found:
 			goto demod_found;
 		}
 	}
+	if (dev->tuner == TUNER_RTL2832_SI2157) {
+		/* check Si2168 ID register; reg=c8 val=80 */
+		ret = rtl28xxu_ctrl_msg(d, &req_si2168);
+		if (ret == 0 && ((buf[0] & 0x80) == 0x80)) {
+			dev_dbg(&d->intf->dev, "Si2168 found\n");
+			dev->slave_demod = SLAVE_DEMOD_SI2168;
+			goto demod_found;
+		}
+	}
 
 demod_found:
 	/* close demod I2C gate */
@@ -674,6 +714,11 @@ static const struct rtl2832_platform_data rtl2832_r820t_platform_data = {
 	.tuner = TUNER_RTL2832_R820T,
 };
 
+static const struct rtl2832_platform_data rtl2832_si2157_platform_data = {
+	.clk = 28800000,
+	.tuner = TUNER_RTL2832_SI2157,
+};
+
 static int rtl2832u_fc0012_tuner_callback(struct dvb_usb_device *d,
 		int cmd, int arg)
 {
@@ -825,6 +870,9 @@ static int rtl2832u_frontend_attach(struct dvb_usb_adapter *adap)
 	case TUNER_RTL2832_R828D:
 		*pdata = rtl2832_r820t_platform_data;
 		break;
+	case TUNER_RTL2832_SI2157:
+		*pdata = rtl2832_si2157_platform_data;
+		break;
 	default:
 		dev_err(&d->intf->dev, "unknown tuner %s\n", dev->tuner_name);
 		ret = -ENODEV;
@@ -892,7 +940,7 @@ static int rtl2832u_frontend_attach(struct dvb_usb_adapter *adap)
 			}
 
 			dev->i2c_client_slave_demod = client;
-		} else {
+		} else if (dev->slave_demod == SLAVE_DEMOD_MN88473) {
 			struct mn88473_config mn88473_config = {};
 
 			mn88473_config.fe = &adap->fe[1];
@@ -914,9 +962,37 @@ static int rtl2832u_frontend_attach(struct dvb_usb_adapter *adap)
 			}
 
 			dev->i2c_client_slave_demod = client;
+		} else {
+			struct si2168_config si2168_config = {};
+			struct i2c_adapter *adapter;
+
+			si2168_config.i2c_adapter = &adapter;
+			si2168_config.fe = &adap->fe[1];
+			si2168_config.ts_mode = SI2168_TS_SERIAL;
+			si2168_config.ts_clock_inv = false;
+			si2168_config.ts_clock_gapped = true;
+			strlcpy(info.type, "si2168", I2C_NAME_SIZE);
+			info.addr = 0x64;
+			info.platform_data = &si2168_config;
+			request_module(info.type);
+			client = i2c_new_device(&d->i2c_adap, &info);
+			if (client == NULL || client->dev.driver == NULL) {
+				dev->slave_demod = SLAVE_DEMOD_NONE;
+				goto err_slave_demod_failed;
+			}
+
+			if (!try_module_get(client->dev.driver->owner)) {
+				i2c_unregister_device(client);
+				dev->slave_demod = SLAVE_DEMOD_NONE;
+				goto err_slave_demod_failed;
+			}
+
+			dev->i2c_client_slave_demod = client;
+
+			/* for Si2168 devices use only new I2C write method */
+			dev->new_i2c_write = true;
 		}
 	}
-
 	return 0;
 err_slave_demod_failed:
 err:
@@ -1156,6 +1232,39 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
 					adap->fe[1]->ops.tuner_ops.get_rf_strength;
 		}
 		break;
+	case TUNER_RTL2832_SI2157: {
+			struct si2157_config si2157_config = {
+				.fe = adap->fe[0],
+				.if_port = 0,
+				.inversion = false,
+			};
+
+			strlcpy(info.type, "si2157", I2C_NAME_SIZE);
+			info.addr = 0x60;
+			info.platform_data = &si2157_config;
+			request_module(info.type);
+			client = i2c_new_device(&d->i2c_adap, &info);
+			if (client == NULL || client->dev.driver == NULL)
+				break;
+
+			if (!try_module_get(client->dev.driver->owner)) {
+				i2c_unregister_device(client);
+				break;
+			}
+
+			dev->i2c_client_tuner = client;
+			subdev = i2c_get_clientdata(client);
+
+			/* copy tuner ops for 2nd FE as tuner is shared */
+			if (adap->fe[1]) {
+				adap->fe[1]->tuner_priv =
+						adap->fe[0]->tuner_priv;
+				memcpy(&adap->fe[1]->ops.tuner_ops,
+						&adap->fe[0]->ops.tuner_ops,
+						sizeof(struct dvb_tuner_ops));
+			}
+		}
+		break;
 	default:
 		dev_err(&d->intf->dev, "unknown tuner %d\n", dev->tuner);
 	}
@@ -1772,6 +1881,8 @@ static const struct usb_device_id rtl28xxu_id_table[] = {
 	/* RTL2832P devices: */
 	{ DVB_USB_DEVICE(USB_VID_HANFTEK, 0x0131,
 		&rtl28xxu_props, "Astrometa DVB-T2", NULL) },
+	{ DVB_USB_DEVICE(0x5654, 0xca42,
+		&rtl28xxu_props, "GoTView MasterHD 3", NULL) },
 	{ }
 };
 MODULE_DEVICE_TABLE(usb, rtl28xxu_id_table);
diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.h b/drivers/media/usb/dvb-usb-v2/rtl28xxu.h
index 1b5d7ff..9f6115a 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.h
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.h
@@ -41,6 +41,8 @@
 #include "fc2580.h"
 #include "tua9001.h"
 #include "r820t.h"
+#include "si2168.h"
+#include "si2157.h"
 
 /*
  * USB commands
@@ -76,6 +78,7 @@ struct rtl28xxu_dev {
 	u8 page; /* integrated demod active register page */
 	struct i2c_adapter *demod_i2c_adapter;
 	bool rc_active;
+	bool new_i2c_write;
 	struct i2c_client *i2c_client_demod;
 	struct i2c_client *i2c_client_tuner;
 	struct i2c_client *i2c_client_slave_demod;
@@ -83,6 +86,7 @@ struct rtl28xxu_dev {
 	#define SLAVE_DEMOD_NONE           0
 	#define SLAVE_DEMOD_MN88472        1
 	#define SLAVE_DEMOD_MN88473        2
+	#define SLAVE_DEMOD_SI2168         3
 	unsigned int slave_demod:2;
 	union {
 		struct rtl2830_platform_data rtl2830_platform_data;
@@ -116,6 +120,7 @@ enum rtl28xxu_tuner {
 	TUNER_RTL2832_FC0013,
 	TUNER_RTL2832_R820T,
 	TUNER_RTL2832_R828D,
+	TUNER_RTL2832_SI2157,
 };
 
 struct rtl28xxu_req {
-- 
1.9.1

