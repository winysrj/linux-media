Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:33314 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756344AbaGNRJU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Jul 2014 13:09:20 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Olli Salonen <olli.salonen@iki.fi>, Antti Palosaari <crope@iki.fi>
Subject: [PATCH 04/18] si2168: implement CNR statistic
Date: Mon, 14 Jul 2014 20:08:45 +0300
Message-Id: <1405357739-3570-4-git-send-email-crope@iki.fi>
In-Reply-To: <1405357739-3570-1-git-send-email-crope@iki.fi>
References: <1405357739-3570-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Implement CNR statistic.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/si2168.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
index 78af598..bfd7525 100644
--- a/drivers/media/dvb-frontends/si2168.c
+++ b/drivers/media/dvb-frontends/si2168.c
@@ -141,6 +141,15 @@ static int si2168_read_status(struct dvb_frontend *fe, fe_status_t *status)
 
 	s->fe_status = *status;
 
+	if (*status & FE_HAS_LOCK) {
+		c->cnr.len = 1;
+		c->cnr.stat[0].scale = FE_SCALE_DECIBEL;
+		c->cnr.stat[0].svalue = cmd.args[3] * 1000 / 4;
+	} else {
+		c->cnr.len = 1;
+		c->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	}
+
 	dev_dbg(&s->client->dev, "%s: status=%02x args=%*ph\n",
 			__func__, *status, cmd.rlen, cmd.args);
 
-- 
1.9.3

