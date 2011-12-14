Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:39415 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753848Ab1LNOmu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Dec 2011 09:42:50 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt2 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LW700F2S7JBB270@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 14 Dec 2011 14:42:47 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LW700MO47JBZI@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 14 Dec 2011 14:42:47 +0000 (GMT)
Date: Wed, 14 Dec 2011 15:42:42 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v4 1/2] v4l: Add new alpha component control
In-reply-to: <1323873763-4491-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	m.szyprowski@samsung.com, jonghun.han@samsung.com,
	riverful.kim@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1323873763-4491-2-git-send-email-s.nawrocki@samsung.com>
References: <4EE8A5D6.4030408@samsung.com>
 <1323873763-4491-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The V4L2_CID_ALPHA_COMPONENT control is intended for the video capture
or memory-to-memory devices that are capable of setting up the per-pixel
alpha component to some arbitrary value. It allows to set the alpha
component for all pixels to an arbitrary value.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
There is no changes in this patch since v3.
---
 Documentation/DocBook/media/v4l/compat.xml         |   11 ++++++++
 Documentation/DocBook/media/v4l/controls.xml       |   25 +++++++++++++++----
 .../DocBook/media/v4l/pixfmt-packed-rgb.xml        |    7 ++++-
 drivers/media/video/v4l2-ctrls.c                   |    1 +
 include/linux/videodev2.h                          |    6 ++--
 5 files changed, 39 insertions(+), 11 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/compat.xml b/Documentation/DocBook/media/v4l/compat.xml
index 8b44a43..12ba262 100644
--- a/Documentation/DocBook/media/v4l/compat.xml
+++ b/Documentation/DocBook/media/v4l/compat.xml
@@ -2379,6 +2379,17 @@ that used it. It was originally scheduled for removal in 2.6.35.
       </orderedlist>
     </section>
 
+    <section>
+      <title>V4L2 in Linux 3.3</title>
+      <orderedlist>
+        <listitem>
+	  <para>Added <constant>V4L2_CID_ALPHA_COMPONENT</constant> control
+	    to the <link linkend="control">User controls class</link>.
+	  </para>
+        </listitem>
+      </orderedlist>
+    </section>
+
     <section id="other">
       <title>Relation of V4L2 to other Linux multimedia APIs</title>
 
diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index 9e72f07..60387d4 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -324,12 +324,6 @@ minimum value disables backlight compensation.</entry>
 		(usually a microscope).</entry>
 	  </row>
 	  <row>
-	    <entry><constant>V4L2_CID_LASTP1</constant></entry>
-	    <entry></entry>
-	    <entry>End of the predefined control IDs (currently
-<constant>V4L2_CID_ILLUMINATORS_2</constant> + 1).</entry>
-	  </row>
-	  <row>
 	    <entry><constant>V4L2_CID_MIN_BUFFERS_FOR_CAPTURE</constant></entry>
 	    <entry>integer</entry>
 	    <entry>This is a read-only control that can be read by the application
@@ -345,6 +339,25 @@ and used as a hint to determine the number of OUTPUT buffers to pass to REQBUFS.
 The value is the minimum number of OUTPUT buffers that is necessary for hardware
 to work.</entry>
 	  </row>
+	  <row id="v4l2-alpha-component">
+	    <entry><constant>V4L2_CID_ALPHA_COMPONENT</constant></entry>
+	    <entry>integer</entry>
+	    <entry> Sets the alpha color component on the capture device or on
+	    the capture buffer queue of a mem-to-mem device. When a mem-to-mem
+	    device produces frame format that includes an alpha component
+	    (e.g. <link linkend="rgb-formats">packed RGB image formats</link>)
+	    and the alpha value is not defined by the mem-to-mem input data
+	    this control lets you select the alpha component value of all
+	    pixels. It is applicable to any pixel format that contains an alpha
+	    component.
+	    </entry>
+	  </row>
+	  <row>
+	    <entry><constant>V4L2_CID_LASTP1</constant></entry>
+	    <entry></entry>
+	    <entry>End of the predefined control IDs (currently
+	      <constant>V4L2_CID_ALPHA_COMPONENT</constant> + 1).</entry>
+	  </row>
 	  <row>
 	    <entry><constant>V4L2_CID_PRIVATE_BASE</constant></entry>
 	    <entry></entry>
diff --git a/Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml b/Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml
index ba56536..166c8d6 100644
--- a/Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml
@@ -428,8 +428,11 @@ colorspace <constant>V4L2_COLORSPACE_SRGB</constant>.</para>
     <para>Bit 7 is the most significant bit. The value of a = alpha
 bits is undefined when reading from the driver, ignored when writing
 to the driver, except when alpha blending has been negotiated for a
-<link linkend="overlay">Video Overlay</link> or <link
-linkend="osd">Video Output Overlay</link>.</para>
+<link linkend="overlay">Video Overlay</link> or <link linkend="osd">
+Video Output Overlay</link> or when alpha component has been configured
+for a <link linkend="capture">Video Capture</link> by means of <link
+linkend="v4l2-alpha-component"> <constant>V4L2_CID_ALPHA_COMPONENT
+</constant> </link> control.</para>
 
     <example>
       <title><constant>V4L2_PIX_FMT_BGR24</constant> 4 &times; 4 pixel
diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index 0f415da..3926615 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -467,6 +467,7 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_ILLUMINATORS_2:		return "Illuminator 2";
 	case V4L2_CID_MIN_BUFFERS_FOR_CAPTURE:	return "Minimum Number of Capture Buffers";
 	case V4L2_CID_MIN_BUFFERS_FOR_OUTPUT:	return "Minimum Number of Output Buffers";
+	case V4L2_CID_ALPHA_COMPONENT:		return "Alpha Component";
 
 	/* MPEG controls */
 	/* Keep the order of the 'case's the same as in videodev2.h! */
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 4b752d5..fdda200 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -1204,10 +1204,10 @@ enum v4l2_colorfx {
 #define V4L2_CID_MIN_BUFFERS_FOR_CAPTURE	(V4L2_CID_BASE+39)
 #define V4L2_CID_MIN_BUFFERS_FOR_OUTPUT		(V4L2_CID_BASE+40)
 
-/* last CID + 1 */
-#define V4L2_CID_LASTP1                         (V4L2_CID_BASE+41)
+#define V4L2_CID_ALPHA_COMPONENT		(V4L2_CID_BASE+41)
 
-/* Minimum number of buffer neede by the device */
+/* last CID + 1 */
+#define V4L2_CID_LASTP1                         (V4L2_CID_BASE+42)
 
 /*  MPEG-class control IDs defined by V4L2 */
 #define V4L2_CID_MPEG_BASE 			(V4L2_CTRL_CLASS_MPEG | 0x900)
-- 
1.7.8

