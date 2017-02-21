Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway31.websitewelcome.com ([192.185.143.4]:30534 "EHLO
        gateway31.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751173AbdBUENs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Feb 2017 23:13:48 -0500
Received: from cm2.websitewelcome.com (cm2.websitewelcome.com [192.185.178.13])
        by gateway31.websitewelcome.com (Postfix) with ESMTP id 3B724FE4B4
        for <linux-media@vger.kernel.org>; Mon, 20 Feb 2017 21:50:01 -0600 (CST)
Date: Mon, 20 Feb 2017 21:49:59 -0600
From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
To: mchehab@kernel.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>,
        Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH 2/2] media: pci: saa7164: remove dead code
Message-ID: <20170221034959.GA4837@embeddedgus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170221034657.GA4757@embeddedgus>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove dead code. The following line of code is never reached:
return SAA_OK;

Addresses-Coverity-ID: 114283
Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
---
 drivers/media/pci/saa7164/saa7164-cmd.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/pci/saa7164/saa7164-cmd.c b/drivers/media/pci/saa7164/saa7164-cmd.c
index 169c90a..fb19498 100644
--- a/drivers/media/pci/saa7164/saa7164-cmd.c
+++ b/drivers/media/pci/saa7164/saa7164-cmd.c
@@ -181,8 +181,6 @@ static int saa7164_cmd_dequeue(struct saa7164_dev *dev)
 		wake_up(q);
 		return SAA_OK;
 	}
-
-	return SAA_OK;
 }
 
 static int saa7164_cmd_set(struct saa7164_dev *dev, struct tmComResInfo *msg,
-- 
2.5.0
