Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f48.google.com ([209.85.160.48]:52292 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754027Ab3CMKwc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Mar 2013 06:52:32 -0400
Received: by mail-pb0-f48.google.com with SMTP id wy12so889352pbc.21
        for <linux-media@vger.kernel.org>; Wed, 13 Mar 2013 03:52:31 -0700 (PDT)
From: Vikas Sajjan <vikas.sajjan@linaro.org>
To: dri-devel@lists.freedesktop.org
Cc: linux-media@vger.kernel.org, kgene.kim@samsung.com,
	joshi@samsung.com, inki.dae@samsung.com,
	linaro-kernel@lists.linaro.org, jy0922.shim@samsung.com
Subject: [PATCH] drm/exynos: change the method for getting the interrupt resource of FIMD
Date: Wed, 13 Mar 2013 16:22:19 +0530
Message-Id: <1363171939-9672-1-git-send-email-vikas.sajjan@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replaces the "platform_get_resource() for IORESOURCE_IRQ" with
platform_get_resource_byname().
Both in exynos4 and exynos5, FIMD IP has 3 interrupts in the order: "fifo",
"vsync", and "lcd_sys".
But The FIMD driver expects the "vsync" interrupt to be mentioned as the
1st parameter in the FIMD DT node. So to meet this expectation of the
driver, the FIMD DT node was forced to be made by keeping "vsync" as the
1st paramter.
For example in exynos4, the FIMD DT node has interrupt numbers
mentioned as <11, 1> <11, 0> <11, 2> keeping "vsync" as the 1st paramter.

This patch fixes the above mentioned "hack" of re-ordering of the
FIMD interrupt numbers by getting interrupt resource of FIMD by using
platform_get_resource_byname().

Signed-off-by: Vikas Sajjan <vikas.sajjan@linaro.org>
---
 drivers/gpu/drm/exynos/exynos_drm_fimd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_fimd.c b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
index 1ea173a..cd79d38 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_fimd.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_fimd.c
@@ -945,7 +945,7 @@ static int fimd_probe(struct platform_device *pdev)
 		return -ENXIO;
 	}
 
-	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	res = platform_get_resource_byname(pdev, IORESOURCE_IRQ, "vsync");
 	if (!res) {
 		dev_err(dev, "irq request failed.\n");
 		return -ENXIO;
-- 
1.7.9.5

