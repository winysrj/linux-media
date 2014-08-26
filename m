Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44171 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755796AbaHZVzW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Aug 2014 17:55:22 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v2 22/35] [media] s5p_mfc: get rid of several warnings
Date: Tue, 26 Aug 2014 18:54:58 -0300
Message-Id: <1409090111-8290-23-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1409090111-8290-1-git-send-email-m.chehab@samsung.com>
References: <1409090111-8290-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/platform/s5p-mfc/s5p_mfc_dec.c:826:5: warning: no previous prototype for 'vidioc_decoder_cmd' [-Wmissing-prototypes]
 int vidioc_decoder_cmd(struct file *file, void *priv,
     ^
drivers/media/platform/s5p-mfc/s5p_mfc.c: In function 's5p_mfc_runtime_resume':
drivers/media/platform/s5p-mfc/s5p_mfc.c:1314:6: warning: variable 'pre_power' set but not used [-Wunused-but-set-variable]
  int pre_power;
      ^
drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v5.c:163:25: warning: no previous prototype for 's5p_mfc_init_hw_cmds_v5' [-Wmissing-prototypes]
 struct s5p_mfc_hw_cmds *s5p_mfc_init_hw_cmds_v5(void)
                         ^
drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.c:156:25: warning: no previous prototype for 's5p_mfc_init_hw_cmds_v6' [-Wmissing-prototypes]
 struct s5p_mfc_hw_cmds *s5p_mfc_init_hw_cmds_v6(void)
                         ^
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c: In function 's5p_mfc_run_dec_frame':
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c:1189:15: warning: variable 'index' set but not used [-Wunused-but-set-variable]
  unsigned int index;
               ^
drivers/media/platform/s5p-mfc/s5p_mfc_enc.c: In function 'cleanup_ref_queue':
drivers/media/platform/s5p-mfc/s5p_mfc_enc.c:742:27: warning: variable 'mb_c_addr' set but not used [-Wunused-but-set-variable]
  unsigned long mb_y_addr, mb_c_addr;
                           ^
drivers/media/platform/s5p-mfc/s5p_mfc_enc.c:742:16: warning: variable 'mb_y_addr' set but not used [-Wunused-but-set-variable]
  unsigned long mb_y_addr, mb_c_addr;
                ^
drivers/media/platform/s5p-mfc/s5p_mfc_enc.c: At top level:
drivers/media/platform/s5p-mfc/s5p_mfc_enc.c:1684:5: warning: no previous prototype for 'vidioc_encoder_cmd' [-Wmissing-prototypes]
 int vidioc_encoder_cmd(struct file *file, void *priv,
     ^

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c        | 2 --
 drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v5.c | 1 +
 drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.c | 1 +
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c    | 4 ++--
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c    | 7 ++-----
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c | 2 --
 6 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index 89b5b4ad34d3..d180440ac43e 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -1311,11 +1311,9 @@ static int s5p_mfc_runtime_resume(struct device *dev)
 {
 	struct platform_device *pdev = to_platform_device(dev);
 	struct s5p_mfc_dev *m_dev = platform_get_drvdata(pdev);
-	int pre_power;
 
 	if (!m_dev->alloc_ctx)
 		return 0;
-	pre_power = atomic_read(&m_dev->pm.power);
 	atomic_set(&m_dev->pm.power, 1);
 	return 0;
 }
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v5.c b/drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v5.c
index 9a6efd6c1329..8c4739ca16d6 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v5.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v5.c
@@ -14,6 +14,7 @@
 #include "s5p_mfc_cmd.h"
 #include "s5p_mfc_common.h"
 #include "s5p_mfc_debug.h"
+#include "s5p_mfc_cmd_v5.h"
 
 /* This function is used to send a command to the MFC */
 static int s5p_mfc_cmd_host2risc_v5(struct s5p_mfc_dev *dev, int cmd,
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.c b/drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.c
index ec1a5947ed7d..f17609669b96 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.c
@@ -16,6 +16,7 @@
 #include "s5p_mfc_debug.h"
 #include "s5p_mfc_intr.h"
 #include "s5p_mfc_opr.h"
+#include "s5p_mfc_cmd_v6.h"
 
 static int s5p_mfc_cmd_host2risc_v6(struct s5p_mfc_dev *dev, int cmd,
 				struct s5p_mfc_cmd_args *args)
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
index 9103258b7df3..fe4d21ccfd49 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
@@ -823,8 +823,8 @@ static int vidioc_g_crop(struct file *file, void *priv,
 	return 0;
 }
 
-int vidioc_decoder_cmd(struct file *file, void *priv,
-						struct v4l2_decoder_cmd *cmd)
+static int vidioc_decoder_cmd(struct file *file, void *priv,
+			      struct v4l2_decoder_cmd *cmd)
 {
 	struct s5p_mfc_ctx *ctx = fh_to_ctx(priv);
 	struct s5p_mfc_dev *dev = ctx->dev;
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
index d26b2484ca10..41f3b7f512fa 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
@@ -739,14 +739,11 @@ static int s5p_mfc_ctx_ready(struct s5p_mfc_ctx *ctx)
 static void cleanup_ref_queue(struct s5p_mfc_ctx *ctx)
 {
 	struct s5p_mfc_buf *mb_entry;
-	unsigned long mb_y_addr, mb_c_addr;
 
 	/* move buffers in ref queue to src queue */
 	while (!list_empty(&ctx->ref_queue)) {
 		mb_entry = list_entry((&ctx->ref_queue)->next,
 						struct s5p_mfc_buf, list);
-		mb_y_addr = vb2_dma_contig_plane_dma_addr(mb_entry->b, 0);
-		mb_c_addr = vb2_dma_contig_plane_dma_addr(mb_entry->b, 1);
 		list_del(&mb_entry->list);
 		ctx->ref_queue_cnt--;
 		list_add_tail(&mb_entry->list, &ctx->src_queue);
@@ -1681,8 +1678,8 @@ static int vidioc_g_parm(struct file *file, void *priv,
 	return 0;
 }
 
-int vidioc_encoder_cmd(struct file *file, void *priv,
-						struct v4l2_encoder_cmd *cmd)
+static int vidioc_encoder_cmd(struct file *file, void *priv,
+			      struct v4l2_encoder_cmd *cmd)
 {
 	struct s5p_mfc_ctx *ctx = fh_to_ctx(priv);
 	struct s5p_mfc_dev *dev = ctx->dev;
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
index 58ec7bb26ebc..31688cddfead 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
@@ -1186,7 +1186,6 @@ static int s5p_mfc_run_dec_frame(struct s5p_mfc_ctx *ctx, int last_frame)
 	struct s5p_mfc_dev *dev = ctx->dev;
 	struct s5p_mfc_buf *temp_vb;
 	unsigned long flags;
-	unsigned int index;
 
 	if (ctx->state == MFCINST_FINISHING) {
 		last_frame = MFC_DEC_LAST_FRAME;
@@ -1211,7 +1210,6 @@ static int s5p_mfc_run_dec_frame(struct s5p_mfc_ctx *ctx, int last_frame)
 		vb2_dma_contig_plane_dma_addr(temp_vb->b, 0),
 		ctx->consumed_stream, temp_vb->b->v4l2_planes[0].bytesused);
 	spin_unlock_irqrestore(&dev->irqlock, flags);
-	index = temp_vb->b->v4l2_buf.index;
 	dev->curr_ctx = ctx->num;
 	s5p_mfc_clean_ctx_int_flags(ctx);
 	if (temp_vb->b->v4l2_planes[0].bytesused == 0) {
-- 
1.9.3

