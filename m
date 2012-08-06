Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:49212 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756511Ab2HFWfz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 6 Aug 2012 18:35:55 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH] m88rs2000: add missing FE_HAS_SYNC flag
Date: Tue,  7 Aug 2012 01:35:26 +0300
Message-Id: <1344292526-26424-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Cc: Malcolm Priestley <tvboxspy@gmail.com>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb/frontends/m88rs2000.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb/frontends/m88rs2000.c b/drivers/media/dvb/frontends/m88rs2000.c
index 312588e..633815e 100644
--- a/drivers/media/dvb/frontends/m88rs2000.c
+++ b/drivers/media/dvb/frontends/m88rs2000.c
@@ -481,7 +481,7 @@ static int m88rs2000_read_status(struct dvb_frontend *fe, fe_status_t *status)
 
 	if ((reg & 0x7) == 0x7) {
 		*status = FE_HAS_CARRIER | FE_HAS_SIGNAL | FE_HAS_VITERBI
-			| FE_HAS_LOCK;
+			| FE_HAS_SYNC | FE_HAS_LOCK;
 		if (state->config->set_ts_params)
 			state->config->set_ts_params(fe, CALL_IS_READ);
 	}
-- 
1.7.11.2

