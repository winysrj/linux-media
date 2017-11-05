Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:44702 "EHLO smtp.gentoo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751307AbdKEOZa (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 5 Nov 2017 09:25:30 -0500
From: Matthias Schwarzott <zzam@gentoo.org>
To: mchehab@kernel.org, linux-media@vger.kernel.org
Cc: Matthias Schwarzott <zzam@gentoo.org>
Subject: [PATCH 12/15] si2165: add DVBv5 BER statistics
Date: Sun,  5 Nov 2017 15:25:08 +0100
Message-Id: <20171105142511.16563-12-zzam@gentoo.org>
In-Reply-To: <20171105142511.16563-1-zzam@gentoo.org>
References: <20171105142511.16563-1-zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for BER statistics.
Configure a measurement period of 30000 packets.

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
---
 drivers/media/dvb-frontends/si2165.c      | 57 +++++++++++++++++++++++++++++--
 drivers/media/dvb-frontends/si2165_priv.h | 11 ++++++
 2 files changed, 66 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/si2165.c b/drivers/media/dvb-frontends/si2165.c
index 777b7d049ae7..1cd2120f5dc4 100644
--- a/drivers/media/dvb-frontends/si2165.c
+++ b/drivers/media/dvb-frontends/si2165.c
@@ -594,8 +594,9 @@ static int si2165_init(struct dvb_frontend *fe)
 	if (ret < 0)
 		goto error;
 
-	/* ber_pkt */
-	ret = si2165_writereg16(state, REG_BER_PKT, 0x7530);
+	/* ber_pkt - default 65535 */
+	ret = si2165_writereg16(state, REG_BER_PKT,
+				STATISTICS_PERIOD_PKT_COUNT);
 	if (ret < 0)
 		goto error;
 
@@ -642,6 +643,10 @@ static int si2165_init(struct dvb_frontend *fe)
 	c = &state->fe.dtv_property_cache;
 	c->cnr.len = 1;
 	c->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	c->post_bit_error.len = 1;
+	c->post_bit_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	c->post_bit_count.len = 1;
+	c->post_bit_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 
 	return 0;
 error:
@@ -738,6 +743,54 @@ static int si2165_read_status(struct dvb_frontend *fe, enum fe_status *status)
 	} else
 		c->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 
+	/* BER */
+	if (*status & FE_HAS_VITERBI) {
+		if (c->post_bit_error.stat[0].scale == FE_SCALE_NOT_AVAILABLE) {
+			/* start new sampling period to get rid of old data*/
+			ret = si2165_writereg8(state, REG_BER_RST, 0x01);
+			if (ret < 0)
+				return ret;
+
+			/* set scale to enter read code on next call */
+			c->post_bit_error.stat[0].scale = FE_SCALE_COUNTER;
+			c->post_bit_count.stat[0].scale = FE_SCALE_COUNTER;
+			c->post_bit_error.stat[0].uvalue = 0;
+			c->post_bit_count.stat[0].uvalue = 0;
+
+		} else {
+			ret = si2165_readreg8(state, REG_BER_AVAIL, &u8tmp);
+			if (ret < 0)
+				return ret;
+
+			if (u8tmp & 1) {
+				u32 biterrcnt;
+
+				ret = si2165_readreg24(state, REG_BER_BIT,
+							&biterrcnt);
+				if (ret < 0)
+					return ret;
+
+				c->post_bit_error.stat[0].uvalue +=
+					biterrcnt;
+				c->post_bit_count.stat[0].uvalue +=
+					STATISTICS_PERIOD_BIT_COUNT;
+
+				/* start new sampling period */
+				ret = si2165_writereg8(state,
+							REG_BER_RST, 0x01);
+				if (ret < 0)
+					return ret;
+
+				dev_dbg(&state->client->dev,
+					"post_bit_error=%u post_bit_count=%u\n",
+					biterrcnt, STATISTICS_PERIOD_BIT_COUNT);
+			}
+		}
+	} else {
+		c->post_bit_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+		c->post_bit_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	}
+
 	return 0;
 }
 
diff --git a/drivers/media/dvb-frontends/si2165_priv.h b/drivers/media/dvb-frontends/si2165_priv.h
index 9d79e86d04c2..8c6fbfe441ff 100644
--- a/drivers/media/dvb-frontends/si2165_priv.h
+++ b/drivers/media/dvb-frontends/si2165_priv.h
@@ -38,6 +38,9 @@ struct si2165_config {
 	bool inversion;
 };
 
+#define STATISTICS_PERIOD_PKT_COUNT	30000u
+#define STATISTICS_PERIOD_BIT_COUNT	(STATISTICS_PERIOD_PKT_COUNT * 204 * 8)
+
 #define REG_CHIP_MODE			0x0000
 #define REG_CHIP_REVCODE		0x0023
 #define REV_CHIP_TYPE			0x0118
@@ -95,8 +98,16 @@ struct si2165_config {
 #define REG_GP_REG0_MSB			0x0387
 #define REG_CRC				0x037a
 #define REG_CHECK_SIGNAL		0x03a8
+#define REG_CBER_RST			0x0424
+#define REG_CBER_BIT			0x0428
+#define REG_CBER_ERR			0x0430
+#define REG_CBER_AVAIL			0x0434
 #define REG_PS_LOCK			0x0440
+#define REG_UNCOR_CNT			0x0468
+#define REG_BER_RST			0x046c
 #define REG_BER_PKT			0x0470
+#define REG_BER_BIT			0x0478
+#define REG_BER_AVAIL			0x047c
 #define REG_FEC_LOCK			0x04e0
 #define REG_TS_DATA_MODE		0x04e4
 #define REG_TS_CLK_MODE			0x04e5
-- 
2.15.0
