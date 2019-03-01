Return-Path: <SRS0=+Qw+=RE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A065C43381
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 13:24:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1771C218E0
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 13:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1551446672;
	bh=I4A2IcKYquzO7ahNNB/1Wh8zMrXn8qQbLWob54FSDCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=yybhDZgMzjrGcp3cWkhJiSzWzIWlsrBYlWDk2UYTJ59sehC1TDGzaREpIq1SKJ2GH
	 DmZtwSE+Gy3eGMpw7TWrG5fj+HPdbZ9LMFzjD9DDEg0YeY97DXvGyIOvBh1iac6fwY
	 qULeLIGlaqvRnkAg/suzK1MhOvG6wS+oI4iLMdro=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387575AbfCANYb (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 1 Mar 2019 08:24:31 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:50520 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728296AbfCANYa (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Mar 2019 08:24:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=2oOf3LXlE7pTjNSawPk9D91Kk3ECJHCRMuRpc8Q8lu8=; b=P4oaKRcIb0xBF8ekI1e71/Pcqm
        NvbIwJRgkRxa3JTx/mmJe7DwTqywCG+/sP81TFD4kXKMU3lyrEfxnQgw8SZkyzTGfz9PKSbQK5cXA
        ItTZ9EpxN4WvDVLCUXRfNM9B6f2cAS7z/nX0rIffZw7x0c4K898ccDmCDQeAbKlYPHxrU///QBQaB
        JQcBjzacKN27mopDp7T6A3usPYj/a3VRszmnU/hfUUbP7KV2+D4N7xYhw8Z/l3qFDNrOxYjYmPYkU
        iN2Qx5CkxlIym0fRm1g6hG9javDXqszlPmqVTQOAsDZi3TCUZmIDPxxmwxC/qX7EPNwcrJIND1wA7
        mypi3PUg==;
Received: from 177.41.113.159.dynamic.adsl.gvt.net.br ([177.41.113.159] helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gzi9N-0003xz-Sd; Fri, 01 Mar 2019 13:24:29 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1gzi9L-0002NI-Qb; Fri, 01 Mar 2019 10:24:27 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH 04/10] media: vim2m: add support for VIDIOC_ENUM_FRAMESIZES
Date:   Fri,  1 Mar 2019 10:24:20 -0300
Message-Id: <23f04fcc0b8b7a8388ac41ecb1422053190ed1ba.1551446121.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1551446121.git.mchehab+samsung@kernel.org>
References: <cover.1551446121.git.mchehab+samsung@kernel.org>
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
index fb736356ee6b..bac9d4733d65 100644
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
 
@@ -675,6 +675,25 @@ static int vidioc_enum_fmt_vid_out(struct file *file, void *priv,
 	return enum_fmt(f, MEM2MEM_OUTPUT);
 }
 
+static int vidioc_enum_framesizes(struct file *file, void *priv,
+				  struct v4l2_frmsizeenum *fsize)
+{
+	if (fsize->index != 0)
+		return -EINVAL;
+
+	if (!find_format(fsize->pixel_format))
+		return -EINVAL;
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
@@ -726,7 +745,7 @@ static int vidioc_try_fmt(struct v4l2_format *f, struct vim2m_fmt *fmt)
 	else if (f->fmt.pix.width > MAX_W)
 		f->fmt.pix.width = MAX_W;
 
-	f->fmt.pix.width &= ~DIM_ALIGN_MASK;
+	f->fmt.pix.width &= ~(WIDTH_ALIGN - 1);
 	f->fmt.pix.bytesperline = (f->fmt.pix.width * fmt->depth) >> 3;
 	f->fmt.pix.sizeimage = f->fmt.pix.height * f->fmt.pix.bytesperline;
 	f->fmt.pix.field = V4L2_FIELD_NONE;
@@ -740,10 +759,10 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
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
@@ -765,10 +784,10 @@ static int vidioc_try_fmt_vid_out(struct file *file, void *priv,
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
@@ -800,7 +819,7 @@ static int vidioc_s_fmt(struct vim2m_ctx *ctx, struct v4l2_format *f)
 		return -EBUSY;
 	}
 
-	q_data->fmt		= find_format(f);
+	q_data->fmt		= find_format(f->fmt.pix.pixelformat);
 	q_data->width		= f->fmt.pix.width;
 	q_data->height		= f->fmt.pix.height;
 	q_data->sizeimage	= q_data->width * q_data->height
@@ -897,6 +916,7 @@ static const struct v4l2_ioctl_ops vim2m_ioctl_ops = {
 	.vidioc_querycap	= vidioc_querycap,
 
 	.vidioc_enum_fmt_vid_cap = vidioc_enum_fmt_vid_cap,
+	.vidioc_enum_framesizes = vidioc_enum_framesizes,
 	.vidioc_g_fmt_vid_cap	= vidioc_g_fmt_vid_cap,
 	.vidioc_try_fmt_vid_cap	= vidioc_try_fmt_vid_cap,
 	.vidioc_s_fmt_vid_cap	= vidioc_s_fmt_vid_cap,
-- 
2.20.1

