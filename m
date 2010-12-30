Return-path: <mchehab@gaivota>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:59254 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586Ab0L3XIU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Dec 2010 18:08:20 -0500
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-m68k@lists.linux-m68k.org, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, ivtv-devel@ivtvdriver.org,
	linux-media@vger.kernel.org, linux-wireless@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	spi-devel-general@lists.sourceforge.net,
	devel@driverdev.osuosl.org, linux-usb@vger.kernel.org,
	"Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 05/15]drivers:staging:vt6655:rf.c Typo change diable to disable.
Date: Thu, 30 Dec 2010 15:07:54 -0800
Message-Id: <1293750484-1161-5-git-send-email-justinmattock@gmail.com>
In-Reply-To: <1293750484-1161-4-git-send-email-justinmattock@gmail.com>
References: <1293750484-1161-1-git-send-email-justinmattock@gmail.com>
 <1293750484-1161-2-git-send-email-justinmattock@gmail.com>
 <1293750484-1161-3-git-send-email-justinmattock@gmail.com>
 <1293750484-1161-4-git-send-email-justinmattock@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

The below patch fixes a typo "diable" to "disable". Please let me know if this 
is correct or not.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/staging/vt6655/rf.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/vt6655/rf.c b/drivers/staging/vt6655/rf.c
index b8ec783..cdd9165 100644
--- a/drivers/staging/vt6655/rf.c
+++ b/drivers/staging/vt6655/rf.c
@@ -496,11 +496,11 @@ bool s_bAL7230Init (unsigned long dwIoBase)
 
     //Calibration
     MACvTimer0MicroSDelay(dwIoBase, 150);//150us
-    bResult &= IFRFbWriteEmbeded(dwIoBase, (0x9ABA8F00+(BY_AL7230_REG_LEN<<3)+IFREGCTL_REGW)); //TXDCOC:active, RCK:diable
+    bResult &= IFRFbWriteEmbeded(dwIoBase, (0x9ABA8F00+(BY_AL7230_REG_LEN<<3)+IFREGCTL_REGW)); //TXDCOC:active, RCK:disable
     MACvTimer0MicroSDelay(dwIoBase, 30);//30us
-    bResult &= IFRFbWriteEmbeded(dwIoBase, (0x3ABA8F00+(BY_AL7230_REG_LEN<<3)+IFREGCTL_REGW)); //TXDCOC:diable, RCK:active
+    bResult &= IFRFbWriteEmbeded(dwIoBase, (0x3ABA8F00+(BY_AL7230_REG_LEN<<3)+IFREGCTL_REGW)); //TXDCOC:disable, RCK:active
     MACvTimer0MicroSDelay(dwIoBase, 30);//30us
-    bResult &= IFRFbWriteEmbeded(dwIoBase, dwAL7230InitTable[CB_AL7230_INIT_SEQ-1]); //TXDCOC:diable, RCK:diable
+    bResult &= IFRFbWriteEmbeded(dwIoBase, dwAL7230InitTable[CB_AL7230_INIT_SEQ-1]); //TXDCOC:diable, RCK:disable
 
     MACvWordRegBitsOn(dwIoBase, MAC_REG_SOFTPWRCTL, (SOFTPWRCTL_SWPE3    |
                                                      SOFTPWRCTL_SWPE2    |
-- 
1.6.5.2.180.gc5b3e

