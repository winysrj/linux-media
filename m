Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([91.232.154.25]:56611 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932443AbeCMXkK (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Mar 2018 19:40:10 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 01/18] af9013: change lock detection slightly
Date: Wed, 14 Mar 2018 01:39:27 +0200
Message-Id: <20180313233944.7234-1-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Whilst rewritten largely, the basic logic remains same with one
exception: do not return immediately on success case. We are going to
add statistics that function and cannot return too early.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/af9013.c | 55 ++++++++++++++++++------------------
 1 file changed, 27 insertions(+), 28 deletions(-)

diff --git a/drivers/media/dvb-frontends/af9013.c b/drivers/media/dvb-frontends/af9013.c
index b8f3ebfc3e27..30cf837058da 100644
--- a/drivers/media/dvb-frontends/af9013.c
+++ b/drivers/media/dvb-frontends/af9013.c
@@ -752,45 +752,44 @@ static int af9013_read_status(struct dvb_frontend *fe, enum fe_status *status)
 	struct af9013_state *state = fe->demodulator_priv;
 	struct i2c_client *client = state->client;
 	int ret;
-	unsigned int utmp;
+	unsigned int utmp, utmp1;
 
 	/*
 	 * Return status from the cache if it is younger than 2000ms with the
 	 * exception of last tune is done during 4000ms.
 	 */
-	if (time_is_after_jiffies(
-		state->read_status_jiffies + msecs_to_jiffies(2000)) &&
-		time_is_before_jiffies(
-		state->set_frontend_jiffies + msecs_to_jiffies(4000))
-	) {
-			*status = state->fe_status;
-			return 0;
+	if (time_is_after_jiffies(state->read_status_jiffies + msecs_to_jiffies(2000)) &&
+	    time_is_before_jiffies(state->set_frontend_jiffies + msecs_to_jiffies(4000))) {
+		*status = state->fe_status;
 	} else {
-		*status = 0;
-	}
+		/* MPEG2 lock */
+		ret = regmap_read(state->regmap, 0xd507, &utmp);
+		if (ret)
+			goto err;
 
-	/* MPEG2 lock */
-	ret = regmap_read(state->regmap, 0xd507, &utmp);
-	if (ret)
-		goto err;
+		if ((utmp >> 6) & 0x01) {
+			utmp1 = FE_HAS_SIGNAL | FE_HAS_CARRIER |
+				FE_HAS_VITERBI | FE_HAS_SYNC | FE_HAS_LOCK;
+		} else {
+			/* TPS lock */
+			ret = regmap_read(state->regmap, 0xd330, &utmp);
+			if (ret)
+				goto err;
 
-	if ((utmp >> 6) & 0x01)
-		*status |= FE_HAS_SIGNAL | FE_HAS_CARRIER | FE_HAS_VITERBI |
-			FE_HAS_SYNC | FE_HAS_LOCK;
+			if ((utmp >> 3) & 0x01)
+				utmp1 = FE_HAS_SIGNAL | FE_HAS_CARRIER |
+					FE_HAS_VITERBI;
+			else
+				utmp1 = 0;
+		}
 
-	if (!*status) {
-		/* TPS lock */
-		ret = regmap_read(state->regmap, 0xd330, &utmp);
-		if (ret)
-			goto err;
+		dev_dbg(&client->dev, "fe_status %02x\n", utmp1);
 
-		if ((utmp >> 3) & 0x01)
-			*status |= FE_HAS_SIGNAL | FE_HAS_CARRIER |
-				FE_HAS_VITERBI;
-	}
+		state->read_status_jiffies = jiffies;
 
-	state->fe_status = *status;
-	state->read_status_jiffies = jiffies;
+		state->fe_status = utmp1;
+		*status = utmp1;
+	}
 
 	return 0;
 err:
-- 
2.14.3
