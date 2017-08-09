Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34319 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751904AbdHIUbh (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Aug 2017 16:31:37 -0400
Received: by mail-wm0-f65.google.com with SMTP id x64so756848wmg.1
        for <linux-media@vger.kernel.org>; Wed, 09 Aug 2017 13:31:36 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: r.scobie@clear.net.nz, jasmin@anw.at, d_spingler@freenet.de,
        Manfred.Knick@t-online.de, rjkm@metzlerbros.de
Subject: [PATCH v3 04/12] [media] ddbridge: split off hardware definitions and mappings
Date: Wed,  9 Aug 2017 22:31:20 +0200
Message-Id: <20170809203128.31476-5-d.scheller.oss@gmail.com>
In-Reply-To: <20170809203128.31476-1-d.scheller.oss@gmail.com>
References: <20170809203128.31476-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Further cleanup of ddbridge-core and ddbridge-main, and moves all such
hw definitions into one single place, making things easier to maintain.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
Tested-by: Richard Scobie <r.scobie@clear.net.nz>
Tested-by: Jasmin Jessich <jasmin@anw.at>
Tested-by: Dietmar Spingler <d_spingler@freenet.de>
Tested-by: Manfred Knick <Manfred.Knick@t-online.de>
---
 drivers/media/pci/ddbridge/Makefile        |   4 +-
 drivers/media/pci/ddbridge/ddbridge-core.c |  68 -------
 drivers/media/pci/ddbridge/ddbridge-hw.c   | 299 +++++++++++++++++++++++++++++
 drivers/media/pci/ddbridge/ddbridge-hw.h   |  52 +++++
 drivers/media/pci/ddbridge/ddbridge-main.c | 217 +--------------------
 drivers/media/pci/ddbridge/ddbridge.h      |   1 -
 6 files changed, 354 insertions(+), 287 deletions(-)
 create mode 100644 drivers/media/pci/ddbridge/ddbridge-hw.c
 create mode 100644 drivers/media/pci/ddbridge/ddbridge-hw.h

diff --git a/drivers/media/pci/ddbridge/Makefile b/drivers/media/pci/ddbridge/Makefile
index 0a7caa95a3b6..c4d8d6261243 100644
--- a/drivers/media/pci/ddbridge/Makefile
+++ b/drivers/media/pci/ddbridge/Makefile
@@ -2,8 +2,8 @@
 # Makefile for the ddbridge device driver
 #
 
-ddbridge-objs := ddbridge-main.o ddbridge-core.o ddbridge-i2c.o \
-		ddbridge-irq.o
+ddbridge-objs := ddbridge-main.o ddbridge-core.o ddbridge-hw.o \
+		ddbridge-i2c.o ddbridge-irq.o
 
 obj-$(CONFIG_DVB_DDBRIDGE) += ddbridge.o
 
diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index 0799f7c5400c..08440dcb5e6f 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -67,74 +67,6 @@ static struct ddb *ddbs[DDB_MAX_ADAPTER];
 /****************************************************************************/
 /****************************************************************************/
 
-static struct ddb_regset octopus_input = {
-	.base = 0x200,
-	.num  = 0x08,
-	.size = 0x10,
-};
-
-static struct ddb_regset octopus_output = {
-	.base = 0x280,
-	.num  = 0x08,
-	.size = 0x10,
-};
-
-static struct ddb_regset octopus_idma = {
-	.base = 0x300,
-	.num  = 0x08,
-	.size = 0x10,
-};
-
-static struct ddb_regset octopus_idma_buf = {
-	.base = 0x2000,
-	.num  = 0x08,
-	.size = 0x100,
-};
-
-static struct ddb_regset octopus_odma = {
-	.base = 0x380,
-	.num  = 0x04,
-	.size = 0x10,
-};
-
-static struct ddb_regset octopus_odma_buf = {
-	.base = 0x2800,
-	.num  = 0x04,
-	.size = 0x100,
-};
-
-static struct ddb_regset octopus_i2c = {
-	.base = 0x80,
-	.num  = 0x04,
-	.size = 0x20,
-};
-
-static struct ddb_regset octopus_i2c_buf = {
-	.base = 0x1000,
-	.num  = 0x04,
-	.size = 0x200,
-};
-
-/****************************************************************************/
-
-struct ddb_regmap octopus_map = {
-	.irq_base_i2c = 0,
-	.irq_base_idma = 8,
-	.irq_base_odma = 16,
-	.i2c = &octopus_i2c,
-	.i2c_buf = &octopus_i2c_buf,
-	.idma = &octopus_idma,
-	.idma_buf = &octopus_idma_buf,
-	.odma = &octopus_odma,
-	.odma_buf = &octopus_odma_buf,
-	.input = &octopus_input,
-	.output = &octopus_output,
-};
-
-/****************************************************************************/
-/****************************************************************************/
-/****************************************************************************/
-
 static void ddb_set_dma_table(struct ddb_io *io)
 {
 	struct ddb *dev = io->port->dev;
diff --git a/drivers/media/pci/ddbridge/ddbridge-hw.c b/drivers/media/pci/ddbridge/ddbridge-hw.c
new file mode 100644
index 000000000000..e35b41e8d860
--- /dev/null
+++ b/drivers/media/pci/ddbridge/ddbridge-hw.c
@@ -0,0 +1,299 @@
+/*
+ * ddbridge-hw.c: Digital Devices bridge hardware maps
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
+#include "ddbridge.h"
+
+/******************************************************************************/
+
+static struct ddb_regset octopus_input = {
+	.base = 0x200,
+	.num  = 0x08,
+	.size = 0x10,
+};
+
+static struct ddb_regset octopus_output = {
+	.base = 0x280,
+	.num  = 0x08,
+	.size = 0x10,
+};
+
+static struct ddb_regset octopus_idma = {
+	.base = 0x300,
+	.num  = 0x08,
+	.size = 0x10,
+};
+
+static struct ddb_regset octopus_idma_buf = {
+	.base = 0x2000,
+	.num  = 0x08,
+	.size = 0x100,
+};
+
+static struct ddb_regset octopus_odma = {
+	.base = 0x380,
+	.num  = 0x04,
+	.size = 0x10,
+};
+
+static struct ddb_regset octopus_odma_buf = {
+	.base = 0x2800,
+	.num  = 0x04,
+	.size = 0x100,
+};
+
+static struct ddb_regset octopus_i2c = {
+	.base = 0x80,
+	.num  = 0x04,
+	.size = 0x20,
+};
+
+static struct ddb_regset octopus_i2c_buf = {
+	.base = 0x1000,
+	.num  = 0x04,
+	.size = 0x200,
+};
+
+/****************************************************************************/
+
+static struct ddb_regmap octopus_map = {
+	.irq_base_i2c = 0,
+	.irq_base_idma = 8,
+	.irq_base_odma = 16,
+	.i2c = &octopus_i2c,
+	.i2c_buf = &octopus_i2c_buf,
+	.idma = &octopus_idma,
+	.idma_buf = &octopus_idma_buf,
+	.odma = &octopus_odma,
+	.odma_buf = &octopus_odma_buf,
+	.input = &octopus_input,
+	.output = &octopus_output,
+};
+
+/****************************************************************************/
+
+const struct ddb_info ddb_none = {
+	.type     = DDB_NONE,
+	.name     = "unknown Digital Devices PCIe card, install newer driver",
+	.regmap   = &octopus_map,
+};
+
+const struct ddb_info ddb_octopus = {
+	.type     = DDB_OCTOPUS,
+	.name     = "Digital Devices Octopus DVB adapter",
+	.regmap   = &octopus_map,
+	.port_num = 4,
+	.i2c_mask = 0x0f,
+};
+
+const struct ddb_info ddb_octopusv3 = {
+	.type     = DDB_OCTOPUS,
+	.name     = "Digital Devices Octopus V3 DVB adapter",
+	.regmap   = &octopus_map,
+	.port_num = 4,
+	.i2c_mask = 0x0f,
+};
+
+const struct ddb_info ddb_octopus_le = {
+	.type     = DDB_OCTOPUS,
+	.name     = "Digital Devices Octopus LE DVB adapter",
+	.regmap   = &octopus_map,
+	.port_num = 2,
+	.i2c_mask = 0x03,
+};
+
+const struct ddb_info ddb_octopus_oem = {
+	.type     = DDB_OCTOPUS,
+	.name     = "Digital Devices Octopus OEM",
+	.regmap   = &octopus_map,
+	.port_num = 4,
+	.i2c_mask = 0x0f,
+	.led_num  = 1,
+	.fan_num  = 1,
+	.temp_num = 1,
+	.temp_bus = 0,
+};
+
+const struct ddb_info ddb_octopus_mini = {
+	.type     = DDB_OCTOPUS,
+	.name     = "Digital Devices Octopus Mini",
+	.regmap   = &octopus_map,
+	.port_num = 4,
+	.i2c_mask = 0x0f,
+};
+
+const struct ddb_info ddb_v6 = {
+	.type     = DDB_OCTOPUS,
+	.name     = "Digital Devices Cine S2 V6 DVB adapter",
+	.regmap   = &octopus_map,
+	.port_num = 3,
+	.i2c_mask = 0x07,
+};
+
+const struct ddb_info ddb_v6_5 = {
+	.type     = DDB_OCTOPUS,
+	.name     = "Digital Devices Cine S2 V6.5 DVB adapter",
+	.regmap   = &octopus_map,
+	.port_num = 4,
+	.i2c_mask = 0x0f,
+};
+
+const struct ddb_info ddb_v7 = {
+	.type     = DDB_OCTOPUS,
+	.name     = "Digital Devices Cine S2 V7 DVB adapter",
+	.regmap   = &octopus_map,
+	.port_num = 4,
+	.i2c_mask = 0x0f,
+	.board_control   = 2,
+	.board_control_2 = 4,
+	.ts_quirks = TS_QUIRK_REVERSED,
+};
+
+const struct ddb_info ddb_v7a = {
+	.type     = DDB_OCTOPUS,
+	.name     = "Digital Devices Cine S2 V7 Advanced DVB adapter",
+	.regmap   = &octopus_map,
+	.port_num = 4,
+	.i2c_mask = 0x0f,
+	.board_control   = 2,
+	.board_control_2 = 4,
+	.ts_quirks = TS_QUIRK_REVERSED,
+};
+
+const struct ddb_info ddb_ctv7 = {
+	.type     = DDB_OCTOPUS,
+	.name     = "Digital Devices Cine CT V7 DVB adapter",
+	.regmap   = &octopus_map,
+	.port_num = 4,
+	.i2c_mask = 0x0f,
+	.board_control   = 3,
+	.board_control_2 = 4,
+};
+
+const struct ddb_info ddb_satixS2v3 = {
+	.type     = DDB_OCTOPUS,
+	.name     = "Mystique SaTiX-S2 V3 DVB adapter",
+	.regmap   = &octopus_map,
+	.port_num = 3,
+	.i2c_mask = 0x07,
+};
+
+const struct ddb_info ddb_ci = {
+	.type     = DDB_OCTOPUS_CI,
+	.name     = "Digital Devices Octopus CI",
+	.regmap   = &octopus_map,
+	.port_num = 4,
+	.i2c_mask = 0x03,
+};
+
+const struct ddb_info ddb_cis = {
+	.type     = DDB_OCTOPUS_CI,
+	.name     = "Digital Devices Octopus CI single",
+	.regmap   = &octopus_map,
+	.port_num = 3,
+	.i2c_mask = 0x03,
+};
+
+const struct ddb_info ddb_ci_s2_pro = {
+	.type     = DDB_OCTOPUS_CI,
+	.name     = "Digital Devices Octopus CI S2 Pro",
+	.regmap   = &octopus_map,
+	.port_num = 4,
+	.i2c_mask = 0x01,
+	.board_control   = 2,
+	.board_control_2 = 4,
+};
+
+const struct ddb_info ddb_ci_s2_pro_a = {
+	.type     = DDB_OCTOPUS_CI,
+	.name     = "Digital Devices Octopus CI S2 Pro Advanced",
+	.regmap   = &octopus_map,
+	.port_num = 4,
+	.i2c_mask = 0x01,
+	.board_control   = 2,
+	.board_control_2 = 4,
+};
+
+const struct ddb_info ddb_dvbct = {
+	.type     = DDB_OCTOPUS,
+	.name     = "Digital Devices DVBCT V6.1 DVB adapter",
+	.regmap   = &octopus_map,
+	.port_num = 3,
+	.i2c_mask = 0x07,
+};
+
+/****************************************************************************/
+
+const struct ddb_info ddb_ct2_8 = {
+	.type     = DDB_OCTOPUS_MAX_CT,
+	.name     = "Digital Devices MAX A8 CT2",
+	.regmap   = &octopus_map,
+	.port_num = 4,
+	.i2c_mask = 0x0f,
+	.board_control   = 0x0ff,
+	.board_control_2 = 0xf00,
+	.ts_quirks = TS_QUIRK_SERIAL,
+	.tempmon_irq = 24,
+};
+
+const struct ddb_info ddb_c2t2_8 = {
+	.type     = DDB_OCTOPUS_MAX_CT,
+	.name     = "Digital Devices MAX A8 C2T2",
+	.regmap   = &octopus_map,
+	.port_num = 4,
+	.i2c_mask = 0x0f,
+	.board_control   = 0x0ff,
+	.board_control_2 = 0xf00,
+	.ts_quirks = TS_QUIRK_SERIAL,
+	.tempmon_irq = 24,
+};
+
+const struct ddb_info ddb_isdbt_8 = {
+	.type     = DDB_OCTOPUS_MAX_CT,
+	.name     = "Digital Devices MAX A8 ISDBT",
+	.regmap   = &octopus_map,
+	.port_num = 4,
+	.i2c_mask = 0x0f,
+	.board_control   = 0x0ff,
+	.board_control_2 = 0xf00,
+	.ts_quirks = TS_QUIRK_SERIAL,
+	.tempmon_irq = 24,
+};
+
+const struct ddb_info ddb_c2t2i_v0_8 = {
+	.type     = DDB_OCTOPUS_MAX_CT,
+	.name     = "Digital Devices MAX A8 C2T2I V0",
+	.regmap   = &octopus_map,
+	.port_num = 4,
+	.i2c_mask = 0x0f,
+	.board_control   = 0x0ff,
+	.board_control_2 = 0xf00,
+	.ts_quirks = TS_QUIRK_SERIAL | TS_QUIRK_ALT_OSC,
+	.tempmon_irq = 24,
+};
+
+const struct ddb_info ddb_c2t2i_8 = {
+	.type     = DDB_OCTOPUS_MAX_CT,
+	.name     = "Digital Devices MAX A8 C2T2I",
+	.regmap   = &octopus_map,
+	.port_num = 4,
+	.i2c_mask = 0x0f,
+	.board_control   = 0x0ff,
+	.board_control_2 = 0xf00,
+	.ts_quirks = TS_QUIRK_SERIAL,
+	.tempmon_irq = 24,
+};
diff --git a/drivers/media/pci/ddbridge/ddbridge-hw.h b/drivers/media/pci/ddbridge/ddbridge-hw.h
new file mode 100644
index 000000000000..bd52c083c4a5
--- /dev/null
+++ b/drivers/media/pci/ddbridge/ddbridge-hw.h
@@ -0,0 +1,52 @@
+/*
+ * ddbridge-hw.h: Digital Devices bridge hardware maps
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
+#ifndef _DDBRIDGE_HW_H_
+#define _DDBRIDGE_HW_H_
+
+#include "ddbridge.h"
+
+/******************************************************************************/
+
+extern const struct ddb_info ddb_none;
+extern const struct ddb_info ddb_octopus;
+extern const struct ddb_info ddb_octopusv3;
+extern const struct ddb_info ddb_octopus_le;
+extern const struct ddb_info ddb_octopus_oem;
+extern const struct ddb_info ddb_octopus_mini;
+extern const struct ddb_info ddb_v6;
+extern const struct ddb_info ddb_v6_5;
+extern const struct ddb_info ddb_v7;
+extern const struct ddb_info ddb_v7a;
+extern const struct ddb_info ddb_ctv7;
+extern const struct ddb_info ddb_satixS2v3;
+extern const struct ddb_info ddb_ci;
+extern const struct ddb_info ddb_cis;
+extern const struct ddb_info ddb_ci_s2_pro;
+extern const struct ddb_info ddb_ci_s2_pro_a;
+extern const struct ddb_info ddb_dvbct;
+
+/****************************************************************************/
+
+extern const struct ddb_info ddb_ct2_8;
+extern const struct ddb_info ddb_c2t2_8;
+extern const struct ddb_info ddb_isdbt_8;
+extern const struct ddb_info ddb_c2t2i_v0_8;
+extern const struct ddb_info ddb_c2t2i_8;
+
+#endif /* _DDBRIDGE_HW_H */
diff --git a/drivers/media/pci/ddbridge/ddbridge-main.c b/drivers/media/pci/ddbridge/ddbridge-main.c
index 5332fd89f359..5094d2ef79d6 100644
--- a/drivers/media/pci/ddbridge/ddbridge-main.c
+++ b/drivers/media/pci/ddbridge/ddbridge-main.c
@@ -35,6 +35,7 @@
 #include "ddbridge.h"
 #include "ddbridge-i2c.h"
 #include "ddbridge-regs.h"
+#include "ddbridge-hw.h"
 #include "ddbridge-io.h"
 
 /****************************************************************************/
@@ -278,222 +279,6 @@ static int ddb_probe(struct pci_dev *pdev,
 /****************************************************************************/
 /****************************************************************************/
 
-static const struct ddb_info ddb_none = {
-	.type     = DDB_NONE,
-	.name     = "unknown Digital Devices PCIe card, install newer driver",
-	.regmap   = &octopus_map,
-};
-
-static const struct ddb_info ddb_octopus = {
-	.type     = DDB_OCTOPUS,
-	.name     = "Digital Devices Octopus DVB adapter",
-	.regmap   = &octopus_map,
-	.port_num = 4,
-	.i2c_mask = 0x0f,
-};
-
-static const struct ddb_info ddb_octopusv3 = {
-	.type     = DDB_OCTOPUS,
-	.name     = "Digital Devices Octopus V3 DVB adapter",
-	.regmap   = &octopus_map,
-	.port_num = 4,
-	.i2c_mask = 0x0f,
-};
-
-static const struct ddb_info ddb_octopus_le = {
-	.type     = DDB_OCTOPUS,
-	.name     = "Digital Devices Octopus LE DVB adapter",
-	.regmap   = &octopus_map,
-	.port_num = 2,
-	.i2c_mask = 0x03,
-};
-
-static const struct ddb_info ddb_octopus_oem = {
-	.type     = DDB_OCTOPUS,
-	.name     = "Digital Devices Octopus OEM",
-	.regmap   = &octopus_map,
-	.port_num = 4,
-	.i2c_mask = 0x0f,
-	.led_num  = 1,
-	.fan_num  = 1,
-	.temp_num = 1,
-	.temp_bus = 0,
-};
-
-static const struct ddb_info ddb_octopus_mini = {
-	.type     = DDB_OCTOPUS,
-	.name     = "Digital Devices Octopus Mini",
-	.regmap   = &octopus_map,
-	.port_num = 4,
-	.i2c_mask = 0x0f,
-};
-
-static const struct ddb_info ddb_v6 = {
-	.type     = DDB_OCTOPUS,
-	.name     = "Digital Devices Cine S2 V6 DVB adapter",
-	.regmap   = &octopus_map,
-	.port_num = 3,
-	.i2c_mask = 0x07,
-};
-
-static const struct ddb_info ddb_v6_5 = {
-	.type     = DDB_OCTOPUS,
-	.name     = "Digital Devices Cine S2 V6.5 DVB adapter",
-	.regmap   = &octopus_map,
-	.port_num = 4,
-	.i2c_mask = 0x0f,
-};
-
-static const struct ddb_info ddb_v7 = {
-	.type     = DDB_OCTOPUS,
-	.name     = "Digital Devices Cine S2 V7 DVB adapter",
-	.regmap   = &octopus_map,
-	.port_num = 4,
-	.i2c_mask = 0x0f,
-	.board_control   = 2,
-	.board_control_2 = 4,
-	.ts_quirks = TS_QUIRK_REVERSED,
-};
-
-static const struct ddb_info ddb_v7a = {
-	.type     = DDB_OCTOPUS,
-	.name     = "Digital Devices Cine S2 V7 Advanced DVB adapter",
-	.regmap   = &octopus_map,
-	.port_num = 4,
-	.i2c_mask = 0x0f,
-	.board_control   = 2,
-	.board_control_2 = 4,
-	.ts_quirks = TS_QUIRK_REVERSED,
-};
-
-static const struct ddb_info ddb_ctv7 = {
-	.type     = DDB_OCTOPUS,
-	.name     = "Digital Devices Cine CT V7 DVB adapter",
-	.regmap   = &octopus_map,
-	.port_num = 4,
-	.i2c_mask = 0x0f,
-	.board_control   = 3,
-	.board_control_2 = 4,
-};
-
-static const struct ddb_info ddb_satixS2v3 = {
-	.type     = DDB_OCTOPUS,
-	.name     = "Mystique SaTiX-S2 V3 DVB adapter",
-	.regmap   = &octopus_map,
-	.port_num = 3,
-	.i2c_mask = 0x07,
-};
-
-static const struct ddb_info ddb_ci = {
-	.type     = DDB_OCTOPUS_CI,
-	.name     = "Digital Devices Octopus CI",
-	.regmap   = &octopus_map,
-	.port_num = 4,
-	.i2c_mask = 0x03,
-};
-
-static const struct ddb_info ddb_cis = {
-	.type     = DDB_OCTOPUS_CI,
-	.name     = "Digital Devices Octopus CI single",
-	.regmap   = &octopus_map,
-	.port_num = 3,
-	.i2c_mask = 0x03,
-};
-
-static const struct ddb_info ddb_ci_s2_pro = {
-	.type     = DDB_OCTOPUS_CI,
-	.name     = "Digital Devices Octopus CI S2 Pro",
-	.regmap   = &octopus_map,
-	.port_num = 4,
-	.i2c_mask = 0x01,
-	.board_control   = 2,
-	.board_control_2 = 4,
-};
-
-static const struct ddb_info ddb_ci_s2_pro_a = {
-	.type     = DDB_OCTOPUS_CI,
-	.name     = "Digital Devices Octopus CI S2 Pro Advanced",
-	.regmap   = &octopus_map,
-	.port_num = 4,
-	.i2c_mask = 0x01,
-	.board_control   = 2,
-	.board_control_2 = 4,
-};
-
-static const struct ddb_info ddb_dvbct = {
-	.type     = DDB_OCTOPUS,
-	.name     = "Digital Devices DVBCT V6.1 DVB adapter",
-	.regmap   = &octopus_map,
-	.port_num = 3,
-	.i2c_mask = 0x07,
-};
-
-/****************************************************************************/
-
-static struct ddb_info ddb_ct2_8 = {
-	.type     = DDB_OCTOPUS_MAX_CT,
-	.name     = "Digital Devices MAX A8 CT2",
-	.regmap   = &octopus_map,
-	.port_num = 4,
-	.i2c_mask = 0x0f,
-	.board_control   = 0x0ff,
-	.board_control_2 = 0xf00,
-	.ts_quirks = TS_QUIRK_SERIAL,
-	.tempmon_irq = 24,
-};
-
-static struct ddb_info ddb_c2t2_8 = {
-	.type     = DDB_OCTOPUS_MAX_CT,
-	.name     = "Digital Devices MAX A8 C2T2",
-	.regmap   = &octopus_map,
-	.port_num = 4,
-	.i2c_mask = 0x0f,
-	.board_control   = 0x0ff,
-	.board_control_2 = 0xf00,
-	.ts_quirks = TS_QUIRK_SERIAL,
-	.tempmon_irq = 24,
-};
-
-static struct ddb_info ddb_isdbt_8 = {
-	.type     = DDB_OCTOPUS_MAX_CT,
-	.name     = "Digital Devices MAX A8 ISDBT",
-	.regmap   = &octopus_map,
-	.port_num = 4,
-	.i2c_mask = 0x0f,
-	.board_control   = 0x0ff,
-	.board_control_2 = 0xf00,
-	.ts_quirks = TS_QUIRK_SERIAL,
-	.tempmon_irq = 24,
-};
-
-static struct ddb_info ddb_c2t2i_v0_8 = {
-	.type     = DDB_OCTOPUS_MAX_CT,
-	.name     = "Digital Devices MAX A8 C2T2I V0",
-	.regmap   = &octopus_map,
-	.port_num = 4,
-	.i2c_mask = 0x0f,
-	.board_control   = 0x0ff,
-	.board_control_2 = 0xf00,
-	.ts_quirks = TS_QUIRK_SERIAL | TS_QUIRK_ALT_OSC,
-	.tempmon_irq = 24,
-};
-
-static struct ddb_info ddb_c2t2i_8 = {
-	.type     = DDB_OCTOPUS_MAX_CT,
-	.name     = "Digital Devices MAX A8 C2T2I",
-	.regmap   = &octopus_map,
-	.port_num = 4,
-	.i2c_mask = 0x0f,
-	.board_control   = 0x0ff,
-	.board_control_2 = 0xf00,
-	.ts_quirks = TS_QUIRK_SERIAL,
-	.tempmon_irq = 24,
-};
-
-/****************************************************************************/
-/****************************************************************************/
-/****************************************************************************/
-
 #define DDVID 0xdd01 /* Digital Devices Vendor ID */
 
 #define DDB_DEVICE(_device, _subdevice, _driver_data) { \
diff --git a/drivers/media/pci/ddbridge/ddbridge.h b/drivers/media/pci/ddbridge/ddbridge.h
index 7dddc7d3b405..726c0db16f12 100644
--- a/drivers/media/pci/ddbridge/ddbridge.h
+++ b/drivers/media/pci/ddbridge/ddbridge.h
@@ -369,7 +369,6 @@ extern int stv0910_single;
 extern struct workqueue_struct *ddb_wq;
 
 /* ddbridge-core.c */
-extern struct ddb_regmap octopus_map;
 void ddb_ports_detach(struct ddb *dev);
 void ddb_ports_release(struct ddb *dev);
 void ddb_buffers_free(struct ddb *dev);
-- 
2.13.0
