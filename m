Return-path: <mchehab@pedra>
Received: from iolanthe.rowland.org ([192.131.102.54]:39096 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932103Ab1FPOfu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jun 2011 10:35:50 -0400
Date: Thu, 16 Jun 2011 10:35:49 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: linux-media@vger.kernel.org, USB list <linux-usb@vger.kernel.org>,
	Andiry Xu <andiry.xu@amd.com>
Subject: Re: uvcvideo failure under xHCI
In-Reply-To: <201106161007.50594.laurent.pinchart@ideasonboard.com>
Message-ID: <Pine.LNX.4.44L0.1106161029490.2204-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, 16 Jun 2011, Laurent Pinchart wrote:

> Hi Sarah,
> 
> On Thursday 16 June 2011 04:59:57 Sarah Sharp wrote:
> > On Wed, Jun 15, 2011 at 06:39:57PM -0700, Sarah Sharp wrote:
> > > When I plug in a webcam under an xHCI host controller in 3.0-rc3+
> > > (basically top of Greg's usb-linus branch) with xHCI debugging turned
> > > on, the host controller occasionally cannot keep up with the isochronous
> > > transfers, and it tells the xHCI driver that it had to "skip" several
> > > microframes of transfers.  These "Missed Service Intervals" aren't
> > > supposed to be fatal errors, just an indication that something was
> > > hogging the PCI memory bandwidth.
> > > 
> > > The xHCI driver then sets the URB's status to -EXDEV, to indicate that
> > > some of the iso_frame_desc transferred, and sets at least one frame's
> > 
> > > status to -EXDEV:
> > ...
> > 
> > > The urb->status causes uvcvideo code in
> > > uvc_status.c:uvc_status_complete() to fail with the message:
> > > 
> > > Jun 15 17:37:11 talon kernel: [  117.987769] uvcvideo: Non-zero status
> > > (-18) in video completion handler.
> > 
> > ...
> > 
> > > I've grepped through drivers/media/video, and it seems like none of the
> > > drivers handle the -EXDEV status.  What should the xHCI driver be
> > > setting the URB's status and frame status to when the xHCI host
> > > controller skips over transfers?  -EREMOTEIO?
> > > 
> > > Or does it need to set the URB's status to zero, but only set the
> > > individual frame status to -EXDEV?
> > 
> > Ok, looking at both EHCI and UHCI, they seem to set the urb->status to
> > zero, regardless of what they set the frame descriptor field to.
> > 
> > Alan, does that seem correct?

The description of the behavior of ehci-hcd and uhci-hcd is correct.  
ohci-hcd behaves the same way too.  And they all agree with the 
behavior described in the kerneldoc for struct urb in 
include/linux/usb.h.

> According to Documentation/usb/error-codes.txt, host controller drivers should 
> set the status to -EXDEV. However, no device drivers seem to handle that, 
> probably because the EHCI/UHCI drivers don't use that error code.
> 
> Drivers are clearly out of sync with the documentation, so we should fix one 
> of them.

Under the circumstances, the documentation file should be changed.  
Sarah, can you do that along with the change to xhci-hcd?

Alan Stern

