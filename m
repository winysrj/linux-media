Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w2.samsung.com ([211.189.100.11]:57741 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbaD1XvL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Apr 2014 19:51:11 -0400
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by mailout1.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N4R009PTM99EB70@mailout1.w2.samsung.com> for
 linux-media@vger.kernel.org; Mon, 28 Apr 2014 19:51:09 -0400 (EDT)
Date: Mon, 28 Apr 2014 16:51:07 -0700
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: LMML <linux-media@vger.kernel.org>
Subject: Fw: +
 media-videobuf2-dma-sg-call-find_vma-with-the-mmap_sem-held.patch added to -mm
 tree
Message-id: <20140428165107.3866fb6b.m.chehab@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Could you please take a look at this patch? I remember you had to revert a
VB2 patch from Al Viro, as it caused some regressions. Not sure if this one
is similar to the one that was reverted.

Thanks,
Mauro

Forwarded message:

Date: Mon, 28 Apr 2014 15:04:06 -0700
From: akpm@linux-foundation.org
To: mm-commits@vger.kernel.org, pawel@osciak.com, m.szyprowski@samsung.com, m.chehab@samsung.com, kyungmin.park@samsung.com, davidlohr@hp.com
Subject: + media-videobuf2-dma-sg-call-find_vma-with-the-mmap_sem-held.patch added to -mm tree


Subject: + media-videobuf2-dma-sg-call-find_vma-with-the-mmap_sem-held.patch added to -mm tree
To: davidlohr@hp.com,kyungmin.park@samsung.com,m.chehab@samsung.com,m.szyprowski@samsung.com,pawel@osciak.com
From: akpm@linux-foundation.org
Date: Mon, 28 Apr 2014 15:04:06 -0700


The patch titled
     Subject: drivers/media/v4l2-core/videobuf2-dma-sg.c: call find_vma with the mmap_sem held
has been added to the -mm tree.  Its filename is
     media-videobuf2-dma-sg-call-find_vma-with-the-mmap_sem-held.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/media-videobuf2-dma-sg-call-find_vma-with-the-mmap_sem-held.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/media-videobuf2-dma-sg-call-find_vma-with-the-mmap_sem-held.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Davidlohr Bueso <davidlohr@hp.com>
Subject: drivers/media/v4l2-core/videobuf2-dma-sg.c: call find_vma with the mmap_sem held

Performing vma lookups without taking the mm->mmap_sem is asking for
trouble.  While doing the search, the vma in question can be modified or
even removed before returning to the caller.  Take the lock in order to
avoid races while iterating through the vmacache and/or rbtree.

Also do some very minor cleanup changes.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Cc: Pawel Osciak <pawel@osciak.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/v4l2-core/videobuf2-dma-sg.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff -puN drivers/media/v4l2-core/videobuf2-dma-sg.c~media-videobuf2-dma-sg-call-find_vma-with-the-mmap_sem-held drivers/media/v4l2-core/videobuf2-dma-sg.c
--- a/drivers/media/v4l2-core/videobuf2-dma-sg.c~media-videobuf2-dma-sg-call-find_vma-with-the-mmap_sem-held
+++ a/drivers/media/v4l2-core/videobuf2-dma-sg.c
@@ -168,8 +168,9 @@ static void *vb2_dma_sg_get_userptr(void
 	unsigned long first, last;
 	int num_pages_from_user;
 	struct vm_area_struct *vma;
+	struct mm_struct *mm = current->mm;
 
-	buf = kzalloc(sizeof *buf, GFP_KERNEL);
+	buf = kzalloc(sizeof(*buf), GFP_KERNEL);
 	if (!buf)
 		return NULL;
 
@@ -178,7 +179,7 @@ static void *vb2_dma_sg_get_userptr(void
 	buf->offset = vaddr & ~PAGE_MASK;
 	buf->size = size;
 
-	first = (vaddr           & PAGE_MASK) >> PAGE_SHIFT;
+	first = (vaddr & PAGE_MASK) >> PAGE_SHIFT;
 	last  = ((vaddr + size - 1) & PAGE_MASK) >> PAGE_SHIFT;
 	buf->num_pages = last - first + 1;
 
@@ -187,7 +188,8 @@ static void *vb2_dma_sg_get_userptr(void
 	if (!buf->pages)
 		goto userptr_fail_alloc_pages;
 
-	vma = find_vma(current->mm, vaddr);
+	down_write(&mm->mmap_sem);
+	vma = find_vma(mm, vaddr);
 	if (!vma) {
 		dprintk(1, "no vma for address %lu\n", vaddr);
 		goto userptr_fail_find_vma;
@@ -218,7 +220,7 @@ static void *vb2_dma_sg_get_userptr(void
 			buf->pages[num_pages_from_user] = pfn_to_page(pfn);
 		}
 	} else
-		num_pages_from_user = get_user_pages(current, current->mm,
+		num_pages_from_user = get_user_pages(current, mm,
 					     vaddr & PAGE_MASK,
 					     buf->num_pages,
 					     write,
@@ -233,6 +235,7 @@ static void *vb2_dma_sg_get_userptr(void
 			buf->num_pages, buf->offset, size, 0))
 		goto userptr_fail_alloc_table_from_pages;
 
+	up_write(&mm->mmap_sem);
 	return buf;
 
 userptr_fail_alloc_table_from_pages:
@@ -244,6 +247,7 @@ userptr_fail_get_user_pages:
 			put_page(buf->pages[num_pages_from_user]);
 	vb2_put_vma(buf->vma);
 userptr_fail_find_vma:
+	up_write(&mm->mmap_sem);
 	kfree(buf->pages);
 userptr_fail_alloc_pages:
 	kfree(buf);
_

Patches currently in -mm which might be from davidlohr@hp.com are

mmvmacache-add-debug-data.patch
mmvmacache-optimize-overflow-system-wide-flushing.patch
mm-pass-vm_bug_on-reason-to-dump_page.patch
mm-pass-vm_bug_on-reason-to-dump_page-fix.patch
hugetlb-prep_compound_gigantic_page-drop-__init-marker.patch
hugetlb-add-hstate_is_gigantic.patch
hugetlb-update_and_free_page-dont-clear-pg_reserved-bit.patch
hugetlb-move-helpers-up-in-the-file.patch
hugetlb-add-support-for-gigantic-page-allocation-at-runtime.patch
m68k-call-find_vma-with-the-mmap_sem-held-in-sys_cacheflush.patch
mips-call-find_vma-with-the-mmap_sem-held.patch
arc-call-find_vma-with-the-mmap_sem-held.patch
arc-call-find_vma-with-the-mmap_sem-held-fix.patch
drm-exynos-call-find_vma-with-the-mmap_sem-held.patch
media-videobuf2-dma-sg-call-find_vma-with-the-mmap_sem-held.patch
ipc-constify-ipc_ops.patch
ipc-shmc-check-for-ulong-overflows-in-shmat.patch
ipc-shmc-check-for-overflows-of-shm_tot.patch
ipc-shmc-check-for-integer-overflow-during-shmget.patch
ipc-shmc-increase-the-defaults-for-shmall-shmmax.patch
blackfin-ptrace-call-find_vma-with-the-mmap_sem-held.patch



-- 

Cheers,
Mauro
