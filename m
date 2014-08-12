Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49208 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755237AbaHLVub (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Aug 2014 17:50:31 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 09/10] [media] as102-fe: make it an independent driver
Date: Tue, 12 Aug 2014 18:50:23 -0300
Message-Id: <1407880224-374-10-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1407880224-374-1-git-send-email-m.chehab@samsung.com>
References: <1407880224-374-1-git-send-email-m.chehab@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Move as102-fe to dvb-frontends directory and make it an
independent driver.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/Kconfig          |   5 +
 drivers/media/dvb-frontends/Makefile         |   2 +-
 drivers/media/dvb-frontends/as102_fe.c       | 470 +++++++++++++++++++++++++++
 drivers/media/dvb-frontends/as102_fe.h       |  29 ++
 drivers/media/dvb-frontends/as102_fe_types.h | 188 +++++++++++
 drivers/media/usb/as102/Makefile             |   3 +-
 drivers/media/usb/as102/as102_fe.c           | 466 --------------------------
 drivers/media/usb/as102/as102_fe.h           |  29 --
 drivers/media/usb/as102/as10x_cmd.c          |   1 -
 drivers/media/usb/as102/as10x_cmd.h          |   2 +-
 drivers/media/usb/as102/as10x_cmd_cfg.c      |   1 -
 drivers/media/usb/as102/as10x_types.h        | 188 -----------
 12 files changed, 696 insertions(+), 688 deletions(-)
 create mode 100644 drivers/media/dvb-frontends/as102_fe.c
 create mode 100644 drivers/media/dvb-frontends/as102_fe.h
 create mode 100644 drivers/media/dvb-frontends/as102_fe_types.h
 delete mode 100644 drivers/media/usb/as102/as102_fe.c
 delete mode 100644 drivers/media/usb/as102/as102_fe.h
 delete mode 100644 drivers/media/usb/as102/as10x_types.h

diff --git a/drivers/media/dvb-frontends/Kconfig b/drivers/media/dvb-frontends/Kconfig
index fe0ddcca192c..aa5ae224626a 100644
--- a/drivers/media/dvb-frontends/Kconfig
+++ b/drivers/media/dvb-frontends/Kconfig
@@ -471,6 +471,11 @@ config DVB_SI2168
 	help
 	  Say Y when you want to support this frontend.
 
+config DVB_AS102_FE
+	tristate
+	depends on DVB_CORE
+	default DVB_AS102
+
 comment "DVB-C (cable) frontends"
 	depends on DVB_CORE
 
diff --git a/drivers/media/dvb-frontends/Makefile b/drivers/media/dvb-frontends/Makefile
index edf103d45920..fc4e689d4b67 100644
--- a/drivers/media/dvb-frontends/Makefile
+++ b/drivers/media/dvb-frontends/Makefile
@@ -113,4 +113,4 @@ obj-$(CONFIG_DVB_RTL2832) += rtl2832.o
 obj-$(CONFIG_DVB_RTL2832_SDR) += rtl2832_sdr.o
 obj-$(CONFIG_DVB_M88RS2000) += m88rs2000.o
 obj-$(CONFIG_DVB_AF9033) += af9033.o
