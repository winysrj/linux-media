Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:47895 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752640AbaIHHxa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Sep 2014 03:53:30 -0400
Message-ID: <540D6077.7030709@iki.fi>
Date: Mon, 08 Sep 2014 10:53:27 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: tskd08@gmail.com, linux-media@vger.kernel.org
CC: m.chehab@samsung.com
Subject: Re: [PATCH v3 1/4] mxl301rf: add driver for MaxLinear MxL301RF OFDM
 tuner
References: <1410093690-5674-1-git-send-email-tskd08@gmail.com> <1410093690-5674-2-git-send-email-tskd08@gmail.com>
In-Reply-To: <1410093690-5674-2-git-send-email-tskd08@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 09/07/2014 03:41 PM, tskd08@gmail.com wrote:
> From: Akihiro Tsukada <tskd08@gmail.com>
>
> This patch adds driver for mxl301rf OFDM tuner chips.
> It is used as an ISDB-T tuner in earthsoft pt3 cards.
>
> Note that this driver does not initilize the chip,
> because the initilization sequence / register setting is not disclosed.
> Thus, the driver assumes that the chips are initilized externally
> by its parent board driver before tuner_ops->init() are called,
> like in PT3 driver where the bridge chip contains the init sequence
> in its private memory and provides a command to trigger the sequence.
>
> Signed-off-by: Akihiro Tsukada <tskd08@gmail.com>
> ---
> Changes in v3:
> - moved to I2C binding model
> - reverted new tuner ops, get_signal_strengh(),
>    update RSSI property in get_signal_rength()
> - small improvements in register read/write.
>
>   drivers/media/tuners/Kconfig    |   7 +
>   drivers/media/tuners/Makefile   |   1 +
>   drivers/media/tuners/mxl301rf.c | 383 ++++++++++++++++++++++++++++++++++++++++
>   drivers/media/tuners/mxl301rf.h |  28 +++
>   4 files changed, 419 insertions(+)
>   create mode 100644 drivers/media/tuners/mxl301rf.c
>   create mode 100644 drivers/media/tuners/mxl301rf.h
>
> diff --git a/drivers/media/tuners/Kconfig b/drivers/media/tuners/Kconfig
> index d79fd1c..cd3f8ee 100644
> --- a/drivers/media/tuners/Kconfig
> +++ b/drivers/media/tuners/Kconfig
> @@ -257,4 +257,11 @@ config MEDIA_TUNER_R820T
>   	default m if !MEDIA_SUBDRV_AUTOSELECT
>   	help
>   	  Rafael Micro R820T silicon tuner driver.
> +
> +config MEDIA_TUNER_MXL301RF
> +	tristate "MaxLinear MxL301RF tuner"
> +	depends on MEDIA_SUPPORT && I2C
> +	default m if !MEDIA_SUBDRV_AUTOSELECT
> +	help
> +	  MaxLinear MxL301RF OFDM tuner driver.
>   endmenu
> diff --git a/drivers/media/tuners/Makefile b/drivers/media/tuners/Makefile
> index 5591699..6d5bf48 100644
> --- a/drivers/media/tuners/Makefile
> +++ b/drivers/media/tuners/Makefile
> @@ -39,6 +39,7 @@ obj-$(CONFIG_MEDIA_TUNER_FC0012) += fc0012.o
>   obj-$(CONFIG_MEDIA_TUNER_FC0013) += fc0013.o
>   obj-$(CONFIG_MEDIA_TUNER_IT913X) += tuner_it913x.o
>   obj-$(CONFIG_MEDIA_TUNER_R820T) += r820t.o
> +obj-$(CONFIG_MEDIA_TUNER_MXL301RF) += mxl301rf.o
>
>   ccflags-y += -I$(srctree)/drivers/media/dvb-core
>   ccflags-y += -I$(srctree)/drivers/media/dvb-frontends
> diff --git a/drivers/media/tuners/mxl301rf.c b/drivers/media/tuners/mxl301rf.c
> new file mode 100644
> index 0000000..645df2d
> --- /dev/null
> +++ b/drivers/media/tuners/mxl301rf.c
> @@ -0,0 +1,383 @@
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
> +#include <linux/kernel.h>
> +#include "mxl301rf.h"
> +
> +struct mxl301rf_state {
> +	struct mxl301rf_config cfg;
> +	struct i2c_client *i2c;
> +};
> +
> +static struct mxl301rf_state *cfg_to_state(struct mxl301rf_config *c)
> +{
> +	return container_of(c, struct mxl301rf_state, cfg);
> +}
> +
> +static int raw_write(struct mxl301rf_state *state, const u8 *buf, int len)
> +{
> +	int ret;
> +
> +	ret = i2c_master_send(state->i2c, buf, len);
> +	if (ret >= 0 && ret < len)
> +		ret = -EIO;
> +	return (ret == len) ? 0 : ret;
> +}
> +
> +static int reg_write(struct mxl301rf_state *state, u8 reg, u8 val)
> +{
> +	u8 buf[2] = { reg, val };
> +
> +	return raw_write(state, buf, 2);
> +}
> +
> +static int reg_read(struct mxl301rf_state *state, u8 reg, u8 *val)
> +{
> +	u8 wbuf[2] = { 0xfb, reg };
> +	struct i2c_msg msgs[2] = {
> +		{
> +			.addr = state->i2c->addr,
> +			.flags = 0,
> +			.buf = wbuf,
> +			.len = 2,
> +		},
> +		{
> +			.addr = state->i2c->addr,
> +			.flags = I2C_M_RD,
> +			.buf = val,
> +			.len = 1,
> +		}
> +	};
> +	int ret;
> +
> +	ret = i2c_transfer(state->i2c->adapter, msgs, ARRAY_SIZE(msgs));
> +	if (ret >= 0 && ret < ARRAY_SIZE(msgs))
> +		ret = -EIO;
> +	return (ret == ARRAY_SIZE(msgs)) ? 0 : ret;
> +}

