Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43706 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750953AbcHTBlA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Aug 2016 21:41:00 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Markus Heiser <markus.heiser@darmarIT.de>,
        linux-doc@vger.kernel.org
Subject: [PATCH 1/3] [media] extended-controls.rst: avoid going past page with LaTeX
Date: Fri, 19 Aug 2016 22:40:51 -0300
Message-Id: <abb3c02861cfaf59fbdce94117aade037cb6d32c.1471657229.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It is painful to put code/verbatim code in bold. It seems that
the only way is to arrange it like:
	``foo``
	    bar

At least on LaTeX output, when this happens, the "foo" string
is not hidentable/breakable. The entire string should fit into
a single line.

Add a workaround for this ReST limitation by splitting the
foo string into two strings, on separate lines. The output
is not the best, but it works.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/v4l/extended-controls.rst | 267 ++++++++++++++++-----
 1 file changed, 213 insertions(+), 54 deletions(-)

diff --git a/Documentation/media/uapi/v4l/extended-controls.rst b/Documentation/media/uapi/v4l/extended-controls.rst
index 3f0f94a5eeed..9c6aff3e97c1 100644
--- a/Documentation/media/uapi/v4l/extended-controls.rst
+++ b/Documentation/media/uapi/v4l/extended-controls.rst
@@ -209,7 +209,10 @@ Codec Control IDs
 
 .. _v4l2-mpeg-stream-type:
 
-``V4L2_CID_MPEG_STREAM_TYPE (enum v4l2_mpeg_stream_type)``
+``V4L2_CID_MPEG_STREAM_TYPE``
+    (enum)
+
+enum v4l2_mpeg_stream_type -
     The MPEG-1, -2 or -4 output stream type. One cannot assume anything
     here. Each hardware MPEG encoder tends to support different subsets
     of the available MPEG stream types. This control is specific to
@@ -282,7 +285,10 @@ Codec Control IDs
 
 .. _v4l2-mpeg-stream-vbi-fmt:
 
-``V4L2_CID_MPEG_STREAM_VBI_FMT (enum v4l2_mpeg_stream_vbi_fmt)``
+``V4L2_CID_MPEG_STREAM_VBI_FMT``
+    (enum)
+
+enum v4l2_mpeg_stream_vbi_fmt -
     Some cards can embed VBI data (e. g. Closed Caption, Teletext) into
     the MPEG stream. This control selects whether VBI data should be
     embedded, and if so, what embedding method should be used. The list
@@ -316,7 +322,10 @@ Codec Control IDs
 
 .. _v4l2-mpeg-audio-sampling-freq:
 
-``V4L2_CID_MPEG_AUDIO_SAMPLING_FREQ (enum v4l2_mpeg_audio_sampling_freq)``
+``V4L2_CID_MPEG_AUDIO_SAMPLING_FREQ``
+    (enum)
+
+enum v4l2_mpeg_audio_sampling_freq -
     MPEG Audio sampling frequency. Possible values are:
 
 
@@ -348,7 +357,10 @@ Codec Control IDs
 
 .. _v4l2-mpeg-audio-encoding:
 
-``V4L2_CID_MPEG_AUDIO_ENCODING (enum v4l2_mpeg_audio_encoding)``
+``V4L2_CID_MPEG_AUDIO_ENCODING``
+    (enum)
+
+enum v4l2_mpeg_audio_encoding -
     MPEG Audio encoding. This control is specific to multiplexed MPEG
     streams. Possible values are:
 
@@ -393,7 +405,10 @@ Codec Control IDs
 
 .. _v4l2-mpeg-audio-l1-bitrate:
 
-``V4L2_CID_MPEG_AUDIO_L1_BITRATE (enum v4l2_mpeg_audio_l1_bitrate)``
+``V4L2_CID_MPEG_AUDIO_L1_BITRATE``
+    (enum)
+
+enum v4l2_mpeg_audio_l1_bitrate -
     MPEG-1/2 Layer I bitrate. Possible values are:
 
 
