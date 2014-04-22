Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:53371 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932873AbaDVR0q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Apr 2014 13:26:46 -0400
Received: by mail-pa0-f50.google.com with SMTP id rd3so616525pab.37
        for <linux-media@vger.kernel.org>; Tue, 22 Apr 2014 10:26:46 -0700 (PDT)
From: "=?UTF-8?q?=D0=91=D1=83=D0=B4=D0=B8=20=D0=A0=D0=BE=D0=BC=D0=B0=D0=BD=D1=82=D0=BE=2C=20AreMa=20Inc?="
	<info@are.ma>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?=D0=91=D1=83=D0=B4=D0=B8=20=D0=A0=D0=BE=D0=BC=D0=B0=D0=BD?=
	 =?UTF-8?q?=D1=82=D0=BE=2C=20AreMa=20Inc?= <knightrider@are.ma>,
	crope@iki.fi, m.chehab@samsung.com, hdegoede@redhat.com,
	hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	mkrufky@linuxtv.org, sylvester.nawrocki@gmail.com,
	g.liakhovetski@gmx.de, peter.senna@gmail.com
Subject: [PATCH] Full DVB driver package for Earthsoft PT3 (ISDB-S/T) cards
Date: Wed, 23 Apr 2014 02:26:24 +0900
Message-Id: <1398187584-26666-1-git-send-email-knightrider@are.ma>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Буди Роман то, AreMa Inc <knightrider@are.ma>

DVB driver for Earthsoft PT3 (ISDB-S/T) receiver PCI Express cards.
It behaves similarly as PT1 DVB, plus some tuning enhancements:
1. in addition to the real frequency:
	ISDB-S : freq. channel ID
	ISDB-T : freq# (I/O# +128), ch#, ch# +64 for CATV
2. in addition to TSID:
	ISDB-S : slot#

Feature changes:
- dropped DKMS & standalone compile
- dropped verbosity (debug levels), use single level -DDEBUG instead
- moved demodulator FE to drivers/media/dvb-frontends
- moved tuners to drivers/media/tuners
- translated to standard (?) I2C protocol
- dropped unused features
- added DVBv5 CNR support

The full package (buildable as standalone, DKMS or tree embedded module) is available at
https://github.com/knight-rider/ptx/tree/master/pt3_dvb

Signed-off-by: Буди Романто, AreMa Inc <knightrider@are.ma>
---
 drivers/media/dvb-frontends/Kconfig   |  11 +-
 drivers/media/dvb-frontends/Makefile  |   1 +
 drivers/media/dvb-frontends/tc90522.c | 539 ++++++++++++++++++++++++++++++++++
 drivers/media/dvb-frontends/tc90522.h |  36 +++
 drivers/media/pci/Kconfig             |   2 +-
 drivers/media/pci/Makefile            |   1 +
 drivers/media/pci/pt3/Kconfig         |  11 +
 drivers/media/pci/pt3/Makefile        |   6 +
 drivers/media/pci/pt3/pt3_common.h    |  86 ++++++
 drivers/media/pci/pt3/pt3_dma.c       | 333 +++++++++++++++++++++
 drivers/media/pci/pt3/pt3_dma.h       |  50 ++++
 drivers/media/pci/pt3/pt3_i2c.c       | 189 ++++++++++++
 drivers/media/pci/pt3/pt3_i2c.h       |  25 ++
 drivers/media/pci/pt3/pt3_pci.c       | 397 +++++++++++++++++++++++++
 drivers/media/tuners/Kconfig          |  15 +
 drivers/media/tuners/Makefile         |   2 +
 drivers/media/tuners/mxl301rf.c       | 390 ++++++++++++++++++++++++
 drivers/media/tuners/mxl301rf.h       |  36 +++
 drivers/media/tuners/qm1d1c0042.c     | 382 ++++++++++++++++++++++++
 drivers/media/tuners/qm1d1c0042.h     |  36 +++
 20 files changed, 2546 insertions(+), 2 deletions(-)
 create mode 100644 drivers/media/dvb-frontends/tc90522.c
 create mode 100644 drivers/media/dvb-frontends/tc90522.h
 create mode 100644 drivers/media/pci/pt3/Kconfig
 create mode 100644 drivers/media/pci/pt3/Makefile
 create mode 100644 drivers/media/pci/pt3/pt3_common.h
 create mode 100644 drivers/media/pci/pt3/pt3_dma.c
 create mode 100644 drivers/media/pci/pt3/pt3_dma.h
 create mode 100644 drivers/media/pci/pt3/pt3_i2c.c
 create mode 100644 drivers/media/pci/pt3/pt3_i2c.h
 create mode 100644 drivers/media/pci/pt3/pt3_pci.c
 create mode 100644 drivers/media/tuners/mxl301rf.c
 create mode 100644 drivers/media/tuners/mxl301rf.h
 create mode 100644 drivers/media/tuners/qm1d1c0042.c
 create mode 100644 drivers/media/tuners/qm1d1c0042.h

diff --git a/drivers/media/dvb-frontends/Kconfig b/drivers/media/dvb-frontends/Kconfig
index 025fc54..0047b3f 100644
--- a/drivers/media/dvb-frontends/Kconfig
+++ b/drivers/media/dvb-frontends/Kconfig
@@ -591,7 +591,7 @@ config DVB_S5H1411
 	  An ATSC 8VSB and QAM64/256 tuner module. Say Y when you want
 	  to support this frontend.
 
-comment "ISDB-T (terrestrial) frontends"
+comment "ISDB-S (satellite) & ISDB-T (terrestrial) frontends"
 	depends on DVB_CORE
 
 config DVB_S921
@@ -618,6 +618,15 @@ config DVB_MB86A20S
 	  A driver for Fujitsu mb86a20s ISDB-T/ISDB-Tsb demodulator.
 	  Say Y when you want to support this frontend.
 
+config DVB_TC90522
+	tristate "Toshiba TC90522XBG OFDM(ISDB-T)/8PSK(ISDB-S)"
+	depends on DVB_CORE && I2C
+	default m if !MEDIA_SUBDRV_AUTOSELECT
+	help
+	  Toshiba TC90522XBG OFDM(ISDB-T)/8PSK(ISDB-S) DVB demodulator
+	  frontend for Earthsoft PT3 PCIE cards.
+	  Say Y when you want to support this frontend.
+
 comment "Digital terrestrial only tuners/PLL"
 	depends on DVB_CORE
 
diff --git a/drivers/media/dvb-frontends/Makefile b/drivers/media/dvb-frontends/Makefile
index 282aba2..a80d212 100644
--- a/drivers/media/dvb-frontends/Makefile
+++ b/drivers/media/dvb-frontends/Makefile
@@ -105,4 +105,5 @@ obj-$(CONFIG_DVB_RTL2830) += rtl2830.o
 obj-$(CONFIG_DVB_RTL2832) += rtl2832.o
 obj-$(CONFIG_DVB_M88RS2000) += m88rs2000.o
 obj-$(CONFIG_DVB_AF9033) += af9033.o
+obj-$(CONFIG_DVB_TC90522) += tc90522.o
 
