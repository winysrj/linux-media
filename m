Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:32779 "EHLO
	mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755246AbbK0WDF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Nov 2015 17:03:05 -0500
Received: by wmec201 with SMTP id c201so85285782wme.0
        for <linux-media@vger.kernel.org>; Fri, 27 Nov 2015 14:03:03 -0800 (PST)
From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH] media: rc: nuvoton: mark wakeup-related resources
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org,
	=?UTF-8?Q?David_H=c3=a4rdeman?= <david@hardeman.nu>
Message-ID: <5658CD64.1030604@gmail.com>
Date: Fri, 27 Nov 2015 22:38:44 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When requesting resources use different names for the normal and
the wakeup part. This makes it easier to interpret the output
of e.g. /proc/interrupts and /proc/ioports.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/media/rc/nuvoton-cir.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index 18adf58..081435c 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -1079,12 +1079,12 @@ static int nvt_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id)
 		goto exit_unregister_device;
 
 	if (!devm_request_region(&pdev->dev, nvt->cir_wake_addr,
-			    CIR_IOREG_LENGTH, NVT_DRIVER_NAME))
+			    CIR_IOREG_LENGTH, NVT_DRIVER_NAME "-wake"))
 		goto exit_unregister_device;
 
 	if (devm_request_irq(&pdev->dev, nvt->cir_wake_irq,
 			     nvt_cir_wake_isr, IRQF_SHARED,
-			     NVT_DRIVER_NAME, (void *)nvt))
+			     NVT_DRIVER_NAME "-wake", (void *)nvt))
 		goto exit_unregister_device;
 
 	device_init_wakeup(&pdev->dev, true);
-- 
2.6.2

