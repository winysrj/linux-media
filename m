Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:33367 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431AbcCFNjs (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Mar 2016 08:39:48 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	=?UTF-8?q?Jan=20Kl=C3=B6tzke?= <jan@kloetzke.net>
Subject: [PATCH 1/6] [media] mantis: check for errors on readl inside loop
Date: Sun,  6 Mar 2016 10:39:17 -0300
Message-Id: <076989c7736719982a1bc9557d7db072910d8efe.1457271549.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As warned by smatch:
	drivers/media/pci/mantis/mantis_uart.c:105 mantis_uart_work() warn: this loop depends on readl() succeeding

If readl() fails, this could lead into an endless loop. Avoid that.
We might instead add some timeout logic, but it readl() is
failing, then something really wrong is happening.

While here, remove two defines that are only used once.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/pci/mantis/mantis_common.h | 7 ++-----
 drivers/media/pci/mantis/mantis_uart.c   | 4 ++--
 2 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/media/pci/mantis/mantis_common.h b/drivers/media/pci/mantis/mantis_common.h
index d48778a366a9..8348c5de3d18 100644
--- a/drivers/media/pci/mantis/mantis_common.h
+++ b/drivers/media/pci/mantis/mantis_common.h
@@ -54,11 +54,8 @@
 	}												\
 } while(0)
 
-#define mwrite(dat, addr)	writel((dat), addr)
-#define mread(addr)		readl(addr)
-
-#define mmwrite(dat, addr)	mwrite((dat), (mantis->mmio + (addr)))
-#define mmread(addr)		mread(mantis->mmio + (addr))
+#define mmwrite(dat, addr)	writel((dat), (mantis->mmio + (addr)))
+#define mmread(addr)		readl(mantis->mmio + (addr))
 
 #define MANTIS_TS_188		0
 #define MANTIS_TS_204		1
diff --git a/drivers/media/pci/mantis/mantis_uart.c b/drivers/media/pci/mantis/mantis_uart.c
index f1c96aec8c7b..95ccc34be9fd 100644
--- a/drivers/media/pci/mantis/mantis_uart.c
+++ b/drivers/media/pci/mantis/mantis_uart.c
@@ -91,7 +91,7 @@ static void mantis_uart_read(struct mantis_pci *mantis)
 static void mantis_uart_work(struct work_struct *work)
 {
 	struct mantis_pci *mantis = container_of(work, struct mantis_pci, uart_work);
-	u32 stat;
+	int stat;
 
 	stat = mmread(MANTIS_UART_STAT);
 
@@ -102,7 +102,7 @@ static void mantis_uart_work(struct work_struct *work)
 	 * MANTIS_UART_RXFIFO_DATA is only set if at least
 	 * config->bytes + 1 bytes are in the FIFO.
 	 */
-	while (stat & MANTIS_UART_RXFIFO_DATA) {
+	while ((stat >= 0) && (stat & MANTIS_UART_RXFIFO_DATA)) {
 		mantis_uart_read(mantis);
 		stat = mmread(MANTIS_UART_STAT);
 	}
-- 
2.5.0

