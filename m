Return-path: <mchehab@pedra>
Received: from que11.charter.net ([209.225.8.21]:34071 "EHLO que11.charter.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753192Ab1FPR0W (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jun 2011 13:26:22 -0400
From: Greg Dietsche <Gregory.Dietsche@cuw.edu>
To: mchehab@infradead.org
Cc: linux-media@vger.kernel.org,
	Greg Dietsche <Gregory.Dietsche@cuw.edu>
Subject: [PATCH] dvb: remove unnecessary code
Date: Thu, 16 Jun 2011 11:33:35 -0500
Message-Id: <1308242015-28665-1-git-send-email-Gregory.Dietsche@cuw.edu>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

remove unnecessary code that matches this coccinelle pattern
	if (...)
		return ret;
	return ret;

Signed-off-by: Greg Dietsche <Gregory.Dietsche@cuw.edu>
---
 drivers/media/dvb/frontends/cx24116.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/drivers/media/dvb/frontends/cx24116.c b/drivers/media/dvb/frontends/cx24116.c
index 95c6465..ccd0525 100644
--- a/drivers/media/dvb/frontends/cx24116.c
+++ b/drivers/media/dvb/frontends/cx24116.c
@@ -1452,11 +1452,7 @@ tuned:  /* Set/Reset B/W */
 	cmd.args[0x00] = CMD_BANDWIDTH;
 	cmd.args[0x01] = 0x00;
 	cmd.len = 0x02;
-	ret = cx24116_cmd_execute(fe, &cmd);
-	if (ret != 0)
-		return ret;
-
-	return ret;
+	return cx24116_cmd_execute(fe, &cmd);
 }
 
 static int cx24116_tune(struct dvb_frontend *fe, struct dvb_frontend_parameters *params,
-- 
1.7.2.5

