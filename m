Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:36772 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753328AbeDIQsA (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 9 Apr 2018 12:48:00 -0400
Received: by mail-wr0-f195.google.com with SMTP id y55so10273215wry.3
        for <linux-media@vger.kernel.org>; Mon, 09 Apr 2018 09:48:00 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Subject: [PATCH v2 04/19] [media] ddbridge: move ddb_wq and the wq+class initialisation to -core
Date: Mon,  9 Apr 2018 18:47:37 +0200
Message-Id: <20180409164752.641-5-d.scheller.oss@gmail.com>
In-Reply-To: <20180409164752.641-1-d.scheller.oss@gmail.com>
References: <20180409164752.641-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Move the ddbridge module initialisation and cleanup code to ddbridge-core
and set up the ddb_wq workqueue there, and create and destroy the ddb
device class there aswell. Due to this, the prototypes for ddb_wq,
ddb_class_create() and ddb_class_destroy() aren't required in ddbridge.h
anymore, so remove them. Also, declare ddb_wq and the ddb_class_*()
functions static.

Picked up from the upstream dddvb-0.9.33 release.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/pci/ddbridge/ddbridge-core.c | 32 +++++++++++++++++++++++++++---
 drivers/media/pci/ddbridge/ddbridge-main.c | 21 +++++++-------------
 drivers/media/pci/ddbridge/ddbridge.h      |  7 ++-----
 3 files changed, 38 insertions(+), 22 deletions(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index 933046d03db5..fb9a2cb758e6 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -100,7 +100,7 @@ MODULE_PARM_DESC(stv0910_single, "use stv0910 cards as single demods");
 
 static DEFINE_MUTEX(redirect_lock);
 
-struct workqueue_struct *ddb_wq;
+static struct workqueue_struct *ddb_wq;
 
 static struct ddb *ddbs[DDB_MAX_ADAPTER];
 
@@ -3055,7 +3055,7 @@ static struct class ddb_class = {
 	.devnode        = ddb_devnode,
 };
 
-int ddb_class_create(void)
+static int ddb_class_create(void)
 {
 	ddb_major = register_chrdev(0, DDB_NAME, &ddb_fops);
 	if (ddb_major < 0)
@@ -3065,7 +3065,7 @@ int ddb_class_create(void)
 	return 0;
 }
 
-void ddb_class_destroy(void)
+static void ddb_class_destroy(void)
 {
 	class_unregister(&ddb_class);
 	unregister_chrdev(ddb_major, DDB_NAME);
@@ -3337,3 +3337,29 @@ void ddb_unmap(struct ddb *dev)
 		iounmap(dev->regs);
 	vfree(dev);
 }
+
+int ddb_exit_ddbridge(int stage, int error)
+{
+	switch (stage) {
+	default:
+	case 2:
+		destroy_workqueue(ddb_wq);
+		/* fall-through */
+	case 1:
+		ddb_class_destroy();
+		break;
+	}
+
+	return error;
+}
+
+int ddb_init_ddbridge(void)
+{
+	if (ddb_class_create() < 0)
+		return -1;
+	ddb_wq = alloc_workqueue("ddbridge", 0, 0);
+	if (!ddb_wq)
+		return ddb_exit_ddbridge(1, -1);
+
+	return 0;
+}
diff --git a/drivers/media/pci/ddbridge/ddbridge-main.c b/drivers/media/pci/ddbridge/ddbridge-main.c
index bde04dc39080..7088162af9d3 100644
--- a/drivers/media/pci/ddbridge/ddbridge-main.c
+++ b/drivers/media/pci/ddbridge/ddbridge-main.c
@@ -282,32 +282,25 @@ static struct pci_driver ddb_pci_driver = {
 
 static __init int module_init_ddbridge(void)
 {
-	int stat = -1;
+	int stat;
 
 	pr_info("Digital Devices PCIE bridge driver "
 		DDBRIDGE_VERSION
 		", Copyright (C) 2010-17 Digital Devices GmbH\n");
-	if (ddb_class_create() < 0)
-		return -1;
-	ddb_wq = create_workqueue("ddbridge");
-	if (!ddb_wq)
-		goto exit1;
+	stat = ddb_init_ddbridge();
+	if (stat < 0)
+		return stat;
 	stat = pci_register_driver(&ddb_pci_driver);
 	if (stat < 0)
-		goto exit2;
-	return stat;
-exit2:
-	destroy_workqueue(ddb_wq);
-exit1:
-	ddb_class_destroy();
+		ddb_exit_ddbridge(0, stat);
+
 	return stat;
 }
 
 static __exit void module_exit_ddbridge(void)
 {
 	pci_unregister_driver(&ddb_pci_driver);
-	destroy_workqueue(ddb_wq);
-	ddb_class_destroy();
+	ddb_exit_ddbridge(0, 0);
 }
 
 module_init(module_init_ddbridge);
diff --git a/drivers/media/pci/ddbridge/ddbridge.h b/drivers/media/pci/ddbridge/ddbridge.h
index e22e67d7e0fe..dbd5f551ce76 100644
--- a/drivers/media/pci/ddbridge/ddbridge.h
+++ b/drivers/media/pci/ddbridge/ddbridge.h
@@ -368,9 +368,6 @@ int ddbridge_flashread(struct ddb *dev, u32 link, u8 *buf, u32 addr, u32 len);
 
 /****************************************************************************/
 
-/* ddbridge-main.c (modparams) */
-extern struct workqueue_struct *ddb_wq;
-
 /* ddbridge-core.c */
 void ddb_ports_detach(struct ddb *dev);
 void ddb_ports_release(struct ddb *dev);
@@ -383,9 +380,9 @@ void ddb_ports_init(struct ddb *dev);
 int ddb_buffers_alloc(struct ddb *dev);
 int ddb_ports_attach(struct ddb *dev);
 int ddb_device_create(struct ddb *dev);
-int ddb_class_create(void);
-void ddb_class_destroy(void);
 int ddb_init(struct ddb *dev);
 void ddb_unmap(struct ddb *dev);
+int ddb_exit_ddbridge(int stage, int error);
+int ddb_init_ddbridge(void);
 
 #endif /* DDBRIDGE_H */
-- 
2.16.1
