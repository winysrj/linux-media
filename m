Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:2733 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906Ab1HIMeR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Aug 2011 08:34:17 -0400
Received: from tschai.localnet (64-103-25-233.cisco.com [64.103.25.233])
	(authenticated bits=0)
	by smtp-vbr15.xs4all.nl (8.13.8/8.13.8) with ESMTP id p79CYFBY003375
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Tue, 9 Aug 2011 14:34:16 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [RFC PATCH] More ENOTTY fixes for v3.1
Date: Tue, 9 Aug 2011 14:34:14 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201108091434.14980.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch fixes the remaining -ENOTTY fallout:

- The ENUM_FMT ops form a subset of the ops used with G/S/TRY_FMT, so list those
  explicitly instead of using a macro.
- Extend the G/S/TRY_FMT ops test to the full set.
- Move all prio tests down to the correct switch cases.
- Fix some 'returns ENOTTY instead of EINVAL' issues with the extended controls
  ioctls and the ENUMSTD, S_STD and G_PARM ioctls.

This patch + two other vivi and ivtv driver fixes can be found here:

http://git.linuxtv.org/hverkuil/media_tree.git/shortlog/refs/heads/enottyv2

Comments welcome,

	Hans

diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index 9f80e9d..a0089bf 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -55,13 +55,18 @@
 	memset((u8 *)(p) + offsetof(typeof(*(p)), field) + sizeof((p)->field), \
 	0, sizeof(*(p)) - offsetof(typeof(*(p)), field) - sizeof((p)->field))
 
-#define no_ioctl_err(foo) ( (						\
+#define have_fmt_ops(foo) (						\
 	ops->vidioc_##foo##_fmt_vid_cap ||				\
 	ops->vidioc_##foo##_fmt_vid_out ||				\
 	ops->vidioc_##foo##_fmt_vid_cap_mplane ||			\
 	ops->vidioc_##foo##_fmt_vid_out_mplane ||			\
 	ops->vidioc_##foo##_fmt_vid_overlay ||				\
