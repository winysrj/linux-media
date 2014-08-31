Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:38978 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751024AbaHaKaB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 31 Aug 2014 06:30:01 -0400
Message-ID: <5402F91E.7000508@gentoo.org>
Date: Sun, 31 Aug 2014 12:29:50 +0200
From: Matthias Schwarzott <zzam@gentoo.org>
MIME-Version: 1.0
To: tskd08@gmail.com, linux-media@vger.kernel.org
CC: m.chehab@samsung.com
Subject: Re: [PATCH v2 4/5] tc90522: add driver for Toshiba TC90522 quad demodulator
References: <1409153356-1887-1-git-send-email-tskd08@gmail.com> <1409153356-1887-5-git-send-email-tskd08@gmail.com>
In-Reply-To: <1409153356-1887-5-git-send-email-tskd08@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 27.08.2014 17:29, tskd08@gmail.com wrote:
> From: Akihiro Tsukada <tskd08@gmail.com>
> 
Hi Akihiro,

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

it sounds wrong to export a second function besides tc90522_attach.
This way there is a hard dependency of the bridge driver to the demod
driver.
In this case it is the only possible demod, but in general it violates
the design of demod drivers and their connection to bridge drivers.

si2168_probe at least has a solution for this:
Write the pointer to the new i2c adapter into location stored in "struct
i2c_adapter **" in the config structure.

Regards
Matthias

