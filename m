Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57342 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754115Ab3DUTAs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Apr 2013 15:00:48 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r3LJ0mTl022608
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 21 Apr 2013 15:00:48 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFCv3 05/10] [media] v4l2-ioctl: Add tuner ioctl support for SDR radio type
Date: Sun, 21 Apr 2013 16:00:34 -0300
Message-Id: <1366570839-662-6-git-send-email-mchehab@redhat.com>
In-Reply-To: <1366570839-662-1-git-send-email-mchehab@redhat.com>
References: <1366570839-662-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The tuner ioctl's are optimized to handle internally the
differences between TV and normal AM/FM radio.

SDR is different than both, so it needs its own way of doing things.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/v4l2-core/v4l2-ioctl.c | 89 ++++++++++++++++++++++++++----------
 include/uapi/linux/videodev2.h       |  5 ++
 2 files changed, 70 insertions(+), 24 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index fd853da..f8bb171 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -1296,6 +1296,19 @@ static int v4l_streamoff(const struct v4l2_ioctl_ops *ops,
 	return ops->vidioc_streamoff(file, fh, *(unsigned int *)arg);
 }
 
+static u32 v4l_device_type(struct video_device *vfd)
+{
+	switch (vfd->vfl_type) {
+	case VFL_TYPE_RADIO:
+		return V4L2_TUNER_RADIO;
+	case VFL_TYPE_SDR:
+		/* May be overriden by the driver */
+		return V4L2_TUNER_SDR_RADIO;
+	default:
+		return V4L2_TUNER_ANALOG_TV;
+	}
+}
+
 static int v4l_g_tuner(const struct v4l2_ioctl_ops *ops,
 				struct file *file, void *fh, void *arg)
 {
@@ -1303,8 +1316,7 @@ static int v4l_g_tuner(const struct v4l2_ioctl_ops *ops,
 	struct v4l2_tuner *p = arg;
 	int err;
 
-	p->type = (vfd->vfl_type == VFL_TYPE_RADIO) ?
-			V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
+	p->type = v4l_device_type(vfd);
 	err = ops->vidioc_g_tuner(file, fh, p);
 	if (!err)
 		p->capability |= V4L2_TUNER_CAP_FREQ_BANDS;
@@ -1316,9 +1328,18 @@ static int v4l_s_tuner(const struct v4l2_ioctl_ops *ops,
 {
 	struct video_device *vfd = video_devdata(file);
 	struct v4l2_tuner *p = arg;
+	u32 type;
+
+	/*
+	 * For non-SDR devices, the type is defined by the dev type;
+	 * For SDR devices, if the type is not an SDR type return error
+	 */
+	type = v4l_device_type(vfd);
+	if (type != VFL_TYPE_SDR)
+		p->type = type;
+	else if (!V4L2_TUNER_IS_SDR(p->type))
+		return -EINVAL;
 
-	p->type = (vfd->vfl_type == VFL_TYPE_RADIO) ?
-			V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
 	return ops->vidioc_s_tuner(file, fh, p);
 }
 
@@ -1340,8 +1361,7 @@ static int v4l_g_frequency(const struct v4l2_ioctl_ops *ops,
 	struct video_device *vfd = video_devdata(file);
 	struct v4l2_frequency *p = arg;
 
-	p->type = (vfd->vfl_type == VFL_TYPE_RADIO) ?
-			V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
+	p->type = v4l_device_type(vfd);
 	return ops->vidioc_g_frequency(file, fh, p);
 }
 
@@ -1352,10 +1372,13 @@ static int v4l_s_frequency(const struct v4l2_ioctl_ops *ops,
 	const struct v4l2_frequency *p = arg;
 	enum v4l2_tuner_type type;
 
-	type = (vfd->vfl_type == VFL_TYPE_RADIO) ?
-			V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
-	if (p->type != type)
+	type = v4l_device_type(vfd);
+	if (type != VFL_TYPE_SDR) {
+		if (p->type != type)
+			return -EINVAL;
+	} else if (!V4L2_TUNER_IS_SDR(p->type))
 		return -EINVAL;
+
 	return ops->vidioc_s_frequency(file, fh, p);
 }
 
@@ -1457,10 +1480,13 @@ static int v4l_s_hw_freq_seek(const struct v4l2_ioctl_ops *ops,
 	struct v4l2_hw_freq_seek *p = arg;
 	enum v4l2_tuner_type type;
 
-	type = (vfd->vfl_type == VFL_TYPE_RADIO) ?
-		V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
-	if (p->type != type)
+	type = v4l_device_type(vfd);
+	if (type != VFL_TYPE_SDR) {
+		if (p->type != type)
+			return -EINVAL;
+	} else if (!V4L2_TUNER_IS_SDR(p->type))
 		return -EINVAL;
+
 	return ops->vidioc_s_hw_freq_seek(file, fh, p);
 }
 
@@ -1974,12 +2000,19 @@ static int v4l_enum_freq_bands(const struct v4l2_ioctl_ops *ops,
 	struct v4l2_frequency_band *p = arg;
 	enum v4l2_tuner_type type;
 	int err;
+	bool is_sdr;
 
-	type = (vfd->vfl_type == VFL_TYPE_RADIO) ?
-			V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
+	type = v4l_device_type(vfd);
+	if (type != VFL_TYPE_SDR) {
+		if (p->type != type)
+			return -EINVAL;
+		is_sdr = false;
+	} else {
+		if (!V4L2_TUNER_IS_SDR(type))
+			return -EINVAL;
+		is_sdr = true;
+	}
 
-	if (type != p->type)
-		return -EINVAL;
 	if (ops->vidioc_enum_freq_bands)
 		return ops->vidioc_enum_freq_bands(file, fh, p);
 	if (is_valid_ioctl(vfd, VIDIOC_G_TUNER)) {
@@ -1988,7 +2021,7 @@ static int v4l_enum_freq_bands(const struct v4l2_ioctl_ops *ops,
 			.type = type,
 		};
 
-		if (p->index)
+		if (p->index && !is_sdr)
 			return -EINVAL;
 		err = ops->vidioc_g_tuner(file, fh, &t);
 		if (err)
@@ -1996,16 +2029,15 @@ static int v4l_enum_freq_bands(const struct v4l2_ioctl_ops *ops,
 		p->capability = t.capability | V4L2_TUNER_CAP_FREQ_BANDS;
 		p->rangelow = t.rangelow;
 		p->rangehigh = t.rangehigh;
-		p->modulation = (type == V4L2_TUNER_RADIO) ?
-			V4L2_BAND_MODULATION_FM : V4L2_BAND_MODULATION_VSB;
-		return 0;
+
+		goto ret;
 	}
 	if (is_valid_ioctl(vfd, VIDIOC_G_MODULATOR)) {
 		struct v4l2_modulator m = {
 			.index = p->tuner,
 		};
 
-		if (type != V4L2_TUNER_RADIO)
+		if (type == V4L2_TUNER_ANALOG_TV)
 			return -EINVAL;
 		if (p->index)
 			return -EINVAL;
@@ -2015,11 +2047,20 @@ static int v4l_enum_freq_bands(const struct v4l2_ioctl_ops *ops,
 		p->capability = m.capability | V4L2_TUNER_CAP_FREQ_BANDS;
 		p->rangelow = m.rangelow;
 		p->rangehigh = m.rangehigh;
-		p->modulation = (type == V4L2_TUNER_RADIO) ?
-			V4L2_BAND_MODULATION_FM : V4L2_BAND_MODULATION_VSB;
-		return 0;
+		goto ret;
 	}
 	return -ENOTTY;
+ret:
+	if (is_sdr) {
+		/* With SDR, modulation type can be anything */
+		p->modulation = V4L2_BAND_MODULATION_ANY;
+		return 0;
+	}
+
+	p->modulation = (type == V4L2_TUNER_RADIO) ?
+		V4L2_BAND_MODULATION_FM : V4L2_BAND_MODULATION_VSB;
+	return 0;
+
 }
 
 struct v4l2_ioctl_info {
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index c002030..e2cc369 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -176,8 +176,12 @@ enum v4l2_tuner_type {
 	V4L2_TUNER_SDR_DTV_ATSC,	/* Optimize for Digital TV, ATSC */
 	V4L2_TUNER_SDR_DTV_DVBT,	/* Optimize for Digital TV, DVB-T */
 	V4L2_TUNER_SDR_DTV_ISDBT,	/* Optimize for Digital TV, ISDB-T */
+	V4L2_TUNER_SDR_MAX
 };
 
+#define V4L2_TUNER_IS_SDR(type)					\
+	(((type) >= V4L2_TUNER_SDR_RADIO) || ((type) < V4L2_TUNER_SDR_MAX))
+
 enum v4l2_memory {
 	V4L2_MEMORY_MMAP             = 1,
 	V4L2_MEMORY_USERPTR          = 2,
@@ -1388,6 +1392,7 @@ struct v4l2_frequency {
 #define V4L2_BAND_MODULATION_VSB	(1 << 1)
 #define V4L2_BAND_MODULATION_FM		(1 << 2)
 #define V4L2_BAND_MODULATION_AM		(1 << 3)
+#define V4L2_BAND_MODULATION_ANY	(1 << 4)
 
 struct v4l2_frequency_band {
 	__u32	tuner;
-- 
1.8.1.4

