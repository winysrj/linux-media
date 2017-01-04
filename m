Return-path: <linux-media-owner@vger.kernel.org>
Received: from kozue.soulik.info ([108.61.200.231]:57338 "EHLO
        kozue.soulik.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751319AbdADQ3r (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 4 Jan 2017 11:29:47 -0500
From: Randy Li <ayaka@soulik.info>
To: dri-devel@lists.freedesktop.org
Cc: ville.syrjala@linux.intel.com, randy.li@rock-chips.com,
        linux-kernel@vger.kernel.org, daniel.vetter@intel.com,
        mchehab@kernel.org, linux-media@vger.kernel.org,
        Randy Li <ayaka@soulik.info>
Subject: [PATCH v2 2/2] [media] v4l: Add 10/16-bits per channel YUV pixel formats
Date: Thu,  5 Jan 2017 00:29:11 +0800
Message-Id: <1483547351-5792-3-git-send-email-ayaka@soulik.info>
In-Reply-To: <1483547351-5792-1-git-send-email-ayaka@soulik.info>
References: <1483547351-5792-1-git-send-email-ayaka@soulik.info>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The formats added by this patch are:
	V4L2_PIX_FMT_P010
	V4L2_PIX_FMT_P010M
	V4L2_PIX_FMT_P016
	V4L2_PIX_FMT_P016M
Currently, none of driver uses those format, but some video device
has been confirmed with could as those format for video output.
The Rockchip's new decoder has supported those 10 bits format for
profile_10 HEVC/AVC video.

Signed-off-by: Randy Li <ayaka@soulik.info>

v4l2
---
 Documentation/media/uapi/v4l/pixfmt-p010.rst  |  86 ++++++++++++++++
 Documentation/media/uapi/v4l/pixfmt-p010m.rst |  94 ++++++++++++++++++
 Documentation/media/uapi/v4l/pixfmt-p016.rst  | 126 ++++++++++++++++++++++++
 Documentation/media/uapi/v4l/pixfmt-p016m.rst | 136 ++++++++++++++++++++++++++
 include/uapi/linux/videodev2.h                |   4 +
 5 files changed, 446 insertions(+)
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-p010.rst
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-p010m.rst
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-p016.rst
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-p016m.rst

diff --git a/Documentation/media/uapi/v4l/pixfmt-p010.rst b/Documentation/media/uapi/v4l/pixfmt-p010.rst
new file mode 100644
index 0000000..82b300c
--- /dev/null
+++ b/Documentation/media/uapi/v4l/pixfmt-p010.rst
@@ -0,0 +1,86 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _V4L2-PIX-FMT-P010:
+
+******************************************************
+V4L2_PIX_FMT_P010 ('P010')
+******************************************************
+
+
+V4L2_PIX_FMT_P010
+Formats with ½ horizontal and vertical chroma resolution. One luminance and
+one chrominance plane with alternating
+chroma samples as simliar to ``V4L2_PIX_FMT_NV12``
+
+
+Description
+===========
+
+It is a two-plane versions of the YUV 4:2:0 format. The three
+components are separated into two sub-images or planes. The Y plane is
+first. The Y plane has 10 bits per pixel. For ``V4L2_PIX_FMT_P010``, a
+combined CbCr plane immediately follows the Y plane in memory. The CbCr
+plane is the same width, in bytes, as the Y plane (and of the image),
+but is half as tall in pixels. Each CbCr pair belongs to four pixels.
+For example, Cb\ :sub:`0`/Cr\ :sub:`0` belongs to Y'\ :sub:`00`,
+Y'\ :sub:`01`, Y'\ :sub:`10`, Y'\ :sub:`11`.
+If the Y plane has pad bytes after each row, then the CbCr plane has as
+many pad bytes after its rows.
+
+
+**Color Sample Location..**
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+    * -
+      - 0
+      -
+      - 1
+      - 2
+      -
+      - 3
+    * - 0
+      - Y
+      -
+      - Y
+      - Y
+      -
+      - Y
+    * -
+      -
+      - C
+      -
+      -
+      - C
+      -
+    * - 1
+      - Y
+      -
+      - Y
+      - Y
+      -
+      - Y
+    * -
+    * - 2
+      - Y
+      -
+      - Y
+      - Y
+      -
+      - Y
+    * -
+      -
+      - C
+      -
+      -
+      - C
+      -
+    * - 3
+      - Y
+      -
+      - Y
+      - Y
+      -
+      - Y
diff --git a/Documentation/media/uapi/v4l/pixfmt-p010m.rst b/Documentation/media/uapi/v4l/pixfmt-p010m.rst
new file mode 100644
index 0000000..80194a1
--- /dev/null
+++ b/Documentation/media/uapi/v4l/pixfmt-p010m.rst
@@ -0,0 +1,94 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _V4L2-PIX-FMT-P010M:
+
+***********************************************************************************
+V4L2_PIX_FMT_P010 ('P010')
+***********************************************************************************
+
+
+V4L2_PIX_FMT_P010M
+Variation of ``V4L2_PIX_FMT_P010`` with planes non contiguous in memory.
+
+
+Description
+===========
+
+This is a multi-planar, two-plane version of the YUV 4:2:0 format. The
+three components are separated into two sub-images or planes.
+``V4L2_PIX_FMT_P010M`` differs from ``V4L2_PIX_FMT_P010`` in that the
+two planes are non-contiguous in memory, i.e. the chroma plane do not
+necessarily immediately follows the luma plane. The luminance data
+occupies the first plane. The Y plane has one byte per pixel. In the
+second plane there is a chrominance data with alternating chroma
+samples. The CbCr plane is the same width, in bytes, as the Y plane (and
+of the image), but is half as tall in pixels. Each CbCr pair belongs to
+four pixels. For example, Cb\ :sub:`0`/Cr\ :sub:`0` belongs to
+Y'\ :sub:`00`, Y'\ :sub:`01`, Y'\ :sub:`10`, Y'\ :sub:`11`.
+
+``V4L2_PIX_FMT_P010M`` is intended to be used only in drivers and
+applications that support the multi-planar API, described in
+:ref:`planar-apis`.
+
+If the Y plane has pad bytes after each row, then the CbCr plane has as
+many pad bytes after its rows.
+
+**Color Sample Location..**
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+    * -
+      - 0
+      -
+      - 1
+      - 2
+      -
+      - 3
+    * - 0
+      - Y
+      -
+      - Y
+      - Y
+      -
+      - Y
+    * -
+      -
+      - C
+      -
+      -
+      - C
+      -
+    * - 1
+      - Y
+      -
+      - Y
+      - Y
+      -
+      - Y
+    * -
+    * - 2
+      - Y
+      -
+      - Y
+      - Y
+      -
+      - Y
+    * -
+      -
+      - C
+      -
+      -
+      -
+      - C
+      -
+    * - 3
+      - Y
+      -
+      - Y
+      - Y
+      -
+      - Y
diff --git a/Documentation/media/uapi/v4l/pixfmt-p016.rst b/Documentation/media/uapi/v4l/pixfmt-p016.rst
new file mode 100644
index 0000000..ac341a1
--- /dev/null
+++ b/Documentation/media/uapi/v4l/pixfmt-p016.rst
@@ -0,0 +1,126 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _V4L2-PIX-FMT-P016:
+
+******************************************************
+V4L2_PIX_FMT_P016 ('P016')
+******************************************************
+
+
+V4L2_PIX_FMT_P016
+Formats with ½ horizontal and vertical chroma resolution. One luminance and
+one chrominance plane with alternating
+chroma samples as simliar to ``V4L2_PIX_FMT_NV12``
+
+
+Description
+===========
+
+It is a two-plane versions of the YUV 4:2:0 format. The three
+components are separated into two sub-images or planes. The Y plane is
+first. The Y plane has 16 bits per pixel. For ``V4L2_PIX_FMT_P016``, a
+combined CbCr plane immediately follows the Y plane in memory. The CbCr
+plane is the same width, in bytes, as the Y plane (and of the image),
+but is half as tall in pixels. Each CbCr pair belongs to four pixels.
+For example, Cb\ :sub:`0`/Cr\ :sub:`0` belongs to Y'\ :sub:`00`,
+Y'\ :sub:`01`, Y'\ :sub:`10`, Y'\ :sub:`11`.
+If the Y plane has pad bytes after each row, then the CbCr plane has as
+many pad bytes after its rows.
+
+**Byte Order.**
+Each cell is two bytes.
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+    * - start + 0:
+      - Y'\ :sub:`00`
+      - Y'\ :sub:`01`
+      - Y'\ :sub:`02`
+      - Y'\ :sub:`03`
+    * - start + 4:
+      - Y'\ :sub:`10`
+      - Y'\ :sub:`11`
+      - Y'\ :sub:`12`
+      - Y'\ :sub:`13`
+    * - start + 8:
+      - Y'\ :sub:`20`
+      - Y'\ :sub:`21`
+      - Y'\ :sub:`22`
+      - Y'\ :sub:`23`
+    * - start + 12:
+      - Y'\ :sub:`30`
+      - Y'\ :sub:`31`
+      - Y'\ :sub:`32`
+      - Y'\ :sub:`33`
+    * - start + 16:
+      - Cb\ :sub:`00`
+      - Cr\ :sub:`00`
+      - Cb\ :sub:`01`
+      - Cr\ :sub:`01`
+    * - start + 20:
+      - Cb\ :sub:`10`
+      - Cr\ :sub:`10`
+      - Cb\ :sub:`11`
+      - Cr\ :sub:`11`
+
+
+
+**Color Sample Location..**
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+    * -
+      - 0
+      -
+      - 1
+      - 2
+      -
+      - 3
+    * - 0
+      - Y
+      -
+      - Y
+      - Y
+      -
+      - Y
+    * -
+      -
+      - C
+      -
+      -
+      - C
+      -
+    * - 1
+      - Y
+      -
+      - Y
+      - Y
+      -
+      - Y
+    * -
+    * - 2
+      - Y
+      -
+      - Y
+      - Y
+      -
+      - Y
+    * -
+      -
+      - C
+      -
+      -
+      - C
+      -
+    * - 3
+      - Y
+      -
+      - Y
+      - Y
+      -
+      - Y
diff --git a/Documentation/media/uapi/v4l/pixfmt-p016m.rst b/Documentation/media/uapi/v4l/pixfmt-p016m.rst
new file mode 100644
index 0000000..ff2a554
--- /dev/null
+++ b/Documentation/media/uapi/v4l/pixfmt-p016m.rst
@@ -0,0 +1,136 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _V4L2-PIX-FMT-P016M:
+
+***********************************************************************************
+V4L2_PIX_FMT_P016 ('P016')
+***********************************************************************************
+
+
+V4L2_PIX_FMT_P016M
+Variation of ``V4L2_PIX_FMT_P016`` with planes non contiguous in memory.
+
+
+Description
+===========
+
+This is a multi-planar, two-plane version of the YUV 4:2:0 format. The
+three components are separated into two sub-images or planes.
+``V4L2_PIX_FMT_P016M`` differs from ``V4L2_PIX_FMT_P016`` in that the
+two planes are non-contiguous in memory, i.e. the chroma plane do not
+necessarily immediately follows the luma plane. The luminance data
+occupies the first plane. The Y plane has one byte per pixel. In the
+second plane there is a chrominance data with alternating chroma
+samples. The CbCr plane is the same width, in bytes, as the Y plane (and
+of the image), but is half as tall in pixels. Each CbCr pair belongs to
+four pixels. For example, Cb\ :sub:`0`/Cr\ :sub:`0` belongs to
+Y'\ :sub:`00`, Y'\ :sub:`01`, Y'\ :sub:`10`, Y'\ :sub:`11`.
+
+``V4L2_PIX_FMT_P016M`` is intended to be used only in drivers and
+applications that support the multi-planar API, described in
+:ref:`planar-apis`.
+
+If the Y plane has pad bytes after each row, then the CbCr plane has as
+many pad bytes after its rows.
+
+
+**Byte Order.**
+Each cell is two bytes.
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+    * - start0 + 0:
+      - Y'\ :sub:`00`
+      - Y'\ :sub:`01`
+      - Y'\ :sub:`02`
+      - Y'\ :sub:`03`
+    * - start0 + 4:
+      - Y'\ :sub:`10`
+      - Y'\ :sub:`11`
+      - Y'\ :sub:`12`
+      - Y'\ :sub:`13`
+    * - start0 + 8:
+      - Y'\ :sub:`20`
+      - Y'\ :sub:`21`
+      - Y'\ :sub:`22`
+      - Y'\ :sub:`23`
+    * - start0 + 12:
+      - Y'\ :sub:`30`
+      - Y'\ :sub:`31`
+      - Y'\ :sub:`32`
+      - Y'\ :sub:`33`
+    * -
+    * - start1 + 0:
+      - Cb\ :sub:`00`
+      - Cr\ :sub:`00`
+      - Cb\ :sub:`01`
+      - Cr\ :sub:`01`
+    * - start1 + 4:
+      - Cb\ :sub:`10`
+      - Cr\ :sub:`10`
+      - Cb\ :sub:`11`
+      - Cr\ :sub:`11`
+
+
+
+**Color Sample Location..**
+
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+    * -
+      - 0
+      -
+      - 1
+      - 2
+      -
+      - 3
+    * - 0
+      - Y
+      -
+      - Y
+      - Y
+      -
+      - Y
+    * -
+      -
+      - C
+      -
+      -
+      - C
+      -
+    * - 1
+      - Y
+      -
+      - Y
+      - Y
+      -
+      - Y
+    * -
+    * - 2
+      - Y
+      -
+      - Y
+      - Y
+      -
+      - Y
+    * -
+      -
+      - C
+      -
+      -
+      -
+      - C
+      -
+    * - 3
+      - Y
+      -
+      - Y
+      - Y
+      -
+      - Y
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 46e8a2e3..43b61f3 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -551,6 +551,8 @@ struct v4l2_pix_format {
 #define V4L2_PIX_FMT_NV61    v4l2_fourcc('N', 'V', '6', '1') /* 16  Y/CrCb 4:2:2  */
 #define V4L2_PIX_FMT_NV24    v4l2_fourcc('N', 'V', '2', '4') /* 24  Y/CbCr 4:4:4  */
 #define V4L2_PIX_FMT_NV42    v4l2_fourcc('N', 'V', '4', '2') /* 24  Y/CrCb 4:4:4  */
+#define V4L2_PIX_FMT_P010    v4l2_fourcc('P', '0', '1', '0') /* 20  Y/CbCr 4:2:0, 10 bits per channel */
+#define V4L2_PIX_FMT_P016    v4l2_fourcc('P', '0', '1', '6') /* 32  Y/CbCr 4:2:0, 16 bits per channel */
 
 /* two non contiguous planes - one Y, one Cr + Cb interleaved  */
 #define V4L2_PIX_FMT_NV12M   v4l2_fourcc('N', 'M', '1', '2') /* 12  Y/CbCr 4:2:0  */
@@ -559,6 +561,8 @@ struct v4l2_pix_format {
 #define V4L2_PIX_FMT_NV61M   v4l2_fourcc('N', 'M', '6', '1') /* 16  Y/CrCb 4:2:2  */
 #define V4L2_PIX_FMT_NV12MT  v4l2_fourcc('T', 'M', '1', '2') /* 12  Y/CbCr 4:2:0 64x32 macroblocks */
 #define V4L2_PIX_FMT_NV12MT_16X16 v4l2_fourcc('V', 'M', '1', '2') /* 12  Y/CbCr 4:2:0 16x16 macroblocks */
+#define V4L2_PIX_FMT_P010M   v4l2_fourcc('P', 'M', '1', '0') /* 20  Y/CbCr 4:2:0, 10 bits per channel */
+#define V4L2_PIX_FMT_P016M   v4l2_fourcc('P', 'M', '1', '6') /* 32  Y/CbCr 4:2:0, 16 bits per channel */
 
 /* three planes - Y Cb, Cr */
 #define V4L2_PIX_FMT_YUV410  v4l2_fourcc('Y', 'U', 'V', '9') /*  9  YUV 4:1:0     */
-- 
2.7.4

