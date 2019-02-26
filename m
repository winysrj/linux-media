Return-Path: <SRS0=99fO=RB=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E635C10F0B
	for <linux-media@archiver.kernel.org>; Tue, 26 Feb 2019 17:05:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C9D720C01
	for <linux-media@archiver.kernel.org>; Tue, 26 Feb 2019 17:05:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X5Wn2K3w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728456AbfBZRFk (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 26 Feb 2019 12:05:40 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:39422 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728385AbfBZRFk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Feb 2019 12:05:40 -0500
Received: by mail-wm1-f68.google.com with SMTP id z84so2961944wmg.4
        for <linux-media@vger.kernel.org>; Tue, 26 Feb 2019 09:05:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=vMyMpGqqdM36AhawPTalbjw4IFBI0qu83CyqC1tgsXE=;
        b=X5Wn2K3w/shNkYNCaYsmHbk8WLQv9YOsC/IyO0nfHg5hdgpz/a7rkz+OI7aDG/NLFy
         r5ecq7wTagVE5zQfwrINERNwln6fbDJyWsvPj3yBgXa/Wrjrgc9w2ATEOvMN9ud2GUjC
         LRTnCAqRO48JORAgaRoM6qnX9BWEmtks7MtKlKM4/aMbkcFn9g5elSYt2ChTk03kFqxD
         KWboOV16rCzWma+7wky1YPxWaORQK1aCWU6vVAqQGcXrXf6K5yZ4hlNscMV8kt0NDEji
         vzSj3uj7m88XB/MoyDQQ00xb8xITDSkE5CQT02PQQuN/AMhJmDcOV+PcWJ+DibOlZ1BA
         1okg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=vMyMpGqqdM36AhawPTalbjw4IFBI0qu83CyqC1tgsXE=;
        b=ruByl5P4bXMycof79tI7BxVG+heQ/3niKbmxZkFRUisv3Dy51sGSoijmcxjl3TUN4x
         5uITzmPTyryhj7a1MWArrbWLkiu6JG3k1IRPeggNPmtPiWvm886PgnlKXp0WWrW9ch1X
         /kAVU5pk8MJYemQoL/PEXAcmtJf06jjmfThhu//salmHs07dfJQkMJX1cyR3Jw7Ckg+V
         5nX/u5LforfO+5gMiV/ovlYZBWRMp9pn98NRnAzI2LeRM0ObBkeVd72itogpSh6EF12x
         GKCy5iWOIiJUVb/W9bodsLxC3ceC17CDHJP3xX/2Ac5pNuCg0jyhHkuOvZjetNHPnXKS
         ywUg==
X-Gm-Message-State: AHQUAuYUQvNTlVAOYCMSte7qTntSUYdV3MqOZWX/bkmkj4Y+3K8/SbOi
        taT6YJcbH3m5ZTmxY1Vf7brYg6CjAK8=
X-Google-Smtp-Source: AHgI3Ib5nT+hd+Wn9sCE8jDOMuZpJQlyE2cqL0ry1d7WwxPCXA0mXvogZAB+/2+cU/9NOU1thefmVw==
X-Received: by 2002:a1c:700a:: with SMTP id l10mr3574712wmc.13.1551200739054;
        Tue, 26 Feb 2019 09:05:39 -0800 (PST)
Received: from ubuntu.home ([77.127.107.32])
        by smtp.gmail.com with ESMTPSA id w4sm21024486wrk.85.2019.02.26.09.05.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 26 Feb 2019 09:05:38 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH v5 07/21] media: vicodec: change variable name for the return value of v4l2_fwht_encode
Date:   Tue, 26 Feb 2019 09:05:00 -0800
Message-Id: <20190226170514.86127-8-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190226170514.86127-1-dafna3@gmail.com>
References: <20190226170514.86127-1-dafna3@gmail.com>
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

