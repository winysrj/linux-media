Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:56581 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538AbZBUNB4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Feb 2009 08:01:56 -0500
Date: Sat, 21 Feb 2009 10:01:23 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Trent Piepho <xyzzy@speakeasy.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Jean Delvare <khali@linux-fr.org>, urishk@yahoo.com,
	linux-media@vger.kernel.org
Subject: Re: Minimum kernel version supported by v4l-dvb
Message-ID: <20090221100123.498dc99e@pedra.chehab.org>
In-Reply-To: <Pine.LNX.4.58.0902210343520.24268@shell2.speakeasy.net>
References: <43235.62.70.2.252.1234947353.squirrel@webmail.xs4all.nl>
	<20090218140105.17c86bcb@hyperion.delvare>
	<20090220212327.410a298b@pedra.chehab.org>
	<200902210212.53245.hverkuil@xs4all.nl>
	<20090220231350.5467116a@pedra.chehab.org>
	<Pine.LNX.4.58.0902210343520.24268@shell2.speakeasy.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 21 Feb 2009 04:06:53 -0800 (PST)
Trent Piepho <xyzzy@speakeasy.org> wrote:

> On Fri, 20 Feb 2009, Mauro Carvalho Chehab wrote:
> > On Sat, 21 Feb 2009 02:12:53 +0100
> > Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > > > I think that maybe we'll need some legacy-like support for bttv and cx88,
> > > > since there are some boards that relies on the old i2c method to work. On
> > > > those boards (like cx88 Pixelview), the same board model (and PCB
> > > > revision) may or may not have a separate audio decoder. On those devices
> > > > that have an audio decoder, the widely used solution is to load tvaudio
> > > > module and let it bind at the i2c bus, on such cases.
> > >
> > > That's what the i2c_new_probed_device() call is for (called through
> > > v4l2_i2c_new_probed_subdev). You pass a list of i2c addresses that the i2c
> > > core will probe for you: but this comes from the adapter driver, not from
> > > the i2c module.
> >
> > This is a problem. The current procedure used by end users will stop working.
> > It is a little worse: as the adapter driver has no means to know that some
> > device could need tvaudio or other similar devices, we would need some hacking
> > to allow the user to pass a parameter to the driver in order to test/load such
> > drivers, since there's no documentation of when such things are needed.
> 
> The new i2c driver interface also supports a ->detect() method and a list
> of address_data to use it with.  This is much more like the legacy model
> than using i2c_new_probed_device().
> 
> I think a compatability layer than implements attach_adapter,
> detach_adapter, and detach_client using a new-style driver's detect, probe,
> remove, and address_data should not be that hard.
> 
> > > But v4l2-i2c-drv.h is bad enough, and even worse is what it looks like in
> > > the kernel when the compat code has been stripped from it: it's turned into
> > > a completely pointless header. And all the v4l2 i2c modules look peculiar
> > > as well due to that header include.
> 
> As I've said before, the v4l2-i2c headers are lot more complicated than
> they need to be.  I have a tree that's shrunk them greatly.  I don't think
> it's fair to give the current headers as an example of how complicated i2c
> backward compat _must_ be.

We can use your tree as a starting point to review the i2c headers. If they
make no sense for upstream, we should get rid of them, maybe adding it for
removal, just like we do with compat.h at gentree.pl.

Where is the tree? Is it updated to work with the current -tip? Probably, some
merging conflicts would be required, due to Hans trees that weren't yet merged. 

> > This way, the development code won't have any #if's or compat code. I'm afraid
> > that just using patches may also bring another range of troubles of needing to
> > periodically maintain the backports. On the other hand, a syntax/semantic
> > parser would be much more complex to develop.
> 
> IMHO, the ALSA method of providing a backward compatability package is much
> inferior to the way v4l-dvb is doings thing.

I never carefully checked how ALSA actually implemented. The way we do in V4L
provides very few maintainership after a backport is done, with the exception
of i2c backport, where part of the backport code went upstream.

Cheers,
Mauro
