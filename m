Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:34198 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752619AbdHTK3U (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 20 Aug 2017 06:29:20 -0400
Received: by mail-wr0-f195.google.com with SMTP id p14so7602942wrg.1
        for <linux-media@vger.kernel.org>; Sun, 20 Aug 2017 03:29:20 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: jasmin@anw.at, rjkm@metzlerbros.de
Subject: [PATCH 1/2] [media] dvb-frontends/stv0910: fix FE_HAS_LOCK check order in tune()
Date: Sun, 20 Aug 2017 12:29:14 +0200
Message-Id: <20170820102915.6196-2-d.scheller.oss@gmail.com>
In-Reply-To: <20170820102915.6196-1-d.scheller.oss@gmail.com>
References: <20170820102915.6196-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/dvb-frontends/stv0910.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb-frontends/stv0910.c b/drivers/media/dvb-frontends/stv0910.c
index a2648dd91a57..fe25b1778555 100644
--- a/drivers/media/dvb-frontends/stv0910.c
+++ b/drivers/media/dvb-frontends/stv0910.c
@@ -1581,13 +1581,15 @@ static int tune(struct dvb_frontend *fe, bool re_tune,
 			return r;
 		state->tune_time = jiffies;
 	}
-	if (*status & FE_HAS_LOCK)
-		return 0;
-	*delay = HZ;
 
 	r = read_status(fe, status);
 	if (r)
 		return r;
+
+	if (*status & FE_HAS_LOCK)
+		return 0;
+	*delay = HZ;
+
 	return 0;
 }
 
-- 
2.13.0
