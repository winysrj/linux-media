Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-out.m-online.net ([212.18.0.9])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <zzam@gentoo.org>) id 1JpxlM-0002y8-Je
	for linux-dvb@linuxtv.org; Sun, 27 Apr 2008 05:41:17 +0200
From: Matthias Schwarzott <zzam@gentoo.org>
To: linux-dvb@linuxtv.org
Date: Sun, 27 Apr 2008 05:40:29 +0200
References: <617be8890804140209p3b79df8cm3f94de8f82b1faa5@mail.gmail.com>
In-Reply-To: <617be8890804140209p3b79df8cm3f94de8f82b1faa5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_tW/EIyUOCQ1kFBG"
Message-Id: <200804270540.29590.zzam@gentoo.org>
Cc: Eduard Huguet <eduardhc@gmail.com>
Subject: Re: [linux-dvb] a700 support (was: [patch 5/5] mt312: add
	attach-time setting to invert lnb-voltage (Matthias Schwarzott))
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

--Boundary-00=_tW/EIyUOCQ1kFBG
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Montag, 14. April 2008, Eduard Huguet wrote:
> > ---------- Missatge reenviat ----------
> > From: Matthias Schwarzott <zzam@gentoo.org>
> > To: linux-dvb@linuxtv.org
> > Date: Sat, 12 Apr 2008 17:04:50 +0200
> > Subject: [linux-dvb] [patch 5/5] mt312: add attach-time setting to inve=
rt
> > lnb-voltage
> > Add a setting to config struct for inversion of lnb-voltage.
> > Needed for support of Avermedia A700 cards.
> >
> > Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
> > Index: v4l-dvb/linux/drivers/media/dvb/frontends/mt312.c
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > --- v4l-dvb.orig/linux/drivers/media/dvb/frontends/mt312.c
> > +++ v4l-dvb/linux/drivers/media/dvb/frontends/mt312.c
> > @@ -422,11 +422,16 @@ static int mt312_set_voltage(struct dvb_
> >   {
> >         struct mt312_state *state =3D fe->demodulator_priv;
> >         const u8 volt_tab[3] =3D { 0x00, 0x40, 0x00 };
> > +       u8 val;
> >
> >         if (v > SEC_VOLTAGE_OFF)
> >                 return -EINVAL;
> >
> > -       return mt312_writereg(state, DISEQC_MODE, volt_tab[v]);
> > +       val =3D volt_tab[v];
> > +       if (state->config->voltage_inverted)
> > +               val ^=3D 0x40;
> > +
> > +       return mt312_writereg(state, DISEQC_MODE, val);
> >   }
> >
> >   static int mt312_read_status(struct dvb_frontend *fe, fe_status_t *s)
> > Index: v4l-dvb/linux/drivers/media/dvb/frontends/mt312.h
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > --- v4l-dvb.orig/linux/drivers/media/dvb/frontends/mt312.h
> > +++ v4l-dvb/linux/drivers/media/dvb/frontends/mt312.h
> > @@ -31,6 +31,9 @@
> >   struct mt312_config {
> >         /* the demodulator's i2c address */
> >         u8 demod_address;
> > +
> > +       /* inverted voltage setting */
> > +       int voltage_inverted:1;
> >   };
> >
> >   #if defined(CONFIG_DVB_MT312) || (defined(CONFIG_DVB_MT312_MODULE) &&
> > defined(MODULE))
> > --
>
> Thanks for the patches. =BFIs your lastest unified diff on your page
> (a700_full_20080412.diff) equivalent to these patches or must they be
> applied separately?
Another 2 weeks later. These patches already have been applied at hg level.=
 So=20
now the new remaining full patch (a700_full_20080427.diff) is to be applied=
=20
on top.

It contains a zl10036 driver and the changes to the glue code in saa7134-dv=
b.
zl10036 works most of the time here, but I am not fully happy with its curr=
ent=20
design.

Open issues:
* Should set_params routine be kept spiltted as it is?
* Is bandwidth handling sane?
Now calc the needed bw by symbolrate and add 3MHz.
Datasheet suggests to start at max setting and decrease as possible after t=
he=20
lock is established (using freq. offset info from demod).
* The used gain values are found by try and error and do not work for all=20
transponders here.
The most difficult transponder here was RTL - and that now works for me wit=
h=20
exactly these gain settings (rfg=3D0, ba=3D1, bg=3D1).

>
> I'll try to some tests tonight, if you have made some progress. By the wa=
y,
> =BFcould you tell me if it's better to use use_frontend=3D0 or 1 for
> saa7134-dvb module? I think that this changes the driver used for fronten=
d,
> but I'm not sure.

