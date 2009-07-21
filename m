Return-path: <linux-media-owner@vger.kernel.org>
Received: from bamako.nerim.net ([62.4.17.28]:53681 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754506AbZGUJt2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Jul 2009 05:49:28 -0400
Date: Tue, 21 Jul 2009 11:14:29 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Andy Walls <awalls@radix.net>
Cc: linux-media@vger.kernel.org, Jarod Wilson <jarod@redhat.com>,
	Mark Lord <lkml@rtr.ca>, Mike Isely <isely@pobox.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Janne Grunau <j@jannau.net>
Subject: Re: [PATCH 1/3] ir-kbd-i2c: Allow use of ir-kdb-i2c internal
 get_key  funcs and set ir_type
Message-ID: <20090721111429.006e8b7a@hyperion.delvare>
In-Reply-To: <1248134870.3148.76.camel@palomino.walls.org>
References: <1247862585.10066.16.camel@palomino.walls.org>
	<1247862937.10066.21.camel@palomino.walls.org>
	<20090719144749.689c2b3a@hyperion.delvare>
	<1248134870.3148.76.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andy,

On Mon, 20 Jul 2009 20:07:50 -0400, Andy Walls wrote:
> On Sun, 2009-07-19 at 14:47 +0200, Jean Delvare wrote:
> > Hi Andy,
> > 
> > On Fri, 17 Jul 2009 16:35:37 -0400, Andy Walls wrote:
> > > This patch augments the init data passed by bridge drivers to ir-kbd-i2c
> > > so that the ir_type can be set explicitly and so ir-kbd-i2c internal
> > > get_key functions can be reused without requiring symbols from
> > > ir-kbd-i2c in the bridge driver.
> > > 
> > > 
> > > Regards,
> > > Andy
> > 
> > Looks good. Minor suggestion below:
> 
> Jean,
> 
> Thanks for the reply.  My responses are inline.
> 
> > > 
> > > diff -r d754a2d5a376 linux/drivers/media/video/ir-kbd-i2c.c
> > > --- a/linux/drivers/media/video/ir-kbd-i2c.c	Wed Jul 15 07:28:02 2009 -0300
> > > +++ b/linux/drivers/media/video/ir-kbd-i2c.c	Fri Jul 17 16:05:28 2009 -0400
> > > @@ -478,7 +480,34 @@
> > >  
> > >  		ir_codes = init_data->ir_codes;
> > >  		name = init_data->name;
> > > +		if (init_data->type)
> > > +			ir_type = init_data->type;
> > >  		ir->get_key = init_data->get_key;
> > > +		switch (init_data->internal_get_key_func) {
> > > +		case IR_KBD_GET_KEY_PIXELVIEW:
> > > +			ir->get_key = get_key_pixelview;
> > > +			break;
> > > +		case IR_KBD_GET_KEY_PV951:
> > > +			ir->get_key = get_key_pv951;
> > > +			break;
> > > +		case IR_KBD_GET_KEY_HAUP:
> > > +			ir->get_key = get_key_haup;
> > > +			break;
> > > +		case IR_KBD_GET_KEY_KNC1:
> > > +			ir->get_key = get_key_knc1;
> > > +			break;
> > > +		case IR_KBD_GET_KEY_FUSIONHDTV:
> > > +			ir->get_key = get_key_fusionhdtv;
> > > +			break;
> > > +		case IR_KBD_GET_KEY_HAUP_XVR:
> > > +			ir->get_key = get_key_haup_xvr;
> > > +			break;
> > > +		case IR_KBD_GET_KEY_AVERMEDIA_CARDBUS:
> > > +			ir->get_key = get_key_avermedia_cardbus;
> > > +			break;
> > > +		default:
> > > +			break;
> > > +		}
> > >  	}
> > >  
> > >  	/* Make sure we are all setup before going on */
> > > diff -r d754a2d5a376 linux/include/media/ir-kbd-i2c.h
> > > --- a/linux/include/media/ir-kbd-i2c.h	Wed Jul 15 07:28:02 2009 -0300
> > > +++ b/linux/include/media/ir-kbd-i2c.h	Fri Jul 17 16:05:28 2009 -0400
> > > @@ -24,10 +24,27 @@
> > >  	int                    (*get_key)(struct IR_i2c*, u32*, u32*);
> > >  };
> > >  
> > > +enum ir_kbd_get_key_fn {
> > > +	IR_KBD_GET_KEY_NONE = 0,
> > 
> > As you never use IR_KBD_GET_KEY_NONE, you might as well not define it
> > and start with IR_KBD_GET_KEY_PIXELVIEW = 1. This would have the added
> > advantage that you could get rid of the "default" statement in the
> > above switch, letting gcc warn you (or any other developer) if you ever
> > add a new enum value and forget to handle it in ir_probe().
> 
> >From gcc-4.0.1 docs:
> 
> -Wswitch
>         Warn whenever a switch statement has an index of enumerated type
>         and lacks a case for one or more of the named codes of that
>         enumeration. (The presence of a default label prevents this
>         warning.) case labels outside the enumeration range also provoke
>         warnings when this option is used. This warning is enabled by
>         -Wall. 
>         
> Since a calling driver may provide a value of 0 via a memset, I'd choose
> keeping the enum label of IR_KBD_GET_KEY_NONE, add a case for it in the
> switch(), and remove the "default:" case.

Yes, that's fine with me too. You might want to rename
IR_KBD_GET_KEY_NONE to IR_KBD_GET_KEY_CUSTOM then, and move
	ir->get_key = init_data->get_key;
inside the switch.

>  It just seems wrong to let
> drivers pass in 0 value for "internal_get_key_func" and the switch()
> neither have an explicit nor a "default:" case for it.  (Maybe it's just
> the years of Ada programming that beat things like this into me...)
> 
> My idea was that a driver would
> 
> a. for a driver provided function, specify a pointer to the driver's
> function in "get_key" and set the "internal_get_key_func" field set to 0
> (IR_KBD_GET_KEY_NONE) likely via memset().
> 
> b. for a ir-kbd-i2c provided function, specify a NULL pointer in
> "get_key", and use an enumerated value in "internal_get_key_func".
> 
> If both are specified, the switch() will set to use the ir-kbd-i2c
> internal function, unless an invalid enum value was used.

My key point was that the default case would prevent gcc from helping
you. Any solution without the default case is thus fine with me.

-- 
Jean Delvare
