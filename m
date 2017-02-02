Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.135]:56195 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751441AbdBBOwA (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 2 Feb 2017 09:52:00 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] [media] ttpci: address stringop overflow warning
Date: Thu,  2 Feb 2017 15:51:28 +0100
Message-Id: <20170202145151.3786590-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

gcc-7.0.1 warns about old code in ttpci:

In file included from drivers/media/pci/ttpci/av7110.c:63:0:
In function 'irdebi.isra.2',
    inlined from 'start_debi_dma' at drivers/media/pci/ttpci/av7110.c:376:3,
    inlined from 'gpioirq' at drivers/media/pci/ttpci/av7110.c:659:3:
drivers/media/pci/ttpci/av7110_hw.h:406:3: warning: 'memcpy': specified size between 18446744071562067968 and 18446744073709551615 exceeds maximum object size 9223372036854775807 [-Wstringop-overflow=]
   memcpy(av7110->debi_virt, (char *) &res, count);
In function 'irdebi.isra.2',
    inlined from 'start_debi_dma' at drivers/media/pci/ttpci/av7110.c:376:3,
    inlined from 'gpioirq' at drivers/media/pci/ttpci/av7110.c:668:3:
drivers/media/pci/ttpci/av7110_hw.h:406:3: warning: 'memcpy': specified size between 18446744071562067968 and 18446744073709551615 exceeds maximum object size 9223372036854775807 [-Wstringop-overflow=]
   memcpy(av7110->debi_virt, (char *) &res, count);

Apparently, 'count' can be negative here, which will then get turned
into a giant size argument for memcpy. Changing the sizes to 'unsigned
int' instead seems safe as we already check for maximum sizes, and it
also simplifies the code a bit.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/pci/ttpci/av7110_hw.c |  8 ++++----
 drivers/media/pci/ttpci/av7110_hw.h | 12 ++++++------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/media/pci/ttpci/av7110_hw.c b/drivers/media/pci/ttpci/av7110_hw.c
index 520414cbe087..cf6291b32ee6 100644
--- a/drivers/media/pci/ttpci/av7110_hw.c
+++ b/drivers/media/pci/ttpci/av7110_hw.c
@@ -56,11 +56,11 @@
    by Nathan Laredo <laredo@gnu.org> */
 
 int av7110_debiwrite(struct av7110 *av7110, u32 config,
-		     int addr, u32 val, int count)
+		     int addr, u32 val, unsigned int count)
 {
 	struct saa7146_dev *dev = av7110->dev;
 
-	if (count <= 0 || count > 32764) {
+	if (count > 32764) {
 		printk("%s: invalid count %d\n", __func__, count);
 		return -1;
 	}
@@ -78,12 +78,12 @@ int av7110_debiwrite(struct av7110 *av7110, u32 config,
 	return 0;
 }
 
-u32 av7110_debiread(struct av7110 *av7110, u32 config, int addr, int count)
+u32 av7110_debiread(struct av7110 *av7110, u32 config, int addr, unsigned int count)
 {
 	struct saa7146_dev *dev = av7110->dev;
 	u32 result = 0;
 
-	if (count > 32764 || count <= 0) {
+	if (count > 32764) {
 		printk("%s: invalid count %d\n", __func__, count);
 		return 0;
 	}
diff --git a/drivers/media/pci/ttpci/av7110_hw.h b/drivers/media/pci/ttpci/av7110_hw.h
index 1634aba5cb84..ccb148059406 100644
--- a/drivers/media/pci/ttpci/av7110_hw.h
+++ b/drivers/media/pci/ttpci/av7110_hw.h
@@ -377,14 +377,14 @@ extern int av7110_fw_request(struct av7110 *av7110, u16 *request_buf,
 
 /* DEBI (saa7146 data extension bus interface) access */
 extern int av7110_debiwrite(struct av7110 *av7110, u32 config,
-			    int addr, u32 val, int count);
+			    int addr, u32 val, unsigned int count);
 extern u32 av7110_debiread(struct av7110 *av7110, u32 config,
-			   int addr, int count);
+			   int addr, unsigned int count);
 
 
 /* DEBI during interrupt */
 /* single word writes */
-static inline void iwdebi(struct av7110 *av7110, u32 config, int addr, u32 val, int count)
+static inline void iwdebi(struct av7110 *av7110, u32 config, int addr, u32 val, unsigned int count)
 {
 	av7110_debiwrite(av7110, config, addr, val, count);
 }
@@ -397,7 +397,7 @@ static inline void mwdebi(struct av7110 *av7110, u32 config, int addr,
 	av7110_debiwrite(av7110, config, addr, 0, count);
 }
 
-static inline u32 irdebi(struct av7110 *av7110, u32 config, int addr, u32 val, int count)
+static inline u32 irdebi(struct av7110 *av7110, u32 config, int addr, u32 val, unsigned int count)
 {
 	u32 res;
 
@@ -408,7 +408,7 @@ static inline u32 irdebi(struct av7110 *av7110, u32 config, int addr, u32 val, i
 }
 
 /* DEBI outside interrupts, only for count <= 4! */
-static inline void wdebi(struct av7110 *av7110, u32 config, int addr, u32 val, int count)
+static inline void wdebi(struct av7110 *av7110, u32 config, int addr, u32 val, unsigned int count)
 {
 	unsigned long flags;
 
@@ -417,7 +417,7 @@ static inline void wdebi(struct av7110 *av7110, u32 config, int addr, u32 val, i
 	spin_unlock_irqrestore(&av7110->debilock, flags);
 }
 
-static inline u32 rdebi(struct av7110 *av7110, u32 config, int addr, u32 val, int count)
+static inline u32 rdebi(struct av7110 *av7110, u32 config, int addr, u32 val, unsigned int count)
 {
 	unsigned long flags;
 	u32 res;
-- 
2.9.0

