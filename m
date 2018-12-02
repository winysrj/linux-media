Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg1-f195.google.com ([209.85.215.195]:46658 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725727AbeLBNSW (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 2 Dec 2018 08:18:22 -0500
From: Yangtao Li <tiny.windzz@gmail.com>
To: kyungmin.park@samsung.com, s.nawrocki@samsung.com,
        mchehab@kernel.org, kgene@kernel.org, krzk@kernel.org,
        fabien.dessenne@st.com, jean-christophe.trotin@st.com
Cc: linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yangtao Li <tiny.windzz@gmail.com>
Subject: [PATCH v2] media: remove bdisp_dbg_declare() and hva_dbg_declare()
Date: Sat,  1 Dec 2018 21:04:25 -0500
Message-Id: <20181202020425.9189-1-tiny.windzz@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We already have the DEFINE_SHOW_ATTRIBUTE.There is no need to define
bdisp_dbg_declare and hva_dbg_declare,so remove them.Also use
DEFINE_SHOW_ATTRIBUTE to simplify some code.

Signed-off-by: Yangtao Li <tiny.windzz@gmail.com>
---
Changes in v2:
-delete fimc_is_debugfs_open
---
 drivers/media/platform/exynos4-is/fimc-is.c   | 16 ++-------
 .../media/platform/sti/bdisp/bdisp-debug.c    | 34 ++++++------------
 drivers/media/platform/sti/hva/hva-debugfs.c  | 36 +++++++------------
 3 files changed, 26 insertions(+), 60 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-is.c b/drivers/media/platform/exynos4-is/fimc-is.c
index f5fc54de19da..02da0b06e56a 100644
--- a/drivers/media/platform/exynos4-is/fimc-is.c
+++ b/drivers/media/platform/exynos4-is/fimc-is.c
@@ -738,7 +738,7 @@ int fimc_is_hw_initialize(struct fimc_is *is)
 	return 0;
 }
 
-static int fimc_is_log_show(struct seq_file *s, void *data)
+static int fimc_is_show(struct seq_file *s, void *data)
 {
 	struct fimc_is *is = s->private;
 	const u8 *buf = is->memory.vaddr + FIMC_IS_DEBUG_REGION_OFFSET;
@@ -752,17 +752,7 @@ static int fimc_is_log_show(struct seq_file *s, void *data)
 	return 0;
 }
 
-static int fimc_is_debugfs_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, fimc_is_log_show, inode->i_private);
-}
-
-static const struct file_operations fimc_is_debugfs_fops = {
-	.open		= fimc_is_debugfs_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
+DEFINE_SHOW_ATTRIBUTE(fimc_is);
 
 static void fimc_is_debugfs_remove(struct fimc_is *is)
 {
@@ -777,7 +767,7 @@ static int fimc_is_debugfs_create(struct fimc_is *is)
 	is->debugfs_entry = debugfs_create_dir("fimc_is", NULL);
 
 	dentry = debugfs_create_file("fw_log", S_IRUGO, is->debugfs_entry,
-				     is, &fimc_is_debugfs_fops);
+				     is, &fimc_is_fops);
 	if (!dentry)
 		fimc_is_debugfs_remove(is);
 
diff --git a/drivers/media/platform/sti/bdisp/bdisp-debug.c b/drivers/media/platform/sti/bdisp/bdisp-debug.c
index c6a4e2de5c0c..77ca7517fa3e 100644
--- a/drivers/media/platform/sti/bdisp/bdisp-debug.c
+++ b/drivers/media/platform/sti/bdisp/bdisp-debug.c
@@ -315,7 +315,7 @@ static void bdisp_dbg_dump_ivmx(struct seq_file *s,
 	seq_puts(s, "Unknown conversion\n");
 }
 
-static int bdisp_dbg_last_nodes(struct seq_file *s, void *data)
+static int last_nodes_show(struct seq_file *s, void *data)
 {
 	/* Not dumping all fields, focusing on significant ones */
 	struct bdisp_dev *bdisp = s->private;
@@ -388,7 +388,7 @@ static int bdisp_dbg_last_nodes(struct seq_file *s, void *data)
 	return 0;
 }
 
-static int bdisp_dbg_last_nodes_raw(struct seq_file *s, void *data)
+static int last_nodes_raw_show(struct seq_file *s, void *data)
 {
 	struct bdisp_dev *bdisp = s->private;
 	struct bdisp_node *node;
@@ -437,7 +437,7 @@ static const char *bdisp_fmt_to_str(struct bdisp_frame frame)
 	}
 }
 
