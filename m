Return-path: <linux-media-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:53626 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754433Ab3JBQiP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Oct 2013 12:38:15 -0400
Date: Wed, 2 Oct 2013 12:38:14 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
	Xenia Ragiadakou <burzalodowa@gmail.com>,
	<linux-usb@vger.kernel.org>, <linux-input@vger.kernel.org>,
	<linux-media@vger.kernel.org>
Subject: Re: New USB core API to change interval and max packet size
In-Reply-To: <20131002131550.38f90611@samsung.com>
Message-ID: <Pine.LNX.4.44L0.1310021234510.1293-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2 Oct 2013, Mauro Carvalho Chehab wrote:

> > > So, there's no need to call usb_change_ep_bandwidth().
> > 
> > That's right.
> > 
> > > If so, then usb_change_ep_bandwidth() as a quirk, if bInterval
> > > or wMaxPacketSize were improperly filled.
> > > 
> > > Right?
> > 
> > Or if the values are correct, but the driver wants to use something 
> > different for its own reasons (for example, to get lower latency or 
> > because it knows that it will never use packets as large as the 
> > descriptor allows).  Right.
> 
> Ok, so, in this case, usb_change_ep_bandwidth() could be called
> just before usb_alloc_urb(), in order to make it to use the packet
> size that would be expected for that kind of ISOC traffic that
> userspace indirectly selected, by adjusting the streaming
> video resolution selected, right?

We haven't decided on the final API yet.  However, note that
usb_alloc_urb() doesn't depend on the packet size.  It requires you to
specify only the number of packets, not their sizes.  Therefore it
doesn't matter whether you call usb_change_ep_bandwidth() before or
after usb_alloc_urb().

Alan Stern

