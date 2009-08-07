Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail2.shareable.org ([80.68.89.115]:37984 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756070AbZHGJyk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Aug 2009 05:54:40 -0400
Date: Fri, 7 Aug 2009 10:54:27 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	David Xiao <dxiao@broadcom.com>,
	Ben Dooks <ben-linux@fluff.org>,
	Hugh Dickins <hugh.dickins@tiscali.co.uk>,
	Robin Holt <holt@sgi.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	v4l2_linux <linux-media@vger.kernel.org>,
	"linux-arm-kernel@lists.arm.linux.org.uk"
	<linux-arm-kernel@lists.arm.linux.org.uk>
Subject: Re: How to efficiently handle DMA and cache on ARMv7 ? (was "Is get_user_pages() enough to prevent pages from being swapped out ?")
Message-ID: <20090807095426.GI8725@shareable.org>
References: <200908061208.22131.laurent.pinchart@ideasonboard.com> <20090806222543.GG31579@n2100.arm.linux.org.uk> <1249624766.32621.61.camel@david-laptop> <200908070958.31322.laurent.pinchart@ideasonboard.com> <20090807081041.GB18343@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090807081041.GB18343@n2100.arm.linux.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Russell King - ARM Linux wrote:
> On Fri, Aug 07, 2009 at 09:58:30AM +0200, Laurent Pinchart wrote:
> > Sorry about this, but I'm not sure to understand the speculative prefetching 
> > cache issue completely.
> 
> The general case with speculative prefetching is that if memory is
> accessible, it can be prefetched.
> 
> In other words, if we mapped devices without NX (non-exec) set, the
> CPU can prefetch instructions from devices, causing random read
> accesses.  Yes, I know it sounds crazy, but that's what I'm told
> _can_ happen.

1. Does the architecture not prevent speculative instruction
prefetches from crossing a page boundary?  It would be handy under the
circumstances.

2. Is NX available on all the CPUs with speculative prefetching
behaviour?  If it is, just use that for device mappings?

-- Jamie
