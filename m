Return-path: <mchehab@gaivota>
Received: from perceval.ideasonboard.com ([95.142.166.194]:46623 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755980Ab0KUVtS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Nov 2010 16:49:18 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH 4/5] uvcvideo: Lock stream mutex when accessing format-related information
Date: Sun, 21 Nov 2010 22:49:25 +0100
Cc: linux-media@vger.kernel.org
References: <1290371573-14907-1-git-send-email-laurent.pinchart@ideasonboard.com> <1290371573-14907-5-git-send-email-laurent.pinchart@ideasonboard.com> <201011212223.38557.hverkuil@xs4all.nl>
In-Reply-To: <201011212223.38557.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201011212249.26202.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Hans,

Thanks for the comment.

On Sunday 21 November 2010 22:23:38 Hans Verkuil wrote:
> On Sunday, November 21, 2010 21:32:52 Laurent Pinchart wrote:
> > The stream mutex protects access to the struct uvc_streaming ctrl,
> > cur_format and cur_frame fields as well as to the hardware probe
> > control. Lock it appropriately.
> > 
> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > ---
> > 
> >  drivers/media/video/uvc/uvc_v4l2.c  |   76
> >  +++++++++++++++++++++++++---------- drivers/media/video/uvc/uvc_video.c
> >  |    3 -
> >  drivers/media/video/uvc/uvcvideo.h  |    4 +-
> >  3 files changed, 57 insertions(+), 26 deletions(-)
> > 
> > diff --git a/drivers/media/video/uvc/uvc_v4l2.c
> > b/drivers/media/video/uvc/uvc_v4l2.c index 07dd235..b4615e2 100644
> > --- a/drivers/media/video/uvc/uvc_v4l2.c
> > +++ b/drivers/media/video/uvc/uvc_v4l2.c

[snip]

> > @@ -255,14 +257,21 @@ done:
> >  static int uvc_v4l2_get_format(struct uvc_streaming *stream,
> >  
> >  	struct v4l2_format *fmt)
> >  
> >  {
> > 
> > -	struct uvc_format *format = stream->cur_format;
> > -	struct uvc_frame *frame = stream->cur_frame;
> > +	struct uvc_format *format;
> > +	struct uvc_frame *frame;
> > +	int ret = 0;
> > 
> >  	if (fmt->type != stream->type)
> >  	
> >  		return -EINVAL;
> > 
> > -	if (format == NULL || frame == NULL)
> > -		return -EINVAL;
> > +	mutex_lock(&stream->mutex);
> > +	format = stream->cur_format;
> > +	frame = stream->cur_frame;
> > +
> > +	if (format == NULL || frame == NULL) {
> > +		ret = -EINVAL;
> 
> ret is set...
> 
> > +		goto done;
> > +	}
> > 
> >  	fmt->fmt.pix.pixelformat = format->fcc;
> >  	fmt->fmt.pix.width = frame->wWidth;
> > 
> > @@ -273,6 +282,8 @@ static int uvc_v4l2_get_format(struct uvc_streaming
> > *stream,
> > 
> >  	fmt->fmt.pix.colorspace = format->colorspace;
> >  	fmt->fmt.pix.priv = 0;
> > 
> > +done:
> > +	mutex_unlock(&stream->mutex);
> > 
> >  	return 0;
> 
> But not returned?!

My bad. I'll fix it. Thanks.

-- 
Regards,

Laurent Pinchart
