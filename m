Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:27211 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755839Ab2KVTNH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Nov 2012 14:13:07 -0500
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MDV003NIHZ6FJ40@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Thu, 22 Nov 2012 14:02:28 +0900 (KST)
Received: from localhost.localdomain ([107.108.73.106])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MDV00KHRHYSU450@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 22 Nov 2012 14:02:28 +0900 (KST)
From: Shaik Ameer Basha <shaik.ameer@samsung.com>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com, kgene.kim@samsung.com
Subject: [PATCH v2] [media] exynos-gsc: propagate timestamps from src to dst
 buffers
Date: Thu, 22 Nov 2012 10:55:06 +0530
Message-id: <1353561906-7869-1-git-send-email-shaik.ameer@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make gsc-m2m propagate the timestamp field from source to destination
buffers

Signed-off-by: John Sheu <sheu@google.com>
Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
---
 drivers/media/platform/exynos-gsc/gsc-m2m.c |   20 +++++++++++++-------
 1 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/media/platform/exynos-gsc/gsc-m2m.c b/drivers/media/platform/exynos-gsc/gsc-m2m.c
index 047f0f0..39dff20 100644
--- a/drivers/media/platform/exynos-gsc/gsc-m2m.c
+++ b/drivers/media/platform/exynos-gsc/gsc-m2m.c
@@ -99,22 +99,28 @@ static void gsc_m2m_job_abort(void *priv)
 		gsc_m2m_job_finish(ctx, VB2_BUF_STATE_ERROR);
 }
 
-static int gsc_fill_addr(struct gsc_ctx *ctx)
+static int gsc_get_bufs(struct gsc_ctx *ctx)
 {
 	struct gsc_frame *s_frame, *d_frame;
-	struct vb2_buffer *vb = NULL;
+	struct vb2_buffer *src_vb, *dst_vb;
 	int ret;
 
 	s_frame = &ctx->s_frame;
 	d_frame = &ctx->d_frame;
 
-	vb = v4l2_m2m_next_src_buf(ctx->m2m_ctx);
-	ret = gsc_prepare_addr(ctx, vb, s_frame, &s_frame->addr);
+	src_vb = v4l2_m2m_next_src_buf(ctx->m2m_ctx);
+	ret = gsc_prepare_addr(ctx, src_vb, s_frame, &s_frame->addr);
+	if (ret)
+		return ret;
+
+	dst_vb = v4l2_m2m_next_dst_buf(ctx->m2m_ctx);
+	ret = gsc_prepare_addr(ctx, dst_vb, d_frame, &d_frame->addr);
 	if (ret)
 		return ret;
 
-	vb = v4l2_m2m_next_dst_buf(ctx->m2m_ctx);
-	return gsc_prepare_addr(ctx, vb, d_frame, &d_frame->addr);
+	dst_vb->v4l2_buf.timestamp = src_vb->v4l2_buf.timestamp;
+
+	return 0;
 }
 
 static void gsc_m2m_device_run(void *priv)
@@ -148,7 +154,7 @@ static void gsc_m2m_device_run(void *priv)
 		goto put_device;
 	}
 
-	ret = gsc_fill_addr(ctx);
+	ret = gsc_get_bufs(ctx);
 	if (ret) {
 		pr_err("Wrong address");
 		goto put_device;
-- 
1.7.0.4

