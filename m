Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:1537 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934608Ab3DHKr7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Apr 2013 06:47:59 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Eduardo Valentin <edubezval@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 5/7] radio-si4713: fix g/s_frequency
Date: Mon,  8 Apr 2013 12:47:39 +0200
Message-Id: <1365418061-23694-6-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1365418061-23694-1-git-send-email-hverkuil@xs4all.nl>
References: <1365418061-23694-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

- check for invalid modulators.
- clamp frequency to valid range.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/radio/si4713-i2c.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/media/radio/si4713-i2c.c b/drivers/media/radio/si4713-i2c.c
index 1cb9a2e..facd669 100644
--- a/drivers/media/radio/si4713-i2c.c
+++ b/drivers/media/radio/si4713-i2c.c
@@ -1852,7 +1852,8 @@ static int si4713_g_frequency(struct v4l2_subdev *sd, struct v4l2_frequency *f)
 	struct si4713_device *sdev = to_si4713_device(sd);
 	int rval = 0;
 
-	f->type = V4L2_TUNER_RADIO;
+	if (f->tuner)
+		return -EINVAL;
 
 	if (sdev->power_state) {
 		u16 freq;
@@ -1877,9 +1878,11 @@ static int si4713_s_frequency(struct v4l2_subdev *sd, const struct v4l2_frequenc
 	int rval = 0;
 	u16 frequency = v4l2_to_si4713(f->frequency);
 
+	if (f->tuner)
+		return -EINVAL;
+
 	/* Check frequency range */
-	if (frequency < FREQ_RANGE_LOW || frequency > FREQ_RANGE_HIGH)
-		return -EDOM;
+	frequency = clamp_t(u16, frequency, FREQ_RANGE_LOW, FREQ_RANGE_HIGH);
 
 	if (sdev->power_state) {
 		rval = si4713_tx_tune_freq(sdev, frequency);
-- 
1.7.10.4

