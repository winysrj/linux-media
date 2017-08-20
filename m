Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:38261 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752420AbdHTKlV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 20 Aug 2017 06:41:21 -0400
Received: by mail-wr0-f193.google.com with SMTP id k10so256448wre.5
        for <linux-media@vger.kernel.org>; Sun, 20 Aug 2017 03:41:20 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: jasmin@anw.at, rjkm@metzlerbros.de
Subject: [PATCH 4/6] [media] ddbridge: remove ddb_info's from the global scope
Date: Sun, 20 Aug 2017 12:41:12 +0200
Message-Id: <20170820104114.6515-5-d.scheller.oss@gmail.com>
In-Reply-To: <20170820104114.6515-1-d.scheller.oss@gmail.com>
References: <20170820104114.6515-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Since the DD hardware info and maps aren't needed anymore outside of
ddbridge-hw.c (they're returned via get_ddb_info() now), mark them
static and remove all refs from ddbridge-hw.h.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/pci/ddbridge/ddbridge-hw.c | 46 ++++++++++++++++----------------
 drivers/media/pci/ddbridge/ddbridge-hw.h | 32 ----------------------
 2 files changed, 23 insertions(+), 55 deletions(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge-hw.c b/drivers/media/pci/ddbridge/ddbridge-hw.c
index 3b208d5bf4ad..1c25e86c189e 100644
--- a/drivers/media/pci/ddbridge/ddbridge-hw.c
+++ b/drivers/media/pci/ddbridge/ddbridge-hw.c
@@ -87,13 +87,13 @@ static struct ddb_regmap octopus_map = {
 
 /****************************************************************************/
 
-const struct ddb_info ddb_none = {
+static const struct ddb_info ddb_none = {
 	.type     = DDB_NONE,
 	.name     = "unknown Digital Devices PCIe card, install newer driver",
 	.regmap   = &octopus_map,
 };
 
-const struct ddb_info ddb_octopus = {
+static const struct ddb_info ddb_octopus = {
 	.type     = DDB_OCTOPUS,
 	.name     = "Digital Devices Octopus DVB adapter",
 	.regmap   = &octopus_map,
@@ -101,7 +101,7 @@ const struct ddb_info ddb_octopus = {
 	.i2c_mask = 0x0f,
 };
 
-const struct ddb_info ddb_octopusv3 = {
+static const struct ddb_info ddb_octopusv3 = {
 	.type     = DDB_OCTOPUS,
 	.name     = "Digital Devices Octopus V3 DVB adapter",
 	.regmap   = &octopus_map,
@@ -109,7 +109,7 @@ const struct ddb_info ddb_octopusv3 = {
 	.i2c_mask = 0x0f,
 };
 
-const struct ddb_info ddb_octopus_le = {
+static const struct ddb_info ddb_octopus_le = {
 	.type     = DDB_OCTOPUS,
 	.name     = "Digital Devices Octopus LE DVB adapter",
 	.regmap   = &octopus_map,
@@ -117,7 +117,7 @@ const struct ddb_info ddb_octopus_le = {
 	.i2c_mask = 0x03,
 };
 
-const struct ddb_info ddb_octopus_oem = {
+static const struct ddb_info ddb_octopus_oem = {
 	.type     = DDB_OCTOPUS,
 	.name     = "Digital Devices Octopus OEM",
 	.regmap   = &octopus_map,
@@ -129,7 +129,7 @@ const struct ddb_info ddb_octopus_oem = {
 	.temp_bus = 0,
 };
 
-const struct ddb_info ddb_octopus_mini = {
+static const struct ddb_info ddb_octopus_mini = {
 	.type     = DDB_OCTOPUS,
 	.name     = "Digital Devices Octopus Mini",
 	.regmap   = &octopus_map,
@@ -137,7 +137,7 @@ const struct ddb_info ddb_octopus_mini = {
 	.i2c_mask = 0x0f,
 };
 
-const struct ddb_info ddb_v6 = {
+static const struct ddb_info ddb_v6 = {
 	.type     = DDB_OCTOPUS,
 	.name     = "Digital Devices Cine S2 V6 DVB adapter",
 	.regmap   = &octopus_map,
@@ -145,7 +145,7 @@ const struct ddb_info ddb_v6 = {
 	.i2c_mask = 0x07,
 };
 
-const struct ddb_info ddb_v6_5 = {
+static const struct ddb_info ddb_v6_5 = {
 	.type     = DDB_OCTOPUS,
 	.name     = "Digital Devices Cine S2 V6.5 DVB adapter",
 	.regmap   = &octopus_map,
@@ -153,7 +153,7 @@ const struct ddb_info ddb_v6_5 = {
 	.i2c_mask = 0x0f,
 };
 
-const struct ddb_info ddb_v7 = {
+static const struct ddb_info ddb_v7 = {
 	.type     = DDB_OCTOPUS,
 	.name     = "Digital Devices Cine S2 V7 DVB adapter",
 	.regmap   = &octopus_map,
@@ -164,7 +164,7 @@ const struct ddb_info ddb_v7 = {
 	.ts_quirks = TS_QUIRK_REVERSED,
 };
 
-const struct ddb_info ddb_v7a = {
+static const struct ddb_info ddb_v7a = {
 	.type     = DDB_OCTOPUS,
 	.name     = "Digital Devices Cine S2 V7 Advanced DVB adapter",
 	.regmap   = &octopus_map,
@@ -175,7 +175,7 @@ const struct ddb_info ddb_v7a = {
 	.ts_quirks = TS_QUIRK_REVERSED,
 };
 
-const struct ddb_info ddb_ctv7 = {
+static const struct ddb_info ddb_ctv7 = {
 	.type     = DDB_OCTOPUS,
 	.name     = "Digital Devices Cine CT V7 DVB adapter",
 	.regmap   = &octopus_map,
@@ -185,7 +185,7 @@ const struct ddb_info ddb_ctv7 = {
 	.board_control_2 = 4,
 };
 
-const struct ddb_info ddb_satixS2v3 = {
+static const struct ddb_info ddb_satixS2v3 = {
 	.type     = DDB_OCTOPUS,
 	.name     = "Mystique SaTiX-S2 V3 DVB adapter",
 	.regmap   = &octopus_map,
@@ -193,7 +193,7 @@ const struct ddb_info ddb_satixS2v3 = {
 	.i2c_mask = 0x07,
 };
 
-const struct ddb_info ddb_ci = {
+static const struct ddb_info ddb_ci = {
 	.type     = DDB_OCTOPUS_CI,
 	.name     = "Digital Devices Octopus CI",
 	.regmap   = &octopus_map,
@@ -201,7 +201,7 @@ const struct ddb_info ddb_ci = {
 	.i2c_mask = 0x03,
 };
 
-const struct ddb_info ddb_cis = {
+static const struct ddb_info ddb_cis = {
 	.type     = DDB_OCTOPUS_CI,
 	.name     = "Digital Devices Octopus CI single",
 	.regmap   = &octopus_map,
@@ -209,7 +209,7 @@ const struct ddb_info ddb_cis = {
 	.i2c_mask = 0x03,
 };
 
-const struct ddb_info ddb_ci_s2_pro = {
+static const struct ddb_info ddb_ci_s2_pro = {
 	.type     = DDB_OCTOPUS_CI,
 	.name     = "Digital Devices Octopus CI S2 Pro",
 	.regmap   = &octopus_map,
@@ -219,7 +219,7 @@ const struct ddb_info ddb_ci_s2_pro = {
 	.board_control_2 = 4,
 };
 
-const struct ddb_info ddb_ci_s2_pro_a = {
+static const struct ddb_info ddb_ci_s2_pro_a = {
 	.type     = DDB_OCTOPUS_CI,
 	.name     = "Digital Devices Octopus CI S2 Pro Advanced",
 	.regmap   = &octopus_map,
@@ -229,7 +229,7 @@ const struct ddb_info ddb_ci_s2_pro_a = {
 	.board_control_2 = 4,
 };
 
-const struct ddb_info ddb_dvbct = {
+static const struct ddb_info ddb_dvbct = {
 	.type     = DDB_OCTOPUS,
 	.name     = "Digital Devices DVBCT V6.1 DVB adapter",
 	.regmap   = &octopus_map,
@@ -239,7 +239,7 @@ const struct ddb_info ddb_dvbct = {
 
 /****************************************************************************/
 
-const struct ddb_info ddb_ct2_8 = {
+static const struct ddb_info ddb_ct2_8 = {
 	.type     = DDB_OCTOPUS_MAX_CT,
 	.name     = "Digital Devices MAX A8 CT2",
 	.regmap   = &octopus_map,
@@ -251,7 +251,7 @@ const struct ddb_info ddb_ct2_8 = {
 	.tempmon_irq = 24,
 };
 
-const struct ddb_info ddb_c2t2_8 = {
+static const struct ddb_info ddb_c2t2_8 = {
 	.type     = DDB_OCTOPUS_MAX_CT,
 	.name     = "Digital Devices MAX A8 C2T2",
 	.regmap   = &octopus_map,
@@ -263,7 +263,7 @@ const struct ddb_info ddb_c2t2_8 = {
 	.tempmon_irq = 24,
 };
 
-const struct ddb_info ddb_isdbt_8 = {
+static const struct ddb_info ddb_isdbt_8 = {
 	.type     = DDB_OCTOPUS_MAX_CT,
 	.name     = "Digital Devices MAX A8 ISDBT",
 	.regmap   = &octopus_map,
@@ -275,7 +275,7 @@ const struct ddb_info ddb_isdbt_8 = {
 	.tempmon_irq = 24,
 };
 
-const struct ddb_info ddb_c2t2i_v0_8 = {
+static const struct ddb_info ddb_c2t2i_v0_8 = {
 	.type     = DDB_OCTOPUS_MAX_CT,
 	.name     = "Digital Devices MAX A8 C2T2I V0",
 	.regmap   = &octopus_map,
@@ -287,7 +287,7 @@ const struct ddb_info ddb_c2t2i_v0_8 = {
 	.tempmon_irq = 24,
 };
 
-const struct ddb_info ddb_c2t2i_8 = {
+static const struct ddb_info ddb_c2t2i_8 = {
 	.type     = DDB_OCTOPUS_MAX_CT,
 	.name     = "Digital Devices MAX A8 C2T2I",
 	.regmap   = &octopus_map,
@@ -301,7 +301,7 @@ const struct ddb_info ddb_c2t2i_8 = {
 
 /****************************************************************************/
 
-const struct ddb_info ddb_s2_48 = {
+static const struct ddb_info ddb_s2_48 = {
 	.type     = DDB_OCTOPUS_MAX,
 	.name     = "Digital Devices MAX S8 4/8",
 	.regmap   = &octopus_map,
diff --git a/drivers/media/pci/ddbridge/ddbridge-hw.h b/drivers/media/pci/ddbridge/ddbridge-hw.h
index 1a985d0a1a97..7c142419419c 100644
--- a/drivers/media/pci/ddbridge/ddbridge-hw.h
+++ b/drivers/media/pci/ddbridge/ddbridge-hw.h
@@ -37,38 +37,6 @@ struct ddb_device_id {
 
 /******************************************************************************/
 
-extern const struct ddb_info ddb_none;
-extern const struct ddb_info ddb_octopus;
-extern const struct ddb_info ddb_octopusv3;
-extern const struct ddb_info ddb_octopus_le;
-extern const struct ddb_info ddb_octopus_oem;
-extern const struct ddb_info ddb_octopus_mini;
-extern const struct ddb_info ddb_v6;
-extern const struct ddb_info ddb_v6_5;
-extern const struct ddb_info ddb_v7;
-extern const struct ddb_info ddb_v7a;
-extern const struct ddb_info ddb_ctv7;
-extern const struct ddb_info ddb_satixS2v3;
-extern const struct ddb_info ddb_ci;
-extern const struct ddb_info ddb_cis;
-extern const struct ddb_info ddb_ci_s2_pro;
-extern const struct ddb_info ddb_ci_s2_pro_a;
-extern const struct ddb_info ddb_dvbct;
-
-/****************************************************************************/
-
-extern const struct ddb_info ddb_ct2_8;
-extern const struct ddb_info ddb_c2t2_8;
-extern const struct ddb_info ddb_isdbt_8;
-extern const struct ddb_info ddb_c2t2i_v0_8;
-extern const struct ddb_info ddb_c2t2i_8;
-
-/****************************************************************************/
-
-extern const struct ddb_info ddb_s2_48;
-
-/****************************************************************************/
-
 const struct ddb_info *get_ddb_info(u16 vendor, u16 device,
 				    u16 subvendor, u16 subdevice);
 
-- 
2.13.0
