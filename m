Return-path: <linux-media-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:32800 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754171AbZDHXvr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 8 Apr 2009 19:51:47 -0400
Date: Wed, 8 Apr 2009 16:40:25 -0700
From: Greg KH <gregkh@suse.de>
To: Alexey Klimov <klimov.linux@gmail.com>
Cc: David Vrabel <david.vrabel@csr.com>, linux-usb@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] usb: add reset endpoint operations
Message-ID: <20090408234025.GA28532@suse.de>
References: <1239212193-27618-1-git-send-email-david.vrabel@csr.com> <1239212193-27618-2-git-send-email-david.vrabel@csr.com> <208cbae30904081636x71e7675egad7566bc601cb2cf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <208cbae30904081636x71e7675egad7566bc601cb2cf@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Apr 09, 2009 at 03:36:51AM +0400, Alexey Klimov wrote:
> (added linux-media maillist)
> 
> Hello, David
> 
> On Wed, Apr 8, 2009 at 9:36 PM, David Vrabel <david.vrabel@csr.com> wrote:
> > Wireless USB endpoint state has a sequence number and a current
> > window and not just a single toggle bit.  So allow HCDs to provide a
> > endpoint_reset method and call this or clear the software toggles as
> > required (after a clear halt, set configuration etc.).
> >
> > usb_settoggle() and friends are then HCD internal and are moved into
> > core/hcd.h and all device drivers call usb_reset_endpoint() instead.
> >
> > If the device endpoint state has been reset (with a clear halt) but
> > the host endpoint state has not then subsequent data transfers will
> > not complete. The device will only work again after it is reset or
> > disconnected.
> >
> > Signed-off-by: David Vrabel <david.vrabel@csr.com>
> > ---
> >  drivers/block/ub.c                        |   20 ++++-----
> >  drivers/isdn/hisax/st5481_usb.c           |    9 +----
> >  drivers/media/video/pvrusb2/pvrusb2-hdw.c |    1 -
> 
> Looks like you change file under /drivers/video. It's better at least
> to add linux-media maillist  or driver maintainer (not only linux-usb
> list) to let developers know that you change drivers.

He's already gotten an Ack from this driver author on the last time this
patch was sent out.  Don't know why he forgot to add it to this version
of the patch, it should still be valid :)

thanks,

greg k-h
