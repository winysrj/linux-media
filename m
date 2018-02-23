Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:45224 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751413AbeBWIy5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Feb 2018 03:54:57 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: yong.zhi@intel.com, Yang@nauris.fi.intel.com,
        Hyungwoo <hyungwoo.yang@intel.com>, Rapolu@nauris.fi.intel.com,
        Chiranjeevi <chiranjeevi.rapolu@intel.com>, andy.yeh@intel.com
Subject: [PATCH v1.1 1/5] v4l: common: Add a function to obtain best size from a list
Date: Fri, 23 Feb 2018 10:54:38 +0200
Message-Id: <1519376078-32291-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a function (as well as a helper macro) to obtain the best size in a
list of device specific sizes. This helps writing drivers as well as
aligns interface behaviour across drivers.

The struct in which this information is contained in is typically specific
to the driver, therefore the existing function v4l2_find_nearest_format()
does not address the need.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
since v1:

- Fix KernelDoc for v4l2_find_nearest_size():

  * v4l2_find_nearest_size - Find the nearest size among a discrete
  *	set of resolutions contained in an array of a driver specific struct.
  *
- * @sizes: a driver specific array of image sizes
+ * @array: a driver specific array of image sizes
+ * @array_size: the length of the driver specific array of image sizes
  * @width_field: the name of the width field in the driver specific struct
  * @height_field: the name of the height field in the driver specific struct
  * @width: desired width.


 drivers/media/v4l2-core/v4l2-common.c | 30 ++++++++++++++++++++++++++++++
 include/media/v4l2-common.h           | 34 ++++++++++++++++++++++++++++++++++
 2 files changed, 64 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-common.c b/drivers/media/v4l2-core/v4l2-common.c
index 96c1b31..7b892c9 100644
--- a/drivers/media/v4l2-core/v4l2-common.c
+++ b/drivers/media/v4l2-core/v4l2-common.c
@@ -383,6 +383,36 @@ v4l2_find_nearest_format(const struct v4l2_frmsize_discrete *sizes,
 }
 EXPORT_SYMBOL_GPL(v4l2_find_nearest_format);
 
+const void *
+__v4l2_find_nearest_size(const void *arr, size_t num_entries, size_t entry_size,
+			 size_t width_offset, size_t height_offset,
+			 s32 width, s32 height)
+{
+	u32 error, min_error = U32_MAX;
+	const void *best = NULL;
+	unsigned int i;
+
+	if (!arr)
+		return NULL;
+
+	for (i = 0; i < num_entries; i++, arr += entry_size) {
+		const u32 *entry_width = arr + width_offset;
+		const u32 *entry_height = arr + height_offset;
+
+		error = abs(*entry_width - width) + abs(*entry_height - height);
+		if (error > min_error)
+			continue;
+
+		min_error = error;
+		best = arr;
+		if (!error)
+			break;
+	}
+
+	return best;
+}
+EXPORT_SYMBOL_GPL(__v4l2_find_nearest_size);
+
 void v4l2_get_timestamp(struct timeval *tv)
 {
 	struct timespec ts;
diff --git a/include/media/v4l2-common.h b/include/media/v4l2-common.h
index f3aa1d7..4a8eaa6 100644
--- a/include/media/v4l2-common.h
+++ b/include/media/v4l2-common.h
@@ -333,6 +333,40 @@ v4l2_find_nearest_format(const struct v4l2_frmsize_discrete *sizes,
 			  s32 width, s32 height);
 
 /**
+ * v4l2_find_nearest_size - Find the nearest size among a discrete
+ *	set of resolutions contained in an array of a driver specific struct.
+ *
+ * @array: a driver specific array of image sizes
+ * @array_size: the length of the driver specific array of image sizes
+ * @width_field: the name of the width field in the driver specific struct
+ * @height_field: the name of the height field in the driver specific struct
+ * @width: desired width.
+ * @height: desired height.
+ *
+ * Finds the closest resolution to minimize the width and height differences
+ * between what requested and the supported resolutions. The size of the width
+ * and height fields in the driver specific must equal to that of u32, i.e. four
+ * bytes.
+ *
+ * Returns the best match or NULL if the length of the array is zero.
+ */
+#define v4l2_find_nearest_size(array, array_size, width_field, height_field, \
+			       width, height)				\
+	({								\
+		BUILD_BUG_ON(sizeof((array)->width_field) != sizeof(u32) || \
+			     sizeof((array)->height_field) != sizeof(u32)); \
+		(typeof(&(*(array))))__v4l2_find_nearest_size(		\
+			(array), array_size, sizeof(*(array)),		\
+			offsetof(typeof(*(array)), width_field),	\
+			offsetof(typeof(*(array)), height_field),	\
+			width, height);					\
+	})
+const void *
+__v4l2_find_nearest_size(const void *arr, size_t entry_size,
+			 size_t width_offset, size_t height_offset,
+			 size_t num_entries, s32 width, s32 height);
+
+/**
  * v4l2_get_timestamp - helper routine to get a timestamp to be used when
  *	filling streaming metadata. Internally, it uses ktime_get_ts(),
  *	which is the recommended way to get it.
-- 
2.7.4
