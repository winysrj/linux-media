Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:7456 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753339AbZB0JKG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Feb 2009 04:10:06 -0500
Date: Fri, 27 Feb 2009 10:09:47 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Old Video ML <video4linux-list@redhat.com>
Subject: Re: Conversion of vino driver for SGI to not use the legacy decoder
 API
Message-ID: <20090227100947.160abd0b@hyperion.delvare>
In-Reply-To: <200902270819.17862.hverkuil@xs4all.nl>
References: <20090226214742.6576f30b@pedra.chehab.org>
	<200902270819.17862.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Fri, 27 Feb 2009 08:19:17 +0100, Hans Verkuil wrote:
> On Friday 27 February 2009 01:47:42 Mauro Carvalho Chehab wrote:
> > After the conversion of Zoran driver to V4L2, now almost all drivers are
> > using the new API. However, there are is one remaining driver using the
> > video_decoder.h API (based on V4L1 API) for message exchange between the
> > bridge driver and the i2c sensor: the vino driver.
> >
> > This driver adds support for the Indy webcam and for a capture hardware
> > on SGI. Does someone have those hardware? If so, are you interested on
> > helping to convert those drivers to fully use V4L2 API?
> >
> > The SGI driver is located at:
> > 	drivers/media/video/vino.c
> >
> > Due to vino, those two drivers are also using the old API:
> > 	drivers/media/video/indycam.c
> > 	drivers/media/video/saa7191.c
> >
> > It shouldn't be hard to convert those files to use the proper APIs, but
> > AFAIK none of the current active developers has any hardware for testing
> > it.
> 
> The conversion has already been done in my v4l-dvb-vino tree. I'm trying to 
> convince the original vino author to boot up his Indy and test it, but he 
> is not very interested in doing that. I'll ask him a few more times, but we 
> may have to just merge my code untested. Or perhaps just drop it.
> 
> Jean, I remember you mentioning that you wouldn't mind if the i2c-algo-sgi 
> code could be dropped which is only used by vino. How important is that to 
> you? Perhaps we are flogging a dead horse here and we should just let this 
> driver die.

My rant was based on the fact that i2c-algo-sgi is totally SGI-specific
while i2c-algo-* modules are supposed to be generic abstractions that
can be reused by a variety of hardware. So i2c-algo-sgi should really be
merged into drivers/media/video/vino.c. But as it takes a SGI system to
build-test such a change, and I don't have one, I am reluctant to do
it. If we can find a tester for your V4L2 conversion then maybe the
same tester will be able to test my own changes.

But i2c-algo-sgi isn't a big problem per se, it doesn't block further
evolutions or anything like that, so if we can't find a tester and it
has to stay for a few more years, this really isn't a problem for me.

-- 
Jean Delvare
