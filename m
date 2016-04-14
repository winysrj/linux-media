Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:57018 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753756AbcDNQcd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Apr 2016 12:32:33 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] uvc: Fix bytesperline calculation for planar YUV
Date: Thu, 14 Apr 2016 19:32:41 +0300
Message-ID: <1654515.2cgsybPvTh@avalon>
In-Reply-To: <1460563054.18956.4.camel@collabora.com>
References: <1452199428-3513-1-git-send-email-nicolas.dufresne@collabora.com> <4325164.Ph5FqXt1zq@avalon> <1460563054.18956.4.camel@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Nicolas,

On Wednesday 13 Apr 2016 11:57:34 Nicolas Dufresne wrote:
> Le mercredi 13 avril 2016 à 17:36 +0300, Laurent Pinchart a écrit :
> > Hi Nicolas,
> > 
> > Thank you for the patch.
> > 
> > On Thursday 07 Jan 2016 15:43:48 Nicolas Dufresne wrote:
> > > The formula used to calculate bytesperline only works for packed
> > > format.
> > > So far, all planar format we support have their bytesperline equal
> > > to
> > > the image width (stride of the Y plane or a line of Y for M420).
> > > 
> > > Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
> > > ---
> > >  drivers/media/usb/uvc/uvc_v4l2.c | 18 ++++++++++++++++--
> > >  1 file changed, 16 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/drivers/media/usb/uvc/uvc_v4l2.c
> > > b/drivers/media/usb/uvc/uvc_v4l2.c index d7723ce..ceb1d1b 100644
> > > --- a/drivers/media/usb/uvc/uvc_v4l2.c
> > > +++ b/drivers/media/usb/uvc/uvc_v4l2.c
> > > @@ -142,6 +142,20 @@ static __u32 uvc_try_frame_interval(struct
> > > uvc_frame
> > > *frame, __u32 interval) return interval;
> > >  }
> > > 
> > > +static __u32 uvc_v4l2_get_bytesperline(struct uvc_format *format,
> > > +	struct uvc_frame *frame)
> > 
> > I'd make the two parameters const.
> 
> I agree.
> 
> > > +{
> > > +	switch (format->fcc) {
> > > +	case V4L2_PIX_FMT_NV12:
> > > +	case V4L2_PIX_FMT_YVU420:
> > > +	case V4L2_PIX_FMT_YUV420:
> > > +	case V4L2_PIX_FMT_M420:
> > > +		return frame->wWidth;
> > > +	default:
> > > +		return format->bpp * frame->wWidth / 8;
> > > +	}
> > > +}
> > > +
> > >  static int uvc_v4l2_try_format(struct uvc_streaming *stream,
> > >  	struct v4l2_format *fmt, struct uvc_streaming_control
> > > *probe,
> > >  	struct uvc_format **uvc_format, struct uvc_frame
> > > **uvc_frame)
> > > @@ -245,7 +259,7 @@ static int uvc_v4l2_try_format(struct
> > > uvc_streaming
> > > *stream, fmt->fmt.pix.width = frame->wWidth;
> > >  	fmt->fmt.pix.height = frame->wHeight;
> > >  	fmt->fmt.pix.field = V4L2_FIELD_NONE;
> > > -	fmt->fmt.pix.bytesperline = format->bpp * frame->wWidth /
> > > 8;
> > > +	fmt->fmt.pix.bytesperline =
> > > uvc_v4l2_get_bytesperline(format, frame);
> > >  	fmt->fmt.pix.sizeimage = probe->dwMaxVideoFrameSize;
> > >  	fmt->fmt.pix.colorspace = format->colorspace;
> > >  	fmt->fmt.pix.priv = 0;
> > > @@ -282,7 +296,7 @@ static int uvc_v4l2_get_format(struct
> > > uvc_streaming
> > > *stream, fmt->fmt.pix.width = frame->wWidth;
> > >  	fmt->fmt.pix.height = frame->wHeight;
> > >  	fmt->fmt.pix.field = V4L2_FIELD_NONE;
> > > -	fmt->fmt.pix.bytesperline = format->bpp * frame->wWidth /
> > > 8;
> > > +	fmt->fmt.pix.bytesperline =
> > > uvc_v4l2_get_bytesperline(format, frame);
> > >  	fmt->fmt.pix.sizeimage = stream->ctrl.dwMaxVideoFrameSize;
> > >  	fmt->fmt.pix.colorspace = format->colorspace;
> > >  	fmt->fmt.pix.priv = 0;
> > 
> > This looks good to me otherwise.
> > 
> > If it's fine with you I can fix the above issue while applying.
> 
> That would be really nice.

Applied to my tree with the above changes, thank you.

-- 
Regards,

Laurent Pinchart

