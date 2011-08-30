Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:46112 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755471Ab1H3Pm3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Aug 2011 11:42:29 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [ANN] Meeting minutes of the Cambourne meeting
Date: Tue, 30 Aug 2011 17:42:55 +0200
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
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
References: <201107261647.19235.laurent.pinchart@ideasonboard.com> <Pine.LNX.4.64.1108301600020.19151@axis700.grange> <CACxGe6tCLJ6F-Rsf=1ENj98YzXHRm9p9xr4-TAiWTHpQbQVOVA@mail.gmail.com>
In-Reply-To: <CACxGe6tCLJ6F-Rsf=1ENj98YzXHRm9p9xr4-TAiWTHpQbQVOVA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108301742.56581.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 30 August 2011 17:18:31 Grant Likely wrote:
> On Tue, Aug 30, 2011 at 8:03 AM, Guennadi Liakhovetski
> 
> <g.liakhovetski@gmx.de> wrote:
> > Hi Grant
> > 
> > On Tue, 30 Aug 2011, Grant Likely wrote:
> >> On Tue, Aug 30, 2011 at 02:41:48PM +0100, Mark Brown wrote:
> >> > On Tue, Aug 30, 2011 at 12:20:09AM +0200, Guennadi Liakhovetski wrote:
> >> > > On Mon, 29 Aug 2011, Laurent Pinchart wrote:
> >> > > > My idea was to let the kernel register all devices based on the DT
> >> > > > or board code. When the V4L2 host/bridge driver gets registered,
> >> > > > it will then call a V4L2 core function with a list of subdevs it
> >> > > > needs. The V4L2 core would store that information and react to
> >> > > > bus notifier events to notify the V4L2 host/bridge driver when
> >> > > > all subdevs are present. At that point the host/bridge
> >> 
> >> Sounds a lot like what ASoC is currently doing.
> >> 
> >> > > > driver will get hold of all the subdevs and call (probably through
> >> > > > the V4L2 core) their .registered operation. That's where the
> >> > > > subdevs will get access to their clock using clk_get().
> >> > > 
> >> > > Correct me, if I'm wrong, but this seems to be the case of sensor
> >> > > (and other i2c-client) drivers having to succeed their probe()
> >> > > methods without being able to actually access the hardware?
> >> 
> >> It indeed sounds like that, which also concerns me.  ASoC and other
> >> subsystems have exactly the same problem where the 'device' is
> >> actually an aggregate of multiple devices attached to different
> >> busses.  My personal opinion is that the best way to handle this is to
> >> support deferred probing
> > 
> > Yes, that's also what I think should be done. But I was thinking about a
> > slightly different approach - a dependency-based probing. I.e., you
> > should be able to register a device, depending on another one (parent?),
> > and only after the latter one has successfully probed, the driver core
> > should be allowed to probe the child. Of course, devices can depend on
> > multiple other devices, so, a single parent might not be enough.
> 
> Yes, a dependency system would be lovely... but it gets really complex
> in a hurry, especially when faced with heterogeneous device
> registrations.  A deferral system ends up being really simple to
> implement and probably work just as well.

The core issue is that physical device trees, clock trees, power trees and 
logical device tress are not always aligned. Instanciating devices based on 
the parent-child device relationships will always lead to situations where a 
device probe() method will be called with clocks or power sources not 
available yet.

A dependency system is tempting but will be very complex to implement 
properly, especially when faced with cyclic dependencies. For instance the 
OMAP3 ISP driver requires the camera sensor device to be present to proceed, 
and the camera sensor requires a clock provided by the OMAP3 ISP. To solve 
this we need to probe the OMAP3 ISP first, have it register its clock devices, 
and then wait until all sensors become available.

A probe deferral system is probably simpler, but it will have its share of 
problems as well. In the above example, if the sensor is probed first, the 
driver can return -EAGAIN in the probe() method as the clock isn't available 
yet (I'm not sure how to differentiate between "not available yet" and "not 
present in the system" though). However, if the OMAP3 ISP is probed first, 
returning -EAGAIN in its probe() method won't really help, as we need to 
register the clock before waiting for the sensor.

-- 
Regards,

Laurent Pinchart
