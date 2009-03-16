Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:56870 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392AbZCPKMb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Mar 2009 06:12:31 -0400
Date: Mon, 16 Mar 2009 07:11:54 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Trent Piepho <xyzzy@speakeasy.org>, linux-media@vger.kernel.org
Subject: Re: REVIEW: bttv conversion to v4l2_subdev
Message-ID: <20090316071154.6b0d3028@gaivota.chehab.org>
In-Reply-To: <200903151953.06835.hverkuil@xs4all.nl>
References: <200903151324.00784.hverkuil@xs4all.nl>
	<200903151753.52663.hverkuil@xs4all.nl>
	<Pine.LNX.4.58.0903151001040.28292@shell2.speakeasy.net>
	<200903151953.06835.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Sun, 15 Mar 2009 19:53:06 +0100
Hans Verkuil <hverkuil@xs4all.nl> wrote:

> On Sunday 15 March 2009 18:28:42 Trent Piepho wrote:
> > On Sun, 15 Mar 2009, Hans Verkuil wrote:
> > > On Sunday 15 March 2009 17:04:43 Trent Piepho wrote:
> > > > On Sun, 15 Mar 2009, Hans Verkuil wrote:
> > > > > Hi Mauro,
> > > > >
> > > > > Can you review my ~hverkuil/v4l-dvb-bttv2 tree?

I'll review it during the week. This will likely take some time, since we need
to be sure that we will not cause any regressions on bttv.

I appreciate if people could try the new driver and give us any feedback if
this works or not, and what boards are confirmed to work.

> > > >
> > > > It would be a lot easier if you would provide patch descriptions.
> > >
> > > Here it is:
> > >
> > > - bttv: convert to v4l2_subdev.
> >
> > You aren't even trying.  I could easily write two pages on this patch.
> 
> You are right. Mauro already knew about all this, but since I posted it to 
> linux-media as well I should have given a more detailed explanation.

The better is to add such comments at the first patch of the series.

Since the patches change the user behaviour, it should, by default, work with
the broader range as possible of probing things.

It should also print some warning messages about the use of deprecated module
parameters (instead of just removing a module and causing load and causing breakages).

We should also provide some sort of documenting that this change happened,
asking people to report troubles to linux-media@vger.kernel.org.

> 
> Here we go:
> 
> > What new module parameters did you add? 
> 
> tvaudio to override the 'needs_tvaudio' from the card definition.

At least on the first kernel with the new driver, IMO, the default should for 
this option should be 1.
> 
> > Why?
> 
> Since just modprobing a module manually will no longer work when the i2c 
> autoprobing mechanism disappears. So you need a method to override it.
> 
> The main reason for doing this is if the card definition is incorrect.
> 
> > What module parameters did  
> > you delete?
> 
> autoload
> 
> > Why?
> 
> You will always autoload, so it has become meaningless.

> > How does one translate a existing modprobe.conf file?  
> 
> Remove the autoload option.

If you just remove autoload, depmod/insmod will complain and not load it. We
should keep it with a deprecated warning message instead.

We can keep this warning up to a few kernel releases, to make sure that people
will be aware (like we did in the past with other deprecated modprobe functions).

Since we're changing an userspace option, we should document it at the features
to deprecated doc in Kernel.

> > Why are the i2c addresses from various i2c chips moved into the bttv
> > driver?
> 
> It is now the adapter driver that tells the i2c core where to probe instead 
> of the other way around. The reason is that it is the adapter driver who 
> has the knowledge where i2c chips are.

This is bad. The I2C address is a property of the i2c adapter, not a property
of the bridge driver. We shouldn't hardcode I2C numbers inside bttv or
other drivers. Maybe we can just create a .h file for each driver, with their
I2C addresses there... oh well, this will just create more complexity.

