Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37240 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726635AbeKHAff (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Nov 2018 19:35:35 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, p.zabel@pengutronix.de
Subject: [PATCH 1/1] v4l: uAPI doc: Simplify NATIVE_SIZE selection target documentation
Date: Wed,  7 Nov 2018 17:04:49 +0200
Message-Id: <20181107150449.24956-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The NATIVE_SIZE target is documented for mem2mem devices but no driver has
ever apparently used it. It may be never needed; remove it for now.

Suggested-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 Documentation/media/uapi/v4l/v4l2-selection-targets.rst | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/Documentation/media/uapi/v4l/v4l2-selection-targets.rst b/Documentation/media/uapi/v4l/v4l2-selection-targets.rst
index 87433ec76c6b..bee31611947e 100644
--- a/Documentation/media/uapi/v4l/v4l2-selection-targets.rst
+++ b/Documentation/media/uapi/v4l/v4l2-selection-targets.rst
@@ -42,12 +42,7 @@ of the two interfaces they are used.
     * - ``V4L2_SEL_TGT_NATIVE_SIZE``
       - 0x0003
       - The native size of the device, e.g. a sensor's pixel array.
-	``left`` and ``top`` fields are zero for this target. Setting the
-	native size will generally only make sense for memory to memory
-	devices where the software can create a canvas of a given size in
-	which for example a video frame can be composed. In that case
-	V4L2_SEL_TGT_NATIVE_SIZE can be used to configure the size of
-	that canvas.
+	``left`` and ``top`` fields are zero for this target.
       - Yes
       - Yes
     * - ``V4L2_SEL_TGT_COMPOSE``
-- 
2.11.0