Could you really implement that as a I2C write with STOP and I2C read 
with STOP. I don't like you abuse, without any good reason, 
i2c_transfer() with REPEATED START even we know chip does not do it.

You should use
i2c_master_send()
i2c_master_recv()


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
> +	/* check RF Synthesizer lock */
> +	ret = reg_read(state, 0x16, &val);
> +	if (ret < 0 || (val & 0x0c) != 0x0c)
> +		return ret;
> +
> +	/* check REF Synthesizer lock */
> +	/* a reference win driver re-reads reg:0x16 for some reason */

If it works without, just set without. Likely reference driver kit 
contains 2 functions which returns synthesizer lock, one for each PLL. I 
am also pretty sure RF synthesizer cannot never LOCK if that another PLL 
is unlocked as I suspect "REF Synthesizer" is there before "RF 
Synthesizer" in a chain. Name REF Synthesizer sounds like a it is used 
to generate needed reference freq to actual RF synthesizer.

> +	ret = reg_read(state, 0x16, &val);
> +	if (ret < 0 || (val & 0x03) != 0x03)
> +		return ret;
> +	*status = TUNER_STATUS_LOCKED;
> +	return 0;
> +}

And whole function is quite useless in any case. It was aimed for analog 
radio driver originally, where was audio demod integrated. We usually 
just program tuner first, then demod, without waiting tuner lock, as 
tuner locks practically immediately to given freq. It is demod which 
locking then has any sense.

Tuner PLL lock bits could be interesting only when you want to test if 
you are in a frequency whole tuner is able to receive. Some corner case 
when tuner is driven over its limits to see if it locks or not.


