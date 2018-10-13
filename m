Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf1-f195.google.com ([209.85.210.195]:34674 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726668AbeJNBlL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 13 Oct 2018 21:41:11 -0400
Received: by mail-pf1-f195.google.com with SMTP id f78-v6so1956823pfe.1
        for <linux-media@vger.kernel.org>; Sat, 13 Oct 2018 11:03:05 -0700 (PDT)
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-media@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Matt Ranostay <matt.ranostay@konsulko.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hansverk@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH v3 3/6] media: v4l2-common: add V4L2_FRACT_COMPARE
Date: Sun, 14 Oct 2018 03:02:36 +0900
Message-Id: <1539453759-29976-4-git-send-email-akinobu.mita@gmail.com>
In-Reply-To: <1539453759-29976-1-git-send-email-akinobu.mita@gmail.com>
References: <1539453759-29976-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add macro to compare two v4l2_fract values in v4l2 common internal API.
The same macro FRACT_CMP() is used by vivid and bcm2835-camera.  This just
renames it to V4L2_FRACT_COMPARE in order to avoid namespace collision.

Cc: Matt Ranostay <matt.ranostay@konsulko.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Hans Verkuil <hansverk@cisco.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
* v3
- Add Acked-by line

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
