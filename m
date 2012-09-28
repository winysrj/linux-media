Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:57147 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758069Ab2I1Sbc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Sep 2012 14:31:32 -0400
Message-ID: <5065ECEB.30807@iki.fi>
Date: Fri, 28 Sep 2012 21:31:07 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: mkrufky@linuxtv.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] tda18271-common: hold the I2C adapter during write transfers
References: <20120928084337.1db94b8c@redhat.com> <1348844661-19114-1-git-send-email-mchehab@redhat.com>
In-Reply-To: <1348844661-19114-1-git-send-email-mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,
Did not fix the issue. Problem remains same. With the sleep + that patch 
it works still.

On 09/28/2012 06:04 PM, Mauro Carvalho Chehab wrote:
> The tda18271 datasheet says:
>
> 	"The image rejection calibration and RF tracking filter
> 	 calibration must be launched exactly as described in the
> 	 flowchart, otherwise bad calibration or even blocking of the
> 	 TDA18211HD can result making it impossible to communicate
> 	 via the I2C-bus."
>
> (yeah, tda18271 refers there to tda18211 - likely a typo at their
>   datasheets)

tda18211 is just same than tda18271 but without a analog.

> That likely explains why sometimes tda18271 stops answering. That
> is now happening more often on designs with drx-k chips, as the
> firmware is now loaded asyncrousnly there.
>
> While the above text doesn't explicitly tell that the I2C bus
> couldn't be used by other devices during such initialization,
> that seems to be a requirement there.
>
> So, let's explicitly use the I2C lock there, avoiding I2C bus
> share during those critical moments.
>
> Compile-tested only. Please test.
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> ---
>   drivers/media/tuners/tda18271-common.c | 104 ++++++++++++++++++++++-----------
>   1 file changed, 71 insertions(+), 33 deletions(-)
>
> diff --git a/drivers/media/tuners/tda18271-common.c b/drivers/media/tuners/tda18271-common.c
> index 221171e..18c77af 100644
> --- a/drivers/media/tuners/tda18271-common.c
> +++ b/drivers/media/tuners/tda18271-common.c
> @@ -187,7 +187,8 @@ int tda18271_read_extended(struct dvb_frontend *fe)
>   	return (ret == 2 ? 0 : ret);
>   }
>
> -int tda18271_write_regs(struct dvb_frontend *fe, int idx, int len)
> +static int __tda18271_write_regs(struct dvb_frontend *fe, int idx, int len,
> +			bool lock_i2c)
>   {
>   	struct tda18271_priv *priv = fe->tuner_priv;
>   	unsigned char *regs = priv->tda18271_regs;
> @@ -198,7 +199,6 @@ int tda18271_write_regs(struct dvb_frontend *fe, int idx, int len)
>
>   	BUG_ON((len == 0) || (idx + len > sizeof(buf)));
>
> -
>   	switch (priv->small_i2c) {
>   	case TDA18271_03_BYTE_CHUNK_INIT:
>   		max = 3;
> @@ -214,7 +214,19 @@ int tda18271_write_regs(struct dvb_frontend *fe, int idx, int len)
>   		max = 39;
>   	}
>
> -	tda18271_i2c_gate_ctrl(fe, 1);
> +
> +	/*
> +	 * If lock_i2c is true, it will take the I2C bus for tda18271 private
> +	 * usage during the entire write ops, as otherwise, bad things could
> +	 * happen.
> +	 * During device init, several write operations will happen. So,
> +	 * tda18271_init_regs controls the I2C lock directly,
> +	 * disabling lock_i2c here.
> +	 */
> +	if (lock_i2c) {
> +		tda18271_i2c_gate_ctrl(fe, 1);
> +		i2c_lock_adapter(priv->i2c_props.adap);
> +	}
>   	while (len) {
>   		if (max > len)
>   			max = len;
> @@ -226,14 +238,17 @@ int tda18271_write_regs(struct dvb_frontend *fe, int idx, int len)
>   		msg.len = max + 1;
>
>   		/* write registers */
> -		ret = i2c_transfer(priv->i2c_props.adap, &msg, 1);
> +		ret = __i2c_transfer(priv->i2c_props.adap, &msg, 1);
>   		if (ret != 1)
>   			break;
>
>   		idx += max;
>   		len -= max;
>   	}
> -	tda18271_i2c_gate_ctrl(fe, 0);
> +	if (lock_i2c) {
> +		i2c_unlock_adapter(priv->i2c_props.adap);
> +		tda18271_i2c_gate_ctrl(fe, 0);
> +	}
>
>   	if (ret != 1)
>   		tda_err("ERROR: idx = 0x%x, len = %d, "
> @@ -242,10 +257,16 @@ int tda18271_write_regs(struct dvb_frontend *fe, int idx, int len)
>   	return (ret == 1 ? 0 : ret);
>   }
>
> +int tda18271_write_regs(struct dvb_frontend *fe, int idx, int len)
> +{
> +	return __tda18271_write_regs(fe, idx, len, true);
> +}
> +
>   /*---------------------------------------------------------------------*/
>
> -int tda18271_charge_pump_source(struct dvb_frontend *fe,
> -				enum tda18271_pll pll, int force)
> +static int __tda18271_charge_pump_source(struct dvb_frontend *fe,
> +					 enum tda18271_pll pll, int force,
> +					 bool lock_i2c)
>   {
>   	struct tda18271_priv *priv = fe->tuner_priv;
>   	unsigned char *regs = priv->tda18271_regs;
> @@ -255,9 +276,16 @@ int tda18271_charge_pump_source(struct dvb_frontend *fe,
>   	regs[r_cp] &= ~0x20;
>   	regs[r_cp] |= ((force & 1) << 5);
>
> -	return tda18271_write_regs(fe, r_cp, 1);
> +	return __tda18271_write_regs(fe, r_cp, 1, lock_i2c);
> +}
> +
> +int tda18271_charge_pump_source(struct dvb_frontend *fe,
> +				enum tda18271_pll pll, int force)
> +{
> +	return __tda18271_charge_pump_source(fe, pll, force, true);
>   }
>
> +
>   int tda18271_init_regs(struct dvb_frontend *fe)
>   {
>   	struct tda18271_priv *priv = fe->tuner_priv;
> @@ -267,6 +295,13 @@ int tda18271_init_regs(struct dvb_frontend *fe)
>   		i2c_adapter_id(priv->i2c_props.adap),
>   		priv->i2c_props.addr);
>
> +	/*
> +	 * Don't let any other I2C transfer to happen at adapter during init,
> +	 * as those could cause bad things
> +	 */
> +	tda18271_i2c_gate_ctrl(fe, 1);
> +	i2c_lock_adapter(priv->i2c_props.adap);
> +
>   	/* initialize registers */
>   	switch (priv->id) {
>   	case TDA18271HDC1:
> @@ -352,28 +387,28 @@ int tda18271_init_regs(struct dvb_frontend *fe)
>   	regs[R_EB22] = 0x48;
>   	regs[R_EB23] = 0xb0;
>
> -	tda18271_write_regs(fe, 0x00, TDA18271_NUM_REGS);
> +	__tda18271_write_regs(fe, 0x00, TDA18271_NUM_REGS, false);
>
>   	/* setup agc1 gain */
>   	regs[R_EB17] = 0x00;
> -	tda18271_write_regs(fe, R_EB17, 1);
> +	__tda18271_write_regs(fe, R_EB17, 1, false);
>   	regs[R_EB17] = 0x03;
> -	tda18271_write_regs(fe, R_EB17, 1);
> +	__tda18271_write_regs(fe, R_EB17, 1, false);
>   	regs[R_EB17] = 0x43;
> -	tda18271_write_regs(fe, R_EB17, 1);
> +	__tda18271_write_regs(fe, R_EB17, 1, false);
>   	regs[R_EB17] = 0x4c;
> -	tda18271_write_regs(fe, R_EB17, 1);
> +	__tda18271_write_regs(fe, R_EB17, 1, false);
>
>   	/* setup agc2 gain */
>   	if ((priv->id) == TDA18271HDC1) {
>   		regs[R_EB20] = 0xa0;
> -		tda18271_write_regs(fe, R_EB20, 1);
> +		__tda18271_write_regs(fe, R_EB20, 1, false);
>   		regs[R_EB20] = 0xa7;
> -		tda18271_write_regs(fe, R_EB20, 1);
> +		__tda18271_write_regs(fe, R_EB20, 1, false);
>   		regs[R_EB20] = 0xe7;
> -		tda18271_write_regs(fe, R_EB20, 1);
> +		__tda18271_write_regs(fe, R_EB20, 1, false);
>   		regs[R_EB20] = 0xec;
> -		tda18271_write_regs(fe, R_EB20, 1);
> +		__tda18271_write_regs(fe, R_EB20, 1, false);
>   	}
>
>   	/* image rejection calibration */
> @@ -391,21 +426,21 @@ int tda18271_init_regs(struct dvb_frontend *fe)
>   	regs[R_MD2] = 0x08;
>   	regs[R_MD3] = 0x00;
>
> -	tda18271_write_regs(fe, R_EP3, 11);
> +	__tda18271_write_regs(fe, R_EP3, 11, false);
>
>   	if ((priv->id) == TDA18271HDC2) {
>   		/* main pll cp source on */
> -		tda18271_charge_pump_source(fe, TDA18271_MAIN_PLL, 1);
> +		__tda18271_charge_pump_source(fe, TDA18271_MAIN_PLL, 1, false);
>   		msleep(1);
>
>   		/* main pll cp source off */
> -		tda18271_charge_pump_source(fe, TDA18271_MAIN_PLL, 0);
> +		__tda18271_charge_pump_source(fe, TDA18271_MAIN_PLL, 0, false);
>   	}
>
>   	msleep(5); /* pll locking */
>
>   	/* launch detector */
> -	tda18271_write_regs(fe, R_EP1, 1);
> +	__tda18271_write_regs(fe, R_EP1, 1, false);
>   	msleep(5); /* wanted low measurement */
>
>   	regs[R_EP5] = 0x85;
> @@ -413,11 +448,11 @@ int tda18271_init_regs(struct dvb_frontend *fe)
>   	regs[R_CD1] = 0x66;
>   	regs[R_CD2] = 0x70;
>
> -	tda18271_write_regs(fe, R_EP3, 7);
> +	__tda18271_write_regs(fe, R_EP3, 7, false);
>   	msleep(5); /* pll locking */
>
>   	/* launch optimization algorithm */
> -	tda18271_write_regs(fe, R_EP2, 1);
> +	__tda18271_write_regs(fe, R_EP2, 1, false);
>   	msleep(30); /* image low optimization completion */
>
>   	/* mid-band */
> @@ -428,11 +463,11 @@ int tda18271_init_regs(struct dvb_frontend *fe)
>   	regs[R_MD1] = 0x73;
>   	regs[R_MD2] = 0x1a;
>
> -	tda18271_write_regs(fe, R_EP3, 11);
> +	__tda18271_write_regs(fe, R_EP3, 11, false);
>   	msleep(5); /* pll locking */
>
>   	/* launch detector */
> -	tda18271_write_regs(fe, R_EP1, 1);
> +	__tda18271_write_regs(fe, R_EP1, 1, false);
>   	msleep(5); /* wanted mid measurement */
>
>   	regs[R_EP5] = 0x86;
> @@ -440,11 +475,11 @@ int tda18271_init_regs(struct dvb_frontend *fe)
>   	regs[R_CD1] = 0x66;
>   	regs[R_CD2] = 0xa0;
>
> -	tda18271_write_regs(fe, R_EP3, 7);
> +	__tda18271_write_regs(fe, R_EP3, 7, false);
>   	msleep(5); /* pll locking */
>
>   	/* launch optimization algorithm */
> -	tda18271_write_regs(fe, R_EP2, 1);
> +	__tda18271_write_regs(fe, R_EP2, 1, false);
>   	msleep(30); /* image mid optimization completion */
>
>   	/* high-band */
> @@ -456,30 +491,33 @@ int tda18271_init_regs(struct dvb_frontend *fe)
>   	regs[R_MD1] = 0x71;
>   	regs[R_MD2] = 0xcd;
>
> -	tda18271_write_regs(fe, R_EP3, 11);
> +	__tda18271_write_regs(fe, R_EP3, 11, false);
>   	msleep(5); /* pll locking */
>
>   	/* launch detector */
> -	tda18271_write_regs(fe, R_EP1, 1);
> +	__tda18271_write_regs(fe, R_EP1, 1, false);
>   	msleep(5); /* wanted high measurement */
>
>   	regs[R_EP5] = 0x87;
>   	regs[R_CD1] = 0x65;
>   	regs[R_CD2] = 0x50;
>
> -	tda18271_write_regs(fe, R_EP3, 7);
> +	__tda18271_write_regs(fe, R_EP3, 7, false);
>   	msleep(5); /* pll locking */
>
>   	/* launch optimization algorithm */
> -	tda18271_write_regs(fe, R_EP2, 1);
> +	__tda18271_write_regs(fe, R_EP2, 1, false);
>   	msleep(30); /* image high optimization completion */
>
>   	/* return to normal mode */
>   	regs[R_EP4] = 0x64;
> -	tda18271_write_regs(fe, R_EP4, 1);
> +	__tda18271_write_regs(fe, R_EP4, 1, false);
>
>   	/* synchronize */
> -	tda18271_write_regs(fe, R_EP1, 1);
> +	__tda18271_write_regs(fe, R_EP1, 1, false);
> +
> +	i2c_unlock_adapter(priv->i2c_props.adap);
> +	tda18271_i2c_gate_ctrl(fe, 0);
>
>   	return 0;
>   }
>


-- 
http://palosaari.fi/
