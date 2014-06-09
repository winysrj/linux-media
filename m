Return-path: <linux-media-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:51349 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752475AbaFIJ7Y (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Jun 2014 05:59:24 -0400
Message-ID: <1402307959.17674.3.camel@jlt4.sipsolutions.net>
Subject: Re: non-working UVC device 058f:5608
From: Johannes Berg <johannes@sipsolutions.net>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-usb@vger.kernel.org,
	Mathias Nyman <mathias.nyman@intel.com>
Date: Mon, 09 Jun 2014 11:59:19 +0200
In-Reply-To: <17531102.o7hyOUhSH7@avalon>
References: <1402177903.8442.9.camel@jlt4.sipsolutions.net>
	 <1404177.cR0nfxENUh@avalon> <1402299186.4148.3.camel@jlt4.sipsolutions.net>
	 <17531102.o7hyOUhSH7@avalon>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2014-06-09 at 11:25 +0200, Laurent Pinchart wrote:

> > Indeed, that works! Interestingly, it works neither on a USB3 port
> > directly, nor on a USB2 hub behind the USB3 port.
> 
> I would thus be tempted to classify this as an XHCI controller issue. linux-
> usb should be the right list to get help. I've CC'ed Mathias Nyman, the XHCI 
> maintainer.

Yeah, I tend to agree.

> Johannes, could you enable USB debugging in the linus/master kernel and 
> provide a kernel log ?

Sure. Note that linus/next is having even more issues with this device,
to the point where I couldn't even get the lsusb I pasted into the first
email. I used 3.13 (because I had it installed on the system in
question) to get that.

It was also throwing an autosuspend warning:
http://mid.gmane.org/1402177014.8442.1.camel@jlt4.sipsolutions.net

I'll try to get some logs (wasn't there tracing added to xhci too? will
check)

johannes

