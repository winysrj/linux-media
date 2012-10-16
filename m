Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59507 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094Ab2JPMVS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Oct 2012 08:21:18 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	airlied@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, sumit.semwal@ti.com, daeinki@gmail.com,
	daniel.vetter@ffwll.ch, robdclark@gmail.com, pawel@osciak.com,
	linaro-mm-sig@lists.linaro.org, hverkuil@xs4all.nl,
	remi@remlab.net, subashrp@gmail.com, mchehab@redhat.com,
	zhangfei.gao@gmail.com, s.nawrocki@samsung.com,
	k.debski@samsung.com
Subject: Re: [PATCHv10 23/26] v4l: vb2-dma-contig: align buffer size to PAGE_SIZE
Date: Tue, 16 Oct 2012 14:22:04 +0200
Message-ID: <5977627.RglZjG67sF@avalon>
In-Reply-To: <5077D3C2.7010207@samsung.com>
References: <1349880405-26049-1-git-send-email-t.stanislaws@samsung.com> <11844448.MZrezqZD1L@avalon> <5077D3C2.7010207@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

On Friday 12 October 2012 10:24:34 Tomasz Stanislawski wrote:
> On 10/11/2012 11:31 PM, Laurent Pinchart wrote:
> > On Wednesday 10 October 2012 16:46:42 Tomasz Stanislawski wrote:
> >> Most operations on DMA and DMABUF framework need page
> >> aligned buffers.
> > 
> > The comment is a bit misleading, the buffer is already page-aligned
> > (unless I'm mistaken dma_alloc_coherent() returns a page-aligned buffer)
> > but its size isn't a multiple of the page size.
> 
> Ok. I will update the commit message that only buffer size is going to be
> page aligned.
>
> > Do we really need a page size multiple ? Isn't it enough to make the size
> > a multiple of the cache line size ?
> 
> Frankly, I strongly oppose forcing a size of a DMA buffer to be rounded up.
> 
> However, I discovered a problem while testing mmap() interface in dma-buf.
> The test in dma_buf_mmap() will fail if the size is not a multiple of 4k.
> 
> Maybe the value from dma-buf.c:456 should be changed from:
> 
> dmabuf->size >> PAGE_SHIFT
> 
> to
> 
> PAGE_ALIGN(dmabuf->size) >> PAGE_SHIFT
> 
> However, I preferred to avoid any changes outside of the media tree hoping
> that the patchset gets merged. Rounding the buffer size to a page size was
> quick workaround for the issue with DMABUF mmap().

After some more thoughts I'm not sure whether this patch does the right thing. 
We have two sizes that we neeed to care about, the user usable buffer size and 
the allocated memory size.

When a user of a buffer requests buffer allocation with an explicit or 
implicit size we might need to allocate a larger buffer to fulfill usage 
requirements. We can thus end up with an allocated memory size larger than 
what the user requested. Such usage requirements include

- DMA and CPU access: when accessing the buffer both through DMA and directly 
by the CPU cache management comes into play, and the buffer address and size 
then need to be aligned to a cache line size boundary.

- Mapping to userspace: we can only map complete pages to userspace, the 
buffer address and size need to be aligned to a page size boundary to make 
sure that we won't leak unrelated data to userspace.

As the cache line size is smaller than a page fulfilling the second 
requirement always fulfills the first. There might be other requirements that 
escape my mind right now.

As we don't precisely know at allocation time how the buffer will be used (for 
instance whether it will eventually be mapped to userspace or not), we have 
two options:

- Align the buffer size to a page size boundary unconditionally.

- Let the user handle that requirement by specifying an allocation size 
aligned to a page size boundary.

Given the complexity associated with the second solution and the very small, 
if not inexistent, expected memory gain (when using the DMA allocation APIs we 
always get complete pages anyway, so there would be no gain in not aligning 
the allocation size to a page size boundary), I think the first solution 
should be preferred.

This leaves us with two questions related to buffer size: what size (between 
the requested size and the actually allocated size) do we report back to the 
user (in the v4l2_buffer length field for instance), and what size do we 
report to the dma-buf core (and thus to the other subsystems and other buffer 
users) ?

-- 
Regards,

Laurent Pinchart

