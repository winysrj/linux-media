Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:1287 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197Ab2CBQSH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Mar 2012 11:18:07 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: Re: [RFCv1 PATCH] Expose controls in debugfs
Date: Fri, 2 Mar 2012 17:17:54 +0100
Cc: Communications nexus for pvrusb2 driver <pvrusb2@isely.net>
References: <201203021436.16026.hverkuil@xs4all.nl>
In-Reply-To: <201203021436.16026.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201203021717.54962.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday, March 02, 2012 14:36:16 Hans Verkuil wrote:
> Hi all,
> 
> I've resumed work on something that was discussed ages ago: exposing controls
> in debugfs. It's quite useful in pvrusb2, but that code is completely custom.
> Creating a general method for this is the goal of this patch.
> 
> The old thread can be found here:
> 
> http://www.mail-archive.com/linux-media@vger.kernel.org/msg17453.html
> 
> Although the original proposal in that thread was to do it in sysfs, the
> overall preference was to use debugfs instead.
> 
> This patch is quite simple and does not touch any driver code. All drivers
> that use the V4L2 control framework (which sadly does not include pvrusb2
> at the moment) will get it for free.
> 
> It even implements poll(), so you can poll on a control waiting for the value
> to change. It also honours the priority setting (VIDIOC_G/S_PRIORITY).
> 
> The control type information is not exposed. As mentioned in the thread above,
> I think adding debugfs entries with the type information will make it very messy.
> 
> One possible idea is to have the control files support VIDIOC_QUERYCTRL and
> VIDIOC_QUERYMENU and to create a small utility that will read out that
> information and output it in a manner that can be easily parsed. It would be
> trivial to do this.
> 
> This patch should also work fine for v4l2-subdevX nodes, although I don't
> have the hardware at the moment to check this.
> 
> The git tree containing this patch is here:
> 
> http://git.linuxtv.org/hverkuil/media_tree.git/shortlog/refs/heads/debugfs
> 
> This patch only exposes controls, it does not add controls that emulate V4L2
> ioctls (as pvrusb2 does). I would have to experiment with that a bit. I'm not
> convinced it is that useful (as opposed to calling v4l2-ctl).

OK, here is a patch that implements a v4l2_input control as a front-end for
VIDIOC_G/S_INPUT and a v4l2_frequency control as a front-end for G/S_FREQUENCY.

This code doesn't touch any drivers, it is all done by the V4L2 core.

Right now the code that handles these two controls is part of v4l2-ctrls.c.
If we decide to go ahead with this, then this will be moved to a separate
source and it will also be put under a config option.

So for the vivi driver you have the following if debugfs is mounted under
/sys/kernel/debug:

$ l /sys/kernel/debug/video4linux/video1/controls/
bitmask  brightness  contrast  gain_automatic  integer_32_bits  menu        string      volume
boolean  button      gain      hue             integer_64_bits  saturation  v4l2_input

For ivtv it will look like this:

$ l /sys/kernel/debug/video4linux/video0/controls/
balance                           mpeg_insert_navigation_packets     mpeg_video_bitrate
brightness                        mpeg_median_chroma_filter_maximum  mpeg_video_bitrate_mode
chroma_agc                        mpeg_median_chroma_filter_minimum  mpeg_video_decoder_frame_count
chroma_gain                       mpeg_median_filter_type            mpeg_video_decoder_pts
contrast                          mpeg_median_luma_filter_maximum    mpeg_video_encoding
hue                               mpeg_median_luma_filter_minimum    mpeg_video_gop_closure
mpeg_audio_crc                    mpeg_spatial_chroma_filter_type    mpeg_video_gop_size
mpeg_audio_emphasis               mpeg_spatial_filter                mpeg_video_mute
mpeg_audio_encoding               mpeg_spatial_filter_mode           mpeg_video_mute_yuv
mpeg_audio_layer_ii_bitrate       mpeg_spatial_luma_filter_type      mpeg_video_peak_bitrate
mpeg_audio_multilingual_playback  mpeg_stream_type                   mpeg_video_temporal_decimation
mpeg_audio_mute                   mpeg_stream_vbi_format             mute
mpeg_audio_playback               mpeg_temporal_filter               saturation
mpeg_audio_sampling_frequency     mpeg_temporal_filter_mode          v4l2_frequency
mpeg_audio_stereo_mode            mpeg_video_aspect                  v4l2_input
mpeg_audio_stereo_mode_extension  mpeg_video_b_frames                volume