@@ -491,7 +506,10 @@ Codec Control IDs
 
 .. _v4l2-mpeg-audio-l2-bitrate:
 
-``V4L2_CID_MPEG_AUDIO_L2_BITRATE (enum v4l2_mpeg_audio_l2_bitrate)``
+``V4L2_CID_MPEG_AUDIO_L2_BITRATE``
+    (enum)
+
+enum v4l2_mpeg_audio_l2_bitrate -
     MPEG-1/2 Layer II bitrate. Possible values are:
 
 
@@ -589,7 +607,10 @@ Codec Control IDs
 
 .. _v4l2-mpeg-audio-l3-bitrate:
 
-``V4L2_CID_MPEG_AUDIO_L3_BITRATE (enum v4l2_mpeg_audio_l3_bitrate)``
+``V4L2_CID_MPEG_AUDIO_L3_BITRATE``
+    (enum)
+
+enum v4l2_mpeg_audio_l3_bitrate -
     MPEG-1/2 Layer III bitrate. Possible values are:
 
 
@@ -690,7 +711,10 @@ Codec Control IDs
 
 .. _v4l2-mpeg-audio-ac3-bitrate:
 
-``V4L2_CID_MPEG_AUDIO_AC3_BITRATE (enum v4l2_mpeg_audio_ac3_bitrate)``
+``V4L2_CID_MPEG_AUDIO_AC3_BITRATE``
+    (enum)
+
+enum v4l2_mpeg_audio_ac3_bitrate -
     AC-3 bitrate. Possible values are:
 
 
@@ -818,7 +842,10 @@ Codec Control IDs
 
 .. _v4l2-mpeg-audio-mode:
 
-``V4L2_CID_MPEG_AUDIO_MODE (enum v4l2_mpeg_audio_mode)``
+``V4L2_CID_MPEG_AUDIO_MODE``
+    (enum)
+
+enum v4l2_mpeg_audio_mode -
     MPEG Audio mode. Possible values are:
 
 
@@ -856,7 +883,10 @@ Codec Control IDs
 
 .. _v4l2-mpeg-audio-mode-extension:
 
-``V4L2_CID_MPEG_AUDIO_MODE_EXTENSION (enum v4l2_mpeg_audio_mode_extension)``
+``V4L2_CID_MPEG_AUDIO_MODE_EXTENSION``
+    (enum)
+
+enum v4l2_mpeg_audio_mode_extension -
     Joint Stereo audio mode extension. In Layer I and II they indicate
     which subbands are in intensity stereo. All other subbands are coded
     in stereo. Layer III is not (yet) supported. Possible values are:
@@ -896,7 +926,10 @@ Codec Control IDs
 
 .. _v4l2-mpeg-audio-emphasis:
 
-``V4L2_CID_MPEG_AUDIO_EMPHASIS (enum v4l2_mpeg_audio_emphasis)``
+``V4L2_CID_MPEG_AUDIO_EMPHASIS``
+    (enum)
+
+enum v4l2_mpeg_audio_emphasis -
     Audio Emphasis. Possible values are:
 
 
@@ -928,7 +961,10 @@ Codec Control IDs
 
 .. _v4l2-mpeg-audio-crc:
 
-``V4L2_CID_MPEG_AUDIO_CRC (enum v4l2_mpeg_audio_crc)``
+``V4L2_CID_MPEG_AUDIO_CRC``
+    (enum)
+
+enum v4l2_mpeg_audio_crc -
     CRC method. Possible values are:
 
 
@@ -960,7 +996,10 @@ Codec Control IDs
 
 .. _v4l2-mpeg-audio-dec-playback:
 
-``V4L2_CID_MPEG_AUDIO_DEC_PLAYBACK (enum v4l2_mpeg_audio_dec_playback)``
+``V4L2_CID_MPEG_AUDIO_DEC_PLAYBACK``
+    (enum)
+
+enum v4l2_mpeg_audio_dec_playback -
     Determines how monolingual audio should be played back. Possible
     values are:
 
