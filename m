Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:52412 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750926Ab3HQXKo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Aug 2013 19:10:44 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH STAGING 3/3] msi3101: few improvements for RF tuner
Date: Sun, 18 Aug 2013 02:09:32 +0300
Message-Id: <1376780972-8977-4-git-send-email-crope@iki.fi>
In-Reply-To: <1376780972-8977-1-git-send-email-crope@iki.fi>
References: <1376780972-8977-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

* Fix AM_MODE. Now it could work at least in theory, cannot test.
* Use greatest common divisor algo to divide PLL fractional parts.
* Fix IF frequency mode.
* + some very minor "style" issues

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/staging/media/msi3101/sdr-msi3101.c | 69 +++++++++++++++++------------
 1 file changed, 41 insertions(+), 28 deletions(-)

diff --git a/drivers/staging/media/msi3101/sdr-msi3101.c b/drivers/staging/media/msi3101/sdr-msi3101.c
index 839e601..eebe1d0 100644
--- a/drivers/staging/media/msi3101/sdr-msi3101.c
+++ b/drivers/staging/media/msi3101/sdr-msi3101.c
@@ -29,11 +29,9 @@
  * http://git.linuxtv.org/anttip/gr-kernel.git
  *
  * TODO:
- * I will look these:
- * - split RF tuner and USB ADC interface to own drivers (msi2500 and msi001)
- * - move controls to V4L2 API
- *
  * Help is very highly welcome for these + all the others you could imagine:
+ * - split USB ADC interface and RF tuner to own drivers (msi2500 and msi001)
+ * - move controls to V4L2 API
  * - use libv4l2 for stream format conversions
  * - gr-kernel: switch to v4l2_mmap (current read eats a lot of cpu)
  * - SDRSharp support
@@ -41,6 +39,7 @@
 
 #include <linux/module.h>
 #include <linux/slab.h>
