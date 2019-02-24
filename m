Return-Path: <SRS0=d4St=Q7=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0427AC43381
	for <linux-media@archiver.kernel.org>; Sun, 24 Feb 2019 09:03:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C685820652
	for <linux-media@archiver.kernel.org>; Sun, 24 Feb 2019 09:03:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="o0oOXt97"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728176AbfBXJDB (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 24 Feb 2019 04:03:01 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36442 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728171AbfBXJDA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 24 Feb 2019 04:03:00 -0500
Received: by mail-wm1-f66.google.com with SMTP id j125so5427914wmj.1
        for <linux-media@vger.kernel.org>; Sun, 24 Feb 2019 01:02:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=cdbAx39js5NverI3DEvBFyhQC6S1f7hf9HQO4u/9CQ8=;
        b=o0oOXt976MYxZdttWVmjyyx42Hjjv9oXV/p5aZujyyL1WYHPJztWc1uqHMVAVZqDDl
         /QUYnRXPJwY7SEmBbEBtBGfNsrNvlrbNna9gorw/Ljxxj9kw8hiUTeS6zDLSj8l+SbEv
         xpYYPmM9MG13F2mH4EguK5U185tWlSvUugQrXDKOrm3CFawQyHJ5OzkH4he9P30nE0WC
         jqrWMU6u/yghamTEYNPxaZcAQVKx/i79iO4cEulkRDdHBITMFyLccKW96+ORFhTafNst
         6CgkddbeuAlXzzzFiamyIli8Mxdecp6AgAwU7ZxNUmFoKRJ+mppqcoL1rVAxmvGtZVpx
         qApg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=cdbAx39js5NverI3DEvBFyhQC6S1f7hf9HQO4u/9CQ8=;
        b=DScm/7CHRRD9UQleOQJPP/g8KiZMzDvAsqwOXTAjULJXW1xuHtDskp8RO+P/VJabaZ
         jnIiJzeHmUGZArYl6jxaaP/eUHkQWLu77na3cqL2xMLe/Jk9+zfMrQJ7SMGHClkYIEiz
         ZBVdvlKbv7Py2c9QaiyE63KgrztOOPk1wcZ3BLOqJQkUfj8ZHE8IlBg4H7mcemOpAMsS
         8Gp58zJHq82sZSZtZ315L2nrATG0pNFC8uYh/Xu01CiH9FL9s5OsCkw53mNzqLSw+C8R
         bkFDI4+s/gzbMrWdnBO3eaO8BjFAexPm87t4EcOgtXG0kMybyaJYixwjRAGwVhF4hyPa
         zK/w==
X-Gm-Message-State: AHQUAuZVPn4tPguAMVVS2Wd6ElpRok51ddLAelAAuxANpkHgeBrcZXtt
        a57YDy6xwfavuoJcD3jIpvbnYypA7cU=
X-Google-Smtp-Source: AHgI3IZTo4z1FpTrSTSXSqmWkFsKZxaSljSawjdqpvQRSuANNwkc1HB/FV9LEQZSzMtkw/bJCqbmJg==
X-Received: by 2002:a1c:f510:: with SMTP id t16mr3137681wmh.105.1550998977952;
        Sun, 24 Feb 2019 01:02:57 -0800 (PST)
Received: from ubuntu.home ([77.127.107.32])
        by smtp.gmail.com with ESMTPSA id e75sm8701971wmg.32.2019.02.24.01.02.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 24 Feb 2019 01:02:57 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH v3 06/18] media: vicodec: change variable name for the return value of v4l2_fwht_encode
Date:   Sun, 24 Feb 2019 01:02:23 -0800
Message-Id: <20190224090234.19723-7-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190224090234.19723-1-dafna3@gmail.com>
References: <20190224090234.19723-1-dafna3@gmail.com>
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
index b92a91e06e18..778b974e9624 100644
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

