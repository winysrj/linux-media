Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:60805 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252AbbAEMOq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Jan 2015 07:14:46 -0500
Received: by mail-pa0-f47.google.com with SMTP id kq14so28443352pab.6
        for <linux-media@vger.kernel.org>; Mon, 05 Jan 2015 04:14:46 -0800 (PST)
Message-ID: <54AA8032.30307@gmail.com>
Date: Mon, 05 Jan 2015 21:14:42 +0900
From: Akihiro TSUKADA <tskd08@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
CC: linux-media@vger.kernel.org, tskd08@gmail.com
Subject: Re: [RFC/PATCH] dvb-core: add template code for i2c binding model
References: <1417776573-16182-1-git-send-email-tskd08@gmail.com>	<20141230111051.7aeff58a@concha.lan> <20141230180126.0b0b333d@concha.lan>
In-Reply-To: <20141230180126.0b0b333d@concha.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> The only thing I noticed is that it is causing some warnings at
> dmesg about trying to create already created sysfs nodes, when the
> driver is removed/reinserted.
> 
> Probably, the remove callback is called too soon or too late.

I don't have any warnings in syslog when reinserting earth-pt3 + tc90522,
but I'll look into it.

> -struct dvb_frontend *mb86a20s_attach(const struct mb86a20s_config *config,
> -				    struct i2c_adapter *i2c)
> +static int mb86a20s_probe(struct i2c_client *i2c,
> +			  const struct i2c_device_id *id)
>  {
> +	struct dvb_frontend *fe;
>  	struct mb86a20s_state *state;
>  	u8	rev;
>  
>  	dev_dbg(&i2c->dev, "%s called.\n", __func__);
>  
> -	/* allocate memory for the internal state */
> -	state = kzalloc(sizeof(struct mb86a20s_state), GFP_KERNEL);
> -	if (state == NULL) {
> -		dev_err(&i2c->dev,
> -			"%s: unable to allocate memory for state\n", __func__);
> -		goto error;
> -	}
> +	fe = i2c_get_clientdata(i2c);
> +	state = fe->demodulator_priv;
>  
>  	/* setup the state */
> -	state->config = config;
> +	memcpy(&state->config, i2c->dev.platform_data, sizeof(state->config));
>  	state->i2c = i2c;
>  
>  	/* create dvb_frontend */
> -	memcpy(&state->frontend.ops, &mb86a20s_ops,
> +	memcpy(&fe->ops, &mb86a20s_ops,
>  		sizeof(struct dvb_frontend_ops));

btw,
we can go with "mb86a20s_param = { .ops.fe_ops = &mb86a20s_ops,}" insead.

--
regards,
akihiro
