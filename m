Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w2.samsung.com ([211.189.100.12]:25508 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502AbaAOPtY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Jan 2014 10:49:24 -0500
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by mailout2.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MZG00F1T9ABLZ80@mailout2.w2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 15 Jan 2014 10:49:23 -0500 (EST)
Date: Wed, 15 Jan 2014 13:49:17 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Martin Kittel <linux@martin-kittel.de>
Cc: linux-media@vger.kernel.org, Jarod Wilson <jwilson@redhat.com>,
	Sean Young <sean@mess.org>
Subject: Re: Patch mceusb: fix invalid urb interval
Message-id: <20140115134917.1450f87c@samsung.com>
In-reply-to: <l8ai94$cbr$1@ger.gmane.org>
References: <loom.20131110T113621-661@post.gmane.org>
 <20131211131751.GA434@pequod.mess.org> <l8ai94$cbr$1@ger.gmane.org>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Martin,

Em Wed, 11 Dec 2013 21:34:55 +0100
Martin Kittel <linux@martin-kittel.de> escreveu:

> Hi Mauro, hi Sean,
> 
> thanks for considering the patch. I have added an updated version at the
> end of this mail.
> 
> Regarding the info Sean was requesting, it is indeed an xhci hub. I also
> added the details of the remote itself.
> 
> Please let me know if there is anything missing.
> 
> Best wishes,
> 
> Martin.
> 
> 
> lsusb -vvv
> ------
> Bus 001 Device 002: ID 2304:0225 Pinnacle Systems, Inc. Remote Kit
> Infrared Transceiver
> Device Descriptor:
>   bLength		 18
>   bDescriptorType	  1
>   bcdUSB	       2.00
>   bDeviceClass		  0 (Defined at Interface level)
>   bDeviceSubClass	  0
>   bDeviceProtocol	  0
>   bMaxPacketSize0	  8
>   idVendor	     0x2304 Pinnacle Systems, Inc.
>   idProduct	     0x0225 Remote Kit Infrared Transceiver
>   bcdDevice	       0.01
>   iManufacturer		  1 Pinnacle Systems
>   iProduct		  2 PCTV Remote USB
>   iSerial		  5 7FFFFFFFFFFFFFFF
>   bNumConfigurations	  1
>   Configuration Descriptor:
>     bLength		    9
>     bDescriptorType	    2
>     wTotalLength	   32
>     bNumInterfaces	    1
>     bConfigurationValue	    1
>     iConfiguration	    3 StandardConfiguration
>     bmAttributes	 0xa0
>       (Bus Powered)
>       Remote Wakeup
>     MaxPower		  100mA
>     Interface Descriptor:
>       bLength		      9
>       bDescriptorType	      4
>       bInterfaceNumber	      0
>       bAlternateSetting	      0
>       bNumEndpoints	      2
>       bInterfaceClass	    255 Vendor Specific Class
>       bInterfaceSubClass      0
>       bInterfaceProtocol      0
>       iInterface	      4 StandardInterface
>       Endpoint Descriptor:
> 	bLength			7
> 	bDescriptorType		5
> 	bEndpointAddress     0x81  EP 1 IN
> 	bmAttributes		2
> 	  Transfer Type		   Bulk
> 	  Synch Type		   None
> 	  Usage Type		   Data
> 	wMaxPacketSize	   0x0040  1x 64 bytes
> 	bInterval	       10

Hmm... interval is equal to 10, e. g. 125us * 2^(10 - 1) = 64 ms.

I'm wandering why mceusb is just forcing the interval to 1 (125ms). That
sounds wrong, except, of course, if the endpoint descriptor is wrong.

On my eyes, though, 64ms seems to be a good enough interval to get
those events.

Jarod/Sean,

Are there any good reason for the mceusb driver to do this?
	ep_in->bInterval = 1;
	ep_out->bInterval = 1;

At least on my tests here with audio with xHCI and EHCI with audio on
em28xx, it seems that EHCI just uses the USB endpoint interval, when
urb->interval == 1, while xHCI uses whatever value stored there.

So, IMHO, the right fix would be to do:

diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index a25bb1581e46..9a0c2ca53f3a 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -1285,7 +1285,6 @@ static int mceusb_dev_probe(struct usb_interface *intf,
 
 			ep_in = ep;
 			ep_in->bmAttributes = USB_ENDPOINT_XFER_INT;
-			ep_in->bInterval = 1;
 			mce_dbg(&intf->dev, "acceptable inbound endpoint "
 				"found\n");
 		}
@@ -1300,7 +1299,6 @@ static int mceusb_dev_probe(struct usb_interface *intf,
 
 			ep_out = ep;
 			ep_out->bmAttributes = USB_ENDPOINT_XFER_INT;
-			ep_out->bInterval = 1;
 			mce_dbg(&intf->dev, "acceptable outbound endpoint "
 				"found\n");
 		}


Martin,

Could you please see if the above patch is enough to fix it?

Thanks!
Mauro
