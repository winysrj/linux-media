Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:54377 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752277AbaLFVfN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 6 Dec 2014 16:35:13 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 07/22] si2168: change firmware version print from debug to info
Date: Sat,  6 Dec 2014 23:34:41 +0200
Message-Id: <1417901696-5517-7-git-send-email-crope@iki.fi>
In-Reply-To: <1417901696-5517-1-git-send-email-crope@iki.fi>
References: <1417901696-5517-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Even firmware version is not needed to know, it is still interesting
and useful to know some cases. Due to that increase its printing to
info log level.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/si2168.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
index a9486ef..e51676c 100644
--- a/drivers/media/dvb-frontends/si2168.c
+++ b/drivers/media/dvb-frontends/si2168.c
@@ -504,7 +504,7 @@ static int si2168_init(struct dvb_frontend *fe)
 	if (ret)
 		goto err;
 
-	dev_dbg(&client->dev, "firmware version: %c.%c.%d\n",
+	dev_info(&client->dev, "firmware version: %c.%c.%d\n",
 			cmd.args[6], cmd.args[7], cmd.args[8]);
 
 	/* set ts mode */
-- 
http://palosaari.fi/

