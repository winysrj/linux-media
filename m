Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:33570 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933982AbaKLETl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Nov 2014 23:19:41 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 1/9] mn88473: Panasonic MN88473 DVB-T/T2/C demod driver
Date: Wed, 12 Nov 2014 06:19:23 +0200
Message-Id: <1415765971-24378-2-git-send-email-crope@iki.fi>
In-Reply-To: <1415765971-24378-1-git-send-email-crope@iki.fi>
References: <1415765971-24378-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Only DVB-C is implemented.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/Kconfig        |   7 +
 drivers/media/dvb-frontends/Makefile       |   1 +
 drivers/media/dvb-frontends/mn88473.c      | 393 +++++++++++++++++++++++++++++
 drivers/media/dvb-frontends/mn88473.h      |  46 ++++
 drivers/media/dvb-frontends/mn88473_priv.h |  34 +++
 5 files changed, 481 insertions(+)
 create mode 100644 drivers/media/dvb-frontends/mn88473.c
 create mode 100644 drivers/media/dvb-frontends/mn88473.h
 create mode 100644 drivers/media/dvb-frontends/mn88473_priv.h

diff --git a/drivers/media/dvb-frontends/Kconfig b/drivers/media/dvb-frontends/Kconfig
index 6c75418..2720b8f 100644
--- a/drivers/media/dvb-frontends/Kconfig
+++ b/drivers/media/dvb-frontends/Kconfig
@@ -471,6 +471,13 @@ config DVB_SI2168
 	help
 	  Say Y when you want to support this frontend.
 
+config DVB_MN88473
+	tristate "Panasonic MN88473"
+	depends on DVB_CORE && I2C
+	default m if !MEDIA_SUBDRV_AUTOSELECT
+	help
+	  Say Y when you want to support this frontend.
+
 config DVB_AS102_FE
 	tristate
 	depends on DVB_CORE
diff --git a/drivers/media/dvb-frontends/Makefile b/drivers/media/dvb-frontends/Makefile
index ba59df6..8be6eb0 100644
--- a/drivers/media/dvb-frontends/Makefile
+++ b/drivers/media/dvb-frontends/Makefile
@@ -113,6 +113,7 @@ obj-$(CONFIG_DVB_RTL2830) += rtl2830.o
 obj-$(CONFIG_DVB_RTL2832) += rtl2832.o
 obj-$(CONFIG_DVB_RTL2832_SDR) += rtl2832_sdr.o
 obj-$(CONFIG_DVB_M88RS2000) += m88rs2000.o
+obj-$(CONFIG_DVB_MN88473) += mn88473.o
 obj-$(CONFIG_DVB_AF9033) += af9033.o
 obj-$(CONFIG_DVB_AS102_FE) += as102_fe.o
 obj-$(CONFIG_DVB_TC90522) += tc90522.o
