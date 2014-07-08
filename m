Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:52254 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752609AbaGHFx1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Jul 2014 01:53:27 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 4/4] tda10071: fix returned symbol rate calculation
Date: Tue,  8 Jul 2014 08:53:06 +0300
Message-Id: <1404798786-28361-4-git-send-email-crope@iki.fi>
In-Reply-To: <1404798786-28361-1-git-send-email-crope@iki.fi>
References: <1404798786-28361-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Detected symbol rate value was returned too small.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/tda10071.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/tda10071.c b/drivers/media/dvb-frontends/tda10071.c
index d590798..9619be5 100644
--- a/drivers/media/dvb-frontends/tda10071.c
+++ b/drivers/media/dvb-frontends/tda10071.c
@@ -860,7 +860,7 @@ static int tda10071_get_frontend(struct dvb_frontend *fe)
 	if (ret)
 		goto error;
 
-	c->symbol_rate = (buf[0] << 16) | (buf[1] << 8) | (buf[2] << 0);
+	c->symbol_rate = ((buf[0] << 16) | (buf[1] << 8) | (buf[2] << 0)) * 1000;
 
 	return ret;
 error:
-- 
1.9.3