> 
> > Doesn't it make more sense that the addresses for chip X should 
> > be in the driver for chip X?
> 
> I do not want to make too many changes, but when all v4l drivers are 
> converted I will revisit this issue. I'm thinking of adding an inline 
> function like this in the header belonging to each i2c driver (in 
> include/media):
> 
> static inline const unsigned short *tvaudio_addrs(void)
> {
> 	static const unsigned short addrs[] = { ... };
> 
> 	return addrs;
> }
> 
> Then you can use that in the adapter driver. It's only relevant if you do 
> not know the exact address, since it is always better to use that if you 
> know it.

This seems even worse. The problem is not related with a I2C range, but with
the fact that msp3400 were designed by the manufacturer to work at the address
with addresses 0x40 or 0x44. There's no practical way (or reason) for any bttv
vendor to use msp3400 on any other address.

So, the bttv and other adapter should only use either one of those two i2c
addresses if they're trying to talk with msp3400.

> > How has module loading changed?  Can one no longer *not* autoload modules
> > if you are trying to test drivers that are not installed in /lib/modules?
> 
> The adapter driver initiates loading of the i2c modules and probes for and 
> attaches to the i2c devices. Just doing 'modprobe foo' will no longer cause 
> it to attach to any i2c adapter.

I think that Trent's talking about a different issue. Since nobody knows what
boards will be broken by this changeset, and assuming that this can happen, it
is important to have some options for the user to change the behaviour, to
reproduce what we had before.

So, currently, if you load bttv with:
	bttv autoload=0

Any user can just load the drivers he knows that it works with his device,
avoiding to load other drivers that could cause troubles.

IMO, we should have something like this, to offer as an option. Maybe something like:
	bttv probe_only_i2c_addresses=0x40,0x48,0x60

> 
> > What fields did you add to the card database?
> 
> has_saa6588.
> 
> > Why? 
> 
> Bttv relied on the user to do 'modprobe saa6588' manually. Which no longer 
> works.
> 
> > How much did the size increase?
> 
> No idea. Let me see:
> 
> Old:
> 
>    text    data     bss     dec     hex filename
>   69915   14044     756   84715   14aeb v4l/bttv.ko
> 
> New:
>    text    data     bss     dec     hex filename
>   71177   14168     756   86101   15055 v4l/bttv.ko
> 
> > What is the never set has_saa6588 field in tvcards needed 
> > for?
> 
> Any card with a saa6588 can set it. Currently the only board that has it is 
> the Terratec Active Radio Upgrade, which is an addon and is detected 
> separately.
> 
> > What are the parameters to bttv_call_all?
> 
> It's a small macro for the v4l2_device_call_all() utility (see 
> v4l2-framework.txt for more info on that):
> 
> #define bttv_call_all(btv, o, f, args...) \
>         v4l2_device_call_all(&btv->c.v4l2_dev, 0, o, f, ##args)
> 
> > How did you change the probing sequence?  What was it before?  What is it
> > now?
> 
> It was random (dependent on the load order of the modules). Now it is in the 
> order as they are probed in bttv-cards.c:
> 
> 1) tuner (really three: radio tuner, demod, tv tuner)
> 2) saa6588
> 3) msp3400
> 4) tvaudio
> 5) tda7432
> 
> Since tvaudio now supports tda9875 (it's in my pending pull request, not yet 
> merged in the master) bttv no longer attempts to load the tda9875 module. 
> It was much easier to tell the tda9875 and tda9874 apart if they were 
> implemented in the same module. We should probably merge tda7432 into 
> tvaudio as well later on.
> 
> >
> > Where do the subdevs you created get deleted?
> 
> When the i2c adapter is deleted or when the v4l2_device is unregistered, 
> whichever comes first. When the i2c client is removed they unregister 
> themselves from the list in v4l2_device automatically (but this might 
> change in the future as it relies on the fact that deleting the i2c adapter 
> will also delete the i2c clients). And when the v4l2_device is unregistered 
> it will unregister all its subdevices as well.
> 
> Regards,
> 
> 	Hans
> 




Cheers,
Mauro
