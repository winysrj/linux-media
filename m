Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:56014 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754203AbZCXOjV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Mar 2009 10:39:21 -0400
Date: Tue, 24 Mar 2009 11:39:13 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Trent Piepho <xyzzy@speakeasy.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: Re: [REVIEWv2] bttv v4l2_subdev conversion
Message-ID: <20090324113913.4afa8f7d@pedra.chehab.org>
In-Reply-To: <Pine.LNX.4.58.0903202236080.28292@shell2.speakeasy.net>
References: <200903192124.52524.hverkuil@xs4all.nl>
	<Pine.LNX.4.58.0903202236080.28292@shell2.speakeasy.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans,

I don't see any points to comment, other than the ones Trent did. So, I'll add
my comments here.

On Fri, 20 Mar 2009 22:56:18 -0700 (PDT)
Trent Piepho <xyzzy@speakeasy.org> wrote:

> >  static unsigned int tuner[BTTV_MAX]  = { [ 0 ... (BTTV_MAX-1) ] = UNSET };
> >  static unsigned int svhs[BTTV_MAX]   = { [ 0 ... (BTTV_MAX-1) ] = UNSET };
> >  static unsigned int remote[BTTV_MAX] = { [ 0 ... (BTTV_MAX-1) ] = UNSET };
> > +static unsigned int msp3400[BTTV_MAX];
> > +static unsigned int tda7432[BTTV_MAX];
> > +static unsigned int tvaudio[BTTV_MAX];
> > +static unsigned int saa6588[BTTV_MAX];
> 
> Are any of these audio chips mutually exclusive?  Does the driver even
> support having more than one of them for the same card?  It looks like it
> doesn't.  In that case you could replace some/all of these options with a
> "audio chip type" option where 0 is none, 1 is tvaudio, 2 is msp3400, etc.
> I think that's nicer than adding lots of new options and if you can't have
> multiple audio chips, why allow one to specify that?

IMO, a mutually exclusive kind of parameter would be better. If the user wants
to force some audio chip (or even disable it, for some reason), it should
explicitly select one.

I like Trent's idea of using something like :
	-1 = no audio
	 0 = autoprobe
	 1 = msp3400
	 2 = tda7432, 
	...

While I don't see much gain for no-audio, since we are adding such option, I
don't see why not allowing the user to disable the audio chip support.

> How about not adding this?  It's unused and I just removed a bunch of
> unused fields from here.  Add it when someone can actually make use of it.
> 
> >  	unsigned int tuner_type;  /* tuner chip type */
> >  	unsigned int tda9887_conf;
> >  	unsigned int svhs, dig;
> > +	unsigned int has_saa6588:1;
> 
> You're better off not using a bitfield here.  Because of padding, it still
> takes 32 bits (or more, depending on the alignment of bttv_pll_info) in the
> struct but takes more code to use.

IMO, it is better to keep it as bitfield since later other bitfields could be
added. Also, as Hans pointed, this indicates that this is a on/off ("boolean")
type, but I'm ok if you decide to use another type.

Cheers,
Mauro
