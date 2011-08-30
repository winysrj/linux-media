Return-path: <linux-media-owner@vger.kernel.org>
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38332 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753877Ab1H3OAy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Aug 2011 10:00:54 -0400
Date: Tue, 30 Aug 2011 15:00:51 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Grant Likely <grant.likely@secretlab.ca>
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
Message-ID: <20110830140051.GH2061@opensource.wolfsonmicro.com>
References: <201107261647.19235.laurent.pinchart@ideasonboard.com>
 <201108081750.07000.laurent.pinchart@ideasonboard.com>
 <4E5A2657.7030605@gmail.com>
 <201108291508.59649.laurent.pinchart@ideasonboard.com>
 <Pine.LNX.4.64.1108300018490.5065@axis700.grange>
 <20110830134148.GA14976@sirena.org.uk>
 <20110830135609.GC1355@ponder.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110830135609.GC1355@ponder.secretlab.ca>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Aug 30, 2011 at 07:56:09AM -0600, Grant Likely wrote:
> On Tue, Aug 30, 2011 at 02:41:48PM +0100, Mark Brown wrote:

> > The events should only be generated after the probe() has succeeded so
> > if the driver talks to the hardware then it can fail probe() if need be.

> I'm a bit confused here.  Which events are you referring to, and which
> .probe call? (the i2c/spi/whatever probe, or the aggregate v4l2 probe?)

There's some driver model core level notifiers that are generated when
things manage to bind (postdating all the ASoC stuff for this IIRC, and
not covering the suspend/resume ordering issues).  Actually, thinking
about it they may be per bus.
