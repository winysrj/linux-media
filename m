Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:58310 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754674Ab2EFVTp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 May 2012 17:19:45 -0400
Received: by eaaq12 with SMTP id q12so1231147eaa.19
        for <linux-media@vger.kernel.org>; Sun, 06 May 2012 14:19:44 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 7 May 2012 00:19:44 +0300
Message-ID: <CAF0Ff2k6s3nt16_v5eacwHLr3PueYaMYGoy_XAmGwbfBjHh_fA@mail.gmail.com>
Subject: [PATCH 1/3] ds3000: remove ts2020 tuner related code
From: Konstantin Dimitrov <kosio.dimitrov@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

remove ts2020 tuner related code from ds3000 driver
prepare ds3000 driver for using external tuner driver

Signed-off-by: Konstantin Dimitrov <kosio.dimitrov@gmail.com>

--- a/linux/drivers/media/dvb/frontends/ds3000.h	2011-02-27
06:45:21.000000000 +0200
+++ b/linux/drivers/media/dvb/frontends/ds3000.h	2012-05-07
00:44:19.188554007 +0300
@@ -1,8 +1,8 @@
 /*
-    Montage Technology DS3000/TS2020 - DVBS/S2 Satellite demod/tuner driver
-    Copyright (C) 2009 Konstantin Dimitrov <kosio.dimitrov@gmail.com>
+    Montage Technology DS3000 - DVBS/S2 Demodulator driver
+    Copyright (C) 2009-2012 Konstantin Dimitrov <kosio.dimitrov@gmail.com>

-    Copyright (C) 2009 TurboSight.com
+    Copyright (C) 2009-2012 TurboSight.com

     This program is free software; you can redistribute it and/or modify
     it under the terms of the GNU General Public License as published by
@@ -17,7 +17,7 @@
     You should have received a copy of the GNU General Public License
     along with this program; if not, write to the Free Software
     Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
-*/
+ */

 #ifndef DS3000_H
 #define DS3000_H
@@ -30,6 +30,8 @@
 	u8 ci_mode;
 	/* Set device param to start dma */
 	int (*set_ts_params)(struct dvb_frontend *fe, int is_punctured);
+	int (*tuner_set_frequency) (struct dvb_frontend *fe, u32 frequency);
+	int (*tuner_get_frequency) (struct dvb_frontend *fe, u32 *frequency);
 };

 #if defined(CONFIG_DVB_DS3000) || \
--- a/linux/drivers/media/dvb/frontends/ds3000.c	2012-01-19
06:45:32.000000000 +0200
+++ b/linux/drivers/media/dvb/frontends/ds3000.c	2012-05-07
00:40:39.856556762 +0300
@@ -1,8 +1,8 @@
 /*
-    Montage Technology DS3000/TS2020 - DVBS/S2 Demodulator/Tuner driver
-    Copyright (C) 2009 Konstantin Dimitrov <kosio.dimitrov@gmail.com>
+    Montage Technology DS3000 - DVBS/S2 Demodulator driver
+    Copyright (C) 2009-2012 Konstantin Dimitrov <kosio.dimitrov@gmail.com>

-    Copyright (C) 2009 TurboSight.com
+    Copyright (C) 2009-2012 TurboSight.com

     This program is free software; you can redistribute it and/or modify
     it under the terms of the GNU General Public License as published by
@@ -42,7 +42,6 @@
 #define DS3000_DEFAULT_FIRMWARE "dvb-fe-ds3000.fw"

 #define DS3000_SAMPLE_RATE 96000 /* in kHz */
-#define DS3000_XTAL_FREQ   27000 /* in kHz */

 /* Register values to initialise the demod in DVB-S mode */
 static u8 ds3000_dvbs_init_tab[] = {
@@ -257,22 +256,14 @@
 	return 0;
 }

