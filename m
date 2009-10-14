Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout5.samsung.com ([203.254.224.35]:51263 "EHLO
	mailout5.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753167AbZJNHhR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Oct 2009 03:37:17 -0400
Received: from epmmp2 (mailout5.samsung.com [203.254.224.35])
 by mailout1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0KRH00ABXUH2TC@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 14 Oct 2009 16:36:38 +0900 (KST)
Received: from AMDC159 ([106.116.37.153])
 by mmp2.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0KRH00GMUUFJ3F@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 14 Oct 2009 16:36:37 +0900 (KST)
Date: Wed, 14 Oct 2009 09:34:07 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: Global Video Buffers Pool - PMM and UPBuffer reference drivers
 [RFC]
In-reply-to: <20091012160015.GC2480@n2100.arm.linux.org.uk>
To: 'Russell King - ARM Linux' <linux@arm.linux.org.uk>
Cc: linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	kyungmin.park@samsung.com, Tomasz Fujak <t.fujak@samsung.com>,
	Pawel Osciak <p.osciak@samsung.com>,
	Michal Nazarewicz <m.nazarewicz@samsung.com>
Message-id: <000001ca4ca0$b906cf30$2b146d90$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-2
Content-language: pl
Content-transfer-encoding: 7BIT
References: <E4D3F24EA6C9E54F817833EAE0D912AC077151C44B@bssrvexch01.BS.local>
 <20091012160015.GC2480@n2100.arm.linux.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Monday, October 12, 2009 6:00 PM Russell King wrote:

> Below are some brief comments from having looked through the code.  I
> don't intend to suggest that they're anywhere near complete though,
> but are observations I've spotted today.

Thank you for your review!

> On Thu, Oct 01, 2009 at 12:39:29PM +0200, Marek Szyprowski wrote:
> >  arch/arm/mach-s3c6410/Kconfig                 |    1 +
> >  arch/arm/mach-s3c6410/include/mach/pmm-plat.h |   40 +
> >  drivers/Kconfig                               |    3 +
> >  drivers/Makefile                              |    1 +
> >  drivers/s3cmm/Kconfig                         |  142 +++
> >  drivers/s3cmm/Makefile                        |    9 +
> >  drivers/s3cmm/pmm-init.c                      |   75 ++
> >  drivers/s3cmm/pmm.c                           | 1400 +++++++++++++++++++++++++
> >  drivers/s3cmm/upbuffer.c                      |  608 +++++++++++
> >  include/linux/s3c/pmm.h                       |  141 +++
> >  include/linux/s3c/upbuffer.h                  |  131 +++
> >  ipc/shm.c                                     |   24 +-
> >  mm/shmem.c                                    |   55 +-
> 
> Does this have to be s3c specific, or can this be turned into something
> generic?

In our opinion our approach can be generic, at least for UMA systems with
a lot of devices that can work only with memory buffers that are contiguous
in physical memory. We have however no idea where it should be placed in
drivers directory tree, that's why we left it in our custom s3c directories.

[snip]
> > +static int direct_pfn_prepare(struct upbuf *b, struct vm_area_struct *vma)
> > +{
> > +       struct upbuf_private *priv = b->priv;
> > +       unsigned long start, base;
> > +       int page_count, i, res;
> > +       pte_t pte;
> > +
> > +       debug("direct_pfn_prepare\n");
> > +
> > +       if (!(vma->vm_flags & VM_PFNMAP) || !vma->vm_file) {
> > +               return -EINVAL;
> > +       }
> > +
> > +       page_count = priv->page_count;
> > +       BUG_ON(!page_count);
> > +
> > +       debug("Direct PFN mapping found, "
> > +             "using special file reference counter.\n");
> > +
> > +       /* increment vma file use count before hacking with pte map */
> > +       get_file(vma->vm_file);
> 
> I do hope you're not under the impression that getting the file in some
> way protects the pte map?  My understanding is the only thing which
> protects page tables (and VMAs) is vma->vm_mm->mmap_sem.
> 
> If you want to protect against VMAs going away, read-lock it.  If you
> want to modify VMAs, write-lock it.  Also, only a write lock will also
> protect against the page fault handler changing the page tables (since
> it will want to gain a read-lock.)

Good point. In our approach memory buffers can be locked for a long time
and we don't want to lock the whole applications memory management and
address space (vm_mm) for such a long time. That's why we were looking
for alternative way.

We decided to protect the physical memory of the buffer not the vma area
itself. If we can ensure that the physical memory would not be reused by
other application until the driver finishes the multimedia transaction,
everything would be fine. If user application unmap the vma area before
the multimedia transaction finishes, it is its own fault. We don't care
about that, unless it causes security issues with other applications.

This is of course for virtual mappings. What we cannot accept though is
the physical memory (from our PMM allocator) being freed before the
transaction is finished.

In our approach we rely on the fact that PMM uses free-after-release
semantic, which means that the allocated physical memory is freed only
after releasing the file that was used to mmap the particular buffer.
In this case locking the buffer can be simplified to increasing the
reference count of the vm_file. We thought that this is a correct way
of locking underlying memory buffers for that vm area. Now we
understand that this worked only for our custom allocator.

Do you know if there is any other way to lock the particular vm area
without locking the whole memory management of the process (vm_mm)?
In other words, we would like to protect the underlying physical
memory from being freed prematurely (without our consent).

[snip] 
> > +       b->paddr            = priv->page_pa_first + priv->page_offset;
> > +       priv->data.file     = vma->vm_file;
> > +       priv->sync          = direct_pfn_sync;
> > +       priv->release       = direct_pfn_release;
> > +       debug("vma = %p, vma->vm_file = %p\n", (void*)vma, (void*)vma->vm_file);
> > +
> > +       if ((pte & PTE_CACHEABLE) == 0) {
> 
> The big hint here is that there's no L_ prefix.  This is buggy.  There is
> no cacheable bit in a 'pte' anymore - there are memory types, which you
> need to mask out and compare instead.
> 
> Even if you did have access to the hardware page table entry, the contents
> of it is CPU specific, and that's most certainly true of the old 'cacheable'
> bit.
> 
> Moreover, shared file mappings on VIVT processors can have their cache
> status down-graded to uncacheable if the thread maps more than one copy
> of the shared file and faults in the same page multiple times.  That
> shouldn't be a problem here, but it could be if this is the situation
> you first notice how the page is mapped - especially if later on it
> becomes mapped with the cache enabled.

Is there any preferred way to get information on the type of the mapping?
If it is cacheable or not? I just found that accessing these bits directly
was the fastest way. Works on S3CXXXX (ARM11 core) and S5PCXXX (Coretex8
core) just fine.

[snip]
> > +int upbuf_prepare(struct upbuf *buf, unsigned long vaddr, unsigned long size,
> > +                  enum upbuf_flags flags)
> > +{
> > +       struct vm_area_struct *vma;
> > +       struct upbuf_private *priv;
> > +       unsigned int page_va_last;
> > +       void *kernel_vaddr;
> > +       int res;
> > +
> > +       BUG_ON(buf == NULL || current == NULL);git
> > +
> > +       debug("upbuf_prepare: vaddr 0x%08lx, size 0x%ld, flags %d\n",
> > +             vaddr, size, flags);
> > +
> > +
> > +       /* Get the VMA */
> > +       vma = find_extend_vma(current->mm, vaddr);
> 
> Locking?  This modifies a vma, and so needs _write_ locking on the mm's
> mmap_lock.

Okay 

Best regards
--
Marek Szyprowski
Samsung Poland R&D Center


