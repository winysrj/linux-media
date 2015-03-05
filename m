Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:44595 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754442AbbCEIyU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 5 Mar 2015 03:54:20 -0500
Date: Thu, 5 Mar 2015 05:54:14 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Kozlov Sergey <serjk@netup.ru>
Cc: linux-media@vger.kernel.org, aospan1@gmail.com
Subject: Re: [PATCH 1/5] [media] horus3a: Sony Horus3A DVB-S/S2 tuner driver
Message-ID: <20150305055414.1b02a0c1@recife.lan>
In-Reply-To: <20150202092806.7B4D81BC32CD@debian>
References: <20150202092806.7B4D81BC32CD@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 02 Feb 2015 12:22:32 +0300
Kozlov Sergey <serjk@netup.ru> escreveu:

> 
> DVB-S/S2 frontend driver for Sony Horus3A (CXD2832AER) chip
> 
> Signed-off-by: Kozlov Sergey <serjk@netup.ru>
> ---
>  MAINTAINERS                           |    9 +
>  drivers/media/dvb-frontends/Kconfig   |    7 +
>  drivers/media/dvb-frontends/Makefile  |    1 +
>  drivers/media/dvb-frontends/horus3a.c |  429 +++++++++++++++++++++++++++++++++
>  drivers/media/dvb-frontends/horus3a.h |   53 ++++
>  5 files changed, 499 insertions(+)
>  create mode 100644 drivers/media/dvb-frontends/horus3a.c
>  create mode 100644 drivers/media/dvb-frontends/horus3a.h
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index ddb9ac8..a3a1767 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -4365,6 +4365,15 @@ W:	http://linuxtv.org
>  S:	Odd Fixes
>  F:	drivers/media/usb/hdpvr/
>  
> +HORUS3A MEDIA DRIVER

Not a big issue, but could you please rename it to:
	MEDIA DRIVERS FOR HORUS3A

We're trying to better organize the media entries at MAINTAINERS, at
least for the new drivers.

> +M:	Sergey Kozlov <serjk@netup.ru>
> +L:	linux-media@vger.kernel.org
> +W:	http://linuxtv.org/
> +W:	http://netup.tv/
> +T:	git git://linuxtv.org/media_tree.git
> +S:	Supported
> +F:	drivers/media/dvb-frontends/horus3a*
> +
>  HWPOISON MEMORY FAILURE HANDLING
>  M:	Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
>  L:	linux-mm@kvack.org
> diff --git a/drivers/media/dvb-frontends/Kconfig b/drivers/media/dvb-frontends/Kconfig
> index 6c75418..c2c157b 100644
> --- a/drivers/media/dvb-frontends/Kconfig
> +++ b/drivers/media/dvb-frontends/Kconfig
> @@ -796,6 +796,13 @@ config DVB_AF9033
>  	depends on DVB_CORE && I2C
>  	default m if !MEDIA_SUBDRV_AUTOSELECT
>  
> +config DVB_HORUS3A
> +	tristate "Sony Horus3A tuner"
> +	depends on DVB_CORE && I2C
> +	default m if !MEDIA_SUBDRV_AUTOSELECT
> +	help
> +	  Say Y when you want to support this frontend.
> +
>  comment "Tools to develop new frontends"
>  
>  config DVB_DUMMY_FE
> diff --git a/drivers/media/dvb-frontends/Makefile b/drivers/media/dvb-frontends/Makefile
> index ba59df6..3aa05f3 100644
> --- a/drivers/media/dvb-frontends/Makefile
> +++ b/drivers/media/dvb-frontends/Makefile
> @@ -116,3 +116,4 @@ obj-$(CONFIG_DVB_M88RS2000) += m88rs2000.o
>  obj-$(CONFIG_DVB_AF9033) += af9033.o
>  obj-$(CONFIG_DVB_AS102_FE) += as102_fe.o
>  obj-$(CONFIG_DVB_TC90522) += tc90522.o
> +obj-$(CONFIG_DVB_HORUS3A) += horus3a.o
> diff --git a/drivers/media/dvb-frontends/horus3a.c b/drivers/media/dvb-frontends/horus3a.c
> new file mode 100644
> index 0000000..aaf61d5ef
> --- /dev/null
> +++ b/drivers/media/dvb-frontends/horus3a.c
> @@ -0,0 +1,429 @@
> +/*
> + * horus3a.h
> + *
> + * Sony Horus3A DVB-S/S2 tuner driver
> + *
> + * Copyright 2012 Sony Corporation
> + * Copyright (C) 2014 NetUP Inc.
> + * Copyright (C) 2014 Sergey Kozlov <serjk@netup.ru>
> + * Copyright (C) 2014 Abylay Ospan <aospan@netup.ru>
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
> +  */
> +
> +#include <linux/slab.h>
> +#include <linux/module.h>
> +#include <linux/dvb/frontend.h>
> +#include <linux/types.h>
> +#include "horus3a.h"
> +#include "dvb_frontend.h"
> +
> +static int debug;
> +module_param(debug, int, 0644);
> +
> +#define dprintk(args...) \
> +	do { \
> +		if (debug) \
> +			dev_dbg(&priv->i2c->dev, args); \
> +	} while (0)

