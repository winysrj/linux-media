Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:33256 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386Ab2KLLWm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Nov 2012 06:22:42 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Dario Carmignani <carmignani.dario@gmail.com>
Cc: g.liakhovetski@gmx.de,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: mt9t031-VPFE integration issues...
Date: Mon, 12 Nov 2012 12:23:36 +0100
Message-ID: <6068465.jCEtSekhgB@avalon>
In-Reply-To: <CAAXAVK013mjBg4v6JN_hMS5kS6sPEQfOjwtmyBP+c6CngswwmQ@mail.gmail.com>
References: <Pine.LNX.4.64.0910030105570.6075@axis700.grange> <Pine.LNX.4.64.1211101434490.13812@axis700.grange> <CAAXAVK013mjBg4v6JN_hMS5kS6sPEQfOjwtmyBP+c6CngswwmQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Dario,

On Saturday 10 November 2012 16:58:05 Dario Carmignani wrote:
> Hi,
> Thank you.
> 
> The main issue I have is that when I use vpfe system and soc camera at the
> same time, I'm able to register ov772x i2c address with soc system, but vpfe
> seems not to be able to register ov772x device because it is now linked to
> the soc. But maybe I'm not doing the right thing.

I've hacked the ov772x driver for use with the OMAP3 ISP driver. You can find 
the patches at 
http://git.linuxtv.org/pinchartl/media.git/shortlog/refs/heads/board/beagle/ov772x. 
They're not upstreamable as-is, work is in progress to implement a proper 
solution, but that will still need time. I don't expect a solution in mainline 
before v3.9, if not v3.10.

> Il giorno 10-nov-2012 14:56, "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
> ha scritto:
> > On Sat, 10 Nov 2012, Carmignani Dario wrote:
> > > Hi,
> > > 
> > > thanks for the answer.
> > > 
> > > Sorry, but I actually have not so clear how I can use soc-camera sensor
> > > driver with, for example, vpfe for dm365.
> > > 
> > > Can you please give me some hints?
> > 
> > Sorry, I'm not working with those systems. I don't even have access to
> > non-soc-camera systems with soc-camera-based sensors. Basically you'll
> > have to take a mainline camera-enabled dm365-based board (if there are
> > any) as an example and use struct soc_camera_link as platform data for the
> > ov772x driver. I think, Laurent (cc'ed) has a git-tree online somewhere
> > with an example, using soc-camera originated sensor drivers with a
> > non-soc-camera system. Try to find his mail about this on the list.
> >
> > > > Guennadi Liakhovetski <mailto:g.liakhovetski@gmx.de>
> > > > 10 novembre 2012 13:44
> > > > 
> > > > > Hi,
> > > > > 
> > > > > I've just wrote you a while ago.
> > > > > 
> > > > > I'm working on a different sensor, but that is based on soc-camera
> > > > > framework as well: ov772x.
> > > > > 
> > > > > I've tried to remove in the ov772x driver the most part of the
> > > > > dependecy from soc-camera. But I guess that I've remove also the bus
> > > > > negotiation, without substituting it with something else.
> > > > > 
> > > > > Have you tried to do something similar on MT9t031 sensor?
> > > > 
> > > > In principle it's not too difficult to use soc-camera sensor drivers
> > > > with non-soc-camera hosts, it should be possible already now without
> > > > any sensor driver (most drivers, including ov772x; mt9t031 would be a
> > > > bit more difficult because of its power management, but if you don't
> > > > need it, it can be disabled) modifications. However, currencly such
> > > > driver re-use is not very elegant or natural. Work is in progress to
> > > > improve it. So, you can either try now or wait until those
> > > > improvements are in place, don't hold your breath though.

-- 
Regards,

Laurent Pinchart

