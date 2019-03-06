Return-Path: <SRS0=KHCC=RJ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECFCBC43381
	for <linux-media@archiver.kernel.org>; Wed,  6 Mar 2019 21:14:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BA639206DD
	for <linux-media@archiver.kernel.org>; Wed,  6 Mar 2019 21:14:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hBwjseTM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbfCFVOQ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 6 Mar 2019 16:14:16 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:50384 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726648AbfCFVOP (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Mar 2019 16:14:15 -0500
Received: by mail-wm1-f67.google.com with SMTP id x7so7316918wmj.0
        for <linux-media@vger.kernel.org>; Wed, 06 Mar 2019 13:14:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=vMyMpGqqdM36AhawPTalbjw4IFBI0qu83CyqC1tgsXE=;
        b=hBwjseTMudsuBG8AgZyQ927GgNp8nMVL/MfGoIFaZOjQawwYj7z8EYKIuqMZZ65dtC
         b609MnrIzuQsAiKQ6U5ZCxngMV6wis6zKFxEDbOtBDkgJZzOvmrlJd/RcuqaE9CECsaB
         pFwI2GM3YKJlJdKzjXwKlaXKveal488hEhfjWcgIIfStvckf2vg5Si435wKtz30mITxG
         ywUB0R+ZXMuVjj9J6Rd0h5IQd7EUhLaNMQtBNkO48w+eEEX6RhcP2EeCtlkdXQJ34dR/
         gyfGMoW3R1bYe42VenLfkUlLZmO/om8WAS0QU3JY3P8bxtFXkwbCDEkip0LDqYAQb0mN
         g7yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=vMyMpGqqdM36AhawPTalbjw4IFBI0qu83CyqC1tgsXE=;
        b=ZKiNIyJ/3bibrMU6L4eAhU/MLtoXwEI1kAyqsELllSf4nTKdBACC+hGE/DQMW9aLeG
         lCWtES9/gHEvf+D9LJFrIZEx0VDwuoDJGjEyr/Eb6THqqhfuxPKglcdpoz/nOpOPdnJ+
         sqb1rM+CM38EiIJBJk9gMehOEz2uSVgyjaucVIZ/1kELHVeYhy2rg3SL/Ss+7Kb8hHvk
         hBqY0/RrZNv3CmWzuuc5/9D4G6g5kEoNRpKVRc1dq/MgoOn/eKnm371ekrhjaFubBdwA
         dRGbIUSaVxy/eKCg6W3twQd/lfulGJ6anqDSW8tk1UDYTQVuf3a3B2xNcY9Lr3ovmhqV
         KlTg==
X-Gm-Message-State: APjAAAUj7pS0ImR3JhbfM6xXOPXwPiZeqpzwI/sBfBl4s0p/bYAZ3R0f
        YrK/WZefI7WbHs0JtpbNCYffF4yhFn8=
X-Google-Smtp-Source: APXvYqwnCf0tNWZgzKvaSxCzJDejrn1iENurYMgHLcQOpEXGMNn14v7PCas48JbRDEbB6sVcqcL8iQ==
X-Received: by 2002:a1c:e0d7:: with SMTP id x206mr3702412wmg.152.1551906853491;
        Wed, 06 Mar 2019 13:14:13 -0800 (PST)
Received: from ubuntu.home ([77.124.117.239])
        by smtp.gmail.com with ESMTPSA id a9sm1882126wmm.10.2019.03.06.13.14.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Mar 2019 13:14:12 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH v5 07/23] media: vicodec: change variable name for the return value of v4l2_fwht_encode
Date:   Wed,  6 Mar 2019 13:13:27 -0800
Message-Id: <20190306211343.15302-8-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190306211343.15302-1-dafna3@gmail.com>
References: <20190306211343.15302-1-dafna3@gmail.com>
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

