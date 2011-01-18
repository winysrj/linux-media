Return-path: <mchehab@pedra>
Received: from mailout3.samsung.com ([203.254.224.33]:52743 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157Ab1ARL1k (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Jan 2011 06:27:40 -0500
Date: Tue, 18 Jan 2011 20:27:32 +0900
From: Jeongtae Park <jtp.park@samsung.com>
Subject: RE: [PATCH 0/1] v4l: videobuf2: Add DMA pool allocator
In-reply-to: <008f01cbb65d$f4c33a40$de49aec0$%szyprowski@samsung.com>
To: 'Marek Szyprowski' <m.szyprowski@samsung.com>,
	linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: k.debski@samsung.com, jaeryul.oh@samsung.com,
	jonghun.han@samsung.com, kgene.kim@samsung.com
Reply-to: jtp.park@samsung.com
Message-id: <006a01cbb702$b5d62900$21827b00$%park@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=Windows-1252
Content-language: ko
Content-transfer-encoding: 7BIT
References: <1293684907-7272-1-git-send-email-jtp.park@samsung.com>
 <008f01cbb65d$f4c33a40$de49aec0$%szyprowski@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Marek Szyprowski
> Sent: Tuesday, January 18, 2011 12:48 AM
> To: 'Jeongtae Park'; linux-media@vger.kernel.org; linux-samsung-
> soc@vger.kernel.org
> Cc: k.debski@samsung.com; jaeryul.oh@samsung.com; jonghun.han@samsung.com;
> kgene.kim@samsung.com
> Subject: RE: [PATCH 0/1] v4l: videobuf2: Add DMA pool allocator
> 
> Hello,
> 
> On Thursday, December 30, 2010 5:55 AM Jeongtae Park wrote:
> 
> > The DMA pool allocator allocates a memory using dma_alloc_coherent(),
> > creates a pool using generic allocator in the initialization.
> > For every allocation requests, the allocator returns a part of its
> > memory pool using generic allocator instead of new memory allocation.
> >
> > This allocator used for devices have below limitations.
> > - the start address should be aligned
> > - the range of memory access limited to the offset from the start
> >   address (= the allocation address should be existed in a
> >   constant offset from the start address)
> > - the allocation address should be aligned
> >
> > I would be grateful for your comments.
> >
> > This patch series contains:
> >
> > [PATCH 1/1] v4l: videobuf2: Add DMA pool allocator
> >
> > Best regards,
> > Jeongtae Park
> >
> > Patch summary:
> >
> > Jeongtae Park (1):
> >       v4l: videobuf2: Add DMA pool allocator
> >
> >  drivers/media/video/Kconfig              |    7 +
> >  drivers/media/video/Makefile             |    1 +
> >  drivers/media/video/videobuf2-dma-pool.c |  310
> ++++++++++++++++++++++++++++++
> >  include/media/videobuf2-dma-pool.h       |   37 ++++
> >  4 files changed, 355 insertions(+), 0 deletions(-)
> >  create mode 100644 drivers/media/video/videobuf2-dma-pool.c
> >  create mode 100644 include/media/videobuf2-dma-pool.h
> 
> The code looks nice but I have one suggestion. This dma-pool memory
allocator
> make sense only for a s5p-mfc driver. All other drivers can use dma-contig
> vb2
> allocator directly. For this reason I suggest to move this allocator
directly
> to drivers/media/video/s5p-mfc/ directory.
>

Is it not possible that there is the device with above limitations or
constraints?
If it's possible, the dma-pool allocator can be useful, but currently this
allocator
is useful only for a s5p-mfc.
But, all other allocators of vb2 framework are drivers/media/video/
directory.
I'm not sure which position is right for dma-pool allocator.

Thanks for your comment.

> Best regards
> --
> Marek Szyprowski
> Samsung Poland R&D Center
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Best regards

