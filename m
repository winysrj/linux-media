Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:33856 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756423Ab2CBWPw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Mar 2012 17:15:52 -0500
Received: by wibhm2 with SMTP id hm2so897733wib.19
        for <linux-media@vger.kernel.org>; Fri, 02 Mar 2012 14:15:51 -0800 (PST)
Message-ID: <1330726541.20647.11.camel@tvbox>
Subject: [PATCH] STV0288 increase delay between carrier search.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Date: Fri, 02 Mar 2012 22:15:41 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The current delay of 30uS is too short to recover any carrier.

In the lmedm04 driver delays were added to overcome carrier lock
problems. The typical delay was 30mS (2 x 15ms register write
0x2c and read 0x24).

Other drivers that use STV0288 don't appear to have any delay are
likely to have also suffered this problem.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/media/dvb/frontends/stv0288.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/frontends/stv0288.c b/drivers/media/dvb/frontends/stv0288.c
index fb5548a..632b251 100644
--- a/drivers/media/dvb/frontends/stv0288.c
+++ b/drivers/media/dvb/frontends/stv0288.c
@@ -506,7 +506,7 @@ static int stv0288_set_frontend(struct dvb_frontend *fe)
 		tda[1] = (unsigned char)tm;
 		stv0288_writeregI(state, 0x2b, tda[1]);
 		stv0288_writeregI(state, 0x2c, tda[2]);
-		udelay(30);
+		msleep(30);
 	}
 	state->tuner_frequency = c->frequency;
 	state->fec_inner = FEC_AUTO;
-- 
1.7.9



