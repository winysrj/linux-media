Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:35964 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744AbcFSMb5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Jun 2016 08:31:57 -0400
Received: by mail-wm0-f67.google.com with SMTP id c82so4915740wme.3
        for <linux-media@vger.kernel.org>; Sun, 19 Jun 2016 05:31:56 -0700 (PDT)
From: Mathias Krause <minipli@googlemail.com>
To: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Brad Spengler <spender@grsecurity.net>,
	PaX Team <pageexec@freemail.hu>, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	Mathias Krause <minipli@googlemail.com>,
	Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 3/3] dma-buf: remove dma_buf_debugfs_create_file()
Date: Sun, 19 Jun 2016 14:31:31 +0200
Message-Id: <1466339491-12639-4-git-send-email-minipli@googlemail.com>
In-Reply-To: <1466339491-12639-1-git-send-email-minipli@googlemail.com>
References: <1466339491-12639-1-git-send-email-minipli@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is only a single user of dma_buf_debugfs_create_file() and that
one got the function pointer cast wrong. With that one fixed, there is
no need to have a wrapper for debugfs_create_file(), just call it
directly.

With no users left, we can remove dma_buf_debugfs_create_file().

While at it, simplify the error handling in dma_buf_init_debugfs()
slightly.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
---
 drivers/dma-buf/dma-buf.c |   29 +++++++++--------------------
 include/linux/dma-buf.h   |    2 --
 2 files changed, 9 insertions(+), 22 deletions(-)

diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index f03e51561199..20ce0687b111 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -895,22 +895,22 @@ static struct dentry *dma_buf_debugfs_dir;
 
 static int dma_buf_init_debugfs(void)
 {
+	struct dentry *d;
 	int err = 0;
 
-	dma_buf_debugfs_dir = debugfs_create_dir("dma_buf", NULL);
+	d = debugfs_create_dir("dma_buf", NULL);
+	if (IS_ERR(d))
+		return PTR_ERR(d);
 
-	if (IS_ERR(dma_buf_debugfs_dir)) {
-		err = PTR_ERR(dma_buf_debugfs_dir);
-		dma_buf_debugfs_dir = NULL;
-		return err;
-	}
+	dma_buf_debugfs_dir = d;
 
-	err = dma_buf_debugfs_create_file("bufinfo", NULL);
-
-	if (err) {
+	d = debugfs_create_file("bufinfo", S_IRUGO, dma_buf_debugfs_dir,
+				NULL, &dma_buf_debug_fops);
+	if (IS_ERR(d)) {
 		pr_debug("dma_buf: debugfs: failed to create node bufinfo\n");
 		debugfs_remove_recursive(dma_buf_debugfs_dir);
 		dma_buf_debugfs_dir = NULL;
+		err = PTR_ERR(d);
 	}
 
 	return err;
@@ -921,17 +921,6 @@ static void dma_buf_uninit_debugfs(void)
 	if (dma_buf_debugfs_dir)
 		debugfs_remove_recursive(dma_buf_debugfs_dir);
 }
-
-int dma_buf_debugfs_create_file(const char *name,
-				int (*write)(struct seq_file *))
-{
-	struct dentry *d;
-
-	d = debugfs_create_file(name, S_IRUGO, dma_buf_debugfs_dir,
-			write, &dma_buf_debug_fops);
-
-	return PTR_ERR_OR_ZERO(d);
-}
 #else
 static inline int dma_buf_init_debugfs(void)
 {
diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
index 4551c6f2a6c4..e0b0741ae671 100644
--- a/include/linux/dma-buf.h
+++ b/include/linux/dma-buf.h
@@ -242,6 +242,4 @@ int dma_buf_mmap(struct dma_buf *, struct vm_area_struct *,
 		 unsigned long);
 void *dma_buf_vmap(struct dma_buf *);
 void dma_buf_vunmap(struct dma_buf *, void *vaddr);
-int dma_buf_debugfs_create_file(const char *name,
-				int (*write)(struct seq_file *));
 #endif /* __DMA_BUF_H__ */
-- 
1.7.10.4

