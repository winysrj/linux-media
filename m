Return-path: <mchehab@pedra>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:16405 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755930Ab1GEL41 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Jul 2011 07:56:27 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from spt2.w1.samsung.com ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LNU00JEUZU2OY20@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 05 Jul 2011 12:56:26 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LNU00IVQZU1OC@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 05 Jul 2011 12:56:25 +0100 (BST)
Date: Tue, 05 Jul 2011 13:56:13 +0200
From: Kamil Debski <k.debski@samsung.com>
Subject: [PATCH 1/4 v10] v4l: add fourcc definitions for compressed formats.
In-reply-to: <1309866976-15113-1-git-send-email-k.debski@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	k.debski@samsung.com, jaeryul.oh@samsung.com, jtp.park@samsung.com,
	hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com
Message-id: <1309866976-15113-2-git-send-email-k.debski@samsung.com>
References: <1309866976-15113-1-git-send-email-k.debski@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Add fourcc definitions and documentation for the following
compressed formats: H263, H264, H264 without start codes,
MPEG1/2/4 ES, XVID, VC1 Annex G and Annex L compliant.

Signed-off-by: Kamil Debski <k.debski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 Documentation/DocBook/media/v4l/controls.xml |    7 +++-
 Documentation/DocBook/media/v4l/pixfmt.xml   |   47 +++++++++++++++++++++++++-
 include/linux/videodev2.h                    |   17 +++++++--
 3 files changed, 64 insertions(+), 7 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index a920ee8..6880798 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -670,7 +670,8 @@ caption of a Tab page in a GUI, for example.</entry>
 	      </row><row><entry spanname="descr">The MPEG-1, -2 or -4
 output stream type. One cannot assume anything here. Each hardware
 MPEG encoder tends to support different subsets of the available MPEG
-stream types. The currently defined stream types are:</entry>
+stream types. This control is specific to multiplexed MPEG streams.
+The currently defined stream types are:</entry>
 	      </row>
 	      <row>
 		<entrytbl spanname="descr" cols="2">
@@ -800,6 +801,7 @@ frequency. Possible values are:</entry>
 		<entry spanname="id"><constant>V4L2_CID_MPEG_AUDIO_ENCODING</constant>&nbsp;</entry>
 		<entry>enum&nbsp;v4l2_mpeg_audio_encoding</entry>
 	      </row><row><entry spanname="descr">MPEG Audio encoding.
+This control is specific to multiplexed MPEG streams.
 Possible values are:</entry>
 	      </row>
 	      <row>
@@ -1250,7 +1252,8 @@ and reproducible audio bitstream. 0 = unmuted, 1 = muted.</entry>
 		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_ENCODING</constant>&nbsp;</entry>
 		<entry>enum&nbsp;v4l2_mpeg_video_encoding</entry>
 	      </row><row><entry spanname="descr">MPEG Video encoding
-method. Possible values are:</entry>
+method. This control is specific to multiplexed MPEG streams.
+Possible values are:</entry>
 	      </row>
 	      <row>
 		<entrytbl spanname="descr" cols="2">
diff --git a/Documentation/DocBook/media/v4l/pixfmt.xml b/Documentation/DocBook/media/v4l/pixfmt.xml
index 88e5c21..c10afa0 100644
--- a/Documentation/DocBook/media/v4l/pixfmt.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt.xml
@@ -741,10 +741,55 @@ information.</para>
 	  <row id="V4L2-PIX-FMT-MPEG">
 	    <entry><constant>V4L2_PIX_FMT_MPEG</constant></entry>
 	    <entry>'MPEG'</entry>
-	    <entry>MPEG stream. The actual format is determined by
+	    <entry>MPEG multiplexed stream. The actual format is determined by
 extended control <constant>V4L2_CID_MPEG_STREAM_TYPE</constant>, see
 <xref linkend="mpeg-control-id" />.</entry>
 	  </row>
