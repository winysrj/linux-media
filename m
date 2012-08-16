Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:13777 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106Ab2HPKkR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Aug 2012 06:40:17 -0400
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: 'Hideki EIRAKU' <hdk@igel.co.jp>
Cc: laurent.pinchart@ideasonboard.com, linux@arm.linux.org.uk,
	pawel@osciak.com, kyungmin.park@samsung.com, mchehab@infradead.org,
	FlorianSchandinat@gmx.de, perex@perex.cz, tiwai@suse.de,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, linux-fbdev@vger.kernel.org,
	alsa-devel@alsa-project.org, matsu@igel.co.jp, dhobsong@igel.co.jp
References: <1344246924-32620-1-git-send-email-hdk@igel.co.jp>
 <1344246924-32620-4-git-send-email-hdk@igel.co.jp>
 <012701cd74ac$6a617060$3f245120$%szyprowski@samsung.com>
 <20120816.191358.127675610.hdk@igel.co.jp>
In-reply-to: <20120816.191358.127675610.hdk@igel.co.jp>
Subject: RE: [PATCH v3 3/4] media: videobuf2-dma-contig: use dma_mmap_coherent
 if available
Date: Thu, 16 Aug 2012 12:39:57 +0200
Message-id: <015b01cd7b9b$8010e2b0$8032a810$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Thursday, August 16, 2012 12:14 PM Hideki EIRAKU wrote:

> From: Marek Szyprowski <m.szyprowski@samsung.com>
> Subject: RE: [PATCH v3 3/4] media: videobuf2-dma-contig: use dma_mmap_coherent if available
> Date: Tue, 07 Aug 2012 16:53:25 +0200
> 
> > I'm sorry for bringing this issue now, once you have already created v3 of your
> > patches, but similar patch has been already proposed some time ago. It is already
> > processed together with general videobuf2-dma-contig redesign and dma-buf extensions
> > by Tomasz Stanislawski.
> >
> > See post http://thread.gmane.org/gmane.comp.video.dri.devel/70402/focus=49461 and
> > http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/49438
> >
> > It doesn't use conditional code inside videobuf2 allocator and rely entirely on
> > dma-mapping subsystem to provide a working dma_mmap_coherent/writecombine/attrs()
> > function. When it was posted, it relied on the dma-mapping extensions, which now
> > have been finally merged to v3.6-rc1. Now I wonder if there are any architectures,
> > which don't use dma_map_ops based dma-mapping framework, which might use
> > videobuf2-dma-conting module.
> 
> Thank you for telling me about videobuf2-dma-contig and v3.6-rc1.  The
> videobuf2-dma-contig patch I sent is now unnecessary.  So I will
> remove the patch.  I will remove the patch defining
> ARCH_HAS_DMA_MMAP_COHERENT too because the v3.6-rc1 kernel has generic
> dma_mmap_coherent() API for every architecture.

Just to let you know - Tomasz has posted an updated version of the dma-buf/vb2-dma-contig
patches:

http://www.spinics.net/lists/linux-media/msg51768.html

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


