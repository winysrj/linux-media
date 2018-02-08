Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga12.intel.com ([192.55.52.136]:56031 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750847AbeBHMof (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Feb 2018 07:44:35 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: yong.zhi@intel.com, Yang@nauris.fi.intel.com,
        Hyungwoo <hyungwoo.yang@intel.com>, Rapolu@nauris.fi.intel.com,
        Chiranjeevi <chiranjeevi.rapolu@intel.com>, andy.yeh@intel.com
Subject: [PATCH 3/5] v4l: common: Remove v4l2_find_nearest_format
Date: Thu,  8 Feb 2018 14:44:26 +0200
Message-Id: <1518093868-3444-4-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1518093868-3444-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1518093868-3444-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

v4l2_find_nearest_format is not useful for drivers in finding the best
matching format as it assumes a V4L2 specific struct. Drivers will use
v4l2_find_nearest_size instead.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/v4l2-common.c | 26 --------------------------
 include/media/v4l2-common.h           | 17 -----------------
 2 files changed, 43 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-common.c b/drivers/media/v4l2-core/v4l2-common.c
index c7a48f2..7bda367 100644
--- a/drivers/media/v4l2-core/v4l2-common.c
+++ b/drivers/media/v4l2-core/v4l2-common.c
@@ -357,32 +357,6 @@ void v4l_bound_align_image(u32 *w, unsigned int wmin, unsigned int wmax,
 }
 EXPORT_SYMBOL_GPL(v4l_bound_align_image);
 
-const struct v4l2_frmsize_discrete *
-v4l2_find_nearest_format(const struct v4l2_frmsize_discrete *sizes,
-			  size_t num_sizes,
-			  s32 width, s32 height)
-{
-	int i;
-	u32 error, min_error = UINT_MAX;
-	const struct v4l2_frmsize_discrete *size, *best = NULL;
-
-	if (!sizes)
-		return NULL;
-
-	for (i = 0, size = sizes; i < num_sizes; i++, size++) {
-		error = abs(size->width - width) + abs(size->height - height);
-		if (error < min_error) {
-			min_error = error;
-			best = size;
-		}
-		if (!error)
-			break;
-	}
-
-	return best;
-}
-EXPORT_SYMBOL_GPL(v4l2_find_nearest_format);
-
 const void *
 __v4l2_find_nearest_size(const void *arr, size_t num_entries, size_t entry_size,
 			 size_t width_offset, size_t height_offset,
diff --git a/include/media/v4l2-common.h b/include/media/v4l2-common.h
index 520463e..0895942 100644
--- a/include/media/v4l2-common.h
+++ b/include/media/v4l2-common.h
@@ -316,23 +316,6 @@ void v4l_bound_align_image(unsigned int *width, unsigned int wmin,
 			   unsigned int salign);
 
 /**
- * v4l2_find_nearest_format - find the nearest format size among a discrete
- *	set of resolutions.
- *
- * @sizes: array of &struct v4l2_frmsize_discrete image sizes.
- * @num_sizes: length of @sizes array.
- * @width: desired width.
- * @height: desired height.
- *
- * Finds the closest resolution to minimize the width and height differences
- * between what requested and the supported resolutions.
- */
-const struct v4l2_frmsize_discrete *
-v4l2_find_nearest_format(const struct v4l2_frmsize_discrete *sizes,
-			  const size_t num_sizes,
-			  s32 width, s32 height);
-
-/**
  * v4l2_find_nearest_size - Find the nearest size among a discrete
  *	set of resolutions contained in an array of a driver specific struct.
  *
-- 
2.7.4
