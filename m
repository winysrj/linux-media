Return-path: <linux-media-owner@vger.kernel.org>
Received: from bubo.tul.cz ([147.230.16.1]:50472 "EHLO bubo.tul.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1425287AbdEAEUw (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 1 May 2017 00:20:52 -0400
From: Petr Cvek <petr.cvek@tul.cz>
Subject: [PATCH 4/4] [media] pxa_camera: Fix a call with an uninitialized
 device pointer
To: robert.jarzmik@free.fr
References: <cover.1493612057.git.petr.cvek@tul.cz>
Cc: linux-media@vger.kernel.org
Message-ID: <81365c5e-d102-12ba-777f-47c758416cd8@tul.cz>
Date: Mon, 1 May 2017 06:21:57 +0200
MIME-Version: 1.0
In-Reply-To: <cover.1493612057.git.petr.cvek@tul.cz>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In 'commit 295ab497d6357 ("[media] media: platform: pxa_camera: make
printk consistent")' a pointer to the device structure in
mclk_get_divisor() was changed to pcdev_to_dev(pcdev). The pointer used
by pcdev_to_dev() is still uninitialized during the call to
mclk_get_divisor() as it happens in v4l2_device_register() at the end
of the probe. The dev_warn and dev_dbg caused a line in the log:

	(NULL device *): Limiting master clock to 26000000

Fix this by using an initialized pointer from the platform_device
(as before the old patch).

Signed-off-by: Petr Cvek <petr.cvek@tul.cz>
---
 drivers/media/platform/pxa_camera.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/pxa_camera.c b/drivers/media/platform/pxa_camera.c
index 79fd7269d1e6..c8466c63be22 100644
--- a/drivers/media/platform/pxa_camera.c
+++ b/drivers/media/platform/pxa_camera.c
@@ -1124,7 +1124,7 @@ static u32 mclk_get_divisor(struct platform_device *pdev,
 	/* mclk <= ciclk / 4 (27.4.2) */
 	if (mclk > lcdclk / 4) {
 		mclk = lcdclk / 4;
-		dev_warn(pcdev_to_dev(pcdev),
+		dev_warn(&pdev->dev,
 			 "Limiting master clock to %lu\n", mclk);
 	}
 
@@ -1135,7 +1135,7 @@ static u32 mclk_get_divisor(struct platform_device *pdev,
 	if (pcdev->platform_flags & PXA_CAMERA_MCLK_EN)
 		pcdev->mclk = lcdclk / (2 * (div + 1));
 
-	dev_dbg(pcdev_to_dev(pcdev), "LCD clock %luHz, target freq %luHz, divisor %u\n",
+	dev_dbg(&pdev->dev, "LCD clock %luHz, target freq %luHz, divisor %u\n",
 		lcdclk, mclk, div);
 
 	return div;
-- 
2.11.0
