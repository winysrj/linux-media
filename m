Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:35163 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933154AbeFTUuv (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Jun 2018 16:50:51 -0400
Date: Wed, 20 Jun 2018 21:50:49 +0100
From: Sean Young <sean@mess.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-usb@vger.kernel.org, tglx@linutronix.de
Subject: Re: [PATCH 22/27] media: ttusbir: use usb_fill_int_urb()
Message-ID: <20180620205049.dh6ewnlxbphfg7wi@gofer.mess.org>
References: <20180620110105.19955-1-bigeasy@linutronix.de>
 <20180620110105.19955-23-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180620110105.19955-23-bigeasy@linutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jun 20, 2018 at 01:01:00PM +0200, Sebastian Andrzej Siewior wrote:
> Using usb_fill_int_urb() helps to find code which initializes an
> URB. A grep for members of the struct (like ->complete) reveal lots
> of other things, too.

The reason I didn't use usb_fill_int_urb() is that is not an interrupt
urb, it's a iso urb. I'm not sure what affect the interval handling
in usb_fill_int_urb() will have on this.


Sean

> 
> Cc: Sean Young <sean@mess.org>
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>  drivers/media/rc/ttusbir.c | 10 +++-------
>  1 file changed, 3 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/media/rc/ttusbir.c b/drivers/media/rc/ttusbir.c
> index aafea3c5170b..6a7c9b50ff5a 100644
> --- a/drivers/media/rc/ttusbir.c
> +++ b/drivers/media/rc/ttusbir.c
> @@ -257,10 +257,6 @@ static int ttusbir_probe(struct usb_interface *intf,
>  			goto out;
>  		}
>  
> -		urb->dev = tt->udev;
> -		urb->context = tt;
> -		urb->pipe = usb_rcvisocpipe(tt->udev, tt->iso_in_endp);
> -		urb->interval = 1;
>  		buffer = usb_alloc_coherent(tt->udev, 128, GFP_KERNEL,
>  						&urb->transfer_dma);
>  		if (!buffer) {
> @@ -268,11 +264,11 @@ static int ttusbir_probe(struct usb_interface *intf,
>  			ret = -ENOMEM;
>  			goto out;
>  		}
> +		usb_fill_int_urb(urb, tt->udev,
> +				 usb_rcvisocpipe(tt->udev, tt->iso_in_endp),
> +				 buffer, 128, ttusbir_urb_complete, tt, 1);
>  		urb->transfer_flags = URB_NO_TRANSFER_DMA_MAP | URB_ISO_ASAP;
> -		urb->transfer_buffer = buffer;
> -		urb->complete = ttusbir_urb_complete;
>  		urb->number_of_packets = 8;
> -		urb->transfer_buffer_length = 128;
>  
>  		for (j = 0; j < 8; j++) {
>  			urb->iso_frame_desc[j].offset = j * 16;
> -- 
> 2.17.1
