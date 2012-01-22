Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:56090 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215Ab2AVKjA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Jan 2012 05:39:00 -0500
Received: by wics10 with SMTP id s10so1467159wic.19
        for <linux-media@vger.kernel.org>; Sun, 22 Jan 2012 02:38:59 -0800 (PST)
Message-ID: <1327228731.2540.3.camel@tvbox>
Subject: [PATCH 1/3] m88brs2000 DVB-S frontend and tuner module.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Date: Sun, 22 Jan 2012 10:38:51 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Support for m88brs2000 chip used in lmedm04 driver.

Note there are still lock problems.

Slow channel change due to the large block of registers sent in set_frontend.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/media/dvb/frontends/Kconfig     |    7 +
 drivers/media/dvb/frontends/Makefile    |    1 +
 drivers/media/dvb/frontends/m88rs2000.c |  867 +++++++++++++++++++++++++++++++
 drivers/media/dvb/frontends/m88rs2000.h |   57 ++
 4 files changed, 932 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/dvb/frontends/m88rs2000.c
 create mode 100644 drivers/media/dvb/frontends/m88rs2000.h

diff --git a/drivers/media/dvb/frontends/Kconfig b/drivers/media/dvb/frontends/Kconfig
index ebb5ed7..fe6bcce 100644
--- a/drivers/media/dvb/frontends/Kconfig
+++ b/drivers/media/dvb/frontends/Kconfig
@@ -698,6 +698,13 @@ config DVB_IT913X_FE
 	  A DVB-T tuner module.
 	  Say Y when you want to support this frontend.
 
+config DVB_M88RS2000
+	tristate "M88RS2000 DVB-S"
+	depends on DVB_CORE && I2C
+	default m if DVB_FE_CUSTOMISE
+	help
+	  A DVB-S tuner module. Say Y when you want to support this frontend.
+
 comment "Tools to develop new frontends"
 
 config DVB_DUMMY_FE
diff --git a/drivers/media/dvb/frontends/Makefile b/drivers/media/dvb/frontends/Makefile
index 00a2063..642c805 100644
--- a/drivers/media/dvb/frontends/Makefile
+++ b/drivers/media/dvb/frontends/Makefile
@@ -96,4 +96,5 @@ obj-$(CONFIG_DVB_TDA18271C2DD) += tda18271c2dd.o
 obj-$(CONFIG_DVB_IT913X_FE) += it913x-fe.o
 obj-$(CONFIG_DVB_A8293) += a8293.o
 obj-$(CONFIG_DVB_TDA10071) += tda10071.o
+obj-$(CONFIG_DVB_M88RS2000) += m88rs2000.o
 
