Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:2229 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932153AbaGUNqB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Jul 2014 09:46:01 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Eduardo Valentin <edubezval@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 5/7] DocBook/media: document the new RDS RX controls
Date: Mon, 21 Jul 2014 15:45:41 +0200
Message-Id: <1405950343-26892-6-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1405950343-26892-1-git-send-email-hverkuil@xs4all.nl>
References: <1405950343-26892-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Document the new RDS receiver controls. This will be used by the radio-miropcm20
driver.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/controls.xml | 51 ++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)

diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index 3ec85f6..9f5ffd8 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -5089,6 +5089,57 @@ description of this control class.</entry>
           </row><row><entry spanname="descr">Enables/disables RDS
 	  reception by the radio tuner</entry>
           </row>
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_RDS_RX_PTY</constant>&nbsp;</entry>
+	    <entry>integer</entry>
+	  </row>
+	  <row><entry spanname="descr">Gets RDS Programme Type field.
+This encodes up to 31 pre-defined programme types.</entry>
+	  </row>
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_RDS_RX_PS_NAME</constant>&nbsp;</entry>
+	    <entry>string</entry>
+	  </row>
+	  <row><entry spanname="descr">Gets the Programme Service name (PS_NAME).
+It is intended for static display on a receiver. It is the primary aid to listeners in programme service
+identification and selection.  In Annex E of <xref linkend="iec62106" />, the RDS specification,
+there is a full description of the correct character encoding for Programme Service name strings.
+Also from RDS specification, PS is usually a single eight character text. However, it is also possible
+to find receivers which can scroll strings sized as 8 x N characters. So, this control must be configured
+with steps of 8 characters. The result is it must always contain a string with size multiple of 8.</entry>
+	  </row>
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_RDS_RX_RADIO_TEXT</constant>&nbsp;</entry>
+	    <entry>string</entry>
+	  </row>
+	  <row><entry spanname="descr">Gets the Radio Text info. It is a textual description of
+what is being broadcasted. RDS Radio Text can be applied when broadcaster wishes to transmit longer PS names,
+programme-related information or any other text. In these cases, RadioText can be used in addition to
+<constant>V4L2_CID_RDS_RX_PS_NAME</constant>. The encoding for Radio Text strings is also fully described
+in Annex E of <xref linkend="iec62106" />. The length of Radio Text strings depends on which RDS Block is being
+used to transmit it, either 32 (2A block) or 64 (2B block).  However, it is also possible
+to find receivers which can scroll strings sized as 32 x N or 64 x N characters. So, this control must be configured
+with steps of 32 or 64 characters. The result is it must always contain a string with size multiple of 32 or 64. </entry>
+	  </row>
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_RDS_RX_TRAFFIC_ANNOUNCEMENT</constant>&nbsp;</entry>
+	    <entry>boolean</entry>
+	  </row>
+	  <row><entry spanname="descr">If set, then a traffic announcement is in progress.</entry>
+	  </row>
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_RDS_RX_TRAFFIC_PROGRAM</constant>&nbsp;</entry>
+	    <entry>boolean</entry>
+	  </row>
+	  <row><entry spanname="descr">If set, then the tuned programme carries traffic announcements.</entry>
+	  </row>
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_RDS_RX_MUSIC_SPEECH</constant>&nbsp;</entry>
+	    <entry>boolean</entry>
+	  </row>
+	  <row><entry spanname="descr">If set, then this channel broadcasts music. If cleared, then it
+broadcasts speech. If the transmitter doesn't make this distinction, then it will be set.</entry>
+	  </row>
           <row>
 	    <entry spanname="id"><constant>V4L2_CID_TUNE_DEEMPHASIS</constant>&nbsp;</entry>
 	    <entry>enum v4l2_deemphasis</entry>
-- 
2.0.1

