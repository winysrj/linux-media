Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:8566 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658Ab0C2KDS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Mar 2010 06:03:18 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from eu_spt1 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0L0100DG9FGP1W00@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 29 Mar 2010 10:53:14 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0L0100LOQFGPQ8@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 29 Mar 2010 10:53:13 +0100 (BST)
Date: Mon, 29 Mar 2010 11:53:06 +0200
From: Kamil Debski <k.debski@samsung.com>
Subject: [PATCH/RFC 1/1] v4l: Add support for binary controls
In-reply-to: <1269856386-29557-1-git-send-email-k.debski@samsung.com>
To: linux-media@vger.kernel.org
Cc: p.osciak@samsung.com, k.debski@samsung.com,
	kyungmin.park@samsung.com
Message-id: <1269856386-29557-2-git-send-email-k.debski@samsung.com>
References: <1269856386-29557-1-git-send-email-k.debski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This control provides means to exchange raw
binary data between the user space and the driver.

Signed-off-by: Kamil Debski <k.debski@samsung.com>
Reviewed-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 Documentation/DocBook/v4l/compat.xml             |    9 ++++++++
 Documentation/DocBook/v4l/videodev2.h.xml        |    2 +
 Documentation/DocBook/v4l/vidioc-g-ext-ctrls.xml |    6 +++++
 Documentation/DocBook/v4l/vidioc-queryctrl.xml   |   23 ++++++++++++++++-----
 drivers/media/video/v4l2-common.c                |    2 +
 include/linux/videodev2.h                        |    2 +
 6 files changed, 38 insertions(+), 6 deletions(-)

diff --git a/Documentation/DocBook/v4l/compat.xml b/Documentation/DocBook/v4l/compat.xml
index b9dbdf9..83b8b64 100644
--- a/Documentation/DocBook/v4l/compat.xml
+++ b/Documentation/DocBook/v4l/compat.xml
@@ -2333,6 +2333,15 @@ more information.</para>
       </orderedlist>
     </section>
    </section>
+    <section>
+      <title>V4L2 in Linux 2.6.35</title>
+      <orderedlist>
+	<listitem>
+	  <para>Added support for binary data controls via new type <constant>V4L2_CTRL_TYPE_BINARY</constant>.</para>
+	</listitem>
+      </orderedlist>
+    </section>
+   </section>
 
    <section id="other">
      <title>Relation of V4L2 to other Linux multimedia APIs</title>
diff --git a/Documentation/DocBook/v4l/videodev2.h.xml b/Documentation/DocBook/v4l/videodev2.h.xml
index 0683259..c552134 100644
--- a/Documentation/DocBook/v4l/videodev2.h.xml
+++ b/Documentation/DocBook/v4l/videodev2.h.xml
@@ -169,6 +169,7 @@ enum <link linkend="v4l2-ctrl-type">v4l2_ctrl_type</link> {
         V4L2_CTRL_TYPE_INTEGER64     = 5,
         V4L2_CTRL_TYPE_CTRL_CLASS    = 6,
         V4L2_CTRL_TYPE_STRING        = 7,
+        V4L2_CTRL_TYPE_BINARY        = 8,
 };
 
 enum <link linkend="v4l2-tuner-type">v4l2_tuner_type</link> {
@@ -913,6 +914,7 @@ struct <link linkend="v4l2-ext-control">v4l2_ext_control</link> {
                 __s32 value;
                 __s64 value64;
                 char *string;
+		unsigned char *blob;
         };
 } __attribute__ ((packed));
 
diff --git a/Documentation/DocBook/v4l/vidioc-g-ext-ctrls.xml b/Documentation/DocBook/v4l/vidioc-g-ext-ctrls.xml
index 3aa7f8f..ab4f1c9 100644
--- a/Documentation/DocBook/v4l/vidioc-g-ext-ctrls.xml
+++ b/Documentation/DocBook/v4l/vidioc-g-ext-ctrls.xml
@@ -170,6 +170,12 @@ applications must set the array to zero.</entry>
 	    <entry><structfield>string</structfield></entry>
 	    <entry>A pointer to a string.</entry>
 	  </row>
+	  <row>
+	    <entry></entry>
+	    <entry>unsigned char *</entry>
+	    <entry><structfield>blob</structfield></entry>
+	    <entry>A pointer to a blob.</entry>
+	  </row>
 	</tbody>
       </tgroup>
     </table>
diff --git a/Documentation/DocBook/v4l/vidioc-queryctrl.xml b/Documentation/DocBook/v4l/vidioc-queryctrl.xml
index 4876ff1..d1cd5ee 100644
--- a/Documentation/DocBook/v4l/vidioc-queryctrl.xml
+++ b/Documentation/DocBook/v4l/vidioc-queryctrl.xml
@@ -142,9 +142,10 @@ bound for <constant>V4L2_CTRL_TYPE_INTEGER</constant> controls and the
 lowest valid index (always 0) for <constant>V4L2_CTRL_TYPE_MENU</constant> controls.
 For <constant>V4L2_CTRL_TYPE_STRING</constant> controls the minimum value
 gives the minimum length of the string. This length <emphasis>does not include the terminating
