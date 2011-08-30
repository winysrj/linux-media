Return-path: <linux-media-owner@vger.kernel.org>
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33144 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755391Ab1H3Pqq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Aug 2011 11:46:46 -0400
Date: Tue, 30 Aug 2011 16:46:42 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Sylwester Nawrocki <snjw23@gmail.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	devicetree-discuss@lists.ozlabs.org,
	linux-media <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Tuukka Toivonen <tuukka.toivonen@intel.com>
Subject: Re: [ANN] Meeting minutes of the Cambourne meeting
Message-ID: <20110830154642.GM2061@opensource.wolfsonmicro.com>
References: <201107261647.19235.laurent.pinchart@ideasonboard.com>
 <Pine.LNX.4.64.1108301600020.19151@axis700.grange>
 <CACxGe6tCLJ6F-Rsf=1ENj98YzXHRm9p9xr4-TAiWTHpQbQVOVA@mail.gmail.com>
 <201108301742.56581.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201108301742.56581.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Aug 30, 2011 at 05:42:55PM +0200, Laurent Pinchart wrote:

> A dependency system is tempting but will be very complex to implement 
> properly, especially when faced with cyclic dependencies. For instance the 
> OMAP3 ISP driver requires the camera sensor device to be present to proceed, 
> and the camera sensor requires a clock provided by the OMAP3 ISP. To solve 
> this we need to probe the OMAP3 ISP first, have it register its clock devices, 
> and then wait until all sensors become available.

With composite devices like that where the borad has sufficient
interesting stuff on it representing the board itself as a device (this
is what ASoC does).

> A probe deferral system is probably simpler, but it will have its share of 
> problems as well. In the above example, if the sensor is probed first, the 
> driver can return -EAGAIN in the probe() method as the clock isn't available 
> yet (I'm not sure how to differentiate between "not available yet" and "not 
> present in the system" though). However, if the OMAP3 ISP is probed first, 
> returning -EAGAIN in its probe() method won't really help, as we need to 
> register the clock before waiting for the sensor.

Having a device for the camera subsystem as a whole breaks this loop as
the probe of that device triggers the overall system probe.
