Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42738 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605AbbLLNlB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Dec 2015 08:41:01 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 5/6] [media] DocBook: add a table for Media Controller interfaces
Date: Sat, 12 Dec 2015 11:40:44 -0200
Message-Id: <c357af8f42b53d16b9cacdf7efa9d6bfcf0901de.1449927561.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1449927561.git.mchehab@osg.samsung.com>
References: <cover.1449927561.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1449927561.git.mchehab@osg.samsung.com>
References: <cover.1449927561.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Document the media controller interfaces at the media
uAPI docbook.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 Documentation/DocBook/media/v4l/media-types.xml | 61 +++++++++++++++++++++++++
 1 file changed, 61 insertions(+)

diff --git a/Documentation/DocBook/media/v4l/media-types.xml b/Documentation/DocBook/media/v4l/media-types.xml
index 4a6038301e06..1af384250910 100644
--- a/Documentation/DocBook/media/v4l/media-types.xml
+++ b/Documentation/DocBook/media/v4l/media-types.xml
@@ -109,6 +109,67 @@
       </tgroup>
     </table>
 
+    <table frame="none" pgwide="1" id="media-intf-type">
+      <title>Media interface types</title>
+      <tgroup cols="3">
+	<colspec colname="c1"/>
+	<colspec colname="c2"/>
+	<colspec colname="c3"/>
+	<tbody valign="top">
+	  <row>
+	    <entry><constant>MEDIA_INTF_T_DVB_FE</constant></entry>
+	    <entry>Device node interface for the Digital TV frontend</entry>
+	    <entry>typically, /dev/dvb/adapter?/frontend?</entry>
+	  </row>
+	  <row>
+	    <entry><constant>MEDIA_INTF_T_DVB_DEMUX</constant></entry>
+	    <entry>Device node interface for the Digital TV demux</entry>
+	    <entry>typically, /dev/dvb/adapter?/demux?</entry>
+	  </row>
+	  <row>
+	    <entry><constant>MEDIA_INTF_T_DVB_DVR</constant></entry>
+	    <entry>Device node interface for the Digital TV DVR</entry>
+	    <entry>typically, /dev/dvb/adapter?/dvr?</entry>
+	  </row>
+	  <row>
+	    <entry><constant>MEDIA_INTF_T_DVB_CA</constant></entry>
+	    <entry>Device node interface for the Digital TV Conditional Access</entry>
+	    <entry>typically, /dev/dvb/adapter?/ca?</entry>
+	  </row>
+	  <row>
+	    <entry><constant>MEDIA_INTF_T_DVB_FE</constant></entry>
+	    <entry>Device node interface for the Digital TV network control</entry>
+	    <entry>typically, /dev/dvb/adapter?/net?</entry>
+	  </row>
+	  <row>
+	    <entry><constant>MEDIA_INTF_T_V4L_VIDEO</constant></entry>
+	    <entry>Device node interface for video (V4L)</entry>
+	    <entry>typically, /dev/video?</entry>
+	  </row>
+	  <row>
+	    <entry><constant>MEDIA_INTF_T_V4L_VBI</constant></entry>
+	    <entry>Device node interface for VBI (V4L)</entry>
+	    <entry>typically, /dev/vbi?</entry>
+	  </row>
+	  <row>
+	    <entry><constant>MEDIA_INTF_T_V4L_RADIO</constant></entry>
+	    <entry>Device node interface for radio (V4L)</entry>
+	    <entry>typically, /dev/vbi?</entry>
+	  </row>
+	  <row>
+	    <entry><constant>MEDIA_INTF_T_V4L_SUBDEV</constant></entry>
+	    <entry>Device node interface for a V4L subdevice</entry>
+	    <entry>typically, /dev/v4l-subdev?</entry>
+	  </row>
+	  <row>
+	    <entry><constant>MEDIA_INTF_T_V4L_SWRADIO</constant></entry>
+	    <entry>Device node interface for Software Defined Radio (V4L)</entry>
+	    <entry>typically, /dev/swradio?</entry>
+	  </row>
+	</tbody>
+      </tgroup>
+    </table>
+
     <table frame="none" pgwide="1" id="media-pad-flag">
       <title>Media pad flags</title>
       <tgroup cols="2">
-- 
2.5.0


