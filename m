Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:56116 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751622AbbGQLqY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jul 2015 07:46:24 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id B41CF2A0091
	for <linux-media@vger.kernel.org>; Fri, 17 Jul 2015 13:45:22 +0200 (CEST)
Message-ID: <55A8EAD2.1050202@xs4all.nl>
Date: Fri, 17 Jul 2015 13:45:22 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] cobalt: allow fewer than 8 PCIe lanes
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently the cobalt driver refuses to load if fewer than 8 PCIe lanes
are assigned. This patch changes this and just issues a warning. The
only time it will refuse to load is if the number of assigned lanes is less
than what the PCIe host is capable of since this suggests that the card
isn't seated correctly in the slot.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/drivers/media/pci/cobalt/cobalt-driver.c b/drivers/media/pci/cobalt/cobalt-driver.c
index b994b8e..8fed61e 100644
--- a/drivers/media/pci/cobalt/cobalt-driver.c
+++ b/drivers/media/pci/cobalt/cobalt-driver.c
@@ -339,15 +339,16 @@ static int cobalt_setup_pci(struct cobalt *cobalt, struct pci_dev *pci_dev,
 	}
 
 	if (pcie_link_get_lanes(cobalt) != 8) {
-		cobalt_err("PCI Express link width is not 8 lanes (%d)\n",
+		cobalt_warn("PCI Express link width is %d lanes.\n",
 				pcie_link_get_lanes(cobalt));
 		if (pcie_bus_link_get_lanes(cobalt) < 8)
-			cobalt_err("The current slot only supports %d lanes, at least 8 are needed\n",
+			cobalt_warn("The current slot only supports %d lanes, for best performance 8 are needed\n",
 					pcie_bus_link_get_lanes(cobalt));
-		else
+		if (pcie_link_get_lanes(cobalt) != pcie_bus_link_get_lanes(cobalt)) {
 			cobalt_err("The card is most likely not seated correctly in the PCIe slot\n");
-		ret = -EIO;
-		goto err_disable;
+			ret = -EIO;
+			goto err_disable;
+		}
 	}
 
 	if (pci_set_dma_mask(pci_dev, DMA_BIT_MASK(64))) {
