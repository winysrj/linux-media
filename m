Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f65.google.com ([209.85.220.65]:34880 "EHLO
        mail-pa0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933641AbcIOCVv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Sep 2016 22:21:51 -0400
Received: by mail-pa0-f65.google.com with SMTP id pp5so1471162pac.2
        for <linux-media@vger.kernel.org>; Wed, 14 Sep 2016 19:21:51 -0700 (PDT)
From: Wei Yongjun <weiyj.lk@gmail.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Arnd Bergmann <arnd@arndb.de>
Cc: Wei Yongjun <weiyongjun1@huawei.com>, linux-media@vger.kernel.org
Subject: [PATCH -next] [media] pxa_camera: fix error return code in pxa_camera_probe()
Date: Thu, 15 Sep 2016 02:21:45 +0000
Message-Id: <1473906105-29387-1-git-send-email-weiyj.lk@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Wei Yongjun <weiyongjun1@huawei.com>

Fix to return error code -ENODEV from dma_request_slave_channel_compat()
error handling case instead of 0, as done elsewhere in this function.

Also fix to release resources in v4l2_clk_register() error handling.

Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/media/platform/pxa_camera.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/pxa_camera.c b/drivers/media/platform/pxa_camera.c
index 1bce7eb..8035290 100644
--- a/drivers/media/platform/pxa_camera.c
+++ b/drivers/media/platform/pxa_camera.c
@@ -2402,6 +2402,7 @@ static int pxa_camera_probe(struct platform_device *pdev)
 						 &params, &pdev->dev, "CI_U");
 	if (!pcdev->dma_chans[1]) {
 		dev_err(&pdev->dev, "Can't request DMA for Y\n");
+		err = -ENODEV;
 		goto exit_free_dma_y;
 	}
 
@@ -2411,6 +2412,7 @@ static int pxa_camera_probe(struct platform_device *pdev)
 						 &params, &pdev->dev, "CI_V");
 	if (!pcdev->dma_chans[2]) {
 		dev_err(&pdev->dev, "Can't request DMA for V\n");
+		err = -ENODEV;
 		goto exit_free_dma_u;
 	}
 
@@ -2461,8 +2463,10 @@ static int pxa_camera_probe(struct platform_device *pdev)
 
 		pcdev->mclk_clk = v4l2_clk_register(&pxa_camera_mclk_ops,
 						    clk_name, NULL);
-		if (IS_ERR(pcdev->mclk_clk))
-			return PTR_ERR(pcdev->mclk_clk);
+		if (IS_ERR(pcdev->mclk_clk)) {
+			err = PTR_ERR(pcdev->mclk_clk);
+			goto exit_free_v4l2dev;
+		}
 	}
 
 	err = v4l2_async_notifier_register(&pcdev->v4l2_dev, &pcdev->notifier);

