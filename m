Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:47951 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728074AbeIGTpX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Sep 2018 15:45:23 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: vidioc-cropcap/g-crop.rst: fix confusing sentence
Message-ID: <586ebd2e-1fcf-b535-bfbd-422fc9c69d0b@xs4all.nl>
Date: Fri, 7 Sep 2018 17:04:00 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The note that the text refers to is actually *below* the type description,
not above.

Fix this.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/Documentation/media/uapi/v4l/vidioc-cropcap.rst b/Documentation/media/uapi/v4l/vidioc-cropcap.rst
index a65dbec6b20b..0a7b8287fd38 100644
--- a/Documentation/media/uapi/v4l/vidioc-cropcap.rst
+++ b/Documentation/media/uapi/v4l/vidioc-cropcap.rst
@@ -58,7 +58,7 @@ overlay devices.
       - Type of the data stream, set by the application. Only these types
 	are valid here: ``V4L2_BUF_TYPE_VIDEO_CAPTURE``, ``V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE``,
 	``V4L2_BUF_TYPE_VIDEO_OUTPUT``, ``V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE`` and
-	``V4L2_BUF_TYPE_VIDEO_OVERLAY``. See :c:type:`v4l2_buf_type` and the note above.
+	``V4L2_BUF_TYPE_VIDEO_OVERLAY``. See :c:type:`v4l2_buf_type` and the note below.
     * - struct :ref:`v4l2_rect <v4l2-rect-crop>`
       - ``bounds``
       - Defines the window within capturing or output is possible, this
diff --git a/Documentation/media/uapi/v4l/vidioc-g-crop.rst b/Documentation/media/uapi/v4l/vidioc-g-crop.rst
index a6ed43ba9ca3..b95ba6743cbd 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-crop.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-crop.rst
@@ -84,7 +84,7 @@ When cropping is not supported then no parameters are changed and
       - Type of the data stream, set by the application. Only these types
 	are valid here: ``V4L2_BUF_TYPE_VIDEO_CAPTURE``, ``V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE``,
 	``V4L2_BUF_TYPE_VIDEO_OUTPUT``, ``V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE`` and
-	``V4L2_BUF_TYPE_VIDEO_OVERLAY``. See :c:type:`v4l2_buf_type` and the note above.
+	``V4L2_BUF_TYPE_VIDEO_OVERLAY``. See :c:type:`v4l2_buf_type` and the note below.
     * - struct :c:type:`v4l2_rect`
       - ``c``
       - Cropping rectangle. The same co-ordinate system as for struct
