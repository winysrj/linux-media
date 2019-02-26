Return-Path: <SRS0=99fO=RB=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5D82C43381
	for <linux-media@archiver.kernel.org>; Tue, 26 Feb 2019 17:05:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7022F20C01
	for <linux-media@archiver.kernel.org>; Tue, 26 Feb 2019 17:05:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="siiLRaWp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727196AbfBZRFa (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 26 Feb 2019 12:05:30 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46715 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726602AbfBZRFa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Feb 2019 12:05:30 -0500
Received: by mail-wr1-f66.google.com with SMTP id i16so14756355wrs.13
        for <linux-media@vger.kernel.org>; Tue, 26 Feb 2019 09:05:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=SqQDgWqyq/avYTu72LEx7hJjXT4S6E3GCk0H+t0e7nE=;
        b=siiLRaWpV/O9i3bGa9zQ2rCFd5x9U80/McsHuDfBIhB7Gx3u6NmV0+G0gDJ/muIoma
         x0lhD2oT9zeBB7IAxXdu/H1fq3kmtBcDmO6zouP8NUCv6H3wurO48nmsuLqAT93VJ+SU
         lblruwbttSbrlzD5Z2AtL7HTgxQSrPo706wwQb8y51VJtz19/dVFEJeAP0Pl+CpaDvcC
         U2+mUxZ66qpNB2eDDJLAuBD6gLJTGBla5f3hZXM4Q43yhilVa8RUQ18UpFxkwX9KyQNZ
         fPCF2rlXKJJs9dQyCyJ/cU5jLXjo4J7kQxvA8BoZvdbUa58jU3coXclO0VgztS1iyclR
         NA9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=SqQDgWqyq/avYTu72LEx7hJjXT4S6E3GCk0H+t0e7nE=;
        b=YSdHOIxQiScwN9Vk6xP3Pycvl96VBMI1KzMfoGB29zqQLoLbMjMaB6jvjYX4VwJmcc
         LHxOhW0y2+92fTKnxOrjxKO8xp3O8gybLyfzVfsMT8p+KCF/GkW2OG9sODFN0KKfcVmq
         NgTGWkLEXP4e4BIuXmbvb8hVkmwnrX7jOVeMBYSofMW9+GW38mjIx1KbvnvtLjZOM35m
         E0zBrMFc2IqxHL+IYwQpuJAXg3qVXirAlS4Uk+/p/RQ0A8sNe6dz5rP2ixx+5+BbSyuD
         qAuCuMF3Ow5jU4BBWas95jdBZ5HRxvlTnZLrrAiZaBXwhcuBnUCCigLQW2RcV9mLz+dU
         9H3g==
X-Gm-Message-State: AHQUAua3OLvCVovKzoRpyATDDI2x8UOQnBtN1AyRJtcFb4LBq27Ju52h
        +VZTZzs1UzLFjp4QTzkea4smnI7K2Cw=
X-Google-Smtp-Source: AHgI3IYSn9MSCBSZwKFALaFmMtdykS0e3Zc3MLdhpRKK5oPQ94TxxDooHy7yV2xUDcZmbMOmpBdq4w==
X-Received: by 2002:adf:ecc6:: with SMTP id s6mr17520513wro.144.1551200728552;
        Tue, 26 Feb 2019 09:05:28 -0800 (PST)
Received: from ubuntu.home ([77.127.107.32])
        by smtp.gmail.com with ESMTPSA id w4sm21024486wrk.85.2019.02.26.09.05.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 26 Feb 2019 09:05:27 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH v5 00/21] add support to stateless decoder
Date:   Tue, 26 Feb 2019 09:04:53 -0800
Message-Id: <20190226170514.86127-1-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

add support to stateless decoder

main changes from v4:
- fixes according to the review.
- documentation for the flags
- removing comp_frame_size from the fwht stateless params
- removing vicodec_ctrl_p/i_frame

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

 .../media/uapi/v4l/ext-ctrls-codec.rst        | 130 ++++
 .../media/uapi/v4l/pixfmt-compressed.rst      |   6 +
 .../media/uapi/v4l/vidioc-reqbufs.rst         |   4 +
 .../media/common/videobuf2/videobuf2-core.c   |   5 +-
 .../media/common/videobuf2/videobuf2-v4l2.c   |   6 +
 drivers/media/platform/vicodec/codec-fwht.c   |  83 ++-
 drivers/media/platform/vicodec/codec-fwht.h   |  12 +-
 .../media/platform/vicodec/codec-v4l2-fwht.c  | 420 +++--------
 .../media/platform/vicodec/codec-v4l2-fwht.h  |   7 +-
 drivers/media/platform/vicodec/vicodec-core.c | 682 +++++++++++++-----
 drivers/media/v4l2-core/v4l2-ctrls.c          |  30 +-
 .../staging/media/sunxi/cedrus/cedrus_video.c |   1 +
 include/media/fwht-ctrls.h                    |  31 +
 include/media/v4l2-ctrls.h                    |   6 +-
 include/media/videobuf2-core.h                |   3 +
 include/uapi/linux/v4l2-controls.h            |   4 +
 include/uapi/linux/videodev2.h                |   2 +
 17 files changed, 886 insertions(+), 546 deletions(-)
 create mode 100644 include/media/fwht-ctrls.h

-- 
2.17.1

