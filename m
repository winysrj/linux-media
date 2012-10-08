Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:39443 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690Ab2JHMTG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Oct 2012 08:19:06 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>,
	linux-fbdev@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 2/2 v6] of: add generic videomode description
Date: Mon, 08 Oct 2012 14:19:49 +0200
Message-ID: <1811676.DhpfCA3vWz@avalon>
In-Reply-To: <20121008075741.GC20800@pengutronix.de>
References: <1349373560-11128-1-git-send-email-s.trumtrar@pengutronix.de> <1349680913.3227.32.camel@deskari> <20121008075741.GC20800@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steffen,

On Monday 08 October 2012 09:57:41 Steffen Trumtrar wrote:
> On Mon, Oct 08, 2012 at 10:21:53AM +0300, Tomi Valkeinen wrote:
> > On Thu, 2012-10-04 at 19:59 +0200, Steffen Trumtrar wrote:

[snip]

> > > diff --git a/include/linux/of_videomode.h b/include/linux/of_videomode.h
> > > new file mode 100644
> > > index 0000000..96efe01
> > > --- /dev/null
> > > +++ b/include/linux/of_videomode.h
> > > @@ -0,0 +1,41 @@
> > > +/*
> > > + * Copyright 2012 Steffen Trumtrar <s.trumtrar@pengutronix.de>
> > > + *
> > > + * generic videomode description
> > > + *
> > > + * This file is released under the GPLv2
> > > + */
> > > +
> > > +#ifndef __LINUX_VIDEOMODE_H
> > > +#define __LINUX_VIDEOMODE_H
> > > +
> > > +#include <drm/drmP.h>
> > 
> > You don't need to include this.
> 
> That is a fix to my liking. Easily done ;-)
> 
> > > +struct videomode {
> > > +	u32 pixelclock;
> > > +	u32 refreshrate;
> > > +
> > > +	u32 hactive;
> > > +	u32 hfront_porch;
> > > +	u32 hback_porch;
> > > +	u32 hsync_len;
> > > +
> > > +	u32 vactive;
> > > +	u32 vfront_porch;
> > > +	u32 vback_porch;
> > > +	u32 vsync_len;
> > > +
> > > +	bool hah;
> > > +	bool vah;
> > > +	bool interlaced;
> > > +	bool doublescan;
> > > +
> > > +};
> > 
> > This is not really of related. And actually, neither is the struct
> > signal_timing in the previous patch. It would be nice to have these in a
> > common header that fb, drm, and others could use instead of each having
> > their own timing structs.
> > 
> > But that's probably out of scope for this series =). Did you check the
> > timing structs from the video related frameworks in the kernel to see if
> > your structs contain all the info the others have, so that, at least in
> > theory, everybody could use these common structs?
> > 
> >  Tomi
> 
> Yes. Stephen and Laurent already suggested to split it up.
> No, all info is not contained. That starts with drm, which has width-mm,..
> If time permits, I will go over that.

Just to make sure we won't forget it, the V4L2 version of the timings 
structure is struct v4l2_bt_timings in include/linux/videodev2.h.

-- 
Regards,

Laurent Pinchart

