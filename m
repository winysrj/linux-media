Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:52309 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753887AbdCFPWP (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 6 Mar 2017 10:22:15 -0500
From: Elena Reshetova <elena.reshetova@intel.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org,
        netdev@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-media@vger.kernel.org, devel@linuxdriverproject.org,
        linux-pci@vger.kernel.org, linux-s390@vger.kernel.org,
        fcoe-devel@open-fcoe.org, linux-scsi@vger.kernel.org,
        open-iscsi@googlegroups.com, devel@driverdev.osuosl.org,
        target-devel@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-usb@vger.kernel.org, peterz@infradead.org,
        Elena Reshetova <elena.reshetova@intel.com>,
        Hans Liljestrand <ishkamiel@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        David Windsor <dwindsor@gmail.com>
Subject: [PATCH 03/29] drivers, char: convert vma_data.refcnt from atomic_t to refcount_t
Date: Mon,  6 Mar 2017 16:20:50 +0200
Message-Id: <1488810076-3754-4-git-send-email-elena.reshetova@intel.com>
In-Reply-To: <1488810076-3754-1-git-send-email-elena.reshetova@intel.com>
References: <1488810076-3754-1-git-send-email-elena.reshetova@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

refcount_t type and corresponding API should be
used instead of atomic_t when the variable is used as
a reference counter. This allows to avoid accidental
refcounter overflows that might lead to use-after-free
situations.

Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
Signed-off-by: Hans Liljestrand <ishkamiel@gmail.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: David Windsor <dwindsor@gmail.com>
---
 drivers/char/mspec.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/char/mspec.c b/drivers/char/mspec.c
index a9c2fa3..7b75669 100644
--- a/drivers/char/mspec.c
+++ b/drivers/char/mspec.c
@@ -43,6 +43,7 @@
 #include <linux/string.h>
 #include <linux/slab.h>
 #include <linux/numa.h>
+#include <linux/refcount.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
 #include <linux/atomic.h>
@@ -89,7 +90,7 @@ static int is_sn2;
  * protect in fork case where multiple tasks share the vma_data.
  */
 struct vma_data {
-	atomic_t refcnt;	/* Number of vmas sharing the data. */
+	refcount_t refcnt;	/* Number of vmas sharing the data. */
 	spinlock_t lock;	/* Serialize access to this structure. */
 	int count;		/* Number of pages allocated. */
 	enum mspec_page_type type; /* Type of pages allocated. */
@@ -144,7 +145,7 @@ mspec_open(struct vm_area_struct *vma)
 	struct vma_data *vdata;
 
 	vdata = vma->vm_private_data;
-	atomic_inc(&vdata->refcnt);
+	refcount_inc(&vdata->refcnt);
 }
 
 /*
@@ -162,7 +163,7 @@ mspec_close(struct vm_area_struct *vma)
 
 	vdata = vma->vm_private_data;
 
-	if (!atomic_dec_and_test(&vdata->refcnt))
+	if (!refcount_dec_and_test(&vdata->refcnt))
 		return;
 
 	last_index = (vdata->vm_end - vdata->vm_start) >> PAGE_SHIFT;
@@ -274,7 +275,7 @@ mspec_mmap(struct file *file, struct vm_area_struct *vma,
 	vdata->vm_end = vma->vm_end;
 	vdata->type = type;
 	spin_lock_init(&vdata->lock);
-	atomic_set(&vdata->refcnt, 1);
+	refcount_set(&vdata->refcnt, 1);
 	vma->vm_private_data = vdata;
 
 	vma->vm_flags |= VM_IO | VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP;
-- 
2.7.4
