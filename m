Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:41084 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755072AbeDPNV1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Apr 2018 09:21:27 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 2/9] subdev-formats.rst: fix incorrect types
Date: Mon, 16 Apr 2018 15:21:14 +0200
Message-Id: <20180416132121.46205-3-hverkuil@xs4all.nl>
In-Reply-To: <20180416132121.46205-1-hverkuil@xs4all.nl>
References: <20180416132121.46205-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The ycbcr_enc, quantization and xfer_func fields are __u16 and not enums.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/media/uapi/v4l/subdev-formats.rst | 27 +++++++++++++++++++------
 1 file changed, 21 insertions(+), 6 deletions(-)

diff --git a/Documentation/media/uapi/v4l/subdev-formats.rst b/Documentation/media/uapi/v4l/subdev-formats.rst
index 9fcabe7f9367..a3f30853f8a8 100644
--- a/Documentation/media/uapi/v4l/subdev-formats.rst
+++ b/Documentation/media/uapi/v4l/subdev-formats.rst
@@ -37,19 +37,34 @@ Media Bus Formats
       - Image colorspace, from enum
 	:c:type:`v4l2_colorspace`. See
 	:ref:`colorspaces` for details.
-    * - enum :c:type:`v4l2_ycbcr_encoding`
+    * - union {
+      - (anonymous)
+      -
+    * - __u16
       - ``ycbcr_enc``
-      - This information supplements the ``colorspace`` and must be set by
+      - Y'CbCr encoding, from enum :c:type:`v4l2_ycbcr_encoding`.
+        This information supplements the ``colorspace`` and must be set by
+	the driver for capture streams and by the application for output
+	streams, see :ref:`colorspaces`.
+    * - __u16
+      - ``hsv_enc``
+      - HSV encoding, from enum :c:type:`v4l2_hsv_encoding`.
+        This information supplements the ``colorspace`` and must be set by
 	the driver for capture streams and by the application for output
 	streams, see :ref:`colorspaces`.
-    * - enum :c:type:`v4l2_quantization`
+    * - }
+      -
+      -
+    * - __u16
       - ``quantization``
-      - This information supplements the ``colorspace`` and must be set by
+      - Quantization range, from enum :c:type:`v4l2_quantization`.
+        This information supplements the ``colorspace`` and must be set by
 	the driver for capture streams and by the application for output
 	streams, see :ref:`colorspaces`.
-    * - enum :c:type:`v4l2_xfer_func`
+    * - __u16
       - ``xfer_func``
-      - This information supplements the ``colorspace`` and must be set by
+      - Transfer function, from enum :c:type:`v4l2_xfer_func`.
+        This information supplements the ``colorspace`` and must be set by
 	the driver for capture streams and by the application for output
 	streams, see :ref:`colorspaces`.
     * - __u16
-- 
2.15.1
