Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:55080 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970Ab1GQWay (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jul 2011 18:30:54 -0400
Date: Mon, 18 Jul 2011 00:30:52 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] v4l: mt9v032: Fix Bayer pattern
In-Reply-To: <201107180022.52876.laurent.pinchart@ideasonboard.com>
Message-ID: <Pine.LNX.4.64.1107180028460.13485@axis700.grange>
References: <1310761106-29722-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <201107172334.29292.laurent.pinchart@ideasonboard.com>
 <Pine.LNX.4.64.1107180013220.13485@axis700.grange>
 <201107180022.52876.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 18 Jul 2011, Laurent Pinchart wrote:

> On Monday 18 July 2011 00:14:21 Guennadi Liakhovetski wrote:
> > On Sun, 17 Jul 2011, Laurent Pinchart wrote:
> > > Hi Guennadi,
> > > 
> > > On Saturday 16 July 2011 23:40:23 Guennadi Liakhovetski wrote:
> > > > On Sat, 16 Jul 2011, Laurent Pinchart wrote:
> > > > > On Saturday 16 July 2011 01:11:28 Guennadi Liakhovetski wrote:
> > > > > > On Fri, 15 Jul 2011, Laurent Pinchart wrote:
> > > > > > > Compute crop rectangle boundaries to ensure a GRBG Bayer pattern.
> > > > > > > 
> > > > > > > Signed-off-by: Laurent Pinchart
> > > > > > > <laurent.pinchart@ideasonboard.com> ---
> > > > > > > 
> > > > > > >  drivers/media/video/mt9v032.c |   20 ++++++++++----------
> > > > > > >  1 files changed, 10 insertions(+), 10 deletions(-)
> > > > > > > 
> > > > > > > If there's no comment I'll send a pull request for this patch in
> > > > > > > a couple of days.
> > > > > > 
> > > > > > Hm, I might have a comment: why?... Isn't it natural to accept the
> > > > > > fact, that different sensors put a different Bayer pixel at their
> > > > > > sensor matrix origin? Isn't that why we have all possible Bayer
> > > > > > formats? Maybe you just have to choose a different output format?
> > > > > 
> > > > > That's the other solution. The driver currently claims the device
> > > > > outputs SGRBG, but configures it to output SGBGR. This is clearly a
> > > > > bug. Is it better to modify the format than the crop rectangle
> > > > > location ?
> > > > 
> > > > Actually, it is interesting. I just looked (again) in the mt9v032 and
> > > > some other Aptina Bayer sensor datasheets, and they actually have
> > > > _odd_ numbers of rows and columns. So, mt9v032 actually has 753x481
> > > > active pixels. And that extra pixel is explicitly provided to adjust
> > > > the origin colour. Ok, they write, it is for uniformity with the
> > > > mirrored image, but who believes them?;-) So, maybe you should adjust
> > > > your max values to the above ones, then taking one pixel out of your
> > > > image will not reduce your useful image size.
> > > 
> > > I'm not sure what you mean. Even though the pixel array is bigger than
> > > that, the maximum output width/height are 752x480 according to the
> > > datasheet.
> > 
> > Have a look at the "Pixel array structure" (p.10 in my version) section.
> 
> I've seen that, but the sensor is still unable to output an image bigger than 
> 752x480. See registers 3 and 4 maximum values on page 24 (in my version :-)).

Right, sorry, what I mean, is, that even when you use one pixel to adjust 
your image origin, you don't actually lose the size. So, you can output 
752 pixels in a row whether you begin at 0 or 1. That's why I suggested to 
set max width to 753, but then make sure it's always actually even. That 
way a configuration offset = 1, width = 752 will also be valid.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