use_frontend is intended to be used for choosing between dvb-s and dvb-t or=
=20
similar if the frontend offers both exclusively. I abused this parameter to=
=20
choose between the two driver for zl10313 demod. This is no longer used, so=
=20
forget about this parameter.

Regards
Matthias

--Boundary-00=_tW/EIyUOCQ1kFBG
Content-Type: text/x-diff;
  charset="iso-8859-15";
  name="a700_full_20080427.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="a700_full_20080427.diff"

Index: v4l-dvb/linux/drivers/media/dvb/frontends/Kconfig
===================================================================
--- v4l-dvb.orig/linux/drivers/media/dvb/frontends/Kconfig
+++ v4l-dvb/linux/drivers/media/dvb/frontends/Kconfig
@@ -368,6 +368,13 @@ config DVB_TUNER_QT1010
 	help
 	  A driver for the silicon tuner QT1010 from Quantek.
 
+config DVB_ZL10036
+	tristate "Zarlink ZL10036 silicon tuner"
+	depends on DVB_CORE && I2C
+	default m if DVB_FE_CUSTOMISE
+	help
+	  A DVB-S silicon tuner module. Say Y when you want to support this tuner.
+
 config DVB_TUNER_MT2060
 	tristate "Microtune MT2060 silicon IF tuner"
 	depends on I2C
Index: v4l-dvb/linux/drivers/media/dvb/frontends/Makefile
===================================================================
--- v4l-dvb.orig/linux/drivers/media/dvb/frontends/Makefile
+++ v4l-dvb/linux/drivers/media/dvb/frontends/Makefile
@@ -25,6 +25,7 @@ obj-$(CONFIG_DVB_TDA1004X) += tda1004x.o
 obj-$(CONFIG_DVB_SP887X) += sp887x.o
 obj-$(CONFIG_DVB_NXT6000) += nxt6000.o
 obj-$(CONFIG_DVB_MT352) += mt352.o
+obj-$(CONFIG_DVB_ZL10036) += zl10036.o
 obj-$(CONFIG_DVB_ZL10353) += zl10353.o
 obj-$(CONFIG_DVB_CX22702) += cx22702.o
 obj-$(CONFIG_DVB_DRX397XD) += drx397xD.o
