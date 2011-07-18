Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:54096 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740Ab1GRIx5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jul 2011 04:53:57 -0400
Date: Mon, 18 Jul 2011 11:53:52 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] v4l: mt9v032: Fix Bayer pattern
Message-ID: <20110718085352.GL27451@valkosipuli.localdomain>
References: <1310761106-29722-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <Pine.LNX.4.64.1107160109000.27399@axis700.grange>
 <201107161152.09214.laurent.pinchart@ideasonboard.com>
 <Pine.LNX.4.64.1107162206010.6202@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1107162206010.6202@axis700.grange>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Jul 16, 2011 at 11:40:23PM +0200, Guennadi Liakhovetski wrote:
> On Sat, 16 Jul 2011, Laurent Pinchart wrote:
> 
> > Hi Guennadi,
> > 
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
> > > > If there's no comment I'll send a pull request for this patch in a couple
> > > > of days.
> > > 
> > > Hm, I might have a comment: why?... Isn't it natural to accept the fact,
> > > that different sensors put a different Bayer pixel at their sensor matrix
> > > origin? Isn't that why we have all possible Bayer formats? Maybe you just
> > > have to choose a different output format?
> > 
> > That's the other solution. The driver currently claims the device outputs 
> > SGRBG, but configures it to output SGBGR. This is clearly a bug. Is it better 
> > to modify the format than the crop rectangle location ?

I would definitely crop the rectangle location than change the
v4l2_mbus_framefmt.code; cropping should have no such side effects.

If the user wants a different format, (s)he will use VIDIOC_SUBDEV_S_FMT
ioctl to change it. Otherwise much of the pipeline configuration would
require changes to it.

What might still be important would be that the size of the image would not
change as a result of adjusting due to the colour pattern. That should be
avoided if possible, as alignment requirements exist and the user may well
have requested a size which fits to the requirements of other blocks in the
pipeline.

> Actually, it is interesting. I just looked (again) in the mt9v032 and some 
> other Aptina Bayer sensor datasheets, and they actually have _odd_ numbers 
> of rows and columns. So, mt9v032 actually has 753x481 active pixels. And 
> that extra pixel is explicitly provided to adjust the origin colour. Ok, 
> they write, it is for uniformity with the mirrored image, but who believes 
> them?;-) So, maybe you should adjust your max values to the above ones, 
> then taking one pixel out of your image will not reduce your useful image 
> size.

Some sensors I've seen are only able to produce just one colour pattern,
even when using cropping.

-- 
Sakari Ailus
sakari.ailus@iki.fi
