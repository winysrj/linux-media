Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48606 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754239AbcJNRrE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 13:47:04 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH 09/25] [media] tuner-core: use %&ph for small buffer dumps
Date: Fri, 14 Oct 2016 14:45:47 -0300
Message-Id: <fb55adb62d169e796dbfe09a5b169c37c5eb7ccb.1476466574.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476466574.git.mchehab@s-opensource.com>
References: <cover.1476466574.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476466574.git.mchehab@s-opensource.com>
References: <cover.1476466574.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This driver has a printk with a continuation lines for debugging purposes.
 Since commit 563873318d32 ("Merge branch 'printk-cleanups'"), this
won't work anymore. We might be using KERNEL_CONT, but it is better
to just use a single printk line using %*ph for buffer dump.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/v4l2-core/tuner-core.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/media/v4l2-core/tuner-core.c b/drivers/media/v4l2-core/tuner-core.c
index e2613ecb7605..d3a6236b6b02 100644
--- a/drivers/media/v4l2-core/tuner-core.c
+++ b/drivers/media/v4l2-core/tuner-core.c
@@ -617,14 +617,12 @@ static int tuner_probe(struct i2c_client *client,
 
 	if (show_i2c) {
 		unsigned char buffer[16];
-		int i, rc;
+		int rc;
 
 		memset(buffer, 0, sizeof(buffer));
 		rc = i2c_master_recv(client, buffer, sizeof(buffer));
-		tuner_info("I2C RECV = ");
-		for (i = 0; i < rc; i++)
-			printk(KERN_CONT "%02x ", buffer[i]);
-		printk("\n");
+		if (rc >= 0)
+			tuner_info("I2C RECV = %*ph\n", rc, buffer);
 	}
 
 	/* autodetection code based on the i2c addr */
-- 
2.7.4


