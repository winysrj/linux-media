Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:51780 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755212Ab1FQRBA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jun 2011 13:01:00 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: Re: uvcvideo failure under xHCI
Date: Fri, 17 Jun 2011 19:01:10 +0200
Cc: Alan Stern <stern@rowland.harvard.edu>,
	linux-media@vger.kernel.org, USB list <linux-usb@vger.kernel.org>,
	Andiry Xu <andiry.xu@amd.com>, Alex He <alex.he@amd.com>
References: <Pine.LNX.4.44L0.1106161619140.1697-100000@iolanthe.rowland.org> <201106171018.40285.laurent.pinchart@ideasonboard.com> <20110617164620.GD5416@xanatos>
In-Reply-To: <20110617164620.GD5416@xanatos>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106171901.11139.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Sarah,

On Friday 17 June 2011 18:46:20 Sarah Sharp wrote:
> On Fri, Jun 17, 2011 at 10:18:39AM +0200, Laurent Pinchart wrote:
> > On Thursday 16 June 2011 22:20:22 Alan Stern wrote:
> > > On Thu, 16 Jun 2011, Sarah Sharp wrote:
> > > > On Thu, Jun 16, 2011 at 03:39:11PM -0400, Alan Stern wrote:
> > > > > That's appropriate.  But nobody should ever set an isochronous
> > > > > URB's status field to -EPROTO, no matter whether the device is
> > > > > connected or not and no matter whether the host controller is
> > > > > alive or not.
> > > > 
> > > > But the individual frame status be set to -EPROTO, correct?  That's
> > > > what Alex was told to do when an isochronous TD had a completion
> > > > code of "Incompatible Device Error".
> > > 
> > > Right.  -EPROTO is a perfectly reasonable code for a frame's status.
> > > But not for an isochronous URB's status.  There's no reason for
> > > uvcvideo to test for it.
> > 
> > The uvcvideo driver tests for -EPROTO for interrupt URBs only. For
> > isochronous URBs it tests for -ENOENT, -ECONNRESET and -ESHUTDOWN.
> 
> So is uvc_status_complete() shared between interrupt and isochronous
> URBs then?

No, uvc_status_complete() handles status URBs (interrupt only), and 
uvc_video_complete() handles video URBs (isochronous or bulk, depending on the 
device).

-- 
Regards,

Laurent Pinchart
