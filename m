Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:50520 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246Ab2EAGs5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 May 2012 02:48:57 -0400
Received: by were53 with SMTP id e53so13718wer.19
        for <linux-media@vger.kernel.org>; Mon, 30 Apr 2012 23:48:55 -0700 (PDT)
Message-ID: <4F9F8752.40609@gmail.com>
Date: Tue, 01 May 2012 08:48:50 +0200
From: poma <pomidorabelisima@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: [PATCH v2] add support for DeLOCK-USB-2.0-DVB-T-Receiver-61744
References: <4F9E5D91.30503@gmail.com> <1335800374-22012-2-git-send-email-thomas.mair86@googlemail.com>
In-Reply-To: <1335800374-22012-2-git-send-email-thomas.mair86@googlemail.com>
Content-Type: multipart/mixed;
 boundary="------------080705040103070306060800"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080705040103070306060800
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 04/30/2012 05:39 PM, Thomas Mair wrote:
> Signed-off-by: Thomas Mair <thomas.mair86@googlemail.com>
> ---
>  drivers/media/common/tuners/Kconfig        |    7 +
>  drivers/media/common/tuners/Makefile       |    1 +
>  drivers/media/common/tuners/fc0012-priv.h  |   42 ++
>  drivers/media/common/tuners/fc0012.c       |  384 +++++++++++++
>  drivers/media/common/tuners/fc0012.h       |   60 ++
>  drivers/media/dvb/dvb-usb/Kconfig          |    2 +
>  drivers/media/dvb/dvb-usb/dvb-usb-ids.h    |    2 +
>  drivers/media/dvb/dvb-usb/rtl28xxu.c       |  439 +++++++++++++---
>  drivers/media/dvb/frontends/Kconfig        |    7 +
>  drivers/media/dvb/frontends/Makefile       |    2 +-
>  drivers/media/dvb/frontends/rtl2832.c      |  832 ++++++++++++++++++++++++++++
>  drivers/media/dvb/frontends/rtl2832.h      |  300 ++++++++++
>  drivers/media/dvb/frontends/rtl2832_priv.h |   60 ++
>  13 files changed, 2070 insertions(+), 68 deletions(-)
>  create mode 100644 drivers/media/common/tuners/fc0012-priv.h
>  create mode 100644 drivers/media/common/tuners/fc0012.c
>  create mode 100644 drivers/media/common/tuners/fc0012.h
>  create mode 100644 drivers/media/dvb/frontends/rtl2832.c
>  create mode 100644 drivers/media/dvb/frontends/rtl2832.h
>  create mode 100644 drivers/media/dvb/frontends/rtl2832_priv.h
> 
> diff --git a/drivers/media/common/tuners/Kconfig b/drivers/media/common/tuners/Kconfig
> index 0fd15d9..8518251 100644
> --- a/drivers/media/common/tuners/Kconfig
> +++ b/drivers/media/common/tuners/Kconfig
> @@ -211,6 +211,13 @@ config MEDIA_TUNER_FC0011
>  	help
>  	  Fitipower FC0011 silicon tuner driver.
>  
> +config MEDIA_TUNER_FC0012
> +	tristate "Fitipower FC0012 silicon tuner"
> +	depends on VIDEO_MEDIA && I2C
> +	default m if MEDIA_TUNER_CUSTOMISE
> +	help
> +	  Fitipower FC0012 silicon tuner driver.
> +
>  config MEDIA_TUNER_TDA18212
>  	tristate "NXP TDA18212 silicon tuner"
>  	depends on VIDEO_MEDIA && I2C
> diff --git a/drivers/media/common/tuners/Makefile b/drivers/media/common/tuners/Makefile
> index 64ee06f..f046106 100644
> --- a/drivers/media/common/tuners/Makefile
> +++ b/drivers/media/common/tuners/Makefile
> @@ -30,6 +30,7 @@ obj-$(CONFIG_MEDIA_TUNER_TDA18218) += tda18218.o
>  obj-$(CONFIG_MEDIA_TUNER_TDA18212) += tda18212.o
>  obj-$(CONFIG_MEDIA_TUNER_TUA9001) += tua9001.o
>  obj-$(CONFIG_MEDIA_TUNER_FC0011) += fc0011.o
> +obj-$(CONFIG_MEDIA_TUNER_FC0012) += fc0012.o
>  
>  ccflags-y += -I$(srctree)/drivers/media/dvb/dvb-core
>  ccflags-y += -I$(srctree)/drivers/media/dvb/frontends
> diff --git a/drivers/media/common/tuners/fc0012-priv.h b/drivers/media/common/tuners/fc0012-priv.h
> new file mode 100644
> index 0000000..c2c3c47
> --- /dev/null
> +++ b/drivers/media/common/tuners/fc0012-priv.h
> @@ -0,0 +1,42 @@
> +/*
> + * Fitipower FC0012 tuner driver - private includes
> + *
> + * Copyright (C) 2012 Hans-Frieder Vogt <hfv...@gmx.net>
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
> +#undef err
> +#define err(f, arg...)  printk(KERN_ERR     LOG_PREFIX": " f "\n" , ## arg)
> +#undef info
> +#define info(f, arg...) printk(KERN_INFO    LOG_PREFIX": " f "\n" , ## arg)
> +#undef warn
> +#define warn(f, arg...) printk(KERN_WARNING LOG_PREFIX": " f "\n" , ## arg)
> +
> +struct fc0012_priv {
> +       struct i2c_adapter *i2c;
> +       u8 addr;
> +       u8 xtal_freq;
> +
> +       u32 frequency;
> +       u32 bandwidth;
> +};
> +
> +#endif
> diff --git a/drivers/media/common/tuners/fc0012.c b/drivers/media/common/tuners/fc0012.c
> new file mode 100644
> index 0000000..bb9f008
> --- /dev/null
> +++ b/drivers/media/common/tuners/fc0012.c
> @@ -0,0 +1,384 @@
> +/*
> + * Fitipower FC0012 tuner driver
> + *
> + * Copyright (C) 2012 Hans-Frieder Vogt <hfv...@gmx.net>
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
> +#include "fc0012.h"
> +#include "fc0012-priv.h"
> +
> +static int fc0012_writereg(struct fc0012_priv *priv, u8 reg, u8 val)
> +{
> +	u8 buf[2] = {reg, val};
> +	struct i2c_msg msg = { .addr = priv->addr, .flags = 0, .buf = buf, .len = 2 };
> +
> +	if (i2c_transfer(priv->i2c, &msg, 1) != 1) {
> +		err("I2C write reg failed, reg: %02x, val: %02x", reg, val);
> +	return -EREMOTEIO;
> +	}
> +	return 0;
> +}
> +
> +static int fc0012_readreg(struct fc0012_priv *priv, u8 reg, u8 *val)
> +{
> +	struct i2c_msg msg[2] = {
> +		{ .addr = priv->addr, .flags = 0, .buf = &reg, .len = 1 },
> +		{ .addr = priv->addr, .flags = I2C_M_RD, .buf = val, .len = 1 },
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
> +	int i, ret = 0;
> +	unsigned char reg[] = {
> +		0x00,   /* dummy reg. 0 */
> +		0x05,   /* reg. 0x01 */
> +		0x10,   /* reg. 0x02 */
> +		0x00,   /* reg. 0x03 */
> +		0x00,   /* reg. 0x04 */
> +		0x0f,   /* reg. 0x05 CHECK: correct? */ /* this is 0x0f in RTL (CNR test) */
> +		0x00,   /* reg. 0x06: divider 2, VCO slow */
> +		0x00,   /* reg. 0x07 */ /* this is also different in RTL code */
> +		0xff,   /* reg. 0x08: AGC Clock divide by 256, AGC gain 1/256,
> +			   Loop Bw 1/8 */
> +		0x6e,   /* reg. 0x09: Disable LoopThrough, Enable LoopThrough: 0x6f */
> +		0xb8,   /* reg. 0x0a: Disable LO Test Buffer */
> +		0x82,   /* reg. 0x0b: Output Clock is same as clock frequency */ /* also different in RTL*/
> +		0xfc,   /* reg. 0x0c: depending on AGC Up-Down mode, may need 0xf8 */ /* RTL */
> +		0x02,   /* reg. 0x0d: AGC Not Forcing & LNA Forcing, 0x02 for DVB-T */
> +		0x00,   /* reg. 0x0e */
> +		0x00,   /* reg. 0x0f */
> +		0x00,   /* reg. 0x10 */ /* RTL */
> +		0x00,   /* reg. 0x11 */
> +		0x1f,   /* reg. 0x12: Set to maximum gain */
> +		0x08,   /* reg. 0x13: Enable IX2, Set to Middle Gain: 0x08,
> +			   Low Gain: 0x00, High Gain: 0x10 */
> +		0x00,   /* reg. 0x14 */
> +		0x04,   /* reg. 0x15: Enable LNA COMPS */
> +	};
> +
> +	info("%s", __func__);
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
> +	
> +	if (fe->ops.i2c_gate_ctrl)
> +		fe->ops.i2c_gate_ctrl(fe, 1); /* open I2C-gate */
> +	
> +	for (i = 1; i < sizeof(reg); i++) {
> +		ret = fc0012_writereg(priv, i, reg[i]);
> +	if (ret)
> +		break;
> +	}
> +
> +	if (fe->ops.i2c_gate_ctrl)
> +		fe->ops.i2c_gate_ctrl(fe, 0); /* close I2C-gate */
> +
> +	if (ret)
> +		warn("%s: failed: %d", __func__, ret);
> +	return ret;
> +}
> +
> +static int fc0012_sleep(struct dvb_frontend *fe)
> +{
> +	/* nothing to do here */
> +	return 0;
> +}
> +
> +static int fc0012_set_params(struct dvb_frontend *fe)
> +{
> +	struct fc0012_priv *priv = fe->tuner_priv;
> +	int i, ret = 0;
> +	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
> +	u32 freq = p->frequency / 1000;
> +	u32 delsys = p->delivery_system;
> +	unsigned char reg[0x16], am, pm, multi;
> +	unsigned long fVCO;
> +	unsigned short xtal_freq_khz_2, xin, xdiv;
> +	int vco_select = false;
> +
> +	info("%s", __func__);
> +
> +	if(fe->callback){
> +		ret = fe->callback(priv->i2c, DVB_FRONTEND_COMPONENT_TUNER, FC0012_FE_CALLBACK_UHF_ENABLE, (freq > 300000 ? 0 : 1));
> +		if (ret)
> +			goto exit;
> +	}
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
> +	reg[6] |= 0x08;
> +	vco_select = true;
> +
> +	/* From divided value (XDIV) determined the FA and FP value */
> +	xdiv = (unsigned short)(fVCO / xtal_freq_khz_2);
> +	if ((fVCO - xdiv * xtal_freq_khz_2) >= (xtal_freq_khz_2 / 2))
> +		xdiv++;
> +	
> +	pm = (unsigned char)(xdiv / 8);
> +	am = (unsigned char)(xdiv - (8 * pm));
> +	
> +	if (am < 2) {
> +		reg[1] = am + 8;
> +		reg[2] = pm - 1;
> +	} else {
> +		reg[1] = am;
> +		reg[2] = pm;
> +	}
> +
> +
> +	/* From VCO frequency determines the XIN ( fractional part of Delta
> +	Sigma PLL) and divided value (XDIV) */
> + 	xin = (unsigned short)(fVCO - (fVCO / xtal_freq_khz_2) * xtal_freq_khz_2);
> +	xin = (xin << 15) / xtal_freq_khz_2;
> +	if (xin >= 16384)
> +		xin += 32768;
> +
> +	reg[3] = xin >> 8;      /* xin with 9 bit resolution */
> +	reg[4] = xin & 0xff;
> +
> +	if (delsys == SYS_DVBT) {
> +		reg[6] &= 0x3f; /* bits 6 and 7 describe the bandwidth */
> +		switch (p->bandwidth_hz) {
> +		case 6000000:
> +			reg[6] |= 0x80;
> +			break;
> +		case 7000000:
> +			reg[6] &= ~0x80;
> +			reg[6] |= 0x40;
> +			break;
> +		case 8000000:
> +		default:
> +			reg[6] &= ~0xc0;
> +			break;
> +	}
> +	} else {
> +		err("%s: modulation type not supported!", __func__);
> +		return -EINVAL;
> +	}
> +
> +	/* modified for Realtek demod */
> +	reg[5] |= 0x07;
> +
> +	if (fe->ops.i2c_gate_ctrl)
> +		fe->ops.i2c_gate_ctrl(fe, 1); /* open I2C-gate */
> +
> +	for (i = 1; i <= 6; i++) {
> +		ret = fc0012_writereg(priv, i, reg[i]);
> +		if (ret)
> +			goto exit;
> +       }
> +
> +	/* VCO Calibration */
> +	ret = fc0012_writereg(priv, 0x0e, 0x80);
> +	if (!ret)
> +		ret = fc0012_writereg(priv, 0x0e, 0x00);
> +
> +	/* VCO Re-Calibration if needed */
> +	if (!ret)
> +		ret = fc0012_writereg(priv, 0x0e, 0x00);
> +
> +	if (!ret) {
> +		msleep(10);
> +		ret = fc0012_readreg(priv, 0x0e, &reg[0x0e]);
> +	}
> +	if (ret)
> +		goto exit;
> +
> +	/* vco selection */
> +	reg[0x0e] &= 0x3f;
> +
> +	if (vco_select) {
> +		if (reg[0x0e] > 0x3c) {
> +		reg[6] &= ~0x08;
> +			ret = fc0012_writereg(priv, 0x06, reg[6]);
> +		if (!ret)
> +			ret = fc0012_writereg(priv, 0x0e, 0x80);
> +		if (!ret)
> +			ret = fc0012_writereg(priv, 0x0e, 0x00);
> +	       }
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
> +	priv->frequency = p->frequency;
> +	priv->bandwidth = p->bandwidth_hz;
> +
> +exit:
> +	if (fe->ops.i2c_gate_ctrl)
> +		fe->ops.i2c_gate_ctrl(fe, 0); /* close I2C-gate */
> +	if (ret)
> +		pr_debug("%s: failed: %d", __func__, ret);
> +	return ret;
> +}
> +
> +static int fc0012_get_frequency(struct dvb_frontend *fe, u32 *frequency)
> +{
> +       struct fc0012_priv *priv = fe->tuner_priv;
> +       *frequency = priv->frequency;
> +       return 0;
> +}
> +
> +static int fc0012_get_if_frequency(struct dvb_frontend *fe, u32 *frequency)
> +{
> +       /* CHECK: always ? */
> +       *frequency = 0;
> +       return 0;
> +}
> +
> +static int fc0012_get_bandwidth(struct dvb_frontend *fe, u32 *bandwidth)
> +{
> +       struct fc0012_priv *priv = fe->tuner_priv;
> +       *bandwidth = priv->bandwidth;
> +       return 0;
> +}
> +
> +
> +static const struct dvb_tuner_ops fc0012_tuner_ops = {
> +       .info = {
> +	       .name		= "Fitipower FC0012",
> +
> +	       .frequency_min	= 170000000,
> +	       .frequency_max	= 860000000,
> +	       .frequency_step	= 0,
> +       },
> +
> +       .release	= fc0012_release,
> +
> +       .init = fc0012_init,
> +       .sleep = fc0012_sleep,
> +
> +       .set_params = fc0012_set_params,
> +
> +       .get_frequency = fc0012_get_frequency,
> +       .get_if_frequency = fc0012_get_if_frequency,
> +       .get_bandwidth = fc0012_get_bandwidth,
> +};
> +
> +struct dvb_frontend * fc0012_attach(struct dvb_frontend *fe,
> +       struct i2c_adapter *i2c, u8 i2c_address,
> +       enum fc0012_xtal_freq xtal_freq)
> +{
> +       struct fc0012_priv *priv = NULL;
> +
> +       priv = kzalloc(sizeof(struct fc0012_priv), GFP_KERNEL);
> +       if (priv == NULL)
> +	       return NULL;
> +
> +       priv->i2c = i2c;
> +       priv->addr = i2c_address;
> +       priv->xtal_freq = xtal_freq;
> +
> +       info("Fitipower FC0012 successfully attached.");
> +
> +       fe->tuner_priv = priv;
> +
> +       memcpy(&fe->ops.tuner_ops, &fc0012_tuner_ops,
> +	       sizeof(struct dvb_tuner_ops));
> +
> +       return fe;
> +}
> +EXPORT_SYMBOL(fc0012_attach);
> +
> +MODULE_DESCRIPTION("Fitipower FC0012 silicon tuner driver");
> +MODULE_AUTHOR("Hans-Frieder Vogt <hfv...@gmx.net>");
> +MODULE_LICENSE("GPL");
> +MODULE_VERSION("0.4");
> diff --git a/drivers/media/common/tuners/fc0012.h b/drivers/media/common/tuners/fc0012.h
> new file mode 100644
> index 0000000..1406e58
> --- /dev/null
> +++ b/drivers/media/common/tuners/fc0012.h
> @@ -0,0 +1,60 @@
> +/*
> + * Fitipower FC0012 tuner driver - include
> + *
> + * Copyright (C) 2012 Hans-Frieder Vogt <hfv...@gmx.net>
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
> +       FC_XTAL_27_MHZ,         /* 27000000 */
> +       FC_XTAL_28_8_MHZ,       /* 28800000 */
> +       FC_XTAL_36_MHZ,         /* 36000000 */
> +};
> +
> +
> +/** enum fc0011_fe_callback_commands - Frontend callbacks
> + *
> + * @FC0012_FE_CALLBACK_VHF_ENABLE: enable VHF or UHF
> + */
> +enum fc0012_fe_callback_commands {
> +	FC0012_FE_CALLBACK_UHF_ENABLE,
> +};
> +
> +#define CONFIG_MEDIA_TUNER_FC0012
> +
> +#if defined(CONFIG_MEDIA_TUNER_FC0012) || \
> +        (defined(CONFIG_MEDIA_TUNER_FC0012_MODULE) && defined(MODULE))
> +extern struct dvb_frontend *fc0012_attach(struct dvb_frontend *fe,
> +                                       struct i2c_adapter *i2c,
> +                                       u8 i2c_address,
> +                                       enum fc0012_xtal_freq xtal_freq);
> +#else
> +static inline struct dvb_frontend *fc0012_attach(struct dvb_frontend *fe,
> +                                               struct i2c_adapter *i2c,
> +                                               u8 i2c_address,
> +                                               enum fc0012_xtal_freq xtal_freq)
> +{
> +       printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
> +       return NULL;
> +}
> +#endif
> +
> +#endif
> diff --git a/drivers/media/dvb/dvb-usb/Kconfig b/drivers/media/dvb/dvb-usb/Kconfig
> index be1db75..a24bbc1 100644
> --- a/drivers/media/dvb/dvb-usb/Kconfig
> +++ b/drivers/media/dvb/dvb-usb/Kconfig
> @@ -417,9 +417,11 @@ config DVB_USB_RTL28XXU
>  	tristate "Realtek RTL28xxU DVB USB support"
>  	depends on DVB_USB && EXPERIMENTAL
>  	select DVB_RTL2830
> +	select DVB_RTL2832
>  	select MEDIA_TUNER_QT1010 if !MEDIA_TUNER_CUSTOMISE
>  	select MEDIA_TUNER_MT2060 if !MEDIA_TUNER_CUSTOMISE
>  	select MEDIA_TUNER_MXL5005S if !MEDIA_TUNER_CUSTOMISE
> +	select MEDIA_TUNER_FC0012 if !MEDIA_TUNER_CUSTOMISE
>  	help
>  	  Say Y here to support the Realtek RTL28xxU DVB USB receiver.
>  
> diff --git a/drivers/media/dvb/dvb-usb/dvb-usb-ids.h b/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
> index 2418e41..1ffee60 100644
> --- a/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
> +++ b/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
> @@ -135,6 +135,7 @@
>  #define USB_PID_GENIUS_TVGO_DVB_T03			0x4012
>  #define USB_PID_GRANDTEC_DVBT_USB_COLD			0x0fa0
>  #define USB_PID_GRANDTEC_DVBT_USB_WARM			0x0fa1
> +#define USB_PID_GTEK					0xb803
>  #define USB_PID_INTEL_CE9500				0x9500
>  #define USB_PID_ITETECH_IT9135				0x9135
>  #define USB_PID_ITETECH_IT9135_9005			0x9005
> @@ -238,6 +239,7 @@
>  #define USB_PID_TERRATEC_CINERGY_T_EXPRESS		0x0062
>  #define USB_PID_TERRATEC_CINERGY_T_XXS			0x0078
>  #define USB_PID_TERRATEC_CINERGY_T_XXS_2		0x00ab
> +#define USB_PID_TERRATEC_CINERGY_T_STICK_BLACK		0x00a9
>  #define USB_PID_TERRATEC_H7				0x10b4
>  #define USB_PID_TERRATEC_H7_2				0x10a3
>  #define USB_PID_TERRATEC_T3				0x10a0
> diff --git a/drivers/media/dvb/dvb-usb/rtl28xxu.c b/drivers/media/dvb/dvb-usb/rtl28xxu.c
> index 8f4736a..1999c17 100644
> --- a/drivers/media/dvb/dvb-usb/rtl28xxu.c
> +++ b/drivers/media/dvb/dvb-usb/rtl28xxu.c
> @@ -3,6 +3,7 @@
>   *
>   * Copyright (C) 2009 Antti Palosaari <crope@iki.fi>
>   * Copyright (C) 2011 Antti Palosaari <crope@iki.fi>
> + * Copyright (C) 2012 Thomas Mair <thomas.mair86@googlemail.com>
>   *
>   *    This program is free software; you can redistribute it and/or modify
>   *    it under the terms of the GNU General Public License as published by
> @@ -22,10 +23,12 @@
>  #include "rtl28xxu.h"
>  
>  #include "rtl2830.h"
> +#include "rtl2832.h"
>  
>  #include "qt1010.h"
>  #include "mt2060.h"
>  #include "mxl5005s.h"
> +#include "fc0012.h"
>  
>  /* debug */
>  static int dvb_usb_rtl28xxu_debug;
> @@ -76,7 +79,7 @@ static int rtl28xxu_ctrl_msg(struct dvb_usb_device *d, struct rtl28xxu_req *req)
>  
>  	return ret;
>  err:
> -	deb_info("%s: failed=%d\n", __func__, ret);
> +	deb_info("%s: failed=%d", __func__, ret);
>  	return ret;
>  }
>  
> @@ -297,7 +300,7 @@ static int rtl2831u_frontend_attach(struct dvb_usb_adapter *adap)
>  	/* for QT1010 tuner probe */
>  	struct rtl28xxu_req req_qt1010 = { 0x0fc4, CMD_I2C_RD, 1, buf };
>  
> -	deb_info("%s:\n", __func__);
> +	deb_info("%s:", __func__);
>  
>  	/*
>  	 * RTL2831U GPIOs
> @@ -312,6 +315,7 @@ static int rtl2831u_frontend_attach(struct dvb_usb_adapter *adap)
>  	if (ret)
>  		goto err;
>  
> +
>  	/* enable as output GPIO0, GPIO2, GPIO4 */
>  	ret = rtl2831_wr_reg(adap->dev, SYS_GPIO_OUT_EN, 0x15);
>  	if (ret)
> @@ -332,10 +336,10 @@ static int rtl2831u_frontend_attach(struct dvb_usb_adapter *adap)
>  	if (ret == 0 && buf[0] == 0x2c) {
>  		priv->tuner = TUNER_RTL2830_QT1010;
>  		rtl2830_config = &rtl28xxu_rtl2830_qt1010_config;
> -		deb_info("%s: QT1010\n", __func__);
> +		deb_info("%s: QT1010", __func__);
>  		goto found;
>  	} else {
> -		deb_info("%s: QT1010 probe failed=%d - %02x\n",
> +		deb_info("%s: QT1010 probe failed=%d - %02x",
>  			__func__, ret, buf[0]);
>  	}
>  
> @@ -349,10 +353,10 @@ static int rtl2831u_frontend_attach(struct dvb_usb_adapter *adap)
>  	if (ret == 0 && buf[0] == 0x63) {
>  		priv->tuner = TUNER_RTL2830_MT2060;
>  		rtl2830_config = &rtl28xxu_rtl2830_mt2060_config;
> -		deb_info("%s: MT2060\n", __func__);
> +		deb_info("%s: MT2060", __func__);
>  		goto found;
>  	} else {
> -		deb_info("%s: MT2060 probe failed=%d - %02x\n",
> +		deb_info("%s: MT2060 probe failed=%d - %02x",
>  			__func__, ret, buf[0]);
>  	}
>  
> @@ -360,7 +364,7 @@ static int rtl2831u_frontend_attach(struct dvb_usb_adapter *adap)
>  	ret = 0;
>  	priv->tuner = TUNER_RTL2830_MXL5005S;
>  	rtl2830_config = &rtl28xxu_rtl2830_mxl5005s_config;
> -	deb_info("%s: MXL5005S\n", __func__);
> +	deb_info("%s: MXL5005S", __func__);
>  	goto found;
>  
>  found:
> @@ -374,37 +378,130 @@ found:
>  
>  	return ret;
>  err:
> -	deb_info("%s: failed=%d\n", __func__, ret);
> +	deb_info("%s: failed=%d", __func__, ret);
>  	return ret;
>  }
>  
> +static struct rtl2832_config rtl28xxu_rtl2832_fc0012_config = {
> +	.i2c_addr = 0x10, /* 0x20 */
> +	.xtal = 28800000,
> +	.ts_mode = 0,
> +	.spec_inv = 1,
> +	.if_dvbt = 0,
> +	.vtop = 0x20,
> +	.krf = 0x04,
> +	.agc_targ_val = 0x2d,
> +	.tuner = TUNER_RTL2832_FC0012
> +};
> +
> +
> +static int rtl2832u_fc0012_tuner_callback(struct dvb_usb_device *d,
> +		int cmd, int arg)
> +{
> +	int ret;
> +	u8 val;
> +
> +	info("%s cmd=%d arg=%d", __func__, cmd, arg);
> +	switch (cmd) {
> +	case FC0012_FE_CALLBACK_UHF_ENABLE:
> +		/* set output values */
> +
> +		ret = rtl2831_rd_reg(d, SYS_GPIO_DIR, &val);
> +		if (ret)
> +			goto err;
> +
> +		val &= 0xbf;
> +
> +		ret = rtl2831_wr_reg(d, SYS_GPIO_DIR, val);
> +		if (ret)
> +			goto err;
> +
> +
> +		ret = rtl2831_rd_reg(d, SYS_GPIO_OUT_EN, &val);
> +		if (ret)
> +			goto err;
> +
> +		val |= 0x40;
> +
> +		ret = rtl2831_wr_reg(d, SYS_GPIO_OUT_EN, val);
> +		if (ret)
> +			goto err;
> +
> +
> +		ret = rtl2831_rd_reg(d, SYS_GPIO_OUT_VAL, &val);
> +		if (ret)
> +			goto err;
> +
> +		if (arg)
> +			val &= 0xbf; /* set GPIO6 low */
> +		else
> +			val |= 0x40; /* set GPIO6 high */
> +		
> +
> +		ret = rtl2831_wr_reg(d, SYS_GPIO_OUT_VAL, val);
> +		if (ret)
> +			goto err;
> +		break;
> +	default:
> +		ret = -EINVAL;
> +		goto err;
> +	}
> +	return 0;
> +
> +err:
> +	err("%s: failed=%d", __func__, ret);
> +
> +	return ret;
> +}
> +
> +static int rtl2832u_tuner_callback(struct dvb_usb_device *d, int cmd, int arg)
> +{
> +	struct rtl28xxu_priv *priv = d->priv;
> +
> +	switch (priv->tuner) {
> +	case TUNER_RTL2832_FC0012:
> +		return rtl2832u_fc0012_tuner_callback(d, cmd, arg);
> +	default:
> +		break;
> +	}
> +
> +	return -ENODEV;
> +}
> +
> +static int rtl2832u_frontend_callback(void *adapter_priv, int component,
> +				    int cmd, int arg)
> +{
> +	struct i2c_adapter *adap = adapter_priv;
> +	struct dvb_usb_device *d = i2c_get_adapdata(adap);
> +
> +	switch (component) {
> +	case DVB_FRONTEND_COMPONENT_TUNER:
> +		return rtl2832u_tuner_callback(d, cmd, arg);
> +	default:
> +		break;
> +	}
> +
> +	return -EINVAL;
> +}
> +
> +
> +
> +
>  static int rtl2832u_frontend_attach(struct dvb_usb_adapter *adap)
>  {
>  	int ret;
>  	struct rtl28xxu_priv *priv = adap->dev->priv;
> +	struct rtl2832_config *rtl2832_config;
> +
>  	u8 buf[1];
>  	/* open RTL2832U/RTL2832 I2C gate */
>  	struct rtl28xxu_req req_gate_open = {0x0120, 0x0011, 0x0001, "\x18"};
>  	/* close RTL2832U/RTL2832 I2C gate */
>  	struct rtl28xxu_req req_gate_close = {0x0120, 0x0011, 0x0001, "\x10"};
> -	/* for FC2580 tuner probe */
> -	struct rtl28xxu_req req_fc2580 = {0x01ac, CMD_I2C_RD, 1, buf};
> -
> -	deb_info("%s:\n", __func__);
> -
> -	/* GPIO direction */
> -	ret = rtl2831_wr_reg(adap->dev, SYS_GPIO_DIR, 0x0a);
> -	if (ret)
> -		goto err;
> +	/* for FC0012 tuner probe */
> +	struct rtl28xxu_req req_fc0012 = {0x00c6, CMD_I2C_RD, 1, buf};
>  
> -	/* enable as output GPIO0, GPIO2, GPIO4 */
> -	ret = rtl2831_wr_reg(adap->dev, SYS_GPIO_OUT_EN, 0x15);
> -	if (ret)
> -		goto err;
> -
> -	ret = rtl2831_wr_reg(adap->dev, SYS_DEMOD_CTL, 0xe8);
> -	if (ret)
> -		goto err;
> +	deb_info("%s:", __func__);
>  
>  	/*
>  	 * Probe used tuner. We need to know used tuner before demod attach
> @@ -416,17 +513,20 @@ static int rtl2832u_frontend_attach(struct dvb_usb_adapter *adap)
>  	if (ret)
>  		goto err;
>  
> -	/* check FC2580 ID register; reg=01 val=56 */
> -	ret = rtl28xxu_ctrl_msg(adap->dev, &req_fc2580);
> -	if (ret == 0 && buf[0] == 0x56) {
> -		priv->tuner = TUNER_RTL2832_FC2580;
> -		deb_info("%s: FC2580\n", __func__);
> +
> +	/* check FC0012 ID register; reg=00 val=a1 */
> +	ret = rtl28xxu_ctrl_msg(adap->dev, &req_fc0012);
> +	if (ret == 0 && buf[0] == 0xa1) {
> +		priv->tuner = TUNER_RTL2832_FC0012;
> +		rtl2832_config = &rtl28xxu_rtl2832_fc0012_config;
> +		deb_info("%s: FC0012", __func__);
>  		goto found;
>  	} else {
> -		deb_info("%s: FC2580 probe failed=%d - %02x\n",
> +		deb_info("%s: FC0012 probe failed=%d - %02x",
>  			__func__, ret, buf[0]);
>  	}
>  
> +
>  	/* close demod I2C gate */
>  	ret = rtl28xxu_ctrl_msg(adap->dev, &req_gate_close);
>  	if (ret)
> @@ -443,11 +543,19 @@ found:
>  		goto err;
>  
>  	/* attach demodulator */
> -	/* TODO: */
> +	adap->fe_adap[0].fe = dvb_attach(rtl2832_attach, rtl2832_config,
> +		&adap->dev->i2c_adap, priv->tuner);
> +		if (adap->fe_adap[0].fe == NULL) {
> +			ret = -ENODEV;
> +			goto err;
> +		}
> +
> +	/* set fe callbacks */
> +	adap->fe_adap[0].fe->callback = rtl2832u_frontend_callback;
>  
>  	return ret;
>  err:
> -	deb_info("%s: failed=%d\n", __func__, ret);
> +	deb_info("%s: failed=%d", __func__, ret);
>  	return ret;
>  }
>  
> @@ -484,7 +592,7 @@ static int rtl2831u_tuner_attach(struct dvb_usb_adapter *adap)
>  	struct i2c_adapter *rtl2830_tuner_i2c;
>  	struct dvb_frontend *fe;
>  
> -	deb_info("%s:\n", __func__);
> +	deb_info("%s:", __func__);
>  
>  	/* use rtl2830 driver I2C adapter, for more info see rtl2830 driver */
>  	rtl2830_tuner_i2c = rtl2830_get_tuner_i2c_adapter(adap->fe_adap[0].fe);
> @@ -515,7 +623,7 @@ static int rtl2831u_tuner_attach(struct dvb_usb_adapter *adap)
>  
>  	return 0;
>  err:
> -	deb_info("%s: failed=%d\n", __func__, ret);
> +	deb_info("%s: failed=%d", __func__, ret);
>  	return ret;
>  }
>  
> @@ -525,12 +633,13 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
>  	struct rtl28xxu_priv *priv = adap->dev->priv;
>  	struct dvb_frontend *fe;
>  
> -	deb_info("%s:\n", __func__);
> +	deb_info("%s:", __func__);
>  
>  	switch (priv->tuner) {
> -	case TUNER_RTL2832_FC2580:
> -		/* TODO: */
> -		fe = NULL;
> +	case TUNER_RTL2832_FC0012:
> +		fe = dvb_attach(fc0012_attach, adap->fe_adap[0].fe,
> +			&adap->dev->i2c_adap, 0xc6>>1, FC_XTAL_28_8_MHZ);
> +		return 0;
>  		break;
>  	default:
>  		fe = NULL;
> @@ -544,16 +653,16 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
>  
>  	return 0;
>  err:
> -	deb_info("%s: failed=%d\n", __func__, ret);
> +	deb_info("%s: failed=%d", __func__, ret);
>  	return ret;
>  }
>  
> -static int rtl28xxu_streaming_ctrl(struct dvb_usb_adapter *adap , int onoff)
> +static int rtl2831u_streaming_ctrl(struct dvb_usb_adapter *adap , int onoff)
>  {
>  	int ret;
>  	u8 buf[2], gpio;
>  
> -	deb_info("%s: onoff=%d\n", __func__, onoff);
> +	deb_info("%s: onoff=%d", __func__, onoff);
>  
>  	ret = rtl2831_rd_reg(adap->dev, SYS_GPIO_OUT_VAL, &gpio);
>  	if (ret)
> @@ -579,16 +688,186 @@ static int rtl28xxu_streaming_ctrl(struct dvb_usb_adapter *adap , int onoff)
>  
>  	return ret;
>  err:
> -	deb_info("%s: failed=%d\n", __func__, ret);
> +	deb_info("%s: failed=%d", __func__, ret);
>  	return ret;
>  }
>  
> -static int rtl28xxu_power_ctrl(struct dvb_usb_device *d, int onoff)
> +static int rtl2832u_streaming_ctrl(struct dvb_usb_adapter *adap , int onoff)
> +{
> +	int ret;
> +	u8 buf[2];
> +
> +	deb_info("%s: onoff=%d", __func__, onoff);
> +
> +
> +	if (onoff) {
> +		buf[0] = 0x00;
> +		buf[1] = 0x00;
> +	} else {
> +		buf[0] = 0x10; /* stall EPA */
> +		buf[1] = 0x02; /* reset EPA */
> +	}
> +
> +	ret = rtl2831_wr_regs(adap->dev, USB_EPA_CTL, buf, 2);
> +	if (ret)
> +		goto err;
> +
> +	return ret;
> +err:
> +	deb_info("%s: failed=%d", __func__, ret);
> +	return ret;
> +}
> +
> +
> +static int rtl2832u_power_ctrl(struct dvb_usb_device *d, int onoff) {
> +
> +	int ret;
> +	struct rtl28xxu_req req;
> +	u8 val;
> +
> +	deb_info("%s: onoff=%d", __func__, onoff);
> +
> +	if(onoff){
> +		/* set output values */
> +		ret = rtl2831_rd_reg(d, SYS_GPIO_OUT_VAL, &val);
> +		if (ret)
> +			goto err;
> +
> +		val |= 0x08;
> +		val &= 0xef;
> +
> +		ret = rtl2831_wr_reg(d, SYS_GPIO_OUT_VAL, val);
> +		if (ret)
> +			goto err;
> +
> +		/* enable as output GPIO3 */
> +		ret = rtl2831_rd_reg(d, SYS_GPIO_OUT_EN, &val);
> +		if (ret)
> +			goto err;
> +
> +		val |= 0x08;
> +
> +		ret = rtl2831_wr_reg(d, SYS_GPIO_OUT_EN, val);
> +		if (ret)
> +			goto err;
> +
> +		/* demod_ctl_1 */
> +		ret = rtl2831_rd_reg(d, SYS_DEMOD_CTL1, &val);
> +		if (ret)
> +			goto err;
> +
> +		val &= 0xef;
> +
> +		ret = rtl2831_wr_reg(d, SYS_DEMOD_CTL1, val);
> +		if (ret)
> +			goto err;
> +
> +		/* demod control */
> +		/* PLL enable */
> +		ret = rtl2831_rd_reg(d, SYS_DEMOD_CTL, &val);
> +		if (ret)
> +			goto err;
> +
> +		/* bit 7 to 1 */
> +		val |= 0x80;
> +
> +		ret = rtl2831_wr_reg(d, SYS_DEMOD_CTL, val);
> +		if (ret)
> +			goto err;
> +
> +		/* demod HW reset */
> +		ret = rtl2831_rd_reg(d, SYS_DEMOD_CTL, &val);
> +		if (ret)
> +			goto err;
> +		/* bit 5 to 0 */
> +		val &= 0xdf;
> +
> +		ret = rtl2831_wr_reg(d, SYS_DEMOD_CTL, val);
> +		if (ret)
> +			goto err;
> +
> +		ret = rtl2831_rd_reg(d, SYS_DEMOD_CTL, &val);
> +		if (ret)
> +			goto err;
> +
> +		val |= 0x20;
> +
> +		ret = rtl2831_wr_reg(d, SYS_DEMOD_CTL, val);
> +		if (ret)
> +			goto err;
> +
> +		/* set page cache to 0 */
> +		req.index = 0x0;
> +		req.value = 0x20 + (1<<8);
> +		req.data = &val;
> +		req.size = 1;
> +		ret = rtl28xxu_ctrl_msg(d, &req);
> +		if (ret)
> +			goto err;
> +
> +
> +		mdelay(5);
> +
> +		/*enable ADC_Q and ADC_I */
> +		ret = rtl2831_rd_reg(d, SYS_DEMOD_CTL, &val);
> +		if (ret)
> +			goto err;
> +
> +		val |= 0x48;
> +
> +		ret = rtl2831_wr_reg(d, SYS_DEMOD_CTL, val);
> +		if (ret)
> +			goto err;
> +
> +
> +	} else {
> +		/* demod_ctl_1 */
> +		ret = rtl2831_rd_reg(d, SYS_DEMOD_CTL1, &val);
> +		if (ret)
> +			goto err;
> +
> +		val |= 0x0c;
> +
> +		ret = rtl2831_wr_reg(d, SYS_DEMOD_CTL1, val);
> +		if (ret)
> +			goto err;
> +
> +		/* set output values */
> +		ret = rtl2831_rd_reg(d, SYS_GPIO_OUT_VAL, &val);
> +		if (ret)
> +				goto err;
> +
> +		val |= 0x10;
> +
> +		ret = rtl2831_wr_reg(d, SYS_GPIO_OUT_VAL, val);
> +		if (ret)
> +			goto err;
> +
> +		/* demod control */
> +		ret = rtl2831_rd_reg(d, SYS_DEMOD_CTL, &val);
> +		if (ret)
> +			goto err;
> +
> +		val &= 0x37;
> +
> +		ret = rtl2831_wr_reg(d, SYS_DEMOD_CTL, val);
> +		if (ret)
> +			goto err;
> +
> +	}
> +
> +	return ret;
> +err:
> +	deb_info("%s: failed=%d", __func__, ret);
> +	return ret;
> +}
> +
> +static int rtl2831u_power_ctrl(struct dvb_usb_device *d, int onoff)
>  {
>  	int ret;
>  	u8 gpio, sys0;
>  
> -	deb_info("%s: onoff=%d\n", __func__, onoff);
> +	deb_info("%s: onoff=%d", __func__, onoff);
>  
>  	/* demod adc */
>  	ret = rtl2831_rd_reg(d, SYS_SYS0, &sys0);
> @@ -600,12 +879,12 @@ static int rtl28xxu_power_ctrl(struct dvb_usb_device *d, int onoff)
>  	if (ret)
>  		goto err;
>  
> -	deb_info("%s: RD SYS0=%02x GPIO_OUT_VAL=%02x\n", __func__, sys0, gpio);
> +	deb_info("%s: RD SYS0=%02x GPIO_OUT_VAL=%02x", __func__, sys0, gpio);
>  
>  	if (onoff) {
>  		gpio |= 0x01; /* GPIO0 = 1 */
>  		gpio &= (~0x10); /* GPIO4 = 0 */
> -		sys0 = sys0 & 0x0f;
> +		sys0 = sys0 & 0x0f; /* enable demod adc */
>  		sys0 |= 0xe0;
>  	} else {
>  		gpio &= (~0x01); /* GPIO0 = 0 */
> @@ -613,7 +892,7 @@ static int rtl28xxu_power_ctrl(struct dvb_usb_device *d, int onoff)
>  		sys0 = sys0 & (~0xc0);
>  	}
>  
> -	deb_info("%s: WR SYS0=%02x GPIO_OUT_VAL=%02x\n", __func__, sys0, gpio);
> +	deb_info("%s: WR SYS0=%02x GPIO_OUT_VAL=%02x", __func__, sys0, gpio);
>  
>  	/* demod adc */
>  	ret = rtl2831_wr_reg(d, SYS_SYS0, sys0);
> @@ -627,7 +906,7 @@ static int rtl28xxu_power_ctrl(struct dvb_usb_device *d, int onoff)
>  
>  	return ret;
>  err:
> -	deb_info("%s: failed=%d\n", __func__, ret);
> +	deb_info("%s: failed=%d", __func__, ret);
>  	return ret;
>  }
>  
> @@ -699,10 +978,12 @@ static int rtl2831u_rc_query(struct dvb_usb_device *d)
>  
>  	return ret;
>  err:
> -	deb_info("%s: failed=%d\n", __func__, ret);
> +	deb_info("%s: failed=%d", __func__, ret);
>  	return ret;
>  }
>  
> +/* unused for now */
> +#if 0
>  static int rtl2832u_rc_query(struct dvb_usb_device *d)
>  {
>  	int ret, i;
> @@ -760,14 +1041,17 @@ static int rtl2832u_rc_query(struct dvb_usb_device *d)
>  exit:
>  	return ret;
>  err:
> -	deb_info("%s: failed=%d\n", __func__, ret);
> +	deb_info("%s: failed=%d", __func__, ret);
>  	return ret;
>  }
> +#endif
>  
>  enum rtl28xxu_usb_table_entry {
>  	RTL2831U_0BDA_2831,
>  	RTL2831U_14AA_0160,
>  	RTL2831U_14AA_0161,
> +	RTL2832U_0CCD_00A9,
> +	RTL2832U_1F4D_B803,
>  };
>  
>  static struct usb_device_id rtl28xxu_table[] = {
> @@ -780,6 +1064,10 @@ static struct usb_device_id rtl28xxu_table[] = {
>  		USB_DEVICE(USB_VID_WIDEVIEW, USB_PID_FREECOM_DVBT_2)},
>  
>  	/* RTL2832U */
> +	[RTL2832U_0CCD_00A9] = {
> +		USB_DEVICE(USB_VID_TERRATEC, USB_PID_TERRATEC_CINERGY_T_STICK_BLACK)},
> +	[RTL2832U_1F4D_B803] = {
> +		USB_DEVICE(USB_VID_GTEK, USB_PID_GTEK)},
>  	{} /* terminating entry */
>  };
>  
> @@ -802,7 +1090,7 @@ static struct dvb_usb_device_properties rtl28xxu_properties[] = {
>  					{
>  						.frontend_attach = rtl2831u_frontend_attach,
>  						.tuner_attach    = rtl2831u_tuner_attach,
> -						.streaming_ctrl  = rtl28xxu_streaming_ctrl,
> +						.streaming_ctrl  = rtl2831u_streaming_ctrl,
>  						.stream = {
>  							.type = USB_BULK,
>  							.count = 6,
> @@ -818,7 +1106,7 @@ static struct dvb_usb_device_properties rtl28xxu_properties[] = {
>  			}
>  		},
>  
> -		.power_ctrl = rtl28xxu_power_ctrl,
> +		.power_ctrl = rtl2831u_power_ctrl,
>  
>  		.rc.core = {
>  			.protocol       = RC_TYPE_NEC,
> @@ -864,11 +1152,11 @@ static struct dvb_usb_device_properties rtl28xxu_properties[] = {
>  					{
>  						.frontend_attach = rtl2832u_frontend_attach,
>  						.tuner_attach    = rtl2832u_tuner_attach,
> -						.streaming_ctrl  = rtl28xxu_streaming_ctrl,
> +						.streaming_ctrl  = rtl2832u_streaming_ctrl,
>  						.stream = {
>  							.type = USB_BULK,
> -							.count = 6,
> -							.endpoint = 0x81,
> +							.count = 10,
> +							.endpoint = 0x01,
>  							.u = {
>  								.bulk = {
>  									.buffersize = 8*512,
> @@ -880,23 +1168,32 @@ static struct dvb_usb_device_properties rtl28xxu_properties[] = {
>  			}
>  		},
>  
> -		.power_ctrl = rtl28xxu_power_ctrl,
> +		.power_ctrl = rtl2832u_power_ctrl,
>  
> -		.rc.core = {
> +		/*.rc.core = {
>  			.protocol       = RC_TYPE_NEC,
>  			.module_name    = "rtl28xxu",
>  			.rc_query       = rtl2832u_rc_query,
>  			.rc_interval    = 400,
>  			.allowed_protos = RC_TYPE_NEC,
>  			.rc_codes       = RC_MAP_EMPTY,
> -		},
> +		},*/
>  
>  		.i2c_algo = &rtl28xxu_i2c_algo,
>  
> -		.num_device_descs = 0, /* disabled as no support for RTL2832 */
> +		.num_device_descs = 2,
>  		.devices = {
>  			{
> -				.name = "Realtek RTL2832U reference design",
> +				.name = "Terratec Cinergy T Stick Black",
> +				.warm_ids = {
> +					&rtl28xxu_table[RTL2832U_0CCD_00A9],
> +				},
> +			},
> +			{
> +				.name = "G-Tek Electronics Group Lifeview LV5TDLX DVB-T [RTL2832U]",
> +				.warm_ids = {
> +					&rtl28xxu_table[RTL2832U_1F4D_B803],
> +				},
>  			},
>  		}
>  	},
> @@ -907,10 +1204,11 @@ static int rtl28xxu_probe(struct usb_interface *intf,
>  		const struct usb_device_id *id)
>  {
>  	int ret, i;
> +	u8 val;
>  	int properties_count = ARRAY_SIZE(rtl28xxu_properties);
>  	struct dvb_usb_device *d;
>  
> -	deb_info("%s: interface=%d\n", __func__,
> +	deb_info("%s: interface=%d", __func__,
>  		intf->cur_altsetting->desc.bInterfaceNumber);
>  
>  	if (intf->cur_altsetting->desc.bInterfaceNumber != 0)
> @@ -926,22 +1224,31 @@ static int rtl28xxu_probe(struct usb_interface *intf,
>  	if (ret)
>  		goto err;
>  
> +
>  	/* init USB endpoints */
> -	ret = rtl2831_wr_reg(d, USB_SYSCTL_0, 0x09);
> +	ret = rtl2831_rd_reg(d, USB_SYSCTL_0, &val);
> +	if (ret)
> +			goto err;
> +
> +	/* enable DMA and Full Packet Mode*/
> +	val |= 0x09;
> +	ret = rtl2831_wr_reg(d, USB_SYSCTL_0, val);
>  	if (ret)
>  		goto err;
>  
> +	/* set EPA maximum packet size to 0x0200 */
>  	ret = rtl2831_wr_regs(d, USB_EPA_MAXPKT, "\x00\x02\x00\x00", 4);
>  	if (ret)
>  		goto err;
>  
> +	/* change EPA FIFO length */
>  	ret = rtl2831_wr_regs(d, USB_EPA_FIFO_CFG, "\x14\x00\x00\x00", 4);
>  	if (ret)
>  		goto err;
>  
>  	return ret;
>  err:
> -	deb_info("%s: failed=%d\n", __func__, ret);
> +	deb_info("%s: failed=%d", __func__, ret);
>  	return ret;
>  }
>  
> @@ -957,8 +1264,6 @@ static int __init rtl28xxu_module_init(void)
>  {
>  	int ret;
>  
> -	deb_info("%s:\n", __func__);
> -
>  	ret = usb_register(&rtl28xxu_driver);
>  	if (ret)
>  		err("usb_register failed=%d", ret);
> @@ -968,7 +1273,6 @@ static int __init rtl28xxu_module_init(void)
>  
>  static void __exit rtl28xxu_module_exit(void)
>  {
> -	deb_info("%s:\n", __func__);
>  
>  	/* deregister this driver from the USB subsystem */
>  	usb_deregister(&rtl28xxu_driver);
> @@ -979,4 +1283,5 @@ module_exit(rtl28xxu_module_exit);
>  
>  MODULE_DESCRIPTION("Realtek RTL28xxU DVB USB driver");
>  MODULE_AUTHOR("Antti Palosaari <crope@iki.fi>");
> +MODULE_AUTHOR("Thomas Mair <thomas.mair86@googlemail.com>");
>  MODULE_LICENSE("GPL");
> diff --git a/drivers/media/dvb/frontends/Kconfig b/drivers/media/dvb/frontends/Kconfig
> index f479834..f7d67d7 100644
> --- a/drivers/media/dvb/frontends/Kconfig
> +++ b/drivers/media/dvb/frontends/Kconfig
> @@ -432,6 +432,13 @@ config DVB_RTL2830
>  	help
>  	  Say Y when you want to support this frontend.
>  
> +config DVB_RTL2832
> +	tristate "Realtek RTL2832 DVB-T"
> +	depends on DVB_CORE && I2C
> +	default m if DVB_FE_CUSTOMISE
> +	help
> +	  Say Y when you want to support this frontend.
> +
>  comment "DVB-C (cable) frontends"
>  	depends on DVB_CORE
>  
> diff --git a/drivers/media/dvb/frontends/Makefile b/drivers/media/dvb/frontends/Makefile
> index b0381dc..a109aae 100644
> --- a/drivers/media/dvb/frontends/Makefile
> +++ b/drivers/media/dvb/frontends/Makefile
> @@ -100,4 +100,4 @@ obj-$(CONFIG_DVB_TDA10071) += tda10071.o
>  obj-$(CONFIG_DVB_RTL2830) += rtl2830.o
>  obj-$(CONFIG_DVB_M88RS2000) += m88rs2000.o
>  obj-$(CONFIG_DVB_AF9033) += af9033.o
> -
> +obj-$(CONFIG_DVB_RTL2832) += rtl2832.o
> diff --git a/drivers/media/dvb/frontends/rtl2832.c b/drivers/media/dvb/frontends/rtl2832.c
> new file mode 100644
> index 0000000..920b068
> --- /dev/null
> +++ b/drivers/media/dvb/frontends/rtl2832.c
> @@ -0,0 +1,832 @@
> +/*
> + * Realtek RTL2832 DVB-T demodulator driver
> + *
> + * Copyright (C) 2012 Thomas Mair <thomas.mair86@gmail.com>
> + *
> + *    This program is free software; you can redistribute it and/or modify
> + *    it under the terms of the GNU General Public License as published by
> + *    the Free Software Foundation; either version 2 of the License, or
> + *    (at your option) any later version.
> + *
> + *    This program is distributed in the hope that it will be useful,
> + *    but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *    GNU General Public License for more details.
> + *
> + *    You should have received a copy of the GNU General Public License along
> + *    with this program; if not, write to the Free Software Foundation, Inc.,
> + *    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
> + */
> +
> +#include "rtl2832_priv.h"
> +
> +
> +
> +int rtl2832_debug = 1;
> +module_param_named(debug, rtl2832_debug, int, 0644);
> +MODULE_PARM_DESC(debug, "Turn on/off frontend debugging (default:off).");
> +
> +
> +static int reg_mask[32] = {
> +    0x00000001,
> +    0x00000003,
> +    0x00000007,
> +    0x0000000f,
> +    0x0000001f,
> +    0x0000003f,
> +    0x0000007f,
> +    0x000000ff,
> +    0x000001ff,
> +    0x000003ff,
> +    0x000007ff,
> +    0x00000fff,
> +    0x00001fff,
> +    0x00003fff,
> +    0x00007fff,
> +    0x0000ffff,
> +    0x0001ffff,
> +    0x0003ffff,
> +    0x0007ffff,
> +    0x000fffff,
> +    0x001fffff,
> +    0x003fffff,
> +    0x007fffff,
> +    0x00ffffff,
> +    0x01ffffff,
> +    0x03ffffff,
> +    0x07ffffff,
> +    0x0fffffff,
> +    0x1fffffff,
> +    0x3fffffff,
> +    0x7fffffff,
> +    0xffffffff
> +};
> +
> +static const rtl2832_reg_entry registers[] = {
> +  [DVBT_SOFT_RST] = {0x1, 0x1, 2, 2},
> +  [DVBT_IIC_REPEAT] = {0x1,  0x1,   3,  3},
> +  [DVBT_TR_WAIT_MIN_8K]   = {0x1,  0x88,   11,  2},
> +  [DVBT_RSD_BER_FAIL_VAL] = {0x1,  0x8f,   15,  0},
> +  [DVBT_EN_BK_TRK]        = {0x1,  0xa6,   7,  7},
> +  [DVBT_AD_EN_REG]        = {0x0,  0x8,   7,  7},
> +  [DVBT_AD_EN_REG1]       = {0x0,  0x8,   6,  6},
> +  [DVBT_EN_BBIN]          = {0x1,  0xb1,   0,  0},
> +  [DVBT_MGD_THD0]         = {0x1,  0x95,   7,  0},
> +  [DVBT_MGD_THD1]         = {0x1,  0x96,   7,  0},
> +  [DVBT_MGD_THD2]         = {0x1,  0x97,   7,  0},
> +  [DVBT_MGD_THD3]         = {0x1,  0x98,   7,  0},
> +  [DVBT_MGD_THD4]         = {0x1,  0x99,   7,  0},
> +  [DVBT_MGD_THD5]         = {0x1,  0x9a,   7,  0},
> +  [DVBT_MGD_THD6]         = {0x1,  0x9b,   7,  0},
> +  [DVBT_MGD_THD7]         = {0x1,  0x9c,   7,  0},
> +  [DVBT_EN_CACQ_NOTCH]    = {0x1,  0x61,   4,  4},
> +  [DVBT_AD_AV_REF]        = {0x0,  0x9,   6,  0},
> +  [DVBT_REG_PI]           = {0x0,  0xa,   2,  0},
> +  [DVBT_PIP_ON]           = {0x0,  0x21,   3,  3},
> +  [DVBT_SCALE1_B92]       = {0x2,  0x92,   7,  0},
> +  [DVBT_SCALE1_B93]       = {0x2,  0x93,   7,  0},
> +  [DVBT_SCALE1_BA7]       = {0x2,  0xa7,   7,  0},
> +  [DVBT_SCALE1_BA9]       = {0x2,  0xa9,   7,  0},
> +  [DVBT_SCALE1_BAA]       = {0x2,  0xaa,   7,  0},
> +  [DVBT_SCALE1_BAB]       = {0x2,  0xab,   7,  0},
> +  [DVBT_SCALE1_BAC]       = {0x2,  0xac,   7,  0},
> +  [DVBT_SCALE1_BB0]       = {0x2,  0xb0,   7,  0},
> +  [DVBT_SCALE1_BB1]       = {0x2,  0xb1,   7,  0},
> +  [DVBT_KB_P1]            = {0x1,  0x64,   3,  1},
> +  [DVBT_KB_P2]            = {0x1,  0x64,   6,  4},
> +  [DVBT_KB_P3]            = {0x1,  0x65,   2,  0},
> +  [DVBT_OPT_ADC_IQ]       = {0x0,  0x6,   5,  4},
> +  [DVBT_AD_AVI]           = {0x0,  0x9,   1,  0},
> +  [DVBT_AD_AVQ]           = {0x0,  0x9,   3,  2},
> +  [DVBT_K1_CR_STEP12]     = {0x2,  0xad,   9,  4},
> +  [DVBT_TRK_KS_P2]        = {0x1,  0x6f,   2,  0},
> +  [DVBT_TRK_KS_I2]        = {0x1,  0x70,   5,  3},
> +  [DVBT_TR_THD_SET2]      = {0x1,  0x72,   3,  0},
> +  [DVBT_TRK_KC_P2]        = {0x1,  0x73,   5,  3},
> +  [DVBT_TRK_KC_I2]        = {0x1,  0x75,   2,  0},
> +  [DVBT_CR_THD_SET2]      = {0x1,  0x76,   7,  6},
> +  [DVBT_PSET_IFFREQ]     = {0x1,  0x19,   21,  0},
> +  [DVBT_SPEC_INV]        = {0x1,  0x15,   0,  0},
> +  [DVBT_RSAMP_RATIO]     = {0x1,  0x9f,   27,  2},
> +  [DVBT_CFREQ_OFF_RATIO] = {0x1,  0x9d,   23,  4},
> +  [DVBT_FSM_STAGE]       = {0x3,  0x51,   6,  3},
> +  [DVBT_RX_CONSTEL]      = {0x3,  0x3c,   3,  2},
> +  [DVBT_RX_HIER]         = {0x3,  0x3c,   6,  4},
> +  [DVBT_RX_C_RATE_LP]    = {0x3,  0x3d,   2,  0},
> +  [DVBT_RX_C_RATE_HP]    = {0x3,  0x3d,   5,  3},
> +  [DVBT_GI_IDX]          = {0x3,  0x51,   1,  0},
> +  [DVBT_FFT_MODE_IDX]    = {0x3,  0x51,   2,  2},
> +  [DVBT_RSD_BER_EST]     = {0x3,  0x4e,   15,  0},
> +  [DVBT_CE_EST_EVM]      = {0x4,  0xc,   15,  0},
> +  [DVBT_RF_AGC_VAL]      = {0x3,  0x5b,   13,  0},
> +  [DVBT_IF_AGC_VAL]      = {0x3,  0x59,   13,  0},
> +  [DVBT_DAGC_VAL]        = {0x3,  0x5,   7,  0},
> +  [DVBT_SFREQ_OFF]       = {0x3,  0x18,   13,  0},
> +  [DVBT_CFREQ_OFF]       = {0x3,  0x5f,   17,  0},
> +  [DVBT_POLAR_RF_AGC]    = {0x0,  0xe,   1,  1},
> +  [DVBT_POLAR_IF_AGC]    = {0x0,  0xe,   0,  0},
> +  [DVBT_AAGC_HOLD]       = {0x1,  0x4,   5,  5},
> +  [DVBT_EN_RF_AGC]       = {0x1,  0x4,   6,  6},
> +  [DVBT_EN_IF_AGC]       = {0x1,  0x4,   7,  7},
> +  [DVBT_IF_AGC_MIN]      = {0x1,  0x8,   7,  0},
> +  [DVBT_IF_AGC_MAX]      = {0x1,  0x9,   7,  0},
> +  [DVBT_RF_AGC_MIN]      = {0x1,  0xa,   7,  0},
> +  [DVBT_RF_AGC_MAX]      = {0x1,  0xb,   7,  0},
> +  [DVBT_IF_AGC_MAN]      = {0x1,  0xc,   6,  6},
> +  [DVBT_IF_AGC_MAN_VAL]  = {0x1,  0xc,   13,  0},
> +  [DVBT_RF_AGC_MAN]      = {0x1,  0xe,   6,  6},
> +  [DVBT_RF_AGC_MAN_VAL]  = {0x1,  0xe,   13,  0},
> +  [DVBT_DAGC_TRG_VAL]    = {0x1,  0x12,   7,  0},
> +  [DVBT_AGC_TARG_VAL_0]  = {0x1,  0x2,   0,  0},
> +  [DVBT_AGC_TARG_VAL_8_1] = {0x1,  0x3,   7,  0},
> +  [DVBT_AAGC_LOOP_GAIN]  = {0x1,  0xc7,   5,  1},
> +  [DVBT_LOOP_GAIN2_3_0]  = {0x1,  0x4,   4,  1},
> +  [DVBT_LOOP_GAIN2_4]    = {0x1,  0x5,   7,  7},
> +  [DVBT_LOOP_GAIN3]      = {0x1,  0xc8,   4,  0},
> +  [DVBT_VTOP1]           = {0x1,  0x6,   5,  0},
> +  [DVBT_VTOP2]           = {0x1,  0xc9,   5,  0},
> +  [DVBT_VTOP3]           = {0x1,  0xca,   5,  0},
> +  [DVBT_KRF1]            = {0x1,  0xcb,   7,  0},
> +  [DVBT_KRF2]            = {0x1,  0x7,   7,  0},
> +  [DVBT_KRF3]            = {0x1,  0xcd,   7,  0},
> +  [DVBT_KRF4]            = {0x1,  0xce,   7,  0},
> +  [DVBT_EN_GI_PGA]       = {0x1,  0xe5,   0,  0},
> +  [DVBT_THD_LOCK_UP]     = {0x1,  0xd9,   8,  0},
> +  [DVBT_THD_LOCK_DW]     = {0x1,  0xdb,   8,  0},
> +  [DVBT_THD_UP1]         = {0x1,  0xdd,   7,  0},
> +  [DVBT_THD_DW1]         = {0x1,  0xde,   7,  0},
> +  [DVBT_INTER_CNT_LEN]   = {0x1,  0xd8,   3,  0},
> +  [DVBT_GI_PGA_STATE]    = {0x1,  0xe6,   3,  3},
> +  [DVBT_EN_AGC_PGA]      = {0x1,  0xd7,   0,  0},
> +  [DVBT_CKOUTPAR]        = {0x1,  0x7b,   5,  5},
> +  [DVBT_CKOUT_PWR]       = {0x1,  0x7b,   6,  6},
> +  [DVBT_SYNC_DUR]        = {0x1,  0x7b,   7,  7},
> +  [DVBT_ERR_DUR]         = {0x1,  0x7c,   0,  0},
> +  [DVBT_SYNC_LVL]        = {0x1,  0x7c,   1,  1},
> +  [DVBT_ERR_LVL]         = {0x1,  0x7c,   2,  2},
> +  [DVBT_VAL_LVL]         = {0x1,  0x7c,   3,  3},
> +  [DVBT_SERIAL]          = {0x1,  0x7c,   4,  4},
> +  [DVBT_SER_LSB]         = {0x1,  0x7c,   5,  5},
> +  [DVBT_CDIV_PH0]        = {0x1,  0x7d,   3,  0},
> +  [DVBT_CDIV_PH1]        = {0x1,  0x7d,   7,  4},
> +  [DVBT_MPEG_IO_OPT_2_2] = {0x0,  0x6,   7,  7},
> +  [DVBT_MPEG_IO_OPT_1_0] = {0x0,  0x7,   7,  6},
> +  [DVBT_CKOUTPAR_PIP]    = {0x0,  0xb7,   4,  4},
> +  [DVBT_CKOUT_PWR_PIP]   = {0x0,  0xb7,   3,  3},
> +  [DVBT_SYNC_LVL_PIP]    = {0x0,  0xb7,   2,  2},
> +  [DVBT_ERR_LVL_PIP]     = {0x0,  0xb7,   1,  1},
> +  [DVBT_VAL_LVL_PIP]     = {0x0,  0xb7,   0,  0},
> +  [DVBT_CKOUTPAR_PID]    = {0x0,  0xb9,   4,  4},
> +  [DVBT_CKOUT_PWR_PID]   = {0x0,  0xb9,   3,  3},
> +  [DVBT_SYNC_LVL_PID]    = {0x0,  0xb9,   2,  2},
> +  [DVBT_ERR_LVL_PID]     = {0x0,  0xb9,   1,  1},
> +  [DVBT_VAL_LVL_PID]     = {0x0,  0xb9,   0,  0},
> +  [DVBT_SM_PASS]         = {0x1,  0x93,   11,  0},
> +  [DVBT_AD7_SETTING]     = {0x0,  0x11,   15,  0},
> +  [DVBT_RSSI_R]          = {0x3,  0x1,   6,  0},
> +  [DVBT_ACI_DET_IND]     = {0x3,  0x12,   0,  0},
> +  [DVBT_REG_MON]        = {0x0,  0xd,   1,  0},
> +  [DVBT_REG_MONSEL]     = {0x0,  0xd,   2,  2},
> +  [DVBT_REG_GPE]        = {0x0,  0xd,   7,  7},
> +  [DVBT_REG_GPO]        = {0x0,  0x10,   0,  0},
> +  [DVBT_REG_4MSEL]      = {0x0,  0x13,   0,  0},
> +};
> +
> +
> +
> +/* write multiple hardware registers */
> +static int rtl2832_wr(struct rtl2832_priv *priv, u8 reg, u8 *val, int len)
> +{
> +	int ret;
> +	u8 buf[1+len];
> +	struct i2c_msg msg[1] = {
> +		{
> +			.addr = priv->cfg.i2c_addr,
> +			.flags = 0,
> +			.len = 1+len,
> +			.buf = buf,
> +		}
> +	};
> +
> +	buf[0] = reg;
> +	memcpy(&buf[1], val, len);
> +
> +	ret = i2c_transfer(priv->i2c, msg, 1);
> +	if (ret == 1) {
> +		ret = 0;
> +	} else {
> +		warn("i2c wr failed=%d reg=%02x len=%d", ret, reg, len);
> +		ret = -EREMOTEIO;
> +	}
> +	return ret;
> +}
> +
> +/* read multiple hardware registers */
> +static int rtl2832_rd(struct rtl2832_priv *priv, u8 reg, u8 *val, int len)
> +{
> +	int ret;
> +	struct i2c_msg msg[2] = {
> +		{
> +			.addr = priv->cfg.i2c_addr,
> +			.flags = 0,
> +			.len = 1,
> +			.buf = &reg,
> +		}, {
> +			.addr = priv->cfg.i2c_addr,
> +			.flags = I2C_M_RD,
> +			.len = len,
> +			.buf = val,
> +		}
> +	};
> +
> +	ret = i2c_transfer(priv->i2c, msg, 2);
> +	if (ret == 2) {
> +		ret = 0;
> +	} else {
> +		warn("i2c rd failed=%d reg=%02x len=%d", ret, reg, len);
> +		ret = -EREMOTEIO;
> +	}
> +	return ret;
> +}
> +
> +/* write multiple registers */
> +static int rtl2832_wr_regs(struct rtl2832_priv *priv, u8 reg, u8 page, u8 *val, int len)
> +{
> +	int ret;
> +
> +
> +	/* switch bank if needed */
> +	if (page != priv->page) {
> +		ret = rtl2832_wr(priv, 0x00, &page, 1);
> +		if (ret)
> +			return ret;
> +
> +		priv->page = page;
> +	}
> +
> +	return rtl2832_wr(priv, reg, val, len);
> +}
> +
> +/* read multiple registers */
> +static int rtl2832_rd_regs(struct rtl2832_priv *priv, u8 reg, u8 page, u8 *val, int len)
> +{
> +	int ret;
> +
> +	/* switch bank if needed */
> +	if (page != priv->page) {
> +		ret = rtl2832_wr(priv, 0x00, &page, 1);
> +		if (ret)
> +			return ret;
> +
> +		priv->page = page;
> +	}
> +
> +	return rtl2832_rd(priv, reg, val, len);
> +}
> +
> +#if 0 /* currently not used */
> +/* write single register */
> +static int rtl2832_wr_reg(struct rtl2832_priv *priv, u8 reg, u8 page, u8 val)
> +{
> +	return rtl2832_wr_regs(priv, reg, page, &val, 1);
> +}
> +#endif
> +
> +/* read single register */
> +static int rtl2832_rd_reg(struct rtl2832_priv *priv, u8 reg, u8 page, u8 *val)
> +{
> +	return rtl2832_rd_regs(priv, reg, page, val, 1);
> +}
> +
> +int rtl2832_rd_demod_reg(struct rtl2832_priv *priv, int reg, u32 *val){
> +	int ret;
> +
> +	u8 reg_start_addr;
> +	u8 msb, lsb;
> +	u8 page;
> +	u8 reading[4];
> +	u32 reading_tmp;
> +	int i;
> +
> +	u8 len;
> +	u32 mask;
> +
> +	reg_start_addr = registers[reg].start_address;
> +	msb = registers[reg].msb;
> +	lsb = registers[reg].lsb;
> +	page = registers[reg].page;
> +
> +	len = (msb >> 3) + 1;
> +	mask = reg_mask[msb-lsb];
> +
> +
> +	ret = rtl2832_rd_regs(priv, reg_start_addr, page, &reading[0], len);
> +	if (ret)
> +		goto err;
> +
> +	reading_tmp = 0;
> +	for(i = 0; i < len; i++){
> +		reading_tmp |= reading[i] << ((len-1-i)*8);
> +	}
> +
> +	*val = (reading_tmp >> lsb) & mask;
> +
> +	return ret;
> +
> +err:
> +	return ret;
> +
> +}
> +
> +int rtl2832_wr_demod_reg(struct rtl2832_priv *priv, int reg, u32 val)
> +{
> +	int ret, i;
> +	u8 len;
> +	u8 reg_start_addr;
> +	u8 msb, lsb;
> +	u8 page;
> +	u32 mask;
> +
> +
> +	u8 reading[4];
> +	u8 writing[4];
> +	u32 reading_tmp;
> +	u32 writing_tmp;
> +
> +
> +	reg_start_addr = registers[reg].start_address;
> +	msb = registers[reg].msb;
> +	lsb = registers[reg].lsb;
> +	page = registers[reg].page;
> +
> +	len = (msb >> 3) + 1;
> +	mask = reg_mask[msb-lsb];
> +
> +
> +	ret = rtl2832_rd_regs(priv, reg_start_addr, page, &reading[0], len);
> +	if (ret)
> +		goto err;
> +
> +	reading_tmp = 0;
> +	for (i = 0; i < len; i++) {
> +		reading_tmp |= reading[i] << ((len-1-i)*8);
> +	}
> +
> +	writing_tmp = reading_tmp & ~(mask << lsb);
> +	writing_tmp |= ((val & mask) << lsb);
> +
> +
> +	for (i = 0; i < len; i++) {
> +		writing[i] = (writing_tmp >> ((len-1-i)*8)) & 0xff;
> +	}
> +
> +	ret = rtl2832_wr_regs(priv, reg_start_addr, page, &writing[0], len);
> +	if(ret)
> +		goto err;
> +
> +	return ret;
> +
> +err:
> +	return ret;
> +
> +}
> +
> +
> +static int rtl2832_i2c_gate_ctrl(struct dvb_frontend *fe, int enable)
> +{
> +	int ret;
> +	struct rtl2832_priv *priv = fe->demodulator_priv;
> +
> +	dbg("%s: enable=%d", __func__, enable);
> +
> +	/* gate already open or close */
> +	if (priv->i2c_gate_state == enable)
> +		return 0;
> +
> +	ret = rtl2832_wr_demod_reg(priv, DVBT_IIC_REPEAT, (enable?0x1:0x0));
> +
> +	if (ret)
> +		goto err;
> +
> +	priv->i2c_gate_state = enable;
> +
> +	return ret;
> +err:
> +	dbg("%s: failed=%d", __func__, ret);
> +	return ret;
> +}
> +
> +
> +
> +static int rtl2832_init(struct dvb_frontend *fe)
> +{
> +	struct rtl2832_priv *priv = fe->demodulator_priv;
> +	int i, ret;
> +
> +	u8 en_bbin;
> +	u64 pset_iffreq;
> +
> +	/* initialization values for the demodulator registers */
> +	static rtl2832_reg_value rtl2832_initial_regs_1[] = {
> +			{DVBT_AD_EN_REG,			0x1		},
> +			{DVBT_AD_EN_REG1,			0x1		},
> +			{DVBT_RSD_BER_FAIL_VAL,		0x2800	},
> +			{DVBT_MGD_THD0,				0x10	},
> +			{DVBT_MGD_THD1,				0x20	},
> +			{DVBT_MGD_THD2,				0x20	},
> +			{DVBT_MGD_THD3,				0x40	},
> +			{DVBT_MGD_THD4,				0x22	},
> +			{DVBT_MGD_THD5,				0x32	},
> +			{DVBT_MGD_THD6,				0x37	},
> +			{DVBT_MGD_THD7,				0x39	},
> +			{DVBT_EN_BK_TRK,			0x0		},
> +			{DVBT_EN_CACQ_NOTCH,		0x0		},
> +			{DVBT_AD_AV_REF,			0x2a	},
> +			{DVBT_REG_PI,				0x6		},
> +			{DVBT_PIP_ON,				0x0		},
> +			{DVBT_CDIV_PH0,				0x8		},
> +			{DVBT_CDIV_PH1,				0x8		},
> +			{DVBT_SCALE1_B92,			0x4		},
> +			{DVBT_SCALE1_B93,			0xb0	},
> +			{DVBT_SCALE1_BA7,			0x78	},
> +			{DVBT_SCALE1_BA9,			0x28	},
> +			{DVBT_SCALE1_BAA,			0x59	},
> +			{DVBT_SCALE1_BAB,			0x83	},
> +			{DVBT_SCALE1_BAC,			0xd4	},
> +			{DVBT_SCALE1_BB0,			0x65	},
> +			{DVBT_SCALE1_BB1,			0x43	},
> +			{DVBT_KB_P1,				0x1		},
> +			{DVBT_KB_P2,				0x4		},
> +			{DVBT_KB_P3,				0x7		},
> +			{DVBT_K1_CR_STEP12,			0xa		},
> +			{DVBT_REG_GPE,				0x1		},
> +			{DVBT_SERIAL,				0x0},
> +			{DVBT_CDIV_PH0,				0x9},
> +			{DVBT_CDIV_PH1,				0x9},
> +			{DVBT_MPEG_IO_OPT_2_2,		0x0},
> +			{DVBT_MPEG_IO_OPT_1_0,		0x0},
> +			{DVBT_TRK_KS_P2,			0x4},
> +			{DVBT_TRK_KS_I2,			0x7},
> +			{DVBT_TR_THD_SET2,			0x6},
> +			{DVBT_TRK_KC_I2,			0x5},
> +			{DVBT_CR_THD_SET2,			0x1},
> +
> +
> +		};
> +
> +	static rtl2832_reg_value rtl2832_initial_regs_2[] = {
> +			{DVBT_SPEC_INV,				0x0},
> +			{DVBT_DAGC_TRG_VAL,			0x5a	},
> +			{DVBT_AGC_TARG_VAL_0,		0x0		},
> +			{DVBT_AGC_TARG_VAL_8_1,		0x5a	},
> +			{DVBT_AAGC_LOOP_GAIN,		0x16    },
> +			{DVBT_LOOP_GAIN2_3_0,		0x6		},
> +			{DVBT_LOOP_GAIN2_4,			0x1		},
> +			{DVBT_LOOP_GAIN3,			0x16	},
> +			{DVBT_VTOP1,				0x35	},
> +			{DVBT_VTOP2,				0x21	},
> +			{DVBT_VTOP3,				0x21	},
> +			{DVBT_KRF1,					0x0		},
> +			{DVBT_KRF2,					0x40	},
> +			{DVBT_KRF3,					0x10	},
> +			{DVBT_KRF4,					0x10	},
> +			{DVBT_IF_AGC_MIN,			0x80	},
> +			{DVBT_IF_AGC_MAX,			0x7f	},
> +			{DVBT_RF_AGC_MIN,			0x80	},
> +			{DVBT_RF_AGC_MAX,			0x7f	},
> +			{DVBT_POLAR_RF_AGC,			0x0		},
> +			{DVBT_POLAR_IF_AGC,			0x0		},
> +			{DVBT_AD7_SETTING,			0xe9bf	},
> +			{DVBT_EN_GI_PGA,			0x0		},
> +			{DVBT_THD_LOCK_UP,			0x0		},
> +			{DVBT_THD_LOCK_DW,			0x0		},
> +			{DVBT_THD_UP1,				0x11	},
> +			{DVBT_THD_DW1,				0xef	},
> +			{DVBT_INTER_CNT_LEN,		0xc		},
> +			{DVBT_GI_PGA_STATE,			0x0		},
> +			{DVBT_EN_AGC_PGA,			0x1		},
> +			{DVBT_IF_AGC_MAN,			0x0		},
> +		};
> +
> +
> +	info("%s", __func__);
> +
> +	en_bbin = (priv->cfg.if_dvbt == 0 ? 0x1 : 0x0);
> +
> +	/* PSET_IFFREQ = - floor((IfFreqHz % CrystalFreqHz) * pow(2, 22) / CrystalFreqHz) */
> +	pset_iffreq = priv->cfg.if_dvbt % priv->cfg.xtal;
> +	pset_iffreq *= 0x400000;
> +	pset_iffreq = div_u64(pset_iffreq, priv->cfg.xtal);
> +	pset_iffreq = pset_iffreq & 0x3fffff;
> +
> +
> +
> +	for (i = 0; i < 42; i++) {
> +		ret = rtl2832_wr_demod_reg(priv, rtl2832_initial_regs_1[i].reg, rtl2832_initial_regs_1[i].value);
> +		if (ret)
> +			goto err;
> +	}
> +
> +	/* if frequency settings */
> +	ret = rtl2832_wr_demod_reg(priv, DVBT_EN_BBIN, en_bbin);
> +		if (ret)
> +			goto err;
> +
> +	ret = rtl2832_wr_demod_reg(priv, DVBT_PSET_IFFREQ, pset_iffreq);
> +		if(ret)
> +			goto err;
> +
> +	for (i = 0; i < 31; i++) {
> +		ret = rtl2832_wr_demod_reg(priv, rtl2832_initial_regs_2[i].reg, rtl2832_initial_regs_2[i].value);
> +		if (ret)
> +			goto err;
> +	}
> +
> +	priv->sleeping = false;
> +
> +	return ret;
> +
> +err:
> +	return ret;
> +}
> +
> +static int rtl2832_sleep(struct dvb_frontend *fe)
> +{
> +	struct rtl2832_priv *priv = fe->demodulator_priv;
> +
> +	info("%s", __func__);
> +	priv->sleeping = true;
> +	return 0;
> +}
> +
> +int rtl2832_get_tune_settings(struct dvb_frontend *fe,
> +	struct dvb_frontend_tune_settings *s)
> +{
> +	info("%s", __func__);
> +	s->min_delay_ms = 1000;
> +	s->step_size = fe->ops.info.frequency_stepsize * 2;
> +	s->max_drift = (fe->ops.info.frequency_stepsize * 2) + 1;
> +	return 0;
> +}
> +
> +static int rtl2832_set_frontend(struct dvb_frontend *fe)
> +{
> +	struct rtl2832_priv *priv = fe->demodulator_priv;
> +	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
> +	int ret, i, j;
> +	u64 bw_mode, num, num2;
> +	u32 resamp_ratio, cfreq_off_ratio;
> +
> +
> +	static u8 bw_params[3][32] = {
> +		/* 6 MHz bandwidth */
> +		{
> +			0xf5,	0xff,	0x15,	0x38,	0x5d,	0x6d,	0x52,	0x07,	0xfa,	0x2f,
> +			0x53,	0xf5,	0x3f,	0xca,	0x0b,	0x91,	0xea,	0x30,	0x63,	0xb2,
> +			0x13,	0xda,	0x0b,	0xc4,	0x18,	0x7e,	0x16,	0x66,	0x08,	0x67,
> +			0x19,	0xe0,
> +		},
> +
> +		/*  7 MHz bandwidth */
> +		{
> +			0xe7,	0xcc,	0xb5,	0xba,	0xe8,	0x2f,	0x67,	0x61,	0x00,	0xaf,
> +			0x86,	0xf2,	0xbf,	0x59,	0x04,	0x11,	0xb6,	0x33,	0xa4,	0x30,
> +			0x15,	0x10,	0x0a,	0x42,	0x18,	0xf8,	0x17,	0xd9,	0x07,	0x22,
> +			0x19,	0x10,
> +		},
> +
> +		/*  8 MHz bandwidth */
> +		{
> +			0x09,	0xf6,	0xd2,	0xa7,	0x9a,	0xc9,	0x27,	0x77,	0x06,	0xbf,
> +			0xec,	0xf4,	0x4f,	0x0b,	0xfc,	0x01,	0x63,	0x35,	0x54,	0xa7,
> +			0x16,	0x66,	0x08,	0xb4,	0x19,	0x6e,	0x19,	0x65,	0x05,	0xc8,
> +			0x19,	0xe0,
> +		},
> +	};
> +
> +
> +	info("%s: frequency=%d bandwidth_hz=%d inversion=%d", __func__,
> +			c->frequency, c->bandwidth_hz, c->inversion);
> +
> +
> +	/* program tuner */
> +	if (fe->ops.tuner_ops.set_params)
> +		fe->ops.tuner_ops.set_params(fe);
> +
> +
> +	switch (c->bandwidth_hz) {
> +		case 6000000:
> +			i = 0;
> +			bw_mode = 48000000;
> +			break;
> +		case 7000000:
> +			i = 1;
> +			bw_mode = 56000000;
> +			break;
> +		case 8000000:
> +			i = 2;
> +			bw_mode = 64000000;
> +			break;
> +		default:
> +			dbg("invalid bandwidth");
> +			return -EINVAL;
> +		}
> +
> +	for (j = 0; j < 32; j++){
> +		ret = rtl2832_wr_regs(priv, 0x1c+j, 1, &bw_params[i][j], 1);
> +		if (ret)
> +			goto err;
> +	}
> +
> +	/* calculate and set resample ratio */
> +	/* RSAMP_RATIO = floor(CrystalFreqHz * 7 * pow(2, 22) / ConstWithBandwidthMode) */
> +	num = priv->cfg.xtal * 7;
> +	num *= 0x400000;
> +	num = div_u64(num, bw_mode);
> +	resamp_ratio =  num & 0x3ffffff;
> +	ret = rtl2832_wr_demod_reg(priv, DVBT_RSAMP_RATIO, resamp_ratio);
> +	if (ret)
> +		goto err;
> +
> +	/* calculate and set cfreq off ratio */
> +	/* CFREQ_OFF_RATIO = - floor(ConstWithBandwidthMode * pow(2, 20) / (CrystalFreqHz * 7)) */
> +	num = bw_mode << 20;
> +	num2 = priv->cfg.xtal * 7;
> +	num = div_u64(num, num2);
> +	num = -num;
> +	cfreq_off_ratio = num & 0xfffff;
> +	ret = rtl2832_wr_demod_reg(priv, DVBT_CFREQ_OFF_RATIO, cfreq_off_ratio);
> +	if (ret)
> +		goto err;
> +
> +
> +	/* soft reset */
> +	ret = rtl2832_wr_demod_reg(priv, DVBT_SOFT_RST, 0x1);
> +	if (ret)
> +		goto err;
> +
> +	ret = rtl2832_wr_demod_reg(priv, DVBT_SOFT_RST, 0x0);
> +	if (ret)
> +		goto err;
> +
> +	return ret;
> +err:
> +	info("%s: failed=%d", __func__, ret);
> +	return ret;
> +}
> +
> +static int rtl2832_read_status(struct dvb_frontend *fe, fe_status_t *status)
> +{
> +	struct rtl2832_priv *priv = fe->demodulator_priv;
> +	int ret;
> +	u32 tmp;
> +	*status = 0;
> +
> +
> +	info("%s", __func__);
> +	if (priv->sleeping)
> +		return 0;
> +
> +	ret = rtl2832_rd_demod_reg(priv, DVBT_FSM_STAGE, &tmp);
> +	if (ret)
> +		goto err;
> +
> +	if (tmp == 11) {
> +		*status |= FE_HAS_SIGNAL | FE_HAS_CARRIER |
> +			FE_HAS_VITERBI | FE_HAS_SYNC | FE_HAS_LOCK;
> +	}
> +	/* TODO find out if this is also true */
> +	/*else if (tmp == 10) {
> +		*status |= FE_HAS_SIGNAL | FE_HAS_CARRIER |
> +			FE_HAS_VITERBI;
> +	}*/
> +
> +	return ret;
> +err:
> +	info("%s: failed=%d", __func__, ret);
> +	return ret;
> +}
> +
> +static int rtl2832_read_snr(struct dvb_frontend *fe, u16 *snr)
> +{
> +	info("%s", __func__);
> +	*snr = 0;
> +	return 0;
> +}
> +
> +static int rtl2832_read_ber(struct dvb_frontend *fe, u32 *ber)
> +{
> +	info("%s", __func__);
> +	*ber = 0;
> +	return 0;
> +}
> +
> +static int rtl2832_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
> +{
> +	info("%s", __func__);
> +	*ucblocks = 0;
> +	return 0;
> +}
> +
> +static int rtl2832_read_signal_strength(struct dvb_frontend *fe, u16 *strength)
> +{
> +	info("%s", __func__);
> +	*strength = 0;
> +	return 0;
> +}
> +
> +static struct dvb_frontend_ops rtl2832_ops;
> +
> +static void rtl2832_release(struct dvb_frontend *fe)
> +{
> +	struct rtl2832_priv *priv = fe->demodulator_priv;
> +
> +	info("%s", __func__);
> +	kfree(priv);
> +}
> +
> +struct dvb_frontend *rtl2832_attach(const struct rtl2832_config *cfg,
> +	struct i2c_adapter *i2c, u8 tuner)
> +{
> +	struct rtl2832_priv *priv = NULL;
> +	int ret = 0;
> +	u8 tmp;
> +
> +	info("%s", __func__);
> +
> +	/* allocate memory for the internal state */
> +	priv = kzalloc(sizeof(struct rtl2832_priv), GFP_KERNEL);
> +	if (priv == NULL)
> +		goto err;
> +
> +	/* setup the priv */
> +	priv->i2c = i2c;
> +	priv->tuner = tuner;
> +	memcpy(&priv->cfg, cfg, sizeof(struct rtl2832_config));
> +
> +	/* check if the demod is there */
> +	ret = rtl2832_rd_reg(priv, 0x00, 0x0, &tmp);
> +	if (ret)
> +		goto err;
> +
> +	/* create dvb_frontend */
> +	memcpy(&priv->fe.ops, &rtl2832_ops, sizeof(struct dvb_frontend_ops));
> +	priv->fe.demodulator_priv = priv;
> +
> +	/* TODO implement sleep mode depending on RC */
> +	priv->sleeping = true;
> +
> +	return &priv->fe;
> +err:
> +	dbg("%s: failed=%d", __func__, ret);
> +	kfree(priv);
> +	return NULL;
> +}
> +EXPORT_SYMBOL(rtl2832_attach);
> +
> +static struct dvb_frontend_ops rtl2832_ops = {
> +	.delsys = { SYS_DVBT },
> +	.info = {
> +		.name = "Realtek RTL2832 (DVB-T)",
> +		.type               = FE_OFDM,
> +		.frequency_min      = 50000000,
> +		.frequency_max      = 862000000,
> +		.frequency_stepsize = 166667,
> +		.caps = FE_CAN_FEC_1_2 |
> +			FE_CAN_FEC_2_3 |
> +			FE_CAN_FEC_3_4 |
> +			FE_CAN_FEC_5_6 |
> +			FE_CAN_FEC_7_8 |
> +			FE_CAN_FEC_AUTO |
> +			FE_CAN_QPSK |
> +			FE_CAN_QAM_16 |
> +			FE_CAN_QAM_64 |
> +			FE_CAN_QAM_AUTO |
> +			FE_CAN_TRANSMISSION_MODE_AUTO |
> +			FE_CAN_GUARD_INTERVAL_AUTO |
> +			FE_CAN_HIERARCHY_AUTO |
> +			FE_CAN_RECOVER |
> +			FE_CAN_MUTE_TS
> +	},
> +
> +	.release = rtl2832_release,
> +
> +	.init = rtl2832_init,
> +	.sleep = rtl2832_sleep,
> +
> +	.get_tune_settings = rtl2832_get_tune_settings,
> +
> +	.set_frontend = rtl2832_set_frontend,
> +
> +	.read_status = rtl2832_read_status,
> +	.read_snr = rtl2832_read_snr,
> +	.read_ber = rtl2832_read_ber,
> +	.read_ucblocks = rtl2832_read_ucblocks,
> +	.read_signal_strength = rtl2832_read_signal_strength,
> +	.i2c_gate_ctrl = rtl2832_i2c_gate_ctrl,
> +};
> +
> +MODULE_AUTHOR("Thomas Mair <mair.thomas86@gmail.com>");
> +MODULE_DESCRIPTION("Realtek RTL2832 DVB-T demodulator driver");
> +MODULE_LICENSE("GPL");
> +MODULE_VERSION("0.1");
> diff --git a/drivers/media/dvb/frontends/rtl2832.h b/drivers/media/dvb/frontends/rtl2832.h
> new file mode 100644
> index 0000000..b16631a
> --- /dev/null
> +++ b/drivers/media/dvb/frontends/rtl2832.h
> @@ -0,0 +1,300 @@
> +/*
> + * Realtek RTL2832 DVB-T demodulator driver
> + *
> + * Copyright (C) 2012 Thomas Mair <thomas.mair86@gmail.com>
> + *
> + *    This program is free software; you can redistribute it and/or modify
> + *    it under the terms of the GNU General Public License as published by
> + *    the Free Software Foundation; either version 2 of the License, or
> + *    (at your option) any later version.
> + *
> + *    This program is distributed in the hope that it will be useful,
> + *    but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *    GNU General Public License for more details.
> + *
> + *    You should have received a copy of the GNU General Public License along
> + *    with this program; if not, write to the Free Software Foundation, Inc.,
> + *    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
> + */
> +
> +#ifndef RTL2832_H
> +#define RTL2832_H
> +
> +#include <linux/dvb/frontend.h>
> +
> +struct rtl2832_config {
> +	/*
> +	 * Demodulator I2C address.
> +	 */
> +	u8 i2c_addr;
> +
> +	/*
> +	 * Xtal frequency.
> +	 * Hz
> +	 * 4000000, 16000000, 25000000, 28800000
> +	 */
> +	u32 xtal;
> +
> +	/*
> +	 * IFs for all used modes.
> +	 * Hz
> +	 * 4570000, 4571429, 36000000, 36125000, 36166667, 44000000
> +	 */
> +	u32 if_dvbt;
> +
> +	/*
> +	 */
> +	u8 tuner;
> +};
> +
> +
> +#if defined(CONFIG_DVB_RTL2832) || \
> +	(defined(CONFIG_DVB_RTL2832_MODULE) && defined(MODULE))
> +extern struct dvb_frontend *rtl2832_attach(
> +	const struct rtl2832_config *cfg,
> +	struct i2c_adapter *i2c,
> +	u8 tuner
> +);
> +
> +extern struct i2c_adapter *rtl2832_get_tuner_i2c_adapter(
> +	struct dvb_frontend *fe
> +);
> +#else
> +static inline struct dvb_frontend *rtl2832_attach(
> +	const struct rtl2832_config *config,
> +	struct i2c_adapter *i2c
> +)
> +{
> +	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
> +	return NULL;
> +}
> +
> +static inline struct i2c_adapter *rtl2832_get_tuner_i2c_adapter(
> +	struct dvb_frontend *fe
> +)
> +{
> +	return NULL;
> +}
> +#endif
> +
> +
> +/* Demod register bit names */
> +enum DVBT_REG_BIT_NAME
> +{
> +	DVBT_SOFT_RST,
> +	DVBT_IIC_REPEAT,
> +	DVBT_TR_WAIT_MIN_8K,
> +	DVBT_RSD_BER_FAIL_VAL,
> +	DVBT_EN_BK_TRK,
> +	DVBT_REG_PI,
> +	DVBT_REG_PFREQ_1_0,
> +	DVBT_PD_DA8,
> +	DVBT_LOCK_TH,
> +	DVBT_BER_PASS_SCAL,
> +	DVBT_CE_FFSM_BYPASS,
> +	DVBT_ALPHAIIR_N,
> +	DVBT_ALPHAIIR_DIF,
> +	DVBT_EN_TRK_SPAN,
> +	DVBT_LOCK_TH_LEN,
> +	DVBT_CCI_THRE,
> +	DVBT_CCI_MON_SCAL,
> +	DVBT_CCI_M0,
> +	DVBT_CCI_M1,
> +	DVBT_CCI_M2,
> +	DVBT_CCI_M3,
> +	DVBT_SPEC_INIT_0,
> +	DVBT_SPEC_INIT_1,
> +	DVBT_SPEC_INIT_2,
> +	DVBT_AD_EN_REG,
> +	DVBT_AD_EN_REG1,
> +	DVBT_EN_BBIN,
> +	DVBT_MGD_THD0,
> +	DVBT_MGD_THD1,
> +	DVBT_MGD_THD2,
> +	DVBT_MGD_THD3,
> +	DVBT_MGD_THD4,
> +	DVBT_MGD_THD5,
> +	DVBT_MGD_THD6,
> +	DVBT_MGD_THD7,
> +	DVBT_EN_CACQ_NOTCH,
> +	DVBT_AD_AV_REF,	
> +	DVBT_PIP_ON,
> +	DVBT_SCALE1_B92,
> +	DVBT_SCALE1_B93,
> +	DVBT_SCALE1_BA7,
> +	DVBT_SCALE1_BA9,
> +	DVBT_SCALE1_BAA,
> +	DVBT_SCALE1_BAB,
> +	DVBT_SCALE1_BAC,
> +	DVBT_SCALE1_BB0,
> +	DVBT_SCALE1_BB1,
> +	DVBT_KB_P1,
> +	DVBT_KB_P2,
> +	DVBT_KB_P3,
> +	DVBT_OPT_AD
> +	DVBT_AD_AVI
> +	DVBT_AD_AVQ
> +	DVBT_K1_CR_STEP12,
> +	DVBT_TRK_KS_P2,
> +	DVBT_TRK_KS_I2,
> +	DVBT_TR_THD_SET2,
> +	DVBT_TRK_KC_P2,
> +	DVBT_TRK_KC_I2,
> +	DVBT_CR_THD_SET2,
> +	DVBT_PSET_IFFREQ,
> +	DVBT_SPEC_INV,
> +	DVBT_BW_INDEX,
> +	DVBT_RSAMP_RATIO,
> +	DVBT_CFREQ_OFF_RATIO,
> +	DVBT_FSM_STAGE,
> +	DVBT_RX_CONSTEL,
> +	DVBT_RX_HIER,
> +	DVBT_RX_C_RATE_LP,
> +	DVBT_RX_C_RATE_HP,
> +	DVBT_GI_IDX,
> +	DVBT_FFT_MODE_IDX,
> +	DVBT_RSD_BER_EST,
> +	DVBT_CE_EST_EVM,
> +	DVBT_RF_AGC_VAL,
> +	DVBT_IF_AGC_VAL,
> +	DVBT_DAGC_VAL,
> +	DVBT_SFREQ_OFF,
> +	DVBT_CFREQ_OFF,
> +	DVBT_POLAR_RF_AGC,
> +	DVBT_POLAR_IF_AGC,
> +	DVBT_AAGC_HOLD,
> +	DVBT_EN_RF_AGC,
> +	DVBT_EN_IF_AGC,
> +	DVBT_IF_AGC_MIN,
> +	DVBT_IF_AGC_MAX,
> +	DVBT_RF_AGC_MIN,
> +	DVBT_RF_AGC_MAX,
> +	DVBT_IF_AGC_MAN,
> +	DVBT_IF_AGC_MAN_VAL,
> +	DVBT_RF_AGC_MAN,
> +	DVBT_RF_AGC_MAN_VAL,
> +	DVBT_DAGC_TRG_VAL,
> +	DVBT_AGC_TARG_VAL,
> +	DVBT_LOOP_GAIN_3_0,
> +	DVBT_LOOP_GAIN_4,
> +	DVBT_VTOP,	
> +	DVBT_KRF,
> +	DVBT_AGC_TARG_VAL_0,
> +	DVBT_AGC_TARG_VAL_8_1,
> +	DVBT_AAGC_LOOP_GAIN,
> +	DVBT_LOOP_GAIN2_3_0,
> +	DVBT_LOOP_GAIN2_4,
> +	DVBT_LOOP_GAIN3,
> +	DVBT_VTOP1,
> +	DVBT_VTOP2,
> +	DVBT_VTOP3,
> +	DVBT_KRF1,
> +	DVBT_KRF2,
> +	DVBT_KRF3,
> +	DVBT_KRF4,
> +	DVBT_EN_GI_PGA,
> +	DVBT_THD_LOCK_UP,
> +	DVBT_THD_LOCK_DW,
> +	DVBT_THD_UP1,
> +	DVBT_THD_DW1,
> +	DVBT_INTER_CNT_LEN,
> +	DVBT_GI_PGA_STATE,
> +	DVBT_EN_AGC_PGA,
> +	DVBT_CKOUTPAR,
> +	DVBT_CKOUT_PWR,
> +	DVBT_SYNC_DUR,
> +	DVBT_ERR_DUR,
> +	DVBT_SYNC_LVL,
> +	DVBT_ERR_LVL,
> +	DVBT_VAL_LVL,
> +	DVBT_SERIAL,
> +	DVBT_SER_LSB,
> +	DVBT_CDIV_PH0,
> +	DVBT_CDIV_PH1,
> +	DVBT_MPEG_IO_OPT_2_2,
> +	DVBT_MPEG_IO_OPT_1_0,
> +	DVBT_CKOUTPAR_PIP,
> +	DVBT_CKOUT_PWR_PIP,
> +	DVBT_SYNC_LVL_PIP,
> +	DVBT_ERR_LVL_PIP,
> +	DVBT_VAL_LVL_PIP,
> +	DVBT_CKOUTPAR_PID,
> +	DVBT_CKOUT_PWR_PID,
> +	DVBT_SYNC_LVL_PID,
> +	DVBT_ERR_LVL_PID,
> +	DVBT_VAL_LVL_PID,
> +	DVBT_SM_PASS,
> +	DVBT_UPDATE_REG_2,
> +	DVBT_BTHD_P3,
> +	DVBT_BTHD_D3,
> +	DVBT_FUNC4_REG0,
> +	DVBT_FUNC4_REG1,
> +	DVBT_FUNC4_REG2,
> +	DVBT_FUNC4_REG3,
> +	DVBT_FUNC4_REG4,
> +	DVBT_FUNC4_REG5,
> +	DVBT_FUNC4_REG6,
> +	DVBT_FUNC4_REG7,
> +	DVBT_FUNC4_REG8,
> +	DVBT_FUNC4_REG9,
> +	DVBT_FUNC4_REG10,
> +	DVBT_FUNC5_REG0,
> +	DVBT_FUNC5_REG1,
> +	DVBT_FUNC5_REG2,
> +	DVBT_FUNC5_REG3,
> +	DVBT_FUNC5_REG4,
> +	DVBT_FUNC5_REG5,
> +	DVBT_FUNC5_REG6,
> +	DVBT_FUNC5_REG7,
> +	DVBT_FUNC5_REG8,
> +	DVBT_FUNC5_REG9,
> +	DVBT_FUNC5_REG10,
> +	DVBT_FUNC5_REG11,
> +	DVBT_FUNC5_REG12,
> +	DVBT_FUNC5_REG13,
> +	DVBT_FUNC5_REG14,
> +	DVBT_FUNC5_REG15,
> +	DVBT_FUNC5_REG16,
> +	DVBT_FUNC5_REG17,
> +	DVBT_FUNC5_REG18,
> +	DVBT_AD7_SETTING,
> +	DVBT_RSSI_R,
> +	DVBT_ACI_DET_IND,
> +	DVBT_REG_MON,
> +	DVBT_REG_MONSEL,
> +	DVBT_REG_GPE,
> +	DVBT_REG_GPO,
> +	DVBT_REG_4MSEL,
> +	DVBT_TEST_REG_1,
> +	DVBT_TEST_REG_2,
> +	DVBT_TEST_REG_3,
> +	DVBT_TEST_REG_4,
> +	DVBT_REG_BIT_NAME_ITEM_TERMINATOR,
> +};
> +
> +
> +/* Register table length */
> +#define RTL2832_REG_TABLE_LEN	DVBT_REG_BIT_NAME_ITEM_TERMINATOR
> +
> +typedef struct
> +{
> +	u8 page;
> +	u8 start_address;
> +	u8 msb;
> +	u8 lsb;
> +}
> +rtl2832_reg_entry;
> +
> +typedef struct
> +{
> +	int reg;
> +	u32 value;
> +}
> +rtl2832_reg_value;
> +
> +
> +
> +
> +
> +#endif /* RTL2832_H */
> diff --git a/drivers/media/dvb/frontends/rtl2832_priv.h b/drivers/media/dvb/frontends/rtl2832_priv.h
> new file mode 100644
> index 0000000..2f591c6
> --- /dev/null
> +++ b/drivers/media/dvb/frontends/rtl2832_priv.h
> @@ -0,0 +1,60 @@
> +/*
> + * Realtek RTL2832 DVB-T demodulator driver
> + *
> + * Copyright (C) 2012 Thomas Mair <thomas.mair86@gmail.com>
> + *
> + *    This program is free software; you can redistribute it and/or modify
> + *    it under the terms of the GNU General Public License as published by
> + *    the Free Software Foundation; either version 2 of the License, or
> + *    (at your option) any later version.
> + *
> + *    This program is distributed in the hope that it will be useful,
> + *    but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *    GNU General Public License for more details.
> + *
> + *    You should have received a copy of the GNU General Public License along
> + *    with this program; if not, write to the Free Software Foundation, Inc.,
> + *    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
> + */
> +
> +#ifndef RTL2832_PRIV_H
> +#define RTL2832_PRIV_H
> +
> +#include "dvb_frontend.h"
> +#include "rtl2832.h"
> +
> +#define LOG_PREFIX "rtl2832"
> +
> +#undef dbg
> +#define dbg(f, arg...) \
> +	if (rtl2832_debug) \
> +		printk(KERN_INFO            LOG_PREFIX": " f "\n" , ## arg)
> +#undef err
> +#define err(f, arg...)  printk(KERN_ERR     LOG_PREFIX": " f "\n" , ## arg)
> +#undef info
> +#define info(f, arg...) printk(KERN_INFO    LOG_PREFIX": " f "\n" , ## arg)
> +#undef warn
> +#define warn(f, arg...) printk(KERN_WARNING LOG_PREFIX": " f "\n" , ## arg)
> +
> +struct rtl2832_priv {
> +	struct i2c_adapter *i2c;
> +	struct dvb_frontend fe;
> +	struct rtl2832_config cfg;
> +
> +	bool i2c_gate_state;
> +	bool sleeping;
> +
> +	u32 xtal;
> +
> +	u8 tuner;
> +	u8 page; /* active register page */
> +};
> +
> +struct rtl2832_reg_val_mask {
> +	u16 reg;
> +	u8  val;
> +	u8  mask;
> +};
> +
> +#endif /* RTL2832_PRIV_H */

OK, thanks!

This patch, 'v2-rtl2832-h.patch' correct make errors:
..
  CC [M]  /tmp/media_build/v4l/dvb-usb-remote.o
In file included from /tmp/media_build/v4l/rtl28xxu.c:26:0:
/tmp/media_build/v4l/rtl2832.h:136:2: error: expected ',' or '}' before
'DVBT_AD_AVI'
/tmp/media_build/v4l/rtl28xxu.c:388:2: error: unknown field 'ts_mode'
specified in initializer
/tmp/media_build/v4l/rtl28xxu.c:389:2: error: unknown field 'spec_inv'
specified in initializer
/tmp/media_build/v4l/rtl28xxu.c:391:2: error: unknown field 'vtop'
specified in initializer
/tmp/media_build/v4l/rtl28xxu.c:392:2: error: unknown field 'krf'
specified in initializer
/tmp/media_build/v4l/rtl28xxu.c:392:2: warning: excess elements in
struct initializer [enabled by default]
/tmp/media_build/v4l/rtl28xxu.c:392:2: warning: (near initialization for
'rtl28xxu_rtl2832_fc0012_config') [enabled by default]
/tmp/media_build/v4l/rtl28xxu.c:393:2: error: unknown field
'agc_targ_val' specified in initializer
/tmp/media_build/v4l/rtl28xxu.c:393:2: warning: excess elements in
struct initializer [enabled by default]
/tmp/media_build/v4l/rtl28xxu.c:393:2: warning: (near initialization for
'rtl28xxu_rtl2832_fc0012_config') [enabled by default]
make[3]: *** [/tmp/media_build/v4l/rtl28xxu.o] Error 1
make[3]: *** Waiting for unfinished jobs....
make[2]: *** [_module_/tmp/media_build/v4l] Error 2
make[2]: Leaving directory `/usr/src/kernels/3.3.2-6.fc16.x86_64'
make[1]: *** [default] Error 2
make[1]: Leaving directory `/tmp/media_build/v4l'
make: *** [all] Error 2


rgds,
poma

--------------080705040103070306060800
Content-Type: text/x-patch;
 name="v2-rtl2832-h.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="v2-rtl2832-h.patch"

--- v2-add-support-for-DeLOCK-USB-2.0-DVB-T-Receiver-61744.patch	2012-05-01 08:10:33.000000000 +0200
+++ v2-add-support-for-DeLOCK-USB-2.0-DVB-T-Receiver-61744-corr.patch	2012-05-01 08:08:03.000000000 +0200
@@ -2187,7 +2187,7 @@
 index 0000000..b16631a
 --- /dev/null
 +++ b/drivers/media/dvb/frontends/rtl2832.h
-@@ -0,0 +1,300 @@
+@@ -0,0 +1,322 @@
 +/*
 + * Realtek RTL2832 DVB-T demodulator driver
 + *
@@ -2227,6 +2227,16 @@
 +	u32 xtal;
 +
 +	/*
++	 * TS output mode.
++	 */
++	u8 ts_mode;
++
++	/*
++	 * Spectrum inversion.
++	 */
++	bool spec_inv;
++
++	/*
 +	 * IFs for all used modes.
 +	 * Hz
 +	 * 4570000, 4571429, 36000000, 36125000, 36166667, 44000000
@@ -2235,6 +2245,18 @@
 +
 +	/*
 +	 */
++	u8 vtop;
++
++	/*
++	 */
++	u8 krf;
++
++	/*
++	 */
++	u8 agc_targ_val;
++
++	/*
++	 */
 +	u8 tuner;
 +};
 +
@@ -2322,9 +2344,9 @@
 +	DVBT_KB_P1,
 +	DVBT_KB_P2,
 +	DVBT_KB_P3,
-+	DVBT_OPT_AD
-+	DVBT_AD_AVI
-+	DVBT_AD_AVQ
++	DVBT_OPT_ADC_IQ,
++	DVBT_AD_AVI,
++	DVBT_AD_AVQ,
 +	DVBT_K1_CR_STEP12,
 +	DVBT_TRK_KS_P2,
 +	DVBT_TRK_KS_I2,

--------------080705040103070306060800--
