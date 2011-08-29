Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:53777 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753838Ab1H2Wid (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Aug 2011 18:38:33 -0400
Date: Tue, 30 Aug 2011 00:38:12 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: Sylwester Nawrocki <snjw23@gmail.com>,
	linux-media <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Tuukka Toivonen <tuukka.toivonen@intel.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	devicetree-discuss@lists.ozlabs.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [ANN] Meeting minutes of the Cambourne meeting
In-Reply-To: <201108300026.05489.laurent.pinchart@ideasonboard.com>
Message-ID: <Pine.LNX.4.64.1108300035430.5065@axis700.grange>
References: <201107261647.19235.laurent.pinchart@ideasonboard.com>
 <201108291508.59649.laurent.pinchart@ideasonboard.com>
 <Pine.LNX.4.64.1108300018490.5065@axis700.grange>
 <201108300026.05489.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 30 Aug 2011, Laurent Pinchart wrote:

> Hi Guennadi,
> 
> On Tuesday 30 August 2011 00:20:09 Guennadi Liakhovetski wrote:
> > On Mon, 29 Aug 2011, Laurent Pinchart wrote:
> > 
> > [snip]
> > 
> > > My idea was to let the kernel register all devices based on the DT or
> > > board code. When the V4L2 host/bridge driver gets registered, it will
> > > then call a V4L2 core function with a list of subdevs it needs. The V4L2
> > > core would store that information and react to bus notifier events to
> > > notify the V4L2 host/bridge driver when all subdevs are present. At that
> > > point the host/bridge driver will get hold of all the subdevs and call
> > > (probably through the V4L2 core) their .registered operation. That's
> > > where the subdevs will get access to their clock using clk_get().
> > 
> > Correct me, if I'm wrong, but this seems to be the case of sensor (and
> > other i2c-client) drivers having to succeed their probe() methods without
> > being able to actually access the hardware?
> 
> That's right. I'd love to find a better way :-) Note that this is already the 
> case for many subdev drivers that probe the hardware in the .registered() 
> operation instead of the probe() method.

Then why do you think it is better, than adding devices from bridge 
drivers? Think about hotpluggable devices - drivers create devices all the 
time - USB etc. Why cannot we do the same? As a historic reference: 
soc-camera used to do this too before - probe without hardware access and 
"really-probe" after the host turns on the clock. Then we switched to 
registering devices later. I like the present approach better.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
