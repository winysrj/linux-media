Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:48598 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751383AbeBWJue (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Feb 2018 04:50:34 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: yong.zhi@intel.com, Hyungwoo Yang <hyungwoo.yang@intel.com>,
        Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>,
        andy.yeh@intel.com
Subject: [PATCH v1.2 1/5] v4l: common: Add a function to obtain best size from a list
Date: Fri, 23 Feb 2018 11:50:14 +0200
Message-Id: <1519379414-7573-1-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1519376078-32291-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1519376078-32291-1-git-send-email-sakari.ailus@linux.intel.com>
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
since v1.1:

- Align argument order in __v4l2_find_nearest_size() function and its
  prototype. Align argument names across the function and the macro.

 drivers/media/v4l2-core/v4l2-common.c | 30 ++++++++++++++++++++++++++++++
 include/media/v4l2-common.h           | 34 ++++++++++++++++++++++++++++++++++
 2 files changed, 64 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-common.c b/drivers/media/v4l2-core/v4l2-common.c
index 96c1b31..9b65529 100644
--- a/drivers/media/v4l2-core/v4l2-common.c
+++ b/drivers/media/v4l2-core/v4l2-common.c
@@ -383,6 +383,36 @@ v4l2_find_nearest_format(const struct v4l2_frmsize_discrete *sizes,
 }
 EXPORT_SYMBOL_GPL(v4l2_find_nearest_format);
 
+const void *
+__v4l2_find_nearest_size(const void *array, size_t array_size,
+			 size_t entry_size, size_t width_offset,
+			 size_t height_offset, s32 width, s32 height)
+{
+	u32 error, min_error = U32_MAX;
+	const void *best = NULL;
+	unsigned int i;
+
+	if (!array)
+		return NULL;
+
+	for (i = 0; i < array_size; i++, array += entry_size) {
+		const u32 *entry_width = array + width_offset;
+		const u32 *entry_height = array + height_offset;
+
+		error = abs(*entry_width - width) + abs(*entry_height - height);
+		if (error > min_error)
+			continue;
+
+		min_error = error;
+		best = array;
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
index f3aa1d7..38947dc 100644
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
+__v4l2_find_nearest_size(const void *array, size_t array_size,
+			 size_t entry_size, size_t width_offset,
+			 size_t height_offset, s32 width, s32 height);
+
+/**
  * v4l2_get_timestamp - helper routine to get a timestamp to be used when
  *	filling streaming metadata. Internally, it uses ktime_get_ts(),
  *	which is the recommended way to get it.
-- 
2.7.4
