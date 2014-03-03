Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49361 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753750AbaCCKH4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Mar 2014 05:07:56 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 45/79] [media] drx-j: reset the DVB scan configuration at powerup
Date: Mon,  3 Mar 2014 07:06:39 -0300
Message-Id: <1393841233-24840-46-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
References: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Without this fixup, the DRX-J will not be properly initialized,
loosing several PIDs.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/drx39xyj/drxj.c | 151 +++++++++++++++-------------
 1 file changed, 80 insertions(+), 71 deletions(-)

diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.c b/drivers/media/dvb-frontends/drx39xyj/drxj.c
index b90e6c1210f8..b1ad26b9778a 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.c
@@ -18354,6 +18354,81 @@ rw_error:
 
 /*============================================================================*/
 
+static void drxj_reset_mode(struct drxj_data *ext_attr)
+{
+	/* Initialize default AFE configuartion for QAM */
+	if (ext_attr->has_lna) {
+		/* IF AGC off, PGA active */
+#ifndef DRXJ_VSB_ONLY
+		ext_attr->qam_if_agc_cfg.standard = DRX_STANDARD_ITU_B;
+		ext_attr->qam_if_agc_cfg.ctrl_mode = DRX_AGC_CTRL_OFF;
+		ext_attr->qam_pga_cfg = 140 + (11 * 13);
+#endif
+		ext_attr->vsb_if_agc_cfg.standard = DRX_STANDARD_8VSB;
+		ext_attr->vsb_if_agc_cfg.ctrl_mode = DRX_AGC_CTRL_OFF;
+		ext_attr->vsb_pga_cfg = 140 + (11 * 13);
+	} else {
+		/* IF AGC on, PGA not active */
+#ifndef DRXJ_VSB_ONLY
+		ext_attr->qam_if_agc_cfg.standard = DRX_STANDARD_ITU_B;
+		ext_attr->qam_if_agc_cfg.ctrl_mode = DRX_AGC_CTRL_AUTO;
+		ext_attr->qam_if_agc_cfg.min_output_level = 0;
+		ext_attr->qam_if_agc_cfg.max_output_level = 0x7FFF;
+		ext_attr->qam_if_agc_cfg.speed = 3;
+		ext_attr->qam_if_agc_cfg.top = 1297;
+		ext_attr->qam_pga_cfg = 140;
+#endif
+		ext_attr->vsb_if_agc_cfg.standard = DRX_STANDARD_8VSB;
+		ext_attr->vsb_if_agc_cfg.ctrl_mode = DRX_AGC_CTRL_AUTO;
+		ext_attr->vsb_if_agc_cfg.min_output_level = 0;
+		ext_attr->vsb_if_agc_cfg.max_output_level = 0x7FFF;
+		ext_attr->vsb_if_agc_cfg.speed = 3;
+		ext_attr->vsb_if_agc_cfg.top = 1024;
+		ext_attr->vsb_pga_cfg = 140;
+	}
+	/* TODO: remove min_output_level and max_output_level for both QAM and VSB after */
+	/* mc has not used them */
+#ifndef DRXJ_VSB_ONLY
+	ext_attr->qam_rf_agc_cfg.standard = DRX_STANDARD_ITU_B;
+	ext_attr->qam_rf_agc_cfg.ctrl_mode = DRX_AGC_CTRL_AUTO;
+	ext_attr->qam_rf_agc_cfg.min_output_level = 0;
+	ext_attr->qam_rf_agc_cfg.max_output_level = 0x7FFF;
+	ext_attr->qam_rf_agc_cfg.speed = 3;
+	ext_attr->qam_rf_agc_cfg.top = 9500;
+	ext_attr->qam_rf_agc_cfg.cut_off_current = 4000;
+	ext_attr->qam_pre_saw_cfg.standard = DRX_STANDARD_ITU_B;
+	ext_attr->qam_pre_saw_cfg.reference = 0x07;
+	ext_attr->qam_pre_saw_cfg.use_pre_saw = true;
+#endif
+	/* Initialize default AFE configuartion for VSB */
+	ext_attr->vsb_rf_agc_cfg.standard = DRX_STANDARD_8VSB;
+	ext_attr->vsb_rf_agc_cfg.ctrl_mode = DRX_AGC_CTRL_AUTO;
+	ext_attr->vsb_rf_agc_cfg.min_output_level = 0;
+	ext_attr->vsb_rf_agc_cfg.max_output_level = 0x7FFF;
+	ext_attr->vsb_rf_agc_cfg.speed = 3;
+	ext_attr->vsb_rf_agc_cfg.top = 9500;
+	ext_attr->vsb_rf_agc_cfg.cut_off_current = 4000;
+	ext_attr->vsb_pre_saw_cfg.standard = DRX_STANDARD_8VSB;
+	ext_attr->vsb_pre_saw_cfg.reference = 0x07;
+	ext_attr->vsb_pre_saw_cfg.use_pre_saw = true;
+
+#ifndef DRXJ_DIGITAL_ONLY
+	/* Initialize default AFE configuartion for ATV */
+	ext_attr->atv_rf_agc_cfg.standard = DRX_STANDARD_NTSC;
+	ext_attr->atv_rf_agc_cfg.ctrl_mode = DRX_AGC_CTRL_AUTO;
+	ext_attr->atv_rf_agc_cfg.top = 9500;
+	ext_attr->atv_rf_agc_cfg.cut_off_current = 4000;
+	ext_attr->atv_rf_agc_cfg.speed = 3;
+	ext_attr->atv_if_agc_cfg.standard = DRX_STANDARD_NTSC;
+	ext_attr->atv_if_agc_cfg.ctrl_mode = DRX_AGC_CTRL_AUTO;
+	ext_attr->atv_if_agc_cfg.speed = 3;
+	ext_attr->atv_if_agc_cfg.top = 2400;
+	ext_attr->atv_pre_saw_cfg.reference = 0x0007;
+	ext_attr->atv_pre_saw_cfg.use_pre_saw = true;
+	ext_attr->atv_pre_saw_cfg.standard = DRX_STANDARD_NTSC;
+#endif
+}
+
 /**
 * \fn int ctrl_power_mode()
 * \brief Set the power mode of the device to the specified power mode
@@ -18418,6 +18493,9 @@ ctrl_power_mode(struct drx_demod_instance *demod, enum drx_power_mode *mode)
 
 	if ((*mode == DRX_POWER_UP)) {
 		/* Restore analog & pin configuartion */
