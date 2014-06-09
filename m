Return-path: <linux-media-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:50976 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750868AbaFIHdK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Jun 2014 03:33:10 -0400
Message-ID: <1402299186.4148.3.camel@jlt4.sipsolutions.net>
Subject: Re: non-working UVC device 058f:5608
From: Johannes Berg <johannes@sipsolutions.net>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-usb@vger.kernel.org
Date: Mon, 09 Jun 2014 09:33:06 +0200
In-Reply-To: <1404177.cR0nfxENUh@avalon>
References: <1402177903.8442.9.camel@jlt4.sipsolutions.net>
	 <1404177.cR0nfxENUh@avalon>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for the quick reply!

> > and then the kernel message repeats forever, while I can't even exit
> > uvccapture unless I kill it hard, at which point I get
> > 
> > xhci_hcd 0000:00:14.0: Signal while waiting for configure endpoint command
> > usb 1-3.4.4.3: Not enough bandwidth for altsetting 0
> > 
> > from the kernel.
> 
> This looks like low-level USB issues, CC'ing the linux-usb mailing list.

Ok.

> > Any thoughts? Just to rule out hardware defects I connected it to my
> > windows 7 work machine and it works fine without even installing a
> > driver.
> 
> Could you try connecting it to an EHCI controller instead of XHCI on a Linux  
> machine ?

Indeed, that works! Interestingly, it works neither on a USB3 port
directly, nor on a USB2 hub behind the USB3 port.

Thanks,
johannes

