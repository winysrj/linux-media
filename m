Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f172.google.com ([209.85.192.172]:41477 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850AbaIJLwI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Sep 2014 07:52:08 -0400
Received: by mail-pd0-f172.google.com with SMTP id v10so12131488pde.31
        for <linux-media@vger.kernel.org>; Wed, 10 Sep 2014 04:52:07 -0700 (PDT)
From: "=?UTF-8?q?=D0=91=D1=83=D0=B4=D0=B8=20=D0=A0=D0=BE=D0=BC=D0=B0=D0=BD=D1=82=D0=BE=2C=20AreMa=20Inc?="
	<info@are.ma>
To: linux-media@vger.kernel.org
Cc: Bud <knightrider@are.ma>, crope@iki.fi, m.chehab@samsung.com,
	hdegoede@redhat.com, laurent.pinchart@ideasonboard.com,
	mkrufky@linuxtv.org, sylvester.nawrocki@gmail.com,
	g.liakhovetski@gmx.de, peter.senna@gmail.com
Subject: [PATCH] Earthsoft PT3 ISDB-S/T driver (demodulator: tc90522)
Date: Wed, 10 Sep 2014 20:52:01 +0900
Message-Id: <1410349921-31739-1-git-send-email-knightrider@are.ma>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Bud <knightrider@are.ma>


DVB driver for Earthsoft PT3 (PCIE ISDB-S/T receiver)
-----------------------------------------------------

Status: stable

Features:
- tuning enhancements, from  PT1 DVB
1. in addition to the real frequency:
	ISDB-S : freq. channel ID
	ISDB-T : freq# (I/O# +128), ch#, ch# +64 for CATV
2. in addition to TSID:
	ISDB-S : slot#
- allocated devices
	ISDB-S : /dev/dvb/adapter0, /dev/dvb/adapter1
	ISDB-T : /dev/dvb/adapter2, /dev/dvb/adapter3

Main components:
1. Sharp	VA4M6JC2103	: contains 2 ISDB-S + 2 ISDB-T tuners
	ISDB-S : Sharp QM1D1C0042 RF-IC
	ISDB-T : MaxLinear CMOS Hybrid TV MxL301RF
2. Toshiba	TC90522XBG	: quad demodulator (2ch OFDM + 2ch 8PSK)
3. Altera	EP4CGX15BF14C8N	: customized FPGA PCI bridge

Full package:
- URL:	https://github.com/knight-rider/ptx/tree/master/pt3_dvb
- buildable as standalone, DKMS or tree embedded module
- installation:
	$ chmod +x dkms.install dkms.uninstall
	$ ./dkms.install

Changes since last release:
- cleanups (removed unused/useless features, simple is the best)
- removed .ops.write hacks

Signed-off-by: Буди Романто, AreMa Inc <knightrider@are.ma>
---
 drivers/media/dvb-frontends/Kconfig   |  18 +-
 drivers/media/dvb-frontends/Makefile  |   3 +-
 drivers/media/dvb-frontends/tc90522.c | 525 ++++++++++++++++++++++++++++++++++
 drivers/media/dvb-frontends/tc90522.h |  33 +++

diff --git a/drivers/media/dvb-frontends/Kconfig b/drivers/media/dvb-frontends/Kconfig
index 704403f..292694e 100644
--- a/drivers/media/dvb-frontends/Kconfig
+++ b/drivers/media/dvb-frontends/Kconfig
@@ -621,7 +621,7 @@ config DVB_S5H1411
 	  An ATSC 8VSB and QAM64/256 tuner module. Say Y when you want
 	  to support this frontend.
 
-comment "ISDB-T (terrestrial) frontends"
+comment "ISDB-S (satellite) & ISDB-T (terrestrial) frontends"
 	depends on DVB_CORE
 
 config DVB_S921
@@ -648,6 +648,15 @@ config DVB_MB86A20S
 	  A driver for Fujitsu mb86a20s ISDB-T/ISDB-Tsb demodulator.
 	  Say Y when you want to support this frontend.
 
+config DVB_TC90522
+	tristate "Toshiba TC90522XBG OFDM(ISDB-T)/8PSK(ISDB-S)"
+	depends on DVB_CORE && I2C
+	default m if !MEDIA_SUBDRV_AUTOSELECT
+	help
+	  Toshiba TC90522XBG OFDM(ISDB-T)/8PSK(ISDB-S) demodulator
+	  frontend for Earthsoft PT3 PCIE cards.
+	  Say Y when you want to support this frontend.
+
 comment "Digital terrestrial only tuners/PLL"
 	depends on DVB_CORE
 
@@ -725,13 +734,6 @@ config DVB_A8293
 	depends on DVB_CORE && I2C
 	default m if !MEDIA_SUBDRV_AUTOSELECT
 
-config DVB_SP2
-	tristate "CIMaX SP2"
-	depends on DVB_CORE && I2C
-	default m if !MEDIA_SUBDRV_AUTOSELECT
-	help
-	  CIMaX SP2/SP2HF Common Interface module.
-
 config DVB_LGS8GL5
 	tristate "Silicon Legend LGS-8GL5 demodulator (OFDM)"
 	depends on DVB_CORE && I2C
diff --git a/drivers/media/dvb-frontends/Makefile b/drivers/media/dvb-frontends/Makefile
index 1e19a74..8f9a229 100644
--- a/drivers/media/dvb-frontends/Makefile
+++ b/drivers/media/dvb-frontends/Makefile
@@ -107,7 +107,6 @@ obj-$(CONFIG_DVB_DRXK) += drxk.o
 obj-$(CONFIG_DVB_TDA18271C2DD) += tda18271c2dd.o
 obj-$(CONFIG_DVB_SI2165) += si2165.o
 obj-$(CONFIG_DVB_A8293) += a8293.o
-obj-$(CONFIG_DVB_SP2) += sp2.o
 obj-$(CONFIG_DVB_TDA10071) += tda10071.o
 obj-$(CONFIG_DVB_RTL2830) += rtl2830.o
 obj-$(CONFIG_DVB_RTL2832) += rtl2832.o
@@ -115,3 +114,5 @@ obj-$(CONFIG_DVB_RTL2832_SDR) += rtl2832_sdr.o
 obj-$(CONFIG_DVB_M88RS2000) += m88rs2000.o
 obj-$(CONFIG_DVB_AF9033) += af9033.o
 obj-$(CONFIG_DVB_AS102_FE) += as102_fe.o
+obj-$(CONFIG_DVB_TC90522) += tc90522.o
+
diff --git a/drivers/media/dvb-frontends/tc90522.c b/drivers/media/dvb-frontends/tc90522.c
new file mode 100644
index 0000000..26e2efe
--- /dev/null
+++ b/drivers/media/dvb-frontends/tc90522.c
@@ -0,0 +1,525 @@
+/*
+ * Toshiba TC90522XBG 2ch OFDM(ISDB-T) + 2ch 8PSK(ISDB-S) demodulator frontend for Earthsoft PT3
+ *
+ * Copyright (C) 2014 Budi Rachmanto, AreMa Inc. <info@are.ma>
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
+#include "dvb_math.h"
+#include "tc90522.h"
+
+MODULE_AUTHOR("Budi Rachmanto, AreMa Inc. <knightrider(@)are.ma>");
+MODULE_DESCRIPTION("Toshiba TC90522 OFDM(ISDB-T)/8PSK(ISDB-S) demodulator [Earthsoft PT3]");
+MODULE_LICENSE("GPL");
+
+#define TC90522_PASSTHROUGH 0xfe
+
+enum tc90522_state {
+	TC90522_IDLE,
+	TC90522_SET_FREQUENCY,
+	TC90522_SET_MODULATION,
+	TC90522_TRACK,
+	TC90522_ABORT,
+};
+
+struct tc90522 {
+	struct dvb_frontend fe;
+	struct i2c_adapter *i2c;
+	fe_delivery_system_t type;
+	u8 idx, addr_demod;
+	s32 offset;
+	enum tc90522_state state;
+};
+
+int tc90522_write(struct dvb_frontend *fe, const u8 *data, int len)
+{
+	struct tc90522 *demod = fe->demodulator_priv;
+	struct i2c_msg msg[] = {
+		{ .addr = demod->addr_demod, .flags = 0, .buf = (u8 *)data, .len = len, },
+	};
+
+	if (!data || !len)
+		return -EINVAL;
+	return i2c_transfer(demod->i2c, msg, 1) == 1 ? 0 : -EREMOTEIO;
+}
+
+int tc90522_write_data(struct dvb_frontend *fe, u8 addr_data, u8 *data, u8 len)
+{
+	u8 buf[len + 1];
+
+	buf[0] = addr_data;
+	memcpy(buf + 1, data, len);
+	return tc90522_write(fe, buf, len + 1);
+}
+
+int tc90522_read(struct tc90522 *demod, u8 addr, u8 *buf, u8 len)
+{
+	struct i2c_msg msg[] = {
+		{ .addr = demod->addr_demod, .flags = 0,	.buf = buf, .len = 1,	},
+		{ .addr = demod->addr_demod, .flags = I2C_M_RD,	.buf = buf, .len = len,	},
+	};
+	if (!buf || !len)
+		return -EINVAL;
+	buf[0] = addr;
+	return i2c_transfer(demod->i2c, msg, 2) == 2 ? 0 : -EREMOTEIO;
+}
+
+u64 tc90522_n2int(const u8 *data, u8 n)		/* convert n_bytes data from stream (network byte order) to integer */
+{						/* can't use <arpa/inet.h>'s ntoh*() as sometimes n = 3,5,...       */
+	u32 i, val = 0;
+
+	for (i = 0; i < n; i++) {
+		val <<= 8;
+		val |= data[i];
+	}
+	return val;
+}
+
+int tc90522_read_id_s(struct tc90522 *demod, u16 *id)
+{
+	u8 buf[2];
+	int err = tc90522_read(demod, 0xe6, buf, 2);
+
+	if (!err)
+		*id = tc90522_n2int(buf, 2);
+	return err;
+}
+
+struct tmcc_s {			/* Transmission and Multiplexing Configuration Control */
+	u32 mode[4];
+	u32 slot[4];
+	u32 id[8];
+};
+
+int tc90522_read_tmcc_s(struct tc90522 *demod, struct tmcc_s *tmcc)
+{
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
+	}
+	for (i = 0; i < 8; i++)
+		tmcc->id[i] = tc90522_n2int(data + 0xce + i * 2 - BASE, 2);
+	return 0;
+}
+
+enum tc90522_pwr {
+	TC90522_PWR_OFF		= 0x00,
+	TC90522_PWR_AMP_ON	= 0x04,
+	TC90522_PWR_TUNER_ON	= 0x40,
+};
+
+int tc90522_set_powers(struct tc90522 *demod, enum tc90522_pwr pwr)
+{
+	u8 data = pwr | 0b10011001;
+
+	dev_dbg(&demod->i2c->dev, "%s #%d %s tuner %s amp %s\n", demod->i2c->name, demod->idx, __func__, pwr & TC90522_PWR_TUNER_ON ?
+		"ON" : "OFF", pwr & TC90522_PWR_AMP_ON ? "ON" : "OFF");
+	return tc90522_write_data(&demod->fe, 0x1e, &data, 1);
+}
+
+/* dvb_frontend_ops */
+int tc90522_get_frontend_algo(struct dvb_frontend *fe)
+{
+	return DVBFE_ALGO_HW;
+}
+
+int tc90522_sleep(struct dvb_frontend *fe)
+{
+	struct tc90522 *demod = fe->demodulator_priv;
+
+	dev_dbg(&demod->i2c->dev, "%s #%d %s %s\n", demod->i2c->name, demod->idx, __func__, demod->type == SYS_ISDBS ? "S" : "T");
+	return fe->ops.tuner_ops.sleep(fe);
+}
+
+int tc90522_wakeup(struct dvb_frontend *fe)
+{
+	struct tc90522 *demod = fe->demodulator_priv;
+
+	dev_dbg(&demod->i2c->dev, "%s #%d %s %s\n", demod->i2c->name, demod->idx, __func__, demod->type == SYS_ISDBS ? "S" : "T");
+	demod->state = TC90522_IDLE;
+	return fe->ops.tuner_ops.init(fe);
+}
+
+void tc90522_release(struct dvb_frontend *fe)
+{
+	struct tc90522 *demod = fe->demodulator_priv;
+
+	dev_dbg(&demod->i2c->dev, "%s #%d %s\n", demod->i2c->name, demod->idx, __func__);
+	tc90522_set_powers(demod, TC90522_PWR_OFF);
+	tc90522_sleep(fe);
+	fe->ops.tuner_ops.release(fe);
+	kfree(demod);
+}
+
+s64 tc90522_get_cn_raw(struct tc90522 *demod)
+{
+	u8 buf[3], buflen = demod->type == SYS_ISDBS ? 2 : 3, addr = demod->type == SYS_ISDBS ? 0xbc : 0x8b;
+	int err = tc90522_read(demod, addr, buf, buflen);
+
+	return err < 0 ? err : tc90522_n2int(buf, buflen);
+}
+
+s64 tc90522_get_cn_s(s64 raw)	/* @ .0001 dB */
+{
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
+
+s64 tc90522_get_cn_t(s64 raw)	/* @ .0001 dB */
+{
+	s64 x, y;
+
+	if (!raw)
+		return 0;
+	x = (1130911733ll - 10ll * intlog10(raw)) >> 2;
+	y = (6ll * x / 25ll) - (16ll << 22);
+	y = ((x * y) >> 22) + (398ll << 22);
+	y = ((x * y) >> 22) + (5491ll << 22);
+	y = ((x * y) >> 22) + (30965ll << 22);
+	return y >> 22;
+}
+
+int tc90522_read_snr(struct dvb_frontend *fe, u16 *cn)	/* raw C/N, digitally modulated S/N ratio */
+{
+	struct tc90522 *demod = fe->demodulator_priv;
+	s64 err = tc90522_get_cn_raw(demod);
+	*cn = err < 0 ? 0 : err;
+	dev_dbg(&demod->i2c->dev, "%s v3 CN %d (%lld dB)\n", demod->i2c->name, (int)*cn,
+		demod->type == SYS_ISDBS ? (int64_t)tc90522_get_cn_s(*cn) : (int64_t)tc90522_get_cn_t(*cn));
+	return err < 0 ? err : 0;
+}
+
+int tc90522_read_status(struct dvb_frontend *fe, fe_status_t *status)
+{
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
+	}
+
+	c->cnr.len = 1;
+	c->cnr.stat[0].svalue = demod->type == SYS_ISDBS ? tc90522_get_cn_s(raw) : tc90522_get_cn_t(raw);
+	c->cnr.stat[0].scale = FE_SCALE_DECIBEL;
+	dev_dbg(&demod->i2c->dev, "%s v5 CN %lld (%lld dB)\n", demod->i2c->name, raw, c->cnr.stat[0].svalue);
+	return err < 0 ? err : 0;
+}
+
+/**** ISDB-S ****/
+int tc90522_tune_s(struct dvb_frontend *fe, bool re_tune, unsigned int mode_flags, unsigned int *delay, fe_status_t *status)
+{
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
+
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
+
+	case TC90522_SET_MODULATION:
+		for (i = 0; i < 1000; i++) {
+			err = tc90522_read_tmcc_s(demod, &tmcc);
+			if (!err)
+				break;
+			msleep_interruptible(1);
+		}
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
+
+	case TC90522_TRACK:
+		*delay = msecs_to_jiffies(2000);
+		*status = FE_HAS_SIGNAL | FE_HAS_CARRIER | FE_HAS_LOCK;
+		return 0;
+
+	case TC90522_ABORT:
+		*delay = msecs_to_jiffies(2000);
+		*status = FE_HAS_SIGNAL;
+		return 0;
+	}
+	return -ERANGE;
+}
+
+int tc90522_read_tuner_s(struct dvb_frontend *fe, u8 *addr, int len)
+{
+	struct tc90522 *demod = fe->demodulator_priv;
+	u8 buf[] = { TC90522_PASSTHROUGH, addr[0] << 1, addr[1], TC90522_PASSTHROUGH, (addr[0] << 1) | 1, 0 };
+	struct i2c_msg msg[] = {
+		{ .addr = demod->addr_demod, .flags = 0,	.buf = buf,	.len = 3, },
+		{ .addr = demod->addr_demod, .flags = 0,	.buf = buf + 3,	.len = 2, },
+		{ .addr = demod->addr_demod, .flags = I2C_M_RD,	.buf = buf + 5,	.len = 1, },
+	};
+
+	if (!addr || (len != 2))
+		return -EINVAL;
+	return i2c_transfer(demod->i2c, msg, 3) == 3 ? buf[5] : -EREMOTEIO;
+}
+
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
+
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
+		}
+		if (retryov)
+			break;
+		msleep_interruptible(1);
+	}
+	return b ? 0 : -EBADMSG;
+}
+
+int tc90522_tune_t(struct dvb_frontend *fe, bool re_tune, unsigned int mode_flags, unsigned int *delay, fe_status_t *status)
+{
+	struct tc90522 *demod = fe->demodulator_priv;
+	int err, i;
+
+	if (re_tune)
+		demod->state = TC90522_SET_FREQUENCY;
+
+	switch (demod->state) {
+	case TC90522_IDLE:
+		*delay = msecs_to_jiffies(2000);
+		*status = 0;
+		return 0;
+
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
+
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
+
+	case TC90522_TRACK:
+		*delay = msecs_to_jiffies(2000);
+		*status = FE_HAS_SIGNAL | FE_HAS_CARRIER | FE_HAS_LOCK;
+		return 0;
+
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
+
+static struct dvb_frontend_ops tc90522_ops_t = {
+	.delsys = { SYS_ISDBT },
+	.info = {
+		.name = "TC90522 ISDB-T",
+		.caps = FE_CAN_INVERSION_AUTO | FE_CAN_FEC_AUTO | FE_CAN_QAM_AUTO |
+			FE_CAN_TRANSMISSION_MODE_AUTO | FE_CAN_GUARD_INTERVAL_AUTO | FE_CAN_HIERARCHY_AUTO,
+	},
+	.init = tc90522_wakeup,
+	.sleep = tc90522_sleep,
+	.release = tc90522_release,
+	.write = tc90522_write,
+	.get_frontend_algo = tc90522_get_frontend_algo,
+	.read_snr = tc90522_read_snr,
+	.read_status = tc90522_read_status,
+	.tune = tc90522_tune_t,
+	.tuner_ops.calc_regs = tc90522_read_tuner_t,
+};
+
+/**** Common ****/
+struct dvb_frontend *tc90522_attach(struct i2c_adapter *i2c, fe_delivery_system_t type, u8 addr_demod, bool pwr_on)
+{
+	struct dvb_frontend *fe;
+	struct tc90522 *demod = kzalloc(sizeof(struct tc90522), GFP_KERNEL);
+
+	if (!demod)
+		return NULL;
+	demod->addr_demod = addr_demod;
+	demod->idx	= (!(addr_demod & 1) << 1) + ((addr_demod & 2) >> 1);
+	demod->i2c	= i2c;
+	demod->type	= type;
+	fe		= &demod->fe;
+	memcpy(&fe->ops, (demod->type == SYS_ISDBS) ? &tc90522_ops_s : &tc90522_ops_t, sizeof(struct dvb_frontend_ops));
+	fe->demodulator_priv = demod;
+
+	if (pwr_on && (tc90522_set_powers(demod, TC90522_PWR_TUNER_ON)	||
+			i2c_transfer(demod->i2c, NULL, 0)		||
+			tc90522_set_powers(demod, TC90522_PWR_TUNER_ON | TC90522_PWR_AMP_ON))) {
+		tc90522_release(fe);
+		return NULL;
+	}
+	return fe;
+}
+EXPORT_SYMBOL(tc90522_attach);
+
diff --git a/drivers/media/dvb-frontends/tc90522.h b/drivers/media/dvb-frontends/tc90522.h
new file mode 100644
index 0000000..ab4911b
--- /dev/null
+++ b/drivers/media/dvb-frontends/tc90522.h
@@ -0,0 +1,33 @@
+/*
+ * Earthsoft PT3 demodulator frontend Toshiba TC90522XBG OFDM(ISDB-T)/8PSK(ISDB-S)
+ *
+ * Copyright (C) 2014 Budi Rachmanto, AreMa Inc. <info@are.ma>
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
+#ifndef	__TC90522_H__
+#define	__TC90522_H__
+
+#include "dvb_frontend.h"
+
+#if IS_ENABLED(CONFIG_DVB_TC90522)
+extern struct dvb_frontend *tc90522_attach(struct i2c_adapter *i2c, fe_delivery_system_t type, u8 addr_demod, bool pwr);
+#else
+static inline struct dvb_frontend *tc90522_attach(struct i2c_adapter *i2c, fe_delivery_system_t type, u8 addr_demod, bool pwr)
+{
+	dev_warn(&i2c->dev, "%s: driver disabled by Kconfig\n", __func__);
+	return NULL;
+}
+#endif
+
+#endif

