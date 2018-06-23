Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:32859 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751589AbeFWPg0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 23 Jun 2018 11:36:26 -0400
Received: by mail-wr0-f195.google.com with SMTP id k16-v6so9439525wro.0
        for <linux-media@vger.kernel.org>; Sat, 23 Jun 2018 08:36:25 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: mchehab@kernel.org, mchehab@s-opensource.com
Cc: linux-media@vger.kernel.org
Subject: [PATCH 07/19] [media] ddbridge: link structure access cosmetics in ddb_port_probe()
Date: Sat, 23 Jun 2018 17:36:03 +0200
Message-Id: <20180623153615.27630-8-d.scheller.oss@gmail.com>
In-Reply-To: <20180623153615.27630-1-d.scheller.oss@gmail.com>
References: <20180623153615.27630-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Throughout the function, dev->link[l] is used several times. Unclutter
this a bit by declaring a ddb_link var at the top of the function, assign
the address of dev->link[l] to it and use that var to access the link[]
struct member.

Picked up from the upstream dddvb GIT.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/pci/ddbridge/ddbridge-core.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index 55eb151f329e..408460be00b7 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -1850,6 +1850,7 @@ static void ddb_port_probe(struct ddb_port *port)
 {
 	struct ddb *dev = port->dev;
 	u32 l = port->lnr;
+	struct ddb_link *link = &dev->link[l];
 	u8 id, type;
 
 	port->name = "NO MODULE";
@@ -1859,7 +1860,7 @@ static void ddb_port_probe(struct ddb_port *port)
 	/* Handle missing ports and ports without I2C */
 
 	if (dummy_tuner && !port->nr &&
-	    dev->link[l].ids.device == 0x0005) {
+	    link->ids.device == 0x0005) {
 		port->name = "DUMMY";
 		port->class = DDB_PORT_TUNER;
 		port->type = DDB_TUNER_DUMMY;
@@ -1873,14 +1874,14 @@ static void ddb_port_probe(struct ddb_port *port)
 		return;
 	}
 
-	if (port->nr == 1 && dev->link[l].info->type == DDB_OCTOPUS_CI &&
-	    dev->link[l].info->i2c_mask == 1) {
+	if (port->nr == 1 && link->info->type == DDB_OCTOPUS_CI &&
+	    link->info->i2c_mask == 1) {
 		port->name = "NO TAB";
 		port->class = DDB_PORT_NONE;
 		return;
 	}
 
-	if (dev->link[l].info->type == DDB_OCTOPUS_MAX) {
+	if (link->info->type == DDB_OCTOPUS_MAX) {
 		port->name = "DUAL DVB-S2 MAX";
 		port->type_name = "MXL5XX";
 		port->class = DDB_PORT_TUNER;
@@ -1891,8 +1892,8 @@ static void ddb_port_probe(struct ddb_port *port)
 		return;
 	}
 
-	if (dev->link[l].info->type == DDB_OCTOPUS_MCI) {
-		if (port->nr >= dev->link[l].info->mci)
+	if (link->info->type == DDB_OCTOPUS_MCI) {
+		if (port->nr >= link->info->mci)
 			return;
 		port->name = "DUAL MCI";
 		port->type_name = "MCI";
@@ -1901,7 +1902,7 @@ static void ddb_port_probe(struct ddb_port *port)
 		return;
 	}
 
-	if (port->nr > 1 && dev->link[l].info->type == DDB_OCTOPUS_CI) {
+	if (port->nr > 1 && link->info->type == DDB_OCTOPUS_CI) {
 		port->name = "CI internal";
 		port->type_name = "INTERNAL";
 		port->class = DDB_PORT_CI;
@@ -1986,7 +1987,7 @@ static void ddb_port_probe(struct ddb_port *port)
 		port->class = DDB_PORT_TUNER;
 		if (id == 0x51) {
 			if (port->nr == 0 &&
-			    dev->link[l].info->ts_quirks & TS_QUIRK_REVERSED)
+			    link->info->ts_quirks & TS_QUIRK_REVERSED)
 				port->type = DDB_TUNER_DVBS_STV0910_PR;
 			else
 				port->type = DDB_TUNER_DVBS_STV0910_P;
-- 
2.16.4
