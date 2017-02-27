Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:65452 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751597AbdB0KO7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Feb 2017 05:14:59 -0500
Date: Mon, 27 Feb 2017 10:13:53 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Koji Matsuoka <koji.matsuoka.xm@renesas.com>,
        Yoshihiro Kaneko <ykaneko0929@gmail.com>,
        Simon Horman <horms+renesas@verge.net.au>
Subject: Re: [PATCH] soc-camera: fix rectangle adjustment in cropping
In-Reply-To: <6082161.NEqkolhdEc@avalon>
Message-ID: <Pine.LNX.4.64.1702271006290.21990@axis700.grange>
References: <Pine.LNX.4.64.1702262150090.17018@axis700.grange>
 <1908551.GjAGnFoZ8e@avalon> <Pine.LNX.4.64.1702270945390.21990@axis700.grange>
 <6082161.NEqkolhdEc@avalon>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 27 Feb 2017, Laurent Pinchart wrote:

> Hi Guennadi,
> 
> On Monday 27 Feb 2017 09:54:19 Guennadi Liakhovetski wrote:
> > On Mon, 27 Feb 2017, Laurent Pinchart wrote:
> > > On Sunday 26 Feb 2017 21:58:16 Guennadi Liakhovetski wrote:
> > >> From: Koji Matsuoka <koji.matsuoka.xm@renesas.com>
> > >> 
> > >> update_subrect() adjusts the sub-rectangle to be inside a base area.
> > >> It checks width and height to not exceed those of the area, then it
> > >> checks the low border (left or top) to lie within the area, then the
> > >> high border (right or bottom) to lie there too. This latter check has
> > >> a bug, which is fixed by this patch.
> > >> 
> > >> Signed-off-by: Koji Matsuoka <koji.matsuoka.xm@renesas.com>
> > >> Signed-off-by: Yoshihiro Kaneko <ykaneko0929@gmail.com>
> > >> [g.liakhovetski@gmx.de: dropped supposedly wrong hunks]
> > >> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > >> ---
> > >> 
> > >> This is a part of the https://patchwork.linuxtv.org/patch/26441/
> > >> submitted almost 2.5 years ago. Back then I commented to the patch but
> > >> never got a reply or an update. I preserved original authorship and Sob
> > >> tags, although this version only uses a small portion of the original
> > >> patch. This version is of course completely untested, any testing (at
> > >> least regression) would be highly appreciated! This code is only used by
> > >> the SH CEU driver and only in cropping / zooming scenarios.
> > >> 
> > >>  drivers/media/platform/soc_camera/soc_scale_crop.c | 4 ++--
> > >>  1 file changed, 2 insertions(+), 2 deletions(-)
> > >> 
> > >> diff --git a/drivers/media/platform/soc_camera/soc_scale_crop.c
> > >> b/drivers/media/platform/soc_camera/soc_scale_crop.c index
> > >> f77252d..4bfc1bf
> > >> 100644
> > >> --- a/drivers/media/platform/soc_camera/soc_scale_crop.c
> > >> +++ b/drivers/media/platform/soc_camera/soc_scale_crop.c
> > >> @@ -70,14 +70,14 @@ static void update_subrect(struct v4l2_rect *rect,
> > >> struct v4l2_rect *subrect)
> > >>  	if (rect->height < subrect->height)
> > >>  		subrect->height = rect->height;
> > >> 
> > >> -	if (rect->left > subrect->left)
> > >> +	if (rect->left < subrect->left)
> > > 
> > > This looks wrong to me. If the purpose of the function is indeed to adjust
> > > subrect to stay within rect, the condition doesn't need to be changed.
> > > 
> > >>  		subrect->left = rect->left;
> > >>  	else if (rect->left + rect->width >
> > >>  		 subrect->left + subrect->width)
> > > 
> > > This condition, however, is wrong.
> > 
> > Arrrrgh, of course, I meant to change this one! Thanks for catching.
> > 
> > >>  		subrect->left = rect->left + rect->width -
> > >>  			subrect->width;
> > > 
> > > More than that, adjusting the width first and then the left coordinate can
> > > result in an incorrect width.
> > 
> > The width is adjusted in the beginning only to stay within the area, you
> > cannot go beyond it anyway. So, that has to be done anyway. And then the
> > origin is adjusted.
> > 
> > > It looks to me like you should drop the width
> > > check at the beginning of this function, and turn the "else if" here into
> > > an "if" with the right condition. Or, even better in my opinion, use the
> > > min/max/clamp macros.
> > 
> > Well, that depends on what result we want to achieve, what parameter we
> > prioritise. This approach prioritises width and height, and then adjusts
> > edges to accommodate as much of them as possible. A different approach
> > would be to prioritise the origin (top and left) and adjust width and
> > height to stay within the area. Do we have a preference for this?
> 
> Don't you need both ? "Inside the area" is a pretty well-defined concept :-)
> 
> 	subrect->left = max(subrect->left, rect->left);

I prefer to avoid assignments like "a = max(a, b)" to avoid a redundant 
"a = a" assignment, when a >= b :-)

> 	subrect->top = max(subrect->top, rect->top);
> 	subrect->width = min(subrect->left + subrect->width,
> 			     rect->left + rect->width) - subrect->left;
> 	subrect->height = min(subrect->top + subrect->height,
> 			      rect->top + rect->height) - subrect->top;

But this is exactly what I meant, isn't it? Consider an area 100..1000 and 
a subrect 200..2000. Obviously, width is wrong. You have two 
possibilities to adjust it: (1) size-priority. You maximise the size 
(900) and then adjust the origin to accommodate it (100). (2) 
origin-priority: you keep origin (200) and maximise size, based on that 
(800). My approach does (1), yours does (2). I prefer (1). Your approach 
also would break if origin is way too large, e.g. 1100..2000, whereas mine 
would work unchanged.

Thanks
Guennadi

> (Completely untested)
> 
> > > Same comments for the vertical checks.
> > > 
> > >> -	if (rect->top > subrect->top)
> > >> +	if (rect->top < subrect->top)
> > >>  		subrect->top = rect->top;
> > >>  	else if (rect->top + rect->height >
> > >>  		 subrect->top + subrect->height)
> 
> -- 
> Regards,
> 
> Laurent Pinchart
> 
