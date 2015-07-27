Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:45838 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752212AbbG0LWq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Jul 2015 07:22:46 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 3/6] zd1301_demod: ZyDAS ZD1301 DVB-T demodulator driver
Date: Mon, 27 Jul 2015 14:22:07 +0300
Message-Id: <1437996130-23735-4-git-send-email-crope@iki.fi>
In-Reply-To: <1437996130-23735-1-git-send-email-crope@iki.fi>
References: <1437996130-23735-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

ZyDAS ZD1301 is chip having USB interface and DVB-T demodulator
integrated. This driver is for demodulator part.
Driver is very reduced, just basic demodulator functionality, no
statistics at all. It registers as a platform driver to driver core.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/Kconfig        |   7 +
 drivers/media/dvb-frontends/Makefile       |   1 +
 drivers/media/dvb-frontends/zd1301_demod.c | 535 +++++++++++++++++++++++++++++
 drivers/media/dvb-frontends/zd1301_demod.h |  55 +++
 4 files changed, 598 insertions(+)
 create mode 100644 drivers/media/dvb-frontends/zd1301_demod.c
 create mode 100644 drivers/media/dvb-frontends/zd1301_demod.h

diff --git a/drivers/media/dvb-frontends/Kconfig b/drivers/media/dvb-frontends/Kconfig
index 5ab90f3..7f5b606 100644
--- a/drivers/media/dvb-frontends/Kconfig
+++ b/drivers/media/dvb-frontends/Kconfig
@@ -487,6 +487,13 @@ config DVB_AS102_FE
 	depends on DVB_CORE
 	default DVB_AS102
 
+config DVB_ZD1301_DEMOD
+	tristate "ZyDAS ZD1301"
+	depends on DVB_CORE && I2C
+	default m if !MEDIA_SUBDRV_AUTOSELECT
+	help
+	  Say Y when you want to support this frontend.
+
 comment "DVB-C (cable) frontends"
 	depends on DVB_CORE
 
diff --git a/drivers/media/dvb-frontends/Makefile b/drivers/media/dvb-frontends/Makefile
index ebab1b8..94e556d 100644
--- a/drivers/media/dvb-frontends/Makefile
+++ b/drivers/media/dvb-frontends/Makefile
@@ -118,3 +118,4 @@ obj-$(CONFIG_DVB_M88RS2000) += m88rs2000.o
 obj-$(CONFIG_DVB_AF9033) += af9033.o
 obj-$(CONFIG_DVB_AS102_FE) += as102_fe.o
 obj-$(CONFIG_DVB_TC90522) += tc90522.o
