Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41405 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755313AbcGHNEE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Jul 2016 09:04:04 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: corbet@lwn.net, markus.heiser@darmarIT.de,
	linux-doc@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 45/54] doc-rst: autogenerate videodev2.h.rst file
Date: Fri,  8 Jul 2016 10:03:37 -0300
Message-Id: <9f97b3066c82a6dd428330fe8a12b8cf6728b05c.1467981855.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467981855.git.mchehab@s-opensource.com>
References: <cover.1467981855.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467981855.git.mchehab@s-opensource.com>
References: <cover.1467981855.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This file comes from the uAPI definitions for V4L2, with is dynamic
and updated on almost every Kernel version. So, this file
needs to be auto-updated, as otherwise the documentation will
become obsolete too early.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/linux_tv/Makefile                    |    6 +-
 Documentation/linux_tv/media/v4l/audio.rst         |    8 +-
 Documentation/linux_tv/media/v4l/hist-v4l2.rst     |    4 +-
 .../linux_tv/media/v4l/vidioc-enumaudioout.rst     |    4 +-
 .../linux_tv/media/v4l/vidioc-g-audioout.rst       |    2 +-
 Documentation/linux_tv/videodev2.h.rst             | 2300 --------------------
 Documentation/linux_tv/videodev2.h.rst.exceptions  |  591 +++++
 7 files changed, 605 insertions(+), 2310 deletions(-)
 delete mode 100644 Documentation/linux_tv/videodev2.h.rst
 create mode 100644 Documentation/linux_tv/videodev2.h.rst.exceptions

diff --git a/Documentation/linux_tv/Makefile b/Documentation/linux_tv/Makefile
index 1773132008da..068e26e0cc6f 100644
--- a/Documentation/linux_tv/Makefile
+++ b/Documentation/linux_tv/Makefile
@@ -2,7 +2,8 @@
 
 PARSER = ../sphinx/parse-headers.pl
 UAPI = ../../include/uapi/linux
-TARGETS = audio.h.rst ca.h.rst dmx.h.rst frontend.h.rst net.h.rst video.h.rst
+TARGETS = audio.h.rst ca.h.rst dmx.h.rst frontend.h.rst net.h.rst video.h.rst \
+	  videodev2.h.rst
 
 htmldocs: ${TARGETS}
 
@@ -24,5 +25,8 @@ net.h.rst: ${PARSER} ${UAPI}/dvb/net.h  net.h.rst.exceptions
 video.h.rst: ${PARSER} ${UAPI}/dvb/video.h  video.h.rst.exceptions
 	${PARSER} ${UAPI}/dvb/video.h $@ video.h.rst.exceptions
 
+videodev2.h.rst: ${UAPI}/videodev2.h ${PARSER} videodev2.h.rst.exceptions
+	${PARSER} ${UAPI}/videodev2.h $@ videodev2.h.rst.exceptions
+
 cleandocs:
 	-rm ${TARGETS}
diff --git a/Documentation/linux_tv/media/v4l/audio.rst b/Documentation/linux_tv/media/v4l/audio.rst
index b6c41c35a744..71502f0bf8bd 100644
--- a/Documentation/linux_tv/media/v4l/audio.rst
+++ b/Documentation/linux_tv/media/v4l/audio.rst
@@ -28,23 +28,23 @@ number, starting at zero, of one audio input or output.
 To learn about the number and attributes of the available inputs and
 outputs applications can enumerate them with the
 :ref:`VIDIOC_ENUMAUDIO` and
-:ref:`VIDIOC_ENUMAUDOUT <VIDIOC_ENUMAUDIOout>` ioctl, respectively.
+:ref:`VIDIOC_ENUMAUDOUT <VIDIOC_ENUMAUDOUT>` ioctl, respectively.
 The struct :ref:`v4l2_audio <v4l2-audio>` returned by the
 :ref:`VIDIOC_ENUMAUDIO` ioctl also contains signal
 :status information applicable when the current audio input is queried.
 
 The :ref:`VIDIOC_G_AUDIO <VIDIOC_G_AUDIO>` and
-:ref:`VIDIOC_G_AUDOUT <VIDIOC_G_AUDIOout>` ioctls report the current
+:ref:`VIDIOC_G_AUDOUT <VIDIOC_G_AUDOUT>` ioctls report the current
 audio input and output, respectively. Note that, unlike
 :ref:`VIDIOC_G_INPUT <VIDIOC_G_INPUT>` and
 :ref:`VIDIOC_G_OUTPUT <VIDIOC_G_OUTPUT>` these ioctls return a
 structure as :ref:`VIDIOC_ENUMAUDIO` and
-:ref:`VIDIOC_ENUMAUDOUT <VIDIOC_ENUMAUDIOout>` do, not just an index.
+:ref:`VIDIOC_ENUMAUDOUT <VIDIOC_ENUMAUDOUT>` do, not just an index.
 
 To select an audio input and change its properties applications call the
 :ref:`VIDIOC_S_AUDIO <VIDIOC_G_AUDIO>` ioctl. To select an audio
 output (which presently has no changeable properties) applications call
-the :ref:`VIDIOC_S_AUDOUT <VIDIOC_G_AUDIOout>` ioctl.
+the :ref:`VIDIOC_S_AUDOUT <VIDIOC_G_AUDOUT>` ioctl.
 
 Drivers must implement all audio input ioctls when the device has
 multiple selectable audio inputs, all audio output ioctls when the
diff --git a/Documentation/linux_tv/media/v4l/hist-v4l2.rst b/Documentation/linux_tv/media/v4l/hist-v4l2.rst
index 7dac98c5dc95..a571e099fde7 100644
--- a/Documentation/linux_tv/media/v4l/hist-v4l2.rst
+++ b/Documentation/linux_tv/media/v4l/hist-v4l2.rst
@@ -727,8 +727,8 @@ V4L2 2003-06-19
    audio input.
 
    The same changes were made to
-   :ref:`VIDIOC_G_AUDOUT <VIDIOC_G_AUDIOout>` and
-   :ref:`VIDIOC_ENUMAUDOUT <VIDIOC_ENUMAUDIOout>`.
+   :ref:`VIDIOC_G_AUDOUT <VIDIOC_G_AUDOUT>` and
+   :ref:`VIDIOC_ENUMAUDOUT <VIDIOC_ENUMAUDOUT>`.
 
    Until further the "videodev" module will automatically translate
    between the old and new ioctls, but drivers and applications must be
diff --git a/Documentation/linux_tv/media/v4l/vidioc-enumaudioout.rst b/Documentation/linux_tv/media/v4l/vidioc-enumaudioout.rst
index 4c1756319c09..15bc5a40f4a6 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-enumaudioout.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-enumaudioout.rst
@@ -1,6 +1,6 @@
 .. -*- coding: utf-8; mode: rst -*-
 
-.. _VIDIOC_ENUMAUDIOOUT:
+.. _VIDIOC_ENUMAUDOUT:
 
 ***********************
 ioctl VIDIOC_ENUMAUDOUT
@@ -44,7 +44,7 @@ zero, incrementing by one until the driver returns ``EINVAL``.
 Note connectors on a TV card to loop back the received audio signal to a
 sound card are not audio outputs in this sense.
 
-See :ref:`VIDIOC_G_AUDIOout <VIDIOC_G_AUDIOout>` for a description of struct
+See :ref:`VIDIOC_G_AUDIOout <VIDIOC_G_AUDOUT>` for a description of struct
 :ref:`v4l2_audioout <v4l2-audioout>`.
 
 
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-audioout.rst b/Documentation/linux_tv/media/v4l/vidioc-g-audioout.rst
index e36b5a116332..bee5f78ed7c1 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-audioout.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-audioout.rst
@@ -1,6 +1,6 @@
 .. -*- coding: utf-8; mode: rst -*-
 
-.. _VIDIOC_G_AUDIOOUT:
+.. _VIDIOC_G_AUDOUT:
 
 **************************************
 ioctl VIDIOC_G_AUDOUT, VIDIOC_S_AUDOUT
