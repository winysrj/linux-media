Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:57053 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755400AbeCSM6Z (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Mar 2018 08:58:25 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 4/5] pixfmt-v4l2.rst: fix types
Date: Mon, 19 Mar 2018 13:58:19 +0100
Message-Id: <20180319125820.31254-5-hverkuil@xs4all.nl>
In-Reply-To: <20180319125820.31254-1-hverkuil@xs4all.nl>
References: <20180319125820.31254-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The v4l2_pix_format documentation still had 'enum's as types.
Replace by __u32 and add a reference to the enum.

Also put ycbcr_enc and hsv_enc in a union.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/media/uapi/v4l/pixfmt-v4l2.rst | 36 ++++++++++++++++++----------
 1 file changed, 24 insertions(+), 12 deletions(-)

diff --git a/Documentation/media/uapi/v4l/pixfmt-v4l2.rst b/Documentation/media/uapi/v4l/pixfmt-v4l2.rst
index 2ee164c25637..826f2305da01 100644
--- a/Documentation/media/uapi/v4l/pixfmt-v4l2.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-v4l2.rst
@@ -40,9 +40,10 @@ Single-planar format structure
 	RGB formats in :ref:`rgb-formats`, YUV formats in
 	:ref:`yuv-formats`, and reserved codes in
 	:ref:`reserved-formats`
-    * - enum :c:type::`v4l2_field`
+    * - __u32
       - ``field``
-      - Video images are typically interlaced. Applications can request to
+      - Field order, from enum :c:type:`v4l2_field`.
+        Video images are typically interlaced. Applications can request to
 	capture or output only the top or bottom field, or both fields
 	interlaced or sequentially stored in one buffer or alternating in
 	separate buffers. Drivers return the actual field order selected.
@@ -82,9 +83,10 @@ Single-planar format structure
 	driver. Usually this is ``bytesperline`` times ``height``. When
 	the image consists of variable length compressed data this is the
 	maximum number of bytes required to hold an image.
-    * - enum :c:type:`v4l2_colorspace`
+    * - __u32
       - ``colorspace``
-      - This information supplements the ``pixelformat`` and must be set
+      - Image colorspace, from enum :c:type:`v4l2_colorspace`.
+        This information supplements the ``pixelformat`` and must be set
 	by the driver for capture streams and by the application for
 	output streams, see :ref:`colorspaces`.
     * - __u32
@@ -116,23 +118,33 @@ Single-planar format structure
     * - __u32
       - ``flags``
       - Flags set by the application or driver, see :ref:`format-flags`.
-    * - enum :c:type:`v4l2_ycbcr_encoding`
+    * - union {
+      - (anonymous)
+      -
+    * - __u32
       - ``ycbcr_enc``
-      - This information supplements the ``colorspace`` and must be set by
+      - Y'CbCr encoding, from enum :c:type:`v4l2_ycbcr_encoding`.
+        This information supplements the ``colorspace`` and must be set by
 	the driver for capture streams and by the application for output
 	streams, see :ref:`colorspaces`.
-    * - enum :c:type:`v4l2_hsv_encoding`
+    * - __u32
       - ``hsv_enc``
-      - This information supplements the ``colorspace`` and must be set by
+      - HSV encoding, from enum :c:type:`v4l2_hsv_encoding`.
+        This information supplements the ``colorspace`` and must be set by
 	the driver for capture streams and by the application for output
 	streams, see :ref:`colorspaces`.
-    * - enum :c:type:`v4l2_quantization`
+    * - }
+      -
+      -
+    * - __u32
       - ``quantization``
-      - This information supplements the ``colorspace`` and must be set by
+      - Quantization range, from enum :c:type:`v4l2_quantization`.
+        This information supplements the ``colorspace`` and must be set by
 	the driver for capture streams and by the application for output
 	streams, see :ref:`colorspaces`.
-    * - enum :c:type:`v4l2_xfer_func`
+    * - __u32
       - ``xfer_func``
-      - This information supplements the ``colorspace`` and must be set by
+      - Transfer function, from enum :c:type:`v4l2_xfer_func`.
+        This information supplements the ``colorspace`` and must be set by
 	the driver for capture streams and by the application for output
 	streams, see :ref:`colorspaces`.
-- 
2.15.1
