Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:57698 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758871Ab2LIT5M (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 9 Dec 2012 14:57:12 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH RFC 01/17] af9033: add support for Fitipower FC0012 tuner
Date: Sun,  9 Dec 2012 21:56:12 +0200
Message-Id: <1355082988-6211-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/af9033.c      |  4 +++
 drivers/media/dvb-frontends/af9033.h      |  1 +
 drivers/media/dvb-frontends/af9033_priv.h | 43 +++++++++++++++++++++++++++++++
 3 files changed, 48 insertions(+)

diff --git a/drivers/media/dvb-frontends/af9033.c b/drivers/media/dvb-frontends/af9033.c
index 464ad87..27638a9 100644
--- a/drivers/media/dvb-frontends/af9033.c
+++ b/drivers/media/dvb-frontends/af9033.c
@@ -318,6 +318,10 @@ static int af9033_init(struct dvb_frontend *fe)
 		len = ARRAY_SIZE(tuner_init_fc2580);
 		init = tuner_init_fc2580;
 		break;
+	case AF9033_TUNER_FC0012:
+		len = ARRAY_SIZE(tuner_init_fc0012);
+		init = tuner_init_fc0012;
+		break;
 	default:
 		dev_dbg(&state->i2c->dev, "%s: unsupported tuner ID=%d\n",
 				__func__, state->cfg.tuner);
diff --git a/drivers/media/dvb-frontends/af9033.h b/drivers/media/dvb-frontends/af9033.h
index bfa4313..82bd8c1 100644
--- a/drivers/media/dvb-frontends/af9033.h
+++ b/drivers/media/dvb-frontends/af9033.h
@@ -40,6 +40,7 @@ struct af9033_config {
 	 */
 #define AF9033_TUNER_TUA9001     0x27 /* Infineon TUA 9001 */
 #define AF9033_TUNER_FC0011      0x28 /* Fitipower FC0011 */
+#define AF9033_TUNER_FC0012      0x2e /* Fitipower FC0012 */
 #define AF9033_TUNER_MXL5007T    0xa0 /* MaxLinear MxL5007T */
 #define AF9033_TUNER_TDA18218    0xa1 /* NXP TDA 18218HN */
 #define AF9033_TUNER_FC2580      0x32 /* FCI FC2580 */
diff --git a/drivers/media/dvb-frontends/af9033_priv.h b/drivers/media/dvb-frontends/af9033_priv.h
index 34dddcd..288cd45 100644
--- a/drivers/media/dvb-frontends/af9033_priv.h
+++ b/drivers/media/dvb-frontends/af9033_priv.h
@@ -397,6 +397,49 @@ static const struct reg_val tuner_init_fc0011[] = {
 	{ 0x80F1E6, 0x00 },
 };
 
+/* Fitipower FC0012 tuner init
+   AF9033_TUNER_FC0012    = 0x2e */
+static const struct reg_val tuner_init_fc0012[] = {
+	{ 0x800046, 0x2e },
+	{ 0x800057, 0x00 },
+	{ 0x800058, 0x01 },
+	{ 0x800059, 0x01 },
+	{ 0x80005f, 0x00 },
+	{ 0x800060, 0x00 },
+	{ 0x80006d, 0x00 },
+	{ 0x800071, 0x05 },
+	{ 0x800072, 0x02 },
+	{ 0x800074, 0x01 },
+	{ 0x800075, 0x03 },
+	{ 0x800076, 0x02 },
+	{ 0x800077, 0x01 },
+	{ 0x800078, 0x00 },
+	{ 0x800079, 0x00 },
+	{ 0x80007a, 0x90 },
+	{ 0x80007b, 0x90 },
+	{ 0x800093, 0x00 },
+	{ 0x800094, 0x01 },
+	{ 0x800095, 0x02 },
+	{ 0x800096, 0x01 },
+	{ 0x800098, 0x0a },
+	{ 0x80009b, 0x05 },
+	{ 0x80009c, 0x80 },
+	{ 0x8000b3, 0x00 },
+	{ 0x8000c5, 0x01 },
+	{ 0x8000c6, 0x00 },
+	{ 0x8000c9, 0x5d },
+	{ 0x80f007, 0x00 },
+	{ 0x80f01f, 0xa0 },
+	{ 0x80f020, 0x00 },
+	{ 0x80f029, 0x82 },
+	{ 0x80f02a, 0x00 },
+	{ 0x80f047, 0x00 },
+	{ 0x80f054, 0x00 },
+	{ 0x80f055, 0x00 },
+	{ 0x80f077, 0x01 },
+	{ 0x80f1e6, 0x00 },
+};
+
 /* MaxLinear MxL5007T tuner init
    AF9033_TUNER_MXL5007T    = 0xa0 */
 static const struct reg_val tuner_init_mxl5007t[] = {
-- 
1.7.11.7

