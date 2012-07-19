Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-4.cisco.com ([144.254.224.147]:11907 "EHLO
	ams-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170Ab2GSMAz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Jul 2012 08:00:55 -0400
From: Hans Verkuil <hans.verkuil@cisco.com>
To: linux-media@vger.kernel.org
Cc: Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [RFC PATCH 5/6] mem2mem_testdev: set default size and fix colorspace.
Date: Thu, 19 Jul 2012 14:00:23 +0200
Message-Id: <49d297309ea5483457c728222274216118c504b2.1342699069.git.hans.verkuil@cisco.com>
In-Reply-To: <1342699224-12642-1-git-send-email-hans.verkuil@cisco.com>
References: <1342699224-12642-1-git-send-email-hans.verkuil@cisco.com>
In-Reply-To: <903c0da0d6e7354d6f884f0ddec783143165e54c.1342699069.git.hans.verkuil@cisco.com>
References: <903c0da0d6e7354d6f884f0ddec783143165e54c.1342699069.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/mem2mem_testdev.c |   21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/mem2mem_testdev.c b/drivers/media/video/mem2mem_testdev.c
index f7a2a2d..7fdee8f 100644
--- a/drivers/media/video/mem2mem_testdev.c
+++ b/drivers/media/video/mem2mem_testdev.c
@@ -171,6 +171,8 @@ struct m2mtest_ctx {
 	/* Processing mode */
 	int			mode;
 
+	enum v4l2_colorspace	colorspace;
+
 	struct v4l2_m2m_ctx	*m2m_ctx;
 
 	/* Source and destination queue data */
@@ -494,6 +496,7 @@ static int vidioc_g_fmt(struct m2mtest_ctx *ctx, struct v4l2_format *f)
 	f->fmt.pix.pixelformat	= q_data->fmt->fourcc;
 	f->fmt.pix.bytesperline	= (q_data->width * q_data->fmt->depth) >> 3;
 	f->fmt.pix.sizeimage	= q_data->sizeimage;
+	f->fmt.pix.colorspace	= ctx->colorspace;
 
 	return 0;
 }
@@ -555,6 +558,7 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 			 f->fmt.pix.pixelformat);
 		return -EINVAL;
 	}
+	f->fmt.pix.colorspace = ctx->colorspace;
 
 	return vidioc_try_fmt(f, fmt);
 }
@@ -572,6 +576,8 @@ static int vidioc_try_fmt_vid_out(struct file *file, void *priv,
 			 f->fmt.pix.pixelformat);
 		return -EINVAL;
 	}
+	if (!f->fmt.pix.colorspace)
+		f->fmt.pix.colorspace = V4L2_COLORSPACE_REC709;
 
 	return vidioc_try_fmt(f, fmt);
 }
@@ -622,13 +628,17 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 static int vidioc_s_fmt_vid_out(struct file *file, void *priv,
 				struct v4l2_format *f)
 {
+	struct m2mtest_ctx *ctx = file2ctx(file);
 	int ret;
 
 	ret = vidioc_try_fmt_vid_out(file, priv, f);
 	if (ret)
 		return ret;
 
-	return vidioc_s_fmt(file2ctx(file), f);
+	ret = vidioc_s_fmt(file2ctx(file), f);
+	if (!ret)
+		ctx->colorspace = f->fmt.pix.colorspace;
+	return ret;
 }
 
 static int vidioc_reqbufs(struct file *file, void *priv,
@@ -906,7 +916,14 @@ static int m2mtest_open(struct file *file)
 	v4l2_ctrl_handler_setup(hdl);
 
 	ctx->q_data[V4L2_M2M_SRC].fmt = &formats[0];
-	ctx->q_data[V4L2_M2M_DST].fmt = &formats[0];
+	ctx->q_data[V4L2_M2M_SRC].width = 640;
+	ctx->q_data[V4L2_M2M_SRC].height = 480;
+	ctx->q_data[V4L2_M2M_SRC].sizeimage =
+		ctx->q_data[V4L2_M2M_SRC].width *
+		ctx->q_data[V4L2_M2M_SRC].height *
+		(ctx->q_data[V4L2_M2M_SRC].fmt->depth >> 3);
+	ctx->q_data[V4L2_M2M_DST] = ctx->q_data[V4L2_M2M_SRC];
+	ctx->colorspace = V4L2_COLORSPACE_REC709;
 
 	ctx->m2m_ctx = v4l2_m2m_ctx_init(dev->m2m_dev, ctx, &queue_init);
 
-- 
1.7.10

