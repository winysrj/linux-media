Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:58024 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759213Ab2EUVUG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 May 2012 17:20:06 -0400
From: "Hans-Frieder Vogt" <hfvogt@gmx.net>
To: Antti Palosaari <crope@iki.fi>
Subject: Re: [PATCH 3/3] fc001x: tuner driver for FC0013
Date: Mon, 21 May 2012 23:19:58 +0200
Cc: linux-media@vger.kernel.org,
	Thomas Mair <thomas.mair86@googlemail.com>
References: <201205062257.02674.hfvogt@gmx.net> <4FB93B2E.6010109@iki.fi>
In-Reply-To: <4FB93B2E.6010109@iki.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201205212319.58264.hfvogt@gmx.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Antti,

Am Sonntag, 20. Mai 2012 schrieb Antti Palosaari:
> On 06.05.2012 23:57, Hans-Frieder Vogt wrote:
> > Support for tuner Fitipower FC0013
> > 
> > Signed-off-by: Hans-Frieder Vogt<hfvogt@gmx.net>
> > 
> >   drivers/media/common/tuners/Kconfig       |    7
> >   drivers/media/common/tuners/Makefile      |    1
> >   drivers/media/common/tuners/fc0013-priv.h |   44 ++
> >   drivers/media/common/tuners/fc0013.c      |  562
> >   ++++++++++++++++++++++++++++++ drivers/media/common/tuners/fc0013.h   
> >     |   57 +++
> >   5 files changed, 671 insertions(+)
> >
> > diff -up --new-file --recursive a/drivers/media/common/tuners/Kconfig
> > b/drivers/media/common/tuners/Kconfig ---
> > a/drivers/media/common/tuners/Kconfig	2012-05-06 22:20:10.167088333
> > +0200 +++ b/drivers/media/common/tuners/Kconfig	2012-05-05
> > 12:00:43.769785450 +0200 @@ -218,6 +218,13 @@ config MEDIA_TUNER_FC0012
> > 
> >   	help
> >   	
> >   	  Fitipower FC0012 silicon tuner driver.
> > 
> > +config MEDIA_TUNER_FC0013
> > +	tristate "Fitipower FC0013 silicon tuner"
> > +	depends on VIDEO_MEDIA&&  I2C
> > +	default m if MEDIA_TUNER_CUSTOMISE
> > +	help
> > +	  Fitipower FC0013 silicon tuner driver.
> > +
> > 
> >   config MEDIA_TUNER_TDA18212
> >   
> >   	tristate "NXP TDA18212 silicon tuner"
> >   	depends on VIDEO_MEDIA&&  I2C
> > 
> > diff -up --new-file --recursive a/drivers/media/common/tuners/Makefile
> > b/drivers/media/common/tuners/Makefile ---
> > a/drivers/media/common/tuners/Makefile	2012-05-06 22:20:25.270299615
> > +0200 +++ b/drivers/media/common/tuners/Makefile	2012-05-06
> > 19:13:08.974524215 +0200 @@ -31,6 +31,7 @@
> > obj-$(CONFIG_MEDIA_TUNER_TDA18212) += td
> > 
> >   obj-$(CONFIG_MEDIA_TUNER_TUA9001) += tua9001.o
> >   obj-$(CONFIG_MEDIA_TUNER_FC0011) += fc0011.o
> >   obj-$(CONFIG_MEDIA_TUNER_FC0012) += fc0012.o
> > 
> > +obj-$(CONFIG_MEDIA_TUNER_FC0013) += fc0013.o
> > 
> >   ccflags-y += -I$(srctree)/drivers/media/dvb/dvb-core
> >   ccflags-y += -I$(srctree)/drivers/media/dvb/frontends
> > 
> > diff -up --new-file --recursive a/drivers/media/common/tuners/fc0013.c
> > b/drivers/media/common/tuners/fc0013.c ---
> > a/drivers/media/common/tuners/fc0013.c	1970-01-01 01:00:00.000000000
> > +0100 +++ b/drivers/media/common/tuners/fc0013.c	2012-05-06
> > 19:40:15.506368324 +0200 @@ -0,0 +1,562 @@
> > +/*
> > + * Fitipower FC0013 tuner driver
> > + *
> > + * Copyright (C) 2012 Hans-Frieder Vogt<hfvogt@gmx.net>
> > + * partially based on driver code from Fitipower
> > + * Copyright (C) 2010 Fitipower Integrated Technology Inc
> > + *
> > + *    This program is free software; you can redistribute it and/or
> > modify + *    it under the terms of the GNU General Public License as
> > published by + *    the Free Software Foundation; either version 2 of
> > the License, or + *    (at your option) any later version.
> > + *
> > + *    This program is distributed in the hope that it will be useful,
> > + *    but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + *    GNU General Public License for more details.
> > + *
> > + *    You should have received a copy of the GNU General Public License
> > + *    along with this program; if not, write to the Free Software
> > + *    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> > + *
> > + */
> > +
> > +#include "fc0013.h"
> > +#include "fc0013-priv.h"
> > +
> > +static int fc0013_writereg(struct fc0013_priv *priv, u8 reg, u8 val)
> > +{
> > +	u8 buf[2] = {reg, val};
> > +	struct i2c_msg msg = {
> > +		.addr = priv->addr, .flags = 0, .buf = buf, .len = 2
> > +	};
> > +
> > +	if (i2c_transfer(priv->i2c,&msg, 1) != 1) {
> > +		err("I2C write reg failed, reg: %02x, val: %02x", reg, val);
> > +		return -EREMOTEIO;
> > +	}
> > +	return 0;
> > +}
> > +
> > +static int fc0013_readreg(struct fc0013_priv *priv, u8 reg, u8 *val)
> > +{
> > +	struct i2c_msg msg[2] = {
> > +		{ .addr = priv->addr, .flags = 0, .buf =&reg, .len = 1 },
> > +		{ .addr = priv->addr, .flags = I2C_M_RD, .buf = val, .len = 1 },
> > +	};
> > +
> > +	if (i2c_transfer(priv->i2c, msg, 2) != 2) {
> > +		err("I2C read reg failed, reg: %02x", reg);
> > +		return -EREMOTEIO;
> > +	}
> > +	return 0;
> > +}
> > +
> > +static int fc0013_release(struct dvb_frontend *fe)
> > +{
> > +	kfree(fe->tuner_priv);
> > +	fe->tuner_priv = NULL;
> > +	return 0;
> > +}
> > +
> > +static int fc0013_init(struct dvb_frontend *fe)
> > +{
> > +	struct fc0013_priv *priv = fe->tuner_priv;
> > +	int i, ret = 0;
> > +	unsigned char reg[] = {
> > +		0x00,	/* reg. 0x00: dummy */
> > +		0x09,	/* reg. 0x01 */
> > +		0x16,	/* reg. 0x02 */
> > +		0x00,	/* reg. 0x03 */
> > +		0x00,	/* reg. 0x04 */
> > +		0x17,	/* reg. 0x05 */
> > +		0x02,	/* reg. 0x06 */
> > +		0x0a,	/* reg. 0x07: CHECK */
> > +		0xff,	/* reg. 0x08: AGC Clock divide by 256, AGC gain 1/256,
> > +			   Loop Bw 1/8 */
> > +		0x6f,	/* reg. 0x09: enable LoopThrough */
> > +		0xb8,	/* reg. 0x0a: Disable LO Test Buffer */
> > +		0x82,	/* reg. 0x0b: CHECK */
> > +		0xfc,	/* reg. 0x0c: depending on AGC Up-Down mode, may need 0xf8 
*/
> > +		0x01,	/* reg. 0x0d: AGC Not Forcing&  LNA Forcing, may need 
0x02 */
> > +		0x00,	/* reg. 0x0e */
> > +		0x00,	/* reg. 0x0f */
> > +		0x00,	/* reg. 0x10 */
> > +		0x00,	/* reg. 0x11 */
> > +		0x00,	/* reg. 0x12 */
> > +		0x00,	/* reg. 0x13 */
> > +		0x50,	/* reg. 0x14: DVB-t High Gain, UHF.
> > +			   Middle Gain: 0x48, Low Gain: 0x40 */
> > +		0x01,	/* reg. 0x15 */
> > +	};
> > +
> > +	switch (priv->xtal_freq) {
> > +	case FC_XTAL_27_MHZ:
> > +	case FC_XTAL_28_8_MHZ:
> > +		reg[0x07] |= 0x20;
> > +		break;
> > +	case FC_XTAL_36_MHZ:
> > +	default:
> > +		break;
> > +	}
> > +
> > +	if (priv->dual_master)
> > +		reg[0x0c] |= 0x02;
> > +
> > +	if (fe->ops.i2c_gate_ctrl)
> > +		fe->ops.i2c_gate_ctrl(fe, 1); /* open I2C-gate */
> > +
> > +	for (i = 1; i<  sizeof(reg); i++) {
> > +		ret = fc0013_writereg(priv, i, reg[i]);
> > +		if (ret)
> > +			break;
> > +	}
> > +
> > +	if (fe->ops.i2c_gate_ctrl)
> > +		fe->ops.i2c_gate_ctrl(fe, 0); /* close I2C-gate */
> > +
> > +	if (ret)
> > +		err("fc0013_writereg failed: %d", ret);
> > +
> > +	return ret;
> > +}
> > +
> > +static int fc0013_sleep(struct dvb_frontend *fe)
> > +{
> > +	/* nothing to do here */
> > +	return 0;
> > +}
> > +
> > +int fc0013_rc_cal_add(struct dvb_frontend *fe, int rc_val)
> > +{
> > +	struct fc0013_priv *priv = fe->tuner_priv;
> > +	int ret;
> > +	u8 rc_cal;
> > +	int val;
> > +
> > +	if (fe->ops.i2c_gate_ctrl)
> > +		fe->ops.i2c_gate_ctrl(fe, 1); /* open I2C-gate */
> > +
> > +	/* push rc_cal value, get rc_cal value */
> > +	ret = fc0013_writereg(priv, 0x10, 0x00);
> > +	if (ret)
> > +		goto error_out;
> > +
> > +	/* get rc_cal value */
> > +	ret = fc0013_readreg(priv, 0x10,&rc_cal);
> > +	if (ret)
> > +		goto error_out;
> > +
> > +	rc_cal&= 0x0f;
> > +
> > +	val = (int)rc_cal + rc_val;
> > +
> > +	/* forcing rc_cal */
> > +	ret = fc0013_writereg(priv, 0x0d, 0x11);
> > +	if (ret)
> > +		goto error_out;
> > +
> > +	/* modify rc_cal value */
> > +	if (val>  15)
> > +		ret = fc0013_writereg(priv, 0x10, 0x0f);
> > +	else if (val<  0)
> > +		ret = fc0013_writereg(priv, 0x10, 0x00);
> > +	else
> > +		ret = fc0013_writereg(priv, 0x10, (u8)val);
> 
> I don't see reason you cast it to the u8 as you have just checked it is
> between 0 and 15.
> 
> Maybe you should consider:
> 
> if (val > 0x0f)
>    val = 0x0f;
> else if (val < 0x00)
>    val = 0x00;
> 
> ret = fc0013_writereg(priv, 0x10, val);
> 
> and generated code is smaller and code is simpler...
>
true. I'll simplify this.
 
> > +
> > +error_out:
> > +	if (fe->ops.i2c_gate_ctrl)
> > +		fe->ops.i2c_gate_ctrl(fe, 0); /* close I2C-gate */
> > +
> > +	return ret;
> > +}
> > +EXPORT_SYMBOL(fc0013_rc_cal_add);
> 
> Could you explain what is use of that exported function?
> I did not see any usage for it when looking dvb_usb_rtl28xxu ...
> 
The windows driver uses this and the following function after tuning. 
Obviously it also works without, but I thought that it could be useful. 
However I can also leave it out and implement it again if there is a real need 
for it...

