Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:38454 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754674Ab1GVSRy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jul 2011 14:17:54 -0400
To: linux-media@vger.kernel.org, mchehab@infradead.org
Subject: [PATCH] bt8xx: use pci_dev->subsystem_{vendor|device}
Content-Disposition: inline
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Date: Fri, 22 Jul 2011 22:16:04 +0400
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107222216.04703.sshtylyov@ru.mvista.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The driver reads PCI subsystem IDs from the PCI configuration registers while
they are already stored by the PCI subsystem in the 'subsystem_{vendor|device}'
fields of 'struct pci_dev'...

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

---
The patch is against the recent Linus' tree.

 drivers/media/video/bt8xx/bttv-cards.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

Index: linux-2.6/drivers/media/video/bt8xx/bttv-cards.c
===================================================================
--- linux-2.6.orig/drivers/media/video/bt8xx/bttv-cards.c
+++ linux-2.6/drivers/media/video/bt8xx/bttv-cards.c
@@ -2892,13 +2892,10 @@ void __devinit bttv_idcard(struct bttv *
 {
 	unsigned int gpiobits;
 	int i,type;
-	unsigned short tmp;
 
 	/* read PCI subsystem ID */
-	pci_read_config_word(btv->c.pci, PCI_SUBSYSTEM_ID, &tmp);
-	btv->cardid = tmp << 16;
-	pci_read_config_word(btv->c.pci, PCI_SUBSYSTEM_VENDOR_ID, &tmp);
-	btv->cardid |= tmp;
+	btv->cardid  = btv->c.pci->subsystem_device << 16;
+	btv->cardid |= btv->c.pci->subsystem_vendor;
 
 	if (0 != btv->cardid && 0xffffffff != btv->cardid) {
 		/* look for the card */
