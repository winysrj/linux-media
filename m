Return-path: <mchehab@pedra>
Received: from tex.lwn.net ([70.33.254.29]:58893 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754187Ab1F3UFm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jun 2011 16:05:42 -0400
From: Jonathan Corbet <corbet@lwn.net>
To: linux-media@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Kassey Lee <ygli@marvell.com>, Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 2/2] marvell-cam: use S/G DMA by default
Date: Thu, 30 Jun 2011 14:05:28 -0600
Message-Id: <1309464328-67565-3-git-send-email-corbet@lwn.net>
In-Reply-To: <1309464328-67565-1-git-send-email-corbet@lwn.net>
References: <1309464328-67565-1-git-send-email-corbet@lwn.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Scatter/gather DMA mode works nicely on this platform and is clearly the
best way of doing things.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>
---
 drivers/media/video/marvell-ccic/mmp-driver.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/marvell-ccic/mmp-driver.c b/drivers/media/video/marvell-ccic/mmp-driver.c
index 7b9c48c..8415915 100644
--- a/drivers/media/video/marvell-ccic/mmp-driver.c
+++ b/drivers/media/video/marvell-ccic/mmp-driver.c
@@ -180,7 +180,7 @@ static int mmpcam_probe(struct platform_device *pdev)
 	mcam->dev = &pdev->dev;
 	mcam->use_smbus = 0;
 	mcam->chip_id = V4L2_IDENT_ARMADA610;
-	mcam->buffer_mode = B_vmalloc;  /* Switch to dma */
+	mcam->buffer_mode = B_DMA_sg;
 	spin_lock_init(&mcam->dev_lock);
 	/*
 	 * Get our I/O memory.
-- 
1.7.5.4

