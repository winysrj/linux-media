Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr19.xs4all.nl ([194.109.24.39]:1445 "EHLO
	smtp-vbr19.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922Ab3BPJ2w (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Feb 2013 04:28:52 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 08/18] s5p-tv: add dv_timings support for mixer_video.
Date: Sat, 16 Feb 2013 10:28:11 +0100
Message-Id: <893b2672e7bb563e82b570767869537c11b3c7aa.1361006882.git.hans.verkuil@cisco.com>
In-Reply-To: <1361006901-16103-1-git-send-email-hverkuil@xs4all.nl>
References: <1361006901-16103-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <a9599acc7829c431d88b547de87c500968ccb86a.1361006882.git.hans.verkuil@cisco.com>
References: <a9599acc7829c431d88b547de87c500968ccb86a.1361006882.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This just adds dv_timings support without modifying existing dv_preset
support.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-tv/mixer_video.c |   78 +++++++++++++++++++++++++++
 1 file changed, 78 insertions(+)

diff --git a/drivers/media/platform/s5p-tv/mixer_video.c b/drivers/media/platform/s5p-tv/mixer_video.c
index 82142a2..cdfadba 100644
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
+	/* preset change cannot be done while there is an entity
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
@@ -742,6 +815,11 @@ static const struct v4l2_ioctl_ops mxr_ioctl_ops = {
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

