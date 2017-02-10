Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:53428 "EHLO
        lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751390AbdBJIXo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Feb 2017 03:23:44 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] vidioc-g-dv-timings.rst: update v4l2_bt_timings struct
Message-ID: <5c1e1e86-12be-d600-4bd0-a9eafb72cd26@xs4all.nl>
Date: Fri, 10 Feb 2017 09:19:14 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The new picture_aspect, cea861_vic and hdmi_vic fields were not documented,
even though the corresponding flags were.

Add documentation for these new fields.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/Documentation/media/uapi/v4l/vidioc-g-dv-timings.rst b/Documentation/media/uapi/v4l/vidioc-g-dv-timings.rst
index aea276502f5e..e573c74138de 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-dv-timings.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-dv-timings.rst
@@ -146,8 +146,20 @@ EBUSY
       - ``flags``
       - Several flags giving more information about the format. See
 	:ref:`dv-bt-flags` for a description of the flags.
-    * - __u32
-      - ``reserved[14]``
+    * - struct :c:type:`v4l2_fract`
+      - ``picture_aspect``
+      - The picture aspect if the pixels are not square. Only valid if the
+        ``V4L2_DV_FL_HAS_PICTURE_ASPECT`` flag is set.
+    * - __u8
+      - ``cea861_vic``
+      - The Video Identification Code according to the CEA-861 standard.
+        Only valid if the ``V4L2_DV_FL_HAS_CEA861_VIC`` flag is set.
+    * - __u8
+      - ``hdmi_vic``
+      - The Video Identification Code according to the HDMI standard.
+        Only valid if the ``V4L2_DV_FL_HAS_HDMI_VIC`` flag is set.
+    * - __u8
+      - ``reserved[46]``
       - Reserved for future extensions. Drivers and applications must set
 	the array to zero.

