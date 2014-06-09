Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:60455 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754774AbaFIJYc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Jun 2014 05:24:32 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-media@vger.kernel.org, linux-usb@vger.kernel.org,
	Mathias Nyman <mathias.nyman@intel.com>
Subject: Re: non-working UVC device 058f:5608
Date: Mon, 09 Jun 2014 11:25:01 +0200
Message-ID: <17531102.o7hyOUhSH7@avalon>
In-Reply-To: <1402299186.4148.3.camel@jlt4.sipsolutions.net>
References: <1402177903.8442.9.camel@jlt4.sipsolutions.net> <1404177.cR0nfxENUh@avalon> <1402299186.4148.3.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Johannes,

On Monday 09 June 2014 09:33:06 Johannes Berg wrote:
> Hi Laurent,
> 
> Thanks for the quick reply!

You're welcome.

> > > and then the kernel message repeats forever, while I can't even exit
> > > uvccapture unless I kill it hard, at which point I get
> > > 
> > > xhci_hcd 0000:00:14.0: Signal while waiting for configure endpoint
> > > command
> > > usb 1-3.4.4.3: Not enough bandwidth for altsetting 0
> > > 
> > > from the kernel.
> > 
> > This looks like low-level USB issues, CC'ing the linux-usb mailing list.
> 
> Ok.
> 
> > > Any thoughts? Just to rule out hardware defects I connected it to my
> > > windows 7 work machine and it works fine without even installing a
> > > driver.
> > 
> > Could you try connecting it to an EHCI controller instead of XHCI on a
> > Linux machine ?
> 
> Indeed, that works! Interestingly, it works neither on a USB3 port
> directly, nor on a USB2 hub behind the USB3 port.

I would thus be tempted to classify this as an XHCI controller issue. linux-
usb should be the right list to get help. I've CC'ed Mathias Nyman, the XHCI 
maintainer.

Johannes, could you enable USB debugging in the linus/master kernel and 
provide a kernel log ?

-- 
Regards,

Laurent Pinchart

