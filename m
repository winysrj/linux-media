Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:56016 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752703AbdCFOY5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
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
Subject: [PATCH 22/29] drivers, scsi: convert iscsi_task.refcount from atomic_t to refcount_t
Date: Mon,  6 Mar 2017 16:21:09 +0200
Message-Id: <1488810076-3754-23-git-send-email-elena.reshetova@intel.com>
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
 drivers/scsi/libiscsi.c        | 8 ++++----
 drivers/scsi/qedi/qedi_iscsi.c | 2 +-
 include/scsi/libiscsi.h        | 3 ++-
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 834d121..7eb1d2c 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -516,13 +516,13 @@ static void iscsi_free_task(struct iscsi_task *task)
 
 void __iscsi_get_task(struct iscsi_task *task)
 {
-	atomic_inc(&task->refcount);
+	refcount_inc(&task->refcount);
 }
 EXPORT_SYMBOL_GPL(__iscsi_get_task);
 
 void __iscsi_put_task(struct iscsi_task *task)
 {
-	if (atomic_dec_and_test(&task->refcount))
+	if (refcount_dec_and_test(&task->refcount))
 		iscsi_free_task(task);
 }
 EXPORT_SYMBOL_GPL(__iscsi_put_task);
@@ -744,7 +744,7 @@ __iscsi_conn_send_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 	 * released by the lld when it has transmitted the task for
 	 * pdus we do not expect a response for.
 	 */
-	atomic_set(&task->refcount, 1);
+	refcount_set(&task->refcount, 1);
 	task->conn = conn;
 	task->sc = NULL;
 	INIT_LIST_HEAD(&task->running);
@@ -1616,7 +1616,7 @@ static inline struct iscsi_task *iscsi_alloc_task(struct iscsi_conn *conn,
 	sc->SCp.phase = conn->session->age;
 	sc->SCp.ptr = (char *) task;
 
-	atomic_set(&task->refcount, 1);
+	refcount_set(&task->refcount, 1);
 	task->state = ISCSI_TASK_PENDING;
 	task->conn = conn;
 	task->sc = sc;
diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c
index b9f79d3..3895bd5 100644
--- a/drivers/scsi/qedi/qedi_iscsi.c
+++ b/drivers/scsi/qedi/qedi_iscsi.c
@@ -1372,7 +1372,7 @@ static void qedi_cleanup_task(struct iscsi_task *task)
 {
 	if (!task->sc || task->state == ISCSI_TASK_PENDING) {
 		QEDI_INFO(NULL, QEDI_LOG_IO, "Returning ref_cnt=%d\n",
-			  atomic_read(&task->refcount));
+			  refcount_read(&task->refcount));
 		return;
 	}
 
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index b0e275d..24d74b5 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -29,6 +29,7 @@
 #include <linux/timer.h>
 #include <linux/workqueue.h>
 #include <linux/kfifo.h>
+#include <linux/refcount.h>
 #include <scsi/iscsi_proto.h>
 #include <scsi/iscsi_if.h>
 #include <scsi/scsi_transport_iscsi.h>
@@ -139,7 +140,7 @@ struct iscsi_task {
 
 	/* state set/tested under session->lock */
 	int			state;
-	atomic_t		refcount;
+	refcount_t		refcount;
 	struct list_head	running;	/* running cmd list */
 	void			*dd_data;	/* driver/transport data */
 };
-- 
2.7.4
