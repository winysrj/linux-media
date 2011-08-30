Return-path: <linux-media-owner@vger.kernel.org>
Received: from cassiel.sirena.org.uk ([80.68.93.111]:51097 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753069Ab1H3NmJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Aug 2011 09:42:09 -0400
Date: Tue, 30 Aug 2011 14:41:48 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	devicetree-discuss@lists.ozlabs.org,
	Sylwester Nawrocki <snjw23@gmail.com>,
	Tuukka Toivonen <tuukka.toivonen@intel.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: [ANN] Meeting minutes of the Cambourne meeting
Message-ID: <20110830134148.GA14976@sirena.org.uk>
References: <201107261647.19235.laurent.pinchart@ideasonboard.com>
 <201108081750.07000.laurent.pinchart@ideasonboard.com>
 <4E5A2657.7030605@gmail.com>
 <201108291508.59649.laurent.pinchart@ideasonboard.com>
 <Pine.LNX.4.64.1108300018490.5065@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1108300018490.5065@axis700.grange>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Aug 30, 2011 at 12:20:09AM +0200, Guennadi Liakhovetski wrote:
> On Mon, 29 Aug 2011, Laurent Pinchart wrote:

> > My idea was to let the kernel register all devices based on the DT or board 
> > code. When the V4L2 host/bridge driver gets registered, it will then call a 
> > V4L2 core function with a list of subdevs it needs. The V4L2 core would store 
> > that information and react to bus notifier events to notify the V4L2 
> > host/bridge driver when all subdevs are present. At that point the host/bridge 
> > driver will get hold of all the subdevs and call (probably through the V4L2 
> > core) their .registered operation. That's where the subdevs will get access to 
> > their clock using clk_get().

> Correct me, if I'm wrong, but this seems to be the case of sensor (and 
> other i2c-client) drivers having to succeed their probe() methods without 
> being able to actually access the hardware?

The events should only be generated after the probe() has succeeded so
if the driver talks to the hardware then it can fail probe() if need be.
