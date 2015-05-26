Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f54.google.com ([74.125.82.54]:33826 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747AbbEZS6y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 May 2015 14:58:54 -0400
Message-ID: <5564C269.2000003@gmail.com>
Date: Tue, 26 May 2015 19:58:49 +0100
From: Malcolm Priestley <tvboxspy@gmail.com>
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: crope@iki.fi, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 2/2] ts2020: Provide DVBv5 API signal strength
References: <20150526150400.10241.25444.stgit@warthog.procyon.org.uk> <20150526150407.10241.89123.stgit@warthog.procyon.org.uk>
In-Reply-To: <20150526150407.10241.89123.stgit@warthog.procyon.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 26/05/15 16:04, David Howells wrote:
> Provide a DVBv5 API signal strength.  This is in units of 0.001 dBm rather
> than a percentage.
>
>>From Antti Palosaari's testing with a signal generator, it appears that the
> gain calculated according to Montage's specification if negated is a
> reasonable representation of the signal strength of the generator.
>
> To this end:
>
>   (1) Polled statistic gathering needed to be implemented in the TS2020 driver.
>       This is done in the ts2020_stat_work() function.
>
>   (2) The calculated gain is placed as the signal strength in the
>       dtv_property_cache associated with the front end with the scale set to
>       FE_SCALE_DECIBEL.
>
>   (3) The DVBv3 format signal strength then needed to be calculated from the
>       signal strength stored in the dtv_property_cache rather than accessing
>       the value when ts2020_read_signal_strength() is called.
>
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
>
>   drivers/media/dvb-frontends/ts2020.c |   62 +++++++++++++++++++++++++++++-----
>   1 file changed, 53 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/media/dvb-frontends/ts2020.c b/drivers/media/dvb-frontends/ts2020.c
> index 277e1cf..80ae039 100644
> --- a/drivers/media/dvb-frontends/ts2020.c
> +++ b/drivers/media/dvb-frontends/ts2020.c
> @@ -32,10 +32,11 @@ struct ts2020_priv {
>   	struct regmap_config regmap_config;
>   	struct regmap *regmap;
>   	struct dvb_frontend *fe;
> +	struct delayed_work stat_work;
>   	int (*get_agc_pwm)(struct dvb_frontend *fe, u8 *_agc_pwm);
>   	/* i2c details */
> -	int i2c_address;
>   	struct i2c_adapter *i2c;
> +	int i2c_address;
>   	u8 clk_out:2;
>   	u8 clk_out_div:5;
>   	u32 frequency_div; /* LO output divider switch frequency */
> @@ -65,6 +66,7 @@ static int ts2020_release(struct dvb_frontend *fe)
>   static int ts2020_sleep(struct dvb_frontend *fe)
>   {
>   	struct ts2020_priv *priv = fe->tuner_priv;
> +	int ret;
>   	u8 u8tmp;
>
>   	if (priv->tuner == TS2020_M88TS2020)
> @@ -72,11 +74,18 @@ static int ts2020_sleep(struct dvb_frontend *fe)
>   	else
>   		u8tmp = 0x00;
>
> -	return regmap_write(priv->regmap, u8tmp, 0x00);
> +	ret = regmap_write(priv->regmap, u8tmp, 0x00);
> +	if (ret < 0)
> +		return ret;
> +
> +	/* stop statistics polling */
> +	cancel_delayed_work_sync(&priv->stat_work);
> +	return 0;
>   }
>
>   static int ts2020_init(struct dvb_frontend *fe)
>   {
> +	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
>   	struct ts2020_priv *priv = fe->tuner_priv;
>   	int i;
>   	u8 u8tmp;
> @@ -138,6 +147,13 @@ static int ts2020_init(struct dvb_frontend *fe)
>   				     reg_vals[i].val);
>   	}
>
> +	/* Initialise v5 stats here */
> +	c->strength.len = 1;
> +	c->strength.stat[0].scale = FE_SCALE_DECIBEL;
> +	c->strength.stat[0].uvalue = 0;
> +
> +	/* Start statistics polling */
> +	schedule_delayed_work(&priv->stat_work, 0);
>   	return 0;
>   }
>

Hi David

Statistics polling can not be done by lmedm04 driver's implementation of 
M88RS2000/TS2020 because I2C messages stop the devices demuxer.

So any polling must be a config option for this driver.

Regards

Malcolm





