Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.tut.by ([195.137.160.40] helo=speedy.tutby.com)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <liplianin@tut.by>) id 1KiDCT-0007H3-DY
	for linux-dvb@linuxtv.org; Tue, 23 Sep 2008 21:05:31 +0200
From: "Igor M. Liplianin" <liplianin@tut.by>
To: linux-dvb@linuxtv.org
Date: Tue, 23 Sep 2008 22:04:29 +0300
References: <48CA0355.6080903@linuxtv.org>
	<200809170037.59770.liplianin@tut.by>
	<200809232201.06863.liplianin@tut.by>
In-Reply-To: <200809232201.06863.liplianin@tut.by>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_92T2I3sI5iCh1C7"
Message-Id: <200809232204.29984.liplianin@tut.by>
Cc: Steven Toth <stoth@hauppauge.com>, Georg Acher <acher@baycom.de>
Subject: Re: [linux-dvb] [PATCH] S2API - ST stv0288 demodulator support.
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--Boundary-00=_92T2I3sI5iCh1C7
Content-Type: text/plain;
  charset="koi8-r"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

=F7 =D3=CF=CF=C2=DD=C5=CE=C9=C9 =CF=D4 23 September 2008 22:01:06 Igor M. L=
iplianin =CE=C1=D0=C9=D3=C1=CC(=C1):
> Hi,
>
> Send patch for ST stv0288 demodulator support.
> Also stb6000 tuner, DvbWorld DW2002 PCI modification with Earda tuner,
> TeVii s420 PCI cards.
> It is S2API compliant ( single frontend )
> If somebody have any objections, let me know
>
> Igor
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

=46orget attachment
Need more sleep :-)

Igor

--Boundary-00=_92T2I3sI5iCh1C7
Content-Type: text/x-diff;
  charset="koi8-r";
  name="8894.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="8894.patch"

# HG changeset patch
# User Igor M. Liplianin <liplianin@me.by>
# Date 1222195437 -10800
# Node ID ed6ca1a375d437fc57c29decf0a00199795a3e1e
# Parent  368768bafa198a07f8ad0c5ee0368f4e58dbf9ba
Add support for ST STV0288 demodulator and cards with it.

From: Georg Acher <acher@baycom.de>
From: Igor M. Liplianin <liplianin@me.by>

Add support for ST STV0288 demodulator and cards with it,
such as TeVii S420.

Signed-off by: Georg Acher <acher@baycom.de>
Signed-off-by: Igor M. Liplianin <liplianin@me.by>

diff -r 368768bafa19 -r ed6ca1a375d4 linux/drivers/media/dvb/dm1105/dm1105.c
--- a/linux/drivers/media/dvb/dm1105/dm1105.c	Mon Sep 22 00:48:13 2008 -0400
+++ b/linux/drivers/media/dvb/dm1105/dm1105.c	Tue Sep 23 21:43:57 2008 +0300
@@ -39,8 +39,8 @@
 #include "dvb-pll.h"
 
 #include "stv0299.h"
-/*#include "stv0288.h"
- *#include "stb6000.h"*/
+#include "stv0288.h"
+#include "stb6000.h"
 #include "si21xx.h"
 #include "cx24116.h"
 #include "z0194a.h"
@@ -602,13 +602,12 @@
 
 	dm1105dvb_dma_unmap(dm1105dvb);
 }
-#if 0 /* keep */
+
 static struct stv0288_config earda_config = {
 	.demod_address = 0x68,
 	.min_delay_ms = 100,
 };
 
-#endif /* keep */
 static struct si21xx_config serit_config = {
 	.demod_address = 0x68,
 	.min_delay_ms = 100,
@@ -635,7 +634,7 @@
 			dvb_attach(dvb_pll_attach, dm1105dvb->fe, 0x60,
 					&dm1105dvb->i2c_adap, DVB_PLL_OPERA1);
 		}
-#if 0 /* keep */
+
 		if (!dm1105dvb->fe) {
 			dm1105dvb->fe = dvb_attach(
 				stv0288_attach, &earda_config,
@@ -647,7 +646,7 @@
 						&dm1105dvb->i2c_adap);
 			}
 		}
