Return-path: <mchehab@pedra>
Received: from mga01.intel.com ([192.55.52.88]:54909 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758120Ab1FPT6q (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jun 2011 15:58:46 -0400
Date: Thu, 16 Jun 2011 12:58:43 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, USB list <linux-usb@vger.kernel.org>,
	Andiry Xu <andiry.xu@amd.com>, Alex He <alex.he@amd.com>
Subject: Re: uvcvideo failure under xHCI
Message-ID: <20110616195843.GB7290@xanatos>
References: <20110616190634.GA7290@xanatos>
 <Pine.LNX.4.44L0.1106161536110.1697-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1106161536110.1697-100000@iolanthe.rowland.org>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, Jun 16, 2011 at 03:39:11PM -0400, Alan Stern wrote:
> That's appropriate.  But nobody should ever set an isochronous URB's
> status field to -EPROTO, no matter whether the device is connected or
> not and no matter whether the host controller is alive or not.

But the individual frame status be set to -EPROTO, correct?  That's what
Alex was told to do when an isochronous TD had a completion code of
"Incompatible Device Error".

Sarah Sharp
