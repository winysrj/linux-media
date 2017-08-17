Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:37061 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751542AbdHQANx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Aug 2017 20:13:53 -0400
Received: by mail-qk0-f196.google.com with SMTP id x77so4799189qka.4
        for <linux-media@vger.kernel.org>; Wed, 16 Aug 2017 17:13:53 -0700 (PDT)
From: Fabio Estevam <festevam@gmail.com>
To: p.zabel@pengutronix.de
Cc: mchehab@kernel.org, hansverk@cisco.com,
        linux-media@vger.kernel.org, Fabio Estevam <fabio.estevam@nxp.com>
Subject: [PATCH] [media] coda/imx-vdoa: Check for platform_get_resource() error
Date: Wed, 16 Aug 2017 21:14:07 -0300
Message-Id: <1502928847-10464-1-git-send-email-festevam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Fabio Estevam <fabio.estevam@nxp.com>

platform_get_resource() may fail and in this case a NULL dereference
will occur.

Prevent this from happening by returning an error on
platform_get_resource() failure. 

Fixes: b0444f18e0b18abce ("[media] coda: add i.MX6 VDOA driver")
Signed-off-by: Fabio Estevam <fabio.estevam@nxp.com>
---
 drivers/media/platform/coda/imx-vdoa.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/coda/imx-vdoa.c b/drivers/media/platform/coda/imx-vdoa.c
index df9b716..8eb3e0c 100644
--- a/drivers/media/platform/coda/imx-vdoa.c
+++ b/drivers/media/platform/coda/imx-vdoa.c
@@ -314,6 +314,8 @@ static int vdoa_probe(struct platform_device *pdev)
 		return PTR_ERR(vdoa->regs);
 
 	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (!res)
+		return -EINVAL;
 	vdoa->irq = devm_request_threaded_irq(&pdev->dev, res->start, NULL,
 					vdoa_irq_handler, IRQF_ONESHOT,
 					"vdoa", vdoa);
-- 
2.7.4
