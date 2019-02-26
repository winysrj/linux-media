Return-Path: <SRS0=99fO=RB=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A428C43381
	for <linux-media@archiver.kernel.org>; Tue, 26 Feb 2019 17:05:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F20E220C01
	for <linux-media@archiver.kernel.org>; Tue, 26 Feb 2019 17:05:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MiK+6Btx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728289AbfBZRFf (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 26 Feb 2019 12:05:35 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:34499 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727981AbfBZRFf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Feb 2019 12:05:35 -0500
Received: by mail-wr1-f66.google.com with SMTP id f14so14812310wrg.1
        for <linux-media@vger.kernel.org>; Tue, 26 Feb 2019 09:05:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Z1jDQ2uZhsiJD3Dk2zOYxfBXHk1iczGdhf5c/i9EnwA=;
        b=MiK+6BtxK5sDFnncnyj/GTJdm6dAj4WWzNDSpr2o0QOPgqicPycxurCLNXyDWQvUWi
         qd1PRXbYwPtfu8/DiANutrrZHDPTItsKxHYPdKZsGquBAsw0NnGOsIVZeIP8bHsTN+6t
         JWxNLDebanx00eoek51IsGvE64wIEKcdcjaMM5CvPih7t2uWK2N58hZg/h0t8zaWqAnH
         neSnChbFh9HnHyxMwdwN1883swqKn81KzyD1ONt2GiU6QaOPXmSDabtJ8fZ++zd6YJQ0
         Lxguas8ajh5YKbmdEgSh/nnQ2F1E5YXxXuNw04Uash6amkAUn/05h5PBd3VnQoZZ/TnS
         vfRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Z1jDQ2uZhsiJD3Dk2zOYxfBXHk1iczGdhf5c/i9EnwA=;
        b=mZUVfhmyciCetpI5JjYqoR6YiXnJHCYd2knhAgDB2+0Qmsfbqz3Kbof5ewkfPEliEh
         h33iXEDoOOMMCRhTaoZUi4NI8vxkJLr3yWZMqBoB9HR9vQZ9aQfEZyblBQo/OxxMZ2hs
         jv541HF/FOtRmAgjHZUoBgsLqznYChpyzAx5PPIAruBmjLn0Pvyb7TYf60lyayf3SYPR
         pypjWAcOkEOoF4tLmD9mnmJf7oR13KVa/oel8ptC4B213AYE+0N4cxruUXzv+xos3ZM3
         TRl/37XlTwljOIB4Hw4KNMiNXrQuSlItt4ebVQuw4uj5LLLVhwPUQPUl07E/wn5+viHU
         kZ+g==
X-Gm-Message-State: AHQUAualO54OkqTAq/3KG+zmtkEUSKUFIyT8h9uFHMgWjc3AYR3XDYWX
        8YWintPm4/3Kp5s7L3wph71kONwmTgg=
X-Google-Smtp-Source: AHgI3IbtSTREZzJMf/iLycFgixdPrky/ARKpIgdo2vbGq9n9OeFVQLpv7orEj0ToIv/Qi+3yxm/NaQ==
X-Received: by 2002:adf:ee01:: with SMTP id y1mr16799126wrn.268.1551200733238;
        Tue, 26 Feb 2019 09:05:33 -0800 (PST)
Received: from ubuntu.home ([77.127.107.32])
        by smtp.gmail.com with ESMTPSA id w4sm21024486wrk.85.2019.02.26.09.05.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 26 Feb 2019 09:05:32 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH v5 03/21] cedrus: set requires_requests
Date:   Tue, 26 Feb 2019 09:04:56 -0800
Message-Id: <20190226170514.86127-4-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190226170514.86127-1-dafna3@gmail.com>
References: <20190226170514.86127-1-dafna3@gmail.com>
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

