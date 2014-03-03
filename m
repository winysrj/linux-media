Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49393 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753835AbaCCKH7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Mar 2014 05:07:59 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 78/79] [media] drx-j: Properly initialize mpeg struct before using it
Date: Mon,  3 Mar 2014 07:07:12 -0300
Message-Id: <1393841233-24840-79-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
References: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The cfg_mpeg_output has more fields than what it is initialized
when the code is called. Be sure to initialize everything before
use, in order to avoid random behaviors.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/drx39xyj/drxj.c | 56 ++++++-----------------------
 1 file changed, 11 insertions(+), 45 deletions(-)

diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.c b/drivers/media/dvb-frontends/drx39xyj/drxj.c
index f7c57c971f8f..8437fd5b8c91 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.c
@@ -2954,20 +2954,6 @@ ctrl_set_cfg_mpeg_output(struct drx_demod_instance *demod, struct drx_cfg_mpeg_o
 		case DRX_STANDARD_ITU_C:
 			break;
 		default:
-			/* not an MPEG producing std, just store MPEG cfg */
-			common_attr->mpeg_cfg.enable_mpeg_output =
-			    cfg_data->enable_mpeg_output;
-			common_attr->mpeg_cfg.insert_rs_byte =
-			    cfg_data->insert_rs_byte;
-			common_attr->mpeg_cfg.enable_parallel =
-			    cfg_data->enable_parallel;
-			common_attr->mpeg_cfg.invert_data = cfg_data->invert_data;
-			common_attr->mpeg_cfg.invert_err = cfg_data->invert_err;
-			common_attr->mpeg_cfg.invert_str = cfg_data->invert_str;
-			common_attr->mpeg_cfg.invert_val = cfg_data->invert_val;
-			common_attr->mpeg_cfg.invert_clk = cfg_data->invert_clk;
-			common_attr->mpeg_cfg.static_clk = cfg_data->static_clk;
-			common_attr->mpeg_cfg.bitrate = cfg_data->bitrate;
 			return 0;
 		}
 
