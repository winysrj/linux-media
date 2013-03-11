Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:1281 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753735Ab3CKLqj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Mar 2013 07:46:39 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Volokh Konstantin <volokh84@gmail.com>,
	Pete Eberlein <pete@sensoray.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 03/42] v4l2-ioctl: check if an ioctl is valid.
Date: Mon, 11 Mar 2013 12:45:41 +0100
Message-Id: <f0045ea28d59c056fd6d3ce6800b14aa1cd4e32d.1363000605.git.hans.verkuil@cisco.com>
In-Reply-To: <1363002380-19825-1-git-send-email-hverkuil@xs4all.nl>
References: <1363002380-19825-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <38bc3cc42d0c021432afd29c2c1e22cf380b06e0.1363000605.git.hans.verkuil@cisco.com>
References: <38bc3cc42d0c021432afd29c2c1e22cf380b06e0.1363000605.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Just checking if the op exists isn't correct, you should check if the ioctl
is valid (which implies that the op exists as well).

One exception is g_std: if current_norm is non-zero, then the g_std op may be
absent. This sort of weird behavior is one of the reasons why I am trying to
get rid of current_norm.

This patch fixes the case where the g/s_std op is set, but these ioctls are
disabled. This can happen in drivers supporting multiple models, some that
have TV input (and support the STD API) and some that have a sensor (and do
not support the STD API). In the latter case qv4l2 would still show the
Standards combobox.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-ioctl.c |   22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index aa6e7c7..b589c34 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -35,6 +35,8 @@
 	memset((u8 *)(p) + offsetof(typeof(*(p)), field) + sizeof((p)->field), \
 	0, sizeof(*(p)) - offsetof(typeof(*(p)), field) - sizeof((p)->field))
 
+#define is_valid_ioctl(vfd, cmd) test_bit(_IOC_NR(cmd), (vfd)->valid_ioctls)
+
 struct std_descr {
 	v4l2_std_id std;
 	const char *descr;
@@ -997,6 +999,7 @@ static int v4l_s_priority(const struct v4l2_ioctl_ops *ops,
 static int v4l_enuminput(const struct v4l2_ioctl_ops *ops,
 				struct file *file, void *fh, void *arg)
 {
+	struct video_device *vfd = video_devdata(file);
 	struct v4l2_input *p = arg;
 
 	/*
@@ -1005,11 +1008,11 @@ static int v4l_enuminput(const struct v4l2_ioctl_ops *ops,
 	 * driver. If the driver doesn't support these
 	 * for a specific input, it must override these flags.
 	 */
-	if (ops->vidioc_s_std)
+	if (is_valid_ioctl(vfd, VIDIOC_S_STD))
 		p->capabilities |= V4L2_IN_CAP_STD;
-	if (ops->vidioc_s_dv_preset)
+	if (is_valid_ioctl(vfd, VIDIOC_S_DV_PRESET))
 		p->capabilities |= V4L2_IN_CAP_PRESETS;
-	if (ops->vidioc_s_dv_timings)
+	if (is_valid_ioctl(vfd, VIDIOC_S_DV_TIMINGS))
 		p->capabilities |= V4L2_IN_CAP_DV_TIMINGS;
 
 	return ops->vidioc_enum_input(file, fh, p);
@@ -1018,6 +1021,7 @@ static int v4l_enuminput(const struct v4l2_ioctl_ops *ops,
 static int v4l_enumoutput(const struct v4l2_ioctl_ops *ops,
 				struct file *file, void *fh, void *arg)
 {
+	struct video_device *vfd = video_devdata(file);
 	struct v4l2_output *p = arg;
 
 	/*
@@ -1026,11 +1030,11 @@ static int v4l_enumoutput(const struct v4l2_ioctl_ops *ops,
 	 * driver. If the driver doesn't support these
 	 * for a specific output, it must override these flags.
 	 */
-	if (ops->vidioc_s_std)
+	if (is_valid_ioctl(vfd, VIDIOC_S_STD))
 		p->capabilities |= V4L2_OUT_CAP_STD;
-	if (ops->vidioc_s_dv_preset)
+	if (is_valid_ioctl(vfd, VIDIOC_S_DV_PRESET))
 		p->capabilities |= V4L2_OUT_CAP_PRESETS;
-	if (ops->vidioc_s_dv_timings)
+	if (is_valid_ioctl(vfd, VIDIOC_S_DV_TIMINGS))
 		p->capabilities |= V4L2_OUT_CAP_DV_TIMINGS;
 
 	return ops->vidioc_enum_output(file, fh, p);
@@ -1513,7 +1517,7 @@ static int v4l_g_parm(const struct v4l2_ioctl_ops *ops,
 	    p->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
 		return -EINVAL;
 	p->parm.capture.readbuffers = 2;
-	if (ops->vidioc_g_std)
+	if (is_valid_ioctl(vfd, VIDIOC_G_STD) && ops->vidioc_g_std)
 		ret = ops->vidioc_g_std(file, fh, &std);
 	if (ret == 0)
 		v4l2_video_std_frame_period(std,
@@ -1873,7 +1877,7 @@ static int v4l_enum_freq_bands(const struct v4l2_ioctl_ops *ops,
 		return -EINVAL;
 	if (ops->vidioc_enum_freq_bands)
 		return ops->vidioc_enum_freq_bands(file, fh, p);
-	if (ops->vidioc_g_tuner) {
+	if (is_valid_ioctl(vfd, VIDIOC_G_TUNER)) {
 		struct v4l2_tuner t = {
 			.index = p->tuner,
 			.type = type,
@@ -1891,7 +1895,7 @@ static int v4l_enum_freq_bands(const struct v4l2_ioctl_ops *ops,
 			V4L2_BAND_MODULATION_FM : V4L2_BAND_MODULATION_VSB;
 		return 0;
 	}
-	if (ops->vidioc_g_modulator) {
+	if (is_valid_ioctl(vfd, VIDIOC_G_MODULATOR)) {
 		struct v4l2_modulator m = {
 			.index = p->tuner,
 		};
-- 
1.7.10.4

