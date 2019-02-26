Return-Path: <SRS0=99fO=RB=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBD4AC43381
	for <linux-media@archiver.kernel.org>; Tue, 26 Feb 2019 11:53:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8830E2087C
	for <linux-media@archiver.kernel.org>; Tue, 26 Feb 2019 11:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1551182039;
	bh=iHUiWc+bK6jXZy4vC/TeVOp/OqILreHkwnF5TeU0ehk=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=FyzFD2iJzwm1FgPvpafPbQA1kPmuEbKE2qJqkBuHL9dvKWKhhlyazJd9tFtdg/en/
	 YgQUG4DrfC/wEHFm+Gf+m2teooBcmvFYKmnNYYTIEtrvGFrU1Taxev8T5x64JHIX5H
	 khpeqW2/C4YP9xnbvXBoAYEXa9bbFybRfJFfzlVw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726419AbfBZLx7 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 26 Feb 2019 06:53:59 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:56896 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726004AbfBZLx6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Feb 2019 06:53:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=S9gVMrIO2u0vrh0mZn5LoXscAmQN0dQHgf7SA96d6oM=; b=KYpeAHYzorctLE3y/qbHox9Ae
        /yk8pqXCFK+RjTMMuaDJ9loryi9t4I7d6d+us7OIqSqXWZA7KB9AIIye6fMgCsXLwcYsOzWiehTp6
        WVOLio8QhftpmsMUdakchABXN2ihdrVEGizd2YFFC7zIB2h6nhaKJjkWnhBaB/0SbnJljVYoBVMa4
        IxiY6PaI0ZXUDhaCa4j265sSsDRGSMWcHZJWF0+6q/CNJv4kmS1j/KBHuXJt30r9rhdTQ/G5fxM/p
        HqtYydSr2Hr/us8GOWu5IYf5S4P8hh43Z9hSHEphT2nnuFcwCovSIDyt6yzAhgP7Wt4kjQzWQi1NL
        BEBzFAM0A==;
Received: from [177.97.27.83] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gybJ8-0000M9-0w; Tue, 26 Feb 2019 11:53:58 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1gybJ4-0004f7-5H; Tue, 26 Feb 2019 08:53:54 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH] media: vim2m: better handle cap/out buffers with different sizes
Date:   Tue, 26 Feb 2019 08:53:53 -0300
Message-Id: <013d728f6a252d6973d75d92017bdad7ddcff8f3.1551182030.git.mchehab+samsung@kernel.org>
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
 drivers/media/platform/vim2m.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
index d95a905bdfc5..37f27082054d 100644
--- a/drivers/media/platform/vim2m.c
+++ b/drivers/media/platform/vim2m.c
@@ -469,7 +469,8 @@ static int device_process(struct vim2m_ctx *ctx,
 	struct vim2m_dev *dev = ctx->dev;
 	struct vim2m_q_data *q_data_in, *q_data_out;
 	u8 *p_in, *p, *p_out;
-	int width, height, bytesperline, x, y, y_out, start, end, step;
+	unsigned int width, height, bytesperline, x, y, y_out, imgsize;
+	int start, end, step;
 	struct vim2m_fmt *in, *out;
 
 	q_data_in = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
@@ -479,8 +480,16 @@ static int device_process(struct vim2m_ctx *ctx,
 	bytesperline = (q_data_in->width * q_data_in->fmt->depth) >> 3;
 
 	q_data_out = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
+	imgsize = (q_data_out->width * q_data_out->fmt->depth) >> 3;
+	imgsize *= q_data_out->height;
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
@@ -489,6 +498,10 @@ static int device_process(struct vim2m_ctx *ctx,
 		return -EFAULT;
 	}
 
+	/* Image size is different. Zero buffer first */
+	if (q_data_in->width  != q_data_out->width ||
+	    q_data_in->height != q_data_out->height)
+		memset(p_out, 0, imgsize);
 	out_vb->sequence = get_q_data(ctx,
 				      V4L2_BUF_TYPE_VIDEO_CAPTURE)->sequence++;
 	in_vb->sequence = q_data_in->sequence++;
@@ -512,6 +525,11 @@ static int device_process(struct vim2m_ctx *ctx,
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
-- 
2.20.1

