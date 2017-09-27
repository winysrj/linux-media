Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:33428
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752364AbdI0VrI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Sep 2017 17:47:08 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Subject: [PATCH v2 06/17] media: v4l2-dv-timings.h: convert comment into kernel-doc markup
Date: Wed, 27 Sep 2017 18:46:49 -0300
Message-Id: <bfe081e9560af67cd499c1f5ae458bfb57d557ea.1506548682.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1506548682.git.mchehab@s-opensource.com>
References: <cover.1506548682.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1506548682.git.mchehab@s-opensource.com>
References: <cover.1506548682.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The can_reduce_fps() is already documented, but it is not
using the kernel-doc markup. Convert it, in order to generate
documentation from it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 include/media/v4l2-dv-timings.h | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/include/media/v4l2-dv-timings.h b/include/media/v4l2-dv-timings.h
index 61a18893e004..c0855887ad87 100644
--- a/include/media/v4l2-dv-timings.h
+++ b/include/media/v4l2-dv-timings.h
@@ -203,13 +203,15 @@ struct v4l2_fract v4l2_calc_aspect_ratio(u8 hor_landscape, u8 vert_portrait);
  */
 struct v4l2_fract v4l2_dv_timings_aspect_ratio(const struct v4l2_dv_timings *t);
 
-/*
- * reduce_fps - check if conditions for reduced fps are true.
- * bt - v4l2 timing structure
+/**
+ * can_reduce_fps - check if conditions for reduced fps are true.
+ * @bt: v4l2 timing structure
+ *
  * For different timings reduced fps is allowed if following conditions
- * are met -
- * For CVT timings: if reduced blanking v2 (vsync == 8) is true.
- * For CEA861 timings: if V4L2_DV_FL_CAN_REDUCE_FPS flag is true.
+ * are met:
+ *
+ *   - For CVT timings: if reduced blanking v2 (vsync == 8) is true.
+ *   - For CEA861 timings: if %V4L2_DV_FL_CAN_REDUCE_FPS flag is true.
  */
 static inline  bool can_reduce_fps(struct v4l2_bt_timings *bt)
 {
-- 
2.13.5
