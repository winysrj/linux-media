Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:33368 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752227AbaLFVfN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 6 Dec 2014 16:35:13 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 05/22] si2168: simplify si2168_cmd_execute() error path
Date: Sat,  6 Dec 2014 23:34:39 +0200
Message-Id: <1417901696-5517-5-git-send-email-crope@iki.fi>
In-Reply-To: <1417901696-5517-1-git-send-email-crope@iki.fi>
References: <1417901696-5517-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove if () from firmware command error path as there should not be
any error prone conditional logic there. Use goto labels instead.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/si2168.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
index db06bb7..2df3a27 100644
--- a/drivers/media/dvb-frontends/si2168.c
+++ b/drivers/media/dvb-frontends/si2168.c
@@ -66,15 +66,11 @@ static int si2168_cmd_execute(struct i2c_client *client, struct si2168_cmd *cmd)
 		}
 	}
 
-	ret = 0;
+	mutex_unlock(&dev->i2c_mutex);
+	return 0;
 
 err_mutex_unlock:
 	mutex_unlock(&dev->i2c_mutex);
-	if (ret)
-		goto err;
-
-	return 0;
-err:
 	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
-- 
http://palosaari.fi/

