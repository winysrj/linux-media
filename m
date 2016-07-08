Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41358 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755250AbcGHNEC (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Jul 2016 09:04:02 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: corbet@lwn.net, markus.heiser@darmarIT.de,
	linux-doc@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 47/54] doc-rst: linux_tv: Don't ignore pix formats
Date: Fri,  8 Jul 2016 10:03:39 -0300
Message-Id: <9aff73d2e45ef3141dc52d08685ff5a788c9ad05.1467981855.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467981855.git.mchehab@s-opensource.com>
References: <cover.1467981855.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467981855.git.mchehab@s-opensource.com>
References: <cover.1467981855.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that the reference problems were solved, let's not
ignore anymore the pix formats, as all of them are already
documented.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/linux_tv/media/v4l/pixfmt-nv12.rst   |   1 +
 Documentation/linux_tv/media/v4l/pixfmt-nv12m.rst  |   2 +
 Documentation/linux_tv/media/v4l/pixfmt-nv16.rst   |   1 +
 Documentation/linux_tv/media/v4l/pixfmt-nv16m.rst  |   1 +
 Documentation/linux_tv/media/v4l/pixfmt-nv24.rst   |   1 +
 .../linux_tv/media/v4l/pixfmt-sdr-cs08.rst         |   2 +-
 .../linux_tv/media/v4l/pixfmt-sdr-cu08.rst         |   2 +-
 .../linux_tv/media/v4l/pixfmt-srggb10.rst          |   3 +
 .../linux_tv/media/v4l/pixfmt-srggb10alaw8.rst     |   3 +
 .../linux_tv/media/v4l/pixfmt-srggb10dpcm8.rst     |   4 +
 .../linux_tv/media/v4l/pixfmt-srggb10p.rst         |   3 +
 .../linux_tv/media/v4l/pixfmt-srggb12.rst          |   4 +
 Documentation/linux_tv/media/v4l/pixfmt-yuv410.rst |   1 +
 .../linux_tv/media/v4l/pixfmt-yuv420m.rst          |   1 +
 .../linux_tv/media/v4l/pixfmt-yuv422m.rst          |   1 +
 .../linux_tv/media/v4l/pixfmt-yuv444m.rst          |   1 +
 Documentation/linux_tv/videodev2.h.rst.exceptions  | 142 ---------------------
 17 files changed, 29 insertions(+), 144 deletions(-)

diff --git a/Documentation/linux_tv/media/v4l/pixfmt-nv12.rst b/Documentation/linux_tv/media/v4l/pixfmt-nv12.rst
index 65ccfb837318..cf59b28f75b7 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-nv12.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-nv12.rst
@@ -1,6 +1,7 @@
 .. -*- coding: utf-8; mode: rst -*-
 
 .. _V4L2-PIX-FMT-NV12:
+.. _V4L2-PIX-FMT-NV21:
 
 ******************************************************
 V4L2_PIX_FMT_NV12 ('NV12'), V4L2_PIX_FMT_NV21 ('NV21')
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-nv12m.rst b/Documentation/linux_tv/media/v4l/pixfmt-nv12m.rst
index f0e0af732949..a4e7eaeccea8 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-nv12m.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-nv12m.rst
@@ -1,6 +1,8 @@
 .. -*- coding: utf-8; mode: rst -*-
 
 .. _V4L2-PIX-FMT-NV12M:
+.. _v4l2-pix-fmt-nv12mt-16x16:
+.. _V4L2-PIX-FMT-NV21M:
 
 ***********************************************************************************
 V4L2_PIX_FMT_NV12M ('NM12'), V4L2_PIX_FMT_NV21M ('NM21'), V4L2_PIX_FMT_NV12MT_16X16
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-nv16.rst b/Documentation/linux_tv/media/v4l/pixfmt-nv16.rst
index 5a7e89529ce9..88aa7617f7cf 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-nv16.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-nv16.rst
@@ -1,6 +1,7 @@
 .. -*- coding: utf-8; mode: rst -*-
 
 .. _V4L2-PIX-FMT-NV16:
+.. _V4L2-PIX-FMT-NV61:
 
 ******************************************************
 V4L2_PIX_FMT_NV16 ('NV16'), V4L2_PIX_FMT_NV61 ('NV61')
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-nv16m.rst b/Documentation/linux_tv/media/v4l/pixfmt-nv16m.rst
index 9b4c5b09c4b5..b7ee068f491c 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-nv16m.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-nv16m.rst
@@ -1,6 +1,7 @@
 .. -*- coding: utf-8; mode: rst -*-
 
 .. _V4L2-PIX-FMT-NV16M:
