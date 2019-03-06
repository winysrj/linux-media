Return-Path: <SRS0=KHCC=RJ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1267C43381
	for <linux-media@archiver.kernel.org>; Wed,  6 Mar 2019 21:14:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF1EA20684
	for <linux-media@archiver.kernel.org>; Wed,  6 Mar 2019 21:14:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kNuSnzFP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726643AbfCFVOH (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 6 Mar 2019 16:14:07 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41954 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726619AbfCFVOG (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Mar 2019 16:14:06 -0500
Received: by mail-wr1-f66.google.com with SMTP id n2so15034430wrw.8
        for <linux-media@vger.kernel.org>; Wed, 06 Mar 2019 13:14:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Wd3HgaUvH1soc/yfyWI6dAQdM9lUwSjfn9ndiCGooyo=;
        b=kNuSnzFPIWMHKUPezzcImpuZu0hW4Ro3fzAGfavYGl+AW+s5e2bONXMxJSaqwjrpkh
         Zi6EFTG4vmGilALM0gZUgALzJdikUkBX/duSHAJG3Mvf4GC3N56ZPXt/91/FOv32s4vW
         klGI+I1wiBDrW+8htRGz4jBiwt/UmO/BZBCAve69oYZDY8oFH/7Lt2wNg9fTZCrpt0CP
         2PZTxqj87ycQCAzO6JcOH8tWu5uPDVjD/4KlnePG8KSKd2F0In1PS3dKAjpWBIizJuHx
         SOpvWEFB9vnGIcxPQEIeZCEvj+aFVsU00TlfdjMiW9LzW2B9RUPevYmgkeiMPOlFUMiO
         +s7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Wd3HgaUvH1soc/yfyWI6dAQdM9lUwSjfn9ndiCGooyo=;
        b=IQUo8glZxnBEZXSG0vaZJXz8l4sLLFfKyXZL1vdl3jIL3gXmjaEjFkIr8J0gC0FOgx
         JsbaZvvA9lxuXQxm8bDoqzHyT4Qv3yW6FlrPN8yUswa5Ab+djpK9cYpvnbiWlt98prvO
         pDSk1waG/nQWSqfNNPBpNNs21UykWzGmacVBDDL9U1+1HEiVdeLxcXowdcxtxClGJJHC
         nfx6ckbgIeKgwDTNyINqhBOarAm80SFm5j9DIi+T6Dft4IorZVQCjVPtBLknIzQY/txG
         xqsmeXZBtRNMIoS066JM0K2MzdjjBI8g3JJdqtY540Md9cKqna9xPEWooyeHLQvXDgcN
         hpsQ==
X-Gm-Message-State: APjAAAW2VTFIoRJdY3Y4MoaZ7nvzrzbQJftm1oB780Vo+sDmeXCUeFeb
        Jo9l0mHV2KKHmgfCrskdwDnITeW7Ffw=
X-Google-Smtp-Source: APXvYqwzwgNa8iw8e01TNyJ/nvhJtOHobvvBgaYrun20JKlfb4oBEvIFmy42R2UJ6w+1nK5FEOYtZA==
X-Received: by 2002:adf:ee01:: with SMTP id y1mr4229523wrn.268.1551906843388;
        Wed, 06 Mar 2019 13:14:03 -0800 (PST)
Received: from ubuntu.home ([77.124.117.239])
        by smtp.gmail.com with ESMTPSA id a9sm1882126wmm.10.2019.03.06.13.14.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Mar 2019 13:14:02 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH v5 02/23] videodev2.h: add V4L2_BUF_CAP_REQUIRES_REQUESTS
Date:   Wed,  6 Mar 2019 13:13:22 -0800
Message-Id: <20190306211343.15302-3-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190306211343.15302-1-dafna3@gmail.com>
References: <20190306211343.15302-1-dafna3@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

Add capability to indicate that requests are required instead of
merely supported.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
 Documentation/media/uapi/v4l/vidioc-reqbufs.rst | 4 ++++
 include/uapi/linux/videodev2.h                  | 1 +
 2 files changed, 5 insertions(+)

diff --git a/Documentation/media/uapi/v4l/vidioc-reqbufs.rst b/Documentation/media/uapi/v4l/vidioc-reqbufs.rst
index d7faef10e39b..d42a3d9a7db3 100644
--- a/Documentation/media/uapi/v4l/vidioc-reqbufs.rst
+++ b/Documentation/media/uapi/v4l/vidioc-reqbufs.rst
@@ -125,6 +125,7 @@ aborting or finishing any DMA in progress, an implicit
 .. _V4L2-BUF-CAP-SUPPORTS-DMABUF:
 .. _V4L2-BUF-CAP-SUPPORTS-REQUESTS:
 .. _V4L2-BUF-CAP-SUPPORTS-ORPHANED-BUFS:
+.. _V4L2-BUF-CAP-REQUIRES-REQUESTS:
 
 .. cssclass:: longtable
 
@@ -150,6 +151,9 @@ aborting or finishing any DMA in progress, an implicit
       - The kernel allows calling :ref:`VIDIOC_REQBUFS` while buffers are still
         mapped or exported via DMABUF. These orphaned buffers will be freed
         when they are unmapped or when the exported DMABUF fds are closed.
+    * - ``V4L2_BUF_CAP_REQUIRES_REQUESTS``
+      - 0x00000020
+      - This buffer type requires the use of :ref:`requests <media-request-api>`.
 
 Return Value
 ============
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 1db220da3bcc..97e6a6a968ba 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -895,6 +895,7 @@ struct v4l2_requestbuffers {
 #define V4L2_BUF_CAP_SUPPORTS_DMABUF	(1 << 2)
 #define V4L2_BUF_CAP_SUPPORTS_REQUESTS	(1 << 3)
 #define V4L2_BUF_CAP_SUPPORTS_ORPHANED_BUFS (1 << 4)
+#define V4L2_BUF_CAP_REQUIRES_REQUESTS	(1 << 5)
 
 /**
  * struct v4l2_plane - plane info for multi-planar buffers
-- 
2.17.1

