Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41311 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755131AbcGHNEB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Jul 2016 09:04:01 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: corbet@lwn.net, markus.heiser@darmarIT.de,
	linux-doc@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 49/54] doc-rst: document enum symbols
Date: Fri,  8 Jul 2016 10:03:41 -0300
Message-Id: <194acc56f23aac97cc202b143508ca8a926698c2.1467981855.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467981855.git.mchehab@s-opensource.com>
References: <cover.1467981855.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467981855.git.mchehab@s-opensource.com>
References: <cover.1467981855.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

After checking that all enum fields are documented at the
corresponding table on the rst file, let's point to the
table, instead of ignore the symbols.

A few symbols are not meant to be documented, as they're
deprecated stuff. keep ignoring them.

One enum field is not documented. Either it is obsolete
or a documentation gap. So, produce warnings for it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/linux_tv/videodev2.h.rst.exceptions | 206 ++++++++++++----------
 1 file changed, 116 insertions(+), 90 deletions(-)

diff --git a/Documentation/linux_tv/videodev2.h.rst.exceptions b/Documentation/linux_tv/videodev2.h.rst.exceptions
index 8cad3ba6ba99..6231549294c1 100644
--- a/Documentation/linux_tv/videodev2.h.rst.exceptions
+++ b/Documentation/linux_tv/videodev2.h.rst.exceptions
@@ -9,98 +9,124 @@ ignore define _UAPI__LINUX_VIDEODEV2_H
 # having something not documented at the uAPI.
 #
 
-# for now, ignore all enum symbols
+# Those symbols should not be used by uAPI - don't document them
 ignore symbol V4L2_BUF_TYPE_PRIVATE
-ignore symbol V4L2_BUF_TYPE_SDR_CAPTURE
-ignore symbol V4L2_BUF_TYPE_SDR_OUTPUT
-ignore symbol V4L2_BUF_TYPE_SLICED_VBI_CAPTURE
-ignore symbol V4L2_BUF_TYPE_SLICED_VBI_OUTPUT
-ignore symbol V4L2_BUF_TYPE_VBI_CAPTURE
-ignore symbol V4L2_BUF_TYPE_VBI_OUTPUT
-ignore symbol V4L2_BUF_TYPE_VIDEO_CAPTURE
-ignore symbol V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE
-ignore symbol V4L2_BUF_TYPE_VIDEO_OUTPUT
-ignore symbol V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE
-ignore symbol V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY
-ignore symbol V4L2_BUF_TYPE_VIDEO_OVERLAY
-ignore symbol V4L2_COLORSPACE_470_SYSTEM_BG
-ignore symbol V4L2_COLORSPACE_470_SYSTEM_M
-ignore symbol V4L2_COLORSPACE_ADOBERGB
-ignore symbol V4L2_COLORSPACE_BT2020
-ignore symbol V4L2_COLORSPACE_BT878
-ignore symbol V4L2_COLORSPACE_DCI_P3
-ignore symbol V4L2_COLORSPACE_DEFAULT
-ignore symbol V4L2_COLORSPACE_JPEG
-ignore symbol V4L2_COLORSPACE_RAW
-ignore symbol V4L2_COLORSPACE_REC709
-ignore symbol V4L2_COLORSPACE_SMPTE170M
-ignore symbol V4L2_COLORSPACE_SMPTE240M
-ignore symbol V4L2_COLORSPACE_SRGB
-ignore symbol V4L2_CTRL_COMPOUND_TYPES
-ignore symbol V4L2_CTRL_TYPE_BITMASK
-ignore symbol V4L2_CTRL_TYPE_BOOLEAN
-ignore symbol V4L2_CTRL_TYPE_BUTTON
-ignore symbol V4L2_CTRL_TYPE_CTRL_CLASS
-ignore symbol V4L2_CTRL_TYPE_INTEGER
-ignore symbol V4L2_CTRL_TYPE_INTEGER64
-ignore symbol V4L2_CTRL_TYPE_INTEGER_MENU
-ignore symbol V4L2_CTRL_TYPE_MENU
-ignore symbol V4L2_CTRL_TYPE_STRING
-ignore symbol V4L2_CTRL_TYPE_U16
-ignore symbol V4L2_CTRL_TYPE_U32
-ignore symbol V4L2_CTRL_TYPE_U8
-ignore symbol V4L2_FIELD_ALTERNATE
-ignore symbol V4L2_FIELD_ANY
-ignore symbol V4L2_FIELD_BOTTOM
-ignore symbol V4L2_FIELD_INTERLACED
-ignore symbol V4L2_FIELD_INTERLACED_BT
-ignore symbol V4L2_FIELD_INTERLACED_TB
-ignore symbol V4L2_FIELD_NONE
-ignore symbol V4L2_FIELD_SEQ_BT
-ignore symbol V4L2_FIELD_SEQ_TB
-ignore symbol V4L2_FIELD_TOP
-ignore symbol V4L2_FRMIVAL_TYPE_CONTINUOUS
-ignore symbol V4L2_FRMIVAL_TYPE_DISCRETE
-ignore symbol V4L2_FRMIVAL_TYPE_STEPWISE
-ignore symbol V4L2_FRMSIZE_TYPE_CONTINUOUS
-ignore symbol V4L2_FRMSIZE_TYPE_DISCRETE
-ignore symbol V4L2_FRMSIZE_TYPE_STEPWISE
-ignore symbol V4L2_MEMORY_DMABUF
-ignore symbol V4L2_MEMORY_MMAP
-ignore symbol V4L2_MEMORY_OVERLAY
-ignore symbol V4L2_MEMORY_USERPTR
-ignore symbol V4L2_PRIORITY_BACKGROUND
-ignore symbol V4L2_PRIORITY_DEFAULT
-ignore symbol V4L2_PRIORITY_INTERACTIVE
-ignore symbol V4L2_PRIORITY_RECORD
-ignore symbol V4L2_PRIORITY_UNSET
-ignore symbol V4L2_QUANTIZATION_DEFAULT
-ignore symbol V4L2_QUANTIZATION_FULL_RANGE
-ignore symbol V4L2_QUANTIZATION_LIM_RANGE
-ignore symbol V4L2_TUNER_ANALOG_TV
 ignore symbol V4L2_TUNER_DIGITAL_TV
