Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:54405 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161180AbbKSUFI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Nov 2015 15:05:08 -0500
From: Matthias Schwarzott <zzam@gentoo.org>
To: linux-media@vger.kernel.org
Cc: mchehab@osg.samsung.com, crope@iki.fi, xpert-reactos@gmx.de,
	Matthias Schwarzott <zzam@gentoo.org>
Subject: [PATCH 10/10] si2165: Add DVB-C support for HVR-4400/HVR-5500
Date: Thu, 19 Nov 2015 21:04:02 +0100
Message-Id: <1447963442-9764-11-git-send-email-zzam@gentoo.org>
In-Reply-To: <1447963442-9764-1-git-send-email-zzam@gentoo.org>
References: <1447963442-9764-1-git-send-email-zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It works only for HVR-4400/HVR-5500.
For WinTV-HVR-930C-HD it fails with bad/no reception
for unknown reasons.

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
---
 drivers/media/dvb-frontends/si2165.c | 86 +++++++++++++++++++++++++++++++++---
 1 file changed, 81 insertions(+), 5 deletions(-)

diff --git a/drivers/media/dvb-frontends/si2165.c b/drivers/media/dvb-frontends/si2165.c
index 131aef1..dd4503a 100644
--- a/drivers/media/dvb-frontends/si2165.c
+++ b/drivers/media/dvb-frontends/si2165.c
@@ -857,6 +857,71 @@ static int si2165_set_frontend_dvbt(struct dvb_frontend *fe)
 	return 0;
 }
 
+static const struct si2165_reg_value_pair dvbc_regs[] = {
+	/* standard = DVB-C */
+	{ 0x00ec, 0x05 },
+	{ 0x08f8, 0x00 },
+
+	/* agc2 */
+	{ 0x016e, 0x50 },
+	{ 0x016c, 0x0e },
+	{ 0x016d, 0x10 },
+	/* agc */
+	{ 0x015b, 0x03 },
+	{ 0x0150, 0x68 },
+	/* agc */
+	{ 0x01a0, 0x68 },
+	{ 0x01c8, 0x50 },
+
+	{ 0x0278, 0x0d },
+
+	{ 0x023a, 0x05 },
+	{ 0x0261, 0x09 },
+	REG16(0x0350, 0x3e80),
+	{ 0x02f4, 0x00 },
+
+	{ 0x00cb, 0x01 },
+	REG16(0x024c, 0x0000),
+	REG16(0x027c, 0x0000),
+	{ 0x0232, 0x03 },
+	{ 0x02f4, 0x0b },
+	{ 0x018b, 0x00 },
+};
+
+static int si2165_set_frontend_dvbc(struct dvb_frontend *fe)
+{
+	struct si2165_state *state = fe->demodulator_priv;
+	int ret;
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
+	const u32 dvb_rate = p->symbol_rate;
+	const u32 bw_hz = p->bandwidth_hz;
+
+	if (!state->has_dvbc)
+		return -EINVAL;
+
+	if (dvb_rate == 0)
+		return -EINVAL;
+
+	ret = si2165_adjust_pll_divl(state, 14);
+	if (ret < 0)
+		return ret;
+
+	/* Oversampling */
+	ret = si2165_set_oversamp(state, dvb_rate);
+	if (ret < 0)
+		return ret;
+
+	ret = si2165_writereg32(state, 0x00c4, bw_hz);
+	if (ret < 0)
+		return ret;
+
+	ret = si2165_write_reg_list(state, dvbc_regs, ARRAY_SIZE(dvbc_regs));
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
 static const struct si2165_reg_value_pair agc_rewrite[] = {
 	{ 0x012a, 0x46 },
 	{ 0x012c, 0x00 },
@@ -884,6 +949,11 @@ static int si2165_set_frontend(struct dvb_frontend *fe)
 		if (ret < 0)
 			return ret;
 		break;
+	case SYS_DVBC_ANNEX_A:
+		ret = si2165_set_frontend_dvbc(fe);
+		if (ret < 0)
+			return ret;
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -947,7 +1017,12 @@ static void si2165_release(struct dvb_frontend *fe)
 static struct dvb_frontend_ops si2165_ops = {
 	.info = {
 		.name = "Silicon Labs ",
-		.caps =	FE_CAN_FEC_1_2 |
+		 /* For DVB-C */
+		.symbol_rate_min = 1000000,
+		.symbol_rate_max = 7200000,
+		/* For DVB-T */
+		.frequency_stepsize = 166667,
+		.caps = FE_CAN_FEC_1_2 |
 			FE_CAN_FEC_2_3 |
 			FE_CAN_FEC_3_4 |
 			FE_CAN_FEC_5_6 |
@@ -960,7 +1035,6 @@ static struct dvb_frontend_ops si2165_ops = {
 			FE_CAN_QAM_128 |
 			FE_CAN_QAM_256 |
 			FE_CAN_QAM_AUTO |
-			FE_CAN_TRANSMISSION_MODE_AUTO |
 			FE_CAN_GUARD_INTERVAL_AUTO |
 			FE_CAN_HIERARCHY_AUTO |
 			FE_CAN_MUTE_TS |
@@ -1072,9 +1146,11 @@ struct dvb_frontend *si2165_attach(const struct si2165_config *config,
 		strlcat(state->fe.ops.info.name, " DVB-T",
 			sizeof(state->fe.ops.info.name));
 	}
-	if (state->has_dvbc)
-		dev_warn(&state->i2c->dev, "%s: DVB-C is not yet supported.\n",
-		       KBUILD_MODNAME);
+	if (state->has_dvbc) {
+		state->fe.ops.delsys[n++] = SYS_DVBC_ANNEX_A;
+		strlcat(state->fe.ops.info.name, " DVB-C",
+			sizeof(state->fe.ops.info.name));
+	}
 
 	return &state->fe;
 
-- 
2.6.3

