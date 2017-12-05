Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:47456 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753003AbdLEJYe (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Dec 2017 04:24:34 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/2] uvcvideo: Factor out video device registration to a function
Date: Tue, 05 Dec 2017 11:24:48 +0200
Message-ID: <2198509.Q7DjPqLdEd@avalon>
In-Reply-To: <alpine.DEB.2.20.1712051008040.22421@axis700.grange>
References: <20171204232333.30084-1-laurent.pinchart@ideasonboard.com> <20171204232333.30084-2-laurent.pinchart@ideasonboard.com> <alpine.DEB.2.20.1712051008040.22421@axis700.grange>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Tuesday, 5 December 2017 11:14:18 EET Guennadi Liakhovetski wrote:
> On Tue, 5 Dec 2017, Laurent Pinchart wrote:
> > The function will then be used to register the video device for metadata
> > capture.
> > 
> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > ---
> > 
> >  drivers/media/usb/uvc/uvc_driver.c | 66 ++++++++++++++++++++-------------
> >  drivers/media/usb/uvc/uvcvideo.h   |  8 +++++
> >  2 files changed, 49 insertions(+), 25 deletions(-)
> > 
> > diff --git a/drivers/media/usb/uvc/uvc_driver.c
> > b/drivers/media/usb/uvc/uvc_driver.c index f77e31fcfc57..b832929d3382
> > 100644
> > --- a/drivers/media/usb/uvc/uvc_driver.c
> > +++ b/drivers/media/usb/uvc/uvc_driver.c
> > @@ -24,6 +24,7 @@
> >  #include <asm/unaligned.h>
> >  
> >  #include <media/v4l2-common.h>
> > +#include <media/v4l2-ioctl.h>
> > 
> >  #include "uvcvideo.h"
> > @@ -1895,52 +1896,63 @@ static void uvc_unregister_video(struct uvc_device
> > *dev)
> 
> [snip]
> 
> >  	vdev->release = uvc_release;
> >  	vdev->prio = &stream->chain->prio;
> > 
> > -	if (stream->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
> > +	if (type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
> >  		vdev->vfl_dir = VFL_DIR_TX;
> 
> Why isn't .vfl_dir set for other stream types? Are you jusut relying on
> VFL_DIR_RX == 0? I'd use a switch (type) here which then would be extended
> in your next patch with .device_caps fields.

Yes, and I agree it's not right. How about

	if (type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
 		vdev->vfl_dir = VFL_DIR_TX;
	else
 		vdev->vfl_dir = VFL_DIR_RX;

Then it won't need to be touched when adding metadata support.

-- 
Regards,

Laurent Pinchart