-
+obj-$(CONFIG_DVB_AS102_FE) += as102_fe.o
diff --git a/drivers/media/dvb-frontends/as102_fe.c b/drivers/media/dvb-frontends/as102_fe.c
new file mode 100644
index 000000000000..b272e4ea1860
--- /dev/null
+++ b/drivers/media/dvb-frontends/as102_fe.c
@@ -0,0 +1,470 @@
+/*
+ * Abilis Systems Single DVB-T Receiver
+ * Copyright (C) 2008 Pierrick Hascoet <pierrick.hascoet@abilis.com>
+ * Copyright (C) 2010 Devin Heitmueller <dheitmueller@kernellabs.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2, or (at your option)
+ * any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <dvb_frontend.h>
+
+#include "as102_fe.h"
+
+struct as102_state {
+	struct dvb_frontend frontend;
+	struct as10x_demod_stats demod_stats;
+
+	const struct as102_fe_ops *ops;
+	void *priv;
+	uint8_t elna_cfg;
+
+	/* signal strength */
+	uint16_t signal_strength;
+	/* bit error rate */
+	uint32_t ber;
+};
+
+static uint8_t as102_fe_get_code_rate(fe_code_rate_t arg)
+{
+	uint8_t c;
+
+	switch (arg) {
+	case FEC_1_2:
+		c = CODE_RATE_1_2;
+		break;
+	case FEC_2_3:
+		c = CODE_RATE_2_3;
+		break;
+	case FEC_3_4:
+		c = CODE_RATE_3_4;
+		break;
+	case FEC_5_6:
+		c = CODE_RATE_5_6;
+		break;
+	case FEC_7_8:
+		c = CODE_RATE_7_8;
+		break;
+	default:
+		c = CODE_RATE_UNKNOWN;
+		break;
+	}
+
+	return c;
+}
+
+static int as102_fe_set_frontend(struct dvb_frontend *fe)
+{
+	struct as102_state *state = fe->demodulator_priv;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+	struct as10x_tune_args tune_args = { 0 };
+
+	/* set frequency */
+	tune_args.freq = c->frequency / 1000;
+
+	/* fix interleaving_mode */
+	tune_args.interleaving_mode = INTLV_NATIVE;
+
+	switch (c->bandwidth_hz) {
+	case 8000000:
+		tune_args.bandwidth = BW_8_MHZ;
+		break;
+	case 7000000:
+		tune_args.bandwidth = BW_7_MHZ;
+		break;
+	case 6000000:
+		tune_args.bandwidth = BW_6_MHZ;
+		break;
+	default:
+		tune_args.bandwidth = BW_8_MHZ;
+	}
+
+	switch (c->guard_interval) {
+	case GUARD_INTERVAL_1_32:
+		tune_args.guard_interval = GUARD_INT_1_32;
+		break;
+	case GUARD_INTERVAL_1_16:
+		tune_args.guard_interval = GUARD_INT_1_16;
+		break;
+	case GUARD_INTERVAL_1_8:
+		tune_args.guard_interval = GUARD_INT_1_8;
+		break;
+	case GUARD_INTERVAL_1_4:
+		tune_args.guard_interval = GUARD_INT_1_4;
+		break;
+	case GUARD_INTERVAL_AUTO:
+	default:
+		tune_args.guard_interval = GUARD_UNKNOWN;
+		break;
+	}
+
+	switch (c->modulation) {
+	case QPSK:
+		tune_args.modulation = CONST_QPSK;
+		break;
+	case QAM_16:
+		tune_args.modulation = CONST_QAM16;
+		break;
+	case QAM_64:
+		tune_args.modulation = CONST_QAM64;
+		break;
+	default:
+		tune_args.modulation = CONST_UNKNOWN;
+		break;
+	}
+
+	switch (c->transmission_mode) {
+	case TRANSMISSION_MODE_2K:
+		tune_args.transmission_mode = TRANS_MODE_2K;
+		break;
+	case TRANSMISSION_MODE_8K:
+		tune_args.transmission_mode = TRANS_MODE_8K;
+		break;
+	default:
+		tune_args.transmission_mode = TRANS_MODE_UNKNOWN;
+	}
+
+	switch (c->hierarchy) {
+	case HIERARCHY_NONE:
+		tune_args.hierarchy = HIER_NONE;
+		break;
+	case HIERARCHY_1:
+		tune_args.hierarchy = HIER_ALPHA_1;
+		break;
+	case HIERARCHY_2:
+		tune_args.hierarchy = HIER_ALPHA_2;
+		break;
+	case HIERARCHY_4:
+		tune_args.hierarchy = HIER_ALPHA_4;
+		break;
+	case HIERARCHY_AUTO:
+		tune_args.hierarchy = HIER_UNKNOWN;
+		break;
+	}
+
+	pr_debug("as102: tuner parameters: freq: %d  bw: 0x%02x  gi: 0x%02x\n",
+			c->frequency,
+			tune_args.bandwidth,
+			tune_args.guard_interval);
+
+	/*
+	 * Detect a hierarchy selection
+	 * if HP/LP are both set to FEC_NONE, HP will be selected.
+	 */
+	if ((tune_args.hierarchy != HIER_NONE) &&
+		       ((c->code_rate_LP == FEC_NONE) ||
+			(c->code_rate_HP == FEC_NONE))) {
+
+		if (c->code_rate_LP == FEC_NONE) {
+			tune_args.hier_select = HIER_HIGH_PRIORITY;
+			tune_args.code_rate =
+			   as102_fe_get_code_rate(c->code_rate_HP);
+		}
+
+		if (c->code_rate_HP == FEC_NONE) {
+			tune_args.hier_select = HIER_LOW_PRIORITY;
+			tune_args.code_rate =
+			   as102_fe_get_code_rate(c->code_rate_LP);
+		}
+
+		pr_debug("as102: \thierarchy: 0x%02x  selected: %s  code_rate_%s: 0x%02x\n",
+			tune_args.hierarchy,
+			tune_args.hier_select == HIER_HIGH_PRIORITY ?
+			"HP" : "LP",
+			tune_args.hier_select == HIER_HIGH_PRIORITY ?
+			"HP" : "LP",
+			tune_args.code_rate);
+	} else {
+		tune_args.code_rate =
+			as102_fe_get_code_rate(c->code_rate_HP);
+	}
+
+	/* Set frontend arguments */
+	return state->ops->set_tune(state->priv, &tune_args);
+}
+
+static int as102_fe_get_frontend(struct dvb_frontend *fe)
+{
+	struct as102_state *state = fe->demodulator_priv;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+	int ret = 0;
+	struct as10x_tps tps = { 0 };
+
+	/* send abilis command: GET_TPS */
+	ret = state->ops->get_tps(state->priv, &tps);
+	if (ret < 0)
+		return ret;
+
+	/* extract constellation */
+	switch (tps.modulation) {
+	case CONST_QPSK:
+		c->modulation = QPSK;
+		break;
+	case CONST_QAM16:
+		c->modulation = QAM_16;
+		break;
+	case CONST_QAM64:
+		c->modulation = QAM_64;
+		break;
+	}
+
+	/* extract hierarchy */
+	switch (tps.hierarchy) {
+	case HIER_NONE:
+		c->hierarchy = HIERARCHY_NONE;
+		break;
+	case HIER_ALPHA_1:
+		c->hierarchy = HIERARCHY_1;
+		break;
+	case HIER_ALPHA_2:
+		c->hierarchy = HIERARCHY_2;
+		break;
+	case HIER_ALPHA_4:
+		c->hierarchy = HIERARCHY_4;
+		break;
+	}
+
+	/* extract code rate HP */
+	switch (tps.code_rate_HP) {
+	case CODE_RATE_1_2:
+		c->code_rate_HP = FEC_1_2;
+		break;
+	case CODE_RATE_2_3:
+		c->code_rate_HP = FEC_2_3;
+		break;
+	case CODE_RATE_3_4:
+		c->code_rate_HP = FEC_3_4;
+		break;
+	case CODE_RATE_5_6:
+		c->code_rate_HP = FEC_5_6;
+		break;
+	case CODE_RATE_7_8:
+		c->code_rate_HP = FEC_7_8;
+		break;
+	}
+
+	/* extract code rate LP */
+	switch (tps.code_rate_LP) {
+	case CODE_RATE_1_2:
+		c->code_rate_LP = FEC_1_2;
+		break;
+	case CODE_RATE_2_3:
+		c->code_rate_LP = FEC_2_3;
+		break;
+	case CODE_RATE_3_4:
+		c->code_rate_LP = FEC_3_4;
+		break;
+	case CODE_RATE_5_6:
+		c->code_rate_LP = FEC_5_6;
+		break;
+	case CODE_RATE_7_8:
+		c->code_rate_LP = FEC_7_8;
+		break;
+	}
+
+	/* extract guard interval */
+	switch (tps.guard_interval) {
+	case GUARD_INT_1_32:
+		c->guard_interval = GUARD_INTERVAL_1_32;
+		break;
+	case GUARD_INT_1_16:
+		c->guard_interval = GUARD_INTERVAL_1_16;
+		break;
+	case GUARD_INT_1_8:
+		c->guard_interval = GUARD_INTERVAL_1_8;
+		break;
+	case GUARD_INT_1_4:
+		c->guard_interval = GUARD_INTERVAL_1_4;
+		break;
+	}
+
+	/* extract transmission mode */
+	switch (tps.transmission_mode) {
+	case TRANS_MODE_2K:
+		c->transmission_mode = TRANSMISSION_MODE_2K;
+		break;
+	case TRANS_MODE_8K:
+		c->transmission_mode = TRANSMISSION_MODE_8K;
+		break;
+	}
+
+	return 0;
+}
+
+static int as102_fe_get_tune_settings(struct dvb_frontend *fe,
+			struct dvb_frontend_tune_settings *settings) {
+
+	settings->min_delay_ms = 1000;
+
+	return 0;
+}
+
+static int as102_fe_read_status(struct dvb_frontend *fe, fe_status_t *status)
+{
+	int ret = 0;
+	struct as102_state *state = fe->demodulator_priv;
+	struct as10x_tune_status tstate = { 0 };
+
+	/* send abilis command: GET_TUNE_STATUS */
+	ret = state->ops->get_status(state->priv, &tstate);
+	if (ret < 0)
+		return ret;
+
+	state->signal_strength  = tstate.signal_strength;
+	state->ber  = tstate.BER;
+
+	switch (tstate.tune_state) {
+	case TUNE_STATUS_SIGNAL_DVB_OK:
+		*status = FE_HAS_SIGNAL | FE_HAS_CARRIER;
+		break;
+	case TUNE_STATUS_STREAM_DETECTED:
+		*status = FE_HAS_SIGNAL | FE_HAS_CARRIER | FE_HAS_SYNC;
+		break;
+	case TUNE_STATUS_STREAM_TUNED:
+		*status = FE_HAS_SIGNAL | FE_HAS_CARRIER | FE_HAS_SYNC |
+			FE_HAS_LOCK;
+		break;
+	default:
+		*status = TUNE_STATUS_NOT_TUNED;
+	}
+
+	pr_debug("as102: tuner status: 0x%02x, strength %d, per: %d, ber: %d\n",
+		 tstate.tune_state, tstate.signal_strength,
+		 tstate.PER, tstate.BER);
+
+	if (!(*status & FE_HAS_LOCK)) {
+		memset(&state->demod_stats, 0, sizeof(state->demod_stats));
+		return 0;
+	}
+
+	ret = state->ops->get_stats(state->priv, &state->demod_stats);
+	if (ret < 0)
+		memset(&state->demod_stats, 0, sizeof(state->demod_stats));
+
+	return ret;
+}
+
+/*
+ * Note:
+ * - in AS102 SNR=MER
+ *   - the SNR will be returned in linear terms, i.e. not in dB
+ *   - the accuracy equals ±2dB for a SNR range from 4dB to 30dB
+ *   - the accuracy is >2dB for SNR values outside this range
+ */
+static int as102_fe_read_snr(struct dvb_frontend *fe, u16 *snr)
+{
+	struct as102_state *state = fe->demodulator_priv;
+
+	*snr = state->demod_stats.mer;
+
+	return 0;
+}
+
+static int as102_fe_read_ber(struct dvb_frontend *fe, u32 *ber)
+{
+	struct as102_state *state = fe->demodulator_priv;
+
+	*ber = state->ber;
+
+	return 0;
+}
+
+static int as102_fe_read_signal_strength(struct dvb_frontend *fe,
+					 u16 *strength)
+{
+	struct as102_state *state = fe->demodulator_priv;
+
+	*strength = (((0xffff * 400) * state->signal_strength + 41000) * 2);
+
+	return 0;
+}
+
+static int as102_fe_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
+{
+	struct as102_state *state = fe->demodulator_priv;
+
+	if (state->demod_stats.has_started)
+		*ucblocks = state->demod_stats.bad_frame_count;
+	else
+		*ucblocks = 0;
+
+	return 0;
+}
+
+static int as102_fe_ts_bus_ctrl(struct dvb_frontend *fe, int acquire)
+{
+	struct as102_state *state = fe->demodulator_priv;
+
+	return state->ops->stream_ctrl(state->priv, acquire,
+				      state->elna_cfg);
+}
+
+static struct dvb_frontend_ops as102_fe_ops = {
+	.delsys = { SYS_DVBT },
+	.info = {
+		.name			= "Abilis AS102 DVB-T",
+		.frequency_min		= 174000000,
+		.frequency_max		= 862000000,
+		.frequency_stepsize	= 166667,
+		.caps = FE_CAN_INVERSION_AUTO
+			| FE_CAN_FEC_1_2 | FE_CAN_FEC_2_3 | FE_CAN_FEC_3_4
+			| FE_CAN_FEC_5_6 | FE_CAN_FEC_7_8 | FE_CAN_FEC_AUTO
+			| FE_CAN_QAM_16 | FE_CAN_QAM_64 | FE_CAN_QPSK
+			| FE_CAN_QAM_AUTO
+			| FE_CAN_TRANSMISSION_MODE_AUTO
+			| FE_CAN_GUARD_INTERVAL_AUTO
+			| FE_CAN_HIERARCHY_AUTO
+			| FE_CAN_RECOVER
+			| FE_CAN_MUTE_TS
+	},
+
+	.set_frontend		= as102_fe_set_frontend,
+	.get_frontend		= as102_fe_get_frontend,
+	.get_tune_settings	= as102_fe_get_tune_settings,
+
+	.read_status		= as102_fe_read_status,
+	.read_snr		= as102_fe_read_snr,
+	.read_ber		= as102_fe_read_ber,
+	.read_signal_strength	= as102_fe_read_signal_strength,
+	.read_ucblocks		= as102_fe_read_ucblocks,
+	.ts_bus_ctrl		= as102_fe_ts_bus_ctrl,
+};
+
+struct dvb_frontend *as102_attach(const char *name,
+				  const struct as102_fe_ops *ops,
+				  void *priv,
+				  uint8_t elna_cfg)
+{
+	struct as102_state *state;
+	struct dvb_frontend *fe;
+
+	state = kzalloc(sizeof(struct as102_state), GFP_KERNEL);
+	if (state == NULL) {
+		pr_err("%s: unable to allocate memory for state\n", __func__);
+		return NULL;
+	}
+	fe = &state->frontend;
+	fe->demodulator_priv = state;
+	state->ops = ops;
+	state->priv = priv;
+	state->elna_cfg = elna_cfg;
+
+	/* init frontend callback ops */
+	memcpy(&fe->ops, &as102_fe_ops, sizeof(struct dvb_frontend_ops));
+	strncpy(fe->ops.info.name, name, sizeof(fe->ops.info.name));
+
+	return fe;
+
+}
+EXPORT_SYMBOL_GPL(as102_attach);
+
+MODULE_DESCRIPTION("as102-fe");
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Pierrick Hascoet <pierrick.hascoet@abilis.com>");
diff --git a/drivers/media/dvb-frontends/as102_fe.h b/drivers/media/dvb-frontends/as102_fe.h
new file mode 100644
index 000000000000..a7c91430ca3d
--- /dev/null
+++ b/drivers/media/dvb-frontends/as102_fe.h
@@ -0,0 +1,29 @@
+/*
+ * Abilis Systems Single DVB-T Receiver
+ * Copyright (C) 2014 Mauro Carvalho Chehab <m.chehab@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2, or (at your option)
+ * any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include "as102_fe_types.h"
+
+struct as102_fe_ops {
+	int (*set_tune)(void *priv, struct as10x_tune_args *tune_args);
+	int (*get_tps)(void *priv, struct as10x_tps *tps);
+	int (*get_status)(void *priv, struct as10x_tune_status *tstate);
+	int (*get_stats)(void *priv, struct as10x_demod_stats *demod_stats);
+	int (*stream_ctrl)(void *priv, int acquire, uint32_t elna_cfg);
+};
+
+struct dvb_frontend *as102_attach(const char *name,
+				  const struct as102_fe_ops *ops,
+				  void *priv,
+				  uint8_t elna_cfg);
diff --git a/drivers/media/dvb-frontends/as102_fe_types.h b/drivers/media/dvb-frontends/as102_fe_types.h
new file mode 100644
index 000000000000..80a5398b580f
--- /dev/null
+++ b/drivers/media/dvb-frontends/as102_fe_types.h
@@ -0,0 +1,188 @@
+/*
+ * Abilis Systems Single DVB-T Receiver
+ * Copyright (C) 2008 Pierrick Hascoet <pierrick.hascoet@abilis.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2, or (at your option)
+ * any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+#ifndef _AS10X_TYPES_H_
+#define _AS10X_TYPES_H_
+
+/*********************************/
+/*       MACRO DEFINITIONS       */
+/*********************************/
+
+/* bandwidth constant values */
+#define BW_5_MHZ		0x00
+#define BW_6_MHZ		0x01
+#define BW_7_MHZ		0x02
+#define BW_8_MHZ		0x03
+
+/* hierarchy priority selection values */
+#define HIER_NO_PRIORITY	0x00
+#define HIER_LOW_PRIORITY	0x01
+#define HIER_HIGH_PRIORITY	0x02
+
+/* constellation available values */
+#define CONST_QPSK		0x00
+#define CONST_QAM16		0x01
+#define CONST_QAM64		0x02
+#define CONST_UNKNOWN		0xFF
+
+/* hierarchy available values */
+#define HIER_NONE		0x00
+#define HIER_ALPHA_1		0x01
+#define HIER_ALPHA_2		0x02
+#define HIER_ALPHA_4		0x03
+#define HIER_UNKNOWN		0xFF
+
+/* interleaving available values */
+#define INTLV_NATIVE		0x00
+#define INTLV_IN_DEPTH		0x01
+#define INTLV_UNKNOWN		0xFF
+
+/* code rate available values */
+#define CODE_RATE_1_2		0x00
+#define CODE_RATE_2_3		0x01
+#define CODE_RATE_3_4		0x02
+#define CODE_RATE_5_6		0x03
+#define CODE_RATE_7_8		0x04
+#define CODE_RATE_UNKNOWN	0xFF
+
+/* guard interval available values */
+#define GUARD_INT_1_32		0x00
+#define GUARD_INT_1_16		0x01
+#define GUARD_INT_1_8		0x02
+#define GUARD_INT_1_4		0x03
+#define GUARD_UNKNOWN		0xFF
+
+/* transmission mode available values */
+#define TRANS_MODE_2K		0x00
+#define TRANS_MODE_8K		0x01
+#define TRANS_MODE_4K		0x02
+#define TRANS_MODE_UNKNOWN	0xFF
+
+/* DVBH signalling available values */
+#define TIMESLICING_PRESENT	0x01
+#define MPE_FEC_PRESENT		0x02
+
+/* tune state available */
+#define TUNE_STATUS_NOT_TUNED		0x00
+#define TUNE_STATUS_IDLE		0x01
+#define TUNE_STATUS_LOCKING		0x02
+#define TUNE_STATUS_SIGNAL_DVB_OK	0x03
+#define TUNE_STATUS_STREAM_DETECTED	0x04
+#define TUNE_STATUS_STREAM_TUNED	0x05
+#define TUNE_STATUS_ERROR		0xFF
+
+/* available TS FID filter types */
+#define TS_PID_TYPE_TS		0
+#define TS_PID_TYPE_PSI_SI	1
+#define TS_PID_TYPE_MPE		2
+
+/* number of echos available */
+#define MAX_ECHOS	15
+
+/* Context types */
+#define CONTEXT_LNA			1010
+#define CONTEXT_ELNA_HYSTERESIS		4003
+#define CONTEXT_ELNA_GAIN		4004
+#define CONTEXT_MER_THRESHOLD		5005
+#define CONTEXT_MER_OFFSET		5006
+#define CONTEXT_IR_STATE		7000
+#define CONTEXT_TSOUT_MSB_FIRST		7004
+#define CONTEXT_TSOUT_FALLING_EDGE	7005
+
+/* Configuration modes */
+#define CFG_MODE_ON	0
+#define CFG_MODE_OFF	1
+#define CFG_MODE_AUTO	2
+
+struct as10x_tps {
+	uint8_t modulation;
+	uint8_t hierarchy;
+	uint8_t interleaving_mode;
+	uint8_t code_rate_HP;
+	uint8_t code_rate_LP;
+	uint8_t guard_interval;
+	uint8_t transmission_mode;
+	uint8_t DVBH_mask_HP;
+	uint8_t DVBH_mask_LP;
+	uint16_t cell_ID;
+} __packed;
+
+struct as10x_tune_args {
+	/* frequency */
+	uint32_t freq;
+	/* bandwidth */
+	uint8_t bandwidth;
+	/* hierarchy selection */
+	uint8_t hier_select;
+	/* constellation */
+	uint8_t modulation;
+	/* hierarchy */
+	uint8_t hierarchy;
+	/* interleaving mode */
+	uint8_t interleaving_mode;
+	/* code rate */
+	uint8_t code_rate;
+	/* guard interval */
+	uint8_t guard_interval;
+	/* transmission mode */
+	uint8_t transmission_mode;
+} __packed;
+
+struct as10x_tune_status {
+	/* tune status */
+	uint8_t tune_state;
+	/* signal strength */
+	int16_t signal_strength;
+	/* packet error rate 10^-4 */
+	uint16_t PER;
+	/* bit error rate 10^-4 */
+	uint16_t BER;
+} __packed;
+
+struct as10x_demod_stats {
+	/* frame counter */
+	uint32_t frame_count;
+	/* Bad frame counter */
+	uint32_t bad_frame_count;
+	/* Number of wrong bytes fixed by Reed-Solomon */
+	uint32_t bytes_fixed_by_rs;
+	/* Averaged MER */
+	uint16_t mer;
+	/* statistics calculation state indicator (started or not) */
+	uint8_t has_started;
+} __packed;
+
+struct as10x_ts_filter {
+	uint16_t pid;  /* valid PID value 0x00 : 0x2000 */
+	uint8_t  type; /* Red TS_PID_TYPE_<N> values */
+	uint8_t  idx;  /* index in filtering table */
+} __packed;
+
+struct as10x_register_value {
+	uint8_t mode;
+	union {
+		uint8_t  value8;   /* 8 bit value */
+		uint16_t value16;  /* 16 bit value */
+		uint32_t value32;  /* 32 bit value */
+	} __packed u;
+} __packed;
+
+struct as10x_register_addr {
+	/* register addr */
+	uint32_t addr;
+	/* register mode access */
+	uint8_t mode;
+};
+
+#endif
diff --git a/drivers/media/usb/as102/Makefile b/drivers/media/usb/as102/Makefile
index 8916d8a909bc..22f43eee4a3b 100644
--- a/drivers/media/usb/as102/Makefile
+++ b/drivers/media/usb/as102/Makefile
@@ -1,6 +1,7 @@
 dvb-as102-objs := as102_drv.o as102_fw.o as10x_cmd.o as10x_cmd_stream.o \
