Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:44660 "EHLO smtp.gentoo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751097AbdKEOZU (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 5 Nov 2017 09:25:20 -0500
From: Matthias Schwarzott <zzam@gentoo.org>
To: mchehab@kernel.org, linux-media@vger.kernel.org
Cc: Matthias Schwarzott <zzam@gentoo.org>
Subject: [PATCH 05/15] si2165: move ts parallel mode setting to the ts init code
Date: Sun,  5 Nov 2017 15:25:01 +0100
Message-Id: <20171105142511.16563-5-zzam@gentoo.org>
In-Reply-To: <20171105142511.16563-1-zzam@gentoo.org>
References: <20171105142511.16563-1-zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The TS parallel mode setting should be where all other TS settings are written.

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
---
 drivers/media/dvb-frontends/si2165.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/si2165.c b/drivers/media/dvb-frontends/si2165.c
index 0f5325798bd2..b2541c1fe554 100644
--- a/drivers/media/dvb-frontends/si2165.c
+++ b/drivers/media/dvb-frontends/si2165.c
@@ -621,6 +621,9 @@ static int si2165_init(struct dvb_frontend *fe)
 	if (ret < 0)
 		return ret;
 	ret = si2165_writereg8(state, REG_TS_CLK_MODE, 0x01);
+	if (ret < 0)
+		return ret;
+	ret = si2165_writereg8(state, REG_TS_PARALLEL_MODE, 0x00);
 	if (ret < 0)
 		return ret;
 
@@ -723,7 +726,6 @@ static int si2165_set_if_freq_shift(struct si2165_state *state)
 static const struct si2165_reg_value_pair dvbt_regs[] = {
 	/* standard = DVB-T */
 	{ REG_DVB_STANDARD, 0x01 },
-	{ REG_TS_PARALLEL_MODE, 0x00 },
 	/* impulsive_noise_remover */
 	{ REG_IMPULSIVE_NOISE_REM, 0x01 },
 	{ REG_AUTO_RESET, 0x00 },
@@ -786,7 +788,6 @@ static int si2165_set_frontend_dvbt(struct dvb_frontend *fe)
 static const struct si2165_reg_value_pair dvbc_regs[] = {
 	/* standard = DVB-C */
 	{ REG_DVB_STANDARD, 0x05 },
-	{ REG_TS_PARALLEL_MODE, 0x00 },
 
 	/* agc2 */
 	{ REG_AGC2_MIN, 0x50 },
-- 
2.15.0
