Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44702 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753283AbcGDLrU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2016 07:47:20 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 03/51] Documentation: v4l2.rst: Fix authors and revisions lists
Date: Mon,  4 Jul 2016 08:46:24 -0300
Message-Id: <868af48f04b16fb8778ce8b31e54dd3f2ae77046.1467629488.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467629488.git.mchehab@s-opensource.com>
References: <cover.1467629488.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467629488.git.mchehab@s-opensource.com>
References: <cover.1467629488.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The conversion of the authors and revision history lists
didn't end too well.

Manually fix them.

The revision history still needs some care in the future.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/linux_tv/media/v4l/v4l2.rst | 70 +++++++++++++++++--------------
 1 file changed, 39 insertions(+), 31 deletions(-)

diff --git a/Documentation/linux_tv/media/v4l/v4l2.rst b/Documentation/linux_tv/media/v4l/v4l2.rst
index cf636b665d95..1ddbd67ec466 100644
--- a/Documentation/linux_tv/media/v4l/v4l2.rst
+++ b/Documentation/linux_tv/media/v4l/v4l2.rst
@@ -1,12 +1,13 @@
 .. -*- coding: utf-8; mode: rst -*-
 
+.. include:: <isonum.txt>
 .. _v4l2spec:
 
 #####################################
 Video for Linux Two API Specification
 #####################################
 
-**Revision 4.4**
+**Revision 4.5**
 
 .. toctree::
     :maxdepth: 1
@@ -30,49 +31,56 @@ Video for Linux Two API Specification
 Revision and Copyright
 **********************
 
+Authors, in alphabetical order:
 
-:author:    Schimek Michael (*H*)
-:address:   mschimek@gmx.at
+- Ailus, Sakari <sakari.ailus@iki.fi>
 
-:author:    Dirks Bill
-:contrib:   Original author of the V4L2 API and documentation.
+  - Subdev selections API.
 
-:author:    Verkuil Hans
-:address:   hverkuil@xs4all.nl
-:contrib:   Designed and documented the VIDIOC_LOG_STATUS ioctl, the extended control ioctls, major parts of the sliced VBI API, the MPEG encoder and decoder APIs and the DV Timings API.
+- Carvalho Chehab, Mauro <m.chehab@kernel.org>
 
-:author:    Rubli Martin
-:contrib:   Designed and documented the VIDIOC_ENUM_FRAMESIZES and VIDIOC_ENUM_FRAMEINTERVALS ioctls.
+  - Documented libv4l, designed and added v4l2grab example, Remote Controller chapter.
 
-:author:    Walls Andy
-:address:   awalls@md.metrocast.net
-:contrib:   Documented the fielded V4L2_MPEG_STREAM_VBI_FMT_IVTV MPEG stream embedded, sliced VBI data format in this specification.
+- Dirks, Bill
 
-:author:    Carvalho Chehab Mauro
-:address:   m.chehab@samsung.com
-:contrib:   Documented libv4l, designed and added v4l2grab example, Remote Controller chapter.
+  - Original author of the V4L2 API and documentation.
 
-:author:    Karicheri Muralidharan
-:address:   m-karicheri2@ti.com
-:contrib:   Documented the Digital Video timings API.
+- H Schimek, Michael <mschimek@gmx.at>
 
-:author:    Osciak Pawel
-:address:   pawel AT osciak.com
-:contrib:   Designed and documented the multi-planar API.
+  - Original author of the V4L2 API and documentation.
 
-:author:    Ailus Sakari
-:address:   sakari.ailus@iki.fi
-:contrib:   Subdev selections API.
+- Karicheri, Muralidharan <m-karicheri2@ti.com>
 
-:author:    Palosaari Antti
-:address:   crope@iki.fi
-:contrib:   SDR API.
+  - Documented the Digital Video timings API.
 
-**Copyright** 1999, 2000, 2001, 2002, 2003, 2004, 2005, 2006, 2007, 2008, 2009, 2010, 2011, 2012, 2013, 2014, 2015 : Bill Dirks, Michael H. Schimek, Hans Verkuil, Martin Rubli, Andy Walls, Muralidharan Karicheri, Mauro Carvalho Chehab, Pawel Osciak
+- Osciak, Pawel <pawel@osciak.com>
+
+  - Designed and documented the multi-planar API.
+
+- Palosaari, Antti <crope@iki.fi>
+
+  - SDR API.
+
+- Rubli, Martin
+
+  - Designed and documented the VIDIOC_ENUM_FRAMESIZES and VIDIOC_ENUM_FRAMEINTERVALS ioctls.
+
+- Walls, Andy <awalls@md.metrocast.net>
+
+  - Documented the fielded V4L2_MPEG_STREAM_VBI_FMT_IVTV MPEG stream embedded, sliced VBI data format in this specification.
+
+- Verkuil, Hans <hverkuil@xs4all.nl>
+
+  - Designed and documented the VIDIOC_LOG_STATUS ioctl, the extended control ioctls, major parts of the sliced VBI API, the MPEG encoder and decoder APIs and the DV Timings API.
+
+**Copyright** |copy| 1999-2016: Bill Dirks, Michael H. Schimek, Hans Verkuil, Martin Rubli, Andy Walls, Muralidharan Karicheri, Mauro Carvalho Chehab, Pawel Osciak, Sakari Ailus & Antti Palosaari.
 
 Except when explicitly stated as GPL, programming examples within this
 part can be used and distributed without restrictions.
 
+****************
+Revision History
+****************
 
 :revision: 4.5 / 2015-10-29 (*rr*)
 
@@ -254,7 +262,7 @@ packed pixel formats.
 
 Added the Video Output Overlay interface, new MPEG controls,
 V4L2_FIELD_INTERLACED_TB and V4L2_FIELD_INTERLACED_BT,
-VIDIOC_DBG_G/S_REGISTER, VIDIOC_(TRY_)ENCODER_CMD,
+VIDIOC_DBG_G/S_REGISTER, VIDIOC\_(TRY\_)ENCODER_CMD,
 VIDIOC_G_CHIP_IDENT, VIDIOC_G_ENC_INDEX, new pixel formats.
 Clarifications in the cropping chapter, about RGB pixel formats, the
 mmap(), poll(), select(), read() and write() functions. Typographical
@@ -311,7 +319,7 @@ for frame format enumeration of digital devices.
 
 :revision: 0.13 / 2006-04-07 (*mhs*)
 
-Corrected the description of struct v4l2_window clips. New V4L2_STD_
+Corrected the description of struct v4l2_window clips. New V4L2_STD\_
 and V4L2_TUNER_MODE_LANG1_LANG2 defines.
 
 
-- 
2.7.4


