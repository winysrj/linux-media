Return-Path: <SRS0=jH9h=P3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E0BAC61CE4
	for <linux-media@archiver.kernel.org>; Sat, 19 Jan 2019 12:02:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1FB5F2086A
	for <linux-media@archiver.kernel.org>; Sat, 19 Jan 2019 12:02:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="uPtvW+el"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727921AbfASMCG (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 19 Jan 2019 07:02:06 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36038 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727900AbfASMCG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 19 Jan 2019 07:02:06 -0500
Received: by mail-wr1-f66.google.com with SMTP id u4so18131352wrp.3
        for <linux-media@vger.kernel.org>; Sat, 19 Jan 2019 04:02:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=n3kZyTzmUdJP2x1l84DarEyh9pc7FJILmKyV7QkFV6c=;
        b=uPtvW+elqj0y8/y1f76DKgsH13YSguGQ75KyIL0HY0p0YaRE1O3M0C43u4VRgeotHG
         Zn2+gK4S3z91Ur+B92CNVNOd13FdoJNmJhfdlctoweENvszB0xZFn8iOLwdTjnq4nN2f
         hLt8Mneop2Vq9T0ZSyRGnV0GgqfQ07XRnah8It8czeJYPoxXfwE+yZ4atgKvCQbz3fKe
         tcBO4eLx4+HSQV+WlrQdzT7JXHjZ3nS/T7ZbeQmM0NTYwzhthLTr4x6RhECSfDTpwSeo
         wcs9JTyGp4eSPrZLuDAGtuXiYjWmy1JP5I1YhZ0SjaSDvCARWL9vljk/XmtcVNMpWlbv
         G7dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=n3kZyTzmUdJP2x1l84DarEyh9pc7FJILmKyV7QkFV6c=;
        b=A90b/3fKfti/0nnJP/W9AVi86y4iS+Cs7l3t7TQiBgP+8gVnURiEoX35jSefwCfAc5
         1SXLcehz9qJC4rv5uTi6s94wfReAJMeCIcGe1kcv6W0lqJGJmfXcuS+KqGhjbAG8r1a1
         GW98en2HuoPpdG+awzCjToonlORsGgK1j/hPNt+MzO0GnpEnkkeJ2YgzS6ZMZoKnpgNR
         zGLsReYXhKlTLktP3eQ0HhpqmHg+g5+MLs0w7p71kawnEkfcjFUg4kV5fDg+29zjNvK6
         IadypJzsOXlikW82ZUkJ/CoKTwuI3blbm9daoMctEWhAbyvq+FcKgwTf/VHw3w5CpLCy
         uhWg==
X-Gm-Message-State: AJcUukdgvqI+nJDEESeU4q6HW3DJFjyC87Vj576Sn6cbsetaxi3zoQkI
        1BPknm+nqiBgefkUiCbgkuGNfC09Mw8=
X-Google-Smtp-Source: ALg8bN49uKRR+s/3x4To1oAvvSb+/K3xw3M/5CdqbkDjwadTLFTAYsCHjqdmAu2dO8Jdh5XVRSnkJQ==
X-Received: by 2002:adf:a393:: with SMTP id l19mr20920055wrb.110.1547899324136;
        Sat, 19 Jan 2019 04:02:04 -0800 (PST)
Received: from localhost.localdomain ([87.71.51.33])
        by smtp.gmail.com with ESMTPSA id e27sm95011131wra.67.2019.01.19.04.02.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 19 Jan 2019 04:02:02 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH v4 0/6] media: vicodec: resolution change suport
Date:   Sat, 19 Jan 2019 04:01:50 -0800
Message-Id: <20190119120156.15851-1-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Changes from v3:
1. bugfix in stop_sreaming callback, ctx->max_comp_size should
initialize when the ref_fram is freed.
2. added patch - use 3 bits for the number of components in the
fwht header.
3. remove the first patch: "bugfix - replace '=' with '|='"
since it was already merged

Dafna Hirschfeld (6):
  media: vicodec: Add num_planes field to v4l2_fwht_pixfmt_info
  media: vicodec: add support for CROP and COMPOSE selection
  media: vicodec: use 3 bits for the number of components
  media: vicodec: Add pixel encoding flags to fwht header
  media: vicodec: Separate fwht header from the frame data
  media: vicodec: Add support for resolution change event.

 drivers/media/platform/vicodec/codec-fwht.c   |  80 ++-
 drivers/media/platform/vicodec/codec-fwht.h   |  25 +-
 .../media/platform/vicodec/codec-v4l2-fwht.c  | 384 +++++++----
 .../media/platform/vicodec/codec-v4l2-fwht.h  |  15 +-
 drivers/media/platform/vicodec/vicodec-core.c | 609 ++++++++++++++----
 5 files changed, 811 insertions(+), 302 deletions(-)

-- 
2.17.1

