Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:32511 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932124Ab3FRMem (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Jun 2013 08:34:42 -0400
Received: from epcpsbgr4.samsung.com
 (u144.gpu120.samsung.co.kr [203.254.230.144])
 by mailout4.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MOL00MKF9LOHUJ0@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Tue, 18 Jun 2013 21:34:41 +0900 (KST)
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org
Cc: k.debski@samsung.com, jtp.park@samsung.com, s.nawrocki@samsung.com,
	hverkuil@xs4all.nl, avnd.kiran@samsung.com,
	arunkk.samsung@gmail.com
Subject: [PATCH v2 7/8] [media] V4L: Add VP8 encoder controls
Date: Tue, 18 Jun 2013 18:26:22 +0530
Message-id: <1371560183-23244-8-git-send-email-arun.kk@samsung.com>
In-reply-to: <1371560183-23244-1-git-send-email-arun.kk@samsung.com>
References: <1371560183-23244-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds new V4L controls for VP8 encoding.

Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
Signed-off-by: Kiran AVND <avnd.kiran@samsung.com>
---
 Documentation/DocBook/media/v4l/controls.xml |  151 ++++++++++++++++++++++++++
 drivers/media/v4l2-core/v4l2-ctrls.c         |   36 ++++++
 include/uapi/linux/v4l2-controls.h           |   28 ++++-
 3 files changed, 213 insertions(+), 2 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index 8d7a779..cd87000 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -3009,6 +3009,156 @@ in by the application. 0 = do not insert, 1 = insert packets.</entry>
 	  </tgroup>
 	</table>
       </section>
+
+    <section>
+      <title>VPX Control Reference</title>
+
+      <para>The VPX controls include controls for encoding parameters
+      of VPx video codec.</para>
+
+      <table pgwide="1" frame="none" id="vpx-control-id">
+      <title>VPX Control IDs</title>
+
+      <tgroup cols="4">
+        <colspec colname="c1" colwidth="1*" />
+        <colspec colname="c2" colwidth="6*" />
+        <colspec colname="c3" colwidth="2*" />
+        <colspec colname="c4" colwidth="6*" />
+        <spanspec namest="c1" nameend="c2" spanname="id" />
+        <spanspec namest="c2" nameend="c4" spanname="descr" />
+        <thead>
+          <row>
+            <entry spanname="id" align="left">ID</entry>
+            <entry align="left">Type</entry>
+          </row><row rowsep="1"><entry spanname="descr" align="left">Description</entry>
+          </row>
+        </thead>
+        <tbody valign="top">
+          <row><entry></entry></row>
+
+	      <row><entry></entry></row>
+	      <row id="v4l2-vpx-num-partitions">
+		<entry spanname="id"><constant>V4L2_CID_VPX_NUM_PARTITIONS</constant>&nbsp;</entry>
+		<entry>enum&nbsp;v4l2_vp8_num_partitions</entry>
+	      </row>
+	      <row><entry spanname="descr">The number of token partitions to use in VP8 encoder.
+Possible values are:</entry>
+	      </row>
+	      <row>
+		<entrytbl spanname="descr" cols="2">
+		  <tbody valign="top">
+		    <row>
+		      <entry><constant>V4L2_VPX_1_PARTITION</constant>&nbsp;</entry>
+		      <entry>1 coefficient partition</entry>
+		    </row>
+		    <row>
+		      <entry><constant>V4L2_VPX_2_PARTITIONS</constant>&nbsp;</entry>
+		      <entry>2 partitions</entry>
+		    </row>
+		    <row>
+		      <entry><constant>V4L2_VPX_4_PARTITIONS</constant>&nbsp;</entry>
+		      <entry>4 partitions</entry>
+		    </row>
+		    <row>
+		      <entry><constant>V4L2_VPX_8_PARTITIONS</constant>&nbsp;</entry>
+		      <entry>8 partitions</entry>
+	            </row>
+                  </tbody>
+		</entrytbl>
+	      </row>
+
+	      <row><entry></entry></row>
+	      <row>
+		<entry spanname="id"><constant>V4L2_CID_VPX_IMD_DISABLE_4X4</constant>&nbsp;</entry>
+		<entry>boolean</entry>
+	      </row>
+	      <row><entry spanname="descr">Setting this prevents intra 4x4 mode in the intra mode decision.</entry>
+	      </row>
+
+	      <row><entry></entry></row>
+	      <row id="v4l2-vpx-num-ref-frames">
+		<entry spanname="id"><constant>V4L2_CID_VPX_NUM_REF_FRAMES</constant>&nbsp;</entry>
+		<entry>enum&nbsp;v4l2_vp8_num_ref_frames</entry>
+	      </row>
+	      <row><entry spanname="descr">The number of reference pictures for encoding P frames.
+Possible values are:</entry>
+	      </row>
+	      <row>
+		<entrytbl spanname="descr" cols="2">
+		  <tbody valign="top">
+		    <row>
+		      <entry><constant>V4L2_VPX_1_REF_FRAME</constant>&nbsp;</entry>
+		      <entry>Last encoded frame will be searched</entry>
+		    </row>
+		    <row>
+		      <entry><constant>V4L2_VPX_2_REF_FRAME</constant>&nbsp;</entry>
+		      <entry>Two frames would be searched among last encoded frame, golden frame
+and altref frame. Encoder implementation can decide which two are chosen.</entry>
+		    </row>
+		    <row>
+		      <entry><constant>V4L2_VPX_3_REF_FRAME</constant>&nbsp;</entry>
+		      <entry>The last encoded frame, golden frame and altref frame will be searched.</entry>
+		    </row>
+                  </tbody>
+		</entrytbl>
+	      </row>
+
+	      <row><entry></entry></row>
+	      <row>
+		<entry spanname="id"><constant>V4L2_CID_VPX_FILTER_LEVEL</constant>&nbsp;</entry>
+		<entry>integer</entry>
+	      </row>
+	      <row><entry spanname="descr">Indicates the loop filter level. The adjustment of loop
+filter level is done via a delta value against a baseline loop filter value.</entry>
+	      </row>
+
+	      <row><entry></entry></row>
+	      <row>
+		<entry spanname="id"><constant>V4L2_CID_VPX_FILTER_SHARPNESS</constant>&nbsp;</entry>
+		<entry>integer</entry>
+	      </row>
+	      <row><entry spanname="descr">This parameter affects the loop filter. Anything above
+zero weakens the deblocking effect on loop filter.</entry>
+	      </row>
+
+	      <row><entry></entry></row>
+	      <row>
+		<entry spanname="id"><constant>V4L2_CID_VPX_GOLDEN_FRAME_REF_PERIOD</constant>&nbsp;</entry>
+		<entry>integer</entry>
+	      </row>
+	      <row><entry spanname="descr">Sets the refresh period for golden frame. Period is defined
+in number of frames. For a value of 'n', every nth frame will be taken as golden frame.</entry>
+	      </row>
+
+	      <row><entry></entry></row>
+	      <row id="v4l2-vpx-golden-frame-sel">
+		<entry spanname="id"><constant>V4L2_CID_VPX_GOLDEN_FRAME_SEL</constant>&nbsp;</entry>
+		<entry>enum&nbsp;v4l2_vp8_golden_frame_sel</entry>
+	      </row>
+	      <row><entry spanname="descr">Selects the golden frame for encoding.
+Possible values are:</entry>
+	      </row>
+	      <row>
+		<entrytbl spanname="descr" cols="2">
+		  <tbody valign="top">
+		    <row>
+		      <entry><constant>V4L2_VPX_GOLDEN_FRAME_USE_PREV</constant>&nbsp;</entry>
+		      <entry>Use the previous second frame (last to last frame) as a golden frame</entry>
+		    </row>
+		    <row>
+		      <entry><constant>V4L2_VPX_GOLDEN_FRAME_USE_REF_PERIOD</constant>&nbsp;</entry>
+		      <entry>Use the previous specific frame indicated by V4L2_CID_VPX_GOLDEN_FRAME_REF_PERIOD as a golden frame</entry>
+		    </row>
+                  </tbody>
+		</entrytbl>
+	      </row>
+
+          <row><entry></entry></row>
+        </tbody>
+      </tgroup>
+      </table>
+
+      </section>
     </section>
 
     <section id="camera-controls">
@@ -4772,4 +4922,5 @@ defines possible values for de-emphasis. Here they are:</entry>
       </table>
 
       </section>
+
 </section>
diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 3cb1cff..2a4413b 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -424,6 +424,12 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
 		NULL,
 	};
 
