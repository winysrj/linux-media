Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:65236 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835Ab2IZHVt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Sep 2012 03:21:49 -0400
Received: by pbbrr4 with SMTP id rr4so1445093pbb.19
        for <linux-media@vger.kernel.org>; Wed, 26 Sep 2012 00:21:49 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com, shaik.ameer@samsung.com,
	sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 2/2] [media] exynos-gsc: Add missing static storage class specifiers
Date: Wed, 26 Sep 2012 12:48:04 +0530
Message-Id: <1348643884-4005-2-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1348643884-4005-1-git-send-email-sachin.kamat@linaro.org>
References: <1348643884-4005-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixes the following warnings:
drivers/media/platform/exynos-gsc/gsc-core.c:313:5: warning:
symbol 'get_plane_info' was not declared. Should it be static?
drivers/media/platform/exynos-gsc/gsc-core.c:746:28: warning:
symbol 'gsc_ctrl_ops' was not declared. Should it be static?
drivers/media/platform/exynos-gsc/gsc-m2m.c:102:5: warning:
symbol 'gsc_fill_addr' was not declared. Should it be static?
drivers/media/platform/exynos-gsc/gsc-m2m.c:252:16: warning:
symbol 'gsc_m2m_qops' was not declared. Should it be static?

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/platform/exynos-gsc/gsc-core.c |    4 ++--
 drivers/media/platform/exynos-gsc/gsc-m2m.c  |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/exynos-gsc/gsc-core.c b/drivers/media/platform/exynos-gsc/gsc-core.c
index 90a6c55..bfec9e6 100644
--- a/drivers/media/platform/exynos-gsc/gsc-core.c
+++ b/drivers/media/platform/exynos-gsc/gsc-core.c
@@ -310,7 +310,7 @@ int gsc_enum_fmt_mplane(struct v4l2_fmtdesc *f)
 	return 0;
 }
 
-u32 get_plane_info(struct gsc_frame *frm, u32 addr, u32 *index)
+static u32 get_plane_info(struct gsc_frame *frm, u32 addr, u32 *index)
 {
 	if (frm->addr.y == addr) {
 		*index = 0;
@@ -743,7 +743,7 @@ static int gsc_s_ctrl(struct v4l2_ctrl *ctrl)
 	return ret;
 }
 
-const struct v4l2_ctrl_ops gsc_ctrl_ops = {
+static const struct v4l2_ctrl_ops gsc_ctrl_ops = {
 	.s_ctrl = gsc_s_ctrl,
 };
 
diff --git a/drivers/media/platform/exynos-gsc/gsc-m2m.c b/drivers/media/platform/exynos-gsc/gsc-m2m.c
index a4f327e..3c7f005 100644
--- a/drivers/media/platform/exynos-gsc/gsc-m2m.c
+++ b/drivers/media/platform/exynos-gsc/gsc-m2m.c
@@ -99,7 +99,7 @@ static void gsc_m2m_job_abort(void *priv)
 		gsc_m2m_job_finish(ctx, VB2_BUF_STATE_ERROR);
 }
 
-int gsc_fill_addr(struct gsc_ctx *ctx)
+static int gsc_fill_addr(struct gsc_ctx *ctx)
 {
 	struct gsc_frame *s_frame, *d_frame;
 	struct vb2_buffer *vb = NULL;
@@ -249,7 +249,7 @@ static void gsc_m2m_buf_queue(struct vb2_buffer *vb)
 		v4l2_m2m_buf_queue(ctx->m2m_ctx, vb);
 }
 
-struct vb2_ops gsc_m2m_qops = {
+static struct vb2_ops gsc_m2m_qops = {
 	.queue_setup	 = gsc_m2m_queue_setup,
 	.buf_prepare	 = gsc_m2m_buf_prepare,
 	.buf_queue	 = gsc_m2m_buf_queue,
-- 
1.7.4.1

