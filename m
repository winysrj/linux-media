Return-path: <linux-media-owner@vger.kernel.org>
Received: from sculptor.uberspace.de ([95.143.172.183]:55459 "EHLO
	sculptor.uberspace.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291AbaF3Nur (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Jun 2014 09:50:47 -0400
Message-ID: <53B169A0.5010907@creimer.net>
Date: Mon, 30 Jun 2014 15:44:00 +0200
From: Christopher Reimer <linux@creimer.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [PATCH] ddbridge: Add IDs for several newer Digital Devices cards
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

it's the first time I try to contribute here. So please be gracious.

This patch adds the necessary IDs for the following dvb cards:

Digital Devices Octopus Mini
Digital Devices Cine S2 V6.5
Digital Devices DVBCT V6.1
Digital Devices Octopus V3
Mystique SaTiX-S2 V3

All these changes are taken from the official driver package by Digital 
Devices.
http://download.digital-devices.de/download/linux/

Signed-off-by: Christopher Reimer <mail@creimer.net>

---

diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c 
b/drivers/media/pci/ddbridge/ddbridge-core.c
index fb52bda..da8f848 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -1663,11 +1663,40 @@ static struct ddb_info ddb_octopus_le = {
      .port_num = 2,
  };

+static struct ddb_info ddb_octopus_mini = {
+    .type     = DDB_OCTOPUS,
+    .name     = "Digital Devices Octopus Mini",
+    .port_num = 4,
+};
+
  static struct ddb_info ddb_v6 = {
      .type     = DDB_OCTOPUS,
      .name     = "Digital Devices Cine S2 V6 DVB adapter",
      .port_num = 3,
  };
+static struct ddb_info ddb_v6_5 = {
+    .type     = DDB_OCTOPUS,
+    .name     = "Digital Devices Cine S2 V6.5 DVB adapter",
+    .port_num = 4,
+};
+
+static struct ddb_info ddb_dvbct = {
+    .type     = DDB_OCTOPUS,
+    .name     = "Digital Devices DVBCT V6.1 DVB adapter",
+    .port_num = 3,
+};
+
+static struct ddb_info ddb_satixS2v3 = {
+    .type     = DDB_OCTOPUS,
+    .name     = "Mystique SaTiX-S2 V3 DVB adapter",
+    .port_num = 3,
+};
+
+static struct ddb_info ddb_octopusv3 = {
+    .type     = DDB_OCTOPUS,
+    .name     = "Digital Devices Octopus V3 DVB adapter",
+    .port_num = 4,
+};

  #define DDVID 0xdd01 /* Digital Devices Vendor ID */

@@ -1680,8 +1709,12 @@ static const struct pci_device_id ddb_id_tbl[] = {
      DDB_ID(DDVID, 0x0002, DDVID, 0x0001, ddb_octopus),
      DDB_ID(DDVID, 0x0003, DDVID, 0x0001, ddb_octopus),
      DDB_ID(DDVID, 0x0003, DDVID, 0x0002, ddb_octopus_le),
-    DDB_ID(DDVID, 0x0003, DDVID, 0x0010, ddb_octopus),
+    DDB_ID(DDVID, 0x0003, DDVID, 0x0010, ddb_octopus_mini),
      DDB_ID(DDVID, 0x0003, DDVID, 0x0020, ddb_v6),
+    DDB_ID(DDVID, 0x0003, DDVID, 0x0021, ddb_v6_5),
+    DDB_ID(DDVID, 0x0003, DDVID, 0x0030, ddb_dvbct),
+    DDB_ID(DDVID, 0x0003, DDVID, 0xdb03, ddb_satixS2v3),
+    DDB_ID(DDVID, 0x0005, DDVID, 0x0004, ddb_octopusv3),
      /* in case sub-ids got deleted in flash */
      DDB_ID(DDVID, 0x0003, PCI_ANY_ID, PCI_ANY_ID, ddb_none),
      {0}