-#endif /* keep */
+
 		if (!dm1105dvb->fe) {
 			dm1105dvb->fe = dvb_attach(
 				si21xx_attach, &serit_config,
diff -r 368768bafa19 -r ed6ca1a375d4 linux/drivers/media/dvb/frontends/Kconfig
--- a/linux/drivers/media/dvb/frontends/Kconfig	Mon Sep 22 00:48:13 2008 -0400
+++ b/linux/drivers/media/dvb/frontends/Kconfig	Tue Sep 23 21:43:57 2008 +0300
@@ -42,6 +42,20 @@
 	default m if DVB_FE_CUSTOMISE
 	help
 	  A DVB-S tuner module. Say Y when you want to support this frontend.
+
+config DVB_STV0288
+	tristate "ST STV0288 based"
+	depends on DVB_CORE && I2C
+	default m if DVB_FE_CUSTOMISE
+	help
+	  A DVB-S tuner module. Say Y when you want to support this frontend.                  
+
+config DVB_STB6000
+	tristate "ST STB6000 silicon tuner"
+	depends on DVB_CORE && I2C
+	default m if DVB_FE_CUSTOMISE
+	  help
+	  A DVB-S silicon tuner module. Say Y when you want to support this tuner.
 
 config DVB_STV0299
 	tristate "ST STV0299 based"
diff -r 368768bafa19 -r ed6ca1a375d4 linux/drivers/media/dvb/frontends/Makefile
--- a/linux/drivers/media/dvb/frontends/Makefile	Mon Sep 22 00:48:13 2008 -0400
+++ b/linux/drivers/media/dvb/frontends/Makefile	Tue Sep 23 21:43:57 2008 +0300
@@ -51,3 +51,5 @@
 obj-$(CONFIG_DVB_LGS8GL5) += lgs8gl5.o
 obj-$(CONFIG_DVB_CX24116) += cx24116.o
 obj-$(CONFIG_DVB_SI21XX) += si21xx.o
+obj-$(CONFIG_DVB_STV0299) += stv0288.o
+obj-$(CONFIG_DVB_STB6000) += stb6000.o
diff -r 368768bafa19 -r ed6ca1a375d4 linux/drivers/media/dvb/frontends/stb6000.c
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/linux/drivers/media/dvb/frontends/stb6000.c	Tue Sep 23 21:43:57 2008 +0300
@@ -0,0 +1,255 @@
+  /*
+     Driver for ST STB6000 DVBS Silicon tuner
+
+     Copyright (C) 2008 Igor M. Liplianin (liplianin@me.by)
+
+     This program is free software; you can redistribute it and/or modify
+     it under the terms of the GNU General Public License as published by
+     the Free Software Foundation; either version 2 of the License, or
+     (at your option) any later version.
+
+     This program is distributed in the hope that it will be useful,
+     but WITHOUT ANY WARRANTY; without even the implied warranty of
+     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+
+     GNU General Public License for more details.
+
+     You should have received a copy of the GNU General Public License
+     along with this program; if not, write to the Free Software
+     Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+
+  */
+
+#include <linux/module.h>
+#include "compat.h"
+#include <linux/dvb/frontend.h>
+#include <asm/types.h>
+
+#include "stb6000.h"
+
+static int debug;
+#define dprintk(args...) \
+	do { \
+		if (debug) \
+			printk(KERN_DEBUG "stb6000: " args); \
+	} while (0)
+
+struct stb6000_priv {
+	/* i2c details */
+	int i2c_address;
+	struct i2c_adapter *i2c;
+	u32 frequency;
+};
+
+static int stb6000_release(struct dvb_frontend *fe)
+{
+	kfree(fe->tuner_priv);
+	fe->tuner_priv = NULL;
+	return 0;
+}
+
+static int stb6000_sleep(struct dvb_frontend *fe)
+{
+	struct stb6000_priv *priv = fe->tuner_priv;
+	int ret;
+	u8 buf[] = { 10, 0 };
+	struct i2c_msg msg = {
+		.addr = priv->i2c_address,
+		.flags = 0,
+		.buf = buf,
+		.len = 2
+	};
+
+	dprintk("%s:\n", __func__);
+
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 1);
+
+	ret = i2c_transfer(priv->i2c, &msg, 1);
+	if (ret != 1)
+		dprintk("%s: i2c error\n", __func__);
+
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 0);
+
+	return (ret == 1) ? 0 : ret;
+}
+
+static int stb6000_set_params(struct dvb_frontend *fe,
+				struct dvb_frontend_parameters *params)
+{
+	struct stb6000_priv *priv = fe->tuner_priv;
+	unsigned int n, m;
+	int ret;
+	u32 freq_mhz;
+	int bandwidth;
+	u8 buf[12];
+	struct i2c_msg msg = {
+		.addr = priv->i2c_address,
+		.flags = 0,
+		.buf = buf,
+		.len = 12
+	};
+
+	dprintk("%s:\n", __func__);
+
+	freq_mhz = params->frequency / 1000;
+	bandwidth = params->u.qpsk.symbol_rate / 1000000;
+
+	if (bandwidth > 31)
+		bandwidth = 31;
+
+	if ((freq_mhz > 949) && (freq_mhz < 2151)) {
+		buf[0] = 0x01;
+		buf[1] = 0xac;
+		if (freq_mhz < 1950)
+			buf[1] = 0xaa;
+		if (freq_mhz < 1800)
+			buf[1] = 0xa8;
+		if (freq_mhz < 1650)
+			buf[1] = 0xa6;
+		if (freq_mhz < 1530)
+			buf[1] = 0xa5;
+		if (freq_mhz < 1470)
+			buf[1] = 0xa4;
+		if (freq_mhz < 1370)
+			buf[1] = 0xa2;
+		if (freq_mhz < 1300)
+			buf[1] = 0xa1;
+		if (freq_mhz < 1200)
+			buf[1] = 0xa0;
+		if (freq_mhz < 1075)
+			buf[1] = 0xbc;
+		if (freq_mhz < 1000)
+			buf[1] = 0xba;
+		if (freq_mhz < 1075) {
+			n = freq_mhz / 8; /* vco=lo*4 */
+			m = 2;
+		} else {
+			n = freq_mhz / 16; /* vco=lo*2 */
+			m = 1;
+		}
+		buf[2] = n >> 1;
+		buf[3] = (unsigned char)(((n & 1) << 7) |
+					(m * freq_mhz - n * 16) | 0x60);
+		buf[4] = 0x04;
+		buf[5] = 0x0e;
+
+		buf[6] = (unsigned char)(bandwidth);
+
+		buf[7] = 0xd8;
+		buf[8] = 0xd0;
+		buf[9] = 0x50;
+		buf[10] = 0xeb;
+		buf[11] = 0x4f;
+
+		if (fe->ops.i2c_gate_ctrl)
+			fe->ops.i2c_gate_ctrl(fe, 1);
+
+		ret = i2c_transfer(priv->i2c, &msg, 1);
+		if (ret != 1)
+			dprintk("%s: i2c error\n", __func__);
+
+		udelay(10);
+		if (fe->ops.i2c_gate_ctrl)
+			fe->ops.i2c_gate_ctrl(fe, 0);
+
+		buf[0] = 0x07;
+		buf[1] = 0xdf;
+		buf[2] = 0xd0;
+		buf[3] = 0x50;
+		buf[4] = 0xfb;
+		msg.len = 5;
+
+		if (fe->ops.i2c_gate_ctrl)
+			fe->ops.i2c_gate_ctrl(fe, 1);
+
+		ret = i2c_transfer(priv->i2c, &msg, 1);
+		if (ret != 1)
+			dprintk("%s: i2c error\n", __func__);
+
+		udelay(10);
+		if (fe->ops.i2c_gate_ctrl)
+			fe->ops.i2c_gate_ctrl(fe, 0);
+
+		priv->frequency = freq_mhz * 1000;
+
+		return (ret == 1) ? 0 : ret;
+	}
+	return -1;
+}
+
+static int stb6000_get_frequency(struct dvb_frontend *fe, u32 *frequency)
+{
+	struct stb6000_priv *priv = fe->tuner_priv;
+	*frequency = priv->frequency;
+	return 0;
+}
+
+static struct dvb_tuner_ops stb6000_tuner_ops = {
+	.info = {
+		.name = "ST STB6000",
+		.frequency_min = 950000,
+		.frequency_max = 2150000
+	},
+	.release = stb6000_release,
+	.sleep = stb6000_sleep,
+	.set_params = stb6000_set_params,
+	.get_frequency = stb6000_get_frequency,
+};
+
+struct dvb_frontend *stb6000_attach(struct dvb_frontend *fe, int addr,
+						struct i2c_adapter *i2c)
+{
+	struct stb6000_priv *priv = NULL;
+	u8 b1[] = { 0, 0 };
+	struct i2c_msg msg[2] = {
+		{
+			.addr = addr,
+			.flags = 0,
+			.buf = NULL,
+			.len = 0
+		}, {
+			.addr = addr,
+			.flags = I2C_M_RD,
+			.buf = b1,
+			.len = 2
+		}
+	};
+	int ret;
+
+	dprintk("%s:\n", __func__);
+
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 1);
+
+	/* is some i2c device here ? */
+	ret = i2c_transfer(i2c, msg, 2);
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 0);
+
+	if (ret != 2)
+		return NULL;
+
+	priv = kzalloc(sizeof(struct stb6000_priv), GFP_KERNEL);
+	if (priv == NULL)
+		return NULL;
+
+	priv->i2c_address = addr;
+	priv->i2c = i2c;
+
+	memcpy(&fe->ops.tuner_ops, &stb6000_tuner_ops,
+				sizeof(struct dvb_tuner_ops));
+
+	fe->tuner_priv = priv;
+
+	return fe;
+}
+EXPORT_SYMBOL(stb6000_attach);
+
+module_param(debug, int, 0644);
+MODULE_PARM_DESC(debug, "Turn on/off frontend debugging (default:off).");
+
+MODULE_DESCRIPTION("DVB STB6000 driver");
+MODULE_AUTHOR("Igor M. Liplianin <liplianin@me.by>");
+MODULE_LICENSE("GPL");
diff -r 368768bafa19 -r ed6ca1a375d4 linux/drivers/media/dvb/frontends/stb6000.h
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/linux/drivers/media/dvb/frontends/stb6000.h	Tue Sep 23 21:43:57 2008 +0300
@@ -0,0 +1,51 @@
+  /*
+     Driver for ST stb6000 DVBS Silicon tuner
+
+     Copyright (C) 2008 Igor M. Liplianin (liplianin@me.by)
+
+     This program is free software; you can redistribute it and/or modify
+     it under the terms of the GNU General Public License as published by
+     the Free Software Foundation; either version 2 of the License, or
+     (at your option) any later version.
+
+     This program is distributed in the hope that it will be useful,
+     but WITHOUT ANY WARRANTY; without even the implied warranty of
+     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+
+     GNU General Public License for more details.
+
+     You should have received a copy of the GNU General Public License
+     along with this program; if not, write to the Free Software
+     Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+
+  */
+
+#ifndef __DVB_STB6000_H__
+#define __DVB_STB6000_H__
+
+#include <linux/i2c.h>
+#include "dvb_frontend.h"
+
+/**
+ * Attach a stb6000 tuner to the supplied frontend structure.
+ *
+ * @param fe Frontend to attach to.
+ * @param addr i2c address of the tuner.
+ * @param i2c i2c adapter to use.
+ * @return FE pointer on success, NULL on failure.
+ */
+#if defined(CONFIG_DVB_STB6000) || (defined(CONFIG_DVB_STB6000_MODULE) \
+							&& defined(MODULE))
+extern struct dvb_frontend *stb6000_attach(struct dvb_frontend *fe, int addr,
+					   struct i2c_adapter *i2c);
+#else
+static inline struct dvb_frontend *stb6000_attach(struct dvb_frontend *fe,
+						  int addr,
+						  struct i2c_adapter *i2c)
+{
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
+	return NULL;
+}
+#endif /* CONFIG_DVB_STB6000 */
+
+#endif /* __DVB_STB6000_H__ */
diff -r 368768bafa19 -r ed6ca1a375d4 linux/drivers/media/dvb/frontends/stv0288.c
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/linux/drivers/media/dvb/frontends/stv0288.c	Tue Sep 23 21:43:57 2008 +0300
@@ -0,0 +1,606 @@
+/*
+	Driver for ST STV0288 demodulator
+	Copyright (C) 2006 Georg Acher, BayCom GmbH, acher (at) baycom (dot) de
+		for Reel Multimedia
+	Copyright (C) 2008 TurboSight.com, Bob Liu <bob@turbosight.com>
+	Copyright (C) 2008 Igor M. Liplianin <liplianin@me.by>
+		Removed stb6000 specific tuner code and revised some
+		procedures.
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
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/string.h>
+#include <linux/slab.h>
+#include <linux/jiffies.h>
+#include <asm/div64.h>
+
+#include "dvb_frontend.h"
+#include "stv0288.h"
+
+struct stv0288_state {
+	struct i2c_adapter *i2c;
+	const struct stv0288_config *config;
+	struct dvb_frontend frontend;
+
+	u8 initialised:1;
+	u32 tuner_frequency;
+	u32 symbol_rate;
+	fe_code_rate_t fec_inner;
+	int errmode;
+};
+
+#define STATUS_BER 0
+#define STATUS_UCBLOCKS 1
+
+static int debug;
+static int debug_legacy_dish_switch;
+#define dprintk(args...) \
+	do { \
+		if (debug) \
+			printk(KERN_DEBUG "stv0288: " args); \
+	} while (0)
+
+
+static int stv0288_writeregI(struct stv0288_state *state, u8 reg, u8 data)
+{
+	int ret;
+	u8 buf[] = { reg, data };
+	struct i2c_msg msg = {
+		.addr = state->config->demod_address,
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
+static int stv0288_write(struct dvb_frontend *fe, u8 *buf, int len)
+{
+	struct stv0288_state *state = fe->demodulator_priv;
+
+	if (len != 2)
+		return -EINVAL;
+
+	return stv0288_writeregI(state, buf[0], buf[1]);
+}
+
+static u8 stv0288_readreg(struct stv0288_state *state, u8 reg)
+{
+	int ret;
+	u8 b0[] = { reg };
+	u8 b1[] = { 0 };
+	struct i2c_msg msg[] = {
+		{
+			.addr = state->config->demod_address,
+			.flags = 0,
+			.buf = b0,
+			.len = 1
+		}, {
+			.addr = state->config->demod_address,
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
+static int stv0288_set_symbolrate(struct dvb_frontend *fe, u32 srate)
+{
+	struct stv0288_state *state = fe->demodulator_priv;
+	unsigned int temp;
+	unsigned char b[3];
+
+	if ((srate < 1000000) || (srate > 45000000))
+		return -EINVAL;
+
+	temp = (unsigned int)srate / 1000;
+
+		temp = temp * 32768;
+		temp = temp / 25;
+		temp = temp / 125;
+		b[0] = (unsigned char)((temp >> 12) & 0xff);
+		b[1] = (unsigned char)((temp >> 4) & 0xff);
+		b[2] = (unsigned char)((temp << 4) & 0xf0);
+		stv0288_writeregI(state, 0x28, 0x80); /* SFRH */
+		stv0288_writeregI(state, 0x29, 0); /* SFRM */
+		stv0288_writeregI(state, 0x2a, 0); /* SFRL */
+
+		stv0288_writeregI(state, 0x28, b[0]);
+		stv0288_writeregI(state, 0x29, b[1]);
+		stv0288_writeregI(state, 0x2a, b[2]);
+		dprintk("stv0288: stv0288_set_symbolrate\n");
+
+	return 0;
+}
+
+static int stv0288_send_diseqc_msg(struct dvb_frontend *fe,
+				    struct dvb_diseqc_master_cmd *m)
+{
+	struct stv0288_state *state = fe->demodulator_priv;
+
+	int i;
+
+	dprintk("%s\n", __func__);
+
+	stv0288_writeregI(state, 0x09, 0);
+	msleep(30);
+	stv0288_writeregI(state, 0x05, 0x16);
+
+	for (i = 0; i < m->msg_len; i++) {
+		if (stv0288_writeregI(state, 0x06, m->msg[i]))
+			return -EREMOTEIO;
+		msleep(12);
+	}
+
+	return 0;
+}
+
+static int stv0288_send_diseqc_burst(struct dvb_frontend *fe,
+						fe_sec_mini_cmd_t burst)
+{
+	struct stv0288_state *state = fe->demodulator_priv;
+
+	dprintk("%s\n", __func__);
+
+	if (stv0288_writeregI(state, 0x05, 0x16))/* burst mode */
+		return -EREMOTEIO;
+
+	if (stv0288_writeregI(state, 0x06, burst == SEC_MINI_A ? 0x00 : 0xff))
+		return -EREMOTEIO;
+
+	if (stv0288_writeregI(state, 0x06, 0x12))
+		return -EREMOTEIO;
+
+	return 0;
+}
+
+static int stv0288_set_tone(struct dvb_frontend *fe, fe_sec_tone_mode_t tone)
+{
+	struct stv0288_state *state = fe->demodulator_priv;
+
+	switch (tone) {
+	case SEC_TONE_ON:
+		if (stv0288_writeregI(state, 0x05, 0x10))/* burst mode */
+			return -EREMOTEIO;
+		return stv0288_writeregI(state, 0x06, 0xff);
+
+	case SEC_TONE_OFF:
+		if (stv0288_writeregI(state, 0x05, 0x13))/* burst mode */
+			return -EREMOTEIO;
+		return stv0288_writeregI(state, 0x06, 0x00);
+
+	default:
+		return -EINVAL;
+	}
+}
+
+static u8 stv0288_inittab[] = {
+	0x01, 0x15,
+	0x02, 0x20,
+	0x09, 0x0,
+	0x0a, 0x4,
+	0x0b, 0x0,
+	0x0c, 0x0,
+	0x0d, 0x0,
+	0x0e, 0xd4,
+	0x0f, 0x30,
+	0x11, 0x80,
+	0x12, 0x03,
+	0x13, 0x48,
+	0x14, 0x84,
+	0x15, 0x45,
+	0x16, 0xb7,
+	0x17, 0x9c,
+	0x18, 0x0,
+	0x19, 0xa6,
+	0x1a, 0x88,
+	0x1b, 0x8f,
+	0x1c, 0xf0,
+	0x20, 0x0b,
+	0x21, 0x54,
+	0x22, 0x0,
+	0x23, 0x0,
+	0x2b, 0xff,
+	0x2c, 0xf7,
+	0x30, 0x0,
+	0x31, 0x1e,
+	0x32, 0x14,
+	0x33, 0x0f,
+	0x34, 0x09,
+	0x35, 0x0c,
+	0x36, 0x05,
+	0x37, 0x2f,
+	0x38, 0x16,
+	0x39, 0xbe,
+	0x3a, 0x0,
+	0x3b, 0x13,
+	0x3c, 0x11,
+	0x3d, 0x30,
+	0x40, 0x63,
+	0x41, 0x04,
+	0x42, 0x60,
+	0x43, 0x00,
+	0x44, 0x00,
+	0x45, 0x00,
+	0x46, 0x00,
+	0x47, 0x00,
+	0x4a, 0x00,
+	0x50, 0x10,
+	0x51, 0x38,
+	0x52, 0x21,
+	0x58, 0x54,
+	0x59, 0x86,
+	0x5a, 0x0,
+	0x5b, 0x9b,
+	0x5c, 0x08,
+	0x5d, 0x7f,
+	0x5e, 0x0,
+	0x5f, 0xff,
+	0x70, 0x0,
+	0x71, 0x0,
+	0x72, 0x0,
+	0x74, 0x0,
+	0x75, 0x0,
+	0x76, 0x0,
+	0x81, 0x0,
+	0x82, 0x3f,
+	0x83, 0x3f,
+	0x84, 0x0,
+	0x85, 0x0,
+	0x88, 0x0,
+	0x89, 0x0,
+	0x8a, 0x0,
+	0x8b, 0x0,
+	0x8c, 0x0,
+	0x90, 0x0,
+	0x91, 0x0,
+	0x92, 0x0,
+	0x93, 0x0,
+	0x94, 0x1c,
+	0x97, 0x0,
+	0xa0, 0x48,
+	0xa1, 0x0,
+	0xb0, 0xb8,
+	0xb1, 0x3a,
+	0xb2, 0x10,
+	0xb3, 0x82,
+	0xb4, 0x80,
+	0xb5, 0x82,
+	0xb6, 0x82,
+	0xb7, 0x82,
+	0xb8, 0x20,
+	0xb9, 0x0,
+	0xf0, 0x0,
+	0xf1, 0x0,
+	0xf2, 0xc0,
+	0x51, 0x36,
+	0x52, 0x09,
+	0x53, 0x94,
+	0x54, 0x62,
+	0x55, 0x29,
+	0x56, 0x64,
+	0x57, 0x2b,
+	0xff, 0xff,
+};
+
+static int stv0288_set_voltage(struct dvb_frontend *fe, fe_sec_voltage_t volt)
+{
+	dprintk("%s: %s\n", __func__,
+		volt == SEC_VOLTAGE_13 ? "SEC_VOLTAGE_13" :
+		volt == SEC_VOLTAGE_18 ? "SEC_VOLTAGE_18" : "??");
+
+	return 0;
+}
+
+static int stv0288_init(struct dvb_frontend *fe)
+{
+	struct stv0288_state *state = fe->demodulator_priv;
+	int i;
+
+	dprintk("stv0288: init chip\n");
+	stv0288_writeregI(state, 0x41, 0x04);
+	msleep(50);
+
+	for (i = 0; !(stv0288_inittab[i] == 0xff &&
+				stv0288_inittab[i + 1] == 0xff); i += 2)
+		stv0288_writeregI(state, stv0288_inittab[i],
+						stv0288_inittab[i + 1]);
+
+	return 0;
+}
+
+static int stv0288_read_status(struct dvb_frontend *fe, fe_status_t *status)
+{
+	struct stv0288_state *state = fe->demodulator_priv;
+
+	u8 sync = stv0288_readreg(state, 0x24);
+	if (sync == 255)
+		sync = 0;
+
+	dprintk("%s : FE_READ_STATUS : VSTATUS: 0x%02x\n", __func__, sync);
+
+	*status = 0;
+
+	if ((sync & 0x08) == 0x08) {
+		*status |= FE_HAS_LOCK;
+		dprintk("stv0288 has locked\n");
+	}
+
+	return 0;
+}
+
+static int stv0288_read_ber(struct dvb_frontend *fe, u32 *ber)
+{
+	struct stv0288_state *state = fe->demodulator_priv;
+
+	if (state->errmode != STATUS_BER)
+		return 0;
+	*ber = (stv0288_readreg(state, 0x26) << 8) |
+					stv0288_readreg(state, 0x27);
+	dprintk("stv0288_read_ber %d\n", *ber);
+
+	return 0;
+}
+
+
+static int stv0288_read_signal_strength(struct dvb_frontend *fe, u16 *strength)
+{
+	struct stv0288_state *state = fe->demodulator_priv;
+
+	s32 signal =  0xffff - ((stv0288_readreg(state, 0x10) << 8));
+
+
+	signal = signal * 5 / 4;
+	*strength = (signal > 0xffff) ? 0xffff : (signal < 0) ? 0 : signal;
+	dprintk("stv0288_read_signal_strength %d\n", *strength);
+
+	return 0;
+}
+static int stv0288_sleep(struct dvb_frontend *fe)
+{
+	struct stv0288_state *state = fe->demodulator_priv;
+
+	stv0288_writeregI(state, 0x41, 0x84);
+	state->initialised = 0;
+
+	return 0;
+}
+static int stv0288_read_snr(struct dvb_frontend *fe, u16 *snr)
+{
+	struct stv0288_state *state = fe->demodulator_priv;
+
+	s32 xsnr = 0xffff - ((stv0288_readreg(state, 0x2d) << 8)
+			   | stv0288_readreg(state, 0x2e));
+	xsnr = 3 * (xsnr - 0xa100);
+	*snr = (xsnr > 0xffff) ? 0xffff : (xsnr < 0) ? 0 : xsnr;
+	dprintk("stv0288_read_snr %d\n", *snr);
+
+	return 0;
+}
+
+static int stv0288_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
+{
+	struct stv0288_state *state = fe->demodulator_priv;
+
+	if (state->errmode != STATUS_BER)
+		return 0;
+	*ucblocks = (stv0288_readreg(state, 0x26) << 8) |
+					stv0288_readreg(state, 0x27);
+	dprintk("stv0288_read_ber %d\n", *ucblocks);
+
+	return 0;
+}
+
+static int stv0288_set_property(struct dvb_frontend *fe, struct dtv_property *p)
+{
+	dprintk("%s(..)\n", __func__);
+	return 0;
+}
+
+static int stv0288_get_property(struct dvb_frontend *fe, struct dtv_property *p)
+{
+	dprintk("%s(..)\n", __func__);
+	return 0;
+}
+
+static int stv0288_set_frontend(struct dvb_frontend *fe,
+					struct dvb_frontend_parameters *dfp)
+{
+	struct stv0288_state *state = fe->demodulator_priv;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+
+	char tm;
+	unsigned char tda[3];
+
+	dprintk("%s : FE_SET_FRONTEND\n", __func__);
+
+	if (c->delivery_system != SYS_DVBS) {
+			dprintk("%s: unsupported delivery "
+				"system selected (%d)\n",
+				__func__, c->delivery_system);
+			return -EOPNOTSUPP;
+	}
+
+	if (state->config->set_ts_params)
+		state->config->set_ts_params(fe, 0);
+
+	/* only frequency & symbol_rate are used for tuner*/
+	dfp->frequency = c->frequency;
+	dfp->u.qpsk.symbol_rate = c->symbol_rate;
+	if (fe->ops.tuner_ops.set_params) {
+		fe->ops.tuner_ops.set_params(fe, dfp);
+		if (fe->ops.i2c_gate_ctrl)
+			fe->ops.i2c_gate_ctrl(fe, 0);
+	}
+
+	udelay(10);
+	stv0288_set_symbolrate(fe, c->symbol_rate);
+	/* Carrier lock control register */
+	stv0288_writeregI(state, 0x15, 0xc5);
+
+	tda[0] = 0x2b; /* CFRM */
+	tda[2] = 0x0; /* CFRL */
+	for (tm = -6; tm < 7;) {
+		/* Viterbi status */
+		if (stv0288_readreg(state, 0x24) & 0x80)
+			break;
+
+		tda[2] += 40;
+		if (tda[2] < 40)
+			tm++;
+		tda[1] = (unsigned char)tm;
+		stv0288_writeregI(state, 0x2b, tda[1]);
+		stv0288_writeregI(state, 0x2c, tda[2]);
+		udelay(30);
+	}
+
+	state->tuner_frequency = c->frequency;
+	state->fec_inner = FEC_AUTO;
+	state->symbol_rate = c->symbol_rate;
+
+	return 0;
+}
+
+static int stv0288_i2c_gate_ctrl(struct dvb_frontend *fe, int enable)
+{
+	struct stv0288_state *state = fe->demodulator_priv;
+
+	if (enable)
+		stv0288_writeregI(state, 0x01, 0xb5);
+	else
+		stv0288_writeregI(state, 0x01, 0x35);
+
+	udelay(1);
+
+	return 0;
+}
+
+static void stv0288_release(struct dvb_frontend *fe)
+{
+	struct stv0288_state *state = fe->demodulator_priv;
+	kfree(state);
+}
+
+static struct dvb_frontend_ops stv0288_ops = {
+
+	.info = {
+		.name			= "ST STV0288 DVB-S",
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
+	.release = stv0288_release,
+	.init = stv0288_init,
+	.sleep = stv0288_sleep,
+	.write = stv0288_write,
+	.i2c_gate_ctrl = stv0288_i2c_gate_ctrl,
+	.read_status = stv0288_read_status,
+	.read_ber = stv0288_read_ber,
+	.read_signal_strength = stv0288_read_signal_strength,
+	.read_snr = stv0288_read_snr,
+	.read_ucblocks = stv0288_read_ucblocks,
+	.diseqc_send_master_cmd = stv0288_send_diseqc_msg,
+	.diseqc_send_burst = stv0288_send_diseqc_burst,
+	.set_tone = stv0288_set_tone,
+	.set_voltage = stv0288_set_voltage,
+
+	.set_property = stv0288_set_property,
+	.get_property = stv0288_get_property,
+	.set_frontend = stv0288_set_frontend,
+};
+
+struct dvb_frontend *stv0288_attach(const struct stv0288_config *config,
+				    struct i2c_adapter *i2c)
+{
+	struct stv0288_state *state = NULL;
+	int id;
+
+	/* allocate memory for the internal state */
+	state = kmalloc(sizeof(struct stv0288_state), GFP_KERNEL);
+	if (state == NULL)
+		goto error;
+
+	/* setup the state */
+	state->config = config;
+	state->i2c = i2c;
+	state->initialised = 0;
+	state->tuner_frequency = 0;
+	state->symbol_rate = 0;
+	state->fec_inner = 0;
+	state->errmode = STATUS_BER;
+
+	stv0288_writeregI(state, 0x41, 0x04);
+	msleep(200);
+	id = stv0288_readreg(state, 0x00);
+	dprintk("stv0288 id %x\n", id);
+
+	/* register 0x00 contains 0x11 for STV0288  */
+	if (id != 0x11)
+		goto error;
+
+	/* create dvb_frontend */
+	memcpy(&state->frontend.ops, &stv0288_ops,
+			sizeof(struct dvb_frontend_ops));
+	state->frontend.demodulator_priv = state;
+	return &state->frontend;
+
+error:
+	kfree(state);
+
+	return NULL;
+}
+EXPORT_SYMBOL(stv0288_attach);
+
+module_param(debug_legacy_dish_switch, int, 0444);
+MODULE_PARM_DESC(debug_legacy_dish_switch,
+		"Enable timing analysis for Dish Network legacy switches");
+
+module_param(debug, int, 0644);
+MODULE_PARM_DESC(debug, "Turn on/off frontend debugging (default:off).");
+
+MODULE_DESCRIPTION("ST STV0288 DVB Demodulator driver");
+MODULE_AUTHOR("Georg Acher, Bob Liu, Igor liplianin");
+MODULE_LICENSE("GPL");
+
diff -r 368768bafa19 -r ed6ca1a375d4 linux/drivers/media/dvb/frontends/stv0288.h
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/linux/drivers/media/dvb/frontends/stv0288.h	Tue Sep 23 21:43:57 2008 +0300
@@ -0,0 +1,65 @@
+/*
+	Driver for ST STV0288 demodulator
+
+	Copyright (C) 2006 Georg Acher, BayCom GmbH, acher (at) baycom (dot) de
+		for Reel Multimedia
+	Copyright (C) 2008 TurboSight.com, <bob@turbosight.com>
+	Copyright (C) 2008 Igor M. Liplianin <liplianin@me.by>
+		Removed stb6000 specific tuner code and revised some
+		procedures.
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
+#ifndef STV0288_H
+#define STV0288_H
+
+#include <linux/dvb/frontend.h>
+#include "dvb_frontend.h"
+
+struct stv0288_config {
+	/* the demodulator's i2c address */
+	u8 demod_address;
+
+	/* minimum delay before retuning */
+	int min_delay_ms;
+
+	int (*set_ts_params)(struct dvb_frontend *fe, int is_punctured);
+};
+
+#if defined(CONFIG_DVB_STV0288) || (defined(CONFIG_DVB_STV0288_MODULE) && \
+							defined(MODULE))
+extern struct dvb_frontend *stv0288_attach(const struct stv0288_config *config,
+					   struct i2c_adapter *i2c);
+#else
+static inline struct dvb_frontend *stv0288_attach(const struct stv0288_config *config,
+					   struct i2c_adapter *i2c)
+{
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
+	return NULL;
+}
+#endif /* CONFIG_DVB_STV0288 */
+
+static inline int stv0288_writereg(struct dvb_frontend *fe, u8 reg, u8 val)
+{
+	int r = 0;
+	u8 buf[] = { reg, val };
+	if (fe->ops.write)
+		r = fe->ops.write(fe, buf, 2);
+	return r;
+}
+
+#endif /* STV0288_H */
diff -r 368768bafa19 -r ed6ca1a375d4 linux/drivers/media/dvb/frontends/stv0299.c
--- a/linux/drivers/media/dvb/frontends/stv0299.c	Mon Sep 22 00:48:13 2008 -0400
+++ b/linux/drivers/media/dvb/frontends/stv0299.c	Tue Sep 23 21:43:57 2008 +0300
@@ -559,6 +559,8 @@
 	int invval = 0;
 
 	dprintk ("%s : FE_SET_FRONTEND\n", __func__);
