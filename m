Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:35060 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753862Ab2EHGby convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 May 2012 02:31:54 -0400
Received: by bkcji2 with SMTP id ji2so4291213bkc.19
        for <linux-media@vger.kernel.org>; Mon, 07 May 2012 23:31:53 -0700 (PDT)
From: "Igor M. Liplianin" <liplianin@me.by>
To: Konstantin Dimitrov <kosio.dimitrov@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 2/3] ts2020: add ts2020 tuner driver
Date: Tue, 08 May 2012 09:32:01 +0300
Message-ID: <14221045.uNfrtNFNKi@useri>
In-Reply-To: <CAF0Ff2=_mLSCvnE2mrwGHuJRWfJ0mGowrNxEXhc0PioiuT9gEw@mail.gmail.com>
References: <CAF0Ff2=_mLSCvnE2mrwGHuJRWfJ0mGowrNxEXhc0PioiuT9gEw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 7 мая 2012 00:22:30 Konstantin Dimitrov wrote:
> add separate ts2020 tuner driver
> 
> Signed-off-by: Konstantin Dimitrov <kosio.dimitrov@gmail.com>
> 
> --- a/linux/drivers/media/dvb/frontends/Kconfig	2012-04-20
> 06:45:55.000000000 +0300
> +++ b/linux/drivers/media/dvb/frontends/Kconfig	2012-05-07
> 00:58:26.888543350 +0300
> @@ -221,6 +221,13 @@
>  	help
>  	  A DVB-S tuner module. Say Y when you want to support this frontend.
> 
> +config DVB_TS2020
> +	tristate "Montage Tehnology TS2020 based tuners"
> +	depends on DVB_CORE && I2C
> +	default m if DVB_FE_CUSTOMISE
> +	help
> +	  A DVB-S/S2 silicon tuner. Say Y when you want to support this tuner.
> +
>  config DVB_DS3000
>  	tristate "Montage Tehnology DS3000 based"
>  	depends on DVB_CORE && I2C
> --- a/linux/drivers/media/dvb/frontends/Makefile	2012-04-20
> 06:45:55.000000000 +0300
> +++ b/linux/drivers/media/dvb/frontends/Makefile	2012-05-07
> 00:54:44.624546145 +0300
> @@ -87,6 +87,7 @@
>  obj-$(CONFIG_DVB_EC100) += ec100.o
>  obj-$(CONFIG_DVB_HD29L2) += hd29l2.o
>  obj-$(CONFIG_DVB_DS3000) += ds3000.o
> +obj-$(CONFIG_DVB_TS2020) += ts2020.o
>  obj-$(CONFIG_DVB_MB86A16) += mb86a16.o
>  obj-$(CONFIG_DVB_MB86A20S) += mb86a20s.o
>  obj-$(CONFIG_DVB_IX2505V) += ix2505v.o
> --- a/linux/drivers/media/dvb/frontends/ts2020.h	2012-05-07
> 01:36:49.876514403 +0300
> +++ b/linux/drivers/media/dvb/frontends/ts2020.h	2012-05-07
> 01:12:54.148532449 +0300
> @@ -0,0 +1,68 @@
> +/*
> +    Montage Technology TS2020 - Silicon Tuner driver
> +    Copyright (C) 2009-2012 Konstantin Dimitrov <kosio.dimitrov@gmail.com>
> +
> +    Copyright (C) 2009-2012 TurboSight.com
> +
> +    This program is free software; you can redistribute it and/or modify
> +    it under the terms of the GNU General Public License as published by
> +    the Free Software Foundation; either version 2 of the License, or
> +    (at your option) any later version.
> +
> +    This program is distributed in the hope that it will be useful,
> +    but WITHOUT ANY WARRANTY; without even the implied warranty of
> +    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +    GNU General Public License for more details.
> +
> +    You should have received a copy of the GNU General Public License
> +    along with this program; if not, write to the Free Software
> +    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> + */
> +
> +#ifndef TS2020_H
> +#define TS2020_H
> +
> +#include <linux/dvb/frontend.h>
> +
> +struct ts2020_config {
> +	u8 tuner_address;
> +};
> +
> +struct ts2020_state {
> +	struct i2c_adapter *i2c;
> +	const struct ts2020_config *config;
> +	struct dvb_frontend *frontend;
> +	int status;
> +};
> +
> +#if defined(CONFIG_DVB_TS2020) || \
> +	(defined(CONFIG_DVB_TS2020_MODULE) && defined(MODULE))
> +
> +extern struct dvb_frontend *ts2020_attach(
> +	struct dvb_frontend *fe,
> +	const struct ts2020_config *config,
> +	struct i2c_adapter *i2c);
> +
> +extern int ts2020_get_signal_strength(
> +	struct dvb_frontend *fe,
> +	u16 *strength);
> +#else
> +static inline struct dvb_frontend *ts2020_attach(
> +	struct dvb_frontend *fe,
> +	const struct ts2020_config *config,
> +	struct i2c_adapter *i2c)
> +{
> +	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
> +	return NULL;
> +}
> +
> +static inline int ts2020_get_signal_strength(
> +	struct dvb_frontend *fe,
> +	u16 *strength)
> +{
> +	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
> +	return NULL;
> +}
> +#endif
> +
> +#endif /* TS2020_H */
> --- a/linux/drivers/media/dvb/frontends/ts2020_cfg.h	2012-05-07
> 01:36:59.836514279 +0300
> +++ b/linux/drivers/media/dvb/frontends/ts2020_cfg.h	2012-05-07
> 01:12:56.248532422 +0300
> @@ -0,0 +1,64 @@
> +/*
> +    Montage Technology TS2020 - Silicon Tuner driver
> +    Copyright (C) 2009-2012 Konstantin Dimitrov <kosio.dimitrov@gmail.com>
> +
> +    Copyright (C) 2009-2012 TurboSight.com
> +
> +    This program is free software; you can redistribute it and/or modify
> +    it under the terms of the GNU General Public License as published by
> +    the Free Software Foundation; either version 2 of the License, or
> +    (at your option) any later version.
> +
> +    This program is distributed in the hope that it will be useful,
> +    but WITHOUT ANY WARRANTY; without even the implied warranty of
> +    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +    GNU General Public License for more details.
> +
> +    You should have received a copy of the GNU General Public License
> +    along with this program; if not, write to the Free Software
> +    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> + */
> +
> +static int ts2020_get_frequency(struct dvb_frontend *fe, u32 *frequency)
> +{
> +	struct dvb_frontend_ops	*frontend_ops = NULL;
> +	struct dvb_tuner_ops *tuner_ops = NULL;
> +	struct tuner_state t_state;
> +	int ret = 0;
> +
> +	if (&fe->ops)
> +		frontend_ops = &fe->ops;
> +	if (&frontend_ops->tuner_ops)
> +		tuner_ops = &frontend_ops->tuner_ops;
> +	if (tuner_ops->get_state) {
> +		ret = tuner_ops->get_state(fe, DVBFE_TUNER_FREQUENCY, &t_state);
> +		if (ret < 0) {
> +			printk(KERN_ERR "%s: Invalid parameter\n", __func__);
> +			return ret;
> +		}
> +		*frequency = t_state.frequency;
> +	}
> +	return 0;
> +}
> +
> +static int ts2020_set_frequency(struct dvb_frontend *fe, u32 frequency)
> +{
> +	struct dvb_frontend_ops	*frontend_ops = NULL;
> +	struct dvb_tuner_ops *tuner_ops = NULL;
> +	struct tuner_state t_state;
> +	int ret = 0;
> +
> +	t_state.frequency = frequency;
> +	if (&fe->ops)
> +		frontend_ops = &fe->ops;
> +	if (&frontend_ops->tuner_ops)
> +		tuner_ops = &frontend_ops->tuner_ops;
> +	if (tuner_ops->set_state) {
> +		ret = tuner_ops->set_state(fe, DVBFE_TUNER_FREQUENCY, &t_state);
> +		if (ret < 0) {
> +			printk(KERN_ERR "%s: Invalid parameter\n", __func__);
> +			return ret;
> +		}
> +	}
> +	return 0;
> +}
> --- a/linux/drivers/media/dvb/frontends/ts2020.c	2012-05-07
> 01:36:51.428514382 +0300
> +++ b/linux/drivers/media/dvb/frontends/ts2020.c	2012-05-07
> 01:27:55.832521116 +0300
> @@ -0,0 +1,369 @@
> +/*
> +    Montage Technology TS2020 - Silicon Tuner driver
> +    Copyright (C) 2009-2012 Konstantin Dimitrov <kosio.dimitrov@gmail.com>
> +
> +    Copyright (C) 2009-2012 TurboSight.com
> +
> +    This program is free software; you can redistribute it and/or modify
> +    it under the terms of the GNU General Public License as published by
> +    the Free Software Foundation; either version 2 of the License, or
> +    (at your option) any later version.
> +
> +    This program is distributed in the hope that it will be useful,
> +    but WITHOUT ANY WARRANTY; without even the implied warranty of
> +    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +    GNU General Public License for more details.
> +
> +    You should have received a copy of the GNU General Public License
> +    along with this program; if not, write to the Free Software
> +    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> + */
> +
> +#include "dvb_frontend.h"
> +#include "ts2020.h"
> +
> +#define TS2020_XTAL_FREQ   27000 /* in kHz */
> +
> +static int ts2020_readreg(struct dvb_frontend *fe, u8 reg)
> +{
> +	struct ts2020_state *state = fe->tuner_priv;
> +
> +	int ret;
> +	u8 b0[] = { reg };
> +	u8 b1[] = { 0 };
> +	struct i2c_msg msg[] = {
> +		{
> +			.addr = state->config->tuner_address,
> +			.flags = 0,
> +			.buf = b0,
> +			.len = 1
> +		}, {
> +			.addr = state->config->tuner_address,
> +			.flags = I2C_M_RD,
> +			.buf = b1,
> +			.len = 1
> +		}
> +	};
> +
> +	if (fe->ops.i2c_gate_ctrl)
> +		fe->ops.i2c_gate_ctrl(fe, 1);
> +
> +	ret = i2c_transfer(state->i2c, msg, 2);
> +
> +	if (fe->ops.i2c_gate_ctrl)
> +		fe->ops.i2c_gate_ctrl(fe, 0);
> +
> +	if (ret != 2) {
> +		printk(KERN_ERR "%s: reg=0x%x(error=%d)\n", __func__, reg, ret);
> +		return ret;
> +	}
> +
> +	return b1[0];
> +}
> +
> +static int ts2020_writereg(struct dvb_frontend *fe, int reg, int data)
> +{
> +	struct ts2020_state *state = fe->tuner_priv;
> +
> +	u8 buf[] = { reg, data };
> +	struct i2c_msg msg = { .addr = state->config->tuner_address,
> +		.flags = 0, .buf = buf, .len = 2 };
> +	int err;
> +
> +
> +	if (fe->ops.i2c_gate_ctrl)
> +		fe->ops.i2c_gate_ctrl(fe, 1);
> +
> +	err = i2c_transfer(state->i2c, &msg, 1);
> +
> +	if (fe->ops.i2c_gate_ctrl)
> +		fe->ops.i2c_gate_ctrl(fe, 0);
> +
> +	if (err != 1) {
> +		printk(KERN_ERR "%s: writereg error(err == %i, reg == 0x%02x,"
> +			 " value == 0x%02x)\n", __func__, err, reg, data);
> +		return -EREMOTEIO;
> +	}
> +
> +	return 0;
> +}
> +
> +static int ts2020_get_status(struct dvb_frontend *fe, u32 *status)
> +{
> +	return TUNER_STATUS_LOCKED;
> +}
> +
> +static int ts2020_init(struct dvb_frontend *fe)
> +{
> +	return 0;
> +}
> +
> +static int ts2020_get_frequency(struct dvb_frontend *fe, u32 *frequency)
> +{
> +	u16 ndiv, div4;
> +
> +	div4 = (ts2020_readreg(fe, 0x10) & 0x10) >> 4;
> +
> +	ndiv = ts2020_readreg(fe, 0x01);
> +	ndiv &= 0x0f;
> +	ndiv <<= 8;
> +	ndiv |= ts2020_readreg(fe, 0x02);
> +
> +	/* actual tuned frequency, i.e. including the offset */
> +	*frequency = (ndiv - ndiv % 2 + 1024) * TS2020_XTAL_FREQ
> +		/ (6 + 8) / (div4 + 1) / 2;
> +
> +	return 0;
> +}
> +
> +static int ts2020_set_frequency(struct dvb_frontend *fe, u32 frequency)
> +{
> +	struct ts2020_state *state = fe->tuner_priv;
> +	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
> +
> +	u8 mlpf, mlpf_new, mlpf_max, mlpf_min, nlpf, div4;
> +	u16 value, ndiv;
> +	u32 srate = 0, f3db;
> +
> +	if (state->status == 0) {
> +		/* TS2020 init */
> +		ts2020_writereg(fe, 0x42, 0x73);
> +		ts2020_writereg(fe, 0x05, 0x01);
> +		ts2020_writereg(fe, 0x62, 0xf5);
> +
> +		state->status = 1;
> +	}
> +
> +	/* unknown */
> +	ts2020_writereg(fe, 0x07, 0x02);
> +	ts2020_writereg(fe, 0x10, 0x00);
> +	ts2020_writereg(fe, 0x60, 0x79);
> +	ts2020_writereg(fe, 0x08, 0x01);
> +	ts2020_writereg(fe, 0x00, 0x01);
> +	div4 = 0;
> +
> +	/* calculate and set freq divider */
> +	if (frequency < 1146000) {
> +		ts2020_writereg(fe, 0x10, 0x11);
> +		div4 = 1;
> +		ndiv = ((frequency * (6 + 8) * 4) +
> +				(TS2020_XTAL_FREQ / 2)) /
> +				TS2020_XTAL_FREQ - 1024;
> +	} else {
> +		ts2020_writereg(fe, 0x10, 0x01);
> +		ndiv = ((frequency * (6 + 8) * 2) +
> +				(TS2020_XTAL_FREQ / 2)) /
> +				TS2020_XTAL_FREQ - 1024;
> +	}
> +
> +	ts2020_writereg(fe, 0x01, (ndiv & 0x0f00) >> 8);
> +	ts2020_writereg(fe, 0x02, ndiv & 0x00ff);
> +
> +	/* set pll */
> +	ts2020_writereg(fe, 0x03, 0x06);
> +	ts2020_writereg(fe, 0x51, 0x0f);
> +	ts2020_writereg(fe, 0x51, 0x1f);
> +	ts2020_writereg(fe, 0x50, 0x10);
> +	ts2020_writereg(fe, 0x50, 0x00);
> +	msleep(5);
> +
> +	/* unknown */
> +	ts2020_writereg(fe, 0x51, 0x17);
> +	ts2020_writereg(fe, 0x51, 0x1f);
> +	ts2020_writereg(fe, 0x50, 0x08);
> +	ts2020_writereg(fe, 0x50, 0x00);
> +	msleep(5);
> +
> +	value = ts2020_readreg(fe, 0x3d);
> +	value &= 0x0f;
> +	if ((value > 4) && (value < 15)) {
> +		value -= 3;
> +		if (value < 4)
> +			value = 4;
> +		value = ((value << 3) | 0x01) & 0x79;
> +	}
> +
> +	ts2020_writereg(fe, 0x60, value);
> +	ts2020_writereg(fe, 0x51, 0x17);
> +	ts2020_writereg(fe, 0x51, 0x1f);
> +	ts2020_writereg(fe, 0x50, 0x08);
> +	ts2020_writereg(fe, 0x50, 0x00);
> +
> +	/* set low-pass filter period */
> +	ts2020_writereg(fe, 0x04, 0x2e);
> +	ts2020_writereg(fe, 0x51, 0x1b);
> +	ts2020_writereg(fe, 0x51, 0x1f);
> +	ts2020_writereg(fe, 0x50, 0x04);
> +	ts2020_writereg(fe, 0x50, 0x00);
> +	msleep(5);
> +
> +	/* get current symbol rate */
> +	if (fe->ops.get_frontend)
> +		fe->ops.get_frontend(fe);
> +	srate = p->symbol_rate / 1000;
> +
> +	f3db = (srate << 2) / 5 + 2000;
> +	if (srate < 5000)
> +		f3db += 3000;
> +	if (f3db < 7000)
> +		f3db = 7000;
> +	if (f3db > 40000)
> +		f3db = 40000;
> +
> +	/* set low-pass filter baseband */
> +	value = ts2020_readreg(fe, 0x26);
> +	mlpf = 0x2e * 207 / ((value << 1) + 151);
> +	mlpf_max = mlpf * 135 / 100;
> +	mlpf_min = mlpf * 78 / 100;
> +	if (mlpf_max > 63)
> +		mlpf_max = 63;
> +
> +	/* rounded to the closest integer */
> +	nlpf = ((mlpf * f3db * 1000) + (2766 * TS2020_XTAL_FREQ / 2))
> +			/ (2766 * TS2020_XTAL_FREQ);
> +	if (nlpf > 23)
> +		nlpf = 23;
> +	if (nlpf < 1)
> +		nlpf = 1;
> +
> +	/* rounded to the closest integer */
> +	mlpf_new = ((TS2020_XTAL_FREQ * nlpf * 2766) +
> +			(1000 * f3db / 2)) / (1000 * f3db);
> +
> +	if (mlpf_new < mlpf_min) {
> +		nlpf++;
> +		mlpf_new = ((TS2020_XTAL_FREQ * nlpf * 2766) +
> +				(1000 * f3db / 2)) / (1000 * f3db);
> +	}
> +
> +	if (mlpf_new > mlpf_max)
> +		mlpf_new = mlpf_max;
> +
> +	ts2020_writereg(fe, 0x04, mlpf_new);
> +	ts2020_writereg(fe, 0x06, nlpf);
> +	ts2020_writereg(fe, 0x51, 0x1b);
> +	ts2020_writereg(fe, 0x51, 0x1f);
> +	ts2020_writereg(fe, 0x50, 0x04);
> +	ts2020_writereg(fe, 0x50, 0x00);
> +	msleep(5);
> +
> +	/* unknown */
> +	ts2020_writereg(fe, 0x51, 0x1e);
> +	ts2020_writereg(fe, 0x51, 0x1f);
> +	ts2020_writereg(fe, 0x50, 0x01);
> +	ts2020_writereg(fe, 0x50, 0x00);
> +	msleep(60);
> +
> +	return 0;
> +}
> +
> +static int ts2020_sleep(struct dvb_frontend *fe)
> +{
> +	/* TODO: power down */
> +	return 0;
> +}
> +
> +static int ts2020_release(struct dvb_frontend *fe)
> +{
> +	struct ts2020_state *state = fe->tuner_priv;
> +
> +	fe->tuner_priv = NULL;
> +	kfree(state);
> +
> +	return 0;
> +}
> +
> +static int ts2020_get_state(struct dvb_frontend *fe,
> +			enum tuner_param param, struct tuner_state *state)
> +{
> +	switch (param) {
> +	case DVBFE_TUNER_FREQUENCY:
> +		ts2020_get_frequency(fe, &state->frequency);
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	return 0;
> +}
> +
> +static int ts2020_set_state(struct dvb_frontend *fe,
> +			enum tuner_param param, struct tuner_state *state)
> +{
> +	switch (param) {
> +	case DVBFE_TUNER_FREQUENCY:
> +		ts2020_set_frequency(fe, state->frequency);
> +		break;
> +	default:
> +		return -EINVAL;
> +		break;
> +	}
> +
> +	return 0;
> +}
> +
> +static struct dvb_tuner_ops ts2020_ops = {
> +	.info = {
> +		.name = "Montage Technology TS2020 Silicon Tuner",
> +		.frequency_min = 950000,
> +		.frequency_max = 2150000,
> +		.frequency_step = 0,
> +	},
> +
> +	.init = ts2020_init,
> +	.sleep = ts2020_sleep,
> +	.get_status = ts2020_get_status,
> +	.get_state = ts2020_get_state,
> +	.set_state = ts2020_set_state,
Why not to use set_frequency/get_frequency directly, without payload of state 
structure and get_state/set_state and separate header file?
Truly, it is expansion of code for just simple operation.
I don't buy that stuff.

> +	.release = ts2020_release
> +};
> +
> +int ts2020_get_signal_strength(struct dvb_frontend *fe,
> +	u16 *signal_strength)
> +{
> +	u16 sig_reading, sig_strength;
> +	u8 rfgain, bbgain;
> +
> +	rfgain = ts2020_readreg(fe, 0x3d) & 0x1f;
> +	bbgain = ts2020_readreg(fe, 0x21) & 0x1f;
> +
> +	if (rfgain > 15)
> +		rfgain = 15;
> +	if (bbgain > 13)
> +		bbgain = 13;
> +
> +	sig_reading = rfgain * 2 + bbgain * 3;
> +
> +	sig_strength = 40 + (64 - sig_reading) * 50 / 64 ;
> +
> +	/* cook the value to be suitable for szap-s2 human readable output */
> +	*signal_strength = sig_strength * 1000;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(ts2020_get_signal_strength);
> +
> +struct dvb_frontend *ts2020_attach(struct dvb_frontend *fe,
> +	const struct ts2020_config *config, struct i2c_adapter *i2c)
> +{
> +	struct ts2020_state *state = NULL;
> +
> +	/* allocate memory for the internal state */
> +	state = kzalloc(sizeof(struct ts2020_state), GFP_KERNEL);
> +	if (!state)
> +		return NULL;
> +
> +	/* setup the state */
> +	state->config = config;
> +	state->i2c = i2c;
> +	state->frontend = fe;
> +	fe->tuner_priv = state;
> +	fe->ops.tuner_ops = ts2020_ops;
> +
> +	return fe;
> +}
> +EXPORT_SYMBOL(ts2020_attach);
> +
> +MODULE_AUTHOR("Konstantin Dimitrov <kosio.dimitrov@gmail.com>");
> +MODULE_DESCRIPTION("Montage Technology TS2020 - Silicon tuner driver
> module"); +MODULE_LICENSE("GPL");
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Igor M. Liplianin
Microsoft Windows Free Zone - Linux used for all Computing Tasks
