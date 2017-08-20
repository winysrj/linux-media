Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:38255 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751634AbdHTKlT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 20 Aug 2017 06:41:19 -0400
Received: by mail-wr0-f194.google.com with SMTP id k10so256394wre.5
        for <linux-media@vger.kernel.org>; Sun, 20 Aug 2017 03:41:18 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: jasmin@anw.at, rjkm@metzlerbros.de
Subject: [PATCH 2/6] [media] ddbridge: move ddb_unmap(), cleanup modparams
Date: Sun, 20 Aug 2017 12:41:10 +0200
Message-Id: <20170820104114.6515-3-d.scheller.oss@gmail.com>
In-Reply-To: <20170820104114.6515-1-d.scheller.oss@gmail.com>
References: <20170820104114.6515-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

adapter_alloc is only used from within ddbridge-core, so move it there,
this removes the need for prototyping/referencing the variable. While at
it, msi isn't needed outside of ddbridge-main, so don't extref that one
aswell.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/pci/ddbridge/ddbridge-core.c | 18 ++++++++++++++++++
 drivers/media/pci/ddbridge/ddbridge-main.c | 20 ++------------------
 drivers/media/pci/ddbridge/ddbridge.h      |  3 +--
 3 files changed, 21 insertions(+), 20 deletions(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index 98a12c644e44..070e382db9ad 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -58,10 +58,21 @@
 
 #define DDB_MAX_ADAPTER 64
 
+/****************************************************************************/
+
 DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
+static int adapter_alloc;
+module_param(adapter_alloc, int, 0444);
+MODULE_PARM_DESC(adapter_alloc,
+		 "0-one adapter per io, 1-one per tab with io, 2-one per tab, 3-one for all");
+
+/****************************************************************************/
+
 DEFINE_MUTEX(redirect_lock);
 
+struct workqueue_struct *ddb_wq;
+
 static struct ddb *ddbs[DDB_MAX_ADAPTER];
 
 /****************************************************************************/
@@ -3612,3 +3623,10 @@ int ddb_init(struct ddb *dev)
 	dev_err(dev->dev, "fail1\n");
 	return -1;
 }
+
+void ddb_unmap(struct ddb *dev)
+{
+	if (dev->regs)
+		iounmap(dev->regs);
+	vfree(dev);
+}
diff --git a/drivers/media/pci/ddbridge/ddbridge-main.c b/drivers/media/pci/ddbridge/ddbridge-main.c
index 3cb6bb265172..25e9bd7d4fc1 100644
--- a/drivers/media/pci/ddbridge/ddbridge-main.c
+++ b/drivers/media/pci/ddbridge/ddbridge-main.c
@@ -41,16 +41,11 @@
 /****************************************************************************/
 /* module parameters */
 
-int adapter_alloc;
-module_param(adapter_alloc, int, 0444);
-MODULE_PARM_DESC(adapter_alloc,
-		 "0-one adapter per io, 1-one per tab with io, 2-one per tab, 3-one for all");
-
 #ifdef CONFIG_PCI_MSI
 #ifdef CONFIG_DVB_DDBRIDGE_MSIENABLE
-int msi = 1;
+static int msi = 1;
 #else
-int msi;
+static int msi;
 #endif
 module_param(msi, int, 0444);
 #ifdef CONFIG_DVB_DDBRIDGE_MSIENABLE
@@ -89,20 +84,9 @@ module_param(stv0910_single, int, 0444);
 MODULE_PARM_DESC(stv0910_single, "use stv0910 cards as single demods");
 
 /****************************************************************************/
-
-struct workqueue_struct *ddb_wq;
-
-/****************************************************************************/
 /****************************************************************************/
 /****************************************************************************/
 
-static void ddb_unmap(struct ddb *dev)
-{
-	if (dev->regs)
-		iounmap(dev->regs);
-	vfree(dev);
-}
-
 static void ddb_irq_disable(struct ddb *dev)
 {
 	ddbwritel(dev, 0, INTERRUPT_ENABLE);
diff --git a/drivers/media/pci/ddbridge/ddbridge.h b/drivers/media/pci/ddbridge/ddbridge.h
index 91b58eff951c..9ca94a4f82ee 100644
--- a/drivers/media/pci/ddbridge/ddbridge.h
+++ b/drivers/media/pci/ddbridge/ddbridge.h
@@ -369,8 +369,6 @@ int ddbridge_flashread(struct ddb *dev, u32 link, u8 *buf, u32 addr, u32 len);
 /****************************************************************************/
 
 /* ddbridge-main.c (modparams) */
-extern int adapter_alloc;
-extern int msi;
 extern int ci_bitrate;
 extern int ts_loop;
 extern int xo2_speed;
@@ -394,5 +392,6 @@ int ddb_device_create(struct ddb *dev);
 int ddb_class_create(void);
 void ddb_class_destroy(void);
 int ddb_init(struct ddb *dev);
+void ddb_unmap(struct ddb *dev);
 
 #endif /* DDBRIDGE_H */
-- 
2.13.0
