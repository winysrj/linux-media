Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([91.232.154.25]:33975 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932786AbeCMXkO (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Mar 2018 19:40:14 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 09/18] af9015: attach demod using i2c binding
Date: Wed, 14 Mar 2018 01:39:35 +0200
Message-Id: <20180313233944.7234-9-crope@iki.fi>
In-Reply-To: <20180313233944.7234-1-crope@iki.fi>
References: <20180313233944.7234-1-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

af9013 demod driver has i2c binding. Use it.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/af9015.c | 158 ++++++++++++++++++++--------------
 drivers/media/usb/dvb-usb-v2/af9015.h |   4 +-
 2 files changed, 96 insertions(+), 66 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/af9015.c b/drivers/media/usb/dvb-usb-v2/af9015.c
index 7e4cce05b911..f07aa42535e5 100644
--- a/drivers/media/usb/dvb-usb-v2/af9015.c
+++ b/drivers/media/usb/dvb-usb-v2/af9015.c
@@ -148,8 +148,8 @@ static int af9015_write_reg_i2c(struct dvb_usb_device *d, u8 addr, u16 reg,
 	struct af9015_state *state = d_to_priv(d);
 	struct req_t req = {WRITE_I2C, addr, reg, 1, 1, 1, &val};
 
-	if (addr == state->af9013_config[0].i2c_addr ||
-	    addr == state->af9013_config[1].i2c_addr)
+	if (addr == state->af9013_i2c_addr[0] ||
+	    addr == state->af9013_i2c_addr[1])
 		req.addr_len = 3;
 
 	return af9015_ctrl_msg(d, &req);
@@ -161,8 +161,8 @@ static int af9015_read_reg_i2c(struct dvb_usb_device *d, u8 addr, u16 reg,
 	struct af9015_state *state = d_to_priv(d);
 	struct req_t req = {READ_I2C, addr, reg, 0, 1, 1, val};
 
-	if (addr == state->af9013_config[0].i2c_addr ||
-	    addr == state->af9013_config[1].i2c_addr)
+	if (addr == state->af9013_i2c_addr[0] ||
+	    addr == state->af9013_i2c_addr[1])
 		req.addr_len = 3;
 
 	return af9015_ctrl_msg(d, &req);
@@ -258,7 +258,7 @@ Due to that the only way to select correct tuner is use demodulator I2C-gate.
 			ret = -EOPNOTSUPP;
 			goto err;
 		}
-		if (msg[0].addr == state->af9013_config[0].i2c_addr)
+		if (msg[0].addr == state->af9013_i2c_addr[0])
 			req.cmd = WRITE_MEMORY;
 		else
 			req.cmd = WRITE_I2C;
@@ -276,7 +276,7 @@ Due to that the only way to select correct tuner is use demodulator I2C-gate.
 			ret = -EOPNOTSUPP;
 			goto err;
 		}
-		if (msg[0].addr == state->af9013_config[0].i2c_addr)
+		if (msg[0].addr == state->af9013_i2c_addr[0])
 			req.cmd = READ_MEMORY;
 		else
 			req.cmd = READ_I2C;
@@ -293,7 +293,7 @@ Due to that the only way to select correct tuner is use demodulator I2C-gate.
 			ret = -EOPNOTSUPP;
 			goto err;
 		}
