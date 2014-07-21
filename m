Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:2167 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932319AbaGUNp5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Jul 2014 09:45:57 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Eduardo Valentin <edubezval@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 2/7] DocBook/media: document the new RDS TX controls
Date: Mon, 21 Jul 2014 15:45:38 +0200
Message-Id: <1405950343-26892-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1405950343-26892-1-git-send-email-hverkuil@xs4all.nl>
References: <1405950343-26892-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Document the new RDS features that will be supported by the si4713 driver.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Eduardo Valentin <edubezval@gmail.com>
---
 Documentation/DocBook/media/v4l/controls.xml | 62 ++++++++++++++++++++++++++++
 1 file changed, 62 insertions(+)

diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index 74f5755..3ec85f6 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -4051,6 +4051,68 @@ to find receivers which can scroll strings sized as 32 x N or 64 x N characters.
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
+	    <entry spanname="id"><constant>V4L2_CID_RDS_TX_ALT_FREQS_ENABLE</constant>&nbsp;</entry>
+	    <entry>boolean</entry>
+	  </row>
+	  <row><entry spanname="descr">If set, then transmit alternate frequencies.</entry>
+	  </row>
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_RDS_TX_ALT_FREQS</constant>&nbsp;</entry>
+	    <entry>__u32 array</entry>
+	  </row>
+	  <row><entry spanname="descr">The alternate frequencies in kHz units. The RDS standard allows
+for up to 25 frequencies to be defined. Drivers may support fewer frequencies so check
+the array size.</entry>
+	  </row>
+	  <row>
 	    <entry spanname="id"><constant>V4L2_CID_AUDIO_LIMITER_ENABLED</constant>&nbsp;</entry>
 	    <entry>boolean</entry>
 	  </row>
-- 
2.0.1

