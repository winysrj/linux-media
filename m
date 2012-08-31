Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:25909 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162Ab2HaNrq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Aug 2012 09:47:46 -0400
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M9M00N10GP73Y70@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 31 Aug 2012 22:47:44 +0900 (KST)
Received: from localhost.localdomain ([107.108.73.106])
 by mmp1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0M9M00K7JGWALLB0@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 31 Aug 2012 22:47:44 +0900 (KST)
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org
Cc: jtp.park@samsung.com, janghyuck.kim@samsung.com,
	jaeryul.oh@samsung.com, ch.naveen@samsung.com, arun.kk@samsung.com,
	m.szyprowski@samsung.com, k.debski@samsung.com,
	s.nawrocki@samsung.com, kmpark@infradead.org, joshi@samsung.com
Subject: [PATCH v6 2/6] [media] v4l: Add control definitions for new H264
 encoder features
Date: Fri, 31 Aug 2012 22:37:38 +0530
Message-id: <1346432862-14242-3-git-send-email-arun.kk@samsung.com>
In-reply-to: <1346432862-14242-1-git-send-email-arun.kk@samsung.com>
References: <1346432862-14242-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jeongtae Park <jtp.park@samsung.com>

New controls are added for supporting H264 encoding features like
- MVC frame packing
- Flexible macroblock ordering
- Arbitrary slice ordering
- Hierarchial coding

Signed-off-by: Jeongtae Park <jtp.park@samsung.com>
Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
---
 Documentation/DocBook/media/v4l/controls.xml |  268 +++++++++++++++++++++++++-
 drivers/media/v4l2-core/v4l2-ctrls.c         |   42 ++++
 include/linux/videodev2.h                    |   41 ++++
 3 files changed, 350 insertions(+), 1 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index 93b9c68..837ef42 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -1586,7 +1586,6 @@ frame counter of the frame that is currently displayed (decoded). This value is
 the decoder is started.</entry>
 	      </row>
 
-
 	      <row><entry></entry></row>
 	      <row>
 		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_DECODER_SLICE_INTERFACE</constant>&nbsp;</entry>
@@ -2270,6 +2269,14 @@ Applicable to the MPEG1, MPEG2, MPEG4 encoders.</entry>
 	      </row>
 
 	      <row><entry></entry></row>
+	      <row id="v4l2-mpeg-video-vbv-delay">
+		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_VBV_DELAY</constant>&nbsp;</entry>
+		<entry>integer</entry>
+	      </row><row><entry spanname="descr">Sets the initial delay in milliseconds for
+VBV buffer control.</entry>
+	      </row>
+
+	      <row><entry></entry></row>
 	      <row>
 		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_H264_CPB_SIZE</constant>&nbsp;</entry>
 		<entry>integer</entry>
@@ -2334,6 +2341,265 @@ Applicable to the MPEG4 decoder.</entry>
 	      </row><row><entry spanname="descr">vop_time_increment value for MPEG4. Applicable to the MPEG4 encoder.</entry>
 	      </row>
 
