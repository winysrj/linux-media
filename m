Return-path: <mchehab@pedra>
Received: from iolanthe.rowland.org ([192.131.102.54]:43150 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932790Ab1FPUUX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jun 2011 16:20:23 -0400
Date: Thu, 16 Jun 2011 16:20:22 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	<linux-media@vger.kernel.org>,
	USB list <linux-usb@vger.kernel.org>,
	Andiry Xu <andiry.xu@amd.com>, Alex He <alex.he@amd.com>
Subject: Re: uvcvideo failure under xHCI
In-Reply-To: <20110616195843.GB7290@xanatos>
Message-ID: <Pine.LNX.4.44L0.1106161619140.1697-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, 16 Jun 2011, Sarah Sharp wrote:

> On Thu, Jun 16, 2011 at 03:39:11PM -0400, Alan Stern wrote:
> > That's appropriate.  But nobody should ever set an isochronous URB's
> > status field to -EPROTO, no matter whether the device is connected or
> > not and no matter whether the host controller is alive or not.
> 
> But the individual frame status be set to -EPROTO, correct?  That's what
> Alex was told to do when an isochronous TD had a completion code of
> "Incompatible Device Error".

Right.  -EPROTO is a perfectly reasonable code for a frame's status.  
But not for an isochronous URB's status.  There's no reason for 
uvcvideo to test for it.

Alan Stern

