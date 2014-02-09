Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:47091 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751403AbaBIJ2Z (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 9 Feb 2014 04:28:25 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [REVIEW PATCH 74/86] msi3101: provide RF tuner bands from sub-device
Date: Sun,  9 Feb 2014 10:49:19 +0200
Message-Id: <1391935771-18670-75-git-send-email-crope@iki.fi>
In-Reply-To: <1391935771-18670-1-git-send-email-crope@iki.fi>
References: <1391935771-18670-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Let the msi001 tuner driver report its frequency bands.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/staging/media/msi3101/sdr-msi3101.c | 48 +++++++++--------------------
 1 file changed, 15 insertions(+), 33 deletions(-)

diff --git a/drivers/staging/media/msi3101/sdr-msi3101.c b/drivers/staging/media/msi3101/sdr-msi3101.c
index f996220..158cbe0 100644
--- a/drivers/staging/media/msi3101/sdr-msi3101.c
+++ b/drivers/staging/media/msi3101/sdr-msi3101.c
@@ -57,7 +57,7 @@
 #define V4L2_PIX_FMT_SDR_S14    v4l2_fourcc('D', 'S', '1', '4') /* signed 14-bit */
 #define V4L2_PIX_FMT_SDR_MSI2500_384 v4l2_fourcc('M', '3', '8', '4') /* Mirics MSi2500 format 384 */
 
-static const struct v4l2_frequency_band bands_adc[] = {
+static const struct v4l2_frequency_band bands[] = {
 	{
 		.tuner = 0,
 		.type = V4L2_TUNER_ADC,
@@ -68,24 +68,6 @@ static const struct v4l2_frequency_band bands_adc[] = {
 	},
 };
 
-static const struct v4l2_frequency_band bands_rf[] = {
-	{
-		.tuner = 1,
-		.type = V4L2_TUNER_RF,
-		.index = 0,
-		.capability = V4L2_TUNER_CAP_1HZ | V4L2_TUNER_CAP_FREQ_BANDS,
-		.rangelow   =   49000000,
-		.rangehigh  =  263000000,
-	}, {
-		.tuner = 1,
-		.type = V4L2_TUNER_RF,
-		.index = 1,
-		.capability = V4L2_TUNER_CAP_1HZ | V4L2_TUNER_CAP_FREQ_BANDS,
-		.rangelow   =  390000000,
-		.rangehigh  =  960000000,
-	},
-};
-
 /* stream formats */
 struct msi3101_format {
 	char	*name;
@@ -1269,8 +1251,8 @@ static int msi3101_s_frequency(struct file *file, void *priv,
 
 	if (f->tuner == 0) {
 		s->f_adc = clamp_t(unsigned int, f->frequency,
-				bands_adc[0].rangelow,
-				bands_adc[0].rangehigh);
+				bands[0].rangelow,
+				bands[0].rangehigh);
 		dev_dbg(&s->udev->dev, "%s: ADC frequency=%u Hz\n",
 				__func__, s->f_adc);
 		ret = msi3101_set_usb_adc(s);
@@ -1287,25 +1269,25 @@ static int msi3101_enum_freq_bands(struct file *file, void *priv,
 		struct v4l2_frequency_band *band)
 {
 	struct msi3101_state *s = video_drvdata(file);
+	int ret;
 	dev_dbg(&s->udev->dev, "%s: tuner=%d type=%d index=%d\n",
 			__func__, band->tuner, band->type, band->index);
 
 	if (band->tuner == 0) {
-		if (band->index >= ARRAY_SIZE(bands_adc))
-			return -EINVAL;
-
-		*band = bands_adc[band->index];
+		if (band->index >= ARRAY_SIZE(bands)) {
+			ret = -EINVAL;
+		} else {
+			*band = bands[band->index];
+			ret = 0;
+		}
 	} else if (band->tuner == 1) {
-		/* TODO: add that to v4l2_subdev_tuner_ops */
-		if (band->index >= ARRAY_SIZE(bands_rf))
-			return -EINVAL;
-
-		*band = bands_rf[band->index];
+		ret = v4l2_subdev_call(s->v4l2_subdev, tuner,
+				enum_freq_bands, band);
 	} else {
-		return -EINVAL;
+		ret = -EINVAL;
 	}
 
-	return 0;
+	return ret;
 }
 
 static const struct v4l2_ioctl_ops msi3101_ioctl_ops = {
@@ -1414,7 +1396,7 @@ static int msi3101_probe(struct usb_interface *intf,
 	spin_lock_init(&s->queued_bufs_lock);
 	INIT_LIST_HEAD(&s->queued_bufs);
 	s->udev = udev;
-	s->f_adc = bands_adc[0].rangelow;
+	s->f_adc = bands[0].rangelow;
 	s->pixelformat = V4L2_SDR_FMT_CU8;
 
 	/* Init videobuf2 queue structure */
-- 
1.8.5.3