-static int ds3000_tuner_writereg(struct ds3000_state *state, int reg, int data)
+static int ds3000_i2c_gate_ctrl(struct dvb_frontend *fe, int enable)
 {
-	u8 buf[] = { reg, data };
-	struct i2c_msg msg = { .addr = 0x60,
-		.flags = 0, .buf = buf, .len = 2 };
-	int err;
-
-	dprintk("%s: write reg 0x%02x, value 0x%02x\n", __func__, reg, data);
+	struct ds3000_state *state = fe->demodulator_priv;

-	ds3000_writereg(state, 0x03, 0x11);
-	err = i2c_transfer(state->i2c, &msg, 1);
-	if (err != 1) {
-		printk("%s: writereg error(err == %i, reg == 0x%02x,"
-			 " value == 0x%02x)\n", __func__, err, reg, data);
-		return -EREMOTEIO;
-	}
+	if (enable)
+		ds3000_writereg(state, 0x03, 0x12);
+	else
+		ds3000_writereg(state, 0x03, 0x02);

 	return 0;
 }
@@ -349,38 +340,6 @@
 	return b1[0];
 }

-static int ds3000_tuner_readreg(struct ds3000_state *state, u8 reg)
-{
-	int ret;
-	u8 b0[] = { reg };
-	u8 b1[] = { 0 };
-	struct i2c_msg msg[] = {
-		{
-			.addr = 0x60,
-			.flags = 0,
-			.buf = b0,
-			.len = 1
-		}, {
-			.addr = 0x60,
-			.flags = I2C_M_RD,
-			.buf = b1,
-			.len = 1
-		}
-	};
-
-	ds3000_writereg(state, 0x03, 0x12);
-	ret = i2c_transfer(state->i2c, msg, 2);
-
-	if (ret != 2) {
-		printk(KERN_ERR "%s: reg=0x%x(error=%d)\n", __func__, reg, ret);
-		return ret;
-	}
-
-	dprintk("%s: read reg 0x%02x, value 0x%02x\n", __func__, reg, b1[0]);
-
-	return b1[0];
-}
-
 static int ds3000_load_firmware(struct dvb_frontend *fe,
 					const struct firmware *fw);

@@ -580,29 +539,8 @@
 static int ds3000_read_signal_strength(struct dvb_frontend *fe,
 						u16 *signal_strength)
 {
-	struct ds3000_state *state = fe->demodulator_priv;
-	u16 sig_reading, sig_strength;
-	u8 rfgain, bbgain;
-
-	dprintk("%s()\n", __func__);
-
-	rfgain = ds3000_tuner_readreg(state, 0x3d) & 0x1f;
-	bbgain = ds3000_tuner_readreg(state, 0x21) & 0x1f;
-
-	if (rfgain > 15)
-		rfgain = 15;
-	if (bbgain > 13)
-		bbgain = 13;
-
-	sig_reading = rfgain * 2 + bbgain * 3;
-
-	sig_strength = 40 + (64 - sig_reading) * 50 / 64 ;
-
-	/* cook the value to be suitable for szap-s2 human readable output */
-	*signal_strength = sig_strength * 1000;
-
-	dprintk("%s: raw / cooked = 0x%04x / 0x%04x\n", __func__,
-			sig_reading, *signal_strength);
+	/* temporary disabled until seperate ts2020 tuner driver is merged */
+	*signal_strength = 0xffff;

 	return 0;
 }
@@ -960,133 +898,16 @@

 	int i;
 	fe_status_t status;
-	u8 mlpf, mlpf_new, mlpf_max, mlpf_min, nlpf, div4;
-	s32 offset_khz;
-	u16 value, ndiv;
-	u32 f3db;
+	s32 offset_khz, frequency;
+	u16 value;

 	dprintk("%s() ", __func__);

 	if (state->config->set_ts_params)
 		state->config->set_ts_params(fe, 0);
 	/* Tune */
