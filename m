Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:2169 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754556Ab1LOOPv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Dec 2011 09:15:51 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv3 PATCH 5/8] Document decoder controls.
Date: Thu, 15 Dec 2011 15:15:34 +0100
Message-Id: <f9de6611cf32fe54914016d6545f82ca6d7d2828.1323957539.git.hans.verkuil@cisco.com>
In-Reply-To: <1323958537-7026-1-git-send-email-hverkuil@xs4all.nl>
References: <1323958537-7026-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <26fac753ffa549b2ffdc5fe64a50e0a9637c2b16.1323957539.git.hans.verkuil@cisco.com>
References: <26fac753ffa549b2ffdc5fe64a50e0a9637c2b16.1323957539.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/controls.xml |   59 ++++++++++++++++++++++++++
 1 files changed, 59 insertions(+), 0 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index 9e72f07..400f223 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -1273,6 +1273,49 @@ produce a slight hiss, but in the encoder itself, guaranteeing a fixed
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
@@ -1434,6 +1477,22 @@ of the video. The supplied 32-bit integer is interpreted as follows (bit
 		  </tbody>
 		</entrytbl>
 	      </row>
+	      <row><entry></entry></row>
+	      <row id="v4l2-mpeg-video-dec-pts">
+		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_DEC_PTS</constant>&nbsp;</entry>
+		<entry>integer64</entry>
+	      </row><row><entry spanname="descr">This read-only control returns the
+33-bit video Presentation Time Stamp as defined in ITU T-REC-H.222.0 and ISO/IEC 13818-1 of
+the currently displayed frame. This is the same PTS as is used in &VIDIOC-DECODER-CMD;.</entry>
+	      </row>
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

