Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:57642 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754535Ab3DROE6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Apr 2013 10:04:58 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Igor Kugasyan <kugasyan@hotmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: mt9v034 driver
Date: Thu, 18 Apr 2013 16:05:03 +0200
Message-ID: <2715596.SBgtSHN5Uy@avalon>
In-Reply-To: <Pine.LNX.4.64.1304171609080.16330@axis700.grange>
References: <DUB112-W5AD3C17EE426206DFAEF9D2CE0@phx.gbl> <Pine.LNX.4.64.1304171609080.16330@axis700.grange>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Igor,

On Wednesday 17 April 2013 16:15:59 Guennadi Liakhovetski wrote:
> On Wed, 17 Apr 2013, Igor Kugasyan wrote:
> > Dear Mr. Guennadi,
> > 
> > Please tell me can I use the soc_camera_ (soc_camera.h, soc_camera.c)
> > interface for a mt9v034 driver as a mt9v022 driver or not?
> 
> I don't know anything about mt9v034. It might or might not be compatible
> with one of supported cameras. If it isn't, a new driver has to be
> developed.

I've put someone on that, so we should get mt9v034 support in mainline in the 
not too distant future.

> > I've read your Video4Linux soc-camera subsystem document and not found a
> > mt9v034 among client drivers. I have the Leopard Board 368 (LI-TB02) with
> > the WVGA camera
> 
> No, you cannot use soc-camera with Leopard Board. Its camera interface
> might be supported by some other driver, but I'm not sure about that.
> 
> >           LI-VM34LP but I haven't a mt9v034 driver for my camera
> > 
> > for the linux-2.6.32 kernel with RidgeRun
> 
> Don't think there's anything that can be done with any kernel apart from
> the current -next, i.e. the forthcoming 3.10.
> 
> >           2011Q2 SDK for LeopardBoardDM365 and
> > 
> > dvsdk_dm365-evm_4_02_00_06. I haven't sufficient experience for
> > comprehension but I learn...
> 
> The only possibility I see is to use a current kernel, adapt an existing
> or write a new camera sensor driver for mt9v034 and use it with the
> appropriate SoC camera interface driver.

-- 
Regards,

Laurent Pinchart

