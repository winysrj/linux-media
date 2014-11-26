Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:52586 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639AbaKZMfS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Nov 2014 07:35:18 -0500
Received: by mail-pd0-f178.google.com with SMTP id g10so2729229pdj.23
        for <linux-media@vger.kernel.org>; Wed, 26 Nov 2014 04:35:17 -0800 (PST)
Date: Wed, 26 Nov 2014 20:35:14 +0800
From: "Nibble Max" <nibble.max@gmail.com>
To: "Olli Salonen" <olli.salonen@iki.fi>
Cc: "linux-media" <linux-media@vger.kernel.org>,
	"Antti Palosaari" <crope@iki.fi>
Subject: [PATCH 2/3] cxusb: remove TechnoTrend CT2-4400 and CT2-4650 devices
Message-ID: <201411262035117039244@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove TechnoTrend CT2-4400 and CT2-4650 devices from cxusb.
They are supported by dvb-usb-dvbsky driver in PATCH 3/3.

Signed-off-by: Nibble Max <nibble.max@gmail.com>
---
 drivers/media/usb/dvb-usb/Kconfig |   1 -
 drivers/media/usb/dvb-usb/cxusb.c | 298 --------------------------------------
 drivers/media/usb/dvb-usb/cxusb.h |   4 -
 3 files changed, 303 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/Kconfig b/drivers/media/usb/dvb-usb/Kconfig
index 41d3eb9..3364200 100644
--- a/drivers/media/usb/dvb-usb/Kconfig
+++ b/drivers/media/usb/dvb-usb/Kconfig
@@ -130,7 +130,6 @@ config DVB_USB_CXUSB
 
 	  Medion MD95700 hybrid USB2.0 device.
 	  DViCO FusionHDTV (Bluebird) USB2.0 devices
-	  TechnoTrend TVStick CT2-4400 and CT2-4650 CI devices
 
 config DVB_USB_M920X
 	tristate "Uli m920x DVB-T USB2.0 support"
diff --git a/drivers/media/usb/dvb-usb/cxusb.c b/drivers/media/usb/dvb-usb/cxusb.c
index 643d88f..0f345b1 100644
--- a/drivers/media/usb/dvb-usb/cxusb.c
+++ b/drivers/media/usb/dvb-usb/cxusb.c
@@ -44,7 +44,6 @@
 #include "atbm8830.h"
 #include "si2168.h"
 #include "si2157.h"
-#include "sp2.h"
 
 /* Max transfer size done by I2C transfer functions */
 #define MAX_XFER_SIZE  80
@@ -147,22 +146,6 @@ static int cxusb_d680_dmb_gpio_tuner(struct dvb_usb_device *d,
 	}
 }
 
-static int cxusb_tt_ct2_4400_gpio_tuner(struct dvb_usb_device *d, int onoff)
-{
-	u8 o[2], i;
-	int rc;
-
-	o[0] = 0x83;
-	o[1] = onoff;
-	rc = cxusb_ctrl_msg(d, CMD_GPIO_WRITE, o, 2, &i, 1);
-
-	if (rc) {
-		deb_info("gpio_write failed.\n");
-		return -EIO;
-	}
-	return 0;
-}
-
 /* I2C */
 static int cxusb_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 			  int num)
@@ -524,30 +507,6 @@ static int cxusb_d680_dmb_rc_query(struct dvb_usb_device *d, u32 *event,
 	return 0;
 }
 
