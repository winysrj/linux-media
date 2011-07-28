Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.work.de ([212.12.45.188]:42991 "EHLO smtp2.work.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755219Ab1G1Lq7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jul 2011 07:46:59 -0400
From: Julian Scheel <julian@jusst.de>
To: linux-media@vger.kernel.org
Cc: Julian Scheel <julian@jusst.de>
Subject: [PATCH] Add support for new revision of KNC 1 DVB-C cards. Using tda10024 instead of tda10023, which is compatible to tda10023 driver.
Date: Thu, 28 Jul 2011 13:04:33 +0200
Message-Id: <1311851073-6558-1-git-send-email-julian@jusst.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Julian Scheel <julian@jusst.de>
---
 drivers/media/dvb/ttpci/budget-av.c   |    4 ++++
 drivers/media/dvb/ttpci/budget-core.c |    2 ++
 drivers/media/dvb/ttpci/budget.h      |    1 +
 3 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/media/dvb/ttpci/budget-av.c b/drivers/media/dvb/ttpci/budget-av.c
index e957d76..5b28bc6 100644
--- a/drivers/media/dvb/ttpci/budget-av.c
+++ b/drivers/media/dvb/ttpci/budget-av.c
@@ -1197,6 +1197,7 @@ static u8 read_pwm(struct budget_av *budget_av)
 #define SUBID_DVBC_KNC1			0x0020
 #define SUBID_DVBC_KNC1_PLUS		0x0021
 #define SUBID_DVBC_KNC1_MK3		0x0022
+#define SUBID_DVBC_KNC1_TDA10024	0x0028
 #define SUBID_DVBC_KNC1_PLUS_MK3	0x0023
 #define SUBID_DVBC_CINERGY1200		0x1156
 #define SUBID_DVBC_CINERGY1200_MK3	0x1176
@@ -1316,6 +1317,7 @@ static void frontend_init(struct budget_av *budget_av)
 	case SUBID_DVBC_EASYWATCH_MK3:
 	case SUBID_DVBC_CINERGY1200_MK3:
 	case SUBID_DVBC_KNC1_MK3:
+	case SUBID_DVBC_KNC1_TDA10024:
 	case SUBID_DVBC_KNC1_PLUS_MK3:
 		budget_av->reinitialise_demod = 1;
 		budget_av->budget.dev->i2c_bitrate = SAA7146_I2C_BUS_BIT_RATE_240;
@@ -1558,6 +1560,7 @@ MAKE_BUDGET_INFO(knc1sp, "KNC1 DVB-S Plus", BUDGET_KNC1SP);
 MAKE_BUDGET_INFO(knc1spx4, "KNC1 DVB-S Plus X4", BUDGET_KNC1SP);
 MAKE_BUDGET_INFO(knc1cp, "KNC1 DVB-C Plus", BUDGET_KNC1CP);
 MAKE_BUDGET_INFO(knc1cmk3, "KNC1 DVB-C MK3", BUDGET_KNC1C_MK3);
+MAKE_BUDGET_INFO(knc1ctda10024, "KNC1 DVB-C TDA10024", BUDGET_KNC1C_TDA10024);
 MAKE_BUDGET_INFO(knc1cpmk3, "KNC1 DVB-C Plus MK3", BUDGET_KNC1CP_MK3);
 MAKE_BUDGET_INFO(knc1tp, "KNC1 DVB-T Plus", BUDGET_KNC1TP);
 MAKE_BUDGET_INFO(cin1200s, "TerraTec Cinergy 1200 DVB-S", BUDGET_CIN1200S);
@@ -1587,6 +1590,7 @@ static struct pci_device_id pci_tbl[] = {
 	MAKE_EXTENSION_PCI(knc1c, 0x1894, 0x0020),
 	MAKE_EXTENSION_PCI(knc1cp, 0x1894, 0x0021),
 	MAKE_EXTENSION_PCI(knc1cmk3, 0x1894, 0x0022),
+	MAKE_EXTENSION_PCI(knc1ctda10024, 0x1894, 0x0028),
 	MAKE_EXTENSION_PCI(knc1cpmk3, 0x1894, 0x0023),
 	MAKE_EXTENSION_PCI(knc1t, 0x1894, 0x0030),
 	MAKE_EXTENSION_PCI(knc1tp, 0x1894, 0x0031),
diff --git a/drivers/media/dvb/ttpci/budget-core.c b/drivers/media/dvb/ttpci/budget-core.c
index 37666d4..37d02fe 100644
--- a/drivers/media/dvb/ttpci/budget-core.c
+++ b/drivers/media/dvb/ttpci/budget-core.c
@@ -110,6 +110,7 @@ static int start_ts_capture(struct budget *budget)
 		break;
 	case BUDGET_CIN1200C_MK3:
 	case BUDGET_KNC1C_MK3:
+	case BUDGET_KNC1C_TDA10024:
 	case BUDGET_KNC1CP_MK3:
 		if (budget->video_port == BUDGET_VIDEO_PORTA) {
 			saa7146_write(dev, DD1_INIT, 0x06000200);
@@ -434,6 +435,7 @@ int ttpci_budget_init(struct budget *budget, struct saa7146_dev *dev,
 	case BUDGET_KNC1CP:
 	case BUDGET_CIN1200C:
 	case BUDGET_KNC1C_MK3:
+	case BUDGET_KNC1C_TDA10024:
 	case BUDGET_KNC1CP_MK3:
 	case BUDGET_CIN1200C_MK3:
 		budget->buffer_width = TS_WIDTH_DVBC;
diff --git a/drivers/media/dvb/ttpci/budget.h b/drivers/media/dvb/ttpci/budget.h
index 3ad0c67..3d8a806 100644
--- a/drivers/media/dvb/ttpci/budget.h
+++ b/drivers/media/dvb/ttpci/budget.h
@@ -104,6 +104,7 @@ static struct saa7146_pci_extension_data x_var = { \
 #define BUDGET_KNC1C_MK3	   16
 #define BUDGET_KNC1CP_MK3	   17
 #define BUDGET_KNC1S2              18
+#define BUDGET_KNC1C_TDA10024	   19
 
 #define BUDGET_VIDEO_PORTA         0
 #define BUDGET_VIDEO_PORTB         1
-- 
1.7.6

