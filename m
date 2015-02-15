Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:62106 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754845AbbBOMLq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Feb 2015 07:11:46 -0500
From: Silvan Jegen <s.jegen@gmail.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Cc: Silvan Jegen <s.jegen@gmail.com>, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [PATCH 2/2] [media] mantis: Use correct goto labels for cleanup on error
Date: Sun, 15 Feb 2015 13:11:05 +0100
Message-Id: <1424002265-16865-3-git-send-email-s.jegen@gmail.com>
In-Reply-To: <1424002265-16865-1-git-send-email-s.jegen@gmail.com>
References: <1424002265-16865-1-git-send-email-s.jegen@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

After calling mantis_pci_init we have to jump to fail2 in order to call
the corresponding mantis_pci_exit. Similarly, after calling mantis_get_mac
we have already called mantis_pci_init and mantis_i2c_init so we need
to jump to fail3 if we want to call the corresponding exit functions.

Signed-off-by: Silvan Jegen <s.jegen@gmail.com>
---
 drivers/media/pci/mantis/mantis_cards.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/mantis/mantis_cards.c b/drivers/media/pci/mantis/mantis_cards.c
index e566061..71497d8 100644
--- a/drivers/media/pci/mantis/mantis_cards.c
+++ b/drivers/media/pci/mantis/mantis_cards.c
@@ -183,7 +183,7 @@ static int mantis_pci_probe(struct pci_dev *pdev,
 	err = mantis_pci_init(mantis);
 	if (err) {
 		dprintk(MANTIS_ERROR, 1, "ERROR: Mantis PCI initialization failed <%d>", err);
-		goto fail1;
+		goto fail2;
 	}
 
 	err = mantis_stream_control(mantis, STREAM_TO_HIF);
@@ -201,7 +201,7 @@ static int mantis_pci_probe(struct pci_dev *pdev,
 	err = mantis_get_mac(mantis);
 	if (err < 0) {
 		dprintk(MANTIS_ERROR, 1, "ERROR: Mantis MAC address read failed <%d>", err);
-		goto fail2;
+		goto fail3;
 	}
 
 	err = mantis_dma_init(mantis);
-- 
2.2.2