@@ -1013,12 +1052,18 @@ Codec Control IDs
 
 .. _v4l2-mpeg-audio-dec-multilingual-playback:
 
-``V4L2_CID_MPEG_AUDIO_DEC_MULTILINGUAL_PLAYBACK (enum v4l2_mpeg_audio_dec_playback)``
+``V4L2_CID_MPEG_AUDIO_DEC_MULTILINGUAL_PLAYBACK``
+    (enum)
+
+enum v4l2_mpeg_audio_dec_playback -
     Determines how multilingual audio should be played back.
 
 .. _v4l2-mpeg-video-encoding:
 
-``V4L2_CID_MPEG_VIDEO_ENCODING (enum v4l2_mpeg_video_encoding)``
+``V4L2_CID_MPEG_VIDEO_ENCODING``
+    (enum)
+
+enum v4l2_mpeg_video_encoding -
     MPEG Video encoding method. This control is specific to multiplexed
     MPEG streams. Possible values are:
 
@@ -1051,7 +1096,10 @@ Codec Control IDs
 
 .. _v4l2-mpeg-video-aspect:
 
-``V4L2_CID_MPEG_VIDEO_ASPECT (enum v4l2_mpeg_video_aspect)``
+``V4L2_CID_MPEG_VIDEO_ASPECT``
+    (enum)
+
+enum v4l2_mpeg_video_aspect -
     Video aspect. Possible values are:
 
 
@@ -1093,7 +1141,10 @@ Codec Control IDs
 
 .. _v4l2-mpeg-video-bitrate-mode:
 
-``V4L2_CID_MPEG_VIDEO_BITRATE_MODE (enum v4l2_mpeg_video_bitrate_mode)``
+``V4L2_CID_MPEG_VIDEO_BITRATE_MODE``
+    (enum)
+
+enum v4l2_mpeg_video_bitrate_mode -
     Video bitrate mode. Possible values are:
 
 
@@ -1197,7 +1248,10 @@ Codec Control IDs
 
 .. _v4l2-mpeg-video-h264-vui-sar-idc:
 
-``V4L2_CID_MPEG_VIDEO_H264_VUI_SAR_IDC (enum v4l2_mpeg_video_h264_vui_sar_idc)``
+``V4L2_CID_MPEG_VIDEO_H264_VUI_SAR_IDC``
+    (enum)
+
+enum v4l2_mpeg_video_h264_vui_sar_idc -
     VUI sample aspect ratio indicator for H.264 encoding. The value is
     defined in the table E-1 in the standard. Applicable to the H264
     encoder.
@@ -1329,7 +1383,10 @@ Codec Control IDs
 
 .. _v4l2-mpeg-video-h264-level:
 
-``V4L2_CID_MPEG_VIDEO_H264_LEVEL (enum v4l2_mpeg_video_h264_level)``
+``V4L2_CID_MPEG_VIDEO_H264_LEVEL``
+    (enum)
+
+enum v4l2_mpeg_video_h264_level -
     The level information for the H264 video elementary stream.
     Applicable to the H264 encoder. Possible values are:
 
@@ -1440,7 +1497,10 @@ Codec Control IDs
 
 .. _v4l2-mpeg-video-mpeg4-level:
 
-``V4L2_CID_MPEG_VIDEO_MPEG4_LEVEL (enum v4l2_mpeg_video_mpeg4_level)``
+``V4L2_CID_MPEG_VIDEO_MPEG4_LEVEL``
+    (enum)
+
+enum v4l2_mpeg_video_mpeg4_level -
     The level information for the MPEG4 elementary stream. Applicable to
     the MPEG4 encoder. Possible values are:
 
@@ -1503,7 +1563,10 @@ Codec Control IDs
 
 .. _v4l2-mpeg-video-h264-profile:
 
