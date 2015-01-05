Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:42700 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751252AbbAEMYx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 5 Jan 2015 07:24:53 -0500
Date: Mon, 5 Jan 2015 10:24:45 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Akihiro TSUKADA <tskd08@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [RFC/PATCH] dvb-core: add template code for i2c binding model
Message-ID: <20150105102445.671d5c1e@concha.lan>
In-Reply-To: <54AA8032.30307@gmail.com>
References: <1417776573-16182-1-git-send-email-tskd08@gmail.com>
	<20141230111051.7aeff58a@concha.lan>
	<20141230180126.0b0b333d@concha.lan>
	<54AA8032.30307@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 05 Jan 2015 21:14:42 +0900
Akihiro TSUKADA <tskd08@gmail.com> escreveu:

> > The only thing I noticed is that it is causing some warnings at
> > dmesg about trying to create already created sysfs nodes, when the
> > driver is removed/reinserted.
> > 
> > Probably, the remove callback is called too soon or too late.
> 
> I don't have any warnings in syslog when reinserting earth-pt3 + tc90522,
> but I'll look into it.

This seems to be an already existing bug at cx231xx, as I'm also getting
those without those patches.

> 
> > -struct dvb_frontend *mb86a20s_attach(const struct mb86a20s_config *config,
> > -				    struct i2c_adapter *i2c)
> > +static int mb86a20s_probe(struct i2c_client *i2c,
> > +			  const struct i2c_device_id *id)
> >  {
> > +	struct dvb_frontend *fe;
> >  	struct mb86a20s_state *state;
> >  	u8	rev;
> >  
> >  	dev_dbg(&i2c->dev, "%s called.\n", __func__);
> >  
> > -	/* allocate memory for the internal state */
> > -	state = kzalloc(sizeof(struct mb86a20s_state), GFP_KERNEL);
> > -	if (state == NULL) {
> > -		dev_err(&i2c->dev,
> > -			"%s: unable to allocate memory for state\n", __func__);
> > -		goto error;
> > -	}
> > +	fe = i2c_get_clientdata(i2c);
> > +	state = fe->demodulator_priv;
> >  
> >  	/* setup the state */
> > -	state->config = config;
> > +	memcpy(&state->config, i2c->dev.platform_data, sizeof(state->config));
> >  	state->i2c = i2c;
> >  
> >  	/* create dvb_frontend */
> > -	memcpy(&state->frontend.ops, &mb86a20s_ops,
> > +	memcpy(&fe->ops, &mb86a20s_ops,
> >  		sizeof(struct dvb_frontend_ops));
> 
> btw,
> we can go with "mb86a20s_param = { .ops.fe_ops = &mb86a20s_ops,}" insead.
> 
> --
> regards,
> akihiro


-- 

Cheers,
Mauro
