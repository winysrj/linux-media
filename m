Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:1691 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754023Ab2F1Gsq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jun 2012 02:48:46 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Pawel Osciak <pawel@osciak.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv3 PATCH 05/33] v4l2-ioctl.c: use the new table for querycap and i/o ioctls.
Date: Thu, 28 Jun 2012 08:47:59 +0200
Message-Id: <46dfb4c5e472c181b437743c49555308dac9765a.1340865818.git.hans.verkuil@cisco.com>
In-Reply-To: <1340866107-4188-1-git-send-email-hverkuil@xs4all.nl>
References: <1340866107-4188-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <d97434d2319fb8dbea360404f9343c680b5b196e.1340865818.git.hans.verkuil@cisco.com>
References: <d97434d2319fb8dbea360404f9343c680b5b196e.1340865818.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/v4l2-ioctl.c |  328 ++++++++++++++++----------------------
 1 file changed, 133 insertions(+), 195 deletions(-)

diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index be89dad..7556678 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -183,6 +183,63 @@ static const char *v4l2_memory_names[] = {
 /* ------------------------------------------------------------------ */
 /* debug help functions                                               */
 
+static void v4l_print_querycap(const void *arg, bool write_only)
+{
+	const struct v4l2_capability *p = arg;
+
+	pr_cont("driver=%s, card=%s, bus=%s, version=0x%08x, "
+		"capabilities=0x%08x, device_caps=0x%08x\n",
+		p->driver, p->card, p->bus_info,
+		p->version, p->capabilities, p->device_caps);
+}
+
+static void v4l_print_enuminput(const void *arg, bool write_only)
+{
+	const struct v4l2_input *p = arg;
+
+	pr_cont("index=%u, name=%s, type=%u, audioset=0x%x, tuner=%u, "
+		"std=0x%08Lx, status=0x%x, capabilities=0x%x\n",
+		p->index, p->name, p->type, p->audioset, p->tuner,
+		(unsigned long long)p->std, p->status, p->capabilities);
+}
+
+static void v4l_print_enumoutput(const void *arg, bool write_only)
+{
+	const struct v4l2_output *p = arg;
+
+	pr_cont("index=%u, name=%s, type=%u, audioset=0x%x, "
+		"modulator=%u, std=0x%08Lx, capabilities=0x%x\n",
+		p->index, p->name, p->type, p->audioset, p->modulator,
+		(unsigned long long)p->std, p->capabilities);
+}
+
+static void v4l_print_audio(const void *arg, bool write_only)
+{
+	const struct v4l2_audio *p = arg;
+
+	if (write_only)
+		pr_cont("index=%u, mode=0x%x\n", p->index, p->mode);
+	else
+		pr_cont("index=%u, name=%s, capability=0x%x, mode=0x%x\n",
+			p->index, p->name, p->capability, p->mode);
+}
+
+static void v4l_print_audioout(const void *arg, bool write_only)
+{
+	const struct v4l2_audioout *p = arg;
+
+	if (write_only)
+		pr_cont("index=%u\n", p->index);
+	else
+		pr_cont("index=%u, name=%s, capability=0x%x, mode=0x%x\n",
+			p->index, p->name, p->capability, p->mode);
+}
+
+static void v4l_print_u32(const void *arg, bool write_only)
+{
+	pr_cont("value=%u\n", *(const u32 *)arg);
+}
+
 static void dbgbuf(unsigned int cmd, struct video_device *vfd,
 					struct v4l2_buffer *p)
 {
@@ -392,6 +449,69 @@ static int check_fmt(const struct v4l2_ioctl_ops *ops, enum v4l2_buf_type type)
 	return -EINVAL;
 }
 
+static int v4l_querycap(const struct v4l2_ioctl_ops *ops,
+				struct file *file, void *fh, void *arg)
+{
+	struct v4l2_capability *cap = (struct v4l2_capability *)arg;
+
+	cap->version = LINUX_VERSION_CODE;
+	return ops->vidioc_querycap(file, fh, cap);
+}
+
+static int v4l_s_input(const struct v4l2_ioctl_ops *ops,
+				struct file *file, void *fh, void *arg)
+{
+	return ops->vidioc_s_input(file, fh, *(unsigned int *)arg);
+}
+
+static int v4l_s_output(const struct v4l2_ioctl_ops *ops,
+				struct file *file, void *fh, void *arg)
+{
+	return ops->vidioc_s_output(file, fh, *(unsigned int *)arg);
+}
+
+static int v4l_enuminput(const struct v4l2_ioctl_ops *ops,
+				struct file *file, void *fh, void *arg)
+{
+	struct v4l2_input *p = arg;
+
+	/*
+	 * We set the flags for CAP_PRESETS, CAP_CUSTOM_TIMINGS &
+	 * CAP_STD here based on ioctl handler provided by the
+	 * driver. If the driver doesn't support these
+	 * for a specific input, it must override these flags.
+	 */
+	if (ops->vidioc_s_std)
+		p->capabilities |= V4L2_IN_CAP_STD;
+	if (ops->vidioc_s_dv_preset)
+		p->capabilities |= V4L2_IN_CAP_PRESETS;
+	if (ops->vidioc_s_dv_timings)
+		p->capabilities |= V4L2_IN_CAP_CUSTOM_TIMINGS;
+
+	return ops->vidioc_enum_input(file, fh, p);
+}
+
+static int v4l_enumoutput(const struct v4l2_ioctl_ops *ops,
+				struct file *file, void *fh, void *arg)
+{
+	struct v4l2_output *p = arg;
+
+	/*
+	 * We set the flags for CAP_PRESETS, CAP_CUSTOM_TIMINGS &
+	 * CAP_STD here based on ioctl handler provided by the
+	 * driver. If the driver doesn't support these
+	 * for a specific output, it must override these flags.
+	 */
+	if (ops->vidioc_s_std)
+		p->capabilities |= V4L2_OUT_CAP_STD;
+	if (ops->vidioc_s_dv_preset)
+		p->capabilities |= V4L2_OUT_CAP_PRESETS;
+	if (ops->vidioc_s_dv_timings)
+		p->capabilities |= V4L2_OUT_CAP_CUSTOM_TIMINGS;
+
+	return ops->vidioc_enum_output(file, fh, p);
+}
+
 struct v4l2_ioctl_info {
 	unsigned int ioctl;
 	u32 flags;
@@ -443,7 +563,7 @@ struct v4l2_ioctl_info {
 	}
 
 static struct v4l2_ioctl_info v4l2_ioctls[] = {
-	IOCTL_INFO(VIDIOC_QUERYCAP, 0),
+	IOCTL_INFO_FNC(VIDIOC_QUERYCAP, v4l_querycap, v4l_print_querycap, 0),
 	IOCTL_INFO(VIDIOC_ENUM_FMT, INFO_FL_CLEAR(v4l2_fmtdesc, type)),
 	IOCTL_INFO(VIDIOC_G_FMT, INFO_FL_CLEAR(v4l2_format, type)),
 	IOCTL_INFO(VIDIOC_S_FMT, INFO_FL_PRIO),
@@ -461,22 +581,22 @@ static struct v4l2_ioctl_info v4l2_ioctls[] = {
 	IOCTL_INFO(VIDIOC_G_STD, 0),
 	IOCTL_INFO(VIDIOC_S_STD, INFO_FL_PRIO),
 	IOCTL_INFO(VIDIOC_ENUMSTD, INFO_FL_CLEAR(v4l2_standard, index)),
-	IOCTL_INFO(VIDIOC_ENUMINPUT, INFO_FL_CLEAR(v4l2_input, index)),
+	IOCTL_INFO_FNC(VIDIOC_ENUMINPUT, v4l_enuminput, v4l_print_enuminput, INFO_FL_CLEAR(v4l2_input, index)),
 	IOCTL_INFO(VIDIOC_G_CTRL, INFO_FL_CTRL),
 	IOCTL_INFO(VIDIOC_S_CTRL, INFO_FL_PRIO | INFO_FL_CTRL),
 	IOCTL_INFO(VIDIOC_G_TUNER, INFO_FL_CLEAR(v4l2_tuner, index)),
 	IOCTL_INFO(VIDIOC_S_TUNER, INFO_FL_PRIO),
-	IOCTL_INFO(VIDIOC_G_AUDIO, 0),
-	IOCTL_INFO(VIDIOC_S_AUDIO, INFO_FL_PRIO),
+	IOCTL_INFO_STD(VIDIOC_G_AUDIO, vidioc_g_audio, v4l_print_audio, 0),
+	IOCTL_INFO_STD(VIDIOC_S_AUDIO, vidioc_s_audio, v4l_print_audio, INFO_FL_PRIO),
 	IOCTL_INFO(VIDIOC_QUERYCTRL, INFO_FL_CTRL | INFO_FL_CLEAR(v4l2_queryctrl, id)),
 	IOCTL_INFO(VIDIOC_QUERYMENU, INFO_FL_CTRL | INFO_FL_CLEAR(v4l2_querymenu, index)),
-	IOCTL_INFO(VIDIOC_G_INPUT, 0),
-	IOCTL_INFO(VIDIOC_S_INPUT, INFO_FL_PRIO),
-	IOCTL_INFO(VIDIOC_G_OUTPUT, INFO_FL_CLEAR(v4l2_output, index)),
-	IOCTL_INFO(VIDIOC_S_OUTPUT, INFO_FL_PRIO),
-	IOCTL_INFO(VIDIOC_ENUMOUTPUT, 0),
-	IOCTL_INFO(VIDIOC_G_AUDOUT, 0),
-	IOCTL_INFO(VIDIOC_S_AUDOUT, INFO_FL_PRIO),
+	IOCTL_INFO_STD(VIDIOC_G_INPUT, vidioc_g_input, v4l_print_u32, 0),
+	IOCTL_INFO_FNC(VIDIOC_S_INPUT, v4l_s_input, v4l_print_u32, INFO_FL_PRIO),
+	IOCTL_INFO_STD(VIDIOC_G_OUTPUT, vidioc_g_output, v4l_print_u32, 0),
+	IOCTL_INFO_FNC(VIDIOC_S_OUTPUT, v4l_s_output, v4l_print_u32, INFO_FL_PRIO),
+	IOCTL_INFO_FNC(VIDIOC_ENUMOUTPUT, v4l_enumoutput, v4l_print_enumoutput, INFO_FL_CLEAR(v4l2_output, index)),
+	IOCTL_INFO_STD(VIDIOC_G_AUDOUT, vidioc_g_audout, v4l_print_audioout, 0),
+	IOCTL_INFO_STD(VIDIOC_S_AUDOUT, vidioc_s_audout, v4l_print_audioout, INFO_FL_PRIO),
 	IOCTL_INFO(VIDIOC_G_MODULATOR, INFO_FL_CLEAR(v4l2_modulator, index)),
 	IOCTL_INFO(VIDIOC_S_MODULATOR, INFO_FL_PRIO),
 	IOCTL_INFO(VIDIOC_G_FREQUENCY, INFO_FL_CLEAR(v4l2_frequency, tuner)),
@@ -490,8 +610,8 @@ static struct v4l2_ioctl_info v4l2_ioctls[] = {
 	IOCTL_INFO(VIDIOC_S_JPEGCOMP, INFO_FL_PRIO),
 	IOCTL_INFO(VIDIOC_QUERYSTD, 0),
 	IOCTL_INFO(VIDIOC_TRY_FMT, 0),
-	IOCTL_INFO(VIDIOC_ENUMAUDIO, INFO_FL_CLEAR(v4l2_audio, index)),
-	IOCTL_INFO(VIDIOC_ENUMAUDOUT, INFO_FL_CLEAR(v4l2_audioout, index)),
+	IOCTL_INFO_STD(VIDIOC_ENUMAUDIO, vidioc_enumaudio, v4l_print_audio, INFO_FL_CLEAR(v4l2_audio, index)),
+	IOCTL_INFO_STD(VIDIOC_ENUMAUDOUT, vidioc_enumaudout, v4l_print_audioout, INFO_FL_CLEAR(v4l2_audioout, index)),
 	IOCTL_INFO(VIDIOC_G_PRIORITY, 0),
 	IOCTL_INFO(VIDIOC_S_PRIORITY, INFO_FL_PRIO),
 	IOCTL_INFO(VIDIOC_G_SLICED_VBI_CAP, INFO_FL_CLEAR(v4l2_sliced_vbi_cap, type)),
@@ -631,25 +751,6 @@ static long __video_do_ioctl(struct file *file,
 
 	switch (cmd) {
 
-	/* --- capabilities ------------------------------------------ */
-	case VIDIOC_QUERYCAP:
-	{
-		struct v4l2_capability *cap = (struct v4l2_capability *)arg;
-
-		cap->version = LINUX_VERSION_CODE;
-		ret = ops->vidioc_querycap(file, fh, cap);
-		if (!ret)
-			dbgarg(cmd, "driver=%s, card=%s, bus=%s, "
-					"version=0x%08x, "
-					"capabilities=0x%08x, "
-					"device_caps=0x%08x\n",
-					cap->driver, cap->card, cap->bus_info,
-					cap->version,
-					cap->capabilities,
-					cap->device_caps);
-		break;
-	}
-
 	/* --- priority ------------------------------------------ */
 	case VIDIOC_G_PRIORITY:
 	{
@@ -1164,98 +1265,6 @@ static long __video_do_ioctl(struct file *file,
 						(unsigned long long)*p);
 		break;
 	}
-	/* ------ input switching ---------- */
-	/* FIXME: Inputs can be handled inside videodev2 */
-	case VIDIOC_ENUMINPUT:
-	{
-		struct v4l2_input *p = arg;
-
-		/*
-		 * We set the flags for CAP_PRESETS, CAP_CUSTOM_TIMINGS &
-		 * CAP_STD here based on ioctl handler provided by the
-		 * driver. If the driver doesn't support these
-		 * for a specific input, it must override these flags.
-		 */
-		if (ops->vidioc_s_std)
-			p->capabilities |= V4L2_IN_CAP_STD;
-		if (ops->vidioc_s_dv_preset)
-			p->capabilities |= V4L2_IN_CAP_PRESETS;
-		if (ops->vidioc_s_dv_timings)
-			p->capabilities |= V4L2_IN_CAP_CUSTOM_TIMINGS;
-
-		ret = ops->vidioc_enum_input(file, fh, p);
-		if (!ret)
-			dbgarg(cmd, "index=%d, name=%s, type=%d, "
-				"audioset=%d, "
-				"tuner=%d, std=%08Lx, status=%d\n",
-				p->index, p->name, p->type, p->audioset,
-				p->tuner,
-				(unsigned long long)p->std,
-				p->status);
-		break;
-	}
-	case VIDIOC_G_INPUT:
-	{
-		unsigned int *i = arg;
-
-		ret = ops->vidioc_g_input(file, fh, i);
-		if (!ret)
-			dbgarg(cmd, "value=%d\n", *i);
-		break;
-	}
-	case VIDIOC_S_INPUT:
-	{
-		unsigned int *i = arg;
-
-		dbgarg(cmd, "value=%d\n", *i);
-		ret = ops->vidioc_s_input(file, fh, *i);
-		break;
-	}
-
-	/* ------ output switching ---------- */
-	case VIDIOC_ENUMOUTPUT:
-	{
-		struct v4l2_output *p = arg;
-
-		/*
-		 * We set the flags for CAP_PRESETS, CAP_CUSTOM_TIMINGS &
-		 * CAP_STD here based on ioctl handler provided by the
-		 * driver. If the driver doesn't support these
-		 * for a specific output, it must override these flags.
-		 */
-		if (ops->vidioc_s_std)
-			p->capabilities |= V4L2_OUT_CAP_STD;
-		if (ops->vidioc_s_dv_preset)
-			p->capabilities |= V4L2_OUT_CAP_PRESETS;
-		if (ops->vidioc_s_dv_timings)
-			p->capabilities |= V4L2_OUT_CAP_CUSTOM_TIMINGS;
-
-		ret = ops->vidioc_enum_output(file, fh, p);
-		if (!ret)
-			dbgarg(cmd, "index=%d, name=%s, type=%d, "
-				"audioset=0x%x, "
-				"modulator=%d, std=0x%08Lx\n",
-				p->index, p->name, p->type, p->audioset,
-				p->modulator, (unsigned long long)p->std);
-		break;
-	}
-	case VIDIOC_G_OUTPUT:
-	{
-		unsigned int *i = arg;
-
-		ret = ops->vidioc_g_output(file, fh, i);
-		if (!ret)
-			dbgarg(cmd, "value=%d\n", *i);
-		break;
-	}
-	case VIDIOC_S_OUTPUT:
-	{
-		unsigned int *i = arg;
-
-		dbgarg(cmd, "value=%d\n", *i);
-		ret = ops->vidioc_s_output(file, fh, *i);
-		break;
-	}
 
 	/* --- controls ---------------------------------------------- */
 	case VIDIOC_QUERYCTRL:
@@ -1426,77 +1435,6 @@ static long __video_do_ioctl(struct file *file,
 				p->id, p->index);
 		break;
 	}
-	/* --- audio ---------------------------------------------- */
-	case VIDIOC_ENUMAUDIO:
-	{
-		struct v4l2_audio *p = arg;
-
-		ret = ops->vidioc_enumaudio(file, fh, p);
-		if (!ret)
-			dbgarg(cmd, "index=%d, name=%s, capability=0x%x, "
-					"mode=0x%x\n", p->index, p->name,
-					p->capability, p->mode);
-		else
-			dbgarg(cmd, "index=%d\n", p->index);
-		break;
-	}
-	case VIDIOC_G_AUDIO:
-	{
-		struct v4l2_audio *p = arg;
-
-		ret = ops->vidioc_g_audio(file, fh, p);
-		if (!ret)
-			dbgarg(cmd, "index=%d, name=%s, capability=0x%x, "
-					"mode=0x%x\n", p->index,
-					p->name, p->capability, p->mode);
-		else
-			dbgarg(cmd, "index=%d\n", p->index);
-		break;
-	}
-	case VIDIOC_S_AUDIO:
-	{
-		struct v4l2_audio *p = arg;
-
-		dbgarg(cmd, "index=%d, name=%s, capability=0x%x, "
-					"mode=0x%x\n", p->index, p->name,
-					p->capability, p->mode);
-		ret = ops->vidioc_s_audio(file, fh, p);
-		break;
-	}
-	case VIDIOC_ENUMAUDOUT:
-	{
-		struct v4l2_audioout *p = arg;
-
-		dbgarg(cmd, "Enum for index=%d\n", p->index);
-		ret = ops->vidioc_enumaudout(file, fh, p);
-		if (!ret)
-			dbgarg2("index=%d, name=%s, capability=%d, "
-					"mode=%d\n", p->index, p->name,
-					p->capability, p->mode);
-		break;
-	}
-	case VIDIOC_G_AUDOUT:
-	{
-		struct v4l2_audioout *p = arg;
-
-		ret = ops->vidioc_g_audout(file, fh, p);
-		if (!ret)
-			dbgarg2("index=%d, name=%s, capability=%d, "
-					"mode=%d\n", p->index, p->name,
-					p->capability, p->mode);
-		break;
-	}
-	case VIDIOC_S_AUDOUT:
-	{
-		struct v4l2_audioout *p = arg;
-
-		dbgarg(cmd, "index=%d, name=%s, capability=%d, "
-					"mode=%d\n", p->index, p->name,
-					p->capability, p->mode);
-
-		ret = ops->vidioc_s_audout(file, fh, p);
-		break;
-	}
 	case VIDIOC_G_MODULATOR:
 	{
 		struct v4l2_modulator *p = arg;
-- 
1.7.10

