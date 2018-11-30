Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl1-f194.google.com ([209.85.214.194]:36274 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726659AbeLADUx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 30 Nov 2018 22:20:53 -0500
From: Yangtao Li <tiny.windzz@gmail.com>
To: sumit.semwal@linaro.org, gustavo@padovan.org
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
        Yangtao Li <tiny.windzz@gmail.com>
Subject: [PATCH] dma-buf: Change to use DEFINE_SHOW_ATTRIBUTE macro
Date: Fri, 30 Nov 2018 11:11:01 -0500
Message-Id: <20181130161101.3413-1-tiny.windzz@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use DEFINE_SHOW_ATTRIBUTE macro to simplify the code.

Signed-off-by: Yangtao Li <tiny.windzz@gmail.com>
---
 drivers/dma-buf/dma-buf.c    | 12 +-----------
 drivers/dma-buf/sync_debug.c | 16 +++-------------
 2 files changed, 4 insertions(+), 24 deletions(-)

diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index 02f7f9a89979..7c858020d14b 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -1093,17 +1093,7 @@ static int dma_buf_debug_show(struct seq_file *s, void *unused)
 	return 0;
 }
 
-static int dma_buf_debug_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, dma_buf_debug_show, NULL);
-}
-
-static const struct file_operations dma_buf_debug_fops = {
-	.open           = dma_buf_debug_open,
-	.read           = seq_read,
-	.llseek         = seq_lseek,
-	.release        = single_release,
-};
+DEFINE_SHOW_ATTRIBUTE(dma_buf_debug);
 
 static struct dentry *dma_buf_debugfs_dir;
 
diff --git a/drivers/dma-buf/sync_debug.c b/drivers/dma-buf/sync_debug.c
index c4c8ecb24aa9..c0abf37df88b 100644
--- a/drivers/dma-buf/sync_debug.c
+++ b/drivers/dma-buf/sync_debug.c
@@ -147,7 +147,7 @@ static void sync_print_sync_file(struct seq_file *s,
 	}
 }
 
-static int sync_debugfs_show(struct seq_file *s, void *unused)
+static int sync_info_debugfs_show(struct seq_file *s, void *unused)
 {
 	struct list_head *pos;
 
@@ -178,17 +178,7 @@ static int sync_debugfs_show(struct seq_file *s, void *unused)
 	return 0;
 }
 
-static int sync_info_debugfs_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, sync_debugfs_show, inode->i_private);
-}
-
-static const struct file_operations sync_info_debugfs_fops = {
-	.open           = sync_info_debugfs_open,
-	.read           = seq_read,
-	.llseek         = seq_lseek,
-	.release        = single_release,
-};
+DEFINE_SHOW_ATTRIBUTE(sync_info_debugfs);
 
 static __init int sync_debugfs_init(void)
 {
@@ -218,7 +208,7 @@ void sync_dump(void)
 	};
 	int i;
 
-	sync_debugfs_show(&s, NULL);
+	sync_info_debugfs_show(&s, NULL);
 
 	for (i = 0; i < s.count; i += DUMP_CHUNK) {
 		if ((s.count - i) > DUMP_CHUNK) {
-- 
2.17.0
