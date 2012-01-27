Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:44395 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753665Ab2A0UTZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Jan 2012 15:19:25 -0500
Received: by werb13 with SMTP id b13so1558897wer.19
        for <linux-media@vger.kernel.org>; Fri, 27 Jan 2012 12:19:24 -0800 (PST)
Message-ID: <4f2306cb.ea58b40a.60a1.0d53@mx.google.com>
Subject: [PATCH 3/3] m88rs2000 move test for lock to after offset force.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Date: Fri, 27 Jan 2012 20:19:20 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sometimes, a otherwise good lock is lost after offset force.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/media/dvb/frontends/m88rs2000.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/dvb/frontends/m88rs2000.c b/drivers/media/dvb/frontends/m88rs2000.c
index 033b89d..75fe26b 100644
--- a/drivers/media/dvb/frontends/m88rs2000.c
+++ b/drivers/media/dvb/frontends/m88rs2000.c
@@ -709,12 +709,6 @@ static int m88rs2000_set_frontend(struct dvb_frontend *fe)
 	if (ret < 0)
 		return -ENODEV;
 
-	for (i = 0; i < 20; i++) {
-		m88rs2000_read_status(fe, &status);
-		if (status & FE_HAS_LOCK)
-			break;
-	}
-
 	offset = (s16)((m88rs2000_demod_read(state, 0x9c) << 8)|
 			m88rs2000_demod_read(state, 0x9d));
 
@@ -730,6 +724,12 @@ static int m88rs2000_set_frontend(struct dvb_frontend *fe)
 	if (ret < 0)
 		return -ENODEV;
 
+	for (i = 0; i < 20; i++) {
+		m88rs2000_read_status(fe, &status);
+		if (status & FE_HAS_LOCK)
+			break;
+	}
+
 	state->tuner_frequency = c->frequency;
 	state->symbol_rate = c->symbol_rate;
 	return 0;
-- 
1.7.5.4




