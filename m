Return-Path: <SRS0=KHCC=RJ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A64F0C43381
	for <linux-media@archiver.kernel.org>; Wed,  6 Mar 2019 21:14:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B13620684
	for <linux-media@archiver.kernel.org>; Wed,  6 Mar 2019 21:14:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bMWHdsq7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbfCFVOT (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 6 Mar 2019 16:14:19 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:39043 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726648AbfCFVOT (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Mar 2019 16:14:19 -0500
Received: by mail-wr1-f66.google.com with SMTP id f18so119035wrp.6
        for <linux-media@vger.kernel.org>; Wed, 06 Mar 2019 13:14:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=W9KqbqFn/6YfJv+YuJSvZWh6iSIWrSMsB1/ivTkTeB8=;
        b=bMWHdsq7ZFDZw14kYuCrCnkhuIbQv0cjuV8sO3btWRTmMumb2ua0ARMDgLQQCOQhQH
         1nCBNF+rjSxP3vrqzyWXn13qjOkX5ro7ykkwkuCQoWDJ/317quzoYYbD34VqCtAxOn+C
         jivzta9C0jct3e3rvji8YLAn0RAadoqwMeKF+TnuRx9WszGpehlYa2VDh1XyDHqBs1Gp
         J47pp0UNpPE3/6OJawEvDa8tMdER4mC5esEYAHQqdw4B1rT0baSVQK+nD1dBCZD4cyuD
         iTSVMTUbP0Nc5/xh13YKWy26kd+kTOtLhXHi0l0RaCBqz6px/1YQo7sosgIfj3QHUumu
         HZ9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=W9KqbqFn/6YfJv+YuJSvZWh6iSIWrSMsB1/ivTkTeB8=;
        b=Ksosa8f7f/rqARMOogSD5b8R0ZJZ+T6BM3SEbHQtozZfLBID9Ma9UiH+ZJ35Lt0R+l
         PnY6VX/o6gqQfR8buklHyKs9m4NEF6PL6/05C1+XFsQGv8/Mo0qwWXbgWyAqi+s2N96e
         qky9JHLLU8vcsE0amWQ52IGhNgjTVpBhl/59TlNHgeg8nBm5Ygrd95aUQDI3TMBLsYCW
         j4O1iCJXWrfz/9rgkw68+6bRWwCsEe6gg7OCXsttfi8hPnSu/pZ4AFcWggaH/Lh0RW6L
         B533Z1WyxsPNJ0exXG35Fgm9N2XgA0+wMO12b9KBzMQDsYsghOLU5EMY6ArsvJn0bXMW
         A3AA==
X-Gm-Message-State: APjAAAVAgf6zdg9cEq9vdb/CP626lyzJDJNlPv1DquKei6KGGaxUWPyX
        Y0Nt10GezStv3ses/79htLGC05C7bPo=
X-Google-Smtp-Source: APXvYqz9Ms08hu8s1nGr1kl2e7YnHvhVfHSzUfmgI/jZ6vCkxENWk6cVtpjGS0zgB3XoefzdzfOywQ==
X-Received: by 2002:a5d:6252:: with SMTP id m18mr4164541wrv.199.1551906857070;
        Wed, 06 Mar 2019 13:14:17 -0800 (PST)
Received: from ubuntu.home ([77.124.117.239])
        by smtp.gmail.com with ESMTPSA id a9sm1882126wmm.10.2019.03.06.13.14.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Mar 2019 13:14:16 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH v5 09/23] media: vicodec: bugfix: free compressed_frame upon device release
Date:   Wed,  6 Mar 2019 13:13:29 -0800
Message-Id: <20190306211343.15302-10-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190306211343.15302-1-dafna3@gmail.com>
References: <20190306211343.15302-1-dafna3@gmail.com>
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

