Return-path: <mchehab@pedra>
Received: from iolanthe.rowland.org ([192.131.102.54]:53242 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759533Ab1FWROF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Jun 2011 13:14:05 -0400
Date: Thu, 23 Jun 2011 13:14:04 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
To: Kirill Smelkov <kirr@mns.spb.ru>
cc: linux-usb@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
	<linux-uvc-devel@lists.berlios.de>, <linux-media@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [RFC, PATCH] USB: EHCI: Allow users to override 80% max periodic
 bandwidth
In-Reply-To: <20110623140539.GA4403@tugrik.mns.mnsspb.ru>
Message-ID: <Pine.LNX.4.44L0.1106231312270.2033-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, 23 Jun 2011, Kirill Smelkov wrote:

> > At 480 Mb/s, each microframe holds 7500 bytes (less if you count 
> > bit-stuffing).  4% of that is 300 bytes, which is not enough for a 
> > 512-byte bulk packet.  I think you'd run into trouble trying to do any 
> > serious bulk transfers on such a tight schedule.
> 
> Yes, you seem to be right.
> 
> I still think 4% is maybe enough for control traffic.

It should be.

> > > @@ -571,6 +579,14 @@ static int ehci_init(struct usb_hcd *hcd)
> > >  	hcc_params = ehci_readl(ehci, &ehci->caps->hcc_params);
> > >  
> > >  	/*
> > > +	 * tell user, if using non-standard (80% == 100 usec/uframe) bandwidth
> > > +	 */
> > > +	if (uframe_periodic_max != 100)
> > > +		ehci_info(ehci, "using non-standard max periodic bandwith "
> > > +				"(%u%% == %u usec/uframe)",
> > > +				100*uframe_periodic_max/125, uframe_periodic_max);
> > > +
> > > +	/*
> > 
> > Check for invalid values.  This should never be less than 100 or 
> > greater than 125.
> 
> Ok. By the way, why should we limit it to be not less than 100?
> Likewise, a user who knows exactly what he/she is doing could limit
> periodic bandwidth to be less than 80% required by USB specification.

What's the point?  If you want to use less than 80% of your bandwidth 
for periodic transfers, go ahead and do so.  You don't need to change 
the limit.

Alan Stern

