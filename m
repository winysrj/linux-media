Return-path: <linux-media-owner@vger.kernel.org>
Received: from blu0-omc2-s21.blu0.hotmail.com ([65.55.111.96]:12543 "EHLO
	blu0-omc2-s21.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752166Ab2DUA7I (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Apr 2012 20:59:08 -0400
Message-ID: <BLU0-SMTP387053873CD770C7D4E9FA4D8230@phx.gbl>
From: Manoel Pinheiro <pinusdtv@hotmail.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 2/2] [media for 3.5] Add support for TBS-Tech ISDB-T Full Seg DTB08: Modifications for frontend mb86a20s
Date: Fri, 20 Apr 2012 21:58:57 -0300
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Driver for TBS-Tech ISDB-T USB2.0 Receiver (DTB08 Full Seg).

The device used as a reference is described in the link
http://linuxtv.org/wiki/index.php/JH_Full_HD_Digital_TV_Receiver

Modifications to allow use the mb86a20s frontend.


Signed-off-by: Manoel Pinheiro <pinusdtv@hotmail.com>
---
 drivers/media/dvb/dvb-usb/tbs-dtb08-fe.c |  570 ++++++++++++++++++++++++++++++
 drivers/media/dvb/dvb-usb/tbs-dtb08-fe.h |   60 ++++
 2 files changed, 630 insertions(+)
 create mode 100644 drivers/media/dvb/dvb-usb/tbs-dtb08-fe.c
 create mode 100644 drivers/media/dvb/dvb-usb/tbs-dtb08-fe.h

diff --git a/drivers/media/dvb/dvb-usb/tbs-dtb08-fe.c b/drivers/media/dvb/dvb-usb/tbs-dtb08-fe.c
new file mode 100644
index 0000000..955de70
--- /dev/null
+++ b/drivers/media/dvb/dvb-usb/tbs-dtb08-fe.c
@@ -0,0 +1,570 @@
+/*
+ *   TBS-Tech ISDB-T Full Seg DTB08 device driver
+ *
+ *   Copyright (C) 2010-2012 Manoel Pinheiro <pinusdtv@hotmail.com>
+ *
+ *   This program is free software; you can redistribute it and/or modify
+ *   it under the terms of the GNU General Public License as published by
+ *   the Free Software Foundation; either version 2 of the License, or
+ *   (at your option) any later version.
+ *
+ *   This program is distributed in the hope that it will be useful,
+ *   but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *   GNU General Public License for more details.
+ *
+ *   You should have received a copy of the GNU General Public License
+ *   along with this program; if not, write to the Free Software
+ *   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+/* This file is part of tbs-dtb08 module and can be removed in the future. */
+
+#include "tbs-dtb08-fe.h"
+
+struct dtb08_a20s_reg_subreg_val {
+	u8 reg;
+	u8 subreg;
+	u8 type;	/* 0=8 bits wo/sub, 1=8 bits w/sub
+			 * 2=16 bits wo/sub, 3=16 bits w/sub, 4=24 bits */
+	u32 val;
+};
+
+static struct dtb08_a20s_reg_subreg_val dtb08_a20s_regs_val[] = {
+	{ 0x70, 0x00, 0x00, 0x0f },
+	{ 0x70, 0x00, 0x00, 0xff },
+	{ 0x08, 0x00, 0x00, 0x01 },
+	{ 0x09, 0x00, 0x00, 0x3e },
+	{ 0x50, 0xd1, 0x01, 0x22 },
+	{ 0x39, 0x00, 0x00, 0x01 },
+	{ 0x71, 0x00, 0x00, 0x00 },
+	{ 0x28, 0x2a, 0x04, 0xff80 },
+	{ 0x28, 0x20, 0x04, 0x33dfa9 },
+	{ 0x28, 0x22, 0x04, 0x1ff0 },
+	{ 0x3b, 0x00, 0x00, 0x21 },
+	{ 0x3c, 0x00, 0x00, 0x3a },
+	{ 0x01, 0x00, 0x00, 0x0d },
+	{ 0x04, 0x08, 0x01, 0x05 },
+	{ 0x04, 0x0e, 0x03, 0x0014 },
+	{ 0x04, 0x0b, 0x01, 0x8c },
+	{ 0x04, 0x00, 0x03, 0x0007 },
+	{ 0x04, 0x02, 0x03, 0x0fa0 },
+	{ 0x04, 0x09, 0x01, 0x00 },
+	{ 0x04, 0x0a, 0x01, 0xff },
+	{ 0x04, 0x27, 0x01, 0x64 },
+	{ 0x04, 0x28, 0x01, 0x00 },
+	{ 0x04, 0x1e, 0x01, 0xff },
+	{ 0x04, 0x29, 0x01, 0x0a },
+	{ 0x04, 0x32, 0x01, 0x0a },
+	{ 0x04, 0x14, 0x01, 0x02 },
+	{ 0x04, 0x04, 0x03, 0x0022 },
+	{ 0x04, 0x06, 0x03, 0x0ed8 },
+	{ 0x04, 0x12, 0x01, 0x00 },
+	{ 0x04, 0x13, 0x01, 0xff },
+	{ 0x04, 0x15, 0x01, 0x4e },
+	{ 0x04, 0x16, 0x01, 0x20 },
+	{ 0x52, 0x00, 0x00, 0x01 },
+	{ 0x50, 0xa7, 0x04, 0xffff },
+	{ 0x50, 0xaa, 0x04, 0xffff },
+	{ 0x50, 0xad, 0x04, 0xffff },
+	{ 0x5e, 0x00, 0x00, 0x07 },
+	{ 0x50, 0xdc, 0x03, 0x01f4 },
+	{ 0x50, 0xde, 0x03, 0x01f4 },
+	{ 0x50, 0xe0, 0x03, 0x01f4 },
+	{ 0x50, 0xb0, 0x01, 0x07 },
+	{ 0x50, 0xb2, 0x03, 0xffff },
+	{ 0x50, 0xb4, 0x03, 0xffff },
+	{ 0x50, 0xb6, 0x03, 0xffff },
+	{ 0x50, 0x50, 0x01, 0x02 },
+	{ 0x50, 0x51, 0x01, 0x04 },
+	{ 0x45, 0x00, 0x00, 0x04 },
+	{ 0x48, 0x00, 0x00, 0x04 },
+	{ 0x50, 0xd5, 0x01, 0x01 },
+	{ 0x50, 0xd6, 0x01, 0x1f },
+	{ 0x50, 0xd2, 0x01, 0x03 },
+	{ 0x50, 0xd7, 0x01, 0x3f },
+	{ 0x28, 0x74, 0x04, 0x0040 },
+	{ 0x28, 0x46, 0x04, 0x2c0c },
+	{ 0x04, 0x40, 0x01, 0x01 },
+	{ 0x28, 0x00, 0x01, 0x10 },
+	{ 0x28, 0x05, 0x01, 0x02 },
+	{ 0x1c, 0x00, 0x00, 0x01 },
+	{ 0x28, 0x06, 0x04, 0x0003 },
+	{ 0x28, 0x07, 0x04, 0x000d },
+	{ 0x28, 0x08, 0x04, 0x0002 },
+	{ 0x28, 0x09, 0x04, 0x0001 },
+	{ 0x28, 0x0a, 0x04, 0x0021 },
+	{ 0x28, 0x0b, 0x04, 0x0029 },
+	{ 0x28, 0x0c, 0x04, 0x0016 },
+	{ 0x28, 0x0d, 0x04, 0x0031 },
+	{ 0x28, 0x0e, 0x04, 0x000e },
+	{ 0x28, 0x0f, 0x04, 0x004e },
+	{ 0x28, 0x10, 0x04, 0x0046 },
+	{ 0x28, 0x11, 0x04, 0x000f },
+	{ 0x28, 0x12, 0x04, 0x0056 },
+	{ 0x28, 0x13, 0x04, 0x0035 },
+	{ 0x28, 0x14, 0x04, 0x01be },
+	{ 0x28, 0x15, 0x04, 0x0184 },
+	{ 0x28, 0x16, 0x04, 0x03ee },
+	{ 0x28, 0x17, 0x04, 0x0098 },
+	{ 0x28, 0x18, 0x04, 0x009f },
+	{ 0x28, 0x19, 0x04, 0x07b2 },
+	{ 0x28, 0x1a, 0x04, 0x06c2 },
+	{ 0x28, 0x1b, 0x04, 0x074a },
+	{ 0x28, 0x1c, 0x04, 0x01bc },
+	{ 0x28, 0x1d, 0x04, 0x04ba },
+	{ 0x28, 0x1e, 0x04, 0x0614 },
+	{ 0x50, 0x1e, 0x01, 0x5d },
+	{ 0x50, 0x22, 0x01, 0x00 },
+	{ 0x50, 0x23, 0x01, 0xc8 },
+	{ 0x50, 0x24, 0x01, 0x00 },
+	{ 0x50, 0x25, 0x01, 0xf0 },
+	{ 0x50, 0x26, 0x01, 0x00 },
+	{ 0x50, 0x27, 0x01, 0xc3 },
+	{ 0x50, 0x39, 0x01, 0x02 },
+	{ 0x28, 0x6a, 0x04, 0x0000 }
+};
+
+static u8 dtb08_a20s_soft_reset[] = {
+	0x70, 0xf0, 0x70, 0xff, 0x08, 0x01, 0x08, 0x00
+};
+
+int dtb08_a20s_read_reg(struct dtb08_a20s_state *state, u8 reg, u8 *val)
+{
+	int ret;
+	*val = 0;
+	ret = state->i2c_read(state->udev, state->demod_addr, reg, val, 1);
+	return (ret < 0) ? ret : 0;
+}
+
+int dtb08_a20s_write_reg(struct dtb08_a20s_state *state, u8 reg, u8 val)
+{
+	int ret;
+	ret = state->i2c_write(state->udev, state->demod_addr, reg, &val, 1);
+	return (ret < 0) ? ret : 0;
+}
+
+int dtb08_a20s_read_subreg(struct dtb08_a20s_state *state,
+			   u8 reg, u8 subreg, u8 *val)
+{
+	int ret;
+
+	*val = 0;
+	ret = dtb08_a20s_write_reg(state, reg, subreg);
+	if (ret < 0)
+		return ret;
+	return dtb08_a20s_read_reg(state, reg + 1, val);
+}
+
+static u32 get_config_reg_val(struct dtb08_a20s_state *state,
+			      struct dtb08_a20s_reg_subreg_val *reg_val)
+{
+	struct dtb08_a20s_reg_subreg_config *config_regs;
+	int i;
+
+	if (!reg_val)
+		return 0;
+	if (!state || !state->config_regs)
+		return reg_val->val;
+
+	config_regs = state->config_regs;
+	for (i = 0; i < state->config_size; i++) {
+		if (config_regs->reg == reg_val->reg &&
+		    config_regs->subreg == reg_val->subreg)
+			return config_regs->val;
+		config_regs++;
+	}
+	return reg_val->val;
+}
+
+static int dtb08_a20s_init_regs(struct dtb08_a20s_state *state)
+{
+	u8 *buf;
+	u32 val;
+	int i, i2, count, ret = 0;
+
+	state->need_init = true;
+	buf = kmalloc(12 , GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	for (i = 0; i < ARRAY_SIZE(dtb08_a20s_regs_val); i++) {
+		struct dtb08_a20s_reg_subreg_val *reg_val;
+
+		reg_val = &dtb08_a20s_regs_val[i];
+		val = get_config_reg_val(state, reg_val);
+		buf[0] = reg_val->reg;
+		count = 1;
+		switch (reg_val->type) {
+		case 1:
+			buf[count++] = reg_val->subreg;
+			if (buf[0] == 0x28)
+				buf[count++] = 0x2b;
+			else
+				buf[count++] = buf[0] + 1;
+			break;
+		case 2:
+			buf[count++] = (u8)(val >> 0x08);
+			buf[count++] = buf[0] + 1;
+			buf[count++] = (u8)val;
+			break;
+		case 3:
+			buf[count++] = reg_val->subreg;
+			buf[count++] = buf[0] + 1;
+			buf[count++] = (u8)(val >> 0x08);
+			buf[count++] = buf[0];
+			buf[count++] = reg_val->subreg + 1;
+			buf[count++] = buf[0] + 1;
+			break;
+		case 4:
+			if (buf[0] == 0x28) {
+				buf[count++] = reg_val->subreg;
+				buf[count++] = 0x29;
+				buf[count++] = (u8)(val >> 0x10);
+				buf[count++] = 0x2a;
+				buf[count++] = (u8)(val >> 0x08);
+				buf[count++] = 0x2b;
+			} else if (buf[0] == 0x50) {
+				buf[count++] = reg_val->subreg;
+				buf[count++] = 0x51;
+				buf[count++] = (u8)(val >> 0x10);
+				buf[count++] = 0x50;
+				buf[count++] = reg_val->subreg + 1;
+				buf[count++] = 0x51;
+				buf[count++] = (u8)(val >> 0x08);
+				buf[count++] = 0x50;
+				buf[count++] = reg_val->subreg + 2;
+				buf[count++] = 0x51;
+			} else {
+				ret = -1;
+				goto ret_err;
+			}
+			break;
+		}
+		buf[count++] = (u8)val;
+		i2 = 0;
+		while (i2 < count) {
+			ret = dtb08_a20s_write_reg(state, buf[i2], buf[i2 + 1]);
+			if (ret < 0)
+				goto ret_err;
+			i2 += 2;
+		}
+	}
+	state->need_init = false;
+	kfree(buf);
+	return 0;
+
+ret_err:
+	err("%s: dtb08_a20s init failed.", __func__);
+	kfree(buf);
+	return ret;
+}
+
+static int dtb08_a20s_init_fe(struct dvb_frontend *fe)
+{
+	int n;
+	struct dtb08_a20s_state *state = fe->sec_priv;
+
+	fe->dtv_property_cache.delivery_system = SYS_ISDBT;
+
+	n = dtb08_a20s_init_regs(state);
+	if (n < 0)
+		return n;
+	else
+		return 0;
+}
+
+static int dtb08_a20s_i2c_gate_ctrl(struct dvb_frontend *fe, int enable)
+{
+	struct dtb08_a20s_state *state = fe->sec_priv;
+	u8 val = 1;
+
+	/*
+	 * In the document "OFDM-LSI for Digital Terrestrial Broadcasting
+	 * Reception MB86A20S" says:
+	 * I2C bus and I2C bus for tuner control
+	 * This product realizes I2C bus for register setup in the main
+	 * unit and I2C bus for tuner control to shut off the bus noise from
+	 * the tuner by connecting the tuner to the I2C bus line only when
+	 * it is controlled.
+	 */
+
+	if (!state->tuner_ctrl)
+		return 0;
+
+	if (enable)
+		val = 0;
+
+	/* Enable/Disable I2C bus for tuner control */
+	return dtb08_a20s_write_reg(state, 0xfe, val);
+}
+
+static int dtb08_a20s_sleep(struct dvb_frontend *fe)
+{
+	struct dtb08_a20s_state *state = fe->sec_priv;
+
+	if (state->led_control)
+		state->led_control(state->udev, 0);
+	state->current_frequency = 0;
+	state->need_init = 1;
+	return 0;
+}
+
+static int dtb08_a20s_set_frontend(struct dvb_frontend *fe)
+{
+	int i, ret;
+	u8 val;
+	struct dtb08_a20s_state *state = fe->sec_priv;
+	struct dtv_frontend_properties *dpc = &fe->dtv_property_cache;
+
+	if (time_before(jiffies, state->next_set_frontend_check) &&
+		state->current_frequency == dpc->frequency)
+			return 0;
+
+	state->current_frequency = dpc->frequency;
+	state->next_set_frontend_check = jiffies + msecs_to_jiffies(200);
+
+	/* turn off the led */
+	if (state->led_control)
+		state->led_control(state->udev, 0);
+
+	if (state->need_init) {
+		ret = dtb08_a20s_init_regs(state);
+		if (ret < 0)
+			return ret;
+	}
+
+	/* program tuner */
+	if (fe->ops.tuner_ops.set_params) {
+		state->tuner_ctrl = true;
+		fe->ops.tuner_ops.set_params(fe);
+		/* disable I2C bus tuner control */
+		if (fe->ops.i2c_gate_ctrl)
+			fe->ops.i2c_gate_ctrl(fe, 0);
+		state->tuner_ctrl = false;
+		msleep(100);
+	}
+
+	for (i = 0; i < sizeof(dtb08_a20s_soft_reset); i += 2) {
+		ret = dtb08_a20s_write_reg(state, dtb08_a20s_soft_reset[i],
+					dtb08_a20s_soft_reset[i+1]);
+		if (ret < 0)
+			return ret;
+	}
+
+	for (i = 0; i < 10; i++) {
+		ret = dtb08_a20s_read_reg(state, 0x0a, &val);
+		if (ret == 0 && val >= 2)
+			break;
+		msleep(100);
+	}
+
+	/* turn on the led */
+	if (state->led_control)
+		state->led_control(state->udev, 1);
+
+	return 0;
+}
+
+static int dtb08_a20s_get_tune_settings(struct dvb_frontend *fe,
+				struct dvb_frontend_tune_settings *feset)
+{
+	feset->min_delay_ms = 600;
+	feset->step_size = 0;
+	feset->max_drift = 0;
+
+	return 0;
+}
+
+static int dtb08_a20s_read_status(struct dvb_frontend *fe, fe_status_t *status)
+{
+	int i;
+	u8 val = 0;
+	struct dtb08_a20s_state *state = fe->sec_priv;
+
+	if (time_before(jiffies, state->next_status_check)) {
+		*status = state->status;
+		return 0;
+	}
+
+	state->next_status_check = jiffies + msecs_to_jiffies(100);
+	for (i = 0; i < 10; i++) {
+		dtb08_a20s_read_reg(state, 0x0a, &val);
+		if (val >= 2)
+			break;
+		msleep(10);
+	}
+
+	*status = 0;
+
+	if (val >= 2)
+		*status |= FE_HAS_SIGNAL;
+	if (val >= 4)
+		*status |= FE_HAS_CARRIER;
+	if (val >= 5)
+		*status |= FE_HAS_VITERBI;
+	if (val >= 7)
+		*status |= FE_HAS_SYNC;
+	if (val >= 8)
+		*status |= FE_HAS_LOCK;
+
+	state->status = *status;
+
+	return 0;
+}
+
+static int dtb08_a20s_get_property(struct dvb_frontend *fe,
+				 struct dtv_property *tvp)
+{
+	struct dtv_frontend_properties *dpc = &fe->dtv_property_cache;
+
+	switch (tvp->cmd) {
+	case DTV_DELIVERY_SYSTEM:
+		tvp->u.data = dpc->delivery_system = SYS_ISDBT;
+		break;
+	}
+	return 0;
+}
+
+static int dtb08_a20s_read_signal_strength(struct dvb_frontend *fe,
+					   u16 *strength)
+{
+	struct dtb08_a20s_state *state = fe->sec_priv;
+	int i, n;
+
+	if (time_before(jiffies, state->next_strength_check)) {
+		*strength = state->strength;
+		return 0;
+	}
+	state->next_strength_check = jiffies + msecs_to_jiffies(100);
+	*strength = state->strength = 0;
+	for (i = 0; i < 10; i++) {
+		u8 val = 0;
+		dtb08_a20s_read_reg(state, 0x0a, &val);
+		if (val < 2)
+			goto next;
+#if 0
+		if (dtb08_a20s_read_subreg(state, 0x04, 0x3a, &val) < 0)
+			goto next;
+		n = ((255 - val) * 10000) / 255;
+		state->strength = *strength = (u16)((65535 * n) / 10000);
+
+		info("%s: val=%d, n=%d, strength=%d %d%%",
+			__func__, val, n, *strength, (255-val) * 100 / 255);
+		return 0;
+#else
+		if (dtb08_a20s_read_subreg(state, 0x04, 0x25, &val) < 0)
+			goto next;
+		n = val;
+		if (dtb08_a20s_read_subreg(state, 0x04, 0x26, &val) < 0)
+			goto next;
+		n = (((n << 8) | val) * 0x100100) >> 16;
+		*strength = state->strength = n ;
+		return 0;
+#endif
+next:
+		msleep(20);
+	}
+
+	return 0;
+}
+
+static int dtb08_a20s_read_snr(struct dvb_frontend *fe, u16 *snr)
+{
+	struct dtb08_a20s_state *state = fe->sec_priv;
+	int i, n, cnr;
+
+	if (time_before(jiffies, state->next_snr_check)) {
+		*snr = state->snr;
+		return 0;
+	}
+
+	state->next_snr_check = jiffies + msecs_to_jiffies(100);
+	*snr = state->snr = 0;
+	for (i = 0; i < 10; i++) {
+		u8 val = 0;
+		n = dtb08_a20s_read_reg(state, 0x0a, &val);
+		if (n < 0 || val < 2)
+			goto next;
+		if (dtb08_a20s_read_reg(state, 0x45, &val) < 0)
+			goto next;
+		/* read cnr_flag */
+		if (((val >> 6) & 1) != 0) {
+			if (dtb08_a20s_read_reg(state, 0x46, &val) < 0)
+				goto next;
+			n = val;
+			if (dtb08_a20s_read_reg(state, 0x47, &val) < 0)
+				goto next;
+			cnr = (n << 0x08) | val;
+			/* reset cnr_counter */
+			dtb08_a20s_read_reg(state, 0x45, &val);
+			val |= 0x10;
+			dtb08_a20s_write_reg(state, 0x45, val);
+			msleep(5);
+			val &= 0x6f; /* FIXME: or 0xef ? */
+			dtb08_a20s_write_reg(state, 0x45, val);
+			if (cnr > 0x4cc0)
+				cnr = 0x4cc0;
+			n = ((0x4cc0 - cnr) * 10000) / 0x4cc0;
+			n = (65535 * n) / 10000;
+			*snr = state->snr = n;
+			return 0;
+		}
+next:
+		msleep(20);
+	}
+
+	return 0;
+}
+
+static int dtb08_a20s_tune(struct dvb_frontend *fe, bool re_tune,
+			   unsigned int mode_flags, unsigned int *delay,
+			   fe_status_t *status)
+{
+	int ret = 0;
+
+	if (re_tune) {
+		ret = dtb08_a20s_set_frontend(fe);
+		if (ret < 0)
+			return ret;
+	}
+
+	if (!(mode_flags & FE_TUNE_MODE_ONESHOT))
+		ret = dtb08_a20s_read_status(fe, status);
+
+	return ret;
+}
+
+int dtb08_a20s_frontend_attach(struct dtb08_a20s_state *state,
+			       struct dvb_usb_adapter *adap,
+			       const struct mb86a20s_config *config)
+{
+	struct dvb_frontend *fe;
+
+	if (!state->i2c_read || !state->i2c_write)
+		return -EOPNOTSUPP;
+
+	if (dtb08_a20s_init_regs(state) != 0)
+		return -ENODEV;
+
+	fe = dvb_attach(mb86a20s_attach, config, &adap->dev->i2c_adap);
+	if (!fe)
+		return -ENODEV;
+
+	state->need_init = true;
+	adap->fe_adap[0].fe = fe;
+
+	fe->sec_priv = state;
+	fe->ops.init = dtb08_a20s_init_fe;
+	fe->ops.sleep = dtb08_a20s_sleep;
+	fe->ops.set_frontend = dtb08_a20s_set_frontend;
+	fe->ops.read_status = dtb08_a20s_read_status;
+	fe->ops.read_signal_strength = dtb08_a20s_read_signal_strength;
+	fe->ops.read_snr = dtb08_a20s_read_snr;
+	fe->ops.get_tune_settings = dtb08_a20s_get_tune_settings;
+	fe->ops.get_property = dtb08_a20s_get_property;
+	fe->ops.i2c_gate_ctrl = dtb08_a20s_i2c_gate_ctrl;
+	fe->ops.tune = dtb08_a20s_tune;
+
+	return 0;
+}
diff --git a/drivers/media/dvb/dvb-usb/tbs-dtb08-fe.h b/drivers/media/dvb/dvb-usb/tbs-dtb08-fe.h
new file mode 100644
index 0000000..6cd82f7
--- /dev/null
+++ b/drivers/media/dvb/dvb-usb/tbs-dtb08-fe.h
@@ -0,0 +1,60 @@
+/*
+ *   TBS-Tech ISDB-T Full Seg DTB08 device driver
+ *
+ *   Copyright (C) 2010-2012 Manoel Pinheiro <pinusdtv@hotmail.com>
+ *
+ *   This program is free software; you can redistribute it and/or modify
+ *   it under the terms of the GNU General Public License as published by
+ *   the Free Software Foundation; either version 2 of the License, or
+ *   (at your option) any later version.
+ *
+ *   This program is distributed in the hope that it will be useful,
+ *   but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *   GNU General Public License for more details.
+ *
+ *   You should have received a copy of the GNU General Public License
+ *   along with this program; if not, write to the Free Software
+ *   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/dvb/frontend.h>
+
+#ifndef DVB_USB_LOG_PREFIX
+#define DVB_USB_LOG_PREFIX "tbs_dtb08-fe"
+#endif
+
+#include "dvb-usb.h"
+#include "mb86a20s.h"
+
+struct dtb08_a20s_reg_subreg_config {
+	u8 reg;
+	u8 subreg;
+	u32 val;
+};
+
+struct dtb08_a20s_state {
+	struct usb_device *udev;
+	int demod_addr;
+	u32 current_frequency;
+	fe_status_t status;
+	u16 snr;
+	u16 strength;
+	unsigned long next_snr_check;
+	unsigned long next_strength_check;
+	unsigned long next_set_frontend_check;
+	unsigned long next_status_check;
+	int config_size;
+	struct dtb08_a20s_reg_subreg_config *config_regs;
+	int (*i2c_read)(struct usb_device *udev,
+			u8 addr, u8 reg, u8 *data, u8 len);
+	int (*i2c_write)(struct usb_device *udev,
+			 u8 addr, u8 reg, u8 *data, u8 len);
+	int (*led_control)(struct usb_device *udev, int onoff);
+	bool need_init;
+	bool tuner_ctrl;
+};
+
+int dtb08_a20s_frontend_attach(struct dtb08_a20s_state *state,
+			       struct dvb_usb_adapter *adap,
+			       const struct mb86a20s_config *config);
-- 
1.7.10

