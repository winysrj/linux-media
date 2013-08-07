Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:58189 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932858Ab3HGSxS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 7 Aug 2013 14:53:18 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 09/16] msi3101: correct ADC sampling rate calc a little
Date: Wed,  7 Aug 2013 21:51:40 +0300
Message-Id: <1375901507-26661-10-git-send-email-crope@iki.fi>
In-Reply-To: <1375901507-26661-1-git-send-email-crope@iki.fi>
References: <1375901507-26661-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/staging/media/msi3101/sdr-msi3101.c | 23 ++++++++---------------
 1 file changed, 8 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/media/msi3101/sdr-msi3101.c b/drivers/staging/media/msi3101/sdr-msi3101.c
index 2b73fc1..04bbbdf 100644
--- a/drivers/staging/media/msi3101/sdr-msi3101.c
+++ b/drivers/staging/media/msi3101/sdr-msi3101.c
@@ -987,7 +987,7 @@ static int msi3101_tuner_write(struct msi3101_state *s, u32 data)
 #define DIV_R_IN 2
 static int msi3101_set_usb_adc(struct msi3101_state *s)
 {
-	int ret, div_n, div_m, div_r_out, f_sr, f_vco;
+	int ret, div_n, div_m, div_r_out, f_sr, f_vco, fract;
 	u32 reg4, reg3;
 	/*
 	 * Synthesizer config is just a educated guess...
@@ -998,7 +998,7 @@ static int msi3101_set_usb_adc(struct msi3101_state *s)
 	 * [12:10] output divider
 	 * [13]    0 ?
 	 * [14]    0 ?
-	 * [15]    increase sr by max fract
+	 * [15]    fractional MSB, bit 20
 	 * [16:19] N
 	 * [23:20] ?
 	 * [24:31] 0x01
@@ -1019,6 +1019,7 @@ static int msi3101_set_usb_adc(struct msi3101_state *s)
 
 	f_sr = s->ctrl_sampling_rate->val64;
 	reg3 = 0x01c00303;
+	reg4 = 0x00000004;
 
 	for (div_r_out = 4; div_r_out < 16; div_r_out += 2) {
 		f_vco = f_sr * div_r_out * 12;
@@ -1030,24 +1031,16 @@ static int msi3101_set_usb_adc(struct msi3101_state *s)
 
 	div_n = f_vco / (F_REF * DIV_R_IN);
 	div_m = f_vco % (F_REF * DIV_R_IN);
+	fract = 0x200000ul * div_m / (F_REF * DIV_R_IN);
 
 	reg3 |= div_n << 16;
 	reg3 |= (div_r_out / 2 - 1) << 10;
-	reg4 = 0x0ffffful * div_m / F_REF;
-
-	if (reg4 >= 0x0ffffful) {
-		dev_dbg(&s->udev->dev,
-				"%s: extending fractional part value %08x\n",
-				__func__, reg4);
-		reg4 -= 0x0ffffful;
-		reg3 |= 1 << 15;
-	}
-
-	reg4 = (reg4 << 8) | 0x04;
+	reg3 |= ((fract >> 20) & 0x000001) << 15; /* [20] */
+	reg4 |= ((fract >>  0) & 0x0fffff) <<  8; /* [19:0] */
 
 	dev_dbg(&s->udev->dev,
-			"%s: f_sr=%d f_vco=%d div_n=%d div_m=%d div_r_out=%d reg4=%08x\n",
-			__func__, f_sr, f_vco, div_n, div_m, div_r_out, reg4);
+			"%s: f_sr=%d f_vco=%d div_n=%d div_m=%d div_r_out=%d reg3=%08x reg4=%08x\n",
+			__func__, f_sr, f_vco, div_n, div_m, div_r_out, reg3, reg4);
 
 	ret = msi3101_ctrl_msg(s, CMD_WREG, 0x00608008);
 	if (ret)
-- 
1.7.11.7

