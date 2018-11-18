Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:50632 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725962AbeKRUhD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 18 Nov 2018 15:37:03 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] vidioc-enum-fmt.rst: update list of valid buftypes
Message-ID: <a898ec7d-cdae-19d0-2288-7236ffaaf3c5@xs4all.nl>
Date: Sun, 18 Nov 2018 11:17:07 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

ENUM_FMT is valid for SDR and META buffer types as well.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/Documentation/media/uapi/v4l/vidioc-enum-fmt.rst b/Documentation/media/uapi/v4l/vidioc-enum-fmt.rst
index 019c513df217..33d4b51a7d16 100644
--- a/Documentation/media/uapi/v4l/vidioc-enum-fmt.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enum-fmt.rst
@@ -64,8 +64,12 @@ one until ``EINVAL`` is returned.
 	are valid here: ``V4L2_BUF_TYPE_VIDEO_CAPTURE``,
 	``V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE``,
 	``V4L2_BUF_TYPE_VIDEO_OUTPUT``,
-	``V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE`` and
-	``V4L2_BUF_TYPE_VIDEO_OVERLAY``. See :c:type:`v4l2_buf_type`.
+	``V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE``,
+	``V4L2_BUF_TYPE_VIDEO_OVERLAY``,
+	``V4L2_BUF_TYPE_SDR_CAPTURE``,
+	``V4L2_BUF_TYPE_SDR_OUTPUT`` and
+	``V4L2_BUF_TYPE_META_CAPTURE``.
+	See :c:type:`v4l2_buf_type`.
     * - __u32
       - ``flags``
       - See :ref:`fmtdesc-flags`
