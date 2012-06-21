Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24713 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759651Ab2FUNgz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jun 2012 09:36:55 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Antti Palosaari <crope@iki.fi>, Kay Sievers <kay@redhat.com>
Subject: [PATCH] [media] drxk: change it to use request_firmware_nowait()
Date: Thu, 21 Jun 2012 10:36:38 -0300
Message-Id: <1340285798-8322-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The firmware blob may not be available when the driver probes.

Instead of blocking the whole kernel use request_firmware_nowait() and
continue without firmware.

This shouldn't be that bad on drx-k devices, as they all seem to have an
internal firmware. So, only the firmware update will take a little longer
to happen.

Cc: Antti Palosaari <crope@iki.fi>
Cc: Kay Sievers <kay@redhat.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/frontends/drxk_hard.c |  109 +++++++++++++++++++------------
 drivers/media/dvb/frontends/drxk_hard.h |    3 +
 2 files changed, 72 insertions(+), 40 deletions(-)

diff --git a/drivers/media/dvb/frontends/drxk_hard.c b/drivers/media/dvb/frontends/drxk_hard.c
index 60b868f..4cb8d1e 100644
--- a/drivers/media/dvb/frontends/drxk_hard.c
+++ b/drivers/media/dvb/frontends/drxk_hard.c
@@ -5968,29 +5968,9 @@ error:
 	return status;
 }
 
-static int load_microcode(struct drxk_state *state, const char *mc_name)
-{
-	const struct firmware *fw = NULL;
-	int err = 0;
-
-	dprintk(1, "\n");
-
-	err = request_firmware(&fw, mc_name, state->i2c->dev.parent);
-	if (err < 0) {
-		printk(KERN_ERR
-		       "drxk: Could not load firmware file %s.\n", mc_name);
-		printk(KERN_INFO
-		       "drxk: Copy %s to your hotplug directory!\n", mc_name);
-		return err;
-	}
-	err = DownloadMicrocode(state, fw->data, fw->size);
-	release_firmware(fw);
-	return err;
-}
-
 static int init_drxk(struct drxk_state *state)
 {
-	int status = 0;
+	int status = 0, n = 0;
 	enum DRXPowerMode powerMode = DRXK_POWER_DOWN_OFDM;
 	u16 driverVersion;
 
@@ -6073,8 +6053,12 @@ static int init_drxk(struct drxk_state *state)
 		if (status < 0)
 			goto error;
 
-		if (state->microcode_name)
-			load_microcode(state, state->microcode_name);
+		if (state->fw) {
+			status = DownloadMicrocode(state, state->fw->data,
+						   state->fw->size);
+			if (status < 0)
+				goto error;
+		}
 
 		/* disable token-ring bus through OFDM block for possible ucode upload */
 		status = write16(state, SIO_OFDM_SH_OFDM_RING_ENABLE__A, SIO_OFDM_SH_OFDM_RING_ENABLE_OFF);
@@ -6167,6 +6151,20 @@ static int init_drxk(struct drxk_state *state)
 			state->m_DrxkState = DRXK_POWERED_DOWN;
 		} else
 			state->m_DrxkState = DRXK_STOPPED;
+
+		/* Initialize the supported delivery systems */
+		n = 0;
+		if (state->m_hasDVBC) {
+			state->frontend.ops.delsys[n++] = SYS_DVBC_ANNEX_A;
+			state->frontend.ops.delsys[n++] = SYS_DVBC_ANNEX_C;
+			strlcat(state->frontend.ops.info.name, " DVB-C",
+				sizeof(state->frontend.ops.info.name));
+		}
+		if (state->m_hasDVBT) {
+			state->frontend.ops.delsys[n++] = SYS_DVBT;
+			strlcat(state->frontend.ops.info.name, " DVB-T",
+				sizeof(state->frontend.ops.info.name));
+		}
 	}
 error:
 	if (status < 0)
@@ -6175,11 +6173,44 @@ error:
 	return status;
 }
 
