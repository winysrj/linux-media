Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34935 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744AbcFSMbz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Jun 2016 08:31:55 -0400
Received: by mail-wm0-f67.google.com with SMTP id a66so2753237wme.2
        for <linux-media@vger.kernel.org>; Sun, 19 Jun 2016 05:31:54 -0700 (PDT)
From: Mathias Krause <minipli@googlemail.com>
To: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Brad Spengler <spender@grsecurity.net>,
	PaX Team <pageexec@freemail.hu>, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	Mathias Krause <minipli@googlemail.com>,
	Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 1/3] dma-buf: propagate errors from dma_buf_describe() on debugfs read
Date: Sun, 19 Jun 2016 14:31:29 +0200
Message-Id: <1466339491-12639-2-git-send-email-minipli@googlemail.com>
In-Reply-To: <1466339491-12639-1-git-send-email-minipli@googlemail.com>
References: <1466339491-12639-1-git-send-email-minipli@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The callback function dma_buf_describe() returns an int not void so the
function pointer cast in dma_buf_show() is wrong. dma_buf_describe() can
also fail when acquiring the mutex gets interrupted so always returning
0 in dma_buf_show() is wrong, too.

Fix both issues by avoiding the indirection via dma_buf_show() and call
dma_buf_describe() directly. Rename it to dma_buf_debug_show() to get it
in line with the other functions.

This type mismatch was caught by the PaX RAP plugin.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Brad Spengler <spender@grsecurity.net>
Cc: PaX Team <pageexec@freemail.hu>
---
 drivers/dma-buf/dma-buf.c |   14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index 6355ab38d630..7094b19bb495 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -824,7 +824,7 @@ void dma_buf_vunmap(struct dma_buf *dmabuf, void *vaddr)
 EXPORT_SYMBOL_GPL(dma_buf_vunmap);
 
 #ifdef CONFIG_DEBUG_FS
-static int dma_buf_describe(struct seq_file *s)
+static int dma_buf_debug_show(struct seq_file *s, void *unused)
 {
 	int ret;
 	struct dma_buf *buf_obj;
@@ -879,17 +879,9 @@ static int dma_buf_describe(struct seq_file *s)
 	return 0;
 }
 
-static int dma_buf_show(struct seq_file *s, void *unused)
-{
-	void (*func)(struct seq_file *) = s->private;
-
-	func(s);
-	return 0;
-}
-
 static int dma_buf_debug_open(struct inode *inode, struct file *file)
 {
-	return single_open(file, dma_buf_show, inode->i_private);
+	return single_open(file, dma_buf_debug_show, NULL);
 }
 
 static const struct file_operations dma_buf_debug_fops = {
@@ -913,7 +905,7 @@ static int dma_buf_init_debugfs(void)
 		return err;
 	}
 
-	err = dma_buf_debugfs_create_file("bufinfo", dma_buf_describe);
+	err = dma_buf_debugfs_create_file("bufinfo", NULL);
 
 	if (err)
 		pr_debug("dma_buf: debugfs: failed to create node bufinfo\n");
-- 
1.7.10.4

