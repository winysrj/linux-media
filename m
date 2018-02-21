Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:37549 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S938336AbeBUPcY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Feb 2018 10:32:24 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv4 06/15] subdev-formats.rst: fix incorrect types
Date: Wed, 21 Feb 2018 16:32:09 +0100
Message-Id: <20180221153218.15654-7-hverkuil@xs4all.nl>
In-Reply-To: <20180221153218.15654-1-hverkuil@xs4all.nl>
References: <20180221153218.15654-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The ycbcr_enc, quantization and xfer_func fields are __u16 and not enums.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 Documentation/media/uapi/v4l/subdev-formats.rst | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

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
-- 
2.16.1
