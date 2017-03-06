Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:37943 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752768AbdCFOZj (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 6 Mar 2017 09:25:39 -0500
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
Subject: [PATCH 08/29] drivers, md: convert mddev.active from atomic_t to refcount_t
Date: Mon,  6 Mar 2017 16:20:55 +0200
Message-Id: <1488810076-3754-9-git-send-email-elena.reshetova@intel.com>
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
 drivers/md/md.c | 6 +++---
 drivers/md/md.h | 3 ++-
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 985374f..94c8ebf 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -449,7 +449,7 @@ EXPORT_SYMBOL(md_unplug);
 
 static inline struct mddev *mddev_get(struct mddev *mddev)
 {
-	atomic_inc(&mddev->active);
+	refcount_inc(&mddev->active);
 	return mddev;
 }
 
@@ -459,7 +459,7 @@ static void mddev_put(struct mddev *mddev)
 {
 	struct bio_set *bs = NULL;
 
-	if (!atomic_dec_and_lock(&mddev->active, &all_mddevs_lock))
+	if (!refcount_dec_and_lock(&mddev->active, &all_mddevs_lock))
 		return;
 	if (!mddev->raid_disks && list_empty(&mddev->disks) &&
 	    mddev->ctime == 0 && !mddev->hold_active) {
@@ -495,7 +495,7 @@ void mddev_init(struct mddev *mddev)
 	INIT_LIST_HEAD(&mddev->all_mddevs);
 	setup_timer(&mddev->safemode_timer, md_safemode_timeout,
 		    (unsigned long) mddev);
-	atomic_set(&mddev->active, 1);
+	refcount_set(&mddev->active, 1);
 	atomic_set(&mddev->openers, 0);
 	atomic_set(&mddev->active_io, 0);
 	spin_lock_init(&mddev->lock);
diff --git a/drivers/md/md.h b/drivers/md/md.h
index b8859cb..4811663 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -22,6 +22,7 @@
 #include <linux/list.h>
 #include <linux/mm.h>
 #include <linux/mutex.h>
+#include <linux/refcount.h>
 #include <linux/timer.h>
 #include <linux/wait.h>
 #include <linux/workqueue.h>
@@ -360,7 +361,7 @@ struct mddev {
 	 */
 	struct mutex			open_mutex;
 	struct mutex			reconfig_mutex;
-	atomic_t			active;		/* general refcount */
+	refcount_t			active;		/* general refcount */
 	atomic_t			openers;	/* number of active opens */
 
 	int				changed;	/* True if we might need to
-- 
2.7.4
