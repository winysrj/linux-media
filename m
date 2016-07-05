Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:38710 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754235AbcGEBb2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2016 21:31:28 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 22/41] Documentation: v4l/pixfmt: re-join a broken paragraph
Date: Mon,  4 Jul 2016 22:30:57 -0300
Message-Id: <1d486b4c2181d9621f894b1596411d9e5f9d511e.1467670142.git.mchehab@s-opensource.com>
In-Reply-To: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
References: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
MIME-Version: 1.0
In-Reply-To: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
References: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=true
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Originally, at the DocBook, the "Byte Order" were a single
paragraph with the string that follows it. The conversion
broke it, and, sometimes, it added an extra dot.

Fix them altogheter at pixfmt-*.rst.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/linux_tv/media/v4l/pixfmt-grey.rst       | 3 +--
 Documentation/linux_tv/media/v4l/pixfmt-m420.rst       | 3 +--
 Documentation/linux_tv/media/v4l/pixfmt-nv12.rst       | 3 +--
 Documentation/linux_tv/media/v4l/pixfmt-nv12m.rst      | 2 +-
 Documentation/linux_tv/media/v4l/pixfmt-nv16m.rst      | 2 +-
 Documentation/linux_tv/media/v4l/pixfmt-nv24.rst       | 3 +--
 Documentation/linux_tv/media/v4l/pixfmt-packed-rgb.rst | 3 +--
 Documentation/linux_tv/media/v4l/pixfmt-sbggr16.rst    | 3 +--
 Documentation/linux_tv/media/v4l/pixfmt-sbggr8.rst     | 3 +--
 Documentation/linux_tv/media/v4l/pixfmt-sdr-cs08.rst   | 3 +--
 Documentation/linux_tv/media/v4l/pixfmt-sdr-cs14le.rst | 3 +--
 Documentation/linux_tv/media/v4l/pixfmt-sdr-cu08.rst   | 3 +--
 Documentation/linux_tv/media/v4l/pixfmt-sdr-cu16le.rst | 3 +--
 Documentation/linux_tv/media/v4l/pixfmt-sdr-ru12le.rst | 3 +--
 Documentation/linux_tv/media/v4l/pixfmt-sgbrg8.rst     | 3 +--
 Documentation/linux_tv/media/v4l/pixfmt-sgrbg8.rst     | 3 +--
 Documentation/linux_tv/media/v4l/pixfmt-srggb10.rst    | 3 +--
 Documentation/linux_tv/media/v4l/pixfmt-srggb10p.rst   | 3 +--
 Documentation/linux_tv/media/v4l/pixfmt-srggb12.rst    | 3 +--
 Documentation/linux_tv/media/v4l/pixfmt-srggb8.rst     | 3 +--
 Documentation/linux_tv/media/v4l/pixfmt-uv8.rst        | 3 +--
 Documentation/linux_tv/media/v4l/pixfmt-uyvy.rst       | 3 +--
 Documentation/linux_tv/media/v4l/pixfmt-vyuy.rst       | 3 +--
 Documentation/linux_tv/media/v4l/pixfmt-y10.rst        | 3 +--
 Documentation/linux_tv/media/v4l/pixfmt-y12.rst        | 3 +--
 Documentation/linux_tv/media/v4l/pixfmt-y16-be.rst     | 3 +--
 Documentation/linux_tv/media/v4l/pixfmt-y16.rst        | 3 +--
 Documentation/linux_tv/media/v4l/pixfmt-y41p.rst       | 1 -
 Documentation/linux_tv/media/v4l/pixfmt-y8i.rst        | 3 +--
 Documentation/linux_tv/media/v4l/pixfmt-yuv410.rst     | 3 +--
 Documentation/linux_tv/media/v4l/pixfmt-yuv411p.rst    | 2 +-
 Documentation/linux_tv/media/v4l/pixfmt-yuv420.rst     | 3 +--
 Documentation/linux_tv/media/v4l/pixfmt-yuv420m.rst    | 3 +--
 Documentation/linux_tv/media/v4l/pixfmt-yuv422m.rst    | 3 +--
 Documentation/linux_tv/media/v4l/pixfmt-yuv422p.rst    | 3 +--
 Documentation/linux_tv/media/v4l/pixfmt-yuv444m.rst    | 3 +--
 Documentation/linux_tv/media/v4l/pixfmt-yuyv.rst       | 3 +--
 Documentation/linux_tv/media/v4l/pixfmt-yvyu.rst       | 3 +--
 Documentation/linux_tv/media/v4l/pixfmt-z16.rst        | 3 +--
 39 files changed, 38 insertions(+), 74 deletions(-)

