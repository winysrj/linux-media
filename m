Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46723 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753776AbaBOUvi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Feb 2014 15:51:38 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, k.debski@samsung.com,
	hverkuil@xs4all.nl, Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH v5 6/7] v4l: Copy timestamp source flags to destination on m2m devices
Date: Sat, 15 Feb 2014 22:53:04 +0200
Message-Id: <1392497585-5084-7-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1392497585-5084-1-git-send-email-sakari.ailus@iki.fi>
References: <1392497585-5084-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Copy the flags containing the timestamp source from source buffer flags to
the destination buffer flags on memory-to-memory devices. This is analogous
to copying the timestamp field from source to destination.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/platform/coda.c                |    3 +++
 drivers/media/platform/exynos-gsc/gsc-m2m.c  |    4 ++++
 drivers/media/platform/exynos4-is/fimc-m2m.c |    3 +++
 drivers/media/platform/m2m-deinterlace.c     |    3 +++
 drivers/media/platform/mem2mem_testdev.c     |    3 +++
 drivers/media/platform/mx2_emmaprp.c         |    5 +++++
 drivers/media/platform/s5p-g2d/g2d.c         |    3 +++
 drivers/media/platform/s5p-jpeg/jpeg-core.c  |    3 +++
 drivers/media/platform/s5p-mfc/s5p_mfc.c     |    5 +++++
 drivers/media/platform/ti-vpe/vpe.c          |    2 ++
 10 files changed, 34 insertions(+)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index 61f3dbc..fe6dee6 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -2829,6 +2829,9 @@ static void coda_finish_encode(struct coda_ctx *ctx)
 	}
 
 	dst_buf->v4l2_buf.timestamp = src_buf->v4l2_buf.timestamp;
+	dst_buf->v4l2_buf.flags &= ~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
+	dst_buf->v4l2_buf.flags |=
+		src_buf->v4l2_buf.flags & V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
 	dst_buf->v4l2_buf.timecode = src_buf->v4l2_buf.timecode;
 
 	v4l2_m2m_buf_done(src_buf, VB2_BUF_STATE_DONE);
