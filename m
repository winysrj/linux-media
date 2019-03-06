Return-Path: <SRS0=KHCC=RJ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D060C4360F
	for <linux-media@archiver.kernel.org>; Wed,  6 Mar 2019 21:14:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D6C7720684
	for <linux-media@archiver.kernel.org>; Wed,  6 Mar 2019 21:14:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U5FHVP4y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726646AbfCFVOI (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 6 Mar 2019 16:14:08 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:50372 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726556AbfCFVOH (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Mar 2019 16:14:07 -0500
Received: by mail-wm1-f67.google.com with SMTP id x7so7316629wmj.0
        for <linux-media@vger.kernel.org>; Wed, 06 Mar 2019 13:14:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Z1jDQ2uZhsiJD3Dk2zOYxfBXHk1iczGdhf5c/i9EnwA=;
        b=U5FHVP4yGAerCdex/lCbznsVXiL2NXFJXGp2Ys3tfM1pVV94ZfNVRGKzAzxUmNRntu
         aD5LaLu6xhziv2yweMOlUp9eNyCmbF45cRVWihI3mHUwkM6SEHsSikzqbwZxa1s5NHnH
         85wfSmZZIBP0cPjlb/O8Yad7FwRrRq6mj8tJl18l1YgJMA1zr6G8tzhr1cEqfAxHTwMH
         sePitM14PsUNeWYUGaPRZooq26o3WSqA618B2k/lZ6QeSINNt+6DrrohqVU9qjVMk/fR
         PJ7XmV/f8E0E+NGWXNkg/Ip0rDZxwchzrA6Bd0QuXppORENjH+LxMmSIWHFdTee24Qwz
         Nxyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Z1jDQ2uZhsiJD3Dk2zOYxfBXHk1iczGdhf5c/i9EnwA=;
        b=SVTQQrASz7OkZ5u+mGuJR4+7wxPoxr6OTq21GHt8InyIX8UtK/h+yQ7OXvctGVl/WW
         Ib1h403E3LhGyBucXfHVT6IR+e2QXxBc9Pmj/jlnnoGyhygvD2B2Fx0/KwirZnP8mbjX
         TpAjcV3FmscLNxh0vYnE4Aj6txHu4et8652oK+ZA0v0z0TdowF+0jyNoPJvD2CSN5FqD
         gPn8oW/EwcuyD/LAPy67nswcXOetY7ewza9feRFUtNsN64vpZEwwST4vhZvkBI+gfCJ8
         AYUlMTnA0Z+Dh3KslBFWTy3NpKSPPXd+cPmtjvcBID54RipldEvAkEweeLqAYYL8+7fD
         vL6g==
X-Gm-Message-State: APjAAAVi+5fd4aTG5MrtfpFxhwyPpI9vEnpkb8+lXfmO7ytEa4J+EpOO
        kx1SROfNnhzOgFYrG4DQGMQ/LIAFILQ=
X-Google-Smtp-Source: APXvYqxc3iRFKj+z6mITmre0dUJTO9DoiTBfGensVyEhfOmorhPShi5sl7WYO24XO6HtaEVNtLYVog==
X-Received: by 2002:a1c:4c1a:: with SMTP id z26mr3700549wmf.139.1551906845365;
        Wed, 06 Mar 2019 13:14:05 -0800 (PST)
Received: from ubuntu.home ([77.124.117.239])
        by smtp.gmail.com with ESMTPSA id a9sm1882126wmm.10.2019.03.06.13.14.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Mar 2019 13:14:04 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH v5 03/23] cedrus: set requires_requests
Date:   Wed,  6 Mar 2019 13:13:23 -0800
Message-Id: <20190306211343.15302-4-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190306211343.15302-1-dafna3@gmail.com>
References: <20190306211343.15302-1-dafna3@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

The cedrus stateless decoder requires the use of request, so
indicate this by setting requires_requests to 1.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
 drivers/staging/media/sunxi/cedrus/cedrus_video.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_video.c b/drivers/staging/media/sunxi/cedrus/cedrus_video.c
index b47854b3bce4..9673874ece10 100644
--- a/drivers/staging/media/sunxi/cedrus/cedrus_video.c
+++ b/drivers/staging/media/sunxi/cedrus/cedrus_video.c
@@ -536,6 +536,7 @@ int cedrus_queue_init(void *priv, struct vb2_queue *src_vq,
 	src_vq->lock = &ctx->dev->dev_mutex;
 	src_vq->dev = ctx->dev->dev;
 	src_vq->supports_requests = true;
+	src_vq->requires_requests = true;
 
 	ret = vb2_queue_init(src_vq);
 	if (ret)
-- 
2.17.1

