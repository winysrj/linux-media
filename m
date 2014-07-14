Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:33459 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756318AbaGNRJU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Jul 2014 13:09:20 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Olli Salonen <olli.salonen@iki.fi>, Antti Palosaari <crope@iki.fi>
Subject: [PATCH 03/18] si2168: set cmd args using memcpy
Date: Mon, 14 Jul 2014 20:08:44 +0300
Message-Id: <1405357739-3570-3-git-send-email-crope@iki.fi>
In-Reply-To: <1405357739-3570-1-git-send-email-crope@iki.fi>
References: <1405357739-3570-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use memcpy for set cmd buffer in order to keep style in line with
rest of file.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/si2168.c | 39 ++++++++----------------------------
 1 file changed, 8 insertions(+), 31 deletions(-)

diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
index 13cf2a8..78af598 100644
--- a/drivers/media/dvb-frontends/si2168.c
+++ b/drivers/media/dvb-frontends/si2168.c
@@ -95,20 +95,17 @@ static int si2168_read_status(struct dvb_frontend *fe, fe_status_t *status)
 
 	switch (c->delivery_system) {
 	case SYS_DVBT:
-		cmd.args[0] = 0xa0;
-		cmd.args[1] = 0x01;
+		memcpy(cmd.args, "\xa0\x01", 2);
 		cmd.wlen = 2;
 		cmd.rlen = 13;
 		break;
 	case SYS_DVBC_ANNEX_A:
-		cmd.args[0] = 0x90;
-		cmd.args[1] = 0x01;
+		memcpy(cmd.args, "\x90\x01", 2);
 		cmd.wlen = 2;
 		cmd.rlen = 9;
 		break;
 	case SYS_DVBT2:
-		cmd.args[0] = 0x50;
-		cmd.args[1] = 0x01;
+		memcpy(cmd.args, "\x50\x01", 2);
 		cmd.wlen = 2;
 		cmd.rlen = 14;
 		break;
@@ -412,7 +409,7 @@ static int si2168_set_frontend(struct dvb_frontend *fe)
 	if (ret)
 		goto err;
 
-	cmd.args[0] = 0x85;
+	memcpy(cmd.args, "\x85", 1);
 	cmd.wlen = 1;
 	cmd.rlen = 1;
 	ret = si2168_cmd_execute(s, &cmd);
@@ -438,40 +435,21 @@ static int si2168_init(struct dvb_frontend *fe)
 
 	dev_dbg(&s->client->dev, "%s:\n", __func__);
 
-	cmd.args[0] = 0xc0;
-	cmd.args[1] = 0x12;
-	cmd.args[2] = 0x00;
-	cmd.args[3] = 0x0c;
-	cmd.args[4] = 0x00;
-	cmd.args[5] = 0x0d;
-	cmd.args[6] = 0x16;
-	cmd.args[7] = 0x00;
-	cmd.args[8] = 0x00;
-	cmd.args[9] = 0x00;
-	cmd.args[10] = 0x00;
-	cmd.args[11] = 0x00;
-	cmd.args[12] = 0x00;
+	memcpy(cmd.args, "\xc0\x12\x00\x0c\x00\x0d\x16\x00\x00\x00\x00\x00\x00", 13);
 	cmd.wlen = 13;
 	cmd.rlen = 0;
 	ret = si2168_cmd_execute(s, &cmd);
 	if (ret)
 		goto err;
 
-	cmd.args[0] = 0xc0;
-	cmd.args[1] = 0x06;
-	cmd.args[2] = 0x01;
-	cmd.args[3] = 0x0f;
-	cmd.args[4] = 0x00;
-	cmd.args[5] = 0x20;
-	cmd.args[6] = 0x20;
-	cmd.args[7] = 0x01;
+	memcpy(cmd.args, "\xc0\x06\x01\x0f\x00\x20\x20\x01", 8);
 	cmd.wlen = 8;
 	cmd.rlen = 1;
 	ret = si2168_cmd_execute(s, &cmd);
 	if (ret)
 		goto err;
 
-	cmd.args[0] = 0x02;
+	memcpy(cmd.args, "\x02", 1);
 	cmd.wlen = 1;
 	cmd.rlen = 13;
 	ret = si2168_cmd_execute(s, &cmd);
@@ -513,8 +491,7 @@ static int si2168_init(struct dvb_frontend *fe)
 	release_firmware(fw);
 	fw = NULL;
 
-	cmd.args[0] = 0x01;
-	cmd.args[1] = 0x01;
+	memcpy(cmd.args, "\x01\x01", 2);
 	cmd.wlen = 2;
 	cmd.rlen = 1;
 	ret = si2168_cmd_execute(s, &cmd);
-- 
1.9.3

