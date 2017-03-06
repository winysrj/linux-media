Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:47164 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754668AbdCFOfz (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 6 Mar 2017 09:35:55 -0500
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
Subject: [PATCH 20/29] drivers, s390: convert qeth_reply.refcnt from atomic_t to refcount_t
Date: Mon,  6 Mar 2017 16:21:07 +0200
Message-Id: <1488810076-3754-21-git-send-email-elena.reshetova@intel.com>
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
 drivers/s390/net/qeth_core.h      | 3 ++-
 drivers/s390/net/qeth_core_main.c | 8 +++-----
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index e7addea..e2c81d21 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -20,6 +20,7 @@
 #include <linux/ethtool.h>
 #include <linux/hashtable.h>
 #include <linux/ip.h>
+#include <linux/refcount.h>
 
 #include <net/ipv6.h>
 #include <net/if_inet6.h>
@@ -641,7 +642,7 @@ struct qeth_reply {
 	int rc;
 	void *param;
 	struct qeth_card *card;
-	atomic_t refcnt;
+	refcount_t refcnt;
 };
 
 
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 315d8a2..a2bf13f 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -555,7 +555,7 @@ static struct qeth_reply *qeth_alloc_reply(struct qeth_card *card)
 
 	reply = kzalloc(sizeof(struct qeth_reply), GFP_ATOMIC);
 	if (reply) {
-		atomic_set(&reply->refcnt, 1);
+		refcount_set(&reply->refcnt, 1);
 		atomic_set(&reply->received, 0);
 		reply->card = card;
 	}
@@ -564,14 +564,12 @@ static struct qeth_reply *qeth_alloc_reply(struct qeth_card *card)
 
 static void qeth_get_reply(struct qeth_reply *reply)
 {
-	WARN_ON(atomic_read(&reply->refcnt) <= 0);
-	atomic_inc(&reply->refcnt);
+	refcount_inc(&reply->refcnt);
 }
 
 static void qeth_put_reply(struct qeth_reply *reply)
 {
-	WARN_ON(atomic_read(&reply->refcnt) <= 0);
-	if (atomic_dec_and_test(&reply->refcnt))
+	if (refcount_dec_and_test(&reply->refcnt))
 		kfree(reply);
 }
 
-- 
2.7.4
