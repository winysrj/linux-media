Return-path: <mchehab@gaivota>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:27968 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753333Ab1DKJHv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Apr 2011 05:07:51 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Mon, 11 Apr 2011 11:07:43 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 2/4] s5p-fimc: Do not allow changing format after REQBUFS
In-reply-to: <1302512865-20379-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com
Message-id: <1302512865-20379-3-git-send-email-s.nawrocki@samsung.com>
References: <1302512865-20379-1-git-send-email-s.nawrocki@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Protecting the color format with vb2_is_streaming() is not sufficient
as this prevents changing the format only after VIDIOC_STREAMON.
To prevent the color format reconfiguration as soon as buffers
are allocated use vb2_is_busy() instead.
Also make the videobuf queue ops structure static.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-capture.c |    2 +-
 drivers/media/video/s5p-fimc/fimc-core.c    |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index 95f8b4e1..00c561c 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -527,7 +527,7 @@ static int fimc_cap_s_fmt_mplane(struct file *file, void *priv,
 	if (ret)
 		return ret;
 
-	if (vb2_is_streaming(&fimc->vid_cap.vbq) || fimc_capture_active(fimc))
+	if (vb2_is_busy(&fimc->vid_cap.vbq) || fimc_capture_active(fimc))
 		return -EBUSY;
 
 	frame = &ctx->d_frame;
diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index d54e6d85..115a1e0 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -758,7 +758,7 @@ static void fimc_unlock(struct vb2_queue *vq)
 	mutex_unlock(&ctx->fimc_dev->lock);
 }
 
-struct vb2_ops fimc_qops = {
+static struct vb2_ops fimc_qops = {
 	.queue_setup	 = fimc_queue_setup,
 	.buf_prepare	 = fimc_buf_prepare,
 	.buf_queue	 = fimc_buf_queue,
@@ -965,7 +965,7 @@ static int fimc_m2m_s_fmt_mplane(struct file *file, void *priv,
 
 	vq = v4l2_m2m_get_vq(ctx->m2m_ctx, f->type);
 
-	if (vb2_is_streaming(vq)) {
+	if (vb2_is_busy(vq)) {
 		v4l2_err(&fimc->m2m.v4l2_dev, "queue (%d) busy\n", f->type);
 		return -EBUSY;
 	}
-- 
1.7.4.3
