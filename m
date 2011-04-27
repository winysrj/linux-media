Return-path: <mchehab@pedra>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:62443 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932102Ab1D0LmE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Apr 2011 07:42:04 -0400
Received: from eu_spt1 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LKB00GC375WT4@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 27 Apr 2011 12:41:57 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LKB00KRX75VSJ@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 27 Apr 2011 12:41:56 +0100 (BST)
Date: Wed, 27 Apr 2011 13:41:43 +0200
From: Kamil Debski <k.debski@samsung.com>
Subject: [RFC/PATCH 2/3 v8] v4l: add control definitions for codec devices.
In-reply-to: <1303904504-11610-1-git-send-email-k.debski@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	k.debski@samsung.com, jaeryul.oh@samsung.com,
	kgene.kim@samsung.com, jtp.park@samsung.com
Message-id: <1303904504-11610-3-git-send-email-k.debski@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1303904504-11610-1-git-send-email-k.debski@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Add control definitions and documentation for codec devices and Samsung MFC 5.1
specific controls.

Signed-off-by: Kamil Debski <k.debski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 Documentation/DocBook/v4l/controls.xml |  747 ++++++++++++++++++++++++++++++++
 include/linux/videodev2.h              |  134 ++++++
 2 files changed, 881 insertions(+), 0 deletions(-)

diff --git a/Documentation/DocBook/v4l/controls.xml b/Documentation/DocBook/v4l/controls.xml
index 6880798..8d3df45 100644
--- a/Documentation/DocBook/v4l/controls.xml
+++ b/Documentation/DocBook/v4l/controls.xml
@@ -325,6 +325,20 @@ minimum value disables backlight compensation.</entry>
 <constant>V4L2_CID_ILLUMINATORS_2</constant> + 1).</entry>
 	  </row>
 	  <row>
+	    <entry><constant>V4L2_CID_MIN_REQ_BUFS_CAP</constant></entry>
+	    <entry>integer</entry>
+	    <entry>This is a read only control that can read by the application
+and used as a hint to determine the number of CAPTURE buffer to pass to REQBUFS. Using
+this value the application can request N more buffers than the minimum.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>V4L2_CID_MIN_REQ_BUFS_OUT</constant></entry>
+	    <entry>integer</entry>
+	    <entry>This is a read only control that can read by the application
+and used as a hint to determine the number of OUTPUT buffer to pass to REQBUFS. Using
+this value the application can request N more buffers than the minimum.</entry>
+	  </row>
+	  <row>
 	    <entry><constant>V4L2_CID_PRIVATE_BASE</constant></entry>
 	    <entry></entry>
 	    <entry>ID of the first custom (driver specific) control.
