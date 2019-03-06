Return-Path: <SRS0=KHCC=RJ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E74E9C43381
	for <linux-media@archiver.kernel.org>; Wed,  6 Mar 2019 21:14:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B672B206DD
	for <linux-media@archiver.kernel.org>; Wed,  6 Mar 2019 21:14:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AkUzMc/T"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726696AbfCFVOg (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 6 Mar 2019 16:14:36 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:50404 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726502AbfCFVOf (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Mar 2019 16:14:35 -0500
Received: by mail-wm1-f67.google.com with SMTP id x7so7317571wmj.0
        for <linux-media@vger.kernel.org>; Wed, 06 Mar 2019 13:14:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=1YBw3Fu4rNl9rkCQkZ5WTrGclXeUx1HGmFR0ckqnWv8=;
        b=AkUzMc/TEPQJctKtzltwWi2tqLLBHEAvYbiDdB1esimYHcu/3/fILs+mdJBMTCQYdJ
         7AnzUwGvsQKOHV0ICbcIz84v0ASFp/JzMibe3eZNeKu+L+WuwdmvkWRkANHinxYy9f7z
         36ZqCcMnXPn9f8CbRS6BAoTA+6CL/f41hKSqaJ8OGk6LO/1AqJYVlilyVa5r91xEZhTF
         BWRAIgYciCXH4p7Ar//8Gbf6c4XBbPXQCjRUWXFkVsrutlpIu1Hu0ejSbPDCHYKuxUK2
         ZCsBMw5IKAa66uk437vdn0s5I4m3ovjaiY5xUMDiQV9SK6TU+1aLQPszKZGDrT2JhZCW
         arpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=1YBw3Fu4rNl9rkCQkZ5WTrGclXeUx1HGmFR0ckqnWv8=;
        b=JgEBXCqzs2U0OyTdQ2IAdzNhsVpYXeQMfnh2qK/z4yLriKeH/QRn7qw4fCgzfzmqDf
         vFPlYQWkt0sZHAaN/hwMrqrWJPm2tG1tevOrku+ap+EPwinewquYCLW6rB8y3fIe4r+G
         pI8i0UOeNx5TA5RcqA6fudWBfspnosmBlvRN+GgK1RsJV8ohJEFIPDpTlXhfr/mSxLRB
         3ykqad+enmDlPehxXa+BIbelGcPjXCtzizJuhbMbuTq59QN0M6+uVTM9PPCi2oQfcc5z
         KCrwTHQor5zdzCYQwk1nZWbtjauf6KybCsrDKGYnVr6sQeHfra3LWN8zVzKk5G8zn55I
         P/TA==
X-Gm-Message-State: APjAAAU3Max1FZyHvYeHB+pIw5F3FJq2m/QVMzgmJFhOLpWXJoBkaoy4
        MUXhU99hICZ250c0mxaEY0HdKDSlr1g=
X-Google-Smtp-Source: APXvYqw0RtltK2oSuF/o+0fHSnUgk1nYSzWOVWuKwxjDkgx0TZE1SfCD4oBxJvQZ9kfs1hAggWSaPA==
X-Received: by 2002:a1c:c644:: with SMTP id w65mr3540443wmf.19.1551906873530;
        Wed, 06 Mar 2019 13:14:33 -0800 (PST)
Received: from ubuntu.home ([77.124.117.239])
        by smtp.gmail.com with ESMTPSA id a9sm1882126wmm.10.2019.03.06.13.14.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Mar 2019 13:14:32 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH v5 18/23] media: vicodec: add documentation to V4L2_CID_MPEG_VIDEO_FWHT_PARAMS
Date:   Wed,  6 Mar 2019 13:13:38 -0800
Message-Id: <20190306211343.15302-19-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190306211343.15302-1-dafna3@gmail.com>
References: <20190306211343.15302-1-dafna3@gmail.com>
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
index 301a4dfbbbde..45ce592279c3 100644
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

