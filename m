Return-path: <mchehab@localhost>
Received: from devils.ext.ti.com ([198.47.26.153]:42288 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755576Ab0IBOqa (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Sep 2010 10:46:30 -0400
From: raja_mani@ti.com
To: hverkuil@xs4all.nl, linux-media@vger.kernel.org,
	mchehab@infradead.org
Cc: matti.j.aaltonen@nokia.com, Raja Mani <raja_mani@ti.com>,
	Pramodh AG <pramodh_ag@ti.com>
Subject: [RFC/PATCH 5/8] drivers:staging:ti-st: Code cleanup in FM Common module
Date: Thu,  2 Sep 2010 11:57:57 -0400
Message-Id: <1283443080-30644-6-git-send-email-raja_mani@ti.com>
In-Reply-To: <1283443080-30644-5-git-send-email-raja_mani@ti.com>
References: <1283443080-30644-1-git-send-email-raja_mani@ti.com>
 <1283443080-30644-2-git-send-email-raja_mani@ti.com>
 <1283443080-30644-3-git-send-email-raja_mani@ti.com>
 <1283443080-30644-4-git-send-email-raja_mani@ti.com>
 <1283443080-30644-5-git-send-email-raja_mani@ti.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@localhost>

From: Raja Mani <raja_mani@ti.com>

Code cleanup and bug fixes in TI FM Common module.
 1) Remove fmc_get_region() API (since it moved to FM RX module)
 2) Mute/Umute fix ( As v4l2 spec, MUTE_ON should 1 and MUTE_OFF should be 0)
 3) Support for FM TX Antenna Impedance configuration.

Signed-off-by: Raja Mani <raja_mani@ti.com>
Signed-off-by: Pramodh AG <pramodh_ag@ti.com>
---
 drivers/staging/ti-st/fmdrv_common.c |   39 +++++++++++++--------------------
 drivers/staging/ti-st/fmdrv_common.h |   23 ++++++++++++++++++-
 2 files changed, 36 insertions(+), 26 deletions(-)

diff --git a/drivers/staging/ti-st/fmdrv_common.c b/drivers/staging/ti-st/fmdrv_common.c
index 8152031..ec502b0 100644
--- a/drivers/staging/ti-st/fmdrv_common.c
+++ b/drivers/staging/ti-st/fmdrv_common.c
@@ -38,8 +38,7 @@
 #include "fmdrv_common.h"
 #include "st.h"
 #include "fmdrv_rx.h"
-/* TODO: Enable when FM TX is supported */
-/* #include "fmdrv_tx.h" */
+#include "fmdrv_tx.h"
 
 #ifndef DEBUG
 #ifdef pr_info
@@ -188,6 +187,8 @@ static struct fm_reg_table fm_reg_info[] = {
 	{0x51, REG_RD, "MS_GET"},
 	{0x52, REG_WR, "PS_SCROLL_SPEED_SET"},
 	{0x52, REG_RD, "PS_SCROLL_SPEED_GET"},
+	{0x57, REG_WR, "ANT_IMP_SET"},
+	{0x57, REG_RD, "ANT_IMP_GET"},
 };
 
 /* Region info */
@@ -1507,9 +1508,8 @@ int fmc_set_frequency(struct fmdrv_ops *fmdev, unsigned int freq_to_set)
 		break;
 
 	case FM_MODE_TX:
-		/* TODO: Enable when FM TX is supported */
-		/* ret = fm_tx_set_frequency(fmdev, freq_to_set); */
-		/* break; */
+		ret = fm_tx_set_frequency(fmdev, freq_to_set);
+		break;
 
 	default:
 		ret = -EINVAL;
@@ -1548,13 +1548,6 @@ exit:
 	return ret;
 }
 
