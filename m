Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f176.google.com ([209.85.192.176]:36399 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752901AbaJTKFu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Oct 2014 06:05:50 -0400
Received: by mail-pd0-f176.google.com with SMTP id fp1so4670384pdb.7
        for <linux-media@vger.kernel.org>; Mon, 20 Oct 2014 03:05:50 -0700 (PDT)
Date: Mon, 20 Oct 2014 18:05:47 +0800
From: "Nibble Max" <nibble.max@gmail.com>
To: "Antti Palosaari" <crope@iki.fi>
Cc: "linux-media" <linux-media@vger.kernel.org>,
	"Olli Salonen" <olli.salonen@iki.fi>
Subject: [PATCH 1/1] dvb-usb-dvbsky: add s960ci dvb-s/s2 usb ci box support
Message-ID: <201410201805442813374@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

DVBSky s960ci dvb-s/s2 usb ci box:
1>dvb frontend: M88TS2022(tuner),M88DS3103(demod)
2>usb controller: CY7C86013A
3>ci controller: CIMAX SP2 or its clone.

Signed-off-by: Nibble Max <nibble.max@gmail.com>
---
 drivers/media/usb/dvb-usb-v2/Kconfig  |   1 +
 drivers/media/usb/dvb-usb-v2/dvbsky.c | 188 ++++++++++++++++++++++++++++++++++
 2 files changed, 189 insertions(+)

diff --git a/drivers/media/usb/dvb-usb-v2/Kconfig b/drivers/media/usb/dvb-usb-v2/Kconfig
index 5b34323..7423033 100644
--- a/drivers/media/usb/dvb-usb-v2/Kconfig
+++ b/drivers/media/usb/dvb-usb-v2/Kconfig
@@ -146,5 +146,6 @@ config DVB_USB_DVBSKY
 	depends on DVB_USB_V2
 	select DVB_M88DS3103 if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_M88TS2022 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_SP2 if MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Say Y here to support the USB receivers from DVBSky.
diff --git a/drivers/media/usb/dvb-usb-v2/dvbsky.c b/drivers/media/usb/dvb-usb-v2/dvbsky.c
index 34688c8..e3439f6 100644
--- a/drivers/media/usb/dvb-usb-v2/dvbsky.c
+++ b/drivers/media/usb/dvb-usb-v2/dvbsky.c
@@ -21,6 +21,7 @@
 #include "dvb_usb.h"
 #include "m88ds3103.h"
 #include "m88ts2022.h"
+#include "sp2.h"
 
 #define DVBSKY_MSG_DELAY	0/*2000*/
 #define DVBSKY_BUF_LEN	64
@@ -33,6 +34,7 @@ struct dvbsky_state {
 	u8 obuf[DVBSKY_BUF_LEN];
 	u8 last_lock;
 	struct i2c_client *i2c_client_tuner;
+	struct i2c_client *i2c_client_ci;
 
 	/* fe hook functions*/
 	int (*fe_set_voltage)(struct dvb_frontend *fe,
@@ -362,6 +364,157 @@ fail_attach:
 	return ret;
 }
 
+static int dvbsky_usb_ci_set_voltage(struct dvb_frontend *fe,
+	fe_sec_voltage_t voltage)
+{
+	struct dvb_usb_device *d = fe_to_d(fe);
+	struct dvbsky_state *state = d_to_priv(d);
+	u8 value;
+
+	if (voltage == SEC_VOLTAGE_OFF)
+		value = 0;
+	else
+		value = 1;
+	dvbsky_gpio_ctrl(d, 0x00, value);
+
+	return state->fe_set_voltage(fe, voltage);
+}
+
+static int dvbsky_ci_ctrl(void *priv, u8 read, int addr,
+					u8 data, int *mem)
+{
+	struct dvb_usb_device *d = priv;
+	int ret = 0;
+	u8 command[4], respond[2], command_size, respond_size;
+
+	command[1] = (u8)((addr >> 8) & 0xff); /*high part of address*/
+	command[2] = (u8)(addr & 0xff); /*low part of address*/
+	if (read) {
+		command[0] = 0x71;
+		command_size = 3;
+		respond_size = 2;
+	} else {
+		command[0] = 0x70;
+		command[3] = data;
+		command_size = 4;
+		respond_size = 1;
+	}
+	ret = dvbsky_usb_generic_rw(d, command, command_size,
+			respond, respond_size);
+	if (ret)
+		goto err;
+	if (read)
+		*mem = respond[1];
+	return ret;
+err:
+	dev_err(&d->udev->dev, "ci control failed=%d\n", ret);
+	return ret;
+}
+
+static const struct m88ds3103_config dvbsky_s960c_m88ds3103_config = {
+	.i2c_addr = 0x68,
+	.clock = 27000000,
+	.i2c_wr_max = 33,
+	.clock_out = 0,
+	.ts_mode = M88DS3103_TS_CI,
+	.ts_clk = 10000,
+	.ts_clk_pol = 1,
+	.agc = 0x99,
+	.lnb_hv_pol = 0,
+	.lnb_en_pol = 1,
+};
+
+static int dvbsky_s960c_attach(struct dvb_usb_adapter *adap)
+{
+	struct dvbsky_state *state = adap_to_priv(adap);
+	struct dvb_usb_device *d = adap_to_d(adap);
+	int ret = 0;
+	/* demod I2C adapter */
+	struct i2c_adapter *i2c_adapter;
+	struct i2c_client *client_tuner, *client_ci;
+	struct i2c_board_info info;
+	struct sp2_config sp2_config;
+	struct m88ts2022_config m88ts2022_config = {
+			.clock = 27000000,
+		};
+	memset(&info, 0, sizeof(struct i2c_board_info));
+
+	/* attach demod */
+	adap->fe[0] = dvb_attach(m88ds3103_attach,
+			&dvbsky_s960c_m88ds3103_config,
+			&d->i2c_adap,
+			&i2c_adapter);
+	if (!adap->fe[0]) {
+		dev_err(&d->udev->dev, "dvbsky_s960ci_attach fail.\n");
+		ret = -ENODEV;
+		goto fail_attach;
+	}
+
+	/* attach tuner */
+	m88ts2022_config.fe = adap->fe[0];
+	strlcpy(info.type, "m88ts2022", I2C_NAME_SIZE);
+	info.addr = 0x60;
+	info.platform_data = &m88ts2022_config;
+	request_module("m88ts2022");
+	client_tuner = i2c_new_device(i2c_adapter, &info);
+	if (client_tuner == NULL || client_tuner->dev.driver == NULL) {
+		ret = -ENODEV;
+		goto fail_tuner_device;
+	}
+
+	if (!try_module_get(client_tuner->dev.driver->owner)) {
+		ret = -ENODEV;
+		goto fail_tuner_module;
+	}
+
+	/* attach ci controller */
+	memset(&sp2_config, 0, sizeof(sp2_config));
+	sp2_config.dvb_adap = &adap->dvb_adap;
+	sp2_config.priv = d;
+	sp2_config.ci_control = dvbsky_ci_ctrl;
+	memset(&info, 0, sizeof(struct i2c_board_info));
+	strlcpy(info.type, "sp2", I2C_NAME_SIZE);
+	info.addr = 0x40;
+	info.platform_data = &sp2_config;
+	request_module("sp2");
+	client_ci = i2c_new_device(i2c_adapter, &info);
+	if (client_ci == NULL || client_ci->dev.driver == NULL) {
+		ret = -ENODEV;
+		goto fail_ci_device;
+	}
+
+	if (!try_module_get(client_ci->dev.driver->owner)) {
+		ret = -ENODEV;
+		goto fail_ci_module;
+	}
+
+	/* delegate signal strength measurement to tuner */
+	adap->fe[0]->ops.read_signal_strength =
+			adap->fe[0]->ops.tuner_ops.get_rf_strength;
+
+	/* hook fe: need to resync the slave fifo when signal locks. */
+	state->fe_read_status = adap->fe[0]->ops.read_status;
+	adap->fe[0]->ops.read_status = dvbsky_usb_read_status;
+
+	/* hook fe: LNB off/on is control by Cypress usb chip. */
+	state->fe_set_voltage = adap->fe[0]->ops.set_voltage;
+	adap->fe[0]->ops.set_voltage = dvbsky_usb_ci_set_voltage;
+
+	state->i2c_client_tuner = client_tuner;
+	state->i2c_client_ci = client_ci;
+	return ret;
+fail_ci_module:
+	i2c_unregister_device(client_ci);
+fail_ci_device:
+	module_put(client_tuner->dev.driver->owner);
+fail_tuner_module:
+	i2c_unregister_device(client_tuner);
+fail_tuner_device:
+	dvb_frontend_detach(adap->fe[0]);
+fail_attach:
+	return ret;
+}
+
 static int dvbsky_identify_state(struct dvb_usb_device *d, const char **name)
 {
 	dvbsky_gpio_ctrl(d, 0x04, 1);
@@ -404,6 +557,12 @@ static void dvbsky_exit(struct dvb_usb_device *d)
 		module_put(client->dev.driver->owner);
 		i2c_unregister_device(client);
 	}
+	client = state->i2c_client_ci;
+	/* remove I2C ci */
+	if (client) {
+		module_put(client->dev.driver->owner);
+		i2c_unregister_device(client);
+	}
 }
 
 /* DVB USB Driver stuff */
@@ -434,9 +593,38 @@ static struct dvb_usb_device_properties dvbsky_s960_props = {
 	}
 };
 
