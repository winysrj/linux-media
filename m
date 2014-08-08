Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f181.google.com ([209.85.192.181]:56795 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755262AbaHHDyI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Aug 2014 23:54:08 -0400
Received: by mail-pd0-f181.google.com with SMTP id g10so6226276pdj.26
        for <linux-media@vger.kernel.org>; Thu, 07 Aug 2014 20:54:07 -0700 (PDT)
Date: Fri, 8 Aug 2014 11:54:03 +0800
From: "nibble.max" <nibble.max@gmail.com>
To: "Antti Palosaari" <crope@iki.fi>
Cc: "linux-media" <linux-media@vger.kernel.org>
Subject: [PATCH 3/4 v2] support for DVBSky dvb-s2 usb: add dvb-usb-v2 driver for DVBSky dvb-s2 box, no ci support.
Message-ID: <201408081153594535194@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

remove ci support part in v1 patch.
hook demod read status and set voltage operations.

Signed-off-by: Nibble Max <nibble.max@gmail.com>
---
 drivers/media/usb/dvb-usb-v2/Kconfig  |   6 +
 drivers/media/usb/dvb-usb-v2/Makefile |   3 +
 drivers/media/usb/dvb-usb-v2/dvbsky.c | 455 ++++++++++++++++++++++++++++++++++
 3 files changed, 464 insertions(+)

diff --git a/drivers/media/usb/dvb-usb-v2/Kconfig b/drivers/media/usb/dvb-usb-v2/Kconfig
index 66645b0..8107c8d 100644
--- a/drivers/media/usb/dvb-usb-v2/Kconfig
+++ b/drivers/media/usb/dvb-usb-v2/Kconfig
@@ -141,3 +141,9 @@ config DVB_USB_RTL28XXU
 	help
 	  Say Y here to support the Realtek RTL28xxU DVB USB receiver.
 
+config DVB_USB_DVBSKY
+	tristate "DVBSky USB support"
+	depends on DVB_USB_V2
+	select DVB_M88DS3103 if MEDIA_SUBDRV_AUTOSELECT
+	help
+	  Say Y here to support the USB receivers from DVBSky.
diff --git a/drivers/media/usb/dvb-usb-v2/Makefile b/drivers/media/usb/dvb-usb-v2/Makefile
index bc38f03..f10d4df 100644
--- a/drivers/media/usb/dvb-usb-v2/Makefile
+++ b/drivers/media/usb/dvb-usb-v2/Makefile
@@ -37,6 +37,9 @@ obj-$(CONFIG_DVB_USB_MXL111SF) += mxl111sf-tuner.o
 dvb-usb-rtl28xxu-objs := rtl28xxu.o
 obj-$(CONFIG_DVB_USB_RTL28XXU) += dvb-usb-rtl28xxu.o
 
+dvb-usb-dvbsky-objs := dvbsky.o
+obj-$(CONFIG_DVB_USB_DVBSKY) += dvb-usb-dvbsky.o
+
 ccflags-y += -I$(srctree)/drivers/media/dvb-core
 ccflags-y += -I$(srctree)/drivers/media/dvb-frontends
 ccflags-y += -I$(srctree)/drivers/media/tuners
diff --git a/drivers/media/usb/dvb-usb-v2/dvbsky.c b/drivers/media/usb/dvb-usb-v2/dvbsky.c
new file mode 100644
index 0000000..2db363e
--- /dev/null
+++ b/drivers/media/usb/dvb-usb-v2/dvbsky.c
@@ -0,0 +1,455 @@
+/*
+ * Driver for DVBSky USB2.0 receiver
+ *
+ * Copyright (C) 2013 Max nibble <nibble.max@gmail.com>
+ *
+ *    This program is free software; you can redistribute it and/or modify
+ *    it under the terms of the GNU General Public License as published by
+ *    the Free Software Foundation; either version 2 of the License, or
+ *    (at your option) any later version.
+ *
+ *    This program is distributed in the hope that it will be useful,
+ *    but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *    GNU General Public License for more details.
+ *
+ *    You should have received a copy of the GNU General Public License
+ *    along with this program; if not, write to the Free Software
+ *    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include "dvb_usb.h"
+#include "m88ds3103.h"
+#include "m88ts2022.h"
+
+static int dvbsky_debug;
+module_param(dvbsky_debug, int, 0644);
+MODULE_PARM_DESC(dvbsky_debug, "Activates dvbsky usb debugging (default:0)");
+
+#define DVBSKY_MSG_DELAY	0/*2000*/
+
+#define dprintk(args...) \
+	do { \
+		if (dvbsky_debug) \
+			printk(KERN_INFO "dvbsky_usb: " args); \
+	} while (0)
+
+DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
+
+struct dvbsky_state {
+	struct mutex stream_mutex;
+	u8 last_lock;
+	struct i2c_client *i2c_client_tuner;
+	int (*fe_set_voltage)(struct dvb_frontend *fe,
+		fe_sec_voltage_t voltage);
+	int (*fe_read_status)(struct dvb_frontend *fe,
+		fe_status_t *status);
+};
+
+static int dvbsky_stream_ctrl(struct dvb_usb_device *d, u8 onoff)
+{
+	struct dvbsky_state *state = d_to_priv(d);
+	int ret;
+	u8 obuf_pre[3] = { 0x37, 0, 0 };
+	u8 obuf_post[3] = { 0x36, 3, 0 };
+	dprintk("%s() -off \n", __func__);
+	mutex_lock(&state->stream_mutex);
+	ret = dvb_usbv2_generic_write(d, obuf_pre, 3);
+	if (!ret && onoff) {
+		msleep(10);
+		ret = dvb_usbv2_generic_write(d, obuf_post, 3);
+		dprintk("%s() -on \n", __func__);
+	}
+	mutex_unlock(&state->stream_mutex);
+	return ret;
+}
+
+static int dvbsky_streaming_ctrl(struct dvb_frontend *fe, int onoff)
+{
+	struct dvb_usb_device *d = fe_to_d(fe);
+	/*dprintk("%s() %d\n", __func__, onoff);*/
+	return dvbsky_stream_ctrl(d, (onoff == 0) ? 0 : 1);
+}
+
+/* GPIO */
+static int dvbsky_gpio_ctrl(struct dvb_usb_device *d, u8 gport, u8 value)
+{
+	int ret;
+	u8 obuf[64], ibuf[64];
+	obuf[0] = 0x0e;
+	obuf[1] = gport;
+	obuf[2] = value;
+	ret = dvb_usbv2_generic_rw(d, obuf, 3, ibuf, 1);
+	if (ret)
+		dev_err(&d->udev->dev, "%s: %s() " \
+				"failed=%d\n", KBUILD_MODNAME, __func__, ret);
+	return ret;
+}
+
+/* I2C */
+static int dvbsky_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msg[],
+	int num)
+{
+	struct dvb_usb_device *d = i2c_get_adapdata(adap);
+	int ret = 0;
+	u8 ibuf[64], obuf[64];
+
+	if (mutex_lock_interruptible(&d->i2c_mutex) < 0)
+		return -EAGAIN;
+
+	if (num > 2) {
+		printk(KERN_ERR
+		"dvbsky_usb: too many i2c messages[%d] than 2.", num);
+		ret = -EOPNOTSUPP;
+		goto i2c_error;
+	}
+
+	if (num == 1) {
+		if (msg[0].len > 60) {
+			printk(KERN_ERR
+			"dvbsky_usb: too many i2c bytes[%d] than 60.",
+			msg[0].len);
+			ret = -EOPNOTSUPP;
+			goto i2c_error;
+		}
+		if (msg[0].flags & I2C_M_RD) {
+			/* single read */
+			obuf[0] = 0x09;
+			obuf[1] = 0;
+			obuf[2] = msg[0].len;
+			obuf[3] = msg[0].addr;
+			ret = dvb_usbv2_generic_rw(d, obuf, 4,
+					ibuf, msg[0].len + 1);
+			if (ret)
+				dev_err(&d->udev->dev, "%s: %s() " \
+					"failed=%d\n",
+					KBUILD_MODNAME, __func__, ret);
+			/*dprintk("%s(): read status = %d\n",
+				__func__, ibuf[0]);*/
+			if (!ret)
+				memcpy(msg[0].buf, &ibuf[1], msg[0].len);
+		} else {
+			/* write */
+			obuf[0] = 0x08;
+			obuf[1] = msg[0].addr;
+			obuf[2] = msg[0].len;
+			memcpy(&obuf[3], msg[0].buf, msg[0].len);
+			ret = dvb_usbv2_generic_rw(d, obuf,
+					msg[0].len + 3, ibuf, 1);
+			if (ret)
+				dev_err(&d->udev->dev, "%s: %s() " \
+					"failed=%d\n",
+					KBUILD_MODNAME, __func__, ret);
+			/*dprintk("%s(): write status = %d\n",
+				__func__, ibuf[0]);*/
+		}
+	} else {
+		if ((msg[0].len > 60) || (msg[1].len > 60)) {
+			printk(KERN_ERR
+			"dvbsky_usb: too many i2c bytes[w-%d][r-%d] than 60.",
+			msg[0].len, msg[1].len);
+			ret = -EOPNOTSUPP;
+			goto i2c_error;
+		}
+		/* write then read */
+		obuf[0] = 0x09;
+		obuf[1] = msg[0].len;
+		obuf[2] = msg[1].len;
+		obuf[3] = msg[0].addr;
+		memcpy(&obuf[4], msg[0].buf, msg[0].len);
+		ret = dvb_usbv2_generic_rw(d, obuf,
+			msg[0].len + 4, ibuf, msg[1].len + 1);
+		if (ret)
+			dev_err(&d->udev->dev, "%s: %s() " \
+				"failed=%d\n", KBUILD_MODNAME, __func__, ret);
+		/*dprintk("%s(): write then read status = %d\n",
+			__func__, ibuf[0]);*/
+		if (!ret)
+			memcpy(msg[1].buf, &ibuf[1], msg[1].len);
+	}
+i2c_error:
+	mutex_unlock(&d->i2c_mutex);
+	return (ret) ? ret : num;
+}
+
+static u32 dvbsky_i2c_func(struct i2c_adapter *adapter)
+{
+	return I2C_FUNC_I2C;
+}
+
+static struct i2c_algorithm dvbsky_i2c_algo = {
+	.master_xfer   = dvbsky_i2c_xfer,
+	.functionality = dvbsky_i2c_func,
+};
+
+#if IS_ENABLED(CONFIG_RC_CORE)
+static int dvbsky_rc_query(struct dvb_usb_device *d)
+{
+
+	u32 code = 0xffff, scancode;
+	u8 rc5_command, rc5_system;
+	u8 obuf[2], ibuf[2], toggle;
+	int ret;
+	obuf[0] = 0x10;
+	ret = dvb_usbv2_generic_rw(d, obuf, 1, ibuf, 2);
+	if (ret)
+		dev_err(&d->udev->dev, "%s: %s() " \
+				"failed=%d\n", KBUILD_MODNAME, __func__, ret);
+	if (ret == 0)
+		code = (ibuf[0] << 8) | ibuf[1];
+	if (code != 0xffff) {
+		dprintk("rc code: %x \n", code);
+		rc5_command = code & 0x3F;
+		rc5_system = (code & 0x7C0) >> 6;
+		toggle = (code & 0x800) ? 1 : 0;
+		scancode = rc5_system << 8 | rc5_command;
+		rc_keydown(d->rc_dev, RC_TYPE_RC5, scancode, toggle);
+	}
+	return 0;
+}
+
+static int dvbsky_get_rc_config(struct dvb_usb_device *d, struct dvb_usb_rc *rc)
+{
+	rc->allowed_protos = RC_BIT_RC5;
+	rc->query          = dvbsky_rc_query;
+	rc->interval       = 300;
+	return 0;
+}
+#else
+	#define dvbsky_get_rc_config NULL
+#endif
+
+static int dvbsky_usb_set_voltage(struct dvb_frontend *fe,
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
+	dvbsky_gpio_ctrl(d, 0x80, value);
+
+	return state->fe_set_voltage(fe, voltage);
+}
+
+static int dvbsky_read_mac_addr(struct dvb_usb_adapter *adap, u8 mac[6])
+{
+	struct dvb_usb_device *d = adap_to_d(adap);
+	u8 obuf[] = { 0x1e, 0x00 };
+	u8 ibuf[6] = { 0 };
+	struct i2c_msg msg[] = {
+		{
+			.addr = 0x51,
+			.flags = 0,
+			.buf = obuf,
+			.len = 2,
+		}, {
+			.addr = 0x51,
+			.flags = I2C_M_RD,
+			.buf = ibuf,
+			.len = 6,
+		}
+	};
+
+	if (i2c_transfer(&d->i2c_adap, msg, 2) == 2)
+		memcpy(mac, ibuf, 6);
+
+	printk(KERN_INFO "dvbsky_usb MAC address=%pM\n", mac);
+
+	return 0;
+}
+
+static int dvbsky_usb_read_status(struct dvb_frontend *fe, fe_status_t *status)
+{
+	struct dvb_usb_device *d = fe_to_d(fe);
+	struct dvbsky_state *state = d_to_priv(d);
+	int ret;
+
+	ret = state->fe_read_status(fe, status);
+
+	/* it need resync slave fifo when signal change from unlock to lock.*/
+	if ((*status & FE_HAS_LOCK) && (!state->last_lock))
+		dvbsky_stream_ctrl(d, 1);
+
+	state->last_lock = (*status & FE_HAS_LOCK) ? 1 : 0;
+	return ret;
+}
+
+static const struct m88ds3103_config dvbsky_s960_m88ds3103_config = {
+	.i2c_addr = 0x68,
+	.clock = 27000000,
+	.i2c_wr_max = 33,
+	.clock_out = 0,
+	.ts_mode = M88DS3103_TS_CI,
+	.ts_clk = 16000,
+	.ts_clk_pol = 0,
+	.agc = 0x99,
+	.pin_ctrl = 0x83,
+};
+
+static int dvbsky_s960_attach(struct dvb_usb_adapter *adap)
+{
+	struct dvbsky_state *state = adap_to_priv(adap);
+	struct dvb_usb_device *d = adap_to_d(adap);
+	int ret = 0;
+	/* demod I2C adapter */
+	struct i2c_adapter *i2c_adapter;
+	struct i2c_client *client;
+	struct i2c_board_info info;
+	struct m88ts2022_config m88ts2022_config = {
+			.clock = 27000000,
+		};
+	memset(&info, 0, sizeof(struct i2c_board_info));
+
+	/* attach demod */
+	adap->fe[0] = dvb_attach(m88ds3103_attach,
+			&dvbsky_s960_m88ds3103_config,
+			&d->i2c_adap,
+			&i2c_adapter);
+	if (!adap->fe[0]) {
+		printk(KERN_ERR "dvbsky_s960_attach fail.");
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
+	client = i2c_new_device(i2c_adapter, &info);
+	if (client == NULL || client->dev.driver == NULL) {
+		dvb_frontend_detach(adap->fe[0]);
+		ret = -ENODEV;
+		goto fail_attach;
+	}
+
+	if (!try_module_get(client->dev.driver->owner)) {
+		i2c_unregister_device(client);
+		dvb_frontend_detach(adap->fe[0]);
+		ret = -ENODEV;
+		goto fail_attach;
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
+	adap->fe[0]->ops.set_voltage = dvbsky_usb_set_voltage;
+
+	state->i2c_client_tuner = client;
+
+fail_attach:
+	return ret;
+}
+
+static int dvbsky_identify_state(struct dvb_usb_device *d, const char **name)
+{
+	/*
+	printk(KERN_INFO "%s, build on %s %s(),delay=%d\n",
+	__func__, __DATE__,__TIME__,d->props->generic_bulk_ctrl_delay);
+	*/
+	dvbsky_gpio_ctrl(d, 0x04, 1);
+	msleep(10);
+	dvbsky_gpio_ctrl(d, 0x83, 0);
+	dvbsky_gpio_ctrl(d, 0xc0, 1);
+	msleep(100);
+	dvbsky_gpio_ctrl(d, 0x83, 1);
+	dvbsky_gpio_ctrl(d, 0xc0, 0);
+	msleep(50);
+
+	return WARM;
+}
+
+static int dvbsky_init(struct dvb_usb_device *d)
+{
+	struct dvbsky_state *state = d_to_priv(d);
+
+	/* use default interface */
+	/*
+	ret = usb_set_interface(d->udev, 0, 0);
+	if (ret)
+		return ret;
+	*/
+	mutex_init(&state->stream_mutex);
+
+	state->last_lock = 0;
+
+	return 0;
+}
+
+static void dvbsky_exit(struct dvb_usb_device *d)
+{
+	struct dvbsky_state *state = d_to_priv(d);
+	struct i2c_client *client;
+
+	client = state->i2c_client_tuner;
+	/* remove I2C tuner */
+	if (client) {
+		module_put(client->dev.driver->owner);
+		i2c_unregister_device(client);
+	}
+}
+
+/* DVB USB Driver stuff */
+static struct dvb_usb_device_properties dvbsky_s960_props = {
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
+	.frontend_attach  = dvbsky_s960_attach,
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
+static const struct usb_device_id dvbsky_id_table[] = {
+	{ DVB_USB_DEVICE(0x0572, 0x6831,
+		&dvbsky_s960_props, "DVBSky S960/S860", RC_MAP_DVBSKY) },
+	{ }
+};
+MODULE_DEVICE_TABLE(usb, dvbsky_id_table);
+
+static struct usb_driver dvbsky_usb_driver = {
+	.name = KBUILD_MODNAME,
+	.id_table = dvbsky_id_table,
+	.probe = dvb_usbv2_probe,
+	.disconnect = dvb_usbv2_disconnect,
+	.suspend = dvb_usbv2_suspend,
+	.resume = dvb_usbv2_resume,
+	.reset_resume = dvb_usbv2_reset_resume,
+	.no_dynamic_id = 1,
+	.soft_unbind = 1,
+};
+
+module_usb_driver(dvbsky_usb_driver);
+
+MODULE_AUTHOR("Max nibble <nibble.max@gmail.com>");
+MODULE_DESCRIPTION("Driver for DVBSky USB");
+MODULE_LICENSE("GPL");
  

