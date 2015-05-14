Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:35144 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965164AbbENOHu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 14 May 2015 10:07:50 -0400
Date: Thu, 14 May 2015 11:07:45 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: serjk@netup.ru
Cc: linux-media@vger.kernel.org, aospan1@gmail.com
Subject: Re: [PATCH V2 2/5] [media] ascot2e: Sony Ascot2e DVB-C/T/T2 tuner
 driver
Message-ID: <20150514110745.35e13396@recife.lan>
In-Reply-To: <1429092470-29697-3-git-send-email-serjk@netup.ru>
References: <1429092470-29697-1-git-send-email-serjk@netup.ru>
	<1429092470-29697-3-git-send-email-serjk@netup.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 15 Apr 2015 13:07:47 +0300
serjk@netup.ru escreveu:

> From: Kozlov Sergey <serjk@netup.ru>
> 
> Add DVB-T/T2/C frontend driver for Sony Ascot2e (CXD2861ER) chip.
> 
> Changes in version 2:
>     - rename MAINTAINERS entry
>     - fix coding style
>     - use dynamic debug instead of module-specifig debug parameter
>     - fix I2C bus error handling
> 
> Signed-off-by: Kozlov Sergey <serjk@netup.ru>
> ---
>  MAINTAINERS                           |    9 +
>  drivers/media/dvb-frontends/Kconfig   |    7 +
>  drivers/media/dvb-frontends/Makefile  |    1 +
>  drivers/media/dvb-frontends/ascot2e.c |  543 +++++++++++++++++++++++++++++++++
>  drivers/media/dvb-frontends/ascot2e.h |   58 ++++
>  5 files changed, 618 insertions(+)
>  create mode 100644 drivers/media/dvb-frontends/ascot2e.c
>  create mode 100644 drivers/media/dvb-frontends/ascot2e.h
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 7ba61b2..9950fbe 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -6269,6 +6269,15 @@ W:	http://linuxtv.org
>  S:	Maintained
>  F:	drivers/media/radio/radio-maxiradio*
>  
> +MEDIA DRIVERS FOR ASCOT2E
> +M:	Sergey Kozlov <serjk@netup.ru>
> +L:	linux-media@vger.kernel.org
> +W:	http://linuxtv.org
> +W:	http://netup.tv/
> +T:	git git://linuxtv.org/media_tree.git
> +S:	Supported
> +F:	drivers/media/dvb-frontends/ascot2e*
> +
>  MEDIA DRIVERS FOR HORUS3A
>  M:	Sergey Kozlov <serjk@netup.ru>
>  L:	linux-media@vger.kernel.org
> diff --git a/drivers/media/dvb-frontends/Kconfig b/drivers/media/dvb-frontends/Kconfig
> index bd5ab69..d178aca 100644
> --- a/drivers/media/dvb-frontends/Kconfig
> +++ b/drivers/media/dvb-frontends/Kconfig
> @@ -805,6 +805,13 @@ config DVB_HORUS3A
>  	help
>  	  Say Y when you want to support this frontend.
>  
> +config DVB_ASCOT2E
> +	tristate "Sony Ascot2E tuner"
> +	depends on DVB_CORE && I2C
> +	default m if !MEDIA_SUBDRV_AUTOSELECT
> +	help
> +	  Say Y when you want to support this frontend.
> +
>  comment "Tools to develop new frontends"
>  
>  config DVB_DUMMY_FE
> diff --git a/drivers/media/dvb-frontends/Makefile b/drivers/media/dvb-frontends/Makefile
> index 3aa05f3..0b19c10 100644
> --- a/drivers/media/dvb-frontends/Makefile
> +++ b/drivers/media/dvb-frontends/Makefile
> @@ -117,3 +117,4 @@ obj-$(CONFIG_DVB_AF9033) += af9033.o
>  obj-$(CONFIG_DVB_AS102_FE) += as102_fe.o
>  obj-$(CONFIG_DVB_TC90522) += tc90522.o
>  obj-$(CONFIG_DVB_HORUS3A) += horus3a.o
> +obj-$(CONFIG_DVB_ASCOT2E) += ascot2e.o
> diff --git a/drivers/media/dvb-frontends/ascot2e.c b/drivers/media/dvb-frontends/ascot2e.c
> new file mode 100644
> index 0000000..a87cfee
> --- /dev/null
> +++ b/drivers/media/dvb-frontends/ascot2e.c
> @@ -0,0 +1,543 @@
> +/*
> + * ascot2e.c
> + *
> + * Sony Ascot3E DVB-T/T2/C/C2 tuner driver
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
> +#include "ascot2e.h"
> +#include "dvb_frontend.h"
> +
> +enum ascot2e_state {
> +	STATE_UNKNOWN,
> +	STATE_SLEEP,
> +	STATE_ACTIVE
> +};
> +
> +struct ascot2e_priv {
> +	u32			frequency;
> +	u8			i2c_address;
> +	struct i2c_adapter	*i2c;
> +	enum ascot2e_state	state;
> +	void			*set_tuner_data;
> +	int			(*set_tuner)(void *, int);
> +};
> +
> +enum ascot2e_tv_system_t {
> +	ASCOT2E_DTV_DVBT_5,
> +	ASCOT2E_DTV_DVBT_6,
> +	ASCOT2E_DTV_DVBT_7,
> +	ASCOT2E_DTV_DVBT_8,
> +	ASCOT2E_DTV_DVBT2_1_7,
> +	ASCOT2E_DTV_DVBT2_5,
> +	ASCOT2E_DTV_DVBT2_6,
> +	ASCOT2E_DTV_DVBT2_7,
> +	ASCOT2E_DTV_DVBT2_8,
> +	ASCOT2E_DTV_DVBC_6,
> +	ASCOT2E_DTV_DVBC_8,
> +	ASCOT2E_DTV_DVBC2_6,
> +	ASCOT2E_DTV_DVBC2_8,
> +	ASCOT2E_DTV_UNKNOWN
> +};
> +
> +struct ascot2e_band_sett {
> +	u8	if_out_sel;
> +	u8	agc_sel;
> +	u8	mix_oll;
> +	u8	rf_gain;
> +	u8	if_bpf_gc;
> +	u8	fif_offset;
> +	u8	bw_offset;
> +	u8	bw;
> +	u8	rf_oldet;
> +	u8	if_bpf_f0;
> +};
> +
> +#define ASCOT2E_AUTO		0xff
> +#define ASCOT2E_OFFSET(ofs)	((u8)(ofs) & 0x1F)
> +#define ASCOT2E_BW_6		0x00
> +#define ASCOT2E_BW_7		0x01
> +#define ASCOT2E_BW_8		0x02
> +#define ASCOT2E_BW_1_7		0x03
> +
> +static struct ascot2e_band_sett ascot2e_sett[] = {
> +	{ ASCOT2E_AUTO, ASCOT2E_AUTO, 0x03, ASCOT2E_AUTO, 0x06,
> +	  ASCOT2E_OFFSET(-8), ASCOT2E_OFFSET(-6), ASCOT2E_BW_6,  0x0B, 0x00 },
> +	{ ASCOT2E_AUTO, ASCOT2E_AUTO, 0x03, ASCOT2E_AUTO, 0x06,
> +	  ASCOT2E_OFFSET(-8), ASCOT2E_OFFSET(-6), ASCOT2E_BW_6,  0x0B, 0x00 },
> +	{ ASCOT2E_AUTO, ASCOT2E_AUTO, 0x03, ASCOT2E_AUTO, 0x06,
> +	  ASCOT2E_OFFSET(-6), ASCOT2E_OFFSET(-4), ASCOT2E_BW_7,  0x0B, 0x00 },
> +	{ ASCOT2E_AUTO, ASCOT2E_AUTO, 0x03, ASCOT2E_AUTO, 0x06,
> +	  ASCOT2E_OFFSET(-4), ASCOT2E_OFFSET(-2), ASCOT2E_BW_8,  0x0B, 0x00 },
> +	{ ASCOT2E_AUTO, ASCOT2E_AUTO, 0x03, ASCOT2E_AUTO, 0x06,
> +	ASCOT2E_OFFSET(-10), ASCOT2E_OFFSET(-16), ASCOT2E_BW_1_7, 0x0B, 0x00 },
> +	{ ASCOT2E_AUTO, ASCOT2E_AUTO, 0x03, ASCOT2E_AUTO, 0x06,
> +	  ASCOT2E_OFFSET(-8), ASCOT2E_OFFSET(-6), ASCOT2E_BW_6,  0x0B, 0x00 },
> +	{ ASCOT2E_AUTO, ASCOT2E_AUTO, 0x03, ASCOT2E_AUTO, 0x06,
> +	  ASCOT2E_OFFSET(-8), ASCOT2E_OFFSET(-6), ASCOT2E_BW_6,  0x0B, 0x00 },
> +	{ ASCOT2E_AUTO, ASCOT2E_AUTO, 0x03, ASCOT2E_AUTO, 0x06,
> +	  ASCOT2E_OFFSET(-6), ASCOT2E_OFFSET(-4), ASCOT2E_BW_7,  0x0B, 0x00 },
> +	{ ASCOT2E_AUTO, ASCOT2E_AUTO, 0x03, ASCOT2E_AUTO, 0x06,
> +	  ASCOT2E_OFFSET(-4), ASCOT2E_OFFSET(-2), ASCOT2E_BW_8,  0x0B, 0x00 },
> +	{ ASCOT2E_AUTO, ASCOT2E_AUTO, 0x02, ASCOT2E_AUTO, 0x03,
> +	  ASCOT2E_OFFSET(-6), ASCOT2E_OFFSET(-8), ASCOT2E_BW_6,  0x09, 0x00 },
> +	{ ASCOT2E_AUTO, ASCOT2E_AUTO, 0x02, ASCOT2E_AUTO, 0x03,
> +	  ASCOT2E_OFFSET(-2), ASCOT2E_OFFSET(-1), ASCOT2E_BW_8,  0x09, 0x00 },
> +	{ ASCOT2E_AUTO, ASCOT2E_AUTO, 0x03, ASCOT2E_AUTO, 0x01,
> +	  ASCOT2E_OFFSET(-6), ASCOT2E_OFFSET(-4), ASCOT2E_BW_6,  0x09, 0x00 },
> +	{ ASCOT2E_AUTO, ASCOT2E_AUTO, 0x03, ASCOT2E_AUTO, 0x01,
> +	  ASCOT2E_OFFSET(-2), ASCOT2E_OFFSET(2),  ASCOT2E_BW_8,  0x09, 0x00 }
> +};
> +
> +static void ascot2e_i2c_debug(struct ascot2e_priv *priv,
> +			      u8 reg, u8 write, const u8 *data, u32 len)
> +{
> +	dev_dbg(&priv->i2c->dev, "ascot2e: I2C %s reg 0x%02x size %d\n",
> +		(write == 0 ? "read" : "write"), reg, len);
> +#if defined(CONFIG_DYNAMIC_DEBUG)
> +	dynamic_hex_dump("ascot2e: I2C data: ",
> +		DUMP_PREFIX_OFFSET, 16, 1, data, len, false);
> +#endif
> +}
> +
> +static int ascot2e_write_regs(struct ascot2e_priv *priv,
> +			      u8 reg, const u8 *data, u32 len)
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
> +	ascot2e_i2c_debug(priv, reg, 1, data, len);
> +	buf[0] = reg;
> +	memcpy(&buf[1], data, len);
> +
> +	ret = i2c_transfer(priv->i2c, msg, 1);
> +	if (ret >= 0 && ret != 1)
> +		ret = -EREMOTEIO;
> +	if (ret < 0) {
> +		dev_warn(&priv->i2c->dev,
> +			"%s: i2c wr failed=%d reg=%02x len=%d\n",
> +			KBUILD_MODNAME, ret, reg, len);
> +		return ret;
> +	}
> +	return 0;
> +}
> +
> +static int ascot2e_write_reg(struct ascot2e_priv *priv, u8 reg, u8 val)
> +{
> +	return ascot2e_write_regs(priv, reg, &val, 1);
> +}
> +
> +static int ascot2e_read_regs(struct ascot2e_priv *priv,
> +			     u8 reg, u8 *val, u32 len)
> +{
> +	int ret;
> +	struct i2c_msg msg[2] = {
> +		{
> +			.addr = priv->i2c_address,
> +			.flags = 0,
> +			.len = 1,
> +			.buf = &reg,
> +		}, {
> +			.addr = priv->i2c_address,
> +			.flags = I2C_M_RD,
> +			.len = len,
> +			.buf = val,
> +		}
> +	};
> +
> +	ret = i2c_transfer(priv->i2c, &msg[0], 1);
> +	if (ret >= 0 && ret != 1)
> +		ret = -EREMOTEIO;
> +	if (ret < 0) {
> +		dev_warn(&priv->i2c->dev,
> +			"%s: I2C rw failed=%d addr=%02x reg=%02x\n",
> +			KBUILD_MODNAME, ret, priv->i2c_address, reg);
> +		return ret;
> +	}
> +
> +	ret = i2c_transfer(priv->i2c, &msg[1], 1);
> +	if (ret >= 0 && ret != 1)
> +		ret = -EREMOTEIO;
> +	if (ret < 0) {
> +		dev_warn(&priv->i2c->dev,
> +			"%s: i2c rd failed=%d addr=%02x reg=%02x\n",
> +			KBUILD_MODNAME, ret, priv->i2c_address, reg);
> +		return ret;
> +	}
> +	ascot2e_i2c_debug(priv, reg, 0, val, len);
> +	return 0;
> +}
> +
> +static int ascot2e_read_reg(struct ascot2e_priv *priv, u8 reg, u8 *val)
> +{
> +	return ascot2e_read_regs(priv, reg, val, 1);
> +}
> +
> +static int ascot2e_set_reg_bits(struct ascot2e_priv *priv,
> +				u8 reg, u8 data, u8 mask)
> +{
> +	int res;
> +	u8 rdata;
> +
> +	if (mask != 0xff) {
> +		res = ascot2e_read_reg(priv, reg, &rdata);
> +		if (res != 0)
> +			return res;
> +		data = ((data & mask) | (rdata & (mask ^ 0xFF)));
> +	}
> +	return ascot2e_write_reg(priv, reg, data);
> +}
> +
> +static int ascot2e_enter_power_save(struct ascot2e_priv *priv)
> +{
> +	u8 data[2];
> +
> +	dev_dbg(&priv->i2c->dev, "%s()\n", __func__);
> +	if (priv->state == STATE_SLEEP)
> +		return 0;
> +	data[0] = 0x00;
> +	data[1] = 0x04;
> +	ascot2e_write_regs(priv, 0x14, data, 2);
> +	ascot2e_write_reg(priv, 0x50, 0x01);
> +	priv->state = STATE_SLEEP;
> +	return 0;
> +}
> +
> +static int ascot2e_leave_power_save(struct ascot2e_priv *priv)
> +{
> +	u8 data[2] = { 0xFB, 0x0F };
> +
> +	dev_dbg(&priv->i2c->dev, "%s()\n", __func__);
> +	if (priv->state == STATE_ACTIVE)
> +		return 0;
> +	ascot2e_write_regs(priv, 0x14, data, 2);
> +	ascot2e_write_reg(priv, 0x50, 0x00);
> +	priv->state = STATE_ACTIVE;
> +	return 0;
> +}
> +
> +static int ascot2e_init(struct dvb_frontend *fe)
> +{
> +	struct ascot2e_priv *priv = fe->tuner_priv;
> +
> +	dev_dbg(&priv->i2c->dev, "%s()\n", __func__);
> +	return ascot2e_leave_power_save(priv);
> +}
> +
> +static int ascot2e_release(struct dvb_frontend *fe)
> +{
> +	struct ascot2e_priv *priv = fe->tuner_priv;
> +
> +	dev_dbg(&priv->i2c->dev, "%s()\n", __func__);
> +	kfree(fe->tuner_priv);
> +	fe->tuner_priv = NULL;
> +	return 0;
> +}
> +
> +static int ascot2e_sleep(struct dvb_frontend *fe)
> +{
> +	struct ascot2e_priv *priv = fe->tuner_priv;
> +
> +	dev_dbg(&priv->i2c->dev, "%s()\n", __func__);
> +	ascot2e_enter_power_save(priv);
> +	return 0;
> +}
> +
> +static enum ascot2e_tv_system_t ascot2e_get_tv_system(struct dvb_frontend *fe)
> +{
> +	enum ascot2e_tv_system_t system = ASCOT2E_DTV_UNKNOWN;
> +	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
> +	struct ascot2e_priv *priv = fe->tuner_priv;
> +
> +	if (p->delivery_system == SYS_DVBT) {
> +		if (p->bandwidth_hz <= 5000000)
> +			system = ASCOT2E_DTV_DVBT_5;
> +		else if (p->bandwidth_hz <= 6000000)
> +			system = ASCOT2E_DTV_DVBT_6;
> +		else if (p->bandwidth_hz <= 7000000)
> +			system = ASCOT2E_DTV_DVBT_7;
> +		else if (p->bandwidth_hz <= 8000000)
> +			system = ASCOT2E_DTV_DVBT_8;
> +		else {
> +			system = ASCOT2E_DTV_DVBT_8;
> +			p->bandwidth_hz = 8000000;
> +		}
> +	} else if (p->delivery_system == SYS_DVBT2) {
> +		if (p->bandwidth_hz <= 5000000)
> +			system = ASCOT2E_DTV_DVBT2_5;
> +		else if (p->bandwidth_hz <= 6000000)
> +			system = ASCOT2E_DTV_DVBT2_6;
> +		else if (p->bandwidth_hz <= 7000000)
> +			system = ASCOT2E_DTV_DVBT2_7;
> +		else if (p->bandwidth_hz <= 8000000)
> +			system = ASCOT2E_DTV_DVBT2_8;
> +		else {
> +			system = ASCOT2E_DTV_DVBT2_8;
> +			p->bandwidth_hz = 8000000;
> +		}
> +	} else if (p->delivery_system == SYS_DVBC_ANNEX_A) {
> +		/* only 8MHz bandwidth supported now */
> +		system = ASCOT2E_DTV_DVBC_8;
> +		p->bandwidth_hz = 8000000;

