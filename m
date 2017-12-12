Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:38915 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752410AbdLLRtF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Dec 2017 12:49:05 -0500
Received: by mail-wm0-f65.google.com with SMTP id i11so301803wmf.4
        for <linux-media@vger.kernel.org>; Tue, 12 Dec 2017 09:49:04 -0800 (PST)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Cc: jasmin@anw.at
Subject: [PATCH] [build] fixup v3.13_ddbridge_pcimsi.patch
Date: Tue, 12 Dec 2017 18:49:01 +0100
Message-Id: <20171212174901.14781-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jasmin Jessich <jasmin@anw.at>

Required after the ddbridge 0.9.32 bump in media_tree.

Signed-off-by: Jasmin Jessich <jasmin@anw.at>
Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
Fixes at least the patch issue with kernel <=3.13. Jasmin originally
prepared the updated patch when the ddbridge-0.9.32 bump was done, so
sending it in behalf of her (with CONFIG_VIDEO_PVRUSB2 disabled this
makes the patch phase work again with older kernels).

Hans, this is probably for you. I don't have a fix for the PVRUSB2
usb_urb_ep_type_check() issue at hands though.

 backports/v3.13_ddbridge_pcimsi.patch | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/backports/v3.13_ddbridge_pcimsi.patch b/backports/v3.13_ddbridge_pcimsi.patch
index 5f602a7..f410251 100644
--- a/backports/v3.13_ddbridge_pcimsi.patch
+++ b/backports/v3.13_ddbridge_pcimsi.patch
@@ -2,7 +2,7 @@ diff --git a/drivers/media/pci/ddbridge/ddbridge-main.c b/drivers/media/pci/ddbr
 index 9ab4736..50c3b4f 100644
 --- a/drivers/media/pci/ddbridge/ddbridge-main.c
 +++ b/drivers/media/pci/ddbridge/ddbridge-main.c
-@@ -129,13 +129,18 @@ static void ddb_irq_msi(struct ddb *dev, int nr)
+@@ -129,14 +129,18 @@ static void ddb_irq_msi(struct ddb *dev, int nr)
  	int stat;
  
  	if (msi && pci_msi_enabled()) {
@@ -10,17 +10,18 @@ index 9ab4736..50c3b4f 100644
 -		if (stat >= 1) {
 -			dev->msi = stat;
 -			dev_info(dev->dev, "using %d MSI interrupt(s)\n",
--				dev->msi);
--		} else
+-				 dev->msi);
+-		} else {
+-			dev_info(dev->dev, "MSI not available.\n");
 +		stat = pci_enable_msi_block(dev->pdev, nr);
 +		if (stat == 0) {
 +			dev->msi = nr;
 +		} else if (stat == 1) {
 +			stat = pci_enable_msi(dev->pdev);
 +			dev->msi = 1;
-+		}
+ 		}
 +		if (stat < 0)
- 			dev_info(dev->dev, "MSI not available.\n");
++			dev_info(dev->dev, "MSI not available.\n");
 +		else
 +			dev_info(dev->dev, "using %d MSI interrupts\n",
 +				 dev->msi);
-- 
2.13.6
