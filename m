Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:35724 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753159AbdCFOY5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 6 Mar 2017 09:24:57 -0500
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
Subject: [PATCH 04/29] drivers, connector: convert cn_callback_entry.refcnt from atomic_t to refcount_t
Date: Mon,  6 Mar 2017 16:20:51 +0200
Message-Id: <1488810076-3754-5-git-send-email-elena.reshetova@intel.com>
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
 drivers/connector/cn_queue.c  | 4 ++--
 drivers/connector/connector.c | 2 +-
 include/linux/connector.h     | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/connector/cn_queue.c b/drivers/connector/cn_queue.c
index 1f8bf05..9c54fdf 100644
--- a/drivers/connector/cn_queue.c
+++ b/drivers/connector/cn_queue.c
@@ -45,7 +45,7 @@ cn_queue_alloc_callback_entry(struct cn_queue_dev *dev, const char *name,
 		return NULL;
 	}
 
-	atomic_set(&cbq->refcnt, 1);
+	refcount_set(&cbq->refcnt, 1);
 
 	atomic_inc(&dev->refcnt);
 	cbq->pdev = dev;
@@ -58,7 +58,7 @@ cn_queue_alloc_callback_entry(struct cn_queue_dev *dev, const char *name,
 
 void cn_queue_release_callback(struct cn_callback_entry *cbq)
 {
-	if (!atomic_dec_and_test(&cbq->refcnt))
+	if (!refcount_dec_and_test(&cbq->refcnt))
 		return;
 
 	atomic_dec(&cbq->pdev->refcnt);
diff --git a/drivers/connector/connector.c b/drivers/connector/connector.c
index 25693b0..8615594b 100644
--- a/drivers/connector/connector.c
+++ b/drivers/connector/connector.c
@@ -157,7 +157,7 @@ static int cn_call_callback(struct sk_buff *skb)
 	spin_lock_bh(&dev->cbdev->queue_lock);
 	list_for_each_entry(i, &dev->cbdev->queue_list, callback_entry) {
 		if (cn_cb_equal(&i->id.id, &msg->id)) {
-			atomic_inc(&i->refcnt);
+			refcount_inc(&i->refcnt);
 			cbq = i;
 			break;
 		}
diff --git a/include/linux/connector.h b/include/linux/connector.h
index f8fe863..032102b 100644
--- a/include/linux/connector.h
+++ b/include/linux/connector.h
@@ -22,7 +22,7 @@
 #define __CONNECTOR_H
 
 
-#include <linux/atomic.h>
+#include <linux/refcount.h>
 
 #include <linux/list.h>
 #include <linux/workqueue.h>
@@ -49,7 +49,7 @@ struct cn_callback_id {
 
 struct cn_callback_entry {
 	struct list_head callback_entry;
-	atomic_t refcnt;
+	refcount_t refcnt;
 	struct cn_queue_dev *pdev;
 
 	struct cn_callback_id id;
-- 
2.7.4
