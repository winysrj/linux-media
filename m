Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49344 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754076AbaCCKHy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Mar 2014 05:07:54 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 54/79] [media] drx-j: move drx39xxj into drxj.c
Date: Mon,  3 Mar 2014 07:06:48 -0300
Message-Id: <1393841233-24840-55-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
References: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While drxj is already too big, moving the code there will
make easier to get rid of the drxj_ctrl function.

It will also help to detect and remove the unused functions,
helping to remove lots of dead code there.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/drx39xyj/Makefile   |   2 +-
 drivers/media/dvb-frontends/drx39xyj/drx39xxj.c | 484 ------------------------
 drivers/media/dvb-frontends/drx39xyj/drxj.c     | 484 ++++++++++++++++++++++++
 3 files changed, 485 insertions(+), 485 deletions(-)
 delete mode 100644 drivers/media/dvb-frontends/drx39xyj/drx39xxj.c

diff --git a/drivers/media/dvb-frontends/drx39xyj/Makefile b/drivers/media/dvb-frontends/drx39xyj/Makefile
index d9ed094e0d18..7f073d4c28ec 100644
--- a/drivers/media/dvb-frontends/drx39xyj/Makefile
+++ b/drivers/media/dvb-frontends/drx39xyj/Makefile
@@ -1,4 +1,4 @@
-drx39xyj-objs := drx39xxj.o drx39xxj_dummy.o drxj.o drx_dap_fasi.o
+drx39xyj-objs := drx39xxj_dummy.o drxj.o drx_dap_fasi.o
 
 obj-$(CONFIG_DVB_DRX39XYJ) += drx39xyj.o
 
