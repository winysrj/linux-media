Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:45718 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752630AbaCANOA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 1 Mar 2014 08:14:00 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, k.debski@samsung.com,
	laurent.pinchart@ideasonboard.com
Subject: [PATH v6 08/10] exynos-gsc, m2m-deinterlace, mx2_emmaprp: Copy v4l2_buffer data from src to dst
Date: Sat,  1 Mar 2014 15:17:05 +0200
Message-Id: <1393679828-25878-9-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1393679828-25878-1-git-send-email-sakari.ailus@iki.fi>
References: <1393679828-25878-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The timestamp and timecode fields were copied from destination to source,
not the other way around as they should. Fix it.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
Acked-by: Kamil Debski <k.debski@samsung.com>
---
 drivers/media/platform/exynos-gsc/gsc-m2m.c |    4 ++--
 drivers/media/platform/m2m-deinterlace.c    |    4 ++--
 drivers/media/platform/mx2_emmaprp.c        |    4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/exynos-gsc/gsc-m2m.c b/drivers/media/platform/exynos-gsc/gsc-m2m.c
index 6741025..3a842ee 100644
--- a/drivers/media/platform/exynos-gsc/gsc-m2m.c
+++ b/drivers/media/platform/exynos-gsc/gsc-m2m.c
@@ -88,8 +88,8 @@ void gsc_m2m_job_finish(struct gsc_ctx *ctx, int vb_state)
 	dst_vb = v4l2_m2m_dst_buf_remove(ctx->m2m_ctx);
 
 	if (src_vb && dst_vb) {
-		src_vb->v4l2_buf.timestamp = dst_vb->v4l2_buf.timestamp;
-		src_vb->v4l2_buf.timecode = dst_vb->v4l2_buf.timecode;
+		dst_vb->v4l2_buf.timestamp = src_vb->v4l2_buf.timestamp;
+		dst_vb->v4l2_buf.timecode = src_vb->v4l2_buf.timecode;
 
 		v4l2_m2m_buf_done(src_vb, vb_state);
 		v4l2_m2m_buf_done(dst_vb, vb_state);
diff --git a/drivers/media/platform/m2m-deinterlace.c b/drivers/media/platform/m2m-deinterlace.c
index f3a9e24..3416131 100644
--- a/drivers/media/platform/m2m-deinterlace.c
+++ b/drivers/media/platform/m2m-deinterlace.c
@@ -207,8 +207,8 @@ static void dma_callback(void *data)
 	src_vb = v4l2_m2m_src_buf_remove(curr_ctx->m2m_ctx);
 	dst_vb = v4l2_m2m_dst_buf_remove(curr_ctx->m2m_ctx);
 
-	src_vb->v4l2_buf.timestamp = dst_vb->v4l2_buf.timestamp;
-	src_vb->v4l2_buf.timecode = dst_vb->v4l2_buf.timecode;
+	dst_vb->v4l2_buf.timestamp = src_vb->v4l2_buf.timestamp;
+	dst_vb->v4l2_buf.timecode = src_vb->v4l2_buf.timecode;
 
 	v4l2_m2m_buf_done(src_vb, VB2_BUF_STATE_DONE);
 	v4l2_m2m_buf_done(dst_vb, VB2_BUF_STATE_DONE);
diff --git a/drivers/media/platform/mx2_emmaprp.c b/drivers/media/platform/mx2_emmaprp.c
index af3e106..6debb02 100644
--- a/drivers/media/platform/mx2_emmaprp.c
+++ b/drivers/media/platform/mx2_emmaprp.c
@@ -377,8 +377,8 @@ static irqreturn_t emmaprp_irq(int irq_emma, void *data)
 			src_vb = v4l2_m2m_src_buf_remove(curr_ctx->m2m_ctx);
 			dst_vb = v4l2_m2m_dst_buf_remove(curr_ctx->m2m_ctx);
 
-			src_vb->v4l2_buf.timestamp = dst_vb->v4l2_buf.timestamp;
-			src_vb->v4l2_buf.timecode = dst_vb->v4l2_buf.timecode;
+			dst_vb->v4l2_buf.timestamp = src_vb->v4l2_buf.timestamp;
+			dst_vb->v4l2_buf.timecode = src_vb->v4l2_buf.timecode;
 
 			spin_lock_irqsave(&pcdev->irqlock, flags);
 			v4l2_m2m_buf_done(src_vb, VB2_BUF_STATE_DONE);
-- 
1.7.10.4

