Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail2.shareable.org ([80.68.89.115]:46826 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755668AbZHGKXp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Aug 2009 06:23:45 -0400
Date: Fri, 7 Aug 2009 11:23:39 +0100
From: Jamie Lokier <jamie@shareable.org>
To: David Xiao <dxiao@broadcom.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Ben Dooks <ben-linux@fluff.org>,
	Hugh Dickins <hugh.dickins@tiscali.co.uk>,
	Robin Holt <holt@sgi.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	v4l2_linux <linux-media@vger.kernel.org>,
	"linux-arm-kernel@lists.arm.linux.org.uk"
	<linux-arm-kernel@lists.arm.linux.org.uk>
Subject: Re: How to efficiently handle DMA and cache on ARMv7 ? (was "Is get_user_pages() enough to prevent pages from being swapped out ?")
Message-ID: <20090807102339.GK8725@shareable.org>
References: <200908061208.22131.laurent.pinchart@ideasonboard.com> <20090806114619.GW2080@trinity.fluff.org> <200908061506.23874.laurent.pinchart@ideasonboard.com> <1249584374.29182.20.camel@david-laptop> <20090806222543.GG31579@n2100.arm.linux.org.uk> <1249624766.32621.61.camel@david-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249624766.32621.61.camel@david-laptop>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

David Xiao wrote:
> > However, that won't work with ARMv7's speculative prefetching.  I'm
> > afraid with such things, DMA direct into userspace mappings becomes a
> > _lot_ harder, and lets face it, lots of Linux drivers just aren't going
> > to bother supporting this - we can't currently get agreement to have an
> > API to map DMA coherent pages into userspace!
> 
> The V7 speculative prefetching will then probably apply to DMA coherency
> issue in general, both kernel and user space DMAs. Could this be
> addressed by inside the dma_unmap_sg/single() calling dma_cache_maint()
> when the direction is DMA_FROM_DEVICE/DMA_BIDIRECTIONAL, to basically
> invalidate the related cache lines in case any filled by prefetching?
> Assuming dma_unmap_sg/single() is called after each DMA operation is
> completed. 

If it's possible, surely its essential because of O_DIRECT file and
block I/O?

-- Jamie