-zero</emphasis>. It may not be valid for any other type of control, including
-<constant>V4L2_CTRL_TYPE_INTEGER64</constant> controls. Note that this is a
-signed value.</entry>
+zero</emphasis>. For <constant>V4L2_CTRL_TYPE_BINARY</constant> controls this value
+gives the minimum length of the binary data. It may not be valid for any other type of
+ control, including <constant>V4L2_CTRL_TYPE_INTEGER64</constant> controls. Note that
+ this is a signed value.</entry>
 	  </row>
 	  <row>
 	    <entry>__s32</entry>
@@ -155,7 +156,8 @@ highest valid index for <constant>V4L2_CTRL_TYPE_MENU</constant>
 controls.
 For <constant>V4L2_CTRL_TYPE_STRING</constant> controls the maximum value
 gives the maximum length of the string. This length <emphasis>does not include the terminating
-zero</emphasis>. It may not be valid for any other type of control, including
+zero</emphasis>. For <constant>V4L2_CTRL_TYPE_BINARY</constant> controls this value
+gives the maximum length of the binary data. It may not be valid for any other type of control, including
 <constant>V4L2_CTRL_TYPE_INTEGER64</constant> controls. Note that this is a
 signed value.</entry>
 	  </row>
@@ -166,8 +168,8 @@ signed value.</entry>
 <constant>V4L2_CTRL_TYPE_INTEGER</constant> controls. For
 <constant>V4L2_CTRL_TYPE_STRING</constant> controls this field refers to
 the string length that has to be a multiple of this step size.
-It may not be valid for any other type of control, including
-<constant>V4L2_CTRL_TYPE_INTEGER64</constant>
+For <constant>V4L2_CTRL_TYPE_BINARY</constant> controls the size of the binary data has to be a multiple of this step size. It may not be valid for any other type of
+control, including <constant>V4L2_CTRL_TYPE_INTEGER64</constant>
 controls.</para><para>Generally drivers should not scale hardware
 control values. It may be necessary for example when the
 <structfield>name</structfield> or <structfield>id</structfield> imply
@@ -319,6 +321,15 @@ Which character encoding is used will depend on the string control itself and
 should be part of the control documentation.</entry>
 	  </row>
 	  <row>
+	    <entry><constant>V4L2_CTRL_TYPE_BINARY</constant></entry>
+	    <entry>&ge; 0</entry>
+	    <entry>&ge; 1</entry>
+	    <entry>&ge; 0</entry>
+	    <entry>The minimum and maximum of the binary data length. The step size
+means that the length must be (minimum + N * step) characters long for
+N &ge; 0. </entry>
+	  </row>
+	  <row>
 	    <entry><constant>V4L2_CTRL_TYPE_CTRL_CLASS</constant></entry>
 	    <entry>n/a</entry>
 	    <entry>n/a</entry>
diff --git a/drivers/media/video/v4l2-common.c b/drivers/media/video/v4l2-common.c
index 36b5cb8..cbd770e 100644
--- a/drivers/media/video/v4l2-common.c
+++ b/drivers/media/video/v4l2-common.c
@@ -158,6 +158,8 @@ int v4l2_ctrl_check(struct v4l2_ext_control *ctrl, struct v4l2_queryctrl *qctrl,
 		return -EBUSY;
 	if (qctrl->type == V4L2_CTRL_TYPE_STRING)
 		return 0;
+	if (qctrl->type == V4L2_CTRL_TYPE_BINARY)
+		return 0;
 	if (qctrl->type == V4L2_CTRL_TYPE_BUTTON ||
 	    qctrl->type == V4L2_CTRL_TYPE_INTEGER64 ||
 	    qctrl->type == V4L2_CTRL_TYPE_CTRL_CLASS)
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 3793d16..5a62c9a 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -168,6 +168,7 @@ enum v4l2_ctrl_type {
 	V4L2_CTRL_TYPE_INTEGER64     = 5,
 	V4L2_CTRL_TYPE_CTRL_CLASS    = 6,
 	V4L2_CTRL_TYPE_STRING        = 7,
+	V4L2_CTRL_TYPE_BINARY        = 8,
 };
 
 enum v4l2_tuner_type {
@@ -918,6 +919,7 @@ struct v4l2_ext_control {
 		__s32 value;
 		__s64 value64;
 		char *string;
+		unsigned char *blob;
 	};
 } __attribute__ ((packed));
 
-- 
1.6.3.3

