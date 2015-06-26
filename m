Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f170.google.com ([209.85.192.170]:35783 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461AbbFZEr7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Jun 2015 00:47:59 -0400
Date: Fri, 26 Jun 2015 10:17:49 +0530
From: Vaishali Thakkar <vthakkar1994@gmail.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [media] ttpci: Replace memset with eth_zero_addr
Message-ID: <20150626044749.GA18942@vaishali-Ideapad-Z570>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use eth_zero_addr to assign the zero address to the given address
array instead of memset when second argument is address of zero.
Note that the 6 in the third argument of memset appears to represent
an ethernet address size (ETH_ALEN).

The Coccinelle semantic patch that makes this change is as follows:

// <smpl>
@eth_zero_addr@
expression e;
@@

-memset(e,0x00,6);
+eth_zero_addr(e);
// </smpl>

Signed-off-by: Vaishali Thakkar <vthakkar1994@gmail.com>
---
 drivers/media/pci/ttpci/budget-av.c    | 2 +-
 drivers/media/pci/ttpci/ttpci-eeprom.c | 5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/media/pci/ttpci/budget-av.c b/drivers/media/pci/ttpci/budget-av.c
index 54c9910..3e469d4 100644
--- a/drivers/media/pci/ttpci/budget-av.c
+++ b/drivers/media/pci/ttpci/budget-av.c
@@ -1508,7 +1508,7 @@ static int budget_av_attach(struct saa7146_dev *dev, struct saa7146_pci_extensio
 	if (i2c_readregs(&budget_av->budget.i2c_adap, 0xa0, 0x30, mac, 6)) {
 		pr_err("KNC1-%d: Could not read MAC from KNC1 card\n",
 		       budget_av->budget.dvb_adapter.num);
-		memset(mac, 0, 6);
+		eth_zero_addr(mac);
 	} else {
 		pr_info("KNC1-%d: MAC addr = %pM\n",
 			budget_av->budget.dvb_adapter.num, mac);
diff --git a/drivers/media/pci/ttpci/ttpci-eeprom.c b/drivers/media/pci/ttpci/ttpci-eeprom.c
index 32d4315..01e13c4 100644
--- a/drivers/media/pci/ttpci/ttpci-eeprom.c
+++ b/drivers/media/pci/ttpci/ttpci-eeprom.c
@@ -36,6 +36,7 @@
 #include <linux/module.h>
 #include <linux/string.h>
 #include <linux/i2c.h>
+#include <linux/etherdevice.h>
 
 #include "ttpci-eeprom.h"
 
@@ -145,7 +146,7 @@ int ttpci_eeprom_parse_mac(struct i2c_adapter *adapter, u8 *proposed_mac)
 
 	if (ret != 0) {		/* Will only be -ENODEV */
 		dprintk("Couldn't read from EEPROM: not there?\n");
-		memset(proposed_mac, 0, 6);
+		eth_zero_addr(proposed_mac);
 		return ret;
 	}
 
@@ -157,7 +158,7 @@ int ttpci_eeprom_parse_mac(struct i2c_adapter *adapter, u8 *proposed_mac)
 			dprintk( "%.2x:", encodedMAC[i]);
 		}
 		dprintk("%.2x\n", encodedMAC[19]);
-		memset(proposed_mac, 0, 6);
+		eth_zero_addr(proposed_mac);
 		return ret;
 	}
 
-- 
1.9.1

