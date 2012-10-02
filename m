Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35347 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751016Ab2JBTFV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Oct 2012 15:05:21 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q92J5Lb0000326
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 2 Oct 2012 15:05:21 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 1/2] drxk: allow loading firmware synchrousnously
Date: Tue,  2 Oct 2012 16:05:15 -0300
Message-Id: <1349204716-25971-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Due to udev-182, the firmware load was changed to be async, as
otherwise udev would give up of loading a firmware.

Add an option to return to the previous behaviour, async firmware
loads cause failures with the tda18271 driver.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb-frontends/drxk.h      |  2 ++
 drivers/media/dvb-frontends/drxk_hard.c | 20 +++++++++++++++-----
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/media/dvb-frontends/drxk.h b/drivers/media/dvb-frontends/drxk.h
index d615d7d..94fecfb 100644
--- a/drivers/media/dvb-frontends/drxk.h
+++ b/drivers/media/dvb-frontends/drxk.h
@@ -28,6 +28,7 @@
  *				A value of 0 (default) or lower indicates that
  *				the correct number of parameters will be
  *				automatically detected.
+ * @load_firmware_sync:		Force the firmware load to be synchronous.
  *
  * On the *_gpio vars, bit 0 is UIO-1, bit 1 is UIO-2 and bit 2 is
  * UIO-3.
@@ -39,6 +40,7 @@ struct drxk_config {
 	bool	parallel_ts;
 	bool	dynamic_clk;
 	bool	enable_merr_cfg;
+	bool	load_firmware_sync;
 
 	bool	antenna_dvbt;
 	u16	antenna_gpio;
diff --git a/drivers/media/dvb-frontends/drxk_hard.c b/drivers/media/dvb-frontends/drxk_hard.c
index 1ab8154..8b4c6d5 100644
--- a/drivers/media/dvb-frontends/drxk_hard.c
+++ b/drivers/media/dvb-frontends/drxk_hard.c
@@ -6609,15 +6609,25 @@ struct dvb_frontend *drxk_attach(const struct drxk_config *config,
 
 	/* Load firmware and initialize DRX-K */
 	if (state->microcode_name) {
-		status = request_firmware_nowait(THIS_MODULE, 1,
+		if (config->load_firmware_sync) {
+			const struct firmware *fw = NULL;
+
+			status = request_firmware(&fw, state->microcode_name,
+						  state->i2c->dev.parent);
+			if (status < 0)
+				fw = NULL;
+			load_firmware_cb(fw, state);
+		} else {
+			status = request_firmware_nowait(THIS_MODULE, 1,
 					      state->microcode_name,
 					      state->i2c->dev.parent,
 					      GFP_KERNEL,
 					      state, load_firmware_cb);
-		if (status < 0) {
-			printk(KERN_ERR
-			"drxk: failed to request a firmware\n");
-			return NULL;
+			if (status < 0) {
+				printk(KERN_ERR
+				       "drxk: failed to request a firmware\n");
+				return NULL;
+			}
 		}
 	} else if (init_drxk(state) < 0)
 		goto error;
-- 
1.7.11.4

