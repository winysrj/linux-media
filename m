Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:33720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755868AbdLOW6m (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Dec 2017 17:58:42 -0500
Subject: [PATCH] [media] netup_unidvb: use PCI_EXP_DEVCTL2_COMP_TIMEOUT macro
From: Bjorn Helgaas <helgaas@kernel.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Abylay Ospan <aospan@netup.ru>, linux-pci@vger.kernel.org,
        Sergey Kozlov <serjk@netup.ru>, linux-media@vger.kernel.org
Date: Fri, 15 Dec 2017 16:58:38 -0600
Message-ID: <20171215225838.177000.19883.stgit@bhelgaas-glaptop.roam.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Bjorn Helgaas <bhelgaas@google.com>

Use the existing PCI_EXP_DEVCTL2_COMP_TIMEOUT macro instead of hard-coding
the PCIe Completion Timeout Value mask.  No functional change intended.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/media/pci/netup_unidvb/netup_unidvb_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/netup_unidvb/netup_unidvb_core.c b/drivers/media/pci/netup_unidvb/netup_unidvb_core.c
index 11829c0fa138..6cf88a0bf458 100644
--- a/drivers/media/pci/netup_unidvb/netup_unidvb_core.c
+++ b/drivers/media/pci/netup_unidvb/netup_unidvb_core.c
@@ -862,7 +862,7 @@ static int netup_unidvb_initdev(struct pci_dev *pci_dev,
 		PCI_EXP_DEVCTL_NOSNOOP_EN, 0);
 	/* Adjust PCIe completion timeout. */
 	pcie_capability_clear_and_set_word(pci_dev,
-		PCI_EXP_DEVCTL2, 0xf, 0x2);
+		PCI_EXP_DEVCTL2, PCI_EXP_DEVCTL2_COMP_TIMEOUT, 0x2);
 
 	if (netup_unidvb_request_mmio(pci_dev)) {
 		dev_err(&pci_dev->dev,
