Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f51.google.com ([209.85.213.51]:46995 "EHLO
	mail-yw0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756484Ab2FUTxm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jun 2012 15:53:42 -0400
Received: by yhnn12 with SMTP id n12so1035632yhn.10
        for <linux-media@vger.kernel.org>; Thu, 21 Jun 2012 12:53:41 -0700 (PDT)
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Ben Collins <bcollins@bluecherry.net>,
	<linux-media@vger.kernel.org>,
	Ezequiel Garcia <elezegarcia@gmail.com>
Subject: [PATCH 04/10] staging: solo6x10: Use DEFINE_PCI_DEVICE_TABLE for struct pci_device_id
Date: Thu, 21 Jun 2012 16:52:06 -0300
Message-Id: <1340308332-1118-4-git-send-email-elezegarcia@gmail.com>
In-Reply-To: <1340308332-1118-1-git-send-email-elezegarcia@gmail.com>
References: <1340308332-1118-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 drivers/staging/media/solo6x10/core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/media/solo6x10/core.c b/drivers/staging/media/solo6x10/core.c
index d2fd842..8c4f5cf 100644
--- a/drivers/staging/media/solo6x10/core.c
+++ b/drivers/staging/media/solo6x10/core.c
@@ -291,7 +291,7 @@ static void __devexit solo_pci_remove(struct pci_dev *pdev)
 	free_solo_dev(solo_dev);
 }
 
-static struct pci_device_id solo_id_table[] = {
+static DEFINE_PCI_DEVICE_TABLE(solo_id_table) = {
 	/* 6010 based cards */
 	{PCI_DEVICE(PCI_VENDOR_ID_SOFTLOGIC, PCI_DEVICE_ID_SOLO6010)},
 	{PCI_DEVICE(PCI_VENDOR_ID_SOFTLOGIC, PCI_DEVICE_ID_SOLO6110),
-- 
1.7.4.4

