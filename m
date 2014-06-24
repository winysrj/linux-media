Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57701 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754026AbaFXO4b (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Jun 2014 10:56:31 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v2 29/29] [media] coda: export auxiliary buffers via debugfs
Date: Tue, 24 Jun 2014 16:56:11 +0200
Message-Id: <1403621771-11636-30-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1403621771-11636-1-git-send-email-p.zabel@pengutronix.de>
References: <1403621771-11636-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch exports all auxiliary buffers, including SRAM, as debugfs binary
blobs for debugging purposes. It shows, for example, that psbuf currently
doesn't seem to be used at all on CODA7541, and that slicebuf and workbuf
usage is far from the maximum. It can also be used to validate SRAM size
allocation.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda.c | 64 +++++++++++++++++++++++++++++++++++--------
 1 file changed, 53 insertions(+), 11 deletions(-)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index ec2b183..8978489 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -12,6 +12,7 @@
  */
 
 #include <linux/clk.h>
+#include <linux/debugfs.h>
 #include <linux/delay.h>
 #include <linux/firmware.h>
 #include <linux/genalloc.h>
@@ -129,6 +130,8 @@ struct coda_aux_buf {
 	void			*vaddr;
 	dma_addr_t		paddr;
 	u32			size;
+	struct debugfs_blob_wrapper blob;
+	struct dentry		*dentry;
 };
 
 struct coda_dev {
@@ -156,6 +159,7 @@ struct coda_dev {
 	struct vb2_alloc_ctx	*alloc_ctx;
 	struct list_head	instances;
 	unsigned long		instance_mask;
+	struct dentry		*debugfs_root;
 };
 
 struct coda_params {
@@ -259,6 +263,7 @@ struct coda_ctx {
 	u32				frm_dis_flg;
 	u32				frame_mem_ctrl;
 	int				display_idx;
+	struct dentry			*debugfs_entry;
 };
 
 static const u8 coda_filler_nal[14] = { 0x00, 0x00, 0x00, 0x01, 0x0c, 0xff,
@@ -1706,7 +1711,8 @@ static void coda_parabuf_write(struct coda_ctx *ctx, int index, u32 value)
 }
 
 static int coda_alloc_aux_buf(struct coda_dev *dev,
-			      struct coda_aux_buf *buf, size_t size)
+			      struct coda_aux_buf *buf, size_t size,
+			      const char *name, struct dentry *parent)
 {
 	buf->vaddr = dma_alloc_coherent(&dev->plat_dev->dev, size, &buf->paddr,
 					GFP_KERNEL);
@@ -1715,13 +1721,23 @@ static int coda_alloc_aux_buf(struct coda_dev *dev,
 
 	buf->size = size;
 
+	if (name && parent) {
+		buf->blob.data = buf->vaddr;
+		buf->blob.size = size;
+		buf->dentry = debugfs_create_blob(name, 0644, parent, &buf->blob);
+		if (!buf->dentry)
+			dev_warn(&dev->plat_dev->dev,
+				 "failed to create debugfs entry %s\n", name);
+	}
+
 	return 0;
 }
 
 static inline int coda_alloc_context_buf(struct coda_ctx *ctx,
-					 struct coda_aux_buf *buf, size_t size)
+					 struct coda_aux_buf *buf, size_t size,
+					 const char *name)
 {
-	return coda_alloc_aux_buf(ctx->dev, buf, size);
+	return coda_alloc_aux_buf(ctx->dev, buf, size, name, ctx->debugfs_entry);
 }
 
 static void coda_free_aux_buf(struct coda_dev *dev,
@@ -1733,6 +1749,7 @@ static void coda_free_aux_buf(struct coda_dev *dev,
 		buf->vaddr = NULL;
 		buf->size = 0;
 	}
+	debugfs_remove(buf->dentry);
 }
 
 static void coda_free_framebuffers(struct coda_ctx *ctx)
@@ -1765,12 +1782,16 @@ static int coda_alloc_framebuffers(struct coda_ctx *ctx, struct coda_q_data *q_d
 	/* Allocate frame buffers */
 	for (i = 0; i < ctx->num_internal_frames; i++) {
 		size_t size;
+		char *name;
 
 		size = ysize + ysize / 2;
 		if (ctx->codec->src_fourcc == V4L2_PIX_FMT_H264 &&
 		    dev->devtype->product != CODA_DX6)
 			size += ysize / 4;
-		ret = coda_alloc_context_buf(ctx, &ctx->internal_frames[i], size);
+		name = kasprintf(GFP_KERNEL, "fb%d", i);
+		ret = coda_alloc_context_buf(ctx, &ctx->internal_frames[i],
+					     size, name);
+		kfree(name);
 		if (ret < 0) {
 			coda_free_framebuffers(ctx);
 			return ret;
@@ -1994,7 +2015,7 @@ static int coda_alloc_context_buffers(struct coda_ctx *ctx,
 		/* worst case slice size */
 		size = (DIV_ROUND_UP(q_data->width, 16) *
 			DIV_ROUND_UP(q_data->height, 16)) * 3200 / 8 + 512;
-		ret = coda_alloc_context_buf(ctx, &ctx->slicebuf, size);
+		ret = coda_alloc_context_buf(ctx, &ctx->slicebuf, size, "slicebuf");
 		if (ret < 0) {
 			v4l2_err(&dev->v4l2_dev, "failed to allocate %d byte slice buffer",
 				 ctx->slicebuf.size);
@@ -2003,14 +2024,14 @@ static int coda_alloc_context_buffers(struct coda_ctx *ctx,
 	}
 
 	if (dev->devtype->product == CODA_7541) {
-		ret = coda_alloc_context_buf(ctx, &ctx->psbuf, CODA7_PS_BUF_SIZE);
+		ret = coda_alloc_context_buf(ctx, &ctx->psbuf, CODA7_PS_BUF_SIZE, "psbuf");
 		if (ret < 0) {
 			v4l2_err(&dev->v4l2_dev, "failed to allocate psmem buffer");
 			goto err;
 		}
 	}
 
-	ret = coda_alloc_context_buf(ctx, &ctx->workbuf, size);
+	ret = coda_alloc_context_buf(ctx, &ctx->workbuf, size, "workbuf");
 	if (ret < 0) {
 		v4l2_err(&dev->v4l2_dev, "failed to allocate %d byte context buffer",
 			 ctx->workbuf.size);
@@ -2896,6 +2917,7 @@ static int coda_open(struct file *file)
 {
 	struct coda_dev *dev = video_drvdata(file);
 	struct coda_ctx *ctx = NULL;
+	char *name;
 	int ret;
 	int idx;
 
@@ -2910,6 +2932,10 @@ static int coda_open(struct file *file)
 	}
 	set_bit(idx, &dev->instance_mask);
 
+	name = kasprintf(GFP_KERNEL, "context%d", idx);
+	ctx->debugfs_entry = debugfs_create_dir(name, dev->debugfs_root);
+	kfree(name);
+
 	init_completion(&ctx->completion);
 	INIT_WORK(&ctx->pic_run_work, coda_pic_run_work);
 	INIT_WORK(&ctx->seq_end_work, coda_seq_end_work);
@@ -2961,7 +2987,8 @@ static int coda_open(struct file *file)
 
 	ctx->fh.ctrl_handler = &ctx->ctrls;
 
-	ret = coda_alloc_context_buf(ctx, &ctx->parabuf, CODA_PARA_BUF_SIZE);
+	ret = coda_alloc_context_buf(ctx, &ctx->parabuf, CODA_PARA_BUF_SIZE,
+				     "parabuf");
 	if (ret < 0) {
 		v4l2_err(&dev->v4l2_dev, "failed to allocate parabuf");
 		goto err_dma_alloc;
@@ -3022,6 +3049,8 @@ static int coda_release(struct file *file)
 	v4l2_dbg(1, coda_debug, &dev->v4l2_dev, "Releasing instance %p\n",
 		 ctx);
 
+	debugfs_remove_recursive(ctx->debugfs_entry);
+
 	/* If this instance is running, call .job_abort and wait for it to end */
 	v4l2_m2m_ctx_release(ctx->fh.m2m_ctx);
 
@@ -3553,7 +3582,8 @@ static void coda_fw_callback(const struct firmware *fw, void *context)
 	}
 
 	/* allocate auxiliary per-device code buffer for the BIT processor */
-	ret = coda_alloc_aux_buf(dev, &dev->codebuf, fw->size);
+	ret = coda_alloc_aux_buf(dev, &dev->codebuf, fw->size, "codebuf",
+				 dev->debugfs_root);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "failed to allocate code buffer\n");
 		return;
@@ -3789,11 +3819,16 @@ static int coda_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
+	dev->debugfs_root = debugfs_create_dir("coda", NULL);
+	if (!dev->debugfs_root)
+		dev_warn(&pdev->dev, "failed to create debugfs root\n");
+
 	/* allocate auxiliary per-device buffers for the BIT processor */
 	switch (dev->devtype->product) {
 	case CODA_DX6:
 		ret = coda_alloc_aux_buf(dev, &dev->workbuf,
-					 CODADX6_WORK_BUF_SIZE);
+					 CODADX6_WORK_BUF_SIZE, "workbuf",
+					 dev->debugfs_root);
 		if (ret < 0) {
 			dev_err(&pdev->dev, "failed to allocate work buffer\n");
 			v4l2_device_unregister(&dev->v4l2_dev);
@@ -3809,7 +3844,8 @@ static int coda_probe(struct platform_device *pdev)
 	}
 	if (dev->tempbuf.size) {
 		ret = coda_alloc_aux_buf(dev, &dev->tempbuf,
-					 dev->tempbuf.size);
+					 dev->tempbuf.size, "tempbuf",
+					 dev->debugfs_root);
 		if (ret < 0) {
 			dev_err(&pdev->dev, "failed to allocate temp buffer\n");
 			v4l2_device_unregister(&dev->v4l2_dev);
@@ -3834,6 +3870,11 @@ static int coda_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
+	dev->iram.blob.data = dev->iram.vaddr;
+	dev->iram.blob.size = dev->iram.size;
+	dev->iram.dentry = debugfs_create_blob("iram", 0644, dev->debugfs_root,
+					       &dev->iram.blob);
+
 	dev->workqueue = alloc_workqueue("coda", WQ_UNBOUND | WQ_MEM_RECLAIM, 1);
 	if (!dev->workqueue) {
 		dev_err(&pdev->dev, "unable to alloc workqueue\n");
@@ -3865,6 +3906,7 @@ static int coda_remove(struct platform_device *pdev)
 	coda_free_aux_buf(dev, &dev->codebuf);
 	coda_free_aux_buf(dev, &dev->tempbuf);
 	coda_free_aux_buf(dev, &dev->workbuf);
+	debugfs_remove_recursive(dev->debugfs_root);
 	return 0;
 }
 
-- 
2.0.0

