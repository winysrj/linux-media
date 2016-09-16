Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:60839 "EHLO
        lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1759135AbcIPK5X (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Sep 2016 06:57:23 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 3/8] vidioc-g-dv-timings.rst: document the new dv_timings flags
Date: Fri, 16 Sep 2016 12:57:06 +0200
Message-Id: <1474023431-32533-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1474023431-32533-1-git-send-email-hverkuil@xs4all.nl>
References: <1474023431-32533-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Document the new flags.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 .../media/uapi/v4l/vidioc-g-dv-timings.rst         | 23 ++++++++++++++++++++++
 Documentation/media/videodev2.h.rst.exceptions     |  3 +++
 2 files changed, 26 insertions(+)

diff --git a/Documentation/media/uapi/v4l/vidioc-g-dv-timings.rst b/Documentation/media/uapi/v4l/vidioc-g-dv-timings.rst
index 379f2be..79d9721 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-dv-timings.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-dv-timings.rst
@@ -424,3 +424,26 @@ EBUSY
 	  R'G'B' values use limited range (i.e. 16-235) as opposed to full
 	  range (i.e. 0-255). All formats defined in CEA-861 except for the
 	  640x480p59.94 format are CE formats.
+
+    -  .. row 8
+
+       -  ``V4L2_DV_FL_HAS_PICTURE_ASPECT``
+
+       -  If set, then the picture_aspect field is valid. Otherwise assume that
+          the pixels are square, so the picture aspect ratio is the same as the
+	  width to height ratio.
+
+    -  .. row 9
+
+       -  ``V4L2_DV_FL_HAS_CEA861_VIC``
+
+       -  If set, then the cea861_vic field is valid and contains the Video
+          Identification Code as per the CEA-861 standard.
+
+    -  .. row 10
+
+       -  ``V4L2_DV_FL_HAS_HDMI_VIC``
+
+       -  If set, then the hdmi_vic field is valid and contains the Video
+          Identification Code as per the HDMI standard (HDMI Vendor Specific
+	  InfoFrame).
diff --git a/Documentation/media/videodev2.h.rst.exceptions b/Documentation/media/videodev2.h.rst.exceptions
index 3828a29..688fe9d 100644
--- a/Documentation/media/videodev2.h.rst.exceptions
+++ b/Documentation/media/videodev2.h.rst.exceptions
@@ -274,6 +274,9 @@ replace define V4L2_DV_FL_CAN_REDUCE_FPS dv-bt-standards
 replace define V4L2_DV_FL_REDUCED_FPS dv-bt-standards
 replace define V4L2_DV_FL_HALF_LINE dv-bt-standards
 replace define V4L2_DV_FL_IS_CE_VIDEO dv-bt-standards
+replace define V4L2_DV_FL_HAS_PICTURE_ASPECT dv-bt-standards
+replace define V4L2_DV_FL_HAS_CEA861_VIC dv-bt-standards
+replace define V4L2_DV_FL_HAS_HDMI_VIC dv-bt-standards
 
 replace define V4L2_DV_BT_656_1120 dv-timing-types
 
-- 
2.8.1

