Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr19.xs4all.nl ([194.109.24.39]:2500 "EHLO
	smtp-vbr19.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932149Ab2GEK0O (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Jul 2012 06:26:14 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	halli manjunatha <hallimanju@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 2/6] v4l2: add core support for the new VIDIOC_ENUM_FREQ_BANDS ioctl.
Date: Thu,  5 Jul 2012 12:25:29 +0200
Message-Id: <7139a19d35532009c0493afd9d62941c98defbdc.1341483687.git.hans.verkuil@cisco.com>
In-Reply-To: <1341483933-9986-1-git-send-email-hverkuil@xs4all.nl>
References: <1341483933-9986-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <9f434bb4733245d7342b1547f65e40dae1603cd5.1341483687.git.hans.verkuil@cisco.com>
References: <9f434bb4733245d7342b1547f65e40dae1603cd5.1341483687.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This adds the usual core support code for this new ioctl.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/v4l2-compat-ioctl32.c |    1 +
 drivers/media/video/v4l2-dev.c            |    2 +
 drivers/media/video/v4l2-ioctl.c          |   88 ++++++++++++++++++++++++++++-
 include/media/v4l2-ioctl.h                |    2 +
 4 files changed, 91 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/v4l2-compat-ioctl32.c b/drivers/media/video/v4l2-compat-ioctl32.c
index 5327ad3..81e5129 100644
--- a/drivers/media/video/v4l2-compat-ioctl32.c
+++ b/drivers/media/video/v4l2-compat-ioctl32.c
@@ -1026,6 +1026,7 @@ long v4l2_compat_ioctl32(struct file *file, unsigned int cmd, unsigned long arg)
 	case VIDIOC_ENUM_DV_TIMINGS:
 	case VIDIOC_QUERY_DV_TIMINGS:
 	case VIDIOC_DV_TIMINGS_CAP:
+	case VIDIOC_ENUM_FREQ_BANDS:
 		ret = do_video_ioctl(file, cmd, arg);
 		break;
 
diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/video/v4l2-dev.c
index d13c47f..ca7ade4 100644
--- a/drivers/media/video/v4l2-dev.c
+++ b/drivers/media/video/v4l2-dev.c
@@ -728,6 +728,8 @@ static void determine_valid_ioctls(struct video_device *vdev)
 	SET_VALID_IOCTL(ops, VIDIOC_UNSUBSCRIBE_EVENT, vidioc_unsubscribe_event);
 	SET_VALID_IOCTL(ops, VIDIOC_CREATE_BUFS, vidioc_create_bufs);
 	SET_VALID_IOCTL(ops, VIDIOC_PREPARE_BUF, vidioc_prepare_buf);
+	if (ops->vidioc_enum_freq_bands || ops->vidioc_g_tuner || ops->vidioc_g_modulator)
+		set_bit(_IOC_NR(VIDIOC_ENUM_FREQ_BANDS), valid_ioctls);
 	bitmap_andnot(vdev->valid_ioctls, valid_ioctls, vdev->valid_ioctls,
 			BASE_VIDIOC_PRIVATE);
 }
diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index 70e0efb..675d8a4 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -825,6 +825,17 @@ static void v4l_print_sliced_vbi_cap(const void *arg, bool write_only)
 				p->service_lines[1][i]);
 }
 
