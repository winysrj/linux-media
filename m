Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail4.sea5.speakeasy.net ([69.17.117.6]:33781 "EHLO
	mail4.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356AbZBUMGy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Feb 2009 07:06:54 -0500
Date: Sat, 21 Feb 2009 04:06:53 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Jean Delvare <khali@linux-fr.org>, urishk@yahoo.com,
	linux-media@vger.kernel.org
Subject: Re: Minimum kernel version supported by v4l-dvb
In-Reply-To: <20090220231350.5467116a@pedra.chehab.org>
Message-ID: <Pine.LNX.4.58.0902210343520.24268@shell2.speakeasy.net>
References: <43235.62.70.2.252.1234947353.squirrel@webmail.xs4all.nl>
 <20090218140105.17c86bcb@hyperion.delvare> <20090220212327.410a298b@pedra.chehab.org>
 <200902210212.53245.hverkuil@xs4all.nl> <20090220231350.5467116a@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 20 Feb 2009, Mauro Carvalho Chehab wrote:
> On Sat, 21 Feb 2009 02:12:53 +0100
> Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > > I think that maybe we'll need some legacy-like support for bttv and cx88,
> > > since there are some boards that relies on the old i2c method to work. On
> > > those boards (like cx88 Pixelview), the same board model (and PCB
> > > revision) may or may not have a separate audio decoder. On those devices
> > > that have an audio decoder, the widely used solution is to load tvaudio
> > > module and let it bind at the i2c bus, on such cases.
> >
> > That's what the i2c_new_probed_device() call is for (called through
> > v4l2_i2c_new_probed_subdev). You pass a list of i2c addresses that the i2c
> > core will probe for you: but this comes from the adapter driver, not from
> > the i2c module.
>
> This is a problem. The current procedure used by end users will stop working.
> It is a little worse: as the adapter driver has no means to know that some
> device could need tvaudio or other similar devices, we would need some hacking
> to allow the user to pass a parameter to the driver in order to test/load such
> drivers, since there's no documentation of when such things are needed.

The new i2c driver interface also supports a ->detect() method and a list
of address_data to use it with.  This is much more like the legacy model
than using i2c_new_probed_device().

I think a compatability layer than implements attach_adapter,
detach_adapter, and detach_client using a new-style driver's detect, probe,
remove, and address_data should not be that hard.

> > But v4l2-i2c-drv.h is bad enough, and even worse is what it looks like in
> > the kernel when the compat code has been stripped from it: it's turned into
> > a completely pointless header. And all the v4l2 i2c modules look peculiar
> > as well due to that header include.

As I've said before, the v4l2-i2c headers are lot more complicated than
they need to be.  I have a tree that's shrunk them greatly.  I don't think
it's fair to give the current headers as an example of how complicated i2c
backward compat _must_ be.

> This way, the development code won't have any #if's or compat code. I'm afraid
> that just using patches may also bring another range of troubles of needing to
> periodically maintain the backports. On the other hand, a syntax/semantic
> parser would be much more complex to develop.

IMHO, the ALSA method of providing a backward compatability package is much
inferior to the way v4l-dvb is doings thing.
