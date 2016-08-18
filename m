Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:57566 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754702AbcHSDar (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 Aug 2016 23:30:47 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Markus Heiser <markus.heiser@darmarit.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Markus Heiser <markus.heiser@darmarIT.de>
Subject: [PATCH 09/20] [media] docs-rst: remove width hints from pixfmt byte order tables
Date: Thu, 18 Aug 2016 13:15:38 -0300
Message-Id: <e8285b0895f52e5c297ed12727d8958bff58e9ef.1471532123.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471532122.git.mchehab@s-opensource.com>
References: <cover.1471532122.git.mchehab@s-opensource.com>
MIME-Version: 1.0
In-Reply-To: <cover.1471532122.git.mchehab@s-opensource.com>
References: <cover.1471532122.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=true
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Those hints are wrong, and doesn't really improve the look
of those tables. So, keep them only when they're useful.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/v4l/pixfmt-grey.rst         |  7 -------
 Documentation/media/uapi/v4l/pixfmt-m420.rst         |  6 ------
 Documentation/media/uapi/v4l/pixfmt-nv12.rst         |  6 ------
 Documentation/media/uapi/v4l/pixfmt-nv12m.rst        |  5 -----
 Documentation/media/uapi/v4l/pixfmt-nv12mt.rst       |  2 --
 Documentation/media/uapi/v4l/pixfmt-nv16.rst         |  7 -------
 Documentation/media/uapi/v4l/pixfmt-nv16m.rst        |  7 -------
 Documentation/media/uapi/v4l/pixfmt-nv24.rst         |  7 -------
 Documentation/media/uapi/v4l/pixfmt-sbggr16.rst      |  8 --------
 Documentation/media/uapi/v4l/pixfmt-sbggr8.rst       |  6 ------
 Documentation/media/uapi/v4l/pixfmt-sdr-cs08.rst     |  7 -------
 Documentation/media/uapi/v4l/pixfmt-sdr-cs14le.rst   |  7 -------
 Documentation/media/uapi/v4l/pixfmt-sdr-cu08.rst     |  8 --------
 Documentation/media/uapi/v4l/pixfmt-sdr-cu16le.rst   |  6 ------
 Documentation/media/uapi/v4l/pixfmt-sdr-ru12le.rst   |  3 ---
 Documentation/media/uapi/v4l/pixfmt-sgbrg8.rst       |  3 ---
 Documentation/media/uapi/v4l/pixfmt-sgrbg8.rst       |  3 ---
 Documentation/media/uapi/v4l/pixfmt-srggb10.rst      |  3 ---
 Documentation/media/uapi/v4l/pixfmt-srggb10alaw8.rst |  2 --
 Documentation/media/uapi/v4l/pixfmt-srggb10p.rst     | 12 ++++++++----
 Documentation/media/uapi/v4l/pixfmt-srggb12.rst      |  3 ---
 Documentation/media/uapi/v4l/pixfmt-srggb8.rst       |  3 ---
 Documentation/media/uapi/v4l/pixfmt-uv8.rst          |  3 ---
 Documentation/media/uapi/v4l/pixfmt-uyvy.rst         |  3 ---
 Documentation/media/uapi/v4l/pixfmt-vyuy.rst         |  3 ---
 Documentation/media/uapi/v4l/pixfmt-y10.rst          |  3 ---
 Documentation/media/uapi/v4l/pixfmt-y10b.rst         |  8 --------
 Documentation/media/uapi/v4l/pixfmt-y12.rst          |  3 ---
 Documentation/media/uapi/v4l/pixfmt-y12i.rst         |  5 -----
 Documentation/media/uapi/v4l/pixfmt-y16-be.rst       |  3 ---
 Documentation/media/uapi/v4l/pixfmt-y16.rst          |  3 ---
 Documentation/media/uapi/v4l/pixfmt-y41p.rst         |  3 ---
 Documentation/media/uapi/v4l/pixfmt-y8i.rst          |  3 ---
 Documentation/media/uapi/v4l/pixfmt-yuv410.rst       |  3 ---
 Documentation/media/uapi/v4l/pixfmt-yuv411p.rst      |  3 ---
 Documentation/media/uapi/v4l/pixfmt-yuv420.rst       |  3 ---
 Documentation/media/uapi/v4l/pixfmt-yuv420m.rst      |  3 ---
 Documentation/media/uapi/v4l/pixfmt-yuv422m.rst      |  3 ---
 Documentation/media/uapi/v4l/pixfmt-yuv422p.rst      |  3 ---
 Documentation/media/uapi/v4l/pixfmt-yuv444m.rst      |  3 ---
 Documentation/media/uapi/v4l/pixfmt-yuyv.rst         |  3 ---
 Documentation/media/uapi/v4l/pixfmt-yvyu.rst         |  3 ---
 Documentation/media/uapi/v4l/pixfmt-z16.rst          |  3 ---
 43 files changed, 8 insertions(+), 183 deletions(-)

diff --git a/Documentation/media/uapi/v4l/pixfmt-grey.rst b/Documentation/media/uapi/v4l/pixfmt-grey.rst
index 844fb67320be..fef58ca50f66 100644
--- a/Documentation/media/uapi/v4l/pixfmt-grey.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-grey.rst
@@ -6,8 +6,6 @@
 V4L2_PIX_FMT_GREY ('GREY')
 **************************
 
-*man V4L2_PIX_FMT_GREY(2)*
-
 Grey-scale image
 
 
@@ -20,14 +18,9 @@ which simply contains no Cb or Cr data.
 **Byte Order.**
 Each cell is one byte.
 
-
-
-.. tabularcolumns:: |p{5.8cm}|p{2.9cm}|p{2.9cm}|p{2.9cm}|p{3.0cm}|
-
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
-    :widths:       2 1 1 1 1
 
 
     -  .. row 1
diff --git a/Documentation/media/uapi/v4l/pixfmt-m420.rst b/Documentation/media/uapi/v4l/pixfmt-m420.rst
index ff0ed7abfef3..f4a21a8a6dcc 100644
--- a/Documentation/media/uapi/v4l/pixfmt-m420.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-m420.rst
@@ -6,8 +6,6 @@
 V4L2_PIX_FMT_M420 ('M420')
 **************************
 
-*man V4L2_PIX_FMT_M420(2)*
-
 Format with ½ horizontal and vertical chroma resolution, also known as
 YUV 4:2:0. Hybrid plane line-interleaved layout.
 
@@ -32,13 +30,9 @@ the CbCr lines.
 Each cell is one byte.
 
 
-
-.. tabularcolumns:: |p{5.8cm}|p{2.9cm}|p{2.9cm}|p{2.9cm}|p{3.0cm}|
-
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
-    :widths:       2 1 1 1 1
 
 
     -  .. row 1
diff --git a/Documentation/media/uapi/v4l/pixfmt-nv12.rst b/Documentation/media/uapi/v4l/pixfmt-nv12.rst
index a5b70b8a1273..6bbdc01362af 100644
--- a/Documentation/media/uapi/v4l/pixfmt-nv12.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-nv12.rst
@@ -7,7 +7,6 @@
 V4L2_PIX_FMT_NV12 ('NV12'), V4L2_PIX_FMT_NV21 ('NV21')
 ******************************************************
 
-*man V4L2_PIX_FMT_NV12(2)*
 
 V4L2_PIX_FMT_NV21
 Formats with ½ horizontal and vertical chroma resolution, also known as
@@ -36,14 +35,9 @@ many pad bytes after its rows.
 Each cell is one byte.
 
 
-
-.. tabularcolumns:: |p{5.8cm}|p{2.9cm}|p{2.9cm}|p{2.9cm}|p{3.0cm}|
-
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
-    :widths:       2 1 1 1 1
-
 
     -  .. row 1
 
diff --git a/Documentation/media/uapi/v4l/pixfmt-nv12m.rst b/Documentation/media/uapi/v4l/pixfmt-nv12m.rst
index cdc24109fdf7..5c2e0648204b 100644
--- a/Documentation/media/uapi/v4l/pixfmt-nv12m.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-nv12m.rst
@@ -8,7 +8,6 @@
 V4L2_PIX_FMT_NV12M ('NM12'), V4L2_PIX_FMT_NV21M ('NM21'), V4L2_PIX_FMT_NV12MT_16X16
 ***********************************************************************************
 
-*man V4L2_PIX_FMT_NV12M(2)*
 
 V4L2_PIX_FMT_NV21M
 V4L2_PIX_FMT_NV12MT_16X16
@@ -47,13 +46,9 @@ many pad bytes after its rows.
 **Byte Order.**
 Each cell is one byte.
 
-.. tabularcolumns:: |p{5.8cm}|p{2.9cm}|p{2.9cm}|p{2.9cm}|p{3.0cm}|
-
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
-    :widths:       2 1 1 1 1
-
 
     -  .. row 1
 
diff --git a/Documentation/media/uapi/v4l/pixfmt-nv12mt.rst b/Documentation/media/uapi/v4l/pixfmt-nv12mt.rst
index 1e6fdf0194f5..9f250a1df2f6 100644
--- a/Documentation/media/uapi/v4l/pixfmt-nv12mt.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-nv12mt.rst
@@ -6,8 +6,6 @@
 V4L2_PIX_FMT_NV12MT ('TM12')
 ****************************
 
-*man V4L2_PIX_FMT_NV12MT(2)*
-
 Formats with ½ horizontal and vertical chroma resolution. This format
 has two planes - one for luminance and one for chrominance. Chroma
 samples are interleaved. The difference to ``V4L2_PIX_FMT_NV12`` is the
diff --git a/Documentation/media/uapi/v4l/pixfmt-nv16.rst b/Documentation/media/uapi/v4l/pixfmt-nv16.rst
index 2cbdc1e6a36d..e2ea0fcdccc7 100644
--- a/Documentation/media/uapi/v4l/pixfmt-nv16.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-nv16.rst
@@ -7,8 +7,6 @@
 V4L2_PIX_FMT_NV16 ('NV16'), V4L2_PIX_FMT_NV61 ('NV61')
 ******************************************************
 
-*man V4L2_PIX_FMT_NV16(2)*
-
 V4L2_PIX_FMT_NV61
 Formats with ½ horizontal chroma resolution, also known as YUV 4:2:2.
 One luminance and one chrominance plane with alternating chroma samples
@@ -35,14 +33,9 @@ many pad bytes after its rows.
 Each cell is one byte.
 
 
-
-.. tabularcolumns:: |p{5.8cm}|p{2.9cm}|p{2.9cm}|p{2.9cm}|p{3.0cm}|
-
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
-    :widths:       2 1 1 1 1
-
 
     -  .. row 1
 
diff --git a/Documentation/media/uapi/v4l/pixfmt-nv16m.rst b/Documentation/media/uapi/v4l/pixfmt-nv16m.rst
index 98cc0550bf26..5908b0437697 100644
--- a/Documentation/media/uapi/v4l/pixfmt-nv16m.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-nv16m.rst
@@ -7,8 +7,6 @@
 V4L2_PIX_FMT_NV16M ('NM16'), V4L2_PIX_FMT_NV61M ('NM61')
 ********************************************************
 
-*man V4L2_PIX_FMT_NV16M(2)*
-
 V4L2_PIX_FMT_NV61M
 Variation of ``V4L2_PIX_FMT_NV16`` and ``V4L2_PIX_FMT_NV61`` with planes
 non contiguous in memory.
@@ -38,14 +36,9 @@ described in :ref:`planar-apis`.
 Each cell is one byte.
 
 
-
-.. tabularcolumns:: |p{5.8cm}|p{2.9cm}|p{2.9cm}|p{2.9cm}|p{3.0cm}|
-
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
-    :widths:       2 1 1 1 1
-
 
     -  .. row 1
 
diff --git a/Documentation/media/uapi/v4l/pixfmt-nv24.rst b/Documentation/media/uapi/v4l/pixfmt-nv24.rst
index ebc27b772a38..67f3c53ac48d 100644
--- a/Documentation/media/uapi/v4l/pixfmt-nv24.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-nv24.rst
@@ -7,8 +7,6 @@
 V4L2_PIX_FMT_NV24 ('NV24'), V4L2_PIX_FMT_NV42 ('NV42')
 ******************************************************
 
-*man V4L2_PIX_FMT_NV24(2)*
-
 V4L2_PIX_FMT_NV42
 Formats with full horizontal and vertical chroma resolutions, also known
 as YUV 4:4:4. One luminance and one chrominance plane with alternating
@@ -35,14 +33,9 @@ twice as many pad bytes after its rows.
 Each cell is one byte.
 
 
-
-.. tabularcolumns:: |p{3.5cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.4cm}|
-
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
-    :widths:       2 1 1 1 1 1 1 1 1
-
 
     -  .. row 1
 
diff --git a/Documentation/media/uapi/v4l/pixfmt-sbggr16.rst b/Documentation/media/uapi/v4l/pixfmt-sbggr16.rst
index c2224c455e8a..58238c06f11e 100644
--- a/Documentation/media/uapi/v4l/pixfmt-sbggr16.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-sbggr16.rst
@@ -6,8 +6,6 @@
 V4L2_PIX_FMT_SBGGR16 ('BYR2')
 *****************************
 
-*man V4L2_PIX_FMT_SBGGR16(2)*
-
 Bayer RGB format
 
 
@@ -27,15 +25,9 @@ memory addresses (little-endian).
 **Byte Order.**
 Each cell is one byte.
 
-
-
-.. tabularcolumns:: |p{3.5cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.4cm}|
-
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
-    :widths:       2 1 1 1 1 1 1 1 1
-
 
     -  .. row 1
 
diff --git a/Documentation/media/uapi/v4l/pixfmt-sbggr8.rst b/Documentation/media/uapi/v4l/pixfmt-sbggr8.rst
index 0a65450e017e..e880ba09379c 100644
--- a/Documentation/media/uapi/v4l/pixfmt-sbggr8.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-sbggr8.rst
@@ -6,8 +6,6 @@
 V4L2_PIX_FMT_SBGGR8 ('BA81')
 ****************************
 
-*man V4L2_PIX_FMT_SBGGR8(2)*
-
 Bayer RGB format
 
 
@@ -25,13 +23,9 @@ scheme repeats to the right and down for every two columns and rows.
 Each cell is one byte.
 
 
-
-.. tabularcolumns:: |p{5.8cm}|p{2.9cm}|p{2.9cm}|p{2.9cm}|p{3.0cm}|
-
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
-    :widths:       2 1 1 1 1
 
 
     -  .. row 1
diff --git a/Documentation/media/uapi/v4l/pixfmt-sdr-cs08.rst b/Documentation/media/uapi/v4l/pixfmt-sdr-cs08.rst
index 48c2469ddd19..82b9995155fa 100644
--- a/Documentation/media/uapi/v4l/pixfmt-sdr-cs08.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-sdr-cs08.rst
@@ -6,8 +6,6 @@
 V4L2_SDR_FMT_CS8 ('CS08')
 *************************
 
-*man V4L2_SDR_FMT_CS8(2)*
-
 Complex signed 8-bit IQ sample
 
 
@@ -22,14 +20,9 @@ Q value after that.
 **Byte Order.**
 Each cell is one byte.
 
-
-
-.. tabularcolumns:: |p{11.7cm}|p{5.8cm}|
-
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
-    :widths:       2 1
 
 
     -  .. row 1
diff --git a/Documentation/media/uapi/v4l/pixfmt-sdr-cs14le.rst b/Documentation/media/uapi/v4l/pixfmt-sdr-cs14le.rst
index d8d7fd3f0ec2..f06cbeb15dc2 100644
--- a/Documentation/media/uapi/v4l/pixfmt-sdr-cs14le.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-sdr-cs14le.rst
@@ -6,8 +6,6 @@
 V4L2_SDR_FMT_CS14LE ('CS14')
 ****************************
 
-*man V4L2_SDR_FMT_CS14LE(2)*
-
 Complex signed 14-bit little endian IQ sample
 
 
@@ -24,14 +22,9 @@ space with unused high bits padded with 0.
 Each cell is one byte.
 
 
-
-.. tabularcolumns:: |p{8.8cm}|p{4.4cm}|p{4.3cm}|
-
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
-    :widths:       2 1 1
-
 
     -  .. row 1
 
diff --git a/Documentation/media/uapi/v4l/pixfmt-sdr-cu08.rst b/Documentation/media/uapi/v4l/pixfmt-sdr-cu08.rst
index 1b7eaf652604..bd81eb2e0549 100644
--- a/Documentation/media/uapi/v4l/pixfmt-sdr-cu08.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-sdr-cu08.rst
@@ -6,8 +6,6 @@
 V4L2_SDR_FMT_CU8 ('CU08')
 *************************
 
-*man V4L2_SDR_FMT_CU8(2)*
-
 Complex unsigned 8-bit IQ sample
 
 
@@ -22,15 +20,9 @@ and Q value after that.
 **Byte Order.**
 Each cell is one byte.
 
-
-
-.. tabularcolumns:: |p{11.7cm}|p{5.8cm}|
-
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
-    :widths:       2 1
-
 
     -  .. row 1
 
diff --git a/Documentation/media/uapi/v4l/pixfmt-sdr-cu16le.rst b/Documentation/media/uapi/v4l/pixfmt-sdr-cu16le.rst
index e12d267423c4..c72587de4a8d 100644
--- a/Documentation/media/uapi/v4l/pixfmt-sdr-cu16le.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-sdr-cu16le.rst
@@ -6,7 +6,6 @@
 V4L2_SDR_FMT_CU16LE ('CU16')
 ****************************
 
-*man V4L2_SDR_FMT_CU16LE(2)*
 
 Complex unsigned 16-bit little endian IQ sample
 
@@ -23,14 +22,9 @@ comes first and Q value after that.
 Each cell is one byte.
 
 
-
-.. tabularcolumns:: |p{8.8cm}|p{4.4cm}|p{4.3cm}|
-
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
-    :widths:       2 1 1
-
 
     -  .. row 1
 
diff --git a/Documentation/media/uapi/v4l/pixfmt-sdr-ru12le.rst b/Documentation/media/uapi/v4l/pixfmt-sdr-ru12le.rst
index 802aefe44b16..b5f0ca0f0c45 100644
--- a/Documentation/media/uapi/v4l/pixfmt-sdr-ru12le.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-sdr-ru12le.rst
@@ -6,7 +6,6 @@
 V4L2_SDR_FMT_RU12LE ('RU12')
 ****************************
 
-*man V4L2_SDR_FMT_RU12LE(2)*
 
 Real unsigned 12-bit little endian sample
 
@@ -23,12 +22,10 @@ Each cell is one byte.
 
 
 
-.. tabularcolumns:: |p{8.8cm}|p{4.4cm}|p{4.3cm}|
 
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
-    :widths:       2 1 1
 
 
     -  .. row 1
diff --git a/Documentation/media/uapi/v4l/pixfmt-sgbrg8.rst b/Documentation/media/uapi/v4l/pixfmt-sgbrg8.rst
index faad9b19dadd..5cd40d611d68 100644
--- a/Documentation/media/uapi/v4l/pixfmt-sgbrg8.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-sgbrg8.rst
@@ -6,7 +6,6 @@
 V4L2_PIX_FMT_SGBRG8 ('GBRG')
 ****************************
 
-*man V4L2_PIX_FMT_SGBRG8(2)*
 
 Bayer RGB format
 
@@ -26,12 +25,10 @@ Each cell is one byte.
 
 
 
-.. tabularcolumns:: |p{5.8cm}|p{2.9cm}|p{2.9cm}|p{2.9cm}|p{3.0cm}|
 
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
-    :widths:       2 1 1 1 1
 
 
     -  .. row 1
diff --git a/Documentation/media/uapi/v4l/pixfmt-sgrbg8.rst b/Documentation/media/uapi/v4l/pixfmt-sgrbg8.rst
index 33a7c4fdf046..05a09dbac494 100644
--- a/Documentation/media/uapi/v4l/pixfmt-sgrbg8.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-sgrbg8.rst
@@ -6,7 +6,6 @@
 V4L2_PIX_FMT_SGRBG8 ('GRBG')
 ****************************
 
-*man V4L2_PIX_FMT_SGRBG8(2)*
 
 Bayer RGB format
 
@@ -26,12 +25,10 @@ Each cell is one byte.
 
 
 
-.. tabularcolumns:: |p{5.8cm}|p{2.9cm}|p{2.9cm}|p{2.9cm}|p{3.0cm}|
 
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
-    :widths:       2 1 1 1 1
 
 
     -  .. row 1
diff --git a/Documentation/media/uapi/v4l/pixfmt-srggb10.rst b/Documentation/media/uapi/v4l/pixfmt-srggb10.rst
index 6a32ecb7f9ad..8af756944fd4 100644
--- a/Documentation/media/uapi/v4l/pixfmt-srggb10.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-srggb10.rst
@@ -9,7 +9,6 @@
 V4L2_PIX_FMT_SRGGB10 ('RG10'), V4L2_PIX_FMT_SGRBG10 ('BA10'), V4L2_PIX_FMT_SGBRG10 ('GB10'), V4L2_PIX_FMT_SBGGR10 ('BG10'),
 ***************************************************************************************************************************
 
-*man V4L2_PIX_FMT_SRGGB10(2)*
 
 V4L2_PIX_FMT_SGRBG10
 V4L2_PIX_FMT_SGBRG10
@@ -33,12 +32,10 @@ Each cell is one byte, high 6 bits in high bytes are 0.
 
 
 
-.. tabularcolumns:: |p{3.5cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.4cm}|
 
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
-    :widths:       2 1 1 1 1 1 1 1 1
 
 
     -  .. row 1
diff --git a/Documentation/media/uapi/v4l/pixfmt-srggb10alaw8.rst b/Documentation/media/uapi/v4l/pixfmt-srggb10alaw8.rst
index 68bae0cb764c..c44e093514de 100644
--- a/Documentation/media/uapi/v4l/pixfmt-srggb10alaw8.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-srggb10alaw8.rst
@@ -9,8 +9,6 @@
 V4L2_PIX_FMT_SBGGR10ALAW8 ('aBA8'), V4L2_PIX_FMT_SGBRG10ALAW8 ('aGA8'), V4L2_PIX_FMT_SGRBG10ALAW8 ('agA8'), V4L2_PIX_FMT_SRGGB10ALAW8 ('aRA8'),
 ***********************************************************************************************************************************************
 
-*man V4L2_PIX_FMT_SBGGR10ALAW8(2)*
-
 V4L2_PIX_FMT_SGBRG10ALAW8
 V4L2_PIX_FMT_SGRBG10ALAW8
 V4L2_PIX_FMT_SRGGB10ALAW8
diff --git a/Documentation/media/uapi/v4l/pixfmt-srggb10p.rst b/Documentation/media/uapi/v4l/pixfmt-srggb10p.rst
index b577dbf09a8b..a5752b9063e3 100644
--- a/Documentation/media/uapi/v4l/pixfmt-srggb10p.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-srggb10p.rst
@@ -9,7 +9,6 @@
 V4L2_PIX_FMT_SRGGB10P ('pRAA'), V4L2_PIX_FMT_SGRBG10P ('pgAA'), V4L2_PIX_FMT_SGBRG10P ('pGAA'), V4L2_PIX_FMT_SBGGR10P ('pBAA'),
 *******************************************************************************************************************************
 
-*man V4L2_PIX_FMT_SRGGB10P(2)*
 
 V4L2_PIX_FMT_SGRBG10P
 V4L2_PIX_FMT_SGBRG10P
@@ -34,15 +33,16 @@ of one of these formats:
 **Byte Order.**
 Each cell is one byte.
 
+.. raw:: latex
 
+    \newline\newline\begin{adjustbox}{width=\columnwidth}
 
-.. tabularcolumns:: |p{5.0cm}|p{2.5cm}|p{2.5cm}|p{2.5cm}|p{2.5cm}|p{2.5cm}|
+.. tabularcolumns:: |p{2.0cm}|p{1.3cm}|p{1.3cm}|p{1.3cm}|p{1.3cm}|p{10.9cm}|
 
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
-    :widths:       2 1 1 1 1 1
-
+    :widths: 12 8 8 8 8 68
 
     -  .. row 1
 
@@ -103,3 +103,7 @@ Each cell is one byte.
 
        -  G\ :sub:`30low`\ (bits 7--6) R\ :sub:`31low`\ (bits 5--4)
 	  G\ :sub:`32low`\ (bits 3--2) R\ :sub:`33low`\ (bits 1--0)
+
+.. raw:: latex
+
+    \end{adjustbox}\newline\newline
diff --git a/Documentation/media/uapi/v4l/pixfmt-srggb12.rst b/Documentation/media/uapi/v4l/pixfmt-srggb12.rst
index 54355af154c8..109772fd0f23 100644
--- a/Documentation/media/uapi/v4l/pixfmt-srggb12.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-srggb12.rst
@@ -10,7 +10,6 @@
 V4L2_PIX_FMT_SRGGB12 ('RG12'), V4L2_PIX_FMT_SGRBG12 ('BA12'), V4L2_PIX_FMT_SGBRG12 ('GB12'), V4L2_PIX_FMT_SBGGR12 ('BG12'),
 ***************************************************************************************************************************
 
-*man V4L2_PIX_FMT_SRGGB12(2)*
 
 V4L2_PIX_FMT_SGRBG12
 V4L2_PIX_FMT_SGBRG12
@@ -34,12 +33,10 @@ Each cell is one byte, high 6 bits in high bytes are 0.
 
 
 
-.. tabularcolumns:: |p{3.5cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.4cm}|
 
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
-    :widths:       2 1 1 1 1 1 1 1 1
 
 
     -  .. row 1
diff --git a/Documentation/media/uapi/v4l/pixfmt-srggb8.rst b/Documentation/media/uapi/v4l/pixfmt-srggb8.rst
index 1a6966b34c6f..41851bbde2cd 100644
--- a/Documentation/media/uapi/v4l/pixfmt-srggb8.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-srggb8.rst
@@ -6,7 +6,6 @@
 V4L2_PIX_FMT_SRGGB8 ('RGGB')
 ****************************
 
-*man V4L2_PIX_FMT_SRGGB8(2)*
 
 Bayer RGB format
 
@@ -26,12 +25,10 @@ Each cell is one byte.
 
 
 
-.. tabularcolumns:: |p{5.8cm}|p{2.9cm}|p{2.9cm}|p{2.9cm}|p{3.0cm}|
 
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
-    :widths:       2 1 1 1 1
 
 
     -  .. row 1
diff --git a/Documentation/media/uapi/v4l/pixfmt-uv8.rst b/Documentation/media/uapi/v4l/pixfmt-uv8.rst
index ab73e0b55d05..8c4ebbf79ca0 100644
--- a/Documentation/media/uapi/v4l/pixfmt-uv8.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-uv8.rst
@@ -6,7 +6,6 @@
 V4L2_PIX_FMT_UV8 ('UV8')
 ************************
 
-*man V4L2_PIX_FMT_UV8(2)*
 
 UV plane interleaved
 
@@ -21,12 +20,10 @@ Each cell is one byte.
 
 
 
-.. tabularcolumns:: |p{5.8cm}|p{2.9cm}|p{2.9cm}|p{2.9cm}|p{3.0cm}|
 
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
-    :widths:       2 1 1 1 1
 
 
     -  .. row 1
diff --git a/Documentation/media/uapi/v4l/pixfmt-uyvy.rst b/Documentation/media/uapi/v4l/pixfmt-uyvy.rst
index 4c0c56003355..ed8ccf52b1db 100644
--- a/Documentation/media/uapi/v4l/pixfmt-uyvy.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-uyvy.rst
@@ -6,7 +6,6 @@
 V4L2_PIX_FMT_UYVY ('UYVY')
 **************************
 
-*man V4L2_PIX_FMT_UYVY(2)*
 
 Variation of ``V4L2_PIX_FMT_YUYV`` with different order of samples in
 memory
@@ -23,12 +22,10 @@ half the horizontal resolution of the Y component.
 **Byte Order.**
 Each cell is one byte.
 
-.. tabularcolumns:: |p{3.5cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.4cm}|
 
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
-    :widths:       2 1 1 1 1 1 1 1 1
 
 
     -  .. row 1
diff --git a/Documentation/media/uapi/v4l/pixfmt-vyuy.rst b/Documentation/media/uapi/v4l/pixfmt-vyuy.rst
index cdebbd3a5ad2..d62c1ac4ed08 100644
--- a/Documentation/media/uapi/v4l/pixfmt-vyuy.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-vyuy.rst
@@ -6,7 +6,6 @@
 V4L2_PIX_FMT_VYUY ('VYUY')
 **************************
 
-*man V4L2_PIX_FMT_VYUY(2)*
 
 Variation of ``V4L2_PIX_FMT_YUYV`` with different order of samples in
 memory
@@ -23,12 +22,10 @@ half the horizontal resolution of the Y component.
 **Byte Order.**
 Each cell is one byte.
 
-.. tabularcolumns:: |p{3.5cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.4cm}|
 
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
-    :widths:       2 1 1 1 1 1 1 1 1
 
 
     -  .. row 1
diff --git a/Documentation/media/uapi/v4l/pixfmt-y10.rst b/Documentation/media/uapi/v4l/pixfmt-y10.rst
index 887e6f052879..cb78e365a84c 100644
--- a/Documentation/media/uapi/v4l/pixfmt-y10.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-y10.rst
@@ -6,7 +6,6 @@
 V4L2_PIX_FMT_Y10 ('Y10 ')
 *************************
 
-*man V4L2_PIX_FMT_Y10(2)*
 
 Grey-scale image
 
@@ -23,12 +22,10 @@ Each cell is one byte.
 
 
 
-.. tabularcolumns:: |p{3.5cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.4cm}|
 
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
-    :widths:       2 1 1 1 1 1 1 1 1
 
 
     -  .. row 1
diff --git a/Documentation/media/uapi/v4l/pixfmt-y10b.rst b/Documentation/media/uapi/v4l/pixfmt-y10b.rst
index 5f5219904a62..e89850bfef58 100644
--- a/Documentation/media/uapi/v4l/pixfmt-y10b.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-y10b.rst
@@ -6,8 +6,6 @@
 V4L2_PIX_FMT_Y10BPACK ('Y10B')
 ******************************
 
-*man V4L2_PIX_FMT_Y10BPACK(2)*
-
 Grey-scale image as a bit-packed array
 
 
@@ -24,15 +22,9 @@ first from the left.
 pixels cross the byte boundary and have a ratio of 5 bytes for each 4
 pixels.
 
-
-
-.. tabularcolumns:: |p{5.8cm}|p{2.9cm}|p{2.9cm}|p{2.9cm}|p{3.0cm}|
-
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
-    :widths:       2 1 1 1 1
-
 
     -  .. row 1
 
diff --git a/Documentation/media/uapi/v4l/pixfmt-y12.rst b/Documentation/media/uapi/v4l/pixfmt-y12.rst
index 6148371909f8..0958e87b6d22 100644
--- a/Documentation/media/uapi/v4l/pixfmt-y12.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-y12.rst
@@ -6,7 +6,6 @@
 V4L2_PIX_FMT_Y12 ('Y12 ')
 *************************
 
-*man V4L2_PIX_FMT_Y12(2)*
 
 Grey-scale image
 
@@ -23,12 +22,10 @@ Each cell is one byte.
 
 
 
-.. tabularcolumns:: |p{3.5cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.4cm}|
 
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
-    :widths:       2 1 1 1 1 1 1 1 1
 
 
     -  .. row 1
diff --git a/Documentation/media/uapi/v4l/pixfmt-y12i.rst b/Documentation/media/uapi/v4l/pixfmt-y12i.rst
index 70f2b2c1f57b..e66d8bcdb410 100644
--- a/Documentation/media/uapi/v4l/pixfmt-y12i.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-y12i.rst
@@ -6,8 +6,6 @@
 V4L2_PIX_FMT_Y12I ('Y12I')
 **************************
 
-*man V4L2_PIX_FMT_Y12I(2)*
-
 Interleaved grey-scale image, e.g. from a stereo-pair
 
 
@@ -29,12 +27,9 @@ these pixels can be deinterlaced using
 pixels cross the byte boundary and have a ratio of 3 bytes for each
 interleaved pixel.
 
-.. tabularcolumns:: |p{8.8cm}|p{4.4cm}|p{4.3cm}|
-
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
-    :widths:       2 1 1
 
 
     -  .. row 1
diff --git a/Documentation/media/uapi/v4l/pixfmt-y16-be.rst b/Documentation/media/uapi/v4l/pixfmt-y16-be.rst
index bc968c246ec5..fc23c6b12193 100644
--- a/Documentation/media/uapi/v4l/pixfmt-y16-be.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-y16-be.rst
@@ -6,7 +6,6 @@
 V4L2_PIX_FMT_Y16_BE ('Y16 ' | (1 << 31))
 ****************************************
 
-*man V4L2_PIX_FMT_Y16_BE(2)*
 
 Grey-scale image
 
@@ -27,12 +26,10 @@ Each cell is one byte.
 
 
 
-.. tabularcolumns:: |p{3.5cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.4cm}|
 
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
-    :widths:       2 1 1 1 1 1 1 1 1
 
 
     -  .. row 1
diff --git a/Documentation/media/uapi/v4l/pixfmt-y16.rst b/Documentation/media/uapi/v4l/pixfmt-y16.rst
index deb59e2a62a7..6b4edc4e34e5 100644
--- a/Documentation/media/uapi/v4l/pixfmt-y16.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-y16.rst
@@ -6,7 +6,6 @@
 V4L2_PIX_FMT_Y16 ('Y16 ')
 *************************
 
-*man V4L2_PIX_FMT_Y16(2)*
 
 Grey-scale image
 
@@ -27,12 +26,10 @@ Each cell is one byte.
 
 
 
-.. tabularcolumns:: |p{3.5cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.4cm}|
 
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
-    :widths:       2 1 1 1 1 1 1 1 1
 
 
     -  .. row 1
diff --git a/Documentation/media/uapi/v4l/pixfmt-y41p.rst b/Documentation/media/uapi/v4l/pixfmt-y41p.rst
index d160e3dc9115..9c3194bbf77e 100644
--- a/Documentation/media/uapi/v4l/pixfmt-y41p.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-y41p.rst
@@ -6,7 +6,6 @@
 V4L2_PIX_FMT_Y41P ('Y41P')
 **************************
 
-*man V4L2_PIX_FMT_Y41P(2)*
 
 Format with ¼ horizontal chroma resolution, also known as YUV 4:1:1
 
@@ -30,12 +29,10 @@ Each cell is one byte.
 
 
 
-.. tabularcolumns:: |p{2.5cm}|p{1.3cm}|p{1.3cm}|p{1.3cm}|p{1.3cm}|p{1.3cm}|p{1.3cm}|p{1.3cm}|p{1.3cm}|p{1.3cm}|p{1.3cm}|p{1.3cm}|p{0.7cm}|
 
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
-    :widths:       2 1 1 1 1 1 1 1 1 1 1 1 1
 
 
     -  .. row 1
diff --git a/Documentation/media/uapi/v4l/pixfmt-y8i.rst b/Documentation/media/uapi/v4l/pixfmt-y8i.rst
index 8b13c7476efb..16bdfbbe6915 100644
--- a/Documentation/media/uapi/v4l/pixfmt-y8i.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-y8i.rst
@@ -6,7 +6,6 @@
 V4L2_PIX_FMT_Y8I ('Y8I ')
 *************************
 
-*man V4L2_PIX_FMT_Y8I(2)*
 
 Interleaved grey-scale image, e.g. from a stereo-pair
 
@@ -24,12 +23,10 @@ Each cell is one byte.
 
 
 
-.. tabularcolumns:: |p{3.5cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.4cm}|
 
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
-    :widths:       2 1 1 1 1 1 1 1 1
 
 
     -  .. row 1
diff --git a/Documentation/media/uapi/v4l/pixfmt-yuv410.rst b/Documentation/media/uapi/v4l/pixfmt-yuv410.rst
index 5d343d99922f..54909839b0d1 100644
--- a/Documentation/media/uapi/v4l/pixfmt-yuv410.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-yuv410.rst
@@ -7,7 +7,6 @@
 V4L2_PIX_FMT_YVU410 ('YVU9'), V4L2_PIX_FMT_YUV410 ('YUV9')
 **********************************************************
 
-*man V4L2_PIX_FMT_YVU410(2)*
 
 V4L2_PIX_FMT_YUV410
 Planar formats with ¼ horizontal and vertical chroma resolution, also
@@ -37,12 +36,10 @@ Each cell is one byte.
 
 
 
-.. tabularcolumns:: |p{5.8cm}|p{2.9cm}|p{2.9cm}|p{2.9cm}|p{3.0cm}|
 
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
-    :widths:       2 1 1 1 1
 
 
     -  .. row 1
diff --git a/Documentation/media/uapi/v4l/pixfmt-yuv411p.rst b/Documentation/media/uapi/v4l/pixfmt-yuv411p.rst
index 13a31d90bf11..913f68fe2536 100644
--- a/Documentation/media/uapi/v4l/pixfmt-yuv411p.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-yuv411p.rst
@@ -6,7 +6,6 @@
 V4L2_PIX_FMT_YUV411P ('411P')
 *****************************
 
-*man V4L2_PIX_FMT_YUV411P(2)*
 
 Format with ¼ horizontal chroma resolution, also known as YUV 4:1:1.
 Planar layout as opposed to ``V4L2_PIX_FMT_Y41P``
@@ -33,12 +32,10 @@ have ¼ as many pad bytes after their rows. In other words, four C x rows
 Each cell is one byte.
 
 
-.. tabularcolumns:: |p{5.8cm}|p{2.9cm}|p{2.9cm}|p{2.9cm}|p{3.0cm}|
 
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
-    :widths:       2 1 1 1 1
 
 
     -  .. row 1
diff --git a/Documentation/media/uapi/v4l/pixfmt-yuv420.rst b/Documentation/media/uapi/v4l/pixfmt-yuv420.rst
index 43bb676d5184..a7f17e40b59e 100644
--- a/Documentation/media/uapi/v4l/pixfmt-yuv420.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-yuv420.rst
@@ -7,7 +7,6 @@
 V4L2_PIX_FMT_YVU420 ('YV12'), V4L2_PIX_FMT_YUV420 ('YU12')
 **********************************************************
 
-*man V4L2_PIX_FMT_YVU420(2)*
 
 V4L2_PIX_FMT_YUV420
 Planar formats with ½ horizontal and vertical chroma resolution, also
@@ -38,12 +37,10 @@ Each cell is one byte.
 
 
 
-.. tabularcolumns:: |p{5.8cm}|p{2.9cm}|p{2.9cm}|p{2.9cm}|p{3.0cm}|
 
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
-    :widths:       2 1 1 1 1
 
 
     -  .. row 1
diff --git a/Documentation/media/uapi/v4l/pixfmt-yuv420m.rst b/Documentation/media/uapi/v4l/pixfmt-yuv420m.rst
index 7f7a7dadd07d..588784512944 100644
--- a/Documentation/media/uapi/v4l/pixfmt-yuv420m.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-yuv420m.rst
@@ -7,7 +7,6 @@
 V4L2_PIX_FMT_YUV420M ('YM12'), V4L2_PIX_FMT_YVU420M ('YM21')
 ************************************************************
 
-*man V4L2_PIX_FMT_YUV420M(2)*
 
 V4L2_PIX_FMT_YVU420M
 Variation of ``V4L2_PIX_FMT_YUV420`` and ``V4L2_PIX_FMT_YVU420`` with
@@ -45,12 +44,10 @@ Each cell is one byte.
 
 
 
-.. tabularcolumns:: |p{5.8cm}|p{2.9cm}|p{2.9cm}|p{2.9cm}|p{3.0cm}|
 
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
-    :widths:       2 1 1 1 1
 
 
     -  .. row 1
diff --git a/Documentation/media/uapi/v4l/pixfmt-yuv422m.rst b/Documentation/media/uapi/v4l/pixfmt-yuv422m.rst
index 5de85f987644..0c0a462c4dde 100644
--- a/Documentation/media/uapi/v4l/pixfmt-yuv422m.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-yuv422m.rst
@@ -7,7 +7,6 @@
 V4L2_PIX_FMT_YUV422M ('YM16'), V4L2_PIX_FMT_YVU422M ('YM61')
 ************************************************************
 
-*man V4L2_PIX_FMT_YUV422M(2)*
 
 V4L2_PIX_FMT_YVU422M
 Planar formats with ½ horizontal resolution, also known as YUV and YVU
@@ -44,12 +43,10 @@ Each cell is one byte.
 
 
 
-.. tabularcolumns:: |p{5.8cm}|p{2.9cm}|p{2.9cm}|p{2.9cm}|p{3.0cm}|
 
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
-    :widths:       2 1 1 1 1
 
 
     -  .. row 1
diff --git a/Documentation/media/uapi/v4l/pixfmt-yuv422p.rst b/Documentation/media/uapi/v4l/pixfmt-yuv422p.rst
index 6cdff74af7c9..9618f0d24265 100644
--- a/Documentation/media/uapi/v4l/pixfmt-yuv422p.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-yuv422p.rst
@@ -6,7 +6,6 @@
 V4L2_PIX_FMT_YUV422P ('422P')
 *****************************
 
-*man V4L2_PIX_FMT_YUV422P(2)*
 
 Format with ½ horizontal chroma resolution, also known as YUV 4:2:2.
 Planar layout as opposed to ``V4L2_PIX_FMT_YUYV``
@@ -34,12 +33,10 @@ Each cell is one byte.
 
 
 
-.. tabularcolumns:: |p{5.8cm}|p{2.9cm}|p{2.9cm}|p{2.9cm}|p{3.0cm}|
 
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
-    :widths:       2 1 1 1 1
 
 
     -  .. row 1
diff --git a/Documentation/media/uapi/v4l/pixfmt-yuv444m.rst b/Documentation/media/uapi/v4l/pixfmt-yuv444m.rst
index 8ebef2ce0e85..5985d45efb2c 100644
--- a/Documentation/media/uapi/v4l/pixfmt-yuv444m.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-yuv444m.rst
@@ -7,7 +7,6 @@
 V4L2_PIX_FMT_YUV444M ('YM24'), V4L2_PIX_FMT_YVU444M ('YM42')
 ************************************************************
 
-*man V4L2_PIX_FMT_YUV444M(2)*
 
 V4L2_PIX_FMT_YVU444M
 Planar formats with full horizontal resolution, also known as YUV and
@@ -38,12 +37,10 @@ described in :ref:`planar-apis`.
 **Byte Order.**
 Each cell is one byte.
 
-.. tabularcolumns:: |p{5.8cm}|p{2.9cm}|p{2.9cm}|p{2.9cm}|p{3.0cm}|
 
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
-    :widths:       2 1 1 1 1
 
 
     -  .. row 1
diff --git a/Documentation/media/uapi/v4l/pixfmt-yuyv.rst b/Documentation/media/uapi/v4l/pixfmt-yuyv.rst
index 24fa9bbb67b6..10deab080d51 100644
--- a/Documentation/media/uapi/v4l/pixfmt-yuyv.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-yuyv.rst
@@ -6,7 +6,6 @@
 V4L2_PIX_FMT_YUYV ('YUYV')
 **************************
 
-*man V4L2_PIX_FMT_YUYV(2)*
 
 Packed format with ½ horizontal chroma resolution, also known as YUV
 4:2:2
@@ -26,12 +25,10 @@ Each cell is one byte.
 
 
 
-.. tabularcolumns:: |p{3.5cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.4cm}|
 
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
-    :widths:       2 1 1 1 1 1 1 1 1
 
 
     -  .. row 1
diff --git a/Documentation/media/uapi/v4l/pixfmt-yvyu.rst b/Documentation/media/uapi/v4l/pixfmt-yvyu.rst
index 346b003b23ba..d126f08c1adc 100644
--- a/Documentation/media/uapi/v4l/pixfmt-yvyu.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-yvyu.rst
@@ -6,7 +6,6 @@
 V4L2_PIX_FMT_YVYU ('YVYU')
 **************************
 
-*man V4L2_PIX_FMT_YVYU(2)*
 
 Variation of ``V4L2_PIX_FMT_YUYV`` with different order of samples in
 memory
@@ -23,12 +22,10 @@ half the horizontal resolution of the Y component.
 **Byte Order.**
 Each cell is one byte.
 
-.. tabularcolumns:: |p{3.5cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.4cm}|
 
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
-    :widths:       2 1 1 1 1 1 1 1 1
 
 
     -  .. row 1
diff --git a/Documentation/media/uapi/v4l/pixfmt-z16.rst b/Documentation/media/uapi/v4l/pixfmt-z16.rst
index dd9a11a6746b..97fe1483a481 100644
--- a/Documentation/media/uapi/v4l/pixfmt-z16.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-z16.rst
@@ -6,7 +6,6 @@
 V4L2_PIX_FMT_Z16 ('Z16 ')
 *************************
 
-*man V4L2_PIX_FMT_Z16(2)*
 
 16-bit depth data with distance values at each pixel
 
@@ -24,12 +23,10 @@ Each cell is one byte.
 
 
 
-.. tabularcolumns:: |p{3.5cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.8cm}|p{1.4cm}|
 
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
-    :widths:       2 1 1 1 1 1 1 1 1
 
 
     -  .. row 1
-- 
2.7.4


