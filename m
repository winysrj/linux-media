Return-path: <linux-media-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.231]:33143 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742AbZCKXQB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Mar 2009 19:16:01 -0400
Date: Wed, 11 Mar 2009 15:15:55 -0700
From: Brandon Philips <brandon@ifup.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <gregkh@suse.de>, laurent.pinchart@skynet.be,
	linux-media@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: S4 hang with uvcvideo causing "Unlink after no-IRQ? Controller
	is probably using the wrong IRQ."
Message-ID: <20090311221555.GB5776@jenkins.ifup.org>
References: <20090311172031.GC22789@jenkins.ifup.org> <Pine.LNX.4.44L0.0903111543580.21047-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0903111543580.21047-100000@iolanthe.rowland.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 15:46 Wed 11 Mar 2009, Alan Stern wrote:
> On Wed, 11 Mar 2009, Brandon Philips wrote:
> Okay, here's a diagnostic patch meant to apply on top of 
> gregkh-all-2.6.29-rc7.  Let's see what it says...

Here is the log:
 http://ifup.org/~philips/467317/pearl-alan-debug.log

>  	default:
>  		qh = (struct ehci_qh *) urb->hcpriv;
> +		if (alantest == 1) {
> +			alantest = 2;
> +			ehci_info(ehci, "dequeue: qh %p\n", qh);
> +		}

This was the last thing printed before I dumped the task states with sysrq
keys.

Thanks,

	Brandon
