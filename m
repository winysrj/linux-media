Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50730 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933282AbaGXTuJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Jul 2014 15:50:09 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH] [media] coda: fix build error by making reset control optional
Date: Thu, 24 Jul 2014 21:50:03 +0200
Message-Id: <1406231403-17649-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

make reset control optional for i.MX27

The patch "[media] coda: add reset control support" introduced a build failure
if CONFIG_RESET_CONTROLLER is disabled:

    drivers/media/platform/coda.c:3734:2: error: implicit declaration of
     function 'devm_reset_control_get'

Since not all SoCs containing CODA VPUs do have a system reset controller,
use devm_reset_control_get_optional to make it optional.

Reported-by: Shawn Guo <shawn.guo@linaro.org>
Reported-by: Olof's autobuilder <build@lixom.net>
Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index 18758e2..ff61bb0 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -3779,10 +3779,10 @@ static int coda_probe(struct platform_device *pdev)
 		return -ENOENT;
 	}
 
-	dev->rstc = devm_reset_control_get(&pdev->dev, NULL);
+	dev->rstc = devm_reset_control_get_optional(&pdev->dev, NULL);
 	if (IS_ERR(dev->rstc)) {
 		ret = PTR_ERR(dev->rstc);
-		if (ret == -ENOENT) {
+		if (ret == -ENOENT || ret == -ENOSYS) {
 			dev->rstc = NULL;
 		} else {
 			dev_err(&pdev->dev, "failed get reset control: %d\n", ret);
-- 
2.0.1

