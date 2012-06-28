Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:1373 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859Ab2F1Gsg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jun 2012 02:48:36 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Pawel Osciak <pawel@osciak.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv3 PATCH 02/33] v4l2-ioctl.c: introduce INFO_FL_CLEAR to replace switch.
Date: Thu, 28 Jun 2012 08:47:56 +0200
Message-Id: <a0ce0e927df5fdc721f113dac454354a8edf1964.1340865818.git.hans.verkuil@cisco.com>
In-Reply-To: <1340866107-4188-1-git-send-email-hverkuil@xs4all.nl>
References: <1340866107-4188-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <d97434d2319fb8dbea360404f9343c680b5b196e.1340865818.git.hans.verkuil@cisco.com>
References: <d97434d2319fb8dbea360404f9343c680b5b196e.1340865818.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The switch statement that determines how much data should be copied from
userspace is replaced by a table lookup.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/v4l2-ioctl.c |  103 +++++++++++++++-----------------------
 1 file changed, 41 insertions(+), 62 deletions(-)

diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index 46fd953..e2f77bc 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -394,7 +394,7 @@ static int check_fmt(const struct v4l2_ioctl_ops *ops, enum v4l2_buf_type type)
 
 struct v4l2_ioctl_info {
 	unsigned int ioctl;
-	u16 flags;
+	u32 flags;
 	const char * const name;
 };
 