diff --git a/Documentation/linux_tv/media/v4l/pixfmt-grey.rst b/Documentation/linux_tv/media/v4l/pixfmt-grey.rst
index e1e19d558d59..761d783d4989 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-grey.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-grey.rst
@@ -17,8 +17,7 @@ Description
 This is a grey-scale image. It is really a degenerate Y'CbCr format
 which simply contains no Cb or Cr data.
 
-**Byte Order..**
-
+**Byte Order.**
 Each cell is one byte.
 
 
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-m420.rst b/Documentation/linux_tv/media/v4l/pixfmt-m420.rst
index 2ef35cfc14fa..f03042653bcd 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-m420.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-m420.rst
@@ -28,8 +28,7 @@ Y'\ :sub:`10`, Y'\ :sub:`11`.
 All line lengths are identical: if the Y lines include pad bytes so do
 the CbCr lines.
 
-**Byte Order..**
-
+**Byte Order.**
 Each cell is one byte.
 
 
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-nv12.rst b/Documentation/linux_tv/media/v4l/pixfmt-nv12.rst
index c15437c0cb23..906d1effff67 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-nv12.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-nv12.rst
@@ -31,8 +31,7 @@ with a Cr byte.
 If the Y plane has pad bytes after each row, then the CbCr plane has as
 many pad bytes after its rows.
 
-**Byte Order..**
-
+**Byte Order.**
 Each cell is one byte.
 
 
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-nv12m.rst b/Documentation/linux_tv/media/v4l/pixfmt-nv12m.rst
index ed0fe226a733..39ed024bcbe7 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-nv12m.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-nv12m.rst
@@ -42,7 +42,7 @@ applications that support the multi-planar API, described in
 If the Y plane has pad bytes after each row, then the CbCr plane has as
 many pad bytes after its rows.
 
-**Byte Order..**
+**Byte Order.**
 Each cell is one byte.
 
 .. flat-table::
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-nv16m.rst b/Documentation/linux_tv/media/v4l/pixfmt-nv16m.rst
index 2157663fa6c2..b43fc50bda73 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-nv16m.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-nv16m.rst
@@ -33,7 +33,7 @@ Cb and Cr bytes are swapped, the CrCb plane starts with a Cr byte.
 used only in drivers and applications that support the multi-planar API,
 described in :ref:`planar-apis`.
 
-**Byte Order..**
+**Byte Order.**
 Each cell is one byte.
 
 
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-nv24.rst b/Documentation/linux_tv/media/v4l/pixfmt-nv24.rst
index c0a8ddfd6963..3f07f9391205 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-nv24.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-nv24.rst
@@ -30,8 +30,7 @@ swapped, the CrCb plane starts with a Cr sample.
 If the Y plane has pad bytes after each row, then the CbCr plane has
 twice as many pad bytes after its rows.
 
-**Byte Order..**
-
+**Byte Order.**
 Each cell is one byte.
 
 
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-packed-rgb.rst b/Documentation/linux_tv/media/v4l/pixfmt-packed-rgb.rst
index 517a5b42151c..08a322b9a2ed 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-packed-rgb.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-packed-rgb.rst
@@ -969,8 +969,7 @@ The XRGB and XBGR formats contain undefined bits (-). Applications,
 devices and drivers must ignore those bits, for both
 :ref:`capture` and :ref:`output` devices.
 
