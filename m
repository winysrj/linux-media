Return-Path: <SRS0=2oy6=QW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F2BDC43381
	for <linux-media@archiver.kernel.org>; Fri, 15 Feb 2019 13:06:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C5F221A80
	for <linux-media@archiver.kernel.org>; Fri, 15 Feb 2019 13:06:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ovff6fDM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394897AbfBONGW (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 15 Feb 2019 08:06:22 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45073 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394896AbfBONGW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Feb 2019 08:06:22 -0500
Received: by mail-wr1-f67.google.com with SMTP id w17so10237533wrn.12
        for <linux-media@vger.kernel.org>; Fri, 15 Feb 2019 05:06:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=7bC/P9l8kovwO03XgdMHc6Ed9Tt0+DuapeIPpqcOpJU=;
        b=ovff6fDMdf2MZ1SXypWQKxXpZPjbGHoRhXJPOIIX7jkXWTXS1qAWlYDhIZ+N4skrZ3
         3DwPNSRZTy5sMrtscSuqTCXV6SC9Z1PrPr/V3EHhEhax2pYtOTPHTocJLvoUXaUkBqO1
         ig8hoj6AI5TP+09VX1tBAb5brTMxKti15tfM/1i3zl0Ljk9uP1hL6goQ2/wV5yz/rKdD
         jqLeQjEHwKTjRopqcmHtYs3dszL8I47trcYbbPj+6kJ9lVYLueMomiegzCo5Y1vnG43/
         y2HSbonnOghJKiiZ3v5mfx/rT5/9HyG+Jz0Gyw1otgBk0vn8T0kukMy8pEuA4NDMydp0
         ZMuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=7bC/P9l8kovwO03XgdMHc6Ed9Tt0+DuapeIPpqcOpJU=;
        b=rOB697T3bXgHsUKKwRTcPyygX9vynmyF4dqQ83zBz8++UQb2c69j+HJQIz7rtbECeh
         jbunbNN9UMkFLhc/fwJIs0gCIuhSwpcsFlszIcvvFH3as6GFjtp+lU4F4cpMNSNtAuyd
         dmnZNeNpXMLPuVg5SMyyOpHXa+rTiLAVFShv2PG8bnQDBOsctgtHatZ3Wdb6XShFDOvf
         0XRlS/z3hV6SBK/nQEirKHoz2sqLPt2bN613ZOhm0rYBEW8XKY48RFN5zpJOpLC2mJgi
         TR4855mZYmuDzDiCZpCMh+7ZhN6JOIuH5DcSbAca4u1NPhVrDFnTNkLkfsVs4hbxEmnK
         xfPQ==
X-Gm-Message-State: AHQUAuZJ9hI4izMPpnlxKiOcwi6z8Fln1DKP8glD4CSiewnqoTNyoEpF
        1g3XbZw1YddcXBajZujsjL30yXk6AuQ=
X-Google-Smtp-Source: AHgI3IbPuSLjSJrL0pwyt0N6t+YPPLXvfr5QJ6aUd9MWZNHv26z7M7oDllDHwyrXGEV1rbJqddYQUQ==
X-Received: by 2002:adf:dc10:: with SMTP id t16mr7068704wri.40.1550235980329;
        Fri, 15 Feb 2019 05:06:20 -0800 (PST)
Received: from localhost.localdomain ([37.26.146.189])
        by smtp.gmail.com with ESMTPSA id n6sm2091065wrt.23.2019.02.15.05.06.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 15 Feb 2019 05:06:19 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH v2 03/10] media: vicodec: add field 'buf' to fwht_raw_frame
Date:   Fri, 15 Feb 2019 05:05:03 -0800
Message-Id: <20190215130509.86290-4-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190215130509.86290-1-dafna3@gmail.com>
References: <20190215130509.86290-1-dafna3@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Add the field 'buf' to fwht_raw_frame to indicate
the start of the raw frame buffer.
This field will be used to copy the capture buffer
to the reference buffer in the next patch.

Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
---
 drivers/media/platform/vicodec/codec-fwht.h   | 1 +
 drivers/media/platform/vicodec/vicodec-core.c | 7 +++++--
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/vicodec/codec-fwht.h b/drivers/media/platform/vicodec/codec-fwht.h
index 60d71d9dacb3..8a4f07d466cb 100644
--- a/drivers/media/platform/vicodec/codec-fwht.h
+++ b/drivers/media/platform/vicodec/codec-fwht.h
@@ -123,6 +123,7 @@ struct fwht_raw_frame {
 	unsigned int luma_alpha_step;
 	unsigned int chroma_step;
 	unsigned int components_num;
+	u8 *buf;
 	u8 *luma, *cb, *cr, *alpha;
 };
 
diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
index 9d739ea5542d..8d38bc1ef079 100644
--- a/drivers/media/platform/vicodec/vicodec-core.c
+++ b/drivers/media/platform/vicodec/vicodec-core.c
@@ -1364,7 +1364,8 @@ static int vicodec_start_streaming(struct vb2_queue *q,
 	state->stride = q_data->coded_width *
 				info->bytesperline_mult;
 
-	state->ref_frame.luma = kvmalloc(total_planes_size, GFP_KERNEL);
+	state->ref_frame.buf = kvmalloc(total_planes_size, GFP_KERNEL);
+	state->ref_frame.luma = state->ref_frame.buf;
 	ctx->comp_max_size = total_planes_size;
 	new_comp_frame = kvmalloc(ctx->comp_max_size, GFP_KERNEL);
 
@@ -1413,7 +1414,9 @@ static void vicodec_stop_streaming(struct vb2_queue *q)
 
 	if ((!V4L2_TYPE_IS_OUTPUT(q->type) && !ctx->is_enc) ||
 	    (V4L2_TYPE_IS_OUTPUT(q->type) && ctx->is_enc)) {
-		kvfree(ctx->state.ref_frame.luma);
+		kvfree(ctx->state.ref_frame.buf);
+		ctx->state.ref_frame.buf = NULL;
+		ctx->state.ref_frame.luma = NULL;
 		ctx->comp_max_size = 0;
 		ctx->source_changed = false;
 	}
-- 
2.17.1

