Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4300 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752428Ab3D1Pr6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Apr 2013 11:47:58 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r3SFlw1g013731
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 28 Apr 2013 11:47:58 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 8/9] [media] drxk_hard: remove needless parenthesis
Date: Sun, 28 Apr 2013 12:47:50 -0300
Message-Id: <1367164071-11468-9-git-send-email-mchehab@redhat.com>
In-Reply-To: <1367164071-11468-1-git-send-email-mchehab@redhat.com>
References: <1367164071-11468-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are several places where: state->var = (some_var)

The parenthesis there are doing nothing but making it
harder to read and breaking the 80 columns soft limits.

Just get rid of it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb-frontends/drxk_hard.c | 50 ++++++++++++++++-----------------
 1 file changed, 25 insertions(+), 25 deletions(-)

diff --git a/drivers/media/dvb-frontends/drxk_hard.c b/drivers/media/dvb-frontends/drxk_hard.c
index 1fd74f2..7f4b514 100644
--- a/drivers/media/dvb-frontends/drxk_hard.c
+++ b/drivers/media/dvb-frontends/drxk_hard.c
@@ -628,21 +628,21 @@ static int init_state(struct drxk_state *state)
 
 	/* Init AGC and PGA parameters */
 	/* VSB IF */
-	state->m_vsb_if_agc_cfg.ctrl_mode = (ul_vsb_if_agc_mode);
-	state->m_vsb_if_agc_cfg.output_level = (ul_vsb_if_agc_output_level);
-	state->m_vsb_if_agc_cfg.min_output_level = (ul_vsb_if_agc_min_level);
-	state->m_vsb_if_agc_cfg.max_output_level = (ul_vsb_if_agc_max_level);
-	state->m_vsb_if_agc_cfg.speed = (ul_vsb_if_agc_speed);
+	state->m_vsb_if_agc_cfg.ctrl_mode = ul_vsb_if_agc_mode;
+	state->m_vsb_if_agc_cfg.output_level = ul_vsb_if_agc_output_level;
+	state->m_vsb_if_agc_cfg.min_output_level = ul_vsb_if_agc_min_level;
+	state->m_vsb_if_agc_cfg.max_output_level = ul_vsb_if_agc_max_level;
+	state->m_vsb_if_agc_cfg.speed = ul_vsb_if_agc_speed;
 	state->m_vsb_pga_cfg = 140;
 
 	/* VSB RF */
-	state->m_vsb_rf_agc_cfg.ctrl_mode = (ul_vsb_rf_agc_mode);
-	state->m_vsb_rf_agc_cfg.output_level = (ul_vsb_rf_agc_output_level);
-	state->m_vsb_rf_agc_cfg.min_output_level = (ul_vsb_rf_agc_min_level);
-	state->m_vsb_rf_agc_cfg.max_output_level = (ul_vsb_rf_agc_max_level);
-	state->m_vsb_rf_agc_cfg.speed = (ul_vsb_rf_agc_speed);
-	state->m_vsb_rf_agc_cfg.top = (ul_vsb_rf_agc_top);
-	state->m_vsb_rf_agc_cfg.cut_off_current = (ul_vsb_rf_agc_cut_off_current);
+	state->m_vsb_rf_agc_cfg.ctrl_mode = ul_vsb_rf_agc_mode;
+	state->m_vsb_rf_agc_cfg.output_level = ul_vsb_rf_agc_output_level;
+	state->m_vsb_rf_agc_cfg.min_output_level = ul_vsb_rf_agc_min_level;
+	state->m_vsb_rf_agc_cfg.max_output_level = ul_vsb_rf_agc_max_level;
+	state->m_vsb_rf_agc_cfg.speed = ul_vsb_rf_agc_speed;
+	state->m_vsb_rf_agc_cfg.top = ul_vsb_rf_agc_top;
+	state->m_vsb_rf_agc_cfg.cut_off_current = ul_vsb_rf_agc_cut_off_current;
 	state->m_vsb_pre_saw_cfg.reference = 0x07;
 	state->m_vsb_pre_saw_cfg.use_pre_saw = true;
 
@@ -654,20 +654,20 @@ static int init_state(struct drxk_state *state)
 	}
 
 	/* ATV IF */
-	state->m_atv_if_agc_cfg.ctrl_mode = (ul_atv_if_agc_mode);
-	state->m_atv_if_agc_cfg.output_level = (ul_atv_if_agc_output_level);
-	state->m_atv_if_agc_cfg.min_output_level = (ul_atv_if_agc_min_level);
-	state->m_atv_if_agc_cfg.max_output_level = (ul_atv_if_agc_max_level);
-	state->m_atv_if_agc_cfg.speed = (ul_atv_if_agc_speed);
+	state->m_atv_if_agc_cfg.ctrl_mode = ul_atv_if_agc_mode;
+	state->m_atv_if_agc_cfg.output_level = ul_atv_if_agc_output_level;
+	state->m_atv_if_agc_cfg.min_output_level = ul_atv_if_agc_min_level;
+	state->m_atv_if_agc_cfg.max_output_level = ul_atv_if_agc_max_level;
+	state->m_atv_if_agc_cfg.speed = ul_atv_if_agc_speed;
 
 	/* ATV RF */
-	state->m_atv_rf_agc_cfg.ctrl_mode = (ul_atv_rf_agc_mode);
-	state->m_atv_rf_agc_cfg.output_level = (ul_atv_rf_agc_output_level);
-	state->m_atv_rf_agc_cfg.min_output_level = (ul_atv_rf_agc_min_level);
-	state->m_atv_rf_agc_cfg.max_output_level = (ul_atv_rf_agc_max_level);
-	state->m_atv_rf_agc_cfg.speed = (ul_atv_rf_agc_speed);
-	state->m_atv_rf_agc_cfg.top = (ul_atv_rf_agc_top);
-	state->m_atv_rf_agc_cfg.cut_off_current = (ul_atv_rf_agc_cut_off_current);
+	state->m_atv_rf_agc_cfg.ctrl_mode = ul_atv_rf_agc_mode;
+	state->m_atv_rf_agc_cfg.output_level = ul_atv_rf_agc_output_level;
+	state->m_atv_rf_agc_cfg.min_output_level = ul_atv_rf_agc_min_level;
+	state->m_atv_rf_agc_cfg.max_output_level = ul_atv_rf_agc_max_level;
+	state->m_atv_rf_agc_cfg.speed = ul_atv_rf_agc_speed;
+	state->m_atv_rf_agc_cfg.top = ul_atv_rf_agc_top;
+	state->m_atv_rf_agc_cfg.cut_off_current = ul_atv_rf_agc_cut_off_current;
 	state->m_atv_pre_saw_cfg.reference = 0x04;
 	state->m_atv_pre_saw_cfg.use_pre_saw = true;
 
@@ -764,7 +764,7 @@ static int init_state(struct drxk_state *state)
 	state->m_sqi_speed = DRXK_DVBT_SQI_SPEED_MEDIUM;
 	state->m_agcfast_clip_ctrl_delay = 0;
 
-	state->m_gpio_cfg = (ul_gpio_cfg);
+	state->m_gpio_cfg = ul_gpio_cfg;
 
 	state->m_b_power_down = false;
 	state->m_current_power_mode = DRX_POWER_DOWN;
-- 
1.8.1.4