-**Byte Order..**
-
+**Byte Order.**
 Each cell is one byte.
 
 
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-sbggr16.rst b/Documentation/linux_tv/media/v4l/pixfmt-sbggr16.rst
index 742816ad4d41..2cfcc97b3c96 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-sbggr16.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-sbggr16.rst
@@ -21,8 +21,7 @@ memory addresses (little-endian). Note the actual sampling precision may
 be lower than 16 bits, for example 10 bits per pixel with values in
 range 0 to 1023.
 
-**Byte Order..**
-
+**Byte Order.**
 Each cell is one byte.
 
 
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-sbggr8.rst b/Documentation/linux_tv/media/v4l/pixfmt-sbggr8.rst
index 9a8e7d27e660..db4c523f49a9 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-sbggr8.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-sbggr8.rst
@@ -21,8 +21,7 @@ from neighbouring pixels. From left to right the first row consists of a
 blue and green value, the second row of a green and red value. This
 scheme repeats to the right and down for every two columns and rows.
 
-**Byte Order..**
-
+**Byte Order.**
 Each cell is one byte.
 
 
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-sdr-cs08.rst b/Documentation/linux_tv/media/v4l/pixfmt-sdr-cs08.rst
index 201901d3f4c5..a772b6a674d5 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-sdr-cs08.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-sdr-cs08.rst
@@ -19,8 +19,7 @@ number consist two parts, called In-phase and Quadrature (IQ). Both I
 and Q are represented as a 8 bit signed number. I value comes first and
 Q value after that.
 
-**Byte Order..**
-
+**Byte Order.**
 Each cell is one byte.
 
 
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-sdr-cs14le.rst b/Documentation/linux_tv/media/v4l/pixfmt-sdr-cs14le.rst
index c7e471fe722f..bfe5804bd84e 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-sdr-cs14le.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-sdr-cs14le.rst
@@ -20,8 +20,7 @@ and Q are represented as a 14 bit signed little endian number. I value
 comes first and Q value after that. 14 bit value is stored in 16 bit
 space with unused high bits padded with 0.
 
-**Byte Order..**
-
+**Byte Order.**
 Each cell is one byte.
 
 
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-sdr-cu08.rst b/Documentation/linux_tv/media/v4l/pixfmt-sdr-cu08.rst
index f97559ebcab5..9ea92099e7ed 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-sdr-cu08.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-sdr-cu08.rst
@@ -19,8 +19,7 @@ number consist two parts, called In-phase and Quadrature (IQ). Both I
 and Q are represented as a 8 bit unsigned number. I value comes first
 and Q value after that.
 
-**Byte Order..**
-
+**Byte Order.**
 Each cell is one byte.
 
 
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-sdr-cu16le.rst b/Documentation/linux_tv/media/v4l/pixfmt-sdr-cu16le.rst
index ee73006bdb23..2a1c0d4924a1 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-sdr-cu16le.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-sdr-cu16le.rst
@@ -19,8 +19,7 @@ number consist two parts, called In-phase and Quadrature (IQ). Both I
 and Q are represented as a 16 bit unsigned little endian number. I value
 comes first and Q value after that.
 
-**Byte Order..**
-
+**Byte Order.**
 Each cell is one byte.
 
 
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-sdr-ru12le.rst b/Documentation/linux_tv/media/v4l/pixfmt-sdr-ru12le.rst
index 7147e6cfe6d9..378581b27d4a 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-sdr-ru12le.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-sdr-ru12le.rst
@@ -18,8 +18,7 @@ This format contains sequence of real number samples. Each sample is
 represented as a 12 bit unsigned little endian number. Sample is stored
 in 16 bit space with unused high bits padded with 0.
 
-**Byte Order..**
-
+**Byte Order.**
 Each cell is one byte.
 
 
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-sgbrg8.rst b/Documentation/linux_tv/media/v4l/pixfmt-sgbrg8.rst
index 8d783f332eaa..6345c24d86f3 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-sgbrg8.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-sgbrg8.rst
@@ -21,8 +21,7 @@ from neighbouring pixels. From left to right the first row consists of a
 green and blue value, the second row of a red and green value. This
 scheme repeats to the right and down for every two columns and rows.
 
