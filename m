Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:55859 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934997AbaH0PcK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Aug 2014 11:32:10 -0400
Received: by mail-pa0-f53.google.com with SMTP id rd3so477952pab.40
        for <linux-media@vger.kernel.org>; Wed, 27 Aug 2014 08:32:08 -0700 (PDT)
From: tskd08@gmail.com
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com
Subject: [PATCH v2 3/5] qm1d1c0042: add driver for Sharp QM1D1C0042 ISDB-S tuner
Date: Thu, 28 Aug 2014 00:29:14 +0900
Message-Id: <1409153356-1887-4-git-send-email-tskd08@gmail.com>
In-Reply-To: <1409153356-1887-1-git-send-email-tskd08@gmail.com>
References: <1409153356-1887-1-git-send-email-tskd08@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Akihiro Tsukada <tskd08@gmail.com>

This patch adds driver for qm1d1c0042 tuner chips.
It is used as an ISDB-S tuner in earthsoft pt3 cards.

Signed-off-by: Akihiro Tsukada <tskd08@gmail.com>
---
Changes in v2:
- moved a static const table out of function scope
- removed an unused config parameter
- improvement in _init() to support suspend/resume

 drivers/media/tuners/Kconfig      |   7 +
 drivers/media/tuners/Makefile     |   1 +
 drivers/media/tuners/qm1d1c0042.c | 422 ++++++++++++++++++++++++++++++++++++++
 drivers/media/tuners/qm1d1c0042.h |  50 +++++
 4 files changed, 480 insertions(+)

diff --git a/drivers/media/tuners/Kconfig b/drivers/media/tuners/Kconfig
index cd3f8ee..8125d1d 100644
--- a/drivers/media/tuners/Kconfig
+++ b/drivers/media/tuners/Kconfig
@@ -264,4 +264,11 @@ config MEDIA_TUNER_MXL301RF
 	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  MaxLinear MxL301RF OFDM tuner driver.
+
+config MEDIA_TUNER_QM1D1C0042
+	tristate "Sharp QM1D1C0042 tuner"
+	depends on MEDIA_SUPPORT && I2C
+	default m if !MEDIA_SUBDRV_AUTOSELECT
+	help
+	  Sharp QM1D1C0042 trellis coded 8PSK tuner driver.
 endmenu
diff --git a/drivers/media/tuners/Makefile b/drivers/media/tuners/Makefile
index 6d5bf48..04d5efc 100644
--- a/drivers/media/tuners/Makefile
+++ b/drivers/media/tuners/Makefile
@@ -40,6 +40,7 @@ obj-$(CONFIG_MEDIA_TUNER_FC0013) += fc0013.o
 obj-$(CONFIG_MEDIA_TUNER_IT913X) += tuner_it913x.o
 obj-$(CONFIG_MEDIA_TUNER_R820T) += r820t.o
 obj-$(CONFIG_MEDIA_TUNER_MXL301RF) += mxl301rf.o
+obj-$(CONFIG_MEDIA_TUNER_QM1D1C0042) += qm1d1c0042.o
 
 ccflags-y += -I$(srctree)/drivers/media/dvb-core
 ccflags-y += -I$(srctree)/drivers/media/dvb-frontends
