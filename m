Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:55227 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753810Ab2FKG2v (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jun 2012 02:28:51 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: Subash Patel <subashrp@gmail.com>, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org, airlied@redhat.com,
	m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	sumit.semwal@ti.com, daeinki@gmail.com, daniel.vetter@ffwll.ch,
	robdclark@gmail.com, pawel@osciak.com,
	linaro-mm-sig@lists.linaro.org, hverkuil@xs4all.nl,
	remi@remlab.net, mchehab@redhat.com, g.liakhovetski@gmx.de
Subject: Re: [PATCH 04/12] v4l: vb2-dma-contig: add setup of sglist for MMAP buffers
Date: Mon, 11 Jun 2012 08:28:55 +0200
Message-ID: <2352272.JbolkA93P4@avalon>
In-Reply-To: <4FD20CC3.9040901@samsung.com>
References: <1337778455-27912-1-git-send-email-t.stanislaws@samsung.com> <4FD0BA9D.6010704@gmail.com> <4FD20CC3.9040901@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

On Friday 08 June 2012 16:31:31 Tomasz Stanislawski wrote:
> Hi Laurent and Subash,
> 
> I confirm the issue found by Subash. The function vb2_dc_kaddr_to_pages does
> fail for some occasions. The failures are rather strange like 'got 95 of
> 150 pages'. It took me some time to find the reason of the problem.
> 
> I found that dma_alloc_coherent for iommu an ARM does use ioremap_page_range
> to map a buffer to the kernel space. The mapping is done by updating the
> page-table.
> 
> The problem is that any process has a different first-level page-table. The
> ioremap_page_range updates only the table for init process. The PT present
> in current->mm shares a majority of entries of 1st-level PT at kernel range
> (above 0xc0000000) but *not all*. That is why vb2_dc_kaddr_to_pages worked
> for small buffers and occasionally failed for larger buffers.
> 
> I found two ways to fix this problem.
> a) use &init_mm instead of current->mm while creating an artificial vma
> b) access the dma memory by calling
>    *((volatile int *)kaddr) = 0;
>    before calling follow_pfn
>    This way a fault is generated and the PT is
>    updated by copying entries from init_mm.
> 
> What do you think about presented solutions?

Just to be sure, this is a hack until dma_get_sgtable is available, and it 
won't make it to mainline, right ?  In that case using init_mm seem easier.

-- 
Regards,

Laurent Pinchart

