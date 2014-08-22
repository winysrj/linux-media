Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:36499 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756071AbaHVK6a (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Aug 2014 06:58:30 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Nibble Max <nibble.max@gmail.com>,
	Olli Salonen <olli.salonen@iki.fi>,
	Evgeny Plehov <EvgenyPlehov@ukr.net>,
	Antti Palosaari <crope@iki.fi>
Subject: [GIT PULL FINAL 08/21] cxusb: Add support for TechnoTrend TT-connect CT2-4650 CI
Date: Fri, 22 Aug 2014 13:58:00 +0300
Message-Id: <1408705093-5167-9-git-send-email-crope@iki.fi>
In-Reply-To: <1408705093-5167-1-git-send-email-crope@iki.fi>
References: <1408705093-5167-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Olli Salonen <olli.salonen@iki.fi>

TechnoTrend TT-connect CT2-4650 CI (0b48:3012) is an USB DVB-T2/C tuner with
the following components:

 USB interface: Cypress CY7C68013A-56LTXC
 Demodulator: Silicon Labs Si2168-A20
 Tuner: Silicon Labs Si2158-A20
 CI chip: CIMaX SP2HF

The firmware for the tuner is the same as for TechnoTrend TT-TVStick CT2-4400.
See https://www.mail-archive.com/linux-media@vger.kernel.org/msg76944.html

The demodulator needs a firmware that can be extracted from the Windows drivers.
File ttConnect4650_64.sys should be extracted from
http://www.tt-downloads.de/bda-treiber_4.1.0.4.zip (MD5 sum below).

3464bfc37a47b4032568718bacba23fb  ttConnect4650_64.sys

Then the firmware can be extracted:
dd if=ttConnect4650_64.sys ibs=1 skip=273376 count=6424 of=dvb-demod-si2168-a20-01.fw

The SP2 CI module requires a definition of a function cxusb_tt_ct2_4650_ci_ctrl
that is passed on to the SP2 driver and called back for CAM operations.

[crope@iki.fi: meld USB ID define patch to this]

Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
Reviewed-by: Antti Palosaari <crope@iki.fi>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-core/dvb-usb-ids.h |  1 +
 drivers/media/usb/dvb-usb/Kconfig    |  2 +-
 drivers/media/usb/dvb-usb/cxusb.c    | 92 +++++++++++++++++++++++++++++++++++-
 drivers/media/usb/dvb-usb/cxusb.h    |  4 ++
 4 files changed, 97 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-core/dvb-usb-ids.h b/drivers/media/dvb-core/dvb-usb-ids.h
index 5135a09..b7a9b98 100644
--- a/drivers/media/dvb-core/dvb-usb-ids.h
+++ b/drivers/media/dvb-core/dvb-usb-ids.h
@@ -244,6 +244,7 @@
 #define USB_PID_TECHNOTREND_CONNECT_S2400               0x3006
 #define USB_PID_TECHNOTREND_CONNECT_S2400_8KEEPROM	0x3009
 #define USB_PID_TECHNOTREND_CONNECT_CT3650		0x300d
+#define USB_PID_TECHNOTREND_CONNECT_CT2_4650_CI		0x3012
 #define USB_PID_TECHNOTREND_TVSTICK_CT2_4400		0x3014
 #define USB_PID_TERRATEC_CINERGY_DT_XS_DIVERSITY	0x005a
 #define USB_PID_TERRATEC_CINERGY_DT_XS_DIVERSITY_2	0x0081
diff --git a/drivers/media/usb/dvb-usb/Kconfig b/drivers/media/usb/dvb-usb/Kconfig
index 10aef21..41d3eb9 100644
--- a/drivers/media/usb/dvb-usb/Kconfig
+++ b/drivers/media/usb/dvb-usb/Kconfig
@@ -130,7 +130,7 @@ config DVB_USB_CXUSB
 
 	  Medion MD95700 hybrid USB2.0 device.
 	  DViCO FusionHDTV (Bluebird) USB2.0 devices
-	  TechnoTrend TVStick CT2-4400
+	  TechnoTrend TVStick CT2-4400 and CT2-4650 CI devices
 
 config DVB_USB_M920X
 	tristate "Uli m920x DVB-T USB2.0 support"
diff --git a/drivers/media/usb/dvb-usb/cxusb.c b/drivers/media/usb/dvb-usb/cxusb.c
index 87842e9..4ab3459 100644
--- a/drivers/media/usb/dvb-usb/cxusb.c
+++ b/drivers/media/usb/dvb-usb/cxusb.c
@@ -44,6 +44,7 @@
 #include "atbm8830.h"
 #include "si2168.h"
 #include "si2157.h"
+#include "sp2.h"
 
 /* Max transfer size done by I2C transfer functions */
 #define MAX_XFER_SIZE  80
@@ -672,6 +673,37 @@ static struct rc_map_table rc_map_d680_dmb_table[] = {
 	{ 0x0025, KEY_POWER },
 };
 
+static int cxusb_tt_ct2_4650_ci_ctrl(void *priv, u8 read, int addr,
+					u8 data, int *mem)
+{
+	struct dvb_usb_device *d = priv;
+	u8 wbuf[3];
+	u8 rbuf[2];
+	int ret;
+
+	wbuf[0] = (addr >> 8) & 0xff;
+	wbuf[1] = addr & 0xff;
+
+	if (read) {
+		ret = cxusb_ctrl_msg(d, CMD_SP2_CI_READ, wbuf, 2, rbuf, 2);
+	} else {
+		wbuf[2] = data;
+		ret = cxusb_ctrl_msg(d, CMD_SP2_CI_WRITE, wbuf, 3, rbuf, 1);
+	}
+
+	if (ret)
+		goto err;
+
+	if (read)
+		*mem = rbuf[1];
+
+	return 0;
+err:
+	deb_info("%s: ci usb write returned %d\n", __func__, ret);
+	return ret;
+
+}
+
 static int cxusb_dee1601_demod_init(struct dvb_frontend* fe)
 {
 	static u8 clock_config []  = { CLOCK_CTL,  0x38, 0x28 };
@@ -1350,9 +1382,12 @@ static int cxusb_tt_ct2_4400_attach(struct dvb_usb_adapter *adap)
 	struct i2c_adapter *adapter;
 	struct i2c_client *client_demod;
 	struct i2c_client *client_tuner;
+	struct i2c_client *client_ci;
 	struct i2c_board_info info;
 	struct si2168_config si2168_config;
 	struct si2157_config si2157_config;
+	struct sp2_config sp2_config;
+	u8 o[2], i;
 
 	/* reset the tuner */
 	if (cxusb_tt_ct2_4400_gpio_tuner(d, 0) < 0) {
@@ -1409,6 +1444,48 @@ static int cxusb_tt_ct2_4400_attach(struct dvb_usb_adapter *adap)
 
 	st->i2c_client_tuner = client_tuner;
 
+	/* initialize CI */
+	if (d->udev->descriptor.idProduct ==
+		USB_PID_TECHNOTREND_CONNECT_CT2_4650_CI) {
+
+		memcpy(o, "\xc0\x01", 2);
+		cxusb_ctrl_msg(d, CMD_GPIO_WRITE, o, 2, &i, 1);
+		msleep(100);
+
+		memcpy(o, "\xc0\x00", 2);
+		cxusb_ctrl_msg(d, CMD_GPIO_WRITE, o, 2, &i, 1);
+		msleep(100);
+
+		memset(&sp2_config, 0, sizeof(sp2_config));
+		sp2_config.dvb_adap = &adap->dvb_adap;
+		sp2_config.priv = d;
+		sp2_config.ci_control = cxusb_tt_ct2_4650_ci_ctrl;
+		memset(&info, 0, sizeof(struct i2c_board_info));
+		strlcpy(info.type, "sp2", I2C_NAME_SIZE);
+		info.addr = 0x40;
+		info.platform_data = &sp2_config;
+		request_module(info.type);
+		client_ci = i2c_new_device(&d->i2c_adap, &info);
+		if (client_ci == NULL || client_ci->dev.driver == NULL) {
+			module_put(client_tuner->dev.driver->owner);
+			i2c_unregister_device(client_tuner);
+			module_put(client_demod->dev.driver->owner);
+			i2c_unregister_device(client_demod);
+			return -ENODEV;
+		}
+		if (!try_module_get(client_ci->dev.driver->owner)) {
+			i2c_unregister_device(client_ci);
+			module_put(client_tuner->dev.driver->owner);
+			i2c_unregister_device(client_tuner);
+			module_put(client_demod->dev.driver->owner);
+			i2c_unregister_device(client_demod);
+			return -ENODEV;
+		}
+
+		st->i2c_client_ci = client_ci;
+
+	}
+
 	return 0;
 }
 
@@ -1538,6 +1615,13 @@ static void cxusb_disconnect(struct usb_interface *intf)
 	struct cxusb_state *st = d->priv;
 	struct i2c_client *client;
 
+	/* remove I2C client for CI */
+	client = st->i2c_client_ci;
+	if (client) {
+		module_put(client->dev.driver->owner);
+		i2c_unregister_device(client);
+	}
+
 	/* remove I2C client for tuner */
 	client = st->i2c_client_tuner;
 	if (client) {
@@ -1577,6 +1661,7 @@ static struct usb_device_id cxusb_table [] = {
 	{ USB_DEVICE(USB_VID_CONEXANT, USB_PID_CONEXANT_D680_DMB) },
 	{ USB_DEVICE(USB_VID_CONEXANT, USB_PID_MYGICA_D689) },
 	{ USB_DEVICE(USB_VID_TECHNOTREND, USB_PID_TECHNOTREND_TVSTICK_CT2_4400) },
+	{ USB_DEVICE(USB_VID_TECHNOTREND, USB_PID_TECHNOTREND_CONNECT_CT2_4650_CI) },
 	{}		/* Terminating entry */
 };
 MODULE_DEVICE_TABLE (usb, cxusb_table);
@@ -2266,13 +2351,18 @@ static struct dvb_usb_device_properties cxusb_tt_ct2_4400_properties = {
 		.rc_interval    = 150,
 	},
 
-	.num_device_descs = 1,
+	.num_device_descs = 2,
 	.devices = {
 		{
 			"TechnoTrend TVStick CT2-4400",
 			{ NULL },
 			{ &cxusb_table[20], NULL },
 		},
+		{
+			"TechnoTrend TT-connect CT2-4650 CI",
+			{ NULL },
+			{ &cxusb_table[21], NULL },
+		},
 	}
 };
 
diff --git a/drivers/media/usb/dvb-usb/cxusb.h b/drivers/media/usb/dvb-usb/cxusb.h
index 527ff79..29f3e2e 100644
--- a/drivers/media/usb/dvb-usb/cxusb.h
+++ b/drivers/media/usb/dvb-usb/cxusb.h
@@ -28,10 +28,14 @@
 #define CMD_ANALOG        0x50
 #define CMD_DIGITAL       0x51
 
+#define CMD_SP2_CI_WRITE  0x70
+#define CMD_SP2_CI_READ   0x71
+
 struct cxusb_state {
 	u8 gpio_write_state[3];
 	struct i2c_client *i2c_client_demod;
 	struct i2c_client *i2c_client_tuner;
+	struct i2c_client *i2c_client_ci;
 };
 
 #endif
-- 
http://palosaari.fi/

