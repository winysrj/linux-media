Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:58503 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755454Ab3LIF6Y (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Dec 2013 00:58:24 -0500
Message-ID: <52A55BFA.2060402@gentoo.org>
Date: Mon, 09 Dec 2013 06:58:18 +0100
From: Matthias Schwarzott <zzam@gentoo.org>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [PATCH REVIEW 03/18] Montage M88DS3103 DVB-S/S2 demodulator driver
References: <1386541895-8634-1-git-send-email-crope@iki.fi> <1386541895-8634-4-git-send-email-crope@iki.fi>
In-Reply-To: <1386541895-8634-4-git-send-email-crope@iki.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Antti,
I have a small suggestion, see below.

On 08.12.2013 23:31, Antti Palosaari wrote:
> diff --git a/drivers/media/dvb-frontends/m88ds3103.c b/drivers/media/dvb-frontends/m88ds3103.c
> new file mode 100644
> index 0000000..91b3729
> --- /dev/null
> +++ b/drivers/media/dvb-frontends/m88ds3103.c
> @@ -0,0 +1,1293 @@
> +/*
> + * Montage M88DS3103 demodulator driver
> + *
> + * Copyright (C) 2013 Antti Palosaari <crope@iki.fi>
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
> +#include "m88ds3103_priv.h"
> +
> +static struct dvb_frontend_ops m88ds3103_ops;
> +
> +/* write multiple registers */
> +static int m88ds3103_wr_regs(struct m88ds3103_priv *priv,
> +		u8 reg, const u8 *val, int len)
> +{
> +	int ret;
> +	u8 buf[1 + len];

Looking at the recent patches for variable length arrays, I think this
should be converted to fixed size.

> +	struct i2c_msg msg[1] = {
> +		{
> +			.addr = priv->cfg->i2c_addr,
> +			.flags = 0,
> +			.len = sizeof(buf),
> +			.buf = buf,
> +		}
> +	};
> +
> +	buf[0] = reg;
> +	memcpy(&buf[1], val, len);
> +
> +	mutex_lock(&priv->i2c_mutex);
> +	ret = i2c_transfer(priv->i2c, msg, 1);
> +	mutex_unlock(&priv->i2c_mutex);
> +	if (ret == 1) {
> +		ret = 0;
> +	} else {
> +		dev_warn(&priv->i2c->dev,
> +				"%s: i2c wr failed=%d reg=%02x len=%d\n",
> +				KBUILD_MODNAME, ret, reg, len);
> +		ret = -EREMOTEIO;
> +	}
> +
> +	return ret;
> +}
> +
> +/* read multiple registers */
> +static int m88ds3103_rd_regs(struct m88ds3103_priv *priv,
> +		u8 reg, u8 *val, int len)
> +{
> +	int ret;
> +	u8 buf[len];

Same as above.

> +	struct i2c_msg msg[2] = {
> +		{
> +			.addr = priv->cfg->i2c_addr,
> +			.flags = 0,
> +			.len = 1,
> +			.buf = &reg,
> +		}, {
> +			.addr = priv->cfg->i2c_addr,
> +			.flags = I2C_M_RD,
> +			.len = sizeof(buf),
> +			.buf = buf,
> +		}
> +	};
> +
> +	mutex_lock(&priv->i2c_mutex);
> +	ret = i2c_transfer(priv->i2c, msg, 2);
> +	mutex_unlock(&priv->i2c_mutex);
> +	if (ret == 2) {
> +		memcpy(val, buf, len);
> +		ret = 0;
> +	} else {
> +		dev_warn(&priv->i2c->dev,
> +				"%s: i2c rd failed=%d reg=%02x len=%d\n",
> +				KBUILD_MODNAME, ret, reg, len);
> +		ret = -EREMOTEIO;
> +	}
> +
> +	return ret;
> +}
> +

Regards
Matthias


