Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:41453 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754297Ab3H3CRw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Aug 2013 22:17:52 -0400
Received: by mail-pa0-f54.google.com with SMTP id kx10so1703112pab.13
        for <linux-media@vger.kernel.org>; Thu, 29 Aug 2013 19:17:52 -0700 (PDT)
From: Pawel Osciak <posciak@chromium.org>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com,
	Pawel Osciak <posciak@chromium.org>
Subject: [PATCH v1 14/19] v4l: Add v4l2_buffer flags for VP8-specific special frames.
Date: Fri, 30 Aug 2013 11:17:13 +0900
Message-Id: <1377829038-4726-15-git-send-email-posciak@chromium.org>
In-Reply-To: <1377829038-4726-1-git-send-email-posciak@chromium.org>
References: <1377829038-4726-1-git-send-email-posciak@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add bits for previous, golden and altref frame types.

Signed-off-by: Pawel Osciak <posciak@chromium.org>
---
 include/uapi/linux/videodev2.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 437f1b0..c011ee0 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -687,6 +687,10 @@ struct v4l2_buffer {
 #define V4L2_BUF_FLAG_TIMESTAMP_UNKNOWN		0x0000
 #define V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC	0x2000
 #define V4L2_BUF_FLAG_TIMESTAMP_COPY		0x4000
+/* VP8 special frames */
+#define V4L2_BUF_FLAG_PREV_FRAME		0x10000  /* VP8 prev frame */
+#define V4L2_BUF_FLAG_GOLDEN_FRAME		0x20000  /* VP8 golden frame */
+#define V4L2_BUF_FLAG_ALTREF_FRAME		0x40000  /* VP8 altref frame */
 
 /**
  * struct v4l2_exportbuffer - export of video buffer as DMABUF file descriptor
-- 
1.8.4