-		as102_fe.o as102_usb_drv.o as10x_cmd_cfg.o
+		  as102_usb_drv.o as10x_cmd_cfg.o
 
 obj-$(CONFIG_DVB_AS102) += dvb-as102.o
 
 ccflags-y += -Idrivers/media/dvb-core
+ccflags-y += -Idrivers/media/dvb-frontends
diff --git a/drivers/media/usb/as102/as102_fe.c b/drivers/media/usb/as102/as102_fe.c
deleted file mode 100644
index f57560c191ae..000000000000
--- a/drivers/media/usb/as102/as102_fe.c
+++ /dev/null
@@ -1,466 +0,0 @@
-/*
- * Abilis Systems Single DVB-T Receiver
- * Copyright (C) 2008 Pierrick Hascoet <pierrick.hascoet@abilis.com>
- * Copyright (C) 2010 Devin Heitmueller <dheitmueller@kernellabs.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2, or (at your option)
- * any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- */
-
-#include <dvb_frontend.h>
-
-#include "as102_fe.h"
-
-struct as102_state {
-	struct dvb_frontend frontend;
-	struct as10x_demod_stats demod_stats;
-
-	const struct as102_fe_ops *ops;
-	void *priv;
-	uint8_t elna_cfg;
-
-	/* signal strength */
-	uint16_t signal_strength;
-	/* bit error rate */
-	uint32_t ber;
-};
-
-static uint8_t as102_fe_get_code_rate(fe_code_rate_t arg)
-{
-	uint8_t c;
-
-	switch (arg) {
-	case FEC_1_2:
-		c = CODE_RATE_1_2;
-		break;
-	case FEC_2_3:
-		c = CODE_RATE_2_3;
-		break;
-	case FEC_3_4:
-		c = CODE_RATE_3_4;
-		break;
-	case FEC_5_6:
-		c = CODE_RATE_5_6;
-		break;
-	case FEC_7_8:
-		c = CODE_RATE_7_8;
-		break;
-	default:
-		c = CODE_RATE_UNKNOWN;
-		break;
-	}
-
-	return c;
-}
-
-static int as102_fe_set_frontend(struct dvb_frontend *fe)
-{
-	struct as102_state *state = fe->demodulator_priv;
-	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
-	struct as10x_tune_args tune_args = { 0 };
-
-	/* set frequency */
-	tune_args.freq = c->frequency / 1000;
-
-	/* fix interleaving_mode */
-	tune_args.interleaving_mode = INTLV_NATIVE;
-
-	switch (c->bandwidth_hz) {
-	case 8000000:
-		tune_args.bandwidth = BW_8_MHZ;
-		break;
-	case 7000000:
-		tune_args.bandwidth = BW_7_MHZ;
-		break;
-	case 6000000:
-		tune_args.bandwidth = BW_6_MHZ;
-		break;
-	default:
-		tune_args.bandwidth = BW_8_MHZ;
-	}
-
-	switch (c->guard_interval) {
-	case GUARD_INTERVAL_1_32:
-		tune_args.guard_interval = GUARD_INT_1_32;
-		break;
-	case GUARD_INTERVAL_1_16:
-		tune_args.guard_interval = GUARD_INT_1_16;
-		break;
-	case GUARD_INTERVAL_1_8:
-		tune_args.guard_interval = GUARD_INT_1_8;
-		break;
-	case GUARD_INTERVAL_1_4:
-		tune_args.guard_interval = GUARD_INT_1_4;
-		break;
-	case GUARD_INTERVAL_AUTO:
-	default:
-		tune_args.guard_interval = GUARD_UNKNOWN;
-		break;
-	}
-
-	switch (c->modulation) {
-	case QPSK:
-		tune_args.modulation = CONST_QPSK;
-		break;
-	case QAM_16:
-		tune_args.modulation = CONST_QAM16;
-		break;
-	case QAM_64:
-		tune_args.modulation = CONST_QAM64;
-		break;
-	default:
-		tune_args.modulation = CONST_UNKNOWN;
-		break;
-	}
-
-	switch (c->transmission_mode) {
-	case TRANSMISSION_MODE_2K:
-		tune_args.transmission_mode = TRANS_MODE_2K;
-		break;
-	case TRANSMISSION_MODE_8K:
-		tune_args.transmission_mode = TRANS_MODE_8K;
-		break;
-	default:
-		tune_args.transmission_mode = TRANS_MODE_UNKNOWN;
-	}
-
-	switch (c->hierarchy) {
-	case HIERARCHY_NONE:
-		tune_args.hierarchy = HIER_NONE;
-		break;
-	case HIERARCHY_1:
-		tune_args.hierarchy = HIER_ALPHA_1;
-		break;
-	case HIERARCHY_2:
-		tune_args.hierarchy = HIER_ALPHA_2;
-		break;
-	case HIERARCHY_4:
-		tune_args.hierarchy = HIER_ALPHA_4;
-		break;
-	case HIERARCHY_AUTO:
-		tune_args.hierarchy = HIER_UNKNOWN;
-		break;
-	}
-
-	pr_debug("as102: tuner parameters: freq: %d  bw: 0x%02x  gi: 0x%02x\n",
-			c->frequency,
-			tune_args.bandwidth,
-			tune_args.guard_interval);
-
-	/*
-	 * Detect a hierarchy selection
-	 * if HP/LP are both set to FEC_NONE, HP will be selected.
-	 */
-	if ((tune_args.hierarchy != HIER_NONE) &&
-		       ((c->code_rate_LP == FEC_NONE) ||
-			(c->code_rate_HP == FEC_NONE))) {
-
-		if (c->code_rate_LP == FEC_NONE) {
-			tune_args.hier_select = HIER_HIGH_PRIORITY;
-			tune_args.code_rate =
-			   as102_fe_get_code_rate(c->code_rate_HP);
-		}
-
-		if (c->code_rate_HP == FEC_NONE) {
-			tune_args.hier_select = HIER_LOW_PRIORITY;
-			tune_args.code_rate =
-			   as102_fe_get_code_rate(c->code_rate_LP);
-		}
-
-		pr_debug("as102: \thierarchy: 0x%02x  selected: %s  code_rate_%s: 0x%02x\n",
-			tune_args.hierarchy,
-			tune_args.hier_select == HIER_HIGH_PRIORITY ?
-			"HP" : "LP",
-			tune_args.hier_select == HIER_HIGH_PRIORITY ?
-			"HP" : "LP",
-			tune_args.code_rate);
-	} else {
-		tune_args.code_rate =
-			as102_fe_get_code_rate(c->code_rate_HP);
-	}
-
-	/* Set frontend arguments */
-	return state->ops->set_tune(state->priv, &tune_args);
-}
-
-static int as102_fe_get_frontend(struct dvb_frontend *fe)
-{
-	struct as102_state *state = fe->demodulator_priv;
-	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
-	int ret = 0;
-	struct as10x_tps tps = { 0 };
-
-	/* send abilis command: GET_TPS */
-	ret = state->ops->get_tps(state->priv, &tps);
-	if (ret < 0)
-		return ret;
-
-	/* extract constellation */
-	switch (tps.modulation) {
-	case CONST_QPSK:
-		c->modulation = QPSK;
-		break;
-	case CONST_QAM16:
-		c->modulation = QAM_16;
-		break;
-	case CONST_QAM64:
-		c->modulation = QAM_64;
-		break;
-	}
-
-	/* extract hierarchy */
-	switch (tps.hierarchy) {
-	case HIER_NONE:
-		c->hierarchy = HIERARCHY_NONE;
-		break;
-	case HIER_ALPHA_1:
-		c->hierarchy = HIERARCHY_1;
-		break;
-	case HIER_ALPHA_2:
-		c->hierarchy = HIERARCHY_2;
-		break;
-	case HIER_ALPHA_4:
-		c->hierarchy = HIERARCHY_4;
-		break;
-	}
-
-	/* extract code rate HP */
-	switch (tps.code_rate_HP) {
-	case CODE_RATE_1_2:
-		c->code_rate_HP = FEC_1_2;
-		break;
-	case CODE_RATE_2_3:
-		c->code_rate_HP = FEC_2_3;
-		break;
-	case CODE_RATE_3_4:
-		c->code_rate_HP = FEC_3_4;
-		break;
-	case CODE_RATE_5_6:
-		c->code_rate_HP = FEC_5_6;
-		break;
-	case CODE_RATE_7_8:
-		c->code_rate_HP = FEC_7_8;
-		break;
-	}
-
-	/* extract code rate LP */
-	switch (tps.code_rate_LP) {
-	case CODE_RATE_1_2:
-		c->code_rate_LP = FEC_1_2;
-		break;
-	case CODE_RATE_2_3:
-		c->code_rate_LP = FEC_2_3;
-		break;
-	case CODE_RATE_3_4:
-		c->code_rate_LP = FEC_3_4;
-		break;
-	case CODE_RATE_5_6:
-		c->code_rate_LP = FEC_5_6;
-		break;
-	case CODE_RATE_7_8:
-		c->code_rate_LP = FEC_7_8;
-		break;
-	}
-
-	/* extract guard interval */
-	switch (tps.guard_interval) {
-	case GUARD_INT_1_32:
-		c->guard_interval = GUARD_INTERVAL_1_32;
-		break;
-	case GUARD_INT_1_16:
-		c->guard_interval = GUARD_INTERVAL_1_16;
-		break;
-	case GUARD_INT_1_8:
-		c->guard_interval = GUARD_INTERVAL_1_8;
-		break;
-	case GUARD_INT_1_4:
-		c->guard_interval = GUARD_INTERVAL_1_4;
-		break;
-	}
-
-	/* extract transmission mode */
-	switch (tps.transmission_mode) {
-	case TRANS_MODE_2K:
-		c->transmission_mode = TRANSMISSION_MODE_2K;
-		break;
-	case TRANS_MODE_8K:
-		c->transmission_mode = TRANSMISSION_MODE_8K;
-		break;
-	}
-
-	return 0;
-}
-
-static int as102_fe_get_tune_settings(struct dvb_frontend *fe,
-			struct dvb_frontend_tune_settings *settings) {
-
-	settings->min_delay_ms = 1000;
-
-	return 0;
-}
-
-static int as102_fe_read_status(struct dvb_frontend *fe, fe_status_t *status)
-{
-	int ret = 0;
-	struct as102_state *state = fe->demodulator_priv;
-	struct as10x_tune_status tstate = { 0 };
-
-	/* send abilis command: GET_TUNE_STATUS */
-	ret = state->ops->get_status(state->priv, &tstate);
-	if (ret < 0)
-		return ret;
-
-	state->signal_strength  = tstate.signal_strength;
-	state->ber  = tstate.BER;
-
-	switch (tstate.tune_state) {
-	case TUNE_STATUS_SIGNAL_DVB_OK:
-		*status = FE_HAS_SIGNAL | FE_HAS_CARRIER;
-		break;
-	case TUNE_STATUS_STREAM_DETECTED:
-		*status = FE_HAS_SIGNAL | FE_HAS_CARRIER | FE_HAS_SYNC;
-		break;
-	case TUNE_STATUS_STREAM_TUNED:
-		*status = FE_HAS_SIGNAL | FE_HAS_CARRIER | FE_HAS_SYNC |
-			FE_HAS_LOCK;
-		break;
-	default:
-		*status = TUNE_STATUS_NOT_TUNED;
-	}
-
-	pr_debug("as102: tuner status: 0x%02x, strength %d, per: %d, ber: %d\n",
-		 tstate.tune_state, tstate.signal_strength,
-		 tstate.PER, tstate.BER);
-
-	if (!(*status & FE_HAS_LOCK)) {
-		memset(&state->demod_stats, 0, sizeof(state->demod_stats));
-		return 0;
-	}
-
-	ret = state->ops->get_stats(state->priv, &state->demod_stats);
-	if (ret < 0)
-		memset(&state->demod_stats, 0, sizeof(state->demod_stats));
-
-	return ret;
-}
-
-/*
- * Note:
- * - in AS102 SNR=MER
- *   - the SNR will be returned in linear terms, i.e. not in dB
- *   - the accuracy equals ±2dB for a SNR range from 4dB to 30dB
- *   - the accuracy is >2dB for SNR values outside this range
- */
-static int as102_fe_read_snr(struct dvb_frontend *fe, u16 *snr)
-{
-	struct as102_state *state = fe->demodulator_priv;
-
-	*snr = state->demod_stats.mer;
-
-	return 0;
-}
-
-static int as102_fe_read_ber(struct dvb_frontend *fe, u32 *ber)
-{
-	struct as102_state *state = fe->demodulator_priv;
-
-	*ber = state->ber;
-
-	return 0;
-}
-
-static int as102_fe_read_signal_strength(struct dvb_frontend *fe,
-					 u16 *strength)
-{
-	struct as102_state *state = fe->demodulator_priv;
-
-	*strength = (((0xffff * 400) * state->signal_strength + 41000) * 2);
-
-	return 0;
-}
-
-static int as102_fe_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
-{
-	struct as102_state *state = fe->demodulator_priv;
-
-	if (state->demod_stats.has_started)
-		*ucblocks = state->demod_stats.bad_frame_count;
-	else
-		*ucblocks = 0;
-
-	return 0;
-}
-
-static int as102_fe_ts_bus_ctrl(struct dvb_frontend *fe, int acquire)
-{
-	struct as102_state *state = fe->demodulator_priv;
-
-	return state->ops->stream_ctrl(state->priv, acquire,
-				      state->elna_cfg);
-}
-
-static struct dvb_frontend_ops as102_fe_ops = {
-	.delsys = { SYS_DVBT },
-	.info = {
-		.name			= "Abilis AS102 DVB-T",
-		.frequency_min		= 174000000,
-		.frequency_max		= 862000000,
-		.frequency_stepsize	= 166667,
-		.caps = FE_CAN_INVERSION_AUTO
-			| FE_CAN_FEC_1_2 | FE_CAN_FEC_2_3 | FE_CAN_FEC_3_4
-			| FE_CAN_FEC_5_6 | FE_CAN_FEC_7_8 | FE_CAN_FEC_AUTO
-			| FE_CAN_QAM_16 | FE_CAN_QAM_64 | FE_CAN_QPSK
-			| FE_CAN_QAM_AUTO
-			| FE_CAN_TRANSMISSION_MODE_AUTO
-			| FE_CAN_GUARD_INTERVAL_AUTO
-			| FE_CAN_HIERARCHY_AUTO
-			| FE_CAN_RECOVER
-			| FE_CAN_MUTE_TS
-	},
-
-	.set_frontend		= as102_fe_set_frontend,
-	.get_frontend		= as102_fe_get_frontend,
-	.get_tune_settings	= as102_fe_get_tune_settings,
-
-	.read_status		= as102_fe_read_status,
-	.read_snr		= as102_fe_read_snr,
-	.read_ber		= as102_fe_read_ber,
-	.read_signal_strength	= as102_fe_read_signal_strength,
-	.read_ucblocks		= as102_fe_read_ucblocks,
-	.ts_bus_ctrl		= as102_fe_ts_bus_ctrl,
-};
-
-struct dvb_frontend *as102_attach(const char *name,
-				  const struct as102_fe_ops *ops,
-				  void *priv,
-				  uint8_t elna_cfg)
-{
-	struct as102_state *state;
-	struct dvb_frontend *fe;
-
-	state = kzalloc(sizeof(struct as102_state), GFP_KERNEL);
-	if (state == NULL) {
-		pr_err("%s: unable to allocate memory for state\n", __func__);
-		return NULL;
-	}
-	fe = &state->frontend;
-	fe->demodulator_priv = state;
-	state->ops = ops;
-	state->priv = priv;
-	state->elna_cfg = elna_cfg;
-
-	/* init frontend callback ops */
-	memcpy(&fe->ops, &as102_fe_ops, sizeof(struct dvb_frontend_ops));
-	strncpy(fe->ops.info.name, name, sizeof(fe->ops.info.name));
-
-	return fe;
-
-}
-EXPORT_SYMBOL_GPL(as102_attach);
diff --git a/drivers/media/usb/as102/as102_fe.h b/drivers/media/usb/as102/as102_fe.h
deleted file mode 100644
index 4098cf8f8cf9..000000000000
--- a/drivers/media/usb/as102/as102_fe.h
+++ /dev/null
@@ -1,29 +0,0 @@
-/*
- * Abilis Systems Single DVB-T Receiver
- * Copyright (C) 2014 Mauro Carvalho Chehab <m.chehab@samsung.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2, or (at your option)
- * any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- */
-
-#include "as10x_types.h"
-
-struct as102_fe_ops {
-	int (*set_tune)(void *priv, struct as10x_tune_args *tune_args);
-	int (*get_tps)(void *priv, struct as10x_tps *tps);
-	int (*get_status)(void *priv, struct as10x_tune_status *tstate);
-	int (*get_stats)(void *priv, struct as10x_demod_stats *demod_stats);
-	int (*stream_ctrl)(void *priv, int acquire, uint32_t elna_cfg);
-};
-
-struct dvb_frontend *as102_attach(const char *name,
-				  const struct as102_fe_ops *ops,
-				  void *priv,
-				  uint8_t elna_cfg);
diff --git a/drivers/media/usb/as102/as10x_cmd.c b/drivers/media/usb/as102/as10x_cmd.c
index 8868c52500ee..ef238022dfe5 100644
--- a/drivers/media/usb/as102/as10x_cmd.c
+++ b/drivers/media/usb/as102/as10x_cmd.c
@@ -16,7 +16,6 @@
 
 #include <linux/kernel.h>
 #include "as102_drv.h"
