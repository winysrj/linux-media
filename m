Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta-out1.inet.fi ([62.71.2.228]:36031 "EHLO kirsi1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756256AbaHYSHO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Aug 2014 14:07:14 -0400
From: Olli Salonen <olli.salonen@iki.fi>
To: linux-media@vger.kernel.org
Cc: Olli Salonen <olli.salonen@iki.fi>
Subject: [PATCH 1/3] si2157: change command for sleep
Date: Mon, 25 Aug 2014 21:07:02 +0300
Message-Id: <1408990024-1642-1-git-send-email-olli.salonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of sending command 13 to the tuner, send command 16 when sleeping. This 
behaviour is observed when using manufacturer provided binary-only Linux driver 
for TechnoTrend CT2-4400 (Windows driver does not do power management).

The issue with command 13 is that firmware loading is necessary after that. 
This is not an issue with tuners that do not require firmware, but resuming 
from sleep on an Si2158 takes noticeable time as firmware is loaded on resume.

Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
---
 drivers/media/tuners/si2157.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/media/tuners/si2157.c b/drivers/media/tuners/si2157.c
index efb5cce..c84f7b8 100644
--- a/drivers/media/tuners/si2157.c
+++ b/drivers/media/tuners/si2157.c
@@ -197,9 +197,10 @@ static int si2157_sleep(struct dvb_frontend *fe)
 
 	s->active = false;
 
-	memcpy(cmd.args, "\x13", 1);
-	cmd.wlen = 1;
-	cmd.rlen = 0;
+	/* standby */
+	memcpy(cmd.args, "\x16\x00", 2);
+	cmd.wlen = 2;
+	cmd.rlen = 1;
 	ret = si2157_cmd_execute(s, &cmd);
 	if (ret)
 		goto err;
-- 
1.9.1

