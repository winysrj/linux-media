Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:29441 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751248AbdCFOY4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
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
Subject: [PATCH 07/29] drivers, md: convert dm_dev_internal.count from atomic_t to refcount_t
Date: Mon,  6 Mar 2017 16:20:54 +0200
Message-Id: <1488810076-3754-8-git-send-email-elena.reshetova@intel.com>
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
 drivers/md/dm-table.c | 6 +++---
 drivers/md/dm.h       | 3 ++-
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 3ad16d9..d2e2741 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -416,15 +416,15 @@ int dm_get_device(struct dm_target *ti, const char *path, fmode_t mode,
 			return r;
 		}
 
-		atomic_set(&dd->count, 0);
+		refcount_set(&dd->count, 1);
 		list_add(&dd->list, &t->devices);
 
 	} else if (dd->dm_dev->mode != (mode | dd->dm_dev->mode)) {
 		r = upgrade_mode(dd, mode, t->md);
 		if (r)
 			return r;
+		refcount_inc(&dd->count);
 	}
-	atomic_inc(&dd->count);
 
 	*result = dd->dm_dev;
 	return 0;
@@ -478,7 +478,7 @@ void dm_put_device(struct dm_target *ti, struct dm_dev *d)
 		       dm_device_name(ti->table->md), d->name);
 		return;
 	}
-	if (atomic_dec_and_test(&dd->count)) {
+	if (refcount_dec_and_test(&dd->count)) {
 		dm_put_table_device(ti->table->md, d);
 		list_del(&dd->list);
 		kfree(dd);
diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index f298b01..63b8142 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -19,6 +19,7 @@
 #include <linux/hdreg.h>
 #include <linux/completion.h>
 #include <linux/kobject.h>
+#include <linux/refcount.h>
 
 #include "dm-stats.h"
 
@@ -38,7 +39,7 @@
  */
 struct dm_dev_internal {
 	struct list_head list;
-	atomic_t count;
+	refcount_t count;
 	struct dm_dev *dm_dev;
 };
 
-- 
2.7.4
