Return-Path: <SRS0=KHCC=RJ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07150C43381
	for <linux-media@archiver.kernel.org>; Wed,  6 Mar 2019 21:14:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CBA8120661
	for <linux-media@archiver.kernel.org>; Wed,  6 Mar 2019 21:14:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hbHy6pNt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726264AbfCFVOC (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 6 Mar 2019 16:14:02 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33210 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726613AbfCFVOB (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Mar 2019 16:14:01 -0500
Received: by mail-wr1-f65.google.com with SMTP id i12so15026315wrw.0
        for <linux-media@vger.kernel.org>; Wed, 06 Mar 2019 13:14:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=hWap7rP/y90IGcf8xH5HH6jQiE7p9TgXIVq+FOyiRKY=;
        b=hbHy6pNtHC6V41GElnmwEj/yGuVCWh8k1/fMCVVuSvr6HT8wKlIouD/g/2kwvgeDLk
         VXcN4XS5Y379GZjI/tWPXWYBVTPjrXhjt/3H8uUEhg3Y+D58Tq0qOgbT8HrfQOxQHp6h
         73G6pAouXcIYYfkYAJO2xuxcDeRKIKjT0i31LThOZoEOS58HaUmgrfz3WeODkcQCnYYw
         q8HRKDHu/URZGMXGCxHVr6acxDYeiAUThDESvKgcrVnS6v+LDawK7jDLOZJ9QTIbRjtZ
         W6DlrIk1yfIHbWwM5TLIY1fVX6RPWzvB1YDk8gXFBH62RjDkhnLV635peHMRakDWlJDW
         DlQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=hWap7rP/y90IGcf8xH5HH6jQiE7p9TgXIVq+FOyiRKY=;
        b=Egmcug3d/T0mPhAjMALxgvOQYxxDdxmjfIVhu++ZdctI+rIMRGLQwA3xB9FrHvEpEI
         x/rLMLCTNtY5pXChpdF4BUEGhwwB2E9R4hhvAdFWWYaLipQbpt308eV9A8JuzQAHcemS
         33OdsVzBx+WsKbRKvJxsgIT/tAAfKwTrVIwzZe1Hv6crT0+pbQiMOD1fYJJm9TGb1AGj
         RP6D329I5r1rUarlL2QWDIXZAzBO1FIw8PGmMzDWBEYOK97z5+uWu0fqg/i3GESA/oSr
         KegkHtVlje3gmFU2v/EmEqvT35XKmOTRonnkbHY4dcsOKrtFqwUJ2pHqYFvLxElgB1Ay
         kpnQ==
X-Gm-Message-State: APjAAAXllBoIMRNHJfuTJQlSlcvqKvq5WHF3kFQLvTIk8Hl/wtN4i/a3
        X/Fj5nuBv8mmq+QYn0/maQ8IGpO/TKg=
X-Google-Smtp-Source: APXvYqwejKbXns4he7v798RCG2ibPb8ESlNcPjt4eJgYIr+S3T3lXUXACTA/gd9TkawGQnnetM3+8g==
X-Received: by 2002:a5d:4412:: with SMTP id z18mr4298969wrq.111.1551906839478;
        Wed, 06 Mar 2019 13:13:59 -0800 (PST)
Received: from ubuntu.home ([77.124.117.239])
        by smtp.gmail.com with ESMTPSA id a9sm1882126wmm.10.2019.03.06.13.13.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Mar 2019 13:13:58 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH v5 00/23] support for stateless decoder
Date:   Wed,  6 Mar 2019 13:13:20 -0800
Message-Id: <20190306211343.15302-1-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Main Changes from v4:
1. fixes according to the review
2. two new patches:
  0015-media-vicodec-Handle-the-case-that-the-reference-buf.patch
  0023-media-vicodec-set-pixelformat-to-V4L2_PIX_FMT_FWHT_S.patch

Dafna Hirschfeld (20):
  media: vicodec: selection api should only check single buffer types
  media: vicodec: upon release, call m2m release before freeing ctrl
    handler
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
  media: vicodec: Handle the case that the reference buffer is NULL
  media: vicodec: add struct for encoder/decoder instance
  media: vicodec: add documentation to V4L2_CID_FWHT_I/P_FRAME_QP
  media: vicodec: add documentation to V4L2_CID_MPEG_VIDEO_FWHT_PARAMS
  media: vicodec: add documentation to V4L2_PIX_FMT_FWHT_STATELESS
  media: vicodec: Introducing stateless fwht defs and structs
  media: vicodec: Register another node for stateless decoder
  media: vicodec: Add support for stateless decoder.
  media: vicodec: set pixelformat to V4L2_PIX_FMT_FWHT_STATELESS for
    stateless decoder

Hans Verkuil (3):
  vb2: add requires_requests bit for stateless codecs
  videodev2.h: add V4L2_BUF_CAP_REQUIRES_REQUESTS
  cedrus: set requires_requests

 .../media/uapi/v4l/ext-ctrls-codec.rst        | 130 ++++
 .../media/uapi/v4l/pixfmt-compressed.rst      |   6 +
 .../media/uapi/v4l/vidioc-reqbufs.rst         |   4 +
 .../media/common/videobuf2/videobuf2-core.c   |   5 +-
 .../media/common/videobuf2/videobuf2-v4l2.c   |   6 +
 drivers/media/platform/vicodec/codec-fwht.c   |  92 ++-
 drivers/media/platform/vicodec/codec-fwht.h   |  12 +-
 .../media/platform/vicodec/codec-v4l2-fwht.c  | 431 ++++-------
 .../media/platform/vicodec/codec-v4l2-fwht.h  |   7 +-
 drivers/media/platform/vicodec/vicodec-core.c | 731 +++++++++++++-----
 drivers/media/v4l2-core/v4l2-ctrls.c          |  30 +-
 .../staging/media/sunxi/cedrus/cedrus_video.c |   1 +
 include/media/fwht-ctrls.h                    |  31 +
 include/media/v4l2-ctrls.h                    |   7 +-
 include/media/videobuf2-core.h                |   3 +
 include/uapi/linux/v4l2-controls.h            |   4 +
 include/uapi/linux/videodev2.h                |   2 +
 17 files changed, 940 insertions(+), 562 deletions(-)
 create mode 100644 include/media/fwht-ctrls.h

-- 
2.17.1

