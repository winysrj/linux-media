Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:36796 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933132AbcJMAZI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Oct 2016 20:25:08 -0400
From: Lorenzo Stoakes <lstoakes@gmail.com>
To: linux-mm@kvack.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Jan Kara <jack@suse.cz>, Hugh Dickins <hughd@google.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@techsingularity.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        adi-buildroot-devel@lists.sourceforge.net,
        ceph-devel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, kvm@vger.kernel.org,
        linux-alpha@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-cris-kernel@axis.com, linux-fbdev@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        linux-mips@linux-mips.org, linux-rdma@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-sh@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org, sparclinux@vger.kernel.org, x86@kernel.org,
        Lorenzo Stoakes <lstoakes@gmail.com>
Subject: [PATCH 03/10] mm: replace get_user_pages_unlocked() write/force parameters with gup_flags
Date: Thu, 13 Oct 2016 01:20:13 +0100
Message-Id: <20161013002020.3062-4-lstoakes@gmail.com>
In-Reply-To: <20161013002020.3062-1-lstoakes@gmail.com>
References: <20161013002020.3062-1-lstoakes@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch removes the write and force parameters from get_user_pages_unlocked()
and replaces them with a gup_flags parameter to make the use of FOLL_FORCE
explicit in callers as use of this flag can result in surprising behaviour (and
hence bugs) within the mm subsystem.

Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
---
 arch/mips/mm/gup.c                 |  2 +-
 arch/s390/mm/gup.c                 |  3 ++-
 arch/sh/mm/gup.c                   |  3 ++-
 arch/sparc/mm/gup.c                |  3 ++-
 arch/x86/mm/gup.c                  |  2 +-
 drivers/media/pci/ivtv/ivtv-udma.c |  4 ++--
 drivers/media/pci/ivtv/ivtv-yuv.c  |  5 +++--
 drivers/scsi/st.c                  |  5 ++---
 drivers/video/fbdev/pvr2fb.c       |  4 ++--
 include/linux/mm.h                 |  2 +-
 mm/gup.c                           | 14 ++++----------
 mm/nommu.c                         | 11 ++---------
 mm/util.c                          |  3 ++-
 net/ceph/pagevec.c                 |  2 +-
 14 files changed, 27 insertions(+), 36 deletions(-)

