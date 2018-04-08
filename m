Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f66.google.com ([209.85.160.66]:45654 "EHLO
        mail-pl0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752668AbeDHRk2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 8 Apr 2018 13:40:28 -0400
Received: by mail-pl0-f66.google.com with SMTP id e22-v6so1964048plj.12
        for <linux-media@vger.kernel.org>; Sun, 08 Apr 2018 10:40:27 -0700 (PDT)
From: tskd08@gmail.com
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, Akihiro Tsukada <tskd08@gmail.com>,
        hiranotaka@zng.info
Subject: [PATCH v3 3/5] dvb: earth-pt1: decompose pt1 driver into sub drivers
Date: Mon,  9 Apr 2018 02:39:51 +0900
Message-Id: <20180408173953.11076-4-tskd08@gmail.com>
In-Reply-To: <20180408173953.11076-1-tskd08@gmail.com>
References: <20180408173953.11076-1-tskd08@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Akihiro Tsukada <tskd08@gmail.com>

earth-pt1 was a monolithic module and included demod/tuner drivers.
This patch removes those FE parts and  attach demod/tuner i2c drivers.

Signed-off-by: Akihiro Tsukada <tskd08@gmail.com>
---
Changes since v2:
- specify tuner chip name literally

Changes since v1:
- use i2c_board_info.name to specify pll_desc id.

 drivers/media/pci/pt1/Kconfig        |   3 +
 drivers/media/pci/pt1/Makefile       |   3 +-
 drivers/media/pci/pt1/pt1.c          | 329 ++++++++----
 drivers/media/pci/pt1/va1j5jf8007s.c | 732 ---------------------------
 drivers/media/pci/pt1/va1j5jf8007s.h |  42 --
 drivers/media/pci/pt1/va1j5jf8007t.c | 532 -------------------
 drivers/media/pci/pt1/va1j5jf8007t.h |  42 --
 7 files changed, 227 insertions(+), 1456 deletions(-)
 delete mode 100644 drivers/media/pci/pt1/va1j5jf8007s.c
 delete mode 100644 drivers/media/pci/pt1/va1j5jf8007s.h
 delete mode 100644 drivers/media/pci/pt1/va1j5jf8007t.c
 delete mode 100644 drivers/media/pci/pt1/va1j5jf8007t.h

diff --git a/drivers/media/pci/pt1/Kconfig b/drivers/media/pci/pt1/Kconfig
index 24501d5bf70..2718b4c6b7c 100644
--- a/drivers/media/pci/pt1/Kconfig
+++ b/drivers/media/pci/pt1/Kconfig
@@ -1,6 +1,9 @@
 config DVB_PT1
 	tristate "PT1 cards"
 	depends on DVB_CORE && PCI && I2C
+	select DVB_TC90522 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_PLL if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_QM1D1B0004 if MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Support for Earthsoft PT1 PCI cards.
 
diff --git a/drivers/media/pci/pt1/Makefile b/drivers/media/pci/pt1/Makefile
index ab873ae088a..bc491e08dd6 100644
--- a/drivers/media/pci/pt1/Makefile
+++ b/drivers/media/pci/pt1/Makefile
@@ -1,5 +1,6 @@
-earth-pt1-objs := pt1.o va1j5jf8007s.o va1j5jf8007t.o
+earth-pt1-objs := pt1.o
 
 obj-$(CONFIG_DVB_PT1) += earth-pt1.o
 
 ccflags-y += -Idrivers/media/dvb-frontends
+ccflags-y += -Idrivers/media/tuners
diff --git a/drivers/media/pci/pt1/pt1.c b/drivers/media/pci/pt1/pt1.c
index 4f6867af831..40b6c0ac342 100644
--- a/drivers/media/pci/pt1/pt1.c
+++ b/drivers/media/pci/pt1/pt1.c
@@ -26,6 +26,8 @@
 #include <linux/kthread.h>
 #include <linux/freezer.h>
 #include <linux/ratelimit.h>
+#include <linux/string.h>
+#include <linux/i2c.h>
 
 #include <media/dvbdev.h>
 #include <media/dvb_demux.h>
@@ -33,8 +35,9 @@
 #include <media/dvb_net.h>
 #include <media/dvb_frontend.h>
 
-#include "va1j5jf8007t.h"
-#include "va1j5jf8007s.h"
+#include "tc90522.h"
+#include "qm1d1b0004.h"
+#include "dvb-pll.h"
 
 #define DRIVER_NAME "earth-pt1"
 
@@ -63,6 +66,11 @@ struct pt1_table {
 	struct pt1_buffer bufs[PT1_NR_BUFS];
 };
 
+enum pt1_fe_clk {
+	PT1_FE_CLK_20MHZ,	/* PT1 */
+	PT1_FE_CLK_25MHZ,	/* PT2 */
+};
+
 #define PT1_NR_ADAPS 4
 
 struct pt1_adapter;
@@ -81,6 +89,8 @@ struct pt1 {
 	struct mutex lock;
 	int power;
 	int reset;
+
+	enum pt1_fe_clk fe_clk;
 };
 
 struct pt1_adapter {
@@ -97,6 +107,8 @@ struct pt1_adapter {
 	int users;
 	struct dmxdev dmxdev;
 	struct dvb_frontend *fe;
+	struct i2c_client *demod_i2c_client;
+	struct i2c_client *tuner_i2c_client;
 	int (*orig_set_voltage)(struct dvb_frontend *fe,
 				enum fe_sec_voltage voltage);
 	int (*orig_sleep)(struct dvb_frontend *fe);
@@ -106,6 +118,144 @@ struct pt1_adapter {
 	int sleep;
 };
 
+union pt1_tuner_config {
+	struct qm1d1b0004_config qm1d1b0004;
+	struct dvb_pll_config tda6651;
+};
+
+struct pt1_config {
+	struct i2c_board_info demod_info;
+	struct tc90522_config demod_cfg;
+
+	struct i2c_board_info tuner_info;
+	union pt1_tuner_config tuner_cfg;
+};
+
+static const struct pt1_config pt1_configs[PT1_NR_ADAPS] = {
+	{
+		.demod_info = {
+			I2C_BOARD_INFO(TC90522_I2C_DEV_SAT, 0x1b),
+		},
+		.tuner_info = {
+			I2C_BOARD_INFO("qm1d1b0004", 0x60),
+		},
+	},
+	{
+		.demod_info = {
+			I2C_BOARD_INFO(TC90522_I2C_DEV_TER, 0x1a),
+		},
+		.tuner_info = {
+			I2C_BOARD_INFO("tda665x_earthpt1", 0x61),
+		},
+	},
+	{
+		.demod_info = {
+			I2C_BOARD_INFO(TC90522_I2C_DEV_SAT, 0x19),
+		},
+		.tuner_info = {
+			I2C_BOARD_INFO("qm1d1b0004", 0x60),
+		},
+	},
+	{
+		.demod_info = {
+			I2C_BOARD_INFO(TC90522_I2C_DEV_TER, 0x18),
+		},
+		.tuner_info = {
+			I2C_BOARD_INFO("tda665x_earthpt1", 0x61),
+		},
+	},
+};
+
+static const u8 va1j5jf8007s_20mhz_configs[][2] = {
+	{0x04, 0x02}, {0x0d, 0x55}, {0x11, 0x40}, {0x13, 0x80}, {0x17, 0x01},
+	{0x1c, 0x0a}, {0x1d, 0xaa}, {0x1e, 0x20}, {0x1f, 0x88}, {0x51, 0xb0},
+	{0x52, 0x89}, {0x53, 0xb3}, {0x5a, 0x2d}, {0x5b, 0xd3}, {0x85, 0x69},
+	{0x87, 0x04}, {0x8e, 0x02}, {0xa3, 0xf7}, {0xa5, 0xc0},
+};
+
+static const u8 va1j5jf8007s_25mhz_configs[][2] = {
+	{0x04, 0x02}, {0x11, 0x40}, {0x13, 0x80}, {0x17, 0x01}, {0x1c, 0x0a},
+	{0x1d, 0xaa}, {0x1e, 0x20}, {0x1f, 0x88}, {0x51, 0xb0}, {0x52, 0x89},
+	{0x53, 0xb3}, {0x5a, 0x2d}, {0x5b, 0xd3}, {0x85, 0x69}, {0x87, 0x04},
+	{0x8e, 0x26}, {0xa3, 0xf7}, {0xa5, 0xc0},
+};
+
+static const u8 va1j5jf8007t_20mhz_configs[][2] = {
+	{0x03, 0x90}, {0x14, 0x8f}, {0x1c, 0x2a}, {0x1d, 0xa8}, {0x1e, 0xa2},
+	{0x22, 0x83}, {0x31, 0x0d}, {0x32, 0xe0}, {0x39, 0xd3}, {0x3a, 0x00},
+	{0x3b, 0x11}, {0x3c, 0x3f},
+	{0x5c, 0x40}, {0x5f, 0x80}, {0x75, 0x02}, {0x76, 0x4e}, {0x77, 0x03},
+	{0xef, 0x01}
+};
+
+static const u8 va1j5jf8007t_25mhz_configs[][2] = {
+	{0x03, 0x90}, {0x1c, 0x2a}, {0x1d, 0xa8}, {0x1e, 0xa2}, {0x22, 0x83},
+	{0x3a, 0x04}, {0x3b, 0x11}, {0x3c, 0x3f}, {0x5c, 0x40}, {0x5f, 0x80},
+	{0x75, 0x0a}, {0x76, 0x4c}, {0x77, 0x03}, {0xef, 0x01}
+};
+
+static int config_demod(struct i2c_client *cl, enum pt1_fe_clk clk)
+{
+	int ret;
+	u8 buf[2] = {0x01, 0x80};
+	bool is_sat;
+	const u8 (*cfg_data)[2];
+	int i, len;
+
+	ret = i2c_master_send(cl, buf, 2);
+	if (ret < 0)
+		return ret;
+	usleep_range(30000, 50000);
+
+	is_sat = !strncmp(cl->name, TC90522_I2C_DEV_SAT, I2C_NAME_SIZE);
+	if (is_sat) {
+		struct i2c_msg msg[2];
+		u8 wbuf, rbuf;
+
+		wbuf = 0x07;
+		msg[0].addr = cl->addr;
+		msg[0].flags = 0;
+		msg[0].len = 1;
+		msg[0].buf = &wbuf;
+
+		msg[1].addr = cl->addr;
+		msg[1].flags = I2C_M_RD;
+		msg[1].len = 1;
+		msg[1].buf = &rbuf;
+		ret = i2c_transfer(cl->adapter, msg, 2);
+		if (ret < 0)
+			return ret;
+		if (rbuf != 0x41)
+			return -EIO;
+	}
+
+	/* frontend init */
+	if (clk == PT1_FE_CLK_20MHZ) {
+		if (is_sat) {
+			cfg_data = va1j5jf8007s_20mhz_configs;
+			len = ARRAY_SIZE(va1j5jf8007s_20mhz_configs);
+		} else {
+			cfg_data = va1j5jf8007t_20mhz_configs;
+			len = ARRAY_SIZE(va1j5jf8007t_20mhz_configs);
+		}
+	} else {
+		if (is_sat) {
+			cfg_data = va1j5jf8007s_25mhz_configs;
+			len = ARRAY_SIZE(va1j5jf8007s_25mhz_configs);
+		} else {
+			cfg_data = va1j5jf8007t_25mhz_configs;
+			len = ARRAY_SIZE(va1j5jf8007t_25mhz_configs);
+		}
+	}
+
+	for (i = 0; i < len; i++) {
+		ret = i2c_master_send(cl, cfg_data[i], 2);
+		if (ret < 0)
+			return ret;
+	}
+	return 0;
+}
+
 static void pt1_write_reg(struct pt1 *pt1, int reg, u32 data)
 {
 	writel(data, pt1->regs + reg * 4);
@@ -589,30 +739,33 @@ static int pt1_set_voltage(struct dvb_frontend *fe, enum fe_sec_voltage voltage)
 static int pt1_sleep(struct dvb_frontend *fe)
 {
 	struct pt1_adapter *adap;
+	int ret;
 
 	adap = container_of(fe->dvb, struct pt1_adapter, adap);
-	adap->sleep = 1;
-	pt1_update_power(adap->pt1);
 
+	ret = 0;
 	if (adap->orig_sleep)
-		return adap->orig_sleep(fe);
-	else
-		return 0;
+		ret = adap->orig_sleep(fe);
+
+	adap->sleep = 1;
+	pt1_update_power(adap->pt1);
+	return ret;
 }
 
 static int pt1_wakeup(struct dvb_frontend *fe)
 {
 	struct pt1_adapter *adap;
+	int ret;
 
 	adap = container_of(fe->dvb, struct pt1_adapter, adap);
 	adap->sleep = 0;
 	pt1_update_power(adap->pt1);
 	schedule_timeout_uninterruptible((HZ + 999) / 1000);
 
-	if (adap->orig_init)
-		return adap->orig_init(fe);
-	else
-		return 0;
+	ret = config_demod(adap->demod_i2c_client, adap->pt1->fe_clk);
+	if (ret == 0 && adap->orig_init)
+		ret = adap->orig_init(fe);
+	return ret;
 }
 
 static void pt1_free_adapter(struct pt1_adapter *adap)
@@ -735,6 +888,8 @@ static int pt1_init_adapters(struct pt1 *pt1)
 static void pt1_cleanup_frontend(struct pt1_adapter *adap)
 {
 	dvb_unregister_frontend(adap->fe);
+	dvb_module_release(adap->tuner_i2c_client);
+	dvb_module_release(adap->demod_i2c_client);
 }
 
 static int pt1_init_frontend(struct pt1_adapter *adap, struct dvb_frontend *fe)
@@ -763,112 +918,70 @@ static void pt1_cleanup_frontends(struct pt1 *pt1)
 		pt1_cleanup_frontend(pt1->adaps[i]);
 }
 
-struct pt1_config {
-	struct va1j5jf8007s_config va1j5jf8007s_config;
-	struct va1j5jf8007t_config va1j5jf8007t_config;
-};
-
-static const struct pt1_config pt1_configs[2] = {
-	{
-		{
-			.demod_address = 0x1b,
-			.frequency = VA1J5JF8007S_20MHZ,
-		},
-		{
-			.demod_address = 0x1a,
-			.frequency = VA1J5JF8007T_20MHZ,
-		},
-	}, {
-		{
-			.demod_address = 0x19,
-			.frequency = VA1J5JF8007S_20MHZ,
-		},
-		{
-			.demod_address = 0x18,
-			.frequency = VA1J5JF8007T_20MHZ,
-		},
-	},
-};
-
-static const struct pt1_config pt2_configs[2] = {
-	{
-		{
-			.demod_address = 0x1b,
-			.frequency = VA1J5JF8007S_25MHZ,
-		},
-		{
-			.demod_address = 0x1a,
-			.frequency = VA1J5JF8007T_25MHZ,
-		},
-	}, {
-		{
-			.demod_address = 0x19,
-			.frequency = VA1J5JF8007S_25MHZ,
-		},
-		{
-			.demod_address = 0x18,
-			.frequency = VA1J5JF8007T_25MHZ,
-		},
-	},
-};
-
 static int pt1_init_frontends(struct pt1 *pt1)
 {
-	int i, j;
-	struct i2c_adapter *i2c_adap;
-	const struct pt1_config *configs, *config;
-	struct dvb_frontend *fe[4];
+	int i;
 	int ret;
 
-	i = 0;
-	j = 0;
-
-	i2c_adap = &pt1->i2c_adap;
-	configs = pt1->pdev->device == 0x211a ? pt1_configs : pt2_configs;
-	do {
-		config = &configs[i / 2];
-
-		fe[i] = va1j5jf8007s_attach(&config->va1j5jf8007s_config,
-					    i2c_adap);
-		if (!fe[i]) {
-			ret = -ENODEV; /* This does not sound nice... */
-			goto err;
-		}
-		i++;
-
-		fe[i] = va1j5jf8007t_attach(&config->va1j5jf8007t_config,
-					    i2c_adap);
-		if (!fe[i]) {
-			ret = -ENODEV;
-			goto err;
+	for (i = 0; i < ARRAY_SIZE(pt1_configs); i++) {
+		const struct i2c_board_info *info;
+		struct tc90522_config dcfg;
+		struct i2c_client *cl;
+
+		info = &pt1_configs[i].demod_info;
+		dcfg = pt1_configs[i].demod_cfg;
+		dcfg.tuner_i2c = NULL;
+
+		ret = -ENODEV;
+		cl = dvb_module_probe("tc90522", info->type, &pt1->i2c_adap,
+				      info->addr, &dcfg);
+		if (!cl)
+			goto fe_unregister;
+		pt1->adaps[i]->demod_i2c_client = cl;
+
+		if (!strncmp(cl->name, TC90522_I2C_DEV_SAT,
+			     strlen(TC90522_I2C_DEV_SAT))) {
+			struct qm1d1b0004_config tcfg;
+
+			info = &pt1_configs[i].tuner_info;
+			tcfg = pt1_configs[i].tuner_cfg.qm1d1b0004;
+			tcfg.fe = dcfg.fe;
+			cl = dvb_module_probe("qm1d1b0004",
+					      info->type, dcfg.tuner_i2c,
+					      info->addr, &tcfg);
+		} else {
+			struct dvb_pll_config tcfg;
+
+			info = &pt1_configs[i].tuner_info;
+			tcfg = pt1_configs[i].tuner_cfg.tda6651;
+			tcfg.fe = dcfg.fe;
+			cl = dvb_module_probe("dvb_pll",
+					      info->type, dcfg.tuner_i2c,
+					      info->addr, &tcfg);
 		}
-		i++;
+		if (!cl)
+			goto demod_release;
+		pt1->adaps[i]->tuner_i2c_client = cl;
 
-		ret = va1j5jf8007s_prepare(fe[i - 2]);
+		ret = pt1_init_frontend(pt1->adaps[i], dcfg.fe);
 		if (ret < 0)
-			goto err;
-
-		ret = va1j5jf8007t_prepare(fe[i - 1]);
-		if (ret < 0)
-			goto err;
-
-	} while (i < 4);
-
-	do {
-		ret = pt1_init_frontend(pt1->adaps[j], fe[j]);
-		if (ret < 0)
-			goto err;
-	} while (++j < 4);
+			goto tuner_release;
+	}
 
 	return 0;
 
-err:
-	while (i-- > j)
-		fe[i]->ops.release(fe[i]);
-
-	while (j--)
-		dvb_unregister_frontend(fe[j]);
-
+tuner_release:
+	dvb_module_release(pt1->adaps[i]->tuner_i2c_client);
+demod_release:
+	dvb_module_release(pt1->adaps[i]->demod_i2c_client);
+fe_unregister:
+	dev_warn(&pt1->pdev->dev, "failed to init FE(%d).\n", i);
+	i--;
+	for (; i >= 0; i--) {
+		dvb_unregister_frontend(pt1->adaps[i]->fe);
+		dvb_module_release(pt1->adaps[i]->tuner_i2c_client);
+		dvb_module_release(pt1->adaps[i]->demod_i2c_client);
+	}
 	return ret;
 }
 
@@ -1112,6 +1225,8 @@ static int pt1_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	mutex_init(&pt1->lock);
 	pt1->pdev = pdev;
 	pt1->regs = regs;
+	pt1->fe_clk = (pdev->device == 0x211a) ?
+				PT1_FE_CLK_20MHZ : PT1_FE_CLK_25MHZ;
 	pci_set_drvdata(pdev, pt1);
 
 	ret = pt1_init_adapters(pt1);
diff --git a/drivers/media/pci/pt1/va1j5jf8007s.c b/drivers/media/pci/pt1/va1j5jf8007s.c
deleted file mode 100644
index f49867aef05..00000000000
--- a/drivers/media/pci/pt1/va1j5jf8007s.c
+++ /dev/null
@@ -1,732 +0,0 @@
-/*
- * ISDB-S driver for VA1J5JF8007/VA1J5JF8011
- *
- * Copyright (C) 2009 HIRANO Takahito <hiranotaka@zng.info>
- *
- * based on pt1dvr - http://pt1dvr.sourceforge.jp/
- *	by Tomoaki Ishikawa <tomy@users.sourceforge.jp>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- */
-
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/slab.h>
-#include <linux/i2c.h>
-#include <media/dvb_frontend.h>
-#include "va1j5jf8007s.h"
-
-enum va1j5jf8007s_tune_state {
-	VA1J5JF8007S_IDLE,
-	VA1J5JF8007S_SET_FREQUENCY_1,
-	VA1J5JF8007S_SET_FREQUENCY_2,
-	VA1J5JF8007S_SET_FREQUENCY_3,
-	VA1J5JF8007S_CHECK_FREQUENCY,
-	VA1J5JF8007S_SET_MODULATION,
-	VA1J5JF8007S_CHECK_MODULATION,
-	VA1J5JF8007S_SET_TS_ID,
-	VA1J5JF8007S_CHECK_TS_ID,
-	VA1J5JF8007S_TRACK,
-};
-
-struct va1j5jf8007s_state {
-	const struct va1j5jf8007s_config *config;
-	struct i2c_adapter *adap;
-	struct dvb_frontend fe;
-	enum va1j5jf8007s_tune_state tune_state;
-};
-
-static int va1j5jf8007s_read_snr(struct dvb_frontend *fe, u16 *snr)
-{
-	struct va1j5jf8007s_state *state;
-	u8 addr;
-	int i;
-	u8 write_buf[1], read_buf[1];
-	struct i2c_msg msgs[2];
-	s32 word, x1, x2, x3, x4, x5, y;
-
-	state = fe->demodulator_priv;
-	addr = state->config->demod_address;
-
-	word = 0;
-	for (i = 0; i < 2; i++) {
-		write_buf[0] = 0xbc + i;
-
-		msgs[0].addr = addr;
-		msgs[0].flags = 0;
-		msgs[0].len = sizeof(write_buf);
-		msgs[0].buf = write_buf;
-
-		msgs[1].addr = addr;
-		msgs[1].flags = I2C_M_RD;
-		msgs[1].len = sizeof(read_buf);
-		msgs[1].buf = read_buf;
-
-		if (i2c_transfer(state->adap, msgs, 2) != 2)
-			return -EREMOTEIO;
-
-		word <<= 8;
-		word |= read_buf[0];
-	}
-
-	word -= 3000;
-	if (word < 0)
-		word = 0;
-
-	x1 = int_sqrt(word << 16) * ((15625ll << 21) / 1000000);
-	x2 = (s64)x1 * x1 >> 31;
-	x3 = (s64)x2 * x1 >> 31;
-	x4 = (s64)x2 * x2 >> 31;
-	x5 = (s64)x4 * x1 >> 31;
-
-	y = (58857ll << 23) / 1000;
-	y -= (s64)x1 * ((89565ll << 24) / 1000) >> 30;
-	y += (s64)x2 * ((88977ll << 24) / 1000) >> 28;
-	y -= (s64)x3 * ((50259ll << 25) / 1000) >> 27;
-	y += (s64)x4 * ((14341ll << 27) / 1000) >> 27;
-	y -= (s64)x5 * ((16346ll << 30) / 10000) >> 28;
-
-	*snr = y < 0 ? 0 : y >> 15;
-	return 0;
-}
-
-static int va1j5jf8007s_get_frontend_algo(struct dvb_frontend *fe)
-{
-	return DVBFE_ALGO_HW;
-}
-
-static int
-va1j5jf8007s_read_status(struct dvb_frontend *fe, enum fe_status *status)
-{
-	struct va1j5jf8007s_state *state;
-
-	state = fe->demodulator_priv;
-
-	switch (state->tune_state) {
-	case VA1J5JF8007S_IDLE:
-	case VA1J5JF8007S_SET_FREQUENCY_1:
-	case VA1J5JF8007S_SET_FREQUENCY_2:
-	case VA1J5JF8007S_SET_FREQUENCY_3:
-	case VA1J5JF8007S_CHECK_FREQUENCY:
-		*status = 0;
-		return 0;
-
-
-	case VA1J5JF8007S_SET_MODULATION:
-	case VA1J5JF8007S_CHECK_MODULATION:
-		*status |= FE_HAS_SIGNAL;
-		return 0;
-
-	case VA1J5JF8007S_SET_TS_ID:
-	case VA1J5JF8007S_CHECK_TS_ID:
-		*status |= FE_HAS_SIGNAL | FE_HAS_CARRIER;
-		return 0;
-
-	case VA1J5JF8007S_TRACK:
-		*status |= FE_HAS_SIGNAL | FE_HAS_CARRIER | FE_HAS_LOCK;
-		return 0;
-	}
-
-	BUG();
-}
-
-struct va1j5jf8007s_cb_map {
-	u32 frequency;
-	u8 cb;
-};
-
-static const struct va1j5jf8007s_cb_map va1j5jf8007s_cb_maps[] = {
-	{  986000, 0xb2 },
-	{ 1072000, 0xd2 },
-	{ 1154000, 0xe2 },
-	{ 1291000, 0x20 },
-	{ 1447000, 0x40 },
-	{ 1615000, 0x60 },
-	{ 1791000, 0x80 },
-	{ 1972000, 0xa0 },
-};
-
-static u8 va1j5jf8007s_lookup_cb(u32 frequency)
-{
-	int i;
-	const struct va1j5jf8007s_cb_map *map;
-
-	for (i = 0; i < ARRAY_SIZE(va1j5jf8007s_cb_maps); i++) {
-		map = &va1j5jf8007s_cb_maps[i];
-		if (frequency < map->frequency)
-			return map->cb;
-	}
-	return 0xc0;
-}
-
-static int va1j5jf8007s_set_frequency_1(struct va1j5jf8007s_state *state)
-{
-	u32 frequency;
-	u16 word;
-	u8 buf[6];
-	struct i2c_msg msg;
-
-	frequency = state->fe.dtv_property_cache.frequency;
-
-	word = (frequency + 500) / 1000;
-	if (frequency < 1072000)
-		word = (word << 1 & ~0x1f) | (word & 0x0f);
-
-	buf[0] = 0xfe;
-	buf[1] = 0xc0;
-	buf[2] = 0x40 | word >> 8;
-	buf[3] = word;
-	buf[4] = 0xe0;
-	buf[5] = va1j5jf8007s_lookup_cb(frequency);
-
-	msg.addr = state->config->demod_address;
-	msg.flags = 0;
-	msg.len = sizeof(buf);
-	msg.buf = buf;
-
-	if (i2c_transfer(state->adap, &msg, 1) != 1)
-		return -EREMOTEIO;
-
-	return 0;
-}
-
-static int va1j5jf8007s_set_frequency_2(struct va1j5jf8007s_state *state)
-{
-	u8 buf[3];
-	struct i2c_msg msg;
-
-	buf[0] = 0xfe;
-	buf[1] = 0xc0;
-	buf[2] = 0xe4;
-
-	msg.addr = state->config->demod_address;
-	msg.flags = 0;
-	msg.len = sizeof(buf);
-	msg.buf = buf;
-
-	if (i2c_transfer(state->adap, &msg, 1) != 1)
-		return -EREMOTEIO;
-
-	return 0;
-}
-
-static int va1j5jf8007s_set_frequency_3(struct va1j5jf8007s_state *state)
-{
-	u32 frequency;
-	u8 buf[4];
-	struct i2c_msg msg;
-
-	frequency = state->fe.dtv_property_cache.frequency;
-
-	buf[0] = 0xfe;
-	buf[1] = 0xc0;
-	buf[2] = 0xf4;
-	buf[3] = va1j5jf8007s_lookup_cb(frequency) | 0x4;
-
-	msg.addr = state->config->demod_address;
-	msg.flags = 0;
-	msg.len = sizeof(buf);
-	msg.buf = buf;
-
-	if (i2c_transfer(state->adap, &msg, 1) != 1)
-		return -EREMOTEIO;
-
-	return 0;
-}
-
-static int
-va1j5jf8007s_check_frequency(struct va1j5jf8007s_state *state, int *lock)
-{
-	u8 addr;
-	u8 write_buf[2], read_buf[1];
-	struct i2c_msg msgs[2];
-
-	addr = state->config->demod_address;
-
-	write_buf[0] = 0xfe;
-	write_buf[1] = 0xc1;
-
-	msgs[0].addr = addr;
-	msgs[0].flags = 0;
-	msgs[0].len = sizeof(write_buf);
-	msgs[0].buf = write_buf;
-
-	msgs[1].addr = addr;
-	msgs[1].flags = I2C_M_RD;
-	msgs[1].len = sizeof(read_buf);
-	msgs[1].buf = read_buf;
-
-	if (i2c_transfer(state->adap, msgs, 2) != 2)
-		return -EREMOTEIO;
-
-	*lock = read_buf[0] & 0x40;
-	return 0;
-}
-
-static int va1j5jf8007s_set_modulation(struct va1j5jf8007s_state *state)
-{
-	u8 buf[2];
-	struct i2c_msg msg;
-
-	buf[0] = 0x03;
-	buf[1] = 0x01;
-
-	msg.addr = state->config->demod_address;
-	msg.flags = 0;
-	msg.len = sizeof(buf);
-	msg.buf = buf;
-
-	if (i2c_transfer(state->adap, &msg, 1) != 1)
-		return -EREMOTEIO;
-
-	return 0;
-}
-
-static int
-va1j5jf8007s_check_modulation(struct va1j5jf8007s_state *state, int *lock)
-{
-	u8 addr;
-	u8 write_buf[1], read_buf[1];
-	struct i2c_msg msgs[2];
-
-	addr = state->config->demod_address;
-
-	write_buf[0] = 0xc3;
-
-	msgs[0].addr = addr;
-	msgs[0].flags = 0;
-	msgs[0].len = sizeof(write_buf);
-	msgs[0].buf = write_buf;
-
-	msgs[1].addr = addr;
-	msgs[1].flags = I2C_M_RD;
-	msgs[1].len = sizeof(read_buf);
-	msgs[1].buf = read_buf;
-
-	if (i2c_transfer(state->adap, msgs, 2) != 2)
-		return -EREMOTEIO;
-
-	*lock = !(read_buf[0] & 0x10);
-	return 0;
-}
-
-static int
-va1j5jf8007s_set_ts_id(struct va1j5jf8007s_state *state)
-{
-	u32 ts_id;
-	u8 buf[3];
-	struct i2c_msg msg;
-
-	ts_id = state->fe.dtv_property_cache.stream_id;
-	if (!ts_id || ts_id == NO_STREAM_ID_FILTER)
-		return 0;
-
-	buf[0] = 0x8f;
-	buf[1] = ts_id >> 8;
-	buf[2] = ts_id;
-
-	msg.addr = state->config->demod_address;
-	msg.flags = 0;
-	msg.len = sizeof(buf);
-	msg.buf = buf;
-
-	if (i2c_transfer(state->adap, &msg, 1) != 1)
-		return -EREMOTEIO;
-
-	return 0;
-}
-
-static int
-va1j5jf8007s_check_ts_id(struct va1j5jf8007s_state *state, int *lock)
-{
-	u8 addr;
-	u8 write_buf[1], read_buf[2];
-	struct i2c_msg msgs[2];
-	u32 ts_id;
-
-	ts_id = state->fe.dtv_property_cache.stream_id;
-	if (!ts_id || ts_id == NO_STREAM_ID_FILTER) {
-		*lock = 1;
-		return 0;
-	}
-
-	addr = state->config->demod_address;
-
-	write_buf[0] = 0xe6;
-
-	msgs[0].addr = addr;
-	msgs[0].flags = 0;
-	msgs[0].len = sizeof(write_buf);
-	msgs[0].buf = write_buf;
-
-	msgs[1].addr = addr;
-	msgs[1].flags = I2C_M_RD;
-	msgs[1].len = sizeof(read_buf);
-	msgs[1].buf = read_buf;
-
-	if (i2c_transfer(state->adap, msgs, 2) != 2)
-		return -EREMOTEIO;
-
-	*lock = (read_buf[0] << 8 | read_buf[1]) == ts_id;
-	return 0;
-}
-
-static int
-va1j5jf8007s_tune(struct dvb_frontend *fe,
-		  bool re_tune,
-		  unsigned int mode_flags,  unsigned int *delay,
-		  enum fe_status *status)
-{
-	struct va1j5jf8007s_state *state;
-	int ret;
-	int lock = 0;
-
-	state = fe->demodulator_priv;
-
-	if (re_tune)
-		state->tune_state = VA1J5JF8007S_SET_FREQUENCY_1;
-
-	switch (state->tune_state) {
-	case VA1J5JF8007S_IDLE:
-		*delay = 3 * HZ;
-		*status = 0;
-		return 0;
-
-	case VA1J5JF8007S_SET_FREQUENCY_1:
-		ret = va1j5jf8007s_set_frequency_1(state);
-		if (ret < 0)
-			return ret;
-
-		state->tune_state = VA1J5JF8007S_SET_FREQUENCY_2;
-		*delay = 0;
-		*status = 0;
-		return 0;
-
-	case VA1J5JF8007S_SET_FREQUENCY_2:
-		ret = va1j5jf8007s_set_frequency_2(state);
-		if (ret < 0)
-			return ret;
-
-		state->tune_state = VA1J5JF8007S_SET_FREQUENCY_3;
-		*delay = (HZ + 99) / 100;
-		*status = 0;
-		return 0;
-
-	case VA1J5JF8007S_SET_FREQUENCY_3:
-		ret = va1j5jf8007s_set_frequency_3(state);
-		if (ret < 0)
-			return ret;
-
-		state->tune_state = VA1J5JF8007S_CHECK_FREQUENCY;
-		*delay = 0;
-		*status = 0;
-		return 0;
-
-	case VA1J5JF8007S_CHECK_FREQUENCY:
-		ret = va1j5jf8007s_check_frequency(state, &lock);
-		if (ret < 0)
-			return ret;
-
-		if (!lock)  {
-			*delay = (HZ + 999) / 1000;
-			*status = 0;
-			return 0;
-		}
-
-		state->tune_state = VA1J5JF8007S_SET_MODULATION;
-		*delay = 0;
-		*status = FE_HAS_SIGNAL;
-		return 0;
-
-	case VA1J5JF8007S_SET_MODULATION:
-		ret = va1j5jf8007s_set_modulation(state);
-		if (ret < 0)
-			return ret;
-
-		state->tune_state = VA1J5JF8007S_CHECK_MODULATION;
-		*delay = 0;
-		*status = FE_HAS_SIGNAL;
-		return 0;
-
-	case VA1J5JF8007S_CHECK_MODULATION:
-		ret = va1j5jf8007s_check_modulation(state, &lock);
-		if (ret < 0)
-			return ret;
-
-		if (!lock)  {
-			*delay = (HZ + 49) / 50;
-			*status = FE_HAS_SIGNAL;
-			return 0;
-		}
-
-		state->tune_state = VA1J5JF8007S_SET_TS_ID;
-		*delay = 0;
-		*status = FE_HAS_SIGNAL | FE_HAS_CARRIER;
-		return 0;
-
-	case VA1J5JF8007S_SET_TS_ID:
-		ret = va1j5jf8007s_set_ts_id(state);
-		if (ret < 0)
-			return ret;
-
-		state->tune_state = VA1J5JF8007S_CHECK_TS_ID;
-		return 0;
-
-	case VA1J5JF8007S_CHECK_TS_ID:
-		ret = va1j5jf8007s_check_ts_id(state, &lock);
-		if (ret < 0)
-			return ret;
-
-		if (!lock)  {
-			*delay = (HZ + 99) / 100;
-			*status = FE_HAS_SIGNAL | FE_HAS_CARRIER;
-			return 0;
-		}
-
-		state->tune_state = VA1J5JF8007S_TRACK;
-		/* fall through */
-
-	case VA1J5JF8007S_TRACK:
-		*delay = 3 * HZ;
-		*status = FE_HAS_SIGNAL | FE_HAS_CARRIER | FE_HAS_LOCK;
-		return 0;
-	}
-
-	BUG();
-}
-
-static int va1j5jf8007s_init_frequency(struct va1j5jf8007s_state *state)
-{
-	u8 buf[4];
-	struct i2c_msg msg;
-
-	buf[0] = 0xfe;
-	buf[1] = 0xc0;
-	buf[2] = 0xf0;
-	buf[3] = 0x04;
-
-	msg.addr = state->config->demod_address;
-	msg.flags = 0;
-	msg.len = sizeof(buf);
-	msg.buf = buf;
-
-	if (i2c_transfer(state->adap, &msg, 1) != 1)
-		return -EREMOTEIO;
-
-	return 0;
-}
-
-static int va1j5jf8007s_set_sleep(struct va1j5jf8007s_state *state, int sleep)
-{
-	u8 buf[2];
-	struct i2c_msg msg;
-
-	buf[0] = 0x17;
-	buf[1] = sleep ? 0x01 : 0x00;
-
-	msg.addr = state->config->demod_address;
-	msg.flags = 0;
-	msg.len = sizeof(buf);
-	msg.buf = buf;
-
-	if (i2c_transfer(state->adap, &msg, 1) != 1)
-		return -EREMOTEIO;
-
-	return 0;
-}
-
-static int va1j5jf8007s_sleep(struct dvb_frontend *fe)
-{
-	struct va1j5jf8007s_state *state;
-	int ret;
-
-	state = fe->demodulator_priv;
-
-	ret = va1j5jf8007s_init_frequency(state);
-	if (ret < 0)
-		return ret;
-
-	return va1j5jf8007s_set_sleep(state, 1);
-}
-
-static int va1j5jf8007s_init(struct dvb_frontend *fe)
-{
-	struct va1j5jf8007s_state *state;
-
-	state = fe->demodulator_priv;
-	state->tune_state = VA1J5JF8007S_IDLE;
-
-	return va1j5jf8007s_set_sleep(state, 0);
-}
-
-static void va1j5jf8007s_release(struct dvb_frontend *fe)
-{
-	struct va1j5jf8007s_state *state;
-	state = fe->demodulator_priv;
-	kfree(state);
-}
-
-static const struct dvb_frontend_ops va1j5jf8007s_ops = {
-	.delsys = { SYS_ISDBS },
-	.info = {
-		.name = "VA1J5JF8007/VA1J5JF8011 ISDB-S",
-		.frequency_min = 950000,
-		.frequency_max = 2150000,
-		.frequency_stepsize = 1000,
-		.caps = FE_CAN_INVERSION_AUTO | FE_CAN_FEC_AUTO |
-			FE_CAN_QAM_AUTO | FE_CAN_TRANSMISSION_MODE_AUTO |
-			FE_CAN_GUARD_INTERVAL_AUTO | FE_CAN_HIERARCHY_AUTO |
-			FE_CAN_MULTISTREAM,
-	},
-
-	.read_snr = va1j5jf8007s_read_snr,
-	.get_frontend_algo = va1j5jf8007s_get_frontend_algo,
-	.read_status = va1j5jf8007s_read_status,
-	.tune = va1j5jf8007s_tune,
-	.sleep = va1j5jf8007s_sleep,
-	.init = va1j5jf8007s_init,
-	.release = va1j5jf8007s_release,
-};
-
-static int va1j5jf8007s_prepare_1(struct va1j5jf8007s_state *state)
-{
-	u8 addr;
-	u8 write_buf[1], read_buf[1];
-	struct i2c_msg msgs[2];
-
-	addr = state->config->demod_address;
-
-	write_buf[0] = 0x07;
-
-	msgs[0].addr = addr;
-	msgs[0].flags = 0;
-	msgs[0].len = sizeof(write_buf);
-	msgs[0].buf = write_buf;
-
-	msgs[1].addr = addr;
-	msgs[1].flags = I2C_M_RD;
-	msgs[1].len = sizeof(read_buf);
-	msgs[1].buf = read_buf;
-
-	if (i2c_transfer(state->adap, msgs, 2) != 2)
-		return -EREMOTEIO;
-
-	if (read_buf[0] != 0x41)
-		return -EIO;
-
-	return 0;
-}
-
-static const u8 va1j5jf8007s_20mhz_prepare_bufs[][2] = {
-	{0x04, 0x02}, {0x0d, 0x55}, {0x11, 0x40}, {0x13, 0x80}, {0x17, 0x01},
-	{0x1c, 0x0a}, {0x1d, 0xaa}, {0x1e, 0x20}, {0x1f, 0x88}, {0x51, 0xb0},
-	{0x52, 0x89}, {0x53, 0xb3}, {0x5a, 0x2d}, {0x5b, 0xd3}, {0x85, 0x69},
-	{0x87, 0x04}, {0x8e, 0x02}, {0xa3, 0xf7}, {0xa5, 0xc0},
-};
-
-static const u8 va1j5jf8007s_25mhz_prepare_bufs[][2] = {
-	{0x04, 0x02}, {0x11, 0x40}, {0x13, 0x80}, {0x17, 0x01}, {0x1c, 0x0a},
-	{0x1d, 0xaa}, {0x1e, 0x20}, {0x1f, 0x88}, {0x51, 0xb0}, {0x52, 0x89},
-	{0x53, 0xb3}, {0x5a, 0x2d}, {0x5b, 0xd3}, {0x85, 0x69}, {0x87, 0x04},
-	{0x8e, 0x26}, {0xa3, 0xf7}, {0xa5, 0xc0},
-};
-
-static int va1j5jf8007s_prepare_2(struct va1j5jf8007s_state *state)
-{
-	const u8 (*bufs)[2];
-	int size;
-	u8 addr;
-	u8 buf[2];
-	struct i2c_msg msg;
-	int i;
-
-	switch (state->config->frequency) {
-	case VA1J5JF8007S_20MHZ:
-		bufs = va1j5jf8007s_20mhz_prepare_bufs;
-		size = ARRAY_SIZE(va1j5jf8007s_20mhz_prepare_bufs);
-		break;
-	case VA1J5JF8007S_25MHZ:
-		bufs = va1j5jf8007s_25mhz_prepare_bufs;
-		size = ARRAY_SIZE(va1j5jf8007s_25mhz_prepare_bufs);
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	addr = state->config->demod_address;
-
-	msg.addr = addr;
-	msg.flags = 0;
-	msg.len = 2;
-	msg.buf = buf;
-	for (i = 0; i < size; i++) {
-		memcpy(buf, bufs[i], sizeof(buf));
-		if (i2c_transfer(state->adap, &msg, 1) != 1)
-			return -EREMOTEIO;
-	}
-
-	return 0;
-}
-
-/* must be called after va1j5jf8007t_attach */
-int va1j5jf8007s_prepare(struct dvb_frontend *fe)
-{
-	struct va1j5jf8007s_state *state;
-	int ret;
-
-	state = fe->demodulator_priv;
-
-	ret = va1j5jf8007s_prepare_1(state);
-	if (ret < 0)
-		return ret;
-
-	ret = va1j5jf8007s_prepare_2(state);
-	if (ret < 0)
-		return ret;
-
-	return va1j5jf8007s_init_frequency(state);
-}
-
-struct dvb_frontend *
-va1j5jf8007s_attach(const struct va1j5jf8007s_config *config,
-		    struct i2c_adapter *adap)
-{
-	struct va1j5jf8007s_state *state;
-	struct dvb_frontend *fe;
-	u8 buf[2];
-	struct i2c_msg msg;
-
-	state = kzalloc(sizeof(struct va1j5jf8007s_state), GFP_KERNEL);
-	if (!state)
-		return NULL;
-
-	state->config = config;
-	state->adap = adap;
-
-	fe = &state->fe;
-	memcpy(&fe->ops, &va1j5jf8007s_ops, sizeof(struct dvb_frontend_ops));
-	fe->demodulator_priv = state;
-
-	buf[0] = 0x01;
-	buf[1] = 0x80;
-
-	msg.addr = state->config->demod_address;
-	msg.flags = 0;
-	msg.len = sizeof(buf);
-	msg.buf = buf;
-
-	if (i2c_transfer(state->adap, &msg, 1) != 1) {
-		kfree(state);
-		return NULL;
-	}
-
-	return fe;
-}
diff --git a/drivers/media/pci/pt1/va1j5jf8007s.h b/drivers/media/pci/pt1/va1j5jf8007s.h
deleted file mode 100644
index f8ce5609095..00000000000
--- a/drivers/media/pci/pt1/va1j5jf8007s.h
+++ /dev/null
@@ -1,42 +0,0 @@
-/*
- * ISDB-S driver for VA1J5JF8007/VA1J5JF8011
- *
- * Copyright (C) 2009 HIRANO Takahito <hiranotaka@zng.info>
- *
- * based on pt1dvr - http://pt1dvr.sourceforge.jp/
- *	by Tomoaki Ishikawa <tomy@users.sourceforge.jp>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- */
-
-#ifndef VA1J5JF8007S_H
-#define VA1J5JF8007S_H
-
-enum va1j5jf8007s_frequency {
-	VA1J5JF8007S_20MHZ,
-	VA1J5JF8007S_25MHZ,
-};
-
-struct va1j5jf8007s_config {
-	u8 demod_address;
-	enum va1j5jf8007s_frequency frequency;
-};
-
-struct i2c_adapter;
-
-struct dvb_frontend *
-va1j5jf8007s_attach(const struct va1j5jf8007s_config *config,
-		    struct i2c_adapter *adap);
-
-/* must be called after va1j5jf8007t_attach */
-int va1j5jf8007s_prepare(struct dvb_frontend *fe);
-
-#endif
diff --git a/drivers/media/pci/pt1/va1j5jf8007t.c b/drivers/media/pci/pt1/va1j5jf8007t.c
deleted file mode 100644
index a52984a6f9b..00000000000
--- a/drivers/media/pci/pt1/va1j5jf8007t.c
+++ /dev/null
@@ -1,532 +0,0 @@
-/*
- * ISDB-T driver for VA1J5JF8007/VA1J5JF8011
- *
- * Copyright (C) 2009 HIRANO Takahito <hiranotaka@zng.info>
- *
- * based on pt1dvr - http://pt1dvr.sourceforge.jp/
- *	by Tomoaki Ishikawa <tomy@users.sourceforge.jp>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- */
-
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/slab.h>
-#include <linux/i2c.h>
-#include <media/dvb_frontend.h>
-#include <media/dvb_math.h>
-#include "va1j5jf8007t.h"
-
-enum va1j5jf8007t_tune_state {
-	VA1J5JF8007T_IDLE,
-	VA1J5JF8007T_SET_FREQUENCY,
-	VA1J5JF8007T_CHECK_FREQUENCY,
-	VA1J5JF8007T_SET_MODULATION,
-	VA1J5JF8007T_CHECK_MODULATION,
-	VA1J5JF8007T_TRACK,
-	VA1J5JF8007T_ABORT,
-};
-
-struct va1j5jf8007t_state {
-	const struct va1j5jf8007t_config *config;
-	struct i2c_adapter *adap;
-	struct dvb_frontend fe;
-	enum va1j5jf8007t_tune_state tune_state;
-};
-
-static int va1j5jf8007t_read_snr(struct dvb_frontend *fe, u16 *snr)
-{
-	struct va1j5jf8007t_state *state;
-	u8 addr;
-	int i;
-	u8 write_buf[1], read_buf[1];
-	struct i2c_msg msgs[2];
-	s32 word, x, y;
-
-	state = fe->demodulator_priv;
-	addr = state->config->demod_address;
-
-	word = 0;
-	for (i = 0; i < 3; i++) {
-		write_buf[0] = 0x8b + i;
-
-		msgs[0].addr = addr;
-		msgs[0].flags = 0;
-		msgs[0].len = sizeof(write_buf);
-		msgs[0].buf = write_buf;
-
-		msgs[1].addr = addr;
-		msgs[1].flags = I2C_M_RD;
-		msgs[1].len = sizeof(read_buf);
-		msgs[1].buf = read_buf;
-
-		if (i2c_transfer(state->adap, msgs, 2) != 2)
-			return -EREMOTEIO;
-
-		word <<= 8;
-		word |= read_buf[0];
-	}
-
-	if (!word)
-		return -EIO;
-
-	x = 10 * (intlog10(0x540000 * 100 / word) - (2 << 24));
-	y = (24ll << 46) / 1000000;
-	y = ((s64)y * x >> 30) - (16ll << 40) / 10000;
-	y = ((s64)y * x >> 29) + (398ll << 35) / 10000;
-	y = ((s64)y * x >> 30) + (5491ll << 29) / 10000;
-	y = ((s64)y * x >> 30) + (30965ll << 23) / 10000;
-	*snr = y >> 15;
-	return 0;
-}
-
-static int va1j5jf8007t_get_frontend_algo(struct dvb_frontend *fe)
-{
-	return DVBFE_ALGO_HW;
-}
-
-static int
-va1j5jf8007t_read_status(struct dvb_frontend *fe, enum fe_status *status)
-{
-	struct va1j5jf8007t_state *state;
-
-	state = fe->demodulator_priv;
-
-	switch (state->tune_state) {
-	case VA1J5JF8007T_IDLE:
-	case VA1J5JF8007T_SET_FREQUENCY:
-	case VA1J5JF8007T_CHECK_FREQUENCY:
-		*status = 0;
-		return 0;
-
-
-	case VA1J5JF8007T_SET_MODULATION:
-	case VA1J5JF8007T_CHECK_MODULATION:
-	case VA1J5JF8007T_ABORT:
-		*status |= FE_HAS_SIGNAL;
-		return 0;
-
-	case VA1J5JF8007T_TRACK:
-		*status |= FE_HAS_SIGNAL | FE_HAS_CARRIER | FE_HAS_LOCK;
-		return 0;
-	}
-
-	BUG();
-}
-
-struct va1j5jf8007t_cb_map {
-	u32 frequency;
-	u8 cb;
-};
-
-static const struct va1j5jf8007t_cb_map va1j5jf8007t_cb_maps[] = {
-	{  90000000, 0x80 },
-	{ 140000000, 0x81 },
-	{ 170000000, 0xa1 },
-	{ 220000000, 0x62 },
-	{ 330000000, 0xa2 },
-	{ 402000000, 0xe2 },
-	{ 450000000, 0x64 },
-	{ 550000000, 0x84 },
-	{ 600000000, 0xa4 },
-	{ 700000000, 0xc4 },
-};
-
-static u8 va1j5jf8007t_lookup_cb(u32 frequency)
-{
-	int i;
-	const struct va1j5jf8007t_cb_map *map;
-
-	for (i = 0; i < ARRAY_SIZE(va1j5jf8007t_cb_maps); i++) {
-		map = &va1j5jf8007t_cb_maps[i];
-		if (frequency < map->frequency)
-			return map->cb;
-	}
-	return 0xe4;
-}
-
-static int va1j5jf8007t_set_frequency(struct va1j5jf8007t_state *state)
-{
-	u32 frequency;
-	u16 word;
-	u8 buf[6];
-	struct i2c_msg msg;
-
-	frequency = state->fe.dtv_property_cache.frequency;
-
-	word = (frequency + 71428) / 142857 + 399;
-	buf[0] = 0xfe;
-	buf[1] = 0xc2;
-	buf[2] = word >> 8;
-	buf[3] = word;
-	buf[4] = 0x80;
-	buf[5] = va1j5jf8007t_lookup_cb(frequency);
-
-	msg.addr = state->config->demod_address;
-	msg.flags = 0;
-	msg.len = sizeof(buf);
-	msg.buf = buf;
-
-	if (i2c_transfer(state->adap, &msg, 1) != 1)
-		return -EREMOTEIO;
-
-	return 0;
-}
-
-static int
-va1j5jf8007t_check_frequency(struct va1j5jf8007t_state *state, int *lock)
-{
-	u8 addr;
-	u8 write_buf[2], read_buf[1];
-	struct i2c_msg msgs[2];
-
-	addr = state->config->demod_address;
-
-	write_buf[0] = 0xfe;
-	write_buf[1] = 0xc3;
-
-	msgs[0].addr = addr;
-	msgs[0].flags = 0;
-	msgs[0].len = sizeof(write_buf);
-	msgs[0].buf = write_buf;
-
-	msgs[1].addr = addr;
-	msgs[1].flags = I2C_M_RD;
-	msgs[1].len = sizeof(read_buf);
-	msgs[1].buf = read_buf;
-
-	if (i2c_transfer(state->adap, msgs, 2) != 2)
-		return -EREMOTEIO;
-
-	*lock = read_buf[0] & 0x40;
-	return 0;
-}
-
-static int va1j5jf8007t_set_modulation(struct va1j5jf8007t_state *state)
-{
-	u8 buf[2];
-	struct i2c_msg msg;
-
-	buf[0] = 0x01;
-	buf[1] = 0x40;
-
-	msg.addr = state->config->demod_address;
-	msg.flags = 0;
-	msg.len = sizeof(buf);
-	msg.buf = buf;
-
-	if (i2c_transfer(state->adap, &msg, 1) != 1)
-		return -EREMOTEIO;
-
-	return 0;
-}
-
-static int va1j5jf8007t_check_modulation(struct va1j5jf8007t_state *state,
-					 int *lock, int *retry)
-{
-	u8 addr;
-	u8 write_buf[1], read_buf[1];
-	struct i2c_msg msgs[2];
-
-	addr = state->config->demod_address;
-
-	write_buf[0] = 0x80;
-
-	msgs[0].addr = addr;
-	msgs[0].flags = 0;
-	msgs[0].len = sizeof(write_buf);
-	msgs[0].buf = write_buf;
-
-	msgs[1].addr = addr;
-	msgs[1].flags = I2C_M_RD;
-	msgs[1].len = sizeof(read_buf);
-	msgs[1].buf = read_buf;
-
-	if (i2c_transfer(state->adap, msgs, 2) != 2)
-		return -EREMOTEIO;
-
-	*lock = !(read_buf[0] & 0x10);
-	*retry = read_buf[0] & 0x80;
-	return 0;
-}
-
-static int
-va1j5jf8007t_tune(struct dvb_frontend *fe,
-		  bool re_tune,
-		  unsigned int mode_flags,  unsigned int *delay,
-		  enum fe_status *status)
-{
-	struct va1j5jf8007t_state *state;
-	int ret;
-	int lock = 0, retry = 0;
-
-	state = fe->demodulator_priv;
-
-	if (re_tune)
-		state->tune_state = VA1J5JF8007T_SET_FREQUENCY;
-
-	switch (state->tune_state) {
-	case VA1J5JF8007T_IDLE:
-		*delay = 3 * HZ;
-		*status = 0;
-		return 0;
-
-	case VA1J5JF8007T_SET_FREQUENCY:
-		ret = va1j5jf8007t_set_frequency(state);
-		if (ret < 0)
-			return ret;
-
-		state->tune_state = VA1J5JF8007T_CHECK_FREQUENCY;
-		*delay = 0;
-		*status = 0;
-		return 0;
-
-	case VA1J5JF8007T_CHECK_FREQUENCY:
-		ret = va1j5jf8007t_check_frequency(state, &lock);
-		if (ret < 0)
-			return ret;
-
-		if (!lock)  {
-			*delay = (HZ + 999) / 1000;
-			*status = 0;
-			return 0;
-		}
-
-		state->tune_state = VA1J5JF8007T_SET_MODULATION;
-		*delay = 0;
-		*status = FE_HAS_SIGNAL;
-		return 0;
-
-	case VA1J5JF8007T_SET_MODULATION:
-		ret = va1j5jf8007t_set_modulation(state);
-		if (ret < 0)
-			return ret;
-
-		state->tune_state = VA1J5JF8007T_CHECK_MODULATION;
-		*delay = 0;
-		*status = FE_HAS_SIGNAL;
-		return 0;
-
-	case VA1J5JF8007T_CHECK_MODULATION:
-		ret = va1j5jf8007t_check_modulation(state, &lock, &retry);
-		if (ret < 0)
-			return ret;
-
-		if (!lock)  {
-			if (!retry)  {
-				state->tune_state = VA1J5JF8007T_ABORT;
-				*delay = 3 * HZ;
-				*status = FE_HAS_SIGNAL;
-				return 0;
-			}
-			*delay = (HZ + 999) / 1000;
-			*status = FE_HAS_SIGNAL;
-			return 0;
-		}
-
-		state->tune_state = VA1J5JF8007T_TRACK;
-		/* fall through */
-
-	case VA1J5JF8007T_TRACK:
-		*delay = 3 * HZ;
-		*status = FE_HAS_SIGNAL | FE_HAS_CARRIER | FE_HAS_LOCK;
-		return 0;
-
-	case VA1J5JF8007T_ABORT:
-		*delay = 3 * HZ;
-		*status = FE_HAS_SIGNAL;
-		return 0;
-	}
-
-	BUG();
-}
-
-static int va1j5jf8007t_init_frequency(struct va1j5jf8007t_state *state)
-{
-	u8 buf[7];
-	struct i2c_msg msg;
-
-	buf[0] = 0xfe;
-	buf[1] = 0xc2;
-	buf[2] = 0x01;
-	buf[3] = 0x8f;
-	buf[4] = 0xc1;
-	buf[5] = 0x80;
-	buf[6] = 0x80;
-
-	msg.addr = state->config->demod_address;
-	msg.flags = 0;
-	msg.len = sizeof(buf);
-	msg.buf = buf;
-
-	if (i2c_transfer(state->adap, &msg, 1) != 1)
-		return -EREMOTEIO;
-
-	return 0;
-}
-
-static int va1j5jf8007t_set_sleep(struct va1j5jf8007t_state *state, int sleep)
-{
-	u8 buf[2];
-	struct i2c_msg msg;
-
-	buf[0] = 0x03;
-	buf[1] = sleep ? 0x90 : 0x80;
-
-	msg.addr = state->config->demod_address;
-	msg.flags = 0;
-	msg.len = sizeof(buf);
-	msg.buf = buf;
-
-	if (i2c_transfer(state->adap, &msg, 1) != 1)
-		return -EREMOTEIO;
-
-	return 0;
-}
-
-static int va1j5jf8007t_sleep(struct dvb_frontend *fe)
-{
-	struct va1j5jf8007t_state *state;
-	int ret;
-
-	state = fe->demodulator_priv;
-
-	ret = va1j5jf8007t_init_frequency(state);
-	if (ret < 0)
-		return ret;
-
-	return va1j5jf8007t_set_sleep(state, 1);
-}
-
-static int va1j5jf8007t_init(struct dvb_frontend *fe)
-{
-	struct va1j5jf8007t_state *state;
-
-	state = fe->demodulator_priv;
-	state->tune_state = VA1J5JF8007T_IDLE;
-
-	return va1j5jf8007t_set_sleep(state, 0);
-}
-
-static void va1j5jf8007t_release(struct dvb_frontend *fe)
-{
-	struct va1j5jf8007t_state *state;
-	state = fe->demodulator_priv;
-	kfree(state);
-}
-
-static const struct dvb_frontend_ops va1j5jf8007t_ops = {
-	.delsys = { SYS_ISDBT },
-	.info = {
-		.name = "VA1J5JF8007/VA1J5JF8011 ISDB-T",
-		.frequency_min = 90000000,
-		.frequency_max = 770000000,
-		.frequency_stepsize = 142857,
-		.caps = FE_CAN_INVERSION_AUTO | FE_CAN_FEC_AUTO |
-			FE_CAN_QAM_AUTO | FE_CAN_TRANSMISSION_MODE_AUTO |
-			FE_CAN_GUARD_INTERVAL_AUTO | FE_CAN_HIERARCHY_AUTO,
-	},
-
-	.read_snr = va1j5jf8007t_read_snr,
-	.get_frontend_algo = va1j5jf8007t_get_frontend_algo,
-	.read_status = va1j5jf8007t_read_status,
-	.tune = va1j5jf8007t_tune,
-	.sleep = va1j5jf8007t_sleep,
-	.init = va1j5jf8007t_init,
-	.release = va1j5jf8007t_release,
-};
-
-static const u8 va1j5jf8007t_20mhz_prepare_bufs[][2] = {
-	{0x03, 0x90}, {0x14, 0x8f}, {0x1c, 0x2a}, {0x1d, 0xa8}, {0x1e, 0xa2},
-	{0x22, 0x83}, {0x31, 0x0d}, {0x32, 0xe0}, {0x39, 0xd3}, {0x3a, 0x00},
-	{0x5c, 0x40}, {0x5f, 0x80}, {0x75, 0x02}, {0x76, 0x4e}, {0x77, 0x03},
-	{0xef, 0x01}
-};
-
-static const u8 va1j5jf8007t_25mhz_prepare_bufs[][2] = {
-	{0x03, 0x90}, {0x1c, 0x2a}, {0x1d, 0xa8}, {0x1e, 0xa2}, {0x22, 0x83},
-	{0x3a, 0x00}, {0x5c, 0x40}, {0x5f, 0x80}, {0x75, 0x0a}, {0x76, 0x4c},
-	{0x77, 0x03}, {0xef, 0x01}
-};
-
-int va1j5jf8007t_prepare(struct dvb_frontend *fe)
-{
-	struct va1j5jf8007t_state *state;
-	const u8 (*bufs)[2];
-	int size;
-	u8 buf[2];
-	struct i2c_msg msg;
-	int i;
-
-	state = fe->demodulator_priv;
-
-	switch (state->config->frequency) {
-	case VA1J5JF8007T_20MHZ:
-		bufs = va1j5jf8007t_20mhz_prepare_bufs;
-		size = ARRAY_SIZE(va1j5jf8007t_20mhz_prepare_bufs);
-		break;
-	case VA1J5JF8007T_25MHZ:
-		bufs = va1j5jf8007t_25mhz_prepare_bufs;
-		size = ARRAY_SIZE(va1j5jf8007t_25mhz_prepare_bufs);
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	msg.addr = state->config->demod_address;
-	msg.flags = 0;
-	msg.len = sizeof(buf);
-	msg.buf = buf;
-
-	for (i = 0; i < size; i++) {
-		memcpy(buf, bufs[i], sizeof(buf));
-		if (i2c_transfer(state->adap, &msg, 1) != 1)
-			return -EREMOTEIO;
-	}
-
-	return va1j5jf8007t_init_frequency(state);
-}
-
-struct dvb_frontend *
-va1j5jf8007t_attach(const struct va1j5jf8007t_config *config,
-		    struct i2c_adapter *adap)
-{
-	struct va1j5jf8007t_state *state;
-	struct dvb_frontend *fe;
-	u8 buf[2];
-	struct i2c_msg msg;
-
-	state = kzalloc(sizeof(struct va1j5jf8007t_state), GFP_KERNEL);
-	if (!state)
-		return NULL;
-
-	state->config = config;
-	state->adap = adap;
-
-	fe = &state->fe;
-	memcpy(&fe->ops, &va1j5jf8007t_ops, sizeof(struct dvb_frontend_ops));
-	fe->demodulator_priv = state;
-
-	buf[0] = 0x01;
-	buf[1] = 0x80;
-
-	msg.addr = state->config->demod_address;
-	msg.flags = 0;
-	msg.len = sizeof(buf);
-	msg.buf = buf;
-
-	if (i2c_transfer(state->adap, &msg, 1) != 1) {
-		kfree(state);
-		return NULL;
-	}
-
-	return fe;
-}
diff --git a/drivers/media/pci/pt1/va1j5jf8007t.h b/drivers/media/pci/pt1/va1j5jf8007t.h
deleted file mode 100644
index 95eb7d294d2..00000000000
--- a/drivers/media/pci/pt1/va1j5jf8007t.h
+++ /dev/null
@@ -1,42 +0,0 @@
-/*
- * ISDB-T driver for VA1J5JF8007/VA1J5JF8011
- *
- * Copyright (C) 2009 HIRANO Takahito <hiranotaka@zng.info>
- *
- * based on pt1dvr - http://pt1dvr.sourceforge.jp/
- *	by Tomoaki Ishikawa <tomy@users.sourceforge.jp>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- */
-
-#ifndef VA1J5JF8007T_H
-#define VA1J5JF8007T_H
-
-enum va1j5jf8007t_frequency {
-	VA1J5JF8007T_20MHZ,
-	VA1J5JF8007T_25MHZ,
-};
-
-struct va1j5jf8007t_config {
-	u8 demod_address;
-	enum va1j5jf8007t_frequency frequency;
-};
-
-struct i2c_adapter;
-
-struct dvb_frontend *
-va1j5jf8007t_attach(const struct va1j5jf8007t_config *config,
-		    struct i2c_adapter *adap);
-
-/* must be called after va1j5jf8007s_attach */
-int va1j5jf8007t_prepare(struct dvb_frontend *fe);
-
-#endif
-- 
2.17.0
