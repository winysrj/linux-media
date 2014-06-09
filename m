Return-path: <linux-media-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:51433 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754043AbaFIK1l (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Jun 2014 06:27:41 -0400
Message-ID: <1402309657.17674.5.camel@jlt4.sipsolutions.net>
Subject: Re: non-working UVC device 058f:5608
From: Johannes Berg <johannes@sipsolutions.net>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-usb@vger.kernel.org,
	Mathias Nyman <mathias.nyman@intel.com>
Date: Mon, 09 Jun 2014 12:27:37 +0200
In-Reply-To: <1402307959.17674.3.camel@jlt4.sipsolutions.net>
References: <1402177903.8442.9.camel@jlt4.sipsolutions.net>
	 <1404177.cR0nfxENUh@avalon> <1402299186.4148.3.camel@jlt4.sipsolutions.net>
	 <17531102.o7hyOUhSH7@avalon>
	 <1402307959.17674.3.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2014-06-09 at 11:59 +0200, Johannes Berg wrote:

> > Johannes, could you enable USB debugging in the linus/master kernel and 
> > provide a kernel log ?

> I'll try to get some logs (wasn't there tracing added to xhci too? will
> check)

Here we go - log + tracing:
log: http://p.sipsolutions.net/d5926c43d531e3af.txt
trace: http://johannes.sipsolutions.net/files/xhci.trace.dat.xz

I plugged in the device, waited a bit, tried to run a camera application
(didn't work) and then ran lsusb -t and lsusb -v.

johannes