-static int cxusb_tt_ct2_4400_rc_query(struct dvb_usb_device *d)
-{
-	u8 i[2];
-	int ret;
-	u32 cmd, keycode;
-	u8 rc5_cmd, rc5_addr, rc5_toggle;
-
-	ret = cxusb_ctrl_msg(d, 0x10, NULL, 0, i, 2);
-	if (ret)
-		return ret;
-
-	cmd = (i[0] << 8) | i[1];
-
-	if (cmd != 0xffff) {
-		rc5_cmd = cmd & 0x3F; /* bits 1-6 for command */
-		rc5_addr = (cmd & 0x07C0) >> 6; /* bits 7-11 for address */
-		rc5_toggle = (cmd & 0x0800) >> 11; /* bit 12 for toggle */
-		keycode = (rc5_addr << 8) | rc5_cmd;
-		rc_keydown(d->rc_dev, RC_BIT_RC5, keycode, rc5_toggle);
-	}
-
-	return 0;
-}
-
 static struct rc_map_table rc_map_dvico_mce_table[] = {
 	{ 0xfe02, KEY_TV },
 	{ 0xfe0e, KEY_MP3 },
@@ -673,70 +632,6 @@ static struct rc_map_table rc_map_d680_dmb_table[] = {
 	{ 0x0025, KEY_POWER },
 };
 
-static int cxusb_tt_ct2_4400_read_mac_address(struct dvb_usb_device *d, u8 mac[6])
-{
-	u8 wbuf[2];
-	u8 rbuf[6];
-	int ret;
-	struct i2c_msg msg[] = {
-		{
-			.addr = 0x51,
-			.flags = 0,
-			.buf = wbuf,
-			.len = 2,
-		}, {
-			.addr = 0x51,
-			.flags = I2C_M_RD,
-			.buf = rbuf,
-			.len = 6,
-		}
-	};
-
-	wbuf[0] = 0x1e;
-	wbuf[1] = 0x00;
-	ret = cxusb_i2c_xfer(&d->i2c_adap, msg, 2);
-
-	if (ret == 2) {
-		memcpy(mac, rbuf, 6);
-		return 0;
-	} else {
-		if (ret < 0)
-			return ret;
-		return -EIO;
-	}
-}
-
-static int cxusb_tt_ct2_4650_ci_ctrl(void *priv, u8 read, int addr,
-					u8 data, int *mem)
-{
-	struct dvb_usb_device *d = priv;
-	u8 wbuf[3];
-	u8 rbuf[2];
-	int ret;
-
-	wbuf[0] = (addr >> 8) & 0xff;
-	wbuf[1] = addr & 0xff;
-
-	if (read) {
-		ret = cxusb_ctrl_msg(d, CMD_SP2_CI_READ, wbuf, 2, rbuf, 2);
-	} else {
-		wbuf[2] = data;
-		ret = cxusb_ctrl_msg(d, CMD_SP2_CI_WRITE, wbuf, 3, rbuf, 1);
-	}
-
-	if (ret)
-		goto err;
-
-	if (read)
-		*mem = rbuf[1];
-
-	return 0;
-err:
-	deb_info("%s: ci usb write returned %d\n", __func__, ret);
-	return ret;
-
-}
-
 static int cxusb_dee1601_demod_init(struct dvb_frontend* fe)
 {
 	static u8 clock_config []  = { CLOCK_CTL,  0x38, 0x28 };
@@ -1478,127 +1373,6 @@ static int cxusb_mygica_t230_frontend_attach(struct dvb_usb_adapter *adap)
 	return 0;
 }
 
-static int cxusb_tt_ct2_4400_attach(struct dvb_usb_adapter *adap)
-{
-	struct dvb_usb_device *d = adap->dev;
-	struct cxusb_state *st = d->priv;
-	struct i2c_adapter *adapter;
-	struct i2c_client *client_demod;
-	struct i2c_client *client_tuner;
-	struct i2c_client *client_ci;
-	struct i2c_board_info info;
-	struct si2168_config si2168_config;
-	struct si2157_config si2157_config;
-	struct sp2_config sp2_config;
-	u8 o[2], i;
-
-	/* reset the tuner */
-	if (cxusb_tt_ct2_4400_gpio_tuner(d, 0) < 0) {
-		err("clear tuner gpio failed");
-		return -EIO;
-	}
-	msleep(100);
-	if (cxusb_tt_ct2_4400_gpio_tuner(d, 1) < 0) {
-		err("set tuner gpio failed");
-		return -EIO;
-	}
-	msleep(100);
-
-	/* attach frontend */
-	memset(&si2168_config, 0, sizeof(si2168_config));
-	si2168_config.i2c_adapter = &adapter;
-	si2168_config.fe = &adap->fe_adap[0].fe;
-	si2168_config.ts_mode = SI2168_TS_PARALLEL;
-
-	/* CT2-4400v2 TS gets corrupted without this */
-	if (le16_to_cpu(d->udev->descriptor.idProduct) ==
-		USB_PID_TECHNOTREND_TVSTICK_CT2_4400)
-		si2168_config.ts_mode |= 0x40;
-
-	memset(&info, 0, sizeof(struct i2c_board_info));
-	strlcpy(info.type, "si2168", I2C_NAME_SIZE);
-	info.addr = 0x64;
-	info.platform_data = &si2168_config;
-	request_module(info.type);
-	client_demod = i2c_new_device(&d->i2c_adap, &info);
-	if (client_demod == NULL || client_demod->dev.driver == NULL)
-		return -ENODEV;
-
-	if (!try_module_get(client_demod->dev.driver->owner)) {
-		i2c_unregister_device(client_demod);
-		return -ENODEV;
-	}
-
-	st->i2c_client_demod = client_demod;
-
-	/* attach tuner */
-	memset(&si2157_config, 0, sizeof(si2157_config));
-	si2157_config.fe = adap->fe_adap[0].fe;
-	memset(&info, 0, sizeof(struct i2c_board_info));
-	strlcpy(info.type, "si2157", I2C_NAME_SIZE);
-	info.addr = 0x60;
-	info.platform_data = &si2157_config;
-	request_module(info.type);
-	client_tuner = i2c_new_device(adapter, &info);
-	if (client_tuner == NULL || client_tuner->dev.driver == NULL) {
-		module_put(client_demod->dev.driver->owner);
-		i2c_unregister_device(client_demod);
-		return -ENODEV;
-	}
-	if (!try_module_get(client_tuner->dev.driver->owner)) {
-		i2c_unregister_device(client_tuner);
-		module_put(client_demod->dev.driver->owner);
-		i2c_unregister_device(client_demod);
-		return -ENODEV;
-	}
-
-	st->i2c_client_tuner = client_tuner;
-
-	/* initialize CI */
-	if (le16_to_cpu(d->udev->descriptor.idProduct) ==
-		USB_PID_TECHNOTREND_CONNECT_CT2_4650_CI) {
-
-		memcpy(o, "\xc0\x01", 2);
-		cxusb_ctrl_msg(d, CMD_GPIO_WRITE, o, 2, &i, 1);
-		msleep(100);
-
-		memcpy(o, "\xc0\x00", 2);
-		cxusb_ctrl_msg(d, CMD_GPIO_WRITE, o, 2, &i, 1);
-		msleep(100);
-
-		memset(&sp2_config, 0, sizeof(sp2_config));
-		sp2_config.dvb_adap = &adap->dvb_adap;
-		sp2_config.priv = d;
-		sp2_config.ci_control = cxusb_tt_ct2_4650_ci_ctrl;
-		memset(&info, 0, sizeof(struct i2c_board_info));
-		strlcpy(info.type, "sp2", I2C_NAME_SIZE);
-		info.addr = 0x40;
-		info.platform_data = &sp2_config;
-		request_module(info.type);
-		client_ci = i2c_new_device(&d->i2c_adap, &info);
-		if (client_ci == NULL || client_ci->dev.driver == NULL) {
-			module_put(client_tuner->dev.driver->owner);
-			i2c_unregister_device(client_tuner);
-			module_put(client_demod->dev.driver->owner);
-			i2c_unregister_device(client_demod);
-			return -ENODEV;
-		}
-		if (!try_module_get(client_ci->dev.driver->owner)) {
-			i2c_unregister_device(client_ci);
-			module_put(client_tuner->dev.driver->owner);
-			i2c_unregister_device(client_tuner);
-			module_put(client_demod->dev.driver->owner);
-			i2c_unregister_device(client_demod);
-			return -ENODEV;
-		}
-
-		st->i2c_client_ci = client_ci;
-
-	}
-
-	return 0;
-}
-
 /*
  * DViCO has shipped two devices with the same USB ID, but only one of them
  * needs a firmware download.  Check the device class details to see if they
@@ -1681,7 +1455,6 @@ static struct dvb_usb_device_properties cxusb_aver_a868r_properties;
 static struct dvb_usb_device_properties cxusb_d680_dmb_properties;
 static struct dvb_usb_device_properties cxusb_mygica_d689_properties;
 static struct dvb_usb_device_properties cxusb_mygica_t230_properties;
-static struct dvb_usb_device_properties cxusb_tt_ct2_4400_properties;
 
 static int cxusb_probe(struct usb_interface *intf,
 		       const struct usb_device_id *id)
@@ -1714,8 +1487,6 @@ static int cxusb_probe(struct usb_interface *intf,
 				     THIS_MODULE, NULL, adapter_nr) ||
 	    0 == dvb_usb_device_init(intf, &cxusb_mygica_t230_properties,
 				     THIS_MODULE, NULL, adapter_nr) ||
-	    0 == dvb_usb_device_init(intf, &cxusb_tt_ct2_4400_properties,
-				     THIS_MODULE, NULL, adapter_nr) ||
 	    0)
 		return 0;
 
@@ -1728,13 +1499,6 @@ static void cxusb_disconnect(struct usb_interface *intf)
 	struct cxusb_state *st = d->priv;
 	struct i2c_client *client;
 
-	/* remove I2C client for CI */
-	client = st->i2c_client_ci;
-	if (client) {
-		module_put(client->dev.driver->owner);
-		i2c_unregister_device(client);
-	}
-
 	/* remove I2C client for tuner */
 	client = st->i2c_client_tuner;
 	if (client) {
@@ -1773,8 +1537,6 @@ static struct usb_device_id cxusb_table [] = {
 	{ USB_DEVICE(USB_VID_DVICO, USB_PID_DVICO_BLUEBIRD_DUAL_4_REV_2) },
 	{ USB_DEVICE(USB_VID_CONEXANT, USB_PID_CONEXANT_D680_DMB) },
 	{ USB_DEVICE(USB_VID_CONEXANT, USB_PID_MYGICA_D689) },
-	{ USB_DEVICE(USB_VID_TECHNOTREND, USB_PID_TECHNOTREND_TVSTICK_CT2_4400) },
-	{ USB_DEVICE(USB_VID_TECHNOTREND, USB_PID_TECHNOTREND_CONNECT_CT2_4650_CI) },
 	{ USB_DEVICE(USB_VID_CONEXANT, USB_PID_MYGICA_T230) },
 	{}		/* Terminating entry */
 };
@@ -2422,66 +2184,6 @@ static struct dvb_usb_device_properties cxusb_mygica_d689_properties = {
 	}
 };
 
-static struct dvb_usb_device_properties cxusb_tt_ct2_4400_properties = {
-	.caps = DVB_USB_IS_AN_I2C_ADAPTER,
-
-	.usb_ctrl         = CYPRESS_FX2,
-
-	.size_of_priv     = sizeof(struct cxusb_state),
-
-	.num_adapters = 1,
-	.read_mac_address = cxusb_tt_ct2_4400_read_mac_address,
-
-	.adapter = {
-		{
-		.num_frontends = 1,
-		.fe = {{
-			.streaming_ctrl   = cxusb_streaming_ctrl,
-			/* both frontend and tuner attached in the
-			   same function */
-			.frontend_attach  = cxusb_tt_ct2_4400_attach,
-
-			/* parameter for the MPEG2-data transfer */
-			.stream = {
-				.type = USB_BULK,
-				.count = 8,
-				.endpoint = 0x82,
-				.u = {
-					.bulk = {
-						.buffersize = 4096,
-					}
-				}
-			},
-		} },
-		},
-	},
-
-	.i2c_algo = &cxusb_i2c_algo,
-	.generic_bulk_ctrl_endpoint = 0x01,
-	.generic_bulk_ctrl_endpoint_response = 0x81,
-
-	.rc.core = {
-		.rc_codes       = RC_MAP_TT_1500,
-		.allowed_protos = RC_BIT_RC5,
-		.rc_query       = cxusb_tt_ct2_4400_rc_query,
-		.rc_interval    = 150,
-	},
-
-	.num_device_descs = 2,
-	.devices = {
-		{
-			"TechnoTrend TVStick CT2-4400",
-			{ NULL },
-			{ &cxusb_table[20], NULL },
-		},
-		{
-			"TechnoTrend TT-connect CT2-4650 CI",
-			{ NULL },
-			{ &cxusb_table[21], NULL },
-		},
-	}
-};
-
 static struct dvb_usb_device_properties cxusb_mygica_t230_properties = {
 	.caps = DVB_USB_IS_AN_I2C_ADAPTER,
 
diff --git a/drivers/media/usb/dvb-usb/cxusb.h b/drivers/media/usb/dvb-usb/cxusb.h
index 29f3e2e..527ff79 100644
--- a/drivers/media/usb/dvb-usb/cxusb.h
+++ b/drivers/media/usb/dvb-usb/cxusb.h
@@ -28,14 +28,10 @@
 #define CMD_ANALOG        0x50
 #define CMD_DIGITAL       0x51
 
-#define CMD_SP2_CI_WRITE  0x70
-#define CMD_SP2_CI_READ   0x71
-
 struct cxusb_state {
 	u8 gpio_write_state[3];
 	struct i2c_client *i2c_client_demod;
 	struct i2c_client *i2c_client_tuner;
-	struct i2c_client *i2c_client_ci;
 };
 
 #endif

-- 
1.9.1