diff --git a/drivers/media/dvb-frontends/tc90522.c b/drivers/media/dvb-frontends/tc90522.c
new file mode 100644
index 0000000..a767600
--- /dev/null
+++ b/drivers/media/dvb-frontends/tc90522.c
@@ -0,0 +1,539 @@
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
+#include "dvb_math.h"
+#include "tc90522.h"
+
+MODULE_AUTHOR("Budi Rachmanto, AreMa Inc. <knightrider(@)are.ma>");
+MODULE_DESCRIPTION("Earthsoft PT3 Toshiba TC90522 OFDM(ISDB-T)/8PSK(ISDB-S) demodulator");
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
+	struct i2c_msg msg[3];
+	u8 buf[6];
+
+	if (data) {
+		msg[0].addr = demod->addr_demod;
+		msg[0].buf = (u8 *)data;
+		msg[0].flags = 0;			/* write */
+		msg[0].len = len;
+
+		return i2c_transfer(demod->i2c, msg, 1) == 1 ? 0 : -EREMOTEIO;
+	} else {
+		u8 addr_tuner = (len >> 8) & 0xff,
+		   addr_data = len & 0xff;
+		if (len >> 16) {			/* read tuner without address */
+			buf[0] = TC90522_PASSTHROUGH;
+			buf[1] = (addr_tuner << 1) | 1;
+			msg[0].buf = buf;
+			msg[0].len = 2;
+			msg[0].addr = demod->addr_demod;
+			msg[0].flags = 0;		/* write */
+
+			msg[1].buf = buf + 2;
+			msg[1].len = 1;
+			msg[1].addr = demod->addr_demod;
+			msg[1].flags = I2C_M_RD;	/* read */
+
+			return i2c_transfer(demod->i2c, msg, 2) == 2 ? buf[2] : -EREMOTEIO;
+		} else {				/* read tuner */
+			buf[0] = TC90522_PASSTHROUGH;
+			buf[1] = addr_tuner << 1;
+			buf[2] = addr_data;
+			msg[0].buf = buf;
+			msg[0].len = 3;
+			msg[0].addr = demod->addr_demod;
+			msg[0].flags = 0;		/* write */
+
+			buf[3] = TC90522_PASSTHROUGH;
+			buf[4] = (addr_tuner << 1) | 1;
+			msg[1].buf = buf + 3;
+			msg[1].len = 2;
+			msg[1].addr = demod->addr_demod;
+			msg[1].flags = 0;		/* write */
+
+			msg[2].buf = buf + 5;
+			msg[2].len = 1;
+			msg[2].addr = demod->addr_demod;
+			msg[2].flags = I2C_M_RD;	/* read */
+
+			return i2c_transfer(demod->i2c, msg, 3) == 3 ? buf[5] : -EREMOTEIO;
+		}
+	}
+}
+
+int tc90522_write_data(struct dvb_frontend *fe, u8 addr_data, u8 *data, u8 len)
+{
+	u8 buf[len + 1];
+	buf[0] = addr_data;
+	memcpy(buf + 1, data, len);
+	return tc90522_write(fe, buf, len + 1);
+}
+
+int tc90522_read(struct tc90522 *demod, u8 addr, u8 *buf, u8 buflen)
+{
+	struct i2c_msg msg[2];
+	if (!buf || !buflen)
+		return -EINVAL;
+
+	buf[0] = addr;
+	msg[0].addr = demod->addr_demod;
+	msg[0].flags = 0;			/* write */
+	msg[0].buf = buf;
+	msg[0].len = 1;
+
+	msg[1].addr = demod->addr_demod;
+	msg[1].flags = I2C_M_RD;		/* read */
+	msg[1].buf = buf;
+	msg[1].len = buflen;
+
+	return i2c_transfer(demod->i2c, msg, 2) == 2 ? 0 : -EREMOTEIO;
+}
+
+u32 tc90522_byten(const u8 *data, u32 n)
+{
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
+	int ret = tc90522_read(demod, 0xe6, buf, 2);
+	if (!ret)
+		*id = tc90522_byten(buf, 2);
+	return ret;
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
+		(tc90522_byten(data, 2) == 0)		||
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
+		tmcc->id[i] = tc90522_byten(data + 0xce + i * 2 - BASE, 2);
+	return 0;
+}
+
+enum tc90522_pwr {
+	TC90522_PWR_OFF		= 0x00,
+	TC90522_PWR_AMP_ON	= 0x04,
+	TC90522_PWR_TUNER_ON	= 0x40,
+};
+
+static enum tc90522_pwr tc90522_pwr = TC90522_PWR_OFF;
+
+int tc90522_set_powers(struct tc90522 *demod, enum tc90522_pwr pwr)
+{
+	u8 data = pwr | 0b10011001;
+	pr_debug("#%d tuner %s amp %s\n", demod->idx, pwr & TC90522_PWR_TUNER_ON ? "ON" : "OFF", pwr & TC90522_PWR_AMP_ON ? "ON" : "OFF");
+	tc90522_pwr = pwr;
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
+	pr_debug("#%d %s %s\n", demod->idx, __func__, demod->type == SYS_ISDBS ? "S" : "T");
+	return fe->ops.tuner_ops.sleep(fe);
+}
+
+int tc90522_wakeup(struct dvb_frontend *fe)
+{
+	struct tc90522 *demod = fe->demodulator_priv;
+	pr_debug("#%d %s %s 0x%x\n", demod->idx, __func__, demod->type == SYS_ISDBS ? "S" : "T", tc90522_pwr);
+
+	if (!tc90522_pwr)
+		return	tc90522_set_powers(demod, TC90522_PWR_TUNER_ON)	||
+			i2c_transfer(demod->i2c, NULL, 0)		||
+			tc90522_set_powers(demod, TC90522_PWR_TUNER_ON | TC90522_PWR_AMP_ON);
+	demod->state = TC90522_IDLE;
+	return fe->ops.tuner_ops.init(fe);
+}
+
+void tc90522_release(struct dvb_frontend *fe)
+{
+	struct tc90522 *demod = fe->demodulator_priv;
+	pr_debug("#%d %s\n", demod->idx, __func__);
+
+	if (tc90522_pwr)
+		tc90522_set_powers(demod, TC90522_PWR_OFF);
+	tc90522_sleep(fe);
+	fe->ops.tuner_ops.release(fe);
+	kfree(demod);
+}
+
+s64 tc90522_get_cn_raw(struct tc90522 *demod)
+{
+	u8 buf[3], buflen = demod->type == SYS_ISDBS ? 2 : 3, addr = demod->type == SYS_ISDBS ? 0xbc : 0x8b;
+	int err = tc90522_read(demod, addr, buf, buflen);
+	return err < 0 ? err : tc90522_byten(buf, buflen);
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
+int tc90522_read_signal_strength(struct dvb_frontend *fe, u16 *cn)	/* raw C/N */
+{
+	struct tc90522 *demod = fe->demodulator_priv;
+	s64 ret = tc90522_get_cn_raw(demod);
+	*cn = ret < 0 ? 0 : ret;
+	pr_debug("v3 CN %d (%lld dB)\n", (int)*cn, demod->type == SYS_ISDBS ? (long long int)tc90522_get_cn_s(*cn) : (long long int)tc90522_get_cn_t(*cn));
+	return ret < 0 ? ret : 0;
+}
+
+int tc90522_read_status(struct dvb_frontend *fe, fe_status_t *status)
+{
+	struct tc90522 *demod = fe->demodulator_priv;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+	s64 ret = tc90522_get_cn_raw(demod),
+	    raw = ret < 0 ? 0 : ret;
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
+	pr_debug("v5 CN %lld (%lld dB)\n", raw, c->cnr.stat[0].svalue);
+	return ret < 0 ? ret : 0;
+}
+
+/**** ISDB-S ****/
+int tc90522_write_id_s(struct dvb_frontend *fe, u16 id)
+{
+	u8 data[2] = { id >> 8, (u8)id };
+	return tc90522_write_data(fe, 0x8f, data, sizeof(data));
+}
+
+int tc90522_tune_s(struct dvb_frontend *fe, bool re_tune, unsigned int mode_flags, unsigned int *delay, fe_status_t *status)
+{
+	struct tc90522 *demod = fe->demodulator_priv;
+	struct tmcc_s tmcc;
+	int i, ret,
+	    freq = fe->dtv_property_cache.frequency,
+	    tsid = fe->dtv_property_cache.stream_id;
+
+	if (re_tune)
+		demod->state = TC90522_SET_FREQUENCY;
+
+	switch (demod->state) {
+	case TC90522_IDLE:
+		*delay = msecs_to_jiffies(3000);
+		*status = 0;
+		return 0;
+
+	case TC90522_SET_FREQUENCY:
+		pr_debug("#%d tsid 0x%x freq %d\n", demod->idx, tsid, freq);
+		ret = fe->ops.tuner_ops.set_frequency(fe, freq);
+		if (ret)
+			return ret;
+		demod->offset = 0;
+		demod->state = TC90522_SET_MODULATION;
+		*delay = 0;
+		*status = FE_HAS_SIGNAL;
+		return 0;
+
+	case TC90522_SET_MODULATION:
+		for (i = 0; i < 1000; i++) {
+			ret = tc90522_read_tmcc_s(demod, &tmcc);
+			if (!ret)
+				break;
+			msleep_interruptible(1);
+		}
+		if (ret) {
+			pr_debug("fail tc_read_tmcc_s ret=0x%x\n", ret);
+			demod->state = TC90522_ABORT;
+			*delay = msecs_to_jiffies(1000);
+			return ret;
+		}
+		pr_debug("slots=%d,%d,%d,%d mode=%d,%d,%d,%d tmcc.id=0x%x,0x%x,0x%x,0x%x,0x%x,0x%x,0x%x,0x%x\n",
+				tmcc.slot[0], tmcc.slot[1], tmcc.slot[2], tmcc.slot[3],
+				tmcc.mode[0], tmcc.mode[1], tmcc.mode[2], tmcc.mode[3],
+				tmcc.id[0], tmcc.id[1], tmcc.id[2], tmcc.id[3],
+				tmcc.id[4], tmcc.id[5], tmcc.id[6], tmcc.id[7]);
+		for (i = 0; i < ARRAY_SIZE(tmcc.id); i++) {
+			pr_debug("tsid %x i %d tmcc.id %x\n", tsid, i, tmcc.id[i]);
+			if (tmcc.id[i] == tsid)
+				break;
+		}
+		if (tsid < ARRAY_SIZE(tmcc.id))		/* treat as slot# */
+			i = tsid;
+		if (i == ARRAY_SIZE(tmcc.id)) {
+			pr_debug("#%d i%d tsid 0x%x not found\n", demod->idx, i, tsid);
+			return -EINVAL;
+		}
+		demod->offset = i;
+		pr_debug("#%d found tsid 0x%x on slot %d\n", demod->idx, tsid, i);
+		ret = tc90522_write_id_s(fe, (u16)tmcc.id[demod->offset]);
+		if (ret) {
+			pr_debug("fail set_tmcc_s ret=%d\n", ret);
+			return ret;
+		}
+		for (i = 0; i < 1000; i++) {
+			u16 short_id;
+			ret = tc90522_read_id_s(demod, &short_id);
+			if (ret) {
+				pr_debug("fail get_id_s ret=%d\n", ret);
+				return ret;
+			}
+			tsid = short_id;
+			pr_debug("#%d tsid=0x%x\n", demod->idx, tsid);
+			if ((tsid & 0xffff) == tmcc.id[demod->offset])
+				break;
+			msleep_interruptible(1);
+		}
+		demod->state = TC90522_TRACK;
+		/* fallthrough */
+
+	case TC90522_TRACK:
+		*delay = msecs_to_jiffies(3000);
+		*status = FE_HAS_SIGNAL | FE_HAS_CARRIER | FE_HAS_LOCK;
+		return 0;
+
+	case TC90522_ABORT:
+		*delay = msecs_to_jiffies(3000);
+		*status = FE_HAS_SIGNAL;
+		return 0;
+	}
+	return -ERANGE;
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
+	.read_signal_strength = tc90522_read_signal_strength,
+	.read_status = tc90522_read_status,
+	.tune = tc90522_tune_s,
+};
+
+/**** ISDB-T ****/
+int tc90522_get_tmcc_t(struct tc90522 *demod)
+{
+	u8 buf;
+	bool b = false, retryov, fulock;
+
+	while (1) {
+		if (tc90522_read(demod, 0x80, &buf, 1))
+			return -EBADMSG;
+		retryov = buf & 0b10000000 ? true : false;
+		fulock  = buf & 0b00001000 ? true : false;
+		if (!fulock) {
+			b = true;
+			break;
+		} else {
+			if (retryov)
+				break;
+		}
+		msleep_interruptible(1);
+	}
+	return b ? 0 : -EBADMSG;
+}
+
+int tc90522_tune_t(struct dvb_frontend *fe, bool re_tune, unsigned int mode_flags, unsigned int *delay, fe_status_t *status)
+{
+	struct tc90522 *demod = fe->demodulator_priv;
+	int ret, i;
+
+	if (re_tune)
+		demod->state = TC90522_SET_FREQUENCY;
+
+	switch (demod->state) {
+	case TC90522_IDLE:
+		*delay = msecs_to_jiffies(3000);
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
+			ret = tc90522_get_tmcc_t(demod);
+			if (!ret)
+				break;
+			msleep_interruptible(2);
+		}
+		if (ret) {
+			pr_debug("#%d fail get_tmcc_t ret=%d\n", demod->idx, ret);
+				demod->state = TC90522_ABORT;
+				*delay = msecs_to_jiffies(1000);
+				return 0;
+		}
+		demod->state = TC90522_TRACK;
+		/* fallthrough */
+
+	case TC90522_TRACK:
+		*delay = msecs_to_jiffies(3000);
+		*status = FE_HAS_SIGNAL | FE_HAS_CARRIER | FE_HAS_LOCK;
+		return 0;
+
+	case TC90522_ABORT:
+		*delay = msecs_to_jiffies(3000);
+		*status = FE_HAS_SIGNAL;
+		return 0;
+	}
+	return -ERANGE;
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
+	.read_signal_strength = tc90522_read_signal_strength,
+	.read_status = tc90522_read_status,
+	.tune = tc90522_tune_t,
+};
+
+/**** Common ****/
+struct dvb_frontend *tc90522_attach(struct i2c_adapter *i2c, u8 idx, fe_delivery_system_t type, u8 addr_demod)
+{
+	struct dvb_frontend *fe;
+	struct tc90522 *demod = kzalloc(sizeof(struct tc90522), GFP_KERNEL);
+	if (!demod)
+		return NULL;
+
+	demod->i2c	= i2c;
+	demod->idx	= idx;
+	demod->type	= type;
+	demod->addr_demod = addr_demod;
+	fe = &demod->fe;
+	memcpy(&fe->ops, (demod->type == SYS_ISDBS) ? &tc90522_ops_s : &tc90522_ops_t, sizeof(struct dvb_frontend_ops));
+	fe->demodulator_priv = demod;
+	return fe;
+}
+EXPORT_SYMBOL(tc90522_attach);
+
diff --git a/drivers/media/dvb-frontends/tc90522.h b/drivers/media/dvb-frontends/tc90522.h
new file mode 100644
index 0000000..78c5298
--- /dev/null
+++ b/drivers/media/dvb-frontends/tc90522.h
@@ -0,0 +1,36 @@
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
+#ifndef pr_fmt
+ #define pr_fmt(fmt) KBUILD_MODNAME " " fmt
+#endif
+#include "dvb_frontend.h"
+
+#if IS_ENABLED(CONFIG_DVB_TC90522)
+extern struct dvb_frontend *tc90522_attach(struct i2c_adapter *i2c, u8 idx, fe_delivery_system_t type, u8 addr_demod);
+#else
+static inline struct dvb_frontend *tc90522_attach(struct i2c_adapter *i2c, u8 idx, fe_delivery_system_t type, u8 addr_demod)
+{
+	pr_warn("%s: driver disabled by Kconfig\n", __func__);
+	return NULL;
+}
+#endif
+
+#endif
+
diff --git a/drivers/media/pci/Kconfig b/drivers/media/pci/Kconfig
index 53196f1..87018c8 100644
--- a/drivers/media/pci/Kconfig
+++ b/drivers/media/pci/Kconfig
@@ -30,7 +30,6 @@ source "drivers/media/pci/cx88/Kconfig"
 source "drivers/media/pci/bt8xx/Kconfig"
 source "drivers/media/pci/saa7134/Kconfig"
 source "drivers/media/pci/saa7164/Kconfig"
