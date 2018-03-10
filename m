Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:34074 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752085AbeCJMYr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 10 Mar 2018 07:24:47 -0500
Received: by mail-wr0-f194.google.com with SMTP id o8so11411747wra.1
        for <linux-media@vger.kernel.org>; Sat, 10 Mar 2018 04:24:46 -0800 (PST)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Subject: [PATCH] [media] ttpci: improve printing of encoded MAC address
Date: Sat, 10 Mar 2018 13:24:43 +0100
Message-Id: <20180310122443.32652-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

When loading the budget_av driver for ie. a KNC1 DVB-C TDA10024 card,
which makes use of the ttpci eeprom check functionality (that always
fails on these cards, but that's no issue at all), this is printed
to the kernel log:

  [   10.497333] saa7146 (0): dma buffer size 192512
  [   10.497335] dvbdev: DVB: registering new adapter (KNC1 DVB-C TDA10024)
  [   10.545007] adapter failed MAC signature check
  [   10.545009] encoded MAC from EEPROM was
  [   10.545010] ff:
  [   10.545011] ff:
  [   10.545011] ff:
  ...
  [   10.545021] ff
  [   10.832422] budget_av: KNC1-4: MAC addr = 00:09:d6:6d:b3:be

with the 'ff' being repeated for a total of 20 times. Improve that by
using the %*phC format specifier instead dprintk()'ing every byte of the
encoded MAC separately. This obsoletes the int i, and the kernel log
looks cleaner:

  [ 3234.383153] saa7146 (0): dma buffer size 192512
  [ 3234.383154] dvbdev: DVB: registering new adapter (KNC1 DVB-C TDA10024)
  [ 3234.428745] adapter failed MAC signature check
  [ 3234.428747] encoded MAC from EEPROM was ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff
  [ 3234.728194] budget_av: KNC1-0: MAC addr = 00:09:d6:6d:b3:be

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/pci/ttpci/ttpci-eeprom.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/media/pci/ttpci/ttpci-eeprom.c b/drivers/media/pci/ttpci/ttpci-eeprom.c
index 9534f29c1ffd..78c7a6589be5 100644
--- a/drivers/media/pci/ttpci/ttpci-eeprom.c
+++ b/drivers/media/pci/ttpci/ttpci-eeprom.c
@@ -138,7 +138,7 @@ static int ttpci_eeprom_read_encodedMAC(struct i2c_adapter *adapter, u8 * encode
 
 int ttpci_eeprom_parse_mac(struct i2c_adapter *adapter, u8 *proposed_mac)
 {
-	int ret, i;
+	int ret;
 	u8 encodedMAC[20];
 	u8 decodedMAC[6];
 
@@ -153,11 +153,8 @@ int ttpci_eeprom_parse_mac(struct i2c_adapter *adapter, u8 *proposed_mac)
 	ret = getmac_tt(decodedMAC, encodedMAC);
 	if( ret != 0 ) {
 		dprintk("adapter failed MAC signature check\n");
-		dprintk("encoded MAC from EEPROM was " );
-		for(i=0; i<19; i++) {
-			dprintk( "%.2x:", encodedMAC[i]);
-		}
-		dprintk("%.2x\n", encodedMAC[19]);
+		dprintk("encoded MAC from EEPROM was %*phC",
+			(int)sizeof(encodedMAC), &encodedMAC);
 		eth_zero_addr(proposed_mac);
 		return ret;
 	}
-- 
2.16.1
