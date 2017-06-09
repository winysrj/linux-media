Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f52.google.com ([74.125.83.52]:36125 "EHLO
        mail-pg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751956AbdFIQKd (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Jun 2017 12:10:33 -0400
Received: by mail-pg0-f52.google.com with SMTP id a70so27962751pge.3
        for <linux-media@vger.kernel.org>; Fri, 09 Jun 2017 09:10:33 -0700 (PDT)
From: Kevin Hilman <khilman@baylibre.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: Sekhar Nori <nsekhar@ti.com>, David Lechner <david@lechnology.com>,
        Patrick Titiano <ptitiano@baylibre.com>,
        Benoit Parrot <bparrot@ti.com>,
        Prabhakar Lad <prabhakar.csengg@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2] [media] davinci: vpif: adaptions for DT support
Date: Fri,  9 Jun 2017 09:10:26 -0700
Message-Id: <20170609161026.7582-1-khilman@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The davinci VPIF is a single hardware block, but the existing driver
is broken up into a common library (vpif.c), output (vpif_display.c) and
intput (vpif_capture.c).

When migrating to DT, to better model the hardware, and because
registers, interrupts, etc. are all common,it was decided to
have a single VPIF hardware node[1].

Because davinci uses legacy, non-DT boot on several SoCs still, the
platform_drivers need to remain.  But they are also needed in DT boot.
Since there are no DT nodes for the display/capture parts in DT
boot (there is a single node for the parent/common device) we need to
create platform_devices somewhere to instansiate the platform_drivers.

When VPIF display/capture are needed for a DT boot, the VPIF node
will have endpoints defined for its subdevs.  Therefore, vpif_probe()
checks for the presence of endpoints, and if detected manually creates
the platform_devices for the display and capture platform_drivers.

[1] Documentation/devicetree/bindings/media/ti,da850-vpif.txt

Signed-off-by: Kevin Hilman <khilman@baylibre.com>
---
Changes since v1:
- added proper error checking to kzalloc calls
- rebased onto media/master

 drivers/media/platform/davinci/vpif.c | 57 ++++++++++++++++++++++++++++++++++-
 1 file changed, 56 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/davinci/vpif.c b/drivers/media/platform/davinci/vpif.c
index 1b02a6363f77..c2d214dfaa3e 100644
--- a/drivers/media/platform/davinci/vpif.c
+++ b/drivers/media/platform/davinci/vpif.c
@@ -26,6 +26,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/spinlock.h>
 #include <linux/v4l2-dv-timings.h>
+#include <linux/of_graph.h>
 
 #include "vpif.h"
 
@@ -423,7 +424,9 @@ EXPORT_SYMBOL(vpif_channel_getfid);
 
 static int vpif_probe(struct platform_device *pdev)
 {
-	static struct resource	*res;
+	static struct resource	*res, *res_irq;
+	struct platform_device *pdev_capture, *pdev_display;
+	struct device_node *endpoint = NULL;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	vpif_base = devm_ioremap_resource(&pdev->dev, res);
@@ -435,6 +438,58 @@ static int vpif_probe(struct platform_device *pdev)
 
 	spin_lock_init(&vpif_lock);
 	dev_info(&pdev->dev, "vpif probe success\n");
+
+	/*
+	 * If VPIF Node has endpoints, assume "new" DT support,
+	 * where capture and display drivers don't have DT nodes
+	 * so their devices need to be registered manually here
+	 * for their legacy platform_drivers to work.
+	 */
+	endpoint = of_graph_get_next_endpoint(pdev->dev.of_node,
+					      endpoint);
+	if (!endpoint) 
+		return 0;
+
+	/*
+	 * For DT platforms, manually create platform_devices for
+	 * capture/display drivers.
+	 */
+	res_irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (!res_irq) {
+		dev_warn(&pdev->dev, "Missing IRQ resource.\n");
+		return -EINVAL;
+	}
+
+	pdev_capture = devm_kzalloc(&pdev->dev, sizeof(*pdev_capture),
+				    GFP_KERNEL);
+	if (pdev_capture) {
+		pdev_capture->name = "vpif_capture";
+		pdev_capture->id = -1;
+		pdev_capture->resource = res_irq;
+		pdev_capture->num_resources = 1;
+		pdev_capture->dev.dma_mask = pdev->dev.dma_mask;
+		pdev_capture->dev.coherent_dma_mask = pdev->dev.coherent_dma_mask;
+		pdev_capture->dev.parent = &pdev->dev;
+		platform_device_register(pdev_capture);
+	} else {
+		dev_warn(&pdev->dev, "Unable to allocate memory for pdev_capture.\n");
+	}
+
+	pdev_display = devm_kzalloc(&pdev->dev, sizeof(*pdev_display),
+				    GFP_KERNEL);
+	if (pdev_display) {
+		pdev_display->name = "vpif_display";
+		pdev_display->id = -1;
+		pdev_display->resource = res_irq;
+		pdev_display->num_resources = 1;
+		pdev_display->dev.dma_mask = pdev->dev.dma_mask;
+		pdev_display->dev.coherent_dma_mask = pdev->dev.coherent_dma_mask;
+		pdev_display->dev.parent = &pdev->dev;
+		platform_device_register(pdev_display);
+	} else {
+		dev_warn(&pdev->dev, "Unable to allocate memory for pdev_display.\n");
+	}
+
 	return 0;
 }
 
-- 
2.9.3
