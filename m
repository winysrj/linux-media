Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-OUT05A.alice.it ([85.33.3.5]:1091 "EHLO
	smtp-OUT05A.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756156AbZKQWMq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Nov 2009 17:12:46 -0500
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-media@vger.kernel.org
Cc: Antonio Ospite <ospite@studenti.unina.it>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Eric Miao <eric.y.miao@gmail.com>,
	linux-arm-kernel@lists.infradead.org,
	Mike Rapoport <mike@compulab.co.il>,
	Juergen Beisert <j.beisert@pengutronix.de>,
	Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH 3/3] pxa_camera: remove init() callback
Date: Tue, 17 Nov 2009 23:04:23 +0100
Message-Id: <1258495463-26029-4-git-send-email-ospite@studenti.unina.it>
In-Reply-To: <1258495463-26029-1-git-send-email-ospite@studenti.unina.it>
References: <1258495463-26029-1-git-send-email-ospite@studenti.unina.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

pxa_camera init() callback is sometimes abused to setup MFP for PXA CIF, or
even to request GPIOs to be used by the camera *sensor*. These initializations
can be performed statically in machine init functions.

The current semantics for this init() callback is ambiguous anyways, it is
invoked in pxa_camera_activate(), hence at device node open, but its users use
it like a generic initialization to be done at module init time (configure
MFP, request GPIOs for *sensor* control).

Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
---
 arch/arm/mach-pxa/include/mach/camera.h |    2 --
 drivers/media/video/pxa_camera.c        |   10 ----------
 2 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/arch/arm/mach-pxa/include/mach/camera.h b/arch/arm/mach-pxa/include/mach/camera.h
index 31abe6d..6709b1c 100644
--- a/arch/arm/mach-pxa/include/mach/camera.h
+++ b/arch/arm/mach-pxa/include/mach/camera.h
@@ -35,8 +35,6 @@
 #define PXA_CAMERA_VSP		0x400
 
 struct pxacamera_platform_data {
-	int (*init)(struct device *);
-
 	unsigned long flags;
 	unsigned long mclk_10khz;
 };
diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
index 51b683c..49f2bf9 100644
--- a/drivers/media/video/pxa_camera.c
+++ b/drivers/media/video/pxa_camera.c
@@ -882,18 +882,8 @@ static void recalculate_fifo_timeout(struct pxa_camera_dev *pcdev,
 
 static void pxa_camera_activate(struct pxa_camera_dev *pcdev)
 {
-	struct pxacamera_platform_data *pdata = pcdev->pdata;
-	struct device *dev = pcdev->soc_host.v4l2_dev.dev;
 	u32 cicr4 = 0;
 
-	dev_dbg(dev, "Registered platform device at %p data %p\n",
-		pcdev, pdata);
-
-	if (pdata && pdata->init) {
-		dev_dbg(dev, "%s: Init gpios\n", __func__);
-		pdata->init(dev);
-	}
-
 	/* disable all interrupts */
 	__raw_writel(0x3ff, pcdev->base + CICR0);
 
-- 
1.6.5.2

