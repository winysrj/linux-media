Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:34589 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753625AbdG2L27 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 29 Jul 2017 07:28:59 -0400
Received: by mail-wr0-f196.google.com with SMTP id o33so20715975wrb.1
        for <linux-media@vger.kernel.org>; Sat, 29 Jul 2017 04:28:58 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: r.scobie@clear.net.nz, jasmin@anw.at, d_spingler@freenet.de,
        Manfred.Knick@t-online.de, rjkm@metzlerbros.de
Subject: [PATCH v2 05/14] [media] ddbridge: split off IRQ handling
Date: Sat, 29 Jul 2017 13:28:39 +0200
Message-Id: <20170729112848.707-6-d.scheller.oss@gmail.com>
In-Reply-To: <20170729112848.707-1-d.scheller.oss@gmail.com>
References: <20170729112848.707-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

This not only helps keep the ddbridge-core tidy, but also gets rid of
defined-but-unused-function warnings which might be triggered depending of
CONFIG_PCI_MSI, without having to clutter the code with #ifdef'ery.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
Tested-by: Richard Scobie <r.scobie@clear.net.nz>
Tested-by: Jasmin Jessich <jasmin@anw.at>
Tested-by: Dietmar Spingler <d_spingler@freenet.de>
Tested-by: Manfred Knick <Manfred.Knick@t-online.de>
---
 drivers/media/pci/ddbridge/Makefile        |   3 +-
 drivers/media/pci/ddbridge/ddbridge-core.c | 117 -----------------------
 drivers/media/pci/ddbridge/ddbridge-irq.c  | 148 +++++++++++++++++++++++++++++
 drivers/media/pci/ddbridge/ddbridge.h      |  12 +--
 4 files changed, 155 insertions(+), 125 deletions(-)
 create mode 100644 drivers/media/pci/ddbridge/ddbridge-irq.c

diff --git a/drivers/media/pci/ddbridge/Makefile b/drivers/media/pci/ddbridge/Makefile
index fe8ff0c681ad..0a7caa95a3b6 100644
--- a/drivers/media/pci/ddbridge/Makefile
+++ b/drivers/media/pci/ddbridge/Makefile
@@ -2,7 +2,8 @@
 # Makefile for the ddbridge device driver
 #
 
-ddbridge-objs := ddbridge-main.o ddbridge-core.o ddbridge-i2c.o
+ddbridge-objs := ddbridge-main.o ddbridge-core.o ddbridge-i2c.o \
+		ddbridge-irq.o
 
 obj-$(CONFIG_DVB_DDBRIDGE) += ddbridge.o
 
diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index 658f8e0f6163..d2f6713539d4 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -2691,123 +2691,6 @@ void ddb_ports_release(struct ddb *dev)
 /****************************************************************************/
 /****************************************************************************/
 
