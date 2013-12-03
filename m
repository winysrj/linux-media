Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:17949 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753209Ab3LCNNI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Dec 2013 08:13:08 -0500
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kamil Debski <k.debski@samsung.com>, lxr1234@hotmail.com,
	jtp.park@samsung.com, m.chehab@samsung.com,
	kyungmin.park@samsung.com, stable@vger.kernel.org
Subject: [PATCH] media: s5p_mfc: remove s5p_mfc_get_node_type() function
Date: Tue, 03 Dec 2013 14:12:51 +0100
Message-id: <1386076371-26699-1-git-send-email-m.szyprowski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

s5p_mfc_get_node_type() relies on get_index() helper function, which in
turn relies on video_device index numbers assigned on driver
registration. All this code is not really needed, because there is
already access to respective video_device structures via common
s5p_mfc_dev structure. This fixes the issues introduced by patch
1056e4388b0454917a512618c8416a98628fc9ce ("v4l2-dev: Fix race condition
on __video_register_device"), which has been merged in v3.12-rc1.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: stable@vger.kernel.org
---
This patch should be applied also to stable v3.12 series.
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c        |   28 ++++++-----------------
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h |    9 --------
 2 files changed, 7 insertions(+), 30 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index 80562809b28a..bd750a1e8632 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -178,21 +178,6 @@ unlock:
 		mutex_unlock(&dev->mfc_mutex);
 }
 
-static enum s5p_mfc_node_type s5p_mfc_get_node_type(struct file *file)
-{
-	struct video_device *vdev = video_devdata(file);
-
-	if (!vdev) {
-		mfc_err("failed to get video_device");
-		return MFCNODE_INVALID;
-	}
-	if (vdev->index == 0)
-		return MFCNODE_DECODER;
-	else if (vdev->index == 1)
-		return MFCNODE_ENCODER;
-	return MFCNODE_INVALID;
-}
-
 static void s5p_mfc_clear_int_flags(struct s5p_mfc_dev *dev)
 {
 	mfc_write(dev, 0, S5P_FIMV_RISC_HOST_INT);
@@ -706,6 +691,7 @@ irq_cleanup_hw:
 /* Open an MFC node */
 static int s5p_mfc_open(struct file *file)
 {
+	struct video_device *vdev = video_devdata(file);
 	struct s5p_mfc_dev *dev = video_drvdata(file);
 	struct s5p_mfc_ctx *ctx = NULL;
 	struct vb2_queue *q;
@@ -743,7 +729,7 @@ static int s5p_mfc_open(struct file *file)
 	/* Mark context as idle */
 	clear_work_bit_irqsave(ctx);
 	dev->ctx[ctx->num] = ctx;
-	if (s5p_mfc_get_node_type(file) == MFCNODE_DECODER) {
+	if (vdev == dev->vfd_dec) {
 		ctx->type = MFCINST_DECODER;
 		ctx->c_ops = get_dec_codec_ops();
 		s5p_mfc_dec_init(ctx);
@@ -753,7 +739,7 @@ static int s5p_mfc_open(struct file *file)
 			mfc_err("Failed to setup mfc controls\n");
 			goto err_ctrls_setup;
 		}
-	} else if (s5p_mfc_get_node_type(file) == MFCNODE_ENCODER) {
+	} else if (vdev == dev->vfd_enc) {
 		ctx->type = MFCINST_ENCODER;
 		ctx->c_ops = get_enc_codec_ops();
 		/* only for encoder */
@@ -798,10 +784,10 @@ static int s5p_mfc_open(struct file *file)
 	q = &ctx->vq_dst;
 	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
 	q->drv_priv = &ctx->fh;
-	if (s5p_mfc_get_node_type(file) == MFCNODE_DECODER) {
+	if (vdev == dev->vfd_dec) {
 		q->io_modes = VB2_MMAP;
 		q->ops = get_dec_queue_ops();
-	} else if (s5p_mfc_get_node_type(file) == MFCNODE_ENCODER) {
+	} else if (vdev == dev->vfd_enc) {
 		q->io_modes = VB2_MMAP | VB2_USERPTR;
 		q->ops = get_enc_queue_ops();
 	} else {
@@ -820,10 +806,10 @@ static int s5p_mfc_open(struct file *file)
 	q->type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
 	q->io_modes = VB2_MMAP;
 	q->drv_priv = &ctx->fh;
-	if (s5p_mfc_get_node_type(file) == MFCNODE_DECODER) {
+	if (vdev == dev->vfd_dec) {
 		q->io_modes = VB2_MMAP;
 		q->ops = get_dec_queue_ops();
-	} else if (s5p_mfc_get_node_type(file) == MFCNODE_ENCODER) {
+	} else if (vdev == dev->vfd_enc) {
 		q->io_modes = VB2_MMAP | VB2_USERPTR;
 		q->ops = get_enc_queue_ops();
 	} else {
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
index 6920b546181a..823812c6b9b0 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
@@ -115,15 +115,6 @@ enum s5p_mfc_fmt_type {
 };
 
 /**
- * enum s5p_mfc_node_type - The type of an MFC device node.
- */
-enum s5p_mfc_node_type {
-	MFCNODE_INVALID = -1,
-	MFCNODE_DECODER = 0,
-	MFCNODE_ENCODER = 1,
-};
-
-/**
  * enum s5p_mfc_inst_type - The type of an MFC instance.
  */
 enum s5p_mfc_inst_type {
-- 
1.7.9.5

