Return-Path: <SRS0=BdY7=QG=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 731FEC282D4
	for <linux-media@archiver.kernel.org>; Wed, 30 Jan 2019 07:33:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B6982084C
	for <linux-media@archiver.kernel.org>; Wed, 30 Jan 2019 07:33:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728356AbfA3Hdr (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 30 Jan 2019 02:33:47 -0500
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:34948 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725819AbfA3Hdr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 Jan 2019 02:33:47 -0500
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id okNSgyuVzBDyIokNVgto6p; Wed, 30 Jan 2019 08:33:45 +0100
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Dafna Hirschfeld <dafna3@gmail.com>
From:   Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH] vicodec: check type in g/s_selection
Message-ID: <9aa71b31-5078-eeaf-e868-37a59e4d3ee0@xs4all.nl>
Date:   Wed, 30 Jan 2019 08:33:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfEwYMHPYxF4bV01XtXxSST6BD3bi6kDcHzQDm0S111qHOFzjuljCgoCoOqGvThxLU1aKPBfnyCO7n+W6aR1XoYtN/T5bAOi0htQRqKEHVZliTIonEruW
 yo+t9+gmT9jgLvNnlEQOyeVbYPbQ6rbQnuL7wgZSVcrvqiLuTHH/OA+wmbfYrn7+tzQ3ftvzHbbzfgGPK3mYn1L8ePCsYxWKg6Y=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Check that the selection buf_type is valid before calling get_q_data() to
avoid hitting the WARN(1) in that function if the buffer type is not valid.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Reported-by: syzbot+44b24cff6bf96006ecfa@syzkaller.appspotmail.com
---
diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
index 3703b587e25e..cda348114764 100644
--- a/drivers/media/platform/vicodec/vicodec-core.c
+++ b/drivers/media/platform/vicodec/vicodec-core.c
@@ -953,6 +953,9 @@ static int vidioc_g_selection(struct file *file, void *priv,
 		valid_out_type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
 	}

+	if (s->type != valid_cap_type && s->type != valid_out_type)
+		return -EINVAL;
+
 	q_data = get_q_data(ctx, s->type);
 	if (!q_data)
 		return -EINVAL;
@@ -994,12 +997,14 @@ static int vidioc_s_selection(struct file *file, void *priv,
 	if (multiplanar)
 		out_type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;

+	if (s->type != out_type)
+		return -EINVAL;
+
 	q_data = get_q_data(ctx, s->type);
 	if (!q_data)
 		return -EINVAL;

-	if (!ctx->is_enc || s->type != out_type ||
-	    s->target != V4L2_SEL_TGT_CROP)
+	if (!ctx->is_enc || s->target != V4L2_SEL_TGT_CROP)
 		return -EINVAL;

 	s->r.left = 0;
