Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:62366 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752608AbdKHQAS (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 8 Nov 2017 11:00:18 -0500
Received: from axis700.grange ([84.44.207.202]) by mail.gmx.com (mrgmx001
 [212.227.17.190]) with ESMTPSA (Nemesis) id 0MEXHd-1eRYwC0gll-00FlBq for
 <linux-media@vger.kernel.org>; Wed, 08 Nov 2017 17:00:17 +0100
Received: from 200r.grange (200r.grange [192.168.1.16])
        by axis700.grange (Postfix) with ESMTP id 72A0E61892
        for <linux-media@vger.kernel.org>; Wed,  8 Nov 2017 17:00:15 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
Subject: [PATCH 1/3 v7] V4L: Add a UVC Metadata format
Date: Wed,  8 Nov 2017 17:00:12 +0100
Message-Id: <1510156814-28645-2-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1510156814-28645-1-git-send-email-g.liakhovetski@gmx.de>
References: <1510156814-28645-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>

Add a pixel format, used by the UVC driver to stream metadata.

Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
---

v7: alphabetic order, update documentation.

 Documentation/media/uapi/v4l/meta-formats.rst    |  1 +
 Documentation/media/uapi/v4l/pixfmt-meta-uvc.rst | 50 ++++++++++++++++++++++++
 include/uapi/linux/videodev2.h                   |  1 +
 3 files changed, 52 insertions(+)
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-meta-uvc.rst

diff --git a/Documentation/media/uapi/v4l/meta-formats.rst b/Documentation/media/uapi/v4l/meta-formats.rst
index 01e24e3..0c4e1ec 100644
--- a/Documentation/media/uapi/v4l/meta-formats.rst
+++ b/Documentation/media/uapi/v4l/meta-formats.rst
@@ -12,5 +12,6 @@ These formats are used for the :ref:`metadata` interface only.
 .. toctree::
     :maxdepth: 1
 
+    pixfmt-meta-uvc
     pixfmt-meta-vsp1-hgo
     pixfmt-meta-vsp1-hgt
diff --git a/Documentation/media/uapi/v4l/pixfmt-meta-uvc.rst b/Documentation/media/uapi/v4l/pixfmt-meta-uvc.rst
new file mode 100644
index 0000000..06f603c
--- /dev/null
+++ b/Documentation/media/uapi/v4l/pixfmt-meta-uvc.rst
@@ -0,0 +1,50 @@
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
+This format describes standard UVC metadata, extracted from UVC packet headers
+and provided by the UVC driver through metadata video nodes. That data includes
+exact copies of the standard part of UVC Payload Header contents and auxiliary
+timing information, required for precise interpretation of timestamps, contained
+in those headers. See section "2.4.3.3 Video and Still Image Payload Headers" of
+the "UVC 1.5 Class specification" for details.
+
+Each UVC payload header can be between 2 and 12 bytes large. Buffers can contain
+multiple headers, if multiple such headers have been transmitted by the camera
+for the respective frame. However, headers, containing no useful information,
+e.g. those without the SCR field or with that field identical to the previous
+header, will be dropped by the driver.
+
+Each individual block contains the following fields:
+
+.. flat-table:: UVC Metadata Block
+    :widths: 1 4
+    :header-rows:  1
+    :stub-columns: 0
+
+    * - Field
+      - Description
+    * - __u64 ts;
+      - system timestamp in host byte order, measured by the driver upon
+        reception of the payload
+    * - __u16 sof;
+      - USB Frame Number in host byte order, also obtained by the driver as
+        close as possible to the above timestamp to enable correlation between
+        them
+    * - :cspan:`1` *The rest is an exact copy of the UVC payload header:*
+    * - __u8 length;
+      - length of the rest of the block, including this field
+    * - __u8 flags;
+      - Flags, indicating presence of other standard UVC fields
+    * - __u8 buf[];
+      - The rest of the header, possibly including UVC PTS and SCR fields
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 185d6a0..0d07b2d 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -687,6 +687,7 @@ struct v4l2_pix_format {
 /* Meta-data formats */
 #define V4L2_META_FMT_VSP1_HGO    v4l2_fourcc('V', 'S', 'P', 'H') /* R-Car VSP1 1-D Histogram */
 #define V4L2_META_FMT_VSP1_HGT    v4l2_fourcc('V', 'S', 'P', 'T') /* R-Car VSP1 2-D Histogram */
+#define V4L2_META_FMT_UVC         v4l2_fourcc('U', 'V', 'C', 'H') /* UVC Payload Header metadata */
 
 /* priv field value to indicates that subsequent fields are valid. */
 #define V4L2_PIX_FMT_PRIV_MAGIC		0xfeedcafe
-- 
1.9.3
