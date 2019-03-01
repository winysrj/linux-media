Return-Path: <SRS0=+Qw+=RE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D07B2C43381
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 13:24:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F9FE2085A
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 13:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1551446678;
	bh=kMMLgwIMnEA2rnluFvQ5luCZdoj0su1qrw+KodtTFSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=ftsVt/6dRa1BAfaDRCPaW/BVcZTBzyfwz+okvaosOw0ygr9fIqriodBsBgb0FIU0r
	 1vw/9yWOK/hipVofhAl+AuCe7zhIi9mbZTKEmNvb9OMlGIpn3zVEkn3RzWrD5CK/xs
	 lMns8/zLuB9+3qzsWdV70Oh6ftbl8LBxAH5OcPos=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387632AbfCANYh (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 1 Mar 2019 08:24:37 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:50514 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728243AbfCANYa (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Mar 2019 08:24:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=tRA8AkkG0iuLBuq01lOc3rbEsef0pSN2qI3B6m0cxCg=; b=cNTAawoh6ok+G/chwlb/1LLM1l
        awvHXGJy6Ci5pAK1nrJvgYMgDGrQjnAFzjoRQ4hcCzb1Jp6GnzOlU0gLPu/bt2rh8mpGmlMeKbVhP
        +g1WncDdsbQ0qCwfhgrTWRfQFZjfzYKsvb1udKUvuu3ZkrOG5edox7pFeJJl+ID8GugusfTECdstZ
        O1g3nOc5RpQe4syldYxdKxJSXw7Jdu5Hu9lLJHvsLTE54FhFfsy2Il8WchdqevgwVM8KZi6DadOkN
        yF6YWgfAsVxGnBWzl+wTW8Tkyy+3uQ6xJ+EnBhJD4VRYpET+mpQg9ZCYcgtlkXBt/AdWKK6T1uTKO
        hwk2YlHg==;
Received: from 177.41.113.159.dynamic.adsl.gvt.net.br ([177.41.113.159] helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gzi9N-0003xx-Rf; Fri, 01 Mar 2019 13:24:29 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1gzi9L-0002N8-Ow; Fri, 01 Mar 2019 10:24:27 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH 02/10] media: vim2m: improve debug messages
Date:   Fri,  1 Mar 2019 10:24:18 -0300
Message-Id: <45274f421cd11059d008c8229c7f4e17751c0a4f.1551446121.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1551446121.git.mchehab+samsung@kernel.org>
References: <cover.1551446121.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

1) Use two levels for debug:
	- level 1: setup stuff
	- level 2: add queue/dequeue messages

2) Better display the debug output, translating buffer
   type, fourcc and making some messages clearer.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/platform/vim2m.c | 46 +++++++++++++++++++++++-----------
 1 file changed, 32 insertions(+), 14 deletions(-)

diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
index d95a905bdfc5..17d40cec2d95 100644
--- a/drivers/media/platform/vim2m.c
+++ b/drivers/media/platform/vim2m.c
@@ -39,7 +39,7 @@ MODULE_ALIAS("mem2mem_testdev");
 
 static unsigned debug;
 module_param(debug, uint, 0644);
-MODULE_PARM_DESC(debug, "activates debug info");
+MODULE_PARM_DESC(debug, "debug level");
 
 /* Default transaction time in msec */
 static unsigned int default_transtime = 40; /* Max 25 fps */
@@ -67,8 +67,8 @@ MODULE_PARM_DESC(default_transtime, "default transaction time in ms");
 #define MEM2MEM_HFLIP	(1 << 0)
 #define MEM2MEM_VFLIP	(1 << 1)
 
