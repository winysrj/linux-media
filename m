Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:36268 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752621AbdDITiu (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 9 Apr 2017 15:38:50 -0400
Received: by mail-wr0-f195.google.com with SMTP id o21so21490091wrb.3
        for <linux-media@vger.kernel.org>; Sun, 09 Apr 2017 12:38:49 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: aospan@netup.ru, serjk@netup.ru, mchehab@kernel.org,
        linux-media@vger.kernel.org
Cc: rjkm@metzlerbros.de
Subject: [PATCH 19/19] [media] ddbridge: hardware IDs for new C2T2 cards and other devices
Date: Sun,  9 Apr 2017 21:38:28 +0200
Message-Id: <20170409193828.18458-20-d.scheller.oss@gmail.com>
In-Reply-To: <20170409193828.18458-1-d.scheller.oss@gmail.com>
References: <20170409193828.18458-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Adds hardware IDs for all Sony CXD-based Cine-cards and MaxA8 devices, also
adds some other yet missing IDs like the Octopus V3, Octopus OEM and
Octopus Mini, as well as cards with unknown/deleted sub-ids.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/pci/ddbridge/Kconfig         |  3 +-
 drivers/media/pci/ddbridge/ddbridge-core.c | 84 +++++++++++++++++++++++++++++-
 drivers/media/pci/ddbridge/ddbridge.h      |  5 +-
 3 files changed, 88 insertions(+), 4 deletions(-)

diff --git a/drivers/media/pci/ddbridge/Kconfig b/drivers/media/pci/ddbridge/Kconfig
index ac6a48d7..ffed78c 100644
--- a/drivers/media/pci/ddbridge/Kconfig
+++ b/drivers/media/pci/ddbridge/Kconfig
@@ -18,6 +18,7 @@ config DVB_DDBRIDGE
 	  - DuoFlex CT Octopus
 	  - cineS2(v6)
 	  - CineCTv6 and DuoFlex CT (STV0367-based)
-	  - DuoFlex CT2/C2T2/C2T2I (Sony CXD28xx-based)
+	  - CineCTv7 and DuoFlex CT2/C2T2/C2T2I (Sony CXD28xx-based)
+	  - MaxA8 series
 
 	  Say Y if you own such a card and want to use it.
diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index 7df0489..e440689 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -2089,6 +2089,12 @@ static const struct ddb_info ddb_octopus_le = {
 	.port_num = 2,
 };
 
+static const struct ddb_info ddb_octopus_oem = {
+	.type     = DDB_OCTOPUS,
+	.name     = "Digital Devices Octopus OEM",
+	.port_num = 4,
+};
+
 static const struct ddb_info ddb_octopus_mini = {
 	.type     = DDB_OCTOPUS,
 	.name     = "Digital Devices Octopus Mini",
@@ -2112,6 +2118,14 @@ static const struct ddb_info ddb_dvbct = {
 	.port_num = 3,
 };
 
+static const struct ddb_info ddb_ctv7 = {
+	.type     = DDB_OCTOPUS,
+	.name     = "Digital Devices Cine CT V7 DVB adapter",
+	.port_num = 4,
+	.board_control   = 3,
+	.board_control_2 = 4,
+};
+
 static const struct ddb_info ddb_satixS2v3 = {
 	.type     = DDB_OCTOPUS,
 	.name     = "Mystique SaTiX-S2 V3 DVB adapter",
@@ -2124,6 +2138,55 @@ static const struct ddb_info ddb_octopusv3 = {
 	.port_num = 4,
 };
 
+/*** MaxA8 adapters ***********************************************************/
+
+static struct ddb_info ddb_ct2_8 = {
+	.type     = DDB_OCTOPUS_MAX_CT,
+	.name     = "Digital Devices MAX A8 CT2",
+	.port_num = 4,
+	.board_control   = 0x0ff,
+	.board_control_2 = 0xf00,
+	.ts_quirks = TS_QUIRK_SERIAL,
+};
+
+static struct ddb_info ddb_c2t2_8 = {
+	.type     = DDB_OCTOPUS_MAX_CT,
+	.name     = "Digital Devices MAX A8 C2T2",
+	.port_num = 4,
+	.board_control   = 0x0ff,
+	.board_control_2 = 0xf00,
+	.ts_quirks = TS_QUIRK_SERIAL,
+};
+
+static struct ddb_info ddb_isdbt_8 = {
+	.type     = DDB_OCTOPUS_MAX_CT,
+	.name     = "Digital Devices MAX A8 ISDBT",
+	.port_num = 4,
+	.board_control   = 0x0ff,
+	.board_control_2 = 0xf00,
+	.ts_quirks = TS_QUIRK_SERIAL,
+};
+
+static struct ddb_info ddb_c2t2i_v0_8 = {
+	.type     = DDB_OCTOPUS_MAX_CT,
+	.name     = "Digital Devices MAX A8 C2T2I V0",
+	.port_num = 4,
+	.board_control   = 0x0ff,
+	.board_control_2 = 0xf00,
+	.ts_quirks = TS_QUIRK_SERIAL | TS_QUIRK_ALT_OSC,
+};
+
+static struct ddb_info ddb_c2t2i_8 = {
+	.type     = DDB_OCTOPUS_MAX_CT,
+	.name     = "Digital Devices MAX A8 C2T2I",
+	.port_num = 4,
+	.board_control   = 0x0ff,
+	.board_control_2 = 0xf00,
+	.ts_quirks = TS_QUIRK_SERIAL,
+};
+
+/******************************************************************************/
+
 #define DDVID 0xdd01 /* Digital Devices Vendor ID */
 
 #define DDB_ID(_vend, _dev, _subvend, _subdev, _driverdata) {	\
@@ -2134,15 +2197,34 @@ static const struct ddb_info ddb_octopusv3 = {
 static const struct pci_device_id ddb_id_tbl[] = {
 	DDB_ID(DDVID, 0x0002, DDVID, 0x0001, ddb_octopus),
 	DDB_ID(DDVID, 0x0003, DDVID, 0x0001, ddb_octopus),
+	DDB_ID(DDVID, 0x0005, DDVID, 0x0004, ddb_octopusv3),
 	DDB_ID(DDVID, 0x0003, DDVID, 0x0002, ddb_octopus_le),
+	DDB_ID(DDVID, 0x0003, DDVID, 0x0003, ddb_octopus_oem),
 	DDB_ID(DDVID, 0x0003, DDVID, 0x0010, ddb_octopus_mini),
+	DDB_ID(DDVID, 0x0005, DDVID, 0x0011, ddb_octopus_mini),
 	DDB_ID(DDVID, 0x0003, DDVID, 0x0020, ddb_v6),
 	DDB_ID(DDVID, 0x0003, DDVID, 0x0021, ddb_v6_5),
 	DDB_ID(DDVID, 0x0003, DDVID, 0x0030, ddb_dvbct),
 	DDB_ID(DDVID, 0x0003, DDVID, 0xdb03, ddb_satixS2v3),
-	DDB_ID(DDVID, 0x0005, DDVID, 0x0004, ddb_octopusv3),
+	DDB_ID(DDVID, 0x0006, DDVID, 0x0031, ddb_ctv7),
+	DDB_ID(DDVID, 0x0006, DDVID, 0x0032, ddb_ctv7),
+	DDB_ID(DDVID, 0x0006, DDVID, 0x0033, ddb_ctv7),
+	DDB_ID(DDVID, 0x0008, DDVID, 0x0034, ddb_ct2_8),
+	DDB_ID(DDVID, 0x0008, DDVID, 0x0035, ddb_c2t2_8),
+	DDB_ID(DDVID, 0x0008, DDVID, 0x0036, ddb_isdbt_8),
+	DDB_ID(DDVID, 0x0008, DDVID, 0x0037, ddb_c2t2i_v0_8),
+	DDB_ID(DDVID, 0x0008, DDVID, 0x0038, ddb_c2t2i_8),
+	DDB_ID(DDVID, 0x0006, DDVID, 0x0039, ddb_ctv7),
 	/* in case sub-ids got deleted in flash */
 	DDB_ID(DDVID, 0x0003, PCI_ANY_ID, PCI_ANY_ID, ddb_none),
+	DDB_ID(DDVID, 0x0005, PCI_ANY_ID, PCI_ANY_ID, ddb_none),
+	DDB_ID(DDVID, 0x0006, PCI_ANY_ID, PCI_ANY_ID, ddb_none),
+	DDB_ID(DDVID, 0x0007, PCI_ANY_ID, PCI_ANY_ID, ddb_none),
+	DDB_ID(DDVID, 0x0008, PCI_ANY_ID, PCI_ANY_ID, ddb_none),
+	DDB_ID(DDVID, 0x0011, PCI_ANY_ID, PCI_ANY_ID, ddb_none),
+	DDB_ID(DDVID, 0x0013, PCI_ANY_ID, PCI_ANY_ID, ddb_none),
+	DDB_ID(DDVID, 0x0201, PCI_ANY_ID, PCI_ANY_ID, ddb_none),
+	DDB_ID(DDVID, 0x0320, PCI_ANY_ID, PCI_ANY_ID, ddb_none),
 	{0}
 };
 MODULE_DEVICE_TABLE(pci, ddb_id_tbl);
diff --git a/drivers/media/pci/ddbridge/ddbridge.h b/drivers/media/pci/ddbridge/ddbridge.h
index 58baddb..4a0e328 100644
--- a/drivers/media/pci/ddbridge/ddbridge.h
+++ b/drivers/media/pci/ddbridge/ddbridge.h
@@ -54,8 +54,9 @@
 
 struct ddb_info {
 	int   type;
-#define DDB_NONE         0
-#define DDB_OCTOPUS      1
+#define DDB_NONE		0
+#define DDB_OCTOPUS		1
+#define DDB_OCTOPUS_MAX_CT	6
 	char *name;
 	int   port_num;
 	u32   port_type[DDB_MAX_PORT];
-- 
2.10.2