+obj-$(CONFIG_DVB_ZD1301_DEMOD) += zd1301_demod.o
diff --git a/drivers/media/dvb-frontends/zd1301_demod.c b/drivers/media/dvb-frontends/zd1301_demod.c
new file mode 100644
index 0000000..8cd8999
--- /dev/null
+++ b/drivers/media/dvb-frontends/zd1301_demod.c
@@ -0,0 +1,535 @@
+/*
+ * ZyDAS ZD1301 driver (demodulator)
+ *
+ * Copyright (C) 2015 Antti Palosaari <crope@iki.fi>
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
+#include "zd1301_demod.h"
+
+static u8 zd1301_demod_gain = 0x38;
+module_param_named(gain, zd1301_demod_gain, byte, 0644);
+MODULE_PARM_DESC(gain, "gain (value: 0x00 - 0x70, default: 0x38)");
+
+struct zd1301_demod_dev {
+	struct platform_device *pdev;
+	struct dvb_frontend frontend;
+	struct i2c_adapter adapter;
+	u8 gain;
+};
+
+static int zd1301_demod_wreg(struct zd1301_demod_dev *dev, u16 reg, u8 val)
+{
+	struct platform_device *pdev = dev->pdev;
+	struct zd1301_demod_platform_data *pdata = pdev->dev.platform_data;
+
+	return pdata->reg_write(pdata->reg_priv, reg, val);
+}
+
+static int zd1301_demod_rreg(struct zd1301_demod_dev *dev, u16 reg, u8 *val)
+{
+	struct platform_device *pdev = dev->pdev;
+	struct zd1301_demod_platform_data *pdata = pdev->dev.platform_data;
+
+	return pdata->reg_read(pdata->reg_priv, reg, val);
+}
+
+static int zd1301_demod_set_frontend(struct dvb_frontend *fe)
+{
+	struct zd1301_demod_dev *dev = fe->demodulator_priv;
+	struct platform_device *pdev = dev->pdev;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+	int ret;
+	u8 r6a50_val;
+
+	dev_dbg(&pdev->dev, "frequency=%u bandwidth_hz=%u inversion=%u\n",
+		c->frequency, c->bandwidth_hz, c->inversion);
+
+	/* Program tuner */
+	if (fe->ops.tuner_ops.set_params) {
+		ret = fe->ops.tuner_ops.set_params(fe);
+		if (ret)
+			goto err;
+	}
+
+	switch (c->bandwidth_hz) {
+	case 6000000:
+		r6a50_val = 0x78;
+		break;
+	case 7000000:
+		r6a50_val = 0x68;
+		break;
+	case 8000000:
+		r6a50_val = 0x58;
+		break;
+	default:
+		ret = -EINVAL;
+		goto err;
+	}
+
+	ret = zd1301_demod_wreg(dev, 0x6a60, 0x11);
+	if (ret)
+		goto err;
+	ret = zd1301_demod_wreg(dev, 0x6a47, 0x46);
+	if (ret)
+		goto err;
+	ret = zd1301_demod_wreg(dev, 0x6a48, 0x46);
+	if (ret)
+		goto err;
+	ret = zd1301_demod_wreg(dev, 0x6a4a, 0x15);
+	if (ret)
+		goto err;
+	ret = zd1301_demod_wreg(dev, 0x6a4b, 0x63);
+	if (ret)
+		goto err;
+	ret = zd1301_demod_wreg(dev, 0x6a5b, 0x99);
+	if (ret)
+		goto err;
+	ret = zd1301_demod_wreg(dev, 0x6a3b, 0x10);
+	if (ret)
+		goto err;
+	ret = zd1301_demod_wreg(dev, 0x6806, 0x01);
+	if (ret)
+		goto err;
+	ret = zd1301_demod_wreg(dev, 0x6a41, 0x08);
+	if (ret)
+		goto err;
+	ret = zd1301_demod_wreg(dev, 0x6a42, 0x46);
+	if (ret)
+		goto err;
+	ret = zd1301_demod_wreg(dev, 0x6a44, 0x14);
+	if (ret)
+		goto err;
+	ret = zd1301_demod_wreg(dev, 0x6a45, 0x67);
+	if (ret)
+		goto err;
+	ret = zd1301_demod_wreg(dev, 0x6a38, 0x00);
+	if (ret)
+		goto err;
+	ret = zd1301_demod_wreg(dev, 0x6a4c, 0x52);
+	if (ret)
+		goto err;
+	ret = zd1301_demod_wreg(dev, 0x6a49, 0x2a);
+	if (ret)
+		goto err;
+	ret = zd1301_demod_wreg(dev, 0x6840, 0x2e);
+	if (ret)
+		goto err;
+	ret = zd1301_demod_wreg(dev, 0x6a50, r6a50_val);
+	if (ret)
+		goto err;
+	ret = zd1301_demod_wreg(dev, 0x6a38, 0x07);
+	if (ret)
+		goto err;
+
+	return 0;
+err:
+	dev_dbg(&pdev->dev, "failed=%d\n", ret);
+	return ret;
+}
+
+static int zd1301_demod_sleep(struct dvb_frontend *fe)
+{
+	struct zd1301_demod_dev *dev = fe->demodulator_priv;
+	struct platform_device *pdev = dev->pdev;
+	int ret;
+
+	dev_dbg(&pdev->dev, "\n");
+
+	ret = zd1301_demod_wreg(dev, 0x6a43, 0x70);
+	if (ret)
+		goto err;
+	ret = zd1301_demod_wreg(dev, 0x684e, 0x00);
+	if (ret)
+		goto err;
+	ret = zd1301_demod_wreg(dev, 0x6849, 0x00);
+	if (ret)
+		goto err;
+	ret = zd1301_demod_wreg(dev, 0x68e2, 0xd7);
+	if (ret)
+		goto err;
+	ret = zd1301_demod_wreg(dev, 0x68e0, 0x39);
+	if (ret)
+		goto err;
+	ret = zd1301_demod_wreg(dev, 0x6840, 0x21);
+	if (ret)
+		goto err;
+
+	return 0;
+err:
+	dev_dbg(&pdev->dev, "failed=%d\n", ret);
+	return ret;
+}
+
+static int zd1301_demod_init(struct dvb_frontend *fe)
+{
+	struct zd1301_demod_dev *dev = fe->demodulator_priv;
+	struct platform_device *pdev = dev->pdev;
+	int ret;
+
+	dev_dbg(&pdev->dev, "\n");
+
+	ret = zd1301_demod_wreg(dev, 0x6840, 0x26);
+	if (ret)
+		goto err;
+	ret = zd1301_demod_wreg(dev, 0x68e0, 0xff);
+	if (ret)
+		goto err;
+	ret = zd1301_demod_wreg(dev, 0x68e2, 0xd8);
+	if (ret)
+		goto err;
+	ret = zd1301_demod_wreg(dev, 0x6849, 0x4e);
+	if (ret)
+		goto err;
+	ret = zd1301_demod_wreg(dev, 0x684e, 0x01);
+	if (ret)
+		goto err;
+	ret = zd1301_demod_wreg(dev, 0x6a43, zd1301_demod_gain);
+	if (ret)
+		goto err;
+
+	return 0;
+err:
+	dev_dbg(&pdev->dev, "failed=%d\n", ret);
+	return ret;
+}
+
+static int zd1301_demod_get_tune_settings(struct dvb_frontend *fe,
+					  struct dvb_frontend_tune_settings *settings)
+{
+	struct zd1301_demod_dev *dev = fe->demodulator_priv;
+	struct platform_device *pdev = dev->pdev;
+
+	dev_dbg(&pdev->dev, "\n");
+
+	/* ~180ms seems to be enough */
+	settings->min_delay_ms = 400;
+
+	return 0;
+}
+
+static int zd1301_demod_read_status(struct dvb_frontend *fe,
+				    enum fe_status *status)
+{
+	struct zd1301_demod_dev *dev = fe->demodulator_priv;
+	struct platform_device *pdev = dev->pdev;
+	int ret;
+	u8 u8tmp;
+
+	ret = zd1301_demod_rreg(dev, 0x6a24, &u8tmp);
+	if (ret)
+		goto err;
+	if (u8tmp > 0x00 && u8tmp < 0x20)
+		*status = FE_HAS_SIGNAL | FE_HAS_CARRIER | FE_HAS_VITERBI |
+			  FE_HAS_SYNC | FE_HAS_LOCK;
+	else
+		*status = 0;
+
+	dev_dbg(&pdev->dev, "lock byte=%02x\n", u8tmp);
+
+	/*
+	 * Interesting registers here are:
+	 * 0x6a05: get some gain value
+	 * 0x6a06: get about same gain value than set to 0x6a43
+	 * 0x6a07: get some gain value
+	 * 0x6a43: set gain value by driver
+	 * 0x6a24: get demod lock bits (FSM stage?)
+	 *
+	 * Driver should implement some kind of algorithm to calculate suitable
+	 * value for register 0x6a43, based likely values from register 0x6a05
+	 * and 0x6a07. Looks like gain register 0x6a43 value could be from
+	 * range 0x00 - 0x70.
+	 */
+
+	if (dev->gain != zd1301_demod_gain) {
+		dev->gain = zd1301_demod_gain;
+
+		ret = zd1301_demod_wreg(dev, 0x6a43, dev->gain);
+		if (ret)
+			goto err;
+	}
+
+	return 0;
+err:
+	dev_dbg(&pdev->dev, "failed=%d\n", ret);
+	return ret;
+}
+
+static const struct dvb_frontend_ops zd1301_demod_ops = {
+	.delsys = {SYS_DVBT},
+	.info = {
+		.name = "ZyDAS ZD1301",
+		.caps = FE_CAN_FEC_1_2 |
+			FE_CAN_FEC_2_3 |
+			FE_CAN_FEC_3_4 |
+			FE_CAN_FEC_5_6 |
+			FE_CAN_FEC_7_8 |
+			FE_CAN_FEC_AUTO |
+			FE_CAN_QPSK |
+			FE_CAN_QAM_16 |
+			FE_CAN_QAM_64 |
+			FE_CAN_QAM_AUTO |
+			FE_CAN_TRANSMISSION_MODE_AUTO |
+			FE_CAN_GUARD_INTERVAL_AUTO |
+			FE_CAN_HIERARCHY_AUTO |
+			FE_CAN_MUTE_TS
+	},
+
+	.sleep = zd1301_demod_sleep,
+	.init = zd1301_demod_init,
+	.set_frontend = zd1301_demod_set_frontend,
+	.get_tune_settings = zd1301_demod_get_tune_settings,
+	.read_status = zd1301_demod_read_status,
+};
+
+struct dvb_frontend *zd1301_demod_get_dvb_frontend(struct platform_device *pdev)
+{
+	struct zd1301_demod_dev *dev = platform_get_drvdata(pdev);
+
+	dev_dbg(&pdev->dev, "\n");
+
+	return &dev->frontend;
+}
+EXPORT_SYMBOL(zd1301_demod_get_dvb_frontend);
+
+static int zd1301_demod_i2c_master_xfer(struct i2c_adapter *adapter,
+					struct i2c_msg msg[], int num)
+{
+	struct zd1301_demod_dev *dev = i2c_get_adapdata(adapter);
+	struct platform_device *pdev = dev->pdev;
+	int ret, i;
+	unsigned long timeout;
+	u8 u8tmp;
+
+#define I2C_XFER_TIMEOUT 5
+#define ZD1301_IS_I2C_XFER_WRITE_READ(_msg, _num) \
+	(_num == 2 && !(_msg[0].flags & I2C_M_RD) && (_msg[1].flags & I2C_M_RD))
+#define ZD1301_IS_I2C_XFER_WRITE(_msg, _num) \
+	(_num == 1 && !(_msg[0].flags & I2C_M_RD))
+#define ZD1301_IS_I2C_XFER_READ(_msg, _num) \
+	(_num == 1 && (_msg[0].flags & I2C_M_RD))
+
+	if (ZD1301_IS_I2C_XFER_WRITE_READ(msg, num)) {
+		dev_dbg(&pdev->dev, "write&read msg[0].len=%u msg[1].len=%u\n",
+			msg[0].len, msg[1].len);
+		if (msg[0].len > 1 || msg[1].len > 8) {
+			ret = -EOPNOTSUPP;
+			goto err;
+		}
+
+		ret = zd1301_demod_wreg(dev, 0x6811, 0x80);
+		if (ret)
+			goto err;
+		ret = zd1301_demod_wreg(dev, 0x6812, 0x05);
+		if (ret)
+			goto err;
+		ret = zd1301_demod_wreg(dev, 0x6813, msg[1].addr << 1);
+		if (ret)
+			goto err;
+		ret = zd1301_demod_wreg(dev, 0x6801, msg[0].buf[0]);
+		if (ret)
+			goto err;
+		ret = zd1301_demod_wreg(dev, 0x6802, 0x00);
+		if (ret)
+			goto err;
+		ret = zd1301_demod_wreg(dev, 0x6803, 0x06);
+		if (ret)
+			goto err;
+		ret = zd1301_demod_wreg(dev, 0x6805, 0x00);
+		if (ret)
+			goto err;
+		ret = zd1301_demod_wreg(dev, 0x6804, msg[1].len);
+		if (ret)
+			goto err;
+
+		/* Poll xfer ready */
+		timeout = jiffies + msecs_to_jiffies(I2C_XFER_TIMEOUT);
+		for (u8tmp = 1; !time_after(jiffies, timeout) && u8tmp;) {
+			usleep_range(500, 800);
+
+			ret = zd1301_demod_rreg(dev, 0x6804, &u8tmp);
+			if (ret)
+				goto err;
+		}
+
+		for (i = 0; i < msg[1].len; i++) {
+			ret = zd1301_demod_rreg(dev, 0x0600 + i, &msg[1].buf[i]);
+			if (ret)
+				goto err;
+		}
+	} else if (ZD1301_IS_I2C_XFER_WRITE(msg, num)) {
+		dev_dbg(&pdev->dev, "write msg[0].len=%u\n", msg[0].len);
+		if (msg[0].len > 1 + 8) {
+			ret = -EOPNOTSUPP;
+			goto err;
+		}
+
+		ret = zd1301_demod_wreg(dev, 0x6811, 0x80);
+		if (ret)
+			goto err;
+		ret = zd1301_demod_wreg(dev, 0x6812, 0x01);
+		if (ret)
+			goto err;
+		ret = zd1301_demod_wreg(dev, 0x6813, msg[0].addr << 1);
+		if (ret)
+			goto err;
+		ret = zd1301_demod_wreg(dev, 0x6800, msg[0].buf[0]);
+		if (ret)
+			goto err;
+		ret = zd1301_demod_wreg(dev, 0x6802, 0x00);
+		if (ret)
+			goto err;
+		ret = zd1301_demod_wreg(dev, 0x6803, 0x06);
+		if (ret)
+			goto err;
+
+		for (i = 0; i < msg[0].len - 1; i++) {
+			ret = zd1301_demod_wreg(dev, 0x0600 + i, msg[0].buf[1 + i]);
+			if (ret)
+				goto err;
+		}
+
+		ret = zd1301_demod_wreg(dev, 0x6805, 0x80);
+		if (ret)
+			goto err;
+		ret = zd1301_demod_wreg(dev, 0x6804, msg[0].len - 1);
+		if (ret)
+			goto err;
+
+		/* Poll xfer ready */
+		timeout = jiffies + msecs_to_jiffies(I2C_XFER_TIMEOUT);
+		for (u8tmp = 1; !time_after(jiffies, timeout) && u8tmp;) {
+			usleep_range(500, 800);
+
+			ret = zd1301_demod_rreg(dev, 0x6804, &u8tmp);
+			if (ret)
+				goto err;
+		}
+	} else {
+		dev_dbg(&pdev->dev, "unknown msg[0].len=%u\n", msg[0].len);
+		ret = -EOPNOTSUPP;
+		if (ret)
+			goto err;
+	}
+
+err:
+	return ret ? ret : num;
+}
+
+static u32 zd1301_demod_i2c_functionality(struct i2c_adapter *adapter)
+{
+	return I2C_FUNC_I2C;
+}
+
+static struct i2c_algorithm zd1301_demod_i2c_algorithm = {
+	.master_xfer   = zd1301_demod_i2c_master_xfer,
+	.functionality = zd1301_demod_i2c_functionality,
+};
+
+struct i2c_adapter *zd1301_demod_get_i2c_adapter(struct platform_device *pdev)
+{
+	struct zd1301_demod_dev *dev = platform_get_drvdata(pdev);
+
+	dev_dbg(&pdev->dev, "\n");
+
+	return &dev->adapter;
+}
+EXPORT_SYMBOL(zd1301_demod_get_i2c_adapter);
+
+/* Platform driver interface */
+static int zd1301_demod_probe(struct platform_device *pdev)
+{
+	struct zd1301_demod_dev *dev;
+	struct zd1301_demod_platform_data *pdata = pdev->dev.platform_data;
+	int ret;
+
+	dev_dbg(&pdev->dev, "\n");
+
+	if (!pdata) {
+		dev_err(&pdev->dev, "Cannot proceed without platform data\n");
+		ret = -EINVAL;
+		goto err;
+	}
+	if (!pdev->dev.parent->driver) {
+		dev_dbg(&pdev->dev, "No parent device\n");
+		ret = -EINVAL;
+		goto err;
+	}
+
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+	if (!dev) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	/* Setup the state */
+	dev->pdev = pdev;
+	dev->gain = zd1301_demod_gain;
+
+	/* Sleep */
+	ret = zd1301_demod_wreg(dev, 0x6840, 0x21);
+	if (ret)
+		goto err_kfree;
+	ret = zd1301_demod_wreg(dev, 0x6a38, 0x07);
+	if (ret)
+		goto err_kfree;
+
+	/* Create I2C adapter */
+	strlcpy(dev->adapter.name, "ZyDAS ZD1301 demod", sizeof(dev->adapter.name));
+	dev->adapter.algo = &zd1301_demod_i2c_algorithm;
+	dev->adapter.algo_data = NULL;
+	dev->adapter.dev.parent = pdev->dev.parent;
+	i2c_set_adapdata(&dev->adapter, dev);
+	ret = i2c_add_adapter(&dev->adapter);
+	if (ret) {
+		dev_info(&pdev->dev, "I2C adapter failed\n");
+		goto err_kfree;
+	}
+
+	/* Create dvb frontend */
+	memcpy(&dev->frontend.ops, &zd1301_demod_ops, sizeof(dev->frontend.ops));
+	dev->frontend.demodulator_priv = dev;
+	platform_set_drvdata(pdev, dev);
+	dev_info(&pdev->dev, "ZyDAS ZD1301 demod attached\n");
+
+	return 0;
+err_kfree:
+	kfree(dev);
+err:
+	dev_dbg(&pdev->dev, "failed=%d\n", ret);
+	return ret;
+}
+
+static int zd1301_demod_remove(struct platform_device *pdev)
+{
+	struct zd1301_demod_dev *dev = platform_get_drvdata(pdev);
+
+	dev_dbg(&pdev->dev, "\n");
+
+	i2c_del_adapter(&dev->adapter);
+	kfree(dev);
+	return 0;
+}
+
+static struct platform_driver zd1301_demod_driver = {
+	.driver = {
+		.name                = "zd1301_demod",
+		.suppress_bind_attrs = true,
+	},
+	.probe          = zd1301_demod_probe,
+	.remove         = zd1301_demod_remove,
+};
+module_platform_driver(zd1301_demod_driver);
+
+MODULE_AUTHOR("Antti Palosaari <crope@iki.fi>");
+MODULE_DESCRIPTION("ZyDAS ZD1301 demodulator driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/media/dvb-frontends/zd1301_demod.h b/drivers/media/dvb-frontends/zd1301_demod.h
new file mode 100644
index 0000000..78a3122
--- /dev/null
+++ b/drivers/media/dvb-frontends/zd1301_demod.h
@@ -0,0 +1,55 @@
+/*
+ * ZyDAS ZD1301 driver (demodulator)
+ *
+ * Copyright (C) 2015 Antti Palosaari <crope@iki.fi>
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
+#ifndef ZD1301_DEMOD_H
+#define ZD1301_DEMOD_H
+
+#include <linux/platform_device.h>
+#include <linux/dvb/frontend.h>
+#include "dvb_frontend.h"
+
+/**
+ * struct zd1301_demod_platform_data - Platform data for the zd1301_demod driver
+ * @reg_priv: First argument of reg_read and reg_write callbacks.
+ * @reg_read: Register read callback.
+ * @reg_write: Register write callback.
+ */
+
+struct zd1301_demod_platform_data {
+	void *reg_priv;
+	int (*reg_read)(void *, u16, u8 *);
+	int (*reg_write)(void *, u16, u8);
+};
+
+/**
+ * zd1301_demod_get_dvb_frontend() - Get pointer to DVB frontend
+ * @pdev: Pointer to platform device
+ *
+ * Return: Pointer to DVB frontend which given platform device owns.
+ */
+
+struct dvb_frontend *zd1301_demod_get_dvb_frontend(struct platform_device *);
+
+/**
+ * zd1301_demod_get_i2c_adapter() - Get pointer to I2C adapter
+ * @pdev: Pointer to platform device
+ *
+ * Return: Pointer to I2C adapter which given platform device owns.
+ */
+
+struct i2c_adapter *zd1301_demod_get_i2c_adapter(struct platform_device *);
+
+#endif /* ZD1301_DEMOD_H */
-- 
http://palosaari.fi/

