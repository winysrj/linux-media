Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail8.sea5.speakeasy.net ([69.17.117.10]:52801 "EHLO
	mail8.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753788AbZCXAiI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Mar 2009 20:38:08 -0400
Date: Mon, 23 Mar 2009 17:38:04 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [REVIEWv2] bttv v4l2_subdev conversion
In-Reply-To: <200903210949.21924.hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.58.0903231724300.28292@shell2.speakeasy.net>
References: <200903192124.52524.hverkuil@xs4all.nl>
 <Pine.LNX.4.58.0903202236080.28292@shell2.speakeasy.net>
 <200903210949.21924.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 21 Mar 2009, Hans Verkuil wrote:
> On Saturday 21 March 2009 06:56:18 Trent Piepho wrote:
> > It seems like one could still disable loading modules for that bttv might
> > think it needs.  When you're testing modules that have not been
> > installed, any calls to request_module() will load the wrong version and
> > cause all sorts of breakage.  It should still be possible to disable any
> > attempts by the driver to do that.
>
> The idea is to either let the driver use the card definition info and
> probing to detect the audio chip, or to tell it which one to load
> explicitly. That's sufficient in my opinion.

I still think it should be possible to prevent the driver from calling
request_module().  If you're trying to test drivers then a call to
request_module can cause a kernel oops.

> I'll remove it. I'll probably put it back in a future patch when I'll start
> working on RDS. Currently you can read from a radio device in bttv and it
> will allow that even when there is no rds on board. I intended to use this
> pointer later in the radio fops to test whether reading is allowed.

Don't you have a has_saa6588 field in the bttv core struct that would allow
the same thing?

> > > --- a/linux/drivers/media/video/bt8xx/bttv.h	Thu Mar 19 20:53:32 2009
> > > +0100 +++ b/linux/drivers/media/video/bt8xx/bttv.h	Thu Mar 19 21:15:53
> > > 2009 +0100 @@ -242,6 +242,7 @@
> > >  	unsigned int msp34xx_alt:1;
> > >
> > >  	unsigned int no_video:1; /* video pci function is unused */
> > > +	unsigned int has_saa6588:1;
> >
> > How about not adding this?  It's unused and I just removed a bunch of
> > unused fields from here.  Add it when someone can actually make use of
> > it.
>
> No. If you add a new card definition and that card has a saa6588, then this
> bit should be available for you. Otherwise I just know that people will
> just skip that chip ('Hey! I can't set it! Oh, I'll skip it then...')
> instead of asking for adding saa6588 support.
>
> The only reason it's not used is that the one board that can have it has to
> test for it dynamically as it is an add-on.

Do you really think anyone is going to add a new card defition to bttv that
has a saa6588?  All these years and there is only one obscure card that has
a saa6588 as an add on.  No one even makes bttv cards with tuners anymore.
The only bttv cards we've seen added in a long time are multi-chip cards
with no tuners.

> Looking at it I should add a comment, though.
>
> > >  	unsigned int tuner_type;  /* tuner chip type */
> > >  	unsigned int tda9887_conf;
> > >  	unsigned int svhs, dig;
> > > +	unsigned int has_saa6588:1;
> >
> > You're better off not using a bitfield here.  Because of padding, it
> > still takes 32 bits (or more, depending on the alignment of
> > bttv_pll_info) in the struct but takes more code to use.
>
> Mauro wants a bitfield, he gets a bitfield. I'm not going back-and-forth on
> this. Personally I don't care one way or the other.

So Mauro, why a bit field?  It doesn't save any space here.
