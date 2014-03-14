Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:2856 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753257AbaCNL5X (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Mar 2014 07:57:23 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH for v3.15 2/2] DocBook media: clarify v4l2_pix_format and v4l2_pix_format_mplane fields
Date: Fri, 14 Mar 2014 12:57:07 +0100
Message-Id: <1394798227-3708-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1394798227-3708-1-git-send-email-hverkuil@xs4all.nl>
References: <1394798227-3708-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Be more specific with regards to how some of these fields are interpreted.
In particular the height value and which fields can be set by the application.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/pixfmt.xml | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/pixfmt.xml b/Documentation/DocBook/media/v4l/pixfmt.xml
index f535d9b..ea514d6 100644
--- a/Documentation/DocBook/media/v4l/pixfmt.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt.xml
@@ -25,7 +25,12 @@ capturing and output, for overlay frame buffer formats see also
 	<row>
 	  <entry>__u32</entry>
 	  <entry><structfield>height</structfield></entry>
-	  <entry>Image height in pixels.</entry>
+	  <entry>Image height in pixels. If <structfield>field</structfield> is
+	  one of <constant>V4L2_FIELD_TOP</constant>, <constant>V4L2_FIELD_BOTTOM</constant>
+	  or <constant>V4L2_FIELD_ALTERNATE</constant> then height refers to the
+	  number of lines in the field, otherwise it refers to the number of
+	  lines in the frame (which is twice the field height for interlaced
+	  formats).</entry>
 	</row>
 	<row>
 	  <entry spanname="hspan">Applications set these fields to
@@ -54,7 +59,7 @@ linkend="reserved-formats" /></entry>
 can request to capture or output only the top or bottom field, or both
 fields interlaced or sequentially stored in one buffer or alternating
 in separate buffers. Drivers return the actual field order selected.
-For details see <xref linkend="field-order" />.</entry>
+For more details on fields see <xref linkend="field-order" />.</entry>
 	</row>
 	<row>
 	  <entry>__u32</entry>
@@ -81,7 +86,10 @@ plane and is divided by the same factor as the
 example the Cb and Cr planes of a YUV 4:2:0 image have half as many
 padding bytes following each line as the Y plane. To avoid ambiguities
 drivers must return a <structfield>bytesperline</structfield> value
-rounded up to a multiple of the scale factor.</para></entry>
+rounded up to a multiple of the scale factor.</para>
+<para>For compressed formats the <structfield>bytesperline</structfield>
+value makes no sense. Applications and drivers must set this to 0 in
+that case.</para></entry>
 	</row>
 	<row>
 	  <entry>__u32</entry>
@@ -97,7 +105,8 @@ hold an image.</entry>
 	  <entry>&v4l2-colorspace;</entry>
 	  <entry><structfield>colorspace</structfield></entry>
 	  <entry>This information supplements the
-<structfield>pixelformat</structfield> and must be set by the driver,
+<structfield>pixelformat</structfield> and must be set by the driver for
+capture streams and by the application for output streams,
 see <xref linkend="colorspaces" />.</entry>
 	</row>
 	<row>
@@ -135,7 +144,7 @@ set this field to zero.</entry>
           <entry>__u16</entry>
           <entry><structfield>bytesperline</structfield></entry>
           <entry>Distance in bytes between the leftmost pixels in two adjacent
-            lines.</entry>
+            lines. See &v4l2-pix-format;.</entry>
         </row>
         <row>
           <entry>__u16</entry>
@@ -154,12 +163,12 @@ set this field to zero.</entry>
         <row>
           <entry>__u32</entry>
           <entry><structfield>width</structfield></entry>
-          <entry>Image width in pixels.</entry>
+          <entry>Image width in pixels. See &v4l2-pix-format;.</entry>
         </row>
         <row>
           <entry>__u32</entry>
           <entry><structfield>height</structfield></entry>
-          <entry>Image height in pixels.</entry>
+          <entry>Image height in pixels. See &v4l2-pix-format;.</entry>
         </row>
         <row>
           <entry>__u32</entry>
-- 
1.9.0

