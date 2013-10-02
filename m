Return-path: <linux-media-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:53368 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753733Ab3JBPAO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Oct 2013 11:00:14 -0400
Date: Wed, 2 Oct 2013 11:00:13 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
	Xenia Ragiadakou <burzalodowa@gmail.com>,
	<linux-usb@vger.kernel.org>, <linux-input@vger.kernel.org>,
	<linux-media@vger.kernel.org>
Subject: Re: New USB core API to change interval and max packet size
In-Reply-To: <20131002093354.507cd24d@samsung.com>
Message-ID: <Pine.LNX.4.44L0.1310021057250.1293-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2 Oct 2013, Mauro Carvalho Chehab wrote:

> Let me see if I understand the changes at the media drivers. So, please
> correct me if I got it wrong.
> 
> I'm yet to get any USB 3.0 media device, although it is common to connect
> an USB 1.1 or USB 2.0 device on a USB 3.0 host port.
> 
> So, for example, on this device:

> ...
> 	      Endpoint Descriptor:
> 	        bLength                 7
> 	        bDescriptorType         5
> 	        bEndpointAddress     0x83  EP 3 IN
> 	        bmAttributes            3
> 	          Transfer Type            Interrupt
> 	          Synch Type               None
> 	          Usage Type               Data
> 	        wMaxPacketSize     0x0004  1x 4 bytes
> 	        bInterval               1
> ...
> 
> connected via this BUS device:

...

> In such situation, and assuming that the USB tables are correct, there's
> nothing that needs to be done there, as bInterval/wMaxPacketSize are
> correct for USB 2.0.
> 
> So, there's no need to call usb_change_ep_bandwidth().

That's right.

> If so, then usb_change_ep_bandwidth() as a quirk, if bInterval
> or wMaxPacketSize were improperly filled.
> 
> Right?

Or if the values are correct, but the driver wants to use something 
different for its own reasons (for example, to get lower latency or 
because it knows that it will never use packets as large as the 
descriptor allows).  Right.

Alan Stern

