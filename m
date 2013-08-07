Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:36424 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932727Ab3HGSxS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 7 Aug 2013 14:53:18 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 03/16] msi3101: fix sampling rate calculation
Date: Wed,  7 Aug 2013 21:51:34 +0300
Message-Id: <1375901507-26661-4-git-send-email-crope@iki.fi>
In-Reply-To: <1375901507-26661-1-git-send-email-crope@iki.fi>
References: <1375901507-26661-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These calculations seems to give 100% correct results. Calculation
formulas could be still a little bit wrong as I have no knowledge
what kind of dividers, multipliers and VCO limits there really is.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/staging/media/msi3101/sdr-msi3101.c | 58 +++++++++++++++--------------
 1 file changed, 31 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/media/msi3101/sdr-msi3101.c b/drivers/staging/media/msi3101/sdr-msi3101.c
index 87896ee..4de4f50 100644
--- a/drivers/staging/media/msi3101/sdr-msi3101.c
+++ b/drivers/staging/media/msi3101/sdr-msi3101.c
@@ -960,16 +960,14 @@ static int msi3101_tuner_write(struct msi3101_state *s, u32 data)
 };
 
 #define F_REF 24000000
+#define DIV_R_IN 2
 static int msi3101_set_usb_adc(struct msi3101_state *s)
 {
-	int ret, div_n, div_m, div_r_out, f_sr;
+	int ret, div_n, div_m, div_r_out, f_sr, f_vco;
 	u32 reg4, reg3;
 	/*
-	 * FIXME: Synthesizer config is just a educated guess...
-	 * It seems to give reasonable values when N is 5-12 and output
-	 * divider R is 2, which means sampling rates 5-12 Msps in practise.
+	 * Synthesizer config is just a educated guess...
 	 *
-	 * reg 3 ADC synthesizer config
 	 * [7:0]   0x03, register address
 	 * [8]     1, always
 	 * [9]     ?
@@ -984,42 +982,48 @@ static int msi3101_set_usb_adc(struct msi3101_state *s)
 	 * output divider
 	 * val   div
 	 *   0     - (invalid)
-	 *   1     2
-	 *   2     3
-	 *   3     4
-	 *   4     5
-	 *   5     6
-	 *   6     7
-	 *   7     8
+	 *   1     4
+	 *   2     6
+	 *   3     8
+	 *   4    10
+	 *   5    12
+	 *   6    14
+	 *   7    16
+	 *
+	 * VCO 202000000 - 720000000++
 	 */
 
 	f_sr = s->ctrl_sampling_rate->val64;
 	reg3 = 0x01c00303;
 
-	for (div_n = 12; div_n > 5; div_n--) {
-		if (f_sr >= div_n * 1000000)
+	for (div_r_out = 4; div_r_out < 16; div_r_out += 2) {
+		f_vco = f_sr * div_r_out * 12;
+		dev_dbg(&s->udev->dev, "%s: div_r_out=%d f_vco=%d\n",
+				__func__, div_r_out, f_vco);
+		if (f_vco >= 202000000)
 			break;
 	}
 
-	reg3 |= div_n << 16;
-
-	for (div_r_out = 2; div_r_out < 8; div_r_out++) {
-		if (f_sr >= div_n * F_REF / div_r_out / 12)
-			break;
-	}
+	div_n = f_vco / (F_REF * DIV_R_IN);
+	div_m = f_vco % (F_REF * DIV_R_IN);
 
-	reg3 |= (div_r_out - 1) << 10;
-	div_m = f_sr % (div_n * F_REF / div_r_out / 12);
+	reg3 |= div_n << 16;
+	reg3 |= (div_r_out / 2 - 1) << 10;
+	reg4 = 0x0ffffful * div_m / F_REF;
 
-	if (div_m >= 500000) {
+	if (reg4 >= 0x0ffffful) {
+		dev_dbg(&s->udev->dev,
+				"%s: extending fractional part value %08x\n",
+				__func__, reg4);
+		reg4 -= 0x0ffffful;
 		reg3 |= 1 << 15;
-		div_m -= 500000;
 	}
 
-	reg4 = ((div_m * 0x0ffffful / 500000) << 8) | 0x04;
+	reg4 = (reg4 << 8) | 0x04;
 
-	dev_dbg(&s->udev->dev, "%s: sr=%d n=%d m=%d r_out=%d reg4=%08x\n",
-			__func__, f_sr, div_n, div_m, div_r_out, reg4);
+	dev_dbg(&s->udev->dev,
+			"%s: f_sr=%d f_vco=%d div_n=%d div_m=%d div_r_out=%d reg4=%08x\n",
+			__func__, f_sr, f_vco, div_n, div_m, div_r_out, reg4);
 
 	ret = msi3101_ctrl_msg(s, CMD_WREG, 0x00608008);
 	if (ret)
-- 
1.7.11.7

