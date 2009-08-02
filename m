Return-path: <linux-media-owner@vger.kernel.org>
Received: from mgw2.diku.dk ([130.225.96.92]:35519 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750890AbZHBGXS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 2 Aug 2009 02:23:18 -0400
Date: Sun, 2 Aug 2009 08:20:04 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Laurent Pinchart <laurent.pinchart@skynet.be>
Cc: linux-media@vger.kernel.org, linux-uvc-devel@lists.berlios.de,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 2/5] drivers/media/video/uvc: Use DIV_ROUND_CLOSEST
In-Reply-To: <200908012223.52022.laurent.pinchart@skynet.be>
Message-ID: <Pine.LNX.4.64.0908020818540.15557@ask.diku.dk>
References: <Pine.LNX.4.64.0908012148420.25693@ask.diku.dk>
 <200908012223.52022.laurent.pinchart@skynet.be>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 1 Aug 2009, Laurent Pinchart wrote:

> On Saturday 01 August 2009 21:49:04 Julia Lawall wrote:
> > From: Julia Lawall <julia@diku.dk>
> >
> > The kernel.h macro DIV_ROUND_CLOSEST performs the computation (x + d/2)/d
> > but is perhaps more readable.
> >
> > The semantic patch that makes this change is as follows:
> > (http://www.emn.fr/x-info/coccinelle/)
> >
> > // <smpl>
> > @haskernel@
> > @@
> >
> > #include <linux/kernel.h>
> >
> > @depends on haskernel@
> > expression x,__divisor;
> > @@
> >
> > - (((x) + ((__divisor) / 2)) / (__divisor))
> > + DIV_ROUND_CLOSEST(x,__divisor)
> > // </smpl>
> >
> > Signed-off-by: Julia Lawall <julia@diku.dk>
> >
> > ---
> >  drivers/media/video/uvc/uvc_v4l2.c  |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >
> > diff --git a/drivers/media/video/uvc/uvc_v4l2.c
> > b/drivers/media/video/uvc/uvc_v4l2.c index 87cb9cc..6edaaf6 100644
> > --- a/drivers/media/video/uvc/uvc_v4l2.c
> > +++ b/drivers/media/video/uvc/uvc_v4l2.c
> > @@ -95,7 +95,7 @@ static __u32 uvc_try_frame_interval(struct uvc_frame
> > *frame, __u32 interval) const __u32 max = frame->dwFrameInterval[1];
> >  		const __u32 step = frame->dwFrameInterval[2];
> >
> > -		interval = min + (interval - min + step/2) / step * step;
> > +		interval = min + DIV_ROUND_CLOSEST(interval-min, step) * step;
> >  		if (interval > max)
> >  			interval = max;
> >  	}
> 
> The purpose of the above code is to clamp the interval value to the [min, max] 
> range at round it to the closest multiple of step. Other drivers might need 
> similar code. Do you think it might be useful to introduce a clamp_step macro 
> for this ?

I tried searching for the following:

@@
expression interval, min, max, step, E;
@@

* interval = min + (interval - min + step/2) / step * step;
  ... when != interval = E
* if (interval > max)
  { ...
     interval = max;
  ... }

@@
expression interval, min, max, step, E;
@@

* interval = min + DIV_ROUND_CLOSEST(interval-min, step) * step;
  ... when != interval = E
* if (interval > max) { ...
     interval = max;
  ... }

and the only occurrence I found was the code above.  Perhaps there is some 
other way in which the pattern would appear?

julia
