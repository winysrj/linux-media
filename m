Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.bredband2.com ([83.219.192.166]:38561 "EHLO
	smtp.bredband2.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227AbaLFAZn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Dec 2014 19:25:43 -0500
Received: from localhost.localdomain (92-244-23-216.customers.ownit.se [92.244.23.216])
	(Authenticated sender: ed8153)
	by smtp.bredband2.com (Postfix) with ESMTPA id 0B16C61BB1
	for <linux-media@vger.kernel.org>; Sat,  6 Dec 2014 01:25:33 +0100 (CET)
From: Benjamin Larsson <benjamin@southpole.se>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/3] mn88472: make sure the private data struct is nulled after free
Date: Sat,  6 Dec 2014 01:25:32 +0100
Message-Id: <1417825533-13081-2-git-send-email-benjamin@southpole.se>
In-Reply-To: <1417825533-13081-1-git-send-email-benjamin@southpole.se>
References: <1417825533-13081-1-git-send-email-benjamin@southpole.se>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Using this driver with the attach dvb model might trigger a use
after free when unloading the driver. With this change the driver
will always fail on unload instead of randomly crash depending
on if the memory has been reused or not.

Signed-off-by: Benjamin Larsson <benjamin@southpole.se>
---
 drivers/staging/media/mn88472/mn88472.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/media/mn88472/mn88472.c b/drivers/staging/media/mn88472/mn88472.c
index 36ef39b..a9d5f0a 100644
--- a/drivers/staging/media/mn88472/mn88472.c
+++ b/drivers/staging/media/mn88472/mn88472.c
@@ -489,6 +489,7 @@ static int mn88472_remove(struct i2c_client *client)
 
 	regmap_exit(dev->regmap[0]);
 
+	memset(dev, 0, sizeof(*dev));
 	kfree(dev);
 
 	return 0;
-- 
1.9.1

