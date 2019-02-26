Return-Path: <SRS0=99fO=RB=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E05E2C43381
	for <linux-media@archiver.kernel.org>; Tue, 26 Feb 2019 17:05:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AE04D21852
	for <linux-media@archiver.kernel.org>; Tue, 26 Feb 2019 17:05:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C2iIowuX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727704AbfBZRFe (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 26 Feb 2019 12:05:34 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:34496 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727981AbfBZRFd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Feb 2019 12:05:33 -0500
Received: by mail-wr1-f65.google.com with SMTP id f14so14812197wrg.1
        for <linux-media@vger.kernel.org>; Tue, 26 Feb 2019 09:05:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Wd3HgaUvH1soc/yfyWI6dAQdM9lUwSjfn9ndiCGooyo=;
        b=C2iIowuXh94OnWyyXPp+DKBfuCq2Z/e5XHn4LDh9Pd4CEIoGGbn+O4MAMlsUPZ0FFr
         e4CyGQqDG+F+Yiuv/uLV5oco9aoy9f5UWhSOSM8iIfB8Q9i0mJBVpUJohgKnRW0fmulz
         ks+7RlMyi63PlHYBe2/jURpDGuIbXiQY0fWvciK7BRv9cTacLycDBhNMk+qjYV9ricrG
         PhWKwvzzSOCXoh2qj5rirLYwiNwMYf3BGIe/O4MPeRBCuuBTnYbSNnL3+mNx6N20jbox
         vwF0unLKCmeVOia+mVLMFWZlzkUOJANV/U/gR9tmQgMeyUk8oshaRbF1suzCJM9zkgj1
         UB2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Wd3HgaUvH1soc/yfyWI6dAQdM9lUwSjfn9ndiCGooyo=;
        b=fjBA3cBMtWJCNUcw7gNniC0vj6Qkzx5KP5q47y/QWnhyoBlYpZz0nNqyYNZ+eWNZaA
         UJ3RMdOKDB8Cjwc5BdRqU0Z+wWk2kfIldKffim8R7U5tu04Qq66KXhmRQowIWqPJdJZd
         G4Df8jQLHdssyXEihOQu4z826v/IbcbtdS3oATlPo3hGK0rRitWTBQh4b9TLv6RRVvuZ
         lJVVZO5wqx/HQnbRdW0D6Xk4XZxCdw1e/852H/sSABjfkWbvhCSO+hyOQPpzpPX34Kra
         1z4OyivuMREQBHntZZ2v2yfD3CLRGBwQob+B6tlqpi7UFgKts1SPiDyUdpW9SvF6aSdI
         pejA==
X-Gm-Message-State: AHQUAuZdnIHq+isO6zDgLXkBtrpVa+nIUMKspzRetzss2T0p+XG/wXDI
        yJZooKNfGJ59eeKooRQHqZQTBQbyXug=
X-Google-Smtp-Source: AHgI3Ib05zKAQUfNN4S19Hxx8wFpaJiddXz/yQ6+UePath0nrpKd126oJdGuJtNHMCbP0GRVG2qljw==
X-Received: by 2002:adf:822d:: with SMTP id 42mr17112330wrb.63.1551200731555;
        Tue, 26 Feb 2019 09:05:31 -0800 (PST)
Received: from ubuntu.home ([77.127.107.32])
        by smtp.gmail.com with ESMTPSA id w4sm21024486wrk.85.2019.02.26.09.05.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 26 Feb 2019 09:05:31 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH v5 02/21] videodev2.h: add V4L2_BUF_CAP_REQUIRES_REQUESTS
Date:   Tue, 26 Feb 2019 09:04:55 -0800
Message-Id: <20190226170514.86127-3-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190226170514.86127-1-dafna3@gmail.com>
References: <20190226170514.86127-1-dafna3@gmail.com>
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

