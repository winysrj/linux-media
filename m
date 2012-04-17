Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:60154 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932192Ab2DQKKP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Apr 2012 06:10:15 -0400
Received: from euspt2 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0M2M005QQC8MZN@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 17 Apr 2012 11:09:59 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M2M009DAC8OYG@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 17 Apr 2012 11:10:00 +0100 (BST)
Date: Tue, 17 Apr 2012 12:09:53 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 12/15] V4L: Add auto focus targets to the subdev selections API
In-reply-to: <1334657396-5737-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
	g.liakhovetski@gmx.de, hdegoede@redhat.com, moinejf@free.fr,
	m.szyprowski@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, s.nawrocki@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1334657396-5737-13-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1334657396-5737-1-git-send-email-s.nawrocki@samsung.com>
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
index 4afcbbe..8a212c4 100644
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
index 208e9f0..c4ccae5 100644
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
1.7.10

