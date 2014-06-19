Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42800 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757862AbaFSO2G (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Jun 2014 10:28:06 -0400
Message-ID: <53A2F36F.9090308@redhat.com>
Date: Thu, 19 Jun 2014 16:27:59 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Antonio Ospite <ao2@ao2.it>, linux-media@vger.kernel.org
CC: Alexander Sosna <alexander@xxor.de>
Subject: Re: [RFC 1/2] gspca: provide a mechanism to select a specific transfer
 endpoint
References: <53450D76.2010405@redhat.com> <1401913499-6475-1-git-send-email-ao2@ao2.it> <1401913499-6475-2-git-send-email-ao2@ao2.it>
In-Reply-To: <1401913499-6475-2-git-send-email-ao2@ao2.it>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Antonio,

Thanks for working on this.

On 06/04/2014 10:24 PM, Antonio Ospite wrote:
> Add a xfer_ep_index field to struct gspca_dev, and change alt_xfer() so
> that it accepts a parameter which represents a specific endpoint to look
> for.
> 
> If a subdriver wants to specify a value for gspca_dev->xfer_ep_index it
> can do that in its sd_config() callback.
> 
> Signed-off-by: Antonio Ospite <ao2@ao2.it>
> ---
> 
> I am not sure if it is OK to specify an endpoint _index_ or if it would be
> better to specify the endpoint address directly (in Kinect 0x81 is for video
> data and 0x82 is for depth data).
>
> Hans, any comment on that?

I think it would be better to use the endpoint address directly for this,
relying on the order in which the endpoints are listed in the descriptor
feels wrong to me.

Other then that this patch looks good.

Regards,

Hans


> 
> Thanks,
>    Antonio
> 
>  drivers/media/usb/gspca/gspca.c | 20 ++++++++++++++------
>  drivers/media/usb/gspca/gspca.h |  1 +
>  2 files changed, 15 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/media/usb/gspca/gspca.c b/drivers/media/usb/gspca/gspca.c
> index f3a7ace..7e5226c 100644
> --- a/drivers/media/usb/gspca/gspca.c
> +++ b/drivers/media/usb/gspca/gspca.c
> @@ -603,10 +603,13 @@ static void gspca_stream_off(struct gspca_dev *gspca_dev)
>  }
>  
>  /*
> - * look for an input transfer endpoint in an alternate setting
> + * look for an input transfer endpoint in an alternate setting.
> + *
> + * If xfer_ep_index is negative, return the first valid one found, otherwise
> + * look for exactly the one in position xfer_ep.
>   */
>  static struct usb_host_endpoint *alt_xfer(struct usb_host_interface *alt,
> -					  int xfer)
> +					  int xfer, int xfer_ep_index)
>  {
>  	struct usb_host_endpoint *ep;
>  	int i, attr;
> @@ -616,8 +619,10 @@ static struct usb_host_endpoint *alt_xfer(struct usb_host_interface *alt,
>  		attr = ep->desc.bmAttributes & USB_ENDPOINT_XFERTYPE_MASK;
>  		if (attr == xfer
>  		    && ep->desc.wMaxPacketSize != 0
> -		    && usb_endpoint_dir_in(&ep->desc))
> +		    && usb_endpoint_dir_in(&ep->desc)
> +		    && (xfer_ep_index < 0 || i == xfer_ep_index)) {
>  			return ep;
> +		}
>  	}
>  	return NULL;
>  }
> @@ -689,7 +694,7 @@ static int build_isoc_ep_tb(struct gspca_dev *gspca_dev,
>  		found = 0;
>  		for (j = 0; j < nbalt; j++) {
>  			ep = alt_xfer(&intf->altsetting[j],
> -				      USB_ENDPOINT_XFER_ISOC);
> +				      USB_ENDPOINT_XFER_ISOC, gspca_dev->xfer_ep_index);
>  			if (ep == NULL)
>  				continue;
>  			if (ep->desc.bInterval == 0) {
> @@ -862,7 +867,8 @@ static int gspca_init_transfer(struct gspca_dev *gspca_dev)
>  	/* if bulk or the subdriver forced an altsetting, get the endpoint */
>  	if (gspca_dev->alt != 0) {
>  		gspca_dev->alt--;	/* (previous version compatibility) */
> -		ep = alt_xfer(&intf->altsetting[gspca_dev->alt], xfer);
> +		ep = alt_xfer(&intf->altsetting[gspca_dev->alt], xfer,
> +			      gspca_dev->xfer_ep_index);
>  		if (ep == NULL) {
>  			pr_err("bad altsetting %d\n", gspca_dev->alt);
>  			return -EIO;
> @@ -904,7 +910,8 @@ static int gspca_init_transfer(struct gspca_dev *gspca_dev)
>  		if (!gspca_dev->cam.no_urb_create) {
>  			PDEBUG(D_STREAM, "init transfer alt %d", alt);
>  			ret = create_urbs(gspca_dev,
> -				alt_xfer(&intf->altsetting[alt], xfer));
> +				alt_xfer(&intf->altsetting[alt], xfer,
> +					 gspca_dev->xfer_ep_index));
>  			if (ret < 0) {
>  				destroy_urbs(gspca_dev);
>  				goto out;
> @@ -2030,6 +2037,7 @@ int gspca_dev_probe2(struct usb_interface *intf,
>  	}
>  	gspca_dev->dev = dev;
>  	gspca_dev->iface = intf->cur_altsetting->desc.bInterfaceNumber;
> +	gspca_dev->xfer_ep_index = -1;
>  
>  	/* check if any audio device */
>  	if (dev->actconfig->desc.bNumInterfaces != 1) {
> diff --git a/drivers/media/usb/gspca/gspca.h b/drivers/media/usb/gspca/gspca.h
> index 300642d..92317af 100644
> --- a/drivers/media/usb/gspca/gspca.h
> +++ b/drivers/media/usb/gspca/gspca.h
> @@ -205,6 +205,7 @@ struct gspca_dev {
>  	char memory;			/* memory type (V4L2_MEMORY_xxx) */
>  	__u8 iface;			/* USB interface number */
>  	__u8 alt;			/* USB alternate setting */
> +	int xfer_ep_index;		/* index of the USB transfer endpoint */
>  	u8 audio;			/* presence of audio device */
>  
>  	/* (*) These variables are proteced by both usb_lock and queue_lock,
> 