-
 endif
 
 if MEDIA_DIGITAL_TV_SUPPORT
@@ -40,6 +39,7 @@ source "drivers/media/pci/b2c2/Kconfig"
 source "drivers/media/pci/pluto2/Kconfig"
 source "drivers/media/pci/dm1105/Kconfig"
 source "drivers/media/pci/pt1/Kconfig"
+source "drivers/media/pci/pt3/Kconfig"
 source "drivers/media/pci/mantis/Kconfig"
 source "drivers/media/pci/ngene/Kconfig"
 source "drivers/media/pci/ddbridge/Kconfig"
diff --git a/drivers/media/pci/Makefile b/drivers/media/pci/Makefile
index 35cc578..f7be6bc 100644
--- a/drivers/media/pci/Makefile
+++ b/drivers/media/pci/Makefile
@@ -7,6 +7,7 @@ obj-y        +=	ttpci/		\
 		pluto2/		\
 		dm1105/		\
 		pt1/		\
+		pt3/		\
 		mantis/		\
 		ngene/		\
 		ddbridge/	\
diff --git a/drivers/media/pci/pt3/Kconfig b/drivers/media/pci/pt3/Kconfig
new file mode 100644
index 0000000..0d866a0
--- /dev/null
+++ b/drivers/media/pci/pt3/Kconfig
@@ -0,0 +1,11 @@
+config PT3_DVB
+	tristate "Earthsoft PT3 ISDB-S/T cards"
+	depends on DVB_CORE && PCI
+	select DVB_TC90522 if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_QM1D1C0042 if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_MXL301RF if MEDIA_SUBDRV_AUTOSELECT
+	help
+	  Support for Earthsoft PT3 PCI-Express cards.
+	  You need to enable frontend (TC90522) & tuners (QM1D1C0042, MXL301RF)
+	  Say Y or M if you own such a device and want to use it.
+
diff --git a/drivers/media/pci/pt3/Makefile b/drivers/media/pci/pt3/Makefile
new file mode 100644
index 0000000..ede00e1
--- /dev/null
+++ b/drivers/media/pci/pt3/Makefile
@@ -0,0 +1,6 @@
+pt3_dvb-objs := pt3_pci.o pt3_dma.o pt3_i2c.o
+
+obj-$(CONFIG_PT3_DVB) += pt3_dvb.o
+
+ccflags-y += -Idrivers/media/dvb-core -Idrivers/media/dvb-frontends -Idrivers/media/tuners
+
diff --git a/drivers/media/pci/pt3/pt3_common.h b/drivers/media/pci/pt3/pt3_common.h
new file mode 100644
index 0000000..21b36f5
--- /dev/null
+++ b/drivers/media/pci/pt3/pt3_common.h
@@ -0,0 +1,86 @@
+/*
+ * DVB driver for Earthsoft PT3 ISDB-S/T PCI-E card
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
+#ifndef	__PT3_COMMON_H__
+#define	__PT3_COMMON_H__
+
+#define pr_fmt(fmt) KBUILD_MODNAME " " fmt
+
+#include <linux/pci.h>
+#include <linux/kthread.h>
+#include <linux/freezer.h>
+#include "dvb_demux.h"
+#include "dmxdev.h"
+#include "dvb_frontend.h"
+
+#define DRV_NAME "pt3_dvb"
+
+/* register idx */
+#define PT3_REG_VERSION	0x00	/*	R	Version		*/
+#define PT3_REG_BUS	0x04	/*	R	Bus		*/
+#define PT3_REG_SYS_W	0x08	/*	W	System		*/
+#define PT3_REG_SYS_R	0x0c	/*	R	System		*/
+#define PT3_REG_I2C_W	0x10	/*	W	I2C		*/
+#define PT3_REG_I2C_R	0x14	/*	R	I2C		*/
+#define PT3_REG_RAM_W	0x18	/*	W	RAM		*/
+#define PT3_REG_RAM_R	0x1c	/*	R	RAM		*/
+#define PT3_REG_BASE	0x40	/* + 0x18*idx			*/
+#define PT3_REG_DMA_D_L	0x00	/*	W	DMA descriptor	*/
+#define PT3_REG_DMA_D_H	0x04	/*	W	DMA descriptor	*/
+#define PT3_REG_DMA_CTL	0x08	/*	W	DMA		*/
+#define PT3_REG_TS_CTL	0x0c	/*	W	TS		*/
+#define PT3_REG_STATUS	0x10	/*	R	DMA/FIFO/TS	*/
+#define PT3_REG_TS_ERR	0x14	/*	R	TS		*/
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
+
+struct pt3_adapter {
+	struct mutex lock;
+	struct pt3_board *pt3;
+
+	u8 idx;
+	bool sleep;
+	struct pt3_dma *dma;
+	struct task_struct *kthread;
+	struct dvb_adapter dvb;
+	struct dvb_demux demux;
+	struct dmxdev dmxdev;
+	int users, voltage;
+
+	struct dvb_frontend *fe;
+	int (*orig_voltage)(struct dvb_frontend *fe, fe_sec_voltage_t voltage);
+	int (*orig_sleep)(struct dvb_frontend *fe);
+	int (*orig_init)(struct dvb_frontend *fe);
+};
+
+#endif
+
diff --git a/drivers/media/pci/pt3/pt3_dma.c b/drivers/media/pci/pt3/pt3_dma.c
new file mode 100644
index 0000000..a1fb82e
--- /dev/null
+++ b/drivers/media/pci/pt3/pt3_dma.c
@@ -0,0 +1,333 @@
+/*
+ * DVB driver for Earthsoft PT3 ISDB-S/T PCI-E card
+ *
+ * Copyright (C) 2013 Budi Rachmanto, AreMa Inc. <info@are.ma>
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
+#include "pt3_dma.h"
+
+#define PT3_DMA_MAX_DESCS	204
+#define PT3_DMA_PAGE_SIZE	(PT3_DMA_MAX_DESCS * sizeof(struct pt3_dma_desc))
+#define PT3_DMA_BLOCK_COUNT	17
+#define PT3_DMA_BLOCK_SIZE	(PT3_DMA_PAGE_SIZE * 47)
+#define PT3_DMA_TS_BUF_SIZE	(PT3_DMA_BLOCK_SIZE * PT3_DMA_BLOCK_COUNT)
+#define PT3_DMA_TS_SYNC		0x47
+#define PT3_DMA_TS_NOT_SYNC	0x74
+
+void pt3_dma_free(struct pt3_dma *dma)
+{
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
+	}
+	if (dma->desc_info) {
+		for (i = 0; i < dma->desc_count; i++) {
+			page = &dma->desc_info[i];
+			if (page->data)
+				pci_free_consistent(dma->adap->pt3->pdev, page->size, page->data, page->addr);
+		}
+		kfree(dma->desc_info);
+	}
+	kfree(dma);
+}
+
+struct pt3_dma_desc {
+	u64 page_addr;
+	u32 page_size;
+	u64 next_desc;
+} __packed;
+
+void pt3_dma_build_page_descriptor(struct pt3_dma *dma)
+{
+	struct pt3_dma_page *desc_info, *ts_info;
+	u64 ts_addr, desc_addr;
+	u32 i, j, ts_size, desc_remain, ts_info_pos, desc_info_pos;
+	struct pt3_dma_desc *prev, *curr;
+
+	pr_debug("#%d %s ts_count=%d ts_size=%d desc_count=%d desc_size=%d\n",
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
+			pr_debug("#%d ts_info overflow max=%d curr=%d\n", dma->adap->idx, dma->ts_count, ts_info_pos);
+			return;
+		}
+		ts_info = &dma->ts_info[ts_info_pos];
+		ts_addr = ts_info->addr;
+		ts_size = ts_info->size;
+		ts_info_pos++;
+		pr_debug("#%d i=%d, ts_info addr=0x%llx ts_size=%d\n", dma->adap->idx, i, ts_addr, ts_size);
+		for (j = 0; j < ts_size / PT3_DMA_PAGE_SIZE; j++) {
+			if (desc_remain < sizeof(struct pt3_dma_desc)) {
+				if (unlikely(desc_info_pos >= dma->desc_count)) {
+					pr_debug("#%d desc_info overflow max=%d curr=%d\n",
+						dma->adap->idx, dma->desc_count, desc_info_pos);
+					return;
+				}
+				desc_info = &dma->desc_info[desc_info_pos];
+				desc_info->data_pos = 0;
+				curr = (struct pt3_dma_desc *)&desc_info->data[desc_info->data_pos];
+				pr_debug("#%d desc_info_pos=%d ts_addr=0x%llx remain=%d\n",
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
+			pr_debug("#%d j=%d dma write desc ts_addr=0x%llx desc_info_pos=%d desc_remain=%d\n",
+				dma->adap->idx, j, ts_addr, desc_info_pos, desc_remain);
+			ts_addr += PT3_DMA_PAGE_SIZE;
+
+			prev = curr;
+			desc_info->data_pos += sizeof(struct pt3_dma_desc);
+			if (unlikely(desc_info->data_pos > desc_info->size)) {
+				pr_debug("#%d dma desc_info data overflow max=%d curr=%d\n",
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
+}
+
+struct pt3_dma *pt3_dma_create(struct pt3_adapter *adap)
+{
+	struct pt3_dma_page *page;
+	u32 i;
+
+	struct pt3_dma *dma = kzalloc(sizeof(struct pt3_dma), GFP_KERNEL);
+	if (!dma) {
+		pr_debug("#%d fail allocate PT3_DMA\n", adap->idx);
+		goto fail;
+	}
+	dma->adap = adap;
+	dma->enabled = false;
+	mutex_init(&dma->lock);
+
+	dma->ts_count = PT3_DMA_BLOCK_COUNT;
+	dma->ts_info = kzalloc(sizeof(struct pt3_dma_page) * dma->ts_count, GFP_KERNEL);
+	if (!dma->ts_info) {
+		pr_debug("#%d fail allocate TS DMA page\n", adap->idx);
+		goto fail;
+	}
+	pr_debug("#%d Alloc TS buf (ts_count %d)\n", adap->idx, dma->ts_count);
+	for (i = 0; i < dma->ts_count; i++) {
+		page = &dma->ts_info[i];
+		page->size = PT3_DMA_BLOCK_SIZE;
+		page->data_pos = 0;
+		page->data = pci_alloc_consistent(adap->pt3->pdev, page->size, &page->addr);
+		if (!page->data) {
+			pr_debug("#%d fail alloc_consistent. %d\n", adap->idx, i);
+			goto fail;
+		}
+	}
+
+	dma->desc_count = 1 + (PT3_DMA_TS_BUF_SIZE / PT3_DMA_PAGE_SIZE - 1) / PT3_DMA_MAX_DESCS;
+	dma->desc_info = kzalloc(sizeof(struct pt3_dma_page) * dma->desc_count, GFP_KERNEL);
+	if (!dma->desc_info) {
+		pr_debug("#%d fail allocate Desc DMA page\n", adap->idx);
+		goto fail;
+	}
+	pr_debug("#%d Alloc Descriptor buf (desc_count %d)\n", adap->idx, dma->desc_count);
+	for (i = 0; i < dma->desc_count; i++) {
+		page = &dma->desc_info[i];
+		page->size = PT3_DMA_PAGE_SIZE;
+		page->data_pos = 0;
+		page->data = pci_alloc_consistent(adap->pt3->pdev, page->size, &page->addr);
+		if (!page->data) {
+			pr_debug("#%d fail alloc_consistent %d\n", adap->idx, i);
+			goto fail;
+		}
+	}
+
+	pr_debug("#%d build page descriptor\n", adap->idx);
+	pt3_dma_build_page_descriptor(dma);
+	return dma;
+fail:
+	if (dma)
+		pt3_dma_free(dma);
+	return NULL;
+}
+
+void __iomem *pt3_dma_get_base_addr(struct pt3_dma *dma)
+{
+	return dma->adap->pt3->bar_reg + PT3_REG_BASE + (0x18 * dma->adap->idx);
+}
+
+void pt3_dma_reset(struct pt3_dma *dma)
+{
+	struct pt3_dma_page *ts;
+	u32 i;
+
+	for (i = 0; i < dma->ts_count; i++) {
+		ts = &dma->ts_info[i];
+		memset(ts->data, 0, ts->size);
+		ts->data_pos = 0;
+		*ts->data = PT3_DMA_TS_NOT_SYNC;
+	}
+	dma->ts_pos = 0;
+}
+
+void pt3_dma_set_enabled(struct pt3_dma *dma, bool enabled)
+{
+	void __iomem *base = pt3_dma_get_base_addr(dma);
+	u64 start_addr = dma->desc_info->addr;
+
+	if (enabled) {
+		pr_debug("#%d DMA enable start_addr=%llx\n", dma->adap->idx, start_addr);
+		pt3_dma_reset(dma);
+		writel(1 << 1, base + PT3_REG_DMA_CTL);	/* stop DMA */
+		writel(start_addr         & 0xffffffff, base + PT3_REG_DMA_D_L);
+		writel((start_addr >> 32) & 0xffffffff, base + PT3_REG_DMA_D_H);
+		pr_debug("set descriptor address low %llx\n",  start_addr         & 0xffffffff);
+		pr_debug("set descriptor address high %llx\n", (start_addr >> 32) & 0xffffffff);
+		writel(1 << 0, base + PT3_REG_DMA_CTL);	/* start DMA */
+	} else {
+		pr_debug("#%d DMA disable\n", dma->adap->idx);
+		writel(1 << 1, base + PT3_REG_DMA_CTL);	/* stop DMA */
+		while (1) {
+			if (!(readl(base + PT3_REG_STATUS) & 1))
+				break;
+			msleep_interruptible(1);
+		}
+	}
+	dma->enabled = enabled;
+}
+
+/* convert Gray code to binary, e.g. 1001 -> 1110 */
+static u32 pt3_dma_gray2binary(u32 gray, u32 bit)
+{
+	u32 binary = 0, i, j, k;
+
+	for (i = 0; i < bit; i++) {
+		k = 0;
+		for (j = i; j < bit; j++)
+			k ^= (gray >> j) & 1;
+		binary |= k << i;
+	}
+	return binary;
+}
+
+u32 pt3_dma_get_ts_error_packet_count(struct pt3_dma *dma)
+{
+	return pt3_dma_gray2binary(readl(pt3_dma_get_base_addr(dma) + PT3_REG_TS_ERR), 32);
+}
+
+void pt3_dma_set_test_mode(struct pt3_dma *dma, enum pt3_dma_mode mode, u16 initval)
+{
+	void __iomem *base = pt3_dma_get_base_addr(dma);
+	u32 data = mode | initval;
+	pr_debug("#%d %s base=%p data=0x%04x\n", dma->adap->idx, __func__, base, data);
+	writel(data, base + PT3_REG_TS_CTL);
+}
+
+bool pt3_dma_ready(struct pt3_dma *dma)
+{
+	struct pt3_dma_page *ts;
+	u8 *p;
+
+	u32 next = dma->ts_pos + 1;
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
+	pr_debug("#%d invalid sync byte value=0x%02x ts_pos=%d data_pos=%d curr=0x%02x\n",
+		dma->adap->idx, *p, next, ts->data_pos, dma->ts_info[dma->ts_pos].data[0]);
+	return false;
+}
+
+ssize_t pt3_dma_copy(struct pt3_dma *dma, struct dvb_demux *demux)
+{
+	bool ready;
+	struct pt3_dma_page *ts;
+	u32 i, prev;
+	size_t csize, remain = dma->ts_info[dma->ts_pos].size;
+
+	mutex_lock(&dma->lock);
+	pr_debug("#%d dma_copy ts_pos=0x%x data_pos=0x%x\n",
+		   dma->adap->idx, dma->ts_pos, dma->ts_info[dma->ts_pos].data_pos);
+	for (;;) {
+		for (i = 0; i < 20; i++) {
+			ready = pt3_dma_ready(dma);
+			if (ready)
+				break;
+			msleep_interruptible(30);
+		}
+		if (!ready) {
+			pr_debug("#%d dma_copy NOT READY\n", dma->adap->idx);
+			goto last;
+		}
+		prev = dma->ts_pos - 1;
+		if (prev < 0 || dma->ts_count <= prev)
+			prev = dma->ts_count - 1;
+		if (dma->ts_info[prev].data[0] != PT3_DMA_TS_NOT_SYNC)
+			pr_debug("#%d DMA buffer overflow. prev=%d data=0x%x\n",
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
+		}
+	}
+last:
+	mutex_unlock(&dma->lock);
+	return dma->ts_info[dma->ts_pos].size - remain;
+}
+
+u32 pt3_dma_get_status(struct pt3_dma *dma)
+{
+	return readl(pt3_dma_get_base_addr(dma) + PT3_REG_STATUS);
+}
+
diff --git a/drivers/media/pci/pt3/pt3_dma.h b/drivers/media/pci/pt3/pt3_dma.h
new file mode 100644
index 0000000..934c222
--- /dev/null
+++ b/drivers/media/pci/pt3/pt3_dma.h
@@ -0,0 +1,50 @@
+/*
+ * DVB driver for Earthsoft PT3 ISDB-S/T PCI-E card
+ *
+ * Copyright (C) 2013 Budi Rachmanto, AreMa Inc. <info@are.ma>
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
+#ifndef	__PT3_DMA_H__
+#define	__PT3_DMA_H__
+
+#include "pt3_common.h"
+
+struct pt3_dma_page {
+	dma_addr_t addr;
+	u8 *data;
+	u32 size, data_pos;
+};
+
+enum pt3_dma_mode {
+	USE_LFSR = 1 << 16,
+	REVERSE  = 1 << 17,
+	RESET    = 1 << 18,
+};
+
+struct pt3_dma {
+	struct pt3_adapter *adap;
+	bool enabled;
+	u32 ts_pos, ts_count, desc_count;
+	struct pt3_dma_page *ts_info, *desc_info;
+	struct mutex lock;
+};
+
+ssize_t pt3_dma_copy(struct pt3_dma *dma, struct dvb_demux *demux);
+struct pt3_dma *pt3_dma_create(struct pt3_adapter *adap);
+void pt3_dma_free(struct pt3_dma *dma);
+u32 pt3_dma_get_status(struct pt3_dma *dma);
+u32 pt3_dma_get_ts_error_packet_count(struct pt3_dma *dma);
+void pt3_dma_set_enabled(struct pt3_dma *dma, bool enabled);
+void pt3_dma_set_test_mode(struct pt3_dma *dma, enum pt3_dma_mode mode, u16 initval);
+
+#endif
diff --git a/drivers/media/pci/pt3/pt3_i2c.c b/drivers/media/pci/pt3/pt3_i2c.c
new file mode 100644
index 0000000..e872ae1
--- /dev/null
+++ b/drivers/media/pci/pt3/pt3_i2c.c
@@ -0,0 +1,189 @@
+/*
+ * DVB driver for Earthsoft PT3 ISDB-S/T PCI-E card
+ *
+ * Copyright (C) 2013 Budi Rachmanto, AreMa Inc. <info@are.ma>
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
+#include "pt3_i2c.h"
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
+
+bool pt3_i2c_is_clean(struct pt3_board *pt3)
+{
+	return (readl(pt3->bar_reg + PT3_REG_I2C_R) >> 3) & 1;
+}
+
+void pt3_i2c_reset(struct pt3_board *pt3)
+{
+	writel(1 << 17, pt3->bar_reg + PT3_REG_I2C_W);	/* 0x00020000 */
+}
+
+void pt3_i2c_wait(struct pt3_board *pt3, u32 *status)
+{
+	u32 val;
+
+	while (1) {
+		val = readl(pt3->bar_reg + PT3_REG_I2C_R);
+		if (!(val & 1))				/* sequence stopped */
+			break;
+		msleep_interruptible(1);
+	}
+	if (status)
+		*status = val;				/* I2C register status */
+}
+
+void pt3_i2c_mem_write(struct pt3_board *pt3, u8 data)
+{
+	void __iomem *dst = pt3->bar_mem + PT3_I2C_DATA_OFFSET + pt3->i2c_addr;
+
+	if (pt3->i2c_filled) {
+		pt3->i2c_buf |= data << 4;
+		writeb(pt3->i2c_buf, dst);
+		pt3->i2c_addr++;
+	} else
+		pt3->i2c_buf = data;
+	pt3->i2c_filled ^= true;
+}
+
+void pt3_i2c_start(struct pt3_board *pt3)
+{
+	pt3_i2c_mem_write(pt3, I_DATA_H);
+	pt3_i2c_mem_write(pt3, I_CLOCK_H);
+	pt3_i2c_mem_write(pt3, I_DATA_L);
+	pt3_i2c_mem_write(pt3, I_CLOCK_L);
+}
+
+void pt3_i2c_cmd_write(struct pt3_board *pt3, const u8 *data, u32 size)
+{
+	u32 i, j;
+	u8 byte;
+
+	for (i = 0; i < size; i++) {
+		byte = data[i];
+		for (j = 0; j < 8; j++)
+			pt3_i2c_mem_write(pt3, (byte >> (7 - j)) & 1 ? I_DATA_H_NOP : I_DATA_L_NOP);
+		pt3_i2c_mem_write(pt3, I_DATA_H_ACK0);
+	}
+}
+
+void pt3_i2c_cmd_read(struct pt3_board *pt3, u8 *data, u32 size)
+{
+	u32 i, j;
+
+	for (i = 0; i < size; i++) {
+		for (j = 0; j < 8; j++)
+			pt3_i2c_mem_write(pt3, I_DATA_H_READ);
+		if (i == (size - 1))
+			pt3_i2c_mem_write(pt3, I_DATA_H_NOP);
+		else
+			pt3_i2c_mem_write(pt3, I_DATA_L_NOP);
+	}
+}
+
+void pt3_i2c_stop(struct pt3_board *pt3)
+{
+	pt3_i2c_mem_write(pt3, I_DATA_L);
+	pt3_i2c_mem_write(pt3, I_CLOCK_H);
+	pt3_i2c_mem_write(pt3, I_DATA_H);
+}
+
+int pt3_i2c_flush(struct pt3_board *pt3, bool end, u32 start_addr)
+{
+	u32 status;
+
+	if (end) {
+		pt3_i2c_mem_write(pt3, I_END);
+		if (pt3->i2c_filled)
+			pt3_i2c_mem_write(pt3, I_END);
+	}
+	pt3_i2c_wait(pt3, &status);
+	writel(1 << 16 | start_addr, pt3->bar_reg + PT3_REG_I2C_W);	/* 0x00010000 start sequence */
+	pt3_i2c_wait(pt3, &status);
+	if (status & 0b0110) {						/* ACK status */
+		pr_err("%s failed, status=0x%x\n", __func__, status);
+		return -EIO;
+	}
+	return 0;
+}
+
+u32 pt3_i2c_func(struct i2c_adapter *i2c)
+{
+	return I2C_FUNC_I2C;
+}
+
+int pt3_i2c_xfer(struct i2c_adapter *i2c, struct i2c_msg *msg, int num)
+{
+	struct pt3_board *pt3 = i2c_get_adapdata(i2c);
+	int i, j;
+
+	if (!num)
+		return pt3_i2c_flush(pt3, false, PT3_I2C_START_ADDR);
+	if ((num < 1) || (num > 3) || !msg || msg[0].flags)	/* always write first */
+		return -ENOTSUPP;
+	mutex_lock(&pt3->lock);
+	pt3->i2c_addr = 0;
+	for (i = 0; i < num; i++) {
+		u8 byte = (msg[i].addr << 1) | (msg[i].flags & 1);
+		pt3_i2c_start(pt3);
+		pt3_i2c_cmd_write(pt3, &byte, 1);
+		if (msg[i].flags == I2C_M_RD)
+			pt3_i2c_cmd_read(pt3, msg[i].buf, msg[i].len);
+		else
+			pt3_i2c_cmd_write(pt3, msg[i].buf, msg[i].len);
+	}
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
+
+int pt3_i2c_add_adapter(struct pt3_board *pt3)
+{
+	struct i2c_adapter *i2c = &pt3->i2c;
+	i2c->algo = &pt3_i2c_algo;
+	i2c->algo_data = NULL;
+	i2c->dev.parent = &pt3->pdev->dev;
+	strcpy(i2c->name, DRV_NAME);
+	i2c_set_adapdata(i2c, pt3);
+	return	i2c_add_adapter(i2c) ||
+		(!pt3_i2c_is_clean(pt3) && pt3_i2c_flush(pt3, false, 0));
+}
+
diff --git a/drivers/media/pci/pt3/pt3_i2c.h b/drivers/media/pci/pt3/pt3_i2c.h
new file mode 100644
index 0000000..8424fd5
--- /dev/null
+++ b/drivers/media/pci/pt3/pt3_i2c.h
@@ -0,0 +1,25 @@
+/*
+ * DVB driver for Earthsoft PT3 ISDB-S/T PCI-E card
+ *
+ * Copyright (C) 2013 Budi Rachmanto, AreMa Inc. <info@are.ma>
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
+#ifndef	__PT3_I2C_H__
+#define	__PT3_I2C_H__
+
+#include "pt3_common.h"
+
+void pt3_i2c_reset(struct pt3_board *pt3);
+int pt3_i2c_add_adapter(struct pt3_board *pt3);
+
+#endif
diff --git a/drivers/media/pci/pt3/pt3_pci.c b/drivers/media/pci/pt3/pt3_pci.c
new file mode 100644
index 0000000..858c30d
--- /dev/null
+++ b/drivers/media/pci/pt3/pt3_pci.c
@@ -0,0 +1,397 @@
+/*
+ * DVB driver for Earthsoft PT3 ISDB-S/T PCIE bridge Altera Cyclone IV FPGA EP4CGX15BF14C8N
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
+#include "pt3_dma.h"
+#include "pt3_i2c.h"
+#include "tc90522.h"
+#include "qm1d1c0042.h"
+#include "mxl301rf.h"
+
+MODULE_AUTHOR("Budi Rachmanto, AreMa Inc. <knightrider(@)are.ma>");
+MODULE_DESCRIPTION("Earthsoft PT3 DVB Driver");
+MODULE_LICENSE("GPL");
+
+static struct pci_device_id pt3_id_table[] = {
+	{ PCI_DEVICE(0x1172, 0x4c15) },
+	{ },
+};
+MODULE_DEVICE_TABLE(pci, pt3_id_table);
+
+static int lnb = 2;
+module_param(lnb, int, 0);
+MODULE_PARM_DESC(lnb, "LNB level (0:OFF 1:+11V 2:+15V)");
+
+struct pt3_lnb {
+	u32 bits;
+	char *str;
+};
+
+static const struct pt3_lnb pt3_lnb[] = {
+	{0b1100,  "0V"},
+	{0b1101, "11V"},
+	{0b1111, "15V"},
+};
+
+struct pt3_cfg {
+	fe_delivery_system_t type;
+	u8 addr_tuner, addr_demod;
+};
+
+static const struct pt3_cfg pt3_cfg[] = {
+	{SYS_ISDBS, 0x63, 0b00010001},
+	{SYS_ISDBS, 0x60, 0b00010011},
+	{SYS_ISDBT, 0x62, 0b00010000},
+	{SYS_ISDBT, 0x61, 0b00010010},
+};
+#define PT3_ADAPN ARRAY_SIZE(pt3_cfg)
+
+int pt3_update_lnb(struct pt3_board *pt3)
+{
+	u8 i, lnb_eff = 0;
+
+	if (pt3->reset) {
+		writel(pt3_lnb[0].bits, pt3->bar_reg + PT3_REG_SYS_W);
+		pt3->reset = false;
+		pt3->lnb = 0;
+	} else {
+		struct pt3_adapter *adap;
+		for (i = 0; i < PT3_ADAPN; i++) {
+			adap = pt3->adap[i];
+			pr_debug("#%d sleep %d\n", adap->idx, adap->sleep);
+			if ((pt3_cfg[i].type == SYS_ISDBS) && (!adap->sleep))
+				lnb_eff |= adap->voltage ? adap->voltage : lnb;
+		}
+		if (unlikely(lnb_eff < 0 || 2 < lnb_eff)) {
+			pr_err("Inconsistent LNB settings\n");
+			return -EINVAL;
+		}
+		if (pt3->lnb != lnb_eff) {
+			writel(pt3_lnb[lnb_eff].bits, pt3->bar_reg + PT3_REG_SYS_W);
+			pt3->lnb = lnb_eff;
+		}
+	}
+	pr_debug("LNB=%s\n", pt3_lnb[lnb_eff].str);
+	return 0;
+}
+
+int pt3_thread(void *data)
+{
+	size_t ret;
+	struct pt3_adapter *adap = data;
+
+	pr_debug("#%d %s sleep %d\n", adap->idx, __func__, adap->sleep);
+	set_freezable();
+	while (!kthread_should_stop()) {
+		try_to_freeze();
+		while ((ret = pt3_dma_copy(adap->dma, &adap->demux)) > 0)
+			;
+		if (ret < 0) {
+			pr_debug("#%d fail dma_copy\n", adap->idx);
+			msleep_interruptible(1);
+		}
+	}
+	return 0;
+}
+
+int pt3_start_feed(struct dvb_demux_feed *feed)
+{
+	int ret = 0;
+	struct pt3_adapter *adap = container_of(feed->demux, struct pt3_adapter, demux);
+	pr_debug("#%d %s sleep %d\n", adap->idx, __func__, adap->sleep);
+	if (!adap->users++) {
+		pr_debug("#%d %s selected, DMA %s\n",
+			adap->idx, (pt3_cfg[adap->idx].type == SYS_ISDBS) ? "S" : "T",
+			pt3_dma_get_status(adap->dma) & 1 ? "ON" : "OFF");
+		mutex_lock(&adap->lock);
+		if (!adap->kthread) {
+			adap->kthread = kthread_run(pt3_thread, adap, DRV_NAME "_%d", adap->idx);
+			if (IS_ERR(adap->kthread)) {
+				ret = PTR_ERR(adap->kthread);
+				adap->kthread = NULL;
+			} else {
+				pt3_dma_set_test_mode(adap->dma, RESET, 0);	/* reset error count */
+				pt3_dma_set_enabled(adap->dma, true);
+			}
+		}
+		mutex_unlock(&adap->lock);
+		if (ret)
+			return ret;
+	}
+	return 0;
+}
+
+int pt3_stop_feed(struct dvb_demux_feed *feed)
+{
+	struct pt3_adapter *adap = container_of(feed->demux, struct pt3_adapter, demux);
+	pr_debug("#%d %s sleep %d\n", adap->idx, __func__, adap->sleep);
+	if (!--adap->users) {
+		mutex_lock(&adap->lock);
+		if (adap->kthread) {
+			pt3_dma_set_enabled(adap->dma, false);
+			pr_debug("#%d DMA ts_err packet cnt %d\n",
+				adap->idx, pt3_dma_get_ts_error_packet_count(adap->dma));
+			kthread_stop(adap->kthread);
+			adap->kthread = NULL;
+		}
+		mutex_unlock(&adap->lock);
+		msleep_interruptible(40);
+	}
+	return 0;
+}
+
+DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
+
+struct pt3_adapter *pt3_dvb_register_adapter(struct pt3_board *pt3)
+{
+	int ret;
+	struct dvb_adapter *dvb;
+	struct dvb_demux *demux;
+	struct dmxdev *dmxdev;
+	struct pt3_adapter *adap = kzalloc(sizeof(struct pt3_adapter), GFP_KERNEL);
+	if (!adap)
+		return ERR_PTR(-ENOMEM);
+
+	adap->pt3 = pt3;
+	adap->sleep = true;
+
+	dvb = &adap->dvb;
+	dvb->priv = adap;
+	ret = dvb_register_adapter(dvb, DRV_NAME, THIS_MODULE, &pt3->pdev->dev, adapter_nr);
+	pr_debug("adapter%d registered\n", ret);
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
+	kfree(adap);
+	return ERR_PTR(ret);
+}
+
+int pt3_sleep(struct dvb_frontend *fe)
+{
+	struct pt3_adapter *adap = container_of(fe->dvb, struct pt3_adapter, dvb);
+	pr_debug("#%d %s orig %p\n", adap->idx, __func__, adap->orig_sleep);
+	adap->sleep = true;
+	pt3_update_lnb(adap->pt3);
+	return (adap->orig_sleep) ? adap->orig_sleep(fe) : 0;
+}
+
+int pt3_wakeup(struct dvb_frontend *fe)
+{
+	struct pt3_adapter *adap = container_of(fe->dvb, struct pt3_adapter, dvb);
+	pr_debug("#%d %s orig %p\n", adap->idx, __func__, adap->orig_init);
+	adap->sleep = false;
+	pt3_update_lnb(adap->pt3);
+	return (adap->orig_init) ? adap->orig_init(fe) : 0;
+}
+
+int pt3_set_voltage(struct dvb_frontend *fe, fe_sec_voltage_t voltage)
+{
+	struct pt3_adapter *adap = container_of(fe->dvb, struct pt3_adapter, dvb);
+	adap->voltage = voltage == SEC_VOLTAGE_18 ? 2 : voltage == SEC_VOLTAGE_13 ? 1 : 0;
+	return (adap->orig_voltage) ? adap->orig_voltage(fe, voltage) : 0;
+}
+
+void pt3_cleanup_adapter(struct pt3_adapter *adap)
+{
+	if (!adap)
+		return;
+	if (adap->kthread)
+		kthread_stop(adap->kthread);
+	if (adap->fe) {
+		dvb_unregister_frontend(adap->fe);
+		adap->fe->ops.release(adap->fe);
+	}
+	if (adap->dma) {
+		if (adap->dma->enabled)
+			pt3_dma_set_enabled(adap->dma, false);
+		pt3_dma_free(adap->dma);
+	}
+	adap->demux.dmx.close(&adap->demux.dmx);
+	dvb_dmxdev_release(&adap->dmxdev);
+	dvb_dmx_release(&adap->demux);
+	dvb_unregister_adapter(&adap->dvb);
+	kfree(adap);
+}
+
+void pt3_remove(struct pci_dev *pdev)
+{
+	int i;
+	struct pt3_board *pt3 = pci_get_drvdata(pdev);
+
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
+	}
+	pci_disable_device(pdev);
+}
+
+int pt3_abort(struct pci_dev *pdev, int ret, char *fmt, ...)
+{
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
+	return ret;
+}
+
+int pt3_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
+{
+	struct pt3_board *pt3;
+	struct pt3_adapter *adap;
+	const struct pt3_cfg *cfg = pt3_cfg;
+	struct dvb_frontend *fe[PT3_ADAPN];
+	int i, err, bars = pci_select_bars(pdev, IORESOURCE_MEM);
+
+	err = pci_enable_device(pdev)					||
+		pci_set_dma_mask(pdev, DMA_BIT_MASK(64))		||
+		pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64))	||
+		pci_read_config_dword(pdev, PCI_CLASS_REVISION, &i)	||
+		pci_request_selected_regions(pdev, bars, DRV_NAME);
+	if (err)
+		return pt3_abort(pdev, err, "PCI/DMA error\n");
+	if ((i & 0xFF) != 1)
+		return pt3_abort(pdev, -EINVAL, "Revision 0x%x is not supported\n", i & 0xFF);
+
+	pci_set_master(pdev);
+	err = pci_save_state(pdev);
+	if (err)
+		return pt3_abort(pdev, err, "Failed pci_save_state\n");
+	pt3 = kzalloc(sizeof(struct pt3_board), GFP_KERNEL);
+	if (!pt3)
+		return pt3_abort(pdev, -ENOMEM, "struct pt3_board out of memory\n");
+	pt3->adap = kzalloc(PT3_ADAPN * sizeof(struct pt3_adapter *), GFP_KERNEL);
+	if (!pt3->adap)
+		return pt3_abort(pdev, -ENOMEM, "No memory for *adap\n");
+
+	pt3->bars = bars;
+	pt3->pdev = pdev;
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
+	mutex_init(&pt3->lock);
+
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
+		fe[i] = tc90522_attach(&pt3->i2c, i, cfg[i].type, cfg[i].addr_demod);
+		if (!fe[i] || (cfg[i].type == SYS_ISDBS ?
+			qm1d1c0042_attach(fe[i], i, cfg[i].addr_tuner) : mxl301rf_attach(fe[i], i, cfg[i].addr_tuner))) {
+			while (i--)
+				fe[i]->ops.release(fe[i]);
+			return pt3_abort(pdev, -ENOMEM, "Cannot attach frontend\n");
+		}
+	}
+	fe[i-1]->ops.init(fe[i-1]);	/* power on tuner & amp */
+
+	for (i = 0; i < PT3_ADAPN; i++) {
+		struct pt3_adapter *adap = pt3->adap[i];
+		pr_debug("#%d %s\n", i, __func__);
+
+		adap->orig_voltage     = fe[i]->ops.set_voltage;
+		adap->orig_sleep       = fe[i]->ops.sleep;
+		adap->orig_init        = fe[i]->ops.init;
+		fe[i]->ops.set_voltage = pt3_set_voltage;
+		fe[i]->ops.sleep       = pt3_sleep;
+		fe[i]->ops.init        = pt3_wakeup;
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
+	}
+	pt3->reset = true;
+	pt3_update_lnb(pt3);
+	return 0;
+}
+
+static struct pci_driver pt3_driver = {
+	.name		= DRV_NAME,
+	.probe		= pt3_probe,
+	.remove		= pt3_remove,
+	.id_table	= pt3_id_table,
+};
+
+module_pci_driver(pt3_driver);
+
diff --git a/drivers/media/tuners/Kconfig b/drivers/media/tuners/Kconfig
index a128488..8ca8ed7 100644
--- a/drivers/media/tuners/Kconfig
+++ b/drivers/media/tuners/Kconfig
@@ -243,4 +243,19 @@ config MEDIA_TUNER_R820T
 	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Rafael Micro R820T silicon tuner driver.
