Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:59340 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756537AbZB0LWs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Feb 2009 06:22:48 -0500
Date: Fri, 27 Feb 2009 08:22:16 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Old Video ML <video4linux-list@redhat.com>,
	Douglas Landgraf <dougsland@gmail.com>
Subject: Re: Conversion of vino driver for SGI to not use the legacy decoder
 API
Message-ID: <20090227082216.574b42cf@pedra.chehab.org>
In-Reply-To: <20090227100947.160abd0b@hyperion.delvare>
References: <20090226214742.6576f30b@pedra.chehab.org>
	<200902270819.17862.hverkuil@xs4all.nl>
	<20090227100947.160abd0b@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 27 Feb 2009 10:09:47 +0100
Jean Delvare <khali@linux-fr.org> wrote:

> Hi Hans,
> 
> On Fri, 27 Feb 2009 08:19:17 +0100, Hans Verkuil wrote:
> > On Friday 27 February 2009 01:47:42 Mauro Carvalho Chehab wrote:
> > > After the conversion of Zoran driver to V4L2, now almost all drivers are
> > > using the new API. However, there are is one remaining driver using the
> > > video_decoder.h API (based on V4L1 API) for message exchange between the
> > > bridge driver and the i2c sensor: the vino driver.
> > >
> > > This driver adds support for the Indy webcam and for a capture hardware
> > > on SGI. Does someone have those hardware? If so, are you interested on
> > > helping to convert those drivers to fully use V4L2 API?
> > >
> > > The SGI driver is located at:
> > > 	drivers/media/video/vino.c
> > >
> > > Due to vino, those two drivers are also using the old API:
> > > 	drivers/media/video/indycam.c
> > > 	drivers/media/video/saa7191.c
> > >
> > > It shouldn't be hard to convert those files to use the proper APIs, but
> > > AFAIK none of the current active developers has any hardware for testing
> > > it.
> > 
> > The conversion has already been done in my v4l-dvb-vino tree. 

Great! Do you have any other tree converting drivers from V4L1 to V4L2 API?
Btw, we should update the dependencies for the converted drivers. They are
still dependent of V4L1:

config VIDEO_BT819
        tristate "BT819A VideoStream decoder"
        depends on VIDEO_V4L1 && I2C

I'll do such update probably later today. I want to have an overall picture on
what's still left.

> > I'm trying to 
> > convince the original vino author to boot up his Indy and test it, but he 
> > is not very interested in doing that. I'll ask him a few more times, but we 
> > may have to just merge my code untested. Or perhaps just drop it.

Well, let's merge the code. Maybe someone at the ML could have an Indy and can test it.

I think that the risk of breaking vino is not big, since this conversion is
more like a variable renaming. Also, after applying those changes at
linux-next, more people can test its code. Maybe we can add some printk's
asking for testers to contact us at LMML.

I would love to finally remove another V4L1 header (video_decoder.h).

> > Jean, I remember you mentioning that you wouldn't mind if the i2c-algo-sgi 
> > code could be dropped which is only used by vino. How important is that to 
> > you? Perhaps we are flogging a dead horse here and we should just let this 
> > driver die.
> 
> My rant was based on the fact that i2c-algo-sgi is totally SGI-specific
> while i2c-algo-* modules are supposed to be generic abstractions that
> can be reused by a variety of hardware. So i2c-algo-sgi should really be
> merged into drivers/media/video/vino.c. But as it takes a SGI system to
> build-test such a change, and I don't have one, I am reluctant to do
> it. If we can find a tester for your V4L2 conversion then maybe the
> same tester will be able to test my own changes.
> 
> But i2c-algo-sgi isn't a big problem per se, it doesn't block further
> evolutions or anything like that, so if we can't find a tester and it
> has to stay for a few more years, this really isn't a problem for me.

If the merger of i2c-algo-sgi is as not something complex, then we can try to
merge and apply at vino. Otherwise, we can just keep as-is.

PS.: probably you haven't noticed, but tea575x-tuner.c is still V4L1 (one of
your patches changed the header improperly, breaking sound build). 

Douglas,

As you've done several radio conversions to V4L2 API, maybe you can also handle
this one.

Cheers,
Mauro
