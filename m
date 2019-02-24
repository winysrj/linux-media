Return-Path: <SRS0=d4St=Q7=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A476C43381
	for <linux-media@archiver.kernel.org>; Sun, 24 Feb 2019 09:02:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4858A20652
	for <linux-media@archiver.kernel.org>; Sun, 24 Feb 2019 09:02:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JWLBGtnM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728151AbfBXJCz (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 24 Feb 2019 04:02:55 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:39013 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726001AbfBXJCy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 24 Feb 2019 04:02:54 -0500
Received: by mail-wm1-f65.google.com with SMTP id z84so5404174wmg.4
        for <linux-media@vger.kernel.org>; Sun, 24 Feb 2019 01:02:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Wd3HgaUvH1soc/yfyWI6dAQdM9lUwSjfn9ndiCGooyo=;
        b=JWLBGtnMhszysQzGd+OfF4k239OUhAItbOHXFASAaZQy5EFsDh/DGtxdEu4jwOPNn0
         QjfmforjhacmzyKAOlq+FDh0aQbf3kUTlVirMY17rpFY264seCDraWipEpf2cEgmB9tE
         ++4dPiRRKKXmQeMVSolez1x3QMgyvrehKYGw97oheDUPdXIq0UpxuHZglsLOQGf9RZeO
         5a23N3pLGpjq0yBY2YZ1AlZ/zUVxzOz/pXXbV4RXeFcbeYEjW5BAQB5fWcHeRnx1jCP6
         jo09Atp33Q6jAoVxHbfkqqPXJC6AIdRLXk//lStpMMEynrqB6HwY1lCsEdUBsEo80ZbL
         lYXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Wd3HgaUvH1soc/yfyWI6dAQdM9lUwSjfn9ndiCGooyo=;
        b=TYCDccsvy59oHZHTccQnSs78XpQSZSHOyhqLCJDFGT7HFfTj8qYLlo8Jj8Vjmd4kt+
         CqGJgsbW57P4KcH7fh4c6yRY+24VCCZt97J7uag8OlGokgsuHTyVYWCm3pxOao+AWYZ1
         mZOp6MkCi598WHorMxDBlifAIvs/dE0LMr3Lf1oA8MhcSp/fkwi/hoe/g7IbAIsM+ChY
         dlkj/FYdBr2wiJ36yrPm95OgKFhUHf5flzHPX/1tJKEeM+a3BWBToGysG0rR2wAUeoUQ
         Zzo/zkdkNLjNnQwWDLaIq+on3xtk336ne34gL5uQ+PqZZijYQCviz/NJQDeIz+0LMIEU
         xEzA==
X-Gm-Message-State: AHQUAuYDqcEtjOv8nRDxfYowxOff9/dcPfGJCnqXkar0pIQs/a2Sh7/3
        Rje7OWkW25KepzfALkGQXxNRMZxMzlk=
X-Google-Smtp-Source: AHgI3IbiKVVTcU5fbs0XjEndcDn91TLK7uqQq5hzPK1GYDoSE2xI4vjiK7ywZVMmV3sz5o0v2Ab9MQ==
X-Received: by 2002:a1c:4406:: with SMTP id r6mr7190516wma.114.1550998972496;
        Sun, 24 Feb 2019 01:02:52 -0800 (PST)
Received: from ubuntu.home ([77.127.107.32])
        by smtp.gmail.com with ESMTPSA id e75sm8701971wmg.32.2019.02.24.01.02.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 24 Feb 2019 01:02:51 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH v3 02/18] videodev2.h: add V4L2_BUF_CAP_REQUIRES_REQUESTS
Date:   Sun, 24 Feb 2019 01:02:19 -0800
Message-Id: <20190224090234.19723-3-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190224090234.19723-1-dafna3@gmail.com>
References: <20190224090234.19723-1-dafna3@gmail.com>
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

