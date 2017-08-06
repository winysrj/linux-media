Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:35939 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751179AbdHFHta (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 6 Aug 2017 03:49:30 -0400
From: Bhumika Goyal <bhumirks@gmail.com>
To: julia.lawall@lip6.fr, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH] media: ddbridge: make ddb_info const
Date: Sun,  6 Aug 2017 13:19:14 +0530
Message-Id: <1502005754-9423-1-git-send-email-bhumirks@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make ddb_info structures const as they are only used during a copy
operation.

Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
---
 drivers/media/pci/ddbridge/ddbridge-core.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index ec41804..7505e1e 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -2302,7 +2302,7 @@ static int ddb_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 /*** MaxA8 adapters ***********************************************************/
 
-static struct ddb_info ddb_ct2_8 = {
+static const struct ddb_info ddb_ct2_8 = {
 	.type     = DDB_OCTOPUS_MAX_CT,
 	.name     = "Digital Devices MAX A8 CT2",
 	.port_num = 4,
@@ -2311,7 +2311,7 @@ static int ddb_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	.ts_quirks = TS_QUIRK_SERIAL,
 };
 
-static struct ddb_info ddb_c2t2_8 = {
+static const struct ddb_info ddb_c2t2_8 = {
 	.type     = DDB_OCTOPUS_MAX_CT,
 	.name     = "Digital Devices MAX A8 C2T2",
 	.port_num = 4,
@@ -2320,7 +2320,7 @@ static int ddb_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	.ts_quirks = TS_QUIRK_SERIAL,
 };
 
-static struct ddb_info ddb_isdbt_8 = {
+static const struct ddb_info ddb_isdbt_8 = {
 	.type     = DDB_OCTOPUS_MAX_CT,
 	.name     = "Digital Devices MAX A8 ISDBT",
 	.port_num = 4,
@@ -2329,7 +2329,7 @@ static int ddb_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	.ts_quirks = TS_QUIRK_SERIAL,
 };
 
-static struct ddb_info ddb_c2t2i_v0_8 = {
+static const struct ddb_info ddb_c2t2i_v0_8 = {
 	.type     = DDB_OCTOPUS_MAX_CT,
 	.name     = "Digital Devices MAX A8 C2T2I V0",
 	.port_num = 4,
@@ -2338,7 +2338,7 @@ static int ddb_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	.ts_quirks = TS_QUIRK_SERIAL | TS_QUIRK_ALT_OSC,
 };
 
-static struct ddb_info ddb_c2t2i_8 = {
+static const struct ddb_info ddb_c2t2i_8 = {
 	.type     = DDB_OCTOPUS_MAX_CT,
 	.name     = "Digital Devices MAX A8 C2T2I",
 	.port_num = 4,
-- 
1.9.1