-#define IRQ_HANDLE(_nr) \
-	do { if ((s & (1UL << ((_nr) & 0x1f))) && dev->handler[0][_nr]) \
-		dev->handler[0][_nr](dev->handler_data[0][_nr]); } \
-	while (0)
-
-static void irq_handle_msg(struct ddb *dev, u32 s)
-{
-	dev->i2c_irq++;
-	IRQ_HANDLE(0);
-	IRQ_HANDLE(1);
-	IRQ_HANDLE(2);
-	IRQ_HANDLE(3);
-}
-
-static void irq_handle_io(struct ddb *dev, u32 s)
-{
-	dev->ts_irq++;
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
-}
-
-#ifdef DDB_USE_MSI_IRQHANDLERS
-irqreturn_t irq_handler0(int irq, void *dev_id)
-{
-	struct ddb *dev = (struct ddb *) dev_id;
-	u32 s = ddbreadl(dev, INTERRUPT_STATUS);
-
-	do {
-		if (s & 0x80000000)
-			return IRQ_NONE;
-		if (!(s & 0xfffff00))
-			return IRQ_NONE;
-		ddbwritel(dev, s & 0xfffff00, INTERRUPT_ACK);
-		irq_handle_io(dev, s);
-	} while ((s = ddbreadl(dev, INTERRUPT_STATUS)));
-
-	return IRQ_HANDLED;
-}
-
-irqreturn_t irq_handler1(int irq, void *dev_id)
-{
-	struct ddb *dev = (struct ddb *) dev_id;
-	u32 s = ddbreadl(dev, INTERRUPT_STATUS);
-
-	do {
-		if (s & 0x80000000)
-			return IRQ_NONE;
-		if (!(s & 0x0000f))
-			return IRQ_NONE;
-		ddbwritel(dev, s & 0x0000f, INTERRUPT_ACK);
-		irq_handle_msg(dev, s);
-	} while ((s = ddbreadl(dev, INTERRUPT_STATUS)));
-
-	return IRQ_HANDLED;
-}
-#endif
-
-irqreturn_t irq_handler(int irq, void *dev_id)
-{
-	struct ddb *dev = (struct ddb *) dev_id;
-	u32 s = ddbreadl(dev, INTERRUPT_STATUS);
-	int ret = IRQ_HANDLED;
-
-	if (!s)
-		return IRQ_NONE;
-	do {
-		if (s & 0x80000000)
-			return IRQ_NONE;
-		ddbwritel(dev, s, INTERRUPT_ACK);
-
-		if (s & 0x0000000f)
-			irq_handle_msg(dev, s);
-		if (s & 0x0fffff00)
-			irq_handle_io(dev, s);
-	} while ((s = ddbreadl(dev, INTERRUPT_STATUS)));
-
-	return ret;
-}
-
-/****************************************************************************/
-/****************************************************************************/
-/****************************************************************************/
-
 static int reg_wait(struct ddb *dev, u32 reg, u32 bit)
 {
 	u32 count = 0;
diff --git a/drivers/media/pci/ddbridge/ddbridge-irq.c b/drivers/media/pci/ddbridge/ddbridge-irq.c
new file mode 100644
index 000000000000..7215767120aa
--- /dev/null
+++ b/drivers/media/pci/ddbridge/ddbridge-irq.c
@@ -0,0 +1,148 @@
+/*
+ * ddbridge-irq.c: Digital Devices bridge irq handlers
+ *
+ * Copyright (C) 2010-2017 Digital Devices GmbH
+ *                         Ralph Metzler <rjkm@metzlerbros.de>
+ *                         Marcus Metzler <mocm@metzlerbros.de>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 only, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/delay.h>
+#include <linux/slab.h>
+#include <linux/poll.h>
+#include <linux/io.h>
+#include <linux/pci.h>
+#include <linux/pci_ids.h>
+#include <linux/timer.h>
+#include <linux/i2c.h>
+#include <linux/swab.h>
+#include <linux/vmalloc.h>
+
+#include "ddbridge.h"
+#include "ddbridge-regs.h"
+#include "ddbridge-io.h"
+
+/******************************************************************************/
+
+#define IRQ_HANDLE(_nr) \
+	do { if ((s & (1UL << ((_nr) & 0x1f))) && dev->handler[0][_nr]) \
+		dev->handler[0][_nr](dev->handler_data[0][_nr]); } \
+	while (0)
+
+static void irq_handle_msg(struct ddb *dev, u32 s)
+{
+	dev->i2c_irq++;
+	IRQ_HANDLE(0);
+	IRQ_HANDLE(1);
+	IRQ_HANDLE(2);
+	IRQ_HANDLE(3);
+}
+
+static void irq_handle_io(struct ddb *dev, u32 s)
+{
+	dev->ts_irq++;
+	if ((s & 0x000000f0)) {
+		IRQ_HANDLE(4);
+		IRQ_HANDLE(5);
+		IRQ_HANDLE(6);
+		IRQ_HANDLE(7);
+	}
+	if ((s & 0x0000ff00)) {
+		IRQ_HANDLE(8);
+		IRQ_HANDLE(9);
+		IRQ_HANDLE(10);
+		IRQ_HANDLE(11);
+		IRQ_HANDLE(12);
+		IRQ_HANDLE(13);
+		IRQ_HANDLE(14);
+		IRQ_HANDLE(15);
+	}
+	if ((s & 0x00ff0000)) {
+		IRQ_HANDLE(16);
+		IRQ_HANDLE(17);
+		IRQ_HANDLE(18);
+		IRQ_HANDLE(19);
+		IRQ_HANDLE(20);
+		IRQ_HANDLE(21);
+		IRQ_HANDLE(22);
+		IRQ_HANDLE(23);
+	}
+	if ((s & 0xff000000)) {
+		IRQ_HANDLE(24);
+		IRQ_HANDLE(25);
+		IRQ_HANDLE(26);
+		IRQ_HANDLE(27);
+		IRQ_HANDLE(28);
+		IRQ_HANDLE(29);
+		IRQ_HANDLE(30);
+		IRQ_HANDLE(31);
+	}
+}
+
+irqreturn_t irq_handler0(int irq, void *dev_id)
+{
+	struct ddb *dev = (struct ddb *) dev_id;
+	u32 s = ddbreadl(dev, INTERRUPT_STATUS);
+
+	do {
+		if (s & 0x80000000)
+			return IRQ_NONE;
+		if (!(s & 0xfffff00))
+			return IRQ_NONE;
+		ddbwritel(dev, s & 0xfffff00, INTERRUPT_ACK);
+		irq_handle_io(dev, s);
+	} while ((s = ddbreadl(dev, INTERRUPT_STATUS)));
+
+	return IRQ_HANDLED;
+}
+
+irqreturn_t irq_handler1(int irq, void *dev_id)
+{
+	struct ddb *dev = (struct ddb *) dev_id;
+	u32 s = ddbreadl(dev, INTERRUPT_STATUS);
+
+	do {
+		if (s & 0x80000000)
+			return IRQ_NONE;
+		if (!(s & 0x0000f))
+			return IRQ_NONE;
+		ddbwritel(dev, s & 0x0000f, INTERRUPT_ACK);
+		irq_handle_msg(dev, s);
+	} while ((s = ddbreadl(dev, INTERRUPT_STATUS)));
+
+	return IRQ_HANDLED;
+}
+
+irqreturn_t irq_handler(int irq, void *dev_id)
+{
+	struct ddb *dev = (struct ddb *) dev_id;
+	u32 s = ddbreadl(dev, INTERRUPT_STATUS);
+	int ret = IRQ_HANDLED;
+
+	if (!s)
+		return IRQ_NONE;
+	do {
+		if (s & 0x80000000)
+			return IRQ_NONE;
+		ddbwritel(dev, s, INTERRUPT_ACK);
+
+		if (s & 0x0000000f)
+			irq_handle_msg(dev, s);
+		if (s & 0x0fffff00)
+			irq_handle_io(dev, s);
+	} while ((s = ddbreadl(dev, INTERRUPT_STATUS)));
+
+	return ret;
+}
diff --git a/drivers/media/pci/ddbridge/ddbridge.h b/drivers/media/pci/ddbridge/ddbridge.h
index 3790fd8465a4..7dddc7d3b405 100644
--- a/drivers/media/pci/ddbridge/ddbridge.h
+++ b/drivers/media/pci/ddbridge/ddbridge.h
@@ -65,10 +65,6 @@
 
 #define DDBRIDGE_VERSION "0.9.29-integrated"
 
-#ifdef CONFIG_PCI_MSI
-#define DDB_USE_MSI_IRQHANDLERS
-#endif
-
 #define DDB_MAX_I2C    32
 #define DDB_MAX_PORT   32
 #define DDB_MAX_INPUT  64
@@ -378,9 +374,6 @@ void ddb_ports_detach(struct ddb *dev);
 void ddb_ports_release(struct ddb *dev);
 void ddb_buffers_free(struct ddb *dev);
 void ddb_device_destroy(struct ddb *dev);
-irqreturn_t irq_handler0(int irq, void *dev_id);
-irqreturn_t irq_handler1(int irq, void *dev_id);
-irqreturn_t irq_handler(int irq, void *dev_id);
 void ddb_ports_init(struct ddb *dev);
 int ddb_buffers_alloc(struct ddb *dev);
 int ddb_ports_attach(struct ddb *dev);
@@ -389,4 +382,9 @@ int ddb_class_create(void);
 void ddb_class_destroy(void);
 int ddb_init(struct ddb *dev);
 
+/* ddbridge-irq.c */
+irqreturn_t irq_handler0(int irq, void *dev_id);
+irqreturn_t irq_handler1(int irq, void *dev_id);
+irqreturn_t irq_handler(int irq, void *dev_id);
+
 #endif /* DDBRIDGE_H */
-- 
2.13.0
