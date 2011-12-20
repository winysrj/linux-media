Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26088 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751801Ab1LTNjW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Dec 2011 08:39:22 -0500
Message-ID: <4EF08FFC.2070802@redhat.com>
Date: Tue, 20 Dec 2011 11:39:08 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org
Subject: Re: [GIT PULL FOR 3.3] HDIC HD29L2 DMB-TH demodulator driver
References: <4EE929D5.6010106@iki.fi>
In-Reply-To: <4EE929D5.6010106@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 14-12-2011 20:57, Antti Palosaari wrote:
> Mauro,
> 
> Please PULL that new driver to the Kernel 3.3!
> 
> Antti
> 
> The following changes since commit 6dbc13e364ad49deb9dd93c4ab84af53ffb52435:
> 
>   mxl5007t: implement .get_if_frequency() (2011-10-10 00:57:07 +0300)
> 
> are available in the git repository at:
>   git://linuxtv.org/anttip/media_tree.git hdic
> 
> Antti Palosaari (1):
>       HDIC HD29L2 DMB-TH demodulator driver

> From: Antti Palosaari <crope@iki.fi>
> Date: Mon, 7 Nov 2011 01:01:13 +0200
> Subject: HDIC HD29L2 DMB-TH demodulator driver
> 
> Signed-off-by: Antti Palosaari <crope@iki.fi>
> ---
>  drivers/media/dvb/frontends/Kconfig       |    7 +
>  drivers/media/dvb/frontends/Makefile      |    1 +
>  drivers/media/dvb/frontends/hd29l2.c      |  863 +++++++++++++++++++++++++++++
>  drivers/media/dvb/frontends/hd29l2.h      |   66 +++
>  drivers/media/dvb/frontends/hd29l2_priv.h |  314 +++++++++++
>  5 files changed, 1251 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/media/dvb/frontends/hd29l2.c
>  create mode 100644 drivers/media/dvb/frontends/hd29l2.h
>  create mode 100644 drivers/media/dvb/frontends/hd29l2_priv.h
> 
> diff --git a/drivers/media/dvb/frontends/Kconfig b/drivers/media/dvb/frontends/Kconfig
> index 4a2d2e6..ebb5ed7 100644
> --- a/drivers/media/dvb/frontends/Kconfig
> +++ b/drivers/media/dvb/frontends/Kconfig
> @@ -404,6 +404,13 @@ config DVB_EC100
>  	help
>  	  Say Y when you want to support this frontend.
>  
> +config DVB_HD29L2
> +	tristate "HDIC HD29L2"
> +	depends on DVB_CORE && I2C
> +	default m if DVB_FE_CUSTOMISE
> +	help
> +	  Say Y when you want to support this frontend.
> +
>  config DVB_STV0367
>  	tristate "ST STV0367 based"
>  	depends on DVB_CORE && I2C
> diff --git a/drivers/media/dvb/frontends/Makefile b/drivers/media/dvb/frontends/Makefile
> index f639f67..00a2063 100644
> --- a/drivers/media/dvb/frontends/Makefile
> +++ b/drivers/media/dvb/frontends/Makefile
> @@ -84,6 +84,7 @@ obj-$(CONFIG_DVB_STV090x) += stv090x.o
>  obj-$(CONFIG_DVB_STV6110x) += stv6110x.o
>  obj-$(CONFIG_DVB_ISL6423) += isl6423.o
>  obj-$(CONFIG_DVB_EC100) += ec100.o
> +obj-$(CONFIG_DVB_HD29L2) += hd29l2.o
>  obj-$(CONFIG_DVB_DS3000) += ds3000.o
>  obj-$(CONFIG_DVB_MB86A16) += mb86a16.o
>  obj-$(CONFIG_DVB_MB86A20S) += mb86a20s.o
> diff --git a/drivers/media/dvb/frontends/hd29l2.c b/drivers/media/dvb/frontends/hd29l2.c
> new file mode 100644
> index 0000000..a85ed47
> --- /dev/null
> +++ b/drivers/media/dvb/frontends/hd29l2.c
> @@ -0,0 +1,863 @@
> +/*
> + * HDIC HD29L2 DMB-TH demodulator driver
> + *
> + * Copyright (C) 2011 Metropolia University of Applied Sciences, Electria R&D
> + *
> + * Author: Antti Palosaari <crope@iki.fi>
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
> + *    You should have received a copy of the GNU General Public License
> + *    along with this program; if not, write to the Free Software
> + *    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> + */
> +
> +#include "hd29l2_priv.h"
> +
> +int hd29l2_debug;
> +module_param_named(debug, hd29l2_debug, int, 0644);
> +MODULE_PARM_DESC(debug, "Turn on/off frontend debugging (default:off).");
> +
> +/* write multiple registers */
> +static int hd29l2_wr_regs(struct hd29l2_priv *priv, u8 reg, u8 *val, int len)
> +{
> +	int ret;
> +	u8 buf[2+len];

CodingStyle. It should be, instead: 
	u8 buf[2 + len]

> +	struct i2c_msg msg[1] = {
> +		{
> +			.addr = priv->cfg.i2c_addr,
> +			.flags = 0,
> +			.len = sizeof(buf),
> +			.buf = buf,
> +		}
> +	};
> +
> +	buf[0] = 0x00;
> +	buf[1] = reg;
> +	memcpy(&buf[2], val, len);
> +
> +	ret = i2c_transfer(priv->i2c, msg, 1);
> +	if (ret == 1) {
> +		ret = 0;
> +	} else {
> +		warn("i2c wr failed=%d reg=%02x len=%d", ret, reg, len);
> +		ret = -EREMOTEIO;
> +	}
> +
> +	return ret;
> +}
> +
> +/* read multiple registers */
> +static int hd29l2_rd_regs(struct hd29l2_priv *priv, u8 reg, u8 *val, int len)
> +{
> +	int ret;
> +	u8 buf[2] = { 0x00, reg };
> +	struct i2c_msg msg[2] = {
> +		{
> +			.addr = priv->cfg.i2c_addr,
> +			.flags = 0,
> +			.len = 2,
> +			.buf = buf,
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
> +
> +	return ret;
> +}
> +
> +/* write single register */
> +static int hd29l2_wr_reg(struct hd29l2_priv *priv, u8 reg, u8 val)
> +{
> +	return hd29l2_wr_regs(priv, reg, &val, 1);
> +}
> +
> +/* read single register */
> +static int hd29l2_rd_reg(struct hd29l2_priv *priv, u8 reg, u8 *val)
> +{
> +	return hd29l2_rd_regs(priv, reg, val, 1);
> +}
> +
> +/* write single register with mask */
> +static int hd29l2_wr_reg_mask(struct hd29l2_priv *priv, u8 reg, u8 val, u8 mask)
> +{
> +	int ret;
> +	u8 tmp;
> +
> +	/* no need for read if whole reg is written */
> +	if (mask != 0xff) {
> +		ret = hd29l2_rd_regs(priv, reg, &tmp, 1);
> +		if (ret)
> +			return ret;
> +
> +		val &= mask;
> +		tmp &= ~mask;
> +		val |= tmp;
> +	}
> +
> +	return hd29l2_wr_regs(priv, reg, &val, 1);
> +}
> +
> +/* read single register with mask */
> +int hd29l2_rd_reg_mask(struct hd29l2_priv *priv, u8 reg, u8 *val, u8 mask)
> +{
> +	int ret, i;
> +	u8 tmp;
> +
> +	ret = hd29l2_rd_regs(priv, reg, &tmp, 1);
> +	if (ret)
> +		return ret;
> +
> +	tmp &= mask;
> +
> +	/* find position of the first bit */
> +	for (i = 0; i < 8; i++) {
> +		if ((mask >> i) & 0x01)
> +			break;
> +	}

Don't re-invent the wheel. Instead, please use the existing macros 
for it, defined at linux/bitmap.h. In this case, it should likely
be:
	find_first_bit()

> +	*val = tmp >> i;
> +
> +	return 0;
> +}
> +
> +static int hd29l2_soft_reset(struct hd29l2_priv *priv)
> +{
> +	int ret;
> +	u8 tmp;
> +
> +	ret = hd29l2_rd_reg(priv, 0x26, &tmp);
> +	if (ret)
> +		goto err;
> +
> +	ret = hd29l2_wr_reg(priv, 0x26, 0x0d);
> +	if (ret)
> +		goto err;
> +
> +	usleep_range(10000, 20000);
> +
> +	ret = hd29l2_wr_reg(priv, 0x26, tmp);
> +	if (ret)
> +		goto err;
> +
> +	return 0;
> +err:
> +	dbg("%s: failed=%d", __func__, ret);
> +	return ret;
> +}
> +
> +static int hd29l2_i2c_gate_ctrl(struct dvb_frontend *fe, int enable)
> +{
> +	int ret, i;
> +	struct hd29l2_priv *priv = fe->demodulator_priv;
> +	u8 tmp;
> +
> +	dbg("%s: enable=%d", __func__, enable);
> +
> +	/* set tuner address for demod */
> +	if (!priv->tuner_i2c_addr_programmed && enable) {
> +		/* no need to set tuner address every time, once is enough */
> +		ret = hd29l2_wr_reg(priv, 0x9d, priv->cfg.tuner_i2c_addr << 1);
> +		if (ret)
> +			goto err;
> +
> +		priv->tuner_i2c_addr_programmed = true;
> +	}
> +
> +	/* open / close gate */
> +	ret = hd29l2_wr_reg(priv, 0x9f, enable);
> +	if (ret)
> +		goto err;
> +
> +	/* wait demod ready */
> +	for (i = 10; i; i--) {
> +		ret = hd29l2_rd_reg(priv, 0x9e, &tmp);
> +		if (ret)
> +			goto err;
> +
> +		if (tmp == enable)
> +			break;
> +
> +		usleep_range(5000, 10000);
> +	}
> +
> +	dbg("%s: loop=%d", __func__, i);
> +
> +	return ret;
> +err:
> +	dbg("%s: failed=%d", __func__, ret);
> +	return ret;
> +}
> +
> +static int hd29l2_read_status(struct dvb_frontend *fe, fe_status_t *status)
> +{
> +	int ret;
> +	struct hd29l2_priv *priv = fe->demodulator_priv;
> +	u8 buf[2];
> +
> +	*status = 0;
> +
> +	ret = hd29l2_rd_reg(priv, 0x05, &buf[0]);
> +	if (ret)
> +		goto err;
> +
> +	if (buf[0] & 0x01) {
> +		/* full lock */
> +		*status |= FE_HAS_SIGNAL | FE_HAS_CARRIER | FE_HAS_VITERBI |
> +			FE_HAS_SYNC | FE_HAS_LOCK;
> +	} else {
> +		ret = hd29l2_rd_reg(priv, 0x0d, &buf[1]);
> +		if (ret)
> +			goto err;
> +
> +		if ((buf[1] & 0xfe) == 0x78)
> +			/* partial lock */
> +			*status |= FE_HAS_SIGNAL | FE_HAS_CARRIER |
> +				FE_HAS_VITERBI | FE_HAS_SYNC;
> +	}
> +
> +	priv->fe_status = *status;
> +
> +	return 0;
> +err:
> +	dbg("%s: failed=%d", __func__, ret);
> +	return ret;
> +}
> +
> +static int hd29l2_read_snr(struct dvb_frontend *fe, u16 *snr)
> +{
> +	int ret;
> +	struct hd29l2_priv *priv = fe->demodulator_priv;
> +	u8 buf[2];
> +	u16 tmp;
> +
> +	if (!(priv->fe_status & FE_HAS_LOCK)) {
> +		*snr = 0;
> +		ret = 0;
> +		goto err;
> +	}
> +
> +	ret = hd29l2_rd_regs(priv, 0x0b, buf, 2);
> +	if (ret)
> +		goto err;
> +
> +	tmp = (buf[0] << 8) | buf[1];
> +
> +	/* report SNR in dB * 10 */
> +	#define LOG10_20736_24 72422627 /* log10(20736) << 24 */
> +	if (tmp)
> +		*snr = (LOG10_20736_24 - intlog10(tmp)) / ((1 << 24) / 100);
> +	else
> +		*snr = 0;
> +
> +	return 0;
> +err:
> +	dbg("%s: failed=%d", __func__, ret);
> +	return ret;
> +}
> +
> +static int hd29l2_read_signal_strength(struct dvb_frontend *fe, u16 *strength)
> +{
> +	int ret;
> +	struct hd29l2_priv *priv = fe->demodulator_priv;
> +	u8 buf[2];
> +	u16 tmp;
> +
> +	*strength = 0;
> +
> +	ret = hd29l2_rd_regs(priv, 0xd5, buf, 2);
> +	if (ret)
> +		goto err;
> +
> +	tmp = buf[0] << 8 | buf[1];
> +	tmp = ~tmp & 0x0fff;
> +
> +	/* scale value to 0x0000-0xffff from 0x0000-0x0fff */
> +	*strength = tmp * 0xffff / 0x0fff;
> +
> +	return 0;
> +err:
> +	dbg("%s: failed=%d", __func__, ret);
> +	return ret;
> +}
> +
> +static int hd29l2_read_ber(struct dvb_frontend *fe, u32 *ber)
> +{
> +	int ret;
> +	struct hd29l2_priv *priv = fe->demodulator_priv;
> +	u8 buf[2];
> +
> +	if (!(priv->fe_status & FE_HAS_SYNC)) {
> +		*ber = 0;
> +		ret = 0;
> +		goto err;
> +	}
> +
> +	ret = hd29l2_rd_regs(priv, 0xd9, buf, 2);
> +	if (ret) {
> +		*ber = 0;
> +		goto err;
> +	}
> +
> +	/* LDPC BER */
> +	*ber = ((buf[0] & 0x0f) << 8) | buf[1];
> +
> +	return 0;
> +err:
> +	dbg("%s: failed=%d", __func__, ret);
> +	return ret;
> +}
> +
> +static int hd29l2_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
> +{
> +	/* no way to read? */
> +	*ucblocks = 0;
> +	return 0;
> +}
> +
> +static enum dvbfe_search hd29l2_search(struct dvb_frontend *fe,
> +	struct dvb_frontend_parameters *p)
> +{
> +	int ret, i;
> +	struct hd29l2_priv *priv = fe->demodulator_priv;
> +	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
> +	u8 tmp, buf[3];
> +	u8 modulation, carrier, guard_interval, interleave, code_rate;
> +	u64 num64;
> +	u32 if_freq, if_ctl;
> +	bool auto_mode;
> +
> +	dbg("%s: delivery_system=%d frequency=%d bandwidth_hz=%d " \
> +		"modulation=%d inversion=%d fec_inner=%d guard_interval=%d",
> +		 __func__,
> +		c->delivery_system, c->frequency, c->bandwidth_hz,
> +		c->modulation, c->inversion, c->fec_inner, c->guard_interval);
> +
> +	/* as for now we detect always params automatically */
> +	auto_mode = true;
> +
> +	/* program tuner */
> +	if (fe->ops.tuner_ops.set_params)
> +		fe->ops.tuner_ops.set_params(fe, p);
> +
> +	/* get and program IF */
> +	if (fe->ops.tuner_ops.get_if_frequency)
> +		fe->ops.tuner_ops.get_if_frequency(fe, &if_freq);
> +	else
> +		if_freq = 0;
> +
> +	if (if_freq) {
> +		/* normal IF */
> +
> +		/* calc IF control value */
> +		num64 = if_freq;
> +		num64 *= 0x800000;
> +		num64 = div_u64(num64, HD29L2_XTAL);
> +		num64 -= 0x800000;
> +		if_ctl = num64;
> +
> +		tmp = 0xfc; /* tuner type normal */
> +	} else {
> +		/* zero IF */
> +		if_ctl = 0;
> +		tmp = 0xfe; /* tuner type Zero-IF */
> +	}
> +
> +	buf[0] = ((if_ctl >>  0) & 0xff);
> +	buf[1] = ((if_ctl >>  8) & 0xff);
> +	buf[2] = ((if_ctl >> 16) & 0xff);
> +
> +	/* program IF control */
> +	ret = hd29l2_wr_regs(priv, 0x14, buf, 3);
> +	if (ret)
> +		goto err;
> +
> +	/* program tuner type */
> +	ret = hd29l2_wr_reg(priv, 0xab, tmp);
> +	if (ret)
> +		goto err;
> +
> +	dbg("%s: if_ctl=%x", __func__, if_ctl);
> +
> +	if (auto_mode) {
> +		/*
> +		 * use auto mode
> +		 */
> +
> +		/* disable quick mode */
> +		ret = hd29l2_wr_reg_mask(priv, 0xac, 0 << 7, 0x80);
> +		if (ret)
> +			goto err;
> +
> +		ret = hd29l2_wr_reg_mask(priv, 0x82, 1 << 1, 0x02);
> +		if (ret)
> +			goto err;
> +
> +		/* enable auto mode */
> +		ret = hd29l2_wr_reg_mask(priv, 0x7d, 1 << 6, 0x40);
> +		if (ret)
> +			goto err;
> +
> +		ret = hd29l2_wr_reg_mask(priv, 0x81, 1 << 3, 0x08);
> +		if (ret)
> +			goto err;
> +
> +		/* soft reset */
> +		ret = hd29l2_soft_reset(priv);
> +		if (ret)
> +			goto err;
> +
> +		/* detect modulation */
> +		for (i = 30; i; i--) {
> +			msleep(100);
> +
> +			ret = hd29l2_rd_reg(priv, 0x0d, &tmp);
> +			if (ret)
> +				goto err;
> +
> +			if ((((tmp & 0xf0) >= 0x10) &&
> +				((tmp & 0x0f) == 0x08)) || (tmp >= 0x2c))
> +				break;
> +		}
> +
> +		dbg("%s: loop=%d", __func__, i);
> +
> +		if (i == 0)
> +			/* detection failed */
> +			return DVBFE_ALGO_SEARCH_FAILED;
> +
> +		/* read modulation */
> +		ret = hd29l2_rd_reg_mask(priv, 0x7d, &modulation, 0x07);
> +		if (ret)
> +			goto err;
> +	} else {
> +		/*
> +		 * use manual mode
> +		 */
> +
> +		modulation = HD29L2_QAM64;
> +		carrier = HD29L2_CARRIER_MULTI;
> +		guard_interval = HD29L2_PN945;
> +		interleave = HD29L2_INTERLEAVER_420;
> +		code_rate = HD29L2_CODE_RATE_08;

Hmm... all DMB-TH properties are already available at the DVB
core? It would be great if you could document what properties are
valid for this delivery system at the DocBook specs.

> +
> +		tmp = (code_rate << 3) | modulation;
> +		ret = hd29l2_wr_reg_mask(priv, 0x7d, tmp, 0x5f);
> +		if (ret)
> +			goto err;
> +
> +		tmp = (carrier << 2) | guard_interval;
> +		ret = hd29l2_wr_reg_mask(priv, 0x81, tmp, 0x0f);
> +		if (ret)
> +			goto err;
> +
> +		tmp = interleave;
> +		ret = hd29l2_wr_reg_mask(priv, 0x82, tmp, 0x03);
> +		if (ret)
> +			goto err;
> +	}
> +
> +	/* ensure modulation validy */
> +	/* 0=QAM4_NR, 1=QAM4, 2=QAM16, 3=QAM32, 4=QAM64 */
> +	if (modulation > 4) {

Please, don't use magic values.

Instead, it should be something like:
	ARRAY_SIZE(reg_mod_vals_tab[0].val)

Still, I don't understand why modulation should be QAM64 when the
auto_mode is disabled. Shouldn't it be provided via a DVB property?

> +		dbg("%s: modulation=%d not valid", __func__, modulation);
> +		goto err;
> +	}
> +
> +	/* program registers according to modulation */
> +	for (i = 0; i < ARRAY_SIZE(reg_mod_vals_tab); i++) {
> +		ret = hd29l2_wr_reg(priv, reg_mod_vals_tab[i].reg,
> +			reg_mod_vals_tab[i].val[modulation]);
> +		if (ret)
> +			goto err;
> +	}
> +
> +	/* read guard interval */
> +	ret = hd29l2_rd_reg_mask(priv, 0x81, &guard_interval, 0x03);
> +	if (ret)
> +		goto err;
> +
> +	/* read carrier mode */
> +	ret = hd29l2_rd_reg_mask(priv, 0x81, &carrier, 0x04);
> +	if (ret)
> +		goto err;
> +
> +	dbg("%s: modulation=%d guard_interval=%d carrier=%d",
> +		__func__, modulation, guard_interval, carrier);
> +
> +	if ((carrier == HD29L2_CARRIER_MULTI) && (modulation == HD29L2_QAM64) &&
> +		(guard_interval == HD29L2_PN945)) {
> +		dbg("%s: C=3780 && QAM64 && PN945", __func__);
> +
> +		ret = hd29l2_wr_reg(priv, 0x42, 0x33);
> +		if (ret)
> +			goto err;
> +
> +		ret = hd29l2_wr_reg(priv, 0xdd, 0x01);
> +		if (ret)
> +			goto err;
> +	}
> +
> +	usleep_range(10000, 20000);
> +
> +	/* soft reset */
> +	ret = hd29l2_soft_reset(priv);
> +	if (ret)
> +		goto err;
> +
> +	/* wait demod lock */
> +	for (i = 30; i; i--) {
> +		msleep(100);
> +
> +		/* read lock bit */
> +		ret = hd29l2_rd_reg_mask(priv, 0x05, &tmp, 0x01);
> +		if (ret)
> +			goto err;
> +
> +		if (tmp)
> +			break;
> +	}
> +
> +	dbg("%s: loop=%d", __func__, i);
> +
> +	if (i == 0)
> +		return DVBFE_ALGO_SEARCH_AGAIN;
> +
> +	return DVBFE_ALGO_SEARCH_SUCCESS;
> +err:
> +	dbg("%s: failed=%d", __func__, ret);
> +	return DVBFE_ALGO_SEARCH_ERROR;
> +}
> +
> +static int hd29l2_get_frontend_algo(struct dvb_frontend *fe)
> +{
> +	return DVBFE_ALGO_CUSTOM;
> +}
> +
> +static int hd29l2_get_frontend(struct dvb_frontend *fe,
> +	struct dvb_frontend_parameters *p)
> +{
> +	int ret;
> +	struct hd29l2_priv *priv = fe->demodulator_priv;
> +	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
> +	u8 buf[3];
> +	u32 if_ctl;
> +	char *str_constellation, *str_code_rate, *str_constellation_code_rate,
> +		*str_guard_interval, *str_carrier, *str_guard_interval_carrier,
> +		*str_interleave, *str_interleave_;
> +
> +	ret = hd29l2_rd_reg(priv, 0x7d, &buf[0]);
> +	if (ret)
> +		goto err;
> +
> +	ret = hd29l2_rd_regs(priv, 0x81, &buf[1], 2);
> +	if (ret)
> +		goto err;
> +
> +	/* constellation, 0x7d[2:0] */
> +	switch ((buf[0] >> 0) & 0x07) {
> +	case 0: /* QAM4NR */
> +		str_constellation = "QAM4NR";
> +		c->modulation = QAM_AUTO; /* FIXME */

Please, don't abuse QAM_AUTO.

> +		break;
> +	case 1: /* QAM4 */
> +		str_constellation = "QAM4";
> +		c->modulation = QPSK; /* FIXME */

QPSK and QAM4 are two names for the same encoding.

> +		break;
> +	case 2:
> +		str_constellation = "QAM16";
> +		c->modulation = QAM_16;
> +		break;
> +	case 3:
> +		str_constellation = "QAM32";
> +		c->modulation = QAM_32;
> +		break;
> +	case 4:
> +		str_constellation = "QAM64";
> +		c->modulation = QAM_64;
> +		break;

Please, avoid magic numbers. Instead, use macros for each
value.

> +	default:
> +		str_constellation = "?";
> +	}
> +
> +	/* LDPC code rate, 0x7d[4:3] */
> +	switch ((buf[0] >> 3) & 0x03) {
> +	case 0: /* 0.4 */
> +		str_code_rate = "0.4";
> +		c->fec_inner = FEC_AUTO; /* FIXME */

Also, please don't abuse FEC_AUTO. Should likely
be FEC_2_5, and you'll likely need to add it to the
API.

> +		break;
> +	case 1: /* 0.6 */
> +		str_code_rate = "0.6";
> +		c->fec_inner = FEC_3_5;
> +		break;
> +	case 2: /* 0.8 */
> +		str_code_rate = "0.8";
> +		c->fec_inner = FEC_4_5;
> +		break;
> +	default:
> +		str_code_rate = "?";
> +	}
> +
> +	/* constellation & code rate set, 0x7d[6] */
> +	switch ((buf[0] >> 6) & 0x01) {
> +	case 0:
> +		str_constellation_code_rate = "manual";
> +		break;
> +	case 1:
> +		str_constellation_code_rate = "auto";
> +		break;
> +	default:
> +		str_constellation_code_rate = "?";
> +	}
> +
> +	/* frame header, 0x81[1:0] */
> +	switch ((buf[1] >> 0) & 0x03) {
> +	case 0: /* PN945 */
> +		str_guard_interval = "PN945";
> +		c->guard_interval = GUARD_INTERVAL_AUTO; /* FIXME */
> +		break;
> +	case 1: /* PN595 */
> +		str_guard_interval = "PN595";
> +		c->guard_interval = GUARD_INTERVAL_AUTO; /* FIXME */
> +		break;
> +	case 2: /* PN420 */
> +		str_guard_interval = "PN420";
> +		c->guard_interval = GUARD_INTERVAL_AUTO; /* FIXME */
> +		break;

Again, don't abuse over the API. Instead, add the proper guard
intervals into it.

> +	default:
> +		str_guard_interval = "?";
> +	}
> +
> +	/* carrier, 0x81[2] */
> +	switch ((buf[1] >> 2) & 0x01) {
> +	case 0:
> +		str_carrier = "C=1";
> +		break;
> +	case 1:
> +		str_carrier = "C=3780";
> +		break;
> +	default:
> +		str_carrier = "?";
> +	}

Probably, API needs to support it. I'm not familiar with DMB specs,
but I think you need to first send a patch adding support for it at
the DocBook and linux/dvb/frontends.h, and then add the driver.

> +
> +	/* frame header & carrier set, 0x81[3] */
> +	switch ((buf[1] >> 3) & 0x01) {
> +	case 0:
> +		str_guard_interval_carrier = "manual";
> +		break;
> +	case 1:
> +		str_guard_interval_carrier = "auto";
> +		break;
> +	default:
> +		str_guard_interval_carrier = "?";
> +	}
> +
> +	/* interleave, 0x82[0] */
> +	switch ((buf[2] >> 0) & 0x01) {
> +	case 0:
> +		str_interleave = "M=720";
> +		break;
> +	case 1:
> +		str_interleave = "M=240";
> +		break;
> +	default:
> +		str_interleave = "?";
> +	}
> +
> +	/* interleave set, 0x82[1] */
> +	switch ((buf[2] >> 1) & 0x01) {
> +	case 0:
> +		str_interleave_ = "manual";
> +		break;
> +	case 1:
> +		str_interleave_ = "auto";
> +		break;
> +	default:
> +		str_interleave_ = "?";
> +	}
> +
> +	/*
> +	 * We can read out current detected NCO and use that value next
> +	 * time instead of calculating new value from targed IF.
> +	 * I think it will not effect receiver sensitivity but gaining lock
> +	 * after tune could be easier...
> +	 */
> +	ret = hd29l2_rd_regs(priv, 0xb1, &buf[0], 3);
> +	if (ret)
> +		goto err;
> +
> +	if_ctl = (buf[0] << 16) | ((buf[1] - 7) << 8) | buf[2];
> +
> +	dbg("%s: %s %s %s | %s %s %s | %s %s | NCO=%06x", __func__,
> +		str_constellation, str_code_rate, str_constellation_code_rate,
> +		str_guard_interval, str_carrier, str_guard_interval_carrier,
> +		str_interleave, str_interleave_, if_ctl);
> +
> +	return 0;
> +err:
> +	dbg("%s: failed=%d", __func__, ret);
> +	return ret;
> +}
> +
> +static int hd29l2_init(struct dvb_frontend *fe)
> +{
> +	int ret, i;
> +	struct hd29l2_priv *priv = fe->demodulator_priv;
> +	u8 tmp;
> +	static const struct reg_val tab[] = {
> +		{ 0x3a, 0x06 },
> +		{ 0x3b, 0x03 },
> +		{ 0x3c, 0x04 },
> +		{ 0xaf, 0x06 },
> +		{ 0xb0, 0x1b },
> +		{ 0x80, 0x64 },
> +		{ 0x10, 0x38 },
> +	};
> +
> +	dbg("%s:", __func__);
> +
> +	/* reset demod */
> +	/* it is recommended to HW reset chip using RST_N pin */
> +	if (fe->callback) {
> +		ret = fe->callback(fe, 0, 0, 0);

This looks weird on my eyes. The fe->callback is tuner-dependent.
So, the command you should use there requires a test for the tuner
type.

In other words, if you're needing to use it, the code should be doing 
something similar to:

        if (fe->callback && priv->tuner_type == TUNER_XC2028)
		ret = fe->callback(fe, 0, XC2028_TUNER_RESET, 0);

(the actual coding will depend on how do you store the tuner type, and
what are the commands for the tuner you're using)

That's said, it probably makes sense to deprecate fe->callback in favor
or a more generic set of callbacks, like fe->tuner_reset().

> +		if (ret)
> +			goto err;
> +
> +		/* reprogramming needed because HW reset clears registers */
> +		priv->tuner_i2c_addr_programmed = false;
> +	}
> +
> +	/* init */
> +	for (i = 0; i < ARRAY_SIZE(tab); i++) {
> +		ret = hd29l2_wr_reg(priv, tab[i].reg, tab[i].val);
> +		if (ret)
> +			goto err;
> +	}
> +
> +	/* TS params */
> +	ret = hd29l2_rd_reg(priv, 0x36, &tmp);
> +	if (ret)
> +		goto err;
> +
> +	tmp &= 0x1b;
> +	tmp |= priv->cfg.ts_mode;
> +	ret = hd29l2_wr_reg(priv, 0x36, tmp);
> +	if (ret)
> +		goto err;
> +
> +	ret = hd29l2_rd_reg(priv, 0x31, &tmp);
> +	tmp &= 0xef;
> +
> +	if (!(priv->cfg.ts_mode >> 7))
> +		/* set b4 for serial TS */
> +		tmp |= 0x10;
> +
> +	ret = hd29l2_wr_reg(priv, 0x31, tmp);
> +	if (ret)
> +		goto err;
> +
> +	return ret;
> +err:
> +	dbg("%s: failed=%d", __func__, ret);
> +	return ret;
> +}
> +
> +static void hd29l2_release(struct dvb_frontend *fe)
> +{
> +	struct hd29l2_priv *priv = fe->demodulator_priv;
> +	kfree(priv);
> +}
> +
> +static struct dvb_frontend_ops hd29l2_ops;
> +
> +struct dvb_frontend *hd29l2_attach(const struct hd29l2_config *config,
> +	struct i2c_adapter *i2c)
> +{
> +	int ret;
> +	struct hd29l2_priv *priv = NULL;
> +	u8 tmp;
> +
> +	/* allocate memory for the internal state */
> +	priv = kzalloc(sizeof(struct hd29l2_priv), GFP_KERNEL);
> +	if (priv == NULL)
> +		goto err;
> +
> +	/* setup the state */
> +	priv->i2c = i2c;
> +	memcpy(&priv->cfg, config, sizeof(struct hd29l2_config));
> +
> +
> +	/* check if the demod is there */
> +	ret = hd29l2_rd_reg(priv, 0x00, &tmp);
> +	if (ret)
> +		goto err;
> +
> +	/* create dvb_frontend */
> +	memcpy(&priv->fe.ops, &hd29l2_ops, sizeof(struct dvb_frontend_ops));
> +	priv->fe.demodulator_priv = priv;
> +
> +	return &priv->fe;
> +err:
> +	kfree(priv);
> +	return NULL;
> +}
> +EXPORT_SYMBOL(hd29l2_attach);
> +
> +static struct dvb_frontend_ops hd29l2_ops = {
> +	.info = {
> +		.name = "HDIC HD29L2 DMB-TH",
> +		.type = FE_OFDM,
> +		.frequency_min = 474000000,
> +		.frequency_max = 858000000,
> +		.frequency_stepsize = 10000,
> +		.caps = FE_CAN_FEC_AUTO |
> +			FE_CAN_QPSK |
> +			FE_CAN_QAM_16 |
> +			FE_CAN_QAM_32 |
> +			FE_CAN_QAM_64 |
> +			FE_CAN_QAM_AUTO |
> +			FE_CAN_TRANSMISSION_MODE_AUTO |
> +			FE_CAN_BANDWIDTH_AUTO |
> +			FE_CAN_GUARD_INTERVAL_AUTO |
> +			FE_CAN_HIERARCHY_AUTO |
> +			FE_CAN_RECOVER
> +	},
> +
> +	.release = hd29l2_release,
> +
> +	.init = hd29l2_init,
> +
> +	.get_frontend_algo = hd29l2_get_frontend_algo,
> +	.search = hd29l2_search,
> +	.get_frontend = hd29l2_get_frontend,
> +
> +	.read_status = hd29l2_read_status,
> +	.read_snr = hd29l2_read_snr,
> +	.read_signal_strength = hd29l2_read_signal_strength,
> +	.read_ber = hd29l2_read_ber,
> +	.read_ucblocks = hd29l2_read_ucblocks,
> +
> +	.i2c_gate_ctrl = hd29l2_i2c_gate_ctrl,
> +};
> +
> +MODULE_AUTHOR("Antti Palosaari <crope@iki.fi>");
> +MODULE_DESCRIPTION("HDIC HD29L2 DMB-TH demodulator driver");
> +MODULE_LICENSE("GPL");
> diff --git a/drivers/media/dvb/frontends/hd29l2.h b/drivers/media/dvb/frontends/hd29l2.h
> new file mode 100644
> index 0000000..a7a6443
> --- /dev/null
> +++ b/drivers/media/dvb/frontends/hd29l2.h
> @@ -0,0 +1,66 @@
> +/*
> + * HDIC HD29L2 DMB-TH demodulator driver
> + *
> + * Copyright (C) 2011 Metropolia University of Applied Sciences, Electria R&D
> + *
> + * Author: Antti Palosaari <crope@iki.fi>
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
> + *    You should have received a copy of the GNU General Public License
> + *    along with this program; if not, write to the Free Software
> + *    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> + */
> +
> +#ifndef HD29L2_H
> +#define HD29L2_H
> +
> +#include <linux/dvb/frontend.h>
> +
> +struct hd29l2_config {
> +	/*
> +	 * demodulator I2C address
> +	 */
> +	u8 i2c_addr;
> +
> +	/*
> +	 * tuner I2C address
> +	 * only needed when tuner is behind demod I2C-gate
> +	 */
> +	u8 tuner_i2c_addr;
> +
> +	/*
> +	 * TS settings
> +	 */
> +#define HD29L2_TS_SERIAL            0x00
> +#define HD29L2_TS_PARALLEL          0x80
> +#define HD29L2_TS_CLK_NORMAL        0x40
> +#define HD29L2_TS_CLK_INVERTED      0x00
> +#define HD29L2_TS_CLK_GATED         0x20
> +#define HD29L2_TS_CLK_FREE          0x00
> +	u8 ts_mode;
> +};
> +
> +
> +#if defined(CONFIG_DVB_HD29L2) || \
> +	(defined(CONFIG_DVB_HD29L2_MODULE) && defined(MODULE))
> +extern struct dvb_frontend *hd29l2_attach(const struct hd29l2_config *config,
> +	struct i2c_adapter *i2c);
> +#else
> +static inline struct dvb_frontend *hd29l2_attach(
> +const struct hd29l2_config *config, struct i2c_adapter *i2c)
> +{
> +	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
> +	return NULL;
> +}
> +#endif
> +
> +#endif /* HD29L2_H */
> diff --git a/drivers/media/dvb/frontends/hd29l2_priv.h b/drivers/media/dvb/frontends/hd29l2_priv.h
> new file mode 100644
> index 0000000..ba16dc3
> --- /dev/null
> +++ b/drivers/media/dvb/frontends/hd29l2_priv.h
> @@ -0,0 +1,314 @@
> +/*
> + * HDIC HD29L2 DMB-TH demodulator driver
> + *
> + * Copyright (C) 2011 Metropolia University of Applied Sciences, Electria R&D
> + *
> + * Author: Antti Palosaari <crope@iki.fi>
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
> + *    You should have received a copy of the GNU General Public License
> + *    along with this program; if not, write to the Free Software
> + *    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> + */
> +
> +#ifndef HD29L2_PRIV
> +#define HD29L2_PRIV
> +
> +#include <linux/dvb/version.h>
> +#include "dvb_frontend.h"
> +#include "dvb_math.h"
> +#include "hd29l2.h"
> +
> +#define LOG_PREFIX "hd29l2"
> +
> +#undef dbg
> +#define dbg(f, arg...) \
> +	if (hd29l2_debug) \
> +		printk(KERN_INFO   LOG_PREFIX": " f "\n" , ## arg)
> +#undef err
> +#define err(f, arg...)  printk(KERN_ERR     LOG_PREFIX": " f "\n" , ## arg)
> +#undef info
> +#define info(f, arg...) printk(KERN_INFO    LOG_PREFIX": " f "\n" , ## arg)
> +#undef warn
> +#define warn(f, arg...) printk(KERN_WARNING LOG_PREFIX": " f "\n" , ## arg)
> +
> +#define HD29L2_XTAL 30400000 /* Hz */
> +
> +
> +#define HD29L2_QAM4NR 0x00
> +#define HD29L2_QAM4   0x01
> +#define HD29L2_QAM16  0x02
> +#define HD29L2_QAM32  0x03
> +#define HD29L2_QAM64  0x04
> +
> +#define HD29L2_CODE_RATE_04 0x00
> +#define HD29L2_CODE_RATE_06 0x08
> +#define HD29L2_CODE_RATE_08 0x10
> +
> +#define HD29L2_PN945 0x00
> +#define HD29L2_PN595 0x01
> +#define HD29L2_PN420 0x02
> +
> +#define HD29L2_CARRIER_SINGLE 0x00
> +#define HD29L2_CARRIER_MULTI  0x01
> +
> +#define HD29L2_INTERLEAVER_720 0x00
> +#define HD29L2_INTERLEAVER_420 0x01
> +
> +struct reg_val {
> +	u8 reg;
> +	u8 val;
> +};
> +
> +struct reg_mod_vals {
> +	u8 reg;
> +	u8 val[5];
> +};
> +
> +struct hd29l2_priv {
> +	struct i2c_adapter *i2c;
> +	struct dvb_frontend fe;
> +	struct hd29l2_config cfg;
> +	u8 tuner_i2c_addr_programmed:1;
> +
> +	fe_status_t fe_status;
> +};
> +
> +static const struct reg_mod_vals reg_mod_vals_tab[] = {
> +	/* REG, QAM4NR, QAM4,QAM16,QAM32,QAM64 */
> +	{ 0x01, { 0x10, 0x10, 0x10, 0x10, 0x10 } },
> +	{ 0x02, { 0x07, 0x07, 0x07, 0x07, 0x07 } },
> +	{ 0x03, { 0x10, 0x10, 0x10, 0x10, 0x10 } },
> +	{ 0x04, { 0x00, 0x00, 0x00, 0x00, 0x00 } },
> +	{ 0x05, { 0x61, 0x60, 0x60, 0x61, 0x60 } },
> +	{ 0x06, { 0xff, 0xff, 0xff, 0xff, 0xff } },
> +	{ 0x07, { 0xff, 0xff, 0xff, 0xff, 0xff } },
> +	{ 0x08, { 0x00, 0x00, 0x00, 0x00, 0x00 } },
> +	{ 0x09, { 0x00, 0x00, 0x00, 0x00, 0x00 } },
> +	{ 0x0a, { 0x15, 0x15, 0x03, 0x03, 0x03 } },
> +	{ 0x0d, { 0x78, 0x78, 0x88, 0x78, 0x78 } },
> +	{ 0x0e, { 0xa0, 0x90, 0xa0, 0xa0, 0xa0 } },
> +	{ 0x0f, { 0x00, 0x00, 0x00, 0x00, 0x00 } },
> +	{ 0x10, { 0xa0, 0xa0, 0x58, 0x38, 0x38 } },
> +	{ 0x11, { 0x00, 0x00, 0x00, 0x00, 0x00 } },
> +	{ 0x12, { 0x5a, 0x5a, 0x5a, 0x5a, 0x5a } },
> +	{ 0x13, { 0xa2, 0xa2, 0xa2, 0xa2, 0xa2 } },
> +	{ 0x17, { 0x40, 0x40, 0x40, 0x40, 0x40 } },
> +	{ 0x18, { 0x21, 0x21, 0x42, 0x52, 0x42 } },
> +	{ 0x19, { 0x21, 0x21, 0x62, 0x72, 0x62 } },
> +	{ 0x1a, { 0x32, 0x43, 0xa9, 0xb9, 0xa9 } },
> +	{ 0x1b, { 0x32, 0x43, 0xb9, 0xd8, 0xb9 } },
> +	{ 0x1c, { 0x02, 0x02, 0x03, 0x02, 0x03 } },
> +	{ 0x1d, { 0x0c, 0x0c, 0x01, 0x02, 0x02 } },
> +	{ 0x1e, { 0x02, 0x02, 0x02, 0x01, 0x02 } },
> +	{ 0x1f, { 0x02, 0x02, 0x01, 0x02, 0x04 } },
> +	{ 0x20, { 0x01, 0x02, 0x01, 0x01, 0x01 } },
> +	{ 0x21, { 0x08, 0x08, 0x0a, 0x0a, 0x0a } },
> +	{ 0x22, { 0x06, 0x06, 0x04, 0x05, 0x05 } },
> +	{ 0x23, { 0x06, 0x06, 0x05, 0x03, 0x05 } },
> +	{ 0x24, { 0x08, 0x08, 0x05, 0x07, 0x07 } },
> +	{ 0x25, { 0x16, 0x10, 0x10, 0x0a, 0x10 } },
> +	{ 0x26, { 0x14, 0x14, 0x04, 0x04, 0x04 } },
> +	{ 0x27, { 0x58, 0x58, 0x58, 0x5c, 0x58 } },
> +	{ 0x28, { 0x0a, 0x0a, 0x0a, 0x0a, 0x0a } },
> +	{ 0x29, { 0x0a, 0x0a, 0x0a, 0x0a, 0x0a } },
> +	{ 0x2a, { 0x08, 0x0a, 0x08, 0x08, 0x08 } },
> +	{ 0x2b, { 0x08, 0x08, 0x08, 0x08, 0x08 } },
> +	{ 0x2c, { 0x06, 0x06, 0x06, 0x06, 0x06 } },
> +	{ 0x2d, { 0x05, 0x06, 0x06, 0x06, 0x06 } },
> +	{ 0x2e, { 0x21, 0x21, 0x21, 0x21, 0x21 } },
> +	{ 0x2f, { 0x00, 0x00, 0x00, 0x00, 0x00 } },
> +	{ 0x30, { 0x14, 0x14, 0x14, 0x14, 0x14 } },
> +	{ 0x33, { 0xb7, 0xb7, 0xb7, 0xb7, 0xb7 } },
> +	{ 0x34, { 0x81, 0x81, 0x81, 0x81, 0x81 } },
> +	{ 0x35, { 0x80, 0x80, 0x80, 0x80, 0x80 } },
> +	{ 0x37, { 0x70, 0x70, 0x70, 0x70, 0x70 } },
> +	{ 0x38, { 0x04, 0x04, 0x02, 0x02, 0x02 } },
> +	{ 0x39, { 0x07, 0x07, 0x05, 0x05, 0x05 } },
> +	{ 0x3a, { 0x06, 0x06, 0x06, 0x06, 0x06 } },
> +	{ 0x3b, { 0x03, 0x03, 0x03, 0x03, 0x03 } },
> +	{ 0x3c, { 0x07, 0x06, 0x04, 0x04, 0x04 } },
> +	{ 0x3d, { 0xf0, 0xf0, 0xf0, 0xf0, 0x80 } },
> +	{ 0x3e, { 0x60, 0x60, 0x60, 0x60, 0xff } },
> +	{ 0x3f, { 0x00, 0x00, 0x00, 0x00, 0x00 } },
> +	{ 0x40, { 0x5b, 0x5b, 0x5b, 0x57, 0x50 } },
> +	{ 0x41, { 0x30, 0x30, 0x30, 0x30, 0x18 } },
> +	{ 0x42, { 0x20, 0x20, 0x20, 0x00, 0x30 } },
> +	{ 0x43, { 0x00, 0x00, 0x00, 0x00, 0x00 } },
> +	{ 0x44, { 0x3f, 0x3f, 0x3f, 0x3f, 0x3f } },
> +	{ 0x45, { 0x00, 0x00, 0x00, 0x00, 0x00 } },
> +	{ 0x46, { 0x0a, 0x0a, 0x0a, 0x0a, 0x0a } },
> +	{ 0x47, { 0x00, 0x00, 0x95, 0x00, 0x95 } },
> +	{ 0x48, { 0xc0, 0xc0, 0xc0, 0xc0, 0xc0 } },
> +	{ 0x49, { 0xc0, 0xc0, 0xc0, 0xc0, 0xc0 } },
> +	{ 0x4a, { 0x40, 0x40, 0x33, 0x11, 0x11 } },
> +	{ 0x4b, { 0x40, 0x40, 0x00, 0x00, 0x00 } },
> +	{ 0x4c, { 0x40, 0x40, 0x99, 0x11, 0x11 } },
> +	{ 0x4d, { 0x40, 0x40, 0x00, 0x00, 0x00 } },
> +	{ 0x4e, { 0x40, 0x40, 0x66, 0x77, 0x77 } },
> +	{ 0x4f, { 0x40, 0x40, 0x00, 0x00, 0x00 } },
> +	{ 0x50, { 0x40, 0x40, 0x88, 0x33, 0x11 } },
> +	{ 0x51, { 0x40, 0x40, 0x00, 0x00, 0x00 } },
> +	{ 0x52, { 0x40, 0x40, 0x88, 0x02, 0x02 } },
> +	{ 0x53, { 0x40, 0x40, 0x00, 0x02, 0x02 } },
> +	{ 0x54, { 0x00, 0x00, 0x88, 0x33, 0x33 } },
> +	{ 0x55, { 0x40, 0x40, 0x00, 0x00, 0x00 } },
> +	{ 0x56, { 0x00, 0x00, 0x00, 0x0b, 0x00 } },
> +	{ 0x57, { 0x40, 0x40, 0x0a, 0x0b, 0x0a } },
> +	{ 0x58, { 0xaa, 0x00, 0x00, 0x00, 0x00 } },
> +	{ 0x59, { 0x7a, 0x40, 0x02, 0x02, 0x02 } },
> +	{ 0x5a, { 0x18, 0x18, 0x01, 0x01, 0x01 } },
> +	{ 0x5b, { 0x18, 0x18, 0x01, 0x01, 0x01 } },
> +	{ 0x5c, { 0x18, 0x18, 0x01, 0x01, 0x01 } },
> +	{ 0x5d, { 0x18, 0x18, 0x01, 0x01, 0x01 } },
> +	{ 0x5e, { 0xc0, 0xc0, 0xc0, 0xff, 0xc0 } },
> +	{ 0x5f, { 0xc0, 0xc0, 0xc0, 0xff, 0xc0 } },
> +	{ 0x60, { 0x40, 0x40, 0x00, 0x30, 0x30 } },
> +	{ 0x61, { 0x40, 0x40, 0x10, 0x30, 0x30 } },
> +	{ 0x62, { 0x40, 0x40, 0x00, 0x30, 0x30 } },
> +	{ 0x63, { 0x40, 0x40, 0x05, 0x30, 0x30 } },
> +	{ 0x64, { 0x40, 0x40, 0x06, 0x00, 0x30 } },
> +	{ 0x65, { 0x40, 0x40, 0x06, 0x08, 0x30 } },
> +	{ 0x66, { 0x40, 0x40, 0x00, 0x00, 0x20 } },
> +	{ 0x67, { 0x40, 0x40, 0x01, 0x04, 0x20 } },
> +	{ 0x68, { 0x00, 0x00, 0x30, 0x00, 0x20 } },
> +	{ 0x69, { 0xa0, 0xa0, 0x00, 0x08, 0x20 } },
> +	{ 0x6a, { 0x00, 0x00, 0x30, 0x00, 0x25 } },
> +	{ 0x6b, { 0xa0, 0xa0, 0x00, 0x06, 0x25 } },
> +	{ 0x6c, { 0x00, 0x00, 0x00, 0x00, 0x00 } },
> +	{ 0x6d, { 0xa0, 0x60, 0x0c, 0x03, 0x0c } },
> +	{ 0x6e, { 0x00, 0x00, 0x00, 0x00, 0x00 } },
> +	{ 0x6f, { 0xa0, 0x60, 0x04, 0x01, 0x04 } },
> +	{ 0x70, { 0x58, 0x58, 0xaa, 0xaa, 0xaa } },
> +	{ 0x71, { 0x58, 0x58, 0xaa, 0xaa, 0xaa } },
> +	{ 0x72, { 0x58, 0x58, 0xff, 0xff, 0xff } },
> +	{ 0x73, { 0x58, 0x58, 0xff, 0xff, 0xff } },
> +	{ 0x74, { 0x06, 0x06, 0x09, 0x05, 0x05 } },
> +	{ 0x75, { 0x06, 0x06, 0x0a, 0x10, 0x10 } },
> +	{ 0x76, { 0x10, 0x10, 0x06, 0x0a, 0x0a } },
> +	{ 0x77, { 0x12, 0x18, 0x28, 0x10, 0x28 } },
> +	{ 0x78, { 0xf8, 0xf8, 0xf8, 0xf8, 0xf8 } },
> +	{ 0x79, { 0x15, 0x15, 0x03, 0x03, 0x03 } },
> +	{ 0x7a, { 0x02, 0x02, 0x01, 0x04, 0x03 } },
> +	{ 0x7b, { 0x01, 0x02, 0x03, 0x03, 0x03 } },
> +	{ 0x7c, { 0x28, 0x28, 0x28, 0x28, 0x28 } },
> +	{ 0x7f, { 0x25, 0x92, 0x5f, 0x17, 0x2d } },
> +	{ 0x80, { 0x64, 0x64, 0x64, 0x74, 0x64 } },
> +	{ 0x83, { 0x06, 0x03, 0x04, 0x04, 0x04 } },
> +	{ 0x84, { 0xff, 0xff, 0xff, 0xff, 0xff } },
> +	{ 0x85, { 0x05, 0x05, 0x05, 0x05, 0x05 } },
> +	{ 0x86, { 0x00, 0x00, 0x11, 0x11, 0x11 } },
> +	{ 0x87, { 0x03, 0x03, 0x03, 0x03, 0x03 } },
> +	{ 0x88, { 0x09, 0x09, 0x09, 0x09, 0x09 } },
> +	{ 0x89, { 0x20, 0x20, 0x30, 0x20, 0x20 } },
> +	{ 0x8a, { 0x03, 0x03, 0x02, 0x03, 0x02 } },
> +	{ 0x8b, { 0x00, 0x07, 0x09, 0x00, 0x09 } },
> +	{ 0x8c, { 0x00, 0x00, 0x00, 0x00, 0x00 } },
> +	{ 0x8d, { 0x4f, 0x4f, 0x4f, 0x3f, 0x4f } },
> +	{ 0x8e, { 0xf0, 0xf0, 0x60, 0xf0, 0xa0 } },
> +	{ 0x8f, { 0xe8, 0xe8, 0xe8, 0xe8, 0xe8 } },
> +	{ 0x90, { 0x10, 0x10, 0x10, 0x10, 0x10 } },
> +	{ 0x91, { 0x40, 0x40, 0x70, 0x70, 0x10 } },
> +	{ 0x92, { 0x00, 0x00, 0x00, 0x00, 0x04 } },
> +	{ 0x93, { 0x60, 0x60, 0x60, 0x60, 0x60 } },
> +	{ 0x94, { 0x00, 0x00, 0x00, 0x00, 0x03 } },
> +	{ 0x95, { 0x09, 0x09, 0x47, 0x47, 0x47 } },
> +	{ 0x96, { 0x80, 0xa0, 0xa0, 0x40, 0xa0 } },
> +	{ 0x97, { 0x60, 0x60, 0x60, 0x60, 0x60 } },
> +	{ 0x98, { 0x50, 0x50, 0x50, 0x30, 0x50 } },
> +	{ 0x99, { 0x10, 0x10, 0x10, 0x10, 0x10 } },
> +	{ 0x9a, { 0x00, 0x00, 0x00, 0x00, 0x00 } },
> +	{ 0x9b, { 0x40, 0x40, 0x40, 0x30, 0x40 } },
> +	{ 0x9c, { 0x00, 0x00, 0x00, 0x00, 0x00 } },
> +	{ 0xa0, { 0xf0, 0xf0, 0xf0, 0xf0, 0xf0 } },
> +	{ 0xa1, { 0x00, 0x00, 0x00, 0x00, 0x00 } },
> +	{ 0xa2, { 0x30, 0x30, 0x00, 0x30, 0x00 } },
> +	{ 0xa3, { 0x00, 0x00, 0x00, 0x00, 0x00 } },
> +	{ 0xa4, { 0x00, 0x00, 0x00, 0x00, 0x00 } },
> +	{ 0xa5, { 0x00, 0x00, 0x00, 0x00, 0x00 } },
> +	{ 0xa6, { 0x00, 0x00, 0x00, 0x00, 0x00 } },
> +	{ 0xa7, { 0x00, 0x00, 0x00, 0x00, 0x00 } },
> +	{ 0xa8, { 0x77, 0x77, 0x77, 0x77, 0x77 } },
> +	{ 0xa9, { 0x02, 0x02, 0x02, 0x02, 0x02 } },
> +	{ 0xaa, { 0x40, 0x40, 0x40, 0x40, 0x40 } },
> +	{ 0xac, { 0x1f, 0x1f, 0x1f, 0x1f, 0x1f } },
> +	{ 0xad, { 0x14, 0x14, 0x14, 0x14, 0x14 } },
> +	{ 0xae, { 0x78, 0x78, 0x78, 0x78, 0x78 } },
> +	{ 0xaf, { 0x06, 0x06, 0x06, 0x06, 0x07 } },
> +	{ 0xb0, { 0x1b, 0x1b, 0x1b, 0x19, 0x1b } },
> +	{ 0xb1, { 0x18, 0x17, 0x17, 0x18, 0x17 } },
> +	{ 0xb2, { 0x35, 0x82, 0x82, 0x38, 0x82 } },
> +	{ 0xb3, { 0xb6, 0xce, 0xc7, 0x5c, 0xb0 } },
> +	{ 0xb4, { 0x3f, 0x3e, 0x3e, 0x3f, 0x3e } },
> +	{ 0xb5, { 0x70, 0x58, 0x50, 0x68, 0x50 } },
> +	{ 0xb6, { 0x00, 0x00, 0x00, 0x00, 0x00 } },
> +	{ 0xb7, { 0x00, 0x00, 0x00, 0x00, 0x00 } },
> +	{ 0xb8, { 0x03, 0x03, 0x01, 0x01, 0x01 } },
> +	{ 0xb9, { 0x00, 0x00, 0x00, 0x00, 0x00 } },
> +	{ 0xba, { 0x06, 0x06, 0x0a, 0x05, 0x0a } },
> +	{ 0xbb, { 0x00, 0x00, 0x00, 0x00, 0x00 } },
> +	{ 0xbc, { 0x00, 0x00, 0x00, 0x00, 0x00 } },
> +	{ 0xbd, { 0x00, 0x00, 0x00, 0x00, 0x00 } },
> +	{ 0xbe, { 0x00, 0x00, 0x00, 0x00, 0x00 } },
> +	{ 0xbf, { 0x00, 0x00, 0x00, 0x00, 0x00 } },
> +	{ 0xc0, { 0x00, 0x00, 0x00, 0x00, 0x00 } },
> +	{ 0xc1, { 0x00, 0x00, 0x00, 0x00, 0x00 } },
> +	{ 0xc2, { 0x00, 0x00, 0x00, 0x00, 0x00 } },
> +	{ 0xc3, { 0x00, 0x00, 0x88, 0x66, 0x88 } },
> +	{ 0xc4, { 0x10, 0x10, 0x00, 0x00, 0x00 } },
> +	{ 0xc5, { 0x00, 0x00, 0x44, 0x60, 0x44 } },
> +	{ 0xc6, { 0x10, 0x0a, 0x00, 0x00, 0x00 } },
> +	{ 0xc7, { 0x00, 0x00, 0x00, 0x00, 0x00 } },
> +	{ 0xc8, { 0x00, 0x00, 0x00, 0x00, 0x00 } },
> +	{ 0xc9, { 0x90, 0x04, 0x00, 0x00, 0x00 } },
> +	{ 0xca, { 0x90, 0x08, 0x01, 0x01, 0x01 } },
> +	{ 0xcb, { 0xa0, 0x04, 0x00, 0x44, 0x00 } },
> +	{ 0xcc, { 0xa0, 0x10, 0x03, 0x00, 0x03 } },
> +	{ 0xcd, { 0x06, 0x06, 0x06, 0x05, 0x06 } },
> +	{ 0xce, { 0x05, 0x05, 0x01, 0x01, 0x01 } },
> +	{ 0xcf, { 0x40, 0x20, 0x18, 0x18, 0x18 } },
> +	{ 0xd0, { 0x00, 0x00, 0x00, 0x00, 0x00 } },
> +	{ 0xd1, { 0x00, 0x00, 0x00, 0x00, 0x00 } },
> +	{ 0xd2, { 0x00, 0x00, 0x00, 0x00, 0x00 } },
> +	{ 0xd3, { 0x00, 0x00, 0x00, 0x00, 0x00 } },
> +	{ 0xd4, { 0x05, 0x05, 0x05, 0x05, 0x05 } },
> +	{ 0xd5, { 0x05, 0x05, 0x05, 0x03, 0x05 } },
> +	{ 0xd6, { 0xac, 0x22, 0xca, 0x8f, 0xca } },
> +	{ 0xd7, { 0x20, 0x20, 0x20, 0x20, 0x20 } },
> +	{ 0xd8, { 0x01, 0x01, 0x01, 0x01, 0x01 } },
> +	{ 0xd9, { 0x00, 0x00, 0x0f, 0x00, 0x0f } },
> +	{ 0xda, { 0x00, 0xff, 0xff, 0x0e, 0xff } },
> +	{ 0xdb, { 0x0a, 0x0a, 0x0a, 0x0a, 0x0a } },
> +	{ 0xdc, { 0x0a, 0x0a, 0x0a, 0x0a, 0x0a } },
> +	{ 0xdd, { 0x05, 0x05, 0x05, 0x05, 0x05 } },
> +	{ 0xde, { 0x0a, 0x0a, 0x0a, 0x0a, 0x0a } },
> +	{ 0xdf, { 0x42, 0x42, 0x44, 0x44, 0x04 } },
> +	{ 0xe0, { 0x00, 0x00, 0x00, 0x00, 0x00 } },
> +	{ 0xe1, { 0x00, 0x00, 0x00, 0x00, 0x00 } },
> +	{ 0xe2, { 0x00, 0x00, 0x00, 0x00, 0x00 } },
> +	{ 0xe3, { 0x00, 0x00, 0x26, 0x06, 0x26 } },
> +	{ 0xe4, { 0x00, 0x00, 0x00, 0x00, 0x00 } },
> +	{ 0xe5, { 0x01, 0x0a, 0x01, 0x01, 0x01 } },
> +	{ 0xe6, { 0x00, 0x00, 0x00, 0x00, 0x00 } },
> +	{ 0xe7, { 0x08, 0x08, 0x08, 0x08, 0x08 } },
> +	{ 0xe8, { 0x63, 0x63, 0x63, 0x63, 0x63 } },
> +	{ 0xe9, { 0x59, 0x59, 0x59, 0x59, 0x59 } },
> +	{ 0xea, { 0x80, 0x80, 0x20, 0x80, 0x80 } },
> +	{ 0xeb, { 0x37, 0x37, 0x78, 0x37, 0x77 } },
> +	{ 0xec, { 0x1f, 0x1f, 0x25, 0x25, 0x25 } },
> +	{ 0xed, { 0x0a, 0x0a, 0x0a, 0x0a, 0x0a } },
> +	{ 0xee, { 0x00, 0x00, 0x00, 0x00, 0x00 } },
> +	{ 0xef, { 0x70, 0x70, 0x58, 0x38, 0x58 } },
> +	{ 0xf0, { 0x00, 0x00, 0x00, 0x00, 0x00 } },
> +};
> +
> +#endif /* HD29L2_PRIV */
> -- 
> 1.7.7.4
> 

