Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:34090 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750999AbdAUJaB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 21 Jan 2017 04:30:01 -0500
From: Bhumika Goyal <bhumirks@gmail.com>
To: julia.lawall@lip6.fr, prabhakar.csengg@gmail.com,
        mchehab@kernel.org, minghsiu.tsai@mediatek.com,
        houlong.wei@mediatek.com, andrew-ct.chen@mediatek.com,
        matthias.bgg@gmail.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Cc: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH] media: platform: constify vb2_ops structures
Date: Sat, 21 Jan 2017 14:59:44 +0530
Message-Id: <1484990984-16136-1-git-send-email-bhumirks@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Declare vb2_ops structures as const as they are only stored in
the ops field of a vb2_queue structure. This field is of type
const, so vb2_ops structures having same properties can be made
const too.
Done using Coccinelle:

@r1 disable optional_qualifier@
identifier i;
position p;
@@
static struct vb2_ops i@p={...};

@ok1@
identifier r1.i;
position p;
struct sta2x11_vip vip;
struct vb2_queue q;
@@
(
vip.vb_vidq.ops=&i@p
|
q.ops=&i@p
)

@bad@
position p!={r1.p,ok1.p};
identifier r1.i;
@@
i@p

@depends on !bad disable optional_qualifier@
identifier r1.i;
@@
+const
struct vb2_ops i;

Cross compiled the media/platform/blackfin/bfin_capture.o file for
blackfin architecture.

File size before:
  text	   data	    bss	    dec	    hex	filename
  6776	    176	      0	   6952	   1b28 platform/blackfin/bfin_capture.o

File size after:
   text	   data	    bss	    dec	    hex	filename
   6816	    136	      0	   6952	   1b28 platform/blackfin/bfin_capture.o

File size before:
   text	   data	    bss	    dec	    hex	filename
  12852	    456	    272	  13580	   350c platform/davinci/vpif_capture.o

File size after:
   text	   data	    bss	    dec	    hex	filename
  12932	    360	    272	  13564	   34fc platform/davinci/vpif_capture.o

File size before:
   text	   data	    bss	    dec	    hex	filename
  12285	    360	    276	  12921	   3279 platform/davinci/vpif_display.o

File size after:
   text	   data	    bss	    dec	    hex	filename
  12365	    296	    276	  12937	   3289 platform/davinci/vpif_display.o

File size details before and after applying the patch remains the same for
drivers/media/platform/pxa_camera.o

Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
---
 drivers/media/platform/davinci/vpif_capture.c | 2 +-
 drivers/media/platform/davinci/vpif_display.c | 2 +-
 drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c  | 2 +-
 drivers/media/platform/pxa_camera.c           | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index f791f5c..54c54d9 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -309,7 +309,7 @@ static void vpif_stop_streaming(struct vb2_queue *vq)
 	spin_unlock_irqrestore(&common->irqlock, flags);
 }
 
-static struct vb2_ops video_qops = {
+static const struct vb2_ops video_qops = {
 	.queue_setup		= vpif_buffer_queue_setup,
 	.buf_prepare		= vpif_buffer_prepare,
 	.start_streaming	= vpif_start_streaming,
diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
index e5f1844..9604afd 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -289,7 +289,7 @@ static void vpif_stop_streaming(struct vb2_queue *vq)
 	spin_unlock_irqrestore(&common->irqlock, flags);
 }
 
-static struct vb2_ops video_qops = {
+static const struct vb2_ops video_qops = {
 	.queue_setup		= vpif_buffer_queue_setup,
 	.wait_prepare		= vb2_ops_wait_prepare,
 	.wait_finish		= vb2_ops_wait_finish,
diff --git a/drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c b/drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c
index 13afe48..3038d62 100644
--- a/drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c
+++ b/drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c
@@ -621,7 +621,7 @@ static void mtk_mdp_m2m_buf_queue(struct vb2_buffer *vb)
 	v4l2_m2m_buf_queue(ctx->m2m_ctx, to_vb2_v4l2_buffer(vb));
 }
 
-static struct vb2_ops mtk_mdp_m2m_qops = {
+static const struct vb2_ops mtk_mdp_m2m_qops = {
 	.queue_setup	 = mtk_mdp_m2m_queue_setup,
 	.buf_prepare	 = mtk_mdp_m2m_buf_prepare,
 	.buf_queue	 = mtk_mdp_m2m_buf_queue,
diff --git a/drivers/media/platform/pxa_camera.c b/drivers/media/platform/pxa_camera.c
index 929006f..17167d1 100644
--- a/drivers/media/platform/pxa_camera.c
+++ b/drivers/media/platform/pxa_camera.c
@@ -1530,7 +1530,7 @@ static void pxac_vb2_stop_streaming(struct vb2_queue *vq)
 		pxa_camera_wakeup(pcdev, buf, VB2_BUF_STATE_ERROR);
 }
 
-static struct vb2_ops pxac_vb2_ops = {
+static const struct vb2_ops pxac_vb2_ops = {
 	.queue_setup		= pxac_vb2_queue_setup,
 	.buf_init		= pxac_vb2_init,
 	.buf_prepare		= pxac_vb2_prepare,
-- 
1.9.1

