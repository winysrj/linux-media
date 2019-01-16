Return-Path: <SRS0=IHIA=PY=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83B0FC43387
	for <linux-media@archiver.kernel.org>; Wed, 16 Jan 2019 12:37:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5480120651
	for <linux-media@archiver.kernel.org>; Wed, 16 Jan 2019 12:37:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="emXV4I1S"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390244AbfAPMhV (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 16 Jan 2019 07:37:21 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:54142 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390065AbfAPMhR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Jan 2019 07:37:17 -0500
Received: by mail-wm1-f66.google.com with SMTP id d15so1804932wmb.3
        for <linux-media@vger.kernel.org>; Wed, 16 Jan 2019 04:37:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=ug3e6os5jQU/1Xs40WCRERDqZndrU7H97ENHpqaYS2E=;
        b=emXV4I1SuCbX9VI163mNmQxjot37j8GeK/s+BjfRrArDVlVnWFejYp8xkt+sdKOuZl
         /KdjvfGcKsA8MFci7e+NQ7zY+uRyuCcvXc566PK9OiPfLB8XJzjGuRaBz4ovxKj6YZuT
         bRD53LepgG6WSeB1pa+LQP32cYNOyEfwvmaTc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ug3e6os5jQU/1Xs40WCRERDqZndrU7H97ENHpqaYS2E=;
        b=uCq8azRwR1k3WbwsBFbB/ocex6ax6a7+VMPmn160yJaT2TdmxKq3/JOFcattQZ2BHh
         Wqe/vJL1JH3Yxu/4+jX6fe8XJwnAXqUHjp8v1kjJNRET9Dc85LPPMa7lJweOvR3XoEZm
         3KjLiA4GUGmdlnnhl9mClLOGdzGRpgWV48cYJC3JE4fR3ffysLMux+p2TsJpOQ3Fcc8A
         3vN7xeQMI8nNOXgsg8Rc/aYemk+bsEYPH8pgqnKAXyc+4rzRekTfi6Zbzl1bswKGCW1w
         4HlB8rdg/JuDn//GlGoTwSJeI6BfHRRzCgLYKLslNpvqD/PSd09SGJfy7XbVeB//X7r+
         +kbw==
X-Gm-Message-State: AJcUukf97Jc5QYn2q2FGMxsV8u0qJWYjDUu2BIQLbI5iLG9PmuhXE4BQ
        kLxLGS0iPoif8lsezY3AZFWDgsjVGJo=
X-Google-Smtp-Source: ALg8bN7zC0XHxXR2PX4G8EkLjLzfoxieUQH+pYYO88qou9obnTRdCtwFJRw1I8YcgTLVIPxsXM1E2g==
X-Received: by 2002:a1c:410b:: with SMTP id o11mr7502319wma.109.1547642234739;
        Wed, 16 Jan 2019 04:37:14 -0800 (PST)
Received: from localhost.localdomain ([37.157.136.206])
        by smtp.gmail.com with ESMTPSA id x20sm49382682wme.6.2019.01.16.04.37.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Jan 2019 04:37:13 -0800 (PST)
From:   Stanimir Varbanov <stanimir.varbanov@linaro.org>
To:     linux-media@vger.kernel.org
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Vikash Garodia <vgarodia@codeaurora.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Malathi Gottam <mgottam@codeaurora.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: [RFC PATCH] media/doc: Allow sizeimage to be set by v4l clients
Date:   Wed, 16 Jan 2019 14:37:01 +0200
Message-Id: <20190116123701.10344-1-stanimir.varbanov@linaro.org>
X-Mailer: git-send-email 2.17.1
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This changes v4l2_pix_format and v4l2_plane_pix_format sizeimage
field description to allow v4l clients to set bigger image size
in case of variable length compressed data.

Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
---
 Documentation/media/uapi/v4l/pixfmt-v4l2-mplane.rst | 5 ++++-
 Documentation/media/uapi/v4l/pixfmt-v4l2.rst        | 3 ++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/Documentation/media/uapi/v4l/pixfmt-v4l2-mplane.rst b/Documentation/media/uapi/v4l/pixfmt-v4l2-mplane.rst
index 7f82dad9013a..dbe0b74e9ba4 100644
--- a/Documentation/media/uapi/v4l/pixfmt-v4l2-mplane.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-v4l2-mplane.rst
@@ -30,7 +30,10 @@ describing all planes of that format.
 
     * - __u32
       - ``sizeimage``
-      - Maximum size in bytes required for image data in this plane.
+      - Maximum size in bytes required for image data in this plane,
+        set by the driver. When the image consists of variable length
+        compressed data this is the maximum number of bytes required
+        to hold an image, and it is allowed to be set by the client.
     * - __u32
       - ``bytesperline``
       - Distance in bytes between the leftmost pixels in two adjacent
diff --git a/Documentation/media/uapi/v4l/pixfmt-v4l2.rst b/Documentation/media/uapi/v4l/pixfmt-v4l2.rst
index 71eebfc6d853..54b6d2b67bd7 100644
--- a/Documentation/media/uapi/v4l/pixfmt-v4l2.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-v4l2.rst
@@ -89,7 +89,8 @@ Single-planar format structure
       - Size in bytes of the buffer to hold a complete image, set by the
 	driver. Usually this is ``bytesperline`` times ``height``. When
 	the image consists of variable length compressed data this is the
-	maximum number of bytes required to hold an image.
+	maximum number of bytes required to hold an image, and it is
+	allowed to be set by the client.
     * - __u32
       - ``colorspace``
       - Image colorspace, from enum :c:type:`v4l2_colorspace`.
-- 
2.17.1

