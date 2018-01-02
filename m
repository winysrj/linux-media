Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:11898 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751380AbeABLNj (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 2 Jan 2018 06:13:39 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: rajmohan.mani@intel.com
Subject: [RESEND PATCH 1/2] dw9714: Call pm_runtime_idle() at the end of probe()
Date: Tue,  2 Jan 2018 13:12:11 +0200
Message-Id: <1514891532-19348-2-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1514891532-19348-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1514891532-19348-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Call pm_runtime_idle() at the end of the driver's probe() function to
enable the device to reach low power state once probe() finishes.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/dw9714.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/i2c/dw9714.c b/drivers/media/i2c/dw9714.c
index ed01e8b..7832210 100644
--- a/drivers/media/i2c/dw9714.c
+++ b/drivers/media/i2c/dw9714.c
@@ -183,6 +183,7 @@ static int dw9714_probe(struct i2c_client *client)
 
 	pm_runtime_set_active(&client->dev);
 	pm_runtime_enable(&client->dev);
+	pm_runtime_idle(&client->dev);
 
 	return 0;
 
-- 
2.7.4
