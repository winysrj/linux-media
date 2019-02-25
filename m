Return-Path: <SRS0=o7tn=RA=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79477C43381
	for <linux-media@archiver.kernel.org>; Mon, 25 Feb 2019 22:19:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 436A0213A2
	for <linux-media@archiver.kernel.org>; Mon, 25 Feb 2019 22:19:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cXsbqIew"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727200AbfBYWTy (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 25 Feb 2019 17:19:54 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:39699 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726845AbfBYWTy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Feb 2019 17:19:54 -0500
Received: by mail-wm1-f67.google.com with SMTP id z84so463240wmg.4
        for <linux-media@vger.kernel.org>; Mon, 25 Feb 2019 14:19:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=PlEyKJ27dJIqS/gB0k3yJ3Jzz9BfZnSKw9PHTev7P9g=;
        b=cXsbqIewKoMLJJQfYpEspFOr+Uhz4RybGs5bVz+8r/K8UwdqAvHPmQiodQYPQSomQX
         6J79RWU3alzb+rEXnlrdt9kPVlstGjzEU0iH9m6aFfa3ymOpyrzQ7rm/QehHg4nDyMqd
         qCxHRAqv/NNpED4S9JhmzxRZ5nGfffZQ9Xck3tH1LpDutNu+ng9ouKmoqMhOCEbkhkPx
         pViY+0hWuJo6Bk+jopU8H3XhMw6TnZJSaeFLVlIqRJUDhp31UKbxNXuE0KVftaVQ+hl7
         ATZabZoPwf84rS/f0wNyAgzEkzpAC3TfNxbbAkOHiiXRpQkxSAM+ysjviOU+QfsSvP+G
         OO0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=PlEyKJ27dJIqS/gB0k3yJ3Jzz9BfZnSKw9PHTev7P9g=;
        b=WcwPc5n2qp+Gcte2KViZvEfCdFldyRcAo6DfcDftEmxDYX6ZVfjYxWRhGKmB/pKdtU
         i0YS66TIg0XbvvED8ItL+WSdAVRbdYeZJstVmTCtFnALGKlh+rbsOsZPGF75U4VtvD6p
         SRVX5hfLXDQJvDAE5Wy8zDgJvgcsAXc6afJvyYCs5b+2RvlYW1+vS8+Ydh//kqxhU+Rs
         JVx6SCk2hs/ZRi7It15RBoJetJ0VKm3wdM02byiT3igDImLbhYRjfZQS6XKBHzEMfcS0
         Yxop88Tmz0N8q6az512KUAnbZtqPWG0q7vTssUf/YJCRrmIsxPuEEJaXCtFexn+YL1YU
         N0kA==
X-Gm-Message-State: AHQUAubZb8xoKm+cv4cBAqbIOpQsLKqDsKwcbj8c8+I0m9Hn0k6afbZz
        Vt9jbLMyBDcgBmOHH8tcBGLRiWymHLk=
X-Google-Smtp-Source: AHgI3IYfCia2jRZFsiEU0lHyhSn4R1EaPfilxY7sWexEF1QRhVoxHelZvCRPS6mPOKo0yhYPG5rZQg==
X-Received: by 2002:a1c:7a1a:: with SMTP id v26mr526077wmc.129.1551133191966;
        Mon, 25 Feb 2019 14:19:51 -0800 (PST)
Received: from ubuntu.home ([77.127.107.32])
        by smtp.gmail.com with ESMTPSA id a20sm4168033wmb.17.2019.02.25.14.19.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 25 Feb 2019 14:19:50 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH v4 00/21] add support to stateless decoder
Date:   Mon, 25 Feb 2019 14:19:24 -0800
Message-Id: <20190225221933.121653-1-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

main changes from v2:
- fixes according to the review.
- patch 5: new bugfix
- patches 16, 17, 18: new documentation

Dafna Hirschfeld (18):
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
  media: vicodec: add struct for encoder/decoder instance
  media: vicodec: add documentation to V4L2_CID_FWHT_I/P_FRAME_QP
  media: vicodec: add documentation to V4L2_CID_MPEG_VIDEO_FWHT_PARAMS
  media: vicodec: add documentation to V4L2_PIX_FMT_FWHT_STATELESS
  media: vicodec: Introducing stateless fwht defs and structs
  media: vicodec: Register another node for stateless decoder
  media: vicodec: Add support for stateless decoder.

Hans Verkuil (3):
  vb2: add requires_requests bit for stateless codecs
  videodev2.h: add V4L2_BUF_CAP_REQUIRES_REQUESTS
  cedrus: set requires_requests

 .../media/uapi/v4l/ext-ctrls-codec.rst        |  66 ++
 .../media/uapi/v4l/pixfmt-compressed.rst      |   5 +
 .../media/uapi/v4l/vidioc-reqbufs.rst         |   4 +
 .../media/common/videobuf2/videobuf2-core.c   |   5 +-
 .../media/common/videobuf2/videobuf2-v4l2.c   |   6 +
 drivers/media/platform/vicodec/codec-fwht.c   |  83 ++-
 drivers/media/platform/vicodec/codec-fwht.h   |  12 +-
 .../media/platform/vicodec/codec-v4l2-fwht.c  | 420 ++++-------
 .../media/platform/vicodec/codec-v4l2-fwht.h  |   7 +-
 drivers/media/platform/vicodec/vicodec-core.c | 665 +++++++++++++-----
 drivers/media/v4l2-core/v4l2-ctrls.c          |  28 +-
 .../staging/media/sunxi/cedrus/cedrus_video.c |   1 +
 include/media/fwht-ctrls.h                    |  32 +
 include/media/v4l2-ctrls.h                    |   6 +-
 include/media/videobuf2-core.h                |   3 +
 include/uapi/linux/v4l2-controls.h            |   3 +
 include/uapi/linux/videodev2.h                |   2 +
 17 files changed, 822 insertions(+), 526 deletions(-)
 create mode 100644 include/media/fwht-ctrls.h

-- 
2.17.1

