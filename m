Return-path: <mchehab@pedra>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:57216 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803Ab1FJGys (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jun 2011 02:54:48 -0400
Received: from eu_spt1 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LMK00519B7AJT@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 10 Jun 2011 07:54:46 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LMK00025B79SU@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 10 Jun 2011 07:54:45 +0100 (BST)
Date: Fri, 10 Jun 2011 08:54:24 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: videobuf2 and VMAs
In-reply-to: <20110609172103.18f242b2@bike.lwn.net>
To: 'Jonathan Corbet' <corbet@lwn.net>,
	'Pawel Osciak' <pawel@osciak.com>, linux-media@vger.kernel.org
Message-id: <002001cc273b$3bbf7aa0$b33e6fe0$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
References: <20110609172103.18f242b2@bike.lwn.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

On Friday, June 10, 2011 1:21 AM Jonathan Corbet wrote:

> I'm finally getting around to trying to really understand videobuf2.  In
> the process I've run into something which has thrown me for a bit of a
> loop...
> 
> /**
>  * vb2_get_vma() - acquire and lock the virtual memory area
>  * @vma:	given virtual memory area
>  *
>  * This function attempts to acquire an area mapped in the userspace for
>  * the duration of a hardware operation. The area is "locked" by performing
>  * the same set of operation that are done when process calls fork() and
>  * memory areas are duplicated.
>  *
>  * Returns a copy of a virtual memory region on success or NULL.
>  */
> 
> This function makes a copy of the VMA which is completely outside of the
> knowledge of the mm subsystem.  For the life of me, I cannot figure out
> why that is a wise or necessary thing to do.  You are not locking the real
> VMA in any way.  If you're worried about the underlying pages going away
> somehow, this will not save you.  User space can still munmap() the space
> whenever it feels like it.

This vb2_get_vma() function mimics the fork() situation, where the vma
structures are cloned and transferred to the new process. All these operations
are performed to ensure that the memory that is behind this vma will not go
away. This means that the following operations are performed: if there exists
a backing file behind the vma, its ref count is increased (simulates open()
call), the vma is copied (in case of fork the vma structures are also copied)
and vm_open() method is called.

This way even if the user will munmap() the original area and close the fd in
his process, the vma (the copied fake vma structure) will still exist and can
be used by vb2 for calling vm_close() method once the client of that memory
finished his access. This ensures that the memory (underlying pages or pfns)
that have been grabbed by vb2_get_vma() are still available until the 
vb2_put_vma() call. 

This of course requires the driver to operate correctly - use vm_area ref 
counting and/or free resources on release method, but we cannot do anything 
more in vb2.

> This kind of operation, it seems, should really be done with
> get_user_pages().  Except that it seems that you're not really expecting
> user pages here - it looks like this is an attempt to support memory
> belonging to a different device which has been mapped into the process's
> address space?  That might be a nice thing to try to document here.

Right, get_user_page() is just one special case and it doesn't work with 
memory coming from mmaped device. You are definitely right that we should
better document it.

> If you're worried about the file being closed, it might be better to save
> a reference directly.  But having fake VMAs floating around worries me.

I see, without additional comment this might be confusing, we will try to
document it better.

> Moving on:
> 
> /**
>  * vb2_get_contig_userptr() - lock physically contiguous userspace mapped
> memory
>  * @vaddr:	starting virtual address of the area to be verified
>  * @size:	size of the area
>  * @res_paddr:	will return physical address for the given vaddr
>  * @res_vma:	will return locked copy of struct vm_area for the given
> area
>  *
>  * This function will go through memory area of size @size mapped at @vaddr
> and
>  * verify that the underlying physical pages are contiguous. If they are
>  * contiguous the virtual memory area is locked and a @res_vma is filled
> with
>  * the copy and @res_pa set to the physical address of the buffer.
>  [...]
> 
> Since we've determined that you're expecting this buffer to be in
> somebody's device memory, the loop through the whole thing seems like a
> bit much.  Testing the VMA flags for VM_IO and !VM_NONLINEAR seems like it
> should suffice?  Or am I missing something?

This is the first time I see VM_NONLINEAR, I will need to check how it is
used. The loop was to ensure that memory is really contiguous, because
nothing prevents other (unknown!) drivers to mmap the io memory in 
non-linear way.

> (FWIW, user space could conceivably create a contiguous buffer in
> anonymous memory by using hugepages.  The current videobuf2 code won't
> support that - follow_pfn() will fail.  Probably not going to be an issue
> anytime in the near future, but one never knows...)

Right, this should be put into TODO list.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


