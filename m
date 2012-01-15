Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:42103 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752022Ab2AOUWh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Jan 2012 15:22:37 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 2/2] cxd2820r: do not switch to DVB-T when DVB-C fails
Date: Sun, 15 Jan 2012 22:21:54 +0200
Message-Id: <1326658914-3451-2-git-send-email-crope@iki.fi>
In-Reply-To: <1326658914-3451-1-git-send-email-crope@iki.fi>
References: <1326658914-3451-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix another bug	introduced by recent multi-frontend to single-frontend change.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb/frontends/cxd2820r_core.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb/frontends/cxd2820r_core.c b/drivers/media/dvb/frontends/cxd2820r_core.c
index 93e1b12..b789a90 100644
--- a/drivers/media/dvb/frontends/cxd2820r_core.c
+++ b/drivers/media/dvb/frontends/cxd2820r_core.c
@@ -476,10 +476,10 @@ static enum dvbfe_search cxd2820r_search(struct dvb_frontend *fe)
 	dbg("%s: delsys=%d", __func__, fe->dtv_property_cache.delivery_system);
 
 	/* switch between DVB-T and DVB-T2 when tune fails */
-	if (priv->last_tune_failed && (priv->delivery_system != SYS_DVBC_ANNEX_A)) {
+	if (priv->last_tune_failed) {
 		if (priv->delivery_system == SYS_DVBT)
 			c->delivery_system = SYS_DVBT2;
-		else
+		else if (priv->delivery_system == SYS_DVBT2)
 			c->delivery_system = SYS_DVBT;
 	}
 
-- 
1.7.4.4