-	/* unknown */
-	ds3000_tuner_writereg(state, 0x07, 0x02);
-	ds3000_tuner_writereg(state, 0x10, 0x00);
-	ds3000_tuner_writereg(state, 0x60, 0x79);
-	ds3000_tuner_writereg(state, 0x08, 0x01);
-	ds3000_tuner_writereg(state, 0x00, 0x01);
-	div4 = 0;
-
-	/* calculate and set freq divider */
-	if (c->frequency < 1146000) {
-		ds3000_tuner_writereg(state, 0x10, 0x11);
-		div4 = 1;
-		ndiv = ((c->frequency * (6 + 8) * 4) +
-				(DS3000_XTAL_FREQ / 2)) /
-				DS3000_XTAL_FREQ - 1024;
-	} else {
-		ds3000_tuner_writereg(state, 0x10, 0x01);
-		ndiv = ((c->frequency * (6 + 8) * 2) +
-				(DS3000_XTAL_FREQ / 2)) /
-				DS3000_XTAL_FREQ - 1024;
-	}
-
-	ds3000_tuner_writereg(state, 0x01, (ndiv & 0x0f00) >> 8);
-	ds3000_tuner_writereg(state, 0x02, ndiv & 0x00ff);
-
-	/* set pll */
-	ds3000_tuner_writereg(state, 0x03, 0x06);
-	ds3000_tuner_writereg(state, 0x51, 0x0f);
-	ds3000_tuner_writereg(state, 0x51, 0x1f);
-	ds3000_tuner_writereg(state, 0x50, 0x10);
-	ds3000_tuner_writereg(state, 0x50, 0x00);
-	msleep(5);
-
-	/* unknown */
-	ds3000_tuner_writereg(state, 0x51, 0x17);
-	ds3000_tuner_writereg(state, 0x51, 0x1f);
-	ds3000_tuner_writereg(state, 0x50, 0x08);
-	ds3000_tuner_writereg(state, 0x50, 0x00);
-	msleep(5);
-
-	value = ds3000_tuner_readreg(state, 0x3d);
-	value &= 0x0f;
-	if ((value > 4) && (value < 15)) {
-		value -= 3;
-		if (value < 4)
-			value = 4;
-		value = ((value << 3) | 0x01) & 0x79;
-	}
-
-	ds3000_tuner_writereg(state, 0x60, value);
-	ds3000_tuner_writereg(state, 0x51, 0x17);
-	ds3000_tuner_writereg(state, 0x51, 0x1f);
-	ds3000_tuner_writereg(state, 0x50, 0x08);
-	ds3000_tuner_writereg(state, 0x50, 0x00);
-
-	/* set low-pass filter period */
-	ds3000_tuner_writereg(state, 0x04, 0x2e);
-	ds3000_tuner_writereg(state, 0x51, 0x1b);
-	ds3000_tuner_writereg(state, 0x51, 0x1f);
-	ds3000_tuner_writereg(state, 0x50, 0x04);
-	ds3000_tuner_writereg(state, 0x50, 0x00);
-	msleep(5);
-
-	f3db = ((c->symbol_rate / 1000) << 2) / 5 + 2000;
-	if ((c->symbol_rate / 1000) < 5000)
-		f3db += 3000;
-	if (f3db < 7000)
-		f3db = 7000;
-	if (f3db > 40000)
-		f3db = 40000;
-
-	/* set low-pass filter baseband */
-	value = ds3000_tuner_readreg(state, 0x26);
-	mlpf = 0x2e * 207 / ((value << 1) + 151);
-	mlpf_max = mlpf * 135 / 100;
-	mlpf_min = mlpf * 78 / 100;
-	if (mlpf_max > 63)
-		mlpf_max = 63;
-
-	/* rounded to the closest integer */
-	nlpf = ((mlpf * f3db * 1000) + (2766 * DS3000_XTAL_FREQ / 2))
-			/ (2766 * DS3000_XTAL_FREQ);
-	if (nlpf > 23)
-		nlpf = 23;
-	if (nlpf < 1)
-		nlpf = 1;
-
-	/* rounded to the closest integer */
-	mlpf_new = ((DS3000_XTAL_FREQ * nlpf * 2766) +
-			(1000 * f3db / 2)) / (1000 * f3db);
-
-	if (mlpf_new < mlpf_min) {
-		nlpf++;
-		mlpf_new = ((DS3000_XTAL_FREQ * nlpf * 2766) +
-				(1000 * f3db / 2)) / (1000 * f3db);
-	}
-
-	if (mlpf_new > mlpf_max)
-		mlpf_new = mlpf_max;
-
-	ds3000_tuner_writereg(state, 0x04, mlpf_new);
-	ds3000_tuner_writereg(state, 0x06, nlpf);
-	ds3000_tuner_writereg(state, 0x51, 0x1b);
-	ds3000_tuner_writereg(state, 0x51, 0x1f);
-	ds3000_tuner_writereg(state, 0x50, 0x04);
-	ds3000_tuner_writereg(state, 0x50, 0x00);
-	msleep(5);
-
-	/* unknown */
-	ds3000_tuner_writereg(state, 0x51, 0x1e);
-	ds3000_tuner_writereg(state, 0x51, 0x1f);
-	ds3000_tuner_writereg(state, 0x50, 0x01);
-	ds3000_tuner_writereg(state, 0x50, 0x00);
-	msleep(60);
-
-	offset_khz = (ndiv - ndiv % 2 + 1024) * DS3000_XTAL_FREQ
-		/ (6 + 8) / (div4 + 1) / 2 - c->frequency;
+	if (state->config->tuner_set_frequency)
+		state->config->tuner_set_frequency(fe, c->frequency);

 	/* ds3000 global reset */
 	ds3000_writereg(state, 0x07, 0x80);
