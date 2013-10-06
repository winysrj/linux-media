Return-path: <linux-media-owner@vger.kernel.org>
Received: from top.free-electrons.com ([176.31.233.9]:51208 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751404Ab3JFGX2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Oct 2013 02:23:28 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: m.chehab@samsung.com, gregkh@linuxfoundation.org
Cc: prabhakar.csengg@gmail.com, yongjun_wei@trendmicro.com.cn,
	sakari.ailus@iki.fi, hans.verkuil@cisco.com,
	linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org,
	Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] [media] davinci: vpfe: remove deprecated IRQF_DISABLED
Date: Sun,  6 Oct 2013 08:23:20 +0200
Message-Id: <1381040600-12683-1-git-send-email-michael.opdenacker@free-electrons.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch proposes to remove the use of the IRQF_DISABLED flag

It's a NOOP since 2.6.35 and it will be removed one day.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c b/drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c
index d8ce20d..cda8388c 100644
--- a/drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c
+++ b/drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c
@@ -298,7 +298,7 @@ static int vpfe_attach_irq(struct vpfe_device *vpfe_dev)
 {
 	int ret = 0;
 
-	ret = request_irq(vpfe_dev->ccdc_irq0, vpfe_isr, IRQF_DISABLED,
+	ret = request_irq(vpfe_dev->ccdc_irq0, vpfe_isr, 0,
 			  "vpfe_capture0", vpfe_dev);
 	if (ret < 0) {
 		v4l2_err(&vpfe_dev->v4l2_dev,
@@ -306,7 +306,7 @@ static int vpfe_attach_irq(struct vpfe_device *vpfe_dev)
 		return ret;
 	}
 
-	ret = request_irq(vpfe_dev->ccdc_irq1, vpfe_vdint1_isr, IRQF_DISABLED,
+	ret = request_irq(vpfe_dev->ccdc_irq1, vpfe_vdint1_isr, 0,
 			  "vpfe_capture1", vpfe_dev);
 	if (ret < 0) {
 		v4l2_err(&vpfe_dev->v4l2_dev,
@@ -316,7 +316,7 @@ static int vpfe_attach_irq(struct vpfe_device *vpfe_dev)
 	}
 
 	ret = request_irq(vpfe_dev->imp_dma_irq, vpfe_imp_dma_isr,
-			  IRQF_DISABLED, "Imp_Sdram_Irq", vpfe_dev);
+			  0, "Imp_Sdram_Irq", vpfe_dev);
 	if (ret < 0) {
 		v4l2_err(&vpfe_dev->v4l2_dev,
 			 "Error: requesting IMP IRQ interrupt\n");
-- 
1.8.1.2