+	if (state->config->set_ts_params)
+		state->config->set_ts_params(fe, 0);
 
 	// set the inversion
 	if (p->inversion == INVERSION_OFF) invval = 0;
diff -r 368768bafa19 -r ed6ca1a375d4 linux/drivers/media/dvb/frontends/stv0299.h
--- a/linux/drivers/media/dvb/frontends/stv0299.h	Mon Sep 22 00:48:13 2008 -0400
+++ b/linux/drivers/media/dvb/frontends/stv0299.h	Tue Sep 23 21:43:57 2008 +0300
@@ -89,15 +89,18 @@
 	int min_delay_ms;
 
 	/* Set the symbol rate */
-	int (*set_symbol_rate)(struct dvb_frontend* fe, u32 srate, u32 ratio);
+	int (*set_symbol_rate)(struct dvb_frontend *fe, u32 srate, u32 ratio);
+
+	/* Set device param to start dma */
+	int (*set_ts_params)(struct dvb_frontend *fe, int is_punctured);
 };
 
 #if defined(CONFIG_DVB_STV0299) || (defined(CONFIG_DVB_STV0299_MODULE) && defined(MODULE))
-extern struct dvb_frontend* stv0299_attach(const struct stv0299_config* config,
-					   struct i2c_adapter* i2c);
+extern struct dvb_frontend *stv0299_attach(const struct stv0299_config *config,
+					   struct i2c_adapter *i2c);
 #else
