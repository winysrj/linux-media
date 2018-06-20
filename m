Return-path: <linux-media-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:60306 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753569AbeFTNVs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Jun 2018 09:21:48 -0400
Date: Wed, 20 Jun 2018 15:21:44 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-usb@vger.kernel.org, tglx@linutronix.de
Subject: Re: [PATCH 27/27] media: uvcvideo: use usb_fill_int_urb()
Message-ID: <20180620132144.5cdu2ydlqre4ijg6@linutronix.de>
References: <20180620110105.19955-1-bigeasy@linutronix.de>
 <20180620110105.19955-28-bigeasy@linutronix.de>
 <3925059.Md1u3KRT1n@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <3925059.Md1u3KRT1n@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2018-06-20 14:55:23 [+0300], Laurent Pinchart wrote:
> Hi Sebastian,
Hi Laurent,

> Thank you for the patch.
> 
> On Wednesday, 20 June 2018 14:01:05 EEST Sebastian Andrzej Siewior wrote:
> > Using usb_fill_int_urb() helps to find code which initializes an
> > URB. A grep for members of the struct (like ->complete) reveal lots
> > of other things, too.
> > usb_fill_int_urb() also checks bInterval to be in the 1…16 range on
> > HS/SS.
> > 
> > Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> > Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> > ---
> >  drivers/media/usb/uvc/uvc_video.c | 14 ++++++--------
> >  1 file changed, 6 insertions(+), 8 deletions(-)
> > 
> > diff --git a/drivers/media/usb/uvc/uvc_video.c
> > b/drivers/media/usb/uvc/uvc_video.c index a88b2e51a666..79e7a827ed44 100644
> > --- a/drivers/media/usb/uvc/uvc_video.c
> > +++ b/drivers/media/usb/uvc/uvc_video.c
> > @@ -1619,21 +1619,19 @@ static int uvc_init_video_isoc(struct uvc_streaming
> > *stream, return -ENOMEM;
> >  		}
> > 
> > -		urb->dev = stream->dev->udev;
> > -		urb->context = stream;
> > -		urb->pipe = usb_rcvisocpipe(stream->dev->udev,
> > -				ep->desc.bEndpointAddress);
> > +		usb_fill_int_urb(urb, stream->dev->udev,
> > +				 usb_rcvisocpipe(stream->dev->udev,
> > +						 ep->desc.bEndpointAddress),
> > +				 stream->urb_buffer[i], size,
> > +				 uvc_video_complete, stream,
> > +				 ep->desc.bInterval);
> 
> You're filling an isoc URB with usb_fill_int_urb(), which is explicitly 
> documented as usable to fill an interrupt URB. Shouldn't we create a 
> usb_fill_isoc_urb() function ? It could just be an alias for 
> usb_fill_int_urb() if isoc and interrupt URBs don't need to be treated 
> differently. Alternatively, I'd be fine using usb_fill_int_urb() if the 
> function documentation's was updated to mention isoc URBs as well.

I thought I read it there but I couldn't find it. And then I found it in
Documentation/driver-api/usb/URB.rst:
| you specify. You can use the :c:func:`usb_fill_int_urb` macro to fill
| most ISO transfer fields.

So you simply asking that the kerneldoc of usb_fill_int_urb() is
extended to mention isoc, too?

> >  #ifndef CONFIG_DMA_NONCOHERENT
> >  		urb->transfer_flags = URB_ISO_ASAP | URB_NO_TRANSFER_DMA_MAP;
> >  		urb->transfer_dma = stream->urb_dma[i];
> >  #else
> >  		urb->transfer_flags = URB_ISO_ASAP;
> >  #endif
> > -		urb->interval = ep->desc.bInterval;
> 
> Unless I'm mistaken this introduces a change in behaviour for HS and SS, and 
> should thus be documented in the commit message. 
I did:

| usb_fill_int_urb() also checks bInterval to be in the 1…16 range on
| HS/SS.

so this wasn't enough?

> I suspect that this is the 
> real reason for this patch. I'd thus update the subject line to describe this 
> fix, and the body of the message to explain why using usb_fill_int_urb() is 
> the proper fix.

Actually no. I was looking for all the ->complete handlers and most of
them used usb_fill_… except a few. And while moving to the function I
was checking if everything stays the same (and mentioned ->interval
since ->start_frame is documented as a return parameter).

So here you are asking for a description update which explicit says
bug-fix?

> > -		urb->transfer_buffer = stream->urb_buffer[i];
> > -		urb->complete = uvc_video_complete;
> >  		urb->number_of_packets = npackets;
> > -		urb->transfer_buffer_length = size;
> 
> usb_fill_int_urb() sets urb->start_frame to -1. Does that impact us in any way 
> ?

It should not. The documentation says:
|  * @start_frame: Returns the initial frame for isochronous transfers.

> >  		for (j = 0; j < npackets; ++j) {
> >  			urb->iso_frame_desc[j].offset = j * psize;

Sebastian
