Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:16772 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932516AbdCFOhB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 6 Mar 2017 09:37:01 -0500
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
Subject: [PATCH 19/29] drivers, s390: convert lcs_reply.refcnt from atomic_t to refcount_t
Date: Mon,  6 Mar 2017 16:21:06 +0200
Message-Id: <1488810076-3754-20-git-send-email-elena.reshetova@intel.com>
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
 drivers/s390/net/lcs.c | 8 +++-----
 drivers/s390/net/lcs.h | 3 ++-
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/s390/net/lcs.c b/drivers/s390/net/lcs.c
index 211b31d..18dc787 100644
--- a/drivers/s390/net/lcs.c
+++ b/drivers/s390/net/lcs.c
@@ -774,15 +774,13 @@ lcs_get_lancmd(struct lcs_card *card, int count)
 static void
 lcs_get_reply(struct lcs_reply *reply)
 {
-	WARN_ON(atomic_read(&reply->refcnt) <= 0);
-	atomic_inc(&reply->refcnt);
+	refcount_inc(&reply->refcnt);
 }
 
 static void
 lcs_put_reply(struct lcs_reply *reply)
 {
-        WARN_ON(atomic_read(&reply->refcnt) <= 0);
-        if (atomic_dec_and_test(&reply->refcnt)) {
+        if (refcount_dec_and_test(&reply->refcnt)) {
 		kfree(reply);
 	}
 
@@ -798,7 +796,7 @@ lcs_alloc_reply(struct lcs_cmd *cmd)
 	reply = kzalloc(sizeof(struct lcs_reply), GFP_ATOMIC);
 	if (!reply)
 		return NULL;
-	atomic_set(&reply->refcnt,1);
+	refcount_set(&reply->refcnt,1);
 	reply->sequence_no = cmd->sequence_no;
 	reply->received = 0;
 	reply->rc = 0;
diff --git a/drivers/s390/net/lcs.h b/drivers/s390/net/lcs.h
index 150fcb4..3802f4f 100644
--- a/drivers/s390/net/lcs.h
+++ b/drivers/s390/net/lcs.h
@@ -4,6 +4,7 @@
 #include <linux/netdevice.h>
 #include <linux/skbuff.h>
 #include <linux/workqueue.h>
+#include <linux/refcount.h>
 #include <asm/ccwdev.h>
 
 #define LCS_DBF_TEXT(level, name, text) \
@@ -270,7 +271,7 @@ struct lcs_buffer {
 struct lcs_reply {
 	struct list_head list;
 	__u16 sequence_no;
-	atomic_t refcnt;
+	refcount_t refcnt;
 	/* Callback for completion notification. */
 	void (*callback)(struct lcs_card *, struct lcs_cmd *);
 	wait_queue_head_t wait_q;
-- 
2.7.4