+
+		/* Initialize default AFE configuartion for VSB */
+		drxj_reset_mode(ext_attr);
 	} else {
 		/* Power down to requested mode */
 		/* Backup some register settings */
@@ -20034,6 +20112,7 @@ rw_error:
 
 /*=============================================================================
 ===== EXPORTED FUNCTIONS ====================================================*/
+
 /**
 * \fn drxj_open()
 * \brief Open the demod instance, configure device, configure drxdriver
@@ -20221,77 +20300,7 @@ int drxj_open(struct drx_demod_instance *demod)
 	common_attr->scan_demod_lock_timeout = DRXJ_SCAN_TIMEOUT;
 	common_attr->scan_desired_lock = DRX_LOCKED;
 
-	/* Initialize default AFE configuartion for QAM */
-	if (ext_attr->has_lna) {
-		/* IF AGC off, PGA active */
-#ifndef DRXJ_VSB_ONLY
-		ext_attr->qam_if_agc_cfg.standard = DRX_STANDARD_ITU_B;
-		ext_attr->qam_if_agc_cfg.ctrl_mode = DRX_AGC_CTRL_OFF;
-		ext_attr->qam_pga_cfg = 140 + (11 * 13);
-#endif
-		ext_attr->vsb_if_agc_cfg.standard = DRX_STANDARD_8VSB;
-		ext_attr->vsb_if_agc_cfg.ctrl_mode = DRX_AGC_CTRL_OFF;
-		ext_attr->vsb_pga_cfg = 140 + (11 * 13);
-	} else {
-		/* IF AGC on, PGA not active */
-#ifndef DRXJ_VSB_ONLY
-		ext_attr->qam_if_agc_cfg.standard = DRX_STANDARD_ITU_B;
-		ext_attr->qam_if_agc_cfg.ctrl_mode = DRX_AGC_CTRL_AUTO;
-		ext_attr->qam_if_agc_cfg.min_output_level = 0;
-		ext_attr->qam_if_agc_cfg.max_output_level = 0x7FFF;
-		ext_attr->qam_if_agc_cfg.speed = 3;
-		ext_attr->qam_if_agc_cfg.top = 1297;
-		ext_attr->qam_pga_cfg = 140;
-#endif
-		ext_attr->vsb_if_agc_cfg.standard = DRX_STANDARD_8VSB;
-		ext_attr->vsb_if_agc_cfg.ctrl_mode = DRX_AGC_CTRL_AUTO;
-		ext_attr->vsb_if_agc_cfg.min_output_level = 0;
-		ext_attr->vsb_if_agc_cfg.max_output_level = 0x7FFF;
-		ext_attr->vsb_if_agc_cfg.speed = 3;
-		ext_attr->vsb_if_agc_cfg.top = 1024;
-		ext_attr->vsb_pga_cfg = 140;
-	}
-	/* TODO: remove min_output_level and max_output_level for both QAM and VSB after */
-	/* mc has not used them */
-#ifndef DRXJ_VSB_ONLY
-	ext_attr->qam_rf_agc_cfg.standard = DRX_STANDARD_ITU_B;
-	ext_attr->qam_rf_agc_cfg.ctrl_mode = DRX_AGC_CTRL_AUTO;
-	ext_attr->qam_rf_agc_cfg.min_output_level = 0;
-	ext_attr->qam_rf_agc_cfg.max_output_level = 0x7FFF;
-	ext_attr->qam_rf_agc_cfg.speed = 3;
-	ext_attr->qam_rf_agc_cfg.top = 9500;
-	ext_attr->qam_rf_agc_cfg.cut_off_current = 4000;
-	ext_attr->qam_pre_saw_cfg.standard = DRX_STANDARD_ITU_B;
-	ext_attr->qam_pre_saw_cfg.reference = 0x07;
-	ext_attr->qam_pre_saw_cfg.use_pre_saw = true;
-#endif
-	/* Initialize default AFE configuartion for VSB */
-	ext_attr->vsb_rf_agc_cfg.standard = DRX_STANDARD_8VSB;
-	ext_attr->vsb_rf_agc_cfg.ctrl_mode = DRX_AGC_CTRL_AUTO;
-	ext_attr->vsb_rf_agc_cfg.min_output_level = 0;
-	ext_attr->vsb_rf_agc_cfg.max_output_level = 0x7FFF;
-	ext_attr->vsb_rf_agc_cfg.speed = 3;
-	ext_attr->vsb_rf_agc_cfg.top = 9500;
-	ext_attr->vsb_rf_agc_cfg.cut_off_current = 4000;
-	ext_attr->vsb_pre_saw_cfg.standard = DRX_STANDARD_8VSB;
-	ext_attr->vsb_pre_saw_cfg.reference = 0x07;
-	ext_attr->vsb_pre_saw_cfg.use_pre_saw = true;
-
-#ifndef DRXJ_DIGITAL_ONLY
-	/* Initialize default AFE configuartion for ATV */
-	ext_attr->atv_rf_agc_cfg.standard = DRX_STANDARD_NTSC;
-	ext_attr->atv_rf_agc_cfg.ctrl_mode = DRX_AGC_CTRL_AUTO;
-	ext_attr->atv_rf_agc_cfg.top = 9500;
-	ext_attr->atv_rf_agc_cfg.cut_off_current = 4000;
-	ext_attr->atv_rf_agc_cfg.speed = 3;
-	ext_attr->atv_if_agc_cfg.standard = DRX_STANDARD_NTSC;
-	ext_attr->atv_if_agc_cfg.ctrl_mode = DRX_AGC_CTRL_AUTO;
-	ext_attr->atv_if_agc_cfg.speed = 3;
-	ext_attr->atv_if_agc_cfg.top = 2400;
-	ext_attr->atv_pre_saw_cfg.reference = 0x0007;
-	ext_attr->atv_pre_saw_cfg.use_pre_saw = true;
-	ext_attr->atv_pre_saw_cfg.standard = DRX_STANDARD_NTSC;
-#endif
+	drxj_reset_mode(ext_attr);
 	ext_attr->standard = DRX_STANDARD_UNKNOWN;
 
 	rc = smart_ant_init(demod);
-- 
1.8.5.3

