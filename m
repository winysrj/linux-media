Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50970 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256AbaAMKnj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jan 2014 05:43:39 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] drxk: remove the option to load firmware asynchronously
Date: Mon, 13 Jan 2014 05:39:58 -0200
Message-Id: <1389598798-15021-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The option to load firmware asynchronously were added due to
a requirement with a few versions of udev. It turns that this was
a bad idea and caused regressions on drxk-based devices.

So, we end by only letting the firmware to be loaded syncronously
everywhere.

So, let's remove the bad code.

This patch partially reverts the changeset 8e30783b0b3.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/drxk.h      |  2 --
 drivers/media/dvb-frontends/drxk_hard.c | 24 ++++++------------------
 drivers/media/usb/em28xx/em28xx-dvb.c   |  5 -----
 3 files changed, 6 insertions(+), 25 deletions(-)

diff --git a/drivers/media/dvb-frontends/drxk.h b/drivers/media/dvb-frontends/drxk.h
index f22eb9f13ad5..f6cb34660327 100644
--- a/drivers/media/dvb-frontends/drxk.h
+++ b/drivers/media/dvb-frontends/drxk.h
@@ -29,7 +29,6 @@
  *				A value of 0 (default) or lower indicates that
  *				the correct number of parameters will be
  *				automatically detected.
- * @load_firmware_sync:		Force the firmware load to be synchronous.
  *
  * On the *_gpio vars, bit 0 is UIO-1, bit 1 is UIO-2 and bit 2 is
  * UIO-3.
@@ -41,7 +40,6 @@ struct drxk_config {
 	bool	parallel_ts;
 	bool	dynamic_clk;
 	bool	enable_merr_cfg;
-	bool	load_firmware_sync;
 
 	bool	antenna_dvbt;
 	u16	antenna_gpio;
diff --git a/drivers/media/dvb-frontends/drxk_hard.c b/drivers/media/dvb-frontends/drxk_hard.c
index bf29a3f0e6f0..cce94a75b2e1 100644
--- a/drivers/media/dvb-frontends/drxk_hard.c
+++ b/drivers/media/dvb-frontends/drxk_hard.c
@@ -6830,25 +6830,13 @@ struct dvb_frontend *drxk_attach(const struct drxk_config *config,
 
 	/* Load firmware and initialize DRX-K */
 	if (state->microcode_name) {
-		if (config->load_firmware_sync) {
-			const struct firmware *fw = NULL;
+		const struct firmware *fw = NULL;
 
-			status = request_firmware(&fw, state->microcode_name,
-						  state->i2c->dev.parent);
-			if (status < 0)
-				fw = NULL;
-			load_firmware_cb(fw, state);
-		} else {
-			status = request_firmware_nowait(THIS_MODULE, 1,
-					      state->microcode_name,
-					      state->i2c->dev.parent,
-					      GFP_KERNEL,
-					      state, load_firmware_cb);
-			if (status < 0) {
-				pr_err("failed to request a firmware\n");
-				return NULL;
-			}
-		}
+		status = request_firmware(&fw, state->microcode_name,
+					  state->i2c->dev.parent);
+		if (status < 0)
+			fw = NULL;
+		load_firmware_cb(fw, state);
 	} else if (init_drxk(state) < 0)
 		goto error;
 
diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index 7ba209de57dd..00a9611b5228 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -375,7 +375,6 @@ static struct drxk_config terratec_h5_drxk = {
 	.no_i2c_bridge = 1,
 	.microcode_name = "dvb-usb-terratec-h5-drxk.fw",
 	.qam_demod_parameter_count = 2,
-	.load_firmware_sync = true,
 };
 
 static struct drxk_config hauppauge_930c_drxk = {
@@ -385,7 +384,6 @@ static struct drxk_config hauppauge_930c_drxk = {
 	.microcode_name = "dvb-usb-hauppauge-hvr930c-drxk.fw",
 	.chunk_size = 56,
 	.qam_demod_parameter_count = 2,
-	.load_firmware_sync = true,
 };
 
 static struct drxk_config terratec_htc_stick_drxk = {
@@ -399,7 +397,6 @@ static struct drxk_config terratec_htc_stick_drxk = {
 	.antenna_dvbt = true,
 	/* The windows driver uses the same. This will disable LNA. */
 	.antenna_gpio = 0x6,
-	.load_firmware_sync = true,
 };
 
 static struct drxk_config maxmedia_ub425_tc_drxk = {
@@ -408,7 +405,6 @@ static struct drxk_config maxmedia_ub425_tc_drxk = {
 	.no_i2c_bridge = 1,
 	.microcode_name = "dvb-demod-drxk-01.fw",
 	.chunk_size = 62,
-	.load_firmware_sync = true,
 	.qam_demod_parameter_count = 2,
 };
 
@@ -420,7 +416,6 @@ static struct drxk_config pctv_520e_drxk = {
 	.chunk_size = 58,
 	.antenna_dvbt = true, /* disable LNA */
 	.antenna_gpio = (1 << 2), /* disable LNA */
-	.load_firmware_sync = true,
 };
 
 static int drxk_gate_ctrl(struct dvb_frontend *fe, int enable)
-- 
1.8.3.1

