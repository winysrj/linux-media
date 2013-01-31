Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:3547 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317Ab3AaKZv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Jan 2013 05:25:51 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Huang Shijie <shijie8@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 12/18] tlg2300: fix frequency handling.
Date: Thu, 31 Jan 2013 11:25:30 +0100
Message-Id: <611d9f61c71f46224c6109db314cdf9cd5d43217.1359627298.git.hans.verkuil@cisco.com>
In-Reply-To: <1359627936-14918-1-git-send-email-hverkuil@xs4all.nl>
References: <1359627936-14918-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <608a45800f829b97fcc5c00b1decc64c829d71cb.1359627298.git.hans.verkuil@cisco.com>
References: <608a45800f829b97fcc5c00b1decc64c829d71cb.1359627298.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The usual set of problems: the frequency isn't clamped to the frequency range,
no tuner index check and the frequency isn't initialized properly on module
load.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/tlg2300/pd-common.h |    4 ++--
 drivers/media/usb/tlg2300/pd-video.c  |   20 ++++++++++++--------
 2 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/media/usb/tlg2300/pd-common.h b/drivers/media/usb/tlg2300/pd-common.h
index 052cb0c..55fe66e 100644
--- a/drivers/media/usb/tlg2300/pd-common.h
+++ b/drivers/media/usb/tlg2300/pd-common.h
@@ -36,8 +36,8 @@
 #define V4L_PAL_VBI_FRAMESIZE	(V4L_PAL_VBI_LINES * 1440 * 2)
 #define V4L_NTSC_VBI_FRAMESIZE	(V4L_NTSC_VBI_LINES * 1440 * 2)
 
-#define TUNER_FREQ_MIN		(45000000)
-#define TUNER_FREQ_MAX		(862000000)
+#define TUNER_FREQ_MIN		(45000000U)
+#define TUNER_FREQ_MAX		(862000000U)
 
 struct vbi_data {
 	struct video_device	v_dev;
diff --git a/drivers/media/usb/tlg2300/pd-video.c b/drivers/media/usb/tlg2300/pd-video.c
index 8ab2894..da7cbd4 100644
--- a/drivers/media/usb/tlg2300/pd-video.c
+++ b/drivers/media/usb/tlg2300/pd-video.c
@@ -940,7 +940,7 @@ static int vidioc_s_input(struct file *file, void *fh, unsigned int i)
 	return 0;
 }
 
-static struct poseidon_control *check_control_id(__u32 id)
+static struct poseidon_control *check_control_id(u32 id)
 {
 	struct poseidon_control *control = &controls[0];
 	int array_size = ARRAY_SIZE(controls);
@@ -1134,21 +1134,21 @@ static int vidioc_g_frequency(struct file *file, void *fh,
 	return 0;
 }
 
-static int set_frequency(struct poseidon *pd, __u32 frequency)
+static int set_frequency(struct poseidon *pd, u32 *frequency)
 {
 	s32 ret = 0, param, cmd_status;
 	struct running_context *context = &pd->video_data.context;
 
-	param = frequency * 62500 / 1000;
-	if (param < TUNER_FREQ_MIN/1000 || param > TUNER_FREQ_MAX / 1000)
-		return -EINVAL;
+	*frequency = clamp(*frequency,
+			TUNER_FREQ_MIN / 62500, TUNER_FREQ_MAX / 62500);
+	param = (*frequency) * 62500 / 1000;
 
 	mutex_lock(&pd->lock);
 	ret = send_set_req(pd, TUNE_FREQ_SELECT, param, &cmd_status);
 	ret = send_set_req(pd, TAKE_REQUEST, 0, &cmd_status);
 
 	msleep(250); /* wait for a while until the hardware is ready. */
-	context->freq = frequency;
+	context->freq = *frequency;
 	mutex_unlock(&pd->lock);
 	return ret;
 }
@@ -1159,12 +1159,14 @@ static int vidioc_s_frequency(struct file *file, void *fh,
 	struct front_face *front = fh;
 	struct poseidon *pd = front->pd;
 
+	if (freq->tuner)
+		return -EINVAL;
 	logs(front);
 #ifdef CONFIG_PM
 	pd->pm_suspend = pm_video_suspend;
 	pd->pm_resume = pm_video_resume;
 #endif
-	return set_frequency(pd, freq->frequency);
+	return set_frequency(pd, &freq->frequency);
 }
 
 static int vidioc_reqbufs(struct file *file, void *fh,
@@ -1351,7 +1353,7 @@ static int restore_v4l2_context(struct poseidon *pd,
 	vidioc_s_input(NULL, front, context->sig_index);
 	pd_vidioc_s_tuner(pd, context->audio_idx);
 	pd_vidioc_s_fmt(pd, &context->pix);
-	set_frequency(pd, context->freq);
+	set_frequency(pd, &context->freq);
 	return 0;
 }
 
@@ -1615,8 +1617,10 @@ int pd_video_init(struct poseidon *pd)
 {
 	struct video_data *video = &pd->video_data;
 	struct vbi_data *vbi	= &pd->vbi_data;
+	u32 freq = TUNER_FREQ_MIN / 62500;
 	int ret = -ENOMEM;
 
+	set_frequency(pd, &freq);
 	video->v_dev = pd_video_template;
 	video->v_dev.v4l2_dev = &pd->v4l2_dev;
 	video_set_drvdata(&video->v_dev, pd);
-- 
1.7.10.4

