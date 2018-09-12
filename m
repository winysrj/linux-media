Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl1-f195.google.com ([209.85.214.195]:37243 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726082AbeILLi6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Sep 2018 07:38:58 -0400
Received: by mail-pl1-f195.google.com with SMTP id f1-v6so485210plt.4
        for <linux-media@vger.kernel.org>; Tue, 11 Sep 2018 23:35:56 -0700 (PDT)
From: dorodnic@gmail.com
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, evgeni.raikhel@intel.com,
        Sergey Dorodnicov <sergey.dorodnicov@intel.com>
Subject: [PATCH v2 1/2] [media] CNF4 fourcc for 4 bit-per-pixel packed depth confidence information
Date: Wed, 12 Sep 2018 02:42:06 -0400
Message-Id: <1536734527-3770-2-git-send-email-sergey.dorodnicov@intel.com>
In-Reply-To: <1536734527-3770-1-git-send-email-sergey.dorodnicov@intel.com>
References: <1536734527-3770-1-git-send-email-sergey.dorodnicov@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sergey Dorodnicov <sergey.dorodnicov@intel.com>

Adding new fourcc CNF4 for 4 bit-per-pixel packed depth confidence
information provided by Intel RealSense cameras. Every two consecutive
pixels are packed into a single byte.

Signed-off-by: Sergey Dorodnicov <sergey.dorodnicov@intel.com>
Signed-off-by: Evgeni Raikhel <evgeni.raikhel@intel.com>
---
 Documentation/media/uapi/v4l/depth-formats.rst |  1 +
 Documentation/media/uapi/v4l/pixfmt-cnf4.rst   | 31 ++++++++++++++++++++++++++
 drivers/media/v4l2-core/v4l2-ioctl.c           |  1 +
 include/uapi/linux/videodev2.h                 |  1 +
 4 files changed, 34 insertions(+)
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-cnf4.rst

diff --git a/Documentation/media/uapi/v4l/depth-formats.rst b/Documentation/media/uapi/v4l/depth-formats.rst
index d1641e9..9533348 100644
--- a/Documentation/media/uapi/v4l/depth-formats.rst
+++ b/Documentation/media/uapi/v4l/depth-formats.rst
@@ -14,3 +14,4 @@ Depth data provides distance to points, mapped onto the image plane
 
     pixfmt-inzi
     pixfmt-z16
+    pixfmt-cnf4
diff --git a/Documentation/media/uapi/v4l/pixfmt-cnf4.rst b/Documentation/media/uapi/v4l/pixfmt-cnf4.rst
new file mode 100644
index 0000000..8f46929
--- /dev/null
+++ b/Documentation/media/uapi/v4l/pixfmt-cnf4.rst
@@ -0,0 +1,31 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _V4L2-PIX-FMT-CNF4:
+
+******************************
+V4L2_PIX_FMT_CNF4 ('CNF4')
+******************************
+
+Depth sensor confidence information as a 4 bits per pixel packed array
+
+Description
+===========
+
+Proprietary format used by Intel RealSense Depth cameras containing depth
+confidence information in range 0-15 with 0 indicating that the sensor was
+unable to resolve any signal and 15 indicating maximum level of confidence for
+the specific sensor (actual error margins might change from sensor to sensor).
+
+Every two consecutive pixels are packed into a single byte.
+Bits 0-3 of byte n refer to confidence value of depth pixel 2*n,
+bits 4-7 to confidence value of depth pixel 2*n+1.
+
+**Bit-packed representation.**
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+    :widths: 64 64
+
+    * - Y'\ :sub:`01[3:0]`\ (bits 7--4) Y'\ :sub:`00[3:0]`\ (bits 3--0)
+      - Y'\ :sub:`03[3:0]`\ (bits 7--4) Y'\ :sub:`02[3:0]`\ (bits 3--0)
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 54afc9c..f9aa8bd 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -1189,6 +1189,7 @@ static void v4l_fill_fmtdesc(struct v4l2_fmtdesc *fmt)
 	case V4L2_PIX_FMT_Y12I:		descr = "Interleaved 12-bit Greyscale"; break;
 	case V4L2_PIX_FMT_Z16:		descr = "16-bit Depth"; break;
 	case V4L2_PIX_FMT_INZI:		descr = "Planar 10:16 Greyscale Depth"; break;
+	case V4L2_PIX_FMT_CNF4:		descr = "4-bit Depth Confidence (Packed)"; break;
 	case V4L2_PIX_FMT_PAL8:		descr = "8-bit Palette"; break;
 	case V4L2_PIX_FMT_UV8:		descr = "8-bit Chrominance UV 4-4"; break;
 	case V4L2_PIX_FMT_YVU410:	descr = "Planar YVU 4:1:0"; break;
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 622f047..2837c93 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -676,6 +676,7 @@ struct v4l2_pix_format {
 #define V4L2_PIX_FMT_Z16      v4l2_fourcc('Z', '1', '6', ' ') /* Depth data 16-bit */
 #define V4L2_PIX_FMT_MT21C    v4l2_fourcc('M', 'T', '2', '1') /* Mediatek compressed block mode  */
 #define V4L2_PIX_FMT_INZI     v4l2_fourcc('I', 'N', 'Z', 'I') /* Intel Planar Greyscale 10-bit and Depth 16-bit */
+#define V4L2_PIX_FMT_CNF4     v4l2_fourcc('C', 'N', 'F', '4') /* Intel 4-bit packed depth confidence information */
 
 /* 10bit raw bayer packed, 32 bytes for every 25 pixels, last LSB 6 bits unused */
 #define V4L2_PIX_FMT_IPU3_SBGGR10	v4l2_fourcc('i', 'p', '3', 'b') /* IPU3 packed 10-bit BGGR bayer */
-- 
2.7.4
