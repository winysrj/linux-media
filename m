Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:38435 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751030Ab3LKXyY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Dec 2013 18:54:24 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH RFC 3/4] v4l: add new tuner types for SDR
Date: Thu, 12 Dec 2013 01:54:02 +0200
Message-Id: <1386806043-5331-4-git-send-email-crope@iki.fi>
In-Reply-To: <1386806043-5331-1-git-send-email-crope@iki.fi>
References: <1386806043-5331-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Define tuner types V4L2_TUNER_ADC and V4L2_TUNER_SDR for SDR usage.

ADC is used for setting sampling rate (sampling frequency) to SDR
device.

Another tuner type, SDR, is possible RF tuner. Is is used to
down-convert RF frequency to range ADC could sample. It is optional
for SDR device.

Also add checks to VIDIOC_G_FREQUENCY, VIDIOC_S_FREQUENCY and
VIDIOC_ENUM_FREQ_BANDS only allow these two tuner types when device
type is SDR (VFL_TYPE_SDR).

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/v4l2-core/v4l2-ioctl.c | 38 +++++++++++++++++++++++++-----------
 include/uapi/linux/videodev2.h       |  2 ++
 2 files changed, 29 insertions(+), 11 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index bc10684..ee91a9f 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -1288,8 +1288,13 @@ static int v4l_g_frequency(const struct v4l2_ioctl_ops *ops,
 	struct video_device *vfd = video_devdata(file);
 	struct v4l2_frequency *p = arg;
 
-	p->type = (vfd->vfl_type == VFL_TYPE_RADIO) ?
-			V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
+	if (vfd->vfl_type == VFL_TYPE_SDR) {
+		if (p->type != V4L2_TUNER_ADC && p->type != V4L2_TUNER_SDR)
+			return -EINVAL;
+	} else {
+		p->type = (vfd->vfl_type == VFL_TYPE_RADIO) ?
+				V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
+	}
 	return ops->vidioc_g_frequency(file, fh, p);
 }
 
@@ -1300,10 +1305,16 @@ static int v4l_s_frequency(const struct v4l2_ioctl_ops *ops,
 	const struct v4l2_frequency *p = arg;
 	enum v4l2_tuner_type type;
 
-	type = (vfd->vfl_type == VFL_TYPE_RADIO) ?
-			V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
-	if (p->type != type)
-		return -EINVAL;
+	if (vfd->vfl_type == VFL_TYPE_SDR) {
+		if (p->type != V4L2_TUNER_ADC && p->type != V4L2_TUNER_SDR)
+			return -EINVAL;
+		type = p->type;
+	} else {
+		type = (vfd->vfl_type == VFL_TYPE_RADIO) ?
+				V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
+		if (type != p->type)
+			return -EINVAL;
+	}
 	return ops->vidioc_s_frequency(file, fh, p);
 }
 
@@ -1882,11 +1893,16 @@ static int v4l_enum_freq_bands(const struct v4l2_ioctl_ops *ops,
 	enum v4l2_tuner_type type;
 	int err;
 
-	type = (vfd->vfl_type == VFL_TYPE_RADIO) ?
-			V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
-
-	if (type != p->type)
-		return -EINVAL;
+	if (vfd->vfl_type == VFL_TYPE_SDR) {
+		if (p->type != V4L2_TUNER_ADC && p->type != V4L2_TUNER_SDR)
+			return -EINVAL;
+		type = p->type;
+	} else {
+		type = (vfd->vfl_type == VFL_TYPE_RADIO) ?
+				V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
+		if (type != p->type)
+			return -EINVAL;
+	}
 	if (ops->vidioc_enum_freq_bands)
 		return ops->vidioc_enum_freq_bands(file, fh, p);
 	if (is_valid_ioctl(vfd, VIDIOC_G_TUNER)) {
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index b8ee9048..6c6a601 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -159,6 +159,8 @@ enum v4l2_tuner_type {
 	V4L2_TUNER_RADIO	     = 1,
 	V4L2_TUNER_ANALOG_TV	     = 2,
 	V4L2_TUNER_DIGITAL_TV	     = 3,
+	V4L2_TUNER_ADC               = 4,
+	V4L2_TUNER_SDR               = 5,
 };
 
 enum v4l2_memory {
-- 
1.8.4.2

