Return-path: <linux-media-owner@vger.kernel.org>
Received: from bubo.tul.cz ([147.230.16.1]:52246 "EHLO bubo.tul.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S979763AbdDYBvM (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 24 Apr 2017 21:51:12 -0400
From: Petr Cvek <petr.cvek@tul.cz>
Subject: [PATCH] [media] pxa_camera: fix module remove codepath for v4l2 clock
To: mchehab@kernel.org, g.liakhovetski@gmx.de, robert.jarzmik@free.fr
Cc: linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Message-ID: <4391b498-0a75-ff42-6a7e-65aef0fada07@tul.cz>
Date: Tue, 25 Apr 2017 03:51:58 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The conversion from soc_camera omitted a correct handling of the clock
gating for a sensor. When the pxa_camera driver module was removed it
tried to unregister clk, but this caused a similar warning:

  WARNING: CPU: 0 PID: 6740 at drivers/media/v4l2-core/v4l2-clk.c:278
  v4l2_clk_unregister(): Refusing to unregister ref-counted 0-0030 clock!

The clock was at time still refcounted by the sensor driver. Before
the removing of the pxa_camera the clock must be dropped by the sensor
driver. This should be triggered by v4l2_async_notifier_unregister() call
which removes sensor driver module too, calls unbind() function and then
tries to probe sensor driver again. Inside unbind() we can safely
unregister the v4l2 clock as the sensor driver got removed. The original
v4l2_clk_unregister() should be put inside test as the clock can be
already unregistered from unbind(). If there was not any bound sensor
the clock is still present.

The codepath is practically a copy from the old soc_camera. The bug was
tested with a pxa_camera+ov9640 combination during the conversion
of the ov9640 from the soc_camera.

Signed-off-by: Petr Cvek <petr.cvek@tul.cz>
---
 drivers/media/platform/pxa_camera.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/pxa_camera.c b/drivers/media/platform/pxa_camera.c
index 929006f65cc7..6615f80fe059 100644
--- a/drivers/media/platform/pxa_camera.c
+++ b/drivers/media/platform/pxa_camera.c
@@ -2177,6 +2177,12 @@ static void pxa_camera_sensor_unbind(struct v4l2_async_notifier *notifier,
 	pxa_dma_stop_channels(pcdev);
 
 	pxa_camera_destroy_formats(pcdev);
+
+	if (pcdev->mclk_clk) {
+		v4l2_clk_unregister(pcdev->mclk_clk);
+		pcdev->mclk_clk = NULL;
+	}
+
 	video_unregister_device(&pcdev->vdev);
 	pcdev->sensor = NULL;
 
@@ -2501,7 +2507,13 @@ static int pxa_camera_remove(struct platform_device *pdev)
 	dma_release_channel(pcdev->dma_chans[1]);
 	dma_release_channel(pcdev->dma_chans[2]);
 
-	v4l2_clk_unregister(pcdev->mclk_clk);
+	v4l2_async_notifier_unregister(&pcdev->notifier);
+
+	if (pcdev->mclk_clk) {
+		v4l2_clk_unregister(pcdev->mclk_clk);
+		pcdev->mclk_clk = NULL;
+	}
+
 	v4l2_device_unregister(&pcdev->v4l2_dev);
 
 	dev_info(&pdev->dev, "PXA Camera driver unloaded\n");
-- 
2.11.0
