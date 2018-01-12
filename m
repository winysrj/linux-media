Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:45033 "EHLO
        homiemail-a68.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S934145AbeALQUF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 12 Jan 2018 11:20:05 -0500
From: Brad Love <brad@nextdimension.cc>
To: linux-media@vger.kernel.org
Cc: Brad Love <brad@nextdimension.cc>
Subject: [PATCH 5/7] lgdt3306a: Announce successful creation
Date: Fri, 12 Jan 2018 10:19:41 -0600
Message-Id: <1515773982-6411-7-git-send-email-brad@nextdimension.cc>
In-Reply-To: <1515773982-6411-1-git-send-email-brad@nextdimension.cc>
References: <1515773982-6411-1-git-send-email-brad@nextdimension.cc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The driver is near silent, this adds a simple announcement at the
end of probe after the chip has been detected and upgrades a debug
message to error if probe has failed.

Signed-off-by: Brad Love <brad@nextdimension.cc>
---
 drivers/media/dvb-frontends/lgdt3306a.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/lgdt3306a.c b/drivers/media/dvb-frontends/lgdt3306a.c
index 3642e6e..ec7d04d 100644
--- a/drivers/media/dvb-frontends/lgdt3306a.c
+++ b/drivers/media/dvb-frontends/lgdt3306a.c
@@ -2202,6 +2202,8 @@ static int lgdt3306a_probe(struct i2c_client *client,
 	*config->i2c_adapter = state->muxc->adapter[0];
 	*config->fe = fe;
 
+	dev_info(&client->dev, "LG Electronics LGDT3306A successfully identified\n");
+
 	return 0;
 
 err_kfree:
@@ -2209,7 +2211,7 @@ static int lgdt3306a_probe(struct i2c_client *client,
 err_fe:
 	kfree(config);
 fail:
-	dev_dbg(&client->dev, "failed=%d\n", ret);
+	dev_warn(&client->dev, "probe failed = %d\n", ret);
 	return ret;
 }
 
-- 
2.7.4