Index: v4l-dvb/linux/drivers/media/dvb/frontends/zl10036.c
===================================================================
--- /dev/null
+++ v4l-dvb/linux/drivers/media/dvb/frontends/zl10036.c
@@ -0,0 +1,700 @@
+/**
+ * Driver for Zarlink zl10036 DVB-S silicon tuner
+ *
+ * Copyright (C) 2006 Tino Reichardt
+ * Copyright (C) 2007,2008 Matthias Schwarzott <zzam@gmx.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License Version 2, as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ **
+ * The data sheet for this tuner can be found at:
+ *    http://www.mcmilk.de/projects/dvb-card/datasheets/ZL10036.pdf
+ *
+ * This one is working: (at my Avermedia DVB-S Pro)
+ * - zl10036 (40pin, FTA)
+ *
+ * These are planned:
+ * - zl10038 (40pin, FTA with DVB-S2 - nearly the same as zl10036)
+ * - zl10037 (28pin, with pay tv support)
+ * - zl10039 (28pin, FTA)
+ */
+
+#include <linux/module.h>
+#include <linux/dvb/frontend.h>
+#include <asm/types.h>
+
+#include "zl10036.h"
+
+static int zl10036_debug;
+#define dprintk(level, args...) \
+	do { if (zl10036_debug & level) printk(KERN_DEBUG "zl10036: " args); \
+	} while (0)
+
+#define deb_info(args...)  dprintk(0x01, args)
+#define deb_i2c(args...)  dprintk(0x02, args)
+
+struct zl10036_state {
+	struct i2c_adapter *i2c;
+	const struct zl10036_config *config;
+	u32 frequency;
+	u8 br, bf;
+};
+
+
+/* This driver assumes the tuner is driven by a 10.111MHz Cristal */
+#define _XTAL 10111
+
+#if 0
+/* Using a divider of 64 leads to a reference Frequency/step size of 158kHz */
+#define _RDIV 64
+#define _RDIV_REG 0x05
+#elif 1
+/* Using a divider of 10 leads to a reference Frequency/step size of 1011kHz */
+#define _RDIV 10
+#define _RDIV_REG 0x0a
+#else
+/* Using a divider of 10 leads to a reference Frequency/step size of 2022kHz */
+#define _RDIV 5
+#define _RDIV_REG 0x09
+#endif
+
+#define _FR   (_XTAL/_RDIV)
+
+#define STATUS_POR 0x80
+#define STATUS_FL  0x40
+
+/* read/write for zl10036 and zl10038 */
+
+static int zl10036_read_status_reg(struct zl10036_state *state)
+{
+	u8 status;
+	struct i2c_msg msg[1] = {
+		{ .addr = state->config->tuner_address, .flags = I2C_M_RD,
+		  .buf = &status, .len = sizeof(status) },
+	};
+
+	if (i2c_transfer(state->i2c, msg, 1) != 1) {
+		printk(KERN_ERR "%s: i2c read failed at addr=%02x\n",
+			__FUNCTION__, state->config->tuner_address);
+		return -EIO;
+	}
+
+	deb_i2c("R(status): %02x  [FL=%d]\n", status,
+		(status & STATUS_FL) ? 1 : 0);
+	if (status & STATUS_POR)
+		deb_info("Power-On-Reset bit enabled - "
+			"may need to reinitialize tuner\n");
+
+	return status;
+}
+
+
+static int zl10036_write(struct zl10036_state *state, u8 buf[], u8 count)
+{
+	struct i2c_msg msg[1] = {
+		{ .addr = state->config->tuner_address, .flags = 0,
+		  .buf = buf, .len = count },
+	};
+	u8 reg = 0;
+	int ret;
+
+	if (zl10036_debug & 0x02) {
+		/* every 8bit-value satisifes this!
+		 * so only do on debug */
+		     if ((buf[0] & 0x80) == 0x00) reg = 2;
+		else if ((buf[0] & 0xc0) == 0x80) reg = 4;
+		else if ((buf[0] & 0xf0) == 0xc0) reg = 6;
+		else if ((buf[0] & 0xf0) == 0xd0) reg = 8;
+		else if ((buf[0] & 0xf0) == 0xe0) reg = 10;
+		else if ((buf[0] & 0xf0) == 0xf0) reg = 12;
+
+		deb_i2c("W(%d):", reg);
+		{
+			int i;
+			for (i = 0; i < count; i++)
+				printk(" %02x", buf[i]);
+			printk("\n");
+		}
+	}
+
+	ret = i2c_transfer(state->i2c, msg, 1);
+	if (ret != 1) {
+		printk(KERN_ERR "%s: i2c error, ret=%d\n", __FUNCTION__, ret);
+		return -EIO;
+	}
+
+	return 0;
+}
+
+#if 0
+/* read/write for zl10037, zl10039 and Intel CE503x */
+static int zl10037_readreg(struct zl10036_state *state, u8 reg)
+{
+	int ret;
+	u8 b0 [] = { reg };
+	u8 b1 [] = { 0 };
+	struct i2c_msg msg[2] = {
+		{ .addr = state->config->tuner_address, .flags = 0,
+		  .buf = b0, .len = 1 },
+		{ .addr = state->config->tuner_address, .flags = I2C_M_RD,
+		  .buf = b1, .len = 1 } };
+
+	ret = i2c_transfer(state->i2c, msg, 2);
+
+	if (ret != 2) {
+		printk(KERN_ERR "%s: i2c read failed at addr=%02x reg=%d\n",
+			__FUNCTION__, state->config->tuner_address, reg);
+		return ret;
+	}
+
+	deb_i2c("R(%d): %02x\n", reg, b1[0]);
+
+	return b1[0];
+}
+
+static int zl10037_write(struct zl10036_state *state, u8 buf[], u8 count)
+{
+	struct i2c_msg msg[1] = {
+		{ .addr = state->config->tuner_address, .flags = 0,
+		  .buf = buf, .len = count },
+	};
+	int ret;
+
+	if (zl10036_debug & 0x02) {
+		deb_i2c("W(%d):", buf[0]);
+		{
+			int i;
+			for (i = 1; i < count; i++)
+				printk(" %02x", buf[i]);
+			printk("\n");
+		}
+	}
+	ret = i2c_transfer(state->i2c, msg, 1);
+	if (ret != 1) {
+		printk(KERN_ERR "%s: i2c error, ret=%d\n", __FUNCTION__, ret);
+		return -EIO;
+	}
+
+	return 0;
+}
+#endif
+
+static int zl10036_release(struct dvb_frontend *fe)
+{
+	struct zl10036_state *state = fe->tuner_priv;
+
+	deb_info("%s\n", __FUNCTION__);
+
+	fe->tuner_priv = NULL;
+	kfree(state);
+
+	return 0;
+}
+
+static int zl10036_sleep(struct dvb_frontend *fe)
+{
+	struct zl10036_state *state = fe->tuner_priv;
+	u8 buf[] = { 0xf0, 0x80 }; /* regs 12/13 */
+	int ret;
+
+	deb_info("%s\n", __FUNCTION__);
+
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 1); /* open i2c_gate */
+
+	ret = zl10036_write(state, buf, sizeof(buf));
+
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 0); /* close i2c_gate */
+
+	return ret;
+}
+
+/**
+ * register map of the ZL10036/ZL10038
+ *
+ * reg[default] content
+ *  2[0x00]:   0 | N14 | N13 | N12 | N11 | N10 |  N9 |  N8
+ *  3[0x00]:  N7 |  N6 |  N5 |  N4 |  N3 |  N2 |  N1 |  N0
+ *  4[0x80]:   1 |   0 | RFG | BA1 | BA0 | BG1 | BG0 | LEN
+ *  5[0x00]:  P0 |  C1 |  C0 |  R4 |  R3 |  R2 |  R1 |  R0
+ *  6[0xc0]:   1 |   1 |   0 |   0 | RSD |   0 |   0 |   0
+ *  7[0x20]:  P1 | BF6 | BF5 | BF4 | BF3 | BF2 | BF1 |   0
+ *  8[0xdb]:   1 |   1 |   0 |   1 |   0 |  CC |   1 |   1
+ *  9[0x30]: VSD |  V2 |  V1 |  V0 |  S3 |  S2 |  S1 |  S0
+ * 10[0xe1]:   1 |   1 |   1 |   0 |   0 | LS2 | LS1 | LS0
+ * 11[0xf5]:  WS | WH2 | WH1 | WH0 | WL2 | WL1 | WL0 | WRE
+ * 12[0xf0]:   1 |   1 |   1 |   1 |   0 |   0 |   0 |   0
+ * 13[0x28]:  PD | BR4 | BR3 | BR2 | BR1 | BR0 | CLR |  TL
+ */
+
+
+static int zl10036_set_frequency(struct zl10036_state *state, u32 frequency)
+{
+	u8 buf[2];
+	u32 div, foffset;
+
+	div = (frequency + _FR/2) / _FR;
+	state->frequency = div * _FR;
+
+	foffset = frequency - state->frequency;
+
+	buf[0] = (div >> 8) & 0x7f;
+	buf[1] = (div >> 0) & 0xff;
+
+	deb_info("%s: ftodo=%u fpriv=%u ferr=%d div=%u\n", __FUNCTION__,
+		frequency, state->frequency, foffset, div);
+
+	return zl10036_write(state, buf, sizeof(buf));
+}
+
+static int zl10036_set_bandwidth(struct zl10036_state *state, u32 fbw)
+{
+	/* fbw is measured in kHz */
+	u8 br, bf;
+	int ret;
+	u8 buf_bf[] = {
+		0xc0, 0x00, /*   6/7: rsd=0 bf=0 */
+	};
+	u8 buf_br[] = {
+		0xf0, 0x00, /* 12/13: br=0xa clr=0 tl=0*/
+	};
+	u8 zl10036_rsd_off[] = { 0xc8 }; /* set RSD=1 */
+
+	/* ensure correct values */
+	if (fbw > 35000)
+		fbw = 35000;
+	if (fbw <  8000)
+		fbw =  8000;
+
+#define _BR_MAXIMUM (_XTAL/575) /* _XTAL / 575kHz = 17 */
+
+	/* <= 28,82 MHz */
+	if (fbw <= 28820) {
+		br = _BR_MAXIMUM;
+	} else {
+		/**
+		 *  f(bw)=34,6MHz f(xtal)=10.111MHz
+		 *  br = (10111/34600) * 63 * 1/K = 14;
+		 */
+#if 0
+		br = ((_XTAL * 63 * 1000) / (fbw * 1257));
+#endif
+		br = ((_XTAL * 21 * 1000) / (fbw * 419));
+	}
+
+	/* ensure correct values */
+	if (br < 4)
+		br = 4;
+	if (br > _BR_MAXIMUM)
+		br = _BR_MAXIMUM;
+
+	/*
+	 * k = 1.257
+	 * bf = fbw/_XTAL * br * k - 1 */
+
+	bf = (fbw * br * 1257) / (_XTAL * 1000) - 1;
+
+	/* ensure correct values */
+	if (bf > 62)
+		bf = 62;
+
+	buf_bf[1] = (bf << 1) & 0x7e;
+	buf_br[1] = (br << 2) & 0x7c;
+	deb_info("%s: BW=%d br=%u bf=%u\n", __FUNCTION__, fbw, br, bf);
+
+	if (br != state->br) {
+		ret = zl10036_write(state, buf_br, sizeof(buf_br));
+		if (ret < 0)
+			return ret;
+	}
+
+	if (bf != state->bf) {
+		ret = zl10036_write(state, buf_bf, sizeof(buf_bf));
+		if (ret < 0)
+			return ret;
+
+		/* time = br/(32* fxtal) */
+		/* minimal sleep time to be calculated
+		 * maximum br is 63 -> max time = 2 /10 MHz = 2e-7 */
+		msleep(1);
+
+		ret = zl10036_write(state, zl10036_rsd_off,
+			sizeof(zl10036_rsd_off));
+		if (ret < 0)
+			return ret;
+	}
+
+	/* disable this optimization for now */
+#if 0
+	state->br = br;
+	state->bf = bf;
+#endif
+
+	return 0;
+}
+
+static int zl10036_set_gain_params(struct zl10036_state *state,
+	int c)
+{
+	u8 buf[2];
+	u8 rfg, ba, bg;
+
+	/* default values */
+	rfg = 0; /* enable when using an lna */
+	ba = 1;
+	bg = 1;
+
+	/* reg 4 */
+	buf[0] = 0x80 | ((rfg << 5) & 0x20)
+		| ((ba  << 3) & 0x18) | ((bg  << 1) & 0x06);
+
+	if (!state->config->rf_loop_enable)
+		buf[0] |= 0x01;
+
+	/* P0=0 */
+	buf[1] = _RDIV_REG | ((c << 5) & 0x60);
+
+	deb_info("%s: c=%u rfg=%u ba=%u bg=%u\n", __FUNCTION__, c, rfg, ba, bg);
+	return zl10036_write(state, buf, sizeof(buf));
+}
+
+static int zl10036_set_params(struct dvb_frontend *fe, struct
+		dvb_frontend_parameters *params)
+{
+	struct zl10036_state *state = fe->tuner_priv;
+	int ret = 0;
+	u32 frequency = params->frequency;
+	u32 fbw;
+	int i;
+	u8 c;
+
+	/* ensure correct values
+	 * maybe redundant as core already checks this */
+	if ((frequency < fe->ops.info.frequency_min)
+	||  (frequency > fe->ops.info.frequency_max))
+		return -EINVAL;
+
+	/**
+	 * alpha = 1.35 for dvb-s
+	 * fBW = (alpha*symbolrate)/(2*0.8)
+	 * 1.35 / (2*0.8) = 1.35 / 1.6 = 135 / 160 = 27 / 32
+	 */
+	fbw = (27 * params->u.qpsk.symbol_rate) / 32;
+
+	/* scale to kHz */
+	fbw /= 1000;
+
+	/* Add safe margin of 3MHz */
+	fbw += 3000;
+
+
+	/* Set maximal bandwidth */
+	//fbw = 35000;
+
+	/* setting the charge pump - guessed values!  */
+	if (frequency < 950000)
+		return -EINVAL;
+	else if (frequency < 1250000)
+		c = 0;
+	else if (frequency < 1750000)
+		c = 1;
+	else if (frequency < 2175000)
+		c = 2;
+	else
+		return -EINVAL;
+
+
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 1); /* open i2c_gate */
+
+	ret = zl10036_set_gain_params(state, c);
+	if (ret < 0)
+		goto error;
+
+	ret = zl10036_set_frequency(state, params->frequency);
+	if (ret < 0)
+		goto error;
+
+	ret = zl10036_set_bandwidth(state, fbw);
+	if (ret < 0)
+		goto error;
+
+	/* wait for tuner lock - no idea if this is really needed */
+	for (i = 0; i < 20; i++) {
+		ret = zl10036_read_status_reg(state);
+		if (ret < 0)
+			goto error;
+
+		/* check Frequency & Phase Lock Bit */
+		if (ret & STATUS_FL)
+			break;
+
+		msleep(10);
+	}
+
+error:
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 0); /* close i2c_gate */
+
+	return ret;
+}
+
+static int zl10036_get_frequency(struct dvb_frontend *fe, u32 *frequency)
+{
+	struct zl10036_state *state = fe->tuner_priv;
+
+	*frequency = state->frequency;
+
+	return 0;
+}
+
+#if 0
+static int zl10036_set_voltage_windows(struct dvb_frontend *fe)
+{
+	struct zl10036_state *state = fe->tuner_priv;
+
+	/* 10/11: from datasheet - lock window levels */
+	u8 buf1[2] = { 0xe3, 0x5b };
+
+	/* 10/11: from datasheet - unlock window levels */
+	u8 buf2[2] = { 0xe3, 0xf9 };
+	int ret;
+
+	ret = zl10036_write(state, buf1, sizeof(buf1));
+	if (ret < 0)
+		return ret;
+
+	ret = zl10036_write(state, buf2, sizeof(buf2));
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+static int zl10036_init_regs(struct dvb_frontend *fe)
+{
+	struct zl10036_state *state = fe->tuner_priv;
+	int ret;
+
+	u8 init_tab[] = { 0xd3, 0x40 }; /* 8/9: from datasheet */
+
+	/* invalid values to trigger writing */
+	state->br = 0xff;
+	state->bf = 0xff;
+
+	deb_info("%s\n", __FUNCTION__);
+
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 1); /* open i2c_gate */
+
+	/* write a valid frequency - 1000MHz */
+	ret = zl10036_set_frequency(fe, 1000000);
+	if (ret < 0)
+		return ret;
+
+	/* set maximum bandwidth */
+	ret = zl10036_set_bandwidth(fe, 35000);
+	if (ret < 0)
+		return ret;
+
+	ret = zl10036_set_gain_params(fe, 0);
+	if (ret < 0)
+		return ret;
+
+	ret = zl10036_set_voltage_windows(fe);
+	if (ret < 0)
+		return ret;
+
+	ret = zl10036_write(state, init_tab, sizeof(init_tab));
+	if (ret < 0)
+		return ret;
+
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 0); /* close i2c_gate */
+
+	return 0;
+}
+#else
+
+static int zl10036_init_regs(struct zl10036_state *state)
+{
+	int ret;
+	int i;
+
+	/* could also be one block from 2 to 13 and additional 10/11 */
+	u8 zl10036_init_tab[][2] = {
+		{ 0x04, 0x00 },		/*   2/3: div=0x400 - arbitrary value */
+		{ 0x8b, _RDIV_REG },	/*   4/5: rfg=0 ba=1 bg=1 len=? */
+					/*        p0=0 c=0 r=_RDIV_REG */
+		{ 0xc0, 0x20 },		/*   6/7: rsd=0 bf=0x10 */
+		{ 0xd3, 0x40 },		/*   8/9: from datasheet */
+		{ 0xe3, 0x5b },		/* 10/11: lock window level */
+		{ 0xf0, 0x28 },		/* 12/13: br=0xa clr=0 tl=0*/
+		{ 0xe3, 0xf9 },		/* 10/11: unlock window level */
+	};
+
+
+
+	/* invalid values to trigger writing */
+	state->br = 0xff;
+	state->bf = 0xff;
+
+	if (!state->config->rf_loop_enable)
+		zl10036_init_tab[1][2] |= 0x01;
+
+	deb_info("%s\n", __FUNCTION__);
+
+	for (i = 0; i < ARRAY_SIZE(zl10036_init_tab); i++) {
+		ret = zl10036_write(state, zl10036_init_tab[i], 2);
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
+}
+#endif
+
+static int zl10036_init(struct dvb_frontend *fe)
+{
+	struct zl10036_state *state = fe->tuner_priv;
+	int ret = 0;
+
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 1); /* open i2c_gate */
+
+	/* error handling? */
+	ret = zl10036_read_status_reg(state);
+
+#if 0
+	/* only init if Power-on-Reset bit is set */
+	if (ret & STATUS_POR)
+		zl10036_init_regs(fe);
+#else
+	ret = zl10036_init_regs(state);
+#endif
+
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 0); /* close i2c_gate */
+
+	return ret;
+}
+
+static struct dvb_tuner_ops zl10036_tuner_ops = {
+	.info = {
+		.name = "Zarlink ZL10036",
+		.frequency_min = 950000,
+		.frequency_max = 2175000
+	},
+	.init = zl10036_init,
+	.release = zl10036_release,
+	.sleep = zl10036_sleep,
+	.set_params = zl10036_set_params,
+	.get_frequency = zl10036_get_frequency,
+};
+
+#if 0
+static char *zl10036_part[] = {
+	[ZL1003X_TYPE_ZL10036] = "Zarlink ZL10036",
+	[ZL1003X_TYPE_ZL10037] = "Zarlink ZL10037",
+	[ZL1003X_TYPE_ZL10038] = "Zarlink ZL10038",
+	[ZL1003X_TYPE_ZL10039] = "Zarlink ZL10039",
+	[ZL1003X_TYPE_CE5037]  = "Intel CE5037",
+	[ZL1003X_TYPE_CE5039]  = "Intel CE5039",
+};
+#endif
+
+struct dvb_frontend *zl10036_attach(struct dvb_frontend *fe,
+				    const struct zl10036_config *config,
+				    struct i2c_adapter *i2c)
+{
+	struct zl10036_state *state = NULL;
+	int ret;
+#if 0
+	const char *name = NULL;
+#endif
+
+	if (NULL == config) {
+		printk(KERN_ERR "%s: no config specified", __FUNCTION__);
+		goto error;
+	}
+
+#if 0
+	if (config->type < ARRAY_SIZE(zl10036_part))
+		name = zl10036_part[config->type];
+
+	if (NULL == name)
+		name = "Missing name";
+
+	switch (config->type) {
+	case ZL1003X_TYPE_ZL10036:
+		break;
+	default:
+		printk(KERN_WARNING "%s: Warning, unsupported silicon tuner"
+			" (type: %s)!\n", __FUNCTION__, name);
+		goto error;
+	}
+#endif
+
+	state = kzalloc(sizeof(struct zl10036_state), GFP_KERNEL);
+	if (state == NULL)
+		return NULL;
+
+	state->config = config;
+	state->i2c = i2c;
+
+
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 1); /* open i2c_gate */
+
+	ret = zl10036_read_status_reg(state);
+	if (ret < 0) {
+		printk(KERN_ERR "%s: No zl10036 found\n", __FUNCTION__);
+		goto error;
+	}
+
+	ret = zl10036_init_regs(state);
+	if (ret < 0) {
+		printk(KERN_ERR "%s: tuner initialization failed\n",
+			__FUNCTION__);
+		goto error;
+	}
+
+	if (fe->ops.i2c_gate_ctrl)
+		fe->ops.i2c_gate_ctrl(fe, 0); /* close i2c_gate */
+
+	fe->tuner_priv = state;
+
+	memcpy(&fe->ops.tuner_ops, &zl10036_tuner_ops,
+		sizeof(struct dvb_tuner_ops));
+#if 0
+	strcpy(fe->ops.tuner_ops.info.name, name);
+#endif
+	printk(KERN_INFO "%s: tuner initialization (%s addr=0x%02x) ok\n",
+		__FUNCTION__, fe->ops.tuner_ops.info.name, config->tuner_address);
+
+	return fe;
+
+error:
+	zl10036_release(fe);
+	return NULL;
+}
+EXPORT_SYMBOL(zl10036_attach);
+
+module_param_named(debug, zl10036_debug, int, 0644);
+MODULE_PARM_DESC(debug, "Turn on/off frontend debugging (default:off).");
+MODULE_DESCRIPTION("DVB ZL10036 driver");
+MODULE_AUTHOR("Tino Reichardt");
+MODULE_AUTHOR("Matthias Schwarzott");
+MODULE_LICENSE("GPL");
Index: v4l-dvb/linux/drivers/media/dvb/frontends/zl10036.h
===================================================================
--- /dev/null
+++ v4l-dvb/linux/drivers/media/dvb/frontends/zl10036.h
@@ -0,0 +1,67 @@
+/**
+ * Driver for Zarlink ZL10036 DVB-S silicon tuner
+ *
+ * Copyright (C) 2006 Tino Reichardt
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License Version 2, as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#ifndef DVB_ZL10036_H
+#define DVB_ZL10036_H
+
+#include <linux/i2c.h>
+#include "dvb_frontend.h"
+
+/**
+ * Attach a zl10036 tuner to the supplied frontend structure.
+ *
+ * @param fe Frontend to attach to.
+ * @param config zl10036_config structure
+ * @return FE pointer on success, NULL on failure.
+ */
+
+#if 0
+enum zl10036_chip_type {
+	UNDEFINED,
+	ZL1003X_TYPE_ZL10036,
+	ZL1003X_TYPE_ZL10037,
+	ZL1003X_TYPE_ZL10038,
+	ZL1003X_TYPE_ZL10039,
+	ZL1003X_TYPE_CE5037,
+	ZL1003X_TYPE_CE5039,
+};
+#endif
+
+struct zl10036_config {
+	u8 tuner_address;
+	int rf_loop_enable;
+#if 0
+	enum zl10036_chip_type type;
+	uint output_ports:2;
+#endif
+};
+
+#if defined(CONFIG_DVB_ZL10036) || (defined(CONFIG_DVB_ZL10036_MODULE) && defined(MODULE))
+extern struct dvb_frontend *zl10036_attach(struct dvb_frontend *fe,
+	const struct zl10036_config *config, struct i2c_adapter *i2c);
+#else
+static inline struct dvb_frontend *zl10036_attach(struct dvb_frontend *fe,
+	const struct zl10036_config *config, struct i2c_adapter *i2c)
+{
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __FUNCTION__);
+	return NULL;
+}
+#endif
+
+#endif /* DVB_ZL10036_H */
Index: v4l-dvb/linux/drivers/media/video/saa7134/Kconfig
===================================================================
--- v4l-dvb.orig/linux/drivers/media/video/saa7134/Kconfig
+++ v4l-dvb/linux/drivers/media/video/saa7134/Kconfig
@@ -38,6 +38,8 @@ config VIDEO_SAA7134_DVB
 	select DVB_TDA827X if !DVB_FE_CUSTOMISE
 	select DVB_ISL6421 if !DVB_FE_CUSTOMISE
 	select TUNER_SIMPLE if !DVB_FE_CUSTOMISE