+
+config MEDIA_TUNER_MXL301RF
+	tristate "MaxLinear MXL301RF ISDB-T tuner"
+	depends on MEDIA_SUPPORT && I2C
+	default m if !MEDIA_SUBDRV_AUTOSELECT
+	help
+	  MaxLinear MxL301RF ISDB-T tuner driver for PT3.
+
+config MEDIA_TUNER_QM1D1C0042
+	tristate "Sharp QM1D1C0042 ISDB-S tuner"
+	depends on MEDIA_SUPPORT && I2C
+	default m if !MEDIA_SUBDRV_AUTOSELECT
+	help
+	  Sharp QM1D1C0042 ISDB-S tuner driver for PT3 PCIE card.
+
 endmenu
diff --git a/drivers/media/tuners/Makefile b/drivers/media/tuners/Makefile
index efe82a9..b98c988 100644
--- a/drivers/media/tuners/Makefile
+++ b/drivers/media/tuners/Makefile
@@ -37,6 +37,8 @@ obj-$(CONFIG_MEDIA_TUNER_FC0012) += fc0012.o
 obj-$(CONFIG_MEDIA_TUNER_FC0013) += fc0013.o
 obj-$(CONFIG_MEDIA_TUNER_IT913X) += tuner_it913x.o
 obj-$(CONFIG_MEDIA_TUNER_R820T) += r820t.o
