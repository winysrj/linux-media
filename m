Return-Path: <SRS0=o7tn=RA=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF548C4360F
	for <linux-media@archiver.kernel.org>; Mon, 25 Feb 2019 22:20:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A36F213A2
	for <linux-media@archiver.kernel.org>; Mon, 25 Feb 2019 22:20:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gH6KMbTM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728204AbfBYWUF (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 25 Feb 2019 17:20:05 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:50611 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728139AbfBYWUD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Feb 2019 17:20:03 -0500
Received: by mail-wm1-f68.google.com with SMTP id x7so512011wmj.0
        for <linux-media@vger.kernel.org>; Mon, 25 Feb 2019 14:20:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=vMyMpGqqdM36AhawPTalbjw4IFBI0qu83CyqC1tgsXE=;
        b=gH6KMbTM5xJWaFOGx+HFo8xj5w8EJeAscfCHlofmsHnLe28YMYAfOQwq+msXxx1DEU
         F3bbiSAXM83w7GUtOQ/6cx6OOpDvXhte4WmzP7EhuBqlvZhb4uy0Gx9gn3wrqk6dqxya
         EJwzvFG50U+bHL69eiwz05jaNQ1JLkHV+DuWtr4K/K4wECERDBTkyibc7Rla1jhxUnRd
         IJDcMOf5GMY6jwB6fJ6aGWzEY0SXCemI3UAcgZshFVQoJIjcK+k9PfePEqsV5qDRIRSs
         XfKfJ4zLjcjLlFAo4Qylc9waEAxMEOC8Is3aKeSAES1x+9mScTUmD0gH6bWXboI1sNat
         Lb7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=vMyMpGqqdM36AhawPTalbjw4IFBI0qu83CyqC1tgsXE=;
        b=bqUNDi3oxUHxsfU894+4vsaPZBbz1MfUrPk1phjGLP1hj1VEXCvWqTXtvLeLWsdAIj
         9MK3Z184SoGHJU/OyNAj6zGIeMYunJfrdagDGihhwMp2AGbKH4P5qd4G5HVHFcNvOcmp
         wBxfKWNbnY+EB/MUOc+i6b4k9Rqc9DeXAwLSKFx4iK3xCE7WicaQcRkV67GfLWrQ/KOp
         TUW7f+QO7TKXAv6/cXZkaB2+no0oEJNQXKZQQXNf5ndGbO5Nt/tQY2cQBKsGWWX8FsE8
         qFqYKIkwDEBFGja41P6kK8MgDvVRPH6o9VB7gs8YKZ2p2fWbq3oAscd/xRCZg2VsA8FJ
         uYXw==
X-Gm-Message-State: AHQUAuZKkpBgtoBwhEV5ZW1tmazn1tNaKPGhxzrEelJw1kjAq4X/O96O
        +qz319P8HPyP/3xWUG0GU+/Girm9GtA=
X-Google-Smtp-Source: AHgI3IYL06u3K+z3rl1njWuZ1yxEewpwkFjExBGmQi06tNJEm19ZLowhJ6sJSl2sFr21MIvUCgewDA==
X-Received: by 2002:a1c:720f:: with SMTP id n15mr518172wmc.64.1551133201730;
        Mon, 25 Feb 2019 14:20:01 -0800 (PST)
Received: from ubuntu.home ([77.127.107.32])
        by smtp.gmail.com with ESMTPSA id a20sm4168033wmb.17.2019.02.25.14.20.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 25 Feb 2019 14:20:01 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH v4 07/21] media: vicodec: change variable name for the return value of v4l2_fwht_encode
Date:   Mon, 25 Feb 2019 14:19:31 -0800
Message-Id: <20190225221933.121653-8-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190225221933.121653-1-dafna3@gmail.com>
References: <20190225221933.121653-1-dafna3@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

v4l2_fwht_encode returns either an error code on
failure or the size of the compressed frame on
success. So change the var assigned to it from
'ret' to 'comp_sz_or_errcode' to clarify that.

Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
---
 drivers/media/platform/vicodec/vicodec-core.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
index 0909f86547f1..eec31b144d56 100644
--- a/drivers/media/platform/vicodec/vicodec-core.c
+++ b/drivers/media/platform/vicodec/vicodec-core.c
@@ -178,13 +178,14 @@ static int device_process(struct vicodec_ctx *ctx,
 
 	if (ctx->is_enc) {
 		struct vicodec_q_data *q_src;
+		int comp_sz_or_errcode;
 
 		q_src = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
 		state->info = q_src->info;
-		ret = v4l2_fwht_encode(state, p_src, p_dst);
-		if (ret < 0)
-			return ret;
-		vb2_set_plane_payload(&dst_vb->vb2_buf, 0, ret);
+		comp_sz_or_errcode = v4l2_fwht_encode(state, p_src, p_dst);
+		if (comp_sz_or_errcode < 0)
+			return comp_sz_or_errcode;
+		vb2_set_plane_payload(&dst_vb->vb2_buf, 0, comp_sz_or_errcode);
 	} else {
 		unsigned int comp_frame_size = ntohl(ctx->state.header.size);
 
-- 
2.17.1