diff --git a/drivers/media/dvb/frontends/m88rs2000.c b/drivers/media/dvb/frontends/m88rs2000.c
new file mode 100644
index 0000000..a614ffe
--- /dev/null
+++ b/drivers/media/dvb/frontends/m88rs2000.c
@@ -0,0 +1,867 @@
+/*
+	Driver for M88RS2000 demodulator and tuner
+
+	Copyright (C) 2012 Malcolm Priestley (tvboxspy@gmail.com)
+
+	Beta Driver
+
+	This program is free software; you can redistribute it and/or modify
+	it under the terms of the GNU General Public License as published by
+	the Free Software Foundation; either version 2 of the License, or
+	(at your option) any later version.
+
+	This program is distributed in the hope that it will be useful,
+	but WITHOUT ANY WARRANTY; without even the implied warranty of
+	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+	GNU General Public License for more details.
+
+	You should have received a copy of the GNU General Public License
+	along with this program; if not, write to the Free Software
+	Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+
+*/
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/device.h>
+#include <linux/jiffies.h>
+#include <linux/string.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+
+
+#include "dvb_frontend.h"
+#include "m88rs2000.h"
+
+struct m88rs2000_state {
+	struct i2c_adapter *i2c;
+	const struct m88rs2000_config *config;
+	struct dvb_frontend frontend;
+	u8 no_lock_count;
+	u32 tuner_frequency;
+	u32 symbol_rate;
+	fe_code_rate_t fec_inner;
+	u8 tuner_level;
+	int errmode;
+};
+
+static int debug;
+#define dprintk(args...) \
+	do { \
+		if (debug) \
+			printk(KERN_DEBUG "m88rs2000: " args); \
+	} while (0)
+
+
+static int m88rs2000_writereg(struct m88rs2000_state *state, u8 tuner,
+	u8 reg, u8 data)
+{
+	int ret;
+	u8 addr = (tuner == 0) ? state->config->tuner_addr :
+		state->config->demod_addr;
+	u8 buf[] = { reg, data };
+	struct i2c_msg msg = {
+		.addr = addr,
+		.flags = 0,
+		.buf = buf,
+		.len = 2
+	};
+
+	ret = i2c_transfer(state->i2c, &msg, 1);
+
+	if (ret != 1)
+		dprintk("%s: writereg error (reg == 0x%02x, val == 0x%02x, "
+			"ret == %i)\n", __func__, reg, data, ret);
+
+	return (ret != 1) ? -EREMOTEIO : 0;
+}
+
+static int m88rs2000_demod_write(struct m88rs2000_state *state, u8 reg, u8 data)
+{
+	return m88rs2000_writereg(state, 1, reg, data);
+}
+
+static int m88rs2000_tuner_write(struct m88rs2000_state *state, u8 reg, u8 data)
+{
+	m88rs2000_demod_write(state, 0x81, 0x84);
+	return m88rs2000_writereg(state, 0, reg, data);
+}
+
+static int m88rs2000_write(struct dvb_frontend *fe, const u8 buf[], int len)
+{
+	struct m88rs2000_state *state = fe->demodulator_priv;
+
+	if (len != 2)
+		return -EINVAL;
+
+	return m88rs2000_writereg(state, 1, buf[0], buf[1]);
+}
+
+static u8 m88rs2000_readreg(struct m88rs2000_state *state, u8 tuner, u8 reg)
+{
+	int ret;
+	u8 b0[] = { reg };
+	u8 b1[] = { 0 };
+	u8 addr = (tuner == 0) ? state->config->tuner_addr :
+		state->config->demod_addr;
+	struct i2c_msg msg[] = {
+		{
+			.addr = addr,
+			.flags = 0,
+			.buf = b0,
+			.len = 1
+		}, {
+			.addr = addr,
+			.flags = I2C_M_RD,
+			.buf = b1,
+			.len = 1
+		}
+	};
+
+	ret = i2c_transfer(state->i2c, msg, 2);
+
+	if (ret != 2)
+		dprintk("%s: readreg error (reg == 0x%02x, ret == %i)\n",
+				__func__, reg, ret);
+
+	return b1[0];
+}
+
+static u8 m88rs2000_demod_read(struct m88rs2000_state *state, u8 reg)
+{
+	return m88rs2000_readreg(state, 1, reg);
+}
+
+static u8 m88rs2000_tuner_read(struct m88rs2000_state *state, u8 reg)
+{
+	m88rs2000_demod_write(state, 0x81, 0x85);
+	return m88rs2000_readreg(state, 0, reg);
+}
+
+static int m88rs2000_set_symbolrate(struct dvb_frontend *fe, u32 srate)
+{
+	struct m88rs2000_state *state = fe->demodulator_priv;
+	int ret;
+	u32 temp;
+	u8 b[4];
+
+	if ((srate < 1000000) || (srate > 45000000))
+		return -EINVAL;
+	b[3] = m88rs2000_demod_read(state, 0x86);
+
+	temp = srate / 1000;
+	temp *= 11831;
+	temp /= 68;
+	temp -= 3;
+
+	b[0] = (u8) (temp >> 16) & 0xff;
+	b[1] = (u8) (temp >> 8) & 0xff;
+	b[2] = (u8) temp & 0xff;
+	ret = m88rs2000_demod_write(state, 0x93, b[2]);
+	ret |= m88rs2000_demod_write(state, 0x94, b[1]);
+	ret |= m88rs2000_demod_write(state, 0x95, b[0]);
+
+	dprintk("m88rs2000: m88rs2000_set_symbolrate\n");
+	return ret;
+}
+
+static int m88rs2000_send_diseqc_msg(struct dvb_frontend *fe,
+				    struct dvb_diseqc_master_cmd *m)
+{
+	struct m88rs2000_state *state = fe->demodulator_priv;
+
+	int i;
+	u8 reg;
+	dprintk("%s\n", __func__);
+	m88rs2000_demod_write(state, 0x9a, 0x30);
+	msleep(50);
+	reg = m88rs2000_demod_read(state, 0xb2);
+	m88rs2000_demod_write(state, 0xb2, 0x01);
+	for (i = 0; i <  m->msg_len; i++)
+		m88rs2000_demod_write(state, 0xb3 + i, m->msg[i]);
+
+	m88rs2000_demod_write(state, 0xb1, 0x1f);
+
+	for (i = 0; i < 10; i++)
+		if ((m88rs2000_demod_read(state, 0xb1) & 0x40) == 0x0)
+			break;
+	if (m88rs2000_demod_read(state, 0xb1) == 0x1f)
+		m88rs2000_demod_write(state, 0xb1, 0x5f);
+	m88rs2000_demod_write(state, 0xb2, reg);
+	m88rs2000_demod_write(state, 0x9a, 0xb0);
+
+
+	return 0;
+}
+
+static int m88rs2000_send_diseqc_burst(struct dvb_frontend *fe,
+						fe_sec_mini_cmd_t burst)
+{
+	struct m88rs2000_state *state = fe->demodulator_priv;
+	u8 reg0, reg1;
+	dprintk("%s\n", __func__);
+	m88rs2000_demod_write(state, 0x9a, 0x30);
+	msleep(50);
+	reg0 = m88rs2000_demod_read(state, 0xb1);
+	reg1 = m88rs2000_demod_read(state, 0xb2);
+
+	m88rs2000_demod_write(state, 0xb2, reg1);
+	m88rs2000_demod_write(state, 0xb1, reg0);
+	m88rs2000_demod_write(state, 0x9a, 0xb0);
+
+	return 0;
+}
+
+static int m88rs2000_set_tone(struct dvb_frontend *fe, fe_sec_tone_mode_t tone)
+{
+	struct m88rs2000_state *state = fe->demodulator_priv;
+	u8 reg0, reg1;
+	m88rs2000_demod_write(state, 0x9a, 0x30);
+	reg0 = m88rs2000_demod_read(state, 0xb1);
+	reg1 = m88rs2000_demod_read(state, 0xb2);
+
+	switch (tone) {
+	case SEC_TONE_ON:
+		reg0 = 0x1c;
+		reg1 = 0x01;
+	break;
+
+	case SEC_TONE_OFF:
+		reg0 = 0x5f;
+		reg1 = 0x81;
+	break;
+
+	default:
+		return -EINVAL;
+	}
+	m88rs2000_demod_write(state, 0xb2, reg1);
+	m88rs2000_demod_write(state, 0xb1, reg0);
+	m88rs2000_demod_write(state, 0x9a, 0xb0);
+	return 0;
+}
+
+struct inittab {
+	u8 cmd;
+	u8 reg;
+	u8 val;
+};
+
+struct inittab m88rs2000_setup[] = {
+	{DEMOD_WRITE, 0x9a, 0x30},
+	{DEMOD_WRITE, 0x00, 0x01},
+	{WRITE_DELAY, 0x19, 0x00},
+	{DEMOD_WRITE, 0x00, 0x00},
+	{DEMOD_WRITE, 0x9a, 0xb0},
+	{DEMOD_WRITE, 0x81, 0xc1},
+	{TUNER_WRITE, 0x42, 0x73},
+	{TUNER_WRITE, 0x05, 0x07},
+	{TUNER_WRITE, 0x20, 0x27},
+	{TUNER_WRITE, 0x07, 0x02},
+	{TUNER_WRITE, 0x11, 0xff},
+	{TUNER_WRITE, 0x60, 0xf9},
+	{TUNER_WRITE, 0x08, 0x01},
+	{TUNER_WRITE, 0x00, 0x41},
+	{DEMOD_WRITE, 0x81, 0x81},
+	{DEMOD_WRITE, 0x86, 0xc6},
+	{DEMOD_WRITE, 0x9a, 0x30},
+	{DEMOD_WRITE, 0xf0, 0x22},
+	{DEMOD_WRITE, 0xf1, 0xbf},
+	{DEMOD_WRITE, 0xb0, 0x45},
+	{DEMOD_WRITE, 0x9a, 0xb0},
+	{0xff, 0xaa, 0xff}
+};
+
+struct inittab tuner_reset[] = {
+	{TUNER_WRITE, 0x42, 0x73},
+	{TUNER_WRITE, 0x05, 0x07},
+	{TUNER_WRITE, 0x20, 0x27},
+	{TUNER_WRITE, 0x07, 0x02},
+	{TUNER_WRITE, 0x11, 0xff},
+	{TUNER_WRITE, 0x60, 0xa1}, /* also f9 0xa1 0x99 */
+	{TUNER_WRITE, 0x08, 0x01},
+	{TUNER_WRITE, 0x00, 0x41},
+	{0xff, 0xaa, 0xff}
+};
+
+struct inittab fe_reset[] = {
+	{DEMOD_WRITE, 0xf1, 0xbf},
+	{DEMOD_WRITE, 0x00, 0x01},
+	{DEMOD_WRITE, 0x20, 0x81},
+	{DEMOD_WRITE, 0x21, 0x80},
+	{DEMOD_WRITE, 0x10, 0x33},
+	{DEMOD_WRITE, 0x11, 0x44},
+	{DEMOD_WRITE, 0x12, 0x07},
+	{DEMOD_WRITE, 0x18, 0x20},
+	{DEMOD_WRITE, 0x28, 0x04},
+	{DEMOD_WRITE, 0x29, 0x8e},
+	{DEMOD_WRITE, 0x3b, 0xff},
+	{DEMOD_WRITE, 0x32, 0x10},
+	{DEMOD_WRITE, 0x33, 0x02},
+	{DEMOD_WRITE, 0x34, 0x30},
+	{DEMOD_WRITE, 0x35, 0xff},
+	{DEMOD_WRITE, 0x38, 0x50},
+	{DEMOD_WRITE, 0x39, 0x68},
+	{DEMOD_WRITE, 0x3c, 0x7f},
+	{DEMOD_WRITE, 0x3d, 0x0f},
+	{DEMOD_WRITE, 0x45, 0x20},
+	{DEMOD_WRITE, 0x46, 0x24},
+	{DEMOD_WRITE, 0x47, 0x7c},
+	{DEMOD_WRITE, 0x48, 0x16},
+	{DEMOD_WRITE, 0x49, 0x04},
+	{DEMOD_WRITE, 0x4a, 0x01},
+	{DEMOD_WRITE, 0x4b, 0x78},
+	{DEMOD_WRITE, 0X4d, 0xd2},
+	{DEMOD_WRITE, 0x4e, 0x6d},
+	{DEMOD_WRITE, 0x50, 0x30},
+	{DEMOD_WRITE, 0x51, 0x30},
+	{DEMOD_WRITE, 0x54, 0x7b},
+	{DEMOD_WRITE, 0x56, 0x09},
+	{DEMOD_WRITE, 0x58, 0x59},
+	{DEMOD_WRITE, 0x59, 0x37},
+	{DEMOD_WRITE, 0x63, 0xfa},
+	{0xff, 0xaa, 0xff}
+};
+
+struct inittab fe_trigger[] = {
+	{DEMOD_WRITE, 0x97, 0x04},
+	{DEMOD_WRITE, 0x99, 0x77},
+	{DEMOD_WRITE, 0x9a, 0xb0},
+	{DEMOD_WRITE, 0x9b, 0x64},
+	{DEMOD_WRITE, 0x9e, 0x00},
+	{DEMOD_WRITE, 0x9f, 0xf8},
+	{DEMOD_WRITE, 0xa0, 0x20},
+	{DEMOD_WRITE, 0xa1, 0xe0},
+	{DEMOD_WRITE, 0xa3, 0x38},
+	{DEMOD_WRITE, 0x98, 0xff},
+	{DEMOD_WRITE, 0xc0, 0x0f},
+	{DEMOD_WRITE, 0x89, 0x01},
+	{DEMOD_WRITE, 0x00, 0x00},
+	{DEMOD_WRITE, 0x00, 0x01},
+	{DEMOD_WRITE, 0x00, 0x00},
+	{0xff, 0xaa, 0xff}
+};
+
+static int m88rs2000_tab_set(struct m88rs2000_state *state,
+		struct inittab *tab)
+{
+	int ret = 0;
+	u8 i;
+	if (tab == NULL)
+		return -EINVAL;
+
+	for (i = 0; i < 255; i++) {
+		switch (tab[i].cmd) {
+		case 0x01:
+			ret = m88rs2000_demod_write(state, tab[i].reg,
+				tab[i].val);
+			break;
+		case 0x02:
+			ret = m88rs2000_tuner_write(state, tab[i].reg,
+				tab[i].val);
+			break;
+		case 0x10:
+			if (tab[i].reg > 0)
+				mdelay(tab[i].reg);
+			break;
+		case 0xff:
+			if (tab[i].reg == 0xaa && tab[i].val == 0xff)
+				return 0;
+		case 0x00:
+			break;
+		default:
+			return -EINVAL;
+		}
+		if (ret < 0)
+			return -ENODEV;
+	}
+	return 0;
+}
+
+static int m88rs2000_set_voltage(struct dvb_frontend *fe, fe_sec_voltage_t volt)
+{
+	dprintk("%s: %s\n", __func__,
+		volt == SEC_VOLTAGE_13 ? "SEC_VOLTAGE_13" :
+		volt == SEC_VOLTAGE_18 ? "SEC_VOLTAGE_18" : "??");
+
+	return 0;
+}
+
+static int m88rs2000_startup(struct m88rs2000_state *state)
+{
+	int ret;
+	u8 reg;
+
+	ret = m88rs2000_tab_set(state, m88rs2000_setup);
+
+	ret |= m88rs2000_demod_write(state, 0x9a, 0x30);
+	reg = m88rs2000_demod_read(state, 0x00);
+	if (reg != 2)
+		ret = -ENODEV;
+	ret |= m88rs2000_demod_write(state, 0x9a, 0xb0);
+
+	return (ret < 0) ? -ENODEV : 0;
+}
+
+static int m88rs2000_init(struct dvb_frontend *fe)
+{
+	struct m88rs2000_state *state = fe->demodulator_priv;
+	int ret;
+	u8 reg;
+
+	dprintk("m88rs2000: init chip\n");
+
+	ret = m88rs2000_demod_write(state, 0x9a, 0x30);
+	reg = m88rs2000_demod_read(state, 0x00);
+	if (reg != 2)
+		if (m88rs2000_startup(state) < 0)
+			ret = -ENODEV;
+	/* only write upper nibble */
+	ret |= m88rs2000_demod_write(state, 0x9a, 0xb0);
+
+	return (ret < 0) ? -ENODEV : 0;
+}
+
+static int m88rs2000_read_status(struct dvb_frontend *fe, fe_status_t *status)
+{
+	struct m88rs2000_state *state = fe->demodulator_priv;
+
+	u8 reg = m88rs2000_demod_read(state, 0x8c);
+	*status = 0;
+	if (reg & 0xc0)
+		*status |= FE_HAS_CARRIER | FE_HAS_SIGNAL;
+	if (reg & 0xd0)
+		*status |= FE_HAS_VITERBI;
+	if (reg & 0x0e) {
+		*status |= FE_HAS_LOCK;
+		state->no_lock_count = 0;
+	} else {
+		state->no_lock_count++;
+		if (state->no_lock_count > 10) {
+			reg = m88rs2000_demod_read(state, 0x70);
+			if (reg == 0xf9)
+				m88rs2000_demod_write(state, 0x70, 0xfd);
+			else
+				m88rs2000_demod_write(state, 0x70, 0xf9);
+			state->no_lock_count = 0;
+		}
+	}
+	return 0;
+}
+
+static int m88rs2000_read_ber(struct dvb_frontend *fe, u32 *ber)
+{
+	dprintk("m88rs2000_read_ber %d\n", *ber);
+	*ber = 0;
+	return 0;
+}
+
+
+static int m88rs2000_read_signal_strength(struct dvb_frontend *fe,
+	u16 *strength)
+{
+	struct m88rs2000_state *state = fe->demodulator_priv;
+
+	*strength = (m88rs2000_demod_read(state, 0x21) << 8) +
+			m88rs2000_demod_read(state, 0x22);
+
+	return 0;
+}
+static int m88rs2000_sleep(struct dvb_frontend *fe)
+{
+	return 0;
+}
+static int m88rs2000_read_snr(struct dvb_frontend *fe, u16 *snr)
+{
+	struct m88rs2000_state *state = fe->demodulator_priv;
+	dprintk("m88rs2000_read_snr %d\n", *snr);
+	*snr = 0xffff - ((m88rs2000_demod_read(state, 0x65) << 8));
+	return 0;
+}
+
+static int m88rs2000_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
+{
+	dprintk("m88rs2000_read_ber %d\n", *ucblocks);
+	*ucblocks = 0;
+	return 0;
+}
+
+static int m88rs2000_set_property(struct dvb_frontend *fe,
+	struct dtv_property *p)
+{
+	dprintk("%s(..)\n", __func__);
+	return 0;
+}
+
+static int m88rs2000_get_property(struct dvb_frontend *fe,
+	struct dtv_property *p)
+{
+	dprintk("%s(..)\n", __func__);
+	return 0;
+}
+
+static int m88rs2000_tuner_gate_ctrl(struct m88rs2000_state *state, u8 offset)
+{
+	int ret;
+	ret = m88rs2000_tuner_write(state, 0x51, 0x1f - offset);
+	ret |= m88rs2000_tuner_write(state, 0x51, 0x1f);
+	ret |= m88rs2000_tuner_write(state, 0x50, offset);
+	ret |= m88rs2000_tuner_write(state, 0x50, 0x00);
+	msleep(20);
+	return ret;
+}
+
+static int m88rs2000_set_tuner(struct dvb_frontend *fe)
+{
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+	struct m88rs2000_state *state = fe->demodulator_priv;
+	int ret;
+	u32 symbol_rate = (c->symbol_rate / 1000);
+	u32 freq;
+	u8 lo = 0x01;
+	u8 reg, bw;
+
+	/* Reset Tuner */
+	ret = m88rs2000_tab_set(state, tuner_reset);
+
+	/* Calc Frequency */
+	if (c->frequency < 1060000) {
+		freq = c->frequency - 493000;
+		freq *= 3;
+		freq /= 83;
+		freq += c->frequency - 493000;
+		freq /= 1000;
+		freq *= 2;
+		freq += 1;
+		lo |= 0x10;
+	} else {
+		freq = c->frequency - 986000;
+		freq *= 3;
+		freq /= 83;
+		freq += c->frequency - 986000;
+		freq /= 1000;
+	}
+
+	ret = m88rs2000_tuner_write(state, 0x10, 0x80 | lo);
+
+	/* Bandwidth Settings */
+	if (symbol_rate < 6000)
+		bw = 0x5;
+	else if (symbol_rate < 8000)
+		bw = 0x4;
+	else if (symbol_rate < 10000)
+		bw = 0x6;
+	else if (symbol_rate < 12000)
+		bw = 0x7;
+	else if (symbol_rate < 14000)
+		bw = 0x8;
+	else if (symbol_rate < 16000)
+		bw = 0x9;
+	else if (symbol_rate < 18000)
+		bw = 0xa;
+	else if (symbol_rate < 20000)
+		bw = 0xb;
+	else if (symbol_rate < 22000)
+		bw = 0xc;
+	else if (symbol_rate < 24000)
+		bw = 0xd;
+	else if (symbol_rate < 26000)
+		bw = 0xe;
+	else if (symbol_rate < 28000)
+		bw = 0xf;
+	else
+		bw = 0x10;
+
+	/* Frequency */
+	ret |= m88rs2000_tuner_write(state, 0x01, freq >> 8);
+	ret |= m88rs2000_tuner_write(state, 0x02, freq & 0xff);
+	ret |= m88rs2000_tuner_write(state, 0x03, 0x06);
+
+	ret |= m88rs2000_tuner_gate_ctrl(state, 0x10);
+	if (ret < 0)
+		return -ENODEV;
+
+	/* Tuner Frequency Range */
+	ret = m88rs2000_tuner_write(state, 0x10, lo);
+
+	ret |= m88rs2000_tuner_gate_ctrl(state, 0x08);
+
+	ret |= m88rs2000_tuner_write(state, 0x04, 0x2e);
+
+	ret |= m88rs2000_tuner_gate_ctrl(state, 0x04);
+	if (ret < 0)
+		return -ENODEV;
+
+	reg = m88rs2000_tuner_read(state, 0x26);
+	/* Gain control */
+	if (bw == 0xf)
+		ret = m88rs2000_tuner_write(state, 0x04, 0x2f);
+	else
+		ret = m88rs2000_tuner_write(state, 0x04, 0x32);
+	/* Bandwidth */
+	ret |= m88rs2000_tuner_write(state, 0x06, bw);
+
+	ret |= m88rs2000_tuner_gate_ctrl(state, 0x04);
+
+	ret |= m88rs2000_tuner_gate_ctrl(state, 0x01);
+
+	return (ret < 0) ? -EINVAL : 0;
+}
+
+static int m88rs2000_set_fec(struct m88rs2000_state *state,
+		fe_code_rate_t fec)
+{
+	int ret;
+	u16 fec_set;
+	switch (fec) {
+	/* This is not confirmed kept for reference */
+/*	case FEC_1_2:
+		fec_set = 0x88;
+		break;
+	case FEC_2_3:
+		fec_set = 0x68;
+		break;
+	case FEC_3_4:
+		fec_set = 0x48;
+		break;
+	case FEC_5_6:
+		fec_set = 0x28;
+		break;
+	case FEC_7_8:
+		fec_set = 0x18;
+		break; */
+	case FEC_AUTO:
+	default:
+		fec_set = 0x08;
+	}
+	ret = m88rs2000_demod_write(state, 0x76, fec_set);
+
+	return 0;
+}
+
+
+static fe_code_rate_t m88rs2000_get_fec(struct m88rs2000_state *state)
+{
+	u8 reg;
+	m88rs2000_demod_write(state, 0x9a, 0x30);
+	reg = m88rs2000_demod_read(state, 0x76);
+	m88rs2000_demod_write(state, 0x9a, 0xb0);
+
+	switch (reg) {
+	case 0x88:
+		return FEC_1_2;
+	case 0x68:
+		return FEC_2_3;
+	case 0x48:
+		return FEC_3_4;
+	case 0x28:
+		return FEC_5_6;
+	case 0x18:
+		return FEC_7_8;
+	case 0x08:
+	default:
+		break;
+	}
+
+	return FEC_AUTO;
+}
+
+static int m88rs2000_set_frontend(struct dvb_frontend *fe)
+{
+	struct m88rs2000_state *state = fe->demodulator_priv;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+	fe_status_t status;
+	int i, ret;
+	s16 offset;
+	u8 reg;
+
+	state->no_lock_count = 0;
+
+	if (c->delivery_system != SYS_DVBS) {
+			dprintk("%s: unsupported delivery "
+				"system selected (%d)\n",
+				__func__, c->delivery_system);
+			return -EOPNOTSUPP;
+	}
+
+	/* Set Tuner */
+	ret = m88rs2000_set_tuner(fe);
+	if (ret < 0)
+		return -ENODEV;
+
+	ret = m88rs2000_demod_write(state, 0x9a, 0x30);
+	ret |= m88rs2000_demod_write(state, 0x86, 0xc6);
+	ret |= m88rs2000_demod_write(state, 0x9c, 0x00);
+	ret |= m88rs2000_demod_write(state, 0x9d, 0x00);
+	if (ret < 0)
+		return -ENODEV;
+
+	/* Reset Demod */
+	ret = m88rs2000_tab_set(state, fe_reset);
+	if (ret < 0)
+		return -ENODEV;
+
+	/* Unknown */
+	reg = m88rs2000_demod_read(state, 0x70);
+	ret = m88rs2000_demod_write(state, 0x70, reg);
+
+	/* Set FEC */
+	ret |= m88rs2000_set_fec(state, c->fec_inner);
+	ret |= m88rs2000_demod_write(state, 0x85, 0x1);
+	ret |= m88rs2000_demod_write(state, 0x8a, 0xbf);
+	ret |= m88rs2000_demod_write(state, 0x8d, 0x1e);
+	ret |= m88rs2000_demod_write(state, 0x90, 0xf1);
+	ret |= m88rs2000_demod_write(state, 0x91, 0x08);
+
+	if (ret < 0)
+		return -ENODEV;
+
+	/* Set Symbol Rate */
+	ret = m88rs2000_set_symbolrate(fe, c->symbol_rate);
+	if (ret < 0)
+		return -ENODEV;
+
+	/* Set up Demod */
+	ret = m88rs2000_tab_set(state, fe_trigger);
+	if (ret < 0)
+		return -ENODEV;
+
+	for (i = 0; i < 20; i++) {
+		m88rs2000_read_status(fe, &status);
+		if (status & FE_HAS_LOCK)
+			break;
+	}
+
+	offset = (s16)((m88rs2000_demod_read(state, 0x9c) << 8)|
+			m88rs2000_demod_read(state, 0x9d));
+
+	if (offset < -0x1000)
+		offset = 0;
+
+	offset += 0xa0;
+
+	ret = m88rs2000_demod_write(state, 0x9a, 0x30);
+	ret |= m88rs2000_demod_write(state, 0x9c, (u8)(offset >> 8));
+	ret |= m88rs2000_demod_write(state, 0x9d, (u8)offset & 0xff);
+	ret |= m88rs2000_demod_write(state, 0x9a, 0xb0);
+	if (ret < 0)
+		return -ENODEV;
+
+	state->tuner_frequency = c->frequency;
+	state->symbol_rate = c->symbol_rate;
+	return 0;
+}
+
+static int m88rs2000_get_frontend(struct dvb_frontend *fe)
+{
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+	struct m88rs2000_state *state = fe->demodulator_priv;
+
+	c->fec_inner = m88rs2000_get_fec(state);
+	c->frequency = state->tuner_frequency;
+	c->symbol_rate = state->symbol_rate;
+
+	return 0;
+}
+
+static int m88rs2000_get_tune_settings(struct dvb_frontend *fe,
+	struct dvb_frontend_tune_settings *fesettings)
+{
+	fesettings->min_delay_ms = 25;
+	return 0;
+}
+
+static int m88rs2000_i2c_gate_ctrl(struct dvb_frontend *fe, int enable)
+{
+	struct m88rs2000_state *state = fe->demodulator_priv;
+
+	if (enable)
+		m88rs2000_demod_write(state, 0x81, 0x84);
+	else
+		m88rs2000_demod_write(state, 0x81, 0x81);
+
+	return 0;
+}
+
+static void m88rs2000_release(struct dvb_frontend *fe)
+{
+	struct m88rs2000_state *state = fe->demodulator_priv;
+	kfree(state);
+}
+
+static struct dvb_frontend_ops m88rs2000_ops = {
+	.delsys = { SYS_DVBS },
+	.info = {
+		.name			= "M88RS2000 DVB-S",
+		.type			= FE_QPSK,
+		.frequency_min		= 950000,
+		.frequency_max		= 2150000,
+		.frequency_stepsize	= 1000,	 /* kHz for QPSK frontends */
+		.frequency_tolerance	= 0,
+		.symbol_rate_min	= 1000000,
+		.symbol_rate_max	= 45000000,
+		.symbol_rate_tolerance	= 500,	/* ppm */
+		.caps = FE_CAN_FEC_1_2 | FE_CAN_FEC_2_3 | FE_CAN_FEC_3_4 |
+		      FE_CAN_FEC_5_6 | FE_CAN_FEC_7_8 |
+		      FE_CAN_QPSK |
+		      FE_CAN_FEC_AUTO
+	},
+
+	.release = m88rs2000_release,
+	.init = m88rs2000_init,
+	.sleep = m88rs2000_sleep,
+	.write = m88rs2000_write,
+	.i2c_gate_ctrl = m88rs2000_i2c_gate_ctrl,
+	.read_status = m88rs2000_read_status,
+	.read_ber = m88rs2000_read_ber,
+	.read_signal_strength = m88rs2000_read_signal_strength,
+	.read_snr = m88rs2000_read_snr,
+	.read_ucblocks = m88rs2000_read_ucblocks,
+	.diseqc_send_master_cmd = m88rs2000_send_diseqc_msg,
+	.diseqc_send_burst = m88rs2000_send_diseqc_burst,
+	.set_tone = m88rs2000_set_tone,
+	.set_voltage = m88rs2000_set_voltage,
+
+	.set_property = m88rs2000_set_property,
+	.get_property = m88rs2000_get_property,
+	.set_frontend = m88rs2000_set_frontend,
+	.get_frontend = m88rs2000_get_frontend,
+	.get_tune_settings = m88rs2000_get_tune_settings,
+};
+
+struct dvb_frontend *m88rs2000_attach(const struct m88rs2000_config *config,
+				    struct i2c_adapter *i2c)
+{
+	struct m88rs2000_state *state = NULL;
+
+	/* allocate memory for the internal state */
+	state = kzalloc(sizeof(struct m88rs2000_state), GFP_KERNEL);
+	if (state == NULL)
+		goto error;
+
+	/* setup the state */
+	state->config = config;
+	state->i2c = i2c;
+	state->tuner_frequency = 0;
+	state->symbol_rate = 0;
+	state->fec_inner = 0;
+
+	if (m88rs2000_startup(state) < 0)
+		goto error;
+
+	/* create dvb_frontend */
+	memcpy(&state->frontend.ops, &m88rs2000_ops,
+			sizeof(struct dvb_frontend_ops));
+	state->frontend.demodulator_priv = state;
+	return &state->frontend;
+
+error:
+	kfree(state);
+
+	return NULL;
+}
+EXPORT_SYMBOL(m88rs2000_attach);
+
+MODULE_DESCRIPTION("M88RS2000 DVB-S Demodulator driver");
+MODULE_AUTHOR("Malcolm Priestley tvboxspy@gmail.com");
+MODULE_LICENSE("GPL");
+MODULE_VERSION("1.00");
+
diff --git a/drivers/media/dvb/frontends/m88rs2000.h b/drivers/media/dvb/frontends/m88rs2000.h
new file mode 100644
index 0000000..9915f44
--- /dev/null
+++ b/drivers/media/dvb/frontends/m88rs2000.h
@@ -0,0 +1,57 @@
+/*
+	Driver for M88RS2000 demodulator
+
+	This program is free software; you can redistribute it and/or modify
+	it under the terms of the GNU General Public License as published by
+	the Free Software Foundation; either version 2 of the License, or
+	(at your option) any later version.
+
+	This program is distributed in the hope that it will be useful,
+	but WITHOUT ANY WARRANTY; without even the implied warranty of
+	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+	GNU General Public License for more details.
+
+	You should have received a copy of the GNU General Public License
+	along with this program; if not, write to the Free Software
+	Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+
+*/
+
+#ifndef M88RS2000_H
+#define M88RS2000_H
+
+#include <linux/dvb/frontend.h>
+#include "dvb_frontend.h"
+
+struct m88rs2000_config {
+	/* Demodulator i2c address */
+	u8 demod_addr;
+	/* Tuner address */
+	u8 tuner_addr;
+
+	u8 *inittab;
+
+	/* minimum delay before retuning */
+	int min_delay_ms;
+
+	int (*set_ts_params)(struct dvb_frontend *fe, int is_punctured);
+};
+
+#if defined(CONFIG_DVB_M88RS2000) || (defined(CONFIG_DVB_M88RS2000_MODULE) && \
+							defined(MODULE))
+extern struct dvb_frontend *m88rs2000_attach(
+	const struct m88rs2000_config *config, struct i2c_adapter *i2c);
+#else
+static inline struct dvb_frontend *m88rs2000_attach(
+	const struct m88rs2000_config *config, struct i2c_adapter *i2c)
+{
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
+	return NULL;
+}
+#endif /* CONFIG_DVB_M88RS2000 */
+enum {
+	DEMOD_WRITE = 0x1,
+	TUNER_WRITE,
+	WRITE_DELAY = 0x10,
+};
+#endif /* M88RS2000_H */
-- 
1.7.8.3