@@ -3215,6 +3201,7 @@ ctrl_set_cfg_mpeg_output(struct drx_demod_instance *demod, struct drx_cfg_mpeg_o
 		else
 			fec_oc_reg_ipr_invert &= (~(FEC_OC_IPR_INVERT_MCLK__M));
 
+
 		if (cfg_data->static_clk == true) {	/* Static mode */
 			u32 dto_rate = 0;
 			u32 bit_rate = 0;
@@ -3546,15 +3533,6 @@ ctrl_set_cfg_mpeg_output(struct drx_demod_instance *demod, struct drx_cfg_mpeg_o
 
 	/* save values for restore after re-acquire */
 	common_attr->mpeg_cfg.enable_mpeg_output = cfg_data->enable_mpeg_output;
-	common_attr->mpeg_cfg.insert_rs_byte = cfg_data->insert_rs_byte;
-	common_attr->mpeg_cfg.enable_parallel = cfg_data->enable_parallel;
-	common_attr->mpeg_cfg.invert_data = cfg_data->invert_data;
-	common_attr->mpeg_cfg.invert_err = cfg_data->invert_err;
-	common_attr->mpeg_cfg.invert_str = cfg_data->invert_str;
-	common_attr->mpeg_cfg.invert_val = cfg_data->invert_val;
-	common_attr->mpeg_cfg.invert_clk = cfg_data->invert_clk;
-	common_attr->mpeg_cfg.static_clk = cfg_data->static_clk;
-	common_attr->mpeg_cfg.bitrate = cfg_data->bitrate;
 
 	return 0;
 rw_error:
@@ -7644,17 +7622,10 @@ static int set_vsb(struct drx_demod_instance *demod)
 		/* TODO: move to set_standard after hardware reset value problem is solved */
 		/* Configure initial MPEG output */
 		struct drx_cfg_mpeg_output cfg_mpeg_output;
+
+		memcpy(&cfg_mpeg_output, &common_attr->mpeg_cfg, sizeof(cfg_mpeg_output));
 		cfg_mpeg_output.enable_mpeg_output = true;
-		cfg_mpeg_output.insert_rs_byte = common_attr->mpeg_cfg.insert_rs_byte;
-		cfg_mpeg_output.enable_parallel =
-		    common_attr->mpeg_cfg.enable_parallel;
-		cfg_mpeg_output.invert_data = common_attr->mpeg_cfg.invert_data;
-		cfg_mpeg_output.invert_err = common_attr->mpeg_cfg.invert_err;
-		cfg_mpeg_output.invert_str = common_attr->mpeg_cfg.invert_str;
-		cfg_mpeg_output.invert_val = common_attr->mpeg_cfg.invert_val;
-		cfg_mpeg_output.invert_clk = common_attr->mpeg_cfg.invert_clk;
-		cfg_mpeg_output.static_clk = common_attr->mpeg_cfg.static_clk;
-		cfg_mpeg_output.bitrate = common_attr->mpeg_cfg.bitrate;
+
 		rc = ctrl_set_cfg_mpeg_output(demod, &cfg_mpeg_output);
 		if (rc != 0) {
 			pr_err("error %d\n", rc);
@@ -8034,6 +8005,7 @@ static int power_down_qam(struct drx_demod_instance *demod, bool primary)
 	int rc;
 	struct i2c_device_addr *dev_addr = demod->my_i2c_dev_addr;
 	struct drx_cfg_mpeg_output cfg_mpeg_output;
+	struct drx_common_attr *common_attr = demod->my_common_attr;
 	u16 cmd_result = 0;
 
 	/*
@@ -8103,7 +8075,9 @@ static int power_down_qam(struct drx_demod_instance *demod, bool primary)
 		}
 	}
 
+	memcpy(&cfg_mpeg_output, &common_attr->mpeg_cfg, sizeof(cfg_mpeg_output));
 	cfg_mpeg_output.enable_mpeg_output = false;
+
 	rc = ctrl_set_cfg_mpeg_output(demod, &cfg_mpeg_output);
 	if (rc != 0) {
 		pr_err("error %d\n", rc);
@@ -10283,19 +10257,9 @@ set_qam(struct drx_demod_instance *demod,
 			/* Configure initial MPEG output */
 			struct drx_cfg_mpeg_output cfg_mpeg_output;
 
+			memcpy(&cfg_mpeg_output, &common_attr->mpeg_cfg, sizeof(cfg_mpeg_output));
 			cfg_mpeg_output.enable_mpeg_output = true;
-			cfg_mpeg_output.insert_rs_byte =
-			    common_attr->mpeg_cfg.insert_rs_byte;
-			cfg_mpeg_output.enable_parallel =
-			    common_attr->mpeg_cfg.enable_parallel;
-			cfg_mpeg_output.invert_data =
-			    common_attr->mpeg_cfg.invert_data;
-			cfg_mpeg_output.invert_err = common_attr->mpeg_cfg.invert_err;
-			cfg_mpeg_output.invert_str = common_attr->mpeg_cfg.invert_str;
-			cfg_mpeg_output.invert_val = common_attr->mpeg_cfg.invert_val;
-			cfg_mpeg_output.invert_clk = common_attr->mpeg_cfg.invert_clk;
-			cfg_mpeg_output.static_clk = common_attr->mpeg_cfg.static_clk;
-			cfg_mpeg_output.bitrate = common_attr->mpeg_cfg.bitrate;
+
 			rc = ctrl_set_cfg_mpeg_output(demod, &cfg_mpeg_output);
 			if (rc != 0) {
 				pr_err("error %d\n", rc);
@@ -19930,7 +19894,9 @@ int drxj_open(struct drx_demod_instance *demod)
 	}
 
 	/* disable mpegoutput pins */
+	memcpy(&cfg_mpeg_output, &common_attr->mpeg_cfg, sizeof(cfg_mpeg_output));
 	cfg_mpeg_output.enable_mpeg_output = false;
+
 	rc = ctrl_set_cfg_mpeg_output(demod, &cfg_mpeg_output);
 	if (rc != 0) {
 		pr_err("error %d\n", rc);
-- 
1.8.5.3

