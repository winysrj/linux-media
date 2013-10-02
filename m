Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w2.samsung.com ([211.189.100.11]:15311 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753503Ab3JBMeB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Oct 2013 08:34:01 -0400
Date: Wed, 02 Oct 2013 09:33:54 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Xenia Ragiadakou <burzalodowa@gmail.com>,
	linux-usb@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: New USB core API to change interval and max packet size
Message-id: <20131002093354.507cd24d@samsung.com>
In-reply-to: <20131001204554.GB15395@xanatos>
References: <524B1BF4.6000305@gmail.com> <20131001204554.GB15395@xanatos>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sarah,

Em Tue, 1 Oct 2013 13:45:54 -0700
Sarah Sharp <sarah.a.sharp@linux.intel.com> escreveu:

> On Tue, Oct 01, 2013 at 10:01:08PM +0300, Xenia Ragiadakou wrote:
> > Hi Sarah,
> > 
> > I read the mail on 'possible conflict between xhci_hcd and a patched
> > usbhid'.
> 
> For reference to others:
> http://marc.info/?l=linux-usb&m=138064948726038&w=2
> http://marc.info/?l=linux-usb&m=138065201426880&w=2
> 
> > I looked in xhci and the problem arises in xhci_queue_intr_tx() when
> > if (xhci_interval != ep_interval) {
> >     ...
> >     urb->interval = xhci_interval;
> > }
> > 
> > right?
> 
> Yes.  The underlying problem is that the xHCI host sets up the endpoint
> contexts during the Configure Endpoint command, using the interval from
> the device's endpoint descriptors.  It also uses the endpoint descriptor
> wMaxPacketSize, which can be wrong as well.  If the device driver wants
> to use a different urb->interval than is in the endpoint descriptor, the
> xHCI driver will simply ignore it.
> 
> (I'm Ccing the linux-media list, as I've discussed some of these devices
> with broken descriptors before.)
> 
> > When you say a new API, what do you mean? New functions in usbcore
> > to be used by usb device drivers?
> 
> Yes.  You would export the function in the USB core, and put a prototype
> in a USB include file (probably in include/linux/usb.h).  Let's say that
> function is called usb_change_ep_bandwidth.
> 
> Drivers could call into that function when they needed to change either
> the bInterval or wMaxPacketSize of a particular endpoint.  This could be
> during the driver's probe function, or before switching alternate
> interface settings, or even after the alt setting is in place, but
> userspace dictates the driver use a different bandwidth.
> 
> Drivers should pass usb_change_ep_bandwidth a pointer to the endpoint
> they need to change, along with the bInterval and wMaxPacketSize values
> they would like the endpoint to have.  Those values could be stored as
> new values in struct usb_host_endpoint.

Let me see if I understand the changes at the media drivers. So, please
correct me if I got it wrong.

I'm yet to get any USB 3.0 media device, although it is common to connect
an USB 1.1 or USB 2.0 device on a USB 3.0 host port.

So, for example, on this device:

	Bus 003 Device 002: ID 2040:6600 Hauppauge 
	Device Descriptor:
	  bLength                18
	  bDescriptorType         1
	  bcdUSB               2.00
	  bDeviceClass            0 (Defined at Interface level)
	  bDeviceSubClass         0 
	  bDeviceProtocol         0 
	  bMaxPacketSize0        64
	  idVendor           0x2040 Hauppauge
	  idProduct          0x6600 
	  bcdDevice            0.69
	  iManufacturer          16 
	  iProduct               32 HVR900H
	  iSerial                64 4031932745
...
	      Endpoint Descriptor:
	        bLength                 7
	        bDescriptorType         5
	        bEndpointAddress     0x83  EP 3 IN
	        bmAttributes            3
	          Transfer Type            Interrupt
	          Synch Type               None
	          Usage Type               Data
	        wMaxPacketSize     0x0004  1x 4 bytes
	        bInterval               1
...

connected via this BUS device:

	Bus 003 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
	Device Descriptor:
	  bLength                18
	  bDescriptorType         1
	  bcdUSB               2.00
	  bDeviceClass            9 Hub
	  bDeviceSubClass         0 Unused
	  bDeviceProtocol         1 Single TT
	  bMaxPacketSize0        64
	  idVendor           0x1d6b Linux Foundation
	  idProduct          0x0002 2.0 root hub
	  bcdDevice            3.11
	  iManufacturer           3 Linux 3.11.2-201.fc19.x86_64 xhci_hcd
	  iProduct                2 xHCI Host Controller
	  iSerial                 1 0000:00:14.0

In such situation, and assuming that the USB tables are correct, there's
nothing that needs to be done there, as bInterval/wMaxPacketSize are
correct for USB 2.0.

So, there's no need to call usb_change_ep_bandwidth().

If so, then usb_change_ep_bandwidth() as a quirk, if bInterval
or wMaxPacketSize were improperly filled.

Right?
-- 

Cheers,
Mauro
