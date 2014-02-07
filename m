Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:2529 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755390AbaBGMUK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Feb 2014 07:20:10 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: edubezval@gmail.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 2/7] DocBook/media: document the new RDS TX controls
Date: Fri,  7 Feb 2014 13:19:35 +0100
Message-Id: <1391775580-29907-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1391775580-29907-1-git-send-email-hverkuil@xs4all.nl>
References: <1391775580-29907-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Document the new RDS features that will be supported by the si4713 driver.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Eduardo Valentin <edubezval@gmail.com>
---
 Documentation/DocBook/media/v4l/controls.xml | 60 ++++++++++++++++++++++++++++
 1 file changed, 60 insertions(+)

diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index a5a3188..58fd169 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -3980,6 +3980,66 @@ to find receivers which can scroll strings sized as 32 x N or 64 x N characters.
 with steps of 32 or 64 characters. The result is it must always contain a string with size multiple of 32 or 64. </entry>
 	  </row>
 	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_RDS_TX_MONO_STEREO</constant>&nbsp;</entry>
+	    <entry>boolean</entry>
+	  </row>
+	  <row><entry spanname="descr">Sets the Mono/Stereo bit of the Decoder Identification code. If set,
+then the audio was recorded as stereo.</entry>
+	  </row>
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_RDS_TX_ARTIFICIAL_HEAD</constant>&nbsp;</entry>
+	    <entry>boolean</entry>
+	  </row>
+	  <row><entry spanname="descr">Sets the
+<ulink url="http://en.wikipedia.org/wiki/Artificial_head">Artificial Head</ulink> bit of the Decoder
+Identification code. If set, then the audio was recorded using an artificial head.</entry>
+	  </row>
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_RDS_TX_COMPRESSED</constant>&nbsp;</entry>
+	    <entry>boolean</entry>
+	  </row>
+	  <row><entry spanname="descr">Sets the Compressed bit of the Decoder Identification code. If set,
+then the audio is compressed.</entry>
+	  </row>
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_RDS_TX_DYNAMIC_PTY</constant>&nbsp;</entry>
+	    <entry>boolean</entry>
+	  </row>
+	  <row><entry spanname="descr">Sets the Dynamic PTY bit of the Decoder Identification code. If set,
+then the PTY code is dynamically switched.</entry>
+	  </row>
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_RDS_TX_TRAFFIC_ANNOUNCEMENT</constant>&nbsp;</entry>
+	    <entry>boolean</entry>
+	  </row>
+	  <row><entry spanname="descr">If set, then a traffic announcement is in progress.</entry>
+	  </row>
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_RDS_TX_TRAFFIC_PROGRAM</constant>&nbsp;</entry>
+	    <entry>boolean</entry>
+	  </row>
+	  <row><entry spanname="descr">If set, then the tuned programme carries traffic announcements.</entry>
+	  </row>
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_RDS_TX_MUSIC_SPEECH</constant>&nbsp;</entry>
+	    <entry>boolean</entry>
+	  </row>
+	  <row><entry spanname="descr">If set, then this channel broadcasts music. If cleared, then it
+broadcasts speech. If the transmitter doesn't make this distinction, then it should be set.</entry>
+	  </row>
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_RDS_TX_ALT_FREQ_ENABLE</constant>&nbsp;</entry>
+	    <entry>boolean</entry>
+	  </row>
+	  <row><entry spanname="descr">If set, then transmit alternate frequencies.</entry>
+	  </row>
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_RDS_TX_FREQ</constant>&nbsp;</entry>
+	    <entry>integer</entry>
+	  </row>
+	  <row><entry spanname="descr">The alternate frequency (in Hz).</entry>
+	  </row>
+	  <row>
 	    <entry spanname="id"><constant>V4L2_CID_AUDIO_LIMITER_ENABLED</constant>&nbsp;</entry>
 	    <entry>boolean</entry>
 	  </row>
-- 
1.8.5.2

