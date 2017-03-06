Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:47968 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752947AbdCFOY4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
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
Subject: [PATCH 09/29] drivers, md: convert table_device.count from atomic_t to refcount_t
Date: Mon,  6 Mar 2017 16:20:56 +0200
Message-Id: <1488810076-3754-10-git-send-email-elena.reshetova@intel.com>
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
 drivers/md/dm.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 9f37d7f..cba91c3 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -21,6 +21,7 @@
 #include <linux/delay.h>
 #include <linux/wait.h>
 #include <linux/pr.h>
+#include <linux/refcount.h>
 
 #define DM_MSG_PREFIX "core"
 
@@ -96,7 +97,7 @@ struct dm_md_mempools {
 
 struct table_device {
 	struct list_head list;
-	atomic_t count;
+	refcount_t count;
 	struct dm_dev dm_dev;
 };
 
@@ -680,10 +681,11 @@ int dm_get_table_device(struct mapped_device *md, dev_t dev, fmode_t mode,
 
 		format_dev_t(td->dm_dev.name, dev);
 
-		atomic_set(&td->count, 0);
+		refcount_set(&td->count, 1);
 		list_add(&td->list, &md->table_devices);
+	} else {
+		refcount_inc(&td->count);
 	}
-	atomic_inc(&td->count);
 	mutex_unlock(&md->table_devices_lock);
 
 	*result = &td->dm_dev;
@@ -696,7 +698,7 @@ void dm_put_table_device(struct mapped_device *md, struct dm_dev *d)
 	struct table_device *td = container_of(d, struct table_device, dm_dev);
 
 	mutex_lock(&md->table_devices_lock);
-	if (atomic_dec_and_test(&td->count)) {
+	if (refcount_dec_and_test(&td->count)) {
 		close_table_device(td, md);
 		list_del(&td->list);
 		kfree(td);
@@ -713,7 +715,7 @@ static void free_table_devices(struct list_head *devices)
 		struct table_device *td = list_entry(tmp, struct table_device, list);
 
 		DMWARN("dm_destroy: %s still exists with %d references",
-		       td->dm_dev.name, atomic_read(&td->count));
+		       td->dm_dev.name, refcount_read(&td->count));
 		kfree(td);
 	}
 }
-- 
2.7.4
