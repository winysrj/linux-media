Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f50.google.com ([209.85.160.50]:60806 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbaBCMaJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Feb 2014 07:30:09 -0500
Received: by mail-pb0-f50.google.com with SMTP id rq2so6982370pbb.23
        for <linux-media@vger.kernel.org>; Mon, 03 Feb 2014 04:30:09 -0800 (PST)
From: Sumit Semwal <sumit.semwal@linaro.org>
To: linux@arm.linux.org.uk
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, patches@linaro.org,
	linaro-kernel@lists.linaro.org,
	Sumit Semwal <sumit.semwal@linaro.org>
Subject: [PATCH] dma-buf: update debugfs output
Date: Mon,  3 Feb 2014 17:59:41 +0530
Message-Id: <1391430581-18522-1-git-send-email-sumit.semwal@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Russell King observed 'wierd' looking output from debugfs, and also suggested
better ways of getting device names (use KBUILD_MODNAME, dev_name())

This patch addresses these issues to make the debugfs output correct and better
looking.

Signed-off-by: Sumit Semwal <sumit.semwal@linaro.org>
---
 drivers/base/dma-buf.c  | 18 ++++++++----------
 include/linux/dma-buf.h |  2 +-
 2 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/base/dma-buf.c b/drivers/base/dma-buf.c
index cfe1d8b..bf89fe3 100644
--- a/drivers/base/dma-buf.c
+++ b/drivers/base/dma-buf.c
@@ -621,7 +621,7 @@ static int dma_buf_describe(struct seq_file *s)
 		return ret;
 
 	seq_printf(s, "\nDma-buf Objects:\n");
-	seq_printf(s, "\texp_name\tsize\tflags\tmode\tcount\n");
+	seq_printf(s, "size\tflags\tmode\tcount\texp_name\n");
 
 	list_for_each_entry(buf_obj, &db_list.head, list_node) {
 		ret = mutex_lock_interruptible(&buf_obj->lock);
@@ -632,24 +632,22 @@ static int dma_buf_describe(struct seq_file *s)
 			continue;
 		}
 
-		seq_printf(s, "\t");
-
-		seq_printf(s, "\t%s\t%08zu\t%08x\t%08x\t%08ld\n",
-				buf_obj->exp_name, buf_obj->size,
+		seq_printf(s, "%08zu\t%08x\t%08x\t%08ld\t%s\n",
+				buf_obj->size,
 				buf_obj->file->f_flags, buf_obj->file->f_mode,
-				(long)(buf_obj->file->f_count.counter));
+				(long)(buf_obj->file->f_count.counter), buf_obj->exp_name);
 
-		seq_printf(s, "\t\tAttached Devices:\n");
+		seq_printf(s, "\tAttached Devices:\n");
 		attach_count = 0;
 
 		list_for_each_entry(attach_obj, &buf_obj->attachments, node) {
-			seq_printf(s, "\t\t");
+			seq_printf(s, "\t");
 
-			seq_printf(s, "%s\n", attach_obj->dev->init_name);
+			seq_printf(s, "%s\n", dev_name(attach_obj->dev));
 			attach_count++;
 		}
 
-		seq_printf(s, "\n\t\tTotal %d devices attached\n",
+		seq_printf(s, "\nTotal %d devices attached\n",
 				attach_count);
 
 		count++;
diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
index dfac5ed..f886985 100644
--- a/include/linux/dma-buf.h
+++ b/include/linux/dma-buf.h
@@ -171,7 +171,7 @@ struct dma_buf *dma_buf_export_named(void *priv, const struct dma_buf_ops *ops,
 			       size_t size, int flags, const char *);
 
 #define dma_buf_export(priv, ops, size, flags)	\
-	dma_buf_export_named(priv, ops, size, flags, __FILE__)
+	dma_buf_export_named(priv, ops, size, flags, KBUILD_MODNAME)
 
 int dma_buf_fd(struct dma_buf *dmabuf, int flags);
 struct dma_buf *dma_buf_get(int fd);
-- 
1.8.3.2

