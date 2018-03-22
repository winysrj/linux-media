Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:58828 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752266AbeCVLDl (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Mar 2018 07:03:41 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Pavel Machek <pavel@ucw.cz>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Smitha T Murthy <smitha.t@samsung.com>,
        Tom Saeger <tom.saeger@oracle.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH] media: extended-controls.rst: don't use adjustbox
Date: Thu, 22 Mar 2018 07:03:26 -0400
Message-Id: <575c29bc9d9e37debffb01ee83dcb625f71e929a.1521716601.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

LaTeX adjustbox is known to cause pdf documentation build breakages
with some newer Sphinx versions. So, don't use it.

While here, adjust table sizes in order to better produce the
pdf output.

Fixes: c0da55b95bd9 ("media: v4l2: Documentation for HEVC CIDs")
Cc: Smitha T Murthy <smitha.t@samsung.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/v4l/extended-controls.rst | 42 +++++++++++-----------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/Documentation/media/uapi/v4l/extended-controls.rst b/Documentation/media/uapi/v4l/extended-controls.rst
index 23d13be44001..d5f3eb6e674a 100644
--- a/Documentation/media/uapi/v4l/extended-controls.rst
+++ b/Documentation/media/uapi/v4l/extended-controls.rst
@@ -2011,9 +2011,9 @@ enum v4l2_mpeg_video_hevc_hier_coding_type -
 
 .. raw:: latex
 
-    \begin{adjustbox}{width=\columnwidth}
+    \footnotesize
 
-.. tabularcolumns:: |p{11.0cm}|p{10.0cm}|
+.. tabularcolumns:: |p{9.0cm}|p{8.0cm}|
 
 .. flat-table::
     :header-rows:  0
@@ -2026,7 +2026,7 @@ enum v4l2_mpeg_video_hevc_hier_coding_type -
 
 .. raw:: latex
 
-    \end{adjustbox}
+    \normalsize
 
 
 ``V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_LAYER (integer)``
@@ -2080,9 +2080,9 @@ enum v4l2_mpeg_video_hevc_profile -
 
 .. raw:: latex
 
-    \begin{adjustbox}{width=\columnwidth}
+    \footnotesize
 
-.. tabularcolumns:: |p{11.0cm}|p{10.0cm}|
+.. tabularcolumns:: |p{9.0cm}|p{8.0cm}|
 
 .. flat-table::
     :header-rows:  0
@@ -2097,7 +2097,7 @@ enum v4l2_mpeg_video_hevc_profile -
 
 .. raw:: latex
 
-    \end{adjustbox}
+    \normalsize
 
 
 .. _v4l2-hevc-level:
@@ -2110,9 +2110,9 @@ enum v4l2_mpeg_video_hevc_level -
 
 .. raw:: latex
 
-    \begin{adjustbox}{width=\columnwidth}
+    \footnotesize
 
-.. tabularcolumns:: |p{11.0cm}|p{10.0cm}|
+.. tabularcolumns:: |p{9.0cm}|p{8.0cm}|
 
 .. flat-table::
     :header-rows:  0
@@ -2147,7 +2147,7 @@ enum v4l2_mpeg_video_hevc_level -
 
 .. raw:: latex
 
-    \end{adjustbox}
+    \normalsize
 
 
 ``V4L2_CID_MPEG_VIDEO_HEVC_FRAME_RATE_RESOLUTION (integer)``
@@ -2169,9 +2169,9 @@ enum v4l2_mpeg_video_hevc_tier -
 
 .. raw:: latex
 
-    \begin{adjustbox}{width=\columnwidth}
+    \footnotesize
 
-.. tabularcolumns:: |p{11.0cm}|p{10.0cm}|
+.. tabularcolumns:: |p{9.0cm}|p{8.0cm}|
 
 .. flat-table::
     :header-rows:  0
@@ -2184,7 +2184,7 @@ enum v4l2_mpeg_video_hevc_tier -
 
 .. raw:: latex
 
-    \end{adjustbox}
+    \normalsize
 
 
 ``V4L2_CID_MPEG_VIDEO_HEVC_MAX_PARTITION_DEPTH (integer)``
@@ -2200,9 +2200,9 @@ enum v4l2_mpeg_video_hevc_loop_filter_mode -
 
 .. raw:: latex
 
-    \begin{adjustbox}{width=\columnwidth}
+    \footnotesize
 
-.. tabularcolumns:: |p{11.0cm}|p{10.0cm}|
+.. tabularcolumns:: |p{10.7cm}|p{6.3cm}|
 
 .. flat-table::
     :header-rows:  0
@@ -2217,7 +2217,7 @@ enum v4l2_mpeg_video_hevc_loop_filter_mode -
 
 .. raw:: latex
 
-    \end{adjustbox}
+    \normalsize
 
 
 ``V4L2_CID_MPEG_VIDEO_HEVC_LF_BETA_OFFSET_DIV2 (integer)``
@@ -2238,9 +2238,9 @@ enum v4l2_mpeg_video_hevc_hier_refresh_type -
 
 .. raw:: latex
 
-    \begin{adjustbox}{width=\columnwidth}
+    \footnotesize
 
-.. tabularcolumns:: |p{11.0cm}|p{10.0cm}|
+.. tabularcolumns:: |p{8.0cm}|p{9.0cm}|
 
 .. flat-table::
     :header-rows:  0
@@ -2255,7 +2255,7 @@ enum v4l2_mpeg_video_hevc_hier_refresh_type -
 
 .. raw:: latex
 
-    \end{adjustbox}
+    \normalsize
 
 
 ``V4L2_CID_MPEG_VIDEO_HEVC_REFRESH_PERIOD (integer)``
@@ -2318,9 +2318,9 @@ enum v4l2_mpeg_video_hevc_size_of_length_field -
 
 .. raw:: latex
 
-    \begin{adjustbox}{width=\columnwidth}
+    \footnotesize
 
-.. tabularcolumns:: |p{11.0cm}|p{10.0cm}|
+.. tabularcolumns:: |p{6.0cm}|p{11.0cm}|
 
 .. flat-table::
     :header-rows:  0
@@ -2337,7 +2337,7 @@ enum v4l2_mpeg_video_hevc_size_of_length_field -
 
 .. raw:: latex
 
-    \end{adjustbox}
+    \normalsize
 
 ``V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L0_BR (integer)``
     Indicates bit rate for hierarchical coding layer 0 for HEVC encoder.
-- 
2.14.3
