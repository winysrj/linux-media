Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:25786 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753940AbdCFO3s (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 6 Mar 2017 09:29:48 -0500
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
Subject: [PATCH 13/29] drivers, media: convert vb2_vmarea_handler.refcount from atomic_t to refcount_t
Date: Mon,  6 Mar 2017 16:21:00 +0200
Message-Id: <1488810076-3754-14-git-send-email-elena.reshetova@intel.com>
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
 drivers/media/v4l2-core/videobuf2-memops.c | 6 +++---
 include/media/videobuf2-memops.h           | 3 ++-
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-memops.c b/drivers/media/v4l2-core/videobuf2-memops.c
index 1cd322e..4bb8424 100644
--- a/drivers/media/v4l2-core/videobuf2-memops.c
+++ b/drivers/media/v4l2-core/videobuf2-memops.c
@@ -96,10 +96,10 @@ static void vb2_common_vm_open(struct vm_area_struct *vma)
 	struct vb2_vmarea_handler *h = vma->vm_private_data;
 
 	pr_debug("%s: %p, refcount: %d, vma: %08lx-%08lx\n",
-	       __func__, h, atomic_read(h->refcount), vma->vm_start,
+	       __func__, h, refcount_read(h->refcount), vma->vm_start,
 	       vma->vm_end);
 
-	atomic_inc(h->refcount);
+	refcount_inc(h->refcount);
 }
 
 /**
@@ -114,7 +114,7 @@ static void vb2_common_vm_close(struct vm_area_struct *vma)
 	struct vb2_vmarea_handler *h = vma->vm_private_data;
 
 	pr_debug("%s: %p, refcount: %d, vma: %08lx-%08lx\n",
-	       __func__, h, atomic_read(h->refcount), vma->vm_start,
+	       __func__, h, refcount_read(h->refcount), vma->vm_start,
 	       vma->vm_end);
 
 	h->put(h->arg);
diff --git a/include/media/videobuf2-memops.h b/include/media/videobuf2-memops.h
index 36565c7a..a6ed091 100644
--- a/include/media/videobuf2-memops.h
+++ b/include/media/videobuf2-memops.h
@@ -16,6 +16,7 @@
 
 #include <media/videobuf2-v4l2.h>
 #include <linux/mm.h>
+#include <linux/refcount.h>
 
 /**
  * struct vb2_vmarea_handler - common vma refcount tracking handler
@@ -25,7 +26,7 @@
  * @arg:	argument for @put callback
  */
 struct vb2_vmarea_handler {
-	atomic_t		*refcount;
+	refcount_t		*refcount;
 	void			(*put)(void *arg);
 	void			*arg;
 };
-- 
2.7.4
