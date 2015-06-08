Return-path: <linux-media-owner@vger.kernel.org>
Received: from ni.piap.pl ([195.187.100.4]:53522 "EHLO ni.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751075AbbFHNhR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Jun 2015 09:37:17 -0400
Received: from t19.piap.pl (OSB1819.piap.pl [10.0.9.19])
	by ni.piap.pl (Postfix) with ESMTP id CEE82440102
	for <linux-media@vger.kernel.org>; Mon,  8 Jun 2015 15:37:15 +0200 (CEST)
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: linux-media <linux-media@vger.kernel.org>
Subject: [PATCH] SOLO6x10: unmap registers only after free_irq().
References: <m3a8waxr86.fsf@t19.piap.pl>
Date: Mon, 08 Jun 2015 15:37:15 +0200
In-Reply-To: <m3a8waxr86.fsf@t19.piap.pl> ("Krzysztof \=\?utf-8\?Q\?Ha\=C5\=82as\?\=
 \=\?utf-8\?Q\?a\=22's\?\= message of
	"Mon, 08 Jun 2015 15:30:17 +0200")
Message-ID: <m3y4juwcc4.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixes a panic on ARM. Diagnosis by Russell King.

Signed-off-by: Krzysztof Hałasa <khalasa@piap.pl>

--- a/drivers/media/pci/solo6x10/solo6x10-core.c
+++ b/drivers/media/pci/solo6x10/solo6x10-core.c
@@ -164,9 +164,9 @@ static void free_solo_dev(struct solo_dev *solo_dev)
 
 		/* Now cleanup the PCI device */
 		solo_irq_off(solo_dev, ~0);
-		pci_iounmap(pdev, solo_dev->reg_base);
 		if (pdev->irq)
 			free_irq(pdev->irq, solo_dev);
+		pci_iounmap(pdev, solo_dev->reg_base);
 	}
 
 	pci_release_regions(pdev);