@@ -1409,6 +1423,739 @@ of the video. The supplied 32-bit integer is interpreted as follows (bit
 		  </tbody>
 		</entrytbl>
 	      </row>
+
+
+	      <row><entry></entry></row>
+	      <row>
+		<entry spanname="id"><constant>V4L2_CID_MPEG_DECODER_SLICE_INTERFACE</constant>&nbsp;</entry>
+		<entry>boolean</entry>
+	      </row>
+	      <row><entry spanname="descr">If enabled the decoder expects a single slice in one buffer, otherwise
+the decoder expects a single frame in one input buffer.</entry>
+	      </row>
+
+	      <row><entry></entry></row>
+	      <row>
+		<entry spanname="id"><constant>V4L2_CID_MPEG_H264_VUI_AR_ENABLE</constant>&nbsp;</entry>
+		<entry>boolean</entry>
+	      </row>
+	      <row><entry spanname="descr">Enable writing aspect ratio in the Video Usability Information.</entry>
+	      </row>
+
+	      <row><entry></entry></row>
+	      <row>
+		<entry spanname="id"><constant>V4L2_CID_MPEG_H264_VUI_AR_IDC</constant>&nbsp;</entry>
+		<entry>integer</entry>
+	      </row>
+	      <row><entry spanname="descr">VUI aspect ratio IDC for H.264 encoding. The value is defined in VUI Table
+E-1 in the standard.
+	      </entry>
+	      </row>
+
+	      <row><entry></entry></row>
+	      <row>
+		<entry spanname="id"><constant>V4L2_CID_MPEG_H264_EXT_SAR_WIDTH</constant>&nbsp;</entry>
+		<entry>integer</entry>
+	      </row>
+	      <row><entry spanname="descr">Extended sample aspect ratio width for H.264 VUI encoding.</entry>
+	      </row>
+
+	      <row><entry></entry></row>
+	      <row>
+		<entry spanname="id"><constant>V4L2_CID_MPEG_H264_EXT_SAR_HEIGHT</constant>&nbsp;</entry>
+		<entry>integer</entry>
+	      </row>
+	      <row><entry spanname="descr">Extended sample aspect ratio height for H.264 VUI encoding.</entry>
+	      </row>
+
+	      <row><entry></entry></row>
+	      <row>
+		<entry spanname="id"><constant>V4L2_CID_MPEG_LEVEL</constant>&nbsp;</entry>
+		<entry>enum&nbsp;v4l2_mpeg_level</entry>
+	      </row>
+	      <row><entry spanname="descr">The level information for stream.
+Possible values are:</entry>
+	      </row>
+	      <row>
+		<entrytbl spanname="descr" cols="2">
+		  <tbody valign="top">
+		    <row>
+		      <entry><constant>V4L2_MPEG_LEVEL_0</constant>&nbsp;</entry>
+		      <entry>Level 0</entry>
+		    </row>
+		    <row>
+		      <entry><constant>V4L2_MPEG_LEVEL_0B</constant>&nbsp;</entry>
+		      <entry>Level 0b</entry>
+		    </row>
+		    <row>
+		      <entry><constant>V4L2_MPEG_LEVEL_1</constant>&nbsp;</entry>
+		      <entry>Level 1.0</entry>
+		    </row>
+		    <row>
+		      <entry><constant>V4L2_MPEG_LEVEL_1_1</constant>&nbsp;</entry>
+		      <entry>Level 1.1</entry>
+		    </row>
+		    <row>
+		      <entry><constant>V4L2_MPEG_LEVEL_1_2</constant>&nbsp;</entry>
+		      <entry>Level 1.2</entry>
+		    </row>
+		    <row>
+		      <entry><constant>V4L2_MPEG_LEVEL_1_3</constant>&nbsp;</entry>
+		      <entry>Level 1.3</entry>
+		    </row>
+		    <row>
+		      <entry><constant>V4L2_MPEG_LEVEL_2</constant>&nbsp;</entry>
+		      <entry>Level 2.0</entry>
+		    </row>
+		    <row>
+		      <entry><constant>V4L2_MPEG_LEVEL_2_1</constant>&nbsp;</entry>
+		      <entry>Level 2.1</entry>
+		    </row>
+		    <row>
+		      <entry><constant>V4L2_MPEG_LEVEL_2_2</constant>&nbsp;</entry>
+		      <entry>Level 2.2</entry>
+		    </row>
+		    <row>
+		      <entry><constant>V4L2_MPEG_LEVEL_3</constant>&nbsp;</entry>
+		      <entry>Level 3.0</entry>
+		    </row>
+		    <row>
+		      <entry><constant>V4L2_MPEG_LEVEL_3B</constant>&nbsp;</entry>
+		      <entry>Level 3b</entry>
+		    </row>
+		    <row>
+		      <entry><constant>V4L2_MPEG_LEVEL_3_1</constant>&nbsp;</entry>
+		      <entry>Level 3.1</entry>
+		    </row>
+		    <row>
+		      <entry><constant>V4L2_MPEG_LEVEL_3_2</constant>&nbsp;</entry>
+		      <entry>Level 3.2</entry>
+		    </row>
+		    <row>
+		      <entry><constant>V4L2_MPEG_LEVEL_4</constant>&nbsp;</entry>
+		      <entry>Level 4.0</entry>
+		    </row>
+		    <row>
+		      <entry><constant>V4L2_MPEG_LEVEL_4_1</constant>&nbsp;</entry>
+		      <entry>Level 4.1</entry>
+		    </row>
+		    <row>
+		      <entry><constant>V4L2_MPEG_LEVEL_4_2</constant>&nbsp;</entry>
+		      <entry>Level 4.2</entry>
+		    </row>
+		    <row>
+		      <entry><constant>V4L2_MPEG_LEVEL_5</constant>&nbsp;</entry>
+		      <entry>Level 5.0</entry>
+		    </row>
+		    <row>
+		      <entry><constant>V4L2_MPEG_LEVEL_5_1</constant>&nbsp;</entry>
+		      <entry>Level 5.1</entry>
+		    </row>
+		  </tbody>
+		</entrytbl>
+	      </row>
+
+	      <row><entry></entry></row>
+	      <row>
+		<entry spanname="id"><constant>V4L2_CID_MPEG_H264_PROFILE</constant>&nbsp;</entry>
+		<entry>enum&nbsp;v4l2_mpeg_h264_profile</entry>
+	      </row>
+	      <row><entry spanname="descr">The profile information for H264.
+Possible values are:</entry>
+	      </row>
+	      <row>
+		<entrytbl spanname="descr" cols="2">
+		  <tbody valign="top">
+		    <row>
+		      <entry><constant>V4L2_MPEG_H264_PROFILE_BASELINE</constant>&nbsp;</entry>
+		      <entry>Baseline profile</entry>
+		    </row>
+		    <row>
+		      <entry><constant>V4L2_MPEG_H264_PROFILE_CONSTRAINED_BASELINE</constant>&nbsp;</entry>
+		      <entry>Constrained Baseline profile</entry>
+		    </row>
+		    <row>
+		      <entry><constant>V4L2_MPEG_H264_PROFILE_MAIN</constant>&nbsp;</entry>
+		      <entry>Main profile</entry>
+		    </row>
+		    <row>
+		      <entry><constant>V4L2_MPEG_H264_PROFILE_HIGH_10</constant>&nbsp;</entry>
+		      <entry>High 10 profile</entry>
+		    </row>
+		    <row>
+		      <entry><constant>V4L2_MPEG_H264_PROFILE_HIGH_422</constant>&nbsp;</entry>
+		      <entry>High 422 profile</entry>
+		    </row>
+		    <row>
+		      <entry><constant>V4L2_MPEG_H264_PROFILE_HIGH_444_PREDICTIVE</constant>&nbsp;</entry>
+		      <entry>High 444 Predictive profile</entry>
+		    </row>
+		    <row>
+		      <entry><constant>V4L2_MPEG_H264_PROFILE_HIGH_10_INTRA</constant>&nbsp;</entry>
+		      <entry>High 10 Intra profile</entry>
+		    </row>
+		    <row>
+		      <entry><constant>V4L2_MPEG_H264_PROFILE_HIGH_422_INTRA</constant>&nbsp;</entry>
+		      <entry>High 422 Intra profile</entry>
+		    </row>
+		    <row>
+		      <entry><constant>V4L2_MPEG_H264_PROFILE_HIGH_444_INTRA</constant>&nbsp;</entry>
+		      <entry>High 444 Intra profile</entry>
+		    </row>
+		    <row>
+		      <entry><constant>V4L2_MPEG_H264_PROFILE_CAVLC_444_INTRA</constant>&nbsp;</entry>
+		      <entry>CAVLC 444 Intra profile</entry>
+		    </row>
+		  </tbody>
+		</entrytbl>
+	      </row>
+
+	      <row><entry></entry></row>
+	      <row>
+		<entry spanname="id"><constant>V4L2_CID_MPEG_MPEG4_PROFILE</constant>&nbsp;</entry>
+		<entry>enum&nbsp;v4l2_mpeg_mpeg4_profile</entry>
+	      </row>
+	      <row><entry spanname="descr">The profile information for MPEG4.
+Possible values are:</entry>
+	      </row>
+	      <row>
+		<entrytbl spanname="descr" cols="2">
+		  <tbody valign="top">
+		    <row>
+		      <entry><constant>V4L2_MPEG_PROFILE_SIMPLE</constant>&nbsp;</entry>
+		      <entry>Simple profile</entry>
+		    </row>
+		    <row>
+		      <entry><constant>V4L2_MPEG_PROFILE_ADVANCED_SIMPLE</constant>&nbsp;</entry>
+		      <entry>Advanced Simple profile</entry>
+		    </row>
+		    <row>
+		      <entry><constant>V4L2_MPEG_PROFILE_CORE</constant>&nbsp;</entry>
+		      <entry>Core profile</entry>
+		    </row>
+		    <row>
+		      <entry><constant>V4L2_MPEG_PROFILE_SIMPLE_SCALABLE</constant>&nbsp;</entry>
+		      <entry>Simple Scalable profile</entry>
+		    </row>
+		    <row>
+		      <entry><constant>V4L2_MPEG_PROFILE_ADVANCED_CODING_EFFICIENCY</constant>&nbsp;</entry>
+		      <entry></entry>
+		    </row>
+		  </tbody>
+		</entrytbl>
+	      </row>
+
+	      <row><entry></entry></row>
+	      <row>
+		<entry spanname="id"><constant>V4L2_CID_MPEG_GOP_SIZE</constant>&nbsp;</entry>
+		<entry>integer</entry>
+	      </row>
+	      <row><entry spanname="descr">The size of group of pictures. For H264 this is the IDR period.</entry>
+	      </row>
+
+	      <row><entry></entry></row>
+	      <row>
+		<entry spanname="id"><constant>V4L2_CID_MPEG_B_FRAMES</constant>&nbsp;</entry>
+		<entry>integer</entry>
+	      </row>
+	      <row><entry spanname="descr">The number of B-frames to use between P frames.</entry>
+	      </row>
+
+	      <row><entry></entry></row>
+	      <row>
+		<entry spanname="id"><constant>V4L2_CID_MPEG_MAX_REF_PIC</constant>&nbsp;</entry>
+		<entry>boolean</entry>
+	      </row>
+	      <row><entry spanname="descr">The maximum number of reference pictures used for encoding.</entry>
+	      </row>
+
+	      <row><entry></entry></row>
+	      <row>
+		<entry spanname="id"><constant>V4L2_CID_MPEG_MULTI_SLICE_MODE</constant>&nbsp;</entry>
+		<entry>enum&nbsp;v4l2_mpeg_multi_slice_mode</entry>
+	      </row>
+	      <row><entry spanname="descr">Determines how multiple slices are handled.
+Possible values are:</entry>
+	      </row>
+	      <row>
+		<entrytbl spanname="descr" cols="2">
+		  <tbody valign="top">
+		    <row>
+		      <entry><constant>V4L2_MPEG_MULTI_SLICE_MODE_SINGLE</constant>&nbsp;</entry>
+		      <entry>Single slice per frame.</entry>
+		    </row>
+		    <row>
+		      <entry><constant>V4L2_MPEG_MULTI_SLICE_MODE_MAX_MB</constant>&nbsp;</entry>
+		      <entry>Multiple slices with set maximum number of macroblocks per slice.</entry>
+		    </row>
+		    <row>
+		      <entry><constant>V4L2_MPEG_MULTI_SLICE_MODE_MAX_BITS</constant>&nbsp;</entry>
+		      <entry>Multiple slice with set maximum size in bits per slice.</entry>
+		    </row>
+		  </tbody>
+		</entrytbl>
+	      </row>
+
+	      <row><entry></entry></row>
+	      <row>
+		<entry spanname="id"><constant>V4L2_CID_MPEG_MULTI_SLICE_MAX_MB</constant>&nbsp;</entry>
+		<entry>integer</entry>
+	      </row>
+	      <row><entry spanname="descr">The upper limit of macroblocks of a slice.</entry>
+	      </row>
+
+	      <row><entry></entry></row>
+	      <row>
+		<entry spanname="id"><constant>V4L2_CID_MPEG_MULTI_SLICE_MAX_BITS</constant>&nbsp;</entry>
+		<entry>integer</entry>
+	      </row>
+	      <row><entry spanname="descr">The upper limit of size in bits of a slice.</entry>
+	      </row>
+
+	      <row><entry></entry></row>
+	      <row>
+		<entry spanname="id"><constant>V4L2_CID_MPEG_H264_LOOP_FILTER_MODE</constant>&nbsp;</entry>
+		<entry>enum&nbsp;v4l2_mpeg_h264_loop_filter_mode</entry>
+	      </row>
+	      <row><entry spanname="descr">Loop filter mode for H264.
+Possible values are:</entry>
+	      </row>
+	      <row>
+		<entrytbl spanname="descr" cols="2">
+		  <tbody valign="top">
+		    <row>
+		      <entry><constant>V4L2_MPEG_H264_LOOP_FILTER_MODE_ENABLED</constant>&nbsp;</entry>
+		      <entry>Loop filter is enabled.</entry>
+		    </row>
+		    <row>
+		      <entry><constant>V4L2_MPEG_H264_LOOP_FILTER_MODE_DISABLED</constant>&nbsp;</entry>
+		      <entry>Loop filter is disabled.</entry>
+		    </row>
+		    <row>
+		      <entry><constant>V4L2_MPEG_H264_LOOP_FILTER_MODE_DISABLED_AT_SLICE_BOUNDARY</constant>&nbsp;</entry>
+		      <entry>Loop filter is disabled at the slice boundary.</entry>
+		    </row>
+		  </tbody>
+		</entrytbl>
+	      </row>
+
+	      <row><entry></entry></row>
+	      <row>
+		<entry spanname="id"><constant>V4L2_CID_MPEG_H264_LOOP_FILTER_ALPHA</constant>&nbsp;</entry>
+		<entry>integer</entry>
+	      </row>
+	      <row><entry spanname="descr">Loop filter alpha coefficient, defined in the standard.</entry>
+	      </row>
+
+	      <row><entry></entry></row>
+	      <row>
+		<entry spanname="id"><constant>V4L2_CID_MPEG_H264_LOOP_FILTER_BETA</constant>&nbsp;</entry>
+		<entry>integer</entry>
+	      </row>
+	      <row><entry spanname="descr">Loop filter alpha coefficient, defined in the standard.</entry>
+	      </row>
+
+	      <row><entry></entry></row>
+	      <row>
+		<entry spanname="id"><constant>V4L2_CID_MPEG_H264_SYMBOL_MODE</constant>&nbsp;</entry>
+		<entry>enum&nbsp;v4l2_mpeg_h264_symbol_mode</entry>
+	      </row>
+	      <row><entry spanname="descr">Symbol mode for H264 - CABAC/CAVALC.
+Possible values are:</entry>
+	      </row>
+	      <row>
+		<entrytbl spanname="descr" cols="2">
+		  <tbody valign="top">
+		    <row>
+		      <entry><constant>V4L2_MPEG_H264_SYMBOL_MODE_CAVLC</constant>&nbsp;</entry>
+		      <entry>Use CAVLC entropy coding.</entry>
+		    </row>
+		    <row>
+		      <entry><constant>V4L2_MPEG_H264_SYMBOL_MODE_CABAC</constant>&nbsp;</entry>
+		      <entry>Use CABAC entropy coding.</entry>
+		    </row>
+		  </tbody>
+		</entrytbl>
+	      </row>
+
+	      <row><entry></entry></row>
+	      <row>
+		<entry spanname="id"><constant>V4L2_CID_MPEG_INTERLACE</constant>&nbsp;</entry>
+		<entry>boolean</entry>
+	      </row>
+	      <row><entry spanname="descr">Enable interlace mode.</entry>
+	      </row>
+
+	      <row><entry></entry></row>
+	      <row>
+		<entry spanname="id"><constant>V4L2_CID_MPEG_H264_8X8_TRANSFORM</constant>&nbsp;</entry>
+		<entry>boolean</entry>
+	      </row>
+	      <row><entry spanname="descr">Enable 8X8 transform for H264.</entry>
+	      </row>
+
+	      <row><entry></entry></row>
+	      <row>
+		<entry spanname="id"><constant>V4L2_CID_MPEG_INTRA_REFRESH_MB</constant>&nbsp;</entry>
+		<entry>integer</entry>
+	      </row>
+	      <row><entry spanname="descr">Period of random intra macroblock refresh.</entry>
+	      </row>
+
+	      <row><entry></entry></row>
+	      <row>
+		<entry spanname="id"><constant>V4L2_CID_MPEG_FRAME_RC_ENABLE</constant>&nbsp;</entry>
+		<entry>boolean</entry>
+	      </row>
+	      <row><entry spanname="descr">Padding enable - use a color instead of repeating border pixels.</entry>
+	      </row>
+
+	      <row><entry></entry></row>
+	      <row>
+		<entry spanname="id"><constant>V4L2_CID_MPEG_H264_MB_RC_ENABLE</constant>&nbsp;</entry>
+		<entry>boolean</entry>
+	      </row>
+	      <row><entry spanname="descr">Macroblock level rate control enable for H264.</entry>
+	      </row>
+
+	      <row><entry></entry></row>
+	      <row>
+		<entry spanname="id"><constant>V4L2_CID_MPEG_FRAME_RATE_NOMINATOR</constant>&nbsp;</entry>
+		<entry>integer</entry>
+	      </row>
+	      <row><entry spanname="descr">Frames per second - nominator.</entry>
+	      </row>
+
+	      <row><entry></entry></row>
+	      <row>
+		<entry spanname="id"><constant>V4L2_CID_MPEG_FRAME_RATE_DENOMINATOR</constant>&nbsp;</entry>
+		<entry>integer</entry>
+	      </row>
+	      <row><entry spanname="descr">Frames per second - denominator</entry>
+	      </row>
+
+	      <row><entry></entry></row>
+	      <row>
+		<entry spanname="id"><constant>V4L2_CID_MPEG_RC_BITRATE</constant>&nbsp;</entry>
+		<entry>integer</entry>
+	      </row>
+	      <row><entry spanname="descr">Bitrate per second for rate control.</entry>
+	      </row>
+
+	      <row><entry></entry></row>
+	      <row>
+		<entry spanname="id"><constant>V4L2_CID_MPEG_MPEG4_QPEL</constant>&nbsp;</entry>
+		<entry>boolean</entry>
+	      </row>
+	      <row><entry spanname="descr">Quarter pixel motion estimation for MPEG4.</entry>
+	      </row>
+
+	      <row><entry></entry></row>
+	      <row>
+		<entry spanname="id"><constant>V4L2_CID_MPEG_I_FRAME_QP</constant>&nbsp;</entry>
+		<entry>integer</entry>
+	      </row>
+	      <row><entry spanname="descr">Quantization parameter for an I frame.</entry>
+	      </row>
+
+	      <row><entry></entry></row>
+	      <row>
+		<entry spanname="id"><constant>V4L2_CID_MPEG_MIN_QP</constant>&nbsp;</entry>
+		<entry>integer</entry>
+	      </row>
+	      <row><entry spanname="descr">Minimum quantization parameter.</entry>
+	      </row>
+
+	      <row><entry></entry></row>
+	      <row>
+		<entry spanname="id"><constant>V4L2_CID_MPEG_MAX_QP</constant>&nbsp;</entry>
+		<entry>integer</entry>
+	      </row>
+	      <row><entry spanname="descr">Maximum quantization parameter.</entry>
+	      </row>
+
+	      <row><entry></entry></row>
+	      <row>
+		<entry spanname="id"><constant>V4L2_CID_MPEG_P_FRAME_QP</constant>&nbsp;</entry>
+		<entry>integer</entry>
+	      </row>
+	      <row><entry spanname="descr">Quantization parameter for an P frame.</entry>
+	      </row>
+
+	      <row><entry></entry></row>
+	      <row>
+		<entry spanname="id"><constant>V4L2_CID_MPEG_B_FRAME_QP</constant>&nbsp;</entry>
+		<entry>integer</entry>
+	      </row>
+	      <row><entry spanname="descr">Quantization parameter for an B frame.</entry>
+	      </row>
+
+	      <row><entry></entry></row>
+	      <row>
+		<entry spanname="id"><constant>V4L2_CID_MPEG_VBV_BUF_SIZE</constant>&nbsp;</entry>
+		<entry>integer</entry>
+	      </row>
+	      <row><entry spanname="descr">Quantization parameter for an P frame.</entry>
+	      </row>
+
+	      <row><entry></entry></row>
+	      <row>
+		<entry spanname="id"><constant>V4L2_CID_MPEG_H264_OPEN_GOP</constant>&nbsp;</entry>
+		<entry>boolean</entry>
+	      </row>
+	      <row><entry spanname="descr">Enable open GOP in H264.</entry>
+	      </row>
+
+	      <row><entry></entry></row>
+	      <row>
+		<entry spanname="id"><constant>V4L2_CID_MPEG_H264_I_PERIOD</constant>&nbsp;</entry>
+		<entry>integer</entry>
+	      </row>
+	      <row><entry spanname="descr">Period between I frames in open GOP for H264.</entry>
+	      </row>
+
+	      <row><entry></entry></row>
+	      <row>
+		<entry spanname="id"><constant>V4L2_CID_MPEG_HEADER_MODE</constant>&nbsp;</entry>
+		<entry>enum&nbsp;v4l2_mpeg_header_mode</entry>
+	      </row>
+	      <row><entry spanname="descr">Determines whether the header is returned as the first buffer or is
+it returned together with the first frame.
+Possible values are:</entry>
+	      </row>
+	      <row>
+		<entrytbl spanname="descr" cols="2">
+		  <tbody valign="top">
+		    <row>
+		      <entry><constant>V4L2_MPEG_HEADER_MODE_SEPARATE</constant>&nbsp;</entry>
+		      <entry>The stream header is returned separately in the first buffer.</entry>
+		    </row>
+		    <row>
+		      <entry><constant>V4L2_MPEG_HEADER_MODE_JOINED_WITH_1ST_FRAME</constant>&nbsp;</entry>
+		      <entry>The stream header is returned together with the first encoded frame.</entry>
+		    </row>
+		  </tbody>
+		</entrytbl>
+	      </row>
+
+	      <row><entry></entry></row>
+	      <row>
+		<entry spanname="id"><constant>V4L2_CID_MPEG_FRAME_RC_ENABLE</constant>&nbsp;</entry>
+		<entry>boolean</entry>
+	      </row>
+	      <row><entry spanname="descr">Frame level rate control enable.</entry>
+	      </row>
+
+	      <row><entry></entry></row>
+	      <row>
+		<entry spanname="id"><constant>V4L2_CID_MPEG_H264_MB_RC_ENABLE</constant>&nbsp;</entry>
+		<entry>boolean</entry>
+	      </row>
+	      <row><entry spanname="descr">Macroblock level rate control enable.</entry>
+	      </row>
+
+	    </tbody>
+	  </tgroup>
+	</table>
+      </section>
+
+      <section>
+	<title>MFC 5.1 MPEG Controls</title>
+
+	<para>The following MPEG class controls deal with MPEG
+decoding and encoding settings that are specific to the MFC 5.1 device present
+in the S5P family of SoCs by Samsung.
+</para>
+
+	<table pgwide="1" frame="none" id="mfc51-control-id">
+	  <title>MFC 5.1 Control IDs</title>
+	  <tgroup cols="4">
+	    <colspec colname="c1" colwidth="1*" />
+	    <colspec colname="c2" colwidth="6*" />
+	    <colspec colname="c3" colwidth="2*" />
+	    <colspec colname="c4" colwidth="6*" />
+	    <spanspec namest="c1" nameend="c2" spanname="id" />
+	    <spanspec namest="c2" nameend="c4" spanname="descr" />
+	    <thead>
+	      <row>
+		<entry spanname="id" align="left">ID</entry>
+		<entry align="left">Type</entry>
+	      </row><row><entry spanname="descr" align="left">Description</entry>
+	      </row>
+	    </thead>
+	    <tbody valign="top">
+	      <row><entry></entry></row>
+	      <row>
+		<entry spanname="id"><constant>V4L2_CID_MPEG_MFC51_DECODER_MPEG4_DEBLOCK_FILTER</constant>&nbsp;</entry>
+		<entry>boolean</entry>
+	      </row><row><entry spanname="descr">Enabled the deblocking post processing filter for MPEG4 decoder.</entry>
+	      </row>
+	      <row><entry></entry></row>
+	      <row>
+		<entry spanname="id"><constant>V4L2_CID_MPEG_MFC51_DECODER_H264_DISPLAY_DELAY_ENABLE</constant>&nbsp;</entry>
+		<entry>integer</entry>
+	      </row><row><entry spanname="descr">If the display delay is enabled then the decoder has to return an
+CAPTURE buffer after processing a certain number of OUTPUT buffers. If this number is low, then it may result in
+buffers not being dequeued in display order. In addition hardware may still use those buffers as reference, thus
+application should not write to those buffers. This feature can be used for example for generating thumbnails of videos.
+	      </entry>
+	      </row>
+	      <row><entry></entry></row>
+	      <row>
+		<entry spanname="id"><constant>V4L2_CID_MPEG_MFC51_DECODER_H264_DISPLAY_DELAY</constant>&nbsp;</entry>
+		<entry>integer</entry>
+	      </row><row><entry spanname="descr">Display delay value for H264 decoder.</entry>
+	      </row>
+	      <row><entry></entry></row>
+	      <row>
+		<entry spanname="id"><constant>V4L2_CID_MPEG_MFC51_NUM_REF_PIC_FOR_P</constant>&nbsp;</entry>
+		<entry>integer</entry>
+	      </row><row><entry spanname="descr">The number of reference pictures used for encoding a P picture.</entry>
+	      </row>
+	      <row><entry></entry></row>
+	      <row>
+		<entry spanname="id"><constant>V;4L2_CID_MPEG_MFC51_PADDING</constant>&nbsp;</entry>
+		<entry>integer</entry>
+	      </row><row><entry spanname="descr">Padding enable - use a color instead of repeating border pixels.</entry>
+	      </row>
+	      <row><entry></entry></row>
+	      <row>
+		<entry spanname="id"><constant>V4L2_CID_MPEG_MFC51_PADDING_YUV</constant>&nbsp;</entry>
+		<entry>integer</entry>
+	      </row><row><entry spanname="descr">Padding color. The supplied 32-bit integer is interpreted as follows (bit
+0 = least significant bit):</entry>
+	      </row>
+	      <row>
+		<entrytbl spanname="descr" cols="2">
+		  <tbody valign="top">
+		    <row>
+		      <entry>Bit 0:7</entry>
+		      <entry>V chrominance information</entry>
+		    </row>
+		    <row>
+		      <entry>Bit 8:15</entry>
+		      <entry>U chrominance information</entry>
+		    </row>
+		    <row>
+		      <entry>Bit 16:23</entry>
+		      <entry>Y luminance information</entry>
+		    </row>
+		    <row>
+		      <entry>Bit 24:31</entry>
+		      <entry>Must be zero.</entry>
+		    </row>
+		  </tbody>
+		</entrytbl>
+	      </row>
+	      <row><entry></entry></row>
+	      <row>
+		<entry spanname="id"><constant>V4L2_CID_MPEG_MFC51_RC_REACTION_COEFF</constant>&nbsp;</entry>
+		<entry>integer</entry>
+	      </row><row><entry spanname="descr">Reaction coefficient for MFC rate control.</entry>
+	      </row>
+	      <row><entry></entry></row>
+	      <row>
+		<entry spanname="id"><constant>V4L2_CID_MPEG_MFC51_H264_ADAPTIVE_RC_DARK</constant>&nbsp;</entry>
+		<entry>integer</entry>
+	      </row><row><entry spanname="descr">Adaptive rate control for dark region.</entry>
+	      </row>
+	      <row><entry></entry></row>
+	      <row>
+		<entry spanname="id"><constant>V4L2_CID_MPEG_MFC51_H264_ADAPTIVE_RC_SMOOTH</constant>&nbsp;</entry>
+		<entry>integer</entry>
+	      </row><row><entry spanname="descr">Adaptive rate control for smooth region.</entry>
+	      </row>
+	      <row><entry></entry></row>
+	      <row>
+		<entry spanname="id"><constant>V4L2_CID_MPEG_MFC51_H264_ADAPTIVE_RC_STATIC</constant>&nbsp;</entry>
+		<entry>integer</entry>
+	      </row><row><entry spanname="descr">Adaptive rate control for static region.</entry>
+	      </row>
+	      <row><entry></entry></row>
+	      <row>
+		<entry spanname="id"><constant>V4L2_CID_MPEG_MFC51_H264_ADAPTIVE_RC_ACTIVITY</constant>&nbsp;</entry>
+		<entry>integer</entry>
+	      </row><row><entry spanname="descr">Adaptive rate control for activity region.</entry>
+	      </row>
+	      <row><entry></entry></row>
+	      <row>
+		<entry spanname="id"><constant>V4L2_CID_MPEG_MFC51_FRAME_SKIP_MODE</constant>&nbsp;</entry>
+		<entry>enum&nbsp;v4l2_mpeg_mfc51_frame_skip_mode</entry>
+	      </row>
+	      <row><entry spanname="descr">
+Possible values are:</entry>
+	      </row>
+	      <row>
+		<entrytbl spanname="descr" cols="2">
+		  <tbody valign="top">
+		    <row>
+		      <entry><constant>V4L2_MPEG_MFC51_FRAME_SKIP_MODE_DISABLED</constant>&nbsp;</entry>
+		      <entry>Frame skip mode is disabled.</entry>
+		    </row>
+		    <row>
+		      <entry><constant>V4L2_MPEG_MFC51_FRAME_SKIP_MODE_LEVEL_LIMIT</constant>&nbsp;</entry>
+		      <entry>Frame skip mode enabled and buffer limit is set by the chosen level.</entry>
+		    </row>
+		    <row>
+		      <entry><constant>V4L2_MPEG_MFC51_FRAME_SKIP_MODE_VBV_LIMIT</constant>&nbsp;</entry>
+		      <entry>Frame skip mode enabled and buffer limit is set by the VBV buffer size control.</entry>
+		    </row>
+		  </tbody>
+		</entrytbl>
+	      </row>
+	      <row><entry></entry></row>
+	      <row>
+		<entry spanname="id"><constant>V4L2_CID_MPEG_MFC51_RC_FIXED_TARGET_BIT</constant>&nbsp;</entry>
+		<entry>integer</entry>
+	      </row><row><entry spanname="descr"></entry>
+	      </row>
+	      <row><entry></entry></row>
+	      <row>
+		<entry spanname="id"><constant>V4L2_CID_MPEG_MFC51_MPEG4_VOP_TIME_RES</constant>&nbsp;</entry>
+		<entry>integer</entry>
+	      </row><row><entry spanname="descr">Used to compute vop_time_increment and modulo_time_base in MPEG4.</entry>
+	      </row>
+	      <row><entry></entry></row>
+	      <row>
+		<entry spanname="id"><constant>V4L2_CID_MPEG_MFC51_MPEG4_VOP_FRAME_DELTA</constant>&nbsp;</entry>
+		<entry>integer</entry>
+	      </row><row><entry spanname="descr">Used to compute vop_time_increment and modulo_time_base in MPEG4.</entry>
+	      </row>
+	      <row><entry></entry></row>
+	      <row>
+		<entry spanname="id"><constant>V4L2_CID_MPEG_MFC51_FORCE_FRAME_TYPE</constant>&nbsp;</entry>
+		<entry>enum&nbsp;v4l2_mpeg_mfc51_force_frame_type</entry>
+	      </row>
+	      <row><entry spanname="descr">Force a frame type for the next queued buffer.
+Possible values are:</entry>
+	      </row>
+	      <row>
+		<entrytbl spanname="descr" cols="2">
+		  <tbody valign="top">
+		    <row>
+		      <entry><constant>V4L2_MPEG_MFC51_FORCE_FRAME_TYPE_DISABLED</constant>&nbsp;</entry>
+		      <entry>Forcing a specific frame type disabled.</entry>
+		    </row>
+		    <row>
+		      <entry><constant>V4L2_MPEG_MFC51_FORCE_FRAME_TYPE_I_FRAME</constant>&nbsp;</entry>
+		      <entry>Force an I-frame.</entry>
+		    </row>
+		    <row>
+		      <entry><constant>V4L2_MPEG_MFC51_FORCE_FRAME_TYPE_NOT_CODED</constant>&nbsp;</entry>
+		      <entry>Force a non-coded frame.</entry>
+		    </row>
+		  </tbody>
+		</entrytbl>
+	      </row>
+	      <row><entry></entry></row>
+	      <row>
+		<entry spanname="id"><constant>V4L2_CID_MPEG_MFC51_FRAME_TAG</constant>&nbsp;</entry>
+		<entry>integer</entry>
+	      </row><row><entry spanname="descr">Frame tag is assigned to an input buffer passed to hardware, and
+the same frame tag is then assigned to the buffer that contains the
+result of processing that frame.
+	      </entry>
+	      </row>
 	    </tbody>
 	  </tgroup>
 	</table>
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index c30981b..9394b59 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -1155,6 +1155,10 @@ enum v4l2_colorfx {
 /* last CID + 1 */
 #define V4L2_CID_LASTP1                         (V4L2_CID_BASE+39)
 
+/* Minimum number of buffer neede by the device */
+#define V4L2_CID_MIN_REQ_BUFS_CAP		(V4L2_CID_BASE+40)
+#define V4L2_CID_MIN_REQ_BUFS_OUT		(V4L2_CID_BASE+41)
+
 /*  MPEG-class control IDs defined by V4L2 */
 #define V4L2_CID_MPEG_BASE 			(V4L2_CTRL_CLASS_MPEG | 0x900)
 #define V4L2_CID_MPEG_CLASS 			(V4L2_CTRL_CLASS_MPEG | 1)
@@ -1326,6 +1330,105 @@ enum v4l2_mpeg_video_bitrate_mode {
 #define V4L2_CID_MPEG_VIDEO_MUTE 		(V4L2_CID_MPEG_BASE+210)
 #define V4L2_CID_MPEG_VIDEO_MUTE_YUV 		(V4L2_CID_MPEG_BASE+211)
 
+#define V4L2_CID_MPEG_DECODER_SLICE_INTERFACE	(V4L2_CID_MPEG_BASE+212)
+#define V4L2_CID_MPEG_H264_VUI_AR_ENABLE	(V4L2_CID_MPEG_BASE+213)
+#define V4L2_CID_MPEG_H264_VUI_AR_IDC		(V4L2_CID_MPEG_BASE+214)
+#define V4L2_CID_MPEG_H264_EXT_SAR_WIDTH	(V4L2_CID_MPEG_BASE+215)
+#define V4L2_CID_MPEG_H264_EXT_SAR_HEIGHT	(V4L2_CID_MPEG_BASE+216)
+#define V4L2_CID_MPEG_LEVEL			(V4L2_CID_MPEG_BASE+217)
+enum v4l2_mpeg_level {
+	V4L2_MPEG_LEVEL_0	= 0,
+	V4L2_MPEG_LEVEL_0B	= 1,
+	V4L2_MPEG_LEVEL_1	= 2,
+	V4L2_MPEG_LEVEL_1B	= 3,
+	V4L2_MPEG_LEVEL_1_1	= 4,
+	V4L2_MPEG_LEVEL_1_2	= 5,
+	V4L2_MPEG_LEVEL_1_3	= 6,
+	V4L2_MPEG_LEVEL_2	= 7,
+	V4L2_MPEG_LEVEL_2_1	= 8,
+	V4L2_MPEG_LEVEL_2_2	= 9,
+	V4L2_MPEG_LEVEL_3	= 10,
+	V4L2_MPEG_LEVEL_3B	= 11,
+	V4L2_MPEG_LEVEL_3_1	= 12,
+	V4L2_MPEG_LEVEL_3_2	= 13,
+	V4L2_MPEG_LEVEL_4	= 14,
+	V4L2_MPEG_LEVEL_4_1	= 15,
+	V4L2_MPEG_LEVEL_4_2	= 16,
+	V4L2_MPEG_LEVEL_5	= 17,
+	V4L2_MPEG_LEVEL_5_1	= 18,
+};
+#define V4L2_CID_MPEG_H264_PROFILE		(V4L2_CID_MPEG_BASE+218)
+enum v4l2_mpeg_h264_profile {
+	V4L2_MPEG_H264_PROFILE_BASELINE			= 0,
+	V4L2_MPEG_H264_PROFILE_CONSTRAINED_BASELINE	= 1,
+	V4L2_MPEG_H264_PROFILE_MAIN			= 2,
+	V4L2_MPEG_H264_PROFILE_EXTENDED			= 3,
+	V4L2_MPEG_H264_PROFILE_HIGH			= 4,
+	V4L2_MPEG_H264_PROFILE_HIGH_10			= 5,
+	V4L2_MPEG_H264_PROFILE_HIGH_422			= 6,
+	V4L2_MPEG_H264_PROFILE_HIGH_444_PREDICTIVE	= 7,
+	V4L2_MPEG_H264_PROFILE_HIGH_10_INTRA		= 8,
+	V4L2_MPEG_H264_PROFILE_HIGH_422_INTRA		= 9,
+	V4L2_MPEG_H264_PROFILE_HIGH_444_INTRA		= 10,
+	V4L2_MPEG_H264_PROFILE_CAVLC_444_INTRA		= 11,
+};
+#define V4L2_CID_MPEG_MPEG4_PROFILE		(V4L2_CID_MPEG_BASE+219)
+enum v4l2_mpeg_mpeg4_profile {
+	V4L2_MPEG_MPEG4_PROFILE_SIMPLE				= 0,
+	V4L2_MPEG_MPEG4_PROFILE_ADVANCED_SIMPLE			= 1,
+	V4L2_MPEG_MPEG4_PROFILE_CORE				= 2,
+	V4L2_MPEG_MPEG4_PROFILE_SIMPLE_SCALABLE			= 3,
+	V4L2_MPEG_MPEG4_PROFILE_ADVANCED_CODING_EFFICIENCY	= 4,
+};
+#define V4L2_CID_MPEG_GOP_SIZE			(V4L2_CID_MPEG_BASE+220)
+#define V4L2_CID_MPEG_B_FRAMES			(V4L2_CID_MPEG_BASE+221)
+#define V4L2_CID_MPEG_MAX_REF_PIC		(V4L2_CID_MPEG_BASE+222)
+#define V4L2_CID_MPEG_MULTI_SLICE_MODE		(V4L2_CID_MPEG_BASE+223)
+enum v4l2_mpeg_multi_slice_mode {
+	V4L2_MPEG_MULTI_SLICE_MODE_SINGLE	= 0,
+	V4L2_MPEG_MULTI_SICE_MODE_MAX_MB	= 1,
+	V4L2_MPEG_MULTI_SICE_MODE_MAX_BITS	= 2,
+};
+#define V4L2_CID_MPEG_MULTI_SLICE_MAX_MB	(V4L2_CID_MPEG_BASE+224)
+#define V4L2_CID_MPEG_MULTI_SLICE_MAX_BITS	(V4L2_CID_MPEG_BASE+225)
+#define V4L2_CID_MPEG_H264_LOOP_FILTER_MODE	(V4L2_CID_MPEG_BASE+226)
+enum v4l2_mpeg_h264_loop_filter_mode {
+	V4L2_MPEG_H264_LOOP_FILTER_MODE_ENABLED				= 0,
+	V4L2_MPEG_H264_LOOP_FILTER_MODE_DISABLED			= 1,
+	V4L2_MPEG_H264_LOOP_FILTER_MODE_DISABLED_AT_SLICE_BOUNDARY	= 2,
+};
+#define V4L2_CID_MPEG_H264_LOOP_FILTER_ALPHA	(V4L2_CID_MPEG_BASE+227)
+#define V4L2_CID_MPEG_H264_LOOP_FILTER_BETA	(V4L2_CID_MPEG_BASE+228)
+#define V4L2_CID_MPEG_H264_SYMBOL_MODE		(V4L2_CID_MPEG_BASE+229)
+enum v4l2_mpeg_h264_symbol_mode {
+	V4L2_MPEG_H264_SYMBOL_MODE_CAVLC	= 0,
+	V4L2_MPEG_H264_SYMBOL_MODE_CABAC	= 1,
+};
+
+#define V4L2_CID_MPEG_INTERLACE			(V4L2_CID_MPEG_BASE+230)
+#define V4L2_CID_MPEG_H264_8X8_TRANSFORM	(V4L2_CID_MPEG_BASE+231)
+#define V4L2_CID_MPEG_INTRA_REFRESH_MB		(V4L2_CID_MPEG_BASE+232)
+#define V4L2_CID_MPEG_FRAME_RC_ENABLE		(V4L2_CID_MPEG_BASE+233)
+#define V4L2_CID_MPEG_H264_MB_RC_ENABLE		(V4L2_CID_MPEG_BASE+234)
+#define V4L2_CID_MPEG_FRAME_RATE_NOMINATOR	(V4L2_CID_MPEG_BASE+235)
+#define V4L2_CID_MPEG_FRAME_RATE_DENOMINATOR	(V4L2_CID_MPEG_BASE+236)
+#define V4L2_CID_MPEG_RC_BITRATE		(V4L2_CID_MPEG_BASE+237)
+#define V4L2_CID_MPEG_MPEG4_QPEL		(V4L2_CID_MPEG_BASE+238)
+#define V4L2_CID_MPEG_I_FRAME_QP		(V4L2_CID_MPEG_BASE+239)
+#define V4L2_CID_MPEG_MIN_QP			(V4L2_CID_MPEG_BASE+240)
+#define V4L2_CID_MPEG_MAX_QP			(V4L2_CID_MPEG_BASE+241)
+#define V4L2_CID_MPEG_P_FRAME_QP		(V4L2_CID_MPEG_BASE+242)
+#define V4L2_CID_MPEG_B_FRAME_QP		(V4L2_CID_MPEG_BASE+243)
+#define V4L2_CID_MPEG_VBV_BUF_SIZE		(V4L2_CID_MPEG_BASE+244)
+#define V4L2_CID_MPEG_H264_OPEN_GOP		(V4L2_CID_MPEG_BASE+245)
+#define V4L2_CID_MPEG_H264_I_PERIOD		(V4L2_CID_MPEG_BASE+246)
+#define V4L2_CID_MPEG_HEADER_MODE		(V4L2_CID_MPEG_BASE+247)
+enum v4l2_mpeg_header_mode {
+	V4L2_MPEG_HEADER_MODE_SEPARATE			= 0,
+	V4L2_MPEG_HEADER_MODE_JOINED_WITH_1ST_FRAME	= 1,
+
+};
+
 /*  MPEG-class control IDs specific to the CX2341x driver as defined by V4L2 */
 #define V4L2_CID_MPEG_CX2341X_BASE 				(V4L2_CTRL_CLASS_MPEG | 0x1000)
 #define V4L2_CID_MPEG_CX2341X_VIDEO_SPATIAL_FILTER_MODE 	(V4L2_CID_MPEG_CX2341X_BASE+0)
@@ -1367,6 +1470,37 @@ enum v4l2_mpeg_cx2341x_video_median_filter_type {
 #define V4L2_CID_MPEG_CX2341X_VIDEO_CHROMA_MEDIAN_FILTER_TOP 	(V4L2_CID_MPEG_CX2341X_BASE+10)
 #define V4L2_CID_MPEG_CX2341X_STREAM_INSERT_NAV_PACKETS 	(V4L2_CID_MPEG_CX2341X_BASE+11)
 
+/*  MPEG-class control IDs specific to the Samsung MFC 5.1 driver as defined by V4L2 */
+#define V4L2_CID_MPEG_MFC51_BASE 			(V4L2_CTRL_CLASS_MPEG | 0x1000)
+
+#define V4L2_CID_MPEG_MFC51_DECODER_MPEG4_DEBLOCK_FILTER	(V4L2_CID_MPEG_MFC51_BASE+0)
+#define V4L2_CID_MPEG_MFC51_DECODER_H264_DISPLAY_DELAY		(V4L2_CID_MPEG_MFC51_BASE+1)
+#define V4L2_CID_MPEG_MFC51_DECODER_H264_DISPLAY_DELAY_ENABLE	(V4L2_CID_MPEG_MFC51_BASE+2)
+#define V4L2_CID_MPEG_MFC51_NUM_REF_PIC_FOR_P			(V4L2_CID_MPEG_MFC51_BASE+3)
+#define V4L2_CID_MPEG_MFC51_PADDING				(V4L2_CID_MPEG_MFC51_BASE+4)
+#define V4L2_CID_MPEG_MFC51_PADDING_YUV				(V4L2_CID_MPEG_MFC51_BASE+5)
+#define V4L2_CID_MPEG_MFC51_RC_REACTION_COEFF			(V4L2_CID_MPEG_MFC51_BASE+8)
+#define V4L2_CID_MPEG_MFC51_H264_ADAPTIVE_RC_DARK		(V4L2_CID_MPEG_MFC51_BASE+9)
+#define V4L2_CID_MPEG_MFC51_H264_ADAPTIVE_RC_SMOOTH		(V4L2_CID_MPEG_MFC51_BASE+10)
+#define V4L2_CID_MPEG_MFC51_H264_ADAPTIVE_RC_STATIC		(V4L2_CID_MPEG_MFC51_BASE+11)
+#define V4L2_CID_MPEG_MFC51_H264_ADAPTIVE_RC_ACTIVITY		(V4L2_CID_MPEG_MFC51_BASE+12)
+#define V4L2_CID_MPEG_MFC51_FRAME_SKIP_MODE			(V4L2_CID_MPEG_MFC51_BASE+13)
+enum v4l2_mpeg_mfc51_frame_skip_mode {
+	V4L2_MPEG_MFC51_FRAME_SKIP_MODE_DISABLED	= 0,
+	V4L2_MPEG_MFC51_FRAME_SKIP_MODE_LEVEL_LIMIT	= 1,
+	V4L2_MPEG_MFC51_FRAME_SKIP_MODE_VBV_LIMIT	= 2,
+};
+#define V4L2_CID_MPEG_MFC51_RC_FIXED_TARGET_BIT			(V4L2_CID_MPEG_MFC51_BASE+14)
+#define V4L2_CID_MPEG_MFC51_MPEG4_VOP_TIME_RES			(V4L2_CID_MPEG_MFC51_BASE+15)
+#define V4L2_CID_MPEG_MFC51_MPEG4_VOP_FRAME_DELTA		(V4L2_CID_MPEG_MFC51_BASE+16)
+#define V4L2_CID_MPEG_MFC51_FORCE_FRAME_TYPE			(V4L2_CID_MPEG_MFC51_BASE+17)
+enum v4l2_mpeg_mfc51_force_frame_type {
+	V4L2_MPEG_MFC51_FORCE_FRAME_TYPE_DISABLED	= 0,
+	V4L2_MPEG_MFC51_FORCE_FRAME_TYPE_I_FRAME	= 1,
+	V4L2_MPEG_MFC51_FORCE_FRAME_TYPE_NOT_CODED	= 2,
+};
+#define V4L2_CID_MPEG_MFC51_FRAME_TAG				(V4L2_CID_MPEG_MFC51_BASE+18)
+
 /*  Camera class control IDs */
 #define V4L2_CID_CAMERA_CLASS_BASE 	(V4L2_CTRL_CLASS_CAMERA | 0x900)
 #define V4L2_CID_CAMERA_CLASS 		(V4L2_CTRL_CLASS_CAMERA | 1)
-- 
1.6.3.3
