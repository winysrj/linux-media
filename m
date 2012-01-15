Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:57705 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752617Ab2AOWat (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Jan 2012 17:30:49 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH] cxd2820r: do not allow get_frontend() when demod is not initialized
Date: Mon, 16 Jan 2012 00:30:36 +0200
Message-Id: <1326666636-3154-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This fixes bug introduced by multi-frontend to single-frontend change.

Finally HAS_LOCK is got back!
We are not allowed to access hardware in sleep mode...
Chip did not like when .get_frontend() reads some registers while
chip was sleeping and due to that HAS_LOCK bit was never gained.

TODO: We should add logic for dvb-core to drop out illegal calls like that.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb/frontends/cxd2820r_core.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/media/dvb/frontends/cxd2820r_core.c b/drivers/media/dvb/frontends/cxd2820r_core.c
index 372a4e7..caae7f7 100644
--- a/drivers/media/dvb/frontends/cxd2820r_core.c
+++ b/drivers/media/dvb/frontends/cxd2820r_core.c
@@ -309,9 +309,14 @@ static int cxd2820r_read_status(struct dvb_frontend *fe, fe_status_t *status)
 
 static int cxd2820r_get_frontend(struct dvb_frontend *fe)
 {
+	struct cxd2820r_priv *priv = fe->demodulator_priv;
 	int ret;
 
 	dbg("%s: delsys=%d", __func__, fe->dtv_property_cache.delivery_system);
+
+	if (priv->delivery_system == SYS_UNDEFINED)
+		return 0;
+
 	switch (fe->dtv_property_cache.delivery_system) {
 	case SYS_DVBT:
 		ret = cxd2820r_get_frontend_t(fe);
-- 
1.7.4.4