-ignore symbol V4L2_TUNER_RADIO
-ignore symbol V4L2_TUNER_RF
-ignore symbol V4L2_TUNER_SDR
-ignore symbol V4L2_XFER_FUNC_709
-ignore symbol V4L2_XFER_FUNC_ADOBERGB
-ignore symbol V4L2_XFER_FUNC_DCI_P3
-ignore symbol V4L2_XFER_FUNC_DEFAULT
-ignore symbol V4L2_XFER_FUNC_NONE
-ignore symbol V4L2_XFER_FUNC_SMPTE2084
-ignore symbol V4L2_XFER_FUNC_SMPTE240M
-ignore symbol V4L2_XFER_FUNC_SRGB
-ignore symbol V4L2_YCBCR_ENC_601
-ignore symbol V4L2_YCBCR_ENC_709
-ignore symbol V4L2_YCBCR_ENC_BT2020
-ignore symbol V4L2_YCBCR_ENC_BT2020_CONST_LUM
-ignore symbol V4L2_YCBCR_ENC_DEFAULT
-ignore symbol V4L2_YCBCR_ENC_SMPTE240M
-ignore symbol V4L2_YCBCR_ENC_SYCC
-ignore symbol V4L2_YCBCR_ENC_XV601
-ignore symbol V4L2_YCBCR_ENC_XV709
-
-# For now, ignore all defines
+ignore symbol V4L2_COLORSPACE_BT878
+
+# Documented enum v4l2_field
+replace symbol V4L2_FIELD_ALTERNATE v4l2-field
+replace symbol V4L2_FIELD_ANY v4l2-field
+replace symbol V4L2_FIELD_BOTTOM v4l2-field
+replace symbol V4L2_FIELD_INTERLACED v4l2-field
+replace symbol V4L2_FIELD_INTERLACED_BT v4l2-field
+replace symbol V4L2_FIELD_INTERLACED_TB v4l2-field
+replace symbol V4L2_FIELD_NONE v4l2-field
+replace symbol V4L2_FIELD_SEQ_BT v4l2-field
+replace symbol V4L2_FIELD_SEQ_TB v4l2-field
+replace symbol V4L2_FIELD_TOP v4l2-field
+
+# Documented enum v4l2_buf_type
+replace symbol V4L2_BUF_TYPE_SDR_CAPTURE v4l2-buf-type
+replace symbol V4L2_BUF_TYPE_SDR_OUTPUT v4l2-buf-type
+replace symbol V4L2_BUF_TYPE_SLICED_VBI_CAPTURE v4l2-buf-type
+replace symbol V4L2_BUF_TYPE_SLICED_VBI_OUTPUT v4l2-buf-type
+replace symbol V4L2_BUF_TYPE_VBI_CAPTURE v4l2-buf-type
+replace symbol V4L2_BUF_TYPE_VBI_OUTPUT v4l2-buf-type
+replace symbol V4L2_BUF_TYPE_VIDEO_CAPTURE v4l2-buf-type
+replace symbol V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE v4l2-buf-type
+replace symbol V4L2_BUF_TYPE_VIDEO_OUTPUT v4l2-buf-type
+replace symbol V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE v4l2-buf-type
+replace symbol V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY v4l2-buf-type
+replace symbol V4L2_BUF_TYPE_VIDEO_OVERLAY v4l2-buf-type
+
+# Documented enum v4l2_tuner_type
+replace symbol V4L2_TUNER_ANALOG_TV v4l2-tuner-type
+replace symbol V4L2_TUNER_RADIO v4l2-tuner-type
+replace symbol V4L2_TUNER_RF v4l2-tuner-type
+replace symbol V4L2_TUNER_SDR v4l2-tuner-type
+
+# Documented enum v4l2_memory
+replace symbol V4L2_MEMORY_DMABUF v4l2-memory
+replace symbol V4L2_MEMORY_MMAP v4l2-memory
+replace symbol V4L2_MEMORY_OVERLAY v4l2-memory
+replace symbol V4L2_MEMORY_USERPTR v4l2-memory
+
+# Documented enum v4l2_colorspace
+replace symbol V4L2_COLORSPACE_470_SYSTEM_BG v4l2-colorspace
+replace symbol V4L2_COLORSPACE_470_SYSTEM_M v4l2-colorspace
+replace symbol V4L2_COLORSPACE_ADOBERGB v4l2-colorspace
+replace symbol V4L2_COLORSPACE_BT2020 v4l2-colorspace
+replace symbol V4L2_COLORSPACE_DCI_P3 v4l2-colorspace
+replace symbol V4L2_COLORSPACE_DEFAULT v4l2-colorspace
+replace symbol V4L2_COLORSPACE_JPEG v4l2-colorspace
+replace symbol V4L2_COLORSPACE_RAW v4l2-colorspace
+replace symbol V4L2_COLORSPACE_REC709 v4l2-colorspace
+replace symbol V4L2_COLORSPACE_SMPTE170M v4l2-colorspace
+replace symbol V4L2_COLORSPACE_SMPTE240M v4l2-colorspace
+replace symbol V4L2_COLORSPACE_SRGB v4l2-colorspace
+
+# Documented enum v4l2_xfer_func
+replace symbol V4L2_XFER_FUNC_709 v4l2-xfer-func
+replace symbol V4L2_XFER_FUNC_ADOBERGB v4l2-xfer-func
+replace symbol V4L2_XFER_FUNC_DCI_P3 v4l2-xfer-func
+replace symbol V4L2_XFER_FUNC_DEFAULT v4l2-xfer-func
+replace symbol V4L2_XFER_FUNC_NONE v4l2-xfer-func
+replace symbol V4L2_XFER_FUNC_SMPTE2084 v4l2-xfer-func
+replace symbol V4L2_XFER_FUNC_SMPTE240M v4l2-xfer-func
+replace symbol V4L2_XFER_FUNC_SRGB v4l2-xfer-func
+
+# Documented enum v4l2_ycbcr_encoding
+replace symbol V4L2_YCBCR_ENC_601 v4l2-ycbcr-encoding
+replace symbol V4L2_YCBCR_ENC_709 v4l2-ycbcr-encoding
+replace symbol V4L2_YCBCR_ENC_BT2020 v4l2-ycbcr-encoding
+replace symbol V4L2_YCBCR_ENC_BT2020_CONST_LUM v4l2-ycbcr-encoding
+replace symbol V4L2_YCBCR_ENC_DEFAULT v4l2-ycbcr-encoding
+replace symbol V4L2_YCBCR_ENC_SYCC v4l2-ycbcr-encoding
+replace symbol V4L2_YCBCR_ENC_XV601 v4l2-ycbcr-encoding
+replace symbol V4L2_YCBCR_ENC_XV709 v4l2-ycbcr-encoding
+
+# Is this deprecated, or just a missing reference?
+replace symbol V4L2_YCBCR_ENC_SMPTE240M v4l2-ycbcr-encoding-FIXME
+
+# Documented enum v4l2_quantization
+replace symbol V4L2_QUANTIZATION_DEFAULT v4l2-quantization
+replace symbol V4L2_QUANTIZATION_FULL_RANGE v4l2-quantization
+replace symbol V4L2_QUANTIZATION_LIM_RANGE v4l2-quantization
+
+# Documented enum v4l2_priority
+replace symbol V4L2_PRIORITY_BACKGROUND v4l2-priority
+replace symbol V4L2_PRIORITY_DEFAULT v4l2-priority
+replace symbol V4L2_PRIORITY_INTERACTIVE v4l2-priority
+replace symbol V4L2_PRIORITY_RECORD v4l2-priority
+replace symbol V4L2_PRIORITY_UNSET v4l2-priority
+
+# Documented enum v4l2_frmsizetypes
+replace symbol V4L2_FRMSIZE_TYPE_CONTINUOUS v4l2-frmsizetypes
+replace symbol V4L2_FRMSIZE_TYPE_DISCRETE v4l2-frmsizetypes
+replace symbol V4L2_FRMSIZE_TYPE_STEPWISE v4l2-frmsizetypes
+
+# Documented enum frmivaltypes
+replace symbol V4L2_FRMIVAL_TYPE_CONTINUOUS v4l2-frmivaltypes
+replace symbol V4L2_FRMIVAL_TYPE_DISCRETE v4l2-frmivaltypes
+replace symbol V4L2_FRMIVAL_TYPE_STEPWISE v4l2-frmivaltypes
+
+# Documented enum v4l2-ctrl-type
+replace symbol V4L2_CTRL_COMPOUND_TYPES vidioc_queryctrl
+replace symbol V4L2_CTRL_TYPE_BITMASK v4l2-ctrl-type
+replace symbol V4L2_CTRL_TYPE_BOOLEAN v4l2-ctrl-type
+replace symbol V4L2_CTRL_TYPE_BUTTON v4l2-ctrl-type
+replace symbol V4L2_CTRL_TYPE_CTRL_CLASS v4l2-ctrl-type
+replace symbol V4L2_CTRL_TYPE_INTEGER v4l2-ctrl-type
+replace symbol V4L2_CTRL_TYPE_INTEGER64 v4l2-ctrl-type
+replace symbol V4L2_CTRL_TYPE_INTEGER_MENU v4l2-ctrl-type
+replace symbol V4L2_CTRL_TYPE_MENU v4l2-ctrl-type
+replace symbol V4L2_CTRL_TYPE_STRING v4l2-ctrl-type
+replace symbol V4L2_CTRL_TYPE_U16 v4l2-ctrl-type
+replace symbol V4L2_CTRL_TYPE_U32 v4l2-ctrl-type
+replace symbol V4L2_CTRL_TYPE_U8 v4l2-ctrl-type
+
+# Ancillary macros that should be ignored
 ignore define VIDEO_MAX_FRAME
 ignore define VIDEO_MAX_PLANES
 ignore define v4l2_fourcc
-- 
2.7.4

