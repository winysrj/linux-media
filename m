Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:47276 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753150AbdCFOY4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
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
Subject: [PATCH 26/29] drivers, usb: convert dev_data.count from atomic_t to refcount_t
Date: Mon,  6 Mar 2017 16:21:13 +0200
Message-Id: <1488810076-3754-27-git-send-email-elena.reshetova@intel.com>
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
 drivers/usb/gadget/legacy/inode.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/gadget/legacy/inode.c b/drivers/usb/gadget/legacy/inode.c
index 79a2d8f..81d76f3 100644
--- a/drivers/usb/gadget/legacy/inode.c
+++ b/drivers/usb/gadget/legacy/inode.c
@@ -27,6 +27,7 @@
 #include <linux/mmu_context.h>
 #include <linux/aio.h>
 #include <linux/uio.h>
+#include <linux/refcount.h>
 
 #include <linux/device.h>
 #include <linux/moduleparam.h>
@@ -114,7 +115,7 @@ enum ep0_state {
 
 struct dev_data {
 	spinlock_t			lock;
-	atomic_t			count;
+	refcount_t			count;
 	enum ep0_state			state;		/* P: lock */
 	struct usb_gadgetfs_event	event [N_EVENT];
 	unsigned			ev_next;
@@ -150,12 +151,12 @@ struct dev_data {
 
 static inline void get_dev (struct dev_data *data)
 {
-	atomic_inc (&data->count);
+	refcount_inc (&data->count);
 }
 
 static void put_dev (struct dev_data *data)
 {
-	if (likely (!atomic_dec_and_test (&data->count)))
+	if (likely (!refcount_dec_and_test (&data->count)))
 		return;
 	/* needs no more cleanup */
 	BUG_ON (waitqueue_active (&data->wait));
@@ -170,7 +171,7 @@ static struct dev_data *dev_new (void)
 	if (!dev)
 		return NULL;
 	dev->state = STATE_DEV_DISABLED;
-	atomic_set (&dev->count, 1);
+	refcount_set (&dev->count, 1);
 	spin_lock_init (&dev->lock);
 	INIT_LIST_HEAD (&dev->epfiles);
 	init_waitqueue_head (&dev->wait);
-- 
2.7.4
