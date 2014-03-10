Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:53313 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754071AbaCJTer (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Mar 2014 15:34:47 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Antti Palosaari <crope@iki.fi>
Subject: [FINAL PATCH 6/6] msi3101: fix v4l2-compliance issues
Date: Mon, 10 Mar 2014 21:34:12 +0200
Message-Id: <1394480052-6003-6-git-send-email-crope@iki.fi>
In-Reply-To: <1394480052-6003-1-git-send-email-crope@iki.fi>
References: <1394480052-6003-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix msi3101 driver v4l2-compliance issues.

Cc: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/staging/media/msi3101/sdr-msi3101.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/staging/media/msi3101/sdr-msi3101.c b/drivers/staging/media/msi3101/sdr-msi3101.c
index 93e6eba..011db2c 100644
--- a/drivers/staging/media/msi3101/sdr-msi3101.c
+++ b/drivers/staging/media/msi3101/sdr-msi3101.c
@@ -1134,6 +1134,7 @@ static int msi3101_g_fmt_sdr_cap(struct file *file, void *priv,
 	dev_dbg(&s->udev->dev, "%s: pixelformat fourcc %4.4s\n", __func__,
 			(char *)&s->pixelformat);
 
+	memset(f->fmt.sdr.reserved, 0, sizeof(f->fmt.sdr.reserved));
 	f->fmt.sdr.pixelformat = s->pixelformat;
 
 	return 0;
@@ -1151,6 +1152,7 @@ static int msi3101_s_fmt_sdr_cap(struct file *file, void *priv,
 	if (vb2_is_busy(q))
 		return -EBUSY;
 
+	memset(f->fmt.sdr.reserved, 0, sizeof(f->fmt.sdr.reserved));
 	for (i = 0; i < NUM_FORMATS; i++) {
 		if (formats[i].pixelformat == f->fmt.sdr.pixelformat) {
 			s->pixelformat = f->fmt.sdr.pixelformat;
@@ -1172,6 +1174,7 @@ static int msi3101_try_fmt_sdr_cap(struct file *file, void *priv,
 	dev_dbg(&s->udev->dev, "%s: pixelformat fourcc %4.4s\n", __func__,
 			(char *)&f->fmt.sdr.pixelformat);
 
+	memset(f->fmt.sdr.reserved, 0, sizeof(f->fmt.sdr.reserved));
 	for (i = 0; i < NUM_FORMATS; i++) {
 		if (formats[i].pixelformat == f->fmt.sdr.pixelformat)
 			return 0;
@@ -1233,6 +1236,7 @@ static int msi3101_g_frequency(struct file *file, void *priv,
 		f->frequency = s->f_adc;
 		ret = 0;
 	} else if (f->tuner == 1) {
+		f->type = V4L2_TUNER_RF;
 		ret = v4l2_subdev_call(s->v4l2_subdev, tuner, g_frequency, f);
 	} else {
 		ret = -EINVAL;
-- 
1.8.5.3

