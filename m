Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:4027 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761934Ab2FVMaS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jun 2012 08:30:18 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Pawel Osciak <pawel@osciak.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 10/34] v4l2-ioctl.c: use the new table for std/tuner/modulator ioctls.
Date: Fri, 22 Jun 2012 14:21:04 +0200
Message-Id: <9ae40a6d1cb4a2c844702f4c6e9fc64ba423aa94.1340366355.git.hans.verkuil@cisco.com>
In-Reply-To: <1340367688-8722-1-git-send-email-hverkuil@xs4all.nl>
References: <1340367688-8722-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1cee710ae251aa69bed8e563a94b419ed99bc41a.1340366355.git.hans.verkuil@cisco.com>
References: <1cee710ae251aa69bed8e563a94b419ed99bc41a.1340366355.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/v4l2-ioctl.c |  430 +++++++++++++++++++-------------------
 1 file changed, 220 insertions(+), 210 deletions(-)

diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index ab4a743..2a5ed40 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -364,6 +364,68 @@ static void v4l_print_buftype(const void *arg, bool write_only)
 	pr_cont("type=%s\n", prt_names(*(u32 *)arg, v4l2_type_names));
 }
 
+static void v4l_print_modulator(const void *arg, bool write_only)
+{
+	const struct v4l2_modulator *p = arg;
+
+	if (write_only)
+		pr_cont("index=%u, txsubchans=0x%x", p->index, p->txsubchans);
+	else
+		pr_cont("index=%u, name=%s, capability=0x%x, "
+			"rangelow=%u, rangehigh=%u, txsubchans=0x%x\n",
+			p->index, p->name, p->capability,
+			p->rangelow, p->rangehigh, p->txsubchans);
+}
+
+static void v4l_print_tuner(const void *arg, bool write_only)
+{
+	const struct v4l2_tuner *p = arg;
+
+	if (write_only)
+		pr_cont("index=%u, audmode=%u\n", p->index, p->audmode);
+	else
+		pr_cont("index=%u, name=%s, type=%u, capability=0x%x, "
+			"rangelow=%u, rangehigh=%u, signal=%u, afc=%d, "
+			"rxsubchans=0x%x, audmode=%u\n",
+			p->index, p->name, p->type,
+			p->capability, p->rangelow,
+			p->rangehigh, p->signal, p->afc,
+			p->rxsubchans, p->audmode);
+}
+
+static void v4l_print_frequency(const void *arg, bool write_only)
+{
+	const struct v4l2_frequency *p = arg;
+
+	pr_cont("tuner=%u, type=%u, frequency=%u\n",
+				p->tuner, p->type, p->frequency);
+}
+
+static void v4l_print_standard(const void *arg, bool write_only)
+{
+	const struct v4l2_standard *p = arg;
+
+	pr_cont("index=%u, id=0x%Lx, name=%s, fps=%u/%u, "
+		"framelines=%u\n", p->index,
+		(unsigned long long)p->id, p->name,
+		p->frameperiod.numerator,
+		p->frameperiod.denominator,
+		p->framelines);
+}
+
+static void v4l_print_std(const void *arg, bool write_only)
+{
+	pr_cont("std=0x%08Lx\n", *(const long long unsigned *)arg);
+}
+
+static void v4l_print_hw_freq_seek(const void *arg, bool write_only)
+{
+	const struct v4l2_hw_freq_seek *p = arg;
+
+	pr_cont("tuner=%u, type=%u, seek_upward=%u, wrap_around=%u, spacing=%u\n",
+		p->tuner, p->type, p->seek_upward, p->wrap_around, p->spacing);
+}
+
 static void v4l_print_u32(const void *arg, bool write_only)
 {
 	pr_cont("value=%u\n", *(const u32 *)arg);
@@ -861,6 +923,153 @@ static int v4l_streamoff(const struct v4l2_ioctl_ops *ops,
 	return ops->vidioc_streamoff(file, fh, *(unsigned int *)arg);
 }
 
+static int v4l_g_tuner(const struct v4l2_ioctl_ops *ops,
+				struct file *file, void *fh, void *arg)
+{
+	struct video_device *vfd = video_devdata(file);
+	struct v4l2_tuner *p = arg;
+
+	p->type = (vfd->vfl_type == VFL_TYPE_RADIO) ?
+			V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
+	return ops->vidioc_g_tuner(file, fh, p);
+}
+
+static int v4l_s_tuner(const struct v4l2_ioctl_ops *ops,
+				struct file *file, void *fh, void *arg)
+{
+	struct video_device *vfd = video_devdata(file);
+	struct v4l2_tuner *p = arg;
+
+	p->type = (vfd->vfl_type == VFL_TYPE_RADIO) ?
+			V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
+	return ops->vidioc_s_tuner(file, fh, p);
+}
+
+static int v4l_g_frequency(const struct v4l2_ioctl_ops *ops,
+				struct file *file, void *fh, void *arg)
+{
+	struct video_device *vfd = video_devdata(file);
+	struct v4l2_frequency *p = arg;
+
+	p->type = (vfd->vfl_type == VFL_TYPE_RADIO) ?
+			V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
+	return ops->vidioc_g_frequency(file, fh, p);
+}
+
+static int v4l_s_frequency(const struct v4l2_ioctl_ops *ops,
+				struct file *file, void *fh, void *arg)
+{
+	struct video_device *vfd = video_devdata(file);
+	struct v4l2_frequency *p = arg;
+	enum v4l2_tuner_type type;
+
+	type = (vfd->vfl_type == VFL_TYPE_RADIO) ?
+			V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
+	if (p->type != type)
+		return -EINVAL;
+	return ops->vidioc_s_frequency(file, fh, p);
+}
+
+static int v4l_enumstd(const struct v4l2_ioctl_ops *ops,
+				struct file *file, void *fh, void *arg)
+{
+	struct video_device *vfd = video_devdata(file);
+	struct v4l2_standard *p = arg;
+	v4l2_std_id id = vfd->tvnorms, curr_id = 0;
+	unsigned int index = p->index, i, j = 0;
+	const char *descr = "";
+
+	/* Return norm array in a canonical way */
+	for (i = 0; i <= index && id; i++) {
+		/* last std value in the standards array is 0, so this
+		   while always ends there since (id & 0) == 0. */
+		while ((id & standards[j].std) != standards[j].std)
+			j++;
+		curr_id = standards[j].std;
+		descr = standards[j].descr;
+		j++;
+		if (curr_id == 0)
+			break;
+		if (curr_id != V4L2_STD_PAL &&
+				curr_id != V4L2_STD_SECAM &&
+				curr_id != V4L2_STD_NTSC)
+			id &= ~curr_id;
+	}
+	if (i <= index)
+		return -EINVAL;
+
+	v4l2_video_std_construct(p, curr_id, descr);
+	return 0;
+}
+
+static int v4l_g_std(const struct v4l2_ioctl_ops *ops,
+				struct file *file, void *fh, void *arg)
+{
+	struct video_device *vfd = video_devdata(file);
+	v4l2_std_id *id = arg;
+
+	/* Calls the specific handler */
+	if (ops->vidioc_g_std)
+		return ops->vidioc_g_std(file, fh, arg);
+	if (vfd->current_norm) {
+		*id = vfd->current_norm;
+		return 0;
+	}
+	return -ENOTTY;
+}
+
+static int v4l_s_std(const struct v4l2_ioctl_ops *ops,
+				struct file *file, void *fh, void *arg)
+{
+	struct video_device *vfd = video_devdata(file);
+	v4l2_std_id *id = arg, norm;
+	int ret;
+
+	norm = (*id) & vfd->tvnorms;
+	if (vfd->tvnorms && !norm)	/* Check if std is supported */
+		return -EINVAL;
+
+	/* Calls the specific handler */
+	ret = ops->vidioc_s_std(file, fh, &norm);
+
+	/* Updates standard information */
+	if (ret >= 0)
+		vfd->current_norm = norm;
+	return ret;
+}
+
+static int v4l_querystd(const struct v4l2_ioctl_ops *ops,
+				struct file *file, void *fh, void *arg)
+{
+	struct video_device *vfd = video_devdata(file);
+	v4l2_std_id *p = arg;
+
+	/*
+	 * If nothing detected, it should return all supported
+	 * standard.
+	 * Drivers just need to mask the std argument, in order
+	 * to remove the standards that don't apply from the mask.
+	 * This means that tuners, audio and video decoders can join
+	 * their efforts to improve the standards detection.
+	 */
+	*p = vfd->tvnorms;
+	return ops->vidioc_querystd(file, fh, arg);
+}
+
+static int v4l_s_hw_freq_seek(const struct v4l2_ioctl_ops *ops,
+				struct file *file, void *fh, void *arg)
+{
+	struct video_device *vfd = video_devdata(file);
+	struct v4l2_hw_freq_seek *p = arg;
+	enum v4l2_tuner_type type;
+
+	type = (vfd->vfl_type == VFL_TYPE_RADIO) ?
+		V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
+	if (p->type != type)
+		return -EINVAL;
+	return ops->vidioc_s_hw_freq_seek(file, fh, p);
+}
+
 struct v4l2_ioctl_info {
 	unsigned int ioctl;
 	u32 flags;
@@ -927,14 +1136,14 @@ static struct v4l2_ioctl_info v4l2_ioctls[] = {
 	IOCTL_INFO_FNC(VIDIOC_STREAMOFF, v4l_streamoff, v4l_print_buftype, INFO_FL_PRIO),
 	IOCTL_INFO(VIDIOC_G_PARM, INFO_FL_CLEAR(v4l2_streamparm, type)),
 	IOCTL_INFO(VIDIOC_S_PARM, INFO_FL_PRIO),
-	IOCTL_INFO(VIDIOC_G_STD, 0),
-	IOCTL_INFO(VIDIOC_S_STD, INFO_FL_PRIO),
-	IOCTL_INFO(VIDIOC_ENUMSTD, INFO_FL_CLEAR(v4l2_standard, index)),
+	IOCTL_INFO_FNC(VIDIOC_G_STD, v4l_g_std, v4l_print_std, 0),
+	IOCTL_INFO_FNC(VIDIOC_S_STD, v4l_s_std, v4l_print_std, INFO_FL_PRIO),
+	IOCTL_INFO_FNC(VIDIOC_ENUMSTD, v4l_enumstd, v4l_print_standard, INFO_FL_CLEAR(v4l2_standard, index)),
 	IOCTL_INFO_FNC(VIDIOC_ENUMINPUT, v4l_enuminput, v4l_print_enuminput, INFO_FL_CLEAR(v4l2_input, index)),
 	IOCTL_INFO(VIDIOC_G_CTRL, INFO_FL_CTRL),
 	IOCTL_INFO(VIDIOC_S_CTRL, INFO_FL_PRIO | INFO_FL_CTRL),
-	IOCTL_INFO(VIDIOC_G_TUNER, INFO_FL_CLEAR(v4l2_tuner, index)),
-	IOCTL_INFO(VIDIOC_S_TUNER, INFO_FL_PRIO),
+	IOCTL_INFO_FNC(VIDIOC_G_TUNER, v4l_g_tuner, v4l_print_tuner, INFO_FL_CLEAR(v4l2_tuner, index)),
+	IOCTL_INFO_FNC(VIDIOC_S_TUNER, v4l_s_tuner, v4l_print_tuner, INFO_FL_PRIO),
 	IOCTL_INFO_STD(VIDIOC_G_AUDIO, vidioc_g_audio, v4l_print_audio, 0),
 	IOCTL_INFO_STD(VIDIOC_S_AUDIO, vidioc_s_audio, v4l_print_audio, INFO_FL_PRIO),
 	IOCTL_INFO(VIDIOC_QUERYCTRL, INFO_FL_CTRL | INFO_FL_CLEAR(v4l2_queryctrl, id)),
@@ -946,10 +1155,10 @@ static struct v4l2_ioctl_info v4l2_ioctls[] = {
 	IOCTL_INFO_FNC(VIDIOC_ENUMOUTPUT, v4l_enumoutput, v4l_print_enumoutput, INFO_FL_CLEAR(v4l2_output, index)),
 	IOCTL_INFO_STD(VIDIOC_G_AUDOUT, vidioc_g_audout, v4l_print_audioout, 0),
 	IOCTL_INFO_STD(VIDIOC_S_AUDOUT, vidioc_s_audout, v4l_print_audioout, INFO_FL_PRIO),
-	IOCTL_INFO(VIDIOC_G_MODULATOR, INFO_FL_CLEAR(v4l2_modulator, index)),
-	IOCTL_INFO(VIDIOC_S_MODULATOR, INFO_FL_PRIO),
-	IOCTL_INFO(VIDIOC_G_FREQUENCY, INFO_FL_CLEAR(v4l2_frequency, tuner)),
-	IOCTL_INFO(VIDIOC_S_FREQUENCY, INFO_FL_PRIO),
+	IOCTL_INFO_STD(VIDIOC_G_MODULATOR, vidioc_g_modulator, v4l_print_modulator, INFO_FL_CLEAR(v4l2_modulator, index)),
+	IOCTL_INFO_STD(VIDIOC_S_MODULATOR, vidioc_s_modulator, v4l_print_modulator, INFO_FL_PRIO),
+	IOCTL_INFO_FNC(VIDIOC_G_FREQUENCY, v4l_g_frequency, v4l_print_frequency, INFO_FL_CLEAR(v4l2_frequency, tuner)),
+	IOCTL_INFO_FNC(VIDIOC_S_FREQUENCY, v4l_s_frequency, v4l_print_frequency, INFO_FL_PRIO),
 	IOCTL_INFO(VIDIOC_CROPCAP, INFO_FL_CLEAR(v4l2_cropcap, type)),
 	IOCTL_INFO(VIDIOC_G_CROP, INFO_FL_CLEAR(v4l2_crop, type)),
 	IOCTL_INFO(VIDIOC_S_CROP, INFO_FL_PRIO),
@@ -957,7 +1166,7 @@ static struct v4l2_ioctl_info v4l2_ioctls[] = {
 	IOCTL_INFO(VIDIOC_S_SELECTION, INFO_FL_PRIO),
 	IOCTL_INFO(VIDIOC_G_JPEGCOMP, 0),
 	IOCTL_INFO(VIDIOC_S_JPEGCOMP, INFO_FL_PRIO),
-	IOCTL_INFO(VIDIOC_QUERYSTD, 0),
+	IOCTL_INFO_FNC(VIDIOC_QUERYSTD, v4l_querystd, v4l_print_std, 0),
 	IOCTL_INFO_FNC(VIDIOC_TRY_FMT, v4l_try_fmt, v4l_print_format, 0),
 	IOCTL_INFO_STD(VIDIOC_ENUMAUDIO, vidioc_enumaudio, v4l_print_audio, INFO_FL_CLEAR(v4l2_audio, index)),
 	IOCTL_INFO_STD(VIDIOC_ENUMAUDOUT, vidioc_enumaudout, v4l_print_audioout, INFO_FL_CLEAR(v4l2_audioout, index)),
@@ -978,7 +1187,7 @@ static struct v4l2_ioctl_info v4l2_ioctls[] = {
 	IOCTL_INFO(VIDIOC_DBG_S_REGISTER, 0),
 	IOCTL_INFO(VIDIOC_DBG_G_REGISTER, 0),
 	IOCTL_INFO(VIDIOC_DBG_G_CHIP_IDENT, 0),
-	IOCTL_INFO(VIDIOC_S_HW_FREQ_SEEK, INFO_FL_PRIO),
+	IOCTL_INFO_FNC(VIDIOC_S_HW_FREQ_SEEK, v4l_s_hw_freq_seek, v4l_print_hw_freq_seek, INFO_FL_PRIO),
 	IOCTL_INFO(VIDIOC_ENUM_DV_PRESETS, 0),
 	IOCTL_INFO(VIDIOC_S_DV_PRESET, INFO_FL_PRIO),
 	IOCTL_INFO(VIDIOC_G_DV_PRESET, 0),
@@ -1160,102 +1369,6 @@ static long __video_do_ioctl(struct file *file,
 			dbgbuf(cmd, vfd, p);
 		break;
 	}
-	/* ---------- tv norms ---------- */
-	case VIDIOC_ENUMSTD:
-	{
-		struct v4l2_standard *p = arg;
-		v4l2_std_id id = vfd->tvnorms, curr_id = 0;
-		unsigned int index = p->index, i, j = 0;
-		const char *descr = "";
-
-		if (id == 0)
-			break;
-		ret = -EINVAL;
-
-		/* Return norm array in a canonical way */
-		for (i = 0; i <= index && id; i++) {
-			/* last std value in the standards array is 0, so this
-			   while always ends there since (id & 0) == 0. */
-			while ((id & standards[j].std) != standards[j].std)
-				j++;
-			curr_id = standards[j].std;
-			descr = standards[j].descr;
-			j++;
-			if (curr_id == 0)
-				break;
-			if (curr_id != V4L2_STD_PAL &&
-			    curr_id != V4L2_STD_SECAM &&
-			    curr_id != V4L2_STD_NTSC)
-				id &= ~curr_id;
-		}
-		if (i <= index)
-			break;
-
-		v4l2_video_std_construct(p, curr_id, descr);
-
-		dbgarg(cmd, "index=%d, id=0x%Lx, name=%s, fps=%d/%d, "
-				"framelines=%d\n", p->index,
-				(unsigned long long)p->id, p->name,
-				p->frameperiod.numerator,
-				p->frameperiod.denominator,
-				p->framelines);
-
-		ret = 0;
-		break;
-	}
-	case VIDIOC_G_STD:
-	{
-		v4l2_std_id *id = arg;
-
-		/* Calls the specific handler */
-		if (ops->vidioc_g_std)
-			ret = ops->vidioc_g_std(file, fh, id);
-		else if (vfd->current_norm) {
-			ret = 0;
-			*id = vfd->current_norm;
-		}
-
-		if (likely(!ret))
-			dbgarg(cmd, "std=0x%08Lx\n", (long long unsigned)*id);
-		break;
-	}
-	case VIDIOC_S_STD:
-	{
-		v4l2_std_id *id = arg, norm;
-
-		dbgarg(cmd, "std=%08Lx\n", (long long unsigned)*id);
-
-		ret = -EINVAL;
-		norm = (*id) & vfd->tvnorms;
-		if (vfd->tvnorms && !norm)	/* Check if std is supported */
-			break;
-
-		/* Calls the specific handler */
-		ret = ops->vidioc_s_std(file, fh, &norm);
-
-		/* Updates standard information */
-		if (ret >= 0)
-			vfd->current_norm = norm;
-		break;
-	}
-	case VIDIOC_QUERYSTD:
-	{
-		v4l2_std_id *p = arg;
-
-		/*
-		 * If nothing detected, it should return all supported
-		 * Drivers just need to mask the std argument, in order
-		 * to remove the standards that don't apply from the mask.
-		 * This means that tuners, audio and video decoders can join
-		 * their efforts to improve the standards detection
-		 */
-		*p = vfd->tvnorms;
-		ret = ops->vidioc_querystd(file, fh, arg);
-		if (!ret)
-			dbgarg(cmd, "detected std=%08Lx\n",
-						(unsigned long long)*p);
-		break;
-	}
 
 	/* --- controls ---------------------------------------------- */
 	case VIDIOC_QUERYCTRL:
@@ -1426,31 +1539,6 @@ static long __video_do_ioctl(struct file *file,
 				p->id, p->index);
 		break;
 	}
-	case VIDIOC_G_MODULATOR:
-	{
-		struct v4l2_modulator *p = arg;
-
-		ret = ops->vidioc_g_modulator(file, fh, p);
-		if (!ret)
-			dbgarg(cmd, "index=%d, name=%s, "
-					"capability=%d, rangelow=%d,"
-					" rangehigh=%d, txsubchans=%d\n",
-					p->index, p->name, p->capability,
-					p->rangelow, p->rangehigh,
-					p->txsubchans);
-		break;
-	}
-	case VIDIOC_S_MODULATOR:
-	{
-		struct v4l2_modulator *p = arg;
-
-		dbgarg(cmd, "index=%d, name=%s, capability=%d, "
-				"rangelow=%d, rangehigh=%d, txsubchans=%d\n",
-				p->index, p->name, p->capability, p->rangelow,
-				p->rangehigh, p->txsubchans);
-			ret = ops->vidioc_s_modulator(file, fh, p);
-		break;
-	}
 	case VIDIOC_G_CROP:
 	{
 		struct v4l2_crop *p = arg;
@@ -1683,68 +1771,6 @@ static long __video_do_ioctl(struct file *file,
 		ret = ops->vidioc_s_parm(file, fh, p);
 		break;
 	}
-	case VIDIOC_G_TUNER:
-	{
-		struct v4l2_tuner *p = arg;
-
-		p->type = (vfd->vfl_type == VFL_TYPE_RADIO) ?
-			V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
-		ret = ops->vidioc_g_tuner(file, fh, p);
-		if (!ret)
-			dbgarg(cmd, "index=%d, name=%s, type=%d, "
-					"capability=0x%x, rangelow=%d, "
-					"rangehigh=%d, signal=%d, afc=%d, "
-					"rxsubchans=0x%x, audmode=%d\n",
-					p->index, p->name, p->type,
-					p->capability, p->rangelow,
-					p->rangehigh, p->signal, p->afc,
-					p->rxsubchans, p->audmode);
-		break;
-	}
-	case VIDIOC_S_TUNER:
-	{
-		struct v4l2_tuner *p = arg;
-
-		p->type = (vfd->vfl_type == VFL_TYPE_RADIO) ?
-			V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
-		dbgarg(cmd, "index=%d, name=%s, type=%d, "
-				"capability=0x%x, rangelow=%d, "
-				"rangehigh=%d, signal=%d, afc=%d, "
-				"rxsubchans=0x%x, audmode=%d\n",
-				p->index, p->name, p->type,
-				p->capability, p->rangelow,
-				p->rangehigh, p->signal, p->afc,
-				p->rxsubchans, p->audmode);
-		ret = ops->vidioc_s_tuner(file, fh, p);
-		break;
-	}
-	case VIDIOC_G_FREQUENCY:
-	{
-		struct v4l2_frequency *p = arg;
-
-		p->type = (vfd->vfl_type == VFL_TYPE_RADIO) ?
-			V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
-		ret = ops->vidioc_g_frequency(file, fh, p);
-		if (!ret)
-			dbgarg(cmd, "tuner=%d, type=%d, frequency=%d\n",
-					p->tuner, p->type, p->frequency);
-		break;
-	}
-	case VIDIOC_S_FREQUENCY:
-	{
-		struct v4l2_frequency *p = arg;
-		enum v4l2_tuner_type type;
-
-		type = (vfd->vfl_type == VFL_TYPE_RADIO) ?
-			V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
-		dbgarg(cmd, "tuner=%d, type=%d, frequency=%d\n",
-				p->tuner, p->type, p->frequency);
-		if (p->type != type)
-			ret = -EINVAL;
-		else
-			ret = ops->vidioc_s_frequency(file, fh, p);
-		break;
-	}
 	case VIDIOC_G_SLICED_VBI_CAP:
 	{
 		struct v4l2_sliced_vbi_cap *p = arg;
@@ -1804,22 +1830,6 @@ static long __video_do_ioctl(struct file *file,
 			dbgarg(cmd, "chip_ident=%u, revision=0x%x\n", p->ident, p->revision);
 		break;
 	}
-	case VIDIOC_S_HW_FREQ_SEEK:
-	{
-		struct v4l2_hw_freq_seek *p = arg;
-		enum v4l2_tuner_type type;
-
-		type = (vfd->vfl_type == VFL_TYPE_RADIO) ?
-			V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
-		dbgarg(cmd,
-			"tuner=%u, type=%u, seek_upward=%u, wrap_around=%u, spacing=%u\n",
-			p->tuner, p->type, p->seek_upward, p->wrap_around, p->spacing);
-		if (p->type != type)
-			ret = -EINVAL;
-		else
-			ret = ops->vidioc_s_hw_freq_seek(file, fh, p);
-		break;
-	}
 	case VIDIOC_ENUM_FRAMESIZES:
 	{
 		struct v4l2_frmsizeenum *p = arg;
-- 
1.7.10

