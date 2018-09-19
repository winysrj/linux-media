Return-path: <linux-media-owner@vger.kernel.org>
Received: from szxga07-in.huawei.com ([45.249.212.35]:57076 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726044AbeISLPZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Sep 2018 07:15:25 -0400
From: zhong jiang <zhongjiang@huawei.com>
To: <mchehab@kernel.org>, <mkrufky@linuxtv.org>
CC: <brad@nextdimension.cc>, <linux-media@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCHv2] media: dvb-frontends: Use kmemdup instead of duplicating its function
Date: Wed, 19 Sep 2018 13:26:43 +0800
Message-ID: <1537334803-32592-1-git-send-email-zhongjiang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

kmemdup has implemented the function that kmalloc() + memcpy().
We prefer to kmemdup rather than code opened implementation.

Signed-off-by: zhong jiang <zhongjiang@huawei.com>
---
 drivers/media/dvb-frontends/lgdt3306a.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb-frontends/lgdt3306a.c b/drivers/media/dvb-frontends/lgdt3306a.c
index 0e1f5da..7547bb0 100644
--- a/drivers/media/dvb-frontends/lgdt3306a.c
+++ b/drivers/media/dvb-frontends/lgdt3306a.c
@@ -2205,15 +2205,13 @@ static int lgdt3306a_probe(struct i2c_client *client,
 	struct dvb_frontend *fe;
 	int ret;
 
-	config = kzalloc(sizeof(struct lgdt3306a_config), GFP_KERNEL);
+	config = kmemdup(client->dev.platform_data,
+			sizeof(struct lgdt3306a_config), GFP_KERNEL);
 	if (config == NULL) {
 		ret = -ENOMEM;
 		goto fail;
 	}
 
-	memcpy(config, client->dev.platform_data,
-			sizeof(struct lgdt3306a_config));
-
 	config->i2c_addr = client->addr;
 	fe = lgdt3306a_attach(config, client->adapter);
 	if (fe == NULL) {
-- 
1.7.12.4
