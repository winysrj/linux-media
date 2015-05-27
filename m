Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f170.google.com ([209.85.192.170]:36575 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495AbbE0OaZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 May 2015 10:30:25 -0400
Received: by pdfh10 with SMTP id h10so17518330pdf.3
        for <linux-media@vger.kernel.org>; Wed, 27 May 2015 07:30:25 -0700 (PDT)
From: Takeshi Yoshimura <yos@sslab.ics.keio.ac.jp>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Markus Elfring <elfring@users.sourceforge.net>,
	Christopher Reimer <linux@creimer.net>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Takeshi Yoshimura <yos@sslab.ics.keio.ac.jp>
Subject: [PATCH 1/1] [media] ddbridge: Do not free_irq() if request_irq() failed
Date: Wed, 27 May 2015 14:28:14 +0000
Message-Id: <1432736894-10368-1-git-send-email-yos@sslab.ics.keio.ac.jp>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Takeshi Yoshimura <yos@sslab.ics.keio.ac.jp>

My static checker detected that free_irq() is called even after 
request_irq() failed in ddb_probe(). In this case, the kernel may try to 
free dev->pdev->irq although the IRQ is not assigned. This event rarely 
occurs, but always introduces a warning if it happens.

"goto fail1" always results in disabling enabled MSI and releasing a 
requested IRQ. It seems like the former handling is necessary. So I added
a conditional branch before the free_irq() (stat == 0 means request_irq() 
succeeds).

Signed-off-by: Takeshi Yoshimura <yos@sslab.ics.keio.ac.jp>
---
 drivers/media/pci/ddbridge/ddbridge-core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index 9e3492e..0ac2dd3 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -1630,7 +1630,8 @@ fail1:
 	printk(KERN_ERR "fail1\n");
 	if (dev->msi)
 		pci_disable_msi(dev->pdev);
-	free_irq(dev->pdev->irq, dev);
+	if (stat == 0)
+		free_irq(dev->pdev->irq, dev);
 fail:
 	printk(KERN_ERR "fail\n");
 	ddb_unmap(dev);
-- 
2.1.0