-#include "as10x_types.h"
 #include "as10x_cmd.h"
 
 /**
diff --git a/drivers/media/usb/as102/as10x_cmd.h b/drivers/media/usb/as102/as10x_cmd.h
index 83c0440dba2f..09134f73ba3d 100644
--- a/drivers/media/usb/as102/as10x_cmd.h
+++ b/drivers/media/usb/as102/as10x_cmd.h
@@ -17,7 +17,7 @@
 
 #include <linux/kernel.h>
 
-#include "as10x_types.h"
+#include "as102_fe_types.h"
 
 /*********************************/
 /*       MACRO DEFINITIONS       */
diff --git a/drivers/media/usb/as102/as10x_cmd_cfg.c b/drivers/media/usb/as102/as10x_cmd_cfg.c
index 833463343ada..6f9dea1d860b 100644
--- a/drivers/media/usb/as102/as10x_cmd_cfg.c
+++ b/drivers/media/usb/as102/as10x_cmd_cfg.c
@@ -15,7 +15,6 @@
 
 #include <linux/kernel.h>
 #include "as102_drv.h"
-#include "as10x_types.h"
 #include "as10x_cmd.h"
 
 /***************************/
diff --git a/drivers/media/usb/as102/as10x_types.h b/drivers/media/usb/as102/as10x_types.h
deleted file mode 100644
index 80a5398b580f..000000000000
--- a/drivers/media/usb/as102/as10x_types.h
+++ /dev/null
@@ -1,188 +0,0 @@
-/*
- * Abilis Systems Single DVB-T Receiver
- * Copyright (C) 2008 Pierrick Hascoet <pierrick.hascoet@abilis.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2, or (at your option)
- * any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- */
-#ifndef _AS10X_TYPES_H_
-#define _AS10X_TYPES_H_
-
-/*********************************/
-/*       MACRO DEFINITIONS       */
-/*********************************/
-
-/* bandwidth constant values */
-#define BW_5_MHZ		0x00
-#define BW_6_MHZ		0x01
-#define BW_7_MHZ		0x02
-#define BW_8_MHZ		0x03
-
-/* hierarchy priority selection values */
-#define HIER_NO_PRIORITY	0x00
-#define HIER_LOW_PRIORITY	0x01
-#define HIER_HIGH_PRIORITY	0x02
-
-/* constellation available values */
-#define CONST_QPSK		0x00
-#define CONST_QAM16		0x01
-#define CONST_QAM64		0x02
-#define CONST_UNKNOWN		0xFF
-
-/* hierarchy available values */
-#define HIER_NONE		0x00
-#define HIER_ALPHA_1		0x01
-#define HIER_ALPHA_2		0x02
-#define HIER_ALPHA_4		0x03
-#define HIER_UNKNOWN		0xFF
-
-/* interleaving available values */
-#define INTLV_NATIVE		0x00
-#define INTLV_IN_DEPTH		0x01
-#define INTLV_UNKNOWN		0xFF
-
-/* code rate available values */
-#define CODE_RATE_1_2		0x00
-#define CODE_RATE_2_3		0x01
-#define CODE_RATE_3_4		0x02
-#define CODE_RATE_5_6		0x03
-#define CODE_RATE_7_8		0x04
-#define CODE_RATE_UNKNOWN	0xFF
-
-/* guard interval available values */
-#define GUARD_INT_1_32		0x00
-#define GUARD_INT_1_16		0x01
-#define GUARD_INT_1_8		0x02
-#define GUARD_INT_1_4		0x03
-#define GUARD_UNKNOWN		0xFF
-
-/* transmission mode available values */
-#define TRANS_MODE_2K		0x00
-#define TRANS_MODE_8K		0x01
-#define TRANS_MODE_4K		0x02
-#define TRANS_MODE_UNKNOWN	0xFF
-
-/* DVBH signalling available values */
-#define TIMESLICING_PRESENT	0x01
-#define MPE_FEC_PRESENT		0x02
-
-/* tune state available */
-#define TUNE_STATUS_NOT_TUNED		0x00
-#define TUNE_STATUS_IDLE		0x01
-#define TUNE_STATUS_LOCKING		0x02
-#define TUNE_STATUS_SIGNAL_DVB_OK	0x03
-#define TUNE_STATUS_STREAM_DETECTED	0x04
-#define TUNE_STATUS_STREAM_TUNED	0x05
-#define TUNE_STATUS_ERROR		0xFF
-
-/* available TS FID filter types */
-#define TS_PID_TYPE_TS		0
-#define TS_PID_TYPE_PSI_SI	1
-#define TS_PID_TYPE_MPE		2
-
-/* number of echos available */
-#define MAX_ECHOS	15
-
-/* Context types */
-#define CONTEXT_LNA			1010
-#define CONTEXT_ELNA_HYSTERESIS		4003
-#define CONTEXT_ELNA_GAIN		4004
-#define CONTEXT_MER_THRESHOLD		5005
-#define CONTEXT_MER_OFFSET		5006
-#define CONTEXT_IR_STATE		7000
-#define CONTEXT_TSOUT_MSB_FIRST		7004
-#define CONTEXT_TSOUT_FALLING_EDGE	7005
-
-/* Configuration modes */
-#define CFG_MODE_ON	0
-#define CFG_MODE_OFF	1
-#define CFG_MODE_AUTO	2
-
-struct as10x_tps {
-	uint8_t modulation;
-	uint8_t hierarchy;
-	uint8_t interleaving_mode;
-	uint8_t code_rate_HP;
-	uint8_t code_rate_LP;
-	uint8_t guard_interval;
-	uint8_t transmission_mode;
-	uint8_t DVBH_mask_HP;
-	uint8_t DVBH_mask_LP;
-	uint16_t cell_ID;
-} __packed;
-
-struct as10x_tune_args {
-	/* frequency */
-	uint32_t freq;
-	/* bandwidth */
-	uint8_t bandwidth;
-	/* hierarchy selection */
-	uint8_t hier_select;
-	/* constellation */
-	uint8_t modulation;
-	/* hierarchy */
-	uint8_t hierarchy;
-	/* interleaving mode */
-	uint8_t interleaving_mode;
-	/* code rate */
-	uint8_t code_rate;
-	/* guard interval */
-	uint8_t guard_interval;
-	/* transmission mode */
-	uint8_t transmission_mode;
-} __packed;
-
-struct as10x_tune_status {
-	/* tune status */
-	uint8_t tune_state;
-	/* signal strength */
-	int16_t signal_strength;
-	/* packet error rate 10^-4 */
-	uint16_t PER;
-	/* bit error rate 10^-4 */
-	uint16_t BER;
-} __packed;
-
-struct as10x_demod_stats {
-	/* frame counter */
-	uint32_t frame_count;
-	/* Bad frame counter */
-	uint32_t bad_frame_count;
-	/* Number of wrong bytes fixed by Reed-Solomon */
-	uint32_t bytes_fixed_by_rs;
-	/* Averaged MER */
-	uint16_t mer;
-	/* statistics calculation state indicator (started or not) */
-	uint8_t has_started;
-} __packed;
-
-struct as10x_ts_filter {
-	uint16_t pid;  /* valid PID value 0x00 : 0x2000 */
-	uint8_t  type; /* Red TS_PID_TYPE_<N> values */
-	uint8_t  idx;  /* index in filtering table */
-} __packed;
-
-struct as10x_register_value {
-	uint8_t mode;
-	union {
-		uint8_t  value8;   /* 8 bit value */
-		uint16_t value16;  /* 16 bit value */
-		uint32_t value32;  /* 32 bit value */
-	} __packed u;
-} __packed;
-
-struct as10x_register_addr {
-	/* register addr */
-	uint32_t addr;
-	/* register mode access */
-	uint8_t mode;
-};
-
-#endif
-- 
1.9.3

