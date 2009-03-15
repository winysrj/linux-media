Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:4063 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568AbZCOSww (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Mar 2009 14:52:52 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Trent Piepho <xyzzy@speakeasy.org>
Subject: Re: REVIEW: bttv conversion to v4l2_subdev
Date: Sun, 15 Mar 2009 19:53:06 +0100
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
References: <200903151324.00784.hverkuil@xs4all.nl> <200903151753.52663.hverkuil@xs4all.nl> <Pine.LNX.4.58.0903151001040.28292@shell2.speakeasy.net>
In-Reply-To: <Pine.LNX.4.58.0903151001040.28292@shell2.speakeasy.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903151953.06835.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sunday 15 March 2009 18:28:42 Trent Piepho wrote:
> On Sun, 15 Mar 2009, Hans Verkuil wrote:
> > On Sunday 15 March 2009 17:04:43 Trent Piepho wrote:
> > > On Sun, 15 Mar 2009, Hans Verkuil wrote:
> > > > Hi Mauro,
> > > >
> > > > Can you review my ~hverkuil/v4l-dvb-bttv2 tree?
> > >
> > > It would be a lot easier if you would provide patch descriptions.
> >
> > Here it is:
> >
> > - bttv: convert to v4l2_subdev.
>
> You aren't even trying.  I could easily write two pages on this patch.

You are right. Mauro already knew about all this, but since I posted it to 
linux-media as well I should have given a more detailed explanation.

Here we go:

> What new module parameters did you add? 

tvaudio to override the 'needs_tvaudio' from the card definition.

> Why?

Since just modprobing a module manually will no longer work when the i2c 
autoprobing mechanism disappears. So you need a method to override it.

The main reason for doing this is if the card definition is incorrect.

> What module parameters did  
> you delete?

autoload

> Why?

You will always autoload, so it has become meaningless.

> How does one translate a existing modprobe.conf file?  

Remove the autoload option.

> Why are the i2c addresses from various i2c chips moved into the bttv
> driver?

It is now the adapter driver that tells the i2c core where to probe instead 
of the other way around. The reason is that it is the adapter driver who 
has the knowledge where i2c chips are.

> Doesn't it make more sense that the addresses for chip X should 
> be in the driver for chip X?

I do not want to make too many changes, but when all v4l drivers are 
converted I will revisit this issue. I'm thinking of adding an inline 
function like this in the header belonging to each i2c driver (in 
include/media):

static inline const unsigned short *tvaudio_addrs(void)
{
	static const unsigned short addrs[] = { ... };

	return addrs;
}

Then you can use that in the adapter driver. It's only relevant if you do 
not know the exact address, since it is always better to use that if you 
know it.

>
> How has module loading changed?  Can one no longer *not* autoload modules
> if you are trying to test drivers that are not installed in /lib/modules?

The adapter driver initiates loading of the i2c modules and probes for and 
attaches to the i2c devices. Just doing 'modprobe foo' will no longer cause 
it to attach to any i2c adapter.

> What fields did you add to the card database?

has_saa6588.

> Why? 

Bttv relied on the user to do 'modprobe saa6588' manually. Which no longer 
works.

> How much did the size increase?

No idea. Let me see:

Old:

   text    data     bss     dec     hex filename
  69915   14044     756   84715   14aeb v4l/bttv.ko

New:
   text    data     bss     dec     hex filename
  71177   14168     756   86101   15055 v4l/bttv.ko

> What is the never set has_saa6588 field in tvcards needed 
> for?

Any card with a saa6588 can set it. Currently the only board that has it is 
the Terratec Active Radio Upgrade, which is an addon and is detected 
separately.

> What are the parameters to bttv_call_all?

It's a small macro for the v4l2_device_call_all() utility (see 
v4l2-framework.txt for more info on that):

#define bttv_call_all(btv, o, f, args...) \
        v4l2_device_call_all(&btv->c.v4l2_dev, 0, o, f, ##args)

> How did you change the probing sequence?  What was it before?  What is it
> now?

It was random (dependent on the load order of the modules). Now it is in the 
order as they are probed in bttv-cards.c:

1) tuner (really three: radio tuner, demod, tv tuner)
2) saa6588
3) msp3400
4) tvaudio
5) tda7432

Since tvaudio now supports tda9875 (it's in my pending pull request, not yet 
merged in the master) bttv no longer attempts to load the tda9875 module. 
It was much easier to tell the tda9875 and tda9874 apart if they were 
implemented in the same module. We should probably merge tda7432 into 
tvaudio as well later on.

>
> Where do the subdevs you created get deleted?

When the i2c adapter is deleted or when the v4l2_device is unregistered, 
whichever comes first. When the i2c client is removed they unregister 
themselves from the list in v4l2_device automatically (but this might 
change in the future as it relies on the fact that deleting the i2c adapter 
will also delete the i2c clients). And when the v4l2_device is unregistered 
it will unregister all its subdevices as well.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
