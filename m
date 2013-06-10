Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:53840 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354Ab3FJNC5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Jun 2013 09:02:57 -0400
Received: from epcpsbgr4.samsung.com
 (u144.gpu120.samsung.co.kr [203.254.230.144])
 by mailout2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MO6008ZSHKR1PP0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Mon, 10 Jun 2013 22:02:56 +0900 (KST)
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org
Cc: k.debski@samsung.com, jtp.park@samsung.com, s.nawrocki@samsung.com,
	avnd.kiran@samsung.com, arunkk.samsung@gmail.com
Subject: [PATCH 5/6] [media] V4L: Add VP8 encoder controls
Date: Mon, 10 Jun 2013 18:53:05 +0530
Message-id: <1370870586-24141-6-git-send-email-arun.kk@samsung.com>
In-reply-to: <1370870586-24141-1-git-send-email-arun.kk@samsung.com>
References: <1370870586-24141-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds new V4L controls for VP8 encoding.

Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
Signed-off-by: Kiran AVND <avnd.kiran@samsung.com>
---
 Documentation/DocBook/media/v4l/controls.xml |  145 ++++++++++++++++++++++++++
 drivers/media/v4l2-core/v4l2-ctrls.c         |   38 +++++++
 include/uapi/linux/v4l2-controls.h           |   30 +++++-
 3 files changed, 212 insertions(+), 1 deletion(-)

diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index 8d7a779..db614c7 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -4772,4 +4772,149 @@ defines possible values for de-emphasis. Here they are:</entry>
       </table>
 
       </section>
+
+    <section id="vpx-controls">
+      <title>VPX Control Reference</title>
+
+      <para>The VPX control class includes controls for encoding parameters
+      of VPx video codec.</para>
+
+      <table pgwide="1" frame="none" id="fm-rx-control-id">
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
+		      <entry>Last encoded frame and the Golden frame will be searched</entry>
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
+	      <row><entry spanname="descr">Sets the refresh period for golden frame.</entry>
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
+		      <entry>Use the previous second frame as a golden frame</entry>
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
+
 </section>
diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index fccd08b..2cf17d4 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -456,6 +456,23 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
 		"RGB full range (0-255)",
 		NULL,
 	};
+	static const char * const vpx_num_partitions[] = {
+		"1 partition",
+		"2 partitions",
+		"4 partitions",
+		"8 partitions",
+		NULL,
+	};
+	static const char * const vpx_num_ref_frames[] = {
+		"1 reference frame",
+		"2 reference frame",
+		NULL,
+	};
+	static const char * const vpx_golden_frame_sel[] = {
+		"Use previous frame",
+		"Use frame indicated by GOLDEN_FRAME_REF_PERIOD",
+		NULL,
+	};
 
 
 	switch (id) {
@@ -545,6 +562,12 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
 	case V4L2_CID_DV_TX_RGB_RANGE:
 	case V4L2_CID_DV_RX_RGB_RANGE:
 		return dv_rgb_range;
+	case V4L2_CID_VPX_NUM_PARTITIONS:
+		return vpx_num_partitions;
+	case V4L2_CID_VPX_NUM_REF_FRAMES:
+		return vpx_num_ref_frames;
+	case V4L2_CID_VPX_GOLDEN_FRAME_SEL:
+		return vpx_golden_frame_sel;
 
 	default:
 		return NULL;
@@ -806,6 +829,17 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_FM_RX_CLASS:		return "FM Radio Receiver Controls";
 	case V4L2_CID_TUNE_DEEMPHASIS:		return "De-Emphasis";
 	case V4L2_CID_RDS_RECEPTION:		return "RDS Reception";
+
+	/* VPX controls */
+	case V4L2_CID_VPX_CLASS:		return "VPX Encoder Controls";
+	case V4L2_CID_VPX_NUM_PARTITIONS:	return "VPX Number of partitions";
+	case V4L2_CID_VPX_IMD_DISABLE_4X4:	return "VPX Intra mode decision disable";
+	case V4L2_CID_VPX_NUM_REF_FRAMES:	return "VPX Number of reference pictures for P frames";
+	case V4L2_CID_VPX_FILTER_LEVEL:		return "VPX Loop filter level range";
+	case V4L2_CID_VPX_FILTER_SHARPNESS:	return "VPX Deblocking effect control";
+	case V4L2_CID_VPX_GOLDEN_FRAME_REF_PERIOD:	return "VPX Golden frame refresh period";
+	case V4L2_CID_VPX_GOLDEN_FRAME_SEL:	return "VPX Golden frame indicator";
+
 	default:
 		return NULL;
 	}
