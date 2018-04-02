Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:39353 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753261AbeDBSYk (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 2 Apr 2018 14:24:40 -0400
Received: by mail-wm0-f68.google.com with SMTP id f125so29012854wme.4
        for <linux-media@vger.kernel.org>; Mon, 02 Apr 2018 11:24:39 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Subject: [PATCH 09/20] [media] ddbridge: add macros to handle IRQs in nibble and byte blocks
Date: Mon,  2 Apr 2018 20:24:16 +0200
Message-Id: <20180402182427.20918-10-d.scheller.oss@gmail.com>
In-Reply-To: <20180402182427.20918-1-d.scheller.oss@gmail.com>
References: <20180402182427.20918-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Currently, each IRQ requires one IRQ_HANDLE() line to call each IRQ
handler that was set up. Add a IRQ_HANDLE_NIBBLE() and IRQ_HANDLE_BYTE()
macro to call all handlers in blocks of four (_NIBBLE) or eight (_BYTE)
handlers at a time, to make this construct more compact.

Picked up from the upstream dddvb-0.9.33 release.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/pci/ddbridge/ddbridge-core.c | 67 ++++++++++++------------------
 1 file changed, 27 insertions(+), 40 deletions(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index be6935bd0cb5..5fbb0996a12c 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -2403,54 +2403,41 @@ void ddb_ports_release(struct ddb *dev)
 		dev->link[0].irq[_nr].handler(dev->link[0].irq[_nr].data); } \
 	while (0)
 
+#define IRQ_HANDLE_NIBBLE(_shift) {		     \
+	if (s & (0x0000000f << ((_shift) & 0x1f))) { \
+		IRQ_HANDLE(0 + (_shift));	     \
+		IRQ_HANDLE(1 + (_shift));	     \
+		IRQ_HANDLE(2 + (_shift));	     \
+		IRQ_HANDLE(3 + (_shift));	     \
+	}					     \
+}
+
+#define IRQ_HANDLE_BYTE(_shift) {		     \
+	if (s & (0x000000ff << ((_shift) & 0x1f))) { \
+		IRQ_HANDLE(0 + (_shift));	     \
+		IRQ_HANDLE(1 + (_shift));	     \
+		IRQ_HANDLE(2 + (_shift));	     \
+		IRQ_HANDLE(3 + (_shift));	     \
+		IRQ_HANDLE(4 + (_shift));	     \
+		IRQ_HANDLE(5 + (_shift));	     \
+		IRQ_HANDLE(6 + (_shift));	     \
+		IRQ_HANDLE(7 + (_shift));	     \
+	}					     \
+}
+
 static void irq_handle_msg(struct ddb *dev, u32 s)
 {
 	dev->i2c_irq++;
-	IRQ_HANDLE(0);
-	IRQ_HANDLE(1);
-	IRQ_HANDLE(2);
-	IRQ_HANDLE(3);
+	IRQ_HANDLE_NIBBLE(0);
 }
 
 static void irq_handle_io(struct ddb *dev, u32 s)
 {
 	dev->ts_irq++;
-	if ((s & 0x000000f0)) {
-		IRQ_HANDLE(4);
-		IRQ_HANDLE(5);
-		IRQ_HANDLE(6);
-		IRQ_HANDLE(7);
-	}
-	if ((s & 0x0000ff00)) {
-		IRQ_HANDLE(8);
-		IRQ_HANDLE(9);
-		IRQ_HANDLE(10);
-		IRQ_HANDLE(11);
-		IRQ_HANDLE(12);
-		IRQ_HANDLE(13);
-		IRQ_HANDLE(14);
-		IRQ_HANDLE(15);
-	}
-	if ((s & 0x00ff0000)) {
-		IRQ_HANDLE(16);
-		IRQ_HANDLE(17);
-		IRQ_HANDLE(18);
-		IRQ_HANDLE(19);
-		IRQ_HANDLE(20);
-		IRQ_HANDLE(21);
-		IRQ_HANDLE(22);
-		IRQ_HANDLE(23);
-	}
-	if ((s & 0xff000000)) {
-		IRQ_HANDLE(24);
-		IRQ_HANDLE(25);
-		IRQ_HANDLE(26);
-		IRQ_HANDLE(27);
-		IRQ_HANDLE(28);
-		IRQ_HANDLE(29);
-		IRQ_HANDLE(30);
-		IRQ_HANDLE(31);
-	}
+	IRQ_HANDLE_NIBBLE(4);
+	IRQ_HANDLE_BYTE(8);
+	IRQ_HANDLE_BYTE(16);
+	IRQ_HANDLE_BYTE(24);
 }
 
 irqreturn_t ddb_irq_handler0(int irq, void *dev_id)
-- 
2.16.1
