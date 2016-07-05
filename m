Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:38617 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753708AbcGEBb0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2016 21:31:26 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 41/41] Documentation: libv4l-introduction.rst: improve format
Date: Mon,  4 Jul 2016 22:31:16 -0300
Message-Id: <9eee76afc74f8d47e344adec0e0fca64605833c9.1467670142.git.mchehab@s-opensource.com>
In-Reply-To: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
References: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
In-Reply-To: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
References: <376f8877e078483e22a906cb0126f8db37bde441.1467670142.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix some cross-references and improve the layout of this
page.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/linux_tv/media/v4l/libv4l-introduction.rst | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/Documentation/linux_tv/media/v4l/libv4l-introduction.rst b/Documentation/linux_tv/media/v4l/libv4l-introduction.rst
index 4b261d95c672..61d085f9f105 100644
--- a/Documentation/linux_tv/media/v4l/libv4l-introduction.rst
+++ b/Documentation/linux_tv/media/v4l/libv4l-introduction.rst
@@ -45,7 +45,7 @@ It currently accepts the following V4L2 driver formats:
 :ref:`V4L2_PIX_FMT_SPCA508 <V4L2-PIX-FMT-SPCA508>`,
 :ref:`V4L2_PIX_FMT_SPCA561 <V4L2-PIX-FMT-SPCA561>`,
 :ref:`V4L2_PIX_FMT_SQ905C <V4L2-PIX-FMT-SQ905C>`,
-``V4L2_PIX_FMT_SRGGB8``,
+:ref:`V4L2_PIX_FMT_SRGGB8 <V4L2-PIX-FMT-SRGGB8>`,
 :ref:`V4L2_PIX_FMT_UYVY <V4L2-PIX-FMT-UYVY>`,
 :ref:`V4L2_PIX_FMT_YUV420 <V4L2-PIX-FMT-YUV420>`,
 :ref:`V4L2_PIX_FMT_YUYV <V4L2-PIX-FMT-YUYV>`,
@@ -92,16 +92,16 @@ and to enhance the image quality.
 In most cases, libv4l2 just passes the calls directly through to the
 v4l2 driver, intercepting the calls to
 :ref:`VIDIOC_TRY_FMT <VIDIOC_G_FMT>`,
-:ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>`
-:ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>`
-:ref:`VIDIOC_ENUM_FRAMESIZES` and
-:ref:`VIDIOC_ENUM_FRAMEINTERVALS` in
+:ref:`VIDIOC_G_FMT <VIDIOC_G_FMT>`,
+:ref:`VIDIOC_S_FMT <VIDIOC_G_FMT>`,
+:ref:`VIDIOC_ENUM_FRAMESIZES <VIDIOC_ENUM_FRAMESIZES>` and
+:ref:`VIDIOC_ENUM_FRAMEINTERVALS <VIDIOC_ENUM_FRAMEINTERVALS>` in
 order to emulate the formats
 :ref:`V4L2_PIX_FMT_BGR24 <V4L2-PIX-FMT-BGR24>`,
 :ref:`V4L2_PIX_FMT_RGB24 <V4L2-PIX-FMT-RGB24>`,
 :ref:`V4L2_PIX_FMT_YUV420 <V4L2-PIX-FMT-YUV420>`, and
 :ref:`V4L2_PIX_FMT_YVU420 <V4L2-PIX-FMT-YVU420>`, if they aren't
-available in the driver. :ref:`VIDIOC_ENUM_FMT`
+available in the driver. :ref:`VIDIOC_ENUM_FMT <VIDIOC_ENUM_FMT>`
 keeps enumerating the hardware supported formats, plus the emulated
 formats offered by libv4l at the end.
 
-- 
2.7.4

