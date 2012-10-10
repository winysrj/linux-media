Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:35693 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198Ab2JJXE1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Oct 2012 19:04:27 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Grant Likely <grant.likely@secretlab.ca>,
	Thomas Abraham <thomas.abraham@linaro.org>,
	Tomasz Figa <t.figa@samsung.com>
Subject: Re: [PATCH 05/14] media: add a V4L2 OF parser
Date: Thu, 11 Oct 2012 01:05:10 +0200
Message-ID: <27000679.ByCzfmu97G@avalon>
In-Reply-To: <Pine.LNX.4.64.1210102229200.31291@axis700.grange>
References: <1348754853-28619-1-git-send-email-g.liakhovetski@gmx.de> <5075D947.3080903@gmail.com> <Pine.LNX.4.64.1210102229200.31291@axis700.grange>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Wednesday 10 October 2012 22:32:22 Guennadi Liakhovetski wrote:
> On Wed, 10 Oct 2012, Sylwester Nawrocki wrote:
> > On 10/10/2012 03:25 PM, Laurent Pinchart wrote:
> > > On Tuesday 09 October 2012 13:00:24 Hans Verkuil wrote:
> > >> On Tue 9 October 2012 12:34:48 Sylwester Nawrocki wrote:
> > >>> On 10/08/2012 11:40 AM, Guennadi Liakhovetski wrote:
> > >>>> On Fri, 5 Oct 2012, Sylwester Nawrocki wrote:
> > >>>>> I would really like to see more than one user until we add any core
> > >>>>> code. No that it couldn't be changed afterwards, but it would be
> > >>>>> nice to ensure the concepts are right and proven in real life.
> > >>>> 
> > >>>> Unfortunately I don't have any more systems on which I could easily
> > >>>> enough try this. I've got a beagleboard with a camera, but I don't
> > >>>> think I'm a particularly good candidate for implementing DT support
> > >>>> for OMAP3 camera drivers;-) Apart from that I've only got soc-camera
> > >>>> based systems, of which none are _really_ DT-ready... At best I could
> > >>>> try an i.MX31 based board, but that doesn't have a very well
> > >>>> developed .dts and that would be soc-camera too anyway.
> > >>> 
> > >>> I certainly wouldn't expect you would do all the job. I mean it would
> > >>> be good to possibly have some other developers adding device tree
> > >>> support based on that new bindings and new infrastructure related to
> > >>> them.
> > > 
> > > As I mentioned in another e-mail, I plan to work on DT support for the
> > > OMAP3 ISP, but I first need generic clock framework support for OMAP3.
> > 
> > OK, let's hope it's available soon.
> > 
> > >>> There have been recently some progress in device tree support for
> > >>> Exynos SoCs, including common clock framework support and we hope to
> > >>> add FDT support to the Samsung SoC camera devices during this kernel
> > >>> cycle, based on the newly designed media bindings. This is going to be
> > >>> a second attempt, after our initial RFC from May [1]. It would still
> > >>> be SoC specific implementation, but not soc-camera based.
> > >>> 
> > >>> I wasn't a big fan of this asynchronous sub-devices probing, but it
> > >>> now seems to be a most complete solution to me. I think it just need
> > >>> to be done right at the v4l2-core so individual drivers don't get
> > >>> complicated too much.
> > >> 
> > >> After investigating this some more I think I agree with that. There are
> > >> some things where we should probably ask for advice from the i2c
> > >> subsystem devs, I'm thinking of putting the driver back into the
> > >> deferred-probe state in particular.
> > > 
> > > We might actually not need that, it might be easier to handle the
> > > circular dependency problem from the other end. We could add a way
> > > (ioctl, sysfs, ...) to force a V4L2 bridge driver to release its
> > > subdevs. Once done, the subdev driver could be unloaded and/or the
> > > subdev device unregistered, which would release the resources used by
> > > the subdev, such as clocks. The bridge driver could then be
> > > unregistered.
> > 
> > That sounds like an option. Perhaps it could be done by v4l2-core, e.g. a
> > sysfs entry could be registered for a media or video device if driver
> > requests it. I'm not sure if we should allow subdevs in "released" state,
> > perhaps it's better to just unregister subdevs entirely right away ?
> 
> What speaks against holding a clock reference only during streaming, or at
> least between open and close? Wouldn't that solve the problem naturally?
> Yes, after giving up your reference to a clock at close() and re-acquiring
> it at open() you will have to make sure the frequency hasn't change, resp.
> adjust it, but I don't see it as a huge problem, I don't think many users
> on embedded systems will compete for your camera master clock. And if they
> do, you have a different problem, IMHO;-)

That's an option as well. I'm a bit worried that it would make subdev drivers 
more complex, as they would need to acquire/release resources in a more fine-
grained fashion at runtime, and handle failures dynamically there instead of 
doing it all at probe time. It could work though, I think we need to 
experiment the possible solutions to find out which one is the best.

Regardless of how we solve the circular dependencies issue at unregistration 
time we will need an easy way for bridge drivers to bind to subdevs. I believe 
that's orthogonal to the unregistration problem, so we can start working on 
registration before knowing exactly how unregistration will be handled.

> > >> Creating v4l2-core support for this is crucial as it is quite complex
> > >> and without core support this is going to be a nightmare for drivers.

-- 
Regards,

Laurent Pinchart

