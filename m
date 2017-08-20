Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:36372 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752533AbdHTKlU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 20 Aug 2017 06:41:20 -0400
Received: by mail-wr0-f194.google.com with SMTP id f8so7809399wrf.3
        for <linux-media@vger.kernel.org>; Sun, 20 Aug 2017 03:41:19 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: jasmin@anw.at, rjkm@metzlerbros.de
Subject: [PATCH 3/6] [media] ddbridge: move device ID table to ddbridge-hw
Date: Sun, 20 Aug 2017 12:41:11 +0200
Message-Id: <20170820104114.6515-4-d.scheller.oss@gmail.com>
In-Reply-To: <20170820104114.6515-1-d.scheller.oss@gmail.com>
References: <20170820104114.6515-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

This further cleans up ddbridge-main from hardware-related data and moves
the exact card type determination into ddbridge-hw.c:get_ddb_info(), right
to the hardware maps/structs. Also, const'ify more structs and pointers.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/pci/ddbridge/ddbridge-core.c |  8 ++--
 drivers/media/pci/ddbridge/ddbridge-hw.c   | 65 ++++++++++++++++++++++++++++++
 drivers/media/pci/ddbridge/ddbridge-hw.h   | 19 +++++++++
 drivers/media/pci/ddbridge/ddbridge-main.c | 47 ++++-----------------
 drivers/media/pci/ddbridge/ddbridge.h      |  2 +-
 5 files changed, 96 insertions(+), 45 deletions(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index 070e382db9ad..5f6367fee586 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -2441,7 +2441,7 @@ static void output_handler(unsigned long data)
 
 static struct ddb_regmap *io_regmap(struct ddb_io *io, int link)
 {
-	struct ddb_info *info;
+	const struct ddb_info *info;
 
 	if (link)
 		info = io->port->dev->link[io->port->lnr].info;
@@ -2575,7 +2575,7 @@ void ddb_ports_init(struct ddb *dev)
 {
 	u32 i, l, p;
 	struct ddb_port *port;
-	struct ddb_info *info;
+	const struct ddb_info *info;
 	struct ddb_regmap *rm;
 
 	for (p = l = 0; l < DDB_MAX_LINK; l++) {
@@ -3538,7 +3538,7 @@ static int tempmon_init(struct ddb_link *link, int first_time)
 
 static int ddb_init_tempmon(struct ddb_link *link)
 {
-	struct ddb_info *info = link->info;
+	const struct ddb_info *info = link->info;
 
 	if (!info->tempmon_irq)
 		return 0;
@@ -3556,7 +3556,7 @@ static int ddb_init_tempmon(struct ddb_link *link)
 
 static int ddb_init_boards(struct ddb *dev)
 {
-	struct ddb_info *info;
+	const struct ddb_info *info;
 	struct ddb_link *link;
 	u32 l;
 
diff --git a/drivers/media/pci/ddbridge/ddbridge-hw.c b/drivers/media/pci/ddbridge/ddbridge-hw.c
index 317dc865e99c..3b208d5bf4ad 100644
--- a/drivers/media/pci/ddbridge/ddbridge-hw.c
+++ b/drivers/media/pci/ddbridge/ddbridge-hw.c
@@ -17,6 +17,7 @@
  */
 
 #include "ddbridge.h"
+#include "ddbridge-hw.h"
 
 /******************************************************************************/
 
@@ -309,3 +310,67 @@ const struct ddb_info ddb_s2_48 = {
 	.board_control = 1,
 	.tempmon_irq = 24,
 };
+
+/****************************************************************************/
+/****************************************************************************/
+/****************************************************************************/
+
+#define DDB_DEVID(_device, _subdevice, _info) { \
+	.vendor = DDVID, \
+	.device = _device, \
+	.subvendor = DDVID, \
+	.subdevice = _subdevice, \
+	.info = &_info }
+
+static const struct ddb_device_id ddb_device_ids[] = {
+	/* PCIe devices */
+	DDB_DEVID(0x0002, 0x0001, ddb_octopus),
+	DDB_DEVID(0x0003, 0x0001, ddb_octopus),
+	DDB_DEVID(0x0005, 0x0004, ddb_octopusv3),
+	DDB_DEVID(0x0003, 0x0002, ddb_octopus_le),
+	DDB_DEVID(0x0003, 0x0003, ddb_octopus_oem),
+	DDB_DEVID(0x0003, 0x0010, ddb_octopus_mini),
+	DDB_DEVID(0x0005, 0x0011, ddb_octopus_mini),
+	DDB_DEVID(0x0003, 0x0020, ddb_v6),
+	DDB_DEVID(0x0003, 0x0021, ddb_v6_5),
+	DDB_DEVID(0x0006, 0x0022, ddb_v7),
+	DDB_DEVID(0x0006, 0x0024, ddb_v7a),
+	DDB_DEVID(0x0003, 0x0030, ddb_dvbct),
+	DDB_DEVID(0x0003, 0xdb03, ddb_satixS2v3),
+	DDB_DEVID(0x0006, 0x0031, ddb_ctv7),
+	DDB_DEVID(0x0006, 0x0032, ddb_ctv7),
+	DDB_DEVID(0x0006, 0x0033, ddb_ctv7),
+	DDB_DEVID(0x0007, 0x0023, ddb_s2_48),
+	DDB_DEVID(0x0008, 0x0034, ddb_ct2_8),
+	DDB_DEVID(0x0008, 0x0035, ddb_c2t2_8),
+	DDB_DEVID(0x0008, 0x0036, ddb_isdbt_8),
+	DDB_DEVID(0x0008, 0x0037, ddb_c2t2i_v0_8),
+	DDB_DEVID(0x0008, 0x0038, ddb_c2t2i_8),
+	DDB_DEVID(0x0006, 0x0039, ddb_ctv7),
+	DDB_DEVID(0x0011, 0x0040, ddb_ci),
+	DDB_DEVID(0x0011, 0x0041, ddb_cis),
+	DDB_DEVID(0x0012, 0x0042, ddb_ci),
+	DDB_DEVID(0x0013, 0x0043, ddb_ci_s2_pro),
+	DDB_DEVID(0x0013, 0x0044, ddb_ci_s2_pro_a),
+};
+
+/****************************************************************************/
+
+const struct ddb_info *get_ddb_info(u16 vendor, u16 device,
+				    u16 subvendor, u16 subdevice)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(ddb_device_ids); i++) {
+		const struct ddb_device_id *id = &ddb_device_ids[i];
+
+		if (vendor == id->vendor &&
+		    device == id->device &&
+		    subvendor == id->subvendor &&
+		    ((subdevice == id->subdevice) ||
+		     (id->subdevice == 0xffff)))
+			return id->info;
+	}
+
+	return &ddb_none;
+}
diff --git a/drivers/media/pci/ddbridge/ddbridge-hw.h b/drivers/media/pci/ddbridge/ddbridge-hw.h
index d26cd9c977d8..1a985d0a1a97 100644
--- a/drivers/media/pci/ddbridge/ddbridge-hw.h
+++ b/drivers/media/pci/ddbridge/ddbridge-hw.h
@@ -23,6 +23,20 @@
 
 /******************************************************************************/
 
+#define DDVID 0xdd01 /* Digital Devices Vendor ID */
+
+/******************************************************************************/
+
+struct ddb_device_id {
+	u16 vendor;
+	u16 device;
+	u16 subvendor;
+	u16 subdevice;
+	const struct ddb_info *info;
+};
+
+/******************************************************************************/
+
 extern const struct ddb_info ddb_none;
 extern const struct ddb_info ddb_octopus;
 extern const struct ddb_info ddb_octopusv3;
@@ -53,4 +67,9 @@ extern const struct ddb_info ddb_c2t2i_8;
 
 extern const struct ddb_info ddb_s2_48;
 
+/****************************************************************************/
+
+const struct ddb_info *get_ddb_info(u16 vendor, u16 device,
+				    u16 subvendor, u16 subdevice);
+
 #endif /* _DDBRIDGE_HW_H */
diff --git a/drivers/media/pci/ddbridge/ddbridge-main.c b/drivers/media/pci/ddbridge/ddbridge-main.c
index 25e9bd7d4fc1..ccac7fe31336 100644
--- a/drivers/media/pci/ddbridge/ddbridge-main.c
+++ b/drivers/media/pci/ddbridge/ddbridge-main.c
@@ -215,10 +215,12 @@ static int ddb_probe(struct pci_dev *pdev,
 	dev->link[0].ids.vendor = id->vendor;
 	dev->link[0].ids.device = id->device;
 	dev->link[0].ids.subvendor = id->subvendor;
-	dev->link[0].ids.subdevice = id->subdevice;
+	dev->link[0].ids.subdevice = pdev->subsystem_device;
 
 	dev->link[0].dev = dev;
-	dev->link[0].info = (struct ddb_info *) id->driver_data;
+	dev->link[0].info = get_ddb_info(id->vendor, id->device,
+					 id->subvendor, pdev->subsystem_device);
+
 	dev_info(&pdev->dev, "detected %s\n", dev->link[0].info->name);
 
 	dev->regs_len = pci_resource_len(dev->pdev, 0);
@@ -270,46 +272,11 @@ static int ddb_probe(struct pci_dev *pdev,
 /****************************************************************************/
 /****************************************************************************/
 
-#define DDVID 0xdd01 /* Digital Devices Vendor ID */
-
-#define DDB_DEVICE(_device, _subdevice, _driver_data) { \
-		PCI_DEVICE_SUB(DDVID, _device, DDVID, _subdevice), \
-			.driver_data = (kernel_ulong_t) &_driver_data }
-
-#define DDB_DEVICE_ANY(_device) { \
-		PCI_DEVICE_SUB(DDVID, _device, DDVID, PCI_ANY_ID), \
-			.driver_data = (kernel_ulong_t) &ddb_none }
+#define DDB_DEVICE_ANY(_device) \
+		{ PCI_DEVICE_SUB(DDVID, _device, DDVID, PCI_ANY_ID) }
 
 static const struct pci_device_id ddb_id_table[] = {
-	DDB_DEVICE(0x0002, 0x0001, ddb_octopus),
-	DDB_DEVICE(0x0003, 0x0001, ddb_octopus),
-	DDB_DEVICE(0x0005, 0x0004, ddb_octopusv3),
-	DDB_DEVICE(0x0003, 0x0002, ddb_octopus_le),
-	DDB_DEVICE(0x0003, 0x0003, ddb_octopus_oem),
-	DDB_DEVICE(0x0003, 0x0010, ddb_octopus_mini),
-	DDB_DEVICE(0x0005, 0x0011, ddb_octopus_mini),
-	DDB_DEVICE(0x0003, 0x0020, ddb_v6),
-	DDB_DEVICE(0x0003, 0x0021, ddb_v6_5),
-	DDB_DEVICE(0x0006, 0x0022, ddb_v7),
-	DDB_DEVICE(0x0006, 0x0024, ddb_v7a),
-	DDB_DEVICE(0x0003, 0x0030, ddb_dvbct),
-	DDB_DEVICE(0x0003, 0xdb03, ddb_satixS2v3),
-	DDB_DEVICE(0x0006, 0x0031, ddb_ctv7),
-	DDB_DEVICE(0x0006, 0x0032, ddb_ctv7),
-	DDB_DEVICE(0x0006, 0x0033, ddb_ctv7),
-	DDB_DEVICE(0x0007, 0x0023, ddb_s2_48),
-	DDB_DEVICE(0x0008, 0x0034, ddb_ct2_8),
-	DDB_DEVICE(0x0008, 0x0035, ddb_c2t2_8),
-	DDB_DEVICE(0x0008, 0x0036, ddb_isdbt_8),
-	DDB_DEVICE(0x0008, 0x0037, ddb_c2t2i_v0_8),
-	DDB_DEVICE(0x0008, 0x0038, ddb_c2t2i_8),
-	DDB_DEVICE(0x0006, 0x0039, ddb_ctv7),
-	DDB_DEVICE(0x0011, 0x0040, ddb_ci),
-	DDB_DEVICE(0x0011, 0x0041, ddb_cis),
-	DDB_DEVICE(0x0012, 0x0042, ddb_ci),
-	DDB_DEVICE(0x0013, 0x0043, ddb_ci_s2_pro),
-	DDB_DEVICE(0x0013, 0x0044, ddb_ci_s2_pro_a),
-	/* in case sub-ids got deleted in flash */
+	DDB_DEVICE_ANY(0x0002),
 	DDB_DEVICE_ANY(0x0003),
 	DDB_DEVICE_ANY(0x0005),
 	DDB_DEVICE_ANY(0x0006),
diff --git a/drivers/media/pci/ddbridge/ddbridge.h b/drivers/media/pci/ddbridge/ddbridge.h
index 9ca94a4f82ee..d890400dc1c3 100644
--- a/drivers/media/pci/ddbridge/ddbridge.h
+++ b/drivers/media/pci/ddbridge/ddbridge.h
@@ -307,7 +307,7 @@ struct ddb_lnb {
 
 struct ddb_link {
 	struct ddb            *dev;
-	struct ddb_info       *info;
+	const struct ddb_info *info;
 	u32                    nr;
 	u32                    regs;
 	spinlock_t             lock;
-- 
2.13.0