+static void v4l_print_freq_band(const void *arg, bool write_only)
+{
+	const struct v4l2_frequency_band *p = arg;
+
+	pr_cont("tuner=%u, type=%u, index=%u, capability=0x%x, "
+			"rangelow=%u, rangehigh=%u, modulation=0x%x\n",
+			p->tuner, p->type, p->index,
+			p->capability, p->rangelow,
+			p->rangehigh, p->modulation);
+}
+
 static void v4l_print_u32(const void *arg, bool write_only)
 {
 	pr_cont("value=%u\n", *(const u32 *)arg);
@@ -1245,10 +1256,14 @@ static int v4l_g_tuner(const struct v4l2_ioctl_ops *ops,
 {
 	struct video_device *vfd = video_devdata(file);
 	struct v4l2_tuner *p = arg;
+	int err;
 
 	p->type = (vfd->vfl_type == VFL_TYPE_RADIO) ?
 			V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
-	return ops->vidioc_g_tuner(file, fh, p);
+	err = ops->vidioc_g_tuner(file, fh, p);
+	if (!err)
+		p->capability |= V4L2_TUNER_CAP_FREQ_BANDS;
+	return err;
 }
 
 static int v4l_s_tuner(const struct v4l2_ioctl_ops *ops,
@@ -1262,6 +1277,18 @@ static int v4l_s_tuner(const struct v4l2_ioctl_ops *ops,
 	return ops->vidioc_s_tuner(file, fh, p);
 }
 
+static int v4l_g_modulator(const struct v4l2_ioctl_ops *ops,
+				struct file *file, void *fh, void *arg)
+{
+	struct v4l2_modulator *p = arg;
+	int err;
+
+	err = ops->vidioc_g_modulator(file, fh, p);
+	if (!err)
+		p->capability |= V4L2_TUNER_CAP_FREQ_BANDS;
+	return err;
+}
+
 static int v4l_g_frequency(const struct v4l2_ioctl_ops *ops,
 				struct file *file, void *fh, void *arg)
 {
@@ -1798,6 +1825,62 @@ static int v4l_g_sliced_vbi_cap(const struct v4l2_ioctl_ops *ops,
 	return ops->vidioc_g_sliced_vbi_cap(file, fh, p);
 }
 
+static int v4l_enum_freq_bands(const struct v4l2_ioctl_ops *ops,
+				struct file *file, void *fh, void *arg)
+{
+	struct video_device *vfd = video_devdata(file);
+	struct v4l2_frequency_band *p = arg;
+	enum v4l2_tuner_type type;
+	int err;
+
+	type = (vfd->vfl_type == VFL_TYPE_RADIO) ?
+			V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
+
+	if (type != p->type)
+		return -EINVAL;
+	if (ops->vidioc_enum_freq_bands)
+		return ops->vidioc_enum_freq_bands(file, fh, p);
+
+	/* There is only one frequency band */
+	if (p->index)
+		return -EINVAL;
+	if (ops->vidioc_g_tuner) {
+		struct v4l2_tuner t = {
+			.index = p->tuner,
+			.type = type,
+		};
+
+		err = ops->vidioc_g_tuner(file, fh, &t);
+		if (err)
+			return err;
+		p->capability = t.capability | V4L2_TUNER_CAP_FREQ_BANDS;
+		p->rangelow = t.rangelow;
+		p->rangehigh = t.rangehigh;
+		p->modulation = (type == V4L2_TUNER_RADIO) ?
+			V4L2_BAND_MODULATION_FM : V4L2_BAND_MODULATION_VSB;
+		return 0;
+	}
+	if (ops->vidioc_g_modulator) {
+		struct v4l2_modulator m = {
+			.index = p->tuner,
+		};
+
+		if (type != V4L2_TUNER_RADIO)
+			return -EINVAL;
+		err = ops->vidioc_g_modulator(file, fh, &m);
+		if (err)
+			return err;
+		p->capability = m.capability | V4L2_TUNER_CAP_FREQ_BANDS;
+		p->rangelow = m.rangelow;
+		p->rangehigh = m.rangehigh;
+		p->modulation = (type == V4L2_TUNER_RADIO) ?
+			V4L2_BAND_MODULATION_FM : V4L2_BAND_MODULATION_VSB;
+		return 0;
+	}
+	/* This should never happen */
+	return -ENOTTY;
+}
+
 struct v4l2_ioctl_info {
 	unsigned int ioctl;
 	u32 flags;
@@ -1879,7 +1962,7 @@ static struct v4l2_ioctl_info v4l2_ioctls[] = {
 	IOCTL_INFO_FNC(VIDIOC_ENUMOUTPUT, v4l_enumoutput, v4l_print_enumoutput, INFO_FL_CLEAR(v4l2_output, index)),
 	IOCTL_INFO_STD(VIDIOC_G_AUDOUT, vidioc_g_audout, v4l_print_audioout, 0),
 	IOCTL_INFO_STD(VIDIOC_S_AUDOUT, vidioc_s_audout, v4l_print_audioout, INFO_FL_PRIO),
-	IOCTL_INFO_STD(VIDIOC_G_MODULATOR, vidioc_g_modulator, v4l_print_modulator, INFO_FL_CLEAR(v4l2_modulator, index)),
+	IOCTL_INFO_FNC(VIDIOC_G_MODULATOR, v4l_g_modulator, v4l_print_modulator, INFO_FL_CLEAR(v4l2_modulator, index)),
 	IOCTL_INFO_STD(VIDIOC_S_MODULATOR, vidioc_s_modulator, v4l_print_modulator, INFO_FL_PRIO),
 	IOCTL_INFO_FNC(VIDIOC_G_FREQUENCY, v4l_g_frequency, v4l_print_frequency, INFO_FL_CLEAR(v4l2_frequency, tuner)),
 	IOCTL_INFO_FNC(VIDIOC_S_FREQUENCY, v4l_s_frequency, v4l_print_frequency, INFO_FL_PRIO),
@@ -1926,6 +2009,7 @@ static struct v4l2_ioctl_info v4l2_ioctls[] = {
 	IOCTL_INFO_STD(VIDIOC_ENUM_DV_TIMINGS, vidioc_enum_dv_timings, v4l_print_enum_dv_timings, 0),
 	IOCTL_INFO_STD(VIDIOC_QUERY_DV_TIMINGS, vidioc_query_dv_timings, v4l_print_dv_timings, 0),
 	IOCTL_INFO_STD(VIDIOC_DV_TIMINGS_CAP, vidioc_dv_timings_cap, v4l_print_dv_timings_cap, 0),
+	IOCTL_INFO_FNC(VIDIOC_ENUM_FREQ_BANDS, v4l_enum_freq_bands, v4l_print_freq_band, 0),
 };
 #define V4L2_IOCTLS ARRAY_SIZE(v4l2_ioctls)
 
diff --git a/include/media/v4l2-ioctl.h b/include/media/v4l2-ioctl.h
index 19e9352..e614c9c 100644
--- a/include/media/v4l2-ioctl.h
+++ b/include/media/v4l2-ioctl.h
@@ -230,6 +230,8 @@ struct v4l2_ioctl_ops {
 					struct v4l2_frequency *a);
 	int (*vidioc_s_frequency)      (struct file *file, void *fh,
 					struct v4l2_frequency *a);
+	int (*vidioc_enum_freq_bands) (struct file *file, void *fh,
+				    struct v4l2_frequency_band *band);
 
 	/* Sliced VBI cap */
 	int (*vidioc_g_sliced_vbi_cap) (struct file *file, void *fh,
-- 
1.7.10

