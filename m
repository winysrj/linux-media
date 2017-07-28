Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:59454 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751737AbdG1Mde (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Jul 2017 08:33:34 -0400
Received: from axis700.grange ([87.78.105.5]) by mail.gmx.com (mrgmx102
 [212.227.17.168]) with ESMTPSA (Nemesis) id 0M6fXs-1dpadF0sb6-00wR1D for
 <linux-media@vger.kernel.org>; Fri, 28 Jul 2017 14:33:33 +0200
Received: from 200r.grange (200r.grange [192.168.1.16])
        by axis700.grange (Postfix) with ESMTP id 35E0C8B116
        for <linux-media@vger.kernel.org>; Fri, 28 Jul 2017 14:30:58 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
Subject: [PATCH 2/6 v5]  V4L: Add a UVC Metadata format
Date: Fri, 28 Jul 2017 14:33:21 +0200
Message-Id: <1501245205-15802-3-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1501245205-15802-1-git-send-email-g.liakhovetski@gmx.de>
References: <1501245205-15802-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a pixel format, used by the UVC driver to stream metadata.

Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
---
 Documentation/media/uapi/v4l/meta-formats.rst    |  1 +
 Documentation/media/uapi/v4l/pixfmt-meta-uvc.rst | 39 ++++++++++++++++++++++++
 include/uapi/linux/videodev2.h                   |  1 +
 3 files changed, 41 insertions(+)
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-meta-uvc.rst

diff --git a/Documentation/media/uapi/v4l/meta-formats.rst b/Documentation/media/uapi/v4l/meta-formats.rst
index 01e24e3..1bb45a3f 100644
--- a/Documentation/media/uapi/v4l/meta-formats.rst
+++ b/Documentation/media/uapi/v4l/meta-formats.rst
@@ -14,3 +14,4 @@ These formats are used for the :ref:`metadata` interface only.
 
     pixfmt-meta-vsp1-hgo
     pixfmt-meta-vsp1-hgt
+    pixfmt-meta-uvc
diff --git a/Documentation/media/uapi/v4l/pixfmt-meta-uvc.rst b/Documentation/media/uapi/v4l/pixfmt-meta-uvc.rst
new file mode 100644
index 0000000..58f78cb
--- /dev/null
+++ b/Documentation/media/uapi/v4l/pixfmt-meta-uvc.rst
@@ -0,0 +1,39 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _v4l2-meta-fmt-uvc:
+
+*******************************
+V4L2_META_FMT_UVC ('UVCH')
+*******************************
+
+UVC Payload Header Data
+
+
+Description
+===========
+
+This format describes data, supplied by the UVC driver from metadata video
+nodes. That data includes UVC Payload Header contents and auxiliary timing
+information, required for precise interpretation of timestamps, contained in
+those headers. Buffers, streamed via UVC metadata nodes, are composed of blocks
+of variable length. Those blocks contain are described by struct uvc_meta_buf
+and contain the following fields:
+
+.. flat-table:: UVC Metadata Block
+    :widths: 1 4
+    :header-rows:  1
+    :stub-columns: 0
+
+    * - Field
+      - Description
+    * - struct timespec ts;
+      - system timestamp, measured by the driver upon reception of the payload
+    * - __u16 sof;
+      - USB Frame Number, also obtained by the driver
+    * - :cspan:`1` *The rest is an exact copy of the payload header:*
+    * - __u8 length;
+      - length of the rest of the block, including this field
+    * - __u8 flags;
+      - Flags, indicating presence of other standard UVC fields
+    * - __u8 buf[];
+      - The rest of the header, possibly including UVC PTS and SCR fields
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 45cf735..0aad91c 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -682,6 +682,7 @@ struct v4l2_pix_format {
 /* Meta-data formats */
 #define V4L2_META_FMT_VSP1_HGO    v4l2_fourcc('V', 'S', 'P', 'H') /* R-Car VSP1 1-D Histogram */
 #define V4L2_META_FMT_VSP1_HGT    v4l2_fourcc('V', 'S', 'P', 'T') /* R-Car VSP1 2-D Histogram */
+#define V4L2_META_FMT_UVC         v4l2_fourcc('U', 'V', 'C', 'H') /* UVC Payload Header metadata */
 
 /* priv field value to indicates that subsequent fields are valid. */
 #define V4L2_PIX_FMT_PRIV_MAGIC		0xfeedcafe
-- 
1.9.3
