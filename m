Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:55743 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934081AbZC0BEg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Mar 2009 21:04:36 -0400
Received: from 200.220.139.66.nipcable.com ([200.220.139.66] helo=pedra.chehab.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.69 #1 (Red Hat Linux))
	id 1Ln0Ur-0005Wz-LL
	for linux-media@vger.kernel.org; Fri, 27 Mar 2009 01:04:34 +0000
Date: Thu, 26 Mar 2009 22:04:28 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Fw: [PATCH] cx88: Missing failure checks
Message-ID: <20090326220428.50523141@pedra.chehab.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



Forwarded message:

Date: Thu, 26 Mar 2009 20:44:38 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: linux-kernel@vger.kernel.org, mchehab@infradead.org
Subject: [PATCH] cx88: Missing failure checks


The ioremap one was reported in October 2007 (Bug 9146), the kmalloc one
was blindingly obvious while looking at the ioremap one

The bug suggests some other configuration for lots of I/O memory (32MB per
device is ioremapped) but I'll leave that to the real maintainers

Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
---

 drivers/media/video/cx88/cx88-cards.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)


diff --git a/drivers/media/video/cx88/cx88-cards.c b/drivers/media/video/cx88/cx88-cards.c
index 733ede3..2fa02cf 100644
--- a/drivers/media/video/cx88/cx88-cards.c
+++ b/drivers/media/video/cx88/cx88-cards.c
@@ -3089,6 +3089,8 @@ struct cx88_core *cx88_core_create(struct pci_dev *pci, int nr)
 	int i;
 
 	core = kzalloc(sizeof(*core), GFP_KERNEL);
+	if (core == NULL)
+		return NULL;
 
 	atomic_inc(&core->refcount);
 	core->pci_bus  = pci->bus->number;
@@ -3110,6 +3112,11 @@ struct cx88_core *cx88_core_create(struct pci_dev *pci, int nr)
 	core->lmmio = ioremap(pci_resource_start(pci, 0),
 			      pci_resource_len(pci, 0));
 	core->bmmio = (u8 __iomem *)core->lmmio;
+	
+	if (core->lmmio == NULL) {
+		kfree(core);
+		return NULL;
+	}
 
 	/* board config */
 	core->boardnr = UNSET;





Cheers,
Mauro
