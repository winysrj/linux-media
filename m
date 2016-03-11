Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:34259 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754082AbcCKGsO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Mar 2016 01:48:14 -0500
Received: by mail-lb0-f179.google.com with SMTP id xr8so138158651lbb.1
        for <linux-media@vger.kernel.org>; Thu, 10 Mar 2016 22:48:13 -0800 (PST)
From: Olli Salonen <olli.salonen@iki.fi>
To: linux-media@vger.kernel.org
Cc: nibble.max@gmail.com, Olli Salonen <olli.salonen@iki.fi>
Subject: [PATCH] smipcie: add RC map into card configuration options
Date: Fri, 11 Mar 2016 08:48:03 +0200
Message-Id: <1457678883-18427-1-git-send-email-olli.salonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove the if..else statement from smipcie-ir.c and add the remote
controller map as a configuration parameter for the card.

Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
---
 drivers/media/pci/smipcie/smipcie-ir.c   | 5 +----
 drivers/media/pci/smipcie/smipcie-main.c | 4 ++++
 drivers/media/pci/smipcie/smipcie.h      | 1 +
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/media/pci/smipcie/smipcie-ir.c b/drivers/media/pci/smipcie/smipcie-ir.c
index d737b5e..826c7c7 100644
--- a/drivers/media/pci/smipcie/smipcie-ir.c
+++ b/drivers/media/pci/smipcie/smipcie-ir.c
@@ -203,10 +203,7 @@ int smi_ir_init(struct smi_dev *dev)
 	rc_dev->dev.parent = &dev->pci_dev->dev;
 
 	rc_dev->driver_type = RC_DRIVER_SCANCODE;
-	if (dev->info->type == SMI_TECHNOTREND_S2_4200)
-		rc_dev->map_name = RC_MAP_TT_1500;
-	else
-		rc_dev->map_name = RC_MAP_DVBSKY;
+	rc_dev->map_name = dev->info->rc_map;
 
 	ir->rc_dev = rc_dev;
 	ir->dev = dev;
diff --git a/drivers/media/pci/smipcie/smipcie-main.c b/drivers/media/pci/smipcie/smipcie-main.c
index 4a9275a..83981d61 100644
--- a/drivers/media/pci/smipcie/smipcie-main.c
+++ b/drivers/media/pci/smipcie/smipcie-main.c
@@ -1067,6 +1067,7 @@ static struct smi_cfg_info dvbsky_s950_cfg = {
 	.ts_1 = SMI_TS_DMA_BOTH,
 	.fe_0 = DVBSKY_FE_NULL,
 	.fe_1 = DVBSKY_FE_M88DS3103,
+	.rc_map = RC_MAP_DVBSKY,
 };
 
 static struct smi_cfg_info dvbsky_s952_cfg = {
@@ -1076,6 +1077,7 @@ static struct smi_cfg_info dvbsky_s952_cfg = {
 	.ts_1 = SMI_TS_DMA_BOTH,
 	.fe_0 = DVBSKY_FE_M88RS6000,
 	.fe_1 = DVBSKY_FE_M88RS6000,
+	.rc_map = RC_MAP_DVBSKY,
 };
 
 static struct smi_cfg_info dvbsky_t9580_cfg = {
@@ -1085,6 +1087,7 @@ static struct smi_cfg_info dvbsky_t9580_cfg = {
 	.ts_1 = SMI_TS_DMA_BOTH,
 	.fe_0 = DVBSKY_FE_SIT2,
 	.fe_1 = DVBSKY_FE_M88DS3103,
+	.rc_map = RC_MAP_DVBSKY,
 };
 
 static struct smi_cfg_info technotrend_s2_4200_cfg = {
@@ -1094,6 +1097,7 @@ static struct smi_cfg_info technotrend_s2_4200_cfg = {
 	.ts_1 = SMI_TS_DMA_BOTH,
 	.fe_0 = DVBSKY_FE_M88RS6000,
 	.fe_1 = DVBSKY_FE_M88RS6000,
+	.rc_map = RC_MAP_TT_1500,
 };
 
 /* PCI IDs */
diff --git a/drivers/media/pci/smipcie/smipcie.h b/drivers/media/pci/smipcie/smipcie.h
index 5528e48..611e4f0 100644
--- a/drivers/media/pci/smipcie/smipcie.h
+++ b/drivers/media/pci/smipcie/smipcie.h
@@ -233,6 +233,7 @@ struct smi_cfg_info {
 #define DVBSKY_FE_SIT2          3
 	int fe_0;
 	int fe_1;
+	char *rc_map;
 };
 
 struct smi_rc {
-- 
1.9.1

