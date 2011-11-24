Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:2622 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756063Ab1KXNjY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Nov 2011 08:39:24 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 05/12] Document decoder controls.
Date: Thu, 24 Nov 2011 14:39:02 +0100
Message-Id: <66d8616e81db35a07966e0612537b4a74b35e855.1322141686.git.hans.verkuil@cisco.com>
In-Reply-To: <1322141949-5795-1-git-send-email-hverkuil@xs4all.nl>
References: <1322141949-5795-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <07c1a0737016dcf588e866cde0f3bc1a59e35bfb.1322141686.git.hans.verkuil@cisco.com>
References: <07c1a0737016dcf588e866cde0f3bc1a59e35bfb.1322141686.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/controls.xml |   58 ++++++++++++++++++++++++++
 1 files changed, 58 insertions(+), 0 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index 3bc5ee8..411fba2 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -797,6 +797,13 @@ in the kernel sources in the file <filename>Documentation/video4linux/cx2341x/RE
 		</entrytbl>
 	      </row>
 	      <row><entry></entry></row>
+	      <row id="v4l2-mpeg-stream-dec-pts">
+		<entry spanname="id"><constant>V4L2_CID_MPEG_STREAM_DEC_PTS</constant>&nbsp;</entry>
+		<entry>integer64</entry>
+	      </row><row><entry spanname="descr">This read-only control returns the
+Program Time Stamp of the frame that is currently displayed (decoded).</entry>
+	      </row>
+	      <row><entry></entry></row>
 	      <row id="v4l2-mpeg-audio-sampling-freq">
 		<entry spanname="id"><constant>V4L2_CID_MPEG_AUDIO_SAMPLING_FREQ</constant>&nbsp;</entry>
 		<entry>enum&nbsp;v4l2_mpeg_audio_sampling_freq</entry>
@@ -1273,6 +1280,49 @@ produce a slight hiss, but in the encoder itself, guaranteeing a fixed
 and reproducible audio bitstream. 0 = unmuted, 1 = muted.</entry>
 	      </row>
 	      <row><entry></entry></row>
+	      <row id="v4l2-mpeg-audio-dec-playback">
+		<entry spanname="id"><constant>V4L2_CID_MPEG_AUDIO_DEC_PLAYBACK</constant>&nbsp;</entry>
+		<entry>enum&nbsp;v4l2_mpeg_audio_dec_playback</entry>
+	      </row><row><entry spanname="descr">Determines how monolingual audio should be played back.
+Possible values are:</entry>
+	      </row>
+	      <row>
+		<entrytbl spanname="descr" cols="2">
+		  <tbody valign="top">
+		    <row>
+		      <entry><constant>V4L2_MPEG_AUDIO_DEC_PLAYBACK_AUTO</constant>&nbsp;</entry>
+		      <entry>Automatically determines the best playback mode.</entry>
+		    </row>
+		    <row>
+		      <entry><constant>V4L2_MPEG_AUDIO_DEC_PLAYBACK_STEREO</constant>&nbsp;</entry>
+		      <entry>Stereo playback.</entry>
+		    </row>
+		    <row>
+		      <entry><constant>V4L2_MPEG_AUDIO_DEC_PLAYBACK_LEFT</constant>&nbsp;</entry>
+		      <entry>Left channel playback.</entry>
+		    </row>
+		    <row>
+		      <entry><constant>V4L2_MPEG_AUDIO_DEC_PLAYBACK_RIGHT</constant>&nbsp;</entry>
+		      <entry>Right channel playback.</entry>
+		    </row>
+		    <row>
+		      <entry><constant>V4L2_MPEG_AUDIO_DEC_PLAYBACK_MONO</constant>&nbsp;</entry>
+		      <entry>Mono playback.</entry>
+		    </row>
+		    <row>
+		      <entry><constant>V4L2_MPEG_AUDIO_DEC_PLAYBACK_SWAPPED_STEREO</constant>&nbsp;</entry>
+		      <entry>Stereo playback with swapped left and right channels.</entry>
+		    </row>
+		  </tbody>
+		</entrytbl>
+	      </row>
+	      <row><entry></entry></row>
+	      <row id="v4l2-mpeg-audio-dec-multilingual-playback">
+		<entry spanname="id"><constant>V4L2_CID_MPEG_AUDIO_DEC_MULTILINGUAL_PLAYBACK</constant>&nbsp;</entry>
+		<entry>enum&nbsp;v4l2_mpeg_audio_dec_playback</entry>
+	      </row><row><entry spanname="descr">Determines how multilingual audio should be played back.</entry>
+	      </row>
+	      <row><entry></entry></row>
 	      <row id="v4l2-mpeg-video-encoding">
 		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_ENCODING</constant>&nbsp;</entry>
 		<entry>enum&nbsp;v4l2_mpeg_video_encoding</entry>
@@ -1434,6 +1484,14 @@ of the video. The supplied 32-bit integer is interpreted as follows (bit
 		  </tbody>
 		</entrytbl>
 	      </row>
+	      <row><entry></entry></row>
+	      <row id="v4l2-mpeg-video-dec-frame">
+		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_DEC_FRAME</constant>&nbsp;</entry>
+		<entry>integer64</entry>
+	      </row><row><entry spanname="descr">This read-only control returns the
+frame counter of the frame that is currently displayed (decoded). This value is reset to 0 whenever
+the decoder is started.</entry>
+	      </row>
 
 
 	      <row><entry></entry></row>
-- 
1.7.7.3

