Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga12.intel.com ([192.55.52.136]:56031 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750806AbeBHMoe (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Feb 2018 07:44:34 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: yong.zhi@intel.com, Yang@nauris.fi.intel.com,
        Hyungwoo <hyungwoo.yang@intel.com>, Rapolu@nauris.fi.intel.com,
        Chiranjeevi <chiranjeevi.rapolu@intel.com>, andy.yeh@intel.com
Subject: [PATCH 2/5] vivid: Use v4l2_find_nearest_size
Date: Thu,  8 Feb 2018 14:44:25 +0200
Message-Id: <1518093868-3444-3-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1518093868-3444-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1518093868-3444-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use v4l2_find_nearest_size instead of a driver specific function to find
nearest matching size.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/platform/vivid/vivid-vid-cap.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/vivid/vivid-vid-cap.c b/drivers/media/platform/vivid/vivid-vid-cap.c
index 0fbbcde..62a42f6 100644
--- a/drivers/media/platform/vivid/vivid-vid-cap.c
+++ b/drivers/media/platform/vivid/vivid-vid-cap.c
@@ -573,9 +573,9 @@ int vivid_try_fmt_vid_cap(struct file *file, void *priv,
 	mp->field = vivid_field_cap(dev, mp->field);
 	if (vivid_is_webcam(dev)) {
 		const struct v4l2_frmsize_discrete *sz =
-			v4l2_find_nearest_format(webcam_sizes,
-						 VIVID_WEBCAM_SIZES,
-						 mp->width, mp->height);
+			v4l2_find_nearest_size(webcam_sizes,
+					       VIVID_WEBCAM_SIZES, width,
+					       height, mp->width, mp->height);
 
 		w = sz->width;
 		h = sz->height;
-- 
2.7.4
