Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.bredband2.com ([83.219.192.166]:41419 "EHLO
	smtp.bredband2.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756663AbbCRVhQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Mar 2015 17:37:16 -0400
From: Benjamin Larsson <benjamin@southpole.se>
To: crope@iki.fi
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 1/1] mn88473: implement lock for all delivery systems
Date: Wed, 18 Mar 2015 22:37:09 +0100
Message-Id: <1426714629-15640-1-git-send-email-benjamin@southpole.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Benjamin Larsson <benjamin@southpole.se>
---
 drivers/staging/media/mn88473/mn88473.c | 50 +++++++++++++++++++++++++++++++--
 1 file changed, 48 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/mn88473/mn88473.c b/drivers/staging/media/mn88473/mn88473.c
index a23e59e..196fcd6 100644
--- a/drivers/staging/media/mn88473/mn88473.c
+++ b/drivers/staging/media/mn88473/mn88473.c
@@ -167,7 +167,10 @@ static int mn88473_read_status(struct dvb_frontend *fe, fe_status_t *status)
 {
 	struct i2c_client *client = fe->demodulator_priv;
 	struct mn88473_dev *dev = i2c_get_clientdata(client);
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret;
+	unsigned int utmp;
+	int lock = 0;
 
 	*status = 0;
 
@@ -176,8 +179,51 @@ static int mn88473_read_status(struct dvb_frontend *fe, fe_status_t *status)
 		goto err;
 	}
 
-	*status = FE_HAS_SIGNAL | FE_HAS_CARRIER | FE_HAS_VITERBI |
-			FE_HAS_SYNC | FE_HAS_LOCK;
+	switch (c->delivery_system) {
+	case SYS_DVBT:
+		ret = regmap_read(dev->regmap[0], 0x62, &utmp);
+		if (ret)
+			goto err;
+		if (utmp & 0xA0) {
+			if ((utmp & 0xF) >= 0x03)
+				*status |= FE_HAS_SIGNAL;
+			if ((utmp & 0xF) >= 0x09)
+				lock = 1;
+		}
+		break;
+	case SYS_DVBT2:
+		ret = regmap_read(dev->regmap[2], 0x8B, &utmp);
+		if (ret)
+			goto err;
+		if (utmp & 0x40) {
+			if ((utmp & 0xF) >= 0x07)
+				*status |= FE_HAS_SIGNAL;
+			if ((utmp & 0xF) >= 0x0a)
+				*status |= FE_HAS_CARRIER;
+			if ((utmp & 0xF) >= 0x0d)
+				*status |= FE_HAS_VITERBI | FE_HAS_SYNC | FE_HAS_LOCK;
+		}
+		break;
+	case SYS_DVBC_ANNEX_A:
+		ret = regmap_read(dev->regmap[1], 0x85, &utmp);
+		if (ret)
+			goto err;
+		if (!(utmp & 0x40)) {
+			ret = regmap_read(dev->regmap[1], 0x89, &utmp);
+			if (ret)
+				goto err;
+			if (utmp & 0x01)
+				lock = 1;
+		}
+		break;
+	default:
+		ret = -EINVAL;
+		goto err;
+	}
+
+	if (lock)
+		*status = FE_HAS_SIGNAL | FE_HAS_CARRIER | FE_HAS_VITERBI |
+				FE_HAS_SYNC | FE_HAS_LOCK;
 
 	return 0;
 err:
-- 
2.1.0

