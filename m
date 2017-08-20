Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:34311 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751634AbdHTKps (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 20 Aug 2017 06:45:48 -0400
Received: by mail-wr0-f196.google.com with SMTP id p14so7646074wrg.1
        for <linux-media@vger.kernel.org>; Sun, 20 Aug 2017 03:45:48 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: jasmin@anw.at, rjkm@metzlerbros.de
Subject: [PATCH] [media] dvb-frontends/mxl5xx: fix lock check order
Date: Sun, 20 Aug 2017 12:45:45 +0200
Message-Id: <20170820104545.6596-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
When the mxl5xx driver together with the ddbridge glue gets merged ([1]),
this one should go in aswell - this fix is part of the dddvb-0.9.31
release.

 drivers/media/dvb-frontends/mxl5xx.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/mxl5xx.c b/drivers/media/dvb-frontends/mxl5xx.c
index 676c96c216c3..d9136d67f5d4 100644
--- a/drivers/media/dvb-frontends/mxl5xx.c
+++ b/drivers/media/dvb-frontends/mxl5xx.c
@@ -638,13 +638,14 @@ static int tune(struct dvb_frontend *fe, bool re_tune,
 		state->tune_time = jiffies;
 		return 0;
 	}
-	if (*status & FE_HAS_LOCK)
-		return 0;
 
 	r = read_status(fe, status);
 	if (r)
 		return r;
 
+	if (*status & FE_HAS_LOCK)
+		return 0;
+
 	return 0;
 }
 
-- 
2.13.0
