Return-Path: <SRS0=o7tn=RA=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0A16C4360F
	for <linux-media@archiver.kernel.org>; Mon, 25 Feb 2019 22:20:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BBBD5213A2
	for <linux-media@archiver.kernel.org>; Mon, 25 Feb 2019 22:20:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FjA74HV/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727927AbfBYWT6 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 25 Feb 2019 17:19:58 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:39605 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726845AbfBYWT5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Feb 2019 17:19:57 -0500
Received: by mail-wr1-f66.google.com with SMTP id l5so11713265wrw.6
        for <linux-media@vger.kernel.org>; Mon, 25 Feb 2019 14:19:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Wd3HgaUvH1soc/yfyWI6dAQdM9lUwSjfn9ndiCGooyo=;
        b=FjA74HV/re31HZmPe8uHtbN7Zei6TnSs4XMQ+jNnexkyAE9Lt43MMSZCBY7VLVW9aK
         CxXLOFy7R6PyZKGAdv2GgIWxbjc0pKVStDL1FXI9iiKAzca7HjY1ACowS+/CxZ6i456z
         Jy3wwq+RL2vFpqamdLBRHDyprXBu8JRmGhrFKGbA63PoynkzhOxDgTWXrz2EYoJWNR/V
         AFFUYThz50RfFQOByTcQWQDcloCt2afKySNwqJTetnZKTSp4Kb2gHG9KS4WIasRa/H+4
         c9GOvchqUX9Zjifrc8VB4JZrSS3GeBrUrqqLm3WYrcE4TEEsuVRiofukgAGWSErQQjNg
         oPQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Wd3HgaUvH1soc/yfyWI6dAQdM9lUwSjfn9ndiCGooyo=;
        b=q0GtY9piXHBL/6dnu1rSOjBcebKCnIJzgBpynYfFK6b9/GyTINv8KqRywCK54dLnLF
         l+LXeWiryfvOaY1B/uAkAZlm1qfTdkQn5KJOZjvAYqpoQ6lWZBZLN3TqLU+IMRmqkNOw
         T/ncW+yvekfbtM2nZDVhXhhkML6RAdowXdqNC/awdMQ43vBeQJVIlDtFIw9dLVYy4Mjo
         qKptD9fcyV+GXi7ZGrDSciBLUA+FwQHC4Oy/vR9YfC0IN47xeBkrrd9gw1zaaBa37fLg
         G/Hz2GKrY9Y69Mk6JyWwh9Wd5tMXGR8HBYJ3BzGImofYECrFyiODDE4T08CcOtGSduYX
         JcvA==
X-Gm-Message-State: AHQUAub4Hgd5H9yLlXIPsYAibC0vLlW1tXZ62r5wP1bTEcOZwRDq20zy
        sKdEkAsNfKMs7/4h4AOkNo8pJwCJEB4=
X-Google-Smtp-Source: AHgI3IZRMgCFfXkf5pGdC0Opq/Cql2KEIAFfh0eqT7mt3zQhoooBAVpdYTO7xmyM4ZCWjCMuyMRffw==
X-Received: by 2002:a05:6000:128f:: with SMTP id f15mr13505295wrx.74.1551133194967;
        Mon, 25 Feb 2019 14:19:54 -0800 (PST)
Received: from ubuntu.home ([77.127.107.32])
        by smtp.gmail.com with ESMTPSA id a20sm4168033wmb.17.2019.02.25.14.19.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 25 Feb 2019 14:19:54 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH v4 02/21] videodev2.h: add V4L2_BUF_CAP_REQUIRES_REQUESTS
Date:   Mon, 25 Feb 2019 14:19:26 -0800
Message-Id: <20190225221933.121653-3-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190225221933.121653-1-dafna3@gmail.com>
References: <20190225221933.121653-1-dafna3@gmail.com>
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

