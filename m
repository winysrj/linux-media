Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:32847 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752596AbdGITmw (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 9 Jul 2017 15:42:52 -0400
Received: by mail-wr0-f195.google.com with SMTP id x23so20431712wrb.0
        for <linux-media@vger.kernel.org>; Sun, 09 Jul 2017 12:42:51 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: jasmin@anw.at, d_spingler@gmx.de, rjkm@metzlerbros.de
Subject: [PATCH 1/4] [media] dvb-frontends: MaxLinear MxL5xx DVB-S/S2 tuner-demodulator driver
Date: Sun,  9 Jul 2017 21:42:43 +0200
Message-Id: <20170709194246.10334-2-d.scheller.oss@gmail.com>
In-Reply-To: <20170709194246.10334-1-d.scheller.oss@gmail.com>
References: <20170709194246.10334-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

This adds the frontend driver for the MaxLinear MxL5xx family of tuner-
demodulators, as used on Digital Devices MaxS4/8 four/eight-tuner cards.

The driver was picked from the dddvb vendor driver package and - judging
solely from the diff - has undergone a 100% rework:

 - Silly #define's used to pass multiple values to functions were
   expanded. This resulted in macro/register names not being usable
   anymore for such occurences, but makes the code WAY more read-,
   understand- and maintainable.
 - CamelCase was changed to kernel_case
 - All typedef were removed
 - Overall code style was fixed, besides >80char lines in _defs.h and
   _regs.h, checkpatch is happy.
 - Also, signal stat acquisition was made to comply with the DVB API
   ways to do these things.

Permission to reuse and mainline the driver code was formally granted by
Ralph Metzler <rjkm@metzlerbros.de>.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/dvb-frontends/Kconfig       |    9 +
 drivers/media/dvb-frontends/Makefile      |    1 +
 drivers/media/dvb-frontends/mxl5xx.c      | 1873 +++++++++++++++++++++++++++++
 drivers/media/dvb-frontends/mxl5xx.h      |   41 +
 drivers/media/dvb-frontends/mxl5xx_defs.h |  731 +++++++++++
 drivers/media/dvb-frontends/mxl5xx_regs.h |  367 ++++++
 6 files changed, 3022 insertions(+)
 create mode 100644 drivers/media/dvb-frontends/mxl5xx.c
 create mode 100644 drivers/media/dvb-frontends/mxl5xx.h
 create mode 100644 drivers/media/dvb-frontends/mxl5xx_defs.h
 create mode 100644 drivers/media/dvb-frontends/mxl5xx_regs.h

diff --git a/drivers/media/dvb-frontends/Kconfig b/drivers/media/dvb-frontends/Kconfig
index d2d3160abdf7..2631d0e0a024 100644
--- a/drivers/media/dvb-frontends/Kconfig
+++ b/drivers/media/dvb-frontends/Kconfig
@@ -53,6 +53,15 @@ config DVB_STV6111
 
 	  Say Y when you want to support these frontends.
 
+config DVB_MXL5XX
+	tristate "MaxLinear MxL5xx based tuner-demodulators"
+	depends on DVB_CORE && I2C
+	default m if !MEDIA_SUBDRV_AUTOSELECT
+	help
+	  MaxLinear MxL5xx family of DVB-S/S2 tuners/demodulators.
+
+	  Say Y when you want to support these frontends.
+
 config DVB_M88DS3103
 	tristate "Montage Technology M88DS3103"
 	depends on DVB_CORE && I2C && I2C_MUX
diff --git a/drivers/media/dvb-frontends/Makefile b/drivers/media/dvb-frontends/Makefile
index e8bf1d873485..f45f6a4a4371 100644
--- a/drivers/media/dvb-frontends/Makefile
+++ b/drivers/media/dvb-frontends/Makefile
@@ -112,6 +112,7 @@ obj-$(CONFIG_DVB_DRXK) += drxk.o
 obj-$(CONFIG_DVB_TDA18271C2DD) += tda18271c2dd.o
 obj-$(CONFIG_DVB_STV0910) += stv0910.o
 obj-$(CONFIG_DVB_STV6111) += stv6111.o
+obj-$(CONFIG_DVB_MXL5XX) += mxl5xx.o
 obj-$(CONFIG_DVB_SI2165) += si2165.o
 obj-$(CONFIG_DVB_A8293) += a8293.o
 obj-$(CONFIG_DVB_SP2) += sp2.o
diff --git a/drivers/media/dvb-frontends/mxl5xx.c b/drivers/media/dvb-frontends/mxl5xx.c
new file mode 100644
index 000000000000..676c96c216c3
--- /dev/null
+++ b/drivers/media/dvb-frontends/mxl5xx.c
@@ -0,0 +1,1873 @@
+/*
+ * Driver for the MaxLinear MxL5xx family of tuners/demods
+ *
+ * Copyright (C) 2014-2015 Ralph Metzler <rjkm@metzlerbros.de>
+ *                         Marcus Metzler <mocm@metzlerbros.de>
+ *                         developed for Digital Devices GmbH
+ *
+ * based on code:
+ * Copyright (c) 2011-2013 MaxLinear, Inc. All rights reserved
+ * which was released under GPL V2
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/init.h>
+#include <linux/delay.h>
+#include <linux/firmware.h>
+#include <linux/i2c.h>
+#include <linux/version.h>
+#include <linux/mutex.h>
+#include <linux/vmalloc.h>
+#include <asm/div64.h>
+#include <asm/unaligned.h>
+
+#include "dvb_frontend.h"
+#include "mxl5xx.h"
+#include "mxl5xx_regs.h"
+#include "mxl5xx_defs.h"
+
+#define BYTE0(v) ((v >>  0) & 0xff)
+#define BYTE1(v) ((v >>  8) & 0xff)
+#define BYTE2(v) ((v >> 16) & 0xff)
+#define BYTE3(v) ((v >> 24) & 0xff)
+
+LIST_HEAD(mxllist);
+
+struct mxl_base {
+	struct list_head     mxllist;
+	struct list_head     mxls;
+
+	u8                   adr;
+	struct i2c_adapter  *i2c;
+
+	u32                  count;
+	u32                  type;
+	u32                  sku_type;
+	u32                  chipversion;
+	u32                  clock;
+	u32                  fwversion;
+
+	u8                  *ts_map;
+	u8                   can_clkout;
+	u8                   chan_bond;
+	u8                   demod_num;
+	u8                   tuner_num;
+
+	unsigned long        next_tune;
+
+	struct mutex         i2c_lock;
+	struct mutex         status_lock;
+	struct mutex         tune_lock;
+
+	u8                   buf[MXL_HYDRA_OEM_MAX_CMD_BUFF_LEN];
+
+	u32                  cmd_size;
+	u8                   cmd_data[MAX_CMD_DATA];
+};
+
+struct mxl {
+	struct list_head     mxl;
+
+	struct mxl_base     *base;
+	struct dvb_frontend  fe;
+	struct device       *i2cdev;
+	u32                  demod;
+	u32                  tuner;
+	u32                  tuner_in_use;
+	u8                   xbar[3];
+
+	unsigned long        tune_time;
+};
+
+static void convert_endian(u8 flag, u32 size, u8 *d)
+{
+	u32 i;
+
+	if (!flag)
+		return;
+	for (i = 0; i < (size & ~3); i += 4) {
+		d[i + 0] ^= d[i + 3];
+		d[i + 3] ^= d[i + 0];
+		d[i + 0] ^= d[i + 3];
+
+		d[i + 1] ^= d[i + 2];
+		d[i + 2] ^= d[i + 1];
+		d[i + 1] ^= d[i + 2];
+	}
+
+	switch (size & 3) {
+	case 0:
+	case 1:
+		/* do nothing */
+		break;
+	case 2:
+		d[i + 0] ^= d[i + 1];
+		d[i + 1] ^= d[i + 0];
+		d[i + 0] ^= d[i + 1];
+		break;
+
+	case 3:
+		d[i + 0] ^= d[i + 2];
+		d[i + 2] ^= d[i + 0];
+		d[i + 0] ^= d[i + 2];
+		break;
+	}
+
+}
+
+static int i2c_write(struct i2c_adapter *adap, u8 adr,
+			    u8 *data, u32 len)
+{
+	struct i2c_msg msg = {.addr = adr, .flags = 0,
+			      .buf = data, .len = len};
+
+	return (i2c_transfer(adap, &msg, 1) == 1) ? 0 : -1;
+}
+
+static int i2c_read(struct i2c_adapter *adap, u8 adr,
+			   u8 *data, u32 len)
+{
+	struct i2c_msg msg = {.addr = adr, .flags = I2C_M_RD,
+			      .buf = data, .len = len};
+
+	return (i2c_transfer(adap, &msg, 1) == 1) ? 0 : -1;
+}
+
+static int i2cread(struct mxl *state, u8 *data, int len)
+{
+	return i2c_read(state->base->i2c, state->base->adr, data, len);
+}
+
+static int i2cwrite(struct mxl *state, u8 *data, int len)
+{
+	return i2c_write(state->base->i2c, state->base->adr, data, len);
+}
+
+static int read_register_unlocked(struct mxl *state, u32 reg, u32 *val)
+{
+	int stat;
+	u8 data[MXL_HYDRA_REG_SIZE_IN_BYTES + MXL_HYDRA_I2C_HDR_SIZE] = {
+		MXL_HYDRA_PLID_REG_READ, 0x04,
+		GET_BYTE(reg, 0), GET_BYTE(reg, 1),
+		GET_BYTE(reg, 2), GET_BYTE(reg, 3),
+	};
+
+	stat = i2cwrite(state, data,
+			MXL_HYDRA_REG_SIZE_IN_BYTES + MXL_HYDRA_I2C_HDR_SIZE);
+	if (stat)
+		dev_err(state->i2cdev, "i2c read error 1\n");
+	if (!stat)
+		stat = i2cread(state, (u8 *) val,
+			       MXL_HYDRA_REG_SIZE_IN_BYTES);
+	le32_to_cpus(val);
+	if (stat)
+		dev_err(state->i2cdev, "i2c read error 2\n");
+	return stat;
+}
+
+#define DMA_I2C_INTERRUPT_ADDR 0x8000011C
+#define DMA_INTR_PROT_WR_CMP 0x08
+
+static int send_command(struct mxl *state, u32 size, u8 *buf)
+{
+	int stat;
+	u32 val, count = 10;
+
+	mutex_lock(&state->base->i2c_lock);
+	if (state->base->fwversion > 0x02010109)  {
+		read_register_unlocked(state, DMA_I2C_INTERRUPT_ADDR, &val);
+		if (DMA_INTR_PROT_WR_CMP & val)
+			dev_info(state->i2cdev, "%s busy\n", __func__);
+		while ((DMA_INTR_PROT_WR_CMP & val) && --count) {
+			mutex_unlock(&state->base->i2c_lock);
+			usleep_range(1000, 2000);
+			mutex_lock(&state->base->i2c_lock);
+			read_register_unlocked(state, DMA_I2C_INTERRUPT_ADDR,
+					       &val);
+		}
+		if (!count) {
+			dev_info(state->i2cdev, "%s busy\n", __func__);
+			mutex_unlock(&state->base->i2c_lock);
+			return -EBUSY;
+		}
+	}
+	stat = i2cwrite(state, buf, size);
+	mutex_unlock(&state->base->i2c_lock);
+	return stat;
+}
+
+static int write_register(struct mxl *state, u32 reg, u32 val)
+{
+	int stat;
+	u8 data[MXL_HYDRA_REG_WRITE_LEN] = {
+		MXL_HYDRA_PLID_REG_WRITE, 0x08,
+		BYTE0(reg), BYTE1(reg), BYTE2(reg), BYTE3(reg),
+		BYTE0(val), BYTE1(val), BYTE2(val), BYTE3(val),
+	};
+	mutex_lock(&state->base->i2c_lock);
+	stat = i2cwrite(state, data, sizeof(data));
+	mutex_unlock(&state->base->i2c_lock);
+	if (stat)
+		dev_err(state->i2cdev, "i2c write error\n");
+	return stat;
+}
+
+static int write_firmware_block(struct mxl *state,
+				u32 reg, u32 size, u8 *reg_data_ptr)
+{
+	int stat;
+	u8 *buf = state->base->buf;
+
+	mutex_lock(&state->base->i2c_lock);
+	buf[0] = MXL_HYDRA_PLID_REG_WRITE;
+	buf[1] = size + 4;
+	buf[2] = GET_BYTE(reg, 0);
+	buf[3] = GET_BYTE(reg, 1);
+	buf[4] = GET_BYTE(reg, 2);
+	buf[5] = GET_BYTE(reg, 3);
+	memcpy(&buf[6], reg_data_ptr, size);
+	stat = i2cwrite(state, buf,
+			MXL_HYDRA_I2C_HDR_SIZE +
+			MXL_HYDRA_REG_SIZE_IN_BYTES + size);
+	mutex_unlock(&state->base->i2c_lock);
+	if (stat)
+		dev_err(state->i2cdev, "fw block write failed\n");
+	return stat;
+}
+
+static int read_register(struct mxl *state, u32 reg, u32 *val)
+{
+	int stat;
+	u8 data[MXL_HYDRA_REG_SIZE_IN_BYTES + MXL_HYDRA_I2C_HDR_SIZE] = {
+		MXL_HYDRA_PLID_REG_READ, 0x04,
+		GET_BYTE(reg, 0), GET_BYTE(reg, 1),
+		GET_BYTE(reg, 2), GET_BYTE(reg, 3),
+	};
+
+	mutex_lock(&state->base->i2c_lock);
+	stat = i2cwrite(state, data,
+			MXL_HYDRA_REG_SIZE_IN_BYTES + MXL_HYDRA_I2C_HDR_SIZE);
+	if (stat)
+		dev_err(state->i2cdev, "i2c read error 1\n");
+	if (!stat)
+		stat = i2cread(state, (u8 *) val,
+			       MXL_HYDRA_REG_SIZE_IN_BYTES);
+	mutex_unlock(&state->base->i2c_lock);
+	le32_to_cpus(val);
+	if (stat)
+		dev_err(state->i2cdev, "i2c read error 2\n");
+	return stat;
+}
+
+static int read_register_block(struct mxl *state, u32 reg, u32 size, u8 *data)
+{
+	int stat;
+	u8 *buf = state->base->buf;
+
+	mutex_lock(&state->base->i2c_lock);
+
+	buf[0] = MXL_HYDRA_PLID_REG_READ;
+	buf[1] = size + 4;
+	buf[2] = GET_BYTE(reg, 0);
+	buf[3] = GET_BYTE(reg, 1);
+	buf[4] = GET_BYTE(reg, 2);
+	buf[5] = GET_BYTE(reg, 3);
+	stat = i2cwrite(state, buf,
+			MXL_HYDRA_I2C_HDR_SIZE + MXL_HYDRA_REG_SIZE_IN_BYTES);
+	if (!stat) {
+		stat = i2cread(state, data, size);
+		convert_endian(MXL_ENABLE_BIG_ENDIAN, size, data);
+	}
+	mutex_unlock(&state->base->i2c_lock);
+	return stat;
+}
+
+static int read_by_mnemonic(struct mxl *state,
+			    u32 reg, u8 lsbloc, u8 numofbits, u32 *val)
+{
+	u32 data = 0, mask = 0;
+	int stat;
+
+	stat = read_register(state, reg, &data);
+	if (stat)
+		return stat;
+	mask = MXL_GET_REG_MASK_32(lsbloc, numofbits);
+	data &= mask;
+	data >>= lsbloc;
+	*val = data;
+	return 0;
+}
+
+
+static int update_by_mnemonic(struct mxl *state,
+			      u32 reg, u8 lsbloc, u8 numofbits, u32 val)
+{
+	u32 data, mask;
+	int stat;
+
+	stat = read_register(state, reg, &data);
+	if (stat)
+		return stat;
+	mask = MXL_GET_REG_MASK_32(lsbloc, numofbits);
+	data = (data & ~mask) | ((val << lsbloc) & mask);
+	stat = write_register(state, reg, data);
+	return stat;
+}
+
+static int firmware_is_alive(struct mxl *state)
+{
+	u32 hb0, hb1;
+
+	if (read_register(state, HYDRA_HEAR_BEAT, &hb0))
+		return 0;
+	msleep(20);
+	if (read_register(state, HYDRA_HEAR_BEAT, &hb1))
+		return 0;
+	if (hb1 == hb0)
+		return 0;
+	return 1;
+}
+
+static int init(struct dvb_frontend *fe)
+{
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
+
+	/* init fe stats */
+	p->strength.len = 1;
+	p->strength.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	p->cnr.len = 1;
+	p->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	p->pre_bit_error.len = 1;
+	p->pre_bit_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	p->pre_bit_count.len = 1;
+	p->pre_bit_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	p->post_bit_error.len = 1;
+	p->post_bit_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	p->post_bit_count.len = 1;
+	p->post_bit_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+
+	return 0;
+}
+
+static void release(struct dvb_frontend *fe)
+{
+	struct mxl *state = fe->demodulator_priv;
+
+	list_del(&state->mxl);
+	/* Release one frontend, two more shall take its place! */
+	state->base->count--;
+	if (state->base->count == 0) {
+		list_del(&state->base->mxllist);
+		kfree(state->base);
+	}
+	kfree(state);
+}
+
+static int get_algo(struct dvb_frontend *fe)
+{
+	return DVBFE_ALGO_HW;
+}
+
+static int cfg_demod_abort_tune(struct mxl *state)
+{
+	struct MXL_HYDRA_DEMOD_ABORT_TUNE_T abort_tune_cmd;
+	u8 cmd_size = sizeof(abort_tune_cmd);
+	u8 cmd_buff[MXL_HYDRA_OEM_MAX_CMD_BUFF_LEN];
+
+	abort_tune_cmd.demod_id = state->demod;
+	BUILD_HYDRA_CMD(MXL_HYDRA_ABORT_TUNE_CMD, MXL_CMD_WRITE,
+			cmd_size, &abort_tune_cmd, cmd_buff);
+	return send_command(state, cmd_size + MXL_HYDRA_CMD_HEADER_SIZE,
+			    &cmd_buff[0]);
+}
+
+static int send_master_cmd(struct dvb_frontend *fe,
+			   struct dvb_diseqc_master_cmd *cmd)
+{
+	/*struct mxl *state = fe->demodulator_priv;*/
+
+	return 0; /*CfgDemodAbortTune(state);*/
+}
+
+static int set_parameters(struct dvb_frontend *fe)
+{
+	struct mxl *state = fe->demodulator_priv;
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
+	struct MXL_HYDRA_DEMOD_PARAM_T demod_chan_cfg;
+	u8 cmd_size = sizeof(demod_chan_cfg);
+	u8 cmd_buff[MXL_HYDRA_OEM_MAX_CMD_BUFF_LEN];
+	u32 srange = 10;
+	int stat;
+
+	if (p->frequency < 950000 || p->frequency > 2150000)
+		return -EINVAL;
+	if (p->symbol_rate < 1000000 || p->symbol_rate > 45000000)
+		return -EINVAL;
+
+	/* CfgDemodAbortTune(state); */
+
+	switch (p->delivery_system) {
+	case SYS_DSS:
+		demod_chan_cfg.standard = MXL_HYDRA_DSS;
+		demod_chan_cfg.roll_off = MXL_HYDRA_ROLLOFF_AUTO;
+		break;
+	case SYS_DVBS:
+		srange = p->symbol_rate / 1000000;
+		if (srange > 10)
+			srange = 10;
+		demod_chan_cfg.standard = MXL_HYDRA_DVBS;
+		demod_chan_cfg.roll_off = MXL_HYDRA_ROLLOFF_0_35;
+		demod_chan_cfg.modulation_scheme = MXL_HYDRA_MOD_QPSK;
+		demod_chan_cfg.pilots = MXL_HYDRA_PILOTS_OFF;
+		break;
+	case SYS_DVBS2:
+		demod_chan_cfg.standard = MXL_HYDRA_DVBS2;
+		demod_chan_cfg.roll_off = MXL_HYDRA_ROLLOFF_AUTO;
+		demod_chan_cfg.modulation_scheme = MXL_HYDRA_MOD_AUTO;
+		demod_chan_cfg.pilots = MXL_HYDRA_PILOTS_AUTO;
+		/* cfg_scrambler(state); */
+		break;
+	default:
+		return -EINVAL;
+	}
+	demod_chan_cfg.tuner_index = state->tuner;
+	demod_chan_cfg.demod_index = state->demod;
+	demod_chan_cfg.frequency_in_hz = p->frequency * 1000;
+	demod_chan_cfg.symbol_rate_in_hz = p->symbol_rate;
+	demod_chan_cfg.max_carrier_offset_in_mhz = srange;
+	demod_chan_cfg.spectrum_inversion = MXL_HYDRA_SPECTRUM_AUTO;
+	demod_chan_cfg.fec_code_rate = MXL_HYDRA_FEC_AUTO;
+
+	mutex_lock(&state->base->tune_lock);
+	if (time_after(jiffies + msecs_to_jiffies(200),
+		       state->base->next_tune))
+		while (time_before(jiffies, state->base->next_tune))
+			usleep_range(10000, 11000);
+	state->base->next_tune = jiffies + msecs_to_jiffies(100);
+	state->tuner_in_use = state->tuner;
+	BUILD_HYDRA_CMD(MXL_HYDRA_DEMOD_SET_PARAM_CMD, MXL_CMD_WRITE,
+			cmd_size, &demod_chan_cfg, cmd_buff);
+	stat = send_command(state, cmd_size + MXL_HYDRA_CMD_HEADER_SIZE,
+			    &cmd_buff[0]);
+	mutex_unlock(&state->base->tune_lock);
+	return stat;
+}
+
+static int enable_tuner(struct mxl *state, u32 tuner, u32 enable);
+
+static int sleep(struct dvb_frontend *fe)
+{
+	struct mxl *state = fe->demodulator_priv;
+	struct mxl *p;
+
+	cfg_demod_abort_tune(state);
+	if (state->tuner_in_use != 0xffffffff) {
+		mutex_lock(&state->base->tune_lock);
+		state->tuner_in_use = 0xffffffff;
+		list_for_each_entry(p, &state->base->mxls, mxl) {
+			if (p->tuner_in_use == state->tuner)
+				break;
+		}
+		if (&p->mxl == &state->base->mxls)
+			enable_tuner(state, state->tuner, 0);
+		mutex_unlock(&state->base->tune_lock);
+	}
+	return 0;
+}
+
+static int read_snr(struct dvb_frontend *fe)
+{
+	struct mxl *state = fe->demodulator_priv;
+	int stat;
+	u32 reg_data = 0;
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
+
+	mutex_lock(&state->base->status_lock);
+	HYDRA_DEMOD_STATUS_LOCK(state, state->demod);
+	stat = read_register(state, (HYDRA_DMD_SNR_ADDR_OFFSET +
+				     HYDRA_DMD_STATUS_OFFSET(state->demod)),
+			     &reg_data);
+	HYDRA_DEMOD_STATUS_UNLOCK(state, state->demod);
+	mutex_unlock(&state->base->status_lock);
+
+	p->cnr.stat[0].scale = FE_SCALE_DECIBEL;
+	p->cnr.stat[0].svalue = (s16)reg_data * 10;
+
+	return stat;
+}
+
+static int read_ber(struct dvb_frontend *fe)
+{
+	struct mxl *state = fe->demodulator_priv;
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
+	u32 reg[8];
+
+	mutex_lock(&state->base->status_lock);
+	HYDRA_DEMOD_STATUS_LOCK(state, state->demod);
+	read_register_block(state,
+		(HYDRA_DMD_DVBS_1ST_CORR_RS_ERRORS_ADDR_OFFSET +
+		 HYDRA_DMD_STATUS_OFFSET(state->demod)),
+		(4 * sizeof(u32)),
+		(u8 *) &reg[0]);
+	HYDRA_DEMOD_STATUS_UNLOCK(state, state->demod);
+
+	switch (p->delivery_system) {
+	case SYS_DSS:
+	case SYS_DVBS:
+		p->pre_bit_error.stat[0].scale = FE_SCALE_COUNTER;
+		p->pre_bit_error.stat[0].uvalue = reg[2];
+		p->pre_bit_count.stat[0].scale = FE_SCALE_COUNTER;
+		p->pre_bit_count.stat[0].uvalue = reg[3];
+		break;
+	default:
+		break;
+	}
+
+	read_register_block(state,
+		(HYDRA_DMD_DVBS2_CRC_ERRORS_ADDR_OFFSET +
+		 HYDRA_DMD_STATUS_OFFSET(state->demod)),
+		(7 * sizeof(u32)),
+		(u8 *) &reg[0]);
+
+	switch (p->delivery_system) {
+	case SYS_DSS:
+	case SYS_DVBS:
+		p->post_bit_error.stat[0].scale = FE_SCALE_COUNTER;
+		p->post_bit_error.stat[0].uvalue = reg[5];
+		p->post_bit_count.stat[0].scale = FE_SCALE_COUNTER;
+		p->post_bit_count.stat[0].uvalue = reg[6];
+		break;
+	case SYS_DVBS2:
+		p->post_bit_error.stat[0].scale = FE_SCALE_COUNTER;
+		p->post_bit_error.stat[0].uvalue = reg[1];
+		p->post_bit_count.stat[0].scale = FE_SCALE_COUNTER;
+		p->post_bit_count.stat[0].uvalue = reg[2];
+		break;
+	default:
+		break;
+	}
+
+	mutex_unlock(&state->base->status_lock);
+
+	return 0;
+}
+
+static int read_signal_strength(struct dvb_frontend *fe)
+{
+	struct mxl *state = fe->demodulator_priv;
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
+	int stat;
+	u32 reg_data = 0;
+
+	mutex_lock(&state->base->status_lock);
+	HYDRA_DEMOD_STATUS_LOCK(state, state->demod);
+	stat = read_register(state, (HYDRA_DMD_STATUS_INPUT_POWER_ADDR +
+				     HYDRA_DMD_STATUS_OFFSET(state->demod)),
+			     &reg_data);
+	HYDRA_DEMOD_STATUS_UNLOCK(state, state->demod);
+	mutex_unlock(&state->base->status_lock);
+
+	p->strength.stat[0].scale = FE_SCALE_DECIBEL;
+	p->strength.stat[0].svalue = (s16) reg_data * 10; /* fix scale */
+
+	return stat;
+}
+
+static int read_status(struct dvb_frontend *fe, enum fe_status *status)
+{
+	struct mxl *state = fe->demodulator_priv;
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
+	u32 reg_data = 0;
+
+	mutex_lock(&state->base->status_lock);
+	HYDRA_DEMOD_STATUS_LOCK(state, state->demod);
+	read_register(state, (HYDRA_DMD_LOCK_STATUS_ADDR_OFFSET +
+			     HYDRA_DMD_STATUS_OFFSET(state->demod)),
+			     &reg_data);
+	HYDRA_DEMOD_STATUS_UNLOCK(state, state->demod);
+	mutex_unlock(&state->base->status_lock);
+
+	*status = (reg_data == 1) ? 0x1f : 0;
+
+	/* signal statistics */
+
+	/* signal strength is always available */
+	read_signal_strength(fe);
+
+	if (*status & FE_HAS_CARRIER)
+		read_snr(fe);
+	else
+		p->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+
+	if (*status & FE_HAS_SYNC)
+		read_ber(fe);
+	else {
+		p->pre_bit_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+		p->pre_bit_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+		p->post_bit_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+		p->post_bit_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	}
+
+	return 0;
+}
+
+static int tune(struct dvb_frontend *fe, bool re_tune,
+		unsigned int mode_flags,
+		unsigned int *delay, enum fe_status *status)
+{
+	struct mxl *state = fe->demodulator_priv;
+	int r = 0;
+
+	*delay = HZ / 2;
+	if (re_tune) {
+		r = set_parameters(fe);
+		if (r)
+			return r;
+		state->tune_time = jiffies;
+		return 0;
+	}
+	if (*status & FE_HAS_LOCK)
+		return 0;
+
+	r = read_status(fe, status);
+	if (r)
+		return r;
+
+	return 0;
+}
+
+static enum fe_code_rate conv_fec(enum MXL_HYDRA_FEC_E fec)
+{
+	enum fe_code_rate fec2fec[11] = {
+		FEC_NONE, FEC_1_2, FEC_3_5, FEC_2_3,
+		FEC_3_4, FEC_4_5, FEC_5_6, FEC_6_7,
+		FEC_7_8, FEC_8_9, FEC_9_10
+	};
+
+	if (fec > MXL_HYDRA_FEC_9_10)
+		return FEC_NONE;
+	return fec2fec[fec];
+}
+
+static int get_frontend(struct dvb_frontend *fe,
+			struct dtv_frontend_properties *p)
+{
+	struct mxl *state = fe->demodulator_priv;
+	u32 reg_data[MXL_DEMOD_CHAN_PARAMS_BUFF_SIZE];
+	u32 freq;
+
+	mutex_lock(&state->base->status_lock);
+	HYDRA_DEMOD_STATUS_LOCK(state, state->demod);
+	read_register_block(state,
+		(HYDRA_DMD_STANDARD_ADDR_OFFSET +
+		HYDRA_DMD_STATUS_OFFSET(state->demod)),
+		(MXL_DEMOD_CHAN_PARAMS_BUFF_SIZE * 4), /* 25 * 4 bytes */
+		(u8 *) &reg_data[0]);
+	/* read demod channel parameters */
+	read_register_block(state,
+		(HYDRA_DMD_STATUS_CENTER_FREQ_IN_KHZ_ADDR +
+		HYDRA_DMD_STATUS_OFFSET(state->demod)),
+		(4), /* 4 bytes */
+		(u8 *) &freq);
+	HYDRA_DEMOD_STATUS_UNLOCK(state, state->demod);
+	mutex_unlock(&state->base->status_lock);
+
+	dev_dbg(state->i2cdev, "freq=%u delsys=%u srate=%u\n",
+		freq * 1000, reg_data[DMD_STANDARD_ADDR],
+		reg_data[DMD_SYMBOL_RATE_ADDR]);
+	p->symbol_rate = reg_data[DMD_SYMBOL_RATE_ADDR];
+	p->frequency = freq;
+	/*
+	 * p->delivery_system =
+	 *	(MXL_HYDRA_BCAST_STD_E) regData[DMD_STANDARD_ADDR];
+	 * p->inversion =
+	 *	(MXL_HYDRA_SPECTRUM_E) regData[DMD_SPECTRUM_INVERSION_ADDR];
+	 * freqSearchRangeKHz =
+	 *	(regData[DMD_FREQ_SEARCH_RANGE_IN_KHZ_ADDR]);
+	 */
+
+	p->fec_inner = conv_fec(reg_data[DMD_FEC_CODE_RATE_ADDR]);
+	switch (p->delivery_system) {
+	case SYS_DSS:
+		break;
+	case SYS_DVBS2:
+		switch ((enum MXL_HYDRA_PILOTS_E)
+			reg_data[DMD_DVBS2_PILOT_ON_OFF_ADDR]) {
+		case MXL_HYDRA_PILOTS_OFF:
+			p->pilot = PILOT_OFF;
+			break;
+		case MXL_HYDRA_PILOTS_ON:
+			p->pilot = PILOT_ON;
+			break;
+		default:
+			break;
+		}
+	case SYS_DVBS:
+		switch ((enum MXL_HYDRA_MODULATION_E)
+			reg_data[DMD_MODULATION_SCHEME_ADDR]) {
+		case MXL_HYDRA_MOD_QPSK:
+			p->modulation = QPSK;
+			break;
+		case MXL_HYDRA_MOD_8PSK:
+			p->modulation = PSK_8;
+			break;
+		default:
+			break;
+		}
+		switch ((enum MXL_HYDRA_ROLLOFF_E)
+			reg_data[DMD_SPECTRUM_ROLL_OFF_ADDR]) {
+		case MXL_HYDRA_ROLLOFF_0_20:
+			p->rolloff = ROLLOFF_20;
+			break;
+		case MXL_HYDRA_ROLLOFF_0_35:
+			p->rolloff = ROLLOFF_35;
+			break;
+		case MXL_HYDRA_ROLLOFF_0_25:
+			p->rolloff = ROLLOFF_25;
+			break;
+		default:
+			break;
+		}
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int set_input(struct dvb_frontend *fe, int input)
+{
+	struct mxl *state = fe->demodulator_priv;
+
+	state->tuner = input;
+	return 0;
+}
+
+static struct dvb_frontend_ops mxl_ops = {
+	.delsys = { SYS_DVBS, SYS_DVBS2, SYS_DSS },
+	.info = {
+		.name			= "MaxLinear MxL5xx DVB-S/S2 tuner-demodulator",
+		.frequency_min		= 300000,
+		.frequency_max		= 2350000,
+		.frequency_stepsize	= 0,
+		.frequency_tolerance	= 0,
+		.symbol_rate_min	= 1000000,
+		.symbol_rate_max	= 45000000,
+		.caps			= FE_CAN_INVERSION_AUTO |
+					  FE_CAN_FEC_AUTO       |
+					  FE_CAN_QPSK           |
+					  FE_CAN_2G_MODULATION
+	},
+	.init				= init,
+	.release                        = release,
+	.get_frontend_algo              = get_algo,
+	.tune                           = tune,
+	.read_status			= read_status,
+	.sleep				= sleep,
+	.get_frontend                   = get_frontend,
+	.diseqc_send_master_cmd		= send_master_cmd,
+};
+
+static struct mxl_base *match_base(struct i2c_adapter  *i2c, u8 adr)
+{
+	struct mxl_base *p;
+
+	list_for_each_entry(p, &mxllist, mxllist)
+		if (p->i2c == i2c && p->adr == adr)
+			return p;
+	return NULL;
+}
+
+static void cfg_dev_xtal(struct mxl *state, u32 freq, u32 cap, u32 enable)
+{
+	if (state->base->can_clkout || !enable)
+		update_by_mnemonic(state, 0x90200054, 23, 1, enable);
+
+	if (freq == 24000000)
+		write_register(state, HYDRA_CRYSTAL_SETTING, 0);
+	else
+		write_register(state, HYDRA_CRYSTAL_SETTING, 1);
+
+	write_register(state, HYDRA_CRYSTAL_CAP, cap);
+}
+
+static u32 get_big_endian(u8 num_of_bits, const u8 buf[])
+{
+	u32 ret_value = 0;
+
+	switch (num_of_bits) {
+	case 24:
+		ret_value = (((u32) buf[0]) << 16) |
+			(((u32) buf[1]) << 8) | buf[2];
+		break;
+	case 32:
+		ret_value = (((u32) buf[0]) << 24) |
+			(((u32) buf[1]) << 16) |
+			(((u32) buf[2]) << 8) | buf[3];
+		break;
+	default:
+		break;
+	}
+
+	return ret_value;
+}
+
+static int write_fw_segment(struct mxl *state,
+			    u32 mem_addr, u32 total_size, u8 *data_ptr)
+{
+	int status;
+	u32 data_count = 0;
+	u32 size = 0;
+	u32 orig_size = 0;
+	u8 *w_buf_ptr = NULL;
+	u32 block_size = ((MXL_HYDRA_OEM_MAX_BLOCK_WRITE_LENGTH -
+			 (MXL_HYDRA_I2C_HDR_SIZE +
+			  MXL_HYDRA_REG_SIZE_IN_BYTES)) / 4) * 4;
+	u8 w_msg_buffer[MXL_HYDRA_OEM_MAX_BLOCK_WRITE_LENGTH -
+		      (MXL_HYDRA_I2C_HDR_SIZE + MXL_HYDRA_REG_SIZE_IN_BYTES)];
+
+	do {
+		size = orig_size = (((u32)(data_count + block_size)) > total_size) ?
+			(total_size - data_count) : block_size;
+
+		if (orig_size & 3)
+			size = (orig_size + 4) & ~3;
+		w_buf_ptr = &w_msg_buffer[0];
+		memset((void *) w_buf_ptr, 0, size);
+		memcpy((void *) w_buf_ptr, (void *) data_ptr, orig_size);
+		convert_endian(1, size, w_buf_ptr);
+		status  = write_firmware_block(state, mem_addr, size, w_buf_ptr);
+		if (status)
+			return status;
+		data_count += size;
+		mem_addr   += size;
+		data_ptr   += size;
+	} while (data_count < total_size);
+
+	return status;
+}
+
+static int do_firmware_download(struct mxl *state, u8 *mbin_buffer_ptr,
+				u32 mbin_buffer_size)
+
+{
+	int status;
+	u32 index = 0;
+	u32 seg_length = 0;
+	u32 seg_address = 0;
+	struct MBIN_FILE_T *mbin_ptr  = (struct MBIN_FILE_T *)mbin_buffer_ptr;
+	struct MBIN_SEGMENT_T *segment_ptr;
+	enum MXL_BOOL_E xcpu_fw_flag = MXL_FALSE;
+
+	if (mbin_ptr->header.id != MBIN_FILE_HEADER_ID) {
+		dev_err(state->i2cdev, "%s: Invalid file header ID (%c)\n",
+		       __func__, mbin_ptr->header.id);
+		return -EINVAL;
+	}
+	status = write_register(state, FW_DL_SIGN_ADDR, 0);
+	if (status)
+		return status;
+	segment_ptr = (struct MBIN_SEGMENT_T *) (&mbin_ptr->data[0]);
+	for (index = 0; index < mbin_ptr->header.num_segments; index++) {
+		if (segment_ptr->header.id != MBIN_SEGMENT_HEADER_ID) {
+			dev_err(state->i2cdev, "%s: Invalid segment header ID (%c)\n",
+			       __func__, segment_ptr->header.id);
+			return -EINVAL;
+		}
+		seg_length  = get_big_endian(24,
+					    &(segment_ptr->header.len24[0]));
+		seg_address = get_big_endian(32,
+					    &(segment_ptr->header.address[0]));
+
+		if (state->base->type == MXL_HYDRA_DEVICE_568) {
+			if ((((seg_address & 0x90760000) == 0x90760000) ||
+			     ((seg_address & 0x90740000) == 0x90740000)) &&
+			    (xcpu_fw_flag == MXL_FALSE)) {
+				update_by_mnemonic(state, 0x8003003C, 0, 1, 1);
+				msleep(200);
+				write_register(state, 0x90720000, 0);
+				usleep_range(10000, 11000);
+				xcpu_fw_flag = MXL_TRUE;
+			}
+			status = write_fw_segment(state, seg_address,
+						  seg_length,
+						  (u8 *) segment_ptr->data);
+		} else {
+			if (((seg_address & 0x90760000) != 0x90760000) &&
+			    ((seg_address & 0x90740000) != 0x90740000))
+				status = write_fw_segment(state, seg_address,
+					seg_length, (u8 *) segment_ptr->data);
+		}
+		if (status)
+			return status;
+		segment_ptr = (struct MBIN_SEGMENT_T *)
+			&(segment_ptr->data[((seg_length + 3) / 4) * 4]);
+	}
+	return status;
+}
+
+static int check_fw(struct mxl *state, u8 *mbin, u32 mbin_len)
+{
+	struct MBIN_FILE_HEADER_T *fh = (struct MBIN_FILE_HEADER_T *) mbin;
+	u32 flen = (fh->image_size24[0] << 16) |
+		(fh->image_size24[1] <<  8) | fh->image_size24[2];
+	u8 *fw, cs = 0;
+	u32 i;
+
+	if (fh->id != 'M' || fh->fmt_version != '1' || flen > 0x3FFF0) {
+		dev_info(state->i2cdev, "Invalid FW Header\n");
+		return -1;
+	}
+	fw = mbin + sizeof(struct MBIN_FILE_HEADER_T);
+	for (i = 0; i < flen; i += 1)
+		cs += fw[i];
+	if (cs != fh->image_checksum) {
+		dev_info(state->i2cdev, "Invalid FW Checksum\n");
+		return -1;
+	}
+	return 0;
+}
+
+static int firmware_download(struct mxl *state, u8 *mbin, u32 mbin_len)
+{
+	int status;
+	u32 reg_data = 0;
+	struct MXL_HYDRA_SKU_COMMAND_T dev_sku_cfg;
+	u8 cmd_size = sizeof(struct MXL_HYDRA_SKU_COMMAND_T);
+	u8 cmd_buff[sizeof(struct MXL_HYDRA_SKU_COMMAND_T) + 6];
+
+	if (check_fw(state, mbin, mbin_len))
+		return -1;
+
+	/* put CPU into reset */
+	status = update_by_mnemonic(state, 0x8003003C, 0, 1, 0);
+	if (status)
+		return status;
+	usleep_range(1000, 2000);
+
+	/* Reset TX FIFO's, BBAND, XBAR */
+	status = write_register(state, HYDRA_RESET_TRANSPORT_FIFO_REG,
+				HYDRA_RESET_TRANSPORT_FIFO_DATA);
+	if (status)
+		return status;
+	status = write_register(state, HYDRA_RESET_BBAND_REG,
+				HYDRA_RESET_BBAND_DATA);
+	if (status)
+		return status;
+	status = write_register(state, HYDRA_RESET_XBAR_REG,
+				HYDRA_RESET_XBAR_DATA);
+	if (status)
+		return status;
+
+	/* Disable clock to Baseband, Wideband, SerDes,
+	 * Alias ext & Transport modules
+	 */
+	status = write_register(state, HYDRA_MODULES_CLK_2_REG,
+				HYDRA_DISABLE_CLK_2);
+	if (status)
+		return status;
+	/* Clear Software & Host interrupt status - (Clear on read) */
+	status = read_register(state, HYDRA_PRCM_ROOT_CLK_REG, &reg_data);
+	if (status)
+		return status;
+	status = do_firmware_download(state, mbin, mbin_len);
+	if (status)
+		return status;
+
+	if (state->base->type == MXL_HYDRA_DEVICE_568) {
+		usleep_range(10000, 11000);
+
+		/* bring XCPU out of reset */
+		status = write_register(state, 0x90720000, 1);
+		if (status)
+			return status;
+		msleep(500);
+
+		/* Enable XCPU UART message processing in MCPU */
+		status = write_register(state, 0x9076B510, 1);
+		if (status)
+			return status;
+	} else {
+		/* Bring CPU out of reset */
+		status = update_by_mnemonic(state, 0x8003003C, 0, 1, 1);
+		if (status)
+			return status;
+		/* Wait until FW boots */
+		msleep(150);
+	}
+
+	/* Initialize XPT XBAR */
+	status = write_register(state, XPT_DMD0_BASEADDR, 0x76543210);
+	if (status)
+		return status;
+
+	if (!firmware_is_alive(state))
+		return -1;
+
+	dev_info(state->i2cdev, "Hydra FW alive. Hail!\n");
+
+	/* sometimes register values are wrong shortly
+	 * after first heart beats
+	 */
+	msleep(50);
+
+	dev_sku_cfg.sku_type = state->base->sku_type;
+	BUILD_HYDRA_CMD(MXL_HYDRA_DEV_CFG_SKU_CMD, MXL_CMD_WRITE,
+			cmd_size, &dev_sku_cfg, cmd_buff);
+	status = send_command(state, cmd_size + MXL_HYDRA_CMD_HEADER_SIZE,
+			      &cmd_buff[0]);
+
+	return status;
+}
+
+static int cfg_ts_pad_mux(struct mxl *state, enum MXL_BOOL_E enable_serial_ts)
+{
+	int status = 0;
+	u32 pad_mux_value = 0;
+
+	if (enable_serial_ts == MXL_TRUE) {
+		pad_mux_value = 0;
+		if ((state->base->type == MXL_HYDRA_DEVICE_541) ||
+		    (state->base->type == MXL_HYDRA_DEVICE_541S))
+			pad_mux_value = 2;
+	} else {
+		if ((state->base->type == MXL_HYDRA_DEVICE_581) ||
+		    (state->base->type == MXL_HYDRA_DEVICE_581S))
+			pad_mux_value = 2;
+		else
+			pad_mux_value = 3;
+	}
+
+	switch (state->base->type) {
+	case MXL_HYDRA_DEVICE_561:
+	case MXL_HYDRA_DEVICE_581:
+	case MXL_HYDRA_DEVICE_541:
+	case MXL_HYDRA_DEVICE_541S:
+	case MXL_HYDRA_DEVICE_561S:
+	case MXL_HYDRA_DEVICE_581S:
+		status |= update_by_mnemonic(state, 0x90000170, 24, 3,
+					     pad_mux_value);
+		status |= update_by_mnemonic(state, 0x90000170, 28, 3,
+					     pad_mux_value);
+		status |= update_by_mnemonic(state, 0x90000174, 0, 3,
+					     pad_mux_value);
+		status |= update_by_mnemonic(state, 0x90000174, 4, 3,
+					     pad_mux_value);
+		status |= update_by_mnemonic(state, 0x90000174, 8, 3,
+					     pad_mux_value);
+		status |= update_by_mnemonic(state, 0x90000174, 12, 3,
+					     pad_mux_value);
+		status |= update_by_mnemonic(state, 0x90000174, 16, 3,
+					     pad_mux_value);
+		status |= update_by_mnemonic(state, 0x90000174, 20, 3,
+					     pad_mux_value);
+		status |= update_by_mnemonic(state, 0x90000174, 24, 3,
+					     pad_mux_value);
+		status |= update_by_mnemonic(state, 0x90000174, 28, 3,
+					     pad_mux_value);
+		status |= update_by_mnemonic(state, 0x90000178, 0, 3,
+					     pad_mux_value);
+		status |= update_by_mnemonic(state, 0x90000178, 4, 3,
+					     pad_mux_value);
+		status |= update_by_mnemonic(state, 0x90000178, 8, 3,
+					     pad_mux_value);
+		break;
+
+	case MXL_HYDRA_DEVICE_544:
+	case MXL_HYDRA_DEVICE_542:
+		status |= update_by_mnemonic(state, 0x9000016C, 4, 3, 1);
+		status |= update_by_mnemonic(state, 0x9000016C, 8, 3, 0);
+		status |= update_by_mnemonic(state, 0x9000016C, 12, 3, 0);
+		status |= update_by_mnemonic(state, 0x9000016C, 16, 3, 0);
+		status |= update_by_mnemonic(state, 0x90000170, 0, 3, 0);
+		status |= update_by_mnemonic(state, 0x90000178, 12, 3, 1);
+		status |= update_by_mnemonic(state, 0x90000178, 16, 3, 1);
+		status |= update_by_mnemonic(state, 0x90000178, 20, 3, 1);
+		status |= update_by_mnemonic(state, 0x90000178, 24, 3, 1);
+		status |= update_by_mnemonic(state, 0x9000017C, 0, 3, 1);
+		status |= update_by_mnemonic(state, 0x9000017C, 4, 3, 1);
+		if (enable_serial_ts == MXL_ENABLE) {
+			status |= update_by_mnemonic(state,
+				0x90000170, 4, 3, 0);
+			status |= update_by_mnemonic(state,
+				0x90000170, 8, 3, 0);
+			status |= update_by_mnemonic(state,
+				0x90000170, 12, 3, 0);
+			status |= update_by_mnemonic(state,
+				0x90000170, 16, 3, 0);
+			status |= update_by_mnemonic(state,
+				0x90000170, 20, 3, 1);
+			status |= update_by_mnemonic(state,
+				0x90000170, 24, 3, 1);
+			status |= update_by_mnemonic(state,
+				0x90000170, 28, 3, 2);
+			status |= update_by_mnemonic(state,
+				0x90000174, 0, 3, 2);
+			status |= update_by_mnemonic(state,
+				0x90000174, 4, 3, 2);
+			status |= update_by_mnemonic(state,
+				0x90000174, 8, 3, 2);
+			status |= update_by_mnemonic(state,
+				0x90000174, 12, 3, 2);
+			status |= update_by_mnemonic(state,
+				0x90000174, 16, 3, 2);
+			status |= update_by_mnemonic(state,
+				0x90000174, 20, 3, 2);
+			status |= update_by_mnemonic(state,
+				0x90000174, 24, 3, 2);
+			status |= update_by_mnemonic(state,
+				0x90000174, 28, 3, 2);
+			status |= update_by_mnemonic(state,
+				0x90000178, 0, 3, 2);
+			status |= update_by_mnemonic(state,
+				0x90000178, 4, 3, 2);
+			status |= update_by_mnemonic(state,
+				0x90000178, 8, 3, 2);
+		} else {
+			status |= update_by_mnemonic(state,
+				0x90000170, 4, 3, 3);
+			status |= update_by_mnemonic(state,
+				0x90000170, 8, 3, 3);
+			status |= update_by_mnemonic(state,
+				0x90000170, 12, 3, 3);
+			status |= update_by_mnemonic(state,
+				0x90000170, 16, 3, 3);
+			status |= update_by_mnemonic(state,
+				0x90000170, 20, 3, 3);
+			status |= update_by_mnemonic(state,
+				0x90000170, 24, 3, 3);
+			status |= update_by_mnemonic(state,
+				0x90000170, 28, 3, 3);
+			status |= update_by_mnemonic(state,
+				0x90000174, 0, 3, 3);
+			status |= update_by_mnemonic(state,
+				0x90000174, 4, 3, 3);
+			status |= update_by_mnemonic(state,
+				0x90000174, 8, 3, 3);
+			status |= update_by_mnemonic(state,
+				0x90000174, 12, 3, 3);
+			status |= update_by_mnemonic(state,
+				0x90000174, 16, 3, 3);
+			status |= update_by_mnemonic(state,
+				0x90000174, 20, 3, 1);
+			status |= update_by_mnemonic(state,
+				0x90000174, 24, 3, 1);
+			status |= update_by_mnemonic(state,
+				0x90000174, 28, 3, 1);
+			status |= update_by_mnemonic(state,
+				0x90000178, 0, 3, 1);
+			status |= update_by_mnemonic(state,
+				0x90000178, 4, 3, 1);
+			status |= update_by_mnemonic(state,
+				0x90000178, 8, 3, 1);
+		}
+		break;
+
+	case MXL_HYDRA_DEVICE_568:
+		if (enable_serial_ts == MXL_FALSE) {
+			status |= update_by_mnemonic(state,
+				0x9000016C, 8, 3, 5);
+			status |= update_by_mnemonic(state,
+				0x9000016C, 12, 3, 5);
+			status |= update_by_mnemonic(state,
+				0x9000016C, 16, 3, 5);
+			status |= update_by_mnemonic(state,
+				0x9000016C, 20, 3, 5);
+			status |= update_by_mnemonic(state,
+				0x9000016C, 24, 3, 5);
+			status |= update_by_mnemonic(state,
+				0x9000016C, 28, 3, 5);
+			status |= update_by_mnemonic(state,
+				0x90000170, 0, 3, 5);
+			status |= update_by_mnemonic(state,
+				0x90000170, 4, 3, 5);
+			status |= update_by_mnemonic(state,
+				0x90000170, 8, 3, 5);
+			status |= update_by_mnemonic(state,
+				0x90000170, 12, 3, 5);
+			status |= update_by_mnemonic(state,
+				0x90000170, 16, 3, 5);
+			status |= update_by_mnemonic(state,
+				0x90000170, 20, 3, 5);
+
+			status |= update_by_mnemonic(state,
+				0x90000170, 24, 3, pad_mux_value);
+			status |= update_by_mnemonic(state,
+				0x90000174, 0, 3, pad_mux_value);
+			status |= update_by_mnemonic(state,
+				0x90000174, 4, 3, pad_mux_value);
+			status |= update_by_mnemonic(state,
+				0x90000174, 8, 3, pad_mux_value);
+			status |= update_by_mnemonic(state,
+				0x90000174, 12, 3, pad_mux_value);
+			status |= update_by_mnemonic(state,
+				0x90000174, 16, 3, pad_mux_value);
+			status |= update_by_mnemonic(state,
+				0x90000174, 20, 3, pad_mux_value);
+			status |= update_by_mnemonic(state,
+				0x90000174, 24, 3, pad_mux_value);
+			status |= update_by_mnemonic(state,
+				0x90000174, 28, 3, pad_mux_value);
+			status |= update_by_mnemonic(state,
+				0x90000178, 0, 3, pad_mux_value);
+			status |= update_by_mnemonic(state,
+				0x90000178, 4, 3, pad_mux_value);
+
+			status |= update_by_mnemonic(state,
+				0x90000178, 8, 3, 5);
+			status |= update_by_mnemonic(state,
+				0x90000178, 12, 3, 5);
+			status |= update_by_mnemonic(state,
+				0x90000178, 16, 3, 5);
+			status |= update_by_mnemonic(state,
+				0x90000178, 20, 3, 5);
+			status |= update_by_mnemonic(state,
+				0x90000178, 24, 3, 5);
+			status |= update_by_mnemonic(state,
+				0x90000178, 28, 3, 5);
+			status |= update_by_mnemonic(state,
+				0x9000017C, 0, 3, 5);
+			status |= update_by_mnemonic(state,
+				0x9000017C, 4, 3, 5);
+		} else {
+			status |= update_by_mnemonic(state,
+				0x90000170, 4, 3, pad_mux_value);
+			status |= update_by_mnemonic(state,
+				0x90000170, 8, 3, pad_mux_value);
+			status |= update_by_mnemonic(state,
+				0x90000170, 12, 3, pad_mux_value);
+			status |= update_by_mnemonic(state,
+				0x90000170, 16, 3, pad_mux_value);
+			status |= update_by_mnemonic(state,
+				0x90000170, 20, 3, pad_mux_value);
+			status |= update_by_mnemonic(state,
+				0x90000170, 24, 3, pad_mux_value);
+			status |= update_by_mnemonic(state,
+				0x90000170, 28, 3, pad_mux_value);
+			status |= update_by_mnemonic(state,
+				0x90000174, 0, 3, pad_mux_value);
+			status |= update_by_mnemonic(state,
+				0x90000174, 4, 3, pad_mux_value);
+			status |= update_by_mnemonic(state,
+				0x90000174, 8, 3, pad_mux_value);
+			status |= update_by_mnemonic(state,
+				0x90000174, 12, 3, pad_mux_value);
+		}
+		break;
+
+
+	case MXL_HYDRA_DEVICE_584:
+	default:
+		status |= update_by_mnemonic(state,
+			0x90000170, 4, 3, pad_mux_value);
+		status |= update_by_mnemonic(state,
+			0x90000170, 8, 3, pad_mux_value);
+		status |= update_by_mnemonic(state,
+			0x90000170, 12, 3, pad_mux_value);
+		status |= update_by_mnemonic(state,
+			0x90000170, 16, 3, pad_mux_value);
+		status |= update_by_mnemonic(state,
+			0x90000170, 20, 3, pad_mux_value);
+		status |= update_by_mnemonic(state,
+			0x90000170, 24, 3, pad_mux_value);
+		status |= update_by_mnemonic(state,
+			0x90000170, 28, 3, pad_mux_value);
+		status |= update_by_mnemonic(state,
+			0x90000174, 0, 3, pad_mux_value);
+		status |= update_by_mnemonic(state,
+			0x90000174, 4, 3, pad_mux_value);
+		status |= update_by_mnemonic(state,
+			0x90000174, 8, 3, pad_mux_value);
+		status |= update_by_mnemonic(state,
+			0x90000174, 12, 3, pad_mux_value);
+		break;
+	}
+	return status;
+}
+
+static int set_drive_strength(struct mxl *state,
+		enum MXL_HYDRA_TS_DRIVE_STRENGTH_E ts_drive_strength)
+{
+	int stat = 0;
+	u32 val;
+
+	read_register(state, 0x90000194, &val);
+	dev_info(state->i2cdev, "DIGIO = %08x\n", val);
+	dev_info(state->i2cdev, "set drive_strength = %u\n", ts_drive_strength);
+
+
+	stat |= update_by_mnemonic(state, 0x90000194, 0, 3, ts_drive_strength);
+	stat |= update_by_mnemonic(state, 0x90000194, 20, 3, ts_drive_strength);
+	stat |= update_by_mnemonic(state, 0x90000194, 24, 3, ts_drive_strength);
+	stat |= update_by_mnemonic(state, 0x90000198, 12, 3, ts_drive_strength);
+	stat |= update_by_mnemonic(state, 0x90000198, 16, 3, ts_drive_strength);
+	stat |= update_by_mnemonic(state, 0x90000198, 20, 3, ts_drive_strength);
+	stat |= update_by_mnemonic(state, 0x90000198, 24, 3, ts_drive_strength);
+	stat |= update_by_mnemonic(state, 0x9000019C, 0, 3, ts_drive_strength);
+	stat |= update_by_mnemonic(state, 0x9000019C, 4, 3, ts_drive_strength);
+	stat |= update_by_mnemonic(state, 0x9000019C, 8, 3, ts_drive_strength);
+	stat |= update_by_mnemonic(state, 0x9000019C, 24, 3, ts_drive_strength);
+	stat |= update_by_mnemonic(state, 0x9000019C, 28, 3, ts_drive_strength);
+	stat |= update_by_mnemonic(state, 0x900001A0, 0, 3, ts_drive_strength);
+	stat |= update_by_mnemonic(state, 0x900001A0, 4, 3, ts_drive_strength);
+	stat |= update_by_mnemonic(state, 0x900001A0, 20, 3, ts_drive_strength);
+	stat |= update_by_mnemonic(state, 0x900001A0, 24, 3, ts_drive_strength);
+	stat |= update_by_mnemonic(state, 0x900001A0, 28, 3, ts_drive_strength);
+
+	return stat;
+}
+
+static int enable_tuner(struct mxl *state, u32 tuner, u32 enable)
+{
+	int stat = 0;
+	struct MXL_HYDRA_TUNER_CMD ctrl_tuner_cmd;
+	u8 cmd_size = sizeof(ctrl_tuner_cmd);
+	u8 cmd_buff[MXL_HYDRA_OEM_MAX_CMD_BUFF_LEN];
+	u32 val, count = 10;
+
+	ctrl_tuner_cmd.tuner_id = tuner;
+	ctrl_tuner_cmd.enable = enable;
+	BUILD_HYDRA_CMD(MXL_HYDRA_TUNER_ACTIVATE_CMD, MXL_CMD_WRITE,
+			cmd_size, &ctrl_tuner_cmd, cmd_buff);
+	stat = send_command(state, cmd_size + MXL_HYDRA_CMD_HEADER_SIZE,
+			    &cmd_buff[0]);
+	if (stat)
+		return stat;
+	read_register(state, HYDRA_TUNER_ENABLE_COMPLETE, &val);
+	while (--count && ((val >> tuner) & 1) != enable) {
+		msleep(20);
+		read_register(state, HYDRA_TUNER_ENABLE_COMPLETE, &val);
+	}
+	if (!count)
+		return -1;
+	read_register(state, HYDRA_TUNER_ENABLE_COMPLETE, &val);
+	dev_dbg(state->i2cdev, "tuner %u ready = %u\n",
+		tuner, (val >> tuner) & 1);
+
+	return 0;
+}
+
+
+static int config_ts(struct mxl *state, enum MXL_HYDRA_DEMOD_ID_E demod_id,
+		     struct MXL_HYDRA_MPEGOUT_PARAM_T *mpeg_out_param_ptr)
+{
+	int status = 0;
+	u32 nco_count_min = 0;
+	u32 clk_type = 0;
+
+	struct MXL_REG_FIELD_T xpt_sync_polarity[MXL_HYDRA_DEMOD_MAX] = {
+		{0x90700010, 8, 1}, {0x90700010, 9, 1},
+		{0x90700010, 10, 1}, {0x90700010, 11, 1},
+		{0x90700010, 12, 1}, {0x90700010, 13, 1},
+		{0x90700010, 14, 1}, {0x90700010, 15, 1} };
+	struct MXL_REG_FIELD_T xpt_clock_polarity[MXL_HYDRA_DEMOD_MAX] = {
+		{0x90700010, 16, 1}, {0x90700010, 17, 1},
+		{0x90700010, 18, 1}, {0x90700010, 19, 1},
+		{0x90700010, 20, 1}, {0x90700010, 21, 1},
+		{0x90700010, 22, 1}, {0x90700010, 23, 1} };
+	struct MXL_REG_FIELD_T xpt_valid_polarity[MXL_HYDRA_DEMOD_MAX] = {
+		{0x90700014, 0, 1}, {0x90700014, 1, 1},
+		{0x90700014, 2, 1}, {0x90700014, 3, 1},
+		{0x90700014, 4, 1}, {0x90700014, 5, 1},
+		{0x90700014, 6, 1}, {0x90700014, 7, 1} };
+	struct MXL_REG_FIELD_T xpt_ts_clock_phase[MXL_HYDRA_DEMOD_MAX] = {
+		{0x90700018, 0, 3}, {0x90700018, 4, 3},
+		{0x90700018, 8, 3}, {0x90700018, 12, 3},
+		{0x90700018, 16, 3}, {0x90700018, 20, 3},
+		{0x90700018, 24, 3}, {0x90700018, 28, 3} };
+	struct MXL_REG_FIELD_T xpt_lsb_first[MXL_HYDRA_DEMOD_MAX] = {
+		{0x9070000C, 16, 1}, {0x9070000C, 17, 1},
+		{0x9070000C, 18, 1}, {0x9070000C, 19, 1},
+		{0x9070000C, 20, 1}, {0x9070000C, 21, 1},
+		{0x9070000C, 22, 1}, {0x9070000C, 23, 1} };
+	struct MXL_REG_FIELD_T xpt_sync_byte[MXL_HYDRA_DEMOD_MAX] = {
+		{0x90700010, 0, 1}, {0x90700010, 1, 1},
+		{0x90700010, 2, 1}, {0x90700010, 3, 1},
+		{0x90700010, 4, 1}, {0x90700010, 5, 1},
+		{0x90700010, 6, 1}, {0x90700010, 7, 1} };
+	struct MXL_REG_FIELD_T xpt_enable_output[MXL_HYDRA_DEMOD_MAX] = {
+		{0x9070000C, 0, 1}, {0x9070000C, 1, 1},
+		{0x9070000C, 2, 1}, {0x9070000C, 3, 1},
+		{0x9070000C, 4, 1}, {0x9070000C, 5, 1},
+		{0x9070000C, 6, 1}, {0x9070000C, 7, 1} };
+	struct MXL_REG_FIELD_T xpt_err_replace_sync[MXL_HYDRA_DEMOD_MAX] = {
+		{0x9070000C, 24, 1}, {0x9070000C, 25, 1},
+		{0x9070000C, 26, 1}, {0x9070000C, 27, 1},
+		{0x9070000C, 28, 1}, {0x9070000C, 29, 1},
+		{0x9070000C, 30, 1}, {0x9070000C, 31, 1} };
+	struct MXL_REG_FIELD_T xpt_err_replace_valid[MXL_HYDRA_DEMOD_MAX] = {
+		{0x90700014, 8, 1}, {0x90700014, 9, 1},
+		{0x90700014, 10, 1}, {0x90700014, 11, 1},
+		{0x90700014, 12, 1}, {0x90700014, 13, 1},
+		{0x90700014, 14, 1}, {0x90700014, 15, 1} };
+	struct MXL_REG_FIELD_T xpt_continuous_clock[MXL_HYDRA_DEMOD_MAX] = {
+		{0x907001D4, 0, 1}, {0x907001D4, 1, 1},
+		{0x907001D4, 2, 1}, {0x907001D4, 3, 1},
+		{0x907001D4, 4, 1}, {0x907001D4, 5, 1},
+		{0x907001D4, 6, 1}, {0x907001D4, 7, 1} };
+	struct MXL_REG_FIELD_T xpt_nco_clock_rate[MXL_HYDRA_DEMOD_MAX] = {
+		{0x90700044, 16, 80}, {0x90700044, 16, 81},
+		{0x90700044, 16, 82}, {0x90700044, 16, 83},
+		{0x90700044, 16, 84}, {0x90700044, 16, 85},
+		{0x90700044, 16, 86}, {0x90700044, 16, 87} };
+
+	demod_id = state->base->ts_map[demod_id];
+
+	if (mpeg_out_param_ptr->enable == MXL_ENABLE) {
+		if (mpeg_out_param_ptr->mpeg_mode ==
+		    MXL_HYDRA_MPEG_MODE_PARALLEL) {
+		} else {
+			cfg_ts_pad_mux(state, MXL_TRUE);
+			update_by_mnemonic(state,
+				0x90700010, 27, 1, MXL_FALSE);
+		}
+	}
+
+	nco_count_min =
+		(u32)(MXL_HYDRA_NCO_CLK / mpeg_out_param_ptr->max_mpeg_clk_rate);
+
+	if (state->base->chipversion >= 2) {
+		status |= update_by_mnemonic(state,
+			xpt_nco_clock_rate[demod_id].reg_addr, /* Reg Addr */
+			xpt_nco_clock_rate[demod_id].lsb_pos, /* LSB pos */
+			xpt_nco_clock_rate[demod_id].num_of_bits, /* Num of bits */
+			nco_count_min); /* Data */
+	} else
+		update_by_mnemonic(state, 0x90700044, 16, 8, nco_count_min);
+
+	if (mpeg_out_param_ptr->mpeg_clk_type == MXL_HYDRA_MPEG_CLK_CONTINUOUS)
+		clk_type = 1;
+
+	if (mpeg_out_param_ptr->mpeg_mode < MXL_HYDRA_MPEG_MODE_PARALLEL) {
+		status |= update_by_mnemonic(state,
+			xpt_continuous_clock[demod_id].reg_addr,
+			xpt_continuous_clock[demod_id].lsb_pos,
+			xpt_continuous_clock[demod_id].num_of_bits,
+			clk_type);
+	} else
+		update_by_mnemonic(state, 0x907001D4, 8, 1, clk_type);
+
+	status |= update_by_mnemonic(state,
+		xpt_sync_polarity[demod_id].reg_addr,
+		xpt_sync_polarity[demod_id].lsb_pos,
+		xpt_sync_polarity[demod_id].num_of_bits,
+		mpeg_out_param_ptr->mpeg_sync_pol);
+
+	status |= update_by_mnemonic(state,
+		xpt_valid_polarity[demod_id].reg_addr,
+		xpt_valid_polarity[demod_id].lsb_pos,
+		xpt_valid_polarity[demod_id].num_of_bits,
+		mpeg_out_param_ptr->mpeg_valid_pol);
+
+	status |= update_by_mnemonic(state,
+		xpt_clock_polarity[demod_id].reg_addr,
+		xpt_clock_polarity[demod_id].lsb_pos,
+		xpt_clock_polarity[demod_id].num_of_bits,
+		mpeg_out_param_ptr->mpeg_clk_pol);
+
+	status |= update_by_mnemonic(state,
+		xpt_sync_byte[demod_id].reg_addr,
+		xpt_sync_byte[demod_id].lsb_pos,
+		xpt_sync_byte[demod_id].num_of_bits,
+		mpeg_out_param_ptr->mpeg_sync_pulse_width);
+
+	status |= update_by_mnemonic(state,
+		xpt_ts_clock_phase[demod_id].reg_addr,
+		xpt_ts_clock_phase[demod_id].lsb_pos,
+		xpt_ts_clock_phase[demod_id].num_of_bits,
+		mpeg_out_param_ptr->mpeg_clk_phase);
+
+	status |= update_by_mnemonic(state,
+		xpt_lsb_first[demod_id].reg_addr,
+		xpt_lsb_first[demod_id].lsb_pos,
+		xpt_lsb_first[demod_id].num_of_bits,
+		mpeg_out_param_ptr->lsb_or_msb_first);
+
+	switch (mpeg_out_param_ptr->mpeg_error_indication) {
+	case MXL_HYDRA_MPEG_ERR_REPLACE_SYNC:
+		status |= update_by_mnemonic(state,
+			xpt_err_replace_sync[demod_id].reg_addr,
+			xpt_err_replace_sync[demod_id].lsb_pos,
+			xpt_err_replace_sync[demod_id].num_of_bits,
+			MXL_TRUE);
+		status |= update_by_mnemonic(state,
+			xpt_err_replace_valid[demod_id].reg_addr,
+			xpt_err_replace_valid[demod_id].lsb_pos,
+			xpt_err_replace_valid[demod_id].num_of_bits,
+			MXL_FALSE);
+		break;
+
+	case MXL_HYDRA_MPEG_ERR_REPLACE_VALID:
+		status |= update_by_mnemonic(state,
+			xpt_err_replace_sync[demod_id].reg_addr,
+			xpt_err_replace_sync[demod_id].lsb_pos,
+			xpt_err_replace_sync[demod_id].num_of_bits,
+			MXL_FALSE);
+
+		status |= update_by_mnemonic(state,
+			xpt_err_replace_valid[demod_id].reg_addr,
+			xpt_err_replace_valid[demod_id].lsb_pos,
+			xpt_err_replace_valid[demod_id].num_of_bits,
+			MXL_TRUE);
+		break;
+
+	case MXL_HYDRA_MPEG_ERR_INDICATION_DISABLED:
+	default:
+		status |= update_by_mnemonic(state,
+			xpt_err_replace_sync[demod_id].reg_addr,
+			xpt_err_replace_sync[demod_id].lsb_pos,
+			xpt_err_replace_sync[demod_id].num_of_bits,
+			MXL_FALSE);
+
+		status |= update_by_mnemonic(state,
+			xpt_err_replace_valid[demod_id].reg_addr,
+			xpt_err_replace_valid[demod_id].lsb_pos,
+			xpt_err_replace_valid[demod_id].num_of_bits,
+			MXL_FALSE);
+
+		break;
+
+	}
+
+	if (mpeg_out_param_ptr->mpeg_mode != MXL_HYDRA_MPEG_MODE_PARALLEL) {
+		status |= update_by_mnemonic(state,
+			xpt_enable_output[demod_id].reg_addr,
+			xpt_enable_output[demod_id].lsb_pos,
+			xpt_enable_output[demod_id].num_of_bits,
+			mpeg_out_param_ptr->enable);
+	}
+	return status;
+}
+
+static int config_mux(struct mxl *state)
+{
+	update_by_mnemonic(state, 0x9070000C, 0, 1, 0);
+	update_by_mnemonic(state, 0x9070000C, 1, 1, 0);
+	update_by_mnemonic(state, 0x9070000C, 2, 1, 0);
+	update_by_mnemonic(state, 0x9070000C, 3, 1, 0);
+	update_by_mnemonic(state, 0x9070000C, 4, 1, 0);
+	update_by_mnemonic(state, 0x9070000C, 5, 1, 0);
+	update_by_mnemonic(state, 0x9070000C, 6, 1, 0);
+	update_by_mnemonic(state, 0x9070000C, 7, 1, 0);
+	update_by_mnemonic(state, 0x90700008, 0, 2, 1);
+	update_by_mnemonic(state, 0x90700008, 2, 2, 1);
+	return 0;
+}
+
+static int load_fw(struct mxl *state, struct mxl5xx_cfg *cfg)
+{
+	int stat = 0;
+	u8 *buf;
+
+	if (cfg->fw)
+		return firmware_download(state, cfg->fw, cfg->fw_len);
+
+	if (!cfg->fw_read)
+		return -1;
+
+	buf = vmalloc(0x40000);
+	if (!buf)
+		return -ENOMEM;
+
+	cfg->fw_read(cfg->fw_priv, buf, 0x40000);
+	stat = firmware_download(state, buf, 0x40000);
+	vfree(buf);
+
+	return stat;
+}
+
+static int validate_sku(struct mxl *state)
+{
+	u32 pad_mux_bond = 0, prcm_chip_id = 0, prcm_so_cid = 0;
+	int status;
+	u32 type = state->base->type;
+
+	status = read_by_mnemonic(state, 0x90000190, 0, 3, &pad_mux_bond);
+	status |= read_by_mnemonic(state, 0x80030000, 0, 12, &prcm_chip_id);
+	status |= read_by_mnemonic(state, 0x80030004, 24, 8, &prcm_so_cid);
+	if (status)
+		return -1;
+
+	dev_info(state->i2cdev, "padMuxBond=%08x, prcmChipId=%08x, prcmSoCId=%08x\n",
+		pad_mux_bond, prcm_chip_id, prcm_so_cid);
+
+	if (prcm_chip_id != 0x560) {
+		switch (pad_mux_bond) {
+		case MXL_HYDRA_SKU_ID_581:
+			if (type == MXL_HYDRA_DEVICE_581)
+				return 0;
+			if (type == MXL_HYDRA_DEVICE_581S) {
+				state->base->type = MXL_HYDRA_DEVICE_581;
+				return 0;
+			}
+			break;
+		case MXL_HYDRA_SKU_ID_584:
+			if (type == MXL_HYDRA_DEVICE_584)
+				return 0;
+			break;
+		case MXL_HYDRA_SKU_ID_544:
+			if (type == MXL_HYDRA_DEVICE_544)
+				return 0;
+			if (type == MXL_HYDRA_DEVICE_542)
+				return 0;
+			break;
+		case MXL_HYDRA_SKU_ID_582:
+			if (type == MXL_HYDRA_DEVICE_582)
+				return 0;
+			break;
+		default:
+			return -1;
+		}
+	} else {
+
+	}
+	return -1;
+}
+
+static int get_fwinfo(struct mxl *state)
+{
+	int status;
+	u32 val = 0;
+
+	status = read_by_mnemonic(state, 0x90000190, 0, 3, &val);
+	if (status)
+		return status;
+	dev_info(state->i2cdev, "chipID=%08x\n", val);
+
+	status = read_by_mnemonic(state, 0x80030004, 8, 8, &val);
+	if (status)
+		return status;
+	dev_info(state->i2cdev, "chipVer=%08x\n", val);
+
+	status = read_register(state, HYDRA_FIRMWARE_VERSION, &val);
+	if (status)
+		return status;
+	dev_info(state->i2cdev, "FWVer=%08x\n", val);
+
+	state->base->fwversion = val;
+	return status;
+}
+
+
+static u8 ts_map1_to_1[MXL_HYDRA_DEMOD_MAX] = {
+	MXL_HYDRA_DEMOD_ID_0,
+	MXL_HYDRA_DEMOD_ID_1,
+	MXL_HYDRA_DEMOD_ID_2,
+	MXL_HYDRA_DEMOD_ID_3,
+	MXL_HYDRA_DEMOD_ID_4,
+	MXL_HYDRA_DEMOD_ID_5,
+	MXL_HYDRA_DEMOD_ID_6,
+	MXL_HYDRA_DEMOD_ID_7,
+};
+
+static u8 ts_map54x[MXL_HYDRA_DEMOD_MAX] = {
+	MXL_HYDRA_DEMOD_ID_2,
+	MXL_HYDRA_DEMOD_ID_3,
+	MXL_HYDRA_DEMOD_ID_4,
+	MXL_HYDRA_DEMOD_ID_5,
+	MXL_HYDRA_DEMOD_MAX,
+	MXL_HYDRA_DEMOD_MAX,
+	MXL_HYDRA_DEMOD_MAX,
+	MXL_HYDRA_DEMOD_MAX,
+};
+
+static int probe(struct mxl *state, struct mxl5xx_cfg *cfg)
+{
+	u32 chipver;
+	int fw, status, j;
+	struct MXL_HYDRA_MPEGOUT_PARAM_T mpeg_interface_cfg;
+
+	state->base->ts_map = ts_map1_to_1;
+
+	switch (state->base->type) {
+	case MXL_HYDRA_DEVICE_581:
+	case MXL_HYDRA_DEVICE_581S:
+		state->base->can_clkout = 1;
+		state->base->demod_num = 8;
+		state->base->tuner_num = 1;
+		state->base->sku_type = MXL_HYDRA_SKU_TYPE_581;
+		break;
+	case MXL_HYDRA_DEVICE_582:
+		state->base->can_clkout = 1;
+		state->base->demod_num = 8;
+		state->base->tuner_num = 3;
+		state->base->sku_type = MXL_HYDRA_SKU_TYPE_582;
+		break;
+	case MXL_HYDRA_DEVICE_585:
+		state->base->can_clkout = 0;
+		state->base->demod_num = 8;
+		state->base->tuner_num = 4;
+		state->base->sku_type = MXL_HYDRA_SKU_TYPE_585;
+		break;
+	case MXL_HYDRA_DEVICE_544:
+		state->base->can_clkout = 0;
+		state->base->demod_num = 4;
+		state->base->tuner_num = 4;
+		state->base->sku_type = MXL_HYDRA_SKU_TYPE_544;
+		state->base->ts_map = ts_map54x;
+		break;
+	case MXL_HYDRA_DEVICE_541:
+	case MXL_HYDRA_DEVICE_541S:
+		state->base->can_clkout = 0;
+		state->base->demod_num = 4;
+		state->base->tuner_num = 1;
+		state->base->sku_type = MXL_HYDRA_SKU_TYPE_541;
+		state->base->ts_map = ts_map54x;
+		break;
+	case MXL_HYDRA_DEVICE_561:
+	case MXL_HYDRA_DEVICE_561S:
+		state->base->can_clkout = 0;
+		state->base->demod_num = 6;
+		state->base->tuner_num = 1;
+		state->base->sku_type = MXL_HYDRA_SKU_TYPE_561;
+		break;
+	case MXL_HYDRA_DEVICE_568:
+		state->base->can_clkout = 0;
+		state->base->demod_num = 8;
+		state->base->tuner_num = 1;
+		state->base->chan_bond = 1;
+		state->base->sku_type = MXL_HYDRA_SKU_TYPE_568;
+		break;
+	case MXL_HYDRA_DEVICE_542:
+		state->base->can_clkout = 1;
+		state->base->demod_num = 4;
+		state->base->tuner_num = 3;
+		state->base->sku_type = MXL_HYDRA_SKU_TYPE_542;
+		state->base->ts_map = ts_map54x;
+		break;
+	case MXL_HYDRA_DEVICE_TEST:
+	case MXL_HYDRA_DEVICE_584:
+	default:
+		state->base->can_clkout = 0;
+		state->base->demod_num = 8;
+		state->base->tuner_num = 4;
+		state->base->sku_type = MXL_HYDRA_SKU_TYPE_584;
+		break;
+	}
+
+	status = validate_sku(state);
+	if (status)
+		return status;
+
+	update_by_mnemonic(state, 0x80030014, 9, 1, 1);
+	update_by_mnemonic(state, 0x8003003C, 12, 1, 1);
+	status = read_by_mnemonic(state, 0x80030000, 12, 4, &chipver);
+	if (status)
+		state->base->chipversion = 0;
+	else
+		state->base->chipversion = (chipver == 2) ? 2 : 1;
+	dev_info(state->i2cdev, "Hydra chip version %u\n",
+		state->base->chipversion);
+
+	cfg_dev_xtal(state, cfg->clk, cfg->cap, 0);
+
+	fw = firmware_is_alive(state);
+	if (!fw) {
+		status = load_fw(state, cfg);
+		if (status)
+			return status;
+	}
+	get_fwinfo(state);
+
+	config_mux(state);
+	mpeg_interface_cfg.enable = MXL_ENABLE;
+	mpeg_interface_cfg.lsb_or_msb_first = MXL_HYDRA_MPEG_SERIAL_MSB_1ST;
+	/*  supports only (0-104&139)MHz */
+	if (cfg->ts_clk)
+		mpeg_interface_cfg.max_mpeg_clk_rate = cfg->ts_clk;
+	else
+		mpeg_interface_cfg.max_mpeg_clk_rate = 69; /* 139; */
+	mpeg_interface_cfg.mpeg_clk_phase = MXL_HYDRA_MPEG_CLK_PHASE_SHIFT_0_DEG;
+	mpeg_interface_cfg.mpeg_clk_pol = MXL_HYDRA_MPEG_CLK_IN_PHASE;
+	/* MXL_HYDRA_MPEG_CLK_GAPPED; */
+	mpeg_interface_cfg.mpeg_clk_type = MXL_HYDRA_MPEG_CLK_CONTINUOUS;
+	mpeg_interface_cfg.mpeg_error_indication =
+		MXL_HYDRA_MPEG_ERR_INDICATION_DISABLED;
+	mpeg_interface_cfg.mpeg_mode = MXL_HYDRA_MPEG_MODE_SERIAL_3_WIRE;
+	mpeg_interface_cfg.mpeg_sync_pol  = MXL_HYDRA_MPEG_ACTIVE_HIGH;
+	mpeg_interface_cfg.mpeg_sync_pulse_width  = MXL_HYDRA_MPEG_SYNC_WIDTH_BIT;
+	mpeg_interface_cfg.mpeg_valid_pol  = MXL_HYDRA_MPEG_ACTIVE_HIGH;
+
+	for (j = 0; j < state->base->demod_num; j++) {
+		status = config_ts(state, (enum MXL_HYDRA_DEMOD_ID_E) j,
+				   &mpeg_interface_cfg);
+		if (status)
+			return status;
+	}
+	set_drive_strength(state, 1);
+	return 0;
+}
+
+struct dvb_frontend *mxl5xx_attach(struct i2c_adapter *i2c,
+	struct mxl5xx_cfg *cfg, u32 demod, u32 tuner,
+	int (**fn_set_input)(struct dvb_frontend *, int))
+{
+	struct mxl *state;
+	struct mxl_base *base;
+
+	state = kzalloc(sizeof(struct mxl), GFP_KERNEL);
+	if (!state)
+		return NULL;
+
+	state->demod = demod;
+	state->tuner = tuner;
+	state->tuner_in_use = 0xffffffff;
+	state->i2cdev = &i2c->dev;
+
+	base = match_base(i2c, cfg->adr);
+	if (base) {
+		base->count++;
+		if (base->count > base->demod_num)
+			goto fail;
+		state->base = base;
+	} else {
+		base = kzalloc(sizeof(struct mxl_base), GFP_KERNEL);
+		if (!base)
+			goto fail;
+		base->i2c = i2c;
+		base->adr = cfg->adr;
+		base->type = cfg->type;
+		base->count = 1;
+		mutex_init(&base->i2c_lock);
+		mutex_init(&base->status_lock);
+		mutex_init(&base->tune_lock);
+		INIT_LIST_HEAD(&base->mxls);
+
+		state->base = base;
+		if (probe(state, cfg) < 0) {
+			kfree(base);
+			goto fail;
+		}
+		list_add(&base->mxllist, &mxllist);
+	}
+	state->fe.ops               = mxl_ops;
+	state->xbar[0]              = 4;
+	state->xbar[1]              = demod;
+	state->xbar[2]              = 8;
+	state->fe.demodulator_priv  = state;
+	*fn_set_input               = set_input;
+
+	list_add(&state->mxl, &base->mxls);
+	return &state->fe;
+
+fail:
+	kfree(state);
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(mxl5xx_attach);
+
+MODULE_DESCRIPTION("MaxLinear MxL5xx DVB-S/S2 tuner-demodulator driver");
+MODULE_AUTHOR("Ralph and Marcus Metzler, Metzler Brothers Systementwicklung GbR");
+MODULE_LICENSE("GPL");
diff --git a/drivers/media/dvb-frontends/mxl5xx.h b/drivers/media/dvb-frontends/mxl5xx.h
new file mode 100644
index 000000000000..532e08111537
--- /dev/null
+++ b/drivers/media/dvb-frontends/mxl5xx.h
@@ -0,0 +1,41 @@
+#ifndef _MXL5XX_H_
+#define _MXL5XX_H_
+
+#include <linux/types.h>
+#include <linux/i2c.h>
+
+#include "dvb_frontend.h"
+
+struct mxl5xx_cfg {
+	u8   adr;
+	u8   type;
+	u32  cap;
+	u32  clk;
+	u32  ts_clk;
+
+	u8  *fw;
+	u32  fw_len;
+
+	int (*fw_read)(void *priv, u8 *buf, u32 len);
+	void *fw_priv;
+};
+
+#if IS_REACHABLE(CONFIG_DVB_MXL5XX)
+
+extern struct dvb_frontend *mxl5xx_attach(struct i2c_adapter *i2c,
+	struct mxl5xx_cfg *cfg, u32 demod, u32 tuner,
+	int (**fn_set_input)(struct dvb_frontend *, int));
+
+#else
+
+static inline struct dvb_frontend *mxl5xx_attach(struct i2c_adapter *i2c,
+	struct mxl5xx_cfg *cfg, u32 demod, u32 tuner,
+	int (**fn_set_input)(struct dvb_frontend *, int))
+{
+	pr_warn("%s: driver disabled by Kconfig\n", __func__);
+	return NULL;
+}
+
+#endif /* CONFIG_DVB_MXL5XX */
+
+#endif /* _MXL5XX_H_ */
diff --git a/drivers/media/dvb-frontends/mxl5xx_defs.h b/drivers/media/dvb-frontends/mxl5xx_defs.h
new file mode 100644
index 000000000000..fd9e61e0188f
--- /dev/null
+++ b/drivers/media/dvb-frontends/mxl5xx_defs.h
@@ -0,0 +1,731 @@
+/*
+ * Defines for the Maxlinear MX58x family of tuners/demods
+ *
+ * Copyright (C) 2014 Digital Devices GmbH
+ *
+ * based on code:
+ * Copyright (c) 2011-2013 MaxLinear, Inc. All rights reserved
+ * which was released under GPL V2
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2, as published by the Free Software Foundation.
+ */
+
+enum MXL_BOOL_E {
+	MXL_DISABLE = 0,
+	MXL_ENABLE  = 1,
+
+	MXL_FALSE = 0,
+	MXL_TRUE  = 1,
+
+	MXL_INVALID = 0,
+	MXL_VALID   = 1,
+
+	MXL_NO      = 0,
+	MXL_YES     = 1,
+
+	MXL_OFF     = 0,
+	MXL_ON      = 1
+};
+
+/* Firmware-Host Command IDs */
+enum MXL_HYDRA_HOST_CMD_ID_E {
+	/* --Device command IDs-- */
+	MXL_HYDRA_DEV_NO_OP_CMD = 0, /* No OP */
+
+	MXL_HYDRA_DEV_SET_POWER_MODE_CMD = 1,
+	MXL_HYDRA_DEV_SET_OVERWRITE_DEF_CMD = 2,
+
+	/* Host-used CMD, not used by firmware */
+	MXL_HYDRA_DEV_FIRMWARE_DOWNLOAD_CMD = 3,
+
+	/* Additional CONTROL types from DTV */
+	MXL_HYDRA_DEV_SET_BROADCAST_PID_STB_ID_CMD = 4,
+	MXL_HYDRA_DEV_GET_PMM_SLEEP_CMD = 5,
+
+	/* --Tuner command IDs-- */
+	MXL_HYDRA_TUNER_TUNE_CMD = 6,
+	MXL_HYDRA_TUNER_GET_STATUS_CMD = 7,
+
+	/* --Demod command IDs-- */
+	MXL_HYDRA_DEMOD_SET_PARAM_CMD = 8,
+	MXL_HYDRA_DEMOD_GET_STATUS_CMD = 9,
+
+	MXL_HYDRA_DEMOD_RESET_FEC_COUNTER_CMD = 10,
+
+	MXL_HYDRA_DEMOD_SET_PKT_NUM_CMD = 11,
+
+	MXL_HYDRA_DEMOD_SET_IQ_SOURCE_CMD = 12,
+	MXL_HYDRA_DEMOD_GET_IQ_DATA_CMD = 13,
+
+	MXL_HYDRA_DEMOD_GET_M68HC05_VER_CMD = 14,
+
+	MXL_HYDRA_DEMOD_SET_ERROR_COUNTER_MODE_CMD = 15,
+
+	/* --- ABORT channel tune */
+	MXL_HYDRA_ABORT_TUNE_CMD = 16, /* Abort current tune command. */
+
+	/* --SWM/FSK command IDs-- */
+	MXL_HYDRA_FSK_RESET_CMD = 17,
+	MXL_HYDRA_FSK_MSG_CMD = 18,
+	MXL_HYDRA_FSK_SET_OP_MODE_CMD = 19,
+
+	/* --DiSeqC command IDs-- */
+	MXL_HYDRA_DISEQC_MSG_CMD = 20,
+	MXL_HYDRA_DISEQC_COPY_MSG_TO_MAILBOX = 21,
+	MXL_HYDRA_DISEQC_CFG_MSG_CMD = 22,
+
+	/* --- FFT Debug Command IDs-- */
+	MXL_HYDRA_REQ_FFT_SPECTRUM_CMD = 23,
+
+	/* -- Demod scramblle code */
+	MXL_HYDRA_DEMOD_SCRAMBLE_CODE_CMD = 24,
+
+	/* ---For host to know how many commands in total */
+	MXL_HYDRA_LAST_HOST_CMD = 25,
+
+	MXL_HYDRA_DEMOD_INTR_TYPE_CMD = 47,
+	MXL_HYDRA_DEV_INTR_CLEAR_CMD = 48,
+	MXL_HYDRA_TUNER_SPECTRUM_REQ_CMD = 53,
+	MXL_HYDRA_TUNER_ACTIVATE_CMD = 55,
+	MXL_HYDRA_DEV_CFG_POWER_MODE_CMD = 56,
+	MXL_HYDRA_DEV_XTAL_CAP_CMD = 57,
+	MXL_HYDRA_DEV_CFG_SKU_CMD = 58,
+	MXL_HYDRA_TUNER_SPECTRUM_MIN_GAIN_CMD = 59,
+	MXL_HYDRA_DISEQC_CONT_TONE_CFG = 60,
+	MXL_HYDRA_DEV_RF_WAKE_UP_CMD = 61,
+	MXL_HYDRA_DEMOD_CFG_EQ_CTRL_PARAM_CMD = 62,
+	MXL_HYDRA_DEMOD_FREQ_OFFSET_SEARCH_RANGE_CMD = 63,
+	MXL_HYDRA_DEV_REQ_PWR_FROM_ADCRSSI_CMD = 64,
+
+	MXL_XCPU_PID_FLT_CFG_CMD = 65,
+	MXL_XCPU_SHMEM_TEST_CMD = 66,
+	MXL_XCPU_ABORT_TUNE_CMD = 67,
+	MXL_XCPU_CHAN_TUNE_CMD = 68,
+	MXL_XCPU_FLT_BOND_HDRS_CMD = 69,
+
+	MXL_HYDRA_DEV_BROADCAST_WAKE_UP_CMD = 70,
+	MXL_HYDRA_FSK_CFG_FSK_FREQ_CMD = 71,
+	MXL_HYDRA_FSK_POWER_DOWN_CMD = 72,
+	MXL_XCPU_CLEAR_CB_STATS_CMD = 73,
+	MXL_XCPU_CHAN_BOND_RESTART_CMD = 74
+};
+
+#define MXL_ENABLE_BIG_ENDIAN        (0)
+
+#define MXL_HYDRA_OEM_MAX_BLOCK_WRITE_LENGTH   248
+
+#define MXL_HYDRA_OEM_MAX_CMD_BUFF_LEN        (248)
+
+#define MXL_HYDRA_CAP_MIN     10
+#define MXL_HYDRA_CAP_MAX     33
+
+#define MXL_HYDRA_PLID_REG_READ       0xFB   /* Read register PLID */
+#define MXL_HYDRA_PLID_REG_WRITE      0xFC   /* Write register PLID */
+
+#define MXL_HYDRA_PLID_CMD_READ       0xFD   /* Command Read PLID */
+#define MXL_HYDRA_PLID_CMD_WRITE      0xFE   /* Command Write PLID */
+
+#define MXL_HYDRA_REG_SIZE_IN_BYTES   4      /* Hydra register size in bytes */
+#define MXL_HYDRA_I2C_HDR_SIZE        (2 * sizeof(u8)) /* PLID + LEN(0xFF) */
+#define MXL_HYDRA_CMD_HEADER_SIZE     (MXL_HYDRA_REG_SIZE_IN_BYTES + MXL_HYDRA_I2C_HDR_SIZE)
+
+#define MXL_HYDRA_SKU_ID_581 0
+#define MXL_HYDRA_SKU_ID_584 1
+#define MXL_HYDRA_SKU_ID_585 2
+#define MXL_HYDRA_SKU_ID_544 3
+#define MXL_HYDRA_SKU_ID_561 4
+#define MXL_HYDRA_SKU_ID_582 5
+#define MXL_HYDRA_SKU_ID_568 6
+
+/* macro for register write data buffer size
+ * (PLID + LEN (0xFF) + RegAddr + RegData)
+ */
+#define MXL_HYDRA_REG_WRITE_LEN       (MXL_HYDRA_I2C_HDR_SIZE + (2 * MXL_HYDRA_REG_SIZE_IN_BYTES))
+
+/* macro to extract a single byte from 4-byte(32-bit) data */
+#define GET_BYTE(x, n)  (((x) >> (8*(n))) & 0xFF)
+
+#define MAX_CMD_DATA 512
+
+#define MXL_GET_REG_MASK_32(lsb_loc, num_of_bits) ((0xFFFFFFFF >> (32 - (num_of_bits))) << (lsb_loc))
+
+#define FW_DL_SIGN (0xDEADBEEF)
+
+#define MBIN_FORMAT_VERSION               '1'
+#define MBIN_FILE_HEADER_ID               'M'
+#define MBIN_SEGMENT_HEADER_ID            'S'
+#define MBIN_MAX_FILE_LENGTH              (1<<23)
+
+struct MBIN_FILE_HEADER_T {
+	u8 id;
+	u8 fmt_version;
+	u8 header_len;
+	u8 num_segments;
+	u8 entry_address[4];
+	u8 image_size24[3];
+	u8 image_checksum;
+	u8 reserved[4];
+};
+
+struct MBIN_FILE_T {
+	struct MBIN_FILE_HEADER_T header;
+	u8 data[1];
+};
+
+struct MBIN_SEGMENT_HEADER_T {
+	u8 id;
+	u8 len24[3];
+	u8 address[4];
+};
+
+struct MBIN_SEGMENT_T {
+	struct MBIN_SEGMENT_HEADER_T header;
+	u8 data[1];
+};
+
+enum MXL_CMD_TYPE_E { MXL_CMD_WRITE = 0, MXL_CMD_READ };
+
+#define BUILD_HYDRA_CMD(cmd_id, req_type, size, data_ptr, cmd_buff)		\
+	do {								\
+		cmd_buff[0] = ((req_type == MXL_CMD_WRITE) ? MXL_HYDRA_PLID_CMD_WRITE : MXL_HYDRA_PLID_CMD_READ); \
+		cmd_buff[1] = (size > 251) ? 0xff : (u8) (size + 4);	\
+		cmd_buff[2] = size;					\
+		cmd_buff[3] = cmd_id;					\
+		cmd_buff[4] = 0x00;					\
+		cmd_buff[5] = 0x00;					\
+		convert_endian(MXL_ENABLE_BIG_ENDIAN, size, (u8 *)data_ptr); \
+		memcpy((void *)&cmd_buff[6], data_ptr, size);		\
+	} while (0)
+
+struct MXL_REG_FIELD_T {
+	u32 reg_addr;
+	u8 lsb_pos;
+	u8 num_of_bits;
+};
+
+struct MXL_DEV_CMD_DATA_T {
+	u32 data_size;
+	u8 data[MAX_CMD_DATA];
+};
+
+enum MXL_HYDRA_SKU_TYPE_E {
+	MXL_HYDRA_SKU_TYPE_MIN = 0x00,
+	MXL_HYDRA_SKU_TYPE_581 = 0x00,
+	MXL_HYDRA_SKU_TYPE_584 = 0x01,
+	MXL_HYDRA_SKU_TYPE_585 = 0x02,
+	MXL_HYDRA_SKU_TYPE_544 = 0x03,
+	MXL_HYDRA_SKU_TYPE_561 = 0x04,
+	MXL_HYDRA_SKU_TYPE_5XX = 0x05,
+	MXL_HYDRA_SKU_TYPE_5YY = 0x06,
+	MXL_HYDRA_SKU_TYPE_511 = 0x07,
+	MXL_HYDRA_SKU_TYPE_561_DE = 0x08,
+	MXL_HYDRA_SKU_TYPE_582 = 0x09,
+	MXL_HYDRA_SKU_TYPE_541 = 0x0A,
+	MXL_HYDRA_SKU_TYPE_568 = 0x0B,
+	MXL_HYDRA_SKU_TYPE_542 = 0x0C,
+	MXL_HYDRA_SKU_TYPE_MAX = 0x0D,
+};
+
+struct MXL_HYDRA_SKU_COMMAND_T {
+	enum MXL_HYDRA_SKU_TYPE_E sku_type;
+};
+
+enum MXL_HYDRA_DEMOD_ID_E {
+	MXL_HYDRA_DEMOD_ID_0 = 0,
+	MXL_HYDRA_DEMOD_ID_1,
+	MXL_HYDRA_DEMOD_ID_2,
+	MXL_HYDRA_DEMOD_ID_3,
+	MXL_HYDRA_DEMOD_ID_4,
+	MXL_HYDRA_DEMOD_ID_5,
+	MXL_HYDRA_DEMOD_ID_6,
+	MXL_HYDRA_DEMOD_ID_7,
+	MXL_HYDRA_DEMOD_MAX
+};
+
+#define MXL_DEMOD_SCRAMBLE_SEQ_LEN  12
+
+#define MAX_STEP_SIZE_24_XTAL_102_05_KHZ  195
+#define MAX_STEP_SIZE_24_XTAL_204_10_KHZ  215
+#define MAX_STEP_SIZE_24_XTAL_306_15_KHZ  203
+#define MAX_STEP_SIZE_24_XTAL_408_20_KHZ  177
+
+#define MAX_STEP_SIZE_27_XTAL_102_05_KHZ  195
+#define MAX_STEP_SIZE_27_XTAL_204_10_KHZ  215
+#define MAX_STEP_SIZE_27_XTAL_306_15_KHZ  203
+#define MAX_STEP_SIZE_27_XTAL_408_20_KHZ  177
+
+#define MXL_HYDRA_SPECTRUM_MIN_FREQ_KHZ  300000
+#define MXL_HYDRA_SPECTRUM_MAX_FREQ_KHZ 2350000
+
+enum MXL_DEMOD_CHAN_PARAMS_OFFSET_E {
+	DMD_STANDARD_ADDR = 0,
+	DMD_SPECTRUM_INVERSION_ADDR,
+	DMD_SPECTRUM_ROLL_OFF_ADDR,
+	DMD_SYMBOL_RATE_ADDR,
+	DMD_MODULATION_SCHEME_ADDR,
+	DMD_FEC_CODE_RATE_ADDR,
+	DMD_SNR_ADDR,
+	DMD_FREQ_OFFSET_ADDR,
+	DMD_CTL_FREQ_OFFSET_ADDR,
+	DMD_STR_FREQ_OFFSET_ADDR,
+	DMD_FTL_FREQ_OFFSET_ADDR,
+	DMD_STR_NBC_SYNC_LOCK_ADDR,
+	DMD_CYCLE_SLIP_COUNT_ADDR,
+	DMD_DISPLAY_IQ_ADDR,
+	DMD_DVBS2_CRC_ERRORS_ADDR,
+	DMD_DVBS2_PER_COUNT_ADDR,
+	DMD_DVBS2_PER_WINDOW_ADDR,
+	DMD_DVBS_CORR_RS_ERRORS_ADDR,
+	DMD_DVBS_UNCORR_RS_ERRORS_ADDR,
+	DMD_DVBS_BER_COUNT_ADDR,
+	DMD_DVBS_BER_WINDOW_ADDR,
+	DMD_TUNER_ID_ADDR,
+	DMD_DVBS2_PILOT_ON_OFF_ADDR,
+	DMD_FREQ_SEARCH_RANGE_IN_KHZ_ADDR,
+
+	MXL_DEMOD_CHAN_PARAMS_BUFF_SIZE,
+};
+
+enum MXL_HYDRA_TUNER_ID_E {
+	MXL_HYDRA_TUNER_ID_0 = 0,
+	MXL_HYDRA_TUNER_ID_1,
+	MXL_HYDRA_TUNER_ID_2,
+	MXL_HYDRA_TUNER_ID_3,
+	MXL_HYDRA_TUNER_MAX
+};
+
+enum MXL_HYDRA_BCAST_STD_E {
+	MXL_HYDRA_DSS = 0,
+	MXL_HYDRA_DVBS,
+	MXL_HYDRA_DVBS2,
+};
+
+enum MXL_HYDRA_FEC_E {
+	MXL_HYDRA_FEC_AUTO = 0,
+	MXL_HYDRA_FEC_1_2,
+	MXL_HYDRA_FEC_3_5,
+	MXL_HYDRA_FEC_2_3,
+	MXL_HYDRA_FEC_3_4,
+	MXL_HYDRA_FEC_4_5,
+	MXL_HYDRA_FEC_5_6,
+	MXL_HYDRA_FEC_6_7,
+	MXL_HYDRA_FEC_7_8,
+	MXL_HYDRA_FEC_8_9,
+	MXL_HYDRA_FEC_9_10,
+};
+
+enum MXL_HYDRA_MODULATION_E {
+	MXL_HYDRA_MOD_AUTO = 0,
+	MXL_HYDRA_MOD_QPSK,
+	MXL_HYDRA_MOD_8PSK
+};
+
+enum MXL_HYDRA_SPECTRUM_E {
+	MXL_HYDRA_SPECTRUM_AUTO = 0,
+	MXL_HYDRA_SPECTRUM_INVERTED,
+	MXL_HYDRA_SPECTRUM_NON_INVERTED,
+};
+
+enum MXL_HYDRA_ROLLOFF_E {
+	MXL_HYDRA_ROLLOFF_AUTO  = 0,
+	MXL_HYDRA_ROLLOFF_0_20,
+	MXL_HYDRA_ROLLOFF_0_25,
+	MXL_HYDRA_ROLLOFF_0_35
+};
+
+enum MXL_HYDRA_PILOTS_E {
+	MXL_HYDRA_PILOTS_OFF  = 0,
+	MXL_HYDRA_PILOTS_ON,
+	MXL_HYDRA_PILOTS_AUTO
+};
+
+enum MXL_HYDRA_CONSTELLATION_SRC_E {
+	MXL_HYDRA_FORMATTER = 0,
+	MXL_HYDRA_LEGACY_FEC,
+	MXL_HYDRA_FREQ_RECOVERY,
+	MXL_HYDRA_NBC,
+	MXL_HYDRA_CTL,
+	MXL_HYDRA_EQ,
+};
+
+struct MXL_HYDRA_DEMOD_LOCK_T {
+	int agc_lock; /* AGC lock info */
+	int fec_lock; /* Demod FEC block lock info */
+};
+
+struct MXL_HYDRA_DEMOD_STATUS_DVBS_T {
+	u32 rs_errors;        /* RS decoder err counter */
+	u32 ber_window;       /* Ber Windows */
+	u32 ber_count;        /* BER count */
+	u32 ber_window_iter1; /* Ber Windows - post viterbi */
+	u32 ber_count_iter1;  /* BER count - post viterbi */
+};
+
+struct MXL_HYDRA_DEMOD_STATUS_DSS_T {
+	u32 rs_errors;  /* RS decoder err counter */
+	u32 ber_window; /* Ber Windows */
+	u32 ber_count;  /* BER count */
+};
+
+struct MXL_HYDRA_DEMOD_STATUS_DVBS2_T {
+	u32 crc_errors;        /* CRC error counter */
+	u32 packet_error_count; /* Number of packet errors */
+	u32 total_packets;     /* Total packets */
+};
+
+struct MXL_HYDRA_DEMOD_STATUS_T {
+	enum MXL_HYDRA_BCAST_STD_E standard_mask; /* Standard DVB-S, DVB-S2 or DSS */
+
+	union {
+		struct MXL_HYDRA_DEMOD_STATUS_DVBS_T demod_status_dvbs;   /* DVB-S demod status */
+		struct MXL_HYDRA_DEMOD_STATUS_DVBS2_T demod_status_dvbs2; /* DVB-S2 demod status */
+		struct MXL_HYDRA_DEMOD_STATUS_DSS_T demod_status_dss;     /* DSS demod status */
+	} u;
+};
+
+struct MXL_HYDRA_DEMOD_SIG_OFFSET_INFO_T {
+	s32 carrier_offset_in_hz; /* CRL offset info */
+	s32 symbol_offset_in_symbol; /* SRL offset info */
+};
+
+struct MXL_HYDRA_DEMOD_SCRAMBLE_INFO_T {
+	u8 scramble_sequence[MXL_DEMOD_SCRAMBLE_SEQ_LEN]; /* scramble sequence */
+	u32 scramble_code; /* scramble gold code */
+};
+
+enum MXL_HYDRA_SPECTRUM_STEP_SIZE_E {
+	MXL_HYDRA_STEP_SIZE_24_XTAL_102_05KHZ, /* 102.05 KHz for 24 MHz XTAL */
+	MXL_HYDRA_STEP_SIZE_24_XTAL_204_10KHZ, /* 204.10 KHz for 24 MHz XTAL */
+	MXL_HYDRA_STEP_SIZE_24_XTAL_306_15KHZ, /* 306.15 KHz for 24 MHz XTAL */
+	MXL_HYDRA_STEP_SIZE_24_XTAL_408_20KHZ, /* 408.20 KHz for 24 MHz XTAL */
+
+	MXL_HYDRA_STEP_SIZE_27_XTAL_102_05KHZ, /* 102.05 KHz for 27 MHz XTAL */
+	MXL_HYDRA_STEP_SIZE_27_XTAL_204_35KHZ, /* 204.35 KHz for 27 MHz XTAL */
+	MXL_HYDRA_STEP_SIZE_27_XTAL_306_52KHZ, /* 306.52 KHz for 27 MHz XTAL */
+	MXL_HYDRA_STEP_SIZE_27_XTAL_408_69KHZ, /* 408.69 KHz for 27 MHz XTAL */
+};
+
+enum MXL_HYDRA_SPECTRUM_RESOLUTION_E {
+	MXL_HYDRA_SPECTRUM_RESOLUTION_00_1_DB, /* 0.1 dB */
+	MXL_HYDRA_SPECTRUM_RESOLUTION_01_0_DB, /* 1.0 dB */
+	MXL_HYDRA_SPECTRUM_RESOLUTION_05_0_DB, /* 5.0 dB */
+	MXL_HYDRA_SPECTRUM_RESOLUTION_10_0_DB, /* 10 dB */
+};
+
+enum MXL_HYDRA_SPECTRUM_ERROR_CODE_E {
+	MXL_SPECTRUM_NO_ERROR,
+	MXL_SPECTRUM_INVALID_PARAMETER,
+	MXL_SPECTRUM_INVALID_STEP_SIZE,
+	MXL_SPECTRUM_BW_CANNOT_BE_COVERED,
+	MXL_SPECTRUM_DEMOD_BUSY,
+	MXL_SPECTRUM_TUNER_NOT_ENABLED,
+};
+
+struct MXL_HYDRA_SPECTRUM_REQ_T {
+	u32 tuner_index; /* TUNER Ctrl: one of MXL58x_TUNER_ID_E */
+	u32 demod_index; /* DEMOD Ctrl: one of MXL58x_DEMOD_ID_E */
+	enum MXL_HYDRA_SPECTRUM_STEP_SIZE_E step_size_in_khz;
+	u32 starting_freq_ink_hz;
+	u32 total_steps;
+	enum MXL_HYDRA_SPECTRUM_RESOLUTION_E spectrum_division;
+};
+
+enum MXL_HYDRA_SEARCH_FREQ_OFFSET_TYPE_E {
+	MXL_HYDRA_SEARCH_MAX_OFFSET = 0, /* DMD searches for max freq offset (i.e. 5MHz) */
+	MXL_HYDRA_SEARCH_BW_PLUS_ROLLOFF, /* DMD searches for BW + ROLLOFF/2 */
+};
+
+struct MXL58X_CFG_FREQ_OFF_SEARCH_RANGE_T {
+	u32 demod_index;
+	enum MXL_HYDRA_SEARCH_FREQ_OFFSET_TYPE_E search_type;
+};
+
+/* there are two slices
+ * slice0 - TS0, TS1, TS2 & TS3
+ * slice1 - TS4, TS5, TS6 & TS7
+ */
+#define MXL_HYDRA_TS_SLICE_MAX  2
+
+#define MAX_FIXED_PID_NUM   32
+
+#define MXL_HYDRA_NCO_CLK   418 /* 418 MHz */
+
+#define MXL_HYDRA_MAX_TS_CLOCK  139 /* 139 MHz */
+
+#define MXL_HYDRA_TS_FIXED_PID_FILT_SIZE          32
+
+#define MXL_HYDRA_SHARED_PID_FILT_SIZE_DEFAULT    33   /* Shared PID filter size in 1-1 mux mode */
+#define MXL_HYDRA_SHARED_PID_FILT_SIZE_2_TO_1     66   /* Shared PID filter size in 2-1 mux mode */
+#define MXL_HYDRA_SHARED_PID_FILT_SIZE_4_TO_1     132  /* Shared PID filter size in 4-1 mux mode */
+
+enum MXL_HYDRA_PID_BANK_TYPE_E {
+	MXL_HYDRA_SOFTWARE_PID_BANK = 0,
+	MXL_HYDRA_HARDWARE_PID_BANK,
+};
+
+enum MXL_HYDRA_TS_MUX_MODE_E {
+	MXL_HYDRA_TS_MUX_PID_REMAP = 0,
+	MXL_HYDRA_TS_MUX_PREFIX_EXTRA_HEADER = 1,
+};
+
+enum MXL_HYDRA_TS_MUX_TYPE_E {
+	MXL_HYDRA_TS_MUX_DISABLE = 0, /* No Mux ( 1 TSIF to 1 TSIF) */
+	MXL_HYDRA_TS_MUX_2_TO_1, /* Mux 2 TSIF to 1 TSIF */
+	MXL_HYDRA_TS_MUX_4_TO_1, /* Mux 4 TSIF to 1 TSIF */
+};
+
+enum MXL_HYDRA_TS_GROUP_E {
+	MXL_HYDRA_TS_GROUP_0_3 = 0, /* TS group 0 to 3 (TS0, TS1, TS2 & TS3) */
+	MXL_HYDRA_TS_GROUP_4_7,     /* TS group 0 to 3 (TS4, TS5, TS6 & TS7) */
+};
+
+enum MXL_HYDRA_TS_PID_FLT_CTRL_E {
+	MXL_HYDRA_TS_PIDS_ALLOW_ALL = 0, /* Allow all pids */
+	MXL_HYDRA_TS_PIDS_DROP_ALL,	 /* Drop all pids */
+	MXL_HYDRA_TS_INVALIDATE_PID_FILTER, /* Delete current PD filter in the device */
+};
+
+enum MXL_HYDRA_TS_PID_TYPE_E {
+	MXL_HYDRA_TS_PID_FIXED = 0,
+	MXL_HYDRA_TS_PID_REGULAR,
+};
+
+struct MXL_HYDRA_TS_PID_T {
+	u16 original_pid;           /* pid from TS */
+	u16 remapped_pid;           /* remapped pid */
+	enum MXL_BOOL_E enable;         /* enable or disable pid */
+	enum MXL_BOOL_E allow_or_drop;    /* allow or drop pid */
+	enum MXL_BOOL_E enable_pid_remap; /* enable or disable pid remap */
+	u8 bond_id;                 /* Bond ID in A0 always 0 - Only for 568 Sku */
+	u8 dest_id;                 /* Output port ID for the PID - Only for 568 Sku */
+};
+
+struct MXL_HYDRA_TS_MUX_PREFIX_HEADER_T {
+	enum MXL_BOOL_E enable;
+	u8 num_byte;
+	u8 header[12];
+};
+
+enum MXL_HYDRA_PID_FILTER_BANK_E {
+	MXL_HYDRA_PID_BANK_A = 0,
+	MXL_HYDRA_PID_BANK_B,
+};
+
+enum MXL_HYDRA_MPEG_DATA_FMT_E {
+	MXL_HYDRA_MPEG_SERIAL_MSB_1ST = 0,
+	MXL_HYDRA_MPEG_SERIAL_LSB_1ST,
+
+	MXL_HYDRA_MPEG_SYNC_WIDTH_BIT = 0,
+	MXL_HYDRA_MPEG_SYNC_WIDTH_BYTE
+};
+
+enum MXL_HYDRA_MPEG_MODE_E {
+	MXL_HYDRA_MPEG_MODE_SERIAL_4_WIRE = 0, /* MPEG 4 Wire serial mode */
+	MXL_HYDRA_MPEG_MODE_SERIAL_3_WIRE,     /* MPEG 3 Wire serial mode */
+	MXL_HYDRA_MPEG_MODE_SERIAL_2_WIRE,     /* MPEG 2 Wire serial mode */
+	MXL_HYDRA_MPEG_MODE_PARALLEL           /* MPEG parallel mode - valid only for MxL581 */
+};
+
+enum MXL_HYDRA_MPEG_CLK_TYPE_E {
+	MXL_HYDRA_MPEG_CLK_CONTINUOUS = 0, /* Continuous MPEG clock */
+	MXL_HYDRA_MPEG_CLK_GAPPED,         /* Gapped (gated) MPEG clock */
+};
+
+enum MXL_HYDRA_MPEG_CLK_FMT_E {
+	MXL_HYDRA_MPEG_ACTIVE_LOW = 0,
+	MXL_HYDRA_MPEG_ACTIVE_HIGH,
+
+	MXL_HYDRA_MPEG_CLK_NEGATIVE = 0,
+	MXL_HYDRA_MPEG_CLK_POSITIVE,
+
+	MXL_HYDRA_MPEG_CLK_IN_PHASE = 0,
+	MXL_HYDRA_MPEG_CLK_INVERTED,
+};
+
+enum MXL_HYDRA_MPEG_CLK_PHASE_E {
+	MXL_HYDRA_MPEG_CLK_PHASE_SHIFT_0_DEG = 0,
+	MXL_HYDRA_MPEG_CLK_PHASE_SHIFT_90_DEG,
+	MXL_HYDRA_MPEG_CLK_PHASE_SHIFT_180_DEG,
+	MXL_HYDRA_MPEG_CLK_PHASE_SHIFT_270_DEG
+};
+
+enum MXL_HYDRA_MPEG_ERR_INDICATION_E {
+	MXL_HYDRA_MPEG_ERR_REPLACE_SYNC = 0,
+	MXL_HYDRA_MPEG_ERR_REPLACE_VALID,
+	MXL_HYDRA_MPEG_ERR_INDICATION_DISABLED
+};
+
+struct MXL_HYDRA_MPEGOUT_PARAM_T {
+	int                                  enable;               /* Enable or Disable MPEG OUT */
+	enum MXL_HYDRA_MPEG_CLK_TYPE_E       mpeg_clk_type;          /* Continuous or gapped */
+	enum MXL_HYDRA_MPEG_CLK_FMT_E        mpeg_clk_pol;           /* MPEG Clk polarity */
+	u8                                   max_mpeg_clk_rate;       /* Max MPEG Clk rate (0 - 104 MHz, 139 MHz) */
+	enum MXL_HYDRA_MPEG_CLK_PHASE_E      mpeg_clk_phase;         /* MPEG Clk phase */
+	enum MXL_HYDRA_MPEG_DATA_FMT_E       lsb_or_msb_first;        /* LSB first or MSB first in TS transmission */
+	enum MXL_HYDRA_MPEG_DATA_FMT_E       mpeg_sync_pulse_width;   /* MPEG SYNC pulse width (1-bit or 1-byte) */
+	enum MXL_HYDRA_MPEG_CLK_FMT_E        mpeg_valid_pol;         /* MPEG VALID polarity */
+	enum MXL_HYDRA_MPEG_CLK_FMT_E        mpeg_sync_pol;          /* MPEG SYNC polarity */
+	enum MXL_HYDRA_MPEG_MODE_E           mpeg_mode;             /* config 4/3/2-wire serial or parallel TS out */
+	enum MXL_HYDRA_MPEG_ERR_INDICATION_E mpeg_error_indication;  /* Enable or Disable MPEG error indication */
+};
+
+enum MXL_HYDRA_EXT_TS_IN_ID_E {
+	MXL_HYDRA_EXT_TS_IN_0 = 0,
+	MXL_HYDRA_EXT_TS_IN_1,
+	MXL_HYDRA_EXT_TS_IN_2,
+	MXL_HYDRA_EXT_TS_IN_3,
+	MXL_HYDRA_EXT_TS_IN_MAX
+};
+
+enum MXL_HYDRA_TS_OUT_ID_E {
+	MXL_HYDRA_TS_OUT_0 = 0,
+	MXL_HYDRA_TS_OUT_1,
+	MXL_HYDRA_TS_OUT_2,
+	MXL_HYDRA_TS_OUT_3,
+	MXL_HYDRA_TS_OUT_4,
+	MXL_HYDRA_TS_OUT_5,
+	MXL_HYDRA_TS_OUT_6,
+	MXL_HYDRA_TS_OUT_7,
+	MXL_HYDRA_TS_OUT_MAX
+};
+
+enum MXL_HYDRA_TS_DRIVE_STRENGTH_E {
+	MXL_HYDRA_TS_DRIVE_STRENGTH_1X = 0,
+	MXL_HYDRA_TS_DRIVE_STRENGTH_2X,
+	MXL_HYDRA_TS_DRIVE_STRENGTH_3X,
+	MXL_HYDRA_TS_DRIVE_STRENGTH_4X,
+	MXL_HYDRA_TS_DRIVE_STRENGTH_5X,
+	MXL_HYDRA_TS_DRIVE_STRENGTH_6X,
+	MXL_HYDRA_TS_DRIVE_STRENGTH_7X,
+	MXL_HYDRA_TS_DRIVE_STRENGTH_8X
+};
+
+enum MXL_HYDRA_DEVICE_E {
+	MXL_HYDRA_DEVICE_581 = 0,
+	MXL_HYDRA_DEVICE_584,
+	MXL_HYDRA_DEVICE_585,
+	MXL_HYDRA_DEVICE_544,
+	MXL_HYDRA_DEVICE_561,
+	MXL_HYDRA_DEVICE_TEST,
+	MXL_HYDRA_DEVICE_582,
+	MXL_HYDRA_DEVICE_541,
+	MXL_HYDRA_DEVICE_568,
+	MXL_HYDRA_DEVICE_542,
+	MXL_HYDRA_DEVICE_541S,
+	MXL_HYDRA_DEVICE_561S,
+	MXL_HYDRA_DEVICE_581S,
+	MXL_HYDRA_DEVICE_MAX
+};
+
+/* Demod IQ data */
+struct MXL_HYDRA_DEMOD_IQ_SRC_T {
+	u32 demod_id;
+	u32 source_of_iq; /* == 0, it means I/Q comes from Formatter
+			 * == 1, Legacy FEC
+			 * == 2, Frequency Recovery
+			 * == 3, NBC
+			 * == 4, CTL
+			 * == 5, EQ
+			 * == 6, FPGA
+			 */
+};
+
+struct MXL_HYDRA_DEMOD_ABORT_TUNE_T {
+	u32 demod_id;
+};
+
+struct MXL_HYDRA_TUNER_CMD {
+	u8 tuner_id;
+	u8 enable;
+};
+
+/* Demod Para for Channel Tune */
+struct MXL_HYDRA_DEMOD_PARAM_T {
+	u32 tuner_index;
+	u32 demod_index;
+	u32 frequency_in_hz;     /* Frequency */
+	u32 standard;          /* one of MXL_HYDRA_BCAST_STD_E */
+	u32 spectrum_inversion; /* Input : Spectrum inversion. */
+	u32 roll_off;           /* rollOff (alpha) factor */
+	u32 symbol_rate_in_hz;    /* Symbol rate */
+	u32 pilots;            /* TRUE = pilots enabled */
+	u32 modulation_scheme;  /* Input : Modulation Scheme is one of MXL_HYDRA_MODULATION_E */
+	u32 fec_code_rate;       /* Input : Forward error correction rate. Is one of MXL_HYDRA_FEC_E */
+	u32 max_carrier_offset_in_mhz; /* Maximum carrier freq offset in MHz. Same as freqSearchRangeKHz, but in unit of MHz. */
+};
+
+struct MXL_HYDRA_DEMOD_SCRAMBLE_CODE_T {
+	u32 demod_index;
+	u8 scramble_sequence[12]; /* scramble sequence */
+	u32 scramble_code; /* scramble gold code */
+};
+
+struct MXL_INTR_CFG_T {
+	u32 intr_type;
+	u32 intr_duration_in_nano_secs;
+	u32 intr_mask;
+};
+
+struct MXL_HYDRA_POWER_MODE_CMD {
+	u8 power_mode; /* enumeration values are defined in MXL_HYDRA_PWR_MODE_E (device API.h) */
+};
+
+struct MXL_HYDRA_RF_WAKEUP_PARAM_T {
+	u32 time_interval_in_seconds; /* in seconds */
+	u32 tuner_index;
+	s32 rssi_threshold;
+};
+
+struct MXL_HYDRA_RF_WAKEUP_CFG_T {
+	u32 tuner_count;
+	struct MXL_HYDRA_RF_WAKEUP_PARAM_T params;
+};
+
+enum MXL_HYDRA_AUX_CTRL_MODE_E {
+	MXL_HYDRA_AUX_CTRL_MODE_FSK = 0, /* Select FSK controller */
+	MXL_HYDRA_AUX_CTRL_MODE_DISEQC,  /* Select DiSEqC controller */
+};
+
+enum MXL_HYDRA_DISEQC_OPMODE_E {
+	MXL_HYDRA_DISEQC_ENVELOPE_MODE = 0,
+	MXL_HYDRA_DISEQC_TONE_MODE,
+};
+
+enum MXL_HYDRA_DISEQC_VER_E {
+	MXL_HYDRA_DISEQC_1_X = 0, /* Config DiSEqC 1.x mode */
+	MXL_HYDRA_DISEQC_2_X, /* Config DiSEqC 2.x mode */
+	MXL_HYDRA_DISEQC_DISABLE /* Disable DiSEqC */
+};
+
+enum MXL_HYDRA_DISEQC_CARRIER_FREQ_E {
+	MXL_HYDRA_DISEQC_CARRIER_FREQ_22KHZ = 0, /* DiSEqC signal frequency of 22 KHz */
+	MXL_HYDRA_DISEQC_CARRIER_FREQ_33KHZ,     /* DiSEqC signal frequency of 33 KHz */
+	MXL_HYDRA_DISEQC_CARRIER_FREQ_44KHZ      /* DiSEqC signal frequency of 44 KHz */
+};
+
+enum MXL_HYDRA_DISEQC_ID_E {
+	MXL_HYDRA_DISEQC_ID_0 = 0,
+	MXL_HYDRA_DISEQC_ID_1,
+	MXL_HYDRA_DISEQC_ID_2,
+	MXL_HYDRA_DISEQC_ID_3
+};
+
+enum MXL_HYDRA_FSK_OP_MODE_E {
+	MXL_HYDRA_FSK_CFG_TYPE_39KPBS = 0, /* 39.0kbps */
+	MXL_HYDRA_FSK_CFG_TYPE_39_017KPBS, /* 39.017kbps */
+	MXL_HYDRA_FSK_CFG_TYPE_115_2KPBS   /* 115.2kbps */
+};
+
+struct MXL58X_DSQ_OP_MODE_T {
+	u32 diseqc_id; /* DSQ 0, 1, 2 or 3 */
+	u32 op_mode; /* Envelope mode (0) or internal tone mode (1) */
+	u32 version; /* 0: 1.0, 1: 1.1, 2: Disable */
+	u32 center_freq; /* 0: 22KHz, 1: 33KHz and 2: 44 KHz */
+};
+
+struct MXL_HYDRA_DISEQC_CFG_CONT_TONE_T {
+	u32 diseqc_id;
+	u32 cont_tone_flag; /* 1: Enable , 0: Disable */
+};
diff --git a/drivers/media/dvb-frontends/mxl5xx_regs.h b/drivers/media/dvb-frontends/mxl5xx_regs.h
new file mode 100644
index 000000000000..5001dafe1ba8
--- /dev/null
+++ b/drivers/media/dvb-frontends/mxl5xx_regs.h
@@ -0,0 +1,367 @@
+/*
+ * Copyright (c) 2011-2013 MaxLinear, Inc. All rights reserved
+ *
+ * License type: GPLv2
+ *
+ * This program is free software; you can redistribute it and/or modify it under
+ * the terms of the GNU General Public License as published by the Free Software
+ * Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
+ * FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
+ *
+ * This program may alternatively be licensed under a proprietary license from
+ * MaxLinear, Inc.
+ *
+ */
+
+#ifndef __MXL58X_REGISTERS_H__
+#define __MXL58X_REGISTERS_H__
+
+#define HYDRA_INTR_STATUS_REG               0x80030008
+#define HYDRA_INTR_MASK_REG                 0x8003000C
+
+#define HYDRA_CRYSTAL_SETTING               0x3FFFC5F0 /* 0 - 24 MHz & 1 - 27 MHz */
+#define HYDRA_CRYSTAL_CAP                   0x3FFFEDA4 /* 0 - 24 MHz & 1 - 27 MHz */
+
+#define HYDRA_CPU_RESET_REG                 0x8003003C
+#define HYDRA_CPU_RESET_DATA                0x00000400
+
+#define HYDRA_RESET_TRANSPORT_FIFO_REG      0x80030028
+#define HYDRA_RESET_TRANSPORT_FIFO_DATA     0x00000000
+
+#define HYDRA_RESET_BBAND_REG               0x80030024
+#define HYDRA_RESET_BBAND_DATA              0x00000000
+
+#define HYDRA_RESET_XBAR_REG                0x80030020
+#define HYDRA_RESET_XBAR_DATA               0x00000000
+
+#define HYDRA_MODULES_CLK_1_REG             0x80030014
+#define HYDRA_DISABLE_CLK_1                 0x00000000
+
+#define HYDRA_MODULES_CLK_2_REG             0x8003001C
+#define HYDRA_DISABLE_CLK_2                 0x0000000B
+
+#define HYDRA_PRCM_ROOT_CLK_REG             0x80030018
+#define HYDRA_PRCM_ROOT_CLK_DISABLE         0x00000000
+
+#define HYDRA_CPU_RESET_CHECK_REG           0x80030008
+#define HYDRA_CPU_RESET_CHECK_OFFSET        0x40000000  /* <bit 30> */
+
+#define HYDRA_SKU_ID_REG                    0x90000190
+
+#define FW_DL_SIGN_ADDR                     0x3FFFEAE0
+
+/* Register to check if FW is running or not */
+#define HYDRA_HEAR_BEAT                     0x3FFFEDDC
+
+/* Firmware version */
+#define HYDRA_FIRMWARE_VERSION              0x3FFFEDB8
+#define HYDRA_FW_RC_VERSION                 0x3FFFCFAC
+
+/* Firmware patch version */
+#define HYDRA_FIRMWARE_PATCH_VERSION        0x3FFFEDC2
+
+/* SOC operating temperature in C */
+#define HYDRA_TEMPARATURE                   0x3FFFEDB4
+
+/* Demod & Tuner status registers */
+/* Demod 0 status base address */
+#define HYDRA_DEMOD_0_BASE_ADDR             0x3FFFC64C
+
+/* Tuner 0 status base address */
+#define HYDRA_TUNER_0_BASE_ADDR             0x3FFFCE4C
+
+#define POWER_FROM_ADCRSSI_READBACK         0x3FFFEB6C
+
+/* Macros to determine base address of respective demod or tuner */
+#define HYDRA_DMD_STATUS_OFFSET(demodID)        ((demodID) * 0x100)
+#define HYDRA_TUNER_STATUS_OFFSET(tunerID)      ((tunerID) * 0x40)
+
+/* Demod status address offset from respective demod's base address */
+#define HYDRA_DMD_AGC_DIG_LEVEL_ADDR_OFFSET               0x3FFFC64C
+#define HYDRA_DMD_LOCK_STATUS_ADDR_OFFSET                 0x3FFFC650
+#define HYDRA_DMD_ACQ_STATUS_ADDR_OFFSET                  0x3FFFC654
+
+#define HYDRA_DMD_STANDARD_ADDR_OFFSET                    0x3FFFC658
+#define HYDRA_DMD_SPECTRUM_INVERSION_ADDR_OFFSET          0x3FFFC65C
+#define HYDRA_DMD_SPECTRUM_ROLL_OFF_ADDR_OFFSET           0x3FFFC660
+#define HYDRA_DMD_SYMBOL_RATE_ADDR_OFFSET                 0x3FFFC664
+#define HYDRA_DMD_MODULATION_SCHEME_ADDR_OFFSET           0x3FFFC668
+#define HYDRA_DMD_FEC_CODE_RATE_ADDR_OFFSET               0x3FFFC66C
+
+#define HYDRA_DMD_SNR_ADDR_OFFSET                         0x3FFFC670
+#define HYDRA_DMD_FREQ_OFFSET_ADDR_OFFSET                 0x3FFFC674
+#define HYDRA_DMD_CTL_FREQ_OFFSET_ADDR_OFFSET             0x3FFFC678
+#define HYDRA_DMD_STR_FREQ_OFFSET_ADDR_OFFSET             0x3FFFC67C
+#define HYDRA_DMD_FTL_FREQ_OFFSET_ADDR_OFFSET             0x3FFFC680
+#define HYDRA_DMD_STR_NBC_SYNC_LOCK_ADDR_OFFSET           0x3FFFC684
+#define HYDRA_DMD_CYCLE_SLIP_COUNT_ADDR_OFFSET            0x3FFFC688
+
+#define HYDRA_DMD_DISPLAY_I_ADDR_OFFSET                   0x3FFFC68C
+#define HYDRA_DMD_DISPLAY_Q_ADDR_OFFSET                   0x3FFFC68E
+
+#define HYDRA_DMD_DVBS2_CRC_ERRORS_ADDR_OFFSET            0x3FFFC690
+#define HYDRA_DMD_DVBS2_PER_COUNT_ADDR_OFFSET             0x3FFFC694
+#define HYDRA_DMD_DVBS2_PER_WINDOW_ADDR_OFFSET            0x3FFFC698
+
+#define HYDRA_DMD_DVBS_CORR_RS_ERRORS_ADDR_OFFSET         0x3FFFC69C
+#define HYDRA_DMD_DVBS_UNCORR_RS_ERRORS_ADDR_OFFSET       0x3FFFC6A0
+#define HYDRA_DMD_DVBS_BER_COUNT_ADDR_OFFSET              0x3FFFC6A4
+#define HYDRA_DMD_DVBS_BER_WINDOW_ADDR_OFFSET             0x3FFFC6A8
+
+/* Debug-purpose DVB-S DMD 0 */
+#define HYDRA_DMD_DVBS_1ST_CORR_RS_ERRORS_ADDR_OFFSET     0x3FFFC6C8  /* corrected RS Errors: 1st iteration */
+#define HYDRA_DMD_DVBS_1ST_UNCORR_RS_ERRORS_ADDR_OFFSET   0x3FFFC6CC  /* uncorrected RS Errors: 1st iteration */
+#define HYDRA_DMD_DVBS_BER_COUNT_1ST_ADDR_OFFSET          0x3FFFC6D0
+#define HYDRA_DMD_DVBS_BER_WINDOW_1ST_ADDR_OFFSET         0x3FFFC6D4
+
+#define HYDRA_DMD_TUNER_ID_ADDR_OFFSET                    0x3FFFC6AC
+#define HYDRA_DMD_DVBS2_PILOT_ON_OFF_ADDR_OFFSET          0x3FFFC6B0
+#define HYDRA_DMD_FREQ_SEARCH_RANGE_KHZ_ADDR_OFFSET       0x3FFFC6B4
+#define HYDRA_DMD_STATUS_LOCK_ADDR_OFFSET                 0x3FFFC6B8
+#define HYDRA_DMD_STATUS_CENTER_FREQ_IN_KHZ_ADDR          0x3FFFC704
+#define HYDRA_DMD_STATUS_INPUT_POWER_ADDR                 0x3FFFC708
+
+/* DVB-S new scaled_BER_count for a new BER API, see HYDRA-1343 "DVB-S post viterbi information" */
+#define DMD0_STATUS_DVBS_1ST_SCALED_BER_COUNT_ADDR        0x3FFFC710 /* DMD 0: 1st iteration BER count scaled by HYDRA_BER_COUNT_SCALING_FACTOR */
+#define DMD0_STATUS_DVBS_SCALED_BER_COUNT_ADDR            0x3FFFC714 /* DMD 0: 2nd iteration BER count scaled by HYDRA_BER_COUNT_SCALING_FACTOR */
+
+#define DMD0_SPECTRUM_MIN_GAIN_STATUS                     0x3FFFC73C
+#define DMD0_SPECTRUM_MIN_GAIN_WB_SAGC_VALUE              0x3FFFC740
+#define DMD0_SPECTRUM_MIN_GAIN_NB_SAGC_VALUE              0x3FFFC744
+
+#define HYDRA_DMD_STATUS_END_ADDR_OFFSET                  0x3FFFC748
+
+/* Tuner status address offset from respective tuners's base address */
+#define HYDRA_TUNER_DEMOD_ID_ADDR_OFFSET                  0x3FFFCE4C
+#define HYDRA_TUNER_AGC_LOCK_OFFSET                       0x3FFFCE50
+#define HYDRA_TUNER_SPECTRUM_STATUS_OFFSET                0x3FFFCE54
+#define HYDRA_TUNER_SPECTRUM_BIN_SIZE_OFFSET              0x3FFFCE58
+#define HYDRA_TUNER_SPECTRUM_ADDRESS_OFFSET               0x3FFFCE5C
+#define HYDRA_TUNER_ENABLE_COMPLETE                       0x3FFFEB78
+
+#define HYDRA_DEMOD_STATUS_LOCK(devId, demodId)   write_register(devId, (HYDRA_DMD_STATUS_LOCK_ADDR_OFFSET + HYDRA_DMD_STATUS_OFFSET(demodId)), MXL_YES)
+#define HYDRA_DEMOD_STATUS_UNLOCK(devId, demodId) write_register(devId, (HYDRA_DMD_STATUS_LOCK_ADDR_OFFSET + HYDRA_DMD_STATUS_OFFSET(demodId)), MXL_NO)
+
+#define HYDRA_VERSION                                     0x3FFFEDB8
+#define HYDRA_DEMOD0_VERSION                              0x3FFFEDBC
+#define HYDRA_DEMOD1_VERSION                              0x3FFFEDC0
+#define HYDRA_DEMOD2_VERSION                              0x3FFFEDC4
+#define HYDRA_DEMOD3_VERSION                              0x3FFFEDC8
+#define HYDRA_DEMOD4_VERSION                              0x3FFFEDCC
+#define HYDRA_DEMOD5_VERSION                              0x3FFFEDD0
+#define HYDRA_DEMOD6_VERSION                              0x3FFFEDD4
+#define HYDRA_DEMOD7_VERSION                              0x3FFFEDD8
+#define HYDRA_HEAR_BEAT                                   0x3FFFEDDC
+#define HYDRA_SKU_MGMT                                    0x3FFFEBC0
+
+#define MXL_HYDRA_FPGA_A_ADDRESS                          0x91C00000
+#define MXL_HYDRA_FPGA_B_ADDRESS                          0x91D00000
+
+/* TS control base address */
+#define HYDRA_TS_CTRL_BASE_ADDR                           0x90700000
+
+#define MPEG_MUX_MODE_SLICE0_REG            (HYDRA_TS_CTRL_BASE_ADDR + 0x08)
+
+#define MPEG_MUX_MODE_SLICE1_REG            (HYDRA_TS_CTRL_BASE_ADDR + 0x08)
+
+#define PID_BANK_SEL_SLICE0_REG             (HYDRA_TS_CTRL_BASE_ADDR + 0x190)
+#define PID_BANK_SEL_SLICE1_REG             (HYDRA_TS_CTRL_BASE_ADDR + 0x1B0)
+
+#define MPEG_CLK_GATED_REG                  (HYDRA_TS_CTRL_BASE_ADDR + 0x20)
+
+#define MPEG_CLK_ALWAYS_ON_REG              (HYDRA_TS_CTRL_BASE_ADDR + 0x1D4)
+
+#define HYDRA_REGULAR_PID_BANK_A_REG        (HYDRA_TS_CTRL_BASE_ADDR + 0x190)
+
+#define HYDRA_FIXED_PID_BANK_A_REG          (HYDRA_TS_CTRL_BASE_ADDR + 0x190)
+
+#define HYDRA_REGULAR_PID_BANK_B_REG        (HYDRA_TS_CTRL_BASE_ADDR + 0x1B0)
+
+#define HYDRA_FIXED_PID_BANK_B_REG          (HYDRA_TS_CTRL_BASE_ADDR + 0x1B0)
+
+#define FIXED_PID_TBL_REG_ADDRESS_0         (HYDRA_TS_CTRL_BASE_ADDR + 0x9000)
+#define FIXED_PID_TBL_REG_ADDRESS_1         (HYDRA_TS_CTRL_BASE_ADDR + 0x9100)
+#define FIXED_PID_TBL_REG_ADDRESS_2         (HYDRA_TS_CTRL_BASE_ADDR + 0x9200)
+#define FIXED_PID_TBL_REG_ADDRESS_3         (HYDRA_TS_CTRL_BASE_ADDR + 0x9300)
+
+#define FIXED_PID_TBL_REG_ADDRESS_4         (HYDRA_TS_CTRL_BASE_ADDR + 0xB000)
+#define FIXED_PID_TBL_REG_ADDRESS_5         (HYDRA_TS_CTRL_BASE_ADDR + 0xB100)
+#define FIXED_PID_TBL_REG_ADDRESS_6         (HYDRA_TS_CTRL_BASE_ADDR + 0xB200)
+#define FIXED_PID_TBL_REG_ADDRESS_7         (HYDRA_TS_CTRL_BASE_ADDR + 0xB300)
+
+#define REGULAR_PID_TBL_REG_ADDRESS_0       (HYDRA_TS_CTRL_BASE_ADDR + 0x8000)
+#define REGULAR_PID_TBL_REG_ADDRESS_1       (HYDRA_TS_CTRL_BASE_ADDR + 0x8200)
+#define REGULAR_PID_TBL_REG_ADDRESS_2       (HYDRA_TS_CTRL_BASE_ADDR + 0x8400)
+#define REGULAR_PID_TBL_REG_ADDRESS_3       (HYDRA_TS_CTRL_BASE_ADDR + 0x8600)
+
+#define REGULAR_PID_TBL_REG_ADDRESS_4       (HYDRA_TS_CTRL_BASE_ADDR + 0xA000)
+#define REGULAR_PID_TBL_REG_ADDRESS_5       (HYDRA_TS_CTRL_BASE_ADDR + 0xA200)
+#define REGULAR_PID_TBL_REG_ADDRESS_6       (HYDRA_TS_CTRL_BASE_ADDR + 0xA400)
+#define REGULAR_PID_TBL_REG_ADDRESS_7       (HYDRA_TS_CTRL_BASE_ADDR + 0xA600)
+
+/***************************************************************************/
+
+#define PAD_MUX_GPIO_00_SYNC_BASEADDR                          0x90000188
+
+
+#define PAD_MUX_UART_RX_C_PINMUX_BASEADDR 0x9000001C
+
+#define   XPT_PACKET_GAP_MIN_BASEADDR                            0x90700044
+#define   XPT_NCO_COUNT_BASEADDR                                 0x90700238
+
+#define   XPT_NCO_COUNT_BASEADDR1                                0x9070023C
+
+/* V2 DigRF status register */
+
+#define   XPT_PID_BASEADDR                                       0x90708000
+
+#define   XPT_PID_REMAP_BASEADDR                                 0x90708004
+
+#define   XPT_KNOWN_PID_BASEADDR                                 0x90709000
+
+#define   XPT_PID_BASEADDR1                                      0x9070A000
+
+#define   XPT_PID_REMAP_BASEADDR1                                0x9070A004
+
+#define   XPT_KNOWN_PID_BASEADDR1                                0x9070B000
+
+#define   XPT_BERT_LOCK_BASEADDR                                 0x907000B8
+
+#define   XPT_BERT_BASEADDR                                      0x907000BC
+
+#define   XPT_BERT_INVERT_BASEADDR                               0x907000C0
+
+#define   XPT_BERT_HEADER_BASEADDR                               0x907000C4
+
+#define   XPT_BERT_BASEADDR1                                     0x907000C8
+
+#define   XPT_BERT_BIT_COUNT0_BASEADDR                           0x907000CC
+
+#define   XPT_BERT_BIT_COUNT0_BASEADDR1                          0x907000D0
+
+#define   XPT_BERT_BIT_COUNT1_BASEADDR                           0x907000D4
+
+#define   XPT_BERT_BIT_COUNT1_BASEADDR1                          0x907000D8
+
+#define   XPT_BERT_BIT_COUNT2_BASEADDR                           0x907000DC
+
+#define   XPT_BERT_BIT_COUNT2_BASEADDR1                          0x907000E0
+
+#define   XPT_BERT_BIT_COUNT3_BASEADDR                           0x907000E4
+
+#define   XPT_BERT_BIT_COUNT3_BASEADDR1                          0x907000E8
+
+#define   XPT_BERT_BIT_COUNT4_BASEADDR                           0x907000EC
+
+#define   XPT_BERT_BIT_COUNT4_BASEADDR1                          0x907000F0
+
+#define   XPT_BERT_BIT_COUNT5_BASEADDR                           0x907000F4
+
+#define   XPT_BERT_BIT_COUNT5_BASEADDR1                          0x907000F8
+
+#define   XPT_BERT_BIT_COUNT6_BASEADDR                           0x907000FC
+
+#define   XPT_BERT_BIT_COUNT6_BASEADDR1                          0x90700100
+
+#define   XPT_BERT_BIT_COUNT7_BASEADDR                           0x90700104
+
+#define   XPT_BERT_BIT_COUNT7_BASEADDR1                          0x90700108
+
+#define   XPT_BERT_ERR_COUNT0_BASEADDR                           0x9070010C
+
+#define   XPT_BERT_ERR_COUNT0_BASEADDR1                          0x90700110
+
+#define   XPT_BERT_ERR_COUNT1_BASEADDR                           0x90700114
+
+#define   XPT_BERT_ERR_COUNT1_BASEADDR1                          0x90700118
+
+#define   XPT_BERT_ERR_COUNT2_BASEADDR                           0x9070011C
+
+#define   XPT_BERT_ERR_COUNT2_BASEADDR1                          0x90700120
+
+#define   XPT_BERT_ERR_COUNT3_BASEADDR                           0x90700124
+
+#define   XPT_BERT_ERR_COUNT3_BASEADDR1                          0x90700128
+
+#define   XPT_BERT_ERR_COUNT4_BASEADDR                           0x9070012C
+
+#define   XPT_BERT_ERR_COUNT4_BASEADDR1                          0x90700130
+
+#define   XPT_BERT_ERR_COUNT5_BASEADDR                           0x90700134
+
+#define   XPT_BERT_ERR_COUNT5_BASEADDR1                          0x90700138
+
+#define   XPT_BERT_ERR_COUNT6_BASEADDR                           0x9070013C
+
+#define   XPT_BERT_ERR_COUNT6_BASEADDR1                          0x90700140
+
+#define   XPT_BERT_ERR_COUNT7_BASEADDR                           0x90700144
+
+#define   XPT_BERT_ERR_COUNT7_BASEADDR1                          0x90700148
+
+#define   XPT_BERT_ERROR_BASEADDR                                0x9070014C
+
+#define   XPT_BERT_ANALYZER_BASEADDR                             0x90700150
+
+#define   XPT_BERT_ANALYZER_BASEADDR1                            0x90700154
+
+#define   XPT_BERT_ANALYZER_BASEADDR2                            0x90700158
+
+#define   XPT_BERT_ANALYZER_BASEADDR3                            0x9070015C
+
+#define   XPT_BERT_ANALYZER_BASEADDR4                            0x90700160
+
+#define   XPT_BERT_ANALYZER_BASEADDR5                            0x90700164
+
+#define   XPT_BERT_ANALYZER_BASEADDR6                            0x90700168
+
+#define   XPT_BERT_ANALYZER_BASEADDR7                            0x9070016C
+
+#define   XPT_BERT_ANALYZER_BASEADDR8                            0x90700170
+
+#define   XPT_BERT_ANALYZER_BASEADDR9                            0x90700174
+
+#define   XPT_DMD0_BASEADDR                                      0x9070024C
+
+/* V2 AGC Gain Freeze & step */
+#define   DBG_ENABLE_DISABLE_AGC                                 (0x3FFFCF60) /* 1: DISABLE, 0:ENABLE */
+#define   WB_DFE0_DFE_FB_RF1_BASEADDR                            0x903004A4
+
+#define   WB_DFE1_DFE_FB_RF1_BASEADDR                            0x904004A4
+
+#define   WB_DFE2_DFE_FB_RF1_BASEADDR                            0x905004A4
+
+#define   WB_DFE3_DFE_FB_RF1_BASEADDR                            0x906004A4
+
+#define   AFE_REG_D2A_TA_RFFE_LNA_BO_1P8_BASEADDR                0x90200104
+
+#define   AFE_REG_AFE_REG_SPARE_BASEADDR                         0x902000A0
+
+#define   AFE_REG_AFE_REG_SPARE_BASEADDR1                        0x902000B4
+
+#define   AFE_REG_AFE_REG_SPARE_BASEADDR2                        0x902000C4
+
+#define   AFE_REG_AFE_REG_SPARE_BASEADDR3                        0x902000D4
+
+#define   WB_DFE0_DFE_FB_AGC_BASEADDR                            0x90300498
+
+#define   WB_DFE1_DFE_FB_AGC_BASEADDR                            0x90400498
+
+#define   WB_DFE2_DFE_FB_AGC_BASEADDR                            0x90500498
+
+#define   WB_DFE3_DFE_FB_AGC_BASEADDR                            0x90600498
+
+#define   WDT_WD_INT_BASEADDR                                    0x8002000C
+
+#define   FSK_TX_FTM_BASEADDR                                    0x80090000
+
+#define   FSK_TX_FTM_TX_CNT_BASEADDR                             0x80090018
+
+#define   AFE_REG_D2A_FSK_BIAS_BASEADDR                          0x90200040
+
+#define   DMD_TEI_BASEADDR                                       0x3FFFEBE0
+
+#endif /* __MXL58X_REGISTERS_H__ */
-- 
2.13.0
