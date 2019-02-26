Return-Path: <SRS0=99fO=RB=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDF3DC43381
	for <linux-media@archiver.kernel.org>; Tue, 26 Feb 2019 17:36:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AC6A7217F9
	for <linux-media@archiver.kernel.org>; Tue, 26 Feb 2019 17:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1551202586;
	bh=ecg2Hdw/71q1P50H92kpAskFu+8NFgDuRjZjYdu5tDM=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=eYAX6gm3eiQsKmMND+kTdAxszNvcxZ/s/9iRdjWcBGjLUhixeWgHuKCJvgsmcFlEP
	 yICiE8G+ZWo+i8SkYgHcpcIFb4JLZP8uLAbooctoJOy5VRW5dbc/hR/2wdQguJv2hX
	 hYCOzCfmHntp3ueH5udRpduChai3zepgRb3DYUrs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727580AbfBZRg0 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 26 Feb 2019 12:36:26 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:60620 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726353AbfBZRgZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Feb 2019 12:36:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=IHnIGNc3m8bBe5YM0rDZWVGM0//j8CgUeuzHdhOzPWI=; b=h2QUg3mgxjfKjzEcNvgE58rUM
        On1l5IjkmDtSsrYvjQSFMXrPEVQReCuq+E+lf3AG8cGQ2Hp5B94OcNtV9WFV9nAus+HD6N3dWJQff
        zGO0LzWpDq2EDdugdBWz5L2MxBizgP31V4S/7su4V1THOlxLy/gkAYyQgdmH+XZ+EVP+A5VRe0CS+
        wPixEoLa59y7Ggy4BdTLKWPKQymT/xPsctGp8zKuf7R1xt3/yhhB81npuDbYMuWLcOT8alhMbkpX5
        JJDeQQh4Lxa/fl5tdVPwEL8Z8eeIBPP7DbnAmLVaXIGXP/rjnl3143SWjn+QyHckiH8uYSYQO+Gh6
        5kuRJUjwA==;
Received: from 177.41.100.217.dynamic.adsl.gvt.net.br ([177.41.100.217] helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gygeV-0006NH-EF; Tue, 26 Feb 2019 17:36:23 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1gygeS-0002Mf-JU; Tue, 26 Feb 2019 14:36:20 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH v2] media: vim2m: better handle cap/out buffers with different sizes
Date:   Tue, 26 Feb 2019 14:36:19 -0300
Message-Id: <8d0a822ce02e1eb95f4a59cc9aabceb5a5661dda.1551202576.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The vim2m driver doesn't enforce that the capture and output
buffers would have the same size. Do the right thing if the
buffers are different, zeroing the buffer before writing,
ensuring that lines will be aligned and it won't write past
the buffer area.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/platform/vim2m.c | 26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
index 89384f324e25..46e3e096123e 100644
--- a/drivers/media/platform/vim2m.c
+++ b/drivers/media/platform/vim2m.c
@@ -481,7 +481,9 @@ static int device_process(struct vim2m_ctx *ctx,
 	struct vim2m_dev *dev = ctx->dev;
 	struct vim2m_q_data *q_data_in, *q_data_out;
 	u8 *p_in, *p, *p_out;
-	int width, height, bytesperline, x, y, y_out, start, end, step;
+	unsigned int width, height, bytesperline, bytesperline_out;
+	unsigned int x, y, y_out;
+	int start, end, step;
 	struct vim2m_fmt *in, *out;
 
 	q_data_in = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
@@ -491,8 +493,15 @@ static int device_process(struct vim2m_ctx *ctx,
 	bytesperline = (q_data_in->width * q_data_in->fmt->depth) >> 3;
 
 	q_data_out = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
+	bytesperline_out = (q_data_out->width * q_data_out->fmt->depth) >> 3;
 	out = q_data_out->fmt;
 
+	/* Crop to the limits of the destination image */
+	if (width > q_data_out->width)
+		width = q_data_out->width;
+	if (height > q_data_out->height)
+		height = q_data_out->height;
+
 	p_in = vb2_plane_vaddr(&in_vb->vb2_buf, 0);
 	p_out = vb2_plane_vaddr(&out_vb->vb2_buf, 0);
 	if (!p_in || !p_out) {
@@ -501,6 +510,10 @@ static int device_process(struct vim2m_ctx *ctx,
 		return -EFAULT;
 	}
 
+	/* Image size is different. Zero buffer first */
+	if (q_data_in->width  != q_data_out->width ||
+	    q_data_in->height != q_data_out->height)
+		memset(p_out, 0, q_data_out->sizeimage);
 	out_vb->sequence = get_q_data(ctx,
 				      V4L2_BUF_TYPE_VIDEO_CAPTURE)->sequence++;
 	in_vb->sequence = q_data_in->sequence++;
@@ -524,6 +537,11 @@ static int device_process(struct vim2m_ctx *ctx,
 		for (x = 0; x < width >> 1; x++)
 			copy_two_pixels(in, out, &p, &p_out, y_out,
 					ctx->mode & MEM2MEM_HFLIP);
+
+		/* Go to the next line at the out buffer*/
+		if (width < q_data_out->width)
+			p_out += ((q_data_out->width - width)
+				  * q_data_out->fmt->depth) >> 3;
 	}
 
 	return 0;
@@ -977,12 +995,6 @@ static int vim2m_buf_prepare(struct vb2_buffer *vb)
 	dprintk(ctx->dev, 2, "type: %s\n", type_name(vb->vb2_queue->type));
 
 	q_data = get_q_data(ctx, vb->vb2_queue->type);
-	if (vb2_plane_size(vb, 0) < q_data->sizeimage) {
-		dprintk(ctx->dev, "%s data will not fit into plane (%lu < %lu)\n",
-				__func__, vb2_plane_size(vb, 0), (long)q_data->sizeimage);
-		return -EINVAL;
-	}
-
 	vb2_set_plane_payload(vb, 0, q_data->sizeimage);
 
 	return 0;
-- 
2.20.1

