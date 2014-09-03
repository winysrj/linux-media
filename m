Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44383 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756085AbaICUda (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Sep 2014 16:33:30 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 12/46] [media] cxd2820r: use true/false for boolean vars
Date: Wed,  3 Sep 2014 17:32:44 -0300
Message-Id: <949380544727964a3f8a297f83209aefd5d7773e.1409775488.git.m.chehab@samsung.com>
In-Reply-To: <cover.1409775488.git.m.chehab@samsung.com>
References: <cover.1409775488.git.m.chehab@samsung.com>
In-Reply-To: <cover.1409775488.git.m.chehab@samsung.com>
References: <cover.1409775488.git.m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using 0 or 1 for boolean, use the true/false
defines.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

diff --git a/drivers/media/dvb-frontends/cxd2820r_c.c b/drivers/media/dvb-frontends/cxd2820r_c.c
index 0f4657e01cde..149fdca3fb44 100644
--- a/drivers/media/dvb-frontends/cxd2820r_c.c
+++ b/drivers/media/dvb-frontends/cxd2820r_c.c
@@ -65,7 +65,7 @@ int cxd2820r_set_frontend_c(struct dvb_frontend *fe)
 	}
 
 	priv->delivery_system = SYS_DVBC_ANNEX_A;
-	priv->ber_running = 0; /* tune stops BER counter */
+	priv->ber_running = false; /* tune stops BER counter */
 
 	/* program IF frequency */
 	if (fe->ops.tuner_ops.get_if_frequency) {
@@ -168,7 +168,7 @@ int cxd2820r_read_ber_c(struct dvb_frontend *fe, u32 *ber)
 			start_ber = 1;
 		}
 	} else {
-		priv->ber_running = 1;
+		priv->ber_running = true;
 		start_ber = 1;
 	}
 
diff --git a/drivers/media/dvb-frontends/cxd2820r_core.c b/drivers/media/dvb-frontends/cxd2820r_core.c
index 03930d5e9fea..cd2af3edbd04 100644
--- a/drivers/media/dvb-frontends/cxd2820r_core.c
+++ b/drivers/media/dvb-frontends/cxd2820r_core.c
@@ -564,10 +564,10 @@ static enum dvbfe_search cxd2820r_search(struct dvb_frontend *fe)
 
 	/* check if we have a valid signal */
 	if (status & FE_HAS_LOCK) {
-		priv->last_tune_failed = 0;
+		priv->last_tune_failed = false;
 		return DVBFE_ALGO_SEARCH_SUCCESS;
 	} else {
-		priv->last_tune_failed = 1;
+		priv->last_tune_failed = true;
 		return DVBFE_ALGO_SEARCH_AGAIN;
 	}
 
diff --git a/drivers/media/dvb-frontends/cxd2820r_t.c b/drivers/media/dvb-frontends/cxd2820r_t.c
index 9b5a45b907bc..51401d036530 100644
--- a/drivers/media/dvb-frontends/cxd2820r_t.c
+++ b/drivers/media/dvb-frontends/cxd2820r_t.c
@@ -89,7 +89,7 @@ int cxd2820r_set_frontend_t(struct dvb_frontend *fe)
 	}
 
 	priv->delivery_system = SYS_DVBT;
-	priv->ber_running = 0; /* tune stops BER counter */
+	priv->ber_running = false; /* tune stops BER counter */
 
 	/* program IF frequency */
 	if (fe->ops.tuner_ops.get_if_frequency) {
@@ -272,7 +272,7 @@ int cxd2820r_read_ber_t(struct dvb_frontend *fe, u32 *ber)
 			start_ber = 1;
 		}
 	} else {
-		priv->ber_running = 1;
+		priv->ber_running = true;
 		start_ber = 1;
 	}
 
-- 
1.9.3