-		if (msg[0].addr == state->af9013_config[0].i2c_addr) {
+		if (msg[0].addr == state->af9013_i2c_addr[0]) {
 			ret = -EINVAL;
 			goto err;
 		}
@@ -478,7 +478,7 @@ static int af9015_read_config(struct dvb_usb_device *d)
 	if (d->udev->speed == USB_SPEED_FULL)
 		state->dual_mode = 0;
 
-	state->af9013_config[0].i2c_addr = AF9015_I2C_DEMOD;
+	state->af9013_i2c_addr[0] = AF9015_I2C_DEMOD;
 
 	if (state->dual_mode) {
 		/* read 2nd demodulator I2C address */
@@ -487,7 +487,7 @@ static int af9015_read_config(struct dvb_usb_device *d)
 		if (ret)
 			goto error;
 
-		state->af9013_config[1].i2c_addr = val >> 1;
+		state->af9013_i2c_addr[1] = val >> 1;
 	}
 
 	for (i = 0; i < state->dual_mode + 1; i++) {
@@ -500,20 +500,20 @@ static int af9015_read_config(struct dvb_usb_device *d)
 			goto error;
 		switch (val) {
 		case 0:
-			state->af9013_config[i].clock = 28800000;
+			state->af9013_pdata[i].clk = 28800000;
 			break;
 		case 1:
-			state->af9013_config[i].clock = 20480000;
+			state->af9013_pdata[i].clk = 20480000;
 			break;
 		case 2:
-			state->af9013_config[i].clock = 28000000;
+			state->af9013_pdata[i].clk = 28000000;
 			break;
 		case 3:
-			state->af9013_config[i].clock = 25000000;
+			state->af9013_pdata[i].clk = 25000000;
 			break;
 		}
-		dev_dbg(&intf->dev, "[%d] xtal %02x, clock %u\n",
-			i, val, state->af9013_config[i].clock);
+		dev_dbg(&intf->dev, "[%d] xtal %02x, clk %u\n",
+			i, val, state->af9013_pdata[i].clk);
 
 		/* IF frequency */
 		req.addr = AF9015_EEPROM_IF1H + offset;
@@ -521,17 +521,17 @@ static int af9015_read_config(struct dvb_usb_device *d)
 		if (ret)
 			goto error;
 
-		state->af9013_config[i].if_frequency = val << 8;
+		state->af9013_pdata[i].if_frequency = val << 8;
 
 		req.addr = AF9015_EEPROM_IF1L + offset;
 		ret = af9015_ctrl_msg(d, &req);
 		if (ret)
 			goto error;
 
-		state->af9013_config[i].if_frequency += val;
-		state->af9013_config[i].if_frequency *= 1000;
+		state->af9013_pdata[i].if_frequency += val;
+		state->af9013_pdata[i].if_frequency *= 1000;
 		dev_dbg(&intf->dev, "[%d] if frequency %u\n",
-			i, state->af9013_config[i].if_frequency);
+			i, state->af9013_pdata[i].if_frequency);
 
 		/* MT2060 IF1 */
 		req.addr = AF9015_EEPROM_MT2060_IF1H  + offset;
@@ -561,17 +561,17 @@ static int af9015_read_config(struct dvb_usb_device *d)
 		case AF9013_TUNER_TDA18271:
 		case AF9013_TUNER_QT1010A:
 		case AF9013_TUNER_TDA18218:
-			state->af9013_config[i].spec_inv = 1;
+			state->af9013_pdata[i].spec_inv = 1;
 			break;
 		case AF9013_TUNER_MXL5003D:
 		case AF9013_TUNER_MXL5005D:
 		case AF9013_TUNER_MXL5005R:
 		case AF9013_TUNER_MXL5007T:
-			state->af9013_config[i].spec_inv = 0;
+			state->af9013_pdata[i].spec_inv = 0;
 			break;
 		case AF9013_TUNER_MC44S803:
-			state->af9013_config[i].gpio[1] = AF9013_GPIO_LO;
-			state->af9013_config[i].spec_inv = 1;
+			state->af9013_pdata[i].gpio[1] = AF9013_GPIO_LO;
+			state->af9013_pdata[i].spec_inv = 1;
 			break;
 		default:
 			dev_err(&intf->dev,
@@ -580,7 +580,7 @@ static int af9015_read_config(struct dvb_usb_device *d)
 			return -ENODEV;
 		}
 
-		state->af9013_config[i].tuner = val;
+		state->af9013_pdata[i].tuner = val;
 		dev_dbg(&intf->dev, "[%d] tuner id %02x\n", i, val);
 	}
 
@@ -601,7 +601,7 @@ static int af9015_read_config(struct dvb_usb_device *d)
 		state->dual_mode = 0;
 
 		/* set correct IF */