+	      <row><entry></entry></row>
+	      <row>
+		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_H264_SEI_FRAME_PACKING</constant>&nbsp;</entry>
+		<entry>boolean</entry>
+	      </row>
+	      <row><entry spanname="descr">Enable generation of frame packing supplemental enhancement information in the encoded bitstream.
+The frame packing SEI message contains the arrangement of L and R planes for 3D viewing. Applicable to the H264 encoder.</entry>
+	      </row>
+
+	      <row><entry></entry></row>
+	      <row>
+		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_H264_SEI_FP_CURRENT_FRAME_0</constant>&nbsp;</entry>
+		<entry>boolean</entry>
+	      </row>
+	      <row><entry spanname="descr">Sets current frame as frame0 in frame packing SEI.
+Applicable to the H264 encoder.</entry>
+	      </row>
+
+	      <row><entry></entry></row>
+	      <row id="v4l2-mpeg-video-h264-sei-fp-arrangement-type">
+		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_H264_SEI_FP_ARRANGEMENT_TYPE</constant>&nbsp;</entry>
+		<entry>enum&nbsp;v4l2_mpeg_video_h264_sei_fp_arrangement_type</entry>
+	      </row>
+	      <row><entry spanname="descr">Frame packing arrangement type for H264 SEI.
+Applicable to the H264 encoder.
+Possible values are:</entry>
+	      </row>
+	      <row>
+		<entrytbl spanname="descr" cols="2">
+		  <tbody valign="top">
+		    <row>
+		      <entry><constant>V4L2_MPEG_VIDEO_H264_SEI_FP_ARRANGEMENT_TYPE_CHEKERBOARD</constant>&nbsp;</entry>
+		      <entry>Pixels are alternatively from L and R.</entry>
+		    </row>
+		    <row>
+		      <entry><constant>V4L2_MPEG_VIDEO_H264_SEI_FP_ARRANGEMENT_TYPE_COLUMN</constant>&nbsp;</entry>
+		      <entry>L and R are interlaced by column.</entry>
+		    </row>
+		    <row>
+		      <entry><constant>V4L2_MPEG_VIDEO_H264_SEI_FP_ARRANGEMENT_TYPE_ROW</constant>&nbsp;</entry>
+		      <entry>L and R are interlaced by row.</entry>
+		    </row>
+		    <row>
+		      <entry><constant>V4L2_MPEG_VIDEO_H264_SEI_FP_ARRANGEMENT_TYPE_SIDE_BY_SIDE</constant>&nbsp;</entry>
+		      <entry>L is on the left, R on the right.</entry>
+		    </row>
+		    <row>
+		      <entry><constant>V4L2_MPEG_VIDEO_H264_SEI_FP_ARRANGEMENT_TYPE_TOP_BOTTOM</constant>&nbsp;</entry>
+		      <entry>L is on top, R on bottom.</entry>
+		    </row>
+		    <row>
+		      <entry><constant>V4L2_MPEG_VIDEO_H264_SEI_FP_ARRANGEMENT_TYPE_TEMPORAL</constant>&nbsp;</entry>
+		      <entry>One view per frame.</entry>
+		    </row>
+		  </tbody>
+		</entrytbl>
+	      </row>
+
+	      <row><entry></entry></row>
+	      <row>
+		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_H264_FMO</constant>&nbsp;</entry>
+		<entry>boolean</entry>
+	      </row>
+	      <row><entry spanname="descr">Enables flexible macroblock ordering in the encoded bitstream. It is a technique
+used for restructuring the ordering of macroblocks in pictures. Applicable to the H264 encoder.</entry>
+	      </row>
+
+	      <row><entry></entry></row>
+	      <row id="v4l2-mpeg-video-h264-fmo-map-type">
+		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_H264_FMO_MAP_TYPE</constant>&nbsp;</entry>
+		<entry>enum&nbsp;v4l2_mpeg_video_h264_fmo_map_type</entry>
+	      </row>
+	      <row><entry spanname="descr">When using FMO, the map type divides the image in different scan patterns of macroblocks.
+Applicable to the H264 encoder.
+Possible values are:</entry>
+	      </row>
+	      <row>
+		<entrytbl spanname="descr" cols="2">
+		  <tbody valign="top">
+		    <row>
+		      <entry><constant>V4L2_MPEG_VIDEO_H264_FMO_MAP_TYPE_INTERLEAVED_SLICES</constant>&nbsp;</entry>
+		      <entry>Slices are interleaved one after other with macroblocks in run length order.</entry>
+		    </row>
+		    <row>
+		      <entry><constant>V4L2_MPEG_VIDEO_H264_FMO_MAP_TYPE_SCATTERED_SLICES</constant>&nbsp;</entry>
+		      <entry>Scatters the macroblocks based on a mathematical function known to both encoder and decoder.</entry>
+		    </row>
+		    <row>
+		      <entry><constant>V4L2_MPEG_VIDEO_H264_FMO_MAP_TYPE_FOREGROUND_WITH_LEFT_OVER</constant>&nbsp;</entry>
+		      <entry>Macroblocks arranged in rectangular areas or regions of interest.</entry>
+		    </row>
+		    <row>
+		      <entry><constant>V4L2_MPEG_VIDEO_H264_FMO_MAP_TYPE_BOX_OUT</constant>&nbsp;</entry>
+		      <entry>Slice groups grow in a cyclic way from centre to outwards.</entry>
+		    </row>
+		    <row>
+		      <entry><constant>V4L2_MPEG_VIDEO_H264_FMO_MAP_TYPE_RASTER_SCAN</constant>&nbsp;</entry>
+		      <entry>Slice groups grow in raster scan pattern from left to right.</entry>
+		    </row>
+		    <row>
+		      <entry><constant>V4L2_MPEG_VIDEO_H264_FMO_MAP_TYPE_WIPE_SCAN</constant>&nbsp;</entry>
+		      <entry>Slice groups grow in wipe scan pattern from top to bottom.</entry>
+		    </row>
+		    <row>
+		      <entry><constant>V4L2_MPEG_VIDEO_H264_FMO_MAP_TYPE_EXPLICIT</constant>&nbsp;</entry>
+		      <entry>User defined map type.</entry>
+		    </row>
+		  </tbody>
+		</entrytbl>
+	      </row>
+
+	      <row><entry></entry></row>
+	      <row>
+		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_H264_FMO_SLICE_GROUP</constant>&nbsp;</entry>
+		<entry>integer</entry>
+	      </row>
+	      <row><entry spanname="descr">Number of slice groups in FMO.
+Applicable to the H264 encoder.</entry>
+	      </row>
+
+	      <row><entry></entry></row>
+	      <row id="v4l2-mpeg-video-h264-fmo-change-direction">
+		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_H264_FMO_CHANGE_DIRECTION</constant>&nbsp;</entry>
+		<entry>enum&nbsp;v4l2_mpeg_video_h264_fmo_change_dir</entry>
+	      </row>
+	      <row><entry spanname="descr">Specifies a direction of the slice group change for raster and wipe maps.
+Applicable to the H264 encoder.
+Possible values are:</entry>
+	      </row>
+	      <row>
+		<entrytbl spanname="descr" cols="2">
+		  <tbody valign="top">
+		    <row>
+		      <entry><constant>V4L2_MPEG_VIDEO_H264_FMO_CHANGE_DIR_RIGHT</constant>&nbsp;</entry>
+		      <entry>Raster scan or wipe right.</entry>
+		    </row>
+		    <row>
+		      <entry><constant>V4L2_MPEG_VIDEO_H264_FMO_CHANGE_DIR_LEFT</constant>&nbsp;</entry>
+		      <entry>Reverse raster scan or wipe left.</entry>
+		    </row>
+		  </tbody>
+		</entrytbl>
+	      </row>
+
+	      <row><entry></entry></row>
+	      <row>
+		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_H264_FMO_CHANGE_RATE</constant>&nbsp;</entry>
+		<entry>integer</entry>
+	      </row>
+	      <row><entry spanname="descr">Specifies the size of the first slice group for raster and wipe map.
+Applicable to the H264 encoder.</entry>
+	      </row>
+
+	      <row><entry></entry></row>
+	      <row>
+		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_H264_FMO_RUN_LENGTH</constant>&nbsp;</entry>
+		<entry>integer</entry>
+	      </row>
+	      <row><entry spanname="descr">Specifies the number of consecutive macroblocks for the interleaved map.
+Applicable to the H264 encoder.</entry>
+	      </row>
+
+	      <row><entry></entry></row>
+	      <row>
+		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_H264_ASO</constant>&nbsp;</entry>
+		<entry>boolean</entry>
+	      </row>
+	      <row><entry spanname="descr">Enables arbitrary slice ordering in encoded bitstream.
+Applicable to the H264 encoder.</entry>
+	      </row>
+
+	      <row><entry></entry></row>
+	      <row>
+		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_H264_ASO_SLICE_ORDER</constant>&nbsp;</entry>
+		<entry>integer</entry>
+	      </row><row><entry spanname="descr">Specifies the slice order in ASO. Applicable to the H264 encoder.
+The supplied 32-bit integer is interpreted as follows (bit
+0 = least significant bit):</entry>
+	      </row>
+	      <row>
+		<entrytbl spanname="descr" cols="2">
+		  <tbody valign="top">
+		    <row>
+		      <entry>Bit 0:15</entry>
+		      <entry>Slice ID</entry>
+		    </row>
+		    <row>
+		      <entry>Bit 16:32</entry>
+		      <entry>Slice position or order</entry>
+		    </row>
+		  </tbody>
+		</entrytbl>
+	      </row>
+
+	      <row><entry></entry></row>
+	      <row>
+		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_H264_HIERARCHICAL_CODING</constant>&nbsp;</entry>
+		<entry>boolean</entry>
+	      </row>
+	      <row><entry spanname="descr">Enables H264 hierarchial coding.
+Applicable to the H264 encoder.</entry>
+	      </row>
+
+	      <row><entry></entry></row>
+	      <row id="v4l2-mpeg-video-h264-hierarchial-coding-type">
+		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_H264_HIERARCHICAL_CODING_TYPE</constant>&nbsp;</entry>
+		<entry>enum&nbsp;v4l2_mpeg_video_h264_hierarchical_coding_type</entry>
+	      </row>
+	      <row><entry spanname="descr">Specifies the hierarchial coding type.
+Applicable to the H264 encoder.
+Possible values are:</entry>
+	      </row>
+	      <row>
+		<entrytbl spanname="descr" cols="2">
+		  <tbody valign="top">
+		    <row>
+		      <entry><constant>V4L2_MPEG_VIDEO_H264_HIERARCHICAL_CODING_B</constant>&nbsp;</entry>
+		      <entry>Hierarchial B coding.</entry>
+		    </row>
+		    <row>
+		      <entry><constant>V4L2_MPEG_VIDEO_H264_HIERARCHICAL_CODING_P</constant>&nbsp;</entry>
+		      <entry>Hierarchial P coding.</entry>
+		    </row>
+		  </tbody>
+		</entrytbl>
+	      </row>
+
+	      <row><entry></entry></row>
+	      <row>
+		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_H264_HIERARCHICAL_CODING_LAYER</constant>&nbsp;</entry>
+		<entry>integer</entry>
+	      </row>
+	      <row><entry spanname="descr">Specifies the number of hierarchial coding layers.
+Applicable to the H264 encoder.</entry>
+	      </row>
+
+	      <row><entry></entry></row>
+	      <row>
+		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_H264_HIERARCHICAL_CODING_LAYER_QP</constant>&nbsp;</entry>
+		<entry>integer</entry>
+	      </row><row><entry spanname="descr">Specifies a user defined QP for each layer. Applicable to the H264 encoder.
+The supplied 32-bit integer is interpreted as follows (bit
+0 = least significant bit):</entry>
+	      </row>
+	      <row>
+		<entrytbl spanname="descr" cols="2">
+		  <tbody valign="top">
+		    <row>
+		      <entry>Bit 0:15</entry>
+		      <entry>QP value</entry>
+		    </row>
+		    <row>
+		      <entry>Bit 16:32</entry>
+		      <entry>Layer number</entry>
+		    </row>
+		  </tbody>
+		</entrytbl>
+	      </row>
+
 	    </tbody>
 	  </tgroup>
 	</table>
diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index b6a2ee7..c405c36 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -384,6 +384,25 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
 		"Extended SAR",
 		NULL,
 	};
+	static const char * const h264_fp_arrangement_type[] = {
+		"Checkerboard",
+		"Column",
+		"Row",
+		"Side by side",
+		"Top Bottom",
+		"Temporal",
+		NULL,
+	};
+	static const char * const h264_fmo_map_type[] = {
+		"Interleaved Slices",
+		"Scattered Slices",
+		"Foreground With Leftover",
+		"Box Out",
+		"Raster Scan",
+		"Wipe Scan",
+		"Explicit",
+		NULL,
+	};
 	static const char * const mpeg_mpeg4_level[] = {
 		"0",
 		"0b",
@@ -496,6 +515,10 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
 		return h264_profile;
 	case V4L2_CID_MPEG_VIDEO_H264_VUI_SAR_IDC:
 		return vui_sar_idc;
+	case V4L2_CID_MPEG_VIDEO_H264_SEI_FP_ARRANGEMENT_TYPE:
+		return h264_fp_arrangement_type;
+	case V4L2_CID_MPEG_VIDEO_H264_FMO_MAP_TYPE:
+		return h264_fmo_map_type;
 	case V4L2_CID_MPEG_VIDEO_MPEG4_LEVEL:
 		return mpeg_mpeg4_level;
 	case V4L2_CID_MPEG_VIDEO_MPEG4_PROFILE:
@@ -626,6 +649,22 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_MPEG_VIDEO_H264_VUI_EXT_SAR_WIDTH:	return "Horizontal Size of SAR";
 	case V4L2_CID_MPEG_VIDEO_H264_VUI_SAR_ENABLE:		return "Aspect Ratio VUI Enable";
 	case V4L2_CID_MPEG_VIDEO_H264_VUI_SAR_IDC:		return "VUI Aspect Ratio IDC";
+	case V4L2_CID_MPEG_VIDEO_H264_SEI_FRAME_PACKING:	return "H264 Enable Frame Packing SEI";
+	case V4L2_CID_MPEG_VIDEO_H264_SEI_FP_CURRENT_FRAME_0:	return "H264 Set Current Frame as Frame0";
+	case V4L2_CID_MPEG_VIDEO_H264_SEI_FP_ARRANGEMENT_TYPE:	return "H264 Frame Packing Arrangement Type";
+	case V4L2_CID_MPEG_VIDEO_H264_FMO:			return "H264 Flexible Macroblock Ordering";
+	case V4L2_CID_MPEG_VIDEO_H264_FMO_MAP_TYPE:		return "H264 Map Type for FMO";
+	case V4L2_CID_MPEG_VIDEO_H264_FMO_SLICE_GROUP:		return "H264 FMO Number of Slice Groups";
+	case V4L2_CID_MPEG_VIDEO_H264_FMO_CHANGE_DIRECTION:	return "H264 FMO Direction of the Slice Group Change";
+	case V4L2_CID_MPEG_VIDEO_H264_FMO_CHANGE_RATE:		return "H264 FMO Size of the First Slice Group";
+	case V4L2_CID_MPEG_VIDEO_H264_FMO_RUN_LENGTH:		return "H264 FMO Number of Consecutive MBs";
+	case V4L2_CID_MPEG_VIDEO_H264_ASO:			return "H264 Arbitrary Slice Ordering";
+	case V4L2_CID_MPEG_VIDEO_H264_ASO_SLICE_ORDER:		return "H264 ASO Slice Order";
+	case V4L2_CID_MPEG_VIDEO_H264_HIERARCHICAL_CODING:	return "Enable H264 Hierarchial Coding";
+	case V4L2_CID_MPEG_VIDEO_H264_HIERARCHICAL_CODING_TYPE:	return "H264 Hierarchial Coding Type";
+	case V4L2_CID_MPEG_VIDEO_H264_HIERARCHICAL_CODING_LAYER:return "H264 Number of Hierarchial Coding Layers";
+	case V4L2_CID_MPEG_VIDEO_H264_HIERARCHICAL_CODING_LAYER_QP:
+								return "H264 Set QP Value for Hierarchial Coding Layers";
 	case V4L2_CID_MPEG_VIDEO_MPEG4_I_FRAME_QP:		return "MPEG4 I-Frame QP Value";
 	case V4L2_CID_MPEG_VIDEO_MPEG4_P_FRAME_QP:		return "MPEG4 P-Frame QP Value";
 	case V4L2_CID_MPEG_VIDEO_MPEG4_B_FRAME_QP:		return "MPEG4 B-Frame QP Value";
@@ -640,6 +679,7 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_MPEG_VIDEO_VBV_SIZE:			return "VBV Buffer Size";
 	case V4L2_CID_MPEG_VIDEO_DEC_PTS:			return "Video Decoder PTS";
 	case V4L2_CID_MPEG_VIDEO_DEC_FRAME:			return "Video Decoder Frame Count";
+	case V4L2_CID_MPEG_VIDEO_VBV_DELAY:			return "Initial Delay for VBV Buffer Control";
 
 	/* CAMERA controls */
 	/* Keep the order of the 'case's the same as in videodev2.h! */
@@ -826,6 +866,8 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_MPEG_VIDEO_H264_LOOP_FILTER_MODE:
 	case V4L2_CID_MPEG_VIDEO_H264_PROFILE:
 	case V4L2_CID_MPEG_VIDEO_H264_VUI_SAR_IDC:
+	case V4L2_CID_MPEG_VIDEO_H264_SEI_FP_ARRANGEMENT_TYPE:
+	case V4L2_CID_MPEG_VIDEO_H264_FMO_MAP_TYPE:
 	case V4L2_CID_MPEG_VIDEO_MPEG4_LEVEL:
 	case V4L2_CID_MPEG_VIDEO_MPEG4_PROFILE:
 	case V4L2_CID_JPEG_CHROMA_SUBSAMPLING:
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 1f70954..092127d 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -1598,6 +1598,7 @@ enum v4l2_mpeg_video_multi_slice_mode {
 #define V4L2_CID_MPEG_VIDEO_VBV_SIZE			(V4L2_CID_MPEG_BASE+222)
 #define V4L2_CID_MPEG_VIDEO_DEC_PTS			(V4L2_CID_MPEG_BASE+223)
 #define V4L2_CID_MPEG_VIDEO_DEC_FRAME			(V4L2_CID_MPEG_BASE+224)
+#define V4L2_CID_MPEG_VIDEO_VBV_DELAY			(V4L2_CID_MPEG_BASE+225)
 
 #define V4L2_CID_MPEG_VIDEO_H263_I_FRAME_QP		(V4L2_CID_MPEG_BASE+300)
 #define V4L2_CID_MPEG_VIDEO_H263_P_FRAME_QP		(V4L2_CID_MPEG_BASE+301)
@@ -1688,6 +1689,46 @@ enum v4l2_mpeg_video_h264_vui_sar_idc {
 	V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_2x1		= 16,
 	V4L2_MPEG_VIDEO_H264_VUI_SAR_IDC_EXTENDED	= 17,
 };
+#define V4L2_CID_MPEG_VIDEO_H264_SEI_FRAME_PACKING		(V4L2_CID_MPEG_BASE+368)
+#define V4L2_CID_MPEG_VIDEO_H264_SEI_FP_CURRENT_FRAME_0		(V4L2_CID_MPEG_BASE+369)
+#define V4L2_CID_MPEG_VIDEO_H264_SEI_FP_ARRANGEMENT_TYPE	(V4L2_CID_MPEG_BASE+370)
+enum v4l2_mpeg_video_h264_sei_fp_arrangement_type {
+	V4L2_MPEG_VIDEO_H264_SEI_FP_ARRANGEMENT_TYPE_CHEKERBOARD	= 0,
+	V4L2_MPEG_VIDEO_H264_SEI_FP_ARRANGEMENT_TYPE_COLUMN		= 1,
+	V4L2_MPEG_VIDEO_H264_SEI_FP_ARRANGEMENT_TYPE_ROW		= 2,
+	V4L2_MPEG_VIDEO_H264_SEI_FP_ARRANGEMENT_TYPE_SIDE_BY_SIDE	= 3,
+	V4L2_MPEG_VIDEO_H264_SEI_FP_ARRANGEMENT_TYPE_TOP_BOTTOM		= 4,
+	V4L2_MPEG_VIDEO_H264_SEI_FP_ARRANGEMENT_TYPE_TEMPORAL		= 5,
+};
+#define V4L2_CID_MPEG_VIDEO_H264_FMO			(V4L2_CID_MPEG_BASE+371)
+#define V4L2_CID_MPEG_VIDEO_H264_FMO_MAP_TYPE		(V4L2_CID_MPEG_BASE+372)
+enum v4l2_mpeg_video_h264_fmo_map_type {
+	V4L2_MPEG_VIDEO_H264_FMO_MAP_TYPE_INTERLEAVED_SLICES		= 0,
+	V4L2_MPEG_VIDEO_H264_FMO_MAP_TYPE_SCATTERED_SLICES		= 1,
+	V4L2_MPEG_VIDEO_H264_FMO_MAP_TYPE_FOREGROUND_WITH_LEFT_OVER	= 2,
+	V4L2_MPEG_VIDEO_H264_FMO_MAP_TYPE_BOX_OUT			= 3,
+	V4L2_MPEG_VIDEO_H264_FMO_MAP_TYPE_RASTER_SCAN			= 4,
+	V4L2_MPEG_VIDEO_H264_FMO_MAP_TYPE_WIPE_SCAN			= 5,
+	V4L2_MPEG_VIDEO_H264_FMO_MAP_TYPE_EXPLICIT			= 6,
+};
+#define V4L2_CID_MPEG_VIDEO_H264_FMO_SLICE_GROUP	(V4L2_CID_MPEG_BASE+373)
+#define V4L2_CID_MPEG_VIDEO_H264_FMO_CHANGE_DIRECTION	(V4L2_CID_MPEG_BASE+374)
+enum v4l2_mpeg_video_h264_fmo_change_dir {
+	V4L2_MPEG_VIDEO_H264_FMO_CHANGE_DIR_RIGHT	= 0,
+	V4L2_MPEG_VIDEO_H264_FMO_CHANGE_DIR_LEFT	= 1,
+};
+#define V4L2_CID_MPEG_VIDEO_H264_FMO_CHANGE_RATE	(V4L2_CID_MPEG_BASE+375)
+#define V4L2_CID_MPEG_VIDEO_H264_FMO_RUN_LENGTH		(V4L2_CID_MPEG_BASE+376)
+#define V4L2_CID_MPEG_VIDEO_H264_ASO			(V4L2_CID_MPEG_BASE+377)
+#define V4L2_CID_MPEG_VIDEO_H264_ASO_SLICE_ORDER	(V4L2_CID_MPEG_BASE+378)
+#define V4L2_CID_MPEG_VIDEO_H264_HIERARCHICAL_CODING		(V4L2_CID_MPEG_BASE+379)
+#define V4L2_CID_MPEG_VIDEO_H264_HIERARCHICAL_CODING_TYPE	(V4L2_CID_MPEG_BASE+380)
+enum v4l2_mpeg_video_h264_hierarchical_coding_type {
+	V4L2_MPEG_VIDEO_H264_HIERARCHICAL_CODING_B	= 0,
+	V4L2_MPEG_VIDEO_H264_HIERARCHICAL_CODING_P	= 1,
+};
+#define V4L2_CID_MPEG_VIDEO_H264_HIERARCHICAL_CODING_LAYER	(V4L2_CID_MPEG_BASE+381)
+#define V4L2_CID_MPEG_VIDEO_H264_HIERARCHICAL_CODING_LAYER_QP	(V4L2_CID_MPEG_BASE+382)
 #define V4L2_CID_MPEG_VIDEO_MPEG4_I_FRAME_QP	(V4L2_CID_MPEG_BASE+400)
 #define V4L2_CID_MPEG_VIDEO_MPEG4_P_FRAME_QP	(V4L2_CID_MPEG_BASE+401)
 #define V4L2_CID_MPEG_VIDEO_MPEG4_B_FRAME_QP	(V4L2_CID_MPEG_BASE+402)
-- 
1.7.0.4

