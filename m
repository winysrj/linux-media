Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:48333 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618Ab3KDAG3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Nov 2013 19:06:29 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Sergio Aguirre <sergio.a.aguirre@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH v2 17/18] v4l: omap4iss: Don't initialize fields to 0 manually
Date: Mon,  4 Nov 2013 01:06:42 +0100
Message-Id: <1383523603-3907-18-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1383523603-3907-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1383523603-3907-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The iss_device structure is allocated with kzalloc, there's no need to
initialize its fields to 0 explicitly.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/staging/media/omap4iss/iss.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/media/omap4iss/iss.c b/drivers/staging/media/omap4iss/iss.c
index c7dffa6..7d427d5 100644
--- a/drivers/staging/media/omap4iss/iss.c
+++ b/drivers/staging/media/omap4iss/iss.c
@@ -1306,7 +1306,6 @@ static int iss_probe(struct platform_device *pdev)
 
 	iss->dev = &pdev->dev;
 	iss->pdata = pdata;
-	iss->ref_count = 0;
 
 	iss->raw_dmamask = DMA_BIT_MASK(32);
 	iss->dev->dma_mask = &iss->raw_dmamask;
-- 
1.8.1.5