-static int bdisp_dbg_last_request(struct seq_file *s, void *data)
+static int last_request_show(struct seq_file *s, void *data)
 {
 	struct bdisp_dev *bdisp = s->private;
 	struct bdisp_request *request = &bdisp->dbg.copy_request;
@@ -474,7 +474,7 @@ static int bdisp_dbg_last_request(struct seq_file *s, void *data)
 
 #define DUMP(reg) seq_printf(s, #reg " \t0x%08X\n", readl(bdisp->regs + reg))
 
-static int bdisp_dbg_regs(struct seq_file *s, void *data)
+static int regs_show(struct seq_file *s, void *data)
 {
 	struct bdisp_dev *bdisp = s->private;
 	int ret;
@@ -582,7 +582,7 @@ static int bdisp_dbg_regs(struct seq_file *s, void *data)
 
 #define SECOND 1000000
 
-static int bdisp_dbg_perf(struct seq_file *s, void *data)
+static int perf_show(struct seq_file *s, void *data)
 {
 	struct bdisp_dev *bdisp = s->private;
 	struct bdisp_request *request = &bdisp->dbg.copy_request;
@@ -627,27 +627,15 @@ static int bdisp_dbg_perf(struct seq_file *s, void *data)
 	return 0;
 }
 
-#define bdisp_dbg_declare(name) \
-	static int bdisp_dbg_##name##_open(struct inode *i, struct file *f) \
-	{ \
-		return single_open(f, bdisp_dbg_##name, i->i_private); \
-	} \
-	static const struct file_operations bdisp_dbg_##name##_fops = { \
-		.open           = bdisp_dbg_##name##_open, \
-		.read           = seq_read, \
-		.llseek         = seq_lseek, \
-		.release        = single_release, \
-	}
-
 #define bdisp_dbg_create_entry(name) \
 	debugfs_create_file(#name, S_IRUGO, bdisp->dbg.debugfs_entry, bdisp, \
-			    &bdisp_dbg_##name##_fops)
+			    &name##_fops)
 
-bdisp_dbg_declare(regs);
-bdisp_dbg_declare(last_nodes);
-bdisp_dbg_declare(last_nodes_raw);
-bdisp_dbg_declare(last_request);
-bdisp_dbg_declare(perf);
+DEFINE_SHOW_ATTRIBUTE(regs);
+DEFINE_SHOW_ATTRIBUTE(last_nodes);
+DEFINE_SHOW_ATTRIBUTE(last_nodes_raw);
+DEFINE_SHOW_ATTRIBUTE(last_request);
+DEFINE_SHOW_ATTRIBUTE(perf);
 
 int bdisp_debugfs_create(struct bdisp_dev *bdisp)
 {
diff --git a/drivers/media/platform/sti/hva/hva-debugfs.c b/drivers/media/platform/sti/hva/hva-debugfs.c
index 9f7e8ac875d1..7d12a5b5d914 100644
--- a/drivers/media/platform/sti/hva/hva-debugfs.c
+++ b/drivers/media/platform/sti/hva/hva-debugfs.c
@@ -271,7 +271,7 @@ static void hva_dbg_perf_compute(struct hva_ctx *ctx)
  * device debug info
  */
 
-static int hva_dbg_device(struct seq_file *s, void *data)
+static int device_show(struct seq_file *s, void *data)
 {
 	struct hva_dev *hva = s->private;
 
@@ -281,7 +281,7 @@ static int hva_dbg_device(struct seq_file *s, void *data)
 	return 0;
 }
 
-static int hva_dbg_encoders(struct seq_file *s, void *data)
+static int encoders_show(struct seq_file *s, void *data)
 {
 	struct hva_dev *hva = s->private;
 	unsigned int i = 0;
@@ -299,7 +299,7 @@ static int hva_dbg_encoders(struct seq_file *s, void *data)
 	return 0;
 }
 
-static int hva_dbg_last(struct seq_file *s, void *data)
+static int last_show(struct seq_file *s, void *data)
 {
 	struct hva_dev *hva = s->private;
 	struct hva_ctx *last_ctx = &hva->dbg.last_ctx;
@@ -316,7 +316,7 @@ static int hva_dbg_last(struct seq_file *s, void *data)
 	return 0;
 }
 
-static int hva_dbg_regs(struct seq_file *s, void *data)
+static int regs_show(struct seq_file *s, void *data)
 {
 	struct hva_dev *hva = s->private;
 
@@ -325,26 +325,14 @@ static int hva_dbg_regs(struct seq_file *s, void *data)
 	return 0;
 }
 
-#define hva_dbg_declare(name)						  \
-	static int hva_dbg_##name##_open(struct inode *i, struct file *f) \
-	{								  \
-		return single_open(f, hva_dbg_##name, i->i_private);	  \
-	}								  \
-	static const struct file_operations hva_dbg_##name##_fops = {	  \
-		.open		= hva_dbg_##name##_open,		  \
-		.read		= seq_read,				  \
-		.llseek		= seq_lseek,				  \
-		.release	= single_release,			  \
-	}
-
 #define hva_dbg_create_entry(name)					 \
 	debugfs_create_file(#name, 0444, hva->dbg.debugfs_entry, hva, \
-			    &hva_dbg_##name##_fops)
+			    &name##_fops)
 
-hva_dbg_declare(device);
-hva_dbg_declare(encoders);
-hva_dbg_declare(last);
-hva_dbg_declare(regs);
+DEFINE_SHOW_ATTRIBUTE(device);
+DEFINE_SHOW_ATTRIBUTE(encoders);
+DEFINE_SHOW_ATTRIBUTE(last);
+DEFINE_SHOW_ATTRIBUTE(regs);
 
 void hva_debugfs_create(struct hva_dev *hva)
 {
@@ -380,7 +368,7 @@ void hva_debugfs_remove(struct hva_dev *hva)
  * context (instance) debug info
  */
 
-static int hva_dbg_ctx(struct seq_file *s, void *data)
+static int ctx_show(struct seq_file *s, void *data)
 {
 	struct hva_ctx *ctx = s->private;
 
@@ -392,7 +380,7 @@ static int hva_dbg_ctx(struct seq_file *s, void *data)
 	return 0;
 }
 
-hva_dbg_declare(ctx);
+DEFINE_SHOW_ATTRIBUTE(ctx);
 
 void hva_dbg_ctx_create(struct hva_ctx *ctx)
 {
@@ -407,7 +395,7 @@ void hva_dbg_ctx_create(struct hva_ctx *ctx)
 
 	ctx->dbg.debugfs_entry = debugfs_create_file(name, 0444,
 						     hva->dbg.debugfs_entry,
-						     ctx, &hva_dbg_ctx_fops);
+						     ctx, &ctx_fops);
 }
 
 void hva_dbg_ctx_remove(struct hva_ctx *ctx)
-- 
2.17.0
