Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:53918 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752856AbdLEJh5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 5 Dec 2017 04:37:57 -0500
Date: Tue, 5 Dec 2017 10:37:53 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/2] uvcvideo: Factor out video device registration to
 a function
In-Reply-To: <2198509.Q7DjPqLdEd@avalon>
Message-ID: <alpine.DEB.2.20.1712051032440.22421@axis700.grange>
References: <20171204232333.30084-1-laurent.pinchart@ideasonboard.com> <20171204232333.30084-2-laurent.pinchart@ideasonboard.com> <alpine.DEB.2.20.1712051008040.22421@axis700.grange> <2198509.Q7DjPqLdEd@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 5 Dec 2017, Laurent Pinchart wrote:

> Hi Guennadi,
> 
> On Tuesday, 5 December 2017 11:14:18 EET Guennadi Liakhovetski wrote:
> > On Tue, 5 Dec 2017, Laurent Pinchart wrote:
> > > The function will then be used to register the video device for metadata
> > > capture.
> > > 
> > > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > > ---
> > > 
> > >  drivers/media/usb/uvc/uvc_driver.c | 66 ++++++++++++++++++++-------------
> > >  drivers/media/usb/uvc/uvcvideo.h   |  8 +++++
> > >  2 files changed, 49 insertions(+), 25 deletions(-)
> > > 
> > > diff --git a/drivers/media/usb/uvc/uvc_driver.c
> > > b/drivers/media/usb/uvc/uvc_driver.c index f77e31fcfc57..b832929d3382
> > > 100644
> > > --- a/drivers/media/usb/uvc/uvc_driver.c
> > > +++ b/drivers/media/usb/uvc/uvc_driver.c
> > > @@ -24,6 +24,7 @@
> > >  #include <asm/unaligned.h>
> > >  
> > >  #include <media/v4l2-common.h>
> > > +#include <media/v4l2-ioctl.h>
> > > 
> > >  #include "uvcvideo.h"
> > > @@ -1895,52 +1896,63 @@ static void uvc_unregister_video(struct uvc_device
> > > *dev)
> > 
> > [snip]
> > 
> > >  	vdev->release = uvc_release;
> > >  	vdev->prio = &stream->chain->prio;
> > > 
> > > -	if (stream->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
> > > +	if (type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
> > >  		vdev->vfl_dir = VFL_DIR_TX;
> > 
> > Why isn't .vfl_dir set for other stream types? Are you jusut relying on
> > VFL_DIR_RX == 0? I'd use a switch (type) here which then would be extended
> > in your next patch with .device_caps fields.
> 
> Yes, and I agree it's not right. How about
> 
> 	if (type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
>  		vdev->vfl_dir = VFL_DIR_TX;
> 	else
>  		vdev->vfl_dir = VFL_DIR_RX;
> 
> Then it won't need to be touched when adding metadata support.

Well, I personally find it a bit less than elegant to have

	if (x = a)
		...
	else
		...

	switch (x) {
	case a:
		...
	...
	}

Also, if I did end up having these two separate, I'd also rather use the 
?: operator for the first one, but in the end it's up to you, I won't 
fight for that :-)

Thanks
Guennadi
