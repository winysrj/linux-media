Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:47292 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752935AbdCFOY4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
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
Subject: [PATCH 25/29] drivers, usb: convert ffs_data.ref from atomic_t to refcount_t
Date: Mon,  6 Mar 2017 16:21:12 +0200
Message-Id: <1488810076-3754-26-git-send-email-elena.reshetova@intel.com>
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
 drivers/usb/gadget/function/f_fs.c | 8 ++++----
 drivers/usb/gadget/function/u_fs.h | 3 ++-
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index 87fccf6..3cdeb91 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -1570,14 +1570,14 @@ static void ffs_data_get(struct ffs_data *ffs)
 {
 	ENTER();
 
-	atomic_inc(&ffs->ref);
+	refcount_inc(&ffs->ref);
 }
 
 static void ffs_data_opened(struct ffs_data *ffs)
 {
 	ENTER();
 
-	atomic_inc(&ffs->ref);
+	refcount_inc(&ffs->ref);
 	if (atomic_add_return(1, &ffs->opened) == 1 &&
 			ffs->state == FFS_DEACTIVATED) {
 		ffs->state = FFS_CLOSING;
@@ -1589,7 +1589,7 @@ static void ffs_data_put(struct ffs_data *ffs)
 {
 	ENTER();
 
-	if (unlikely(atomic_dec_and_test(&ffs->ref))) {
+	if (unlikely(refcount_dec_and_test(&ffs->ref))) {
 		pr_info("%s(): freeing\n", __func__);
 		ffs_data_clear(ffs);
 		BUG_ON(waitqueue_active(&ffs->ev.waitq) ||
@@ -1634,7 +1634,7 @@ static struct ffs_data *ffs_data_new(void)
 
 	ENTER();
 
-	atomic_set(&ffs->ref, 1);
+	refcount_set(&ffs->ref, 1);
 	atomic_set(&ffs->opened, 0);
 	ffs->state = FFS_READ_DESCRIPTORS;
 	mutex_init(&ffs->mutex);
diff --git a/drivers/usb/gadget/function/u_fs.h b/drivers/usb/gadget/function/u_fs.h
index 4b69694..abfca48 100644
--- a/drivers/usb/gadget/function/u_fs.h
+++ b/drivers/usb/gadget/function/u_fs.h
@@ -20,6 +20,7 @@
 #include <linux/list.h>
 #include <linux/mutex.h>
 #include <linux/workqueue.h>
+#include <linux/refcount.h>
 
 #ifdef VERBOSE_DEBUG
 #ifndef pr_vdebug
@@ -177,7 +178,7 @@ struct ffs_data {
 	struct completion		ep0req_completion;	/* P: mutex */
 
 	/* reference counter */
-	atomic_t			ref;
+	refcount_t			ref;
 	/* how many files are opened (EP0 and others) */
 	atomic_t			opened;
 
-- 
2.7.4
