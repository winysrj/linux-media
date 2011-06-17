Return-path: <mchehab@pedra>
Received: from mga01.intel.com ([192.55.52.88]:65369 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755105Ab1FQQqc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jun 2011 12:46:32 -0400
Date: Fri, 17 Jun 2011 09:46:20 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
	linux-media@vger.kernel.org, USB list <linux-usb@vger.kernel.org>,
	Andiry Xu <andiry.xu@amd.com>, Alex He <alex.he@amd.com>
Subject: Re: uvcvideo failure under xHCI
Message-ID: <20110617164620.GD5416@xanatos>
References: <Pine.LNX.4.44L0.1106161619140.1697-100000@iolanthe.rowland.org>
 <201106171018.40285.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201106171018.40285.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Fri, Jun 17, 2011 at 10:18:39AM +0200, Laurent Pinchart wrote:
> On Thursday 16 June 2011 22:20:22 Alan Stern wrote:
> > On Thu, 16 Jun 2011, Sarah Sharp wrote:
> > > On Thu, Jun 16, 2011 at 03:39:11PM -0400, Alan Stern wrote:
> > > > That's appropriate.  But nobody should ever set an isochronous URB's
> > > > status field to -EPROTO, no matter whether the device is connected or
> > > > not and no matter whether the host controller is alive or not.
> > > 
> > > But the individual frame status be set to -EPROTO, correct?  That's what
> > > Alex was told to do when an isochronous TD had a completion code of
> > > "Incompatible Device Error".
> > 
> > Right.  -EPROTO is a perfectly reasonable code for a frame's status.
> > But not for an isochronous URB's status.  There's no reason for
> > uvcvideo to test for it.
> 
> The uvcvideo driver tests for -EPROTO for interrupt URBs only. For isochronous 
> URBs it tests for -ENOENT, -ECONNRESET and -ESHUTDOWN.

So is uvc_status_complete() shared between interrupt and isochronous
URBs then?

Sarah Sharp
