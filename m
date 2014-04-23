Return-path: <linux-media-owner@vger.kernel.org>
Received: from pequod.mess.org ([80.229.237.210]:45736 "EHLO pequod.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755258AbaDWNZi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Apr 2014 09:25:38 -0400
Date: Wed, 23 Apr 2014 14:19:51 +0100
From: Sean Young <sean@mess.org>
To: Matt DeVillier <matt.devillier@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH ] fix mceusb endpoint type identification/handling
Message-ID: <20140423131951.GA17979@pequod.mess.org>
References: <5356F1DF.7030901@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5356F1DF.7030901@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Apr 22, 2014 at 05:49:03PM -0500, Matt DeVillier wrote:
> From: Matt DeVillier <matt.devillier@gmail.com>
> 
> Change the I/O endpoint handling of the mceusb driver to respect the
> endpoint type reported by device (bulk/interrupt), rather than
> treating all endpoints as type interrupt, which breaks devices using
> bulk endpoints when connected to a xhci controller.  Accordingly,
> change the function calls to initialize an endpoint's transfer pipe
> and urb handlers to use the correct function based on the endpoint
> type.
> 
> Signed-off-by: Matt DeVillier <matt.devillier@gmail.com>
> ---
> This is a continuation of the work started in patch #21648
> Patch compiled and tested against linux-media git master. Backported
> and tested against 3.14.1 stable as well.
> ---
> --- mceusb.c.orig    2014-04-22 13:48:51.186259472 -0500
> +++ mceusb.c    2014-04-22 14:46:12.378347584 -0500
> @@ -747,11 +747,17 @@ static void mce_request_packet(struct mc
>          }
> 
>          /* outbound data */
> -        pipe = usb_sndintpipe(ir->usbdev,
> -                      ir->usb_ep_out->bEndpointAddress);
> -        usb_fill_int_urb(async_urb, ir->usbdev, pipe,
> -            async_buf, size, mce_async_callback,
> -            ir, ir->usb_ep_out->bInterval);
> +        if ((ir->usb_ep_out->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK)
> +            == USB_ENDPOINT_XFER_INT) {
> +            pipe = usb_sndintpipe(ir->usbdev,
> ir->usb_ep_out->bEndpointAddress);

The lines are wrapped and tabs have been replaced with spaces; your mail
client messed with your patch.

See
https://www.kernel.org/doc/Documentation/email-clients.txt

> +            usb_fill_int_urb(async_urb, ir->usbdev, pipe, async_buf,
> +                     size, mce_async_callback, ir,
> ir->usb_ep_out->bInterval);
> +        } else {
> +            pipe = usb_sndbulkpipe(ir->usbdev,
> +                     ir->usb_ep_out->bEndpointAddress);
> +            usb_fill_bulk_urb(async_urb, ir->usbdev, pipe, async_buf,
> +                     size, mce_async_callback, ir);
> +        }
>          memcpy(async_buf, data, size);
> 
>      } else if (urb_type == MCEUSB_RX) {
> @@ -1271,38 +1277,48 @@ static int mceusb_dev_probe(struct usb_i
> 
>          if ((ep_in == NULL)
>              && ((ep->bEndpointAddress & USB_ENDPOINT_DIR_MASK)
> -                == USB_DIR_IN)
> -            && (((ep->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK)
> -                == USB_ENDPOINT_XFER_BULK)
> -            || ((ep->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK)
> -                == USB_ENDPOINT_XFER_INT))) {
> -
> -            ep_in = ep;
> -            ep_in->bmAttributes = USB_ENDPOINT_XFER_INT;
> -            ep_in->bInterval = 1;
> -            dev_dbg(&intf->dev, "acceptable inbound endpoint found");
> +            == USB_DIR_IN)) {
> +
> +            if ((ep->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK)
> +                == USB_ENDPOINT_XFER_BULK) {
> +
> +                ep_in = ep;
> +                mce_dbg(&intf->dev, "acceptable bulk inbound
> endpoint found\n");
> +            } else if ((ep->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK)
> +                == USB_ENDPOINT_XFER_INT) {
> +
> +                ep_in = ep;
> +                ep_in->bInterval = 1;
> +                mce_dbg(&intf->dev, "acceptable interrupt inbound
> endpoint found\n");
> +            }
>          }
> 
>          if ((ep_out == NULL)
>              && ((ep->bEndpointAddress & USB_ENDPOINT_DIR_MASK)
> -                == USB_DIR_OUT)
> -            && (((ep->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK)
> -                == USB_ENDPOINT_XFER_BULK)
> -            || ((ep->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK)
> -                == USB_ENDPOINT_XFER_INT))) {
> -
> -            ep_out = ep;
> -            ep_out->bmAttributes = USB_ENDPOINT_XFER_INT;
> -            ep_out->bInterval = 1;
> -            dev_dbg(&intf->dev, "acceptable outbound endpoint found");
> +            == USB_DIR_OUT)) {
> +            if ((ep->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK)
> +                == USB_ENDPOINT_XFER_BULK) {
> +                ep_out = ep;
> +                mce_dbg(&intf->dev, "acceptable bulk outbound
> endpoint found\n");
> +            } else if ((ep->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK)
> +                == USB_ENDPOINT_XFER_INT) {
> +                ep_out = ep;
> +                ep_out->bInterval = 1;
> +                mce_dbg(&intf->dev, "acceptable interrupt outbound
> endpoint found\n");
> +            }
>          }
>      }
> -    if (ep_in == NULL) {
> +    if (ep_in == NULL || ep_out == NULL) {

Although I think this is correct this is unrelated to the rest of the patch.

>          dev_dbg(&intf->dev, "inbound and/or endpoint not found");
>          return -ENODEV;
>      }
> 
> -    pipe = usb_rcvintpipe(dev, ep_in->bEndpointAddress);
> +    if ((ep_in->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK)
> +        == USB_ENDPOINT_XFER_INT) {
> +        pipe = usb_rcvintpipe(dev, ep_in->bEndpointAddress);
> +    } else {
> +        pipe = usb_rcvbulkpipe(dev, ep_in->bEndpointAddress);
> +    }
>      maxp = usb_maxpacket(dev, pipe, usb_pipeout(pipe));
> 
>      ir = kzalloc(sizeof(struct mceusb_dev), GFP_KERNEL);
> @@ -1343,8 +1359,14 @@ static int mceusb_dev_probe(struct usb_i
>          goto rc_dev_fail;
> 
>      /* wire up inbound data handler */
> -    usb_fill_int_urb(ir->urb_in, dev, pipe, ir->buf_in, maxp,
> -                mceusb_dev_recv, ir, ep_in->bInterval);
> +    if ((ep_in->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK)
> +        == USB_ENDPOINT_XFER_INT) {
> +        usb_fill_int_urb(ir->urb_in, dev, pipe, ir->buf_in, maxp,
> +                 mceusb_dev_recv, ir, ep_in->bInterval);
> +    } else {
> +        usb_fill_bulk_urb(ir->urb_in, dev, pipe, ir->buf_in, maxp,
> +                 mceusb_dev_recv, ir);
> +    }
>      ir->urb_in->transfer_dma = ir->dma_in;
>      ir->urb_in->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;

I've tested this patch and it does fix my mceusb device with bulk 
endpoints on xhci. So

Tested-by: Sean Young <sean@mess.org>

