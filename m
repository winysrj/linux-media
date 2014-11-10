Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:62304 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751634AbaKJVPj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Nov 2014 16:15:39 -0500
Date: Mon, 10 Nov 2014 22:15:35 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] v4l: uvcvideo: Fix buffer completion size check
In-Reply-To: <Pine.LNX.4.64.1411101613280.23739@axis700.grange>
Message-ID: <Pine.LNX.4.64.1411102207510.30425@axis700.grange>
References: <1412113371-11485-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <2530457.fbzKgqC21y@avalon> <Pine.LNX.4.64.1411101613280.23739@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 10 Nov 2014, Guennadi Liakhovetski wrote:

> Hi Laurent,
> 
> On Thu, 2 Oct 2014, Laurent Pinchart wrote:
> 
> > Hi Guennadi,
> > 
> > Ping ?
> 
> Sorry again for a delay, and unfortunately my eventual reply won't be very 
> helpful: we've modified our user-space in a way, that that path isn't 
> triggered anymore, so, I cannot easily verify your patch. In any case by 
> looking at it and judging by the fact, that sizeimage is anyway 
> initialised from dwMaxVideoFrameSize in VIDIOC_G_FMT, I think your patch 
> is correct.

Actgually, I did test it, but only in the "normal" case, not in the error 
case, which was the problem. I.e. when the buffer size is equal to the 
frame size. But since I tested this case with your patch applied and it 
worked, this means, that dwMaxVideoFrameSize is indeed equal to the 
expected image size, since it is unlikely, that it is derived from the 
buffer size, right? So, I guess, we can count this as a

Tested-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

(if you haven't pushed it upstream yet ;))

Thanks
Guennadi

> > On Wednesday 01 October 2014 00:42:51 Laurent Pinchart wrote:
> > > Commit e93e7fd9f5a3fffec7792dbcc4c3574653effda7 ("v4l2: uvcvideo: Allow
> > > using larger buffers") reworked the buffer size sanity check at buffer
> > > completion time to use the frame size instead of the allocated buffer
> > > size. However, it introduced two bugs in doing so:
> > > 
> > > - it assigned the allocated buffer size to the frame_size field, instead
> > >   of assigning the correct frame size
> > > 
> > > - it performed the assignment in the S_FMT handler, resulting in the
> > >   frame_size field being uninitialized if the userspace application
> > >   doesn't call S_FMT.
> > > 
> > > Fix both issues by removing the frame_size field and validating the
> > > buffer size against the UVC video control dwMaxFrameSize.
> > > 
> > > Fixes: e93e7fd9f5a3 ("v4l2: uvcvideo: Allow using larger buffers")
> > > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > > ---
> > >  drivers/media/usb/uvc/uvc_v4l2.c  | 1 -
> > >  drivers/media/usb/uvc/uvc_video.c | 2 +-
> > >  drivers/media/usb/uvc/uvcvideo.h  | 1 -
> > >  3 files changed, 1 insertion(+), 3 deletions(-)
> > > 
> > > Guennadi, could you please test and ack this ASAP, as the bug needs to be
> > > fixed for v3.18-rc1 if possible ?
> > > 
> > > diff --git a/drivers/media/usb/uvc/uvc_v4l2.c
> > > b/drivers/media/usb/uvc/uvc_v4l2.c index f205934..f33a067 100644
> > > --- a/drivers/media/usb/uvc/uvc_v4l2.c
> > > +++ b/drivers/media/usb/uvc/uvc_v4l2.c
> > > @@ -318,7 +318,6 @@ static int uvc_v4l2_set_format(struct uvc_streaming
> > > *stream, stream->ctrl = probe;
> > >  	stream->cur_format = format;
> > >  	stream->cur_frame = frame;
> > > -	stream->frame_size = fmt->fmt.pix.sizeimage;
> > > 
> > >  done:
> > >  	mutex_unlock(&stream->mutex);
> > > diff --git a/drivers/media/usb/uvc/uvc_video.c
> > > b/drivers/media/usb/uvc/uvc_video.c index 9ace520..df81b9c 100644
> > > --- a/drivers/media/usb/uvc/uvc_video.c
> > > +++ b/drivers/media/usb/uvc/uvc_video.c
> > > @@ -1143,7 +1143,7 @@ static int uvc_video_encode_data(struct uvc_streaming
> > > *stream, static void uvc_video_validate_buffer(const struct uvc_streaming
> > > *stream, struct uvc_buffer *buf)
> > >  {
> > > -	if (stream->frame_size != buf->bytesused &&
> > > +	if (stream->ctrl.dwMaxVideoFrameSize != buf->bytesused &&
> > >  	    !(stream->cur_format->flags & UVC_FMT_FLAG_COMPRESSED))
> > >  		buf->error = 1;
> > >  }
> > > diff --git a/drivers/media/usb/uvc/uvcvideo.h
> > > b/drivers/media/usb/uvc/uvcvideo.h index f585c08..897cfd8 100644
> > > --- a/drivers/media/usb/uvc/uvcvideo.h
> > > +++ b/drivers/media/usb/uvc/uvcvideo.h
> > > @@ -458,7 +458,6 @@ struct uvc_streaming {
> > >  	struct uvc_format *def_format;
> > >  	struct uvc_format *cur_format;
> > >  	struct uvc_frame *cur_frame;
> > > -	size_t frame_size;
> > > 
> > >  	/* Protect access to ctrl, cur_format, cur_frame and hardware video
> > >  	 * probe control.
> > 
> > -- 
> > Regards,
> > 
> > Laurent Pinchart
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
