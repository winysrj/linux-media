Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:45098 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755325AbeCSM6Z (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Mar 2018 08:58:25 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 3/5] pixfmt-v4l2-mplane.rst: fix types
Date: Mon, 19 Mar 2018 13:58:18 +0100
Message-Id: <20180319125820.31254-4-hverkuil@xs4all.nl>
In-Reply-To: <20180319125820.31254-1-hverkuil@xs4all.nl>
References: <20180319125820.31254-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The v4l2_pix_format_mplane documentation still had 'enum's as types.
Replace by __u8 and add a reference to the enum.

Also put ycbcr_enc and hsv_enc in a union.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 .../media/uapi/v4l/pixfmt-v4l2-mplane.rst          | 36 ++++++++++++++--------
 1 file changed, 24 insertions(+), 12 deletions(-)

diff --git a/Documentation/media/uapi/v4l/pixfmt-v4l2-mplane.rst b/Documentation/media/uapi/v4l/pixfmt-v4l2-mplane.rst
index 337e8188caf1..ef52f637d8e9 100644
--- a/Documentation/media/uapi/v4l/pixfmt-v4l2-mplane.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-v4l2-mplane.rst
@@ -55,12 +55,14 @@ describing all planes of that format.
       - ``pixelformat``
       - The pixel format. Both single- and multi-planar four character
 	codes can be used.
-    * - enum :c:type:`v4l2_field`
+    * - __u32
       - ``field``
-      - See struct :c:type:`v4l2_pix_format`.
-    * - enum :c:type:`v4l2_colorspace`
+      - Field order, from enum :c:type:`v4l2_field`.
+        See struct :c:type:`v4l2_pix_format`.
+    * - __u32
       - ``colorspace``
-      - See struct :c:type:`v4l2_pix_format`.
+      - Colorspace encoding, from enum :c:type:`v4l2_colorspace`.
+        See struct :c:type:`v4l2_pix_format`.
     * - struct :c:type:`v4l2_plane_pix_format`
       - ``plane_fmt[VIDEO_MAX_PLANES]``
       - An array of structures describing format of each plane this pixel
@@ -73,24 +75,34 @@ describing all planes of that format.
     * - __u8
       - ``flags``
       - Flags set by the application or driver, see :ref:`format-flags`.
-    * - enum :c:type:`v4l2_ycbcr_encoding`
+    * - union {
+      - (anonymous)
+      -
+    * - __u8
       - ``ycbcr_enc``
-      - This information supplements the ``colorspace`` and must be set by
+      - Y'CbCr encoding, from enum :c:type:`v4l2_ycbcr_encoding`.
+        This information supplements the ``colorspace`` and must be set by
 	the driver for capture streams and by the application for output
 	streams, see :ref:`colorspaces`.
-    * - enum :c:type:`v4l2_hsv_encoding`
+    * - __u8
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
+    * - __u8
       - ``quantization``
-      - This information supplements the ``colorspace`` and must be set by
+      - Quantization range, from enum :c:type:`v4l2_quantization`.
+        This information supplements the ``colorspace`` and must be set by
 	the driver for capture streams and by the application for output
 	streams, see :ref:`colorspaces`.
-    * - enum :c:type:`v4l2_xfer_func`
+    * - __u8
       - ``xfer_func``
-      - This information supplements the ``colorspace`` and must be set by
+      - Transfer function, from enum :c:type:`v4l2_xfer_func`.
+        This information supplements the ``colorspace`` and must be set by
 	the driver for capture streams and by the application for output
 	streams, see :ref:`colorspaces`.
     * - __u8
-- 
2.15.1
