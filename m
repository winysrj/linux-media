Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:45020 "EHLO
        homiemail-a68.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S934138AbeALQUF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 12 Jan 2018 11:20:05 -0500
From: Brad Love <brad@nextdimension.cc>
To: linux-media@vger.kernel.org
Cc: Brad Love <brad@nextdimension.cc>
Subject: [PATCH 6/7] si2168: Announce frontend creation failure
Date: Fri, 12 Jan 2018 10:19:40 -0600
Message-Id: <1515773982-6411-6-git-send-email-brad@nextdimension.cc>
In-Reply-To: <1515773982-6411-1-git-send-email-brad@nextdimension.cc>
References: <1515773982-6411-1-git-send-email-brad@nextdimension.cc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The driver outputs on success, but is silent on failure. Give
one message that probe failed.

Signed-off-by: Brad Love <brad@nextdimension.cc>
---
 drivers/media/dvb-frontends/si2168.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
index 429c03a..c1a638c 100644
--- a/drivers/media/dvb-frontends/si2168.c
+++ b/drivers/media/dvb-frontends/si2168.c
@@ -810,7 +810,7 @@ static int si2168_probe(struct i2c_client *client,
 err_kfree:
 	kfree(dev);
 err:
-	dev_dbg(&client->dev, "failed=%d\n", ret);
+	dev_warn(&client->dev, "probe failed = %d\n", ret);
 	return ret;
 }
 
-- 
2.7.4
