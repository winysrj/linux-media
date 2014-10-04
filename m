Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f171.google.com ([209.85.192.171]:41114 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbaJDIsm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 4 Oct 2014 04:48:42 -0400
Received: by mail-pd0-f171.google.com with SMTP id ft15so778522pdb.30
        for <linux-media@vger.kernel.org>; Sat, 04 Oct 2014 01:48:42 -0700 (PDT)
From: "=?UTF-8?q?=D0=91=D1=83=D0=B4=D0=B8=20=D0=A0=D0=BE=D0=BC=D0=B0=D0=BD=D1=82=D0=BE=2C=20AreMa=20Inc?="
	<info@are.ma>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?=D0=91=D1=83=D0=B4=D0=B8=20=D0=A0=D0=BE=D0=BC=D0=B0=D0=BD=D1=82=D0=BE=2C=20AreMa=20Inc?=
	<knightrider@are.ma>, crope@iki.fi, m.chehab@samsung.com,
	mchehab@osg.samsung.com, hdegoede@redhat.com,
	laurent.pinchart@ideasonboard.com, mkrufky@linuxtv.org,
	sylvester.nawrocki@gmail.com, g.liakhovetski@gmx.de,
	peter.senna@gmail.com
Subject: [PATCH 0/14] pt3 (pci, tc90522, mxl301rf, qm1d1c0042) full diffs
Date: Sat,  4 Oct 2014 17:48:24 +0900
Message-Id: <1412412504-17377-1-git-send-email-knightrider@are.ma>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Буди Романто, AreMa Inc <knightrider@are.ma>

Namespace cleanups & more...
https://github.com/knight-rider/ptx/tree/master/pt3_dvb

This is a full package.
Splitted patches will follow.

Signed-off-by: Буди Романто, AreMa Inc <knightrider@are.ma>
---
 drivers/media/dvb-frontends/Kconfig   |    4 +-
 drivers/media/dvb-frontends/Makefile  |    1 +
 drivers/media/dvb-frontends/tc90522.c | 1146 +++++++++---------------
 drivers/media/dvb-frontends/tc90522.h |   41 +-
 drivers/media/pci/pt3/Kconfig         |    2 +-
 drivers/media/pci/pt3/Makefile        |    8 +-
 drivers/media/pci/pt3/pt3.c           | 1557 ++++++++++++++++++---------------
 drivers/media/pci/pt3/pt3.h           |  183 +---
 drivers/media/pci/pt3/pt3_dma.c       |  225 -----
 drivers/media/pci/pt3/pt3_i2c.c       |  240 -----
 drivers/media/tuners/mxl301rf.c       |  550 ++++++------
 drivers/media/tuners/mxl301rf.h       |   23 +-
 drivers/media/tuners/qm1d1c0042.c     |  644 +++++++-------
 drivers/media/tuners/qm1d1c0042.h     |   34 +-
 14 files changed, 1903 insertions(+), 2755 deletions(-)
 delete mode 100644 drivers/media/pci/pt3/pt3_dma.c
 delete mode 100644 drivers/media/pci/pt3/pt3_i2c.c

diff --git a/drivers/media/dvb-frontends/Kconfig b/drivers/media/dvb-frontends/Kconfig
index 5a13454..0c59825 100644
--- a/drivers/media/dvb-frontends/Kconfig
+++ b/drivers/media/dvb-frontends/Kconfig
@@ -621,7 +621,7 @@ config DVB_S5H1411
 	  An ATSC 8VSB and QAM64/256 tuner module. Say Y when you want
 	  to support this frontend.
 
-comment "ISDB-T (terrestrial) frontends"
+comment "ISDB-S (satellite) & ISDB-T (terrestrial) frontends"
 	depends on DVB_CORE
 
 config DVB_S921
@@ -653,7 +653,7 @@ config DVB_TC90522
 	depends on DVB_CORE && I2C
 	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
-	  A Toshiba TC90522 2xISDB-T + 2xISDB-S demodulator.
+	  Toshiba TC90522 2xISDB-S 8PSK + 2xISDB-T OFDM demodulator.
 	  Say Y when you want to support this frontend.
 
 comment "Digital terrestrial only tuners/PLL"
diff --git a/drivers/media/dvb-frontends/Makefile b/drivers/media/dvb-frontends/Makefile
index ba59df6..6f05615 100644
--- a/drivers/media/dvb-frontends/Makefile
+++ b/drivers/media/dvb-frontends/Makefile
@@ -116,3 +116,4 @@ obj-$(CONFIG_DVB_M88RS2000) += m88rs2000.o
 obj-$(CONFIG_DVB_AF9033) += af9033.o
 obj-$(CONFIG_DVB_AS102_FE) += as102_fe.o
 obj-$(CONFIG_DVB_TC90522) += tc90522.o
+
diff --git a/drivers/media/dvb-frontends/tc90522.c b/drivers/media/dvb-frontends/tc90522.c
index d9905fb..cf19cfb 100644
--- a/drivers/media/dvb-frontends/tc90522.c
+++ b/drivers/media/dvb-frontends/tc90522.c
@@ -1,12 +1,12 @@
 /*
- * Toshiba TC90522 Demodulator
+ * Toshiba TC90522XBG 2ch OFDM(ISDB-T) + 2ch 8PSK(ISDB-S) demodulator frontend for Earthsoft PT3
  *
- * Copyright (C) 2014 Akihiro Tsukada <tskd08@gmail.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation version 2.
+ * Copyright (C) 2014 Budi Rachmanto, AreMa Inc. <info@are.ma>
  *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
  *
  * This program is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
@@ -14,827 +14,535 @@
  * GNU General Public License for more details.
  */
 
-/*
- * NOTICE:
- * This driver is incomplete and lacks init/config of the chips,
- * as the necessary info is not disclosed.
- * It assumes that users of this driver (such as a PCI bridge of
- * DTV receiver cards) properly init and configure the chip
- * via I2C *before* calling this driver's init() function.
- *
- * Currently, PT3 driver is the only one that uses this driver,
- * and contains init/config code in its firmware.
- * Thus some part of the code might be dependent on PT3 specific config.
- */
-
-#include <linux/kernel.h>
-#include <linux/math64.h>
-#include <linux/dvb/frontend.h>
 #include "dvb_math.h"
+#include "dvb_frontend.h"
 #include "tc90522.h"
 
-#define TC90522_I2C_THRU_REG 0xfe
-
-#define TC90522_MODULE_IDX(addr) (((u8)(addr) & 0x02U) >> 1)
+#define TC90522_PASSTHROUGH 0xfe
 
-struct tc90522_state {
-	struct tc90522_config cfg;
-	struct dvb_frontend fe;
-	struct i2c_client *i2c_client;
-	struct i2c_adapter tuner_i2c;
-
-	bool lna;
+enum tc90522_state {
+	TC90522_IDLE,
+	TC90522_SET_FREQUENCY,
+	TC90522_SET_MODULATION,
+	TC90522_TRACK,
+	TC90522_ABORT,
 };
 
-struct reg_val {
-	u8 reg;
-	u8 val;
+struct tc90522 {
+	struct dvb_frontend fe;
+	struct i2c_adapter *i2c;
+	fe_delivery_system_t type;
+	u8 idx, addr_demod;
+	s32 offset;
+	enum tc90522_state state;
 };
 
-static int
-reg_write(struct tc90522_state *state, const struct reg_val *regs, int num)
+int tc90522_write(struct dvb_frontend *fe, const u8 *data, int len)
 {
-	int i, ret;
-	struct i2c_msg msg;
-
-	ret = 0;
-	msg.addr = state->i2c_client->addr;
-	msg.flags = 0;
-	msg.len = 2;
-	for (i = 0; i < num; i++) {
-		msg.buf = (u8 *)&regs[i];
-		ret = i2c_transfer(state->i2c_client->adapter, &msg, 1);
-		if (ret == 0)
-			ret = -EIO;
-		if (ret < 0)
-			return ret;
-	}
-	return 0;
-}
-
-static int reg_read(struct tc90522_state *state, u8 reg, u8 *val, u8 len)
-{
-	struct i2c_msg msgs[2] = {
-		{
-			.addr = state->i2c_client->addr,
-			.flags = 0,
-			.buf = &reg,
-			.len = 1,
-		},
-		{
-			.addr = state->i2c_client->addr,
-			.flags = I2C_M_RD,
-			.buf = val,
-			.len = len,
-		},
+	struct tc90522 *demod = fe->demodulator_priv;
+	struct i2c_msg msg[] = {
+		{ .addr = demod->addr_demod, .flags = 0, .buf = (u8 *)data, .len = len, },
 	};
-	int ret;
-
-	ret = i2c_transfer(state->i2c_client->adapter, msgs, ARRAY_SIZE(msgs));
-	if (ret == ARRAY_SIZE(msgs))
-		ret = 0;
-	else if (ret >= 0)
-		ret = -EIO;
-	return ret;
-}
 
-static struct tc90522_state *cfg_to_state(struct tc90522_config *c)
-{
-	return container_of(c, struct tc90522_state, cfg);
+	if (!data || !len)
+		return -EINVAL;
+	return i2c_transfer(demod->i2c, msg, 1) == 1 ? 0 : -EREMOTEIO;
 }
 
-
-static int tc90522s_set_tsid(struct dvb_frontend *fe)
+int tc90522_write_data(struct dvb_frontend *fe, u8 addr_data, u8 *data, u8 len)
 {
-	struct reg_val set_tsid[] = {
-		{ 0x8f, 00 },
-		{ 0x90, 00 }
-	};
+	u8 buf[len + 1];
 
-	set_tsid[0].val = (fe->dtv_property_cache.stream_id & 0xff00) >> 8;
-	set_tsid[1].val = fe->dtv_property_cache.stream_id & 0xff;
-	return reg_write(fe->demodulator_priv, set_tsid, ARRAY_SIZE(set_tsid));
+	buf[0] = addr_data;
+	memcpy(buf + 1, data, len);
+	return tc90522_write(fe, buf, len + 1);
 }
 
-static int tc90522t_set_layers(struct dvb_frontend *fe)
+int tc90522_read(struct tc90522 *demod, u8 addr, u8 *buf, u8 len)
 {
-	struct reg_val rv;
-	u8 laysel;
-
-	laysel = ~fe->dtv_property_cache.isdbt_layer_enabled & 0x07;
-	laysel = (laysel & 0x01) << 2 | (laysel & 0x02) | (laysel & 0x04) >> 2;
-	rv.reg = 0x71;
-	rv.val = laysel;
-	return reg_write(fe->demodulator_priv, &rv, 1);
+	struct i2c_msg msg[] = {
+		{ .addr = demod->addr_demod, .flags = 0,	.buf = buf, .len = 1,	},
+		{ .addr = demod->addr_demod, .flags = I2C_M_RD,	.buf = buf, .len = len,	},
+	};
+	if (!buf || !len)
+		return -EINVAL;
+	buf[0] = addr;
+	return i2c_transfer(demod->i2c, msg, 2) == 2 ? 0 : -EREMOTEIO;
 }
 
-/* frontend ops */
+u64 tc90522_n2int(const u8 *data, u8 n)		/* convert n_bytes data from stream (network byte order) to integer */
+{						/* can't use <arpa/inet.h>'s ntoh*() as sometimes n = 3,5,...       */
+	u32 i, val = 0;
 
-static int tc90522s_read_status(struct dvb_frontend *fe, fe_status_t *status)
-{
-	struct tc90522_state *state;
-	int ret;
-	u8 reg;
-
-	state = fe->demodulator_priv;
-	ret = reg_read(state, 0xc3, &reg, 1);
-	if (ret < 0)
-		return ret;
-
-	*status = 0;
-	if (reg & 0x80) /* input level under min ? */
-		return 0;
-	*status |= FE_HAS_SIGNAL;
-
-	if (reg & 0x60) /* carrier? */
-		return 0;
-	*status |= FE_HAS_CARRIER | FE_HAS_VITERBI | FE_HAS_SYNC;
-
-	if (reg & 0x10)
-		return 0;
-	if (reg_read(state, 0xc5, &reg, 1) < 0 || !(reg & 0x03))
-		return 0;
-	*status |= FE_HAS_LOCK;
-	return 0;
+	for (i = 0; i < n; i++) {
+		val <<= 8;
+		val |= data[i];
+	}
+	return val;
 }
 
-static int tc90522t_read_status(struct dvb_frontend *fe, fe_status_t *status)
+int tc90522_read_id_s(struct tc90522 *demod, u16 *id)
 {
-	struct tc90522_state *state;
-	int ret;
-	u8 reg;
-
-	state = fe->demodulator_priv;
-	ret = reg_read(state, 0x96, &reg, 1);
-	if (ret < 0)
-		return ret;
-
-	*status = 0;
-	if (reg & 0xe0) {
-		*status = FE_HAS_SIGNAL | FE_HAS_CARRIER | FE_HAS_VITERBI
-				| FE_HAS_SYNC | FE_HAS_LOCK;
-		return 0;
-	}
-
-	ret = reg_read(state, 0x80, &reg, 1);
-	if (ret < 0)
-		return ret;
-
-	if (reg & 0xf0)
-		return 0;
-	*status |= FE_HAS_SIGNAL | FE_HAS_CARRIER;
+	u8 buf[2];
+	int err = tc90522_read(demod, 0xe6, buf, 2);
 
-	if (reg & 0x0c)
-		return 0;
-	*status |= FE_HAS_SYNC | FE_HAS_VITERBI;
-
-	if (reg & 0x02)
-		return 0;
-	*status |= FE_HAS_LOCK;
-	return 0;
+	if (!err)
+		*id = tc90522_n2int(buf, 2);
+	return err;
 }
 
-static const fe_code_rate_t fec_conv_sat[] = {
-	FEC_NONE, /* unused */
-	FEC_1_2, /* for BPSK */
-	FEC_1_2, FEC_2_3, FEC_3_4, FEC_5_6, FEC_7_8, /* for QPSK */
-	FEC_2_3, /* for 8PSK. (trellis code) */
+struct tmcc_s {			/* Transmission and Multiplexing Configuration Control */
+	u32 mode[4];
+	u32 slot[4];
+	u32 id[8];
 };
 
-static int tc90522s_get_frontend(struct dvb_frontend *fe)
+int tc90522_read_tmcc_s(struct tc90522 *demod, struct tmcc_s *tmcc)
 {
-	struct tc90522_state *state;
-	struct dtv_frontend_properties *c;
-	struct dtv_fe_stats *stats;
-	int ret, i;
-	int layers;
-	u8 val[10];
-	u32 cndat;
-
-	state = fe->demodulator_priv;
-	c = &fe->dtv_property_cache;
-	c->delivery_system = SYS_ISDBS;
-
-	layers = 0;
-	ret = reg_read(state, 0xe8, val, 3);
-	if (ret == 0) {
-		int slots;
-		u8 v;
-
-		/* high/single layer */
-		v = (val[0] & 0x70) >> 4;
-		c->modulation = (v == 7) ? PSK_8 : QPSK;
-		c->fec_inner = fec_conv_sat[v];
-		c->layer[0].fec = c->fec_inner;
-		c->layer[0].modulation = c->modulation;
-		c->layer[0].segment_count = val[1] & 0x3f; /* slots */
-
-		/* low layer */
-		v = (val[0] & 0x07);
-		c->layer[1].fec = fec_conv_sat[v];
-		if (v == 0)  /* no low layer */
-			c->layer[1].segment_count = 0;
-		else
-			c->layer[1].segment_count = val[2] & 0x3f; /* slots */
-		/* actually, BPSK if v==1, but not defined in fe_modulation_t */
-		c->layer[1].modulation = QPSK;
-		layers = (v > 0) ? 2 : 1;
-
-		slots =  c->layer[0].segment_count +  c->layer[1].segment_count;
-		c->symbol_rate = 28860000 * slots / 48;
-	}
-
-	/* statistics */
-
-	stats = &c->strength;
-	stats->len = 0;
-	/* let the connected tuner set RSSI property cache */
-	if (fe->ops.tuner_ops.get_rf_strength) {
-		u16 dummy;
-
-		fe->ops.tuner_ops.get_rf_strength(fe, &dummy);
-	}
-
-	stats = &c->cnr;
-	stats->len = 1;
-	stats->stat[0].scale = FE_SCALE_NOT_AVAILABLE;
-	cndat = 0;
-	ret = reg_read(state, 0xbc, val, 2);
-	if (ret == 0)
-		cndat = val[0] << 8 | val[1];
-	if (cndat >= 3000) {
-		u32 p, p4;
-		s64 cn;
-
-		cndat -= 3000;  /* cndat: 4.12 fixed point float */
-		/*
-		 * cnr[mdB] = -1634.6 * P^5 + 14341 * P^4 - 50259 * P^3
-		 *                 + 88977 * P^2 - 89565 * P + 58857
-		 *  (P = sqrt(cndat) / 64)
-		 */
-		/* p := sqrt(cndat) << 8 = P << 14, 2.14 fixed  point float */
-		/* cn = cnr << 3 */
-		p = int_sqrt(cndat << 16);
-		p4 = cndat * cndat;
-		cn = div64_s64(-16346LL * p4 * p, 10) >> 35;
-		cn += (14341LL * p4) >> 21;
-		cn -= (50259LL * cndat * p) >> 23;
-		cn += (88977LL * cndat) >> 9;
-		cn -= (89565LL * p) >> 11;
-		cn += 58857  << 3;
-		stats->stat[0].svalue = cn >> 3;
-		stats->stat[0].scale = FE_SCALE_DECIBEL;
-	}
-
-	/* per-layer post viterbi BER (or PER? config dependent?) */
-	stats = &c->post_bit_error;
-	memset(stats, 0, sizeof(*stats));
-	stats->len = layers;
-	ret = reg_read(state, 0xeb, val, 10);
-	if (ret < 0)
-		for (i = 0; i < layers; i++)
-			stats->stat[i].scale = FE_SCALE_NOT_AVAILABLE;
-	else {
-		for (i = 0; i < layers; i++) {
-			stats->stat[i].scale = FE_SCALE_COUNTER;
-			stats->stat[i].uvalue = val[i * 5] << 16
-				| val[i * 5 + 1] << 8 | val[i * 5 + 2];
-		}
-	}
-	stats = &c->post_bit_count;
-	memset(stats, 0, sizeof(*stats));
-	stats->len = layers;
-	if (ret < 0)
-		for (i = 0; i < layers; i++)
-			stats->stat[i].scale = FE_SCALE_NOT_AVAILABLE;
-	else {
-		for (i = 0; i < layers; i++) {
-			stats->stat[i].scale = FE_SCALE_COUNTER;
-			stats->stat[i].uvalue =
-				val[i * 5 + 3] << 8 | val[i * 5 + 4];
-			stats->stat[i].uvalue *= 204 * 8;
-		}
+	enum {
+		BASE = 0xc5,
+		SIZE = 0xe5 - BASE + 1
+	};
+	u8 data[SIZE];
+	u32 i, byte_offset, bit_offset;
+
+	int err = tc90522_read(demod, 0xc3, data, 1)	||
+		((data[0] >> 4) & 1)			||
+		tc90522_read(demod, 0xce, data, 2)	||
+		(tc90522_n2int(data, 2) == 0)		||
+		tc90522_read(demod, 0xc3, data, 1)	||
+		tc90522_read(demod, 0xc5, data, SIZE);
+	if (err)
+		return err;
+	for (i = 0; i < 4; i++) {
+		byte_offset = i >> 1;
+		bit_offset = (i & 1) ? 0 : 4;
+		tmcc->mode[i] = (data[0xc8 + byte_offset - BASE] >> bit_offset) & 0b00001111;
+		tmcc->slot[i] = (data[0xca + i           - BASE] >>          0) & 0b00111111;
 	}
-
+	for (i = 0; i < 8; i++)
+		tmcc->id[i] = tc90522_n2int(data + 0xce + i * 2 - BASE, 2);
 	return 0;
 }
 
-
-static const fe_transmit_mode_t tm_conv[] = {
-	TRANSMISSION_MODE_2K,
-	TRANSMISSION_MODE_4K,
-	TRANSMISSION_MODE_8K,
-	0
+enum tc90522_pwr {
+	TC90522_PWR_OFF		= 0x00,
+	TC90522_PWR_AMP_ON	= 0x04,
+	TC90522_PWR_TUNER_ON	= 0x40,
 };
 
-static const fe_code_rate_t fec_conv_ter[] = {
-	FEC_1_2, FEC_2_3, FEC_3_4, FEC_5_6, FEC_7_8, 0, 0, 0
-};
+int tc90522_set_powers(struct tc90522 *demod, enum tc90522_pwr pwr)
+{
+	u8 data = pwr | 0b10011001;
 
-static const fe_modulation_t mod_conv[] = {
-	DQPSK, QPSK, QAM_16, QAM_64, 0, 0, 0, 0
-};
+	dev_dbg(&demod->i2c->dev, "%s #%d %s tuner %s amp %s\n", demod->i2c->name, demod->idx, __func__, pwr & TC90522_PWR_TUNER_ON ?
+		"ON" : "OFF", pwr & TC90522_PWR_AMP_ON ? "ON" : "OFF");
+	return tc90522_write_data(&demod->fe, 0x1e, &data, 1);
+}
 
-static int tc90522t_get_frontend(struct dvb_frontend *fe)
+/* dvb_frontend_ops */
+int tc90522_get_frontend_algo(struct dvb_frontend *fe)
 {
-	struct tc90522_state *state;
-	struct dtv_frontend_properties *c;
-	struct dtv_fe_stats *stats;
-	int ret, i;
-	int layers;
-	u8 val[15], mode;
-	u32 cndat;
-
-	state = fe->demodulator_priv;
-	c = &fe->dtv_property_cache;
-	c->delivery_system = SYS_ISDBT;
-	c->bandwidth_hz = 6000000;
-	mode = 1;
-	ret = reg_read(state, 0xb0, val, 1);
-	if (ret == 0) {
-		mode = (val[0] & 0xc0) >> 2;
-		c->transmission_mode = tm_conv[mode];
-		c->guard_interval = (val[0] & 0x30) >> 4;
-	}
-
-	ret = reg_read(state, 0xb2, val, 6);
-	layers = 0;
-	if (ret == 0) {
-		u8 v;
-
-		c->isdbt_partial_reception = val[0] & 0x01;
-		c->isdbt_sb_mode = (val[0] & 0xc0) == 0x01;
-
-		/* layer A */
-		v = (val[2] & 0x78) >> 3;
-		if (v == 0x0f)
-			c->layer[0].segment_count = 0;
-		else {
-			layers++;
-			c->layer[0].segment_count = v;
-			c->layer[0].fec = fec_conv_ter[(val[1] & 0x1c) >> 2];
-			c->layer[0].modulation = mod_conv[(val[1] & 0xe0) >> 5];
-			v = (val[1] & 0x03) << 1 | (val[2] & 0x80) >> 7;
-			c->layer[0].interleaving = v;
-		}
+	return DVBFE_ALGO_HW;
+}
 
-		/* layer B */
-		v = (val[3] & 0x03) << 1 | (val[4] & 0xc0) >> 6;
-		if (v == 0x0f)
-			c->layer[1].segment_count = 0;
-		else {
-			layers++;
-			c->layer[1].segment_count = v;
-			c->layer[1].fec = fec_conv_ter[(val[3] & 0xe0) >> 5];
-			c->layer[1].modulation = mod_conv[(val[2] & 0x07)];
-			c->layer[1].interleaving = (val[3] & 0x1c) >> 2;
-		}
+int tc90522_sleep(struct dvb_frontend *fe)
+{
+	struct tc90522 *demod = fe->demodulator_priv;
 
-		/* layer C */
-		v = (val[5] & 0x1e) >> 1;
-		if (v == 0x0f)
-			c->layer[2].segment_count = 0;
-		else {
-			layers++;
-			c->layer[2].segment_count = v;
-			c->layer[2].fec = fec_conv_ter[(val[4] & 0x07)];
-			c->layer[2].modulation = mod_conv[(val[4] & 0x38) >> 3];
-			c->layer[2].interleaving = (val[5] & 0xe0) >> 5;
-		}
-	}
+	dev_dbg(&demod->i2c->dev, "%s #%d %s %s\n", demod->i2c->name, demod->idx, __func__, demod->type == SYS_ISDBS ? "S" : "T");
+	return fe->ops.tuner_ops.sleep(fe);
+}
 
-	/* statistics */
+int tc90522_wakeup(struct dvb_frontend *fe)
+{
+	struct tc90522 *demod = fe->demodulator_priv;
 
-	stats = &c->strength;
-	stats->len = 0;
-	/* let the connected tuner set RSSI property cache */
-	if (fe->ops.tuner_ops.get_rf_strength) {
-		u16 dummy;
+	dev_dbg(&demod->i2c->dev, "%s #%d %s %s\n", demod->i2c->name, demod->idx, __func__, demod->type == SYS_ISDBS ? "S" : "T");
+	demod->state = TC90522_IDLE;
+	return fe->ops.tuner_ops.init(fe);
+}
 
-		fe->ops.tuner_ops.get_rf_strength(fe, &dummy);
-	}
+void tc90522_release(struct dvb_frontend *fe)
+{
+	struct tc90522 *demod = fe->demodulator_priv;
 
-	stats = &c->cnr;
-	stats->len = 1;
-	stats->stat[0].scale = FE_SCALE_NOT_AVAILABLE;
-	cndat = 0;
-	ret = reg_read(state, 0x8b, val, 3);
-	if (ret == 0)
-		cndat = val[0] << 16 | val[1] << 8 | val[2];
-	if (cndat != 0) {
-		u32 p, tmp;
-		s64 cn;
-
-		/*
-		 * cnr[mdB] = 0.024 P^4 - 1.6 P^3 + 39.8 P^2 + 549.1 P + 3096.5
-		 * (P = 10log10(5505024/cndat))
-		 */
-		/* cn = cnr << 3 (61.3 fixed point float */
-		/* p = 10log10(5505024/cndat) << 24  (8.24 fixed point float)*/
-		p = intlog10(5505024) - intlog10(cndat);
-		p *= 10;
-
-		cn = 24772;
-		cn += div64_s64(43827LL * p, 10) >> 24;
-		tmp = p >> 8;
-		cn += div64_s64(3184LL * tmp * tmp, 10) >> 32;
-		tmp = p >> 13;
-		cn -= div64_s64(128LL * tmp * tmp * tmp, 10) >> 33;
-		tmp = p >> 18;
-		cn += div64_s64(192LL * tmp * tmp * tmp * tmp, 1000) >> 24;
-
-		stats->stat[0].svalue = cn >> 3;
-		stats->stat[0].scale = FE_SCALE_DECIBEL;
-	}
+	dev_dbg(&demod->i2c->dev, "%s #%d %s\n", demod->i2c->name, demod->idx, __func__);
+	tc90522_set_powers(demod, TC90522_PWR_OFF);
+	tc90522_sleep(fe);
+}
 
-	/* per-layer post viterbi BER (or PER? config dependent?) */
-	stats = &c->post_bit_error;
-	memset(stats, 0, sizeof(*stats));
-	stats->len = layers;
-	ret = reg_read(state, 0x9d, val, 15);
-	if (ret < 0)
-		for (i = 0; i < layers; i++)
-			stats->stat[i].scale = FE_SCALE_NOT_AVAILABLE;
-	else {
-		for (i = 0; i < layers; i++) {
-			stats->stat[i].scale = FE_SCALE_COUNTER;
-			stats->stat[i].uvalue = val[i * 3] << 16
-				| val[i * 3 + 1] << 8 | val[i * 3 + 2];
-		}
-	}
-	stats = &c->post_bit_count;
-	memset(stats, 0, sizeof(*stats));
-	stats->len = layers;
-	if (ret < 0)
-		for (i = 0; i < layers; i++)
-			stats->stat[i].scale = FE_SCALE_NOT_AVAILABLE;
-	else {
-		for (i = 0; i < layers; i++) {
-			stats->stat[i].scale = FE_SCALE_COUNTER;
-			stats->stat[i].uvalue =
-				val[9 + i * 2] << 8 | val[9 + i * 2 + 1];
-			stats->stat[i].uvalue *= 204 * 8;
-		}
-	}
+s64 tc90522_get_cn_raw(struct tc90522 *demod)
+{
+	u8 buf[3], buflen = demod->type == SYS_ISDBS ? 2 : 3, addr = demod->type == SYS_ISDBS ? 0xbc : 0x8b;
+	int err = tc90522_read(demod, addr, buf, buflen);
 
-	return 0;
+	return err < 0 ? err : tc90522_n2int(buf, buflen);
 }
 
-static const struct reg_val reset_sat = { 0x03, 0x01 };
-static const struct reg_val reset_ter = { 0x01, 0x40 };
-
-static int tc90522_set_frontend(struct dvb_frontend *fe)
+s64 tc90522_get_cn_s(s64 raw)	/* @ .0001 dB */
 {
-	struct tc90522_state *state;
-	int ret;
-
-	state = fe->demodulator_priv;
-
-	if (fe->ops.tuner_ops.set_params)
-		ret = fe->ops.tuner_ops.set_params(fe);
-	else
-		ret = -ENODEV;
-	if (ret < 0)
-		goto failed;
-
-	if (fe->ops.delsys[0] == SYS_ISDBS) {
-		ret = tc90522s_set_tsid(fe);
-		if (ret < 0)
-			goto failed;
-		ret = reg_write(state, &reset_sat, 1);
-	} else {
-		ret = tc90522t_set_layers(fe);
-		if (ret < 0)
-			goto failed;
-		ret = reg_write(state, &reset_ter, 1);
-	}
-	if (ret < 0)
-		goto failed;
+	s64 x, y;
+
+	raw -= 3000;
+	if (raw < 0)
+		raw = 0;
+	x = int_sqrt(raw << 20);
+	y = 16346ll * x - (143410ll << 16);
+	y = ((x * y) >> 16) + (502590ll << 16);
+	y = ((x * y) >> 16) - (889770ll << 16);
+	y = ((x * y) >> 16) + (895650ll << 16);
+	y = (588570ll << 16) - ((x * y) >> 16);
+	return y < 0 ? 0 : y >> 16;
+}
 
-	return 0;
+s64 tc90522_get_cn_t(s64 raw)	/* @ .0001 dB */
+{
+	s64 x, y;
 
-failed:
-	dev_warn(&state->tuner_i2c.dev, "(%s) failed. [adap%d-fe%d]\n",
-			__func__, fe->dvb->num, fe->id);
-	return ret;
+	if (!raw)
+		return 0;
+	x = (1130911733ll - 10ll * intlog10(raw)) >> 2;
+	y = (x >> 2) - (x >> 6) + (x >> 8) + (x >> 9) - (x >> 10) + (x >> 11) + (x >> 12) - (16ll << 22);
+	y = ((x * y) >> 22) + (398ll << 22);
+	y = ((x * y) >> 22) + (5491ll << 22);
+	y = ((x * y) >> 22) + (30965ll << 22);
+	return y >> 22;
 }
 
-static int tc90522_get_tune_settings(struct dvb_frontend *fe,
-	struct dvb_frontend_tune_settings *settings)
+int tc90522_read_snr(struct dvb_frontend *fe, u16 *cn)	/* raw C/N, digitally modulated S/N ratio */
 {
-	if (fe->ops.delsys[0] == SYS_ISDBS) {
-		settings->min_delay_ms = 250;
-		settings->step_size = 1000;
-		settings->max_drift = settings->step_size * 2;
-	} else {
-		settings->min_delay_ms = 400;
-		settings->step_size = 142857;
-		settings->max_drift = settings->step_size;
-	}
-	return 0;
+	struct tc90522 *demod = fe->demodulator_priv;
+	s64 err = tc90522_get_cn_raw(demod);
+	*cn = err < 0 ? 0 : err;
+	dev_dbg(&demod->i2c->dev, "%s v3 CN %d (%lld dB)\n", demod->i2c->name, (int)*cn,
+		demod->type == SYS_ISDBS ? (int64_t)tc90522_get_cn_s(*cn) : (int64_t)tc90522_get_cn_t(*cn));
+	return err < 0 ? err : 0;
 }
 
-static int tc90522_set_if_agc(struct dvb_frontend *fe, bool on)
+int tc90522_read_status(struct dvb_frontend *fe, fe_status_t *status)
 {
-	struct reg_val agc_sat[] = {
-		{ 0x0a, 0x00 },
-		{ 0x10, 0x30 },
-		{ 0x11, 0x00 },
-		{ 0x03, 0x01 },
-	};
-	struct reg_val agc_ter[] = {
-		{ 0x25, 0x00 },
-		{ 0x23, 0x4c },
-		{ 0x01, 0x40 },
-	};
-	struct tc90522_state *state;
-	struct reg_val *rv;
-	int num;
-
-	state = fe->demodulator_priv;
-	if (fe->ops.delsys[0] == SYS_ISDBS) {
-		agc_sat[0].val = on ? 0xff : 0x00;
-		agc_sat[1].val |= 0x80;
-		agc_sat[1].val |= on ? 0x01 : 0x00;
-		agc_sat[2].val |= on ? 0x40 : 0x00;
-		rv = agc_sat;
-		num = ARRAY_SIZE(agc_sat);
-	} else {
-		agc_ter[0].val = on ? 0x40 : 0x00;
-		agc_ter[1].val |= on ? 0x00 : 0x01;
-		rv = agc_ter;
-		num = ARRAY_SIZE(agc_ter);
+	struct tc90522 *demod = fe->demodulator_priv;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+	s64 err = tc90522_get_cn_raw(demod),
+	    raw = err < 0 ? 0 : err;
+
+	switch (demod->state) {
+	case TC90522_IDLE:
+	case TC90522_SET_FREQUENCY:
+		*status = 0;
+		break;
+
+	case TC90522_SET_MODULATION:
+	case TC90522_ABORT:
+		*status |= FE_HAS_SIGNAL;
+		break;
+
+	case TC90522_TRACK:
+		*status |= FE_HAS_SIGNAL | FE_HAS_CARRIER | FE_HAS_LOCK;
+		break;
 	}
-	return reg_write(state, rv, num);
-}
 
-static const struct reg_val sleep_sat = { 0x17, 0x01 };
-static const struct reg_val sleep_ter = { 0x03, 0x90 };
+	c->cnr.len = 1;
+	c->cnr.stat[0].svalue = demod->type == SYS_ISDBS ? tc90522_get_cn_s(raw) : tc90522_get_cn_t(raw);
+	c->cnr.stat[0].scale = FE_SCALE_DECIBEL;
+	dev_dbg(&demod->i2c->dev, "%s v5 CN %lld (%lld dB)\n", demod->i2c->name, raw, c->cnr.stat[0].svalue);
+	return err < 0 ? err : 0;
+}
 
-static int tc90522_sleep(struct dvb_frontend *fe)
+/**** ISDB-S ****/
+int tc90522_tune_s(struct dvb_frontend *fe, bool re_tune, unsigned int mode_flags, unsigned int *delay, fe_status_t *status)
 {
-	struct tc90522_state *state;
-	int ret;
-
-	state = fe->demodulator_priv;
-	if (fe->ops.delsys[0] == SYS_ISDBS)
-		ret = reg_write(state, &sleep_sat, 1);
-	else {
-		ret = reg_write(state, &sleep_ter, 1);
-		if (ret == 0 && fe->ops.set_lna &&
-		    fe->dtv_property_cache.lna == LNA_AUTO) {
-			fe->dtv_property_cache.lna = 0;
-			ret = fe->ops.set_lna(fe);
-			fe->dtv_property_cache.lna = LNA_AUTO;
-		}
-	}
-	if (ret < 0)
-		dev_warn(&state->tuner_i2c.dev,
-			"(%s) failed. [adap%d-fe%d]\n",
-			__func__, fe->dvb->num, fe->id);
-	return ret;
-}
+	struct tc90522 *demod = fe->demodulator_priv;
+	struct tmcc_s tmcc;
+	int i, err,
+	    freq = fe->dtv_property_cache.frequency,
+	    tsid = fe->dtv_property_cache.stream_id;
+	u8 id_s[2];
+
+	if (re_tune)
+		demod->state = TC90522_SET_FREQUENCY;
+
+	switch (demod->state) {
+	case TC90522_IDLE:
+		*delay = msecs_to_jiffies(2000);
+		*status = 0;
+		return 0;
 
-static const struct reg_val wakeup_sat = { 0x17, 0x00 };
-static const struct reg_val wakeup_ter = { 0x03, 0x80 };
+	case TC90522_SET_FREQUENCY:
+		dev_dbg(&demod->i2c->dev, "%s #%d tsid 0x%x freq %d\n", demod->i2c->name, demod->idx, tsid, freq);
+		err = fe->ops.tuner_ops.set_frequency(fe, freq);
+		if (err)
+			return err;
+		demod->offset = 0;
+		demod->state = TC90522_SET_MODULATION;
+		*delay = 0;
+		*status = FE_HAS_SIGNAL;
+		return 0;
 
-static int tc90522_init(struct dvb_frontend *fe)
-{
-	struct tc90522_state *state;
-	int ret;
-
-	/*
-	 * Because the init sequence is not public,
-	 * the parent device/driver should have init'ed the device before.
-	 * just wake up the device here.
-	 */
-
-	state = fe->demodulator_priv;
-	if (fe->ops.delsys[0] == SYS_ISDBS)
-		ret = reg_write(state, &wakeup_sat, 1);
-	else {
-		ret = reg_write(state, &wakeup_ter, 1);
-		if (ret == 0 && fe->ops.set_lna &&
-		    fe->dtv_property_cache.lna == LNA_AUTO) {
-			fe->dtv_property_cache.lna = 1;
-			ret = fe->ops.set_lna(fe);
-			fe->dtv_property_cache.lna = LNA_AUTO;
+	case TC90522_SET_MODULATION:
+		for (i = 0; i < 1000; i++) {
+			err = tc90522_read_tmcc_s(demod, &tmcc);
+			if (!err)
+				break;
+			msleep_interruptible(1);
 		}
-	}
-	if (ret < 0) {
-		dev_warn(&state->tuner_i2c.dev,
-			"(%s) failed. [adap%d-fe%d]\n",
-			__func__, fe->dvb->num, fe->id);
-		return ret;
-	}
-
-	/* prefer 'all-layers' to 'none' as a default */
-	if (fe->dtv_property_cache.isdbt_layer_enabled == 0)
-		fe->dtv_property_cache.isdbt_layer_enabled = 7;
-	return tc90522_set_if_agc(fe, true);
-}
+		if (err) {
+			dev_dbg(&demod->i2c->dev, "%s fail tc_read_tmcc_s err=0x%x\n", demod->i2c->name, err);
+			demod->state = TC90522_ABORT;
+			*delay = msecs_to_jiffies(1000);
+			return err;
+		}
+		dev_dbg(&demod->i2c->dev, "%s slots=%d,%d,%d,%d mode=%d,%d,%d,%d tmcc.id=0x%x,0x%x,0x%x,0x%x,0x%x,0x%x,0x%x,0x%x\n",
+				demod->i2c->name,
+				tmcc.slot[0], tmcc.slot[1], tmcc.slot[2], tmcc.slot[3],
+				tmcc.mode[0], tmcc.mode[1], tmcc.mode[2], tmcc.mode[3],
+				tmcc.id[0], tmcc.id[1], tmcc.id[2], tmcc.id[3],
+				tmcc.id[4], tmcc.id[5], tmcc.id[6], tmcc.id[7]);
+		for (i = 0; i < ARRAY_SIZE(tmcc.id); i++) {
+			dev_dbg(&demod->i2c->dev, "%s tsid %x i %d tmcc.id %x\n", demod->i2c->name, tsid, i, tmcc.id[i]);
+			if (tmcc.id[i] == tsid)
+				break;
+		}
+		if (tsid < ARRAY_SIZE(tmcc.id))		/* treat as slot# */
+			i = tsid;
+		if (i == ARRAY_SIZE(tmcc.id)) {
+			dev_dbg(&demod->i2c->dev, "%s #%d i%d tsid 0x%x not found\n", demod->i2c->name, demod->idx, i, tsid);
+			return -EINVAL;
+		}
+		demod->offset = i;
+		dev_dbg(&demod->i2c->dev, "%s #%d found tsid 0x%x on slot %d\n", demod->i2c->name, demod->idx, tsid, i);
+
+		id_s[0] = (tmcc.id[demod->offset] >> 8)	& 0xff;
+		id_s[1] = tmcc.id[demod->offset]	& 0xff;
+		err = tc90522_write_data(fe, 0x8f, id_s, sizeof(id_s));
+		if (err) {
+			dev_dbg(&demod->i2c->dev, "%s fail set_tmcc_s err=%d\n", demod->i2c->name, err);
+			return err;
+		}
+		for (i = 0; i < 1000; i++) {
+			u16 short_id;
+
+			err = tc90522_read_id_s(demod, &short_id);
+			if (err) {
+				dev_dbg(&demod->i2c->dev, "%s fail get_id_s err=%d\n", demod->i2c->name, err);
+				return err;
+			}
+			tsid = short_id;
+			dev_dbg(&demod->i2c->dev, "%s #%d tsid=0x%x\n", demod->i2c->name, demod->idx, tsid);
+			if ((tsid & 0xffff) == tmcc.id[demod->offset])
+				break;
+			msleep_interruptible(1);
+		}
+		demod->state = TC90522_TRACK;
+		/* fallthrough */
 
+	case TC90522_TRACK:
+		*delay = msecs_to_jiffies(2000);
+		*status = FE_HAS_SIGNAL | FE_HAS_CARRIER | FE_HAS_LOCK;
+		return 0;
 
-/*
- * tuner I2C adapter functions
- */
+	case TC90522_ABORT:
+		*delay = msecs_to_jiffies(2000);
+		*status = FE_HAS_SIGNAL;
+		return 0;
+	}
+	return -ERANGE;
+}
 
-static int
-tc90522_master_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs, int num)
+int tc90522_read_tuner_s(struct dvb_frontend *fe, u8 *addr, int len)
 {
-	struct tc90522_state *state;
-	struct i2c_msg *new_msgs;
-	int i, j;
-	int ret, rd_num;
-	u8 wbuf[256];
-	u8 *p, *bufend;
-
-	if (num <= 0)
-		return -EINVAL;
+	struct tc90522 *demod = fe->demodulator_priv;
+	u8 buf[] = { TC90522_PASSTHROUGH, addr[0] << 1, addr[1], TC90522_PASSTHROUGH, (addr[0] << 1) | 1, 0 };
+	struct i2c_msg msg[] = {
+		{ .addr = demod->addr_demod, .flags = 0,	.buf = buf,	.len = 3, },
+		{ .addr = demod->addr_demod, .flags = 0,	.buf = buf + 3,	.len = 2, },
+		{ .addr = demod->addr_demod, .flags = I2C_M_RD,	.buf = buf + 5,	.len = 1, },
+	};
 
-	rd_num = 0;
-	for (i = 0; i < num; i++)
-		if (msgs[i].flags & I2C_M_RD)
-			rd_num++;
-	new_msgs = kmalloc(sizeof(*new_msgs) * (num + rd_num), GFP_KERNEL);
-	if (!new_msgs)
-		return -ENOMEM;
+	if (!addr || (len != 2))
+		return -EINVAL;
+	return i2c_transfer(demod->i2c, msg, 3) == 3 ? buf[5] : -EREMOTEIO;
+}
 
-	state = i2c_get_adapdata(adap);
-	p = wbuf;
-	bufend = wbuf + sizeof(wbuf);
-	for (i = 0, j = 0; i < num; i++, j++) {
-		new_msgs[j].addr = state->i2c_client->addr;
-		new_msgs[j].flags = msgs[i].flags;
+static struct dvb_frontend_ops tc90522_ops_s = {
+	.delsys = { SYS_ISDBS },
+	.info = {
+		.name = "TC90522 ISDB-S",
+		.caps = FE_CAN_INVERSION_AUTO | FE_CAN_FEC_AUTO | FE_CAN_QAM_AUTO | FE_CAN_MULTISTREAM |
+			FE_CAN_TRANSMISSION_MODE_AUTO | FE_CAN_GUARD_INTERVAL_AUTO | FE_CAN_HIERARCHY_AUTO,
+	},
+	.init = tc90522_wakeup,
+	.sleep = tc90522_sleep,
+	.release = tc90522_release,
+	.write = tc90522_write,
+	.get_frontend_algo = tc90522_get_frontend_algo,
+	.read_snr = tc90522_read_snr,
+	.read_status = tc90522_read_status,
+	.tune = tc90522_tune_s,
+	.tuner_ops.calc_regs = tc90522_read_tuner_s,
+};
 
-		if (msgs[i].flags & I2C_M_RD) {
-			new_msgs[j].flags &= ~I2C_M_RD;
-			if (p + 2 > bufend)
-				break;
-			p[0] = TC90522_I2C_THRU_REG;
-			p[1] = msgs[i].addr << 1 | 0x01;
-			new_msgs[j].buf = p;
-			new_msgs[j].len = 2;
-			p += 2;
-			j++;
-			new_msgs[j].addr = state->i2c_client->addr;
-			new_msgs[j].flags = msgs[i].flags;
-			new_msgs[j].buf = msgs[i].buf;
-			new_msgs[j].len = msgs[i].len;
-			continue;
+/**** ISDB-T ****/
+int tc90522_get_tmcc_t(struct tc90522 *demod)
+{
+	u8 buf;
+	u16 i = 65535;
+	bool b = false, retryov, fulock;
+
+	while (i--) {
+		if (tc90522_read(demod, 0x80, &buf, 1))
+			return -EBADMSG;
+		retryov = buf & 0b10000000 ? true : false;
+		fulock  = buf & 0b00001000 ? true : false;
+		if (!fulock) {
+			b = true;
+			break;
 		}
-
-		if (p + msgs[i].len + 2 > bufend)
+		if (retryov)
 			break;
-		p[0] = TC90522_I2C_THRU_REG;
-		p[1] = msgs[i].addr << 1;
-		memcpy(p + 2, msgs[i].buf, msgs[i].len);
-		new_msgs[j].buf = p;
-		new_msgs[j].len = msgs[i].len + 2;
-		p += new_msgs[j].len;
+		msleep_interruptible(1);
 	}
-
-	if (i < num)
-		ret = -ENOMEM;
-	else
-		ret = i2c_transfer(state->i2c_client->adapter, new_msgs, j);
-	if (ret >= 0 && ret < j)
-		ret = -EIO;
-	kfree(new_msgs);
-	return (ret == j) ? num : ret;
+	return b ? 0 : -EBADMSG;
 }
 
-static u32 tc90522_functionality(struct i2c_adapter *adap)
+int tc90522_tune_t(struct dvb_frontend *fe, bool re_tune, unsigned int mode_flags, unsigned int *delay, fe_status_t *status)
 {
-	return I2C_FUNC_I2C;
-}
+	struct tc90522 *demod = fe->demodulator_priv;
+	int err, i;
 
-static const struct i2c_algorithm tc90522_tuner_i2c_algo = {
-	.master_xfer   = &tc90522_master_xfer,
-	.functionality = &tc90522_functionality,
-};
+	if (re_tune)
+		demod->state = TC90522_SET_FREQUENCY;
 
+	switch (demod->state) {
+	case TC90522_IDLE:
+		*delay = msecs_to_jiffies(2000);
+		*status = 0;
+		return 0;
 
-/*
- * I2C driver functions
- */
+	case TC90522_SET_FREQUENCY:
+		if (fe->ops.tuner_ops.set_frequency(fe, fe->dtv_property_cache.frequency)) {
+			*delay = msecs_to_jiffies(1000);
+			*status = 0;
+			return 0;
+		}
+		demod->state = TC90522_SET_MODULATION;
+		*delay = 0;
+		*status = FE_HAS_SIGNAL;
+		return 0;
 
-static const struct dvb_frontend_ops tc90522_ops_sat = {
-	.delsys = { SYS_ISDBS },
-	.info = {
-		.name = "Toshiba TC90522 ISDB-S module",
-		.frequency_min =  950000,
-		.frequency_max = 2150000,
-		.caps = FE_CAN_INVERSION_AUTO | FE_CAN_FEC_AUTO |
-			FE_CAN_QAM_AUTO | FE_CAN_TRANSMISSION_MODE_AUTO |
-			FE_CAN_GUARD_INTERVAL_AUTO | FE_CAN_HIERARCHY_AUTO,
-	},
+	case TC90522_SET_MODULATION:
+		for (i = 0; i < 1000; i++) {
+			err = tc90522_get_tmcc_t(demod);
+			if (!err)
+				break;
+			msleep_interruptible(2);
+		}
+		if (err) {
+			dev_dbg(&demod->i2c->dev, "%s #%d fail get_tmcc_t err=%d\n", demod->i2c->name, demod->idx, err);
+				demod->state = TC90522_ABORT;
+				*delay = msecs_to_jiffies(1000);
+				return 0;
+		}
+		demod->state = TC90522_TRACK;
+		/* fallthrough */
 
-	.init = tc90522_init,
-	.sleep = tc90522_sleep,
-	.set_frontend = tc90522_set_frontend,
-	.get_tune_settings = tc90522_get_tune_settings,
+	case TC90522_TRACK:
+		*delay = msecs_to_jiffies(2000);
+		*status = FE_HAS_SIGNAL | FE_HAS_CARRIER | FE_HAS_LOCK;
+		return 0;
 
-	.get_frontend = tc90522s_get_frontend,
-	.read_status = tc90522s_read_status,
-};
+	case TC90522_ABORT:
+		*delay = msecs_to_jiffies(2000);
+		*status = FE_HAS_SIGNAL;
+		return 0;
+	}
+	return -ERANGE;
+}
+
+int tc90522_read_tuner_t(struct dvb_frontend *fe, u8 *addr, int len)
+{
+	struct tc90522 *demod = fe->demodulator_priv;
+	u8 buf[] = { TC90522_PASSTHROUGH, (addr[0] << 1) | 1, 0 };
+	struct i2c_msg msg[] = {
+		{ .addr = demod->addr_demod, .flags = 0,	.buf = buf,	.len = 2, },
+		{ .addr = demod->addr_demod, .flags = I2C_M_RD,	.buf = buf + 2,	.len = 1, },
+	};
+
+	if (!addr || (len != 1))
+		return -EINVAL;
+	return i2c_transfer(demod->i2c, msg, 2) == 2 ? buf[2] : -EREMOTEIO;
+}
 
-static const struct dvb_frontend_ops tc90522_ops_ter = {
+static struct dvb_frontend_ops tc90522_ops_t = {
 	.delsys = { SYS_ISDBT },
 	.info = {
-		.name = "Toshiba TC90522 ISDB-T module",
-		.frequency_min = 470000000,
-		.frequency_max = 770000000,
-		.frequency_stepsize = 142857,
-		.caps = FE_CAN_INVERSION_AUTO |
-			FE_CAN_FEC_1_2  | FE_CAN_FEC_2_3 | FE_CAN_FEC_3_4 |
-			FE_CAN_FEC_5_6  | FE_CAN_FEC_7_8 | FE_CAN_FEC_AUTO |
-			FE_CAN_QPSK     | FE_CAN_QAM_16 | FE_CAN_QAM_64 |
-			FE_CAN_QAM_AUTO | FE_CAN_TRANSMISSION_MODE_AUTO |
-			FE_CAN_GUARD_INTERVAL_AUTO | FE_CAN_RECOVER |
-			FE_CAN_HIERARCHY_AUTO,
+		.name = "TC90522 ISDB-T",
+		.caps = FE_CAN_INVERSION_AUTO | FE_CAN_FEC_AUTO | FE_CAN_QAM_AUTO |
+			FE_CAN_TRANSMISSION_MODE_AUTO | FE_CAN_GUARD_INTERVAL_AUTO | FE_CAN_HIERARCHY_AUTO,
 	},
-
-	.init = tc90522_init,
+	.init = tc90522_wakeup,
 	.sleep = tc90522_sleep,
-	.set_frontend = tc90522_set_frontend,
-	.get_tune_settings = tc90522_get_tune_settings,
-
-	.get_frontend = tc90522t_get_frontend,
-	.read_status = tc90522t_read_status,
+	.release = tc90522_release,
+	.write = tc90522_write,
+	.get_frontend_algo = tc90522_get_frontend_algo,
+	.read_snr = tc90522_read_snr,
+	.read_status = tc90522_read_status,
+	.tune = tc90522_tune_t,
+	.tuner_ops.calc_regs = tc90522_read_tuner_t,
 };
 
-
-static int tc90522_probe(struct i2c_client *client,
-			 const struct i2c_device_id *id)
+/**** Common ****/
+int tc90522_remove(struct i2c_client *client)
 {
-	struct tc90522_state *state;
-	struct tc90522_config *cfg;
-	const struct dvb_frontend_ops *ops;
-	struct i2c_adapter *adap;
-	int ret;
-
-	state = kzalloc(sizeof(*state), GFP_KERNEL);
-	if (!state)
-		return -ENOMEM;
-	state->i2c_client = client;
-
-	cfg = client->dev.platform_data;
-	memcpy(&state->cfg, cfg, sizeof(state->cfg));
-	cfg->fe = state->cfg.fe = &state->fe;
-	ops =  id->driver_data == 0 ? &tc90522_ops_sat : &tc90522_ops_ter;
-	memcpy(&state->fe.ops, ops, sizeof(*ops));
-	state->fe.demodulator_priv = state;
-
-	adap = &state->tuner_i2c;
-	adap->owner = THIS_MODULE;
-	adap->algo = &tc90522_tuner_i2c_algo;
-	adap->dev.parent = &client->dev;
-	strlcpy(adap->name, "tc90522_sub", sizeof(adap->name));
-	i2c_set_adapdata(adap, state);
-	ret = i2c_add_adapter(adap);
-	if (ret < 0)
-		goto err;
-	cfg->tuner_i2c = state->cfg.tuner_i2c = adap;
-
-	i2c_set_clientdata(client, &state->cfg);
-	dev_info(&client->dev, "Toshiba TC90522 attached.\n");
+	dev_dbg(&client->dev, "%s\n", __func__);
+	kfree(i2c_get_clientdata(client));
 	return 0;
-
-err:
-	kfree(state);
-	return ret;
 }
 
-static int tc90522_remove(struct i2c_client *client)
+int tc90522_probe(struct i2c_client *client, const struct i2c_device_id *id)
 {
-	struct tc90522_state *state;
+	struct tc90522_config *cfg = client->dev.platform_data;
+	struct tc90522 *demod = kzalloc(sizeof(struct tc90522), GFP_KERNEL);
+	struct dvb_frontend *fe	= &demod->fe;
 
-	state = cfg_to_state(i2c_get_clientdata(client));
-	i2c_del_adapter(&state->tuner_i2c);
-	kfree(state);
+	if (!demod)
+		return -ENOMEM;
+	demod->addr_demod = client->addr;
+	demod->idx	= (!(client->addr & 1) << 1) + ((client->addr & 2) >> 1);
+	demod->i2c	= client->adapter;
+	demod->type	= cfg->type;
+	memcpy(&fe->ops, (demod->type == SYS_ISDBS) ? &tc90522_ops_s : &tc90522_ops_t, sizeof(struct dvb_frontend_ops));
+	fe->demodulator_priv = demod;
+	if (cfg->pwr && (tc90522_set_powers(demod, TC90522_PWR_TUNER_ON)	||
+			i2c_transfer(demod->i2c, NULL, 0)			||
+			tc90522_set_powers(demod, TC90522_PWR_TUNER_ON | TC90522_PWR_AMP_ON))) {
+		tc90522_release(fe);
+		return -EIO;
+	}
+	cfg->fe = fe;
+	i2c_set_clientdata(client, demod);
 	return 0;
 }
 
-
-static const struct i2c_device_id tc90522_id[] = {
-	{ TC90522_I2C_DEV_SAT, 0 },
-	{ TC90522_I2C_DEV_TER, 1 },
-	{}
+static struct i2c_device_id tc90522_id_table[] = {
+	{ TC90522_DRVNAME, 0 },
+	{ },
 };
-MODULE_DEVICE_TABLE(i2c, tc90522_id);
+MODULE_DEVICE_TABLE(i2c, tc90522_id_table);
 
 static struct i2c_driver tc90522_driver = {
 	.driver = {
-		.name	= "tc90522",
+		.owner	= THIS_MODULE,
+		.name	= tc90522_id_table->name,
 	},
 	.probe		= tc90522_probe,
 	.remove		= tc90522_remove,
-	.id_table	= tc90522_id,
+	.id_table	= tc90522_id_table,
 };
-
 module_i2c_driver(tc90522_driver);
 
-MODULE_DESCRIPTION("Toshiba TC90522 frontend");
-MODULE_AUTHOR("Akihiro TSUKADA");
+MODULE_AUTHOR("Budi Rachmanto, AreMa Inc. <knightrider(@)are.ma>");
+MODULE_DESCRIPTION("Toshiba TC90522 8PSK(ISDB-S)/OFDM(ISDB-T) PT3 quad demodulator");
 MODULE_LICENSE("GPL");
+
diff --git a/drivers/media/dvb-frontends/tc90522.h b/drivers/media/dvb-frontends/tc90522.h
index b1cbddf..c78a5b0 100644
--- a/drivers/media/dvb-frontends/tc90522.h
+++ b/drivers/media/dvb-frontends/tc90522.h
@@ -1,12 +1,12 @@
 /*
- * Toshiba TC90522 Demodulator
+ * Earthsoft PT3 demodulator frontend Toshiba TC90522XBG OFDM(ISDB-T)/8PSK(ISDB-S)
  *
- * Copyright (C) 2014 Akihiro Tsukada <tskd08@gmail.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation version 2.
+ * Copyright (C) 2014 Budi Rachmanto, AreMa Inc. <info@are.ma>
  *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
  *
  * This program is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
@@ -14,29 +14,16 @@
  * GNU General Public License for more details.
  */
 
-/*
- * The demod has 4 input (2xISDB-T and 2xISDB-S),
- * and provides independent sub modules for each input.
- * As the sub modules work in parallel and have the separate i2c addr's,
- * this driver treats each sub module as one demod device.
- */
-
-#ifndef TC90522_H
-#define TC90522_H
+#ifndef	__TC90522_H__
+#define	__TC90522_H__
 
-#include <linux/i2c.h>
-#include "dvb_frontend.h"
-
-/* I2C device types */
-#define TC90522_I2C_DEV_SAT "tc90522sat"
-#define TC90522_I2C_DEV_TER "tc90522ter"
+#define TC90522_DRVNAME "tc90522"
 
 struct tc90522_config {
-	/* [OUT] frontend returned by driver */
-	struct dvb_frontend *fe;
-
-	/* [OUT] tuner I2C adapter returned by driver */
-	struct i2c_adapter *tuner_i2c;
+	fe_delivery_system_t	type;	/* IN	SYS_ISDBS or SYS_ISDBT */
+	bool			pwr;	/* IN	set only once after all demods initialized */
+	struct dvb_frontend	*fe;	/* OUT	allocated frontend */
 };
 
-#endif /* TC90522_H */
+#endif
+
diff --git a/drivers/media/pci/pt3/Kconfig b/drivers/media/pci/pt3/Kconfig
index 16c208a..f7b7210 100644
--- a/drivers/media/pci/pt3/Kconfig
+++ b/drivers/media/pci/pt3/Kconfig
@@ -6,5 +6,5 @@ config DVB_PT3
 	select MEDIA_TUNER_MXL301RF if MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Support for Earthsoft PT3 PCIe cards.
-
+	  You need to enable frontend (TC90522) & tuners (QM1D1C0042, MXL301RF)
 	  Say Y or M if you own such a device and want to use it.
diff --git a/drivers/media/pci/pt3/Makefile b/drivers/media/pci/pt3/Makefile
index 396f146..56ebc9b 100644
--- a/drivers/media/pci/pt3/Makefile
+++ b/drivers/media/pci/pt3/Makefile
@@ -1,8 +1,4 @@
+obj-$(CONFIG_DVB_PT3) += pt3.o
 
-earth-pt3-objs += pt3.o pt3_i2c.o pt3_dma.o
+ccflags-y += -Idrivers/media/dvb-core -Idrivers/media/dvb-frontends -Idrivers/media/tuners
 
-obj-$(CONFIG_DVB_PT3) += earth-pt3.o
-
-ccflags-y += -Idrivers/media/dvb-core
-ccflags-y += -Idrivers/media/dvb-frontends
-ccflags-y += -Idrivers/media/tuners
diff --git a/drivers/media/pci/pt3/pt3.c b/drivers/media/pci/pt3/pt3.c
index 1fdeac1..fcefee7 100644
--- a/drivers/media/pci/pt3/pt3.c
+++ b/drivers/media/pci/pt3/pt3.c
@@ -1,12 +1,12 @@
 /*
- * Earthsoft PT3 driver
+ * DVB driver for Earthsoft PT3 ISDB-S/T PCIE bridge Altera Cyclone IV FPGA EP4CGX15BF14C8N
  *
- * Copyright (C) 2014 Akihiro Tsukada <tskd08@gmail.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation version 2.
+ * Copyright (C) 2014 Budi Rachmanto, AreMa Inc. <info@are.ma>
  *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
  *
  * This program is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
@@ -14,863 +14,984 @@
  * GNU General Public License for more details.
  */
 
-#include <linux/freezer.h>
-#include <linux/kernel.h>
-#include <linux/kthread.h>
-#include <linux/mutex.h>
-#include <linux/module.h>
 #include <linux/pci.h>
-#include <linux/string.h>
-
-#include "dmxdev.h"
-#include "dvbdev.h"
+#include <linux/kthread.h>
+#include <linux/freezer.h>
 #include "dvb_demux.h"
+#include "dmxdev.h"
 #include "dvb_frontend.h"
-
+#include "tc90522.h"
+#include "qm1d1c0042.h"
+#include "mxl301rf.h"
 #include "pt3.h"
 
-DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
+MODULE_AUTHOR("Budi Rachmanto, AreMa Inc. <knightrider(@)are.ma>");
+MODULE_DESCRIPTION("Earthsoft PT3 DVB Driver");
+MODULE_LICENSE("GPL");
 
-static bool one_adapter;
-module_param(one_adapter, bool, 0444);
-MODULE_PARM_DESC(one_adapter, "Place FE's together under one adapter.");
+static struct pci_device_id pt3_id_table[] = {
+	{ PCI_DEVICE(0x1172, 0x4c15) },
+	{ },
+};
+MODULE_DEVICE_TABLE(pci, pt3_id_table);
 
-static int num_bufs = 4;
-module_param(num_bufs, int, 0444);
-MODULE_PARM_DESC(num_bufs, "Number of DMA buffer (188KiB) per FE.");
+static int lnb = 2;
+module_param(lnb, int, 0);
+MODULE_PARM_DESC(lnb, "LNB level (0:OFF 1:+11V 2:+15V)");
+
+/* common defs */
+
+#define PT3_REG_VERSION	0x00	/*	R	Version		*/
+#define PT3_REG_BUS	0x04	/*	R	Bus		*/
+#define PT3_REG_SYS_W	0x08	/*	W	System		*/
+#define PT3_REG_SYS_R	0x0c	/*	R	System		*/
+#define PT3_REG_I2C_W	0x10	/*	W	I2C		*/
+#define PT3_REG_I2C_R	0x14	/*	R	I2C		*/
+#define PT3_REG_RAM_W	0x18	/*	W	RAM		*/
+#define PT3_REG_RAM_R	0x1c	/*	R	RAM		*/
+#define PT3_REG_BASE	0x40	/* + 0x18*idx			*/
+#define PT3_OFS_DMA_D_L	0x00	/*	W	DMA descriptor	*/
+#define PT3_OFS_DMA_D_H	0x04	/*	W	DMA descriptor	*/
+#define PT3_OFS_DMA_CTL	0x08	/*	W	DMA		*/
+#define PT3_OFS_TS_CTL	0x0c	/*	W	TS		*/
+#define PT3_OFS_STATUS	0x10	/*	R	DMA/FIFO/TS	*/
+#define PT3_OFS_TS_ERR	0x14	/*	R	TS		*/
+
+struct pt3_adapter;
+
+struct pt3_board {
+	struct mutex lock;
+	int lnb;
+	bool reset;
+
+	struct pci_dev *pdev;
+	int bars;
+	void __iomem *bar_reg, *bar_mem;
+	struct i2c_adapter i2c;
+	u8 i2c_buf;
+	u32 i2c_addr;
+	bool i2c_filled;
+
+	struct pt3_adapter **adap;
+};
 
+struct pt3_adapter {
+	struct mutex lock;
+	struct pt3_board *pt3;
 
-static const struct i2c_algorithm pt3_i2c_algo = {
-	.master_xfer   = &pt3_i2c_master_xfer,
-	.functionality = &pt3_i2c_functionality,
+	u8 idx;
+	bool sleep;
+	struct pt3_dma *dma;
+	struct task_struct *kthread;
+	struct dvb_adapter dvb;
+	struct dvb_demux demux;
+	struct dmxdev dmxdev;
+	int users;
+
+	struct i2c_client *i2c_demod, *i2c_tuner;
+	struct dvb_frontend *fe;
+	int (*orig_sleep)(struct dvb_frontend *fe);
+	int (*orig_init)(struct dvb_frontend *fe);
 };
 
-static const struct pt3_adap_config adap_conf[PT3_NUM_FE] = {
-	{
-		.demod_info = {
-			I2C_BOARD_INFO(TC90522_I2C_DEV_SAT, 0x11),
-		},
-		.tuner_info = {
-			I2C_BOARD_INFO("qm1d1c0042", 0x63),
-		},
-		.tuner_cfg.qm1d1c0042 = {
-			.lpf = 1,
-		},
-		.init_freq = 1049480 - 300,
-	},
-	{
-		.demod_info = {
-			I2C_BOARD_INFO(TC90522_I2C_DEV_TER, 0x10),
-		},
-		.tuner_info = {
-			I2C_BOARD_INFO("mxl301rf", 0x62),
-		},
-		.init_freq = 515142857,
-	},
-	{
-		.demod_info = {
-			I2C_BOARD_INFO(TC90522_I2C_DEV_SAT, 0x13),
-		},
-		.tuner_info = {
-			I2C_BOARD_INFO("qm1d1c0042", 0x60),
-		},
-		.tuner_cfg.qm1d1c0042 = {
-			.lpf = 1,
-		},
-		.init_freq = 1049480 + 300,
-	},
-	{
-		.demod_info = {
-			I2C_BOARD_INFO(TC90522_I2C_DEV_TER, 0x12),
-		},
-		.tuner_info = {
-			I2C_BOARD_INFO("mxl301rf", 0x61),
-		},
-		.init_freq = 521142857,
-	},
+/* DMA handler */
+
+#define PT3_DMA_MAX_DESCS	204
+#define PT3_DMA_PAGE_SIZE	(PT3_DMA_MAX_DESCS * sizeof(struct pt3_dma_desc))
+#define PT3_DMA_BLOCK_COUNT	17
+#define PT3_DMA_BLOCK_SIZE	(PT3_DMA_PAGE_SIZE * 47)
+#define PT3_DMA_TS_BUF_SIZE	(PT3_DMA_BLOCK_SIZE * PT3_DMA_BLOCK_COUNT)
+#define PT3_DMA_TS_SYNC		0x47
+#define PT3_DMA_TS_NOT_SYNC	0x74
+
+struct pt3_dma_page {
+	dma_addr_t addr;
+	u8 *data;
+	u32 size, data_pos;
 };
 
+enum pt3_dma_mode {
+	USE_LFSR = 1 << 16,
+	REVERSE  = 1 << 17,
+	RESET    = 1 << 18,
+};
 
-struct reg_val {
-	u8 reg;
-	u8 val;
+struct pt3_dma {
+	struct pt3_adapter *adap;
+	bool enabled;
+	u32 ts_pos, ts_count, desc_count;
+	struct pt3_dma_page *ts_info, *desc_info;
+	struct mutex lock;
 };
 
-static int
-pt3_demod_write(struct pt3_adapter *adap, const struct reg_val *data, int num)
+void pt3_dma_free(struct pt3_dma *dma)
 {
-	struct i2c_msg msg;
-	int i, ret;
-
-	ret = 0;
-	msg.addr = adap->i2c_demod->addr;
-	msg.flags = 0;
-	msg.len = 2;
-	for (i = 0; i < num; i++) {
-		msg.buf = (u8 *)&data[i];
-		ret = i2c_transfer(adap->i2c_demod->adapter, &msg, 1);
-		if (ret == 0)
-			ret = -EREMOTE;
-		if (ret < 0)
-			return ret;
+	struct pt3_dma_page *page;
+	u32 i;
+
+	if (dma->ts_info) {
+		for (i = 0; i < dma->ts_count; i++) {
+			page = &dma->ts_info[i];
+			if (page->data)
+				pci_free_consistent(dma->adap->pt3->pdev, page->size, page->data, page->addr);
+		}
+		kfree(dma->ts_info);
 	}
-	return 0;
+	if (dma->desc_info) {
+		for (i = 0; i < dma->desc_count; i++) {
+			page = &dma->desc_info[i];
+			if (page->data)
+				pci_free_consistent(dma->adap->pt3->pdev, page->size, page->data, page->addr);
+		}
+		kfree(dma->desc_info);
+	}
+	kfree(dma);
 }
 
-static inline void pt3_lnb_ctrl(struct pt3_board *pt3, bool on)
+struct pt3_dma_desc {
+	u64 page_addr;
+	u32 page_size;
+	u64 next_desc;
+} __packed;
+
+void pt3_dma_build_page_descriptor(struct pt3_dma *dma)
 {
-	iowrite32((on ? 0x0f : 0x0c), pt3->regs[0] + REG_SYSTEM_W);
+	struct pt3_dma_page *desc_info, *ts_info;
+	u64 ts_addr, desc_addr;
+	u32 i, j, ts_size, desc_remain, ts_info_pos, desc_info_pos;
+	struct pt3_dma_desc *prev, *curr;
+
+	dev_dbg(dma->adap->dvb.device, "#%d %s ts_count=%d ts_size=%d desc_count=%d desc_size=%d\n",
+		dma->adap->idx, __func__, dma->ts_count, dma->ts_info[0].size, dma->desc_count, dma->desc_info[0].size);
+	desc_info_pos = ts_info_pos = 0;
+	desc_info = &dma->desc_info[desc_info_pos];
+	desc_addr   = desc_info->addr;
+	desc_remain = desc_info->size;
+	desc_info->data_pos = 0;
+	prev = NULL;
+	curr = (struct pt3_dma_desc *)&desc_info->data[desc_info->data_pos];
+	desc_info_pos++;
+
+	for (i = 0; i < dma->ts_count; i++) {
+		if (unlikely(ts_info_pos >= dma->ts_count)) {
+			dev_dbg(dma->adap->dvb.device, "#%d ts_info overflow max=%d curr=%d\n", dma->adap->idx, dma->ts_count, ts_info_pos);
+			return;
+		}
+		ts_info = &dma->ts_info[ts_info_pos];
+		ts_addr = ts_info->addr;
+		ts_size = ts_info->size;
+		ts_info_pos++;
+		dev_dbg(dma->adap->dvb.device, "#%d i=%d, ts_info addr=0x%llx ts_size=%d\n", dma->adap->idx, i, ts_addr, ts_size);
+		for (j = 0; j < ts_size / PT3_DMA_PAGE_SIZE; j++) {
+			if (desc_remain < sizeof(struct pt3_dma_desc)) {
+				if (unlikely(desc_info_pos >= dma->desc_count)) {
+					dev_dbg(dma->adap->dvb.device, "#%d desc_info overflow max=%d curr=%d\n",
+						dma->adap->idx, dma->desc_count, desc_info_pos);
+					return;
+				}
+				desc_info = &dma->desc_info[desc_info_pos];
+				desc_info->data_pos = 0;
+				curr = (struct pt3_dma_desc *)&desc_info->data[desc_info->data_pos];
+				dev_dbg(dma->adap->dvb.device, "#%d desc_info_pos=%d ts_addr=0x%llx remain=%d\n",
+					dma->adap->idx, desc_info_pos, ts_addr, desc_remain);
+				desc_addr = desc_info->addr;
+				desc_remain = desc_info->size;
+				desc_info_pos++;
+			}
+			if (prev)
+				prev->next_desc = desc_addr | 0b10;
+			curr->page_addr = ts_addr           | 0b111;
+			curr->page_size = PT3_DMA_PAGE_SIZE | 0b111;
+			curr->next_desc = 0b10;
+			dev_dbg(dma->adap->dvb.device, "#%d j=%d dma write desc ts_addr=0x%llx desc_info_pos=%d desc_remain=%d\n",
+				dma->adap->idx, j, ts_addr, desc_info_pos, desc_remain);
+			ts_addr += PT3_DMA_PAGE_SIZE;
+
+			prev = curr;
+			desc_info->data_pos += sizeof(struct pt3_dma_desc);
+			if (unlikely(desc_info->data_pos > desc_info->size)) {
+				dev_dbg(dma->adap->dvb.device, "#%d dma desc_info data overflow max=%d curr=%d\n",
+					dma->adap->idx, desc_info->size, desc_info->data_pos);
+				return;
+			}
+			curr = (struct pt3_dma_desc *)&desc_info->data[desc_info->data_pos];
+			desc_addr += sizeof(struct pt3_dma_desc);
+			desc_remain -= sizeof(struct pt3_dma_desc);
+		}
+	}
+	if (prev)
+		prev->next_desc = dma->desc_info->addr | 0b10;
 }
 
-static inline struct pt3_adapter *pt3_find_adapter(struct dvb_frontend *fe)
+struct pt3_dma *pt3_dma_create(struct pt3_adapter *adap)
 {
-	struct pt3_board *pt3;
-	int i;
+	struct pt3_dma_page *page;
+	u32 i;
+	struct pt3_dma *dma = kzalloc(sizeof(struct pt3_dma), GFP_KERNEL);
+
+	if (!dma)
+		goto fail;
+	dma->adap = adap;
+	dma->enabled = false;
+	mutex_init(&dma->lock);
+
+	dma->ts_count = PT3_DMA_BLOCK_COUNT;
+	dma->ts_info = kcalloc(dma->ts_count, sizeof(struct pt3_dma_page), GFP_KERNEL);
+	if (!dma->ts_info) {
+		dev_dbg(adap->dvb.device, "#%d fail allocate TS DMA page\n", adap->idx);
+		goto fail;
+	}
+	dev_dbg(adap->dvb.device, "#%d Alloc TS buf (ts_count %d)\n", adap->idx, dma->ts_count);
+	for (i = 0; i < dma->ts_count; i++) {
+		page = &dma->ts_info[i];
+		page->size = PT3_DMA_BLOCK_SIZE;
+		page->data_pos = 0;
+		page->data = pci_alloc_consistent(adap->pt3->pdev, page->size, &page->addr);
+		if (!page->data) {
+			dev_dbg(adap->dvb.device, "#%d fail alloc_consistent. %d\n", adap->idx, i);
+			goto fail;
+		}
+	}
 
-	if (one_adapter) {
-		pt3 = fe->dvb->priv;
-		for (i = 0; i < PT3_NUM_FE; i++)
-			if (pt3->adaps[i]->fe == fe)
-				return pt3->adaps[i];
+	dma->desc_count = 1 + (PT3_DMA_TS_BUF_SIZE / PT3_DMA_PAGE_SIZE - 1) / PT3_DMA_MAX_DESCS;
+	dma->desc_info = kcalloc(dma->desc_count, sizeof(struct pt3_dma_page), GFP_KERNEL);
+	if (!dma->desc_info) {
+		dev_dbg(adap->dvb.device, "#%d fail allocate Desc DMA page\n", adap->idx);
+		goto fail;
+	}
+	dev_dbg(adap->dvb.device, "#%d Alloc Descriptor buf (desc_count %d)\n", adap->idx, dma->desc_count);
+	for (i = 0; i < dma->desc_count; i++) {
+		page = &dma->desc_info[i];
+		page->size = PT3_DMA_PAGE_SIZE;
+		page->data_pos = 0;
+		page->data = pci_alloc_consistent(adap->pt3->pdev, page->size, &page->addr);
+		if (!page->data) {
+			dev_dbg(adap->dvb.device, "#%d fail alloc_consistent %d\n", adap->idx, i);
+			goto fail;
+		}
 	}
-	return container_of(fe->dvb, struct pt3_adapter, dvb_adap);
+
+	dev_dbg(adap->dvb.device, "#%d build page descriptor\n", adap->idx);
+	pt3_dma_build_page_descriptor(dma);
+	return dma;
+fail:
+	if (dma)
+		pt3_dma_free(dma);
+	return NULL;
 }
 
-/*
- * all 4 tuners in PT3 are packaged in a can module (Sharp VA4M6JC2103).
- * it seems that they share the power lines and Amp power line and
- * adaps[3] controls those powers.
- */
-static int
-pt3_set_tuner_power(struct pt3_board *pt3, bool tuner_on, bool amp_on)
+void __iomem *pt3_dma_get_base_addr(struct pt3_dma *dma)
 {
-	struct reg_val rv = { 0x1e, 0x99 };
-
-	if (tuner_on)
-		rv.val |= 0x40;
-	if (amp_on)
-		rv.val |= 0x04;
-	return pt3_demod_write(pt3->adaps[PT3_NUM_FE - 1], &rv, 1);
+	return dma->adap->pt3->bar_reg + PT3_REG_BASE + (0x18 * dma->adap->idx);
 }
 
-static int pt3_set_lna(struct dvb_frontend *fe)
+void pt3_dma_reset(struct pt3_dma *dma)
 {
-	struct pt3_adapter *adap;
-	struct pt3_board *pt3;
-	u32 val;
-	int ret;
-
-	/* LNA is shared btw. 2 TERR-tuners */
+	struct pt3_dma_page *ts;
+	u32 i;
 
-	adap = pt3_find_adapter(fe);
-	val = fe->dtv_property_cache.lna;
-	if (val == LNA_AUTO || val == adap->cur_lna)
-		return 0;
-
-	pt3 = adap->dvb_adap.priv;
-	if (mutex_lock_interruptible(&pt3->lock))
-		return -ERESTARTSYS;
-	if (val)
-		pt3->lna_on_cnt++;
-	else
-		pt3->lna_on_cnt--;
-
-	if (val && pt3->lna_on_cnt <= 1) {
-		pt3->lna_on_cnt = 1;
-		ret = pt3_set_tuner_power(pt3, true, true);
-	} else if (!val && pt3->lna_on_cnt <= 0) {
-		pt3->lna_on_cnt = 0;
-		ret = pt3_set_tuner_power(pt3, true, false);
-	} else
-		ret = 0;
-	mutex_unlock(&pt3->lock);
-	adap->cur_lna = (val != 0);
-	return ret;
+	for (i = 0; i < dma->ts_count; i++) {
+		ts = &dma->ts_info[i];
+		memset(ts->data, 0, ts->size);
+		ts->data_pos = 0;
+		*ts->data = PT3_DMA_TS_NOT_SYNC;
+	}
+	dma->ts_pos = 0;
 }
 
-static int pt3_set_voltage(struct dvb_frontend *fe, fe_sec_voltage_t volt)
+void pt3_dma_set_enabled(struct pt3_dma *dma, bool enabled)
 {
-	struct pt3_adapter *adap;
-	struct pt3_board *pt3;
-	bool on;
-
-	/* LNB power is shared btw. 2 SAT-tuners */
-
-	adap = pt3_find_adapter(fe);
-	on = (volt != SEC_VOLTAGE_OFF);
-	if (on == adap->cur_lnb)
-		return 0;
-	adap->cur_lnb = on;
-	pt3 = adap->dvb_adap.priv;
-	if (mutex_lock_interruptible(&pt3->lock))
-		return -ERESTARTSYS;
-	if (on)
-		pt3->lnb_on_cnt++;
-	else
-		pt3->lnb_on_cnt--;
-
-	if (on && pt3->lnb_on_cnt <= 1) {
-		pt3->lnb_on_cnt = 1;
-		pt3_lnb_ctrl(pt3, true);
-	} else if (!on && pt3->lnb_on_cnt <= 0) {
-		pt3->lnb_on_cnt = 0;
-		pt3_lnb_ctrl(pt3, false);
+	void __iomem *base = pt3_dma_get_base_addr(dma);
+	u64 start_addr = dma->desc_info->addr;
+
+	if (enabled) {
+		dev_dbg(dma->adap->dvb.device, "#%d DMA enable start_addr=%llx\n", dma->adap->idx, start_addr);
+		pt3_dma_reset(dma);
+		writel(1 << 1, base + PT3_OFS_DMA_CTL);	/* stop DMA */
+		writel(start_addr         & 0xffffffff, base + PT3_OFS_DMA_D_L);
+		writel((start_addr >> 32) & 0xffffffff, base + PT3_OFS_DMA_D_H);
+		dev_dbg(dma->adap->dvb.device, "set descriptor address low %llx\n",  start_addr         & 0xffffffff);
+		dev_dbg(dma->adap->dvb.device, "set descriptor address high %llx\n", (start_addr >> 32) & 0xffffffff);
+		writel(1 << 0, base + PT3_OFS_DMA_CTL);	/* start DMA */
+	} else {
+		dev_dbg(dma->adap->dvb.device, "#%d DMA disable\n", dma->adap->idx);
+		writel(1 << 1, base + PT3_OFS_DMA_CTL);	/* stop DMA */
+		while (1) {
+			if (!(readl(base + PT3_OFS_STATUS) & 1))
+				break;
+			msleep_interruptible(1);
+		}
 	}
-	mutex_unlock(&pt3->lock);
-	return 0;
+	dma->enabled = enabled;
 }
 
-/* register values used in pt3_fe_init() */
-
-static const struct reg_val init0_sat[] = {
-	{ 0x03, 0x01 },
-	{ 0x1e, 0x10 },
-};
-static const struct reg_val init0_ter[] = {
-	{ 0x01, 0x40 },
-	{ 0x1c, 0x10 },
-};
-static const struct reg_val cfg_sat[] = {
-	{ 0x1c, 0x15 },
-	{ 0x1f, 0x04 },
-};
-static const struct reg_val cfg_ter[] = {
-	{ 0x1d, 0x01 },
-};
-
-/*
- * pt3_fe_init: initialize demod sub modules and ISDB-T tuners all at once.
- *
- * As for demod IC (TC90522) and ISDB-T tuners (MxL301RF),
- * the i2c sequences for init'ing them are not public and hidden in a ROM,
- * and include the board specific configurations as well.
- * They are stored in a lump and cannot be taken out / accessed separately,
- * thus cannot be moved to the FE/tuner driver.
- */
-static int pt3_fe_init(struct pt3_board *pt3)
+static u32 pt3_dma_gray2binary(u32 gray, u32 bit)	/* convert Gray code to binary, e.g. 1001 -> 1110 */
 {
-	int i, ret;
-	struct dvb_frontend *fe;
+	u32 binary = 0, i, j, k;
 
-	pt3_i2c_reset(pt3);
-	ret = pt3_init_all_demods(pt3);
-	if (ret < 0) {
-		dev_warn(&pt3->pdev->dev, "Failed to init demod chips.");
-		return ret;
+	for (i = 0; i < bit; i++) {
+		k = 0;
+		for (j = i; j < bit; j++)
+			k ^= (gray >> j) & 1;
+		binary |= k << i;
 	}
+	return binary;
+}
 
-	/* additional config? */
-	for (i = 0; i < PT3_NUM_FE; i++) {
-		fe = pt3->adaps[i]->fe;
-
-		if (fe->ops.delsys[0] == SYS_ISDBS)
-			ret = pt3_demod_write(pt3->adaps[i],
-					      init0_sat, ARRAY_SIZE(init0_sat));
-		else
-			ret = pt3_demod_write(pt3->adaps[i],
-					      init0_ter, ARRAY_SIZE(init0_ter));
-		if (ret < 0) {
-			dev_warn(&pt3->pdev->dev,
-				 "demod[%d] faild in init sequence0.", i);
-			return ret;
-		}
-		ret = fe->ops.init(fe);
-		if (ret < 0)
-			return ret;
-	}
+u32 pt3_dma_get_ts_error_packet_count(struct pt3_dma *dma)
+{
+	return pt3_dma_gray2binary(readl(pt3_dma_get_base_addr(dma) + PT3_OFS_TS_ERR), 32);
+}
 
-	usleep_range(2000, 4000);
-	ret = pt3_set_tuner_power(pt3, true, false);
-	if (ret < 0) {
-		dev_warn(&pt3->pdev->dev, "Failed to control tuner module.");
-		return ret;
-	}
+void pt3_dma_set_test_mode(struct pt3_dma *dma, enum pt3_dma_mode mode, u16 initval)
+{
+	void __iomem *base = pt3_dma_get_base_addr(dma);
+	u32 data = mode | initval;
 
-	/* output pin configuration */
-	for (i = 0; i < PT3_NUM_FE; i++) {
-		fe = pt3->adaps[i]->fe;
-		if (fe->ops.delsys[0] == SYS_ISDBS)
-			ret = pt3_demod_write(pt3->adaps[i],
-						cfg_sat, ARRAY_SIZE(cfg_sat));
-		else
-			ret = pt3_demod_write(pt3->adaps[i],
-						cfg_ter, ARRAY_SIZE(cfg_ter));
-		if (ret < 0) {
-			dev_warn(&pt3->pdev->dev,
-				 "demod[%d] faild in init sequence1.", i);
-			return ret;
-		}
-	}
-	usleep_range(4000, 6000);
-
-	for (i = 0; i < PT3_NUM_FE; i++) {
-		fe = pt3->adaps[i]->fe;
-		if (fe->ops.delsys[0] != SYS_ISDBS)
-			continue;
-		/* init and wake-up ISDB-S tuners */
-		ret = fe->ops.tuner_ops.init(fe);
-		if (ret < 0) {
-			dev_warn(&pt3->pdev->dev,
-				 "Failed to init SAT-tuner[%d].", i);
-			return ret;
-		}
-	}
-	ret = pt3_init_all_mxl301rf(pt3);
-	if (ret < 0) {
-		dev_warn(&pt3->pdev->dev, "Failed to init TERR-tuners.");
-		return ret;
-	}
+	dev_dbg(dma->adap->dvb.device, "#%d %s base=%p data=0x%04x\n", dma->adap->idx, __func__, base, data);
+	writel(data, base + PT3_OFS_TS_CTL);
+}
 
-	ret = pt3_set_tuner_power(pt3, true, true);
-	if (ret < 0) {
-		dev_warn(&pt3->pdev->dev, "Failed to control tuner module.");
-		return ret;
-	}
+bool pt3_dma_ready(struct pt3_dma *dma)
+{
+	struct pt3_dma_page *ts;
+	u8 *p;
+	u32 next = dma->ts_pos + 1;
+
+	if (next >= dma->ts_count)
+		next = 0;
+	ts = &dma->ts_info[next];
+	p = &ts->data[ts->data_pos];
+
+	if (*p == PT3_DMA_TS_SYNC)
+		return true;
+	if (*p == PT3_DMA_TS_NOT_SYNC)
+		return false;
+
+	dev_dbg(dma->adap->dvb.device, "#%d invalid sync byte value=0x%02x ts_pos=%d data_pos=%d curr=0x%02x\n",
+		dma->adap->idx, *p, next, ts->data_pos, dma->ts_info[dma->ts_pos].data[0]);
+	return false;
+}
 
-	/* Wake up all tuners and make an initial tuning,
-	 * in order to avoid interference among the tuners in the module,
-	 * according to the doc from the manufacturer.
-	 */
-	for (i = 0; i < PT3_NUM_FE; i++) {
-		fe = pt3->adaps[i]->fe;
-		ret = 0;
-		if (fe->ops.delsys[0] == SYS_ISDBT)
-			ret = fe->ops.tuner_ops.init(fe);
-		/* set only when called from pt3_probe(), not resume() */
-		if (ret == 0 && fe->dtv_property_cache.frequency == 0) {
-			fe->dtv_property_cache.frequency =
-						adap_conf[i].init_freq;
-			ret = fe->ops.tuner_ops.set_params(fe);
+ssize_t pt3_dma_copy(struct pt3_dma *dma, struct dvb_demux *demux)
+{
+	bool ready;
+	struct pt3_dma_page *ts;
+	u32 i, prev;
+	size_t csize, remain = dma->ts_info[dma->ts_pos].size;
+
+	mutex_lock(&dma->lock);
+	dev_dbg(dma->adap->dvb.device, "#%d dma_copy ts_pos=0x%x data_pos=0x%x\n",
+		   dma->adap->idx, dma->ts_pos, dma->ts_info[dma->ts_pos].data_pos);
+	for (;;) {
+		for (i = 0; i < 20; i++) {
+			ready = pt3_dma_ready(dma);
+			if (ready)
+				break;
+			msleep_interruptible(30);
 		}
-		if (ret < 0) {
-			dev_warn(&pt3->pdev->dev,
-				 "Failed in initial tuning of tuner[%d].", i);
-			return ret;
+		if (!ready) {
+			dev_dbg(dma->adap->dvb.device, "#%d dma_copy NOT READY\n", dma->adap->idx);
+			goto last;
+		}
+		prev = dma->ts_pos - 1;
+		if (prev < 0 || dma->ts_count <= prev)
+			prev = dma->ts_count - 1;
+		if (dma->ts_info[prev].data[0] != PT3_DMA_TS_NOT_SYNC)
+			dev_dbg(dma->adap->dvb.device, "#%d DMA buffer overflow. prev=%d data=0x%x\n",
+					dma->adap->idx, prev, dma->ts_info[prev].data[0]);
+		ts = &dma->ts_info[dma->ts_pos];
+		for (;;) {
+			csize = (remain < (ts->size - ts->data_pos)) ?
+				 remain : (ts->size - ts->data_pos);
+			dvb_dmx_swfilter(demux, &ts->data[ts->data_pos], csize);
+			remain -= csize;
+			ts->data_pos += csize;
+			if (ts->data_pos >= ts->size) {
+				ts->data_pos = 0;
+				ts->data[ts->data_pos] = PT3_DMA_TS_NOT_SYNC;
+				dma->ts_pos++;
+				if (dma->ts_pos >= dma->ts_count)
+					dma->ts_pos = 0;
+				break;
+			}
+			if (remain <= 0)
+				goto last;
 		}
 	}
+last:
+	mutex_unlock(&dma->lock);
+	return dma->ts_info[dma->ts_pos].size - remain;
+}
 
-	/* and sleep again, waiting to be opened by users. */
-	for (i = 0; i < PT3_NUM_FE; i++) {
-		fe = pt3->adaps[i]->fe;
-		if (fe->ops.tuner_ops.sleep)
-			ret = fe->ops.tuner_ops.sleep(fe);
-		if (ret < 0)
-			break;
-		if (fe->ops.sleep)
-			ret = fe->ops.sleep(fe);
-		if (ret < 0)
-			break;
-		if (fe->ops.delsys[0] == SYS_ISDBS)
-			fe->ops.set_voltage = &pt3_set_voltage;
-		else
-			fe->ops.set_lna = &pt3_set_lna;
-	}
-	if (i < PT3_NUM_FE) {
-		dev_warn(&pt3->pdev->dev, "FE[%d] failed to standby.", i);
-		return ret;
-	}
-	return 0;
+u32 pt3_dma_get_status(struct pt3_dma *dma)
+{
+	return readl(pt3_dma_get_base_addr(dma) + PT3_OFS_STATUS);
 }
 
+/* I2C handler */
+
+#define PT3_I2C_DATA_OFFSET	2048
+#define PT3_I2C_START_ADDR	0x17fa
+
+enum pt3_i2c_cmd {
+	I_END,
+	I_ADDRESS,
+	I_CLOCK_L,
+	I_CLOCK_H,
+	I_DATA_L,
+	I_DATA_H,
+	I_RESET,
+	I_SLEEP,
+	I_DATA_L_NOP  = 0x08,
+	I_DATA_H_NOP  = 0x0c,
+	I_DATA_H_READ = 0x0d,
+	I_DATA_H_ACK0 = 0x0e,
+	I_DATA_H_ACK1 = 0x0f,
+};
 
-static int pt3_attach_fe(struct pt3_board *pt3, int i)
+bool pt3_i2c_is_clean(struct pt3_board *pt3)
 {
-	struct i2c_board_info info;
-	struct tc90522_config cfg;
-	struct i2c_client *cl;
-	struct dvb_adapter *dvb_adap;
-	int ret;
+	return (readl(pt3->bar_reg + PT3_REG_I2C_R) >> 3) & 1;
+}
 
-	info = adap_conf[i].demod_info;
-	cfg = adap_conf[i].demod_cfg;
-	cfg.tuner_i2c = NULL;
-	info.platform_data = &cfg;
-
-	ret = -ENODEV;
-	request_module("tc90522");
-	cl = i2c_new_device(&pt3->i2c_adap, &info);
-	if (!cl || !cl->dev.driver)
-		return -ENODEV;
-	pt3->adaps[i]->i2c_demod = cl;
-	if (!try_module_get(cl->dev.driver->owner))
-		goto err_demod_i2c_unregister_device;
-
-	if (!strncmp(cl->name, TC90522_I2C_DEV_SAT, sizeof(cl->name))) {
-		struct qm1d1c0042_config tcfg;
-
-		tcfg = adap_conf[i].tuner_cfg.qm1d1c0042;
-		tcfg.fe = cfg.fe;
-		info = adap_conf[i].tuner_info;
-		info.platform_data = &tcfg;
-		request_module("qm1d1c0042");
-		cl = i2c_new_device(cfg.tuner_i2c, &info);
-	} else {
-		struct mxl301rf_config tcfg;
-
-		tcfg = adap_conf[i].tuner_cfg.mxl301rf;
-		tcfg.fe = cfg.fe;
-		info = adap_conf[i].tuner_info;
-		info.platform_data = &tcfg;
-		request_module("mxl301rf");
-		cl = i2c_new_device(cfg.tuner_i2c, &info);
-	}
-	if (!cl || !cl->dev.driver)
-		goto err_demod_module_put;
-	pt3->adaps[i]->i2c_tuner = cl;
-	if (!try_module_get(cl->dev.driver->owner))
-		goto err_tuner_i2c_unregister_device;
-
-	dvb_adap = &pt3->adaps[one_adapter ? 0 : i]->dvb_adap;
-	ret = dvb_register_frontend(dvb_adap, cfg.fe);
-	if (ret < 0)
-		goto err_tuner_module_put;
-	pt3->adaps[i]->fe = cfg.fe;
-	return 0;
+void pt3_i2c_reset(struct pt3_board *pt3)
+{
+	writel(1 << 17, pt3->bar_reg + PT3_REG_I2C_W);			/* 0x00020000 */
+}
 
-err_tuner_module_put:
-	module_put(pt3->adaps[i]->i2c_tuner->dev.driver->owner);
-err_tuner_i2c_unregister_device:
-	i2c_unregister_device(pt3->adaps[i]->i2c_tuner);
-err_demod_module_put:
-	module_put(pt3->adaps[i]->i2c_demod->dev.driver->owner);
-err_demod_i2c_unregister_device:
-	i2c_unregister_device(pt3->adaps[i]->i2c_demod);
+void pt3_i2c_wait(struct pt3_board *pt3, u32 *status)
+{
+	u32 val;
 
-	return ret;
+	while (1) {
+		val = readl(pt3->bar_reg + PT3_REG_I2C_R);
+		if (!(val & 1))						/* sequence stopped */
+			break;
+		msleep_interruptible(1);
+	}
+	if (status)
+		*status = val;						/* I2C register status */
 }
 
-
-static int pt3_fetch_thread(void *data)
+void pt3_i2c_mem_write(struct pt3_board *pt3, u8 data)
 {
-	struct pt3_adapter *adap = data;
-	ktime_t delay;
-	bool was_frozen;
+	void __iomem *dst = pt3->bar_mem + PT3_I2C_DATA_OFFSET + pt3->i2c_addr;
 
-#define PT3_INITIAL_BUF_DROPS 4
-#define PT3_FETCH_DELAY 10
-#define PT3_FETCH_DELAY_DELTA 2
-
-	pt3_init_dmabuf(adap);
-	adap->num_discard = PT3_INITIAL_BUF_DROPS;
+	if (pt3->i2c_filled) {
+		pt3->i2c_buf |= data << 4;
+		writeb(pt3->i2c_buf, dst);
+		pt3->i2c_addr++;
+	} else
+		pt3->i2c_buf = data;
+	pt3->i2c_filled ^= true;
+}
 
-	dev_dbg(adap->dvb_adap.device,
-		"PT3: [%s] started.\n", adap->thread->comm);
-	set_freezable();
-	while (!kthread_freezable_should_stop(&was_frozen)) {
-		if (was_frozen)
-			adap->num_discard = PT3_INITIAL_BUF_DROPS;
+void pt3_i2c_start(struct pt3_board *pt3)
+{
+	pt3_i2c_mem_write(pt3, I_DATA_H);
+	pt3_i2c_mem_write(pt3, I_CLOCK_H);
+	pt3_i2c_mem_write(pt3, I_DATA_L);
+	pt3_i2c_mem_write(pt3, I_CLOCK_L);
+}
 
-		pt3_proc_dma(adap);
+void pt3_i2c_cmd_write(struct pt3_board *pt3, const u8 *data, u32 size)
+{
+	u32 i, j;
+	u8 byte;
 
-		delay = ktime_set(0, PT3_FETCH_DELAY * NSEC_PER_MSEC);
-		set_current_state(TASK_UNINTERRUPTIBLE);
-		freezable_schedule_hrtimeout_range(&delay,
-					PT3_FETCH_DELAY_DELTA * NSEC_PER_MSEC,
-					HRTIMER_MODE_REL);
+	for (i = 0; i < size; i++) {
+		byte = data[i];
+		for (j = 0; j < 8; j++)
+			pt3_i2c_mem_write(pt3, (byte >> (7 - j)) & 1 ? I_DATA_H_NOP : I_DATA_L_NOP);
+		pt3_i2c_mem_write(pt3, I_DATA_H_ACK0);
 	}
-	dev_dbg(adap->dvb_adap.device,
-		"PT3: [%s] exited.\n", adap->thread->comm);
-	adap->thread = NULL;
-	return 0;
 }
 
-static int pt3_start_streaming(struct pt3_adapter *adap)
+void pt3_i2c_cmd_read(struct pt3_board *pt3, u8 *data, u32 size)
 {
-	struct task_struct *thread;
+	u32 i, j;
 
-	/* start fetching thread */
-	thread = kthread_run(pt3_fetch_thread, adap, "pt3-ad%i-dmx%i",
-				adap->dvb_adap.num, adap->dmxdev.dvbdev->id);
-	if (IS_ERR(thread)) {
-		int ret = PTR_ERR(thread);
-
-		dev_warn(adap->dvb_adap.device,
-			"PT3 (adap:%d, dmx:%d): failed to start kthread.\n",
-			adap->dvb_adap.num, adap->dmxdev.dvbdev->id);
-		return ret;
+	for (i = 0; i < size; i++) {
+		for (j = 0; j < 8; j++)
+			pt3_i2c_mem_write(pt3, I_DATA_H_READ);
+		if (i == (size - 1))
+			pt3_i2c_mem_write(pt3, I_DATA_H_NOP);
+		else
+			pt3_i2c_mem_write(pt3, I_DATA_L_NOP);
 	}
-	adap->thread = thread;
+}
 
-	return pt3_start_dma(adap);
+void pt3_i2c_stop(struct pt3_board *pt3)
+{
+	pt3_i2c_mem_write(pt3, I_DATA_L);
+	pt3_i2c_mem_write(pt3, I_CLOCK_H);
+	pt3_i2c_mem_write(pt3, I_DATA_H);
 }
 
-static int pt3_stop_streaming(struct pt3_adapter *adap)
+int pt3_i2c_flush(struct pt3_board *pt3, bool end, u32 start_addr)
 {
-	int ret;
+	u32 status;
 
-	ret = pt3_stop_dma(adap);
-	if (ret)
-		dev_warn(adap->dvb_adap.device,
-			"PT3: failed to stop streaming of adap:%d/FE:%d\n",
-			adap->dvb_adap.num, adap->fe->id);
+	if (end) {
+		pt3_i2c_mem_write(pt3, I_END);
+		if (pt3->i2c_filled)
+			pt3_i2c_mem_write(pt3, I_END);
+	}
+	pt3_i2c_wait(pt3, &status);
+	writel(1 << 16 | start_addr, pt3->bar_reg + PT3_REG_I2C_W);	/* 0x00010000 start sequence */
+	pt3_i2c_wait(pt3, &status);
+	if (status & 0b0110) {						/* ACK status */
+		dev_err(&pt3->i2c.dev, "%s %s failed, status=0x%x\n", pt3->i2c.name, __func__, status);
+		return -EIO;
+	}
+	return 0;
+}
 
-	/* kill the fetching thread */
-	ret = kthread_stop(adap->thread);
-	return ret;
+u32 pt3_i2c_func(struct i2c_adapter *i2c)
+{
+	return I2C_FUNC_I2C;
 }
 
-static int pt3_start_feed(struct dvb_demux_feed *feed)
+int pt3_i2c_xfer(struct i2c_adapter *i2c, struct i2c_msg *msg, int num)
 {
-	struct pt3_adapter *adap;
+	struct pt3_board *pt3 = i2c_get_adapdata(i2c);
+	int i, j;
+
+	if (!num)
+		return pt3_i2c_flush(pt3, false, PT3_I2C_START_ADDR);
+	if ((num < 1) || (num > 3) || !msg || msg[0].flags)		/* always write first */
+		return -ENOTSUPP;
+	mutex_lock(&pt3->lock);
+	pt3->i2c_addr = 0;
+	for (i = 0; i < num; i++) {
+		u8 byte = (msg[i].addr << 1) | (msg[i].flags & 1);
 
-	if (signal_pending(current))
-		return -EINTR;
-
-	adap = container_of(feed->demux, struct pt3_adapter, demux);
-	adap->num_feeds++;
-	if (adap->thread)
-		return 0;
-	if (adap->num_feeds != 1) {
-		dev_warn(adap->dvb_adap.device,
-			"%s: unmatched start/stop_feed in adap:%i/dmx:%i.\n",
-			__func__, adap->dvb_adap.num, adap->dmxdev.dvbdev->id);
-		adap->num_feeds = 1;
+		pt3_i2c_start(pt3);
+		pt3_i2c_cmd_write(pt3, &byte, 1);
+		if (msg[i].flags == I2C_M_RD)
+			pt3_i2c_cmd_read(pt3, msg[i].buf, msg[i].len);
+		else
+			pt3_i2c_cmd_write(pt3, msg[i].buf, msg[i].len);
 	}
+	pt3_i2c_stop(pt3);
+	if (pt3_i2c_flush(pt3, true, 0))
+		num = -EIO;
+	else
+		for (i = 1; i < num; i++)
+			if (msg[i].flags == I2C_M_RD)
+				for (j = 0; j < msg[i].len; j++)
+					msg[i].buf[j] = readb(pt3->bar_mem + PT3_I2C_DATA_OFFSET + j);
+	mutex_unlock(&pt3->lock);
+	return num;
+}
+
+static const struct i2c_algorithm pt3_i2c_algo = {
+	.functionality = pt3_i2c_func,
+	.master_xfer = pt3_i2c_xfer,
+};
 
-	return pt3_start_streaming(adap);
+int pt3_i2c_add_adapter(struct pt3_board *pt3)
+{
+	struct i2c_adapter *i2c = &pt3->i2c;
 
+	i2c->algo = &pt3_i2c_algo;
+	i2c->algo_data = NULL;
+	i2c->dev.parent = &pt3->pdev->dev;
+	strcpy(i2c->name, PT3_DRVNAME);
+	i2c_set_adapdata(i2c, pt3);
+	return	i2c_add_adapter(i2c) ||
+		(!pt3_i2c_is_clean(pt3) && pt3_i2c_flush(pt3, false, 0));
 }
 
-static int pt3_stop_feed(struct dvb_demux_feed *feed)
-{
-	struct pt3_adapter *adap;
+/* PCI bridge routines */
 
-	adap = container_of(feed->demux, struct pt3_adapter, demux);
+struct pt3_lnb {
+	u32 bits;
+	char *str;
+};
 
-	adap->num_feeds--;
-	if (adap->num_feeds > 0 || !adap->thread)
-		return 0;
-	adap->num_feeds = 0;
+static const struct pt3_lnb pt3_lnb[] = {
+	{0b1100,  "0V"},
+	{0b1101, "11V"},
+	{0b1111, "15V"},
+};
 
-	return pt3_stop_streaming(adap);
-}
+struct pt3_cfg {
+	fe_delivery_system_t type;
+	u8 addr_tuner, addr_demod;
+};
 
+static const struct pt3_cfg pt3_cfg[] = {
+	{SYS_ISDBS, 0x63, 0b00010001},
+	{SYS_ISDBS, 0x60, 0b00010011},
+	{SYS_ISDBT, 0x62, 0b00010000},
+	{SYS_ISDBT, 0x61, 0b00010010},
+};
+#define PT3_ADAPN ARRAY_SIZE(pt3_cfg)
 
-static int pt3_alloc_adapter(struct pt3_board *pt3, int index)
+int pt3_update_lnb(struct pt3_board *pt3)
 {
-	int ret;
-	struct pt3_adapter *adap;
-	struct dvb_adapter *da;
+	u8 i, lnb_eff = 0;
+
+	if (pt3->reset) {
+		writel(pt3_lnb[0].bits, pt3->bar_reg + PT3_REG_SYS_W);
+		pt3->reset = false;
+		pt3->lnb = 0;
+	} else {
+		struct pt3_adapter *adap;
 
-	adap = kzalloc(sizeof(*adap), GFP_KERNEL);
-	if (!adap) {
-		dev_err(&pt3->pdev->dev, "failed to alloc mem for adapter.\n");
-		return -ENOMEM;
+		for (i = 0; i < PT3_ADAPN; i++) {
+			adap = pt3->adap[i];
+			dev_dbg(adap->dvb.device, "#%d sleep %d\n", adap->idx, adap->sleep);
+			if ((pt3_cfg[i].type == SYS_ISDBS) && (!adap->sleep))
+				lnb_eff |= lnb;
+		}
+		if (unlikely(lnb_eff < 0 || 2 < lnb_eff)) {
+			dev_err(&pt3->pdev->dev, "Invalid LNB\n");
+			return -EINVAL;
+		}
+		if (pt3->lnb != lnb_eff) {
+			writel(pt3_lnb[lnb_eff].bits, pt3->bar_reg + PT3_REG_SYS_W);
+			pt3->lnb = lnb_eff;
+		}
 	}
-	pt3->adaps[index] = adap;
-	adap->adap_idx = index;
+	dev_dbg(&pt3->pdev->dev, "LNB=%s\n", pt3_lnb[lnb_eff].str);
+	return 0;
+}
 
-	if (index == 0 || !one_adapter) {
-		ret = dvb_register_adapter(&adap->dvb_adap, "PT3 DVB",
-				THIS_MODULE, &pt3->pdev->dev, adapter_nr);
+int pt3_thread(void *data)
+{
+	size_t ret;
+	struct pt3_adapter *adap = data;
+
+	dev_dbg(adap->dvb.device, "#%d %s sleep %d\n", adap->idx, __func__, adap->sleep);
+	set_freezable();
+	while (!kthread_should_stop()) {
+		try_to_freeze();
+		while ((ret = pt3_dma_copy(adap->dma, &adap->demux)) > 0)
+			;
 		if (ret < 0) {
-			dev_err(&pt3->pdev->dev,
-				"failed to register adapter dev.\n");
-			goto err_mem;
+			dev_dbg(adap->dvb.device, "#%d fail dma_copy\n", adap->idx);
+			msleep_interruptible(1);
 		}
-		da = &adap->dvb_adap;
-	} else
-		da = &pt3->adaps[0]->dvb_adap;
-
-	adap->dvb_adap.priv = pt3;
-	adap->demux.dmx.capabilities = DMX_TS_FILTERING | DMX_SECTION_FILTERING;
-	adap->demux.priv = adap;
-	adap->demux.feednum = 256;
-	adap->demux.filternum = 256;
-	adap->demux.start_feed = pt3_start_feed;
-	adap->demux.stop_feed = pt3_stop_feed;
-	ret = dvb_dmx_init(&adap->demux);
-	if (ret < 0) {
-		dev_err(&pt3->pdev->dev, "failed to init dmx dev.\n");
-		goto err_adap;
 	}
+	return 0;
+}
 
-	adap->dmxdev.filternum = 256;
-	adap->dmxdev.demux = &adap->demux.dmx;
-	ret = dvb_dmxdev_init(&adap->dmxdev, da);
-	if (ret < 0) {
-		dev_err(&pt3->pdev->dev, "failed to init dmxdev.\n");
-		goto err_demux;
+int pt3_start_feed(struct dvb_demux_feed *feed)
+{
+	int err = 0;
+	struct pt3_adapter *adap = container_of(feed->demux, struct pt3_adapter, demux);
+
+	dev_dbg(adap->dvb.device, "#%d %s sleep %d\n", adap->idx, __func__, adap->sleep);
+	if (!adap->users++) {
+		dev_dbg(adap->dvb.device, "#%d %s selected, DMA %s\n",
+			adap->idx, (pt3_cfg[adap->idx].type == SYS_ISDBS) ? "S" : "T",
+			pt3_dma_get_status(adap->dma) & 1 ? "ON" : "OFF");
+		mutex_lock(&adap->lock);
+		if (!adap->kthread) {
+			adap->kthread = kthread_run(pt3_thread, adap, PT3_DRVNAME "_%d", adap->idx);
+			if (IS_ERR(adap->kthread)) {
+				err = PTR_ERR(adap->kthread);
+				adap->kthread = NULL;
+			} else {
+				pt3_dma_set_test_mode(adap->dma, RESET, 0);	/* reset error count */
+				pt3_dma_set_enabled(adap->dma, true);
+			}
+		}
+		mutex_unlock(&adap->lock);
+		if (err)
+			return err;
 	}
+	return 0;
+}
 
-	ret = pt3_alloc_dmabuf(adap);
-	if (ret) {
-		dev_err(&pt3->pdev->dev, "failed to alloc DMA buffers.\n");
-		goto err_dmabuf;
+int pt3_stop_feed(struct dvb_demux_feed *feed)
+{
+	struct pt3_adapter *adap = container_of(feed->demux, struct pt3_adapter, demux);
+
+	dev_dbg(adap->dvb.device, "#%d %s sleep %d\n", adap->idx, __func__, adap->sleep);
+	if (!--adap->users) {
+		mutex_lock(&adap->lock);
+		if (adap->kthread) {
+			pt3_dma_set_enabled(adap->dma, false);
+			dev_dbg(adap->dvb.device, "#%d DMA ts_err packet cnt %d\n",
+				adap->idx, pt3_dma_get_ts_error_packet_count(adap->dma));
+			kthread_stop(adap->kthread);
+			adap->kthread = NULL;
+		}
+		mutex_unlock(&adap->lock);
 	}
-
 	return 0;
+}
 
-err_dmabuf:
-	pt3_free_dmabuf(adap);
-	dvb_dmxdev_release(&adap->dmxdev);
-err_demux:
-	dvb_dmx_release(&adap->demux);
-err_adap:
-	if (index == 0 || !one_adapter)
-		dvb_unregister_adapter(da);
-err_mem:
+DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
+
+struct pt3_adapter *pt3_dvb_register_adapter(struct pt3_board *pt3)
+{
+	int ret;
+	struct dvb_adapter *dvb;
+	struct dvb_demux *demux;
+	struct dmxdev *dmxdev;
+	struct pt3_adapter *adap = kzalloc(sizeof(struct pt3_adapter), GFP_KERNEL);
+
+	if (!adap)
+		return ERR_PTR(-ENOMEM);
+	adap->pt3 = pt3;
+	adap->sleep = true;
+
+	dvb = &adap->dvb;
+	dvb->priv = adap;
+	ret = dvb_register_adapter(dvb, PT3_DRVNAME, THIS_MODULE, &pt3->pdev->dev, adapter_nr);
+	dev_dbg(dvb->device, "adapter%d registered\n", ret);
+	if (ret >= 0) {
+		demux = &adap->demux;
+		demux->dmx.capabilities = DMX_TS_FILTERING | DMX_SECTION_FILTERING;
+		demux->priv = adap;
+		demux->feednum = 256;
+		demux->filternum = 256;
+		demux->start_feed = pt3_start_feed;
+		demux->stop_feed = pt3_stop_feed;
+		demux->write_to_decoder = NULL;
+		ret = dvb_dmx_init(demux);
+		if (ret >= 0) {
+			dmxdev = &adap->dmxdev;
+			dmxdev->filternum = 256;
+			dmxdev->demux = &demux->dmx;
+			dmxdev->capabilities = 0;
+			ret = dvb_dmxdev_init(dmxdev, dvb);
+			if (ret >= 0)
+				return adap;
+			dvb_dmx_release(demux);
+		}
+		dvb_unregister_adapter(dvb);
+	}
 	kfree(adap);
-	pt3->adaps[index] = NULL;
-	return ret;
+	return ERR_PTR(ret);
 }
 
-static void pt3_cleanup_adapter(struct pt3_board *pt3, int index)
+int pt3_sleep(struct dvb_frontend *fe)
 {
-	struct pt3_adapter *adap;
-	struct dmx_demux *dmx;
+	struct pt3_adapter *adap = container_of(fe->dvb, struct pt3_adapter, dvb);
 
-	adap = pt3->adaps[index];
-	if (adap == NULL)
-		return;
+	dev_dbg(adap->dvb.device, "#%d %s orig %p\n", adap->idx, __func__, adap->orig_sleep);
+	adap->sleep = true;
+	pt3_update_lnb(adap->pt3);
+	return (adap->orig_sleep) ? adap->orig_sleep(fe) : 0;
+}
+
+int pt3_wakeup(struct dvb_frontend *fe)
+{
+	struct pt3_adapter *adap = container_of(fe->dvb, struct pt3_adapter, dvb);
 
-	/* stop demux kthread */
-	if (adap->thread)
-		pt3_stop_streaming(adap);
+	dev_dbg(adap->dvb.device, "#%d %s orig %p\n", adap->idx, __func__, adap->orig_init);
+	adap->sleep = false;
+	pt3_update_lnb(adap->pt3);
+	return (adap->orig_init) ? adap->orig_init(fe) : 0;
+}
+
+void pt3_unregister_subdev(struct i2c_client *clt)
+{
+	if (clt) {
+		module_put(clt->dev.driver->owner);
+		i2c_unregister_device(clt);
+	}
+}
 
-	dmx = &adap->demux.dmx;
-	dmx->close(dmx);
+void pt3_cleanup_adapter(struct pt3_adapter *adap)
+{
+	if (!adap)
+		return;
+	if (adap->kthread)
+		kthread_stop(adap->kthread);
 	if (adap->fe) {
-		adap->fe->callback = NULL;
-		if (adap->fe->frontend_priv)
-			dvb_unregister_frontend(adap->fe);
-		if (adap->i2c_tuner) {
-			module_put(adap->i2c_tuner->dev.driver->owner);
-			i2c_unregister_device(adap->i2c_tuner);
-		}
-		if (adap->i2c_demod) {
-			module_put(adap->i2c_demod->dev.driver->owner);
-			i2c_unregister_device(adap->i2c_demod);
-		}
+		dvb_unregister_frontend(adap->fe);
+		adap->fe->ops.release(adap->fe);
 	}
-	pt3_free_dmabuf(adap);
+	pt3_unregister_subdev(adap->i2c_tuner);
+	pt3_unregister_subdev(adap->i2c_demod);
+	if (adap->dma) {
+		if (adap->dma->enabled)
+			pt3_dma_set_enabled(adap->dma, false);
+		pt3_dma_free(adap->dma);
+	}
+	adap->demux.dmx.close(&adap->demux.dmx);
 	dvb_dmxdev_release(&adap->dmxdev);
 	dvb_dmx_release(&adap->demux);
-	if (index == 0 || !one_adapter)
-		dvb_unregister_adapter(&adap->dvb_adap);
+	dvb_unregister_adapter(&adap->dvb);
 	kfree(adap);
-	pt3->adaps[index] = NULL;
 }
 
-#ifdef CONFIG_PM_SLEEP
-
-static int pt3_suspend(struct device *dev)
+void pt3_remove(struct pci_dev *pdev)
 {
-	struct pci_dev *pdev = to_pci_dev(dev);
-	struct pt3_board *pt3 = pci_get_drvdata(pdev);
 	int i;
-	struct pt3_adapter *adap;
+	struct pt3_board *pt3 = pci_get_drvdata(pdev);
 
-	for (i = 0; i < PT3_NUM_FE; i++) {
-		adap = pt3->adaps[i];
-		if (adap->num_feeds > 0)
-			pt3_stop_dma(adap);
-		dvb_frontend_suspend(adap->fe);
-		pt3_free_dmabuf(adap);
+	if (pt3) {
+		pt3->reset = true;
+		pt3_update_lnb(pt3);
+		for (i = 0; i < PT3_ADAPN; i++)
+			pt3_cleanup_adapter(pt3->adap[i]);
+		pt3_i2c_reset(pt3);
+		i2c_del_adapter(&pt3->i2c);
+		if (pt3->bar_mem)
+			iounmap(pt3->bar_mem);
+		if (pt3->bar_reg)
+			iounmap(pt3->bar_reg);
+		pci_release_selected_regions(pdev, pt3->bars);
+		kfree(pt3->adap);
+		kfree(pt3);
 	}
-
-	pt3_lnb_ctrl(pt3, false);
-	pt3_set_tuner_power(pt3, false, false);
-	return 0;
+	pci_disable_device(pdev);
 }
 
-static int pt3_resume(struct device *dev)
+int pt3_abort(struct pci_dev *pdev, int err, char *fmt, ...)
 {
-	struct pci_dev *pdev = to_pci_dev(dev);
-	struct pt3_board *pt3 = pci_get_drvdata(pdev);
-	int i, ret;
-	struct pt3_adapter *adap;
-
-	ret = pt3_fe_init(pt3);
-	if (ret)
-		return ret;
-
-	if (pt3->lna_on_cnt > 0)
-		pt3_set_tuner_power(pt3, true, true);
-	if (pt3->lnb_on_cnt > 0)
-		pt3_lnb_ctrl(pt3, true);
-
-	for (i = 0; i < PT3_NUM_FE; i++) {
-		adap = pt3->adaps[i];
-		dvb_frontend_resume(adap->fe);
-		ret = pt3_alloc_dmabuf(adap);
-		if (ret) {
-			dev_err(&pt3->pdev->dev, "failed to alloc DMA bufs.\n");
-			continue;
-		}
-		if (adap->num_feeds > 0)
-			pt3_start_dma(adap);
-	}
-
-	return 0;
+	va_list ap;
+	char *s = NULL;
+	int slen;
+
+	va_start(ap, fmt);
+	slen = vsnprintf(s, 0, fmt, ap);
+	s = vzalloc(slen);
+	if (slen > 0 && s) {
+		vsnprintf(s, slen, fmt, ap);
+		dev_err(&pdev->dev, "%s", s);
+		vfree(s);
+	}
+	va_end(ap);
+	pt3_remove(pdev);
+	return err;
 }
 
-#endif /* CONFIG_PM_SLEEP */
-
-
-static void pt3_remove(struct pci_dev *pdev)
+struct i2c_client *pt3_register_subdev(struct i2c_adapter *adap, struct i2c_board_info const *info)
 {
-	struct pt3_board *pt3;
-	int i;
-
-	pt3 = pci_get_drvdata(pdev);
-	for (i = PT3_NUM_FE - 1; i >= 0; i--)
-		pt3_cleanup_adapter(pt3, i);
-	i2c_del_adapter(&pt3->i2c_adap);
-	kfree(pt3->i2c_buf);
-	pci_iounmap(pt3->pdev, pt3->regs[0]);
-	pci_iounmap(pt3->pdev, pt3->regs[1]);
-	pci_release_regions(pdev);
-	pci_disable_device(pdev);
-	kfree(pt3);
+	struct i2c_client *clt;
+
+	request_module("%s", info->type);
+	clt = i2c_new_device(adap, info);
+	if (clt && clt->dev.driver)
+		if (!try_module_get(clt->dev.driver->owner)) {
+			i2c_unregister_device(clt);
+			clt = NULL;
+		}
+	return clt;
 }
 
-static int pt3_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
+int pt3_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
-	u8 rev;
-	u32 ver;
-	int i, ret;
 	struct pt3_board *pt3;
-	struct i2c_adapter *i2c;
-
-	if (pci_read_config_byte(pdev, PCI_REVISION_ID, &rev) || rev != 1)
-		return -ENODEV;
+	struct pt3_adapter *adap;
+	const struct pt3_cfg *cfg = pt3_cfg;
+	struct dvb_frontend *fe[PT3_ADAPN];
+	u8 i;
+	int err, bars = pci_select_bars(pdev, IORESOURCE_MEM);
+
+	err = pci_enable_device(pdev)					||
+		pci_set_dma_mask(pdev, DMA_BIT_MASK(64))		||
+		pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64))	||
+		pci_read_config_byte(pdev, PCI_CLASS_REVISION, &i)	||
+		pci_request_selected_regions(pdev, bars, PT3_DRVNAME);
+	if (err)
+		return pt3_abort(pdev, err, "PCI/DMA error\n");
+	if (i != 1)
+		return pt3_abort(pdev, -EINVAL, "Revision 0x%x is not supported\n", i);
 
-	ret = pci_enable_device(pdev);
-	if (ret < 0)
-		return -ENODEV;
 	pci_set_master(pdev);
-
-	ret = pci_request_regions(pdev, DRV_NAME);
-	if (ret < 0)
-		goto err_disable_device;
-
-	ret = dma_set_mask(&pdev->dev, DMA_BIT_MASK(64));
-	if (ret == 0)
-		dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(64));
-	else {
-		ret = dma_set_mask(&pdev->dev, DMA_BIT_MASK(32));
-		if (ret == 0)
-			dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
-		else {
-			dev_err(&pdev->dev, "Failed to set DMA mask.\n");
-			goto err_release_regions;
-		}
-		dev_info(&pdev->dev, "Use 32bit DMA.\n");
-	}
-
-	pt3 = kzalloc(sizeof(*pt3), GFP_KERNEL);
-	if (!pt3) {
-		dev_err(&pdev->dev, "Failed to alloc mem for this dev.\n");
-		ret = -ENOMEM;
-		goto err_release_regions;
-	}
-	pci_set_drvdata(pdev, pt3);
+	pt3 = kzalloc(sizeof(struct pt3_board), GFP_KERNEL);
+	if (!pt3)
+		return pt3_abort(pdev, -ENOMEM, "struct pt3_board out of memory\n");
+	pt3->adap = kcalloc(PT3_ADAPN, sizeof(struct pt3_adapter *), GFP_KERNEL);
+	if (!pt3->adap)
+		return pt3_abort(pdev, -ENOMEM, "No memory for *adap\n");
+
+	pt3->bars = bars;
 	pt3->pdev = pdev;
+	pci_set_drvdata(pdev, pt3);
+	pt3->bar_reg = pci_ioremap_bar(pdev, 0);
+	pt3->bar_mem = pci_ioremap_bar(pdev, 2);
+	if (!pt3->bar_reg || !pt3->bar_mem)
+		return pt3_abort(pdev, -EIO, "Failed pci_ioremap_bar\n");
+
+	err = readl(pt3->bar_reg + PT3_REG_VERSION);
+	i = ((err >> 24) & 0xFF);
+	if (i != 3)
+		return pt3_abort(pdev, -EIO, "ID=0x%x, not a PT3\n", i);
+	i = ((err >>  8) & 0xFF);
+	if (i != 4)
+		return pt3_abort(pdev, -EIO, "FPGA version 0x%x is not supported\n", i);
+	err = pt3_i2c_add_adapter(pt3);
+	if (err < 0)
+		return pt3_abort(pdev, err, "Cannot add I2C\n");
 	mutex_init(&pt3->lock);
-	pt3->regs[0] = pci_ioremap_bar(pdev, 0);
-	pt3->regs[1] = pci_ioremap_bar(pdev, 2);
-	if (pt3->regs[0] == NULL || pt3->regs[1] == NULL) {
-		dev_err(&pdev->dev, "Failed to ioremap.\n");
-		ret = -ENOMEM;
-		goto err_kfree;
-	}
-
-	ver = ioread32(pt3->regs[0] + REG_VERSION);
-	if ((ver >> 16) != 0x0301) {
-		dev_warn(&pdev->dev, "PT%d, I/F-ver.:%d not supported",
-			ver >> 24, (ver & 0x00ff0000) >> 16);
-		ret = -ENODEV;
-		goto err_iounmap;
-	}
-
-	pt3->num_bufs = clamp_val(num_bufs, MIN_DATA_BUFS, MAX_DATA_BUFS);
-
-	pt3->i2c_buf = kmalloc(sizeof(*pt3->i2c_buf), GFP_KERNEL);
-	if (pt3->i2c_buf == NULL) {
-		dev_err(&pdev->dev, "Failed to alloc mem for i2c.\n");
-		ret = -ENOMEM;
-		goto err_iounmap;
-	}
-	i2c = &pt3->i2c_adap;
-	i2c->owner = THIS_MODULE;
-	i2c->algo = &pt3_i2c_algo;
-	i2c->algo_data = NULL;
-	i2c->dev.parent = &pdev->dev;
-	strlcpy(i2c->name, DRV_NAME, sizeof(i2c->name));
-	i2c_set_adapdata(i2c, pt3);
-	ret = i2c_add_adapter(i2c);
-	if (ret < 0) {
-		dev_err(&pdev->dev, "Failed to add i2c adapter.\n");
-		goto err_i2cbuf;
-	}
-
-	for (i = 0; i < PT3_NUM_FE; i++) {
-		ret = pt3_alloc_adapter(pt3, i);
-		if (ret < 0)
-			break;
-
-		ret = pt3_attach_fe(pt3, i);
-		if (ret < 0)
-			break;
-	}
-	if (i < PT3_NUM_FE) {
-		dev_err(&pdev->dev, "Failed to create FE%d.\n", i);
-		goto err_cleanup_adapters;
-	}
 
-	ret = pt3_fe_init(pt3);
-	if (ret < 0) {
-		dev_err(&pdev->dev, "Failed to init frontends.\n");
-		i = PT3_NUM_FE - 1;
-		goto err_cleanup_adapters;
+	for (i = 0; i < PT3_ADAPN; i++) {
+		adap = pt3_dvb_register_adapter(pt3);
+		if (IS_ERR(adap))
+			return pt3_abort(pdev, PTR_ERR(adap), "Failed pt3_dvb_register_adapter\n");
+		adap->idx = i;
+		adap->dma = pt3_dma_create(adap);
+		if (!adap->dma)
+			return pt3_abort(pdev, -ENOMEM, "Failed pt3_dma_create\n");
+		pt3->adap[i] = adap;
+		adap->sleep = true;
+		mutex_init(&adap->lock);
+	}
+
+	for (i = 0; i < PT3_ADAPN; i++) {
+		struct tc90522_config cfg_demod = {};
+		struct i2c_board_info info = {};
+
+		adap = pt3->adap[i];
+		cfg_demod.type = cfg[i].type;
+		cfg_demod.pwr = i + 1 == PT3_ADAPN;
+		info.addr = cfg[i].addr_demod;
+		info.platform_data = &cfg_demod;
+		strlcpy(info.type, TC90522_DRVNAME, I2C_NAME_SIZE);
+		adap->i2c_demod = pt3_register_subdev(&pt3->i2c, &info);
+		if (!adap->i2c_demod)
+			return pt3_abort(pdev, -ENODEV, "Cannot register I2C demod\n");
+		fe[i] = cfg_demod.fe;
+
+		info.addr = cfg[i].addr_tuner;
+		info.platform_data = fe[i];
+		strlcpy(info.type, cfg[i].type == SYS_ISDBS ? QM1D1C0042_DRVNAME : MXL301RF_DRVNAME, I2C_NAME_SIZE);
+		adap->i2c_tuner = pt3_register_subdev(&pt3->i2c, &info);
+		if (!adap->i2c_tuner)
+			return pt3_abort(pdev, -ENODEV, "Cannot register I2C tuner\n");
+	}
+
+	for (i = 0; i < PT3_ADAPN; i++) {
+		dev_dbg(&pdev->dev, "#%d %s\n", i, __func__);
+		adap = pt3->adap[i];
+		adap->orig_sleep	= fe[i]->ops.sleep;
+		adap->orig_init		= fe[i]->ops.init;
+		fe[i]->ops.sleep	= pt3_sleep;
+		fe[i]->ops.init		= pt3_wakeup;
+		fe[i]->dvb		= &adap->dvb;
+		if ((adap->orig_init(fe[i]) && adap->orig_init(fe[i]) && adap->orig_init(fe[i])) ||
+			adap->orig_sleep(fe[i]) || dvb_register_frontend(&adap->dvb, fe[i])) {
+			while (i--)
+				dvb_unregister_frontend(fe[i]);
+			for (i = 0; i < PT3_ADAPN; i++) {
+				fe[i]->ops.release(fe[i]);
+				adap->fe = NULL;
+			}
+			return pt3_abort(pdev, -EREMOTEIO, "Cannot register frontend\n");
+		}
+		adap->fe = fe[i];
 	}
-
-	dev_info(&pdev->dev,
-		"successfully init'ed PT%d (fw:0x%02x, I/F:0x%02x).\n",
-		ver >> 24, (ver >> 8) & 0xff, (ver >> 16) & 0xff);
+	pt3->reset = true;
+	pt3_update_lnb(pt3);
 	return 0;
-
-err_cleanup_adapters:
-	while (i >= 0)
-		pt3_cleanup_adapter(pt3, i--);
-	i2c_del_adapter(i2c);
-err_i2cbuf:
-	kfree(pt3->i2c_buf);
-err_iounmap:
-	if (pt3->regs[0])
-		pci_iounmap(pdev, pt3->regs[0]);
-	if (pt3->regs[1])
-		pci_iounmap(pdev, pt3->regs[1]);
-err_kfree:
-	kfree(pt3);
-err_release_regions:
-	pci_release_regions(pdev);
-err_disable_device:
-	pci_disable_device(pdev);
-	return ret;
-
 }
 
-static const struct pci_device_id pt3_id_table[] = {
-	{ PCI_DEVICE_SUB(0x1172, 0x4c15, 0xee8d, 0x0368) },
-	{ },
-};
-MODULE_DEVICE_TABLE(pci, pt3_id_table);
-
-static SIMPLE_DEV_PM_OPS(pt3_pm_ops, pt3_suspend, pt3_resume);
-
 static struct pci_driver pt3_driver = {
-	.name		= DRV_NAME,
+	.name		= PT3_DRVNAME,
 	.probe		= pt3_probe,
 	.remove		= pt3_remove,
 	.id_table	= pt3_id_table,
-
-	.driver.pm	= &pt3_pm_ops,
 };
-
 module_pci_driver(pt3_driver);
 
-MODULE_DESCRIPTION("Earthsoft PT3 Driver");
-MODULE_AUTHOR("Akihiro TSUKADA");
-MODULE_LICENSE("GPL");
diff --git a/drivers/media/pci/pt3/pt3.h b/drivers/media/pci/pt3/pt3.h
index 1b3f2ad..13a0c8c 100644
--- a/drivers/media/pci/pt3/pt3.h
+++ b/drivers/media/pci/pt3/pt3.h
@@ -1,12 +1,12 @@
 /*
- * Earthsoft PT3 driver
+ * DVB driver for Earthsoft PT3 ISDB-S/T PCI-E card
  *
- * Copyright (C) 2014 Akihiro Tsukada <tskd08@gmail.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation version 2.
+ * Copyright (C) 2014 Budi Rachmanto, AreMa Inc. <info@are.ma>
  *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
  *
  * This program is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
@@ -14,173 +14,10 @@
  * GNU General Public License for more details.
  */
 
-#ifndef PT3_H
-#define PT3_H
-
-#include <linux/atomic.h>
-#include <linux/types.h>
-
-#include "dvb_demux.h"
-#include "dvb_frontend.h"
-#include "dmxdev.h"
-
-#include "tc90522.h"
-#include "mxl301rf.h"
-#include "qm1d1c0042.h"
-
-#define DRV_NAME KBUILD_MODNAME
-
-#define PT3_NUM_FE 4
-
-/*
- * register index of the FPGA chip
- */
-#define REG_VERSION	0x00
-#define REG_BUS		0x04
-#define REG_SYSTEM_W	0x08
-#define REG_SYSTEM_R	0x0c
-#define REG_I2C_W	0x10
-#define REG_I2C_R	0x14
-#define REG_RAM_W	0x18
-#define REG_RAM_R	0x1c
-#define REG_DMA_BASE	0x40	/* regs for FE[i] = REG_DMA_BASE + 0x18 * i */
-#define OFST_DMA_DESC_L	0x00
-#define OFST_DMA_DESC_H	0x04
-#define OFST_DMA_CTL	0x08
-#define OFST_TS_CTL	0x0c
-#define OFST_STATUS	0x10
-#define OFST_TS_ERR	0x14
-
-/*
- * internal buffer for I2C
- */
-#define PT3_I2C_MAX 4091
-struct pt3_i2cbuf {
-	u8  data[PT3_I2C_MAX];
-	u8  tmp;
-	u32 num_cmds;
-};
-
-/*
- * DMA things
- */
-#define TS_PACKET_SZ  188
-/* DMA transfers must not cross 4GiB, so use one page / transfer */
-#define DATA_XFER_SZ   4096
-#define DATA_BUF_XFERS 47
-/* (num_bufs * DATA_BUF_SZ) % TS_PACKET_SZ must be 0 */
-#define DATA_BUF_SZ    (DATA_BUF_XFERS * DATA_XFER_SZ)
-#define MAX_DATA_BUFS  16
-#define MIN_DATA_BUFS   2
-
-#define DESCS_IN_PAGE (PAGE_SIZE / sizeof(struct xfer_desc))
-#define MAX_NUM_XFERS (MAX_DATA_BUFS * DATA_BUF_XFERS)
-#define MAX_DESC_BUFS DIV_ROUND_UP(MAX_NUM_XFERS, DESCS_IN_PAGE)
-
-/* DMA transfer description.
- * device is passed a pointer to this struct, dma-reads it,
- * and gets the DMA buffer ring for storing TS data.
- */
-struct xfer_desc {
-	u32 addr_l; /* bus address of target data buffer */
-	u32 addr_h;
-	u32 size;
-	u32 next_l; /* bus adddress of the next xfer_desc */
-	u32 next_h;
-};
-
-/* A DMA mapping of a page containing xfer_desc's */
-struct xfer_desc_buffer {
-	dma_addr_t b_addr;
-	struct xfer_desc *descs; /* PAGE_SIZE (xfer_desc[DESCS_IN_PAGE]) */
-};
-
-/* A DMA mapping of a data buffer */
-struct dma_data_buffer {
-	dma_addr_t b_addr;
-	u8 *data; /* size: u8[PAGE_SIZE] */
-};
-
-/*
- * device things
- */
-struct pt3_adap_config {
-	struct i2c_board_info demod_info;
-	struct tc90522_config demod_cfg;
-
-	struct i2c_board_info tuner_info;
-	union tuner_config {
-		struct qm1d1c0042_config qm1d1c0042;
-		struct mxl301rf_config   mxl301rf;
-	} tuner_cfg;
-	u32 init_freq;
-};
-
-struct pt3_adapter {
-	struct dvb_adapter  dvb_adap;  /* dvb_adap.priv => struct pt3_board */
-	int adap_idx;
-
-	struct dvb_demux    demux;
-	struct dmxdev       dmxdev;
-	struct dvb_frontend *fe;
-	struct i2c_client   *i2c_demod;
-	struct i2c_client   *i2c_tuner;
-
-	/* data fetch thread */
-	struct task_struct *thread;
-	int num_feeds;
-
-	bool cur_lna;
-	bool cur_lnb; /* current LNB power status (on/off) */
-
-	/* items below are for DMA */
-	struct dma_data_buffer buffer[MAX_DATA_BUFS];
-	int buf_idx;
-	int buf_ofs;
-	int num_bufs;  /* == pt3_board->num_bufs */
-	int num_discard; /* how many access units to discard initially */
-
-	struct xfer_desc_buffer desc_buf[MAX_DESC_BUFS];
-	int num_desc_bufs;  /* == num_bufs * DATA_BUF_XFERS / DESCS_IN_PAGE */
-};
+#ifndef	__PT3_H__
+#define	__PT3_H__
 
+#define PT3_DRVNAME KBUILD_MODNAME
 
-struct pt3_board {
-	struct pci_dev *pdev;
-	void __iomem *regs[2];
-	/* regs[0]: registers, regs[1]: internal memory, used for I2C */
-
-	struct mutex lock;
-
-	/* LNB power shared among sat-FEs */
-	int lnb_on_cnt; /* LNB power on count */
-
-	/* LNA shared among terr-FEs */
-	int lna_on_cnt; /* booster enabled count */
-
-	int num_bufs;  /* number of DMA buffers allocated/mapped per FE */
-
-	struct i2c_adapter i2c_adap;
-	struct pt3_i2cbuf *i2c_buf;
-
-	struct pt3_adapter *adaps[PT3_NUM_FE];
-};
-
-
-/*
- * prototypes
- */
-extern int  pt3_alloc_dmabuf(struct pt3_adapter *adap);
-extern void pt3_init_dmabuf(struct pt3_adapter *adap);
-extern void pt3_free_dmabuf(struct pt3_adapter *adap);
-extern int  pt3_start_dma(struct pt3_adapter *adap);
-extern int  pt3_stop_dma(struct pt3_adapter *adap);
-extern int  pt3_proc_dma(struct pt3_adapter *adap);
+#endif
 
-extern int  pt3_i2c_master_xfer(struct i2c_adapter *adap,
-				struct i2c_msg *msgs, int num);
-extern u32  pt3_i2c_functionality(struct i2c_adapter *adap);
-extern void pt3_i2c_reset(struct pt3_board *pt3);
-extern int  pt3_init_all_demods(struct pt3_board *pt3);
-extern int  pt3_init_all_mxl301rf(struct pt3_board *pt3);
-#endif /* PT3_H */
diff --git a/drivers/media/pci/pt3/pt3_dma.c b/drivers/media/pci/pt3/pt3_dma.c
deleted file mode 100644
index f0ce904..0000000
--- a/drivers/media/pci/pt3/pt3_dma.c
+++ /dev/null
@@ -1,225 +0,0 @@
-/*
- * Earthsoft PT3 driver
- *
- * Copyright (C) 2014 Akihiro Tsukada <tskd08@gmail.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation version 2.
- *
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- */
-#include <linux/dma-mapping.h>
-#include <linux/kernel.h>
-#include <linux/pci.h>
-
-#include "pt3.h"
-
-#define PT3_ACCESS_UNIT (TS_PACKET_SZ * 128)
-#define PT3_BUF_CANARY  (0x74)
-
-static u32 get_dma_base(int idx)
-{
-	int i;
-
-	i = (idx == 1 || idx == 2) ? 3 - idx : idx;
-	return REG_DMA_BASE + 0x18 * i;
-}
-
-int pt3_stop_dma(struct pt3_adapter *adap)
-{
-	struct pt3_board *pt3 = adap->dvb_adap.priv;
-	u32 base;
-	u32 stat;
-	int retry;
-
-	base = get_dma_base(adap->adap_idx);
-	stat = ioread32(pt3->regs[0] + base + OFST_STATUS);
-	if (!(stat & 0x01))
-		return 0;
-
-	iowrite32(0x02, pt3->regs[0] + base + OFST_DMA_CTL);
-	for (retry = 0; retry < 5; retry++) {
-		stat = ioread32(pt3->regs[0] + base + OFST_STATUS);
-		if (!(stat & 0x01))
-			return 0;
-		msleep(50);
-	}
-	return -EIO;
-}
-
-int pt3_start_dma(struct pt3_adapter *adap)
-{
-	struct pt3_board *pt3 = adap->dvb_adap.priv;
-	u32 base = get_dma_base(adap->adap_idx);
-
-	iowrite32(0x02, pt3->regs[0] + base + OFST_DMA_CTL);
-	iowrite32(lower_32_bits(adap->desc_buf[0].b_addr),
-			pt3->regs[0] + base + OFST_DMA_DESC_L);
-	iowrite32(upper_32_bits(adap->desc_buf[0].b_addr),
-			pt3->regs[0] + base + OFST_DMA_DESC_H);
-	iowrite32(0x01, pt3->regs[0] + base + OFST_DMA_CTL);
-	return 0;
-}
-
-
-static u8 *next_unit(struct pt3_adapter *adap, int *idx, int *ofs)
-{
-	*ofs += PT3_ACCESS_UNIT;
-	if (*ofs >= DATA_BUF_SZ) {
-		*ofs -= DATA_BUF_SZ;
-		(*idx)++;
-		if (*idx == adap->num_bufs)
-			*idx = 0;
-	}
-	return &adap->buffer[*idx].data[*ofs];
-}
-
-int pt3_proc_dma(struct pt3_adapter *adap)
-{
-	int idx, ofs;
-
-	idx = adap->buf_idx;
-	ofs = adap->buf_ofs;
-
-	if (adap->buffer[idx].data[ofs] == PT3_BUF_CANARY)
-		return 0;
-
-	while (*next_unit(adap, &idx, &ofs) != PT3_BUF_CANARY) {
-		u8 *p;
-
-		p = &adap->buffer[adap->buf_idx].data[adap->buf_ofs];
-		if (adap->num_discard > 0)
-			adap->num_discard--;
-		else if (adap->buf_ofs + PT3_ACCESS_UNIT > DATA_BUF_SZ) {
-			dvb_dmx_swfilter_packets(&adap->demux, p,
-				(DATA_BUF_SZ - adap->buf_ofs) / TS_PACKET_SZ);
-			dvb_dmx_swfilter_packets(&adap->demux,
-				adap->buffer[idx].data, ofs / TS_PACKET_SZ);
-		} else
-			dvb_dmx_swfilter_packets(&adap->demux, p,
-				PT3_ACCESS_UNIT / TS_PACKET_SZ);
-
-		*p = PT3_BUF_CANARY;
-		adap->buf_idx = idx;
-		adap->buf_ofs = ofs;
-	}
-	return 0;
-}
-
-void pt3_init_dmabuf(struct pt3_adapter *adap)
-{
-	int idx, ofs;
-	u8 *p;
-
-	idx = 0;
-	ofs = 0;
-	p = adap->buffer[0].data;
-	/* mark the whole buffers as "not written yet" */
-	while (idx < adap->num_bufs) {
-		p[ofs] = PT3_BUF_CANARY;
-		ofs += PT3_ACCESS_UNIT;
-		if (ofs >= DATA_BUF_SZ) {
-			ofs -= DATA_BUF_SZ;
-			idx++;
-			p = adap->buffer[idx].data;
-		}
-	}
-	adap->buf_idx = 0;
-	adap->buf_ofs = 0;
-}
-
-void pt3_free_dmabuf(struct pt3_adapter *adap)
-{
-	struct pt3_board *pt3;
-	int i;
-
-	pt3 = adap->dvb_adap.priv;
-	for (i = 0; i < adap->num_bufs; i++)
-		dma_free_coherent(&pt3->pdev->dev, DATA_BUF_SZ,
-			adap->buffer[i].data, adap->buffer[i].b_addr);
-	adap->num_bufs = 0;
-
-	for (i = 0; i < adap->num_desc_bufs; i++)
-		dma_free_coherent(&pt3->pdev->dev, PAGE_SIZE,
-			adap->desc_buf[i].descs, adap->desc_buf[i].b_addr);
-	adap->num_desc_bufs = 0;
-}
-
-
-int pt3_alloc_dmabuf(struct pt3_adapter *adap)
-{
-	struct pt3_board *pt3;
-	void *p;
-	int i, j;
-	int idx, ofs;
-	int num_desc_bufs;
-	dma_addr_t data_addr, desc_addr;
-	struct xfer_desc *d;
-
-	pt3 = adap->dvb_adap.priv;
-	adap->num_bufs = 0;
-	adap->num_desc_bufs = 0;
-	for (i = 0; i < pt3->num_bufs; i++) {
-		p = dma_alloc_coherent(&pt3->pdev->dev, DATA_BUF_SZ,
-					&adap->buffer[i].b_addr, GFP_KERNEL);
-		if (p == NULL)
-			goto failed;
-		adap->buffer[i].data = p;
-		adap->num_bufs++;
-	}
-	pt3_init_dmabuf(adap);
-
-	/* build circular-linked pointers (xfer_desc) to the data buffers*/
-	idx = 0;
-	ofs = 0;
-	num_desc_bufs =
-		DIV_ROUND_UP(adap->num_bufs * DATA_BUF_XFERS, DESCS_IN_PAGE);
-	for (i = 0; i < num_desc_bufs; i++) {
-		p = dma_alloc_coherent(&pt3->pdev->dev, PAGE_SIZE,
-					&desc_addr, GFP_KERNEL);
-		if (p == NULL)
-			goto failed;
-		adap->num_desc_bufs++;
-		adap->desc_buf[i].descs = p;
-		adap->desc_buf[i].b_addr = desc_addr;
-
-		if (i > 0) {
-			d = &adap->desc_buf[i - 1].descs[DESCS_IN_PAGE - 1];
-			d->next_l = lower_32_bits(desc_addr);
-			d->next_h = upper_32_bits(desc_addr);
-		}
-		for (j = 0; j < DESCS_IN_PAGE; j++) {
-			data_addr = adap->buffer[idx].b_addr + ofs;
-			d = &adap->desc_buf[i].descs[j];
-			d->addr_l = lower_32_bits(data_addr);
-			d->addr_h = upper_32_bits(data_addr);
-			d->size = DATA_XFER_SZ;
-
-			desc_addr += sizeof(struct xfer_desc);
-			d->next_l = lower_32_bits(desc_addr);
-			d->next_h = upper_32_bits(desc_addr);
-
-			ofs += DATA_XFER_SZ;
-			if (ofs >= DATA_BUF_SZ) {
-				ofs -= DATA_BUF_SZ;
-				idx++;
-				if (idx >= adap->num_bufs) {
-					desc_addr = adap->desc_buf[0].b_addr;
-					d->next_l = lower_32_bits(desc_addr);
-					d->next_h = upper_32_bits(desc_addr);
-					return 0;
-				}
-			}
-		}
-	}
-	return 0;
-
-failed:
-	pt3_free_dmabuf(adap);
-	return -ENOMEM;
-}
diff --git a/drivers/media/pci/pt3/pt3_i2c.c b/drivers/media/pci/pt3/pt3_i2c.c
deleted file mode 100644
index ec6a8a2..0000000
--- a/drivers/media/pci/pt3/pt3_i2c.c
+++ /dev/null
@@ -1,240 +0,0 @@
-/*
- * Earthsoft PT3 driver
- *
- * Copyright (C) 2014 Akihiro Tsukada <tskd08@gmail.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation version 2.
- *
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- */
-#include <linux/delay.h>
-#include <linux/device.h>
-#include <linux/i2c.h>
-#include <linux/io.h>
-#include <linux/pci.h>
-
-#include "pt3.h"
-
-#define PT3_I2C_BASE  2048
-#define PT3_CMD_ADDR_NORMAL 0
-#define PT3_CMD_ADDR_INIT_DEMOD  4096
-#define PT3_CMD_ADDR_INIT_TUNER  (4096 + 2042)
-
-/* masks for I2C status register */
-#define STAT_SEQ_RUNNING 0x1
-#define STAT_SEQ_ERROR   0x6
-#define STAT_NO_SEQ      0x8
-
-#define PT3_I2C_RUN   (1 << 16)
-#define PT3_I2C_RESET (1 << 17)
-
-enum ctl_cmd {
-	I_END,
-	I_ADDRESS,
-	I_CLOCK_L,
-	I_CLOCK_H,
-	I_DATA_L,
-	I_DATA_H,
-	I_RESET,
-	I_SLEEP,
-	I_DATA_L_NOP  = 0x08,
-	I_DATA_H_NOP  = 0x0c,
-	I_DATA_H_READ = 0x0d,
-	I_DATA_H_ACK0 = 0x0e,
-	I_DATA_H_ACK1 = 0x0f,
-};
-
-
-static void cmdbuf_add(struct pt3_i2cbuf *cbuf, enum ctl_cmd cmd)
-{
-	int buf_idx;
-
-	if ((cbuf->num_cmds % 2) == 0)
-		cbuf->tmp = cmd;
-	else {
-		cbuf->tmp |= cmd << 4;
-		buf_idx = cbuf->num_cmds / 2;
-		if (buf_idx < ARRAY_SIZE(cbuf->data))
-			cbuf->data[buf_idx] = cbuf->tmp;
-	}
-	cbuf->num_cmds++;
-}
-
-static void put_end(struct pt3_i2cbuf *cbuf)
-{
-	cmdbuf_add(cbuf, I_END);
-	if (cbuf->num_cmds % 2)
-		cmdbuf_add(cbuf, I_END);
-}
-
-static void put_start(struct pt3_i2cbuf *cbuf)
-{
-	cmdbuf_add(cbuf, I_DATA_H);
-	cmdbuf_add(cbuf, I_CLOCK_H);
-	cmdbuf_add(cbuf, I_DATA_L);
-	cmdbuf_add(cbuf, I_CLOCK_L);
-}
-
-static void put_byte_write(struct pt3_i2cbuf *cbuf, u8 val)
-{
-	u8 mask;
-
-	mask = 0x80;
-	for (mask = 0x80; mask > 0; mask >>= 1)
-		cmdbuf_add(cbuf, (val & mask) ? I_DATA_H_NOP : I_DATA_L_NOP);
-	cmdbuf_add(cbuf, I_DATA_H_ACK0);
-}
-
-static void put_byte_read(struct pt3_i2cbuf *cbuf, u32 size)
-{
-	int i, j;
-
-	for (i = 0; i < size; i++) {
-		for (j = 0; j < 8; j++)
-			cmdbuf_add(cbuf, I_DATA_H_READ);
-		cmdbuf_add(cbuf, (i == size - 1) ? I_DATA_H_NOP : I_DATA_L_NOP);
-	}
-}
-
-static void put_stop(struct pt3_i2cbuf *cbuf)
-{
-	cmdbuf_add(cbuf, I_DATA_L);
-	cmdbuf_add(cbuf, I_CLOCK_H);
-	cmdbuf_add(cbuf, I_DATA_H);
-}
-
-
-/* translates msgs to internal commands for bit-banging */
-static void translate(struct pt3_i2cbuf *cbuf, struct i2c_msg *msgs, int num)
-{
-	int i, j;
-	bool rd;
-
-	cbuf->num_cmds = 0;
-	for (i = 0; i < num; i++) {
-		rd = !!(msgs[i].flags & I2C_M_RD);
-		put_start(cbuf);
-		put_byte_write(cbuf, msgs[i].addr << 1 | rd);
-		if (rd)
-			put_byte_read(cbuf, msgs[i].len);
-		else
-			for (j = 0; j < msgs[i].len; j++)
-				put_byte_write(cbuf, msgs[i].buf[j]);
-	}
-	if (num > 0) {
-		put_stop(cbuf);
-		put_end(cbuf);
-	}
-}
-
-static int wait_i2c_result(struct pt3_board *pt3, u32 *result, int max_wait)
-{
-	int i;
-	u32 v;
-
-	for (i = 0; i < max_wait; i++) {
-		v = ioread32(pt3->regs[0] + REG_I2C_R);
-		if (!(v & STAT_SEQ_RUNNING))
-			break;
-		usleep_range(500, 750);
-	}
-	if (i >= max_wait)
-		return -EIO;
-	if (result)
-		*result = v;
-	return 0;
-}
-
-/* send [pre-]translated i2c msgs stored at addr */
-static int send_i2c_cmd(struct pt3_board *pt3, u32 addr)
-{
-	u32 ret;
-
-	/* make sure that previous transactions had finished */
-	if (wait_i2c_result(pt3, NULL, 50)) {
-		dev_warn(&pt3->pdev->dev, "(%s) prev. transaction stalled\n",
-				__func__);
-		return -EIO;
-	}
-
-	iowrite32(PT3_I2C_RUN | addr, pt3->regs[0] + REG_I2C_W);
-	usleep_range(200, 300);
-	/* wait for the current transaction to finish */
-	if (wait_i2c_result(pt3, &ret, 500) || (ret & STAT_SEQ_ERROR)) {
-		dev_warn(&pt3->pdev->dev, "(%s) failed.\n", __func__);
-		return -EIO;
-	}
-	return 0;
-}
-
-
-/* init commands for each demod are combined into one transaction
- *  and hidden in ROM with the address PT3_CMD_ADDR_INIT_DEMOD.
- */
-int  pt3_init_all_demods(struct pt3_board *pt3)
-{
-	ioread32(pt3->regs[0] + REG_I2C_R);
-	return send_i2c_cmd(pt3, PT3_CMD_ADDR_INIT_DEMOD);
-}
-
-/* init commands for two ISDB-T tuners are hidden in ROM. */
-int  pt3_init_all_mxl301rf(struct pt3_board *pt3)
-{
-	usleep_range(1000, 2000);
-	return send_i2c_cmd(pt3, PT3_CMD_ADDR_INIT_TUNER);
-}
-
-void pt3_i2c_reset(struct pt3_board *pt3)
-{
-	iowrite32(PT3_I2C_RESET, pt3->regs[0] + REG_I2C_W);
-}
-
-/*
- * I2C algorithm
- */
-int
-pt3_i2c_master_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs, int num)
-{
-	struct pt3_board *pt3;
-	struct pt3_i2cbuf *cbuf;
-	int i;
-	void __iomem *p;
-
-	pt3 = i2c_get_adapdata(adap);
-	cbuf = pt3->i2c_buf;
-
-	for (i = 0; i < num; i++)
-		if (msgs[i].flags & I2C_M_RECV_LEN) {
-			dev_warn(&pt3->pdev->dev,
-				"(%s) I2C_M_RECV_LEN not supported.\n",
-				__func__);
-			return -EINVAL;
-		}
-
-	translate(cbuf, msgs, num);
-	memcpy_toio(pt3->regs[1] + PT3_I2C_BASE + PT3_CMD_ADDR_NORMAL / 2,
-			cbuf->data, cbuf->num_cmds);
-
-	if (send_i2c_cmd(pt3, PT3_CMD_ADDR_NORMAL) < 0)
-		return -EIO;
-
-	p = pt3->regs[1] + PT3_I2C_BASE;
-	for (i = 0; i < num; i++)
-		if ((msgs[i].flags & I2C_M_RD) && msgs[i].len > 0) {
-			memcpy_fromio(msgs[i].buf, p, msgs[i].len);
-			p += msgs[i].len;
-		}
-
-	return num;
-}
-
-u32 pt3_i2c_functionality(struct i2c_adapter *adap)
-{
-	return I2C_FUNC_I2C;
-}
diff --git a/drivers/media/tuners/mxl301rf.c b/drivers/media/tuners/mxl301rf.c
index 1575a5d..b1ed978 100644
--- a/drivers/media/tuners/mxl301rf.c
+++ b/drivers/media/tuners/mxl301rf.c
@@ -1,12 +1,12 @@
 /*
- * MaxLinear MxL301RF OFDM tuner driver
+ * Sharp VA4M6JC2103 - Earthsoft PT3 ISDB-T tuner MaxLinear CMOS Hybrid TV MxL301RF
  *
- * Copyright (C) 2014 Akihiro Tsukada <tskd08@gmail.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation version 2.
+ * Copyright (C) 2014 Budi Rachmanto, AreMa Inc. <info@are.ma>
  *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
  *
  * This program is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
@@ -14,116 +14,24 @@
  * GNU General Public License for more details.
  */
 
-/*
- * NOTICE:
- * This driver is incomplete and lacks init/config of the chips,
- * as the necessary info is not disclosed.
- * Other features like get_if_frequency() are missing as well.
- * It assumes that users of this driver (such as a PCI bridge of
- * DTV receiver cards) properly init and configure the chip
- * via I2C *before* calling this driver's init() function.
- *
- * Currently, PT3 driver is the only one that uses this driver,
- * and contains init/config code in its firmware.
- * Thus some part of the code might be dependent on PT3 specific config.
- */
-
-#include <linux/kernel.h>
+#include "dvb_frontend.h"
 #include "mxl301rf.h"
 
-struct mxl301rf_state {
-	struct mxl301rf_config cfg;
-	struct i2c_client *i2c;
+struct mxl301rf {
+	struct dvb_frontend *fe;
+	u8 addr_tuner, idx;
+	u32 freq;
+	int (*read)(struct dvb_frontend *fe, u8 *buf, int buflen);
 };
 
-static struct mxl301rf_state *cfg_to_state(struct mxl301rf_config *c)
-{
-	return container_of(c, struct mxl301rf_state, cfg);
-}
-
-static int raw_write(struct mxl301rf_state *state, const u8 *buf, int len)
-{
-	int ret;
-
-	ret = i2c_master_send(state->i2c, buf, len);
-	if (ret >= 0 && ret < len)
-		ret = -EIO;
-	return (ret == len) ? 0 : ret;
-}
-
-static int reg_write(struct mxl301rf_state *state, u8 reg, u8 val)
-{
-	u8 buf[2] = { reg, val };
-
-	return raw_write(state, buf, 2);
-}
-
-static int reg_read(struct mxl301rf_state *state, u8 reg, u8 *val)
-{
-	u8 wbuf[2] = { 0xfb, reg };
-	int ret;
-
-	ret = raw_write(state, wbuf, sizeof(wbuf));
-	if (ret == 0)
-		ret = i2c_master_recv(state->i2c, val, 1);
-	if (ret >= 0 && ret < 1)
-		ret = -EIO;
-	return (ret == 1) ? 0 : ret;
-}
-
-/* tuner_ops */
-
-/* get RSSI and update propery cache, set to *out in % */
-static int mxl301rf_get_rf_strength(struct dvb_frontend *fe, u16 *out)
-{
-	struct mxl301rf_state *state;
-	int ret;
-	u8  rf_in1, rf_in2, rf_off1, rf_off2;
-	u16 rf_in, rf_off;
-	s64 level;
-	struct dtv_fe_stats *rssi;
-
-	rssi = &fe->dtv_property_cache.strength;
-	rssi->len = 1;
-	rssi->stat[0].scale = FE_SCALE_NOT_AVAILABLE;
-	*out = 0;
-
-	state = fe->tuner_priv;
-	ret = reg_write(state, 0x14, 0x01);
-	if (ret < 0)
-		return ret;
-	usleep_range(1000, 2000);
-
-	ret = reg_read(state, 0x18, &rf_in1);
-	if (ret == 0)
-		ret = reg_read(state, 0x19, &rf_in2);
-	if (ret == 0)
-		ret = reg_read(state, 0xd6, &rf_off1);
-	if (ret == 0)
-		ret = reg_read(state, 0xd7, &rf_off2);
-	if (ret != 0)
-		return ret;
-
-	rf_in = (rf_in2 & 0x07) << 8 | rf_in1;
-	rf_off = (rf_off2 & 0x0f) << 5 | (rf_off1 >> 3);
-	level = rf_in - rf_off - (113 << 3); /* x8 dBm */
-	level = level * 1000 / 8;
-	rssi->stat[0].svalue = level;
-	rssi->stat[0].scale = FE_SCALE_DECIBEL;
-	/* *out = (level - min) * 100 / (max - min) */
-	*out = (rf_in - rf_off + (1 << 9) - 1) * 100 / ((5 << 9) - 2);
-	return 0;
-}
-
-/* spur shift parameters */
-struct shf {
-	u32	freq;		/* Channel center frequency */
-	u32	ofst_th;	/* Offset frequency threshold */
-	u8	shf_val;	/* Spur shift value */
-	u8	shf_dir;	/* Spur shift direction */
+struct shf_dvbt {
+	u32	freq,		/* Channel center frequency @ kHz	*/
+		freq_th;	/* Offset frequency threshold @ kHz	*/
+	u8	shf_val,	/* Spur shift value			*/
+		shf_dir;	/* Spur shift direction			*/
 };
 
-static const struct shf shf_tab[] = {
+static const struct shf_dvbt shf_dvbt_tab[] = {
 	{  64500, 500, 0x92, 0x07 },
 	{ 191500, 300, 0xe2, 0x07 },
 	{ 205500, 500, 0x2c, 0x04 },
@@ -143,207 +51,331 @@ static const struct shf shf_tab[] = {
 	{ 153143, 500, 0x01, 0x07 }
 };
 
-struct reg_val {
-	u8 reg;
-	u8 val;
-} __attribute__ ((__packed__));
-
-static const struct reg_val set_idac[] = {
-	{ 0x0d, 0x00 },
-	{ 0x0c, 0x67 },
-	{ 0x6f, 0x89 },
-	{ 0x70, 0x0c },
-	{ 0x6f, 0x8a },
-	{ 0x70, 0x0e },
-	{ 0x6f, 0x8b },
-	{ 0x70, 0x1c },
+static const u32 mxl301rf_rf_tab[112] = {
+	0x058d3f49, 0x05e8ccc9, 0x06445a49, 0x069fe7c9, 0x06fb7549,
+	0x075702c9, 0x07b29049, 0x080e1dc9, 0x0869ab49, 0x08c538c9,
+	0x0920c649, 0x097c53c9, 0x09f665c9, 0x0a51f349, 0x0aad80c9,
+	0x0b090e49, 0x0b649bc9, 0x0ba1a4c9, 0x0bfd3249, 0x0c58bfc9,
+	0x0cb44d49, 0x0d0fdac9, 0x0d6b6849, 0x0dc6f5c9, 0x0e228349,
+	0x0e7e10c9, 0x0ed99e49, 0x0f352bc9, 0x0f90b949, 0x0fec46c9,
+	0x1047d449, 0x10a361c9, 0x10feef49, 0x115a7cc9, 0x11b60a49,
+	0x121197c9, 0x126d2549, 0x12c8b2c9, 0x13244049, 0x137fcdc9,
+	0x13db5b49, 0x1436e8c9, 0x14927649, 0x14ee03c9, 0x15499149,
+	0x15a51ec9, 0x1600ac49, 0x165c39c9, 0x16b7c749, 0x171354c9,
+	0x176ee249, 0x17ca6fc9, 0x1825fd49, 0x18818ac9, 0x18dd1849,
+	0x1938a5c9, 0x19943349, 0x19efc0c9, 0x1a4b4e49, 0x1aa6dbc9,
+	0x1b026949, 0x1b5df6c9, 0x1bb98449, 0x1c339649, 0x1c8f23c9,
+	0x1ceab149, 0x1d463ec9, 0x1da1cc49, 0x1dfd59c9, 0x1e58e749,
+	0x1eb474c9, 0x1f100249, 0x1f6b8fc9, 0x1fc71d49, 0x2022aac9,
+	0x207e3849, 0x20d9c5c9, 0x21355349, 0x2190e0c9, 0x21ec6e49,
+	0x2247fbc9, 0x22a38949, 0x22ff16c9, 0x235aa449, 0x23b631c9,
+	0x2411bf49, 0x246d4cc9, 0x24c8da49, 0x252467c9, 0x257ff549,
+	0x25db82c9, 0x26371049, 0x26929dc9, 0x26ee2b49, 0x2749b8c9,
+	0x27a54649, 0x2800d3c9, 0x285c6149, 0x28b7eec9, 0x29137c49,
+	0x296f09c9, 0x29ca9749, 0x2a2624c9, 0x2a81b249, 0x2add3fc9,
+	0x2b38cd49, 0x2b945ac9, 0x2befe849, 0x2c4b75c9, 0x2ca70349,
+	0x2d0290c9, 0x2d5e1e49,
 };
+#define MXL301RF_NHK (mxl301rf_rf_tab[77])	/* 日本放送協会 Nippon Hōsō Kyōkai, Japan Broadcasting Corporation */
 
-static int mxl301rf_set_params(struct dvb_frontend *fe)
+int mxl301rf_freq(int freq)
 {
-	struct reg_val tune0[] = {
-		{ 0x13, 0x00 },		/* abort tuning */
-		{ 0x3b, 0xc0 },
-		{ 0x3b, 0x80 },
-		{ 0x10, 0x95 },		/* BW */
-		{ 0x1a, 0x05 },
-		{ 0x61, 0x00 },		/* spur shift value (placeholder) */
-		{ 0x62, 0xa0 }		/* spur shift direction (placeholder) */
-	};
+	if (freq >= 90000000)
+		return freq;					/* real_freq Hz	*/
+	if (freq > 255)
+		return MXL301RF_NHK;
+	if (freq > 127)
+		return mxl301rf_rf_tab[freq - 128];		/* freqno (IO#)	*/
+	if (freq > 63) {					/* CATV		*/
+		freq -= 64;
+		if (freq > 22)
+			return mxl301rf_rf_tab[freq - 1];	/* C23-C62	*/
+		if (freq > 12)
+			return mxl301rf_rf_tab[freq - 10];	/* C13-C22	*/
+		return MXL301RF_NHK;
+	}
+	if (freq > 62)
+		return MXL301RF_NHK;
+	if (freq > 12)
+		return mxl301rf_rf_tab[freq + 50];		/* 13-62	*/
+	if (freq >  3)
+		return mxl301rf_rf_tab[freq +  9];		/*  4-12	*/
+	if (freq)
+		return mxl301rf_rf_tab[freq -  1];		/*  1-3		*/
+	return MXL301RF_NHK;
+}
 
-	struct reg_val tune1[] = {
-		{ 0x11, 0x40 },		/* RF frequency L (placeholder) */
-		{ 0x12, 0x0e },		/* RF frequency H (placeholder) */
-		{ 0x13, 0x01 }		/* start tune */
+void mxl301rf_rftune(struct dvb_frontend *fe, u8 *data, u32 *size, u32 freq)
+{
+	u8 rf_data[] = {
+		0x13, 0x00,	/* abort tune			*/
+		0x3b, 0xc0,
+		0x3b, 0x80,
+		0x10, 0x95,	/* BW				*/
+		0x1a, 0x05,
+		0x61, 0x00,
+		0x62, 0xa0,
+		0x11, 0x40,	/* 2 bytes to store RF freq.	*/
+		0x12, 0x0e,	/* 2 bytes to store RF freq.	*/
+		0x13, 0x01	/* start tune			*/
 	};
-
-	struct mxl301rf_state *state;
-	u32 freq;
-	u16 f;
-	u32 tmp, div;
-	int i, ret;
-
-	state = fe->tuner_priv;
-	freq = fe->dtv_property_cache.frequency;
-
-	/* spur shift function (for analog) */
-	for (i = 0; i < ARRAY_SIZE(shf_tab); i++) {
-		if (freq >= (shf_tab[i].freq - shf_tab[i].ofst_th) * 1000 &&
-		    freq <= (shf_tab[i].freq + shf_tab[i].ofst_th) * 1000) {
-			tune0[5].val = shf_tab[i].shf_val;
-			tune0[6].val = 0xa0 | shf_tab[i].shf_dir;
-			break;
-		}
-	}
-	ret = raw_write(state, (u8 *) tune0, sizeof(tune0));
-	if (ret < 0)
-		goto failed;
-	usleep_range(3000, 4000);
-
-	/* convert freq to 10.6 fixed point float [MHz] */
-	f = freq / 1000000;
-	tmp = freq % 1000000;
-	div = 1000000;
+	u32 i, dig_rf_freq, tmp,
+		kHz = 1000,
+		MHz = 1000000,
+		frac_divider = 1000000;
+
+	freq = mxl301rf_freq(freq);
+	dig_rf_freq = freq / MHz;
+	tmp = freq % MHz;
 	for (i = 0; i < 6; i++) {
-		f <<= 1;
-		div >>= 1;
-		if (tmp > div) {
-			tmp -= div;
-			f |= 1;
+		dig_rf_freq <<= 1;
+		frac_divider /= 2;
+		if (tmp > frac_divider) {
+			tmp -= frac_divider;
+			dig_rf_freq++;
 		}
 	}
 	if (tmp > 7812)
-		f++;
-	tune1[0].val = f & 0xff;
-	tune1[1].val = f >> 8;
-	ret = raw_write(state, (u8 *) tune1, sizeof(tune1));
-	if (ret < 0)
-		goto failed;
-	msleep(31);
-
-	ret = reg_write(state, 0x1a, 0x0d);
-	if (ret < 0)
-		goto failed;
-	ret = raw_write(state, (u8 *) set_idac, sizeof(set_idac));
-	if (ret < 0)
-		goto failed;
-	return 0;
+		dig_rf_freq++;
+	rf_data[2 * 7 + 1] = (u8)(dig_rf_freq);
+	rf_data[2 * 8 + 1] = (u8)(dig_rf_freq >> 8);
+
+	for (i = 0; i < ARRAY_SIZE(shf_dvbt_tab); i++) {
+		if ((freq >= (shf_dvbt_tab[i].freq - shf_dvbt_tab[i].freq_th) * kHz) &&
+				(freq <= (shf_dvbt_tab[i].freq + shf_dvbt_tab[i].freq_th) * kHz)) {
+			rf_data[2 * 5 + 1] = shf_dvbt_tab[i].shf_val;
+			rf_data[2 * 6 + 1] = 0xa0 | shf_dvbt_tab[i].shf_dir;
+			break;
+		}
+	}
+	memcpy(data, rf_data, sizeof(rf_data));
+	*size = sizeof(rf_data);
 
-failed:
-	dev_warn(&state->i2c->dev, "(%s) failed. [adap%d-fe%d]\n",
-		__func__, fe->dvb->num, fe->id);
-	return ret;
+	dev_dbg(fe->dvb->device, "mx_rftune freq=%d\n", freq);
 }
 
-static const struct reg_val standby_data[] = {
-	{ 0x01, 0x00 },
-	{ 0x13, 0x00 }
-};
-
-static int mxl301rf_sleep(struct dvb_frontend *fe)
+/* write via demodulator */
+int mxl301rf_fe_write_data(struct dvb_frontend *fe, u8 addr_data, const u8 *data, int len)
 {
-	struct mxl301rf_state *state;
-	int ret;
+	u8 buf[len + 1];
 
-	state = fe->tuner_priv;
-	ret = raw_write(state, (u8 *)standby_data, sizeof(standby_data));
-	if (ret < 0)
-		dev_warn(&state->i2c->dev, "(%s) failed. [adap%d-fe%d]\n",
-			__func__, fe->dvb->num, fe->id);
-	return ret;
+	buf[0] = addr_data;
+	memcpy(buf + 1, data, len);
+	return fe->ops.write(fe, buf, len + 1);
 }
 
+#define MXL301RF_FE_PASSTHROUGH 0xfe
 
-/* init sequence is not public.
- * the parent must have init'ed the device.
- * just wake up here.
- */
-static int mxl301rf_init(struct dvb_frontend *fe)
+int mxl301rf_fe_write_tuner(struct dvb_frontend *fe, const u8 *data, int len)
 {
-	struct mxl301rf_state *state;
+	u8 buf[len + 2];
+
+	buf[0] = MXL301RF_FE_PASSTHROUGH;
+	buf[1] = ((struct mxl301rf *)fe->tuner_priv)->addr_tuner << 1;
+	memcpy(buf + 2, data, len);
+	return fe->ops.write(fe, buf, len + 2);
+}
+
+/* read via demodulator */
+void mxl301rf_fe_read(struct dvb_frontend *fe, u8 addr, u8 *data)
+{
+	struct mxl301rf *mx = fe->tuner_priv;
+	const u8 wbuf[2] = {0xfb, addr};
 	int ret;
 
-	state = fe->tuner_priv;
+	mxl301rf_fe_write_tuner(fe, wbuf, sizeof(wbuf));
+	ret = mx->read(fe, &mx->addr_tuner, 1);
+	if (ret >= 0)
+		*data = ret;
+}
 
-	ret = reg_write(state, 0x01, 0x01);
-	if (ret < 0) {
-		dev_warn(&state->i2c->dev, "(%s) failed. [adap%d-fe%d]\n",
-			 __func__, fe->dvb->num, fe->id);
-		return ret;
-	}
-	return 0;
+void mxl301rf_idac_setting(struct dvb_frontend *fe)
+{
+	const u8 idac[] = {
+		0x0d, 0x00,
+		0x0c, 0x67,
+		0x6f, 0x89,
+		0x70, 0x0c,
+		0x6f, 0x8a,
+		0x70, 0x0e,
+		0x6f, 0x8b,
+		0x70, 0x10+12,
+	};
+	mxl301rf_fe_write_tuner(fe, idac, sizeof(idac));
 }
 
-/* I2C driver functions */
+void mxl301rf_set_register(struct dvb_frontend *fe, u8 addr, u8 value)
+{
+	const u8 data[2] = {addr, value};
 
-static const struct dvb_tuner_ops mxl301rf_ops = {
-	.info = {
-		.name = "MaxLinear MxL301RF",
+	mxl301rf_fe_write_tuner(fe, data, sizeof(data));
+}
 
-		.frequency_min =  93000000,
-		.frequency_max = 803142857,
-	},
+int mxl301rf_write_imsrst(struct dvb_frontend *fe)
+{
+	u8 data = 0x01 << 6;
 
-	.init = mxl301rf_init,
-	.sleep = mxl301rf_sleep,
+	return mxl301rf_fe_write_data(fe, 0x01, &data, 1);
+}
 
-	.set_params = mxl301rf_set_params,
-	.get_rf_strength = mxl301rf_get_rf_strength,
+enum mxl301rf_agc {
+	MXL301RF_AGC_AUTO,
+	MXL301RF_AGC_MANUAL,
 };
 
+int mxl301rf_set_agc(struct dvb_frontend *fe, enum mxl301rf_agc agc)
+{
+	u8 data = (agc == MXL301RF_AGC_AUTO) ? 0x40 : 0x00;
+	int err = mxl301rf_fe_write_data(fe, 0x25, &data, 1);
+
+	if (err)
+		return err;
+	data = 0x4c | ((agc == MXL301RF_AGC_AUTO) ? 0x00 : 0x01);
+	return	mxl301rf_fe_write_data(fe, 0x23, &data, 1) ||
+		mxl301rf_write_imsrst(fe);
+}
 
-static int mxl301rf_probe(struct i2c_client *client,
-			  const struct i2c_device_id *id)
+int mxl301rf_sleep(struct dvb_frontend *fe)
 {
-	struct mxl301rf_state *state;
-	struct mxl301rf_config *cfg;
-	struct dvb_frontend *fe;
+	u8 buf = (1 << 7) | (1 << 4);
+	const u8 data[4] = {0x01, 0x00, 0x13, 0x00};
+	int err = mxl301rf_set_agc(fe, MXL301RF_AGC_MANUAL);
+
+	if (err)
+		return err;
+	mxl301rf_fe_write_tuner(fe, data, sizeof(data));
+	return mxl301rf_fe_write_data(fe, 0x03, &buf, 1);
+}
 
-	state = kzalloc(sizeof(*state), GFP_KERNEL);
-	if (!state)
-		return -ENOMEM;
+bool mxl301rf_rfsynth_locked(struct dvb_frontend *fe)
+{
+	u8 data;
 
-	state->i2c = client;
-	cfg = client->dev.platform_data;
+	mxl301rf_fe_read(fe, 0x16, &data);
+	return (data & 0x0c) == 0x0c;
+}
 
-	memcpy(&state->cfg, cfg, sizeof(state->cfg));
-	fe = cfg->fe;
-	fe->tuner_priv = state;
-	memcpy(&fe->ops.tuner_ops, &mxl301rf_ops, sizeof(mxl301rf_ops));
+bool mxl301rf_refsynth_locked(struct dvb_frontend *fe)
+{
+	u8 data;
 
-	i2c_set_clientdata(client, &state->cfg);
-	dev_info(&client->dev, "MaxLinear MxL301RF attached.\n");
+	mxl301rf_fe_read(fe, 0x16, &data);
+	return (data & 0x03) == 0x03;
+}
+
+bool mxl301rf_locked(struct dvb_frontend *fe)
+{
+	bool locked1 = false, locked2 = false;
+	unsigned long timeout = jiffies + msecs_to_jiffies(100);
+
+	while (time_before(jiffies, timeout)) {
+		locked1 = mxl301rf_rfsynth_locked(fe);
+		locked2 = mxl301rf_refsynth_locked(fe);
+		if (locked1 && locked2)
+			break;
+		msleep_interruptible(1);
+	}
+	dev_dbg(fe->dvb->device, "#%d %s lock1=%d lock2=%d\n", ((struct mxl301rf *)fe->tuner_priv)->idx, __func__, locked1, locked2);
+	return locked1 && locked2 ? !mxl301rf_set_agc(fe, MXL301RF_AGC_AUTO) : false;
+}
+
+int mxl301rf_tuner_rftune(struct dvb_frontend *fe, u32 freq)
+{
+	struct mxl301rf *mx = fe->tuner_priv;
+	u8 data[100];
+	u32 size = 0;
+	int err = mxl301rf_set_agc(fe, MXL301RF_AGC_MANUAL);
+
+	if (err)
+		return err;
+	mx->freq = freq;
+	mxl301rf_rftune(fe, data, &size, freq);
+	if (size != 20) {
+		dev_dbg(fe->dvb->device, "fail mx_rftune size = %d\n", size);
+		return -EINVAL;
+	}
+	mxl301rf_fe_write_tuner(fe, data, 14);
+	msleep_interruptible(1);
+	mxl301rf_fe_write_tuner(fe, data + 14, 6);
+	msleep_interruptible(1);
+	mxl301rf_set_register(fe, 0x1a, 0x0d);
+	mxl301rf_idac_setting(fe);
+	return mxl301rf_locked(fe) ? 0 : -ETIMEDOUT;
+}
+
+int mxl301rf_wakeup(struct dvb_frontend *fe)
+{
+	struct mxl301rf *mx = fe->tuner_priv;
+	int err;
+	u8 buf = (1 << 7) | (0 << 4);
+	const u8 data[2] = {0x01, 0x01};
+
+	err = mxl301rf_fe_write_data(fe, 0x03, &buf, 1);
+	if (err)
+		return err;
+	mxl301rf_fe_write_tuner(fe, data, sizeof(data));
+	mxl301rf_tuner_rftune(fe, mx->freq);
 	return 0;
 }
 
-static int mxl301rf_remove(struct i2c_client *client)
+static struct dvb_tuner_ops mxl301rf_ops = {
+	.info = {
+		.frequency_min	= 1,		/* freq under 90 MHz is handled as channel */
+		.frequency_max	= 770000000,	/* Hz */
+		.frequency_step	= 142857,
+	},
+	.set_frequency = mxl301rf_tuner_rftune,
+	.sleep = mxl301rf_sleep,
+	.init = mxl301rf_wakeup,
+};
+
+int mxl301rf_remove(struct i2c_client *client)
 {
-	struct mxl301rf_state *state;
+	struct dvb_frontend *fe = i2c_get_clientdata(client);
 
-	state = cfg_to_state(i2c_get_clientdata(client));
-	state->cfg.fe->tuner_priv = NULL;
-	kfree(state);
+	dev_dbg(&client->dev, "%s\n", __func__);
+	kfree(fe->tuner_priv);
+	fe->tuner_priv = NULL;
 	return 0;
 }
 
+int mxl301rf_probe(struct i2c_client *client, const struct i2c_device_id *id)
+{
+	u8 d[] = { 0x10, 0x01 };
+	struct dvb_frontend *fe = client->dev.platform_data;
+	struct mxl301rf *mx = kzalloc(sizeof(struct mxl301rf), GFP_KERNEL);
 
-static const struct i2c_device_id mxl301rf_id[] = {
-	{"mxl301rf", 0},
-	{}
+	if (!mx)
+		return -ENOMEM;
+	fe->tuner_priv = mx;
+	mx->fe = fe;
+	mx->idx = (client->addr & 1) | 2;
+	mx->addr_tuner = client->addr;
+	mx->read = fe->ops.tuner_ops.calc_regs;
+	memcpy(&fe->ops.tuner_ops, &mxl301rf_ops, sizeof(struct dvb_tuner_ops));
+	i2c_set_clientdata(client, fe);
+	return	mxl301rf_fe_write_data(fe, 0x1c, d, 1)	||
+		mxl301rf_fe_write_data(fe, 0x1d, d+1, 1);
+}
+
+static struct i2c_device_id mxl301rf_id_table[] = {
+	{ MXL301RF_DRVNAME, 0 },
+	{ },
 };
-MODULE_DEVICE_TABLE(i2c, mxl301rf_id);
+MODULE_DEVICE_TABLE(i2c, mxl301rf_id_table);
 
 static struct i2c_driver mxl301rf_driver = {
 	.driver = {
-		.name	= "mxl301rf",
+		.owner	= THIS_MODULE,
+		.name	= mxl301rf_id_table->name,
 	},
 	.probe		= mxl301rf_probe,
 	.remove		= mxl301rf_remove,
-	.id_table	= mxl301rf_id,
+	.id_table	= mxl301rf_id_table,
 };
-
 module_i2c_driver(mxl301rf_driver);
 
-MODULE_DESCRIPTION("MaxLinear MXL301RF tuner");
-MODULE_AUTHOR("Akihiro TSUKADA");
+MODULE_AUTHOR("Budi Rachmanto, AreMa Inc. <knightrider(@)are.ma>");
+MODULE_DESCRIPTION("Earthsoft PT3 MxL301RF MaxLinear CMOS Hybrid TV ISDB-T tuner driver");
 MODULE_LICENSE("GPL");
+
diff --git a/drivers/media/tuners/mxl301rf.h b/drivers/media/tuners/mxl301rf.h
index 19e6840..a5334e7 100644
--- a/drivers/media/tuners/mxl301rf.h
+++ b/drivers/media/tuners/mxl301rf.h
@@ -1,12 +1,12 @@
 /*
- * MaxLinear MxL301RF OFDM tuner driver
+ * Sharp VA4M6JC2103 - Earthsoft PT3 ISDB-T tuner MaxLinear CMOS Hybrid TV MxL301RF
  *
- * Copyright (C) 2014 Akihiro Tsukada <tskd08@gmail.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation version 2.
+ * Copyright (C) 2014 Budi Rachmanto, AreMa Inc. <info@are.ma>
  *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
  *
  * This program is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
@@ -14,13 +14,10 @@
  * GNU General Public License for more details.
  */
 
-#ifndef MXL301RF_H
-#define MXL301RF_H
+#ifndef __MXL301RF_H__
+#define __MXL301RF_H__
 
-#include "dvb_frontend.h"
+#define MXL301RF_DRVNAME "mxl301rf"
 
-struct mxl301rf_config {
-	struct dvb_frontend *fe;
-};
+#endif
 
-#endif /* MXL301RF_H */
diff --git a/drivers/media/tuners/qm1d1c0042.c b/drivers/media/tuners/qm1d1c0042.c
index 18bc745..39adc0a 100644
--- a/drivers/media/tuners/qm1d1c0042.c
+++ b/drivers/media/tuners/qm1d1c0042.c
@@ -1,12 +1,12 @@
 /*
- * Sharp QM1D1C0042 8PSK tuner driver
+ * Sharp VA4M6JC2103 - Earthsoft PT3 ISDB-S tuner driver QM1D1C0042
  *
- * Copyright (C) 2014 Akihiro Tsukada <tskd08@gmail.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation version 2.
+ * Copyright (C) 2014 Budi Rachmanto, AreMa Inc. <info@are.ma>
  *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
  *
  * This program is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
@@ -14,156 +14,145 @@
  * GNU General Public License for more details.
  */
 
-/*
- * NOTICE:
- * As the disclosed information on the chip is very limited,
- * this driver lacks some features, including chip config like IF freq.
- * It assumes that users of this driver (such as a PCI bridge of
- * DTV receiver cards) know the relevant info and
- * configure the chip via I2C if necessary.
- *
- * Currently, PT3 driver is the only one that uses this driver,
- * and contains init/config code in its firmware.
- * Thus some part of the code might be dependent on PT3 specific config.
- */
-
-#include <linux/kernel.h>
-#include <linux/math64.h>
+#include "dvb_frontend.h"
 #include "qm1d1c0042.h"
 
-#define QM1D1C0042_NUM_REGS 0x20
+struct qm1d1c0042 {
+	struct dvb_frontend *fe;
+	u8 addr_tuner, idx, reg[32];
+	u32 freq;
+	int (*read)(struct dvb_frontend *fe, u8 *buf, int buflen);
+};
 
-static const u8 reg_initval[QM1D1C0042_NUM_REGS] = {
+static const u8 qm1d1c0042_reg_rw[] = {
 	0x48, 0x1c, 0xa0, 0x10, 0xbc, 0xc5, 0x20, 0x33,
 	0x06, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00,
 	0x00, 0xff, 0xf3, 0x00, 0x2a, 0x64, 0xa6, 0x86,
-	0x8c, 0xcf, 0xb8, 0xf1, 0xa8, 0xf2, 0x89, 0x00
-};
-
-static const struct qm1d1c0042_config default_cfg = {
-	.xtal_freq = 16000,
-	.lpf = 1,
-	.fast_srch = 0,
-	.lpf_wait = 20,
-	.fast_srch_wait = 4,
-	.normal_srch_wait = 15,
+	0x8c, 0xcf, 0xb8, 0xf1, 0xa8, 0xf2, 0x89, 0x00,
 };
 
-struct qm1d1c0042_state {
-	struct qm1d1c0042_config cfg;
-	struct i2c_client *i2c;
-	u8 regs[QM1D1C0042_NUM_REGS];
-};
-
-static struct qm1d1c0042_state *cfg_to_state(struct qm1d1c0042_config *c)
-{
-	return container_of(c, struct qm1d1c0042_state, cfg);
-}
-
-static int reg_write(struct qm1d1c0042_state *state, u8 reg, u8 val)
+/* read via demodulator */
+int qm1d1c0042_fe_read(struct dvb_frontend *fe, u8 addr_data, u8 *data)
 {
-	u8 wbuf[2] = { reg, val };
 	int ret;
+	struct qm1d1c0042 *qm = fe->tuner_priv;
+	u8 addr[] = { qm->addr_tuner, addr_data };
 
-	ret = i2c_master_send(state->i2c, wbuf, sizeof(wbuf));
-	if (ret >= 0 && ret < sizeof(wbuf))
-		ret = -EIO;
-	return (ret == sizeof(wbuf)) ? 0 : ret;
+	if ((addr_data != 0x00) && (addr_data != 0x0d))
+		return -EFAULT;
+	ret = qm->read(fe, addr, ARRAY_SIZE(addr));
+	if (ret < 0)
+		return ret;
+	*data = ret;
+	return 0;
 }
 
-static int reg_read(struct qm1d1c0042_state *state, u8 reg, u8 *val)
+/* write via demodulator */
+int qm1d1c0042_fe_write_data(struct dvb_frontend *fe, u8 addr_data, u8 *data, int len)
 {
-	struct i2c_msg msgs[2] = {
-		{
-			.addr = state->i2c->addr,
-			.flags = 0,
-			.buf = &reg,
-			.len = 1,
-		},
-		{
-			.addr = state->i2c->addr,
-			.flags = I2C_M_RD,
-			.buf = val,
-			.len = 1,
-		},
-	};
-	int ret;
+	u8 buf[len + 1];
 
-	ret = i2c_transfer(state->i2c->adapter, msgs, ARRAY_SIZE(msgs));
-	if (ret >= 0 && ret < ARRAY_SIZE(msgs))
-		ret = -EIO;
-	return (ret == ARRAY_SIZE(msgs)) ? 0 : ret;
+	buf[0] = addr_data;
+	memcpy(buf + 1, data, len);
+	return fe->ops.write(fe, buf, len + 1);
 }
 
+#define QM1D1C0042_FE_PASSTHROUGH 0xfe
 
-static int qm1d1c0042_set_srch_mode(struct qm1d1c0042_state *state, bool fast)
+int qm1d1c0042_fe_write_tuner(struct dvb_frontend *fe, u8 *data, int len)
 {
-	if (fast)
-		state->regs[0x03] |= 0x01; /* set fast search mode */
-	else
-		state->regs[0x03] &= ~0x01 & 0xff;
+	u8 buf[len + 2];
 
-	return reg_write(state, 0x03, state->regs[0x03]);
+	buf[0] = QM1D1C0042_FE_PASSTHROUGH;
+	buf[1] = ((struct qm1d1c0042 *)fe->tuner_priv)->addr_tuner << 1;
+	memcpy(buf + 2, data, len);
+	return fe->ops.write(fe, buf, len + 2);
 }
 
-static int qm1d1c0042_wakeup(struct qm1d1c0042_state *state)
+int qm1d1c0042_write(struct dvb_frontend *fe, u8 addr, u8 data)
 {
-	int ret;
-
-	state->regs[0x01] |= 1 << 3;             /* BB_Reg_enable */
-	state->regs[0x01] &= (~(1 << 0)) & 0xff; /* NORMAL (wake-up) */
-	state->regs[0x05] &= (~(1 << 3)) & 0xff; /* pfd_rst NORMAL */
-	ret = reg_write(state, 0x01, state->regs[0x01]);
-	if (ret == 0)
-		ret = reg_write(state, 0x05, state->regs[0x05]);
+	struct qm1d1c0042 *qm = fe->tuner_priv;
+	u8 buf[] = { addr, data };
+	int err = qm1d1c0042_fe_write_tuner(fe, buf, sizeof(buf));
 
-	if (ret < 0)
-		dev_warn(&state->i2c->dev, "(%s) failed. [adap%d-fe%d]\n",
-			__func__, state->cfg.fe->dvb->num, state->cfg.fe->id);
-	return ret;
+	qm->reg[addr] = buf[1];
+	return err;
 }
 
-/* tuner_ops */
-
-static int qm1d1c0042_set_config(struct dvb_frontend *fe, void *priv_cfg)
+int qm1d1c0042_write_pskmsrst(struct dvb_frontend *fe)
 {
-	struct qm1d1c0042_state *state;
-	struct qm1d1c0042_config *cfg;
-
-	state = fe->tuner_priv;
-	cfg = priv_cfg;
+	u8 data = 0x01;
 
-	if (cfg->fe)
-		state->cfg.fe = cfg->fe;
+	return qm1d1c0042_fe_write_data(fe, 0x03, &data, 1);
+}
 
-	if (cfg->xtal_freq != QM1D1C0042_CFG_XTAL_DFLT)
-		dev_warn(&state->i2c->dev,
-			"(%s) changing xtal_freq not supported. ", __func__);
-	state->cfg.xtal_freq = default_cfg.xtal_freq;
+enum qm1d1c0042_agc {
+	QM1D1C0042_AGC_AUTO,
+	QM1D1C0042_AGC_MANUAL,
+};
 
-	state->cfg.lpf = cfg->lpf;
-	state->cfg.fast_srch = cfg->fast_srch;
+int qm1d1c0042_set_agc(struct dvb_frontend *fe, enum qm1d1c0042_agc agc)
+{
+	u8 data = (agc == QM1D1C0042_AGC_AUTO) ? 0xff : 0x00;
+	int err = qm1d1c0042_fe_write_data(fe, 0x0a, &data, 1);
+
+	if (err)
+		return err;
+	data = 0xb0 | ((agc == QM1D1C0042_AGC_AUTO) ? 1 : 0);
+	err = qm1d1c0042_fe_write_data(fe, 0x10, &data, 1);
+	if (err)
+		return err;
+
+	data = (agc == QM1D1C0042_AGC_AUTO) ? 0x40 : 0x00;
+	return (err = qm1d1c0042_fe_write_data(fe, 0x11, &data, 1)) ? err : qm1d1c0042_write_pskmsrst(fe);
+}
 
-	if (cfg->lpf_wait != QM1D1C0042_CFG_WAIT_DFLT)
-		state->cfg.lpf_wait = cfg->lpf_wait;
-	else
-		state->cfg.lpf_wait = default_cfg.lpf_wait;
+int qm1d1c0042_sleep(struct dvb_frontend *fe)
+{
+	struct qm1d1c0042 *qm = fe->tuner_priv;
+	u8 buf = 1;
+
+	dev_dbg(fe->dvb->device, "#%d %s\n", qm->idx, __func__);
+	qm->reg[0x01] &= (~(1 << 3)) & 0xff;
+	qm->reg[0x01] |= 1 << 0;
+	qm->reg[0x05] |= 1 << 3;
+	return	qm1d1c0042_set_agc(fe, QM1D1C0042_AGC_MANUAL)	||
+		qm1d1c0042_write(fe, 0x05, qm->reg[0x05])	||
+		qm1d1c0042_write(fe, 0x01, qm->reg[0x01])	||
+		qm1d1c0042_fe_write_data(fe, 0x17, &buf, 1);
+}
 
-	if (cfg->fast_srch_wait != QM1D1C0042_CFG_WAIT_DFLT)
-		state->cfg.fast_srch_wait = cfg->fast_srch_wait;
-	else
-		state->cfg.fast_srch_wait = default_cfg.fast_srch_wait;
+int qm1d1c0042_wakeup(struct dvb_frontend *fe)
+{
+	struct qm1d1c0042 *qm = fe->tuner_priv;
+	u8 buf = 0;
+
+	dev_dbg(fe->dvb->device, "#%d %s\n", qm->idx, __func__);
+	qm->reg[0x01] |= 1 << 3;
+	qm->reg[0x01] &= (~(1 << 0)) & 0xff;
+	qm->reg[0x05] &= (~(1 << 3)) & 0xff;
+	return	qm1d1c0042_fe_write_data(fe, 0x17, &buf, 1)	||
+		qm1d1c0042_write(fe, 0x01, qm->reg[0x01])	||
+		qm1d1c0042_write(fe, 0x05, qm->reg[0x05]);
+}
 
-	if (cfg->normal_srch_wait != QM1D1C0042_CFG_WAIT_DFLT)
-		state->cfg.normal_srch_wait = cfg->normal_srch_wait;
-	else
-		state->cfg.normal_srch_wait = default_cfg.normal_srch_wait;
-	return 0;
+void qm1d1c0042_ch2freq(u32 channel, u32 *number, u32 *freq)
+{
+	if (channel < 12) {
+		*number = 1 + 2 * channel;
+		*freq = 104948 + 3836 * channel;
+	} else if (channel < 24) {
+		channel -= 12;
+		*number = 2 + 2 * channel;
+		*freq = 161300 + 4000 * channel;
+	} else {
+		channel -= 24;
+		*number = 1 + 2 * channel;
+		*freq = 159300 + 4000 * channel;
+	}
 }
 
-/* divisor, vco_band parameters */
-/*  {maxfreq,  param1(band?), param2(div?) */
-static const u32 conv_table[9][3] = {
+static const u32 qm1d1c0042_freq_tab[9][3] = {
 	{ 2151000, 1, 7 },
 	{ 1950000, 1, 6 },
 	{ 1800000, 1, 5 },
@@ -175,274 +164,233 @@ static const u32 conv_table[9][3] = {
 	{  950000, 0, 0 }
 };
 
-static int qm1d1c0042_set_params(struct dvb_frontend *fe)
+static const u32 qm1d1c0042_sd_tab[24][3] = {
+	{0x38fae1, 0x0d, 0x5},
+	{0x3f570a, 0x0e, 0x3},
+	{0x05b333, 0x0e, 0x5},
+	{0x3c0f5c, 0x0f, 0x4},
+	{0x026b85, 0x0f, 0x6},
+	{0x38c7ae, 0x10, 0x5},
+	{0x3f23d7, 0x11, 0x3},
+	{0x058000, 0x11, 0x5},
+	{0x3bdc28, 0x12, 0x4},
+	{0x023851, 0x12, 0x6},
+	{0x38947a, 0x13, 0x5},
+	{0x3ef0a3, 0x14, 0x3},
+	{0x3c8000, 0x16, 0x4},
+	{0x048000, 0x16, 0x6},
+	{0x3c8000, 0x17, 0x5},
+	{0x048000, 0x18, 0x3},
+	{0x3c8000, 0x18, 0x6},
+	{0x048000, 0x19, 0x4},
+	{0x3c8000, 0x1a, 0x3},
+	{0x048000, 0x1a, 0x5},
+	{0x3c8000, 0x1b, 0x4},
+	{0x048000, 0x1b, 0x6},
+	{0x3c8000, 0x1c, 0x5},
+	{0x048000, 0x1d, 0x3},
+};
+
+static int qm1d1c0042_tuning(struct qm1d1c0042 *qm, u32 *sd, u32 channel)
 {
-	struct qm1d1c0042_state *state;
-	u32 freq;
-	int i, ret;
-	u8 val, mask;
-	u32 a, sd;
-	s32 b;
-
-	state = fe->tuner_priv;
-	freq = fe->dtv_property_cache.frequency;
-
-	state->regs[0x08] &= 0xf0;
-	state->regs[0x08] |= 0x09;
-
-	state->regs[0x13] &= 0x9f;
-	state->regs[0x13] |= 0x20;
-
-	/* div2/vco_band */
-	val = state->regs[0x02] & 0x0f;
-	for (i = 0; i < 8; i++)
-		if (freq < conv_table[i][0] && freq >= conv_table[i + 1][0]) {
-			val |= conv_table[i][1] << 7;
-			val |= conv_table[i][2] << 4;
-			break;
+	int ret;
+	struct dvb_frontend *fe = qm->fe;
+	u8 i_data;
+	u32 i, N, A;
+
+	qm->reg[0x08] &= 0xf0;
+	qm->reg[0x08] |= 0x09;
+
+	qm->reg[0x13] &= 0x9f;
+	qm->reg[0x13] |= 0x20;
+
+	for (i = 0; i < 8; i++) {
+		if ((qm1d1c0042_freq_tab[i+1][0] <= qm->freq) && (qm->freq < qm1d1c0042_freq_tab[i][0])) {
+			i_data = qm->reg[0x02];
+			i_data &= 0x0f;
+			i_data |= qm1d1c0042_freq_tab[i][1] << 7;
+			i_data |= qm1d1c0042_freq_tab[i][2] << 4;
+			qm1d1c0042_write(fe, 0x02, i_data);
 		}
-	ret = reg_write(state, 0x02, val);
-	if (ret < 0)
-		return ret;
-
-	a = (freq + state->cfg.xtal_freq / 2) / state->cfg.xtal_freq;
-
-	state->regs[0x06] &= 0x40;
-	state->regs[0x06] |= (a - 12) / 4;
-	ret = reg_write(state, 0x06, state->regs[0x06]);
-	if (ret < 0)
-		return ret;
-
-	state->regs[0x07] &= 0xf0;
-	state->regs[0x07] |= (a - 4 * ((a - 12) / 4 + 1) - 5) & 0x0f;
-	ret = reg_write(state, 0x07, state->regs[0x07]);
-	if (ret < 0)
-		return ret;
-
-	/* LPF */
-	val = state->regs[0x08];
-	if (state->cfg.lpf) {
-		/* LPF_CLK, LPF_FC */
-		val &= 0xf0;
-		val |= 0x02;
 	}
-	ret = reg_write(state, 0x08, val);
-	if (ret < 0)
-		return ret;
 
-	/*
-	 * b = (freq / state->cfg.xtal_freq - a) << 20;
-	 * sd = b          (b >= 0)
-	 *      1<<22 + b  (b < 0)
-	 */
-	b = (s32)div64_s64(((s64) freq) << 20, state->cfg.xtal_freq)
-			   - (((s64) a) << 20);
+	*sd = qm1d1c0042_sd_tab[channel][0];
+	N = qm1d1c0042_sd_tab[channel][1];
+	A = qm1d1c0042_sd_tab[channel][2];
 
-	if (b >= 0)
-		sd = b;
-	else
-		sd = (1 << 22) + b;
-
-	state->regs[0x09] &= 0xc0;
-	state->regs[0x09] |= (sd >> 16) & 0x3f;
-	state->regs[0x0a] = (sd >> 8) & 0xff;
-	state->regs[0x0b] = sd & 0xff;
-	ret = reg_write(state, 0x09, state->regs[0x09]);
-	if (ret == 0)
-		ret = reg_write(state, 0x0a, state->regs[0x0a]);
-	if (ret == 0)
-		ret = reg_write(state, 0x0b, state->regs[0x0b]);
-	if (ret != 0)
-		return ret;
-
-	if (!state->cfg.lpf) {
-		/* CSEL_Offset */
-		ret = reg_write(state, 0x13, state->regs[0x13]);
-		if (ret < 0)
-			return ret;
-	}
-
-	/* VCO_TM, LPF_TM */
-	mask = state->cfg.lpf ? 0x3f : 0x7f;
-	val = state->regs[0x0c] & mask;
-	ret = reg_write(state, 0x0c, val);
-	if (ret < 0)
-		return ret;
-	usleep_range(2000, 3000);
-	val = state->regs[0x0c] | ~mask;
-	ret = reg_write(state, 0x0c, val);
-	if (ret < 0)
+	qm->reg[0x06] &= 0x40;
+	qm->reg[0x06] |= N;
+	ret = qm1d1c0042_write(fe, 0x06, qm->reg[0x06]);
+	if (ret)
 		return ret;
 
-	if (state->cfg.lpf)
-		msleep(state->cfg.lpf_wait);
-	else if (state->regs[0x03] & 0x01)
-		msleep(state->cfg.fast_srch_wait);
-	else
-		msleep(state->cfg.normal_srch_wait);
-
-	if (state->cfg.lpf) {
-		/* LPF_FC */
-		ret = reg_write(state, 0x08, 0x09);
-		if (ret < 0)
-			return ret;
-
-		/* CSEL_Offset */
-		ret = reg_write(state, 0x13, state->regs[0x13]);
-		if (ret < 0)
-			return ret;
-	}
-	return 0;
+	qm->reg[0x07] &= 0xf0;
+	qm->reg[0x07] |= A & 0x0f;
+	return qm1d1c0042_write(fe, 0x07, qm->reg[0x07]);
 }
 
-static int qm1d1c0042_sleep(struct dvb_frontend *fe)
+static int qm1d1c0042_local_lpf_tuning(struct qm1d1c0042 *qm, u32 channel)
 {
-	struct qm1d1c0042_state *state;
-	int ret;
-
-	state = fe->tuner_priv;
-	state->regs[0x01] &= (~(1 << 3)) & 0xff; /* BB_Reg_disable */
-	state->regs[0x01] |= 1 << 0;             /* STDBY */
-	state->regs[0x05] |= 1 << 3;             /* pfd_rst STANDBY */
-	ret = reg_write(state, 0x05, state->regs[0x05]);
-	if (ret == 0)
-		ret = reg_write(state, 0x01, state->regs[0x01]);
-	if (ret < 0)
-		dev_warn(&state->i2c->dev, "(%s) failed. [adap%d-fe%d]\n",
-			__func__, fe->dvb->num, fe->id);
-	return ret;
+	struct dvb_frontend *fe = qm->fe;
+	u8 i_data;
+	u32 sd = 0;
+	int err = qm1d1c0042_tuning(qm, &sd, channel);
+
+	if (err)
+		return err;
+	i_data = qm->reg[0x08] & 0xf0;
+	i_data |= 2;
+	err = qm1d1c0042_write(fe, 0x08, i_data);
+	if (err)
+		return err;
+
+	qm->reg[0x09] &= 0xc0;
+	qm->reg[0x09] |= (sd >> 16) & 0x3f;
+	qm->reg[0x0a] = (sd >> 8) & 0xff;
+	qm->reg[0x0b] = (sd >> 0) & 0xff;
+	err =	qm1d1c0042_write(fe, 0x09, qm->reg[0x09])	||
+		qm1d1c0042_write(fe, 0x0a, qm->reg[0x0a])	||
+		qm1d1c0042_write(qm->fe, 0x0b, qm->reg[0x0b]);
+	if (err)
+		return err;
+
+	i_data = qm->reg[0x0c];
+	i_data &= 0x3f;
+	err = qm1d1c0042_write(fe, 0x0c, i_data);
+	if (err)
+		return err;
+	msleep_interruptible(1);
+
+	i_data = qm->reg[0x0c];
+	i_data |= 0xc0;
+	return	qm1d1c0042_write(fe, 0x0c, i_data)	||
+		qm1d1c0042_write(fe, 0x08, 0x09)	||
+		qm1d1c0042_write(fe, 0x13, qm->reg[0x13]);
 }
 
-static int qm1d1c0042_init(struct dvb_frontend *fe)
+int qm1d1c0042_get_locked(struct qm1d1c0042 *qm, bool *locked)
 {
-	struct qm1d1c0042_state *state;
-	u8 val;
-	int i, ret;
-
-	state = fe->tuner_priv;
-	memcpy(state->regs, reg_initval, sizeof(reg_initval));
+	int err = qm1d1c0042_fe_read(qm->fe, 0x0d, &qm->reg[0x0d]);
 
-	reg_write(state, 0x01, 0x0c);
-	reg_write(state, 0x01, 0x0c);
-
-	ret = reg_write(state, 0x01, 0x0c); /* soft reset on */
-	if (ret < 0)
-		goto failed;
-	usleep_range(2000, 3000);
-
-	val = state->regs[0x01] | 0x10;
-	ret = reg_write(state, 0x01, val); /* soft reset off */
-	if (ret < 0)
-		goto failed;
+	if (err)
+		return err;
+	if (qm->reg[0x0d] & 0x40)
+		*locked = true;
+	else
+		*locked = false;
+	return err;
+}
 
-	/* check ID */
-	ret = reg_read(state, 0x00, &val);
-	if (ret < 0 || val != 0x48)
-		goto failed;
-	usleep_range(2000, 3000);
+u32 qm1d1c0042_freq2ch(u32 frequency)
+{
+	u32 freq = frequency / 10,
+	    ch0 = (freq - 104948) / 3836, diff0 = freq - (104948 + 3836 * ch0),
+	    ch1 = (freq - 161300) / 4000, diff1 = freq - (161300 + 4000 * ch1),
+	    ch2 = (freq - 159300) / 4000, diff2 = freq - (159300 + 4000 * ch2),
+	    min = diff0 < diff1 ? diff0 : diff1;
+
+	if (frequency < 1024)
+		return frequency;	/* consider as channel ID if low */
+	if (diff2 < min)
+		return ch2 + 24;
+	if (min == diff1)
+		return ch1 + 12;
+	return ch0;
+}
 
-	state->regs[0x0c] |= 0x40;
-	ret = reg_write(state, 0x0c, state->regs[0x0c]);
-	if (ret < 0)
-		goto failed;
-	msleep(state->cfg.lpf_wait);
-
-	/* set all writable registers */
-	for (i = 1; i <= 0x0c ; i++) {
-		ret = reg_write(state, i, state->regs[i]);
-		if (ret < 0)
-			goto failed;
-	}
-	for (i = 0x11; i < QM1D1C0042_NUM_REGS; i++) {
-		ret = reg_write(state, i, state->regs[i]);
-		if (ret < 0)
-			goto failed;
+int qm1d1c0042_set_freq(struct dvb_frontend *fe, u32 frequency)
+{
+	struct qm1d1c0042 *qm = fe->tuner_priv;
+	u32 channel = qm1d1c0042_freq2ch(frequency);
+	u32 number, freq;
+	bool locked = false;
+	unsigned long timeout;
+	int err = qm1d1c0042_set_agc(fe, QM1D1C0042_AGC_MANUAL);
+
+	if (err)
+		return err;
+	qm1d1c0042_ch2freq(channel, &number, &freq);
+	qm->freq = freq * 10 - 500;
+	dev_dbg(fe->dvb->device, "#%d ch %d freq %d kHz\n", qm->idx, channel, qm->freq);
+
+	err = qm1d1c0042_local_lpf_tuning(qm, channel);
+	if (err)
+		return err;
+
+	timeout = jiffies + msecs_to_jiffies(1000);	/* 1s */
+	while (time_before(jiffies, timeout)) {
+		err = qm1d1c0042_get_locked(qm, &locked);
+		if (err)
+			return err;
+		if (locked)
+			break;
+		msleep_interruptible(1);
 	}
-
-	ret = qm1d1c0042_wakeup(state);
-	if (ret < 0)
-		goto failed;
-
-	ret = qm1d1c0042_set_srch_mode(state, state->cfg.fast_srch);
-	if (ret < 0)
-		goto failed;
-
-	return ret;
-
-failed:
-	dev_warn(&state->i2c->dev, "(%s) failed. [adap%d-fe%d]\n",
-		__func__, fe->dvb->num, fe->id);
-	return ret;
+	dev_dbg(fe->dvb->device, "#%d %s %s\n", qm->idx, __func__, locked ? "LOCKED" : "TIMEOUT");
+	return locked ? qm1d1c0042_set_agc(fe, QM1D1C0042_AGC_AUTO) : -ETIMEDOUT;
 }
 
-/* I2C driver functions */
-
-static const struct dvb_tuner_ops qm1d1c0042_ops = {
+static struct dvb_tuner_ops qm1d1c0042_ops = {
 	.info = {
-		.name = "Sharp QM1D1C0042",
-
-		.frequency_min =  950000,
-		.frequency_max = 2150000,
+		.frequency_min	= 1,		/* freq under 1024 kHz is handled as channel */
+		.frequency_max	= 2150000,	/* kHz */
+		.frequency_step	= 1000,		/* = 1 MHz */
 	},
-
-	.init = qm1d1c0042_init,
+	.set_frequency = qm1d1c0042_set_freq,
 	.sleep = qm1d1c0042_sleep,
-	.set_config = qm1d1c0042_set_config,
-	.set_params = qm1d1c0042_set_params,
+	.init = qm1d1c0042_wakeup,
 };
 
-
-static int qm1d1c0042_probe(struct i2c_client *client,
-			    const struct i2c_device_id *id)
+int qm1d1c0042_remove(struct i2c_client *client)
 {
-	struct qm1d1c0042_state *state;
-	struct qm1d1c0042_config *cfg;
-	struct dvb_frontend *fe;
-
-	state = kzalloc(sizeof(*state), GFP_KERNEL);
-	if (!state)
-		return -ENOMEM;
-	state->i2c = client;
+	struct dvb_frontend *fe = i2c_get_clientdata(client);
 
-	cfg = client->dev.platform_data;
-	fe = cfg->fe;
-	fe->tuner_priv = state;
-	qm1d1c0042_set_config(fe, cfg);
-	memcpy(&fe->ops.tuner_ops, &qm1d1c0042_ops, sizeof(qm1d1c0042_ops));
-
-	i2c_set_clientdata(client, &state->cfg);
-	dev_info(&client->dev, "Sharp QM1D1C0042 attached.\n");
+	dev_dbg(&client->dev, "%s\n", __func__);
+	kfree(fe->tuner_priv);
+	fe->tuner_priv = NULL;
 	return 0;
 }
 
-static int qm1d1c0042_remove(struct i2c_client *client)
+int qm1d1c0042_probe(struct i2c_client *client, const struct i2c_device_id *id)
 {
-	struct qm1d1c0042_state *state;
+	u8 d[] = { 0x10, 0x15, 0x04 };
+	struct dvb_frontend *fe = client->dev.platform_data;
+	struct qm1d1c0042 *qm = kzalloc(sizeof(struct qm1d1c0042), GFP_KERNEL);
 
-	state = cfg_to_state(i2c_get_clientdata(client));
-	state->cfg.fe->tuner_priv = NULL;
-	kfree(state);
-	return 0;
+	if (!qm)
+		return -ENOMEM;
+	fe->tuner_priv = qm;
+	qm->fe = fe;
+	qm->idx = !(client->addr & 1);
+	qm->addr_tuner = client->addr;
+	qm->read = fe->ops.tuner_ops.calc_regs;
+	memcpy(&fe->ops.tuner_ops, &qm1d1c0042_ops, sizeof(struct dvb_tuner_ops));
+	memcpy(qm->reg, qm1d1c0042_reg_rw, sizeof(qm1d1c0042_reg_rw));
+	qm->freq = 0;
+	i2c_set_clientdata(client, fe);
+	return	qm1d1c0042_fe_write_data(fe, 0x1e, d,   1)	||
+		qm1d1c0042_fe_write_data(fe, 0x1c, d+1, 1)	||
+		qm1d1c0042_fe_write_data(fe, 0x1f, d+2, 1);
 }
 
-
-static const struct i2c_device_id qm1d1c0042_id[] = {
-	{"qm1d1c0042", 0},
-	{}
+static struct i2c_device_id qm1d1c0042_id_table[] = {
+	{ QM1D1C0042_DRVNAME, 0 },
+	{ },
 };
-MODULE_DEVICE_TABLE(i2c, qm1d1c0042_id);
+MODULE_DEVICE_TABLE(i2c, qm1d1c0042_id_table);
 
 static struct i2c_driver qm1d1c0042_driver = {
 	.driver = {
-		.name	= "qm1d1c0042",
+		.owner	= THIS_MODULE,
+		.name	= qm1d1c0042_id_table->name,
 	},
 	.probe		= qm1d1c0042_probe,
 	.remove		= qm1d1c0042_remove,
-	.id_table	= qm1d1c0042_id,
+	.id_table	= qm1d1c0042_id_table,
 };
-
 module_i2c_driver(qm1d1c0042_driver);
 
-MODULE_DESCRIPTION("Sharp QM1D1C0042 tuner");
-MODULE_AUTHOR("Akihiro TSUKADA");
+MODULE_AUTHOR("Budi Rachmanto, AreMa Inc. <knightrider(@)are.ma>");
+MODULE_DESCRIPTION("Earthsoft PT3 QM1D1C0042 ISDB-S tuner driver");
 MODULE_LICENSE("GPL");
+
diff --git a/drivers/media/tuners/qm1d1c0042.h b/drivers/media/tuners/qm1d1c0042.h
index 4f5c188..65bca43 100644
--- a/drivers/media/tuners/qm1d1c0042.h
+++ b/drivers/media/tuners/qm1d1c0042.h
@@ -1,12 +1,12 @@
 /*
- * Sharp QM1D1C0042 8PSK tuner driver
+ * Sharp VA4M6JC2103 - Earthsoft PT3 ISDB-S tuner driver QM1D1C0042
  *
- * Copyright (C) 2014 Akihiro Tsukada <tskd08@gmail.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation version 2.
+ * Copyright (C) 2014 Budi Rachmanto, AreMa Inc. <info@are.ma>
  *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
  *
  * This program is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
@@ -14,24 +14,10 @@
  * GNU General Public License for more details.
  */
 
-#ifndef QM1D1C0042_H
-#define QM1D1C0042_H
-
-#include "dvb_frontend.h"
-
+#ifndef __QM1D1C0042_H__
+#define __QM1D1C0042_H__
 
-struct qm1d1c0042_config {
-	struct dvb_frontend *fe;
+#define QM1D1C0042_DRVNAME "qm1d1c0042"
 
-	u32  xtal_freq;    /* [kHz] */ /* currently ignored */
-	bool lpf;          /* enable LPF */
-	bool fast_srch;    /* enable fast search mode, no LPF */
-	u32  lpf_wait;         /* wait in tuning with LPF enabled. [ms] */
-	u32  fast_srch_wait;   /* with fast-search mode, no LPF. [ms] */
-	u32  normal_srch_wait; /* with no LPF/fast-search mode. [ms] */
-};
-/* special values indicating to use the default in qm1d1c0042_config */
-#define QM1D1C0042_CFG_XTAL_DFLT 0
-#define QM1D1C0042_CFG_WAIT_DFLT 0
+#endif
 
-#endif /* QM1D1C0042_H */
-- 
1.8.4.5