-static inline struct dvb_frontend* stv0299_attach(const struct stv0299_config* config,
-					   struct i2c_adapter* i2c)
+static inline struct dvb_frontend *stv0299_attach(const struct stv0299_config *config,
+					   struct i2c_adapter *i2c)
 {
 	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
diff -r 368768bafa19 -r ed6ca1a375d4 linux/drivers/media/video/cx88/Kconfig
--- a/linux/drivers/media/video/cx88/Kconfig	Mon Sep 22 00:48:13 2008 -0400
+++ b/linux/drivers/media/video/cx88/Kconfig	Tue Sep 23 21:43:57 2008 +0300
@@ -59,6 +59,9 @@
 	select MEDIA_TUNER_SIMPLE if !DVB_FE_CUSTOMISE
 	select DVB_S5H1411 if !DVB_FE_CUSTOMISE
 	select DVB_CX24116 if !DVB_FE_CUSTOMISE
+	select DVB_STV0299 if !DVB_FE_CUSTOMISE
+	select DVB_STV0288 if !DVB_FE_CUSTOMISE
+	select DVB_STB6000 if !DVB_FE_CUSTOMISE
 	---help---
 	  This adds support for DVB/ATSC cards based on the
 	  Conexant 2388x chip.
diff -r 368768bafa19 -r ed6ca1a375d4 linux/drivers/media/video/cx88/cx88-cards.c
--- a/linux/drivers/media/video/cx88/cx88-cards.c	Mon Sep 22 00:48:13 2008 -0400
+++ b/linux/drivers/media/video/cx88/cx88-cards.c	Tue Sep 23 21:43:57 2008 +0300
@@ -1769,6 +1769,18 @@
 		} },
 		.mpeg           = CX88_MPEG_DVB,
 	},
