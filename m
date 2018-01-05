Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:37603 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751593AbeAEQgB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 5 Jan 2018 11:36:01 -0500
Message-ID: <1515170159.13494.1.camel@pengutronix.de>
Subject: Re: [PATCH] media: uvcvideo: support multiple frame descriptors
 with the same dimensions
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Philipp Zabel <philipp.zabel@gmail.com>
Cc: linux-media@vger.kernel.org
Date: Fri, 05 Jan 2018 17:35:59 +0100
In-Reply-To: <3663272.AjVBumhkVf@avalon>
References: <20180104225129.9488-1-philipp.zabel@gmail.com>
         <3663272.AjVBumhkVf@avalon>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Fri, 2018-01-05 at 15:30 +0200, Laurent Pinchart wrote:
> Hi Philipp,
> 
> Thank you for the patch.
> 
> On Friday, 5 January 2018 00:51:29 EET Philipp Zabel wrote:
> > The Microsoft HoloLens Sensors device has two separate frame descriptors
> > with the same dimensions, each with a single different frame interval:
> > 
> >       VideoStreaming Interface Descriptor:
> >         bLength                            30
> >         bDescriptorType                    36
> >         bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
> >         bFrameIndex                         1
> >         bmCapabilities                   0x00
> >           Still image unsupported
> >         wWidth                           1280
> >         wHeight                           481
> >         dwMinBitRate                147763200
> >         dwMaxBitRate                147763200
> >         dwMaxVideoFrameBufferSize      615680
> >         dwDefaultFrameInterval         333333
> >         bFrameIntervalType                  1
> >         dwFrameInterval( 0)            333333
> >       VideoStreaming Interface Descriptor:
> >         bLength                            30
> >         bDescriptorType                    36
> >         bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
> >         bFrameIndex                         2
> >         bmCapabilities                   0x00
> >           Still image unsupported
> >         wWidth                           1280
> >         wHeight                           481
> >         dwMinBitRate                443289600
> >         dwMaxBitRate                443289600
> >         dwMaxVideoFrameBufferSize      615680
> >         dwDefaultFrameInterval         111111
> >         bFrameIntervalType                  1
> >         dwFrameInterval( 0)            111111
> > 
> > Skip duplicate dimensions in enum_framesizes, let enum_frameintervals list
> > the intervals from both frame descriptors. Change set_streamparm to switch
> > to the correct frame index when changing the interval. This enables 90 fps
> > capture on a Lenovo Explorer Windows Mixed Reality headset.
> > 
> > Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
> > ---
> > Changes since v1 [1]:
> > - Break out of frame size loop if maxd == 0 in uvc_v4l2_set_streamparm.
> > - Moved d and tmp variables in uvc_v4l2_set_streamparm into loop,
> >   renamed tmp variable to tmp_ival.
> > - Changed i loop variables to unsigned int.
> > - Changed index variables to unsigned int.
> > - One line per variable declaration.
> > 
> > [1] https://patchwork.linuxtv.org/patch/46109/
> > ---
> >  drivers/media/usb/uvc/uvc_v4l2.c | 71
> > +++++++++++++++++++++++++++++++--------- 1 file changed, 55 insertions(+),
> > 16 deletions(-)
> > 
> > diff --git a/drivers/media/usb/uvc/uvc_v4l2.c
> > b/drivers/media/usb/uvc/uvc_v4l2.c index f5ab8164bca5..d9ee400bf47c 100644
> > --- a/drivers/media/usb/uvc/uvc_v4l2.c
> > +++ b/drivers/media/usb/uvc/uvc_v4l2.c
> > @@ -373,7 +373,10 @@ static int uvc_v4l2_set_streamparm(struct uvc_streaming
> > *stream, {
> >  	struct uvc_streaming_control probe;
> >  	struct v4l2_fract timeperframe;
> > -	uint32_t interval;
> > +	struct uvc_format *format;
> > +	struct uvc_frame *frame;
> > +	__u32 interval, maxd;
> > +	unsigned int i;
> >  	int ret;
> > 
> >  	if (parm->type != stream->type)
> > @@ -396,9 +399,33 @@ static int uvc_v4l2_set_streamparm(struct uvc_streaming
> > *stream, return -EBUSY;
> >  	}
> > 
> > +	format = stream->cur_format;
> > +	frame = stream->cur_frame;
> >  	probe = stream->ctrl;
> > -	probe.dwFrameInterval =
> > -		uvc_try_frame_interval(stream->cur_frame, interval);
> > +	probe.dwFrameInterval = uvc_try_frame_interval(frame, interval);
> > +	maxd = abs((__s32)probe.dwFrameInterval - interval);
> > +
> > +	/* Try frames with matching size to find the best frame interval. */
> > +	for (i = 0; i < format->nframes && maxd != 0; i++) {
> > +		__u32 d, tmp_ival;
>
> How about ival instead of tmp_ival ?
> 
> Apart from that,
> 
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> If you're fine with the change there's no need to resubmit.

Absolutely, thanks for the review!

regards
Philipp
