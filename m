Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:32788 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756598AbaGNRJV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Jul 2014 13:09:21 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Olli Salonen <olli.salonen@iki.fi>, Antti Palosaari <crope@iki.fi>
Subject: [PATCH 07/18] si2168: do not set values which are already on default
Date: Mon, 14 Jul 2014 20:08:48 +0300
Message-Id: <1405357739-3570-7-git-send-email-crope@iki.fi>
In-Reply-To: <1405357739-3570-1-git-send-email-crope@iki.fi>
References: <1405357739-3570-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

No need to set explicitly value that are already defaulted same.

Setting new value returns old value. Firmware default values can
be found just looking returned value.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/si2168.c | 98 ------------------------------------
 1 file changed, 98 deletions(-)

diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
index 432703c..666d428 100644
--- a/drivers/media/dvb-frontends/si2168.c
+++ b/drivers/media/dvb-frontends/si2168.c
@@ -249,27 +249,6 @@ static int si2168_set_frontend(struct dvb_frontend *fe)
 	if (ret)
 		goto err;
 
-	memcpy(cmd.args, "\x14\x00\x01\x04\x00\x00", 6);
-	cmd.wlen = 6;
-	cmd.rlen = 1;
-	ret = si2168_cmd_execute(s, &cmd);
-	if (ret)
-		goto err;
-
-	memcpy(cmd.args, "\x14\x00\x03\x10\x17\x00", 6);
-	cmd.wlen = 6;
-	cmd.rlen = 1;
-	ret = si2168_cmd_execute(s, &cmd);
-	if (ret)
-		goto err;
-
-	memcpy(cmd.args, "\x14\x00\x02\x10\x15\x00", 6);
-	cmd.wlen = 6;
-	cmd.rlen = 1;
-	ret = si2168_cmd_execute(s, &cmd);
-	if (ret)
-		goto err;
-
 	memcpy(cmd.args, "\x14\x00\x0c\x10\x12\x00", 6);
 	cmd.wlen = 6;
 	cmd.rlen = 1;
@@ -284,13 +263,6 @@ static int si2168_set_frontend(struct dvb_frontend *fe)
 	if (ret)
 		goto err;
 
-	memcpy(cmd.args, "\x14\x00\x0b\x10\x88\x13", 6);
-	cmd.wlen = 6;
-	cmd.rlen = 1;
-	ret = si2168_cmd_execute(s, &cmd);
-	if (ret)
-		goto err;
-
 	memcpy(cmd.args, "\x14\x00\x07\x10\x00\x24", 6);
 	cmd.wlen = 6;
 	cmd.rlen = 1;
@@ -306,20 +278,6 @@ static int si2168_set_frontend(struct dvb_frontend *fe)
 	if (ret)
 		goto err;
 
-	memcpy(cmd.args, "\x14\x00\x04\x10\x15\x00", 6);
-	cmd.wlen = 6;
-	cmd.rlen = 1;
-	ret = si2168_cmd_execute(s, &cmd);
-	if (ret)
-		goto err;
-
-	memcpy(cmd.args, "\x14\x00\x05\x10\xa1\x00", 6);
-	cmd.wlen = 6;
-	cmd.rlen = 1;
-	ret = si2168_cmd_execute(s, &cmd);
-	if (ret)
-		goto err;
-
 	memcpy(cmd.args, "\x14\x00\x0f\x10\x10\x00", 6);
 	cmd.wlen = 6;
 	cmd.rlen = 1;
@@ -327,13 +285,6 @@ static int si2168_set_frontend(struct dvb_frontend *fe)
 	if (ret)
 		goto err;
 
-	memcpy(cmd.args, "\x14\x00\x0d\x10\xd0\x02", 6);
-	cmd.wlen = 6;
-	cmd.rlen = 1;
-	ret = si2168_cmd_execute(s, &cmd);
-	if (ret)
-		goto err;
-
 	memcpy(cmd.args, "\x14\x00\x01\x10\x16\x00", 6);
 	cmd.wlen = 6;
 	cmd.rlen = 1;
@@ -355,55 +306,6 @@ static int si2168_set_frontend(struct dvb_frontend *fe)
 	if (ret)
 		goto err;
 
-	memcpy(cmd.args, "\x14\x00\x04\x03\x00\x00", 6);
-	cmd.wlen = 6;
-	cmd.rlen = 1;
-	ret = si2168_cmd_execute(s, &cmd);
-	if (ret)
-		goto err;
-
-	memcpy(cmd.args, "\x14\x00\x03\x03\x00\x00", 6);
-	cmd.wlen = 6;
-	cmd.rlen = 1;
-	ret = si2168_cmd_execute(s, &cmd);
-	if (ret)
-		goto err;
-
-	memcpy(cmd.args, "\x14\x00\x08\x03\x00\x00", 6);
-	cmd.wlen = 6;
-	cmd.rlen = 1;
-	ret = si2168_cmd_execute(s, &cmd);
-	if (ret)
-		goto err;
-
-	memcpy(cmd.args, "\x14\x00\x07\x03\x01\x02", 6);
-	cmd.wlen = 6;
-	cmd.rlen = 1;
-	ret = si2168_cmd_execute(s, &cmd);
-	if (ret)
-		goto err;
-
-	memcpy(cmd.args, "\x14\x00\x06\x03\x00\x00", 6);
-	cmd.wlen = 6;
-	cmd.rlen = 1;
-	ret = si2168_cmd_execute(s, &cmd);
-	if (ret)
-		goto err;
-
-	memcpy(cmd.args, "\x14\x00\x05\x03\x00\x00", 6);
-	cmd.wlen = 6;
-	cmd.rlen = 1;
-	ret = si2168_cmd_execute(s, &cmd);
-	if (ret)
-		goto err;
-
-	memcpy(cmd.args, "\x14\x00\x01\x03\x0c\x40", 6);
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

