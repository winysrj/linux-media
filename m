Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:49259 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752968AbcIBWht (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 2 Sep 2016 18:37:49 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 8/9] cxd2820r: improve lock detection
Date: Sat,  3 Sep 2016 01:37:23 +0300
Message-Id: <1472855844-8665-8-git-send-email-crope@iki.fi>
In-Reply-To: <1472855844-8665-1-git-send-email-crope@iki.fi>
References: <1472855844-8665-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Check demod and ts locks and report lock status according to those.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/cxd2820r_c.c  | 29 ++++++++++++--------
 drivers/media/dvb-frontends/cxd2820r_t.c  | 44 ++++++++++++-------------------
 drivers/media/dvb-frontends/cxd2820r_t2.c | 26 ++++++++++--------
 3 files changed, 50 insertions(+), 49 deletions(-)

diff --git a/drivers/media/dvb-frontends/cxd2820r_c.c b/drivers/media/dvb-frontends/cxd2820r_c.c
index beb46a6..0f96add 100644
--- a/drivers/media/dvb-frontends/cxd2820r_c.c
+++ b/drivers/media/dvb-frontends/cxd2820r_c.c
@@ -160,25 +160,32 @@ int cxd2820r_read_status_c(struct dvb_frontend *fe, enum fe_status *status)
 	struct i2c_client *client = priv->client[0];
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret;
-	unsigned int utmp;
+	unsigned int utmp, utmp1, utmp2;
 	u8 buf[3];
-	*status = 0;
 
-	ret = cxd2820r_rd_regs(priv, 0x10088, buf, 2);
+	/* Lock detection */
+	ret = cxd2820r_rd_reg(priv, 0x10088, &buf[0]);
+	if (ret)
+		goto error;
+	ret = cxd2820r_rd_reg(priv, 0x10073, &buf[1]);
 	if (ret)
 		goto error;
 
