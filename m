Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:35046 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505Ab2KEQAO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Nov 2012 11:00:14 -0500
Received: by mail-wg0-f44.google.com with SMTP id dr13so4061968wgb.1
        for <linux-media@vger.kernel.org>; Mon, 05 Nov 2012 08:00:14 -0800 (PST)
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-media@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, p.zabel@pengutronix.de,
	s.nawrocki@samsung.com, mchehab@infradead.org,
	kernel@pengutronix.de,
	Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH 2/2] media: coda: Use iram_alloc() for codadx6 too.
Date: Mon,  5 Nov 2012 16:59:45 +0100
Message-Id: <1352131185-12079-2-git-send-email-javier.martin@vista-silicon.com>
In-Reply-To: <1352131185-12079-1-git-send-email-javier.martin@vista-silicon.com>
References: <1352131185-12079-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use this helper function instead of hardcoding the
physical address of the IRAM in the i.MX27.

Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
---
 drivers/media/video/Kconfig |    2 +-
 drivers/media/video/coda.c  |   18 ++++++++++--------
 2 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index ecab6ef..0b5f785 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -1229,7 +1229,7 @@ config VIDEO_CODA
 	depends on VIDEO_DEV && VIDEO_V4L2 && ARCH_MXC
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
-	select IRAM_ALLOC if SOC_IMX53
+	select IRAM_ALLOC
 	---help---
 	   Coda is a range of video codec IPs that supports
 	   H.264, MPEG-4, and other video formats.
diff --git a/drivers/media/video/coda.c b/drivers/media/video/coda.c
index 7febcd9..96ecb3f 100644
--- a/drivers/media/video/coda.c
+++ b/drivers/media/video/coda.c
@@ -43,6 +43,7 @@
 #define CODA_PARA_BUF_SIZE	(10 * 1024)
 #define CODA_ISRAM_SIZE	(2048 * 2)
 #define CODA7_IRAM_SIZE		0x14000 /* 81920 bytes */
+#define CODADX6_IRAM_SIZE	45056
 
 #define CODA_MAX_FRAMEBUFFERS	2
 
@@ -1919,6 +1920,8 @@ static int __devinit coda_probe(struct platform_device *pdev)
 	const struct of_device_id *of_id =
 			of_match_device(of_match_ptr(coda_dt_ids), &pdev->dev);
 	const struct platform_device_id *pdev_id;
+	void __iomem *iram_vaddr;
+	unsigned long iram_size;
 	struct coda_dev *dev;
 	struct resource *res;
 	int ret, irq;
@@ -2016,16 +2019,15 @@ static int __devinit coda_probe(struct platform_device *pdev)
 	}
 
 	if (dev->devtype->product == CODA_DX6) {
-		dev->iram_paddr = 0xffff4c00;
+		iram_size = CODADX6_IRAM_SIZE;
 	} else {
-		void __iomem *iram_vaddr;
+		iram_size = CODA7_IRAM_SIZE;
+	}
 
-		iram_vaddr = iram_alloc(CODA7_IRAM_SIZE,
-					&dev->iram_paddr);
-		if (!iram_vaddr) {
-			dev_err(&pdev->dev, "unable to alloc iram\n");
-			return -ENOMEM;
-		}
+	iram_vaddr = iram_alloc(iram_size, &dev->iram_paddr);
+	if (!iram_vaddr) {
+		dev_err(&pdev->dev, "unable to alloc iram\n");
+		return -ENOMEM;
 	}
 
 	platform_set_drvdata(pdev, dev);
-- 
1.7.9.5

