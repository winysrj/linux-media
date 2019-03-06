Return-Path: <SRS0=KHCC=RJ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83A89C43381
	for <linux-media@archiver.kernel.org>; Wed,  6 Mar 2019 21:14:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5283420684
	for <linux-media@archiver.kernel.org>; Wed,  6 Mar 2019 21:14:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="khLq6w5s"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbfCFVOM (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 6 Mar 2019 16:14:12 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38623 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726648AbfCFVOL (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Mar 2019 16:14:11 -0500
Received: by mail-wm1-f67.google.com with SMTP id a188so7219000wmf.3
        for <linux-media@vger.kernel.org>; Wed, 06 Mar 2019 13:14:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=dvajL4wp99YEdlSFfMaxVmGJLQp55KLRy+dOmN6R5Zk=;
        b=khLq6w5s4n+HFM5DlbDHVj+niETS4gGqthKaqGwqmzLxD4s+R7HxoGp8bpVgtadhHz
         f2RR/QGithVxni6IhuYoGFfAi3R/TDQDK3wXqIIhT14WAxzt7BuYbtd3ay06CqtNwe2u
         DtDBAG7F4GMl2VhXKmYUA02ZHFV/aYnZ2Zf9pixYKe2+y98UTK0mj6Vsx/rK3CSJsSTd
         ApkTmg/VT8qK9arf3/Niwq1VZmIzuaS4LjWJ56zJwWhg5bMS4LJcakbwjc6Dec1exudC
         0XcyWxd7vyZdR9pT3Ht15RzW21bJxJmlMOgHTGqe3a0PdJD0f8J4yWe2hQSgcS91ksmI
         aG9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=dvajL4wp99YEdlSFfMaxVmGJLQp55KLRy+dOmN6R5Zk=;
        b=uHnnSXzrv2D9cgbsx64c3lfhPzXyBP77LjjtnJjdsomRA8q31NJmkVpnx6VZf+w3nR
         bmkyP0XxZnPPkMWmHQHBJmaHjFe/cnwBoBFj2kWafg3MZK+uBc74Tc0IlFnufelFWZxt
         nTK4AAA4rhZRuO+NcHTxCRNgykunLJo+g91rJqwLfncZkO6aPQ2mrgqu/bVYmFauRhrl
         K20NIV7lWbHuY4IffEhEhe9uLi+9sfpquJ1XN1mhX92b+3djjXa96t4i7nm7TSEnRa8Y
         rYCp81Q6XHt4zxECXRmtFXa+QLBXVaIqqtGrtgB/XF62bvqzThjd35u5Oa0EtXiNV6vS
         pPPQ==
X-Gm-Message-State: APjAAAWPWjTq7m4TxTWtbT9zH+OmlNx5Ikm16oCsSHtkgj8FO4HcSWyh
        XKgUqnDYMn9ZanIL5LKipcvlREgAUXU=
X-Google-Smtp-Source: APXvYqyq8WM4llzWezN3pXfzKJizGq/VG9VwOVQzJXNTvoTjg4pIkMoX+MKcXGmUsMIg6KycdUlLVQ==
X-Received: by 2002:a1c:2743:: with SMTP id n64mr3847569wmn.143.1551906849545;
        Wed, 06 Mar 2019 13:14:09 -0800 (PST)
Received: from ubuntu.home ([77.124.117.239])
        by smtp.gmail.com with ESMTPSA id a9sm1882126wmm.10.2019.03.06.13.14.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Mar 2019 13:14:09 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH v5 05/23] media: vicodec: upon release, call m2m release before freeing ctrl handler
Date:   Wed,  6 Mar 2019 13:13:25 -0800
Message-Id: <20190306211343.15302-6-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190306211343.15302-1-dafna3@gmail.com>
References: <20190306211343.15302-1-dafna3@gmail.com>
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

