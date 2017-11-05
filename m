Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:44678 "EHLO smtp.gentoo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751141AbdKEOZY (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 5 Nov 2017 09:25:24 -0500
From: Matthias Schwarzott <zzam@gentoo.org>
To: mchehab@kernel.org, linux-media@vger.kernel.org
Cc: Matthias Schwarzott <zzam@gentoo.org>
Subject: [PATCH 08/15] si2165: Use constellation from property cache instead of hardcoded QAM256
Date: Sun,  5 Nov 2017 15:25:04 +0100
Message-Id: <20171105142511.16563-8-zzam@gentoo.org>
In-Reply-To: <20171105142511.16563-1-zzam@gentoo.org>
References: <20171105142511.16563-1-zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use constellation from property cache instead of always setting it to
QAM256.

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
---
 drivers/media/dvb-frontends/si2165.c | 29 ++++++++++++++++++++++++++---
 1 file changed, 26 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb-frontends/si2165.c b/drivers/media/dvb-frontends/si2165.c
index 0b801bad5802..30ceba664f5f 100644
--- a/drivers/media/dvb-frontends/si2165.c
+++ b/drivers/media/dvb-frontends/si2165.c
@@ -834,13 +834,11 @@ static const struct si2165_reg_value_pair dvbc_regs[] = {
 	{ REG_KP_LOCK, 0x05 },
 	{ REG_CENTRAL_TAP, 0x09 },
 	REG16(REG_UNKNOWN_350, 0x3e80),
-	{ REG_REQ_CONSTELLATION, 0x00 },
 
 	{ REG_AUTO_RESET, 0x01 },
 	REG16(REG_UNKNOWN_24C, 0x0000),
 	REG16(REG_UNKNOWN_27C, 0x0000),
 	{ REG_SWEEP_STEP, 0x03 },
-	{ REG_REQ_CONSTELLATION, 0x0b },
 	{ REG_AGC_IF_TRI, 0x00 },
 };
 
@@ -850,6 +848,7 @@ static int si2165_set_frontend_dvbc(struct dvb_frontend *fe)
 	int ret;
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	const u32 dvb_rate = p->symbol_rate;
+	u8 u8tmp;
 
 	if (!state->has_dvbc)
 		return -EINVAL;
@@ -866,6 +865,31 @@ static int si2165_set_frontend_dvbc(struct dvb_frontend *fe)
 	if (ret < 0)
 		return ret;
 
+	switch (p->modulation) {
+	case QPSK:
+		u8tmp = 0x3;
+		break;
+	case QAM_16:
+		u8tmp = 0x7;
+		break;
+	case QAM_32:
+		u8tmp = 0x8;
+		break;
+	case QAM_64:
+		u8tmp = 0x9;
+		break;
+	case QAM_128:
+		u8tmp = 0xa;
+		break;
+	case QAM_256:
+	default:
+		u8tmp = 0xb;
+		break;
+	}
+	ret = si2165_writereg8(state, REG_REQ_CONSTELLATION, u8tmp);
+	if (ret < 0)
+		return ret;
+
 	ret = si2165_writereg32(state, REG_LOCK_TIMEOUT, 0x007a1200);
 	if (ret < 0)
 		return ret;
@@ -981,7 +1005,6 @@ static const struct dvb_frontend_ops si2165_ops = {
 			FE_CAN_QAM_64 |
 			FE_CAN_QAM_128 |
 			FE_CAN_QAM_256 |
-			FE_CAN_QAM_AUTO |
 			FE_CAN_GUARD_INTERVAL_AUTO |
 			FE_CAN_HIERARCHY_AUTO |
 			FE_CAN_MUTE_TS |
-- 
2.15.0