-**Byte Order..**
-
+**Byte Order.**
 Each cell is one byte.
 
 
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-sgrbg8.rst b/Documentation/linux_tv/media/v4l/pixfmt-sgrbg8.rst
index 04b93d9335a6..51b7b8ef7519 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-sgrbg8.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-sgrbg8.rst
@@ -21,8 +21,7 @@ from neighbouring pixels. From left to right the first row consists of a
 green and blue value, the second row of a red and green value. This
 scheme repeats to the right and down for every two columns and rows.
 
-**Byte Order..**
-
+**Byte Order.**
 Each cell is one byte.
 
 
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-srggb10.rst b/Documentation/linux_tv/media/v4l/pixfmt-srggb10.rst
index 2ad8ef04ad32..b21d9f01ed35 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-srggb10.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-srggb10.rst
@@ -25,8 +25,7 @@ are stored in memory in little endian order. They are conventionally
 described as GRGR... BGBG..., RGRG... GBGB..., etc. Below is an example
 of one of these formats
 
-**Byte Order..**
-
+**Byte Order.**
 Each cell is one byte, high 6 bits in high bytes are 0.
 
 
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-srggb10p.rst b/Documentation/linux_tv/media/v4l/pixfmt-srggb10p.rst
index fe2908e37d06..f95672d7327b 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-srggb10p.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-srggb10p.rst
@@ -28,8 +28,7 @@ with alternating green-red and green-blue rows. They are conventionally
 described as GRGR... BGBG..., RGRG... GBGB..., etc. Below is an example
 of one of these formats:
 
-**Byte Order..**
-
+**Byte Order.**
 Each cell is one byte.
 
 
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-srggb12.rst b/Documentation/linux_tv/media/v4l/pixfmt-srggb12.rst
index fa2efa33be66..86694681033a 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-srggb12.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-srggb12.rst
@@ -25,8 +25,7 @@ are stored in memory in little endian order. They are conventionally
 described as GRGR... BGBG..., RGRG... GBGB..., etc. Below is an example
 of one of these formats
 
-**Byte Order..**
-
+**Byte Order.**
 Each cell is one byte, high 6 bits in high bytes are 0.
 
 
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-srggb8.rst b/Documentation/linux_tv/media/v4l/pixfmt-srggb8.rst
index eb3f6b5e39ca..e88de4c48d47 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-srggb8.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-srggb8.rst
@@ -21,8 +21,7 @@ from neighbouring pixels. From left to right the first row consists of a
 red and green value, the second row of a green and blue value. This
 scheme repeats to the right and down for every two columns and rows.
 
-**Byte Order..**
-
+**Byte Order.**
 Each cell is one byte.
 
 
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-uv8.rst b/Documentation/linux_tv/media/v4l/pixfmt-uv8.rst
index 033cedf85f57..fa8f7ee9fee1 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-uv8.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-uv8.rst
@@ -16,8 +16,7 @@ Description
 
 In this format there is no Y plane, Only CbCr plane. ie (UV interleaved)
 
-**Byte Order..**
-
+**Byte Order.**
 Each cell is one byte.
 
 
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-uyvy.rst b/Documentation/linux_tv/media/v4l/pixfmt-uyvy.rst
index 8eaacd3af3df..6975949fc7a5 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-uyvy.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-uyvy.rst
@@ -20,8 +20,7 @@ Y's, a Cb and a Cr. Each Y goes to one of the pixels, and the Cb and Cr
 belong to both pixels. As you can see, the Cr and Cb components have
 half the horizontal resolution of the Y component.
 
-**Byte Order..**
-
+**Byte Order.**
 Each cell is one byte.
 
 .. flat-table::
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-vyuy.rst b/Documentation/linux_tv/media/v4l/pixfmt-vyuy.rst
index 9ce531834d9a..c3c72bdc3a1e 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-vyuy.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-vyuy.rst
@@ -20,8 +20,7 @@ Y's, a Cb and a Cr. Each Y goes to one of the pixels, and the Cb and Cr
 belong to both pixels. As you can see, the Cr and Cb components have
 half the horizontal resolution of the Y component.
 
