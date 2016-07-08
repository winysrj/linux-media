Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41313 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755153AbcGHNEB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Jul 2016 09:04:01 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: corbet@lwn.net, markus.heiser@darmarIT.de,
	linux-doc@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 48/54] doc-rst: videodev2.h: don't ignore V4L2_STD macros
Date: Fri,  8 Jul 2016 10:03:40 -0300
Message-Id: <5ed759819f43fd850e883059e1dd6aa2d2591137.1467981855.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467981855.git.mchehab@s-opensource.com>
References: <cover.1467981855.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467981855.git.mchehab@s-opensource.com>
References: <cover.1467981855.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The content of those macros are all declared at the v4l2-std-id
table. So, point to it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/linux_tv/videodev2.h.rst.exceptions | 94 ++++++++++++-----------
 1 file changed, 48 insertions(+), 46 deletions(-)

diff --git a/Documentation/linux_tv/videodev2.h.rst.exceptions b/Documentation/linux_tv/videodev2.h.rst.exceptions
index 2c49287b6d59..8cad3ba6ba99 100644
--- a/Documentation/linux_tv/videodev2.h.rst.exceptions
+++ b/Documentation/linux_tv/videodev2.h.rst.exceptions
@@ -196,52 +196,6 @@ ignore define V4L2_FBUF_FLAG_LOCAL_INV_ALPHA
 ignore define V4L2_FBUF_FLAG_SRC_CHROMAKEY
 ignore define V4L2_MODE_HIGHQUALITY
 ignore define V4L2_CAP_TIMEPERFRAME
-ignore define V4L2_STD_PAL_B
-ignore define V4L2_STD_PAL_B1
-ignore define V4L2_STD_PAL_G
-ignore define V4L2_STD_PAL_H
-ignore define V4L2_STD_PAL_I
-ignore define V4L2_STD_PAL_D
-ignore define V4L2_STD_PAL_D1
-ignore define V4L2_STD_PAL_K
-ignore define V4L2_STD_PAL_M
-ignore define V4L2_STD_PAL_N
-ignore define V4L2_STD_PAL_Nc
-ignore define V4L2_STD_PAL_60
-ignore define V4L2_STD_NTSC_M
-ignore define V4L2_STD_NTSC_M_JP
-ignore define V4L2_STD_NTSC_443
-ignore define V4L2_STD_NTSC_M_KR
-ignore define V4L2_STD_SECAM_B
-ignore define V4L2_STD_SECAM_D
-ignore define V4L2_STD_SECAM_G
-ignore define V4L2_STD_SECAM_H
-ignore define V4L2_STD_SECAM_K
-ignore define V4L2_STD_SECAM_K1
-ignore define V4L2_STD_SECAM_L
-ignore define V4L2_STD_SECAM_LC
-ignore define V4L2_STD_ATSC_8_VSB
-ignore define V4L2_STD_ATSC_16_VSB
-ignore define V4L2_STD_NTSC
-ignore define V4L2_STD_SECAM_DK
-ignore define V4L2_STD_SECAM
-ignore define V4L2_STD_PAL_BG
-ignore define V4L2_STD_PAL_DK
-ignore define V4L2_STD_PAL
-ignore define V4L2_STD_B
-ignore define V4L2_STD_G
-ignore define V4L2_STD_H
-ignore define V4L2_STD_L
-ignore define V4L2_STD_GH
-ignore define V4L2_STD_DK
-ignore define V4L2_STD_BG
-ignore define V4L2_STD_MN
-ignore define V4L2_STD_MTS
-ignore define V4L2_STD_525_60
-ignore define V4L2_STD_625_50
-ignore define V4L2_STD_ATSC
-ignore define V4L2_STD_UNKNOWN
-ignore define V4L2_STD_ALL
 ignore define V4L2_DV_PROGRESSIVE
 ignore define V4L2_DV_INTERLACED
 ignore define V4L2_DV_VSYNC_POS_POL
@@ -414,6 +368,54 @@ ignore define V4L2_CHIP_FL_READABLE
 ignore define V4L2_CHIP_FL_WRITABLE
 ignore define BASE_VIDIOC_PRIVATE
 
+# The V4L2_STD_foo are all defined at v4l2_std_id table
+replace define V4L2_STD_PAL_B v4l2-std-id
+replace define V4L2_STD_PAL_B1 v4l2-std-id
+replace define V4L2_STD_PAL_G v4l2-std-id
+replace define V4L2_STD_PAL_H v4l2-std-id
+replace define V4L2_STD_PAL_I v4l2-std-id
+replace define V4L2_STD_PAL_D v4l2-std-id
+replace define V4L2_STD_PAL_D1 v4l2-std-id
+replace define V4L2_STD_PAL_K v4l2-std-id
+replace define V4L2_STD_PAL_M v4l2-std-id
+replace define V4L2_STD_PAL_N v4l2-std-id
+replace define V4L2_STD_PAL_Nc v4l2-std-id
+replace define V4L2_STD_PAL_60 v4l2-std-id
+replace define V4L2_STD_NTSC_M v4l2-std-id
+replace define V4L2_STD_NTSC_M_JP v4l2-std-id
+replace define V4L2_STD_NTSC_443 v4l2-std-id
+replace define V4L2_STD_NTSC_M_KR v4l2-std-id
+replace define V4L2_STD_SECAM_B v4l2-std-id
+replace define V4L2_STD_SECAM_D v4l2-std-id
+replace define V4L2_STD_SECAM_G v4l2-std-id
+replace define V4L2_STD_SECAM_H v4l2-std-id
+replace define V4L2_STD_SECAM_K v4l2-std-id
+replace define V4L2_STD_SECAM_K1 v4l2-std-id
+replace define V4L2_STD_SECAM_L v4l2-std-id
+replace define V4L2_STD_SECAM_LC v4l2-std-id
+replace define V4L2_STD_ATSC_8_VSB v4l2-std-id
+replace define V4L2_STD_ATSC_16_VSB v4l2-std-id
+replace define V4L2_STD_NTSC v4l2-std-id
+replace define V4L2_STD_SECAM_DK v4l2-std-id
+replace define V4L2_STD_SECAM v4l2-std-id
+replace define V4L2_STD_PAL_BG v4l2-std-id
+replace define V4L2_STD_PAL_DK v4l2-std-id
+replace define V4L2_STD_PAL v4l2-std-id
+replace define V4L2_STD_B v4l2-std-id
+replace define V4L2_STD_G v4l2-std-id
+replace define V4L2_STD_H v4l2-std-id
+replace define V4L2_STD_L v4l2-std-id
+replace define V4L2_STD_GH v4l2-std-id
+replace define V4L2_STD_DK v4l2-std-id
+replace define V4L2_STD_BG v4l2-std-id
+replace define V4L2_STD_MN v4l2-std-id
+replace define V4L2_STD_MTS v4l2-std-id
+replace define V4L2_STD_525_60 v4l2-std-id
+replace define V4L2_STD_625_50 v4l2-std-id
+replace define V4L2_STD_ATSC v4l2-std-id
+replace define V4L2_STD_UNKNOWN v4l2-std-id
+replace define V4L2_STD_ALL v4l2-std-id
+
 # Ignore reserved ioctl
 ignore ioctl VIDIOC_RESERVED
 
-- 
2.7.4