@@ -1191,7 +1012,11 @@
 	/* start ds3000 build-in uC */
 	ds3000_writereg(state, 0xb2, 0x00);

-	ds3000_set_carrier_offset(fe, offset_khz);
+	if (state->config->tuner_get_frequency) {
+		offset_khz = state->config->tuner_get_frequency(fe, &frequency);
+		offset_khz = frequency - c->frequency;
+		ds3000_set_carrier_offset(fe, offset_khz);
+	}

 	for (i = 0; i < 30 ; i++) {
 		ds3000_read_status(fe, &status);
@@ -1221,6 +1046,15 @@
 	return ds3000_read_status(fe, status);
 }

+static int ds3000_get_frontend(struct dvb_frontend *fe)
+{
+	/* struct dtv_frontend_properties *c = &fe->dtv_property_cache; */
+
+	/* FIXME: for optimal performance get the SR from the silicon */
+
+	return 0;
+}
+
 static enum dvbfe_algo ds3000_get_algo(struct dvb_frontend *fe)
 {
 	dprintk("%s()\n", __func__);
@@ -1242,10 +1076,6 @@
 	ds3000_writereg(state, 0x08, 0x01 | ds3000_readreg(state, 0x08));
 	msleep(1);

-	/* TS2020 init */
-	ds3000_tuner_writereg(state, 0x42, 0x73);
-	ds3000_tuner_writereg(state, 0x05, 0x01);
-	ds3000_tuner_writereg(state, 0x62, 0xf5);
 	/* Load the firmware if required */
 	ret = ds3000_firmware_ondemand(fe);
 	if (ret != 0) {
@@ -1264,9 +1094,9 @@
 }

 static struct dvb_frontend_ops ds3000_ops = {
-	.delsys = { SYS_DVBS, SYS_DVBS2},
+	.delsys = { SYS_DVBS, SYS_DVBS2 },
 	.info = {
-		.name = "Montage Technology DS3000/TS2020",
+		.name = "Montage Technology DS3000",
 		.frequency_min = 950000,
 		.frequency_max = 2150000,
 		.frequency_stepsize = 1011, /* kHz for QPSK frontends */
@@ -1285,6 +1115,7 @@

 	.init = ds3000_initfe,
 	.sleep = ds3000_sleep,
+	.i2c_gate_ctrl = ds3000_i2c_gate_ctrl,
 	.read_status = ds3000_read_status,
 	.read_ber = ds3000_read_ber,
 	.read_signal_strength = ds3000_read_signal_strength,
@@ -1295,6 +1126,7 @@
 	.diseqc_send_master_cmd = ds3000_send_diseqc_msg,
 	.diseqc_send_burst = ds3000_diseqc_send_burst,
 	.get_frontend_algo = ds3000_get_algo,
+	.get_frontend = ds3000_get_frontend,

 	.set_frontend = ds3000_set_frontend,
 	.tune = ds3000_tune,
@@ -1304,6 +1136,6 @@
 MODULE_PARM_DESC(debug, "Activates frontend debugging (default:0)");

 MODULE_DESCRIPTION("DVB Frontend module for Montage Technology "
-			"DS3000/TS2020 hardware");
-MODULE_AUTHOR("Konstantin Dimitrov");
+			"DS3000 hardware");
+MODULE_AUTHOR("Konstantin Dimitrov <kosio.dimitrov@gmail.com>");
 MODULE_LICENSE("GPL");