This is not very nice, as, in order to enable debug, both this parameter
and dynamic printk should be enabled via /sys/kernel/debug/dynamic_debug.

Just use dev_dbg() directly.

> +
> +enum horus3a_state {
> +	STATE_UNKNOWN,
> +	STATE_SLEEP,
> +	STATE_ACTIVE
> +};
> +
> +struct horus3a_priv {
> +	u32			frequency;
> +	u8			i2c_address;
> +	struct i2c_adapter	*i2c;
> +	enum horus3a_state	state;
> +	void			*set_tuner_data;
> +	int			(*set_tuner)(void *, int);
> +};
> +
> +static void horus3a_i2c_debug(struct horus3a_priv *priv,
> +		u8 reg, u8 write, const u8 *data, u32 len)
> +{
> +	u32 i;
> +	u8 buf[128];
> +	int offst = 0;
> +
> +	for (i = 0; i < len; i++) {
> +		offst += snprintf(buf + offst, sizeof(buf) - offst, " %02x",
> +			data[i]);
> +		if (offst >= sizeof(buf) - 1)
> +			break;
> +	}

There are already Kernel functions to produce hexdumps.

In this case, were we want to allow the user to dynamically enable this
debug function, the proper call would be dynamic_hex_dump().

> +	dprintk("horus3a: I2C %s 0x%02x [%s ]\n",
> +		(write == 0 ? "read" : "write"), reg, buf);
> +}
> +
> +static int horus3a_write_regs(struct horus3a_priv *priv,
> +		u8 reg, const u8 *data, u32 len)
> +{
> +	int ret;
> +	u8 buf[len+1];
> +	struct i2c_msg msg[1] = {
> +		{
> +			.addr = priv->i2c_address,
> +			.flags = 0,
> +			.len = sizeof(buf),
> +			.buf = buf,
> +		}
> +	};
> +
> +	horus3a_i2c_debug(priv, reg, 1, data, len);
> +	buf[0] = reg;
> +	memcpy(&buf[1], data, len);
> +
> +	ret = i2c_transfer(priv->i2c, msg, 1);
> +	if (ret == 1) {
> +		ret = 0;
> +	} else {
> +		dev_warn(&priv->i2c->dev,
> +			"%s: i2c wr failed=%d reg=%02x len=%d\n",
> +			KBUILD_MODNAME, ret, reg, len);
> +		ret = -EREMOTEIO;
> +	}
> +	return ret;

Actually, if ret == 0, nothing was transferred. Also, the best is to
preserve whatever error code is received from i2c_transfer().

So, the error code handling should be, instead, something like:

	if (ret >= 0 && ret != 1)
		ret = -EREMOTEIO;

	if (ret < 0) {
		dev_warn(&priv->i2c->dev,
			"%s: i2c wr failed=%d reg=%02x len=%d\n",
			KBUILD_MODNAME, ret, reg, len);
		return ret;
	}
	return 0;

> +}
> +
> +static int horus3a_write_reg(struct horus3a_priv *priv, u8 reg, u8 val)
> +{
> +	return horus3a_write_regs(priv, reg, &val, 1);
> +}
> +
> +static int horus3a_enter_power_save(struct horus3a_priv *priv)
> +{
> +	u8 data[2];
> +
> +	dprintk("%s()\n", __func__);
> +	if (priv->state == STATE_SLEEP)
> +		return 0;
> +	/* IQ Generator disable */
> +	horus3a_write_reg(priv, 0x2a, 0x79);
> +	/* MDIV_EN = 0 */
> +	horus3a_write_reg(priv, 0x29, 0x70);
> +	/* VCO disable preparation */
> +	horus3a_write_reg(priv, 0x28, 0x3e);
> +	/* VCO buffer disable */
> +	horus3a_write_reg(priv, 0x2a, 0x19);
> +	/* VCO calibration disable */
> +	horus3a_write_reg(priv, 0x1c, 0x00);
> +	/* Power save setting (xtal is not stopped) */
> +	data[0] = 0xC0;
> +	/* LNA is Disabled */
> +	data[1] = 0xA7;
> +	/* 0x11 - 0x12 */
> +	horus3a_write_regs(priv, 0x11, data, sizeof(data));
> +	priv->state = STATE_SLEEP;
> +	return 0;
> +}
> +
> +static int horus3a_leave_power_save(struct horus3a_priv *priv)
> +{
> +	u8 data[2];
> +
> +	dprintk("%s()\n", __func__);
> +	if (priv->state == STATE_ACTIVE)
> +		return 0;
> +	/* Leave power save */
> +	data[0] = 0x00;
> +	/* LNA is Disabled */
> +	data[1] = 0xa7;
> +	/* 0x11 - 0x12 */
> +	horus3a_write_regs(priv, 0x11, data, sizeof(data));
> +	/* VCO buffer enable */
> +	horus3a_write_reg(priv, 0x2a, 0x79);
> +	/* VCO calibration enable */
> +	horus3a_write_reg(priv, 0x1c, 0xc0);
> +	/* MDIV_EN = 1 */
> +	horus3a_write_reg(priv, 0x29, 0x71);
> +	usleep_range(5000, 7000);
> +	priv->state = STATE_ACTIVE;
> +	return 0;
> +}
> +
> +static int horus3a_init(struct dvb_frontend *fe)
> +{
> +	struct horus3a_priv *priv = fe->tuner_priv;
> +
> +	dprintk("%s()\n", __func__);
> +	return 0;
> +}
> +
> +static int horus3a_release(struct dvb_frontend *fe)
> +{
> +	struct horus3a_priv *priv = fe->tuner_priv;
> +
> +	dprintk("%s()\n", __func__);
> +	kfree(fe->tuner_priv);
> +	fe->tuner_priv = NULL;
> +	return 0;
> +}
> +
> +static int horus3a_sleep(struct dvb_frontend *fe)
> +{
> +	struct horus3a_priv *priv = fe->tuner_priv;
> +
> +	dprintk("%s()\n", __func__);
> +	horus3a_enter_power_save(priv);
> +	return 0;
> +}
> +
> +static int horus3a_set_params(struct dvb_frontend *fe)
> +{
> +	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
> +	struct horus3a_priv *priv = fe->tuner_priv;
> +	u32 frequency = p->frequency;
> +	u32 symbol_rate = p->symbol_rate/1000;
> +	u8 mixdiv = 0;
> +	u8 mdiv = 0;
> +	u32 ms = 0;
> +	u8 f_ctl = 0;
> +	u8 g_ctl = 0;
> +	u8 fc_lpf = 0;
> +	u8 data[5];
> +
> +	dprintk("%s(): frequency %dkHz symbol_rate %dksps\n",
> +		__func__, frequency, symbol_rate);
> +	if (priv->set_tuner)
> +		priv->set_tuner(priv->set_tuner_data, 0);
> +	if (priv->state == STATE_SLEEP)
> +		horus3a_leave_power_save(priv);
> +
> +	/* frequency should be X MHz (X : integer) */
> +	frequency = ((frequency + 500) / 1000) * 1000;

Please use DIV_ROUND_CLOSEST(). The rounding functions are declared
at include/linux/kernel.h.

> +	if (frequency <= 1155000) {
> +		mixdiv = 4;
> +		mdiv = 1;
> +	} else {
> +		mixdiv = 2;
> +		mdiv = 0;
> +	}
> +	/* Assumed that fREF == 1MHz (1000kHz) */
> +	ms = ((frequency * mixdiv)/2 + 1000/2) / 1000; /* Round */

Please use DIV_ROUND_CLOSEST().

> +	if (ms > 0x7FFF) { /* 15 bit */
> +		dev_err(&priv->i2c->dev, "horus3a: invalid frequency %d\n",
> +			frequency);
> +		return -EINVAL;
> +	}
> +	if (frequency < 975000) {
> +		/* F_CTL=11100 G_CTL=001 */
> +		f_ctl = 0x1C;
> +		g_ctl = 0x01;
> +	} else if (frequency < 1050000) {
> +		/* F_CTL=11000 G_CTL=010 */
> +		f_ctl = 0x18;
> +		g_ctl = 0x02;
> +	} else if (frequency < 1150000) {
> +		/* F_CTL=10100 G_CTL=010 */
> +		f_ctl = 0x14;
> +		g_ctl = 0x02;
> +	} else if (frequency < 1250000) {
> +		/* F_CTL=10000 G_CTL=011 */
> +		f_ctl = 0x10;
> +		g_ctl = 0x03;
> +	} else if (frequency < 1350000) {
> +		/* F_CTL=01100 G_CTL=100 */
> +		f_ctl = 0x0C;
> +		g_ctl = 0x04;
> +	} else if (frequency < 1450000) {
> +		/* F_CTL=01010 G_CTL=100 */
> +		f_ctl = 0x0A;
> +		g_ctl = 0x04;
> +	} else if (frequency < 1600000) {
> +		/* F_CTL=00111 G_CTL=101 */
> +		f_ctl = 0x07;
> +		g_ctl = 0x05;
> +	} else if (frequency < 1800000) {
> +		/* F_CTL=00100 G_CTL=010 */
> +		f_ctl = 0x04;
> +		g_ctl = 0x02;
> +	} else if (frequency < 2000000) {
> +		/* F_CTL=00010 G_CTL=001 */
> +		f_ctl = 0x02;
> +		g_ctl = 0x01;
> +	} else {
> +		/* F_CTL=00000 G_CTL=000 */
> +		f_ctl = 0x00;
> +		g_ctl = 0x00;
> +	}
> +	/* LPF cutoff frequency setting */
> +	switch (p->delivery_system) {
> +	case SYS_DVBS:
> +		/*
> +		rolloff = 0.35
> +		SR <= 4.3
> +		fc_lpf = 5
> +		4.3 < SR <= 10
> +		fc_lpf = SR * (1 + rolloff) / 2 + SR / 2 =
> +			SR * 1.175 = SR * (47/40)
> +		10 < SR
> +		fc_lpf = SR * (1 + rolloff) / 2 + 5 =
> +			SR * 0.675 + 5 = SR * (27/40) + 5
> +		NOTE: The result should be round up.
> +		*/

In order to follow Kernel CodingStyle, multi-line comments
should look like:
	/*
	 * line 1
	 * line 2
	 * line 3
	 */

> +		if (symbol_rate <= 4300)
> +			fc_lpf = 5;
> +		else if (symbol_rate <= 10000)
> +			fc_lpf = (u8)((symbol_rate * 47 +
> +					(40000-1)) / 40000);

Please use Kernel function DIV_ROUND_UP. That makes the rounding easier
to read. Same on other parts of the code below.

> +		else
> +			fc_lpf = (u8)((symbol_rate * 27 +
> +					(40000-1)) / 40000 + 5);
> +		/* 5 <= fc_lpf <= 36 */
> +		if (fc_lpf > 36)
> +			fc_lpf = 36;
> +		break;
> +	case SYS_DVBS2:
> +		/*
> +		rolloff = 0.2
> +		SR <= 4.5
> +		fc_lpf = 5
> +		4.5 < SR <= 10
> +		fc_lpf = SR * (1 + rolloff) / 2 + SR / 2 =
> +			SR * 1.1 = SR * (11/10)
> +		10 < SR
> +		fc_lpf = SR * (1 + rolloff) / 2 + 5 =
> +			SR * 0.6 + 5 = SR * (3/5) + 5
> +		NOTE: The result should be round up.
> +		*/

In order to follow Kernel CodingStyle, multi-line comments
should look like:
	/*
	 * line 1
	 * line 2
	 * line 3
	 */

> +		if (symbol_rate <= 4500)
> +			fc_lpf = 5;
> +		else if (symbol_rate <= 10000)
> +			fc_lpf = (u8)((symbol_rate * 11 +
> +				(10000-1)) / 10000);

Please use Kernel function DIV_ROUND_UP.

> +		else
> +			fc_lpf = (u8)((symbol_rate * 3 +
> +				(5000-1)) / 5000 + 5);

Please use Kernel function DIV_ROUND_UP.

> +		/* 5 <= fc_lpf <= 36 is valid */
> +		if (fc_lpf > 36)
> +			fc_lpf = 36;
> +		break;
> +	default:
> +		dev_err(&priv->i2c->dev,
> +			"horus3a: invalid delivery system %d\n",
> +			p->delivery_system);
> +		return -EINVAL;
> +	}
> +	/* 0x00 - 0x04 */
> +	data[0] = (u8)((ms >> 7) & 0xFF);
> +	data[1] = (u8)((ms << 1) & 0xFF);
> +	data[2] = 0x00;
> +	data[3] = 0x00;
> +	data[4] = (u8)(mdiv << 7);
> +	horus3a_write_regs(priv, 0x00, data, sizeof(data));
> +	/* Write G_CTL, F_CTL */
> +	horus3a_write_reg(priv, 0x09, (u8)((g_ctl << 5) | f_ctl));
> +	/* Write LPF cutoff frequency */
> +	horus3a_write_reg(priv, 0x37, (u8)(0x80 | (fc_lpf << 1)));
> +	/* Start Calibration */
> +	horus3a_write_reg(priv, 0x05, 0x80);
> +	/* IQ Generator enable */
> +	horus3a_write_reg(priv, 0x2a, 0x7b);
> +	/* tuner stabilization time */
> +	msleep(60);
> +	/* Store tuned frequency to the struct */
> +	priv->frequency = ms * 2 * 1000 / mixdiv;
> +	return 0;
> +}
> +
> +static int horus3a_get_frequency(struct dvb_frontend *fe, u32 *frequency)
> +{
> +	struct horus3a_priv *priv = fe->tuner_priv;
> +	*frequency = priv->frequency;
> +	return 0;
> +}
> +
> +static struct dvb_tuner_ops horus3a_tuner_ops = {
> +	.info = {
> +		.name = "Sony Horus3a",
> +		.frequency_min = 950000,
> +		.frequency_max = 2150000,
> +		.frequency_step = 1000,
> +	},
> +	.init = horus3a_init,
> +	.release = horus3a_release,
> +	.sleep = horus3a_sleep,
> +	.set_params = horus3a_set_params,
> +	.get_frequency = horus3a_get_frequency,
> +};
> +
> +struct dvb_frontend *horus3a_attach(struct dvb_frontend *fe,
> +					const struct horus3a_config *config,
> +					struct i2c_adapter *i2c)
> +{
> +	u8 buf[3], val;
> +	struct horus3a_priv *priv = NULL;
> +
> +	priv = kzalloc(sizeof(struct horus3a_priv), GFP_KERNEL);
> +	if (priv == NULL)
> +		return NULL;
> +	priv->i2c_address = (config->i2c_address >> 1);
> +	priv->i2c = i2c;
> +	priv->set_tuner_data = config->set_tuner_priv;
> +	priv->set_tuner = config->set_tuner_callback;
> +
> +	if (fe->ops.i2c_gate_ctrl)
> +		fe->ops.i2c_gate_ctrl(fe, 1);
> +
> +	/* wait 4ms after power on */
> +	usleep_range(4000, 6000);
> +	/* IQ Generator disable */
> +	horus3a_write_reg(priv, 0x2a, 0x79);
> +	/* REF_R = Xtal Frequency */
> +	buf[0] = config->xtal_freq_mhz;
> +	buf[1] = config->xtal_freq_mhz;
> +	buf[2] = 0;
> +	/* 0x6 - 0x8 */
> +	horus3a_write_regs(priv, 0x6, buf, 3);
> +	/* IQ Out = Single Ended */
> +	horus3a_write_reg(priv, 0x0a, 0x40);
> +	switch (config->xtal_freq_mhz) {
> +	case 27:
> +		val = 0x1f;
> +		break;
> +	case 24:
> +		val = 0x10;
> +		break;
> +	case 16:
> +		val = 0xc;
> +		break;
> +	default:
> +		val = 0;
> +		dev_warn(&priv->i2c->dev,
> +			"horus3a: invalid xtal frequency %dMHz\n",
> +			config->xtal_freq_mhz);
> +		break;
> +	}
> +	val <<= 2;
> +	horus3a_write_reg(priv, 0x0e, val);
> +	horus3a_enter_power_save(priv);
> +	usleep_range(3000, 5000);
> +
> +	if (fe->ops.i2c_gate_ctrl)
> +		fe->ops.i2c_gate_ctrl(fe, 0);
> +
> +	memcpy(&fe->ops.tuner_ops, &horus3a_tuner_ops,
> +				sizeof(struct dvb_tuner_ops));
> +	fe->tuner_priv = priv;
> +	dev_info(&priv->i2c->dev,
> +		"Sony HORUS3A attached on addr=%x at I2C adapter %p\n",
> +		priv->i2c_address, priv->i2c);
> +	return fe;
> +}
> +EXPORT_SYMBOL(horus3a_attach);
> +
> +MODULE_DESCRIPTION("Sony HORUS3A sattelite tuner driver");
> +MODULE_AUTHOR("Sergey Kozlov <serjk@netup.ru>");
> +MODULE_LICENSE("GPL");
> diff --git a/drivers/media/dvb-frontends/horus3a.h b/drivers/media/dvb-frontends/horus3a.h
> new file mode 100644
> index 0000000..9cd64b6
> --- /dev/null
> +++ b/drivers/media/dvb-frontends/horus3a.h
> @@ -0,0 +1,53 @@
> +/*
> + * horus3a.h
> + *
> + * Sony Horus3A DVB-S/S2 tuner driver
> + *
> + * Copyright 2012 Sony Corporation
> + * Copyright (C) 2014 NetUP Inc.
> + * Copyright (C) 2014 Sergey Kozlov <serjk@netup.ru>
> + * Copyright (C) 2014 Abylay Ospan <aospan@netup.ru>
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
> +  */
> +
> +#ifndef __DVB_HORUS3A_H__
> +#define __DVB_HORUS3A_H__
> +
> +#include <linux/kconfig.h>
> +#include <linux/dvb/frontend.h>
> +#include <linux/i2c.h>
> +
> +struct horus3a_config {
> +	/* default is 0xc0 */
> +	u8	i2c_address;
> +	/* default is 16 MHz */
> +	u8	xtal_freq_mhz;
> +	/* set tuner function */
> +	void	*set_tuner_priv;
> +	int	(*set_tuner_callback)(void *, int);
> +};
> +
> +#if IS_ENABLED(CONFIG_DVB_HORUS3A)
> +extern struct dvb_frontend *horus3a_attach(struct dvb_frontend *fe,
> +					const struct horus3a_config *config,
> +					struct i2c_adapter *i2c);
> +#else
> +static inline struct dvb_frontend *horus3a_attach(
> +					const struct cxd2820r_config *config,
> +					struct i2c_adapter *i2c)
> +{
> +	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
> +	return NULL;
> +}
> +#endif
> +
> +#endif
