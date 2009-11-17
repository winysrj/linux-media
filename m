Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:47909 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755453AbZKQBg4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Nov 2009 20:36:56 -0500
Received: by bwz27 with SMTP id 27so6349904bwz.21
        for <linux-media@vger.kernel.org>; Mon, 16 Nov 2009 17:37:01 -0800 (PST)
From: "Igor M. Liplianin" <liplianin@me.by>
To: Mauro Chehab <mchehab@infradead.org>, linux-media@vger.kernel.org
Subject: [PATCH] Add Prof 7301 PCI DVB-S2 card
Date: Tue, 17 Nov 2009 03:35:56 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911170335.56527.liplianin@me.by>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

# HG changeset patch
# User Igor M. Liplianin <liplianin@me.by>
# Date 1258420952 -7200
# Node ID b7c6748070e3547ceedd00fe90d2d220c4568e32
# Parent  e341e9e85af2f8190e2b2c087b4b7888e78905ee
Add Prof 7301 PCI DVB-S2 card

From: Igor M. Liplianin <liplianin@me.by>

The card based on stv0903 demod, stb6100 tuner.

Signed-off-by: Igor M. Liplianin <liplianin@me.by>

diff -r e341e9e85af2 -r b7c6748070e3 linux/Documentation/video4linux/CARDLIST.cx88
--- a/linux/Documentation/video4linux/CARDLIST.cx88	Fri Nov 13 22:22:03 2009 -0200
+++ b/linux/Documentation/video4linux/CARDLIST.cx88	Tue Nov 17 03:22:32 2009 +0200
@@ -81,3 +81,4 @@
  80 -> Hauppauge WinTV-IR Only                             [0070:9290]
  81 -> Leadtek WinFast DTV1800 Hybrid                      [107d:6654]
  82 -> WinFast DTV2000 H rev. J                            [107d:6f2b]
