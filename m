Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.netup.ru ([77.72.80.15]:56635 "EHLO imap.netup.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755707AbbG1Owh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jul 2015 10:52:37 -0400
From: serjk@netup.ru
To: linux-media@vger.kernel.org
Cc: mchehab@osg.samsung.com, aospan1@gmail.com,
	Kozlov Sergey <serjk@netup.ru>
Subject: [PATCH v3 3/5] [media] lnbh25: LNBH25 SEC controller driver
Date: Tue, 28 Jul 2015 17:33:02 +0300
Message-Id: <731fe3fdbb4a356869e11ba60998ad943fa06a31.1438090209.git.serjk@netup.ru>
In-Reply-To: <cover.1438090209.git.serjk@netup.ru>
References: <cover.1438090209.git.serjk@netup.ru>
In-Reply-To: <cover.1438090209.git.serjk@netup.ru>
References: <cover.1438090209.git.serjk@netup.ru>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Kozlov Sergey <serjk@netup.ru>

Add DVB SEC frontend driver for STM LNBH25PQR chip.

Changes in version 3:
    - use print_hex_dump() insted of dynamic_hex_dump()
    - use IS_REACHABLE macro instead of IS_ENABLED

Signed-off-by: Kozlov Sergey <serjk@netup.ru>
---
 MAINTAINERS                          |    9 ++
 drivers/media/dvb-frontends/Kconfig  |    8 ++
 drivers/media/dvb-frontends/Makefile |    1 +
 drivers/media/dvb-frontends/lnbh25.c |  189 ++++++++++++++++++++++++++++++++++
 drivers/media/dvb-frontends/lnbh25.h |   56 ++++++++++
 5 files changed, 263 insertions(+)
 create mode 100644 drivers/media/dvb-frontends/lnbh25.c
 create mode 100644 drivers/media/dvb-frontends/lnbh25.h

diff --git a/MAINTAINERS b/MAINTAINERS
index bc82b91..156e3a3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6362,6 +6362,15 @@ T:	git git://linuxtv.org/media_tree.git
 S:	Supported
 F:	drivers/media/dvb-frontends/horus3a*
 
+MEDIA DRIVERS FOR LNBH25
+M:	Sergey Kozlov <serjk@netup.ru>
+L:	linux-media@vger.kernel.org
+W:	http://linuxtv.org/
+W:	http://netup.tv/
+T:	git git://linuxtv.org/media_tree.git
+S:	Supported
+F:	drivers/media/dvb-frontends/lnbh25*
+
 MEDIA INPUT INFRASTRUCTURE (V4L/DVB)
 M:	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
 P:	LinuxTV.org Project
diff --git a/drivers/media/dvb-frontends/Kconfig b/drivers/media/dvb-frontends/Kconfig
index 3bdc357..90fcabf 100644
--- a/drivers/media/dvb-frontends/Kconfig
+++ b/drivers/media/dvb-frontends/Kconfig
@@ -703,6 +703,14 @@ comment "SEC control devices for DVB-S"
 
 source "drivers/media/dvb-frontends/drx39xyj/Kconfig"
 
+config DVB_LNBH25
+	tristate "LNBH25 SEC controller"
+	depends on DVB_CORE && I2C
+	default m if !MEDIA_SUBDRV_AUTOSELECT
+	help
+	  An SEC control chip.
+	  Say Y when you want to support this chip.
+
 config DVB_LNBP21
 	tristate "LNBP21/LNBH24 SEC controllers"
 	depends on DVB_CORE && I2C
diff --git a/drivers/media/dvb-frontends/Makefile b/drivers/media/dvb-frontends/Makefile
index 74b729e..74055f9 100644
--- a/drivers/media/dvb-frontends/Makefile
+++ b/drivers/media/dvb-frontends/Makefile
@@ -57,6 +57,7 @@ obj-$(CONFIG_DVB_LGDT3305) += lgdt3305.o
 obj-$(CONFIG_DVB_LGDT3306A) += lgdt3306a.o
 obj-$(CONFIG_DVB_LG2160) += lg2160.o
 obj-$(CONFIG_DVB_CX24123) += cx24123.o
+obj-$(CONFIG_DVB_LNBH25) += lnbh25.o
 obj-$(CONFIG_DVB_LNBP21) += lnbp21.o
 obj-$(CONFIG_DVB_LNBP22) += lnbp22.o
 obj-$(CONFIG_DVB_ISL6405) += isl6405.o
diff --git a/drivers/media/dvb-frontends/lnbh25.c b/drivers/media/dvb-frontends/lnbh25.c
new file mode 100644
index 0000000..8fb934b
--- /dev/null
+++ b/drivers/media/dvb-frontends/lnbh25.c
@@ -0,0 +1,189 @@
+/*
+ * lnbh25.c
+ *
+ * Driver for LNB supply and control IC LNBH25
+ *
+ * Copyright (C) 2014 NetUP Inc.
+ * Copyright (C) 2014 Sergey Kozlov <serjk@netup.ru>
+ * Copyright (C) 2014 Abylay Ospan <aospan@netup.ru>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/string.h>
+#include <linux/slab.h>
+
+#include "dvb_frontend.h"
+#include "lnbh25.h"
+
+/**
+ * struct lnbh25_priv - LNBH25 driver private data
+ * @i2c:		pointer to the I2C adapter structure
+ * @i2c_address:	I2C address of LNBH25 SEC chip
+ * @config:		Registers configuration:
+ *			offset 0: 1st register address, always 0x02 (DATA1)
+ *			offset 1: DATA1 register value
+ *			offset 2: DATA2 register value
+ */
+struct lnbh25_priv {
+	struct i2c_adapter	*i2c;
+	u8			i2c_address;
+	u8			config[3];
+};
+
+#define LNBH25_STATUS_OFL	0x1
+#define LNBH25_STATUS_VMON	0x4
+#define LNBH25_VSEL_13		0x03
+#define LNBH25_VSEL_18		0x0a
+
+static int lnbh25_read_vmon(struct lnbh25_priv *priv)
+{
+	int i, ret;
+	u8 addr = 0x00;
+	u8 status[6];
+	struct i2c_msg msg[2] = {
+		{
+			.addr = priv->i2c_address,
+			.flags = 0,
+			.len = 1,
+			.buf = &addr
+		}, {
+			.addr = priv->i2c_address,
+			.flags = I2C_M_RD,
+			.len = sizeof(status),
+			.buf = status
+		}
+	};
+
+	for (i = 0; i < 2; i++) {
+		ret = i2c_transfer(priv->i2c, &msg[i], 1);
+		if (ret >= 0 && ret != 1)
+			ret = -EIO;
+		if (ret < 0) {
+			dev_dbg(&priv->i2c->dev,
+				"%s(): I2C transfer %d failed (%d)\n",
+				__func__, i, ret);
+			return ret;
+		}
+	}
+	print_hex_dump_bytes("lnbh25_read_vmon: ",
+		DUMP_PREFIX_OFFSET, status, sizeof(status));
+	if ((status[0] & (LNBH25_STATUS_OFL | LNBH25_STATUS_VMON)) != 0) {
+		dev_err(&priv->i2c->dev,
+			"%s(): voltage in failure state, status reg 0x%x\n",
+			__func__, status[0]);
+		return -EIO;
+	}
+	return 0;
+}
+
+static int lnbh25_set_voltage(struct dvb_frontend *fe,
+			      fe_sec_voltage_t voltage)
+{
+	int ret;
+	u8 data1_reg;
+	const char *vsel;
+	struct lnbh25_priv *priv = fe->sec_priv;
+	struct i2c_msg msg = {
+		.addr = priv->i2c_address,
+		.flags = 0,
+		.len = sizeof(priv->config),
+		.buf = priv->config
+	};
+
+	switch (voltage) {
+	case SEC_VOLTAGE_OFF:
+		data1_reg = 0x00;
+		vsel = "Off";
+		break;
+	case SEC_VOLTAGE_13:
+		data1_reg = LNBH25_VSEL_13;
+		vsel = "13V";
+		break;
+	case SEC_VOLTAGE_18:
+		data1_reg = LNBH25_VSEL_18;
+		vsel = "18V";
+		break;
+	default:
+		return -EINVAL;
+	}
+	priv->config[1] = data1_reg;
+	dev_dbg(&priv->i2c->dev,
+		"%s(): %s, I2C 0x%x write [ %02x %02x %02x ]\n",
+		__func__, vsel, priv->i2c_address,
+		priv->config[0], priv->config[1], priv->config[2]);
+	ret = i2c_transfer(priv->i2c, &msg, 1);
+	if (ret >= 0 && ret != 1)
+		ret = -EIO;
+	if (ret < 0) {
+		dev_err(&priv->i2c->dev, "%s(): I2C transfer error (%d)\n",
+			__func__, ret);
+		return ret;
+	}
+	if (voltage != SEC_VOLTAGE_OFF) {
+		msleep(120);
+		ret = lnbh25_read_vmon(priv);
+	} else {
+		msleep(20);
+		ret = 0;
+	}
+	return ret;
+}
+
+static void lnbh25_release(struct dvb_frontend *fe)
+{
+	struct lnbh25_priv *priv = fe->sec_priv;
+
+	dev_dbg(&priv->i2c->dev, "%s()\n", __func__);
+	lnbh25_set_voltage(fe, SEC_VOLTAGE_OFF);
+	kfree(fe->sec_priv);
+	fe->sec_priv = NULL;
+}
+
+struct dvb_frontend *lnbh25_attach(struct dvb_frontend *fe,
+				   struct lnbh25_config *cfg,
+				   struct i2c_adapter *i2c)
+{
+	struct lnbh25_priv *priv;
+
+	dev_dbg(&i2c->dev, "%s()\n", __func__);
+	priv = kzalloc(sizeof(struct lnbh25_priv), GFP_KERNEL);
+	if (!priv)
+		return NULL;
+	priv->i2c_address = (cfg->i2c_address >> 1);
+	priv->i2c = i2c;
+	priv->config[0] = 0x02;
+	priv->config[1] = 0x00;
+	priv->config[2] = cfg->data2_config;
+	fe->sec_priv = priv;
+	if (lnbh25_set_voltage(fe, SEC_VOLTAGE_OFF)) {
+		dev_err(&i2c->dev,
+			"%s(): no LNBH25 found at I2C addr 0x%02x\n",
+			__func__, priv->i2c_address);
+		kfree(priv);
+		fe->sec_priv = NULL;
+		return NULL;
+	}
+
+	fe->ops.release_sec = lnbh25_release;
+	fe->ops.set_voltage = lnbh25_set_voltage;
+
+	dev_err(&i2c->dev, "%s(): attached at I2C addr 0x%02x\n",
+		__func__, priv->i2c_address);
+	return fe;
+}
+EXPORT_SYMBOL(lnbh25_attach);
+
+MODULE_DESCRIPTION("ST LNBH25 driver");
+MODULE_AUTHOR("info@netup.ru");
+MODULE_LICENSE("GPL");
diff --git a/drivers/media/dvb-frontends/lnbh25.h b/drivers/media/dvb-frontends/lnbh25.h
new file mode 100644
index 0000000..69f30e2
--- /dev/null
+++ b/drivers/media/dvb-frontends/lnbh25.h
@@ -0,0 +1,56 @@
+/*
+ * lnbh25.c
+ *
+ * Driver for LNB supply and control IC LNBH25
+ *
+ * Copyright (C) 2014 NetUP Inc.
+ * Copyright (C) 2014 Sergey Kozlov <serjk@netup.ru>
+ * Copyright (C) 2014 Abylay Ospan <aospan@netup.ru>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef LNBH25_H
+#define LNBH25_H
+
+#include <linux/i2c.h>
+#include <linux/kconfig.h>
+#include <linux/dvb/frontend.h>
+
+/* 22 kHz tone enabled. Tone output controlled by DSQIN pin */
+#define	LNBH25_TEN	0x01
+/* Low power mode activated (used only with 22 kHz tone output disabled) */
+#define LNBH25_LPM	0x02
+/* DSQIN input pin is set to receive external 22 kHz TTL signal source */
+#define LNBH25_EXTM	0x04
+
+struct lnbh25_config {
+	u8	i2c_address;
+	u8	data2_config;
+};
+
+#if IS_REACHABLE(CONFIG_DVB_LNBH25)
+struct dvb_frontend *lnbh25_attach(
+	struct dvb_frontend *fe,
+	struct lnbh25_config *cfg,
+	struct i2c_adapter *i2c);
+#else
+static inline dvb_frontend *lnbh25_attach(
+	struct dvb_frontend *fe,
+	struct lnbh25_config *cfg,
+	struct i2c_adapter *i2c)
+{
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
+	return NULL;
+}
+#endif
+
+#endif
-- 
1.7.10.4

