Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49302 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753750AbaCCKHt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Mar 2014 05:07:49 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [PATCH 04/79] [media] drx-j: Fix compilation and un-comment it
Date: Mon,  3 Mar 2014 07:05:58 -0300
Message-Id: <1393841233-24840-5-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
References: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mauro Carvalho Chehab <mchehab@redhat.com>

There were some DVB internal API changes, since this driver were
written. Change it to work with the new API.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/drx39xyj/Kconfig    |  1 -
 drivers/media/dvb-frontends/drx39xyj/Makefile   |  3 +++
 drivers/media/dvb-frontends/drx39xyj/drx39xxj.c | 16 ++++------------
 drivers/media/usb/em28xx/Kconfig                |  1 +
 4 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/media/dvb-frontends/drx39xyj/Kconfig b/drivers/media/dvb-frontends/drx39xyj/Kconfig
index 5bcf6b4cb74a..15628eb5cf0c 100644
--- a/drivers/media/dvb-frontends/drx39xyj/Kconfig
+++ b/drivers/media/dvb-frontends/drx39xyj/Kconfig
@@ -2,7 +2,6 @@ config DVB_DRX39XYJ
 	tristate "Micronas DRX-J demodulator"
 	depends on DVB_CORE && I2C
 	default m if DVB_FE_CUSTOMISE
-	depends on BROKEN
 	help
 	  An ATSC 8VSB and QAM64/256 tuner module. Say Y when you want
 	  to support this frontend.
diff --git a/drivers/media/dvb-frontends/drx39xyj/Makefile b/drivers/media/dvb-frontends/drx39xyj/Makefile
index b44dc3710229..f84c5d87d771 100644
--- a/drivers/media/dvb-frontends/drx39xyj/Makefile
+++ b/drivers/media/dvb-frontends/drx39xyj/Makefile
@@ -1,3 +1,6 @@
 drx39xyj-objs := drx39xxj.o drx_driver.o drx39xxj_dummy.o drxj.o drx_dap_fasi.o
 
 obj-$(CONFIG_DVB_DRX39XYJ) += drx39xyj.o
+
+ccflags-y += -I$(srctree)/drivers/media/dvb-core/
+ccflags-y += -I$(srctree)/drivers/media/tuners/
diff --git a/drivers/media/dvb-frontends/drx39xyj/drx39xxj.c b/drivers/media/dvb-frontends/drx39xyj/drx39xxj.c
index 6c8c8456cb05..7f9cff1d8413 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx39xxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drx39xxj.c
@@ -175,18 +175,12 @@ static int drx39xxj_read_ucblocks(struct dvb_frontend *fe, u32 * ucblocks)
 	return 0;
 }
 
-static int drx39xxj_get_frontend(struct dvb_frontend *fe,
-				 struct dvb_frontend_parameters *p)
-{
-	return 0;
-}
-
-static int drx39xxj_set_frontend(struct dvb_frontend *fe,
-				 struct dvb_frontend_parameters *p)
+static int drx39xxj_set_frontend(struct dvb_frontend *fe)
 {
 #ifdef DJH_DEBUG
 	int i;
 #endif
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct drx39xxj_state *state = fe->demodulator_priv;
 	DRXDemodInstance_t *demod = state->demod;
 	DRXStandard_t standard = DRX_STANDARD_8VSB;
@@ -217,7 +211,7 @@ static int drx39xxj_set_frontend(struct dvb_frontend *fe,
 	if (fe->ops.tuner_ops.set_params) {
 		if (fe->ops.i2c_gate_ctrl)
 			fe->ops.i2c_gate_ctrl(fe, 1);
-		fe->ops.tuner_ops.set_params(fe, p);
+		fe->ops.tuner_ops.set_params(fe);
 		if (fe->ops.i2c_gate_ctrl)
 			fe->ops.i2c_gate_ctrl(fe, 0);
 	}
@@ -426,10 +420,9 @@ error:
 }
 
 static struct dvb_frontend_ops drx39xxj_ops = {
-
+	.delsys = { SYS_ATSC, SYS_DVBC_ANNEX_B },
 	.info = {
 		 .name = "Micronas DRX39xxj family Frontend",
-		 .type = FE_ATSC | FE_QAM,
 		 .frequency_stepsize = 62500,
 		 .frequency_min = 51000000,
 		 .frequency_max = 858000000,
@@ -439,7 +432,6 @@ static struct dvb_frontend_ops drx39xxj_ops = {
 	.i2c_gate_ctrl = drx39xxj_i2c_gate_ctrl,
 	.sleep = drx39xxj_sleep,
 	.set_frontend = drx39xxj_set_frontend,
-	.get_frontend = drx39xxj_get_frontend,
 	.get_tune_settings = drx39xxj_get_tune_settings,
 	.read_status = drx39xxj_read_status,
 	.read_ber = drx39xxj_read_ber,
diff --git a/drivers/media/usb/em28xx/Kconfig b/drivers/media/usb/em28xx/Kconfig
index a1fccf3096de..7fb02875a1e6 100644
--- a/drivers/media/usb/em28xx/Kconfig
+++ b/drivers/media/usb/em28xx/Kconfig
@@ -55,6 +55,7 @@ config VIDEO_EM28XX_DVB
 	select MEDIA_TUNER_TDA18271 if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_M88DS3103 if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_M88TS2022 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_DRX39XYJ if MEDIA_SUBDRV_AUTOSELECT
 	---help---
 	  This adds support for DVB cards based on the
 	  Empiatech em28xx chips.
-- 
1.8.5.3

