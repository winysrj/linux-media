Return-path: <mchehab@pedra>
Received: from mailout2.samsung.com ([203.254.224.25]:60754 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932166Ab1BYMqF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Feb 2011 07:46:05 -0500
Received: from epmmp1 (mailout2.samsung.com [203.254.224.25])
 by mailout2.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LH6005EZBGRWB20@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Fri, 25 Feb 2011 21:46:04 +0900 (KST)
Received: from TNRNDGASPAPP1.tn.corp.samsungelectronics.net ([165.213.149.150])
 by mmp1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LH600EGOBGRJR@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 25 Feb 2011 21:46:03 +0900 (KST)
Date: Fri, 25 Feb 2011 21:46:03 +0900
From: "Kim, HeungJun" <riverful.kim@samsung.com>
Subject: [RFC PATCH RESEND v2 3/3] v4l2-ctrls: document the changes about auto
 focus mode
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>
Reply-to: riverful.kim@samsung.com
Message-id: <4D67A48B.6030700@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Document about the type changes and the enumeration of the auto focus control.

Signed-off-by: Heungjun Kim <riverful.kim@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 Documentation/DocBook/v4l/controls.xml    |   31 +++++++++++++++++++++++++---
 Documentation/DocBook/v4l/videodev2.h.xml |    6 +++++
 2 files changed, 33 insertions(+), 4 deletions(-)

diff --git a/Documentation/DocBook/v4l/controls.xml b/Documentation/DocBook/v4l/controls.xml
index 2fae3e8..889fa84 100644
--- a/Documentation/DocBook/v4l/controls.xml
+++ b/Documentation/DocBook/v4l/controls.xml
@@ -1801,12 +1801,35 @@ negative values towards infinity. This is a write-only control.</entry>
 	  </row>
 	  <row><entry></entry></row>
 
-	  <row>
+	  <row id="v4l2-focus-auto-type">
 	    <entry spanname="id"><constant>V4L2_CID_FOCUS_AUTO</constant>&nbsp;</entry>
-	    <entry>boolean</entry>
+	    <entry>enum&nbsp;v4l2_focus_auto_type</entry>
 	  </row><row><entry spanname="descr">Enables automatic focus
-adjustments. The effect of manual focus adjustments while this feature
-is enabled is undefined, drivers should ignore such requests.</entry>
+adjustments of the normal or macro or continuous(CAF) mode. The effect of
+manual focus adjustments while this feature is enabled is undefined,
+drivers should ignore such requests. Possible values are:</entry>
+	  </row>
+	  <row>
+	    <entrytbl spanname="descr" cols="2">
+	      <tbody valign="top">
+		<row>
+		  <entry><constant>V4L2_FOCUS_MANUAL</constant>&nbsp;</entry>
+		  <entry>Manual focus mode.</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_FOCUS_AUTO</constant>&nbsp;</entry>
+		  <entry>Auto focus mode with normal operation.</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_FOCUS_MACRO</constant>&nbsp;</entry>
+		  <entry>Auto focus mode with macro operation.</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_FOCUS_CONTINUOUS</constant>&nbsp;</entry>
+		  <entry>Auto focus mode with continuous(CAF) operation.</entry>
+		</row>
+	      </tbody>
+	    </entrytbl>
 	  </row>
 	  <row><entry></entry></row>
 
diff --git a/Documentation/DocBook/v4l/videodev2.h.xml b/Documentation/DocBook/v4l/videodev2.h.xml
index 325b23b..ccf6c2b 100644
--- a/Documentation/DocBook/v4l/videodev2.h.xml
+++ b/Documentation/DocBook/v4l/videodev2.h.xml
@@ -1291,6 +1291,12 @@ enum  <link linkend="v4l2-exposure-auto-type">v4l2_exposure_auto_type</link> {
 #define V4L2_CID_FOCUS_ABSOLUTE                 (V4L2_CID_CAMERA_CLASS_BASE+10)
 #define V4L2_CID_FOCUS_RELATIVE                 (V4L2_CID_CAMERA_CLASS_BASE+11)
 #define V4L2_CID_FOCUS_AUTO                     (V4L2_CID_CAMERA_CLASS_BASE+12)
+enum  <link linkend="v4l2-focus-auto-type">v4l2_exposure_auto_type</link> {
+	V4L2_FOCUS_MANUAL = 0,
+	V4L2_FOCUS_AUTO = 1,
+	V4L2_FOCUS_MACRO = 2,
+	V4L2_FOCUS_CONTINUOUS = 3
+};
 
 #define V4L2_CID_ZOOM_ABSOLUTE                  (V4L2_CID_CAMERA_CLASS_BASE+13)
 #define V4L2_CID_ZOOM_RELATIVE                  (V4L2_CID_CAMERA_CLASS_BASE+14)
-- 
1.7.0.4
