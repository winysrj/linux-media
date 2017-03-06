Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:54160 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753162AbdCFOY4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 6 Mar 2017 09:24:56 -0500
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
Subject: [PATCH 29/29] drivers, xen: convert grant_map.users from atomic_t to refcount_t
Date: Mon,  6 Mar 2017 16:21:16 +0200
Message-Id: <1488810076-3754-30-git-send-email-elena.reshetova@intel.com>
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
 drivers/xen/gntdev.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
index 2ef2b61..b183cb2 100644
--- a/drivers/xen/gntdev.c
+++ b/drivers/xen/gntdev.c
@@ -35,6 +35,7 @@
 #include <linux/spinlock.h>
 #include <linux/slab.h>
 #include <linux/highmem.h>
+#include <linux/refcount.h>
 
 #include <xen/xen.h>
 #include <xen/grant_table.h>
@@ -85,7 +86,7 @@ struct grant_map {
 	int index;
 	int count;
 	int flags;
-	atomic_t users;
+	refcount_t users;
 	struct unmap_notify notify;
 	struct ioctl_gntdev_grant_ref *grants;
 	struct gnttab_map_grant_ref   *map_ops;
@@ -165,7 +166,7 @@ static struct grant_map *gntdev_alloc_map(struct gntdev_priv *priv, int count)
 
 	add->index = 0;
 	add->count = count;
-	atomic_set(&add->users, 1);
+	refcount_set(&add->users, 1);
 
 	return add;
 
@@ -211,7 +212,7 @@ static void gntdev_put_map(struct gntdev_priv *priv, struct grant_map *map)
 	if (!map)
 		return;
 
-	if (!atomic_dec_and_test(&map->users))
+	if (!refcount_dec_and_test(&map->users))
 		return;
 
 	atomic_sub(map->count, &pages_mapped);
@@ -399,7 +400,7 @@ static void gntdev_vma_open(struct vm_area_struct *vma)
 	struct grant_map *map = vma->vm_private_data;
 
 	pr_debug("gntdev_vma_open %p\n", vma);
-	atomic_inc(&map->users);
+	refcount_inc(&map->users);
 }
 
 static void gntdev_vma_close(struct vm_area_struct *vma)
@@ -1003,7 +1004,7 @@ static int gntdev_mmap(struct file *flip, struct vm_area_struct *vma)
 		goto unlock_out;
 	}
 
-	atomic_inc(&map->users);
+	refcount_inc(&map->users);
 
 	vma->vm_ops = &gntdev_vmops;
 
-- 
2.7.4
