Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:55425 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728168AbeJ0XJk (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 27 Oct 2018 19:09:40 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH] media: saa7134: rc device does not need 'saa7134 IR (' prefix
Date: Sat, 27 Oct 2018 15:28:29 +0100
Message-Id: <20181027142829.12326-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Before this patch, the rc name is truncated to:

	saa7134 IR (Hauppauge WinTV-HVR

Now it is:

	Hauppauge WinTV-HVR1150 ATSC/QAM-Hybrid

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/pci/saa7134/saa7134-input.c | 4 +---
 drivers/media/pci/saa7134/saa7134.h       | 1 -
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/media/pci/saa7134/saa7134-input.c b/drivers/media/pci/saa7134/saa7134-input.c
index 999b2774b220..6e6d68964017 100644
--- a/drivers/media/pci/saa7134/saa7134-input.c
+++ b/drivers/media/pci/saa7134/saa7134-input.c
@@ -880,8 +880,6 @@ int saa7134_input_init1(struct saa7134_dev *dev)
 	ir->raw_decode	 = raw_decode;
 
 	/* init input device */
-	snprintf(ir->name, sizeof(ir->name), "saa7134 IR (%s)",
-		 saa7134_boards[dev->board].name);
 	snprintf(ir->phys, sizeof(ir->phys), "pci-%s/ir0",
 		 pci_name(dev->pci));
 
@@ -893,7 +891,7 @@ int saa7134_input_init1(struct saa7134_dev *dev)
 		rc->allowed_protocols = RC_PROTO_BIT_ALL_IR_DECODER;
 	}
 
-	rc->device_name = ir->name;
+	rc->device_name = saa7134_boards[dev->board].name;
 	rc->input_phys = ir->phys;
 	rc->input_id.bustype = BUS_PCI;
 	rc->input_id.version = 1;
diff --git a/drivers/media/pci/saa7134/saa7134.h b/drivers/media/pci/saa7134/saa7134.h
index 480228456014..1c3f273f7dd2 100644
--- a/drivers/media/pci/saa7134/saa7134.h
+++ b/drivers/media/pci/saa7134/saa7134.h
@@ -123,7 +123,6 @@ struct saa7134_format {
 struct saa7134_card_ir {
 	struct rc_dev		*dev;
 
-	char                    name[32];
 	char                    phys[32];
 	unsigned                users;
 
-- 
2.17.2