+.. _v4l2-pix-fmt-nv61m:
 
 ********************************************************
 V4L2_PIX_FMT_NV16M ('NM16'), V4L2_PIX_FMT_NV61M ('NM61')
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-nv24.rst b/Documentation/linux_tv/media/v4l/pixfmt-nv24.rst
index 3f07f9391205..db98f476446e 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-nv24.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-nv24.rst
@@ -1,6 +1,7 @@
 .. -*- coding: utf-8; mode: rst -*-
 
 .. _V4L2-PIX-FMT-NV24:
+.. _V4L2-PIX-FMT-NV42:
 
 ******************************************************
 V4L2_PIX_FMT_NV24 ('NV24'), V4L2_PIX_FMT_NV42 ('NV42')
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-sdr-cs08.rst b/Documentation/linux_tv/media/v4l/pixfmt-sdr-cs08.rst
index a772b6a674d5..2736275d080f 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-sdr-cs08.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-sdr-cs08.rst
@@ -1,6 +1,6 @@
 .. -*- coding: utf-8; mode: rst -*-
 
-.. _V4L2-SDR-FMT-CS08:
+.. _v4l2-sdr-fmt-cs8:
 
 *************************
 V4L2_SDR_FMT_CS8 ('CS08')
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-sdr-cu08.rst b/Documentation/linux_tv/media/v4l/pixfmt-sdr-cu08.rst
index 9ea92099e7ed..68ad1717f6d7 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-sdr-cu08.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-sdr-cu08.rst
@@ -1,6 +1,6 @@
 .. -*- coding: utf-8; mode: rst -*-
 
-.. _V4L2-SDR-FMT-CU08:
+.. _v4l2-sdr-fmt-cu8:
 
 *************************
 V4L2_SDR_FMT_CU8 ('CU08')
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-srggb10.rst b/Documentation/linux_tv/media/v4l/pixfmt-srggb10.rst
index b21d9f01ed35..44a49563917c 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-srggb10.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-srggb10.rst
@@ -1,6 +1,9 @@
 .. -*- coding: utf-8; mode: rst -*-
 
 .. _V4L2-PIX-FMT-SRGGB10:
+.. _v4l2-pix-fmt-sbggr10:
+.. _v4l2-pix-fmt-sgbrg10:
+.. _v4l2-pix-fmt-sgrbg10:
 
 ***************************************************************************************************************************
 V4L2_PIX_FMT_SRGGB10 ('RG10'), V4L2_PIX_FMT_SGRBG10 ('BA10'), V4L2_PIX_FMT_SGBRG10 ('GB10'), V4L2_PIX_FMT_SBGGR10 ('BG10'),
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-srggb10alaw8.rst b/Documentation/linux_tv/media/v4l/pixfmt-srggb10alaw8.rst
index 4e221629bcb3..68bae0cb764c 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-srggb10alaw8.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-srggb10alaw8.rst
@@ -1,6 +1,9 @@
 .. -*- coding: utf-8; mode: rst -*-
 
 .. _V4L2-PIX-FMT-SBGGR10ALAW8:
+.. _v4l2-pix-fmt-sgbrg10alaw8:
+.. _v4l2-pix-fmt-sgrbg10alaw8:
+.. _v4l2-pix-fmt-srggb10alaw8:
 
 ***********************************************************************************************************************************************
 V4L2_PIX_FMT_SBGGR10ALAW8 ('aBA8'), V4L2_PIX_FMT_SGBRG10ALAW8 ('aGA8'), V4L2_PIX_FMT_SGRBG10ALAW8 ('agA8'), V4L2_PIX_FMT_SRGGB10ALAW8 ('aRA8'),
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-srggb10dpcm8.rst b/Documentation/linux_tv/media/v4l/pixfmt-srggb10dpcm8.rst
index 23e7db7333ba..5e041d02eff0 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-srggb10dpcm8.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-srggb10dpcm8.rst
@@ -1,6 +1,10 @@
 .. -*- coding: utf-8; mode: rst -*-
 
 .. _V4L2-PIX-FMT-SBGGR10DPCM8:
+.. _v4l2-pix-fmt-sgbrg10dpcm8:
+.. _v4l2-pix-fmt-sgrbg10dpcm8:
+.. _v4l2-pix-fmt-srggb10dpcm8:
+
 
 ***********************************************************************************************************************************************
 V4L2_PIX_FMT_SBGGR10DPCM8 ('bBA8'), V4L2_PIX_FMT_SGBRG10DPCM8 ('bGA8'), V4L2_PIX_FMT_SGRBG10DPCM8 ('BD10'), V4L2_PIX_FMT_SRGGB10DPCM8 ('bRA8'),
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-srggb10p.rst b/Documentation/linux_tv/media/v4l/pixfmt-srggb10p.rst
index 9b4a1d9951ba..d71368f69087 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-srggb10p.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-srggb10p.rst
@@ -1,6 +1,9 @@
 .. -*- coding: utf-8; mode: rst -*-
 
 .. _V4L2-PIX-FMT-SRGGB10P:
