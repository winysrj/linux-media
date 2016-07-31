Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:33300 "EHLO
	mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100AbcGaD6G (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 30 Jul 2016 23:58:06 -0400
Date: Sun, 31 Jul 2016 09:28:00 +0530
From: Amitoj Kaur Chawla <amitoj1606@gmail.com>
To: sakari.ailus@iki.fi, mchehab@osg.samsung.com,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH] i2c: Modify error handling
Message-ID: <20160731035800.GA4576@amitoj-Inspiron-3542>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

devm_gpiod_get returns an ERR_PTR on error so a null check is
incorrect and an IS_ERR check is required.

The Coccinelle semantic patch used to make this change is as follows:
@@
expression e;
statement S;
@@

  e = devm_gpiod_get(...);
 if(
-   !e
+   IS_ERR(e)
   )
  {
   ...
-  return ...;
+  return PTR_ERR(e);
  }

Signed-off-by: Amitoj Kaur Chawla <amitoj1606@gmail.com>
---
 drivers/media/i2c/adp1653.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/adp1653.c b/drivers/media/i2c/adp1653.c
index 7e9cbf7..54b355e 100644
--- a/drivers/media/i2c/adp1653.c
+++ b/drivers/media/i2c/adp1653.c
@@ -466,9 +466,9 @@ static int adp1653_of_init(struct i2c_client *client,
 	of_node_put(child);
 
 	pd->enable_gpio = devm_gpiod_get(&client->dev, "enable", GPIOD_OUT_LOW);
-	if (!pd->enable_gpio) {
+	if (IS_ERR(pd->enable_gpio)) {
 		dev_err(&client->dev, "Error getting GPIO\n");
-		return -EINVAL;
+		return PTR_ERR(pd->enable_gpio);
 	}
 
 	return 0;
-- 
1.9.1