-/* Returns current band index (0-Europe/US; 1-Japan) */
-int fmc_get_region(struct fmdrv_ops *fmdev, unsigned char *region)
-{
-	*region = fmdev->rx.region.region_index;
-	return 0;
-}
-
 int fmc_set_region(struct fmdrv_ops *fmdev, unsigned char region_to_set)
 {
 	int ret;
@@ -1565,9 +1558,8 @@ int fmc_set_region(struct fmdrv_ops *fmdev, unsigned char region_to_set)
 		break;
 
 	case FM_MODE_TX:
-		/* TODO: Enable when FM TX is supported */
-		/* ret = fm_tx_set_region(fmdev, region_to_set); */
-		/* break; */
+		ret = fm_tx_set_region(fmdev, region_to_set);
+		break;
 
 	default:
 		ret = -EINVAL;
@@ -1585,9 +1577,8 @@ int fmc_set_mute_mode(struct fmdrv_ops *fmdev, unsigned char mute_mode_toset)
 		break;
 
 	case FM_MODE_TX:
-		/* TODO: Enable when FM TX is supported */
-		/* ret = fm_tx_set_mute_mode(fmdev, mute_mode_toset); */
-		/* break; */
+		ret = fm_tx_set_mute_mode(fmdev, mute_mode_toset);
+		break;
 
 	default:
 		ret = -EINVAL;
@@ -1605,9 +1596,8 @@ int fmc_set_stereo_mono(struct fmdrv_ops *fmdev, unsigned short mode)
 		break;
 
 	case FM_MODE_TX:
-		/* TODO: Enable when FM TX is supported */
-		/* ret = fm_tx_set_stereo_mono(fmdev, mode); */
-		/* break; */
+		ret = fm_tx_set_stereo_mono(fmdev, mode);
+		break;
 
 	default:
 		ret = -EINVAL;
@@ -1625,9 +1615,8 @@ int fmc_set_rds_mode(struct fmdrv_ops *fmdev, unsigned char rds_en_dis)
 		break;
 
 	case FM_MODE_TX:
-		/* TODO: Enable when FM TX is supported */
-		/* ret = fm_tx_set_rds_mode(fmdev, rds_en_dis); */
-		/* break; */
+		ret = fm_tx_set_rds_mode(fmdev, rds_en_dis);
+		break;
 
 	default:
 		ret = -EINVAL;
@@ -2101,6 +2090,8 @@ static int __init fm_drv_init(void)
 
 	fmdev->irq_info.fm_int_handlers = g_IntHandlerTable;
 	fmdev->curr_fmmode = FM_MODE_OFF;
+	fmdev->tx_data.pwr_lvl = FM_PWR_LVL_DEF;
+	fmdev->tx_data.preemph = FM_TX_PREEMPH_50US;
 	goto exit;
 
 rel_rdsbuf:
diff --git a/drivers/staging/ti-st/fmdrv_common.h b/drivers/staging/ti-st/fmdrv_common.h
index 7fb55f3..9f60c2c 100644
--- a/drivers/staging/ti-st/fmdrv_common.h
+++ b/drivers/staging/ti-st/fmdrv_common.h
@@ -173,6 +173,8 @@ enum fm_reg_index {
 	MS_GET,
 	PS_SCROLL_SPEED_SET,
 	PS_SCROLL_SPEED_GET,
+	IMP_SET,
+	IMP_GET,
 
 	FM_REG_MAX_ENTRIES
 };
@@ -300,8 +302,8 @@ struct bts_action_delay {
 #define FM_RX_VOLUME_GAIN_STEP	0x370
 
 /* Mute modes */
-#define FM_MUTE_ON		0
-#define	FM_MUTE_OFF		1
+#define FM_MUTE_OFF		0
+#define	FM_MUTE_ON		1
 #define	FM_MUTE_ATTENUATE	2
 
 #define FM_RX_MUTE_UNMUTE_MODE		0x00
@@ -432,6 +434,23 @@ struct bts_action_delay {
 #define FM_DEFAULT_RX_VOLUME		10
 #define FM_DEFAULT_RSSI_THRESHOLD	3
 
+/* Range for TX power level in units for dB/uV */
+#define FM_PWR_LVL_LOW			91
+#define FM_PWR_LVL_HIGH			122
+
+/* Chip specific default TX power level value */
+#define FM_PWR_LVL_DEF			4
+
+/* FM TX Pre-emphasis filter values */
+#define FM_TX_PREEMPH_OFF		1
+#define FM_TX_PREEMPH_50US		0
+#define FM_TX_PREEMPH_75US		2
+
+/* FM TX antenna impedence values */
+#define FM_TX_ANT_IMP_50		0
+#define FM_TX_ANT_IMP_200		1
+#define FM_TX_ANT_IMP_500		2
+
 /* Functions exported by FM common sub-module */
 int fmc_prepare(struct fmdrv_ops *);
 int fmc_release(struct fmdrv_ops *);
-- 
1.5.6.3

