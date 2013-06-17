Return-path: <linux-media-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43073 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756209Ab3FQNb7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Jun 2013 09:31:59 -0400
Date: Mon, 17 Jun 2013 14:31:10 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Inki Dae <inki.dae@samsung.com>
Cc: 'Maarten Lankhorst' <maarten.lankhorst@canonical.com>,
	linux-fbdev@vger.kernel.org, kyungmin.park@samsung.com,
	dri-devel@lists.freedesktop.org, robdclark@gmail.com,
	myungjoo.ham@samsung.com, yj44.cho@samsung.com, daniel@ffwll.ch,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [RFC PATCH v2] dmabuf-sync: Introduce buffer synchronization
	framework
Message-ID: <20130617133109.GG2718@n2100.arm.linux.org.uk>
References: <1371112088-15310-1-git-send-email-inki.dae@samsung.com> <1371467722-665-1-git-send-email-inki.dae@samsung.com> <51BEF458.4090606@canonical.com> <012501ce6b5b$3d39b0b0$b7ad1210$%dae@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <012501ce6b5b$3d39b0b0$b7ad1210$%dae@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jun 17, 2013 at 10:04:45PM +0900, Inki Dae wrote:
> It's just to implement a thin sync framework coupling cache operation. This
> approach is based on dma-buf for more generic implementation against android
> sync driver or KDS.
> 
> The described steps may be summarized as:
> 	lock -> cache operation -> CPU or DMA access to a buffer/s -> unlock
> 
> I think that there is no need to get complicated for such approach at least
> for most devices sharing system memory. Simple is best.

But hang on, doesn't the dmabuf API already provide that?

The dmabuf API already uses dma_map_sg() and dma_unmap_sg() by providers,
and the rules around the DMA API are that:

	dma_map_sg()
	/* DMA _ONLY_ has access, CPU should not access */
	dma_unmap_sg()
	/* DMA may not access, CPU can access */

It's a little more than that if you include the sync_sg_for_cpu and
sync_sg_for_device APIs too - but the above is the general idea.  What
this means from the dmabuf API point of view is that once you attach to
a dma_buf, and call dma_buf_map_attachment() to get the SG list, the CPU
doesn't have ownership of the buffer and _must_ _not_ access it via any
other means - including using the other dma_buf methods, until either
the appropriate dma_sync_sg_for_cpu() call has been made or the DMA
mapping has been removed via dma_buf_unmap_attachment().

So, the sequence should be:

	dma_buf_map_attachment()
	/* do DMA */
	dma_buf_unmap_attachment()
	/* CPU can now access the buffer */
