Return-Path: <SRS0=99fO=RB=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDD6CC43381
	for <linux-media@archiver.kernel.org>; Tue, 26 Feb 2019 21:40:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9C3D121874
	for <linux-media@archiver.kernel.org>; Tue, 26 Feb 2019 21:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1551217238;
	bh=meberCKFmNEMnatoyqAAwA7al27+l8RI58rPTLjHn8E=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=dP7lT7v4+oq1oYezaZFzOvy8ScyqKko2GfaKRWp6103L/iUyTjtSeoW1+pnXlOyf9
	 ZOSPfi1pKDDrm3QrkRI3WsbfZEQ12m/VMlQ2WjcZqYuOMJVcSDkZFr4zIMa8dKx3cO
	 L96nmoOFz4fmW2fK7IexooFfTTT2CfD+V0vlJIs8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728989AbfBZVki (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 26 Feb 2019 16:40:38 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:35422 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728673AbfBZVkh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Feb 2019 16:40:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=CVZTzG/vl4EpYEKR7g8bSJ4tiksbWm7Y372tlnkp7YQ=; b=mMXXivVcBGAkHmdIXv1wHIu/e
        HM+ysOztF7q/enAbZfuzMDRFZsfyjjbf+59Ii/ESKmmSTsP6KkOeQh80GNDIQzVMVSxkoxsV0GShA
        7mRCFwm73nZdKSyrtCdHwDRcCppTM8mPbPHzr5EbTKY/ZCYxRg1sJS8WvRKbV7ls65zvHOcuZZJVI
        +0n72mQsIXOl6Y/ctwItG5fIv9PrYHs9bO1G/c87BlZ/pG9E8tsw1VMLo+Y+PkRkMOfgWec8ZntEP
        6Kl04UKET9Ps9U6H2gTp+1iHcNjf2OiXt9v5fd5oMeG1OQ9i0SmxPvHX2Gvgk20C2QJdnqEbvr/sH
        +VfjifhZQ==;
Received: from 177.41.100.217.dynamic.adsl.gvt.net.br ([177.41.100.217] helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gykSr-0007sK-AG; Tue, 26 Feb 2019 21:40:37 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1gykSn-000820-Qd; Tue, 26 Feb 2019 18:40:33 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH] media: vim2m: add support for VIDIOC_ENUM_FRAMESIZES
Date:   Tue, 26 Feb 2019 18:40:32 -0300
Message-Id: <1a7ffc4a7841abf1fbc83b4ac6d14d0d8dd0be1b.1551217228.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

As we do alignments for width, expose it via V4L2 API.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/platform/vim2m.c | 38 ++++++++++++++++++++++++++--------
 1 file changed, 29 insertions(+), 9 deletions(-)

diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
index a3a39b8a0664..aa8bf8e96969 100644
--- a/drivers/media/platform/vim2m.c
+++ b/drivers/media/platform/vim2m.c
@@ -50,7 +50,7 @@ MODULE_PARM_DESC(default_transtime, "default transaction time in ms");
 #define MIN_H 32
 #define MAX_W 640
 #define MAX_H 480
-#define DIM_ALIGN_MASK 1 /* 2-byte alignment */
+#define WIDTH_ALIGN 2 /* 2-byte alignment */
 
 /* Flags that indicate a format can be used for capture/output */
 #define MEM2MEM_CAPTURE	(1 << 0)
@@ -145,14 +145,14 @@ enum {
 #define V4L2_CID_TRANS_TIME_MSEC	(V4L2_CID_USER_BASE + 0x1000)
 #define V4L2_CID_TRANS_NUM_BUFS		(V4L2_CID_USER_BASE + 0x1001)
 
-static struct vim2m_fmt *find_format(struct v4l2_format *f)
+static struct vim2m_fmt *find_format(u32 fourcc)
 {
 	struct vim2m_fmt *fmt;
 	unsigned int k;
 
 	for (k = 0; k < NUM_FORMATS; k++) {
 		fmt = &formats[k];
-		if (fmt->fourcc == f->fmt.pix.pixelformat)
+		if (fmt->fourcc == fourcc)
 			break;
 	}
 
@@ -693,6 +693,25 @@ static int vidioc_enum_fmt_vid_out(struct file *file, void *priv,
 	return enum_fmt(f, MEM2MEM_OUTPUT);
 }
 
+static int vidioc_enum_framesizes(struct file *file, void *priv,
+				  struct v4l2_frmsizeenum *fsize)
+{
+	if (fsize->index != 0)
+		return -EINVAL;
+
+	if (!find_format(fsize->pixel_format))
+                return -EINVAL;
+
+	fsize->type = V4L2_FRMSIZE_TYPE_STEPWISE;
+	fsize->stepwise.min_width = MIN_W;
+	fsize->stepwise.min_height =MIN_H;
+	fsize->stepwise.max_width = MAX_W;
+	fsize->stepwise.max_height = MAX_H;
+	fsize->stepwise.step_width = WIDTH_ALIGN;
+	fsize->stepwise.step_height = 1;
+	return 0;
+}
+
 static int vidioc_g_fmt(struct vim2m_ctx *ctx, struct v4l2_format *f)
 {
 	struct vb2_queue *vq;
@@ -744,7 +763,7 @@ static int vidioc_try_fmt(struct v4l2_format *f, struct vim2m_fmt *fmt)
 	else if (f->fmt.pix.width > MAX_W)
 		f->fmt.pix.width = MAX_W;
 
-	f->fmt.pix.width &= ~DIM_ALIGN_MASK;
+	f->fmt.pix.width &= ~(WIDTH_ALIGN - 1);
 	f->fmt.pix.bytesperline = (f->fmt.pix.width * fmt->depth) >> 3;
 	f->fmt.pix.sizeimage = f->fmt.pix.height * f->fmt.pix.bytesperline;
 	f->fmt.pix.field = V4L2_FIELD_NONE;
@@ -758,10 +777,10 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 	struct vim2m_fmt *fmt;
 	struct vim2m_ctx *ctx = file2ctx(file);
 
-	fmt = find_format(f);
+	fmt = find_format(f->fmt.pix.pixelformat);
 	if (!fmt) {
 		f->fmt.pix.pixelformat = formats[0].fourcc;
-		fmt = find_format(f);
+		fmt = find_format(f->fmt.pix.pixelformat);
 	}
 	if (!(fmt->types & MEM2MEM_CAPTURE)) {
 		v4l2_err(&ctx->dev->v4l2_dev,
@@ -783,10 +802,10 @@ static int vidioc_try_fmt_vid_out(struct file *file, void *priv,
 	struct vim2m_fmt *fmt;
 	struct vim2m_ctx *ctx = file2ctx(file);
 
-	fmt = find_format(f);
+	fmt = find_format(f->fmt.pix.pixelformat);
 	if (!fmt) {
 		f->fmt.pix.pixelformat = formats[0].fourcc;
-		fmt = find_format(f);
+		fmt = find_format(f->fmt.pix.pixelformat);
 	}
 	if (!(fmt->types & MEM2MEM_OUTPUT)) {
 		v4l2_err(&ctx->dev->v4l2_dev,
@@ -818,7 +837,7 @@ static int vidioc_s_fmt(struct vim2m_ctx *ctx, struct v4l2_format *f)
 		return -EBUSY;
 	}
 
-	q_data->fmt		= find_format(f);
+	q_data->fmt		= find_format(f->fmt.pix.pixelformat);
 	q_data->width		= f->fmt.pix.width;
 	q_data->height		= f->fmt.pix.height;
 	q_data->sizeimage	= q_data->width * q_data->height
@@ -915,6 +934,7 @@ static const struct v4l2_ioctl_ops vim2m_ioctl_ops = {
 	.vidioc_querycap	= vidioc_querycap,
 
 	.vidioc_enum_fmt_vid_cap = vidioc_enum_fmt_vid_cap,
+	.vidioc_enum_framesizes = vidioc_enum_framesizes,
 	.vidioc_g_fmt_vid_cap	= vidioc_g_fmt_vid_cap,
 	.vidioc_try_fmt_vid_cap	= vidioc_try_fmt_vid_cap,
 	.vidioc_s_fmt_vid_cap	= vidioc_s_fmt_vid_cap,
-- 
2.20.1

