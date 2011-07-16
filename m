Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:62211 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655Ab1GPVkZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Jul 2011 17:40:25 -0400
Date: Sat, 16 Jul 2011 23:40:23 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] v4l: mt9v032: Fix Bayer pattern
In-Reply-To: <201107161152.09214.laurent.pinchart@ideasonboard.com>
Message-ID: <Pine.LNX.4.64.1107162206010.6202@axis700.grange>
References: <1310761106-29722-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <Pine.LNX.4.64.1107160109000.27399@axis700.grange>
 <201107161152.09214.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 16 Jul 2011, Laurent Pinchart wrote:

> Hi Guennadi,
> 
> On Saturday 16 July 2011 01:11:28 Guennadi Liakhovetski wrote:
> > On Fri, 15 Jul 2011, Laurent Pinchart wrote:
> > > Compute crop rectangle boundaries to ensure a GRBG Bayer pattern.
> > > 
> > > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > > ---
> > > 
> > >  drivers/media/video/mt9v032.c |   20 ++++++++++----------
> > >  1 files changed, 10 insertions(+), 10 deletions(-)
> > > 
> > > If there's no comment I'll send a pull request for this patch in a couple
> > > of days.
> > 
> > Hm, I might have a comment: why?... Isn't it natural to accept the fact,
> > that different sensors put a different Bayer pixel at their sensor matrix
> > origin? Isn't that why we have all possible Bayer formats? Maybe you just
> > have to choose a different output format?
> 
> That's the other solution. The driver currently claims the device outputs 
> SGRBG, but configures it to output SGBGR. This is clearly a bug. Is it better 
> to modify the format than the crop rectangle location ?

Actually, it is interesting. I just looked (again) in the mt9v032 and some 
other Aptina Bayer sensor datasheets, and they actually have _odd_ numbers 
of rows and columns. So, mt9v032 actually has 753x481 active pixels. And 
that extra pixel is explicitly provided to adjust the origin colour. Ok, 
they write, it is for uniformity with the mirrored image, but who believes 
them?;-) So, maybe you should adjust your max values to the above ones, 
then taking one pixel out of your image will not reduce your useful image 
size.

Thanks
Guennadi

> The OMAP3 ISP supports all Bayer formats, but the driver configures itself for 
> SGRBG by default. Using another pattern currently requires userspace software 
> to change several hardware-dependent parameters (including matrices and 
> tables). This should eventually be fixed in the OMAP3 ISP driver, but for the 
> time being application developers will have an easier life if the sensor 
> outputs SGRBG instead of SGBRG.
> 
> -- 
> Regards,
> 
> Laurent Pinchart
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
