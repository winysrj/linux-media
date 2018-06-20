Return-path: <linux-media-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:32955 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932177AbeFTQtt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Jun 2018 12:49:49 -0400
Date: Wed, 20 Jun 2018 18:49:45 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-usb@vger.kernel.org, tglx@linutronix.de,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] USB: note that usb_fill_int_urb() can be used used for
 ISOC urbs.
Message-ID: <20180620164945.xb24m7wlbtb6cys5@linutronix.de>
References: <20180620160200.vxdq4o2azkftpfqs@linutronix.de>
 <Pine.LNX.4.44L0.1806201217150.1758-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <Pine.LNX.4.44L0.1806201217150.1758-100000@iolanthe.rowland.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2018-06-20 12:21:33 [-0400], Alan Stern wrote:
> > > There are two problems with using usb_fill_int_urb() to initialize an 
> > > isochronous URB:
> > > 
> > > 	The calculation of the interval value is wrong for full-speed
> > > 	devices.
> > 
> > Why wrong?
> 
> Because the interval value in the FS endpoint descriptor uses a
> logarithmic encoding, whereas the value stored in the URB uses a linear
> encoding.  Simply copying one value to the other will store an
> incorrect number, except in the lucky cases where the interval is
> either 1 or 2.

Hmmm. Now that I looked into USB 2.0 specification it really says
logarithmic encoding for ISOC endpoints on every speed and not just HS.
And INTR endpoints have logarithmic encoding only for HS. I remembered
it differently…

But based on this, we should really introduce usb_fill_iso_urb() which
handles this correctly. Also the documentation should be updated because
the suggestion for ubs_fill_intr_urb() is misleading (especially if you
have wrong memory about the encoding on FS).

> Alan Stern

Sebastian