-	ops->vidioc_##foo##_fmt_type_private) ? -EINVAL : -ENOTTY)
+	ops->vidioc_##foo##_fmt_vbi_cap ||				\
+	ops->vidioc_##foo##_fmt_vid_out_overlay ||			\
+	ops->vidioc_##foo##_fmt_vbi_out ||				\
+	ops->vidioc_##foo##_fmt_sliced_vbi_cap ||			\
+	ops->vidioc_##foo##_fmt_sliced_vbi_out ||			\
+	ops->vidioc_##foo##_fmt_type_private)
 
 struct std_descr {
 	v4l2_std_id std;
@@ -551,6 +556,7 @@ static long __video_do_ioctl(struct file *file,
 	struct v4l2_fh *vfh = NULL;
 	struct v4l2_format f_copy;
 	int use_fh_prio = 0;
+	long ret_prio = 0;
 	long ret = -ENOTTY;
 
 	if (ops == NULL) {
@@ -570,39 +576,8 @@ static long __video_do_ioctl(struct file *file,
 		use_fh_prio = test_bit(V4L2_FL_USE_FH_PRIO, &vfd->flags);
 	}
 
-	if (use_fh_prio) {
-		switch (cmd) {
-		case VIDIOC_S_CTRL:
-		case VIDIOC_S_STD:
-		case VIDIOC_S_INPUT:
-		case VIDIOC_S_OUTPUT:
-		case VIDIOC_S_TUNER:
-		case VIDIOC_S_FREQUENCY:
-		case VIDIOC_S_FMT:
-		case VIDIOC_S_CROP:
-		case VIDIOC_S_AUDIO:
-		case VIDIOC_S_AUDOUT:
-		case VIDIOC_S_EXT_CTRLS:
-		case VIDIOC_S_FBUF:
-		case VIDIOC_S_PRIORITY:
-		case VIDIOC_S_DV_PRESET:
-		case VIDIOC_S_DV_TIMINGS:
-		case VIDIOC_S_JPEGCOMP:
-		case VIDIOC_S_MODULATOR:
-		case VIDIOC_S_PARM:
-		case VIDIOC_S_HW_FREQ_SEEK:
-		case VIDIOC_ENCODER_CMD:
-		case VIDIOC_OVERLAY:
-		case VIDIOC_REQBUFS:
-		case VIDIOC_STREAMON:
-		case VIDIOC_STREAMOFF:
-			ret = v4l2_prio_check(vfd->prio, vfh->prio);
-			if (ret)
-				goto exit_prio;
-			ret = -ENOTTY;
-			break;
-		}
-	}
+	if (use_fh_prio)
+		ret_prio = v4l2_prio_check(vfd->prio, vfh->prio);
 
 	switch (cmd) {
 
@@ -651,7 +626,9 @@ static long __video_do_ioctl(struct file *file,
 		if (ops->vidioc_s_priority)
 			ret = ops->vidioc_s_priority(file, fh, *p);
 		else
-			ret = v4l2_prio_change(&vfd->v4l2_dev->prio, &vfh->prio, *p);
+			ret = ret_prio ? ret_prio :
+				v4l2_prio_change(&vfd->v4l2_dev->prio,
+							&vfh->prio, *p);
 		break;
 	}
 
@@ -701,8 +678,14 @@ static long __video_do_ioctl(struct file *file,
 				(f->pixelformat >> 16) & 0xff,
 				(f->pixelformat >> 24) & 0xff,
 				f->description);
-		else if (ret == -ENOTTY)
-			ret = no_ioctl_err(enum);
+		else if (ret == -ENOTTY &&
+			 (ops->vidioc_enum_fmt_vid_cap ||
+			  ops->vidioc_enum_fmt_vid_out ||
+			  ops->vidioc_enum_fmt_vid_cap_mplane ||
+			  ops->vidioc_enum_fmt_vid_out_mplane ||
+			  ops->vidioc_enum_fmt_vid_overlay ||
+			  ops->vidioc_enum_fmt_type_private))
+			ret = -EINVAL;
 		break;
 	}
 	case VIDIOC_G_FMT:
@@ -827,8 +810,8 @@ static long __video_do_ioctl(struct file *file,
 								fh, f);
 			break;
 		}
-		if (unlikely(ret == -ENOTTY))
-			ret = no_ioctl_err(g);
+		if (unlikely(ret == -ENOTTY && have_fmt_ops(g)))
+			ret = -EINVAL;
 
 		break;
 	}
@@ -836,6 +819,14 @@ static long __video_do_ioctl(struct file *file,
 	{
 		struct v4l2_format *f = (struct v4l2_format *)arg;
 
+		if (!have_fmt_ops(s))
+			break;
+		if (ret_prio) {
+			ret = ret_prio;
+			break;
+		}
+		ret = -EINVAL;
+
 		/* FIXME: Should be one dump per type */
 		dbgarg(cmd, "type=%s\n", prt_names(f->type, v4l2_type_names));
 
@@ -966,8 +957,6 @@ static long __video_do_ioctl(struct file *file,
 								fh, f);
 			break;
 		}
-		if (unlikely(ret == -ENOTTY))
-			ret = no_ioctl_err(g);
 		break;
 	}
 	case VIDIOC_TRY_FMT:
@@ -1097,8 +1086,6 @@ static long __video_do_ioctl(struct file *file,
 			if (likely(ops->vidioc_try_fmt_sliced_vbi_out))
 				ret = ops->vidioc_try_fmt_sliced_vbi_out(file,
 								fh, f);
-			else
-				ret = no_ioctl_err(try);
 			break;
 		case V4L2_BUF_TYPE_PRIVATE:
 			/* CLEAR_AFTER_FIELD(f, fmt.raw_data); <- does nothing */
@@ -1107,8 +1094,8 @@ static long __video_do_ioctl(struct file *file,
 								fh, f);
 			break;
 		}
-		if (unlikely(ret == -ENOTTY))
-			ret = no_ioctl_err(g);
+		if (unlikely(ret == -ENOTTY && have_fmt_ops(try)))
+			ret = -EINVAL;
 		break;
 	}
 	/* FIXME: Those buf reqs could be handled here,
@@ -1121,6 +1108,10 @@ static long __video_do_ioctl(struct file *file,
 
 		if (!ops->vidioc_reqbufs)
 			break;
+		if (ret_prio) {
+			ret = ret_prio;
+			break;
+		}
 		ret = check_fmt(ops, p->type);
 		if (ret)
 			break;
@@ -1186,6 +1177,10 @@ static long __video_do_ioctl(struct file *file,
 
 		if (!ops->vidioc_overlay)
 			break;
+		if (ret_prio) {
+			ret = ret_prio;
+			break;
+		}
 		dbgarg(cmd, "value=%d\n", *i);
 		ret = ops->vidioc_overlay(file, fh, *i);
 		break;
@@ -1211,6 +1206,10 @@ static long __video_do_ioctl(struct file *file,
 
 		if (!ops->vidioc_s_fbuf)
 			break;
+		if (ret_prio) {
+			ret = ret_prio;
+			break;
+		}
 		dbgarg(cmd, "capability=0x%x, flags=%d, base=0x%08lx\n",
 			p->capability, p->flags, (unsigned long)p->base);
 		v4l_print_pix_fmt(vfd, &p->fmt);
@@ -1223,6 +1222,10 @@ static long __video_do_ioctl(struct file *file,
 
 		if (!ops->vidioc_streamon)
 			break;
+		if (ret_prio) {
+			ret = ret_prio;
+			break;
+		}
 		dbgarg(cmd, "type=%s\n", prt_names(i, v4l2_type_names));
 		ret = ops->vidioc_streamon(file, fh, i);
 		break;
@@ -1233,6 +1236,10 @@ static long __video_do_ioctl(struct file *file,
 
 		if (!ops->vidioc_streamoff)
 			break;
+		if (ret_prio) {
+			ret = ret_prio;
+			break;
+		}
 		dbgarg(cmd, "type=%s\n", prt_names(i, v4l2_type_names));
 		ret = ops->vidioc_streamoff(file, fh, i);
 		break;
@@ -1245,6 +1252,10 @@ static long __video_do_ioctl(struct file *file,
 		unsigned int index = p->index, i, j = 0;
 		const char *descr = "";
 
+		if (id == 0)
+			break;
+		ret = -EINVAL;
+
 		/* Return norm array in a canonical way */
 		for (i = 0; i <= index && id; i++) {
 			/* last std value in the standards array is 0, so this
@@ -1298,13 +1309,20 @@ static long __video_do_ioctl(struct file *file,
 
 		dbgarg(cmd, "std=%08Lx\n", (long long unsigned)*id);
 
+		if (!ops->vidioc_s_std)
+			break;
+
+		if (ret_prio) {
+			ret = ret_prio;
+			break;
+		}
+		ret = -EINVAL;
 		norm = (*id) & vfd->tvnorms;
 		if (vfd->tvnorms && !norm)	/* Check if std is supported */
 			break;
 
 		/* Calls the specific handler */
-		if (ops->vidioc_s_std)
-			ret = ops->vidioc_s_std(file, fh, &norm);
+		ret = ops->vidioc_s_std(file, fh, &norm);
 
 		/* Updates standard information */
 		if (ret >= 0)
@@ -1373,6 +1391,10 @@ static long __video_do_ioctl(struct file *file,
 
 		if (!ops->vidioc_s_input)
 			break;
+		if (ret_prio) {
+			ret = ret_prio;
+			break;
+		}
 		dbgarg(cmd, "value=%d\n", *i);
 		ret = ops->vidioc_s_input(file, fh, *i);
 		break;
@@ -1425,6 +1447,10 @@ static long __video_do_ioctl(struct file *file,
 
 		if (!ops->vidioc_s_output)
 			break;
+		if (ret_prio) {
+			ret = ret_prio;
+			break;
+		}
 		dbgarg(cmd, "value=%d\n", *i);
 		ret = ops->vidioc_s_output(file, fh, *i);
 		break;
@@ -1494,6 +1520,10 @@ static long __video_do_ioctl(struct file *file,
 		if (!(vfh && vfh->ctrl_handler) && !vfd->ctrl_handler &&
 			!ops->vidioc_s_ctrl && !ops->vidioc_s_ext_ctrls)
 			break;
+		if (ret_prio) {
+			ret = ret_prio;
+			break;
+		}
 
 		dbgarg(cmd, "id=0x%x, value=%d\n", p->id, p->value);
 
@@ -1519,6 +1549,8 @@ static long __video_do_ioctl(struct file *file,
 		ctrl.value = p->value;
 		if (check_ext_ctrls(&ctrls, 1))
 			ret = ops->vidioc_s_ext_ctrls(file, fh, &ctrls);
+		else
+			ret = -EINVAL;
 		break;
 	}
 	case VIDIOC_G_EXT_CTRLS:
@@ -1530,8 +1562,10 @@ static long __video_do_ioctl(struct file *file,
 			ret = v4l2_g_ext_ctrls(vfh->ctrl_handler, p);
 		else if (vfd->ctrl_handler)
 			ret = v4l2_g_ext_ctrls(vfd->ctrl_handler, p);
-		else if (ops->vidioc_g_ext_ctrls && check_ext_ctrls(p, 0))
-			ret = ops->vidioc_g_ext_ctrls(file, fh, p);
+		else if (ops->vidioc_g_ext_ctrls)
+			ret = check_ext_ctrls(p, 0) ?
+				ops->vidioc_g_ext_ctrls(file, fh, p) :
+				-EINVAL;
 		else
 			break;
 		v4l_print_ext_ctrls(cmd, vfd, p, !ret);
@@ -1545,6 +1579,10 @@ static long __video_do_ioctl(struct file *file,
 		if (!(vfh && vfh->ctrl_handler) && !vfd->ctrl_handler &&
 				!ops->vidioc_s_ext_ctrls)
 			break;
+		if (ret_prio) {
+			ret = ret_prio;
+			break;
+		}
 		v4l_print_ext_ctrls(cmd, vfd, p, 1);
 		if (vfh && vfh->ctrl_handler)
 			ret = v4l2_s_ext_ctrls(vfh, vfh->ctrl_handler, p);
@@ -1552,6 +1590,8 @@ static long __video_do_ioctl(struct file *file,
 			ret = v4l2_s_ext_ctrls(NULL, vfd->ctrl_handler, p);
 		else if (check_ext_ctrls(p, 0))
 			ret = ops->vidioc_s_ext_ctrls(file, fh, p);
+		else
+			ret = -EINVAL;
 		break;
 	}
 	case VIDIOC_TRY_EXT_CTRLS:
@@ -1569,6 +1609,8 @@ static long __video_do_ioctl(struct file *file,
 			ret = v4l2_try_ext_ctrls(vfd->ctrl_handler, p);
 		else if (check_ext_ctrls(p, 0))
 			ret = ops->vidioc_try_ext_ctrls(file, fh, p);
+		else
+			ret = -EINVAL;
 		break;
 	}
 	case VIDIOC_QUERYMENU:
@@ -1629,6 +1671,10 @@ static long __video_do_ioctl(struct file *file,
 
 		if (!ops->vidioc_s_audio)
 			break;
+		if (ret_prio) {
+			ret = ret_prio;
+			break;
+		}
 		dbgarg(cmd, "index=%d, name=%s, capability=0x%x, "
 					"mode=0x%x\n", p->index, p->name,
 					p->capability, p->mode);
@@ -1669,6 +1715,10 @@ static long __video_do_ioctl(struct file *file,
 
 		if (!ops->vidioc_s_audout)
 			break;
+		if (ret_prio) {
+			ret = ret_prio;
+			break;
+		}
 		dbgarg(cmd, "index=%d, name=%s, capability=%d, "
 					"mode=%d\n", p->index, p->name,
 					p->capability, p->mode);
@@ -1698,6 +1748,10 @@ static long __video_do_ioctl(struct file *file,
 
 		if (!ops->vidioc_s_modulator)
 			break;
+		if (ret_prio) {
+			ret = ret_prio;
+			break;
+		}
 		dbgarg(cmd, "index=%d, name=%s, capability=%d, "
 				"rangelow=%d, rangehigh=%d, txsubchans=%d\n",
 				p->index, p->name, p->capability, p->rangelow,
@@ -1724,6 +1778,10 @@ static long __video_do_ioctl(struct file *file,
 
 		if (!ops->vidioc_s_crop)
 			break;
+		if (ret_prio) {
+			ret = ret_prio;
+			break;
+		}
 		dbgarg(cmd, "type=%s\n", prt_names(p->type, v4l2_type_names));
 		dbgrect(vfd, "", &p->c);
 		ret = ops->vidioc_s_crop(file, fh, p);
@@ -1767,11 +1825,15 @@ static long __video_do_ioctl(struct file *file,
 
 		if (!ops->vidioc_g_jpegcomp)
 			break;
+		if (ret_prio) {
+			ret = ret_prio;
+			break;
+		}
 		dbgarg(cmd, "quality=%d, APPn=%d, APP_len=%d, "
 					"COM_len=%d, jpeg_markers=%d\n",
 					p->quality, p->APPn, p->APP_len,
 					p->COM_len, p->jpeg_markers);
-			ret = ops->vidioc_s_jpegcomp(file, fh, p);
+		ret = ops->vidioc_s_jpegcomp(file, fh, p);
 		break;
 	}
 	case VIDIOC_G_ENC_INDEX:
@@ -1792,6 +1854,10 @@ static long __video_do_ioctl(struct file *file,
 
 		if (!ops->vidioc_encoder_cmd)
 			break;
+		if (ret_prio) {
+			ret = ret_prio;
+			break;
+		}
 		ret = ops->vidioc_encoder_cmd(file, fh, p);
 		if (!ret)
 			dbgarg(cmd, "cmd=%d, flags=%x\n", p->cmd, p->flags);
@@ -1812,6 +1878,8 @@ static long __video_do_ioctl(struct file *file,
 	{
 		struct v4l2_streamparm *p = arg;
 
+		if (!ops->vidioc_g_parm && !vfd->current_norm)
+			break;
 		if (ops->vidioc_g_parm) {
 			ret = check_fmt(ops, p->type);
 			if (ret)
@@ -1820,14 +1888,13 @@ static long __video_do_ioctl(struct file *file,
 		} else {
 			v4l2_std_id std = vfd->current_norm;
 
+			ret = -EINVAL;
 			if (p->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 				break;
 
 			ret = 0;
 			if (ops->vidioc_g_std)
 				ret = ops->vidioc_g_std(file, fh, &std);
-			else if (std == 0)
-				ret = -ENOTTY;
 			if (ret == 0)
 				v4l2_video_std_frame_period(std,
 						    &p->parm.capture.timeperframe);
@@ -1842,6 +1909,10 @@ static long __video_do_ioctl(struct file *file,
 
 		if (!ops->vidioc_s_parm)
 			break;
+		if (ret_prio) {
+			ret = ret_prio;
+			break;
+		}
 		ret = check_fmt(ops, p->type);
 		if (ret)
 			break;
@@ -1877,6 +1948,10 @@ static long __video_do_ioctl(struct file *file,
 
 		if (!ops->vidioc_s_tuner)
 			break;
+		if (ret_prio) {
+			ret = ret_prio;
+			break;
+		}
 		p->type = (vfd->vfl_type == VFL_TYPE_RADIO) ?
 			V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
 		dbgarg(cmd, "index=%d, name=%s, type=%d, "
@@ -1911,6 +1986,10 @@ static long __video_do_ioctl(struct file *file,
 
 		if (!ops->vidioc_s_frequency)
 			break;
+		if (ret_prio) {
+			ret = ret_prio;
+			break;
+		}
 		dbgarg(cmd, "tuner=%d, type=%d, frequency=%d\n",
 				p->tuner, p->type, p->frequency);
 		ret = ops->vidioc_s_frequency(file, fh, p);
@@ -1985,6 +2064,10 @@ static long __video_do_ioctl(struct file *file,
 
 		if (!ops->vidioc_s_hw_freq_seek)
 			break;
+		if (ret_prio) {
+			ret = ret_prio;
+			break;
+		}
 		type = (vfd->vfl_type == VFL_TYPE_RADIO) ?
 			V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
 		dbgarg(cmd,
@@ -2089,6 +2172,10 @@ static long __video_do_ioctl(struct file *file,
 
 		if (!ops->vidioc_s_dv_preset)
 			break;
+		if (ret_prio) {
+			ret = ret_prio;
+			break;
+		}
 
 		dbgarg(cmd, "preset=%d\n", p->preset);
 		ret = ops->vidioc_s_dv_preset(file, fh, p);
@@ -2124,6 +2211,10 @@ static long __video_do_ioctl(struct file *file,
 
 		if (!ops->vidioc_s_dv_timings)
 			break;
+		if (ret_prio) {
+			ret = ret_prio;
+			break;
+		}
 
 		switch (p->type) {
 		case V4L2_DV_BT_656_1120:
@@ -2232,19 +2323,12 @@ static long __video_do_ioctl(struct file *file,
 		break;
 	}
 	default:
-	{
-		bool valid_prio = true;
-
 		if (!ops->vidioc_default)
 			break;
-		if (use_fh_prio)
-			valid_prio = v4l2_prio_check(vfd->prio, vfh->prio) >= 0;
-		ret = ops->vidioc_default(file, fh, valid_prio, cmd, arg);
+		ret = ops->vidioc_default(file, fh, ret_prio >= 0, cmd, arg);
 		break;
-	}
 	} /* switch */
 
-exit_prio:
 	if (vfd->debug & V4L2_DEBUG_IOCTL_ARG) {
 		if (ret < 0) {
 			v4l_print_ioctl(vfd->name, cmd);
