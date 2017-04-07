Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.ispras.ru ([83.149.199.45]:37876 "EHLO mail.ispras.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751981AbdDGXJ1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Apr 2017 19:09:27 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org
Subject: [PATCH] m2m-deinterlace: don't return zero on failure paths in deinterlace_probe()
Date: Sat,  8 Apr 2017 02:09:17 +0300
Message-Id: <1491606557-18988-1-git-send-email-khoroshilov@ispras.ru>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If DMA does not support INTERLEAVE, deinterlace_probe() breaks off
initialization, releases dma channel, but returns zero.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/media/platform/m2m-deinterlace.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/m2m-deinterlace.c b/drivers/media/platform/m2m-deinterlace.c
index bedc7cc4c7d6..980066b8d32a 100644
--- a/drivers/media/platform/m2m-deinterlace.c
+++ b/drivers/media/platform/m2m-deinterlace.c
@@ -1017,6 +1017,7 @@ static int deinterlace_probe(struct platform_device *pdev)
 
 	if (!dma_has_cap(DMA_INTERLEAVE, pcdev->dma_chan->device->cap_mask)) {
 		dev_err(&pdev->dev, "DMA does not support INTERLEAVE\n");
+		ret = -ENODEV;
 		goto rel_dma;
 	}
 
-- 
2.7.4
