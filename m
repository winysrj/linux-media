Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:48612 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756717AbaGNRJV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Jul 2014 13:09:21 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Olli Salonen <olli.salonen@iki.fi>, Antti Palosaari <crope@iki.fi>
Subject: [PATCH 08/18] si2168: receive 4 bytes reply from cmd 0x14
Date: Mon, 14 Jul 2014 20:08:49 +0300
Message-Id: <1405357739-3570-8-git-send-email-crope@iki.fi>
In-Reply-To: <1405357739-3570-1-git-send-email-crope@iki.fi>
References: <1405357739-3570-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Command 0x14 returns 4 bytes as a reply. It is used for setting
key/value pairs to firmware and it returns 4 bytes back including
old value.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/si2168.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
index 666d428..bae7771 100644
--- a/drivers/media/dvb-frontends/si2168.c
+++ b/drivers/media/dvb-frontends/si2168.c
@@ -251,21 +251,21 @@ static int si2168_set_frontend(struct dvb_frontend *fe)
 
 	memcpy(cmd.args, "\x14\x00\x0c\x10\x12\x00", 6);
 	cmd.wlen = 6;
-	cmd.rlen = 1;
+	cmd.rlen = 4;
 	ret = si2168_cmd_execute(s, &cmd);
 	if (ret)
 		goto err;
 
 	memcpy(cmd.args, "\x14\x00\x06\x10\x24\x00", 6);
 	cmd.wlen = 6;
-	cmd.rlen = 1;
+	cmd.rlen = 4;
 	ret = si2168_cmd_execute(s, &cmd);
 	if (ret)
 		goto err;
 
 	memcpy(cmd.args, "\x14\x00\x07\x10\x00\x24", 6);
 	cmd.wlen = 6;
-	cmd.rlen = 1;
+	cmd.rlen = 4;
 	ret = si2168_cmd_execute(s, &cmd);
 	if (ret)
 		goto err;
@@ -273,42 +273,42 @@ static int si2168_set_frontend(struct dvb_frontend *fe)
 	memcpy(cmd.args, "\x14\x00\x0a\x10\x00\x00", 6);
 	cmd.args[4] = delivery_system | bandwidth;
 	cmd.wlen = 6;
-	cmd.rlen = 1;
+	cmd.rlen = 4;
 	ret = si2168_cmd_execute(s, &cmd);
 	if (ret)
 		goto err;
 
 	memcpy(cmd.args, "\x14\x00\x0f\x10\x10\x00", 6);
 	cmd.wlen = 6;
-	cmd.rlen = 1;
+	cmd.rlen = 4;
 	ret = si2168_cmd_execute(s, &cmd);
 	if (ret)
 		goto err;
 
 	memcpy(cmd.args, "\x14\x00\x01\x10\x16\x00", 6);
 	cmd.wlen = 6;
-	cmd.rlen = 1;
+	cmd.rlen = 4;
 	ret = si2168_cmd_execute(s, &cmd);
 	if (ret)
 		goto err;
 
 	memcpy(cmd.args, "\x14\x00\x09\x10\xe3\x18", 6);
 	cmd.wlen = 6;
-	cmd.rlen = 1;
+	cmd.rlen = 4;
 	ret = si2168_cmd_execute(s, &cmd);
 	if (ret)
 		goto err;
 
 	memcpy(cmd.args, "\x14\x00\x08\x10\xd7\x15", 6);
 	cmd.wlen = 6;
-	cmd.rlen = 1;
+	cmd.rlen = 4;
 	ret = si2168_cmd_execute(s, &cmd);
 	if (ret)
 		goto err;
 
 	memcpy(cmd.args, "\x14\x00\x01\x12\x00\x00", 6);
 	cmd.wlen = 6;
-	cmd.rlen = 1;
+	cmd.rlen = 4;
 	ret = si2168_cmd_execute(s, &cmd);
 	if (ret)
 		goto err;
-- 
1.9.3

