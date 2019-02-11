Return-Path: <SRS0=8Y7M=QS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00B20C4151A
	for <linux-media@archiver.kernel.org>; Mon, 11 Feb 2019 10:14:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C497E21479
	for <linux-media@archiver.kernel.org>; Mon, 11 Feb 2019 10:14:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726340AbfBKKOD (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 11 Feb 2019 05:14:03 -0500
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:53659 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726105AbfBKKOC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Feb 2019 05:14:02 -0500
Received: from tschai.fritz.box ([212.251.195.8])
        by smtp-cloud9.xs4all.net with ESMTPA
        id t8b7gs8zWRO5Zt8bBg3Gnb; Mon, 11 Feb 2019 11:14:01 +0100
From:   Hans Verkuil <hverkuil-cisco@xs4all.nl>
To:     linux-media@vger.kernel.org
Cc:     Dafna Hirschfeld <dafna3@gmail.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCHv2 2/6] videodev2.h: add V4L2_BUF_CAP_REQUIRES_REQUESTS
Date:   Mon, 11 Feb 2019 11:13:53 +0100
Message-Id: <20190211101357.48754-3-hverkuil-cisco@xs4all.nl>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190211101357.48754-1-hverkuil-cisco@xs4all.nl>
References: <20190211101357.48754-1-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfJiEjTxQpxnSvpzpkjp9Xx4QPqYFUvnR79eNbVxxJTdmhAOwUbwm6TOr69A0RItKJSbnTAesiw1MuMSWeC13NW2FjKzMTv4GPF6TSUeEeeiwCK9B/sV0
 qqTrngwGsKTZSOfth93BBGgYy+YbBCMc63jSNcpzSWpkcptOAlCdcHK/oTbhehznBLr5idEVImxFLuKfO+F52VA6CC+nv0y29a/+F5oA/DZK9olhggxaWVf4
 x5Bhva+nPG3GkwvWumt9MvvtDg4D+MRDezG+hT5TStKqWETKWXGap5oYRgp7e/qp9rZUBm9IQ5Wz28to7vPXASLuI14wKlawhWzZbObWWjg=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

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
index 9a920f071ff9..7f035d44666e 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -891,6 +891,7 @@ struct v4l2_requestbuffers {
 #define V4L2_BUF_CAP_SUPPORTS_DMABUF	(1 << 2)
 #define V4L2_BUF_CAP_SUPPORTS_REQUESTS	(1 << 3)
 #define V4L2_BUF_CAP_SUPPORTS_ORPHANED_BUFS (1 << 4)
+#define V4L2_BUF_CAP_REQUIRES_REQUESTS	(1 << 5)
 
 /**
  * struct v4l2_plane - plane info for multi-planar buffers
-- 
2.20.1

