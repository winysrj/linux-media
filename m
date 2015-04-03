Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:44878 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751702AbbDCLNr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 3 Apr 2015 07:13:47 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id EAEAD2A009F
	for <linux-media@vger.kernel.org>; Fri,  3 Apr 2015 13:13:14 +0200 (CEST)
Message-ID: <551E75CA.4050308@xs4all.nl>
Date: Fri, 03 Apr 2015 13:13:14 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] bttv: fix missing irq after reloading driver
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If pci_disable_device() isn't called when the driver is removed, then
the next time when it is loaded the irq isn't found.

I'm pretty sure this used to work in the past, but calling pci_disable_device()
is clearly the correct method and this makes it work again.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
index 4ec2a3c..cdf8d2e 100644
--- a/drivers/media/pci/bt8xx/bttv-driver.c
+++ b/drivers/media/pci/bt8xx/bttv-driver.c
@@ -4267,6 +4267,7 @@ fail0:
 		iounmap(btv->bt848_mmio);
 	release_mem_region(pci_resource_start(btv->c.pci,0),
 			   pci_resource_len(btv->c.pci,0));
+	pci_disable_device(btv->c.pci);
 	return result;
 }
 
@@ -4310,6 +4311,7 @@ static void bttv_remove(struct pci_dev *pci_dev)
 	iounmap(btv->bt848_mmio);
 	release_mem_region(pci_resource_start(btv->c.pci,0),
 			   pci_resource_len(btv->c.pci,0));
+	pci_disable_device(btv->c.pci);
 
 	v4l2_device_unregister(&btv->c.v4l2_dev);
 	bttvs[btv->c.nr] = NULL;
