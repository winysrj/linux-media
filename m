Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:34447 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753097AbdHTOgw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 20 Aug 2017 10:36:52 -0400
Received: by mail-wr0-f196.google.com with SMTP id p14so8262105wrg.1
        for <linux-media@vger.kernel.org>; Sun, 20 Aug 2017 07:36:52 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Cc: jasmin@anw.at, mchehab@kernel.org
Subject: [PATCH 2/3] [media_build] patch pci_alloc_irq_vectors() for ddbridge aswell
Date: Sun, 20 Aug 2017 16:36:47 +0200
Message-Id: <20170820143648.27669-3-d.scheller.oss@gmail.com>
In-Reply-To: <20170820143648.27669-1-d.scheller.oss@gmail.com>
References: <20170820143648.27669-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 backports/v4.7_pci_alloc_irq_vectors.patch | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/backports/v4.7_pci_alloc_irq_vectors.patch b/backports/v4.7_pci_alloc_irq_vectors.patch
index 64867fa..e15d521 100644
--- a/backports/v4.7_pci_alloc_irq_vectors.patch
+++ b/backports/v4.7_pci_alloc_irq_vectors.patch
@@ -42,3 +42,16 @@ index 00f773e..ed00dc9 100644
  	/* omnitek dma */
  	int dma_channels;
  	int first_fifo_channel;
+diff --git a/drivers/media/pci/ddbridge/ddbridge.c b/drivers/media/pci/ddbridge/ddbridge.c
+index fab421f..031288a 100644
+--- a/drivers/media/pci/ddbridge/ddbridge-main.c
++++ b/drivers/media/pci/ddbridge/ddbridge-main.c
+@@ -109,7 +109,7 @@ static void ddb_irq_msi(struct ddb *dev, int nr)
+ 	int stat;
+ 
+ 	if (msi && pci_msi_enabled()) {
+-		stat = pci_alloc_irq_vectors(dev->pdev, 1, nr, PCI_IRQ_MSI);
++		stat = pci_enable_msi_range(dev->pdev, 1, nr);
+ 		if (stat >= 1) {
+ 			dev->msi = stat;
+ 			dev_info(dev->dev, "using %d MSI interrupt(s)\n",
-- 
2.13.0