-	if (((buf[0] >> 0) & 0x01) == 1) {
-		*status |= FE_HAS_SIGNAL | FE_HAS_CARRIER |
-			FE_HAS_VITERBI | FE_HAS_SYNC;
+	utmp1 = (buf[0] >> 0) & 0x01;
+	utmp2 = (buf[1] >> 3) & 0x01;
 
-		if (((buf[1] >> 3) & 0x01) == 1) {
-			*status |= FE_HAS_SIGNAL | FE_HAS_CARRIER |
-				FE_HAS_VITERBI | FE_HAS_SYNC | FE_HAS_LOCK;
-		}
+	if (utmp1 == 1 && utmp2 == 1) {
+		*status = FE_HAS_SIGNAL | FE_HAS_CARRIER |
+			  FE_HAS_VITERBI | FE_HAS_SYNC | FE_HAS_LOCK;
+	} else if (utmp1 == 1 || utmp2 == 1) {
+		*status = FE_HAS_SIGNAL | FE_HAS_CARRIER |
+			  FE_HAS_VITERBI | FE_HAS_SYNC;
+	} else {
+		*status = 0;
 	}
 
-	dev_dbg(&client->dev, "lock=%*ph\n", 2, buf);
+	dev_dbg(&client->dev, "status=%02x raw=%*ph sync=%u ts=%u\n",
+		*status, 2, buf, utmp1, utmp2);
 
 	/* Signal strength */
 	if (*status & FE_HAS_SIGNAL) {
diff --git a/drivers/media/dvb-frontends/cxd2820r_t.c b/drivers/media/dvb-frontends/cxd2820r_t.c
index 174d916..19f72cd 100644
--- a/drivers/media/dvb-frontends/cxd2820r_t.c
+++ b/drivers/media/dvb-frontends/cxd2820r_t.c
@@ -265,42 +265,32 @@ int cxd2820r_read_status_t(struct dvb_frontend *fe, enum fe_status *status)
 	struct i2c_client *client = priv->client[0];
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret;
-	unsigned int utmp;
-	u8 buf[4];
-	*status = 0;
+	unsigned int utmp, utmp1, utmp2;
+	u8 buf[3];
 
+	/* Lock detection */
 	ret = cxd2820r_rd_reg(priv, 0x00010, &buf[0]);
 	if (ret)
 		goto error;
+	ret = cxd2820r_rd_reg(priv, 0x00073, &buf[1]);
+	if (ret)
+		goto error;
 
-	if ((buf[0] & 0x07) == 6) {
-		ret = cxd2820r_rd_reg(priv, 0x00073, &buf[1]);
-		if (ret)
-			goto error;
+	utmp1 = (buf[0] >> 0) & 0x07;
+	utmp2 = (buf[1] >> 3) & 0x01;
 
-		if (((buf[1] >> 3) & 0x01) == 1) {
-			*status |= FE_HAS_SIGNAL | FE_HAS_CARRIER |
-				FE_HAS_VITERBI | FE_HAS_SYNC | FE_HAS_LOCK;
-		} else {
-			*status |= FE_HAS_SIGNAL | FE_HAS_CARRIER |
-				FE_HAS_VITERBI | FE_HAS_SYNC;
-		}
+	if (utmp1 == 6 && utmp2 == 1) {
+		*status = FE_HAS_SIGNAL | FE_HAS_CARRIER |
+			  FE_HAS_VITERBI | FE_HAS_SYNC | FE_HAS_LOCK;
+	} else if (utmp1 == 6 || utmp2 == 1) {
+		*status = FE_HAS_SIGNAL | FE_HAS_CARRIER |
+			  FE_HAS_VITERBI | FE_HAS_SYNC;
 	} else {
-		ret = cxd2820r_rd_reg(priv, 0x00014, &buf[2]);
-		if (ret)
-			goto error;
-
-		if ((buf[2] & 0x0f) >= 4) {
-			ret = cxd2820r_rd_reg(priv, 0x00a14, &buf[3]);
-			if (ret)
-				goto error;
-
-			if (((buf[3] >> 4) & 0x01) == 1)
-				*status |= FE_HAS_SIGNAL;
-		}
+		*status = 0;
 	}
 
-	dev_dbg(&client->dev, "lock=%*ph\n", 4, buf);
+	dev_dbg(&client->dev, "status=%02x raw=%*ph sync=%u ts=%u\n",
+		*status, 2, buf, utmp1, utmp2);
 
 	/* Signal strength */
 	if (*status & FE_HAS_SIGNAL) {
diff --git a/drivers/media/dvb-frontends/cxd2820r_t2.c b/drivers/media/dvb-frontends/cxd2820r_t2.c
index 939a68d..4a6fbf8 100644
--- a/drivers/media/dvb-frontends/cxd2820r_t2.c
+++ b/drivers/media/dvb-frontends/cxd2820r_t2.c
@@ -293,25 +293,29 @@ int cxd2820r_read_status_t2(struct dvb_frontend *fe, enum fe_status *status)
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct i2c_client *client = priv->client[0];
 	int ret;
-	unsigned int utmp;
+	unsigned int utmp, utmp1, utmp2;
 	u8 buf[4];
-	*status = 0;
 
+	/* Lock detection */
 	ret = cxd2820r_rd_reg(priv, 0x02010 , &buf[0]);
 	if (ret)
 		goto error;
 
-	if ((buf[0] & 0x07) == 6) {
-		if (((buf[0] >> 5) & 0x01) == 1) {
-			*status |= FE_HAS_SIGNAL | FE_HAS_CARRIER |
-				FE_HAS_VITERBI | FE_HAS_SYNC | FE_HAS_LOCK;
-		} else {
-			*status |= FE_HAS_SIGNAL | FE_HAS_CARRIER |
-				FE_HAS_VITERBI | FE_HAS_SYNC;
-		}
+	utmp1 = (buf[0] >> 0) & 0x07;
+	utmp2 = (buf[0] >> 5) & 0x01;
+
+	if (utmp1 == 6 && utmp2 == 1) {
+		*status = FE_HAS_SIGNAL | FE_HAS_CARRIER |
+			  FE_HAS_VITERBI | FE_HAS_SYNC | FE_HAS_LOCK;
+	} else if (utmp1 == 6 || utmp2 == 1) {
+		*status = FE_HAS_SIGNAL | FE_HAS_CARRIER |
+			  FE_HAS_VITERBI | FE_HAS_SYNC;
+	} else {
+		*status = 0;
 	}
 
-	dev_dbg(&client->dev, "lock=%*ph\n", 1, buf);
+	dev_dbg(&client->dev, "status=%02x raw=%*ph sync=%u ts=%u\n",
+		*status, 1, buf, utmp1, utmp2);
 
 	/* Signal strength */
 	if (*status & FE_HAS_SIGNAL) {
-- 
http://palosaari.fi/