-``V4L2_CID_MPEG_VIDEO_H264_PROFILE (enum v4l2_mpeg_video_h264_profile)``
+``V4L2_CID_MPEG_VIDEO_H264_PROFILE``
+    (enum)
+
+enum v4l2_mpeg_video_h264_profile -
     The profile information for H264. Applicable to the H264 encoder.
     Possible values are:
 
@@ -1620,7 +1683,10 @@ Codec Control IDs
 
 .. _v4l2-mpeg-video-mpeg4-profile:
 
-``V4L2_CID_MPEG_VIDEO_MPEG4_PROFILE (enum v4l2_mpeg_video_mpeg4_profile)``
+``V4L2_CID_MPEG_VIDEO_MPEG4_PROFILE``
+    (enum)
+
+enum v4l2_mpeg_video_mpeg4_profile -
     The profile information for MPEG4. Applicable to the MPEG4 encoder.
     Possible values are:
 
@@ -1669,13 +1735,16 @@ Codec Control IDs
 
 .. _v4l2-mpeg-video-multi-slice-mode:
 
-``V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MODE (enum v4l2_mpeg_video_multi_slice_mode)``
+``V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MODE``
+    (enum)
+
+enum v4l2_mpeg_video_multi_slice_mode -
     Determines how the encoder should handle division of frame into
     slices. Applicable to the encoder. Possible values are:
 
 
 
-.. tabularcolumns:: |p{5.5cm}|p{12.0cm}|
+.. tabularcolumns:: |p{8.7cm}|p{8.8cm}|
 
 .. flat-table::
     :header-rows:  0
@@ -1716,7 +1785,10 @@ Codec Control IDs
 
 .. _v4l2-mpeg-video-h264-loop-filter-mode:
 
-``V4L2_CID_MPEG_VIDEO_H264_LOOP_FILTER_MODE (enum v4l2_mpeg_video_h264_loop_filter_mode)``
+``V4L2_CID_MPEG_VIDEO_H264_LOOP_FILTER_MODE``
+    (enum)
+
+enum v4l2_mpeg_video_h264_loop_filter_mode -
     Loop filter mode for H264 encoder. Possible values are:
 
 
@@ -1757,7 +1829,10 @@ Codec Control IDs
 
 .. _v4l2-mpeg-video-h264-entropy-mode:
 
-``V4L2_CID_MPEG_VIDEO_H264_ENTROPY_MODE (enum v4l2_mpeg_video_h264_entropy_mode)``
+``V4L2_CID_MPEG_VIDEO_H264_ENTROPY_MODE``
+    (enum)
+
+enum v4l2_mpeg_video_h264_entropy_mode -
     Entropy coding mode for H264 - CABAC/CAVALC. Applicable to the H264
     encoder. Possible values are:
 
@@ -1918,7 +1993,10 @@ Codec Control IDs
 
 .. _v4l2-mpeg-video-header-mode:
 
-``V4L2_CID_MPEG_VIDEO_HEADER_MODE (enum v4l2_mpeg_video_header_mode)``
+``V4L2_CID_MPEG_VIDEO_HEADER_MODE``
+    (enum)
+
+enum v4l2_mpeg_video_header_mode -
     Determines whether the header is returned as the first buffer or is
     it returned together with the first frame. Applicable to encoders.
     Possible values are:
@@ -1976,7 +2054,10 @@ Codec Control IDs
 
 .. _v4l2-mpeg-video-h264-sei-fp-arrangement-type:
 
-``V4L2_CID_MPEG_VIDEO_H264_SEI_FP_ARRANGEMENT_TYPE`` ``(enum v4l2_mpeg_video_h264_sei_fp_arrangement_type)``
+``V4L2_CID_MPEG_VIDEO_H264_SEI_FP_ARRANGEMENT_TYPE``
+    (enum)
+
+enum v4l2_mpeg_video_h264_sei_fp_arrangement_type -
     Frame packing arrangement type for H264 SEI. Applicable to the H264
     encoder. Possible values are:
 
