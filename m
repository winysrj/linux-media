Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:39085 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256Ab2KWMTK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Nov 2012 07:19:10 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 4/6] uvcvideo: Set device_caps in VIDIOC_QUERYCAP
Date: Fri, 23 Nov 2012 13:20:10 +0100
Message-ID: <1498367.xoaGbmT0nc@avalon>
In-Reply-To: <201211161500.29555.hverkuil@xs4all.nl>
References: <1348758980-21683-1-git-send-email-laurent.pinchart@ideasonboard.com> <1348758980-21683-5-git-send-email-laurent.pinchart@ideasonboard.com> <201211161500.29555.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for the review.

On Friday 16 November 2012 15:00:29 Hans Verkuil wrote:
> On Thu September 27 2012 17:16:18 Laurent Pinchart wrote:
> > Set the capabilities field to global capabilities, and the device_caps
> > field to the video node capabilities.
> > 
> > This issue was found by the v4l2-compliance tool.
> > 
> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > ---
> > 
> >  drivers/media/usb/uvc/uvc_driver.c |    5 +++++
> >  drivers/media/usb/uvc/uvc_v4l2.c   |   10 ++++++----
> >  drivers/media/usb/uvc/uvcvideo.h   |    2 ++
> >  3 files changed, 13 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/media/usb/uvc/uvc_driver.c
> > b/drivers/media/usb/uvc/uvc_driver.c index 5967081..ae24f7d 100644
> > --- a/drivers/media/usb/uvc/uvc_driver.c
> > +++ b/drivers/media/usb/uvc/uvc_driver.c
> > @@ -1741,6 +1741,11 @@ static int uvc_register_video(struct uvc_device
> > *dev,
> >  		return ret;
> >  	}
> > 
> > +	if (stream->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
> > +		stream->chain->caps |= V4L2_CAP_VIDEO_CAPTURE;
> > +	else
> > +		stream->chain->caps |= V4L2_CAP_VIDEO_OUTPUT;
> > +
> >  	atomic_inc(&dev->nstreams);
> >  	return 0;
> >  }
> > diff --git a/drivers/media/usb/uvc/uvc_v4l2.c
> > b/drivers/media/usb/uvc/uvc_v4l2.c index 3bd9373..b1aa55f 100644
> > --- a/drivers/media/usb/uvc/uvc_v4l2.c
> > +++ b/drivers/media/usb/uvc/uvc_v4l2.c
> > @@ -565,12 +565,14 @@ static long uvc_v4l2_do_ioctl(struct file *file,
> > unsigned int cmd, void *arg)> 
> >  		usb_make_path(stream->dev->udev,
> >  			      cap->bus_info, sizeof(cap->bus_info));
> >  		cap->version = LINUX_VERSION_CODE;
> > +		cap->capabilities = V4L2_CAP_DEVICE_CAPS | V4L2_CAP_STREAMING
> > +				  | chain->caps;
> >  		if (stream->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
> > -			cap->capabilities = V4L2_CAP_VIDEO_CAPTURE
> > -					  | V4L2_CAP_STREAMING;
> > +			cap->device_caps = V4L2_CAP_VIDEO_CAPTURE
> > +					 | V4L2_CAP_STREAMING;
> >  		else
> > -			cap->capabilities = V4L2_CAP_VIDEO_OUTPUT
> > -					  | V4L2_CAP_STREAMING;
> > +			cap->device_caps = V4L2_CAP_VIDEO_OUTPUT
> > +					 | V4L2_CAP_STREAMING;
> 
> This seems weird. Wouldn't it be easier to do:
> 
> 		cap->device_caps = chain->caps | V4L2_CAP_STREAMING;
> 
> You don't need the if/else here.

No, because chain->caps can be V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_VIDEO_OUTPUT 
as a chain can contain several video nodes. We want to caps of this particular 
video node only here.

> >  		break;
> >  	}

-- 
Regards,

Laurent Pinchart

