Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f180.google.com ([209.85.217.180]:47283 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792AbaK0Tmd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Nov 2014 14:42:33 -0500
Received: by mail-lb0-f180.google.com with SMTP id l4so4491676lbv.25
        for <linux-media@vger.kernel.org>; Thu, 27 Nov 2014 11:42:32 -0800 (PST)
From: Olli Salonen <olli.salonen@iki.fi>
To: linux-media@vger.kernel.org
Cc: Olli Salonen <olli.salonen@iki.fi>
Subject: [PATCH 1/2] si2168: debug printout for firmware version
Date: Thu, 27 Nov 2014 21:42:22 +0200
Message-Id: <1417117343-1793-1-git-send-email-olli.salonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A debug printout for firmware version.

Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
---
 drivers/media/dvb-frontends/si2168.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
index bec3aa5..6da38e8 100644
--- a/drivers/media/dvb-frontends/si2168.c
+++ b/drivers/media/dvb-frontends/si2168.c
@@ -489,6 +489,17 @@ static int si2168_init(struct dvb_frontend *fe)
 	if (ret)
 		goto err;
 
+	/* query firmware version */
+	memcpy(cmd.args, "\x11", 1);
+	cmd.wlen = 1;
+	cmd.rlen = 10;
+	ret = si2168_cmd_execute(s, &cmd);
+	if (ret)
+		goto err;
+
+	dev_dbg(&s->client->dev, "firmware version: %c.%c.%d\n",
+			cmd.args[6], cmd.args[7], cmd.args[8]);
+
 	/* set ts mode */
 	memcpy(cmd.args, "\x14\x00\x01\x10\x10\x00", 6);
 	cmd.args[4] |= s->ts_mode;
-- 
1.9.1