@@ -2031,7 +2112,10 @@ Codec Control IDs
 
 .. _v4l2-mpeg-video-h264-fmo-map-type:
 
-``V4L2_CID_MPEG_VIDEO_H264_FMO_MAP_TYPE`` ``(enum v4l2_mpeg_video_h264_fmo_map_type)``
+``V4L2_CID_MPEG_VIDEO_H264_FMO_MAP_TYPE`` ````
+    (enum)
+
+enum v4l2_mpeg_video_h264_fmo_map_type -
     When using FMO, the map type divides the image in different scan
     patterns of macroblocks. Applicable to the H264 encoder. Possible
     values are:
@@ -2093,7 +2177,10 @@ Codec Control IDs
 
 .. _v4l2-mpeg-video-h264-fmo-change-direction:
 
-``V4L2_CID_MPEG_VIDEO_H264_FMO_CHANGE_DIRECTION (enum v4l2_mpeg_video_h264_fmo_change_dir)``
+``V4L2_CID_MPEG_VIDEO_H264_FMO_CHANGE_DIRECTION``
+    (enum)
+
+enum v4l2_mpeg_video_h264_fmo_change_dir -
     Specifies a direction of the slice group change for raster and wipe
     maps. Applicable to the H264 encoder. Possible values are:
 
@@ -2161,7 +2248,10 @@ Codec Control IDs
 
 .. _v4l2-mpeg-video-h264-hierarchical-coding-type:
 
-``V4L2_CID_MPEG_VIDEO_H264_HIERARCHICAL_CODING_TYPE (enum v4l2_mpeg_video_h264_hierarchical_coding_type)``
+``V4L2_CID_MPEG_VIDEO_H264_HIERARCHICAL_CODING_TYPE``
+    (enum)
+
+enum v4l2_mpeg_video_h264_hierarchical_coding_type -
     Specifies the hierarchical coding type. Applicable to the H264
     encoder. Possible values are:
 
@@ -2330,7 +2420,10 @@ MFC 5.1 Control IDs
 
 .. _v4l2-mpeg-mfc51-video-frame-skip-mode:
 
-``V4L2_CID_MPEG_MFC51_VIDEO_FRAME_SKIP_MODE (enum v4l2_mpeg_mfc51_video_frame_skip_mode)``
+``V4L2_CID_MPEG_MFC51_VIDEO_FRAME_SKIP_MODE``
+    (enum)
+
+enum v4l2_mpeg_mfc51_video_frame_skip_mode -
     Indicates in what conditions the encoder should skip frames. If
     encoding a frame would cause the encoded stream to be larger then a
     chosen data limit then the frame will be skipped. Possible values
@@ -2379,7 +2472,10 @@ MFC 5.1 Control IDs
 
 .. _v4l2-mpeg-mfc51-video-force-frame-type:
 
-``V4L2_CID_MPEG_MFC51_VIDEO_FORCE_FRAME_TYPE (enum v4l2_mpeg_mfc51_video_force_frame_type)``
+``V4L2_CID_MPEG_MFC51_VIDEO_FORCE_FRAME_TYPE``
+    (enum)
+
+enum v4l2_mpeg_mfc51_video_force_frame_type -
     Force a frame type for the next queued buffer. Applicable to
     encoders. Possible values are:
 
@@ -2425,7 +2521,10 @@ CX2341x Control IDs
 
 .. _v4l2-mpeg-cx2341x-video-spatial-filter-mode:
 
-``V4L2_CID_MPEG_CX2341X_VIDEO_SPATIAL_FILTER_MODE (enum v4l2_mpeg_cx2341x_video_spatial_filter_mode)``
+``V4L2_CID_MPEG_CX2341X_VIDEO_SPATIAL_FILTER_MODE``
+    (enum)
+
+enum v4l2_mpeg_cx2341x_video_spatial_filter_mode -
     Sets the Spatial Filter mode (default ``MANUAL``). Possible values
     are:
 
