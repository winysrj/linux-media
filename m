Return-path: <linux-media-owner@vger.kernel.org>
Received: from pequod.mess.org ([80.229.237.210]:57376 "EHLO pequod.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751480AbaAOQwr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Jan 2014 11:52:47 -0500
Date: Wed, 15 Jan 2014 16:52:45 +0000
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Martin Kittel <linux@martin-kittel.de>,
	linux-media@vger.kernel.org, Jarod Wilson <jwilson@redhat.com>
Subject: Re: Patch mceusb: fix invalid urb interval
Message-ID: <20140115165245.GA23620@pequod.mess.org>
References: <loom.20131110T113621-661@post.gmane.org>
 <20131211131751.GA434@pequod.mess.org>
 <l8ai94$cbr$1@ger.gmane.org>
 <20140115134917.1450f87c@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140115134917.1450f87c@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jan 15, 2014 at 01:49:17PM -0200, Mauro Carvalho Chehab wrote:
> Hi Martin,
> 
> Em Wed, 11 Dec 2013 21:34:55 +0100
> Martin Kittel <linux@martin-kittel.de> escreveu:
> 
> > Hi Mauro, hi Sean,
> > 
> > thanks for considering the patch. I have added an updated version at the
> > end of this mail.
> > 
> > Regarding the info Sean was requesting, it is indeed an xhci hub. I also
> > added the details of the remote itself.
> > 
> > Please let me know if there is anything missing.
> > 
> > Best wishes,
> > 
> > Martin.
> > 
> > 
> > lsusb -vvv
> > ------
> > Bus 001 Device 002: ID 2304:0225 Pinnacle Systems, Inc. Remote Kit
> > Infrared Transceiver
> > Device Descriptor:
> >   bLength		 18
> >   bDescriptorType	  1
> >   bcdUSB	       2.00
> >   bDeviceClass		  0 (Defined at Interface level)
> >   bDeviceSubClass	  0
> >   bDeviceProtocol	  0
> >   bMaxPacketSize0	  8
> >   idVendor	     0x2304 Pinnacle Systems, Inc.
> >   idProduct	     0x0225 Remote Kit Infrared Transceiver
> >   bcdDevice	       0.01
> >   iManufacturer		  1 Pinnacle Systems
> >   iProduct		  2 PCTV Remote USB
> >   iSerial		  5 7FFFFFFFFFFFFFFF
> >   bNumConfigurations	  1
> >   Configuration Descriptor:
> >     bLength		    9
> >     bDescriptorType	    2
> >     wTotalLength	   32
> >     bNumInterfaces	    1
> >     bConfigurationValue	    1
> >     iConfiguration	    3 StandardConfiguration
> >     bmAttributes	 0xa0
> >       (Bus Powered)
> >       Remote Wakeup
> >     MaxPower		  100mA
> >     Interface Descriptor:
> >       bLength		      9
> >       bDescriptorType	      4
> >       bInterfaceNumber	      0
> >       bAlternateSetting	      0
> >       bNumEndpoints	      2
> >       bInterfaceClass	    255 Vendor Specific Class
> >       bInterfaceSubClass      0
> >       bInterfaceProtocol      0
> >       iInterface	      4 StandardInterface
> >       Endpoint Descriptor:
> > 	bLength			7
> > 	bDescriptorType		5
> > 	bEndpointAddress     0x81  EP 1 IN
> > 	bmAttributes		2
> > 	  Transfer Type		   Bulk
> > 	  Synch Type		   None
> > 	  Usage Type		   Data
> > 	wMaxPacketSize	   0x0040  1x 64 bytes
> > 	bInterval	       10
> 
> Hmm... interval is equal to 10, e. g. 125us * 2^(10 - 1) = 64 ms.
> 
> I'm wandering why mceusb is just forcing the interval to 1 (125ms). That
> sounds wrong, except, of course, if the endpoint descriptor is wrong.

Note that the endpoint descriptor describes it as a bulk endpoint, but
it is used as a interrupt endpoint by the driver. For bulk endpoints,
the interval should not be used (?).

Maybe the correct solution would be to use the endpoints as bulk endpoints
if that is what the endpoint says? mceusb devices come in interrupt and 
bulk flavours.

> On my eyes, though, 64ms seems to be a good enough interval to get
> those events.

Each packet will be 64 bytes, and at 64 ms you should be able to 960 
bytes per second. That's more than enough.

> Jarod/Sean,
> 
> Are there any good reason for the mceusb driver to do this?
> 	ep_in->bInterval = 1;
> 	ep_out->bInterval = 1;

I don't know.
 
> At least on my tests here with audio with xHCI and EHCI with audio on
> em28xx, it seems that EHCI just uses the USB endpoint interval, when
> urb->interval == 1, while xHCI uses whatever value stored there.

The xhci driver is not happy about the interval being changed. With
CONFIG_USB_DEBUG you get:

usb 3-12: Driver uses different interval (8 microframes) than xHCI (1 microframe)


Sean
