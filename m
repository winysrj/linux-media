Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49421 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754182AbaCCKIB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Mar 2014 05:08:01 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 72/79] [media] drx-j: be sure to send the powerup command at device open
Date: Mon,  3 Mar 2014 07:07:06 -0300
Message-Id: <1393841233-24840-73-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
References: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As drxj_close puts the device in powerdown, we need to power it up
properly at drxj_open.

This is the behavior noticed at the Windows driver.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/drx39xyj/drxj.c | 39 +++++++++++++++++------------
 1 file changed, 23 insertions(+), 16 deletions(-)

diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.c b/drivers/media/dvb-frontends/drx39xyj/drxj.c
index f48f320d7bf3..97a30057ff09 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.c
@@ -18621,19 +18621,22 @@ ctrl_power_mode(struct drx_demod_instance *demod, enum drx_power_mode *mode)
 		default:
 			return -EIO;
 		}
+		ext_attr->standard = DRX_STANDARD_UNKNOWN;
+	}
 
-		if (*mode != DRXJ_POWER_DOWN_MAIN_PATH) {
-			rc = drxj_dap_write_reg16(dev_addr, SIO_CC_PWD_MODE__A, sio_cc_pwd_mode, 0);
-			if (rc != 0) {
-				pr_err("error %d\n", rc);
-				goto rw_error;
-			}
-			rc = drxj_dap_write_reg16(dev_addr, SIO_CC_UPDATE__A, SIO_CC_UPDATE_KEY, 0);
-			if (rc != 0) {
-				pr_err("error %d\n", rc);
-				goto rw_error;
-			}
+	if (*mode != DRXJ_POWER_DOWN_MAIN_PATH) {
+		rc = drxj_dap_write_reg16(dev_addr, SIO_CC_PWD_MODE__A, sio_cc_pwd_mode, 0);
+		if (rc != 0) {
+			pr_err("error %d\n", rc);
+			goto rw_error;
+		}
+		rc = drxj_dap_write_reg16(dev_addr, SIO_CC_UPDATE__A, SIO_CC_UPDATE_KEY, 0);
+		if (rc != 0) {
+			pr_err("error %d\n", rc);
+			goto rw_error;
+		}
 
+		if ((*mode != DRX_POWER_UP)) {
 			/* Initialize HI, wakeup key especially before put IC to sleep */
 			rc = init_hi(demod);
 			if (rc != 0) {
@@ -18648,14 +18651,13 @@ ctrl_power_mode(struct drx_demod_instance *demod, enum drx_power_mode *mode)
 				goto rw_error;
 			}
 		}
-		ext_attr->standard = DRX_STANDARD_UNKNOWN;
 	}
 
 	common_attr->current_power_mode = *mode;
 
 	return 0;
 rw_error:
-	return -EIO;
+	return rc;
 }
 
 #if 0
@@ -19838,7 +19840,7 @@ int drxj_open(struct drx_demod_instance *demod)
 	struct drxu_code_info ucode_info;
 	struct drx_cfg_mpeg_output cfg_mpeg_output;
 	int rc;
-
+	enum drx_power_mode power_mode = DRX_POWER_UP;
 
 	if ((demod == NULL) ||
 	    (demod->my_common_attr == NULL) ||
@@ -19856,12 +19858,16 @@ int drxj_open(struct drx_demod_instance *demod)
 	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 	common_attr = (struct drx_common_attr *) demod->my_common_attr;
 
-	rc = power_up_device(demod);
+	rc = ctrl_power_mode(demod, &power_mode);
 	if (rc != 0) {
 		pr_err("error %d\n", rc);
 		goto rw_error;
 	}
-	common_attr->current_power_mode = DRX_POWER_UP;
+	if (power_mode != DRX_POWER_UP) {
+		rc = -EINVAL;
+		pr_err("failed to powerup device\n");
+		goto rw_error;
+	}
 
 	/* has to be in front of setIqmAf and setOrxNsuAox */
 	rc = get_device_capabilities(demod);
@@ -20797,6 +20803,7 @@ struct dvb_frontend *drx39xxj_attach(struct i2c_adapter *i2c)
 	demod->my_common_attr->microcode_file = DRX39XX_MAIN_FIRMWARE;
 	demod->my_common_attr->verify_microcode = true;
 	demod->my_common_attr->intermediate_freq = 5000;
+	demod->my_common_attr->current_power_mode = DRX_POWER_DOWN;
 	demod->my_ext_attr = demod_ext_attr;
 	((struct drxj_data *)demod_ext_attr)->uio_sma_tx_mode = DRX_UIO_MODE_READWRITE;
 	demod->i2c = i2c;
-- 
1.8.5.3

