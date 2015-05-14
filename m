Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:58625 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932562AbbENRNu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 14 May 2015 13:13:50 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH] dvb-core: fix 32-bit overflow during bandwidth calculation
Date: Thu, 14 May 2015 20:13:28 +0300
Message-Id: <1431623608-4749-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Frontend bandwidth calculation overflows on very high DVB-S/S2
symbol rates. Use mult_frac() macro in order to keep calculation
correct.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-core/dvb_frontend.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index 882ca41..a894d4c 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -2216,7 +2216,7 @@ static int dtv_set_frontend(struct dvb_frontend *fe)
 		break;
 	}
 	if (rolloff)
-		c->bandwidth_hz = (c->symbol_rate * rolloff) / 100;
+		c->bandwidth_hz = mult_frac(c->symbol_rate, rolloff, 100);
 
 	/* force auto frequency inversion if requested */
 	if (dvb_force_auto_inversion)
-- 
http://palosaari.fi/

