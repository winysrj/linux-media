Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:3219 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752948Ab3BPJ24 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Feb 2013 04:28:56 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 14/18] v4l2-common: remove obsolete v4l_fill_dv_preset_info
Date: Sat, 16 Feb 2013 10:28:17 +0100
Message-Id: <a406353f76281219878f54aedf35a622005df720.1361006882.git.hans.verkuil@cisco.com>
In-Reply-To: <1361006901-16103-1-git-send-email-hverkuil@xs4all.nl>
References: <1361006901-16103-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <a9599acc7829c431d88b547de87c500968ccb86a.1361006882.git.hans.verkuil@cisco.com>
References: <a9599acc7829c431d88b547de87c500968ccb86a.1361006882.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

It's no longer used, so it can now be removed.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-common.c |   47 ---------------------------------
 include/media/v4l2-common.h           |    1 -
 2 files changed, 48 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-common.c b/drivers/media/v4l2-core/v4l2-common.c
index aa044f4..b81f274 100644
--- a/drivers/media/v4l2-core/v4l2-common.c
+++ b/drivers/media/v4l2-core/v4l2-common.c
@@ -551,53 +551,6 @@ void v4l_bound_align_image(u32 *w, unsigned int wmin, unsigned int wmax,
 EXPORT_SYMBOL_GPL(v4l_bound_align_image);
 
 /**
- * v4l_fill_dv_preset_info - fill description of a digital video preset
- * @preset - preset value
- * @info - pointer to struct v4l2_dv_enum_preset
- *
- * drivers can use this helper function to fill description of dv preset
- * in info.
- */
-int v4l_fill_dv_preset_info(u32 preset, struct v4l2_dv_enum_preset *info)
-{
-	static const struct v4l2_dv_preset_info {
-		u16 width;
-		u16 height;
-		const char *name;
-	} dv_presets[] = {
-		{ 0, 0, "Invalid" },		/* V4L2_DV_INVALID */
-		{ 720,  480, "480p@59.94" },	/* V4L2_DV_480P59_94 */
-		{ 720,  576, "576p@50" },	/* V4L2_DV_576P50 */
-		{ 1280, 720, "720p@24" },	/* V4L2_DV_720P24 */
-		{ 1280, 720, "720p@25" },	/* V4L2_DV_720P25 */
-		{ 1280, 720, "720p@30" },	/* V4L2_DV_720P30 */
-		{ 1280, 720, "720p@50" },	/* V4L2_DV_720P50 */
-		{ 1280, 720, "720p@59.94" },	/* V4L2_DV_720P59_94 */
-		{ 1280, 720, "720p@60" },	/* V4L2_DV_720P60 */
-		{ 1920, 1080, "1080i@29.97" },	/* V4L2_DV_1080I29_97 */
-		{ 1920, 1080, "1080i@30" },	/* V4L2_DV_1080I30 */
-		{ 1920, 1080, "1080i@25" },	/* V4L2_DV_1080I25 */
-		{ 1920, 1080, "1080i@50" },	/* V4L2_DV_1080I50 */
-		{ 1920, 1080, "1080i@60" },	/* V4L2_DV_1080I60 */
-		{ 1920, 1080, "1080p@24" },	/* V4L2_DV_1080P24 */
-		{ 1920, 1080, "1080p@25" },	/* V4L2_DV_1080P25 */
-		{ 1920, 1080, "1080p@30" },	/* V4L2_DV_1080P30 */
-		{ 1920, 1080, "1080p@50" },	/* V4L2_DV_1080P50 */
-		{ 1920, 1080, "1080p@60" },	/* V4L2_DV_1080P60 */
-	};
-
-	if (info == NULL || preset >= ARRAY_SIZE(dv_presets))
-		return -EINVAL;
-
-	info->preset = preset;
-	info->width = dv_presets[preset].width;
-	info->height = dv_presets[preset].height;
-	strlcpy(info->name, dv_presets[preset].name, sizeof(info->name));
-	return 0;
-}
-EXPORT_SYMBOL_GPL(v4l_fill_dv_preset_info);
-
-/**
  * v4l_match_dv_timings - check if two timings match
  * @t1 - compare this v4l2_dv_timings struct...
  * @t2 - with this struct.
diff --git a/include/media/v4l2-common.h b/include/media/v4l2-common.h
index ec7c9c0..1d93c48 100644
--- a/include/media/v4l2-common.h
+++ b/include/media/v4l2-common.h
@@ -201,7 +201,6 @@ void v4l_bound_align_image(unsigned int *w, unsigned int wmin,
 			   unsigned int *h, unsigned int hmin,
 			   unsigned int hmax, unsigned int halign,
 			   unsigned int salign);
-int v4l_fill_dv_preset_info(u32 preset, struct v4l2_dv_enum_preset *info);
 
 struct v4l2_discrete_probe {
 	const struct v4l2_frmsize_discrete	*sizes;
-- 
1.7.10.4

