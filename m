Return-path: <mchehab@pedra>
Received: from iolanthe.rowland.org ([192.131.102.54]:46404 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757062Ab1FPTjM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jun 2011 15:39:12 -0400
Date: Thu, 16 Jun 2011 15:39:11 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	<linux-media@vger.kernel.org>,
	USB list <linux-usb@vger.kernel.org>,
	Andiry Xu <andiry.xu@amd.com>
Subject: Re: uvcvideo failure under xHCI
In-Reply-To: <20110616190634.GA7290@xanatos>
Message-ID: <Pine.LNX.4.44L0.1106161536110.1697-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, 16 Jun 2011, Sarah Sharp wrote:

> > > Sure.  It feels like there should be a note about which values
> > > isochronous URBs might have in the urb->status field.  The USB core is
> > > the only one that would be setting those, so which values would it set?
> > > uvcvideo tests for these error codes:
> > > 
> > >         case -ENOENT:           /* usb_kill_urb() called. */
> > >         case -ECONNRESET:       /* usb_unlink_urb() called. */
> > >         case -ESHUTDOWN:        /* The endpoint is being disabled. */
> > >         case -EPROTO:           /* Device is disconnected (reported by some
> > >                                  * host controller). */
> > > 
> > > Are there any others.
> > 
> > -EREMOTEIO, in the unlikely event that URB_SHORT_NOT_OK is set, but no
> > others.
> 
> Are you saying that the USB core will only set -EREMOTEIO for
> isochronous URBs?  Or do you mean that in addition to the status values
> that uvcvideo checks, the USB core can also set -EREMOTEIO?

The latter.  However, if uvcvideo never sets the URB_SHORT_NOT_OK flag 
then usbcore will never set urb->status to -EREMOTEIO.

> > And I wasn't aware of that last one...  Host controller drivers should
> > report -ESHUTDOWN to mean the device has been disconnected, not
> > -EPROTO.  But usually HCD don't take these events into account when
> > determining URB status codes.
> 
> The xHCI driver will return -ESHUTDOWN as a status for URBs when the
> host controller is dying.

That's appropriate.  But nobody should ever set an isochronous URB's
status field to -EPROTO, no matter whether the device is connected or
not and no matter whether the host controller is alive or not.

Alan Stern

