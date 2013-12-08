Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:37704 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759949Ab3LHWbz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 8 Dec 2013 17:31:55 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH REVIEW 11/18] m88ds3103: use kernel macro to round division
Date: Mon,  9 Dec 2013 00:31:28 +0200
Message-Id: <1386541895-8634-12-git-send-email-crope@iki.fi>
In-Reply-To: <1386541895-8634-1-git-send-email-crope@iki.fi>
References: <1386541895-8634-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

DIV_ROUND_CLOSEST does the job and looks better.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/m88ds3103.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb-frontends/m88ds3103.c b/drivers/media/dvb-frontends/m88ds3103.c
index e07e8d6..bd9effa 100644
--- a/drivers/media/dvb-frontends/m88ds3103.c
+++ b/drivers/media/dvb-frontends/m88ds3103.c
@@ -460,8 +460,7 @@ static int m88ds3103_set_frontend(struct dvb_frontend *fe)
 	if (ret)
 		goto err;
 
-	u16tmp = (((c->symbol_rate / 1000) << 15) + (M88DS3103_MCLK_KHZ / 4)) /
-			(M88DS3103_MCLK_KHZ / 2);
+	u16tmp = DIV_ROUND_CLOSEST((c->symbol_rate / 1000) << 15, M88DS3103_MCLK_KHZ / 2);
 	buf[0] = (u16tmp >> 0) & 0xff;
 	buf[1] = (u16tmp >> 8) & 0xff;
 	ret = m88ds3103_wr_regs(priv, 0x61, buf, 2);
@@ -484,7 +483,7 @@ static int m88ds3103_set_frontend(struct dvb_frontend *fe)
 			(tuner_frequency - c->frequency));
 
 	s32tmp = 0x10000 * (tuner_frequency - c->frequency);
-	s32tmp = (2 * s32tmp + M88DS3103_MCLK_KHZ) / (2 * M88DS3103_MCLK_KHZ);
+	s32tmp = DIV_ROUND_CLOSEST(s32tmp, M88DS3103_MCLK_KHZ);
 	if (s32tmp < 0)
 		s32tmp += 0x10000;
 
-- 
1.8.4.2

