Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:54398 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161169AbbKSUFG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Nov 2015 15:05:06 -0500
From: Matthias Schwarzott <zzam@gentoo.org>
To: linux-media@vger.kernel.org
Cc: mchehab@osg.samsung.com, crope@iki.fi, xpert-reactos@gmx.de,
	Matthias Schwarzott <zzam@gentoo.org>
Subject: [PATCH 09/10] si2165: Prepare si2165_set_frontend for splitting
Date: Thu, 19 Nov 2015 21:04:01 +0100
Message-Id: <1447963442-9764-10-git-send-email-zzam@gentoo.org>
In-Reply-To: <1447963442-9764-1-git-send-email-zzam@gentoo.org>
References: <1447963442-9764-1-git-send-email-zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
---
 drivers/media/dvb-frontends/si2165.c | 51 ++++++++++++++++++++++++++----------
 1 file changed, 37 insertions(+), 14 deletions(-)

diff --git a/drivers/media/dvb-frontends/si2165.c b/drivers/media/dvb-frontends/si2165.c
index 01c9a19..131aef1 100644
--- a/drivers/media/dvb-frontends/si2165.c
+++ b/drivers/media/dvb-frontends/si2165.c
@@ -760,7 +760,7 @@ static int si2165_set_oversamp(struct si2165_state *state, u32 dvb_rate)
 	do_div(oversamp, dvb_rate);
 	reg_value = oversamp & 0x3fffffff;
 
-	/* oversamp, usbdump contained 0x03100000; */
+	dprintk("%s: Write oversamp=%#x\n", __func__, reg_value);
 	return si2165_writereg32(state, 0x00e4, reg_value);
 }
 
@@ -795,14 +795,6 @@ static int si2165_set_if_freq_shift(struct si2165_state *state)
 	return si2165_writereg32(state, 0x00e8, reg_value);
 }
 
-static const struct si2165_reg_value_pair agc_rewrite[] = {
-	{ 0x012a, 0x46 },
-	{ 0x012c, 0x00 },
-	{ 0x012e, 0x0a },
-	{ 0x012f, 0xff },
-	{ 0x0123, 0x70 }
-};
-
 static const struct si2165_reg_value_pair dvbt_regs[] = {
 	/* standard = DVB-T */
 	{ 0x00ec, 0x01 },
@@ -826,12 +818,11 @@ static const struct si2165_reg_value_pair dvbt_regs[] = {
 	{ 0x0387, 0x00 }
 };
 
-static int si2165_set_frontend(struct dvb_frontend *fe)
+static int si2165_set_frontend_dvbt(struct dvb_frontend *fe)
 {
 	int ret;
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct si2165_state *state = fe->demodulator_priv;
-	u8 val[3];
 	u32 dvb_rate = 0;
 	u16 bw10k;
 	u32 bw_hz = p->bandwidth_hz;
@@ -851,9 +842,6 @@ static int si2165_set_frontend(struct dvb_frontend *fe)
 	if (ret < 0)
 		return ret;
 
-	ret = si2165_set_if_freq_shift(state);
-	if (ret < 0)
-		return ret;
 	/* bandwidth in 10KHz steps */
 	ret = si2165_writereg16(state, 0x0308, bw10k);
 	if (ret < 0)
@@ -866,6 +854,40 @@ static int si2165_set_frontend(struct dvb_frontend *fe)
 	if (ret < 0)
 		return ret;
 
+	return 0;
+}
+
+static const struct si2165_reg_value_pair agc_rewrite[] = {
+	{ 0x012a, 0x46 },
+	{ 0x012c, 0x00 },
+	{ 0x012e, 0x0a },
+	{ 0x012f, 0xff },
+	{ 0x0123, 0x70 }
+};
+
+static int si2165_set_frontend(struct dvb_frontend *fe)
+{
+	struct si2165_state *state = fe->demodulator_priv;
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
+	u32 delsys = p->delivery_system;
+	int ret;
+	u8 val[3];
+
+	/* initial setting of if freq shift */
+	ret = si2165_set_if_freq_shift(state);
+	if (ret < 0)
+		return ret;
+
+	switch (delsys) {
+	case SYS_DVBT:
+		ret = si2165_set_frontend_dvbt(fe);
+		if (ret < 0)
+			return ret;
+		break;
+	default:
+		return -EINVAL;
+	}
+
 	/* dsp_addr_jump */
 	ret = si2165_writereg32(state, 0x0348, 0xf4000000);
 	if (ret < 0)
@@ -886,6 +908,7 @@ static int si2165_set_frontend(struct dvb_frontend *fe)
 	ret = si2165_writereg8(state, 0x0341, 0x00);
 	if (ret < 0)
 		return ret;
+
 	/* reset all */
 	ret = si2165_writereg8(state, 0x00c0, 0x00);
 	if (ret < 0)
-- 
2.6.3

