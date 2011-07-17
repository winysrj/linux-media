Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:39069 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177Ab1GQVeZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jul 2011 17:34:25 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] v4l: mt9v032: Fix Bayer pattern
Date: Sun, 17 Jul 2011 23:34:29 +0200
Cc: linux-media@vger.kernel.org
References: <1310761106-29722-1-git-send-email-laurent.pinchart@ideasonboard.com> <201107161152.09214.laurent.pinchart@ideasonboard.com> <Pine.LNX.4.64.1107162206010.6202@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1107162206010.6202@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107172334.29292.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Saturday 16 July 2011 23:40:23 Guennadi Liakhovetski wrote:
> On Sat, 16 Jul 2011, Laurent Pinchart wrote:
> > On Saturday 16 July 2011 01:11:28 Guennadi Liakhovetski wrote:
> > > On Fri, 15 Jul 2011, Laurent Pinchart wrote:
> > > > Compute crop rectangle boundaries to ensure a GRBG Bayer pattern.
> > > > 
> > > > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > > > ---
> > > > 
> > > >  drivers/media/video/mt9v032.c |   20 ++++++++++----------
> > > >  1 files changed, 10 insertions(+), 10 deletions(-)
> > > > 
> > > > If there's no comment I'll send a pull request for this patch in a
> > > > couple of days.
> > > 
> > > Hm, I might have a comment: why?... Isn't it natural to accept the
> > > fact, that different sensors put a different Bayer pixel at their
> > > sensor matrix origin? Isn't that why we have all possible Bayer
> > > formats? Maybe you just have to choose a different output format?
> > 
> > That's the other solution. The driver currently claims the device outputs
> > SGRBG, but configures it to output SGBGR. This is clearly a bug. Is it
> > better to modify the format than the crop rectangle location ?
> 
> Actually, it is interesting. I just looked (again) in the mt9v032 and some
> other Aptina Bayer sensor datasheets, and they actually have _odd_ numbers
> of rows and columns. So, mt9v032 actually has 753x481 active pixels. And
> that extra pixel is explicitly provided to adjust the origin colour. Ok,
> they write, it is for uniformity with the mirrored image, but who believes
> them?;-) So, maybe you should adjust your max values to the above ones,
> then taking one pixel out of your image will not reduce your useful image
> size.

I'm not sure what you mean. Even though the pixel array is bigger than that, 
the maximum output width/height are 752x480 according to the datasheet.

-- 
Regards,

Laurent Pinchart
