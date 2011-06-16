Return-path: <mchehab@pedra>
Received: from mga09.intel.com ([134.134.136.24]:39487 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751709Ab1FPDAA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Jun 2011 23:00:00 -0400
Date: Wed, 15 Jun 2011 19:59:57 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-usb@vger.kernel.org,
	Andiry Xu <andiry.xu@amd.com>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: Re: uvcvideo failure under xHCI
Message-ID: <20110616025957.GA10184@xanatos>
References: <20110616013957.GA9809@xanatos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110616013957.GA9809@xanatos>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, Jun 15, 2011 at 06:39:57PM -0700, Sarah Sharp wrote:
> When I plug in a webcam under an xHCI host controller in 3.0-rc3+
> (basically top of Greg's usb-linus branch) with xHCI debugging turned
> on, the host controller occasionally cannot keep up with the isochronous
> transfers, and it tells the xHCI driver that it had to "skip" several
> microframes of transfers.  These "Missed Service Intervals" aren't
> supposed to be fatal errors, just an indication that something was
> hogging the PCI memory bandwidth.
> 
> The xHCI driver then sets the URB's status to -EXDEV, to indicate that
> some of the iso_frame_desc transferred, and sets at least one frame's
> status to -EXDEV:
...
> The urb->status causes uvcvideo code in uvc_status.c:uvc_status_complete() to
> fail with the message:
> 
> Jun 15 17:37:11 talon kernel: [  117.987769] uvcvideo: Non-zero status (-18) in video completion handler.
...
> I've grepped through drivers/media/video, and it seems like none of the
> drivers handle the -EXDEV status.  What should the xHCI driver be
> setting the URB's status and frame status to when the xHCI host
> controller skips over transfers?  -EREMOTEIO?
> 
> Or does it need to set the URB's status to zero, but only set the
> individual frame status to -EXDEV?

Ok, looking at both EHCI and UHCI, they seem to set the urb->status to
zero, regardless of what they set the frame descriptor field to.

Alan, does that seem correct?

I've created a patch to do the same thing in the xHCI driver, and I seem
to be getting consistent video with xHCI debugging turned on, despite
lots of Missed Service Interval events.

Sarah Sharp
