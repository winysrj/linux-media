Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:5001 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753002AbdCFOY4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
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
Subject: [PATCH 02/29] drivers, firewire: convert fw_node.ref_count from atomic_t to refcount_t
Date: Mon,  6 Mar 2017 16:20:49 +0200
Message-Id: <1488810076-3754-3-git-send-email-elena.reshetova@intel.com>
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
 drivers/firewire/core-topology.c | 2 +-
 drivers/firewire/core.h          | 8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/firewire/core-topology.c b/drivers/firewire/core-topology.c
index 0de8350..939d259 100644
--- a/drivers/firewire/core-topology.c
+++ b/drivers/firewire/core-topology.c
@@ -124,7 +124,7 @@ static struct fw_node *fw_node_create(u32 sid, int port_count, int color)
 	node->initiated_reset = SELF_ID_PHY_INITIATOR(sid);
 	node->port_count = port_count;
 
-	atomic_set(&node->ref_count, 1);
+	refcount_set(&node->ref_count, 1);
 	INIT_LIST_HEAD(&node->link);
 
 	return node;
diff --git a/drivers/firewire/core.h b/drivers/firewire/core.h
index e1480ff6..c07962e 100644
--- a/drivers/firewire/core.h
+++ b/drivers/firewire/core.h
@@ -12,7 +12,7 @@
 #include <linux/slab.h>
 #include <linux/types.h>
 
-#include <linux/atomic.h>
+#include <linux/refcount.h>
 
 struct device;
 struct fw_card;
@@ -184,7 +184,7 @@ struct fw_node {
 			 * local node to this node. */
 	u8 max_depth:4;	/* Maximum depth to any leaf node */
 	u8 max_hops:4;	/* Max hops in this sub tree */
-	atomic_t ref_count;
+	refcount_t ref_count;
 
 	/* For serializing node topology into a list. */
 	struct list_head link;
@@ -197,14 +197,14 @@ struct fw_node {
 
 static inline struct fw_node *fw_node_get(struct fw_node *node)
 {
-	atomic_inc(&node->ref_count);
+	refcount_inc(&node->ref_count);
 
 	return node;
 }
 
 static inline void fw_node_put(struct fw_node *node)
 {
-	if (atomic_dec_and_test(&node->ref_count))
+	if (refcount_dec_and_test(&node->ref_count))
 		kfree(node);
 }
 
-- 
2.7.4
