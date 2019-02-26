Return-Path: <SRS0=99fO=RB=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5774C43381
	for <linux-media@archiver.kernel.org>; Tue, 26 Feb 2019 17:05:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B6BD32173C
	for <linux-media@archiver.kernel.org>; Tue, 26 Feb 2019 17:05:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d5y3uGFW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728645AbfBZRF6 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 26 Feb 2019 12:05:58 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:39214 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728638AbfBZRF6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Feb 2019 12:05:58 -0500
Received: by mail-wr1-f68.google.com with SMTP id l5so14792450wrw.6
        for <linux-media@vger.kernel.org>; Tue, 26 Feb 2019 09:05:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=n3+UUZcdG6LCrngjZDc8iv5up+SDQ5196f/ftr6//7o=;
        b=d5y3uGFW+pKi8ACtVMtIRSWCVudopdwog7/0TiRtwxt74R/7BwLNmR4cHPrlG2BQaS
         aQico87EsUsdLtfAKU7VANrgQbKo8I+8gw5Nb+42fWtStrNAx0YKstzv1T9p9BOqM0AV
         G42+Ge8tGjJPg7nR8wIfeKvAqF7ikhcjorfcnkB8ZFRtSTwdXSiKGfX9kJk24YgiYVUT
         jdXGQabBcvt0VLJvuFBlnHf4E9rISyEJnmLh0SMQ2lCBvPF6/XxwvmktC2mez2cWLVoN
         cV7acQmZ96UKD9/8nnZwfdfZkXKvwJw8rzMf3TqujUkILfYncONv8oswhS6U26vE4IIt
         1MtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=n3+UUZcdG6LCrngjZDc8iv5up+SDQ5196f/ftr6//7o=;
        b=cZl4HN+LP6fGRzG/zVYK7XcFogQYYgD5zikLZArm8hdmJzKWpJ8u8Gl/fMzIDV6OfP
         9oiIPqYSb5nr7L65b4vBV1FmgVNL/BS7OnICGF3TiKs9CaOLtjaX7T5Um6faKicTn9Ey
         4BSTKVmM5E4OwkiY7pSd6gkfj4k3wDUiR1H/Ckyn9oSIqCQnOPKmM9FskSK5uqRHdzYQ
         kP/8rOv1cLrXh+zEnDEWfuY2mwSqtqMvBA5Ik97fGG+2Fa3WfI1dTw8IF+DuOenf/rFo
         jlGvuXJrhSPfJMDxxsnKhPeHCl0P6aCR8uVU6PPbWBopK8CzSmZ3n6wN/8BRyv9ddAtw
         D4ug==
X-Gm-Message-State: AHQUAuY2PwJGFYaXpCOQShzwSDQbzNtUBEBz7GlDLw1SaRfuOxWCInyN
        rc3mPjf8m2XIKMW6hvliCWvASc5uq+I=
X-Google-Smtp-Source: AHgI3IZq7exJy3X23k5a7Ab6kKEaZQIwZr5AJsctEBj114T2Cg+keQsLsrZWfQFWla7UpR2cqjaYaA==
X-Received: by 2002:adf:e949:: with SMTP id m9mr18296003wrn.1.1551200754965;
        Tue, 26 Feb 2019 09:05:54 -0800 (PST)
Received: from ubuntu.home ([77.127.107.32])
        by smtp.gmail.com with ESMTPSA id w4sm21024486wrk.85.2019.02.26.09.05.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 26 Feb 2019 09:05:54 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH v5 17/21] media: vicodec: add documentation to V4L2_CID_MPEG_VIDEO_FWHT_PARAMS
Date:   Tue, 26 Feb 2019 09:05:10 -0800
Message-Id: <20190226170514.86127-18-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190226170514.86127-1-dafna3@gmail.com>
References: <20190226170514.86127-1-dafna3@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

add documentation to V4L2_CID_MPEG_VIDEO_FWHT_PARAMS
control and its related 'v4l2_ctrl_fwht_params' struct

Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
---
 .../media/uapi/v4l/ext-ctrls-codec.rst        | 119 ++++++++++++++++++
 1 file changed, 119 insertions(+)

diff --git a/Documentation/media/uapi/v4l/ext-ctrls-codec.rst b/Documentation/media/uapi/v4l/ext-ctrls-codec.rst
index 088d25a670cc..05232cd71c3a 100644
--- a/Documentation/media/uapi/v4l/ext-ctrls-codec.rst
+++ b/Documentation/media/uapi/v4l/ext-ctrls-codec.rst
@@ -1538,6 +1538,125 @@ enum v4l2_mpeg_video_h264_hierarchical_coding_type -
 	non-4:2:0 YUV formats.
 
 
