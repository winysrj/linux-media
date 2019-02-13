Return-Path: <SRS0=D6oO=QU=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64174C4360F
	for <linux-media@archiver.kernel.org>; Wed, 13 Feb 2019 23:05:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E34B222A1
	for <linux-media@archiver.kernel.org>; Wed, 13 Feb 2019 23:05:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405539AbfBMXFb (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 13 Feb 2019 18:05:31 -0500
Received: from mga12.intel.com ([192.55.52.136]:55782 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726323AbfBMXFX (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Feb 2019 18:05:23 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Feb 2019 15:05:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,366,1544515200"; 
   d="scan'208";a="138415583"
Received: from iweiny-desk2.sc.intel.com ([10.3.52.157])
  by orsmga001.jf.intel.com with ESMTP; 13 Feb 2019 15:05:13 -0800
From:   ira.weiny@intel.com
To:     linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
        sparclinux@vger.kernel.org, kvm@vger.kernel.org,
        linux-fpga@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-rdma@vger.kernel.org, linux-media@vger.kernel.org,
        linux-scsi@vger.kernel.org, devel@driverdev.osuosl.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-fbdev@vger.kernel.org, xen-devel@lists.xenproject.org,
        devel@lists.orangefs.org, linux-mm@kvack.org,
        ceph-devel@vger.kernel.org, rds-devel@oss.oracle.com
Cc:     Ira Weiny <ira.weiny@intel.com>,
        John Hubbard <jhubbard@nvidia.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Joerg Roedel <joro@8bytes.org>, Wu Hao <hao.wu@intel.com>,
        Alan Tull <atull@kernel.org>, Moritz Fischer <mdf@kernel.org>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Christian Benvenuti <benve@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Matt Porter <mporter@kernel.crashing.org>,
        Alexandre Bounine <alex.bou9@gmail.com>,
        =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Rob Springer <rspringer@google.com>,
        Todd Poynor <toddpoynor@google.com>,
        Ben Chan <benchan@chromium.org>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Martin Brandenburg <martin@omnibond.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH V2 1/7] mm/gup: Replace get_user_pages_longterm() with FOLL_LONGTERM
Date:   Wed, 13 Feb 2019 15:04:49 -0800
Message-Id: <20190213230455.5605-2-ira.weiny@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190213230455.5605-1-ira.weiny@intel.com>
References: <20190211201643.7599-1-ira.weiny@intel.com>
 <20190213230455.5605-1-ira.weiny@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Ira Weiny <ira.weiny@intel.com>

Rather than have a separate get_user_pages_longterm() call,
introduce FOLL_LONGTERM and change the longterm callers to use
it.

This patch does not change any functionality.

FOLL_LONGTERM can only be supported with get_user_pages() as it
requires vmas to determine if DAX is in use.

Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 drivers/infiniband/core/umem.c             |   5 +-
 drivers/infiniband/hw/qib/qib_user_pages.c |   8 +-
 drivers/infiniband/hw/usnic/usnic_uiom.c   |   9 +-
 drivers/media/v4l2-core/videobuf-dma-sg.c  |   6 +-
 drivers/vfio/vfio_iommu_type1.c            |   3 +-
 include/linux/mm.h                         |  13 +-
 mm/gup.c                                   | 138 ++++++++++++---------
 mm/gup_benchmark.c                         |   5 +-
 8 files changed, 101 insertions(+), 86 deletions(-)

diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
index b69d3efa8712..120a40df91b4 100644
--- a/drivers/infiniband/core/umem.c
+++ b/drivers/infiniband/core/umem.c
@@ -185,10 +185,11 @@ struct ib_umem *ib_umem_get(struct ib_udata *udata, unsigned long addr,
 
 	while (npages) {
 		down_read(&mm->mmap_sem);
-		ret = get_user_pages_longterm(cur_base,
+		ret = get_user_pages(cur_base,
 				     min_t(unsigned long, npages,
 					   PAGE_SIZE / sizeof (struct page *)),
-				     gup_flags, page_list, vma_list);
+				     gup_flags | FOLL_LONGTERM,
+				     page_list, vma_list);
 		if (ret < 0) {
 			up_read(&mm->mmap_sem);
 			goto umem_release;
diff --git a/drivers/infiniband/hw/qib/qib_user_pages.c b/drivers/infiniband/hw/qib/qib_user_pages.c
index ef8bcf366ddc..1b9368261035 100644
--- a/drivers/infiniband/hw/qib/qib_user_pages.c
+++ b/drivers/infiniband/hw/qib/qib_user_pages.c
@@ -114,10 +114,10 @@ int qib_get_user_pages(unsigned long start_page, size_t num_pages,
 
 	down_read(&current->mm->mmap_sem);
 	for (got = 0; got < num_pages; got += ret) {
-		ret = get_user_pages_longterm(start_page + got * PAGE_SIZE,
-					      num_pages - got,
-					      FOLL_WRITE | FOLL_FORCE,
-					      p + got, NULL);
+		ret = get_user_pages(start_page + got * PAGE_SIZE,
+				     num_pages - got,
+				     FOLL_LONGTERM | FOLL_WRITE | FOLL_FORCE,
+				     p + got, NULL);
 		if (ret < 0) {
 			up_read(&current->mm->mmap_sem);
 			goto bail_release;
diff --git a/drivers/infiniband/hw/usnic/usnic_uiom.c b/drivers/infiniband/hw/usnic/usnic_uiom.c
index 06862a6af185..1d9a182ac163 100644
--- a/drivers/infiniband/hw/usnic/usnic_uiom.c
+++ b/drivers/infiniband/hw/usnic/usnic_uiom.c
@@ -143,10 +143,11 @@ static int usnic_uiom_get_pages(unsigned long addr, size_t size, int writable,
 	ret = 0;
 
 	while (npages) {
-		ret = get_user_pages_longterm(cur_base,
-					min_t(unsigned long, npages,
-					PAGE_SIZE / sizeof(struct page *)),
-					gup_flags, page_list, NULL);
+		ret = get_user_pages(cur_base,
+				     min_t(unsigned long, npages,
+				     PAGE_SIZE / sizeof(struct page *)),
+				     gup_flags | FOLL_LONGTERM,
+				     page_list, NULL);
 
 		if (ret < 0)
 			goto out;
diff --git a/drivers/media/v4l2-core/videobuf-dma-sg.c b/drivers/media/v4l2-core/videobuf-dma-sg.c
index 08929c087e27..870a2a526e0b 100644
--- a/drivers/media/v4l2-core/videobuf-dma-sg.c
+++ b/drivers/media/v4l2-core/videobuf-dma-sg.c
@@ -186,12 +186,12 @@ static int videobuf_dma_init_user_locked(struct videobuf_dmabuf *dma,
 	dprintk(1, "init user [0x%lx+0x%lx => %d pages]\n",
 		data, size, dma->nr_pages);
 
-	err = get_user_pages_longterm(data & PAGE_MASK, dma->nr_pages,
-			     flags, dma->pages, NULL);
+	err = get_user_pages(data & PAGE_MASK, dma->nr_pages,
+			     flags | FOLL_LONGTERM, dma->pages, NULL);
 
 	if (err != dma->nr_pages) {
 		dma->nr_pages = (err >= 0) ? err : 0;
-		dprintk(1, "get_user_pages_longterm: err=%d [%d]\n", err,
+		dprintk(1, "get_user_pages: err=%d [%d]\n", err,
 			dma->nr_pages);
 		return err < 0 ? err : -EINVAL;
 	}
diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 73652e21efec..1500bd0bb6da 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -351,7 +351,8 @@ static int vaddr_get_pfn(struct mm_struct *mm, unsigned long vaddr,
 
 	down_read(&mm->mmap_sem);
 	if (mm == current->mm) {
-		ret = get_user_pages_longterm(vaddr, 1, flags, page, vmas);
+		ret = get_user_pages(vaddr, 1, flags | FOLL_LONGTERM, page,
+				     vmas);
 	} else {
 		ret = get_user_pages_remote(NULL, mm, vaddr, 1, flags, page,
 					    vmas, NULL);
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 80bb6408fe73..05a105d9d4c3 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1536,18 +1536,6 @@ long get_user_pages_locked(unsigned long start, unsigned long nr_pages,
 		    unsigned int gup_flags, struct page **pages, int *locked);
 long get_user_pages_unlocked(unsigned long start, unsigned long nr_pages,
 		    struct page **pages, unsigned int gup_flags);
-#ifdef CONFIG_FS_DAX
-long get_user_pages_longterm(unsigned long start, unsigned long nr_pages,
-			    unsigned int gup_flags, struct page **pages,
-			    struct vm_area_struct **vmas);
-#else
-static inline long get_user_pages_longterm(unsigned long start,
-		unsigned long nr_pages, unsigned int gup_flags,
-		struct page **pages, struct vm_area_struct **vmas)
-{
-	return get_user_pages(start, nr_pages, gup_flags, pages, vmas);
-}
-#endif /* CONFIG_FS_DAX */
 
 int get_user_pages_fast(unsigned long start, int nr_pages, int write,
 			struct page **pages);
@@ -2615,6 +2603,7 @@ struct page *follow_page(struct vm_area_struct *vma, unsigned long address,
 #define FOLL_REMOTE	0x2000	/* we are working on non-current tsk/mm */
 #define FOLL_COW	0x4000	/* internal GUP flag */
 #define FOLL_ANON	0x8000	/* don't do file mappings */
+#define FOLL_LONGTERM	0x10000	/* mapping is intended for a long term pin */
 
 static inline int vm_fault_to_errno(vm_fault_t vm_fault, int foll_flags)
 {
diff --git a/mm/gup.c b/mm/gup.c
index b63e88eca31b..ee96eaff118c 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -1109,87 +1109,109 @@ long get_user_pages_remote(struct task_struct *tsk, struct mm_struct *mm,
 }
 EXPORT_SYMBOL(get_user_pages_remote);
 
-/*
- * This is the same as get_user_pages_remote(), just with a
- * less-flexible calling convention where we assume that the task
- * and mm being operated on are the current task's and don't allow
- * passing of a locked parameter.  We also obviously don't pass
- * FOLL_REMOTE in here.
- */
-long get_user_pages(unsigned long start, unsigned long nr_pages,
-		unsigned int gup_flags, struct page **pages,
-		struct vm_area_struct **vmas)
-{
-	return __get_user_pages_locked(current, current->mm, start, nr_pages,
-				       pages, vmas, NULL,
-				       gup_flags | FOLL_TOUCH);
-}
-EXPORT_SYMBOL(get_user_pages);
-
 #ifdef CONFIG_FS_DAX
 /*
- * This is the same as get_user_pages() in that it assumes we are
- * operating on the current task's mm, but it goes further to validate
- * that the vmas associated with the address range are suitable for
- * longterm elevated page reference counts. For example, filesystem-dax
- * mappings are subject to the lifetime enforced by the filesystem and
- * we need guarantees that longterm users like RDMA and V4L2 only
- * establish mappings that have a kernel enforced revocation mechanism.
+ * __gup_longterm_locked() is a wrapper for __get_uer_pages_locked which
+ * allows us to process the FOLL_LONGTERM flag if present.
+ *
+ * __gup_longterm_locked() validates that the vmas associated with the address
+ * range are suitable for longterm elevated page reference counts. For example,
+ * filesystem-dax mappings are subject to the lifetime enforced by the
+ * filesystem and we need guarantees that longterm users like RDMA and V4L2
+ * only establish mappings that have a kernel enforced revocation mechanism.
  *
  * "longterm" == userspace controlled elevated page count lifetime.
  * Contrast this to iov_iter_get_pages() usages which are transient.
  */
-long get_user_pages_longterm(unsigned long start, unsigned long nr_pages,
-		unsigned int gup_flags, struct page **pages,
-		struct vm_area_struct **vmas_arg)
+static __always_inline long __gup_longterm_locked(struct task_struct *tsk,
+						  struct mm_struct *mm,
+						  unsigned long start,
+						  unsigned long nr_pages,
+						  struct page **pages,
+						  struct vm_area_struct **vmas,
+						  unsigned int flags)
 {
-	struct vm_area_struct **vmas = vmas_arg;
+	struct vm_area_struct **vmas_tmp = vmas;
 	struct vm_area_struct *vma_prev = NULL;
 	long rc, i;
 
-	if (!pages)
-		return -EINVAL;
-
-	if (!vmas) {
-		vmas = kcalloc(nr_pages, sizeof(struct vm_area_struct *),
-			       GFP_KERNEL);
-		if (!vmas)
-			return -ENOMEM;
+	if (flags & FOLL_LONGTERM) {
+		if (!pages)
+			return -EINVAL;
+
+		if (!vmas_tmp) {
+			vmas_tmp = kcalloc(nr_pages,
+					   sizeof(struct vm_area_struct *),
+					   GFP_KERNEL);
+			if (!vmas_tmp)
+				return -ENOMEM;
+		}
 	}
 
-	rc = get_user_pages(start, nr_pages, gup_flags, pages, vmas);
+	rc = __get_user_pages_locked(tsk, mm, start, nr_pages, pages,
+				     vmas_tmp, NULL, flags);
 
-	for (i = 0; i < rc; i++) {
-		struct vm_area_struct *vma = vmas[i];
+	if (flags & FOLL_LONGTERM) {
+		for (i = 0; i < rc; i++) {
+			struct vm_area_struct *vma = vmas_tmp[i];
 
-		if (vma == vma_prev)
-			continue;
+			if (vma == vma_prev)
+				continue;
 
-		vma_prev = vma;
+			vma_prev = vma;
 
-		if (vma_is_fsdax(vma))
-			break;
-	}
+			if (vma_is_fsdax(vma))
+				break;
+		}
 
-	/*
-	 * Either get_user_pages() failed, or the vma validation
-	 * succeeded, in either case we don't need to put_page() before
-	 * returning.
-	 */
-	if (i >= rc)
-		goto out;
+		/*
+		 * Either get_user_pages() failed, or the vma validation
+		 * succeeded, in either case we don't need to put_page() before
+		 * returning.
+		 */
+		if (i >= rc)
+			goto out;
 
-	for (i = 0; i < rc; i++)
-		put_page(pages[i]);
-	rc = -EOPNOTSUPP;
+		for (i = 0; i < rc; i++)
+			put_page(pages[i]);
+		rc = -EOPNOTSUPP;
 out:
-	if (vmas != vmas_arg)
-		kfree(vmas);
+		if (vmas_tmp != vmas)
+			kfree(vmas_tmp);
+	}
+
 	return rc;
 }
-EXPORT_SYMBOL(get_user_pages_longterm);
+#else /* !CONFIG_FS_DAX */
+static __always_inline long __gup_longterm_locked(struct task_struct *tsk,
+						  struct mm_struct *mm,
+						  unsigned long start,
+						  unsigned long nr_pages,
+						  struct page **pages,
+						  struct vm_area_struct **vmas,
+						  unsigned int flags)
+{
+	return __get_user_pages_locked(tsk, mm, start, nr_pages, pages, vmas,
+				       NULL, flags);
+}
 #endif /* CONFIG_FS_DAX */
 
+/*
+ * This is the same as get_user_pages_remote(), just with a
+ * less-flexible calling convention where we assume that the task
+ * and mm being operated on are the current task's and don't allow
+ * passing of a locked parameter.  We also obviously don't pass
+ * FOLL_REMOTE in here.
+ */
+long get_user_pages(unsigned long start, unsigned long nr_pages,
+		unsigned int gup_flags, struct page **pages,
+		struct vm_area_struct **vmas)
+{
+	return __gup_longterm_locked(current, current->mm, start, nr_pages,
+				     pages, vmas, gup_flags | FOLL_TOUCH);
+}
+EXPORT_SYMBOL(get_user_pages);
+
 /**
  * populate_vma_page_range() -  populate a range of pages in the vma.
  * @vma:   target vma
diff --git a/mm/gup_benchmark.c b/mm/gup_benchmark.c
index 5b42d3d4b60a..c898e2e0d1e4 100644
--- a/mm/gup_benchmark.c
+++ b/mm/gup_benchmark.c
@@ -54,8 +54,9 @@ static int __gup_benchmark_ioctl(unsigned int cmd,
 						 pages + i);
 			break;
 		case GUP_LONGTERM_BENCHMARK:
-			nr = get_user_pages_longterm(addr, nr, gup->flags & 1,
-						     pages + i, NULL);
+			nr = get_user_pages(addr, nr,
+					    (gup->flags & 1) | FOLL_LONGTERM,
+					    pages + i, NULL);
 			break;
 		case GUP_BENCHMARK:
 			nr = get_user_pages(addr, nr, gup->flags & 1, pages + i,
-- 
2.20.1

