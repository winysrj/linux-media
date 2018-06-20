Return-path: <linux-media-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:47784 "HELO
        iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1754192AbeFTPkV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Jun 2018 11:40:21 -0400
Date: Wed, 20 Jun 2018 11:40:20 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        <linux-usb@vger.kernel.org>, <tglx@linutronix.de>
Subject: Re: [PATCH 27/27 v2] media: uvcvideo: use usb_fill_int_urb() for
 the ->intarval value
In-Reply-To: <20180620152122.ebstiwvdpbhgsbrs@linutronix.de>
Message-ID: <Pine.LNX.4.44L0.1806201135580.1758-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 20 Jun 2018, Sebastian Andrzej Siewior wrote:

> uvc_init_video_isoc() assigns
> 	urb->interval = p->desc.bInterval;
> 
> for the interval. This is correct for FS/LS.

That's a strange thing to say.  For one thing, LS devices don't support 
isochronous transfers at all.  And while this assignment would be 
correct for FS interrupt URBs, it is wrong for FS isochronous URBs.

> For HS/SS the bInterval
> value is using a logarithmic encoding. The usb_fill_int_urb() function
> takes this into account while settings the ->interval member.
> ->start_frame is set to -1 on init and should be filled by the HC on
> completion of the URB.
> 
> Use usb_fill_int_urb() to fill the members of the struct urb.

Please don't do this.  If you instead on using an inline routine to 
save on source code, create an explicit usb_fill_isoc_urb() function.

Alan Stern

> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>  drivers/media/usb/uvc/uvc_video.c | 14 ++++++--------
>  1 file changed, 6 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
> index a88b2e51a666..79e7a827ed44 100644
> --- a/drivers/media/usb/uvc/uvc_video.c
> +++ b/drivers/media/usb/uvc/uvc_video.c
> @@ -1619,21 +1619,19 @@ static int uvc_init_video_isoc(struct uvc_streaming *stream,
>  			return -ENOMEM;
>  		}
>  
> -		urb->dev = stream->dev->udev;
> -		urb->context = stream;
> -		urb->pipe = usb_rcvisocpipe(stream->dev->udev,
> -				ep->desc.bEndpointAddress);
> +		usb_fill_int_urb(urb, stream->dev->udev,
> +				 usb_rcvisocpipe(stream->dev->udev,
> +						 ep->desc.bEndpointAddress),
> +				 stream->urb_buffer[i], size,
> +				 uvc_video_complete, stream,
> +				 ep->desc.bInterval);
>  #ifndef CONFIG_DMA_NONCOHERENT
>  		urb->transfer_flags = URB_ISO_ASAP | URB_NO_TRANSFER_DMA_MAP;
>  		urb->transfer_dma = stream->urb_dma[i];
>  #else
>  		urb->transfer_flags = URB_ISO_ASAP;
>  #endif
> -		urb->interval = ep->desc.bInterval;
> -		urb->transfer_buffer = stream->urb_buffer[i];
> -		urb->complete = uvc_video_complete;
>  		urb->number_of_packets = npackets;
> -		urb->transfer_buffer_length = size;
>  
>  		for (j = 0; j < npackets; ++j) {
>  			urb->iso_frame_desc[j].offset = j * psize;
> 
