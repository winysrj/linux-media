Return-path: <linux-media-owner@vger.kernel.org>
Received: from 108-197-250-228.lightspeed.miamfl.sbcglobal.net ([108.197.250.228]:38382
	"EHLO usa.attlocal.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752961AbcGYSjD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jul 2016 14:39:03 -0400
From: Abylay Ospan <aospan@netup.ru>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Cc: Abylay Ospan <aospan@netup.ru>
Subject: [PATCH] [media] lgdt3306a: remove 20*50 msec unnecessary timeout
Date: Mon, 25 Jul 2016 14:38:59 -0400
Message-Id: <1469471939-25393-1-git-send-email-aospan@netup.ru>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

inside lgdt3306a_search we reading demod status 20 times with 50 msec sleep after each read.
This gives us more than 1 sec of delay. Removing this delay should not affect demod functionality.

Signed-off-by: Abylay Ospan <aospan@netup.ru>
---
 drivers/media/dvb-frontends/lgdt3306a.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/media/dvb-frontends/lgdt3306a.c b/drivers/media/dvb-frontends/lgdt3306a.c
index 179c26e..dad7ad3 100644
--- a/drivers/media/dvb-frontends/lgdt3306a.c
+++ b/drivers/media/dvb-frontends/lgdt3306a.c
@@ -1737,24 +1737,16 @@ static int lgdt3306a_get_tune_settings(struct dvb_frontend *fe,
 static int lgdt3306a_search(struct dvb_frontend *fe)
 {
 	enum fe_status status = 0;
-	int i, ret;
+	int ret;
 
 	/* set frontend */
 	ret = lgdt3306a_set_parameters(fe);
 	if (ret)
 		goto error;
 
-	/* wait frontend lock */
-	for (i = 20; i > 0; i--) {
-		dbg_info(": loop=%d\n", i);
-		msleep(50);
-		ret = lgdt3306a_read_status(fe, &status);
-		if (ret)
-			goto error;
-
-		if (status & FE_HAS_LOCK)
-			break;
-	}
+	ret = lgdt3306a_read_status(fe, &status);
+	if (ret)
+		goto error;
 
 	/* check if we have a valid signal */
 	if (status & FE_HAS_LOCK)
-- 
2.7.4

