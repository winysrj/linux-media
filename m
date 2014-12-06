Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:37631 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752339AbaLFVfN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 6 Dec 2014 16:35:13 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 09/22] si2168: add own goto label for kzalloc failure
Date: Sat,  6 Dec 2014 23:34:43 +0200
Message-Id: <1417901696-5517-9-git-send-email-crope@iki.fi>
In-Reply-To: <1417901696-5517-1-git-send-email-crope@iki.fi>
References: <1417901696-5517-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use own label for kzalloc failure in which does not call kfree().
kfree() could be called with NULL, but it is still better to have
own label which skips unnecessary kfree().

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/si2168.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
index b4a6096..1fab088 100644
--- a/drivers/media/dvb-frontends/si2168.c
+++ b/drivers/media/dvb-frontends/si2168.c
@@ -672,7 +672,7 @@ static int si2168_probe(struct i2c_client *client,
 	if (!dev) {
 		ret = -ENOMEM;
 		dev_err(&client->dev, "kzalloc() failed\n");
-		goto err_kfree;
+		goto err;
 	}
 
 	mutex_init(&dev->i2c_mutex);
@@ -700,6 +700,7 @@ static int si2168_probe(struct i2c_client *client,
 	return 0;
 err_kfree:
 	kfree(dev);
+err:
 	dev_dbg(&client->dev, "failed=%d\n", ret);
 	return ret;
 }
-- 
http://palosaari.fi/

