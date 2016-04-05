Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:33693 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759502AbcDEQaa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Apr 2016 12:30:30 -0400
Date: Tue, 5 Apr 2016 09:30:25 -0700
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: <info@are.ma>
Cc: <linux-media@vger.kernel.org>,
	"=?UTF-8?B?0JHRg9C00Lgg0KDQvtC80LDQvdGC?= =?UTF-8?B?0L4s?= AreMa Inc"
	<knightrider@are.ma>, <linux-kernel@vger.kernel.org>,
	<crope@iki.fi>, <mchehab@osg.samsung.com>, <hdegoede@redhat.com>,
	<laurent.pinchart@ideasonboard.com>, <mkrufky@linuxtv.org>,
	<sylvester.nawrocki@gmail.com>, <g.liakhovetski@gmx.de>,
	<peter.senna@gmail.com>
Subject: Re: [media 2/5] drop backstabbing drivers
Message-ID: <20160405093025.66fc7b74@vela.lan>
In-Reply-To: <a4efc3c0aca884cac0bdc83b4121f8829ce8b258.1459872226.git.knightrider@are.ma>
References: <cover.1459872226.git.knightrider@are.ma>
	<a4efc3c0aca884cac0bdc83b4121f8829ce8b258.1459872226.git.knightrider@are.ma>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 6 Apr 2016 01:14:11 +0900
<info@are.ma> escreveu:

> From: Буди Романто, AreMa Inc <knightrider@are.ma>

You should, instead, add the stuff you need to the existing drivers and not
remove them.

> Obsoleted & superseded, please read cover letter for details.

Cover letter is not stored at the git history. So, it should be used
with care, to just help reviewers to see the hole picture, but not
to describe the patches themselves.

So, if there are important information out there, required to understand
why/what/how a patch is needed, this should be moved into the patch 
descriptions and not being kept only at the cover letter.


Regards,
Mauro


