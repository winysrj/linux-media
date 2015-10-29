Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:37573 "EHLO
	mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757914AbbJ2VXg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Oct 2015 17:23:36 -0400
Received: by wmff134 with SMTP id f134so33247795wmf.0
        for <linux-media@vger.kernel.org>; Thu, 29 Oct 2015 14:23:35 -0700 (PDT)
From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH 1/9] media: rc: nuvoton-cir: remove unneeded IRQ_RETVAL usage
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org
Message-ID: <56328D35.3070908@gmail.com>
Date: Thu, 29 Oct 2015 22:18:45 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Using IRQ_RETVAL is unneeded here. IRQ_NONE / IRQ_HANDLED can be
returned directly.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/media/rc/nuvoton-cir.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index 85af7a8..3d9a4cf 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -779,7 +779,7 @@ static irqreturn_t nvt_cir_isr(int irq, void *data)
 	if (!status) {
 		nvt_dbg_verbose("%s exiting, IRSTS 0x0", __func__);
 		nvt_cir_reg_write(nvt, 0xff, CIR_IRSTS);
-		return IRQ_RETVAL(IRQ_NONE);
+		return IRQ_NONE;
 	}
 
 	/* ack/clear all irq flags we've got */
@@ -790,7 +790,7 @@ static irqreturn_t nvt_cir_isr(int irq, void *data)
 	iren = nvt_cir_reg_read(nvt, CIR_IREN);
 	if (!iren) {
 		nvt_dbg_verbose("%s exiting, CIR not enabled", __func__);
-		return IRQ_RETVAL(IRQ_NONE);
+		return IRQ_NONE;
 	}
 
 	if (debug)
@@ -853,7 +853,7 @@ static irqreturn_t nvt_cir_isr(int irq, void *data)
 	}
 
 	nvt_dbg_verbose("%s done", __func__);
-	return IRQ_RETVAL(IRQ_HANDLED);
+	return IRQ_HANDLED;
 }
 
 /* Interrupt service routine for CIR Wake */
@@ -867,7 +867,7 @@ static irqreturn_t nvt_cir_wake_isr(int irq, void *data)
 
 	status = nvt_cir_wake_reg_read(nvt, CIR_WAKE_IRSTS);
 	if (!status)
-		return IRQ_RETVAL(IRQ_NONE);
+		return IRQ_NONE;
 
 	if (status & CIR_WAKE_IRSTS_IR_PENDING)
 		nvt_clear_cir_wake_fifo(nvt);
@@ -879,7 +879,7 @@ static irqreturn_t nvt_cir_wake_isr(int irq, void *data)
 	iren = nvt_cir_wake_reg_read(nvt, CIR_WAKE_IREN);
 	if (!iren) {
 		nvt_dbg_wake("%s exiting, wake not enabled", __func__);
-		return IRQ_RETVAL(IRQ_HANDLED);
+		return IRQ_HANDLED;
 	}
 
 	if ((status & CIR_WAKE_IRSTS_PE) &&
@@ -896,7 +896,7 @@ static irqreturn_t nvt_cir_wake_isr(int irq, void *data)
 	}
 
 	nvt_dbg_wake("%s done", __func__);
-	return IRQ_RETVAL(IRQ_HANDLED);
+	return IRQ_HANDLED;
 }
 
 static void nvt_enable_cir(struct nvt_dev *nvt)
-- 
2.6.2


