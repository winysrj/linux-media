Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:4975 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027Ab3BPJfL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Feb 2013 04:35:11 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 16/18] v4l2 core: remove the obsolete dv_preset support.
Date: Sat, 16 Feb 2013 10:28:19 +0100
Message-Id: <f395089d9dbe8c8e5b890de813a9d2f38b5a9628.1361006882.git.hans.verkuil@cisco.com>
In-Reply-To: <1361006901-16103-1-git-send-email-hverkuil@xs4all.nl>
References: <1361006901-16103-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <a9599acc7829c431d88b547de87c500968ccb86a.1361006882.git.hans.verkuil@cisco.com>
References: <a9599acc7829c431d88b547de87c500968ccb86a.1361006882.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

These ioctls are no longer used by any drivers, so remove them.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c |    4 ----
 drivers/media/v4l2-core/v4l2-dev.c            |    4 ----
 drivers/media/v4l2-core/v4l2-ioctl.c          |   27 ++-----------------------
 include/media/v4l2-ioctl.h                    |    9 ---------
 4 files changed, 2 insertions(+), 42 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
index 7157af3..f129551 100644
--- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
+++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
@@ -1076,10 +1076,6 @@ long v4l2_compat_ioctl32(struct file *file, unsigned int cmd, unsigned long arg)
 	case VIDIOC_DBG_G_REGISTER:
 	case VIDIOC_DBG_G_CHIP_IDENT:
 	case VIDIOC_S_HW_FREQ_SEEK:
-	case VIDIOC_ENUM_DV_PRESETS:
-	case VIDIOC_S_DV_PRESET:
-	case VIDIOC_G_DV_PRESET:
-	case VIDIOC_QUERY_DV_PRESET:
 	case VIDIOC_S_DV_TIMINGS:
 	case VIDIOC_G_DV_TIMINGS:
 	case VIDIOC_DQEVENT:
diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
index 51b3a77..a4201ff 100644
--- a/drivers/media/v4l2-core/v4l2-dev.c
+++ b/drivers/media/v4l2-core/v4l2-dev.c
@@ -685,7 +685,6 @@ static void determine_valid_ioctls(struct video_device *vdev)
 			SET_VALID_IOCTL(ops, VIDIOC_ENUMAUDIO, vidioc_enumaudio);
 			SET_VALID_IOCTL(ops, VIDIOC_G_AUDIO, vidioc_g_audio);
 			SET_VALID_IOCTL(ops, VIDIOC_S_AUDIO, vidioc_s_audio);
-			SET_VALID_IOCTL(ops, VIDIOC_QUERY_DV_PRESET, vidioc_query_dv_preset);
 			SET_VALID_IOCTL(ops, VIDIOC_QUERY_DV_TIMINGS, vidioc_query_dv_timings);
 		}
 		if (is_tx) {
@@ -708,9 +707,6 @@ static void determine_valid_ioctls(struct video_device *vdev)
 					(ops->vidioc_g_std || vdev->current_norm)))
 			set_bit(_IOC_NR(VIDIOC_G_PARM), valid_ioctls);
 		SET_VALID_IOCTL(ops, VIDIOC_S_PARM, vidioc_s_parm);
-		SET_VALID_IOCTL(ops, VIDIOC_ENUM_DV_PRESETS, vidioc_enum_dv_presets);
-		SET_VALID_IOCTL(ops, VIDIOC_S_DV_PRESET, vidioc_s_dv_preset);
-		SET_VALID_IOCTL(ops, VIDIOC_G_DV_PRESET, vidioc_g_dv_preset);
 		SET_VALID_IOCTL(ops, VIDIOC_S_DV_TIMINGS, vidioc_s_dv_timings);
 		SET_VALID_IOCTL(ops, VIDIOC_G_DV_TIMINGS, vidioc_g_dv_timings);
 		SET_VALID_IOCTL(ops, VIDIOC_ENUM_DV_TIMINGS, vidioc_enum_dv_timings);
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index aa6e7c7..3f24902 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -643,21 +643,6 @@ static void v4l_print_dbg_register(const void *arg, bool write_only)
 			p->reg, p->val);
 }
 