+	[CX88_BOARD_TEVII_S420] = {
+		.name           = "TeVii S420 DVB-S",
+		.tuner_type     = UNSET,
+		.radio_type     = UNSET,
+		.tuner_addr     = ADDR_UNSET,
+		.radio_addr     = ADDR_UNSET,
+		.input          = {{
+			.type   = CX88_VMUX_DVB,
+			.vmux   = 0,
+		} },
+		.mpeg           = CX88_MPEG_DVB,
+	},
 	[CX88_BOARD_TEVII_S460] = {
 		.name           = "TeVii S460 DVB-S/S2",
 		.tuner_type     = UNSET,
@@ -2175,7 +2187,11 @@
 		.subdevice = 0x6906,
 		.card      = CX88_BOARD_HAUPPAUGE_HVR4000LITE,
 	}, {
-		.subvendor = 0xD460,
+		.subvendor = 0xd420,
+		.subdevice = 0x9022,
+		.card      = CX88_BOARD_TEVII_S420,
+	}, {
+		.subvendor = 0xd460,
 		.subdevice = 0x9022,
 		.card      = CX88_BOARD_TEVII_S460,
 	}, {
@@ -2767,6 +2783,7 @@
 		cx88_call_i2c_clients(core, TUNER_SET_CONFIG, &tea5767_cfg);
 		break;
 	}
