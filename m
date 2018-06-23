Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34948 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751661AbeFWPgb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 23 Jun 2018 11:36:31 -0400
Received: by mail-wm0-f65.google.com with SMTP id j15-v6so5644268wme.0
        for <linux-media@vger.kernel.org>; Sat, 23 Jun 2018 08:36:30 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: mchehab@kernel.org, mchehab@s-opensource.com
Cc: linux-media@vger.kernel.org
Subject: [PATCH 13/19] [media] ddbridge/mci: store mci type and number of ports in the hwinfo
Date: Sat, 23 Jun 2018 17:36:09 +0200
Message-Id: <20180623153615.27630-14-d.scheller.oss@gmail.com>
In-Reply-To: <20180623153615.27630-1-d.scheller.oss@gmail.com>
References: <20180623153615.27630-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

For better support for future MCI based cards, rename the mci struct
member to mci_ports to carry the number of ports on the cards, and add a
mci_type member to identify the card type to handle differing hardware.

Picked up from the upstream dddvb GIT.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/pci/ddbridge/ddbridge-core.c | 4 ++--
 drivers/media/pci/ddbridge/ddbridge-hw.c   | 3 ++-
 drivers/media/pci/ddbridge/ddbridge.h      | 9 ++++++---
 3 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index 68ea0ffdad2d..67b60da12cf4 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -1893,12 +1893,12 @@ static void ddb_port_probe(struct ddb_port *port)
 	}
 
 	if (link->info->type == DDB_OCTOPUS_MCI) {
-		if (port->nr >= link->info->mci)
+		if (port->nr >= link->info->mci_ports)
 			return;
 		port->name = "DUAL MCI";
 		port->type_name = "MCI";
 		port->class = DDB_PORT_TUNER;
-		port->type = DDB_TUNER_MCI_SX8;
+		port->type = DDB_TUNER_MCI + link->info->mci_type;
 		return;
 	}
 
diff --git a/drivers/media/pci/ddbridge/ddbridge-hw.c b/drivers/media/pci/ddbridge/ddbridge-hw.c
index 1d3ee6accdd5..f3cbac07b41f 100644
--- a/drivers/media/pci/ddbridge/ddbridge-hw.c
+++ b/drivers/media/pci/ddbridge/ddbridge-hw.c
@@ -318,7 +318,8 @@ static const struct ddb_info ddb_s2x_48 = {
 	.port_num = 4,
 	.i2c_mask = 0x00,
 	.tempmon_irq = 24,
-	.mci      = 4
+	.mci_ports = 4,
+	.mci_type = 0,
 };
 
 /****************************************************************************/
diff --git a/drivers/media/pci/ddbridge/ddbridge.h b/drivers/media/pci/ddbridge/ddbridge.h
index 65bd74d86ed5..8a354dfb6c22 100644
--- a/drivers/media/pci/ddbridge/ddbridge.h
+++ b/drivers/media/pci/ddbridge/ddbridge.h
@@ -120,20 +120,23 @@ struct ddb_info {
 #define DDB_OCTOPUS_MCI     9
 	char *name;
 	u32   i2c_mask;
+	u32   board_control;
+	u32   board_control_2;
+
 	u8    port_num;
 	u8    led_num;
 	u8    fan_num;
 	u8    temp_num;
 	u8    temp_bus;
-	u32   board_control;
-	u32   board_control_2;
 	u8    con_clock; /* use a continuous clock */
 	u8    ts_quirks;
 #define TS_QUIRK_SERIAL   1
 #define TS_QUIRK_REVERSED 2
 #define TS_QUIRK_ALT_OSC  8
+	u8    mci_ports;
+	u8    mci_type;
+
 	u32   tempmon_irq;
-	u8    mci;
 	const struct ddb_regmap *regmap;
 };
 
-- 
2.16.4
