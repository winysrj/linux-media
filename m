Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:2264 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127AbZCXHTM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Mar 2009 03:19:12 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Trent Piepho <xyzzy@speakeasy.org>
Subject: Re: [REVIEWv2] bttv v4l2_subdev conversion
Date: Tue, 24 Mar 2009 08:19:26 +0100
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
References: <200903192124.52524.hverkuil@xs4all.nl> <200903210949.21924.hverkuil@xs4all.nl> <Pine.LNX.4.58.0903231724300.28292@shell2.speakeasy.net>
In-Reply-To: <Pine.LNX.4.58.0903231724300.28292@shell2.speakeasy.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903240819.26398.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 24 March 2009 01:38:04 Trent Piepho wrote:
> On Sat, 21 Mar 2009, Hans Verkuil wrote:
> > On Saturday 21 March 2009 06:56:18 Trent Piepho wrote:
> > > It seems like one could still disable loading modules for that bttv
> > > might think it needs.  When you're testing modules that have not been
> > > installed, any calls to request_module() will load the wrong version
> > > and cause all sorts of breakage.  It should still be possible to
> > > disable any attempts by the driver to do that.
> >
> > The idea is to either let the driver use the card definition info and
> > probing to detect the audio chip, or to tell it which one to load
> > explicitly. That's sufficient in my opinion.
>
> I still think it should be possible to prevent the driver from calling
> request_module().  If you're trying to test drivers then a call to
> request_module can cause a kernel oops.

You mean you want to be able to load the driver without loading any audio 
module? Or do you mean something else? It must be me, but I still don't 
understand what scenario you are trying to prevent. Note that just calling 
request_module() doesn't do anything but load the module in memory. Without 
autoprobing it will never attach to a i2c adapter.

> > I'll remove it. I'll probably put it back in a future patch when I'll
> > start working on RDS. Currently you can read from a radio device in
> > bttv and it will allow that even when there is no rds on board. I
> > intended to use this pointer later in the radio fops to test whether
> > reading is allowed.
>
> Don't you have a has_saa6588 field in the bttv core struct that would
> allow the same thing?

Yeah, that would work as well: if I can't attach the saa6588 module, then I 
can set that field to 0 and check that field elsewhere.

> > > > --- a/linux/drivers/media/video/bt8xx/bttv.h	Thu Mar 19 20:53:32
> > > > 2009 +0100 +++ b/linux/drivers/media/video/bt8xx/bttv.h	Thu Mar 19
> > > > 21:15:53 2009 +0100 @@ -242,6 +242,7 @@
> > > >  	unsigned int msp34xx_alt:1;
> > > >
> > > >  	unsigned int no_video:1; /* video pci function is unused */
> > > > +	unsigned int has_saa6588:1;
> > >
> > > How about not adding this?  It's unused and I just removed a bunch of
> > > unused fields from here.  Add it when someone can actually make use
> > > of it.
> >
> > No. If you add a new card definition and that card has a saa6588, then
> > this bit should be available for you. Otherwise I just know that people
> > will just skip that chip ('Hey! I can't set it! Oh, I'll skip it
> > then...') instead of asking for adding saa6588 support.
> >
> > The only reason it's not used is that the one board that can have it
> > has to test for it dynamically as it is an add-on.
>
> Do you really think anyone is going to add a new card defition to bttv
> that has a saa6588?  All these years and there is only one obscure card
> that has a saa6588 as an add on.  No one even makes bttv cards with
> tuners anymore. The only bttv cards we've seen added in a long time are
> multi-chip cards with no tuners.

I wasn't thinking so much of new devices as existing devices that never 
recorded the presence of a saa6588. We use 17 bits of the 32 available in 
the bitfield. This will be the 18th. I see absolutely no problem with that.

> > Looking at it I should add a comment, though.
> >
> > > >  	unsigned int tuner_type;  /* tuner chip type */
> > > >  	unsigned int tda9887_conf;
> > > >  	unsigned int svhs, dig;
> > > > +	unsigned int has_saa6588:1;
> > >
> > > You're better off not using a bitfield here.  Because of padding, it
> > > still takes 32 bits (or more, depending on the alignment of
> > > bttv_pll_info) in the struct but takes more code to use.
> >
> > Mauro wants a bitfield, he gets a bitfield. I'm not going
> > back-and-forth on this. Personally I don't care one way or the other.
>
> So Mauro, why a bit field?  It doesn't save any space here.

Because this clearly shows that it is a on-off value and not an integer that 
can have other values as well.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
