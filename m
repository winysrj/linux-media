Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:36671 "EHLO
        lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750780AbdEJGhC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 10 May 2017 02:37:02 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH[ v4l2-ioctl.c: always copy G/S_EDID result
Message-ID: <ea4085e3-07aa-44f5-fef6-4913858bd707@xs4all.nl>
Date: Wed, 10 May 2017 08:36:56 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The VIDIOC_G/S_EDID ioctls can return valid data even if an error is returned.

Mark those ioctls accordingly. Rather than using an explicit 'if' to check for the
ioctl (as was done until now for VIDIOC_QUERY_DV_TIMINGS) just set a new flag in the
v4l2_ioctls array.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index e5a2187381db..4f27cfa134a1 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -2472,20 +2472,22 @@ struct v4l2_ioctl_info {
 };

 /* This control needs a priority check */
-#define INFO_FL_PRIO	(1 << 0)
+#define INFO_FL_PRIO		(1 << 0)
 /* This control can be valid if the filehandle passes a control handler. */
-#define INFO_FL_CTRL	(1 << 1)
+#define INFO_FL_CTRL		(1 << 1)
 /* This is a standard ioctl, no need for special code */
-#define INFO_FL_STD	(1 << 2)
+#define INFO_FL_STD		(1 << 2)
 /* This is ioctl has its own function */
-#define INFO_FL_FUNC	(1 << 3)
+#define INFO_FL_FUNC		(1 << 3)
 /* Queuing ioctl */
-#define INFO_FL_QUEUE	(1 << 4)
+#define INFO_FL_QUEUE		(1 << 4)
+/* Always copy back result, even on error */
+#define INFO_FL_ALWAYS_COPY	(1 << 5)
 /* Zero struct from after the field to the end */
 #define INFO_FL_CLEAR(v4l2_struct, field)			\
 	((offsetof(struct v4l2_struct, field) +			\
 	  sizeof(((struct v4l2_struct *)0)->field)) << 16)
-#define INFO_FL_CLEAR_MASK (_IOC_SIZEMASK << 16)
+#define INFO_FL_CLEAR_MASK 	(_IOC_SIZEMASK << 16)

 #define IOCTL_INFO_STD(_ioctl, _vidioc, _debug, _flags)			\
 	[_IOC_NR(_ioctl)] = {						\
@@ -2536,8 +2538,8 @@ static struct v4l2_ioctl_info v4l2_ioctls[] = {
 	IOCTL_INFO_FNC(VIDIOC_QUERYMENU, v4l_querymenu, v4l_print_querymenu, INFO_FL_CTRL | INFO_FL_CLEAR(v4l2_querymenu, index)),
 	IOCTL_INFO_STD(VIDIOC_G_INPUT, vidioc_g_input, v4l_print_u32, 0),
 	IOCTL_INFO_FNC(VIDIOC_S_INPUT, v4l_s_input, v4l_print_u32, INFO_FL_PRIO),
-	IOCTL_INFO_STD(VIDIOC_G_EDID, vidioc_g_edid, v4l_print_edid, 0),
-	IOCTL_INFO_STD(VIDIOC_S_EDID, vidioc_s_edid, v4l_print_edid, INFO_FL_PRIO),
+	IOCTL_INFO_STD(VIDIOC_G_EDID, vidioc_g_edid, v4l_print_edid, INFO_FL_ALWAYS_COPY),
+	IOCTL_INFO_STD(VIDIOC_S_EDID, vidioc_s_edid, v4l_print_edid, INFO_FL_PRIO | INFO_FL_ALWAYS_COPY),
 	IOCTL_INFO_STD(VIDIOC_G_OUTPUT, vidioc_g_output, v4l_print_u32, 0),
 	IOCTL_INFO_FNC(VIDIOC_S_OUTPUT, v4l_s_output, v4l_print_u32, INFO_FL_PRIO),
 	IOCTL_INFO_FNC(VIDIOC_ENUMOUTPUT, v4l_enumoutput, v4l_print_enumoutput, INFO_FL_CLEAR(v4l2_output, index)),
@@ -2583,7 +2585,7 @@ static struct v4l2_ioctl_info v4l2_ioctls[] = {
 	IOCTL_INFO_FNC(VIDIOC_CREATE_BUFS, v4l_create_bufs, v4l_print_create_buffers, INFO_FL_PRIO | INFO_FL_QUEUE),
 	IOCTL_INFO_FNC(VIDIOC_PREPARE_BUF, v4l_prepare_buf, v4l_print_buffer, INFO_FL_QUEUE),
 	IOCTL_INFO_STD(VIDIOC_ENUM_DV_TIMINGS, vidioc_enum_dv_timings, v4l_print_enum_dv_timings, INFO_FL_CLEAR(v4l2_enum_dv_timings, pad)),
-	IOCTL_INFO_STD(VIDIOC_QUERY_DV_TIMINGS, vidioc_query_dv_timings, v4l_print_dv_timings, 0),
+	IOCTL_INFO_STD(VIDIOC_QUERY_DV_TIMINGS, vidioc_query_dv_timings, v4l_print_dv_timings, INFO_FL_ALWAYS_COPY),
 	IOCTL_INFO_STD(VIDIOC_DV_TIMINGS_CAP, vidioc_dv_timings_cap, v4l_print_dv_timings_cap, INFO_FL_CLEAR(v4l2_dv_timings_cap, type)),
 	IOCTL_INFO_FNC(VIDIOC_ENUM_FREQ_BANDS, v4l_enum_freq_bands, v4l_print_freq_band, 0),
 	IOCTL_INFO_FNC(VIDIOC_DBG_G_CHIP_INFO, v4l_dbg_g_chip_info, v4l_print_dbg_chip_info, INFO_FL_CLEAR(v4l2_dbg_chip_info, match)),
@@ -2801,6 +2803,7 @@ video_usercopy(struct file *file, unsigned int cmd, unsigned long arg,
 	void	*parg = (void *)arg;
 	long	err  = -EINVAL;
 	bool	has_array_args;
+	bool	always_copy = false;
 	size_t  array_size = 0;
 	void __user *user_ptr = NULL;
 	void	**kernel_ptr = NULL;
@@ -2830,8 +2833,10 @@ video_usercopy(struct file *file, unsigned int cmd, unsigned long arg,
 			 */
 			if (v4l2_is_known_ioctl(cmd)) {
 				u32 flags = v4l2_ioctls[_IOC_NR(cmd)].flags;
+
 				if (flags & INFO_FL_CLEAR_MASK)
 					n = (flags & INFO_FL_CLEAR_MASK) >> 16;
+				always_copy = flags & INFO_FL_ALWAYS_COPY;
 			}

 			if (copy_from_user(parg, (void __user *)arg, n))
@@ -2885,9 +2890,11 @@ video_usercopy(struct file *file, unsigned int cmd, unsigned long arg,
 			err = -EFAULT;
 		goto out_array_args;
 	}
-	/* VIDIOC_QUERY_DV_TIMINGS can return an error, but still have valid
-	   results that must be returned. */
-	if (err < 0 && cmd != VIDIOC_QUERY_DV_TIMINGS)
+	/*
+	 * Some ioctls can return an error, but still have valid
+	 * results that must be returned.
+	 */
+	if (err < 0 && !always_copy)
 		goto out;

 out_array_args:
