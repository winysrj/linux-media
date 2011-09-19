Return-path: <linux-media-owner@vger.kernel.org>
Received: from [212.255.34.49] ([212.255.34.49]:34897 "HELO
	neutronstar.dyndns.org" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with SMTP id S1751494Ab1ISGLA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Sep 2011 02:11:00 -0400
Date: Mon, 19 Sep 2011 08:02:52 +0200
From: martin@neutronstar.dyndns.org
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: Re: [PATCH] v4l subdev: add dispatching for VIDIOC_DBG_G_REGISTER
 and VIDIOC_DBG_S_REGISTER.
Message-ID: <20110919060252.GC9244@neutronstar.dyndns.org>
References: <1316251596-32073-1-git-send-email-martin@neutronstar.dyndns.org>
 <201109190053.08451.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201109190053.08451.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Sep 19, 2011 at 12:53:07AM +0200, Laurent Pinchart wrote:
> Hi Martin,
> 
> Thanks for the patch.
> 
> On Saturday 17 September 2011 11:26:36 Martin Hostettler wrote:
> > Ioctls on the subdevs node currently don't dispatch the register access
> > debug driver callbacks. Add the dispatching with the same security checks
> > are for non subdev video nodes (i.e. only capable(CAP_SYS_ADMIN may call
> > the register access ioctls).
> 
> Can we get your SoB line ? If you resubmit the patch, please fold the commit 
> message at 72 columns to keep git happy.

Yes, of course. Seems i forgot it.

> 
> > ---
> >  drivers/media/video/v4l2-subdev.c |   20 ++++++++++++++++++++
> >  1 files changed, 20 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/media/video/v4l2-subdev.c
> > b/drivers/media/video/v4l2-subdev.c index b7967c9..8bf8397 100644
> > --- a/drivers/media/video/v4l2-subdev.c
> > +++ b/drivers/media/video/v4l2-subdev.c
> > @@ -25,6 +25,7 @@
> >  #include <linux/types.h>
> >  #include <linux/videodev2.h>
> > 
> > +#include <media/v4l2-chip-ident.h>
> 
> Is this needed ?

No, it's an leftover.

I'll resend a patch fixed patch.

 - Martin Hostettler
