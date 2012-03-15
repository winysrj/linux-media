Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:51289 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761209Ab2COOf6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Mar 2012 10:35:58 -0400
Received: by bkcik5 with SMTP id ik5so2160998bkc.19
        for <linux-media@vger.kernel.org>; Thu, 15 Mar 2012 07:35:56 -0700 (PDT)
Message-ID: <4F61FE49.6010704@gmail.com>
Date: Thu, 15 Mar 2012 15:35:53 +0100
From: poma <pomidorabelisima@gmail.com>
MIME-Version: 1.0
To: Hans-Frieder Vogt <hfvogt@gmx.net>, linux-media@vger.kernel.org
Subject: Re: [PATCH 1/3] Support for tuner FC0012
References: <201202222321.35533.hfvogt@gmx.net>
In-Reply-To: <201202222321.35533.hfvogt@gmx.net>
Content-Type: multipart/mixed;
 boundary="------------020102050209030503080705"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020102050209030503080705
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 02/22/2012 11:21 PM, Hans-Frieder Vogt wrote:
> Support for the tuner Fitipower FC0012
> 
> Signed-off-by: Hans-Frieder Vogt <hfvogt@gmx.net>
> 
> diff -Nupr a/drivers/media/common/tuners/fc0012.c 
> b/drivers/media/common/tuners/fc0012.c
> --- a/drivers/media/common/tuners/fc0012.c	1970-01-01 01:00:00.000000000 +0100
> +++ b/drivers/media/common/tuners/fc0012.c	2012-02-19 17:37:27.364482154 
> +0100
> @@ -0,0 +1,430 @@
> +/*
> + * Fitipower FC0012 tuner driver
> + *
> + * Copyright (C) 2012 Hans-Frieder Vogt <hfvogt@gmx.net>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> + */
> +
> +#include <linux/version.h>
> +#include "fc0012.h"
> +#include "fc0012-priv.h"
> +
> +static int fc0012_debug;
> +module_param_named(debug, fc0012_debug, int, 0644);
> +MODULE_PARM_DESC(debug, "Select debug level (default: debug off)");
> +
> +/* the FC0012 seems to have only byte access to the registers */
> +static int fc0012_writeregs(struct fc0012_priv *priv, u8 reg, u8 *val, int 
> len)
> +{
> +	u8 buf[1+len];
> +	struct i2c_msg msg = { .addr = priv->addr,
> +		.flags = 0, .buf = buf, .len = sizeof(buf) };
> +
> +	buf[0] = reg;
> +	memcpy(&buf[1], val, len);
> +
> +	msleep(1);
> +	if (i2c_transfer(priv->i2c, &msg, 1) != 1) {
> +		err("I2C write regs failed, reg: %02x, val[0]: %02x",
> +			reg, val[0]);
> +		return -EREMOTEIO;
> +	}
> +	return 0;
> +}
> +
> +static int fc0012_writereg(struct fc0012_priv *priv, u8 reg, u8 val)
> +{
> +	u8 buf[2] = {reg, val};
> +	struct i2c_msg msg = { .addr = priv->addr,
> +		.flags = 0, .buf = buf, .len = 2 };
> +
> +	msleep(1);
> +	if (i2c_transfer(priv->i2c, &msg, 1) != 1) {
> +		err("I2C write reg failed, reg: %02x, val: %02x", reg, val);
> +		return -EREMOTEIO;
> +	}
> +	return 0;
> +}
> +
> +static int fc0012_readreg(struct fc0012_priv *priv, u8 reg, u8 *val)
> +{
> +	struct i2c_msg msg[2] = {
> +		{ .addr = priv->addr,
> +		  .flags = 0, .buf = &reg, .len = 1 },
> +		{ .addr = priv->addr,
> +		  .flags = I2C_M_RD, .buf = val, .len = 1 },
> +	};
> +
> +	if (i2c_transfer(priv->i2c, msg, 2) != 2) {
> +		err("I2C read failed, reg: %02x", reg);
> +		return -EREMOTEIO;
> +	}
> +	return 0;
> +}
> +
> +static int fc0012_release(struct dvb_frontend *fe)
> +{
> +	kfree(fe->tuner_priv);
> +	fe->tuner_priv = NULL;
> +	return 0;
> +}
> +
> +static int fc0012_init(struct dvb_frontend *fe)
> +{
> +	struct fc0012_priv *priv = fe->tuner_priv;
> +	int ret = 0;
> +	u8 i;
> +	unsigned char reg[] = {
> +		0x00,	/* dummy reg. 0 */
> +		0x05,	/* reg. 0x01 */
> +		0x10,	/* reg. 0x02 */
> +		0x00,	/* reg. 0x03 */
> +		0x00,	/* reg. 0x04 */
> +		0x0a,	/* reg. 0x05 CHECK: correct? */
> +		0x00,	/* reg. 0x06: divider 2, VCO slow */ 
> +		0x0f,	/* reg. 0x07 */
> +		0xff,	/* reg. 0x08: AGC Clock divide by 256, AGC gain 1/256, Loop Bw 
> 1/8 */
> +		0x6e,	/* reg. 0x09: Disable LoopThrough */
> +		0xb8,	/* reg. 0x0a: Disable LO Test Buffer */
> +		0x83,	/* reg. 0x0b: Output Clock is same as clock frequency */
> +		0xfe,	/* reg. 0x0c: depending on AGC Up-Down mode, may need 0xf8 */
> +		0x02,	/* reg. 0x0d: AGC Not Forcing & LNA Forcing, 0x02 for DVB-T */
> +		0x00,	/* reg. 0x0e */
> +		0x00,	/* reg. 0x0f */
> +		0x0d,	/* reg. 0x10 */
> +		0x00,	/* reg. 0x11 */
> +		0x1f,	/* reg. 0x12: Set to maximum gain */
> +		0x90,	/* reg. 0x13: Enable IX2, Set to Middle Gain: 0x08, Low Gain: 
> 0x00, High Gain: 0x10 */
> +		0x00,	/* reg. 0x14 */
> +		0x04,	/* reg. 0x15: Enable LNA COMPS */
> +	};
> +
> +	switch (priv->xtal_freq) {
> +	case FC_XTAL_27_MHZ:
> +	case FC_XTAL_28_8_MHZ:
> +		reg[0x07] |= 0x20;
> +		break;
> +	case FC_XTAL_36_MHZ:
> +	default:
> +		break;
> +	}
> +	for (i = 1; i < sizeof(reg); i++) {
> +		ret = fc0012_writereg(priv, i, reg[i]);
> +		if (ret)
> +			break;
> +	}
> +
> +	if (ret)
> +		deb_info("%s: failed:%d\n", __func__, ret);
> +
> +	return ret;
> +}
> +
> +static int fc0012_sleep(struct dvb_frontend *fe)
> +{
> +	/* nothing to do here */
> +	return 0;
> +}
> +
> +#if LINUX_VERSION_CODE >= KERNEL_VERSION(3,3,0)
> +static int fc0012_set_params(struct dvb_frontend *fe)
> +#else
> +static int fc0012_set_params(struct dvb_frontend *fe,
> +        struct dvb_frontend_parameters *params)
> +#endif
> +{
> +        struct fc0012_priv *priv = fe->tuner_priv;
> +        int ret;
> +#if LINUX_VERSION_CODE >= KERNEL_VERSION(3,3,0)
> +	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
> +	u32 freq = p->frequency / 1000;
> +	u32 delsys = p->delivery_system;
> +#else
> +	u32 freq = params->frequency / 1000;
> +	u32 bw = 0;
> +#endif
> +	unsigned char reg[0x16], am, pm, multi;
> +	unsigned long fVCO;
> +	unsigned short xtal_freq_khz_2, xin, xdiv;
> +	int vco_select = false;
> +
> +	switch (priv->xtal_freq) {
> +	case FC_XTAL_27_MHZ:
> +		xtal_freq_khz_2 = 27000 / 2;
> +		break;
> +	case FC_XTAL_36_MHZ:
> +		xtal_freq_khz_2 = 36000 / 2;
> +		break;
> +	case FC_XTAL_28_8_MHZ:
> +	default:
> +		xtal_freq_khz_2 = 28800 / 2;
> +		break;
> +	}
> +
> +	/* select frequency divider and the frequency of VCO */
> +	if (freq * 96 < 3560000) {
> +		multi = 96;
> +		reg[5] = 0x82;
> +		reg[6] = 0x00;
> +	} else if (freq * 64 < 3560000) {
> +		multi = 64;
> +		reg[5] = 0x82;
> +		reg[6] = 0x02;
> +	} else if (freq * 48 < 3560000) {
> +		multi = 48;
> +		reg[5] = 0x42;
> +		reg[6] = 0x00;
> +	} else if (freq * 32 < 3560000) {
> +		multi = 32;
> +		reg[5] = 0x42;
> +		reg[6] = 0x02;
> +	} else if (freq * 24 < 3560000) {
> +		multi = 24;
> +		reg[5] = 0x22;
> +		reg[6] = 0x00;
> +	} else if (freq * 16 < 3560000) {
> +		multi = 16;
> +		reg[5] = 0x22;
> +		reg[6] = 0x02;
> +	} else if (freq * 12 < 3560000) {
> +		multi = 12;
> +		reg[5] = 0x12;
> +		reg[6] = 0x00;
> +	} else if (freq * 8 < 3560000) {
> +		multi = 8;
> +		reg[5] = 0x12;
> +		reg[6] = 0x02;
> +	} else if (freq * 6 < 3560000) {
> +		multi = 6;
> +		reg[5] = 0x0a;
> +		reg[6] = 0x00;
> +	} else {
> +		multi = 4;
> +		reg[5] = 0x0a;
> +		reg[6] = 0x02;
> +	}
> +
> +	fVCO = freq * multi;
> +
> +	if (fVCO >= 3060000) {
> +		reg[6] |= 0x08;
> +		vco_select = true;
> +	}
> +
> +	if (freq >= 45000) {
> +		/* From divided value (XDIV) determined the FA and FP value */
> +		xdiv = (unsigned short)(fVCO / xtal_freq_khz_2);
> +		if ((fVCO - xdiv * xtal_freq_khz_2) >= (xtal_freq_khz_2 / 2))
> +			xdiv++;
> +
> +		pm = (unsigned char)(xdiv / 8);
> +		am = (unsigned char)(xdiv - (8 * pm));
> +
> +		if (am < 2) {
> +			reg[1] = am + 8;
> +			reg[2] = pm - 1;
> +		} else {
> +			reg[1] = am;
> +			reg[2] = pm;
> +		}
> +	} else {
> +		/* fix for frequency less than 45 MHz */
> +		reg[1] = 0x06;
> +		reg[2] = 0x11;
> +	}
> +
> +	/* fix clock out */
> +	reg[6] |= 0x20;
> +
> +	/* From VCO frequency determines the XIN ( fractional part of Delta
> +	   Sigma PLL) and divided value (XDIV) */
> +	xin = (unsigned short)(fVCO - (fVCO / xtal_freq_khz_2) * 
> xtal_freq_khz_2);
> +	xin = (xin << 15) / xtal_freq_khz_2;
> +	if (xin >= 16384)
> +		xin += 32768;
> +
> +	reg[3] = xin >> 8;	/* xin with 9 bit resolution */
> +	reg[4] = xin & 0xff;
> +
> +#if LINUX_VERSION_CODE >= KERNEL_VERSION(3,3,0)
> +	if (delsys == SYS_DVBT) {
> +		reg[6] &= 0x3f;	/* bits 6 and 7 describe the bandwidth */
> +		switch (p->bandwidth_hz) {
> +		case 6000000:
> +			reg[6] |= 0x80;
> +			break;
> +		case 7000000:
> +			reg[6] |= 0x40;
> +			break;
> +		case 8000000:
> +		default:
> +			break;
> +		}
> +#else
> +	if (fe->ops.info.type == FE_OFDM) {
> +		reg[6] &= 0x3f;	/* bits 6 and 7 describe the bandwidth */
> +		switch (params->u.ofdm.bandwidth) {
> +		case BANDWIDTH_6_MHZ:
> +			bw = 6000000;
> +			reg[6] |= 0x80;
> +			break;
> +		case BANDWIDTH_7_MHZ:
> +			bw = 7000000;
> +			reg[6] |= 0x40;
> +			break;
> +		case BANDWIDTH_8_MHZ:
> +		default:
> +			bw = 8000000;
> +			break;
> +		}
> +#endif
> +	} else {
> +		err("%s: modulation type not supported!\n", __func__);
> +		return -EINVAL;
> +	}
> +
> +	/* modified for Realtek demod */
> +	reg[5] |= 0x07;
> +
> +	ret = fc0012_writeregs(priv, 1, &reg[1], 6);
> +	if (ret)
> +		goto error_out;
> +
> +	/* VCO Calibration */
> +	ret = fc0012_writereg(priv, 0x0e, 0x80);
> +	if (!ret)
> +		ret = fc0012_writereg(priv, 0x0e, 0x00);
> +	/* VCO Re-Calibration if needed */
> +	if (!ret)
> +		ret = fc0012_writereg(priv, 0x0e, 0x00);
> +
> +	if (!ret) {
> +		msleep(10);
> +		ret = fc0012_readreg(priv, 0x0e, &reg[0x0e]);
> +	}
> +	if (ret)
> +		goto error_out;
> +
> +	/* vco selection */
> +	reg[0x0e] &= 0x3f;
> +
> +	if (vco_select) {
> +		if (reg[0x0e] > 0x3c) {
> +			reg[6] &= ~0x08;
> +			ret = fc0012_writereg(priv, 0x06, reg[6]);
> +			if (!ret)
> +				ret = fc0012_writereg(priv, 0x0e, 0x80);
> +			if (!ret)
> +				ret = fc0012_writereg(priv, 0x0e, 0x00);
> +		}
> +	} else {
> +		if (reg[0x0e] < 0x02) {
> +			reg[6] |= 0x08;
> +			ret = fc0012_writereg(priv, 0x06, reg[6]);
> +			if (!ret)
> +				ret = fc0012_writereg(priv, 0x0e, 0x80);
> +			if (!ret)
> +				ret = fc0012_writereg(priv, 0x0e, 0x00);
> +		}
> +	}
> +
> +	priv->frequency = freq;
> +#if LINUX_VERSION_CODE >= KERNEL_VERSION(3,3,0)
> +	priv->bandwidth = p->bandwidth_hz;
> +#else
> +	priv->bandwidth = bw;
> +#endif
> +
> +error_out:
> +	return ret;
> +}
> +
> +static int fc0012_get_frequency(struct dvb_frontend *fe, u32 *frequency)
> +{
> +        struct fc0012_priv *priv = fe->tuner_priv;
> +        *frequency = priv->frequency;
> +        return 0;
> +}
> +
> +#ifdef DEFINED_GET_IF_FREQUENCY
> +static int fc0012_get_if_frequency(struct dvb_frontend *fe, u32 *frequency)
> +{
> +	/* CHECK: always ? */
> +        *frequency = 0;
> +        return 0;
> +}
> +#endif
> +
> +static int fc0012_get_bandwidth(struct dvb_frontend *fe, u32 *bandwidth)
> +{
> +        struct fc0012_priv *priv = fe->tuner_priv;
> +        *bandwidth = priv->bandwidth;
> +        return 0;
> +}
> +
> +
> +static const struct dvb_tuner_ops fc0012_tuner_ops = {
> +        .info = {
> +                .name           = "Fitipower FC0012",
> +
> +                .frequency_min  = 170000000,
> +                .frequency_max  = 860000000,
> +                .frequency_step = 0,
> +        },
> +
> +        .release       = fc0012_release,
> +
> +        .init          = fc0012_init,
> +	.sleep         = fc0012_sleep,
> +
> +        .set_params    = fc0012_set_params,
> +
> +        .get_frequency = fc0012_get_frequency,
> +#ifdef DEFINED_GET_IF_FREQUENCY
> +	.get_if_frequency = fc0012_get_if_frequency,
> +#endif
> +	.get_bandwidth = fc0012_get_bandwidth,
> +};
> +
> +struct dvb_frontend * fc0012_attach(struct dvb_frontend *fe,
> +        struct i2c_adapter *i2c, u8 i2c_address,
> +	enum fc0012_xtal_freq xtal_freq)
> +{
> +        struct fc0012_priv *priv = NULL;
> +
> +	priv = kzalloc(sizeof(struct fc0012_priv), GFP_KERNEL);
> +	if (priv == NULL)
> +		return NULL;
> +
> +	priv->i2c = i2c;
> +	priv->addr = i2c_address;
> +	priv->xtal_freq = xtal_freq;
> +
> +	info("Fitipower FC0012 successfully attached.");
> +
> +	fe->tuner_priv = priv;
> +
> +	memcpy(&fe->ops.tuner_ops, &fc0012_tuner_ops,
> +		sizeof(struct dvb_tuner_ops));
> +
> +	return fe;
> +}
> +EXPORT_SYMBOL(fc0012_attach);
> +
> +MODULE_DESCRIPTION("Fitipower FC0012 silicon tuner driver");
> +MODULE_AUTHOR("Hans-Frieder Vogt <hfvogt@gmx.net>");
> +MODULE_LICENSE("GPL");
> +MODULE_VERSION("0.1");
> diff -Nupr a/drivers/media/common/tuners/fc0012.h 
> b/drivers/media/common/tuners/fc0012.h
> --- a/drivers/media/common/tuners/fc0012.h	1970-01-01 01:00:00.000000000 +0100
> +++ b/drivers/media/common/tuners/fc0012.h	2012-02-20 23:02:11.639876934 
> +0100
> @@ -0,0 +1,49 @@
> +/*
> + * Fitipower FC0012 tuner driver - include
> + *
> + * Copyright (C) 2012 Hans-Frieder Vogt <hfvogt@gmx.net>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> + */
> +
> +#ifndef _FC0012_H_
> +#define _FC0012_H_
> +
> +#include "dvb_frontend.h"
> +
> +enum fc0012_xtal_freq {
> +        FC_XTAL_27_MHZ,      /* 27000000 */
> +        FC_XTAL_28_8_MHZ,    /* 28800000 */
> +        FC_XTAL_36_MHZ,      /* 36000000 */
> +};
> +
> +#if defined(CONFIG_MEDIA_TUNER_FC0012) || \
> +        (defined(CONFIG_MEDIA_TUNER_FC0012_MODULE) && defined(MODULE))
> +extern struct dvb_frontend *fc0012_attach(struct dvb_frontend *fe,
> +					struct i2c_adapter *i2c,
> +					u8 i2c_address,
> +					enum fc0012_xtal_freq xtal_freq);
> +#else
> +static inline struct dvb_frontend *fc0012_attach(struct dvb_frontend *fe,
> +						struct i2c_adapter *i2c,
> +						u8 i2c_address,
> +						enum fc0012_xtal_freq xtal_freq)
> +{
> +	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
> +	return NULL;
> +}
> +#endif
> +
> +#endif
> diff -Nupr a/drivers/media/common/tuners/fc0012-priv.h 
> b/drivers/media/common/tuners/fc0012-priv.h
> --- a/drivers/media/common/tuners/fc0012-priv.h	1970-01-01 01:00:00.000000000 
> +0100
> +++ b/drivers/media/common/tuners/fc0012-priv.h	2012-02-19 
> 17:37:46.770986275 +0100
> @@ -0,0 +1,50 @@
> +/*
> + * Fitipower FC0012 tuner driver - private includes
> + *
> + * Copyright (C) 2012 Hans-Frieder Vogt <hfvogt@gmx.net>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> + */
> +
> +#ifndef _FC0012_PRIV_H_
> +#define _FC0012_PRIV_H_
> +
> +#define LOG_PREFIX "fc0012"
> +
> +#define dprintk(var, level, args...) \
> +	do { \
> +		if ((var & level)) \
> +			printk(args); \
> +	} while (0)
> +
> +#define deb_info(args...) dprintk(fc0012_debug, 0x01, args)
> +
> +#undef err
> +#define err(f, arg...)  printk(KERN_ERR     LOG_PREFIX": " f "\n" , ## arg)
> +#undef info
> +#define info(f, arg...) printk(KERN_INFO    LOG_PREFIX": " f "\n" , ## arg)
> +#undef warn
> +#define warn(f, arg...) printk(KERN_WARNING LOG_PREFIX": " f "\n" , ## arg)
> +
> +struct fc0012_priv {
> +        struct i2c_adapter *i2c;
> +	u8 addr;
> +	u8 xtal_freq;
> +
> +        u32 frequency;
> +	u32 bandwidth;
> +};
> +
> +#endif
> diff -Nupr a/drivers/media/common/tuners/Kconfig 
> b/drivers/media/common/tuners/Kconfig
> --- a/drivers/media/common/tuners/Kconfig	2012-01-08 05:45:35.000000000 +0100
> +++ b/drivers/media/common/tuners/Kconfig	2012-02-20 23:04:29.435357491 
> +0100
> @@ -211,4 +211,11 @@ config MEDIA_TUNER_TDA18212
>  	help
>  	  NXP TDA18212 silicon tuner driver.
>  
> +config MEDIA_TUNER_FC0012
> +	tristate "Fitipower FC0012 silicon tuner"
> +	depends on VIDEO_MEDIA && I2C
> +	default m if MEDIA_TUNER_CUSTOMISE
> +	help
> +	  Fitipower FC0012 silicon tuner driver.
> +
>  endmenu
> diff -Nupr a/drivers/media/common/tuners/Makefile 
> b/drivers/media/common/tuners/Makefile
> --- a/drivers/media/common/tuners/Makefile	2012-01-05 05:45:47.000000000 +0100
> +++ b/drivers/media/common/tuners/Makefile	2012-02-20 23:01:14.010487009 
> +0100
> @@ -28,6 +28,7 @@ obj-$(CONFIG_MEDIA_TUNER_MC44S803) += mc
>  obj-$(CONFIG_MEDIA_TUNER_MAX2165) += max2165.o
>  obj-$(CONFIG_MEDIA_TUNER_TDA18218) += tda18218.o
>  obj-$(CONFIG_MEDIA_TUNER_TDA18212) += tda18212.o
> +obj-$(CONFIG_MEDIA_TUNER_FC0012) += fc0012.o
>  
>  ccflags-y += -Idrivers/media/dvb/dvb-core
>  ccflags-y += -Idrivers/media/dvb/frontends
> 
> 
> Hans-Frieder Vogt                       e-mail: hfvogt <at> gmx .dot. net
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Patched git://linuxtv.org/media_build.git with your Fitipower FC0012
tuner driver(fc0012.patch) got here:
..
  CC [M]  /tmp/media_build/v4l/fc0012.o
/tmp/media_build/v4l/tda18212.c:21:0: warning: "pr_fmt" redefined
[enabled by default]
include/linux/printk.h:152:0: note: this is the location of the previous
definition
/tmp/media_build/v4l/fc0012.c:146:16: warning: 'struct
dvb_frontend_parameters' declared inside parameter list [enabled by default]
/tmp/media_build/v4l/fc0012.c:146:16: warning: its scope is only this
definition or declaration, which is probably not what you want [enabled
by default]
/tmp/media_build/v4l/fc0012.c: In function 'fc0012_set_params':
/tmp/media_build/v4l/fc0012.c:156:19: error: dereferencing pointer to
incomplete type
/tmp/media_build/v4l/fc0012.c:279:17: error: dereferencing pointer to
incomplete type
/tmp/media_build/v4l/fc0012.c:280:8: error: 'BANDWIDTH_6_MHZ' undeclared
(first use in this function)
/tmp/media_build/v4l/fc0012.c:280:8: note: each undeclared identifier is
reported only once for each function it appears in
/tmp/media_build/v4l/fc0012.c:284:8: error: 'BANDWIDTH_7_MHZ' undeclared
(first use in this function)
/tmp/media_build/v4l/fc0012.c:288:8: error: 'BANDWIDTH_8_MHZ' undeclared
(first use in this function)
/tmp/media_build/v4l/fc0012.c: At top level:
/tmp/media_build/v4l/fc0012.c:393:9: warning: initialization from
incompatible pointer type [enabled by default]
/tmp/media_build/v4l/fc0012.c:393:9: warning: (near initialization for
'fc0012_tuner_ops.set_params') [enabled by default]
make[3]: *** [/tmp/media_build/v4l/fc0012.o] Error 1
make[3]: *** Waiting for unfinished jobs....
make[2]: *** [_module_/tmp/media_build/v4l] Error 2
make[2]: Leaving directory `/usr/src/kernels/3.2.9-2.fc16.x86_64'
make[1]: *** [default] Error 2
make[1]: Leaving directory `/tmp/media_build/v4l'
make: *** [all] Error 2

rgds,
poma

--------------020102050209030503080705
Content-Type: text/x-patch;
 name="fc0012.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="fc0012.patch"

diff -Nupr a/drivers/media/common/tuners/fc0012.c b/drivers/media/common/tuners/fc0012.c
--- a/drivers/media/common/tuners/fc0012.c	1970-01-01 01:00:00.000000000 +0100
+++ b/drivers/media/common/tuners/fc0012.c	2012-02-19 17:37:27.364482154 +0100
@@ -0,0 +1,430 @@
+/*
+ * Fitipower FC0012 tuner driver
+ *
+ * Copyright (C) 2012 Hans-Frieder Vogt <hfvogt@gmx.net>
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
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/version.h>
+#include "fc0012.h"
+#include "fc0012-priv.h"
+
+static int fc0012_debug;
+module_param_named(debug, fc0012_debug, int, 0644);
+MODULE_PARM_DESC(debug, "Select debug level (default: debug off)");
+
+/* the FC0012 seems to have only byte access to the registers */
+static int fc0012_writeregs(struct fc0012_priv *priv, u8 reg, u8 *val, int len)
+{
+	u8 buf[1+len];
+	struct i2c_msg msg = { .addr = priv->addr,
+		.flags = 0, .buf = buf, .len = sizeof(buf) };
+
+	buf[0] = reg;
+	memcpy(&buf[1], val, len);
+
+	msleep(1);
+	if (i2c_transfer(priv->i2c, &msg, 1) != 1) {
+		err("I2C write regs failed, reg: %02x, val[0]: %02x",
+			reg, val[0]);
+		return -EREMOTEIO;
+	}
+	return 0;
+}
+
+static int fc0012_writereg(struct fc0012_priv *priv, u8 reg, u8 val)
+{
+	u8 buf[2] = {reg, val};
+	struct i2c_msg msg = { .addr = priv->addr,
+		.flags = 0, .buf = buf, .len = 2 };
+
+	msleep(1);
+	if (i2c_transfer(priv->i2c, &msg, 1) != 1) {
+		err("I2C write reg failed, reg: %02x, val: %02x", reg, val);
+		return -EREMOTEIO;
+	}
+	return 0;
+}
+
+static int fc0012_readreg(struct fc0012_priv *priv, u8 reg, u8 *val)
+{
+	struct i2c_msg msg[2] = {
+		{ .addr = priv->addr,
+		  .flags = 0, .buf = &reg, .len = 1 },
+		{ .addr = priv->addr,
+		  .flags = I2C_M_RD, .buf = val, .len = 1 },
+	};
+
+	if (i2c_transfer(priv->i2c, msg, 2) != 2) {
+		err("I2C read failed, reg: %02x", reg);
+		return -EREMOTEIO;
+	}
+	return 0;
+}
+
+static int fc0012_release(struct dvb_frontend *fe)
+{
+	kfree(fe->tuner_priv);
+	fe->tuner_priv = NULL;
+	return 0;
+}
+
+static int fc0012_init(struct dvb_frontend *fe)
+{
+	struct fc0012_priv *priv = fe->tuner_priv;
+	int ret = 0;
+	u8 i;
+	unsigned char reg[] = {
+		0x00,	/* dummy reg. 0 */
+		0x05,	/* reg. 0x01 */
+		0x10,	/* reg. 0x02 */
+		0x00,	/* reg. 0x03 */
+		0x00,	/* reg. 0x04 */
+		0x0a,	/* reg. 0x05 CHECK: correct? */
+		0x00,	/* reg. 0x06: divider 2, VCO slow */ 
+		0x0f,	/* reg. 0x07 */
+		0xff,	/* reg. 0x08: AGC Clock divide by 256, AGC gain 1/256, Loop Bw 1/8 */
+		0x6e,	/* reg. 0x09: Disable LoopThrough */
+		0xb8,	/* reg. 0x0a: Disable LO Test Buffer */
+		0x83,	/* reg. 0x0b: Output Clock is same as clock frequency */
+		0xfe,	/* reg. 0x0c: depending on AGC Up-Down mode, may need 0xf8 */
+		0x02,	/* reg. 0x0d: AGC Not Forcing & LNA Forcing, 0x02 for DVB-T */
+		0x00,	/* reg. 0x0e */
+		0x00,	/* reg. 0x0f */
+		0x0d,	/* reg. 0x10 */
+		0x00,	/* reg. 0x11 */
+		0x1f,	/* reg. 0x12: Set to maximum gain */
+		0x90,	/* reg. 0x13: Enable IX2, Set to Middle Gain: 0x08, Low Gain: 0x00, High Gain: 0x10 */
+		0x00,	/* reg. 0x14 */
+		0x04,	/* reg. 0x15: Enable LNA COMPS */
+	};
+
+	switch (priv->xtal_freq) {
+	case FC_XTAL_27_MHZ:
+	case FC_XTAL_28_8_MHZ:
+		reg[0x07] |= 0x20;
+		break;
+	case FC_XTAL_36_MHZ:
+	default:
+		break;
+	}
+	for (i = 1; i < sizeof(reg); i++) {
+		ret = fc0012_writereg(priv, i, reg[i]);
+		if (ret)
+			break;
+	}
+
+	if (ret)
+		deb_info("%s: failed:%d\n", __func__, ret);
+
+	return ret;
+}
+
+static int fc0012_sleep(struct dvb_frontend *fe)
+{
+	/* nothing to do here */
+	return 0;
+}
+
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(3,3,0)
+static int fc0012_set_params(struct dvb_frontend *fe)
+#else
+static int fc0012_set_params(struct dvb_frontend *fe,
+        struct dvb_frontend_parameters *params)
+#endif
+{
+        struct fc0012_priv *priv = fe->tuner_priv;
+        int ret;
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(3,3,0)
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
+	u32 freq = p->frequency / 1000;
+	u32 delsys = p->delivery_system;
+#else
+	u32 freq = params->frequency / 1000;
+	u32 bw = 0;
+#endif
+	unsigned char reg[0x16], am, pm, multi;
+	unsigned long fVCO;
+	unsigned short xtal_freq_khz_2, xin, xdiv;
+	int vco_select = false;
+
+	switch (priv->xtal_freq) {
+	case FC_XTAL_27_MHZ:
+		xtal_freq_khz_2 = 27000 / 2;
+		break;
+	case FC_XTAL_36_MHZ:
+		xtal_freq_khz_2 = 36000 / 2;
+		break;
+	case FC_XTAL_28_8_MHZ:
+	default:
+		xtal_freq_khz_2 = 28800 / 2;
+		break;
+	}
+
+	/* select frequency divider and the frequency of VCO */
+	if (freq * 96 < 3560000) {
+		multi = 96;
+		reg[5] = 0x82;
+		reg[6] = 0x00;
+	} else if (freq * 64 < 3560000) {
+		multi = 64;
+		reg[5] = 0x82;
+		reg[6] = 0x02;
+	} else if (freq * 48 < 3560000) {
+		multi = 48;
+		reg[5] = 0x42;
+		reg[6] = 0x00;
+	} else if (freq * 32 < 3560000) {
+		multi = 32;
+		reg[5] = 0x42;
+		reg[6] = 0x02;
+	} else if (freq * 24 < 3560000) {
+		multi = 24;
+		reg[5] = 0x22;
+		reg[6] = 0x00;
+	} else if (freq * 16 < 3560000) {
+		multi = 16;
+		reg[5] = 0x22;
+		reg[6] = 0x02;
+	} else if (freq * 12 < 3560000) {
+		multi = 12;
+		reg[5] = 0x12;
+		reg[6] = 0x00;
+	} else if (freq * 8 < 3560000) {
+		multi = 8;
+		reg[5] = 0x12;
+		reg[6] = 0x02;
+	} else if (freq * 6 < 3560000) {
+		multi = 6;
+		reg[5] = 0x0a;
+		reg[6] = 0x00;
+	} else {
+		multi = 4;
+		reg[5] = 0x0a;
+		reg[6] = 0x02;
+	}
+
+	fVCO = freq * multi;
+
+	if (fVCO >= 3060000) {
+		reg[6] |= 0x08;
+		vco_select = true;
+	}
+
+	if (freq >= 45000) {
+		/* From divided value (XDIV) determined the FA and FP value */
+		xdiv = (unsigned short)(fVCO / xtal_freq_khz_2);
+		if ((fVCO - xdiv * xtal_freq_khz_2) >= (xtal_freq_khz_2 / 2))
+			xdiv++;
+
+		pm = (unsigned char)(xdiv / 8);
+		am = (unsigned char)(xdiv - (8 * pm));
+
+		if (am < 2) {
+			reg[1] = am + 8;
+			reg[2] = pm - 1;
+		} else {
+			reg[1] = am;
+			reg[2] = pm;
+		}
+	} else {
+		/* fix for frequency less than 45 MHz */
+		reg[1] = 0x06;
+		reg[2] = 0x11;
+	}
+
+	/* fix clock out */
+	reg[6] |= 0x20;
+
+	/* From VCO frequency determines the XIN ( fractional part of Delta
+	   Sigma PLL) and divided value (XDIV) */
+	xin = (unsigned short)(fVCO - (fVCO / xtal_freq_khz_2) * xtal_freq_khz_2);
+	xin = (xin << 15) / xtal_freq_khz_2;
+	if (xin >= 16384)
+		xin += 32768;
+
+	reg[3] = xin >> 8;	/* xin with 9 bit resolution */
+	reg[4] = xin & 0xff;
+
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(3,3,0)
+	if (delsys == SYS_DVBT) {
+		reg[6] &= 0x3f;	/* bits 6 and 7 describe the bandwidth */
+		switch (p->bandwidth_hz) {
+		case 6000000:
+			reg[6] |= 0x80;
+			break;
+		case 7000000:
+			reg[6] |= 0x40;
+			break;
+		case 8000000:
+		default:
+			break;
+		}
+#else
+	if (fe->ops.info.type == FE_OFDM) {
+		reg[6] &= 0x3f;	/* bits 6 and 7 describe the bandwidth */
+		switch (params->u.ofdm.bandwidth) {
+		case BANDWIDTH_6_MHZ:
+			bw = 6000000;
+			reg[6] |= 0x80;
+			break;
+		case BANDWIDTH_7_MHZ:
+			bw = 7000000;
+			reg[6] |= 0x40;
+			break;
+		case BANDWIDTH_8_MHZ:
+		default:
+			bw = 8000000;
+			break;
+		}
+#endif
+	} else {
+		err("%s: modulation type not supported!\n", __func__);
+		return -EINVAL;
+	}
+
+	/* modified for Realtek demod */
+	reg[5] |= 0x07;
+
+	ret = fc0012_writeregs(priv, 1, &reg[1], 6);
+	if (ret)
+		goto error_out;
+
+	/* VCO Calibration */
+	ret = fc0012_writereg(priv, 0x0e, 0x80);
+	if (!ret)
+		ret = fc0012_writereg(priv, 0x0e, 0x00);
+	/* VCO Re-Calibration if needed */
+	if (!ret)
+		ret = fc0012_writereg(priv, 0x0e, 0x00);
+
+	if (!ret) {
+		msleep(10);
+		ret = fc0012_readreg(priv, 0x0e, &reg[0x0e]);
+	}
+	if (ret)
+		goto error_out;
+
+	/* vco selection */
+	reg[0x0e] &= 0x3f;
+
+	if (vco_select) {
+		if (reg[0x0e] > 0x3c) {
+			reg[6] &= ~0x08;
+			ret = fc0012_writereg(priv, 0x06, reg[6]);
+			if (!ret)
+				ret = fc0012_writereg(priv, 0x0e, 0x80);
+			if (!ret)
+				ret = fc0012_writereg(priv, 0x0e, 0x00);
+		}
+	} else {
+		if (reg[0x0e] < 0x02) {
+			reg[6] |= 0x08;
+			ret = fc0012_writereg(priv, 0x06, reg[6]);
+			if (!ret)
+				ret = fc0012_writereg(priv, 0x0e, 0x80);
+			if (!ret)
+				ret = fc0012_writereg(priv, 0x0e, 0x00);
+		}
+	}
+
+	priv->frequency = freq;
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(3,3,0)
+	priv->bandwidth = p->bandwidth_hz;
+#else
+	priv->bandwidth = bw;
+#endif
+
+error_out:
+	return ret;
+}
+
+static int fc0012_get_frequency(struct dvb_frontend *fe, u32 *frequency)
+{
+        struct fc0012_priv *priv = fe->tuner_priv;
+        *frequency = priv->frequency;
+        return 0;
+}
+
+#ifdef DEFINED_GET_IF_FREQUENCY
+static int fc0012_get_if_frequency(struct dvb_frontend *fe, u32 *frequency)
+{
+	/* CHECK: always ? */
+        *frequency = 0;
+        return 0;
+}
+#endif
+
+static int fc0012_get_bandwidth(struct dvb_frontend *fe, u32 *bandwidth)
+{
+        struct fc0012_priv *priv = fe->tuner_priv;
+        *bandwidth = priv->bandwidth;
+        return 0;
+}
+
+
+static const struct dvb_tuner_ops fc0012_tuner_ops = {
+        .info = {
+                .name           = "Fitipower FC0012",
+
+                .frequency_min  = 170000000,
+                .frequency_max  = 860000000,
+                .frequency_step = 0,
+        },
+
+        .release       = fc0012_release,
+
+        .init          = fc0012_init,
+	.sleep         = fc0012_sleep,
+
+        .set_params    = fc0012_set_params,
+
+        .get_frequency = fc0012_get_frequency,
+#ifdef DEFINED_GET_IF_FREQUENCY
+	.get_if_frequency = fc0012_get_if_frequency,
+#endif
+	.get_bandwidth = fc0012_get_bandwidth,
+};
+
+struct dvb_frontend * fc0012_attach(struct dvb_frontend *fe,
+        struct i2c_adapter *i2c, u8 i2c_address,
+	enum fc0012_xtal_freq xtal_freq)
+{
+        struct fc0012_priv *priv = NULL;
+
+	priv = kzalloc(sizeof(struct fc0012_priv), GFP_KERNEL);
+	if (priv == NULL)
+		return NULL;
+
+	priv->i2c = i2c;
+	priv->addr = i2c_address;
+	priv->xtal_freq = xtal_freq;
+
+	info("Fitipower FC0012 successfully attached.");
+
+	fe->tuner_priv = priv;
+
+	memcpy(&fe->ops.tuner_ops, &fc0012_tuner_ops,
+		sizeof(struct dvb_tuner_ops));
+
+	return fe;
+}
+EXPORT_SYMBOL(fc0012_attach);
+
+MODULE_DESCRIPTION("Fitipower FC0012 silicon tuner driver");
+MODULE_AUTHOR("Hans-Frieder Vogt <hfvogt@gmx.net>");
+MODULE_LICENSE("GPL");
+MODULE_VERSION("0.1");
diff -Nupr a/drivers/media/common/tuners/fc0012.h b/drivers/media/common/tuners/fc0012.h
--- a/drivers/media/common/tuners/fc0012.h	1970-01-01 01:00:00.000000000 +0100
+++ b/drivers/media/common/tuners/fc0012.h	2012-02-20 23:02:11.639876934 +0100
@@ -0,0 +1,49 @@
+/*
+ * Fitipower FC0012 tuner driver - include
+ *
+ * Copyright (C) 2012 Hans-Frieder Vogt <hfvogt@gmx.net>
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
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#ifndef _FC0012_H_
+#define _FC0012_H_
+
+#include "dvb_frontend.h"
+
+enum fc0012_xtal_freq {
+        FC_XTAL_27_MHZ,      /* 27000000 */
+        FC_XTAL_28_8_MHZ,    /* 28800000 */
+        FC_XTAL_36_MHZ,      /* 36000000 */
+};
+
+#if defined(CONFIG_MEDIA_TUNER_FC0012) || \
+        (defined(CONFIG_MEDIA_TUNER_FC0012_MODULE) && defined(MODULE))
+extern struct dvb_frontend *fc0012_attach(struct dvb_frontend *fe,
+					struct i2c_adapter *i2c,
+					u8 i2c_address,
+					enum fc0012_xtal_freq xtal_freq);
+#else
+static inline struct dvb_frontend *fc0012_attach(struct dvb_frontend *fe,
+						struct i2c_adapter *i2c,
+						u8 i2c_address,
+						enum fc0012_xtal_freq xtal_freq)
+{
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
+	return NULL;
+}
+#endif
+
+#endif
diff -Nupr a/drivers/media/common/tuners/fc0012-priv.h b/drivers/media/common/tuners/fc0012-priv.h
--- a/drivers/media/common/tuners/fc0012-priv.h	1970-01-01 01:00:00.000000000 +0100
+++ b/drivers/media/common/tuners/fc0012-priv.h	2012-02-19 17:37:46.770986275 +0100
@@ -0,0 +1,50 @@
+/*
+ * Fitipower FC0012 tuner driver - private includes
+ *
+ * Copyright (C) 2012 Hans-Frieder Vogt <hfvogt@gmx.net>
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
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#ifndef _FC0012_PRIV_H_
+#define _FC0012_PRIV_H_
+
+#define LOG_PREFIX "fc0012"
+
+#define dprintk(var, level, args...) \
+	do { \
+		if ((var & level)) \
+			printk(args); \
+	} while (0)
+
+#define deb_info(args...) dprintk(fc0012_debug, 0x01, args)
+
+#undef err
+#define err(f, arg...)  printk(KERN_ERR     LOG_PREFIX": " f "\n" , ## arg)
+#undef info
+#define info(f, arg...) printk(KERN_INFO    LOG_PREFIX": " f "\n" , ## arg)
+#undef warn
+#define warn(f, arg...) printk(KERN_WARNING LOG_PREFIX": " f "\n" , ## arg)
+
+struct fc0012_priv {
+        struct i2c_adapter *i2c;
+	u8 addr;
+	u8 xtal_freq;
+
+        u32 frequency;
+	u32 bandwidth;
+};
+
+#endif
diff -Nupr a/drivers/media/common/tuners/Kconfig b/drivers/media/common/tuners/Kconfig
--- a/drivers/media/common/tuners/Kconfig	2012-01-08 05:45:35.000000000 +0100
+++ b/drivers/media/common/tuners/Kconfig	2012-02-20 23:04:29.435357491 +0100
@@ -211,4 +211,11 @@ config MEDIA_TUNER_TDA18212
 	help
 	  NXP TDA18212 silicon tuner driver.
 
+config MEDIA_TUNER_FC0012
+	tristate "Fitipower FC0012 silicon tuner"
+	depends on VIDEO_MEDIA && I2C
+	default m if MEDIA_TUNER_CUSTOMISE
+	help
+	  Fitipower FC0012 silicon tuner driver.
+
 endmenu
diff -Nupr a/drivers/media/common/tuners/Makefile b/drivers/media/common/tuners/Makefile
--- a/drivers/media/common/tuners/Makefile	2012-01-05 05:45:47.000000000 +0100
+++ b/drivers/media/common/tuners/Makefile	2012-02-20 23:01:14.010487009 +0100
@@ -28,6 +28,7 @@ obj-$(CONFIG_MEDIA_TUNER_MC44S803) += mc
 obj-$(CONFIG_MEDIA_TUNER_MAX2165) += max2165.o
 obj-$(CONFIG_MEDIA_TUNER_TDA18218) += tda18218.o
 obj-$(CONFIG_MEDIA_TUNER_TDA18212) += tda18212.o
+obj-$(CONFIG_MEDIA_TUNER_FC0012) += fc0012.o
 
 ccflags-y += -I$(srctree)/drivers/media/dvb/dvb-core
 ccflags-y += -I$(srctree)/drivers/media/dvb/frontends


--------------020102050209030503080705--
