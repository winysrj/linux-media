Return-Path: <SRS0=I7H+=PZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 086E3C43387
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 18:24:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE3AD20652
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 18:24:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QImfufMr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727553AbfAQSYU (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 17 Jan 2019 13:24:20 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:40774 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726905AbfAQSYU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 Jan 2019 13:24:20 -0500
Received: by mail-wm1-f66.google.com with SMTP id f188so2076490wmf.5
        for <linux-media@vger.kernel.org>; Thu, 17 Jan 2019 10:24:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=vlzUj4bOp4FjKGigHWSL/WtTwfIVS6iv3nRJ7s6H12w=;
        b=QImfufMrJtHWD9ioRQHLIvAvkwKVIi4yTfcJpQX6lOW6AusMwhw2ypUFDhPoPCi0ov
         Tn2F7/Cl8cDvaiXVEuRSn97MuDP+boZ3Ah/4hYHNkJUQumw2MiIIc1aodswt9ZK2z7DR
         0Tv2wR2NxFbqAusj32gmmXbSIjf5Sw8m//DVTMpNB0Z1V55eEpgJCAXA1Ij3WQxSiU+d
         EfPi21X47iMYISTgqCgicBQXvCNxGoKOCkQH5jXCLVnZLmv6HCgRoKL+BDrF8xIiec4R
         ECkH6KgIPVNS0vRHMLgGAtDQxZi9tgcFYYynPXCQp8c6RgqB6mcZkL0a6jMXeUNNflx0
         gR8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=vlzUj4bOp4FjKGigHWSL/WtTwfIVS6iv3nRJ7s6H12w=;
        b=hT/7CCasl5kNg0HwTXqf1/4Fx7cLWQPzcOflBmwwXAX7sP+pyJMttJvYyyEz1clS9B
         0fHa+hisQHMnxGEDB6H9j9qyZoqo28wpZ32cCm13rDhMtMRxHCHHQCkgJMRUZER9CxMj
         OW4qY74KD3uQeGJkZCdWZiehhRUqx8cj4+uOprdEpKUgQeuhg7MJ9QsmVCjd8kzlwgFL
         uWNb5TVeXfNoRN5UjFx08bGxGkJC0BnQqnApTnN0IR/ciaqxcmGzKuK7Rt7vua7JyxPk
         6mOR7XhiKNZQmaEj4fcZM8GBgSScJkBE6YouawVpOVBWErxDjD2oxeeD4mG6V+3niyVv
         TMuQ==
X-Gm-Message-State: AJcUukcYljZTatF2ohJHah/6dlTx6kp7sGq4sNncjD8LmLlw27hujFKh
        As27Bn5Dkv/JWhV28lMRWx11+RIbzko=
X-Google-Smtp-Source: ALg8bN67IfBiRwIOAbEM4bBkyW/k4zNVqxbbt3XrqR2886koso3gkWJkRncJzMLBRHVhmrrYetqozQ==
X-Received: by 2002:a1c:2547:: with SMTP id l68mr12826392wml.11.1547749458070;
        Thu, 17 Jan 2019 10:24:18 -0800 (PST)
Received: from localhost.localdomain ([87.71.12.187])
        by smtp.gmail.com with ESMTPSA id o4sm76052266wrq.66.2019.01.17.10.24.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Jan 2019 10:24:17 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH v3 0/6] add support for resolution change event
Date:   Thu, 17 Jan 2019 10:23:13 -0800
Message-Id: <20190117182319.118359-1-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Main changes from v2:
1. bugfix in patch "add support for CROP" (pix instead of pix_mp)
in vidioc_try_fmt
2. using bits 18-20 for the pixel encoding so that 0 means previous version
3. some refactoring


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
 .../media/platform/vicodec/codec-v4l2-fwht.h  |  15 +-
 drivers/media/platform/vicodec/vicodec-core.c | 609 ++++++++++++++----
 5 files changed, 811 insertions(+), 303 deletions(-)

-- 
2.17.1

