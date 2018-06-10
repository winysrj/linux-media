Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f68.google.com ([209.85.160.68]:44736 "EHLO
        mail-pl0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751845AbeFJOqS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 10 Jun 2018 10:46:18 -0400
Received: by mail-pl0-f68.google.com with SMTP id z9-v6so10857032plk.11
        for <linux-media@vger.kernel.org>; Sun, 10 Jun 2018 07:46:17 -0700 (PDT)
From: tskd08@gmail.com
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, Akihiro Tsukada <tskd08@gmail.com>,
        crope@iki.fi
Subject: [PATCH v7] dvb-usb/friio, dvb-usb-v2/gl861: decompose friio and merge with gl861
Date: Sun, 10 Jun 2018 23:45:31 +0900
Message-Id: <20180610144531.7721-1-tskd08@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Akihiro Tsukada <tskd08@gmail.com>

Friio device contains "gl861" bridge and "tc90522" demod,
for which the separate drivers are already in the kernel.
But friio driver was monolithic and did not use them,
practically copying those features.
This patch decomposes friio driver into sub drivers and
re-uses existing ones, thus reduces some code.

It adds some features to gl861,
to support the friio-specific init/config of the devices
and implement i2c communications to the tuner via demod
with USB vendor requests.

Signed-off-by: Akihiro Tsukada <tskd08@gmail.com>
---
Changes since v6:
- separate algorithm/adapter for tuner i2c
- remove the hack for module ref-counting (fix in the tuner driver)
- cut redundant sleeps in friio init/config
- add comments on Friio-specific init/config and i2c

Changes since v5:
- specify chip name literally

Changes since v4:
- use new style of specifying pll_desc id of the tuner driver

Changes since v3:
- make dvb_usb_device_properties static

Changes since v2:
(patch #27928, dvb-usb-friio: split and merge into dvb-usbv2-gl861)
 - used the new i2c binding helpers instead of my own one
 - merged gl861-friio.c with gl861.c

 drivers/media/usb/dvb-usb-v2/Kconfig |   5 +-
 drivers/media/usb/dvb-usb-v2/gl861.c | 471 ++++++++++++++++++++++++
 drivers/media/usb/dvb-usb-v2/gl861.h |   1 +
 drivers/media/usb/dvb-usb/Kconfig    |   6 -
 drivers/media/usb/dvb-usb/Makefile   |   3 -
 drivers/media/usb/dvb-usb/friio-fe.c | 441 ----------------------
 drivers/media/usb/dvb-usb/friio.c    | 522 ---------------------------
 drivers/media/usb/dvb-usb/friio.h    |  99 -----
 8 files changed, 476 insertions(+), 1072 deletions(-)
 delete mode 100644 drivers/media/usb/dvb-usb/friio-fe.c
 delete mode 100644 drivers/media/usb/dvb-usb/friio.c
 delete mode 100644 drivers/media/usb/dvb-usb/friio.h

diff --git a/drivers/media/usb/dvb-usb-v2/Kconfig b/drivers/media/usb/dvb-usb-v2/Kconfig
index 37053477b84..9c352b2999d 100644
--- a/drivers/media/usb/dvb-usb-v2/Kconfig
+++ b/drivers/media/usb/dvb-usb-v2/Kconfig
@@ -96,10 +96,13 @@ config DVB_USB_GL861
 	tristate "Genesys Logic GL861 USB2.0 support"
 	depends on DVB_USB_V2
 	select DVB_ZL10353 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_TC90522 if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_QT1010 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_PLL if MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Say Y here to support the MSI Megasky 580 (55801) DVB-T USB2.0
-	  receiver with USB ID 0db0:5581.
+	  receiver with USB ID 0db0:5581, Friio White ISDB-T receiver
+	  with USB ID 0x7a69:0001.
 
 config DVB_USB_LME2510
 	tristate "LME DM04/QQBOX DVB-S USB2.0 support"
diff --git a/drivers/media/usb/dvb-usb-v2/gl861.c b/drivers/media/usb/dvb-usb-v2/gl861.c
index 4817dfd3e65..28c28c68015 100644
--- a/drivers/media/usb/dvb-usb-v2/gl861.c
+++ b/drivers/media/usb/dvb-usb-v2/gl861.c
@@ -6,10 +6,14 @@
  *
  * see Documentation/dvb/README.dvb-usb for more information
  */
+#include <linux/string.h>
+
 #include "gl861.h"
 
 #include "zl10353.h"
 #include "qt1010.h"
+#include "tc90522.h"
+#include "dvb-pll.h"
 
 DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
@@ -162,11 +166,478 @@ static struct dvb_usb_device_properties gl861_props = {
 	}
 };
 
+
+/*
+ * For Fiio
+ */
+
+struct friio_priv {
+	struct i2c_adapter *demod_sub_i2c;
+	struct i2c_client  *i2c_client_demod;
+	struct i2c_client  *i2c_client_tuner;
+	struct i2c_adapter tuner_adap;
+};
+
+struct friio_config {
+	struct i2c_board_info demod_info;
+	struct tc90522_config demod_cfg;
+
+	struct i2c_board_info tuner_info;
+	struct dvb_pll_config tuner_cfg;
+};
+
+static const struct friio_config friio_config = {
+	.demod_info = { I2C_BOARD_INFO(TC90522_I2C_DEV_TER, 0x18), },
+	.tuner_info = { I2C_BOARD_INFO("tua6034_friio", 0x60), },
+};
+
+/* For another type of I2C:
+ * message sent by a USB control-read/write transaction with data stage.
+ * Used in init/config of Friio.
+ */
+static int
+gl861_i2c_write_ex(struct dvb_usb_device *d, u8 addr, u8 *wbuf, u16 wlen)
+{
+	u8 *buf;
+	int ret;
+
+	buf = kmalloc(wlen, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	memcpy(buf, wbuf, wlen);
+	ret = usb_control_msg(d->udev, usb_sndctrlpipe(d->udev, 0),
+				 GL861_REQ_I2C_RAW, GL861_WRITE,
+				 addr << (8 + 1), 0x0100, buf, wlen, 2000);
+	kfree(buf);
+	return ret;
+}
+
+static int
+gl861_i2c_read_ex(struct dvb_usb_device *d, u8 addr, u8 *rbuf, u16 rlen)
+{
+	u8 *buf;
+	int ret;
+
+	buf = kmalloc(rlen, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	ret = usb_control_msg(d->udev, usb_rcvctrlpipe(d->udev, 0),
+				 GL861_REQ_I2C_READ, GL861_READ,
+				 addr << (8 + 1), 0x0100, buf, rlen, 2000);
+	if (ret > 0 && rlen > 0)
+		memcpy(buf, rbuf, rlen);
+	kfree(buf);
+	return ret;
+}
+
+/* For I2C transactions to the tuner of Friio (dvb_pll).
+ *
+ * Friio uses irregular USB encapsulation for tuner i2c transactions:
+ * write transacions are encapsulated with a different USB 'request' value.
+ *
+ * Although all transactions are sent via the demod(tc90522)
+ * and the demod provides an i2c adapter for them, it cannot be used in Friio
+ * since it assumes using the same parent adapter with the demod,
+ * which does not use the request value and uses same one for both read/write.
+ * So we define a dedicated i2c adapter here.
+ */
+
+static int
+friio_i2c_tuner_read(struct dvb_usb_device *d, struct i2c_msg *msg)
+{
+	struct friio_priv *priv;
+	u8 addr;
+
+	priv = d_to_priv(d);
+	addr = priv->i2c_client_demod->addr;
+	return gl861_i2c_read_ex(d, addr, msg->buf, msg->len);
+}
+
+static int
+friio_i2c_tuner_write(struct dvb_usb_device *d, struct i2c_msg *msg)
+{
+	u8 *buf;
+	int ret;
+	struct friio_priv *priv;
+
+	priv = d_to_priv(d);
+
+	if (msg->len < 1)
+		return -EINVAL;
+
+	buf = kmalloc(msg->len + 1, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+	buf[0] = msg->addr << 1;
+	memcpy(buf + 1, msg->buf, msg->len);
+
+	ret = usb_control_msg(d->udev, usb_sndctrlpipe(d->udev, 0),
+				 GL861_REQ_I2C_RAW, GL861_WRITE,
+				 priv->i2c_client_demod->addr << (8 + 1),
+				 0xFE, buf, msg->len + 1, 2000);
+	kfree(buf);
+	return ret;
+}
+
+static int friio_tuner_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msg[],
+				int num)
+{
+	struct dvb_usb_device *d = i2c_get_adapdata(adap);
+	int i;
+
+	if (num > 2)
+		return -EINVAL;
+
+	if (mutex_lock_interruptible(&d->i2c_mutex) < 0)
+		return -EAGAIN;
+
+	for (i = 0; i < num; i++) {
+		int ret;
+
+		if (msg[i].flags & I2C_M_RD)
+			ret = friio_i2c_tuner_read(d, &msg[i]);
+		else
+			ret = friio_i2c_tuner_write(d, &msg[i]);
+
+		if (ret < 0)
+			break;
+
+		usleep_range(1000, 2000); /* avoid I2C errors */
+	}
+
+	mutex_unlock(&d->i2c_mutex);
+	return i;
+}
+
+static struct i2c_algorithm friio_tuner_i2c_algo = {
+	.master_xfer   = friio_tuner_i2c_xfer,
+	.functionality = gl861_i2c_func,
+};
+
+/* GPIO control in Friio */
+
+#define FRIIO_CTL_LNB (1 << 0)
+#define FRIIO_CTL_STROBE (1 << 1)
+#define FRIIO_CTL_CLK (1 << 2)
+#define FRIIO_CTL_LED (1 << 3)
+
+#define FRIIO_LED_RUNNING 0x6400ff64
+#define FRIIO_LED_STOPPED 0x96ff00ff
+
+/* control PIC16F676 attached to Friio */
+static int friio_ext_ctl(struct dvb_usb_device *d,
+			    u32 sat_color, int power_on)
+{
+	int i, ret;
+	struct i2c_msg msg;
+	u8 *buf;
+	u32 mask;
+	u8 power = (power_on) ? FRIIO_CTL_LNB : 0;
+
+	buf = kmalloc(2, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	msg.addr = 0x00;
+	msg.flags = 0;
+	msg.len = 2;
+	msg.buf = buf;
+	buf[0] = 0x00;
+
+	/* send 2bit header (&B10) */
+	buf[1] = power | FRIIO_CTL_LED | FRIIO_CTL_STROBE;
+	ret = i2c_transfer(&d->i2c_adap, &msg, 1);
+	buf[1] |= FRIIO_CTL_CLK;
+	ret += i2c_transfer(&d->i2c_adap, &msg, 1);
+
+	buf[1] = power | FRIIO_CTL_STROBE;
+	ret += i2c_transfer(&d->i2c_adap, &msg, 1);
+	buf[1] |= FRIIO_CTL_CLK;
+	ret += i2c_transfer(&d->i2c_adap, &msg, 1);
+
+	/* send 32bit(satur, R, G, B) data in serial */
+	mask = 1 << 31;
+	for (i = 0; i < 32; i++) {
+		buf[1] = power | FRIIO_CTL_STROBE;
+		if (sat_color & mask)
+			buf[1] |= FRIIO_CTL_LED;
+		ret += i2c_transfer(&d->i2c_adap, &msg, 1);
+		buf[1] |= FRIIO_CTL_CLK;
+		ret += i2c_transfer(&d->i2c_adap, &msg, 1);
+		mask >>= 1;
+	}
+
+	/* set the strobe off */
+	buf[1] = power;
+	ret += i2c_transfer(&d->i2c_adap, &msg, 1);
+	buf[1] |= FRIIO_CTL_CLK;
+	ret += i2c_transfer(&d->i2c_adap, &msg, 1);
+
+	kfree(buf);
+	return (ret == 70) ? 0 : -EREMOTEIO;
+}
+
+/* init/config of gl861 for Friio */
+/* NOTE:
+ * This function cannot be moved to friio_init()/dvb_usbv2_init(),
+ * because the init defined here must be done before any activities like I2C,
+ * but friio_init() is called by dvb-usbv2 after {_frontend, _tuner}_attach(),
+ * where I2C communication is used.
+ * Thus this function is set to be called from _power_ctl().
+ *
+ * Since it will be called on the early init stage
+ * where the i2c adapter is not initialized yet,
+ * we cannot use i2c_transfer() here.
+ */
+static int friio_reset(struct dvb_usb_device *d)
+{
+	int i, ret;
+	u8 wbuf[2], rbuf[2];
+
+	static const u8 friio_init_cmds[][2] = {
+		{0x33, 0x08}, {0x37, 0x40}, {0x3a, 0x1f}, {0x3b, 0xff},
+		{0x3c, 0x1f}, {0x3d, 0xff}, {0x38, 0x00}, {0x35, 0x00},
+		{0x39, 0x00}, {0x36, 0x00},
+	};
+
+	ret = usb_set_interface(d->udev, 0, 0);
+	if (ret < 0)
+		return ret;
+
+	wbuf[0] = 0x11;
+	wbuf[1] = 0x02;
+	ret = gl861_i2c_msg(d, 0x00, wbuf, 2, NULL, 0);
+	if (ret < 0)
+		return ret;
+	usleep_range(2000, 3000);
+
+	wbuf[0] = 0x11;
+	wbuf[1] = 0x00;
+	ret = gl861_i2c_msg(d, 0x00, wbuf, 2, NULL, 0);
+	if (ret < 0)
+		return ret;
+
+	/*
+	 * Check if the dev is really a Friio White, since it might be
+	 * another device, Friio Black, with the same VID/PID.
+	 */
+
+	usleep_range(1000, 2000);
+	wbuf[0] = 0x03;
+	wbuf[1] = 0x80;
+	ret = gl861_i2c_write_ex(d, 0x09, wbuf, 2);
+	if (ret < 0)
+		return ret;
+
+	usleep_range(2000, 3000);
+	ret = gl861_i2c_read_ex(d, 0x09, rbuf, 2);
+	if (ret < 0)
+		return ret;
+	if (rbuf[0] != 0xff || rbuf[1] != 0xff)
+		return -ENODEV;
+
+
+	usleep_range(1000, 2000);
+	ret = gl861_i2c_write_ex(d, 0x48, wbuf, 2);
+	if (ret < 0)
+		return ret;
+
+	usleep_range(2000, 3000);
+	ret = gl861_i2c_read_ex(d, 0x48, rbuf, 2);
+	if (ret < 0)
+		return ret;
+	if (rbuf[0] != 0xff || rbuf[1] != 0xff)
+		return -ENODEV;
+
+	wbuf[0] = 0x30;
+	wbuf[1] = 0x04;
+	ret = gl861_i2c_msg(d, 0x00, wbuf, 2, NULL, 0);
+	if (ret < 0)
+		return ret;
+
+	wbuf[0] = 0x00;
+	wbuf[1] = 0x01;
+	ret = gl861_i2c_msg(d, 0x00, wbuf, 2, NULL, 0);
+	if (ret < 0)
+		return ret;
+
+	wbuf[0] = 0x06;
+	wbuf[1] = 0x0f;
+	ret = gl861_i2c_msg(d, 0x00, wbuf, 2, NULL, 0);
+	if (ret < 0)
+		return ret;
+
+	for (i = 0; i < ARRAY_SIZE(friio_init_cmds); i++) {
+		ret = gl861_i2c_msg(d, 0x00, (u8 *)friio_init_cmds[i], 2,
+				      NULL, 0);
+		if (ret < 0)
+			return ret;
+	}
+	return 0;
+}
+
+/*
+ * DVB callbacks for Friio
+ */
+
+static int friio_power_ctrl(struct dvb_usb_device *d, int onoff)
+{
+	return onoff ? friio_reset(d) : 0;
+}
+
+static int friio_frontend_attach(struct dvb_usb_adapter *adap)
+{
+	const struct i2c_board_info *info;
+	struct dvb_usb_device *d;
+	struct tc90522_config cfg;
+	struct i2c_client *cl;
+	struct friio_priv *priv;
+
+	info = &friio_config.demod_info;
+	d = adap_to_d(adap);
+	cl = dvb_module_probe("tc90522", info->type,
+			      &d->i2c_adap, info->addr, &cfg);
+	if (!cl)
+		return -ENODEV;
+	adap->fe[0] = cfg.fe;
+
+	/* ignore cfg.tuner_i2c and create new one */
+	priv = adap_to_priv(adap);
+	priv->i2c_client_demod = cl;
+	priv->tuner_adap.algo = &friio_tuner_i2c_algo;
+	priv->tuner_adap.dev.parent = &d->udev->dev;
+	strlcpy(priv->tuner_adap.name, d->name, sizeof(priv->tuner_adap.name));
+	strlcat(priv->tuner_adap.name, "-tuner", sizeof(priv->tuner_adap.name));
+	priv->demod_sub_i2c = &priv->tuner_adap;
+	i2c_set_adapdata(&priv->tuner_adap, d);
+
+	return i2c_add_adapter(&priv->tuner_adap);
+}
+
+static int friio_frontend_detach(struct dvb_usb_adapter *adap)
+{
+	struct friio_priv *priv;
+
+	priv = adap_to_priv(adap);
+	i2c_del_adapter(&priv->tuner_adap);
+	dvb_module_release(priv->i2c_client_demod);
+	return 0;
+}
+
+static int friio_tuner_attach(struct dvb_usb_adapter *adap)
+{
+	const struct i2c_board_info *info;
+	struct dvb_pll_config cfg;
+	struct i2c_client *cl;
+	struct friio_priv *priv;
+
+	priv = adap_to_priv(adap);
+	info = &friio_config.tuner_info;
+	cfg = friio_config.tuner_cfg;
+	cfg.fe = adap->fe[0];
+
+	cl = dvb_module_probe("dvb_pll", info->type,
+			      priv->demod_sub_i2c, info->addr, &cfg);
+	if (!cl)
+		return -ENODEV;
+	priv->i2c_client_tuner = cl;
+	return 0;
+}
+
+static int friio_tuner_detach(struct dvb_usb_adapter *adap)
+{
+	struct friio_priv *priv;
+
+	priv = adap_to_priv(adap);
+	dvb_module_release(priv->i2c_client_tuner);
+	return 0;
+}
+
+static int friio_init(struct dvb_usb_device *d)
+{
+	int i;
+	int ret;
+	struct friio_priv *priv;
+
+	static const u8 demod_init[][2] = {
+		{0x01, 0x40}, {0x04, 0x38}, {0x05, 0x40}, {0x07, 0x40},
+		{0x0f, 0x4f}, {0x11, 0x21}, {0x12, 0x0b}, {0x13, 0x2f},
+		{0x14, 0x31}, {0x16, 0x02}, {0x21, 0xc4}, {0x22, 0x20},
+		{0x2c, 0x79}, {0x2d, 0x34}, {0x2f, 0x00}, {0x30, 0x28},
+		{0x31, 0x31}, {0x32, 0xdf}, {0x38, 0x01}, {0x39, 0x78},
+		{0x3b, 0x33}, {0x3c, 0x33}, {0x48, 0x90}, {0x51, 0x68},
+		{0x5e, 0x38}, {0x71, 0x00}, {0x72, 0x08}, {0x77, 0x00},
+		{0xc0, 0x21}, {0xc1, 0x10}, {0xe4, 0x1a}, {0xea, 0x1f},
+		{0x77, 0x00}, {0x71, 0x00}, {0x71, 0x00}, {0x76, 0x0c},
+	};
+
+	/* power on LNA? */
+	ret = friio_ext_ctl(d, FRIIO_LED_STOPPED, true);
+	if (ret < 0)
+		return ret;
+	msleep(20);
+
+	/* init/config demod */
+	priv = d_to_priv(d);
+	for (i = 0; i < ARRAY_SIZE(demod_init); i++) {
+		int ret;
+
+		ret = i2c_master_send(priv->i2c_client_demod, demod_init[i], 2);
+		if (ret < 0)
+			return ret;
+	}
+	msleep(100);
+	return 0;
+}
+
+static void friio_exit(struct dvb_usb_device *d)
+{
+	friio_ext_ctl(d, FRIIO_LED_STOPPED, false);
+}
+
+static int friio_streaming_ctrl(struct dvb_frontend *fe, int onoff)
+{
+	u32 led_color;
+
+	led_color = onoff ? FRIIO_LED_RUNNING : FRIIO_LED_STOPPED;
+	return friio_ext_ctl(fe_to_d(fe), led_color, true);
+}
+
+
+static struct dvb_usb_device_properties friio_props = {
+	.driver_name = KBUILD_MODNAME,
+	.owner = THIS_MODULE,
+	.adapter_nr = adapter_nr,
+
+	.size_of_priv = sizeof(struct friio_priv),
+
+	.i2c_algo = &gl861_i2c_algo,
+	.power_ctrl = friio_power_ctrl,
+	.frontend_attach = friio_frontend_attach,
+	.frontend_detach = friio_frontend_detach,
+	.tuner_attach = friio_tuner_attach,
+	.tuner_detach = friio_tuner_detach,
+	.init = friio_init,
+	.exit = friio_exit,
+	.streaming_ctrl = friio_streaming_ctrl,
+
+	.num_adapters = 1,
+	.adapter = {
+		{
+			.stream = DVB_USB_STREAM_BULK(0x01, 8, 16384),
+		}
+	}
+};
+
 static const struct usb_device_id gl861_id_table[] = {
 	{ DVB_USB_DEVICE(USB_VID_MSI, USB_PID_MSI_MEGASKY580_55801,
 		&gl861_props, "MSI Mega Sky 55801 DVB-T USB2.0", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_ALINK, USB_VID_ALINK_DTU,
 		&gl861_props, "A-LINK DTU DVB-T USB2.0", NULL) },
+	{ DVB_USB_DEVICE(USB_VID_774, USB_PID_FRIIO_WHITE,
+		&friio_props, "774 Friio White ISDB-T USB2.0", NULL) },
 	{ }
 };
 MODULE_DEVICE_TABLE(usb, gl861_id_table);
diff --git a/drivers/media/usb/dvb-usb-v2/gl861.h b/drivers/media/usb/dvb-usb-v2/gl861.h
index b651b857e03..02c00e10748 100644
--- a/drivers/media/usb/dvb-usb-v2/gl861.h
+++ b/drivers/media/usb/dvb-usb-v2/gl861.h
@@ -9,5 +9,6 @@
 
 #define GL861_REQ_I2C_WRITE	0x01
 #define GL861_REQ_I2C_READ	0x02
+#define GL861_REQ_I2C_RAW	0x03
 
 #endif
diff --git a/drivers/media/usb/dvb-usb/Kconfig b/drivers/media/usb/dvb-usb/Kconfig
index 2651ae27734..1990d1c975e 100644
--- a/drivers/media/usb/dvb-usb/Kconfig
+++ b/drivers/media/usb/dvb-usb/Kconfig
@@ -312,12 +312,6 @@ config DVB_USB_DTV5100
 	help
 	  Say Y here to support the AME DTV-5100 USB2.0 DVB-T receiver.
 
-config DVB_USB_FRIIO
-	tristate "Friio ISDB-T USB2.0 Receiver support"
-	depends on DVB_USB
-	help
-	  Say Y here to support the Japanese DTV receiver Friio.
-
 config DVB_USB_AZ6027
 	tristate "Azurewave DVB-S/S2 USB2.0 AZ6027 support"
 	depends on DVB_USB
diff --git a/drivers/media/usb/dvb-usb/Makefile b/drivers/media/usb/dvb-usb/Makefile
index 9ad2618408e..407d90ca8be 100644
--- a/drivers/media/usb/dvb-usb/Makefile
+++ b/drivers/media/usb/dvb-usb/Makefile
@@ -71,9 +71,6 @@ obj-$(CONFIG_DVB_USB_DTV5100) += dvb-usb-dtv5100.o
 dvb-usb-cinergyT2-objs := cinergyT2-core.o cinergyT2-fe.o
 obj-$(CONFIG_DVB_USB_CINERGY_T2) += dvb-usb-cinergyT2.o
 
-dvb-usb-friio-objs := friio.o friio-fe.o
-obj-$(CONFIG_DVB_USB_FRIIO) += dvb-usb-friio.o
-
 dvb-usb-az6027-objs := az6027.o
 obj-$(CONFIG_DVB_USB_AZ6027) += dvb-usb-az6027.o
 
diff --git a/drivers/media/usb/dvb-usb/friio-fe.c b/drivers/media/usb/dvb-usb/friio-fe.c
deleted file mode 100644
index b2830c15754..00000000000
--- a/drivers/media/usb/dvb-usb/friio-fe.c
+++ /dev/null
@@ -1,441 +0,0 @@
-/* DVB USB compliant Linux driver for the Friio USB2.0 ISDB-T receiver.
- *
- * Copyright (C) 2009 Akihiro Tsukada <tskd2@yahoo.co.jp>
- *
- * This module is based off the the gl861 and vp702x modules.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by the Free
- * Software Foundation, version 2.
- *
- * see Documentation/dvb/README.dvb-usb for more information
- */
-#include <linux/init.h>
-#include <linux/string.h>
-#include <linux/slab.h>
-#include <linux/kernel.h>
-
-#include "friio.h"
-
-struct jdvbt90502_state {
-	struct i2c_adapter *i2c;
-	struct dvb_frontend frontend;
-	struct jdvbt90502_config config;
-};
-
-/* NOTE: TC90502 has 16bit register-address? */
-/* register 0x0100 is used for reading PLL status, so reg is u16 here */
-static int jdvbt90502_reg_read(struct jdvbt90502_state *state,
-			       const u16 reg, u8 *buf, const size_t count)
-{
-	int ret;
-	u8 wbuf[3];
-	struct i2c_msg msg[2];
-
-	wbuf[0] = reg & 0xFF;
-	wbuf[1] = 0;
-	wbuf[2] = reg >> 8;
-
-	msg[0].addr = state->config.demod_address;
-	msg[0].flags = 0;
-	msg[0].buf = wbuf;
-	msg[0].len = sizeof(wbuf);
-
-	msg[1].addr = msg[0].addr;
-	msg[1].flags = I2C_M_RD;
-	msg[1].buf = buf;
-	msg[1].len = count;
-
-	ret = i2c_transfer(state->i2c, msg, 2);
-	if (ret != 2) {
-		deb_fe(" reg read failed.\n");
-		return -EREMOTEIO;
-	}
-	return 0;
-}
-
-/* currently 16bit register-address is not used, so reg is u8 here */
-static int jdvbt90502_single_reg_write(struct jdvbt90502_state *state,
-				       const u8 reg, const u8 val)
-{
-	struct i2c_msg msg;
-	u8 wbuf[2];
-
-	wbuf[0] = reg;
-	wbuf[1] = val;
-
-	msg.addr = state->config.demod_address;
-	msg.flags = 0;
-	msg.buf = wbuf;
-	msg.len = sizeof(wbuf);
-
-	if (i2c_transfer(state->i2c, &msg, 1) != 1) {
-		deb_fe(" reg write failed.");
-		return -EREMOTEIO;
-	}
-	return 0;
-}
-
-static int _jdvbt90502_write(struct dvb_frontend *fe, const u8 buf[], int len)
-{
-	struct jdvbt90502_state *state = fe->demodulator_priv;
-	int err, i;
-	for (i = 0; i < len - 1; i++) {
-		err = jdvbt90502_single_reg_write(state,
-						  buf[0] + i, buf[i + 1]);
-		if (err)
-			return err;
-	}
-
-	return 0;
-}
-
-/* read pll status byte via the demodulator's I2C register */
-/* note: Win box reads it by 8B block at the I2C addr 0x30 from reg:0x80 */
-static int jdvbt90502_pll_read(struct jdvbt90502_state *state, u8 *result)
-{
-	int ret;
-
-	/* +1 for reading */
-	u8 pll_addr_byte = (state->config.pll_address << 1) + 1;
-
-	*result = 0;
-
-	ret = jdvbt90502_single_reg_write(state, JDVBT90502_2ND_I2C_REG,
-					  pll_addr_byte);
-	if (ret)
-		goto error;
-
-	ret = jdvbt90502_reg_read(state, 0x0100, result, 1);
-	if (ret)
-		goto error;
-
-	deb_fe("PLL read val:%02x\n", *result);
-	return 0;
-
-error:
-	deb_fe("%s:ret == %d\n", __func__, ret);
-	return -EREMOTEIO;
-}
-
-
-/* set pll frequency via the demodulator's I2C register */
-static int jdvbt90502_pll_set_freq(struct jdvbt90502_state *state, u32 freq)
-{
-	int ret;
-	int retry;
-	u8 res1;
-	u8 res2[9];
-
-	u8 pll_freq_cmd[PLL_CMD_LEN];
-	u8 pll_agc_cmd[PLL_CMD_LEN];
-	struct i2c_msg msg[2];
-	u32 f;
-
-	deb_fe("%s: freq=%d, step=%d\n", __func__, freq,
-	       state->frontend.ops.info.frequency_stepsize);
-	/* freq -> oscilator frequency conversion. */
-	/* freq: 473,000,000 + n*6,000,000 [+ 142857 (center freq. shift)] */
-	f = freq / state->frontend.ops.info.frequency_stepsize;
-	/* add 399[1/7 MHZ] = 57MHz for the IF  */
-	f += 399;
-	/* add center frequency shift if necessary */
-	if (f % 7 == 0)
-		f++;
-	pll_freq_cmd[DEMOD_REDIRECT_REG] = JDVBT90502_2ND_I2C_REG; /* 0xFE */
-	pll_freq_cmd[ADDRESS_BYTE] = state->config.pll_address << 1;
-	pll_freq_cmd[DIVIDER_BYTE1] = (f >> 8) & 0x7F;
-	pll_freq_cmd[DIVIDER_BYTE2] = f & 0xFF;
-	pll_freq_cmd[CONTROL_BYTE] = 0xB2; /* ref.divider:28, 4MHz/28=1/7MHz */
-	pll_freq_cmd[BANDSWITCH_BYTE] = 0x08;	/* UHF band */
-
-	msg[0].addr = state->config.demod_address;
-	msg[0].flags = 0;
-	msg[0].buf = pll_freq_cmd;
-	msg[0].len = sizeof(pll_freq_cmd);
-
-	ret = i2c_transfer(state->i2c, &msg[0], 1);
-	if (ret != 1)
-		goto error;
-
-	udelay(50);
-
-	pll_agc_cmd[DEMOD_REDIRECT_REG] = pll_freq_cmd[DEMOD_REDIRECT_REG];
-	pll_agc_cmd[ADDRESS_BYTE] = pll_freq_cmd[ADDRESS_BYTE];
-	pll_agc_cmd[DIVIDER_BYTE1] = pll_freq_cmd[DIVIDER_BYTE1];
-	pll_agc_cmd[DIVIDER_BYTE2] = pll_freq_cmd[DIVIDER_BYTE2];
-	pll_agc_cmd[CONTROL_BYTE] = 0x9A; /*  AGC_CTRL instead of BANDSWITCH */
-	pll_agc_cmd[AGC_CTRL_BYTE] = 0x50;
-	/* AGC Time Constant 2s, AGC take-over point:103dBuV(lowest) */
-
-	msg[1].addr = msg[0].addr;
-	msg[1].flags = 0;
-	msg[1].buf = pll_agc_cmd;
-	msg[1].len = sizeof(pll_agc_cmd);
-
-	ret = i2c_transfer(state->i2c, &msg[1], 1);
-	if (ret != 1)
-		goto error;
-
-	/* I don't know what these cmds are for,  */
-	/* but the USB log on a windows box contains them */
-	ret = jdvbt90502_single_reg_write(state, 0x01, 0x40);
-	ret |= jdvbt90502_single_reg_write(state, 0x01, 0x00);
-	if (ret)
-		goto error;
-	udelay(100);
-
-	/* wait for the demod to be ready? */
-#define RETRY_COUNT 5
-	for (retry = 0; retry < RETRY_COUNT; retry++) {
-		ret = jdvbt90502_reg_read(state, 0x0096, &res1, 1);
-		if (ret)
-			goto error;
-		/* if (res1 != 0x00) goto error; */
-		ret = jdvbt90502_reg_read(state, 0x00B0, res2, sizeof(res2));
-		if (ret)
-			goto error;
-		if (res2[0] >= 0xA7)
-			break;
-		msleep(100);
-	}
-	if (retry >= RETRY_COUNT) {
-		deb_fe("%s: FE does not get ready after freq setting.\n",
-		       __func__);
-		return -EREMOTEIO;
-	}
-
-	return 0;
-error:
-	deb_fe("%s:ret == %d\n", __func__, ret);
-	return -EREMOTEIO;
-}
-
-static int jdvbt90502_read_status(struct dvb_frontend *fe,
-				  enum fe_status *state)
-{
-	u8 result;
-	int ret;
-
-	*state = FE_HAS_SIGNAL;
-
-	ret = jdvbt90502_pll_read(fe->demodulator_priv, &result);
-	if (ret) {
-		deb_fe("%s:ret == %d\n", __func__, ret);
-		return -EREMOTEIO;
-	}
-
-	*state = FE_HAS_SIGNAL
-		| FE_HAS_CARRIER
-		| FE_HAS_VITERBI
-		| FE_HAS_SYNC;
-
-	if (result & PLL_STATUS_LOCKED)
-		*state |= FE_HAS_LOCK;
-
-	return 0;
-}
-
-static int jdvbt90502_read_signal_strength(struct dvb_frontend *fe,
-					   u16 *strength)
-{
-	int ret;
-	u8 rbuf[37];
-
-	*strength = 0;
-
-	/* status register (incl. signal strength) : 0x89  */
-	/* TODO: read just the necessary registers [0x8B..0x8D]? */
-	ret = jdvbt90502_reg_read(fe->demodulator_priv, 0x0089,
-				  rbuf, sizeof(rbuf));
-
-	if (ret) {
-		deb_fe("%s:ret == %d\n", __func__, ret);
-		return -EREMOTEIO;
-	}
-
-	/* signal_strength: rbuf[2-4] (24bit BE), use lower 16bit for now. */
-	*strength = (rbuf[3] << 8) + rbuf[4];
-	if (rbuf[2])
-		*strength = 0xffff;
-
-	return 0;
-}
-
-static int jdvbt90502_set_frontend(struct dvb_frontend *fe)
-{
-	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
-
-	/**
-	 * NOTE: ignore all the parameters except frequency.
-	 *       others should be fixed to the proper value for ISDB-T,
-	 *       but don't check here.
-	 */
-
-	struct jdvbt90502_state *state = fe->demodulator_priv;
-	int ret;
-
-	deb_fe("%s: Freq:%d\n", __func__, p->frequency);
-
-	/* This driver only works on auto mode */
-	p->inversion = INVERSION_AUTO;
-	p->bandwidth_hz = 6000000;
-	p->code_rate_HP = FEC_AUTO;
-	p->code_rate_LP = FEC_AUTO;
-	p->modulation = QAM_64;
-	p->transmission_mode = TRANSMISSION_MODE_AUTO;
-	p->guard_interval = GUARD_INTERVAL_AUTO;
-	p->hierarchy = HIERARCHY_AUTO;
-	p->delivery_system = SYS_ISDBT;
-
-	ret = jdvbt90502_pll_set_freq(state, p->frequency);
-	if (ret) {
-		deb_fe("%s:ret == %d\n", __func__, ret);
-		return -EREMOTEIO;
-	}
-
-	return 0;
-}
-
-
-/*
- * (reg, val) commad list to initialize this module.
- *  captured on a Windows box.
- */
-static u8 init_code[][2] = {
-	{0x01, 0x40},
-	{0x04, 0x38},
-	{0x05, 0x40},
-	{0x07, 0x40},
-	{0x0F, 0x4F},
-	{0x11, 0x21},
-	{0x12, 0x0B},
-	{0x13, 0x2F},
-	{0x14, 0x31},
-	{0x16, 0x02},
-	{0x21, 0xC4},
-	{0x22, 0x20},
-	{0x2C, 0x79},
-	{0x2D, 0x34},
-	{0x2F, 0x00},
-	{0x30, 0x28},
-	{0x31, 0x31},
-	{0x32, 0xDF},
-	{0x38, 0x01},
-	{0x39, 0x78},
-	{0x3B, 0x33},
-	{0x3C, 0x33},
-	{0x48, 0x90},
-	{0x51, 0x68},
-	{0x5E, 0x38},
-	{0x71, 0x00},
-	{0x72, 0x08},
-	{0x77, 0x00},
-	{0xC0, 0x21},
-	{0xC1, 0x10},
-	{0xE4, 0x1A},
-	{0xEA, 0x1F},
-	{0x77, 0x00},
-	{0x71, 0x00},
-	{0x71, 0x00},
-	{0x76, 0x0C},
-};
-
-static int jdvbt90502_init(struct dvb_frontend *fe)
-{
-	int i = -1;
-	int ret;
-	struct i2c_msg msg;
-
-	struct jdvbt90502_state *state = fe->demodulator_priv;
-
-	deb_fe("%s called.\n", __func__);
-
-	msg.addr = state->config.demod_address;
-	msg.flags = 0;
-	msg.len = 2;
-	for (i = 0; i < ARRAY_SIZE(init_code); i++) {
-		msg.buf = init_code[i];
-		ret = i2c_transfer(state->i2c, &msg, 1);
-		if (ret != 1)
-			goto error;
-	}
-	fe->dtv_property_cache.delivery_system = SYS_ISDBT;
-	msleep(100);
-
-	return 0;
-
-error:
-	deb_fe("%s: init_code[%d] failed. ret==%d\n", __func__, i, ret);
-	return -EREMOTEIO;
-}
-
-
-static void jdvbt90502_release(struct dvb_frontend *fe)
-{
-	struct jdvbt90502_state *state = fe->demodulator_priv;
-	kfree(state);
-}
-
-
-static const struct dvb_frontend_ops jdvbt90502_ops;
-
-struct dvb_frontend *jdvbt90502_attach(struct dvb_usb_device *d)
-{
-	struct jdvbt90502_state *state = NULL;
-
-	deb_info("%s called.\n", __func__);
-
-	/* allocate memory for the internal state */
-	state = kzalloc(sizeof(struct jdvbt90502_state), GFP_KERNEL);
-	if (state == NULL)
-		goto error;
-
-	/* setup the state */
-	state->i2c = &d->i2c_adap;
-	state->config = friio_fe_config;
-
-	/* create dvb_frontend */
-	state->frontend.ops = jdvbt90502_ops;
-	state->frontend.demodulator_priv = state;
-
-	if (jdvbt90502_init(&state->frontend) < 0)
-		goto error;
-
-	return &state->frontend;
-
-error:
-	kfree(state);
-	return NULL;
-}
-
-static const struct dvb_frontend_ops jdvbt90502_ops = {
-	.delsys = { SYS_ISDBT },
-	.info = {
-		.name			= "Comtech JDVBT90502 ISDB-T",
-		.frequency_min		= 473000000, /* UHF 13ch, center */
-		.frequency_max		= 767142857, /* UHF 62ch, center */
-		.frequency_stepsize	= JDVBT90502_PLL_CLK / JDVBT90502_PLL_DIVIDER,
-		.frequency_tolerance	= 0,
-
-		/* NOTE: this driver ignores all parameters but frequency. */
-		.caps = FE_CAN_INVERSION_AUTO |
-			FE_CAN_FEC_1_2 | FE_CAN_FEC_2_3 | FE_CAN_FEC_3_4 |
-			FE_CAN_FEC_4_5 | FE_CAN_FEC_5_6 | FE_CAN_FEC_6_7 |
-			FE_CAN_FEC_7_8 | FE_CAN_FEC_8_9 | FE_CAN_FEC_AUTO |
-			FE_CAN_QAM_16 | FE_CAN_QAM_64 | FE_CAN_QAM_AUTO |
-			FE_CAN_TRANSMISSION_MODE_AUTO |
-			FE_CAN_GUARD_INTERVAL_AUTO |
-			FE_CAN_HIERARCHY_AUTO,
-	},
-
-	.release = jdvbt90502_release,
-
-	.init = jdvbt90502_init,
-	.write = _jdvbt90502_write,
-
-	.set_frontend = jdvbt90502_set_frontend,
-
-	.read_status = jdvbt90502_read_status,
-	.read_signal_strength = jdvbt90502_read_signal_strength,
-};
diff --git a/drivers/media/usb/dvb-usb/friio.c b/drivers/media/usb/dvb-usb/friio.c
deleted file mode 100644
index 16875945e66..00000000000
--- a/drivers/media/usb/dvb-usb/friio.c
+++ /dev/null
@@ -1,522 +0,0 @@
-/* DVB USB compliant Linux driver for the Friio USB2.0 ISDB-T receiver.
- *
- * Copyright (C) 2009 Akihiro Tsukada <tskd2@yahoo.co.jp>
- *
- * This module is based off the the gl861 and vp702x modules.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by the Free
- * Software Foundation, version 2.
- *
- * see Documentation/dvb/README.dvb-usb for more information
- */
-#include "friio.h"
-
-/* debug */
-int dvb_usb_friio_debug;
-module_param_named(debug, dvb_usb_friio_debug, int, 0644);
-MODULE_PARM_DESC(debug,
-		 "set debugging level (1=info,2=xfer,4=rc,8=fe (or-able))."
-		 DVB_USB_DEBUG_STATUS);
-
-DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
-
-/*
- * Indirect I2C access to the PLL via FE.
- * whole I2C protocol data to the PLL is sent via the FE's I2C register.
- * This is done by a control msg to the FE with the I2C data accompanied, and
- * a specific USB request number is assigned for that purpose.
- *
- * this func sends wbuf[1..] to the I2C register wbuf[0] at addr (= at FE).
- * TODO: refoctored, smarter i2c functions.
- */
-static int gl861_i2c_ctrlmsg_data(struct dvb_usb_device *d, u8 addr,
-				  u8 *wbuf, u16 wlen, u8 *rbuf, u16 rlen)
-{
-	u16 index = wbuf[0];	/* must be JDVBT90502_2ND_I2C_REG(=0xFE) */
-	u16 value = addr << (8 + 1);
-	int wo = (rbuf == NULL || rlen == 0);	/* write only */
-	u8 req, type;
-
-	deb_xfer("write to PLL:0x%02x via FE reg:0x%02x, len:%d\n",
-		 wbuf[1], wbuf[0], wlen - 1);
-
-	if (wo && wlen >= 2) {
-		req = GL861_REQ_I2C_DATA_CTRL_WRITE;
-		type = GL861_WRITE;
-		udelay(20);
-		return usb_control_msg(d->udev, usb_sndctrlpipe(d->udev, 0),
-				       req, type, value, index,
-				       &wbuf[1], wlen - 1, 2000);
-	}
-
-	deb_xfer("not supported ctrl-msg, aborting.");
-	return -EINVAL;
-}
-
-/* normal I2C access (without extra data arguments).
- * write to the register wbuf[0] at I2C address addr with the value wbuf[1],
- *  or read from the register wbuf[0].
- * register address can be 16bit (wbuf[2]<<8 | wbuf[0]) if wlen==3
- */
-static int gl861_i2c_msg(struct dvb_usb_device *d, u8 addr,
-			 u8 *wbuf, u16 wlen, u8 *rbuf, u16 rlen)
-{
-	u16 index;
-	u16 value = addr << (8 + 1);
-	int wo = (rbuf == NULL || rlen == 0);	/* write-only */
-	u8 req, type;
-	unsigned int pipe;
-
-	/* special case for the indirect I2C access to the PLL via FE, */
-	if (addr == friio_fe_config.demod_address &&
-	    wbuf[0] == JDVBT90502_2ND_I2C_REG)
-		return gl861_i2c_ctrlmsg_data(d, addr, wbuf, wlen, rbuf, rlen);
-
-	if (wo) {
-		req = GL861_REQ_I2C_WRITE;
-		type = GL861_WRITE;
-		pipe = usb_sndctrlpipe(d->udev, 0);
-	} else {		/* rw */
-		req = GL861_REQ_I2C_READ;
-		type = GL861_READ;
-		pipe = usb_rcvctrlpipe(d->udev, 0);
-	}
-
-	switch (wlen) {
-	case 1:
-		index = wbuf[0];
-		break;
-	case 2:
-		index = wbuf[0];
-		value = value + wbuf[1];
-		break;
-	case 3:
-		/* special case for 16bit register-address */
-		index = (wbuf[2] << 8) | wbuf[0];
-		value = value + wbuf[1];
-		break;
-	default:
-		deb_xfer("wlen = %x, aborting.", wlen);
-		return -EINVAL;
-	}
-	msleep(1);
-	return usb_control_msg(d->udev, pipe, req, type,
-			       value, index, rbuf, rlen, 2000);
-}
-
-/* I2C */
-static int gl861_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msg[],
-			  int num)
-{
-	struct dvb_usb_device *d = i2c_get_adapdata(adap);
-	int i;
-
-
-	if (num > 2)
-		return -EINVAL;
-
-	if (mutex_lock_interruptible(&d->i2c_mutex) < 0)
-		return -EAGAIN;
-
-	for (i = 0; i < num; i++) {
-		/* write/read request */
-		if (i + 1 < num && (msg[i + 1].flags & I2C_M_RD)) {
-			if (gl861_i2c_msg(d, msg[i].addr,
-					  msg[i].buf, msg[i].len,
-					  msg[i + 1].buf, msg[i + 1].len) < 0)
-				break;
-			i++;
-		} else
-			if (gl861_i2c_msg(d, msg[i].addr, msg[i].buf,
-					  msg[i].len, NULL, 0) < 0)
-				break;
-	}
-
-	mutex_unlock(&d->i2c_mutex);
-	return i;
-}
-
-static u32 gl861_i2c_func(struct i2c_adapter *adapter)
-{
-	return I2C_FUNC_I2C;
-}
-
-static int friio_ext_ctl(struct dvb_usb_adapter *adap,
-			 u32 sat_color, int lnb_on)
-{
-	int i;
-	int ret;
-	struct i2c_msg msg;
-	u8 *buf;
-	u32 mask;
-	u8 lnb = (lnb_on) ? FRIIO_CTL_LNB : 0;
-
-	buf = kmalloc(2, GFP_KERNEL);
-	if (!buf)
-		return -ENOMEM;
-
-	msg.addr = 0x00;
-	msg.flags = 0;
-	msg.len = 2;
-	msg.buf = buf;
-
-	buf[0] = 0x00;
-
-	/* send 2bit header (&B10) */
-	buf[1] = lnb | FRIIO_CTL_LED | FRIIO_CTL_STROBE;
-	ret = gl861_i2c_xfer(&adap->dev->i2c_adap, &msg, 1);
-	buf[1] |= FRIIO_CTL_CLK;
-	ret += gl861_i2c_xfer(&adap->dev->i2c_adap, &msg, 1);
-
-	buf[1] = lnb | FRIIO_CTL_STROBE;
-	ret += gl861_i2c_xfer(&adap->dev->i2c_adap, &msg, 1);
-	buf[1] |= FRIIO_CTL_CLK;
-	ret += gl861_i2c_xfer(&adap->dev->i2c_adap, &msg, 1);
-
-	/* send 32bit(satur, R, G, B) data in serial */
-	mask = 1 << 31;
-	for (i = 0; i < 32; i++) {
-		buf[1] = lnb | FRIIO_CTL_STROBE;
-		if (sat_color & mask)
-			buf[1] |= FRIIO_CTL_LED;
-		ret += gl861_i2c_xfer(&adap->dev->i2c_adap, &msg, 1);
-		buf[1] |= FRIIO_CTL_CLK;
-		ret += gl861_i2c_xfer(&adap->dev->i2c_adap, &msg, 1);
-		mask >>= 1;
-	}
-
-	/* set the strobe off */
-	buf[1] = lnb;
-	ret += gl861_i2c_xfer(&adap->dev->i2c_adap, &msg, 1);
-	buf[1] |= FRIIO_CTL_CLK;
-	ret += gl861_i2c_xfer(&adap->dev->i2c_adap, &msg, 1);
-
-	kfree(buf);
-	return (ret == 70);
-}
-
-
-static int friio_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff);
-
-/* TODO: move these init cmds to the FE's init routine? */
-static u8 streaming_init_cmds[][2] = {
-	{0x33, 0x08},
-	{0x37, 0x40},
-	{0x3A, 0x1F},
-	{0x3B, 0xFF},
-	{0x3C, 0x1F},
-	{0x3D, 0xFF},
-	{0x38, 0x00},
-	{0x35, 0x00},
-	{0x39, 0x00},
-	{0x36, 0x00},
-};
-static int cmdlen = sizeof(streaming_init_cmds) / 2;
-
-/*
- * Command sequence in this init function is a replay
- *  of the captured USB commands from the Windows proprietary driver.
- */
-static int friio_initialize(struct dvb_usb_device *d)
-{
-	int ret;
-	int i;
-	int retry = 0;
-	u8 *rbuf, *wbuf;
-
-	deb_info("%s called.\n", __func__);
-
-	wbuf = kmalloc(3, GFP_KERNEL);
-	if (!wbuf)
-		return -ENOMEM;
-
-	rbuf = kmalloc(2, GFP_KERNEL);
-	if (!rbuf) {
-		kfree(wbuf);
-		return -ENOMEM;
-	}
-
-	/* use gl861_i2c_msg instead of gl861_i2c_xfer(), */
-	/* because the i2c device is not set up yet. */
-	wbuf[0] = 0x11;
-	wbuf[1] = 0x02;
-	ret = gl861_i2c_msg(d, 0x00, wbuf, 2, NULL, 0);
-	if (ret < 0)
-		goto error;
-	msleep(2);
-
-	wbuf[0] = 0x11;
-	wbuf[1] = 0x00;
-	ret = gl861_i2c_msg(d, 0x00, wbuf, 2, NULL, 0);
-	if (ret < 0)
-		goto error;
-	msleep(1);
-
-	/* following msgs should be in the FE's init code? */
-	/* cmd sequence to identify the device type? (friio black/white) */
-	wbuf[0] = 0x03;
-	wbuf[1] = 0x80;
-	/* can't use gl861_i2c_cmd, as the register-addr is 16bit(0x0100) */
-	ret = usb_control_msg(d->udev, usb_sndctrlpipe(d->udev, 0),
-			      GL861_REQ_I2C_DATA_CTRL_WRITE, GL861_WRITE,
-			      0x1200, 0x0100, wbuf, 2, 2000);
-	if (ret < 0)
-		goto error;
-
-	msleep(2);
-	wbuf[0] = 0x00;
-	wbuf[2] = 0x01;		/* reg.0x0100 */
-	wbuf[1] = 0x00;
-	ret = gl861_i2c_msg(d, 0x12 >> 1, wbuf, 3, rbuf, 2);
-	/* my Friio White returns 0xffff. */
-	if (ret < 0 || rbuf[0] != 0xff || rbuf[1] != 0xff)
-		goto error;
-
-	msleep(2);
-	wbuf[0] = 0x03;
-	wbuf[1] = 0x80;
-	ret = usb_control_msg(d->udev, usb_sndctrlpipe(d->udev, 0),
-			      GL861_REQ_I2C_DATA_CTRL_WRITE, GL861_WRITE,
-			      0x9000, 0x0100, wbuf, 2, 2000);
-	if (ret < 0)
-		goto error;
-
-	msleep(2);
-	wbuf[0] = 0x00;
-	wbuf[2] = 0x01;		/* reg.0x0100 */
-	wbuf[1] = 0x00;
-	ret = gl861_i2c_msg(d, 0x90 >> 1, wbuf, 3, rbuf, 2);
-	/* my Friio White returns 0xffff again. */
-	if (ret < 0 || rbuf[0] != 0xff || rbuf[1] != 0xff)
-		goto error;
-
-	msleep(1);
-
-restart:
-	/* ============ start DEMOD init cmds ================== */
-	/* read PLL status to clear the POR bit */
-	wbuf[0] = JDVBT90502_2ND_I2C_REG;
-	wbuf[1] = (FRIIO_PLL_ADDR << 1) + 1;	/* +1 for reading */
-	ret = gl861_i2c_msg(d, FRIIO_DEMOD_ADDR, wbuf, 2, NULL, 0);
-	if (ret < 0)
-		goto error;
-
-	msleep(5);
-	/* note: DEMODULATOR has 16bit register-address. */
-	wbuf[0] = 0x00;
-	wbuf[2] = 0x01;		/* reg addr: 0x0100 */
-	wbuf[1] = 0x00;		/* val: not used */
-	ret = gl861_i2c_msg(d, FRIIO_DEMOD_ADDR, wbuf, 3, rbuf, 1);
-	if (ret < 0)
-		goto error;
-/*
-	msleep(1);
-	wbuf[0] = 0x80;
-	wbuf[1] = 0x00;
-	ret = gl861_i2c_msg(d, FRIIO_DEMOD_ADDR, wbuf, 2, rbuf, 1);
-	if (ret < 0)
-		goto error;
- */
-	if (rbuf[0] & 0x80) {	/* still in PowerOnReset state? */
-		if (++retry > 3) {
-			deb_info("failed to get the correct FE demod status:0x%02x\n",
-				 rbuf[0]);
-			goto error;
-		}
-		msleep(100);
-		goto restart;
-	}
-
-	/* TODO: check return value in rbuf */
-	/* =========== end DEMOD init cmds ===================== */
-	msleep(1);
-
-	wbuf[0] = 0x30;
-	wbuf[1] = 0x04;
-	ret = gl861_i2c_msg(d, 0x00, wbuf, 2, NULL, 0);
-	if (ret < 0)
-		goto error;
-
-	msleep(2);
-	/* following 2 cmds unnecessary? */
-	wbuf[0] = 0x00;
-	wbuf[1] = 0x01;
-	ret = gl861_i2c_msg(d, 0x00, wbuf, 2, NULL, 0);
-	if (ret < 0)
-		goto error;
-
-	wbuf[0] = 0x06;
-	wbuf[1] = 0x0F;
-	ret = gl861_i2c_msg(d, 0x00, wbuf, 2, NULL, 0);
-	if (ret < 0)
-		goto error;
-
-	/* some streaming ctl cmds (maybe) */
-	msleep(10);
-	for (i = 0; i < cmdlen; i++) {
-		ret = gl861_i2c_msg(d, 0x00, streaming_init_cmds[i], 2,
-				    NULL, 0);
-		if (ret < 0)
-			goto error;
-		msleep(1);
-	}
-	msleep(20);
-
-	/* change the LED color etc. */
-	ret = friio_streaming_ctrl(&d->adapter[0], 0);
-	if (ret < 0)
-		goto error;
-
-	return 0;
-
-error:
-	kfree(wbuf);
-	kfree(rbuf);
-	deb_info("%s:ret == %d\n", __func__, ret);
-	return -EIO;
-}
-
-/* Callbacks for DVB USB */
-
-static int friio_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff)
-{
-	int ret;
-
-	deb_info("%s called.(%d)\n", __func__, onoff);
-
-	/* set the LED color and saturation (and LNB on) */
-	if (onoff)
-		ret = friio_ext_ctl(adap, 0x6400ff64, 1);
-	else
-		ret = friio_ext_ctl(adap, 0x96ff00ff, 1);
-
-	if (ret != 1) {
-		deb_info("%s failed to send cmdx. ret==%d\n", __func__, ret);
-		return -EREMOTEIO;
-	}
-	return 0;
-}
-
-static int friio_frontend_attach(struct dvb_usb_adapter *adap)
-{
-	if (friio_initialize(adap->dev) < 0)
-		return -EIO;
-
-	adap->fe_adap[0].fe = jdvbt90502_attach(adap->dev);
-	if (adap->fe_adap[0].fe == NULL)
-		return -EIO;
-
-	return 0;
-}
-
-/* DVB USB Driver stuff */
-static struct dvb_usb_device_properties friio_properties;
-
-static int friio_probe(struct usb_interface *intf,
-		       const struct usb_device_id *id)
-{
-	struct dvb_usb_device *d;
-	struct usb_host_interface *alt;
-	int ret;
-
-	if (intf->num_altsetting < GL861_ALTSETTING_COUNT)
-		return -ENODEV;
-
-	alt = usb_altnum_to_altsetting(intf, FRIIO_BULK_ALTSETTING);
-	if (alt == NULL) {
-		deb_rc("not alt found!\n");
-		return -ENODEV;
-	}
-	ret = usb_set_interface(interface_to_usbdev(intf),
-				alt->desc.bInterfaceNumber,
-				alt->desc.bAlternateSetting);
-	if (ret != 0) {
-		deb_rc("failed to set alt-setting!\n");
-		return ret;
-	}
-
-	ret = dvb_usb_device_init(intf, &friio_properties,
-				  THIS_MODULE, &d, adapter_nr);
-	if (ret == 0)
-		friio_streaming_ctrl(&d->adapter[0], 1);
-
-	return ret;
-}
-
-
-struct jdvbt90502_config friio_fe_config = {
-	.demod_address = FRIIO_DEMOD_ADDR,
-	.pll_address = FRIIO_PLL_ADDR,
-};
-
-static struct i2c_algorithm gl861_i2c_algo = {
-	.master_xfer   = gl861_i2c_xfer,
-	.functionality = gl861_i2c_func,
-};
-
-static struct usb_device_id friio_table[] = {
-	{ USB_DEVICE(USB_VID_774, USB_PID_FRIIO_WHITE) },
-	{ }		/* Terminating entry */
-};
-MODULE_DEVICE_TABLE(usb, friio_table);
-
-
-static struct dvb_usb_device_properties friio_properties = {
-	.caps = DVB_USB_IS_AN_I2C_ADAPTER,
-	.usb_ctrl = DEVICE_SPECIFIC,
-
-	.size_of_priv = 0,
-
-	.num_adapters = 1,
-	.adapter = {
-		/* caps:0 =>  no pid filter, 188B TS packet */
-		/* GL861 has a HW pid filter, but no info available. */
-		{
-		.num_frontends = 1,
-		.fe = {{
-			.caps  = 0,
-
-			.frontend_attach  = friio_frontend_attach,
-			.streaming_ctrl = friio_streaming_ctrl,
-
-			.stream = {
-				.type = USB_BULK,
-				/* count <= MAX_NO_URBS_FOR_DATA_STREAM(10) */
-				.count = 8,
-				.endpoint = 0x01,
-				.u = {
-					/* GL861 has 6KB buf inside */
-					.bulk = {
-						.buffersize = 16384,
-					}
-				}
-			},
-		}},
-		}
-	},
-	.i2c_algo = &gl861_i2c_algo,
-
-	.num_device_descs = 1,
-	.devices = {
-		{
-			.name = "774 Friio ISDB-T USB2.0",
-			.cold_ids = { NULL },
-			.warm_ids = { &friio_table[0], NULL },
-		},
-	}
-};
-
-static struct usb_driver friio_driver = {
-	.name		= "dvb_usb_friio",
-	.probe		= friio_probe,
-	.disconnect	= dvb_usb_device_exit,
-	.id_table	= friio_table,
-};
-
-module_usb_driver(friio_driver);
-
-MODULE_AUTHOR("Akihiro Tsukada <tskd2@yahoo.co.jp>");
-MODULE_DESCRIPTION("Driver for Friio ISDB-T USB2.0 Receiver");
-MODULE_VERSION("0.2");
-MODULE_LICENSE("GPL");
diff --git a/drivers/media/usb/dvb-usb/friio.h b/drivers/media/usb/dvb-usb/friio.h
deleted file mode 100644
index 0f461ca10cb..00000000000
--- a/drivers/media/usb/dvb-usb/friio.h
+++ /dev/null
@@ -1,99 +0,0 @@
-/* DVB USB compliant Linux driver for the Friio USB2.0 ISDB-T receiver.
- *
- * Copyright (C) 2009 Akihiro Tsukada <tskd2@yahoo.co.jp>
- *
- * This module is based off the the gl861 and vp702x modules.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by the Free
- * Software Foundation, version 2.
- *
- * see Documentation/dvb/README.dvb-usb for more information
- */
-#ifndef _DVB_USB_FRIIO_H_
-#define _DVB_USB_FRIIO_H_
-
-/**
- *      Friio Components
- *       USB hub:                                AU4254
- *         USB controller(+ TS dmx & streaming): GL861
- *         Frontend:                             comtech JDVBT-90502
- *             (tuner PLL:                       tua6034, I2C addr:(0xC0 >> 1))
- *             (OFDM demodulator:                TC90502, I2C addr:(0x30 >> 1))
- *         LED x3 (+LNB) control:                PIC 16F676
- *         EEPROM:                               24C08
- *
- *        (USB smart card reader:                AU9522)
- *
- */
-
-#define DVB_USB_LOG_PREFIX "friio"
-#include "dvb-usb.h"
-
-extern int dvb_usb_friio_debug;
-#define deb_info(args...) dprintk(dvb_usb_friio_debug, 0x01, args)
-#define deb_xfer(args...) dprintk(dvb_usb_friio_debug, 0x02, args)
-#define deb_rc(args...)   dprintk(dvb_usb_friio_debug, 0x04, args)
-#define deb_fe(args...)   dprintk(dvb_usb_friio_debug, 0x08, args)
-
-/* Vendor requests */
-#define GL861_WRITE		0x40
-#define GL861_READ		0xc0
-
-/* command bytes */
-#define GL861_REQ_I2C_WRITE	0x01
-#define GL861_REQ_I2C_READ	0x02
-/* For control msg with data argument */
-/* Used for accessing the PLL on the secondary I2C bus of FE via GL861 */
-#define GL861_REQ_I2C_DATA_CTRL_WRITE	0x03
-
-#define GL861_ALTSETTING_COUNT	2
-#define FRIIO_BULK_ALTSETTING	0
-#define FRIIO_ISOC_ALTSETTING	1
-
-/* LED & LNB control via PIC. */
-/* basically, it's serial control with clock and strobe. */
-/* write the below 4bit control data to the reg 0x00 at the I2C addr 0x00 */
-/* when controlling the LEDs, 32bit(saturation, R, G, B) is sent on the bit3*/
-#define FRIIO_CTL_LNB (1 << 0)
-#define FRIIO_CTL_STROBE (1 << 1)
-#define FRIIO_CTL_CLK (1 << 2)
-#define FRIIO_CTL_LED (1 << 3)
-
-/* Front End related */
-
-#define FRIIO_DEMOD_ADDR  (0x30 >> 1)
-#define FRIIO_PLL_ADDR  (0xC0 >> 1)
-
-#define JDVBT90502_PLL_CLK	4000000
-#define JDVBT90502_PLL_DIVIDER	28
-
-#define JDVBT90502_2ND_I2C_REG 0xFE
-
-/* byte index for pll i2c command data structure*/
-/* see datasheet for tua6034 */
-#define DEMOD_REDIRECT_REG 0
-#define ADDRESS_BYTE       1
-#define DIVIDER_BYTE1      2
-#define DIVIDER_BYTE2      3
-#define CONTROL_BYTE       4
-#define BANDSWITCH_BYTE    5
-#define AGC_CTRL_BYTE      5
-#define PLL_CMD_LEN        6
-
-/* bit masks for PLL STATUS response */
-#define PLL_STATUS_POR_MODE   0x80 /* 1: Power on Reset (test) Mode */
-#define PLL_STATUS_LOCKED     0x40 /* 1: locked */
-#define PLL_STATUS_AGC_ACTIVE 0x08 /* 1:active */
-#define PLL_STATUS_TESTMODE   0x07 /* digital output level (5 level) */
-  /* 0.15Vcc step   0x00: < 0.15Vcc, ..., 0x04: >= 0.6Vcc (<= 1Vcc) */
-
-
-struct jdvbt90502_config {
-	u8 demod_address; /* i2c addr for demodulator IC */
-	u8 pll_address;   /* PLL addr on the secondary i2c*/
-};
-extern struct jdvbt90502_config friio_fe_config;
-
-extern struct dvb_frontend *jdvbt90502_attach(struct dvb_usb_device *d);
-#endif
-- 
2.17.1
