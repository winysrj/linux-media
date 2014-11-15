Return-Path: <andrey.utkin@corp.bluecherry.net>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
From: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
To: khalasa@piap.pl, linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
 m.chehab@samsung.com, hverkuil@xs4all.nl
Subject: SOLO6x10: fix a race in IRQ handler.
Date: Sat, 15 Nov 2014 14:34:35 +0400
Message-id: <m3lhneez9h.fsf@t19.piap.pl>
In-reply-to: <m3lhneez9h.fsf@t19.piap.pl>
References: <m3lhneez9h.fsf@t19.piap.pl>
Received: from ni.piap.pl
 ([195.187.100.4]:56387 "EHLO ni.piap.pl" rhost-flags-OK-OK-OK-OK)
 by vger.kernel.org with ESMTP id S965171AbaKNMfI convert rfc822-to-8bit
 (ORCPT <rfc822;linux-media@vger.kernel.org>); Fri, 14 Nov 2014 07:35:08 -0500
Received: from ni.piap.pl (localhost.localdomain [127.0.0.1])
 by ni.piap.pl (Postfix) with ESMTP id E64124412B3 for
 <linux-media@vger.kernel.org>; Fri, 14 Nov 2014 13:35:06 +0100 (CET)
Content-transfer-encoding: 8BIT
List-Id: <linux-media.vger.kernel.org>

From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)

The IRQs have to be acknowledged before they are serviced, otherwise some events
may be skipped. Also, acknowledging IRQs just before returning from the handler
doesn't leave enough time for the device to deassert the INTx line, and for
bridges to propagate this change. This resulted in twice the IRQ rate on ARMv6
dual core CPU.

Signed-off-by: Krzysztof Hałasa <khalasa@piap.pl>
Acked-by: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
Tested-by: Andrey Utkin <andrey.utkin@corp.bluecherry.net>

--- a/drivers/media/pci/solo6x10/solo6x10-core.c
+++ b/drivers/media/pci/solo6x10/solo6x10-core.c
@@ -105,11 +105,8 @@ static irqreturn_t solo_isr(int irq, void *data)
 	if (!status)
 		return IRQ_NONE;
 
-	if (status & ~solo_dev->irq_mask) {
-		solo_reg_write(solo_dev, SOLO_IRQ_STAT,
-			       status & ~solo_dev->irq_mask);
-		status &= solo_dev->irq_mask;
-	}
+	/* Acknowledge all interrupts immediately */
+	solo_reg_write(solo_dev, SOLO_IRQ_STAT, status);
 
 	if (status & SOLO_IRQ_PCI_ERR)
 		solo_p2m_error_isr(solo_dev);
@@ -132,9 +129,6 @@ static irqreturn_t solo_isr(int irq, void *data)
 	if (status & SOLO_IRQ_G723)
 		solo_g723_isr(solo_dev);
 
-	/* Clear all interrupts handled */
-	solo_reg_write(solo_dev, SOLO_IRQ_STAT, status);
-
 	return IRQ_HANDLED;
 }
