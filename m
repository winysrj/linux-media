Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway23.websitewelcome.com ([192.185.49.104]:43060 "EHLO
        gateway23.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750912AbdBUEMg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Feb 2017 23:12:36 -0500
Received: from cm3.websitewelcome.com (unknown [108.167.139.23])
        by gateway23.websitewelcome.com (Postfix) with ESMTP id 6C955174A1
        for <linux-media@vger.kernel.org>; Mon, 20 Feb 2017 21:47:00 -0600 (CST)
Date: Mon, 20 Feb 2017 21:46:58 -0600
From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
To: mchehab@kernel.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>,
        Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH 1/2] media: pci: saa7164: remove unnecessary code
Message-ID: <20170221034657.GA4757@embeddedgus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove unnecessary variable 'loop'.

Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
---
 drivers/media/pci/saa7164/saa7164-cmd.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/pci/saa7164/saa7164-cmd.c b/drivers/media/pci/saa7164/saa7164-cmd.c
index 45951b3..169c90a 100644
--- a/drivers/media/pci/saa7164/saa7164-cmd.c
+++ b/drivers/media/pci/saa7164/saa7164-cmd.c
@@ -134,14 +134,13 @@ int saa7164_irq_dequeue(struct saa7164_dev *dev)
  * -bus/c running buffer. */
 static int saa7164_cmd_dequeue(struct saa7164_dev *dev)
 {
-	int loop = 1;
 	int ret;
 	u32 timeout;
 	wait_queue_head_t *q = NULL;
 	u8 tmp[512];
 	dprintk(DBGLVL_CMD, "%s()\n", __func__);
 
-	while (loop) {
+	while (true) {
 
 		struct tmComResInfo tRsp = { 0, 0, 0, 0, 0, 0 };
 		ret = saa7164_bus_get(dev, &tRsp, NULL, 1);
-- 
2.5.0
