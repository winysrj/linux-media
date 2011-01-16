Return-path: <mchehab@pedra>
Received: from skyboo.net ([82.160.187.4]:35242 "EHLO skyboo.net"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753666Ab1APUpI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Jan 2011 15:45:08 -0500
Message-ID: <4D3358C5.5080706@skyboo.net>
Date: Sun, 16 Jan 2011 21:44:53 +0100
From: Mariusz Bialonczyk <manio@skyboo.net>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Subject: [PATCH] Prof 7301: switching frontend to stv090x, fixing "LOCK FAILED"
 issue
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Fixing the very annoying tunning issue. When switching from DVB-S2 to DVB-S,
it often took minutes to have a lock.
This issue is known to Igor M. Liplianin and was also reported ie. in the
following posts:
http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/24573
http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/25275

The patch is changing the frontend from stv0900 to stv090x.
The card now works much more reliable. There is no problem with switching
from DVB-S2 to DVB-S, tunning works flawless.

Signed-off-by: Mariusz Bialonczyk <manio@skyboo.net>
Tested-by: Warpme <warpme@o2.pl>
---
 drivers/media/video/cx88/Kconfig           |    2 +-
 drivers/media/video/cx88/cx88-dvb.c        |   56 ++++++++++++----------------
 2 files changed, 25 insertions(+), 33 deletions(-)

diff --git a/drivers/media/video/cx88/Kconfig b/drivers/media/video/cx88/Kconfig
index 5c42abd..57316bb 100644
--- a/drivers/media/video/cx88/Kconfig
+++ b/drivers/media/video/cx88/Kconfig
@@ -60,7 +60,7 @@ config VIDEO_CX88_DVB
 	select DVB_STV0299 if !DVB_FE_CUSTOMISE
 	select DVB_STV0288 if !DVB_FE_CUSTOMISE
 	select DVB_STB6000 if !DVB_FE_CUSTOMISE
-	select DVB_STV0900 if !DVB_FE_CUSTOMISE
+	select DVB_STV090x if !DVB_FE_CUSTOMISE
 	select DVB_STB6100 if !DVB_FE_CUSTOMISE
 	select MEDIA_TUNER_SIMPLE if !MEDIA_TUNER_CUSTOMISE
 	---help---
diff --git a/drivers/media/video/cx88/cx88-dvb.c b/drivers/media/video/cx88/cx88-dvb.c
index 90717ee..3f25872 100644
--- a/drivers/media/video/cx88/cx88-dvb.c
+++ b/drivers/media/video/cx88/cx88-dvb.c
@@ -53,9 +53,9 @@
 #include "stv0288.h"
 #include "stb6000.h"
 #include "cx24116.h"
-#include "stv0900.h"
+#include "stv090x.h"
 #include "stb6100.h"
-#include "stb6100_proc.h"
+#include "stb6100_cfg.h"
 #include "mb86a16.h"
 
 MODULE_DESCRIPTION("driver for cx2388x based DVB cards");
@@ -611,15 +611,6 @@ static int cx24116_set_ts_param(struct dvb_frontend *fe,
 	return 0;
 }
 
-static int stv0900_set_ts_param(struct dvb_frontend *fe,
-	int is_punctured)
-{
-	struct cx8802_dev *dev = fe->dvb->priv;
-	dev->ts_gen_cntrl = 0;
-
-	return 0;
-}
-
 static int cx24116_reset_device(struct dvb_frontend *fe)
 {
 	struct cx8802_dev *dev = fe->dvb->priv;
@@ -648,16 +639,21 @@ static const struct cx24116_config tevii_s460_config = {
 	.reset_device  = cx24116_reset_device,
 };
 
-static const struct stv0900_config prof_7301_stv0900_config = {
-	.demod_address = 0x6a,
-/*	demod_mode = 0,*/
-	.xtal = 27000000,
-	.clkmode = 3,/* 0-CLKI, 2-XTALI, else AUTO */
-	.diseqc_mode = 2,/* 2/3 PWM */
-	.tun1_maddress = 0,/* 0x60 */
-	.tun1_adc = 0,/* 2 Vpp */
-	.path1_mode = 3,
-	.set_ts_params = stv0900_set_ts_param,
+static struct stv090x_config prof_7301_stv090x_config = {
+        .device                 = STV0903,
+        .demod_mode             = STV090x_SINGLE,
+        .clk_mode               = STV090x_CLK_EXT,
+        .xtal                   = 27000000,
+        .address                = 0x6A,
+        .ts1_mode               = STV090x_TSMODE_PARALLEL_PUNCTURED,
+        .repeater_level         = STV090x_RPTLEVEL_64,
+        .adc1_range             = STV090x_ADC_2Vpp,
+        .diseqc_envelope_mode   = false,
+
+        .tuner_get_frequency    = stb6100_get_frequency,
+        .tuner_set_frequency    = stb6100_set_frequency,
+        .tuner_set_bandwidth    = stb6100_set_bandwidth,
+        .tuner_get_bandwidth    = stb6100_get_bandwidth,
 };
 
 static const struct stb6100_config prof_7301_stb6100_config = {
@@ -1402,23 +1398,19 @@ static int dvb_register(struct cx8802_dev *dev)
 		}
 		break;
 	case CX88_BOARD_PROF_7301:{
-		struct dvb_tuner_ops *tuner_ops = NULL;
+		dev->ts_gen_cntrl = 0x00;
 
-		fe0->dvb.frontend = dvb_attach(stv0900_attach,
-						&prof_7301_stv0900_config,
-						&core->i2c_adap, 0);
+		fe0->dvb.frontend = dvb_attach(stv090x_attach,
+						&prof_7301_stv090x_config,
+						&core->i2c_adap,
+						STV090x_DEMODULATOR_0);
 		if (fe0->dvb.frontend != NULL) {
-			if (!dvb_attach(stb6100_attach, fe0->dvb.frontend,
+			if (!dvb_attach(stb6100_attach,
+					fe0->dvb.frontend,
 					&prof_7301_stb6100_config,
 					&core->i2c_adap))
 				goto frontend_detach;
 
-			tuner_ops = &fe0->dvb.frontend->ops.tuner_ops;
-			tuner_ops->set_frequency = stb6100_set_freq;
-			tuner_ops->get_frequency = stb6100_get_freq;
-			tuner_ops->set_bandwidth = stb6100_set_bandw;
-			tuner_ops->get_bandwidth = stb6100_get_bandw;
-
 			core->prev_set_voltage =
 					fe0->dvb.frontend->ops.set_voltage;
 			fe0->dvb.frontend->ops.set_voltage =

-- 
Mariusz Bialonczyk
jabber/e-mail: manio@skyboo.net
http://manio.skyboo.net
