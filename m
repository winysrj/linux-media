Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:52294 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726430AbeIARGk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 1 Sep 2018 13:06:40 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] videodev2.h.rst.exceptions: add
 V4L2_DV_FL_CAN_DETECT_REDUCED_FPS
Message-ID: <72adfe8d-359d-57b7-5d3d-3f84bf5a68c9@xs4all.nl>
Date: Sat, 1 Sep 2018 14:54:37 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This fixes a documentation warning:

Documentation/output/videodev2.h.rst:6: WARNING: undefined label: v4l2-dv-fl-can-detect-reduced-fps (if the link has no caption the label
must precede a section header)

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/media/videodev2.h.rst.exceptions | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/media/videodev2.h.rst.exceptions b/Documentation/media/videodev2.h.rst.exceptions
index ca9f0edc579e..63fa131729c0 100644
--- a/Documentation/media/videodev2.h.rst.exceptions
+++ b/Documentation/media/videodev2.h.rst.exceptions
@@ -278,6 +278,7 @@ replace define V4L2_DV_BT_STD_SDI dv-bt-standards

 replace define V4L2_DV_FL_REDUCED_BLANKING dv-bt-standards
 replace define V4L2_DV_FL_CAN_REDUCE_FPS dv-bt-standards
+replace define V4L2_DV_FL_CAN_DETECT_REDUCED_FPS dv-bt-standards
 replace define V4L2_DV_FL_REDUCED_FPS dv-bt-standards
 replace define V4L2_DV_FL_HALF_LINE dv-bt-standards
 replace define V4L2_DV_FL_IS_CE_VIDEO dv-bt-standards
-- 
2.18.0
