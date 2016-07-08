Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41317 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755392AbcGHNEG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Jul 2016 09:04:06 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: corbet@lwn.net, markus.heiser@darmarIT.de,
	linux-doc@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 50/54] doc-rst: videodev2.h: add cross-references for defines
Date: Fri,  8 Jul 2016 10:03:42 -0300
Message-Id: <249e5ba0be97f34bab45ce29e5c077a011cb507e.1467981855.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467981855.git.mchehab@s-opensource.com>
References: <cover.1467981855.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467981855.git.mchehab@s-opensource.com>
References: <cover.1467981855.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove most of ignore stuff for defines, pointing them to the
proper tables/sections.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 .../linux_tv/media/v4l/vidioc-dv-timings-cap.rst   |   8 +-
 .../linux_tv/media/v4l/vidioc-g-dv-timings.rst     |  26 +-
 Documentation/linux_tv/videodev2.h.rst.exceptions  | 618 ++++++++++++---------
 3 files changed, 367 insertions(+), 285 deletions(-)

diff --git a/Documentation/linux_tv/media/v4l/vidioc-dv-timings-cap.rst b/Documentation/linux_tv/media/v4l/vidioc-dv-timings-cap.rst
index b56cdef7673e..5a35bb254b4b 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-dv-timings-cap.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-dv-timings-cap.rst
@@ -217,26 +217,26 @@ that doesn't support them will return an ``EINVAL`` error code.
 
     -  .. row 3
 
-       -  V4L2_DV_BT_CAP_INTERLACED
+       -  ``V4L2_DV_BT_CAP_INTERLACED``
 
        -  Interlaced formats are supported.
 
     -  .. row 4
 
-       -  V4L2_DV_BT_CAP_PROGRESSIVE
+       -  ``V4L2_DV_BT_CAP_PROGRESSIVE``
 
        -  Progressive formats are supported.
 
     -  .. row 5
 
-       -  V4L2_DV_BT_CAP_REDUCED_BLANKING
+       -  ``V4L2_DV_BT_CAP_REDUCED_BLANKING``
 
        -  CVT/GTF specific: the timings can make use of reduced blanking
 	  (CVT) or the 'Secondary GTF' curve (GTF).
 
     -  .. row 6
 
-       -  V4L2_DV_BT_CAP_CUSTOM
+       -  ``V4L2_DV_BT_CAP_CUSTOM``
 
        -  Can support non-standard timings, i.e. timings not belonging to
 	  the standards set in the ``standards`` field.
diff --git a/Documentation/linux_tv/media/v4l/vidioc-g-dv-timings.rst b/Documentation/linux_tv/media/v4l/vidioc-g-dv-timings.rst
index 0dd93d1ee284..e19d64e0116a 100644
--- a/Documentation/linux_tv/media/v4l/vidioc-g-dv-timings.rst
+++ b/Documentation/linux_tv/media/v4l/vidioc-g-dv-timings.rst
@@ -109,8 +109,8 @@ EBUSY
        -  ``polarities``
 
        -  This is a bit mask that defines polarities of sync signals. bit 0
-	  (V4L2_DV_VSYNC_POS_POL) is for vertical sync polarity and bit
-	  1 (V4L2_DV_HSYNC_POS_POL) is for horizontal sync polarity. If
+	  (``V4L2_DV_VSYNC_POS_POL``) is for vertical sync polarity and bit
+	  1 (``V4L2_DV_HSYNC_POS_POL``) is for horizontal sync polarity. If
 	  the bit is set (1) it is positive polarity and if is cleared (0),
 	  it is negative polarity.
 
@@ -289,7 +289,7 @@ EBUSY
 
     -  .. row 3
 
-       -  V4L2_DV_BT_656_1120
+       -  ``V4L2_DV_BT_656_1120``
 
        -  0
 
@@ -317,25 +317,25 @@ EBUSY
 
     -  .. row 3
 
-       -  V4L2_DV_BT_STD_CEA861
+       -  ``V4L2_DV_BT_STD_CEA861``
 
        -  The timings follow the CEA-861 Digital TV Profile standard
 
     -  .. row 4
 
-       -  V4L2_DV_BT_STD_DMT
+       -  ``V4L2_DV_BT_STD_DMT``
 
        -  The timings follow the VESA Discrete Monitor Timings standard
 
     -  .. row 5
 
-       -  V4L2_DV_BT_STD_CVT
+       -  ``V4L2_DV_BT_STD_CVT``
 
        -  The timings follow the VESA Coordinated Video Timings standard
 
     -  .. row 6
 
-       -  V4L2_DV_BT_STD_GTF
+       -  ``V4L2_DV_BT_STD_GTF``
 
        -  The timings follow the VESA Generalized Timings Formula standard
 
@@ -361,7 +361,7 @@ EBUSY
 
     -  .. row 3
 
-       -  V4L2_DV_FL_REDUCED_BLANKING
+       -  ``V4L2_DV_FL_REDUCED_BLANKING``
 
        -  CVT/GTF specific: the timings use reduced blanking (CVT) or the
 	  'Secondary GTF' curve (GTF). In both cases the horizontal and/or
@@ -371,7 +371,7 @@ EBUSY
 
     -  .. row 4
 
-       -  V4L2_DV_FL_CAN_REDUCE_FPS
+       -  ``V4L2_DV_FL_CAN_REDUCE_FPS``
 
        -  CEA-861 specific: set for CEA-861 formats with a framerate that is
 	  a multiple of six. These formats can be optionally played at 1 /
@@ -383,11 +383,11 @@ EBUSY
 
     -  .. row 5
 
-       -  V4L2_DV_FL_REDUCED_FPS
+       -  ``V4L2_DV_FL_REDUCED_FPS``
 
        -  CEA-861 specific: only valid for video transmitters, the flag is
 	  cleared by receivers. It is also only valid for formats with the
