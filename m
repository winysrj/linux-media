Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:4731 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985Ab2GBOPv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Jul 2012 10:15:51 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>,
	halli manjunatha <hallimanju@gmail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 2/6] v4l2: add core support for the new VIDIOC_ENUM_FREQ_BANDS ioctl.
Date: Mon,  2 Jul 2012 16:15:08 +0200
Message-Id: <c4f211036f9ee5db95c77732e8180ed2b583a9a3.1341237775.git.hans.verkuil@cisco.com>
In-Reply-To: <1341238512-17504-1-git-send-email-hverkuil@xs4all.nl>
References: <1341238512-17504-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <f8baa47c370e4d79309e126b56127df8a5edd11a.1341237775.git.hans.verkuil@cisco.com>
References: <f8baa47c370e4d79309e126b56127df8a5edd11a.1341237775.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This adds the usual core support code for this new ioctl.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/v4l2-compat-ioctl32.c |    1 +
 drivers/media/video/v4l2-dev.c            |    1 +
 drivers/media/video/v4l2-ioctl.c          |   21 +++++++++++++++++++++
 include/media/v4l2-ioctl.h                |    2 ++
 4 files changed, 25 insertions(+)

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
index 83dbb2d..4e34808 100644
--- a/drivers/media/video/v4l2-dev.c
+++ b/drivers/media/video/v4l2-dev.c
@@ -663,6 +663,7 @@ static void determine_valid_ioctls(struct video_device *vdev)
 	SET_VALID_IOCTL(ops, VIDIOC_S_TUNER, vidioc_s_tuner);
 	SET_VALID_IOCTL(ops, VIDIOC_G_FREQUENCY, vidioc_g_frequency);
 	SET_VALID_IOCTL(ops, VIDIOC_S_FREQUENCY, vidioc_s_frequency);
+	SET_VALID_IOCTL(ops, VIDIOC_ENUM_FREQ_BANDS, vidioc_enum_freq_bands);
 	SET_VALID_IOCTL(ops, VIDIOC_G_SLICED_VBI_CAP, vidioc_g_sliced_vbi_cap);
 	SET_VALID_IOCTL(ops, VIDIOC_LOG_STATUS, vidioc_log_status);
 #ifdef CONFIG_VIDEO_ADV_DEBUG
diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index d7fa896..b8e5ef7 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -284,6 +284,7 @@ static struct v4l2_ioctl_info v4l2_ioctls[] = {
 	IOCTL_INFO(VIDIOC_ENUM_DV_TIMINGS, 0),
 	IOCTL_INFO(VIDIOC_QUERY_DV_TIMINGS, 0),
 	IOCTL_INFO(VIDIOC_DV_TIMINGS_CAP, 0),
+	IOCTL_INFO(VIDIOC_ENUM_FREQ_BANDS, 0),
 };
 #define V4L2_IOCTLS ARRAY_SIZE(v4l2_ioctls)
 
@@ -1765,6 +1766,26 @@ static long __video_do_ioctl(struct file *file,
 			ret = ops->vidioc_s_frequency(file, fh, p);
 		break;
 	}
+	case VIDIOC_ENUM_FREQ_BANDS:
+	{
+		struct v4l2_frequency_band *p = arg;
+		enum v4l2_tuner_type type;
+
+		type = (vfd->vfl_type == VFL_TYPE_RADIO) ?
+			V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
+		if (p->type != type)
+			ret = -EINVAL;
+		else
+			ret = ops->vidioc_enum_freq_bands(file, fh, p);
+		if (!ret)
+			dbgarg(cmd, "tuner=%d, index=%d, name=%s, "
+					"capability=0x%x, rangelow=%d, "
+					"rangehigh=%d\n",
+					p->tuner, p->index, p->name,
+					p->capability, p->rangelow,
+					p->rangehigh);
+		break;
+	}
 	case VIDIOC_G_SLICED_VBI_CAP:
 	{
 		struct v4l2_sliced_vbi_cap *p = arg;
diff --git a/include/media/v4l2-ioctl.h b/include/media/v4l2-ioctl.h
index d8b76f7..6d706ab 100644
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