+static struct dvb_usb_device_properties dvbsky_s960c_props = {
+	.driver_name = KBUILD_MODNAME,
+	.owner = THIS_MODULE,
+	.adapter_nr = adapter_nr,
+	.size_of_priv = sizeof(struct dvbsky_state),
+
+	.generic_bulk_ctrl_endpoint = 0x01,
+	.generic_bulk_ctrl_endpoint_response = 0x81,
+	.generic_bulk_ctrl_delay = DVBSKY_MSG_DELAY,
+
+	.i2c_algo         = &dvbsky_i2c_algo,
+	.frontend_attach  = dvbsky_s960c_attach,
+	.init             = dvbsky_init,
+	.get_rc_config    = dvbsky_get_rc_config,
+	.streaming_ctrl   = dvbsky_streaming_ctrl,
+	.identify_state	  = dvbsky_identify_state,
+	.exit             = dvbsky_exit,
+	.read_mac_address = dvbsky_read_mac_addr,
+
+	.num_adapters = 1,
+	.adapter = {
+		{
+			.stream = DVB_USB_STREAM_BULK(0x82, 8, 4096),
+		}
+	}
+};
+
 static const struct usb_device_id dvbsky_id_table[] = {
 	{ DVB_USB_DEVICE(0x0572, 0x6831,
 		&dvbsky_s960_props, "DVBSky S960/S860", RC_MAP_DVBSKY) },
+	{ DVB_USB_DEVICE(0x0572, 0x960c,
+		&dvbsky_s960c_props, "DVBSky S960CI", RC_MAP_DVBSKY) },
 	{ }
 };
 MODULE_DEVICE_TABLE(usb, dvbsky_id_table);

-- 
1.9.1

