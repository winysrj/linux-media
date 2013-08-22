Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:4949 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821Ab3HVKPE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Aug 2013 06:15:04 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: ismael.luceno@corp.bluecherry.net, pete@sensoray.com,
	sakari.ailus@iki.fi, sylvester.nawrocki@gmail.com,
	laurent.pinchart@ideasonboard.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv3 PATCH 07/10] DocBook: add the new v4l detection class controls.
Date: Thu, 22 Aug 2013 12:14:21 +0200
Message-Id: <c5131e2768b19d8a9df23069fd66eff43eb6f276.1377166147.git.hans.verkuil@cisco.com>
In-Reply-To: <1377166464-27448-1-git-send-email-hverkuil@xs4all.nl>
References: <1377166464-27448-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <7c5a78eea892dd37d172f24081402be354758894.1377166147.git.hans.verkuil@cisco.com>
References: <7c5a78eea892dd37d172f24081402be354758894.1377166147.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/controls.xml | 69 ++++++++++++++++++++++++++++
 1 file changed, 69 insertions(+)

diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index c2fc9ec..dabc707 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -4772,4 +4772,73 @@ defines possible values for de-emphasis. Here they are:</entry>
       </table>
 
       </section>
+
+    <section id="detect-controls">
+      <title>Detect Control Reference</title>
+
+      <para>The Detect class includes controls for common features of
+      various motion or object detection capable devices.</para>
+
+      <table pgwide="1" frame="none" id="detect-control-id">
+      <title>Detect Control IDs</title>
+
+      <tgroup cols="4">
+        <colspec colname="c1" colwidth="1*" />
+        <colspec colname="c2" colwidth="6*" />
+        <colspec colname="c3" colwidth="2*" />
+        <colspec colname="c4" colwidth="6*" />
+        <spanspec namest="c1" nameend="c2" spanname="id" />
+        <spanspec namest="c2" nameend="c4" spanname="descr" />
+        <thead>
+          <row>
+            <entry spanname="id" align="left">ID</entry>
+            <entry align="left">Type</entry>
+          </row><row rowsep="1"><entry spanname="descr" align="left">Description</entry>
+          </row>
+        </thead>
+        <tbody valign="top">
+          <row><entry></entry></row>
+          <row>
+            <entry spanname="id"><constant>V4L2_CID_DETECT_CLASS</constant>&nbsp;</entry>
+            <entry>class</entry>
+          </row><row><entry spanname="descr">The Detect class
+descriptor. Calling &VIDIOC-QUERYCTRL; for this control will return a
+description of this control class.</entry>
+          </row>
+          <row>
+            <entry spanname="id"><constant>V4L2_CID_DETECT_MOTION_MODE</constant>&nbsp;</entry>
+            <entry>menu</entry>
+          </row><row><entry spanname="descr">Sets the motion detection mode.</entry>
+          </row>
+	  <row>
+	    <entrytbl spanname="descr" cols="2">
+	      <tbody valign="top">
+		<row>
+		  <entry><constant>V4L2_DETECT_MOTION_DISABLED</constant>
+		  </entry><entry>Disable motion detection.</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_DETECT_MOTION_GLOBAL</constant>
+		  </entry><entry>Use a single motion detection threshold.</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_DETECT_MOTION_REGIONAL</constant>
+		  </entry><entry>The image is divided into regions, each with their own
+		  motion detection threshold.</entry>
+		</row>
+	      </tbody>
+	    </entrytbl>
+	  </row>
+          <row>
+	    <entry spanname="id"><constant>V4L2_CID_DETECT_MOTION_THRESHOLD</constant>&nbsp;</entry>
+	    <entry>integer</entry>
+	  </row>
+	  <row><entry spanname="descr">Sets the global motion detection threshold to be
+	  used with the <constant>V4L2_DETECT_MOTION_GLOBAL</constant> motion detection mode.</entry>
+          </row>
+        </tbody>
+      </tgroup>
+      </table>
+
+      </section>
 </section>
-- 
1.8.3.2