+.. _v4l2-mpeg-fwht:
+
+``V4L2_CID_MPEG_VIDEO_FWHT_PARAMS (struct)``
+    Specifies the fwht parameters (as extracted from the bitstream) for the
+    associated FWHT data. This includes the necessary parameters for
+    configuring a stateless hardware decoding pipeline for FWHT.
+
+    .. note::
+
+       This compound control is not yet part of the public kernel API and
+       it is expected to change.
+
+.. c:type:: v4l2_ctrl_fwht_params
+
+.. cssclass:: longtable
+
+.. flat-table:: struct v4l2_ctrl_fwht_params
+    :header-rows:  0
+    :stub-columns: 0
+    :widths:       1 1 2
+
+    * - __u64
+      - ``backward_ref_ts``
+      - Timestamp of the V4L2 capture buffer to use as backward reference, used
+        with P-coded frames. The timestamp refers to the
+	``timestamp`` field in struct :c:type:`v4l2_buffer`. Use the
+	:c:func:`v4l2_timeval_to_ns()` function to convert the struct
+	:c:type:`timeval` in struct :c:type:`v4l2_buffer` to a __u64.
+    * - __u32
+      - ``version``
+      - The version of the codec
+    * - __u32
+      - ``width``
+      - The width of the frame
+    * - __u32
+      - ``height``
+      - The height of the frame
+    * - __u32
+      - ``flags``
+      - The flags of the frame, see :ref:`fwht-flags`.
+    * - __u32
+      - ``colorspace``
+      - The colorspace of the frame, from enum :c:type:`v4l2_colorspace`.
+    * - __u32
+      - ``xfer_func``
+      - The transfer function, from enum :c:type:`v4l2_xfer_func`.
+    * - __u32
+      - ``ycbcr_enc``
+      - The Y'CbCr encoding, from enum :c:type:`v4l2_ycbcr_encoding`.
+    * - __u32
+      - ``quantization``
+      - The quantization range, from enum :c:type:`v4l2_quantization`.
+
+
+
+.. _fwht-flags:
+
+FWHT Flags
+============
+.. tabularcolumns:: |p{7.0cm}|p{2.2cm}|p{8.3cm}|
+
+.. cssclass:: longtable
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+    :widths:       3 1 4
+
+
+    * - ``FWHT_FL_IS_INTERLACED``
+      - 0x00000001
+      - Set if this is an interlaced format
+    * - ``FWHT_FL_IS_BOTTOM_FIRST``
+      - 0x00000002
+      - Set if this is a bottom-first (NTSC) interlaced format
+    * - ``FWHT_FL_IS_ALTERNATE``
+      - 0x00000004
+      - Set if each 'frame' contains just one field
+    * - ``FWHT_FL_IS_BOTTOM_FIELD``
+      - 0x00000008
+      - If FWHT_FL_IS_ALTERNATE was set, then this is set if this 'frame' is the
+	bottom field, else it is the top field.
+    * - ``FWHT_FL_LUMA_IS_UNCOMPRESSED``
+      - 0x00000010
+      - Set if the luma plane is uncompressed
+    * - ``FWHT_FL_CB_IS_UNCOMPRESSED``
+      - 0x00000020
+      - Set if the cb plane is uncompressed
+    * - ``FWHT_FL_CR_IS_UNCOMPRESSED``
+      - 0x00000040
+      - Set if the cr plane is uncompressed
+    * - ``FWHT_FL_CHROMA_FULL_HEIGHT``
+      - 0x00000080
+      - Set if the chroma plane has the same height as the luma plane,
+	else the chroma plane is half the height of the luma plane
+    * - ``FWHT_FL_CHROMA_FULL_WIDTH``
+      - 0x00000100
+      - Set if the chroma plane has the same width as the luma plane,
+	else the chroma plane is half the width of the luma plane
+    * - ``FWHT_FL_ALPHA_IS_UNCOMPRESSED``
+      - 0x00000200
+      - Set if the alpha plane is uncompressed
+    * - ``FWHT_FL_I_FRAME``
+      - 0x00000400
+      - Set if this is an I-frame
+    * - ``FWHT_FL_COMPONENTS_NUM_MSK``
+      - 0x00070000
+      - A 4-values flag - the number of components - 1
+    * - ``FWHT_FL_PIXENC_YUV``
+      - 0x00080000
+      - Set if the pixel encoding is YUV
+    * - ``FWHT_FL_PIXENC_RGB``
+      - 0x00100000
+      - Set if the pixel encoding is RGB
+    * - ``FWHT_FL_PIXENC_HSV``
+      - 0x00180000
+      - Set if the pixel encoding is HSV
+
+
 
 
 ``V4L2_CID_FWHT_I_FRAME_QP (integer)``
-- 
2.17.1

