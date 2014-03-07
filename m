Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:3927 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753556AbaCGO0g (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Mar 2014 09:26:36 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 5/5] DocBook media: clarify v4l2_pix_format and v4l2_pix_format_mplane fields
Date: Fri,  7 Mar 2014 15:26:24 +0100
Message-Id: <1394202384-5762-6-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1394202384-5762-1-git-send-email-hverkuil@xs4all.nl>
References: <1394202384-5762-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Be more specific with regards to how some of these fields are interpreted.
In particular height vs field and which fields can be set by the application.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/pixfmt.xml | 33 +++++++++++++++++++++++-------
 1 file changed, 26 insertions(+), 7 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/pixfmt.xml b/Documentation/DocBook/media/v4l/pixfmt.xml
index f586d34..7b0b098 100644
--- a/Documentation/DocBook/media/v4l/pixfmt.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt.xml
@@ -25,7 +25,18 @@ capturing and output, for overlay frame buffer formats see also
 	<row>
 	  <entry>__u32</entry>
 	  <entry><structfield>height</structfield></entry>
-	  <entry>Image height in pixels.</entry>
+	  <entry>Image height in pixels. If <structfield>field</structfield> is
+	  one of <constant>V4L2_FIELD_TOP</constant>, <constant>V4L2_FIELD_BOTTOM</constant>
+	  or <constant>V4L2_FIELD_ALTERNATE</constant> then height refers to the
+	  number of lines in the field, otherwise it refers to the number of
+	  lines in the frame (which is twice the field height for interlaced
+	  formats). In case of conflicts between the <structfield>height</structfield>
+	  value and the <structfield>field</structfield> value, the
+	  <structfield>height</structfield> shall be the deciding factor.
+	  So if <structfield>height</structfield> is set to 480 for an NTSC-M
+	  standard, and <structfield>field</structfield> is set to
+	  <constant>V4L2_FIELD_TOP</constant>, then <structfield>field</structfield>
+	  shall be adjusted to &eg; <constant>V4L2_FIELD_INTERLACED</constant>.</entry>
 	</row>
 	<row>
 	  <entry spanname="hspan">Applications set these fields to
@@ -54,7 +65,11 @@ linkend="reserved-formats" /></entry>
 can request to capture or output only the top or bottom field, or both
 fields interlaced or sequentially stored in one buffer or alternating
 in separate buffers. Drivers return the actual field order selected.
-For details see <xref linkend="field-order" />.</entry>
+In case of conflicts between the <structfield>height</structfield> and
+<structfield>field</structfield> values, the <structfield>height</structfield>
+value will be the deciding factor. See also the description of
+<structfield>height</structfield> above.
+For more details on fields see <xref linkend="field-order" />.</entry>
 	</row>
 	<row>
 	  <entry>__u32</entry>
@@ -81,7 +96,10 @@ plane and is divided by the same factor as the
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
@@ -97,7 +115,8 @@ hold an image.</entry>
 	  <entry>&v4l2-colorspace;</entry>
 	  <entry><structfield>colorspace</structfield></entry>
 	  <entry>This information supplements the
-<structfield>pixelformat</structfield> and must be set by the driver,
+<structfield>pixelformat</structfield> and must be set by the driver for
+capture streams and by the application for output streams,
 see <xref linkend="colorspaces" />.</entry>
 	</row>
 	<row>
@@ -135,7 +154,7 @@ set this field to zero.</entry>
           <entry>__u16</entry>
           <entry><structfield>bytesperline</structfield></entry>
           <entry>Distance in bytes between the leftmost pixels in two adjacent
-            lines.</entry>
+            lines. See &v4l2-pix-format;.</entry>
         </row>
         <row>
           <entry>__u16</entry>
@@ -154,12 +173,12 @@ set this field to zero.</entry>
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