diff --git a/Documentation/linux_tv/videodev2.h.rst b/Documentation/linux_tv/videodev2.h.rst
deleted file mode 100644
index f3c9e6959be0..000000000000
--- a/Documentation/linux_tv/videodev2.h.rst
+++ /dev/null
@@ -1,2300 +0,0 @@
-.. -*- coding: utf-8; mode: rst -*-
-
-file: videodev2.h
-=================
-
-.. code-block:: c
-
-    /*
-     *  Video for Linux Two header file
-     *
-     *  Copyright (C) 1999-2012 the contributors
-     *
-     *  This program is free software; you can redistribute it and/or modify
-     *  it under the terms of the GNU General Public License as published by
-     *  the Free Software Foundation; either version 2 of the License, or
-     *  (at your option) any later version.
-     *
-     *  This program is distributed in the hope that it will be useful,
-     *  but WITHOUT ANY WARRANTY; without even the implied warranty of
-     *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-     *  GNU General Public License for more details.
-     *
-     *  Alternatively you can redistribute this file under the terms of the
-     *  BSD license as stated below:
-     *
-     *  Redistribution and use in source and binary forms, with or without
-     *  modification, are permitted provided that the following conditions
-     *  are met:
-     *  1. Redistributions of source code must retain the above copyright
-     *     notice, this list of conditions and the following disclaimer.
-     *  2. Redistributions in binary form must reproduce the above copyright
-     *     notice, this list of conditions and the following disclaimer in
-     *     the documentation and/or other materials provided with the
-     *     distribution.
-     *  3. The names of its contributors may not be used to endorse or promote
-     *     products derived from this software without specific prior written
-     *     permission.
-     *
-     *  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
-     *  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
-     *  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
-     *  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
-     *  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
-     *  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
-     *  TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
-     *  PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
-     *  LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
-     *  NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
-     *  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
-     *
-     *      Header file for v4l or V4L2 drivers and applications
-     * with public API.
-     * All kernel-specific stuff were moved to media/v4l2-dev.h, so
-     * no #if __KERNEL tests are allowed here
-     *
-     *      See https://linuxtv.org for more info
-     *
-     *      Author: Bill Dirks <bill@thedirks.org>
-     *              Justin Schoeman
-     *              Hans Verkuil <hverkuil@xs4all.nl>
-     *              et al.
-     */
-    #ifndef _UAPI__LINUX_VIDEODEV2_H
-    #define _UAPI__LINUX_VIDEODEV2_H
-
-    #ifndef __KERNEL__
-    #include <sys/time.h>
-    #endif
-    #include <linux/compiler.h>
-    #include <linux/ioctl.h>
-    #include <linux/types.h>
-    #include <linux/v4l2-common.h>
-    #include <linux/v4l2-controls.h>
-
-    /*
-     * Common stuff for both V4L1 and V4L2
-     * Moved from videodev.h
-     */
-    #define VIDEO_MAX_FRAME               32
-    #define VIDEO_MAX_PLANES               8
-
-    /*
-     *      M I S C E L L A N E O U S
-     */
-
-    /*  Four-character-code (FOURCC) */
-    #define v4l2_fourcc(a, b, c, d)
-	    ((__u32)(a) | ((__u32)(b) << 8) | ((__u32)(c) << 16) | ((__u32)(d) << 24))
-    #define v4l2_fourcc_be(a, b, c, d)      (v4l2_fourcc(a, b, c, d) | (1 << 31))
-
-    /*
-     *      E N U M S
-     */
-    enum v4l2_field {
-	    V4L2_FIELD_ANY           = 0, /* driver can choose from none,
-					     top, bottom, interlaced
-					     depending on whatever it thinks
-					     is approximate ... */
-	    V4L2_FIELD_NONE          = 1, /* this device has no fields ... */
-	    V4L2_FIELD_TOP           = 2, /* top field only */
-	    V4L2_FIELD_BOTTOM        = 3, /* bottom field only */
-	    V4L2_FIELD_INTERLACED    = 4, /* both fields interlaced */
-	    V4L2_FIELD_SEQ_TB        = 5, /* both fields sequential into one
-					     buffer, top-bottom order */
-	    V4L2_FIELD_SEQ_BT        = 6, /* same as above + bottom-top order */
-	    V4L2_FIELD_ALTERNATE     = 7, /* both fields alternating into
-					     separate buffers */
-	    V4L2_FIELD_INTERLACED_TB = 8, /* both fields interlaced, top field
-					     first and the top field is
-					     transmitted first */
-	    V4L2_FIELD_INTERLACED_BT = 9, /* both fields interlaced, top field
-					     first and the bottom field is
-					     transmitted first */
-    };
-    #define V4L2_FIELD_HAS_TOP(field)
-	    ((field) == V4L2_FIELD_TOP      ||
-	     (field) == V4L2_FIELD_INTERLACED ||
-	     (field) == V4L2_FIELD_INTERLACED_TB ||
-	     (field) == V4L2_FIELD_INTERLACED_BT ||
-	     (field) == V4L2_FIELD_SEQ_TB   ||
-	     (field) == V4L2_FIELD_SEQ_BT)
-    #define V4L2_FIELD_HAS_BOTTOM(field)
-	    ((field) == V4L2_FIELD_BOTTOM   ||
-	     (field) == V4L2_FIELD_INTERLACED ||
-	     (field) == V4L2_FIELD_INTERLACED_TB ||
-	     (field) == V4L2_FIELD_INTERLACED_BT ||
-	     (field) == V4L2_FIELD_SEQ_TB   ||
-	     (field) == V4L2_FIELD_SEQ_BT)
-    #define V4L2_FIELD_HAS_BOTH(field)
-	    ((field) == V4L2_FIELD_INTERLACED ||
-	     (field) == V4L2_FIELD_INTERLACED_TB ||
-	     (field) == V4L2_FIELD_INTERLACED_BT ||
-	     (field) == V4L2_FIELD_SEQ_TB ||
-	     (field) == V4L2_FIELD_SEQ_BT)
-    #define V4L2_FIELD_HAS_T_OR_B(field)
-	    ((field) == V4L2_FIELD_BOTTOM ||
-	     (field) == V4L2_FIELD_TOP ||
-	     (field) == V4L2_FIELD_ALTERNATE)
-
-    enum v4l2_buf_type {
-	    V4L2_BUF_TYPE_VIDEO_CAPTURE        = 1,
-	    V4L2_BUF_TYPE_VIDEO_OUTPUT         = 2,
-	    V4L2_BUF_TYPE_VIDEO_OVERLAY        = 3,
-	    V4L2_BUF_TYPE_VBI_CAPTURE          = 4,
-	    V4L2_BUF_TYPE_VBI_OUTPUT           = 5,
-	    V4L2_BUF_TYPE_SLICED_VBI_CAPTURE   = 6,
-	    V4L2_BUF_TYPE_SLICED_VBI_OUTPUT    = 7,
-	    V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY = 8,
-	    V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE = 9,
-	    V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE  = 10,
-	    V4L2_BUF_TYPE_SDR_CAPTURE          = 11,
-	    V4L2_BUF_TYPE_SDR_OUTPUT           = 12,
-	    /* Deprecated, do not use */
-	    V4L2_BUF_TYPE_PRIVATE              = 0x80,
-    };
-
-    #define V4L2_TYPE_IS_MULTIPLANAR(type)
-	    ((type) == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE
-	     || (type) == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
-
-    #define V4L2_TYPE_IS_OUTPUT(type)
-	    ((type) == V4L2_BUF_TYPE_VIDEO_OUTPUT
-	     || (type) == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE
-	     || (type) == V4L2_BUF_TYPE_VIDEO_OVERLAY
-	     || (type) == V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY
-	     || (type) == V4L2_BUF_TYPE_VBI_OUTPUT
-	     || (type) == V4L2_BUF_TYPE_SLICED_VBI_OUTPUT
-	     || (type) == V4L2_BUF_TYPE_SDR_OUTPUT)
-
-    enum v4l2_tuner_type {
-	    V4L2_TUNER_RADIO             = 1,
-	    V4L2_TUNER_ANALOG_TV         = 2,
-	    V4L2_TUNER_DIGITAL_TV        = 3,
-	    V4L2_TUNER_SDR               = 4,
-	    V4L2_TUNER_RF                = 5,
-    };
-
-    /* Deprecated, do not use */
-    #define V4L2_TUNER_ADC  V4L2_TUNER_SDR
-
-    enum v4l2_memory {
-	    V4L2_MEMORY_MMAP             = 1,
-	    V4L2_MEMORY_USERPTR          = 2,
-	    V4L2_MEMORY_OVERLAY          = 3,
-	    V4L2_MEMORY_DMABUF           = 4,
-    };
-
-    /* see also http://vektor.theorem.ca/graphics/ycbcr/ */
-    enum v4l2_colorspace {
-	    /*
-	     * Default colorspace, i.e.ie; let the driver figure it out.
-	     * Can only be used with video capture.
-	     */
-	    V4L2_COLORSPACE_DEFAULT       = 0,
-
-	    /* SMPTE 170M: used for broadcast NTSC/PAL SDTV */
-	    V4L2_COLORSPACE_SMPTE170M     = 1,
-
-	    /* Obsolete pre-1998 SMPTE 240M HDTV standard, superseded by Rec 709 */
-	    V4L2_COLORSPACE_SMPTE240M     = 2,
-
-	    /* Rec.709: used for HDTV */
-	    V4L2_COLORSPACE_REC709        = 3,
-
-	    /*
-	     * Deprecated, do not use. No driver will ever return this. This was
-	     * based on a misunderstanding of the bt878 datasheet.
-	     */
-	    V4L2_COLORSPACE_BT878         = 4,
-
-	    /*
-	     * NTSC 1953 colorspace. This only makes sense when dealing with
-	     * really, really old NTSC recordings. Superseded by SMPTE 170M.
-	     */
-	    V4L2_COLORSPACE_470_SYSTEM_M  = 5,
-
-	    /*
-	     * EBU Tech 3213 PAL/SECAM colorspace. This only makes sense when
-	     * dealing with really old PAL/SECAM recordings. Superseded by
-	     * SMPTE 170M.
-	     */
-	    V4L2_COLORSPACE_470_SYSTEM_BG = 6,
-
-	    /*
-	     * Effectively shorthand for V4L2_COLORSPACE_SRGB, V4L2_YCBCR_ENC_601
-	     * and V4L2_QUANTIZATION_FULL_RANGE. To be used for (Motion-)JPEG.
-	     */
-	    V4L2_COLORSPACE_JPEG          = 7,
-
-	    /* For RGB colorspaces such as produces by most webcams. */
-	    V4L2_COLORSPACE_SRGB          = 8,
-
-	    /* AdobeRGB colorspace */
-	    V4L2_COLORSPACE_ADOBERGB      = 9,
-
-	    /* BT.2020 colorspace, used for UHDTV. */
-	    V4L2_COLORSPACE_BT2020        = 10,
-
-	    /* Raw colorspace: for RAW unprocessed images */
-	    V4L2_COLORSPACE_RAW           = 11,
-
-	    /* DCI-P3 colorspace, used by cinema projectors */
-	    V4L2_COLORSPACE_DCI_P3        = 12,
-    };
-
-    /*
-     * Determine how COLORSPACE_DEFAULT should map to a proper colorspace.
-     * This depends on whether this is a SDTV image (use SMPTE 170M), an
-     * HDTV image (use Rec. 709), or something else (use sRGB).
-     */
-    #define V4L2_MAP_COLORSPACE_DEFAULT(is_sdtv, is_hdtv)
-	    ((is_sdtv) ? V4L2_COLORSPACE_SMPTE170M :
-	     ((is_hdtv) ? V4L2_COLORSPACE_REC709 : V4L2_COLORSPACE_SRGB))
-
-    enum v4l2_xfer_func {
-	    /*
-	     * Mapping of V4L2_XFER_FUNC_DEFAULT to actual transfer functions
-	     * for the various colorspaces:
-	     *
-	     * V4L2_COLORSPACE_SMPTE170M, V4L2_COLORSPACE_470_SYSTEM_M,
-	     * V4L2_COLORSPACE_470_SYSTEM_BG, V4L2_COLORSPACE_REC709 and
-	     * V4L2_COLORSPACE_BT2020: V4L2_XFER_FUNC_709
-	     *
-	     * V4L2_COLORSPACE_SRGB, V4L2_COLORSPACE_JPEG: V4L2_XFER_FUNC_SRGB
-	     *
-	     * V4L2_COLORSPACE_ADOBERGB: V4L2_XFER_FUNC_ADOBERGB
-	     *
-	     * V4L2_COLORSPACE_SMPTE240M: V4L2_XFER_FUNC_SMPTE240M
-	     *
-	     * V4L2_COLORSPACE_RAW: V4L2_XFER_FUNC_NONE
-	     *
-	     * V4L2_COLORSPACE_DCI_P3: V4L2_XFER_FUNC_DCI_P3
-	     */
-	    V4L2_XFER_FUNC_DEFAULT     = 0,
-	    V4L2_XFER_FUNC_709         = 1,
-	    V4L2_XFER_FUNC_SRGB        = 2,
-	    V4L2_XFER_FUNC_ADOBERGB    = 3,
-	    V4L2_XFER_FUNC_SMPTE240M   = 4,
-	    V4L2_XFER_FUNC_NONE        = 5,
-	    V4L2_XFER_FUNC_DCI_P3      = 6,
-	    V4L2_XFER_FUNC_SMPTE2084   = 7,
-    };
-
-    /*
-     * Determine how XFER_FUNC_DEFAULT should map to a proper transfer function.
-     * This depends on the colorspace.
-     */
-    #define V4L2_MAP_XFER_FUNC_DEFAULT(colsp)
-	    ((colsp) == V4L2_COLORSPACE_ADOBERGB ? V4L2_XFER_FUNC_ADOBERGB :
-	     ((colsp) == V4L2_COLORSPACE_SMPTE240M ? V4L2_XFER_FUNC_SMPTE240M :
-	      ((colsp) == V4L2_COLORSPACE_DCI_P3 ? V4L2_XFER_FUNC_DCI_P3 :
-	       ((colsp) == V4L2_COLORSPACE_RAW ? V4L2_XFER_FUNC_NONE :
-		((colsp) == V4L2_COLORSPACE_SRGB || (colsp) == V4L2_COLORSPACE_JPEG ?
-		 V4L2_XFER_FUNC_SRGB : V4L2_XFER_FUNC_709)))))
-
-    enum v4l2_ycbcr_encoding {
-	    /*
-	     * Mapping of V4L2_YCBCR_ENC_DEFAULT to actual encodings for the
-	     * various colorspaces:
-	     *
-	     * V4L2_COLORSPACE_SMPTE170M, V4L2_COLORSPACE_470_SYSTEM_M,
-	     * V4L2_COLORSPACE_470_SYSTEM_BG, V4L2_COLORSPACE_ADOBERGB and
-	     * V4L2_COLORSPACE_JPEG: V4L2_YCBCR_ENC_601
-	     *
-	     * V4L2_COLORSPACE_REC709 and V4L2_COLORSPACE_DCI_P3: V4L2_YCBCR_ENC_709
-	     *
-	     * V4L2_COLORSPACE_SRGB: V4L2_YCBCR_ENC_SYCC
-	     *
-	     * V4L2_COLORSPACE_BT2020: V4L2_YCBCR_ENC_BT2020
-	     *
-	     * V4L2_COLORSPACE_SMPTE240M: V4L2_YCBCR_ENC_SMPTE240M
-	     */
-	    V4L2_YCBCR_ENC_DEFAULT        = 0,
-
-	    /* ITU-R 601 -- SDTV */
-	    V4L2_YCBCR_ENC_601            = 1,
-
-	    /* Rec. 709 -- HDTV */
-	    V4L2_YCBCR_ENC_709            = 2,
-
-	    /* ITU-R 601/EN 61966-2-4 Extended Gamut -- SDTV */
-	    V4L2_YCBCR_ENC_XV601          = 3,
-
-	    /* Rec. 709/EN 61966-2-4 Extended Gamut -- HDTV */
-	    V4L2_YCBCR_ENC_XV709          = 4,
-
-	    /* sYCC (Y'CbCr encoding of sRGB) */
-	    V4L2_YCBCR_ENC_SYCC           = 5,
-
-	    /* BT.2020 Non-constant Luminance Y'CbCr */
-	    V4L2_YCBCR_ENC_BT2020         = 6,
-
-	    /* BT.2020 Constant Luminance Y'CbcCrc */
-	    V4L2_YCBCR_ENC_BT2020_CONST_LUM = 7,
-
-	    /* SMPTE 240M -- Obsolete HDTV */
-	    V4L2_YCBCR_ENC_SMPTE240M      = 8,
-    };
-
-    /*
-     * Determine how YCBCR_ENC_DEFAULT should map to a proper Y'CbCr encoding.
-     * This depends on the colorspace.
-     */
-    #define V4L2_MAP_YCBCR_ENC_DEFAULT(colsp)
-	    (((colsp) == V4L2_COLORSPACE_REC709 ||
-	      (colsp) == V4L2_COLORSPACE_DCI_P3) ? V4L2_YCBCR_ENC_709 :
-	     ((colsp) == V4L2_COLORSPACE_BT2020 ? V4L2_YCBCR_ENC_BT2020 :
-	      ((colsp) == V4L2_COLORSPACE_SMPTE240M ? V4L2_YCBCR_ENC_SMPTE240M :
-	       V4L2_YCBCR_ENC_601)))
-
-    enum v4l2_quantization {
-	    /*
-	     * The default for R'G'B' quantization is always full range, except
-	     * for the BT2020 colorspace. For Y'CbCr the quantization is always
-	     * limited range, except for COLORSPACE_JPEG, SYCC, XV601 or XV709:
-	     * those are full range.
-	     */
-	    V4L2_QUANTIZATION_DEFAULT     = 0,
-	    V4L2_QUANTIZATION_FULL_RANGE  = 1,
-	    V4L2_QUANTIZATION_LIM_RANGE   = 2,
-    };
-
-    /*
-     * Determine how QUANTIZATION_DEFAULT should map to a proper quantization.
-     * This depends on whether the image is RGB or not, the colorspace and the
-     * Y'CbCr encoding.
-     */
-    #define V4L2_MAP_QUANTIZATION_DEFAULT(is_rgb, colsp, ycbcr_enc)
-	    (((is_rgb) && (colsp) == V4L2_COLORSPACE_BT2020) ? V4L2_QUANTIZATION_LIM_RANGE :
-	     (((is_rgb) || (ycbcr_enc) == V4L2_YCBCR_ENC_XV601 ||
-	      (ycbcr_enc) == V4L2_YCBCR_ENC_XV709 || (colsp) == V4L2_COLORSPACE_JPEG) ?
-	     V4L2_QUANTIZATION_FULL_RANGE : V4L2_QUANTIZATION_LIM_RANGE))
-
-    enum v4l2_priority {
-	    V4L2_PRIORITY_UNSET       = 0,  /* not initialized */
-	    V4L2_PRIORITY_BACKGROUND  = 1,
-	    V4L2_PRIORITY_INTERACTIVE = 2,
-	    V4L2_PRIORITY_RECORD      = 3,
-	    V4L2_PRIORITY_DEFAULT     = V4L2_PRIORITY_INTERACTIVE,
-    };
-
-    struct v4l2_rect {
-	    __s32   left;
-	    __s32   top;
-	    __u32   width;
-	    __u32   height;
-    };
-
-    struct v4l2_fract {
-	    __u32   numerator;
-	    __u32   denominator;
-    };
-
-    /**
-      * struct v4l2_capability - Describes V4L2 device caps returned by VIDIOC_QUERYCAP
-      *
-      * @driver:       name of the driver module (e.g. "bttv")
-      * @card:         name of the card (e.g. "Hauppauge WinTV")
-      * @bus_info:     name of the bus (e.g. "PCI:" + pci_name(pci_dev) )
-      * @version:      KERNEL_VERSION
-      * @capabilities: capabilities of the physical device as a whole
-      * @device_caps:  capabilities accessed via this particular device (node)
-      * @reserved:     reserved fields for future extensions
-      */
-    struct v4l2_capability {
-	    __u8    driver[16];
-	    __u8    card[32];
-	    __u8    bus_info[32];
-	    __u32   version;
-	    __u32   capabilities;
-	    __u32   device_caps;
-	    __u32   reserved[3];
-    };
-
-    /* Values for 'capabilities' field */
-    #define V4L2_CAP_VIDEO_CAPTURE          0x00000001  /* Is a video capture device */
-    #define V4L2_CAP_VIDEO_OUTPUT           0x00000002  /* Is a video output device */
-    #define V4L2_CAP_VIDEO_OVERLAY          0x00000004  /* Can do video overlay */
-    #define V4L2_CAP_VBI_CAPTURE            0x00000010  /* Is a raw VBI capture device */
-    #define V4L2_CAP_VBI_OUTPUT             0x00000020  /* Is a raw VBI output device */
-    #define V4L2_CAP_SLICED_VBI_CAPTURE     0x00000040  /* Is a sliced VBI capture device */
-    #define V4L2_CAP_SLICED_VBI_OUTPUT      0x00000080  /* Is a sliced VBI output device */
-    #define V4L2_CAP_RDS_CAPTURE            0x00000100  /* RDS data capture */
-    #define V4L2_CAP_VIDEO_OUTPUT_OVERLAY   0x00000200  /* Can do video output overlay */
-    #define V4L2_CAP_HW_FREQ_SEEK           0x00000400  /* Can do hardware frequency seek  */
-    #define V4L2_CAP_RDS_OUTPUT             0x00000800  /* Is an RDS encoder */
-
-    /* Is a video capture device that supports multiplanar formats */
-    #define V4L2_CAP_VIDEO_CAPTURE_MPLANE   0x00001000
-    /* Is a video output device that supports multiplanar formats */
-    #define V4L2_CAP_VIDEO_OUTPUT_MPLANE    0x00002000
-    /* Is a video mem-to-mem device that supports multiplanar formats */
-    #define V4L2_CAP_VIDEO_M2M_MPLANE       0x00004000
-    /* Is a video mem-to-mem device */
-    #define V4L2_CAP_VIDEO_M2M              0x00008000
-
-    #define V4L2_CAP_TUNER                  0x00010000  /* has a tuner */
-    #define V4L2_CAP_AUDIO                  0x00020000  /* has audio support */
-    #define V4L2_CAP_RADIO                  0x00040000  /* is a radio device */
-    #define V4L2_CAP_MODULATOR              0x00080000  /* has a modulator */
-
-    #define V4L2_CAP_SDR_CAPTURE            0x00100000  /* Is a SDR capture device */
-    #define V4L2_CAP_EXT_PIX_FORMAT         0x00200000  /* Supports the extended pixel format */
-    #define V4L2_CAP_SDR_OUTPUT             0x00400000  /* Is a SDR output device */
-
-    #define V4L2_CAP_READWRITE              0x01000000  /* read/write systemcalls */
-    #define V4L2_CAP_ASYNCIO                0x02000000  /* async I/O */
-    #define V4L2_CAP_STREAMING              0x04000000  /* streaming I/O ioctls */
-
-    #define V4L2_CAP_DEVICE_CAPS            0x80000000  /* sets device capabilities field */
-
-    /*
-     *      V I D E O   I M A G E   F O R M A T
-     */
-    struct v4l2_pix_format {
-	    __u32                   width;
-	    __u32                   height;
-	    __u32                   pixelformat;
-	    __u32                   field;          /* enum v4l2_field */
-	    __u32                   bytesperline;   /* for padding, zero if unused */
-	    __u32                   sizeimage;
-	    __u32                   colorspace;     /* enum v4l2_colorspace */
-	    __u32                   priv;           /* private data, depends on pixelformat */
-	    __u32                   flags;          /* format flags (V4L2_PIX_FMT_FLAG_*) */
-	    __u32                   ycbcr_enc;      /* enum v4l2_ycbcr_encoding */
-	    __u32                   quantization;   /* enum v4l2_quantization */
-	    __u32                   xfer_func;      /* enum v4l2_xfer_func */
-    };
-
-    /*      Pixel format         FOURCC                          depth  Description  */
-
-    /* RGB formats */
-    #define V4L2_PIX_FMT_RGB332  v4l2_fourcc('R', 'G', 'B', '1') /*  8  RGB-3-3-2     */
-    #define V4L2_PIX_FMT_RGB444  v4l2_fourcc('R', '4', '4', '4') /* 16  xxxxrrrr ggggbbbb */
-    #define V4L2_PIX_FMT_ARGB444 v4l2_fourcc('A', 'R', '1', '2') /* 16  aaaarrrr ggggbbbb */
-    #define V4L2_PIX_FMT_XRGB444 v4l2_fourcc('X', 'R', '1', '2') /* 16  xxxxrrrr ggggbbbb */
-    #define V4L2_PIX_FMT_RGB555  v4l2_fourcc('R', 'G', 'B', 'O') /* 16  RGB-5-5-5     */
-    #define V4L2_PIX_FMT_ARGB555 v4l2_fourcc('A', 'R', '1', '5') /* 16  ARGB-1-5-5-5  */
-    #define V4L2_PIX_FMT_XRGB555 v4l2_fourcc('X', 'R', '1', '5') /* 16  XRGB-1-5-5-5  */
-    #define V4L2_PIX_FMT_RGB565  v4l2_fourcc('R', 'G', 'B', 'P') /* 16  RGB-5-6-5     */
-    #define V4L2_PIX_FMT_RGB555X v4l2_fourcc('R', 'G', 'B', 'Q') /* 16  RGB-5-5-5 BE  */
-    #define V4L2_PIX_FMT_ARGB555X v4l2_fourcc_be('A', 'R', '1', '5') /* 16  ARGB-5-5-5 BE */
-    #define V4L2_PIX_FMT_XRGB555X v4l2_fourcc_be('X', 'R', '1', '5') /* 16  XRGB-5-5-5 BE */
-    #define V4L2_PIX_FMT_RGB565X v4l2_fourcc('R', 'G', 'B', 'R') /* 16  RGB-5-6-5 BE  */
-    #define V4L2_PIX_FMT_BGR666  v4l2_fourcc('B', 'G', 'R', 'H') /* 18  BGR-6-6-6     */
-    #define V4L2_PIX_FMT_BGR24   v4l2_fourcc('B', 'G', 'R', '3') /* 24  BGR-8-8-8     */
-    #define V4L2_PIX_FMT_RGB24   v4l2_fourcc('R', 'G', 'B', '3') /* 24  RGB-8-8-8     */
-    #define V4L2_PIX_FMT_BGR32   v4l2_fourcc('B', 'G', 'R', '4') /* 32  BGR-8-8-8-8   */
-    #define V4L2_PIX_FMT_ABGR32  v4l2_fourcc('A', 'R', '2', '4') /* 32  BGRA-8-8-8-8  */
-    #define V4L2_PIX_FMT_XBGR32  v4l2_fourcc('X', 'R', '2', '4') /* 32  BGRX-8-8-8-8  */
-    #define V4L2_PIX_FMT_RGB32   v4l2_fourcc('R', 'G', 'B', '4') /* 32  RGB-8-8-8-8   */
-    #define V4L2_PIX_FMT_ARGB32  v4l2_fourcc('B', 'A', '2', '4') /* 32  ARGB-8-8-8-8  */
-    #define V4L2_PIX_FMT_XRGB32  v4l2_fourcc('B', 'X', '2', '4') /* 32  XRGB-8-8-8-8  */
-
-    /* Grey formats */
-    #define V4L2_PIX_FMT_GREY    v4l2_fourcc('G', 'R', 'E', 'Y') /*  8  Greyscale     */
-    #define V4L2_PIX_FMT_Y4      v4l2_fourcc('Y', '0', '4', ' ') /*  4  Greyscale     */
-    #define V4L2_PIX_FMT_Y6      v4l2_fourcc('Y', '0', '6', ' ') /*  6  Greyscale     */
-    #define V4L2_PIX_FMT_Y10     v4l2_fourcc('Y', '1', '0', ' ') /* 10  Greyscale     */
-    #define V4L2_PIX_FMT_Y12     v4l2_fourcc('Y', '1', '2', ' ') /* 12  Greyscale     */
-    #define V4L2_PIX_FMT_Y16     v4l2_fourcc('Y', '1', '6', ' ') /* 16  Greyscale     */
-    #define V4L2_PIX_FMT_Y16_BE  v4l2_fourcc_be('Y', '1', '6', ' ') /* 16  Greyscale BE  */
-
-    /* Grey bit-packed formats */
-    #define V4L2_PIX_FMT_Y10BPACK    v4l2_fourcc('Y', '1', '0', 'B') /* 10  Greyscale bit-packed */
-
-    /* Palette formats */
-    #define V4L2_PIX_FMT_PAL8    v4l2_fourcc('P', 'A', 'L', '8') /*  8  8-bit palette */
-
-    /* Chrominance formats */
-    #define V4L2_PIX_FMT_UV8     v4l2_fourcc('U', 'V', '8', ' ') /*  8  UV 4:4 */
-
-    /* Luminance+Chrominance formats */
-    #define V4L2_PIX_FMT_YVU410  v4l2_fourcc('Y', 'V', 'U', '9') /*  9  YVU 4:1:0     */
-    #define V4L2_PIX_FMT_YVU420  v4l2_fourcc('Y', 'V', '1', '2') /* 12  YVU 4:2:0     */
-    #define V4L2_PIX_FMT_YUYV    v4l2_fourcc('Y', 'U', 'Y', 'V') /* 16  YUV 4:2:2     */
-    #define V4L2_PIX_FMT_YYUV    v4l2_fourcc('Y', 'Y', 'U', 'V') /* 16  YUV 4:2:2     */
-    #define V4L2_PIX_FMT_YVYU    v4l2_fourcc('Y', 'V', 'Y', 'U') /* 16 YVU 4:2:2 */
-    #define V4L2_PIX_FMT_UYVY    v4l2_fourcc('U', 'Y', 'V', 'Y') /* 16  YUV 4:2:2     */
-    #define V4L2_PIX_FMT_VYUY    v4l2_fourcc('V', 'Y', 'U', 'Y') /* 16  YUV 4:2:2     */
-    #define V4L2_PIX_FMT_YUV422P v4l2_fourcc('4', '2', '2', 'P') /* 16  YVU422 planar */
-    #define V4L2_PIX_FMT_YUV411P v4l2_fourcc('4', '1', '1', 'P') /* 16  YVU411 planar */
-    #define V4L2_PIX_FMT_Y41P    v4l2_fourcc('Y', '4', '1', 'P') /* 12  YUV 4:1:1     */
-    #define V4L2_PIX_FMT_YUV444  v4l2_fourcc('Y', '4', '4', '4') /* 16  xxxxyyyy uuuuvvvv */
-    #define V4L2_PIX_FMT_YUV555  v4l2_fourcc('Y', 'U', 'V', 'O') /* 16  YUV-5-5-5     */
-    #define V4L2_PIX_FMT_YUV565  v4l2_fourcc('Y', 'U', 'V', 'P') /* 16  YUV-5-6-5     */
-    #define V4L2_PIX_FMT_YUV32   v4l2_fourcc('Y', 'U', 'V', '4') /* 32  YUV-8-8-8-8   */
-    #define V4L2_PIX_FMT_YUV410  v4l2_fourcc('Y', 'U', 'V', '9') /*  9  YUV 4:1:0     */
-    #define V4L2_PIX_FMT_YUV420  v4l2_fourcc('Y', 'U', '1', '2') /* 12  YUV 4:2:0     */
-    #define V4L2_PIX_FMT_HI240   v4l2_fourcc('H', 'I', '2', '4') /*  8  8-bit color   */
-    #define V4L2_PIX_FMT_HM12    v4l2_fourcc('H', 'M', '1', '2') /*  8  YUV 4:2:0 16x16 macroblocks */
-    #define V4L2_PIX_FMT_M420    v4l2_fourcc('M', '4', '2', '0') /* 12  YUV 4:2:0 2 lines y, 1 line uv interleaved */
-
-    /* two planes -- one Y, one Cr + Cb interleaved  */
-    #define V4L2_PIX_FMT_NV12    v4l2_fourcc('N', 'V', '1', '2') /* 12  Y/CbCr 4:2:0  */
-    #define V4L2_PIX_FMT_NV21    v4l2_fourcc('N', 'V', '2', '1') /* 12  Y/CrCb 4:2:0  */
-    #define V4L2_PIX_FMT_NV16    v4l2_fourcc('N', 'V', '1', '6') /* 16  Y/CbCr 4:2:2  */
-    #define V4L2_PIX_FMT_NV61    v4l2_fourcc('N', 'V', '6', '1') /* 16  Y/CrCb 4:2:2  */
-    #define V4L2_PIX_FMT_NV24    v4l2_fourcc('N', 'V', '2', '4') /* 24  Y/CbCr 4:4:4  */
-    #define V4L2_PIX_FMT_NV42    v4l2_fourcc('N', 'V', '4', '2') /* 24  Y/CrCb 4:4:4  */
-
-    /* two non contiguous planes - one Y, one Cr + Cb interleaved  */
-    #define V4L2_PIX_FMT_NV12M   v4l2_fourcc('N', 'M', '1', '2') /* 12  Y/CbCr 4:2:0  */
-    #define V4L2_PIX_FMT_NV21M   v4l2_fourcc('N', 'M', '2', '1') /* 21  Y/CrCb 4:2:0  */
-    #define V4L2_PIX_FMT_NV16M   v4l2_fourcc('N', 'M', '1', '6') /* 16  Y/CbCr 4:2:2  */
-    #define V4L2_PIX_FMT_NV61M   v4l2_fourcc('N', 'M', '6', '1') /* 16  Y/CrCb 4:2:2  */
-    #define V4L2_PIX_FMT_NV12MT  v4l2_fourcc('T', 'M', '1', '2') /* 12  Y/CbCr 4:2:0 64x32 macroblocks */
-    #define V4L2_PIX_FMT_NV12MT_16X16 v4l2_fourcc('V', 'M', '1', '2') /* 12  Y/CbCr 4:2:0 16x16 macroblocks */
-
-    /* three non contiguous planes - Y, Cb, Cr */
-    #define V4L2_PIX_FMT_YUV420M v4l2_fourcc('Y', 'M', '1', '2') /* 12  YUV420 planar */
-    #define V4L2_PIX_FMT_YVU420M v4l2_fourcc('Y', 'M', '2', '1') /* 12  YVU420 planar */
-    #define V4L2_PIX_FMT_YUV422M v4l2_fourcc('Y', 'M', '1', '6') /* 16  YUV422 planar */
-    #define V4L2_PIX_FMT_YVU422M v4l2_fourcc('Y', 'M', '6', '1') /* 16  YVU422 planar */
-    #define V4L2_PIX_FMT_YUV444M v4l2_fourcc('Y', 'M', '2', '4') /* 24  YUV444 planar */
-    #define V4L2_PIX_FMT_YVU444M v4l2_fourcc('Y', 'M', '4', '2') /* 24  YVU444 planar */
-
-    /* Bayer formats - see http://www.siliconimaging.com/RGB%20Bayer.htm */
-    #define V4L2_PIX_FMT_SBGGR8  v4l2_fourcc('B', 'A', '8', '1') /*  8  BGBG.. GRGR.. */
-    #define V4L2_PIX_FMT_SGBRG8  v4l2_fourcc('G', 'B', 'R', 'G') /*  8  GBGB.. RGRG.. */
-    #define V4L2_PIX_FMT_SGRBG8  v4l2_fourcc('G', 'R', 'B', 'G') /*  8  GRGR.. BGBG.. */
-    #define V4L2_PIX_FMT_SRGGB8  v4l2_fourcc('R', 'G', 'G', 'B') /*  8  RGRG.. GBGB.. */
-    #define V4L2_PIX_FMT_SBGGR10 v4l2_fourcc('B', 'G', '1', '0') /* 10  BGBG.. GRGR.. */
-    #define V4L2_PIX_FMT_SGBRG10 v4l2_fourcc('G', 'B', '1', '0') /* 10  GBGB.. RGRG.. */
-    #define V4L2_PIX_FMT_SGRBG10 v4l2_fourcc('B', 'A', '1', '0') /* 10  GRGR.. BGBG.. */
-    #define V4L2_PIX_FMT_SRGGB10 v4l2_fourcc('R', 'G', '1', '0') /* 10  RGRG.. GBGB.. */
-	    /* 10bit raw bayer packed, 5 bytes for every 4 pixels */
-    #define V4L2_PIX_FMT_SBGGR10P v4l2_fourcc('p', 'B', 'A', 'A')
-    #define V4L2_PIX_FMT_SGBRG10P v4l2_fourcc('p', 'G', 'A', 'A')
-    #define V4L2_PIX_FMT_SGRBG10P v4l2_fourcc('p', 'g', 'A', 'A')
-    #define V4L2_PIX_FMT_SRGGB10P v4l2_fourcc('p', 'R', 'A', 'A')
-	    /* 10bit raw bayer a-law compressed to 8 bits */
-    #define V4L2_PIX_FMT_SBGGR10ALAW8 v4l2_fourcc('a', 'B', 'A', '8')
-    #define V4L2_PIX_FMT_SGBRG10ALAW8 v4l2_fourcc('a', 'G', 'A', '8')
-    #define V4L2_PIX_FMT_SGRBG10ALAW8 v4l2_fourcc('a', 'g', 'A', '8')
-    #define V4L2_PIX_FMT_SRGGB10ALAW8 v4l2_fourcc('a', 'R', 'A', '8')
-	    /* 10bit raw bayer DPCM compressed to 8 bits */
-    #define V4L2_PIX_FMT_SBGGR10DPCM8 v4l2_fourcc('b', 'B', 'A', '8')
-    #define V4L2_PIX_FMT_SGBRG10DPCM8 v4l2_fourcc('b', 'G', 'A', '8')
-    #define V4L2_PIX_FMT_SGRBG10DPCM8 v4l2_fourcc('B', 'D', '1', '0')
-    #define V4L2_PIX_FMT_SRGGB10DPCM8 v4l2_fourcc('b', 'R', 'A', '8')
-    #define V4L2_PIX_FMT_SBGGR12 v4l2_fourcc('B', 'G', '1', '2') /* 12  BGBG.. GRGR.. */
-    #define V4L2_PIX_FMT_SGBRG12 v4l2_fourcc('G', 'B', '1', '2') /* 12  GBGB.. RGRG.. */
-    #define V4L2_PIX_FMT_SGRBG12 v4l2_fourcc('B', 'A', '1', '2') /* 12  GRGR.. BGBG.. */
-    #define V4L2_PIX_FMT_SRGGB12 v4l2_fourcc('R', 'G', '1', '2') /* 12  RGRG.. GBGB.. */
-    #define V4L2_PIX_FMT_SBGGR16 v4l2_fourcc('B', 'Y', 'R', '2') /* 16  BGBG.. GRGR.. */
-
-    /* compressed formats */
-    #define V4L2_PIX_FMT_MJPEG    v4l2_fourcc('M', 'J', 'P', 'G') /* Motion-JPEG   */
-    #define V4L2_PIX_FMT_JPEG     v4l2_fourcc('J', 'P', 'E', 'G') /* JFIF JPEG     */
-    #define V4L2_PIX_FMT_DV       v4l2_fourcc('d', 'v', 's', 'd') /* 1394          */
-    #define V4L2_PIX_FMT_MPEG     v4l2_fourcc('M', 'P', 'E', 'G') /* MPEG-1/2/4 Multiplexed */
-    #define V4L2_PIX_FMT_H264     v4l2_fourcc('H', '2', '6', '4') /* H264 with start codes */
-    #define V4L2_PIX_FMT_H264_NO_SC v4l2_fourcc('A', 'V', 'C', '1') /* H264 without start codes */
-    #define V4L2_PIX_FMT_H264_MVC v4l2_fourcc('M', '2', '6', '4') /* H264 MVC */
-    #define V4L2_PIX_FMT_H263     v4l2_fourcc('H', '2', '6', '3') /* H263          */
-    #define V4L2_PIX_FMT_MPEG1    v4l2_fourcc('M', 'P', 'G', '1') /* MPEG-1 ES     */
-    #define V4L2_PIX_FMT_MPEG2    v4l2_fourcc('M', 'P', 'G', '2') /* MPEG-2 ES     */
-    #define V4L2_PIX_FMT_MPEG4    v4l2_fourcc('M', 'P', 'G', '4') /* MPEG-4 part 2 ES */
-    #define V4L2_PIX_FMT_XVID     v4l2_fourcc('X', 'V', 'I', 'D') /* Xvid           */
-    #define V4L2_PIX_FMT_VC1_ANNEX_G v4l2_fourcc('V', 'C', '1', 'G') /* SMPTE 421M Annex G compliant stream */
-    #define V4L2_PIX_FMT_VC1_ANNEX_L v4l2_fourcc('V', 'C', '1', 'L') /* SMPTE 421M Annex L compliant stream */
-    #define V4L2_PIX_FMT_VP8      v4l2_fourcc('V', 'P', '8', '0') /* VP8 */
-
-    /*  Vendor-specific formats   */
-    #define V4L2_PIX_FMT_CPIA1    v4l2_fourcc('C', 'P', 'I', 'A') /* cpia1 YUV */
-    #define V4L2_PIX_FMT_WNVA     v4l2_fourcc('W', 'N', 'V', 'A') /* Winnov hw compress */
-    #define V4L2_PIX_FMT_SN9C10X  v4l2_fourcc('S', '9', '1', '0') /* SN9C10x compression */
-    #define V4L2_PIX_FMT_SN9C20X_I420 v4l2_fourcc('S', '9', '2', '0') /* SN9C20x YUV 4:2:0 */
-    #define V4L2_PIX_FMT_PWC1     v4l2_fourcc('P', 'W', 'C', '1') /* pwc older webcam */
-    #define V4L2_PIX_FMT_PWC2     v4l2_fourcc('P', 'W', 'C', '2') /* pwc newer webcam */
-    #define V4L2_PIX_FMT_ET61X251 v4l2_fourcc('E', '6', '2', '5') /* ET61X251 compression */
-    #define V4L2_PIX_FMT_SPCA501  v4l2_fourcc('S', '5', '0', '1') /* YUYV per line */
-    #define V4L2_PIX_FMT_SPCA505  v4l2_fourcc('S', '5', '0', '5') /* YYUV per line */
-    #define V4L2_PIX_FMT_SPCA508  v4l2_fourcc('S', '5', '0', '8') /* YUVY per line */
-    #define V4L2_PIX_FMT_SPCA561  v4l2_fourcc('S', '5', '6', '1') /* compressed GBRG bayer */
-    #define V4L2_PIX_FMT_PAC207   v4l2_fourcc('P', '2', '0', '7') /* compressed BGGR bayer */
-    #define V4L2_PIX_FMT_MR97310A v4l2_fourcc('M', '3', '1', '0') /* compressed BGGR bayer */
-    #define V4L2_PIX_FMT_JL2005BCD v4l2_fourcc('J', 'L', '2', '0') /* compressed RGGB bayer */
-    #define V4L2_PIX_FMT_SN9C2028 v4l2_fourcc('S', 'O', 'N', 'X') /* compressed GBRG bayer */
-    #define V4L2_PIX_FMT_SQ905C   v4l2_fourcc('9', '0', '5', 'C') /* compressed RGGB bayer */
-    #define V4L2_PIX_FMT_PJPG     v4l2_fourcc('P', 'J', 'P', 'G') /* Pixart 73xx JPEG */
-    #define V4L2_PIX_FMT_OV511    v4l2_fourcc('O', '5', '1', '1') /* ov511 JPEG */
-    #define V4L2_PIX_FMT_OV518    v4l2_fourcc('O', '5', '1', '8') /* ov518 JPEG */
-    #define V4L2_PIX_FMT_STV0680  v4l2_fourcc('S', '6', '8', '0') /* stv0680 bayer */
-    #define V4L2_PIX_FMT_TM6000   v4l2_fourcc('T', 'M', '6', '0') /* tm5600/tm60x0 */
-    #define V4L2_PIX_FMT_CIT_YYVYUY v4l2_fourcc('C', 'I', 'T', 'V') /* one line of Y then 1 line of VYUY */
-    #define V4L2_PIX_FMT_KONICA420  v4l2_fourcc('K', 'O', 'N', 'I') /* YUV420 planar in blocks of 256 pixels */
-    #define V4L2_PIX_FMT_JPGL       v4l2_fourcc('J', 'P', 'G', 'L') /* JPEG-Lite */
-    #define V4L2_PIX_FMT_SE401      v4l2_fourcc('S', '4', '0', '1') /* se401 janggu compressed rgb */
-    #define V4L2_PIX_FMT_S5C_UYVY_JPG v4l2_fourcc('S', '5', 'C', 'I') /* S5C73M3 interleaved UYVY/JPEG */
-    #define V4L2_PIX_FMT_Y8I      v4l2_fourcc('Y', '8', 'I', ' ') /* Greyscale 8-bit L/R interleaved */
-    #define V4L2_PIX_FMT_Y12I     v4l2_fourcc('Y', '1', '2', 'I') /* Greyscale 12-bit L/R interleaved */
-    #define V4L2_PIX_FMT_Z16      v4l2_fourcc('Z', '1', '6', ' ') /* Depth data 16-bit */
-
-    /* SDR formats - used only for Software Defined Radio devices */
-    #define V4L2_SDR_FMT_CU8          v4l2_fourcc('C', 'U', '0', '8') /* IQ u8 */
-    #define V4L2_SDR_FMT_CU16LE       v4l2_fourcc('C', 'U', '1', '6') /* IQ u16le */
-    #define V4L2_SDR_FMT_CS8          v4l2_fourcc('C', 'S', '0', '8') /* complex s8 */
-    #define V4L2_SDR_FMT_CS14LE       v4l2_fourcc('C', 'S', '1', '4') /* complex s14le */
-    #define V4L2_SDR_FMT_RU12LE       v4l2_fourcc('R', 'U', '1', '2') /* real u12le */
-
-    /* priv field value to indicates that subsequent fields are valid. */
-    #define V4L2_PIX_FMT_PRIV_MAGIC         0xfeedcafe
-
-    /* Flags */
-    #define V4L2_PIX_FMT_FLAG_PREMUL_ALPHA  0x00000001
-
-    /*
-     *      F O R M A T   E N U M E R A T I O N
-     */
-    struct v4l2_fmtdesc {
-	    __u32               index;             /* Format number      */
-	    __u32               type;              /* enum v4l2_buf_type */
-	    __u32               flags;
-	    __u8                description[32];   /* Description string */
-	    __u32               pixelformat;       /* Format fourcc      */
-	    __u32               reserved[4];
-    };
-
-    #define V4L2_FMT_FLAG_COMPRESSED 0x0001
-    #define V4L2_FMT_FLAG_EMULATED   0x0002
-
-	    /* Frame Size and frame rate enumeration */
-    /*
-     *      F R A M E   S I Z E   E N U M E R A T I O N
-     */
-    enum v4l2_frmsizetypes {
-	    V4L2_FRMSIZE_TYPE_DISCRETE      = 1,
-	    V4L2_FRMSIZE_TYPE_CONTINUOUS    = 2,
-	    V4L2_FRMSIZE_TYPE_STEPWISE      = 3,
-    };
-
-    struct v4l2_frmsize_discrete {
-	    __u32                   width;          /* Frame width [pixel] */
-	    __u32                   height;         /* Frame height [pixel] */
-    };
-
-    struct v4l2_frmsize_stepwise {
-	    __u32                   min_width;      /* Minimum frame width [pixel] */
-	    __u32                   max_width;      /* Maximum frame width [pixel] */
-	    __u32                   step_width;     /* Frame width step size [pixel] */
-	    __u32                   min_height;     /* Minimum frame height [pixel] */
-	    __u32                   max_height;     /* Maximum frame height [pixel] */
-	    __u32                   step_height;    /* Frame height step size [pixel] */
-    };
-
-    struct v4l2_frmsizeenum {
-	    __u32                   index;          /* Frame size number */
-	    __u32                   pixel_format;   /* Pixel format */
-	    __u32                   type;           /* Frame size type the device supports. */
-
-	    union {                                 /* Frame size */
-		    struct v4l2_frmsize_discrete    discrete;
-		    struct v4l2_frmsize_stepwise    stepwise;
-	    };
-
-	    __u32   reserved[2];                    /* Reserved space for future use */
-    };
-
-    /*
-     *      F R A M E   R A T E   E N U M E R A T I O N
-     */
-    enum v4l2_frmivaltypes {
-	    V4L2_FRMIVAL_TYPE_DISCRETE      = 1,
-	    V4L2_FRMIVAL_TYPE_CONTINUOUS    = 2,
-	    V4L2_FRMIVAL_TYPE_STEPWISE      = 3,
-    };
-
-    struct v4l2_frmival_stepwise {
-	    struct v4l2_fract       min;            /* Minimum frame interval [s] */
-	    struct v4l2_fract       max;            /* Maximum frame interval [s] */
-	    struct v4l2_fract       step;           /* Frame interval step size [s] */
-    };
-
-    struct v4l2_frmivalenum {
-	    __u32                   index;          /* Frame format index */
-	    __u32                   pixel_format;   /* Pixel format */
-	    __u32                   width;          /* Frame width */
-	    __u32                   height;         /* Frame height */
-	    __u32                   type;           /* Frame interval type the device supports. */
-
-	    union {                                 /* Frame interval */
-		    struct v4l2_fract               discrete;
-		    struct v4l2_frmival_stepwise    stepwise;
-	    };
-
-	    __u32   reserved[2];                    /* Reserved space for future use */
-    };
-
-    /*
-     *      T I M E C O D E
-     */
-    struct v4l2_timecode {
-	    __u32   type;
-	    __u32   flags;
-	    __u8    frames;
-	    __u8    seconds;
-	    __u8    minutes;
-	    __u8    hours;
-	    __u8    userbits[4];
-    };
-
-    /*  Type  */
-    #define V4L2_TC_TYPE_24FPS              1
-    #define V4L2_TC_TYPE_25FPS              2
-    #define V4L2_TC_TYPE_30FPS              3
-    #define V4L2_TC_TYPE_50FPS              4
-    #define V4L2_TC_TYPE_60FPS              5
-
-    /*  Flags  */
-    #define V4L2_TC_FLAG_DROPFRAME          0x0001 /* "drop-frame" mode */
-    #define V4L2_TC_FLAG_COLORFRAME         0x0002
-    #define V4L2_TC_USERBITS_field          0x000C
-    #define V4L2_TC_USERBITS_USERDEFINED    0x0000
-    #define V4L2_TC_USERBITS_8BITCHARS      0x0008
-    /* The above is based on SMPTE timecodes */
-
-    struct v4l2_jpegcompression {
-	    int quality;
-
-	    int  APPn;              /* Number of APP segment to be written,
-				     * must be 0..15 */
-	    int  APP_len;           /* Length of data in JPEG APPn segment */
-	    char APP_data[60];      /* Data in the JPEG APPn segment. */
-
-	    int  COM_len;           /* Length of data in JPEG COM segment */
-	    char COM_data[60];      /* Data in JPEG COM segment */
-
-	    __u32 jpeg_markers;     /* Which markers should go into the JPEG
-				     * output. Unless you exactly know what
-				     * you do, leave them untouched.
-				     * Including less markers will make the
-				     * resulting code smaller, but there will
-				     * be fewer applications which can read it.
-				     * The presence of the APP and COM marker
-				     * is influenced by APP_len and COM_len
-				     * ONLY, not by this property! */
-
-    #define V4L2_JPEG_MARKER_DHT (1<<3)    /* Define Huffman Tables */
-    #define V4L2_JPEG_MARKER_DQT (1<<4)    /* Define Quantization Tables */
-    #define V4L2_JPEG_MARKER_DRI (1<<5)    /* Define Restart Interval */
-    #define V4L2_JPEG_MARKER_COM (1<<6)    /* Comment segment */
-    #define V4L2_JPEG_MARKER_APP (1<<7)    /* App segment, driver will
-					    * always use APP0 */
-    };
-
-    /*
-     *      M E M O R Y - M A P P I N G   B U F F E R S
-     */
-    struct v4l2_requestbuffers {
-	    __u32                   count;
-	    __u32                   type;           /* enum v4l2_buf_type */
-	    __u32                   memory;         /* enum v4l2_memory */
-	    __u32                   reserved[2];
-    };
-
-    /**
-     * struct v4l2_plane - plane info for multi-planar buffers
-     * @bytesused:          number of bytes occupied by data in the plane (payload)
-     * @length:             size of this plane (NOT the payload) in bytes
-     * @mem_offset:         when memory in the associated struct v4l2_buffer is
-     *                      V4L2_MEMORY_MMAP, equals the offset from the start of
-     *                      the device memory for this plane (or is a "cookie" that
-     *                      should be passed to mmap() called on the video node)
-     * @userptr:            when memory is V4L2_MEMORY_USERPTR, a userspace pointer
-     *                      pointing to this plane
-     * @fd:                 when memory is V4L2_MEMORY_DMABUF, a userspace file
-     *                      descriptor associated with this plane
-     * @data_offset:        offset in the plane to the start of data; usually 0,
-     *                      unless there is a header in front of the data
-     *
-     * Multi-planar buffers consist of one or more planes, e.g. an YCbCr buffer
-     * with two planes can have one plane for Y, and another for interleaved CbCr
-     * components. Each plane can reside in a separate memory buffer, or even in
-     * a completely separate memory node (e.g. in embedded devices).
-     */
-    struct v4l2_plane {
-	    __u32                   bytesused;
-	    __u32                   length;
-	    union {
-		    __u32           mem_offset;
-		    unsigned long   userptr;
-		    __s32           fd;
-	    } m;
-	    __u32                   data_offset;
-	    __u32                   reserved[11];
-    };
-
-    /**
-     * struct v4l2_buffer - video buffer info
-     * @index:      id number of the buffer
-     * @type:       enum v4l2_buf_type; buffer type (type == *_MPLANE for
-     *              multiplanar buffers);
-     * @bytesused:  number of bytes occupied by data in the buffer (payload);
-     *              unused (set to 0) for multiplanar buffers
-     * @flags:      buffer informational flags
-     * @field:      enum v4l2_field; field order of the image in the buffer
-     * @timestamp:  frame timestamp
-     * @timecode:   frame timecode
-     * @sequence:   sequence count of this frame
-     * @memory:     enum v4l2_memory; the method, in which the actual video data is
-     *              passed
-     * @offset:     for non-multiplanar buffers with memory == V4L2_MEMORY_MMAP;
-     *              offset from the start of the device memory for this plane,
-     *              (or a "cookie" that should be passed to mmap() as offset)
-     * @userptr:    for non-multiplanar buffers with memory == V4L2_MEMORY_USERPTR;
-     *              a userspace pointer pointing to this buffer
-     * @fd:         for non-multiplanar buffers with memory == V4L2_MEMORY_DMABUF;
-     *              a userspace file descriptor associated with this buffer
-     * @planes:     for multiplanar buffers; userspace pointer to the array of plane
-     *              info structs for this buffer
-     * @length:     size in bytes of the buffer (NOT its payload) for single-plane
-     *              buffers (when type != *_MPLANE); number of elements in the
-     *              planes array for multi-plane buffers
-     *
-     * Contains data exchanged by application and driver using one of the Streaming
-     * I/O methods.
-     */
-    struct v4l2_buffer {
-	    __u32                   index;
-	    __u32                   type;
-	    __u32                   bytesused;
-	    __u32                   flags;
-	    __u32                   field;
-	    struct timeval          timestamp;
-	    struct v4l2_timecode    timecode;
-	    __u32                   sequence;
-
-	    /* memory location */
-	    __u32                   memory;
-	    union {
-		    __u32           offset;
-		    unsigned long   userptr;
-		    struct v4l2_plane *planes;
-		    __s32           fd;
-	    } m;
-	    __u32                   length;
-	    __u32                   reserved2;
-	    __u32                   reserved;
-    };
-
-    /*  Flags for 'flags' field */
-    /* Buffer is mapped (flag) */
-    #define V4L2_BUF_FLAG_MAPPED                    0x00000001
-    /* Buffer is queued for processing */
-    #define V4L2_BUF_FLAG_QUEUED                    0x00000002
-    /* Buffer is ready */
-    #define V4L2_BUF_FLAG_DONE                      0x00000004
-    /* Image is a keyframe (I-frame) */
-    #define V4L2_BUF_FLAG_KEYFRAME                  0x00000008
-    /* Image is a P-frame */
-    #define V4L2_BUF_FLAG_PFRAME                    0x00000010
-    /* Image is a B-frame */
-    #define V4L2_BUF_FLAG_BFRAME                    0x00000020
-    /* Buffer is ready, but the data contained within is corrupted. */
-    #define V4L2_BUF_FLAG_ERROR                     0x00000040
-    /* timecode field is valid */
-    #define V4L2_BUF_FLAG_TIMECODE                  0x00000100
-    /* Buffer is prepared for queuing */
-    #define V4L2_BUF_FLAG_PREPARED                  0x00000400
-    /* Cache handling flags */
-    #define V4L2_BUF_FLAG_NO_CACHE_INVALIDATE       0x00000800
-    #define V4L2_BUF_FLAG_NO_CACHE_CLEAN            0x00001000
-    /* Timestamp type */
-    #define V4L2_BUF_FLAG_TIMESTAMP_MASK            0x0000e000
-    #define V4L2_BUF_FLAG_TIMESTAMP_UNKNOWN         0x00000000
-    #define V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC       0x00002000
-    #define V4L2_BUF_FLAG_TIMESTAMP_COPY            0x00004000
-    /* Timestamp sources. */
-    #define V4L2_BUF_FLAG_TSTAMP_SRC_MASK           0x00070000
-    #define V4L2_BUF_FLAG_TSTAMP_SRC_EOF            0x00000000
-    #define V4L2_BUF_FLAG_TSTAMP_SRC_SOE            0x00010000
-    /* mem2mem encoder/decoder */
-    #define V4L2_BUF_FLAG_LAST                      0x00100000
-
-    /**
-     * struct v4l2_exportbuffer - export of video buffer as DMABUF file descriptor
-     *
-     * @index:      id number of the buffer
-     * @type:       enum v4l2_buf_type; buffer type (type == *_MPLANE for
-     *              multiplanar buffers);
-     * @plane:      index of the plane to be exported, 0 for single plane queues
-     * @flags:      flags for newly created file, currently only O_CLOEXEC is
-     *              supported, refer to manual of open syscall for more details
-     * @fd:         file descriptor associated with DMABUF (set by driver)
-     *
-     * Contains data used for exporting a video buffer as DMABUF file descriptor.
-     * The buffer is identified by a 'cookie' returned by VIDIOC_QUERYBUF
-     * (identical to the cookie used to mmap() the buffer to userspace). All
-     * reserved fields must be set to zero. The field reserved0 is expected to
-     * become a structure 'type' allowing an alternative layout of the structure
-     * content. Therefore this field should not be used for any other extensions.
-     */
-    struct v4l2_exportbuffer {
-	    __u32           type; /* enum v4l2_buf_type */
-	    __u32           index;
-	    __u32           plane;
-	    __u32           flags;
-	    __s32           fd;
-	    __u32           reserved[11];
-    };
-
-    /*
-     *      O V E R L A Y   P R E V I E W
-     */
-    struct v4l2_framebuffer {
-	    __u32                   capability;
-	    __u32                   flags;
-    /* FIXME: in theory we should pass something like PCI device + memory
-     * region + offset instead of some physical address */
-	    void                    *base;
-	    struct {
-		    __u32           width;
-		    __u32           height;
-		    __u32           pixelformat;
-		    __u32           field;          /* enum v4l2_field */
-		    __u32           bytesperline;   /* for padding, zero if unused */
-		    __u32           sizeimage;
-		    __u32           colorspace;     /* enum v4l2_colorspace */
-		    __u32           priv;           /* reserved field, set to 0 */
-	    } fmt;
-    };
-    /*  Flags for the 'capability' field. Read only */
-    #define V4L2_FBUF_CAP_EXTERNOVERLAY     0x0001
-    #define V4L2_FBUF_CAP_CHROMAKEY         0x0002
-    #define V4L2_FBUF_CAP_LIST_CLIPPING     0x0004
-    #define V4L2_FBUF_CAP_BITMAP_CLIPPING   0x0008
-    #define V4L2_FBUF_CAP_LOCAL_ALPHA       0x0010
-    #define V4L2_FBUF_CAP_GLOBAL_ALPHA      0x0020
-    #define V4L2_FBUF_CAP_LOCAL_INV_ALPHA   0x0040
-    #define V4L2_FBUF_CAP_SRC_CHROMAKEY     0x0080
-    /*  Flags for the 'flags' field. */
-    #define V4L2_FBUF_FLAG_PRIMARY          0x0001
-    #define V4L2_FBUF_FLAG_OVERLAY          0x0002
-    #define V4L2_FBUF_FLAG_CHROMAKEY        0x0004
-    #define V4L2_FBUF_FLAG_LOCAL_ALPHA      0x0008
-    #define V4L2_FBUF_FLAG_GLOBAL_ALPHA     0x0010
-    #define V4L2_FBUF_FLAG_LOCAL_INV_ALPHA  0x0020
-    #define V4L2_FBUF_FLAG_SRC_CHROMAKEY    0x0040
-
-    struct v4l2_clip {
-	    struct v4l2_rect        c;
-	    struct v4l2_clip        __user *next;
-    };
-
-    struct v4l2_window {
-	    struct v4l2_rect        w;
-	    __u32                   field;   /* enum v4l2_field */
-	    __u32                   chromakey;
-	    struct v4l2_clip        __user *clips;
-	    __u32                   clipcount;
-	    void                    __user *bitmap;
-	    __u8                    global_alpha;
-    };
-
-    /*
-     *      C A P T U R E   P A R A M E T E R S
-     */
-    struct v4l2_captureparm {
-	    __u32              capability;    /*  Supported modes */
-	    __u32              capturemode;   /*  Current mode */
-	    struct v4l2_fract  timeperframe;  /*  Time per frame in seconds */
-	    __u32              extendedmode;  /*  Driver-specific extensions */
-	    __u32              readbuffers;   /*  # of buffers for read */
-	    __u32              reserved[4];
-    };
-
-    /*  Flags for 'capability' and 'capturemode' fields */
-    #define V4L2_MODE_HIGHQUALITY   0x0001  /*  High quality imaging mode */
-    #define V4L2_CAP_TIMEPERFRAME   0x1000  /*  timeperframe field is supported */
-
-    struct v4l2_outputparm {
-	    __u32              capability;   /*  Supported modes */
-	    __u32              outputmode;   /*  Current mode */
-	    struct v4l2_fract  timeperframe; /*  Time per frame in seconds */
-	    __u32              extendedmode; /*  Driver-specific extensions */
-	    __u32              writebuffers; /*  # of buffers for write */
-	    __u32              reserved[4];
-    };
-
-    /*
-     *      I N P U T   I M A G E   C R O P P I N G
-     */
-    struct v4l2_cropcap {
-	    __u32                   type;   /* enum v4l2_buf_type */
-	    struct v4l2_rect        bounds;
-	    struct v4l2_rect        defrect;
-	    struct v4l2_fract       pixelaspect;
-    };
-
-    struct v4l2_crop {
-	    __u32                   type;   /* enum v4l2_buf_type */
-	    struct v4l2_rect        c;
-    };
-
-    /**
-     * struct v4l2_selection - selection info
-     * @type:       buffer type (do not use *_MPLANE types)
-     * @target:     Selection target, used to choose one of possible rectangles;
-     *              defined in v4l2-common.h; V4L2_SEL_TGT_* .
-     * @flags:      constraints flags, defined in v4l2-common.h; V4L2_SEL_FLAG_*.
-     * @r:          coordinates of selection window
-     * @reserved:   for future use, rounds structure size to 64 bytes, set to zero
-     *
-     * Hardware may use multiple helper windows to process a video stream.
-     * The structure is used to exchange this selection areas between
-     * an application and a driver.
-     */
-    struct v4l2_selection {
-	    __u32                   type;
-	    __u32                   target;
-	    __u32                   flags;
-	    struct v4l2_rect        r;
-	    __u32                   reserved[9];
-    };
-
-
-    /*
-     *      A N A L O G   V I D E O   S T A N D A R D
-     */
-
-    typedef __u64 v4l2_std_id;
-
-    /* one bit for each */
-    #define V4L2_STD_PAL_B          ((v4l2_std_id)0x00000001)
-    #define V4L2_STD_PAL_B1         ((v4l2_std_id)0x00000002)
-    #define V4L2_STD_PAL_G          ((v4l2_std_id)0x00000004)
-    #define V4L2_STD_PAL_H          ((v4l2_std_id)0x00000008)
-    #define V4L2_STD_PAL_I          ((v4l2_std_id)0x00000010)
-    #define V4L2_STD_PAL_D          ((v4l2_std_id)0x00000020)
-    #define V4L2_STD_PAL_D1         ((v4l2_std_id)0x00000040)
-    #define V4L2_STD_PAL_K          ((v4l2_std_id)0x00000080)
-
-    #define V4L2_STD_PAL_M          ((v4l2_std_id)0x00000100)
-    #define V4L2_STD_PAL_N          ((v4l2_std_id)0x00000200)
-    #define V4L2_STD_PAL_Nc         ((v4l2_std_id)0x00000400)
-    #define V4L2_STD_PAL_60         ((v4l2_std_id)0x00000800)
-
-    #define V4L2_STD_NTSC_M         ((v4l2_std_id)0x00001000)       /* BTSC */
-    #define V4L2_STD_NTSC_M_JP      ((v4l2_std_id)0x00002000)       /* EIA-J */
-    #define V4L2_STD_NTSC_443       ((v4l2_std_id)0x00004000)
-    #define V4L2_STD_NTSC_M_KR      ((v4l2_std_id)0x00008000)       /* FM A2 */
-
-    #define V4L2_STD_SECAM_B        ((v4l2_std_id)0x00010000)
-    #define V4L2_STD_SECAM_D        ((v4l2_std_id)0x00020000)
-    #define V4L2_STD_SECAM_G        ((v4l2_std_id)0x00040000)
-    #define V4L2_STD_SECAM_H        ((v4l2_std_id)0x00080000)
-    #define V4L2_STD_SECAM_K        ((v4l2_std_id)0x00100000)
-    #define V4L2_STD_SECAM_K1       ((v4l2_std_id)0x00200000)
-    #define V4L2_STD_SECAM_L        ((v4l2_std_id)0x00400000)
-    #define V4L2_STD_SECAM_LC       ((v4l2_std_id)0x00800000)
-
-    /* ATSC/HDTV */
-    #define V4L2_STD_ATSC_8_VSB     ((v4l2_std_id)0x01000000)
-    #define V4L2_STD_ATSC_16_VSB    ((v4l2_std_id)0x02000000)
-
-    /* FIXME:
-       Although std_id is 64 bits, there is an issue on PPC32 architecture that
-       makes switch(__u64) to break. So, there's a hack on v4l2-common.c rounding
-       this value to 32 bits.
-       As, currently, the max value is for V4L2_STD_ATSC_16_VSB (30 bits wide),
-       it should work fine. However, if needed to add more than two standards,
-       v4l2-common.c should be fixed.
-     */
-
-    /*
-     * Some macros to merge video standards in order to make live easier for the
-     * drivers and V4L2 applications
-     */
-
-    /*
-     * "Common" NTSC/M - It should be noticed that V4L2_STD_NTSC_443 is
-     * Missing here.
-     */
-    #define V4L2_STD_NTSC           (V4L2_STD_NTSC_M        |
-				     V4L2_STD_NTSC_M_JP     |
-				     V4L2_STD_NTSC_M_KR)
-    /* Secam macros */
-    #define V4L2_STD_SECAM_DK       (V4L2_STD_SECAM_D       |
-				     V4L2_STD_SECAM_K       |
-				     V4L2_STD_SECAM_K1)
-    /* All Secam Standards */
-    #define V4L2_STD_SECAM          (V4L2_STD_SECAM_B       |
-				     V4L2_STD_SECAM_G       |
-				     V4L2_STD_SECAM_H       |
-				     V4L2_STD_SECAM_DK      |
-				     V4L2_STD_SECAM_L       |
-				     V4L2_STD_SECAM_LC)
-    /* PAL macros */
-    #define V4L2_STD_PAL_BG         (V4L2_STD_PAL_B         |
-				     V4L2_STD_PAL_B1        |
-				     V4L2_STD_PAL_G)
-    #define V4L2_STD_PAL_DK         (V4L2_STD_PAL_D         |
-				     V4L2_STD_PAL_D1        |
-				     V4L2_STD_PAL_K)
-    /*
-     * "Common" PAL - This macro is there to be compatible with the old
-     * V4L1 concept of "PAL": /BGDKHI.
-     * Several PAL standards are missing here: /M, /N and /Nc
-     */
-    #define V4L2_STD_PAL            (V4L2_STD_PAL_BG        |
-				     V4L2_STD_PAL_DK        |
-				     V4L2_STD_PAL_H         |
-				     V4L2_STD_PAL_I)
-    /* Chroma "agnostic" standards */
-    #define V4L2_STD_B              (V4L2_STD_PAL_B         |
-				     V4L2_STD_PAL_B1        |
-				     V4L2_STD_SECAM_B)
-    #define V4L2_STD_G              (V4L2_STD_PAL_G         |
-				     V4L2_STD_SECAM_G)
-    #define V4L2_STD_H              (V4L2_STD_PAL_H         |
-				     V4L2_STD_SECAM_H)
-    #define V4L2_STD_L              (V4L2_STD_SECAM_L       |
-				     V4L2_STD_SECAM_LC)
-    #define V4L2_STD_GH             (V4L2_STD_G             |
-				     V4L2_STD_H)
-    #define V4L2_STD_DK             (V4L2_STD_PAL_DK        |
-				     V4L2_STD_SECAM_DK)
-    #define V4L2_STD_BG             (V4L2_STD_B             |
-				     V4L2_STD_G)
-    #define V4L2_STD_MN             (V4L2_STD_PAL_M         |
-				     V4L2_STD_PAL_N         |
-				     V4L2_STD_PAL_Nc        |
-				     V4L2_STD_NTSC)
-
-    /* Standards where MTS/BTSC stereo could be found */
-    #define V4L2_STD_MTS            (V4L2_STD_NTSC_M        |
-				     V4L2_STD_PAL_M         |
-				     V4L2_STD_PAL_N         |
-				     V4L2_STD_PAL_Nc)
-
-    /* Standards for Countries with 60Hz Line frequency */
-    #define V4L2_STD_525_60         (V4L2_STD_PAL_M         |
-				     V4L2_STD_PAL_60        |
-				     V4L2_STD_NTSC          |
-				     V4L2_STD_NTSC_443)
-    /* Standards for Countries with 50Hz Line frequency */
-    #define V4L2_STD_625_50         (V4L2_STD_PAL           |
-				     V4L2_STD_PAL_N         |
-				     V4L2_STD_PAL_Nc        |
-				     V4L2_STD_SECAM)
-
-    #define V4L2_STD_ATSC           (V4L2_STD_ATSC_8_VSB    |
-				     V4L2_STD_ATSC_16_VSB)
-    /* Macros with none and all analog standards */
-    #define V4L2_STD_UNKNOWN        0
-    #define V4L2_STD_ALL            (V4L2_STD_525_60        |
-				     V4L2_STD_625_50)
-
-    struct v4l2_standard {
-	    __u32                index;
-	    v4l2_std_id          id;
-	    __u8                 name[24];
-	    struct v4l2_fract    frameperiod; /* Frames, not fields */
-	    __u32                framelines;
-	    __u32                reserved[4];
-    };
-
-    /*
-     *      D V     B T     T I M I N G S
-     */
-
-    /** struct v4l2_bt_timings - BT.656/BT.1120 timing data
-     * @width:      total width of the active video in pixels
-     * @height:     total height of the active video in lines
-     * @interlaced: Interlaced or progressive
-     * @polarities: Positive or negative polarities
-     * @pixelclock: Pixel clock in HZ. Ex. 74.25MHz->74250000
-     * @hfrontporch:Horizontal front porch in pixels
-     * @hsync:      Horizontal Sync length in pixels
-     * @hbackporch: Horizontal back porch in pixels
-     * @vfrontporch:Vertical front porch in lines
-     * @vsync:      Vertical Sync length in lines
-     * @vbackporch: Vertical back porch in lines
-     * @il_vfrontporch:Vertical front porch for the even field
-     *              (aka field 2) of interlaced field formats
-     * @il_vsync:   Vertical Sync length for the even field
-     *              (aka field 2) of interlaced field formats
-     * @il_vbackporch:Vertical back porch for the even field
-     *              (aka field 2) of interlaced field formats
-     * @standards:  Standards the timing belongs to
-     * @flags:      Flags
-     * @reserved:   Reserved fields, must be zeroed.
-     *
-     * A note regarding vertical interlaced timings: height refers to the total
-     * height of the active video frame (= two fields). The blanking timings refer
-     * to the blanking of each field. So the height of the total frame is
-     * calculated as follows:
-     *
-     * tot_height = height + vfrontporch + vsync + vbackporch +
-     *                       il_vfrontporch + il_vsync + il_vbackporch
-     *
-     * The active height of each field is height / 2.
-     */
-    struct v4l2_bt_timings {
-	    __u32   width;
-	    __u32   height;
-	    __u32   interlaced;
-	    __u32   polarities;
-	    __u64   pixelclock;
-	    __u32   hfrontporch;
-	    __u32   hsync;
-	    __u32   hbackporch;
-	    __u32   vfrontporch;
-	    __u32   vsync;
-	    __u32   vbackporch;
-	    __u32   il_vfrontporch;
-	    __u32   il_vsync;
-	    __u32   il_vbackporch;
-	    __u32   standards;
-	    __u32   flags;
-	    __u32   reserved[14];
-    } __attribute__ ((packed));
-
-    /* Interlaced or progressive format */
-    #define V4L2_DV_PROGRESSIVE     0
-    #define V4L2_DV_INTERLACED      1
-
-    /* Polarities. If bit is not set, it is assumed to be negative polarity */
-    #define V4L2_DV_VSYNC_POS_POL   0x00000001
-    #define V4L2_DV_HSYNC_POS_POL   0x00000002
-
-    /* Timings standards */
-    #define V4L2_DV_BT_STD_CEA861   (1 << 0)  /* CEA-861 Digital TV Profile */
-    #define V4L2_DV_BT_STD_DMT      (1 << 1)  /* VESA Discrete Monitor Timings */
-    #define V4L2_DV_BT_STD_CVT      (1 << 2)  /* VESA Coordinated Video Timings */
-    #define V4L2_DV_BT_STD_GTF      (1 << 3)  /* VESA Generalized Timings Formula */
-
-    /* Flags */
-
-    /* CVT/GTF specific: timing uses reduced blanking (CVT) or the 'Secondary
-       GTF' curve (GTF). In both cases the horizontal and/or vertical blanking
-       intervals are reduced, allowing a higher resolution over the same
-       bandwidth. This is a read-only flag. */
-    #define V4L2_DV_FL_REDUCED_BLANKING             (1 << 0)
-    /* CEA-861 specific: set for CEA-861 formats with a framerate of a multiple
-       of six. These formats can be optionally played at 1 / 1.001 speed.
-       This is a read-only flag. */
-    #define V4L2_DV_FL_CAN_REDUCE_FPS               (1 << 1)
-    /* CEA-861 specific: only valid for video transmitters, the flag is cleared
-       by receivers.
-       If the framerate of the format is a multiple of six, then the pixelclock
-       used to set up the transmitter is divided by 1.001 to make it compatible
-       with 60 Hz based standards such as NTSC and PAL-M that use a framerate of
-       29.97 Hz. Otherwise this flag is cleared. If the transmitter can't generate
-       such frequencies, then the flag will also be cleared. */
-    #define V4L2_DV_FL_REDUCED_FPS                  (1 << 2)
-    /* Specific to interlaced formats: if set, then field 1 is really one half-line
-       longer and field 2 is really one half-line shorter, so each field has
-       exactly the same number of half-lines. Whether half-lines can be detected
-       or used depends on the hardware. */
-    #define V4L2_DV_FL_HALF_LINE                    (1 << 3)
-    /* If set, then this is a Consumer Electronics (CE) video format. Such formats
-     * differ from other formats (commonly called IT formats) in that if RGB
-     * encoding is used then by default the RGB values use limited range (i.e.ie;
-     * use the range 16-235) as opposed to 0-255. All formats defined in CEA-861
-     * except for the 640x480 format are CE formats. */
-    #define V4L2_DV_FL_IS_CE_VIDEO                  (1 << 4)
-
-    /* A few useful defines to calculate the total blanking and frame sizes */
-    #define V4L2_DV_BT_BLANKING_WIDTH(bt)
-	    ((bt)->hfrontporch + (bt)->hsync + (bt)->hbackporch)
-    #define V4L2_DV_BT_FRAME_WIDTH(bt)
-	    ((bt)->width + V4L2_DV_BT_BLANKING_WIDTH(bt))
-    #define V4L2_DV_BT_BLANKING_HEIGHT(bt)
-	    ((bt)->vfrontporch + (bt)->vsync + (bt)->vbackporch + \\
-	     (bt)->il_vfrontporch + (bt)->il_vsync + (bt)->il_vbackporch)
-    #define V4L2_DV_BT_FRAME_HEIGHT(bt)
-	    ((bt)->height + V4L2_DV_BT_BLANKING_HEIGHT(bt))
-
-    /** struct v4l2_dv_timings - DV timings
-     * @type:       the type of the timings
-     * @bt: BT656/1120 timings
-     */
-    struct v4l2_dv_timings {
-	    __u32 type;
-	    union {
-		    struct v4l2_bt_timings  bt;
-		    __u32   reserved[32];
-	    };
-    } __attribute__ ((packed));
-
-    /* Values for the type field */
-    #define V4L2_DV_BT_656_1120     0       /* BT.656/1120 timing type */
-
-
-    /** struct v4l2_enum_dv_timings - DV timings enumeration
-     * @index:      enumeration index
-     * @pad:        the pad number for which to enumerate timings (used with
-     *              v4l-subdev nodes only)
-     * @reserved:   must be zeroed
-     * @timings:    the timings for the given index
-     */
-    struct v4l2_enum_dv_timings {
-	    __u32 index;
-	    __u32 pad;
-	    __u32 reserved[2];
-	    struct v4l2_dv_timings timings;
-    };
-
-    /** struct v4l2_bt_timings_cap - BT.656/BT.1120 timing capabilities
-     * @min_width:          width in pixels
-     * @max_width:          width in pixels
-     * @min_height:         height in lines
-     * @max_height:         height in lines
-     * @min_pixelclock:     Pixel clock in HZ. Ex. 74.25MHz->74250000
-     * @max_pixelclock:     Pixel clock in HZ. Ex. 74.25MHz->74250000
-     * @standards:          Supported standards
-     * @capabilities:       Supported capabilities
-     * @reserved:           Must be zeroed
-     */
-    struct v4l2_bt_timings_cap {
-	    __u32   min_width;
-	    __u32   max_width;
-	    __u32   min_height;
-	    __u32   max_height;
-	    __u64   min_pixelclock;
-	    __u64   max_pixelclock;
-	    __u32   standards;
-	    __u32   capabilities;
-	    __u32   reserved[16];
-    } __attribute__ ((packed));
-
-    /* Supports interlaced formats */
-    #define V4L2_DV_BT_CAP_INTERLACED       (1 << 0)
-    /* Supports progressive formats */
-    #define V4L2_DV_BT_CAP_PROGRESSIVE      (1 << 1)
-    /* Supports CVT/GTF reduced blanking */
-    #define V4L2_DV_BT_CAP_REDUCED_BLANKING (1 << 2)
-    /* Supports custom formats */
-    #define V4L2_DV_BT_CAP_CUSTOM           (1 << 3)
-
-    /** struct v4l2_dv_timings_cap - DV timings capabilities
-     * @type:       the type of the timings (same as in struct v4l2_dv_timings)
-     * @pad:        the pad number for which to query capabilities (used with
-     *              v4l-subdev nodes only)
-     * @bt:         the BT656/1120 timings capabilities
-     */
-    struct v4l2_dv_timings_cap {
-	    __u32 type;
-	    __u32 pad;
-	    __u32 reserved[2];
-	    union {
-		    struct v4l2_bt_timings_cap bt;
-		    __u32 raw_data[32];
-	    };
-    };
-
-
-    /*
-     *      V I D E O   I N P U T S
-     */
-    struct v4l2_input {
-	    __u32        index;             /*  Which input */
-	    __u8         name[32];          /*  Label */
-	    __u32        type;              /*  Type of input */
-	    __u32        audioset;          /*  Associated audios (bitfield) */
-	    __u32        tuner;             /*  enum v4l2_tuner_type */
-	    v4l2_std_id  std;
-	    __u32        status;
-	    __u32        capabilities;
-	    __u32        reserved[3];
-    };
-
-    /*  Values for the 'type' field */
-    #define V4L2_INPUT_TYPE_TUNER           1
-    #define V4L2_INPUT_TYPE_CAMERA          2
-
-    /* field 'status' - general */
-    #define V4L2_IN_ST_NO_POWER    0x00000001  /* Attached device is off */
-    #define V4L2_IN_ST_NO_SIGNAL   0x00000002
-    #define V4L2_IN_ST_NO_COLOR    0x00000004
-
-    /* field 'status' - sensor orientation */
-    /* If sensor is mounted upside down set both bits */
-    #define V4L2_IN_ST_HFLIP       0x00000010 /* Frames are flipped horizontally */
-    #define V4L2_IN_ST_VFLIP       0x00000020 /* Frames are flipped vertically */
-
-    /* field 'status' - analog */
-    #define V4L2_IN_ST_NO_H_LOCK   0x00000100  /* No horizontal sync lock */
-    #define V4L2_IN_ST_COLOR_KILL  0x00000200  /* Color killer is active */
-
-    /* field 'status' - digital */
-    #define V4L2_IN_ST_NO_SYNC     0x00010000  /* No synchronization lock */
-    #define V4L2_IN_ST_NO_EQU      0x00020000  /* No equalizer lock */
-    #define V4L2_IN_ST_NO_CARRIER  0x00040000  /* Carrier recovery failed */
-
-    /* field 'status' - VCR and set-top box */
-    #define V4L2_IN_ST_MACROVISION 0x01000000  /* Macrovision detected */
-    #define V4L2_IN_ST_NO_ACCESS   0x02000000  /* Conditional access denied */
-    #define V4L2_IN_ST_VTR         0x04000000  /* VTR time constant */
-
-    /* capabilities flags */
-    #define V4L2_IN_CAP_DV_TIMINGS          0x00000002 /* Supports S_DV_TIMINGS */
-    #define V4L2_IN_CAP_CUSTOM_TIMINGS      V4L2_IN_CAP_DV_TIMINGS /* For compatibility */
-    #define V4L2_IN_CAP_STD                 0x00000004 /* Supports S_STD */
-    #define V4L2_IN_CAP_NATIVE_SIZE         0x00000008 /* Supports setting native size */
-
-    /*
-     *      V I D E O   O U T P U T S
-     */
-    struct v4l2_output {
-	    __u32        index;             /*  Which output */
-	    __u8         name[32];          /*  Label */
-	    __u32        type;              /*  Type of output */
-	    __u32        audioset;          /*  Associated audios (bitfield) */
-	    __u32        modulator;         /*  Associated modulator */
-	    v4l2_std_id  std;
-	    __u32        capabilities;
-	    __u32        reserved[3];
-    };
-    /*  Values for the 'type' field */
-    #define V4L2_OUTPUT_TYPE_MODULATOR              1
-    #define V4L2_OUTPUT_TYPE_ANALOG                 2
-    #define V4L2_OUTPUT_TYPE_ANALOGVGAOVERLAY       3
-
-    /* capabilities flags */
-    #define V4L2_OUT_CAP_DV_TIMINGS         0x00000002 /* Supports S_DV_TIMINGS */
-    #define V4L2_OUT_CAP_CUSTOM_TIMINGS     V4L2_OUT_CAP_DV_TIMINGS /* For compatibility */
-    #define V4L2_OUT_CAP_STD                0x00000004 /* Supports S_STD */
-    #define V4L2_OUT_CAP_NATIVE_SIZE        0x00000008 /* Supports setting native size */
-
-    /*
-     *      C O N T R O L S
-     */
-    struct v4l2_control {
-	    __u32                id;
-	    __s32                value;
-    };
-
-    struct v4l2_ext_control {
-	    __u32 id;
-	    __u32 size;
-	    __u32 reserved2[1];
-	    union {
-		    __s32 value;
-		    __s64 value64;
-		    char __user *string;
-		    __u8 __user *p_u8;
-		    __u16 __user *p_u16;
-		    __u32 __user *p_u32;
-		    void __user *ptr;
-	    };
-    } __attribute__ ((packed));
-
-    struct v4l2_ext_controls {
-	    union {
-    #ifndef __KERNEL__
-		    __u32 ctrl_class;
-    #endif
-		    __u32 which;
-	    };
-	    __u32 count;
-	    __u32 error_idx;
-	    __u32 reserved[2];
-	    struct v4l2_ext_control *controls;
-    };
-
-    #define V4L2_CTRL_ID_MASK         (0x0fffffff)
-    #ifndef __KERNEL__
-    #define V4L2_CTRL_ID2CLASS(id)    ((id) & 0x0fff0000UL)
-    #endif
-    #define V4L2_CTRL_ID2WHICH(id)    ((id) & 0x0fff0000UL)
-    #define V4L2_CTRL_DRIVER_PRIV(id) (((id) & 0xffff) >= 0x1000)
-    #define V4L2_CTRL_MAX_DIMS        (4)
-    #define V4L2_CTRL_WHICH_CUR_VAL   0
-    #define V4L2_CTRL_WHICH_DEF_VAL   0x0f000000
-
-    enum v4l2_ctrl_type {
-	    V4L2_CTRL_TYPE_INTEGER       = 1,
-	    V4L2_CTRL_TYPE_BOOLEAN       = 2,
-	    V4L2_CTRL_TYPE_MENU          = 3,
-	    V4L2_CTRL_TYPE_BUTTON        = 4,
-	    V4L2_CTRL_TYPE_INTEGER64     = 5,
-	    V4L2_CTRL_TYPE_CTRL_CLASS    = 6,
-	    V4L2_CTRL_TYPE_STRING        = 7,
-	    V4L2_CTRL_TYPE_BITMASK       = 8,
-	    V4L2_CTRL_TYPE_INTEGER_MENU  = 9,
-
-	    /* Compound types are >= 0x0100 */
-	    V4L2_CTRL_COMPOUND_TYPES     = 0x0100,
-	    V4L2_CTRL_TYPE_U8            = 0x0100,
-	    V4L2_CTRL_TYPE_U16           = 0x0101,
-	    V4L2_CTRL_TYPE_U32           = 0x0102,
-    };
-
-    /*  Used in the VIDIOC_QUERYCTRL ioctl for querying controls */
-    struct v4l2_queryctrl {
-	    __u32                id;
-	    __u32                type;      /* enum v4l2_ctrl_type */
-	    __u8                 name[32];  /* Whatever */
-	    __s32                minimum;   /* Note signedness */
-	    __s32                maximum;
-	    __s32                step;
-	    __s32                default_value;
-	    __u32                flags;
-	    __u32                reserved[2];
-    };
-
-    /*  Used in the VIDIOC_QUERY_EXT_CTRL ioctl for querying extended controls */
-    struct v4l2_query_ext_ctrl {
-	    __u32                id;
-	    __u32                type;
-	    char                 name[32];
-	    __s64                minimum;
-	    __s64                maximum;
-	    __u64                step;
-	    __s64                default_value;
-	    __u32                flags;
-	    __u32                elem_size;
-	    __u32                elems;
-	    __u32                nr_of_dims;
-	    __u32                dims[V4L2_CTRL_MAX_DIMS];
-	    __u32                reserved[32];
-    };
-
-    /*  Used in the VIDIOC_QUERYMENU ioctl for querying menu items */
-    struct v4l2_querymenu {
-	    __u32           id;
-	    __u32           index;
-	    union {
-		    __u8    name[32];       /* Whatever */
-		    __s64   value;
-	    };
-	    __u32           reserved;
-    } __attribute__ ((packed));
-
-    /*  Control flags  */
-    #define V4L2_CTRL_FLAG_DISABLED         0x0001
-    #define V4L2_CTRL_FLAG_GRABBED          0x0002
-    #define V4L2_CTRL_FLAG_READ_ONLY        0x0004
-    #define V4L2_CTRL_FLAG_UPDATE           0x0008
-    #define V4L2_CTRL_FLAG_INACTIVE         0x0010
-    #define V4L2_CTRL_FLAG_SLIDER           0x0020
-    #define V4L2_CTRL_FLAG_WRITE_ONLY       0x0040
-    #define V4L2_CTRL_FLAG_VOLATILE         0x0080
-    #define V4L2_CTRL_FLAG_HAS_PAYLOAD      0x0100
-    #define V4L2_CTRL_FLAG_EXECUTE_ON_WRITE 0x0200
-
-    /*  Query flags, to be ORed with the control ID */
-    #define V4L2_CTRL_FLAG_NEXT_CTRL        0x80000000
-    #define V4L2_CTRL_FLAG_NEXT_COMPOUND    0x40000000
-
-    /*  User-class control IDs defined by V4L2 */
-    #define V4L2_CID_MAX_CTRLS              1024
-    /*  IDs reserved for driver specific controls */
-    #define V4L2_CID_PRIVATE_BASE           0x08000000
-
-
-    /*
-     *      T U N I N G
-     */
-    struct v4l2_tuner {
-	    __u32                   index;
-	    __u8                    name[32];
-	    __u32                   type;   /* enum v4l2_tuner_type */
-	    __u32                   capability;
-	    __u32                   rangelow;
-	    __u32                   rangehigh;
-	    __u32                   rxsubchans;
-	    __u32                   audmode;
-	    __s32                   signal;
-	    __s32                   afc;
-	    __u32                   reserved[4];
-    };
-
-    struct v4l2_modulator {
-	    __u32                   index;
-	    __u8                    name[32];
-	    __u32                   capability;
-	    __u32                   rangelow;
-	    __u32                   rangehigh;
-	    __u32                   txsubchans;
-	    __u32                   type;   /* enum v4l2_tuner_type */
-	    __u32                   reserved[3];
-    };
-
-    /*  Flags for the 'capability' field */
-    #define V4L2_TUNER_CAP_LOW              0x0001
-    #define V4L2_TUNER_CAP_NORM             0x0002
-    #define V4L2_TUNER_CAP_HWSEEK_BOUNDED   0x0004
-    #define V4L2_TUNER_CAP_HWSEEK_WRAP      0x0008
-    #define V4L2_TUNER_CAP_STEREO           0x0010
-    #define V4L2_TUNER_CAP_LANG2            0x0020
-    #define V4L2_TUNER_CAP_SAP              0x0020
-    #define V4L2_TUNER_CAP_LANG1            0x0040
-    #define V4L2_TUNER_CAP_RDS              0x0080
-    #define V4L2_TUNER_CAP_RDS_BLOCK_IO     0x0100
-    #define V4L2_TUNER_CAP_RDS_CONTROLS     0x0200
-    #define V4L2_TUNER_CAP_FREQ_BANDS       0x0400
-    #define V4L2_TUNER_CAP_HWSEEK_PROG_LIM  0x0800
-    #define V4L2_TUNER_CAP_1HZ              0x1000
-
-    /*  Flags for the 'rxsubchans' field */
-    #define V4L2_TUNER_SUB_MONO             0x0001
-    #define V4L2_TUNER_SUB_STEREO           0x0002
-    #define V4L2_TUNER_SUB_LANG2            0x0004
-    #define V4L2_TUNER_SUB_SAP              0x0004
-    #define V4L2_TUNER_SUB_LANG1            0x0008
-    #define V4L2_TUNER_SUB_RDS              0x0010
-
-    /*  Values for the 'audmode' field */
-    #define V4L2_TUNER_MODE_MONO            0x0000
-    #define V4L2_TUNER_MODE_STEREO          0x0001
-    #define V4L2_TUNER_MODE_LANG2           0x0002
-    #define V4L2_TUNER_MODE_SAP             0x0002
-    #define V4L2_TUNER_MODE_LANG1           0x0003
-    #define V4L2_TUNER_MODE_LANG1_LANG2     0x0004
-
-    struct v4l2_frequency {
-	    __u32   tuner;
-	    __u32   type;   /* enum v4l2_tuner_type */
-	    __u32   frequency;
-	    __u32   reserved[8];
-    };
-
-    #define V4L2_BAND_MODULATION_VSB        (1 << 1)
-    #define V4L2_BAND_MODULATION_FM         (1 << 2)
-    #define V4L2_BAND_MODULATION_AM         (1 << 3)
-
-    struct v4l2_frequency_band {
-	    __u32   tuner;
-	    __u32   type;   /* enum v4l2_tuner_type */
-	    __u32   index;
-	    __u32   capability;
-	    __u32   rangelow;
-	    __u32   rangehigh;
-	    __u32   modulation;
-	    __u32   reserved[9];
-    };
-
-    struct v4l2_hw_freq_seek {
-	    __u32   tuner;
-	    __u32   type;   /* enum v4l2_tuner_type */
-	    __u32   seek_upward;
-	    __u32   wrap_around;
-	    __u32   spacing;
-	    __u32   rangelow;
-	    __u32   rangehigh;
-	    __u32   reserved[5];
-    };
-
-    /*
-     *      R D S
-     */
-
-    struct v4l2_rds_data {
-	    __u8    lsb;
-	    __u8    msb;
-	    __u8    block;
-    } __attribute__ ((packed));
-
-    #define V4L2_RDS_BLOCK_MSK       0x7
-    #define V4L2_RDS_BLOCK_A         0
-    #define V4L2_RDS_BLOCK_B         1
-    #define V4L2_RDS_BLOCK_C         2
-    #define V4L2_RDS_BLOCK_D         3
-    #define V4L2_RDS_BLOCK_C_ALT     4
-    #define V4L2_RDS_BLOCK_INVALID   7
-
-    #define V4L2_RDS_BLOCK_CORRECTED 0x40
-    #define V4L2_RDS_BLOCK_ERROR     0x80
-
-    /*
-     *      A U D I O
-     */
-    struct v4l2_audio {
-	    __u32   index;
-	    __u8    name[32];
-	    __u32   capability;
-	    __u32   mode;
-	    __u32   reserved[2];
-    };
-
-    /*  Flags for the 'capability' field */
-    #define V4L2_AUDCAP_STEREO              0x00001
-    #define V4L2_AUDCAP_AVL                 0x00002
-
-    /*  Flags for the 'mode' field */
-    #define V4L2_AUDMODE_AVL                0x00001
-
-    struct v4l2_audioout {
-	    __u32   index;
-	    __u8    name[32];
-	    __u32   capability;
-	    __u32   mode;
-	    __u32   reserved[2];
-    };
-
-    /*
-     *      M P E G   S E R V I C E S
-     */
-    #if 1
-    #define V4L2_ENC_IDX_FRAME_I    (0)
-    #define V4L2_ENC_IDX_FRAME_P    (1)
-    #define V4L2_ENC_IDX_FRAME_B    (2)
-    #define V4L2_ENC_IDX_FRAME_MASK (0xf)
-
-    struct v4l2_enc_idx_entry {
-	    __u64 offset;
-	    __u64 pts;
-	    __u32 length;
-	    __u32 flags;
-	    __u32 reserved[2];
-    };
-
-    #define V4L2_ENC_IDX_ENTRIES (64)
-    struct v4l2_enc_idx {
-	    __u32 entries;
-	    __u32 entries_cap;
-	    __u32 reserved[4];
-	    struct v4l2_enc_idx_entry entry[V4L2_ENC_IDX_ENTRIES];
-    };
-
-
-    #define V4L2_ENC_CMD_START      (0)
-    #define V4L2_ENC_CMD_STOP       (1)
-    #define V4L2_ENC_CMD_PAUSE      (2)
-    #define V4L2_ENC_CMD_RESUME     (3)
-
-    /* Flags for V4L2_ENC_CMD_STOP */
-    #define V4L2_ENC_CMD_STOP_AT_GOP_END    (1 << 0)
-
-    struct v4l2_encoder_cmd {
-	    __u32 cmd;
-	    __u32 flags;
-	    union {
-		    struct {
-			    __u32 data[8];
-		    } raw;
-	    };
-    };
-
-    /* Decoder commands */
-    #define V4L2_DEC_CMD_START       (0)
-    #define V4L2_DEC_CMD_STOP        (1)
-    #define V4L2_DEC_CMD_PAUSE       (2)
-    #define V4L2_DEC_CMD_RESUME      (3)
-
-    /* Flags for V4L2_DEC_CMD_START */
-    #define V4L2_DEC_CMD_START_MUTE_AUDIO   (1 << 0)
-
-    /* Flags for V4L2_DEC_CMD_PAUSE */
-    #define V4L2_DEC_CMD_PAUSE_TO_BLACK     (1 << 0)
-
-    /* Flags for V4L2_DEC_CMD_STOP */
-    #define V4L2_DEC_CMD_STOP_TO_BLACK      (1 << 0)
-    #define V4L2_DEC_CMD_STOP_IMMEDIATELY   (1 << 1)
-
-    /* Play format requirements (returned by the driver): */
-
-    /* The decoder has no special format requirements */
-    #define V4L2_DEC_START_FMT_NONE         (0)
-    /* The decoder requires full GOPs */
-    #define V4L2_DEC_START_FMT_GOP          (1)
-
-    /* The structure must be zeroed before use by the application
-       This ensures it can be extended safely in the future. */
-    struct v4l2_decoder_cmd {
-	    __u32 cmd;
-	    __u32 flags;
-	    union {
-		    struct {
-			    __u64 pts;
-		    } stop;
-
-		    struct {
-			    /* 0 or 1000 specifies normal speed,
-			       1 specifies forward single stepping,
-			       -1 specifies backward single stepping,
-			       >1: playback at speed/1000 of the normal speed,
-			       <-1: reverse playback at (-speed/1000) of the normal speed. */
-			    __s32 speed;
-			    __u32 format;
-		    } start;
-
-		    struct {
-			    __u32 data[16];
-		    } raw;
-	    };
-    };
-    #endif
-
-
-    /*
-     *      D A T A   S E R V I C E S   ( V B I )
-     *
-     *      Data services API by Michael Schimek
-     */
-
-    /* Raw VBI */
-    struct v4l2_vbi_format {
-	    __u32   sampling_rate;          /* in 1 Hz */
-	    __u32   offset;
-	    __u32   samples_per_line;
-	    __u32   sample_format;          /* V4L2_PIX_FMT_* */
-	    __s32   start[2];
-	    __u32   count[2];
-	    __u32   flags;                  /* V4L2_VBI_* */
-	    __u32   reserved[2];            /* must be zero */
-    };
-
-    /*  VBI flags  */
-    #define V4L2_VBI_UNSYNC         (1 << 0)
-    #define V4L2_VBI_INTERLACED     (1 << 1)
-
-    /* ITU-R start lines for each field */
-    #define V4L2_VBI_ITU_525_F1_START (1)
-    #define V4L2_VBI_ITU_525_F2_START (264)
-    #define V4L2_VBI_ITU_625_F1_START (1)
-    #define V4L2_VBI_ITU_625_F2_START (314)
-
-    /* Sliced VBI
-     *
-     *    This implements is a proposal V4L2 API to allow SLICED VBI
-     * required for some hardware encoders. It should change without
-     * notice in the definitive implementation.
-     */
-
-    struct v4l2_sliced_vbi_format {
-	    __u16   service_set;
-	    /* service_lines[0][...] specifies lines 0-23 (1-23 used) of the first field
-	       service_lines[1][...] specifies lines 0-23 (1-23 used) of the second field
-				     (equals frame lines 313-336 for 625 line video
-				      standards, 263-286 for 525 line standards) */
-	    __u16   service_lines[2][24];
-	    __u32   io_size;
-	    __u32   reserved[2];            /* must be zero */
-    };
-
-    /* Teletext World System Teletext
-       (WST), defined on ITU-R BT.653-2 */
-    #define V4L2_SLICED_TELETEXT_B          (0x0001)
-    /* Video Program System, defined on ETS 300 231*/
-    #define V4L2_SLICED_VPS                 (0x0400)
-    /* Closed Caption, defined on EIA-608 */
-    #define V4L2_SLICED_CAPTION_525         (0x1000)
-    /* Wide Screen System, defined on ITU-R BT1119.1 */
-    #define V4L2_SLICED_WSS_625             (0x4000)
-
-    #define V4L2_SLICED_VBI_525             (V4L2_SLICED_CAPTION_525)
-    #define V4L2_SLICED_VBI_625             (V4L2_SLICED_TELETEXT_B | V4L2_SLICED_VPS | V4L2_SLICED_WSS_625)
-
-    struct v4l2_sliced_vbi_cap {
-	    __u16   service_set;
-	    /* service_lines[0][...] specifies lines 0-23 (1-23 used) of the first field
-	       service_lines[1][...] specifies lines 0-23 (1-23 used) of the second field
-				     (equals frame lines 313-336 for 625 line video
-				      standards, 263-286 for 525 line standards) */
-	    __u16   service_lines[2][24];
-	    __u32   type;           /* enum v4l2_buf_type */
-	    __u32   reserved[3];    /* must be 0 */
-    };
-
-    struct v4l2_sliced_vbi_data {
-	    __u32   id;
-	    __u32   field;          /* 0: first field, 1: second field */
-	    __u32   line;           /* 1-23 */
-	    __u32   reserved;       /* must be 0 */
-	    __u8    data[48];
-    };
-
-    /*
-     * Sliced VBI data inserted into MPEG Streams
-     */
-
-    /*
-     * V4L2_MPEG_STREAM_VBI_FMT_IVTV:
-     *
-     * Structure of payload contained in an MPEG 2 Private Stream 1 PES Packet in an
-     * MPEG-2 Program Pack that contains V4L2_MPEG_STREAM_VBI_FMT_IVTV Sliced VBI
-     * data
-     *
-     * Note, the MPEG-2 Program Pack and Private Stream 1 PES packet header
-     * definitions are not included here.  See the MPEG-2 specifications for details
-     * on these headers.
-     */
-
-    /* Line type IDs */
-    #define V4L2_MPEG_VBI_IVTV_TELETEXT_B     (1)
-    #define V4L2_MPEG_VBI_IVTV_CAPTION_525    (4)
-    #define V4L2_MPEG_VBI_IVTV_WSS_625        (5)
-    #define V4L2_MPEG_VBI_IVTV_VPS            (7)
-
-    struct v4l2_mpeg_vbi_itv0_line {
-	    __u8 id;        /* One of V4L2_MPEG_VBI_IVTV_* above */
-	    __u8 data[42];  /* Sliced VBI data for the line */
-    } __attribute__ ((packed));
-
-    struct v4l2_mpeg_vbi_itv0 {
-	    __le32 linemask[2]; /* Bitmasks of VBI service lines present */
-	    struct v4l2_mpeg_vbi_itv0_line line[35];
-    } __attribute__ ((packed));
-
-    struct v4l2_mpeg_vbi_ITV0 {
-	    struct v4l2_mpeg_vbi_itv0_line line[36];
-    } __attribute__ ((packed));
-
-    #define V4L2_MPEG_VBI_IVTV_MAGIC0       "itv0"
-    #define V4L2_MPEG_VBI_IVTV_MAGIC1       "ITV0"
-
-    struct v4l2_mpeg_vbi_fmt_ivtv {
-	    __u8 magic[4];
-	    union {
-		    struct v4l2_mpeg_vbi_itv0 itv0;
-		    struct v4l2_mpeg_vbi_ITV0 ITV0;
-	    };
-    } __attribute__ ((packed));
-
-    /*
-     *      A G G R E G A T E   S T R U C T U R E S
-     */
-
-    /**
-     * struct v4l2_plane_pix_format - additional, per-plane format definition
-     * @sizeimage:          maximum size in bytes required for data, for which
-     *                      this plane will be used
-     * @bytesperline:       distance in bytes between the leftmost pixels in two
-     *                      adjacent lines
-     */
-    struct v4l2_plane_pix_format {
-	    __u32           sizeimage;
-	    __u32           bytesperline;
-	    __u16           reserved[6];
-    } __attribute__ ((packed));
-
-    /**
-     * struct v4l2_pix_format_mplane - multiplanar format definition
-     * @width:              image width in pixels
-     * @height:             image height in pixels
-     * @pixelformat:        little endian four character code (fourcc)
-     * @field:              enum v4l2_field; field order (for interlaced video)
-     * @colorspace:         enum v4l2_colorspace; supplemental to pixelformat
-     * @plane_fmt:          per-plane information
-     * @num_planes:         number of planes for this format
-     * @flags:              format flags (V4L2_PIX_FMT_FLAG_*)
-     * @ycbcr_enc:          enum v4l2_ycbcr_encoding, Y'CbCr encoding
-     * @quantization:       enum v4l2_quantization, colorspace quantization
-     * @xfer_func:          enum v4l2_xfer_func, colorspace transfer function
-     */
-    struct v4l2_pix_format_mplane {
-	    __u32                           width;
-	    __u32                           height;
-	    __u32                           pixelformat;
-	    __u32                           field;
-	    __u32                           colorspace;
-
-	    struct v4l2_plane_pix_format    plane_fmt[VIDEO_MAX_PLANES];
-	    __u8                            num_planes;
-	    __u8                            flags;
-	    __u8                            ycbcr_enc;
-	    __u8                            quantization;
-	    __u8                            xfer_func;
-	    __u8                            reserved[7];
-    } __attribute__ ((packed));
-
-    /**
-     * struct v4l2_sdr_format - SDR format definition
-     * @pixelformat:        little endian four character code (fourcc)
-     * @buffersize:         maximum size in bytes required for data
-     */
-    struct v4l2_sdr_format {
-	    __u32                           pixelformat;
-	    __u32                           buffersize;
-	    __u8                            reserved[24];
-    } __attribute__ ((packed));
-
-    /**
-     * struct v4l2_format - stream data format
-     * @type:       enum v4l2_buf_type; type of the data stream
-     * @pix:        definition of an image format
-     * @pix_mp:     definition of a multiplanar image format
-     * @win:        definition of an overlaid image
-     * @vbi:        raw VBI capture or output parameters
-     * @sliced:     sliced VBI capture or output parameters
-     * @raw_data:   placeholder for future extensions and custom formats
-     */
-    struct v4l2_format {
-	    __u32    type;
-	    union {
-		    struct v4l2_pix_format          pix;     /* V4L2_BUF_TYPE_VIDEO_CAPTURE */
-		    struct v4l2_pix_format_mplane   pix_mp;  /* V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE */
-		    struct v4l2_window              win;     /* V4L2_BUF_TYPE_VIDEO_OVERLAY */
-		    struct v4l2_vbi_format          vbi;     /* V4L2_BUF_TYPE_VBI_CAPTURE */
-		    struct v4l2_sliced_vbi_format   sliced;  /* V4L2_BUF_TYPE_SLICED_VBI_CAPTURE */
-		    struct v4l2_sdr_format          sdr;     /* V4L2_BUF_TYPE_SDR_CAPTURE */
-		    __u8    raw_data[200];                   /* user-defined */
-	    } fmt;
-    };
-
-    /*      Stream type-dependent parameters
-     */
-    struct v4l2_streamparm {
-	    __u32    type;                  /* enum v4l2_buf_type */
-	    union {
-		    struct v4l2_captureparm capture;
-		    struct v4l2_outputparm  output;
-		    __u8    raw_data[200];  /* user-defined */
-	    } parm;
-    };
-
-    /*
-     *      E V E N T S
-     */
-
-    #define V4L2_EVENT_ALL                          0
-    #define V4L2_EVENT_VSYNC                        1
-    #define V4L2_EVENT_EOS                          2
-    #define V4L2_EVENT_CTRL                         3
-    #define V4L2_EVENT_FRAME_SYNC                   4
-    #define V4L2_EVENT_SOURCE_CHANGE                5
-    #define V4L2_EVENT_MOTION_DET                   6
-    #define V4L2_EVENT_PRIVATE_START                0x08000000
-
-    /* Payload for V4L2_EVENT_VSYNC */
-    struct v4l2_event_vsync {
-	    /* Can be V4L2_FIELD_ANY, _NONE, _TOP or _BOTTOM */
-	    __u8 field;
-    } __attribute__ ((packed));
-
-    /* Payload for V4L2_EVENT_CTRL */
-    #define V4L2_EVENT_CTRL_CH_VALUE                (1 << 0)
-    #define V4L2_EVENT_CTRL_CH_FLAGS                (1 << 1)
-    #define V4L2_EVENT_CTRL_CH_RANGE                (1 << 2)
-
-    struct v4l2_event_ctrl {
-	    __u32 changes;
-	    __u32 type;
-	    union {
-		    __s32 value;
-		    __s64 value64;
-	    };
-	    __u32 flags;
-	    __s32 minimum;
-	    __s32 maximum;
-	    __s32 step;
-	    __s32 default_value;
-    };
-
-    struct v4l2_event_frame_sync {
-	    __u32 frame_sequence;
-    };
-
-    #define V4L2_EVENT_SRC_CH_RESOLUTION            (1 << 0)
-
-    struct v4l2_event_src_change {
-	    __u32 changes;
-    };
-
-    #define V4L2_EVENT_MD_FL_HAVE_FRAME_SEQ (1 << 0)
-
-    /**
-     * struct v4l2_event_motion_det - motion detection event
-     * @flags:             if V4L2_EVENT_MD_FL_HAVE_FRAME_SEQ is set, then the
-     *                     frame_sequence field is valid.
-     * @frame_sequence:    the frame sequence number associated with this event.
-     * @region_mask:       which regions detected motion.
-     */
-    struct v4l2_event_motion_det {
-	    __u32 flags;
-	    __u32 frame_sequence;
-	    __u32 region_mask;
-    };
-
-    struct v4l2_event {
-	    __u32                           type;
-	    union {
-		    struct v4l2_event_vsync         vsync;
-		    struct v4l2_event_ctrl          ctrl;
-		    struct v4l2_event_frame_sync    frame_sync;
-		    struct v4l2_event_src_change    src_change;
-		    struct v4l2_event_motion_det    motion_det;
-		    __u8                            data[64];
-	    } u;
-	    __u32                           pending;
-	    __u32                           sequence;
-	    struct timespec                 timestamp;
-	    __u32                           id;
-	    __u32                           reserved[8];
-    };
-
-    #define V4L2_EVENT_SUB_FL_SEND_INITIAL          (1 << 0)
-    #define V4L2_EVENT_SUB_FL_ALLOW_FEEDBACK        (1 << 1)
-
-    struct v4l2_event_subscription {
-	    __u32                           type;
-	    __u32                           id;
-	    __u32                           flags;
-	    __u32                           reserved[5];
-    };
-
-    /*
-     *      A D V A N C E D   D E B U G G I N G
-     *
-     *      NOTE: EXPERIMENTAL API, NEVER RELY ON THIS IN APPLICATIONS!
-     *      FOR DEBUGGING, TESTING AND INTERNAL USE ONLY!
-     */
-
-    /* VIDIOC_DBG_G_REGISTER and VIDIOC_DBG_S_REGISTER */
-
-    #define V4L2_CHIP_MATCH_BRIDGE      0  /* Match against chip ID on the bridge (0 for the bridge) */
-    #define V4L2_CHIP_MATCH_SUBDEV      4  /* Match against subdev index */
-
-    /* The following four defines are no longer in use */
-    #define V4L2_CHIP_MATCH_HOST V4L2_CHIP_MATCH_BRIDGE
-    #define V4L2_CHIP_MATCH_I2C_DRIVER  1  /* Match against I2C driver name */
-    #define V4L2_CHIP_MATCH_I2C_ADDR    2  /* Match against I2C 7-bit address */
-    #define V4L2_CHIP_MATCH_AC97        3  /* Match against ancillary AC97 chip */
-
-    struct v4l2_dbg_match {
-	    __u32 type; /* Match type */
-	    union {     /* Match this chip, meaning determined by type */
-		    __u32 addr;
-		    char name[32];
-	    };
-    } __attribute__ ((packed));
-
-    struct v4l2_dbg_register {
-	    struct v4l2_dbg_match match;
-	    __u32 size;     /* register size in bytes */
-	    __u64 reg;
-	    __u64 val;
-    } __attribute__ ((packed));
-
-    #define V4L2_CHIP_FL_READABLE (1 << 0)
-    #define V4L2_CHIP_FL_WRITABLE (1 << 1)
-
-    /* VIDIOC_DBG_G_CHIP_INFO */
-    struct v4l2_dbg_chip_info {
-	    struct v4l2_dbg_match match;
-	    char name[32];
-	    __u32 flags;
-	    __u32 reserved[32];
-    } __attribute__ ((packed));
-
-    /**
-     * struct v4l2_create_buffers - VIDIOC_CREATE_BUFS argument
-     * @index:      on return, index of the first created buffer
-     * @count:      entry: number of requested buffers,
-     *              return: number of created buffers
-     * @memory:     enum v4l2_memory; buffer memory type
-     * @format:     frame format, for which buffers are requested
-     * @reserved:   future extensions
-     */
-    struct v4l2_create_buffers {
-	    __u32                   index;
-	    __u32                   count;
-	    __u32                   memory;
-	    struct v4l2_format      format;
-	    __u32                   reserved[8];
-    };
-
-    /*
-     *      I O C T L   C O D E S   F O R   V I D E O   D E V I C E S
-     *
-     */
-    #define VIDIOC_QUERYCAP          _IOR('V',  0, struct v4l2_capability)
-    #define VIDIOC_RESERVED           _IO('V',  1)
-    #define VIDIOC_ENUM_FMT         _IOWR('V',  2, struct v4l2_fmtdesc)
-    #define VIDIOC_G_FMT            _IOWR('V',  4, struct v4l2_format)
-    #define VIDIOC_S_FMT            _IOWR('V',  5, struct v4l2_format)
-    #define VIDIOC_REQBUFS          _IOWR('V',  8, struct v4l2_requestbuffers)
-    #define VIDIOC_QUERYBUF         _IOWR('V',  9, struct v4l2_buffer)
-    #define VIDIOC_G_FBUF            _IOR('V', 10, struct v4l2_framebuffer)
-    #define VIDIOC_S_FBUF            _IOW('V', 11, struct v4l2_framebuffer)
-    #define VIDIOC_OVERLAY           _IOW('V', 14, int)
-    #define VIDIOC_QBUF             _IOWR('V', 15, struct v4l2_buffer)
-    #define VIDIOC_EXPBUF           _IOWR('V', 16, struct v4l2_exportbuffer)
-    #define VIDIOC_DQBUF            _IOWR('V', 17, struct v4l2_buffer)
-    #define VIDIOC_STREAMON          _IOW('V', 18, int)
-    #define VIDIOC_STREAMOFF         _IOW('V', 19, int)
-    #define VIDIOC_G_PARM           _IOWR('V', 21, struct v4l2_streamparm)
-    #define VIDIOC_S_PARM           _IOWR('V', 22, struct v4l2_streamparm)
-    #define VIDIOC_G_STD             _IOR('V', 23, v4l2_std_id)
-    #define VIDIOC_S_STD             _IOW('V', 24, v4l2_std_id)
-    #define VIDIOC_ENUMSTD          _IOWR('V', 25, struct v4l2_standard)
-    #define VIDIOC_ENUMINPUT        _IOWR('V', 26, struct v4l2_input)
-    #define VIDIOC_G_CTRL           _IOWR('V', 27, struct v4l2_control)
-    #define VIDIOC_S_CTRL           _IOWR('V', 28, struct v4l2_control)
-    #define VIDIOC_G_TUNER          _IOWR('V', 29, struct v4l2_tuner)
-    #define VIDIOC_S_TUNER           _IOW('V', 30, struct v4l2_tuner)
-    #define VIDIOC_G_AUDIO           _IOR('V', 33, struct v4l2_audio)
-    #define VIDIOC_S_AUDIO           _IOW('V', 34, struct v4l2_audio)
-    #define VIDIOC_QUERYCTRL        _IOWR('V', 36, struct v4l2_queryctrl)
-    #define VIDIOC_QUERYMENU        _IOWR('V', 37, struct v4l2_querymenu)
-    #define VIDIOC_G_INPUT           _IOR('V', 38, int)
-    #define VIDIOC_S_INPUT          _IOWR('V', 39, int)
-    #define VIDIOC_G_EDID           _IOWR('V', 40, struct v4l2_edid)
-    #define VIDIOC_S_EDID           _IOWR('V', 41, struct v4l2_edid)
-    #define VIDIOC_G_OUTPUT          _IOR('V', 46, int)
-    #define VIDIOC_S_OUTPUT         _IOWR('V', 47, int)
-    #define VIDIOC_ENUMOUTPUT       _IOWR('V', 48, struct v4l2_output)
-    #define VIDIOC_G_AUDOUT          _IOR('V', 49, struct v4l2_audioout)
-    #define VIDIOC_S_AUDOUT          _IOW('V', 50, struct v4l2_audioout)
-    #define VIDIOC_G_MODULATOR      _IOWR('V', 54, struct v4l2_modulator)
-    #define VIDIOC_S_MODULATOR       _IOW('V', 55, struct v4l2_modulator)
-    #define VIDIOC_G_FREQUENCY      _IOWR('V', 56, struct v4l2_frequency)
-    #define VIDIOC_S_FREQUENCY       _IOW('V', 57, struct v4l2_frequency)
-    #define VIDIOC_CROPCAP          _IOWR('V', 58, struct v4l2_cropcap)
-    #define VIDIOC_G_CROP           _IOWR('V', 59, struct v4l2_crop)
-    #define VIDIOC_S_CROP            _IOW('V', 60, struct v4l2_crop)
-    #define VIDIOC_G_JPEGCOMP        _IOR('V', 61, struct v4l2_jpegcompression)
-    #define VIDIOC_S_JPEGCOMP        _IOW('V', 62, struct v4l2_jpegcompression)
-    #define VIDIOC_QUERYSTD          _IOR('V', 63, v4l2_std_id)
-    #define VIDIOC_TRY_FMT          _IOWR('V', 64, struct v4l2_format)
-    #define VIDIOC_ENUMAUDIO        _IOWR('V', 65, struct v4l2_audio)
-    #define VIDIOC_ENUMAUDOUT       _IOWR('V', 66, struct v4l2_audioout)
-    #define VIDIOC_G_PRIORITY        _IOR('V', 67, __u32) /* enum v4l2_priority */
-    #define VIDIOC_S_PRIORITY        _IOW('V', 68, __u32) /* enum v4l2_priority */
-    #define VIDIOC_G_SLICED_VBI_CAP _IOWR('V', 69, struct v4l2_sliced_vbi_cap)
-    #define VIDIOC_LOG_STATUS         _IO('V', 70)
-    #define VIDIOC_G_EXT_CTRLS      _IOWR('V', 71, struct v4l2_ext_controls)
-    #define VIDIOC_S_EXT_CTRLS      _IOWR('V', 72, struct v4l2_ext_controls)
-    #define VIDIOC_TRY_EXT_CTRLS    _IOWR('V', 73, struct v4l2_ext_controls)
-    #define VIDIOC_ENUM_FRAMESIZES  _IOWR('V', 74, struct v4l2_frmsizeenum)
-    #define VIDIOC_ENUM_FRAMEINTERVALS _IOWR('V', 75, struct v4l2_frmivalenum)
-    #define VIDIOC_G_ENC_INDEX       _IOR('V', 76, struct v4l2_enc_idx)
-    #define VIDIOC_ENCODER_CMD      _IOWR('V', 77, struct v4l2_encoder_cmd)
-    #define VIDIOC_TRY_ENCODER_CMD  _IOWR('V', 78, struct v4l2_encoder_cmd)
-
-    /*
-     * Experimental, meant for debugging, testing and internal use.
-     * Only implemented if CONFIG_VIDEO_ADV_DEBUG is defined.
-     * You must be root to use these ioctls. Never use these in applications!
-     */
-    #define VIDIOC_DBG_S_REGISTER    _IOW('V', 79, struct v4l2_dbg_register)
-    #define VIDIOC_DBG_G_REGISTER   _IOWR('V', 80, struct v4l2_dbg_register)
-
-    #define VIDIOC_S_HW_FREQ_SEEK    _IOW('V', 82, struct v4l2_hw_freq_seek)
-    #define VIDIOC_S_DV_TIMINGS     _IOWR('V', 87, struct v4l2_dv_timings)
-    #define VIDIOC_G_DV_TIMINGS     _IOWR('V', 88, struct v4l2_dv_timings)
-    #define VIDIOC_DQEVENT           _IOR('V', 89, struct v4l2_event)
-    #define VIDIOC_SUBSCRIBE_EVENT   _IOW('V', 90, struct v4l2_event_subscription)
-    #define VIDIOC_UNSUBSCRIBE_EVENT _IOW('V', 91, struct v4l2_event_subscription)
-    #define VIDIOC_CREATE_BUFS      _IOWR('V', 92, struct v4l2_create_buffers)
-    #define VIDIOC_PREPARE_BUF      _IOWR('V', 93, struct v4l2_buffer)
-    #define VIDIOC_G_SELECTION      _IOWR('V', 94, struct v4l2_selection)
-    #define VIDIOC_S_SELECTION      _IOWR('V', 95, struct v4l2_selection)
-    #define VIDIOC_DECODER_CMD      _IOWR('V', 96, struct v4l2_decoder_cmd)
-    #define VIDIOC_TRY_DECODER_CMD  _IOWR('V', 97, struct v4l2_decoder_cmd)
-    #define VIDIOC_ENUM_DV_TIMINGS  _IOWR('V', 98, struct v4l2_enum_dv_timings)
-    #define VIDIOC_QUERY_DV_TIMINGS  _IOR('V', 99, struct v4l2_dv_timings)
-    #define VIDIOC_DV_TIMINGS_CAP   _IOWR('V', 100, struct v4l2_dv_timings_cap)
-    #define VIDIOC_ENUM_FREQ_BANDS  _IOWR('V', 101, struct v4l2_frequency_band)
-
-    /*
-     * Experimental, meant for debugging, testing and internal use.
-     * Never use this in applications!
-     */
-    #define VIDIOC_DBG_G_CHIP_INFO  _IOWR('V', 102, struct v4l2_dbg_chip_info)
-
-    #define VIDIOC_QUERY_EXT_CTRL   _IOWR('V', 103, struct v4l2_query_ext_ctrl)
-
-    /* Reminder: when adding new ioctls please add support for them to
-       drivers/media/v4l2-core/v4l2-compat-ioctl32.c as well! */
-
-    #define BASE_VIDIOC_PRIVATE     192             /* 192-255 are private */
-
-    #endif /* _UAPI__LINUX_VIDEODEV2_H */
diff --git a/Documentation/linux_tv/videodev2.h.rst.exceptions b/Documentation/linux_tv/videodev2.h.rst.exceptions
new file mode 100644
index 000000000000..abc9144feba9
--- /dev/null
+++ b/Documentation/linux_tv/videodev2.h.rst.exceptions
@@ -0,0 +1,591 @@
+# Ignore header name
+ignore define _UAPI__LINUX_VIDEODEV2_H
+
+#
+# The cross reference valitator for videodev2.h DocBook never cared
+# about enum symbols or defines. Yet, they're all (or almost all?)
+# handled inside V4L API sections. So, for now, it is safe to just
+# ignore. This should be revisited, as validating it helps to avoid
+# having something not documented at the uAPI.
+#
+
+# for now, ignore all enum symbols
+ignore symbol V4L2_BUF_TYPE_PRIVATE
+ignore symbol V4L2_BUF_TYPE_SDR_CAPTURE
+ignore symbol V4L2_BUF_TYPE_SDR_OUTPUT
+ignore symbol V4L2_BUF_TYPE_SLICED_VBI_CAPTURE
+ignore symbol V4L2_BUF_TYPE_SLICED_VBI_OUTPUT
+ignore symbol V4L2_BUF_TYPE_VBI_CAPTURE
+ignore symbol V4L2_BUF_TYPE_VBI_OUTPUT
+ignore symbol V4L2_BUF_TYPE_VIDEO_CAPTURE
+ignore symbol V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE
+ignore symbol V4L2_BUF_TYPE_VIDEO_OUTPUT
+ignore symbol V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE
+ignore symbol V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY
+ignore symbol V4L2_BUF_TYPE_VIDEO_OVERLAY
+ignore symbol V4L2_COLORSPACE_470_SYSTEM_BG
+ignore symbol V4L2_COLORSPACE_470_SYSTEM_M
+ignore symbol V4L2_COLORSPACE_ADOBERGB
+ignore symbol V4L2_COLORSPACE_BT2020
+ignore symbol V4L2_COLORSPACE_BT878
+ignore symbol V4L2_COLORSPACE_DCI_P3
+ignore symbol V4L2_COLORSPACE_DEFAULT
+ignore symbol V4L2_COLORSPACE_JPEG
+ignore symbol V4L2_COLORSPACE_RAW
+ignore symbol V4L2_COLORSPACE_REC709
+ignore symbol V4L2_COLORSPACE_SMPTE170M
+ignore symbol V4L2_COLORSPACE_SMPTE240M
+ignore symbol V4L2_COLORSPACE_SRGB
+ignore symbol V4L2_CTRL_COMPOUND_TYPES
+ignore symbol V4L2_CTRL_TYPE_BITMASK
+ignore symbol V4L2_CTRL_TYPE_BOOLEAN
+ignore symbol V4L2_CTRL_TYPE_BUTTON
+ignore symbol V4L2_CTRL_TYPE_CTRL_CLASS
+ignore symbol V4L2_CTRL_TYPE_INTEGER
+ignore symbol V4L2_CTRL_TYPE_INTEGER64
+ignore symbol V4L2_CTRL_TYPE_INTEGER_MENU
+ignore symbol V4L2_CTRL_TYPE_MENU
+ignore symbol V4L2_CTRL_TYPE_STRING
+ignore symbol V4L2_CTRL_TYPE_U16
+ignore symbol V4L2_CTRL_TYPE_U32
+ignore symbol V4L2_CTRL_TYPE_U8
+ignore symbol V4L2_FIELD_ALTERNATE
+ignore symbol V4L2_FIELD_ANY
+ignore symbol V4L2_FIELD_BOTTOM
+ignore symbol V4L2_FIELD_INTERLACED
+ignore symbol V4L2_FIELD_INTERLACED_BT
+ignore symbol V4L2_FIELD_INTERLACED_TB
+ignore symbol V4L2_FIELD_NONE
+ignore symbol V4L2_FIELD_SEQ_BT
+ignore symbol V4L2_FIELD_SEQ_TB
+ignore symbol V4L2_FIELD_TOP
+ignore symbol V4L2_FRMIVAL_TYPE_CONTINUOUS
+ignore symbol V4L2_FRMIVAL_TYPE_DISCRETE
+ignore symbol V4L2_FRMIVAL_TYPE_STEPWISE
+ignore symbol V4L2_FRMSIZE_TYPE_CONTINUOUS
+ignore symbol V4L2_FRMSIZE_TYPE_DISCRETE
+ignore symbol V4L2_FRMSIZE_TYPE_STEPWISE
+ignore symbol V4L2_MEMORY_DMABUF
+ignore symbol V4L2_MEMORY_MMAP
+ignore symbol V4L2_MEMORY_OVERLAY
+ignore symbol V4L2_MEMORY_USERPTR
+ignore symbol V4L2_PRIORITY_BACKGROUND
+ignore symbol V4L2_PRIORITY_DEFAULT
+ignore symbol V4L2_PRIORITY_INTERACTIVE
+ignore symbol V4L2_PRIORITY_RECORD
+ignore symbol V4L2_PRIORITY_UNSET
+ignore symbol V4L2_QUANTIZATION_DEFAULT
+ignore symbol V4L2_QUANTIZATION_FULL_RANGE
+ignore symbol V4L2_QUANTIZATION_LIM_RANGE
+ignore symbol V4L2_TUNER_ANALOG_TV
+ignore symbol V4L2_TUNER_DIGITAL_TV
+ignore symbol V4L2_TUNER_RADIO
+ignore symbol V4L2_TUNER_RF
+ignore symbol V4L2_TUNER_SDR
+ignore symbol V4L2_XFER_FUNC_709
+ignore symbol V4L2_XFER_FUNC_ADOBERGB
+ignore symbol V4L2_XFER_FUNC_DCI_P3
+ignore symbol V4L2_XFER_FUNC_DEFAULT
+ignore symbol V4L2_XFER_FUNC_NONE
+ignore symbol V4L2_XFER_FUNC_SMPTE2084
+ignore symbol V4L2_XFER_FUNC_SMPTE240M
+ignore symbol V4L2_XFER_FUNC_SRGB
+ignore symbol V4L2_YCBCR_ENC_601
+ignore symbol V4L2_YCBCR_ENC_709
+ignore symbol V4L2_YCBCR_ENC_BT2020
+ignore symbol V4L2_YCBCR_ENC_BT2020_CONST_LUM
+ignore symbol V4L2_YCBCR_ENC_DEFAULT
+ignore symbol V4L2_YCBCR_ENC_SMPTE240M
+ignore symbol V4L2_YCBCR_ENC_SYCC
+ignore symbol V4L2_YCBCR_ENC_XV601
+ignore symbol V4L2_YCBCR_ENC_XV709
+
+# For now, ignore all defines
+ignore define VIDEO_MAX_FRAME
+ignore define VIDEO_MAX_PLANES
+ignore define v4l2_fourcc
+ignore define v4l2_fourcc_be
+ignore define V4L2_FIELD_HAS_TOP
+ignore define V4L2_FIELD_HAS_BOTTOM
+ignore define V4L2_FIELD_HAS_BOTH
+ignore define V4L2_FIELD_HAS_T_OR_B
+ignore define V4L2_TYPE_IS_MULTIPLANAR
+ignore define V4L2_TYPE_IS_OUTPUT
+ignore define V4L2_TUNER_ADC
+ignore define V4L2_MAP_COLORSPACE_DEFAULT
+ignore define V4L2_MAP_XFER_FUNC_DEFAULT
+ignore define V4L2_MAP_YCBCR_ENC_DEFAULT
+ignore define V4L2_CAP_VIDEO_CAPTURE
+ignore define V4L2_CAP_VIDEO_OUTPUT
+ignore define V4L2_CAP_VIDEO_OVERLAY
+ignore define V4L2_CAP_VBI_CAPTURE
+ignore define V4L2_CAP_VBI_OUTPUT
+ignore define V4L2_CAP_SLICED_VBI_CAPTURE
+ignore define V4L2_CAP_SLICED_VBI_OUTPUT
+ignore define V4L2_CAP_RDS_CAPTURE
+ignore define V4L2_CAP_VIDEO_OUTPUT_OVERLAY
+ignore define V4L2_CAP_HW_FREQ_SEEK
+ignore define V4L2_CAP_RDS_OUTPUT
+ignore define V4L2_CAP_VIDEO_CAPTURE_MPLANE
+ignore define V4L2_CAP_VIDEO_OUTPUT_MPLANE
+ignore define V4L2_CAP_VIDEO_M2M_MPLANE
+ignore define V4L2_CAP_VIDEO_M2M
+ignore define V4L2_CAP_TUNER
+ignore define V4L2_CAP_AUDIO
+ignore define V4L2_CAP_RADIO
+ignore define V4L2_CAP_MODULATOR
+ignore define V4L2_CAP_SDR_CAPTURE
+ignore define V4L2_CAP_EXT_PIX_FORMAT
+ignore define V4L2_CAP_SDR_OUTPUT
+ignore define V4L2_CAP_READWRITE
+ignore define V4L2_CAP_ASYNCIO
+ignore define V4L2_CAP_STREAMING
+ignore define V4L2_CAP_DEVICE_CAPS
+ignore define V4L2_PIX_FMT_RGB332
+ignore define V4L2_PIX_FMT_RGB444
+ignore define V4L2_PIX_FMT_ARGB444
+ignore define V4L2_PIX_FMT_XRGB444
+ignore define V4L2_PIX_FMT_RGB555
+ignore define V4L2_PIX_FMT_ARGB555
+ignore define V4L2_PIX_FMT_XRGB555
+ignore define V4L2_PIX_FMT_RGB565
+ignore define V4L2_PIX_FMT_RGB555X
+ignore define V4L2_PIX_FMT_ARGB555X
+ignore define V4L2_PIX_FMT_XRGB555X
+ignore define V4L2_PIX_FMT_RGB565X
+ignore define V4L2_PIX_FMT_BGR666
+ignore define V4L2_PIX_FMT_BGR24
+ignore define V4L2_PIX_FMT_RGB24
+ignore define V4L2_PIX_FMT_BGR32
+ignore define V4L2_PIX_FMT_ABGR32
+ignore define V4L2_PIX_FMT_XBGR32
+ignore define V4L2_PIX_FMT_RGB32
+ignore define V4L2_PIX_FMT_ARGB32
+ignore define V4L2_PIX_FMT_XRGB32
+ignore define V4L2_PIX_FMT_GREY
+ignore define V4L2_PIX_FMT_Y4
+ignore define V4L2_PIX_FMT_Y6
+ignore define V4L2_PIX_FMT_Y10
+ignore define V4L2_PIX_FMT_Y12
+ignore define V4L2_PIX_FMT_Y16
+ignore define V4L2_PIX_FMT_Y16_BE
+ignore define V4L2_PIX_FMT_Y10BPACK
+ignore define V4L2_PIX_FMT_PAL8
+ignore define V4L2_PIX_FMT_UV8
+ignore define V4L2_PIX_FMT_YUYV
+ignore define V4L2_PIX_FMT_YYUV
+ignore define V4L2_PIX_FMT_YVYU
+ignore define V4L2_PIX_FMT_UYVY
+ignore define V4L2_PIX_FMT_VYUY
+ignore define V4L2_PIX_FMT_Y41P
+ignore define V4L2_PIX_FMT_YUV444
+ignore define V4L2_PIX_FMT_YUV555
+ignore define V4L2_PIX_FMT_YUV565
+ignore define V4L2_PIX_FMT_YUV32
+ignore define V4L2_PIX_FMT_HI240
+ignore define V4L2_PIX_FMT_HM12
+ignore define V4L2_PIX_FMT_M420
+ignore define V4L2_PIX_FMT_NV12
+ignore define V4L2_PIX_FMT_NV21
+ignore define V4L2_PIX_FMT_NV16
+ignore define V4L2_PIX_FMT_NV61
+ignore define V4L2_PIX_FMT_NV24
+ignore define V4L2_PIX_FMT_NV42
+ignore define V4L2_PIX_FMT_NV12M
+ignore define V4L2_PIX_FMT_NV21M
+ignore define V4L2_PIX_FMT_NV16M
+ignore define V4L2_PIX_FMT_NV61M
+ignore define V4L2_PIX_FMT_NV12MT
+ignore define V4L2_PIX_FMT_NV12MT_16X16
+ignore define V4L2_PIX_FMT_YUV410
+ignore define V4L2_PIX_FMT_YVU410
+ignore define V4L2_PIX_FMT_YUV411P
+ignore define V4L2_PIX_FMT_YUV420
+ignore define V4L2_PIX_FMT_YVU420
+ignore define V4L2_PIX_FMT_YUV422P
+ignore define V4L2_PIX_FMT_YUV420M
+ignore define V4L2_PIX_FMT_YVU420M
+ignore define V4L2_PIX_FMT_YUV422M
+ignore define V4L2_PIX_FMT_YVU422M
+ignore define V4L2_PIX_FMT_YUV444M
+ignore define V4L2_PIX_FMT_YVU444M
+ignore define V4L2_PIX_FMT_SBGGR8
+ignore define V4L2_PIX_FMT_SGBRG8
+ignore define V4L2_PIX_FMT_SGRBG8
+ignore define V4L2_PIX_FMT_SRGGB8
+ignore define V4L2_PIX_FMT_SBGGR10
+ignore define V4L2_PIX_FMT_SGBRG10
+ignore define V4L2_PIX_FMT_SGRBG10
+ignore define V4L2_PIX_FMT_SRGGB10
+ignore define V4L2_PIX_FMT_SBGGR10P
+ignore define V4L2_PIX_FMT_SGBRG10P
+ignore define V4L2_PIX_FMT_SGRBG10P
+ignore define V4L2_PIX_FMT_SRGGB10P
+ignore define V4L2_PIX_FMT_SBGGR10ALAW8
+ignore define V4L2_PIX_FMT_SGBRG10ALAW8
+ignore define V4L2_PIX_FMT_SGRBG10ALAW8
+ignore define V4L2_PIX_FMT_SRGGB10ALAW8
+ignore define V4L2_PIX_FMT_SBGGR10DPCM8
+ignore define V4L2_PIX_FMT_SGBRG10DPCM8
+ignore define V4L2_PIX_FMT_SGRBG10DPCM8
+ignore define V4L2_PIX_FMT_SRGGB10DPCM8
+ignore define V4L2_PIX_FMT_SBGGR12
+ignore define V4L2_PIX_FMT_SGBRG12
+ignore define V4L2_PIX_FMT_SGRBG12
+ignore define V4L2_PIX_FMT_SRGGB12
+ignore define V4L2_PIX_FMT_SBGGR16
+ignore define V4L2_PIX_FMT_MJPEG
+ignore define V4L2_PIX_FMT_JPEG
+ignore define V4L2_PIX_FMT_DV
+ignore define V4L2_PIX_FMT_MPEG
+ignore define V4L2_PIX_FMT_H264
+ignore define V4L2_PIX_FMT_H264_NO_SC
+ignore define V4L2_PIX_FMT_H264_MVC
+ignore define V4L2_PIX_FMT_H263
+ignore define V4L2_PIX_FMT_MPEG1
+ignore define V4L2_PIX_FMT_MPEG2
+ignore define V4L2_PIX_FMT_MPEG4
+ignore define V4L2_PIX_FMT_XVID
+ignore define V4L2_PIX_FMT_VC1_ANNEX_G
+ignore define V4L2_PIX_FMT_VC1_ANNEX_L
+ignore define V4L2_PIX_FMT_VP8
+ignore define V4L2_PIX_FMT_CPIA1
+ignore define V4L2_PIX_FMT_WNVA
+ignore define V4L2_PIX_FMT_SN9C10X
+ignore define V4L2_PIX_FMT_SN9C20X_I420
+ignore define V4L2_PIX_FMT_PWC1
+ignore define V4L2_PIX_FMT_PWC2
+ignore define V4L2_PIX_FMT_ET61X251
+ignore define V4L2_PIX_FMT_SPCA501
+ignore define V4L2_PIX_FMT_SPCA505
+ignore define V4L2_PIX_FMT_SPCA508
+ignore define V4L2_PIX_FMT_SPCA561
+ignore define V4L2_PIX_FMT_PAC207
+ignore define V4L2_PIX_FMT_MR97310A
+ignore define V4L2_PIX_FMT_JL2005BCD
+ignore define V4L2_PIX_FMT_SN9C2028
+ignore define V4L2_PIX_FMT_SQ905C
+ignore define V4L2_PIX_FMT_PJPG
+ignore define V4L2_PIX_FMT_OV511
+ignore define V4L2_PIX_FMT_OV518
+ignore define V4L2_PIX_FMT_STV0680
+ignore define V4L2_PIX_FMT_TM6000
+ignore define V4L2_PIX_FMT_CIT_YYVYUY
+ignore define V4L2_PIX_FMT_KONICA420
+ignore define V4L2_PIX_FMT_JPGL
+ignore define V4L2_PIX_FMT_SE401
+ignore define V4L2_PIX_FMT_S5C_UYVY_JPG
+ignore define V4L2_PIX_FMT_Y8I
+ignore define V4L2_PIX_FMT_Y12I
+ignore define V4L2_PIX_FMT_Z16
+ignore define V4L2_SDR_FMT_CU8
+ignore define V4L2_SDR_FMT_CU16LE
+ignore define V4L2_SDR_FMT_CS8
+ignore define V4L2_SDR_FMT_CS14LE
+ignore define V4L2_SDR_FMT_RU12LE
+ignore define V4L2_PIX_FMT_PRIV_MAGIC
+ignore define V4L2_PIX_FMT_FLAG_PREMUL_ALPHA
+ignore define V4L2_FMT_FLAG_COMPRESSED
+ignore define V4L2_FMT_FLAG_EMULATED
+ignore define V4L2_TC_TYPE_24FPS
+ignore define V4L2_TC_TYPE_25FPS
+ignore define V4L2_TC_TYPE_30FPS
+ignore define V4L2_TC_TYPE_50FPS
+ignore define V4L2_TC_TYPE_60FPS
+ignore define V4L2_TC_FLAG_DROPFRAME
+ignore define V4L2_TC_FLAG_COLORFRAME
+ignore define V4L2_TC_USERBITS_field
+ignore define V4L2_TC_USERBITS_USERDEFINED
+ignore define V4L2_TC_USERBITS_8BITCHARS
+ignore define V4L2_JPEG_MARKER_DHT
+ignore define V4L2_JPEG_MARKER_DQT
+ignore define V4L2_JPEG_MARKER_DRI
+ignore define V4L2_JPEG_MARKER_COM
+ignore define V4L2_JPEG_MARKER_APP
+ignore define V4L2_BUF_FLAG_MAPPED
+ignore define V4L2_BUF_FLAG_QUEUED
+ignore define V4L2_BUF_FLAG_DONE
+ignore define V4L2_BUF_FLAG_KEYFRAME
+ignore define V4L2_BUF_FLAG_PFRAME
+ignore define V4L2_BUF_FLAG_BFRAME
+ignore define V4L2_BUF_FLAG_ERROR
+ignore define V4L2_BUF_FLAG_TIMECODE
+ignore define V4L2_BUF_FLAG_PREPARED
+ignore define V4L2_BUF_FLAG_NO_CACHE_INVALIDATE
+ignore define V4L2_BUF_FLAG_NO_CACHE_CLEAN
+ignore define V4L2_BUF_FLAG_TIMESTAMP_MASK
+ignore define V4L2_BUF_FLAG_TIMESTAMP_UNKNOWN
+ignore define V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC
+ignore define V4L2_BUF_FLAG_TIMESTAMP_COPY
+ignore define V4L2_BUF_FLAG_TSTAMP_SRC_MASK
+ignore define V4L2_BUF_FLAG_TSTAMP_SRC_EOF
+ignore define V4L2_BUF_FLAG_TSTAMP_SRC_SOE
+ignore define V4L2_BUF_FLAG_LAST
+ignore define V4L2_FBUF_CAP_EXTERNOVERLAY
+ignore define V4L2_FBUF_CAP_CHROMAKEY
+ignore define V4L2_FBUF_CAP_LIST_CLIPPING
+ignore define V4L2_FBUF_CAP_BITMAP_CLIPPING
+ignore define V4L2_FBUF_CAP_LOCAL_ALPHA
+ignore define V4L2_FBUF_CAP_GLOBAL_ALPHA
+ignore define V4L2_FBUF_CAP_LOCAL_INV_ALPHA
+ignore define V4L2_FBUF_CAP_SRC_CHROMAKEY
+ignore define V4L2_FBUF_FLAG_PRIMARY
+ignore define V4L2_FBUF_FLAG_OVERLAY
+ignore define V4L2_FBUF_FLAG_CHROMAKEY
+ignore define V4L2_FBUF_FLAG_LOCAL_ALPHA
+ignore define V4L2_FBUF_FLAG_GLOBAL_ALPHA
+ignore define V4L2_FBUF_FLAG_LOCAL_INV_ALPHA
+ignore define V4L2_FBUF_FLAG_SRC_CHROMAKEY
+ignore define V4L2_MODE_HIGHQUALITY
+ignore define V4L2_CAP_TIMEPERFRAME
+ignore define V4L2_STD_PAL_B
+ignore define V4L2_STD_PAL_B1
+ignore define V4L2_STD_PAL_G
+ignore define V4L2_STD_PAL_H
+ignore define V4L2_STD_PAL_I
+ignore define V4L2_STD_PAL_D
+ignore define V4L2_STD_PAL_D1
+ignore define V4L2_STD_PAL_K
+ignore define V4L2_STD_PAL_M
+ignore define V4L2_STD_PAL_N
+ignore define V4L2_STD_PAL_Nc
+ignore define V4L2_STD_PAL_60
+ignore define V4L2_STD_NTSC_M
+ignore define V4L2_STD_NTSC_M_JP
+ignore define V4L2_STD_NTSC_443
+ignore define V4L2_STD_NTSC_M_KR
+ignore define V4L2_STD_SECAM_B
+ignore define V4L2_STD_SECAM_D
+ignore define V4L2_STD_SECAM_G
+ignore define V4L2_STD_SECAM_H
+ignore define V4L2_STD_SECAM_K
+ignore define V4L2_STD_SECAM_K1
+ignore define V4L2_STD_SECAM_L
+ignore define V4L2_STD_SECAM_LC
+ignore define V4L2_STD_ATSC_8_VSB
+ignore define V4L2_STD_ATSC_16_VSB
+ignore define V4L2_STD_NTSC
+ignore define V4L2_STD_SECAM_DK
+ignore define V4L2_STD_SECAM
+ignore define V4L2_STD_PAL_BG
+ignore define V4L2_STD_PAL_DK
+ignore define V4L2_STD_PAL
+ignore define V4L2_STD_B
+ignore define V4L2_STD_G
+ignore define V4L2_STD_H
+ignore define V4L2_STD_L
+ignore define V4L2_STD_GH
+ignore define V4L2_STD_DK
+ignore define V4L2_STD_BG
+ignore define V4L2_STD_MN
+ignore define V4L2_STD_MTS
+ignore define V4L2_STD_525_60
+ignore define V4L2_STD_625_50
+ignore define V4L2_STD_ATSC
+ignore define V4L2_STD_UNKNOWN
+ignore define V4L2_STD_ALL
+ignore define V4L2_DV_PROGRESSIVE
+ignore define V4L2_DV_INTERLACED
+ignore define V4L2_DV_VSYNC_POS_POL
+ignore define V4L2_DV_HSYNC_POS_POL
+ignore define V4L2_DV_BT_STD_CEA861
+ignore define V4L2_DV_BT_STD_DMT
+ignore define V4L2_DV_BT_STD_CVT
+ignore define V4L2_DV_BT_STD_GTF
+ignore define V4L2_DV_FL_REDUCED_BLANKING
+ignore define V4L2_DV_FL_CAN_REDUCE_FPS
+ignore define V4L2_DV_FL_REDUCED_FPS
+ignore define V4L2_DV_FL_HALF_LINE
+ignore define V4L2_DV_FL_IS_CE_VIDEO
+ignore define V4L2_DV_BT_BLANKING_WIDTH(bt)
+ignore define V4L2_DV_BT_FRAME_WIDTH(bt)
+ignore define V4L2_DV_BT_BLANKING_HEIGHT(bt)
+ignore define V4L2_DV_BT_FRAME_HEIGHT(bt)
+ignore define V4L2_DV_BT_656_1120
+ignore define V4L2_DV_BT_CAP_INTERLACED
+ignore define V4L2_DV_BT_CAP_PROGRESSIVE
+ignore define V4L2_DV_BT_CAP_REDUCED_BLANKING
+ignore define V4L2_DV_BT_CAP_CUSTOM
+ignore define V4L2_INPUT_TYPE_TUNER
+ignore define V4L2_INPUT_TYPE_CAMERA
+ignore define V4L2_IN_ST_NO_POWER
+ignore define V4L2_IN_ST_NO_SIGNAL
+ignore define V4L2_IN_ST_NO_COLOR
+ignore define V4L2_IN_ST_HFLIP
+ignore define V4L2_IN_ST_VFLIP
+ignore define V4L2_IN_ST_NO_H_LOCK
+ignore define V4L2_IN_ST_COLOR_KILL
+ignore define V4L2_IN_ST_NO_SYNC
+ignore define V4L2_IN_ST_NO_EQU
+ignore define V4L2_IN_ST_NO_CARRIER
+ignore define V4L2_IN_ST_MACROVISION
+ignore define V4L2_IN_ST_NO_ACCESS
+ignore define V4L2_IN_ST_VTR
+ignore define V4L2_IN_CAP_DV_TIMINGS
+ignore define V4L2_IN_CAP_CUSTOM_TIMINGS
+ignore define V4L2_IN_CAP_STD
+ignore define V4L2_IN_CAP_NATIVE_SIZE
+ignore define V4L2_OUTPUT_TYPE_MODULATOR
+ignore define V4L2_OUTPUT_TYPE_ANALOG
+ignore define V4L2_OUTPUT_TYPE_ANALOGVGAOVERLAY
+ignore define V4L2_OUT_CAP_DV_TIMINGS
+ignore define V4L2_OUT_CAP_CUSTOM_TIMINGS
+ignore define V4L2_OUT_CAP_STD
+ignore define V4L2_OUT_CAP_NATIVE_SIZE
+ignore define V4L2_CTRL_ID_MASK
+ignore define V4L2_CTRL_ID2CLASS(id)
+ignore define V4L2_CTRL_ID2WHICH(id)
+ignore define V4L2_CTRL_DRIVER_PRIV(id)
+ignore define V4L2_CTRL_MAX_DIMS
+ignore define V4L2_CTRL_WHICH_CUR_VAL
+ignore define V4L2_CTRL_WHICH_DEF_VAL
+ignore define V4L2_CTRL_FLAG_DISABLED
+ignore define V4L2_CTRL_FLAG_GRABBED
+ignore define V4L2_CTRL_FLAG_READ_ONLY
+ignore define V4L2_CTRL_FLAG_UPDATE
+ignore define V4L2_CTRL_FLAG_INACTIVE
+ignore define V4L2_CTRL_FLAG_SLIDER
+ignore define V4L2_CTRL_FLAG_WRITE_ONLY
+ignore define V4L2_CTRL_FLAG_VOLATILE
+ignore define V4L2_CTRL_FLAG_HAS_PAYLOAD
+ignore define V4L2_CTRL_FLAG_EXECUTE_ON_WRITE
+ignore define V4L2_CTRL_FLAG_NEXT_CTRL
+ignore define V4L2_CTRL_FLAG_NEXT_COMPOUND
+ignore define V4L2_CID_MAX_CTRLS
+ignore define V4L2_CID_PRIVATE_BASE
+ignore define V4L2_TUNER_CAP_LOW
+ignore define V4L2_TUNER_CAP_NORM
+ignore define V4L2_TUNER_CAP_HWSEEK_BOUNDED
+ignore define V4L2_TUNER_CAP_HWSEEK_WRAP
+ignore define V4L2_TUNER_CAP_STEREO
+ignore define V4L2_TUNER_CAP_LANG2
+ignore define V4L2_TUNER_CAP_SAP
+ignore define V4L2_TUNER_CAP_LANG1
+ignore define V4L2_TUNER_CAP_RDS
+ignore define V4L2_TUNER_CAP_RDS_BLOCK_IO
+ignore define V4L2_TUNER_CAP_RDS_CONTROLS
+ignore define V4L2_TUNER_CAP_FREQ_BANDS
+ignore define V4L2_TUNER_CAP_HWSEEK_PROG_LIM
+ignore define V4L2_TUNER_CAP_1HZ
+ignore define V4L2_TUNER_SUB_MONO
+ignore define V4L2_TUNER_SUB_STEREO
+ignore define V4L2_TUNER_SUB_LANG2
+ignore define V4L2_TUNER_SUB_SAP
+ignore define V4L2_TUNER_SUB_LANG1
+ignore define V4L2_TUNER_SUB_RDS
+ignore define V4L2_TUNER_MODE_MONO
+ignore define V4L2_TUNER_MODE_STEREO
+ignore define V4L2_TUNER_MODE_LANG2
+ignore define V4L2_TUNER_MODE_SAP
+ignore define V4L2_TUNER_MODE_LANG1
+ignore define V4L2_TUNER_MODE_LANG1_LANG2
+ignore define V4L2_BAND_MODULATION_VSB
+ignore define V4L2_BAND_MODULATION_FM
+ignore define V4L2_BAND_MODULATION_AM
+ignore define V4L2_RDS_BLOCK_MSK
+ignore define V4L2_RDS_BLOCK_A
+ignore define V4L2_RDS_BLOCK_B
+ignore define V4L2_RDS_BLOCK_C
+ignore define V4L2_RDS_BLOCK_D
+ignore define V4L2_RDS_BLOCK_C_ALT
+ignore define V4L2_RDS_BLOCK_INVALID
+ignore define V4L2_RDS_BLOCK_CORRECTED
+ignore define V4L2_RDS_BLOCK_ERROR
+ignore define V4L2_AUDCAP_STEREO
+ignore define V4L2_AUDCAP_AVL
+ignore define V4L2_AUDMODE_AVL
+ignore define V4L2_ENC_IDX_FRAME_I
+ignore define V4L2_ENC_IDX_FRAME_P
+ignore define V4L2_ENC_IDX_FRAME_B
+ignore define V4L2_ENC_IDX_FRAME_MASK
+ignore define V4L2_ENC_IDX_ENTRIES
+ignore define V4L2_ENC_CMD_START
+ignore define V4L2_ENC_CMD_STOP
+ignore define V4L2_ENC_CMD_PAUSE
+ignore define V4L2_ENC_CMD_RESUME
+ignore define V4L2_ENC_CMD_STOP_AT_GOP_END
+ignore define V4L2_DEC_CMD_START
+ignore define V4L2_DEC_CMD_STOP
+ignore define V4L2_DEC_CMD_PAUSE
+ignore define V4L2_DEC_CMD_RESUME
+ignore define V4L2_DEC_CMD_START_MUTE_AUDIO
+ignore define V4L2_DEC_CMD_PAUSE_TO_BLACK
+ignore define V4L2_DEC_CMD_STOP_TO_BLACK
+ignore define V4L2_DEC_CMD_STOP_IMMEDIATELY
+ignore define V4L2_DEC_START_FMT_NONE
+ignore define V4L2_DEC_START_FMT_GOP
+ignore define V4L2_VBI_UNSYNC
+ignore define V4L2_VBI_INTERLACED
+ignore define V4L2_VBI_ITU_525_F1_START
+ignore define V4L2_VBI_ITU_525_F2_START
+ignore define V4L2_VBI_ITU_625_F1_START
+ignore define V4L2_VBI_ITU_625_F2_START
+ignore define V4L2_SLICED_TELETEXT_B
+ignore define V4L2_SLICED_VPS
+ignore define V4L2_SLICED_CAPTION_525
+ignore define V4L2_SLICED_WSS_625
+ignore define V4L2_SLICED_VBI_525
+ignore define V4L2_SLICED_VBI_625
+ignore define V4L2_MPEG_VBI_IVTV_TELETEXT_B
+ignore define V4L2_MPEG_VBI_IVTV_CAPTION_525
+ignore define V4L2_MPEG_VBI_IVTV_WSS_625
+ignore define V4L2_MPEG_VBI_IVTV_VPS
+ignore define V4L2_MPEG_VBI_IVTV_MAGIC0
+ignore define V4L2_MPEG_VBI_IVTV_MAGIC1
+ignore define V4L2_EVENT_ALL
+ignore define V4L2_EVENT_VSYNC
+ignore define V4L2_EVENT_EOS
+ignore define V4L2_EVENT_CTRL
+ignore define V4L2_EVENT_FRAME_SYNC
+ignore define V4L2_EVENT_SOURCE_CHANGE
+ignore define V4L2_EVENT_PRIVATE_START
+ignore define V4L2_EVENT_CTRL_CH_VALUE
+ignore define V4L2_EVENT_CTRL_CH_FLAGS
+ignore define V4L2_EVENT_CTRL_CH_RANGE
+ignore define V4L2_EVENT_SRC_CH_RESOLUTION
+ignore define V4L2_EVENT_MD_FL_HAVE_FRAME_SEQ
+ignore define V4L2_EVENT_SUB_FL_SEND_INITIAL
+ignore define V4L2_EVENT_SUB_FL_ALLOW_FEEDBACK
+ignore define V4L2_CHIP_MATCH_BRIDGE
+ignore define V4L2_CHIP_MATCH_SUBDEV
+ignore define V4L2_CHIP_MATCH_HOST
+ignore define V4L2_CHIP_MATCH_I2C_DRIVER
+ignore define V4L2_CHIP_MATCH_I2C_ADDR
+ignore define V4L2_CHIP_MATCH_AC97
+ignore define V4L2_CHIP_FL_READABLE
+ignore define V4L2_CHIP_FL_WRITABLE
+ignore define BASE_VIDIOC_PRIVATE
+
+# Ignore reserved ioctl
+ignore ioctl VIDIOC_RESERVED
+
+# Associate ioctls with their counterparts
+replace ioctl VIDIOC_DBG_S_REGISTER vidioc_dbg_g_register
+replace ioctl VIDIOC_DQBUF vidioc_qbuf
+replace ioctl VIDIOC_S_AUDOUT vidioc_g_audout
+replace ioctl VIDIOC_S_CROP vidioc_g_crop
+replace ioctl VIDIOC_S_CTRL vidioc_g_ctrl
+replace ioctl VIDIOC_S_DV_TIMINGS vidioc_g_dv_timings
+replace ioctl VIDIOC_S_EDID vidioc_g_edid
+replace ioctl VIDIOC_S_EXT_CTRLS vidioc_g_ext_ctrls
+replace ioctl VIDIOC_S_FBUF vidioc_g_fbuf
+replace ioctl VIDIOC_S_FMT vidioc_g_fmt
+replace ioctl VIDIOC_S_FREQUENCY vidioc_g_frequency
+replace ioctl VIDIOC_S_INPUT vidioc_g_input
+replace ioctl VIDIOC_S_JPEGCOMP vidioc_g_jpegcomp
+replace ioctl VIDIOC_S_MODULATOR vidioc_g_modulator
+replace ioctl VIDIOC_S_OUTPUT vidioc_g_output
+replace ioctl VIDIOC_S_PARM vidioc_g_parm
+replace ioctl VIDIOC_S_PRIORITY vidioc_g_priority
+replace ioctl VIDIOC_S_SELECTION vidioc_g_selection
+replace ioctl VIDIOC_S_STD vidioc_g_std
+replace ioctl VIDIOC_S_AUDIO vidioc_g_audio
+replace ioctl VIDIOC_S_TUNER vidioc_g_tuner
+replace ioctl VIDIOC_TRY_DECODER_CMD vidioc_decoder_cmd
+replace ioctl VIDIOC_TRY_ENCODER_CMD vidioc_encoder_cmd
+replace ioctl VIDIOC_TRY_EXT_CTRLS vidioc_g_ext_ctrls
+replace ioctl VIDIOC_TRY_FMT vidioc_g_fmt
+replace ioctl VIDIOC_STREAMOFF vidioc_streamon
+replace ioctl VIDIOC_UNSUBSCRIBE_EVENT vidioc_subscribe_event
+replace ioctl VIDIOC_QUERY_EXT_CTRL vidioc_queryctrl
+replace ioctl VIDIOC_QUERYMENU vidioc_queryctrl
-- 
2.7.4

