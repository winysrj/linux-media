Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:9158 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750772AbeEPPTW (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 May 2018 11:19:22 -0400
From: Andy Yeh <andy.yeh@intel.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@linux.intel.com, andy.yeh@intel.com,
        tfiga@chromium.org, alanx.chiang@intel.com
Subject: [PATCH] media: dw9807: Fix a warning: unused variable 'retry'
Date: Wed, 16 May 2018 23:27:42 +0800
Message-Id: <1526484462-10256-1-git-send-email-andy.yeh@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix a warning reported by compiler, along with an incremental patch.
---
 drivers/media/i2c/dw9807.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/dw9807.c b/drivers/media/i2c/dw9807.c
index 28ede2b..6ebb987 100644
--- a/drivers/media/i2c/dw9807.c
+++ b/drivers/media/i2c/dw9807.c
@@ -78,7 +78,7 @@ static int dw9807_set_dac(struct i2c_client *client, u16 data)
 	const char tx_data[3] = {
 		DW9807_MSB_ADDR, ((data >> 8) & 0x03), (data & 0xff)
 	};
-	int val, ret, retry = 0;
+	int val, ret;
 
 	/*
 	 * According to the datasheet, need to check the bus status before we
-- 
2.7.4
