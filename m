Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:37093 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341Ab3KHKBZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Nov 2013 05:01:25 -0500
Date: Fri, 8 Nov 2013 13:01:09 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Grant Likely <grant.likely@linaro.org>,
	Rob Herring <rob.herring@calxeda.com>,
	Archit Taneja <archit@ti.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Kamil Debski <k.debski@samsung.com>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] [media] v4l: ti-vpe: checking for IS_ERR() instead of NULL
Message-ID: <20131108100109.GN27977@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

devm_ioremap() returns NULL on error, it doesn't return an ERR_PTR.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
index 4e58069..e163466 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -1962,8 +1962,8 @@ static int vpe_probe(struct platform_device *pdev)
 	 * registers based on the sub block base addresses
 	 */
 	dev->base = devm_ioremap(&pdev->dev, res->start, SZ_32K);
-	if (IS_ERR(dev->base)) {
-		ret = PTR_ERR(dev->base);
+	if (!dev->base) {
+		ret = -ENOMEM;
 		goto v4l2_dev_unreg;
 	}
 
