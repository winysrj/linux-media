Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:57844 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751862AbbIAXFC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Sep 2015 19:05:02 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Antti Palosaari <crope@iki.fi>
Subject: [PATCH 2/2] vivid: sdr cap: few enhancements
Date: Wed,  2 Sep 2015 02:04:51 +0300
Message-Id: <1441148691-8799-2-git-send-email-crope@iki.fi>
In-Reply-To: <1441148691-8799-1-git-send-email-crope@iki.fi>
References: <1441148691-8799-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

* Constify struct

* Fix comments

* Fix alignment

* Use modulus to transfer phase angles

* Correct float [-1.0, +1.0] to s8 [-128, 127] conversion

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/platform/vivid/vivid-sdr-cap.c | 31 +++++++++++-----------------
 1 file changed, 12 insertions(+), 19 deletions(-)

diff --git a/drivers/media/platform/vivid/vivid-sdr-cap.c b/drivers/media/platform/vivid/vivid-sdr-cap.c
index c36b3f5..fcbf498 100644
--- a/drivers/media/platform/vivid/vivid-sdr-cap.c
+++ b/drivers/media/platform/vivid/vivid-sdr-cap.c
@@ -41,7 +41,7 @@ struct vivid_format {
 };
 
 /* format descriptions for capture and preview */
-static struct vivid_format formats[] = {
+static const struct vivid_format formats[] = {
 	{
 		.pixelformat	= V4L2_SDR_FMT_CU8,
 		.buffersize	= SDR_CAP_SAMPLES_PER_BUF * 2,
@@ -502,16 +502,10 @@ void vivid_sdr_cap_process(struct vivid_dev *dev, struct vivid_buffer *buf)
 	s32 fixp_i;
 	s32 fixp_q;
 
-	/*
-	 * TODO: Generated beep tone goes very crackly when sample rate is
-	 * increased to ~1Msps or more. That is because of huge rounding error
-	 * of phase angle caused by used cosine implementation.
-	 */
-
 	/* calculate phase step */
 	#define BEEP_FREQ 1000 /* 1kHz beep */
 	src_phase_step = DIV_ROUND_CLOSEST(FIXP_2PI * BEEP_FREQ,
-			dev->sdr_adc_freq);
+					   dev->sdr_adc_freq);
 
 	for (i = 0; i < plane_size; i += 2) {
 		mod_phase_step = fixp_cos32_rad(dev->sdr_fixp_src_phase,
@@ -522,17 +516,15 @@ void vivid_sdr_cap_process(struct vivid_dev *dev, struct vivid_buffer *buf)
 		dev->sdr_fixp_mod_phase += div_s64(s64tmp, M_100000PI);
 
 		/*
-		 * Transfer phases to [0 / 2xPI] in order to avoid variable
+		 * Transfer phase agle to [0, 2xPI] in order to avoid variable
 		 * overflow and make it suitable for cosine implementation
 		 * used, which does not support negative angles.
 		 */
-		while (dev->sdr_fixp_mod_phase < FIXP_2PI)
-			dev->sdr_fixp_mod_phase += FIXP_2PI;
-		while (dev->sdr_fixp_mod_phase > FIXP_2PI)
-			dev->sdr_fixp_mod_phase -= FIXP_2PI;
+		dev->sdr_fixp_src_phase %= FIXP_2PI;
+		dev->sdr_fixp_mod_phase %= FIXP_2PI;
 
-		while (dev->sdr_fixp_src_phase > FIXP_2PI)
-			dev->sdr_fixp_src_phase -= FIXP_2PI;
+		if (dev->sdr_fixp_mod_phase < 0)
+			dev->sdr_fixp_mod_phase += FIXP_2PI;
 
 		fixp_i = fixp_cos32_rad(dev->sdr_fixp_mod_phase, FIXP_2PI);
 		fixp_q = fixp_sin32_rad(dev->sdr_fixp_mod_phase, FIXP_2PI);
@@ -544,7 +536,7 @@ void vivid_sdr_cap_process(struct vivid_dev *dev, struct vivid_buffer *buf)
 
 		switch (dev->sdr_pixelformat) {
 		case V4L2_SDR_FMT_CU8:
-			/* convert 'fixp float' to u8 */
+			/* convert 'fixp float' to u8 [0, +255] */
 			/* u8 = X * 127.5 + 127.5; X is float [-1.0, +1.0] */
 			fixp_i = fixp_i * 1275 + FIXP_FRAC * 1275;
 			fixp_q = fixp_q * 1275 + FIXP_FRAC * 1275;
@@ -552,9 +544,10 @@ void vivid_sdr_cap_process(struct vivid_dev *dev, struct vivid_buffer *buf)
 			*vbuf++ = DIV_ROUND_CLOSEST(fixp_q, FIXP_FRAC * 10);
 			break;
 		case V4L2_SDR_FMT_CS8:
-			/* convert 'fixp float' to s8 */
-			fixp_i = fixp_i * 1275;
-			fixp_q = fixp_q * 1275;
+			/* convert 'fixp float' to s8 [-128, +127] */
+			/* s8 = X * 127.5 - 0.5; X is float [-1.0, +1.0] */
+			fixp_i = fixp_i * 1275 - FIXP_FRAC * 5;
+			fixp_q = fixp_q * 1275 - FIXP_FRAC * 5;
 			*vbuf++ = DIV_ROUND_CLOSEST(fixp_i, FIXP_FRAC * 10);
 			*vbuf++ = DIV_ROUND_CLOSEST(fixp_q, FIXP_FRAC * 10);
 			break;
-- 
http://palosaari.fi/