-	  V4L2_DV_FL_CAN_REDUCE_FPS flag set, for other formats the
+	  ``V4L2_DV_FL_CAN_REDUCE_FPS`` flag set, for other formats the
 	  flag will be cleared by the driver. If the application sets this
 	  flag, then the pixelclock used to set up the transmitter is
 	  divided by 1.001 to make it compatible with NTSC framerates. If
@@ -396,7 +396,7 @@ EBUSY
 
     -  .. row 6
 
-       -  V4L2_DV_FL_HALF_LINE
+       -  ``V4L2_DV_FL_HALF_LINE``
 
        -  Specific to interlaced formats: if set, then the vertical
 	  frontporch of field 1 (aka the odd field) is really one half-line
@@ -407,7 +407,7 @@ EBUSY
 
     -  .. row 7
 
-       -  V4L2_DV_FL_IS_CE_VIDEO
+       -  ``V4L2_DV_FL_IS_CE_VIDEO``
 
        -  If set, then this is a Consumer Electronics (CE) video format.
 	  Such formats differ from other formats (commonly called IT
diff --git a/Documentation/linux_tv/videodev2.h.rst.exceptions b/Documentation/linux_tv/videodev2.h.rst.exceptions
index 6231549294c1..c15660f5c588 100644
--- a/Documentation/linux_tv/videodev2.h.rst.exceptions
+++ b/Documentation/linux_tv/videodev2.h.rst.exceptions
@@ -113,6 +113,7 @@ replace symbol V4L2_FRMIVAL_TYPE_STEPWISE v4l2-frmivaltypes
 
 # Documented enum v4l2-ctrl-type
 replace symbol V4L2_CTRL_COMPOUND_TYPES vidioc_queryctrl
+
 replace symbol V4L2_CTRL_TYPE_BITMASK v4l2-ctrl-type
 replace symbol V4L2_CTRL_TYPE_BOOLEAN v4l2-ctrl-type
 replace symbol V4L2_CTRL_TYPE_BUTTON v4l2-ctrl-type
@@ -126,275 +127,110 @@ replace symbol V4L2_CTRL_TYPE_U16 v4l2-ctrl-type
 replace symbol V4L2_CTRL_TYPE_U32 v4l2-ctrl-type
 replace symbol V4L2_CTRL_TYPE_U8 v4l2-ctrl-type
 
-# Ancillary macros that should be ignored
-ignore define VIDEO_MAX_FRAME
-ignore define VIDEO_MAX_PLANES
-ignore define v4l2_fourcc
-ignore define v4l2_fourcc_be
-ignore define V4L2_FIELD_HAS_TOP
-ignore define V4L2_FIELD_HAS_BOTTOM
-ignore define V4L2_FIELD_HAS_BOTH
-ignore define V4L2_FIELD_HAS_T_OR_B
-ignore define V4L2_TYPE_IS_MULTIPLANAR
-ignore define V4L2_TYPE_IS_OUTPUT
-ignore define V4L2_TUNER_ADC
-ignore define V4L2_MAP_COLORSPACE_DEFAULT
-ignore define V4L2_MAP_XFER_FUNC_DEFAULT
-ignore define V4L2_MAP_YCBCR_ENC_DEFAULT
-ignore define V4L2_CAP_VIDEO_CAPTURE
-ignore define V4L2_CAP_VIDEO_OUTPUT
-ignore define V4L2_CAP_VIDEO_OVERLAY
-ignore define V4L2_CAP_VBI_CAPTURE
-ignore define V4L2_CAP_VBI_OUTPUT
-ignore define V4L2_CAP_SLICED_VBI_CAPTURE
-ignore define V4L2_CAP_SLICED_VBI_OUTPUT
-ignore define V4L2_CAP_RDS_CAPTURE
-ignore define V4L2_CAP_VIDEO_OUTPUT_OVERLAY
-ignore define V4L2_CAP_HW_FREQ_SEEK
-ignore define V4L2_CAP_RDS_OUTPUT
-ignore define V4L2_CAP_VIDEO_CAPTURE_MPLANE
-ignore define V4L2_CAP_VIDEO_OUTPUT_MPLANE
-ignore define V4L2_CAP_VIDEO_M2M_MPLANE
-ignore define V4L2_CAP_VIDEO_M2M
-ignore define V4L2_CAP_TUNER
-ignore define V4L2_CAP_AUDIO
-ignore define V4L2_CAP_RADIO
-ignore define V4L2_CAP_MODULATOR
-ignore define V4L2_CAP_SDR_CAPTURE
-ignore define V4L2_CAP_EXT_PIX_FORMAT
-ignore define V4L2_CAP_SDR_OUTPUT
-ignore define V4L2_CAP_READWRITE
-ignore define V4L2_CAP_ASYNCIO
-ignore define V4L2_CAP_STREAMING
-ignore define V4L2_CAP_DEVICE_CAPS
-ignore define V4L2_PIX_FMT_PRIV_MAGIC
-ignore define V4L2_PIX_FMT_FLAG_PREMUL_ALPHA
-ignore define V4L2_FMT_FLAG_COMPRESSED
-ignore define V4L2_FMT_FLAG_EMULATED
-ignore define V4L2_TC_TYPE_24FPS
-ignore define V4L2_TC_TYPE_25FPS
-ignore define V4L2_TC_TYPE_30FPS
-ignore define V4L2_TC_TYPE_50FPS
-ignore define V4L2_TC_TYPE_60FPS
-ignore define V4L2_TC_FLAG_DROPFRAME
-ignore define V4L2_TC_FLAG_COLORFRAME
-ignore define V4L2_TC_USERBITS_field
-ignore define V4L2_TC_USERBITS_USERDEFINED
-ignore define V4L2_TC_USERBITS_8BITCHARS
-ignore define V4L2_JPEG_MARKER_DHT
-ignore define V4L2_JPEG_MARKER_DQT
-ignore define V4L2_JPEG_MARKER_DRI
-ignore define V4L2_JPEG_MARKER_COM
-ignore define V4L2_JPEG_MARKER_APP
-ignore define V4L2_BUF_FLAG_MAPPED
-ignore define V4L2_BUF_FLAG_QUEUED
-ignore define V4L2_BUF_FLAG_DONE
-ignore define V4L2_BUF_FLAG_KEYFRAME
-ignore define V4L2_BUF_FLAG_PFRAME
-ignore define V4L2_BUF_FLAG_BFRAME
-ignore define V4L2_BUF_FLAG_ERROR
-ignore define V4L2_BUF_FLAG_TIMECODE
-ignore define V4L2_BUF_FLAG_PREPARED
-ignore define V4L2_BUF_FLAG_NO_CACHE_INVALIDATE
-ignore define V4L2_BUF_FLAG_NO_CACHE_CLEAN
-ignore define V4L2_BUF_FLAG_TIMESTAMP_MASK
-ignore define V4L2_BUF_FLAG_TIMESTAMP_UNKNOWN
-ignore define V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC
-ignore define V4L2_BUF_FLAG_TIMESTAMP_COPY
-ignore define V4L2_BUF_FLAG_TSTAMP_SRC_MASK
-ignore define V4L2_BUF_FLAG_TSTAMP_SRC_EOF
-ignore define V4L2_BUF_FLAG_TSTAMP_SRC_SOE
-ignore define V4L2_BUF_FLAG_LAST
-ignore define V4L2_FBUF_CAP_EXTERNOVERLAY
-ignore define V4L2_FBUF_CAP_CHROMAKEY
-ignore define V4L2_FBUF_CAP_LIST_CLIPPING
-ignore define V4L2_FBUF_CAP_BITMAP_CLIPPING
-ignore define V4L2_FBUF_CAP_LOCAL_ALPHA
-ignore define V4L2_FBUF_CAP_GLOBAL_ALPHA
-ignore define V4L2_FBUF_CAP_LOCAL_INV_ALPHA
-ignore define V4L2_FBUF_CAP_SRC_CHROMAKEY
-ignore define V4L2_FBUF_FLAG_PRIMARY
-ignore define V4L2_FBUF_FLAG_OVERLAY
-ignore define V4L2_FBUF_FLAG_CHROMAKEY
-ignore define V4L2_FBUF_FLAG_LOCAL_ALPHA
-ignore define V4L2_FBUF_FLAG_GLOBAL_ALPHA
-ignore define V4L2_FBUF_FLAG_LOCAL_INV_ALPHA
-ignore define V4L2_FBUF_FLAG_SRC_CHROMAKEY
-ignore define V4L2_MODE_HIGHQUALITY
-ignore define V4L2_CAP_TIMEPERFRAME
-ignore define V4L2_DV_PROGRESSIVE
-ignore define V4L2_DV_INTERLACED
-ignore define V4L2_DV_VSYNC_POS_POL
-ignore define V4L2_DV_HSYNC_POS_POL
-ignore define V4L2_DV_BT_STD_CEA861
-ignore define V4L2_DV_BT_STD_DMT
-ignore define V4L2_DV_BT_STD_CVT
-ignore define V4L2_DV_BT_STD_GTF
-ignore define V4L2_DV_FL_REDUCED_BLANKING
-ignore define V4L2_DV_FL_CAN_REDUCE_FPS
-ignore define V4L2_DV_FL_REDUCED_FPS
-ignore define V4L2_DV_FL_HALF_LINE
-ignore define V4L2_DV_FL_IS_CE_VIDEO
-ignore define V4L2_DV_BT_BLANKING_WIDTH(bt)
-ignore define V4L2_DV_BT_FRAME_WIDTH(bt)
-ignore define V4L2_DV_BT_BLANKING_HEIGHT(bt)
-ignore define V4L2_DV_BT_FRAME_HEIGHT(bt)
-ignore define V4L2_DV_BT_656_1120
-ignore define V4L2_DV_BT_CAP_INTERLACED
-ignore define V4L2_DV_BT_CAP_PROGRESSIVE
-ignore define V4L2_DV_BT_CAP_REDUCED_BLANKING
-ignore define V4L2_DV_BT_CAP_CUSTOM
-ignore define V4L2_INPUT_TYPE_TUNER
-ignore define V4L2_INPUT_TYPE_CAMERA
-ignore define V4L2_IN_ST_NO_POWER
-ignore define V4L2_IN_ST_NO_SIGNAL
-ignore define V4L2_IN_ST_NO_COLOR
-ignore define V4L2_IN_ST_HFLIP
-ignore define V4L2_IN_ST_VFLIP
-ignore define V4L2_IN_ST_NO_H_LOCK
-ignore define V4L2_IN_ST_COLOR_KILL
-ignore define V4L2_IN_ST_NO_SYNC
-ignore define V4L2_IN_ST_NO_EQU
-ignore define V4L2_IN_ST_NO_CARRIER
-ignore define V4L2_IN_ST_MACROVISION
-ignore define V4L2_IN_ST_NO_ACCESS
-ignore define V4L2_IN_ST_VTR
-ignore define V4L2_IN_CAP_DV_TIMINGS
-ignore define V4L2_IN_CAP_CUSTOM_TIMINGS
-ignore define V4L2_IN_CAP_STD
-ignore define V4L2_IN_CAP_NATIVE_SIZE
-ignore define V4L2_OUTPUT_TYPE_MODULATOR
-ignore define V4L2_OUTPUT_TYPE_ANALOG
-ignore define V4L2_OUTPUT_TYPE_ANALOGVGAOVERLAY
-ignore define V4L2_OUT_CAP_DV_TIMINGS
-ignore define V4L2_OUT_CAP_CUSTOM_TIMINGS
-ignore define V4L2_OUT_CAP_STD
-ignore define V4L2_OUT_CAP_NATIVE_SIZE
-ignore define V4L2_CTRL_ID_MASK
-ignore define V4L2_CTRL_ID2CLASS(id)
-ignore define V4L2_CTRL_ID2WHICH(id)
-ignore define V4L2_CTRL_DRIVER_PRIV(id)
-ignore define V4L2_CTRL_MAX_DIMS
-ignore define V4L2_CTRL_WHICH_CUR_VAL
-ignore define V4L2_CTRL_WHICH_DEF_VAL
-ignore define V4L2_CTRL_FLAG_DISABLED
-ignore define V4L2_CTRL_FLAG_GRABBED
-ignore define V4L2_CTRL_FLAG_READ_ONLY
-ignore define V4L2_CTRL_FLAG_UPDATE
-ignore define V4L2_CTRL_FLAG_INACTIVE
-ignore define V4L2_CTRL_FLAG_SLIDER
-ignore define V4L2_CTRL_FLAG_WRITE_ONLY
-ignore define V4L2_CTRL_FLAG_VOLATILE
-ignore define V4L2_CTRL_FLAG_HAS_PAYLOAD
-ignore define V4L2_CTRL_FLAG_EXECUTE_ON_WRITE
-ignore define V4L2_CTRL_FLAG_NEXT_CTRL
-ignore define V4L2_CTRL_FLAG_NEXT_COMPOUND
-ignore define V4L2_CID_MAX_CTRLS
-ignore define V4L2_CID_PRIVATE_BASE
-ignore define V4L2_TUNER_CAP_LOW
-ignore define V4L2_TUNER_CAP_NORM
-ignore define V4L2_TUNER_CAP_HWSEEK_BOUNDED
-ignore define V4L2_TUNER_CAP_HWSEEK_WRAP
-ignore define V4L2_TUNER_CAP_STEREO
-ignore define V4L2_TUNER_CAP_LANG2
-ignore define V4L2_TUNER_CAP_SAP
-ignore define V4L2_TUNER_CAP_LANG1
-ignore define V4L2_TUNER_CAP_RDS
-ignore define V4L2_TUNER_CAP_RDS_BLOCK_IO
-ignore define V4L2_TUNER_CAP_RDS_CONTROLS
-ignore define V4L2_TUNER_CAP_FREQ_BANDS
-ignore define V4L2_TUNER_CAP_HWSEEK_PROG_LIM
-ignore define V4L2_TUNER_CAP_1HZ
-ignore define V4L2_TUNER_SUB_MONO
-ignore define V4L2_TUNER_SUB_STEREO
-ignore define V4L2_TUNER_SUB_LANG2
-ignore define V4L2_TUNER_SUB_SAP
-ignore define V4L2_TUNER_SUB_LANG1
-ignore define V4L2_TUNER_SUB_RDS
-ignore define V4L2_TUNER_MODE_MONO
-ignore define V4L2_TUNER_MODE_STEREO
-ignore define V4L2_TUNER_MODE_LANG2
-ignore define V4L2_TUNER_MODE_SAP
-ignore define V4L2_TUNER_MODE_LANG1
-ignore define V4L2_TUNER_MODE_LANG1_LANG2
-ignore define V4L2_BAND_MODULATION_VSB
-ignore define V4L2_BAND_MODULATION_FM
-ignore define V4L2_BAND_MODULATION_AM
-ignore define V4L2_RDS_BLOCK_MSK
-ignore define V4L2_RDS_BLOCK_A
-ignore define V4L2_RDS_BLOCK_B
-ignore define V4L2_RDS_BLOCK_C
-ignore define V4L2_RDS_BLOCK_D
-ignore define V4L2_RDS_BLOCK_C_ALT
-ignore define V4L2_RDS_BLOCK_INVALID
-ignore define V4L2_RDS_BLOCK_CORRECTED
-ignore define V4L2_RDS_BLOCK_ERROR
-ignore define V4L2_AUDCAP_STEREO
-ignore define V4L2_AUDCAP_AVL
-ignore define V4L2_AUDMODE_AVL
-ignore define V4L2_ENC_IDX_FRAME_I
-ignore define V4L2_ENC_IDX_FRAME_P
-ignore define V4L2_ENC_IDX_FRAME_B
-ignore define V4L2_ENC_IDX_FRAME_MASK
-ignore define V4L2_ENC_IDX_ENTRIES
-ignore define V4L2_ENC_CMD_START
-ignore define V4L2_ENC_CMD_STOP
-ignore define V4L2_ENC_CMD_PAUSE
-ignore define V4L2_ENC_CMD_RESUME
-ignore define V4L2_ENC_CMD_STOP_AT_GOP_END
-ignore define V4L2_DEC_CMD_START
-ignore define V4L2_DEC_CMD_STOP
-ignore define V4L2_DEC_CMD_PAUSE
-ignore define V4L2_DEC_CMD_RESUME
-ignore define V4L2_DEC_CMD_START_MUTE_AUDIO
-ignore define V4L2_DEC_CMD_PAUSE_TO_BLACK
-ignore define V4L2_DEC_CMD_STOP_TO_BLACK
-ignore define V4L2_DEC_CMD_STOP_IMMEDIATELY
-ignore define V4L2_DEC_START_FMT_NONE
-ignore define V4L2_DEC_START_FMT_GOP
-ignore define V4L2_VBI_UNSYNC
-ignore define V4L2_VBI_INTERLACED
-ignore define V4L2_VBI_ITU_525_F1_START
-ignore define V4L2_VBI_ITU_525_F2_START
-ignore define V4L2_VBI_ITU_625_F1_START
-ignore define V4L2_VBI_ITU_625_F2_START
-ignore define V4L2_SLICED_TELETEXT_B
-ignore define V4L2_SLICED_VPS
-ignore define V4L2_SLICED_CAPTION_525
-ignore define V4L2_SLICED_WSS_625
-ignore define V4L2_SLICED_VBI_525
-ignore define V4L2_SLICED_VBI_625
-ignore define V4L2_MPEG_VBI_IVTV_TELETEXT_B
-ignore define V4L2_MPEG_VBI_IVTV_CAPTION_525
-ignore define V4L2_MPEG_VBI_IVTV_WSS_625
-ignore define V4L2_MPEG_VBI_IVTV_VPS
-ignore define V4L2_MPEG_VBI_IVTV_MAGIC0
-ignore define V4L2_MPEG_VBI_IVTV_MAGIC1
-ignore define V4L2_EVENT_ALL
-ignore define V4L2_EVENT_VSYNC
-ignore define V4L2_EVENT_EOS
-ignore define V4L2_EVENT_CTRL
-ignore define V4L2_EVENT_FRAME_SYNC
-ignore define V4L2_EVENT_SOURCE_CHANGE
-ignore define V4L2_EVENT_PRIVATE_START
-ignore define V4L2_EVENT_CTRL_CH_VALUE
-ignore define V4L2_EVENT_CTRL_CH_FLAGS
-ignore define V4L2_EVENT_CTRL_CH_RANGE
-ignore define V4L2_EVENT_SRC_CH_RESOLUTION
-ignore define V4L2_EVENT_MD_FL_HAVE_FRAME_SEQ
-ignore define V4L2_EVENT_SUB_FL_SEND_INITIAL
-ignore define V4L2_EVENT_SUB_FL_ALLOW_FEEDBACK
-ignore define V4L2_CHIP_MATCH_BRIDGE
-ignore define V4L2_CHIP_MATCH_SUBDEV
-ignore define V4L2_CHIP_MATCH_HOST
-ignore define V4L2_CHIP_MATCH_I2C_DRIVER
-ignore define V4L2_CHIP_MATCH_I2C_ADDR
-ignore define V4L2_CHIP_MATCH_AC97
-ignore define V4L2_CHIP_FL_READABLE
-ignore define V4L2_CHIP_FL_WRITABLE
-ignore define BASE_VIDIOC_PRIVATE
+# V4L2 capability defines
+replace define V4L2_CAP_VIDEO_CAPTURE device-capabilities
+replace define V4L2_CAP_VIDEO_CAPTURE_MPLANE device-capabilities
+replace define V4L2_CAP_VIDEO_OUTPUT device-capabilities
+replace define V4L2_CAP_VIDEO_OUTPUT_MPLANE device-capabilities
+replace define V4L2_CAP_VIDEO_M2M device-capabilities
+replace define V4L2_CAP_VIDEO_M2M_MPLANE device-capabilities
+replace define V4L2_CAP_VIDEO_OVERLAY device-capabilities
+replace define V4L2_CAP_VBI_CAPTURE device-capabilities
+replace define V4L2_CAP_VBI_OUTPUT device-capabilities
+replace define V4L2_CAP_SLICED_VBI_CAPTURE device-capabilities
+replace define V4L2_CAP_SLICED_VBI_OUTPUT device-capabilities
+replace define V4L2_CAP_RDS_CAPTURE device-capabilities
+replace define V4L2_CAP_VIDEO_OUTPUT_OVERLAY device-capabilities
+replace define V4L2_CAP_HW_FREQ_SEEK device-capabilities
+replace define V4L2_CAP_RDS_OUTPUT device-capabilities
+replace define V4L2_CAP_TUNER device-capabilities
+replace define V4L2_CAP_AUDIO device-capabilities
+replace define V4L2_CAP_RADIO device-capabilities
+replace define V4L2_CAP_MODULATOR device-capabilities
+replace define V4L2_CAP_SDR_CAPTURE device-capabilities
+replace define V4L2_CAP_EXT_PIX_FORMAT device-capabilities
+replace define V4L2_CAP_SDR_OUTPUT device-capabilities
+replace define V4L2_CAP_READWRITE device-capabilities
+replace define V4L2_CAP_ASYNCIO device-capabilities
+replace define V4L2_CAP_STREAMING device-capabilities
+replace define V4L2_CAP_DEVICE_CAPS device-capabilities
+
+# V4L2 pix flags
+replace define V4L2_PIX_FMT_PRIV_MAGIC v4l2-pix-format
+replace define V4L2_PIX_FMT_FLAG_PREMUL_ALPHA reserved-formats
+
+# V4L2 format flags
+replace define V4L2_FMT_FLAG_COMPRESSED fmtdesc-flags
+replace define V4L2_FMT_FLAG_EMULATED fmtdesc-flags
+
+# V4L2 tymecode types
+replace define V4L2_TC_TYPE_24FPS timecode-type
+replace define V4L2_TC_TYPE_25FPS timecode-type
+replace define V4L2_TC_TYPE_30FPS timecode-type
+replace define V4L2_TC_TYPE_50FPS timecode-type
+replace define V4L2_TC_TYPE_60FPS timecode-type
+
+# V4L2 tymecode flags
+replace define V4L2_TC_FLAG_DROPFRAME timecode-flags
+replace define V4L2_TC_FLAG_COLORFRAME timecode-flags
+replace define V4L2_TC_USERBITS_field timecode-flags
+replace define V4L2_TC_USERBITS_USERDEFINED timecode-flags
+replace define V4L2_TC_USERBITS_8BITCHARS timecode-flags
+
+# V4L2 JPEG markers
+replace define V4L2_JPEG_MARKER_DHT jpeg-markers
+replace define V4L2_JPEG_MARKER_DQT jpeg-markers
+replace define V4L2_JPEG_MARKER_DRI jpeg-markers
+replace define V4L2_JPEG_MARKER_COM jpeg-markers
+replace define V4L2_JPEG_MARKER_APP jpeg-markers
+
+#V4L2 buffer flags
+replace define V4L2_BUF_FLAG_MAPPED buffer-flags
+replace define V4L2_BUF_FLAG_QUEUED buffer-flags
+replace define V4L2_BUF_FLAG_DONE buffer-flags
+replace define V4L2_BUF_FLAG_ERROR buffer-flags
+replace define V4L2_BUF_FLAG_KEYFRAME buffer-flags
+replace define V4L2_BUF_FLAG_PFRAME buffer-flags
+replace define V4L2_BUF_FLAG_BFRAME buffer-flags
+replace define V4L2_BUF_FLAG_TIMECODE buffer-flags
+replace define V4L2_BUF_FLAG_PREPARED buffer-flags
+replace define V4L2_BUF_FLAG_NO_CACHE_INVALIDATE buffer-flags
+replace define V4L2_BUF_FLAG_NO_CACHE_CLEAN buffer-flags
+replace define V4L2_BUF_FLAG_TIMESTAMP_MASK buffer-flags
+replace define V4L2_BUF_FLAG_TIMESTAMP_UNKNOWN buffer-flags
+replace define V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC buffer-flags
+replace define V4L2_BUF_FLAG_TIMESTAMP_COPY buffer-flags
+replace define V4L2_BUF_FLAG_TSTAMP_SRC_MASK buffer-flags
+replace define V4L2_BUF_FLAG_TSTAMP_SRC_EOF buffer-flags
+replace define V4L2_BUF_FLAG_TSTAMP_SRC_SOE buffer-flags
+replace define V4L2_BUF_FLAG_LAST buffer-flags-FIXME
+
+# V4L2 framebuffer caps and flags
+
+replace define V4L2_FBUF_CAP_EXTERNOVERLAY framebuffer-cap
+replace define V4L2_FBUF_CAP_CHROMAKEY framebuffer-cap
+replace define V4L2_FBUF_CAP_LIST_CLIPPING framebuffer-cap
+replace define V4L2_FBUF_CAP_BITMAP_CLIPPING framebuffer-cap
+replace define V4L2_FBUF_CAP_LOCAL_ALPHA framebuffer-cap
+replace define V4L2_FBUF_CAP_GLOBAL_ALPHA framebuffer-cap
+replace define V4L2_FBUF_CAP_LOCAL_INV_ALPHA framebuffer-cap
+replace define V4L2_FBUF_CAP_SRC_CHROMAKEY framebuffer-cap
+
+replace define V4L2_FBUF_FLAG_PRIMARY framebuffer-flags
+replace define V4L2_FBUF_FLAG_OVERLAY framebuffer-flags
+replace define V4L2_FBUF_FLAG_CHROMAKEY framebuffer-flags
+replace define V4L2_FBUF_FLAG_LOCAL_ALPHA framebuffer-flags
+replace define V4L2_FBUF_FLAG_GLOBAL_ALPHA framebuffer-flags
+replace define V4L2_FBUF_FLAG_LOCAL_INV_ALPHA framebuffer-flags
+replace define V4L2_FBUF_FLAG_SRC_CHROMAKEY framebuffer-flags
+
+# Used on VIDIOC_G_PARM
+
+replace define V4L2_MODE_HIGHQUALITY parm-flags
+replace define V4L2_CAP_TIMEPERFRAME v4l2-captureparm
 
 # The V4L2_STD_foo are all defined at v4l2_std_id table
+
 replace define V4L2_STD_PAL_B v4l2-std-id
 replace define V4L2_STD_PAL_B1 v4l2-std-id
 replace define V4L2_STD_PAL_G v4l2-std-id
@@ -442,8 +278,254 @@ replace define V4L2_STD_ATSC v4l2-std-id
 replace define V4L2_STD_UNKNOWN v4l2-std-id
 replace define V4L2_STD_ALL v4l2-std-id
 
-# Ignore reserved ioctl
+# V4L2 DT BT timings definitions
+
+replace define V4L2_DV_PROGRESSIVE v4l2-dv-fixme
+replace define V4L2_DV_INTERLACED v4l2-dv-fixme
+
+replace define V4L2_DV_VSYNC_POS_POL v4l2-bt-timings
+replace define V4L2_DV_HSYNC_POS_POL v4l2-bt-timings
+
+replace define V4L2_DV_BT_STD_CEA861 dv-bt-standards
+replace define V4L2_DV_BT_STD_DMT dv-bt-standards
+replace define V4L2_DV_BT_STD_CVT dv-bt-standards
+replace define V4L2_DV_BT_STD_GTF dv-bt-standards
+
+replace define V4L2_DV_FL_REDUCED_BLANKING dv-bt-standards
+replace define V4L2_DV_FL_CAN_REDUCE_FPS dv-bt-standards
+replace define V4L2_DV_FL_REDUCED_FPS dv-bt-standards
+replace define V4L2_DV_FL_HALF_LINE dv-bt-standards
+replace define V4L2_DV_FL_IS_CE_VIDEO dv-bt-standards
+
+replace define V4L2_DV_BT_656_1120 dv-timing-types
+
+replace define V4L2_DV_BT_CAP_INTERLACED framebuffer-cap
+replace define V4L2_DV_BT_CAP_PROGRESSIVE framebuffer-cap
+replace define V4L2_DV_BT_CAP_REDUCED_BLANKING framebuffer-cap
+replace define V4L2_DV_BT_CAP_CUSTOM framebuffer-cap
+
+# V4L2 input
+
+replace define V4L2_INPUT_TYPE_TUNER input-type
+replace define V4L2_INPUT_TYPE_CAMERA input-type
+
+replace define V4L2_IN_ST_NO_POWER input-status
+replace define V4L2_IN_ST_NO_SIGNAL input-status
+replace define V4L2_IN_ST_NO_COLOR input-status
+replace define V4L2_IN_ST_HFLIP input-status
+replace define V4L2_IN_ST_VFLIP input-status
+replace define V4L2_IN_ST_NO_H_LOCK input-status
+replace define V4L2_IN_ST_COLOR_KILL input-status
+replace define V4L2_IN_ST_NO_SYNC input-status
+replace define V4L2_IN_ST_NO_EQU input-status
+replace define V4L2_IN_ST_NO_CARRIER input-status
+replace define V4L2_IN_ST_MACROVISION input-status
+replace define V4L2_IN_ST_NO_ACCESS input-status
+replace define V4L2_IN_ST_VTR input-status
+
+replace define V4L2_IN_CAP_DV_TIMINGS input-capabilities
+replace define V4L2_IN_CAP_STD input-capabilities
+replace define V4L2_IN_CAP_NATIVE_SIZE input-capabilities
+
+# V4L2 output
+
+replace define V4L2_OUTPUT_TYPE_MODULATOR output-type
+replace define V4L2_OUTPUT_TYPE_ANALOG output-type
+replace define V4L2_OUTPUT_TYPE_ANALOGVGAOVERLAY output-type
+
+replace define V4L2_OUT_CAP_DV_TIMINGS output-capabilities
+replace define V4L2_OUT_CAP_STD output-capabilities
+replace define V4L2_OUT_CAP_NATIVE_SIZE output-capabilities
+
+# V4L2 control flags
+
+replace define V4L2_CTRL_FLAG_DISABLED control-flags
+replace define V4L2_CTRL_FLAG_GRABBED control-flags
+replace define V4L2_CTRL_FLAG_READ_ONLY control-flags
+replace define V4L2_CTRL_FLAG_UPDATE control-flags
+replace define V4L2_CTRL_FLAG_INACTIVE control-flags
+replace define V4L2_CTRL_FLAG_SLIDER control-flags
+replace define V4L2_CTRL_FLAG_WRITE_ONLY control-flags
+replace define V4L2_CTRL_FLAG_VOLATILE control-flags
+replace define V4L2_CTRL_FLAG_HAS_PAYLOAD control-flags
+replace define V4L2_CTRL_FLAG_EXECUTE_ON_WRITE control-flags
+
+replace define V4L2_CTRL_FLAG_NEXT_CTRL control
+replace define V4L2_CTRL_FLAG_NEXT_COMPOUND control
+replace define V4L2_CID_PRIVATE_BASE control
+
+# V4L2 tuner
+
+replace define V4L2_TUNER_CAP_LOW tuner-capability
+replace define V4L2_TUNER_CAP_NORM tuner-capability
+replace define V4L2_TUNER_CAP_HWSEEK_BOUNDED tuner-capability
+replace define V4L2_TUNER_CAP_HWSEEK_WRAP tuner-capability
+replace define V4L2_TUNER_CAP_STEREO tuner-capability
+replace define V4L2_TUNER_CAP_LANG2 tuner-capability
+replace define V4L2_TUNER_CAP_SAP tuner-capability
+replace define V4L2_TUNER_CAP_LANG1 tuner-capability
+replace define V4L2_TUNER_CAP_RDS tuner-capability
+replace define V4L2_TUNER_CAP_RDS_BLOCK_IO tuner-capability
+replace define V4L2_TUNER_CAP_RDS_CONTROLS tuner-capability
+replace define V4L2_TUNER_CAP_FREQ_BANDS tuner-capability
+replace define V4L2_TUNER_CAP_HWSEEK_PROG_LIM tuner-capability
+replace define V4L2_TUNER_CAP_1HZ tuner-capability
+
+replace define V4L2_TUNER_SUB_MONO tuner-rxsubchans
+replace define V4L2_TUNER_SUB_STEREO tuner-rxsubchans
+replace define V4L2_TUNER_SUB_LANG2 tuner-rxsubchans
+replace define V4L2_TUNER_SUB_SAP tuner-rxsubchans
+replace define V4L2_TUNER_SUB_LANG1 tuner-rxsubchans
+replace define V4L2_TUNER_SUB_RDS tuner-rxsubchans
+
+replace define V4L2_TUNER_MODE_MONO tuner-audmode
+replace define V4L2_TUNER_MODE_STEREO tuner-audmode
+replace define V4L2_TUNER_MODE_LANG2 tuner-audmode
+replace define V4L2_TUNER_MODE_SAP tuner-audmode
+replace define V4L2_TUNER_MODE_LANG1 tuner-audmode
+replace define V4L2_TUNER_MODE_LANG1_LANG2 tuner-audmode
+
+replace define V4L2_BAND_MODULATION_VSB band-modulation
+replace define V4L2_BAND_MODULATION_FM band-modulation
+replace define V4L2_BAND_MODULATION_AM band-modulation
+
+replace define V4L2_RDS_BLOCK_MSK v4l2-rds-block
+replace define V4L2_RDS_BLOCK_A v4l2-rds-block
+replace define V4L2_RDS_BLOCK_B v4l2-rds-block
+replace define V4L2_RDS_BLOCK_C v4l2-rds-block
+replace define V4L2_RDS_BLOCK_D v4l2-rds-block
+replace define V4L2_RDS_BLOCK_C_ALT v4l2-rds-block
+replace define V4L2_RDS_BLOCK_INVALID v4l2-rds-block
+replace define V4L2_RDS_BLOCK_CORRECTED v4l2-rds-block
+replace define V4L2_RDS_BLOCK_ERROR v4l2-rds-block
+
+# V4L2 audio
+
+replace define V4L2_AUDCAP_STEREO audio-capability
+replace define V4L2_AUDCAP_AVL audio-capability
+
+replace define V4L2_AUDMODE_AVL audio-mode
+
+# MPEG
+
+replace define V4L2_ENC_IDX_FRAME_I v4l2-enc-idx
+replace define V4L2_ENC_IDX_FRAME_P v4l2-enc-idx
+replace define V4L2_ENC_IDX_FRAME_B v4l2-enc-idx
+replace define V4L2_ENC_IDX_FRAME_MASK v4l2-enc-idx
+replace define V4L2_ENC_IDX_ENTRIES v4l2-enc-idx
+
+replace define V4L2_ENC_CMD_START encoder-cmds
+replace define V4L2_ENC_CMD_STOP encoder-cmds
+replace define V4L2_ENC_CMD_PAUSE encoder-cmds
+replace define V4L2_ENC_CMD_RESUME encoder-cmds
+
+replace define V4L2_ENC_CMD_STOP_AT_GOP_END encoder-flags
+
+replace define V4L2_DEC_CMD_START decoder-cmds
+replace define V4L2_DEC_CMD_STOP decoder-cmds
+replace define V4L2_DEC_CMD_PAUSE decoder-cmds
+replace define V4L2_DEC_CMD_RESUME decoder-cmds
+
+replace define V4L2_DEC_CMD_START_MUTE_AUDIO decoder-cmds
+replace define V4L2_DEC_CMD_PAUSE_TO_BLACK decoder-cmds
+replace define V4L2_DEC_CMD_STOP_TO_BLACK decoder-cmds
+replace define V4L2_DEC_CMD_STOP_IMMEDIATELY decoder-cmds
+
+replace define V4L2_DEC_START_FMT_NONE decoder-cmds
+replace define V4L2_DEC_START_FMT_GOP decoder-cmds
+
+# V4L2 VBI
+
+replace define V4L2_VBI_UNSYNC vbifmt-flags
+replace define V4L2_VBI_INTERLACED vbifmt-flags
+
+replace define V4L2_VBI_ITU_525_F1_START v4l2-vbi-format
+replace define V4L2_VBI_ITU_525_F2_START v4l2-vbi-format
+replace define V4L2_VBI_ITU_625_F1_START v4l2-vbi-format
+replace define V4L2_VBI_ITU_625_F2_START v4l2-vbi-format
+
+
+replace define V4L2_SLICED_TELETEXT_B vbi-services
+replace define V4L2_SLICED_VPS vbi-services
+replace define V4L2_SLICED_CAPTION_525 vbi-services
+replace define V4L2_SLICED_WSS_625 vbi-services
+replace define V4L2_SLICED_VBI_525 vbi-services
+replace define V4L2_SLICED_VBI_625 vbi-services
+
+replace define V4L2_MPEG_VBI_IVTV_TELETEXT_B ITV0-Line-Identifier-Constants
+replace define V4L2_MPEG_VBI_IVTV_CAPTION_525 ITV0-Line-Identifier-Constants
+replace define V4L2_MPEG_VBI_IVTV_WSS_625 ITV0-Line-Identifier-Constants
+replace define V4L2_MPEG_VBI_IVTV_VPS ITV0-Line-Identifier-Constants
+
+replace define V4L2_MPEG_VBI_IVTV_MAGIC0 v4l2-mpeg-vbi-fmt-ivtv-magic
+replace define V4L2_MPEG_VBI_IVTV_MAGIC1 v4l2-mpeg-vbi-fmt-ivtv-magic
+
+# V4L2 events
+
+replace define V4L2_EVENT_ALL event-type
+replace define V4L2_EVENT_VSYNC event-type
+replace define V4L2_EVENT_EOS event-type
+replace define V4L2_EVENT_CTRL event-type
+replace define V4L2_EVENT_FRAME_SYNC event-type
+replace define V4L2_EVENT_SOURCE_CHANGE event-type
+replace define V4L2_EVENT_MOTION_DET event-type
+replace define V4L2_EVENT_PRIVATE_START event-type
+
+replace define V4L2_EVENT_CTRL_CH_VALUE ctrl-changes-flags
+replace define V4L2_EVENT_CTRL_CH_FLAGS ctrl-changes-flags
+replace define V4L2_EVENT_CTRL_CH_RANGE ctrl-changes-flags
+
+replace define V4L2_EVENT_SRC_CH_RESOLUTION src-changes-flags
+
+replace define V4L2_EVENT_MD_FL_HAVE_FRAME_SEQ v4l2-event-motion-det
+
+replace define V4L2_EVENT_SUB_FL_SEND_INITIAL event-flags
+replace define V4L2_EVENT_SUB_FL_ALLOW_FEEDBACK event-flags
+
+# V4L2 debugging
+replace define V4L2_CHIP_MATCH_BRIDGE vidioc_dbg_g_register
+replace define V4L2_CHIP_MATCH_SUBDEV vidioc_dbg_g_register
+replace define V4L2_CHIP_MATCH_HOST vidioc_dbg_g_register
+replace define V4L2_CHIP_MATCH_I2C_DRIVER vidioc_dbg_g_register
+replace define V4L2_CHIP_MATCH_I2C_ADDR vidioc_dbg_g_register
+replace define V4L2_CHIP_MATCH_AC97 vidioc_dbg_g_register
+
+replace define V4L2_CHIP_FL_READABLE vidioc_dbg_g_register
+replace define V4L2_CHIP_FL_WRITABLE vidioc_dbg_g_register
+
+# Ignore reserved ioctl and ancillary macros
+
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
+ignore define V4L2_DV_BT_BLANKING_WIDTH
+ignore define V4L2_DV_BT_FRAME_WIDTH
+ignore define V4L2_DV_BT_BLANKING_HEIGHT
+ignore define V4L2_DV_BT_FRAME_HEIGHT
+ignore define V4L2_IN_CAP_CUSTOM_TIMINGS
+ignore define V4L2_CTRL_ID_MASK
+ignore define V4L2_CTRL_ID2CLASS
+ignore define V4L2_CTRL_ID2WHICH
+ignore define V4L2_CTRL_DRIVER_PRIV
+ignore define V4L2_CTRL_MAX_DIMS
+ignore define V4L2_CTRL_WHICH_CUR_VAL
+ignore define V4L2_CTRL_WHICH_DEF_VAL
+ignore define V4L2_OUT_CAP_CUSTOM_TIMINGS
+ignore define V4L2_CID_MAX_CTRLS
+
 ignore ioctl VIDIOC_RESERVED
+ignore define BASE_VIDIOC_PRIVATE
 
 # Associate ioctls with their counterparts
 replace ioctl VIDIOC_DBG_S_REGISTER vidioc_dbg_g_register
-- 
2.7.4

