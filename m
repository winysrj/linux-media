Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:3284 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758072Ab3CDNCb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Mar 2013 08:02:31 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 4/6] s5p-tv: remove dv_preset support from mixer_video.
Date: Mon,  4 Mar 2013 14:02:04 +0100
Message-Id: <bc3303524652ecb56a31a693d61bcae75c8e477a.1362401530.git.hans.verkuil@cisco.com>
In-Reply-To: <1362402126-13149-1-git-send-email-hverkuil@xs4all.nl>
References: <1362402126-13149-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <2b361dfb4359134806e6b6d741d9286968c49df6.1362401530.git.hans.verkuil@cisco.com>
References: <2b361dfb4359134806e6b6d741d9286968c49df6.1362401530.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The dv_preset API is deprecated and is replaced by the much improved dv_timings
API. Remove the dv_preset support from this driver as this will allow us to
remove the dv_preset API altogether (s5p-tv being the last user of this code).

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Tested-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-tv/mixer_video.c |   64 ---------------------------
 1 file changed, 64 deletions(-)

diff --git a/drivers/media/platform/s5p-tv/mixer_video.c b/drivers/media/platform/s5p-tv/mixer_video.c
index 24fb381..9961e13 100644
--- a/drivers/media/platform/s5p-tv/mixer_video.c
+++ b/drivers/media/platform/s5p-tv/mixer_video.c
@@ -501,64 +501,6 @@ fail:
 	return -ERANGE;
 }
 
-static int mxr_enum_dv_presets(struct file *file, void *fh,
-	struct v4l2_dv_enum_preset *preset)
-{
-	struct mxr_layer *layer = video_drvdata(file);
-	struct mxr_device *mdev = layer->mdev;
-	int ret;
-
-	/* lock protects from changing sd_out */
-	mutex_lock(&mdev->mutex);
-	ret = v4l2_subdev_call(to_outsd(mdev), video, enum_dv_presets, preset);
-	mutex_unlock(&mdev->mutex);
-
-	return ret ? -EINVAL : 0;
-}
-
-static int mxr_s_dv_preset(struct file *file, void *fh,
-	struct v4l2_dv_preset *preset)
-{
-	struct mxr_layer *layer = video_drvdata(file);
-	struct mxr_device *mdev = layer->mdev;
-	int ret;
-
-	/* lock protects from changing sd_out */
-	mutex_lock(&mdev->mutex);
-
-	/* preset change cannot be done while there is an entity
-	 * dependant on output configuration
-	 */
-	if (mdev->n_output > 0) {
-		mutex_unlock(&mdev->mutex);
-		return -EBUSY;
-	}
-
-	ret = v4l2_subdev_call(to_outsd(mdev), video, s_dv_preset, preset);
-
-	mutex_unlock(&mdev->mutex);
-
-	mxr_layer_update_output(layer);
-
-	/* any failure should return EINVAL according to V4L2 doc */
-	return ret ? -EINVAL : 0;
-}
-
-static int mxr_g_dv_preset(struct file *file, void *fh,
-	struct v4l2_dv_preset *preset)
-{
-	struct mxr_layer *layer = video_drvdata(file);
-	struct mxr_device *mdev = layer->mdev;
-	int ret;
-
-	/* lock protects from changing sd_out */
-	mutex_lock(&mdev->mutex);
-	ret = v4l2_subdev_call(to_outsd(mdev), video, g_dv_preset, preset);
-	mutex_unlock(&mdev->mutex);
-
-	return ret ? -EINVAL : 0;
-}
-
 static int mxr_enum_dv_timings(struct file *file, void *fh,
 	struct v4l2_enum_dv_timings *timings)
 {
@@ -689,8 +631,6 @@ static int mxr_enum_output(struct file *file, void *fh, struct v4l2_output *a)
 	/* try to obtain supported tv norms */
 	v4l2_subdev_call(sd, video, g_tvnorms_output, &a->std);
 	a->capabilities = 0;
-	if (sd->ops->video && sd->ops->video->s_dv_preset)
-		a->capabilities |= V4L2_OUT_CAP_PRESETS;
 	if (sd->ops->video && sd->ops->video->s_dv_timings)
 		a->capabilities |= V4L2_OUT_CAP_DV_TIMINGS;
 	if (sd->ops->video && sd->ops->video->s_std_output)
@@ -813,10 +753,6 @@ static const struct v4l2_ioctl_ops mxr_ioctl_ops = {
 	/* Streaming control */
 	.vidioc_streamon = mxr_streamon,
 	.vidioc_streamoff = mxr_streamoff,
-	/* Preset functions */
-	.vidioc_enum_dv_presets = mxr_enum_dv_presets,
-	.vidioc_s_dv_preset = mxr_s_dv_preset,
-	.vidioc_g_dv_preset = mxr_g_dv_preset,
 	/* DV Timings functions */
 	.vidioc_enum_dv_timings = mxr_enum_dv_timings,
 	.vidioc_s_dv_timings = mxr_s_dv_timings,
-- 
1.7.10.4