@@ -402,6 +402,11 @@ struct v4l2_ioctl_info {
 #define INFO_FL_PRIO	(1 << 0)
 /* This control can be valid if the filehandle passes a control handler. */
 #define INFO_FL_CTRL	(1 << 1)
+/* Zero struct from after the field to the end */
+#define INFO_FL_CLEAR(v4l2_struct, field)			\
+	((offsetof(struct v4l2_struct, field) +			\
+	  sizeof(((struct v4l2_struct *)0)->field)) << 16)
+#define INFO_FL_CLEAR_MASK (_IOC_SIZEMASK << 16)
 
 #define IOCTL_INFO(_ioctl, _flags) [_IOC_NR(_ioctl)] = {	\
 	.ioctl = _ioctl,					\
@@ -411,11 +416,11 @@ struct v4l2_ioctl_info {
 
 static struct v4l2_ioctl_info v4l2_ioctls[] = {
 	IOCTL_INFO(VIDIOC_QUERYCAP, 0),
-	IOCTL_INFO(VIDIOC_ENUM_FMT, 0),
-	IOCTL_INFO(VIDIOC_G_FMT, 0),
+	IOCTL_INFO(VIDIOC_ENUM_FMT, INFO_FL_CLEAR(v4l2_fmtdesc, type)),
+	IOCTL_INFO(VIDIOC_G_FMT, INFO_FL_CLEAR(v4l2_format, type)),
 	IOCTL_INFO(VIDIOC_S_FMT, INFO_FL_PRIO),
 	IOCTL_INFO(VIDIOC_REQBUFS, INFO_FL_PRIO),
-	IOCTL_INFO(VIDIOC_QUERYBUF, 0),
+	IOCTL_INFO(VIDIOC_QUERYBUF, INFO_FL_CLEAR(v4l2_buffer, length)),
 	IOCTL_INFO(VIDIOC_G_FBUF, 0),
 	IOCTL_INFO(VIDIOC_S_FBUF, INFO_FL_PRIO),
 	IOCTL_INFO(VIDIOC_OVERLAY, INFO_FL_PRIO),
@@ -423,33 +428,33 @@ static struct v4l2_ioctl_info v4l2_ioctls[] = {
 	IOCTL_INFO(VIDIOC_DQBUF, 0),
 	IOCTL_INFO(VIDIOC_STREAMON, INFO_FL_PRIO),
 	IOCTL_INFO(VIDIOC_STREAMOFF, INFO_FL_PRIO),
-	IOCTL_INFO(VIDIOC_G_PARM, 0),
+	IOCTL_INFO(VIDIOC_G_PARM, INFO_FL_CLEAR(v4l2_streamparm, type)),
 	IOCTL_INFO(VIDIOC_S_PARM, INFO_FL_PRIO),
 	IOCTL_INFO(VIDIOC_G_STD, 0),
 	IOCTL_INFO(VIDIOC_S_STD, INFO_FL_PRIO),
-	IOCTL_INFO(VIDIOC_ENUMSTD, 0),
-	IOCTL_INFO(VIDIOC_ENUMINPUT, 0),
+	IOCTL_INFO(VIDIOC_ENUMSTD, INFO_FL_CLEAR(v4l2_standard, index)),
+	IOCTL_INFO(VIDIOC_ENUMINPUT, INFO_FL_CLEAR(v4l2_input, index)),
 	IOCTL_INFO(VIDIOC_G_CTRL, INFO_FL_CTRL),
 	IOCTL_INFO(VIDIOC_S_CTRL, INFO_FL_PRIO | INFO_FL_CTRL),
-	IOCTL_INFO(VIDIOC_G_TUNER, 0),
+	IOCTL_INFO(VIDIOC_G_TUNER, INFO_FL_CLEAR(v4l2_tuner, index)),
 	IOCTL_INFO(VIDIOC_S_TUNER, INFO_FL_PRIO),
 	IOCTL_INFO(VIDIOC_G_AUDIO, 0),
 	IOCTL_INFO(VIDIOC_S_AUDIO, INFO_FL_PRIO),
-	IOCTL_INFO(VIDIOC_QUERYCTRL, INFO_FL_CTRL),
-	IOCTL_INFO(VIDIOC_QUERYMENU, INFO_FL_CTRL),
+	IOCTL_INFO(VIDIOC_QUERYCTRL, INFO_FL_CTRL | INFO_FL_CLEAR(v4l2_queryctrl, id)),
+	IOCTL_INFO(VIDIOC_QUERYMENU, INFO_FL_CTRL | INFO_FL_CLEAR(v4l2_querymenu, index)),
 	IOCTL_INFO(VIDIOC_G_INPUT, 0),
 	IOCTL_INFO(VIDIOC_S_INPUT, INFO_FL_PRIO),
-	IOCTL_INFO(VIDIOC_G_OUTPUT, 0),
+	IOCTL_INFO(VIDIOC_G_OUTPUT, INFO_FL_CLEAR(v4l2_output, index)),
 	IOCTL_INFO(VIDIOC_S_OUTPUT, INFO_FL_PRIO),
 	IOCTL_INFO(VIDIOC_ENUMOUTPUT, 0),
 	IOCTL_INFO(VIDIOC_G_AUDOUT, 0),
 	IOCTL_INFO(VIDIOC_S_AUDOUT, INFO_FL_PRIO),
-	IOCTL_INFO(VIDIOC_G_MODULATOR, 0),
+	IOCTL_INFO(VIDIOC_G_MODULATOR, INFO_FL_CLEAR(v4l2_modulator, index)),
 	IOCTL_INFO(VIDIOC_S_MODULATOR, INFO_FL_PRIO),
-	IOCTL_INFO(VIDIOC_G_FREQUENCY, 0),
+	IOCTL_INFO(VIDIOC_G_FREQUENCY, INFO_FL_CLEAR(v4l2_frequency, tuner)),
 	IOCTL_INFO(VIDIOC_S_FREQUENCY, INFO_FL_PRIO),
-	IOCTL_INFO(VIDIOC_CROPCAP, 0),
-	IOCTL_INFO(VIDIOC_G_CROP, 0),
+	IOCTL_INFO(VIDIOC_CROPCAP, INFO_FL_CLEAR(v4l2_cropcap, type)),
+	IOCTL_INFO(VIDIOC_G_CROP, INFO_FL_CLEAR(v4l2_crop, type)),
 	IOCTL_INFO(VIDIOC_S_CROP, INFO_FL_PRIO),
 	IOCTL_INFO(VIDIOC_G_SELECTION, 0),
 	IOCTL_INFO(VIDIOC_S_SELECTION, INFO_FL_PRIO),
@@ -457,20 +462,20 @@ static struct v4l2_ioctl_info v4l2_ioctls[] = {
 	IOCTL_INFO(VIDIOC_S_JPEGCOMP, INFO_FL_PRIO),
 	IOCTL_INFO(VIDIOC_QUERYSTD, 0),
 	IOCTL_INFO(VIDIOC_TRY_FMT, 0),
-	IOCTL_INFO(VIDIOC_ENUMAUDIO, 0),
-	IOCTL_INFO(VIDIOC_ENUMAUDOUT, 0),
+	IOCTL_INFO(VIDIOC_ENUMAUDIO, INFO_FL_CLEAR(v4l2_audio, index)),
+	IOCTL_INFO(VIDIOC_ENUMAUDOUT, INFO_FL_CLEAR(v4l2_audioout, index)),
 	IOCTL_INFO(VIDIOC_G_PRIORITY, 0),
 	IOCTL_INFO(VIDIOC_S_PRIORITY, INFO_FL_PRIO),
-	IOCTL_INFO(VIDIOC_G_SLICED_VBI_CAP, 0),
+	IOCTL_INFO(VIDIOC_G_SLICED_VBI_CAP, INFO_FL_CLEAR(v4l2_sliced_vbi_cap, type)),
 	IOCTL_INFO(VIDIOC_LOG_STATUS, 0),
 	IOCTL_INFO(VIDIOC_G_EXT_CTRLS, INFO_FL_CTRL),
 	IOCTL_INFO(VIDIOC_S_EXT_CTRLS, INFO_FL_PRIO | INFO_FL_CTRL),
 	IOCTL_INFO(VIDIOC_TRY_EXT_CTRLS, 0),
-	IOCTL_INFO(VIDIOC_ENUM_FRAMESIZES, 0),
-	IOCTL_INFO(VIDIOC_ENUM_FRAMEINTERVALS, 0),
+	IOCTL_INFO(VIDIOC_ENUM_FRAMESIZES, INFO_FL_CLEAR(v4l2_frmsizeenum, pixel_format)),
+	IOCTL_INFO(VIDIOC_ENUM_FRAMEINTERVALS, INFO_FL_CLEAR(v4l2_frmivalenum, height)),
 	IOCTL_INFO(VIDIOC_G_ENC_INDEX, 0),
-	IOCTL_INFO(VIDIOC_ENCODER_CMD, INFO_FL_PRIO),
-	IOCTL_INFO(VIDIOC_TRY_ENCODER_CMD, 0),
+	IOCTL_INFO(VIDIOC_ENCODER_CMD, INFO_FL_PRIO | INFO_FL_CLEAR(v4l2_encoder_cmd, flags)),
+	IOCTL_INFO(VIDIOC_TRY_ENCODER_CMD, INFO_FL_CLEAR(v4l2_encoder_cmd, flags)),
 	IOCTL_INFO(VIDIOC_DECODER_CMD, INFO_FL_PRIO),
 	IOCTL_INFO(VIDIOC_TRY_DECODER_CMD, 0),
 #ifdef CONFIG_VIDEO_ADV_DEBUG
@@ -2106,45 +2111,6 @@ static long __video_do_ioctl(struct file *file,
 	return ret;
 }
 
-/* In some cases, only a few fields are used as input, i.e. when the app sets
- * "index" and then the driver fills in the rest of the structure for the thing
- * with that index.  We only need to copy up the first non-input field.  */
-static unsigned long cmd_input_size(unsigned int cmd)
-{
-	/* Size of structure up to and including 'field' */
-#define CMDINSIZE(cmd, type, field) 				\
-	case VIDIOC_##cmd: 					\
-		return offsetof(struct v4l2_##type, field) + 	\
-			sizeof(((struct v4l2_##type *)0)->field);
-
-	switch (cmd) {
-		CMDINSIZE(ENUM_FMT,		fmtdesc,	type);
-		CMDINSIZE(G_FMT,		format,		type);
-		CMDINSIZE(QUERYBUF,		buffer,		length);
-		CMDINSIZE(G_PARM,		streamparm,	type);
-		CMDINSIZE(ENUMSTD,		standard,	index);
-		CMDINSIZE(ENUMINPUT,		input,		index);
-		CMDINSIZE(G_CTRL,		control,	id);
-		CMDINSIZE(G_TUNER,		tuner,		index);
-		CMDINSIZE(QUERYCTRL,		queryctrl,	id);
-		CMDINSIZE(QUERYMENU,		querymenu,	index);
-		CMDINSIZE(ENUMOUTPUT,		output,		index);
-		CMDINSIZE(G_MODULATOR,		modulator,	index);
-		CMDINSIZE(G_FREQUENCY,		frequency,	tuner);
-		CMDINSIZE(CROPCAP,		cropcap,	type);
-		CMDINSIZE(G_CROP,		crop,		type);
-		CMDINSIZE(ENUMAUDIO,		audio, 		index);
-		CMDINSIZE(ENUMAUDOUT,		audioout, 	index);
-		CMDINSIZE(ENCODER_CMD,		encoder_cmd,	flags);
-		CMDINSIZE(TRY_ENCODER_CMD,	encoder_cmd,	flags);
-		CMDINSIZE(G_SLICED_VBI_CAP,	sliced_vbi_cap,	type);
-		CMDINSIZE(ENUM_FRAMESIZES,	frmsizeenum,	pixel_format);
-		CMDINSIZE(ENUM_FRAMEINTERVALS,	frmivalenum,	height);
-	default:
-		return _IOC_SIZE(cmd);
-	}
-}
-
 static int check_array_args(unsigned int cmd, void *parg, size_t *array_size,
 			    void * __user *user_ptr, void ***kernel_ptr)
 {
@@ -2219,7 +2185,20 @@ video_usercopy(struct file *file, unsigned int cmd, unsigned long arg,
 
 		err = -EFAULT;
 		if (_IOC_DIR(cmd) & _IOC_WRITE) {
-			unsigned long n = cmd_input_size(cmd);
+			unsigned int n = _IOC_SIZE(cmd);
+
+			/*
+			 * In some cases, only a few fields are used as input,
+			 * i.e. when the app sets "index" and then the driver
+			 * fills in the rest of the structure for the thing
+			 * with that index.  We only need to copy up the first
+			 * non-input field.
+			 */
+			if (v4l2_is_known_ioctl(cmd)) {
+				u32 flags = v4l2_ioctls[_IOC_NR(cmd)].flags;
+				if (flags & INFO_FL_CLEAR_MASK)
+					n = (flags & INFO_FL_CLEAR_MASK) >> 16;
+			}
 
 			if (copy_from_user(parg, (void __user *)arg, n))
 				goto out;
-- 
1.7.10

