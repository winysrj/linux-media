Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:53158 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755937Ab1H3UMH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Aug 2011 16:12:07 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [ANN] Meeting minutes of the Cambourne meeting
Date: Tue, 30 Aug 2011 22:12:30 +0200
Cc: Grant Likely <grant.likely@secretlab.ca>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Sylwester Nawrocki <snjw23@gmail.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	devicetree-discuss@lists.ozlabs.org,
	"linux-media" <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Tuukka Toivonen <tuukka.toivonen@intel.com>
References: <201107261647.19235.laurent.pinchart@ideasonboard.com> <201108301742.56581.laurent.pinchart@ideasonboard.com> <20110830154642.GM2061@opensource.wolfsonmicro.com>
In-Reply-To: <20110830154642.GM2061@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108302212.31144.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mark,

On Tuesday 30 August 2011 17:46:42 Mark Brown wrote:
> On Tue, Aug 30, 2011 at 05:42:55PM +0200, Laurent Pinchart wrote:
> > A dependency system is tempting but will be very complex to implement
> > properly, especially when faced with cyclic dependencies. For instance
> > the OMAP3 ISP driver requires the camera sensor device to be present to
> > proceed, and the camera sensor requires a clock provided by the OMAP3
> > ISP. To solve this we need to probe the OMAP3 ISP first, have it
> > register its clock devices, and then wait until all sensors become
> > available.
> 
> With composite devices like that where the borad has sufficient
> interesting stuff on it representing the board itself as a device (this
> is what ASoC does).
> 
> > A probe deferral system is probably simpler, but it will have its share
> > of problems as well. In the above example, if the sensor is probed
> > first, the driver can return -EAGAIN in the probe() method as the clock
> > isn't available yet (I'm not sure how to differentiate between "not
> > available yet" and "not present in the system" though). However, if the
> > OMAP3 ISP is probed first, returning -EAGAIN in its probe() method won't
> > really help, as we need to register the clock before waiting for the
> > sensor.
> 
> Having a device for the camera subsystem as a whole breaks this loop as
> the probe of that device triggers the overall system probe.

The exact same idea crossed my mind after hitting the "Send" button :-)

Would such a device be included in the DT ? My understanding is that the DT 
should only describe the hardware.

-- 
Regards,

Laurent Pinchart
