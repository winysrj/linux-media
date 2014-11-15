Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:39707 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222AbaKOKxe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Nov 2014 05:53:34 -0500
Received: by mail-wi0-f177.google.com with SMTP id l15so4934513wiw.10
        for <linux-media@vger.kernel.org>; Sat, 15 Nov 2014 02:53:32 -0800 (PST)
From: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
To: khalasa@piap.pl, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, m.chehab@samsung.com,
	hverkuil@xs4all.nl
Subject: [PATCH] solo6x10: fix a race in IRQ handler
Date: Sat, 15 Nov 2014 14:52:26 +0400
Message-Id: <1416048746-12717-1-git-send-email-andrey.utkin@corp.bluecherry.net>
In-Reply-To: <m3lhneez9h.fsf@t19.piap.pl>
References: <m3lhneez9h.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Krzysztof Hałasa <khalasa@piap.pl>

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
