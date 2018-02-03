Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:50015 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754346AbeBCSWL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 3 Feb 2018 13:22:11 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] subdev-formats.rst: fix incorrect types
Message-ID: <236f940e-fa4e-907d-f928-1a667b132077@xs4all.nl>
Date: Sat, 3 Feb 2018 19:22:06 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The ycbcr_enc, quantization and xfer_func fields are __u16 and not enums.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/Documentation/media/uapi/v4l/subdev-formats.rst b/Documentation/media/uapi/v4l/subdev-formats.rst
index b1eea44550e1..4f0c0b282f98 100644
--- a/Documentation/media/uapi/v4l/subdev-formats.rst
+++ b/Documentation/media/uapi/v4l/subdev-formats.rst
@@ -33,17 +33,17 @@ Media Bus Formats
       - Image colorspace, from enum
 	:c:type:`v4l2_colorspace`. See
 	:ref:`colorspaces` for details.
-    * - enum :c:type:`v4l2_ycbcr_encoding`
+    * - __u16
       - ``ycbcr_enc``
       - This information supplements the ``colorspace`` and must be set by
 	the driver for capture streams and by the application for output
 	streams, see :ref:`colorspaces`.
-    * - enum :c:type:`v4l2_quantization`
+    * - __u16
       - ``quantization``
       - This information supplements the ``colorspace`` and must be set by
 	the driver for capture streams and by the application for output
 	streams, see :ref:`colorspaces`.
-    * - enum :c:type:`v4l2_xfer_func`
+    * - __u16
       - ``xfer_func``
       - This information supplements the ``colorspace`` and must be set by
 	the driver for capture streams and by the application for output
