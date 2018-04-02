Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:35381 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753138AbeDBSYr (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 2 Apr 2018 14:24:47 -0400
Received: by mail-wm0-f67.google.com with SMTP id r82so29280405wme.0
        for <linux-media@vger.kernel.org>; Mon, 02 Apr 2018 11:24:47 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Subject: [PATCH 18/20] [media] ddbridge: add hardware defs and PCI IDs for MCI cards
Date: Mon,  2 Apr 2018 20:24:25 +0200
Message-Id: <20180402182427.20918-19-d.scheller.oss@gmail.com>
In-Reply-To: <20180402182427.20918-1-d.scheller.oss@gmail.com>
References: <20180402182427.20918-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Add PCI IDs and ddb_info for the new MCI-based MaxSX8 cards. Also add
needed defines so the cards can be hooked up into ddbridge's probe and
attach handling.

Picked up from the upstream dddvb-0.9.33 release.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/pci/ddbridge/ddbridge-hw.c   | 11 +++++++++++
 drivers/media/pci/ddbridge/ddbridge-main.c |  1 +
 drivers/media/pci/ddbridge/ddbridge.h      | 11 +++++++----
 3 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge-hw.c b/drivers/media/pci/ddbridge/ddbridge-hw.c
index c6d14925e2fc..1d3ee6accdd5 100644
--- a/drivers/media/pci/ddbridge/ddbridge-hw.c
+++ b/drivers/media/pci/ddbridge/ddbridge-hw.c
@@ -311,6 +311,16 @@ static const struct ddb_info ddb_s2_48 = {
 	.tempmon_irq = 24,
 };
 
+static const struct ddb_info ddb_s2x_48 = {
+	.type     = DDB_OCTOPUS_MCI,
+	.name     = "Digital Devices MAX SX8",
+	.regmap   = &octopus_map,
+	.port_num = 4,
+	.i2c_mask = 0x00,
+	.tempmon_irq = 24,
+	.mci      = 4
+};
+
 /****************************************************************************/
 /****************************************************************************/
 /****************************************************************************/
@@ -346,6 +356,7 @@ static const struct ddb_device_id ddb_device_ids[] = {
 	DDB_DEVID(0x0008, 0x0036, ddb_isdbt_8),
 	DDB_DEVID(0x0008, 0x0037, ddb_c2t2i_v0_8),
 	DDB_DEVID(0x0008, 0x0038, ddb_c2t2i_8),
+	DDB_DEVID(0x0009, 0x0025, ddb_s2x_48),
 	DDB_DEVID(0x0006, 0x0039, ddb_ctv7),
 	DDB_DEVID(0x0011, 0x0040, ddb_ci),
 	DDB_DEVID(0x0011, 0x0041, ddb_cis),
diff --git a/drivers/media/pci/ddbridge/ddbridge-main.c b/drivers/media/pci/ddbridge/ddbridge-main.c
index 6356b48b3874..f4748cfd904b 100644
--- a/drivers/media/pci/ddbridge/ddbridge-main.c
+++ b/drivers/media/pci/ddbridge/ddbridge-main.c
@@ -264,6 +264,7 @@ static const struct pci_device_id ddb_id_table[] = {
 	DDB_DEVICE_ANY(0x0006),
 	DDB_DEVICE_ANY(0x0007),
 	DDB_DEVICE_ANY(0x0008),
+	DDB_DEVICE_ANY(0x0009),
 	DDB_DEVICE_ANY(0x0011),
 	DDB_DEVICE_ANY(0x0012),
 	DDB_DEVICE_ANY(0x0013),
diff --git a/drivers/media/pci/ddbridge/ddbridge.h b/drivers/media/pci/ddbridge/ddbridge.h
index cb69021a3443..72fe33cb72b9 100644
--- a/drivers/media/pci/ddbridge/ddbridge.h
+++ b/drivers/media/pci/ddbridge/ddbridge.h
@@ -112,11 +112,12 @@ struct ddb_ids {
 
 struct ddb_info {
 	int   type;
-#define DDB_NONE         0
-#define DDB_OCTOPUS      1
-#define DDB_OCTOPUS_CI   2
-#define DDB_OCTOPUS_MAX  5
+#define DDB_NONE            0
+#define DDB_OCTOPUS         1
+#define DDB_OCTOPUS_CI      2
+#define DDB_OCTOPUS_MAX     5
 #define DDB_OCTOPUS_MAX_CT  6
+#define DDB_OCTOPUS_MCI     9
 	char *name;
 	u32   i2c_mask;
 	u8    port_num;
@@ -133,6 +134,7 @@ struct ddb_info {
 #define TS_QUIRK_REVERSED 2
 #define TS_QUIRK_ALT_OSC  8
 	u32   tempmon_irq;
+	u8    mci;
 	const struct ddb_regmap *regmap;
 };
 
@@ -253,6 +255,7 @@ struct ddb_port {
 #define DDB_CI_EXTERNAL_XO2_B    13
 #define DDB_TUNER_DVBS_STV0910_PR 14
 #define DDB_TUNER_DVBC2T2I_SONY_P 15
+#define DDB_TUNER_MCI            16
 
 #define DDB_TUNER_XO2            32
 #define DDB_TUNER_DVBS_STV0910   (DDB_TUNER_XO2 + 0)
-- 
2.16.1
