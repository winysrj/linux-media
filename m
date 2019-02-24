Return-Path: <SRS0=d4St=Q7=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A581C43381
	for <linux-media@archiver.kernel.org>; Sun, 24 Feb 2019 09:02:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE38320652
	for <linux-media@archiver.kernel.org>; Sun, 24 Feb 2019 09:02:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="poDZWWcm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727021AbfBXJCw (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 24 Feb 2019 04:02:52 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:37400 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726001AbfBXJCv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 24 Feb 2019 04:02:51 -0500
Received: by mail-wr1-f66.google.com with SMTP id w6so3400879wrs.4
        for <linux-media@vger.kernel.org>; Sun, 24 Feb 2019 01:02:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=c91LtJxnIqoMwr0EImCz2AZKOoz4EcBWaPtnj+GOgX8=;
        b=poDZWWcmPuIK7wIxOl76dstN9jTLMbvMnH+ctlE1Hkj5YwvV11jTNRKLrk4LS1U6yA
         Z/lMB9Z7SqsPvS2Z5G7AKZTVIJ13VSgU5zEmfU5dJKXxXAYvDTAB5VYNRpL2OeS8O0xE
         8hFWYG0PDgAV7unljLKww2njjWhGDzSJJaVxN4A9wsfozObatFfxAt2PpxFU8aKREbKb
         Kg29skaC8jW1sRh0yunlPor3T+qjOOcEMk8fu2iEIUS7Ws3u7tMqRkiZHMQSCI5sdPSK
         /P8B4b4H66133op1C2p6xxztxQJpVwwkfBCnprSbyjkHEJepkqz6a26OEqttTwTZmiOw
         yEHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=c91LtJxnIqoMwr0EImCz2AZKOoz4EcBWaPtnj+GOgX8=;
        b=kNWsxz3rfIUst3Sgucx+KM04guwzZeocpqefNiem6McNRxIeUtTPsCWaI8mBPiIvpu
         eApLDv0AZb9viNXQbGA1QR2oBkIBO8Bd40+Mu1kHoeri4ty1GQoP9N9Ml+ATFslYiDeW
         DM5ja1hYLeOk9a7w72oeFS+2Txm2yA/rJcH5+4Fl3QR5eJtCaQAfFMigJBzdjLTJ/Bou
         JpWiIo9v0nEWsf7RHgr02UDdOBoisQsaZkLqqfMZVPxwy9ydltxHrbZmczabz91lg63l
         VBg2Z90kdw4HfT7iCtKdQt0RKwQVcsdC5nc1QZGEsrshDZeAFLDQK3z/+VrZad/lhzcz
         elug==
X-Gm-Message-State: AHQUAubL/yZxpgVBzUe1FFYLd0bZOc+VEtOQcSEJOkJbQoiPiW+GZkCY
        M/RJCApdimFuzrrbrpVNX6tGpEUzAps=
X-Google-Smtp-Source: AHgI3IZamzs85Yrj6limoTvy+i1mxpmhI/KjGKf4j4LpKnSHzZDdgbIRDhPnA0doPRzXNLZL0a4F2Q==
X-Received: by 2002:adf:fc12:: with SMTP id i18mr8570075wrr.201.1550998969621;
        Sun, 24 Feb 2019 01:02:49 -0800 (PST)
Received: from ubuntu.home ([77.127.107.32])
        by smtp.gmail.com with ESMTPSA id e75sm8701971wmg.32.2019.02.24.01.02.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 24 Feb 2019 01:02:48 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH v3 00/18] add support to stateless decoder
Date:   Sun, 24 Feb 2019 01:02:17 -0800
Message-Id: <20190224090234.19723-1-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

main changes from v2:
- fixes according to the review.
- changes in 'copy_cap_to_ref' and to support NV24/42 types
- changes in the codec-fwht.c functions to support
reference frame which is not internal so stride and chroma_stride
for the refernce frame should be function parameters.
- patches 1,2,3 are from another patchset - add "requires request"
they are added so the the kbuild tests won't complian

Dafna Hirschfeld (15):
  media: vicodec: selection api should only check signal buffer types
  media: v4l2-ctrl: v4l2_ctrl_request_setup returns with error upon
    failure
  media: vicodec: change variable name for the return value of
    v4l2_fwht_encode
  media: vicodec: bugfix - call v4l2_m2m_buf_copy_metadata also if
    decoding fails
  media: vicodec: bugfix: free compressed_frame upon device release
  media: vicodec: Move raw frame preparation code to a function
  media: vicodec: add field 'buf' to fwht_raw_frame
  media: vicodec: keep the ref frame according to the format in decoder
  media: vicodec: Validate version dependent header values in a separate
    function
  media: vicodec: rename v4l2_fwht_default_fmt to v4l2_fwht_find_nth_fmt
  media: vicodec: add struct for encoder/decoder instance
  media: vicodec: Introducing stateless fwht defs and structs
  media: vicodec: Register another node for stateless decoder
  media: vicodec: Add support for stateless decoder.
  prints

Hans Verkuil (3):
  vb2: add requires_requests bit for stateless codecs
  videodev2.h: add V4L2_BUF_CAP_REQUIRES_REQUESTS
  cedrus: set requires_requests

 .../media/uapi/v4l/vidioc-reqbufs.rst         |   4 +
 .../media/common/videobuf2/videobuf2-core.c   |   5 +-
 .../media/common/videobuf2/videobuf2-v4l2.c   |   6 +
 drivers/media/media-request.c                 |   3 +
 drivers/media/platform/vicodec/codec-fwht.c   | 108 ++-
 drivers/media/platform/vicodec/codec-fwht.h   |  14 +-
 .../media/platform/vicodec/codec-v4l2-fwht.c  | 473 ++++-------
 .../media/platform/vicodec/codec-v4l2-fwht.h  |   7 +-
 drivers/media/platform/vicodec/vicodec-core.c | 753 ++++++++++++++----
 drivers/media/v4l2-core/v4l2-ctrls.c          |  69 +-
 .../staging/media/sunxi/cedrus/cedrus_video.c |   1 +
 include/media/fwht-ctrls.h                    |  35 +
 include/media/v4l2-ctrls.h                    |   6 +-
 include/media/videobuf2-core.h                |   3 +
 include/uapi/linux/videodev2.h                |   2 +
 15 files changed, 963 insertions(+), 526 deletions(-)
 create mode 100644 include/media/fwht-ctrls.h

-- 
2.17.1

