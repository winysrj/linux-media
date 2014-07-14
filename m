Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:44525 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756490AbaGNRJV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Jul 2014 13:09:21 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Olli Salonen <olli.salonen@iki.fi>, Antti Palosaari <crope@iki.fi>
Subject: [PATCH 06/18] si2168: remove duplicate command
Date: Mon, 14 Jul 2014 20:08:47 +0300
Message-Id: <1405357739-3570-6-git-send-email-crope@iki.fi>
In-Reply-To: <1405357739-3570-1-git-send-email-crope@iki.fi>
References: <1405357739-3570-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Same command was executed twice, but different value. Remove
redundant command.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/si2168.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
index bfd7525..432703c 100644
--- a/drivers/media/dvb-frontends/si2168.c
+++ b/drivers/media/dvb-frontends/si2168.c
@@ -334,7 +334,7 @@ static int si2168_set_frontend(struct dvb_frontend *fe)
 	if (ret)
 		goto err;
 
-	memcpy(cmd.args, "\x14\x00\x01\x10\x00\x00", 6);
+	memcpy(cmd.args, "\x14\x00\x01\x10\x16\x00", 6);
 	cmd.wlen = 6;
 	cmd.rlen = 1;
 	ret = si2168_cmd_execute(s, &cmd);
@@ -404,13 +404,6 @@ static int si2168_set_frontend(struct dvb_frontend *fe)
 	if (ret)
 		goto err;
 
-	memcpy(cmd.args, "\x14\x00\x01\x10\x16\x00", 6);
-	cmd.wlen = 6;
-	cmd.rlen = 1;
-	ret = si2168_cmd_execute(s, &cmd);
-	if (ret)
-		goto err;
-
 	memcpy(cmd.args, "\x14\x00\x01\x12\x00\x00", 6);
 	cmd.wlen = 6;
 	cmd.rlen = 1;
-- 
1.9.3