-**Byte Order..**
-
+**Byte Order.**
 Each cell is one byte.
 
 .. flat-table::
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-y10.rst b/Documentation/linux_tv/media/v4l/pixfmt-y10.rst
index bb3f3229d8e5..d22f77138289 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-y10.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-y10.rst
@@ -18,8 +18,7 @@ This is a grey-scale image with a depth of 10 bits per pixel. Pixels are
 stored in 16-bit words with unused high bits padded with 0. The least
 significant byte is stored at lower memory addresses (little-endian).
 
-**Byte Order..**
-
+**Byte Order.**
 Each cell is one byte.
 
 
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-y12.rst b/Documentation/linux_tv/media/v4l/pixfmt-y12.rst
index 24c59c911fee..7729bcbf3350 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-y12.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-y12.rst
@@ -18,8 +18,7 @@ This is a grey-scale image with a depth of 12 bits per pixel. Pixels are
 stored in 16-bit words with unused high bits padded with 0. The least
 significant byte is stored at lower memory addresses (little-endian).
 
-**Byte Order..**
-
+**Byte Order.**
 Each cell is one byte.
 
 
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-y16-be.rst b/Documentation/linux_tv/media/v4l/pixfmt-y16-be.rst
index 6dcd9251659d..0c61a10018c2 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-y16-be.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-y16-be.rst
@@ -19,8 +19,7 @@ significant byte is stored at lower memory addresses (big-endian). Note
 the actual sampling precision may be lower than 16 bits, for example 10
 bits per pixel with values in range 0 to 1023.
 
-**Byte Order..**
-
+**Byte Order.**
 Each cell is one byte.
 
 
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-y16.rst b/Documentation/linux_tv/media/v4l/pixfmt-y16.rst
index cc1565f37db8..a8d4b7192ae3 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-y16.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-y16.rst
@@ -19,8 +19,7 @@ significant byte is stored at lower memory addresses (little-endian).
 Note the actual sampling precision may be lower than 16 bits, for
 example 10 bits per pixel with values in range 0 to 1023.
 
-**Byte Order..**
-
+**Byte Order.**
 Each cell is one byte.
 
 
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-y41p.rst b/Documentation/linux_tv/media/v4l/pixfmt-y41p.rst
index 1f8fe468001d..e2c690e4d254 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-y41p.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-y41p.rst
@@ -26,7 +26,6 @@ from "YUV 4:1:1 *packed*", while YUV411P stands for "YUV 4:1:1
 *planar*".
 
 **Byte Order.**
-
 Each cell is one byte.
 
 
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-y8i.rst b/Documentation/linux_tv/media/v4l/pixfmt-y8i.rst
index 3f3dbf18357f..7fa16ee85ab7 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-y8i.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-y8i.rst
@@ -19,8 +19,7 @@ pixels from 2 sources interleaved. Each pixel is stored in a 16-bit
 word. E.g. the R200 RealSense camera stores pixel from the left sensor
 in lower and from the right sensor in the higher 8 bits.
 
-**Byte Order..**
-
+**Byte Order.**
 Each cell is one byte.
 
 
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-yuv410.rst b/Documentation/linux_tv/media/v4l/pixfmt-yuv410.rst
index 642c20a038b6..6939099c1baa 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-yuv410.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-yuv410.rst
@@ -31,8 +31,7 @@ have ¼ as many pad bytes after their rows. In other words, four Cx rows
 (including padding) are exactly as long as one Y row (including
 padding).
 
-**Byte Order..**
-
+**Byte Order.**
 Each cell is one byte.
 
 
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-yuv411p.rst b/Documentation/linux_tv/media/v4l/pixfmt-yuv411p.rst
index 9521c4431c78..5747303cf2a7 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-yuv411p.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-yuv411p.rst
@@ -29,7 +29,7 @@ If the Y plane has pad bytes after each row, then the Cr and Cb planes
 have ¼ as many pad bytes after their rows. In other words, four C x rows
 (including padding) is exactly as long as one Y row (including padding).
 
