Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49351 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754094AbaCCKHz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Mar 2014 05:07:55 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 53/79] [media] drx-j: get rid of the remaining drx generic functions
Date: Mon,  3 Mar 2014 07:06:47 -0300
Message-Id: <1393841233-24840-54-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
References: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Get rid of drx_open and drx_close, as those are just wrapper
functions to drxj_open/drxj_close.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/drx39xyj/drx39xxj.c   |   2 +-
 drivers/media/dvb-frontends/drx39xyj/drx_driver.h |  25 -----
 drivers/media/dvb-frontends/drx39xyj/drxj.c       | 108 +++++-----------------
 3 files changed, 23 insertions(+), 112 deletions(-)

diff --git a/drivers/media/dvb-frontends/drx39xyj/drx39xxj.c b/drivers/media/dvb-frontends/drx39xyj/drx39xxj.c
index 7e316618bfa9..aae9e7c24d5f 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx39xxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drx39xxj.c
@@ -413,7 +413,7 @@ struct dvb_frontend *drx39xxj_attach(struct i2c_adapter *i2c)
 	demod->my_tuner = NULL;
 	demod->i2c = i2c;
 
-	result = drx_open(demod);
+	result = drxj_open(demod);
 	if (result != 0) {
 		pr_err("DRX open failed!  Aborting\n");
 		goto error;
diff --git a/drivers/media/dvb-frontends/drx39xyj/drx_driver.h b/drivers/media/dvb-frontends/drx39xyj/drx_driver.h
index 9ecf01029e90..b9ba48f88523 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx_driver.h
+++ b/drivers/media/dvb-frontends/drx39xyj/drx_driver.h
@@ -2013,28 +2013,11 @@ struct drx_reg_dump {
 
 struct drx_demod_instance;
 
-	typedef int(*drx_open_func_t) (struct drx_demod_instance *demod);
-	typedef int(*drx_close_func_t) (struct drx_demod_instance *demod);
-	typedef int(*drx_ctrl_func_t) (struct drx_demod_instance *demod,
-					     u32 ctrl,
-					     void *ctrl_data);
-
-/**
-* \struct struct drx_demod_func * \brief A stucture containing all functions of a demodulator.
-*/
-	struct drx_demod_func {
-		u32 type_id;		 /**< Device type identifier.      */
-		drx_open_func_t open_func;	 /**< Pointer to Open() function.  */
-		drx_close_func_t close_func;/**< Pointer to Close() function. */
-		drx_ctrl_func_t ctrl_func;	 /**< Pointer to Ctrl() function.  */};
-
 /**
 * \struct struct drx_demod_instance * \brief Top structure of demodulator instance.
 */
 struct drx_demod_instance {
 	/* type specific demodulator data */
-	struct drx_demod_func *my_demod_funct;
-				/**< demodulator functions                */
 	struct drx_access_func *my_access_funct;
 				/**< data access protocol functions       */
 	struct tuner_instance *my_tuner;
@@ -2461,14 +2444,6 @@ Access macros
 #define DRX_ISDVBTSTD(std) ((std) == DRX_STANDARD_DVBT)
 
 /*-------------------------------------------------------------------------
-Exported FUNCTIONS
--------------------------------------------------------------------------*/
-
-	int drx_open(struct drx_demod_instance *demod);
-
-	int drx_close(struct drx_demod_instance *demod);
-
-/*-------------------------------------------------------------------------
 THE END
 -------------------------------------------------------------------------*/
 #endif				/* __DRXDRIVER_H__ */
diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.c b/drivers/media/dvb-frontends/drx39xyj/drxj.c
index 083673525243..9bcd24b77076 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.c
@@ -586,17 +586,6 @@ struct drx_access_func drx_dap_drxj_funct_g = {
 	drxj_dap_read_modify_write_reg32,	/* Not supported   */
 };
 
-/**
-* /var DRXJ_Func_g
-* /brief The driver functions of the drxj
-*/
-struct drx_demod_func drxj_functions_g = {
-	DRXJ_TYPE_ID,
-	drxj_open,
-	drxj_close,
-	drxj_ctrl
-};
-
 struct drxj_data drxj_data_g = {
 	false,			/* has_lna : true if LNA (aka PGA) present      */
 	false,			/* has_oob : true if OOB supported              */
@@ -927,7 +916,6 @@ struct drx_common_attr drxj_default_comm_attr_g = {
 * \brief Default drxj demodulator instance.
 */
 struct drx_demod_instance drxj_default_demod_g = {
-	&drxj_functions_g,	/* demod functions */
 	&DRXJ_DAP,		/* data access protocol functions */
 	NULL,			/* tuner instance */
 	&drxj_default_addr_g,	/* i2c address & device id */
@@ -19822,6 +19810,15 @@ int drxj_open(struct drx_demod_instance *demod)
 	struct drx_cfg_mpeg_output cfg_mpeg_output;
 	int rc;
 
+
+	if ((demod == NULL) ||
+	    (demod->my_common_attr == NULL) ||
+	    (demod->my_ext_attr == NULL) ||
+	    (demod->my_i2c_dev_addr == NULL) ||
+	    (demod->my_common_attr->is_opened)) {
+		return -EINVAL;
+	}
+
 	/* Check arguments */
 	if (demod->my_ext_attr == NULL)
 		return -EINVAL;
@@ -20020,6 +20017,7 @@ int drxj_open(struct drx_demod_instance *demod)
 	/* refresh the audio data structure with default */
 	ext_attr->aud_data = drxj_default_aud_data_g;
 
+	demod->my_common_attr->is_opened = true;
 	return 0;
 rw_error:
 	common_attr->is_opened = false;
@@ -20040,6 +20038,14 @@ int drxj_close(struct drx_demod_instance *demod)
 	int rc;
 	enum drx_power_mode power_mode = DRX_POWER_UP;
 
+	if ((demod == NULL) ||
+	    (demod->my_common_attr == NULL) ||
+	    (demod->my_ext_attr == NULL) ||
+	    (demod->my_i2c_dev_addr == NULL) ||
+	    (!demod->my_common_attr->is_opened)) {
+		return -EINVAL;
+	}
+
 	/* power up */
 	rc = ctrl_power_mode(demod, &power_mode);
 	if (rc != 0) {
@@ -20084,8 +20090,12 @@ int drxj_close(struct drx_demod_instance *demod)
 		goto rw_error;
 	}
 
+	DRX_ATTR_ISOPENED(demod) = false;
+
 	return 0;
 rw_error:
+	DRX_ATTR_ISOPENED(demod) = false;
+
 	return -EIO;
 }
 
@@ -20578,77 +20588,3 @@ release:
 
 	return rc;
 }
-
-/*============================================================================*/
-
-/*
- * Exported functions
- */
-
-/**
- * drx_open - Open a demodulator instance.
- * @demod: A pointer to a demodulator instance.
- *
- * This function returns:
- *	0:		Opened demod instance with succes.
- *	-EIO:		Driver not initialized or unable to initialize
- *			demod.
- *	-EINVAL:	Demod instance has invalid content.
- *
- */
-
-int drx_open(struct drx_demod_instance *demod)
-{
-	int status = 0;
-
-	if ((demod == NULL) ||
-	    (demod->my_demod_funct == NULL) ||
-	    (demod->my_common_attr == NULL) ||
-	    (demod->my_ext_attr == NULL) ||
-	    (demod->my_i2c_dev_addr == NULL) ||
-	    (demod->my_common_attr->is_opened)) {
-		return -EINVAL;
-	}
-
-	status = (*(demod->my_demod_funct->open_func)) (demod);
-
-	if (status == 0)
-		demod->my_common_attr->is_opened = true;
-
-	return status;
-}
-
-/*============================================================================*/
-
-/**
- * drx_close - Close device
- * @demod: A pointer to a demodulator instance.
- *
- * Free resources occupied by device instance.
- * Put device into sleep mode.
- *
- * This function returns:
- *	0:		Closed demod instance with succes.
- *	-EIO:		Driver not initialized or error during close
- *			demod.
- *	-EINVAL:	Demod instance has invalid content.
- */
-int drx_close(struct drx_demod_instance *demod)
-{
-	int status = 0;
-
-	if ((demod == NULL) ||
-	    (demod->my_demod_funct == NULL) ||
-	    (demod->my_common_attr == NULL) ||
-	    (demod->my_ext_attr == NULL) ||
-	    (demod->my_i2c_dev_addr == NULL) ||
-	    (!demod->my_common_attr->is_opened)) {
-		return -EINVAL;
-	}
-
-	status = (*(demod->my_demod_funct->close_func)) (demod);
-
-	DRX_ATTR_ISOPENED(demod) = false;
-
-	return status;
-}
-- 
1.8.5.3

