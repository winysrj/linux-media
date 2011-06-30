Return-path: <mchehab@pedra>
Received: from mga09.intel.com ([134.134.136.24]:11452 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751027Ab1F3SBF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jun 2011 14:01:05 -0400
Date: Thu, 30 Jun 2011 11:01:01 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Kirill Smelkov <kirr@mns.spb.ru>
Cc: Alan Stern <stern@rowland.harvard.edu>,
	matt mooney <mfm@muteddisk.com>,
	Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
	linux-uvc-devel@lists.berlios.de, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] USB: EHCI: Allow users to override 80% max
 periodic bandwidth
Message-ID: <20110630180101.GB7979@xanatos>
References: <cover.1308933456.git.kirr@mns.spb.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1308933456.git.kirr@mns.spb.ru>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Fri, Jun 24, 2011 at 08:48:06PM +0400, Kirill Smelkov wrote:
> 
> Changes since v1:
> 
> 
>  - dropped RFC status as "this seems like the sort of feature somebody might
>    reasonably want to use -- if they know exactly what they're doing";
> 
>  - new preparatory patch (1/2) which moves already-in-there sysfs code into
>    ehci-sysfs.c;
> 
>  - moved uframe_periodic_max parameter from module option to sysfs attribute,
>    so that it can be set per controller and at runtime, added validity checks;
> 
>  - clarified a bit bandwith analysis for 96% max periodic setup as noticed by
>    Alan Stern;
> 
>  - clarified patch description saying that set in stone 80% max periodic is
>    specified by USB 2.0;

Have you tested this patch by maxing out this bandwidth on various
types of host controllers?  It's entirely possible that you'll run into
vendor-specific bugs if you try to pack the schedule with isochronous
transfers.  I don't think any hardware designer would seriously test or
validate their hardware with a schedule that is basically a violation of
the USB bus spec (more than 80% for periodic transfers).

But if Alan is fine with giving users a way to shoot themselves in the
foot, and it's disabled by default, then I don't particularly mind this
patch.

Sarah Sharp
