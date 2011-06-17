Return-path: <mchehab@pedra>
Received: from mga09.intel.com ([134.134.136.24]:53163 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932107Ab1FQSTF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jun 2011 14:19:05 -0400
Date: Fri, 17 Jun 2011 11:19:01 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
	linux-media@vger.kernel.org, USB list <linux-usb@vger.kernel.org>,
	Andiry Xu <andiry.xu@amd.com>, Alex He <alex.he@amd.com>
Subject: Re: uvcvideo failure under xHCI
Message-ID: <20110617181901.GF5416@xanatos>
References: <Pine.LNX.4.44L0.1106161619140.1697-100000@iolanthe.rowland.org>
 <201106171018.40285.laurent.pinchart@ideasonboard.com>
 <20110617164620.GD5416@xanatos>
 <201106171901.11139.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201106171901.11139.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Fri, Jun 17, 2011 at 07:01:10PM +0200, Laurent Pinchart wrote:
> Hi Sarah,
> 
> On Friday 17 June 2011 18:46:20 Sarah Sharp wrote:
> > On Fri, Jun 17, 2011 at 10:18:39AM +0200, Laurent Pinchart wrote:
> > > On Thursday 16 June 2011 22:20:22 Alan Stern wrote:
> > > > On Thu, 16 Jun 2011, Sarah Sharp wrote:
> > > > > On Thu, Jun 16, 2011 at 03:39:11PM -0400, Alan Stern wrote:
> > > > > > That's appropriate.  But nobody should ever set an isochronous
> > > > > > URB's status field to -EPROTO, no matter whether the device is
> > > > > > connected or not and no matter whether the host controller is
> > > > > > alive or not.
> > > > > 
> > > > > But the individual frame status be set to -EPROTO, correct?  That's
> > > > > what Alex was told to do when an isochronous TD had a completion
> > > > > code of "Incompatible Device Error".
> > > > 
> > > > Right.  -EPROTO is a perfectly reasonable code for a frame's status.
> > > > But not for an isochronous URB's status.  There's no reason for
> > > > uvcvideo to test for it.
> > > 
> > > The uvcvideo driver tests for -EPROTO for interrupt URBs only. For
> > > isochronous URBs it tests for -ENOENT, -ECONNRESET and -ESHUTDOWN.
> > 
> > So is uvc_status_complete() shared between interrupt and isochronous
> > URBs then?
> 
> No, uvc_status_complete() handles status URBs (interrupt only), and 
> uvc_video_complete() handles video URBs (isochronous or bulk, depending on the 
> device).

Huh, that's very odd then.  I could have sworn I was getting missed
service interval events (which are only for isochronous transfers) and
then seeing the "Non-zero" message.  And the userspace video definitely
froze before my patch and did not freeze after the patch was applied.
I'll have to look more closely at the logs.

Sarah Sharp
