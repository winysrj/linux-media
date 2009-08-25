Return-path: <linux-media-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:25829 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbZHYMx3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Aug 2009 08:53:29 -0400
MIME-Version: 1.0
In-Reply-To: <20090806222543.GG31579@n2100.arm.linux.org.uk>
References: <200908061208.22131.laurent.pinchart@ideasonboard.com>
	 <20090806114619.GW2080@trinity.fluff.org>
	 <200908061506.23874.laurent.pinchart@ideasonboard.com>
	 <1249584374.29182.20.camel@david-laptop>
	 <20090806222543.GG31579@n2100.arm.linux.org.uk>
Date: Tue, 25 Aug 2009 08:53:29 -0400
Message-ID: <e06498070908250553h5971102x6da7004495abb911@mail.gmail.com>
Subject: Re: How to efficiently handle DMA and cache on ARMv7 ? (was "Is
	get_user_pages() enough to prevent pages from being swapped out ?")
From: Steven Walter <stevenrwalter@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: David Xiao <dxiao@broadcom.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Ben Dooks <ben-linux@fluff.org>,
	Hugh Dickins <hugh.dickins@tiscali.co.uk>,
	Robin Holt <holt@sgi.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	v4l2_linux <linux-media@vger.kernel.org>,
	"linux-arm-kernel@lists.arm.linux.org.uk"
	<linux-arm-kernel@lists.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Aug 6, 2009 at 6:25 PM, Russell King - ARM
Linux<linux@arm.linux.org.uk> wrote:
[...]
> As far as userspace DMA coherency, the only way you could do it with
> current kernel APIs is by using get_user_pages(), creating a scatterlist
> from those, and then passing it to dma_map_sg().  While the device has
> ownership of the SG, userspace must _not_ touch the buffer until after
> DMA has completed.
[...]

Would that work on a processor with VIVT caches?  It seems not.  In
particular, dma_map_page uses page_address to get a virtual address to
pass to map_single().  map_single() in turn uses this address to
perform cache maintenance.  Since page_address() returns the kernel
virtual address, I don't see how any cache-lines for the userspace
virtual address would get invalidated (for the DMA_FROM_DEVICE case).

If that's true, then what is the correct way to allow DMA to/from a
userspace buffer with a VIVT cache?  If not true, what am I missing?

Thanks
-- 
-Steven Walter <stevenrwalter@gmail.com>