+ 83 -> Prof 7301 DVB-S/S2                                  [b034:3034]
diff -r e341e9e85af2 -r b7c6748070e3 linux/drivers/media/dvb/frontends/stb6100_proc.h
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/linux/drivers/media/dvb/frontends/stb6100_proc.h	Tue Nov 17 03:22:32 2009 +0200
@@ -0,0 +1,138 @@
+/*
+	STB6100 Silicon Tuner wrapper
+	Copyright (C)2009 Igor M. Liplianin (liplianin@me.by)
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
+*/
+
+static int stb6100_get_freq(struct dvb_frontend *fe, u32 *frequency)
+{
+	struct dvb_frontend_ops	*frontend_ops = NULL;
+	struct dvb_tuner_ops	*tuner_ops = NULL;
+	struct tuner_state	state;
+	int err = 0;
+
+	if (&fe->ops)
+		frontend_ops = &fe->ops;
+	if (&frontend_ops->tuner_ops)
+		tuner_ops = &frontend_ops->tuner_ops;
+	if (tuner_ops->get_state) {
+		if (frontend_ops->i2c_gate_ctrl)
+			frontend_ops->i2c_gate_ctrl(fe, 1);
+
+		err = tuner_ops->get_state(fe, DVBFE_TUNER_FREQUENCY, &state);
+		if (err < 0) {
+			printk(KERN_ERR "%s: Invalid parameter\n", __func__);
+			return err;
+		}
+
+		if (frontend_ops->i2c_gate_ctrl)
+			frontend_ops->i2c_gate_ctrl(fe, 0);
+
+		*frequency = state.frequency;
+	}
+
+	return 0;
+}
+
+static int stb6100_set_freq(struct dvb_frontend *fe, u32 frequency)
+{
+	struct dvb_frontend_ops	*frontend_ops = NULL;
+	struct dvb_tuner_ops	*tuner_ops = NULL;
+	struct tuner_state	state;
+	int err = 0;
+
+	state.frequency = frequency;
+	if (&fe->ops)
+		frontend_ops = &fe->ops;
+	if (&frontend_ops->tuner_ops)
+		tuner_ops = &frontend_ops->tuner_ops;
+	if (tuner_ops->set_state) {
+		if (frontend_ops->i2c_gate_ctrl)
+			frontend_ops->i2c_gate_ctrl(fe, 1);
+
+		err = tuner_ops->set_state(fe, DVBFE_TUNER_FREQUENCY, &state);
+		if (err < 0) {
+			printk(KERN_ERR "%s: Invalid parameter\n", __func__);
+			return err;
+		}
+
+		if (frontend_ops->i2c_gate_ctrl)
+			frontend_ops->i2c_gate_ctrl(fe, 0);
+
+	}
+
+	return 0;
+}
+
+static int stb6100_get_bandw(struct dvb_frontend *fe, u32 *bandwidth)
+{
+	struct dvb_frontend_ops	*frontend_ops = NULL;
+	struct dvb_tuner_ops	*tuner_ops = NULL;
+	struct tuner_state	state;
+	int err = 0;
+
+	if (&fe->ops)
+		frontend_ops = &fe->ops;
+	if (&frontend_ops->tuner_ops)
+		tuner_ops = &frontend_ops->tuner_ops;
+	if (tuner_ops->get_state) {
+		if (frontend_ops->i2c_gate_ctrl)
+			frontend_ops->i2c_gate_ctrl(fe, 1);
+
+		err = tuner_ops->get_state(fe, DVBFE_TUNER_BANDWIDTH, &state);
+		if (err < 0) {
+			printk(KERN_ERR "%s: Invalid parameter\n", __func__);
+			return err;
+		}
+
+		if (frontend_ops->i2c_gate_ctrl)
+			frontend_ops->i2c_gate_ctrl(fe, 0);
+
+		*bandwidth = state.bandwidth;
+	}
+
+	return 0;
+}
+
+static int stb6100_set_bandw(struct dvb_frontend *fe, u32 bandwidth)
+{
+	struct dvb_frontend_ops	*frontend_ops = NULL;
+	struct dvb_tuner_ops	*tuner_ops = NULL;
+	struct tuner_state	state;
+	int err = 0;
+
+	state.bandwidth = bandwidth;
+	if (&fe->ops)
+		frontend_ops = &fe->ops;
+	if (&frontend_ops->tuner_ops)
+		tuner_ops = &frontend_ops->tuner_ops;
+	if (tuner_ops->set_state) {
+		if (frontend_ops->i2c_gate_ctrl)
+			frontend_ops->i2c_gate_ctrl(fe, 1);
+
+		err = tuner_ops->set_state(fe, DVBFE_TUNER_BANDWIDTH, &state);
+		if (err < 0) {
+			printk(KERN_ERR "%s: Invalid parameter\n", __func__);
+			return err;
+		}
+
+		if (frontend_ops->i2c_gate_ctrl)
+			frontend_ops->i2c_gate_ctrl(fe, 0);
+
+	}
+
+	return 0;
+}
diff -r e341e9e85af2 -r b7c6748070e3 linux/drivers/media/dvb/frontends/stv0900.h
--- a/linux/drivers/media/dvb/frontends/stv0900.h	Fri Nov 13 22:22:03 2009 -0200
+++ b/linux/drivers/media/dvb/frontends/stv0900.h	Tue Nov 17 03:22:32 2009 +0200
@@ -48,6 +48,8 @@
 	u8 tun2_maddress;
 	u8 tun1_adc;/* 1 for stv6110, 2 for stb6100 */
 	u8 tun2_adc;
+	/* Set device param to start dma */
+	int (*set_ts_params)(struct dvb_frontend *fe, int is_punctured);
 };
 
 #if defined(CONFIG_DVB_STV0900) || (defined(CONFIG_DVB_STV0900_MODULE) \
diff -r e341e9e85af2 -r b7c6748070e3 linux/drivers/media/dvb/frontends/stv0900_core.c
--- a/linux/drivers/media/dvb/frontends/stv0900_core.c	Fri Nov 13 22:22:03 2009 -0200
+++ b/linux/drivers/media/dvb/frontends/stv0900_core.c	Tue Nov 17 03:22:32 2009 +0200
@@ -1557,6 +1557,9 @@
 
 	dprintk("%s: ", __func__);
 
+	if (state->config->set_ts_params)
+		state->config->set_ts_params(fe, 0);
+
 	p_result.locked = FALSE;
 	p_search.path = state->demod;
 	p_search.frequency = c->frequency;
