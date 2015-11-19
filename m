Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:54392 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161146AbbKSUFF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Nov 2015 15:05:05 -0500
From: Matthias Schwarzott <zzam@gentoo.org>
To: linux-media@vger.kernel.org
Cc: mchehab@osg.samsung.com, crope@iki.fi, xpert-reactos@gmx.de,
	Matthias Schwarzott <zzam@gentoo.org>
Subject: [PATCH 08/10] si2165: set list of DVB-T registers together
Date: Thu, 19 Nov 2015 21:04:00 +0100
Message-Id: <1447963442-9764-9-git-send-email-zzam@gentoo.org>
In-Reply-To: <1447963442-9764-1-git-send-email-zzam@gentoo.org>
References: <1447963442-9764-1-git-send-email-zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
---
 drivers/media/dvb-frontends/si2165.c | 73 +++++++++++++-----------------------
 1 file changed, 26 insertions(+), 47 deletions(-)

diff --git a/drivers/media/dvb-frontends/si2165.c b/drivers/media/dvb-frontends/si2165.c
index e97b0e6..01c9a19 100644
--- a/drivers/media/dvb-frontends/si2165.c
+++ b/drivers/media/dvb-frontends/si2165.c
@@ -803,6 +803,29 @@ static const struct si2165_reg_value_pair agc_rewrite[] = {
 	{ 0x0123, 0x70 }
 };
 
+static const struct si2165_reg_value_pair dvbt_regs[] = {
+	/* standard = DVB-T */
+	{ 0x00ec, 0x01 },
+	{ 0x08f8, 0x00 },
+	/* impulsive_noise_remover */
+	{ 0x031c, 0x01 },
+	{ 0x00cb, 0x00 },
+	/* agc2 */
+	{ 0x016e, 0x41 },
+	{ 0x016c, 0x0e },
+	{ 0x016d, 0x10 },
+	/* agc */
+	{ 0x015b, 0x03 },
+	{ 0x0150, 0x78 },
+	/* agc */
+	{ 0x01a0, 0x78 },
+	{ 0x01c8, 0x68 },
+	/* freq_sync_range */
+	REG16(0x030c, 0x0064),
+	/* gp_reg0 */
+	{ 0x0387, 0x00 }
+};
+
 static int si2165_set_frontend(struct dvb_frontend *fe)
 {
 	int ret;
@@ -824,10 +847,6 @@ static int si2165_set_frontend(struct dvb_frontend *fe)
 	dvb_rate = bw_hz * 8 / 7;
 	bw10k = bw_hz / 10000;
 
-	/* standard = DVB-T */
-	ret = si2165_writereg8(state, 0x00ec, 0x01);
-	if (ret < 0)
-		return ret;
 	ret = si2165_adjust_pll_divl(state, 12);
 	if (ret < 0)
 		return ret;
@@ -835,9 +854,6 @@ static int si2165_set_frontend(struct dvb_frontend *fe)
 	ret = si2165_set_if_freq_shift(state);
 	if (ret < 0)
 		return ret;
-	ret = si2165_writereg8(state, 0x08f8, 0x00);
-	if (ret < 0)
-		return ret;
 	/* bandwidth in 10KHz steps */
 	ret = si2165_writereg16(state, 0x0308, bw10k);
 	if (ret < 0)
@@ -845,48 +861,11 @@ static int si2165_set_frontend(struct dvb_frontend *fe)
 	ret = si2165_set_oversamp(state, dvb_rate);
 	if (ret < 0)
 		return ret;
-	/* impulsive_noise_remover */
-	ret = si2165_writereg8(state, 0x031c, 0x01);
-	if (ret < 0)
-		return ret;
-	ret = si2165_writereg8(state, 0x00cb, 0x00);
-	if (ret < 0)
-		return ret;
-	/* agc2 */
-	ret = si2165_writereg8(state, 0x016e, 0x41);
-	if (ret < 0)
-		return ret;
-	ret = si2165_writereg8(state, 0x016c, 0x0e);
-	if (ret < 0)
-		return ret;
-	ret = si2165_writereg8(state, 0x016d, 0x10);
-	if (ret < 0)
-		return ret;
-	/* agc */
-	ret = si2165_writereg8(state, 0x015b, 0x03);
-	if (ret < 0)
-		return ret;
-	ret = si2165_writereg8(state, 0x0150, 0x78);
-	if (ret < 0)
-		return ret;
-	/* agc */
-	ret = si2165_writereg8(state, 0x01a0, 0x78);
-	if (ret < 0)
-		return ret;
-	ret = si2165_writereg8(state, 0x01c8, 0x68);
-	if (ret < 0)
-		return ret;
-	/* freq_sync_range */
-	ret = si2165_writereg16(state, 0x030c, 0x0064);
-	if (ret < 0)
-		return ret;
-	/* gp_reg0 */
-	ret = si2165_readreg8(state, 0x0387, val);
-	if (ret < 0)
-		return ret;
-	ret = si2165_writereg8(state, 0x0387, 0x00);
+
+	ret = si2165_write_reg_list(state, dvbt_regs, ARRAY_SIZE(dvbt_regs));
 	if (ret < 0)
 		return ret;
+
 	/* dsp_addr_jump */
 	ret = si2165_writereg32(state, 0x0348, 0xf4000000);
 	if (ret < 0)
-- 
2.6.3

