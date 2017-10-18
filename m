Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:51478 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934106AbdJRIwV (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 18 Oct 2017 04:52:21 -0400
Date: Wed, 18 Oct 2017 10:52:11 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: Hans Yang <hansy@nvidia.com>, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH resend] [media] uvcvideo: zero seq number when disabling
 stream
In-Reply-To: <2456831.iuhP316MQr@avalon>
Message-ID: <alpine.DEB.2.20.1710181042550.11231@axis700.grange>
References: <1505456871-12680-1-git-send-email-hansy@nvidia.com> <2456831.iuhP316MQr@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Mon, 16 Oct 2017, Laurent Pinchart wrote:

> Hi Hans,
> 
> (CC'ing Guennadi Liakhovetski)
> 
> Thank you for the patch.
> 
> On Friday, 15 September 2017 09:27:51 EEST Hans Yang wrote:
> > For bulk-based devices, when disabling the video stream,
> > in addition to issue CLEAR_FEATURE(HALT), it is better to set
> > alternate setting 0 as well or the sequnce number in host
> > side will probably not reset to zero.
> 
> The USB 2.0 specificatin states in the description of the SET_INTERFACE 
> request that "If a device only supports a default setting for the specified 
> interface, then a STALL may be returned in the Status stage of the request".
> 
> The Linux implementation of usb_set_interface() deals with this by handling 
> STALL conditions and manually clearing HALT for all endpoints in the 
> interface, but I'm still concerned that this change could break existing bulk-
> based cameras. Do you know what other operating systems do when disabling the 
> stream on bulk cameras ? According to a comment in the driver Windows calls 
> CLEAR_FEATURE(HALT), but the situation might have changed since that was 
> tested.
> 
> Guennadi, how do your bulk-based cameras handle this ?

I don't know what design decisions are implemented there, but I tested a 
couple of cameras for sending a STREAMOFF after a few captured buffers, 
sleeping for a couple of seconds, requeuing buffers, sending STREAMON and 
capturing a few more - that seems to have worked. "Seems" because I only 
used a modified version of capture-example, I haven't checked buffer 
contents.

BTW, Hans, may I ask - what cameras did you use?

Thanks
Guennadi

> > Then in next time video stream start, the device will expect
> > host starts packet from 0 sequence number but host actually
> > continue the sequence number from last transaction and this
> > causes transaction errors.
> 
> Do you mean the DATA0/DATA1 toggle ? Why does the host continue toggling the 
> PID from the last transation ? The usb_clear_halt() function calls 
> usb_reset_endpoint() which should reset the DATA PID toggle.
> 
> > This commit fixes this by adding set alternate setting 0 back
> > as what isoch-based devices do.
> > 
> > Below error message will also be eliminated for some devices:
> > uvcvideo: Non-zero status (-71) in video completion handler.
> > 
> > Signed-off-by: Hans Yang <hansy@nvidia.com>
> > ---
> >  drivers/media/usb/uvc/uvc_video.c | 5 ++---
> >  1 file changed, 2 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/media/usb/uvc/uvc_video.c
> > b/drivers/media/usb/uvc/uvc_video.c index fb86d6af398d..ad80c2a6da6a 100644
> > --- a/drivers/media/usb/uvc/uvc_video.c
> > +++ b/drivers/media/usb/uvc/uvc_video.c
> > @@ -1862,10 +1862,9 @@ int uvc_video_enable(struct uvc_streaming *stream,
> > int enable)
> > 
> >  	if (!enable) {
> >  		uvc_uninit_video(stream, 1);
> > -		if (stream->intf->num_altsetting > 1) {
> > -			usb_set_interface(stream->dev->udev,
> > +		usb_set_interface(stream->dev->udev,
> >  					  stream->intfnum, 0);
> > -		} else {
> > +		if (stream->intf->num_altsetting == 1) {
> >  			/* UVC doesn't specify how to inform a bulk-based device
> >  			 * when the video stream is stopped. Windows sends a
> >  			 * CLEAR_FEATURE(HALT) request to the video streaming
> 
> -- 
> Regards,
> 
> Laurent Pinchart
> 
