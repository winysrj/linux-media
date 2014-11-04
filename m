Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:36536 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750849AbaKDBHP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 3 Nov 2014 20:07:15 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 3/6] af9033: improve read_signal_strength error handling slightly
Date: Tue,  4 Nov 2014 03:07:01 +0200
Message-Id: <1415063224-28453-3-git-send-email-crope@iki.fi>
In-Reply-To: <1415063224-28453-1-git-send-email-crope@iki.fi>
References: <1415063224-28453-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Check return status after each register access routine and avoid
masking return status values.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/af9033.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb-frontends/af9033.c b/drivers/media/dvb-frontends/af9033.c
index e3bae77..3f688de 100644
--- a/drivers/media/dvb-frontends/af9033.c
+++ b/drivers/media/dvb-frontends/af9033.c
@@ -876,7 +876,12 @@ static int af9033_read_signal_strength(struct dvb_frontend *fe, u16 *strength)
 		*strength = u8tmp * 0xffff / 100;
 	} else {
 		ret = af9033_rd_reg(dev, 0x8000f7, &u8tmp);
-		ret |= af9033_rd_regs(dev, 0x80f900, buf, 7);
+		if (ret < 0)
+			goto err;
+
+		ret = af9033_rd_regs(dev, 0x80f900, buf, 7);
+		if (ret < 0)
+			goto err;
 
 		if (c->frequency <= 300000000)
 			gain_offset = 7; /* VHF */
@@ -901,9 +906,6 @@ static int af9033_read_signal_strength(struct dvb_frontend *fe, u16 *strength)
 		*strength = tmp * 0xffff / 100;
 	}
 
-	if (ret)
-		goto err;
-
 	return 0;
 
 err:
-- 
http://palosaari.fi/

