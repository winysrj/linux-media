Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13628 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753591Ab3CCP7B (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 3 Mar 2013 10:59:01 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r23Fx0kK014108
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 3 Mar 2013 10:59:00 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 05/11] [media] mb86a20s: don't allow updating signal strength too fast
Date: Sun,  3 Mar 2013 12:58:45 -0300
Message-Id: <1362326331-17541-6-git-send-email-mchehab@redhat.com>
In-Reply-To: <1362326331-17541-1-git-send-email-mchehab@redhat.com>
References: <1362326331-17541-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Getting signal strength requires some loop poking with I2C.
Don't let it happen too fast.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb-frontends/mb86a20s.c | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/media/dvb-frontends/mb86a20s.c b/drivers/media/dvb-frontends/mb86a20s.c
index 983fb3b..82fa2af 100644
--- a/drivers/media/dvb-frontends/mb86a20s.c
+++ b/drivers/media/dvb-frontends/mb86a20s.c
@@ -34,6 +34,7 @@ struct mb86a20s_state {
 	u32 if_freq;
 
 	u32 estimated_rate[3];
+	unsigned long get_strength_time;
 
 	bool need_init;
 };
@@ -318,9 +319,17 @@ static int mb86a20s_read_status(struct dvb_frontend *fe, fe_status_t *status)
 static int mb86a20s_read_signal_strength(struct dvb_frontend *fe)
 {
 	struct mb86a20s_state *state = fe->demodulator_priv;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int rc;
 	unsigned rf_max, rf_min, rf;
 
+	if (state->get_strength_time &&
+	   (!time_after(jiffies, state->get_strength_time)))
+		return c->strength.stat[0].uvalue;
+
+	/* Reset its value if an error happen */
+	c->strength.stat[0].uvalue = 0;
+
 	/* Does a binary search to get RF strength */
 	rf_max = 0xfff;
 	rf_min = 0;
@@ -350,15 +359,19 @@ static int mb86a20s_read_signal_strength(struct dvb_frontend *fe)
 			rf = (rf_max + rf_min) / 2;
 
 			/* Rescale it from 2^12 (4096) to 2^16 */
-			rf <<= (16 - 12);
+			rf = rf << (16 - 12);
+			if (rf)
+				rf |= (1 << 12) - 1;
+
 			dev_dbg(&state->i2c->dev,
 				"%s: signal strength = %d (%d < RF=%d < %d)\n",
 				__func__, rf, rf_min, rf >> 4, rf_max);
-			return rf;
+			c->strength.stat[0].uvalue = rf;
+			state->get_strength_time = jiffies +
+						   msecs_to_jiffies(1000);
+			return 0;
 		}
 	} while (1);
-
-	return 0;
 }
 
 static int mb86a20s_get_modulation(struct mb86a20s_state *state,
@@ -1882,7 +1895,6 @@ static int mb86a20s_read_status_and_stats(struct dvb_frontend *fe,
 					  fe_status_t *status)
 {
 	struct mb86a20s_state *state = fe->demodulator_priv;
-	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int rc, status_nr;
 
 	dev_dbg(&state->i2c->dev, "%s called.\n", __func__);
@@ -1913,8 +1925,6 @@ static int mb86a20s_read_status_and_stats(struct dvb_frontend *fe,
 		rc = 0;		/* Status is OK */
 		goto error;
 	}
-	/* Fill signal strength */
-	c->strength.stat[0].uvalue = rc;
 
 	if (status_nr >= 7) {
 		/* Get TMCC info*/
-- 
1.8.1.4