+	  <row id="V4L2-PIX-FMT-H264">
+		<entry><constant>V4L2_PIX_FMT_H264</constant></entry>
+		<entry>'H264'</entry>
+		<entry>H264 video elementary stream with start codes.</entry>
+	  </row>
+	  <row id="V4L2-PIX-FMT-H264-NO-SC">
+		<entry><constant>V4L2_PIX_FMT_H264_NO_SC</constant></entry>
+		<entry>'AVC1'</entry>
+		<entry>H264 video elementary stream without start codes.</entry>
+	  </row>
+	  <row id="V4L2-PIX-FMT-H263">
+		<entry><constant>V4L2_PIX_FMT_H263</constant></entry>
+		<entry>'H263'</entry>
+		<entry>H263 video elementary stream.</entry>
+	  </row>
+	  <row id="V4L2-PIX-FMT-MPEG1">
+		<entry><constant>V4L2_PIX_FMT_MPEG1</constant></entry>
+		<entry>'MPG1'</entry>
+		<entry>MPEG1 video elementary stream.</entry>
+	  </row>
+	  <row id="V4L2-PIX-FMT-MPEG2">
+		<entry><constant>V4L2_PIX_FMT_MPEG2</constant></entry>
+		<entry>'MPG2'</entry>
+		<entry>MPEG2 video elementary stream.</entry>
+	  </row>
+	  <row id="V4L2-PIX-FMT-MPEG4">
+		<entry><constant>V4L2_PIX_FMT_MPEG4</constant></entry>
+		<entry>'MPG4'</entry>
+		<entry>MPEG4 video elementary stream.</entry>
+	  </row>
+	  <row id="V4L2-PIX-FMT-XVID">
+		<entry><constant>V4L2_PIX_FMT_XVID</constant></entry>
+		<entry>'XVID'</entry>
+		<entry>Xvid video elementary stream.</entry>
+	  </row>
+	  <row id="V4L2-PIX-FMT-VC1-ANNEX-G">
+		<entry><constant>V4L2_PIX_FMT_VC1_ANNEX_G</constant></entry>
+		<entry>'VC1G'</entry>
+		<entry>VC1, SMPTE 421M Annex G compliant stream.</entry>
+	  </row>
+	  <row id="V4L2-PIX-FMT-VC1-ANNEX-L">
+		<entry><constant>V4L2_PIX_FMT_VC1_ANNEX_L</constant></entry>
+		<entry>'VC1L'</entry>
+		<entry>VC1, SMPTE 421M Annex L compliant stream.</entry>
+	  </row>
 	</tbody>
       </tgroup>
     </table>
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 2c4e837..f47265e 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -376,7 +376,16 @@ struct v4l2_pix_format {
 #define V4L2_PIX_FMT_MJPEG    v4l2_fourcc('M', 'J', 'P', 'G') /* Motion-JPEG   */
 #define V4L2_PIX_FMT_JPEG     v4l2_fourcc('J', 'P', 'E', 'G') /* JFIF JPEG     */
 #define V4L2_PIX_FMT_DV       v4l2_fourcc('d', 'v', 's', 'd') /* 1394          */
-#define V4L2_PIX_FMT_MPEG     v4l2_fourcc('M', 'P', 'E', 'G') /* MPEG-1/2/4    */
+#define V4L2_PIX_FMT_MPEG     v4l2_fourcc('M', 'P', 'E', 'G') /* MPEG-1/2/4 Multiplexed */
+#define V4L2_PIX_FMT_H264     v4l2_fourcc('H', '2', '6', '4') /* H264 with start codes */
+#define V4L2_PIX_FMT_H264_NO_SC v4l2_fourcc('A', 'V', 'C', '1') /* H264 without start codes */
+#define V4L2_PIX_FMT_H263     v4l2_fourcc('H', '2', '6', '3') /* H263          */
+#define V4L2_PIX_FMT_MPEG1    v4l2_fourcc('M', 'P', 'G', '1') /* MPEG-1 ES     */
+#define V4L2_PIX_FMT_MPEG2    v4l2_fourcc('M', 'P', 'G', '2') /* MPEG-2 ES     */
+#define V4L2_PIX_FMT_MPEG4    v4l2_fourcc('M', 'P', 'G', '4') /* MPEG-4 ES     */
+#define V4L2_PIX_FMT_XVID     v4l2_fourcc('X', 'V', 'I', 'D') /* Xvid           */
+#define V4L2_PIX_FMT_VC1_ANNEX_G v4l2_fourcc('V', 'C', '1', 'G') /* SMPTE 421M Annex G compliant stream */
+#define V4L2_PIX_FMT_VC1_ANNEX_L v4l2_fourcc('V', 'C', '1', 'L') /* SMPTE 421M Annex L compliant stream */
 
 /*  Vendor-specific formats   */
 #define V4L2_PIX_FMT_CPIA1    v4l2_fourcc('C', 'P', 'I', 'A') /* cpia1 YUV */
@@ -1151,7 +1160,7 @@ enum v4l2_colorfx {
 #define V4L2_CID_MPEG_BASE 			(V4L2_CTRL_CLASS_MPEG | 0x900)
 #define V4L2_CID_MPEG_CLASS 			(V4L2_CTRL_CLASS_MPEG | 1)
 
-/*  MPEG streams */
+/*  MPEG streams, specific to multiplexed streams */
 #define V4L2_CID_MPEG_STREAM_TYPE 		(V4L2_CID_MPEG_BASE+0)
 enum v4l2_mpeg_stream_type {
 	V4L2_MPEG_STREAM_TYPE_MPEG2_PS   = 0, /* MPEG-2 program stream */
@@ -1173,7 +1182,7 @@ enum v4l2_mpeg_stream_vbi_fmt {
 	V4L2_MPEG_STREAM_VBI_FMT_IVTV = 1,  /* VBI in private packets, IVTV format */
 };
 
-/*  MPEG audio */
+/*  MPEG audio controls specific to multiplexed streams  */
 #define V4L2_CID_MPEG_AUDIO_SAMPLING_FREQ 	(V4L2_CID_MPEG_BASE+100)
 enum v4l2_mpeg_audio_sampling_freq {
 	V4L2_MPEG_AUDIO_SAMPLING_FREQ_44100 = 0,
@@ -1289,7 +1298,7 @@ enum v4l2_mpeg_audio_ac3_bitrate {
 	V4L2_MPEG_AUDIO_AC3_BITRATE_640K = 18,
 };
 
-/*  MPEG video */
+/*  MPEG video controls specific to multiplexed streams */
 #define V4L2_CID_MPEG_VIDEO_ENCODING 		(V4L2_CID_MPEG_BASE+200)
 enum v4l2_mpeg_video_encoding {
 	V4L2_MPEG_VIDEO_ENCODING_MPEG_1     = 0,
-- 
1.6.3.3

