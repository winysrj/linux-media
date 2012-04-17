Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:59161 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932096Ab2DQKKI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Apr 2012 06:10:08 -0400
Received: from euspt1 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0M2M00C0TC6Q7O@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 17 Apr 2012 11:08:51 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M2M001HPC8Q90@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 17 Apr 2012 11:10:03 +0100 (BST)
Date: Tue, 17 Apr 2012 12:09:52 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 11/15] V4L: Add auto focus targets to the selections API
In-reply-to: <1334657396-5737-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
	g.liakhovetski@gmx.de, hdegoede@redhat.com, moinejf@free.fr,
	m.szyprowski@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, s.nawrocki@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1334657396-5737-12-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1334657396-5737-1-git-send-email-s.nawrocki@samsung.com>
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
index 4a60d5f..e6f69df 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -805,6 +805,11 @@ struct v4l2_crop {
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

