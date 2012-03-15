Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:30756 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031980Ab2COQy5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Mar 2012 12:54:57 -0400
Received: from euspt1 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0M0X009PRQZ8MY@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 15 Mar 2012 16:54:44 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M0X002OQQZ4O0@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 15 Mar 2012 16:54:42 +0000 (GMT)
Date: Thu, 15 Mar 2012 17:54:37 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH/RFC 23/23] V4L: Add auto focus targets to the subdev selections
 API
In-reply-to: <1331830477-12146-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, riverful.kim@samsung.com,
	kyungmin.park@samsung.com, s.nawrocki@samsung.com
Message-id: <1331830477-12146-24-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1331830477-12146-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 Documentation/DocBook/media/v4l/dev-subdev.xml     |   27 +++++++++++++++++++-
 .../media/v4l/vidioc-subdev-g-selection.xml        |   14 ++++++++--
 include/linux/v4l2-subdev.h                        |    4 +++
 3 files changed, 42 insertions(+), 3 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/dev-subdev.xml b/Documentation/DocBook/media/v4l/dev-subdev.xml
index 133fb02..9d2857b 100644
--- a/Documentation/DocBook/media/v4l/dev-subdev.xml
+++ b/Documentation/DocBook/media/v4l/dev-subdev.xml
@@ -277,7 +277,7 @@
     </section>
 
     <section>
-      <title>Selections: cropping, scaling and composition</title>
+      <title>Selections - cropping, scaling and composition</title>
 
       <para>Many sub-devices support cropping frames on their input or output
       pads (or possible even on both). Cropping is used to select the area of
@@ -330,6 +330,31 @@
     </section>
 
     <section>
+      <title>Selections - regions of interest</title>
+    <section>
+      <title>Automatic focus</title>
+
+      <para>The camera automatic focus algorithms may require configuration
+      of a region or multiple regions of interest in form of rectangle or spot
+      coordinates.</para>
+
+      <para>A single rectangle of interest is represented in &v4l2-rect;
+      by the coordinates of the top left corner and the rectangle size. Both
+      the coordinates and sizes are expressed in pixels. When the <structfield>
+      width</structfield> and <structfield>height</structfield> fields of
+      &v4l2-rect; are set to 0 the selection determines spot coordinates,
+      rather than a rectangle.</para>
+
+      <para>Auto focus rectangles are reset to their default values when the
+      output image format is modified. Drivers should use the output image size
+      as the auto focus rectangle default value, but hardware requirements may
+      prevent this.
+      </para>
+      <para>The auto focus selections on input pads are not defined.</para>
+    </section>
+    </section>
+
+    <section>
       <title>Types of selection targets</title>
 
       <section>
diff --git a/Documentation/DocBook/media/v4l/vidioc-subdev-g-selection.xml b/Documentation/DocBook/media/v4l/vidioc-subdev-g-selection.xml
index 1e3a744..6d60bb0 100644
--- a/Documentation/DocBook/media/v4l/vidioc-subdev-g-selection.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-subdev-g-selection.xml
@@ -57,8 +57,8 @@
 
     <para>The selections are used to configure various image
     processing functionality performed by the subdevs which affect the
-    image size. This currently includes cropping, scaling and
-    composition.</para>
+    image size. This currently includes cropping, scaling, composition
+    and automatic focus regions of interest.</para>
 
     <para>The selection API replaces <link
     linkend="vidioc-subdev-g-crop">the old subdev crop API</link>. All
@@ -114,6 +114,16 @@
 	    <entry>0x0102</entry>
 	    <entry>Bounds of the compose rectangle.</entry>
 	  </row>
+	  <row>
+	    <entry><constant>V4L2_SUBDEV_SEL_TGT_AUTO_FOCUS_BOUNDS</constant></entry>
+	    <entry>0x1000</entry>
+	    <entry>Bounds of the automatic focus region of interest.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>V4L2_SUBDEV_SEL_TGT_AUTO_FOCUS_ACTUAL</constant></entry>
+	    <entry>0x1001</entry>
+	    <entry>Actual automatic focus rectangle or spot coordinates.</entry>
+	  </row>
 	</tbody>
       </tgroup>
     </table>
diff --git a/include/linux/v4l2-subdev.h b/include/linux/v4l2-subdev.h
index 812019e..49b1f14 100644
--- a/include/linux/v4l2-subdev.h
+++ b/include/linux/v4l2-subdev.h
@@ -136,6 +136,10 @@ struct v4l2_subdev_frame_interval_enum {
 /* composing bounds */
 #define V4L2_SUBDEV_SEL_TGT_COMPOSE_BOUNDS		0x0102
 
+/* auto focus region of interest */
+#define V4L2_SUBDEV_SEL_TGT_AUTO_FOCUS_ACTUAL		0x1000
+/* auto focus region (spot coordinates) bounds */
+#define V4L2_SUBDEV_SEL_TGT_AUTO_FOCUS_BOUNDS		0x1001
 
 /**
  * struct v4l2_subdev_selection - selection info
-- 
1.7.9.2

