Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:41855 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753864AbZLCUSU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Dec 2009 15:18:20 -0500
From: m-karicheri2@ti.com
To: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Cc: davinci-linux-open-source@linux.davincidsp.com,
	Muralidharan Karicheri <m-karicheri2@ti.com>
Subject: [PATCH -v2] Adding helper function to get dv preset description
Date: Thu,  3 Dec 2009 15:18:24 -0500
Message-Id: <1259871504-18156-1-git-send-email-m-karicheri2@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Muralidharan Karicheri <m-karicheri2@ti.com>

Updated based on comments against v1 of the patch

This patch adds a helper function to get description of a digital
video preset added by the video timing API. This will be usefull for drivers
implementing the above API.

NOTE: depends on the patch that adds video timing API.

Signed-off-by: Muralidharan Karicheri <m-karicheri2@ti.com>
Reviewed-by: Hans Verkuil <hverkuil@xs4all.nl>
---
Applies to V4L-DVB linux-next branch
 drivers/media/video/v4l2-common.c |   47 +++++++++++++++++++++++++++++++++++++
 include/media/v4l2-common.h       |    2 +-
 2 files changed, 48 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/v4l2-common.c b/drivers/media/video/v4l2-common.c
index e8e5aff..36b5cb8 100644
--- a/drivers/media/video/v4l2-common.c
+++ b/drivers/media/video/v4l2-common.c
@@ -1024,3 +1024,50 @@ void v4l_bound_align_image(u32 *w, unsigned int wmin, unsigned int wmax,
 	}
 }
 EXPORT_SYMBOL_GPL(v4l_bound_align_image);
+
+/**
+ * v4l_fill_dv_preset_info - fill description of a digital video preset
+ * @preset - preset value
+ * @info - pointer to struct v4l2_dv_enum_preset
+ *
+ * drivers can use this helper function to fill description of dv preset
+ * in info.
+ */
+int v4l_fill_dv_preset_info(u32 preset, struct v4l2_dv_enum_preset *info)
+{
+	static const struct v4l2_dv_preset_info {
+		u16 width;
+		u16 height;
+		const char *name;
+	} dv_presets[] = {
+		{ 0, 0, "Invalid" },		/* V4L2_DV_INVALID */
+		{ 720,  480, "480p@59.94" },	/* V4L2_DV_480P59_94 */
+		{ 720,  576, "576p@50" },	/* V4L2_DV_576P50 */
+		{ 1280, 720, "720p@24" },	/* V4L2_DV_720P24 */
+		{ 1280, 720, "720p@25" },	/* V4L2_DV_720P25 */
+		{ 1280, 720, "720p@30" },	/* V4L2_DV_720P30 */
+		{ 1280, 720, "720p@50" },	/* V4L2_DV_720P50 */
+		{ 1280, 720, "720p@59.94" },	/* V4L2_DV_720P59_94 */
+		{ 1280, 720, "720p@60" },	/* V4L2_DV_720P60 */
+		{ 1920, 1080, "1080i@29.97" },	/* V4L2_DV_1080I29_97 */
+		{ 1920, 1080, "1080i@30" },	/* V4L2_DV_1080I30 */
+		{ 1920, 1080, "1080i@25" },	/* V4L2_DV_1080I25 */
+		{ 1920, 1080, "1080i@50" },	/* V4L2_DV_1080I50 */
+		{ 1920, 1080, "1080i@60" },	/* V4L2_DV_1080I60 */
+		{ 1920, 1080, "1080p@24" },	/* V4L2_DV_1080P24 */
+		{ 1920, 1080, "1080p@25" },	/* V4L2_DV_1080P25 */
+		{ 1920, 1080, "1080p@30" },	/* V4L2_DV_1080P30 */
+		{ 1920, 1080, "1080p@50" },	/* V4L2_DV_1080P50 */
+		{ 1920, 1080, "1080p@60" },	/* V4L2_DV_1080P60 */
+	};
+
+	if (info == NULL || preset >= ARRAY_SIZE(dv_presets))
+		return -EINVAL;
+
+	info->preset = preset;
+	info->width = dv_presets[preset].width;
+	info->height = dv_presets[preset].height;
+	strlcpy(info->name, dv_presets[preset].name, sizeof(info->name));
+	return 0;
+}
+EXPORT_SYMBOL_GPL(v4l_fill_dv_preset_info);
diff --git a/include/media/v4l2-common.h b/include/media/v4l2-common.h
index 1c25b10..1c7b259 100644
--- a/include/media/v4l2-common.h
+++ b/include/media/v4l2-common.h
@@ -212,5 +212,5 @@ void v4l_bound_align_image(unsigned int *w, unsigned int wmin,
 			   unsigned int *h, unsigned int hmin,
 			   unsigned int hmax, unsigned int halign,
 			   unsigned int salign);
-
+int v4l_fill_dv_preset_info(u32 preset, struct v4l2_dv_enum_preset *info);
 #endif /* V4L2_COMMON_H_ */
-- 
1.6.0.4