+static void load_firmware_cb(const struct firmware *fw,
+			     void *context)
+{
+	struct drxk_state *state = context;
+
+	if (!fw) {
+		printk(KERN_ERR
+		       "drxk: Could not load firmware file %s.\n",
+			state->microcode_name);
+		printk(KERN_INFO
+		       "drxk: Copy %s to your hotplug directory!\n",
+			state->microcode_name);
+		state->microcode_name = NULL;
+
+		/*
+		 * As firmware is now load asynchronous, it is not possible
+		 * anymore to fail at frontend attach. We might silently
+		 * return here, and hope that the driver won't crash.
+		 * We might also change all DVB callbacks to return -ENODEV
+		 * if the device is not initialized.
+		 * As the DRX-K devices have their own internal firmware,
+		 * let's just hope that it will match a firmware revision
+		 * compatible with this driver and proceed.
+		 */
+	}
+	state->fw = fw;
+
+	init_drxk(state);
+}
+
 static void drxk_release(struct dvb_frontend *fe)
 {
 	struct drxk_state *state = fe->demodulator_priv;
 
 	dprintk(1, "\n");
+	if (state->fw)
+		release_firmware(state->fw);
+
 	kfree(state);
 }
 
@@ -6371,10 +6402,9 @@ static struct dvb_frontend_ops drxk_ops = {
 struct dvb_frontend *drxk_attach(const struct drxk_config *config,
 				 struct i2c_adapter *i2c)
 {
-	int n;
-
 	struct drxk_state *state = NULL;
 	u8 adr = config->adr;
+	int status;
 
 	dprintk(1, "\n");
 	state = kzalloc(sizeof(struct drxk_state), GFP_KERNEL);
@@ -6425,22 +6455,21 @@ struct dvb_frontend *drxk_attach(const struct drxk_config *config,
 	state->frontend.demodulator_priv = state;
 
 	init_state(state);
-	if (init_drxk(state) < 0)
-		goto error;
 
-	/* Initialize the supported delivery systems */
-	n = 0;
-	if (state->m_hasDVBC) {
-		state->frontend.ops.delsys[n++] = SYS_DVBC_ANNEX_A;
-		state->frontend.ops.delsys[n++] = SYS_DVBC_ANNEX_C;
-		strlcat(state->frontend.ops.info.name, " DVB-C",
-			sizeof(state->frontend.ops.info.name));
-	}
-	if (state->m_hasDVBT) {
-		state->frontend.ops.delsys[n++] = SYS_DVBT;
-		strlcat(state->frontend.ops.info.name, " DVB-T",
-			sizeof(state->frontend.ops.info.name));
-	}
+	/* Load firmware and initialize DRX-K */
+	if (state->microcode_name) {
+		status = request_firmware_nowait(THIS_MODULE, 1,
+					      state->microcode_name,
+					      state->i2c->dev.parent,
+					      GFP_KERNEL,
+					      state, load_firmware_cb);
+		if (status < 0) {
+			printk(KERN_ERR
+			"drxk: failed to request a firmware\n");
+			return NULL;
+		}
+	} else if (init_drxk(state) < 0)
+		goto error;
 
 	printk(KERN_INFO "drxk: frontend initialized.\n");
 	return &state->frontend;
diff --git a/drivers/media/dvb/frontends/drxk_hard.h b/drivers/media/dvb/frontends/drxk_hard.h
index 4bbf841..36677cd 100644
--- a/drivers/media/dvb/frontends/drxk_hard.h
+++ b/drivers/media/dvb/frontends/drxk_hard.h
@@ -338,7 +338,10 @@ struct drxk_state {
 	bool	antenna_dvbt;
 	u16	antenna_gpio;
 
+	/* Firmware */
 	const char *microcode_name;
+	struct completion fw_wait_load;
+	const struct firmware *fw;
 };
 
 #define NEVER_LOCK 0
-- 
1.7.10.2