diff -r e341e9e85af2 -r b7c6748070e3 linux/drivers/media/video/cx88/Kconfig
--- a/linux/drivers/media/video/cx88/Kconfig	Fri Nov 13 22:22:03 2009 -0200
+++ b/linux/drivers/media/video/cx88/Kconfig	Tue Nov 17 03:22:32 2009 +0200
@@ -61,6 +61,8 @@
 	select DVB_STV0299 if !DVB_FE_CUSTOMISE
 	select DVB_STV0288 if !DVB_FE_CUSTOMISE
 	select DVB_STB6000 if !DVB_FE_CUSTOMISE
+	select DVB_STV0900 if !DVB_FE_CUSTOMISE
+	select DVB_STB6100 if !DVB_FE_CUSTOMISE
 	select MEDIA_TUNER_SIMPLE if !MEDIA_TUNER_CUSTOMISE
 	---help---
 	  This adds support for DVB/ATSC cards based on the
diff -r e341e9e85af2 -r b7c6748070e3 linux/drivers/media/video/cx88/cx88-cards.c
--- a/linux/drivers/media/video/cx88/cx88-cards.c	Fri Nov 13 22:22:03 2009 -0200
+++ b/linux/drivers/media/video/cx88/cx88-cards.c	Tue Nov 17 03:22:32 2009 +0200
@@ -2108,6 +2108,18 @@
 		},
 		.mpeg           = CX88_MPEG_DVB,
 	},
+	[CX88_BOARD_PROF_7301] = {
+		.name           = "Prof 7301 DVB-S/S2",
+		.tuner_type     = UNSET,
+		.radio_type     = UNSET,
+		.tuner_addr     = ADDR_UNSET,
+		.radio_addr     = ADDR_UNSET,
+		.input          = { {
+			.type   = CX88_VMUX_DVB,
+			.vmux   = 0,
+		} },
+		.mpeg           = CX88_MPEG_DVB,
+	},
 };
 
 /* ------------------------------------------------------------------ */
@@ -2568,6 +2580,10 @@
 		.subvendor = 0x107d,
 		.subdevice = 0x6618,
 		.card      = CX88_BOARD_WINFAST_TV2000_XP_GLOBAL,
+	}, {
+		.subvendor = 0xb034,
+		.subdevice = 0x3034,
+		.card      = CX88_BOARD_PROF_7301,
 	},
 };
 
@@ -3244,6 +3260,7 @@
 	case  CX88_BOARD_TBS_8920:
 	case  CX88_BOARD_PROF_6200:
 	case  CX88_BOARD_PROF_7300:
+	case  CX88_BOARD_PROF_7301:
 	case  CX88_BOARD_SATTRADE_ST4200:
 		cx_write(MO_GP0_IO, 0x8000);
 		msleep(100);
diff -r e341e9e85af2 -r b7c6748070e3 linux/drivers/media/video/cx88/cx88-dvb.c
--- a/linux/drivers/media/video/cx88/cx88-dvb.c	Fri Nov 13 22:22:03 2009 -0200
+++ b/linux/drivers/media/video/cx88/cx88-dvb.c	Tue Nov 17 03:22:32 2009 +0200
@@ -54,6 +54,9 @@
 #include "stv0288.h"
 #include "stb6000.h"
 #include "cx24116.h"
+#include "stv0900.h"
+#include "stb6100.h"
+#include "stb6100_proc.h"
 
 MODULE_DESCRIPTION("driver for cx2388x based DVB cards");
 MODULE_AUTHOR("Chris Pascoe <c.pascoe@itee.uq.edu.au>");
@@ -580,6 +583,15 @@
 	return 0;
 }
 
+static int stv0900_set_ts_param(struct dvb_frontend *fe,
+	int is_punctured)
+{
+	struct cx8802_dev *dev = fe->dvb->priv;
+	dev->ts_gen_cntrl = 0;
+
+	return 0;
+}
+
 static int cx24116_reset_device(struct dvb_frontend *fe)
 {
 	struct cx8802_dev *dev = fe->dvb->priv;
@@ -608,6 +620,23 @@
 	.reset_device  = cx24116_reset_device,
 };
 
