Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:22267 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754804Ab2DQL0D (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Apr 2012 07:26:03 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=US-ASCII
Received: from euspt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M2M007ZWFRKJBA0@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 17 Apr 2012 12:26:08 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M2M009CLFRCOB@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 17 Apr 2012 12:26:00 +0100 (BST)
Date: Tue, 17 Apr 2012 13:25:56 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH 08/11] v4l: vb2-dma-contig: add support for scatterlist in
 userptr mode
In-reply-to: <2771378.1sgcPnzBp9@avalon>
To: 'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	airlied@redhat.com, kyungmin.park@samsung.com, sumit.semwal@ti.com,
	daeinki@gmail.com, daniel.vetter@ffwll.ch, robdclark@gmail.com,
	pawel@osciak.com, linaro-mm-sig@lists.linaro.org,
	subashrp@gmail.com, Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
	'Kamil Debski' <k.debski@samsung.com>
Message-id: <002401cd1c8c$db56a420$9203ec60$%szyprowski@samsung.com>
Content-language: pl
References: <1333634408-4960-1-git-send-email-t.stanislaws@samsung.com>
 <7682170.ReRPS8sOII@avalon> <4F8557C3.9030502@samsung.com>
 <2771378.1sgcPnzBp9@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Tuesday, April 17, 2012 2:41 AM Laurent Pinchart wrote:

(snipped)

> > >> +static struct vm_area_struct *vb2_dc_get_user_vma(
> > >> +	unsigned long start, unsigned long size)
> > >> +{
> > >> +	struct vm_area_struct *vma;
> > >> +
> > >> +	/* current->mm->mmap_sem is taken by videobuf2 core */
> > >> +	vma = find_vma(current->mm, start);
> > >> +	if (!vma) {
> > >> +		printk(KERN_ERR "no vma for address %lu\n", start);
> > >> +		return ERR_PTR(-EFAULT);
> > >> +	}
> > >> +
> > >> +	if (vma->vm_end - vma->vm_start < size) {
> > >> +		printk(KERN_ERR "vma at %lu is too small for %lu bytes\n",
> > >> +			start, size);
> > >> +		return ERR_PTR(-EFAULT);
> > >> +	}
> > >
> > > Should we support multiple VMAs, or do you think that's not worth it ?
> >
> > What do you mean by multiple VMAs?
> 
> I mean multiple VMAs for a single userspace buffer. It's probably overkill,
> but I'm not familiar enough with the memory management code to be sure. Do you
> have more insight ?

Multiple VMAs means that userspace did something really hacky in the specified 
address range, I'm really convinced that we should not bother supporting such 
cases.

With user pointer mode You usually want to get access to either anonymous pages
(malloc and friends) or the memory somehow allocated by the other device 
(mmaped to userspace). In both cases it available as a single VMA. VMAs with 
anonymous memory are merged together if they get extended to meet side-by-side 
each other.

> 
> > >> +	vma = vb2_get_vma(vma);
> > >> +	if (!vma) {
> > >> +		printk(KERN_ERR "failed to copy vma\n");
> > >> +		return ERR_PTR(-ENOMEM);
> > >> +	}
> > >
> > > I still think there's no need to copy the VMA. get_user_pages() will make
> > > sure the memory doesn't get paged out, and we don't need to ensure that
> > > the userspace mapping stays in place as our cache operations use a
> > > scatter list. Storing the result of vma_is_io() in vb2_dc_buf should be
> > > enough.
> >
> > As I understand calling get_user_pages ensures that pages are not going to
> > be swapped or freed. I agree that it provides enough protection for the
> > memory.
> >
> > IO mappings are the problem. As you mentioned few mails ago get_page would
> > likely crash for such pages. AFAIK increasing reference count for VMA could
> > be a reliable mechanism for protecting the memory from being freed.
> 
> The main use case here (which is actually the only use case I have
> encountered) is memory reserved at boot time to be used by specific devices
> such as frame buffers. That memory will never be paged out, so I don't think
> there's an issue here. Regarding freeing, it will likely not be freed either,
> and if it does, I doubt that duplicating the VMA will make any difference.

We use user pointer method also to access buffers allocated dynamically by 
other v4l2 devices (we have quite a lot of the in our system). In this case
duplicating VMA is necessary.

> > The problem is that VMA has no reference counters in it. Calling open ops
> > will protect the memory. However it will not protect VMA structure from
> > being freed!
> >
> > Analyze following scenario:
> >
> > - mmap -> returns userptr
> > - qbuf (userptr)
> > - unmap (userptr)
> > - dqbuf
> >
> > The VMA will be destroyed at unmap but memory will not be released.
> >
> > The reason is that open ops was called at qbuf.
> 
> I think I see your point. You want to make sure that the exporter driver (on
> which mmap() has been called) will not release the memory, and to do so you
> call the exporter's open() vm operation when you acquire the memory. To call
> the exporter's close() operation when you release the memory you need a
> pointer to the VMA, but the original VMA might have disappeared. To work
> around the problem you make a copy of the VMA and use it when releasing the
> memory.
> 
> That's a pretty dirty hack. Most of the copy VMA fields will be invalid when
> you use it. On a side note, would storing vm_ops and vm_private_data be enough
> ? I'm also not sure if we need to call get_file() and put_file().

This code is there from the beginning of the videobuf2. The main problem is the
fact that you cannot get a reliable access to user pointer memory which is not 
described with anonymous pages. The hacks/workarounds we use at works really
well with the memory mmaped by the other v4l2 devices (which use vm_open/
vm_close refcounting) and framebuffers which use no refcounting on vma, but we
force them not to release memory by calling get_file() (so the framebuffer 
driver cannot be removed/unloaded once we use its memory, yes, pretty 
theoretical case).

Copying vma was the only solution for the races that usually happen on process 
cleanup or special 'nasty' test case which closed the device before closing the
other v4l2 which used its memory with user pointer method.

The most critical parts of vma are NULLed (vm_mm, vm_next, vm_prev) to catch 
possible issues, but the sane close callback should not touch them anyway. 
Besides vm_private_data, close callback might need to access vm_file, 
vm_start/vm_end and vm_flags. Maybe coping them explicitly while keeping 
everything else NULLed would be a better idea. 

(snipped)

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center



