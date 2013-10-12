Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:59838 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557Ab3JLMcW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Oct 2013 08:32:22 -0400
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, pawel@osciak.com,
	javier.martin@vista-silicon.com, m.szyprowski@samsung.com,
	shaik.ameer@samsung.com, arun.kk@samsung.com, k.debski@samsung.com,
	p.zabel@pengutronix.de, kyungmin.park@samsung.com,
	linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH RFC v2 05/10] mx2-emmaprp: Use struct v4l2_fh
Date: Sat, 12 Oct 2013 14:31:55 +0200
Message-Id: <1381581120-26883-6-git-send-email-s.nawrocki@samsung.com>
In-Reply-To: <1381581120-26883-1-git-send-email-s.nawrocki@samsung.com>
References: <1381581120-26883-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/mx2_emmaprp.c |   54 ++++++++++++++++++++++-----------
 1 files changed, 36 insertions(+), 18 deletions(-)

diff --git a/drivers/media/platform/mx2_emmaprp.c b/drivers/media/platform/mx2_emmaprp.c
index c690435..e91a4d5 100644
--- a/drivers/media/platform/mx2_emmaprp.c
+++ b/drivers/media/platform/mx2_emmaprp.c
@@ -221,9 +221,12 @@ struct emmaprp_ctx {
 	/* Abort requested by m2m */
 	int			aborting;
 	struct emmaprp_q_data	q_data[2];
+	struct v4l2_fh		fh;
 	struct v4l2_m2m_ctx	*m2m_ctx;
 };

+#define fh_to_ctx(__fh) container_of(__fh, struct emmaprp_ctx, fh)
+
 static struct emmaprp_q_data *get_q_data(struct emmaprp_ctx *ctx,
 					 enum v4l2_buf_type type)
 {
@@ -478,13 +481,15 @@ static int vidioc_g_fmt(struct emmaprp_ctx *ctx, struct v4l2_format *f)
 static int vidioc_g_fmt_vid_out(struct file *file, void *priv,
 				struct v4l2_format *f)
 {
-	return vidioc_g_fmt(priv, f);
+	struct emmaprp_ctx *ctx = fh_to_ctx(priv);
+	return vidioc_g_fmt(ctx, f);
 }

 static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
 				struct v4l2_format *f)
 {
-	return vidioc_g_fmt(priv, f);
+	struct emmaprp_ctx *ctx = fh_to_ctx(priv);
+	return vidioc_g_fmt(ctx, f);
 }

 static int vidioc_try_fmt(struct v4l2_format *f)
@@ -524,8 +529,8 @@ static int vidioc_try_fmt(struct v4l2_format *f)
 static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 				  struct v4l2_format *f)
 {
+	struct emmaprp_ctx *ctx = fh_to_ctx(priv);
 	struct emmaprp_fmt *fmt;
-	struct emmaprp_ctx *ctx = priv;

 	fmt = find_format(f);
 	if (!fmt || !(fmt->types & MEM2MEM_CAPTURE)) {
@@ -541,8 +546,8 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 static int vidioc_try_fmt_vid_out(struct file *file, void *priv,
 				  struct v4l2_format *f)
 {
+	struct emmaprp_ctx *ctx = fh_to_ctx(priv);
 	struct emmaprp_fmt *fmt;
-	struct emmaprp_ctx *ctx = priv;

 	fmt = find_format(f);
 	if (!fmt || !(fmt->types & MEM2MEM_OUTPUT)) {
@@ -561,7 +566,7 @@ static int vidioc_s_fmt(struct emmaprp_ctx *ctx, struct v4l2_format *f)
 	struct vb2_queue *vq;
 	int ret;

-	vq = v4l2_m2m_get_vq(ctx->m2m_ctx, f->type);
+	vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx, f->type);
 	if (!vq)
 		return -EINVAL;

@@ -596,25 +601,27 @@ static int vidioc_s_fmt(struct emmaprp_ctx *ctx, struct v4l2_format *f)
 static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 				struct v4l2_format *f)
 {
+	struct emmaprp_ctx *ctx = fh_to_ctx(priv);
 	int ret;

 	ret = vidioc_try_fmt_vid_cap(file, priv, f);
 	if (ret)
 		return ret;

-	return vidioc_s_fmt(priv, f);
+	return vidioc_s_fmt(ctx, f);
 }

 static int vidioc_s_fmt_vid_out(struct file *file, void *priv,
 				struct v4l2_format *f)
 {
+	struct emmaprp_ctx *ctx = fh_to_ctx(priv);
 	int ret;

 	ret = vidioc_try_fmt_vid_out(file, priv, f);
 	if (ret)
 		return ret;

-	return vidioc_s_fmt(priv, f);
+	return vidioc_s_fmt(ctx, f);
 }

 static int vidioc_reqbufs(struct file *file, void *priv,
@@ -790,27 +797,28 @@ static int emmaprp_open(struct file *file)
 {
 	struct emmaprp_dev *pcdev = video_drvdata(file);
 	struct emmaprp_ctx *ctx;
+	int ret;

 	ctx = kzalloc(sizeof *ctx, GFP_KERNEL);
 	if (!ctx)
 		return -ENOMEM;

-	file->private_data = ctx;
-	ctx->dev = pcdev;
-
 	if (mutex_lock_interruptible(&pcdev->dev_mutex)) {
-		kfree(ctx);
-		return -ERESTARTSYS;
+		ret = -ERESTARTSYS;
+		goto err_free;
 	}

+	v4l2_fh_init(&ctx->fh, pcdev->vfd);
+	file->private_data = &ctx->fh;
+	v4l2_fh_add(&ctx->fh);
+
+	ctx->dev = pcdev;
+
 	ctx->m2m_ctx = v4l2_m2m_ctx_init(pcdev->m2m_dev, ctx, &queue_init);

 	if (IS_ERR(ctx->m2m_ctx)) {
-		int ret = PTR_ERR(ctx->m2m_ctx);
-
-		mutex_unlock(&pcdev->dev_mutex);
-		kfree(ctx);
-		return ret;
+		ret = PTR_ERR(ctx->m2m_ctx);
+		goto err_fh;
 	}

 	clk_prepare_enable(pcdev->clk_emma_ipg);
@@ -822,12 +830,20 @@ static int emmaprp_open(struct file *file)
 	dprintk(pcdev, "Created instance %p, m2m_ctx: %p\n", ctx, ctx->m2m_ctx);

 	return 0;
+
+err_fh:
+	v4l2_fh_del(&ctx->fh);
+	v4l2_fh_exit(&ctx->fh);
+err_free:
+	kfree(ctx);
+	mutex_unlock(&pcdev->dev_mutex);
+	return ret;
 }

 static int emmaprp_release(struct file *file)
 {
+	struct emmaprp_ctx *ctx = fh_to_ctx(file->private_data);
 	struct emmaprp_dev *pcdev = video_drvdata(file);
-	struct emmaprp_ctx *ctx = file->private_data;

 	dprintk(pcdev, "Releasing instance %p\n", ctx);

@@ -835,6 +851,8 @@ static int emmaprp_release(struct file *file)
 	clk_disable_unprepare(pcdev->clk_emma_ahb);
 	clk_disable_unprepare(pcdev->clk_emma_ipg);
 	v4l2_m2m_ctx_release(ctx->m2m_ctx);
+	v4l2_fh_del(&ctx->fh);
+	v4l2_fh_exit(&ctx->fh);
 	mutex_unlock(&pcdev->dev_mutex);
 	kfree(ctx);

--
1.7.4.1

