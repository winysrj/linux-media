Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:7962 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750726AbaBLJCN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Feb 2014 04:02:13 -0500
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org,
	Daniel Jeong <gshark.jeong@gmail.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 3/3] lm3560: prevent memory leak in case of pdata absence
Date: Wed, 12 Feb 2014 11:02:07 +0200
Message-Id: <1392195727-1494-3-git-send-email-andriy.shevchenko@linux.intel.com>
In-Reply-To: <1392195727-1494-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1392195727-1494-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If we have no pdata defined and driver fails to register we leak memory.
Converting to devm_kzalloc prevents this to happen.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/media/i2c/lm3560.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/i2c/lm3560.c b/drivers/media/i2c/lm3560.c
index 93e5227..c23de59 100644
--- a/drivers/media/i2c/lm3560.c
+++ b/drivers/media/i2c/lm3560.c
@@ -416,8 +416,7 @@ static int lm3560_probe(struct i2c_client *client,
 
 	/* if there is no platform data, use chip default value */
 	if (pdata == NULL) {
-		pdata =
-		    kzalloc(sizeof(struct lm3560_platform_data), GFP_KERNEL);
+		pdata = devm_kzalloc(&client->dev, sizeof(*pdata), GFP_KERNEL);
 		if (pdata == NULL)
 			return -ENODEV;
 		pdata->peak = LM3560_PEAK_3600mA;
-- 
1.9.0.rc3