> +
> +/* get RSSI and update propery cache, set to *out in % */
> +static int mxl301rf_get_rf_strength(struct dvb_frontend *fe, u16 *out)
> +{
> +	struct mxl301rf_state *state;
> +	int ret;
> +	u8  rf_in1, rf_in2, rf_off1, rf_off2;
> +	u16 rf_in, rf_off;
> +	s64 level;
> +	struct dtv_fe_stats *rssi;
> +
> +	rssi = &fe->dtv_property_cache.strength;
> +	rssi->len = 1;
> +	rssi->stat[0].scale = FE_SCALE_NOT_AVAILABLE;
> +	*out = 0;
> +
> +	state = fe->tuner_priv;
> +	ret = reg_write(state, 0x14, 0x01);
> +	if (ret < 0)
> +		return ret;
> +	usleep_range(1000, 2000);
> +
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
> +	rf_off = (rf_off2 & 0x0f) << 5 | (rf_off1 >> 3);
> +	level = rf_in - rf_off - (113 << 3); /* x8 dBm */
> +	level = level * 1000 / 8;
> +	rssi->stat[0].svalue = level;
> +	rssi->stat[0].scale = FE_SCALE_DECIBEL;
> +	/* *out = (level - min) * 100 / (max - min) */
> +	*out = (rf_in - rf_off + (1 << 9) - 1) * 100 / ((5 << 9) - 2);
> +	return 0;
> +}
> +
> +/* spur shift parameters */
> +struct shf {
> +	u32	freq;		/* Channel center frequency */
> +	u32	ofst_th;	/* Offset frequency threshold */
> +	u8	shf_val;	/* Spur shift value */
> +	u8	shf_dir;	/* Spur shift direction */
> +};
> +
> +static const struct shf shf_tab[] = {
> +	{  64500, 500, 0x92, 0x07 },
> +	{ 191500, 300, 0xe2, 0x07 },
> +	{ 205500, 500, 0x2c, 0x04 },
> +	{ 212500, 500, 0x1e, 0x04 },
> +	{ 226500, 500, 0xd4, 0x07 },
> +	{  99143, 500, 0x9c, 0x07 },
> +	{ 173143, 500, 0xd4, 0x07 },
> +	{ 191143, 300, 0xd4, 0x07 },
> +	{ 207143, 500, 0xce, 0x07 },
> +	{ 225143, 500, 0xce, 0x07 },
> +	{ 243143, 500, 0xd4, 0x07 },
> +	{ 261143, 500, 0xd4, 0x07 },
> +	{ 291143, 500, 0xd4, 0x07 },
> +	{ 339143, 500, 0x2c, 0x04 },
> +	{ 117143, 500, 0x7a, 0x07 },
> +	{ 135143, 300, 0x7a, 0x07 },
> +	{ 153143, 500, 0x01, 0x07 }
> +};
> +
> +struct reg_val {
> +	u8 reg;
> +	u8 val;
> +} __attribute__ ((__packed__));
> +
> +static const struct reg_val set_idac[] = {
> +	{ 0x0d, 0x00 },
> +	{ 0x0c, 0x67 },
> +	{ 0x6f, 0x89 },
> +	{ 0x70, 0x0c },
> +	{ 0x6f, 0x8a },
> +	{ 0x70, 0x0e },
> +	{ 0x6f, 0x8b },
> +	{ 0x70, 0x1c },
> +};
> +
> +static int mxl301rf_set_params(struct dvb_frontend *fe)
> +{
> +	struct reg_val tune0[] = {
> +		{ 0x13, 0x00 },		/* abort tuning */
> +		{ 0x3b, 0xc0 },
> +		{ 0x3b, 0x80 },
> +		{ 0x10, 0x95 },		/* BW */
> +		{ 0x1a, 0x05 },
> +		{ 0x61, 0x00 },		/* spur shift value (placeholder) */
> +		{ 0x62, 0xa0 }		/* spur shift direction (placeholder) */
> +	};
> +
> +	struct reg_val tune1[] = {
> +		{ 0x11, 0x40 },		/* RF frequency L (placeholder) */
> +		{ 0x12, 0x0e },		/* RF frequency H (placeholder) */
> +		{ 0x13, 0x01 }		/* start tune */
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
> +
> +	/* spur shift function (for analog) */
> +	for (i = 0; i < ARRAY_SIZE(shf_tab); i++) {
> +		if (freq >= (shf_tab[i].freq - shf_tab[i].ofst_th) * 1000 &&
> +		    freq <= (shf_tab[i].freq + shf_tab[i].ofst_th) * 1000) {
> +			tune0[5].val = shf_tab[i].shf_val;
> +			tune0[6].val = 0xa0 | shf_tab[i].shf_dir;
> +			break;
> +		}
> +	}
> +	ret = raw_write(state, (u8 *) tune0, sizeof(tune0));
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
> +	tune1[0].val = f & 0xff;
> +	tune1[1].val = f >> 8;
> +	ret = raw_write(state, (u8 *) tune1, sizeof(tune1));
> +	if (ret < 0)
> +		goto failed;
> +	msleep(31);
> +
> +	ret = reg_write(state, 0x1a, 0x0d);
> +	if (ret < 0)
> +		goto failed;
> +	ret = raw_write(state, (u8 *) set_idac, sizeof(set_idac));
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
> +static const struct reg_val standby_data[] = {
> +	{ 0x01, 0x00 },
> +	{ 0x13, 0x00 }
> +};
> +
> +static int mxl301rf_sleep(struct dvb_frontend *fe)
> +{
> +	struct mxl301rf_state *state;
> +	int ret;
> +
> +	state = fe->tuner_priv;
> +	ret = raw_write(state, (u8 *)standby_data, sizeof(standby_data));
> +	if (ret < 0)
> +		dev_warn(&state->i2c->dev, "(%s) failed. [adap%d-fe%d]\n",
> +			__func__, fe->dvb->num, fe->id);
> +	return ret;
> +}
> +
> +
> +/* init sequence is not public.
> + * the parent must have init'ed the device.
> + * just wake up here.
> + */
> +static int mxl301rf_init(struct dvb_frontend *fe)
> +{
> +	struct mxl301rf_state *state;
> +	int ret;
> +
> +	state = fe->tuner_priv;
> +
> +	ret = reg_write(state, 0x01, 0x01);
> +	if (ret < 0)
> +		goto failed;
> +
> +	/* tune to the initial freq */
> +	if (state->cfg.init_freq > 0) {
> +		u32 f = fe->dtv_property_cache.frequency;
> +
> +		fe->dtv_property_cache.frequency = state->cfg.init_freq;
> +		ret = mxl301rf_set_params(fe);
> +		fe->dtv_property_cache.frequency = f;
> +		if (ret < 0)
> +			goto failed;
> +	}

This looks odd. Why it is tuned here to some freq? What happens if you 
don't do it and it will be tuned to requested freq. Sometimes that kind 
of things are used to initialize badly written driven...

> +	return 0;
> +
> +failed:
> +	dev_warn(&state->i2c->dev, "(%s) failed. [adap%d-fe%d]\n",
> +		__func__, fe->dvb->num, fe->id);
> +	return ret;
> +}
> +
> +/* I2C driver functions */
> +
> +static const struct dvb_tuner_ops mxl301rf_ops = {
> +	.info = {
> +		.name = "MaxLinear MxL301RF",
> +
> +		.frequency_min =  93000000,
> +		.frequency_max = 803142857,
> +	},
> +
> +	.init = mxl301rf_init,
> +	.sleep = mxl301rf_sleep,
> +
> +	.set_params = mxl301rf_set_params,
> +	.get_status = mxl301rf_get_status,
> +	.get_rf_strength = mxl301rf_get_rf_strength,

get IF frequency is missing. That is tuner using IF so you will need to 
know IF in order to get demod working.

> +};
> +
> +
> +static int mxl301rf_probe(struct i2c_client *client,
> +			  const struct i2c_device_id *id)
> +{
> +	struct mxl301rf_state *state;
> +	struct mxl301rf_config *cfg;
> +	struct dvb_frontend *fe;
> +
> +	state = kzalloc(sizeof(*state), GFP_KERNEL);
> +	if (!state)
> +		return -ENOMEM;
> +
> +	state->i2c = client;
> +	cfg = client->dev.platform_data;
> +
> +	memcpy(&state->cfg, cfg, sizeof(state->cfg));
> +	fe = cfg->fe;
> +	fe->tuner_priv = state;
> +	memcpy(&fe->ops.tuner_ops, &mxl301rf_ops, sizeof(mxl301rf_ops));
> +
> +	i2c_set_clientdata(client, &state->cfg);
> +	dev_info(&client->dev, "MaxLinear MxL301RF attached.\n");
> +	return 0;
> +}
> +
> +static int mxl301rf_remove(struct i2c_client *client)
> +{
> +	struct mxl301rf_state *state;
> +
> +	state = cfg_to_state(i2c_get_clientdata(client));
> +	state->cfg.fe->tuner_priv = NULL;
> +	kfree(state);
> +	return 0;
> +}
> +
> +
> +static const struct i2c_device_id mxl301rf_id[] = {
> +	{"mxl301rf", 0},
> +	{}
> +};
> +MODULE_DEVICE_TABLE(i2c, mxl301rf_id);
> +
> +static struct i2c_driver mxl301rf_driver = {
> +	.driver = {
> +		.name	= "mxl301rf",
> +	},
> +	.probe		= mxl301rf_probe,
> +	.remove		= mxl301rf_remove,
> +	.id_table	= mxl301rf_id,
> +};
> +
> +module_i2c_driver(mxl301rf_driver);
> +
> +MODULE_DESCRIPTION("MaxLinear MXL301RF tuner");
> +MODULE_AUTHOR("Akihiro TSUKADA");
> +MODULE_LICENSE("GPL");
> diff --git a/drivers/media/tuners/mxl301rf.h b/drivers/media/tuners/mxl301rf.h
> new file mode 100644
> index 0000000..a11ef80
> --- /dev/null
> +++ b/drivers/media/tuners/mxl301rf.h
> @@ -0,0 +1,28 @@
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
> +#include "dvb_frontend.h"
> +
> +struct mxl301rf_config {
> +	struct dvb_frontend *fe;
> +
> +	u32 init_freq;
> +};
> +
> +#endif /* MXL301RF_H */
>

The rest looks quite OK.

regards
Antti

-- 
http://palosaari.fi/
