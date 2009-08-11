Return-path: <linux-media-owner@vger.kernel.org>
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:52589 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752317AbZHKL5T (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Aug 2009 07:57:19 -0400
Subject: Re: How to efficiently handle DMA and cache on ARMv7 ? (was "Is
	get_user_pages() enough to prevent pages from being swapped out ?")
From: Catalin Marinas <catalin.marinas@arm.com>
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
In-Reply-To: <1249624766.32621.61.camel@david-laptop>
References: <200908061208.22131.laurent.pinchart@ideasonboard.com>
	 <20090806114619.GW2080@trinity.fluff.org>
	 <200908061506.23874.laurent.pinchart@ideasonboard.com>
	 <1249584374.29182.20.camel@david-laptop>
	 <20090806222543.GG31579@n2100.arm.linux.org.uk>
	 <1249624766.32621.61.camel@david-laptop>
Content-Type: text/plain
Date: Tue, 11 Aug 2009 10:31:02 +0100
Message-Id: <1249983062.27150.20.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2009-08-06 at 22:59 -0700, David Xiao wrote:
> The V7 speculative prefetching will then probably apply to DMA coherency
> issue in general, both kernel and user space DMAs. Could this be
> addressed by inside the dma_unmap_sg/single() calling dma_cache_maint()
> when the direction is DMA_FROM_DEVICE/DMA_BIDIRECTIONAL, to basically
> invalidate the related cache lines in case any filled by prefetching?
> Assuming dma_unmap_sg/single() is called after each DMA operation is
> completed. 

Theoretically, with speculative prefetching on ARMv7 and the FROM_DEVICE
case we need to invalidate the corresponding D-cache lines both before
and after the DMA transfer, i.e. in both dma_map_sg and dma_unmap_sg,
otherwise there is a risk of stale data in the cache.

-- 
Catalin