+	case  CX88_BOARD_TEVII_S420:
 	case  CX88_BOARD_TEVII_S460:
 		cx_write(MO_SRST_IO, 0);
 		msleep(100);
diff -r 368768bafa19 -r ed6ca1a375d4 linux/drivers/media/video/cx88/cx88-dvb.c
--- a/linux/drivers/media/video/cx88/cx88-dvb.c	Mon Sep 22 00:48:13 2008 -0400
+++ b/linux/drivers/media/video/cx88/cx88-dvb.c	Tue Sep 23 21:43:57 2008 +0300
@@ -49,6 +49,10 @@
 #include "tuner-simple.h"
 #include "tda9887.h"
 #include "s5h1411.h"
+#include "stv0299.h"
+#include "z0194a.h"
+#include "stv0288.h"
+#include "stb6000.h"
 #include "cx24116.h"
 
 MODULE_DESCRIPTION("driver for cx2388x based DVB cards");
@@ -586,6 +590,25 @@
 	.reset_device  = cx24116_reset_device,
 };
 
+static struct stv0299_config tevii_tuner_sharp_config = {
+	.demod_address = 0x68,
+	.inittab = sharp_z0194a__inittab,
+	.mclk = 88000000UL,
+	.invert = 1,
+	.skip_reinit = 0,
+	.lock_output = 1,
+	.volt13_op0_op1 = STV0299_VOLT13_OP1,
+	.min_delay_ms = 100,
+	.set_symbol_rate = sharp_z0194a__set_symbol_rate,
+	.set_ts_params = cx24116_set_ts_param,
+};
+
+static struct stv0288_config tevii_tuner_earda_config = {
+	.demod_address = 0x68,
+	.min_delay_ms = 100,
+	.set_ts_params = cx24116_set_ts_param,
+};
+
 static int dvb_register(struct cx8802_dev *dev)
 {
 	struct cx88_core *core = dev->core;
@@ -964,6 +987,31 @@
 				0x08, ISL6421_DCL, 0x00);
 		}
 		break;
