Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:45338 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753140AbaHBDtO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 1 Aug 2014 23:49:14 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 1/5] cxd2843: do not call get_if_frequency() when it is NULL
Date: Sat,  2 Aug 2014 06:48:51 +0300
Message-Id: <1406951335-24026-2-git-send-email-crope@iki.fi>
In-Reply-To: <1406951335-24026-1-git-send-email-crope@iki.fi>
References: <1406951335-24026-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Calling NULL callback crash kernel. Check its existence before
call it.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/cxd2843.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/cxd2843.c b/drivers/media/dvb-frontends/cxd2843.c
index 10fc240..433d913 100644
--- a/drivers/media/dvb-frontends/cxd2843.c
+++ b/drivers/media/dvb-frontends/cxd2843.c
@@ -1154,7 +1154,8 @@ static int set_parameters(struct dvb_frontend *fe)
 		state->plp = fe->dtv_property_cache.stream_id & 0xff;
 	}
 	/* printk("PLP = %08x, bw = %u\n", state->plp, state->bw); */
-	fe->ops.tuner_ops.get_if_frequency(fe, &IF);
+	if (fe->ops.tuner_ops.get_if_frequency)
+		fe->ops.tuner_ops.get_if_frequency(fe, &IF);
 	stat = Start(state, IF);
 	return stat;
 }
-- 
http://palosaari.fi/

