Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44651 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934328AbbLQIlT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Dec 2015 03:41:19 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Subject: [PATCH/RFC 38/48] DocBook: media: Document the V4L2 subdev request API
Date: Thu, 17 Dec 2015 10:40:16 +0200
Message-Id: <1450341626-6695-39-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1450341626-6695-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1450341626-6695-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The V4L2 subdev request API consists in extensions to existing V4L2
subdev ioctls. Document it.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 .../DocBook/media/v4l/vidioc-subdev-g-fmt.xml      | 33 ++++++++++++++++++++--
 .../media/v4l/vidioc-subdev-g-selection.xml        | 28 ++++++++++++++++--
 2 files changed, 55 insertions(+), 6 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/vidioc-subdev-g-fmt.xml b/Documentation/DocBook/media/v4l/vidioc-subdev-g-fmt.xml
index a67cde6f8c54..2623e8f52362 100644
--- a/Documentation/DocBook/media/v4l/vidioc-subdev-g-fmt.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-subdev-g-fmt.xml
@@ -97,6 +97,13 @@
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
@@ -124,8 +131,22 @@
 	    linkend="v4l2-mbus-framefmt" /> for details.</entry>
 	  </row>
 	  <row>
+	    <entry>__u16</entry>
+	    <entry><structfield>request</structfield></entry>
+	    <entry>Request ID, only valid when the <structfield>which</structfield>
+	    field is set to <constant>V4L2_SUBDEV_FORMAT_REQUEST</constant>.
+	    Applications and drivers must set the field to zero in all other
+	    cases.</entry>
+	  </row>
+	  <row>
+	    <entry>__u16</entry>
+	    <entry><structfield>reserved2</structfield></entry>
+	    <entry>Reserved for future extensions. Applications and drivers must
+	    set the field to zero.</entry>
+	  </row>
+	  <row>
 	    <entry>__u32</entry>
-	    <entry><structfield>reserved</structfield>[8]</entry>
+	    <entry><structfield>reserved</structfield>[7]</entry>
 	    <entry>Reserved for future extensions. Applications and drivers must
 	    set the array to zero.</entry>
 	  </row>
@@ -148,6 +169,11 @@
 	    <entry>1</entry>
 	    <entry>Active formats, applied to the hardware.</entry>
 	  </row>
+	  <row>
+	    <entry>V4L2_SUBDEV_FORMAT_REQUEST</entry>
+	    <entry>1</entry>
+	    <entry>Request formats, used with the requests API.</entry>
+	  </row>
 	</tbody>
       </tgroup>
     </table>
@@ -171,8 +197,9 @@
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
index 9b59b49db0c3..f1f6a31baa63 100644
--- a/Documentation/DocBook/media/v4l/vidioc-subdev-g-selection.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-subdev-g-selection.xml
@@ -100,6 +100,13 @@
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
@@ -160,8 +167,22 @@
 	    <entry>Selection rectangle, in pixels.</entry>
 	  </row>
 	  <row>
+	    <entry>__u16</entry>
+	    <entry><structfield>request</structfield></entry>
+	    <entry>Request ID, only valid when the <structfield>which</structfield>
+	    field is set to <constant>V4L2_SUBDEV_FORMAT_REQUEST</constant>.
+	    Applications and drivers must set the field to zero in all other
+	    cases.</entry>
+	  </row>
+	  <row>
+	    <entry>__u16</entry>
+	    <entry><structfield>reserved2</structfield></entry>
+	    <entry>Reserved for future extensions. Applications and drivers must
+	    set the field to zero.</entry>
+	  </row>
+	  <row>
 	    <entry>__u32</entry>
-	    <entry><structfield>reserved</structfield>[8]</entry>
+	    <entry><structfield>reserved</structfield>[7]</entry>
 	    <entry>Reserved for future extensions. Applications and drivers must
 	    set the array to zero.</entry>
 	  </row>
@@ -193,8 +214,9 @@
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
2.4.10