-		state->af9013_config[0].if_frequency = 4570000;
+		state->af9013_pdata[0].if_frequency = 4570000;
 	}
 
 	return ret;
@@ -741,7 +741,7 @@ static int af9015_copy_firmware(struct dvb_usb_device *d)
 	fw_params[2] = state->firmware_checksum >> 8;
 	fw_params[3] = state->firmware_checksum & 0xff;
 
-	ret = af9015_read_reg_i2c(d, state->af9013_config[1].i2c_addr,
+	ret = af9015_read_reg_i2c(d, state->af9013_i2c_addr[1],
 			0x98be, &val);
 	if (ret)
 		goto error;
@@ -771,7 +771,7 @@ static int af9015_copy_firmware(struct dvb_usb_device *d)
 		goto error;
 
 	/* request boot firmware */
-	ret = af9015_write_reg_i2c(d, state->af9013_config[1].i2c_addr,
+	ret = af9015_write_reg_i2c(d, state->af9013_i2c_addr[1],
 			0xe205, 1);
 	dev_dbg(&intf->dev, "firmware boot cmd status %d\n", ret);
 	if (ret)
@@ -781,7 +781,7 @@ static int af9015_copy_firmware(struct dvb_usb_device *d)
 		msleep(100);
 
 		/* check firmware status */
-		ret = af9015_read_reg_i2c(d, state->af9013_config[1].i2c_addr,
+		ret = af9015_read_reg_i2c(d, state->af9013_i2c_addr[1],
 				0x98be, &val);
 		dev_dbg(&intf->dev, "firmware status cmd status %d, firmware status %02x\n",
 			ret, val);
@@ -810,18 +810,22 @@ static int af9015_af9013_frontend_attach(struct dvb_usb_adapter *adap)
 	struct af9015_state *state = adap_to_priv(adap);
 	struct dvb_usb_device *d = adap_to_d(adap);
 	struct usb_interface *intf = d->intf;
+	struct i2c_client *client;
 	int ret;
 
+	dev_dbg(&intf->dev, "adap id %u\n", adap->id);
+
 	if (adap->id == 0) {
-		state->af9013_config[0].ts_mode = AF9013_TS_USB;
-		memcpy(state->af9013_config[0].api_version, "\x0\x1\x9\x0", 4);
-		state->af9013_config[0].gpio[0] = AF9013_GPIO_HI;
-		state->af9013_config[0].gpio[3] = AF9013_GPIO_TUNER_ON;
+		state->af9013_pdata[0].ts_mode = AF9013_TS_MODE_USB;
+		memcpy(state->af9013_pdata[0].api_version, "\x0\x1\x9\x0", 4);
+		state->af9013_pdata[0].gpio[0] = AF9013_GPIO_HI;
+		state->af9013_pdata[0].gpio[3] = AF9013_GPIO_TUNER_ON;
 	} else if (adap->id == 1) {
-		state->af9013_config[1].ts_mode = AF9013_TS_SERIAL;
-		memcpy(state->af9013_config[1].api_version, "\x0\x1\x9\x0", 4);
-		state->af9013_config[1].gpio[0] = AF9013_GPIO_TUNER_ON;
-		state->af9013_config[1].gpio[1] = AF9013_GPIO_LO;
+		state->af9013_pdata[1].ts_mode = AF9013_TS_MODE_SERIAL;
+		state->af9013_pdata[1].ts_output_pin = 7;
+		memcpy(state->af9013_pdata[1].api_version, "\x0\x1\x9\x0", 4);
+		state->af9013_pdata[1].gpio[0] = AF9013_GPIO_TUNER_ON;
+		state->af9013_pdata[1].gpio[1] = AF9013_GPIO_LO;
 
 		/* copy firmware to 2nd demodulator */
 		if (state->dual_mode) {
@@ -833,16 +837,24 @@ static int af9015_af9013_frontend_attach(struct dvb_usb_adapter *adap)
 				dev_err(&intf->dev,
 					"firmware copy to 2nd frontend failed, will disable it\n");
 				state->dual_mode = 0;
-				return -ENODEV;
+				goto err;
 			}
 		} else {
-			return -ENODEV;
+			ret = -ENODEV;
+			goto err;
 		}
 	}
 
-	/* attach demodulator */
-	adap->fe[0] = dvb_attach(af9013_attach,
-		&state->af9013_config[adap->id], &adap_to_d(adap)->i2c_adap);
+	/* Add I2C demod */
+	client = dvb_module_probe("af9013", NULL, &d->i2c_adap,
+				  state->af9013_i2c_addr[adap->id],
+				  &state->af9013_pdata[adap->id]);
+	if (!client) {
+		ret = -ENODEV;
+		goto err;
+	}
+	adap->fe[0] = state->af9013_pdata[adap->id].get_dvb_frontend(client);
+	state->demod_i2c_client[adap->id] = client;
 
 	/*
 	 * AF9015 firmware does not like if it gets interrupted by I2C adapter
@@ -869,7 +881,26 @@ static int af9015_af9013_frontend_attach(struct dvb_usb_adapter *adap)
 		adap->fe[0]->ops.sleep = af9015_af9013_sleep;
 	}
 
-	return adap->fe[0] == NULL ? -ENODEV : 0;
+	return 0;
+err:
+	dev_dbg(&intf->dev, "failed %d\n", ret);
+	return ret;
+}
+
+static int af9015_frontend_detach(struct dvb_usb_adapter *adap)
+{
+	struct af9015_state *state = adap_to_priv(adap);
+	struct dvb_usb_device *d = adap_to_d(adap);
+	struct usb_interface *intf = d->intf;
+	struct i2c_client *client;
+
+	dev_dbg(&intf->dev, "adap id %u\n", adap->id);
+
+	/* Remove I2C demod */
+	client = state->demod_i2c_client[adap->id];
+	dvb_module_release(client);
+
+	return 0;
 }
 
 static struct mt2060_config af9015_mt2060_config = {
@@ -940,64 +971,60 @@ static int af9015_tuner_attach(struct dvb_usb_adapter *adap)
 	struct dvb_usb_device *d = adap_to_d(adap);
 	struct af9015_state *state = d_to_priv(d);
 	struct usb_interface *intf = d->intf;
+	struct i2c_client *client;
+	struct i2c_adapter *adapter;
 	int ret;
 
-	dev_dbg(&intf->dev, "\n");
+	dev_dbg(&intf->dev, "adap id %u\n", adap->id);
+
+	client = state->demod_i2c_client[adap->id];
+	adapter = state->af9013_pdata[adap->id].get_i2c_adapter(client);
 
-	switch (state->af9013_config[adap->id].tuner) {
+	switch (state->af9013_pdata[adap->id].tuner) {
 	case AF9013_TUNER_MT2060:
 	case AF9013_TUNER_MT2060_2:
-		ret = dvb_attach(mt2060_attach, adap->fe[0],
-			&adap_to_d(adap)->i2c_adap, &af9015_mt2060_config,
-			state->mt2060_if1[adap->id])
-			== NULL ? -ENODEV : 0;
+		ret = dvb_attach(mt2060_attach, adap->fe[0], adapter,
+			&af9015_mt2060_config,
+			state->mt2060_if1[adap->id]) == NULL ? -ENODEV : 0;
 		break;
 	case AF9013_TUNER_QT1010:
 	case AF9013_TUNER_QT1010A:
-		ret = dvb_attach(qt1010_attach, adap->fe[0],
-			&adap_to_d(adap)->i2c_adap,
+		ret = dvb_attach(qt1010_attach, adap->fe[0], adapter,
 			&af9015_qt1010_config) == NULL ? -ENODEV : 0;
 		break;
 	case AF9013_TUNER_TDA18271:
-		ret = dvb_attach(tda18271_attach, adap->fe[0], 0x60,
-			&adap_to_d(adap)->i2c_adap,
+		ret = dvb_attach(tda18271_attach, adap->fe[0], 0x60, adapter,
 			&af9015_tda18271_config) == NULL ? -ENODEV : 0;
 		break;
 	case AF9013_TUNER_TDA18218:
-		ret = dvb_attach(tda18218_attach, adap->fe[0],
-			&adap_to_d(adap)->i2c_adap,
+		ret = dvb_attach(tda18218_attach, adap->fe[0], adapter,
 			&af9015_tda18218_config) == NULL ? -ENODEV : 0;
 		break;
 	case AF9013_TUNER_MXL5003D:
-		ret = dvb_attach(mxl5005s_attach, adap->fe[0],
-			&adap_to_d(adap)->i2c_adap,
+		ret = dvb_attach(mxl5005s_attach, adap->fe[0], adapter,
 			&af9015_mxl5003_config) == NULL ? -ENODEV : 0;
 		break;
 	case AF9013_TUNER_MXL5005D:
 	case AF9013_TUNER_MXL5005R:
-		ret = dvb_attach(mxl5005s_attach, adap->fe[0],
-			&adap_to_d(adap)->i2c_adap,
+		ret = dvb_attach(mxl5005s_attach, adap->fe[0], adapter,
 			&af9015_mxl5005_config) == NULL ? -ENODEV : 0;
 		break;
 	case AF9013_TUNER_ENV77H11D5:
-		ret = dvb_attach(dvb_pll_attach, adap->fe[0], 0x60,
-			&adap_to_d(adap)->i2c_adap,
+		ret = dvb_attach(dvb_pll_attach, adap->fe[0], 0x60, adapter,
 			DVB_PLL_TDA665X) == NULL ? -ENODEV : 0;
 		break;
 	case AF9013_TUNER_MC44S803:
-		ret = dvb_attach(mc44s803_attach, adap->fe[0],
-			&adap_to_d(adap)->i2c_adap,
+		ret = dvb_attach(mc44s803_attach, adap->fe[0], adapter,
 			&af9015_mc44s803_config) == NULL ? -ENODEV : 0;
 		break;
 	case AF9013_TUNER_MXL5007T:
-		ret = dvb_attach(mxl5007t_attach, adap->fe[0],
-			&adap_to_d(adap)->i2c_adap,
+		ret = dvb_attach(mxl5007t_attach, adap->fe[0], adapter,
 			0x60, &af9015_mxl5007t_config) == NULL ? -ENODEV : 0;
 		break;
 	case AF9013_TUNER_UNKNOWN:
 	default:
 		dev_err(&intf->dev, "unknown tuner, tuner id %02x\n",
-			state->af9013_config[adap->id].tuner);
+			state->af9013_pdata[adap->id].tuner);
 		ret = -ENODEV;
 	}
 
@@ -1404,6 +1431,7 @@ static struct dvb_usb_device_properties af9015_props = {
 	.i2c_algo = &af9015_i2c_algo,
 	.read_config = af9015_read_config,
 	.frontend_attach = af9015_af9013_frontend_attach,
+	.frontend_detach = af9015_frontend_detach,
 	.tuner_attach = af9015_tuner_attach,
 	.init = af9015_init,
 	.get_rc_config = af9015_get_rc_config,
diff --git a/drivers/media/usb/dvb-usb-v2/af9015.h b/drivers/media/usb/dvb-usb-v2/af9015.h
index 3a9d9815ab7a..97339bf3749b 100644
--- a/drivers/media/usb/dvb-usb-v2/af9015.h
+++ b/drivers/media/usb/dvb-usb-v2/af9015.h
@@ -125,7 +125,9 @@ struct af9015_state {
 	u16 firmware_size;
 	u16 firmware_checksum;
 	u32 eeprom_sum;
-	struct af9013_config af9013_config[2];
+	struct af9013_platform_data af9013_pdata[2];
+	struct i2c_client *demod_i2c_client[2];
+	u8 af9013_i2c_addr[2];
 
 	/* for demod callback override */
 	int (*set_frontend[2]) (struct dvb_frontend *fe);
-- 
2.14.3
