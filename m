Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:28616 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572AbZBUNLq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Feb 2009 08:11:46 -0500
Date: Sat, 21 Feb 2009 14:11:30 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Trent Piepho <xyzzy@speakeasy.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hverkuil@xs4all.nl>, urishk@yahoo.com,
	linux-media@vger.kernel.org
Subject: Re: Minimum kernel version supported by v4l-dvb
Message-ID: <20090221141130.1c4f1265@hyperion.delvare>
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

Hi Trent,

On Sat, 21 Feb 2009 04:06:53 -0800 (PST), Trent Piepho wrote:
> On Fri, 20 Feb 2009, Mauro Carvalho Chehab wrote:
> > On Sat, 21 Feb 2009 02:12:53 +0100
> > Hans Verkuil <hverkuil@xs4all.nl> wrote:
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

Correct.

> I think a compatability layer than implements attach_adapter,
> detach_adapter, and detach_client using a new-style driver's detect, probe,
> remove, and address_data should not be that hard.

Well, that's basically what Hans has been doing with
v4l2-i2c-drv-legacy.h for months now, isn't it? This is the easy part
(even though even this wasn't exactly trivial...)

The hard part is when you want to use pure new-style i2c binding (using
i2c_new_device() or i2c_new_probed_device()) in the upstream kernel.
There is simply no equivalent in pre-2.6.22 kernels. So no matter what
amount of compatibility code you add (and it would get _a lot_ of
compatibility code to get there), at best you will get a different
behavior between new and old kernels, worst case the driver will simply
not work in old kernels.

> > > But v4l2-i2c-drv.h is bad enough, and even worse is what it looks like in
> > > the kernel when the compat code has been stripped from it: it's turned into
> > > a completely pointless header. And all the v4l2 i2c modules look peculiar
> > > as well due to that header include.
> 
> As I've said before, the v4l2-i2c headers are lot more complicated than
> they need to be.  I have a tree that's shrunk them greatly.  I don't think
> it's fair to give the current headers as an example of how complicated i2c
> backward compat _must_ be.

Well, why don't send your patches out to Hans and myself for review? If
you came up with simplifications that work, we will be very happy to
apply them.

Thanks,
-- 
Jean Delvare