-static void v4l_print_dv_enum_presets(const void *arg, bool write_only)
-{
-	const struct v4l2_dv_enum_preset *p = arg;
-
-	pr_cont("index=%u, preset=%u, name=%s, width=%u, height=%u\n",
-			p->index, p->preset, p->name, p->width, p->height);
-}
-
-static void v4l_print_dv_preset(const void *arg, bool write_only)
-{
-	const struct v4l2_dv_preset *p = arg;
-
-	pr_cont("preset=%u\n", p->preset);
-}
-
 static void v4l_print_dv_timings(const void *arg, bool write_only)
 {
 	const struct v4l2_dv_timings *p = arg;
@@ -1000,15 +985,13 @@ static int v4l_enuminput(const struct v4l2_ioctl_ops *ops,
 	struct v4l2_input *p = arg;
 
 	/*
-	 * We set the flags for CAP_PRESETS, CAP_DV_TIMINGS &
+	 * We set the flags for CAP_DV_TIMINGS &
 	 * CAP_STD here based on ioctl handler provided by the
 	 * driver. If the driver doesn't support these
 	 * for a specific input, it must override these flags.
 	 */
 	if (ops->vidioc_s_std)
 		p->capabilities |= V4L2_IN_CAP_STD;
-	if (ops->vidioc_s_dv_preset)
-		p->capabilities |= V4L2_IN_CAP_PRESETS;
 	if (ops->vidioc_s_dv_timings)
 		p->capabilities |= V4L2_IN_CAP_DV_TIMINGS;
 
@@ -1021,15 +1004,13 @@ static int v4l_enumoutput(const struct v4l2_ioctl_ops *ops,
 	struct v4l2_output *p = arg;
 
 	/*
-	 * We set the flags for CAP_PRESETS, CAP_DV_TIMINGS &
+	 * We set the flags for CAP_DV_TIMINGS &
 	 * CAP_STD here based on ioctl handler provided by the
 	 * driver. If the driver doesn't support these
 	 * for a specific output, it must override these flags.
 	 */
 	if (ops->vidioc_s_std)
 		p->capabilities |= V4L2_OUT_CAP_STD;
-	if (ops->vidioc_s_dv_preset)
-		p->capabilities |= V4L2_OUT_CAP_PRESETS;
 	if (ops->vidioc_s_dv_timings)
 		p->capabilities |= V4L2_OUT_CAP_DV_TIMINGS;
 
@@ -2028,10 +2009,6 @@ static struct v4l2_ioctl_info v4l2_ioctls[] = {
 	IOCTL_INFO_FNC(VIDIOC_DBG_G_REGISTER, v4l_dbg_g_register, v4l_print_dbg_register, 0),
 	IOCTL_INFO_FNC(VIDIOC_DBG_G_CHIP_IDENT, v4l_dbg_g_chip_ident, v4l_print_dbg_chip_ident, 0),
 	IOCTL_INFO_FNC(VIDIOC_S_HW_FREQ_SEEK, v4l_s_hw_freq_seek, v4l_print_hw_freq_seek, INFO_FL_PRIO),
-	IOCTL_INFO_STD(VIDIOC_ENUM_DV_PRESETS, vidioc_enum_dv_presets, v4l_print_dv_enum_presets, 0),
-	IOCTL_INFO_STD(VIDIOC_S_DV_PRESET, vidioc_s_dv_preset, v4l_print_dv_preset, INFO_FL_PRIO),
-	IOCTL_INFO_STD(VIDIOC_G_DV_PRESET, vidioc_g_dv_preset, v4l_print_dv_preset, 0),
-	IOCTL_INFO_STD(VIDIOC_QUERY_DV_PRESET, vidioc_query_dv_preset, v4l_print_dv_preset, 0),
 	IOCTL_INFO_STD(VIDIOC_S_DV_TIMINGS, vidioc_s_dv_timings, v4l_print_dv_timings, INFO_FL_PRIO),
 	IOCTL_INFO_STD(VIDIOC_G_DV_TIMINGS, vidioc_g_dv_timings, v4l_print_dv_timings, 0),
 	IOCTL_INFO_FNC(VIDIOC_DQEVENT, v4l_dqevent, v4l_print_event, 0),
diff --git a/include/media/v4l2-ioctl.h b/include/media/v4l2-ioctl.h
index 4118ad1..daa0065 100644
--- a/include/media/v4l2-ioctl.h
+++ b/include/media/v4l2-ioctl.h
@@ -254,15 +254,6 @@ struct v4l2_ioctl_ops {
 					   struct v4l2_frmivalenum *fival);
 
 	/* DV Timings IOCTLs */
-	int (*vidioc_enum_dv_presets) (struct file *file, void *fh,
-				       struct v4l2_dv_enum_preset *preset);
-
-	int (*vidioc_s_dv_preset) (struct file *file, void *fh,
-				   struct v4l2_dv_preset *preset);
-	int (*vidioc_g_dv_preset) (struct file *file, void *fh,
-				   struct v4l2_dv_preset *preset);
-	int (*vidioc_query_dv_preset) (struct file *file, void *fh,
-					struct v4l2_dv_preset *qpreset);
 	int (*vidioc_s_dv_timings) (struct file *file, void *fh,
 				    struct v4l2_dv_timings *timings);
 	int (*vidioc_g_dv_timings) (struct file *file, void *fh,
-- 
1.7.10.4