diff --git a/arch/mips/mm/gup.c b/arch/mips/mm/gup.c
index 42d124f..d8c3c15 100644
--- a/arch/mips/mm/gup.c
+++ b/arch/mips/mm/gup.c
@@ -287,7 +287,7 @@ int get_user_pages_fast(unsigned long start, int nr_pages, int write,
 	pages += nr;
 
 	ret = get_user_pages_unlocked(start, (end - start) >> PAGE_SHIFT,
-				      write, 0, pages);
+				      pages, write ? FOLL_WRITE : 0);
 
 	/* Have to be a bit careful with return values */
 	if (nr > 0) {
diff --git a/arch/s390/mm/gup.c b/arch/s390/mm/gup.c
index adb0c34..18d4107 100644
--- a/arch/s390/mm/gup.c
+++ b/arch/s390/mm/gup.c
@@ -266,7 +266,8 @@ int get_user_pages_fast(unsigned long start, int nr_pages, int write,
 	/* Try to get the remaining pages with get_user_pages */
 	start += nr << PAGE_SHIFT;
 	pages += nr;
-	ret = get_user_pages_unlocked(start, nr_pages - nr, write, 0, pages);
+	ret = get_user_pages_unlocked(start, nr_pages - nr, pages,
+				      write ? FOLL_WRITE : 0);
 	/* Have to be a bit careful with return values */
 	if (nr > 0)
 		ret = (ret < 0) ? nr : ret + nr;
diff --git a/arch/sh/mm/gup.c b/arch/sh/mm/gup.c
index 40fa6c8..063c298 100644
--- a/arch/sh/mm/gup.c
+++ b/arch/sh/mm/gup.c
@@ -258,7 +258,8 @@ int get_user_pages_fast(unsigned long start, int nr_pages, int write,
 		pages += nr;
 
 		ret = get_user_pages_unlocked(start,
-			(end - start) >> PAGE_SHIFT, write, 0, pages);
+			(end - start) >> PAGE_SHIFT, pages,
+			write ? FOLL_WRITE : 0);
 
 		/* Have to be a bit careful with return values */
 		if (nr > 0) {
diff --git a/arch/sparc/mm/gup.c b/arch/sparc/mm/gup.c
index 4e06750..cd0e32b 100644
--- a/arch/sparc/mm/gup.c
+++ b/arch/sparc/mm/gup.c
@@ -238,7 +238,8 @@ int get_user_pages_fast(unsigned long start, int nr_pages, int write,
 		pages += nr;
 
 		ret = get_user_pages_unlocked(start,
-			(end - start) >> PAGE_SHIFT, write, 0, pages);
+			(end - start) >> PAGE_SHIFT, pages,
+			write ? FOLL_WRITE : 0);
 
 		/* Have to be a bit careful with return values */
 		if (nr > 0) {
diff --git a/arch/x86/mm/gup.c b/arch/x86/mm/gup.c
index b8b6a60..0d4fb3e 100644
--- a/arch/x86/mm/gup.c
+++ b/arch/x86/mm/gup.c
@@ -435,7 +435,7 @@ int get_user_pages_fast(unsigned long start, int nr_pages, int write,
 
 		ret = get_user_pages_unlocked(start,
 					      (end - start) >> PAGE_SHIFT,
-					      write, 0, pages);
+					      pages, write ? FOLL_WRITE : 0);
 
 		/* Have to be a bit careful with return values */
 		if (nr > 0) {
diff --git a/drivers/media/pci/ivtv/ivtv-udma.c b/drivers/media/pci/ivtv/ivtv-udma.c
index 4769469..2c9232e 100644
--- a/drivers/media/pci/ivtv/ivtv-udma.c
+++ b/drivers/media/pci/ivtv/ivtv-udma.c
@@ -124,8 +124,8 @@ int ivtv_udma_setup(struct ivtv *itv, unsigned long ivtv_dest_addr,
 	}
 
 	/* Get user pages for DMA Xfer */
-	err = get_user_pages_unlocked(user_dma.uaddr, user_dma.page_count, 0,
-			1, dma->map);
+	err = get_user_pages_unlocked(user_dma.uaddr, user_dma.page_count,
+			dma->map, FOLL_FORCE);
 
 	if (user_dma.page_count != err) {
 		IVTV_DEBUG_WARN("failed to map user pages, returned %d instead of %d\n",
diff --git a/drivers/media/pci/ivtv/ivtv-yuv.c b/drivers/media/pci/ivtv/ivtv-yuv.c
index b094054..f7299d3 100644
--- a/drivers/media/pci/ivtv/ivtv-yuv.c
+++ b/drivers/media/pci/ivtv/ivtv-yuv.c
@@ -76,11 +76,12 @@ static int ivtv_yuv_prep_user_dma(struct ivtv *itv, struct ivtv_user_dma *dma,
 
 	/* Get user pages for DMA Xfer */
 	y_pages = get_user_pages_unlocked(y_dma.uaddr,
-			y_dma.page_count, 0, 1, &dma->map[0]);
+			y_dma.page_count, &dma->map[0], FOLL_FORCE);
 	uv_pages = 0; /* silence gcc. value is set and consumed only if: */
 	if (y_pages == y_dma.page_count) {
 		uv_pages = get_user_pages_unlocked(uv_dma.uaddr,
-				uv_dma.page_count, 0, 1, &dma->map[y_pages]);
+				uv_dma.page_count, &dma->map[y_pages],
+				FOLL_FORCE);
 	}
 
 	if (y_pages != y_dma.page_count || uv_pages != uv_dma.page_count) {
diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 7af5226..618422e 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -4922,9 +4922,8 @@ static int sgl_map_user_pages(struct st_buffer *STbp,
 	res = get_user_pages_unlocked(
 		uaddr,
 		nr_pages,
-		rw == READ,
-		0, /* don't force */
-		pages);
+		pages,
+		rw == READ ? FOLL_WRITE : 0); /* don't force */
 
 	/* Errors and no page mapped should return here */
 	if (res < nr_pages)
diff --git a/drivers/video/fbdev/pvr2fb.c b/drivers/video/fbdev/pvr2fb.c
index 3b1ca44..a2564ab 100644
--- a/drivers/video/fbdev/pvr2fb.c
+++ b/drivers/video/fbdev/pvr2fb.c
@@ -686,8 +686,8 @@ static ssize_t pvr2fb_write(struct fb_info *info, const char *buf,
 	if (!pages)
 		return -ENOMEM;
 
-	ret = get_user_pages_unlocked((unsigned long)buf, nr_pages, WRITE,
-			0, pages);
+	ret = get_user_pages_unlocked((unsigned long)buf, nr_pages, pages,
+			FOLL_WRITE);
 
 	if (ret < nr_pages) {
 		nr_pages = ret;
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 2db98b6..6adc4bc 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1287,7 +1287,7 @@ long __get_user_pages_unlocked(struct task_struct *tsk, struct mm_struct *mm,
 			       unsigned long start, unsigned long nr_pages,
 			       struct page **pages, unsigned int gup_flags);
 long get_user_pages_unlocked(unsigned long start, unsigned long nr_pages,
-		    int write, int force, struct page **pages);
+		    struct page **pages, unsigned int gup_flags);
 int get_user_pages_fast(unsigned long start, int nr_pages, int write,
 			struct page **pages);
 
diff --git a/mm/gup.c b/mm/gup.c
index 3d620dd..cfcb014 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -897,17 +897,10 @@ EXPORT_SYMBOL(__get_user_pages_unlocked);
  * "force" parameter).
  */
 long get_user_pages_unlocked(unsigned long start, unsigned long nr_pages,
-			     int write, int force, struct page **pages)
+			     struct page **pages, unsigned int gup_flags)
 {
-	unsigned int flags = FOLL_TOUCH;
-
-	if (write)
-		flags |= FOLL_WRITE;
-	if (force)
-		flags |= FOLL_FORCE;
-
 	return __get_user_pages_unlocked(current, current->mm, start, nr_pages,
-					 pages, flags);
+					 pages, gup_flags | FOLL_TOUCH);
 }
 EXPORT_SYMBOL(get_user_pages_unlocked);
 
@@ -1525,7 +1518,8 @@ int get_user_pages_fast(unsigned long start, int nr_pages, int write,
 		start += nr << PAGE_SHIFT;
 		pages += nr;
 
-		ret = get_user_pages_unlocked(start, nr_pages - nr, write, 0, pages);
+		ret = get_user_pages_unlocked(start, nr_pages - nr, pages,
+				write ? FOLL_WRITE : 0);
 
 		/* Have to be a bit careful with return values */
 		if (nr > 0) {
diff --git a/mm/nommu.c b/mm/nommu.c
index 925dcc1..7e27add 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -197,17 +197,10 @@ long __get_user_pages_unlocked(struct task_struct *tsk, struct mm_struct *mm,
 EXPORT_SYMBOL(__get_user_pages_unlocked);
 
 long get_user_pages_unlocked(unsigned long start, unsigned long nr_pages,
-			     int write, int force, struct page **pages)
+			     struct page **pages, unsigned int gup_flags)
 {
-	unsigned int flags = 0;
-
-	if (write)
-		flags |= FOLL_WRITE;
-	if (force)
-		flags |= FOLL_FORCE;
-
 	return __get_user_pages_unlocked(current, current->mm, start, nr_pages,
-					 pages, flags);
+					 pages, gup_flags);
 }
 EXPORT_SYMBOL(get_user_pages_unlocked);
 
diff --git a/mm/util.c b/mm/util.c
index 662cddf..4c685bd 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -283,7 +283,8 @@ EXPORT_SYMBOL_GPL(__get_user_pages_fast);
 int __weak get_user_pages_fast(unsigned long start,
 				int nr_pages, int write, struct page **pages)
 {
-	return get_user_pages_unlocked(start, nr_pages, write, 0, pages);
+	return get_user_pages_unlocked(start, nr_pages, pages,
+				       write ? FOLL_WRITE : 0);
 }
 EXPORT_SYMBOL_GPL(get_user_pages_fast);
 
diff --git a/net/ceph/pagevec.c b/net/ceph/pagevec.c
index 00d2601..1a7c9a7 100644
--- a/net/ceph/pagevec.c
+++ b/net/ceph/pagevec.c
@@ -26,7 +26,7 @@ struct page **ceph_get_direct_page_vector(const void __user *data,
 	while (got < num_pages) {
 		rc = get_user_pages_unlocked(
 		    (unsigned long)data + ((unsigned long)got * PAGE_SIZE),
-		    num_pages - got, write_page, 0, pages + got);
+		    num_pages - got, pages + got, write_page ? FOLL_WRITE : 0);
 		if (rc < 0)
 			break;
 		BUG_ON(rc == 0);
-- 
2.10.0

