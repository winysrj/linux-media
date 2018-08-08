Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:34328 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727521AbeHHRNB (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 8 Aug 2018 13:13:01 -0400
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 6/6] siano: get rid of an unused return code for debugfs register
Date: Wed,  8 Aug 2018 10:52:56 -0400
Message-Id: <76af93fcc30cb20d9560d897bd0999c5434ee9f5.1533739965.git.mchehab+samsung@kernel.org>
In-Reply-To: <577a6299b1881c011bb82adb8a321ce72599a33c.1533739965.git.mchehab+samsung@kernel.org>
References: <577a6299b1881c011bb82adb8a321ce72599a33c.1533739965.git.mchehab+samsung@kernel.org>
In-Reply-To: <577a6299b1881c011bb82adb8a321ce72599a33c.1533739965.git.mchehab+samsung@kernel.org>
References: <577a6299b1881c011bb82adb8a321ce72599a33c.1533739965.git.mchehab+samsung@kernel.org>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The siano's debugfs register logic is optional: it should be ok
if it fails. So, no need to check if debufs register succeeded.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/common/siano/smsdvb-debugfs.c | 10 +++++-----
 drivers/media/common/siano/smsdvb.h         |  7 ++-----
 2 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/media/common/siano/smsdvb-debugfs.c b/drivers/media/common/siano/smsdvb-debugfs.c
index 40891f4f842b..c95d4583498e 100644
--- a/drivers/media/common/siano/smsdvb-debugfs.c
+++ b/drivers/media/common/siano/smsdvb-debugfs.c
@@ -500,7 +500,7 @@ void smsdvb_debugfs_release(struct smsdvb_client_t *client)
 	client->debugfs = NULL;
 }
 
-int smsdvb_debugfs_register(void)
+void smsdvb_debugfs_register(void)
 {
 	struct dentry *d;
 
@@ -517,15 +517,15 @@ int smsdvb_debugfs_register(void)
 	d = debugfs_create_dir("smsdvb", usb_debug_root);
 	if (IS_ERR_OR_NULL(d)) {
 		pr_err("Couldn't create sysfs node for smsdvb\n");
-		return PTR_ERR(d);
-	} else {
-		smsdvb_debugfs_usb_root = d;
+		return;
 	}
-	return 0;
+	smsdvb_debugfs_usb_root = d;
 }
 
 void smsdvb_debugfs_unregister(void)
 {
+	if (!smsdvb_debugfs_usb_root)
+		return;
 	debugfs_remove_recursive(smsdvb_debugfs_usb_root);
 	smsdvb_debugfs_usb_root = NULL;
 }
diff --git a/drivers/media/common/siano/smsdvb.h b/drivers/media/common/siano/smsdvb.h
index b15754d95ec0..befeb9817e54 100644
--- a/drivers/media/common/siano/smsdvb.h
+++ b/drivers/media/common/siano/smsdvb.h
@@ -107,7 +107,7 @@ struct RECEPTION_STATISTICS_PER_SLICES_S {
 
 int smsdvb_debugfs_create(struct smsdvb_client_t *client);
 void smsdvb_debugfs_release(struct smsdvb_client_t *client);
-int smsdvb_debugfs_register(void);
+void smsdvb_debugfs_register(void);
 void smsdvb_debugfs_unregister(void);
 
 #else
@@ -119,10 +119,7 @@ static inline int smsdvb_debugfs_create(struct smsdvb_client_t *client)
 
 static inline void smsdvb_debugfs_release(struct smsdvb_client_t *client) {}
 
-static inline int smsdvb_debugfs_register(void)
-{
-	return 0;
-};
+static inline void smsdvb_debugfs_register(void) {}
 
 static inline void smsdvb_debugfs_unregister(void) {};
 
-- 
2.17.1
