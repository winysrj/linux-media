Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:3749 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbZBUN2k (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Feb 2009 08:28:40 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Jean Delvare <khali@linux-fr.org>
Subject: Re: Minimum kernel version supported by v4l-dvb
Date: Sat, 21 Feb 2009 14:28:31 +0100
Cc: Trent Piepho <xyzzy@speakeasy.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	urishk@yahoo.com, linux-media@vger.kernel.org
References: <43235.62.70.2.252.1234947353.squirrel@webmail.xs4all.nl> <Pine.LNX.4.58.0902210343520.24268@shell2.speakeasy.net> <20090221141130.1c4f1265@hyperion.delvare>
In-Reply-To: <20090221141130.1c4f1265@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902211428.31814.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Saturday 21 February 2009 14:11:30 Jean Delvare wrote:
> Hi Trent,
>
> On Sat, 21 Feb 2009 04:06:53 -0800 (PST), Trent Piepho wrote:
> > On Fri, 20 Feb 2009, Mauro Carvalho Chehab wrote:
> > > On Sat, 21 Feb 2009 02:12:53 +0100
> > >
> > > Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > > > That's what the i2c_new_probed_device() call is for (called through
> > > > v4l2_i2c_new_probed_subdev). You pass a list of i2c addresses that
> > > > the i2c core will probe for you: but this comes from the adapter
> > > > driver, not from the i2c module.
> > >
> > > This is a problem. The current procedure used by end users will stop
> > > working. It is a little worse: as the adapter driver has no means to
> > > know that some device could need tvaudio or other similar devices, we
> > > would need some hacking to allow the user to pass a parameter to the
> > > driver in order to test/load such drivers, since there's no
> > > documentation of when such things are needed.
> >
> > The new i2c driver interface also supports a ->detect() method and a
> > list of address_data to use it with.  This is much more like the legacy
> > model than using i2c_new_probed_device().
>
> Correct.
>
> > I think a compatability layer than implements attach_adapter,
> > detach_adapter, and detach_client using a new-style driver's detect,
> > probe, remove, and address_data should not be that hard.
>
> Well, that's basically what Hans has been doing with
> v4l2-i2c-drv-legacy.h for months now, isn't it? This is the easy part
> (even though even this wasn't exactly trivial...)

Sorry, that's not quite true. v4l2-i2c-drv-legacy.h is for i2c modules that 
are either called new-style (by converted adapter drivers) or old-style (by 
not-yet converted adapter drivers). It does that by creating two i2c_driver 
instances, one for each variant. By contrast, i2c modules that include 
v4l2-i2c-drv.h can only be called by converted adapter drivers. This has 
nothing to do with detect(). I'm not using that at all.

It was always the intention that the legacy.h header would disappear once 
all adapter drivers are converted. But v4l2-i2c-drv.h still has to support 
kernels < 2.6.22 were the new API doesn't exist at all. That's the sticking 
point that prevents us from dropping this header as well and go back to a 
normally written i2c module without all this nonsense.

You may have meant the same thing, Jean, but I thought I should clarify it 
yet a bit more :-)

> The hard part is when you want to use pure new-style i2c binding (using
> i2c_new_device() or i2c_new_probed_device()) in the upstream kernel.
> There is simply no equivalent in pre-2.6.22 kernels. So no matter what
> amount of compatibility code you add (and it would get _a lot_ of
> compatibility code to get there), at best you will get a different
> behavior between new and old kernels, worst case the driver will simply
> not work in old kernels.
>
> > > > But v4l2-i2c-drv.h is bad enough, and even worse is what it looks
> > > > like in the kernel when the compat code has been stripped from it:
> > > > it's turned into a completely pointless header. And all the v4l2
> > > > i2c modules look peculiar as well due to that header include.
> >
> > As I've said before, the v4l2-i2c headers are lot more complicated than
> > they need to be.  I have a tree that's shrunk them greatly.  I don't
> > think it's fair to give the current headers as an example of how
> > complicated i2c backward compat _must_ be.
>
> Well, why don't send your patches out to Hans and myself for review? If
> you came up with simplifications that work, we will be very happy to
> apply them.

The point is not how easy or complicated these headers are, the point is 
that we shouldn't have them at all since they make no sense in the upstream 
kernel.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
