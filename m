Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:40517 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755443AbcEXQvC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 24 May 2016 12:51:02 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	mchehab@osg.samsung.com,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Subject: [RFC v2 19/21] DocBook: media: Document the V4L2 subdev request API
Date: Tue, 24 May 2016 19:47:29 +0300
Message-Id: <1464108451-28142-20-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1464108451-28142-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1464108451-28142-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

The V4L2 subdev request API consists in extensions to existing V4L2
subdev ioctls. Document it.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 .../DocBook/media/v4l/vidioc-subdev-g-fmt.xml      | 27 +++++++++++++++++++---
 .../media/v4l/vidioc-subdev-g-selection.xml        | 24 +++++++++++++++----
 2 files changed, 44 insertions(+), 7 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/vidioc-subdev-g-fmt.xml b/Documentation/DocBook/media/v4l/vidioc-subdev-g-fmt.xml
index 781089c..5cf6d89 100644
--- a/Documentation/DocBook/media/v4l/vidioc-subdev-g-fmt.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-subdev-g-fmt.xml
@@ -91,6 +91,13 @@
     low-pass noise filter might crop pixels at the frame boundaries, modifying
     its output frame size.</para>
 
+    <para>Applications can get and set formats stored in a request by setting
+    the <structfield>which</structfield> field to
+    <constant>V4L2_SUBDEV_FORMAT_REQUEST</constant> and the
+    <structfield>request</structfield> to the request ID. See
+    <xref linkend="v4l2-requests" /> for more information about the request
+    API.</para>
+
     <para>Drivers must not return an error solely because the requested format
     doesn't match the device capabilities. They must instead modify the format
     to match what the hardware can provide. The modified format should be as
@@ -119,7 +126,15 @@
 	  </row>
 	  <row>
 	    <entry>__u32</entry>
-	    <entry><structfield>reserved</structfield>[8]</entry>
+	    <entry><structfield>request</structfield></entry>
+	    <entry>Request ID, only valid when the <structfield>which</structfield>
+	    field is set to <constant>V4L2_SUBDEV_FORMAT_REQUEST</constant>.
+	    Applications and drivers must set the field to zero in all other
+	    cases.</entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>reserved</structfield>[7]</entry>
 	    <entry>Reserved for future extensions. Applications and drivers must
 	    set the array to zero.</entry>
 	  </row>
@@ -142,6 +157,11 @@
 	    <entry>1</entry>
 	    <entry>Active formats, applied to the hardware.</entry>
 	  </row>
+	  <row>
+	    <entry>V4L2_SUBDEV_FORMAT_REQUEST</entry>
+	    <entry>2</entry>
+	    <entry>Request formats, used with the requests API.</entry>
+	  </row>
 	</tbody>
       </tgroup>
     </table>
@@ -165,8 +185,9 @@
 	<term><errorcode>EINVAL</errorcode></term>
 	<listitem>
 	  <para>The &v4l2-subdev-format; <structfield>pad</structfield>
-	  references a non-existing pad, or the <structfield>which</structfield>
-	  field references a non-existing format.</para>
+	  references a non-existing pad, the <structfield>which</structfield>
+	  field references a non-existing format or the request ID references
+	  a nonexistant request.</para>
 	</listitem>
       </varlistentry>
     </variablelist>
diff --git a/Documentation/DocBook/media/v4l/vidioc-subdev-g-selection.xml b/Documentation/DocBook/media/v4l/vidioc-subdev-g-selection.xml
index faac955..c0fbfbe 100644
--- a/Documentation/DocBook/media/v4l/vidioc-subdev-g-selection.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-subdev-g-selection.xml
@@ -94,6 +94,13 @@
     handle. Two applications querying the same sub-device would thus not
     interfere with each other.</para>
 
+    <para>Applications can get and set selection rectangles stored in a request
+    by setting the <structfield>which</structfield> field to
+    <constant>V4L2_SUBDEV_FORMAT_REQUEST</constant> and the
+    <structfield>request</structfield> to the request ID. See
+    <xref linkend="v4l2-requests" /> for more information about the request
+    API.</para>
+
     <para>Drivers must not return an error solely because the requested
     selection rectangle doesn't match the device capabilities. They must instead
     modify the rectangle to match what the hardware can provide. The modified
@@ -128,7 +135,7 @@
 	  <row>
 	    <entry>__u32</entry>
 	    <entry><structfield>which</structfield></entry>
-	    <entry>Active or try selection, from
+	    <entry>Selection to be modified, from
 	    &v4l2-subdev-format-whence;.</entry>
 	  </row>
 	  <row>
@@ -155,7 +162,15 @@
 	  </row>
 	  <row>
 	    <entry>__u32</entry>
-	    <entry><structfield>reserved</structfield>[8]</entry>
+	    <entry><structfield>request</structfield></entry>
+	    <entry>Request ID, only valid when the <structfield>which</structfield>
+	    field is set to <constant>V4L2_SUBDEV_FORMAT_REQUEST</constant>.
+	    Applications and drivers must set the field to zero in all other
+	    cases.</entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>reserved</structfield>[7]</entry>
 	    <entry>Reserved for future extensions. Applications and drivers must
 	    set the array to zero.</entry>
 	  </row>
@@ -187,8 +202,9 @@
 	  <para>The &v4l2-subdev-selection;
 	  <structfield>pad</structfield> references a non-existing
 	  pad, the <structfield>which</structfield> field references a
-	  non-existing format, or the selection target is not
-	  supported on the given subdev pad.</para>
+	  non-existing format, the selection target is not supported on
+	  the given subdev pad or the request ID references a nonexistant
+	  request.</para>
 	</listitem>
       </varlistentry>
     </variablelist>
-- 
1.9.1

