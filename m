Return-path: <mchehab@pedra>
Received: from mailout3.samsung.com ([203.254.224.33]:39359 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755151Ab1CVIiT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Mar 2011 04:38:19 -0400
Received: from epmmp1 (mailout3.samsung.com [203.254.224.33])
 by mailout3.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LIG001MCANPL300@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Tue, 22 Mar 2011 17:38:13 +0900 (KST)
Received: from TNRNDGASPAPP1.tn.corp.samsungelectronics.net ([165.213.149.150])
 by mmp1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LIG001UXANP8A@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 22 Mar 2011 17:38:13 +0900 (KST)
Date: Tue, 22 Mar 2011 17:38:09 +0900
From: "Kim, Heungjun" <riverful.kim@samsung.com>
Subject: [RFC PATCH v3 2/2] v4l2-ctrls: update auto focus mode documentation
In-reply-to: <4D885F32.60309@samsung.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	s.nawrocki@samsung.com, kyungmin.park@samsung.com,
	"Kim, Heungjun" <riverful.kim@samsung.com>
Message-id: <1300783089-14984-2-git-send-email-riverful.kim@samsung.com>
Content-transfer-encoding: 7BIT
References: <4D885F32.60309@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

As following to change the boolean type of V4L2_CID_FOCUS_AUTO to menu type,
this uvc is modified the usage of V4L2_CID_FOCUS_AUTO.

Signed-off-by: Heungjun Kim <riverful.kim@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 Documentation/DocBook/v4l/controls.xml    |   67 +++++++++++++++++++++++++++++
 Documentation/DocBook/v4l/videodev2.h.xml |    8 +++
 2 files changed, 75 insertions(+), 0 deletions(-)

diff --git a/Documentation/DocBook/v4l/controls.xml b/Documentation/DocBook/v4l/controls.xml
index 2fae3e8..b940e21 100644
--- a/Documentation/DocBook/v4l/controls.xml
+++ b/Documentation/DocBook/v4l/controls.xml
@@ -1860,6 +1860,73 @@ it one step further. This is a write-only control.</entry>
 	  </row>
 	  <row><entry></entry></row>
 
+	  <row id="v4l2-focus-auto-mode-type">
+	    <entry spanname="id"><constant>V4L2_CID_FOCUS_AUTO_MODE</constant>&nbsp;</entry>
+	    <entry>enum&nbsp;v4l2_focus_auto_mode_type</entry>
+	  </row><row><entry spanname="descr">Enables setting modes of
+auto focus. The focus has 5 kinds of mode, and each enumerations express
+current auto focus mode in which the camera is. In the case of
+V4L2_FOCUS_AUTO_RECTANGLE, this control id can be clustered with
+4 control id which means focusing spot expressed by 4 point of rectangle.
+	  </entry>
+	  </row>
+	  <row>
+	    <entrytbl spanname="descr" cols="2">
+	      <tbody valign="top">
+		<row>
+		  <entry><constant>V4L2_FOCUS_AUTO_NORMAL</constant>&nbsp;</entry>
+		  <entry>Normal mode Auto focus, single shot.</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_FOCUS_AUTO_MACRO</constant>&nbsp;</entry>
+		  <entry>Macro mode Auto focus, single shot.</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_FOCUS_AUTO_CONTINUOUS</constant>&nbsp;</entry>
+		  <entry>Continuous mode Auto focus, continuous shot.</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_FOCUS_AUTO_FACE_DETECTION</constant>&nbsp;</entry>
+		  <entry>Face detection mode Auto focus, single shot.</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_FOCUS_AUTO_RECTANGLE</constant>&nbsp;</entry>
+		  <entry>Rectangle mode Auto focus, single shot.</entry>
+		</row>
+	      </tbody>
+	    </entrytbl>
+	  </row>
+	  <row><entry></entry></row>
+
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_FOCUS_AUTO_RECTANGLE_LEFT</constant>&nbsp;</entry>
+	    <entry>integer</entry>
+	  </row><row><entry spanname="descr">This control means the left
+side's point of the rectangle expressing focusing spot.</entry>
+	  </row>
+	  <row><entry></entry></row>
+
+	    <entry spanname="id"><constant>V4L2_CID_FOCUS_AUTO_RECTANGLE_TOP</constant>&nbsp;</entry>
+	    <entry>integer</entry>
+	  </row><row><entry spanname="descr">This control means the top
+side's point of the rectangle expressing focusing spot.</entry>
+	  </row>
+	  <row><entry></entry></row>
+
+	    <entry spanname="id"><constant>V4L2_CID_FOCUS_AUTO_RECTANGLE_WIDTH</constant>&nbsp;</entry>
+	    <entry>integer</entry>
+	  </row><row><entry spanname="descr">This control means the width
+length of the rectangle expressing focusing spot.</entry>
+	  </row>
+	  <row><entry></entry></row>
+
+	    <entry spanname="id"><constant>V4L2_CID_FOCUS_AUTO_RECTANGLE_HEIGHT</constant>&nbsp;</entry>
+	    <entry>integer</entry>
+	  </row><row><entry spanname="descr">This control means the height
+length of the rectangle expressing focusing spot.</entry>
+	  </row>
+	  <row><entry></entry></row>
+
 	  <row>
 	    <entry spanname="id"><constant>V4L2_CID_PRIVACY</constant>&nbsp;</entry>
 	    <entry>boolean</entry>
diff --git a/Documentation/DocBook/v4l/videodev2.h.xml b/Documentation/DocBook/v4l/videodev2.h.xml
index 2b796a2..6bb67a6 100644
--- a/Documentation/DocBook/v4l/videodev2.h.xml
+++ b/Documentation/DocBook/v4l/videodev2.h.xml
@@ -1385,6 +1385,14 @@ enum  <link linkend="v4l2-exposure-auto-type">v4l2_exposure_auto_type</link> {
 #define V4L2_CID_IRIS_ABSOLUTE                  (V4L2_CID_CAMERA_CLASS_BASE+17)
 #define V4L2_CID_IRIS_RELATIVE                  (V4L2_CID_CAMERA_CLASS_BASE+18)
 
+enum  <link linkend="v4l2-focus-auto-mode-type">v4l2_focus_auto_mode_type</link> {
+	V4L2_FOCUS_AUTO_NORMAL = 0,
+	V4L2_FOCUS_AUTO_MACRO = 1,
+	V4L2_FOCUS_AUTO_CONTINUOUS = 2,
+	V4L2_FOCUS_AUTO_FACE_DETECTION = 3,
+	V4L2_FOCUS_AUTO_RECTANGLE = 4
+};
+
 /* FM Modulator class control IDs */
 #define V4L2_CID_FM_TX_CLASS_BASE               (V4L2_CTRL_CLASS_FM_TX | 0x900)
 #define V4L2_CID_FM_TX_CLASS                    (V4L2_CTRL_CLASS_FM_TX | 1)
-- 
1.7.0.4

