Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:51148 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753727AbaIEJXo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Sep 2014 05:23:44 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>, Olli Salonen <olli.salonen@iki.fi>
Subject: [PATCH] si2157: sleep hack
Date: Fri,  5 Sep 2014 12:23:23 +0300
Message-Id: <1409909003-29730-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Olli could you test that?

Cc: Olli Salonen <olli.salonen@iki.fi>
---
 drivers/media/dvb-frontends/si2168.c |  4 ++--
 drivers/media/tuners/si2157.c        | 14 ++++++++++++--
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
index a0797fd..6c00052 100644
--- a/drivers/media/dvb-frontends/si2168.c
+++ b/drivers/media/dvb-frontends/si2168.c
@@ -379,14 +379,14 @@ static int si2168_init(struct dvb_frontend *fe)
 		ret = si2168_cmd_execute(s, &cmd);
 		if (ret)
 			goto err;
-
+#if 1
 		memcpy(cmd.args, "\x85", 1);
 		cmd.wlen = 1;
 		cmd.rlen = 1;
 		ret = si2168_cmd_execute(s, &cmd);
 		if (ret)
 			goto err;
-
+#endif
 		goto warm;
 	}
 
diff --git a/drivers/media/tuners/si2157.c b/drivers/media/tuners/si2157.c
index 5901484..1bbcb51 100644
--- a/drivers/media/tuners/si2157.c
+++ b/drivers/media/tuners/si2157.c
@@ -89,17 +89,22 @@ static int si2157_init(struct dvb_frontend *fe)
 
 	dev_dbg(&s->client->dev, "\n");
 
-	if (s->fw_loaded)
-		goto warm;
+//	if (s->fw_loaded)
+//		goto warm;
 
 	/* power up */
 	memcpy(cmd.args, "\xc0\x00\x0c\x00\x00\x01\x01\x01\x01\x01\x01\x02\x00\x00\x01", 15);
+	if (s->fw_loaded)
+		memcpy(cmd.args, "\xc0\x00\x0c\x00\x00\x01\x01\x01\x01\x01\x01\x02\x00\x01\x01", 15);
 	cmd.wlen = 15;
 	cmd.rlen = 1;
 	ret = si2157_cmd_execute(s, &cmd);
 	if (ret)
 		goto err;
 
+	if (s->fw_loaded)
+		goto warm;
+
 	/* query chip revision */
 	memcpy(cmd.args, "\x02", 1);
 	cmd.wlen = 1;
@@ -203,10 +208,15 @@ static int si2157_sleep(struct dvb_frontend *fe)
 
 	s->active = false;
 
+	memcpy(cmd.args, "\x13", 1);
+	cmd.wlen = 1;
+	cmd.rlen = 0;
+#if 0
 	/* standby */
 	memcpy(cmd.args, "\x16\x00", 2);
 	cmd.wlen = 2;
 	cmd.rlen = 1;
+#endif
 	ret = si2157_cmd_execute(s, &cmd);
 	if (ret)
 		goto err;
-- 
http://palosaari.fi/