+	select DVB_ZL10036 if !DVB_FE_CUSTOMISE
+	select DVB_MT312 if !DVB_FE_CUSTOMISE
 	---help---
 	  This adds support for DVB cards based on the
 	  Philips saa7134 chip.
Index: v4l-dvb/linux/drivers/media/video/saa7134/saa7134-cards.c
===================================================================
--- v4l-dvb.orig/linux/drivers/media/video/saa7134/saa7134-cards.c
+++ v4l-dvb/linux/drivers/media/video/saa7134/saa7134-cards.c
@@ -4261,8 +4261,7 @@ struct saa7134_board saa7134_boards[] = 
 		.radio_type     = UNSET,
 		.tuner_addr     = ADDR_UNSET,
 		.radio_addr     = ADDR_UNSET,
-		/* no DVB support for now */
-		/* .mpeg           = SAA7134_MPEG_DVB, */
+		.mpeg           = SAA7134_MPEG_DVB,
 		.inputs         = { {
 			.name = name_comp,
 			.vmux = 1,
@@ -4281,8 +4280,7 @@ struct saa7134_board saa7134_boards[] = 
 		.radio_type     = UNSET,
 		.tuner_addr     = ADDR_UNSET,
 		.radio_addr     = ADDR_UNSET,
-		/* no DVB support for now */
-		/* .mpeg           = SAA7134_MPEG_DVB, */
+		.mpeg           = SAA7134_MPEG_DVB,
 		.inputs         = { {
 			.name = name_comp,
 			.vmux = 1,
@@ -5676,12 +5674,24 @@ int saa7134_board_init1(struct saa7134_d
 		break;
 	case SAA7134_BOARD_AVERMEDIA_A700_PRO:
 	case SAA7134_BOARD_AVERMEDIA_A700_HYBRID:
+#if 0
+		/* power-up tuner chip */
+		saa_andorl(SAA7134_GPIO_GPMODE0 >> 2,   0xffffffff, 0xffffffff);
+		saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, 0xffffffff, 0xffffffff);
+		msleep(1);
+#endif
+#if 1
 		/* write windows gpio values */
 		saa_andorl(SAA7134_GPIO_GPMODE0 >> 2,   0x80040100, 0x80040100);
 		saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, 0x80040100, 0x00040100);
-		printk("%s: %s: hybrid analog/dvb card\n"
-		       "%s: Sorry, only the analog inputs are supported for now.\n",
-			dev->name, card(dev).name, dev->name);
+#endif
+#if 0
+		/* reset demod */
+		saa7134_set_gpio(dev, 23, 1);
+		msleep(100);
+		saa7134_set_gpio(dev, 23, 3); // back to tristate = input mode
+		msleep(100);
+#endif
 		break;
 	}
 	return 0;
Index: v4l-dvb/linux/drivers/media/video/saa7134/saa7134-dvb.c
===================================================================
--- v4l-dvb.orig/linux/drivers/media/video/saa7134/saa7134-dvb.c
+++ v4l-dvb/linux/drivers/media/video/saa7134/saa7134-dvb.c
@@ -49,6 +49,9 @@
 #include "lnbp21.h"
 #include "tuner-simple.h"
 
+#include "zl10036.h"
+#include "mt312.h"
+
 MODULE_AUTHOR("Gerd Knorr <kraxel@bytesex.org> [SuSE Labs]");
 MODULE_LICENSE("GPL");
 
@@ -933,6 +936,17 @@ static struct nxt200x_config kworldatsc1
 	.demod_address    = 0x0a,
 };
 
+/* ------------------------------------------------------------------ */
+
+static struct mt312_config avertv_a700_mt312 = {
+	.demod_address = 0x0e,
+	.voltage_inverted = 1,
+};
+
+static struct zl10036_config avertv_a700_tuner = {
+	.tuner_address = 0x60,
+};
+
 /* ==================================================================
  * Core code
  */
@@ -1242,6 +1256,18 @@ static int dvb_init(struct saa7134_dev *
 			fe->ops.enable_high_lnb_voltage = md8800_set_high_voltage;
 		}
 		break;
+	case SAA7134_BOARD_AVERMEDIA_A700_PRO:
+	case SAA7134_BOARD_AVERMEDIA_A700_HYBRID:
+		dev->dvb.frontend = dvb_attach(vp310_mt312_attach,
+			&avertv_a700_mt312, &dev->i2c_adap);
+		if (dev->dvb.frontend) {
+			if (dvb_attach(zl10036_attach, dev->dvb.frontend,
+					&avertv_a700_tuner, &dev->i2c_adap) == NULL) {
+				wprintk("%s: No zl10036 found!\n",
+					__FUNCTION__);
+			}
+		}
+		break;
 	default:
 		wprintk("Huh? unknown DVB card?\n");
 		break;

--Boundary-00=_tW/EIyUOCQ1kFBG
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--Boundary-00=_tW/EIyUOCQ1kFBG--
