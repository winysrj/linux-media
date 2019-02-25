Return-Path: <SRS0=o7tn=RA=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 716CEC43381
	for <linux-media@archiver.kernel.org>; Mon, 25 Feb 2019 22:20:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3DDD2213A2
	for <linux-media@archiver.kernel.org>; Mon, 25 Feb 2019 22:20:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G6WhFluT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728128AbfBYWUC (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 25 Feb 2019 17:20:02 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:47020 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726919AbfBYWUB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Feb 2019 17:20:01 -0500
Received: by mail-wr1-f65.google.com with SMTP id i16so11676804wrs.13
        for <linux-media@vger.kernel.org>; Mon, 25 Feb 2019 14:19:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=dvajL4wp99YEdlSFfMaxVmGJLQp55KLRy+dOmN6R5Zk=;
        b=G6WhFluTIr8+Np1J5/2+MiOU6meGNuPZ26838n/ZZxzC2cpsuN+molId41QI0FIXkk
         FcFXKoHk4bHiwauQepFUyUe+TH8sc+RqrJGKiddnLUYccugYEloydcdAFvRP8rpOZsE/
         vAD58pc5lKWPFHtYm1KYZsib0AnhCmfLyX8pJqEZhMTw9by8xvM90ep0ZW279KfeOd1o
         pzmF7qqAc/mUzdQqUPFN/n+A5IV7NIsebR4s0Qq29ClqsqLyUyN4DybL3hELcvb+X1Rg
         syNVQjlpsU1Dngi25vdsxjYeoQRfIlWwQP6Tply142gc14U384Sb+Rpcdpm6v1Bef5n4
         P6Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=dvajL4wp99YEdlSFfMaxVmGJLQp55KLRy+dOmN6R5Zk=;
        b=HR+pORtc3LmZrQakx0NbIm4KeQ9fuQyEKm6/SAKGteRRdH2DXn4FXc8rQEGwjCbtTc
         3XRgeH68gawWWi0RfxtLcnXgzDT00UA+e7hlYm+9ock39+7PdXRPKfTdq9mP9jfUBdhk
         hha3r8fgs5/3feldFi6zHEk9VIq9pHxPOoVM7FdTHW4zOXphvREMauT9KzxIoG5osxFZ
         mx9S88BZmB4Ym6mOHu926HLR3CG+DadbwsVPkK76xhty7RQOwq6sdY3pPgdUde5gaYl5
         PcQflNNyc80m2QdVjnYK6V5WJc1EoAJgBTwBTbrQaUjJ2ouCxDXqmyIsXgeSzTar63yi
         fzNg==
X-Gm-Message-State: AHQUAuZQQsS2CM0vU3lq4t8zttIQDZPLg3mCpQ3RYoe6vKrV0VtGhGTO
        +FVx7y8AITJUFPzSu4Gpb5hxjoNTojA=
X-Google-Smtp-Source: AHgI3IYQgoiqUBR2wAbaY4G6UlmwvYbd/OWS+l4AZcLex2cXQwOJY+g/8odQhqiedH9znXcLi6MikA==
X-Received: by 2002:adf:f7c9:: with SMTP id a9mr14939865wrq.39.1551133198962;
        Mon, 25 Feb 2019 14:19:58 -0800 (PST)
Received: from ubuntu.home ([77.127.107.32])
        by smtp.gmail.com with ESMTPSA id a20sm4168033wmb.17.2019.02.25.14.19.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 25 Feb 2019 14:19:58 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH v4 05/21] media: vicodec: upon release, call m2m release before freeing ctrl handler
Date:   Mon, 25 Feb 2019 14:19:29 -0800
Message-Id: <20190225221933.121653-6-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190225221933.121653-1-dafna3@gmail.com>
References: <20190225221933.121653-1-dafna3@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

'v4l2_m2m_ctx_release' calls request complete
so it should be called before 'v4l2_ctrl_handler_free'.

Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
---
 drivers/media/platform/vicodec/vicodec-core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
index b92a91e06e18..0909f86547f1 100644
--- a/drivers/media/platform/vicodec/vicodec-core.c
+++ b/drivers/media/platform/vicodec/vicodec-core.c
@@ -1606,12 +1606,12 @@ static int vicodec_release(struct file *file)
 	struct video_device *vfd = video_devdata(file);
 	struct vicodec_ctx *ctx = file2ctx(file);
 
-	v4l2_fh_del(&ctx->fh);
-	v4l2_fh_exit(&ctx->fh);
-	v4l2_ctrl_handler_free(&ctx->hdl);
 	mutex_lock(vfd->lock);
 	v4l2_m2m_ctx_release(ctx->fh.m2m_ctx);
 	mutex_unlock(vfd->lock);
+	v4l2_fh_del(&ctx->fh);
+	v4l2_fh_exit(&ctx->fh);
+	v4l2_ctrl_handler_free(&ctx->hdl);
 	kfree(ctx);
 
 	return 0;
-- 
2.17.1

