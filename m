Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:42825 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754191Ab1HBPyF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Aug 2011 11:54:05 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from eu_spt1 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LPB0068K5I4S3A0@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 02 Aug 2011 16:54:04 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LPB00HML5I3GU@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 02 Aug 2011 16:54:03 +0100 (BST)
Date: Tue, 02 Aug 2011 17:53:49 +0200
From: Kamil Debski <k.debski@samsung.com>
Subject: [PATCH v2] v4l2: Fix documentation of the codec device controls
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, k.debski@samsung.com,
	jaeryul.oh@samsung.com, rdunlap@xenotime.net, mchehab@infradead.org
Message-id: <1312300429-26777-1-git-send-email-k.debski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixed missing ids of the codec controls description in the controls.xml file.

Signed-off-by: Kamil Debski <k.debski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Reported-by: Randy Dunlap <rdunlap@xenotime.net>
---
Hi,

This patch fixes the problem with codec controls documentation reported by Randy
in the following email:
http://comments.gmane.org/gmane.linux.drivers.video-input-infrastructure/36288

The first version did not address all the errors detected - this one should
make the docs build without errors.

Thank you again for reporting these errors.

Best wishes,
Kamil Debski
---
 Documentation/DocBook/media/v4l/controls.xml |   38 +++++++++++++-------------
 1 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index 8516401..23fdf79 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -1455,7 +1455,7 @@ Applicable to the H264 encoder.</entry>
 	      </row>
 
 	      <row><entry></entry></row>
-	      <row>
+	      <row id="v4l2-mpeg-video-h264-vui-sar-idc">
 		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_H264_VUI_SAR_IDC</constant>&nbsp;</entry>
 		<entry>enum&nbsp;v4l2_mpeg_video_h264_vui_sar_idc</entry>
 	      </row>
@@ -1561,7 +1561,7 @@ Applicable to the H264 encoder.</entry>
 	      </row>
 
 	      <row><entry></entry></row>
-	      <row>
+	      <row id="v4l2-mpeg-video-h264-level">
 		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_H264_LEVEL</constant>&nbsp;</entry>
 		<entry>enum&nbsp;v4l2_mpeg_video_h264_level</entry>
 	      </row>
@@ -1641,7 +1641,7 @@ Possible values are:</entry>
 	      </row>
 
 	      <row><entry></entry></row>
-	      <row>
+	      <row id="v4l2-mpeg-video-mpeg4-level">
 		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_MPEG4_LEVEL</constant>&nbsp;</entry>
 		<entry>enum&nbsp;v4l2_mpeg_video_mpeg4_level</entry>
 	      </row>
@@ -1689,9 +1689,9 @@ Possible values are:</entry>
 	      </row>
 
 	      <row><entry></entry></row>
-	      <row>
+	      <row id="v4l2-mpeg-video-h264-profile">
 		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_H264_PROFILE</constant>&nbsp;</entry>
-		<entry>enum&nbsp;v4l2_mpeg_h264_profile</entry>
+		<entry>enum&nbsp;v4l2_mpeg_video_h264_profile</entry>
 	      </row>
 	      <row><entry spanname="descr">The profile information for H264.
 Applicable to the H264 encoder.
@@ -1774,9 +1774,9 @@ Possible values are:</entry>
 	      </row>
 
 	      <row><entry></entry></row>
-	      <row>
+	      <row id="v4l2-mpeg-video-mpeg4-profile">
 		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_MPEG4_PROFILE</constant>&nbsp;</entry>
-		<entry>enum&nbsp;v4l2_mpeg_mpeg4_profile</entry>
+		<entry>enum&nbsp;v4l2_mpeg_video_mpeg4_profile</entry>
 	      </row>
 	      <row><entry spanname="descr">The profile information for MPEG4.
 Applicable to the MPEG4 encoder.
@@ -1820,9 +1820,9 @@ Applicable to the encoder.
 	      </row>
 
 	      <row><entry></entry></row>
-	      <row>
+	      <row id="v4l2-mpeg-video-multi-slice-mode">
 		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MODE</constant>&nbsp;</entry>
