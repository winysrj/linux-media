Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:10814 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932434AbdCFOfc (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 6 Mar 2017 09:35:32 -0500
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
Subject: [PATCH 18/29] drivers, s390: convert urdev.ref_count from atomic_t to refcount_t
Date: Mon,  6 Mar 2017 16:21:05 +0200
Message-Id: <1488810076-3754-19-git-send-email-elena.reshetova@intel.com>
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
 drivers/s390/char/vmur.c | 8 ++++----
 drivers/s390/char/vmur.h | 4 +++-
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/s390/char/vmur.c b/drivers/s390/char/vmur.c
index 04aceb6..ced8151 100644
--- a/drivers/s390/char/vmur.c
+++ b/drivers/s390/char/vmur.c
@@ -110,7 +110,7 @@ static struct urdev *urdev_alloc(struct ccw_device *cdev)
 	mutex_init(&urd->io_mutex);
 	init_waitqueue_head(&urd->wait);
 	spin_lock_init(&urd->open_lock);
-	atomic_set(&urd->ref_count,  1);
+	refcount_set(&urd->ref_count,  1);
 	urd->cdev = cdev;
 	get_device(&cdev->dev);
 	return urd;
@@ -126,7 +126,7 @@ static void urdev_free(struct urdev *urd)
 
 static void urdev_get(struct urdev *urd)
 {
-	atomic_inc(&urd->ref_count);
+	refcount_inc(&urd->ref_count);
 }
 
 static struct urdev *urdev_get_from_cdev(struct ccw_device *cdev)
@@ -159,7 +159,7 @@ static struct urdev *urdev_get_from_devno(u16 devno)
 
 static void urdev_put(struct urdev *urd)
 {
-	if (atomic_dec_and_test(&urd->ref_count))
+	if (refcount_dec_and_test(&urd->ref_count))
 		urdev_free(urd);
 }
 
@@ -946,7 +946,7 @@ static int ur_set_offline_force(struct ccw_device *cdev, int force)
 		rc = -EBUSY;
 		goto fail_urdev_put;
 	}
-	if (!force && (atomic_read(&urd->ref_count) > 2)) {
+	if (!force && (refcount_read(&urd->ref_count) > 2)) {
 		/* There is still a user of urd (e.g. ur_open) */
 		TRACE("ur_set_offline: BUSY\n");
 		rc = -EBUSY;
diff --git a/drivers/s390/char/vmur.h b/drivers/s390/char/vmur.h
index fa320ad..35ea9d1 100644
--- a/drivers/s390/char/vmur.h
+++ b/drivers/s390/char/vmur.h
@@ -11,6 +11,8 @@
 #ifndef _VMUR_H_
 #define _VMUR_H_
 
+#include <linux/refcount.h>
+
 #define DEV_CLASS_UR_I 0x20 /* diag210 unit record input device class */
 #define DEV_CLASS_UR_O 0x10 /* diag210 unit record output device class */
 /*
@@ -69,7 +71,7 @@ struct urdev {
 	size_t reclen;			/* Record length for *write* CCWs */
 	int class;			/* VM device class */
 	int io_request_rc;		/* return code from I/O request */
-	atomic_t ref_count;		/* reference counter */
+	refcount_t ref_count;		/* reference counter */
 	wait_queue_head_t wait;		/* wait queue to serialize open */
 	int open_flag;			/* "urdev is open" flag */
 	spinlock_t open_lock;		/* serialize critical sections */
-- 
2.7.4
