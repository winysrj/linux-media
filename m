Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:43916 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752311Ab3AAPkL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Jan 2013 10:40:11 -0500
Message-ID: <50E30336.9040206@iki.fi>
Date: Tue, 01 Jan 2013 17:39:34 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Michael Krufky <mkrufky@linuxtv.org>
CC: linux-media@vger.kernel.org, mchehab@redhat.com
Subject: Re: [PATCH] tda10071: make sure both tuner and demod i2c addresses
 are specified
References: <1355706724-25663-1-git-send-email-mkrufky@linuxtv.org>
In-Reply-To: <1355706724-25663-1-git-send-email-mkrufky@linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/17/2012 03:12 AM, Michael Krufky wrote:
> display an error message if either tuner_i2c_addr or demod_i2c_addr
> are not specified in the tda10071_config structure

Nack.

I don't see it necessary at all to check correctness of driver 
configuration values explicitly like that. Those are values which user 
cannot never change and when driver developer pass wrong values he will 
find it out very soon as hardware is not working.

Adding comments to configuration struct which says possible values is 
advisable and enough IMHO.

Maybe you should open own topic for discussion if you really would like 
to add this kind of checks. It is not tda10071 driver specific change, 
it affects about all drivers.


regards
Antti


>
> Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
> ---
>   drivers/media/dvb-frontends/tda10071.c  |   18 +++++++++++++++---
>   drivers/media/dvb-frontends/tda10071.h  |    4 ++--
>   drivers/media/pci/cx23885/cx23885-dvb.c |    2 +-
>   drivers/media/usb/em28xx/em28xx-dvb.c   |    3 ++-
>   4 files changed, 20 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/media/dvb-frontends/tda10071.c b/drivers/media/dvb-frontends/tda10071.c
> index 7103629..02f9234 100644
> --- a/drivers/media/dvb-frontends/tda10071.c
> +++ b/drivers/media/dvb-frontends/tda10071.c
> @@ -30,7 +30,7 @@ static int tda10071_wr_regs(struct tda10071_priv *priv, u8 reg, u8 *val,
>   	u8 buf[len+1];
>   	struct i2c_msg msg[1] = {
>   		{
> -			.addr = priv->cfg.i2c_address,
> +			.addr = priv->cfg.demod_i2c_addr,
>   			.flags = 0,
>   			.len = sizeof(buf),
>   			.buf = buf,
> @@ -59,12 +59,12 @@ static int tda10071_rd_regs(struct tda10071_priv *priv, u8 reg, u8 *val,
>   	u8 buf[len];
>   	struct i2c_msg msg[2] = {
>   		{
> -			.addr = priv->cfg.i2c_address,
> +			.addr = priv->cfg.demod_i2c_addr,
>   			.flags = 0,
>   			.len = 1,
>   			.buf = &reg,
>   		}, {
> -			.addr = priv->cfg.i2c_address,
> +			.addr = priv->cfg.demod_i2c_addr,
>   			.flags = I2C_M_RD,
>   			.len = sizeof(buf),
>   			.buf = buf,
> @@ -1202,6 +1202,18 @@ struct dvb_frontend *tda10071_attach(const struct tda10071_config *config,
>   		goto error;
>   	}
>
> +	/* make sure demod i2c address is specified */
> +	if (!config->demod_i2c_addr) {
> +		dev_dbg(&i2c->dev, "%s: invalid demod i2c address!\n", __func__);
> +		goto error;
> +	}
> +
> +	/* make sure tuner i2c address is specified */
> +	if (!config->tuner_i2c_addr) {
> +		dev_dbg(&i2c->dev, "%s: invalid tuner i2c address!\n", __func__);
> +		goto error;
> +	}
> +
>   	/* setup the priv */
>   	priv->i2c = i2c;
>   	memcpy(&priv->cfg, config, sizeof(struct tda10071_config));
> diff --git a/drivers/media/dvb-frontends/tda10071.h b/drivers/media/dvb-frontends/tda10071.h
> index a20d5c4..bff1c38 100644
> --- a/drivers/media/dvb-frontends/tda10071.h
> +++ b/drivers/media/dvb-frontends/tda10071.h
> @@ -28,10 +28,10 @@ struct tda10071_config {
>   	 * Default: none, must set
>   	 * Values: 0x55,
>   	 */
> -	u8 i2c_address;
> +	u8 demod_i2c_addr;
>
>   	/* Tuner I2C address.
> -	 * Default: 0x14
> +	 * Default: none, must set
>   	 * Values: 0x14, 0x54, ...
>   	 */
>   	u8 tuner_i2c_addr;
> diff --git a/drivers/media/pci/cx23885/cx23885-dvb.c b/drivers/media/pci/cx23885/cx23885-dvb.c
> index cf84c53..a1aae56 100644
> --- a/drivers/media/pci/cx23885/cx23885-dvb.c
> +++ b/drivers/media/pci/cx23885/cx23885-dvb.c
> @@ -662,7 +662,7 @@ static struct mt2063_config terratec_mt2063_config[] = {
>   };
>
>   static const struct tda10071_config hauppauge_tda10071_config = {
> -	.i2c_address = 0x05,
> +	.demod_i2c_addr = 0x05,
>   	.tuner_i2c_addr = 0x54,
>   	.i2c_wr_max = 64,
>   	.ts_mode = TDA10071_TS_SERIAL,
> diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
> index 63f2e70..e800881 100644
> --- a/drivers/media/usb/em28xx/em28xx-dvb.c
> +++ b/drivers/media/usb/em28xx/em28xx-dvb.c
> @@ -714,7 +714,8 @@ static struct tda18271_config em28xx_cxd2820r_tda18271_config = {
>   };
>
>   static const struct tda10071_config em28xx_tda10071_config = {
> -	.i2c_address = 0x55, /* (0xaa >> 1) */
> +	.demod_i2c_addr = 0x55, /* (0xaa >> 1) */
> +	.tuner_i2c_addr = 0x14,
>   	.i2c_wr_max = 64,
>   	.ts_mode = TDA10071_TS_SERIAL,
>   	.spec_inv = 0,
>


-- 
http://palosaari.fi/