+obj-$(CONFIG_MEDIA_TUNER_MXL301RF) += mxl301rf.o
+obj-$(CONFIG_MEDIA_TUNER_QM1D1C0042) += qm1d1c0042.o
 
 ccflags-y += -I$(srctree)/drivers/media/dvb-core
 ccflags-y += -I$(srctree)/drivers/media/dvb-frontends
diff --git a/drivers/media/tuners/mxl301rf.c b/drivers/media/tuners/mxl301rf.c
new file mode 100644
index 0000000..cc60831
--- /dev/null
+++ b/drivers/media/tuners/mxl301rf.c
@@ -0,0 +1,390 @@
+/*
+ * Sharp VA4M6JC2103 - Earthsoft PT3 ISDB-T tuner MaxLinear CMOS Hybrid TV MxL301RF
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
+#include "mxl301rf.h"
+
+MODULE_AUTHOR("Budi Rachmanto, AreMa Inc. <knightrider(@)are.ma>");
+MODULE_DESCRIPTION("Earthsoft PT3 MxL301RF MaxLinear CMOS Hybrid TV ISDB-T tuner driver");
+MODULE_LICENSE("GPL");
+
+struct mxl301rf {
+	struct dvb_frontend *fe;
+	u8 addr_tuner, idx;
+	u32 freq;
+};
+
+struct shf_dvbt {
+	u32	freq,		/* Channel center frequency @ kHz	*/
+		freq_th;	/* Offset frequency threshold @ kHz	*/
+	u8	shf_val,	/* Spur shift value			*/
+		shf_dir;	/* Spur shift direction			*/
+};
+
+static const struct shf_dvbt shf_dvbt_tab[] = {
+	{  64500, 500, 0x92, 0x07 },
+	{ 191500, 300, 0xe2, 0x07 },
+	{ 205500, 500, 0x2c, 0x04 },
+	{ 212500, 500, 0x1e, 0x04 },
+	{ 226500, 500, 0xd4, 0x07 },
+	{  99143, 500, 0x9c, 0x07 },
+	{ 173143, 500, 0xd4, 0x07 },
+	{ 191143, 300, 0xd4, 0x07 },
+	{ 207143, 500, 0xce, 0x07 },
+	{ 225143, 500, 0xce, 0x07 },
+	{ 243143, 500, 0xd4, 0x07 },
+	{ 261143, 500, 0xd4, 0x07 },
+	{ 291143, 500, 0xd4, 0x07 },
+	{ 339143, 500, 0x2c, 0x04 },
+	{ 117143, 500, 0x7a, 0x07 },
+	{ 135143, 300, 0x7a, 0x07 },
+	{ 153143, 500, 0x01, 0x07 }
+};
+
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
+};
+#define MXL301RF_NHK (mxl301rf_rf_tab[77])	/* 日本放送協会 Nippon Hōsō Kyōkai, Japan Broadcasting Corporation */
+
+int mxl301rf_freq(int freq)
+{
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
+
+void mxl301rf_rftune(u8 *data, u32 *size, u32 freq)
+{
+	u32 dig_rf_freq, tmp, frac_divider, kHz, MHz, i;
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
+	};
+
+	freq = mxl301rf_freq(freq);
+	dig_rf_freq = 0;
+	tmp = 0;
+	frac_divider = 1000000;
+	kHz = 1000;
+	MHz = 1000000;
+
+	dig_rf_freq = freq / MHz;
+	tmp = freq % MHz;
+
+	for (i = 0; i < 6; i++) {
+		dig_rf_freq <<= 1;
+		frac_divider /= 2;
+		if (tmp > frac_divider) {
+			tmp -= frac_divider;
+			dig_rf_freq++;
+		}
+	}
+	if (tmp > 7812)
+		dig_rf_freq++;
+
+	rf_data[2 * (7) + 1] = (u8)(dig_rf_freq);
+	rf_data[2 * (8) + 1] = (u8)(dig_rf_freq >> 8);
+
+	for (i = 0; i < ARRAY_SIZE(shf_dvbt_tab); i++) {
+		if ((freq >= (shf_dvbt_tab[i].freq - shf_dvbt_tab[i].freq_th) * kHz) &&
+				(freq <= (shf_dvbt_tab[i].freq + shf_dvbt_tab[i].freq_th) * kHz)) {
+			rf_data[2 * (5) + 1] = shf_dvbt_tab[i].shf_val;
+			rf_data[2 * (6) + 1] = 0xa0 | shf_dvbt_tab[i].shf_dir;
+			break;
+		}
+	}
+	memcpy(data, rf_data, sizeof(rf_data));
+	*size = sizeof(rf_data);
+
+	pr_debug("mx_rftune freq=%d\n", freq);
+}
+
+/* write via demod */
+int mxl301rf_fe_write_data(struct dvb_frontend *fe, u8 addr_data, const u8 *data, int len)
+{
+	u8 buf[len + 1];
+
+	buf[0] = addr_data;
+	memcpy(buf + 1, data, len);
+	return fe->ops.write(fe, buf, len + 1);
+}
+
+#define MXL301RF_FE_PASSTHROUGH 0xfe
+
+int mxl301rf_fe_write_tuner(struct dvb_frontend *fe, const u8 *data, int len)
+{
+	u8 buf[len + 2];
+
+	buf[0] = MXL301RF_FE_PASSTHROUGH;
+	buf[1] = ((struct mxl301rf *)fe->tuner_priv)->addr_tuner << 1;
+	memcpy(buf + 2, data, len);
+	return fe->ops.write(fe, buf, len + 2);
+}
+
+/* read via demod */
+void mxl301rf_fe_read(struct dvb_frontend *fe, u8 addr, u8 *data)
+{
+	const u8 wbuf[2] = {0xfb, addr};
+	int ret;
+
+	mxl301rf_fe_write_tuner(fe, wbuf, sizeof(wbuf));
+	ret = fe->ops.write(fe, NULL, (1 << 16) | (((struct mxl301rf *)fe->tuner_priv)->addr_tuner << 8) | addr);
+	if (ret >= 0)
+		*data = ret;
+}
+
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
+}
+
+void mxl301rf_set_register(struct dvb_frontend *fe, u8 addr, u8 value)
+{
+	const u8 data[2] = {addr, value};
+	mxl301rf_fe_write_tuner(fe, data, sizeof(data));
+}
+
+int mxl301rf_write_imsrst(struct dvb_frontend *fe)
+{
+	u8 data = 0x01 << 6;
+	return mxl301rf_fe_write_data(fe, 0x01, &data, 1);
+}
+
+enum mxl301rf_agc {
+	MXL301RF_AGC_AUTO,
+	MXL301RF_AGC_MANUAL,
+};
+
+int mxl301rf_set_agc(struct dvb_frontend *fe, enum mxl301rf_agc agc)
+{
+	u8 data = (agc == MXL301RF_AGC_AUTO) ? 0x40 : 0x00;
+	int ret = mxl301rf_fe_write_data(fe, 0x25, &data, 1);
+	if (ret)
+		return ret;
+
+	data = 0x4c | ((agc == MXL301RF_AGC_AUTO) ? 0x00 : 0x01);
+	return	mxl301rf_fe_write_data(fe, 0x23, &data, 1) ||
+		mxl301rf_write_imsrst(fe);
+}
+
+int mxl301rf_sleep(struct dvb_frontend *fe)
+{
+	u8 buf = (1 << 7) | (1 << 4);
+	const u8 data[4] = {0x01, 0x00, 0x13, 0x00};
+	int err = mxl301rf_set_agc(fe, MXL301RF_AGC_MANUAL);
+	if (err)
+		return err;
+	mxl301rf_fe_write_tuner(fe, data, sizeof(data));
+	return mxl301rf_fe_write_data(fe, 0x03, &buf, 1);
+}
+
+static const u8 mxl301rf_freq_tab[][3] = {
+	{   2, 0,  3 },
+	{  12, 1, 22 },
+	{  21, 0, 12 },
+	{  62, 1, 63 },
+	{ 112, 0, 62 }
+};
+
+bool mxl301rf_rfsynth_locked(struct dvb_frontend *fe)
+{
+	u8 data;
+
+	mxl301rf_fe_read(fe, 0x16, &data);
+	return (data & 0x0c) == 0x0c;
+}
+
+bool mxl301rf_refsynth_locked(struct dvb_frontend *fe)
+{
+	u8 data;
+
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
+	pr_debug("#%d %s lock1=%d lock2=%d\n", ((struct mxl301rf *)fe->tuner_priv)->idx, __func__, locked1, locked2);
+	return locked1 && locked2 ? !mxl301rf_set_agc(fe, MXL301RF_AGC_AUTO) : false;
+}
+
+int mxl301rf_tuner_rftune(struct dvb_frontend *fe, u32 freq)
+{
+	struct mxl301rf *mx = fe->tuner_priv;
+	u8 data[100];
+	u32 size = 0;
+	int err = mxl301rf_set_agc(fe, MXL301RF_AGC_MANUAL);
+	if (err)
+		return err;
+
+	mx->freq = freq;
+	mxl301rf_rftune(data, &size, freq);
+	if (size != 20) {
+		pr_debug("fail mx_rftune size = %d\n", size);
+		return -EINVAL;
+	}
+	mxl301rf_fe_write_tuner(fe, data, 14);
+	msleep_interruptible(1);
+	mxl301rf_fe_write_tuner(fe, data + 14, 6);
+	msleep_interruptible(1);
+	mxl301rf_set_register(fe, 0x1a, 0x0d);
+	mxl301rf_idac_setting(fe);
+
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
+	return 0;
+}
+
+void mxl301rf_ch2freq(u32 channel, bool *catv, u32 *number, u32 *freq)
+{
+	u32 i;
+	s32 freq_offset = 0;
+
+	if (12 <= channel)
+		freq_offset += 2;
+	if (17 <= channel)
+		freq_offset -= 2;
+	if (63 <= channel)
+		freq_offset += 2;
+	*freq = 93 + channel * 6 + freq_offset;
+
+	for (i = 0; i < ARRAY_SIZE(mxl301rf_freq_tab); i++) {
+		if (channel <= mxl301rf_freq_tab[i][0]) {
+			*catv = mxl301rf_freq_tab[i][1] ? true : false;
+			*number = channel + mxl301rf_freq_tab[i][2] - mxl301rf_freq_tab[i][0];
+			break;
+		}
+	}
+}
+
+int mxl301rf_release(struct dvb_frontend *fe)
+{
+	kfree(fe->tuner_priv);
+	fe->tuner_priv = NULL;
+	return 0;
+}
+
+static struct dvb_tuner_ops mxl301rf_ops = {
+	.info = {
+		.frequency_min	= 1,		/* actually 90 MHz, freq below that is handled as ch */
+		.frequency_max	= 770000000,	/* Hz */
+		.frequency_step	= 142857,
+	},
+	.set_frequency = mxl301rf_tuner_rftune,
+	.sleep = mxl301rf_sleep,
+	.init = mxl301rf_wakeup,
+	.release = mxl301rf_release,
+};
+
+int mxl301rf_attach(struct dvb_frontend *fe, u8 idx, u8 addr_tuner)
+{
+	u8 d[] = { 0x10, 0x01 };
+	struct mxl301rf *mx = kzalloc(sizeof(struct mxl301rf), GFP_KERNEL);
+	if (!mx)
+		return -ENOMEM;
+	fe->tuner_priv = mx;
+	mx->fe = fe;
+	mx->idx = idx;
+	mx->addr_tuner = addr_tuner;
+	memcpy(&fe->ops.tuner_ops, &mxl301rf_ops, sizeof(struct dvb_tuner_ops));
+
+	return	mxl301rf_fe_write_data(fe, 0x1c, d, 1)	||
+		mxl301rf_fe_write_data(fe, 0x1d, d+1, 1);
+}
+EXPORT_SYMBOL(mxl301rf_attach);
+
diff --git a/drivers/media/tuners/mxl301rf.h b/drivers/media/tuners/mxl301rf.h
new file mode 100644
index 0000000..22599b9
--- /dev/null
+++ b/drivers/media/tuners/mxl301rf.h
@@ -0,0 +1,36 @@
+/*
+ * Sharp VA4M6JC2103 - Earthsoft PT3 ISDB-T tuner MaxLinear CMOS Hybrid TV MxL301RF
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
+#ifndef __MXL301RF_H__
+#define __MXL301RF_H__
+
+#ifndef pr_fmt
+ #define pr_fmt(fmt) KBUILD_MODNAME " " fmt
+#endif
+#include "dvb_frontend.h"
+
+#if IS_ENABLED(CONFIG_MEDIA_TUNER_MXL301RF)
+extern int mxl301rf_attach(struct dvb_frontend *fe, u8 idx, u8 addr_tuner);
+#else
+static inline int mxl301rf_attach(struct dvb_frontend *fe, u8 idx, u8 addr_tuner)
+{
+	pr_warn("%s: driver disabled by Kconfig\n", __func__);
+	return 0;
+}
+#endif
+
+#endif
+
diff --git a/drivers/media/tuners/qm1d1c0042.c b/drivers/media/tuners/qm1d1c0042.c
new file mode 100644
index 0000000..3be552f
--- /dev/null
+++ b/drivers/media/tuners/qm1d1c0042.c
@@ -0,0 +1,382 @@
+/*
+ * Sharp VA4M6JC2103 - Earthsoft PT3 ISDB-S tuner driver QM1D1C0042
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
+#include "qm1d1c0042.h"
+
+MODULE_AUTHOR("Budi Rachmanto, AreMa Inc. <knightrider(@)are.ma>");
+MODULE_DESCRIPTION("Earthsoft PT3 QM1D1C0042 ISDB-S tuner driver");
+MODULE_LICENSE("GPL");
+
+struct qm1d1c0042 {
+	struct dvb_frontend *fe;
+	u8 addr_tuner, idx, reg[32];
+	u32 freq;
+};
+
+static const u8 qm1d1c0042_reg_rw[] = {
+	0x48, 0x1c, 0xa0, 0x10, 0xbc, 0xc5, 0x20, 0x33,
+	0x06, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00,
+	0x00, 0xff, 0xf3, 0x00, 0x2a, 0x64, 0xa6, 0x86,
+	0x8c, 0xcf, 0xb8, 0xf1, 0xa8, 0xf2, 0x89, 0x00,
+};
+
+/* read via demodulator */
+int qm1d1c0042_fe_read(struct dvb_frontend *fe, u8 addr, u8 *data)
+{
+	int ret;
+	if ((addr != 0x00) && (addr != 0x0d))
+		return -EFAULT;
+	ret = fe->ops.write(fe, NULL, (((struct qm1d1c0042 *)fe->tuner_priv)->addr_tuner << 8) | addr);
+	if (ret < 0)
+		return ret;
+	*data = ret;
+	return 0;
+}
+
+/* write via demodulator */
+int qm1d1c0042_fe_write_data(struct dvb_frontend *fe, u8 addr_data, u8 *data, int len)
+{
+	u8 buf[len + 1];
+
+	buf[0] = addr_data;
+	memcpy(buf + 1, data, len);
+	return fe->ops.write(fe, buf, len + 1);
+}
+
+#define QM1D1C0042_FE_PASSTHROUGH 0xfe
+
+int qm1d1c0042_fe_write_tuner(struct dvb_frontend *fe, u8 *data, int len)
+{
+	u8 buf[len + 2];
+
+	buf[0] = QM1D1C0042_FE_PASSTHROUGH;
+	buf[1] = ((struct qm1d1c0042 *)fe->tuner_priv)->addr_tuner << 1;
+	memcpy(buf + 2, data, len);
+	return fe->ops.write(fe, buf, len + 2);
+}
+
+int qm1d1c0042_write(struct dvb_frontend *fe, u8 addr, u8 data)
+{
+	struct qm1d1c0042 *qm = fe->tuner_priv;
+	u8 buf[] = { addr, data };
+	int err = qm1d1c0042_fe_write_tuner(fe, buf, sizeof(buf));
+	qm->reg[addr] = buf[1];
+	return err;
+}
+
+static const u8 qm1d1c0042_flag[32] = {
+	0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0,
+	0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
+};
+
+int qm1d1c0042_write_pskmsrst(struct dvb_frontend *fe)
+{
+	u8 data = 0x01;
+	return qm1d1c0042_fe_write_data(fe, 0x03, &data, 1);
+}
+
+enum qm1d1c0042_agc {
+	QM1D1C0042_AGC_AUTO,
+	QM1D1C0042_AGC_MANUAL,
+};
+
+int qm1d1c0042_set_agc(struct dvb_frontend *fe, enum qm1d1c0042_agc agc)
+{
+	struct qm1d1c0042 *qm = fe->tuner_priv;
+	static u8 agc_data_s[2] = { 0xb0, 0x30 };
+	u8 data = (agc == QM1D1C0042_AGC_AUTO) ? 0xff : 0x00;
+	int ret = qm1d1c0042_fe_write_data(fe, 0x0a, &data, 1);
+	if (ret)
+		return ret;
+
+	data = agc_data_s[(qm->idx >> 1) & 1];
+	data |= (agc == QM1D1C0042_AGC_AUTO) ? 0x01 : 0x00;
+	ret = qm1d1c0042_fe_write_data(fe, 0x10, &data, 1);
+	if (ret)
+		return ret;
+
+	data = (agc == QM1D1C0042_AGC_AUTO) ? 0x40 : 0x00;
+	return (ret = qm1d1c0042_fe_write_data(fe, 0x11, &data, 1)) ? ret : qm1d1c0042_write_pskmsrst(fe);
+}
+
+int qm1d1c0042_sleep(struct dvb_frontend *fe)
+{
+	struct qm1d1c0042 *qm = fe->tuner_priv;
+	u8 buf = 1;
+	pr_debug("#%d %s\n", qm->idx, __func__);
+
+	qm->reg[0x01] &= (~(1 << 3)) & 0xff;
+	qm->reg[0x01] |= 1 << 0;
+	qm->reg[0x05] |= 1 << 3;
+	return	qm1d1c0042_set_agc(fe, QM1D1C0042_AGC_MANUAL)	||
+		qm1d1c0042_write(fe, 0x05, qm->reg[0x05])	||
+		qm1d1c0042_write(fe, 0x01, qm->reg[0x01])	||
+		qm1d1c0042_fe_write_data(fe, 0x17, &buf, 1);
+}
+
+int qm1d1c0042_wakeup(struct dvb_frontend *fe)
+{
+	struct qm1d1c0042 *qm = fe->tuner_priv;
+	u8 buf = 0;
+	pr_debug("#%d %s\n", qm->idx, __func__);
+
+	qm->reg[0x01] |= 1 << 3;
+	qm->reg[0x01] &= (~(1 << 0)) & 0xff;
+	qm->reg[0x05] &= (~(1 << 3)) & 0xff;
+	return	qm1d1c0042_fe_write_data(fe, 0x17, &buf, 1)	||
+		qm1d1c0042_write(fe, 0x01, qm->reg[0x01])	||
+		qm1d1c0042_write(fe, 0x05, qm->reg[0x05]);
+}
+
+void qm1d1c0042_get_channel_freq(u32 channel, u32 *number, u32 *freq)
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
+}
+
+static const u32 qm1d1c0042_freq_tab[9][3] = {
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
+static const u32 qm1d1c0042_sd_tab[24][2][3] = {
+	{{0x38fae1, 0x0d, 0x5}, {0x39fae1, 0x0d, 0x5},},
+	{{0x3f570a, 0x0e, 0x3}, {0x00570a, 0x0e, 0x3},},
+	{{0x05b333, 0x0e, 0x5}, {0x06b333, 0x0e, 0x5},},
+	{{0x3c0f5c, 0x0f, 0x4}, {0x3d0f5c, 0x0f, 0x4},},
+	{{0x026b85, 0x0f, 0x6}, {0x036b85, 0x0f, 0x6},},
+	{{0x38c7ae, 0x10, 0x5}, {0x39c7ae, 0x10, 0x5},},
+	{{0x3f23d7, 0x11, 0x3}, {0x0023d7, 0x11, 0x3},},
+	{{0x058000, 0x11, 0x5}, {0x068000, 0x11, 0x5},},
+	{{0x3bdc28, 0x12, 0x4}, {0x3cdc28, 0x12, 0x4},},
+	{{0x023851, 0x12, 0x6}, {0x033851, 0x12, 0x6},},
+	{{0x38947a, 0x13, 0x5}, {0x39947a, 0x13, 0x5},},
+	{{0x3ef0a3, 0x14, 0x3}, {0x3ff0a3, 0x14, 0x3},},
+	{{0x3c8000, 0x16, 0x4}, {0x3d8000, 0x16, 0x4},},
+	{{0x048000, 0x16, 0x6}, {0x058000, 0x16, 0x6},},
+	{{0x3c8000, 0x17, 0x5}, {0x3d8000, 0x17, 0x5},},
+	{{0x048000, 0x18, 0x3}, {0x058000, 0x18, 0x3},},
+	{{0x3c8000, 0x18, 0x6}, {0x3d8000, 0x18, 0x6},},
+	{{0x048000, 0x19, 0x4}, {0x058000, 0x19, 0x4},},
+	{{0x3c8000, 0x1a, 0x3}, {0x3d8000, 0x1a, 0x3},},
+	{{0x048000, 0x1a, 0x5}, {0x058000, 0x1a, 0x5},},
+	{{0x3c8000, 0x1b, 0x4}, {0x3d8000, 0x1b, 0x4},},
+	{{0x048000, 0x1b, 0x6}, {0x058000, 0x1b, 0x6},},
+	{{0x3c8000, 0x1c, 0x5}, {0x3d8000, 0x1c, 0x5},},
+	{{0x048000, 0x1d, 0x3}, {0x058000, 0x1d, 0x3},},
+};
+
+static int qm1d1c0042_tuning(struct qm1d1c0042 *qm, u32 *sd, u32 channel)
+{
+	int ret;
+	struct dvb_frontend *fe = qm->fe;
+	u8 i_data;
+	u32 i, N, A, index = (qm->idx >> 1) & 1;
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
+		}
+	}
+
+	*sd = qm1d1c0042_sd_tab[channel][index][0];
+	N = qm1d1c0042_sd_tab[channel][index][1];
+	A = qm1d1c0042_sd_tab[channel][index][2];
+
+	qm->reg[0x06] &= 0x40;
+	qm->reg[0x06] |= N;
+	ret = qm1d1c0042_write(fe, 0x06, qm->reg[0x06]);
+	if (ret)
+		return ret;
+
+	qm->reg[0x07] &= 0xf0;
+	qm->reg[0x07] |= A & 0x0f;
+	return qm1d1c0042_write(fe, 0x07, qm->reg[0x07]);
+}
+
+static int qm1d1c0042_local_lpf_tuning(struct qm1d1c0042 *qm, u32 channel)
+{
+	struct dvb_frontend *fe = qm->fe;
+	u8 i_data;
+	u32 sd = 0;
+	int ret = qm1d1c0042_tuning(qm, &sd, channel);
+	if (ret)
+		return ret;
+
+	i_data = qm->reg[0x08] & 0xf0;
+	i_data |= 2;
+	ret = qm1d1c0042_write(fe, 0x08, i_data);
+	if (ret)
+		return ret;
+
+	qm->reg[0x09] &= 0xc0;
+	qm->reg[0x09] |= (sd >> 16) & 0x3f;
+	qm->reg[0x0a] = (sd >> 8) & 0xff;
+	qm->reg[0x0b] = (sd >> 0) & 0xff;
+	ret =	qm1d1c0042_write(fe, 0x09, qm->reg[0x09])	||
+		qm1d1c0042_write(fe, 0x0a, qm->reg[0x0a])	||
+		qm1d1c0042_write(qm->fe, 0x0b, qm->reg[0x0b]);
+	if (ret)
+		return ret;
+
+	i_data = qm->reg[0x0c];
+	i_data &= 0x3f;
+	ret = qm1d1c0042_write(fe, 0x0c, i_data);
+	if (ret)
+		return ret;
+	msleep_interruptible(1);
+
+	i_data = qm->reg[0x0c];
+	i_data |= 0xc0;
+	return	qm1d1c0042_write(fe, 0x0c, i_data)	||
+		qm1d1c0042_write(fe, 0x08, 0x09)	||
+		qm1d1c0042_write(fe, 0x13, qm->reg[0x13]);
+}
+
+int qm1d1c0042_get_locked(struct qm1d1c0042 *qm, bool *locked)
+{
+	int ret = qm1d1c0042_fe_read(qm->fe, 0x0d, &qm->reg[0x0d]);
+	if (ret)
+		return ret;
+	if (qm->reg[0x0d] & 0x40)
+		*locked = true;
+	else
+		*locked = false;
+	return ret;
+}
+
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
+	else if (min == diff1)
+		return ch1 + 12;
+	else
+		return ch0;
+}
+
+int qm1d1c0042_set_freq(struct dvb_frontend *fe, u32 frequency)
+{
+	struct qm1d1c0042 *qm = fe->tuner_priv;
+	u32 channel = qm1d1c0042_freq2ch(frequency);
+	u32 number, freq, freq_kHz;
+	bool locked = false;
+	unsigned long timeout;
+	int err = qm1d1c0042_set_agc(fe, QM1D1C0042_AGC_MANUAL);
+	if (err)
+		return err;
+
+	qm1d1c0042_get_channel_freq(channel, &number, &freq);
+	freq_kHz = freq * 10;
+	if (((qm->idx >> 1) & 1) == 0)
+		freq_kHz -= 500;
+	else
+		freq_kHz += 500;
+	qm->freq = freq_kHz;
+	pr_debug("#%d ch %d freq %d kHz\n", qm->idx, channel, freq_kHz);
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
+	}
+	pr_debug("#%d %s %s\n", qm->idx, __func__, locked ? "LOCKED" : "TIMEOUT");
+	return locked ? qm1d1c0042_set_agc(fe, QM1D1C0042_AGC_AUTO) : -ETIMEDOUT;
+}
+
+int qm1d1c0042_release(struct dvb_frontend *fe)
+{
+	kfree(fe->tuner_priv);
+	fe->tuner_priv = NULL;
+	return 0;
+}
+
+static struct dvb_tuner_ops qm1d1c0042_ops = {
+	.info = {
+		.frequency_min	= 1,		/* actually 1024 kHz, freq below that is handled as ch */
+		.frequency_max	= 2150000,	/* kHz */
+		.frequency_step	= 1000,		/* = 1 MHz */
+	},
+	.set_frequency = qm1d1c0042_set_freq,
+	.sleep = qm1d1c0042_sleep,
+	.init = qm1d1c0042_wakeup,
+	.release = qm1d1c0042_release,
+};
+
+int qm1d1c0042_attach(struct dvb_frontend *fe, u8 idx, u8 addr_tuner)
+{
+	u8 d[] = { 0x10, 0x15, 0x04 };
+	struct qm1d1c0042 *qm = kzalloc(sizeof(struct qm1d1c0042), GFP_KERNEL);
+	if (!qm)
+		return -ENOMEM;
+	fe->tuner_priv = qm;
+	qm->fe = fe;
+	qm->idx = idx;
+	qm->addr_tuner = addr_tuner;
+	memcpy(&fe->ops.tuner_ops, &qm1d1c0042_ops, sizeof(struct dvb_tuner_ops));
+
+	memcpy(qm->reg, qm1d1c0042_reg_rw, sizeof(qm1d1c0042_reg_rw));
+	qm->freq = 0;
+
+	return	qm1d1c0042_fe_write_data(fe, 0x1e, d,   1)	||
+		qm1d1c0042_fe_write_data(fe, 0x1c, d+1, 1)	||
+		qm1d1c0042_fe_write_data(fe, 0x1f, d+2, 1);
+}
+EXPORT_SYMBOL(qm1d1c0042_attach);
+
diff --git a/drivers/media/tuners/qm1d1c0042.h b/drivers/media/tuners/qm1d1c0042.h
new file mode 100644
index 0000000..2b14b70
--- /dev/null
+++ b/drivers/media/tuners/qm1d1c0042.h
@@ -0,0 +1,36 @@
+/*
+ * Sharp VA4M6JC2103 - Earthsoft PT3 ISDB-S tuner driver QM1D1C0042
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
+#ifndef __QM1D1C0042_H__
+#define __QM1D1C0042_H__
+
+#ifndef pr_fmt
+ #define pr_fmt(fmt) KBUILD_MODNAME " " fmt
+#endif
+#include "dvb_frontend.h"
+
+#if IS_ENABLED(CONFIG_MEDIA_TUNER_QM1D1C0042)
+extern int qm1d1c0042_attach(struct dvb_frontend *fe, u8 idx, u8 addr_tuner);
+#else
+static inline int qm1d1c0042_attach(struct dvb_frontend *fe, u8 idx, u8 addr_tuner)
+{
+	pr_warn("%s: driver disabled by Kconfig\n", __func__);
+	return 0;
+}
+#endif
+
+#endif
+
-- 
1.8.4.5

