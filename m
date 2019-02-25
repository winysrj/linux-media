Return-Path: <SRS0=o7tn=RA=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A32CCC10F00
	for <linux-media@archiver.kernel.org>; Mon, 25 Feb 2019 22:22:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6D9EA213A2
	for <linux-media@archiver.kernel.org>; Mon, 25 Feb 2019 22:22:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZR0ujHCG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727546AbfBYWWW (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 25 Feb 2019 17:22:22 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39805 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726845AbfBYWWW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Feb 2019 17:22:22 -0500
Received: by mail-wr1-f67.google.com with SMTP id l5so11718723wrw.6
        for <linux-media@vger.kernel.org>; Mon, 25 Feb 2019 14:22:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ZvTkVhC004g66pVAoaWQCbnS0Q4Lnh5O0JAznaE+x18=;
        b=ZR0ujHCGPS5Ji8TRXlyTLpfytdHyz3vtL8NM3+G1ABkPrzzIXGY4pB527su615oNeU
         kNR5jPkbL/eOQff/IKcEdVzFp5FqIcBuXc4pNkc0H4nLXE0EQDWuepR+JaQfGnEzwwFT
         KnGGFAbav2YNhbexkxydomzjffdWrCLGUuZuG4PmyQZUuVRN1oN4IJ4ukXm+dX4fbdn8
         st4OmuPInWDFPdW1h/rE25hZsvIYc2g3Mn+jaJQqLnuW1iYEv/I8KOX+O2Wa794ow4j/
         6HNWr3i9y3nlzi4aZ2OAbvDs12YgRAz32JEQkA2JdSSxj/ZeIEMt+hgeRRcOM5NATnXa
         aNVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ZvTkVhC004g66pVAoaWQCbnS0Q4Lnh5O0JAznaE+x18=;
        b=dpZR4QiWv5NNp8XVaQkESSD2Z/nmj66WnCrz7VAR03dB7qElgOYC2bsQayhcL8ImYm
         YhfvlWA/cUp6NSKhymbRZb84E6XEv1KFl331AVt/lIbgJLDsEyNXIpQzyzse1pldMmHK
         Rd8MNROLdnVbPHL5g3vpIvNFfSifC7M+Ongqgu8tswd5d9TmL8FF0/bUJsbnEGJnClBU
         RW7GwJB+ZZG8U/2uRdOxH5zEPqz6N05grZfeYVKNOORIGAJyGiwspQwT1UQ2slZggniF
         RDyJMuLsdU9nhuH672Vk6+eWeIEaJ49KmyJYDpZU8x8YmzzvOGD5rRcxTlPtga9hPRwu
         Y+sQ==
X-Gm-Message-State: AHQUAuZyRIztsm7Yb3OfJPmBOp2sHEsbmQl802PoseisM9IkeJfHFsnM
        zx7P2UKPqj3I5tysyvvFzvoZbM1sXcs=
X-Google-Smtp-Source: AHgI3IYEONfjA2TF0J2brWzHf2ZeaJKm0rhEh5qmPfvRLLIaPFkC36qoeJSxPsbaXTt/YZ8voeKaLw==
X-Received: by 2002:adf:f5d0:: with SMTP id k16mr12478654wrp.325.1551133340241;
        Mon, 25 Feb 2019 14:22:20 -0800 (PST)
Received: from ubuntu.home ([77.127.107.32])
        by smtp.gmail.com with ESMTPSA id d206sm16981422wmc.11.2019.02.25.14.22.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 25 Feb 2019 14:22:19 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH v4 11/21] media: vicodec: add field 'buf' to fwht_raw_frame
Date:   Mon, 25 Feb 2019 14:22:02 -0800
Message-Id: <20190225222210.121713-2-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190225222210.121713-1-dafna3@gmail.com>
References: <20190225222210.121713-1-dafna3@gmail.com>
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
index c410512d47c5..8f0b790839f8 100644
--- a/drivers/media/platform/vicodec/codec-fwht.h
+++ b/drivers/media/platform/vicodec/codec-fwht.h
@@ -124,6 +124,7 @@ struct fwht_raw_frame {
 	unsigned int luma_alpha_step;
 	unsigned int chroma_step;
 	unsigned int components_num;
+	u8 *buf;
 	u8 *luma, *cb, *cr, *alpha;
 };
 
diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
index 8128ea6d1948..42af0e922249 100644
--- a/drivers/media/platform/vicodec/vicodec-core.c
+++ b/drivers/media/platform/vicodec/vicodec-core.c
@@ -1352,7 +1352,8 @@ static int vicodec_start_streaming(struct vb2_queue *q,
 	state->stride = q_data->coded_width *
 				info->bytesperline_mult;
 
-	state->ref_frame.luma = kvmalloc(total_planes_size, GFP_KERNEL);
+	state->ref_frame.buf = kvmalloc(total_planes_size, GFP_KERNEL);
+	state->ref_frame.luma = state->ref_frame.buf;
 	ctx->comp_max_size = total_planes_size;
 	new_comp_frame = kvmalloc(ctx->comp_max_size, GFP_KERNEL);
 
@@ -1401,7 +1402,9 @@ static void vicodec_stop_streaming(struct vb2_queue *q)
 
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

