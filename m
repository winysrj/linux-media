Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35645 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754800AbcHSDqX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 Aug 2016 23:46:23 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Markus Heiser <markus.heiser@darmarit.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Markus Heiser <markus.heiser@darmarIT.de>
Subject: [PATCH 04/20] [media] extended-controls.rst: fix table sizes
Date: Thu, 18 Aug 2016 13:15:33 -0300
Message-Id: <5c1fa669e5506e6c1af467b9e56d07b8e95f5b98.1471532123.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471532122.git.mchehab@s-opensource.com>
References: <cover.1471532122.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471532122.git.mchehab@s-opensource.com>
References: <cover.1471532122.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Lots of tables at extended-controls.rst need explicit hints for
LaTeX to adjust their widths. Provide that.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/v4l/extended-controls.rst | 63 ++++++++++++----------
 1 file changed, 36 insertions(+), 27 deletions(-)

diff --git a/Documentation/media/uapi/v4l/extended-controls.rst b/Documentation/media/uapi/v4l/extended-controls.rst
index 782f7f3c2209..3f0f94a5eeed 100644
--- a/Documentation/media/uapi/v4l/extended-controls.rst
+++ b/Documentation/media/uapi/v4l/extended-controls.rst
@@ -291,6 +291,8 @@ Codec Control IDs
 
 
 
+.. tabularcolumns:: |p{6 cm}|p{11.5cm}|
+
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
@@ -964,6 +966,8 @@ Codec Control IDs
 
 
 
+.. tabularcolumns:: |p{9.0cm}|p{8.5cm}|
+
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
@@ -1671,6 +1675,8 @@ Codec Control IDs
 
 
 
+.. tabularcolumns:: |p{5.5cm}|p{12.0cm}|
+
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
@@ -1715,11 +1721,12 @@ Codec Control IDs
 
 
 
+.. tabularcolumns:: |p{14.0cm}|p{3.5cm}|
+
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
 
-
     -  .. row 1
 
        -  ``V4L2_MPEG_VIDEO_H264_LOOP_FILTER_MODE_ENABLED``
@@ -1918,6 +1925,8 @@ Codec Control IDs
 
 
 
+.. tabularcolumns:: |p{10.3cm}|p{7.2cm}|
+
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
@@ -1967,17 +1976,16 @@ Codec Control IDs
 
 .. _v4l2-mpeg-video-h264-sei-fp-arrangement-type:
 
-``V4L2_CID_MPEG_VIDEO_H264_SEI_FP_ARRANGEMENT_TYPE (enum v4l2_mpeg_video_h264_sei_fp_arrangement_type)``
+``V4L2_CID_MPEG_VIDEO_H264_SEI_FP_ARRANGEMENT_TYPE`` ``(enum v4l2_mpeg_video_h264_sei_fp_arrangement_type)``
     Frame packing arrangement type for H264 SEI. Applicable to the H264
     encoder. Possible values are:
 
-
+.. tabularcolumns:: |p{12cm}|p{5.5cm}|
 
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
 
-
     -  .. row 1
 
        -  ``V4L2_MPEG_VIDEO_H264_SEI_FP_ARRANGEMENT_TYPE_CHEKERBOARD``
@@ -2023,18 +2031,17 @@ Codec Control IDs
 
 .. _v4l2-mpeg-video-h264-fmo-map-type:
 
-``V4L2_CID_MPEG_VIDEO_H264_FMO_MAP_TYPE (enum v4l2_mpeg_video_h264_fmo_map_type)``
+``V4L2_CID_MPEG_VIDEO_H264_FMO_MAP_TYPE`` ``(enum v4l2_mpeg_video_h264_fmo_map_type)``
     When using FMO, the map type divides the image in different scan
     patterns of macroblocks. Applicable to the H264 encoder. Possible
     values are:
 
-
+.. tabularcolumns:: |p{12.5cm}|p{5.0cm}|
 
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
 
-
     -  .. row 1
 
        -  ``V4L2_MPEG_VIDEO_H264_FMO_MAP_TYPE_INTERLEAVED_SLICES``
@@ -2330,12 +2337,12 @@ MFC 5.1 Control IDs
     are:
 
 
+.. tabularcolumns:: |p{9.0cm}|p{8.5cm}|
 
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
 
-
     -  .. row 1
 
        -  ``V4L2_MPEG_MFC51_FRAME_SKIP_MODE_DISABLED``
@@ -2455,6 +2462,8 @@ CX2341x Control IDs
 
 
 
+.. tabularcolumns:: |p{14.5cm}|p{3.0cm}|
+
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
@@ -2679,13 +2688,12 @@ VPX Control IDs
     The number of reference pictures for encoding P frames. Possible
     values are:
 
-
+.. tabularcolumns:: |p{7.9cm}|p{9.6cm}|
 
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
 
-
     -  .. row 1
 
        -  ``V4L2_CID_MPEG_VIDEO_VPX_1_REF_FRAME``
