Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:33544 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752945AbdHTM7Q (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 20 Aug 2017 08:59:16 -0400
Received: by mail-wr0-f194.google.com with SMTP id 30so1072371wrk.0
        for <linux-media@vger.kernel.org>; Sun, 20 Aug 2017 05:59:16 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: jasmin@anw.at
Subject: [PATCH 2/2] [media] dvb-frontends/stv6111.c: return NULL instead of plain integer
Date: Sun, 20 Aug 2017 14:59:12 +0200
Message-Id: <20170820125912.9716-3-d.scheller.oss@gmail.com>
In-Reply-To: <20170820125912.9716-1-d.scheller.oss@gmail.com>
References: <20170820125912.9716-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Fixes:
  stv6111.c:665:24: warning: Using plain integer as NULL pointer

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/dvb-frontends/stv6111.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/stv6111.c b/drivers/media/dvb-frontends/stv6111.c
index 9a59fa318207..e3e90070e293 100644
--- a/drivers/media/dvb-frontends/stv6111.c
+++ b/drivers/media/dvb-frontends/stv6111.c
@@ -669,7 +669,7 @@ struct dvb_frontend *stv6111_attach(struct dvb_frontend *fe,
 		fe->ops.i2c_gate_ctrl(fe, 0);
 	if (stat < 0) {
 		kfree(state);
-		return 0;
+		return NULL;
 	}
 	fe->tuner_priv = state;
 	return fe;
-- 
2.13.0
