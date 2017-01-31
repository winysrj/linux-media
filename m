Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:51956 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751357AbdAaKQB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Jan 2017 05:16:01 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH] [media] coda/imx-vdoa: constify structs
Date: Tue, 31 Jan 2017 08:14:56 -0200
Message-Id: <4ece2d056d96ae6fd40cb9d6c58dd1510d448ed1.1485857690.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As warned by checkpatch:

	WARNING: struct of_device_id should normally be const
	#318: FILE: drivers/media/platform/coda/imx-vdoa.c:318:
	+static struct of_device_id vdoa_dt_ids[] = {

So, constify structs.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/platform/coda/imx-vdoa.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/coda/imx-vdoa.c b/drivers/media/platform/coda/imx-vdoa.c
index f61baf7dcbc1..67fd8ffa60a4 100644
--- a/drivers/media/platform/coda/imx-vdoa.c
+++ b/drivers/media/platform/coda/imx-vdoa.c
@@ -315,13 +315,13 @@ static int vdoa_remove(struct platform_device *pdev)
 	return 0;
 }
 
-static struct of_device_id vdoa_dt_ids[] = {
+static const struct of_device_id vdoa_dt_ids[] = {
 	{ .compatible = "fsl,imx6q-vdoa" },
 	{}
 };
 MODULE_DEVICE_TABLE(of, vdoa_dt_ids);
 
-static struct platform_driver vdoa_driver = {
+static const struct platform_driver vdoa_driver = {
 	.probe		= vdoa_probe,
 	.remove		= vdoa_remove,
 	.driver		= {
-- 
2.9.3

