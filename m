Return-Path: <SRS0=c0D3=QM=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E45DAC282CB
	for <linux-media@archiver.kernel.org>; Tue,  5 Feb 2019 18:23:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BA7FC2083B
	for <linux-media@archiver.kernel.org>; Tue,  5 Feb 2019 18:23:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pqqXUjRy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729647AbfBESXO (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Feb 2019 13:23:14 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:40438 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725921AbfBESXN (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Feb 2019 13:23:13 -0500
Received: by mail-wm1-f66.google.com with SMTP id f188so4748038wmf.5
        for <linux-media@vger.kernel.org>; Tue, 05 Feb 2019 10:23:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=qNX1eGncfgtS+MlSLY2sPSD9GA/R6HOp6rwO6JizSVg=;
        b=pqqXUjRy5O/Y50HXsRabiVz0XrXiIV+5tPIYCVaRH+UZqnHfqv6oBIk47E81J1fNpV
         x+aLXhzjF7YkT1Jhz7SC9CDgxV3UwaADgsCY7DZAPNpvUbprvKMHYVmJz7f/D4YvXWl7
         vmz6vctq+HT44578lyP05zJR+7YMsEhf4+YX45n+67P3pFgySvJbaxXQ880H3YExoazK
         eHwLeqUoHHH+yZ+HkHKZuFZDHTZeHdy79rTBno2QGfGfXpckO6ijfTTLXPyKOijY+iQu
         aRSIYTMfeDJ0GTgFCTk35P94DHCocnNoHqv8h30XtWescBGgJ0t5yWbK6XYSWPTGO2QW
         JYaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=qNX1eGncfgtS+MlSLY2sPSD9GA/R6HOp6rwO6JizSVg=;
        b=rDBEkvPU05OmyxTuOPUHy9AGOlD6pC1stFO/Urs4nR6mR1y9hQJGbtExP11Y3NhoYF
         zSdtgtB6JKfj+UNXNtj2126IlBifQvjYRxu5y6a9exXm8ljTx2sFDmHm8erU5isRGuWM
         8gPITec82l3TgOAHukt6cfncgnOQOvT/40edECztsB+xt1/AgQ5IPBlgrYdwQuAGp0qq
         0ggqLvNEW1E9/jDTCs35VDAYMfCuekO9f+baEFxloNJzFme5d1tP5TPkDXuJgy57+a81
         +p7Biewsk+67cZHHscquLaGZMwIQG6ycF1QPObQJck8ukI9cWezMdy3csIIxM6vXPiCn
         Nybw==
X-Gm-Message-State: AHQUAuZy/EsNgpYGHVKuXpF+v7rVzoYGwLDJ65UXHerSi2g4SWdjMYQn
        sKGaiZcYZtQ9p70NiFDe5udBGkPlqmM=
X-Google-Smtp-Source: AHgI3IZIRdA1J8f9FUGohnE2/2IOrq5Pv+nIc83xx9Rw+PIKrHNeBvT4z6rTi/9VGbWSwx+A2V1HSw==
X-Received: by 2002:a1c:544f:: with SMTP id p15mr4732801wmi.37.1549390512459;
        Tue, 05 Feb 2019 10:15:12 -0800 (PST)
Received: from ubuntu.home ([77.127.107.32])
        by smtp.gmail.com with ESMTPSA id w125sm34296778wmb.45.2019.02.05.10.15.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 Feb 2019 10:15:11 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH 2/3] media: vicodec: add field 'buf' to fwht_raw_frame
Date:   Tue,  5 Feb 2019 10:14:41 -0800
Message-Id: <20190205181442.109681-2-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190205181442.109681-1-dafna3@gmail.com>
References: <20190205181442.109681-1-dafna3@gmail.com>
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
index 3703b587e25e..cb1abccdf13b 100644
--- a/drivers/media/platform/vicodec/vicodec-core.c
+++ b/drivers/media/platform/vicodec/vicodec-core.c
@@ -1354,7 +1354,8 @@ static int vicodec_start_streaming(struct vb2_queue *q,
 	state->stride = q_data->coded_width *
 				info->bytesperline_mult;
 
-	state->ref_frame.luma = kvmalloc(total_planes_size, GFP_KERNEL);
+	state->ref_frame.buf = kvmalloc(total_planes_size, GFP_KERNEL);
+	state->ref_frame.luma = state->ref_frame.buf;
 	ctx->comp_max_size = total_planes_size;
 	new_comp_frame = kvmalloc(ctx->comp_max_size, GFP_KERNEL);
 
@@ -1403,7 +1404,9 @@ static void vicodec_stop_streaming(struct vb2_queue *q)
 
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

