Return-path: <linux-media-owner@vger.kernel.org>
Received: from pequod.mess.org ([80.229.237.210]:55247 "EHLO pequod.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752138AbaASV4v (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Jan 2014 16:56:51 -0500
Date: Sun, 19 Jan 2014 21:56:48 +0000
From: Sean Young <sean@mess.org>
To: Martin Kittel <linux@martin-kittel.de>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org, Jarod Wilson <jwilson@redhat.com>
Subject: Re: Patch mceusb: fix invalid urb interval
Message-ID: <20140119215648.GA15388@pequod.mess.org>
References: <loom.20131110T113621-661@post.gmane.org>
 <20131211131751.GA434@pequod.mess.org>
 <l8ai94$cbr$1@ger.gmane.org>
 <20140115134917.1450f87c@samsung.com>
 <20140115165245.GA23620@pequod.mess.org>
 <20140115155923.0b8978da.m.chehab@samsung.com>
 <52DC3E0B.6010202@martin-kittel.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52DC3E0B.6010202@martin-kittel.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Jan 19, 2014 at 10:05:15PM +0100, Martin Kittel wrote:
> Hi Mauro, hi Sean,
> 
> On 01/15/2014 06:59 PM, Mauro Carvalho Chehab wrote:
> > Em Wed, 15 Jan 2014 16:52:45 +0000
> > Sean Young <sean@mess.org> escreveu:
> > 
> >> On Wed, Jan 15, 2014 at 01:49:17PM -0200, Mauro Carvalho Chehab wrote:
> >>> Hi Martin,
> >>>
> >>> Em Wed, 11 Dec 2013 21:34:55 +0100
> >>> Martin Kittel <linux@martin-kittel.de> escreveu:
> >>>
> >>>> Hi Mauro, hi Sean,
> >>>>
> >>>> thanks for considering the patch. I have added an updated version at the
> >>>> end of this mail.
> >>>>
> >>>> Regarding the info Sean was requesting, it is indeed an xhci hub. I also
> >>>> added the details of the remote itself.
> >>>>
> >>>> Please let me know if there is anything missing.
> >>>>
> >>>> Best wishes,
> >>>>
> >>>> Martin.
> >>>>
> >>>>
> >>>> lsusb -vvv
> >>>> ------
> >>>> Bus 001 Device 002: ID 2304:0225 Pinnacle Systems, Inc. Remote Kit
> >>>> Infrared Transceiver
> >>>> Device Descriptor:
> >>>>   bLength		 18
> >>>>   bDescriptorType	  1
> >>>>   bcdUSB	       2.00
> >>>>   bDeviceClass		  0 (Defined at Interface level)
> >>>>   bDeviceSubClass	  0
> >>>>   bDeviceProtocol	  0
> >>>>   bMaxPacketSize0	  8
> >>>>   idVendor	     0x2304 Pinnacle Systems, Inc.
> >>>>   idProduct	     0x0225 Remote Kit Infrared Transceiver
> >>>>   bcdDevice	       0.01
> >>>>   iManufacturer		  1 Pinnacle Systems
> >>>>   iProduct		  2 PCTV Remote USB
> >>>>   iSerial		  5 7FFFFFFFFFFFFFFF
> >>>>   bNumConfigurations	  1
> >>>>   Configuration Descriptor:
> >>>>     bLength		    9
> >>>>     bDescriptorType	    2
> >>>>     wTotalLength	   32
> >>>>     bNumInterfaces	    1
> >>>>     bConfigurationValue	    1
> >>>>     iConfiguration	    3 StandardConfiguration
> >>>>     bmAttributes	 0xa0
> >>>>       (Bus Powered)
> >>>>       Remote Wakeup
> >>>>     MaxPower		  100mA
> >>>>     Interface Descriptor:
> >>>>       bLength		      9
> >>>>       bDescriptorType	      4
> >>>>       bInterfaceNumber	      0
> >>>>       bAlternateSetting	      0
> >>>>       bNumEndpoints	      2
> >>>>       bInterfaceClass	    255 Vendor Specific Class
> >>>>       bInterfaceSubClass      0
> >>>>       bInterfaceProtocol      0
> >>>>       iInterface	      4 StandardInterface
> >>>>       Endpoint Descriptor:
> >>>> 	bLength			7
> >>>> 	bDescriptorType		5
> >>>> 	bEndpointAddress     0x81  EP 1 IN
> >>>> 	bmAttributes		2
> >>>> 	  Transfer Type		   Bulk
> >>>> 	  Synch Type		   None
> >>>> 	  Usage Type		   Data
> >>>> 	wMaxPacketSize	   0x0040  1x 64 bytes
> >>>> 	bInterval	       10
> >>>
> >>> Hmm... interval is equal to 10, e. g. 125us * 2^(10 - 1) = 64 ms.
> >>>
> >>> I'm wandering why mceusb is just forcing the interval to 1 (125ms). That
> >>> sounds wrong, except, of course, if the endpoint descriptor is wrong.
> >>
> >> Note that the endpoint descriptor describes it as a bulk endpoint, but
> >> it is used as a interrupt endpoint by the driver. For bulk endpoints,
> >> the interval should not be used (?).
> >>
> >> Maybe the correct solution would be to use the endpoints as bulk endpoints
> >> if that is what the endpoint says? mceusb devices come in interrupt and 
> >> bulk flavours.
> > 
> > Yes, this could be a possible fix.
> > 
> 
> I have tried this and the driver is working fine without my initial fix.
> I haven't been running with the bulk setting for long, but so far I
> haven't seen the spurious 'xhci_queue_intr_tx: <number> callbacks
> suppressed' messages like I have before.
> 
> The current version of the patch against 3.13-rc8 is below.
> 
> Please let me know if there is anything else I should check or further
> rework is needed.
> 
> Thanks for your help and best wishes,
> 
> Martin.
> 
> -----------
> 
> >From a71676dad29adef9cafb08598e693ec308ba2e95 Mon Sep 17 00:00:00 2001
> From: Martin Kittel <linux@martin-kittel.de>
> Date: Sun, 19 Jan 2014 21:24:55 +0100
> Subject: [PATCH] mceusb: use endpoint xfer mode as advertised
> 
> mceusb always sets endpoints to interrupt transfer mode no matter
> what the device itself is advertising. This causes trouble on xhci
> hubs. This patch changes the behavior to honor the device endpoint
> settings.

This patch is wrong. I get:

[   60.962727] ------------[ cut here ]------------
[   60.962729] WARNING: CPU: 0 PID: 0 at drivers/usb/core/urb.c:452 usb_submit_u
rb+0x1fd/0x5b0()
[   60.962730] usb 3-2: BOGUS urb xfer, pipe 1 != type 3

This is because the patch no longer sets the endpoints to interrupt
endpoints, but still uses the interrupt functions like
usb_fill_int_urb().

> 
> Signed-off-by: Martin Kittel <linux@martin-kittel.de>
> ---
>  drivers/media/rc/mceusb.c | 51
> ++++++++++++++++++++++++++---------------------
>  1 file changed, 28 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
> index a25bb15..67df9a6 100644
> --- a/drivers/media/rc/mceusb.c
> +++ b/drivers/media/rc/mceusb.c
> @@ -1277,32 +1277,37 @@ static int mceusb_dev_probe(struct usb_interface
> *intf,
> 
>  		if ((ep_in == NULL)
>  			&& ((ep->bEndpointAddress & USB_ENDPOINT_DIR_MASK)
> -			    == USB_DIR_IN)
> -			&& (((ep->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK)
> -			    == USB_ENDPOINT_XFER_BULK)
> -			|| ((ep->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK)
> -			    == USB_ENDPOINT_XFER_INT))) {
> -
> -			ep_in = ep;
> -			ep_in->bmAttributes = USB_ENDPOINT_XFER_INT;
> -			ep_in->bInterval = 1;
> -			mce_dbg(&intf->dev, "acceptable inbound endpoint "
> -				"found\n");
> +			    == USB_DIR_IN)) {
> +			if ((ep->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK)
> +			    == USB_ENDPOINT_XFER_BULK) {
> +				ep_in = ep;
> +				mce_dbg(&intf->dev, "acceptable bulk inbound endpoint "
> +					"found\n");
> +			}
> +			if ((ep->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK)
> +			    == USB_ENDPOINT_XFER_INT) {
> +				ep_in = ep;
> +				ep_in->bInterval = 1;
> +				mce_dbg(&intf->dev, "acceptable interrupt inbound endpoint "
> +					"found\n");
> +			}
>  		}
> -
>  		if ((ep_out == NULL)
>  			&& ((ep->bEndpointAddress & USB_ENDPOINT_DIR_MASK)
> -			    == USB_DIR_OUT)
> -			&& (((ep->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK)
> -			    == USB_ENDPOINT_XFER_BULK)
> -			|| ((ep->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK)
> -			    == USB_ENDPOINT_XFER_INT))) {
> -
> -			ep_out = ep;
> -			ep_out->bmAttributes = USB_ENDPOINT_XFER_INT;
> -			ep_out->bInterval = 1;
> -			mce_dbg(&intf->dev, "acceptable outbound endpoint "
> -				"found\n");
> +			    == USB_DIR_OUT)) {
> +			if ((ep->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK)
> +			    == USB_ENDPOINT_XFER_BULK) {
> +				ep_out = ep;
> +				mce_dbg(&intf->dev, "acceptable bulk outbound endpoint "
> +					"found\n");
> +			}
> +			if ((ep->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK)
> +			    == USB_ENDPOINT_XFER_INT) {
> +				ep_out = ep;
> +				ep_out->bInterval = 1;
> +				mce_dbg(&intf->dev, "acceptable interrupt outbound endpoint "
> +					"found\n");
> +			}
>  		}
>  	}
>  	if (ep_in == NULL) {
> -- 
> 1.8.4.rc3
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