diff --git a/drivers/media/dvb-frontends/drx39xyj/drx39xxj.c b/drivers/media/dvb-frontends/drx39xyj/drx39xxj.c
deleted file mode 100644
index aae9e7c24d5f..000000000000
--- a/drivers/media/dvb-frontends/drx39xyj/drx39xxj.c
+++ /dev/null
@@ -1,484 +0,0 @@
-/*
- *  Driver for Micronas DRX39xx family (drx3933j)
- *
- *  Written by Devin Heitmueller <devin.heitmueller@kernellabs.com>
- *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation; either version 2 of the License, or
- *  (at your option) any later version.
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *
- *  GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.=
- */
-
-#define pr_fmt(fmt) KBUILD_MODNAME ":%s: " fmt, __func__
-
-#include <linux/module.h>
-#include <linux/init.h>
-#include <linux/string.h>
-#include <linux/slab.h>
-
-#include "dvb_frontend.h"
-#include "drx39xxj.h"
-#include "drx_driver.h"
-#include "drxj.h"
-
-#define DRX39XX_MAIN_FIRMWARE "dvb-fe-drxj-mc-1.0.8.fw"
-
-static int drx39xxj_set_powerstate(struct dvb_frontend *fe, int enable)
-{
-	struct drx39xxj_state *state = fe->demodulator_priv;
-	struct drx_demod_instance *demod = state->demod;
-	int result;
-	enum drx_power_mode power_mode;
-
-	if (enable)
-		power_mode = DRX_POWER_UP;
-	else
-		power_mode = DRX_POWER_DOWN;
-
-	result = drxj_ctrl(demod, DRX_CTRL_POWER_MODE, &power_mode);
-	if (result != 0) {
-		pr_err("Power state change failed\n");
-		return 0;
-	}
-
-	state->powered_up = enable;
-	return 0;
-}
-
-static int drx39xxj_read_status(struct dvb_frontend *fe, fe_status_t *status)
-{
-	struct drx39xxj_state *state = fe->demodulator_priv;
-	struct drx_demod_instance *demod = state->demod;
-	int result;
-	enum drx_lock_status lock_status;
-
-	*status = 0;
-
-	result = drxj_ctrl(demod, DRX_CTRL_LOCK_STATUS, &lock_status);
-	if (result != 0) {
-		pr_err("drx39xxj: could not get lock status!\n");
-		*status = 0;
-	}
-
-	switch (lock_status) {
-	case DRX_NEVER_LOCK:
-		*status = 0;
-		pr_err("drx says NEVER_LOCK\n");
-		break;
-	case DRX_NOT_LOCKED:
-		*status = 0;
-		break;
-	case DRX_LOCK_STATE_1:
-	case DRX_LOCK_STATE_2:
-	case DRX_LOCK_STATE_3:
-	case DRX_LOCK_STATE_4:
-	case DRX_LOCK_STATE_5:
-	case DRX_LOCK_STATE_6:
-	case DRX_LOCK_STATE_7:
-	case DRX_LOCK_STATE_8:
-	case DRX_LOCK_STATE_9:
-		*status = FE_HAS_SIGNAL
-		    | FE_HAS_CARRIER | FE_HAS_VITERBI | FE_HAS_SYNC;
-		break;
-	case DRX_LOCKED:
-		*status = FE_HAS_SIGNAL
-		    | FE_HAS_CARRIER
-		    | FE_HAS_VITERBI | FE_HAS_SYNC | FE_HAS_LOCK;
-		break;
-	default:
-		pr_err("Lock state unknown %d\n", lock_status);
-	}
-
-	return 0;
-}
-
-static int drx39xxj_read_ber(struct dvb_frontend *fe, u32 *ber)
-{
-	struct drx39xxj_state *state = fe->demodulator_priv;
-	struct drx_demod_instance *demod = state->demod;
-	int result;
-	struct drx_sig_quality sig_quality;
-
-	result = drxj_ctrl(demod, DRX_CTRL_SIG_QUALITY, &sig_quality);
-	if (result != 0) {
-		pr_err("drx39xxj: could not get ber!\n");
-		*ber = 0;
-		return 0;
-	}
-
-	*ber = sig_quality.post_reed_solomon_ber;
-	return 0;
-}
-
-static int drx39xxj_read_signal_strength(struct dvb_frontend *fe,
-					 u16 *strength)
-{
-	struct drx39xxj_state *state = fe->demodulator_priv;
-	struct drx_demod_instance *demod = state->demod;
-	int result;
-	struct drx_sig_quality sig_quality;
-
-	result = drxj_ctrl(demod, DRX_CTRL_SIG_QUALITY, &sig_quality);
-	if (result != 0) {
-		pr_err("drx39xxj: could not get signal strength!\n");
-		*strength = 0;
-		return 0;
-	}
-
-	/* 1-100% scaled to 0-65535 */
-	*strength = (sig_quality.indicator * 65535 / 100);
-	return 0;
-}
-
-static int drx39xxj_read_snr(struct dvb_frontend *fe, u16 *snr)
-{
-	struct drx39xxj_state *state = fe->demodulator_priv;
-	struct drx_demod_instance *demod = state->demod;
-	int result;
-	struct drx_sig_quality sig_quality;
-
-	result = drxj_ctrl(demod, DRX_CTRL_SIG_QUALITY, &sig_quality);
-	if (result != 0) {
-		pr_err("drx39xxj: could not read snr!\n");
-		*snr = 0;
-		return 0;
-	}
-
-	*snr = sig_quality.MER;
-	return 0;
-}
-
-static int drx39xxj_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
-{
-	struct drx39xxj_state *state = fe->demodulator_priv;
-	struct drx_demod_instance *demod = state->demod;
-	int result;
-	struct drx_sig_quality sig_quality;
-
-	result = drxj_ctrl(demod, DRX_CTRL_SIG_QUALITY, &sig_quality);
-	if (result != 0) {
-		pr_err("drx39xxj: could not get uc blocks!\n");
-		*ucblocks = 0;
-		return 0;
-	}
-
-	*ucblocks = sig_quality.packet_error;
-	return 0;
-}
-
-static int drx39xxj_set_frontend(struct dvb_frontend *fe)
-{
-#ifdef DJH_DEBUG
-	int i;
-#endif
-	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
-	struct drx39xxj_state *state = fe->demodulator_priv;
-	struct drx_demod_instance *demod = state->demod;
-	enum drx_standard standard = DRX_STANDARD_8VSB;
-	struct drx_channel channel;
-	int result;
-	struct drxuio_data uio_data;
-	static const struct drx_channel def_channel = {
-		/* frequency      */ 0,
-		/* bandwidth      */ DRX_BANDWIDTH_6MHZ,
-		/* mirror         */ DRX_MIRROR_NO,
-		/* constellation  */ DRX_CONSTELLATION_AUTO,
-		/* hierarchy      */ DRX_HIERARCHY_UNKNOWN,
-		/* priority       */ DRX_PRIORITY_UNKNOWN,
-		/* coderate       */ DRX_CODERATE_UNKNOWN,
-		/* guard          */ DRX_GUARD_UNKNOWN,
-		/* fftmode        */ DRX_FFTMODE_UNKNOWN,
-		/* classification */ DRX_CLASSIFICATION_AUTO,
-		/* symbolrate     */ 5057000,
-		/* interleavemode */ DRX_INTERLEAVEMODE_UNKNOWN,
-		/* ldpc           */ DRX_LDPC_UNKNOWN,
-		/* carrier        */ DRX_CARRIER_UNKNOWN,
-		/* frame mode     */ DRX_FRAMEMODE_UNKNOWN
-	};
-	u32 constellation = DRX_CONSTELLATION_AUTO;
-
-	/* Bring the demod out of sleep */
-	drx39xxj_set_powerstate(fe, 1);
-
-	/* Now make the tuner do it's thing... */
-	if (fe->ops.tuner_ops.set_params) {
-		if (fe->ops.i2c_gate_ctrl)
-			fe->ops.i2c_gate_ctrl(fe, 1);
-		fe->ops.tuner_ops.set_params(fe);
-		if (fe->ops.i2c_gate_ctrl)
-			fe->ops.i2c_gate_ctrl(fe, 0);
-	}
-
-	switch (p->delivery_system) {
-	case SYS_ATSC:
-		standard = DRX_STANDARD_8VSB;
-		break;
-	case SYS_DVBC_ANNEX_B:
-		standard = DRX_STANDARD_ITU_B;
-
-		switch (p->modulation) {
-		case QAM_64:
-			constellation = DRX_CONSTELLATION_QAM64;
-			break;
-		case QAM_256:
-			constellation = DRX_CONSTELLATION_QAM256;
-			break;
-		default:
-			constellation = DRX_CONSTELLATION_AUTO;
-			break;
-		}
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	if (standard != state->current_standard || state->powered_up == 0) {
-		/* Set the standard (will be powered up if necessary */
-		result = drxj_ctrl(demod, DRX_CTRL_SET_STANDARD, &standard);
-		if (result != 0) {
-			pr_err("Failed to set standard! result=%02x\n",
-			       result);
-			return -EINVAL;
-		}
-		state->powered_up = 1;
-		state->current_standard = standard;
-	}
-
-	/* set channel parameters */
-	channel = def_channel;
-	channel.frequency = p->frequency / 1000;
-	channel.bandwidth = DRX_BANDWIDTH_6MHZ;
-	channel.constellation = constellation;
-
-	/* program channel */
-	result = drxj_ctrl(demod, DRX_CTRL_SET_CHANNEL, &channel);
-	if (result != 0) {
-		pr_err("Failed to set channel!\n");
-		return -EINVAL;
-	}
-	/* Just for giggles, let's shut off the LNA again.... */
-	uio_data.uio = DRX_UIO1;
-	uio_data.value = false;
-	result = drxj_ctrl(demod, DRX_CTRL_UIO_WRITE, &uio_data);
-	if (result != 0) {
-		pr_err("Failed to disable LNA!\n");
-		return 0;
-	}
-#ifdef DJH_DEBUG
-	for (i = 0; i < 2000; i++) {
-		fe_status_t status;
-		drx39xxj_read_status(fe, &status);
-		pr_dbg("i=%d status=%d\n", i, status);
-		msleep(100);
-		i += 100;
-	}
-#endif
-
-	return 0;
-}
-
-static int drx39xxj_sleep(struct dvb_frontend *fe)
-{
-	/* power-down the demodulator */
-	return drx39xxj_set_powerstate(fe, 0);
-}
-
-static int drx39xxj_i2c_gate_ctrl(struct dvb_frontend *fe, int enable)
-{
-	struct drx39xxj_state *state = fe->demodulator_priv;
-	struct drx_demod_instance *demod = state->demod;
-	bool i2c_gate_state;
-	int result;
-
-#ifdef DJH_DEBUG
-	pr_dbg("i2c gate call: enable=%d state=%d\n", enable,
-	       state->i2c_gate_open);
-#endif
-
-	if (enable)
-		i2c_gate_state = true;
-	else
-		i2c_gate_state = false;
-
-	if (state->i2c_gate_open == enable) {
-		/* We're already in the desired state */
-		return 0;
-	}
-
-	result = drxj_ctrl(demod, DRX_CTRL_I2C_BRIDGE, &i2c_gate_state);
-	if (result != 0) {
-		pr_err("drx39xxj: could not open i2c gate [%d]\n",
-		       result);
-		dump_stack();
-	} else {
-		state->i2c_gate_open = enable;
-	}
-	return 0;
-}
-
-static int drx39xxj_init(struct dvb_frontend *fe)
-{
-	/* Bring the demod out of sleep */
-	drx39xxj_set_powerstate(fe, 1);
-
-	return 0;
-}
-
-static int drx39xxj_get_tune_settings(struct dvb_frontend *fe,
-				      struct dvb_frontend_tune_settings *tune)
-{
-	tune->min_delay_ms = 1000;
-	return 0;
-}
-
-static void drx39xxj_release(struct dvb_frontend *fe)
-{
-	struct drx39xxj_state *state = fe->demodulator_priv;
-	struct drx_demod_instance *demod = state->demod;
-
-	kfree(demod->my_ext_attr);
-	kfree(demod->my_common_attr);
-	kfree(demod->my_i2c_dev_addr);
-	if (demod->firmware)
-		release_firmware(demod->firmware);
-	kfree(demod);
-	kfree(state);
-}
-
-static struct dvb_frontend_ops drx39xxj_ops;
-
-struct dvb_frontend *drx39xxj_attach(struct i2c_adapter *i2c)
-{
-	struct drx39xxj_state *state = NULL;
-
-	struct i2c_device_addr *demod_addr = NULL;
-	struct drx_common_attr *demod_comm_attr = NULL;
-	struct drxj_data *demod_ext_attr = NULL;
-	struct drx_demod_instance *demod = NULL;
-	struct drxuio_cfg uio_cfg;
-	struct drxuio_data uio_data;
-	int result;
-
-	/* allocate memory for the internal state */
-	state = kzalloc(sizeof(struct drx39xxj_state), GFP_KERNEL);
-	if (state == NULL)
-		goto error;
-
-	demod = kmalloc(sizeof(struct drx_demod_instance), GFP_KERNEL);
-	if (demod == NULL)
-		goto error;
-
-	demod_addr = kmalloc(sizeof(struct i2c_device_addr), GFP_KERNEL);
-	if (demod_addr == NULL)
-		goto error;
-	memcpy(demod_addr, &drxj_default_addr_g,
-	       sizeof(struct i2c_device_addr));
-
-	demod_comm_attr = kmalloc(sizeof(struct drx_common_attr), GFP_KERNEL);
-	if (demod_comm_attr == NULL)
-		goto error;
-	memcpy(demod_comm_attr, &drxj_default_comm_attr_g,
-	       sizeof(struct drx_common_attr));
-
-	demod_ext_attr = kmalloc(sizeof(struct drxj_data), GFP_KERNEL);
-	if (demod_ext_attr == NULL)
-		goto error;
-	memcpy(demod_ext_attr, &drxj_data_g, sizeof(struct drxj_data));
-
-	/* setup the state */
-	state->i2c = i2c;
-	state->demod = demod;
-
-	/* setup the demod data */
-	memcpy(demod, &drxj_default_demod_g, sizeof(struct drx_demod_instance));
-
-	demod->my_i2c_dev_addr = demod_addr;
-	demod->my_common_attr = demod_comm_attr;
-	demod->my_i2c_dev_addr->user_data = state;
-	demod->my_common_attr->microcode_file = DRX39XX_MAIN_FIRMWARE;
-	demod->my_common_attr->verify_microcode = true;
-	demod->my_common_attr->intermediate_freq = 5000;
-	demod->my_ext_attr = demod_ext_attr;
-	((struct drxj_data *)demod_ext_attr)->uio_sma_tx_mode = DRX_UIO_MODE_READWRITE;
-	demod->my_tuner = NULL;
-	demod->i2c = i2c;
-
-	result = drxj_open(demod);
-	if (result != 0) {
-		pr_err("DRX open failed!  Aborting\n");
-		goto error;
-	}
-
-	/* Turn off the LNA */
-	uio_cfg.uio = DRX_UIO1;
-	uio_cfg.mode = DRX_UIO_MODE_READWRITE;
-	/* Configure user-I/O #3: enable read/write */
-	result = drxj_ctrl(demod, DRX_CTRL_UIO_CFG, &uio_cfg);
-	if (result) {
-		pr_err("Failed to setup LNA GPIO!\n");
-		goto error;
-	}
-
-	uio_data.uio = DRX_UIO1;
-	uio_data.value = false;
-	result = drxj_ctrl(demod, DRX_CTRL_UIO_WRITE, &uio_data);
-	if (result != 0) {
-		pr_err("Failed to disable LNA!\n");
-		goto error;
-	}
-
-	/* create dvb_frontend */
-	memcpy(&state->frontend.ops, &drx39xxj_ops,
-	       sizeof(struct dvb_frontend_ops));
-
-	state->frontend.demodulator_priv = state;
-	return &state->frontend;
-
-error:
-	kfree(demod_ext_attr);
-	kfree(demod_comm_attr);
-	kfree(demod_addr);
-	kfree(demod);
-	kfree(state);
-
-	return NULL;
-}
-EXPORT_SYMBOL(drx39xxj_attach);
-
-static struct dvb_frontend_ops drx39xxj_ops = {
-	.delsys = { SYS_ATSC, SYS_DVBC_ANNEX_B },
-	.info = {
-		 .name = "Micronas DRX39xxj family Frontend",
-		 .frequency_stepsize = 62500,
-		 .frequency_min = 51000000,
-		 .frequency_max = 858000000,
-		 .caps = FE_CAN_QAM_64 | FE_CAN_QAM_256 | FE_CAN_8VSB
-	},
-
-	.init = drx39xxj_init,
-	.i2c_gate_ctrl = drx39xxj_i2c_gate_ctrl,
-	.sleep = drx39xxj_sleep,
-	.set_frontend = drx39xxj_set_frontend,
-	.get_tune_settings = drx39xxj_get_tune_settings,
-	.read_status = drx39xxj_read_status,
-	.read_ber = drx39xxj_read_ber,
-	.read_signal_strength = drx39xxj_read_signal_strength,
-	.read_snr = drx39xxj_read_snr,
-	.read_ucblocks = drx39xxj_read_ucblocks,
-	.release = drx39xxj_release,
-};
-
-MODULE_DESCRIPTION("Micronas DRX39xxj Frontend");
-MODULE_AUTHOR("Devin Heitmueller");
-MODULE_LICENSE("GPL");
-MODULE_FIRMWARE(DRX39XX_MAIN_FIRMWARE);
diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.c b/drivers/media/dvb-frontends/drx39xyj/drxj.c
index 9bcd24b77076..635698990e28 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.c
@@ -29,6 +29,24 @@
 
   DRXJ specific implementation of DRX driver
   authors: Dragan Savic, Milos Nikolic, Mihajlo Katona, Tao Ding, Paul Janssen
+
+  The Linux DVB Driver for Micronas DRX39xx family (drx3933j) was
+  written by Devin Heitmueller <devin.heitmueller@kernellabs.com>
+
+  This program is free software; you can redistribute it and/or modify
+  it under the terms of the GNU General Public License as published by
+  the Free Software Foundation; either version 2 of the License, or
+  (at your option) any later version.
+
+  This program is distributed in the hope that it will be useful,
+  but WITHOUT ANY WARRANTY; without even the implied warranty of
+  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+
+  GNU General Public License for more details.
+
+  You should have received a copy of the GNU General Public License
+  along with this program; if not, write to the Free Software
+  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */
 
 /*-----------------------------------------------------------------------------
@@ -37,6 +55,14 @@ INCLUDE FILES
 
 #define pr_fmt(fmt) KBUILD_MODNAME ":%s: " fmt, __func__
 
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/string.h>
+#include <linux/slab.h>
+
+#include "dvb_frontend.h"
+#include "drx39xxj.h"
+
 #include "drxj.h"
 #include "drxj_map.h"
 
@@ -44,6 +70,8 @@ INCLUDE FILES
 /*=== DEFINES ================================================================*/
 /*============================================================================*/
 
+#define DRX39XX_MAIN_FIRMWARE "dvb-fe-drxj-mc-1.0.8.fw"
+
 /**
 * \brief Maximum u32 value.
 */
@@ -20588,3 +20616,459 @@ release:
 
 	return rc;
 }
