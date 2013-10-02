Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w2.samsung.com ([211.189.100.13]:21576 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754740Ab3JBRLa (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Oct 2013 13:11:30 -0400
Date: Wed, 02 Oct 2013 14:11:23 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
	Xenia Ragiadakou <burzalodowa@gmail.com>,
	linux-usb@vger.kernel.org, linux-input@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: Re: New USB core API to change interval and max packet size
Message-id: <20131002141123.1c8d2e3b@samsung.com>
In-reply-to: <Pine.LNX.4.44L0.1310021234510.1293-100000@iolanthe.rowland.org>
References: <20131002131550.38f90611@samsung.com>
 <Pine.LNX.4.44L0.1310021234510.1293-100000@iolanthe.rowland.org>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 02 Oct 2013 12:38:14 -0400 (EDT)
Alan Stern <stern@rowland.harvard.edu> escreveu:

> On Wed, 2 Oct 2013, Mauro Carvalho Chehab wrote:
> 
> > > > So, there's no need to call usb_change_ep_bandwidth().
> > > 
> > > That's right.
> > > 
> > > > If so, then usb_change_ep_bandwidth() as a quirk, if bInterval
> > > > or wMaxPacketSize were improperly filled.
> > > > 
> > > > Right?
> > > 
> > > Or if the values are correct, but the driver wants to use something 
> > > different for its own reasons (for example, to get lower latency or 
> > > because it knows that it will never use packets as large as the 
> > > descriptor allows).  Right.
> > 
> > Ok, so, in this case, usb_change_ep_bandwidth() could be called
> > just before usb_alloc_urb(), in order to make it to use the packet
> > size that would be expected for that kind of ISOC traffic that
> > userspace indirectly selected, by adjusting the streaming
> > video resolution selected, right?
> 
> We haven't decided on the final API yet.  However, note that
> usb_alloc_urb() doesn't depend on the packet size.  It requires you to
> specify only the number of packets, not their sizes.  Therefore it
> doesn't matter whether you call usb_change_ep_bandwidth() before or
> after usb_alloc_urb().

Sure, but, at least on almost all V4L2 drivers, the number of packets
and their sizes should be calculated to be able to receive all URBs
needed to store a complete image frame (that generally arrives on 
every 1/60 Hz or 1/50 Hz - depending on the frames per second rate).

On those drivers, the transfer_buffer is allocated at the same loop 
where usb_alloc_urb() is called.

So, it makes sense for them to specify the bandwidth parameters at
the function that calls usb_alloc_coherent() and usb_alloc_urb().

Regards,
Mauro
