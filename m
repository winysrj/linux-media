Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:48519 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751369AbdCIUI0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 9 Mar 2017 15:08:26 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Russell King <linux@armlinux.org.uk>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 2/3] Revert "[media] coda/imx-vdoa: constify structs"
Date: Thu,  9 Mar 2017 17:08:17 -0300
Message-Id: <2bb350eb8ab0d6db9092d689916029b3580dde2b.1489090091.git.mchehab@s-opensource.com>
In-Reply-To: <311737bbe02ab45e7b0c27e95a312b57fc31b21a.1489090091.git.mchehab@s-opensource.com>
References: <311737bbe02ab45e7b0c27e95a312b57fc31b21a.1489090091.git.mchehab@s-opensource.com>
In-Reply-To: <311737bbe02ab45e7b0c27e95a312b57fc31b21a.1489090091.git.mchehab@s-opensource.com>
References: <311737bbe02ab45e7b0c27e95a312b57fc31b21a.1489090091.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We can't constify struct platform_driver.

This reverts commit d2fe28feaebbbbe147e5e6e7bc68857f9bd7f6ad.

Reported-by: Russell King <linux@armlinux.org.uk>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/platform/coda/imx-vdoa.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/coda/imx-vdoa.c b/drivers/media/platform/coda/imx-vdoa.c
index 67fd8ffa60a4..f61baf7dcbc1 100644
--- a/drivers/media/platform/coda/imx-vdoa.c
+++ b/drivers/media/platform/coda/imx-vdoa.c
@@ -315,13 +315,13 @@ static int vdoa_remove(struct platform_device *pdev)
 	return 0;
 }
 
-static const struct of_device_id vdoa_dt_ids[] = {
+static struct of_device_id vdoa_dt_ids[] = {
 	{ .compatible = "fsl,imx6q-vdoa" },
 	{}
 };
 MODULE_DEVICE_TABLE(of, vdoa_dt_ids);
 
-static const struct platform_driver vdoa_driver = {
+static struct platform_driver vdoa_driver = {
 	.probe		= vdoa_probe,
 	.remove		= vdoa_remove,
 	.driver		= {
-- 
2.9.3
