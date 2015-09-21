Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:51699 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756468AbbIUJgz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Sep 2015 05:36:55 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: ricardo.ribalda@gmail.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 2/2] DocBook/media: clarify control documentation
Date: Mon, 21 Sep 2015 11:36:42 +0200
Message-Id: <1442828202-25578-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1442828202-25578-1-git-send-email-hverkuil@xs4all.nl>
References: <1442828202-25578-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

- Add missing V4L2_CTRL_TYPE_U32 documentation
- Remove 'which are actually different on the hardware' sentence which
  is confusing. I think the idea was to let the user know that the step can
  be different for different hardware, but that's obvious because otherwise
  you wouldn't need to specify the step value.
- Clarify that V4L2_CTRL_COMPOUND_TYPES also applies to arrays.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 .../DocBook/media/v4l/vidioc-g-ext-ctrls.xml        |  7 +++++++
 .../DocBook/media/v4l/vidioc-queryctrl.xml          | 21 ++++++++++++++++-----
 2 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml b/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
index c5bdbfc..842536a 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
@@ -200,6 +200,13 @@ Valid if this control is of type <constant>V4L2_CTRL_TYPE_U16</constant>.</entry
 	  </row>
 	  <row>
 	    <entry></entry>
+	    <entry>__u32 *</entry>
+	    <entry><structfield>p_u32</structfield></entry>
+	    <entry>A pointer to a matrix control of unsigned 32-bit values.
+Valid if this control is of type <constant>V4L2_CTRL_TYPE_U32</constant>.</entry>
+	  </row>
+	  <row>
+	    <entry></entry>
 	    <entry>void *</entry>
 	    <entry><structfield>ptr</structfield></entry>
 	    <entry>A pointer to a compound type which can be an N-dimensional array and/or a
diff --git a/Documentation/DocBook/media/v4l/vidioc-queryctrl.xml b/Documentation/DocBook/media/v4l/vidioc-queryctrl.xml
index 6ec39c6..55b7582 100644
--- a/Documentation/DocBook/media/v4l/vidioc-queryctrl.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-queryctrl.xml
@@ -101,8 +101,9 @@ prematurely end the enumeration).</para></footnote></para>
 next supported non-compound control, or <errorcode>EINVAL</errorcode>
 if there is none. In addition, the <constant>V4L2_CTRL_FLAG_NEXT_COMPOUND</constant>
 flag can be specified to enumerate all compound controls (i.e. controls
-with type &ge; <constant>V4L2_CTRL_COMPOUND_TYPES</constant>). Specify both
-<constant>V4L2_CTRL_FLAG_NEXT_CTRL</constant> and
+with type &ge; <constant>V4L2_CTRL_COMPOUND_TYPES</constant> and/or array
+control, in other words controls that contain more than one value).
+Specify both <constant>V4L2_CTRL_FLAG_NEXT_CTRL</constant> and
 <constant>V4L2_CTRL_FLAG_NEXT_COMPOUND</constant> in order to enumerate
 all controls, compound or not. Drivers which do not support these flags yet
 always return <errorcode>EINVAL</errorcode>.</para>
@@ -422,7 +423,7 @@ the array to zero.</entry>
 	    <entry>any</entry>
 	    <entry>An integer-valued control ranging from minimum to
 maximum inclusive. The step value indicates the increment between
-values which are actually different on the hardware.</entry>
+values.</entry>
 	  </row>
 	  <row>
 	    <entry><constant>V4L2_CTRL_TYPE_BOOLEAN</constant></entry>
@@ -518,7 +519,7 @@ Older drivers which do not support this feature return an
 	    <entry>any</entry>
 	    <entry>An unsigned 8-bit valued control ranging from minimum to
 maximum inclusive. The step value indicates the increment between
-values which are actually different on the hardware.
+values.
 </entry>
 	  </row>
 	  <row>
@@ -528,7 +529,17 @@ values which are actually different on the hardware.
 	    <entry>any</entry>
 	    <entry>An unsigned 16-bit valued control ranging from minimum to
 maximum inclusive. The step value indicates the increment between
-values which are actually different on the hardware.
+values.
+</entry>
+	  </row>
+	  <row>
+	    <entry><constant>V4L2_CTRL_TYPE_U32</constant></entry>
+	    <entry>any</entry>
+	    <entry>any</entry>
+	    <entry>any</entry>
+	    <entry>An unsigned 32-bit valued control ranging from minimum to
+maximum inclusive. The step value indicates the increment between
+values.
 </entry>
 	  </row>
 	</tbody>
-- 
2.5.3