+
+/*
+ * The Linux DVB Driver for Micronas DRX39xx family (drx3933j)
+ *
+ * Written by Devin Heitmueller <devin.heitmueller@kernellabs.com>
+ */
+
+static int drx39xxj_set_powerstate(struct dvb_frontend *fe, int enable)
+{
+	struct drx39xxj_state *state = fe->demodulator_priv;
+	struct drx_demod_instance *demod = state->demod;
+	int result;
+	enum drx_power_mode power_mode;
+
+	if (enable)
+		power_mode = DRX_POWER_UP;
+	else
+		power_mode = DRX_POWER_DOWN;
+
+	result = drxj_ctrl(demod, DRX_CTRL_POWER_MODE, &power_mode);
+	if (result != 0) {
+		pr_err("Power state change failed\n");
+		return 0;
+	}
+
+	state->powered_up = enable;
+	return 0;
+}
+
+static int drx39xxj_read_status(struct dvb_frontend *fe, fe_status_t *status)
+{
+	struct drx39xxj_state *state = fe->demodulator_priv;
+	struct drx_demod_instance *demod = state->demod;
+	int result;
+	enum drx_lock_status lock_status;
+
+	*status = 0;
+
+	result = drxj_ctrl(demod, DRX_CTRL_LOCK_STATUS, &lock_status);
+	if (result != 0) {
+		pr_err("drx39xxj: could not get lock status!\n");
+		*status = 0;
+	}
+
+	switch (lock_status) {
+	case DRX_NEVER_LOCK:
+		*status = 0;
+		pr_err("drx says NEVER_LOCK\n");
+		break;
+	case DRX_NOT_LOCKED:
+		*status = 0;
+		break;
+	case DRX_LOCK_STATE_1:
+	case DRX_LOCK_STATE_2:
+	case DRX_LOCK_STATE_3:
+	case DRX_LOCK_STATE_4:
+	case DRX_LOCK_STATE_5:
+	case DRX_LOCK_STATE_6:
+	case DRX_LOCK_STATE_7:
+	case DRX_LOCK_STATE_8:
+	case DRX_LOCK_STATE_9:
+		*status = FE_HAS_SIGNAL
+		    | FE_HAS_CARRIER | FE_HAS_VITERBI | FE_HAS_SYNC;
+		break;
+	case DRX_LOCKED:
+		*status = FE_HAS_SIGNAL
+		    | FE_HAS_CARRIER
+		    | FE_HAS_VITERBI | FE_HAS_SYNC | FE_HAS_LOCK;
+		break;
+	default:
+		pr_err("Lock state unknown %d\n", lock_status);
+	}
+
+	return 0;
+}
+
+static int drx39xxj_read_ber(struct dvb_frontend *fe, u32 *ber)
+{
+	struct drx39xxj_state *state = fe->demodulator_priv;
+	struct drx_demod_instance *demod = state->demod;
+	int result;
+	struct drx_sig_quality sig_quality;
+
+	result = drxj_ctrl(demod, DRX_CTRL_SIG_QUALITY, &sig_quality);
+	if (result != 0) {
+		pr_err("drx39xxj: could not get ber!\n");
+		*ber = 0;
+		return 0;
+	}
+
+	*ber = sig_quality.post_reed_solomon_ber;
+	return 0;
+}
+
+static int drx39xxj_read_signal_strength(struct dvb_frontend *fe,
+					 u16 *strength)
+{
+	struct drx39xxj_state *state = fe->demodulator_priv;
+	struct drx_demod_instance *demod = state->demod;
+	int result;
+	struct drx_sig_quality sig_quality;
+
+	result = drxj_ctrl(demod, DRX_CTRL_SIG_QUALITY, &sig_quality);
+	if (result != 0) {
+		pr_err("drx39xxj: could not get signal strength!\n");
+		*strength = 0;
+		return 0;
+	}
+
+	/* 1-100% scaled to 0-65535 */
+	*strength = (sig_quality.indicator * 65535 / 100);
+	return 0;
+}
+
+static int drx39xxj_read_snr(struct dvb_frontend *fe, u16 *snr)
+{
+	struct drx39xxj_state *state = fe->demodulator_priv;
+	struct drx_demod_instance *demod = state->demod;
+	int result;
+	struct drx_sig_quality sig_quality;
+
+	result = drxj_ctrl(demod, DRX_CTRL_SIG_QUALITY, &sig_quality);
+	if (result != 0) {
+		pr_err("drx39xxj: could not read snr!\n");
+		*snr = 0;
+		return 0;
+	}
+
+	*snr = sig_quality.MER;
+	return 0;
+}
+
+static int drx39xxj_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
+{
+	struct drx39xxj_state *state = fe->demodulator_priv;
+	struct drx_demod_instance *demod = state->demod;
+	int result;
+	struct drx_sig_quality sig_quality;
+
+	result = drxj_ctrl(demod, DRX_CTRL_SIG_QUALITY, &sig_quality);
+	if (result != 0) {
+		pr_err("drx39xxj: could not get uc blocks!\n");
+		*ucblocks = 0;
+		return 0;
+	}
+
+	*ucblocks = sig_quality.packet_error;
+	return 0;
+}
+
+static int drx39xxj_set_frontend(struct dvb_frontend *fe)
+{
+#ifdef DJH_DEBUG
+	int i;
+#endif
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
+	struct drx39xxj_state *state = fe->demodulator_priv;
+	struct drx_demod_instance *demod = state->demod;
+	enum drx_standard standard = DRX_STANDARD_8VSB;
+	struct drx_channel channel;
+	int result;
+	struct drxuio_data uio_data;
+	static const struct drx_channel def_channel = {
+		/* frequency      */ 0,
+		/* bandwidth      */ DRX_BANDWIDTH_6MHZ,
+		/* mirror         */ DRX_MIRROR_NO,
+		/* constellation  */ DRX_CONSTELLATION_AUTO,
+		/* hierarchy      */ DRX_HIERARCHY_UNKNOWN,
+		/* priority       */ DRX_PRIORITY_UNKNOWN,
+		/* coderate       */ DRX_CODERATE_UNKNOWN,
+		/* guard          */ DRX_GUARD_UNKNOWN,
+		/* fftmode        */ DRX_FFTMODE_UNKNOWN,
+		/* classification */ DRX_CLASSIFICATION_AUTO,
+		/* symbolrate     */ 5057000,
+		/* interleavemode */ DRX_INTERLEAVEMODE_UNKNOWN,
+		/* ldpc           */ DRX_LDPC_UNKNOWN,
+		/* carrier        */ DRX_CARRIER_UNKNOWN,
+		/* frame mode     */ DRX_FRAMEMODE_UNKNOWN
+	};
+	u32 constellation = DRX_CONSTELLATION_AUTO;
+
+	/* Bring the demod out of sleep */
+	drx39xxj_set_powerstate(fe, 1);
+
+	/* Now make the tuner do it's thing... */
+	if (fe->ops.tuner_ops.set_params) {
+		if (fe->ops.i2c_gate_ctrl)
+			fe->ops.i2c_gate_ctrl(fe, 1);
+		fe->ops.tuner_ops.set_params(fe);
+		if (fe->ops.i2c_gate_ctrl)
+			fe->ops.i2c_gate_ctrl(fe, 0);
+	}
+
+	switch (p->delivery_system) {
+	case SYS_ATSC:
+		standard = DRX_STANDARD_8VSB;
+		break;
+	case SYS_DVBC_ANNEX_B:
+		standard = DRX_STANDARD_ITU_B;
+
+		switch (p->modulation) {
+		case QAM_64:
+			constellation = DRX_CONSTELLATION_QAM64;
+			break;
+		case QAM_256:
+			constellation = DRX_CONSTELLATION_QAM256;
+			break;
+		default:
+			constellation = DRX_CONSTELLATION_AUTO;
+			break;
+		}
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (standard != state->current_standard || state->powered_up == 0) {
+		/* Set the standard (will be powered up if necessary */
+		result = drxj_ctrl(demod, DRX_CTRL_SET_STANDARD, &standard);
+		if (result != 0) {
+			pr_err("Failed to set standard! result=%02x\n",
+			       result);
+			return -EINVAL;
+		}
+		state->powered_up = 1;
+		state->current_standard = standard;
+	}
+
+	/* set channel parameters */
+	channel = def_channel;
+	channel.frequency = p->frequency / 1000;
+	channel.bandwidth = DRX_BANDWIDTH_6MHZ;
+	channel.constellation = constellation;
+
+	/* program channel */
+	result = drxj_ctrl(demod, DRX_CTRL_SET_CHANNEL, &channel);
+	if (result != 0) {
+		pr_err("Failed to set channel!\n");
+		return -EINVAL;
+	}
+	/* Just for giggles, let's shut off the LNA again.... */
+	uio_data.uio = DRX_UIO1;
+	uio_data.value = false;
+	result = drxj_ctrl(demod, DRX_CTRL_UIO_WRITE, &uio_data);
+	if (result != 0) {
+		pr_err("Failed to disable LNA!\n");
+		return 0;
+	}
+#ifdef DJH_DEBUG
+	for (i = 0; i < 2000; i++) {
+		fe_status_t status;
+		drx39xxj_read_status(fe, &status);
+		pr_dbg("i=%d status=%d\n", i, status);
+		msleep(100);
+		i += 100;
+	}
+#endif
+
+	return 0;
+}
+
+static int drx39xxj_sleep(struct dvb_frontend *fe)
+{
+	/* power-down the demodulator */
+	return drx39xxj_set_powerstate(fe, 0);
+}
+
+static int drx39xxj_i2c_gate_ctrl(struct dvb_frontend *fe, int enable)
+{
+	struct drx39xxj_state *state = fe->demodulator_priv;
+	struct drx_demod_instance *demod = state->demod;
+	bool i2c_gate_state;
+	int result;
+
+#ifdef DJH_DEBUG
+	pr_dbg("i2c gate call: enable=%d state=%d\n", enable,
+	       state->i2c_gate_open);
+#endif
+
+	if (enable)
+		i2c_gate_state = true;
+	else
+		i2c_gate_state = false;
+
+	if (state->i2c_gate_open == enable) {
+		/* We're already in the desired state */
+		return 0;
+	}
+
+	result = drxj_ctrl(demod, DRX_CTRL_I2C_BRIDGE, &i2c_gate_state);
+	if (result != 0) {
+		pr_err("drx39xxj: could not open i2c gate [%d]\n",
+		       result);
+		dump_stack();
+	} else {
+		state->i2c_gate_open = enable;
+	}
+	return 0;
+}
+
+static int drx39xxj_init(struct dvb_frontend *fe)
+{
+	/* Bring the demod out of sleep */
+	drx39xxj_set_powerstate(fe, 1);
+
+	return 0;
+}
+
+static int drx39xxj_get_tune_settings(struct dvb_frontend *fe,
+				      struct dvb_frontend_tune_settings *tune)
+{
+	tune->min_delay_ms = 1000;
+	return 0;
+}
+
+static void drx39xxj_release(struct dvb_frontend *fe)
+{
+	struct drx39xxj_state *state = fe->demodulator_priv;
+	struct drx_demod_instance *demod = state->demod;
+
+	kfree(demod->my_ext_attr);
+	kfree(demod->my_common_attr);
+	kfree(demod->my_i2c_dev_addr);
+	if (demod->firmware)
+		release_firmware(demod->firmware);
+	kfree(demod);
+	kfree(state);
+}
+
+static struct dvb_frontend_ops drx39xxj_ops;
+
+struct dvb_frontend *drx39xxj_attach(struct i2c_adapter *i2c)
+{
+	struct drx39xxj_state *state = NULL;
+
+	struct i2c_device_addr *demod_addr = NULL;
+	struct drx_common_attr *demod_comm_attr = NULL;
+	struct drxj_data *demod_ext_attr = NULL;
+	struct drx_demod_instance *demod = NULL;
+	struct drxuio_cfg uio_cfg;
+	struct drxuio_data uio_data;
+	int result;
+
+	/* allocate memory for the internal state */
+	state = kzalloc(sizeof(struct drx39xxj_state), GFP_KERNEL);
+	if (state == NULL)
+		goto error;
+
+	demod = kmalloc(sizeof(struct drx_demod_instance), GFP_KERNEL);
+	if (demod == NULL)
+		goto error;
+
+	demod_addr = kmalloc(sizeof(struct i2c_device_addr), GFP_KERNEL);
+	if (demod_addr == NULL)
+		goto error;
+	memcpy(demod_addr, &drxj_default_addr_g,
+	       sizeof(struct i2c_device_addr));
+
+	demod_comm_attr = kmalloc(sizeof(struct drx_common_attr), GFP_KERNEL);
+	if (demod_comm_attr == NULL)
+		goto error;
+	memcpy(demod_comm_attr, &drxj_default_comm_attr_g,
+	       sizeof(struct drx_common_attr));
+
+	demod_ext_attr = kmalloc(sizeof(struct drxj_data), GFP_KERNEL);
+	if (demod_ext_attr == NULL)
+		goto error;
+	memcpy(demod_ext_attr, &drxj_data_g, sizeof(struct drxj_data));
+
+	/* setup the state */
+	state->i2c = i2c;
+	state->demod = demod;
+
+	/* setup the demod data */
+	memcpy(demod, &drxj_default_demod_g, sizeof(struct drx_demod_instance));
+
+	demod->my_i2c_dev_addr = demod_addr;
+	demod->my_common_attr = demod_comm_attr;
+	demod->my_i2c_dev_addr->user_data = state;
+	demod->my_common_attr->microcode_file = DRX39XX_MAIN_FIRMWARE;
+	demod->my_common_attr->verify_microcode = true;
+	demod->my_common_attr->intermediate_freq = 5000;
+	demod->my_ext_attr = demod_ext_attr;
+	((struct drxj_data *)demod_ext_attr)->uio_sma_tx_mode = DRX_UIO_MODE_READWRITE;
+	demod->my_tuner = NULL;
+	demod->i2c = i2c;
+
+	result = drxj_open(demod);
+	if (result != 0) {
+		pr_err("DRX open failed!  Aborting\n");
+		goto error;
+	}
+
+	/* Turn off the LNA */
+	uio_cfg.uio = DRX_UIO1;
+	uio_cfg.mode = DRX_UIO_MODE_READWRITE;
+	/* Configure user-I/O #3: enable read/write */
+	result = drxj_ctrl(demod, DRX_CTRL_UIO_CFG, &uio_cfg);
+	if (result) {
+		pr_err("Failed to setup LNA GPIO!\n");
+		goto error;
+	}
+
+	uio_data.uio = DRX_UIO1;
+	uio_data.value = false;
+	result = drxj_ctrl(demod, DRX_CTRL_UIO_WRITE, &uio_data);
+	if (result != 0) {
+		pr_err("Failed to disable LNA!\n");
+		goto error;
+	}
+
+	/* create dvb_frontend */
+	memcpy(&state->frontend.ops, &drx39xxj_ops,
+	       sizeof(struct dvb_frontend_ops));
+
+	state->frontend.demodulator_priv = state;
+	return &state->frontend;
+
+error:
+	kfree(demod_ext_attr);
+	kfree(demod_comm_attr);
+	kfree(demod_addr);
+	kfree(demod);
+	kfree(state);
+
+	return NULL;
+}
+EXPORT_SYMBOL(drx39xxj_attach);
+
+static struct dvb_frontend_ops drx39xxj_ops = {
+	.delsys = { SYS_ATSC, SYS_DVBC_ANNEX_B },
+	.info = {
+		 .name = "Micronas DRX39xxj family Frontend",
+		 .frequency_stepsize = 62500,
+		 .frequency_min = 51000000,
+		 .frequency_max = 858000000,
+		 .caps = FE_CAN_QAM_64 | FE_CAN_QAM_256 | FE_CAN_8VSB
+	},
+
+	.init = drx39xxj_init,
+	.i2c_gate_ctrl = drx39xxj_i2c_gate_ctrl,
+	.sleep = drx39xxj_sleep,
+	.set_frontend = drx39xxj_set_frontend,
+	.get_tune_settings = drx39xxj_get_tune_settings,
+	.read_status = drx39xxj_read_status,
+	.read_ber = drx39xxj_read_ber,
+	.read_signal_strength = drx39xxj_read_signal_strength,
+	.read_snr = drx39xxj_read_snr,
+	.read_ucblocks = drx39xxj_read_ucblocks,
+	.release = drx39xxj_release,
+};
+
+MODULE_DESCRIPTION("Micronas DRX39xxj Frontend");
+MODULE_AUTHOR("Devin Heitmueller");
+MODULE_LICENSE("GPL");
+MODULE_FIRMWARE(DRX39XX_MAIN_FIRMWARE);
-- 
1.8.5.3