+.. _v4l2-pix-fmt-sbggr10p:
+.. _v4l2-pix-fmt-sgbrg10p:
+.. _v4l2-pix-fmt-sgrbg10p:
 
 *******************************************************************************************************************************
 V4L2_PIX_FMT_SRGGB10P ('pRAA'), V4L2_PIX_FMT_SGRBG10P ('pgAA'), V4L2_PIX_FMT_SGBRG10P ('pGAA'), V4L2_PIX_FMT_SBGGR10P ('pBAA'),
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-srggb12.rst b/Documentation/linux_tv/media/v4l/pixfmt-srggb12.rst
index 86694681033a..f5303ab9e79c 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-srggb12.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-srggb12.rst
@@ -1,6 +1,10 @@
 .. -*- coding: utf-8; mode: rst -*-
 
 .. _V4L2-PIX-FMT-SRGGB12:
+.. _v4l2-pix-fmt-sbggr12:
+.. _v4l2-pix-fmt-sgbrg12:
+.. _v4l2-pix-fmt-sgrbg12:
+
 
 ***************************************************************************************************************************
 V4L2_PIX_FMT_SRGGB12 ('RG12'), V4L2_PIX_FMT_SGRBG12 ('BA12'), V4L2_PIX_FMT_SGBRG12 ('GB12'), V4L2_PIX_FMT_SBGGR12 ('BG12'),
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-yuv410.rst b/Documentation/linux_tv/media/v4l/pixfmt-yuv410.rst
index c51b4e2f108f..8a5d1a2ee005 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-yuv410.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-yuv410.rst
@@ -1,6 +1,7 @@
 .. -*- coding: utf-8; mode: rst -*-
 
 .. _V4L2-PIX-FMT-YVU410:
+.. _v4l2-pix-fmt-yuv410:
 
 **********************************************************
 V4L2_PIX_FMT_YVU410 ('YVU9'), V4L2_PIX_FMT_YUV410 ('YUV9')
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-yuv420m.rst b/Documentation/linux_tv/media/v4l/pixfmt-yuv420m.rst
index 0faf15cac881..4dab85090d7d 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-yuv420m.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-yuv420m.rst
@@ -1,6 +1,7 @@
 .. -*- coding: utf-8; mode: rst -*-
 
 .. _V4L2-PIX-FMT-YUV420M:
+.. _v4l2-pix-fmt-yvu420m:
 
 ************************************************************
 V4L2_PIX_FMT_YUV420M ('YM12'), V4L2_PIX_FMT_YVU420M ('YM21')
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-yuv422m.rst b/Documentation/linux_tv/media/v4l/pixfmt-yuv422m.rst
index 6850b359c887..ccb67284133a 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-yuv422m.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-yuv422m.rst
@@ -1,6 +1,7 @@
 .. -*- coding: utf-8; mode: rst -*-
 
 .. _V4L2-PIX-FMT-YUV422M:
+.. _v4l2-pix-fmt-yvu422m:
 
 ************************************************************
 V4L2_PIX_FMT_YUV422M ('YM16'), V4L2_PIX_FMT_YVU422M ('YM61')
diff --git a/Documentation/linux_tv/media/v4l/pixfmt-yuv444m.rst b/Documentation/linux_tv/media/v4l/pixfmt-yuv444m.rst
index b04b2f4a8f17..04f34508b934 100644
--- a/Documentation/linux_tv/media/v4l/pixfmt-yuv444m.rst
+++ b/Documentation/linux_tv/media/v4l/pixfmt-yuv444m.rst
@@ -1,6 +1,7 @@
 .. -*- coding: utf-8; mode: rst -*-
 
 .. _V4L2-PIX-FMT-YUV444M:
+.. _v4l2-pix-fmt-yvu444m:
 
 ************************************************************
 V4L2_PIX_FMT_YUV444M ('YM24'), V4L2_PIX_FMT_YVU444M ('YM42')
