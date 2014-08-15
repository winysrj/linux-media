Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w2.samsung.com ([211.189.100.11]:39343 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbaHOQJd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Aug 2014 12:09:33 -0400
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by mailout1.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NAC007AWVJTLH10@mailout1.w2.samsung.com> for
 linux-media@vger.kernel.org; Fri, 15 Aug 2014 12:09:29 -0400 (EDT)
Date: Fri, 15 Aug 2014 13:09:24 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: tskd08@gmail.com
Cc: linux-media@vger.kernel.org, james.hogan@imgtec.com
Subject: Re: [PATCH 3/4] tc90522: add driver for Toshiba TC90522 quad
 demodulator
Message-id: <20140815130924.72029bfd.m.chehab@samsung.com>
In-reply-to: <1405352627-22677-4-git-send-email-tskd08@gmail.com>
References: <1405352627-22677-1-git-send-email-tskd08@gmail.com>
 <1405352627-22677-2-git-send-email-tskd08@gmail.com>
 <1405352627-22677-3-git-send-email-tskd08@gmail.com>
 <1405352627-22677-4-git-send-email-tskd08@gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 15 Jul 2014 00:43:46 +0900
tskd08@gmail.com escreveu:

> From: Akihiro Tsukada <tskd08@gmail.com>
> 
> This patch adds driver for tc90522 demodulator chips.
> The chip contains 4 demod modules that run in parallel and are independently
> controllable via separate I2C addresses.
> Two of the modules are for ISDB-T and the rest for ISDB-S.
> It is used in earthsoft pt3 cards.
> 
> Note that this driver does not init the chip,
> because the initilization sequence / register setting is not disclosed.
> Thus, the driver assumes that the chips are initilized externally
> by its parent board driver before fe->ops->init() are called.
> Earthsoft PT3 PCIe card, for example, contains the init sequence
> in its private memory and provides a command to trigger the sequence.
> 
> Signed-off-by: Akihiro Tsukada <tskd08@gmail.com>
> ---
>  drivers/media/dvb-frontends/Kconfig   |   8 +
>  drivers/media/dvb-frontends/Makefile  |   1 +
>  drivers/media/dvb-frontends/tc90522.c | 843 ++++++++++++++++++++++++++++++++++
>  drivers/media/dvb-frontends/tc90522.h |  63 +++
>  4 files changed, 915 insertions(+)
>  create mode 100644 drivers/media/dvb-frontends/tc90522.c
>  create mode 100644 drivers/media/dvb-frontends/tc90522.h
> 
> diff --git a/drivers/media/dvb-frontends/Kconfig b/drivers/media/dvb-frontends/Kconfig
> index 1469d44..0244571 100644
> --- a/drivers/media/dvb-frontends/Kconfig
> +++ b/drivers/media/dvb-frontends/Kconfig
> @@ -625,6 +625,14 @@ config DVB_MB86A20S
>  	  A driver for Fujitsu mb86a20s ISDB-T/ISDB-Tsb demodulator.
>  	  Say Y when you want to support this frontend.
>  
> +config DVB_TC90522
> +	tristate "Toshiba TC90522"
> +	depends on DVB_CORE && I2C
> +	default m if !MEDIA_SUBDRV_AUTOSELECT
> +	help
> +	  A Toshiba TC90522 2xISDB-T + 2xISDB-S demodulator.
> +	  Say Y when you want to support this frontend.
> +
>  comment "Digital terrestrial only tuners/PLL"
>  	depends on DVB_CORE
>  
> diff --git a/drivers/media/dvb-frontends/Makefile b/drivers/media/dvb-frontends/Makefile
> index dda0bee..5da7a25 100644
> --- a/drivers/media/dvb-frontends/Makefile
> +++ b/drivers/media/dvb-frontends/Makefile
> @@ -106,4 +106,5 @@ obj-$(CONFIG_DVB_RTL2830) += rtl2830.o
>  obj-$(CONFIG_DVB_RTL2832) += rtl2832.o
>  obj-$(CONFIG_DVB_M88RS2000) += m88rs2000.o
>  obj-$(CONFIG_DVB_AF9033) += af9033.o
> +obj-$(CONFIG_DVB_TC90522) += tc90522.o
>  
> diff --git a/drivers/media/dvb-frontends/tc90522.c b/drivers/media/dvb-frontends/tc90522.c
> new file mode 100644
> index 0000000..6a9ecfa
> --- /dev/null
> +++ b/drivers/media/dvb-frontends/tc90522.c
> @@ -0,0 +1,843 @@
> +/*
> + * Toshiba TC90522 Demodulator
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
> +#include <linux/dvb/frontend.h>
> +#include "dvb_math.h"
> +#include "tc90522.h"
> +
> +#define TC90522_I2C_THRU_REG 0xfe
> +
> +#define TC90522_MODULE_IDX(addr) (((u8)(addr) & 0x02U) >> 1)
> +
> +enum tc90522_tuning_status {
> +	STATUS_IDLE,
> +	STATUS_SET_FREQ,
> +	STATUS_CHECK_TUNER,
> +	STATUS_CHECK_DEMOD,
> +	STATUS_TRACK,
> +};
> +
> +struct tc90522_state {
> +	struct dvb_frontend dvb_fe;
> +
> +	struct tc90522_config cfg;
> +	struct i2c_adapter *i2c;
> +	struct i2c_adapter tuner_i2c;
> +	enum tc90522_tuning_status tuning_status;
> +	int retry_count;
> +
> +	bool lna;
> +};
> +
> +struct reg_val {
> +	u8 reg;
> +	u8 val;
> +};
> +
> +
> +static int
> +reg_write(struct tc90522_state *state, const struct reg_val *regs, int num)
> +{
> +	int i, ret;
> +	struct i2c_msg msg;
> +
> +	ret = 0;
> +	msg.addr = state->cfg.addr;
> +	msg.flags = 0;
> +	msg.len = 2;
> +	for (i = 0; i < num; i++) {
> +		msg.buf = (u8 *)&regs[i];
> +		ret = i2c_transfer(state->i2c, &msg, 1);
> +		if (ret < 0)
> +			break;
> +	}
> +	return ret;
> +}
> +
> +static int reg_read(struct tc90522_state *state, u8 reg, u8 *val, u8 len)
> +{
> +	struct i2c_msg msgs[2] = {
> +		{
> +			.addr = state->cfg.addr,
> +			.flags = 0,
> +			.buf = &reg,
> +			.len = 1,
> +		},
> +		{
> +			.addr = state->cfg.addr,
> +			.flags = I2C_M_RD,
> +			.buf = val,
> +			.len = len,
> +		},
> +	};
> +
> +	return i2c_transfer(state->i2c, msgs, ARRAY_SIZE(msgs));
> +}
> +
> +static int enable_lna(struct dvb_frontend *fe, bool on)
> +{
> +	struct tc90522_state *state;
> +
> +	state = fe->demodulator_priv;
> +	/* delegate to the parent board */
> +	if (fe->callback)
> +		fe->callback(fe, DVB_FRONTEND_COMPONENT_DEMOD,
> +				TC90522T_CMD_SET_LNA, on);
> +	state->lna = on;
> +	return 0;
> +}
> +
> +static int tc90522s_set_tsid(struct dvb_frontend *fe)
> +{
> +	struct reg_val set_tsid[] = {
> +		{ 0x8f, 00 },
> +		{ 0x90, 00 }
> +	};
> +
> +	set_tsid[0].val = (fe->dtv_property_cache.stream_id & 0xff00) >> 8;
> +	set_tsid[1].val = fe->dtv_property_cache.stream_id & 0xff;
> +	return reg_write(fe->demodulator_priv, set_tsid, ARRAY_SIZE(set_tsid));
> +}
> +
> +static int tc90522t_set_layers(struct dvb_frontend *fe)
> +{
> +	struct reg_val rv;
> +	u8 laysel;
> +
> +	laysel = ~fe->dtv_property_cache.isdbt_layer_enabled & 0x07;
> +	laysel = (laysel & 0x01) << 2 | (laysel & 0x02) | (laysel & 0x04) >> 2;
> +	rv.reg = 0x71;
> +	rv.val = laysel;
> +	return reg_write(fe->demodulator_priv, &rv, 1);
> +}
> +
> +/* frontend ops */
> +
> +static int tc90522s_read_status(struct dvb_frontend *fe, fe_status_t *status)
> +{
> +	int ret;
> +	u8 s;

"s" is a very bad name for an unsigned int. We generally use it for
strings. The same occurs on other functions. Instead, better to call it
as "reg".

> +
> +	*status = 0;
> +	ret = reg_read(fe->demodulator_priv, 0xc3, &s, 1);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (s & 0x80) /* input level under min ? */
> +		return 0;
> +	*status |= FE_HAS_SIGNAL;
> +
> +	if (s & 0x60) /* carrier? */
> +		return 0;
> +	*status |= FE_HAS_CARRIER | FE_HAS_VITERBI | FE_HAS_SYNC;
> +
> +	if (s & 0x10)
> +		return 0;
> +	if (reg_read(fe->demodulator_priv, 0xc5, &s, 1) < 0 || !(s & 0x03))
> +		return 0;
> +	*status |= FE_HAS_LOCK;
> +	return 0;
> +}
> +
> +static int tc90522t_read_status(struct dvb_frontend *fe, fe_status_t *status)
> +{
> +	int ret;
> +	u8 s;
> +
> +	*status = 0;
> +	ret = reg_read(fe->demodulator_priv, 0x96, &s, 1);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (s & 0xe0) {
> +		*status = FE_HAS_SIGNAL | FE_HAS_CARRIER | FE_HAS_VITERBI
> +				| FE_HAS_SYNC | FE_HAS_LOCK;
> +		return 0;
> +	}
> +
> +	ret = reg_read(fe->demodulator_priv, 0x80, &s, 1);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (s & 0xf0)
> +		return 0;
> +	*status |= FE_HAS_SIGNAL | FE_HAS_CARRIER;
> +
> +	if (s & 0x0c)
> +		return 0;
> +	*status |= FE_HAS_SYNC | FE_HAS_VITERBI;
> +
> +	if (s & 0x02)
> +		return 0;
> +	*status |= FE_HAS_LOCK;
> +	return 0;
> +}
> +
> +static int tc90522s_get_frontend(struct dvb_frontend *fe)
> +{
> +	static const fe_code_rate_t fec_conv[] = {
> +		FEC_NONE, /* unused */
> +		FEC_NONE, /* for BPSK */
> +		FEC_1_2, FEC_2_3, FEC_3_4, FEC_5_6, FEC_7_8, /* for QPSK */
> +		FEC_2_3, /* for 8PSK. (trellis code) */
> +	};
> +
> +	struct tc90522_state *state;
> +	struct dtv_frontend_properties *c;
> +	struct dtv_fe_stats *s;
> +	int ret, i;
> +	int layers;
> +	u8 val[10], v;
> +	u32 cndat;
> +
> +	state = fe->demodulator_priv;
> +	c = &fe->dtv_property_cache;
> +	c->delivery_system = SYS_ISDBS;
> +	c->symbol_rate = 28860000;

Hmm... symbol rate is fixed? That looks weird on my eyes.

> +
> +	layers = 0;
> +	ret = reg_read(state, 0xe8, val, 3);
> +	if (ret == 0) {
> +		/* high/single layer */
> +		v = (val[0] & 0x70) >> 4;
> +		c->modulation = (v == 7) ? PSK_8 : QPSK;
> +		c->fec_inner = fec_conv[v];
> +		c->layer[0].fec = c->fec_inner;
> +		c->layer[0].modulation = c->modulation;
> +		c->layer[0].segment_count = val[1] & 0x1f; /* slots */
> +
> +		/* low layer */
> +		v = (val[0] & 0x07);
> +		c->layer[1].fec = fec_conv[v];
> +		if (v == 0)  /* no low layer */
> +			c->layer[1].segment_count = 0;
> +		else
> +			c->layer[1].segment_count = val[2] & 0x1f; /* slots */
> +		/* actually, BPSK for v==1, NONE for v==0 */
> +		c->layer[1].modulation = QPSK;
> +		layers = (v > 0) ? 2 : 1;
> +	}
> +
> +	/* statistics */
> +
> +	s = &c->strength;
> +	s->len = 0;
> +	if (fe->ops.tuner_ops.get_rf_strength) {
> +		s16 str;
> +
> +		s->len = 1;
> +		ret = fe->ops.tuner_ops.get_rf_strength(fe, (u16 *)&str);
> +		if (ret == 0) {
> +			s->stat[0].scale = FE_SCALE_DECIBEL;
> +			s->stat[0].svalue = str;

Ah, I see now that you're actually using DVBv5. I suspect, however,
that you'll have a trouble passing it as u16. Using this get_rf_strength
ops here seems awkward, as it forces to pass the value as u16.

The better is likely to add a new ops to get rf strength in dBm as s64,
just like the way we use it on DVBv5.

> +		} else
> +			s->stat[0].scale = FE_SCALE_NOT_AVAILABLE;
> +	}
> +
> +	s = &c->cnr;
> +	s->len = 1;
> +	s->stat[0].scale = FE_SCALE_NOT_AVAILABLE;
> +	cndat = 0;
> +	ret = reg_read(state, 0xbc, val, 2);
> +	if (ret == 0)
> +		cndat = val[0] << 8 | val[1];
> +	if (cndat >= 3000) {
> +		u32 p, p4;
> +		s64 cn;
> +
> +		cndat -= 3000;  /* cndat: 4.12 fixed point float */
> +		/*
> +		 * cnr[mdB] = -1634.6 * P^5 + 14341 * P^4 - 50259 * P^3
> +		 *                 + 88977 * P^2 - 89565 * P + 58857
> +		 *  (P = sqrt(cndat) / 64)
> +		 */
> +		/* p := sqrt(cndat) << 8 = P << 14, 2.14 fixed  point float */
> +		/* cn = cnr << 3 */
> +		p = int_sqrt(cndat << 16);
> +		p4 = cndat * cndat;
> +		cn = (-16346LL * p4 * p / 10) >> 35;
> +		cn += (14341LL * p4) >> 21;
> +		cn -= (50259LL * cndat * p) >> 23;
> +		cn += (88977LL * cndat) >> 9;
> +		cn -= (89565LL * p) >> 11;
> +		cn += 58857  << 3;
> +		s->stat[0].svalue = cn >> 3;
> +		s->stat[0].scale = FE_SCALE_DECIBEL;
> +	}
> +
> +	/* per-layer post viterbi BER (or PER? config dependent?) */
> +	s = &c->post_bit_error;
> +	memset(s, 0, sizeof(*s));
> +	s->len = layers;
> +	ret = reg_read(state, 0xeb, val, 10);
> +	if (ret < 0)
> +		for (i = 0; i < layers; i++)
> +			s->stat[i].scale = FE_SCALE_NOT_AVAILABLE;
> +	else {
> +		for (i = 0; i < layers; i++) {
> +			s->stat[i].scale = FE_SCALE_COUNTER;
> +			s->stat[i].uvalue = val[i * 5] << 16
> +				| val[i * 5 + 1] << 8 | val[i * 5 + 2];
> +		}
> +	}
> +	s = &c->post_bit_count;
> +	memset(s, 0, sizeof(*s));
> +	s->len = layers;
> +	if (ret < 0)
> +		for (i = 0; i < layers; i++)
> +			s->stat[i].scale = FE_SCALE_NOT_AVAILABLE;
> +	else {
> +		for (i = 0; i < layers; i++) {
> +			s->stat[i].scale = FE_SCALE_COUNTER;
> +			s->stat[i].uvalue =
> +				val[i * 5 + 3] << 8 | val[i * 5 + 4];
> +			s->stat[i].uvalue *= 204 * 8;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static int tc90522t_get_frontend(struct dvb_frontend *fe)
> +{
> +	static const fe_transmit_mode_t tm_conv[] = {
> +		TRANSMISSION_MODE_2K,
> +		TRANSMISSION_MODE_4K,
> +		TRANSMISSION_MODE_8K, 0

Better to put the final 0 on a separate line, to be consistent.

I would also move those tables out of get_frontend, as this improves
readability.

> +	};
> +	static const fe_code_rate_t fec_conv[] = {
> +		FEC_1_2, FEC_2_3, FEC_3_4, FEC_5_6, FEC_7_8, 0, 0, 0
> +	};
> +	static const fe_modulation_t mod_conv[] = {
> +		DQPSK, QPSK, QAM_16, QAM_64, 0, 0, 0, 0
> +	};
> +	struct tc90522_state *state;
> +	struct dtv_frontend_properties *c;
> +	struct dtv_fe_stats *s;
> +	int ret, i;
> +	int layers;
> +	u8 val[15], mode;
> +	u32 cndat;
> +
> +	state = fe->demodulator_priv;
> +	c = &fe->dtv_property_cache;
> +	c->delivery_system = SYS_ISDBT;
> +	c->bandwidth_hz = 6000000;
> +	mode = 1;
> +	ret = reg_read(state, 0xb0, val, 1);
> +	if (ret == 0) {
> +		mode = (val[0] & 0xc0) >> 2;
> +		c->transmission_mode = tm_conv[mode];
> +		c->guard_interval = (val[0] & 0x30) >> 4;
> +	}
> +
> +	ret = reg_read(state, 0xb2, val, 6);
> +	layers = 0;
> +	if (ret == 0) {
> +		u8 v;
> +
> +		c->isdbt_partial_reception = val[0] & 0x01;
> +		c->isdbt_sb_mode = (val[0] & 0xc0) == 0x01;
> +
> +		/* layer A */
> +		v = (val[2] & 0x78) >> 3;
> +		if (v == 0x0f)
> +			c->layer[0].segment_count = 0;
> +		else {
> +			layers++;
> +			c->layer[0].segment_count = v;
> +			c->layer[0].fec = fec_conv[(val[1] & 0x1c) >> 2];
> +			c->layer[0].modulation = mod_conv[(val[1] & 0xe0) >> 5];
> +			v = (val[1] & 0x03) << 1 | (val[2] & 0x80) >> 7;
> +			c->layer[0].interleaving = v;
> +		}
> +
> +		/* layer B */
> +		v = (val[3] & 0x03) << 1 | (val[4] & 0xc0) >> 6;
> +		if (v == 0x0f)
> +			c->layer[1].segment_count = 0;
> +		else {
> +			layers++;
> +			c->layer[1].segment_count = v;
> +			c->layer[1].fec = fec_conv[(val[3] & 0xe0) >> 5];
> +			c->layer[1].modulation = mod_conv[(val[2] & 0x07)];
> +			c->layer[1].interleaving = (val[3] & 0x1c) >> 2;
> +		}
> +
> +		/* layer C */
> +		v = (val[5] & 0x1e) >> 1;
> +		if (v == 0x0f)
> +			c->layer[2].segment_count = 0;
> +		else {
> +			layers++;
> +			c->layer[2].segment_count = v;
> +			c->layer[2].fec = fec_conv[(val[4] & 0x07)];
> +			c->layer[2].modulation = mod_conv[(val[4] & 0x38) >> 3];
> +			c->layer[2].interleaving = (val[5] & 0xe0) >> 5;
> +		}
> +	}
> +
> +	/* statistics */
> +
> +	s = &c->strength;
> +	s->len = 0;
> +	if (fe->ops.tuner_ops.get_rf_strength) {
> +		s16 str;
> +
> +		s->len = 1;
> +		ret = fe->ops.tuner_ops.get_rf_strength(fe, (u16 *)&str);
> +		if (ret == 0) {
> +			s->stat[0].scale = FE_SCALE_DECIBEL;
> +			s->stat[0].svalue = str;
> +		} else
> +			s->stat[0].scale = FE_SCALE_NOT_AVAILABLE;
> +	}
> +
> +	s = &c->cnr;
> +	s->len = 1;
> +	s->stat[0].scale = FE_SCALE_NOT_AVAILABLE;
> +	cndat = 0;
> +	ret = reg_read(state, 0x8b, val, 3);
> +	if (ret == 0)
> +		cndat = val[0] << 16 | val[1] << 8 | val[2];
> +	if (cndat != 0) {
> +		u32 p, tmp;
> +		s64 cn;
> +
> +		/*
> +		 * cnr[mdB] = 0.024 P^4 - 1.6 P^3 + 39.8 P^2 + 549.1 P + 3096.5
> +		 * (P = 10log10(5505024/cndat))
> +		 */
> +		/* cn = cnr << 3 (61.3 fixed point float */
> +		/* p = 10log10(5505024/cndat) << 24  (8.24 fixed point float)*/
> +		p = intlog10(5505024) - intlog10(cndat);
> +		p *= 10;
> +
> +		cn = 24772;
> +		cn += ((43827LL * p) / 10) >> 24;
> +		tmp = p >> 8;
> +		cn += ((3184LL * tmp * tmp) / 10) >> 32;
> +		tmp = p >> 13;
> +		cn -= ((128LL * tmp * tmp * tmp) / 10) >> 33;
> +		tmp = p >> 18;
> +		cn += ((192LL * tmp * tmp * tmp * tmp) / 1000) >> 24;
> +
> +		s->stat[0].svalue = cn >> 3;
> +		s->stat[0].scale = FE_SCALE_DECIBEL;
> +	}
> +
> +	/* per-layer post viterbi BER (or PER? config dependent?) */
> +	s = &c->post_bit_error;
> +	memset(s, 0, sizeof(*s));
> +	s->len = layers;
> +	ret = reg_read(state, 0x9d, val, 15);
> +	if (ret < 0)
> +		for (i = 0; i < layers; i++)
> +			s->stat[i].scale = FE_SCALE_NOT_AVAILABLE;
> +	else {
> +		for (i = 0; i < layers; i++) {
> +			s->stat[i].scale = FE_SCALE_COUNTER;
> +			s->stat[i].uvalue = val[i * 3] << 16
> +				| val[i * 3 + 1] << 8 | val[i * 3 + 2];
> +		}
> +	}
> +	s = &c->post_bit_count;
> +	memset(s, 0, sizeof(*s));
> +	s->len = layers;
> +	if (ret < 0)
> +		for (i = 0; i < layers; i++)
> +			s->stat[i].scale = FE_SCALE_NOT_AVAILABLE;
> +	else {
> +		for (i = 0; i < layers; i++) {
> +			s->stat[i].scale = FE_SCALE_COUNTER;
> +			s->stat[i].uvalue =
> +				val[9 + i * 2] << 8 | val[9 + i * 2 + 1];
> +			s->stat[i].uvalue *= 204 * 8;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static int tc90522s_set_voltage(struct dvb_frontend *fe, fe_sec_voltage_t volt)
> +{
> +	int ret;
> +
> +	ret = 0;
> +	if (fe->callback)
> +		ret = fe->callback(fe, DVB_FRONTEND_COMPONENT_DEMOD,
> +				TC90522S_CMD_SET_LNB, volt);
> +	return ret;
> +}
> +
> +static int tc90522t_set_lna(struct dvb_frontend *fe)
> +{
> +	struct tc90522_state *state;
> +	int ret;
> +
> +	ret = 0;
> +	state = fe->demodulator_priv;
> +	if (fe->dtv_property_cache.lna != LNA_AUTO &&
> +	    fe->dtv_property_cache.lna != state->lna)
> +		ret = enable_lna(fe, fe->dtv_property_cache.lna);
> +	return ret;
> +}
> +
> +static int tc90522_set_frontend(struct dvb_frontend *fe)
> +{
> +	static const struct reg_val reset_sat = { 0x03, 0x01 };
> +	static const struct reg_val reset_ter = { 0x01, 0x40 };
> +	struct tc90522_state *state;
> +	int ret, i;
> +	u32 s;
> +
> +	state = fe->demodulator_priv;
> +
> +	if (fe->ops.tuner_ops.set_params)
> +		ret = fe->ops.tuner_ops.set_params(fe);

Hmm... I'm not seeing any part of the driver parsing the ISDB
parameters (except for the frequency).

> +	else
> +		ret = -ENODEV;
> +	if (ret < 0)
> +		goto failed;
> +
> +	if (fe->ops.tuner_ops.get_status) {
> +		for (i = 50; i > 0; i--) {
> +			ret = fe->ops.tuner_ops.get_status(fe, &s);
> +			if (ret < 0)
> +				goto failed;
> +			if (s & TUNER_STATUS_LOCKED)
> +				break;
> +			usleep_range(2000, 3000);
> +		}
> +		if (i <= 0) {
> +			ret = -ETIMEDOUT;
> +			goto failed;
> +		}
> +	}
> +
> +	if (fe->ops.delsys[0] == SYS_ISDBS) {
> +		ret = tc90522s_set_tsid(fe);
> +		if (ret < 0)
> +			goto failed;
> +		ret = reg_write(state, &reset_sat, 1);
> +	} else {
> +		ret = tc90522t_set_layers(fe);
> +		if (ret < 0)
> +			goto failed;
> +		ret = reg_write(state, &reset_ter, 1);
> +	}
> +	if (ret < 0)
> +		goto failed;
> +
> +	return 0;
> +
> +failed:
> +	dev_warn(&state->tuner_i2c.dev, "(%s) failed. [adap%d-fe%d]\n",
> +			__func__, fe->dvb->num, fe->id);
> +	return ret;
> +}
> +
> +static int tc90522_get_tune_settings(struct dvb_frontend *fe,
> +	struct dvb_frontend_tune_settings *settings)
> +{
> +	if (fe->ops.delsys[0] == SYS_ISDBS) {
> +		settings->min_delay_ms = 250;
> +		settings->step_size = 1000;
> +		settings->max_drift = settings->step_size * 2;
> +	} else {
> +		settings->min_delay_ms = 400;
> +		settings->step_size = 142857;
> +		settings->max_drift = settings->step_size;
> +	}
> +	return 0;
> +}
> +
> +static int tc90522_set_if_agc(struct dvb_frontend *fe, bool on)
> +{
> +	struct reg_val sat_agc[] = {
> +		{ 0x0a, 0x00 },
> +		{ 0x10, 0x30 },
> +		{ 0x11, 0x00 },
> +		{ 0x03, 0x01 },
> +	};
> +	struct reg_val ter_agc[] = {
> +		{ 0x25, 0x00 },
> +		{ 0x23, 0x4c },
> +		{ 0x01, 0x40 },
> +	};
> +	struct tc90522_state *state;
> +	struct reg_val *rv;
> +	int num;
> +
> +	state = fe->demodulator_priv;
> +	if (fe->ops.delsys[0] == SYS_ISDBS) {
> +		sat_agc[0].val = on ? 0xff : 0x00;
> +		sat_agc[1].val |= 0x80;
> +		sat_agc[1].val |= on ? 0x01 : 0x00;
> +		sat_agc[2].val |= on ? 0x40 : 0x00;
> +		rv = sat_agc;
> +		num = ARRAY_SIZE(sat_agc);
> +	} else {
> +		ter_agc[0].val = on ? 0x40 : 0x00;
> +		ter_agc[1].val |= on ? 0x00 : 0x01;
> +		rv = ter_agc;
> +		num = ARRAY_SIZE(ter_agc);
> +	}
> +	return reg_write(state, rv, num);
> +}
> +
> +static int tc90522_sleep(struct dvb_frontend *fe)
> +{
> +	static const struct reg_val sleep_sat = { 0x17, 0x01 };
> +	static const struct reg_val sleep_ter = { 0x03, 0x90 };
> +	struct tc90522_state *state;
> +	int ret;
> +
> +	state = fe->demodulator_priv;
> +	if (fe->ops.delsys[0] == SYS_ISDBS)
> +		ret = reg_write(state, &sleep_sat, 1);
> +	else {
> +		ret = reg_write(state, &sleep_ter, 1);
> +		if (ret == 0 && fe->dtv_property_cache.lna == LNA_AUTO)
> +			ret = enable_lna(fe, false);
> +	}
> +	if (ret < 0)
> +		dev_warn(&state->tuner_i2c.dev,
> +			"(%s) failed. [adap%d-fe%d]\n",
> +			__func__, fe->dvb->num, fe->id);
> +	return ret;
> +}
> +
> +static void tc90522_release(struct dvb_frontend *fe)
> +{
> +	struct tc90522_state *state;
> +
> +	state = fe->demodulator_priv;
> +	i2c_del_adapter(&state->tuner_i2c);
> +	fe->demodulator_priv = NULL;
> +	kfree(state);
> +}
> +
> +
> +static int tc90522_init(struct dvb_frontend *fe)
> +{
> +	static const struct reg_val wakeup_sat = { 0x17, 0x00 };
> +	static const struct reg_val wakeup_ter = { 0x03, 0x80 };
> +	struct tc90522_state *state;
> +	int ret;
> +
> +	/*
> +	 * Because the init sequence is not public,
> +	 * the parent device/driver should have init'ed the device before.
> +	 * just wake up the device here.
> +	 */
> +
> +	state = fe->demodulator_priv;
> +	if (fe->ops.delsys[0] == SYS_ISDBS)
> +		ret = reg_write(state, &wakeup_sat, 1);
> +	else {
> +		ret = reg_write(state, &wakeup_ter, 1);
> +		if (ret == 0 && fe->dtv_property_cache.lna == LNA_AUTO)
> +			ret = enable_lna(fe, true);
> +	}
> +	fe->dtv_property_cache.stream_id = 0;
> +	fe->dtv_property_cache.isdbt_layer_enabled = 7;
> +	if (ret < 0) {
> +		dev_warn(&state->tuner_i2c.dev,
> +			"(%s) failed. [adap%d-fe%d]\n",
> +			__func__, fe->dvb->num, fe->id);
> +		return ret;
> +	}
> +	return tc90522_set_if_agc(fe, true);
> +}
> +
> +
> +/*
> + * tuner I2C
> + */
> +
> +static int
> +tc90522_master_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs, int num)
> +{
> +	struct tc90522_state *state;
> +	struct i2c_msg *new_msgs;
> +	int i, j;
> +	int ret, rd_num;
> +	u8 wbuf[256];
> +	u8 *p, *bufend;
> +
> +	rd_num = 0;
> +	for (i = 0; i < num; i++)
> +		if (msgs[i].flags & I2C_M_RD)
> +			rd_num++;
> +	new_msgs = kmalloc(sizeof(*new_msgs) * (num + rd_num), GFP_KERNEL);
> +	if (!new_msgs)
> +		return -ENOMEM;
> +
> +	state = i2c_get_adapdata(adap);
> +	p = wbuf;
> +	bufend = wbuf + sizeof(wbuf);
> +	for (i = 0, j = 0; i < num; i++, j++) {
> +		new_msgs[j].addr = state->cfg.addr;
> +		new_msgs[j].flags = msgs[i].flags;
> +
> +		if (msgs[i].flags & I2C_M_RD) {
> +			new_msgs[j].flags &= ~I2C_M_RD;
> +			if (p + 2 > bufend)
> +				break;
> +			p[0] = TC90522_I2C_THRU_REG;
> +			p[1] = msgs[i].addr << 1 | 0x01;
> +			new_msgs[j].buf = p;
> +			new_msgs[j].len = 2;
> +			p += 2;
> +			j++;
> +			new_msgs[j].addr = state->cfg.addr;
> +			new_msgs[j].flags = msgs[i].flags;
> +			new_msgs[j].buf = msgs[i].buf;
> +			new_msgs[j].len = msgs[i].len;
> +			continue;
> +		}
> +
> +		if (p + msgs[i].len + 2 > bufend)
> +			break;
> +		p[0] = TC90522_I2C_THRU_REG;
> +		p[1] = msgs[i].addr << 1;
> +		memcpy(p + 2, msgs[i].buf, msgs[i].len);
> +		new_msgs[j].buf = p;
> +		new_msgs[j].len = msgs[i].len + 2;
> +		p += new_msgs[j].len;
> +	}
> +	if (i < num)
> +		ret = -ENOMEM;
> +	else
> +		ret = i2c_transfer(state->i2c, new_msgs, j);
> +	kfree(new_msgs);
> +	return ret;
> +}
> +
> +u32 tc90522_functionality(struct i2c_adapter *adap)
> +{
> +	return I2C_FUNC_I2C;
> +}
> +
> +static const struct i2c_algorithm tc90522_tuner_i2c_algo = {
> +	.master_xfer   = &tc90522_master_xfer,
> +	.functionality = &tc90522_functionality,
> +};
> +
> +
> +/*
> + * exported functions
> + */
> +
> +static const struct dvb_frontend_ops tc90522_ops_sat = {
> +	.delsys = { SYS_ISDBS },
> +	.info = {
> +		.name = "Toshiba TC90522 ISDB-S module",
> +		.frequency_min =  950000,
> +		.frequency_max = 2150000,
> +		.caps = FE_CAN_INVERSION_AUTO | FE_CAN_FEC_AUTO |
> +			FE_CAN_QAM_AUTO | FE_CAN_TRANSMISSION_MODE_AUTO |
> +			FE_CAN_GUARD_INTERVAL_AUTO | FE_CAN_HIERARCHY_AUTO,
> +	},
> +
> +	.release = tc90522_release,
> +	.init = tc90522_init,
> +	.sleep = tc90522_sleep,
> +	.set_frontend = tc90522_set_frontend,
> +	.get_tune_settings = tc90522_get_tune_settings,
> +
> +	.get_frontend = tc90522s_get_frontend,
> +	.read_status = tc90522s_read_status,
> +	.set_voltage = tc90522s_set_voltage,
> +};
> +
> +static const struct dvb_frontend_ops tc90522_ops_ter = {
> +	.delsys = { SYS_ISDBT },
> +	.info = {
> +		.name = "Toshiba TC90522 ISDB-T module",
> +		.frequency_min = 470000000,
> +		.frequency_max = 770000000,
> +		.frequency_stepsize = 142857,
> +		.caps = FE_CAN_INVERSION_AUTO |
> +			FE_CAN_FEC_1_2  | FE_CAN_FEC_2_3 | FE_CAN_FEC_3_4 |
> +			FE_CAN_FEC_5_6  | FE_CAN_FEC_7_8 | FE_CAN_FEC_AUTO |
> +			FE_CAN_QPSK     | FE_CAN_QAM_16 | FE_CAN_QAM_64 |
> +			FE_CAN_QAM_AUTO | FE_CAN_TRANSMISSION_MODE_AUTO |
> +			FE_CAN_GUARD_INTERVAL_AUTO | FE_CAN_RECOVER |
> +			FE_CAN_HIERARCHY_AUTO,
> +	},
> +
> +	.release = tc90522_release,
> +	.init = tc90522_init,
> +	.sleep = tc90522_sleep,
> +	.set_frontend = tc90522_set_frontend,
> +	.get_tune_settings = tc90522_get_tune_settings,
> +
> +	.get_frontend = tc90522t_get_frontend,
> +	.read_status = tc90522t_read_status,
> +	.set_lna = tc90522t_set_lna,
> +};
> +
> +struct dvb_frontend *
> +tc90522_attach(const struct tc90522_config *cfg, struct i2c_adapter *i2c)
> +{
> +	struct tc90522_state *state;
> +	const struct dvb_frontend_ops *ops;
> +	struct i2c_adapter *adap;
> +	int ret;
> +
> +	state = kzalloc(sizeof(*state), GFP_KERNEL);
> +	if (!state)
> +		return NULL;
> +
> +	memcpy(&state->cfg, cfg, sizeof(*cfg));
> +	state->i2c = i2c;
> +	ops = TC90522_IS_ISDBS(cfg->addr) ? &tc90522_ops_sat : &tc90522_ops_ter;
> +	memcpy(&state->dvb_fe.ops, ops, sizeof(*ops));
> +	state->dvb_fe.demodulator_priv = state;
> +
> +	adap = &state->tuner_i2c;
> +	adap->owner = i2c->owner;
> +	adap->algo = &tc90522_tuner_i2c_algo;
> +	adap->dev.parent = i2c->dev.parent;
> +	strlcpy(adap->name, "tc90522 tuner", sizeof(adap->name));
> +	i2c_set_adapdata(adap, state);
> +	ret = i2c_add_adapter(adap);
> +	if (ret < 0) {
> +		kfree(state);
> +		return NULL;
> +	}
> +	dev_info(&i2c->dev, "Toshiba TC90522 attached.\n");
> +	return &state->dvb_fe;
> +}
> +EXPORT_SYMBOL(tc90522_attach);
> +
> +
> +struct i2c_adapter *tc90522_get_tuner_i2c(struct dvb_frontend *fe)
> +{
> +	struct tc90522_state *state;
> +
> +	state = fe->demodulator_priv;
> +	return &state->tuner_i2c;
> +}
> +EXPORT_SYMBOL(tc90522_get_tuner_i2c);
> +
> +
> +MODULE_DESCRIPTION("Toshiba TC90522 frontend");
> +MODULE_AUTHOR("Akihiro TSUKADA");
> +MODULE_LICENSE("GPL");
> diff --git a/drivers/media/dvb-frontends/tc90522.h b/drivers/media/dvb-frontends/tc90522.h
> new file mode 100644
> index 0000000..d55a6be
> --- /dev/null
> +++ b/drivers/media/dvb-frontends/tc90522.h
> @@ -0,0 +1,63 @@
> +/*
> + * Toshiba TC90522 Demodulator
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
> +/*
> + * The demod has 4 input (2xISDB-T and 2xISDB-S),
> + * and provides independent sub modules for each input.
> + * As the sub modules work in parallel and have the separate i2c addr's,
> + * this driver treats each sub module as one demod device.
> + */
> +
> +#ifndef TC90522_H
> +#define TC90522_H
> +
> +#include <linux/i2c.h>
> +#include <linux/kconfig.h>
> +#include "dvb_frontend.h"
> +
> +#define TC90522_IS_ISDBS(addr) (addr & 1)
> +
> +#define TC90522T_CMD_SET_LNA 1
> +#define TC90522S_CMD_SET_LNB 1
> +
> +struct tc90522_config {
> +	u8 addr;
> +};
> +
> +#if IS_ENABLED(CONFIG_DVB_TC90522)
> +
> +extern struct dvb_frontend *tc90522_attach(const struct tc90522_config *cfg,
> +		struct i2c_adapter *i2c);
> +
> +extern struct i2c_adapter *tc90522_get_tuner_i2c(struct dvb_frontend *fe);
> +
> +#else
> +static inline struct dvb_frontend *tc90522_attach(
> +	const struct tc90522_config *cfg, struct i2c_adapter *i2c)
> +{
> +	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
> +	return NULL;
> +}
> +
> +static inline struct i2c_adapter *tc90522_get_tuner_i2c(struct dvb_frontend *fe)
> +{
> +	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
> +	return NULL;
> +}
> +
> +#endif
> +
> +#endif /* TC90522_H */