Hmm... Why? It seems on my eyes that the rest of the code would
accept ASCOT2E_DTV_DVBC_6. Wasn't it tested, or is it broken?

> +	}
> +	dev_dbg(&priv->i2c->dev,
> +		"%s(): ASCOT2E DTV system %d (delsys %d, bandwidth %d)\n",
> +		__func__, (int)system, p->delivery_system, p->bandwidth_hz);
> +	return system;
> +}
> +
> +static int ascot2e_set_params(struct dvb_frontend *fe)
> +{
> +	u8 data[10];
> +	u32 frequency;
> +	enum ascot2e_tv_system_t tv_system;
> +	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
> +	struct ascot2e_priv *priv = fe->tuner_priv;
> +
> +	dev_dbg(&priv->i2c->dev, "%s(): tune frequency %dkHz\n",
> +		__func__, p->frequency / 1000);
> +	tv_system = ascot2e_get_tv_system(fe);
> +
> +	if (tv_system == ASCOT2E_DTV_UNKNOWN) {
> +		dev_dbg(&priv->i2c->dev, "%s(): unknown DTV system\n",
> +			__func__);
> +		return -EINVAL;
> +	}
> +	if (priv->set_tuner)
> +		priv->set_tuner(priv->set_tuner_data, 1);
> +	frequency = roundup(p->frequency / 1000, 25);
> +	if (priv->state == STATE_SLEEP)
> +		ascot2e_leave_power_save(priv);
> +
> +	/* IF_OUT_SEL / AGC_SEL setting */
> +	data[0] = 0x00;
> +	if (ascot2e_sett[tv_system].agc_sel != ASCOT2E_AUTO) {
> +		/* AGC pin setting from parameter table */
> +		data[0] |= (u8)(
> +			(ascot2e_sett[tv_system].agc_sel & 0x03) << 3);
> +	}
> +	if (ascot2e_sett[tv_system].if_out_sel != ASCOT2E_AUTO) {
> +		/* IFOUT pin setting from parameter table */
> +		data[0] |= (u8)(
> +			(ascot2e_sett[tv_system].if_out_sel & 0x01) << 2);
> +	}
> +	/* Set bit[4:2] only */
> +	ascot2e_set_reg_bits(priv, 0x05, data[0], 0x1c);
> +	/* 0x06 - 0x0F */
> +	/* REF_R setting (0x06) */
> +	if (tv_system == ASCOT2E_DTV_DVBC_6 ||
> +			tv_system == ASCOT2E_DTV_DVBC_8) {
> +		/* xtal, xtal*2 */
> +		data[0] = (frequency > 500000) ? 16 : 32;
> +	} else {
> +		/* xtal/8, xtal/4 */
> +		data[0] = (frequency > 500000) ? 2 : 4;
> +	}
> +	/* XOSC_SEL=100uA */
> +	data[1] = 0x04;
> +	/* KBW setting (0x08), KC0 setting (0x09), KC1 setting (0x0A) */
> +	if (tv_system == ASCOT2E_DTV_DVBC_6 ||
> +			tv_system == ASCOT2E_DTV_DVBC_8) {
> +		data[2] = 18;
> +		data[3] = 120;
> +		data[4] = 20;
> +	} else {
> +		data[2] = 48;
> +		data[3] = 10;
> +		data[4] = 30;
> +	}
> +	/* ORDER/R2_RANGE/R2_BANK/C2_BANK setting (0x0B) */
> +	if (tv_system == ASCOT2E_DTV_DVBC_6 ||
> +			tv_system == ASCOT2E_DTV_DVBC_8)
> +		data[5] = (frequency > 500000) ? 0x08 : 0x0c;
> +	else
> +		data[5] = (frequency > 500000) ? 0x30 : 0x38;
> +	/* Set MIX_OLL (0x0C) value from parameter table */
> +	data[6] = ascot2e_sett[tv_system].mix_oll;
> +	/* Set RF_GAIN (0x0D) setting from parameter table */
> +	if (ascot2e_sett[tv_system].rf_gain == ASCOT2E_AUTO) {
> +		/* RF_GAIN auto control enable */
> +		ascot2e_write_reg(priv, 0x4E, 0x01);
> +		/* RF_GAIN Default value */
> +		data[7] = 0x00;
> +	} else {
> +		/* RF_GAIN auto control disable */
> +		ascot2e_write_reg(priv, 0x4E, 0x00);
> +		data[7] = ascot2e_sett[tv_system].rf_gain;
> +	}
> +	/* Set IF_BPF_GC/FIF_OFFSET (0x0E) value from parameter table */
> +	data[8] = (u8)((ascot2e_sett[tv_system].fif_offset << 3) |
> +		(ascot2e_sett[tv_system].if_bpf_gc & 0x07));
> +	/* Set BW_OFFSET (0x0F) value from parameter table */
> +	data[9] = ascot2e_sett[tv_system].bw_offset;
> +	ascot2e_write_regs(priv, 0x06, data, 10);
> +	/*
> +	 * 0x45 - 0x47
> +	 * LNA optimization setting
> +	 * RF_LNA_DIST1-5, RF_LNA_CM
> +	 */
> +	if (tv_system == ASCOT2E_DTV_DVBC_6 ||
> +			tv_system == ASCOT2E_DTV_DVBC_8) {
> +		data[0] = 0x0F;
> +		data[1] = 0x00;
> +		data[2] = 0x01;
> +	} else {
> +		data[0] = 0x0F;
> +		data[1] = 0x00;
> +		data[2] = 0x03;
> +	}
> +	ascot2e_write_regs(priv, 0x45, data, 3);
> +	/* 0x49 - 0x4A
> +	 Set RF_OLDET_ENX/RF_OLDET_OLL value from parameter table */
> +	data[0] = ascot2e_sett[tv_system].rf_oldet;
> +	/* Set IF_BPF_F0 value from parameter table */
> +	data[1] = ascot2e_sett[tv_system].if_bpf_f0;
> +	ascot2e_write_regs(priv, 0x49, data, 2);
> +	/*
> +	 * Tune now
> +	 * RFAGC fast mode / RFAGC auto control enable
> +	 * (set bit[7], bit[5:4] only)
> +	 * vco_cal = 1, set MIX_OL_CPU_EN
> +	 */
> +	ascot2e_set_reg_bits(priv, 0x0c, 0x90, 0xb0);
> +	/* Logic wake up, CPU wake up */
> +	data[0] = 0xc4;
> +	data[1] = 0x40;
> +	ascot2e_write_regs(priv, 0x03, data, 2);
> +	/* 0x10 - 0x14 */
> +	data[0] = (u8)(frequency & 0xFF);         /* 0x10: FRF_L */
> +	data[1] = (u8)((frequency >> 8) & 0xFF);  /* 0x11: FRF_M */
> +	data[2] = (u8)((frequency >> 16) & 0x0F); /* 0x12: FRF_H (bit[3:0]) */
> +	/* 0x12: BW (bit[5:4]) */
> +	data[2] |= (u8)(ascot2e_sett[tv_system].bw << 4);
> +	data[3] = 0xFF; /* 0x13: VCO calibration enable */
> +	data[4] = 0xFF; /* 0x14: Analog block enable */
> +	/* Tune (Burst write) */
> +	ascot2e_write_regs(priv, 0x10, data, 5);
> +	msleep(50);
> +	/* CPU deep sleep */
> +	ascot2e_write_reg(priv, 0x04, 0x00);
> +	/* Logic sleep */
> +	ascot2e_write_reg(priv, 0x03, 0xC0);
> +	/* RFAGC normal mode (set bit[5:4] only) */
> +	ascot2e_set_reg_bits(priv, 0x0C, 0x00, 0x30);
> +	priv->frequency = frequency;
> +	return 0;
> +}
> +
> +static int ascot2e_get_frequency(struct dvb_frontend *fe, u32 *frequency)
> +{
> +	struct ascot2e_priv *priv = fe->tuner_priv;
> +
> +	*frequency = priv->frequency * 1000;
> +	return 0;
> +}
> +
> +static struct dvb_tuner_ops ascot2e_tuner_ops = {
> +	.info = {
> +		.name = "Sony ASCOT2E",
> +		.frequency_min = 1000000,
> +		.frequency_max = 1200000000,
> +		.frequency_step = 25000,
> +	},
> +	.init = ascot2e_init,
> +	.release = ascot2e_release,
> +	.sleep = ascot2e_sleep,
> +	.set_params = ascot2e_set_params,
> +	.get_frequency = ascot2e_get_frequency,
> +};
> +
> +struct dvb_frontend *ascot2e_attach(struct dvb_frontend *fe,
> +				    const struct ascot2e_config *config,
> +				    struct i2c_adapter *i2c)
> +{
> +	u8 data[4];
> +	struct ascot2e_priv *priv = NULL;
> +
> +	priv = kzalloc(sizeof(struct ascot2e_priv), GFP_KERNEL);
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
> +	/* 16 MHz xTal frequency */
> +	data[0] = 16;
> +	/* VCO current setting */
> +	data[1] = 0x06;
> +	/* Logic wake up, CPU boot */
> +	data[2] = 0xC4;
> +	data[3] = 0x40;
> +	ascot2e_write_regs(priv, 0x01, data, 4);
> +	/* RFVGA optimization setting (RF_DIST0 - RF_DIST2) */
> +	data[0] = 0x10;
> +	data[1] = 0x3F;
> +	data[2] = 0x25;
> +	ascot2e_write_regs(priv, 0x22, data, 3);
> +	/* PLL mode setting */
> +	ascot2e_write_reg(priv, 0x28, 0x1e);
> +	/* RSSI setting */
> +	ascot2e_write_reg(priv, 0x59, 0x04);
> +	/* TODO check CPU HW error state here */
> +	msleep(80);
> +	/* Xtal oscillator current control setting */
> +	ascot2e_write_reg(priv, 0x4c, 0x01);
> +	/* XOSC_SEL=100uA */
> +	ascot2e_write_reg(priv, 0x07, 0x04);
> +	/* CPU deep sleep */
> +	ascot2e_write_reg(priv, 0x04, 0x00);
> +	/* Logic sleep */
> +	ascot2e_write_reg(priv, 0x03, 0xc0);
> +	/* Power save setting */
> +	data[0] = 0x00;
> +	data[1] = 0x04;
> +	ascot2e_write_regs(priv, 0x14, data, 2);
> +	ascot2e_write_reg(priv, 0x50, 0x01);
> +	priv->state = STATE_SLEEP;
> +
> +	if (fe->ops.i2c_gate_ctrl)
> +		fe->ops.i2c_gate_ctrl(fe, 0);
> +
> +	memcpy(&fe->ops.tuner_ops, &ascot2e_tuner_ops,
> +				sizeof(struct dvb_tuner_ops));
> +	fe->tuner_priv = priv;
> +	dev_info(&priv->i2c->dev,
> +		"Sony ASCOT2E attached on addr=%x at I2C adapter %p\n",
> +		priv->i2c_address, priv->i2c);
> +	return fe;
> +}
> +EXPORT_SYMBOL(ascot2e_attach);
> +
> +MODULE_DESCRIPTION("Sony ASCOT2E terr/cab tuner driver");
> +MODULE_AUTHOR("info@netup.ru");
> +MODULE_LICENSE("GPL");
> diff --git a/drivers/media/dvb-frontends/ascot2e.h b/drivers/media/dvb-frontends/ascot2e.h
> new file mode 100644
> index 0000000..b9e12a3
> --- /dev/null
> +++ b/drivers/media/dvb-frontends/ascot2e.h
> @@ -0,0 +1,58 @@
> +/*
> + * ascot2e.h
> + *
> + * Sony Ascot3E DVB-T/T2/C/C2 tuner driver
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
> +#ifndef __DVB_ASCOT2E_H__
> +#define __DVB_ASCOT2E_H__
> +
> +#include <linux/kconfig.h>
> +#include <linux/dvb/frontend.h>
> +#include <linux/i2c.h>
> +
> +/**
> + * struct ascot2e_config - the configuration of Ascot2E tuner driver
> + * @i2c_address:	I2C address of the tuner
> + * @xtal_freq_mhz:	Oscillator frequency, MHz
> + * @set_tuner_priv:	Callback function private context
> + * @set_tuner_callback:	Callback function that notifies the parent driver
> + *			which tuner is active now
> + */
> +struct ascot2e_config {
> +	u8	i2c_address;
> +	u8	xtal_freq_mhz;
> +	void	*set_tuner_priv;
> +	int	(*set_tuner_callback)(void *, int);
> +};
> +
> +#if IS_ENABLED(CONFIG_DVB_ASCOT2E)

IS_REACHABLE()

> +extern struct dvb_frontend *ascot2e_attach(struct dvb_frontend *fe,
> +					const struct ascot2e_config *config,
> +					struct i2c_adapter *i2c);
> +#else
> +static inline struct dvb_frontend *ascot2e_attach(struct dvb_frontend *fe,
> +					const struct ascot2e_config *config,
> +					struct i2c_adapter *i2c)
> +{
> +	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
> +	return NULL;
> +}
> +#endif
> +
> +#endif
