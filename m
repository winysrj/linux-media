Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:42417 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754755Ab2DQAkW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Apr 2012 20:40:22 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	airlied@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, sumit.semwal@ti.com, daeinki@gmail.com,
	daniel.vetter@ffwll.ch, robdclark@gmail.com, pawel@osciak.com,
	linaro-mm-sig@lists.linaro.org, subashrp@gmail.com,
	Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
	Kamil Debski <k.debski@samsung.com>
Subject: Re: [PATCH 08/11] v4l: vb2-dma-contig: add support for scatterlist in userptr mode
Date: Tue, 17 Apr 2012 02:40:33 +0200
Message-ID: <2771378.1sgcPnzBp9@avalon>
In-Reply-To: <4F8557C3.9030502@samsung.com>
References: <1333634408-4960-1-git-send-email-t.stanislaws@samsung.com> <7682170.ReRPS8sOII@avalon> <4F8557C3.9030502@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

On Wednesday 11 April 2012 12:06:59 Tomasz Stanislawski wrote:
> On 04/06/2012 05:02 PM, Laurent Pinchart wrote:
> > On Thursday 05 April 2012 16:00:05 Tomasz Stanislawski wrote:

[snip]

> > Also, Documentation/CodingStyle favors one variable declaration per line,
> > without commas for multiple declarations.
> 
> does it include loop counters like i and j?

According to CodingStyle, yes :-)

[snip]

> >> +static struct vm_area_struct *vb2_dc_get_user_vma(
> >> +	unsigned long start, unsigned long size)
> >> +{
> >> +	struct vm_area_struct *vma;
> >> +
> >> +	/* current->mm->mmap_sem is taken by videobuf2 core */
> >> +	vma = find_vma(current->mm, start);
> >> +	if (!vma) {
> >> +		printk(KERN_ERR "no vma for address %lu\n", start);
> >> +		return ERR_PTR(-EFAULT);
> >> +	}
> >> +
> >> +	if (vma->vm_end - vma->vm_start < size) {
> >> +		printk(KERN_ERR "vma at %lu is too small for %lu bytes\n",
> >> +			start, size);
> >> +		return ERR_PTR(-EFAULT);
> >> +	}
> > 
> > Should we support multiple VMAs, or do you think that's not worth it ?
> 
> What do you mean by multiple VMAs?

I mean multiple VMAs for a single userspace buffer. It's probably overkill, 
but I'm not familiar enough with the memory management code to be sure. Do you 
have more insight ?

> >> +	vma = vb2_get_vma(vma);
> >> +	if (!vma) {
> >> +		printk(KERN_ERR "failed to copy vma\n");
> >> +		return ERR_PTR(-ENOMEM);
> >> +	}
> > 
> > I still think there's no need to copy the VMA. get_user_pages() will make
> > sure the memory doesn't get paged out, and we don't need to ensure that
> > the userspace mapping stays in place as our cache operations use a
> > scatter list. Storing the result of vma_is_io() in vb2_dc_buf should be
> > enough.
> 
> As I understand calling get_user_pages ensures that pages are not going to
> be swapped or freed. I agree that it provides enough protection for the
> memory.
> 
> IO mappings are the problem. As you mentioned few mails ago get_page would
> likely crash for such pages. AFAIK increasing reference count for VMA could
> be a reliable mechanism for protecting the memory from being freed.

The main use case here (which is actually the only use case I have 
encountered) is memory reserved at boot time to be used by specific devices 
such as frame buffers. That memory will never be paged out, so I don't think 
there's an issue here. Regarding freeing, it will likely not be freed either, 
and if it does, I doubt that duplicating the VMA will make any difference. 

> The problem is that VMA has no reference counters in it. Calling open ops
> will protect the memory. However it will not protect VMA structure from
> being freed!
> 
> Analyze following scenario:
> 
> - mmap -> returns userptr
> - qbuf (userptr)
> - unmap (userptr)
> - dqbuf
> 
> The VMA will be destroyed at unmap but memory will not be released.
>
> The reason is that open ops was called at qbuf.

I think I see your point. You want to make sure that the exporter driver (on 
which mmap() has been called) will not release the memory, and to do so you 
call the exporter's open() vm operation when you acquire the memory. To call 
the exporter's close() operation when you release the memory you need a 
pointer to the VMA, but the original VMA might have disappeared. To work 
around the problem you make a copy of the VMA and use it when releasing the 
memory.

That's a pretty dirty hack. Most of the copy VMA fields will be invalid when 
you use it. On a side note, would storing vm_ops and vm_private_data be enough 
? I'm also not sure if we need to call get_file() and put_file().

> In order to free the memory the VB2 has to call close ops. This
> callback takes pointer to VMA as an argument. The original VMA
> cannot be used here because it is not longer valid.
> 
> Therefore VMA has to be copied at qbuf operation. The function vb2_get_vma
> is used for this purpose.
>
> The workaround could be dropping support for IO mappings in VB2.
> However it will handicap all s5p media drivers because mapping
> produced by dma_mmap_coherent (aka writecombine) are IO mapping.
> As result s5p-fimc could no longer create a pipeline with s5p-mfc.

There's no reason to drop that, even if it's currently hackish :-) (at least 
until we have a working replacement).
 
> Introducing DMABUF to V4L is a good alternative but only if exporting
> is supported.
> 
> For now I think it is better to keep support for IO mappings. At least
> until DMA mapping redesign and DMABUF exporting in V4L is merged.

I agree. DMABUF is the way to go, but we need to get it in first.

> >> +	return vma;
> >> +}

-- 
Regards,

Laurent Pinchart