-#define dprintk(dev, fmt, arg...) \
-	v4l2_dbg(1, debug, &dev->v4l2_dev, "%s: " fmt, __func__, ## arg)
+#define dprintk(dev, lvl, fmt, arg...) \
+	v4l2_dbg(lvl, debug, &dev->v4l2_dev, "%s: " fmt, __func__, ## arg)
 
 
 static void vim2m_dev_release(struct device *dev)
@@ -227,6 +227,18 @@ static struct vim2m_q_data *get_q_data(struct vim2m_ctx *ctx,
 	return NULL;
 }
 
+static const char *type_name(enum v4l2_buf_type type)
+{
+	switch (type) {
+	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
+		return "Output";
+	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
+		return "Capture";
+	default:
+		return "Invalid";
+	}
+}
+
 #define CLIP(__color) \
 	(u8)(((__color) > 0xff) ? 0xff : (((__color) < 0) ? 0 : (__color)))
 
@@ -530,7 +542,7 @@ static int job_ready(void *priv)
 
 	if (v4l2_m2m_num_src_bufs_ready(ctx->fh.m2m_ctx) < ctx->translen
 	    || v4l2_m2m_num_dst_bufs_ready(ctx->fh.m2m_ctx) < ctx->translen) {
-		dprintk(ctx->dev, "Not enough buffers available\n");
+		dprintk(ctx->dev, 1, "Not enough buffers available\n");
 		return 0;
 	}
 
@@ -601,7 +613,7 @@ static void device_work(struct work_struct *w)
 
 	if (curr_ctx->num_processed == curr_ctx->translen
 	    || curr_ctx->aborting) {
-		dprintk(curr_ctx->dev, "Finishing transaction\n");
+		dprintk(curr_ctx->dev, 2, "Finishing capture buffer fill\n");
 		curr_ctx->num_processed = 0;
 		v4l2_m2m_job_finish(vim2m_dev->m2m_dev, curr_ctx->fh.m2m_ctx);
 	} else {
@@ -794,9 +806,14 @@ static int vidioc_s_fmt(struct vim2m_ctx *ctx, struct v4l2_format *f)
 	q_data->sizeimage	= q_data->width * q_data->height
 				* q_data->fmt->depth >> 3;
 
-	dprintk(ctx->dev,
-		"Setting format for type %d, wxh: %dx%d, fmt: %d\n",
-		f->type, q_data->width, q_data->height, q_data->fmt->fourcc);
+	dprintk(ctx->dev, 1,
+		"Format for type %s: %dx%d (%d bpp), fmt: %c%c%c%c\n",
+		type_name(f->type), q_data->width, q_data->height,
+		q_data->fmt->depth,
+		(q_data->fmt->fourcc & 0xff),
+		(q_data->fmt->fourcc >>  8) & 0xff,
+		(q_data->fmt->fourcc >> 16) & 0xff,
+		(q_data->fmt->fourcc >> 24) & 0xff);
 
 	return 0;
 }
@@ -931,7 +948,8 @@ static int vim2m_queue_setup(struct vb2_queue *vq,
 	*nplanes = 1;
 	sizes[0] = size;
 
-	dprintk(ctx->dev, "get %d buffer(s) of size %d each.\n", count, size);
+	dprintk(ctx->dev, 1, "%s: get %d buffer(s) of size %d each.\n",
+		type_name(vq->type), count, size);
 
 	return 0;
 }
@@ -944,7 +962,7 @@ static int vim2m_buf_out_validate(struct vb2_buffer *vb)
 	if (vbuf->field == V4L2_FIELD_ANY)
 		vbuf->field = V4L2_FIELD_NONE;
 	if (vbuf->field != V4L2_FIELD_NONE) {
-		dprintk(ctx->dev, "%s field isn't supported\n", __func__);
+		dprintk(ctx->dev, 1, "%s field isn't supported\n", __func__);
 		return -EINVAL;
 	}
 
@@ -956,11 +974,11 @@ static int vim2m_buf_prepare(struct vb2_buffer *vb)
 	struct vim2m_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
 	struct vim2m_q_data *q_data;
 
-	dprintk(ctx->dev, "type: %d\n", vb->vb2_queue->type);
+	dprintk(ctx->dev, 2, "type: %s\n", type_name(vb->vb2_queue->type));
 
 	q_data = get_q_data(ctx, vb->vb2_queue->type);
 	if (vb2_plane_size(vb, 0) < q_data->sizeimage) {
-		dprintk(ctx->dev, "%s data will not fit into plane (%lu < %lu)\n",
+		dprintk(ctx->dev, 1, "%s data will not fit into plane (%lu < %lu)\n",
 				__func__, vb2_plane_size(vb, 0), (long)q_data->sizeimage);
 		return -EINVAL;
 	}
@@ -1147,7 +1165,7 @@ static int vim2m_open(struct file *file)
 	v4l2_fh_add(&ctx->fh);
 	atomic_inc(&dev->num_inst);
 
-	dprintk(dev, "Created instance: %p, m2m_ctx: %p\n",
+	dprintk(dev, 1, "Created instance: %p, m2m_ctx: %p\n",
 		ctx, ctx->fh.m2m_ctx);
 
 open_unlock:
@@ -1160,7 +1178,7 @@ static int vim2m_release(struct file *file)
 	struct vim2m_dev *dev = video_drvdata(file);
 	struct vim2m_ctx *ctx = file2ctx(file);
 
-	dprintk(dev, "Releasing instance %p\n", ctx);
+	dprintk(dev, 1, "Releasing instance %p\n", ctx);
 
 	v4l2_fh_del(&ctx->fh);
 	v4l2_fh_exit(&ctx->fh);
-- 
2.20.1

