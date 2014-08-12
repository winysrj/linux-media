Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49202 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755232AbaHLVub (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Aug 2014 17:50:31 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 08/10] [media] as102: prepare as102_fe to be compiled as a module
Date: Tue, 12 Aug 2014 18:50:22 -0300
Message-Id: <1407880224-374-9-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1407880224-374-1-git-send-email-m.chehab@samsung.com>
References: <1407880224-374-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove the dependencies of as102_cmd from as102, in order to
allow it to be compiled as a separate module.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/as102/as102_drv.c    | 116 +++++++++++++++++++++++++++++++++
 drivers/media/usb/as102/as102_drv.h    |   8 +--
 drivers/media/usb/as102/as102_fe.c     | 105 ++++++++---------------------
 drivers/media/usb/as102/as102_fe.h     |  29 +++++++++
 drivers/media/usb/as102/as10x_cmd.h    |   2 -
 drivers/media/usb/as102/as10x_handle.h |   3 +-
 drivers/media/usb/as102/as10x_types.h  |   2 -
 7 files changed, 179 insertions(+), 86 deletions(-)
 create mode 100644 drivers/media/usb/as102/as102_fe.h

diff --git a/drivers/media/usb/as102/as102_drv.c b/drivers/media/usb/as102/as102_drv.c
index ff5bd2e5657a..8be1474b2c36 100644
--- a/drivers/media/usb/as102/as102_drv.c
+++ b/drivers/media/usb/as102/as102_drv.c
@@ -24,6 +24,8 @@
 
 /* header file for usb device driver*/
 #include "as102_drv.h"
+#include "as10x_cmd.h"
+#include "as102_fe.h"
 #include "as102_fw.h"
 #include "dvbdev.h"
 
@@ -176,6 +178,119 @@ static int as102_dvb_dmx_stop_feed(struct dvb_demux_feed *dvbdmxfeed)
 	return 0;
 }
 
