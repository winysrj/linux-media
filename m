Return-Path: <SRS0=+Qw+=RE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08FC4C10F03
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 16:52:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC1582087E
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 16:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1551459139;
	bh=yiQO6TDLnt00EJVOlsKuAnYGOtQwpIArPXnbDmlh3ZU=;
	h=From:Cc:Subject:Date:To:List-ID:From;
	b=PY5sRARuG39MdzmONL2djo1MFZLDkm3Ru11PbWNwxJF/GTyalvJv7/zURu0ksgpYj
	 keG3dUQTEIjY0v9+RHpxQHJibDcpqjOXylGbWx0TBGDO9/5L9fieSYezmHPqSKMZVI
	 f7YpiFCoyqdSwTzp1YYyzUTfwW/TrN93CFxRkHhM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389120AbfCAQwS (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 1 Mar 2019 11:52:18 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:46610 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728489AbfCAQwS (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Mar 2019 11:52:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=yRnly+cdLkl45FmP15BZOI6YLvVS6ooybqGznHZ9v+0=; b=AoCXAG2cVaUZwxl2MLJF+2NgP
        0a/sWWN6xMhsaQk/XRZgIyc14G635d8ho8y7kX3wv9sZcNA4eHIEbETicaKGKDzEVcMzsTlxXf1oI
        Bic1n+toBgy+kGeNNph1aTrRS3hKlvlw0cnWSed/3i7geku0kBXvXS2E1D/fTX0WS+XWDjWxrfx2U
        /HVgwbkBudr5yjiDcAAJlTRggg6SJ1CIaEx9OCwbgrDVMNaAVCSGqAWVGURbVYqwRWxNUFMvkXpwr
        BKKaTpxHqPbaM5HtbKwYQvFYky2Auw0cPLMirOY/9OScRxoSMQGEaGFky5pHkY9m6mFCUQrHgaIf3
        B4t/7ngaQ==;
Received: from 177.41.113.159.dynamic.adsl.gvt.net.br ([177.41.113.159] helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gzlOT-00029R-UP; Fri, 01 Mar 2019 16:52:17 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1gzlOP-0002l0-JH; Fri, 01 Mar 2019 11:52:13 -0500
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH 1/2] media: vim2m: don't use BUG()
Date:   Fri,  1 Mar 2019 11:52:12 -0500
Message-Id: <971d62ddd23eb07b6cbad858f9b004342efa6ee1.1551459127.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

There's no reason why this driver should use BUG(). Instead,
just properly handle issue, returning an error code where
pertinent.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/platform/vim2m.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
index 631e79b89ce9..eff4eff858fe 100644
--- a/drivers/media/platform/vim2m.c
+++ b/drivers/media/platform/vim2m.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0+
 /*
  * A virtual v4l2-mem2mem example device.
  *
@@ -247,9 +248,8 @@ static struct vim2m_q_data *get_q_data(struct vim2m_ctx *ctx,
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
 		return &ctx->q_data[V4L2_M2M_DST];
 	default:
-		BUG();
+		return NULL;
 	}
-	return NULL;
 }
 
 static const char *type_name(enum v4l2_buf_type type)
@@ -451,10 +451,14 @@ static int device_process(struct vim2m_ctx *ctx,
 	int start, end, step;
 
 	q_data_in = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
+	if (!q_data_in)
+		return 0;
 	bytesperline = (q_data_in->width * q_data_in->fmt->depth) >> 3;
 	bytes_per_pixel = q_data_in->fmt->depth >> 3;
 
 	q_data_out = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
+	if (!q_data_out)
+		return 0;
 
 	/* As we're doing scaling, use the output dimensions here */
 	height = q_data_out->height;
@@ -468,8 +472,7 @@ static int device_process(struct vim2m_ctx *ctx,
 		return -EFAULT;
 	}
 
-	out_vb->sequence = get_q_data(ctx,
-				      V4L2_BUF_TYPE_VIDEO_CAPTURE)->sequence++;
+	out_vb->sequence = q_data_out->sequence++;
 	in_vb->sequence = q_data_in->sequence++;
 	v4l2_m2m_buf_copy_metadata(in_vb, out_vb, true);
 
@@ -732,6 +735,8 @@ static int vidioc_g_fmt(struct vim2m_ctx *ctx, struct v4l2_format *f)
 		return -EINVAL;
 
 	q_data = get_q_data(ctx, f->type);
+	if (!q_data)
+		return -EINVAL;
 
 	f->fmt.pix.width	= q_data->width;
 	f->fmt.pix.height	= q_data->height;
@@ -986,6 +991,8 @@ static int vim2m_queue_setup(struct vb2_queue *vq,
 	unsigned int size, count = *nbuffers;
 
 	q_data = get_q_data(ctx, vq->type);
+	if (!q_data)
+		return -EINVAL;
 
 	size = q_data->width * q_data->height * q_data->fmt->depth >> 3;
 
@@ -1028,6 +1035,8 @@ static int vim2m_buf_prepare(struct vb2_buffer *vb)
 	dprintk(ctx->dev, 2, "type: %s\n", type_name(vb->vb2_queue->type));
 
 	q_data = get_q_data(ctx, vb->vb2_queue->type);
+	if (!q_data)
+		return -EINVAL;
 	if (vb2_plane_size(vb, 0) < q_data->sizeimage) {
 		dprintk(ctx->dev, 1,
 			"%s data will not fit into plane (%lu < %lu)\n",
@@ -1054,6 +1063,9 @@ static int vim2m_start_streaming(struct vb2_queue *q, unsigned count)
 	struct vim2m_ctx *ctx = vb2_get_drv_priv(q);
 	struct vim2m_q_data *q_data = get_q_data(ctx, q->type);
 
+	if (!q_data)
+		return -EINVAL;
+
 	q_data->sequence = 0;
 	return 0;
 }
-- 
2.20.1