diff --git a/drivers/media/platform/exynos-gsc/gsc-m2m.c b/drivers/media/platform/exynos-gsc/gsc-m2m.c
index 62c84d5..4260ea5 100644
--- a/drivers/media/platform/exynos-gsc/gsc-m2m.c
+++ b/drivers/media/platform/exynos-gsc/gsc-m2m.c
@@ -90,6 +90,10 @@ void gsc_m2m_job_finish(struct gsc_ctx *ctx, int vb_state)
 	if (src_vb && dst_vb) {
 		dst_vb->v4l2_buf.timestamp = src_vb->v4l2_buf.timestamp;
 		dst_vb->v4l2_buf.timecode = src_vb->v4l2_buf.timecode;
+		dst_vb->v4l2_buf.flags &= ~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
+		dst_vb->v4l2_buf.flags |=
+			src_vb->v4l2_buf.flags
+			& V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
 
 		v4l2_m2m_buf_done(src_vb, vb_state);
 		v4l2_m2m_buf_done(dst_vb, vb_state);
diff --git a/drivers/media/platform/exynos4-is/fimc-m2m.c b/drivers/media/platform/exynos4-is/fimc-m2m.c
index 9da95bd..a4249a1 100644
--- a/drivers/media/platform/exynos4-is/fimc-m2m.c
+++ b/drivers/media/platform/exynos4-is/fimc-m2m.c
@@ -134,6 +134,9 @@ static void fimc_device_run(void *priv)
 		goto dma_unlock;
 
 	dst_vb->v4l2_buf.timestamp = src_vb->v4l2_buf.timestamp;
+	dst_vb->v4l2_buf.flags &= ~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
+	dst_vb->v4l2_buf.flags |=
+		src_vb->v4l2_buf.flags & V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
 
 	/* Reconfigure hardware if the context has changed. */
 	if (fimc->m2m.ctx != ctx) {
diff --git a/drivers/media/platform/m2m-deinterlace.c b/drivers/media/platform/m2m-deinterlace.c
index 1f272d3..79ffdab 100644
--- a/drivers/media/platform/m2m-deinterlace.c
+++ b/drivers/media/platform/m2m-deinterlace.c
@@ -208,6 +208,9 @@ static void dma_callback(void *data)
 	dst_vb = v4l2_m2m_dst_buf_remove(curr_ctx->m2m_ctx);
 
 	dst_vb->v4l2_buf.timestamp = src_vb->v4l2_buf.timestamp;
+	dst_vb->v4l2_buf.flags &= ~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
+	dst_vb->v4l2_buf.flags |=
+		src_vb->v4l2_buf.flags & V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
 	dst_vb->v4l2_buf.timecode = src_vb->v4l2_buf.timecode;
 
 	v4l2_m2m_buf_done(src_vb, VB2_BUF_STATE_DONE);
diff --git a/drivers/media/platform/mem2mem_testdev.c b/drivers/media/platform/mem2mem_testdev.c
index 08e2437..b91da7f 100644
--- a/drivers/media/platform/mem2mem_testdev.c
+++ b/drivers/media/platform/mem2mem_testdev.c
@@ -239,6 +239,9 @@ static int device_process(struct m2mtest_ctx *ctx,
 	memcpy(&out_vb->v4l2_buf.timestamp,
 			&in_vb->v4l2_buf.timestamp,
 			sizeof(struct timeval));
+	out_vb->v4l2_buf.flags &= ~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
+	out_vb->v4l2_buf.flags |=
+		in_vb->v4l2_buf.flags & V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
 
 	switch (ctx->mode) {
 	case MEM2MEM_HFLIP | MEM2MEM_VFLIP:
diff --git a/drivers/media/platform/mx2_emmaprp.c b/drivers/media/platform/mx2_emmaprp.c
index 91056ac0..0f59082 100644
--- a/drivers/media/platform/mx2_emmaprp.c
+++ b/drivers/media/platform/mx2_emmaprp.c
@@ -378,6 +378,11 @@ static irqreturn_t emmaprp_irq(int irq_emma, void *data)
 			dst_vb = v4l2_m2m_dst_buf_remove(curr_ctx->m2m_ctx);
 
 			dst_vb->v4l2_buf.timestamp = src_vb->v4l2_buf.timestamp;
+			dst_vb->v4l2_buf.flags &=
+				~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
+			dst_vb->v4l2_buf.flags |=
+				src_vb->v4l2_buf.flags
+				& V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
 			dst_vb->v4l2_buf.timecode = src_vb->v4l2_buf.timecode;
 
 			spin_lock_irqsave(&pcdev->irqlock, flags);
diff --git a/drivers/media/platform/s5p-g2d/g2d.c b/drivers/media/platform/s5p-g2d/g2d.c
index 0fcf7d7..48fe6ea 100644
--- a/drivers/media/platform/s5p-g2d/g2d.c
+++ b/drivers/media/platform/s5p-g2d/g2d.c
@@ -560,6 +560,9 @@ static irqreturn_t g2d_isr(int irq, void *prv)
 
 	dst->v4l2_buf.timecode = src->v4l2_buf.timecode;
 	dst->v4l2_buf.timestamp = src->v4l2_buf.timestamp;
+	dst->v4l2_buf.flags &= ~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
+	dst->v4l2_buf.flags |=
+		src->v4l2_buf.flags & V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
 
 	v4l2_m2m_buf_done(src, VB2_BUF_STATE_DONE);
 	v4l2_m2m_buf_done(dst, VB2_BUF_STATE_DONE);
diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index a1c78c8..7b10120 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -1766,6 +1766,9 @@ static irqreturn_t s5p_jpeg_irq(int irq, void *dev_id)
 
 	dst_buf->v4l2_buf.timecode = src_buf->v4l2_buf.timecode;
 	dst_buf->v4l2_buf.timestamp = src_buf->v4l2_buf.timestamp;
+	dst_buf->v4l2_buf.flags &= ~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
+	dst_buf->v4l2_buf.flags |=
+		src_buf->v4l2_buf.flags & V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
 
 	v4l2_m2m_buf_done(src_buf, state);
 	if (curr_ctx->mode == S5P_JPEG_ENCODE)
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index e2aac59..702ca1b 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -232,6 +232,11 @@ static void s5p_mfc_handle_frame_copy_time(struct s5p_mfc_ctx *ctx)
 						src_buf->b->v4l2_buf.timecode;
 			dst_buf->b->v4l2_buf.timestamp =
 						src_buf->b->v4l2_buf.timestamp;
+			dst_buf->b->v4l2_buf.flags &=
+				~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
+			dst_buf->b->v4l2_buf.flags |=
+				src_buf->b->v4l2_buf.flags
+				& V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
 			switch (frame_type) {
 			case S5P_FIMV_DECODE_FRAME_I_FRAME:
 				dst_buf->b->v4l2_buf.flags |=
diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
index 1296c53..d67c467 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -1278,6 +1278,8 @@ static irqreturn_t vpe_irq(int irq_vpe, void *data)
 	d_buf = &d_vb->v4l2_buf;
 
 	d_buf->timestamp = s_buf->timestamp;
+	d_buf->flags &= ~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
+	d_buf->flags |= s_buf->flags & V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
 	if (s_buf->flags & V4L2_BUF_FLAG_TIMECODE) {
 		d_buf->flags |= V4L2_BUF_FLAG_TIMECODE;
 		d_buf->timecode = s_buf->timecode;
-- 
1.7.10.4

