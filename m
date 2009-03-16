Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:40194 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755071AbZCPMwl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Mar 2009 08:52:41 -0400
Date: Mon, 16 Mar 2009 09:51:57 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Hans Verkuil" <hverkuil@xs4all.nl>
Cc: "Trent Piepho" <xyzzy@speakeasy.org>, linux-media@vger.kernel.org
Subject: Re: REVIEW: bttv conversion to v4l2_subdev
Message-ID: <20090316095157.1ac4889f@gaivota.chehab.org>
In-Reply-To: <24193.62.70.2.252.1237205766.squirrel@webmail.xs4all.nl>
References: <24193.62.70.2.252.1237205766.squirrel@webmail.xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 16 Mar 2009 13:16:06 +0100 (CET)
"Hans Verkuil" <hverkuil@xs4all.nl> wrote:
> >>  	if (BTTV_BOARD_UNKNOWN == btv->c.type) {
> >>  		bttv_readee(btv,eeprom_data,0xa0);
> >> @@ -3502,8 +3501,13 @@ void __devinit bttv_init_card2(struct bt
> >>  		struct tuner_setup tun_setup;
> >>
> >>  		/* Load tuner module before issuing tuner config call! */
> >> -		if (autoload)
> >> -			request_module("tuner");
> >> +		if (bttv_tvcards[btv->c.type].has_radio)
> >> +			v4l2_i2c_new_probed_subdev(&btv->c.i2c_adap,
> >> +				"tuner", "tuner", v4l2_i2c_tuner_addrs(ADDRS_RADIO));
> >> +		v4l2_i2c_new_probed_subdev(&btv->c.i2c_adap, "tuner",
> >> +				"tuner", v4l2_i2c_tuner_addrs(ADDRS_DEMOD));
> >> +		v4l2_i2c_new_probed_subdev(&btv->c.i2c_adap, "tuner",
> >> +				"tuner", v4l2_i2c_tuner_addrs(ADDRS_TV_WITH_DEMOD));
> >
> > There are several bttv boards without tuner. In fact, those are becoming
> > a more common setup with bttv, since there are still several surveillance
> > boards with bttv being selled in the market. We should test if
> > !TUNER_ABSENT
> > before doing the probe for a tuner.
> 
> Hmm? This code is already inside an 'if (btv->tuner_type != TUNER_ABSENT)'.

OK.

> >> +		btv->sd_msp34xx = v4l2_i2c_new_probed_subdev(&btv->c.i2c_adap,
> >> +				"msp3400", "msp3400", addrs);
> >> +	}
> >
> > Why do you need to probe it twice? Shouldn't it be just one probing for
> > both addresses?
> 
> The original code is actually doing its own probing for just one address.
> So this replicates the original behavior.

IMO, it is safe to use just one probing function here.

> > Based on this principle, IMO, the probing function should, by default,
> > probe
> > for tvaudio, if it doesn't find another audio device. You may eventually
> > ask
> > for people to report, to warn us that the board entry is broken, but we
> > shouln't intentionally break a device that we're almost sure that requires
> > tvaudio or tda7432.
> 
> OK. In other words it would be better to probe for:
> 
> 1) msp3400
> 2) msp3400_alt
> 3) tda7432
> 4) tvaudio
> 
> and return as soon as we find a chip. So tvaudio is probed
> unconditionally, effectively ignoring the needs_tvaudio flag and only
> honoring the tvaudio module option (although I'm not sure whether that is
> still needed in that case).

IMO, we should handle the needs_tvaudio with a different behaviour: using such kind of
glue only when we're sure about the tv audio chips used for a certain board. If
unsure, use the auto probing. Otherwise, we'll probe just that know chip(s) range.

> 
> >> +	} else {
> >> +		/* tda9875 is now also handled by tvaudio. It used to be
> >> +		   handled by the tda9875 module, but that causes problems
> >> +		   in detecting whether you have a tda9874 or tda9875. It is
> >> +		   better to use tvaudio for both. */
> >> +		load_tvaudio = bttv_tvcards[btv->c.type].needs_tvaudio ||
> >> +			!bttv_tvcards[btv->c.type].no_tda9875;
> >> +	}
> >> +
> >> +	/* Now see if we can find one of the tvaudio devices. */
> >> +	if (load_tvaudio) {
> >> +		static const unsigned short addrs[] = {
> >> +			I2C_ADDR_TDA8425   >> 1,
> >> +			I2C_ADDR_TEA6300   >> 1,
> >> +			I2C_ADDR_TEA6420   >> 1,
> >> +			I2C_ADDR_TDA9840   >> 1,
> >> +			I2C_ADDR_TDA985x_L >> 1,
> >> +			I2C_ADDR_TDA985x_H >> 1,
> >> +			I2C_ADDR_TDA9874   >> 1,
> >> +			I2C_ADDR_PIC16C54  >> 1,
> >> +			I2C_CLIENT_END
> >> +		};
> >
> > We should preserve the same probing order as before, in order to reduce
> > breakage risks.
> 
> It is the same order.

Ok.

> >> @@ -331,6 +331,7 @@ struct bttv {
> >>  	unsigned int tuner_type;  /* tuner chip type */
> >>  	unsigned int tda9887_conf;
> >>  	unsigned int svhs, dig;
> >> +	int has_saa6588;
> >
> > Does it need to be a 32 or 64 bit integer?
> 
> I'll replace it with a u8.

I was thinking on using a bit field here instead.

> Thanks for the review! Much appreciated.

You're welcome.


Cheers,
Mauro
