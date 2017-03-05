Return-path: <linux-media-owner@vger.kernel.org>
Received: from kozue.soulik.info ([108.61.200.231]:39146 "EHLO
        kozue.soulik.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751124AbdCEKAr (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 5 Mar 2017 05:00:47 -0500
From: Randy Li <ayaka@soulik.info>
To: dri-devel@lists.freedesktop.org
Cc: clinton.a.taylor@intel.com, daniel@fooishbar.org,
        ville.syrjala@linux.intel.com, linux-media@vger.kernel.org,
        mchehab@kernel.org, linux-kernel@vger.kernel.org,
        Randy Li <ayaka@soulik.info>
Subject: [PATCH v6 2/3] v4l: Add 10/16-bits per channel YUV pixel formats
Date: Sun,  5 Mar 2017 18:00:32 +0800
Message-Id: <1488708033-5691-3-git-send-email-ayaka@soulik.info>
In-Reply-To: <1488708033-5691-1-git-send-email-ayaka@soulik.info>
References: <1488708033-5691-1-git-send-email-ayaka@soulik.info>
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
Currently, none of driver uses those format.

Also a variant of V4L2_PIX_FMT_P010M pixel format is added.
The V4L2_PIX_FMT_P010CM is a compat variant of the V4L2_PIX_FMT_P010,
which uses the unused 6 bits to store the next pixel. And with
the alignment requirement of the hardware, it usually would be
some extra space left at the end of a stride.

Signed-off-by: Randy Li <ayaka@soulik.info>
---
 Documentation/media/uapi/v4l/pixfmt-p010.rst  | 126 ++++++++++++++++++++++++
 Documentation/media/uapi/v4l/pixfmt-p010m.rst | 135 ++++++++++++++++++++++++++
 Documentation/media/uapi/v4l/pixfmt-p016.rst  | 125 ++++++++++++++++++++++++
 Documentation/media/uapi/v4l/pixfmt-p016m.rst | 134 +++++++++++++++++++++++++
 Documentation/media/uapi/v4l/yuv-formats.rst  |   4 +
 include/uapi/linux/videodev2.h                |   5 +
 6 files changed, 529 insertions(+)
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-p010.rst
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-p010m.rst
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-p016.rst
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-p016m.rst

diff --git a/Documentation/media/uapi/v4l/pixfmt-p010.rst b/Documentation/media/uapi/v4l/pixfmt-p010.rst
new file mode 100644
index 0000000..59ed118
--- /dev/null
+++ b/Documentation/media/uapi/v4l/pixfmt-p010.rst
@@ -0,0 +1,126 @@
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
+first. The Y plane has 16 bits per pixel, but only 10 bits are used with the
+rest 6 bits set to zero. For ``V4L2_PIX_FMT_P010``, a combined CbCr plane
+immediately follows the Y plane in memory. The CbCr
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
index 0000000..6697d15
--- /dev/null
+++ b/Documentation/media/uapi/v4l/pixfmt-p010m.rst
@@ -0,0 +1,135 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _V4L2-PIX-FMT-P010M:
+
+***********************************************************************************
+V4L2_PIX_FMT_P010M ('PM10')
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
+occupies the first plane. The Y plane has 16 bits per pixel, but only
+10 bits are used with the rest 6 bits set to zero. In the
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
index 0000000..a6d60b3
--- /dev/null
+++ b/Documentation/media/uapi/v4l/pixfmt-p016.rst
@@ -0,0 +1,125 @@
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
index 0000000..14c434d
--- /dev/null
+++ b/Documentation/media/uapi/v4l/pixfmt-p016m.rst
@@ -0,0 +1,134 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _V4L2-PIX-FMT-P016M:
+
+***********************************************************************************
+V4L2_PIX_FMT_P016M ('PM16')
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
+occupies the first plane. The Y plane has 16 bits per pixel. In the
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
diff --git a/Documentation/media/uapi/v4l/yuv-formats.rst b/Documentation/media/uapi/v4l/yuv-formats.rst
index 3334ea4..1474192 100644
--- a/Documentation/media/uapi/v4l/yuv-formats.rst
+++ b/Documentation/media/uapi/v4l/yuv-formats.rst
@@ -53,3 +53,7 @@ to brightness information.
     pixfmt-nv16m
     pixfmt-nv24
     pixfmt-m420
+    pixfmt-p010
+    pixfmt-p010m
+    pixfmt-p016
+    pixfmt-p016m
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 45184a2..d2f2013 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -550,6 +550,8 @@ struct v4l2_pix_format {
 #define V4L2_PIX_FMT_NV61    v4l2_fourcc('N', 'V', '6', '1') /* 16  Y/CrCb 4:2:2  */
 #define V4L2_PIX_FMT_NV24    v4l2_fourcc('N', 'V', '2', '4') /* 24  Y/CbCr 4:4:4  */
 #define V4L2_PIX_FMT_NV42    v4l2_fourcc('N', 'V', '4', '2') /* 24  Y/CrCb 4:4:4  */
+#define V4L2_PIX_FMT_P010    v4l2_fourcc('P', '0', '1', '0') /* 20  Y/CbCr 4:2:0, 10 bits per channel */
+#define V4L2_PIX_FMT_P016    v4l2_fourcc('P', '0', '1', '6') /* 32  Y/CbCr 4:2:0, 16 bits per channel */
 
 /* two non contiguous planes - one Y, one Cr + Cb interleaved  */
 #define V4L2_PIX_FMT_NV12M   v4l2_fourcc('N', 'M', '1', '2') /* 12  Y/CbCr 4:2:0  */
@@ -558,6 +560,9 @@ struct v4l2_pix_format {
 #define V4L2_PIX_FMT_NV61M   v4l2_fourcc('N', 'M', '6', '1') /* 16  Y/CrCb 4:2:2  */
 #define V4L2_PIX_FMT_NV12MT  v4l2_fourcc('T', 'M', '1', '2') /* 12  Y/CbCr 4:2:0 64x32 macroblocks */
 #define V4L2_PIX_FMT_NV12MT_16X16 v4l2_fourcc('V', 'M', '1', '2') /* 12  Y/CbCr 4:2:0 16x16 macroblocks */
+#define V4L2_PIX_FMT_P010M   v4l2_fourcc('P', 'M', '1', '0') /* 32  Y/CbCr 4:2:0, 10 bits per channel */
+#define V4L2_PIX_FMT_P016M   v4l2_fourcc('P', 'M', '1', '6') /* 32  Y/CbCr 4:2:0, 16 bits per channel */
+#define V4L2_PIX_FMT_P010CM  v4l2_fourcc('C', 'M', '1', '0') /* 20  Y/CbCr 4:2:0, 10 bits per channel, compact format  */
 
 /* three planes - Y Cb, Cr */
 #define V4L2_PIX_FMT_YUV410  v4l2_fourcc('Y', 'U', 'V', '9') /*  9  YUV 4:1:0     */
-- 
2.7.4