@@ -914,6 +948,9 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_DV_RX_RGB_RANGE:
 	case V4L2_CID_TEST_PATTERN:
 	case V4L2_CID_TUNE_DEEMPHASIS:
+	case V4L2_CID_VPX_NUM_PARTITIONS:
+	case V4L2_CID_VPX_NUM_REF_FRAMES:
+	case V4L2_CID_VPX_GOLDEN_FRAME_SEL:
 		*type = V4L2_CTRL_TYPE_MENU;
 		break;
 	case V4L2_CID_LINK_FREQ:
@@ -937,6 +974,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_IMAGE_PROC_CLASS:
 	case V4L2_CID_DV_CLASS:
 	case V4L2_CID_FM_RX_CLASS:
+	case V4L2_CID_VPX_CLASS:
 		*type = V4L2_CTRL_TYPE_CTRL_CLASS;
 		/* You can neither read not write these */
 		*flags |= V4L2_CTRL_FLAG_READ_ONLY | V4L2_CTRL_FLAG_WRITE_ONLY;
diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
index 69bd5bb..3d6649c 100644
--- a/include/uapi/linux/v4l2-controls.h
+++ b/include/uapi/linux/v4l2-controls.h
@@ -60,6 +60,7 @@
 #define V4L2_CTRL_CLASS_IMAGE_PROC	0x009f0000	/* Image processing controls */
 #define V4L2_CTRL_CLASS_DV		0x00a00000	/* Digital Video controls */
 #define V4L2_CTRL_CLASS_FM_RX		0x00a10000	/* Digital Video controls */
+#define V4L2_CTRL_CLASS_VPX		0x00a20000	/* VPX-compression controls */
 
 /* User-class control IDs */
 
@@ -818,7 +819,6 @@ enum v4l2_jpeg_chroma_subsampling {
 #define V4L2_CID_PIXEL_RATE			(V4L2_CID_IMAGE_PROC_CLASS_BASE + 2)
 #define V4L2_CID_TEST_PATTERN			(V4L2_CID_IMAGE_PROC_CLASS_BASE + 3)
 
-
 /*  DV-class control IDs defined by V4L2 */
 #define V4L2_CID_DV_CLASS_BASE			(V4L2_CTRL_CLASS_DV | 0x900)
 #define V4L2_CID_DV_CLASS			(V4L2_CTRL_CLASS_DV | 1)
@@ -853,4 +853,32 @@ enum v4l2_deemphasis {
 
 #define V4L2_CID_RDS_RECEPTION			(V4L2_CID_FM_RX_CLASS_BASE + 2)
 
+/* VP-class control IDs */
+
+#define V4L2_CID_VPX_BASE			(V4L2_CTRL_CLASS_VPX | 0x900)
+#define V4L2_CID_VPX_CLASS			(V4L2_CTRL_CLASS_VPX | 1)
+
+/*  VPX streams, specific to multiplexed streams */
+#define V4L2_CID_VPX_NUM_PARTITIONS		(V4L2_CID_VPX_BASE+0)
+enum v4l2_vp8_num_partitions {
+	V4L2_VPX_1_PARTITION	= 0,
+	V4L2_VPX_2_PARTITIONS	= (1 << 1),
+	V4L2_VPX_4_PARTITIONS	= (1 << 2),
+	V4L2_VPX_8_PARTITIONS	= (1 << 3),
+};
+#define V4L2_CID_VPX_IMD_DISABLE_4X4		(V4L2_CID_VPX_BASE+1)
+#define V4L2_CID_VPX_NUM_REF_FRAMES		(V4L2_CID_VPX_BASE+2)
+enum v4l2_vp8_num_ref_frames {
+	V4L2_VPX_1_REF_FRAME	= 0,
+	V4L2_VPX_2_REF_FRAME	= 1,
+};
+#define V4L2_CID_VPX_FILTER_LEVEL		(V4L2_CID_VPX_BASE+3)
+#define V4L2_CID_VPX_FILTER_SHARPNESS		(V4L2_CID_VPX_BASE+4)
+#define V4L2_CID_VPX_GOLDEN_FRAME_REF_PERIOD	(V4L2_CID_VPX_BASE+5)
+#define V4L2_CID_VPX_GOLDEN_FRAME_SEL		(V4L2_CID_VPX_BASE+6)
+enum v4l2_vp8_golden_frame_sel {
+	V4L2_VPX_GOLDEN_FRAME_USE_PREV		= 0,
+	V4L2_VPX_GOLDEN_FRAME_USE_REF_PERIOD	= 1,
+};
+
 #endif
-- 
1.7.9.5

