Return-Path: <SRS0=o7tn=RA=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E302C43381
	for <linux-media@archiver.kernel.org>; Mon, 25 Feb 2019 22:22:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 550C6213A2
	for <linux-media@archiver.kernel.org>; Mon, 25 Feb 2019 22:22:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="n1uNDj+7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728434AbfBYWWb (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 25 Feb 2019 17:22:31 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:38829 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727801AbfBYWWb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Feb 2019 17:22:31 -0500
Received: by mail-wm1-f66.google.com with SMTP id v26so475112wmh.3
        for <linux-media@vger.kernel.org>; Mon, 25 Feb 2019 14:22:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=4ma+hd6urjZkoOq/+0FVgdXyzPtICpe2mbxq1MjhqI0=;
        b=n1uNDj+7tlAISKFY6YIKypv5Lh6thT56X4gST6aHrJ9dHlpQu1uQu+mQtZkUzCOuyx
         46XsMOlzb31zG84ckSRTgp6prfJJgpD6T9/xJKTooBD3X5MOHHHzZa6Eeali7ImqL3pu
         l0owb5SsJjIPWm6YAD6UvS7Ie9VvvE9hDj0zl7z2dpqu67sdMoSm6AlzHS1m/lzEfW1U
         HxTfAljd3rhPy4sFQYGQIzwcwWQKxcmG7EJj2tJfZjrnPKvalRnrShouOwJCRt0p0bJK
         ln1ni5WeoN2N8yHNrPLhGShhl17nlDAaEhn6qCGPgn0k1SiU/QCh3/XufXdqXF295pc8
         N2jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=4ma+hd6urjZkoOq/+0FVgdXyzPtICpe2mbxq1MjhqI0=;
        b=cdwae7LcjEBsuCV4PfpSEkYWqR0RekeZISVyoOxUt6RhmPsKIU8w8RjVBziCcQIWtd
         SPZ/t74nFcpfC/sWDJnzMQ648p3HNV33MLriJ3wcGkOYR6Zi3DdsdRjWhOAf1FFGdK+w
         giN0RAmuWAOMhChgzW+9pry+9wfZDaQjHdyAexzYJ3pGxbMGHhTwkYZpLZiFSNqVjUcO
         b4ci0hthWvE5UvJNJ7fQkVQjMzDIpdWWFahmAXOu+ZGP0yFcWwSbPEc42K80ZZgJ5UAT
         Fq16q27VODVFhzMf3/oU9NIUqA5QLs74algUjsAC+BUiKKEBs8teZQf2E4xf0WPXiQlH
         uMqg==
X-Gm-Message-State: AHQUAubjZxMVQ/HR09CgtTlYQAtFHzYzSjUqtdXAzlw/svWSx49JfIPW
        xV+6B8b+465HqAFr82qHhZejaNzljN4=
X-Google-Smtp-Source: AHgI3IYN5qDfUdA3fDdOH1Kh0UOGJ1i50iz+dTJ+0ePWxJpvDFcVCMZYwRJSNDljfU0dLtW3WryJeg==
X-Received: by 2002:a1c:9aca:: with SMTP id c193mr576877wme.2.1551133349147;
        Mon, 25 Feb 2019 14:22:29 -0800 (PST)
Received: from ubuntu.home ([77.127.107.32])
        by smtp.gmail.com with ESMTPSA id d206sm16981422wmc.11.2019.02.25.14.22.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 25 Feb 2019 14:22:28 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH v4 17/21] media: vicodec: add documentation to V4L2_CID_MPEG_VIDEO_FWHT_PARAMS
Date:   Mon, 25 Feb 2019 14:22:08 -0800
Message-Id: <20190225222210.121713-8-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190225222210.121713-1-dafna3@gmail.com>
References: <20190225222210.121713-1-dafna3@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

add documentation to V4L2_CID_MPEG_VIDEO_FWHT_PARAMS
control and it's related 'v4l2_ctrl_fwht_params' struct

Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
---
 .../media/uapi/v4l/ext-ctrls-codec.rst        | 54 +++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/Documentation/media/uapi/v4l/ext-ctrls-codec.rst b/Documentation/media/uapi/v4l/ext-ctrls-codec.rst
index a30ce4fd2ea1..280f1386d5a9 100644
--- a/Documentation/media/uapi/v4l/ext-ctrls-codec.rst
+++ b/Documentation/media/uapi/v4l/ext-ctrls-codec.rst
@@ -1541,6 +1541,60 @@ enum v4l2_mpeg_video_h264_hierarchical_coding_type -
 
 .. _v4l2-mpeg-fwht:
 
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
+      - The flags of the frame
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
+    * - __u32
+      - ``comp_frame_size``
+      - The size of the compressed frame.
+
 ``V4L2_CID_FWHT_I_FRAME_QP (integer)``
     Quantization parameter for an I frame for FWHT. Valid range: from 1
     to 31.
-- 
2.17.1

