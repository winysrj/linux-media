Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.24]:42677 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726315AbeIZTPU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Sep 2018 15:15:20 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] media: imx-pxp: include linux/interrupt.h
Date: Wed, 26 Sep 2018 15:01:26 +0200
Message-Id: <20180926130139.2320343-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The newly added driver fails to build in some configurations due to a
missing header inclusion:

drivers/media/platform/imx-pxp.c:988:8: error: unknown type name 'irqreturn_t'
 static irqreturn_t pxp_irq_handler(int irq, void *dev_id)
        ^~~~~~~~~~~
drivers/media/platform/imx-pxp.c: In function 'pxp_irq_handler':
drivers/media/platform/imx-pxp.c:1012:9: error: 'IRQ_HANDLED' undeclared (first use in this function); did you mean 'IRQ_MODE'?
  return IRQ_HANDLED;
         ^~~~~~~~~~~
         IRQ_MODE
drivers/media/platform/imx-pxp.c:1012:9: note: each undeclared identifier is reported only once for each function it appears in
drivers/media/platform/imx-pxp.c: In function 'pxp_probe':
drivers/media/platform/imx-pxp.c:1660:8: error: implicit declaration of function 'devm_request_threaded_irq'; did you mean 'devm_request_region'? [-Werror=implicit-function-declaration]
  ret = devm_request_threaded_irq(&pdev->dev, irq, NULL, pxp_irq_handler,
        ^~~~~~~~~~~~~~~~~~~~~~~~~
        devm_request_region
drivers/media/platform/imx-pxp.c:1661:4: error: 'IRQF_ONESHOT' undeclared (first use in this function); did you mean 'SA_ONESHOT'?
    IRQF_ONESHOT, dev_name(&pdev->dev), dev);

Fixes: 51abcf7fdb70 ("media: imx-pxp: add i.MX Pixel Pipeline driver")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/platform/imx-pxp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/imx-pxp.c b/drivers/media/platform/imx-pxp.c
index 229c23ae4029..b76cd0e8313c 100644
--- a/drivers/media/platform/imx-pxp.c
+++ b/drivers/media/platform/imx-pxp.c
@@ -16,6 +16,7 @@
 #include <linux/interrupt.h>
 #include <linux/io.h>
 #include <linux/iopoll.h>
+#include <linux/interrupt.h>
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/sched.h>
-- 
2.18.0
