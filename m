Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl1-f196.google.com ([209.85.214.196]:41224 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726230AbeIWWdU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 23 Sep 2018 18:33:20 -0400
Received: by mail-pl1-f196.google.com with SMTP id b12-v6so8059141plr.8
        for <linux-media@vger.kernel.org>; Sun, 23 Sep 2018 09:35:18 -0700 (PDT)
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-media@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Matt Ranostay <matt.ranostay@konsulko.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hansverk@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH v2 3/6] media: v4l2-common: add V4L2_FRACT_COMPARE
Date: Mon, 24 Sep 2018 01:34:49 +0900
Message-Id: <1537720492-31201-4-git-send-email-akinobu.mita@gmail.com>
In-Reply-To: <1537720492-31201-1-git-send-email-akinobu.mita@gmail.com>
References: <1537720492-31201-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add macro to compare two v4l2_fract values in v4l2 common internal API.
The same macro FRACT_CMP() is used by vivid and bcm2835-camera.  This just
renames it to V4L2_FRACT_COMPARE in order to avoid namespace collision.

Cc: Matt Ranostay <matt.ranostay@konsulko.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Hans Verkuil <hansverk@cisco.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
* v2
- New patch

 include/media/v4l2-common.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/media/v4l2-common.h b/include/media/v4l2-common.h
index cdc87ec..eafb8a3 100644
--- a/include/media/v4l2-common.h
+++ b/include/media/v4l2-common.h
@@ -384,4 +384,9 @@ int v4l2_g_parm_cap(struct video_device *vdev,
 int v4l2_s_parm_cap(struct video_device *vdev,
 		    struct v4l2_subdev *sd, struct v4l2_streamparm *a);
 
+/* Compare two v4l2_fract structs */
+#define V4L2_FRACT_COMPARE(a, OP, b)			\
+	((u64)(a).numerator * (b).denominator OP	\
+	(u64)(b).numerator * (a).denominator)
+
 #endif /* V4L2_COMMON_H_ */
-- 
2.7.4
