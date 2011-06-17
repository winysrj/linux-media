Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:45359 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757813Ab1FQIS0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jun 2011 04:18:26 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: uvcvideo failure under xHCI
Date: Fri, 17 Jun 2011 10:18:39 +0200
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
	linux-media@vger.kernel.org, USB list <linux-usb@vger.kernel.org>,
	Andiry Xu <andiry.xu@amd.com>, Alex He <alex.he@amd.com>
References: <Pine.LNX.4.44L0.1106161619140.1697-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1106161619140.1697-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106171018.40285.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thursday 16 June 2011 22:20:22 Alan Stern wrote:
> On Thu, 16 Jun 2011, Sarah Sharp wrote:
> > On Thu, Jun 16, 2011 at 03:39:11PM -0400, Alan Stern wrote:
> > > That's appropriate.  But nobody should ever set an isochronous URB's
> > > status field to -EPROTO, no matter whether the device is connected or
> > > not and no matter whether the host controller is alive or not.
> > 
> > But the individual frame status be set to -EPROTO, correct?  That's what
> > Alex was told to do when an isochronous TD had a completion code of
> > "Incompatible Device Error".
> 
> Right.  -EPROTO is a perfectly reasonable code for a frame's status.
> But not for an isochronous URB's status.  There's no reason for
> uvcvideo to test for it.

The uvcvideo driver tests for -EPROTO for interrupt URBs only. For isochronous 
URBs it tests for -ENOENT, -ECONNRESET and -ESHUTDOWN.

-- 
Regards,

Laurent Pinchart
