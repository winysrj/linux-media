Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:58873 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752084AbbEEVmL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 5 May 2015 17:42:11 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 3/4] msi2500: revise synthesizer calculation
Date: Wed,  6 May 2015 00:42:01 +0300
Message-Id: <1430862122-9326-3-git-send-email-crope@iki.fi>
In-Reply-To: <1430862122-9326-1-git-send-email-crope@iki.fi>
References: <1430862122-9326-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Update synthesizer calculation to model I prefer nowadays. It is mostly
just renaming some variables, but also minor functionality change how
integer and fractional part are divided (using div_u64_rem()). Also, add
'schematic' of synthesizer following my current understanding.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/msi2500/msi2500.c | 49 +++++++++++++++++++++++++------------
 1 file changed, 34 insertions(+), 15 deletions(-)

diff --git a/drivers/media/usb/msi2500/msi2500.c b/drivers/media/usb/msi2500/msi2500.c
index efc761c..8605b96 100644
--- a/drivers/media/usb/msi2500/msi2500.c
+++ b/drivers/media/usb/msi2500/msi2500.c
@@ -682,11 +682,10 @@ static int msi2500_ctrl_msg(struct msi2500_state *s, u8 cmd, u32 data)
 	return ret;
 }
 
-#define F_REF 24000000
-#define DIV_R_IN 2
 static int msi2500_set_usb_adc(struct msi2500_state *s)
 {
-	int ret, div_n, div_m, div_r_out, f_sr, f_vco, fract;
+	int ret;
+	unsigned int f_vco, f_sr, div_n, k, k_cw, div_out;
 	u32 reg3, reg4, reg7;
 	struct v4l2_ctrl *bandwidth_auto;
 	struct v4l2_ctrl *bandwidth;
@@ -728,6 +727,21 @@ static int msi2500_set_usb_adc(struct msi2500_state *s)
 	}
 
 	/*
+	 * Fractional-N synthesizer
+	 *
+	 *           +----------------------------------------+
+	 *           v                                        |
+	 *  Fref   +----+     +-------+     +-----+         +------+     +---+
+	 * ------> | PD | --> |  VCO  | --> | /2  | ------> | /N.F | <-- | K |
+	 *         +----+     +-------+     +-----+         +------+     +---+
+	 *                      |
+	 *                      |
+	 *                      v
+	 *                    +-------+     +-----+  Fout
+	 *                    | /Rout | --> | /12 | ------>
+	 *                    +-------+     +-----+
+	 */
+	/*
 	 * Synthesizer config is just a educated guess...
 	 *
 	 * [7:0]   0x03, register address
@@ -754,10 +768,14 @@ static int msi2500_set_usb_adc(struct msi2500_state *s)
 	 *
 	 * VCO 202000000 - 720000000++
 	 */
+
+	#define F_REF 24000000
+	#define DIV_PRE_N 2
+	#define DIV_LO_OUT 12
 	reg3 = 0x01000303;
 	reg4 = 0x00000004;
 
-	/* XXX: Filters? AGC? */
+	/* XXX: Filters? AGC? VCO band? */
 	if (f_sr < 6000000)
 		reg3 |= 0x1 << 20;
 	else if (f_sr < 7000000)
@@ -767,24 +785,25 @@ static int msi2500_set_usb_adc(struct msi2500_state *s)
 	else
 		reg3 |= 0xd << 20;
 
-	for (div_r_out = 4; div_r_out < 16; div_r_out += 2) {
-		f_vco = f_sr * div_r_out * 12;
-		dev_dbg(s->dev, "div_r_out=%d f_vco=%d\n", div_r_out, f_vco);
+	for (div_out = 4; div_out < 16; div_out += 2) {
+		f_vco = f_sr * div_out * DIV_LO_OUT;
+		dev_dbg(s->dev, "div_out=%d f_vco=%d\n", div_out, f_vco);
 		if (f_vco >= 202000000)
 			break;
 	}
 
-	div_n = f_vco / (F_REF * DIV_R_IN);
-	div_m = f_vco % (F_REF * DIV_R_IN);
-	fract = 0x200000ul * div_m / (F_REF * DIV_R_IN);
+	/* Calculate PLL integer and fractional control word. */
+	div_n = div_u64_rem(f_vco, DIV_PRE_N * F_REF, &k);
+	k_cw = div_u64((u64) k * 0x200000, DIV_PRE_N * F_REF);
 
 	reg3 |= div_n << 16;
-	reg3 |= (div_r_out / 2 - 1) << 10;
-	reg3 |= ((fract >> 20) & 0x000001) << 15; /* [20] */
-	reg4 |= ((fract >>  0) & 0x0fffff) <<  8; /* [19:0] */
+	reg3 |= (div_out / 2 - 1) << 10;
+	reg3 |= ((k_cw >> 20) & 0x000001) << 15; /* [20] */
+	reg4 |= ((k_cw >>  0) & 0x0fffff) <<  8; /* [19:0] */
 
-	dev_dbg(s->dev, "f_sr=%d f_vco=%d div_n=%d div_m=%d div_r_out=%d reg3=%08x reg4=%08x\n",
-			f_sr, f_vco, div_n, div_m, div_r_out, reg3, reg4);
+	dev_dbg(s->dev,
+		"f_sr=%u f_vco=%u div_n=%u k=%u div_out=%u reg3=%08x reg4=%08x\n",
+		f_sr, f_vco, div_n, k, div_out, reg3, reg4);
 
 	ret = msi2500_ctrl_msg(s, CMD_WREG, 0x00608008);
 	if (ret)
-- 
http://palosaari.fi/