+#include <linux/gcd.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-ctrls.h>
@@ -1331,25 +1330,25 @@ err:
 static int msi3101_set_tuner(struct msi3101_state *s)
 {
 	int ret, i, len;
-	unsigned int n, m, thresh, frac, vco_step, tmp;
+	unsigned int n, m, thresh, frac, vco_step, tmp, f_if1;
 	u32 reg;
 	u64 f_vco;
-	u8 mode, lo_div;
+	u8 mode, filter_mode, lo_div;
 	const struct msi3101_gain *gain_lut;
 	static const struct {
 		u32 rf;
 		u8 mode;
 		u8 lo_div;
 	} band_lut[] = {
-		{ 47000000, 0x01, 16}, /* AM_MODE1 */
-		{108000000, 0x02, 32}, /* VHF_MODE */
-		{330000000, 0x04, 16}, /* B3_MODE */
-		{960000000, 0x08,  4}, /* B45_MODE */
-		{      ~0U, 0x10,  2}, /* BL_MODE */
+		{ 50000000, 0xe1, 16}, /* AM_MODE2, antenna 2 */
+		{108000000, 0x42, 32}, /* VHF_MODE */
+		{330000000, 0x44, 16}, /* B3_MODE */
+		{960000000, 0x48,  4}, /* B45_MODE */
+		{      ~0U, 0x50,  2}, /* BL_MODE */
 	};
 	static const struct {
 		u32 freq;
-		u8 val;
+		u8 filter_mode;
 	} if_freq_lut[] = {
 		{      0, 0x03}, /* Zero IF */
 		{ 450000, 0x02}, /* 450 kHz IF */
@@ -1370,19 +1369,19 @@ static int msi3101_set_tuner(struct msi3101_state *s)
 		{8000000, 0x07}, /* 8 MHz */
 	};
 
-	unsigned int rf_freq = s->ctrl_tuner_rf->val64;
+	unsigned int f_rf = s->ctrl_tuner_rf->val64;
 
 	/*
 	 * bandwidth (Hz)
 	 * 200000, 300000, 600000, 1536000, 5000000, 6000000, 7000000, 8000000
 	 */
-	int bandwidth = s->ctrl_tuner_bw->val;
+	unsigned int bandwidth = s->ctrl_tuner_bw->val;
 
 	/*
 	 * intermediate frequency (Hz)
 	 * 0, 450000, 1620000, 2048000
 	 */
-	int if_freq = s->ctrl_tuner_if->val;
+	unsigned int f_if = s->ctrl_tuner_if->val;
 
 	/*
 	 * gain reduction (dB)
@@ -1392,13 +1391,13 @@ static int msi3101_set_tuner(struct msi3101_state *s)
 	int gain = s->ctrl_tuner_gain->val;
 
 	dev_dbg(&s->udev->dev,
-			"%s: rf_freq=%d bandwidth=%d if_freq=%d gain=%d\n",
-			__func__, rf_freq, bandwidth, if_freq, gain);
+			"%s: f_rf=%d bandwidth=%d f_if=%d gain=%d\n",
+			__func__, f_rf, bandwidth, f_if, gain);
 
 	ret = -EINVAL;
 
 	for (i = 0; i < ARRAY_SIZE(band_lut); i++) {
-		if (rf_freq <= band_lut[i].rf) {
+		if (f_rf <= band_lut[i].rf) {
 			mode = band_lut[i].mode;
 			lo_div = band_lut[i].lo_div;
 			break;
@@ -1408,9 +1407,15 @@ static int msi3101_set_tuner(struct msi3101_state *s)
 	if (i == ARRAY_SIZE(band_lut))
 		goto err;
 
+	/* AM_MODE is upconverted */
+	if ((mode >> 0) & 0x1)
+		f_if1 =  5 * F_REF;
+	else
+		f_if1 =  0;
+
 	for (i = 0; i < ARRAY_SIZE(if_freq_lut); i++) {
-		if (if_freq == if_freq_lut[i].freq) {
-			if_freq = if_freq_lut[i].val;
+		if (f_if == if_freq_lut[i].freq) {
+			filter_mode = if_freq_lut[i].filter_mode;
 			break;
 		}
 	}
@@ -1430,8 +1435,7 @@ static int msi3101_set_tuner(struct msi3101_state *s)
 
 #define F_OUT_STEP 1
 #define R_REF 4
-#define F_IF 0
-	f_vco = (rf_freq + F_IF) * lo_div;
+	f_vco = (f_rf + f_if + f_if1) * lo_div;
 	n = f_vco / (F_REF * R_REF);
 	m = f_vco % (F_REF * R_REF);
 
@@ -1439,7 +1443,12 @@ static int msi3101_set_tuner(struct msi3101_state *s)
 	thresh = (F_REF * R_REF) / vco_step;
 	frac = 1ul * thresh * m / (F_REF * R_REF);
 
-	/* Divide to reg max. After that RF resolution will be +-500Hz. */
+	/* Find out greatest common divisor and divide to smaller. */
+	tmp = gcd(thresh, frac);
+	thresh /= tmp;
+	frac /= tmp;
+
+	/* Force divide to reg max. Resolution will be reduced. */
 	tmp = DIV_ROUND_UP(thresh, 4095);
 	thresh = DIV_ROUND_CLOSEST(thresh, tmp);
 	frac = DIV_ROUND_CLOSEST(frac, tmp);
@@ -1451,15 +1460,19 @@ static int msi3101_set_tuner(struct msi3101_state *s)
 
 	dev_dbg(&s->udev->dev,
 			"%s: rf=%u:%u n=%d thresh=%d frac=%d\n",
-				__func__, rf_freq, tmp, n, thresh, frac);
+				__func__, f_rf, tmp, n, thresh, frac);
 
 	ret = msi3101_tuner_write(s, 0x00000e);
+	if (ret)
+		goto err;
+
 	ret = msi3101_tuner_write(s, 0x000003);
+	if (ret)
+		goto err;
 
 	reg = 0 << 0;
 	reg |= mode << 4;
-	reg |= 1 << 10;
-	reg |= if_freq << 12;
+	reg |= filter_mode << 12;
 	reg |= bandwidth << 14;
 	reg |= 0x02 << 17;
 	reg |= 0x00 << 20;
@@ -1482,10 +1495,10 @@ static int msi3101_set_tuner(struct msi3101_state *s)
 	if (ret)
 		goto err;
 
-	if (rf_freq < 120000000) {
+	if (f_rf < 120000000) {
 		gain_lut = msi3101_gain_lut_120;
 		len = ARRAY_SIZE(msi3101_gain_lut_120);
-	} else if (rf_freq < 245000000) {
+	} else if (f_rf < 245000000) {
 		gain_lut = msi3101_gain_lut_245;
 		len = ARRAY_SIZE(msi3101_gain_lut_120);
 	} else {
-- 
1.7.11.7

