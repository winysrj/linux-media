Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pw0-f42.google.com ([209.85.160.42]:42179 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755690AbZJZLvt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Oct 2009 07:51:49 -0400
Received: by pwj9 with SMTP id 9so1254473pwj.21
        for <linux-media@vger.kernel.org>; Mon, 26 Oct 2009 04:51:53 -0700 (PDT)
Message-ID: <4AE58D54.3060906@gmail.com>
Date: Mon, 26 Oct 2009 19:51:48 +0800
From: "David T. L. Wong" <davidtlwong@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: v4l-dvb <linux-media@vger.kernel.org>
Subject: [PATCH] AltoBeam ATBM8830 GB20600-2006(DMB-TH) demodulator
Content-Type: multipart/mixed;
 boundary="------------090802000701050200090501"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090802000701050200090501
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

   This patch adds support for Maxim MAX2165 silicon tuner.

   It is tested on Mygica X8558Pro, which has MAX2165, ATBM8830 and CX23885

Regards,
David

Signed-off-by: David T. L. Wong <davidtlwong@gmail.com>

--------------090802000701050200090501
Content-Type: text/x-patch;
 name="atbm8830.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="atbm8830.patch"

changeset:   13167:af24d868416c
user:        David T.L. Wong <davidtlwong@gmail.com>
date:        Mon Oct 26 18:08:17 2009 +0800
summary:     add AltoBeam ATBM8830 GB20600-2006 (A.K.A DMB-TH) digital demodulator support

diff --git a/linux/drivers/media/dvb/frontends/Kconfig b/linux/drivers/media/dvb/frontends/Kconfig
--- a/linux/drivers/media/dvb/frontends/Kconfig
+++ b/linux/drivers/media/dvb/frontends/Kconfig
@@ -557,6 +557,13 @@
 	help
 	  A DMB-TH tuner module. Say Y when you want to support this frontend.
 
+config DVB_ATBM8830
+	tristate "AltoBeam ATBM8830/8831 DMB-TH demodulator"
+	depends on DVB_CORE && I2C
+	default m if DVB_FE_CUSTOMISE
+	help
+	  A DMB-TH tuner module. Say Y when you want to support this frontend.
+
 comment "Tools to develop new frontends"
 
 config DVB_DUMMY_FE
diff --git a/linux/drivers/media/dvb/frontends/Makefile b/linux/drivers/media/dvb/frontends/Makefile
--- a/linux/drivers/media/dvb/frontends/Makefile
+++ b/linux/drivers/media/dvb/frontends/Makefile
@@ -64,6 +64,7 @@
 obj-$(CONFIG_DVB_S5H1411) += s5h1411.o
 obj-$(CONFIG_DVB_LGS8GL5) += lgs8gl5.o
 obj-$(CONFIG_DVB_LGS8GXX) += lgs8gxx.o
+obj-$(CONFIG_DVB_ATBM8830) += atbm8830.o
 obj-$(CONFIG_DVB_DUMMY_FE) += dvb_dummy_fe.o
 obj-$(CONFIG_DVB_AF9013) += af9013.o
 obj-$(CONFIG_DVB_CX24116) += cx24116.o
diff --git a/linux/drivers/media/dvb/frontends/atbm8830.c b/linux/drivers/media/dvb/frontends/atbm8830.c
new file mode 100644
--- /dev/null
+++ b/linux/drivers/media/dvb/frontends/atbm8830.c
@@ -0,0 +1,500 @@
+/*
+ *    Support for AltoBeam GB20600 (a.k.a DMB-TH) demodulator
+ *    ATBM8830, ATBM8831
+ *
+ *    Copyright (C) 2009 David T.L. Wong <davidtlwong@gmail.com>
+ *
+ *    This program is free software; you can redistribute it and/or modify
+ *    it under the terms of the GNU General Public License as published by
+ *    the Free Software Foundation; either version 2 of the License, or
+ *    (at your option) any later version.
+ *
+ *    This program is distributed in the hope that it will be useful,
+ *    but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *    GNU General Public License for more details.
+ *
+ *    You should have received a copy of the GNU General Public License
+ *    along with this program; if not, write to the Free Software
+ *    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include "dvb_frontend.h"
+
+#include "atbm8830.h"
+#include "atbm8830_priv.h"
+
+#define dprintk(args...) \
+	do { \
+		if (debug) \
+			printk(KERN_DEBUG "atbm8830: " args); \
+	} while (0)
+
+static int debug;
+
+module_param(debug, int, 0644);
+MODULE_PARM_DESC(debug, "Turn on/off frontend debugging (default:off).");
+
+static int atbm8830_write_reg(struct atbm_state *priv, u16 reg, u8 data)
+{
+	int ret = 0;
+	u8 dev_addr;
+	u8 buf1[] = { reg >> 8, reg & 0xFF };
+	u8 buf2[] = { data };
+	struct i2c_msg msg1 = { .flags = 0, .buf = buf1, .len = 2 };
+	struct i2c_msg msg2 = { .flags = 0, .buf = buf2, .len = 1 };
+
+	dev_addr = priv->config->demod_address;
+	msg1.addr = dev_addr;
+	msg2.addr = dev_addr;
+
+	if (debug >= 2)
+		printk(KERN_DEBUG "%s: reg=0x%04X, data=0x%02X\n",
+			__func__, reg, data);
+
+	ret = i2c_transfer(priv->i2c, &msg1, 1);
+	if (ret != 1)
+		return -EIO;
+
+	ret = i2c_transfer(priv->i2c, &msg2, 1);
+	return (ret != 1) ? -EIO : 0;
+}
+
+static int atbm8830_read_reg(struct atbm_state *priv, u16 reg, u8 *p_data)
+{
+	int ret;
+	u8 dev_addr;
+
+	u8 buf1[] = { reg >> 8, reg & 0xFF };
+	u8 buf2[] = { 0 };
+	struct i2c_msg msg1 = { .flags = 0, .buf = buf1, .len = 2 };
+	struct i2c_msg msg2 = { .flags = I2C_M_RD, .buf = buf2, .len = 1 };
+
+	dev_addr = priv->config->demod_address;
+	msg1.addr = dev_addr;
+	msg2.addr = dev_addr;
+
+	ret = i2c_transfer(priv->i2c, &msg1, 1);
+	if (ret != 1) {
+		dprintk(KERN_DEBUG "%s: error reg=0x%04x, ret=%i\n",
+			__func__, reg, ret);
+		return -EIO;
+	}
+
+	ret = i2c_transfer(priv->i2c, &msg2, 1);
+	if (ret != 1)
+		return -EIO;
+
+	*p_data = buf2[0];
+	if (debug >= 2)
+		printk(KERN_DEBUG "%s: reg=0x%04X, data=0x%02X\n",
+			__func__, reg, buf2[0]);
+
+	return 0;
+}
+
+/* Lock register latch so that multi-register read is atomic */
+static inline int atbm8830_reglatch_lock(struct atbm_state *priv, int lock)
+{
+	return atbm8830_write_reg(priv, REG_READ_LATCH, lock ? 1 : 0);
+}
+
+static int set_osc_freq(struct atbm_state *priv, u32 freq /*in kHz*/)
+{
+	u32 val;
+
+	val = (u64)0x100000 * freq / 30400;
+
+	atbm8830_write_reg(priv, REG_OSC_CLK, val);
+	atbm8830_write_reg(priv, REG_OSC_CLK + 1, val >> 8);
+	atbm8830_write_reg(priv, REG_OSC_CLK + 2, val >> 16);
+
+	return 0;
+}
+
+static int set_if_freq(struct atbm_state *priv, u32 freq /*in kHz*/)
+{
+	
+	u32 fs = priv->config->osc_clk_freq;
+	double t;
+	u32 val;
+	u8 dat;
+
+	t = 2 * 3.141593 * (freq - fs) / fs * (1 << 22);
+	val = t;
+
+	if (freq != 0) {
+		atbm8830_write_reg(priv, REG_TUNER_BASEBAND, 1);
+		atbm8830_write_reg(priv, REG_IF_FREQ, val);
+		atbm8830_write_reg(priv, REG_IF_FREQ+1, val >> 8);
+		atbm8830_write_reg(priv, REG_IF_FREQ+2, val >> 16);
+
+		atbm8830_read_reg(priv, REG_ADC_CONFIG, &dat);
+		dat &= 0xFC;
+		atbm8830_write_reg(priv, REG_ADC_CONFIG, dat);
+	} else {
+		/* Zero IF */
+		atbm8830_write_reg(priv, REG_TUNER_BASEBAND, 0);
+
+		atbm8830_read_reg(priv, REG_ADC_CONFIG, &dat);
+		dat &= 0xFC;
+		dat |= 0x02;
+		atbm8830_write_reg(priv, REG_ADC_CONFIG, dat);
+
+		if (priv->config->zif_swap_iq)
+			atbm8830_write_reg(priv, REG_SWAP_I_Q, 0x03);
+		else
+			atbm8830_write_reg(priv, REG_SWAP_I_Q, 0x01);
+	}
+
+	return 0;
+}
+
+static int is_locked(struct atbm_state *priv, u8 *locked)
+{
+	u8 status;
+
+	atbm8830_read_reg(priv, REG_LOCK_STATUS, &status);
+
+	if (locked != NULL)
+		*locked = (status == 1);
+	return 0;
+}
+
+static int set_agc_config(struct atbm_state *priv,
+	u8 min, u8 max, u8 hold_loop)
+{
+	atbm8830_write_reg(priv, REG_AGC_MIN, min);
+	atbm8830_write_reg(priv, REG_AGC_MAX, max);
+	atbm8830_write_reg(priv, REG_AGC_HOLD_LOOP, hold_loop);
+
+	return 0;
+}
+
+static int set_static_channel_mode(struct atbm_state *priv)
+{
+	int i;
+
+	for(i = 0; i < 5; i++)
+		atbm8830_write_reg(priv, 0x099B + i, 0x08);
+
+	atbm8830_write_reg(priv, 0x095B, 0x7F);
+	atbm8830_write_reg(priv, 0x09CB, 0x01);
+	atbm8830_write_reg(priv, 0x09CC, 0x7F);
+	atbm8830_write_reg(priv, 0x09CD, 0x7F);
+	atbm8830_write_reg(priv, 0x0E01, 0x20);
+
+	/* For single carrier */
+	atbm8830_write_reg(priv, 0x0B03, 0x0A);
+	atbm8830_write_reg(priv, 0x0935, 0x10);
+	atbm8830_write_reg(priv, 0x0936, 0x08);
+	atbm8830_write_reg(priv, 0x093E, 0x08);
+	atbm8830_write_reg(priv, 0x096E, 0x06);
+
+	/* frame_count_max0 */
+	atbm8830_write_reg(priv, 0x0B09, 0x00);
+	/* frame_count_max1 */
+	atbm8830_write_reg(priv, 0x0B0A, 0x08);
+
+	return 0;
+}
+
+static int set_ts_config(struct atbm_state *priv)
+{
+	const struct atbm8830_config *cfg = priv->config;
+
+	/*Set parallel/serial ts mode*/
+	atbm8830_write_reg(priv, REG_TS_SERIAL, cfg->serial_ts ? 1 : 0);
+	atbm8830_write_reg(priv, REG_TS_CLK_MODE, cfg->serial_ts ? 1 : 0);
+	/*Set ts sampling edge*/
+	atbm8830_write_reg(priv, REG_TS_SAMPLE_EDGE,
+		cfg->ts_sampling_edge ? 1 : 0);
+	/*Set ts clock freerun*/
+	atbm8830_write_reg(priv, REG_TS_CLK_FREERUN,
+		cfg->ts_clk_gated ? 0 : 1);
+
+	return 0;
+}
+
+static int atbm8830_init(struct dvb_frontend *fe)
+{
+	struct atbm_state *priv = fe->demodulator_priv;
+	const struct atbm8830_config *cfg = priv->config;
+
+	/*Set oscillator frequency*/
+	set_osc_freq(priv, cfg->osc_clk_freq);
+
+	/*Set IF frequency*/
+	set_if_freq(priv, cfg->if_freq);
+
+#if 0
+	/*Set AGC Config*/
+	set_agc_config(priv, cfg->agc_min, cfg->agc_max,
+		cfg->agc_hold_loop);
+#endif
+
+	/*Set static channel mode*/
+	set_static_channel_mode(priv);
+
+	set_ts_config(priv);
+	/*Turn off DSP reset*/
+	atbm8830_write_reg(priv, 0x000A, 0);
+
+	/*SW version test*/
+	atbm8830_write_reg(priv, 0x020C, 11);
+
+	/* Run */
+	atbm8830_write_reg(priv, REG_DEMOD_RUN, 1);
+
+	return 0;
+}
+
+
+static void atbm8830_release(struct dvb_frontend *fe)
+{
+	struct atbm_state *state = fe->demodulator_priv;
+	dprintk("%s\n", __func__);
+
+	kfree(state);
+}
+
+static int atbm8830_set_fe(struct dvb_frontend *fe,
+			  struct dvb_frontend_parameters *fe_params)
+{
+	struct atbm_state *priv = fe->demodulator_priv;
+	int i;
+	u8 locked = 0;
+	dprintk("%s\n", __func__);
+
+	/* set frequency */
+	if (fe->ops.tuner_ops.set_params) {
+		if (fe->ops.i2c_gate_ctrl)
+			fe->ops.i2c_gate_ctrl(fe, 1);
+		fe->ops.tuner_ops.set_params(fe, fe_params);
+		if (fe->ops.i2c_gate_ctrl)
+			fe->ops.i2c_gate_ctrl(fe, 0);
+	}
+
+	/* start auto lock */
+	for (i = 0; i < 10; i++) {
+		mdelay(100);
+		dprintk("Try %d\n", i);
+		is_locked(priv, &locked);
+		if (locked != 0) {
+			dprintk("ATBM8830 locked!\n");
+			break;
+		}
+	}
+
+	return 0;
+}
+
+static int atbm8830_get_fe(struct dvb_frontend *fe,
+			  struct dvb_frontend_parameters *fe_params)
+{
+	dprintk("%s\n", __func__);
+
+	/* TODO: get real readings from device */
+	/* inversion status */
+	fe_params->inversion = INVERSION_OFF;
+
+	/* bandwidth */
+	fe_params->u.ofdm.bandwidth = BANDWIDTH_8_MHZ;
+
+	fe_params->u.ofdm.code_rate_HP = FEC_AUTO;
+	fe_params->u.ofdm.code_rate_LP = FEC_AUTO;
+
+	fe_params->u.ofdm.constellation = QAM_AUTO;
+
+	/* transmission mode */
+	fe_params->u.ofdm.transmission_mode = TRANSMISSION_MODE_AUTO;
+
+	/* guard interval */
+	fe_params->u.ofdm.guard_interval = GUARD_INTERVAL_AUTO;
+
+	/* hierarchy */
+	fe_params->u.ofdm.hierarchy_information = HIERARCHY_NONE;
+
+	return 0;
+}
+
+static int atbm8830_get_tune_settings(struct dvb_frontend *fe,
+	struct dvb_frontend_tune_settings *fesettings)
+{
+	fesettings->min_delay_ms = 0;
+	fesettings->step_size = 0;
+	fesettings->max_drift = 0;
+	return 0;
+}
+
+static int atbm8830_read_status(struct dvb_frontend *fe, fe_status_t *fe_status)
+{
+	struct atbm_state *priv = fe->demodulator_priv;
+	u8 locked = 0;
+	u8 agc_locked = 0;
+
+	dprintk("%s\n", __func__);
+	*fe_status = 0;
+
+	is_locked(priv, &locked);
+	if (locked) {
+		*fe_status |= FE_HAS_SIGNAL | FE_HAS_CARRIER |
+			FE_HAS_VITERBI | FE_HAS_SYNC | FE_HAS_LOCK;
+	}
+	dprintk("%s: fe_status=0x%x\n", __func__, *fe_status);
+
+	atbm8830_read_reg(priv, REG_AGC_LOCK, &agc_locked);
+	dprintk("AGC Lock: %d\n", agc_locked);
+
+	return 0;
+}
+
+static int atbm8830_read_ber(struct dvb_frontend *fe, u32 *ber)
+{
+	struct atbm_state *priv = fe->demodulator_priv;
+	u32 frame_err;
+	u8 t;
+
+	dprintk("%s\n", __func__);
+
+	atbm8830_reglatch_lock(priv, 1);
+
+	atbm8830_read_reg(priv, REG_FRAME_ERR_CNT + 1, &t);
+	frame_err = t & 0x7F;
+	frame_err <<= 8;
+	atbm8830_read_reg(priv, REG_FRAME_ERR_CNT, &t);
+	frame_err |= t;
+
+	atbm8830_reglatch_lock(priv, 0);
+
+	*ber = frame_err * 100 / 32767;
+
+	dprintk("%s: ber=0x%x\n", __func__, *ber);
+	return 0;
+}
+
+static int atbm8830_read_signal_strength(struct dvb_frontend *fe, u16 *signal)
+{
+	struct atbm_state *priv = fe->demodulator_priv;
+	u32 pwm;
+	u8 t;
+
+	dprintk("%s\n", __func__);
+	atbm8830_reglatch_lock(priv, 1);
+
+	atbm8830_read_reg(priv, REG_AGC_PWM_VAL + 1, &t);
+	pwm = t & 0x03;
+	pwm <<= 8;
+	atbm8830_read_reg(priv, REG_AGC_PWM_VAL, &t);
+	pwm |= t;
+
+	atbm8830_reglatch_lock(priv, 0);
+
+	dprintk("AGC PWM = 0x%02X\n", pwm);
+	pwm = 0x400 - pwm;
+
+	*signal = pwm * 0x10000 / 0x400;
+
+	return 0;
+}
+
+static int atbm8830_read_snr(struct dvb_frontend *fe, u16 *snr)
+{
+	dprintk("%s\n", __func__);
+	*snr = 0;
+	return 0;
+}
+
+static int atbm8830_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
+{
+	dprintk("%s\n", __func__);
+	*ucblocks = 0;
+	return 0;
+}
+
+static int atbm8830_i2c_gate_ctrl(struct dvb_frontend *fe, int enable)
+{
+	struct atbm_state *priv = fe->demodulator_priv;
+
+	return atbm8830_write_reg(priv, REG_I2C_GATE, enable ? 1 : 0);
+}
+
+static struct dvb_frontend_ops atbm8830_ops = {
+	.info = {
+		.name = "AltoBeam ATBM8830/8831 DMB-TH",
+		.type = FE_OFDM,
+		.frequency_min = 474000000,
+		.frequency_max = 858000000,
+		.frequency_stepsize = 10000,
+		.caps =
+			FE_CAN_FEC_AUTO |
+			FE_CAN_QAM_AUTO |
+			FE_CAN_TRANSMISSION_MODE_AUTO |
+			FE_CAN_GUARD_INTERVAL_AUTO
+	},
+
+	.release = atbm8830_release,
+
+	.init = atbm8830_init,
+	.sleep = NULL,
+	.write = NULL,
+	.i2c_gate_ctrl = atbm8830_i2c_gate_ctrl,
+
+	.set_frontend = atbm8830_set_fe,
+	.get_frontend = atbm8830_get_fe,
+	.get_tune_settings = atbm8830_get_tune_settings,
+
+	.read_status = atbm8830_read_status,
+	.read_ber = atbm8830_read_ber,
+	.read_signal_strength = atbm8830_read_signal_strength,
+	.read_snr = atbm8830_read_snr,
+	.read_ucblocks = atbm8830_read_ucblocks,
+};
+
+struct dvb_frontend *atbm8830_attach(const struct atbm8830_config *config,
+	struct i2c_adapter *i2c)
+{
+	struct atbm_state *priv = NULL;
+	u8 data = 0;
+
+	dprintk("%s()\n", __func__);
+
+	if (config == NULL || i2c == NULL)
+		return NULL;
+
+	priv = kzalloc(sizeof(struct atbm_state), GFP_KERNEL);
+	if (priv == NULL)
+		goto error_out;
+
+	priv->config = config;
+	priv->i2c = i2c;
+
+	/* check if the demod is there */
+	if (atbm8830_read_reg(priv, REG_CHIP_ID, &data) != 0) {
+		dprintk("%s atbm8830/8831 not found at i2c addr 0x%02X\n",
+			__func__, priv->config->demod_address);
+		goto error_out;
+	}
+	dprintk("atbm8830 chip id: 0x%02X\n", data);
+
+	memcpy(&priv->frontend.ops, &atbm8830_ops,
+	       sizeof(struct dvb_frontend_ops));
+	priv->frontend.demodulator_priv = priv;
+
+	atbm8830_init(&priv->frontend);
+
+	atbm8830_i2c_gate_ctrl(&priv->frontend, 1);
+
+	return &priv->frontend;
+
+error_out:
+	dprintk("%s() error_out\n", __func__);
+	kfree(priv);
+	return NULL;
+
+}
+EXPORT_SYMBOL(atbm8830_attach);
+
+MODULE_DESCRIPTION("AltoBeam ATBM8830/8831 GB20600 demodulator driver");
+MODULE_AUTHOR("David T. L. Wong <davidtlwong@gmail.com>");
+MODULE_LICENSE("GPL");
diff --git a/linux/drivers/media/dvb/frontends/atbm8830.h b/linux/drivers/media/dvb/frontends/atbm8830.h
new file mode 100644
--- /dev/null
+++ b/linux/drivers/media/dvb/frontends/atbm8830.h
@@ -0,0 +1,76 @@
+/*
+ *    Support for AltoBeam GB20600 (a.k.a DMB-TH) demodulator
+ *    ATBM8830, ATBM8831
+ *
+ *    Copyright (C) 2009 David T.L. Wong <davidtlwong@gmail.com>
+ *
+ *    This program is free software; you can redistribute it and/or modify
+ *    it under the terms of the GNU General Public License as published by
+ *    the Free Software Foundation; either version 2 of the License, or
+ *    (at your option) any later version.
+ *
+ *    This program is distributed in the hope that it will be useful,
+ *    but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *    GNU General Public License for more details.
+ *
+ *    You should have received a copy of the GNU General Public License
+ *    along with this program; if not, write to the Free Software
+ *    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#ifndef __ATBM8830_H__
+#define __ATBM8830_H__
+
+#include <linux/dvb/frontend.h>
+#include <linux/i2c.h>
+
+#define ATBM8830_PROD_8830 0
+#define ATBM8830_PROD_8831 1
+
+struct atbm8830_config {
+
+	/* product type */
+	u8 prod;
+
+	/* the demodulator's i2c address */
+	u8 demod_address;
+
+	/* parallel or serial transport stream */
+	u8 serial_ts;
+
+	/* transport stream clock output only when receving valid stream */
+	u8 ts_clk_gated;
+
+	/* Decoder sample TS data at rising edge of clock */
+	u8 ts_sampling_edge;
+
+	/* Oscillator clock frequency */
+	u32 osc_clk_freq; /* in kHz */
+
+	/* IF frequency */
+	u32 if_freq; /* in kHz */
+
+	/* Swap I/Q for zero IF */
+	u8 zif_swap_iq;
+
+	/* Tuner AGC settings */
+	u8 agc_min;
+	u8 agc_max;
+	u8 agc_hold_loop;
+};
+
+#if defined(CONFIG_DVB_ATBM8830) || \
+	(defined(CONFIG_DVB_ATBM8830_MODULE) && defined(MODULE))
+extern struct dvb_frontend *atbm8830_attach(const struct atbm8830_config *config,
+		struct i2c_adapter *i2c);
+#else
+static inline
+struct dvb_frontend *atbm8830_attach(const struct atbm8830_config *config,
+		struct i2c_adapter *i2c) {
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
+	return NULL;
+}
+#endif /* CONFIG_DVB_ATBM8830 */
+
+#endif /* __ATBM8830_H__ */
diff --git a/linux/drivers/media/dvb/frontends/atbm8830_priv.h b/linux/drivers/media/dvb/frontends/atbm8830_priv.h
new file mode 100644
--- /dev/null
+++ b/linux/drivers/media/dvb/frontends/atbm8830_priv.h
@@ -0,0 +1,75 @@
+/*
+ *    Support for AltoBeam GB20600 (a.k.a DMB-TH) demodulator
+ *    ATBM8830, ATBM8831
+ *
+ *    Copyright (C) 2009 David T.L. Wong <davidtlwong@gmail.com>
+ *
+ *    This program is free software; you can redistribute it and/or modify
+ *    it under the terms of the GNU General Public License as published by
+ *    the Free Software Foundation; either version 2 of the License, or
+ *    (at your option) any later version.
+ *
+ *    This program is distributed in the hope that it will be useful,
+ *    but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *    GNU General Public License for more details.
+ *
+ *    You should have received a copy of the GNU General Public License
+ *    along with this program; if not, write to the Free Software
+ *    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+ 
+#ifndef __ATBM8830_PRIV_H
+#define __ATBM8830_PRIV_H
+
+struct atbm_state {
+	struct i2c_adapter *i2c;
+	/* configuration settings */
+	const struct atbm8830_config *config;
+	struct dvb_frontend frontend;
+};
+
+#define REG_CHIP_ID	0x0000
+#define REG_TUNER_BASEBAND	0x0001
+#define REG_DEMOD_RUN	0x0004
+#define REG_DSP_RESET	0x0005
+#define REG_RAM_RESET	0x0006
+#define REG_ADC_RESET	0x0007
+#define REG_TSPORT_RESET	0x0008
+#define REG_BLKERR_POL	0x000C
+#define REG_I2C_GATE	0x0103
+#define REG_TS_SAMPLE_EDGE	0x0301
+#define REG_TS_PKT_LEN_204	0x0302
+#define REG_TS_PKT_LEN_AUTO	0x0303
+#define REG_TS_SERIAL	0x0305
+#define REG_TS_CLK_FREERUN	0x0306
+#define REG_TS_VALID_MODE	0x0307
+#define REG_TS_CLK_MODE	0x030B /* 1 for serial, 0 for parallel */
+
+#define REG_TS_ERRBIT_USE	0x030C
+#define REG_LOCK_STATUS	0x030D
+#define REG_ADC_CONFIG	0x0602
+#define REG_CARRIER_OFFSET	0x0827 /* 0x0827-0x0829 little endian */
+#define REG_DETECTED_PN_MODE	0x082D
+#define REG_READ_LATCH	0x084D
+#define REG_IF_FREQ	0x0A00 /* 0x0A00-0x0A02 little endian */
+#define REG_OSC_CLK	0x0A03 /* 0x0A03-0x0A05 little endian */
+#define REG_BYPASS_CCI	0x0A06
+#define REG_ANALOG_LUMA_DETECTED	0x0A25
+#define REG_ANALOG_AUDIO_DETECTED	0x0A26
+#define REG_ANALOG_CHROMA_DETECTED	0x0A39
+#define REG_FRAME_ERR_CNT	0x0B04
+#define REG_USE_EXT_ADC	0x0C00
+#define REG_SWAP_I_Q	0x0C01
+#define REG_TPS_MANUAL	0x0D01
+#define REG_TPS_CONFIG	0x0D02
+#define REG_BYPASS_DEINTERLEAVER	0x0E00
+#define REG_AGC_TARGET	0x1003 /* 0x1003-0x1005 little endian */
+#define REG_AGC_MIN	0x1020
+#define REG_AGC_MAX	0x1023
+#define REG_AGC_LOCK	0x1027
+#define REG_AGC_PWM_VAL	0x1028 /* 0x1028-0x1029 little endian */
+#define REG_AGC_HOLD_LOOP	0x1031
+
+#endif
+


--------------090802000701050200090501--
