Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:47144 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753877Ab1H3N4N (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Aug 2011 09:56:13 -0400
Received: by pzk37 with SMTP id 37so10347349pzk.1
        for <linux-media@vger.kernel.org>; Tue, 30 Aug 2011 06:56:13 -0700 (PDT)
Date: Tue, 30 Aug 2011 07:56:09 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Sylwester Nawrocki <snjw23@gmail.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	devicetree-discuss@lists.ozlabs.org,
	linux-media <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Tuukka Toivonen <tuukka.toivonen@intel.com>
Subject: Re: [ANN] Meeting minutes of the Cambourne meeting
Message-ID: <20110830135609.GC1355@ponder.secretlab.ca>
References: <201107261647.19235.laurent.pinchart@ideasonboard.com>
 <201108081750.07000.laurent.pinchart@ideasonboard.com>
 <4E5A2657.7030605@gmail.com>
 <201108291508.59649.laurent.pinchart@ideasonboard.com>
 <Pine.LNX.4.64.1108300018490.5065@axis700.grange>
 <20110830134148.GA14976@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110830134148.GA14976@sirena.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Aug 30, 2011 at 02:41:48PM +0100, Mark Brown wrote:
> On Tue, Aug 30, 2011 at 12:20:09AM +0200, Guennadi Liakhovetski wrote:
> > On Mon, 29 Aug 2011, Laurent Pinchart wrote:
> 
> > > My idea was to let the kernel register all devices based on the DT or board 
> > > code. When the V4L2 host/bridge driver gets registered, it will then call a 
> > > V4L2 core function with a list of subdevs it needs. The V4L2 core would store 
> > > that information and react to bus notifier events to notify the V4L2 
> > > host/bridge driver when all subdevs are present. At that point the host/bridge 

Sounds a lot like what ASoC is currently doing.

> > > driver will get hold of all the subdevs and call (probably through the V4L2 
> > > core) their .registered operation. That's where the subdevs will get access to 
> > > their clock using clk_get().
> 
> > Correct me, if I'm wrong, but this seems to be the case of sensor (and 
> > other i2c-client) drivers having to succeed their probe() methods without 
> > being able to actually access the hardware?

It indeed sounds like that, which also concerns me.  ASoC and other
subsystems have exactly the same problem where the 'device' is
actually an aggregate of multiple devices attached to different
busses.  My personal opinion is that the best way to handle this is to
support deferred probing so that a driver can fail with -EAGAIN if all
the resources that it requires are not available immediately, and have
the driver core retry the probe after other devices have successfully
probed.

I've got prototype code for this, but it needs some more work before
being mainlined.

> The events should only be generated after the probe() has succeeded so
> if the driver talks to the hardware then it can fail probe() if need be.

I'm a bit confused here.  Which events are you referring to, and which
.probe call? (the i2c/spi/whatever probe, or the aggregate v4l2 probe?)