diff --git a/drivers/media/tuners/qm1d1c0042.c b/drivers/media/tuners/qm1d1c0042.c
new file mode 100644
index 0000000..ea6c245
--- /dev/null
+++ b/drivers/media/tuners/qm1d1c0042.c
@@ -0,0 +1,422 @@
+/*
+ * Sharp QM1D1C0042 8PSK tuner driver
+ *
+ * Copyright (C) 2014 Akihiro Tsukada <tskd08@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include "qm1d1c0042.h"
+
+#define QM1D1C0042_NUM_REGS 0x20
+
+static const u8 reg_initval[QM1D1C0042_NUM_REGS] = {
+	0x48, 0x1c, 0xa0, 0x10, 0xbc, 0xc5, 0x20, 0x33,
+	0x06, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00,
+	0x00, 0xff, 0xf3, 0x00, 0x2a, 0x64, 0xa6, 0x86,
+	0x8c, 0xcf, 0xb8, 0xf1, 0xa8, 0xf2, 0x89, 0x00
+};
+
+static const struct qm1d1c0042_config default_cfg = {
+	.init_freq = 0,
+	.xtal_freq = 16000,
+	.lpf = 1,
+	.fast_srch = 0,
+	.lpf_wait = 20,
+	.fast_srch_wait = 4,
+	.normal_srch_wait = 15,
+};
+
+struct qm1d1c0042_state {
+	struct qm1d1c0042_config cfg;
+	struct i2c_adapter *i2c;
+	struct dvb_frontend *fe;
+	u8 regs[QM1D1C0042_NUM_REGS];
+};
+
+static int reg_write(struct qm1d1c0042_state *state, u8 reg, u8 val)
+{
+	u8 wbuf[2] = { reg, val };
+	struct i2c_msg msg = {
+		.addr = state->cfg.addr,
+		.flags = 0,
+		.buf = wbuf,
+		.len = 2,
+	};
+	return i2c_transfer(state->i2c, &msg, 1);
+}
+
+
+static int reg_read(struct qm1d1c0042_state *state, u8 reg, u8 *val)
+{
+	struct i2c_msg msgs[2] = {
+		{
+			.addr = state->cfg.addr,
+			.flags = 0,
+			.buf = &reg,
+			.len = 1,
+		},
+		{
+			.addr = state->cfg.addr,
+			.flags = I2C_M_RD,
+			.buf = val,
+			.len = 1,
+		},
+	};
+
+	return i2c_transfer(state->i2c, msgs, ARRAY_SIZE(msgs));
+}
+
+static int qm1d1c0042_set_srch_mode(struct qm1d1c0042_state *state, bool fast)
+{
+	if (fast)
+		state->regs[0x03] |= 0x01; /* set fast search mode */
+	else
+		state->regs[0x03] &= ~0x01 & 0xff;
+
+	return reg_write(state, 0x03, state->regs[0x03]);
+}
+
+static int qm1d1c0042_wakeup(struct qm1d1c0042_state *state)
+{
+	int ret;
+
+	state->regs[0x01] |= 1 << 3;             /* BB_Reg_enable */
+	state->regs[0x01] &= (~(1 << 0)) & 0xff; /* NORMAL (wake-up) */
+	state->regs[0x05] &= (~(1 << 3)) & 0xff; /* pfd_rst NORMAL */
+	ret = reg_write(state, 0x01, state->regs[0x01]);
+	if (ret == 0)
+		ret = reg_write(state, 0x05, state->regs[0x05]);
+
+	if (ret < 0)
+		dev_warn(&state->i2c->dev, "(%s) failed. [adap%d-fe%d]\n",
+			__func__, state->fe->dvb->num, state->fe->id);
+	return ret;
+}
+
+/* tuner_ops */
+
+static int qm1d1c0042_set_config(struct dvb_frontend *fe, void *priv_cfg)
+{
+	struct qm1d1c0042_state *state;
+	struct qm1d1c0042_config *cfg;
+
+	state = fe->tuner_priv;
+	cfg = priv_cfg;
+
+	state->cfg.init_freq = cfg->init_freq;
+	if (cfg->xtal_freq != QM1D1C0042_CFG_XTAL_DFLT)
+		dev_warn(&state->i2c->dev,
+			"(%s) changing xtal_freq not supported. "
+			"[adap%d-fe%d]\n", __func__, fe->dvb->num, fe->id);
+	state->cfg.lpf = cfg->lpf;
+	state->cfg.fast_srch = cfg->fast_srch;
+	if (cfg->lpf_wait != QM1D1C0042_CFG_WAIT_DFLT)
+		state->cfg.lpf_wait = cfg->lpf_wait;
+	else
+		state->cfg.lpf_wait = default_cfg.lpf_wait;
+	if (cfg->fast_srch_wait != QM1D1C0042_CFG_WAIT_DFLT)
+		state->cfg.fast_srch_wait = cfg->fast_srch_wait;
+	else
+		state->cfg.fast_srch_wait = default_cfg.fast_srch_wait;
+	if (cfg->normal_srch_wait != QM1D1C0042_CFG_WAIT_DFLT)
+		state->cfg.normal_srch_wait = cfg->normal_srch_wait;
+	else
+		state->cfg.normal_srch_wait = default_cfg.normal_srch_wait;
+	return 0;
+}
+
+/* divisor, vco_band parameters */
+/*  {maxfreq,  param1(band?), param2(div?) */
+static const u32 conv_table[9][3] = {
+	{ 2151000, 1, 7 },
+	{ 1950000, 1, 6 },
+	{ 1800000, 1, 5 },
+	{ 1600000, 1, 4 },
+	{ 1450000, 1, 3 },
+	{ 1250000, 1, 2 },
+	{ 1200000, 0, 7 },
+	{  975000, 0, 6 },
+	{  950000, 0, 0 }
+};
+
+static int qm1d1c0042_set_params(struct dvb_frontend *fe)
+{
+	struct qm1d1c0042_state *state;
+	u32 freq;
+	int i, ret;
+	u8 val, mask;
+	u32 a, sd;
+	s32 b;
+
+	state = fe->tuner_priv;
+	freq = fe->dtv_property_cache.frequency;
+
+	state->regs[0x08] &= 0xf0;
+	state->regs[0x08] |= 0x09;
+
+	state->regs[0x13] &= 0x9f;
+	state->regs[0x13] |= 0x20;
+
+	/* div2/vco_band */
+	val = state->regs[0x02] & 0x0f;
+	for (i = 0; i < 8; i++)
+		if (freq < conv_table[i][0] && freq >= conv_table[i + 1][0]) {
+			val |= conv_table[i][1] << 7;
+			val |= conv_table[i][2] << 4;
+			break;
+		}
+	ret = reg_write(state, 0x02, val);
+	if (ret < 0)
+		return ret;
+
+	a = (freq + state->cfg.xtal_freq / 2) / state->cfg.xtal_freq;
+
+	state->regs[0x06] &= 0x40;
+	state->regs[0x06] |= (a - 12) / 4;
+	ret = reg_write(state, 0x06, state->regs[0x06]);
+	if (ret < 0)
+		return ret;
+
+	state->regs[0x07] &= 0xf0;
+	state->regs[0x07] |= (a - 4 * ((a - 12) / 4 + 1) - 5) & 0x0f;
+	ret = reg_write(state, 0x07, state->regs[0x07]);
+	if (ret < 0)
+		return ret;
+
+	/* LPF */
+	val = state->regs[0x08];
+	if (state->cfg.lpf) {
+		/* LPF_CLK, LPF_FC */
+		val &= 0xf0;
+		val |= 0x02;
+	}
+	ret = reg_write(state, 0x08, val);
+	if (ret < 0)
+		return ret;
+
+	/*
+	 * b = (freq / state->cfg.xtal_freq - a) << 20;
+	 * sd = b          (b >= 0)
+	 *      1<<22 + b  (b < 0)
+	 */
+	b = (((s64) freq) << 20) / state->cfg.xtal_freq - (((s64) a) << 20);
+	if (b >= 0)
+		sd = b;
+	else
+		sd = (1 << 22) + b;
+
+	state->regs[0x09] &= 0xc0;
+	state->regs[0x09] |= (sd >> 16) & 0x3f;
+	state->regs[0x0a] = (sd >> 8) & 0xff;
+	state->regs[0x0b] = sd & 0xff;
+	ret = reg_write(state, 0x09, state->regs[0x09]);
+	ret |= reg_write(state, 0x0a, state->regs[0x0a]);
+	ret |= reg_write(state, 0x0b, state->regs[0x0b]);
+	if (ret != 0)
+		return ret;
+
+	if (!state->cfg.lpf) {
+		/* CSEL_Offset */
+		ret = reg_write(state, 0x13, state->regs[0x13]);
+		if (ret < 0)
+			return ret;
+	}
+
+	/* VCO_TM, LPF_TM */
+	mask = state->cfg.lpf ? 0x3f : 0x7f;
+	val = state->regs[0x0c] & mask;
+	ret = reg_write(state, 0x0c, val);
+	if (ret < 0)
+		return ret;
+	usleep_range(2000, 3000);
+	val = state->regs[0x0c] | ~mask;
+	ret = reg_write(state, 0x0c, val);
+	if (ret < 0)
+		return ret;
+
+	if (state->cfg.lpf)
+		msleep(state->cfg.lpf_wait);
+	else if (state->regs[0x03] & 0x01)
+		msleep(state->cfg.fast_srch_wait);
+	else
+		msleep(state->cfg.normal_srch_wait);
+
+	if (state->cfg.lpf) {
+		/* LPF_FC */
+		ret = reg_write(state, 0x08, 0x09);
+		if (ret < 0)
+			return ret;
+
+		/* CSEL_Offset */
+		ret = reg_write(state, 0x13, state->regs[0x13]);
+		if (ret < 0)
+			return ret;
+	}
+	return 0;
+}
+
+static int qm1d1c0042_get_status(struct dvb_frontend *fe, u32 *status)
+{
+	struct qm1d1c0042_state *state;
+	int ret;
+
+	*status = 0;
+	state = fe->tuner_priv;
+	ret = reg_read(state, 0x0d, &state->regs[0x0d]);
+	if (ret == 0 && state->regs[0x0d] & 0x40)
+		*status = TUNER_STATUS_LOCKED;
+	return ret;
+}
+
+static int qm1d1c0042_sleep(struct dvb_frontend *fe)
+{
+	struct qm1d1c0042_state *state;
+	int ret;
+
+	state = fe->tuner_priv;
+	state->regs[0x01] &= (~(1 << 3)) & 0xff; /* BB_Reg_disable */
+	state->regs[0x01] |= 1 << 0;             /* STDBY */
+	state->regs[0x05] |= 1 << 3;             /* pfd_rst STANDBY */
+	ret = reg_write(state, 0x05, state->regs[0x05]);
+	if (ret == 0)
+		ret = reg_write(state, 0x01, state->regs[0x01]);
+	if (ret < 0)
+		dev_warn(&state->i2c->dev, "(%s) failed. [adap%d-fe%d]\n",
+			__func__, fe->dvb->num, fe->id);
+	return ret;
+}
+
+static int qm1d1c0042_init(struct dvb_frontend *fe)
+{
+	struct qm1d1c0042_state *state;
+	u8 val;
+	u8 i;
+	int ret;
+
+	state = fe->tuner_priv;
+	memcpy(state->regs, reg_initval, sizeof(reg_initval));
+
+	reg_write(state, 0x01, 0x0c);
+	reg_write(state, 0x01, 0x0c);
+
+	ret = reg_write(state, 0x01, 0x0c); /* soft reset on */
+	if (ret < 0)
+		goto failed;
+	usleep_range(2000, 3000);
+
+	val = state->regs[0x01] | 0x10;
+	ret = reg_write(state, 0x01, val); /* soft reset off */
+	if (ret < 0)
+		goto failed;
+
+	/* check ID */
+	ret = reg_read(state, 0x00, &val);
+	if (ret < 0 || val != 0x48)
+		goto failed;
+	usleep_range(2000, 3000);
+
+	state->regs[0x0c] |= 0x40;
+	ret = reg_write(state, 0x0c, state->regs[0x0c]);
+	if (ret < 0)
+		goto failed;
+	msleep(state->cfg.lpf_wait);
+
+	/* set all writable registers */
+	for (i = 1; i <= 0x0c ; i++) {
+		ret = reg_write(state, i, state->regs[i]);
+		if (ret < 0)
+			goto failed;
+	}
+	for (i = 0x11; i < QM1D1C0042_NUM_REGS; i++) {
+		ret = reg_write(state, i, state->regs[i]);
+		if (ret < 0)
+			goto failed;
+	}
+
+	ret = qm1d1c0042_wakeup(state);
+	if (ret < 0)
+		goto failed;
+
+	ret = qm1d1c0042_set_srch_mode(state, state->cfg.fast_srch);
+	if (ret < 0)
+		goto failed;
+
+	if (state->cfg.init_freq > 0) {
+		u32 f = fe->dtv_property_cache.frequency;
+
+		fe->dtv_property_cache.frequency = state->cfg.init_freq;
+		ret = qm1d1c0042_set_params(fe);
+		fe->dtv_property_cache.frequency = f;
+	}
+	return ret;
+
+failed:
+	dev_warn(&state->i2c->dev, "(%s) failed. [adap%d-fe%d]\n",
+		__func__, fe->dvb->num, fe->id);
+	return ret;
+}
+
+static int qm1d1c0042_release(struct dvb_frontend *fe)
+{
+	struct qm1d1c0042_state *state;
+
+	state = fe->tuner_priv;
+	kfree(state);
+	fe->tuner_priv = NULL;
+	return 0;
+}
+
+/* exported functions */
+
+static const struct dvb_tuner_ops qm1d1c0042_ops = {
+	.info = {
+		.name = "Sharp QM1D1C0042",
+
+		.frequency_min =  950000,
+		.frequency_max = 2150000,
+	},
+
+	.release = qm1d1c0042_release,
+	.init = qm1d1c0042_init,
+	.sleep = qm1d1c0042_sleep,
+	.set_config = qm1d1c0042_set_config,
+	.set_params = qm1d1c0042_set_params,
+	.get_status = qm1d1c0042_get_status,
+};
+
+
+struct dvb_frontend *qm1d1c0042_attach(struct dvb_frontend *fe,
+				       struct i2c_adapter *i2c,
+				       const struct qm1d1c0042_config *cfg)
+{
+	struct qm1d1c0042_state *state;
+
+	state = kzalloc(sizeof(*state), GFP_KERNEL);
+	if (!state)
+		return NULL;
+
+	state->fe = fe;
+	state->i2c = i2c;
+	memcpy(&state->cfg, &default_cfg, sizeof(default_cfg));
+	state->cfg.addr = cfg->addr;
+
+	memcpy(&fe->ops.tuner_ops, &qm1d1c0042_ops, sizeof(qm1d1c0042_ops));
+	fe->tuner_priv = state;
+	fe->ops.tuner_ops.set_config(fe, (void *)cfg);
+	dev_info(&i2c->dev, "Sharp QM1D1C0042 attached.\n");
+	return fe;
+}
+EXPORT_SYMBOL(qm1d1c0042_attach);
+
+MODULE_DESCRIPTION("Sharp QM1D1C0042 tuner");
+MODULE_AUTHOR("Akihiro TSUKADA");
+MODULE_LICENSE("GPL");
diff --git a/drivers/media/tuners/qm1d1c0042.h b/drivers/media/tuners/qm1d1c0042.h
new file mode 100644
index 0000000..5b76da8
--- /dev/null
+++ b/drivers/media/tuners/qm1d1c0042.h
@@ -0,0 +1,50 @@
+/*
+ * Sharp QM1D1C0042 8PSK tuner driver
+ *
+ * Copyright (C) 2014 Akihiro Tsukada <tskd08@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef QM1D1C0042_H
+#define QM1D1C0042_H
+
+#include <linux/kconfig.h>
+#include "dvb_frontend.h"
+
+
+struct qm1d1c0042_config {
+	u8   addr;
+	u32  init_freq;    /* initial frequency to be tuned. [kHz] */
+	u32  xtal_freq;    /* [kHz] */ /* currently ignored */
+	bool lpf;          /* enable LPF */
+	bool fast_srch;    /* enable fast search mode, no LPF */
+	u32  lpf_wait;         /* wait in tuning with LPF enabled. [ms] */
+	u32  fast_srch_wait;   /* with fast-search mode, no LPF. [ms] */
+	u32  normal_srch_wait; /* with no LPF/fast-search mode. [ms] */
+};
+/* special values indicating to use the default in qm1d1c0042_config */
+#define QM1D1C0042_CFG_XTAL_DFLT 0
+#define QM1D1C0042_CFG_WAIT_DFLT 0
+
+#if IS_ENABLED(CONFIG_MEDIA_TUNER_QM1D1C0042)
+extern struct dvb_frontend *qm1d1c0042_attach(struct dvb_frontend *fe,
+		struct i2c_adapter *i2c, const struct qm1d1c0042_config *cfg);
+#else
+static inline struct dvb_frontend *qm1d1c0042_attach(struct dvb_frontend *fe,
+		struct i2c_adapter *i2c, const struct qm1d1c0042_config *cfg)
+{
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
+	return NULL;
+}
+#endif
+
+#endif /* QM1D1C0042_H */
-- 
2.1.0

