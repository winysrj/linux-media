Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:53964 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934741AbaBDWK2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Feb 2014 17:10:28 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Philipp Zabel <pza@pengutronix.de>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	kernel@pengutronix.de
Subject: Re: [PATCH] [media] uvcvideo: Enable VIDIOC_CREATE_BUFS
Date: Tue, 04 Feb 2014 23:11:23 +0100
Message-ID: <2421948.xVuskQpCdf@avalon>
In-Reply-To: <52EF5B6B.7030103@xs4all.nl>
References: <1391012032-19600-1-git-send-email-p.zabel@pengutronix.de> <20140202130430.GA15734@pengutronix.de> <52EF5B6B.7030103@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Monday 03 February 2014 10:03:39 Hans Verkuil wrote:
> On 02/02/2014 02:04 PM, Philipp Zabel wrote:
> > On Sun, Feb 02, 2014 at 11:21:13AM +0100, Laurent Pinchart wrote:
> >> On Friday 31 January 2014 09:43:00 Hans Verkuil wrote:
> >>> I think you might want to add a check in uvc_queue_setup to verify the
> >>> fmt that create_bufs passes. The spec says that: "Unsupported formats
> >>> will result in an error". In this case I guess that the format basically
> >>> should match the current selected format.
> >>> 
> >>> I'm unhappy with the current implementations of create_bufs (see also
> >>> this patch:
> >>> http://www.mail-archive.com/linux-media@vger.kernel.org/msg70796.html).
> >>> 
> >>> Nobody is actually checking the format today, which isn't good.
> >>> 
> >>> The fact that the spec says that the fmt field isn't changed by the
> >>> driver isn't helping as it invalidated my patch from above, although
> >>> that can be fixed.
> >>> 
> >>> I need to think about this some more, but for this particular case you
> >>> can just do a memcmp of the v4l2_pix_format against the currently
> >>> selected format and return an error if they differ. Unless you want to
> >>> support different buffer sizes as well?
> >> 
> >> Isn't the whole point of VIDIOC_CREATE_BUFS being able to create buffers
> >> of different resolutions than the current active resolution ?
> 
> Or just additional buffers with the same resolution (or really, the same
> size).

Sure, that as well, but one use is to allocate larger buffers, shouldn't that 
be allowed ?

> > For that to work the driver in question would need to keep track of
> > per-buffer format and resolution, and not only of per-queue format and
> > resolution.
> > 
> > For now, would something like the following be enough? Unfortunately the
> > uvc driver doesn't keep a v4l2_format around that we could just memcmp
> > against:
> > 
> > diff --git a/drivers/media/usb/uvc/uvc_v4l2.c
> > b/drivers/media/usb/uvc/uvc_v4l2.c index fa58131..7fa469b 100644
> > --- a/drivers/media/usb/uvc/uvc_v4l2.c
> > +++ b/drivers/media/usb/uvc/uvc_v4l2.c
> > @@ -1003,10 +1003,26 @@ static long uvc_v4l2_do_ioctl(struct file *file,
> > unsigned int cmd, void *arg)> 
> >  	case VIDIOC_CREATE_BUFS:
> >  	{
> >  	
> >  		struct v4l2_create_buffers *cb = arg;
> > 
> > +		struct v4l2_pix_format *pix;
> > +		struct uvc_format *format;
> > +		struct uvc_frame *frame;
> > 
> >  		if (!uvc_has_privileges(handle))
> >  		
> >  			return -EBUSY;
> > 
> > +		format = stream->cur_format;
> > +		frame = stream->cur_frame;
> > +		pix = &cb->format.fmt.pix;
> > +
> > +		if (pix->pixelformat != format->fcc ||
> > +		    pix->width != frame->wWidth ||
> > +		    pix->height != frame->wHeight ||
> > +		    pix->field != V4L2_FIELD_NONE ||
> > +		    pix->bytesperline != format->bpp * frame->wWidth / 8 ||
> > +		    pix->sizeimage != stream->ctrl.dwMaxVideoFrameSize ||
> > +		    pix->colorspace != format->colorspace)
> 
> I would drop the field and colorspace checks (those do not really affect
> any size calculations), other than that it looks good.
> 
> Regards,
> 
> 	Hans
> 
> > +			return -EINVAL;
> > +
> >  		return uvc_create_buffers(&stream->queue, cb);
> >  	
> >  	}

-- 
Regards,

Laurent Pinchart

