Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:2821 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933268AbaFLLyv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jun 2014 07:54:51 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, s.nawrocki@samsung.com,
	sakari.ailus@iki.fi, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv4 PATCH 27/34] DocBook media: document new motion detection controls.
Date: Thu, 12 Jun 2014 13:52:59 +0200
Message-Id: <538b8e77a4df915ef8b2bbb3d2c71421c2e0fa10.1402573818.git.hans.verkuil@cisco.com>
In-Reply-To: <1402573986-20794-1-git-send-email-hverkuil@xs4all.nl>
References: <1402573986-20794-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <971e25ca71923ba77526326f998227fdfb30f216.1402573818.git.hans.verkuil@cisco.com>
References: <971e25ca71923ba77526326f998227fdfb30f216.1402573818.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Document the 'Detect' control class and the new Motion Detection controls.
Those controls will be used by the solo6x10 and go7007 drivers.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/controls.xml | 96 ++++++++++++++++++++++++++++
 1 file changed, 96 insertions(+)

diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index e7b8b72..cc0087e 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -5055,6 +5055,102 @@ defines possible values for de-emphasis. Here they are:</entry>
         </tbody>
       </tgroup>
       </table>
+    </section>
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
+	  motion detection mode. Matrix element (0, 0) represents the cell at the top-left of the
+	  grid.</entry>
+          </row>
+          <row>
+	    <entry spanname="id"><constant>V4L2_CID_DETECT_MD_REGION_GRID</constant>&nbsp;</entry>
+	    <entry>__u8 matrix</entry>
+	  </row>
+	  <row><entry spanname="descr">Sets the motion detection region value for each cell in the grid.
+	  To be used with the <constant>V4L2_DETECT_MD_MODE_REGION_GRID</constant>
+	  motion detection mode. Matrix element (0, 0) represents the cell at the top-left of the
+	  grid.</entry>
+          </row>
+        </tbody>
+      </tgroup>
+      </table>
 
       </section>
 
-- 
2.0.0.rc0

