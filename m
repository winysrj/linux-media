Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:48493 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750868Ab3IHAXA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Sep 2013 20:23:00 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 1/3] e4000: fix PLL calc bug on 32-bit arch
Date: Sun,  8 Sep 2013 03:21:49 +0300
Message-Id: <1378599711-26875-2-git-send-email-crope@iki.fi>
In-Reply-To: <1378599711-26875-1-git-send-email-crope@iki.fi>
References: <1378599711-26875-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix long-lasting bug that causes tuning failure of some frequencies
on 32-bit arch.

Special thanks goes to Damien CABROL who finally find root of the bug.
Also big thanks to Jacek Konieczny for donating "non-working" device.

[crope@iki.fi: fix trivial merge conflict]
Reported-by: Jacek Konieczny <jajcus@jajcus.net>
Reported-by: Torsten Seyffarth <t.seyffarth@gmx.de>
Reported-by: Jan Taegert <jantaegert@gmx.net>
Reported-by: Damien CABROL <cabrol.damien@free.fr>
Tested-by: Damien CABROL <cabrol.damien@free.fr>
Tested-by: Jan Taegert <jantaegert@gmx.net>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/e4000.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/tuners/e4000.c b/drivers/media/tuners/e4000.c
index ad9309d..54e2d8a 100644
--- a/drivers/media/tuners/e4000.c
+++ b/drivers/media/tuners/e4000.c
@@ -233,7 +233,7 @@ static int e4000_set_params(struct dvb_frontend *fe)
 	 * or more.
 	 */
 	f_vco = c->frequency * e4000_pll_lut[i].mul;
-	sigma_delta = 0x10000UL * (f_vco % priv->cfg->clock) / priv->cfg->clock;
+	sigma_delta = div_u64(0x10000ULL * (f_vco % priv->cfg->clock), priv->cfg->clock);
 	buf[0] = f_vco / priv->cfg->clock;
 	buf[1] = (sigma_delta >> 0) & 0xff;
 	buf[2] = (sigma_delta >> 8) & 0xff;
-- 
1.7.11.7

