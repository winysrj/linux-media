Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f195.google.com ([209.85.217.195]:36410 "EHLO
	mail-lb0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753977AbcCIWii (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Mar 2016 17:38:38 -0500
Received: by mail-lb0-f195.google.com with SMTP id gn5so6569432lbc.3
        for <linux-media@vger.kernel.org>; Wed, 09 Mar 2016 14:38:38 -0800 (PST)
From: Olli Salonen <olli.salonen@iki.fi>
To: linux-media@vger.kernel.org
Cc: Olli Salonen <olli.salonen@iki.fi>
Subject: [PATCH 1/2] smipcie: add support for TechnoTrend S2-4200 Twin
Date: Thu, 10 Mar 2016 00:38:27 +0200
Message-Id: <1457563108-17017-1-git-send-email-olli.salonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for TechnoTrend TT-budget S2-4200 Twin DVB-S2 tuner. The
device seems to be rather similar to DVBSky S952 V3. This is a PCIe
card with 2 tuners. SMI PCIe bridge is used and the card has two 
Montage M88RS6000 demod/tuners.

The M88RS6000 demod/tuner package needs firmware. You can download
one here:
http://palosaari.fi/linux/v4l-dvb/firmware/M88RS6000/

Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
---
 drivers/media/pci/smipcie/smipcie-ir.c   |  5 ++++-
 drivers/media/pci/smipcie/smipcie-main.c | 10 ++++++++++
 drivers/media/pci/smipcie/smipcie.h      |  1 +
 3 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/media/pci/smipcie/smipcie-ir.c b/drivers/media/pci/smipcie/smipcie-ir.c
index d018673..d737b5e 100644
--- a/drivers/media/pci/smipcie/smipcie-ir.c
+++ b/drivers/media/pci/smipcie/smipcie-ir.c
@@ -203,7 +203,10 @@ int smi_ir_init(struct smi_dev *dev)
 	rc_dev->dev.parent = &dev->pci_dev->dev;
 
 	rc_dev->driver_type = RC_DRIVER_SCANCODE;
-	rc_dev->map_name = RC_MAP_DVBSKY;
+	if (dev->info->type == SMI_TECHNOTREND_S2_4200)
+		rc_dev->map_name = RC_MAP_TT_1500;
+	else
+		rc_dev->map_name = RC_MAP_DVBSKY;
 
 	ir->rc_dev = rc_dev;
 	ir->dev = dev;
diff --git a/drivers/media/pci/smipcie/smipcie-main.c b/drivers/media/pci/smipcie/smipcie-main.c
index b039a22..993a2d1 100644
--- a/drivers/media/pci/smipcie/smipcie-main.c
+++ b/drivers/media/pci/smipcie/smipcie-main.c
@@ -1086,6 +1086,15 @@ static struct smi_cfg_info dvbsky_t9580_cfg = {
 	.fe_1 = DVBSKY_FE_M88DS3103,
 };
 
+static struct smi_cfg_info technotrend_s2_4200_cfg = {
+	.type = SMI_TECHNOTREND_S2_4200,
+	.name = "TechnoTrend TT-budget S2-4200 Twin",
+	.ts_0 = SMI_TS_DMA_BOTH,
+	.ts_1 = SMI_TS_DMA_BOTH,
+	.fe_0 = DVBSKY_FE_M88RS6000,
+	.fe_1 = DVBSKY_FE_M88RS6000,
+};
+
 /* PCI IDs */
 #define SMI_ID(_subvend, _subdev, _driverdata) {	\
 	.vendor      = SMI_VID,    .device    = SMI_PID, \
@@ -1096,6 +1105,7 @@ static const struct pci_device_id smi_id_table[] = {
 	SMI_ID(0x4254, 0x0550, dvbsky_s950_cfg),
 	SMI_ID(0x4254, 0x0552, dvbsky_s952_cfg),
 	SMI_ID(0x4254, 0x5580, dvbsky_t9580_cfg),
+	SMI_ID(0x13c2, 0x3016, technotrend_s2_4200_cfg),
 	{0}
 };
 MODULE_DEVICE_TABLE(pci, smi_id_table);
diff --git a/drivers/media/pci/smipcie/smipcie.h b/drivers/media/pci/smipcie/smipcie.h
index 68cdda2..5528e48 100644
--- a/drivers/media/pci/smipcie/smipcie.h
+++ b/drivers/media/pci/smipcie/smipcie.h
@@ -216,6 +216,7 @@ struct smi_cfg_info {
 #define SMI_DVBSKY_S950         1
 #define SMI_DVBSKY_T9580        2
 #define SMI_DVBSKY_T982         3
+#define SMI_TECHNOTREND_S2_4200 4
 	int type;
 	char *name;
 #define SMI_TS_NULL             0
-- 
1.9.1

