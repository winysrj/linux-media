Return-path: <mchehab@pedra>
Received: from mga14.intel.com ([143.182.124.37]:17467 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755901Ab1FPRRW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jun 2011 13:17:22 -0400
Date: Thu, 16 Jun 2011 10:17:11 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, USB list <linux-usb@vger.kernel.org>,
	Andiry Xu <andiry.xu@amd.com>
Subject: Re: uvcvideo failure under xHCI
Message-ID: <20110616171711.GB6188@xanatos>
References: <201106161007.50594.laurent.pinchart@ideasonboard.com>
 <Pine.LNX.4.44L0.1106161029490.2204-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1106161029490.2204-100000@iolanthe.rowland.org>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, Jun 16, 2011 at 10:35:49AM -0400, Alan Stern wrote:
> On Thu, 16 Jun 2011, Laurent Pinchart wrote:
> > On Thursday 16 June 2011 04:59:57 Sarah Sharp wrote:
> > > On Wed, Jun 15, 2011 at 06:39:57PM -0700, Sarah Sharp wrote:
> > > > I've grepped through drivers/media/video, and it seems like none of the
> > > > drivers handle the -EXDEV status.  What should the xHCI driver be
> > > > setting the URB's status and frame status to when the xHCI host
> > > > controller skips over transfers?  -EREMOTEIO?
> > > > 
> > > > Or does it need to set the URB's status to zero, but only set the
> > > > individual frame status to -EXDEV?
> > > 
> > > Ok, looking at both EHCI and UHCI, they seem to set the urb->status to
> > > zero, regardless of what they set the frame descriptor field to.
> > > 
> > > Alan, does that seem correct?
> 
> The description of the behavior of ehci-hcd and uhci-hcd is correct.  
> ohci-hcd behaves the same way too.  And they all agree with the 
> behavior described in the kerneldoc for struct urb in 
> include/linux/usb.h.

Ah, you mean this bit?

 * @status: This is read in non-iso completion functions to get the
 *      status of the particular request.  ISO requests only use it
 *      to tell whether the URB was unlinked; detailed status for
 *      each frame is in the fields of the iso_frame-desc.


> > According to Documentation/usb/error-codes.txt, host controller drivers should 
> > set the status to -EXDEV. However, no device drivers seem to handle that, 
> > probably because the EHCI/UHCI drivers don't use that error code.
> > 
> > Drivers are clearly out of sync with the documentation, so we should fix one 
> > of them.
> 
> Under the circumstances, the documentation file should be changed.  
> Sarah, can you do that along with the change to xhci-hcd?

Sure.  It feels like there should be a note about which values
isochronous URBs might have in the urb->status field.  The USB core is
the only one that would be setting those, so which values would it set?
uvcvideo tests for these error codes:

        case -ENOENT:           /* usb_kill_urb() called. */
        case -ECONNRESET:       /* usb_unlink_urb() called. */
        case -ESHUTDOWN:        /* The endpoint is being disabled. */
        case -EPROTO:           /* Device is disconnected (reported by some
                                 * host controller). */

Are there any others.

Sarah Sharp
