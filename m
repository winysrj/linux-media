Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:42827 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751800AbaBIJaw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 9 Feb 2014 04:30:52 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>, Hans Verkuil <hverkuil@xs4all.nl>
Subject: [REVIEW PATCH 73/86] msi001: implement .enum_freq_bands()
Date: Sun,  9 Feb 2014 10:49:18 +0200
Message-Id: <1391935771-18670-74-git-send-email-crope@iki.fi>
In-Reply-To: <1391935771-18670-1-git-send-email-crope@iki.fi>
References: <1391935771-18670-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Implement .enum_freq_bands() in order to provide
VIDIOC_ENUM_FREQ_BANDS IOCTL from sub-device.

Cc: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/staging/media/msi3101/msi001.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/staging/media/msi3101/msi001.c b/drivers/staging/media/msi3101/msi001.c
index 5c5bb52..da7a34d 100644
--- a/drivers/staging/media/msi3101/msi001.c
+++ b/drivers/staging/media/msi3101/msi001.c
@@ -345,11 +345,29 @@ static int msi001_s_frequency(struct v4l2_subdev *sd,
 	return msi001_set_tuner(s);
 }
 
+static int msi001_enum_freq_bands(struct v4l2_subdev *sd,
+		struct v4l2_frequency_band *band)
+{
+	struct msi001 *s = sd_to_msi001(sd);
+	dev_dbg(&s->spi->dev, "%s: tuner=%d type=%d index=%d\n",
+			__func__, band->tuner, band->type, band->index);
+
+	if (band->index >= ARRAY_SIZE(bands))
+		return -EINVAL;
+
+	band->capability = bands[band->index].capability;
+	band->rangelow = bands[band->index].rangelow;
+	band->rangehigh = bands[band->index].rangehigh;
+
+	return 0;
+}
+
 static const struct v4l2_subdev_tuner_ops msi001_tuner_ops = {
 	.g_tuner                  = msi001_g_tuner,
 	.s_tuner                  = msi001_s_tuner,
 	.g_frequency              = msi001_g_frequency,
 	.s_frequency              = msi001_s_frequency,
+	.enum_freq_bands          = msi001_enum_freq_bands,
 };
 
 static const struct v4l2_subdev_ops msi001_ops = {
-- 
1.8.5.3

