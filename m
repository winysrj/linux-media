Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:34505 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751066AbdFYL0x (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 25 Jun 2017 07:26:53 -0400
Received: by mail-wr0-f196.google.com with SMTP id k67so23865428wrc.1
        for <linux-media@vger.kernel.org>; Sun, 25 Jun 2017 04:26:53 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: liplianin@netup.ru, rjkm@metzlerbros.de, crope@iki.fi
Subject: [PATCH v3 4/4] [media] dvb-frontends/stv0367: update UCB readout condition logic
Date: Sun, 25 Jun 2017 13:26:46 +0200
Message-Id: <20170625112646.7973-5-d.scheller.oss@gmail.com>
In-Reply-To: <20170625112646.7973-1-d.scheller.oss@gmail.com>
References: <20170625112646.7973-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Since the other statistics are read when fe_status conditions are TRUE,
change the ucblocks readout logic to match this aswell.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/dvb-frontends/stv0367.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/media/dvb-frontends/stv0367.c b/drivers/media/dvb-frontends/stv0367.c
index 6097752a93bc..18ad1488be48 100644
--- a/drivers/media/dvb-frontends/stv0367.c
+++ b/drivers/media/dvb-frontends/stv0367.c
@@ -3113,13 +3113,11 @@ static int stv0367ddb_read_status(struct dvb_frontend *fe,
 	else
 		p->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 
-	/* stop if demod isn't locked */
-	if (!(*status & FE_HAS_LOCK)) {
+	/* read uncorrected blocks on FE_HAS_LOCK */
+	if (*status & FE_HAS_LOCK)
+		stv0367ddb_read_ucblocks(fe);
+	else
 		p->block_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
-		return ret;
-	}
-
-	stv0367ddb_read_ucblocks(fe);
 
 	return 0;
 }
-- 
2.13.0
