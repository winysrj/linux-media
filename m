Return-Path: <SRS0=99fO=RB=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39A0AC43381
	for <linux-media@archiver.kernel.org>; Tue, 26 Feb 2019 17:05:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 061902173C
	for <linux-media@archiver.kernel.org>; Tue, 26 Feb 2019 17:05:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A81mKk50"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728382AbfBZRFi (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 26 Feb 2019 12:05:38 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:43159 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727981AbfBZRFi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Feb 2019 12:05:38 -0500
Received: by mail-wr1-f66.google.com with SMTP id d17so14747435wre.10
        for <linux-media@vger.kernel.org>; Tue, 26 Feb 2019 09:05:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=dvajL4wp99YEdlSFfMaxVmGJLQp55KLRy+dOmN6R5Zk=;
        b=A81mKk507YJMCKZo6oFiHeZBb+2sANkMGhn5ZpQQ0n295Lqje4hdoyZx0/30z6nsEM
         zpccKMl8ZpHHFYaxEmCiD0FOrwrjG/mq15/DwEQCKg4xLYq3fJnZ9tbk6PQ0TsPwyvBo
         SpWpjQ6XQxn4jwx7jE8B4rDjXQ+V48M6XW7d74c4y5RZz5v0xY4/Z5Fge0ubFvhNukU6
         U+oS1zQUaC78NbHQt0QfzHHAtA7VX7S5cnDkMK6pzRx6ADqXSbMsp20vByU6X/VuFs2x
         JN7Z0+SeTB6j0YS+k0SbKvb5963rIddV2TpUIZz3uOpGQKxbV+r1kx7FmwVPYVf3TSm3
         IVhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=dvajL4wp99YEdlSFfMaxVmGJLQp55KLRy+dOmN6R5Zk=;
        b=oPxmNygNzTT1fRVA4qcq9AZ3vlmNR1aSMphmRD2YohruTjd5/GecsX+0QCicR5UDC/
         YV+Y+gKVv3AayBXNnvkO6ocFkv/DxyH31tB9bTTS08hMBi5VL9x8NxWO0q97KM+Iol6T
         vOxNwdu4qfyt7T53/ijxiQSldzP0WJsvqSkusSisIuBUmxybSSjGUh067Ah2ZVFBKUVq
         ELphJVAI77iQ/f4/C3+/a1KnBu2zArXffK7EPClhjBw9mugG8PRoGhaF5XibgdzWU+v7
         XzUEi1m47i51udrFv+5O8jYLBvG+JEu3sYML4MR4uvNWCEYUQW22IA0rqwfPDW0PFYEg
         UnUg==
X-Gm-Message-State: AHQUAuZToYtN1Ee8AzErAdXp9xLA7tMBM+FQzA7YKv7eohcx/RMUlW0j
        822QWGEVH6B1HFDXABCa8g7NVesXtls=
X-Google-Smtp-Source: AHgI3Ibued3twxlItnoF5OGgn+yInapXdeekvfVGQo52f3BBVnMIEkZXcoauwRbUM7VSq2vKpl800w==
X-Received: by 2002:adf:e3cb:: with SMTP id k11mr17617675wrm.263.1551200736133;
        Tue, 26 Feb 2019 09:05:36 -0800 (PST)
Received: from ubuntu.home ([77.127.107.32])
        by smtp.gmail.com with ESMTPSA id w4sm21024486wrk.85.2019.02.26.09.05.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 26 Feb 2019 09:05:35 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH v5 05/21] media: vicodec: upon release, call m2m release before freeing ctrl handler
Date:   Tue, 26 Feb 2019 09:04:58 -0800
Message-Id: <20190226170514.86127-6-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190226170514.86127-1-dafna3@gmail.com>
References: <20190226170514.86127-1-dafna3@gmail.com>
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

