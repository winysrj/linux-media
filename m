Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:54122 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754262Ab2ATXsk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Jan 2012 18:48:40 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH] cxd2820r: sleep on DVB-T/T2 delivery system switch
Date: Sat, 21 Jan 2012 01:48:28 +0200
Message-Id: <1327103308-15766-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix bug introduced by multi-frontend to single-frontend change.
It is safer to put DVB-T parts sleeping when auto-switching to DVB-T2
and vice versa. That was original behaviour.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb/frontends/cxd2820r_core.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb/frontends/cxd2820r_core.c b/drivers/media/dvb/frontends/cxd2820r_core.c
index bdfa207..5c7c2aa 100644
--- a/drivers/media/dvb/frontends/cxd2820r_core.c
+++ b/drivers/media/dvb/frontends/cxd2820r_core.c
@@ -482,10 +482,19 @@ static enum dvbfe_search cxd2820r_search(struct dvb_frontend *fe)
 
 	/* switch between DVB-T and DVB-T2 when tune fails */
 	if (priv->last_tune_failed) {
-		if (priv->delivery_system == SYS_DVBT)
+		if (priv->delivery_system == SYS_DVBT) {
+			ret = cxd2820r_sleep_t(fe);
+			if (ret)
+				goto error;
+
 			c->delivery_system = SYS_DVBT2;
-		else if (priv->delivery_system == SYS_DVBT2)
+		} else if (priv->delivery_system == SYS_DVBT2) {
+			ret = cxd2820r_sleep_t2(fe);
+			if (ret)
+				goto error;
+
 			c->delivery_system = SYS_DVBT;
+		}
 	}
 
 	/* set frontend */
-- 
1.7.4.4

