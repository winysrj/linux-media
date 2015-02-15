Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:63982 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754749AbbBOMLp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Feb 2015 07:11:45 -0500
From: Silvan Jegen <s.jegen@gmail.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Cc: Silvan Jegen <s.jegen@gmail.com>, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [PATCH 1/2] [media] mantis: Move jump label to activate dead code
Date: Sun, 15 Feb 2015 13:11:04 +0100
Message-Id: <1424002265-16865-2-git-send-email-s.jegen@gmail.com>
In-Reply-To: <1424002265-16865-1-git-send-email-s.jegen@gmail.com>
References: <1424002265-16865-1-git-send-email-s.jegen@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Due to a misplaced goto label mantis_uart_exit is never called.  Adjusting
the label position (while correcting its numbering) changes this.

This issue was found using the smatch static checker.

Signed-off-by: Silvan Jegen <s.jegen@gmail.com>
---
 drivers/media/pci/mantis/mantis_cards.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/mantis/mantis_cards.c b/drivers/media/pci/mantis/mantis_cards.c
index 801fc55..e566061 100644
--- a/drivers/media/pci/mantis/mantis_cards.c
+++ b/drivers/media/pci/mantis/mantis_cards.c
@@ -215,10 +215,11 @@ static int mantis_pci_probe(struct pci_dev *pdev,
 		dprintk(MANTIS_ERROR, 1, "ERROR: Mantis DVB initialization failed <%d>", err);
 		goto fail4;
 	}
+
 	err = mantis_uart_init(mantis);
 	if (err < 0) {
 		dprintk(MANTIS_ERROR, 1, "ERROR: Mantis UART initialization failed <%d>", err);
-		goto fail6;
+		goto fail5;
 	}
 
 	devs++;
@@ -226,10 +227,10 @@ static int mantis_pci_probe(struct pci_dev *pdev,
 	return err;
 
 
+fail5:
 	dprintk(MANTIS_ERROR, 1, "ERROR: Mantis UART exit! <%d>", err);
 	mantis_uart_exit(mantis);
 
-fail6:
 fail4:
 	dprintk(MANTIS_ERROR, 1, "ERROR: Mantis DMA exit! <%d>", err);
 	mantis_dma_exit(mantis);
-- 
2.2.2