diff --git a/Documentation/linux_tv/videodev2.h.rst.exceptions b/Documentation/linux_tv/videodev2.h.rst.exceptions
index abc9144feba9..2c49287b6d59 100644
--- a/Documentation/linux_tv/videodev2.h.rst.exceptions
+++ b/Documentation/linux_tv/videodev2.h.rst.exceptions
@@ -141,148 +141,6 @@ ignore define V4L2_CAP_READWRITE
 ignore define V4L2_CAP_ASYNCIO
 ignore define V4L2_CAP_STREAMING
 ignore define V4L2_CAP_DEVICE_CAPS
-ignore define V4L2_PIX_FMT_RGB332
-ignore define V4L2_PIX_FMT_RGB444
-ignore define V4L2_PIX_FMT_ARGB444
-ignore define V4L2_PIX_FMT_XRGB444
-ignore define V4L2_PIX_FMT_RGB555
-ignore define V4L2_PIX_FMT_ARGB555
-ignore define V4L2_PIX_FMT_XRGB555
-ignore define V4L2_PIX_FMT_RGB565
-ignore define V4L2_PIX_FMT_RGB555X
-ignore define V4L2_PIX_FMT_ARGB555X
-ignore define V4L2_PIX_FMT_XRGB555X
-ignore define V4L2_PIX_FMT_RGB565X
-ignore define V4L2_PIX_FMT_BGR666
-ignore define V4L2_PIX_FMT_BGR24
-ignore define V4L2_PIX_FMT_RGB24
-ignore define V4L2_PIX_FMT_BGR32
-ignore define V4L2_PIX_FMT_ABGR32
-ignore define V4L2_PIX_FMT_XBGR32
-ignore define V4L2_PIX_FMT_RGB32
-ignore define V4L2_PIX_FMT_ARGB32
-ignore define V4L2_PIX_FMT_XRGB32
-ignore define V4L2_PIX_FMT_GREY
-ignore define V4L2_PIX_FMT_Y4
-ignore define V4L2_PIX_FMT_Y6
-ignore define V4L2_PIX_FMT_Y10
-ignore define V4L2_PIX_FMT_Y12
-ignore define V4L2_PIX_FMT_Y16
-ignore define V4L2_PIX_FMT_Y16_BE
-ignore define V4L2_PIX_FMT_Y10BPACK
-ignore define V4L2_PIX_FMT_PAL8
-ignore define V4L2_PIX_FMT_UV8
-ignore define V4L2_PIX_FMT_YUYV
-ignore define V4L2_PIX_FMT_YYUV
-ignore define V4L2_PIX_FMT_YVYU
-ignore define V4L2_PIX_FMT_UYVY
-ignore define V4L2_PIX_FMT_VYUY
-ignore define V4L2_PIX_FMT_Y41P
-ignore define V4L2_PIX_FMT_YUV444
-ignore define V4L2_PIX_FMT_YUV555
-ignore define V4L2_PIX_FMT_YUV565
-ignore define V4L2_PIX_FMT_YUV32
-ignore define V4L2_PIX_FMT_HI240
-ignore define V4L2_PIX_FMT_HM12
-ignore define V4L2_PIX_FMT_M420
-ignore define V4L2_PIX_FMT_NV12
-ignore define V4L2_PIX_FMT_NV21
-ignore define V4L2_PIX_FMT_NV16
-ignore define V4L2_PIX_FMT_NV61
-ignore define V4L2_PIX_FMT_NV24
-ignore define V4L2_PIX_FMT_NV42
-ignore define V4L2_PIX_FMT_NV12M
-ignore define V4L2_PIX_FMT_NV21M
-ignore define V4L2_PIX_FMT_NV16M
-ignore define V4L2_PIX_FMT_NV61M
-ignore define V4L2_PIX_FMT_NV12MT
-ignore define V4L2_PIX_FMT_NV12MT_16X16
-ignore define V4L2_PIX_FMT_YUV410
-ignore define V4L2_PIX_FMT_YVU410
-ignore define V4L2_PIX_FMT_YUV411P
-ignore define V4L2_PIX_FMT_YUV420
-ignore define V4L2_PIX_FMT_YVU420
-ignore define V4L2_PIX_FMT_YUV422P
-ignore define V4L2_PIX_FMT_YUV420M
-ignore define V4L2_PIX_FMT_YVU420M
-ignore define V4L2_PIX_FMT_YUV422M
-ignore define V4L2_PIX_FMT_YVU422M
-ignore define V4L2_PIX_FMT_YUV444M
-ignore define V4L2_PIX_FMT_YVU444M
-ignore define V4L2_PIX_FMT_SBGGR8
-ignore define V4L2_PIX_FMT_SGBRG8
-ignore define V4L2_PIX_FMT_SGRBG8
-ignore define V4L2_PIX_FMT_SRGGB8
-ignore define V4L2_PIX_FMT_SBGGR10
-ignore define V4L2_PIX_FMT_SGBRG10
-ignore define V4L2_PIX_FMT_SGRBG10
-ignore define V4L2_PIX_FMT_SRGGB10
-ignore define V4L2_PIX_FMT_SBGGR10P
-ignore define V4L2_PIX_FMT_SGBRG10P
-ignore define V4L2_PIX_FMT_SGRBG10P
-ignore define V4L2_PIX_FMT_SRGGB10P
-ignore define V4L2_PIX_FMT_SBGGR10ALAW8
-ignore define V4L2_PIX_FMT_SGBRG10ALAW8
-ignore define V4L2_PIX_FMT_SGRBG10ALAW8
-ignore define V4L2_PIX_FMT_SRGGB10ALAW8
-ignore define V4L2_PIX_FMT_SBGGR10DPCM8
-ignore define V4L2_PIX_FMT_SGBRG10DPCM8
-ignore define V4L2_PIX_FMT_SGRBG10DPCM8
-ignore define V4L2_PIX_FMT_SRGGB10DPCM8
-ignore define V4L2_PIX_FMT_SBGGR12
-ignore define V4L2_PIX_FMT_SGBRG12
-ignore define V4L2_PIX_FMT_SGRBG12
-ignore define V4L2_PIX_FMT_SRGGB12
-ignore define V4L2_PIX_FMT_SBGGR16
-ignore define V4L2_PIX_FMT_MJPEG
-ignore define V4L2_PIX_FMT_JPEG
-ignore define V4L2_PIX_FMT_DV
-ignore define V4L2_PIX_FMT_MPEG
-ignore define V4L2_PIX_FMT_H264
-ignore define V4L2_PIX_FMT_H264_NO_SC
-ignore define V4L2_PIX_FMT_H264_MVC
-ignore define V4L2_PIX_FMT_H263
-ignore define V4L2_PIX_FMT_MPEG1
-ignore define V4L2_PIX_FMT_MPEG2
-ignore define V4L2_PIX_FMT_MPEG4
-ignore define V4L2_PIX_FMT_XVID
-ignore define V4L2_PIX_FMT_VC1_ANNEX_G
-ignore define V4L2_PIX_FMT_VC1_ANNEX_L
-ignore define V4L2_PIX_FMT_VP8
-ignore define V4L2_PIX_FMT_CPIA1
-ignore define V4L2_PIX_FMT_WNVA
-ignore define V4L2_PIX_FMT_SN9C10X
-ignore define V4L2_PIX_FMT_SN9C20X_I420
-ignore define V4L2_PIX_FMT_PWC1
-ignore define V4L2_PIX_FMT_PWC2
-ignore define V4L2_PIX_FMT_ET61X251
-ignore define V4L2_PIX_FMT_SPCA501
-ignore define V4L2_PIX_FMT_SPCA505
-ignore define V4L2_PIX_FMT_SPCA508
-ignore define V4L2_PIX_FMT_SPCA561
-ignore define V4L2_PIX_FMT_PAC207
-ignore define V4L2_PIX_FMT_MR97310A
-ignore define V4L2_PIX_FMT_JL2005BCD
-ignore define V4L2_PIX_FMT_SN9C2028
-ignore define V4L2_PIX_FMT_SQ905C
-ignore define V4L2_PIX_FMT_PJPG
-ignore define V4L2_PIX_FMT_OV511
-ignore define V4L2_PIX_FMT_OV518
-ignore define V4L2_PIX_FMT_STV0680
-ignore define V4L2_PIX_FMT_TM6000
-ignore define V4L2_PIX_FMT_CIT_YYVYUY
-ignore define V4L2_PIX_FMT_KONICA420
-ignore define V4L2_PIX_FMT_JPGL
-ignore define V4L2_PIX_FMT_SE401
-ignore define V4L2_PIX_FMT_S5C_UYVY_JPG
-ignore define V4L2_PIX_FMT_Y8I
-ignore define V4L2_PIX_FMT_Y12I
-ignore define V4L2_PIX_FMT_Z16
-ignore define V4L2_SDR_FMT_CU8
-ignore define V4L2_SDR_FMT_CU16LE
-ignore define V4L2_SDR_FMT_CS8
-ignore define V4L2_SDR_FMT_CS14LE
-ignore define V4L2_SDR_FMT_RU12LE
 ignore define V4L2_PIX_FMT_PRIV_MAGIC
 ignore define V4L2_PIX_FMT_FLAG_PREMUL_ALPHA
 ignore define V4L2_FMT_FLAG_COMPRESSED
-- 
2.7.4

