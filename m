Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:51633 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752514AbaLFVfP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 6 Dec 2014 16:35:15 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 19/22] si2157: add own goto label for kfree() on probe error
Date: Sat,  6 Dec 2014 23:34:53 +0200
Message-Id: <1417901696-5517-19-git-send-email-crope@iki.fi>
In-Reply-To: <1417901696-5517-1-git-send-email-crope@iki.fi>
References: <1417901696-5517-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use own goto label for error case mem free is needed, even kfree could
be called with NULL. I think it is better to have it, even not required.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/si2157.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/tuners/si2157.c b/drivers/media/tuners/si2157.c
index 211d500..3f9aa7a 100644
--- a/drivers/media/tuners/si2157.c
+++ b/drivers/media/tuners/si2157.c
@@ -353,7 +353,7 @@ static int si2157_probe(struct i2c_client *client,
 	cmd.rlen = 1;
 	ret = si2157_cmd_execute(client, &cmd);
 	if (ret)
-		goto err;
+		goto err_kfree;
 
 	memcpy(&fe->ops.tuner_ops, &si2157_ops, sizeof(struct dvb_tuner_ops));
 	fe->tuner_priv = client;
@@ -363,9 +363,11 @@ static int si2157_probe(struct i2c_client *client,
 			"Si2146" : "Si2147/2148/2157/2158");
 
 	return 0;
+
+err_kfree:
+	kfree(dev);
 err:
 	dev_dbg(&client->dev, "failed=%d\n", ret);
-	kfree(dev);
 	return ret;
 }
 
-- 
http://palosaari.fi/