@@ -2456,7 +2555,10 @@ CX2341x Control IDs
 
 .. _luma-spatial-filter-type:
 
-``V4L2_CID_MPEG_CX2341X_VIDEO_LUMA_SPATIAL_FILTER_TYPE (enum v4l2_mpeg_cx2341x_video_luma_spatial_filter_type)``
+``V4L2_CID_MPEG_CX2341X_VIDEO_LUMA_SPATIAL_FILTER_TYPE``
+    (enum)
+
+enum v4l2_mpeg_cx2341x_video_luma_spatial_filter_type -
     Select the algorithm to use for the Luma Spatial Filter (default
     ``1D_HOR``). Possible values:
 
@@ -2503,7 +2605,10 @@ CX2341x Control IDs
 
 .. _chroma-spatial-filter-type:
 
-``V4L2_CID_MPEG_CX2341X_VIDEO_CHROMA_SPATIAL_FILTER_TYPE (enum v4l2_mpeg_cx2341x_video_chroma_spatial_filter_type)``
+``V4L2_CID_MPEG_CX2341X_VIDEO_CHROMA_SPATIAL_FILTER_TYPE``
+    (enum)
+
+enum v4l2_mpeg_cx2341x_video_chroma_spatial_filter_type -
     Select the algorithm for the Chroma Spatial Filter (default
     ``1D_HOR``). Possible values are:
 
@@ -2530,7 +2635,10 @@ CX2341x Control IDs
 
 .. _v4l2-mpeg-cx2341x-video-temporal-filter-mode:
 
-``V4L2_CID_MPEG_CX2341X_VIDEO_TEMPORAL_FILTER_MODE (enum v4l2_mpeg_cx2341x_video_temporal_filter_mode)``
+``V4L2_CID_MPEG_CX2341X_VIDEO_TEMPORAL_FILTER_MODE``
+    (enum)
+
+enum v4l2_mpeg_cx2341x_video_temporal_filter_mode -
     Sets the Temporal Filter mode (default ``MANUAL``). Possible values
     are:
 
@@ -2561,7 +2669,10 @@ CX2341x Control IDs
 
 .. _v4l2-mpeg-cx2341x-video-median-filter-type:
 
-``V4L2_CID_MPEG_CX2341X_VIDEO_MEDIAN_FILTER_TYPE (enum v4l2_mpeg_cx2341x_video_median_filter_type)``
+``V4L2_CID_MPEG_CX2341X_VIDEO_MEDIAN_FILTER_TYPE``
+    (enum)
+
+enum v4l2_mpeg_cx2341x_video_median_filter_type -
     Median Filter Type (default ``OFF``). Possible values are:
 
 
@@ -2642,7 +2753,10 @@ VPX Control IDs
 
 .. _v4l2-vpx-num-partitions:
 
-``V4L2_CID_MPEG_VIDEO_VPX_NUM_PARTITIONS (enum v4l2_vp8_num_partitions)``
+``V4L2_CID_MPEG_VIDEO_VPX_NUM_PARTITIONS``
+    (enum)
+
+enum v4l2_vp8_num_partitions -
     The number of token partitions to use in VP8 encoder. Possible
     values are:
 
@@ -2684,7 +2798,10 @@ VPX Control IDs
 
 .. _v4l2-vpx-num-ref-frames:
 
-``V4L2_CID_MPEG_VIDEO_VPX_NUM_REF_FRAMES (enum v4l2_vp8_num_ref_frames)``
+``V4L2_CID_MPEG_VIDEO_VPX_NUM_REF_FRAMES``
+    (enum)
+
+enum v4l2_vp8_num_ref_frames -
     The number of reference pictures for encoding P frames. Possible
     values are:
 
