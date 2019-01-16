Return-Path: <SRS0=IHIA=PY=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9ABABC43387
	for <linux-media@archiver.kernel.org>; Wed, 16 Jan 2019 15:25:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 609AD205C9
	for <linux-media@archiver.kernel.org>; Wed, 16 Jan 2019 15:25:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G1mEwA7d"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394002AbfAPPZj (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 16 Jan 2019 10:25:39 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:40810 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391264AbfAPPZj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Jan 2019 10:25:39 -0500
Received: by mail-wr1-f66.google.com with SMTP id p4so7369608wrt.7
        for <linux-media@vger.kernel.org>; Wed, 16 Jan 2019 07:25:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=9AWXXRPbFYbsmK/oOLQ0Edb0Q+fpP7gd0qMLnsl6ipw=;
        b=G1mEwA7duXAxrQf8ANVrtBJ/iuwOab/S4Wy+5PaaiO4LfyML6Yl5znaswMnsymHyIQ
         aw+4uRBSxdKZvwbUw97LMCt7PpQHoPgBPhcDBR74MVPguG6UrfZVdLRAQJtlTKXaNgLN
         ewvTKqWo2bk0ydE62aT5ztsO4nwTGIMtel2bXfqZh8tmFfsFaGeno+xFd0TEgZxLoQvh
         aC7b5RL1WVsFvvympKE9WbZyxNxiJmDKnOyGKzgx7OSdL/uq+IGqylEBQQ6EDzlV2CTW
         ooTdcNiJUqM93cNef9xfTcRAAkrmnKoQQBTYdeiifExGAmUU+jMaVE27Sg5WDlAxSu69
         vGEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=9AWXXRPbFYbsmK/oOLQ0Edb0Q+fpP7gd0qMLnsl6ipw=;
        b=chT0qkVBSBB8vsil2wWGiQXNB3os7MR5ff01ZwxfonK1kh38WdQi5zOR959ZfOkrIw
         MgWhG/Ov5Pmo+qengRdGtm1aJExB7wenJSYRXk2pX1/UphNKTXCVbMXeZHSL5bPS2R0T
         5hXFE0z2lrRCVlL8KaP8KJRxG0uu9/GPj44ZGG487LRwOFvO74L7HVnXa0mpqP8rl5QT
         pkRZ/YhljyRSV4VJbOAqUxbJ8bL5EYrXWpsT40OZ8WfdDaSIq27QMmTULmTtcfk1c6Hp
         tHcg0bHXzdn748G3xBvPU5r7ElutYNVAmvg2TnhI6Xvohfb9AQT/HxJ7cZbU7sQSt11c
         jd2A==
X-Gm-Message-State: AJcUuke2AL/qq3Gt77FMHnb3coRBeMXQ+jht16aLc8q9cl/4YmGiUMYE
        1uYHxzXwDzGpZ7YQb5N/6VKJs8w+83M=
X-Google-Smtp-Source: ALg8bN7F29CtpPJbfRvspJoVA4UcPUGeitbyRuPuImJzGDtWzXVEp2L2bDWIo1Iuz7X0Bf4hGTpvtw==
X-Received: by 2002:a5d:67cf:: with SMTP id n15mr7776199wrw.211.1547652337574;
        Wed, 16 Jan 2019 07:25:37 -0800 (PST)
Received: from localhost.localdomain ([87.71.12.187])
        by smtp.gmail.com with ESMTPSA id l14sm161371758wrp.55.2019.01.16.07.25.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Jan 2019 07:25:36 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH v2 0/6] Adding support to resolution change and apdding
Date:   Wed, 16 Jan 2019 07:25:21 -0800
Message-Id: <20190116152527.34411-1-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Main changes from v1:
split the last patch to 3 patches:
1. add pixel encoding flags
2. read the compressed frame header to a different field than the
frame data
3. add support for source change event

Dafna Hirschfeld (6):
  media: vicodec: bugfix - replace '=' with '|='
  media: vicodec: Add num_planes field to v4l2_fwht_pixfmt_info
  media: vicodec: add support for CROP and COMPOSE selection
  media: vicodec: Add pixel encoding flags to fwht header
  media: vicodec: Separate fwht header from the frame data
  media: vicodec: Add support for resolution change event.

 drivers/media/platform/vicodec/codec-fwht.c   |  84 ++-
 drivers/media/platform/vicodec/codec-fwht.h   |  22 +-
 .../media/platform/vicodec/codec-v4l2-fwht.c  | 384 +++++++----
 .../media/platform/vicodec/codec-v4l2-fwht.h  |  16 +-
 drivers/media/platform/vicodec/vicodec-core.c | 651 +++++++++++++-----
 5 files changed, 836 insertions(+), 321 deletions(-)

-- 
2.17.1

