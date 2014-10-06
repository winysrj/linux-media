Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailrelay011.isp.belgacom.be ([195.238.6.178]:18845 "EHLO
	mailrelay011.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753019AbaJFPgs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 6 Oct 2014 11:36:48 -0400
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Fabian Frederick <fabf@skynet.be>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Subject: [PATCH 3/7 linux-next] tw68: remove deprecated IRQF_DISABLED
Date: Mon,  6 Oct 2014 17:35:50 +0200
Message-Id: <1412609755-28627-4-git-send-email-fabf@skynet.be>
In-Reply-To: <1412609755-28627-1-git-send-email-fabf@skynet.be>
References: <1412609755-28627-1-git-send-email-fabf@skynet.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

See include/linux/interrupt.h:
"This flag is a NOOP and scheduled to be removed"

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/media/pci/tw68/tw68-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/tw68/tw68-core.c b/drivers/media/pci/tw68/tw68-core.c
index a6fb48c..63f0b64 100644
--- a/drivers/media/pci/tw68/tw68-core.c
+++ b/drivers/media/pci/tw68/tw68-core.c
@@ -306,7 +306,7 @@ static int tw68_initdev(struct pci_dev *pci_dev,
 
 	/* get irq */
 	err = devm_request_irq(&pci_dev->dev, pci_dev->irq, tw68_irq,
-			  IRQF_SHARED | IRQF_DISABLED, dev->name, dev);
+			  IRQF_SHARED, dev->name, dev);
 	if (err < 0) {
 		pr_err("%s: can't get IRQ %d\n",
 		       dev->name, pci_dev->irq);
-- 
1.9.3