> > +
> > +int fc0013_rc_cal_reset(struct dvb_frontend *fe)
> > +{
> > +	struct fc0013_priv *priv = fe->tuner_priv;
> > +	int ret;
> > +
> > +	if (fe->ops.i2c_gate_ctrl)
> > +		fe->ops.i2c_gate_ctrl(fe, 1); /* open I2C-gate */
> > +
> > +	ret = fc0013_writereg(priv, 0x0d, 0x01);
> > +	if (!ret)
> > +		ret = fc0013_writereg(priv, 0x10, 0x00);
> > +
> > +	if (fe->ops.i2c_gate_ctrl)
> > +		fe->ops.i2c_gate_ctrl(fe, 0); /* close I2C-gate */
> > +
> > +	return ret;
> > +}
> > +EXPORT_SYMBOL(fc0013_rc_cal_reset);
> 
> And same here.
> 
>  From the name I can guess these both exported functions are for the
> calibration. But without any use.
> 
> > +
> > +static int fc0013_set_vhf_track(struct fc0013_priv *priv, u32 freq)
> > +{
> > +	int ret;
> > +	u8 tmp;
> > +
> > +	ret = fc0013_readreg(priv, 0x1d,&tmp);
> > +	if (ret)
> > +		goto error_out;
> > +	tmp&= 0xe3;
> > +	if (freq<= 177500) {		/* VHF Track: 7 */
> > +		ret = fc0013_writereg(priv, 0x1d, tmp | 0x1c);
> > +	} else if (freq<= 184500) {	/* VHF Track: 6 */
> > +		ret = fc0013_writereg(priv, 0x1d, tmp | 0x18);
> > +	} else if (freq<= 191500) {	/* VHF Track: 5 */
> > +		ret = fc0013_writereg(priv, 0x1d, tmp | 0x14);
> > +	} else if (freq<= 198500) {	/* VHF Track: 4 */
> > +		ret = fc0013_writereg(priv, 0x1d, tmp | 0x10);
> > +	} else if (freq<= 205500) {	/* VHF Track: 3 */
> > +		ret = fc0013_writereg(priv, 0x1d, tmp | 0x0c);
> > +	} else if (freq<= 219500) {	/* VHF Track: 2 */
> > +		ret = fc0013_writereg(priv, 0x1d, tmp | 0x08);
> > +	} else if (freq<  300000) {	/* VHF Track: 1 */
> > +		ret = fc0013_writereg(priv, 0x1d, tmp | 0x04);
> > +	} else {			/* UHF and GPS */
> > +		ret = fc0013_writereg(priv, 0x1d, tmp | 0x1c);
> > +	}
> 
> I think the generated code will be much smaller if you just resolve
> register value and finally write it. As you can see the routine is for
> selecting register 0x1d value based of target frequency.
> 
OK. Will be changed.

> Also using {..} for the single line is not allowed. Forget to ran
> checkpatch.pl ?
> 
strange enough checkpatch didn't detect that (maybe old version?).

> > +	if (ret)
> > +		goto error_out;
> > +error_out:
> > +	return ret;
> > +}
> > +
> > +static int fc0013_set_params(struct dvb_frontend *fe)
> > +{
> > +	struct fc0013_priv *priv = fe->tuner_priv;
> > +	int i, ret = 0;
> > +	struct dtv_frontend_properties *p =&fe->dtv_property_cache;
> > +	u32 freq = p->frequency / 1000;
> > +	u32 delsys = p->delivery_system;
> > +	unsigned char reg[7], am, pm, multi, tmp;
> > +	unsigned long f_vco;
> > +	unsigned short xtal_freq_khz_2, xin, xdiv;
> > +	int vco_select = false;
> > +
> > +	if (fe->callback) {
> > +		ret = fe->callback(priv->i2c, DVB_FRONTEND_COMPONENT_TUNER,
> > +			FC_FE_CALLBACK_VHF_ENABLE, (freq>  300000 ? 0 : 1));
> > +		if (ret)
> > +			goto exit;
> > +	}
> > +
> > +	switch (priv->xtal_freq) {
> > +	case FC_XTAL_27_MHZ:
> > +		xtal_freq_khz_2 = 27000 / 2;
> > +		break;
> > +	case FC_XTAL_36_MHZ:
> > +		xtal_freq_khz_2 = 36000 / 2;
> > +		break;
> > +	case FC_XTAL_28_8_MHZ:
> > +	default:
> > +		xtal_freq_khz_2 = 28800 / 2;
> > +		break;
> > +	}
> 
> My personal opinion is that we should never use enums like that. If we
> have some real number like a frequency it is always simple to pass it as
> it is. In that case you have converted Xtal frequency first as a enum
> value and then here from enum back to real Xtal. If real Xtal frequency
> used you can just write it xtal_freq_khz_2 = config->xtal / 2;
> 
> #define NUMBER_0 0
> #define NUMBER_1 1
> 
> or
> 
> enum numbers {
>    NUMBER_0 0,
>    NUMBER_1 1,
> }
> 
> not good IMHO.

I can follow your argumentation, but am not fully convinced:
Chosing an enum for a limited number of options helps focus on the available 
options and thus reduces errors. If we had hundreds of possible crystal 
frequencies I would agree to directly use the frequency, but here we are 
talking about 3 possible values (may be more later, but certainly less than 
10).
Erroneously calling fc0013_attach with FC_XTAL_28_9_MHZ would be immediately 
detected at compile time, calling it with 28900000 would not.

> 
> > +
> > +	if (fe->ops.i2c_gate_ctrl)
> > +		fe->ops.i2c_gate_ctrl(fe, 1); /* open I2C-gate */
> > +
> > +	/* set VHF track */
> > +	ret = fc0013_set_vhf_track(priv, freq);
> > +	if (ret)
> > +		goto exit;
> > +
> > +	if (freq<  300000) {
> > +		/* enable VHF filter */
> > +		ret = fc0013_readreg(priv, 0x07,&tmp);
> > +		if (ret)
> > +			goto exit;
> > +		ret = fc0013_writereg(priv, 0x07, tmp | 0x10);
> > +		if (ret)
> > +			goto exit;
> > +
> > +		/* disable UHF&  disable GPS */
> > +		ret = fc0013_readreg(priv, 0x14,&tmp);
> > +		if (ret)
> > +			goto exit;
> > +		ret = fc0013_writereg(priv, 0x14, tmp&  0x1f);
> > +		if (ret)
> > +			goto exit;
> > +	} else if (freq<= 862000) {
> > +		/* disable VHF filter */
> > +		ret = fc0013_readreg(priv, 0x07,&tmp);
> > +		if (ret)
> > +			goto exit;
> > +		ret = fc0013_writereg(priv, 0x07, tmp&  0xef);
> > +		if (ret)
> > +			goto exit;
> > +
> > +		/* enable UHF&  disable GPS */
> > +		ret = fc0013_readreg(priv, 0x14,&tmp);
> > +		if (ret)
> > +			goto exit;
> > +		ret = fc0013_writereg(priv, 0x14, (tmp&  0x1f) | 0x40);
> > +		if (ret)
> > +			goto exit;
> > +	} else {
> > +		/* disable VHF filter */
> > +		ret = fc0013_readreg(priv, 0x07,&tmp);
> > +		if (ret)
> > +			goto exit;
> > +		ret = fc0013_writereg(priv, 0x07, tmp&  0xef);
> > +		if (ret)
> > +			goto exit;
> > +
> > +		/* disable UHF&  enable GPS */
> > +		ret = fc0013_readreg(priv, 0x14,&tmp);
> > +		if (ret)
> > +			goto exit;
> > +		ret = fc0013_writereg(priv, 0x14, (tmp&  0x1f) | 0x20);
> > +		if (ret)
> > +			goto exit;
> > +	}
> > +
> > +	/* select frequency divider and the frequency of VCO */
> > +	if (freq<  37084) {		/* freq * 96<  3560000 */
> > +		multi = 96;
> > +		reg[5] = 0x82;
> > +		reg[6] = 0x00;
> > +	} else if (freq<  55625) {	/* freq * 64<  3560000 */
> > +		multi = 64;
> > +		reg[5] = 0x02;
> > +		reg[6] = 0x02;
> > +	} else if (freq<  74167) {	/* freq * 48<  3560000 */
> > +		multi = 48;
> > +		reg[5] = 0x42;
> > +		reg[6] = 0x00;
> > +	} else if (freq<  111250) {	/* freq * 32<  3560000 */
> > +		multi = 32;
> > +		reg[5] = 0x82;
> > +		reg[6] = 0x02;
> > +	} else if (freq<  148334) {	/* freq * 24<  3560000 */
> > +		multi = 24;
> > +		reg[5] = 0x22;
> > +		reg[6] = 0x00;
> > +	} else if (freq<  222500) {	/* freq * 16<  3560000 */
> > +		multi = 16;
> > +		reg[5] = 0x42;
> > +		reg[6] = 0x02;
> > +	} else if (freq<  296667) {	/* freq * 12<  3560000 */
> > +		multi = 12;
> > +		reg[5] = 0x12;
> > +		reg[6] = 0x00;
> > +	} else if (freq<  445000) {	/* freq * 8<  3560000 */
> > +		multi = 8;
> > +		reg[5] = 0x22;
> > +		reg[6] = 0x02;
> > +	} else if (freq<  593334) {	/* freq * 6<  3560000 */
> > +		multi = 6;
> > +		reg[5] = 0x0a;
> > +		reg[6] = 0x00;
> > +	} else if (freq<  950000) {	/* freq * 4<  3800000 */
> > +		multi = 4;
> > +		reg[5] = 0x12;
> > +		reg[6] = 0x02;
> > +	} else {
> > +		multi = 2;
> > +		reg[5] = 0x0a;
> > +		reg[6] = 0x02;
> > +	}
> > +
> > +	f_vco = freq * multi;
> > +
> > +	if (f_vco>= 3060000) {
> > +		reg[6] |= 0x08;
> > +		vco_select = true;
> > +	}
> > +
> > +	if (freq>= 45000) {
> > +		/* From divided value (XDIV) determined the FA and FP value */
> > +		xdiv = (unsigned short)(f_vco / xtal_freq_khz_2);
> > +		if ((f_vco - xdiv * xtal_freq_khz_2)>= (xtal_freq_khz_2 / 2))
> > +			xdiv++;
> > +
> > +		pm = (unsigned char)(xdiv / 8);
> > +		am = (unsigned char)(xdiv - (8 * pm));
> > +
> > +		if (am<  2) {
> > +			reg[1] = am + 8;
> > +			reg[2] = pm - 1;
> > +		} else {
> > +			reg[1] = am;
> > +			reg[2] = pm;
> > +		}
> > +	} else {
> > +		/* fix for frequency less than 45 MHz */
> > +		reg[1] = 0x06;
> > +		reg[2] = 0x11;
> > +	}
> > +
> > +	/* fix clock out */
> > +	reg[6] |= 0x20;
> > +
> > +	/* From VCO frequency determines the XIN ( fractional part of Delta
> > +	   Sigma PLL) and divided value (XDIV) */
> > +	xin = (unsigned short)(f_vco - (f_vco / xtal_freq_khz_2) *
> > xtal_freq_khz_2); +	xin = (xin<<  15) / xtal_freq_khz_2;
> > +	if (xin>= 16384)
> > +		xin += 32768;
> > +
> > +	reg[3] = xin>>  8;
> > +	reg[4] = xin&  0xff;
> > +
> > +	if (delsys == SYS_DVBT) {
> > +		reg[6]&= 0x3f; /* bits 6 and 7 describe the bandwidth */
> > +		switch (p->bandwidth_hz) {
> > +		case 6000000:
> > +			reg[6] |= 0x80;
> > +			break;
> > +		case 7000000:
> > +			reg[6] |= 0x40;
> > +			break;
> > +		case 8000000:
> > +		default:
> > +			break;
> > +		}
> > +	} else {
> > +		err("%s: modulation type not supported!", __func__);
> > +		return -EINVAL;
> > +	}
> > +
> > +	/* modified for Realtek demod */
> > +	reg[5] |= 0x07;
> > +
> > +	for (i = 1; i<= 6; i++) {
> > +		ret = fc0013_writereg(priv, i, reg[i]);
> > +		if (ret)
> > +			goto exit;
> > +	}
> > +
> > +	ret = fc0013_readreg(priv, 0x11,&tmp);
> > +	if (ret)
> > +		goto exit;
> > +	if (multi == 64)
> > +		ret = fc0013_writereg(priv, 0x11, tmp | 0x04);
> > +	else
> > +		ret = fc0013_writereg(priv, 0x11, tmp&  0xfb);
> > +	if (ret)
> > +		goto exit;
> > +
> > +	/* VCO Calibration */
> > +	ret = fc0013_writereg(priv, 0x0e, 0x80);
> > +	if (!ret)
> > +		ret = fc0013_writereg(priv, 0x0e, 0x00);
> > +
> > +	/* VCO Re-Calibration if needed */
> > +	if (!ret)
> > +		ret = fc0013_writereg(priv, 0x0e, 0x00);
> > +
> > +	if (!ret) {
> > +		msleep(10);
> > +		ret = fc0013_readreg(priv, 0x0e,&tmp);
> > +	}
> > +	if (ret)
> > +		goto exit;
> > +
> > +	/* vco selection */
> > +	tmp&= 0x3f;
> > +
> > +	if (vco_select) {
> > +		if (tmp>  0x3c) {
> > +			reg[6]&= ~0x08;
> > +			ret = fc0013_writereg(priv, 0x06, reg[6]);
> > +			if (!ret)
> > +				ret = fc0013_writereg(priv, 0x0e, 0x80);
> > +			if (!ret)
> > +				ret = fc0013_writereg(priv, 0x0e, 0x00);
> > +		}
> > +	} else {
> > +		if (tmp<  0x02) {
> > +			reg[6] |= 0x08;
> > +			ret = fc0013_writereg(priv, 0x06, reg[6]);
> > +			if (!ret)
> > +				ret = fc0013_writereg(priv, 0x0e, 0x80);
> > +			if (!ret)
> > +				ret = fc0013_writereg(priv, 0x0e, 0x00);
> > +		}
> > +	}
> > +
> > +	priv->frequency = p->frequency;
> > +	priv->bandwidth = p->bandwidth_hz;
> > +
> > +exit:
> > +	if (fe->ops.i2c_gate_ctrl)
> > +		fe->ops.i2c_gate_ctrl(fe, 0); /* close I2C-gate */
> > +	return ret;
> > +}
> > +
> > +static int fc0013_get_frequency(struct dvb_frontend *fe, u32 *frequency)
> > +{
> > +	struct fc0013_priv *priv = fe->tuner_priv;
> > +	*frequency = priv->frequency;
> > +	return 0;
> > +}
> > +
> > +static int fc0013_get_if_frequency(struct dvb_frontend *fe, u32
> > *frequency) +{
> > +	/* always ? */
> > +	*frequency = 0;
> > +	return 0;
> > +}
> > +
> > +static int fc0013_get_bandwidth(struct dvb_frontend *fe, u32 *bandwidth)
> > +{
> > +	struct fc0013_priv *priv = fe->tuner_priv;
> > +	*bandwidth = priv->bandwidth;
> > +	return 0;
> > +}
> > +
> > +
> > +static const struct dvb_tuner_ops fc0013_tuner_ops = {
> > +	.info = {
> > +		.name		= "Fitipower FC0013",
> > +
> > +		.frequency_min	= 37000000,	/* estimate */
> > +		.frequency_max	= 1680000000,	/* CHECK */
> > +		.frequency_step	= 0,
> > +	},
> > +
> > +	.release	= fc0013_release,
> > +
> > +	.init		= fc0013_init,
> > +	.sleep		= fc0013_sleep,
> > +
> > +	.set_params	= fc0013_set_params,
> > +
> > +	.get_frequency	= fc0013_get_frequency,
> > +	.get_if_frequency = fc0013_get_if_frequency,
> > +	.get_bandwidth	= fc0013_get_bandwidth,
> > +};
> > +
> > +struct dvb_frontend *fc0013_attach(struct dvb_frontend *fe,
> > +	struct i2c_adapter *i2c, u8 i2c_address, int dual_master,
> > +	enum fc001x_xtal_freq xtal_freq)
> > +{
> > +	struct fc0013_priv *priv = NULL;
> > +
> > +	priv = kzalloc(sizeof(struct fc0013_priv), GFP_KERNEL);
> > +	if (priv == NULL)
> > +		return NULL;
> > +
> > +	priv->i2c = i2c;
> > +	priv->dual_master = dual_master;
> > +	priv->addr = i2c_address;
> > +	priv->xtal_freq = xtal_freq;
> > +
> > +	info("Fitipower FC0013 successfully attached.");
> > +
> > +	fe->tuner_priv = priv;
> > +
> > +	memcpy(&fe->ops.tuner_ops,&fc0013_tuner_ops,
> > +		sizeof(struct dvb_tuner_ops));
> > +
> > +	return fe;
> > +}
> > +EXPORT_SYMBOL(fc0013_attach);
> > +
> > +MODULE_DESCRIPTION("Fitipower FC0013 silicon tuner driver");
> > +MODULE_AUTHOR("Hans-Frieder Vogt<hfvogt@gmx.net>");
> > +MODULE_LICENSE("GPL");
> > +MODULE_VERSION("0.1");
> > diff -up --new-file --recursive a/drivers/media/common/tuners/fc0013.h
> > b/drivers/media/common/tuners/fc0013.h ---
> > a/drivers/media/common/tuners/fc0013.h	1970-01-01 01:00:00.000000000
> > +0100 +++ b/drivers/media/common/tuners/fc0013.h	2012-05-06
> > 19:40:48.162715247 +0200 @@ -0,0 +1,57 @@
> > +/*
> > + * Fitipower FC0013 tuner driver
> > + *
> > + * Copyright (C) 2012 Hans-Frieder Vogt<hfvogt@gmx.net>
> > + *
> > + *    This program is free software; you can redistribute it and/or
> > modify + *    it under the terms of the GNU General Public License as
> > published by + *    the Free Software Foundation; either version 2 of
> > the License, or + *    (at your option) any later version.
> > + *
> > + *    This program is distributed in the hope that it will be useful,
> > + *    but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + *    GNU General Public License for more details.
> > + *
> > + *    You should have received a copy of the GNU General Public License
> > + *    along with this program; if not, write to the Free Software
> > + *    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> > + *
> > + */
> > +
> > +#ifndef _FC0013_H_
> > +#define _FC0013_H_
> > +
> > +#include "dvb_frontend.h"
> > +#include "fc001x-common.h"
> > +
> > +#if defined(CONFIG_MEDIA_TUNER_FC0013) || \
> > +	(defined(CONFIG_MEDIA_TUNER_FC0013_MODULE)&&  defined(MODULE))
> > +extern struct dvb_frontend *fc0013_attach(struct dvb_frontend *fe,
> > +					struct i2c_adapter *i2c,
> > +					u8 i2c_address, int dual_master,
> > +					enum fc001x_xtal_freq xtal_freq);
> > +extern int fc0013_rc_cal_add(struct dvb_frontend *fe, int rc_val);
> > +extern int fc0013_rc_cal_reset(struct dvb_frontend *fe);
> > +#else
> > +static inline struct dvb_frontend *fc0013_attach(struct dvb_frontend
> > *fe, +					struct i2c_adapter *i2c,
> > +					u8 i2c_address, int dual_master,
> > +					enum fc001x_xtal_freq xtal_freq)
> > +{
> > +	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
> > +	return NULL;
> > +}
> > +
> > +static inline int fc0013_rc_cal_add(struct dvb_frontend *fe, int rc_val)
> > +{
> > +	return 0;
> > +}
> > +
> > +static inline int fc0013_rc_cal_reset(struct dvb_frontend *fe)
> > +{
> > +	return 0;
> > +}
> > +#endif
> > +
> > +#endif
> > diff -up --new-file --recursive
> > a/drivers/media/common/tuners/fc0013-priv.h
> > b/drivers/media/common/tuners/fc0013- priv.h
> > --- a/drivers/media/common/tuners/fc0013-priv.h	1970-01-01
> > 01:00:00.000000000 +0100 +++
> > b/drivers/media/common/tuners/fc0013-priv.h	2012-05-06
> > 19:33:20.420412665 +0200 @@ -0,0 +1,44 @@
> > +/*
> > + * Fitipower FC0013 tuner driver
> > + *
> > + * Copyright (C) 2012 Hans-Frieder Vogt<hfvogt@gmx.net>
> > + *
> > + *    This program is free software; you can redistribute it and/or
> > modify + *    it under the terms of the GNU General Public License as
> > published by + *    the Free Software Foundation; either version 2 of
> > the License, or + *    (at your option) any later version.
> > + *
> > + *    This program is distributed in the hope that it will be useful,
> > + *    but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + *    GNU General Public License for more details.
> > + *
> > + *    You should have received a copy of the GNU General Public License
> > + *    along with this program; if not, write to the Free Software
> > + *    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> > + *
> > + */
> > +
> > +#ifndef _FC0013_PRIV_H_
> > +#define _FC0013_PRIV_H_
> > +
> > +#define LOG_PREFIX "fc0013"
> > +
> > +#undef err
> > +#define err(f, arg...)  printk(KERN_ERR     LOG_PREFIX": " f "\n" , ##
> > arg) +#undef info
> > +#define info(f, arg...) printk(KERN_INFO    LOG_PREFIX": " f "\n" , ##
> > arg) +#undef warn
> > +#define warn(f, arg...) printk(KERN_WARNING LOG_PREFIX": " f "\n" , ##
> > arg) +
> > +struct fc0013_priv {
> > +	struct i2c_adapter *i2c;
> > +	u8 addr;
> > +	u8 dual_master;
> > +	u8 xtal_freq;
> > +
> > +	u32 frequency;
> > +	u32 bandwidth;
> > +};
> > +
> > +#endif
> > 
> > Hans-Frieder Vogt                       e-mail: hfvogt<at>  gmx .dot. net
> 
> + the same comments as for the FC0012.
> 
> These two, FC0012 and FC0013, seems to contains a lot of same code. IIRC
> FC0011 was also very similar. I wonder if all these tuner can be
> supported by one driver.
> As listed vendor page it looks like FC0011 < FC0012 < FC0013:
> http://www.fiticomm.com/products.html
> 
good point! I am well aware of the similarities, but felt it would be clearer 
to keep them separate. Since the registers of the fc0013 are no simple 
superset of the fc0012, we would need a lot of ifs and thens. That wouldn't be 
easy to read, and even more difficult to debug.

What would you think about an option where we have fc0012/fc0013 in one driver 
with different .._attach functions using different ..._tuner_ops diverting into 
special functions for fc0012 and fc0013?

With regards to the fc0011: I don't have access to a device with that tuner, 
but I can make a try...

> FC0014 seems to be rather much feature rich compared to these older ones
> and thus I suspect it is totally different design.
> 
> regards
> Antti

thanks very much for your comments. I really appreciate your critical view and 
your determination to create good quality code!

Regards,
Hans-Frieder

Hans-Frieder Vogt                       e-mail: hfvogt <at> gmx .dot. net
