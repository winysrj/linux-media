Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([89.238.76.85]:55517 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752569AbcHILfX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Aug 2016 07:35:23 -0400
From: Wolfram Sang <wsa-dev@sang-engineering.com>
To: linux-kernel@vger.kernel.org
Cc: linux-i2c@vger.kernel.org,
	Wolfram Sang <wsa-dev@sang-engineering.com>,
	Sergey Kozlov <serjk@netup.ru>, Abylay Ospan <aospan@netup.ru>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	linux-media@vger.kernel.org
Subject: [PATCH 1/4] media: pci: netup_unidvb: don't print error when adding adapter fails
Date: Tue,  9 Aug 2016 13:35:13 +0200
Message-Id: <1470742517-12774-2-git-send-email-wsa-dev@sang-engineering.com>
In-Reply-To: <1470742517-12774-1-git-send-email-wsa-dev@sang-engineering.com>
References: <1470742517-12774-1-git-send-email-wsa-dev@sang-engineering.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The core will do this for us now.

Signed-off-by: Wolfram Sang <wsa-dev@sang-engineering.com>
---
 drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c b/drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c
index c09c52bc6eabef..b49e4f9788e869 100644
--- a/drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c
+++ b/drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c
@@ -327,11 +327,8 @@ static int netup_i2c_init(struct netup_unidvb_dev *ndev, int bus_num)
 	i2c->adap.dev.parent = &ndev->pci_dev->dev;
 	i2c_set_adapdata(&i2c->adap, i2c);
 	ret = i2c_add_adapter(&i2c->adap);
-	if (ret) {
-		dev_err(&ndev->pci_dev->dev,
-			"%s(): failed to add I2C adapter\n", __func__);
+	if (ret)
 		return ret;
-	}
 	dev_info(&ndev->pci_dev->dev,
 		"%s(): registered I2C bus %d at 0x%x\n",
 		__func__,
-- 
2.8.1

