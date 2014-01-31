Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:1639 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754015AbaAaJ5Q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Jan 2014 04:57:16 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, laurent.pinchart@ideasonboard.com,
	s.nawrocki@samsung.com, ismael.luceno@corp.bluecherry.net,
	Pete Eberlein <pete@sensoray.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 27/32] DocBook media: document new motion detection controls.
Date: Fri, 31 Jan 2014 10:56:25 +0100
Message-Id: <1391162190-8620-28-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1391162190-8620-1-git-send-email-hverkuil@xs4all.nl>
References: <1391162190-8620-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Document the 'Detect' control class and the new Motion Detection controls.
Those controls will be used by the solo6x10 and go7007 drivers.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/controls.xml | 95 ++++++++++++++++++++++++++++
 1 file changed, 95 insertions(+)

diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index 85d78d4..5f3e138 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -5022,4 +5022,99 @@ defines possible values for de-emphasis. Here they are:</entry>
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
+            <entry spanname="id"><constant>V4L2_CID_DETECT_MD_MODE</constant>&nbsp;</entry>
+            <entry>menu</entry>
+          </row><row><entry spanname="descr">Sets the motion detection mode.</entry>
+          </row>
+	  <row>
+	    <entrytbl spanname="descr" cols="2">
+	      <tbody valign="top">
+		<row>
+		  <entry><constant>V4L2_DETECT_MD_MODE_DISABLED</constant>
+		  </entry><entry>Disable motion detection.</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_DETECT_MD_MODE_GLOBAL</constant>
+		  </entry><entry>Use a single motion detection threshold.</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_DETECT_MD_MODE_THRESHOLD_GRID</constant>
+		  </entry><entry>The image is divided into a grid, each cell with its own
+		  motion detection threshold. These thresholds are set through the
+		  <constant>V4L2_CID_DETECT_MD_THRESHOLD_GRID</constant> matrix control.</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_DETECT_MD_MODE_REGION_GRID</constant>
+		  </entry><entry>The image is divided into a grid, each cell with its own
+		  region value that specifies which per-region motion detection thresholds
+		  should be used. Each region has its own thresholds. How these per-region
+		  thresholds are set up is driver-specific. The region values for the grid are set
+		  through the <constant>V4L2_CID_DETECT_MD_REGION_GRID</constant> matrix
+		  control.</entry>
+		</row>
+	      </tbody>
+	    </entrytbl>
+	  </row>
+          <row>
+	    <entry spanname="id"><constant>V4L2_CID_DETECT_MD_GLOBAL_THRESHOLD</constant>&nbsp;</entry>
+	    <entry>integer</entry>
+	  </row>
+	  <row><entry spanname="descr">Sets the global motion detection threshold to be
+	  used with the <constant>V4L2_DETECT_MD_MODE_GLOBAL</constant> motion detection mode.</entry>
+          </row>
+          <row>
+	    <entry spanname="id"><constant>V4L2_CID_DETECT_MD_THRESHOLD_GRID</constant>&nbsp;</entry>
+	    <entry>__u16 matrix</entry>
+	  </row>
+	  <row><entry spanname="descr">Sets the motion detection thresholds for each cell in the grid.
+	  To be used with the <constant>V4L2_DETECT_MD_MODE_THRESHOLD_GRID</constant>
+	  motion detection mode.</entry>
+          </row>
+          <row>
+	    <entry spanname="id"><constant>V4L2_CID_DETECT_MD_REGION_GRID</constant>&nbsp;</entry>
+	    <entry>__u8 matrix</entry>
+	  </row>
+	  <row><entry spanname="descr">Sets the motion detection region value for each cell in the grid.
+	  To be used with the <constant>V4L2_DETECT_MD_MODE_REGION_GRID</constant>
+	  motion detection mode.</entry>
+          </row>
+        </tbody>
+      </tgroup>
+      </table>
+
+      </section>
 </section>
-- 
1.8.5.2

