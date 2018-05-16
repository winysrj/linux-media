Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:41335 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750791AbeEPPVX (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 May 2018 11:21:23 -0400
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH] media: dw9807: remove an unused var
Date: Wed, 16 May 2018 11:21:17 -0400
Message-Id: <7e6b6b945272c20f6b78d319e07f27897a8373c9.1526484075.git.mchehab+samsung@kernel.org>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/i2c/dw9807.c: In function 'dw9807_set_dac':
drivers/media/i2c/dw9807.c:81:16: warning: unused variable 'retry' [-Wunused-variable]
  int val, ret, retry = 0;
                ^

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/i2c/dw9807.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/dw9807.c b/drivers/media/i2c/dw9807.c
index 28ede2b47acf..6ebb98717fb1 100644
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
2.17.0
