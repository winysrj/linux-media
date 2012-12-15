Return-path: <linux-media-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:56712 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586Ab2LOUMi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Dec 2012 15:12:38 -0500
Date: Sat, 15 Dec 2012 20:12:37 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: [PATCH] omap_vout: find_vma() needs ->mmap_sem held
Message-ID: <20121215201237.GW4939@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

	Walking rbtree while it's modified is a Bad Idea(tm); besides,
the result of find_vma() can be freed just as it's getting returned
to caller.  Fortunately, it's easy to fix - just take ->mmap_sem a bit
earlier (and don't bother with find_vma() at all if virtp >= PAGE_OFFSET -
in that case we don't even look at its result).

Cc: stable@vger.kernel.org [2.6.35]
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/drivers/media/platform/omap/omap_vout.c b/drivers/media/platform/omap/omap_vout.c
index 9935040..984512f 100644
--- a/drivers/media/platform/omap/omap_vout.c
+++ b/drivers/media/platform/omap/omap_vout.c
@@ -207,19 +207,21 @@ static u32 omap_vout_uservirt_to_phys(u32 virtp)
 	struct vm_area_struct *vma;
 	struct mm_struct *mm = current->mm;
 
-	vma = find_vma(mm, virtp);
 	/* For kernel direct-mapped memory, take the easy way */
-	if (virtp >= PAGE_OFFSET) {
-		physp = virt_to_phys((void *) virtp);
+	if (virtp >= PAGE_OFFSET)
+		return virt_to_phys((void *) virtp);
+
+	down_read(&current->mm->mmap_sem);
+	vma = find_vma(mm, virtp);
 	} else if (vma && (vma->vm_flags & VM_IO) && vma->vm_pgoff) {
 		/* this will catch, kernel-allocated, mmaped-to-usermode
 		   addresses */
 		physp = (vma->vm_pgoff << PAGE_SHIFT) + (virtp - vma->vm_start);
+		up_read(&current->mm->mmap_sem);
 	} else {
 		/* otherwise, use get_user_pages() for general userland pages */
 		int res, nr_pages = 1;
 		struct page *pages;
-		down_read(&current->mm->mmap_sem);
 
 		res = get_user_pages(current, current->mm, virtp, nr_pages, 1,
 				0, &pages, NULL);
