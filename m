Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49354 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754098AbaCCKHz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Mar 2014 05:07:55 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 52/79] [media] drx-j: get rid of drx_ctrl
Date: Mon,  3 Mar 2014 07:06:46 -0300
Message-Id: <1393841233-24840-53-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
References: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This function is used only as an abstraction layer to call the
two firmware functions. Remove it.

As a bonus, the drx_ctrl_function is now unused and can be
removed.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/drx39xyj/drx39xxj.c   |  24 +--
 drivers/media/dvb-frontends/drx39xyj/drx_driver.h |   3 -
 drivers/media/dvb-frontends/drx39xyj/drxj.c       | 185 ++--------------------
 3 files changed, 28 insertions(+), 184 deletions(-)

diff --git a/drivers/media/dvb-frontends/drx39xyj/drx39xxj.c b/drivers/media/dvb-frontends/drx39xyj/drx39xxj.c
index 7a7a4a87fe25..7e316618bfa9 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx39xxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drx39xxj.c
@@ -45,7 +45,7 @@ static int drx39xxj_set_powerstate(struct dvb_frontend *fe, int enable)
 	else
 		power_mode = DRX_POWER_DOWN;
 
-	result = drx_ctrl(demod, DRX_CTRL_POWER_MODE, &power_mode);
+	result = drxj_ctrl(demod, DRX_CTRL_POWER_MODE, &power_mode);
 	if (result != 0) {
 		pr_err("Power state change failed\n");
 		return 0;
@@ -64,7 +64,7 @@ static int drx39xxj_read_status(struct dvb_frontend *fe, fe_status_t *status)
 
 	*status = 0;
 
-	result = drx_ctrl(demod, DRX_CTRL_LOCK_STATUS, &lock_status);
+	result = drxj_ctrl(demod, DRX_CTRL_LOCK_STATUS, &lock_status);
 	if (result != 0) {
 		pr_err("drx39xxj: could not get lock status!\n");
 		*status = 0;
@@ -109,7 +109,7 @@ static int drx39xxj_read_ber(struct dvb_frontend *fe, u32 *ber)
 	int result;
 	struct drx_sig_quality sig_quality;
 
-	result = drx_ctrl(demod, DRX_CTRL_SIG_QUALITY, &sig_quality);
+	result = drxj_ctrl(demod, DRX_CTRL_SIG_QUALITY, &sig_quality);
 	if (result != 0) {
 		pr_err("drx39xxj: could not get ber!\n");
 		*ber = 0;
@@ -128,7 +128,7 @@ static int drx39xxj_read_signal_strength(struct dvb_frontend *fe,
 	int result;
 	struct drx_sig_quality sig_quality;
 
-	result = drx_ctrl(demod, DRX_CTRL_SIG_QUALITY, &sig_quality);
+	result = drxj_ctrl(demod, DRX_CTRL_SIG_QUALITY, &sig_quality);
 	if (result != 0) {
 		pr_err("drx39xxj: could not get signal strength!\n");
 		*strength = 0;
@@ -147,7 +147,7 @@ static int drx39xxj_read_snr(struct dvb_frontend *fe, u16 *snr)
 	int result;
 	struct drx_sig_quality sig_quality;
 
-	result = drx_ctrl(demod, DRX_CTRL_SIG_QUALITY, &sig_quality);
+	result = drxj_ctrl(demod, DRX_CTRL_SIG_QUALITY, &sig_quality);
 	if (result != 0) {
 		pr_err("drx39xxj: could not read snr!\n");
 		*snr = 0;
@@ -165,7 +165,7 @@ static int drx39xxj_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
 	int result;
 	struct drx_sig_quality sig_quality;
 
-	result = drx_ctrl(demod, DRX_CTRL_SIG_QUALITY, &sig_quality);
+	result = drxj_ctrl(demod, DRX_CTRL_SIG_QUALITY, &sig_quality);
 	if (result != 0) {
 		pr_err("drx39xxj: could not get uc blocks!\n");
 		*ucblocks = 0;
@@ -244,7 +244,7 @@ static int drx39xxj_set_frontend(struct dvb_frontend *fe)
 
 	if (standard != state->current_standard || state->powered_up == 0) {
 		/* Set the standard (will be powered up if necessary */
-		result = drx_ctrl(demod, DRX_CTRL_SET_STANDARD, &standard);
+		result = drxj_ctrl(demod, DRX_CTRL_SET_STANDARD, &standard);
 		if (result != 0) {
 			pr_err("Failed to set standard! result=%02x\n",
 			       result);
@@ -261,7 +261,7 @@ static int drx39xxj_set_frontend(struct dvb_frontend *fe)
 	channel.constellation = constellation;
 
 	/* program channel */
-	result = drx_ctrl(demod, DRX_CTRL_SET_CHANNEL, &channel);
+	result = drxj_ctrl(demod, DRX_CTRL_SET_CHANNEL, &channel);
 	if (result != 0) {
 		pr_err("Failed to set channel!\n");
 		return -EINVAL;
@@ -269,7 +269,7 @@ static int drx39xxj_set_frontend(struct dvb_frontend *fe)
 	/* Just for giggles, let's shut off the LNA again.... */
 	uio_data.uio = DRX_UIO1;
 	uio_data.value = false;
-	result = drx_ctrl(demod, DRX_CTRL_UIO_WRITE, &uio_data);
+	result = drxj_ctrl(demod, DRX_CTRL_UIO_WRITE, &uio_data);
 	if (result != 0) {
 		pr_err("Failed to disable LNA!\n");
 		return 0;
@@ -315,7 +315,7 @@ static int drx39xxj_i2c_gate_ctrl(struct dvb_frontend *fe, int enable)
 		return 0;
 	}
 
-	result = drx_ctrl(demod, DRX_CTRL_I2C_BRIDGE, &i2c_gate_state);
+	result = drxj_ctrl(demod, DRX_CTRL_I2C_BRIDGE, &i2c_gate_state);
 	if (result != 0) {
 		pr_err("drx39xxj: could not open i2c gate [%d]\n",
 		       result);
@@ -423,7 +423,7 @@ struct dvb_frontend *drx39xxj_attach(struct i2c_adapter *i2c)
 	uio_cfg.uio = DRX_UIO1;
 	uio_cfg.mode = DRX_UIO_MODE_READWRITE;
 	/* Configure user-I/O #3: enable read/write */
-	result = drx_ctrl(demod, DRX_CTRL_UIO_CFG, &uio_cfg);
+	result = drxj_ctrl(demod, DRX_CTRL_UIO_CFG, &uio_cfg);
 	if (result) {
 		pr_err("Failed to setup LNA GPIO!\n");
 		goto error;
@@ -431,7 +431,7 @@ struct dvb_frontend *drx39xxj_attach(struct i2c_adapter *i2c)
 
 	uio_data.uio = DRX_UIO1;
 	uio_data.value = false;
-	result = drx_ctrl(demod, DRX_CTRL_UIO_WRITE, &uio_data);
+	result = drxj_ctrl(demod, DRX_CTRL_UIO_WRITE, &uio_data);
 	if (result != 0) {
 		pr_err("Failed to disable LNA!\n");
 		goto error;
diff --git a/drivers/media/dvb-frontends/drx39xyj/drx_driver.h b/drivers/media/dvb-frontends/drx39xyj/drx_driver.h
index 343ae519b5dc..9ecf01029e90 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx_driver.h
+++ b/drivers/media/dvb-frontends/drx39xyj/drx_driver.h
@@ -2468,9 +2468,6 @@ Exported FUNCTIONS
 
 	int drx_close(struct drx_demod_instance *demod);
 
-	int drx_ctrl(struct drx_demod_instance *demod,
-			     u32 ctrl, void *ctrl_data);
-
 /*-------------------------------------------------------------------------
 THE END
 -------------------------------------------------------------------------*/
diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.c b/drivers/media/dvb-frontends/drx39xyj/drxj.c
index cea5b6d66ab7..083673525243 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.c
@@ -19797,6 +19797,10 @@ rw_error:
 /*=============================================================================
 ===== EXPORTED FUNCTIONS ====================================================*/
 
+static int drx_ctrl_u_code(struct drx_demod_instance *demod,
+		       struct drxu_code_info *mc_info,
+		       enum drxu_code_action action);
+
 /**
 * \fn drxj_open()
 * \brief Open the demod instance, configure device, configure drxdriver
@@ -19807,6 +19811,7 @@ rw_error:
 * rely on SCU or AUD ucode to be present.
 *
 */
+
 int drxj_open(struct drx_demod_instance *demod)
 {
 	struct i2c_device_addr *dev_addr = NULL;
@@ -19908,15 +19913,21 @@ int drxj_open(struct drx_demod_instance *demod)
 		common_attr->is_opened = true;
 		ucode_info.mc_file = common_attr->microcode_file;
 
-		rc = drx_ctrl(demod, DRX_CTRL_LOAD_UCODE, &ucode_info);
+		if (DRX_ISPOWERDOWNMODE(demod->my_common_attr->current_power_mode)) {
+			pr_err("Should powerup before loading the firmware.");
+			return -EINVAL;
+		}
+
+		rc = drx_ctrl_u_code(demod, &ucode_info, UCODE_UPLOAD);
 		if (rc != 0) {
-			pr_err("error %d\n", rc);
+			pr_err("error %d while uploading the firmware\n", rc);
 			goto rw_error;
 		}
 		if (common_attr->verify_microcode == true) {
-			rc = drx_ctrl(demod, DRX_CTRL_VERIFY_UCODE, &ucode_info);
+			rc = drx_ctrl_u_code(demod, &ucode_info, UCODE_VERIFY);
 			if (rc != 0) {
-				pr_err("error %d\n", rc);
+				pr_err("error %d while verifying the firmware\n",
+				       rc);
 				goto rw_error;
 			}
 		}
@@ -20454,17 +20465,8 @@ static int drx_ctrl_u_code(struct drx_demod_instance *demod,
 		rc = drx_check_firmware(demod, (u8 *)mc_data_init, size);
 		if (rc)
 			goto release;
-
-		/* After scanning, validate the microcode.
-		   It is also valid if no validation control exists.
-		 */
-		rc = drx_ctrl(demod, DRX_CTRL_VALIDATE_UCODE, NULL);
-		if (rc != 0 && rc != -ENOTSUPP) {
-			pr_err("Validate ucode not supported\n");
-			return rc;
-		}
 		pr_info("Uploading firmware %s\n", mc_file);
-	} else if (action == UCODE_VERIFY) {
+	} else {
 		pr_info("Verifying if firmware upload was ok.\n");
 	}
 
@@ -20579,67 +20581,6 @@ release:
 
 /*============================================================================*/
 
-/**
- * drx_ctrl_version - Build list of version information.
- * @demod: A pointer to a demodulator instance.
- * @version_list: Pointer to linked list of versions.
- *
- * This function returns:
- *	0:		Version information stored in version_list
- *	-EINVAL:	Invalid arguments.
- */
-static int drx_ctrl_version(struct drx_demod_instance *demod,
-			struct drx_version_list **version_list)
-{
-	static char drx_driver_core_module_name[] = "Core driver";
-	static char drx_driver_core_version_text[] =
-	    DRX_VERSIONSTRING(0, 0, 0);
-
-	static struct drx_version drx_driver_core_version;
-	static struct drx_version_list drx_driver_core_version_list;
-
-	struct drx_version_list *demod_version_list = NULL;
-	int return_status = -EIO;
-
-	/* Check arguments */
-	if (version_list == NULL)
-		return -EINVAL;
-
-	/* Get version info list from demod */
-	return_status = (*(demod->my_demod_funct->ctrl_func)) (demod,
-							   DRX_CTRL_VERSION,
-							   (void *)
-							   &demod_version_list);
-
-	/* Always fill in the information of the driver SW . */
-	drx_driver_core_version.module_type = DRX_MODULE_DRIVERCORE;
-	drx_driver_core_version.module_name = drx_driver_core_module_name;
-	drx_driver_core_version.v_major = 0;
-	drx_driver_core_version.v_minor = 0;
-	drx_driver_core_version.v_patch = 0;
-	drx_driver_core_version.v_string = drx_driver_core_version_text;
-
-	drx_driver_core_version_list.version = &drx_driver_core_version;
-	drx_driver_core_version_list.next = (struct drx_version_list *) (NULL);
-
-	if ((return_status == 0) && (demod_version_list != NULL)) {
-		/* Append versioninfo from driver to versioninfo from demod  */
-		/* Return version info in "bottom-up" order. This way, multiple
-		   devices can be handled without using malloc. */
-		struct drx_version_list *current_list_element = demod_version_list;
-		while (current_list_element->next != NULL)
-			current_list_element = current_list_element->next;
-		current_list_element->next = &drx_driver_core_version_list;
-
-		*version_list = demod_version_list;
-	} else {
-		/* Just return versioninfo from driver */
-		*version_list = &drx_driver_core_version_list;
-	}
-
-	return 0;
-}
-
 /*
  * Exported functions
  */
@@ -20711,97 +20652,3 @@ int drx_close(struct drx_demod_instance *demod)
 
 	return status;
 }
-/**
- * drx_ctrl - Control the device.
- * @demod:    A pointer to a demodulator instance.
- * @ctrl:     Reference to desired control function.
- * @ctrl_data: Pointer to data structure for control function.
- *
- * Data needed or returned by the control function is stored in ctrl_data.
- *
- * This function returns:
- *	0:		Control function completed successfully.
- *	-EIO:		Driver not initialized or error during control demod.
- *	-EINVAL:	Demod instance or ctrl_data has invalid content.
- *	-ENOTSUPP:	Specified control function is not available.
- */
-
-int drx_ctrl(struct drx_demod_instance *demod, u32 ctrl, void *ctrl_data)
-{
-	int status = -EIO;
-
-	if ((demod == NULL) ||
-	    (demod->my_demod_funct == NULL) ||
-	    (demod->my_common_attr == NULL) ||
-	    (demod->my_ext_attr == NULL) || (demod->my_i2c_dev_addr == NULL)
-	    ) {
-		return -EINVAL;
-	}
-
-	if (((!demod->my_common_attr->is_opened) &&
-	     (ctrl != DRX_CTRL_PROBE_DEVICE) && (ctrl != DRX_CTRL_VERSION))
-	    ) {
-		return -EINVAL;
-	}
-
-	if ((DRX_ISPOWERDOWNMODE(demod->my_common_attr->current_power_mode) &&
-	     (ctrl != DRX_CTRL_POWER_MODE) &&
-	     (ctrl != DRX_CTRL_PROBE_DEVICE) &&
-	     (ctrl != DRX_CTRL_NOP) && (ctrl != DRX_CTRL_VERSION)
-	    )
-	    ) {
-		return -ENOTSUPP;
-	}
-
-	/* Fixed control functions */
-	switch (ctrl) {
-      /*======================================================================*/
-	case DRX_CTRL_NOP:
-		/* No operation */
-		return 0;
-		break;
-
-      /*======================================================================*/
-	case DRX_CTRL_VERSION:
-		return drx_ctrl_version(demod, (struct drx_version_list **)ctrl_data);
-		break;
-
-      /*======================================================================*/
-	default:
-		/* Do nothing */
-		break;
-	}
-
-	/* Virtual functions */
-	/* First try calling function from derived class */
-	status = (*(demod->my_demod_funct->ctrl_func)) (demod, ctrl, ctrl_data);
-	if (status == -ENOTSUPP) {
-		/* Now try calling a the base class function */
-		switch (ctrl) {
-	 /*===================================================================*/
-		case DRX_CTRL_LOAD_UCODE:
-			return drx_ctrl_u_code(demod,
-					 (struct drxu_code_info *)ctrl_data,
-					 UCODE_UPLOAD);
-			break;
-
-	 /*===================================================================*/
-		case DRX_CTRL_VERIFY_UCODE:
-			{
-				return drx_ctrl_u_code(demod,
-						 (struct drxu_code_info *)ctrl_data,
-						 UCODE_VERIFY);
-			}
-			break;
-
-	 /*===================================================================*/
-		default:
-			pr_err("control %d not supported\n", ctrl);
-			return -ENOTSUPP;
-		}
-	} else {
-		return status;
-	}
-
-	return 0;
-}
\ No newline at end of file
-- 
1.8.5.3

