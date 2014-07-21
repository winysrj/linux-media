Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:35948 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932905AbaGUQes (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Jul 2014 12:34:48 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mathias Nyman <mathias.nyman@intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-media@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: non-working UVC device 058f:5608
Date: Mon, 21 Jul 2014 18:34:58 +0200
Message-ID: <4901169.xvpWIyQ2Tj@avalon>
In-Reply-To: <1402309657.17674.5.camel@jlt4.sipsolutions.net>
References: <1402177903.8442.9.camel@jlt4.sipsolutions.net> <1402307959.17674.3.camel@jlt4.sipsolutions.net> <1402309657.17674.5.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 09 June 2014 12:27:37 Johannes Berg wrote:
> On Mon, 2014-06-09 at 11:59 +0200, Johannes Berg wrote:
> > > Johannes, could you enable USB debugging in the linus/master kernel and
> > > provide a kernel log ?
> > 
> > I'll try to get some logs (wasn't there tracing added to xhci too? will
> > check)
> 
> Here we go - log + tracing:
> log: http://p.sipsolutions.net/d5926c43d531e3af.txt
> trace: http://johannes.sipsolutions.net/files/xhci.trace.dat.xz
> 
> I plugged in the device, waited a bit, tried to run a camera application
> (didn't work) and then ran lsusb -t and lsusb -v.

Mathias, would you have time to give this a quick look ?

-- 
Regards,

Laurent Pinchart

