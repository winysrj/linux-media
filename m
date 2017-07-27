Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:56363 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751413AbdG0MrQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 27 Jul 2017 08:47:16 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Nicolas Dufresne <nicolas@ndufresne.ca>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] media/extended-controls.rst: fix wrong enum names
Message-ID: <55c421b4-7226-d735-723c-2ea46f83d9fb@xs4all.nl>
Date: Thu, 27 Jul 2017 14:47:10 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

MPEG4 level and profile defines were wrong. Fix this.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reported-by: Nicolas Dufresne <nicolas@ndufresne.ca>
---
diff --git a/Documentation/media/uapi/v4l/extended-controls.rst b/Documentation/media/uapi/v4l/extended-controls.rst
index 9acc9cad49e2..667ba882c4cd 100644
--- a/Documentation/media/uapi/v4l/extended-controls.rst
+++ b/Documentation/media/uapi/v4l/extended-controls.rst
@@ -942,21 +942,21 @@ enum v4l2_mpeg_video_mpeg4_level -
     :header-rows:  0
     :stub-columns: 0

-    * - ``V4L2_MPEG_VIDEO_LEVEL_0``
+    * - ``V4L2_MPEG_VIDEO_MPEG4_LEVEL_0``
       - Level 0
-    * - ``V4L2_MPEG_VIDEO_LEVEL_0B``
+    * - ``V4L2_MPEG_VIDEO_MPEG4_LEVEL_0B``
       - Level 0b
-    * - ``V4L2_MPEG_VIDEO_LEVEL_1``
+    * - ``V4L2_MPEG_VIDEO_MPEG4_LEVEL_1``
       - Level 1
-    * - ``V4L2_MPEG_VIDEO_LEVEL_2``
+    * - ``V4L2_MPEG_VIDEO_MPEG4_LEVEL_2``
       - Level 2
-    * - ``V4L2_MPEG_VIDEO_LEVEL_3``
+    * - ``V4L2_MPEG_VIDEO_MPEG4_LEVEL_3``
       - Level 3
-    * - ``V4L2_MPEG_VIDEO_LEVEL_3B``
+    * - ``V4L2_MPEG_VIDEO_MPEG4_LEVEL_3B``
       - Level 3b
-    * - ``V4L2_MPEG_VIDEO_LEVEL_4``
+    * - ``V4L2_MPEG_VIDEO_MPEG4_LEVEL_4``
       - Level 4
-    * - ``V4L2_MPEG_VIDEO_LEVEL_5``
+    * - ``V4L2_MPEG_VIDEO_MPEG4_LEVEL_5``
       - Level 5


@@ -1028,15 +1028,15 @@ enum v4l2_mpeg_video_mpeg4_profile -
     :header-rows:  0
     :stub-columns: 0

-    * - ``V4L2_MPEG_VIDEO_PROFILE_SIMPLE``
+    * - ``V4L2_MPEG_VIDEO_MPEG4_PROFILE_SIMPLE``
       - Simple profile
-    * - ``V4L2_MPEG_VIDEO_PROFILE_ADVANCED_SIMPLE``
+    * - ``V4L2_MPEG_VIDEO_MPEG4_PROFILE_ADVANCED_SIMPLE``
       - Advanced Simple profile
-    * - ``V4L2_MPEG_VIDEO_PROFILE_CORE``
+    * - ``V4L2_MPEG_VIDEO_MPEG4_PROFILE_CORE``
       - Core profile
-    * - ``V4L2_MPEG_VIDEO_PROFILE_SIMPLE_SCALABLE``
+    * - ``V4L2_MPEG_VIDEO_MPEG4_PROFILE_SIMPLE_SCALABLE``
       - Simple Scalable profile
-    * - ``V4L2_MPEG_VIDEO_PROFILE_ADVANCED_CODING_EFFICIENCY``
+    * - ``V4L2_MPEG_VIDEO_MPEG4_PROFILE_ADVANCED_CODING_EFFICIENCY``
       -