> 
> Signed-off-by: Буди Романто, AreMa Inc <knightrider@are.ma>
> ---
>  drivers/media/dvb-frontends/tc90522.c | 840 --------------------------------
>  drivers/media/dvb-frontends/tc90522.h |  42 --
>  drivers/media/pci/pt3/Kconfig         |  10 -
>  drivers/media/pci/pt3/Makefile        |   8 -
>  drivers/media/pci/pt3/pt3.c           | 874 ----------------------------------
>  drivers/media/pci/pt3/pt3.h           | 186 --------
>  drivers/media/pci/pt3/pt3_dma.c       | 225 ---------
>  drivers/media/pci/pt3/pt3_i2c.c       | 240 ----------
>  drivers/media/tuners/mxl301rf.c       | 349 --------------
>  drivers/media/tuners/mxl301rf.h       |  26 -
>  drivers/media/tuners/qm1d1c0042.c     | 448 -----------------
>  drivers/media/tuners/qm1d1c0042.h     |  37 --
>  12 files changed, 3285 deletions(-)
>  delete mode 100644 drivers/media/dvb-frontends/tc90522.c
>  delete mode 100644 drivers/media/dvb-frontends/tc90522.h
>  delete mode 100644 drivers/media/pci/pt3/Kconfig
>  delete mode 100644 drivers/media/pci/pt3/Makefile
>  delete mode 100644 drivers/media/pci/pt3/pt3.c
>  delete mode 100644 drivers/media/pci/pt3/pt3.h
>  delete mode 100644 drivers/media/pci/pt3/pt3_dma.c
>  delete mode 100644 drivers/media/pci/pt3/pt3_i2c.c
>  delete mode 100644 drivers/media/tuners/mxl301rf.c
>  delete mode 100644 drivers/media/tuners/mxl301rf.h
>  delete mode 100644 drivers/media/tuners/qm1d1c0042.c
>  delete mode 100644 drivers/media/tuners/qm1d1c0042.h
> 
> diff --git a/drivers/media/dvb-frontends/tc90522.c b/drivers/media/dvb-frontends/tc90522.c
> deleted file mode 100644
> index 31cd325..0000000
> --- a/drivers/media/dvb-frontends/tc90522.c
> +++ /dev/null
> @@ -1,840 +0,0 @@
> -/*
> - * Toshiba TC90522 Demodulator
> - *
> - * Copyright (C) 2014 Akihiro Tsukada <tskd08@gmail.com>
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation version 2.
> - *
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - */
> -
> -/*
> - * NOTICE:
> - * This driver is incomplete and lacks init/config of the chips,
> - * as the necessary info is not disclosed.
> - * It assumes that users of this driver (such as a PCI bridge of
> - * DTV receiver cards) properly init and configure the chip
> - * via I2C *before* calling this driver's init() function.
> - *
> - * Currently, PT3 driver is the only one that uses this driver,
> - * and contains init/config code in its firmware.
> - * Thus some part of the code might be dependent on PT3 specific config.
> - */
> -
> -#include <linux/kernel.h>
> -#include <linux/math64.h>
> -#include <linux/dvb/frontend.h>
> -#include "dvb_math.h"
> -#include "tc90522.h"
> -
> -#define TC90522_I2C_THRU_REG 0xfe
> -
> -#define TC90522_MODULE_IDX(addr) (((u8)(addr) & 0x02U) >> 1)
> -
> -struct tc90522_state {
> -	struct tc90522_config cfg;
> -	struct dvb_frontend fe;
> -	struct i2c_client *i2c_client;
> -	struct i2c_adapter tuner_i2c;
> -
> -	bool lna;
> -};
> -
> -struct reg_val {
> -	u8 reg;
> -	u8 val;
> -};
> -
> -static int
> -reg_write(struct tc90522_state *state, const struct reg_val *regs, int num)
> -{
> -	int i, ret;
> -	struct i2c_msg msg;
> -
> -	ret = 0;
> -	msg.addr = state->i2c_client->addr;
> -	msg.flags = 0;
> -	msg.len = 2;
> -	for (i = 0; i < num; i++) {
> -		msg.buf = (u8 *)&regs[i];
> -		ret = i2c_transfer(state->i2c_client->adapter, &msg, 1);
> -		if (ret == 0)
> -			ret = -EIO;
> -		if (ret < 0)
> -			return ret;
> -	}
> -	return 0;
> -}
> -
> -static int reg_read(struct tc90522_state *state, u8 reg, u8 *val, u8 len)
> -{
> -	struct i2c_msg msgs[2] = {
> -		{
> -			.addr = state->i2c_client->addr,
> -			.flags = 0,
> -			.buf = &reg,
> -			.len = 1,
> -		},
> -		{
> -			.addr = state->i2c_client->addr,
> -			.flags = I2C_M_RD,
> -			.buf = val,
> -			.len = len,
> -		},
> -	};
> -	int ret;
> -
> -	ret = i2c_transfer(state->i2c_client->adapter, msgs, ARRAY_SIZE(msgs));
> -	if (ret == ARRAY_SIZE(msgs))
> -		ret = 0;
> -	else if (ret >= 0)
> -		ret = -EIO;
> -	return ret;
> -}
> -
> -static struct tc90522_state *cfg_to_state(struct tc90522_config *c)
> -{
> -	return container_of(c, struct tc90522_state, cfg);
> -}
> -
> -
> -static int tc90522s_set_tsid(struct dvb_frontend *fe)
> -{
> -	struct reg_val set_tsid[] = {
> -		{ 0x8f, 00 },
> -		{ 0x90, 00 }
> -	};
> -
> -	set_tsid[0].val = (fe->dtv_property_cache.stream_id & 0xff00) >> 8;
> -	set_tsid[1].val = fe->dtv_property_cache.stream_id & 0xff;
> -	return reg_write(fe->demodulator_priv, set_tsid, ARRAY_SIZE(set_tsid));
> -}
> -
> -static int tc90522t_set_layers(struct dvb_frontend *fe)
> -{
> -	struct reg_val rv;
> -	u8 laysel;
> -
> -	laysel = ~fe->dtv_property_cache.isdbt_layer_enabled & 0x07;
> -	laysel = (laysel & 0x01) << 2 | (laysel & 0x02) | (laysel & 0x04) >> 2;
> -	rv.reg = 0x71;
> -	rv.val = laysel;
> -	return reg_write(fe->demodulator_priv, &rv, 1);
> -}
> -
> -/* frontend ops */
> -
> -static int tc90522s_read_status(struct dvb_frontend *fe, enum fe_status *status)
> -{
> -	struct tc90522_state *state;
> -	int ret;
> -	u8 reg;
> -
> -	state = fe->demodulator_priv;
> -	ret = reg_read(state, 0xc3, &reg, 1);
> -	if (ret < 0)
> -		return ret;
> -
> -	*status = 0;
> -	if (reg & 0x80) /* input level under min ? */
> -		return 0;
> -	*status |= FE_HAS_SIGNAL;
> -
> -	if (reg & 0x60) /* carrier? */
> -		return 0;
> -	*status |= FE_HAS_CARRIER | FE_HAS_VITERBI | FE_HAS_SYNC;
> -
> -	if (reg & 0x10)
> -		return 0;
> -	if (reg_read(state, 0xc5, &reg, 1) < 0 || !(reg & 0x03))
> -		return 0;
> -	*status |= FE_HAS_LOCK;
> -	return 0;
> -}
> -
> -static int tc90522t_read_status(struct dvb_frontend *fe, enum fe_status *status)
> -{
> -	struct tc90522_state *state;
> -	int ret;
> -	u8 reg;
> -
> -	state = fe->demodulator_priv;
> -	ret = reg_read(state, 0x96, &reg, 1);
> -	if (ret < 0)
> -		return ret;
> -
> -	*status = 0;
> -	if (reg & 0xe0) {
> -		*status = FE_HAS_SIGNAL | FE_HAS_CARRIER | FE_HAS_VITERBI
> -				| FE_HAS_SYNC | FE_HAS_LOCK;
> -		return 0;
> -	}
> -
> -	ret = reg_read(state, 0x80, &reg, 1);
> -	if (ret < 0)
> -		return ret;
> -
> -	if (reg & 0xf0)
> -		return 0;
> -	*status |= FE_HAS_SIGNAL | FE_HAS_CARRIER;
> -
> -	if (reg & 0x0c)
> -		return 0;
> -	*status |= FE_HAS_SYNC | FE_HAS_VITERBI;
> -
> -	if (reg & 0x02)
> -		return 0;
> -	*status |= FE_HAS_LOCK;
> -	return 0;
> -}
> -
> -static const enum fe_code_rate fec_conv_sat[] = {
> -	FEC_NONE, /* unused */
> -	FEC_1_2, /* for BPSK */
> -	FEC_1_2, FEC_2_3, FEC_3_4, FEC_5_6, FEC_7_8, /* for QPSK */
> -	FEC_2_3, /* for 8PSK. (trellis code) */
> -};
> -
> -static int tc90522s_get_frontend(struct dvb_frontend *fe,
> -				 struct dtv_frontend_properties *c)
> -{
> -	struct tc90522_state *state;
> -	struct dtv_fe_stats *stats;
> -	int ret, i;
> -	int layers;
> -	u8 val[10];
> -	u32 cndat;
> -
> -	state = fe->demodulator_priv;
> -	c->delivery_system = SYS_ISDBS;
> -	c->symbol_rate = 28860000;
> -
> -	layers = 0;
> -	ret = reg_read(state, 0xe6, val, 5);
> -	if (ret == 0) {
> -		u8 v;
> -
> -		c->stream_id = val[0] << 8 | val[1];
> -
> -		/* high/single layer */
> -		v = (val[2] & 0x70) >> 4;
> -		c->modulation = (v == 7) ? PSK_8 : QPSK;
> -		c->fec_inner = fec_conv_sat[v];
> -		c->layer[0].fec = c->fec_inner;
> -		c->layer[0].modulation = c->modulation;
> -		c->layer[0].segment_count = val[3] & 0x3f; /* slots */
> -
> -		/* low layer */
> -		v = (val[2] & 0x07);
> -		c->layer[1].fec = fec_conv_sat[v];
> -		if (v == 0)  /* no low layer */
> -			c->layer[1].segment_count = 0;
> -		else
> -			c->layer[1].segment_count = val[4] & 0x3f; /* slots */
> -		/*
> -		 * actually, BPSK if v==1, but not defined in
> -		 * enum fe_modulation
> -		 */
> -		c->layer[1].modulation = QPSK;
> -		layers = (v > 0) ? 2 : 1;
> -	}
> -
> -	/* statistics */
> -
> -	stats = &c->strength;
> -	stats->len = 0;
> -	/* let the connected tuner set RSSI property cache */
> -	if (fe->ops.tuner_ops.get_rf_strength) {
> -		u16 dummy;
> -
> -		fe->ops.tuner_ops.get_rf_strength(fe, &dummy);
> -	}
> -
> -	stats = &c->cnr;
> -	stats->len = 1;
> -	stats->stat[0].scale = FE_SCALE_NOT_AVAILABLE;
> -	cndat = 0;
> -	ret = reg_read(state, 0xbc, val, 2);
> -	if (ret == 0)
> -		cndat = val[0] << 8 | val[1];
> -	if (cndat >= 3000) {
> -		u32 p, p4;
> -		s64 cn;
> -
> -		cndat -= 3000;  /* cndat: 4.12 fixed point float */
> -		/*
> -		 * cnr[mdB] = -1634.6 * P^5 + 14341 * P^4 - 50259 * P^3
> -		 *                 + 88977 * P^2 - 89565 * P + 58857
> -		 *  (P = sqrt(cndat) / 64)
> -		 */
> -		/* p := sqrt(cndat) << 8 = P << 14, 2.14 fixed  point float */
> -		/* cn = cnr << 3 */
> -		p = int_sqrt(cndat << 16);
> -		p4 = cndat * cndat;
> -		cn = div64_s64(-16346LL * p4 * p, 10) >> 35;
> -		cn += (14341LL * p4) >> 21;
> -		cn -= (50259LL * cndat * p) >> 23;
> -		cn += (88977LL * cndat) >> 9;
> -		cn -= (89565LL * p) >> 11;
> -		cn += 58857  << 3;
> -		stats->stat[0].svalue = cn >> 3;
> -		stats->stat[0].scale = FE_SCALE_DECIBEL;
> -	}
> -
> -	/* per-layer post viterbi BER (or PER? config dependent?) */
> -	stats = &c->post_bit_error;
> -	memset(stats, 0, sizeof(*stats));
> -	stats->len = layers;
> -	ret = reg_read(state, 0xeb, val, 10);
> -	if (ret < 0)
> -		for (i = 0; i < layers; i++)
> -			stats->stat[i].scale = FE_SCALE_NOT_AVAILABLE;
> -	else {
> -		for (i = 0; i < layers; i++) {
> -			stats->stat[i].scale = FE_SCALE_COUNTER;
> -			stats->stat[i].uvalue = val[i * 5] << 16
> -				| val[i * 5 + 1] << 8 | val[i * 5 + 2];
> -		}
> -	}
> -	stats = &c->post_bit_count;
> -	memset(stats, 0, sizeof(*stats));
> -	stats->len = layers;
> -	if (ret < 0)
> -		for (i = 0; i < layers; i++)
> -			stats->stat[i].scale = FE_SCALE_NOT_AVAILABLE;
> -	else {
> -		for (i = 0; i < layers; i++) {
> -			stats->stat[i].scale = FE_SCALE_COUNTER;
> -			stats->stat[i].uvalue =
> -				val[i * 5 + 3] << 8 | val[i * 5 + 4];
> -			stats->stat[i].uvalue *= 204 * 8;
> -		}
> -	}
> -
> -	return 0;
> -}
> -
> -
> -static const enum fe_transmit_mode tm_conv[] = {
> -	TRANSMISSION_MODE_2K,
> -	TRANSMISSION_MODE_4K,
> -	TRANSMISSION_MODE_8K,
> -	0
> -};
> -
> -static const enum fe_code_rate fec_conv_ter[] = {
> -	FEC_1_2, FEC_2_3, FEC_3_4, FEC_5_6, FEC_7_8, 0, 0, 0
> -};
> -
> -static const enum fe_modulation mod_conv[] = {
> -	DQPSK, QPSK, QAM_16, QAM_64, 0, 0, 0, 0
> -};
> -
> -static int tc90522t_get_frontend(struct dvb_frontend *fe,
> -				 struct dtv_frontend_properties *c)
> -{
> -	struct tc90522_state *state;
> -	struct dtv_fe_stats *stats;
> -	int ret, i;
> -	int layers;
> -	u8 val[15], mode;
> -	u32 cndat;
> -
> -	state = fe->demodulator_priv;
> -	c->delivery_system = SYS_ISDBT;
> -	c->bandwidth_hz = 6000000;
> -	mode = 1;
> -	ret = reg_read(state, 0xb0, val, 1);
> -	if (ret == 0) {
> -		mode = (val[0] & 0xc0) >> 2;
> -		c->transmission_mode = tm_conv[mode];
> -		c->guard_interval = (val[0] & 0x30) >> 4;
> -	}
> -
> -	ret = reg_read(state, 0xb2, val, 6);
> -	layers = 0;
> -	if (ret == 0) {
> -		u8 v;
> -
> -		c->isdbt_partial_reception = val[0] & 0x01;
> -		c->isdbt_sb_mode = (val[0] & 0xc0) == 0x40;
> -
> -		/* layer A */
> -		v = (val[2] & 0x78) >> 3;
> -		if (v == 0x0f)
> -			c->layer[0].segment_count = 0;
> -		else {
> -			layers++;
> -			c->layer[0].segment_count = v;
> -			c->layer[0].fec = fec_conv_ter[(val[1] & 0x1c) >> 2];
> -			c->layer[0].modulation = mod_conv[(val[1] & 0xe0) >> 5];
> -			v = (val[1] & 0x03) << 1 | (val[2] & 0x80) >> 7;
> -			c->layer[0].interleaving = v;
> -		}
> -
> -		/* layer B */
> -		v = (val[3] & 0x03) << 1 | (val[4] & 0xc0) >> 6;
> -		if (v == 0x0f)
> -			c->layer[1].segment_count = 0;
> -		else {
> -			layers++;
> -			c->layer[1].segment_count = v;
> -			c->layer[1].fec = fec_conv_ter[(val[3] & 0xe0) >> 5];
> -			c->layer[1].modulation = mod_conv[(val[2] & 0x07)];
> -			c->layer[1].interleaving = (val[3] & 0x1c) >> 2;
> -		}
> -
> -		/* layer C */
> -		v = (val[5] & 0x1e) >> 1;
> -		if (v == 0x0f)
> -			c->layer[2].segment_count = 0;
> -		else {
> -			layers++;
> -			c->layer[2].segment_count = v;
> -			c->layer[2].fec = fec_conv_ter[(val[4] & 0x07)];
> -			c->layer[2].modulation = mod_conv[(val[4] & 0x38) >> 3];
> -			c->layer[2].interleaving = (val[5] & 0xe0) >> 5;
> -		}
> -	}
> -
> -	/* statistics */
> -
> -	stats = &c->strength;
> -	stats->len = 0;
> -	/* let the connected tuner set RSSI property cache */
> -	if (fe->ops.tuner_ops.get_rf_strength) {
> -		u16 dummy;
> -
> -		fe->ops.tuner_ops.get_rf_strength(fe, &dummy);
> -	}
> -
> -	stats = &c->cnr;
> -	stats->len = 1;
> -	stats->stat[0].scale = FE_SCALE_NOT_AVAILABLE;
> -	cndat = 0;
> -	ret = reg_read(state, 0x8b, val, 3);
> -	if (ret == 0)
> -		cndat = val[0] << 16 | val[1] << 8 | val[2];
> -	if (cndat != 0) {
> -		u32 p, tmp;
> -		s64 cn;
> -
> -		/*
> -		 * cnr[mdB] = 0.024 P^4 - 1.6 P^3 + 39.8 P^2 + 549.1 P + 3096.5
> -		 * (P = 10log10(5505024/cndat))
> -		 */
> -		/* cn = cnr << 3 (61.3 fixed point float */
> -		/* p = 10log10(5505024/cndat) << 24  (8.24 fixed point float)*/
> -		p = intlog10(5505024) - intlog10(cndat);
> -		p *= 10;
> -
> -		cn = 24772;
> -		cn += div64_s64(43827LL * p, 10) >> 24;
> -		tmp = p >> 8;
> -		cn += div64_s64(3184LL * tmp * tmp, 10) >> 32;
> -		tmp = p >> 13;
> -		cn -= div64_s64(128LL * tmp * tmp * tmp, 10) >> 33;
> -		tmp = p >> 18;
> -		cn += div64_s64(192LL * tmp * tmp * tmp * tmp, 1000) >> 24;
> -
> -		stats->stat[0].svalue = cn >> 3;
> -		stats->stat[0].scale = FE_SCALE_DECIBEL;
> -	}
> -
> -	/* per-layer post viterbi BER (or PER? config dependent?) */
> -	stats = &c->post_bit_error;
> -	memset(stats, 0, sizeof(*stats));
> -	stats->len = layers;
> -	ret = reg_read(state, 0x9d, val, 15);
> -	if (ret < 0)
> -		for (i = 0; i < layers; i++)
> -			stats->stat[i].scale = FE_SCALE_NOT_AVAILABLE;
> -	else {
> -		for (i = 0; i < layers; i++) {
> -			stats->stat[i].scale = FE_SCALE_COUNTER;
> -			stats->stat[i].uvalue = val[i * 3] << 16
> -				| val[i * 3 + 1] << 8 | val[i * 3 + 2];
> -		}
> -	}
> -	stats = &c->post_bit_count;
> -	memset(stats, 0, sizeof(*stats));
> -	stats->len = layers;
> -	if (ret < 0)
> -		for (i = 0; i < layers; i++)
> -			stats->stat[i].scale = FE_SCALE_NOT_AVAILABLE;
> -	else {
> -		for (i = 0; i < layers; i++) {
> -			stats->stat[i].scale = FE_SCALE_COUNTER;
> -			stats->stat[i].uvalue =
> -				val[9 + i * 2] << 8 | val[9 + i * 2 + 1];
> -			stats->stat[i].uvalue *= 204 * 8;
> -		}
> -	}
> -
> -	return 0;
> -}
> -
> -static const struct reg_val reset_sat = { 0x03, 0x01 };
> -static const struct reg_val reset_ter = { 0x01, 0x40 };
> -
> -static int tc90522_set_frontend(struct dvb_frontend *fe)
> -{
> -	struct tc90522_state *state;
> -	int ret;
> -
> -	state = fe->demodulator_priv;
> -
> -	if (fe->ops.tuner_ops.set_params)
> -		ret = fe->ops.tuner_ops.set_params(fe);
> -	else
> -		ret = -ENODEV;
> -	if (ret < 0)
> -		goto failed;
> -
> -	if (fe->ops.delsys[0] == SYS_ISDBS) {
> -		ret = tc90522s_set_tsid(fe);
> -		if (ret < 0)
> -			goto failed;
> -		ret = reg_write(state, &reset_sat, 1);
> -	} else {
> -		ret = tc90522t_set_layers(fe);
> -		if (ret < 0)
> -			goto failed;
> -		ret = reg_write(state, &reset_ter, 1);
> -	}
> -	if (ret < 0)
> -		goto failed;
> -
> -	return 0;
> -
> -failed:
> -	dev_warn(&state->tuner_i2c.dev, "(%s) failed. [adap%d-fe%d]\n",
> -			__func__, fe->dvb->num, fe->id);
> -	return ret;
> -}
> -
> -static int tc90522_get_tune_settings(struct dvb_frontend *fe,
> -	struct dvb_frontend_tune_settings *settings)
> -{
> -	if (fe->ops.delsys[0] == SYS_ISDBS) {
> -		settings->min_delay_ms = 250;
> -		settings->step_size = 1000;
> -		settings->max_drift = settings->step_size * 2;
> -	} else {
> -		settings->min_delay_ms = 400;
> -		settings->step_size = 142857;
> -		settings->max_drift = settings->step_size;
> -	}
> -	return 0;
> -}
> -
> -static int tc90522_set_if_agc(struct dvb_frontend *fe, bool on)
> -{
> -	struct reg_val agc_sat[] = {
> -		{ 0x0a, 0x00 },
> -		{ 0x10, 0x30 },
> -		{ 0x11, 0x00 },
> -		{ 0x03, 0x01 },
> -	};
> -	struct reg_val agc_ter[] = {
> -		{ 0x25, 0x00 },
> -		{ 0x23, 0x4c },
> -		{ 0x01, 0x40 },
> -	};
> -	struct tc90522_state *state;
> -	struct reg_val *rv;
> -	int num;
> -
> -	state = fe->demodulator_priv;
> -	if (fe->ops.delsys[0] == SYS_ISDBS) {
> -		agc_sat[0].val = on ? 0xff : 0x00;
> -		agc_sat[1].val |= 0x80;
> -		agc_sat[1].val |= on ? 0x01 : 0x00;
> -		agc_sat[2].val |= on ? 0x40 : 0x00;
> -		rv = agc_sat;
> -		num = ARRAY_SIZE(agc_sat);
> -	} else {
> -		agc_ter[0].val = on ? 0x40 : 0x00;
> -		agc_ter[1].val |= on ? 0x00 : 0x01;
> -		rv = agc_ter;
> -		num = ARRAY_SIZE(agc_ter);
> -	}
> -	return reg_write(state, rv, num);
> -}
> -
> -static const struct reg_val sleep_sat = { 0x17, 0x01 };
> -static const struct reg_val sleep_ter = { 0x03, 0x90 };
> -
> -static int tc90522_sleep(struct dvb_frontend *fe)
> -{
> -	struct tc90522_state *state;
> -	int ret;
> -
> -	state = fe->demodulator_priv;
> -	if (fe->ops.delsys[0] == SYS_ISDBS)
> -		ret = reg_write(state, &sleep_sat, 1);
> -	else {
> -		ret = reg_write(state, &sleep_ter, 1);
> -		if (ret == 0 && fe->ops.set_lna &&
> -		    fe->dtv_property_cache.lna == LNA_AUTO) {
> -			fe->dtv_property_cache.lna = 0;
> -			ret = fe->ops.set_lna(fe);
> -			fe->dtv_property_cache.lna = LNA_AUTO;
> -		}
> -	}
> -	if (ret < 0)
> -		dev_warn(&state->tuner_i2c.dev,
> -			"(%s) failed. [adap%d-fe%d]\n",
> -			__func__, fe->dvb->num, fe->id);
> -	return ret;
> -}
> -
> -static const struct reg_val wakeup_sat = { 0x17, 0x00 };
> -static const struct reg_val wakeup_ter = { 0x03, 0x80 };
> -
> -static int tc90522_init(struct dvb_frontend *fe)
> -{
> -	struct tc90522_state *state;
> -	int ret;
> -
> -	/*
> -	 * Because the init sequence is not public,
> -	 * the parent device/driver should have init'ed the device before.
> -	 * just wake up the device here.
> -	 */
> -
> -	state = fe->demodulator_priv;
> -	if (fe->ops.delsys[0] == SYS_ISDBS)
> -		ret = reg_write(state, &wakeup_sat, 1);
> -	else {
> -		ret = reg_write(state, &wakeup_ter, 1);
> -		if (ret == 0 && fe->ops.set_lna &&
> -		    fe->dtv_property_cache.lna == LNA_AUTO) {
> -			fe->dtv_property_cache.lna = 1;
> -			ret = fe->ops.set_lna(fe);
> -			fe->dtv_property_cache.lna = LNA_AUTO;
> -		}
> -	}
> -	if (ret < 0) {
> -		dev_warn(&state->tuner_i2c.dev,
> -			"(%s) failed. [adap%d-fe%d]\n",
> -			__func__, fe->dvb->num, fe->id);
> -		return ret;
> -	}
> -
> -	/* prefer 'all-layers' to 'none' as a default */
> -	if (fe->dtv_property_cache.isdbt_layer_enabled == 0)
> -		fe->dtv_property_cache.isdbt_layer_enabled = 7;
> -	return tc90522_set_if_agc(fe, true);
> -}
> -
> -
> -/*
> - * tuner I2C adapter functions
> - */
> -
> -static int
> -tc90522_master_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs, int num)
> -{
> -	struct tc90522_state *state;
> -	struct i2c_msg *new_msgs;
> -	int i, j;
> -	int ret, rd_num;
> -	u8 wbuf[256];
> -	u8 *p, *bufend;
> -
> -	if (num <= 0)
> -		return -EINVAL;
> -
> -	rd_num = 0;
> -	for (i = 0; i < num; i++)
> -		if (msgs[i].flags & I2C_M_RD)
> -			rd_num++;
> -	new_msgs = kmalloc(sizeof(*new_msgs) * (num + rd_num), GFP_KERNEL);
> -	if (!new_msgs)
> -		return -ENOMEM;
> -
> -	state = i2c_get_adapdata(adap);
> -	p = wbuf;
> -	bufend = wbuf + sizeof(wbuf);
> -	for (i = 0, j = 0; i < num; i++, j++) {
> -		new_msgs[j].addr = state->i2c_client->addr;
> -		new_msgs[j].flags = msgs[i].flags;
> -
> -		if (msgs[i].flags & I2C_M_RD) {
> -			new_msgs[j].flags &= ~I2C_M_RD;
> -			if (p + 2 > bufend)
> -				break;
> -			p[0] = TC90522_I2C_THRU_REG;
> -			p[1] = msgs[i].addr << 1 | 0x01;
> -			new_msgs[j].buf = p;
> -			new_msgs[j].len = 2;
> -			p += 2;
> -			j++;
> -			new_msgs[j].addr = state->i2c_client->addr;
> -			new_msgs[j].flags = msgs[i].flags;
> -			new_msgs[j].buf = msgs[i].buf;
> -			new_msgs[j].len = msgs[i].len;
> -			continue;
> -		}
> -
> -		if (p + msgs[i].len + 2 > bufend)
> -			break;
> -		p[0] = TC90522_I2C_THRU_REG;
> -		p[1] = msgs[i].addr << 1;
> -		memcpy(p + 2, msgs[i].buf, msgs[i].len);
> -		new_msgs[j].buf = p;
> -		new_msgs[j].len = msgs[i].len + 2;
> -		p += new_msgs[j].len;
> -	}
> -
> -	if (i < num)
> -		ret = -ENOMEM;
> -	else
> -		ret = i2c_transfer(state->i2c_client->adapter, new_msgs, j);
> -	if (ret >= 0 && ret < j)
> -		ret = -EIO;
> -	kfree(new_msgs);
> -	return (ret == j) ? num : ret;
> -}
> -
> -static u32 tc90522_functionality(struct i2c_adapter *adap)
> -{
> -	return I2C_FUNC_I2C;
> -}
> -
> -static const struct i2c_algorithm tc90522_tuner_i2c_algo = {
> -	.master_xfer   = &tc90522_master_xfer,
> -	.functionality = &tc90522_functionality,
> -};
> -
> -
> -/*
> - * I2C driver functions
> - */
> -
> -static const struct dvb_frontend_ops tc90522_ops_sat = {
> -	.delsys = { SYS_ISDBS },
> -	.info = {
> -		.name = "Toshiba TC90522 ISDB-S module",
> -		.frequency_min =  950000,
> -		.frequency_max = 2150000,
> -		.caps = FE_CAN_INVERSION_AUTO | FE_CAN_FEC_AUTO |
> -			FE_CAN_QAM_AUTO | FE_CAN_TRANSMISSION_MODE_AUTO |
> -			FE_CAN_GUARD_INTERVAL_AUTO | FE_CAN_HIERARCHY_AUTO,
> -	},
> -
> -	.init = tc90522_init,
> -	.sleep = tc90522_sleep,
> -	.set_frontend = tc90522_set_frontend,
> -	.get_tune_settings = tc90522_get_tune_settings,
> -
> -	.get_frontend = tc90522s_get_frontend,
> -	.read_status = tc90522s_read_status,
> -};
> -
> -static const struct dvb_frontend_ops tc90522_ops_ter = {
> -	.delsys = { SYS_ISDBT },
> -	.info = {
> -		.name = "Toshiba TC90522 ISDB-T module",
> -		.frequency_min = 470000000,
> -		.frequency_max = 770000000,
> -		.frequency_stepsize = 142857,
> -		.caps = FE_CAN_INVERSION_AUTO |
> -			FE_CAN_FEC_1_2  | FE_CAN_FEC_2_3 | FE_CAN_FEC_3_4 |
> -			FE_CAN_FEC_5_6  | FE_CAN_FEC_7_8 | FE_CAN_FEC_AUTO |
> -			FE_CAN_QPSK     | FE_CAN_QAM_16 | FE_CAN_QAM_64 |
> -			FE_CAN_QAM_AUTO | FE_CAN_TRANSMISSION_MODE_AUTO |
> -			FE_CAN_GUARD_INTERVAL_AUTO | FE_CAN_RECOVER |
> -			FE_CAN_HIERARCHY_AUTO,
> -	},
> -
> -	.init = tc90522_init,
> -	.sleep = tc90522_sleep,
> -	.set_frontend = tc90522_set_frontend,
> -	.get_tune_settings = tc90522_get_tune_settings,
> -
> -	.get_frontend = tc90522t_get_frontend,
> -	.read_status = tc90522t_read_status,
> -};
> -
> -
> -static int tc90522_probe(struct i2c_client *client,
> -			 const struct i2c_device_id *id)
> -{
> -	struct tc90522_state *state;
> -	struct tc90522_config *cfg;
> -	const struct dvb_frontend_ops *ops;
> -	struct i2c_adapter *adap;
> -	int ret;
> -
> -	state = kzalloc(sizeof(*state), GFP_KERNEL);
> -	if (!state)
> -		return -ENOMEM;
> -	state->i2c_client = client;
> -
> -	cfg = client->dev.platform_data;
> -	memcpy(&state->cfg, cfg, sizeof(state->cfg));
> -	cfg->fe = state->cfg.fe = &state->fe;
> -	ops =  id->driver_data == 0 ? &tc90522_ops_sat : &tc90522_ops_ter;
> -	memcpy(&state->fe.ops, ops, sizeof(*ops));
> -	state->fe.demodulator_priv = state;
> -
> -	adap = &state->tuner_i2c;
> -	adap->owner = THIS_MODULE;
> -	adap->algo = &tc90522_tuner_i2c_algo;
> -	adap->dev.parent = &client->dev;
> -	strlcpy(adap->name, "tc90522_sub", sizeof(adap->name));
> -	i2c_set_adapdata(adap, state);
> -	ret = i2c_add_adapter(adap);
> -	if (ret < 0)
> -		goto err;
> -	cfg->tuner_i2c = state->cfg.tuner_i2c = adap;
> -
> -	i2c_set_clientdata(client, &state->cfg);
> -	dev_info(&client->dev, "Toshiba TC90522 attached.\n");
> -	return 0;
> -
> -err:
> -	kfree(state);
> -	return ret;
> -}
> -
> -static int tc90522_remove(struct i2c_client *client)
> -{
> -	struct tc90522_state *state;
> -
> -	state = cfg_to_state(i2c_get_clientdata(client));
> -	i2c_del_adapter(&state->tuner_i2c);
> -	kfree(state);
> -	return 0;
> -}
> -
> -
> -static const struct i2c_device_id tc90522_id[] = {
> -	{ TC90522_I2C_DEV_SAT, 0 },
> -	{ TC90522_I2C_DEV_TER, 1 },
> -	{}
> -};
> -MODULE_DEVICE_TABLE(i2c, tc90522_id);
> -
> -static struct i2c_driver tc90522_driver = {
> -	.driver = {
> -		.name	= "tc90522",
> -	},
> -	.probe		= tc90522_probe,
> -	.remove		= tc90522_remove,
> -	.id_table	= tc90522_id,
> -};
> -
> -module_i2c_driver(tc90522_driver);
> -
> -MODULE_DESCRIPTION("Toshiba TC90522 frontend");
> -MODULE_AUTHOR("Akihiro TSUKADA");
> -MODULE_LICENSE("GPL");
> diff --git a/drivers/media/dvb-frontends/tc90522.h b/drivers/media/dvb-frontends/tc90522.h
> deleted file mode 100644
> index b1cbddf..0000000
> --- a/drivers/media/dvb-frontends/tc90522.h
> +++ /dev/null
> @@ -1,42 +0,0 @@
> -/*
> - * Toshiba TC90522 Demodulator
> - *
> - * Copyright (C) 2014 Akihiro Tsukada <tskd08@gmail.com>
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation version 2.
> - *
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - */
> -
> -/*
> - * The demod has 4 input (2xISDB-T and 2xISDB-S),
> - * and provides independent sub modules for each input.
> - * As the sub modules work in parallel and have the separate i2c addr's,
> - * this driver treats each sub module as one demod device.
> - */
> -
> -#ifndef TC90522_H
> -#define TC90522_H
> -
> -#include <linux/i2c.h>
> -#include "dvb_frontend.h"
> -
> -/* I2C device types */
> -#define TC90522_I2C_DEV_SAT "tc90522sat"
> -#define TC90522_I2C_DEV_TER "tc90522ter"
> -
> -struct tc90522_config {
> -	/* [OUT] frontend returned by driver */
> -	struct dvb_frontend *fe;
> -
> -	/* [OUT] tuner I2C adapter returned by driver */
> -	struct i2c_adapter *tuner_i2c;
> -};
> -
> -#endif /* TC90522_H */
> diff --git a/drivers/media/pci/pt3/Kconfig b/drivers/media/pci/pt3/Kconfig
> deleted file mode 100644
> index 16c208a..0000000
> --- a/drivers/media/pci/pt3/Kconfig
> +++ /dev/null
> @@ -1,10 +0,0 @@
> -config DVB_PT3
> -	tristate "Earthsoft PT3 cards"
> -	depends on DVB_CORE && PCI && I2C
> -	select DVB_TC90522 if MEDIA_SUBDRV_AUTOSELECT
> -	select MEDIA_TUNER_QM1D1C0042 if MEDIA_SUBDRV_AUTOSELECT
> -	select MEDIA_TUNER_MXL301RF if MEDIA_SUBDRV_AUTOSELECT
> -	help
> -	  Support for Earthsoft PT3 PCIe cards.
> -
> -	  Say Y or M if you own such a device and want to use it.
> diff --git a/drivers/media/pci/pt3/Makefile b/drivers/media/pci/pt3/Makefile
> deleted file mode 100644
> index 396f146..0000000
> --- a/drivers/media/pci/pt3/Makefile
> +++ /dev/null
> @@ -1,8 +0,0 @@
> -
> -earth-pt3-objs += pt3.o pt3_i2c.o pt3_dma.o
> -
> -obj-$(CONFIG_DVB_PT3) += earth-pt3.o
> -
> -ccflags-y += -Idrivers/media/dvb-core
> -ccflags-y += -Idrivers/media/dvb-frontends
> -ccflags-y += -Idrivers/media/tuners
> diff --git a/drivers/media/pci/pt3/pt3.c b/drivers/media/pci/pt3/pt3.c
> deleted file mode 100644
> index eff5e9f..0000000
> --- a/drivers/media/pci/pt3/pt3.c
> +++ /dev/null
> @@ -1,874 +0,0 @@
> -/*
> - * Earthsoft PT3 driver
> - *
> - * Copyright (C) 2014 Akihiro Tsukada <tskd08@gmail.com>
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation version 2.
> - *
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - */
> -
> -#include <linux/freezer.h>
> -#include <linux/kernel.h>
> -#include <linux/kthread.h>
> -#include <linux/mutex.h>
> -#include <linux/module.h>
> -#include <linux/pci.h>
> -#include <linux/string.h>
> -
> -#include "dmxdev.h"
> -#include "dvbdev.h"
> -#include "dvb_demux.h"
> -#include "dvb_frontend.h"
> -
> -#include "pt3.h"
> -
> -DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
> -
> -static bool one_adapter;
> -module_param(one_adapter, bool, 0444);
> -MODULE_PARM_DESC(one_adapter, "Place FE's together under one adapter.");
> -
> -static int num_bufs = 4;
> -module_param(num_bufs, int, 0444);
> -MODULE_PARM_DESC(num_bufs, "Number of DMA buffer (188KiB) per FE.");
> -
> -
> -static const struct i2c_algorithm pt3_i2c_algo = {
> -	.master_xfer   = &pt3_i2c_master_xfer,
> -	.functionality = &pt3_i2c_functionality,
> -};
> -
> -static const struct pt3_adap_config adap_conf[PT3_NUM_FE] = {
> -	{
> -		.demod_info = {
> -			I2C_BOARD_INFO(TC90522_I2C_DEV_SAT, 0x11),
> -		},
> -		.tuner_info = {
> -			I2C_BOARD_INFO("qm1d1c0042", 0x63),
> -		},
> -		.tuner_cfg.qm1d1c0042 = {
> -			.lpf = 1,
> -		},
> -		.init_freq = 1049480 - 300,
> -	},
> -	{
> -		.demod_info = {
> -			I2C_BOARD_INFO(TC90522_I2C_DEV_TER, 0x10),
> -		},
> -		.tuner_info = {
> -			I2C_BOARD_INFO("mxl301rf", 0x62),
> -		},
> -		.init_freq = 515142857,
> -	},
> -	{
> -		.demod_info = {
> -			I2C_BOARD_INFO(TC90522_I2C_DEV_SAT, 0x13),
> -		},
> -		.tuner_info = {
> -			I2C_BOARD_INFO("qm1d1c0042", 0x60),
> -		},
> -		.tuner_cfg.qm1d1c0042 = {
> -			.lpf = 1,
> -		},
> -		.init_freq = 1049480 + 300,
> -	},
> -	{
> -		.demod_info = {
> -			I2C_BOARD_INFO(TC90522_I2C_DEV_TER, 0x12),
> -		},
> -		.tuner_info = {
> -			I2C_BOARD_INFO("mxl301rf", 0x61),
> -		},
> -		.init_freq = 521142857,
> -	},
> -};
> -
> -
> -struct reg_val {
> -	u8 reg;
> -	u8 val;
> -};
> -
> -static int
> -pt3_demod_write(struct pt3_adapter *adap, const struct reg_val *data, int num)
> -{
> -	struct i2c_msg msg;
> -	int i, ret;
> -
> -	ret = 0;
> -	msg.addr = adap->i2c_demod->addr;
> -	msg.flags = 0;
> -	msg.len = 2;
> -	for (i = 0; i < num; i++) {
> -		msg.buf = (u8 *)&data[i];
> -		ret = i2c_transfer(adap->i2c_demod->adapter, &msg, 1);
> -		if (ret == 0)
> -			ret = -EREMOTE;
> -		if (ret < 0)
> -			return ret;
> -	}
> -	return 0;
> -}
> -
> -static inline void pt3_lnb_ctrl(struct pt3_board *pt3, bool on)
> -{
> -	iowrite32((on ? 0x0f : 0x0c), pt3->regs[0] + REG_SYSTEM_W);
> -}
> -
> -static inline struct pt3_adapter *pt3_find_adapter(struct dvb_frontend *fe)
> -{
> -	struct pt3_board *pt3;
> -	int i;
> -
> -	if (one_adapter) {
> -		pt3 = fe->dvb->priv;
> -		for (i = 0; i < PT3_NUM_FE; i++)
> -			if (pt3->adaps[i]->fe == fe)
> -				return pt3->adaps[i];
> -	}
> -	return container_of(fe->dvb, struct pt3_adapter, dvb_adap);
> -}
> -
> -/*
> - * all 4 tuners in PT3 are packaged in a can module (Sharp VA4M6JC2103).
> - * it seems that they share the power lines and Amp power line and
> - * adaps[3] controls those powers.
> - */
> -static int
> -pt3_set_tuner_power(struct pt3_board *pt3, bool tuner_on, bool amp_on)
> -{
> -	struct reg_val rv = { 0x1e, 0x99 };
> -
> -	if (tuner_on)
> -		rv.val |= 0x40;
> -	if (amp_on)
> -		rv.val |= 0x04;
> -	return pt3_demod_write(pt3->adaps[PT3_NUM_FE - 1], &rv, 1);
> -}
> -
> -static int pt3_set_lna(struct dvb_frontend *fe)
> -{
> -	struct pt3_adapter *adap;
> -	struct pt3_board *pt3;
> -	u32 val;
> -	int ret;
> -
> -	/* LNA is shared btw. 2 TERR-tuners */
> -
> -	adap = pt3_find_adapter(fe);
> -	val = fe->dtv_property_cache.lna;
> -	if (val == LNA_AUTO || val == adap->cur_lna)
> -		return 0;
> -
> -	pt3 = adap->dvb_adap.priv;
> -	if (mutex_lock_interruptible(&pt3->lock))
> -		return -ERESTARTSYS;
> -	if (val)
> -		pt3->lna_on_cnt++;
> -	else
> -		pt3->lna_on_cnt--;
> -
> -	if (val && pt3->lna_on_cnt <= 1) {
> -		pt3->lna_on_cnt = 1;
> -		ret = pt3_set_tuner_power(pt3, true, true);
> -	} else if (!val && pt3->lna_on_cnt <= 0) {
> -		pt3->lna_on_cnt = 0;
> -		ret = pt3_set_tuner_power(pt3, true, false);
> -	} else
> -		ret = 0;
> -	mutex_unlock(&pt3->lock);
> -	adap->cur_lna = (val != 0);
> -	return ret;
> -}
> -
> -static int pt3_set_voltage(struct dvb_frontend *fe, enum fe_sec_voltage volt)
> -{
> -	struct pt3_adapter *adap;
> -	struct pt3_board *pt3;
> -	bool on;
> -
> -	/* LNB power is shared btw. 2 SAT-tuners */
> -
> -	adap = pt3_find_adapter(fe);
> -	on = (volt != SEC_VOLTAGE_OFF);
> -	if (on == adap->cur_lnb)
> -		return 0;
> -	adap->cur_lnb = on;
> -	pt3 = adap->dvb_adap.priv;
> -	if (mutex_lock_interruptible(&pt3->lock))
> -		return -ERESTARTSYS;
> -	if (on)
> -		pt3->lnb_on_cnt++;
> -	else
> -		pt3->lnb_on_cnt--;
> -
> -	if (on && pt3->lnb_on_cnt <= 1) {
> -		pt3->lnb_on_cnt = 1;
> -		pt3_lnb_ctrl(pt3, true);
> -	} else if (!on && pt3->lnb_on_cnt <= 0) {
> -		pt3->lnb_on_cnt = 0;
> -		pt3_lnb_ctrl(pt3, false);
> -	}
> -	mutex_unlock(&pt3->lock);
> -	return 0;
> -}
> -
> -/* register values used in pt3_fe_init() */
> -
> -static const struct reg_val init0_sat[] = {
> -	{ 0x03, 0x01 },
> -	{ 0x1e, 0x10 },
> -};
> -static const struct reg_val init0_ter[] = {
> -	{ 0x01, 0x40 },
> -	{ 0x1c, 0x10 },
> -};
> -static const struct reg_val cfg_sat[] = {
> -	{ 0x1c, 0x15 },
> -	{ 0x1f, 0x04 },
> -};
> -static const struct reg_val cfg_ter[] = {
> -	{ 0x1d, 0x01 },
> -};
> -
> -/*
> - * pt3_fe_init: initialize demod sub modules and ISDB-T tuners all at once.
> - *
> - * As for demod IC (TC90522) and ISDB-T tuners (MxL301RF),
> - * the i2c sequences for init'ing them are not public and hidden in a ROM,
> - * and include the board specific configurations as well.
> - * They are stored in a lump and cannot be taken out / accessed separately,
> - * thus cannot be moved to the FE/tuner driver.
> - */
> -static int pt3_fe_init(struct pt3_board *pt3)
> -{
> -	int i, ret;
> -	struct dvb_frontend *fe;
> -
> -	pt3_i2c_reset(pt3);
> -	ret = pt3_init_all_demods(pt3);
> -	if (ret < 0) {
> -		dev_warn(&pt3->pdev->dev, "Failed to init demod chips\n");
> -		return ret;
> -	}
> -
> -	/* additional config? */
> -	for (i = 0; i < PT3_NUM_FE; i++) {
> -		fe = pt3->adaps[i]->fe;
> -
> -		if (fe->ops.delsys[0] == SYS_ISDBS)
> -			ret = pt3_demod_write(pt3->adaps[i],
> -					      init0_sat, ARRAY_SIZE(init0_sat));
> -		else
> -			ret = pt3_demod_write(pt3->adaps[i],
> -					      init0_ter, ARRAY_SIZE(init0_ter));
> -		if (ret < 0) {
> -			dev_warn(&pt3->pdev->dev,
> -				 "demod[%d] failed in init sequence0\n", i);
> -			return ret;
> -		}
> -		ret = fe->ops.init(fe);
> -		if (ret < 0)
> -			return ret;
> -	}
> -
> -	usleep_range(2000, 4000);
> -	ret = pt3_set_tuner_power(pt3, true, false);
> -	if (ret < 0) {
> -		dev_warn(&pt3->pdev->dev, "Failed to control tuner module\n");
> -		return ret;
> -	}
> -
> -	/* output pin configuration */
> -	for (i = 0; i < PT3_NUM_FE; i++) {
> -		fe = pt3->adaps[i]->fe;
> -		if (fe->ops.delsys[0] == SYS_ISDBS)
> -			ret = pt3_demod_write(pt3->adaps[i],
> -						cfg_sat, ARRAY_SIZE(cfg_sat));
> -		else
> -			ret = pt3_demod_write(pt3->adaps[i],
> -						cfg_ter, ARRAY_SIZE(cfg_ter));
> -		if (ret < 0) {
> -			dev_warn(&pt3->pdev->dev,
> -				 "demod[%d] failed in init sequence1\n", i);
> -			return ret;
> -		}
> -	}
> -	usleep_range(4000, 6000);
> -
> -	for (i = 0; i < PT3_NUM_FE; i++) {
> -		fe = pt3->adaps[i]->fe;
> -		if (fe->ops.delsys[0] != SYS_ISDBS)
> -			continue;
> -		/* init and wake-up ISDB-S tuners */
> -		ret = fe->ops.tuner_ops.init(fe);
> -		if (ret < 0) {
> -			dev_warn(&pt3->pdev->dev,
> -				 "Failed to init SAT-tuner[%d]\n", i);
> -			return ret;
> -		}
> -	}
> -	ret = pt3_init_all_mxl301rf(pt3);
> -	if (ret < 0) {
> -		dev_warn(&pt3->pdev->dev, "Failed to init TERR-tuners\n");
> -		return ret;
> -	}
> -
> -	ret = pt3_set_tuner_power(pt3, true, true);
> -	if (ret < 0) {
> -		dev_warn(&pt3->pdev->dev, "Failed to control tuner module\n");
> -		return ret;
> -	}
> -
> -	/* Wake up all tuners and make an initial tuning,
> -	 * in order to avoid interference among the tuners in the module,
> -	 * according to the doc from the manufacturer.
> -	 */
> -	for (i = 0; i < PT3_NUM_FE; i++) {
> -		fe = pt3->adaps[i]->fe;
> -		ret = 0;
> -		if (fe->ops.delsys[0] == SYS_ISDBT)
> -			ret = fe->ops.tuner_ops.init(fe);
> -		/* set only when called from pt3_probe(), not resume() */
> -		if (ret == 0 && fe->dtv_property_cache.frequency == 0) {
> -			fe->dtv_property_cache.frequency =
> -						adap_conf[i].init_freq;
> -			ret = fe->ops.tuner_ops.set_params(fe);
> -		}
> -		if (ret < 0) {
> -			dev_warn(&pt3->pdev->dev,
> -				 "Failed in initial tuning of tuner[%d]\n", i);
> -			return ret;
> -		}
> -	}
> -
> -	/* and sleep again, waiting to be opened by users. */
> -	for (i = 0; i < PT3_NUM_FE; i++) {
> -		fe = pt3->adaps[i]->fe;
> -		if (fe->ops.tuner_ops.sleep)
> -			ret = fe->ops.tuner_ops.sleep(fe);
> -		if (ret < 0)
> -			break;
> -		if (fe->ops.sleep)
> -			ret = fe->ops.sleep(fe);
> -		if (ret < 0)
> -			break;
> -		if (fe->ops.delsys[0] == SYS_ISDBS)
> -			fe->ops.set_voltage = &pt3_set_voltage;
> -		else
> -			fe->ops.set_lna = &pt3_set_lna;
> -	}
> -	if (i < PT3_NUM_FE) {
> -		dev_warn(&pt3->pdev->dev, "FE[%d] failed to standby\n", i);
> -		return ret;
> -	}
> -	return 0;
> -}
> -
> -
> -static int pt3_attach_fe(struct pt3_board *pt3, int i)
> -{
> -	struct i2c_board_info info;
> -	struct tc90522_config cfg;
> -	struct i2c_client *cl;
> -	struct dvb_adapter *dvb_adap;
> -	int ret;
> -
> -	info = adap_conf[i].demod_info;
> -	cfg = adap_conf[i].demod_cfg;
> -	cfg.tuner_i2c = NULL;
> -	info.platform_data = &cfg;
> -
> -	ret = -ENODEV;
> -	request_module("tc90522");
> -	cl = i2c_new_device(&pt3->i2c_adap, &info);
> -	if (!cl || !cl->dev.driver)
> -		return -ENODEV;
> -	pt3->adaps[i]->i2c_demod = cl;
> -	if (!try_module_get(cl->dev.driver->owner))
> -		goto err_demod_i2c_unregister_device;
> -
> -	if (!strncmp(cl->name, TC90522_I2C_DEV_SAT,
> -		     strlen(TC90522_I2C_DEV_SAT))) {
> -		struct qm1d1c0042_config tcfg;
> -
> -		tcfg = adap_conf[i].tuner_cfg.qm1d1c0042;
> -		tcfg.fe = cfg.fe;
> -		info = adap_conf[i].tuner_info;
> -		info.platform_data = &tcfg;
> -		request_module("qm1d1c0042");
> -		cl = i2c_new_device(cfg.tuner_i2c, &info);
> -	} else {
> -		struct mxl301rf_config tcfg;
> -
> -		tcfg = adap_conf[i].tuner_cfg.mxl301rf;
> -		tcfg.fe = cfg.fe;
> -		info = adap_conf[i].tuner_info;
> -		info.platform_data = &tcfg;
> -		request_module("mxl301rf");
> -		cl = i2c_new_device(cfg.tuner_i2c, &info);
> -	}
> -	if (!cl || !cl->dev.driver)
> -		goto err_demod_module_put;
> -	pt3->adaps[i]->i2c_tuner = cl;
> -	if (!try_module_get(cl->dev.driver->owner))
> -		goto err_tuner_i2c_unregister_device;
> -
> -	dvb_adap = &pt3->adaps[one_adapter ? 0 : i]->dvb_adap;
> -	ret = dvb_register_frontend(dvb_adap, cfg.fe);
> -	if (ret < 0)
> -		goto err_tuner_module_put;
> -	pt3->adaps[i]->fe = cfg.fe;
> -	return 0;
> -
> -err_tuner_module_put:
> -	module_put(pt3->adaps[i]->i2c_tuner->dev.driver->owner);
> -err_tuner_i2c_unregister_device:
> -	i2c_unregister_device(pt3->adaps[i]->i2c_tuner);
> -err_demod_module_put:
> -	module_put(pt3->adaps[i]->i2c_demod->dev.driver->owner);
> -err_demod_i2c_unregister_device:
> -	i2c_unregister_device(pt3->adaps[i]->i2c_demod);
> -
> -	return ret;
> -}
> -
> -
> -static int pt3_fetch_thread(void *data)
> -{
> -	struct pt3_adapter *adap = data;
> -	ktime_t delay;
> -	bool was_frozen;
> -
> -#define PT3_INITIAL_BUF_DROPS 4
> -#define PT3_FETCH_DELAY 10
> -#define PT3_FETCH_DELAY_DELTA 2
> -
> -	pt3_init_dmabuf(adap);
> -	adap->num_discard = PT3_INITIAL_BUF_DROPS;
> -
> -	dev_dbg(adap->dvb_adap.device, "PT3: [%s] started\n",
> -		adap->thread->comm);
> -	set_freezable();
> -	while (!kthread_freezable_should_stop(&was_frozen)) {
> -		if (was_frozen)
> -			adap->num_discard = PT3_INITIAL_BUF_DROPS;
> -
> -		pt3_proc_dma(adap);
> -
> -		delay = ktime_set(0, PT3_FETCH_DELAY * NSEC_PER_MSEC);
> -		set_current_state(TASK_UNINTERRUPTIBLE);
> -		freezable_schedule_hrtimeout_range(&delay,
> -					PT3_FETCH_DELAY_DELTA * NSEC_PER_MSEC,
> -					HRTIMER_MODE_REL);
> -	}
> -	dev_dbg(adap->dvb_adap.device, "PT3: [%s] exited\n",
> -		adap->thread->comm);
> -	adap->thread = NULL;
> -	return 0;
> -}
> -
> -static int pt3_start_streaming(struct pt3_adapter *adap)
> -{
> -	struct task_struct *thread;
> -
> -	/* start fetching thread */
> -	thread = kthread_run(pt3_fetch_thread, adap, "pt3-ad%i-dmx%i",
> -				adap->dvb_adap.num, adap->dmxdev.dvbdev->id);
> -	if (IS_ERR(thread)) {
> -		int ret = PTR_ERR(thread);
> -
> -		dev_warn(adap->dvb_adap.device,
> -			 "PT3 (adap:%d, dmx:%d): failed to start kthread\n",
> -			 adap->dvb_adap.num, adap->dmxdev.dvbdev->id);
> -		return ret;
> -	}
> -	adap->thread = thread;
> -
> -	return pt3_start_dma(adap);
> -}
> -
> -static int pt3_stop_streaming(struct pt3_adapter *adap)
> -{
> -	int ret;
> -
> -	ret = pt3_stop_dma(adap);
> -	if (ret)
> -		dev_warn(adap->dvb_adap.device,
> -			 "PT3: failed to stop streaming of adap:%d/FE:%d\n",
> -			 adap->dvb_adap.num, adap->fe->id);
> -
> -	/* kill the fetching thread */
> -	ret = kthread_stop(adap->thread);
> -	return ret;
> -}
> -
> -static int pt3_start_feed(struct dvb_demux_feed *feed)
> -{
> -	struct pt3_adapter *adap;
> -
> -	if (signal_pending(current))
> -		return -EINTR;
> -
> -	adap = container_of(feed->demux, struct pt3_adapter, demux);
> -	adap->num_feeds++;
> -	if (adap->thread)
> -		return 0;
> -	if (adap->num_feeds != 1) {
> -		dev_warn(adap->dvb_adap.device,
> -			 "%s: unmatched start/stop_feed in adap:%i/dmx:%i\n",
> -			 __func__, adap->dvb_adap.num, adap->dmxdev.dvbdev->id);
> -		adap->num_feeds = 1;
> -	}
> -
> -	return pt3_start_streaming(adap);
> -
> -}
> -
> -static int pt3_stop_feed(struct dvb_demux_feed *feed)
> -{
> -	struct pt3_adapter *adap;
> -
> -	adap = container_of(feed->demux, struct pt3_adapter, demux);
> -
> -	adap->num_feeds--;
> -	if (adap->num_feeds > 0 || !adap->thread)
> -		return 0;
> -	adap->num_feeds = 0;
> -
> -	return pt3_stop_streaming(adap);
> -}
> -
> -
> -static int pt3_alloc_adapter(struct pt3_board *pt3, int index)
> -{
> -	int ret;
> -	struct pt3_adapter *adap;
> -	struct dvb_adapter *da;
> -
> -	adap = kzalloc(sizeof(*adap), GFP_KERNEL);
> -	if (!adap)
> -		return -ENOMEM;
> -
> -	pt3->adaps[index] = adap;
> -	adap->adap_idx = index;
> -
> -	if (index == 0 || !one_adapter) {
> -		ret = dvb_register_adapter(&adap->dvb_adap, "PT3 DVB",
> -				THIS_MODULE, &pt3->pdev->dev, adapter_nr);
> -		if (ret < 0) {
> -			dev_err(&pt3->pdev->dev,
> -				"failed to register adapter dev\n");
> -			goto err_mem;
> -		}
> -		da = &adap->dvb_adap;
> -	} else
> -		da = &pt3->adaps[0]->dvb_adap;
> -
> -	adap->dvb_adap.priv = pt3;
> -	adap->demux.dmx.capabilities = DMX_TS_FILTERING | DMX_SECTION_FILTERING;
> -	adap->demux.priv = adap;
> -	adap->demux.feednum = 256;
> -	adap->demux.filternum = 256;
> -	adap->demux.start_feed = pt3_start_feed;
> -	adap->demux.stop_feed = pt3_stop_feed;
> -	ret = dvb_dmx_init(&adap->demux);
> -	if (ret < 0) {
> -		dev_err(&pt3->pdev->dev, "failed to init dmx dev\n");
> -		goto err_adap;
> -	}
> -
> -	adap->dmxdev.filternum = 256;
> -	adap->dmxdev.demux = &adap->demux.dmx;
> -	ret = dvb_dmxdev_init(&adap->dmxdev, da);
> -	if (ret < 0) {
> -		dev_err(&pt3->pdev->dev, "failed to init dmxdev\n");
> -		goto err_demux;
> -	}
> -
> -	ret = pt3_alloc_dmabuf(adap);
> -	if (ret) {
> -		dev_err(&pt3->pdev->dev, "failed to alloc DMA buffers\n");
> -		goto err_dmabuf;
> -	}
> -
> -	return 0;
> -
> -err_dmabuf:
> -	pt3_free_dmabuf(adap);
> -	dvb_dmxdev_release(&adap->dmxdev);
> -err_demux:
> -	dvb_dmx_release(&adap->demux);
> -err_adap:
> -	if (index == 0 || !one_adapter)
> -		dvb_unregister_adapter(da);
> -err_mem:
> -	kfree(adap);
> -	pt3->adaps[index] = NULL;
> -	return ret;
> -}
> -
> -static void pt3_cleanup_adapter(struct pt3_board *pt3, int index)
> -{
> -	struct pt3_adapter *adap;
> -	struct dmx_demux *dmx;
> -
> -	adap = pt3->adaps[index];
> -	if (adap == NULL)
> -		return;
> -
> -	/* stop demux kthread */
> -	if (adap->thread)
> -		pt3_stop_streaming(adap);
> -
> -	dmx = &adap->demux.dmx;
> -	dmx->close(dmx);
> -	if (adap->fe) {
> -		adap->fe->callback = NULL;
> -		if (adap->fe->frontend_priv)
> -			dvb_unregister_frontend(adap->fe);
> -		if (adap->i2c_tuner) {
> -			module_put(adap->i2c_tuner->dev.driver->owner);
> -			i2c_unregister_device(adap->i2c_tuner);
> -		}
> -		if (adap->i2c_demod) {
> -			module_put(adap->i2c_demod->dev.driver->owner);
> -			i2c_unregister_device(adap->i2c_demod);
> -		}
> -	}
> -	pt3_free_dmabuf(adap);
> -	dvb_dmxdev_release(&adap->dmxdev);
> -	dvb_dmx_release(&adap->demux);
> -	if (index == 0 || !one_adapter)
> -		dvb_unregister_adapter(&adap->dvb_adap);
> -	kfree(adap);
> -	pt3->adaps[index] = NULL;
> -}
> -
> -#ifdef CONFIG_PM_SLEEP
> -
> -static int pt3_suspend(struct device *dev)
> -{
> -	struct pci_dev *pdev = to_pci_dev(dev);
> -	struct pt3_board *pt3 = pci_get_drvdata(pdev);
> -	int i;
> -	struct pt3_adapter *adap;
> -
> -	for (i = 0; i < PT3_NUM_FE; i++) {
> -		adap = pt3->adaps[i];
> -		if (adap->num_feeds > 0)
> -			pt3_stop_dma(adap);
> -		dvb_frontend_suspend(adap->fe);
> -		pt3_free_dmabuf(adap);
> -	}
> -
> -	pt3_lnb_ctrl(pt3, false);
> -	pt3_set_tuner_power(pt3, false, false);
> -	return 0;
> -}
> -
> -static int pt3_resume(struct device *dev)
> -{
> -	struct pci_dev *pdev = to_pci_dev(dev);
> -	struct pt3_board *pt3 = pci_get_drvdata(pdev);
> -	int i, ret;
> -	struct pt3_adapter *adap;
> -
> -	ret = pt3_fe_init(pt3);
> -	if (ret)
> -		return ret;
> -
> -	if (pt3->lna_on_cnt > 0)
> -		pt3_set_tuner_power(pt3, true, true);
> -	if (pt3->lnb_on_cnt > 0)
> -		pt3_lnb_ctrl(pt3, true);
> -
> -	for (i = 0; i < PT3_NUM_FE; i++) {
> -		adap = pt3->adaps[i];
> -		dvb_frontend_resume(adap->fe);
> -		ret = pt3_alloc_dmabuf(adap);
> -		if (ret) {
> -			dev_err(&pt3->pdev->dev, "failed to alloc DMA bufs\n");
> -			continue;
> -		}
> -		if (adap->num_feeds > 0)
> -			pt3_start_dma(adap);
> -	}
> -
> -	return 0;
> -}
> -
> -#endif /* CONFIG_PM_SLEEP */
> -
> -
> -static void pt3_remove(struct pci_dev *pdev)
> -{
> -	struct pt3_board *pt3;
> -	int i;
> -
> -	pt3 = pci_get_drvdata(pdev);
> -	for (i = PT3_NUM_FE - 1; i >= 0; i--)
> -		pt3_cleanup_adapter(pt3, i);
> -	i2c_del_adapter(&pt3->i2c_adap);
> -	kfree(pt3->i2c_buf);
> -	pci_iounmap(pt3->pdev, pt3->regs[0]);
> -	pci_iounmap(pt3->pdev, pt3->regs[1]);
> -	pci_release_regions(pdev);
> -	pci_disable_device(pdev);
> -	kfree(pt3);
> -}
> -
> -static int pt3_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
> -{
> -	u8 rev;
> -	u32 ver;
> -	int i, ret;
> -	struct pt3_board *pt3;
> -	struct i2c_adapter *i2c;
> -
> -	if (pci_read_config_byte(pdev, PCI_REVISION_ID, &rev) || rev != 1)
> -		return -ENODEV;
> -
> -	ret = pci_enable_device(pdev);
> -	if (ret < 0)
> -		return -ENODEV;
> -	pci_set_master(pdev);
> -
> -	ret = pci_request_regions(pdev, DRV_NAME);
> -	if (ret < 0)
> -		goto err_disable_device;
> -
> -	ret = dma_set_mask(&pdev->dev, DMA_BIT_MASK(64));
> -	if (ret == 0)
> -		dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(64));
> -	else {
> -		ret = dma_set_mask(&pdev->dev, DMA_BIT_MASK(32));
> -		if (ret == 0)
> -			dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
> -		else {
> -			dev_err(&pdev->dev, "Failed to set DMA mask\n");
> -			goto err_release_regions;
> -		}
> -		dev_info(&pdev->dev, "Use 32bit DMA\n");
> -	}
> -
> -	pt3 = kzalloc(sizeof(*pt3), GFP_KERNEL);
> -	if (!pt3) {
> -		ret = -ENOMEM;
> -		goto err_release_regions;
> -	}
> -	pci_set_drvdata(pdev, pt3);
> -	pt3->pdev = pdev;
> -	mutex_init(&pt3->lock);
> -	pt3->regs[0] = pci_ioremap_bar(pdev, 0);
> -	pt3->regs[1] = pci_ioremap_bar(pdev, 2);
> -	if (pt3->regs[0] == NULL || pt3->regs[1] == NULL) {
> -		dev_err(&pdev->dev, "Failed to ioremap\n");
> -		ret = -ENOMEM;
> -		goto err_kfree;
> -	}
> -
> -	ver = ioread32(pt3->regs[0] + REG_VERSION);
> -	if ((ver >> 16) != 0x0301) {
> -		dev_warn(&pdev->dev, "PT%d, I/F-ver.:%d not supported\n",
> -			 ver >> 24, (ver & 0x00ff0000) >> 16);
> -		ret = -ENODEV;
> -		goto err_iounmap;
> -	}
> -
> -	pt3->num_bufs = clamp_val(num_bufs, MIN_DATA_BUFS, MAX_DATA_BUFS);
> -
> -	pt3->i2c_buf = kmalloc(sizeof(*pt3->i2c_buf), GFP_KERNEL);
> -	if (pt3->i2c_buf == NULL) {
> -		ret = -ENOMEM;
> -		goto err_iounmap;
> -	}
> -	i2c = &pt3->i2c_adap;
> -	i2c->owner = THIS_MODULE;
> -	i2c->algo = &pt3_i2c_algo;
> -	i2c->algo_data = NULL;
> -	i2c->dev.parent = &pdev->dev;
> -	strlcpy(i2c->name, DRV_NAME, sizeof(i2c->name));
> -	i2c_set_adapdata(i2c, pt3);
> -	ret = i2c_add_adapter(i2c);
> -	if (ret < 0) {
> -		dev_err(&pdev->dev, "Failed to add i2c adapter\n");
> -		goto err_i2cbuf;
> -	}
> -
> -	for (i = 0; i < PT3_NUM_FE; i++) {
> -		ret = pt3_alloc_adapter(pt3, i);
> -		if (ret < 0)
> -			break;
> -
> -		ret = pt3_attach_fe(pt3, i);
> -		if (ret < 0)
> -			break;
> -	}
> -	if (i < PT3_NUM_FE) {
> -		dev_err(&pdev->dev, "Failed to create FE%d\n", i);
> -		goto err_cleanup_adapters;
> -	}
> -
> -	ret = pt3_fe_init(pt3);
> -	if (ret < 0) {
> -		dev_err(&pdev->dev, "Failed to init frontends\n");
> -		i = PT3_NUM_FE - 1;
> -		goto err_cleanup_adapters;
> -	}
> -
> -	dev_info(&pdev->dev,
> -		 "successfully init'ed PT%d (fw:0x%02x, I/F:0x%02x)\n",
> -		 ver >> 24, (ver >> 8) & 0xff, (ver >> 16) & 0xff);
> -	return 0;
> -
> -err_cleanup_adapters:
> -	while (i >= 0)
> -		pt3_cleanup_adapter(pt3, i--);
> -	i2c_del_adapter(i2c);
> -err_i2cbuf:
> -	kfree(pt3->i2c_buf);
> -err_iounmap:
> -	if (pt3->regs[0])
> -		pci_iounmap(pdev, pt3->regs[0]);
> -	if (pt3->regs[1])
> -		pci_iounmap(pdev, pt3->regs[1]);
> -err_kfree:
> -	kfree(pt3);
> -err_release_regions:
> -	pci_release_regions(pdev);
> -err_disable_device:
> -	pci_disable_device(pdev);
> -	return ret;
> -
> -}
> -
> -static const struct pci_device_id pt3_id_table[] = {
> -	{ PCI_DEVICE_SUB(0x1172, 0x4c15, 0xee8d, 0x0368) },
> -	{ },
> -};
> -MODULE_DEVICE_TABLE(pci, pt3_id_table);
> -
> -static SIMPLE_DEV_PM_OPS(pt3_pm_ops, pt3_suspend, pt3_resume);
> -
> -static struct pci_driver pt3_driver = {
> -	.name		= DRV_NAME,
> -	.probe		= pt3_probe,
> -	.remove		= pt3_remove,
> -	.id_table	= pt3_id_table,
> -
> -	.driver.pm	= &pt3_pm_ops,
> -};
> -
> -module_pci_driver(pt3_driver);
> -
> -MODULE_DESCRIPTION("Earthsoft PT3 Driver");
> -MODULE_AUTHOR("Akihiro TSUKADA");
> -MODULE_LICENSE("GPL");
> diff --git a/drivers/media/pci/pt3/pt3.h b/drivers/media/pci/pt3/pt3.h
> deleted file mode 100644
> index 1b3f2ad..0000000
> --- a/drivers/media/pci/pt3/pt3.h
> +++ /dev/null
> @@ -1,186 +0,0 @@
> -/*
> - * Earthsoft PT3 driver
> - *
> - * Copyright (C) 2014 Akihiro Tsukada <tskd08@gmail.com>
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation version 2.
> - *
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - */
> -
> -#ifndef PT3_H
> -#define PT3_H
> -
> -#include <linux/atomic.h>
> -#include <linux/types.h>
> -
> -#include "dvb_demux.h"
> -#include "dvb_frontend.h"
> -#include "dmxdev.h"
> -
> -#include "tc90522.h"
> -#include "mxl301rf.h"
> -#include "qm1d1c0042.h"
> -
> -#define DRV_NAME KBUILD_MODNAME
> -
> -#define PT3_NUM_FE 4
> -
> -/*
> - * register index of the FPGA chip
> - */
> -#define REG_VERSION	0x00
> -#define REG_BUS		0x04
> -#define REG_SYSTEM_W	0x08
> -#define REG_SYSTEM_R	0x0c
> -#define REG_I2C_W	0x10
> -#define REG_I2C_R	0x14
> -#define REG_RAM_W	0x18
> -#define REG_RAM_R	0x1c
> -#define REG_DMA_BASE	0x40	/* regs for FE[i] = REG_DMA_BASE + 0x18 * i */
> -#define OFST_DMA_DESC_L	0x00
> -#define OFST_DMA_DESC_H	0x04
> -#define OFST_DMA_CTL	0x08
> -#define OFST_TS_CTL	0x0c
> -#define OFST_STATUS	0x10
> -#define OFST_TS_ERR	0x14
> -
> -/*
> - * internal buffer for I2C
> - */
> -#define PT3_I2C_MAX 4091
> -struct pt3_i2cbuf {
> -	u8  data[PT3_I2C_MAX];
> -	u8  tmp;
> -	u32 num_cmds;
> -};
> -
> -/*
> - * DMA things
> - */
> -#define TS_PACKET_SZ  188
> -/* DMA transfers must not cross 4GiB, so use one page / transfer */
> -#define DATA_XFER_SZ   4096
> -#define DATA_BUF_XFERS 47
> -/* (num_bufs * DATA_BUF_SZ) % TS_PACKET_SZ must be 0 */
> -#define DATA_BUF_SZ    (DATA_BUF_XFERS * DATA_XFER_SZ)
> -#define MAX_DATA_BUFS  16
> -#define MIN_DATA_BUFS   2
> -
> -#define DESCS_IN_PAGE (PAGE_SIZE / sizeof(struct xfer_desc))
> -#define MAX_NUM_XFERS (MAX_DATA_BUFS * DATA_BUF_XFERS)
> -#define MAX_DESC_BUFS DIV_ROUND_UP(MAX_NUM_XFERS, DESCS_IN_PAGE)
> -
> -/* DMA transfer description.
> - * device is passed a pointer to this struct, dma-reads it,
> - * and gets the DMA buffer ring for storing TS data.
> - */
> -struct xfer_desc {
> -	u32 addr_l; /* bus address of target data buffer */
> -	u32 addr_h;
> -	u32 size;
> -	u32 next_l; /* bus adddress of the next xfer_desc */
> -	u32 next_h;
> -};
> -
> -/* A DMA mapping of a page containing xfer_desc's */
> -struct xfer_desc_buffer {
> -	dma_addr_t b_addr;
> -	struct xfer_desc *descs; /* PAGE_SIZE (xfer_desc[DESCS_IN_PAGE]) */
> -};
> -
> -/* A DMA mapping of a data buffer */
> -struct dma_data_buffer {
> -	dma_addr_t b_addr;
> -	u8 *data; /* size: u8[PAGE_SIZE] */
> -};
> -
> -/*
> - * device things
> - */
> -struct pt3_adap_config {
> -	struct i2c_board_info demod_info;
> -	struct tc90522_config demod_cfg;
> -
> -	struct i2c_board_info tuner_info;
> -	union tuner_config {
> -		struct qm1d1c0042_config qm1d1c0042;
> -		struct mxl301rf_config   mxl301rf;
> -	} tuner_cfg;
> -	u32 init_freq;
> -};
> -
> -struct pt3_adapter {
> -	struct dvb_adapter  dvb_adap;  /* dvb_adap.priv => struct pt3_board */
> -	int adap_idx;
> -
> -	struct dvb_demux    demux;
> -	struct dmxdev       dmxdev;
> -	struct dvb_frontend *fe;
> -	struct i2c_client   *i2c_demod;
> -	struct i2c_client   *i2c_tuner;
> -
> -	/* data fetch thread */
> -	struct task_struct *thread;
> -	int num_feeds;
> -
> -	bool cur_lna;
> -	bool cur_lnb; /* current LNB power status (on/off) */
> -
> -	/* items below are for DMA */
> -	struct dma_data_buffer buffer[MAX_DATA_BUFS];
> -	int buf_idx;
> -	int buf_ofs;
> -	int num_bufs;  /* == pt3_board->num_bufs */
> -	int num_discard; /* how many access units to discard initially */
> -
> -	struct xfer_desc_buffer desc_buf[MAX_DESC_BUFS];
> -	int num_desc_bufs;  /* == num_bufs * DATA_BUF_XFERS / DESCS_IN_PAGE */
> -};
> -
> -
> -struct pt3_board {
> -	struct pci_dev *pdev;
> -	void __iomem *regs[2];
> -	/* regs[0]: registers, regs[1]: internal memory, used for I2C */
> -
> -	struct mutex lock;
> -
> -	/* LNB power shared among sat-FEs */
> -	int lnb_on_cnt; /* LNB power on count */
> -
> -	/* LNA shared among terr-FEs */
> -	int lna_on_cnt; /* booster enabled count */
> -
> -	int num_bufs;  /* number of DMA buffers allocated/mapped per FE */
> -
> -	struct i2c_adapter i2c_adap;
> -	struct pt3_i2cbuf *i2c_buf;
> -
> -	struct pt3_adapter *adaps[PT3_NUM_FE];
> -};
> -
> -
> -/*
> - * prototypes
> - */
> -extern int  pt3_alloc_dmabuf(struct pt3_adapter *adap);
> -extern void pt3_init_dmabuf(struct pt3_adapter *adap);
> -extern void pt3_free_dmabuf(struct pt3_adapter *adap);
> -extern int  pt3_start_dma(struct pt3_adapter *adap);
> -extern int  pt3_stop_dma(struct pt3_adapter *adap);
> -extern int  pt3_proc_dma(struct pt3_adapter *adap);
> -
> -extern int  pt3_i2c_master_xfer(struct i2c_adapter *adap,
> -				struct i2c_msg *msgs, int num);
> -extern u32  pt3_i2c_functionality(struct i2c_adapter *adap);
> -extern void pt3_i2c_reset(struct pt3_board *pt3);
> -extern int  pt3_init_all_demods(struct pt3_board *pt3);
> -extern int  pt3_init_all_mxl301rf(struct pt3_board *pt3);
> -#endif /* PT3_H */
> diff --git a/drivers/media/pci/pt3/pt3_dma.c b/drivers/media/pci/pt3/pt3_dma.c
> deleted file mode 100644
> index f0ce904..0000000
> --- a/drivers/media/pci/pt3/pt3_dma.c
> +++ /dev/null
> @@ -1,225 +0,0 @@
> -/*
> - * Earthsoft PT3 driver
> - *
> - * Copyright (C) 2014 Akihiro Tsukada <tskd08@gmail.com>
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation version 2.
> - *
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - */
> -#include <linux/dma-mapping.h>
> -#include <linux/kernel.h>
> -#include <linux/pci.h>
> -
> -#include "pt3.h"
> -
> -#define PT3_ACCESS_UNIT (TS_PACKET_SZ * 128)
> -#define PT3_BUF_CANARY  (0x74)
> -
> -static u32 get_dma_base(int idx)
> -{
> -	int i;
> -
> -	i = (idx == 1 || idx == 2) ? 3 - idx : idx;
> -	return REG_DMA_BASE + 0x18 * i;
> -}
> -
> -int pt3_stop_dma(struct pt3_adapter *adap)
> -{
> -	struct pt3_board *pt3 = adap->dvb_adap.priv;
> -	u32 base;
> -	u32 stat;
> -	int retry;
> -
> -	base = get_dma_base(adap->adap_idx);
> -	stat = ioread32(pt3->regs[0] + base + OFST_STATUS);
> -	if (!(stat & 0x01))
> -		return 0;
> -
> -	iowrite32(0x02, pt3->regs[0] + base + OFST_DMA_CTL);
> -	for (retry = 0; retry < 5; retry++) {
> -		stat = ioread32(pt3->regs[0] + base + OFST_STATUS);
> -		if (!(stat & 0x01))
> -			return 0;
> -		msleep(50);
> -	}
> -	return -EIO;
> -}
> -
> -int pt3_start_dma(struct pt3_adapter *adap)
> -{
> -	struct pt3_board *pt3 = adap->dvb_adap.priv;
> -	u32 base = get_dma_base(adap->adap_idx);
> -
> -	iowrite32(0x02, pt3->regs[0] + base + OFST_DMA_CTL);
> -	iowrite32(lower_32_bits(adap->desc_buf[0].b_addr),
> -			pt3->regs[0] + base + OFST_DMA_DESC_L);
> -	iowrite32(upper_32_bits(adap->desc_buf[0].b_addr),
> -			pt3->regs[0] + base + OFST_DMA_DESC_H);
> -	iowrite32(0x01, pt3->regs[0] + base + OFST_DMA_CTL);
> -	return 0;
> -}
> -
> -
> -static u8 *next_unit(struct pt3_adapter *adap, int *idx, int *ofs)
> -{
> -	*ofs += PT3_ACCESS_UNIT;
> -	if (*ofs >= DATA_BUF_SZ) {
> -		*ofs -= DATA_BUF_SZ;
> -		(*idx)++;
> -		if (*idx == adap->num_bufs)
> -			*idx = 0;
> -	}
> -	return &adap->buffer[*idx].data[*ofs];
> -}
> -
> -int pt3_proc_dma(struct pt3_adapter *adap)
> -{
> -	int idx, ofs;
> -
> -	idx = adap->buf_idx;
> -	ofs = adap->buf_ofs;
> -
> -	if (adap->buffer[idx].data[ofs] == PT3_BUF_CANARY)
> -		return 0;
> -
> -	while (*next_unit(adap, &idx, &ofs) != PT3_BUF_CANARY) {
> -		u8 *p;
> -
> -		p = &adap->buffer[adap->buf_idx].data[adap->buf_ofs];
> -		if (adap->num_discard > 0)
> -			adap->num_discard--;
> -		else if (adap->buf_ofs + PT3_ACCESS_UNIT > DATA_BUF_SZ) {
> -			dvb_dmx_swfilter_packets(&adap->demux, p,
> -				(DATA_BUF_SZ - adap->buf_ofs) / TS_PACKET_SZ);
> -			dvb_dmx_swfilter_packets(&adap->demux,
> -				adap->buffer[idx].data, ofs / TS_PACKET_SZ);
> -		} else
> -			dvb_dmx_swfilter_packets(&adap->demux, p,
> -				PT3_ACCESS_UNIT / TS_PACKET_SZ);
> -
> -		*p = PT3_BUF_CANARY;
> -		adap->buf_idx = idx;
> -		adap->buf_ofs = ofs;
> -	}
> -	return 0;
> -}
> -
> -void pt3_init_dmabuf(struct pt3_adapter *adap)
> -{
> -	int idx, ofs;
> -	u8 *p;
> -
> -	idx = 0;
> -	ofs = 0;
> -	p = adap->buffer[0].data;
> -	/* mark the whole buffers as "not written yet" */
> -	while (idx < adap->num_bufs) {
> -		p[ofs] = PT3_BUF_CANARY;
> -		ofs += PT3_ACCESS_UNIT;
> -		if (ofs >= DATA_BUF_SZ) {
> -			ofs -= DATA_BUF_SZ;
> -			idx++;
> -			p = adap->buffer[idx].data;
> -		}
> -	}
> -	adap->buf_idx = 0;
> -	adap->buf_ofs = 0;
> -}
> -
> -void pt3_free_dmabuf(struct pt3_adapter *adap)
> -{
> -	struct pt3_board *pt3;
> -	int i;
> -
> -	pt3 = adap->dvb_adap.priv;
> -	for (i = 0; i < adap->num_bufs; i++)
> -		dma_free_coherent(&pt3->pdev->dev, DATA_BUF_SZ,
> -			adap->buffer[i].data, adap->buffer[i].b_addr);
> -	adap->num_bufs = 0;
> -
> -	for (i = 0; i < adap->num_desc_bufs; i++)
> -		dma_free_coherent(&pt3->pdev->dev, PAGE_SIZE,
> -			adap->desc_buf[i].descs, adap->desc_buf[i].b_addr);
> -	adap->num_desc_bufs = 0;
> -}
> -
> -
> -int pt3_alloc_dmabuf(struct pt3_adapter *adap)
> -{
> -	struct pt3_board *pt3;
> -	void *p;
> -	int i, j;
> -	int idx, ofs;
> -	int num_desc_bufs;
> -	dma_addr_t data_addr, desc_addr;
> -	struct xfer_desc *d;
> -
> -	pt3 = adap->dvb_adap.priv;
> -	adap->num_bufs = 0;
> -	adap->num_desc_bufs = 0;
> -	for (i = 0; i < pt3->num_bufs; i++) {
> -		p = dma_alloc_coherent(&pt3->pdev->dev, DATA_BUF_SZ,
> -					&adap->buffer[i].b_addr, GFP_KERNEL);
> -		if (p == NULL)
> -			goto failed;
> -		adap->buffer[i].data = p;
> -		adap->num_bufs++;
> -	}
> -	pt3_init_dmabuf(adap);
> -
> -	/* build circular-linked pointers (xfer_desc) to the data buffers*/
> -	idx = 0;
> -	ofs = 0;
> -	num_desc_bufs =
> -		DIV_ROUND_UP(adap->num_bufs * DATA_BUF_XFERS, DESCS_IN_PAGE);
> -	for (i = 0; i < num_desc_bufs; i++) {
> -		p = dma_alloc_coherent(&pt3->pdev->dev, PAGE_SIZE,
> -					&desc_addr, GFP_KERNEL);
> -		if (p == NULL)
> -			goto failed;
> -		adap->num_desc_bufs++;
> -		adap->desc_buf[i].descs = p;
> -		adap->desc_buf[i].b_addr = desc_addr;
> -
> -		if (i > 0) {
> -			d = &adap->desc_buf[i - 1].descs[DESCS_IN_PAGE - 1];
> -			d->next_l = lower_32_bits(desc_addr);
> -			d->next_h = upper_32_bits(desc_addr);
> -		}
> -		for (j = 0; j < DESCS_IN_PAGE; j++) {
> -			data_addr = adap->buffer[idx].b_addr + ofs;
> -			d = &adap->desc_buf[i].descs[j];
> -			d->addr_l = lower_32_bits(data_addr);
> -			d->addr_h = upper_32_bits(data_addr);
> -			d->size = DATA_XFER_SZ;
> -
> -			desc_addr += sizeof(struct xfer_desc);
> -			d->next_l = lower_32_bits(desc_addr);
> -			d->next_h = upper_32_bits(desc_addr);
> -
> -			ofs += DATA_XFER_SZ;
> -			if (ofs >= DATA_BUF_SZ) {
> -				ofs -= DATA_BUF_SZ;
> -				idx++;
> -				if (idx >= adap->num_bufs) {
> -					desc_addr = adap->desc_buf[0].b_addr;
> -					d->next_l = lower_32_bits(desc_addr);
> -					d->next_h = upper_32_bits(desc_addr);
> -					return 0;
> -				}
> -			}
> -		}
> -	}
> -	return 0;
> -
> -failed:
> -	pt3_free_dmabuf(adap);
> -	return -ENOMEM;
> -}
> diff --git a/drivers/media/pci/pt3/pt3_i2c.c b/drivers/media/pci/pt3/pt3_i2c.c
> deleted file mode 100644
> index ec6a8a2..0000000
> --- a/drivers/media/pci/pt3/pt3_i2c.c
> +++ /dev/null
> @@ -1,240 +0,0 @@
> -/*
> - * Earthsoft PT3 driver
> - *
> - * Copyright (C) 2014 Akihiro Tsukada <tskd08@gmail.com>
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation version 2.
> - *
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - */
> -#include <linux/delay.h>
> -#include <linux/device.h>
> -#include <linux/i2c.h>
> -#include <linux/io.h>
> -#include <linux/pci.h>
> -
> -#include "pt3.h"
> -
> -#define PT3_I2C_BASE  2048
> -#define PT3_CMD_ADDR_NORMAL 0
> -#define PT3_CMD_ADDR_INIT_DEMOD  4096
> -#define PT3_CMD_ADDR_INIT_TUNER  (4096 + 2042)
> -
> -/* masks for I2C status register */
> -#define STAT_SEQ_RUNNING 0x1
> -#define STAT_SEQ_ERROR   0x6
> -#define STAT_NO_SEQ      0x8
> -
> -#define PT3_I2C_RUN   (1 << 16)
> -#define PT3_I2C_RESET (1 << 17)
> -
> -enum ctl_cmd {
> -	I_END,
> -	I_ADDRESS,
> -	I_CLOCK_L,
> -	I_CLOCK_H,
> -	I_DATA_L,
> -	I_DATA_H,
> -	I_RESET,
> -	I_SLEEP,
> -	I_DATA_L_NOP  = 0x08,
> -	I_DATA_H_NOP  = 0x0c,
> -	I_DATA_H_READ = 0x0d,
> -	I_DATA_H_ACK0 = 0x0e,
> -	I_DATA_H_ACK1 = 0x0f,
> -};
> -
> -
> -static void cmdbuf_add(struct pt3_i2cbuf *cbuf, enum ctl_cmd cmd)
> -{
> -	int buf_idx;
> -
> -	if ((cbuf->num_cmds % 2) == 0)
> -		cbuf->tmp = cmd;
> -	else {
> -		cbuf->tmp |= cmd << 4;
> -		buf_idx = cbuf->num_cmds / 2;
> -		if (buf_idx < ARRAY_SIZE(cbuf->data))
> -			cbuf->data[buf_idx] = cbuf->tmp;
> -	}
> -	cbuf->num_cmds++;
> -}
> -
> -static void put_end(struct pt3_i2cbuf *cbuf)
> -{
> -	cmdbuf_add(cbuf, I_END);
> -	if (cbuf->num_cmds % 2)
> -		cmdbuf_add(cbuf, I_END);
> -}
> -
> -static void put_start(struct pt3_i2cbuf *cbuf)
> -{
> -	cmdbuf_add(cbuf, I_DATA_H);
> -	cmdbuf_add(cbuf, I_CLOCK_H);
> -	cmdbuf_add(cbuf, I_DATA_L);
> -	cmdbuf_add(cbuf, I_CLOCK_L);
> -}
> -
> -static void put_byte_write(struct pt3_i2cbuf *cbuf, u8 val)
> -{
> -	u8 mask;
> -
> -	mask = 0x80;
> -	for (mask = 0x80; mask > 0; mask >>= 1)
> -		cmdbuf_add(cbuf, (val & mask) ? I_DATA_H_NOP : I_DATA_L_NOP);
> -	cmdbuf_add(cbuf, I_DATA_H_ACK0);
> -}
> -
> -static void put_byte_read(struct pt3_i2cbuf *cbuf, u32 size)
> -{
> -	int i, j;
> -
> -	for (i = 0; i < size; i++) {
> -		for (j = 0; j < 8; j++)
> -			cmdbuf_add(cbuf, I_DATA_H_READ);
> -		cmdbuf_add(cbuf, (i == size - 1) ? I_DATA_H_NOP : I_DATA_L_NOP);
> -	}
> -}
> -
> -static void put_stop(struct pt3_i2cbuf *cbuf)
> -{
> -	cmdbuf_add(cbuf, I_DATA_L);
> -	cmdbuf_add(cbuf, I_CLOCK_H);
> -	cmdbuf_add(cbuf, I_DATA_H);
> -}
> -
> -
> -/* translates msgs to internal commands for bit-banging */
> -static void translate(struct pt3_i2cbuf *cbuf, struct i2c_msg *msgs, int num)
> -{
> -	int i, j;
> -	bool rd;
> -
> -	cbuf->num_cmds = 0;
> -	for (i = 0; i < num; i++) {
> -		rd = !!(msgs[i].flags & I2C_M_RD);
> -		put_start(cbuf);
> -		put_byte_write(cbuf, msgs[i].addr << 1 | rd);
> -		if (rd)
> -			put_byte_read(cbuf, msgs[i].len);
> -		else
> -			for (j = 0; j < msgs[i].len; j++)
> -				put_byte_write(cbuf, msgs[i].buf[j]);
> -	}
> -	if (num > 0) {
> -		put_stop(cbuf);
> -		put_end(cbuf);
> -	}
> -}
> -
> -static int wait_i2c_result(struct pt3_board *pt3, u32 *result, int max_wait)
> -{
> -	int i;
> -	u32 v;
> -
> -	for (i = 0; i < max_wait; i++) {
> -		v = ioread32(pt3->regs[0] + REG_I2C_R);
> -		if (!(v & STAT_SEQ_RUNNING))
> -			break;
> -		usleep_range(500, 750);
> -	}
> -	if (i >= max_wait)
> -		return -EIO;
> -	if (result)
> -		*result = v;
> -	return 0;
> -}
> -
> -/* send [pre-]translated i2c msgs stored at addr */
> -static int send_i2c_cmd(struct pt3_board *pt3, u32 addr)
> -{
> -	u32 ret;
> -
> -	/* make sure that previous transactions had finished */
> -	if (wait_i2c_result(pt3, NULL, 50)) {
> -		dev_warn(&pt3->pdev->dev, "(%s) prev. transaction stalled\n",
> -				__func__);
> -		return -EIO;
> -	}
> -
> -	iowrite32(PT3_I2C_RUN | addr, pt3->regs[0] + REG_I2C_W);
> -	usleep_range(200, 300);
> -	/* wait for the current transaction to finish */
> -	if (wait_i2c_result(pt3, &ret, 500) || (ret & STAT_SEQ_ERROR)) {
> -		dev_warn(&pt3->pdev->dev, "(%s) failed.\n", __func__);
> -		return -EIO;
> -	}
> -	return 0;
> -}
> -
> -
> -/* init commands for each demod are combined into one transaction
> - *  and hidden in ROM with the address PT3_CMD_ADDR_INIT_DEMOD.
> - */
> -int  pt3_init_all_demods(struct pt3_board *pt3)
> -{
> -	ioread32(pt3->regs[0] + REG_I2C_R);
> -	return send_i2c_cmd(pt3, PT3_CMD_ADDR_INIT_DEMOD);
> -}
> -
> -/* init commands for two ISDB-T tuners are hidden in ROM. */
> -int  pt3_init_all_mxl301rf(struct pt3_board *pt3)
> -{
> -	usleep_range(1000, 2000);
> -	return send_i2c_cmd(pt3, PT3_CMD_ADDR_INIT_TUNER);
> -}
> -
> -void pt3_i2c_reset(struct pt3_board *pt3)
> -{
> -	iowrite32(PT3_I2C_RESET, pt3->regs[0] + REG_I2C_W);
> -}
> -
> -/*
> - * I2C algorithm
> - */
> -int
> -pt3_i2c_master_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs, int num)
> -{
> -	struct pt3_board *pt3;
> -	struct pt3_i2cbuf *cbuf;
> -	int i;
> -	void __iomem *p;
> -
> -	pt3 = i2c_get_adapdata(adap);
> -	cbuf = pt3->i2c_buf;
> -
> -	for (i = 0; i < num; i++)
> -		if (msgs[i].flags & I2C_M_RECV_LEN) {
> -			dev_warn(&pt3->pdev->dev,
> -				"(%s) I2C_M_RECV_LEN not supported.\n",
> -				__func__);
> -			return -EINVAL;
> -		}
> -
> -	translate(cbuf, msgs, num);
> -	memcpy_toio(pt3->regs[1] + PT3_I2C_BASE + PT3_CMD_ADDR_NORMAL / 2,
> -			cbuf->data, cbuf->num_cmds);
> -
> -	if (send_i2c_cmd(pt3, PT3_CMD_ADDR_NORMAL) < 0)
> -		return -EIO;
> -
> -	p = pt3->regs[1] + PT3_I2C_BASE;
> -	for (i = 0; i < num; i++)
> -		if ((msgs[i].flags & I2C_M_RD) && msgs[i].len > 0) {
> -			memcpy_fromio(msgs[i].buf, p, msgs[i].len);
> -			p += msgs[i].len;
> -		}
> -
> -	return num;
> -}
> -
> -u32 pt3_i2c_functionality(struct i2c_adapter *adap)
> -{
> -	return I2C_FUNC_I2C;
> -}
> diff --git a/drivers/media/tuners/mxl301rf.c b/drivers/media/tuners/mxl301rf.c
> deleted file mode 100644
> index 1575a5d..0000000
> --- a/drivers/media/tuners/mxl301rf.c
> +++ /dev/null
> @@ -1,349 +0,0 @@
> -/*
> - * MaxLinear MxL301RF OFDM tuner driver
> - *
> - * Copyright (C) 2014 Akihiro Tsukada <tskd08@gmail.com>
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation version 2.
> - *
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - */
> -
> -/*
> - * NOTICE:
> - * This driver is incomplete and lacks init/config of the chips,
> - * as the necessary info is not disclosed.
> - * Other features like get_if_frequency() are missing as well.
> - * It assumes that users of this driver (such as a PCI bridge of
> - * DTV receiver cards) properly init and configure the chip
> - * via I2C *before* calling this driver's init() function.
> - *
> - * Currently, PT3 driver is the only one that uses this driver,
> - * and contains init/config code in its firmware.
> - * Thus some part of the code might be dependent on PT3 specific config.
> - */
> -
> -#include <linux/kernel.h>
> -#include "mxl301rf.h"
> -
> -struct mxl301rf_state {
> -	struct mxl301rf_config cfg;
> -	struct i2c_client *i2c;
> -};
> -
> -static struct mxl301rf_state *cfg_to_state(struct mxl301rf_config *c)
> -{
> -	return container_of(c, struct mxl301rf_state, cfg);
> -}
> -
> -static int raw_write(struct mxl301rf_state *state, const u8 *buf, int len)
> -{
> -	int ret;
> -
> -	ret = i2c_master_send(state->i2c, buf, len);
> -	if (ret >= 0 && ret < len)
> -		ret = -EIO;
> -	return (ret == len) ? 0 : ret;
> -}
> -
> -static int reg_write(struct mxl301rf_state *state, u8 reg, u8 val)
> -{
> -	u8 buf[2] = { reg, val };
> -
> -	return raw_write(state, buf, 2);
> -}
> -
> -static int reg_read(struct mxl301rf_state *state, u8 reg, u8 *val)
> -{
> -	u8 wbuf[2] = { 0xfb, reg };
> -	int ret;
> -
> -	ret = raw_write(state, wbuf, sizeof(wbuf));
> -	if (ret == 0)
> -		ret = i2c_master_recv(state->i2c, val, 1);
> -	if (ret >= 0 && ret < 1)
> -		ret = -EIO;
> -	return (ret == 1) ? 0 : ret;
> -}
> -
> -/* tuner_ops */
> -
> -/* get RSSI and update propery cache, set to *out in % */
> -static int mxl301rf_get_rf_strength(struct dvb_frontend *fe, u16 *out)
> -{
> -	struct mxl301rf_state *state;
> -	int ret;
> -	u8  rf_in1, rf_in2, rf_off1, rf_off2;
> -	u16 rf_in, rf_off;
> -	s64 level;
> -	struct dtv_fe_stats *rssi;
> -
> -	rssi = &fe->dtv_property_cache.strength;
> -	rssi->len = 1;
> -	rssi->stat[0].scale = FE_SCALE_NOT_AVAILABLE;
> -	*out = 0;
> -
> -	state = fe->tuner_priv;
> -	ret = reg_write(state, 0x14, 0x01);
> -	if (ret < 0)
> -		return ret;
> -	usleep_range(1000, 2000);
> -
> -	ret = reg_read(state, 0x18, &rf_in1);
> -	if (ret == 0)
> -		ret = reg_read(state, 0x19, &rf_in2);
> -	if (ret == 0)
> -		ret = reg_read(state, 0xd6, &rf_off1);
> -	if (ret == 0)
> -		ret = reg_read(state, 0xd7, &rf_off2);
> -	if (ret != 0)
> -		return ret;
> -
> -	rf_in = (rf_in2 & 0x07) << 8 | rf_in1;
> -	rf_off = (rf_off2 & 0x0f) << 5 | (rf_off1 >> 3);
> -	level = rf_in - rf_off - (113 << 3); /* x8 dBm */
> -	level = level * 1000 / 8;
> -	rssi->stat[0].svalue = level;
> -	rssi->stat[0].scale = FE_SCALE_DECIBEL;
> -	/* *out = (level - min) * 100 / (max - min) */
> -	*out = (rf_in - rf_off + (1 << 9) - 1) * 100 / ((5 << 9) - 2);
> -	return 0;
> -}
> -
> -/* spur shift parameters */
> -struct shf {
> -	u32	freq;		/* Channel center frequency */
> -	u32	ofst_th;	/* Offset frequency threshold */
> -	u8	shf_val;	/* Spur shift value */
> -	u8	shf_dir;	/* Spur shift direction */
> -};
> -
> -static const struct shf shf_tab[] = {
> -	{  64500, 500, 0x92, 0x07 },
> -	{ 191500, 300, 0xe2, 0x07 },
> -	{ 205500, 500, 0x2c, 0x04 },
> -	{ 212500, 500, 0x1e, 0x04 },
> -	{ 226500, 500, 0xd4, 0x07 },
> -	{  99143, 500, 0x9c, 0x07 },
> -	{ 173143, 500, 0xd4, 0x07 },
> -	{ 191143, 300, 0xd4, 0x07 },
> -	{ 207143, 500, 0xce, 0x07 },
> -	{ 225143, 500, 0xce, 0x07 },
> -	{ 243143, 500, 0xd4, 0x07 },
> -	{ 261143, 500, 0xd4, 0x07 },
> -	{ 291143, 500, 0xd4, 0x07 },
> -	{ 339143, 500, 0x2c, 0x04 },
> -	{ 117143, 500, 0x7a, 0x07 },
> -	{ 135143, 300, 0x7a, 0x07 },
> -	{ 153143, 500, 0x01, 0x07 }
> -};
> -
> -struct reg_val {
> -	u8 reg;
> -	u8 val;
> -} __attribute__ ((__packed__));
> -
> -static const struct reg_val set_idac[] = {
> -	{ 0x0d, 0x00 },
> -	{ 0x0c, 0x67 },
> -	{ 0x6f, 0x89 },
> -	{ 0x70, 0x0c },
> -	{ 0x6f, 0x8a },
> -	{ 0x70, 0x0e },
> -	{ 0x6f, 0x8b },
> -	{ 0x70, 0x1c },
> -};
> -
> -static int mxl301rf_set_params(struct dvb_frontend *fe)
> -{
> -	struct reg_val tune0[] = {
> -		{ 0x13, 0x00 },		/* abort tuning */
> -		{ 0x3b, 0xc0 },
> -		{ 0x3b, 0x80 },
> -		{ 0x10, 0x95 },		/* BW */
> -		{ 0x1a, 0x05 },
> -		{ 0x61, 0x00 },		/* spur shift value (placeholder) */
> -		{ 0x62, 0xa0 }		/* spur shift direction (placeholder) */
> -	};
> -
> -	struct reg_val tune1[] = {
> -		{ 0x11, 0x40 },		/* RF frequency L (placeholder) */
> -		{ 0x12, 0x0e },		/* RF frequency H (placeholder) */
> -		{ 0x13, 0x01 }		/* start tune */
> -	};
> -
> -	struct mxl301rf_state *state;
> -	u32 freq;
> -	u16 f;
> -	u32 tmp, div;
> -	int i, ret;
> -
> -	state = fe->tuner_priv;
> -	freq = fe->dtv_property_cache.frequency;
> -
> -	/* spur shift function (for analog) */
> -	for (i = 0; i < ARRAY_SIZE(shf_tab); i++) {
> -		if (freq >= (shf_tab[i].freq - shf_tab[i].ofst_th) * 1000 &&
> -		    freq <= (shf_tab[i].freq + shf_tab[i].ofst_th) * 1000) {
> -			tune0[5].val = shf_tab[i].shf_val;
> -			tune0[6].val = 0xa0 | shf_tab[i].shf_dir;
> -			break;
> -		}
> -	}
> -	ret = raw_write(state, (u8 *) tune0, sizeof(tune0));
> -	if (ret < 0)
> -		goto failed;
> -	usleep_range(3000, 4000);
> -
> -	/* convert freq to 10.6 fixed point float [MHz] */
> -	f = freq / 1000000;
> -	tmp = freq % 1000000;
> -	div = 1000000;
> -	for (i = 0; i < 6; i++) {
> -		f <<= 1;
> -		div >>= 1;
> -		if (tmp > div) {
> -			tmp -= div;
> -			f |= 1;
> -		}
> -	}
> -	if (tmp > 7812)
> -		f++;
> -	tune1[0].val = f & 0xff;
> -	tune1[1].val = f >> 8;
> -	ret = raw_write(state, (u8 *) tune1, sizeof(tune1));
> -	if (ret < 0)
> -		goto failed;
> -	msleep(31);
> -
> -	ret = reg_write(state, 0x1a, 0x0d);
> -	if (ret < 0)
> -		goto failed;
> -	ret = raw_write(state, (u8 *) set_idac, sizeof(set_idac));
> -	if (ret < 0)
> -		goto failed;
> -	return 0;
> -
> -failed:
> -	dev_warn(&state->i2c->dev, "(%s) failed. [adap%d-fe%d]\n",
> -		__func__, fe->dvb->num, fe->id);
> -	return ret;
> -}
> -
> -static const struct reg_val standby_data[] = {
> -	{ 0x01, 0x00 },
> -	{ 0x13, 0x00 }
> -};
> -
> -static int mxl301rf_sleep(struct dvb_frontend *fe)
> -{
> -	struct mxl301rf_state *state;
> -	int ret;
> -
> -	state = fe->tuner_priv;
> -	ret = raw_write(state, (u8 *)standby_data, sizeof(standby_data));
> -	if (ret < 0)
> -		dev_warn(&state->i2c->dev, "(%s) failed. [adap%d-fe%d]\n",
> -			__func__, fe->dvb->num, fe->id);
> -	return ret;
> -}
> -
> -
> -/* init sequence is not public.
> - * the parent must have init'ed the device.
> - * just wake up here.
> - */
> -static int mxl301rf_init(struct dvb_frontend *fe)
> -{
> -	struct mxl301rf_state *state;
> -	int ret;
> -
> -	state = fe->tuner_priv;
> -
> -	ret = reg_write(state, 0x01, 0x01);
> -	if (ret < 0) {
> -		dev_warn(&state->i2c->dev, "(%s) failed. [adap%d-fe%d]\n",
> -			 __func__, fe->dvb->num, fe->id);
> -		return ret;
> -	}
> -	return 0;
> -}
> -
> -/* I2C driver functions */
> -
> -static const struct dvb_tuner_ops mxl301rf_ops = {
> -	.info = {
> -		.name = "MaxLinear MxL301RF",
> -
> -		.frequency_min =  93000000,
> -		.frequency_max = 803142857,
> -	},
> -
> -	.init = mxl301rf_init,
> -	.sleep = mxl301rf_sleep,
> -
> -	.set_params = mxl301rf_set_params,
> -	.get_rf_strength = mxl301rf_get_rf_strength,
> -};
> -
> -
> -static int mxl301rf_probe(struct i2c_client *client,
> -			  const struct i2c_device_id *id)
> -{
> -	struct mxl301rf_state *state;
> -	struct mxl301rf_config *cfg;
> -	struct dvb_frontend *fe;
> -
> -	state = kzalloc(sizeof(*state), GFP_KERNEL);
> -	if (!state)
> -		return -ENOMEM;
> -
> -	state->i2c = client;
> -	cfg = client->dev.platform_data;
> -
> -	memcpy(&state->cfg, cfg, sizeof(state->cfg));
> -	fe = cfg->fe;
> -	fe->tuner_priv = state;
> -	memcpy(&fe->ops.tuner_ops, &mxl301rf_ops, sizeof(mxl301rf_ops));
> -
> -	i2c_set_clientdata(client, &state->cfg);
> -	dev_info(&client->dev, "MaxLinear MxL301RF attached.\n");
> -	return 0;
> -}
> -
> -static int mxl301rf_remove(struct i2c_client *client)
> -{
> -	struct mxl301rf_state *state;
> -
> -	state = cfg_to_state(i2c_get_clientdata(client));
> -	state->cfg.fe->tuner_priv = NULL;
> -	kfree(state);
> -	return 0;
> -}
> -
> -
> -static const struct i2c_device_id mxl301rf_id[] = {
> -	{"mxl301rf", 0},
> -	{}
> -};
> -MODULE_DEVICE_TABLE(i2c, mxl301rf_id);
> -
> -static struct i2c_driver mxl301rf_driver = {
> -	.driver = {
> -		.name	= "mxl301rf",
> -	},
> -	.probe		= mxl301rf_probe,
> -	.remove		= mxl301rf_remove,
> -	.id_table	= mxl301rf_id,
> -};
> -
> -module_i2c_driver(mxl301rf_driver);
> -
> -MODULE_DESCRIPTION("MaxLinear MXL301RF tuner");
> -MODULE_AUTHOR("Akihiro TSUKADA");
> -MODULE_LICENSE("GPL");
> diff --git a/drivers/media/tuners/mxl301rf.h b/drivers/media/tuners/mxl301rf.h
> deleted file mode 100644
> index 19e6840..0000000
> --- a/drivers/media/tuners/mxl301rf.h
> +++ /dev/null
> @@ -1,26 +0,0 @@
> -/*
> - * MaxLinear MxL301RF OFDM tuner driver
> - *
> - * Copyright (C) 2014 Akihiro Tsukada <tskd08@gmail.com>
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation version 2.
> - *
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - */
> -
> -#ifndef MXL301RF_H
> -#define MXL301RF_H
> -
> -#include "dvb_frontend.h"
> -
> -struct mxl301rf_config {
> -	struct dvb_frontend *fe;
> -};
> -
> -#endif /* MXL301RF_H */
> diff --git a/drivers/media/tuners/qm1d1c0042.c b/drivers/media/tuners/qm1d1c0042.c
> deleted file mode 100644
> index 18bc745..0000000
> --- a/drivers/media/tuners/qm1d1c0042.c
> +++ /dev/null
> @@ -1,448 +0,0 @@
> -/*
> - * Sharp QM1D1C0042 8PSK tuner driver
> - *
> - * Copyright (C) 2014 Akihiro Tsukada <tskd08@gmail.com>
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation version 2.
> - *
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - */
> -
> -/*
> - * NOTICE:
> - * As the disclosed information on the chip is very limited,
> - * this driver lacks some features, including chip config like IF freq.
> - * It assumes that users of this driver (such as a PCI bridge of
> - * DTV receiver cards) know the relevant info and
> - * configure the chip via I2C if necessary.
> - *
> - * Currently, PT3 driver is the only one that uses this driver,
> - * and contains init/config code in its firmware.
> - * Thus some part of the code might be dependent on PT3 specific config.
> - */
> -
> -#include <linux/kernel.h>
> -#include <linux/math64.h>
> -#include "qm1d1c0042.h"
> -
> -#define QM1D1C0042_NUM_REGS 0x20
> -
> -static const u8 reg_initval[QM1D1C0042_NUM_REGS] = {
> -	0x48, 0x1c, 0xa0, 0x10, 0xbc, 0xc5, 0x20, 0x33,
> -	0x06, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00,
> -	0x00, 0xff, 0xf3, 0x00, 0x2a, 0x64, 0xa6, 0x86,
> -	0x8c, 0xcf, 0xb8, 0xf1, 0xa8, 0xf2, 0x89, 0x00
> -};
> -
> -static const struct qm1d1c0042_config default_cfg = {
> -	.xtal_freq = 16000,
> -	.lpf = 1,
> -	.fast_srch = 0,
> -	.lpf_wait = 20,
> -	.fast_srch_wait = 4,
> -	.normal_srch_wait = 15,
> -};
> -
> -struct qm1d1c0042_state {
> -	struct qm1d1c0042_config cfg;
> -	struct i2c_client *i2c;
> -	u8 regs[QM1D1C0042_NUM_REGS];
> -};
> -
> -static struct qm1d1c0042_state *cfg_to_state(struct qm1d1c0042_config *c)
> -{
> -	return container_of(c, struct qm1d1c0042_state, cfg);
> -}
> -
> -static int reg_write(struct qm1d1c0042_state *state, u8 reg, u8 val)
> -{
> -	u8 wbuf[2] = { reg, val };
> -	int ret;
> -
> -	ret = i2c_master_send(state->i2c, wbuf, sizeof(wbuf));
> -	if (ret >= 0 && ret < sizeof(wbuf))
> -		ret = -EIO;
> -	return (ret == sizeof(wbuf)) ? 0 : ret;
> -}
> -
> -static int reg_read(struct qm1d1c0042_state *state, u8 reg, u8 *val)
> -{
> -	struct i2c_msg msgs[2] = {
> -		{
> -			.addr = state->i2c->addr,
> -			.flags = 0,
> -			.buf = &reg,
> -			.len = 1,
> -		},
> -		{
> -			.addr = state->i2c->addr,
> -			.flags = I2C_M_RD,
> -			.buf = val,
> -			.len = 1,
> -		},
> -	};
> -	int ret;
> -
> -	ret = i2c_transfer(state->i2c->adapter, msgs, ARRAY_SIZE(msgs));
> -	if (ret >= 0 && ret < ARRAY_SIZE(msgs))
> -		ret = -EIO;
> -	return (ret == ARRAY_SIZE(msgs)) ? 0 : ret;
> -}
> -
> -
> -static int qm1d1c0042_set_srch_mode(struct qm1d1c0042_state *state, bool fast)
> -{
> -	if (fast)
> -		state->regs[0x03] |= 0x01; /* set fast search mode */
> -	else
> -		state->regs[0x03] &= ~0x01 & 0xff;
> -
> -	return reg_write(state, 0x03, state->regs[0x03]);
> -}
> -
> -static int qm1d1c0042_wakeup(struct qm1d1c0042_state *state)
> -{
> -	int ret;
> -
> -	state->regs[0x01] |= 1 << 3;             /* BB_Reg_enable */
> -	state->regs[0x01] &= (~(1 << 0)) & 0xff; /* NORMAL (wake-up) */
> -	state->regs[0x05] &= (~(1 << 3)) & 0xff; /* pfd_rst NORMAL */
> -	ret = reg_write(state, 0x01, state->regs[0x01]);
> -	if (ret == 0)
> -		ret = reg_write(state, 0x05, state->regs[0x05]);
> -
> -	if (ret < 0)
> -		dev_warn(&state->i2c->dev, "(%s) failed. [adap%d-fe%d]\n",
> -			__func__, state->cfg.fe->dvb->num, state->cfg.fe->id);
> -	return ret;
> -}
> -
> -/* tuner_ops */
> -
> -static int qm1d1c0042_set_config(struct dvb_frontend *fe, void *priv_cfg)
> -{
> -	struct qm1d1c0042_state *state;
> -	struct qm1d1c0042_config *cfg;
> -
> -	state = fe->tuner_priv;
> -	cfg = priv_cfg;
> -
> -	if (cfg->fe)
> -		state->cfg.fe = cfg->fe;
> -
> -	if (cfg->xtal_freq != QM1D1C0042_CFG_XTAL_DFLT)
> -		dev_warn(&state->i2c->dev,
> -			"(%s) changing xtal_freq not supported. ", __func__);
> -	state->cfg.xtal_freq = default_cfg.xtal_freq;
> -
> -	state->cfg.lpf = cfg->lpf;
> -	state->cfg.fast_srch = cfg->fast_srch;
> -
> -	if (cfg->lpf_wait != QM1D1C0042_CFG_WAIT_DFLT)
> -		state->cfg.lpf_wait = cfg->lpf_wait;
> -	else
> -		state->cfg.lpf_wait = default_cfg.lpf_wait;
> -
> -	if (cfg->fast_srch_wait != QM1D1C0042_CFG_WAIT_DFLT)
> -		state->cfg.fast_srch_wait = cfg->fast_srch_wait;
> -	else
> -		state->cfg.fast_srch_wait = default_cfg.fast_srch_wait;
> -
> -	if (cfg->normal_srch_wait != QM1D1C0042_CFG_WAIT_DFLT)
> -		state->cfg.normal_srch_wait = cfg->normal_srch_wait;
> -	else
> -		state->cfg.normal_srch_wait = default_cfg.normal_srch_wait;
> -	return 0;
> -}
> -
> -/* divisor, vco_band parameters */
> -/*  {maxfreq,  param1(band?), param2(div?) */
> -static const u32 conv_table[9][3] = {
> -	{ 2151000, 1, 7 },
> -	{ 1950000, 1, 6 },
> -	{ 1800000, 1, 5 },
> -	{ 1600000, 1, 4 },
> -	{ 1450000, 1, 3 },
> -	{ 1250000, 1, 2 },
> -	{ 1200000, 0, 7 },
> -	{  975000, 0, 6 },
> -	{  950000, 0, 0 }
> -};
> -
> -static int qm1d1c0042_set_params(struct dvb_frontend *fe)
> -{
> -	struct qm1d1c0042_state *state;
> -	u32 freq;
> -	int i, ret;
> -	u8 val, mask;
> -	u32 a, sd;
> -	s32 b;
> -
> -	state = fe->tuner_priv;
> -	freq = fe->dtv_property_cache.frequency;
> -
> -	state->regs[0x08] &= 0xf0;
> -	state->regs[0x08] |= 0x09;
> -
> -	state->regs[0x13] &= 0x9f;
> -	state->regs[0x13] |= 0x20;
> -
> -	/* div2/vco_band */
> -	val = state->regs[0x02] & 0x0f;
> -	for (i = 0; i < 8; i++)
> -		if (freq < conv_table[i][0] && freq >= conv_table[i + 1][0]) {
> -			val |= conv_table[i][1] << 7;
> -			val |= conv_table[i][2] << 4;
> -			break;
> -		}
> -	ret = reg_write(state, 0x02, val);
> -	if (ret < 0)
> -		return ret;
> -
> -	a = (freq + state->cfg.xtal_freq / 2) / state->cfg.xtal_freq;
> -
> -	state->regs[0x06] &= 0x40;
> -	state->regs[0x06] |= (a - 12) / 4;
> -	ret = reg_write(state, 0x06, state->regs[0x06]);
> -	if (ret < 0)
> -		return ret;
> -
> -	state->regs[0x07] &= 0xf0;
> -	state->regs[0x07] |= (a - 4 * ((a - 12) / 4 + 1) - 5) & 0x0f;
> -	ret = reg_write(state, 0x07, state->regs[0x07]);
> -	if (ret < 0)
> -		return ret;
> -
> -	/* LPF */
> -	val = state->regs[0x08];
> -	if (state->cfg.lpf) {
> -		/* LPF_CLK, LPF_FC */
> -		val &= 0xf0;
> -		val |= 0x02;
> -	}
> -	ret = reg_write(state, 0x08, val);
> -	if (ret < 0)
> -		return ret;
> -
> -	/*
> -	 * b = (freq / state->cfg.xtal_freq - a) << 20;
> -	 * sd = b          (b >= 0)
> -	 *      1<<22 + b  (b < 0)
> -	 */
> -	b = (s32)div64_s64(((s64) freq) << 20, state->cfg.xtal_freq)
> -			   - (((s64) a) << 20);
> -
> -	if (b >= 0)
> -		sd = b;
> -	else
> -		sd = (1 << 22) + b;
> -
> -	state->regs[0x09] &= 0xc0;
> -	state->regs[0x09] |= (sd >> 16) & 0x3f;
> -	state->regs[0x0a] = (sd >> 8) & 0xff;
> -	state->regs[0x0b] = sd & 0xff;
> -	ret = reg_write(state, 0x09, state->regs[0x09]);
> -	if (ret == 0)
> -		ret = reg_write(state, 0x0a, state->regs[0x0a]);
> -	if (ret == 0)
> -		ret = reg_write(state, 0x0b, state->regs[0x0b]);
> -	if (ret != 0)
> -		return ret;
> -
> -	if (!state->cfg.lpf) {
> -		/* CSEL_Offset */
> -		ret = reg_write(state, 0x13, state->regs[0x13]);
> -		if (ret < 0)
> -			return ret;
> -	}
> -
> -	/* VCO_TM, LPF_TM */
> -	mask = state->cfg.lpf ? 0x3f : 0x7f;
> -	val = state->regs[0x0c] & mask;
> -	ret = reg_write(state, 0x0c, val);
> -	if (ret < 0)
> -		return ret;
> -	usleep_range(2000, 3000);
> -	val = state->regs[0x0c] | ~mask;
> -	ret = reg_write(state, 0x0c, val);
> -	if (ret < 0)
> -		return ret;
> -
> -	if (state->cfg.lpf)
> -		msleep(state->cfg.lpf_wait);
> -	else if (state->regs[0x03] & 0x01)
> -		msleep(state->cfg.fast_srch_wait);
> -	else
> -		msleep(state->cfg.normal_srch_wait);
> -
> -	if (state->cfg.lpf) {
> -		/* LPF_FC */
> -		ret = reg_write(state, 0x08, 0x09);
> -		if (ret < 0)
> -			return ret;
> -
> -		/* CSEL_Offset */
> -		ret = reg_write(state, 0x13, state->regs[0x13]);
> -		if (ret < 0)
> -			return ret;
> -	}
> -	return 0;
> -}
> -
> -static int qm1d1c0042_sleep(struct dvb_frontend *fe)
> -{
> -	struct qm1d1c0042_state *state;
> -	int ret;
> -
> -	state = fe->tuner_priv;
> -	state->regs[0x01] &= (~(1 << 3)) & 0xff; /* BB_Reg_disable */
> -	state->regs[0x01] |= 1 << 0;             /* STDBY */
> -	state->regs[0x05] |= 1 << 3;             /* pfd_rst STANDBY */
> -	ret = reg_write(state, 0x05, state->regs[0x05]);
> -	if (ret == 0)
> -		ret = reg_write(state, 0x01, state->regs[0x01]);
> -	if (ret < 0)
> -		dev_warn(&state->i2c->dev, "(%s) failed. [adap%d-fe%d]\n",
> -			__func__, fe->dvb->num, fe->id);
> -	return ret;
> -}
> -
> -static int qm1d1c0042_init(struct dvb_frontend *fe)
> -{
> -	struct qm1d1c0042_state *state;
> -	u8 val;
> -	int i, ret;
> -
> -	state = fe->tuner_priv;
> -	memcpy(state->regs, reg_initval, sizeof(reg_initval));
> -
> -	reg_write(state, 0x01, 0x0c);
> -	reg_write(state, 0x01, 0x0c);
> -
> -	ret = reg_write(state, 0x01, 0x0c); /* soft reset on */
> -	if (ret < 0)
> -		goto failed;
> -	usleep_range(2000, 3000);
> -
> -	val = state->regs[0x01] | 0x10;
> -	ret = reg_write(state, 0x01, val); /* soft reset off */
> -	if (ret < 0)
> -		goto failed;
> -
> -	/* check ID */
> -	ret = reg_read(state, 0x00, &val);
> -	if (ret < 0 || val != 0x48)
> -		goto failed;
> -	usleep_range(2000, 3000);
> -
> -	state->regs[0x0c] |= 0x40;
> -	ret = reg_write(state, 0x0c, state->regs[0x0c]);
> -	if (ret < 0)
> -		goto failed;
> -	msleep(state->cfg.lpf_wait);
> -
> -	/* set all writable registers */
> -	for (i = 1; i <= 0x0c ; i++) {
> -		ret = reg_write(state, i, state->regs[i]);
> -		if (ret < 0)
> -			goto failed;
> -	}
> -	for (i = 0x11; i < QM1D1C0042_NUM_REGS; i++) {
> -		ret = reg_write(state, i, state->regs[i]);
> -		if (ret < 0)
> -			goto failed;
> -	}
> -
> -	ret = qm1d1c0042_wakeup(state);
> -	if (ret < 0)
> -		goto failed;
> -
> -	ret = qm1d1c0042_set_srch_mode(state, state->cfg.fast_srch);
> -	if (ret < 0)
> -		goto failed;
> -
> -	return ret;
> -
> -failed:
> -	dev_warn(&state->i2c->dev, "(%s) failed. [adap%d-fe%d]\n",
> -		__func__, fe->dvb->num, fe->id);
> -	return ret;
> -}
> -
> -/* I2C driver functions */
> -
> -static const struct dvb_tuner_ops qm1d1c0042_ops = {
> -	.info = {
> -		.name = "Sharp QM1D1C0042",
> -
> -		.frequency_min =  950000,
> -		.frequency_max = 2150000,
> -	},
> -
> -	.init = qm1d1c0042_init,
> -	.sleep = qm1d1c0042_sleep,
> -	.set_config = qm1d1c0042_set_config,
> -	.set_params = qm1d1c0042_set_params,
> -};
> -
> -
> -static int qm1d1c0042_probe(struct i2c_client *client,
> -			    const struct i2c_device_id *id)
> -{
> -	struct qm1d1c0042_state *state;
> -	struct qm1d1c0042_config *cfg;
> -	struct dvb_frontend *fe;
> -
> -	state = kzalloc(sizeof(*state), GFP_KERNEL);
> -	if (!state)
> -		return -ENOMEM;
> -	state->i2c = client;
> -
> -	cfg = client->dev.platform_data;
> -	fe = cfg->fe;
> -	fe->tuner_priv = state;
> -	qm1d1c0042_set_config(fe, cfg);
> -	memcpy(&fe->ops.tuner_ops, &qm1d1c0042_ops, sizeof(qm1d1c0042_ops));
> -
> -	i2c_set_clientdata(client, &state->cfg);
> -	dev_info(&client->dev, "Sharp QM1D1C0042 attached.\n");
> -	return 0;
> -}
> -
> -static int qm1d1c0042_remove(struct i2c_client *client)
> -{
> -	struct qm1d1c0042_state *state;
> -
> -	state = cfg_to_state(i2c_get_clientdata(client));
> -	state->cfg.fe->tuner_priv = NULL;
> -	kfree(state);
> -	return 0;
> -}
> -
> -
> -static const struct i2c_device_id qm1d1c0042_id[] = {
> -	{"qm1d1c0042", 0},
> -	{}
> -};
> -MODULE_DEVICE_TABLE(i2c, qm1d1c0042_id);
> -
> -static struct i2c_driver qm1d1c0042_driver = {
> -	.driver = {
> -		.name	= "qm1d1c0042",
> -	},
> -	.probe		= qm1d1c0042_probe,
> -	.remove		= qm1d1c0042_remove,
> -	.id_table	= qm1d1c0042_id,
> -};
> -
> -module_i2c_driver(qm1d1c0042_driver);
> -
> -MODULE_DESCRIPTION("Sharp QM1D1C0042 tuner");
> -MODULE_AUTHOR("Akihiro TSUKADA");
> -MODULE_LICENSE("GPL");
> diff --git a/drivers/media/tuners/qm1d1c0042.h b/drivers/media/tuners/qm1d1c0042.h
> deleted file mode 100644
> index 4f5c188..0000000
> --- a/drivers/media/tuners/qm1d1c0042.h
> +++ /dev/null
> @@ -1,37 +0,0 @@
> -/*
> - * Sharp QM1D1C0042 8PSK tuner driver
> - *
> - * Copyright (C) 2014 Akihiro Tsukada <tskd08@gmail.com>
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation version 2.
> - *
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - */
> -
> -#ifndef QM1D1C0042_H
> -#define QM1D1C0042_H
> -
> -#include "dvb_frontend.h"
> -
> -
> -struct qm1d1c0042_config {
> -	struct dvb_frontend *fe;
> -
> -	u32  xtal_freq;    /* [kHz] */ /* currently ignored */
> -	bool lpf;          /* enable LPF */
> -	bool fast_srch;    /* enable fast search mode, no LPF */
> -	u32  lpf_wait;         /* wait in tuning with LPF enabled. [ms] */
> -	u32  fast_srch_wait;   /* with fast-search mode, no LPF. [ms] */
> -	u32  normal_srch_wait; /* with no LPF/fast-search mode. [ms] */
> -};
> -/* special values indicating to use the default in qm1d1c0042_config */
> -#define QM1D1C0042_CFG_XTAL_DFLT 0
> -#define QM1D1C0042_CFG_WAIT_DFLT 0
> -
> -#endif /* QM1D1C0042_H */


-- 

Cheers,
Mauro