@@ -2736,7 +2853,10 @@ VPX Control IDs
 
 .. _v4l2-vpx-golden-frame-sel:
 
-``V4L2_CID_MPEG_VIDEO_VPX_GOLDEN_FRAME_SEL (enum v4l2_vp8_golden_frame_sel)``
+``V4L2_CID_MPEG_VIDEO_VPX_GOLDEN_FRAME_SEL``
+    (enum)
+
+enum v4l2_vp8_golden_frame_sel -
     Selects the golden frame for encoding. Possible values are:
 
 .. raw:: latex
@@ -2807,7 +2927,10 @@ Camera Control IDs
 
 .. _v4l2-exposure-auto-type:
 
-``V4L2_CID_EXPOSURE_AUTO (enum v4l2_exposure_auto_type)``
+``V4L2_CID_EXPOSURE_AUTO``
+    (enum)
+
+enum v4l2_exposure_auto_type -
     Enables automatic adjustments of the exposure time and/or iris
     aperture. The effect of manual changes of the exposure time or iris
     aperture while these features are enabled is undefined, drivers
@@ -2872,7 +2995,10 @@ Camera Control IDs
 
 .. _v4l2-exposure-metering:
 
-``V4L2_CID_EXPOSURE_METERING (enum v4l2_exposure_metering)``
+``V4L2_CID_EXPOSURE_METERING``
+    (enum)
+
+enum v4l2_exposure_metering -
     Determines how the camera measures the amount of light available for
     the frame exposure. Possible values are:
 
@@ -3018,7 +3144,10 @@ Camera Control IDs
 
 .. _v4l2-auto-focus-range:
 
-``V4L2_CID_AUTO_FOCUS_RANGE (enum v4l2_auto_focus_range)``
+``V4L2_CID_AUTO_FOCUS_RANGE``
+    (enum)
+
+enum v4l2_auto_focus_range -
     Determines auto focus distance range for which lens may be adjusted.
 
 .. tabularcolumns:: |p{6.5cm}|p{11.0cm}|
@@ -3102,7 +3231,10 @@ Camera Control IDs
 
 .. _v4l2-auto-n-preset-white-balance:
 
-``V4L2_CID_AUTO_N_PRESET_WHITE_BALANCE (enum v4l2_auto_n_preset_white_balance)``
+``V4L2_CID_AUTO_N_PRESET_WHITE_BALANCE``
+    (enum)
+
+enum v4l2_auto_n_preset_white_balance -
     Sets white balance to automatic, manual or a preset. The presets
     determine color temperature of the light as a hint to the camera for
     white balance adjustments resulting in most accurate color
@@ -3218,7 +3350,10 @@ Camera Control IDs
 
 .. _v4l2-iso-sensitivity-auto-type:
 
-``V4L2_CID_ISO_SENSITIVITY_AUTO (enum v4l2_iso_sensitivity_type)``
+``V4L2_CID_ISO_SENSITIVITY_AUTO``
+    (enum)
+
+enum v4l2_iso_sensitivity_type -
     Enables or disables automatic ISO sensitivity adjustments.
 
 
@@ -3244,7 +3379,10 @@ Camera Control IDs
 
 .. _v4l2-scene-mode:
 
-``V4L2_CID_SCENE_MODE (enum v4l2_scene_mode)``
+``V4L2_CID_SCENE_MODE``
+    (enum)
+
+enum v4l2_scene_mode -
     This control allows to select scene programs as the camera automatic
     modes optimized for common shooting scenes. Within these modes the
     camera determines best exposure, aperture, focusing, light metering,
@@ -3582,7 +3720,10 @@ FM_TX Control IDs
     Configures pilot tone frequency value. Unit is in Hz. The range and
     step are driver-specific.
 