+static struct stv0900_config prof_7301_stv0900_config = {
+	.demod_address = 0x6a,
+/*	demod_mode = 0,*/
+	.xtal = 27000000,
+	.clkmode = 3,/* 0-CLKI, 2-XTALI, else AUTO */
+	.diseqc_mode = 2,/* 2/3 PWM */
+	.tun1_maddress = 0,/* 0x60 */
+	.tun1_adc = 0,/* 2 Vpp */
+	.path1_mode = 3,
+	.set_ts_params = stv0900_set_ts_param,
+};
+
+static struct stb6100_config prof_7301_stb6100_config = {
+	.tuner_address = 0x60,
+	.refclock = 27000000,
+};
+
 static struct stv0299_config tevii_tuner_sharp_config = {
 	.demod_address = 0x68,
 	.inittab = sharp_z0194a_inittab,
@@ -1156,6 +1185,31 @@
 				goto frontend_detach;
 		}
 		break;
+	case CX88_BOARD_PROF_7301:{
+		struct dvb_tuner_ops *tuner_ops = NULL;
+
+		fe0->dvb.frontend = dvb_attach(stv0900_attach,
+						&prof_7301_stv0900_config,
+						&core->i2c_adap, 0);
+		if (fe0->dvb.frontend != NULL) {
+			if (!dvb_attach(stb6100_attach, fe0->dvb.frontend,
+					&prof_7301_stb6100_config,
+					&core->i2c_adap))
+				goto frontend_detach;
+
+			tuner_ops = &fe0->dvb.frontend->ops.tuner_ops;
+			tuner_ops->set_frequency = stb6100_set_freq;
+			tuner_ops->get_frequency = stb6100_get_freq;
+			tuner_ops->set_bandwidth = stb6100_set_bandw;
+			tuner_ops->get_bandwidth = stb6100_get_bandw;
+
+			core->prev_set_voltage =
+					fe0->dvb.frontend->ops.set_voltage;
+			fe0->dvb.frontend->ops.set_voltage =
+					tevii_dvbs_set_voltage;
+		}
+		break;
+		}
 	default:
 		printk(KERN_ERR "%s/2: The frontend of your DVB/ATSC card isn't supported yet\n",
 		       core->name);
diff -r e341e9e85af2 -r b7c6748070e3 linux/drivers/media/video/cx88/cx88-input.c
--- a/linux/drivers/media/video/cx88/cx88-input.c	Fri Nov 13 22:22:03 2009 -0200
+++ b/linux/drivers/media/video/cx88/cx88-input.c	Tue Nov 17 03:22:32 2009 +0200
@@ -309,6 +309,7 @@
 	case CX88_BOARD_TBS_8920:
 	case CX88_BOARD_TBS_8910:
 	case CX88_BOARD_PROF_7300:
+	case CX88_BOARD_PROF_7301:
 	case CX88_BOARD_PROF_6200:
 		ir_codes = &ir_codes_tbs_nec_table;
 		ir_type = IR_TYPE_PD;
@@ -462,6 +463,7 @@
 	case CX88_BOARD_TBS_8920:
 	case CX88_BOARD_TBS_8910:
 	case CX88_BOARD_PROF_7300:
+	case CX88_BOARD_PROF_7301:
 	case CX88_BOARD_PROF_6200:
 		ircode = ir_decode_pulsedistance(ir->samples, ir->scount, 1, 4);
 
diff -r e341e9e85af2 -r b7c6748070e3 linux/drivers/media/video/cx88/cx88.h
--- a/linux/drivers/media/video/cx88/cx88.h	Fri Nov 13 22:22:03 2009 -0200
+++ b/linux/drivers/media/video/cx88/cx88.h	Tue Nov 17 03:22:32 2009 +0200
@@ -239,6 +239,7 @@
 #define CX88_BOARD_HAUPPAUGE_IRONLY        80
 #define CX88_BOARD_WINFAST_DTV1800H        81
 #define CX88_BOARD_WINFAST_DTV2000H_J      82
+#define CX88_BOARD_PROF_7301               83
 
 enum cx88_itype {
 	CX88_VMUX_COMPOSITE1 = 1,