+	case CX88_BOARD_TEVII_S420:
+		dev->dvb.frontend = dvb_attach(stv0299_attach,
+						&tevii_tuner_sharp_config,
+						&core->i2c_adap);
+		if (dev->dvb.frontend != NULL) {
+			if (!dvb_attach(dvb_pll_attach, dev->dvb.frontend, 0x60,
+					&core->i2c_adap, DVB_PLL_OPERA1))
+				goto frontend_detach;
+			core->prev_set_voltage = dev->dvb.frontend->ops.set_voltage;
+			dev->dvb.frontend->ops.set_voltage = tevii_dvbs_set_voltage;
+
+		} else {
+			dev->dvb.frontend = dvb_attach(stv0288_attach,
+							    &tevii_tuner_earda_config,
+							    &core->i2c_adap);
+				if (dev->dvb.frontend != NULL) {
+					if (!dvb_attach(stb6000_attach, dev->dvb.frontend, 0x61,
+						&core->i2c_adap))
+					goto frontend_detach;
+				core->prev_set_voltage = dev->dvb.frontend->ops.set_voltage;
+				dev->dvb.frontend->ops.set_voltage = tevii_dvbs_set_voltage;
+
+			}
+		}
+		break;
 	case CX88_BOARD_TEVII_S460:
 		dev->dvb.frontend = dvb_attach(cx24116_attach,
 					       &tevii_s460_config,
diff -r 368768bafa19 -r ed6ca1a375d4 linux/drivers/media/video/cx88/cx88.h
--- a/linux/drivers/media/video/cx88/cx88.h	Mon Sep 22 00:48:13 2008 -0400
+++ b/linux/drivers/media/video/cx88/cx88.h	Tue Sep 23 21:43:57 2008 +0300
@@ -227,6 +227,7 @@
 #define CX88_BOARD_TEVII_S460              70
 #define CX88_BOARD_OMICOM_SS4_PCI          71
 #define CX88_BOARD_TBS_8920                72
+#define CX88_BOARD_TEVII_S420              73
 
 enum cx88_itype {
 	CX88_VMUX_COMPOSITE1 = 1,

--Boundary-00=_92T2I3sI5iCh1C7
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--Boundary-00=_92T2I3sI5iCh1C7--
