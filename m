Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:63374 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759691Ab2D0OXi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Apr 2012 10:23:38 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt2 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M3500AQJ6NK4Q30@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 27 Apr 2012 15:23:44 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M3500LMC6N8JR@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 27 Apr 2012 15:23:32 +0100 (BST)
Date: Fri, 27 Apr 2012 16:23:27 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH/RFC v3 10/14] V4L: Add auto focus targets to the selections API
In-reply-to: <1335536611-4298-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
	g.liakhovetski@gmx.de, hdegoede@redhat.com, moinejf@free.fr,
	hverkuil@xs4all.nl, m.szyprowski@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	s.nawrocki@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1335536611-4298-11-git-send-email-s.nawrocki@samsung.com>
References: <1335536611-4298-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The camera automatic focus algorithms may require setting up
a spot or rectangle coordinates or multiple such parameters.

The automatic focus selection targets are introduced in order
to allow applications to query and set such coordinates. Those
selections are intended to be used together with the automatic
focus controls available in the camera control class.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 Documentation/DocBook/media/v4l/selection-api.xml  |   33 +++++++++++++++++++-
 .../DocBook/media/v4l/vidioc-g-selection.xml       |   11 +++++++
 include/linux/videodev2.h                          |    5 +++
 3 files changed, 48 insertions(+), 1 deletion(-)

diff --git a/Documentation/DocBook/media/v4l/selection-api.xml b/Documentation/DocBook/media/v4l/selection-api.xml
index b299e47..490d29a 100644
--- a/Documentation/DocBook/media/v4l/selection-api.xml
+++ b/Documentation/DocBook/media/v4l/selection-api.xml
@@ -1,6 +1,6 @@
 <section id="selection-api">
 
-  <title>Experimental API for cropping, composing and scaling</title>
+  <title>Experimental selections API</title>
 
       <note>
 	<title>Experimental</title>
@@ -9,6 +9,10 @@
 interface and may change in the future.</para>
       </note>
 
+ <section>
+
+ <title>Image cropping, composing and scaling</title>
+
   <section>
     <title>Introduction</title>
 
@@ -321,5 +325,32 @@ V4L2_BUF_TYPE_VIDEO_OUTPUT </constant> for other devices</para>
       </example>
 
    </section>
+ </section>
+
+   <section>
+     <title>Automatic focus regions of interest</title>
+
+<para> The camera automatic focus algorithms may require configuration of
+regions of interest in form of rectangle or spot coordinates. The automatic
+focus selection targets allow applications to query and set such coordinates.
+Those selections are intended to be used together with the
+<constant>V4L2_CID_AUTO_FOCUS_AREA</constant> <link linkend="camera-controls">
+camera class</link> control. The <constant>V4L2_SEL_TGT_AUTO_FOCUS_ACTUAL
+</constant> target is used for querying or setting actual spot or rectangle
+coordinates, while <constant>V4L2_SEL_TGT_AUTO_FOCUS_BOUNDS</constant> target
+determines bounds for a single spot or rectangle.
+These selections are only effective when the <constant>V4L2_CID_AUTO_FOCUS_AREA
+</constant>control is set to <constant>V4L2_AUTO_FOCUS_AREA_SPOT</constant> or
+<constant>V4L2_AUTO_FOCUS_AREA_RECTANGLE</constant>. The new coordinates shall
+be accepted and applied to hardware when the focus area control value is
+changed and also during a &VIDIOC-S-SELECTION; ioctl call, only when the focus
+area control is already set to required value.</para>
+
+<para> For the <constant>V4L2_AUTO_FOCUS_AREA_SPOT</constant> case, the selection
+rectangle <structfield> width</structfield> and <structfield>height</structfield>
+are not used, i.e. shall be set to 0 by applications and ignored by drivers for
+the &VIDIOC-S-SELECTION; ioctl and shall be ignored by applications for the
+&VIDIOC-G-SELECTION; ioctl.</para>
+   </section>
 
 </section>
diff --git a/Documentation/DocBook/media/v4l/vidioc-g-selection.xml b/Documentation/DocBook/media/v4l/vidioc-g-selection.xml
index bb04eff..87df4da 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-selection.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-selection.xml
@@ -195,6 +195,17 @@ exist no rectangle </emphasis> that satisfies the constraints.</para>
             <entry>0x0103</entry>
             <entry>The active area and all padding pixels that are inserted or modified by hardware.</entry>
 	  </row>
+	  <row>
+            <entry><constant>V4L2_SEL_TGT_AUTO_FOCUS_ACTUAL</constant></entry>
+            <entry>0x1000</entry>
+	    <entry>Actual automatic focus rectangle or spot coordinates.</entry>
+	  </row>
+	  <row>
+            <entry><constant>V4L2_SEL_TGT_AUTO_FOCUS_BOUNDS</constant></entry>
+            <entry>0x1002</entry>
+            <entry>Bounds of the automatic focus region of interest.
+	    </entry>
+	  </row>
 	</tbody>
       </tgroup>
     </table>
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 7c30d54..29b84ae 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -777,6 +777,11 @@ struct v4l2_crop {
 /* Current composing area plus all padding pixels */
 #define V4L2_SEL_TGT_COMPOSE_PADDED	0x0103
 
+/* Auto focus region of interest */
+#define V4L2_SEL_TGT_AUTO_FOCUS_ACTUAL	0x1000
+/* Auto focus region (spot coordinates) bounds */
+#define V4L2_SEL_TGT_AUTO_FOCUS_BOUNDS	0x1001
+
 /**
  * struct v4l2_selection - selection info
  * @type:	buffer type (do not use *_MPLANE types)
-- 
1.7.10

