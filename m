Return-Path: <SRS0=o7tn=RA=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BAFCC4360F
	for <linux-media@archiver.kernel.org>; Mon, 25 Feb 2019 22:20:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2CFBD213A2
	for <linux-media@archiver.kernel.org>; Mon, 25 Feb 2019 22:20:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rRZk9JQS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728326AbfBYWUH (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 25 Feb 2019 17:20:07 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:51873 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728207AbfBYWUG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Feb 2019 17:20:06 -0500
Received: by mail-wm1-f65.google.com with SMTP id n19so505824wmi.1
        for <linux-media@vger.kernel.org>; Mon, 25 Feb 2019 14:20:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=W9KqbqFn/6YfJv+YuJSvZWh6iSIWrSMsB1/ivTkTeB8=;
        b=rRZk9JQSXEmWbNLdFGeXYvfZM8QQlYJIozno3gInAVEnE/GbL83kwJ9fJYnFtSUEYQ
         GEzZwGiNt8xP++ywgGkmPcYszKUC4J7g9JsoZvDuo7DxISrgCgIXg+5QZAiB5wWBqU04
         cIZq04iMppk7yPVptNsTtuk0xndxx8pSeN5rws0voJNs5jY6G1tVYo5RB9dXBIi1b+sM
         5H89zR385GPZ0qeuQJisvHDNVHnuEFE+4nWk40916XIQcP4uthBgPu/u6Trwbkzomp39
         JqOnQ2oYmGMgSOnhOhejcH97gpugmy4VOCOy25daMH39BQ/mCuS3scT30ZKvEp99KPxL
         UCwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=W9KqbqFn/6YfJv+YuJSvZWh6iSIWrSMsB1/ivTkTeB8=;
        b=IJmGkEWJqmkn9v8eFNxkjuHOAroFaBA1CDkArsN/1iZQCymHBae6RWIUQoIh5nq+Wj
         xu7+r+Egq5fL321PZYIvZx0zqUWrqo5oTyIcew+7F6LNi8iHoYaXfKwrma3li71iNS2C
         rmEuddubckUrg9jWCvIxy8B00qpSAE10SyTErFSEMtnEh9/dwL/RNoEGT1bFzJ35OyyW
         gnacGpXpXzfcZ0W3FzBYsdLQ3s+xSuL4kv8rIILU7YnBieR8eKfYLG7KnSp82Xri4hGG
         s2p9gSDwp1PAHXKNyveDHC4aWxpaeUiZyedQHI/JqAb/FCvIrT0HQe4zVqfAByN7EMJs
         d0nQ==
X-Gm-Message-State: AHQUAuZEuknV2WAsKpM5VxXxogd09O8K/QU4GAV41sLdyYv6DV5zloED
        BR6rDvPgdbHSr3dVe5Ih189piEJeEAM=
X-Google-Smtp-Source: AHgI3Ibl/wNNJeMH1T7vWO0nJzqrx7rY9dCWii0M0+1stpTGRss/zP/Id+pcA2mP8aFcrFXvJ64n5Q==
X-Received: by 2002:a7b:cbcd:: with SMTP id n13mr597778wmi.92.1551133204495;
        Mon, 25 Feb 2019 14:20:04 -0800 (PST)
Received: from ubuntu.home ([77.127.107.32])
        by smtp.gmail.com with ESMTPSA id a20sm4168033wmb.17.2019.02.25.14.20.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 25 Feb 2019 14:20:03 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH v4 09/21] media: vicodec: bugfix: free compressed_frame upon device release
Date:   Mon, 25 Feb 2019 14:19:33 -0800
Message-Id: <20190225221933.121653-10-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190225221933.121653-1-dafna3@gmail.com>
References: <20190225221933.121653-1-dafna3@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Free compressed_frame buffer upon device release.

Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
---
 drivers/media/platform/vicodec/vicodec-core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
index 8205a602bb38..8128ea6d1948 100644
--- a/drivers/media/platform/vicodec/vicodec-core.c
+++ b/drivers/media/platform/vicodec/vicodec-core.c
@@ -1614,6 +1614,7 @@ static int vicodec_release(struct file *file)
 	v4l2_fh_del(&ctx->fh);
 	v4l2_fh_exit(&ctx->fh);
 	v4l2_ctrl_handler_free(&ctx->hdl);
+	kvfree(ctx->state.compressed_frame);
 	kfree(ctx);
 
 	return 0;
-- 
2.17.1

