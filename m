Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:57184 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932966Ab3HGSxS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 7 Aug 2013 14:53:18 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 10/16] msi3101: improve tuner synth calc step size
Date: Wed,  7 Aug 2013 21:51:41 +0300
Message-Id: <1375901507-26661-11-git-send-email-crope@iki.fi>
In-Reply-To: <1375901507-26661-1-git-send-email-crope@iki.fi>
References: <1375901507-26661-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Allow stepless synthesizer configuration. With that change we lose
precision a little bit, as it is now between +-500Hz from the target.
It could be better but on that case calculation algorithm goes more
complex and atm there is more important things to do.

Two approach to improve which comes to my mind are:
1) select and use biggest suitable step
2) use greatest common divisor algo to find divisor for thresh & frac
when possible to avoid rounding errors, which is root of cause of
current +-500Hz inaccuracy.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/staging/media/msi3101/sdr-msi3101.c | 44 ++++++++++++++++++-----------
 1 file changed, 27 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/media/msi3101/sdr-msi3101.c b/drivers/staging/media/msi3101/sdr-msi3101.c
index 04bbbdf..4ff6030 100644
--- a/drivers/staging/media/msi3101/sdr-msi3101.c
+++ b/drivers/staging/media/msi3101/sdr-msi3101.c
@@ -1079,9 +1079,10 @@ err:
 
 static int msi3101_set_tuner(struct msi3101_state *s)
 {
-	int i, ret, len;
-	u32 reg, synthstep, thresh, n, frac;
-	u64 fsynth;
+	int ret, i, len;
+	unsigned int n, m, thresh, frac, vco_step, tmp;
+	u32 reg;
+	u64 f_vco;
 	u8 mode, lo_div;
 	const struct msi3101_gain *gain_lut;
 	static const struct {
@@ -1176,21 +1177,30 @@ static int msi3101_set_tuner(struct msi3101_state *s)
 	if (i == ARRAY_SIZE(bandwidth_lut))
 		goto err;
 
-	#define FSTEP 10000
-	#define FREF1 24000000
-	fsynth = (rf_freq + 0) * lo_div;
-	synthstep = FSTEP * lo_div;
-	thresh = (FREF1 * 4) / synthstep;
-	n = fsynth / (FREF1 * 4);
-	frac = thresh * (fsynth % (FREF1 * 4)) / (FREF1 * 4);
+#define F_OUT_STEP 1
+#define R_REF 4
+#define F_IF 0
+	f_vco = (rf_freq + F_IF) * lo_div;
+	n = f_vco / (F_REF * R_REF);
+	m = f_vco % (F_REF * R_REF);
 
-	if (thresh > 4095 || n > 63 || frac > 4095) {
-		dev_dbg(&s->udev->dev,
-				"%s: synth setup failed rf=%d thresh=%d n=%d frac=%d\n",
-				__func__, rf_freq, thresh, n, frac);
-		ret = -EINVAL;
-		goto err;
-	}
+	vco_step = F_OUT_STEP * lo_div;
+	thresh = (F_REF * R_REF) / vco_step;
+	frac = 1ul * thresh * m / (F_REF * R_REF);
+
+	/* Divide to reg max. After that RF resolution will be +-500Hz. */
+	tmp = DIV_ROUND_UP(thresh, 4095);
+	thresh = DIV_ROUND_CLOSEST(thresh, tmp);
+	frac = DIV_ROUND_CLOSEST(frac, tmp);
+
+	/* calc real RF set */
+	tmp = 1ul * F_REF * R_REF * n;
+	tmp += 1ul * F_REF * R_REF * frac / thresh;
+	tmp /= lo_div;
+
+	dev_dbg(&s->udev->dev,
+			"%s: rf=%u:%u n=%d thresh=%d frac=%d\n",
+				__func__, rf_freq, tmp, n, thresh, frac);
 
 	ret = msi3101_tuner_write(s, 0x00000e);
 	ret = msi3101_tuner_write(s, 0x000003);
-- 
1.7.11.7

