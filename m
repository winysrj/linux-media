Return-path: <mchehab@pedra>
Received: from iolanthe.rowland.org ([192.131.102.54]:52955 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758436Ab1FPRjo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jun 2011 13:39:44 -0400
Date: Thu, 16 Jun 2011 13:39:43 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	<linux-media@vger.kernel.org>,
	USB list <linux-usb@vger.kernel.org>,
	Andiry Xu <andiry.xu@amd.com>
Subject: Re: uvcvideo failure under xHCI
In-Reply-To: <20110616171711.GB6188@xanatos>
Message-ID: <Pine.LNX.4.44L0.1106161329250.3807-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, 16 Jun 2011, Sarah Sharp wrote:

> > > > Alan, does that seem correct?
> > 
> > The description of the behavior of ehci-hcd and uhci-hcd is correct.  
> > ohci-hcd behaves the same way too.  And they all agree with the 
> > behavior described in the kerneldoc for struct urb in 
> > include/linux/usb.h.
> 
> Ah, you mean this bit?
> 
>  * @status: This is read in non-iso completion functions to get the
>  *      status of the particular request.  ISO requests only use it
>  *      to tell whether the URB was unlinked; detailed status for
>  *      each frame is in the fields of the iso_frame-desc.

Right.  There's also some more near the end:

 * Completion Callbacks:
 *
 * The completion callback is made in_interrupt(), and one of the first
 * things that a completion handler should do is check the status field.
 * The status field is provided for all URBs.  It is used to report
 * unlinked URBs, and status for all non-ISO transfers.  It should not
 * be examined before the URB is returned to the completion handler.

> > Under the circumstances, the documentation file should be changed.  
> > Sarah, can you do that along with the change to xhci-hcd?
> 
> Sure.  It feels like there should be a note about which values
> isochronous URBs might have in the urb->status field.  The USB core is
> the only one that would be setting those, so which values would it set?
> uvcvideo tests for these error codes:
> 
>         case -ENOENT:           /* usb_kill_urb() called. */
>         case -ECONNRESET:       /* usb_unlink_urb() called. */
>         case -ESHUTDOWN:        /* The endpoint is being disabled. */
>         case -EPROTO:           /* Device is disconnected (reported by some
>                                  * host controller). */
> 
> Are there any others.

-EREMOTEIO, in the unlikely event that URB_SHORT_NOT_OK is set, but no
others.

And I wasn't aware of that last one...  Host controller drivers should
report -ESHUTDOWN to mean the device has been disconnected, not
-EPROTO.  But usually HCD don't take these events into account when
determining URB status codes.

Alan Stern

