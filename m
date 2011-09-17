Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:56570 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503Ab1IQMe2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Sep 2011 08:34:28 -0400
Date: Sat, 17 Sep 2011 14:34:25 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sylwester Nawrocki <snjw23@gmail.com>
cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, sw0312.kim@samsung.com,
	riverful.kim@samsung.com
Subject: Re: [PATCH/RFC 1/2] v4l2: Add the parallel bus HREF signal polarity
 flags
In-Reply-To: <4E748D82.8040006@gmail.com>
Message-ID: <alpine.DEB.2.00.1109171423460.28766@axis700.grange>
References: <1316194123-21185-1-git-send-email-s.nawrocki@samsung.com> <1316194123-21185-2-git-send-email-s.nawrocki@samsung.com> <201109171254.49003.laurent.pinchart@ideasonboard.com> <4E748D82.8040006@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 17 Sep 2011, Sylwester Nawrocki wrote:

> Hi Laurent,
> 
> thanks for your comments.
> 
> On 09/17/2011 12:54 PM, Laurent Pinchart wrote:
> > Hi Sylwester,
> > 
> > On Friday 16 September 2011 19:28:42 Sylwester Nawrocki wrote:
> >> HREF is a signal indicating valid data during single line transmission.
> >> Add corresponding flags for this signal to the set of mediabus signal
> >> polarity flags.
> > 
> > So that's a data valid signal that gates the pixel data ? The OMAP3 ISP has a
> 
> Yes, it's "horizontal window reference" signal, it's well described in this datasheet:
> http://www.morninghan.com/pdf/OV2640FSL_DS_(1_3).pdf
> 
> AFAICS there can be also its vertical counterpart - VREF.
> 
> Many devices seem to use this terminology. However, I realize, not all, as you're
> pointing out. So perhaps it's time for some naming contest now.. :-)

Hi

No objections in principle, just one question though: can these signals 
actually be used simultaneously with respective *SYNC signals or only as 
an alternative? If the latter, maybe we could reuse same names by just 
making them more generic?

Thanks
Guennadi

> > similar signal called WEN, and I've seen other chips using DVAL. Your patch
> > looks good to me, except maybe for the signal name that could be made a bit
> > more explicit (I'm not sure what most chips use though).
> 
> I'm pretty OK with HREF/VREF. But I'm open to any better suggestions.
> 
> Maybe 
> 
> V4L2_MBUS_LINE_VALID_ACTIVE_HIGH
> V4L2_MBUS_LINE_VALID_ACTIVE_LOW
> 
> V4L2_MBUS_FRAME_VALID_ACTIVE_HIGH
> V4L2_MBUS_FRAME_VALID_ACTIVE_LOW
> 	
> ? 
> Some of Aptina sensor datasheets describes those signals as LINE_VALID/FRAME_VALID,
> (www.aptina.com/assets/downloadDocument.do?id=76).
> 
> > 
> >> Signed-off-by: Sylwester Nawrocki<s.nawrocki@samsung.com>
> >> Signed-off-by: Kyungmin Park<kyungmin.park@samsung.com>
> >> ---
> >>   include/media/v4l2-mediabus.h |   14 ++++++++------
> >>   1 files changed, 8 insertions(+), 6 deletions(-)
> >>
> >> diff --git a/include/media/v4l2-mediabus.h b/include/media/v4l2-mediabus.h
> >> index 6114007..41d8771 100644
> >> --- a/include/media/v4l2-mediabus.h
> >> +++ b/include/media/v4l2-mediabus.h
> >> @@ -26,12 +26,14 @@
> >>   /* Note: in BT.656 mode HSYNC and VSYNC are unused */
> 
> I've forgotten to update this:
> 
> /* Note: in BT.656 mode HSYNC, HREF and VSYNC are unused */
> 
> >>   #define V4L2_MBUS_HSYNC_ACTIVE_HIGH		(1<<  2)
> >>   #define V4L2_MBUS_HSYNC_ACTIVE_LOW		(1<<  3)
> >> -#define V4L2_MBUS_VSYNC_ACTIVE_HIGH		(1<<  4)
> >> -#define V4L2_MBUS_VSYNC_ACTIVE_LOW		(1<<  5)
> >> -#define V4L2_MBUS_PCLK_SAMPLE_RISING		(1<<  6)
> >> -#define V4L2_MBUS_PCLK_SAMPLE_FALLING		(1<<  7)
> >> -#define V4L2_MBUS_DATA_ACTIVE_HIGH		(1<<  8)
> >> -#define V4L2_MBUS_DATA_ACTIVE_LOW		(1<<  9)
> >> +#define V4L2_MBUS_HREF_ACTIVE_HIGH		(1<<  4)
> >> +#define V4L2_MBUS_HREF_ACTIVE_LOW		(1<<  5)
> >> +#define V4L2_MBUS_VSYNC_ACTIVE_HIGH		(1<<  6)
> >> +#define V4L2_MBUS_VSYNC_ACTIVE_LOW		(1<<  7)
> >> +#define V4L2_MBUS_PCLK_SAMPLE_RISING		(1<<  8)
> >> +#define V4L2_MBUS_PCLK_SAMPLE_FALLING		(1<<  9)
> >> +#define V4L2_MBUS_DATA_ACTIVE_HIGH		(1<<  10)
> >> +#define V4L2_MBUS_DATA_ACTIVE_LOW		(1<<  11)
> 
> --
> Thanks,
> Sylwester
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
