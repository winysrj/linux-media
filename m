Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:37943 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752768AbdCFOY4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
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
Subject: [PATCH 24/29] drivers: convert iblock_req.pending from atomic_t to refcount_t
Date: Mon,  6 Mar 2017 16:21:11 +0200
Message-Id: <1488810076-3754-25-git-send-email-elena.reshetova@intel.com>
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
 drivers/target/target_core_iblock.c | 12 ++++++------
 drivers/target/target_core_iblock.h |  3 ++-
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index d316ed5..bb069eb 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -279,7 +279,7 @@ static void iblock_complete_cmd(struct se_cmd *cmd)
 	struct iblock_req *ibr = cmd->priv;
 	u8 status;
 
-	if (!atomic_dec_and_test(&ibr->pending))
+	if (!refcount_dec_and_test(&ibr->pending))
 		return;
 
 	if (atomic_read(&ibr->ib_bio_err_cnt))
@@ -487,7 +487,7 @@ iblock_execute_write_same(struct se_cmd *cmd)
 	bio_list_init(&list);
 	bio_list_add(&list, bio);
 
-	atomic_set(&ibr->pending, 1);
+	refcount_set(&ibr->pending, 1);
 
 	while (sectors) {
 		while (bio_add_page(bio, sg_page(sg), sg->length, sg->offset)
@@ -498,7 +498,7 @@ iblock_execute_write_same(struct se_cmd *cmd)
 			if (!bio)
 				goto fail_put_bios;
 
-			atomic_inc(&ibr->pending);
+			refcount_inc(&ibr->pending);
 			bio_list_add(&list, bio);
 		}
 
@@ -706,7 +706,7 @@ iblock_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 	cmd->priv = ibr;
 
 	if (!sgl_nents) {
-		atomic_set(&ibr->pending, 1);
+		refcount_set(&ibr->pending, 1);
 		iblock_complete_cmd(cmd);
 		return 0;
 	}
@@ -719,7 +719,7 @@ iblock_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 	bio_list_init(&list);
 	bio_list_add(&list, bio);
 
-	atomic_set(&ibr->pending, 2);
+	refcount_set(&ibr->pending, 2);
 	bio_cnt = 1;
 
 	for_each_sg(sgl, sg, sgl_nents, i) {
@@ -740,7 +740,7 @@ iblock_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 			if (!bio)
 				goto fail_put_bios;
 
-			atomic_inc(&ibr->pending);
+			refcount_inc(&ibr->pending);
 			bio_list_add(&list, bio);
 			bio_cnt++;
 		}
diff --git a/drivers/target/target_core_iblock.h b/drivers/target/target_core_iblock.h
index 718d3fc..f2a5797 100644
--- a/drivers/target/target_core_iblock.h
+++ b/drivers/target/target_core_iblock.h
@@ -2,6 +2,7 @@
 #define TARGET_CORE_IBLOCK_H
 
 #include <linux/atomic.h>
+#include <linux/refcount.h>
 #include <target/target_core_base.h>
 
 #define IBLOCK_VERSION		"4.0"
@@ -10,7 +11,7 @@
 #define IBLOCK_LBA_SHIFT	9
 
 struct iblock_req {
-	atomic_t pending;
+	refcount_t pending;
 	atomic_t ib_bio_err_cnt;
 } ____cacheline_aligned;
 
-- 
2.7.4
