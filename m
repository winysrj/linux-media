Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:4933 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758328Ab3CDNC0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Mar 2013 08:02:26 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 3/6] s5p-tv: add dv_timings support for mixer_video.
Date: Mon,  4 Mar 2013 14:02:03 +0100
Message-Id: <f3470cbb559c08a101418bc39621aabe2ab072b0.1362401530.git.hans.verkuil@cisco.com>
In-Reply-To: <1362402126-13149-1-git-send-email-hverkuil@xs4all.nl>
References: <1362402126-13149-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <2b361dfb4359134806e6b6d741d9286968c49df6.1362401530.git.hans.verkuil@cisco.com>
References: <2b361dfb4359134806e6b6d741d9286968c49df6.1362401530.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This just adds dv_timings support without modifying existing dv_preset
support.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Tested-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-tv/mixer_video.c |   80 +++++++++++++++++++++++++++
 1 file changed, 80 insertions(+)

diff --git a/drivers/media/platform/s5p-tv/mixer_video.c b/drivers/media/platform/s5p-tv/mixer_video.c
index 82142a2..24fb381 100644
--- a/drivers/media/platform/s5p-tv/mixer_video.c
+++ b/drivers/media/platform/s5p-tv/mixer_video.c
@@ -559,6 +559,79 @@ static int mxr_g_dv_preset(struct file *file, void *fh,
 	return ret ? -EINVAL : 0;
 }
 
+static int mxr_enum_dv_timings(struct file *file, void *fh,
+	struct v4l2_enum_dv_timings *timings)
+{
+	struct mxr_layer *layer = video_drvdata(file);
+	struct mxr_device *mdev = layer->mdev;
+	int ret;
+
+	/* lock protects from changing sd_out */
+	mutex_lock(&mdev->mutex);
+	ret = v4l2_subdev_call(to_outsd(mdev), video, enum_dv_timings, timings);
+	mutex_unlock(&mdev->mutex);
+
+	return ret ? -EINVAL : 0;
+}
+
+static int mxr_s_dv_timings(struct file *file, void *fh,
+	struct v4l2_dv_timings *timings)
+{
+	struct mxr_layer *layer = video_drvdata(file);
+	struct mxr_device *mdev = layer->mdev;
+	int ret;
+
+	/* lock protects from changing sd_out */
+	mutex_lock(&mdev->mutex);
+
+	/* timings change cannot be done while there is an entity
+	 * dependant on output configuration
+	 */
+	if (mdev->n_output > 0) {
+		mutex_unlock(&mdev->mutex);
+		return -EBUSY;
+	}
+
+	ret = v4l2_subdev_call(to_outsd(mdev), video, s_dv_timings, timings);
+
+	mutex_unlock(&mdev->mutex);
+
+	mxr_layer_update_output(layer);
+
+	/* any failure should return EINVAL according to V4L2 doc */
+	return ret ? -EINVAL : 0;
+}
+
+static int mxr_g_dv_timings(struct file *file, void *fh,
+	struct v4l2_dv_timings *timings)
+{
+	struct mxr_layer *layer = video_drvdata(file);
+	struct mxr_device *mdev = layer->mdev;
+	int ret;
+
+	/* lock protects from changing sd_out */
+	mutex_lock(&mdev->mutex);
+	ret = v4l2_subdev_call(to_outsd(mdev), video, g_dv_timings, timings);
+	mutex_unlock(&mdev->mutex);
+
+	return ret ? -EINVAL : 0;
+}
+
+static int mxr_dv_timings_cap(struct file *file, void *fh,
+	struct v4l2_dv_timings_cap *cap)
+{
+	struct mxr_layer *layer = video_drvdata(file);
+	struct mxr_device *mdev = layer->mdev;
+	int ret;
+
+	/* lock protects from changing sd_out */
+	mutex_lock(&mdev->mutex);
+	ret = v4l2_subdev_call(to_outsd(mdev), video, dv_timings_cap, cap);
+	mutex_unlock(&mdev->mutex);
+
+	return ret ? -EINVAL : 0;
+}
+
 static int mxr_s_std(struct file *file, void *fh, v4l2_std_id *norm)
 {
 	struct mxr_layer *layer = video_drvdata(file);
@@ -618,6 +691,8 @@ static int mxr_enum_output(struct file *file, void *fh, struct v4l2_output *a)
 	a->capabilities = 0;
 	if (sd->ops->video && sd->ops->video->s_dv_preset)
 		a->capabilities |= V4L2_OUT_CAP_PRESETS;
+	if (sd->ops->video && sd->ops->video->s_dv_timings)
+		a->capabilities |= V4L2_OUT_CAP_DV_TIMINGS;
 	if (sd->ops->video && sd->ops->video->s_std_output)
 		a->capabilities |= V4L2_OUT_CAP_STD;
 	a->type = V4L2_OUTPUT_TYPE_ANALOG;
@@ -742,6 +817,11 @@ static const struct v4l2_ioctl_ops mxr_ioctl_ops = {
 	.vidioc_enum_dv_presets = mxr_enum_dv_presets,
 	.vidioc_s_dv_preset = mxr_s_dv_preset,
 	.vidioc_g_dv_preset = mxr_g_dv_preset,
+	/* DV Timings functions */
+	.vidioc_enum_dv_timings = mxr_enum_dv_timings,
+	.vidioc_s_dv_timings = mxr_s_dv_timings,
+	.vidioc_g_dv_timings = mxr_g_dv_timings,
+	.vidioc_dv_timings_cap = mxr_dv_timings_cap,
 	/* analog TV standard functions */
 	.vidioc_s_std = mxr_s_std,
 	.vidioc_g_std = mxr_g_std,
-- 
1.7.10.4