+	static const char * const vpx_golden_frame_sel[] = {
+		"Use Previous Frame",
+		"Use Frame Indicated By GOLDEN_FRAME_REF_PERIOD",
+		NULL,
+	};
+
 	static const char * const flash_led_mode[] = {
 		"Off",
 		"Flash",
@@ -538,6 +544,8 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
 		return mpeg_mpeg4_level;
 	case V4L2_CID_MPEG_VIDEO_MPEG4_PROFILE:
 		return mpeg4_profile;
+	case V4L2_CID_VPX_GOLDEN_FRAME_SEL:
+		return vpx_golden_frame_sel;
 	case V4L2_CID_JPEG_CHROMA_SUBSAMPLING:
 		return jpeg_chroma_subsampling;
 	case V4L2_CID_DV_TX_MODE:
@@ -558,7 +566,23 @@ EXPORT_SYMBOL(v4l2_ctrl_get_menu);
  */
 const s64 const *v4l2_ctrl_get_int_menu(u32 id, u32 *len)
 {
+#define V4L2_INT_MENU_RETURN(qmenu) \
+	do { *len = ARRAY_SIZE(qmenu); return qmenu; } while (0)
+
+	static const s64 const qmenu_int_vpx_num_partitions[] = {
+		1, 2, 4, 8,
+	};
+
+	static const s64 const qmenu_int_vpx_num_ref_frames[] = {
+		1, 2, 3,
+	};
+
 	switch (id) {
+	case V4L2_CID_VPX_NUM_PARTITIONS:
+		V4L2_INT_MENU_RETURN(qmenu_int_vpx_num_partitions);
+	case V4L2_CID_VPX_NUM_REF_FRAMES:
+		V4L2_INT_MENU_RETURN(qmenu_int_vpx_num_ref_frames);
+
 	default:
 		*len = 0;
 		return NULL;
@@ -714,6 +738,15 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_MPEG_VIDEO_VBV_DELAY:			return "Initial Delay for VBV Control";
 	case V4L2_CID_MPEG_VIDEO_REPEAT_SEQ_HEADER:		return "Repeat Sequence Header";
 
+	/* VPX controls */
+	case V4L2_CID_VPX_NUM_PARTITIONS:			return "VPX Number of partitions";
+	case V4L2_CID_VPX_IMD_DISABLE_4X4:			return "VPX Intra mode decision disable";
+	case V4L2_CID_VPX_NUM_REF_FRAMES:			return "VPX No. of refs for P frame";
+	case V4L2_CID_VPX_FILTER_LEVEL:				return "VPX Loop filter level range";
+	case V4L2_CID_VPX_FILTER_SHARPNESS:			return "VPX Deblocking effect control";
+	case V4L2_CID_VPX_GOLDEN_FRAME_REF_PERIOD:		return "VPX Golden frame refresh period";
+	case V4L2_CID_VPX_GOLDEN_FRAME_SEL:			return "VPX Golden frame indicator";
+
 	/* CAMERA controls */
 	/* Keep the order of the 'case's the same as in videodev2.h! */
 	case V4L2_CID_CAMERA_CLASS:		return "Camera Controls";
@@ -929,6 +962,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_DV_RX_RGB_RANGE:
 	case V4L2_CID_TEST_PATTERN:
 	case V4L2_CID_TUNE_DEEMPHASIS:
+	case V4L2_CID_VPX_GOLDEN_FRAME_SEL:
 		*type = V4L2_CTRL_TYPE_MENU;
 		break;
 	case V4L2_CID_LINK_FREQ:
@@ -940,6 +974,8 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 		break;
 	case V4L2_CID_ISO_SENSITIVITY:
 	case V4L2_CID_AUTO_EXPOSURE_BIAS:
+	case V4L2_CID_VPX_NUM_PARTITIONS:
+	case V4L2_CID_VPX_NUM_REF_FRAMES:
 		*type = V4L2_CTRL_TYPE_INTEGER_MENU;
 		break;
 	case V4L2_CID_USER_CLASS:
diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
index 69bd5bb..a1f6036 100644
--- a/include/uapi/linux/v4l2-controls.h
+++ b/include/uapi/linux/v4l2-controls.h
@@ -522,6 +522,32 @@ enum v4l2_mpeg_video_mpeg4_profile {
 };
 #define V4L2_CID_MPEG_VIDEO_MPEG4_QPEL		(V4L2_CID_MPEG_BASE+407)
 
+/*  Control IDs for VP8 streams
+ *  Though VP8 is not part of MPEG, adding it here as MPEG class is
+ *  already handling other video compression standards */
+#define V4L2_CID_VPX_NUM_PARTITIONS		(V4L2_CID_MPEG_BASE+500)
+enum v4l2_vp8_num_partitions {
+	V4L2_VPX_1_PARTITION	= 0,
+	V4L2_VPX_2_PARTITIONS	= 1,
+	V4L2_VPX_4_PARTITIONS	= 2,
+	V4L2_VPX_8_PARTITIONS	= 3,
+};
+#define V4L2_CID_VPX_IMD_DISABLE_4X4		(V4L2_CID_MPEG_BASE+501)
+#define V4L2_CID_VPX_NUM_REF_FRAMES		(V4L2_CID_MPEG_BASE+502)
+enum v4l2_vp8_num_ref_frames {
+	V4L2_VPX_1_REF_FRAME	= 0,
+	V4L2_VPX_2_REF_FRAME	= 1,
+	V4L2_VPX_3_REF_FRAME	= 2,
+};
+#define V4L2_CID_VPX_FILTER_LEVEL		(V4L2_CID_MPEG_BASE+503)
+#define V4L2_CID_VPX_FILTER_SHARPNESS		(V4L2_CID_MPEG_BASE+504)
+#define V4L2_CID_VPX_GOLDEN_FRAME_REF_PERIOD	(V4L2_CID_MPEG_BASE+505)
+#define V4L2_CID_VPX_GOLDEN_FRAME_SEL		(V4L2_CID_MPEG_BASE+506)
+enum v4l2_vp8_golden_frame_sel {
+	V4L2_VPX_GOLDEN_FRAME_USE_PREV		= 0,
+	V4L2_VPX_GOLDEN_FRAME_USE_REF_PERIOD	= 1,
+};
+
 /*  MPEG-class control IDs specific to the CX2341x driver as defined by V4L2 */
 #define V4L2_CID_MPEG_CX2341X_BASE 				(V4L2_CTRL_CLASS_MPEG | 0x1000)
 #define V4L2_CID_MPEG_CX2341X_VIDEO_SPATIAL_FILTER_MODE 	(V4L2_CID_MPEG_CX2341X_BASE+0)
@@ -590,7 +616,6 @@ enum v4l2_mpeg_mfc51_video_force_frame_type {
 #define V4L2_CID_MPEG_MFC51_VIDEO_H264_ADAPTIVE_RC_STATIC		(V4L2_CID_MPEG_MFC51_BASE+53)
 #define V4L2_CID_MPEG_MFC51_VIDEO_H264_NUM_REF_PIC_FOR_P		(V4L2_CID_MPEG_MFC51_BASE+54)
 
-
 /*  Camera class control IDs */
 
 #define V4L2_CID_CAMERA_CLASS_BASE 	(V4L2_CTRL_CLASS_CAMERA | 0x900)
@@ -818,7 +843,6 @@ enum v4l2_jpeg_chroma_subsampling {
 #define V4L2_CID_PIXEL_RATE			(V4L2_CID_IMAGE_PROC_CLASS_BASE + 2)
 #define V4L2_CID_TEST_PATTERN			(V4L2_CID_IMAGE_PROC_CLASS_BASE + 3)
 
-
 /*  DV-class control IDs defined by V4L2 */
 #define V4L2_CID_DV_CLASS_BASE			(V4L2_CTRL_CLASS_DV | 0x900)
 #define V4L2_CID_DV_CLASS			(V4L2_CTRL_CLASS_DV | 1)
-- 
1.7.9.5