-		<entry>enum&nbsp;v4l2_mpeg_multi_slice_mode</entry>
+		<entry>enum&nbsp;v4l2_mpeg_video_multi_slice_mode</entry>
 	      </row>
 	      <row><entry spanname="descr">Determines how the encoder should handle division of frame into slices.
 Applicable to the encoder.
@@ -1868,9 +1868,9 @@ Applicable to the encoder.</entry>
 	      </row>
 
 	      <row><entry></entry></row>
-	      <row>
+	      <row id="v4l2-mpeg-video-h264-loop-filter-mode">
 		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_H264_LOOP_FILTER_MODE</constant>&nbsp;</entry>
-		<entry>enum&nbsp;v4l2_mpeg_h264_loop_filter_mode</entry>
+		<entry>enum&nbsp;v4l2_mpeg_video_h264_loop_filter_mode</entry>
 	      </row>
 	      <row><entry spanname="descr">Loop filter mode for H264 encoder.
 Possible values are:</entry>
@@ -1913,9 +1913,9 @@ Applicable to the H264 encoder.</entry>
 	      </row>
 
 	      <row><entry></entry></row>
-	      <row>
+	      <row id="v4l2-mpeg-video-h264-entropy-mode">
 		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_H264_ENTROPY_MODE</constant>&nbsp;</entry>
-		<entry>enum&nbsp;v4l2_mpeg_h264_symbol_mode</entry>
+		<entry>enum&nbsp;v4l2_mpeg_video_h264_entropy_mode</entry>
 	      </row>
 	      <row><entry spanname="descr">Entropy coding mode for H264 - CABAC/CAVALC.
 Applicable to the H264 encoder.
@@ -2140,9 +2140,9 @@ previous frames. Applicable to the H264 encoder.</entry>
 	      </row>
 
 	      <row><entry></entry></row>
-	      <row>
+	      <row id="v4l2-mpeg-video-header-mode">
 		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_HEADER_MODE</constant>&nbsp;</entry>
-		<entry>enum&nbsp;v4l2_mpeg_header_mode</entry>
+		<entry>enum&nbsp;v4l2_mpeg_video_header_mode</entry>
 	      </row>
 	      <row><entry spanname="descr">Determines whether the header is returned as the first buffer or is
 it returned together with the first frame. Applicable to encoders.
@@ -2320,9 +2320,9 @@ Valid only when H.264 and macroblock level RC is enabled (<constant>V4L2_CID_MPE
 Applicable to the H264 encoder.</entry>
 	      </row>
 	      <row><entry></entry></row>
-	      <row>
+	      <row id="v4l2-mpeg-mfc51-video-frame-skip-mode">
 		<entry spanname="id"><constant>V4L2_CID_MPEG_MFC51_VIDEO_FRAME_SKIP_MODE</constant>&nbsp;</entry>
-		<entry>enum&nbsp;v4l2_mpeg_mfc51_frame_skip_mode</entry>
+		<entry>enum&nbsp;v4l2_mpeg_mfc51_video_frame_skip_mode</entry>
 	      </row>
 	      <row><entry spanname="descr">
 Indicates in what conditions the encoder should skip frames. If encoding a frame would cause the encoded stream to be larger then
@@ -2361,9 +2361,9 @@ the stream will meet tight bandwidth contraints. Applicable to encoders.
 </entry>
 	      </row>
 	      <row><entry></entry></row>
-	      <row>
+	      <row id="v4l2-mpeg-mfc51-video-force-frame-type">
 		<entry spanname="id"><constant>V4L2_CID_MPEG_MFC51_VIDEO_FORCE_FRAME_TYPE</constant>&nbsp;</entry>
-		<entry>enum&nbsp;v4l2_mpeg_mfc51_force_frame_type</entry>
+		<entry>enum&nbsp;v4l2_mpeg_mfc51_video_force_frame_type</entry>
 	      </row>
 	      <row><entry spanname="descr">Force a frame type for the next queued buffer. Applicable to encoders.
 Possible values are:</entry>
-- 
1.6.3.3

