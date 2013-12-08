Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f173.google.com ([209.85.192.173]:58998 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708Ab3LHFOg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Dec 2013 00:14:36 -0500
Received: by mail-pd0-f173.google.com with SMTP id p10so3264781pdj.32
        for <linux-media@vger.kernel.org>; Sat, 07 Dec 2013 21:14:36 -0800 (PST)
From: Guest <info@are.ma>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?=D0=91=D1=83=D0=B4=D0=B8=20=D0=A0=D0=BE=D0=BC=D0=B0=D0=BD=D1=82=D0=BE?=
	<knightrider@are.ma>, mchehab@redhat.com, hdegoede@redhat.com,
	hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	mkrufky@linuxtv.org, sylvester.nawrocki@gmail.com,
	g.liakhovetski@gmx.de, peter.senna@gmail.com
Subject: [PATCH] Full DVB driver package for Earthsoft PT3 (ISDB-S/T) cards
Date: Sun,  8 Dec 2013 14:14:11 +0900
Message-Id: <1386479651-23236-1-git-send-email-guest@puma.are.ma>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Буди Романто <knightrider@are.ma>

A DVB driver for Earthsoft PT3 (ISDB-S/T) receiver PCI Express cards, based on
1. PT3 chardev driver
	https://github.com/knight-rider/ptx/tree/master/pt3_drv
	https://github.com/m-tsudo/pt3
2. PT1/PT2 DVB driver
	drivers/media/pci/pt1

It behaves similarly as PT1 DVB, plus some tuning enhancements:
1. in addition to the real frequency:
	ISDB-S : freq. channel ID
	ISDB-T : freq# (I/O# +128), ch#, ch# +64 for CATV
2. in addition to TSID:
	ISDB-S : slot#

Feature changes:
- dropped DKMS & standalone compile
- dropped verbosity (debug levels), use single level -DDEBUG instead
- changed SNR (.read_snr) to CNR (.read_signal_strength)
- moved FE to drivers/media/dvb-frontends
- moved demodulator & tuners to drivers/media/tuners
- translated to standard (?) I2C protocol

The full package (buildable as standalone, DKMS or tree embedded module) is available at
https://github.com/knight-rider/ptx/tree/master/pt3_dvb

Signed-off-by: Bud R <knightrider@are.ma>

---
 drivers/media/dvb-frontends/Kconfig      |  10 +-
 drivers/media/dvb-frontends/Makefile     |   1 +
 drivers/media/dvb-frontends/pt3_common.h |  95 +++++
 drivers/media/dvb-frontends/pt3_fe.c     | 412 ++++++++++++++++++++++
 drivers/media/dvb-frontends/pt3_fe.h     |  22 ++
 drivers/media/pci/Kconfig                |   2 +-
 drivers/media/pci/Makefile               |   1 +
 drivers/media/pci/pt3/Kconfig            |  10 +
 drivers/media/pci/pt3/Makefile           |   6 +
 drivers/media/pci/pt3/pt3.c              | 579 +++++++++++++++++++++++++++++++
 drivers/media/pci/pt3/pt3.h              |  23 ++
 drivers/media/pci/pt3/pt3_dma.c          | 335 ++++++++++++++++++
 drivers/media/pci/pt3/pt3_dma.h          |  48 +++
 drivers/media/pci/pt3/pt3_i2c.c          | 167 +++++++++
 drivers/media/pci/pt3/pt3_i2c.h          |  29 ++
 drivers/media/tuners/Kconfig             |   7 +
 drivers/media/tuners/Makefile            |   2 +
 drivers/media/tuners/mxl301rf.c          | 347 ++++++++++++++++++
 drivers/media/tuners/mxl301rf.h          |  27 ++
 drivers/media/tuners/qm1d1c0042.c        | 413 ++++++++++++++++++++++
 drivers/media/tuners/qm1d1c0042.h        |  34 ++
 drivers/media/tuners/tc90522.c           | 412 ++++++++++++++++++++++
 drivers/media/tuners/tc90522.h           |  90 +++++
 23 files changed, 3070 insertions(+), 2 deletions(-)
 create mode 100644 drivers/media/dvb-frontends/pt3_common.h
 create mode 100644 drivers/media/dvb-frontends/pt3_fe.c
 create mode 100644 drivers/media/dvb-frontends/pt3_fe.h
 create mode 100644 drivers/media/pci/pt3/Kconfig
 create mode 100644 drivers/media/pci/pt3/Makefile
 create mode 100644 drivers/media/pci/pt3/pt3.c
 create mode 100644 drivers/media/pci/pt3/pt3.h
 create mode 100644 drivers/media/pci/pt3/pt3_dma.c
 create mode 100644 drivers/media/pci/pt3/pt3_dma.h
 create mode 100644 drivers/media/pci/pt3/pt3_i2c.c
 create mode 100644 drivers/media/pci/pt3/pt3_i2c.h
 create mode 100644 drivers/media/tuners/mxl301rf.c
 create mode 100644 drivers/media/tuners/mxl301rf.h
 create mode 100644 drivers/media/tuners/qm1d1c0042.c
 create mode 100644 drivers/media/tuners/qm1d1c0042.h
 create mode 100644 drivers/media/tuners/tc90522.c
 create mode 100644 drivers/media/tuners/tc90522.h

diff --git a/drivers/media/dvb-frontends/Kconfig b/drivers/media/dvb-frontends/Kconfig
index bddbab4..371c407 100644
--- a/drivers/media/dvb-frontends/Kconfig
+++ b/drivers/media/dvb-frontends/Kconfig
@@ -584,7 +584,7 @@ config DVB_S5H1411
 	  An ATSC 8VSB and QAM64/256 tuner module. Say Y when you want
 	  to support this frontend.
 
-comment "ISDB-T (terrestrial) frontends"
+comment "ISDB-S (satellite) & ISDB-T (terrestrial) frontends"
 	depends on DVB_CORE
 
 config DVB_S921
@@ -611,6 +611,14 @@ config DVB_MB86A20S
 	  A driver for Fujitsu mb86a20s ISDB-T/ISDB-Tsb demodulator.
 	  Say Y when you want to support this frontend.
 
+config DVB_PT3_FE
+	tristate "Earthsoft PT3 ISDB-S/T frontends"
+	depends on DVB_CORE && I2C
+	default m if !MEDIA_SUBDRV_AUTOSELECT
+	help
+	  DVB driver frontend for Earthsoft PT3 ISDB-S/ISDB-T PCIE cards.
+	  Say Y when you want to support this frontend.
+
 comment "Digital terrestrial only tuners/PLL"
 	depends on DVB_CORE
 
diff --git a/drivers/media/dvb-frontends/Makefile b/drivers/media/dvb-frontends/Makefile
index f9cb43d..1b97ba1 100644
--- a/drivers/media/dvb-frontends/Makefile
+++ b/drivers/media/dvb-frontends/Makefile
@@ -104,4 +104,5 @@ obj-$(CONFIG_DVB_RTL2830) += rtl2830.o
 obj-$(CONFIG_DVB_RTL2832) += rtl2832.o
 obj-$(CONFIG_DVB_M88RS2000) += m88rs2000.o
 obj-$(CONFIG_DVB_AF9033) += af9033.o
+obj-$(CONFIG_DVB_PT3_FE) += pt3_fe.o
 
diff --git a/drivers/media/dvb-frontends/pt3_common.h b/drivers/media/dvb-frontends/pt3_common.h
new file mode 100644
index 0000000..8519f0e
--- /dev/null
+++ b/drivers/media/dvb-frontends/pt3_common.h
@@ -0,0 +1,95 @@
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
+#define PT3_NR_ADAPS 4
+#define PT3_SHIFT_MASK(val, shift, mask) (((val) >> (shift)) & (((u64)1<<(mask))-1))
+
+/* register idx */
+#define REG_VERSION	0x00	/*	R	Version		*/
+#define REG_BUS		0x04	/*	R	Bus		*/
+#define REG_SYSTEM_W	0x08	/*	W	System		*/
+#define REG_SYSTEM_R	0x0c	/*	R	System		*/
+#define REG_I2C_W	0x10	/*	W	I2C		*/
+#define REG_I2C_R	0x14	/*	R	I2C		*/
+#define REG_RAM_W	0x18	/*	W	RAM		*/
+#define REG_RAM_R	0x1c	/*	R	RAM		*/
+#define REG_BASE	0x40	/* + 0x18*idx			*/
+#define REG_DMA_DESC_L	0x00	/*	W	DMA		*/
+#define REG_DMA_DESC_H	0x04	/*	W	DMA		*/
+#define REG_DMA_CTL	0x08	/*	W	DMA		*/
+#define REG_TS_CTL	0x0c	/*	W	TS		*/
+#define REG_STATUS	0x10	/*	R	DMA/FIFO/TS	*/
+#define REG_TS_ERR	0x14	/*	R	TS		*/
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
+	struct pt3_adapter *adap[PT3_NR_ADAPS];
+};
+
+struct pt3_adapter {
+	struct mutex lock;
+	struct pt3_board *pt3;
+
+	int idx, init_ch;
+	char *str;
+	fe_delivery_system_t type;
+	bool in_use, sleep;
+	u32 channel;
+	s32 offset;
+	u8 addr_demod, addr_tuner;
+	u32 freq;
+	struct qm1d1c0042 *qm;
+	struct pt3_dma *dma;
+	struct task_struct *kthread;
+	int *dec;
+	struct dvb_adapter dvb;
+	struct dvb_demux demux;
+	int users;
+	struct dmxdev dmxdev;
+	struct dvb_frontend *fe;
+	int (*orig_voltage)(struct dvb_frontend *fe, fe_sec_voltage_t voltage);
+	int (*orig_sleep)  (struct dvb_frontend *fe);
+	int (*orig_init)   (struct dvb_frontend *fe);
+	fe_sec_voltage_t voltage;
+};
+
+#endif
+
diff --git a/drivers/media/dvb-frontends/pt3_fe.c b/drivers/media/dvb-frontends/pt3_fe.c
new file mode 100644
index 0000000..00b5e06
--- /dev/null
+++ b/drivers/media/dvb-frontends/pt3_fe.c
@@ -0,0 +1,412 @@
+/*
+ * DVB Frontend driver for Earthsoft PT3 ISDB-S/T PCI-E card
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
+#include "pt3_common.h"
+#include "tc90522.h"
+#include "qm1d1c0042.h"
+#include "mxl301rf.h"
+
+MODULE_AUTHOR("Budi Rachmanto, AreMa Inc. <knightrider(@)are.ma>");
+MODULE_DESCRIPTION("DVB Frontend Driver for Earthsoft PT3 cards");
+MODULE_LICENSE("GPL");
+
+/**** Common ****/
+enum pt3_fe_tune_state {
+	PT3_TUNE_IDLE,
+	PT3_TUNE_SET_FREQUENCY,
+	PT3_TUNE_CHECK_FREQUENCY,
+	PT3_TUNE_SET_MODULATION,
+	PT3_TUNE_CHECK_MODULATION,
+	PT3_TUNE_SET_TS_ID,
+	PT3_TUNE_CHECK_TS_ID,
+	PT3_TUNE_TRACK,
+	PT3_TUNE_ABORT,
+};
+
+struct pt3_fe_state {
+	struct pt3_adapter *adap;
+	struct dvb_frontend fe;
+	enum pt3_fe_tune_state tune_state;
+};
+
+static int pt3_fe_read_signal_strength(struct dvb_frontend *fe, u16 *cn)
+{
+	struct pt3_fe_state *state = fe->demodulator_priv;
+	return tc90522_read_cn(state->adap, (u32 *)cn);
+}
+
+static int pt3_fe_get_frontend_algo(struct dvb_frontend *fe)
+{
+	return DVBFE_ALGO_HW;
+}
+
+static void pt3_fe_release(struct dvb_frontend *fe)
+{
+	kfree(fe->demodulator_priv);
+}
+
+static int pt3_fe_init(struct dvb_frontend *fe)
+{
+	struct pt3_fe_state *state = fe->demodulator_priv;
+	state->tune_state = PT3_TUNE_IDLE;
+	return (state->adap->type == SYS_ISDBS) ?
+		qm1d1c0042_set_sleep(state->adap->qm, false) : mxl301rf_set_sleep(state->adap, false);
+}
+
+static int pt3_fe_sleep(struct dvb_frontend *fe)
+{
+	struct pt3_fe_state *state = fe->demodulator_priv;
+	return (state->adap->type == SYS_ISDBS) ?
+		qm1d1c0042_set_sleep(state->adap->qm, true) : mxl301rf_set_sleep(state->adap, true);
+}
+
+/**** ISDB-S ****/
+u32 pt3_fe_s_get_channel(u32 frequency)
+{
+	u32 freq = frequency / 10,
+	    ch0 = (freq - 104948) / 3836, diff0 = freq - (104948 + 3836 * ch0),
+	    ch1 = (freq - 161300) / 4000, diff1 = freq - (161300 + 4000 * ch1),
+	    ch2 = (freq - 159300) / 4000, diff2 = freq - (159300 + 4000 * ch2),
+	    min = diff0 < diff1 ? diff0 : diff1;
+
+	if (diff2 < min)
+		return ch2 + 24;
+	else if (min == diff1)
+		return ch1 + 12;
+	else
+		return ch0;
+}
+
+static int pt3_fe_s_read_status(struct dvb_frontend *fe, fe_status_t *status)
+{
+	struct pt3_fe_state *state = fe->demodulator_priv;
+
+	switch (state->tune_state) {
+	case PT3_TUNE_IDLE:
+	case PT3_TUNE_SET_FREQUENCY:
+	case PT3_TUNE_CHECK_FREQUENCY:
+		*status = 0;
+		return 0;
+
+	case PT3_TUNE_SET_MODULATION:
+	case PT3_TUNE_CHECK_MODULATION:
+	case PT3_TUNE_ABORT:
+		*status |= FE_HAS_SIGNAL;
+		return 0;
+
+	case PT3_TUNE_SET_TS_ID:
+	case PT3_TUNE_CHECK_TS_ID:
+		*status |= FE_HAS_SIGNAL | FE_HAS_CARRIER;
+		return 0;
+
+	case PT3_TUNE_TRACK:
+		*status |= FE_HAS_SIGNAL | FE_HAS_CARRIER | FE_HAS_LOCK;
+		return 0;
+	}
+	BUG();
+}
+
+static int pt3_fe_s_tune(struct dvb_frontend *fe, bool re_tune, unsigned int mode_flags, unsigned int *delay, fe_status_t *status)
+{
+	struct pt3_fe_state *state = fe->demodulator_priv;
+	struct pt3_adapter *adap = state->adap;
+	struct tmcc_s *tmcc = &adap->qm->tmcc;
+	int i, ret,
+	    freq = state->fe.dtv_property_cache.frequency,
+	    tsid = state->fe.dtv_property_cache.stream_id,
+	    ch = (freq < 1024) ? freq : pt3_fe_s_get_channel(freq);	/* consider as channel ID if low */
+
+	if (re_tune)
+		state->tune_state = PT3_TUNE_SET_FREQUENCY;
+
+	switch (state->tune_state) {
+	case PT3_TUNE_IDLE:
+		*delay = 3 * HZ;
+		*status = 0;
+		return 0;
+
+	case PT3_TUNE_SET_FREQUENCY:
+	case PT3_TUNE_CHECK_FREQUENCY:
+		pr_debug("#%d freq %d tsid 0x%x ch %d\n", adap->idx, freq, tsid, ch);
+		ret = qm1d1c0042_set_frequency(adap->qm, ch);
+		if (ret)
+			return ret;
+		adap->channel = ch;
+		state->tune_state = PT3_TUNE_SET_MODULATION;
+		*delay = 0;
+		*status = FE_HAS_SIGNAL;
+		return 0;
+
+	case PT3_TUNE_SET_MODULATION:
+		for (i = 0; i < 1000; i++) {
+			ret = tc90522_read_tmcc(adap, tmcc);
+			if (!ret)
+				break;
+			msleep_interruptible(1);
+		}
+		if (ret) {
+			pr_debug("fail tc_read_tmcc_s ret=0x%x\n", ret);
+			state->tune_state = PT3_TUNE_ABORT;
+			*delay = HZ;
+			return ret;
+		}
+		pr_debug("slots=%d,%d,%d,%d mode=%d,%d,%d,%d\n",
+				tmcc->slot[0], tmcc->slot[1], tmcc->slot[2], tmcc->slot[3],
+				tmcc->mode[0], tmcc->mode[1], tmcc->mode[2], tmcc->mode[3]);
+		state->tune_state = PT3_TUNE_CHECK_MODULATION;
+		*delay = 0;
+		*status = FE_HAS_SIGNAL;
+		return 0;
+
+	case PT3_TUNE_CHECK_MODULATION:
+		pr_debug("tmcc->id=0x%x,0x%x,0x%x,0x%x,0x%x,0x%x,0x%x,0x%x\n",
+				tmcc->id[0], tmcc->id[1], tmcc->id[2], tmcc->id[3],
+				tmcc->id[4], tmcc->id[5], tmcc->id[6], tmcc->id[7]);
+		for (i = 0; i < sizeof(tmcc->id)/sizeof(tmcc->id[0]); i++) {
+			pr_debug("tsid %x i %d tmcc->id %x\n", tsid, i, tmcc->id[i]);
+			if (tmcc->id[i] == tsid)
+				break;
+		}
+		if (tsid < sizeof(tmcc->id)/sizeof(tmcc->id[0]))	/* consider as slot# */
+			i = tsid;
+		if (i == sizeof(tmcc->id)/sizeof(tmcc->id[0])) {
+			pr_debug("#%d i%d tsid 0x%x not found\n", adap->idx, i, tsid);
+			return -EINVAL;
+		}
+		adap->offset = i;
+		pr_debug("#%d found tsid 0x%x on slot %d\n", adap->idx, tsid, i);
+		state->tune_state = PT3_TUNE_SET_TS_ID;
+		*delay = 0;
+		*status = FE_HAS_SIGNAL | FE_HAS_CARRIER;
+		return 0;
+
+	case PT3_TUNE_SET_TS_ID:
+		ret = tc90522_write_id_s(adap, (u16)tmcc->id[adap->offset]);
+		if (ret) {
+			pr_debug("fail set_tmcc_s ret=%d\n", ret);
+			return ret;
+		}
+		state->tune_state = PT3_TUNE_CHECK_TS_ID;
+		return 0;
+
+	case PT3_TUNE_CHECK_TS_ID:
+		for (i = 0; i < 1000; i++) {
+			u16 short_id;
+			ret = tc90522_read_id_s(adap, &short_id);
+			if (ret) {
+				pr_debug("fail get_id_s ret=%d\n", ret);
+				return ret;
+			}
+			tsid = short_id;
+			pr_debug("#%d tsid=0x%x\n", adap->idx, tsid);
+			if ((tsid & 0xffff) == tmcc->id[adap->offset])
+				break;
+			msleep_interruptible(1);
+		}
+		state->tune_state = PT3_TUNE_TRACK;
+
+	case PT3_TUNE_TRACK:
+		*delay = 3 * HZ;
+		*status = FE_HAS_SIGNAL | FE_HAS_CARRIER | FE_HAS_LOCK;
+		return 0;
+
+	case PT3_TUNE_ABORT:
+		*delay = 3 * HZ;
+		*status = FE_HAS_SIGNAL;
+		return 0;
+	}
+	BUG();
+}
+
+static struct dvb_frontend_ops pt3_fe_s_ops = {
+	.delsys = { SYS_ISDBS },
+	.info = {
+		.name = "PT3 ISDB-S",
+		.frequency_min = 1,
+		.frequency_max = 2150000,
+		.frequency_stepsize = 1000,
+		.caps = FE_CAN_INVERSION_AUTO | FE_CAN_FEC_AUTO | FE_CAN_QAM_AUTO | FE_CAN_MULTISTREAM |
+			FE_CAN_TRANSMISSION_MODE_AUTO | FE_CAN_GUARD_INTERVAL_AUTO | FE_CAN_HIERARCHY_AUTO,
+	},
+	.init = pt3_fe_init,
+	.sleep = pt3_fe_sleep,
+	.release = pt3_fe_release,
+	.get_frontend_algo = pt3_fe_get_frontend_algo,
+	.read_signal_strength = pt3_fe_read_signal_strength,
+	.read_status = pt3_fe_s_read_status,
+	.tune = pt3_fe_s_tune,
+};
+
+/**** ISDB-T ****/
+static int pt3_fe_t_get_tmcc(struct pt3_adapter *adap, struct tmcc_t *tmcc)
+{
+	bool b = false, retryov, tmunvld, fulock;
+
+	if (unlikely(!tmcc))
+		return -EINVAL;
+	while (1) {
+		tc90522_read_retryov_tmunvld_fulock(adap, &retryov, &tmunvld, &fulock);
+		if (!fulock) {
+			b = true;
+			break;
+		} else {
+			if (retryov)
+				break;
+		}
+		msleep_interruptible(1);
+	}
+	if (likely(b))
+		tc90522_read_tmcc(adap, tmcc);
+	return b ? 0 : -EBADMSG;
+}
+
+static int pt3_fe_t_read_status(struct dvb_frontend *fe, fe_status_t *status)
+{
+	struct pt3_fe_state *state = fe->demodulator_priv;
+
+	switch (state->tune_state) {
+	case PT3_TUNE_IDLE:
+	case PT3_TUNE_SET_FREQUENCY:
+	case PT3_TUNE_CHECK_FREQUENCY:
+		*status = 0;
+		return 0;
+
+	case PT3_TUNE_SET_MODULATION:
+	case PT3_TUNE_CHECK_MODULATION:
+	case PT3_TUNE_SET_TS_ID:
+	case PT3_TUNE_CHECK_TS_ID:
+	case PT3_TUNE_ABORT:
+		*status |= FE_HAS_SIGNAL;
+		return 0;
+
+	case PT3_TUNE_TRACK:
+		*status |= FE_HAS_SIGNAL | FE_HAS_CARRIER | FE_HAS_LOCK;
+		return 0;
+	}
+	BUG();
+}
+
+static int pt3_fe_t_tune(struct dvb_frontend *fe, bool re_tune, unsigned int mode_flags, unsigned int *delay, fe_status_t *status)
+{
+	struct pt3_fe_state *state = fe->demodulator_priv;
+	struct tmcc_t tmcc_t;
+	int ret, i;
+
+	if (re_tune)
+		state->tune_state = PT3_TUNE_SET_FREQUENCY;
+
+	switch (state->tune_state) {
+	case PT3_TUNE_IDLE:
+		*delay = 3 * HZ;
+		*status = 0;
+		return 0;
+
+	case PT3_TUNE_SET_FREQUENCY:
+		ret = tc90522_set_agc(state->adap, TC90522_AGC_MANUAL);
+		if (ret)
+			return ret;
+		mxl301rf_tuner_rftune(state->adap, mxl301rf_freq(state->fe.dtv_property_cache.frequency));
+		state->tune_state = PT3_TUNE_CHECK_FREQUENCY;
+		*delay = 0;
+		*status = 0;
+		return 0;
+
+	case PT3_TUNE_CHECK_FREQUENCY:
+		if (!mxl301rf_locked(state->adap)) {
+			*delay = HZ;
+			*status = 0;
+			return 0;
+		}
+		state->tune_state = PT3_TUNE_SET_MODULATION;
+		*delay = 0;
+		*status = FE_HAS_SIGNAL;
+		return 0;
+
+	case PT3_TUNE_SET_MODULATION:
+		ret = tc90522_set_agc(state->adap, TC90522_AGC_AUTO);
+		if (ret)
+			return ret;
+		state->tune_state = PT3_TUNE_CHECK_MODULATION;
+		*delay = 0;
+		*status = FE_HAS_SIGNAL;
+		return 0;
+
+	case PT3_TUNE_CHECK_MODULATION:
+	case PT3_TUNE_SET_TS_ID:
+	case PT3_TUNE_CHECK_TS_ID:
+		for (i = 0; i < 1000; i++) {
+			ret = pt3_fe_t_get_tmcc(state->adap, &tmcc_t);
+			if (!ret)
+				break;
+			msleep_interruptible(2);
+		}
+		if (ret) {
+			pr_debug("#%d fail get_tmcc_t ret=%d\n", state->adap->idx, ret);
+				state->tune_state = PT3_TUNE_ABORT;
+				*delay = HZ;
+				return 0;
+		}
+		state->tune_state = PT3_TUNE_TRACK;
+
+	case PT3_TUNE_TRACK:
+		*delay = 3 * HZ;
+		*status = FE_HAS_SIGNAL | FE_HAS_CARRIER | FE_HAS_LOCK;
+		return 0;
+
+	case PT3_TUNE_ABORT:
+		*delay = 3 * HZ;
+		*status = FE_HAS_SIGNAL;
+		return 0;
+	}
+	BUG();
+}
+
+static struct dvb_frontend_ops pt3_fe_t_ops = {
+	.delsys = { SYS_ISDBT },
+	.info = {
+		.name = "PT3 ISDB-T",
+		.frequency_min = 1,
+		.frequency_max = 770000000,
+		.frequency_stepsize = 142857,
+		.caps = FE_CAN_INVERSION_AUTO | FE_CAN_FEC_AUTO | FE_CAN_QAM_AUTO |
+			FE_CAN_TRANSMISSION_MODE_AUTO | FE_CAN_GUARD_INTERVAL_AUTO | FE_CAN_HIERARCHY_AUTO,
+	},
+	.init = pt3_fe_init,
+	.sleep = pt3_fe_sleep,
+	.release = pt3_fe_release,
+	.get_frontend_algo = pt3_fe_get_frontend_algo,
+	.read_signal_strength = pt3_fe_read_signal_strength,
+	.read_status = pt3_fe_t_read_status,
+	.tune = pt3_fe_t_tune,
+};
+
+/**** Common ****/
+struct dvb_frontend *pt3_fe_attach(struct pt3_adapter *adap)
+{
+	struct dvb_frontend *fe;
+	struct pt3_fe_state *state = kzalloc(sizeof(struct pt3_fe_state), GFP_KERNEL);
+
+	if (!state)
+		return NULL;
+	state->adap = adap;
+	fe = &state->fe;
+	memcpy(&fe->ops, (adap->type == SYS_ISDBS) ? &pt3_fe_s_ops : &pt3_fe_t_ops, sizeof(struct dvb_frontend_ops));
+	fe->demodulator_priv = state;
+	return fe;
+}
+
+EXPORT_SYMBOL(pt3_fe_attach);
+
diff --git a/drivers/media/dvb-frontends/pt3_fe.h b/drivers/media/dvb-frontends/pt3_fe.h
new file mode 100644
index 0000000..0d614f3
--- /dev/null
+++ b/drivers/media/dvb-frontends/pt3_fe.h
@@ -0,0 +1,22 @@
+/*
+ * DVB Frontend driver for Earthsoft PT3 ISDB-S/T PCI-E card
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
+#ifndef	__PT3_FE_H__
+#define	__PT3_FE_H__
+
+struct dvb_frontend *pt3_fe_attach(struct pt3_adapter *adap);
+
+#endif
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
index 0000000..519fdaa
--- /dev/null
+++ b/drivers/media/pci/pt3/Kconfig
@@ -0,0 +1,10 @@
+config PT3_DVB
+	tristate "Earthsoft PT3 ISDB-S/T cards"
+	depends on DVB_CORE && PCI
+	select DVB_PT3_FE if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_PT3 if MEDIA_SUBDRV_AUTOSELECT
+	help
+	  Support for Earthsoft PT3 PCI-Express cards.
+	  You may also need to enable PT3 DVB frontend & tuner.
+	  Say Y or M if you own such a device and want to use it.
+
diff --git a/drivers/media/pci/pt3/Makefile b/drivers/media/pci/pt3/Makefile
new file mode 100644
index 0000000..b030927
--- /dev/null
+++ b/drivers/media/pci/pt3/Makefile
@@ -0,0 +1,6 @@
+pt3_dvb-objs := pt3.o pt3_dma.o pt3_i2c.o
+
+obj-$(CONFIG_PT3_DVB) += pt3_dvb.o
+
+ccflags-y += -Idrivers/media/dvb-core -Idrivers/media/dvb-frontends -Idrivers/media/tuners
+
diff --git a/drivers/media/pci/pt3/pt3.c b/drivers/media/pci/pt3/pt3.c
new file mode 100644
index 0000000..d1b1952
--- /dev/null
+++ b/drivers/media/pci/pt3/pt3.c
@@ -0,0 +1,579 @@
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
+#include "pt3_common.h"
+#include "pt3_dma.h"
+#include "pt3_i2c.h"
+#include "tc90522.h"
+#include "qm1d1c0042.h"
+#include "mxl301rf.h"
+#include "pt3_fe.h"
+
+#define DRV_NAME "pt3_dvb"
+
+MODULE_AUTHOR("Budi Rachmanto, AreMa Inc. <knightrider(@)are.ma>");
+MODULE_DESCRIPTION("Earthsoft PT3 DVB Driver");
+MODULE_LICENSE("GPL");
+
+static DEFINE_PCI_DEVICE_TABLE(pt3_id_table) = {
+	{ PCI_DEVICE(0x1172, 0x4c15) },
+	{ },
+};
+MODULE_DEVICE_TABLE(pci, pt3_id_table);
+
+static int lnb = 2;	/* used if not set by frontend or the value is invalid */
+module_param(lnb, int, 0);
+MODULE_PARM_DESC(lnb, "LNB level (0:OFF 1:+11V 2:+15V)");
+
+struct {
+	u32 bits;
+	char *str;
+} pt3_lnb[] = {
+	{0b1100,  "0V"},
+	{0b1101, "11V"},
+	{0b1111, "15V"},
+};
+
+static int pt3_update_lnb(struct pt3_board *pt3)
+{
+	u8 i, lnb_eff = 0;
+
+	if (pt3->reset) {
+		writel(pt3_lnb[0].bits, pt3->bar_reg + REG_SYSTEM_W);
+		pt3->reset = false;
+		pt3->lnb = 0;
+	} else {
+		struct pt3_adapter *adap;
+		mutex_lock(&pt3->lock);
+		for (i = 0; i < PT3_NR_ADAPS; i++) {
+			adap = pt3->adap[i];
+			pr_debug("#%d in_use %d sleep %d\n", adap->idx, adap->in_use, adap->sleep);
+			if ((adap->type == SYS_ISDBS) && (!adap->sleep)) {
+				lnb_eff |= adap->voltage == SEC_VOLTAGE_13 ? 1
+					:  adap->voltage == SEC_VOLTAGE_18 ? 2
+					:  lnb;
+			}
+		}
+		mutex_unlock(&pt3->lock);
+		if (unlikely(lnb_eff < 0 || 2 < lnb_eff)) {
+			pr_err("Inconsistent LNB settings\n");
+			return -EINVAL;
+		}
+		if (pt3->lnb != lnb_eff) {
+			writel(pt3_lnb[lnb_eff].bits, pt3->bar_reg + REG_SYSTEM_W);
+			pt3->lnb = lnb_eff;
+		}
+	}
+	pr_debug("LNB=%s\n", pt3_lnb[lnb_eff].str);
+	return 0;
+}
+
+void pt3_filter(struct pt3_adapter *adap, struct dvb_demux *demux, u8 *buf, size_t count)
+{
+	dvb_dmx_swfilter(demux, buf, count);
+}
+
+int pt3_thread(void *data)
+{
+	size_t ret;
+	struct pt3_adapter *adap = data;
+
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
+static int pt3_start_polling(struct pt3_adapter *adap)
+{
+	int ret = 0;
+
+	mutex_lock(&adap->lock);
+	if (!adap->kthread) {
+		adap->kthread = kthread_run(pt3_thread, adap, DRV_NAME "_%d", adap->idx);
+		if (IS_ERR(adap->kthread)) {
+			ret = PTR_ERR(adap->kthread);
+			adap->kthread = NULL;
+		} else {
+			pt3_dma_set_test_mode(adap->dma, RESET, 0);	/* reset_error_count */
+			pt3_dma_set_enabled(adap->dma, true);
+		}
+	}
+	mutex_unlock(&adap->lock);
+	return ret;
+}
+
+static void pt3_stop_polling(struct pt3_adapter *adap)
+{
+	mutex_lock(&adap->lock);
+	if (adap->kthread) {
+		pt3_dma_set_enabled(adap->dma, false);
+		pr_debug("#%d DMA ts_err packet cnt %d\n",
+			adap->idx, pt3_dma_get_ts_error_packet_count(adap->dma));
+		kthread_stop(adap->kthread);
+		adap->kthread = NULL;
+	}
+	mutex_unlock(&adap->lock);
+}
+
+static int pt3_start_feed(struct dvb_demux_feed *feed)
+{
+	int ret;
+	struct pt3_adapter *adap = container_of(feed->demux, struct pt3_adapter, demux);
+	if (!adap->users++) {
+		if (adap->in_use) {
+			pr_err("#%d device is already used\n", adap->idx);
+			return -EIO;
+		}
+		pr_debug("#%d %s selected, DMA %s\n",
+			adap->idx, adap->str, pt3_dma_get_status(adap->dma) & 1 ? "ON" : "OFF");
+		adap->in_use = true;
+		ret = pt3_start_polling(adap);
+		if (ret)
+			return ret;
+	}
+	return 0;
+}
+
+static int pt3_stop_feed(struct dvb_demux_feed *feed)
+{
+	struct pt3_adapter *adap = container_of(feed->demux, struct pt3_adapter, demux);
+	if (!--adap->users) {
+		pt3_stop_polling(adap);
+		adap->in_use = false;
+		msleep_interruptible(40);
+	}
+	return 0;
+}
+
+DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
+
+static struct pt3_adapter *pt3_alloc_adapter(struct pt3_board *pt3)
+{
+	int ret;
+	struct dvb_adapter *dvb;
+	struct dvb_demux *demux;
+	struct dmxdev *dmxdev;
+	struct pt3_adapter *adap = kzalloc(sizeof(struct pt3_adapter), GFP_KERNEL);
+
+	if (!adap) {
+		ret = -ENOMEM;
+		goto err;
+	}
+	adap->pt3 = pt3;
+	adap->voltage = SEC_VOLTAGE_OFF;
+	adap->sleep = true;
+
+	dvb = &adap->dvb;
+	dvb->priv = adap;
+	ret = dvb_register_adapter(dvb, DRV_NAME, THIS_MODULE, &pt3->pdev->dev, adapter_nr);
+	if (ret < 0)
+		goto err_kfree;
+
+	demux = &adap->demux;
+	demux->dmx.capabilities = DMX_TS_FILTERING | DMX_SECTION_FILTERING;
+	demux->priv = adap;
+	demux->feednum = 256;
+	demux->filternum = 256;
+	demux->start_feed = pt3_start_feed;
+	demux->stop_feed = pt3_stop_feed;
+	demux->write_to_decoder = NULL;
+	ret = dvb_dmx_init(demux);
+	if (ret < 0)
+		goto err_unregister_adapter;
+
+	dmxdev = &adap->dmxdev;
+	dmxdev->filternum = 256;
+	dmxdev->demux = &demux->dmx;
+	dmxdev->capabilities = 0;
+	ret = dvb_dmxdev_init(dmxdev, dvb);
+	if (ret < 0)
+		goto err_dmx_release;
+
+	return adap;
+
+err_dmx_release:
+	dvb_dmx_release(demux);
+err_unregister_adapter:
+	dvb_unregister_adapter(dvb);
+err_kfree:
+	kfree(adap);
+err:
+	return ERR_PTR(ret);
+}
+
+int pt3_set_freq(struct pt3_adapter *adap, u32 ch)
+{
+	int ret;
+
+	pr_debug("#%d %s set_freq channel=%d\n", adap->idx, adap->str, ch);
+
+	if (adap->type == SYS_ISDBS)
+		ret = qm1d1c0042_set_frequency(adap->qm, ch);
+	else
+		ret = mxl301rf_set_frequency(adap, ch, 0);
+	return ret;
+}
+
+int pt3_tuner_set_sleep(struct pt3_adapter *adap, bool sleep)
+{
+	int ret;
+	pr_debug("#%d %p %s %s\n", adap->idx, adap, adap->str, sleep ? "Sleep" : "Wakeup");
+
+	if (adap->type == SYS_ISDBS)
+		ret = qm1d1c0042_set_sleep(adap->qm, sleep);
+	else
+		ret = mxl301rf_set_sleep(adap, sleep);
+	msleep_interruptible(10);
+	return ret;
+}
+
+static void pt3_cleanup_adapter(struct pt3_adapter *adap)
+{
+	if (!adap)
+		return;
+	if (adap->kthread)
+		kthread_stop(adap->kthread);
+	if (adap->fe)
+		dvb_unregister_frontend(adap->fe);
+	if (!adap->sleep)
+		pt3_tuner_set_sleep(adap, true);
+	if (adap->qm)
+		vfree(adap->qm);
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
+static int pt3_set_voltage(struct dvb_frontend *fe, fe_sec_voltage_t voltage)
+{
+	struct pt3_adapter *adap = container_of(fe->dvb, struct pt3_adapter, dvb);
+	adap->voltage = voltage;
+	return (adap->orig_voltage) ? adap->orig_voltage(fe, voltage) : 0;
+}
+
+static int pt3_sleep(struct dvb_frontend *fe)
+{
+	struct pt3_adapter *adap = container_of(fe->dvb, struct pt3_adapter, dvb);
+	adap->sleep = true;
+	pt3_update_lnb(adap->pt3);
+	return (adap->orig_sleep) ? adap->orig_sleep(fe) : 0;
+}
+
+static int pt3_wakeup(struct dvb_frontend *fe)
+{
+	struct pt3_adapter *adap = container_of(fe->dvb, struct pt3_adapter, dvb);
+	adap->sleep = false;
+	pt3_update_lnb(adap->pt3);
+	return (adap->orig_init) ? adap->orig_init(fe) : 0;
+}
+
+static int pt3_init_frontends(struct pt3_board *pt3)
+{
+	struct dvb_frontend *fe[PT3_NR_ADAPS];
+	int i, ret;
+
+	for (i = 0; i < PT3_NR_ADAPS; i++) {
+		fe[i] = pt3_fe_attach(pt3->adap[i]);
+		if (!fe[i]) {
+			while (i--)
+				fe[i]->ops.release(fe[i]);
+			return -ENOMEM;
+		}
+	}
+	for (i = 0; i < PT3_NR_ADAPS; i++) {
+		struct pt3_adapter *adap = pt3->adap[i];
+
+		adap->orig_voltage     = fe[i]->ops.set_voltage;
+		adap->orig_sleep       = fe[i]->ops.sleep;
+		adap->orig_init        = fe[i]->ops.init;
+		fe[i]->ops.set_voltage = pt3_set_voltage;
+		fe[i]->ops.sleep       = pt3_sleep;
+		fe[i]->ops.init        = pt3_wakeup;
+
+		ret = dvb_register_frontend(&adap->dvb, fe[i]);
+		if (ret >= 0)
+			adap->fe = fe[i];
+		else {
+			while (i--)
+				dvb_unregister_frontend(fe[i]);
+			for (i = 0; i < PT3_NR_ADAPS; i++)
+				fe[i]->ops.release(fe[i]);
+			return ret;
+		}
+	}
+	return 0;
+}
+
+static void pt3_remove(struct pci_dev *pdev)
+{
+	int i;
+	struct pt3_board *pt3 = pci_get_drvdata(pdev);
+
+	if (pt3) {
+		pt3->reset = true;
+		pt3_update_lnb(pt3);
+		if (pt3->adap && pt3->adap[PT3_NR_ADAPS-1])
+			tc90522_set_powers(pt3->adap[PT3_NR_ADAPS-1], false, false);
+		for (i = 0; i < PT3_NR_ADAPS; i++)
+			pt3_cleanup_adapter(pt3->adap[i]);
+		pt3_i2c_reset(pt3);
+		i2c_del_adapter(&pt3->i2c);
+		if (pt3->bar_mem)
+			iounmap(pt3->bar_mem);
+		if (pt3->bar_reg)
+			iounmap(pt3->bar_reg);
+		pci_release_selected_regions(pdev, pt3->bars);
+		kfree(pt3);
+	}
+	pci_disable_device(pdev);
+}
+
+static int pt3_abort(struct pci_dev *pdev, int ret, char *fmt, ...)
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
+		dev_alert(&pdev->dev, "%s", s);
+		vfree(s);
+	}
+	va_end(ap);
+	pt3_remove(pdev);
+	return ret;
+}
+
+struct {
+	fe_delivery_system_t type;
+	u8 addr_tuner, addr_demod;
+	int init_ch;
+	char *str;
+} pt3_config[] = {
+	{SYS_ISDBS, 0x63, 0b00010001,  0, "ISDB-S"},
+	{SYS_ISDBS, 0x60, 0b00010011,  0, "ISDB-S"},
+	{SYS_ISDBT, 0x62, 0b00010000, 70, "ISDB-T"},
+	{SYS_ISDBT, 0x61, 0b00010010, 71, "ISDB-T"},
+};
+
+int pt3_tuner_init(struct pt3_adapter *adap)
+{
+	qm1d1c0042_tuner_init(adap->qm);
+	adap->pt3->i2c_addr = 0;
+	if (pt3_i2c_flush(adap->pt3, true, 0))
+		return -EIO;
+
+	if (qm1d1c0042_tuner_init(adap->qm))
+		return -EIO;
+	adap->pt3->i2c_addr = 0;
+	if (pt3_i2c_flush(adap->pt3, true, 0))
+		return -EIO;
+	return 0;
+}
+
+static int pt3_tuner_init_all(struct pt3_board *pt3)
+{
+	int ret, i, j;
+	struct pt3_ts_pins_mode pins;
+
+	if (!pt3_i2c_is_clean(pt3)) {
+		pr_debug("cleanup I2C\n");
+		ret = pt3_i2c_flush(pt3, false, 0);
+		if (ret)
+			goto last;
+		msleep_interruptible(10);
+	}
+	for (i = 0; i < PT3_NR_ADAPS; i++) {
+		ret = tc90522_init(pt3->adap[i]);
+		pr_debug("#%d tc_init ret=%d\n", i, ret);
+	}
+	ret = tc90522_set_powers(pt3->adap[PT3_NR_ADAPS-1], true, false);
+	if (ret) {
+		pr_debug("fail set powers.\n");
+		goto last;
+	}
+
+	pins.clock_data = PT3_TS_PIN_MODE_NORMAL;
+	pins.byte       = PT3_TS_PIN_MODE_NORMAL;
+	pins.valid      = PT3_TS_PIN_MODE_NORMAL;
+	for (i = 0; i < PT3_NR_ADAPS; i++) {
+		ret = tc90522_set_ts_pins_mode(pt3->adap[i], &pins);
+		if (ret)
+			pr_debug("#%d %s fail set ts pins mode ret=%d\n", i, pt3->adap[i]->str, ret);
+	}
+	msleep_interruptible(1);
+
+	for (i = 0; i < PT3_NR_ADAPS; i++)
+		if (pt3->adap[i]->type == SYS_ISDBS) {
+			for (j = 0; j < 10; j++) {
+				if (j)
+					pr_debug("retry pt3_tuner_init\n");
+				ret = pt3_tuner_init(pt3->adap[i]);
+				if (!ret)
+					break;
+				msleep_interruptible(1);
+			}
+			if (ret) {
+				pr_debug("#%d fail pt3_tuner_init ret=0x%x\n", i, ret);
+				goto last;
+			}
+		}
+	ret = pt3_i2c_flush(pt3, false, PT3_I2C_START_ADDR);
+	if (ret)
+		goto last;
+	ret = tc90522_set_powers(pt3->adap[PT3_NR_ADAPS-1], true, true);
+	if (ret) {
+		pr_debug("fail tc_set_powers,\n");
+		goto last;
+	}
+	for (i = 0; i < PT3_NR_ADAPS; i++) {
+		struct pt3_adapter *adap = pt3->adap[i];
+		ret = pt3_tuner_set_sleep(adap, false);
+		if (ret)
+			goto last;
+		ret = pt3_set_freq(adap, adap->init_ch);
+		if (ret)
+			pr_debug("fail set_frequency, ret=%d\n", ret);
+		ret = pt3_tuner_set_sleep(adap, true);
+		if (ret)
+			goto last;
+	}
+last:
+	return ret;
+}
+
+static const struct i2c_algorithm pt3_i2c_algo = {
+	.functionality = pt3_i2c_func,
+	.master_xfer = pt3_i2c_xfer,
+};
+
+static int pt3_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
+{
+	struct pt3_board *pt3;
+	struct pt3_adapter *adap;
+	struct i2c_adapter *i2c;
+	int i, ret, bars = pci_select_bars(pdev, IORESOURCE_MEM);
+
+	ret = pci_enable_device(pdev);
+	if (ret < 0)
+		return pt3_abort(pdev, ret, "PCI device unusable\n");
+	ret = pci_set_dma_mask(pdev, DMA_BIT_MASK(64));
+	if (ret)
+		return pt3_abort(pdev, ret, "DMA mask error\n");
+	pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
+
+	pci_read_config_dword(pdev, PCI_CLASS_REVISION, &i);
+	if ((i & 0xFF) != 1)
+		return pt3_abort(pdev, ret, "Revision 0x%x is not supported\n", i & 0xFF);
+	ret = pci_request_selected_regions(pdev, bars, DRV_NAME);
+	if (ret < 0)
+		return pt3_abort(pdev, ret, "Could not request regions\n");
+
+	pci_set_master(pdev);
+	ret = pci_save_state(pdev);
+	if (ret)
+		return pt3_abort(pdev, ret, "Failed pci_save_state\n");
+	pt3 = kzalloc(sizeof(struct pt3_board), GFP_KERNEL);
+	if (!pt3)
+		return pt3_abort(pdev, -ENOMEM, "struct pt3_board out of memory\n");
+
+	pt3->bars = bars;
+	pt3->pdev = pdev;
+	pci_set_drvdata(pdev, pt3);
+	pt3->bar_reg = pci_ioremap_bar(pdev, 0);
+	pt3->bar_mem = pci_ioremap_bar(pdev, 2);
+	if (!pt3->bar_reg || !pt3->bar_mem)
+		return pt3_abort(pdev, -EIO, "Failed pci_ioremap_bar\n");
+
+	ret = readl(pt3->bar_reg + REG_VERSION);
+	i = ((ret >> 24) & 0xFF);
+	if (i != 3)
+		return pt3_abort(pdev, -EIO, "ID=0x%x, not a PT3\n", i);
+	i = ((ret >>  8) & 0xFF);
+	if (i != 4)
+		return pt3_abort(pdev, -EIO, "FPGA version 0x%x is not supported\n", i);
+	mutex_init(&pt3->lock);
+
+	for (i = 0; i < PT3_NR_ADAPS; i++) {
+		pt3->adap[i] = NULL;
+		adap = pt3_alloc_adapter(pt3);
+		if (IS_ERR(adap))
+			return pt3_abort(pdev, PTR_ERR(adap), "Failed pt3_alloc_adapter\n");
+		adap->idx = i;
+		adap->dma = pt3_dma_create(adap);
+		if (!adap->dma)
+			return pt3_abort(pdev, -ENOMEM, "Failed pt3_dma_create\n");
+		mutex_init(&adap->lock);
+		pt3->adap[i] = adap;
+		adap->type       = pt3_config[i].type;
+		adap->addr_tuner = pt3_config[i].addr_tuner;
+		adap->addr_demod    = pt3_config[i].addr_demod;
+		adap->init_ch    = pt3_config[i].init_ch;
+		adap->str        = pt3_config[i].str;
+		if (adap->type == SYS_ISDBS) {
+			adap->qm = vzalloc(sizeof(struct qm1d1c0042));
+			if (!adap->qm)
+				return pt3_abort(pdev, -ENOMEM, "QM out of memory\n");
+			adap->qm->adap = adap;
+		}
+		adap->sleep = true;
+	}
+	pt3->reset = true;
+	pt3_update_lnb(pt3);
+
+	i2c = &pt3->i2c;
+	i2c->algo = &pt3_i2c_algo;
+	i2c->algo_data = NULL;
+	i2c->dev.parent = &pdev->dev;
+	strcpy(i2c->name, DRV_NAME);
+	i2c_set_adapdata(i2c, pt3);
+	ret = i2c_add_adapter(i2c);
+	if (ret < 0)
+		return pt3_abort(pdev, ret, "Cannot add I2C\n");
+
+	if (pt3_tuner_init_all(pt3))
+		return pt3_abort(pdev, ret, "Failed pt3_tuner_init_all\n");
+	ret = pt3_init_frontends(pt3);
+	return (ret >= 0) ? ret : pt3_abort(pdev, ret, "Failed pt3_init_frontends\n");
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
diff --git a/drivers/media/pci/pt3/pt3.h b/drivers/media/pci/pt3/pt3.h
new file mode 100644
index 0000000..057d1b4
--- /dev/null
+++ b/drivers/media/pci/pt3/pt3.h
@@ -0,0 +1,23 @@
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
+#ifndef	__PT3_H__
+#define	__PT3_H__
+
+void pt3_filter(struct pt3_adapter *adap, struct dvb_demux *demux, u8 *buf, size_t count);
+
+#endif
+
diff --git a/drivers/media/pci/pt3/pt3_dma.c b/drivers/media/pci/pt3/pt3_dma.c
new file mode 100644
index 0000000..33b1a2e
--- /dev/null
+++ b/drivers/media/pci/pt3/pt3_dma.c
@@ -0,0 +1,335 @@
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
+#include "pt3_common.h"
+#include "pt3_dma.h"
+#include "pt3.h"
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
+	pr_debug("#%d build page descriptor ts_count=%d ts_size=%d desc_count=%d desc_size=%d\n",
+		dma->adap->idx, dma->ts_count, dma->ts_info[0].size, dma->desc_count, dma->desc_info[0].size);
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
+	return dma->adap->pt3->bar_reg + REG_BASE + (0x18 * dma->adap->idx);
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
+		writel(1 << 1, base + REG_DMA_CTL);	/* stop DMA */
+		writel(PT3_SHIFT_MASK(start_addr,  0, 32), base + REG_DMA_DESC_L);
+		writel(PT3_SHIFT_MASK(start_addr, 32, 32), base + REG_DMA_DESC_H);
+		pr_debug("set descriptor address low %llx\n",  PT3_SHIFT_MASK(start_addr,  0, 32));
+		pr_debug("set descriptor address high %llx\n", PT3_SHIFT_MASK(start_addr, 32, 32));
+		writel(1 << 0, base + REG_DMA_CTL);	/* start DMA */
+	} else {
+		pr_debug("#%d DMA disable\n", dma->adap->idx);
+		writel(1 << 1, base + REG_DMA_CTL);	/* stop DMA */
+		while (1) {
+			if (!PT3_SHIFT_MASK(readl(base + REG_STATUS), 0, 1))
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
+			k = k ^ PT3_SHIFT_MASK(gray, j, 1);
+		binary |= k << i;
+	}
+	return binary;
+}
+
+u32 pt3_dma_get_ts_error_packet_count(struct pt3_dma *dma)
+{
+	return pt3_dma_gray2binary(readl(pt3_dma_get_base_addr(dma) + REG_TS_ERR), 32);
+}
+
+void pt3_dma_set_test_mode(struct pt3_dma *dma, enum pt3_dma_mode mode, u16 initval)
+{
+	void __iomem *base = pt3_dma_get_base_addr(dma);
+	u32 data = mode | initval;
+	pr_debug("set_test_mode base=%p data=0x%04x\n", base, data);
+	writel(data, base + REG_TS_CTL);
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
+			pt3_filter(dma->adap, demux, &ts->data[ts->data_pos], csize);
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
+	return readl(pt3_dma_get_base_addr(dma) + REG_STATUS);
+}
+
diff --git a/drivers/media/pci/pt3/pt3_dma.h b/drivers/media/pci/pt3/pt3_dma.h
new file mode 100644
index 0000000..ecae4c1
--- /dev/null
+++ b/drivers/media/pci/pt3/pt3_dma.h
@@ -0,0 +1,48 @@
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
index 0000000..7f0eb7c
--- /dev/null
+++ b/drivers/media/pci/pt3/pt3_i2c.c
@@ -0,0 +1,167 @@
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
+#include "pt3_common.h"
+#include "pt3_i2c.h"
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
+	return PT3_SHIFT_MASK(readl(pt3->bar_reg + REG_I2C_R), 3, 1);
+}
+
+void pt3_i2c_reset(struct pt3_board *pt3)
+{
+	writel(1 << 17, pt3->bar_reg + REG_I2C_W);	/* 0x00020000 */
+}
+
+void pt3_i2c_wait(struct pt3_board *pt3, u32 *status)
+{
+	u32 val;
+
+	while (1) {
+		val = readl(pt3->bar_reg + REG_I2C_R);
+		if (!PT3_SHIFT_MASK(val, 0, 1))		/* sequence stopped */
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
+			pt3_i2c_mem_write(pt3, PT3_SHIFT_MASK(byte, 7 - j, 1) ? I_DATA_H_NOP : I_DATA_L_NOP);
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
+	writel(1 << 16 | start_addr, pt3->bar_reg + REG_I2C_W);	/* 0x00010000 start sequence */
+	pt3_i2c_wait(pt3, &status);
+	if (PT3_SHIFT_MASK(status, 1, 2)) {			/* ACK status */
+		pr_err("%s failed, status=0x%x\n", __func__, status);
+		return -EIO;
+	}
+	return 0;
+}
+
+u32 pt3_i2c_func(struct i2c_adapter *adap)
+{
+	return I2C_FUNC_I2C;
+}
+
+int pt3_i2c_xfer(struct i2c_adapter *i2c, struct i2c_msg *msg, int num)
+{
+	struct pt3_board *pt3 = i2c_get_adapdata(i2c);
+	int i, j;
+
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
+		return -EIO;
+	for (i = 1; i < num; i++)
+		if (msg[i].flags == I2C_M_RD)
+			for (j = 0; j < msg[i].len; j++)
+				msg[i].buf[j] = readb(pt3->bar_mem + PT3_I2C_DATA_OFFSET + j);
+	mutex_unlock(&pt3->lock);
+	return num;
+}
+
diff --git a/drivers/media/pci/pt3/pt3_i2c.h b/drivers/media/pci/pt3/pt3_i2c.h
new file mode 100644
index 0000000..5e61f17
--- /dev/null
+++ b/drivers/media/pci/pt3/pt3_i2c.h
@@ -0,0 +1,29 @@
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
+#define PT3_I2C_DATA_OFFSET	2048
+#define PT3_I2C_START_ADDR	0x17fa
+
+int pt3_i2c_flush(struct pt3_board *pt3, bool end, u32 start_addr);
+bool pt3_i2c_is_clean(struct pt3_board *pt3);
+void pt3_i2c_reset(struct pt3_board *pt3);
+u32 pt3_i2c_func(struct i2c_adapter *adap);
+int pt3_i2c_xfer(struct i2c_adapter *i2c, struct i2c_msg *msg, int num);
+
+#endif
diff --git a/drivers/media/tuners/Kconfig b/drivers/media/tuners/Kconfig
index 15665de..999e70c 100644
--- a/drivers/media/tuners/Kconfig
+++ b/drivers/media/tuners/Kconfig
@@ -235,4 +235,11 @@ config MEDIA_TUNER_R820T
 	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Rafael Micro R820T silicon tuner driver.
+
+config MEDIA_TUNER_PT3
+	tristate "Demodulator/Tuners for Earthsoft PT3 ISDB-S/T"
+	depends on MEDIA_SUPPORT && I2C
+	default m if !MEDIA_SUBDRV_AUTOSELECT
+	help
+	  Earthsoft PT3 demodulator/tuner driver: ISDB-S QM1D1C0042, ISDB-T MxL301RF, TC90522
 endmenu
diff --git a/drivers/media/tuners/Makefile b/drivers/media/tuners/Makefile
index 308f108..de6a87e 100644
--- a/drivers/media/tuners/Makefile
+++ b/drivers/media/tuners/Makefile
@@ -3,6 +3,7 @@
 #
 
 tda18271-objs := tda18271-maps.o tda18271-common.o tda18271-fe.o
+pt3_tuner-objs := mxl301rf.o qm1d1c0042.o tc90522.o
 
 obj-$(CONFIG_MEDIA_TUNER_XC2028) += tuner-xc2028.o
 obj-$(CONFIG_MEDIA_TUNER_SIMPLE) += tuner-simple.o
@@ -36,6 +37,7 @@ obj-$(CONFIG_MEDIA_TUNER_FC0012) += fc0012.o
 obj-$(CONFIG_MEDIA_TUNER_FC0013) += fc0013.o
 obj-$(CONFIG_MEDIA_TUNER_IT913X) += tuner_it913x.o
 obj-$(CONFIG_MEDIA_TUNER_R820T) += r820t.o
+obj-$(CONFIG_MEDIA_TUNER_PT3) += pt3_tuner.o
 
 ccflags-y += -I$(srctree)/drivers/media/dvb-core
 ccflags-y += -I$(srctree)/drivers/media/dvb-frontends
diff --git a/drivers/media/tuners/mxl301rf.c b/drivers/media/tuners/mxl301rf.c
new file mode 100644
index 0000000..8ecf263
--- /dev/null
+++ b/drivers/media/tuners/mxl301rf.c
@@ -0,0 +1,347 @@
+/*
+ * MxL301RF MaxLinear CMOS Hybrid TV ISDB-T tuner driver for Earthsoft PT3
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
+#include "pt3_common.h"
+#include "tc90522.h"
+
+MODULE_AUTHOR("Budi Rachmanto, AreMa Inc. <knightrider(@)are.ma>");
+MODULE_DESCRIPTION("Earthsoft PT3 MxL301RF MaxLinear CMOS Hybrid TV ISDB-T tuner driver");
+MODULE_LICENSE("GPL");
+
+static struct {
+	u32	freq,		/* Channel center frequency @ kHz	*/
+		freq_th;	/* Offset frequency threshold @ kHz	*/
+	u8	shf_val,	/* Spur shift value			*/
+		shf_dir;	/* Spur shift direction			*/
+} SHF_DVBT_TAB[] = {
+	{  64500, 500, 0x92, 0x07 },
+	{ 191500, 300, 0xE2, 0x07 },
+	{ 205500, 500, 0x2C, 0x04 },
+	{ 212500, 500, 0x1E, 0x04 },
+	{ 226500, 500, 0xD4, 0x07 },
+	{  99143, 500, 0x9C, 0x07 },
+	{ 173143, 500, 0xD4, 0x07 },
+	{ 191143, 300, 0xD4, 0x07 },
+	{ 207143, 500, 0xCE, 0x07 },
+	{ 225143, 500, 0xCE, 0x07 },
+	{ 243143, 500, 0xD4, 0x07 },
+	{ 261143, 500, 0xD4, 0x07 },
+	{ 291143, 500, 0xD4, 0x07 },
+	{ 339143, 500, 0x2C, 0x04 },
+	{ 117143, 500, 0x7A, 0x07 },
+	{ 135143, 300, 0x7A, 0x07 },
+	{ 153143, 500, 0x01, 0x07 }
+};
+
+static void mxl301rf_rftune(u8 *data, u32 *size, u32 freq)
+{
+	u32 dig_rf_freq, tmp, frac_divider, kHz, MHz, i;
+	u8 rf_data[] = {
+		0x13, 0x00,	/* abort tune			*/
+		0x3B, 0xC0,
+		0x3B, 0x80,
+		0x10, 0x95,	/* BW				*/
+		0x1A, 0x05,
+		0x61, 0x00,
+		0x62, 0xA0,
+		0x11, 0x40,	/* 2 bytes to store RF freq.	*/
+		0x12, 0x0E,	/* 2 bytes to store RF freq.	*/
+		0x13, 0x01	/* start tune			*/
+	};
+
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
+	for (i = 0; i < sizeof(SHF_DVBT_TAB)/sizeof(*SHF_DVBT_TAB); i++) {
+		if ((freq >= (SHF_DVBT_TAB[i].freq - SHF_DVBT_TAB[i].freq_th) * kHz) &&
+				(freq <= (SHF_DVBT_TAB[i].freq + SHF_DVBT_TAB[i].freq_th) * kHz)) {
+			rf_data[2 * (5) + 1] = SHF_DVBT_TAB[i].shf_val;
+			rf_data[2 * (6) + 1] = 0xa0 | SHF_DVBT_TAB[i].shf_dir;
+			break;
+		}
+	}
+	memcpy(data, rf_data, sizeof(rf_data));
+	*size = sizeof(rf_data);
+
+	pr_debug("mx_rftune freq=%d\n", freq);
+}
+
+/* write via demodulator */
+static void mxl301rf_write(struct pt3_adapter *adap, u8 *data, size_t size)
+{
+	tc90522_write_tuner_without_addr(adap, data, size);
+}
+
+static void mxl301rf_standby(struct pt3_adapter *adap)
+{
+	u8 data[4] = {0x01, 0x00, 0x13, 0x00};
+	mxl301rf_write(adap, data, sizeof(data));
+}
+
+static void mxl301rf_set_register(struct pt3_adapter *adap, u8 addr, u8 value)
+{
+	u8 data[2] = {addr, value};
+	mxl301rf_write(adap, data, sizeof(data));
+}
+
+static void mxl301rf_idac_setting(struct pt3_adapter *adap)
+{
+	u8 data[] = {
+		0x0D, 0x00,
+		0x0C, 0x67,
+		0x6F, 0x89,
+		0x70, 0x0C,
+		0x6F, 0x8A,
+		0x70, 0x0E,
+		0x6F, 0x8B,
+		0x70, 0x10+12,
+	};
+	mxl301rf_write(adap, data, sizeof(data));
+}
+
+void mxl301rf_tuner_rftune(struct pt3_adapter *adap, u32 freq)
+{
+	u8 data[100];
+	u32 size;
+
+	size = 0;
+	adap->freq = freq;
+	mxl301rf_rftune(data, &size, freq);
+	if (size != 20) {
+		pr_debug("fail mx_rftune size = %d\n", size);
+		return;
+	}
+	mxl301rf_write(adap, data, 14);
+	msleep_interruptible(1);
+	mxl301rf_write(adap, data + 14, 6);
+	msleep_interruptible(1);
+	mxl301rf_set_register(adap, 0x1a, 0x0d);
+	mxl301rf_idac_setting(adap);
+}
+
+static void mxl301rf_wakeup(struct pt3_adapter *adap)
+{
+	u8 data[2] = {0x01, 0x01};
+
+	mxl301rf_write(adap, data, sizeof(data));
+	mxl301rf_tuner_rftune(adap, adap->freq);
+}
+
+static void mxl301rf_set_sleep_mode(struct pt3_adapter *adap, bool sleep)
+{
+	if (sleep)
+		mxl301rf_standby(adap);
+	else
+		mxl301rf_wakeup(adap);
+}
+
+int mxl301rf_set_sleep(struct pt3_adapter *adap, bool sleep)
+{
+	int ret;
+
+	if (sleep) {
+		ret = tc90522_set_agc(adap, TC90522_AGC_MANUAL);
+		if (ret)
+			return ret;
+		mxl301rf_set_sleep_mode(adap, sleep);
+		tc90522_write_sleep_time(adap, sleep);
+	} else {
+		tc90522_write_sleep_time(adap, sleep);
+		mxl301rf_set_sleep_mode(adap, sleep);
+	}
+	adap->sleep = sleep;
+	return 0;
+}
+
+static u8 MXL301RF_FREQ_TABLE[][3] = {
+	{   2, 0,  3 },
+	{  12, 1, 22 },
+	{  21, 0, 12 },
+	{  62, 1, 63 },
+	{ 112, 0, 62 }
+};
+
+void mxl301rf_get_channel_frequency(struct pt3_adapter *adap, u32 channel, bool *catv, u32 *number, u32 *freq)
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
+	for (i = 0; i < sizeof(MXL301RF_FREQ_TABLE) / sizeof(*MXL301RF_FREQ_TABLE); i++) {
+		if (channel <= MXL301RF_FREQ_TABLE[i][0]) {
+			*catv = MXL301RF_FREQ_TABLE[i][1] ? true : false;
+			*number = channel + MXL301RF_FREQ_TABLE[i][2] - MXL301RF_FREQ_TABLE[i][0];
+			break;
+		}
+	}
+}
+
+static u32 MXL301RF_RF_TABLE[112] = {
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
+
+/* read via demodulator */
+static void mxl301rf_read(struct pt3_adapter *adap, u8 addr, u8 *data)
+{
+	u8 write[2] = {0xfb, addr};
+
+	tc90522_write_tuner_without_addr(adap, write, sizeof(write));
+	tc90522_read_tuner_without_addr(adap, data);
+}
+
+static void mxl301rf_rfsynth_lock_status(struct pt3_adapter *adap, bool *locked)
+{
+	u8 data;
+
+	*locked = false;
+	mxl301rf_read(adap, 0x16, &data);
+	data &= 0x0c;
+	if (data == 0x0c)
+		*locked = true;
+}
+
+static void mxl301rf_refsynth_lock_status(struct pt3_adapter *adap, bool *locked)
+{
+	u8 data;
+
+	*locked = false;
+	mxl301rf_read(adap, 0x16, &data);
+	data &= 0x03;
+	if (data == 0x03)
+		*locked = true;
+}
+
+bool mxl301rf_locked(struct pt3_adapter *adap)
+{
+	bool locked1 = false, locked2 = false;
+	struct timeval begin, now;
+
+	do_gettimeofday(&begin);
+	while (1) {
+		do_gettimeofday(&now);
+		mxl301rf_rfsynth_lock_status(adap, &locked1);
+		mxl301rf_refsynth_lock_status(adap, &locked2);
+		if (locked1 && locked2)
+			break;
+		if (tc90522_time_diff(&begin, &now) > 1000)
+			break;
+		msleep_interruptible(1);
+	}
+	pr_debug("#%d mx locked1=%d locked2=%d\n", adap->idx, locked1, locked2);
+	return locked1 && locked2;
+}
+
+int mxl301rf_set_frequency(struct pt3_adapter *adap, u32 channel, s32 offset)
+{
+	bool catv;
+	u32 number, freq, real_freq;
+	int ret = tc90522_set_agc(adap, TC90522_AGC_MANUAL);
+
+	if (ret)
+		return ret;
+	mxl301rf_get_channel_frequency(adap, channel, &catv, &number, &freq);
+	pr_debug("#%d ch%d%s no%d %dHz\n", adap->idx, channel, catv ? " CATV" : "", number, freq);
+	/* real_freq = (7 * freq + 1 + offset) * 1000000.0/7.0; */
+	real_freq = MXL301RF_RF_TABLE[channel];
+
+	mxl301rf_tuner_rftune(adap, real_freq);
+
+	return (!mxl301rf_locked(adap)) ? -ETIMEDOUT : tc90522_set_agc(adap, TC90522_AGC_AUTO);
+}
+
+#define MXL301RF_NHK (MXL301RF_RF_TABLE[77])
+int mxl301rf_freq(int freq)
+{
+	if (freq >= 90000000)
+		return freq;					/* real_freq	*/
+	if (freq > 255)
+		return MXL301RF_NHK;
+	if (freq > 127)
+		return MXL301RF_RF_TABLE[freq - 128];		/* freqno (IO#)	*/
+	if (freq > 63) {					/* CATV		*/
+		freq -= 64;
+		if (freq > 22)
+			return MXL301RF_RF_TABLE[freq - 1];	/* C23-C62	*/
+		if (freq > 12)
+			return MXL301RF_RF_TABLE[freq - 10];	/* C13-C22	*/
+		return MXL301RF_NHK;
+	}
+	if (freq > 62)
+		return MXL301RF_NHK;
+	if (freq > 12)
+		return MXL301RF_RF_TABLE[freq + 50];		/* 13-62	*/
+	if (freq >  3)
+		return MXL301RF_RF_TABLE[freq +  9];		/*  4-12	*/
+	if (freq)
+		return MXL301RF_RF_TABLE[freq -  1];		/*  1-3		*/
+	return MXL301RF_NHK;
+}
+
+EXPORT_SYMBOL(mxl301rf_set_frequency);
+EXPORT_SYMBOL(mxl301rf_set_sleep);
+EXPORT_SYMBOL(mxl301rf_freq);
+EXPORT_SYMBOL(mxl301rf_tuner_rftune);
+EXPORT_SYMBOL(mxl301rf_locked);
+
diff --git a/drivers/media/tuners/mxl301rf.h b/drivers/media/tuners/mxl301rf.h
new file mode 100644
index 0000000..a025494
--- /dev/null
+++ b/drivers/media/tuners/mxl301rf.h
@@ -0,0 +1,27 @@
+/*
+ * MxL301RF MaxLinear CMOS Hybrid TV ISDB-T tuner driver for Earthsoft PT3
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
+#ifndef __MXL301RF_H__
+#define __MXL301RF_H__
+
+int mxl301rf_set_frequency(struct pt3_adapter *adap, u32 channel, s32 offset);
+int mxl301rf_set_sleep(struct pt3_adapter *adap, bool sleep);
+int mxl301rf_freq(int freq);
+void mxl301rf_tuner_rftune(struct pt3_adapter *adap, u32 freq);
+bool mxl301rf_locked(struct pt3_adapter *adap);
+
+#endif
+
diff --git a/drivers/media/tuners/qm1d1c0042.c b/drivers/media/tuners/qm1d1c0042.c
new file mode 100644
index 0000000..eb7c869
--- /dev/null
+++ b/drivers/media/tuners/qm1d1c0042.c
@@ -0,0 +1,413 @@
+/*
+ * QM1D1C0042 ISDB-S tuner driver for Earthsoft PT3
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
+#include "pt3_common.h"
+#include "tc90522.h"
+#include "qm1d1c0042.h"
+
+MODULE_AUTHOR("Budi Rachmanto, AreMa Inc. <knightrider(@)are.ma>");
+MODULE_DESCRIPTION("Earthsoft PT3 QM1D1C0042 ISDB-S tuner driver");
+MODULE_LICENSE("GPL");
+
+static u8 qm1d1c0042_reg_rw[] = {
+	0x48, 0x1c, 0xa0, 0x10, 0xbc, 0xc5, 0x20, 0x33,
+	0x06, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00,
+	0x00, 0xff, 0xf3, 0x00, 0x2a, 0x64, 0xa6, 0x86,
+	0x8c, 0xcf, 0xb8, 0xf1, 0xa8, 0xf2, 0x89, 0x00,
+};
+
+void qm1d1c0042_init_reg_param(struct qm1d1c0042 *qm)
+{
+	memcpy(qm->reg, qm1d1c0042_reg_rw, sizeof(qm1d1c0042_reg_rw));
+
+	qm->adap->freq = 0;
+	qm->standby = false;
+	qm->wait_time_lpf = 20;
+	qm->wait_time_search_fast = 4;
+	qm->wait_time_search_normal = 15;
+}
+
+/* read via demodulator */
+static int qm1d1c0042_read(struct qm1d1c0042 *qm, u8 addr, u8 *data)
+{
+	int ret = 0;
+	if ((addr == 0x00) || (addr == 0x0d))
+		ret = tc90522_read_tuner(qm->adap, addr, data);
+	return ret;
+}
+
+/* write via demodulator */
+static int qm1d1c0042_write(struct qm1d1c0042 *qm, u8 addr, u8 data)
+{
+	int ret = tc90522_write_tuner(qm->adap, addr, &data, sizeof(data));
+	qm->reg[addr] = data;
+	return ret;
+}
+
+#define QM1D1C0042_INIT_DUMMY_RESET 0x0c
+
+void qm1d1c0042_dummy_reset(struct qm1d1c0042 *qm)
+{
+	qm1d1c0042_write(qm, 0x01, QM1D1C0042_INIT_DUMMY_RESET);
+	qm1d1c0042_write(qm, 0x01, QM1D1C0042_INIT_DUMMY_RESET);
+}
+
+static u8 qm1d1c0042_flag[32] = {
+	0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0,
+	0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
+};
+
+static int qm1d1c0042_set_sleep_mode(struct qm1d1c0042 *qm)
+{
+	int ret;
+
+	if (qm->standby) {
+		qm->reg[0x01] &= (~(1 << 3)) & 0xff;
+		qm->reg[0x01] |= 1 << 0;
+		qm->reg[0x05] |= 1 << 3;
+
+		ret = qm1d1c0042_write(qm, 0x05, qm->reg[0x05]);
+		if (ret)
+			return ret;
+		ret = qm1d1c0042_write(qm, 0x01, qm->reg[0x01]);
+		if (ret)
+			return ret;
+	} else {
+		qm->reg[0x01] |= 1 << 3;
+		qm->reg[0x01] &= (~(1 << 0)) & 0xff;
+		qm->reg[0x05] &= (~(1 << 3)) & 0xff;
+
+		ret = qm1d1c0042_write(qm, 0x01, qm->reg[0x01]);
+		if (ret)
+			return ret;
+		ret = qm1d1c0042_write(qm, 0x05, qm->reg[0x05]);
+		if (ret)
+			return ret;
+	}
+	return ret;
+}
+
+static int qm1d1c0042_set_search_mode(struct qm1d1c0042 *qm)
+{
+	qm->reg[3] &= 0xfe;
+	return qm1d1c0042_write(qm, 0x03, qm->reg[3]);
+}
+
+int qm1d1c0042_init(struct qm1d1c0042 *qm)
+{
+	u8 i_data;
+	u32 i;
+	int ret;
+
+	/* soft reset on */
+	ret = qm1d1c0042_write(qm, 0x01, QM1D1C0042_INIT_DUMMY_RESET);
+	if (ret)
+		return ret;
+
+	msleep_interruptible(1);
+
+	/* soft reset off */
+	i_data = qm->reg[0x01] | 0x10;
+	ret = qm1d1c0042_write(qm, 0x01, i_data);
+	if (ret)
+		return ret;
+
+	/* ID check */
+	ret = qm1d1c0042_read(qm, 0x00, &i_data);
+	if (ret)
+		return ret;
+	if (i_data != 0x48)
+		return -EINVAL;
+
+	/* LPF tuning on */
+	msleep_interruptible(1);
+	qm->reg[0x0c] |= 0x40;
+	ret = qm1d1c0042_write(qm, 0x0c, qm->reg[0x0c]);
+	if (ret)
+		return ret;
+	msleep_interruptible(qm->wait_time_lpf);
+
+	for (i = 0; i < sizeof(qm1d1c0042_flag); i++)
+		if (qm1d1c0042_flag[i] == 1) {
+			ret = qm1d1c0042_write(qm, i, qm->reg[i]);
+			if (ret)
+				return ret;
+		}
+	ret = qm1d1c0042_set_sleep_mode(qm);
+	if (ret)
+		return ret;
+	return qm1d1c0042_set_search_mode(qm);
+}
+
+int qm1d1c0042_set_sleep(struct qm1d1c0042 *qm, bool sleep)
+{
+	qm->standby = sleep;
+	if (sleep) {
+		int ret = tc90522_set_agc(qm->adap, TC90522_AGC_MANUAL);
+		if (ret)
+			return ret;
+		qm1d1c0042_set_sleep_mode(qm);
+		tc90522_set_sleep_s(qm->adap, sleep);
+	} else {
+		tc90522_set_sleep_s(qm->adap, sleep);
+		qm1d1c0042_set_sleep_mode(qm);
+	}
+	qm->adap->sleep = sleep;
+	return 0;
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
+static u32 QM1D1C0042_FREQ_TABLE[9][3] = {
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
+static u32 SD_TABLE[24][2][3] = {
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
+	struct pt3_adapter *adap = qm->adap;
+	u8 i_data;
+	u32 index, i, N, A;
+
+	qm->reg[0x08] &= 0xf0;
+	qm->reg[0x08] |= 0x09;
+
+	qm->reg[0x13] &= 0x9f;
+	qm->reg[0x13] |= 0x20;
+
+	for (i = 0; i < 8; i++) {
+		if ((QM1D1C0042_FREQ_TABLE[i+1][0] <= adap->freq) && (adap->freq < QM1D1C0042_FREQ_TABLE[i][0])) {
+			i_data = qm->reg[0x02];
+			i_data &= 0x0f;
+			i_data |= QM1D1C0042_FREQ_TABLE[i][1] << 7;
+			i_data |= QM1D1C0042_FREQ_TABLE[i][2] << 4;
+			qm1d1c0042_write(qm, 0x02, i_data);
+		}
+	}
+
+	index = tc90522_index(qm->adap);
+	*sd = SD_TABLE[channel][index][0];
+	N = SD_TABLE[channel][index][1];
+	A = SD_TABLE[channel][index][2];
+
+	qm->reg[0x06] &= 0x40;
+	qm->reg[0x06] |= N;
+	ret = qm1d1c0042_write(qm, 0x06, qm->reg[0x06]);
+	if (ret)
+		return ret;
+
+	qm->reg[0x07] &= 0xf0;
+	qm->reg[0x07] |= A & 0x0f;
+	return qm1d1c0042_write(qm, 0x07, qm->reg[0x07]);
+}
+
+static int qm1d1c0042_local_lpf_tuning(struct qm1d1c0042 *qm, int lpf, u32 channel)
+{
+	u8 i_data;
+	u32 sd = 0;
+	int ret = qm1d1c0042_tuning(qm, &sd, channel);
+
+	if (ret)
+		return ret;
+	if (lpf) {
+		i_data = qm->reg[0x08] & 0xf0;
+		i_data |= 2;
+		ret = qm1d1c0042_write(qm, 0x08, i_data);
+	} else
+		ret = qm1d1c0042_write(qm, 0x08, qm->reg[0x08]);
+	if (ret)
+		return ret;
+
+	qm->reg[0x09] &= 0xc0;
+	qm->reg[0x09] |= (sd >> 16) & 0x3f;
+	qm->reg[0x0a] = (sd >> 8) & 0xff;
+	qm->reg[0x0b] = (sd >> 0) & 0xff;
+	ret = qm1d1c0042_write(qm, 0x09, qm->reg[0x09]);
+	if (ret)
+		return ret;
+	ret = qm1d1c0042_write(qm, 0x0a, qm->reg[0x0a]);
+	if (ret)
+		return ret;
+	ret = qm1d1c0042_write(qm, 0x0b, qm->reg[0x0b]);
+	if (ret)
+		return ret;
+
+	if (lpf) {
+		i_data = qm->reg[0x0c];
+		i_data &= 0x3f;
+		ret = qm1d1c0042_write(qm, 0x0c, i_data);
+		if (ret)
+			return ret;
+		msleep_interruptible(1);
+
+		i_data = qm->reg[0x0c];
+		i_data |= 0xc0;
+		ret = qm1d1c0042_write(qm, 0x0c, i_data);
+		if (ret)
+			return ret;
+		msleep_interruptible(qm->wait_time_lpf);
+		ret = qm1d1c0042_write(qm, 0x08, 0x09);
+		if (ret)
+			return ret;
+		ret = qm1d1c0042_write(qm, 0x13, qm->reg[0x13]);
+		if (ret)
+			return ret;
+	} else {
+		ret = qm1d1c0042_write(qm, 0x13, qm->reg[0x13]);
+		if (ret)
+			return ret;
+		i_data = qm->reg[0x0c];
+		i_data &= 0x7f;
+		ret = qm1d1c0042_write(qm, 0x0c, i_data);
+		if (ret)
+			return ret;
+		msleep_interruptible(2);
+
+		i_data = qm->reg[0x0c];
+		i_data |= 0x80;
+		ret = qm1d1c0042_write(qm, 0x0c, i_data);
+		if (ret)
+			return ret;
+		if (qm->reg[0x03] & 0x01)
+			msleep_interruptible(qm->wait_time_search_fast);
+		else
+			msleep_interruptible(qm->wait_time_search_normal);
+	}
+	return ret;
+}
+
+int qm1d1c0042_get_locked(struct qm1d1c0042 *qm, bool *locked)
+{
+	int ret = qm1d1c0042_read(qm, 0x0d, &qm->reg[0x0d]);
+	if (ret)
+		return ret;
+	if (qm->reg[0x0d] & 0x40)
+		*locked = true;
+	else
+		*locked = false;
+	return ret;
+}
+
+int qm1d1c0042_set_frequency(struct qm1d1c0042 *qm, u32 channel)
+{
+	u32 number, freq, freq_kHz;
+	struct timeval begin, now;
+	bool locked;
+	int ret = tc90522_set_agc(qm->adap, TC90522_AGC_MANUAL);
+	if (ret)
+		return ret;
+
+	qm1d1c0042_get_channel_freq(channel, &number, &freq);
+	freq_kHz = freq * 10;
+	if (tc90522_index(qm->adap) == 0)
+		freq_kHz -= 500;
+	else
+		freq_kHz += 500;
+	qm->adap->freq = freq_kHz;
+	pr_debug("#%d ch %d freq %d kHz\n", qm->adap->idx, channel, freq_kHz);
+
+	ret = qm1d1c0042_local_lpf_tuning(qm, 1, channel);
+	if (ret)
+		return ret;
+	do_gettimeofday(&begin);
+	while (1) {
+		do_gettimeofday(&now);
+		ret = qm1d1c0042_get_locked(qm, &locked);
+		if (ret)
+			return ret;
+		if (locked)
+			break;
+		if (tc90522_time_diff(&begin, &now) >= 100)
+			break;
+		msleep_interruptible(1);
+	}
+	pr_debug("#%d qm_get_locked %d ret=0x%x\n", qm->adap->idx, locked, ret);
+	if (!locked)
+		return -ETIMEDOUT;
+
+	ret = tc90522_set_agc(qm->adap, TC90522_AGC_AUTO);
+	if (!ret) {
+		qm->adap->channel = channel;
+		qm->adap->offset = 0;
+	}
+	return ret;
+}
+
+int qm1d1c0042_tuner_init(struct qm1d1c0042 *qm)
+{
+	if (*qm->reg) {
+		if (qm1d1c0042_init(qm))
+			return -EIO;
+	} else {
+		qm1d1c0042_init_reg_param(qm);
+		qm1d1c0042_dummy_reset(qm);
+	}
+	return 0;
+}
+
+EXPORT_SYMBOL(qm1d1c0042_set_frequency);
+EXPORT_SYMBOL(qm1d1c0042_set_sleep);
+EXPORT_SYMBOL(qm1d1c0042_tuner_init);
+
diff --git a/drivers/media/tuners/qm1d1c0042.h b/drivers/media/tuners/qm1d1c0042.h
new file mode 100644
index 0000000..ed3246d
--- /dev/null
+++ b/drivers/media/tuners/qm1d1c0042.h
@@ -0,0 +1,34 @@
+/*
+ * QM1D1C0042 ISDB-S tuner driver for Earthsoft PT3
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
+#ifndef __QM1D1C0042_H__
+#define __QM1D1C0042_H__
+
+struct qm1d1c0042 {
+	struct pt3_adapter *adap;
+	u8 reg[32];
+
+	bool standby;
+	u32 wait_time_lpf, wait_time_search_fast, wait_time_search_normal;
+	struct tmcc_s tmcc;
+};
+
+int qm1d1c0042_set_frequency(struct qm1d1c0042 *qm, u32 channel);
+int qm1d1c0042_set_sleep(struct qm1d1c0042 *qm, bool sleep);
+int qm1d1c0042_tuner_init(struct qm1d1c0042 *qm);
+
+#endif
+
diff --git a/drivers/media/tuners/tc90522.c b/drivers/media/tuners/tc90522.c
new file mode 100644
index 0000000..bce4532
--- /dev/null
+++ b/drivers/media/tuners/tc90522.c
@@ -0,0 +1,412 @@
+/*
+ * Earthsoft PT3 demodulator driver TC90522 Toshiba OFDM(ISDB-T)/8PSK(ISDB-S)
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
+#include "pt3_common.h"
+#include "tc90522.h"
+
+MODULE_AUTHOR("Budi Rachmanto, AreMa Inc. <knightrider(@)are.ma>");
+MODULE_DESCRIPTION("Earthsoft PT3 TC90522 OFDM(ISDB-T)/8PSK(ISDB-S) Toshiba demodulator driver");
+MODULE_LICENSE("GPL");
+
+int tc90522_write(struct pt3_adapter *adap, u8 addr, u8 *data, u8 len)
+{
+	struct i2c_msg msg[1];
+	u8 buf[len + 1];
+	buf[0] = addr;
+	memcpy(buf + 1, data, len);
+
+	msg[0].addr = adap->addr_demod;
+	msg[0].flags = 0;			/* write */
+	msg[0].buf = buf;
+	msg[0].len = len + 1;
+
+	return i2c_transfer(&adap->pt3->i2c, msg, 1) == 1 ? 0 : -EREMOTEIO;
+}
+
+static int tc90522_write_pskmsrst(struct pt3_adapter *adap)
+{
+	u8 data = 0x01;
+	return tc90522_write(adap, 0x03, &data, 1);
+}
+
+static int tc90522_write_imsrst(struct pt3_adapter *adap)
+{
+	u8 data = 0x01 << 6;
+	return tc90522_write(adap, 0x01, &data, 1);
+}
+
+int tc90522_init(struct pt3_adapter *adap)
+{
+	u8 data = 0x10;
+
+	pr_debug("#%d %s tuner=0x%x demod=0x%x\n", adap->idx, adap->str, adap->addr_tuner, adap->addr_demod);
+	if (adap->type == SYS_ISDBS) {
+		int ret = tc90522_write_pskmsrst(adap);
+		return ret ? ret : tc90522_write(adap, 0x1e, &data, 1);
+	} else {
+		int ret = tc90522_write_imsrst(adap);
+		return ret ? ret : tc90522_write(adap, 0x1c, &data, 1);
+	}
+}
+
+int tc90522_set_powers(struct pt3_adapter *adap, bool tuner, bool amp)
+{
+	u8	tuner_power = tuner ? 0x03 : 0x02,
+		amp_power = amp ? 0x03 : 0x02,
+		data = (tuner_power << 6) | (0x01 << 4) | (amp_power << 2) | 0x01 << 0;
+	pr_debug("#%d tuner %s amp %s\n", adap->idx, tuner ? "ON" : "OFF", amp ? "ON" : "OFF");
+	return tc90522_write(adap, 0x1e, &data, 1);
+}
+
+int tc90522_set_ts_pins_mode(struct pt3_adapter *adap, struct pt3_ts_pins_mode *mode)
+{
+	u32	clock_data = mode->clock_data,
+		byte = mode->byte,
+		valid = mode->valid;
+
+	if (clock_data)
+		clock_data++;
+	if (byte)
+		byte++;
+	if (valid)
+		valid++;
+	if (adap->type == SYS_ISDBS) {
+		u8 data[2];
+		int ret;
+		data[0] = 0x15 | (valid << 6);
+		data[1] = 0x04 | (clock_data << 4) | byte;
+		return (ret = tc90522_write(adap, 0x1c, &data[0], 1)) ?
+			ret : tc90522_write(adap, 0x1f, &data[1], 1);
+	} else {
+		u8 data = (u8)(0x01 | (clock_data << 6) | (byte << 4) | (valid << 2));
+		return tc90522_write(adap, 0x1d, &data, 1);
+	}
+}
+
+#define TC90522_THROUGH 0xfe
+
+int tc90522_write_tuner(struct pt3_adapter *adap, u8 addr, const u8 *data, u32 len)
+{
+	struct i2c_msg msg[1];
+	u8 buf[len + 3];
+
+	buf[0] = TC90522_THROUGH;
+	buf[1] = adap->addr_tuner << 1;
+	buf[2] = addr;
+	memcpy(buf + 3, data, len);
+	msg[0].buf = buf;
+	msg[0].len = len + 3;
+	msg[0].addr = adap->addr_demod;
+	msg[0].flags = 0;			/* write */
+
+	return i2c_transfer(&adap->pt3->i2c, msg, 1) == 1 ? 0 : -EREMOTEIO;
+}
+
+int tc90522_read_tuner(struct pt3_adapter *adap, u8 addr, u8 *data)
+{
+	struct i2c_msg msg[3];
+	u8 buf[5];
+
+	buf[0] = TC90522_THROUGH;
+	buf[1] = adap->addr_tuner << 1;
+	buf[2] = addr;
+	msg[0].buf = buf;
+	msg[0].len = 3;
+	msg[0].addr = adap->addr_demod;
+	msg[0].flags = 0;			/* write */
+
+	buf[3] = TC90522_THROUGH;
+	buf[4] = (adap->addr_tuner << 1) | 1;
+	msg[1].buf = buf + 3;
+	msg[1].len = 2;
+	msg[1].addr = adap->addr_demod;
+	msg[1].flags = 0;			/* write */
+
+	msg[2].buf = data;
+	msg[2].len = 1;
+	msg[2].addr = adap->addr_demod;
+	msg[2].flags = I2C_M_RD;		/* read */
+
+	return i2c_transfer(&adap->pt3->i2c, msg, 3) == 3 ? 0 : -EREMOTEIO;
+}
+
+static u8 agc_data_s[2] = { 0xb0, 0x30 };
+
+u32 tc90522_index(struct pt3_adapter *adap)
+{
+	return PT3_SHIFT_MASK(adap->addr_demod, 1, 1);
+}
+
+int tc90522_set_agc_s(struct pt3_adapter *adap, enum tc90522_agc agc)
+{
+	u8 data = (agc == TC90522_AGC_AUTO) ? 0xff : 0x00;
+	int ret = tc90522_write(adap, 0x0a, &data, 1);
+	if (ret)
+		return ret;
+
+	data = agc_data_s[tc90522_index(adap)];
+	data |= (agc == TC90522_AGC_AUTO) ? 0x01 : 0x00;
+	ret = tc90522_write(adap, 0x10, &data, 1);
+	if (ret)
+		return ret;
+
+	data = (agc == TC90522_AGC_AUTO) ? 0x40 : 0x00;
+	return (ret = tc90522_write(adap, 0x11, &data, 1)) ? ret : tc90522_write_pskmsrst(adap);
+}
+
+int tc90522_set_sleep_s(struct pt3_adapter *adap, bool sleep)
+{
+	u8 buf = sleep ? 1 : 0;
+	return tc90522_write(adap, 0x17, &buf, 1);
+}
+
+int tc90522_set_agc_t(struct pt3_adapter *adap, enum tc90522_agc agc)
+{
+	u8 data = (agc == TC90522_AGC_AUTO) ? 0x40 : 0x00;
+	int ret = tc90522_write(adap, 0x25, &data, 1);
+	if (ret)
+		return ret;
+
+	data = 0x4c | ((agc == TC90522_AGC_AUTO) ? 0x00 : 0x01);
+	return (ret = tc90522_write(adap, 0x23, &data, 1)) ? ret : tc90522_write_imsrst(adap);
+}
+
+int tc90522_set_agc(struct pt3_adapter *adap, enum tc90522_agc agc)
+{
+	if (adap->type == SYS_ISDBS)
+		return tc90522_set_agc_s(adap, agc);
+	else
+		return tc90522_set_agc_t(adap, agc);
+}
+
+int tc90522_write_tuner_without_addr(struct pt3_adapter *adap, const u8 *data, u32 len)
+{
+	struct i2c_msg msg[1];
+	u8 buf[len + 2];
+
+	buf[0] = TC90522_THROUGH;
+	buf[1] = adap->addr_tuner << 1;
+	memcpy(buf + 2, data, len);
+	msg[0].buf = buf;
+	msg[0].len = len + 2;
+	msg[0].addr = adap->addr_demod;
+	msg[0].flags = 0;			/* write */
+
+	return i2c_transfer(&adap->pt3->i2c, msg, 1) == 1 ? 0 : -EREMOTEIO;
+}
+
+int tc90522_write_sleep_time(struct pt3_adapter *adap, int sleep)
+{
+	u8 data = (1 << 7) | ((sleep ? 1 : 0) << 4);
+	return tc90522_write(adap, 0x03, &data, 1);
+}
+
+u32 tc90522_time_diff(struct timeval *st, struct timeval *et)
+{
+	u32 diff = ((et->tv_sec - st->tv_sec) * 1000000 + (et->tv_usec - st->tv_usec)) / 1000;
+	pr_debug("time diff = %d\n", diff);
+	return diff;
+}
+
+int tc90522_read_tuner_without_addr(struct pt3_adapter *adap, u8 *data)
+{
+	struct i2c_msg msg[2];
+	u8 buf[2];
+
+	buf[0] = TC90522_THROUGH;
+	buf[1] = (adap->addr_tuner << 1) | 1;
+	msg[0].buf = buf;
+	msg[0].len = 2;
+	msg[0].addr = adap->addr_demod;
+	msg[0].flags = 0;			/* write */
+
+	msg[1].buf = data;
+	msg[1].len = 1;
+	msg[1].addr = adap->addr_demod;
+	msg[1].flags = I2C_M_RD;		/* read */
+
+	return i2c_transfer(&adap->pt3->i2c, msg, 2) == 2 ? 0 : -EREMOTEIO;
+}
+
+static u32 tc90522_byten(const u8 *data, u32 n)
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
+int tc90522_read(struct pt3_adapter *adap, u8 addr, u8 *buf, u8 buflen)
+{
+	struct i2c_msg msg[2];
+	buf[0] = addr;
+
+	msg[0].addr = adap->addr_demod;
+	msg[0].flags = 0;			/* write */
+	msg[0].buf = buf;
+	msg[0].len = 1;
+
+	msg[1].addr = adap->addr_demod;
+	msg[1].flags = I2C_M_RD;		/* read */
+	msg[1].buf = buf;
+	msg[1].len = buflen;
+
+	return i2c_transfer(&adap->pt3->i2c, msg, 2) == 2 ? 0 : -EREMOTEIO;
+}
+
+int tc90522_read_retryov_tmunvld_fulock(struct pt3_adapter *adap, bool *retryov, bool *tmunvld, bool *fulock)
+{
+	u8 buf;
+	int ret = tc90522_read(adap, 0x80, &buf, 1);
+	if (!ret) {
+		*retryov = PT3_SHIFT_MASK(buf, 7, 1) ? true : false;
+		*tmunvld = PT3_SHIFT_MASK(buf, 5, 1) ? true : false;
+		*fulock  = PT3_SHIFT_MASK(buf, 3, 1) ? true : false;
+	}
+	return ret;
+}
+
+int tc90522_read_cn(struct pt3_adapter *adap, u32 *cn)
+{
+	u8 buf[3], buflen = (adap->type == SYS_ISDBS) ? 2 : 3, addr = (adap->type == SYS_ISDBS) ? 0xbc : 0x8b;
+	int ret = tc90522_read(adap, addr, buf, buflen);
+	if (!ret)
+		*cn =  tc90522_byten(buf, buflen);
+	return ret;
+}
+
+int tc90522_read_id_s(struct pt3_adapter *adap, u16 *id)
+{
+	u8 buf[2];
+	int ret = tc90522_read(adap, 0xe6, buf, 2);
+	if (!ret)
+		*id = tc90522_byten(buf, 2);
+	return ret;
+}
+
+int tc90522_read_tmcc_t(struct pt3_adapter *adap, struct tmcc_t *tmcc)
+{
+	u32 interleave0h, interleave0l, segment1h, segment1l;
+	u8 data[8];
+
+	int ret = tc90522_read(adap, 0xb2+0, data, 4);
+	if (ret)
+		return ret;
+	ret = tc90522_read(adap, 0xb2+4, data+4, 4);
+	if (ret)
+		return ret;
+
+	tmcc->system    = PT3_SHIFT_MASK(data[0], 6, 2);
+	tmcc->indicator = PT3_SHIFT_MASK(data[0], 2, 4);
+	tmcc->emergency = PT3_SHIFT_MASK(data[0], 1, 1);
+	tmcc->partial   = PT3_SHIFT_MASK(data[0], 0, 1);
+
+	tmcc->mode[0] = PT3_SHIFT_MASK(data[1], 5, 3);
+	tmcc->mode[1] = PT3_SHIFT_MASK(data[2], 0, 3);
+	tmcc->mode[2] = PT3_SHIFT_MASK(data[4], 3, 3);
+
+	tmcc->rate[0] = PT3_SHIFT_MASK(data[1], 2, 3);
+	tmcc->rate[1] = PT3_SHIFT_MASK(data[3], 5, 3);
+	tmcc->rate[2] = PT3_SHIFT_MASK(data[4], 0, 3);
+
+	interleave0h = PT3_SHIFT_MASK(data[1], 0, 2);
+	interleave0l = PT3_SHIFT_MASK(data[2], 7, 1);
+
+	tmcc->interleave[0] = interleave0h << 1 | interleave0l << 0;
+	tmcc->interleave[1] = PT3_SHIFT_MASK(data[3], 2, 3);
+	tmcc->interleave[2] = PT3_SHIFT_MASK(data[5], 5, 3);
+
+	segment1h = PT3_SHIFT_MASK(data[3], 0, 2);
+	segment1l = PT3_SHIFT_MASK(data[4], 6, 2);
+
+	tmcc->segment[0] = PT3_SHIFT_MASK(data[2], 3, 4);
+	tmcc->segment[1] = segment1h << 2 | segment1l << 0;
+	tmcc->segment[2] = PT3_SHIFT_MASK(data[5], 1, 4);
+
+	return ret;
+}
+
+int tc90522_read_tmcc_s(struct pt3_adapter *adap, struct tmcc_s *tmcc)
+{
+	enum {
+		BASE = 0xc5,
+		SIZE = 0xe5 - BASE + 1
+	};
+	u8 data[SIZE];
+	u32 i, byte_offset, bit_offset;
+
+	int ret = tc90522_read(adap, 0xc3, data, 1);
+	if (ret)
+		return ret;
+	if (PT3_SHIFT_MASK(data[0], 4, 1))
+		return -EBADMSG;
+
+	ret = tc90522_read(adap, 0xce, data, 2);
+	if (ret)
+		return ret;
+	if (tc90522_byten(data, 2) == 0)
+		return -EBADMSG;
+
+	ret = tc90522_read(adap, 0xc3, data, 1);
+	if (ret)
+		return ret;
+	tmcc->emergency = PT3_SHIFT_MASK(data[0], 2, 1);
+	tmcc->extflag   = PT3_SHIFT_MASK(data[0], 1, 1);
+
+	ret = tc90522_read(adap, 0xc5, data, SIZE);
+	if (ret)
+		return ret;
+	tmcc->indicator = PT3_SHIFT_MASK(data[0xc5 - BASE], 3, 5);
+	tmcc->uplink    = PT3_SHIFT_MASK(data[0xc7 - BASE], 0, 4);
+
+	for (i = 0; i < 4; i++) {
+		byte_offset = i >> 1;
+		bit_offset = (i & 1) ? 0 : 4;
+		tmcc->mode[i] = PT3_SHIFT_MASK(data[0xc8 + byte_offset - BASE], bit_offset, 4);
+		tmcc->slot[i] = PT3_SHIFT_MASK(data[0xca + i - BASE], 0, 6);
+	}
+	for (i = 0; i < 8; i++)
+		tmcc->id[i] = tc90522_byten(data + 0xce + i * 2 - BASE, 2);
+	return ret;
+}
+
+int tc90522_read_tmcc(struct pt3_adapter *adap, void *tmcc)
+{
+	if (adap->type == SYS_ISDBS)
+		return tc90522_read_tmcc_s(adap, (struct tmcc_s *)tmcc);
+	else
+		return tc90522_read_tmcc_t(adap, (struct tmcc_t *)tmcc);
+}
+
+int tc90522_write_id_s(struct pt3_adapter *adap, u16 id)
+{
+	u8 data[2] = { id >> 8, (u8)id };
+	return tc90522_write(adap, 0x8f, data, sizeof(data));
+}
+
+EXPORT_SYMBOL(tc90522_init);
+EXPORT_SYMBOL(tc90522_read_cn);
+EXPORT_SYMBOL(tc90522_read_id_s);
+EXPORT_SYMBOL(tc90522_read_retryov_tmunvld_fulock);
+EXPORT_SYMBOL(tc90522_read_tmcc);
+EXPORT_SYMBOL(tc90522_set_agc);
+EXPORT_SYMBOL(tc90522_set_powers);
+EXPORT_SYMBOL(tc90522_set_ts_pins_mode);
+EXPORT_SYMBOL(tc90522_write_id_s);
+
diff --git a/drivers/media/tuners/tc90522.h b/drivers/media/tuners/tc90522.h
new file mode 100644
index 0000000..9d33ec5
--- /dev/null
+++ b/drivers/media/tuners/tc90522.h
@@ -0,0 +1,90 @@
+/*
+ * Earthsoft PT3 demodulator driver TC90522 Toshiba OFDM(ISDB-T)/8PSK(ISDB-S)
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
+#ifndef	__TC90522_H__
+#define	__TC90522_H__
+
+/* Transmission and Multiplexing Configuration Control */
+
+enum {
+	LAYER_INDEX_L = 0,
+	LAYER_INDEX_H,
+
+	LAYER_INDEX_A = 0,
+	LAYER_INDEX_B,
+	LAYER_INDEX_C
+};
+
+enum {
+	LAYER_COUNT_S = LAYER_INDEX_H + 1,
+	LAYER_COUNT_T = LAYER_INDEX_C + 1,
+};
+
+struct tmcc_s {
+	u32 indicator;
+	u32 mode[4];
+	u32 slot[4];
+	u32 id[8];
+	u32 emergency;
+	u32 uplink;
+	u32 extflag;
+};
+
+struct tmcc_t {
+	u32 system;
+	u32 indicator;
+	u32 emergency;
+	u32 partial;
+	u32 mode[LAYER_COUNT_T];
+	u32 rate[LAYER_COUNT_T];
+	u32 interleave[LAYER_COUNT_T];
+	u32 segment[LAYER_COUNT_T];
+};
+
+enum tc90522_agc {
+	TC90522_AGC_AUTO,
+	TC90522_AGC_MANUAL,
+};
+
+enum pt3_ts_pin_mode {
+	PT3_TS_PIN_MODE_NORMAL,
+	PT3_TS_PIN_MODE_LOW,
+	PT3_TS_PIN_MODE_HIGH,
+};
+
+struct pt3_ts_pins_mode {
+	enum pt3_ts_pin_mode clock_data, byte, valid;
+};
+
+u32 tc90522_index(struct pt3_adapter *adap);
+int tc90522_init(struct pt3_adapter *adap);
+int tc90522_read_cn(struct pt3_adapter *adap, u32 *cn);
+int tc90522_read_id_s(struct pt3_adapter *adap, u16 *id);
+int tc90522_read_retryov_tmunvld_fulock(struct pt3_adapter *adap, bool *retryov, bool *tmunvld, bool *fulock);
+int tc90522_read_tmcc(struct pt3_adapter *adap, void *tmcc);
+int tc90522_read_tuner(struct pt3_adapter *adap, u8 addr, u8 *data);
+int tc90522_read_tuner_without_addr(struct pt3_adapter *adap, u8 *data);
+int tc90522_set_agc(struct pt3_adapter *adap, enum tc90522_agc agc);
+int tc90522_set_powers(struct pt3_adapter *adap, bool tuner, bool amp);
+int tc90522_set_sleep_s(struct pt3_adapter *adap, bool sleep);
+int tc90522_set_ts_pins_mode(struct pt3_adapter *adap, struct pt3_ts_pins_mode *mode);
+u32 tc90522_time_diff(struct timeval *st, struct timeval *et);
+int tc90522_write_id_s(struct pt3_adapter *adap, u16 id);
+int tc90522_write_sleep_time(struct pt3_adapter *adap, int sleep);
+int tc90522_write_tuner(struct pt3_adapter *adap, u8 addr, const u8 *data, u32 size);
+int tc90522_write_tuner_without_addr(struct pt3_adapter *adap, const u8 *data, u32 size);
+
+#endif
-- 
1.8.4.5

