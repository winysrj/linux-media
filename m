Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f179.google.com ([209.85.192.179]:59294 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754548AbbAPLbn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Jan 2015 06:31:43 -0500
Received: by mail-pd0-f179.google.com with SMTP id v10so4099767pde.10
        for <linux-media@vger.kernel.org>; Fri, 16 Jan 2015 03:31:43 -0800 (PST)
From: tskd08@gmail.com
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, Akihiro Tsukada <tskd08@gmail.com>
Subject: [PATCH v2 1/2] dvb: tua6034: add a new driver for Infineon tua6034 tuner
Date: Fri, 16 Jan 2015 20:31:29 +0900
Message-Id: <1421407890-9381-2-git-send-email-tskd08@gmail.com>
In-Reply-To: <1421407890-9381-1-git-send-email-tskd08@gmail.com>
References: <1421407890-9381-1-git-send-email-tskd08@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Akihiro Tsukada <tskd08@gmail.com>

this 3-band tuner is used in Friio (dvb-usb-friio),
and it was buried in friio-fe.c.

Signed-off-by: Akihiro Tsukada <tskd08@gmail.com>
---
 drivers/media/tuners/Kconfig   |   7 +
 drivers/media/tuners/Makefile  |   1 +
 drivers/media/tuners/tua6034.c | 464 +++++++++++++++++++++++++++++++++++++++++
 drivers/media/tuners/tua6034.h | 113 ++++++++++
 4 files changed, 585 insertions(+)
 create mode 100644 drivers/media/tuners/tua6034.c
 create mode 100644 drivers/media/tuners/tua6034.h

diff --git a/drivers/media/tuners/Kconfig b/drivers/media/tuners/Kconfig
index 42e5a01..6c15d28 100644
--- a/drivers/media/tuners/Kconfig
+++ b/drivers/media/tuners/Kconfig
@@ -282,4 +282,11 @@ config MEDIA_TUNER_QM1D1C0042
 	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Sharp QM1D1C0042 trellis coded 8PSK tuner driver.
+
+config MEDIA_TUNER_TUA6034
+	tristate "Infineon TUA6034 tuner"
+	depends on MEDIA_SUPPORT && I2C
+	default m if !MEDIA_SUBDRV_AUTOSELECT
+	help
+	  Infineon TUA6034 3-band ditigal TV tuner driver.
 endmenu
diff --git a/drivers/media/tuners/Makefile b/drivers/media/tuners/Makefile
index da4fe6e..8c95c08 100644
--- a/drivers/media/tuners/Makefile
+++ b/drivers/media/tuners/Makefile
@@ -42,6 +42,7 @@ obj-$(CONFIG_MEDIA_TUNER_R820T) += r820t.o
 obj-$(CONFIG_MEDIA_TUNER_MXL301RF) += mxl301rf.o
 obj-$(CONFIG_MEDIA_TUNER_QM1D1C0042) += qm1d1c0042.o
 obj-$(CONFIG_MEDIA_TUNER_M88RS6000T) += m88rs6000t.o
+obj-$(CONFIG_MEDIA_TUNER_TUA6034) += tua6034.o
 
 ccflags-y += -I$(srctree)/drivers/media/dvb-core
 ccflags-y += -I$(srctree)/drivers/media/dvb-frontends
diff --git a/drivers/media/tuners/tua6034.c b/drivers/media/tuners/tua6034.c
new file mode 100644
index 0000000..7cbc185
--- /dev/null
+++ b/drivers/media/tuners/tua6034.c
@@ -0,0 +1,464 @@
+/*
+ * Infineon TUA6034 terrestial tuner driver
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
+#include <linux/kernel.h>
+#include "dvb_i2c.h"
+#include "tua6034.h"
+
+#define TUA6034_XTL_FREQ 4000000
+
+struct tua6034_state {
+	struct tua6034_config cfg;
+	struct i2c_client *i2c;
+
+	/* current parameters (except frequency divider) */
+	u8 ctrl_byte;
+	u8 band_sw_byte;
+	u8 aux_byte;
+};
+
+struct def_param {
+	/* for auto "band" selection */
+	u32 band_sw_freq[4]; /* fmin, flow_mid, fmid_high, fmax */
+
+	/* for auto "CP current" selection */
+	/* band:[low, mid, high] x cp:[50uA/125uA,125uA/250uA,250uA/650uA] */
+	u32 cp_sw_freq[3][3];
+	u32 if_freq;
+	u32 if_bw;
+	enum tua6034_ref_div ref_div;
+};
+
+/* per-DELSYS default configuration */
+static const struct def_param def_cfgs[] = {
+	/* ISDB-T */
+	{
+		.band_sw_freq = {90000000, 170000000, 470000000, 900000000},
+		.cp_sw_freq = {
+			{0, 0, 170000000},
+			{0, 270000000, 370000000},
+			{0, 0, 670000000}
+		},
+
+		.if_freq = 57000000,
+		.if_bw = 6000000,
+		.ref_div = TUA6034_REF_DIV_1_28,
+	},
+
+	/* DVB-T */
+	{
+		.band_sw_freq = {44250000, 157500000, 443000000, 900000000},
+		.cp_sw_freq = {
+			{0, 140500000, 157500000},
+			{0, 443000000, 0},
+			{0, 802000000, 900000000}
+		},
+
+		.if_freq = 36125000,
+		.if_bw = 8000000,
+		.ref_div = TUA6034_REF_DIV_1_24,
+	},
+
+	/* ATSC */
+	{
+		.band_sw_freq = {50000000, 160000000, 454000000, 900000000},
+		.cp_sw_freq = {
+			{0, 160000000, 0},
+			{0, 454000000, 0},
+			{0, 900000000, 0}
+		},
+
+		.if_freq = 44000000,
+		.if_bw = 6000000,
+		.ref_div = TUA6034_REF_DIV_1_64,
+	},
+};
+
+
+static int raw_write(struct tua6034_state *state, const u8 *buf, int len)
+{
+	int ret;
+
+	ret = i2c_master_send(state->i2c, buf, len);
+	if (ret >= 0 && ret < len)
+		ret = -EIO;
+	return (ret == len) ? 0 : ret;
+}
+
+static int raw_read(struct tua6034_state *state, u8 *val)
+{
+	int ret;
+
+	ret = i2c_master_recv(state->i2c, val, 1);
+	if (ret >= 0 && ret < 1)
+		ret = -EIO;
+	return (ret == 1) ? 0 : ret;
+}
+
+static int calc_ctrl_bytes(struct tua6034_state *state, u32 freq)
+{
+	enum tua6034_ref_div rdiv;
+	enum tua6034_band    band;
+	enum tua6034_cp_cur  cp_cur;
+	const struct def_param *def;
+	int i, j;
+
+	switch (state->cfg.cfg_mode) {
+	case TUA6034_CONFIG_DFLT_ISDBT:
+	case TUA6034_CONFIG_DFLT_DVBT:
+	case TUA6034_CONFIG_DFLT_ATSC:
+		/* user configured band,cp_cur. no auto selection */
+		if (state->cfg.band != TUA6034_BAND_ALL &&
+		    state->cfg.cp_cur != TUA6034_CP_DEF) {
+			band = state->cfg.band;
+			cp_cur = state->cfg.cp_cur;
+			break;
+		}
+
+		def = &def_cfgs[state->cfg.cfg_mode];
+		for (i = 0; i < ARRAY_SIZE(def->band_sw_freq); i++)
+			if (freq < def->band_sw_freq[i])
+				break;
+		if (i == 0 || i >= ARRAY_SIZE(def->band_sw_freq))
+			goto invalid_param;
+
+		band = (i == 1) ? TUA6034_BAND_LOW :
+			(i == 2) ? TUA6034_BAND_MID : TUA6034_BAND_HIGH;
+		if (state->cfg.band != TUA6034_BAND_ALL &&
+		    state->cfg.band != band)
+			goto invalid_param;
+
+		if (state->cfg.cp_cur != TUA6034_CP_DEF) {
+			cp_cur = state->cfg.cp_cur;
+			break;
+		}
+
+		for (j = 0; j < 3; j++)
+			if (freq < def->cp_sw_freq[i - 1][j])
+				break;
+		cp_cur = j + 1;
+		break;
+
+	case TUA6034_CONFIG_MANNUAL:
+		band =    state->cfg.band;
+		cp_cur =  state->cfg.cp_cur;
+		break;
+	default:
+		goto invalid_param;
+	}
+
+	rdiv = state->cfg.ref_div;
+	/* check constraints */
+	if ((rdiv == TUA6034_REF_DIV_1_80 || rdiv == TUA6034_REF_DIV_1_128) &&
+	    (cp_cur == TUA6034_CP_125uA || cp_cur == TUA6034_CP_650uA)) {
+		if (state->cfg.cfg_mode == TUA6034_CONFIG_MANNUAL)
+			goto invalid_param;
+		cp_cur = TUA6034_CP_250uA;
+	}
+
+	state->ctrl_byte = 0x80;
+	if (cp_cur == TUA6034_CP_250uA || cp_cur == TUA6034_CP_650uA)
+		state->ctrl_byte |= 0x40;
+
+	if (cp_cur == TUA6034_CP_125uA || cp_cur == TUA6034_CP_650uA ||
+	    rdiv == TUA6034_REF_DIV_1_32 || rdiv == TUA6034_REF_DIV_1_28)
+		state->ctrl_byte |= 0x30;
+
+	if (cp_cur == TUA6034_CP_125uA || cp_cur == TUA6034_CP_650uA)
+		state->ctrl_byte |= 0x08;
+	if (rdiv == TUA6034_REF_DIV_1_24 || rdiv == TUA6034_REF_DIV_1_64)
+		state->ctrl_byte |= 0x04;
+	if (rdiv == TUA6034_REF_DIV_1_128 ||
+	    rdiv == TUA6034_REF_DIV_1_64 || rdiv == TUA6034_REF_DIV_1_28)
+		state->ctrl_byte |= 0x02;
+
+	state->band_sw_byte = band & 0x03;
+
+	state->aux_byte = (state->cfg.agc_tc != TUA6034_AGC_TC_LONG) << 7;
+	state->aux_byte |= (state->cfg.agc_tkov - 1) << 4;
+
+	return 0;
+
+invalid_param:
+	dev_warn(&state->i2c->dev, "invalid tuning parameters.");
+	return -EINVAL;
+}
+
+/* tuner_ops */
+
+static int tua6034_set_config(struct dvb_frontend *fe, void *priv_cfg)
+{
+	struct tua6034_state *state;
+	struct tua6034_config *cfg;
+	const struct def_param *def = NULL;
+	u32 fmin, fmax;
+
+	state = fe->tuner_priv;
+	cfg = priv_cfg;
+
+	state->cfg.agc_tc = cfg->agc_tc;
+	if (cfg->agc_tkov == TUA6034_AGC_TKOV_DEF)
+		state->cfg.agc_tkov = TUA6034_AGC_112dBuV;
+	else
+		state->cfg.agc_tkov = cfg->agc_tkov;
+	state->cfg.ports = cfg->ports;
+
+	state->cfg.cfg_mode = cfg->cfg_mode;
+	switch (cfg->cfg_mode) {
+	case TUA6034_CONFIG_DFLT_ISDBT:
+	case TUA6034_CONFIG_DFLT_DVBT:
+	case TUA6034_CONFIG_DFLT_ATSC:
+		def = &def_cfgs[cfg->cfg_mode];
+
+		state->cfg.if_freq = (cfg->if_freq != 0) ?
+			cfg->if_freq : def->if_freq;
+
+		state->cfg.if_bw = (cfg->if_bw != 0) ?
+			cfg->if_bw : def->if_bw;
+
+		state->cfg.ref_div = (cfg->ref_div != 0) ?
+			cfg->ref_div : def->ref_div;
+		break;
+
+	case TUA6034_CONFIG_MANNUAL:
+		if (cfg->if_freq == 0 || cfg->if_bw == 0 ||
+		    cfg->ref_div == 0 || cfg->band == 0 ||
+		    cfg->band == TUA6034_BAND_ALL || cfg->cp_cur == 0)
+			return -EINVAL;
+		state->cfg.if_freq = cfg->if_freq;
+		state->cfg.if_bw = cfg->if_bw;
+		state->cfg.ref_div = cfg->ref_div;
+		break;
+
+	default:
+		return -EINVAL;
+	}
+	if ((state->cfg.ref_div == TUA6034_REF_DIV_1_80 ||
+	     state->cfg.ref_div == TUA6034_REF_DIV_1_128) &&
+	    (state->cfg.cp_cur == TUA6034_CP_125uA ||
+	     state->cfg.cp_cur == TUA6034_CP_650uA))
+		return -EINVAL;
+
+	if (cfg->band == TUA6034_BAND_NONE)
+		return -EINVAL;
+	state->cfg.band = cfg->band;
+
+	state->cfg.cp_cur = cfg->cp_cur;
+
+	fe->ops.tuner_ops.info.frequency_step =
+					TUA6034_XTL_FREQ / state->cfg.ref_div;
+	if (state->cfg.cfg_mode == TUA6034_CONFIG_MANNUAL) {
+		fmin =  44000000;
+		fmax = 863000000;
+	} else {
+		switch (state->cfg.band) {
+		case TUA6034_BAND_ALL:
+			fmin = def->band_sw_freq[0];
+			fmax = def->band_sw_freq[3];
+			break;
+		case TUA6034_BAND_HIGH:
+			fmin = def->band_sw_freq[2];
+			fmax = def->band_sw_freq[3];
+			break;
+		case TUA6034_BAND_LOW:
+			fmin = def->band_sw_freq[0];
+			fmax = def->band_sw_freq[1];
+			break;
+		case TUA6034_BAND_MID:
+			fmin = def->band_sw_freq[1];
+			fmax = def->band_sw_freq[2];
+			break;
+		default:
+			return -EINVAL;
+		}
+	}
+	fe->ops.tuner_ops.info.frequency_min = fmin;
+	fe->ops.tuner_ops.info.frequency_max = fmax;
+
+	return 0;
+}
+
+static int tua6034_get_if_freq(struct dvb_frontend *fe, u32 *freq)
+{
+	struct tua6034_state *state;
+
+	if (!freq)
+		return 0;
+
+	state = fe->tuner_priv;
+	*freq = state->cfg.if_freq;
+	return 0;
+}
+
+static int tua6034_get_bandwidth(struct dvb_frontend *fe, u32 *bw)
+{
+	struct tua6034_state *state;
+
+	if (!bw)
+		return 0;
+
+	state = fe->tuner_priv;
+	if (state->cfg.cfg_mode == TUA6034_CONFIG_DFLT_DVBT &&
+	    state->cfg.band == TUA6034_BAND_LOW)
+		*bw = 7000000;
+	else
+		*bw = state->cfg.if_bw;
+	return 0;
+}
+
+static int tua6034_set_params(struct dvb_frontend *fe)
+{
+	struct tua6034_state *state;
+	u8 cmd[4];
+	u32 freq;
+	u32 div;
+	int ret;
+
+	state = fe->tuner_priv;
+	freq = fe->dtv_property_cache.frequency + state->cfg.if_freq;
+	div = mult_frac(freq, state->cfg.ref_div, TUA6034_XTL_FREQ);
+	cmd[0] = (div >> 8) & 0x7f;
+	cmd[1] = div & 0xff;
+
+	ret = calc_ctrl_bytes(state, fe->dtv_property_cache.frequency);
+	if (ret < 0)
+		goto failed;
+	cmd[2] = state->ctrl_byte;
+	cmd[3] = state->band_sw_byte;
+	cmd[3] |= (state->cfg.ports << 2);
+	ret = raw_write(state, cmd, 4);
+	if (ret < 0)
+		goto failed;
+
+	usleep_range(50, 200);
+	cmd[2] = (state->ctrl_byte & 0xc7) | 0x18;
+	cmd[3] = state->aux_byte;
+	ret = raw_write(state, cmd, 4);
+	if (ret < 0)
+		goto failed;
+
+	return 0;
+
+failed:
+	dev_warn(&state->i2c->dev, "(%s) failed. [adap%d-fe%d]\n",
+		__func__, fe->dvb->num, fe->id);
+	return ret;
+}
+
+
+static int tua6034_sleep(struct dvb_frontend *fe)
+{
+	struct tua6034_state *state;
+	u8 cmd[2];
+	int ret;
+
+	state = fe->tuner_priv;
+	cmd[0] = state->ctrl_byte | 0x01;
+	/* set band_sw_byte to 0x03(BAND_NONE) to sleep */
+	cmd[1] = 0x03;
+	ret = raw_write(state, cmd, 2);
+	if (ret < 0)
+		dev_warn(&state->i2c->dev, "(%s) failed. [adap%d-fe%d]\n",
+			__func__, fe->dvb->num, fe->id);
+	return 0;
+}
+
+
+static int tua6034_init(struct dvb_frontend *fe)
+{
+	struct tua6034_state *state;
+	u8 rbuf;
+	int i, ret;
+
+	state = fe->tuner_priv;
+
+	/* wait for POR bit to be cleared */
+	for (i = 5; i > 0; i--) {
+		ret = raw_read(state, &rbuf);
+		if (ret < 0 || !(rbuf & 0x80))
+			break;
+		if (i == 1)
+			ret = -ENODEV;
+		else
+			msleep(100);
+	}
+	if (ret < 0) {
+		dev_warn(&state->i2c->dev, "(%s) failed. [adap%d-fe%d]\n",
+			 __func__, fe->dvb->num, fe->id);
+		return ret;
+	}
+	return 0;
+}
+
+/* I2C driver functions */
+
+static const struct dvb_tuner_ops tua6034_ops = {
+	.info = {
+		.name = "Infineon TUA6034",
+		/* .frequency_{min,max} are set by set_config() */
+	},
+
+	.init = tua6034_init,
+	.sleep = tua6034_sleep,
+
+	.set_params = tua6034_set_params,
+	.set_config = tua6034_set_config,
+	.get_bandwidth = tua6034_get_bandwidth,
+	.get_if_frequency = tua6034_get_if_freq,
+
+};
+
+
+static int tua6034_probe(struct i2c_client *client,
+			 const struct i2c_device_id *id)
+{
+	struct tua6034_state *state;
+	struct dvb_i2c_tuner_config *cfg;
+	struct dvb_frontend *fe;
+	int ret;
+
+
+	cfg = client->dev.platform_data;
+	fe = cfg->fe;
+	state = fe->tuner_priv;
+	state->i2c = client;
+
+	ret = tua6034_set_config(fe, (void *) cfg->devcfg.priv_cfg);
+	if (ret < 0)
+		return ret;
+
+	dev_info(&client->dev, "Infineon TUA6034 attached.\n");
+	return 0;
+}
+
+static const struct i2c_device_id tua6034_id[] = {
+	{"tua6034", 0},
+	{}
+};
+
+static const struct dvb_i2c_module_param tua6034_param = {
+	.ops.tuner_ops = &tua6034_ops,
+	.priv_probe = tua6034_probe,
+
+	.priv_size = sizeof(struct tua6034_state),
+	.is_tuner = true,
+};
+
+DEFINE_DVB_I2C_MODULE(tua6034, tua6034_id, tua6034_param);
+
+MODULE_DESCRIPTION("Infineon TUA6034 terrestial tuner");
+MODULE_AUTHOR("Akihiro TSUKADA");
+MODULE_LICENSE("GPL");
diff --git a/drivers/media/tuners/tua6034.h b/drivers/media/tuners/tua6034.h
new file mode 100644
index 0000000..ed58c22
--- /dev/null
+++ b/drivers/media/tuners/tua6034.h
@@ -0,0 +1,113 @@
+/*
+ * Infineon TUA6034 terrestial tuner driver
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
+#ifndef TUA6034_H
+#define TUA6034_H
+
+#include "dvb_frontend.h"
+
+/* AGC timeconstant (and current) */
+enum tua6034_agc_timeconst {
+	TUA6034_AGC_TC_LONG,     /* 2sec, 300nA with 160nF on AGC pin */
+	TUA6034_AGC_TC_SHORT,    /* 50msec, 9uA with 160nF on AGC pin */
+
+	TUA6034_AGC_TC_DEF = 0,  /* long */
+};
+
+/* AGC takeover point */
+enum tua6034_agc_takeover {
+	TUA6034_AGC_TKOV_DEF,	/* (112dBuV) */
+	TUA6034_AGC_118dBuV,
+	TUA6034_AGC_115dBuV,
+	TUA6034_AGC_112dBuV,
+	TUA6034_AGC_109dBuV,
+	TUA6034_AGC_106dBuV,
+	TUA6034_AGC_103dBuV,
+	TUA6034_AGC_HIGHZ,		/* use external AGC */
+	TUA6034_AGC_DISABLED,
+};
+
+/* use per delivery system default for config parameters */
+enum tua6034_config_def {
+	/* use default config parameters for ISDB-T */
+	TUA6034_CONFIG_DFLT_ISDBT,
+
+	/* use default config parameters for DVB-T */
+	TUA6034_CONFIG_DFLT_DVBT,
+
+	/* use default config parameters for ATSC */
+	TUA6034_CONFIG_DFLT_ATSC,
+
+	/* do not use delsys specific defaults */
+	TUA6034_CONFIG_MANNUAL,
+
+	TUA6034_CONFIG_DFLT_DEF = 0,	/* ISDB-T */
+};
+
+/* reference frequency divider */
+enum tua6034_ref_div {
+	TUA6034_REF_DIV_DEF,		/* 142.86kHz */
+	/* in normal mode only */
+	TUA6034_REF_DIV_1_80 = 80,	/* 50kHz @ 4MHz XSTL */
+	TUA6034_REF_DIV_1_128 = 128,	/* 31.25kHz */
+	/* in both modes OK */
+	TUA6034_REF_DIV_1_24 = 24,	/* 166.67kHz */
+	TUA6034_REF_DIV_1_64 = 64,	/* 62.5kHz */
+	/* in extended mode only */
+	TUA6034_REF_DIV_1_32 = 32,	/* 125kHz */
+	TUA6034_REF_DIV_1_28 = 28,	/* 142.86kHz */
+};
+
+enum tua6034_band {
+	TUA6034_BAND_HIGH,
+	TUA6034_BAND_LOW,
+	TUA6034_BAND_MID,
+	TUA6034_BAND_NONE,		/* stand-by mode */
+	/* all bands supported, and auto-selected by frequency */
+	TUA6034_BAND_ALL,
+
+	TUA6034_BAND_DEF = 0,	/* band HIGH */
+};
+
+/* charge pump current */
+enum tua6034_cp_cur {
+	TUA6034_CP_DEF,		/* 250uA */
+	TUA6034_CP_50uA,
+	TUA6034_CP_125uA,		/* extended mode only */
+	TUA6034_CP_250uA,
+	TUA6034_CP_650uA,		/* extended mode only */
+};
+
+
+/* any member can be set to 0, to use the default value */
+struct tua6034_config {
+	enum tua6034_agc_timeconst agc_tc;
+	enum tua6034_agc_takeover  agc_tkov;
+#define TUA6034_PORT3_ON 0x01
+#define TUA6034_PORT4_ON 0x02
+	u8 ports;
+
+	enum tua6034_config_def cfg_mode;
+
+	/* the following params have default values from cfg_mode */
+	u32 if_freq;
+	u32 if_bw;
+	enum tua6034_ref_div ref_div;
+	enum tua6034_band band;
+	enum tua6034_cp_cur cp_cur;
+};
+
+#endif /* TUA6034_H */
-- 
2.2.2

