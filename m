Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49497 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754237AbaCCKIO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Mar 2014 05:08:14 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 58/79] [media] drx-j: get rid of tuner dummy get/set frequency
Date: Mon,  3 Mar 2014 07:06:52 -0300
Message-Id: <1393841233-24840-59-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
References: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Those functions will never be used with Linux DVB binding.

Get rid of them.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 .../media/dvb-frontends/drx39xyj/drx39xxj_dummy.c  |  21 --
 drivers/media/dvb-frontends/drx39xyj/drx_driver.h  |   3 -
 drivers/media/dvb-frontends/drx39xyj/drxj.c        | 217 +--------------------
 3 files changed, 3 insertions(+), 238 deletions(-)
 delete mode 100644 drivers/media/dvb-frontends/drx39xyj/drx39xxj_dummy.c

diff --git a/drivers/media/dvb-frontends/drx39xyj/drx39xxj_dummy.c b/drivers/media/dvb-frontends/drx39xyj/drx39xxj_dummy.c
deleted file mode 100644
index 33413cda5290..000000000000
--- a/drivers/media/dvb-frontends/drx39xyj/drx39xxj_dummy.c
+++ /dev/null
@@ -1,21 +0,0 @@
-/* Dummy function to satisfy drxj.c */
-
-#include <linux/types.h>
-#include "drx_driver.h"
-
-
-int drxbsp_tuner_set_frequency(struct tuner_instance *tuner,
-				      u32 mode,
-				      s32 center_frequency)
-{
-	return 0;
-}
-
-int
-drxbsp_tuner_get_frequency(struct tuner_instance *tuner,
-			   u32 mode,
-			  s32 *r_ffrequency,
-			  s32 *i_ffrequency)
-{
-	return 0;
-}
diff --git a/drivers/media/dvb-frontends/drx39xyj/drx_driver.h b/drivers/media/dvb-frontends/drx39xyj/drx_driver.h
index 1aff810b57da..aabd5c56d55b 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx_driver.h
+++ b/drivers/media/dvb-frontends/drx39xyj/drx_driver.h
@@ -1944,8 +1944,6 @@ struct drx_demod_instance {
 	/* type specific demodulator data */
 	struct drx_access_func *my_access_funct;
 				/**< data access protocol functions       */
-	struct tuner_instance *my_tuner;
-				/**< tuner instance,if NULL then baseband */
 	struct i2c_device_addr *my_i2c_dev_addr;
 				/**< i2c address and device identifier    */
 	struct drx_common_attr *my_common_attr;
@@ -2269,7 +2267,6 @@ Access macros
 #define DRX_ATTR_TUNERIFAGCPOL(d)    ((d)->my_common_attr->tuner_if_agc_pol)
 #define DRX_ATTR_TUNERSLOWMODE(d)    ((d)->my_common_attr->tuner_slow_mode)
 #define DRX_ATTR_TUNERSPORTNR(d)     ((d)->my_common_attr->tuner_port_nr)
-#define DRX_ATTR_TUNER(d)           ((d)->my_tuner)
 #define DRX_ATTR_I2CADDR(d)         ((d)->my_i2c_dev_addr->i2c_addr)
 #define DRX_ATTR_I2CDEVID(d)        ((d)->my_i2c_dev_addr->i2c_dev_id)
 #define DRX_ISMCVERTYPE(x) ((x) == AUX_VER_RECORD)
diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.c b/drivers/media/dvb-frontends/drx39xyj/drxj.c
index 08e32d70269a..c9608e627cca 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.c
@@ -945,7 +945,6 @@ struct drx_common_attr drxj_default_comm_attr_g = {
 */
 struct drx_demod_instance drxj_default_demod_g = {
 	&DRXJ_DAP,		/* data access protocol functions */
-	NULL,			/* tuner instance */
 	&drxj_default_addr_g,	/* i2c address & device id */
 	&drxj_default_comm_attr_g,	/* demod common attributes */
 	&drxj_data_g		/* demod device specific attributes */
@@ -16990,16 +16989,12 @@ static int
 ctrl_set_channel(struct drx_demod_instance *demod, struct drx_channel *channel)
 {
 	int rc;
-	s32 tuner_set_freq = 0;
-	s32 tuner_get_freq = 0;
 	s32 tuner_freq_offset = 0;
 	s32 intermediate_freq = 0;
 	struct drxj_data *ext_attr = NULL;
 	struct i2c_device_addr *dev_addr = NULL;
 	enum drx_standard standard = DRX_STANDARD_UNKNOWN;
-	u32 tuner_mode = 0;
 	struct drx_common_attr *common_attr = NULL;
-	bool bridge_closed = false;
 #ifndef DRXJ_VSB_ONLY
 	u32 min_symbol_rate = 0;
 	u32 max_symbol_rate = 0;
@@ -17206,108 +17201,9 @@ ctrl_set_channel(struct drx_demod_instance *demod, struct drx_channel *channel)
 		pr_err("error %d\n", rc);
 		goto rw_error;
 	}
-   /*== Tune, fast mode ======================================================*/
-	if (demod->my_tuner != NULL) {
-		/* Determine tuner mode and freq to tune to ... */
-		switch (standard) {
-#if 0
-		case DRX_STANDARD_NTSC:	/* fallthrough */
-		case DRX_STANDARD_PAL_SECAM_BG:	/* fallthrough */
-		case DRX_STANDARD_PAL_SECAM_DK:	/* fallthrough */
-		case DRX_STANDARD_PAL_SECAM_I:	/* fallthrough */
-		case DRX_STANDARD_PAL_SECAM_L:	/* fallthrough */
-		case DRX_STANDARD_PAL_SECAM_LP:
-			/* expecting center frequency, not picture carrier so no
-			   conversion .... */
-			tuner_mode |= TUNER_MODE_ANALOG;
-			tuner_set_freq = channel->frequency;
-			break;
-		case DRX_STANDARD_FM:
-			/* center frequency (equals sound carrier) as input,
-			   tune to edge of SAW */
-			tuner_mode |= TUNER_MODE_ANALOG;
-			tuner_set_freq =
-			    channel->frequency + DRXJ_FM_CARRIER_FREQ_OFFSET;
-			break;
-#endif
-		case DRX_STANDARD_8VSB:	/* fallthrough */
-#ifndef DRXJ_VSB_ONLY
-		case DRX_STANDARD_ITU_A:	/* fallthrough */
-		case DRX_STANDARD_ITU_B:	/* fallthrough */
-		case DRX_STANDARD_ITU_C:
-#endif
-			tuner_mode |= TUNER_MODE_DIGITAL;
-			tuner_set_freq = channel->frequency;
-			break;
-		case DRX_STANDARD_UNKNOWN:
-		default:
-			return -EIO;
-		}		/* switch(standard) */
 
-		tuner_mode |= TUNER_MODE_SWITCH;
-		switch (channel->bandwidth) {
-		case DRX_BANDWIDTH_8MHZ:
-			tuner_mode |= TUNER_MODE_8MHZ;
-			break;
-		case DRX_BANDWIDTH_7MHZ:
-			tuner_mode |= TUNER_MODE_7MHZ;
-			break;
-		case DRX_BANDWIDTH_6MHZ:
-			tuner_mode |= TUNER_MODE_6MHZ;
-			break;
-		default:
-			/* TODO: for FM which bandwidth to use ?
-			   also check offset from centre frequency ?
-			   For now using 6MHz.
-			 */
-			tuner_mode |= TUNER_MODE_6MHZ;
-			break;
-			/* return (-EINVAL); */
-		}
-
-		/* store bandwidth for GetChannel() */
-		ext_attr->curr_bandwidth = channel->bandwidth;
-		ext_attr->curr_symbol_rate = channel->symbolrate;
-		ext_attr->frequency = tuner_set_freq;
-		if (common_attr->tuner_port_nr == 1) {
-			/* close tuner bridge */
-			bridge_closed = true;
-			rc = ctrl_i2c_bridge(demod, &bridge_closed);
-			if (rc != 0) {
-				pr_err("error %d\n", rc);
-				goto rw_error;
-			}
-			/* set tuner frequency */
-		}
-
-		rc = drxbsp_tuner_set_frequency(demod->my_tuner, tuner_mode, tuner_set_freq);
-		if (rc != 0) {
-			pr_err("error %d\n", rc);
-			goto rw_error;
-		}
-		if (common_attr->tuner_port_nr == 1) {
-			/* open tuner bridge */
-			bridge_closed = false;
-			rc = ctrl_i2c_bridge(demod, &bridge_closed);
-			if (rc != 0) {
-				pr_err("error %d\n", rc);
-				goto rw_error;
-			}
-		}
-
-		/* Get actual frequency set by tuner and compute offset */
-		rc = drxbsp_tuner_get_frequency(demod->my_tuner, 0, &tuner_get_freq, &intermediate_freq);
-		if (rc != 0) {
-			pr_err("error %d\n", rc);
-			goto rw_error;
-		}
-		tuner_freq_offset = tuner_get_freq - tuner_set_freq;
-		common_attr->intermediate_freq = intermediate_freq;
-	} else {
-		/* no tuner instance defined, use fixed intermediate frequency */
-		tuner_freq_offset = 0;
-		intermediate_freq = demod->my_common_attr->intermediate_freq;
-	}			/* if ( demod->my_tuner != NULL ) */
+	tuner_freq_offset = 0;
+	intermediate_freq = demod->my_common_attr->intermediate_freq;
 
    /*== Setup demod for specific standard ====================================*/
 	switch (standard) {
@@ -17362,40 +17258,6 @@ ctrl_set_channel(struct drx_demod_instance *demod, struct drx_channel *channel)
 		return -EIO;
 	}
 
-   /*== Re-tune, slow mode ===================================================*/
-	if (demod->my_tuner != NULL) {
-		/* tune to slow mode */
-		tuner_mode &= ~TUNER_MODE_SWITCH;
-		tuner_mode |= TUNER_MODE_LOCK;
-
-		if (common_attr->tuner_port_nr == 1) {
-			/* close tuner bridge */
-			bridge_closed = true;
-			rc = ctrl_i2c_bridge(demod, &bridge_closed);
-			if (rc != 0) {
-				pr_err("error %d\n", rc);
-				goto rw_error;
-			}
-		}
-
-		/* set tuner frequency */
-		rc = drxbsp_tuner_set_frequency(demod->my_tuner, tuner_mode, tuner_set_freq);
-		if (rc != 0) {
-			pr_err("error %d\n", rc);
-			goto rw_error;
-		}
-		if (common_attr->tuner_port_nr == 1) {
-			/* open tuner bridge */
-			bridge_closed = false;
-			rc = ctrl_i2c_bridge(demod, &bridge_closed);
-			if (rc != 0) {
-				pr_err("error %d\n", rc);
-				goto rw_error;
-			}
-		}
-	}
-
-	/* if ( demod->my_tuner !=NULL ) */
 	/* flag the packet error counter reset */
 	ext_attr->reset_pkt_err_acc = true;
 
@@ -17459,31 +17321,7 @@ ctrl_get_channel(struct drx_demod_instance *demod, struct drx_channel *channel)
 /*   channel->interleaver       = DRX_INTERLEAVER_UNKNOWN;*/
 	channel->ldpc = DRX_LDPC_UNKNOWN;
 
-	if (demod->my_tuner != NULL) {
-		s32 tuner_freq_offset = 0;
-		bool tuner_mirror = common_attr->mirror_freq_spect ? false : true;
-
-		/* Get frequency from tuner */
-		rc = drxbsp_tuner_get_frequency(demod->my_tuner, 0, &(channel->frequency), &intermediate_freq);
-		if (rc != 0) {
-			pr_err("error %d\n", rc);
-			goto rw_error;
-		}
-		tuner_freq_offset = channel->frequency - ext_attr->frequency;
-		if (tuner_mirror) {
-			/* positive image */
-			channel->frequency += tuner_freq_offset;
-		} else {
-			/* negative image */
-			channel->frequency -= tuner_freq_offset;
-		}
-
-		/* Handle sound carrier offset in RF domain */
-		if (standard == DRX_STANDARD_FM)
-			channel->frequency -= DRXJ_FM_CARRIER_FREQ_OFFSET;
-	} else {
-		intermediate_freq = common_attr->intermediate_freq;
-	}
+	intermediate_freq = common_attr->intermediate_freq;
 
 	/* check lock status */
 	rc = ctrl_lock_status(demod, &lock_status);
@@ -19740,33 +19578,6 @@ int drxj_open(struct drx_demod_instance *demod)
 		goto rw_error;
 	}
 
-	/* Open tuner instance */
-	if (demod->my_tuner != NULL) {
-		demod->my_tuner->my_common_attr->my_user_data = (void *)demod;
-
-		if (common_attr->tuner_port_nr == 1) {
-			bool bridge_closed = true;
-			rc = ctrl_i2c_bridge(demod, &bridge_closed);
-			if (rc != 0) {
-				pr_err("error %d\n", rc);
-				goto rw_error;
-			}
-		}
-
-		if (common_attr->tuner_port_nr == 1) {
-			bool bridge_closed = false;
-			rc = ctrl_i2c_bridge(demod, &bridge_closed);
-			if (rc != 0) {
-				pr_err("error %d\n", rc);
-				goto rw_error;
-			}
-		}
-		common_attr->tuner_min_freq_rf =
-		    ((demod->my_tuner)->my_common_attr->min_freq_rf);
-		common_attr->tuner_max_freq_rf =
-		    ((demod->my_tuner)->my_common_attr->max_freq_rf);
-	}
-
 	/* Initialize scan timeout */
 	common_attr->scan_demod_lock_timeout = DRXJ_SCAN_TIMEOUT;
 	common_attr->scan_desired_lock = DRX_LOCKED;
@@ -19830,7 +19641,6 @@ rw_error:
 int drxj_close(struct drx_demod_instance *demod)
 {
 	struct i2c_device_addr *dev_addr = demod->my_i2c_dev_addr;
-	struct drx_common_attr *common_attr = demod->my_common_attr;
 	int rc;
 	enum drx_power_mode power_mode = DRX_POWER_UP;
 
@@ -19849,26 +19659,6 @@ int drxj_close(struct drx_demod_instance *demod)
 		goto rw_error;
 	}
 
-	if (demod->my_tuner != NULL) {
-		/* Check if bridge is used */
-		if (common_attr->tuner_port_nr == 1) {
-			bool bridge_closed = true;
-			rc = ctrl_i2c_bridge(demod, &bridge_closed);
-			if (rc != 0) {
-				pr_err("error %d\n", rc);
-				goto rw_error;
-			}
-		}
-		if (common_attr->tuner_port_nr == 1) {
-			bool bridge_closed = false;
-			rc = ctrl_i2c_bridge(demod, &bridge_closed);
-			if (rc != 0) {
-				pr_err("error %d\n", rc);
-				goto rw_error;
-			}
-		}
-	}
-
 	rc = DRXJ_DAP.write_reg16func(dev_addr, SCU_COMM_EXEC__A, SCU_COMM_EXEC_ACTIVE, 0);
 	if (rc != 0) {
 		pr_err("error %d\n", rc);
@@ -20581,7 +20371,6 @@ struct dvb_frontend *drx39xxj_attach(struct i2c_adapter *i2c)
 	demod->my_common_attr->intermediate_freq = 5000;
 	demod->my_ext_attr = demod_ext_attr;
 	((struct drxj_data *)demod_ext_attr)->uio_sma_tx_mode = DRX_UIO_MODE_READWRITE;
-	demod->my_tuner = NULL;
 	demod->i2c = i2c;
 
 	result = drxj_open(demod);
-- 
1.8.5.3

