Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:43193 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751039Ab3LTFuM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Dec 2013 00:50:12 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH RFC v5 02/12] v4l: add new tuner types for SDR
Date: Fri, 20 Dec 2013 07:49:44 +0200
Message-Id: <1387518594-11609-3-git-send-email-crope@iki.fi>
In-Reply-To: <1387518594-11609-1-git-send-email-crope@iki.fi>
References: <1387518594-11609-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Define tuner types V4L2_TUNER_ADC and V4L2_TUNER_RF for SDR usage.

ADC is used for setting sampling rate (sampling frequency) to SDR
device.

Another tuner type, named as V4L2_TUNER_RF, is possible RF tuner.
Is is used to down-convert RF frequency to range ADC could sample.
Having RF tuner is optional, whilst in practice it is almost always
there.

Also add checks to VIDIOC_G_FREQUENCY, VIDIOC_S_FREQUENCY and
VIDIOC_ENUM_FREQ_BANDS only allow these two tuner types when device
type is SDR (VFL_TYPE_SDR). For VIDIOC_G_FREQUENCY we do not check
tuner type, instead override type with V4L2_TUNER_ADC in every
case (requested by Hans in order to keep functionality in line with
existing tuners and existing API does not specify it).

Prohibit VIDIOC_S_HW_FREQ_SEEK explicitly when device type is SDR,
as device cannot do hardware seek without a hardware demodulator.

Cc: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Antti Palosaari <crope@iki.fi>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-ioctl.c | 39 ++++++++++++++++++++++++++----------
 include/uapi/linux/videodev2.h       |  2 ++
 2 files changed, 30 insertions(+), 11 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 68e6b5e..0397fc6 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -1288,8 +1288,11 @@ static int v4l_g_frequency(const struct v4l2_ioctl_ops *ops,
 	struct video_device *vfd = video_devdata(file);
 	struct v4l2_frequency *p = arg;
 
-	p->type = (vfd->vfl_type == VFL_TYPE_RADIO) ?
-			V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
+	if (vfd->vfl_type == VFL_TYPE_SDR)
+		p->type = V4L2_TUNER_ADC;
+	else
+		p->type = (vfd->vfl_type == VFL_TYPE_RADIO) ?
+				V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
 	return ops->vidioc_g_frequency(file, fh, p);
 }
 
@@ -1300,10 +1303,15 @@ static int v4l_s_frequency(const struct v4l2_ioctl_ops *ops,
 	const struct v4l2_frequency *p = arg;
 	enum v4l2_tuner_type type;
 
-	type = (vfd->vfl_type == VFL_TYPE_RADIO) ?
-			V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
-	if (p->type != type)
-		return -EINVAL;
+	if (vfd->vfl_type == VFL_TYPE_SDR) {
+		if (p->type != V4L2_TUNER_ADC && p->type != V4L2_TUNER_RF)
+			return -EINVAL;
+	} else {
+		type = (vfd->vfl_type == VFL_TYPE_RADIO) ?
+				V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
+		if (type != p->type)
+			return -EINVAL;
+	}
 	return ops->vidioc_s_frequency(file, fh, p);
 }
 
@@ -1383,6 +1391,10 @@ static int v4l_s_hw_freq_seek(const struct v4l2_ioctl_ops *ops,
 	struct v4l2_hw_freq_seek *p = arg;
 	enum v4l2_tuner_type type;
 
+	/* s_hw_freq_seek is not supported for SDR for now */
+	if (vfd->vfl_type == VFL_TYPE_SDR)
+		return -EINVAL;
+
 	type = (vfd->vfl_type == VFL_TYPE_RADIO) ?
 		V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
 	if (p->type != type)
@@ -1882,11 +1894,16 @@ static int v4l_enum_freq_bands(const struct v4l2_ioctl_ops *ops,
 	enum v4l2_tuner_type type;
 	int err;
 
-	type = (vfd->vfl_type == VFL_TYPE_RADIO) ?
-			V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
-
-	if (type != p->type)
-		return -EINVAL;
+	if (vfd->vfl_type == VFL_TYPE_SDR) {
+		if (p->type != V4L2_TUNER_ADC && p->type != V4L2_TUNER_RF)
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
index 437f1b0..3fff116 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -159,6 +159,8 @@ enum v4l2_tuner_type {
 	V4L2_TUNER_RADIO	     = 1,
 	V4L2_TUNER_ANALOG_TV	     = 2,
 	V4L2_TUNER_DIGITAL_TV	     = 3,
+	V4L2_TUNER_ADC               = 4,
+	V4L2_TUNER_RF                = 5,
 };
 
 enum v4l2_memory {
-- 
1.8.4.2