-**Byte Order..**
+**Byte Order.**
 Each cell is one byte.
 
 
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-yuv420.rst b/Documentation/linux_tv/media/v4l/pixfmt-yuv420.rst
index 106afed50125..633b63b14b59 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-yuv420.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-yuv420.rst
@@ -33,8 +33,7 @@ have half as many pad bytes after their rows. In other words, two Cx
 rows (including padding) is exactly as long as one Y row (including
 padding).
 
-**Byte Order..**
-
+**Byte Order.**
 Each cell is one byte.
 
 
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-yuv420m.rst b/Documentation/linux_tv/media/v4l/pixfmt-yuv420m.rst
index dc3d395a5731..fc87afaf9139 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-yuv420m.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-yuv420m.rst
@@ -39,8 +39,7 @@ padding).
 used only in drivers and applications that support the multi-planar API,
 described in :ref:`planar-apis`.
 
-**Byte Order..**
-
+**Byte Order.**
 Each cell is one byte.
 
 
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-yuv422m.rst b/Documentation/linux_tv/media/v4l/pixfmt-yuv422m.rst
index 0057bc85fd24..fe903dc90aac 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-yuv422m.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-yuv422m.rst
@@ -38,8 +38,7 @@ padding).
 used only in drivers and applications that support the multi-planar API,
 described in :ref:`planar-apis`.
 
-**Byte Order..**
-
+**Byte Order.**
 Each cell is one byte.
 
 
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-yuv422p.rst b/Documentation/linux_tv/media/v4l/pixfmt-yuv422p.rst
index c5efeadc0e9c..bb95d656fcc1 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-yuv422p.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-yuv422p.rst
@@ -29,8 +29,7 @@ have half as many pad bytes after their rows. In other words, two Cx
 rows (including padding) is exactly as long as one Y row (including
 padding).
 
-**Byte Order..**
-
+**Byte Order.**
 Each cell is one byte.
 
 
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-yuv444m.rst b/Documentation/linux_tv/media/v4l/pixfmt-yuv444m.rst
index 556c37c34d67..d6fa7a7b0049 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-yuv444m.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-yuv444m.rst
@@ -34,8 +34,7 @@ have the same number of pad bytes after their rows.
 used only in drivers and applications that support the multi-planar API,
 described in :ref:`planar-apis`.
 
-**Byte Order..**
-
+**Byte Order.**
 Each cell is one byte.
 
 .. flat-table::
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-yuyv.rst b/Documentation/linux_tv/media/v4l/pixfmt-yuyv.rst
index 9f01ae03bd10..edc81a2875e9 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-yuyv.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-yuyv.rst
@@ -21,8 +21,7 @@ belong to both pixels. As you can see, the Cr and Cb components have
 half the horizontal resolution of the Y component. ``V4L2_PIX_FMT_YUYV``
 is known in the Windows environment as YUY2.
 
-**Byte Order..**
-
+**Byte Order.**
 Each cell is one byte.
 
 
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-yvyu.rst b/Documentation/linux_tv/media/v4l/pixfmt-yvyu.rst
index 576af343b81b..88da5e7cc1ef 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-yvyu.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-yvyu.rst
@@ -20,8 +20,7 @@ Y's, a Cb and a Cr. Each Y goes to one of the pixels, and the Cb and Cr
 belong to both pixels. As you can see, the Cr and Cb components have
 half the horizontal resolution of the Y component.
 
-**Byte Order..**
-
+**Byte Order.**
 Each cell is one byte.
 
 .. flat-table::
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-z16.rst b/Documentation/linux_tv/media/v4l/pixfmt-z16.rst
index 8804dd5cc1c0..c5cce2db78b6 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-z16.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-z16.rst
@@ -19,8 +19,7 @@ distance to the respective point in the image coordinates. Distance unit
 can vary and has to be negotiated with the device separately. Each pixel
 is stored in a 16-bit word in the little endian byte order.
 
-**Byte Order..**
-
+**Byte Order.**
 Each cell is one byte.
 
 
-- 
2.7.4