diff --git a/drivers/media/dvb-frontends/mn88473.c b/drivers/media/dvb-frontends/mn88473.c
new file mode 100644
index 0000000..afe59f3
--- /dev/null
+++ b/drivers/media/dvb-frontends/mn88473.c
@@ -0,0 +1,393 @@
+/*
+ * Panasonic MN88473 DVB-T/T2/C demodulator driver
+ *
+ * Copyright (C) 2014 Antti Palosaari <crope@iki.fi>
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
+ */
+
+#include "mn88473_priv.h"
+
+static struct dvb_frontend_ops mn88473_ops;
+
+/* write multiple registers */
+static int mn88473_wregs(struct mn88473_dev *dev, u16 reg, const u8 *val, int len)
+{
+#define MAX_WR_LEN 21
+#define MAX_WR_XFER_LEN (MAX_WR_LEN + 1)
+	int ret;
+	u8 buf[MAX_WR_XFER_LEN];
+	struct i2c_msg msg[1] = {
+		{
+			.addr = (reg >> 8) & 0xff,
+			.flags = 0,
+			.len = 1 + len,
+			.buf = buf,
+		}
+	};
+
+	if (WARN_ON(len > MAX_WR_LEN))
+		return -EINVAL;
+
+	buf[0] = (reg >> 0) & 0xff;
+	memcpy(&buf[1], val, len);
+
+	ret = i2c_transfer(dev->i2c, msg, 1);
+	if (ret == 1) {
+		ret = 0;
+	} else {
+		dev_warn(&dev->i2c->dev,
+				"%s: i2c wr failed=%d reg=%02x len=%d\n",
+				KBUILD_MODNAME, ret, reg, len);
+		ret = -EREMOTEIO;
+	}
+
+	return ret;
+}
+
+/* read multiple registers */
+static int mn88473_rregs(struct mn88473_dev *dev, u16 reg, u8 *val, int len)
+{
+#define MAX_RD_LEN 2
+#define MAX_RD_XFER_LEN (MAX_RD_LEN)
+	int ret;
+	u8 buf[MAX_RD_XFER_LEN];
+	struct i2c_msg msg[2] = {
+		{
+			.addr = (reg >> 8) & 0xff,
+			.flags = 0,
+			.len = 1,
+			.buf = buf,
+		}, {
+			.addr = (reg >> 8) & 0xff,
+			.flags = I2C_M_RD,
+			.len = len,
+			.buf = buf,
+		}
+	};
+
+	if (WARN_ON(len > MAX_RD_LEN))
+		return -EINVAL;
+
+	buf[0] = (reg >> 0) & 0xff;
+
+	ret = i2c_transfer(dev->i2c, msg, 2);
+	if (ret == 2) {
+		memcpy(val, buf, len);
+		ret = 0;
+	} else {
+		dev_warn(&dev->i2c->dev,
+				"%s: i2c rd failed=%d reg=%02x len=%d\n",
+				KBUILD_MODNAME, ret, reg, len);
+		ret = -EREMOTEIO;
+	}
+
+	return ret;
+}
+
+/* write single register */
+static int mn88473_wreg(struct mn88473_dev *dev, u16 reg, u8 val)
+{
+	return mn88473_wregs(dev, reg, &val, 1);
+}
+
+/* read single register */
+static int mn88473_rreg(struct mn88473_dev *dev, u16 reg, u8 *val)
+{
+	return mn88473_rregs(dev, reg, val, 1);
+}
+
+static int mn88473_get_tune_settings(struct dvb_frontend *fe,
+	struct dvb_frontend_tune_settings *s)
+{
+	s->min_delay_ms = 1000;
+	return 0;
+}
+
+static int mn88473_set_frontend(struct dvb_frontend *fe)
+{
+	struct mn88473_dev *dev = fe->demodulator_priv;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+	int ret;
+	u32 if_frequency = 0;
+
+	dev_dbg(&dev->i2c->dev,
+			"%s: delivery_system=%d modulation=%d frequency=%d symbol_rate=%d inversion=%d\n",
+			__func__, c->delivery_system, c->modulation,
+			c->frequency, c->symbol_rate, c->inversion);
+
+	if (!dev->warm) {
+		ret = -EAGAIN;
+		goto err;
+	}
+
+	/* program tuner */
+	if (fe->ops.tuner_ops.set_params) {
+		ret = fe->ops.tuner_ops.set_params(fe);
+		if (ret)
+			goto err;
+	}
+
+	if (fe->ops.tuner_ops.get_if_frequency) {
+		ret = fe->ops.tuner_ops.get_if_frequency(fe, &if_frequency);
+		if (ret)
+			goto err;
+
+		dev_dbg(&dev->i2c->dev, "%s: get_if_frequency=%d\n",
+				__func__, if_frequency);
+	}
+
+	if (if_frequency != 5070000) {
+		dev_err(&dev->i2c->dev, "%s: IF frequency %d not supported\n",
+				KBUILD_MODNAME, if_frequency);
+		ret = -EINVAL;
+		goto err;
+	}
+
+	ret = mn88473_wregs(dev, 0x1c05, "\x00", 1);
+	ret = mn88473_wregs(dev, 0x1cfb, "\x13", 1);
+	ret = mn88473_wregs(dev, 0x1cef, "\x13", 1);
+	ret = mn88473_wregs(dev, 0x1cf9, "\x13", 1);
+	ret = mn88473_wregs(dev, 0x1c00, "\x18", 1);
+	ret = mn88473_wregs(dev, 0x1c01, "\x01", 1);
+	ret = mn88473_wregs(dev, 0x1c02, "\x21", 1);
+	ret = mn88473_wregs(dev, 0x1c03, "\x04", 1);
+	ret = mn88473_wregs(dev, 0x1c0b, "\x00", 1);
+	ret = mn88473_wregs(dev, 0x1c10, "\x33\xea\xb3\xaf\x00\x00\x11\xec\x11\xec", 10);
+	ret = mn88473_wregs(dev, 0x1c2d, "\x3b", 1);
+	ret = mn88473_wregs(dev, 0x1c2e, "\x00", 1);
+	ret = mn88473_wregs(dev, 0x1c56, "\x0d", 1);
+	ret = mn88473_wregs(dev, 0x1802, "\x13", 1);
+	ret = mn88473_wregs(dev, 0x1803, "\x80", 1);
+	ret = mn88473_wregs(dev, 0x1804, "\xba", 1);
+	ret = mn88473_wregs(dev, 0x1805, "\x91", 1);
+	ret = mn88473_wregs(dev, 0x1808, "\x28", 1);
+	ret = mn88473_wregs(dev, 0x180a, "\x1a", 1);
+	ret = mn88473_wregs(dev, 0x1813, "\x1f", 1);
+	ret = mn88473_wregs(dev, 0x1819, "\x03", 1);
+	ret = mn88473_wregs(dev, 0x181d, "\xb0", 1);
+	ret = mn88473_wregs(dev, 0x182a, "\x72", 1);
+	ret = mn88473_wregs(dev, 0x182d, "\x00", 1);
+	ret = mn88473_wregs(dev, 0x183c, "\x00", 1);
+	ret = mn88473_wregs(dev, 0x183f, "\xf8", 1);
+	ret = mn88473_wregs(dev, 0x1840, "\xf4", 1);
+	ret = mn88473_wregs(dev, 0x1841, "\x08", 1);
+	ret = mn88473_wregs(dev, 0x18d2, "\x29", 1);
+	ret = mn88473_wregs(dev, 0x18d4, "\x55", 1);
+	ret = mn88473_wregs(dev, 0x1a10, "\x10", 1);
+	ret = mn88473_wregs(dev, 0x1a11, "\xab", 1);
+	ret = mn88473_wregs(dev, 0x1a12, "\x0d", 1);
+	ret = mn88473_wregs(dev, 0x1a13, "\xae", 1);
+	ret = mn88473_wregs(dev, 0x1a14, "\x1d", 1);
+	ret = mn88473_wregs(dev, 0x1a15, "\x9d", 1);
+	ret = mn88473_wregs(dev, 0x1abe, "\x08", 1);
+	ret = mn88473_wregs(dev, 0x1c09, "\x08", 1);
+	ret = mn88473_wregs(dev, 0x1c08, "\x1d", 1);
+	ret = mn88473_wregs(dev, 0x18b2, "\x37", 1);
+	ret = mn88473_wregs(dev, 0x18d7, "\x04", 1);
+	ret = mn88473_wregs(dev, 0x1cf8, "\x9f", 1);
+	if (ret)
+		goto err;
+
+	dev->delivery_system = c->delivery_system;
+
+	return 0;
+err:
+	dev_dbg(&dev->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	return ret;
+}
+
+static int mn88473_read_status(struct dvb_frontend *fe, fe_status_t *status)
+{
+	struct mn88473_dev *dev = fe->demodulator_priv;
+	int ret;
+
+	*status = 0;
+
+	if (!dev->warm) {
+		ret = -EAGAIN;
+		goto err;
+	}
+
+	*status = FE_HAS_SIGNAL | FE_HAS_CARRIER | FE_HAS_VITERBI |
+			FE_HAS_SYNC | FE_HAS_LOCK;
+
+	return 0;
+err:
+	dev_dbg(&dev->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	return ret;
+}
+
+static int mn88473_init(struct dvb_frontend *fe)
+{
+	struct mn88473_dev *dev = fe->demodulator_priv;
+	int ret, len, remaining;
+	const struct firmware *fw = NULL;
+	u8 *fw_file = MN88473_FIRMWARE;
+
+	dev_dbg(&dev->i2c->dev, "%s:\n", __func__);
+
+	if (dev->warm)
+		return 0;
+
+	/* request the firmware, this will block and timeout */
+	ret = request_firmware(&fw, fw_file, dev->i2c->dev.parent);
+	if (ret) {
+		dev_err(&dev->i2c->dev, "%s: firmare file '%s' not found\n",
+				KBUILD_MODNAME, fw_file);
+		goto err;
+	}
+
+	dev_info(&dev->i2c->dev, "%s: downloading firmware from file '%s'\n",
+			KBUILD_MODNAME, fw_file);
+
+	ret = mn88473_wreg(dev, 0x18f5, 0x03);
+	if (ret)
+		goto err;
+
+	for (remaining = fw->size; remaining > 0;
+			remaining -= (dev->cfg->i2c_wr_max - 1)) {
+		len = remaining;
+		if (len > (dev->cfg->i2c_wr_max - 1))
+			len = (dev->cfg->i2c_wr_max - 1);
+
+		ret = mn88473_wregs(dev, 0x18f6,
+				&fw->data[fw->size - remaining], len);
+		if (ret) {
+			dev_err(&dev->i2c->dev,
+					"%s: firmware download failed=%d\n",
+					KBUILD_MODNAME, ret);
+			goto err;
+		}
+	}
+
+	ret = mn88473_wreg(dev, 0x18f5, 0x00);
+	if (ret)
+		goto err;
+
+	release_firmware(fw);
+	fw = NULL;
+
+	/* warm state */
+	dev->warm = true;
+
+	return 0;
+err:
+	if (fw)
+		release_firmware(fw);
+
+	dev_dbg(&dev->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	return ret;
+}
+
+static int mn88473_sleep(struct dvb_frontend *fe)
+{
+	struct mn88473_dev *dev = fe->demodulator_priv;
+	int ret;
+
+	dev_dbg(&dev->i2c->dev, "%s:\n", __func__);
+
+	ret = mn88473_wreg(dev, 0x1c05, 0x3e);
+	if (ret)
+		goto err;
+
+	dev->delivery_system = SYS_UNDEFINED;
+
+	return 0;
+err:
+	dev_dbg(&dev->i2c->dev, "%s: failed=%d\n", __func__, ret);
+	return ret;
+}
+
+static void mn88473_release(struct dvb_frontend *fe)
+{
+	struct mn88473_dev *dev = fe->demodulator_priv;
+	kfree(dev);
+}
+
+struct dvb_frontend *mn88473_attach(const struct mn88473_config *cfg,
+		struct i2c_adapter *i2c)
+{
+	int ret;
+	struct mn88473_dev *dev;
+	u8 u8tmp;
+
+	dev_dbg(&i2c->dev, "%s:\n", __func__);
+
+	/* allocate memory for the internal state */
+	dev = kzalloc(sizeof(struct mn88473_dev), GFP_KERNEL);
+	if (!dev) {
+		ret = -ENOMEM;
+		dev_err(&i2c->dev, "%s: kzalloc() failed\n", KBUILD_MODNAME);
+		goto err;
+	}
+
+	dev->cfg = cfg;
+	dev->i2c = i2c;
+
+	/* check demod responds to I2C */
+	ret = mn88473_rreg(dev, 0x1c00, &u8tmp);
+	if (ret)
+		goto err;
+
+	/* create dvb_frontend */
+	memcpy(&dev->fe.ops, &mn88473_ops, sizeof(struct dvb_frontend_ops));
+	dev->fe.demodulator_priv = dev;
+
+	return &dev->fe;
+err:
+	dev_dbg(&i2c->dev, "%s: failed=%d\n", __func__, ret);
+	kfree(dev);
+	return NULL;
+}
+EXPORT_SYMBOL(mn88473_attach);
+
+static struct dvb_frontend_ops mn88473_ops = {
+	.delsys = {SYS_DVBC_ANNEX_AC},
+	.info = {
+		.name = "Panasonic MN88473",
+		.caps =	FE_CAN_FEC_1_2			|
+			FE_CAN_FEC_2_3			|
+			FE_CAN_FEC_3_4			|
+			FE_CAN_FEC_5_6			|
+			FE_CAN_FEC_7_8			|
+			FE_CAN_FEC_AUTO			|
+			FE_CAN_QPSK			|
+			FE_CAN_QAM_16			|
+			FE_CAN_QAM_32			|
+			FE_CAN_QAM_64			|
+			FE_CAN_QAM_128			|
+			FE_CAN_QAM_256			|
+			FE_CAN_QAM_AUTO			|
+			FE_CAN_TRANSMISSION_MODE_AUTO	|
+			FE_CAN_GUARD_INTERVAL_AUTO	|
+			FE_CAN_HIERARCHY_AUTO		|
+			FE_CAN_MUTE_TS			|
+			FE_CAN_2G_MODULATION		|
+			FE_CAN_MULTISTREAM
+	},
+
+	.release = mn88473_release,
+
+	.get_tune_settings = mn88473_get_tune_settings,
+
+	.init = mn88473_init,
+	.sleep = mn88473_sleep,
+
+	.set_frontend = mn88473_set_frontend,
+
+	.read_status = mn88473_read_status,
+};
+
+MODULE_AUTHOR("Antti Palosaari <crope@iki.fi>");
+MODULE_DESCRIPTION("Panasonic MN88473 DVB-T/T2/C demodulator driver");
+MODULE_LICENSE("GPL");
+MODULE_FIRMWARE(MN88473_FIRMWARE);
diff --git a/drivers/media/dvb-frontends/mn88473.h b/drivers/media/dvb-frontends/mn88473.h
new file mode 100644
index 0000000..13b51b6
--- /dev/null
+++ b/drivers/media/dvb-frontends/mn88473.h
@@ -0,0 +1,46 @@
+/*
+ * Panasonic MN88473 DVB-T/T2/C demodulator driver
+ *
+ * Copyright (C) 2014 Antti Palosaari <crope@iki.fi>
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
+ */
+
+#ifndef MN88473_H
+#define MN88473_H
+
+#include <linux/dvb/frontend.h>
+
+struct mn88473_config {
+	/*
+	 * max bytes I2C client could write
+	 * Value must be set.
+	 */
+	int i2c_wr_max;
+};
+
+#if IS_ENABLED(CONFIG_DVB_MN88473)
+extern struct dvb_frontend *mn88473_attach(
+	const struct mn88473_config *cfg,
+	struct i2c_adapter *i2c
+);
+#else
+static inline struct dvb_frontend *mn88473_attach(
+	const struct mn88473_config *cfg,
+	struct i2c_adapter *i2c
+)
+{
+	dev_warn(&i2c->dev, "%s: driver disabled by Kconfig\n", __func__);
+	return NULL;
+}
+#endif
+
+#endif
diff --git a/drivers/media/dvb-frontends/mn88473_priv.h b/drivers/media/dvb-frontends/mn88473_priv.h
new file mode 100644
index 0000000..c40b3a5
--- /dev/null
+++ b/drivers/media/dvb-frontends/mn88473_priv.h
@@ -0,0 +1,34 @@
+/*
+ * Panasonic MN88473 DVB-T/T2/C demodulator driver
+ *
+ * Copyright (C) 2014 Antti Palosaari <crope@iki.fi>
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
+ */
+
+#ifndef MN88473_PRIV_H
+#define MN88473_PRIV_H
+
+#include "dvb_frontend.h"
+#include "mn88473.h"
+#include <linux/firmware.h>
+
+#define MN88473_FIRMWARE "dvb-demod-mn88473-01.fw"
+
+struct mn88473_dev {
+	struct i2c_adapter *i2c;
+	const struct mn88473_config *cfg;
+	struct dvb_frontend fe;
+	fe_delivery_system_t delivery_system;
+	bool warm; /* FW running */
+};
+
+#endif
-- 
http://palosaari.fi/

