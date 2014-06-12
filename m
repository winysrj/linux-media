Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:3253 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933278AbaFLLyq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jun 2014 07:54:46 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, s.nawrocki@samsung.com,
	sakari.ailus@iki.fi, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv4 PATCH 24/34] DocBook media: document new u8 and u16 control types.
Date: Thu, 12 Jun 2014 13:52:56 +0200
Message-Id: <3c18c7c79a46b5333f98e60a643e390e998950d3.1402573818.git.hans.verkuil@cisco.com>
In-Reply-To: <1402573986-20794-1-git-send-email-hverkuil@xs4all.nl>
References: <1402573986-20794-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <971e25ca71923ba77526326f998227fdfb30f216.1402573818.git.hans.verkuil@cisco.com>
References: <971e25ca71923ba77526326f998227fdfb30f216.1402573818.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

These types are needed for the upcoming Motion Detection matrix
controls, so document them.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 .../DocBook/media/v4l/vidioc-g-ext-ctrls.xml       | 14 +++++++++++++
 .../DocBook/media/v4l/vidioc-queryctrl.xml         | 23 +++++++++++++++++++++-
 2 files changed, 36 insertions(+), 1 deletion(-)

diff --git a/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml b/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
index 2a157b3..c5bdbfc 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
@@ -186,6 +186,20 @@ type <constant>V4L2_CTRL_TYPE_STRING</constant>.</entry>
 	  </row>
 	  <row>
 	    <entry></entry>
+	    <entry>__u8 *</entry>
+	    <entry><structfield>p_u8</structfield></entry>
+	    <entry>A pointer to a matrix control of unsigned 8-bit values.
+Valid if this control is of type <constant>V4L2_CTRL_TYPE_U8</constant>.</entry>
+	  </row>
+	  <row>
+	    <entry></entry>
+	    <entry>__u16 *</entry>
+	    <entry><structfield>p_u16</structfield></entry>
+	    <entry>A pointer to a matrix control of unsigned 16-bit values.
+Valid if this control is of type <constant>V4L2_CTRL_TYPE_U16</constant>.</entry>
+	  </row>
+	  <row>
+	    <entry></entry>
 	    <entry>void *</entry>
 	    <entry><structfield>ptr</structfield></entry>
 	    <entry>A pointer to a compound type which can be an N-dimensional array and/or a
diff --git a/Documentation/DocBook/media/v4l/vidioc-queryctrl.xml b/Documentation/DocBook/media/v4l/vidioc-queryctrl.xml
index 30c4e8a..0dcb0af 100644
--- a/Documentation/DocBook/media/v4l/vidioc-queryctrl.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-queryctrl.xml
@@ -289,7 +289,8 @@ accepts values 0-511 and the driver reports 0-65535, step should be
 	    <entry>The default value of a
 <constant>V4L2_CTRL_TYPE_INTEGER</constant>, <constant>_INTEGER64</constant>,
 <constant>_BOOLEAN</constant>, <constant>_BITMASK</constant>,
-<constant>_MENU</constant> or <constant>_INTEGER_MENU</constant> control.
+<constant>_MENU</constant>, <constant>_INTEGER_MENU</constant>,
+<constant>_U8</constant> or <constant>_U16</constant> control.
 Not valid for other types of controls.
 Note that drivers reset controls to their default value only when the
 driver is first loaded, never afterwards.
@@ -510,6 +511,26 @@ ioctl returns the name of the control class and this control type.
 Older drivers which do not support this feature return an
 &EINVAL;.</entry>
 	  </row>
+	  <row>
+	    <entry><constant>V4L2_CTRL_TYPE_U8</constant></entry>
+	    <entry>any</entry>
+	    <entry>any</entry>
+	    <entry>any</entry>
+	    <entry>An unsigned 8-bit valued control ranging from minimum to
+maximum inclusive. The step value indicates the increment between
+values which are actually different on the hardware. This type is only used
+in array controls.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>V4L2_CTRL_TYPE_U16</constant></entry>
+	    <entry>any</entry>
+	    <entry>any</entry>
+	    <entry>any</entry>
+	    <entry>An unsigned 16-bit valued control ranging from minimum to
+maximum inclusive. The step value indicates the increment between
+values which are actually different on the hardware. This type is only used
+in array controls.</entry>
+	  </row>
 	</tbody>
       </tgroup>
     </table>
-- 
2.0.0.rc0

