Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0153.hostedemail.com ([216.40.44.153]:36103 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753379AbbFOCBs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Jun 2015 22:01:48 -0400
Message-ID: <1434333705.2507.32.camel@perches.com>
Subject: [PATCH] media: ttpci:  Use vsprintf %pM extension
From: Joe Perches <joe@perches.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sun, 14 Jun 2015 19:01:45 -0700
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Format mac addresses with the normal kernel extension.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/media/pci/ttpci/ttpci-eeprom.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/media/pci/ttpci/ttpci-eeprom.c b/drivers/media/pci/ttpci/ttpci-eeprom.c
index 32d4315..c6f31f2 100644
--- a/drivers/media/pci/ttpci/ttpci-eeprom.c
+++ b/drivers/media/pci/ttpci/ttpci-eeprom.c
@@ -162,9 +162,7 @@ int ttpci_eeprom_parse_mac(struct i2c_adapter *adapter, u8 *proposed_mac)
 	}
 
 	memcpy(proposed_mac, decodedMAC, 6);
-	dprintk("adapter has MAC addr = %.2x:%.2x:%.2x:%.2x:%.2x:%.2x\n",
-		decodedMAC[0], decodedMAC[1], decodedMAC[2],
-		decodedMAC[3], decodedMAC[4], decodedMAC[5]);
+	dprintk("adapter has MAC addr = %pM\n", decodedMAC);
 	return 0;
 }
 


