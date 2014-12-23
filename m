Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:50902 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756647AbaLWUue (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Dec 2014 15:50:34 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 42/66] rtl2832: remove unneeded software reset from init()
Date: Tue, 23 Dec 2014 22:49:35 +0200
Message-Id: <1419367799-14263-42-git-send-email-crope@iki.fi>
In-Reply-To: <1419367799-14263-1-git-send-email-crope@iki.fi>
References: <1419367799-14263-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is no need to do software reset on init() as it is done a bit
later on end of set_frontend(). Software reset usually means
restarting (resetting to starting point) chip internal state machine
(FSM). Naturally it is done after all parameters are programmed.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/rtl2832.c | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/drivers/media/dvb-frontends/rtl2832.c b/drivers/media/dvb-frontends/rtl2832.c
index 4b6e6e0..82398d8 100644
--- a/drivers/media/dvb-frontends/rtl2832.c
+++ b/drivers/media/dvb-frontends/rtl2832.c
@@ -434,21 +434,6 @@ static int rtl2832_init(struct dvb_frontend *fe)
 			goto err;
 	}
 
-	/*
-	 * r820t NIM code does a software reset here at the demod -
-	 * may not be needed, as there's already a software reset at
-	 * set_params()
-	 */
-#if 1
-	/* soft reset */
-	ret = rtl2832_wr_demod_reg(dev, DVBT_SOFT_RST, 0x1);
-	if (ret)
-		goto err;
-
-	ret = rtl2832_wr_demod_reg(dev, DVBT_SOFT_RST, 0x0);
-	if (ret)
-		goto err;
-#endif
 	/* init stats here in order signal app which stats are supported */
 	c->strength.len = 1;
 	c->strength.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
-- 
http://palosaari.fi/

