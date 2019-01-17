Return-Path: <SRS0=I7H+=PZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3396BC43612
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 16:21:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 07D9F20855
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 16:21:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="WhA+Lag5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729206AbfAQQVQ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 17 Jan 2019 11:21:16 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34129 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729199AbfAQQVO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 Jan 2019 11:21:14 -0500
Received: by mail-wr1-f68.google.com with SMTP id j2so11750107wrw.1
        for <linux-media@vger.kernel.org>; Thu, 17 Jan 2019 08:21:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=aHseR03KuZFgXQcyp39rH2RiSTCI0A/sA8/HyCR9OmI=;
        b=WhA+Lag5SvO8FC2NrNMNujQMvxsP/XMPh4Yk/EVfTWU43kPdqeiCKqO9AuoEEsBrFK
         3klZNo4hmA1AOlQvWfJ5MPj16vTdN/5KnAFQUu1LQEfJ/gk+79My0JClZ6JUYOTeV/RB
         /RX4vcslQoZYddkz8Ghpf1Edrq4b47zi582V4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=aHseR03KuZFgXQcyp39rH2RiSTCI0A/sA8/HyCR9OmI=;
        b=XVrhfSqlqnGe/kK91rKVVN0cPqeL/VxRnjmo+rfRZ+2xe0h+BaWwaluvStLiyal7oS
         iH/pDfu4bf1o4QwDrbgY7RBoAtawSaLhtBpvfceit1knpxpRDDBZ+VW7dUnpPoTeUpL0
         9KJPojDvMCtZWOhkOEmpGyjL9sDDctQeRsCd2LVwfaWMpOVjdBXpJzsw4Ys08nHojnZm
         8SUvC6RY1iuv1iSpXoD7A7N6WkCyg7fOn/xxuz3uyqiBVM102KbJ0aV99yW78KD2DoBN
         OG2f9D3kRCsDigrSpeTxAYh1hvUNdXN6qYKkPwWLZcIFy1/FaQJYwtXbVnC5CzQrjdjV
         y5fg==
X-Gm-Message-State: AJcUukcWlt9P0y/BZuuZrnDVD+05JHyRtgbs9jevIIoNy+7mVeYm5dz6
        9aijNCjn7S0P/VPECMEI2i4COv0OEi4=
X-Google-Smtp-Source: ALg8bN6MzoLll8gQQFTLx3NU9k1toCVsKmLbnejf5MNGG42VmtEI1Oi2UC+f58ia/53+L12+e5eUHw==
X-Received: by 2002:adf:9d08:: with SMTP id k8mr13422897wre.203.1547742072995;
        Thu, 17 Jan 2019 08:21:12 -0800 (PST)
Received: from localhost.localdomain ([37.157.136.206])
        by smtp.gmail.com with ESMTPSA id v133sm31124734wmf.19.2019.01.17.08.21.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Jan 2019 08:21:12 -0800 (PST)
From:   Stanimir Varbanov <stanimir.varbanov@linaro.org>
To:     linux-media@vger.kernel.org
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Vikash Garodia <vgarodia@codeaurora.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Malathi Gottam <mgottam@codeaurora.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: [PATCH 09/10] venus: vdec: allow bigger sizeimage set by clients
Date:   Thu, 17 Jan 2019 18:20:07 +0200
Message-Id: <20190117162008.25217-10-stanimir.varbanov@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190117162008.25217-1-stanimir.varbanov@linaro.org>
References: <20190117162008.25217-1-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

In most of the cases the client will know better what could be
the maximum size for compressed data buffers. Change the driver
to permit the user to set bigger size for the compressed buffer
but make reasonable sanitation.

Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
---
 drivers/media/platform/qcom/venus/vdec.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/vdec.c b/drivers/media/platform/qcom/venus/vdec.c
index 282de21cf2e1..7a9370df7515 100644
--- a/drivers/media/platform/qcom/venus/vdec.c
+++ b/drivers/media/platform/qcom/venus/vdec.c
@@ -142,6 +142,7 @@ vdec_try_fmt_common(struct venus_inst *inst, struct v4l2_format *f)
 	struct v4l2_pix_format_mplane *pixmp = &f->fmt.pix_mp;
 	struct v4l2_plane_pix_format *pfmt = pixmp->plane_fmt;
 	const struct venus_format *fmt;
+	u32 szimage;
 
 	memset(pfmt[0].reserved, 0, sizeof(pfmt[0].reserved));
 	memset(pixmp->reserved, 0, sizeof(pixmp->reserved));
@@ -170,14 +171,18 @@ vdec_try_fmt_common(struct venus_inst *inst, struct v4l2_format *f)
 	pixmp->num_planes = fmt->num_planes;
 	pixmp->flags = 0;
 
-	pfmt[0].sizeimage = venus_helper_get_framesz(pixmp->pixelformat,
-						     pixmp->width,
-						     pixmp->height);
+	szimage = venus_helper_get_framesz(pixmp->pixelformat, pixmp->width,
+					   pixmp->height);
 
-	if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
+	if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
+		pfmt[0].sizeimage = szimage;
 		pfmt[0].bytesperline = ALIGN(pixmp->width, 128);
-	else
+	} else {
+		pfmt[0].sizeimage = clamp_t(u32, pfmt[0].sizeimage, 0, SZ_4M);
+		if (szimage > pfmt[0].sizeimage)
+			pfmt[0].sizeimage = szimage;
 		pfmt[0].bytesperline = 0;
+	}
 
 	return fmt;
 }
@@ -275,6 +280,7 @@ static int vdec_s_fmt(struct file *file, void *fh, struct v4l2_format *f)
 		inst->ycbcr_enc = pixmp->ycbcr_enc;
 		inst->quantization = pixmp->quantization;
 		inst->xfer_func = pixmp->xfer_func;
+		inst->input_buf_size = pixmp->plane_fmt[0].sizeimage;
 	}
 
 	memset(&format, 0, sizeof(format));
@@ -737,6 +743,8 @@ static int vdec_queue_setup(struct vb2_queue *q,
 		sizes[0] = venus_helper_get_framesz(inst->fmt_out->pixfmt,
 						    inst->out_width,
 						    inst->out_height);
+		if (inst->input_buf_size > sizes[0])
+			sizes[0] = inst->input_buf_size;
 		inst->input_buf_size = sizes[0];
 		*num_buffers = max(*num_buffers, in_num);
 		inst->num_input_bufs = *num_buffers;
-- 
2.17.1