@@ -2731,13 +2739,16 @@ VPX Control IDs
 ``V4L2_CID_MPEG_VIDEO_VPX_GOLDEN_FRAME_SEL (enum v4l2_vp8_golden_frame_sel)``
     Selects the golden frame for encoding. Possible values are:
 
+.. raw:: latex
 
+    \begin{adjustbox}{width=\columnwidth}
+
+.. tabularcolumns:: |p{11.0cm}|p{10.0cm}|
 
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
 
-
     -  .. row 1
 
        -  ``V4L2_CID_MPEG_VIDEO_VPX_GOLDEN_FRAME_USE_PREV``
@@ -2750,9 +2761,12 @@ VPX Control IDs
        -  ``V4L2_CID_MPEG_VIDEO_VPX_GOLDEN_FRAME_USE_REF_PERIOD``
 
        -  Use the previous specific frame indicated by
-	  V4L2_CID_MPEG_VIDEO_VPX_GOLDEN_FRAME_REF_PERIOD as a
+	  ``V4L2_CID_MPEG_VIDEO_VPX_GOLDEN_FRAME_REF_PERIOD`` as a
 	  golden frame.
 
+.. raw:: latex
+
+    \end{adjustbox}
 
 
 ``V4L2_CID_MPEG_VIDEO_VPX_MIN_QP (integer)``
@@ -2862,13 +2876,12 @@ Camera Control IDs
     Determines how the camera measures the amount of light available for
     the frame exposure. Possible values are:
 
-
+.. tabularcolumns:: |p{8.5cm}|p{9.0cm}|
 
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
 
-
     -  .. row 1
 
        -  ``V4L2_EXPOSURE_METERING_AVERAGE``
@@ -2970,13 +2983,12 @@ Camera Control IDs
     control may stop updates of the ``V4L2_CID_AUTO_FOCUS_STATUS``
     control value.
 
-
+.. tabularcolumns:: |p{6.5cm}|p{11.0cm}|
 
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
 
-
     -  .. row 1
 
        -  ``V4L2_AUTO_FOCUS_STATUS_IDLE``
@@ -3009,7 +3021,7 @@ Camera Control IDs
 ``V4L2_CID_AUTO_FOCUS_RANGE (enum v4l2_auto_focus_range)``
     Determines auto focus distance range for which lens may be adjusted.
 
-
+.. tabularcolumns:: |p{6.5cm}|p{11.0cm}|
 
 .. flat-table::
     :header-rows:  0
@@ -3097,13 +3109,12 @@ Camera Control IDs
     representation. The following white balance presets are listed in
     order of increasing color temperature.
 
-
+.. tabularcolumns:: |p{7.0 cm}|p{10.5cm}|
 
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
 
-
     -  .. row 1
 
        -  ``V4L2_WHITE_BALANCE_MANUAL``
@@ -3245,13 +3256,12 @@ Camera Control IDs
     to ``V4L2_SCENE_MODE_NONE`` to make sure the other possibly related
     controls are accessible. The following scene programs are defined:
 
-
+.. tabularcolumns:: |p{6.0cm}|p{11.5cm}|
 
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
 
-
     -  .. row 1
 
        -  ``V4L2_SCENE_MODE_NONE``
@@ -3710,13 +3720,12 @@ Flash Control IDs
 ``V4L2_CID_FLASH_STROBE_SOURCE (menu)``
     Defines the source of the flash LED strobe.
 
-
+.. tabularcolumns:: |p{7.0cm}|p{10.5cm}|
 
 .. flat-table::
     :header-rows:  0
     :stub-columns: 0
 
-
     -  .. row 1
 
        -  ``V4L2_FLASH_STROBE_SOURCE_SOFTWARE``
@@ -3777,7 +3786,7 @@ Flash Control IDs
     an effect is chip dependent. Reading the faults resets the control
     and returns the chip to a usable state if possible.
 
-
+.. tabularcolumns:: |p{8.0cm}|p{9.5cm}|
 
 .. flat-table::
     :header-rows:  0
@@ -3888,7 +3897,7 @@ JPEG Control IDs
     how Cb and Cr components are downsampled after coverting an input
     image from RGB to Y'CbCr color space.
 
-
+.. tabularcolumns:: |p{7.0cm}|p{10.5cm}|
 
 .. flat-table::
     :header-rows:  0
@@ -4190,7 +4199,7 @@ Digital Video Control IDs
     or an analog source. The enum v4l2_dv_it_content_type defines
     the possible content types:
 
-
+.. tabularcolumns:: |p{7.0cm}|p{10.5cm}|
 
 .. flat-table::
     :header-rows:  0
@@ -4384,7 +4393,7 @@ Detect Control IDs
 ``V4L2_CID_DETECT_MD_MODE (menu)``
     Sets the motion detection mode.
 
-
+.. tabularcolumns:: |p{7.5cm}|p{10.0cm}|
 
 .. flat-table::
     :header-rows:  0
-- 
2.7.4


