Return-path: <mchehab@pedra>
Received: from tex.lwn.net ([70.33.254.29]:41299 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752715Ab1FIXVF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Jun 2011 19:21:05 -0400
Date: Thu, 9 Jun 2011 17:21:03 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-media@vger.kernel.org
Subject: videobuf2 and VMAs
Message-ID: <20110609172103.18f242b2@bike.lwn.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

I'm finally getting around to trying to really understand videobuf2.  In
the process I've run into something which has thrown me for a bit of a
loop...  

/**
 * vb2_get_vma() - acquire and lock the virtual memory area
 * @vma:	given virtual memory area
 *
 * This function attempts to acquire an area mapped in the userspace for
 * the duration of a hardware operation. The area is "locked" by performing
 * the same set of operation that are done when process calls fork() and
 * memory areas are duplicated.
 *
 * Returns a copy of a virtual memory region on success or NULL.
 */

This function makes a copy of the VMA which is completely outside of the
knowledge of the mm subsystem.  For the life of me, I cannot figure out
why that is a wise or necessary thing to do.  You are not locking the real
VMA in any way.  If you're worried about the underlying pages going away
somehow, this will not save you.  User space can still munmap() the space
whenever it feels like it.

This kind of operation, it seems, should really be done with
get_user_pages().  Except that it seems that you're not really expecting
user pages here - it looks like this is an attempt to support memory
belonging to a different device which has been mapped into the process's
address space?  That might be a nice thing to try to document here.

If you're worried about the file being closed, it might be better to save
a reference directly.  But having fake VMAs floating around worries me.

Moving on:

/**
 * vb2_get_contig_userptr() - lock physically contiguous userspace mapped memory
 * @vaddr:	starting virtual address of the area to be verified
 * @size:	size of the area
 * @res_paddr:	will return physical address for the given vaddr
 * @res_vma:	will return locked copy of struct vm_area for the given area
 *
 * This function will go through memory area of size @size mapped at @vaddr and
 * verify that the underlying physical pages are contiguous. If they are
 * contiguous the virtual memory area is locked and a @res_vma is filled with
 * the copy and @res_pa set to the physical address of the buffer.
 [...]

Since we've determined that you're expecting this buffer to be in
somebody's device memory, the loop through the whole thing seems like a
bit much.  Testing the VMA flags for VM_IO and !VM_NONLINEAR seems like it
should suffice?  Or am I missing something?

(FWIW, user space could conceivably create a contiguous buffer in
anonymous memory by using hugepages.  The current videobuf2 code won't
support that - follow_pfn() will fail.  Probably not going to be an issue
anytime in the near future, but one never knows...)

Thanks,

jon