It's magic :-)

As a proof of concept this shows that it is quite easy to do this cleanly.
Whether this is actually something that should be followed-up is another
question.

Comments are welcome!

Regards,

	Hans

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/v4l2-ctrls.c |  164 ++++++++++++++++++++++++++++++--------
 drivers/media/video/v4l2-dev.c   |    5 +
 include/media/v4l2-ctrls.h       |    2 +
 include/media/v4l2-dev.h         |    4 +
 4 files changed, 142 insertions(+), 33 deletions(-)

diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index 4f49643..3cef2e2 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -2408,6 +2408,8 @@ EXPORT_SYMBOL(v4l2_ctrl_poll);
 static const char *get_class_prefix(u32 id)
 {
 	switch (V4L2_CTRL_ID2CLASS(id)) {
+	case 0:
+		return "v4l2_";
 	case V4L2_CTRL_CLASS_USER:
 		return "";
 	case V4L2_CTRL_CLASS_CAMERA:
@@ -2436,6 +2438,82 @@ static void make_debugfs_name(char *src)
 	*dst = 0;
 }
 
+#define DEBUGFS_CID_INPUT	1
+#define DEBUGFS_CID_FREQUENCY	2
+
+static void debugfs_v4l2_read(struct file *filp, struct video_device *vdev,
+		struct v4l2_ctrl *ctrl)
+{
+	switch (ctrl->id) {
+	case DEBUGFS_CID_INPUT:
+		vdev->ioctl_ops->vidioc_g_input(filp, filp->private_data,
+				&ctrl->cur.val);
+		break;
+
+	case DEBUGFS_CID_FREQUENCY: {
+		struct v4l2_frequency freq;
+
+		freq.tuner = 0;
+		freq.type = (vdev->vfl_type == VFL_TYPE_RADIO) ?
+			V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
+		memset(freq.reserved, 0, sizeof(freq.reserved));
+		vdev->ioctl_ops->vidioc_g_frequency(filp, filp->private_data,
+				&freq);
+		ctrl->cur.val = freq.frequency;
+		break;
+	}
+	}
+}
+
+static int debugfs_v4l2_write(struct file *filp, struct video_device *vdev,
+		struct v4l2_ctrl *ctrl)
+{
+	switch (ctrl->id) {
+	case DEBUGFS_CID_INPUT:
+		return vdev->ioctl_ops->vidioc_s_input(filp, filp->private_data,
+				ctrl->cur.val);
+
+	case DEBUGFS_CID_FREQUENCY: {
+		struct v4l2_frequency freq;
+
+		freq.tuner = 0;
+		freq.type = (vdev->vfl_type == VFL_TYPE_RADIO) ?
+			V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
+		freq.frequency = ctrl->cur.val;
+		memset(freq.reserved, 0, sizeof(freq.reserved));
+		return vdev->ioctl_ops->vidioc_s_frequency(filp, filp->private_data,
+				&freq);
+	}
+	}
+	return -EINVAL;
+}
+
+int v4l2_ctrl_debugfs_v4l2_controls(struct video_device *vdev)
+{
+	struct v4l2_ctrl_config cfg = {
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.max = INT_MAX,
+		.step = 1,
+	};
+	int ret = v4l2_ctrl_handler_init(&vdev->v4l2_hdl, 1);
+
+	if (ret)
+		return ret;
+	if (vdev->ioctl_ops->vidioc_enum_input) {
+		cfg.id = DEBUGFS_CID_INPUT;
+		cfg.name = "input";
+		if (!v4l2_ctrl_new_custom(&vdev->v4l2_hdl, &cfg, NULL))
+			return -ENOMEM;
+	}
+	if (vdev->ioctl_ops->vidioc_s_frequency) {
+		cfg.id = DEBUGFS_CID_FREQUENCY;
+		cfg.name = "frequency";
+		if (!v4l2_ctrl_new_custom(&vdev->v4l2_hdl, &cfg, NULL))
+			return -ENOMEM;
+	}
+	return 0;
+}
+
 static ssize_t debugfs_read(struct file *filp, char __user *buf,
 		size_t sz, loff_t *off)
 {
@@ -2454,6 +2532,9 @@ static ssize_t debugfs_read(struct file *filp, char __user *buf,
 	if (ctrl->flags & V4L2_CTRL_FLAG_WRITE_ONLY)
 		return -EACCES;
 
+	if (ctrl->handler == &vdev->v4l2_hdl)
+		debugfs_v4l2_read(filp, vdev, ctrl);
+
 	v4l2_ctrl_lock(ctrl);
 	/* g_volatile_ctrl will update the current control values */
 	if (ctrl->flags & V4L2_CTRL_FLAG_VOLATILE) {
@@ -2602,6 +2683,8 @@ static ssize_t debugfs_write(struct file *filp, const char __user *buf,
 	}
 	ret = try_or_set_cluster(NULL, master, true);
 	v4l2_ctrl_unlock(ctrl);
+	if (!ret && ctrl->handler == &vdev->v4l2_hdl)
+		ret = debugfs_v4l2_write(filp, vdev, ctrl);
 	return ret ? ret : sz;
 }
 
@@ -2611,7 +2694,8 @@ static int debugfs_open(struct inode *inode, struct file *filp)
 	struct v4l2_ctrl_ref *ref = filp->f_path.dentry->d_inode->i_private;
 	struct video_device *vdev = video_devdata(filp);
 
-	if (!ret && test_bit(V4L2_FL_USES_V4L2_FH, &vdev->flags)) {
+	if (!ret && ref->ctrl->handler != &vdev->v4l2_hdl &&
+			test_bit(V4L2_FL_USES_V4L2_FH, &vdev->flags)) {
 		struct v4l2_fh *fh = filp->private_data;
 		struct v4l2_event_subscription sub = {
 			.type = V4L2_EVENT_CTRL,
@@ -2632,7 +2716,7 @@ static unsigned int debugfs_poll(struct file *file, struct poll_table_struct *wa
 	struct video_device *vdev = video_devdata(file);
 	unsigned int mask = 0;
 
-	if (test_bit(V4L2_FL_USES_V4L2_FH, &vdev->flags)) {
+	if (ctrl->handler != &vdev->v4l2_hdl && test_bit(V4L2_FL_USES_V4L2_FH, &vdev->flags)) {
 		mask = v4l2_ctrl_poll(file, wait);
 
 		if (mask & POLLPRI) {
@@ -2659,6 +2743,44 @@ const struct file_operations debugfs_fops = {
 	.llseek = no_llseek,
 };
 
+
+static int v4l2_ctrl_debugfs_add_control(struct video_device *vdev,
+		struct v4l2_ctrl_ref *ref)
+{
+	struct v4l2_ctrl *ctrl = ref->ctrl;
+	const char *prefix = get_class_prefix(ctrl->id);
+	char name[strlen(ctrl->name) + strlen(prefix) + 1];
+	mode_t mode = S_IRUGO | S_IWUGO;
+	struct dentry *debugfs_file;
+
+	if (ctrl->type == V4L2_CTRL_TYPE_CTRL_CLASS)
+		return 0;
+	if (ctrl->flags & V4L2_CTRL_FLAG_DISABLED)
+		return 0;
+
+	strcpy(name, prefix);
+	strcat(name, ctrl->name);
+	make_debugfs_name(name);
+
+	if (ref->minor < 0)
+		ref->minor = vdev->minor;
+
+	if (ctrl->flags & V4L2_CTRL_FLAG_WRITE_ONLY)
+		mode = S_IWUGO;
+	else if (ctrl->flags & V4L2_CTRL_FLAG_READ_ONLY)
+		mode = S_IRUGO;
+
+	debugfs_file = debugfs_create_file(name,
+			mode, vdev->debugfs_controls, ref,
+			&debugfs_fops);
+	if (IS_ERR_OR_NULL(debugfs_file)) {
+		printk(KERN_ERR "%s: debugfs: could not create %s\n",
+				__func__, name);
+		return -ENODEV;
+	}
+	return 0;
+}
+
 /* Update the debugfs controls if something changed. */
 int v4l2_ctrl_debugfs_update_controls(struct video_device *vdev)
 {
@@ -2681,38 +2803,14 @@ int v4l2_ctrl_debugfs_update_controls(struct video_device *vdev)
 	}
 
 	list_for_each_entry(ref, &hdl->ctrl_refs, node) {
-		struct v4l2_ctrl *ctrl = ref->ctrl;
-		const char *prefix = get_class_prefix(ctrl->id);
-		char name[strlen(ctrl->name) + strlen(prefix) + 1];
-		mode_t mode = S_IRUGO | S_IWUGO;
-		struct dentry *debugfs_file;
-
-		if (ctrl->type == V4L2_CTRL_TYPE_CTRL_CLASS)
-			continue;
-		if (ctrl->flags & V4L2_CTRL_FLAG_DISABLED)
-			continue;
-
-		strcpy(name, prefix);
-		strcat(name, ctrl->name);
-		make_debugfs_name(name);
-
-		if (ref->minor < 0)
-			ref->minor = vdev->minor;
-
-		if (ctrl->flags & V4L2_CTRL_FLAG_WRITE_ONLY)
-			mode = S_IWUGO;
-		else if (ctrl->flags & V4L2_CTRL_FLAG_READ_ONLY)
-			mode = S_IRUGO;
-
-		debugfs_file = debugfs_create_file(name,
-				mode, vdev->debugfs_controls, ref,
-				&debugfs_fops);
-		if (IS_ERR_OR_NULL(debugfs_file)) {
-			printk(KERN_ERR "%s: debugfs: could not create %s\n",
-					__func__, name);
-			err = -ENODEV;
+		err = v4l2_ctrl_debugfs_add_control(vdev, ref);
+		if (err)
+			break;
+	}
+	list_for_each_entry(ref, &vdev->v4l2_hdl.ctrl_refs, node) {
+		err = v4l2_ctrl_debugfs_add_control(vdev, ref);
+		if (err)
 			break;
-		}
 	}
 	if (err) {
 		debugfs_remove_recursive(vdev->debugfs_controls);
diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/video/v4l2-dev.c
index 0a59a75..3050d2e 100644
--- a/drivers/media/video/v4l2-dev.c
+++ b/drivers/media/video/v4l2-dev.c
@@ -701,6 +701,9 @@ int __video_register_device(struct video_device *vdev, int type, int nr,
 					__func__, video_device_node_name(vdev));
 			goto cleanup;
 		}
+		ret = v4l2_ctrl_debugfs_v4l2_controls(vdev);
+		if (ret)
+			goto cleanup;
 		ret = v4l2_ctrl_debugfs_update_controls(vdev);
 		if (ret)
 			goto cleanup;
@@ -753,6 +756,7 @@ cleanup:
 		debugfs_remove_recursive(vdev->debugfs_devnode);
 		vdev->debugfs_devnode = NULL;
 		vdev->debugfs_controls = NULL;
+		v4l2_ctrl_handler_free(&vdev->v4l2_hdl);
 	}
 	mutex_lock(&videodev_lock);
 	if (vdev->cdev)
@@ -781,6 +785,7 @@ void video_unregister_device(struct video_device *vdev)
 	debugfs_remove_recursive(vdev->debugfs_devnode);
 	vdev->debugfs_devnode = NULL;
 	vdev->debugfs_controls = NULL;
+	v4l2_ctrl_handler_free(&vdev->v4l2_hdl);
 	mutex_lock(&videodev_lock);
 	/* This must be in a critical section to prevent a race with v4l2_open.
 	 * Once this bit has been cleared video_get may never be called again.
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index 54c0fcf..9634ce8 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -524,6 +524,8 @@ int v4l2_s_ext_ctrls(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
    Returns 0 if vdev->ctrl_handler == NULL. */
 int v4l2_ctrl_debugfs_update_controls(struct video_device *vdev);
 
+int v4l2_ctrl_debugfs_v4l2_controls(struct video_device *vdev);
+
 
 /* Helpers for subdevices. If the associated ctrl_handler == NULL then they
    will all return -EINVAL. */
diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
index 6f21386..df1872d 100644
--- a/include/media/v4l2-dev.h
+++ b/include/media/v4l2-dev.h
@@ -17,6 +17,7 @@
 #include <linux/videodev2.h>
 
 #include <media/media-entity.h>
+#include <media/v4l2-ctrls.h>
 
 #define VIDEO_MAJOR	81
 
@@ -94,6 +95,9 @@ struct video_device
 	/* Control handler associated with this device node. May be NULL. */
 	struct v4l2_ctrl_handler *ctrl_handler;
 
+	/* Control handler containing controls that map to V4L2 ioctls. */
+	struct v4l2_ctrl_handler v4l2_hdl;
+
 	/* debugfs directories */
 	struct dentry *debugfs_devnode;
 	struct dentry *debugfs_controls;
-- 
1.7.9.1

