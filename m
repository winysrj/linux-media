Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:52372 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752249AbbGaCLK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jul 2015 22:11:10 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Antti Palosaari <crope@iki.fi>
Subject: [PATCHv3 06/13] v4l: add type field to v4l2_modulator struct
Date: Fri, 31 Jul 2015 05:10:43 +0300
Message-Id: <1438308650-2702-7-git-send-email-crope@iki.fi>
In-Reply-To: <1438308650-2702-1-git-send-email-crope@iki.fi>
References: <1438308650-2702-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add type field to that struct like it counterpart v4l2_tuner
already has. We need type field to distinguish different tuner
types from each others for transmitter too.

Cc: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/v4l2-core/v4l2-ioctl.c | 18 +++++++++++++++++-
 include/uapi/linux/videodev2.h       |  3 ++-
 2 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 21e9598..85f80cb 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -1646,15 +1646,31 @@ static int v4l_s_tuner(const struct v4l2_ioctl_ops *ops,
 static int v4l_g_modulator(const struct v4l2_ioctl_ops *ops,
 				struct file *file, void *fh, void *arg)
 {
+	struct video_device *vfd = video_devdata(file);
 	struct v4l2_modulator *p = arg;
 	int err;
 
+	if (vfd->vfl_type == VFL_TYPE_RADIO)
+		p->type = V4L2_TUNER_RADIO;
+
 	err = ops->vidioc_g_modulator(file, fh, p);
 	if (!err)
 		p->capability |= V4L2_TUNER_CAP_FREQ_BANDS;
 	return err;
 }
 
+static int v4l_s_modulator(const struct v4l2_ioctl_ops *ops,
+				struct file *file, void *fh, void *arg)
+{
+	struct video_device *vfd = video_devdata(file);
+	struct v4l2_modulator *p = arg;
+
+	if (vfd->vfl_type == VFL_TYPE_RADIO)
+		p->type = V4L2_TUNER_RADIO;
+
+	return ops->vidioc_s_modulator(file, fh, p);
+}
+
 static int v4l_g_frequency(const struct v4l2_ioctl_ops *ops,
 				struct file *file, void *fh, void *arg)
 {
@@ -2441,7 +2457,7 @@ static struct v4l2_ioctl_info v4l2_ioctls[] = {
 	IOCTL_INFO_STD(VIDIOC_G_AUDOUT, vidioc_g_audout, v4l_print_audioout, 0),
 	IOCTL_INFO_STD(VIDIOC_S_AUDOUT, vidioc_s_audout, v4l_print_audioout, INFO_FL_PRIO),
 	IOCTL_INFO_FNC(VIDIOC_G_MODULATOR, v4l_g_modulator, v4l_print_modulator, INFO_FL_CLEAR(v4l2_modulator, index)),
-	IOCTL_INFO_STD(VIDIOC_S_MODULATOR, vidioc_s_modulator, v4l_print_modulator, INFO_FL_PRIO),
+	IOCTL_INFO_FNC(VIDIOC_S_MODULATOR, v4l_s_modulator, v4l_print_modulator, INFO_FL_PRIO),
 	IOCTL_INFO_FNC(VIDIOC_G_FREQUENCY, v4l_g_frequency, v4l_print_frequency, INFO_FL_CLEAR(v4l2_frequency, tuner)),
 	IOCTL_INFO_FNC(VIDIOC_S_FREQUENCY, v4l_s_frequency, v4l_print_frequency, INFO_FL_PRIO),
 	IOCTL_INFO_FNC(VIDIOC_CROPCAP, v4l_cropcap, v4l_print_cropcap, INFO_FL_CLEAR(v4l2_cropcap, type)),
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 70f06c9..3a8eb8e 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -1584,7 +1584,8 @@ struct v4l2_modulator {
 	__u32			rangelow;
 	__u32			rangehigh;
 	__u32			txsubchans;
-	__u32			reserved[4];
+	__u32			type;	/* enum v4l2_tuner_type */
+	__u32			reserved[3];
 };
 
 /*  Flags for the 'capability' field */
-- 
http://palosaari.fi/