+static int as102_set_tune(void *priv, struct as10x_tune_args *tune_args)
+{
+	struct as10x_bus_adapter_t *bus_adap = priv;
+	int ret;
+
+	/* Set frontend arguments */
+	if (mutex_lock_interruptible(&bus_adap->lock))
+		return -EBUSY;
+
+	ret =  as10x_cmd_set_tune(bus_adap, tune_args);
+	if (ret != 0)
+		dev_dbg(&bus_adap->usb_dev->dev,
+			"as10x_cmd_set_tune failed. (err = %d)\n", ret);
+
+	mutex_unlock(&bus_adap->lock);
+
+	return ret;
+}
+
+static int as102_get_tps(void *priv, struct as10x_tps *tps)
+{
+	struct as10x_bus_adapter_t *bus_adap = priv;
+	int ret;
+
+	if (mutex_lock_interruptible(&bus_adap->lock))
+		return -EBUSY;
+
+	/* send abilis command: GET_TPS */
+	ret = as10x_cmd_get_tps(bus_adap, tps);
+
+	mutex_unlock(&bus_adap->lock);
+
+	return ret;
+}
+
+static int as102_get_status(void *priv, struct as10x_tune_status *tstate)
+{
+	struct as10x_bus_adapter_t *bus_adap = priv;
+	int ret;
+
+	if (mutex_lock_interruptible(&bus_adap->lock))
+		return -EBUSY;
+
+	/* send abilis command: GET_TUNE_STATUS */
+	ret = as10x_cmd_get_tune_status(bus_adap, tstate);
+	if (ret < 0) {
+		dev_dbg(&bus_adap->usb_dev->dev,
+			"as10x_cmd_get_tune_status failed (err = %d)\n",
+			ret);
+	}
+
+	mutex_unlock(&bus_adap->lock);
+
+	return ret;
+}
+
+static int as102_get_stats(void *priv, struct as10x_demod_stats *demod_stats)
+{
+	struct as10x_bus_adapter_t *bus_adap = priv;
+	int ret;
+
+	if (mutex_lock_interruptible(&bus_adap->lock))
+		return -EBUSY;
+
+	/* send abilis command: GET_TUNE_STATUS */
+	ret = as10x_cmd_get_demod_stats(bus_adap, demod_stats);
+	if (ret < 0) {
+		dev_dbg(&bus_adap->usb_dev->dev,
+			"as10x_cmd_get_demod_stats failed (probably not tuned)\n");
+	} else {
+		dev_dbg(&bus_adap->usb_dev->dev,
+			"demod status: fc: 0x%08x, bad fc: 0x%08x, bytes corrected: 0x%08x , MER: 0x%04x\n",
+			demod_stats->frame_count,
+			demod_stats->bad_frame_count,
+			demod_stats->bytes_fixed_by_rs,
+			demod_stats->mer);
+	}
+	mutex_unlock(&bus_adap->lock);
+
+	return ret;
+}
+
+static int as102_stream_ctrl(void *priv, int acquire, uint32_t elna_cfg)
+{
+	struct as10x_bus_adapter_t *bus_adap = priv;
+	int ret;
+
+	if (mutex_lock_interruptible(&bus_adap->lock))
+		return -EBUSY;
+
+	if (acquire) {
+		if (elna_enable)
+			as10x_cmd_set_context(bus_adap,
+					      CONTEXT_LNA, elna_cfg);
+
+		ret = as10x_cmd_turn_on(bus_adap);
+	} else {
+		ret = as10x_cmd_turn_off(bus_adap);
+	}
+
+	mutex_unlock(&bus_adap->lock);
+
+	return ret;
+}
+
+static const struct as102_fe_ops as102_fe_ops = {
+	.set_tune = as102_set_tune,
+	.get_tps  = as102_get_tps,
+	.get_status = as102_get_status,
+	.get_stats = as102_get_stats,
+	.stream_ctrl = as102_stream_ctrl,
+};
+
 int as102_dvb_register(struct as102_dev_t *as102_dev)
 {
 	struct device *dev = &as102_dev->bus_adap.usb_dev->dev;
@@ -218,6 +333,7 @@ int as102_dvb_register(struct as102_dev_t *as102_dev)
 
 	/* Attach the frontend */
 	as102_dev->dvb_fe = dvb_attach(as102_attach, as102_dev->name,
+				       &as102_fe_ops,
 				       &as102_dev->bus_adap,
 				       as102_dev->elna_cfg);
 	if (!as102_dev->dvb_fe) {
diff --git a/drivers/media/usb/as102/as102_drv.h b/drivers/media/usb/as102/as102_drv.h
index 1e2a76d3c517..9430d30163a3 100644
--- a/drivers/media/usb/as102/as102_drv.h
+++ b/drivers/media/usb/as102/as102_drv.h
@@ -13,10 +13,13 @@
  * GNU General Public License for more details.
  */
 
+#ifndef _AS102_DRV_H
+#define _AS102_DRV_H
 #include <linux/usb.h>
 #include <dvb_demux.h>
 #include <dvb_frontend.h>
 #include <dmxdev.h>
+#include "as10x_handle.h"
 #include "as10x_cmd.h"
 #include "as102_usb_drv.h"
 
@@ -77,7 +80,4 @@ struct as102_dev_t {
 int as102_dvb_register(struct as102_dev_t *dev);
 void as102_dvb_unregister(struct as102_dev_t *dev);
 
-/* FIXME: move it to a separate header */
-struct dvb_frontend *as102_attach(const char *name,
-				  struct as10x_bus_adapter_t *bus_adap,
-				  uint8_t elna_cfg);
+#endif
\ No newline at end of file
diff --git a/drivers/media/usb/as102/as102_fe.c b/drivers/media/usb/as102/as102_fe.c
index 0cd19f23eca9..f57560c191ae 100644
--- a/drivers/media/usb/as102/as102_fe.c
+++ b/drivers/media/usb/as102/as102_fe.c
@@ -13,15 +13,17 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  */
-#include "as102_drv.h"
-#include "as10x_types.h"
-#include "as10x_cmd.h"
+
+#include <dvb_frontend.h>
+
+#include "as102_fe.h"
 
 struct as102_state {
 	struct dvb_frontend frontend;
 	struct as10x_demod_stats demod_stats;
-	struct as10x_bus_adapter_t *bus_adap;
 
+	const struct as102_fe_ops *ops;
+	void *priv;
 	uint8_t elna_cfg;
 
 	/* signal strength */
@@ -62,7 +64,6 @@ static int as102_fe_set_frontend(struct dvb_frontend *fe)
 {
 	struct as102_state *state = fe->demodulator_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
-	int ret = 0;
 	struct as10x_tune_args tune_args = { 0 };
 
 	/* set frequency */
@@ -186,17 +187,7 @@ static int as102_fe_set_frontend(struct dvb_frontend *fe)
 	}
 
 	/* Set frontend arguments */
-	if (mutex_lock_interruptible(&state->bus_adap->lock))
-		return -EBUSY;
-
-	ret =  as10x_cmd_set_tune(state->bus_adap, &tune_args);
-	if (ret != 0)
-		dev_dbg(&state->bus_adap->usb_dev->dev,
-			"as10x_cmd_set_tune failed. (err = %d)\n", ret);
-
-	mutex_unlock(&state->bus_adap->lock);
-
-	return (ret < 0) ? -EINVAL : 0;
+	return state->ops->set_tune(state->priv, &tune_args);
 }
 
 static int as102_fe_get_frontend(struct dvb_frontend *fe)
@@ -206,14 +197,8 @@ static int as102_fe_get_frontend(struct dvb_frontend *fe)
 	int ret = 0;
 	struct as10x_tps tps = { 0 };
 
-	if (mutex_lock_interruptible(&state->bus_adap->lock))
-		return -EBUSY;
-
 	/* send abilis command: GET_TPS */
-	ret = as10x_cmd_get_tps(state->bus_adap, &tps);
-
-	mutex_unlock(&state->bus_adap->lock);
-
+	ret = state->ops->get_tps(state->priv, &tps);
 	if (ret < 0)
 		return ret;
 
@@ -321,24 +306,16 @@ static int as102_fe_get_tune_settings(struct dvb_frontend *fe,
 	return 0;
 }
 
-
 static int as102_fe_read_status(struct dvb_frontend *fe, fe_status_t *status)
 {
 	int ret = 0;
 	struct as102_state *state = fe->demodulator_priv;
 	struct as10x_tune_status tstate = { 0 };
 
-	if (mutex_lock_interruptible(&state->bus_adap->lock))
-		return -EBUSY;
-
 	/* send abilis command: GET_TUNE_STATUS */
-	ret = as10x_cmd_get_tune_status(state->bus_adap, &tstate);
-	if (ret < 0) {
-		dev_dbg(&state->bus_adap->usb_dev->dev,
-			"as10x_cmd_get_tune_status failed (err = %d)\n",
-			ret);
-		goto out;
-	}
+	ret = state->ops->get_status(state->priv, &tstate);
+	if (ret < 0)
+		return ret;
 
 	state->signal_strength  = tstate.signal_strength;
 	state->ber  = tstate.BER;
@@ -358,31 +335,19 @@ static int as102_fe_read_status(struct dvb_frontend *fe, fe_status_t *status)
 		*status = TUNE_STATUS_NOT_TUNED;
 	}
 
-	dev_dbg(&state->bus_adap->usb_dev->dev,
-			"tuner status: 0x%02x, strength %d, per: %d, ber: %d\n",
-			tstate.tune_state, tstate.signal_strength,
-			tstate.PER, tstate.BER);
-
-	if (*status & FE_HAS_LOCK) {
-		if (as10x_cmd_get_demod_stats(state->bus_adap,
-			(struct as10x_demod_stats *) &state->demod_stats) < 0) {
-			memset(&state->demod_stats, 0, sizeof(state->demod_stats));
-			dev_dbg(&state->bus_adap->usb_dev->dev,
-				"as10x_cmd_get_demod_stats failed (probably not tuned)\n");
-		} else {
-			dev_dbg(&state->bus_adap->usb_dev->dev,
-				"demod status: fc: 0x%08x, bad fc: 0x%08x, bytes corrected: 0x%08x , MER: 0x%04x\n",
-				state->demod_stats.frame_count,
-				state->demod_stats.bad_frame_count,
-				state->demod_stats.bytes_fixed_by_rs,
-				state->demod_stats.mer);
-		}
-	} else {
+	pr_debug("as102: tuner status: 0x%02x, strength %d, per: %d, ber: %d\n",
+		 tstate.tune_state, tstate.signal_strength,
+		 tstate.PER, tstate.BER);
+
+	if (!(*status & FE_HAS_LOCK)) {
 		memset(&state->demod_stats, 0, sizeof(state->demod_stats));
+		return 0;
 	}
 
-out:
-	mutex_unlock(&state->bus_adap->lock);
+	ret = state->ops->get_stats(state->priv, &state->demod_stats);
+	if (ret < 0)
+		memset(&state->demod_stats, 0, sizeof(state->demod_stats));
+
 	return ret;
 }
 
@@ -436,24 +401,9 @@ static int as102_fe_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
 static int as102_fe_ts_bus_ctrl(struct dvb_frontend *fe, int acquire)
 {
 	struct as102_state *state = fe->demodulator_priv;
-	int ret;
-
-	if (mutex_lock_interruptible(&state->bus_adap->lock))
-		return -EBUSY;
 
-	if (acquire) {
-		if (elna_enable)
-			as10x_cmd_set_context(state->bus_adap,
-					      CONTEXT_LNA, state->elna_cfg);
-
-		ret = as10x_cmd_turn_on(state->bus_adap);
-	} else {
-		ret = as10x_cmd_turn_off(state->bus_adap);
-	}
-
-	mutex_unlock(&state->bus_adap->lock);
-
-	return ret;
+	return state->ops->stream_ctrl(state->priv, acquire,
+				      state->elna_cfg);
 }
 
 static struct dvb_frontend_ops as102_fe_ops = {
@@ -488,7 +438,8 @@ static struct dvb_frontend_ops as102_fe_ops = {
 };
 
 struct dvb_frontend *as102_attach(const char *name,
-				  struct as10x_bus_adapter_t *bus_adap,
+				  const struct as102_fe_ops *ops,
+				  void *priv,
 				  uint8_t elna_cfg)
 {
 	struct as102_state *state;
@@ -496,13 +447,13 @@ struct dvb_frontend *as102_attach(const char *name,
 
 	state = kzalloc(sizeof(struct as102_state), GFP_KERNEL);
 	if (state == NULL) {
-		dev_err(&bus_adap->usb_dev->dev,
-			"%s: unable to allocate memory for state\n", __func__);
+		pr_err("%s: unable to allocate memory for state\n", __func__);
 		return NULL;
 	}
 	fe = &state->frontend;
 	fe->demodulator_priv = state;
-	state->bus_adap = bus_adap;
+	state->ops = ops;
+	state->priv = priv;
 	state->elna_cfg = elna_cfg;
 
 	/* init frontend callback ops */
diff --git a/drivers/media/usb/as102/as102_fe.h b/drivers/media/usb/as102/as102_fe.h
new file mode 100644
index 000000000000..4098cf8f8cf9
--- /dev/null
+++ b/drivers/media/usb/as102/as102_fe.h
@@ -0,0 +1,29 @@
+/*
+ * Abilis Systems Single DVB-T Receiver
+ * Copyright (C) 2014 Mauro Carvalho Chehab <m.chehab@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2, or (at your option)
+ * any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include "as10x_types.h"
+
+struct as102_fe_ops {
+	int (*set_tune)(void *priv, struct as10x_tune_args *tune_args);
+	int (*get_tps)(void *priv, struct as10x_tps *tps);
+	int (*get_status)(void *priv, struct as10x_tune_status *tstate);
+	int (*get_stats)(void *priv, struct as10x_demod_stats *demod_stats);
+	int (*stream_ctrl)(void *priv, int acquire, uint32_t elna_cfg);
+};
+
+struct dvb_frontend *as102_attach(const char *name,
+				  const struct as102_fe_ops *ops,
+				  void *priv,
+				  uint8_t elna_cfg);
diff --git a/drivers/media/usb/as102/as10x_cmd.h b/drivers/media/usb/as102/as10x_cmd.h
index 1c9ea2c2175e..83c0440dba2f 100644
--- a/drivers/media/usb/as102/as10x_cmd.h
+++ b/drivers/media/usb/as102/as10x_cmd.h
@@ -15,9 +15,7 @@
 #ifndef _AS10X_CMD_H_
 #define _AS10X_CMD_H_
 
-#ifdef __KERNEL__
 #include <linux/kernel.h>
-#endif
 
 #include "as10x_types.h"
 
diff --git a/drivers/media/usb/as102/as10x_handle.h b/drivers/media/usb/as102/as10x_handle.h
index e535fffbcd94..d6b58c770500 100644
--- a/drivers/media/usb/as102/as10x_handle.h
+++ b/drivers/media/usb/as102/as10x_handle.h
@@ -12,7 +12,8 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  */
-#ifdef __KERNEL__
+#ifndef _AS10X_HANDLE_H
+#define _AS10X_HANDLE_H
 struct as10x_bus_adapter_t;
 struct as102_dev_t;
 
diff --git a/drivers/media/usb/as102/as10x_types.h b/drivers/media/usb/as102/as10x_types.h
index f82d51e542e3..80a5398b580f 100644
--- a/drivers/media/usb/as102/as10x_types.h
+++ b/drivers/media/usb/as102/as10x_types.h
@@ -15,8 +15,6 @@
 #ifndef _AS10X_TYPES_H_
 #define _AS10X_TYPES_H_
 
-#include "as10x_handle.h"
-
 /*********************************/
 /*       MACRO DEFINITIONS       */
 /*********************************/
-- 
1.9.3

