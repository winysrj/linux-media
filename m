Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:58569 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753955AbeDLPYb (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 12 Apr 2018 11:24:31 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 16/17] media: mantis: prevent staying forever in a loop at IRQ
Date: Thu, 12 Apr 2018 11:24:08 -0400
Message-Id: <95f98d2a03ff97d82672f5e7d6d2e358e4dd6d17.1523546545.git.mchehab@s-opensource.com>
In-Reply-To: <d20ab7176b2af82d6b679211edb5f151629d4033.1523546545.git.mchehab@s-opensource.com>
References: <d20ab7176b2af82d6b679211edb5f151629d4033.1523546545.git.mchehab@s-opensource.com>
In-Reply-To: <d20ab7176b2af82d6b679211edb5f151629d4033.1523546545.git.mchehab@s-opensource.com>
References: <d20ab7176b2af82d6b679211edb5f151629d4033.1523546545.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As warned by smatch:
	drivers/media/pci/mantis/mantis_uart.c:105 mantis_uart_work() warn: this loop depends on readl() succeeding

If something goes wrong at readl(), the logic will stay there
inside an IRQ code forever. This is not the nicest thing to
do :-)

So, add a timeout there, preventing staying inside the IRQ
for more than 10ms.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/pci/mantis/mantis_uart.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/media/pci/mantis/mantis_uart.c b/drivers/media/pci/mantis/mantis_uart.c
index 18f81c135996..b7765687e0c3 100644
--- a/drivers/media/pci/mantis/mantis_uart.c
+++ b/drivers/media/pci/mantis/mantis_uart.c
@@ -92,6 +92,7 @@ static void mantis_uart_work(struct work_struct *work)
 {
 	struct mantis_pci *mantis = container_of(work, struct mantis_pci, uart_work);
 	u32 stat;
+	unsigned long timeout;
 
 	stat = mmread(MANTIS_UART_STAT);
 
@@ -102,9 +103,15 @@ static void mantis_uart_work(struct work_struct *work)
 	 * MANTIS_UART_RXFIFO_DATA is only set if at least
 	 * config->bytes + 1 bytes are in the FIFO.
 	 */
+
+	/* FIXME: is 10ms good enough ? */
+	timeout = jiffies +  msecs_to_jiffies(10);
 	while (stat & MANTIS_UART_RXFIFO_DATA) {
 		mantis_uart_read(mantis);
 		stat = mmread(MANTIS_UART_STAT);
+
+		if (!time_is_after_jiffies(timeout))
+			break;
 	}
 
 	/* re-enable UART (RX) interrupt */
-- 
2.14.3
