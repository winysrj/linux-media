Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:37290
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753700AbcKUOQ1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Nov 2016 09:16:27 -0500
Date: Mon, 21 Nov 2016 12:16:20 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Felipe Balbi <felipe.balbi@linux.intel.com>
Cc: Linux USB <linux-usb@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 13/82] media: usbtv: core: make use of new
 usb_endpoint_maxp_mult()
Message-ID: <20161121121620.21ff91f8@vento.lan>
In-Reply-To: <20161031104914.1990-14-felipe.balbi@linux.intel.com>
References: <20161031104914.1990-1-felipe.balbi@linux.intel.com>
        <20161031104914.1990-14-felipe.balbi@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 31 Oct 2016 12:48:05 +0200
Felipe Balbi <felipe.balbi@linux.intel.com> escreveu:

> We have introduced a helper to calculate multiplier
> value from wMaxPacketSize. Start using it.

Good idea! Btw, we have something similar at em28xx, stk1160-core.c and
tm6000 drivers. On them, we have this:
	/* high bandwidth multiplier, as encoded in highspeed endpoint descriptors */
	#define hb_mult(wMaxPacketSize) (1 + (((wMaxPacketSize) >> 11) & 0x03))

PLease add the same changes for the above files on this patch.

Btw, are you planning to send this patch via USB tree or via the
media one? If you want to send via USB, after this change,
feel free to add my ack:

	Acked-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>


> 
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> Cc: <linux-media@vger.kernel.org>
> Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
> ---
>  drivers/media/usb/usbtv/usbtv-core.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/usb/usbtv/usbtv-core.c b/drivers/media/usb/usbtv/usbtv-core.c
> index dc76fd41e00f..ceb953be0770 100644
> --- a/drivers/media/usb/usbtv/usbtv-core.c
> +++ b/drivers/media/usb/usbtv/usbtv-core.c
> @@ -71,6 +71,7 @@ static int usbtv_probe(struct usb_interface *intf,
>  	int size;
>  	struct device *dev = &intf->dev;
>  	struct usbtv *usbtv;
> +	struct usb_host_endpoint *ep;
>  
>  	/* Checks that the device is what we think it is. */
>  	if (intf->num_altsetting != 2)
> @@ -78,10 +79,12 @@ static int usbtv_probe(struct usb_interface *intf,
>  	if (intf->altsetting[1].desc.bNumEndpoints != 4)
>  		return -ENODEV;
>  
> +	ep = &intf->altsetting[1].endpoint[0];
> +
>  	/* Packet size is split into 11 bits of base size and count of
>  	 * extra multiplies of it.*/
> -	size = usb_endpoint_maxp(&intf->altsetting[1].endpoint[0].desc);
> -	size = (size & 0x07ff) * (((size & 0x1800) >> 11) + 1);
> +	size = usb_endpoint_maxp(&ep->desc);
> +	size = (size & 0x07ff) * usb_endpoint_maxp_mult(&ep->desc);
>  
>  	/* Device structure */
>  	usbtv = kzalloc(sizeof(struct usbtv), GFP_KERNEL);


Thanks,
Mauro
