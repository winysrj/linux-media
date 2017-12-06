Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:31170 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751711AbdLFQjU (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 6 Dec 2017 11:39:20 -0500
From: Flavio Ceolin <flavio.ceolin@intel.com>
To: linux-kernel@vger.kernel.org
Cc: Flavio Ceolin <flavio.ceolin@intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Petr Cvek <petr.cvek@tul.cz>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Arnd Bergmann <arnd@arndb.de>,
        linux-media@vger.kernel.org (open list:MEDIA INPUT INFRASTRUCTURE
        (V4L/DVB))
Subject: [PATCH] media: pxa_camera: disable and unprepare the clock source on error
Date: Wed,  6 Dec 2017 08:38:50 -0800
Message-Id: <20171206163852.8532-1-flavio.ceolin@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

pxa_camera_probe() was not calling pxa_camera_deactivate(),
responsible to call clk_disable_unprepare(), on the failure path. This
was leading to unbalancing source clock.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Flavio Ceolin <flavio.ceolin@intel.com>
---
 drivers/media/platform/pxa_camera.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/pxa_camera.c b/drivers/media/platform/pxa_camera.c
index 9d3f0cb..7877037 100644
--- a/drivers/media/platform/pxa_camera.c
+++ b/drivers/media/platform/pxa_camera.c
@@ -2489,7 +2489,7 @@ static int pxa_camera_probe(struct platform_device *pdev)
 	dev_set_drvdata(&pdev->dev, pcdev);
 	err = v4l2_device_register(&pdev->dev, &pcdev->v4l2_dev);
 	if (err)
-		goto exit_free_dma;
+		goto exit_deactivate;
 
 	pcdev->asds[0] = &pcdev->asd;
 	pcdev->notifier.subdevs = pcdev->asds;
@@ -2525,6 +2525,8 @@ static int pxa_camera_probe(struct platform_device *pdev)
 	v4l2_clk_unregister(pcdev->mclk_clk);
 exit_free_v4l2dev:
 	v4l2_device_unregister(&pcdev->v4l2_dev);
+exit_deactivate:
+	pxa_camera_deactivate(pcdev);
 exit_free_dma:
 	dma_release_channel(pcdev->dma_chans[2]);
 exit_free_dma_u:
-- 
2.9.5
