Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:2651 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755333Ab1G2MLI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jul 2011 08:11:08 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [RFCv1 PATCH for v3.1] v4l2-ioctl: fix ENOTTY handling.
Date: Fri, 29 Jul 2011 14:10:53 +0200
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201107291410.53552.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

While converting v4l2-compliance to correctly handle ENOTTY errors I found
several regressions in v4l2-ioctl.c:

1) VIDIOC_ENUM/G/S/TRY_FMT would return -ENOTTY if the op for the particular
   format type was not set, even though the op for other types might have been
   present. In such a case -EINVAL should have been returned.
2) The priority check could cause -EBUSY or -EINVAL to be returned instead of
   -ENOTTY if the corresponding ioctl was unsupported.
3) Certain ioctls that have an internal implementation (ENUMSTD, G_STD, S_STD,
   G_PARM and the extended control ioctls) could return -EINVAL when -ENOTTY
   should have been returned or vice versa.

I first tried to fix this by adding extra code for each affected ioctl, but
that made the code rather ugly.

So I ended up with this code that first checks whether a certain ioctl is
supported or not and returns -ENOTTY if not.

Comments?

	Hans


Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/v4l2-ioctl.c |  466 +++++++++++++++++++++++---------------
 1 files changed, 289 insertions(+), 177 deletions(-)

diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index 002ce13..6a5062a 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -542,13 +542,14 @@ static long __video_do_ioctl(struct file *file,
 	void *fh = file->private_data;
 	struct v4l2_fh *vfh = NULL;
 	struct v4l2_format f_copy;
+	bool have_op;
 	int use_fh_prio = 0;
-	long ret = -ENOTTY;
+	long ret = -EINVAL;
 
 	if (ops == NULL) {
 		printk(KERN_WARNING "videodev: \"%s\" has no ioctl_ops.\n",
 				vfd->name);
-		return ret;
+		return -ENOTTY;
 	}
 
 	if ((vfd->debug & V4L2_DEBUG_IOCTL) &&
@@ -562,6 +563,275 @@ static long __video_do_ioctl(struct file *file,
 		use_fh_prio = test_bit(V4L2_FL_USE_FH_PRIO, &vfd->flags);
 	}
 
+	switch (cmd) {
+	case VIDIOC_QUERYCAP:
+		have_op = ops->vidioc_querycap;
+		break;
+	case VIDIOC_G_PRIORITY:
+		have_op = ops->vidioc_g_priority || use_fh_prio;
+		break;
+	case VIDIOC_S_PRIORITY:
+		have_op = ops->vidioc_s_priority || use_fh_prio;
+		break;
+	case VIDIOC_ENUM_FMT:
+		have_op = ops->vidioc_enum_fmt_vid_cap ||
+			  ops->vidioc_enum_fmt_vid_out ||
+			  ops->vidioc_enum_fmt_vid_cap_mplane ||
+			  ops->vidioc_enum_fmt_vid_out_mplane ||
+			  ops->vidioc_enum_fmt_vid_overlay ||
+			  ops->vidioc_enum_fmt_type_private;
+		break;
+	case VIDIOC_G_FMT:
+		have_op = ops->vidioc_g_fmt_vid_cap ||
+			  ops->vidioc_g_fmt_vid_out ||
+			  ops->vidioc_g_fmt_vid_cap_mplane ||
+			  ops->vidioc_g_fmt_vid_out_mplane ||
+			  ops->vidioc_g_fmt_vbi_cap ||
+			  ops->vidioc_g_fmt_vid_overlay ||
+			  ops->vidioc_g_fmt_vid_out_overlay ||
+			  ops->vidioc_g_fmt_vbi_out ||
+			  ops->vidioc_g_fmt_sliced_vbi_cap ||
+			  ops->vidioc_g_fmt_sliced_vbi_out ||
+			  ops->vidioc_g_fmt_type_private;
+		break;
+	case VIDIOC_S_FMT:
+		have_op = ops->vidioc_s_fmt_vid_cap ||
+			  ops->vidioc_s_fmt_vid_out ||
+			  ops->vidioc_s_fmt_vid_cap_mplane ||
+			  ops->vidioc_s_fmt_vid_out_mplane ||
+			  ops->vidioc_s_fmt_vbi_cap ||
+			  ops->vidioc_s_fmt_vid_overlay ||
+			  ops->vidioc_s_fmt_vid_out_overlay ||
+			  ops->vidioc_s_fmt_vbi_out ||
+			  ops->vidioc_s_fmt_sliced_vbi_cap ||
+			  ops->vidioc_s_fmt_sliced_vbi_out ||
+			  ops->vidioc_s_fmt_type_private;
+		break;
+	case VIDIOC_TRY_FMT:
+		have_op = ops->vidioc_try_fmt_vid_cap ||
+			  ops->vidioc_try_fmt_vid_out ||
+			  ops->vidioc_try_fmt_vid_cap_mplane ||
+			  ops->vidioc_try_fmt_vid_out_mplane ||
+			  ops->vidioc_try_fmt_vbi_cap ||
+			  ops->vidioc_try_fmt_vid_overlay ||
+			  ops->vidioc_try_fmt_vid_out_overlay ||
+			  ops->vidioc_try_fmt_vbi_out ||
+			  ops->vidioc_try_fmt_sliced_vbi_cap ||
+			  ops->vidioc_try_fmt_sliced_vbi_out ||
+			  ops->vidioc_try_fmt_type_private;
+		break;
+	case VIDIOC_REQBUFS:
+		have_op = ops->vidioc_reqbufs;
+		break;
+	case VIDIOC_QUERYBUF:
+		have_op = ops->vidioc_querybuf;
+		break;
+	case VIDIOC_QBUF:
+		have_op = ops->vidioc_qbuf;
+		break;
+	case VIDIOC_DQBUF:
+		have_op = ops->vidioc_dqbuf;
+		break;
+	case VIDIOC_OVERLAY:
+		have_op = ops->vidioc_overlay;
+		break;
+	case VIDIOC_G_FBUF:
+		have_op = ops->vidioc_g_fbuf;
+		break;
+	case VIDIOC_S_FBUF:
+		have_op = ops->vidioc_s_fbuf;
+		break;
+	case VIDIOC_STREAMON:
+		have_op = ops->vidioc_streamon;
+		break;
+	case VIDIOC_STREAMOFF:
+		have_op = ops->vidioc_streamoff;
+		break;
+	case VIDIOC_ENUMSTD:
+		have_op = vfd->tvnorms;
+		break;
+	case VIDIOC_G_STD:
+		have_op = ops->vidioc_g_std || vfd->current_norm;
+		break;
+	case VIDIOC_S_STD:
+		have_op = ops->vidioc_s_std;
+		break;
+	case VIDIOC_QUERYSTD:
+		have_op = ops->vidioc_querystd;
+		break;
+	case VIDIOC_ENUMINPUT:
+		have_op = ops->vidioc_enum_input;
+		break;
+	case VIDIOC_G_INPUT:
+		have_op = ops->vidioc_g_input;
+		break;
+	case VIDIOC_S_INPUT:
+		have_op = ops->vidioc_s_input;
+		break;
+	case VIDIOC_ENUMOUTPUT:
+		have_op = ops->vidioc_enum_output;
+		break;
+	case VIDIOC_G_OUTPUT:
+		have_op = ops->vidioc_g_output;
+		break;
+	case VIDIOC_S_OUTPUT:
+		have_op = ops->vidioc_s_output;
+		break;
+	case VIDIOC_QUERYCTRL:
+		have_op = (vfh && vfh->ctrl_handler) || vfd->ctrl_handler ||
+				ops->vidioc_queryctrl;
+		break;
+	case VIDIOC_G_CTRL:
+		have_op = (vfh && vfh->ctrl_handler) || vfd->ctrl_handler ||
+				ops->vidioc_g_ctrl || ops->vidioc_g_ext_ctrls;
+		break;
+	case VIDIOC_S_CTRL:
+		have_op = (vfh && vfh->ctrl_handler) || vfd->ctrl_handler ||
+				ops->vidioc_s_ctrl || ops->vidioc_s_ext_ctrls;
+		break;
+	case VIDIOC_G_EXT_CTRLS:
+		have_op = (vfh && vfh->ctrl_handler) || vfd->ctrl_handler ||
+				ops->vidioc_g_ext_ctrls;
+		break;
+	case VIDIOC_S_EXT_CTRLS:
+		have_op = (vfh && vfh->ctrl_handler) || vfd->ctrl_handler ||
+				ops->vidioc_s_ext_ctrls;
+		break;
+	case VIDIOC_TRY_EXT_CTRLS:
+		have_op = (vfh && vfh->ctrl_handler) || vfd->ctrl_handler ||
+				ops->vidioc_try_ext_ctrls;
+		break;
+	case VIDIOC_QUERYMENU:
+		have_op = (vfh && vfh->ctrl_handler) || vfd->ctrl_handler ||
+				ops->vidioc_querymenu;
+		break;
+	case VIDIOC_ENUMAUDIO:
+		have_op = ops->vidioc_enumaudio;
+		break;
+	case VIDIOC_G_AUDIO:
+		have_op = ops->vidioc_g_audio;
+		break;
+	case VIDIOC_S_AUDIO:
+		have_op = ops->vidioc_s_audio;
+		break;
+	case VIDIOC_ENUMAUDOUT:
+		have_op = ops->vidioc_enumaudout;
+		break;
+	case VIDIOC_G_AUDOUT:
+		have_op = ops->vidioc_g_audout;
+		break;
+	case VIDIOC_S_AUDOUT:
+		have_op = ops->vidioc_s_audout;
+		break;
+	case VIDIOC_G_MODULATOR:
+		have_op = ops->vidioc_g_modulator;
+		break;
+	case VIDIOC_S_MODULATOR:
+		have_op = ops->vidioc_s_modulator;
+		break;
+	case VIDIOC_G_CROP:
+		have_op = ops->vidioc_g_crop;
+		break;
+	case VIDIOC_S_CROP:
+		have_op = ops->vidioc_s_crop;
+		break;
+	case VIDIOC_CROPCAP:
+		have_op = ops->vidioc_cropcap;
+		break;
+	case VIDIOC_G_JPEGCOMP:
+		have_op = ops->vidioc_g_jpegcomp;
+		break;
+	case VIDIOC_S_JPEGCOMP:
+		have_op = ops->vidioc_g_jpegcomp;
+		break;
+	case VIDIOC_G_ENC_INDEX:
+		have_op = ops->vidioc_g_enc_index;
+		break;
+	case VIDIOC_ENCODER_CMD:
+		have_op = ops->vidioc_encoder_cmd;
+		break;
+	case VIDIOC_TRY_ENCODER_CMD:
+		have_op = ops->vidioc_try_encoder_cmd;
+		break;
+	case VIDIOC_G_PARM:
+		have_op = ops->vidioc_g_parm || vfd->current_norm;
+		break;
+	case VIDIOC_S_PARM:
+		have_op = ops->vidioc_s_parm;
+		break;
+	case VIDIOC_G_TUNER:
+		have_op = ops->vidioc_g_tuner;
+		break;
+	case VIDIOC_S_TUNER:
+		have_op = ops->vidioc_s_tuner;
+		break;
+	case VIDIOC_G_FREQUENCY:
+		have_op = ops->vidioc_g_frequency;
+		break;
+	case VIDIOC_S_FREQUENCY:
+		have_op = ops->vidioc_s_frequency;
+		break;
+	case VIDIOC_G_SLICED_VBI_CAP:
+		have_op = ops->vidioc_g_sliced_vbi_cap;
+		break;
+	case VIDIOC_LOG_STATUS:
+		have_op = ops->vidioc_log_status;
+		break;
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+	case VIDIOC_DBG_G_REGISTER:
+		have_op = ops->vidioc_g_register;
+		break;
+	case VIDIOC_DBG_S_REGISTER:
+		have_op = ops->vidioc_s_register;
+		break;
+#endif
+	case VIDIOC_DBG_G_CHIP_IDENT:
+		have_op = ops->vidioc_g_chip_ident;
+		break;
+	case VIDIOC_S_HW_FREQ_SEEK:
+		have_op = ops->vidioc_s_hw_freq_seek;
+		break;
+	case VIDIOC_ENUM_FRAMESIZES:
+		have_op = ops->vidioc_enum_framesizes;
+		break;
+	case VIDIOC_ENUM_FRAMEINTERVALS:
+		have_op = ops->vidioc_enum_frameintervals;
+		break;
+	case VIDIOC_ENUM_DV_PRESETS:
+		have_op = ops->vidioc_enum_dv_presets;
+		break;
+	case VIDIOC_S_DV_PRESET:
+		have_op = ops->vidioc_s_dv_preset;
+		break;
+	case VIDIOC_G_DV_PRESET:
+		have_op = ops->vidioc_g_dv_preset;
+		break;
+	case VIDIOC_QUERY_DV_PRESET:
+		have_op = ops->vidioc_query_dv_preset;
+		break;
+	case VIDIOC_S_DV_TIMINGS:
+		have_op = ops->vidioc_s_dv_timings;
+		break;
+	case VIDIOC_G_DV_TIMINGS:
+		have_op = ops->vidioc_g_dv_timings;
+		break;
+	case VIDIOC_DQEVENT:
+		have_op = ops->vidioc_subscribe_event;
+		break;
+	case VIDIOC_SUBSCRIBE_EVENT:
+		have_op = ops->vidioc_subscribe_event;
+		break;
+	case VIDIOC_UNSUBSCRIBE_EVENT:
+		have_op = ops->vidioc_unsubscribe_event;
+		break;
+	default:
+		have_op = ops->vidioc_default;
+		break;
+	}
+
+	if (!have_op)
+		return -ENOTTY;
+
 	if (use_fh_prio) {
 		switch (cmd) {
 		case VIDIOC_S_CTRL:
@@ -603,9 +873,6 @@ static long __video_do_ioctl(struct file *file,
 	{
 		struct v4l2_capability *cap = (struct v4l2_capability *)arg;
 
-		if (!ops->vidioc_querycap)
-			break;
-
 		cap->version = LINUX_VERSION_CODE;
 		ret = ops->vidioc_querycap(file, fh, cap);
 		if (!ret)
@@ -625,7 +892,7 @@ static long __video_do_ioctl(struct file *file,
 
 		if (ops->vidioc_g_priority) {
 			ret = ops->vidioc_g_priority(file, fh, p);
-		} else if (use_fh_prio) {
+		} else {
 			*p = v4l2_prio_max(&vfd->v4l2_dev->prio);
 			ret = 0;
 		}
@@ -637,8 +904,6 @@ static long __video_do_ioctl(struct file *file,
 	{
 		enum v4l2_priority *p = arg;
 
-		if (!ops->vidioc_s_priority && !use_fh_prio)
-				break;
 		dbgarg(cmd, "setting priority to %d\n", *p);
 		if (ops->vidioc_s_priority)
 			ret = ops->vidioc_s_priority(file, fh, *p);
@@ -1101,8 +1366,6 @@ static long __video_do_ioctl(struct file *file,
 	{
 		struct v4l2_requestbuffers *p = arg;
 
-		if (!ops->vidioc_reqbufs)
-			break;
 		ret = check_fmt(ops, p->type);
 		if (ret)
 			break;
@@ -1121,8 +1384,6 @@ static long __video_do_ioctl(struct file *file,
 	{
 		struct v4l2_buffer *p = arg;
 
-		if (!ops->vidioc_querybuf)
-			break;
 		ret = check_fmt(ops, p->type);
 		if (ret)
 			break;
@@ -1136,8 +1397,6 @@ static long __video_do_ioctl(struct file *file,
 	{
 		struct v4l2_buffer *p = arg;
 
-		if (!ops->vidioc_qbuf)
-			break;
 		ret = check_fmt(ops, p->type);
 		if (ret)
 			break;
@@ -1151,8 +1410,6 @@ static long __video_do_ioctl(struct file *file,
 	{
 		struct v4l2_buffer *p = arg;
 
-		if (!ops->vidioc_dqbuf)
-			break;
 		ret = check_fmt(ops, p->type);
 		if (ret)
 			break;
@@ -1166,8 +1423,6 @@ static long __video_do_ioctl(struct file *file,
 	{
 		int *i = arg;
 
-		if (!ops->vidioc_overlay)
-			break;
 		dbgarg(cmd, "value=%d\n", *i);
 		ret = ops->vidioc_overlay(file, fh, *i);
 		break;
@@ -1176,8 +1431,6 @@ static long __video_do_ioctl(struct file *file,
 	{
 		struct v4l2_framebuffer *p = arg;
 
-		if (!ops->vidioc_g_fbuf)
-			break;
 		ret = ops->vidioc_g_fbuf(file, fh, arg);
 		if (!ret) {
 			dbgarg(cmd, "capability=0x%x, flags=%d, base=0x%08lx\n",
@@ -1191,8 +1444,6 @@ static long __video_do_ioctl(struct file *file,
 	{
 		struct v4l2_framebuffer *p = arg;
 
-		if (!ops->vidioc_s_fbuf)
-			break;
 		dbgarg(cmd, "capability=0x%x, flags=%d, base=0x%08lx\n",
 			p->capability, p->flags, (unsigned long)p->base);
 		v4l_print_pix_fmt(vfd, &p->fmt);
@@ -1203,8 +1454,6 @@ static long __video_do_ioctl(struct file *file,
 	{
 		enum v4l2_buf_type i = *(int *)arg;
 
-		if (!ops->vidioc_streamon)
-			break;
 		dbgarg(cmd, "type=%s\n", prt_names(i, v4l2_type_names));
 		ret = ops->vidioc_streamon(file, fh, i);
 		break;
@@ -1213,8 +1462,6 @@ static long __video_do_ioctl(struct file *file,
 	{
 		enum v4l2_buf_type i = *(int *)arg;
 
-		if (!ops->vidioc_streamoff)
-			break;
 		dbgarg(cmd, "type=%s\n", prt_names(i, v4l2_type_names));
 		ret = ops->vidioc_streamoff(file, fh, i);
 		break;
@@ -1266,10 +1513,8 @@ static long __video_do_ioctl(struct file *file,
 		/* Calls the specific handler */
 		if (ops->vidioc_g_std)
 			ret = ops->vidioc_g_std(file, fh, id);
-		else if (vfd->current_norm)
-			*id = vfd->current_norm;
 		else
-			ret = -EINVAL;
+			*id = vfd->current_norm;
 
 		if (!ret)
 			dbgarg(cmd, "std=0x%08Lx\n", (long long unsigned)*id);
@@ -1286,10 +1531,7 @@ static long __video_do_ioctl(struct file *file,
 			break;
 
 		/* Calls the specific handler */
-		if (ops->vidioc_s_std)
-			ret = ops->vidioc_s_std(file, fh, &norm);
-		else
-			ret = -EINVAL;
+		ret = ops->vidioc_s_std(file, fh, &norm);
 
 		/* Updates standard information */
 		if (ret >= 0)
@@ -1300,8 +1542,6 @@ static long __video_do_ioctl(struct file *file,
 	{
 		v4l2_std_id *p = arg;
 
-		if (!ops->vidioc_querystd)
-			break;
 		ret = ops->vidioc_querystd(file, fh, arg);
 		if (!ret)
 			dbgarg(cmd, "detected std=%08Lx\n",
@@ -1327,9 +1567,6 @@ static long __video_do_ioctl(struct file *file,
 		if (ops->vidioc_s_dv_timings)
 			p->capabilities |= V4L2_IN_CAP_CUSTOM_TIMINGS;
 
-		if (!ops->vidioc_enum_input)
-			break;
-
 		ret = ops->vidioc_enum_input(file, fh, p);
 		if (!ret)
 			dbgarg(cmd, "index=%d, name=%s, type=%d, "
@@ -1345,8 +1582,6 @@ static long __video_do_ioctl(struct file *file,
 	{
 		unsigned int *i = arg;
 
-		if (!ops->vidioc_g_input)
-			break;
 		ret = ops->vidioc_g_input(file, fh, i);
 		if (!ret)
 			dbgarg(cmd, "value=%d\n", *i);
@@ -1356,8 +1591,6 @@ static long __video_do_ioctl(struct file *file,
 	{
 		unsigned int *i = arg;
 
-		if (!ops->vidioc_s_input)
-			break;
 		dbgarg(cmd, "value=%d\n", *i);
 		ret = ops->vidioc_s_input(file, fh, *i);
 		break;
@@ -1368,9 +1601,6 @@ static long __video_do_ioctl(struct file *file,
 	{
 		struct v4l2_output *p = arg;
 
-		if (!ops->vidioc_enum_output)
-			break;
-
 		/*
 		 * We set the flags for CAP_PRESETS, CAP_CUSTOM_TIMINGS &
 		 * CAP_STD here based on ioctl handler provided by the
@@ -1397,8 +1627,6 @@ static long __video_do_ioctl(struct file *file,
 	{
 		unsigned int *i = arg;
 
-		if (!ops->vidioc_g_output)
-			break;
 		ret = ops->vidioc_g_output(file, fh, i);
 		if (!ret)
 			dbgarg(cmd, "value=%d\n", *i);
@@ -1408,8 +1636,6 @@ static long __video_do_ioctl(struct file *file,
 	{
 		unsigned int *i = arg;
 
-		if (!ops->vidioc_s_output)
-			break;
 		dbgarg(cmd, "value=%d\n", *i);
 		ret = ops->vidioc_s_output(file, fh, *i);
 		break;
@@ -1424,10 +1650,8 @@ static long __video_do_ioctl(struct file *file,
 			ret = v4l2_queryctrl(vfh->ctrl_handler, p);
 		else if (vfd->ctrl_handler)
 			ret = v4l2_queryctrl(vfd->ctrl_handler, p);
-		else if (ops->vidioc_queryctrl)
-			ret = ops->vidioc_queryctrl(file, fh, p);
 		else
-			break;
+			ret = ops->vidioc_queryctrl(file, fh, p);
 		if (!ret)
 			dbgarg(cmd, "id=0x%x, type=%d, name=%s, min/max=%d/%d, "
 					"step=%d, default=%d, flags=0x%08x\n",
@@ -1448,7 +1672,7 @@ static long __video_do_ioctl(struct file *file,
 			ret = v4l2_g_ctrl(vfd->ctrl_handler, p);
 		else if (ops->vidioc_g_ctrl)
 			ret = ops->vidioc_g_ctrl(file, fh, p);
-		else if (ops->vidioc_g_ext_ctrls) {
+		else {
 			struct v4l2_ext_controls ctrls;
 			struct v4l2_ext_control ctrl;
 
@@ -1462,8 +1686,7 @@ static long __video_do_ioctl(struct file *file,
 				if (ret == 0)
 					p->value = ctrl.value;
 			}
-		} else
-			break;
+		}
 		if (!ret)
 			dbgarg(cmd, "id=0x%x, value=%d\n", p->id, p->value);
 		else
@@ -1476,10 +1699,6 @@ static long __video_do_ioctl(struct file *file,
 		struct v4l2_ext_controls ctrls;
 		struct v4l2_ext_control ctrl;
 
-		if (!(vfh && vfh->ctrl_handler) && !vfd->ctrl_handler &&
-			!ops->vidioc_s_ctrl && !ops->vidioc_s_ext_ctrls)
-			break;
-
 		dbgarg(cmd, "id=0x%x, value=%d\n", p->id, p->value);
 
 		if (vfh && vfh->ctrl_handler) {
@@ -1494,8 +1713,6 @@ static long __video_do_ioctl(struct file *file,
 			ret = ops->vidioc_s_ctrl(file, fh, p);
 			break;
 		}
-		if (!ops->vidioc_s_ext_ctrls)
-			break;
 
 		ctrls.ctrl_class = V4L2_CTRL_ID2CLASS(p->id);
 		ctrls.count = 1;
@@ -1515,7 +1732,7 @@ static long __video_do_ioctl(struct file *file,
 			ret = v4l2_g_ext_ctrls(vfh->ctrl_handler, p);
 		else if (vfd->ctrl_handler)
 			ret = v4l2_g_ext_ctrls(vfd->ctrl_handler, p);
-		else if (ops->vidioc_g_ext_ctrls && check_ext_ctrls(p, 0))
+		else if (check_ext_ctrls(p, 0))
 			ret = ops->vidioc_g_ext_ctrls(file, fh, p);
 		else
 			break;
@@ -1527,9 +1744,6 @@ static long __video_do_ioctl(struct file *file,
 		struct v4l2_ext_controls *p = arg;
 
 		p->error_idx = p->count;
-		if (!(vfh && vfh->ctrl_handler) && !vfd->ctrl_handler &&
-				!ops->vidioc_s_ext_ctrls)
-			break;
 		v4l_print_ext_ctrls(cmd, vfd, p, 1);
 		if (vfh && vfh->ctrl_handler)
 			ret = v4l2_s_ext_ctrls(vfh, vfh->ctrl_handler, p);
@@ -1544,9 +1758,6 @@ static long __video_do_ioctl(struct file *file,
 		struct v4l2_ext_controls *p = arg;
 
 		p->error_idx = p->count;
-		if (!(vfh && vfh->ctrl_handler) && !vfd->ctrl_handler &&
-				!ops->vidioc_try_ext_ctrls)
-			break;
 		v4l_print_ext_ctrls(cmd, vfd, p, 1);
 		if (vfh && vfh->ctrl_handler)
 			ret = v4l2_try_ext_ctrls(vfh->ctrl_handler, p);
@@ -1564,10 +1775,8 @@ static long __video_do_ioctl(struct file *file,
 			ret = v4l2_querymenu(vfh->ctrl_handler, p);
 		else if (vfd->ctrl_handler)
 			ret = v4l2_querymenu(vfd->ctrl_handler, p);
-		else if (ops->vidioc_querymenu)
-			ret = ops->vidioc_querymenu(file, fh, p);
 		else
-			break;
+			ret = ops->vidioc_querymenu(file, fh, p);
 		if (!ret)
 			dbgarg(cmd, "id=0x%x, index=%d, name=%s\n",
 				p->id, p->index, p->name);
@@ -1581,8 +1790,6 @@ static long __video_do_ioctl(struct file *file,
 	{
 		struct v4l2_audio *p = arg;
 
-		if (!ops->vidioc_enumaudio)
-			break;
 		ret = ops->vidioc_enumaudio(file, fh, p);
 		if (!ret)
 			dbgarg(cmd, "index=%d, name=%s, capability=0x%x, "
@@ -1596,9 +1803,6 @@ static long __video_do_ioctl(struct file *file,
 	{
 		struct v4l2_audio *p = arg;
 
-		if (!ops->vidioc_g_audio)
-			break;
-
 		ret = ops->vidioc_g_audio(file, fh, p);
 		if (!ret)
 			dbgarg(cmd, "index=%d, name=%s, capability=0x%x, "
@@ -1612,8 +1816,6 @@ static long __video_do_ioctl(struct file *file,
 	{
 		struct v4l2_audio *p = arg;
 
-		if (!ops->vidioc_s_audio)
-			break;
 		dbgarg(cmd, "index=%d, name=%s, capability=0x%x, "
 					"mode=0x%x\n", p->index, p->name,
 					p->capability, p->mode);
@@ -1624,8 +1826,6 @@ static long __video_do_ioctl(struct file *file,
 	{
 		struct v4l2_audioout *p = arg;
 
-		if (!ops->vidioc_enumaudout)
-			break;
 		dbgarg(cmd, "Enum for index=%d\n", p->index);
 		ret = ops->vidioc_enumaudout(file, fh, p);
 		if (!ret)
@@ -1638,9 +1838,6 @@ static long __video_do_ioctl(struct file *file,
 	{
 		struct v4l2_audioout *p = arg;
 
-		if (!ops->vidioc_g_audout)
-			break;
-
 		ret = ops->vidioc_g_audout(file, fh, p);
 		if (!ret)
 			dbgarg2("index=%d, name=%s, capability=%d, "
@@ -1652,8 +1849,6 @@ static long __video_do_ioctl(struct file *file,
 	{
 		struct v4l2_audioout *p = arg;
 
-		if (!ops->vidioc_s_audout)
-			break;
 		dbgarg(cmd, "index=%d, name=%s, capability=%d, "
 					"mode=%d\n", p->index, p->name,
 					p->capability, p->mode);
@@ -1665,8 +1860,6 @@ static long __video_do_ioctl(struct file *file,
 	{
 		struct v4l2_modulator *p = arg;
 
-		if (!ops->vidioc_g_modulator)
-			break;
 		ret = ops->vidioc_g_modulator(file, fh, p);
 		if (!ret)
 			dbgarg(cmd, "index=%d, name=%s, "
@@ -1681,8 +1874,6 @@ static long __video_do_ioctl(struct file *file,
 	{
 		struct v4l2_modulator *p = arg;
 
-		if (!ops->vidioc_s_modulator)
-			break;
 		dbgarg(cmd, "index=%d, name=%s, capability=%d, "
 				"rangelow=%d, rangehigh=%d, txsubchans=%d\n",
 				p->index, p->name, p->capability, p->rangelow,
@@ -1694,9 +1885,6 @@ static long __video_do_ioctl(struct file *file,
 	{
 		struct v4l2_crop *p = arg;
 
-		if (!ops->vidioc_g_crop)
-			break;
-
 		dbgarg(cmd, "type=%s\n", prt_names(p->type, v4l2_type_names));
 		ret = ops->vidioc_g_crop(file, fh, p);
 		if (!ret)
@@ -1707,8 +1895,6 @@ static long __video_do_ioctl(struct file *file,
 	{
 		struct v4l2_crop *p = arg;
 
-		if (!ops->vidioc_s_crop)
-			break;
 		dbgarg(cmd, "type=%s\n", prt_names(p->type, v4l2_type_names));
 		dbgrect(vfd, "", &p->c);
 		ret = ops->vidioc_s_crop(file, fh, p);
@@ -1719,9 +1905,6 @@ static long __video_do_ioctl(struct file *file,
 		struct v4l2_cropcap *p = arg;
 
 		/*FIXME: Should also show v4l2_fract pixelaspect */
-		if (!ops->vidioc_cropcap)
-			break;
-
 		dbgarg(cmd, "type=%s\n", prt_names(p->type, v4l2_type_names));
 		ret = ops->vidioc_cropcap(file, fh, p);
 		if (!ret) {
@@ -1734,9 +1917,6 @@ static long __video_do_ioctl(struct file *file,
 	{
 		struct v4l2_jpegcompression *p = arg;
 
-		if (!ops->vidioc_g_jpegcomp)
-			break;
-
 		ret = ops->vidioc_g_jpegcomp(file, fh, p);
 		if (!ret)
 			dbgarg(cmd, "quality=%d, APPn=%d, "
@@ -1750,21 +1930,17 @@ static long __video_do_ioctl(struct file *file,
 	{
 		struct v4l2_jpegcompression *p = arg;
 
-		if (!ops->vidioc_g_jpegcomp)
-			break;
 		dbgarg(cmd, "quality=%d, APPn=%d, APP_len=%d, "
 					"COM_len=%d, jpeg_markers=%d\n",
 					p->quality, p->APPn, p->APP_len,
 					p->COM_len, p->jpeg_markers);
-			ret = ops->vidioc_s_jpegcomp(file, fh, p);
+		ret = ops->vidioc_s_jpegcomp(file, fh, p);
 		break;
 	}
 	case VIDIOC_G_ENC_INDEX:
 	{
 		struct v4l2_enc_idx *p = arg;
 
-		if (!ops->vidioc_g_enc_index)
-			break;
 		ret = ops->vidioc_g_enc_index(file, fh, p);
 		if (!ret)
 			dbgarg(cmd, "entries=%d, entries_cap=%d\n",
@@ -1775,8 +1951,6 @@ static long __video_do_ioctl(struct file *file,
 	{
 		struct v4l2_encoder_cmd *p = arg;
 
-		if (!ops->vidioc_encoder_cmd)
-			break;
 		ret = ops->vidioc_encoder_cmd(file, fh, p);
 		if (!ret)
 			dbgarg(cmd, "cmd=%d, flags=%x\n", p->cmd, p->flags);
@@ -1786,8 +1960,6 @@ static long __video_do_ioctl(struct file *file,
 	{
 		struct v4l2_encoder_cmd *p = arg;
 
-		if (!ops->vidioc_try_encoder_cmd)
-			break;
 		ret = ops->vidioc_try_encoder_cmd(file, fh, p);
 		if (!ret)
 			dbgarg(cmd, "cmd=%d, flags=%x\n", p->cmd, p->flags);
@@ -1825,8 +1997,6 @@ static long __video_do_ioctl(struct file *file,
 	{
 		struct v4l2_streamparm *p = arg;
 
-		if (!ops->vidioc_s_parm)
-			break;
 		ret = check_fmt(ops, p->type);
 		if (ret)
 			break;
@@ -1839,9 +2009,6 @@ static long __video_do_ioctl(struct file *file,
 	{
 		struct v4l2_tuner *p = arg;
 
-		if (!ops->vidioc_g_tuner)
-			break;
-
 		p->type = (vfd->vfl_type == VFL_TYPE_RADIO) ?
 			V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
 		ret = ops->vidioc_g_tuner(file, fh, p);
@@ -1860,8 +2027,6 @@ static long __video_do_ioctl(struct file *file,
 	{
 		struct v4l2_tuner *p = arg;
 
-		if (!ops->vidioc_s_tuner)
-			break;
 		p->type = (vfd->vfl_type == VFL_TYPE_RADIO) ?
 			V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
 		dbgarg(cmd, "index=%d, name=%s, type=%d, "
@@ -1879,9 +2044,6 @@ static long __video_do_ioctl(struct file *file,
 	{
 		struct v4l2_frequency *p = arg;
 
-		if (!ops->vidioc_g_frequency)
-			break;
-
 		p->type = (vfd->vfl_type == VFL_TYPE_RADIO) ?
 			V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
 		ret = ops->vidioc_g_frequency(file, fh, p);
@@ -1894,8 +2056,6 @@ static long __video_do_ioctl(struct file *file,
 	{
 		struct v4l2_frequency *p = arg;
 
-		if (!ops->vidioc_s_frequency)
-			break;
 		dbgarg(cmd, "tuner=%d, type=%d, frequency=%d\n",
 				p->tuner, p->type, p->frequency);
 		ret = ops->vidioc_s_frequency(file, fh, p);
@@ -1905,9 +2065,6 @@ static long __video_do_ioctl(struct file *file,
 	{
 		struct v4l2_sliced_vbi_cap *p = arg;
 
-		if (!ops->vidioc_g_sliced_vbi_cap)
-			break;
-
 		/* Clear up to type, everything after type is zerod already */
 		memset(p, 0, offsetof(struct v4l2_sliced_vbi_cap, type));
 
@@ -1919,8 +2076,6 @@ static long __video_do_ioctl(struct file *file,
 	}
 	case VIDIOC_LOG_STATUS:
 	{
-		if (!ops->vidioc_log_status)
-			break;
 		ret = ops->vidioc_log_status(file, fh);
 		break;
 	}
@@ -1929,24 +2084,20 @@ static long __video_do_ioctl(struct file *file,
 	{
 		struct v4l2_dbg_register *p = arg;
 
-		if (ops->vidioc_g_register) {
-			if (!capable(CAP_SYS_ADMIN))
-				ret = -EPERM;
-			else
-				ret = ops->vidioc_g_register(file, fh, p);
-		}
+		if (!capable(CAP_SYS_ADMIN))
+			ret = -EPERM;
+		else
+			ret = ops->vidioc_g_register(file, fh, p);
 		break;
 	}
 	case VIDIOC_DBG_S_REGISTER:
 	{
 		struct v4l2_dbg_register *p = arg;
 
-		if (ops->vidioc_s_register) {
-			if (!capable(CAP_SYS_ADMIN))
-				ret = -EPERM;
-			else
-				ret = ops->vidioc_s_register(file, fh, p);
-		}
+		if (!capable(CAP_SYS_ADMIN))
+			ret = -EPERM;
+		else
+			ret = ops->vidioc_s_register(file, fh, p);
 		break;
 	}
 #endif
@@ -1954,8 +2105,6 @@ static long __video_do_ioctl(struct file *file,
 	{
 		struct v4l2_dbg_chip_ident *p = arg;
 
-		if (!ops->vidioc_g_chip_ident)
-			break;
 		p->ident = V4L2_IDENT_NONE;
 		p->revision = 0;
 		ret = ops->vidioc_g_chip_ident(file, fh, p);
@@ -1968,8 +2117,6 @@ static long __video_do_ioctl(struct file *file,
 		struct v4l2_hw_freq_seek *p = arg;
 		enum v4l2_tuner_type type;
 
-		if (!ops->vidioc_s_hw_freq_seek)
-			break;
 		type = (vfd->vfl_type == VFL_TYPE_RADIO) ?
 			V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
 		dbgarg(cmd,
@@ -1985,9 +2132,6 @@ static long __video_do_ioctl(struct file *file,
 	{
 		struct v4l2_frmsizeenum *p = arg;
 
-		if (!ops->vidioc_enum_framesizes)
-			break;
-
 		ret = ops->vidioc_enum_framesizes(file, fh, p);
 		dbgarg(cmd,
 			"index=%d, pixelformat=%c%c%c%c, type=%d ",
@@ -2021,9 +2165,6 @@ static long __video_do_ioctl(struct file *file,
 	{
 		struct v4l2_frmivalenum *p = arg;
 
-		if (!ops->vidioc_enum_frameintervals)
-			break;
-
 		ret = ops->vidioc_enum_frameintervals(file, fh, p);
 		dbgarg(cmd,
 			"index=%d, pixelformat=%d, width=%d, height=%d, type=%d ",
@@ -2056,9 +2197,6 @@ static long __video_do_ioctl(struct file *file,
 	{
 		struct v4l2_dv_enum_preset *p = arg;
 
-		if (!ops->vidioc_enum_dv_presets)
-			break;
-
 		ret = ops->vidioc_enum_dv_presets(file, fh, p);
 		if (!ret)
 			dbgarg(cmd,
@@ -2072,9 +2210,6 @@ static long __video_do_ioctl(struct file *file,
 	{
 		struct v4l2_dv_preset *p = arg;
 
-		if (!ops->vidioc_s_dv_preset)
-			break;
-
 		dbgarg(cmd, "preset=%d\n", p->preset);
 		ret = ops->vidioc_s_dv_preset(file, fh, p);
 		break;
@@ -2083,9 +2218,6 @@ static long __video_do_ioctl(struct file *file,
 	{
 		struct v4l2_dv_preset *p = arg;
 
-		if (!ops->vidioc_g_dv_preset)
-			break;
-
 		ret = ops->vidioc_g_dv_preset(file, fh, p);
 		if (!ret)
 			dbgarg(cmd, "preset=%d\n", p->preset);
@@ -2095,9 +2227,6 @@ static long __video_do_ioctl(struct file *file,
 	{
 		struct v4l2_dv_preset *p = arg;
 
-		if (!ops->vidioc_query_dv_preset)
-			break;
-
 		ret = ops->vidioc_query_dv_preset(file, fh, p);
 		if (!ret)
 			dbgarg(cmd, "preset=%d\n", p->preset);
@@ -2107,9 +2236,6 @@ static long __video_do_ioctl(struct file *file,
 	{
 		struct v4l2_dv_timings *p = arg;
 
-		if (!ops->vidioc_s_dv_timings)
-			break;
-
 		switch (p->type) {
 		case V4L2_DV_BT_656_1120:
 			dbgarg2("bt-656/1120:interlaced=%d, pixelclock=%lld,"
@@ -2137,9 +2263,6 @@ static long __video_do_ioctl(struct file *file,
 	{
 		struct v4l2_dv_timings *p = arg;
 
-		if (!ops->vidioc_g_dv_timings)
-			break;
-
 		ret = ops->vidioc_g_dv_timings(file, fh, p);
 		if (!ret) {
 			switch (p->type) {
@@ -2171,9 +2294,6 @@ static long __video_do_ioctl(struct file *file,
 	{
 		struct v4l2_event *ev = arg;
 
-		if (!ops->vidioc_subscribe_event)
-			break;
-
 		ret = v4l2_event_dequeue(fh, ev, file->f_flags & O_NONBLOCK);
 		if (ret < 0) {
 			dbgarg(cmd, "no pending events?");
@@ -2190,9 +2310,6 @@ static long __video_do_ioctl(struct file *file,
 	{
 		struct v4l2_event_subscription *sub = arg;
 
-		if (!ops->vidioc_subscribe_event)
-			break;
-
 		ret = ops->vidioc_subscribe_event(fh, sub);
 		if (ret < 0) {
 			dbgarg(cmd, "failed, ret=%ld", ret);
@@ -2205,9 +2322,6 @@ static long __video_do_ioctl(struct file *file,
 	{
 		struct v4l2_event_subscription *sub = arg;
 
-		if (!ops->vidioc_unsubscribe_event)
-			break;
-
 		ret = ops->vidioc_unsubscribe_event(fh, sub);
 		if (ret < 0) {
 			dbgarg(cmd, "failed, ret=%ld", ret);
@@ -2220,8 +2334,6 @@ static long __video_do_ioctl(struct file *file,
 	{
 		bool valid_prio = true;
 
-		if (!ops->vidioc_default)
-			break;
 		if (use_fh_prio)
 			valid_prio = v4l2_prio_check(vfd->prio, vfh->prio) >= 0;
 		ret = ops->vidioc_default(file, fh, valid_prio, cmd, arg);
-- 
1.7.1

