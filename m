Return-path: <mchehab@pedra>
Received: from mail-px0-f174.google.com ([209.85.212.174]:34392 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006Ab1APWWP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Jan 2011 17:22:15 -0500
Received: by pxi15 with SMTP id 15so739671pxi.19
        for <linux-media@vger.kernel.org>; Sun, 16 Jan 2011 14:22:14 -0800 (PST)
From: Pawel Osciak <pawel@osciak.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com, Pawel Osciak <pawel@osciak.com>
Subject: [PATCH] [media] Remove compatibility layer from multi-planar API documentation
Date: Sun, 16 Jan 2011 14:21:43 -0800
Message-Id: <1295216503-15535-1-git-send-email-pawel@osciak.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This feature will probably be moved to libv4l2.

Signed-off-by: Pawel Osciak <pawel@osciak.com>
---
 Documentation/DocBook/v4l/planar-apis.xml     |   35 +++++-------------------
 Documentation/DocBook/v4l/vidioc-querycap.xml |   22 +++++++--------
 2 files changed, 18 insertions(+), 39 deletions(-)

diff --git a/Documentation/DocBook/v4l/planar-apis.xml b/Documentation/DocBook/v4l/planar-apis.xml
index 8be7552..e6b5c18 100644
--- a/Documentation/DocBook/v4l/planar-apis.xml
+++ b/Documentation/DocBook/v4l/planar-apis.xml
@@ -2,10 +2,10 @@
   <title>Single- and multi-planar APIs</title>
 
   <para>Some devices require data for each input or output video frame
-  to be placed in discontiguous memory buffers. In such cases one
+  to be placed in discontiguous memory buffers. In such cases, one
   video frame has to be addressed using more than one memory address, i.e. one
-  pointer per "plane". A plane is a sub-buffer of current frame. For examples
-  of such formats see <xref linkend="pixfmt" />.</para>
+  pointer per "plane". A plane is a sub-buffer of the current frame. For
+  examples of such formats see <xref linkend="pixfmt" />.</para>
 
   <para>Initially, V4L2 API did not support multi-planar buffers and a set of
   extensions has been introduced to handle them. Those extensions constitute
@@ -14,8 +14,8 @@
   <para>Some of the V4L2 API calls and structures are interpreted differently,
   depending on whether single- or multi-planar API is being used. An application
   can choose whether to use one or the other by passing a corresponding buffer
-  type to its ioctl calls. Multi-planar versions of buffer types are suffixed with
-  an `_MPLANE' string. For a list of available multi-planar buffer types
+  type to its ioctl calls. Multi-planar versions of buffer types are suffixed
+  with an `_MPLANE' string. For a list of available multi-planar buffer types
   see &v4l2-buf-type;.
   </para>
 
@@ -24,28 +24,9 @@
     <para>Multi-planar API introduces new multi-planar formats. Those formats
     use a separate set of FourCC codes. It is important to distinguish between
     the multi-planar API and a multi-planar format. Multi-planar API calls can
-    handle all single-planar formats as well, while the single-planar API cannot
-    handle multi-planar formats. Applications do not have to switch between APIs
-    when handling both single- and multi-planar devices and should use the
-    multi-planar API version for both single- and multi-planar formats.
-    Drivers that do not support multi-planar API can still be handled with it,
-    utilizing a compatibility layer built into standard V4L2 ioctl handling.
-    </para>
-  </section>
-
-  <section>
-    <title>Single and multi-planar API compatibility layer</title>
-    <para>In most cases<footnote><para>The compatibility layer does not cover
-    drivers that do not use video_ioctl2() call.</para></footnote>, applications
-    can use the multi-planar API with older drivers that support
-    only its single-planar version and vice versa. Appropriate conversion is
-    done seamlessly for both applications and drivers in the V4L2 core. The
-    general rule of thumb is: as long as an application uses formats that
-    a driver supports, it can use either API (although use of multi-planar
-    formats is only possible with the multi-planar API). The list of formats
-    supported by a driver can be obtained using the &VIDIOC-ENUM-FMT; call.
-    It is possible, but discouraged, for a driver or an application to support
-    and use both versions of the API.</para>
+    handle all single-planar formats as well (as long as they are passed in
+    multi-planar API structures), while the single-planar API cannot
+    handle multi-planar formats.</para>
   </section>
 
   <section>
diff --git a/Documentation/DocBook/v4l/vidioc-querycap.xml b/Documentation/DocBook/v4l/vidioc-querycap.xml
index 9369976..f29f1b8 100644
--- a/Documentation/DocBook/v4l/vidioc-querycap.xml
+++ b/Documentation/DocBook/v4l/vidioc-querycap.xml
@@ -142,30 +142,28 @@ this array to zero.</entry>
 	  <row>
 	    <entry><constant>V4L2_CAP_VIDEO_CAPTURE</constant></entry>
 	    <entry>0x00000001</entry>
-	    <entry>The device supports single-planar formats through the <link
-linkend="capture">Video Capture</link> interface. An application can use either
-<link linkend="planar-apis">the single or the multi-planar API</link>.</entry>
+	    <entry>The device supports the single-planar API through the <link
+linkend="capture">Video Capture</link> interface.</entry>
 	  </row>
 	  <row>
 	    <entry><constant>V4L2_CAP_VIDEO_CAPTURE_MPLANE</constant></entry>
 	    <entry>0x00001000</entry>
-	    <entry>The device supports multi-planar formats through the <link
-linkend="capture">Video Capture</link> interface. An application has to use the
-<link linkend="planar-apis">multi-planar API</link>.</entry>
+	    <entry>The device supports the
+	    <link linkend="planar-apis">multi-planar API</link> through the
+	    <link linkend="capture">Video Capture</link> interface.</entry>
 	  </row>
 	  <row>
 	    <entry><constant>V4L2_CAP_VIDEO_OUTPUT</constant></entry>
 	    <entry>0x00000002</entry>
-	    <entry>The device supports single-planar formats through the <link
-linkend="output">Video Output</link> interface. An application can use either
-<link linkend="planar-apis">the single or the multi-planar API</link>.</entry>
+	    <entry>The device supports the single-planar API through the <link
+linkend="output">Video Output</link> interface.</entry>
 	  </row>
 	  <row>
 	    <entry><constant>V4L2_CAP_VIDEO_OUTPUT_MPLANE</constant></entry>
 	    <entry>0x00002000</entry>
-	    <entry>The device supports multi-planar formats through the <link
-linkend="output">Video Output</link> interface. An application has to use the
-<link linkend="planar-apis">multi-planar API</link>.</entry>
+	    <entry>The device supports the
+	    <link linkend="planar-apis">multi-planar API</link> through the
+	    <link linkend="output">Video Output</link> interface.</entry>
 	  </row>
 	  <row>
 	    <entry><constant>V4L2_CAP_VIDEO_OVERLAY</constant></entry>
-- 
1.7.3.5