-``V4L2_CID_TUNE_PREEMPHASIS (enum v4l2_preemphasis)``
+``V4L2_CID_TUNE_PREEMPHASIS``
+    (enum)
+
+enum v4l2_preemphasis -
     Configures the pre-emphasis value for broadcasting. A pre-emphasis
     filter is applied to the broadcast to accentuate the high audio
     frequencies. Depending on the region, a time constant of either 50
@@ -4173,13 +4314,19 @@ Digital Video Control IDs
     EDIDs, then the bit for that pad will be 0. This read-only control
     is applicable to VGA, DVI-A/D, HDMI and DisplayPort connectors.
 
-``V4L2_CID_DV_TX_MODE (enum v4l2_dv_tx_mode)``
+``V4L2_CID_DV_TX_MODE``
+    (enum)
+
+enum v4l2_dv_tx_mode -
     HDMI transmitters can transmit in DVI-D mode (just video) or in HDMI
     mode (video + audio + auxiliary data). This control selects which
     mode to use: V4L2_DV_TX_MODE_DVI_D or V4L2_DV_TX_MODE_HDMI.
     This control is applicable to HDMI connectors.
 
-``V4L2_CID_DV_TX_RGB_RANGE (enum v4l2_dv_rgb_range)``
+``V4L2_CID_DV_TX_RGB_RANGE``
+    (enum)
+
+enum v4l2_dv_rgb_range -
     Select the quantization range for RGB output. V4L2_DV_RANGE_AUTO
     follows the RGB quantization range specified in the standard for the
     video interface (ie. :ref:`cea861` for HDMI).
@@ -4191,7 +4338,10 @@ Digital Video Control IDs
     the number of bits per component. This control is applicable to VGA,
     DVI-A/D, HDMI and DisplayPort connectors.
 
-``V4L2_CID_DV_TX_IT_CONTENT_TYPE (enum v4l2_dv_it_content_type)``
+``V4L2_CID_DV_TX_IT_CONTENT_TYPE``
+    (enum)
+
+enum v4l2_dv_it_content_type -
     Configures the IT Content Type of the transmitted video. This
     information is sent over HDMI and DisplayPort connectors as part of
     the AVI InfoFrame. The term 'IT Content' is used for content that
@@ -4252,7 +4402,10 @@ Digital Video Control IDs
     will be 0. This read-only control is applicable to DVI-D, HDMI and
     DisplayPort connectors.
 
-``V4L2_CID_DV_RX_RGB_RANGE (enum v4l2_dv_rgb_range)``
+``V4L2_CID_DV_RX_RGB_RANGE``
+    (enum)
+
+enum v4l2_dv_rgb_range -
     Select the quantization range for RGB input. V4L2_DV_RANGE_AUTO
     follows the RGB quantization range specified in the standard for the
     video interface (ie. :ref:`cea861` for HDMI).
@@ -4264,7 +4417,10 @@ Digital Video Control IDs
     the number of bits per component. This control is applicable to VGA,
     DVI-A/D, HDMI and DisplayPort connectors.
 
-``V4L2_CID_DV_RX_IT_CONTENT_TYPE (enum v4l2_dv_it_content_type)``
+``V4L2_CID_DV_RX_IT_CONTENT_TYPE``
+    (enum)
+
+enum v4l2_dv_it_content_type -
     Reads the IT Content Type of the received video. This information is
     sent over HDMI and DisplayPort connectors as part of the AVI
     InfoFrame. The term 'IT Content' is used for content that originates
@@ -4336,7 +4492,10 @@ FM_RX Control IDs
     broadcasts speech. If the transmitter doesn't make this distinction,
     then it will be set.
 
-``V4L2_CID_TUNE_DEEMPHASIS (enum v4l2_deemphasis)``
+``V4L2_CID_TUNE_DEEMPHASIS``
+    (enum)
+
+enum v4l2_deemphasis -
     Configures the de-emphasis value for reception. A de-emphasis filter
     is applied to the broadcast to accentuate the high audio
     frequencies. Depending on the region, a time constant of either 50
-- 
2.7.4

