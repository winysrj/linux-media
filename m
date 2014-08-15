Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w2.samsung.com ([211.189.100.14]:65325 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116AbaHOPvA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Aug 2014 11:51:00 -0400
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by usmailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NAC00EJ1UOY3C20@usmailout4.samsung.com> for
 linux-media@vger.kernel.org; Fri, 15 Aug 2014 11:50:58 -0400 (EDT)
Date: Fri, 15 Aug 2014 12:50:53 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: tskd08@gmail.com
Cc: linux-media@vger.kernel.org, james.hogan@imgtec.com
Subject: Re: [PATCH 1/4] mxl301rf: add driver for MaxLinear MxL301RF OFDM tuner
Message-id: <20140815125053.5cc901a6.m.chehab@samsung.com>
In-reply-to: <1405352627-22677-2-git-send-email-tskd08@gmail.com>
References: <1405352627-22677-1-git-send-email-tskd08@gmail.com>
 <1405352627-22677-2-git-send-email-tskd08@gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 15 Jul 2014 00:43:44 +0900
tskd08@gmail.com escreveu:

> From: Akihiro Tsukada <tskd08@gmail.com>
> 
> This patch adds driver for mxl301rf OFDM tuner chips.
> It is used as an ISDB-T tuner in earthsoft pt3 cards.
> 
> Note that this driver does not initilize the chip,
> because the initilization sequence / register setting is not disclosed.
> Thus, the driver assumes that the chips are initilized externally
> by its parent board driver before tuner_ops->init() are called.
> Earthsoft PT3 PCIe card, for example, contains the init sequence
> in its private memory and provides a command to trigger the sequence.
> 
> Signed-off-by: Akihiro Tsukada <tskd08@gmail.com>
> ---
>  drivers/media/tuners/Kconfig    |   7 +
>  drivers/media/tuners/Makefile   |   1 +
>  drivers/media/tuners/mxl301rf.c | 331 ++++++++++++++++++++++++++++++++++++++++
>  drivers/media/tuners/mxl301rf.h |  40 +++++
>  4 files changed, 379 insertions(+)
>  create mode 100644 drivers/media/tuners/mxl301rf.c
>  create mode 100644 drivers/media/tuners/mxl301rf.h
> 
> diff --git a/drivers/media/tuners/Kconfig b/drivers/media/tuners/Kconfig
> index 22b6b8b..939111d 100644
> --- a/drivers/media/tuners/Kconfig
> +++ b/drivers/media/tuners/Kconfig
> @@ -250,4 +250,11 @@ config MEDIA_TUNER_R820T
>  	default m if !MEDIA_SUBDRV_AUTOSELECT
>  	help
>  	  Rafael Micro R820T silicon tuner driver.
> +
> +config MEDIA_TUNER_MXL301RF
> +	tristate "MaxLinear MxL301RF tuner"
> +	depends on MEDIA_SUPPORT && I2C
> +	default m if !MEDIA_SUBDRV_AUTOSELECT
> +	help
> +	  MaxLinear MxL301RF OFDM tuner driver.
>  endmenu
> diff --git a/drivers/media/tuners/Makefile b/drivers/media/tuners/Makefile
> index a6ff0c6..026eb16 100644
> --- a/drivers/media/tuners/Makefile
> +++ b/drivers/media/tuners/Makefile
> @@ -38,6 +38,7 @@ obj-$(CONFIG_MEDIA_TUNER_FC0012) += fc0012.o
>  obj-$(CONFIG_MEDIA_TUNER_FC0013) += fc0013.o
>  obj-$(CONFIG_MEDIA_TUNER_IT913X) += tuner_it913x.o
>  obj-$(CONFIG_MEDIA_TUNER_R820T) += r820t.o
> +obj-$(CONFIG_MEDIA_TUNER_MXL301RF) += mxl301rf.o
>  
>  ccflags-y += -I$(srctree)/drivers/media/dvb-core
>  ccflags-y += -I$(srctree)/drivers/media/dvb-frontends
> diff --git a/drivers/media/tuners/mxl301rf.c b/drivers/media/tuners/mxl301rf.c
> new file mode 100644
> index 0000000..65e4438
> --- /dev/null
> +++ b/drivers/media/tuners/mxl301rf.c
> @@ -0,0 +1,331 @@
> +/*
> + * MaxLinear MxL301RF OFDM tuner driver
> + *
> + * Copyright (C) 2014 Akihiro Tsukada <tskd08@gmail.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation version 2.
> + *
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include "mxl301rf.h"
> +
> +struct mxl301rf_state {
> +	struct mxl301rf_config cfg;
> +	struct i2c_adapter *i2c;
> +};
> +
> +static int data_write(struct mxl301rf_state *state, const u8 *buf, int len)
> +{
> +	struct i2c_msg msg = {
> +		.addr = state->cfg.addr,
> +		.flags = 0,
> +		.buf = (u8 *)buf,
> +		.len = len,
> +	};
> +
> +	return i2c_transfer(state->i2c, &msg, 1);
> +}
> +
> +static int reg_write(struct mxl301rf_state *state, u8 reg, u8 val)
> +{
> +	u8 buf[2] = { reg, val };
> +
> +	return data_write(state, buf, 2);
> +}
> +
> +static int reg_read(struct mxl301rf_state *state, u8 reg, u8 *val)
> +{
> +	u8 wbuf[2] = { 0xfb, reg };
> +	struct i2c_msg msgs[2] = {
> +		{
> +			.addr = state->cfg.addr,
> +			.flags = 0,
> +			.buf = wbuf,
> +			.len = 2,
> +		},
> +		{
> +			.addr = state->cfg.addr,
> +			.flags = I2C_M_RD,
> +			.buf = val,
> +			.len = 1,
> +		}
> +	};
> +
> +	return i2c_transfer(state->i2c, msgs, ARRAY_SIZE(msgs));
> +}
> +
> +/* tuner_ops */
> +
> +static int mxl301rf_get_status(struct dvb_frontend *fe, u32 *status)
> +{
> +	struct mxl301rf_state *state;
> +	int ret;
> +	u8 val;
> +
> +	*status = 0;
> +	state = fe->tuner_priv;
> +	ret = reg_read(state, 0x16, &val);  /* check RF Synthesizer lock */
> +	if (ret < 0 || (val & 0x0c) != 0x0c)
> +		return ret;
> +	ret = reg_read(state, 0x16, &val);  /* check REF Synthesizer lock */
> +	if (ret < 0 || (val & 0x03) != 0x03)
> +		return ret;
> +	*status = TUNER_STATUS_LOCKED;
> +	return 0;
> +}
> +
> +/* *strength : [1/1000 dBm] */
> +static int mxl301rf_get_rf_strength(struct dvb_frontend *fe, u16 *strength)
> +{
> +	struct mxl301rf_state *state;
> +	int ret;
> +	u8 rf_in1, rf_in2, rf_off1, rf_off2;
> +	u16 rf_in, rf_off;
> +	s16 level;
> +
> +	*strength = 0;
> +	state = fe->tuner_priv;
> +	ret = reg_write(state, 0x14, 0x01);
> +	if (ret < 0)
> +		return ret;
> +	usleep_range(1000, 2000);
> +	ret = reg_read(state, 0x18, &rf_in1);
> +	if (ret == 0)
> +		ret = reg_read(state, 0x19, &rf_in2);
> +	if (ret == 0)
> +		ret = reg_read(state, 0xd6, &rf_off1);
> +	if (ret == 0)
> +		ret = reg_read(state, 0xd7, &rf_off2);
> +	if (ret != 0)
> +		return ret;
> +
> +	rf_in = (rf_in2 & 0x07) << 8 | rf_in1;
> +	rf_off = (rf_off2 & 0x0f) << 5 | (rf_off2 >> 3);
> +	level = rf_in - rf_off - (113 << 3); /* x8 dBm */
> +	level = level * 1000 / 8;
> +	*strength = (u16)level;

Please implement it using DVBv5 API, e. g. using dBm scale.

> +	return 0;
> +}
> +
> +static int mxl301rf_set_params(struct dvb_frontend *fe)
> +{
> +	struct shf {
> +		u32	freq;		/* Channel center frequency */
> +		u32	ofst_th;	/* Offset frequency threshold */
> +		u8	shf_val;	/* Spur shift value */
> +		u8	shf_dir;	/* Spur shift direction */
> +	};
> +	static const struct shf shf_tab[] = {
> +		{  64500, 500, 0x92, 0x07 },
> +		{ 191500, 300, 0xe2, 0x07 },
> +		{ 205500, 500, 0x2c, 0x04 },
> +		{ 212500, 500, 0x1e, 0x04 },
> +		{ 226500, 500, 0xd4, 0x07 },
> +		{  99143, 500, 0x9c, 0x07 },
> +		{ 173143, 500, 0xd4, 0x07 },
> +		{ 191143, 300, 0xd4, 0x07 },
> +		{ 207143, 500, 0xce, 0x07 },
> +		{ 225143, 500, 0xce, 0x07 },
> +		{ 243143, 500, 0xd4, 0x07 },
> +		{ 261143, 500, 0xd4, 0x07 },
> +		{ 291143, 500, 0xd4, 0x07 },
> +		{ 339143, 500, 0x2c, 0x04 },
> +		{ 117143, 500, 0x7a, 0x07 },
> +		{ 135143, 300, 0x7a, 0x07 },
> +		{ 153143, 500, 0x01, 0x07 }
> +	};
> +	static const u8 set_idac[] = {
> +		0x0d, 0x00,
> +		0x0c, 0x67,
> +		0x6f, 0x89,
> +		0x70, 0x0c,
> +		0x6f, 0x8a,
> +		0x70, 0x0e,
> +		0x6f, 0x8b,
> +		0x70, 0x1c,
> +	};
> +
> +	u8 tune0[] = {
> +		0x13, 0x00,		/* abort tuning */
> +		0x3b, 0xc0,
> +		0x3b, 0x80,
> +		0x10, 0x95,		/* BW */
> +		0x1a, 0x05,
> +		0x61, 0x00,
> +		0x62, 0xa0
> +	};
> +	u8 tune1[] = {
> +		0x11, 0x40,		/* RF frequency L */
> +		0x12, 0x0e,		/* RF frequency H */
> +		0x13, 0x01		/* start tune */
> +	};
> +
> +	struct mxl301rf_state *state;
> +	u32 freq;
> +	u16 f;
> +	u32 tmp, div;
> +	int i, ret;
> +
> +	state = fe->tuner_priv;
> +	freq = fe->dtv_property_cache.frequency;
> +	/* offset 1/7MHz if not applied yet */
> +	if (freq % 1000000 == 0)
> +		freq += 142857;

Don't do that. Userspace should be providing the right requency

> +
> +	/* spur shift function (for analog) */
> +	for (i = 0; i < ARRAY_SIZE(shf_tab); i++) {
> +		if (freq >= (shf_tab[i].freq - shf_tab[i].ofst_th) * 1000 &&
> +		    freq <= (shf_tab[i].freq + shf_tab[i].ofst_th) * 1000) {
> +			tune0[2 * 5 + 1] = shf_tab[i].shf_val;
> +			tune0[2 * 6 + 1] = 0xa0 | shf_tab[i].shf_dir;
> +			break;
> +		}
> +	}

Hmm... are you using a table to match the channels? If so, don't do that.
Instead, just calculate the dividers based on the given frequency.

> +	ret = data_write(state, tune0, sizeof(tune0));
> +	if (ret < 0)
> +		goto failed;
> +	usleep_range(3000, 4000);
> +
> +	/* convert freq to 10.6 fixed point float [MHz] */
> +	f = freq / 1000000;
> +	tmp = freq % 1000000;
> +	div = 1000000;
> +	for (i = 0; i < 6; i++) {
> +		f <<= 1;
> +		div >>= 1;
> +		if (tmp > div) {
> +			tmp -= div;
> +			f |= 1;
> +		}
> +	}
> +	if (tmp > 7812)
> +		f++;
> +	tune1[2 * 0 + 1] = f & 0xff;
> +	tune1[2 * 1 + 1] = f >> 8;
> +	ret = data_write(state, tune1, sizeof(tune1));
> +	if (ret < 0)
> +		goto failed;
> +	msleep(31);
> +
> +	ret = reg_write(state, 0x1a, 0x0d);
> +	if (ret < 0)
> +		goto failed;
> +	ret = data_write(state, set_idac, sizeof(set_idac));
> +	if (ret < 0)
> +		goto failed;
> +	return 0;
> +
> +failed:
> +	dev_warn(&state->i2c->dev, "(%s) failed. [adap%d-fe%d]\n",
> +		__func__, fe->dvb->num, fe->id);
> +	return ret;
> +}
> +
> +static int mxl301rf_sleep(struct dvb_frontend *fe)
> +{
> +	static const u8 standby_data[] = {
> +		0x01, 0x00, 0x13, 0x00
> +	};
> +	struct mxl301rf_state *state;
> +	int ret;
> +
> +	state = fe->tuner_priv;
> +	ret = data_write(fe->tuner_priv, standby_data, sizeof(standby_data));
> +	if (ret < 0)
> +		dev_warn(&state->i2c->dev, "(%s) failed. [adap%d-fe%d]\n",
> +			__func__, fe->dvb->num, fe->id);
> +	return ret;
> +}
> +
> +static int mxl301rf_release(struct dvb_frontend *fe)
> +{
> +	struct mxl301rf_state *state;
> +
> +	state = fe->tuner_priv;
> +	kfree(state);
> +	fe->tuner_priv = NULL;
> +	return 0;
> +}
> +
> +
> +/* init sequence is not public.
> + * the parent must have init'ed the device.
> + * just wake up here.
> + */
> +static int mxl301rf_init(struct dvb_frontend *fe)
> +{
> +	static const u8 wakeup_data[] = {
> +		0x01, 0x01
> +	};
> +	struct mxl301rf_state *state;
> +	int ret;
> +
> +	state = fe->tuner_priv;
> +
> +	ret = data_write(state, wakeup_data, sizeof(wakeup_data));
> +	if (ret < 0)
> +		goto failed;
> +
> +	/* tune to the initial freq */
> +	if (state->cfg.init_freq > 0) {
> +		fe->dtv_property_cache.frequency = state->cfg.init_freq;
> +		ret = mxl301rf_set_params(fe);
> +		if (ret < 0)
> +			goto failed;
> +	}
> +	return 0;
> +
> +failed:
> +	dev_warn(&state->i2c->dev, "(%s) failed. [adap%d-fe%d]\n",
> +		__func__, fe->dvb->num, fe->id);
> +	return ret;
> +}
> +
> +/* exported functions */
> +
> +static const struct dvb_tuner_ops mxl301rf_ops = {
> +	.info = {
> +		.name = "MaxLinear MxL301RF",
> +
> +		.frequency_min =  93000000,
> +		.frequency_max = 767000000,

Hmm... it doesn't support all 69 channels on ISDB-T?

Ok, Japan uses only a more restricted frequency range, but other Countries
use channels up to 803.14 MHz.

> +	},
> +
> +	.release = mxl301rf_release,
> +	.init = mxl301rf_init,
> +	.sleep = mxl301rf_sleep,
> +
> +	.set_params = mxl301rf_set_params,
> +	.get_status = mxl301rf_get_status,
> +	.get_rf_strength = mxl301rf_get_rf_strength,

Isn't it capable of providing more stats?

> +};
> +
> +
> +struct dvb_frontend *mxl301rf_attach(struct dvb_frontend *fe,
> +	struct i2c_adapter *i2c, const struct mxl301rf_config *cfg)
> +{
> +	struct mxl301rf_state *state;
> +
> +	state = kzalloc(sizeof(*state), GFP_KERNEL);
> +	if (!state)
> +		return NULL;
> +
> +	memcpy(&state->cfg, cfg, sizeof(*cfg));
> +	state->i2c = i2c;
> +	memcpy(&fe->ops.tuner_ops, &mxl301rf_ops, sizeof(mxl301rf_ops));
> +	fe->tuner_priv = state;
> +	dev_info(&i2c->dev, "MaxLinear MxL301RF attached.\n");
> +	return fe;
> +}
> +EXPORT_SYMBOL(mxl301rf_attach);
> +
> +MODULE_DESCRIPTION("MaxLinear MXL301RF tuner");
> +MODULE_AUTHOR("Akihiro TSUKADA");
> +MODULE_LICENSE("GPL");
> diff --git a/drivers/media/tuners/mxl301rf.h b/drivers/media/tuners/mxl301rf.h
> new file mode 100644
> index 0000000..8c47e55
> --- /dev/null
> +++ b/drivers/media/tuners/mxl301rf.h
> @@ -0,0 +1,40 @@
> +/*
> + * MaxLinear MxL301RF OFDM tuner driver
> + *
> + * Copyright (C) 2014 Akihiro Tsukada <tskd08@gmail.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation version 2.
> + *
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#ifndef MXL301RF_H
> +#define MXL301RF_H
> +
> +#include <linux/kconfig.h>
> +#include "dvb_frontend.h"
> +
> +struct mxl301rf_config {
> +	u8 addr;
> +	u32 init_freq;
> +};
> +
> +#if IS_ENABLED(CONFIG_MEDIA_TUNER_MXL301RF)
> +extern struct dvb_frontend *mxl301rf_attach(struct dvb_frontend *fe,
> +		struct i2c_adapter *i2c, const struct mxl301rf_config *cfg);
> +#else
> +static inline struct dvb_frontend *mxl301rf_attach(struct dvb_frontend *fe,
> +		struct i2c_adapter *i2c, const struct mxl301rf_config *cfg)
> +{
> +	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
> +	return NULL;
> +}
> +#endif
> +
> +#endif /* MXL301RF_H */
