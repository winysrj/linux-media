Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-1.atlantis.sk ([80.94.52.57]:39666 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754176Ab3BDU2J (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Feb 2013 15:28:09 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH] tda8290: change magic LNA config values to enum
Date: Mon, 4 Feb 2013 21:27:43 +0100
Cc: Michael Krufky <mkrufky@linuxtv.org>, linux-media@vger.kernel.org
References: <1359750087-1155-1-git-send-email-linux@rainbow-software.org> <CAOcJUbwyh7_Mh+-dGWbTzUNcdbS4gtV2Hch0-oKdfZydJm42XQ@mail.gmail.com> <20130204114347.0c28af10@redhat.com>
In-Reply-To: <20130204114347.0c28af10@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201302042127.44961.linux@rainbow-software.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use enum instead of magic values for LNA config in tda8290.
Update tda827x, tda18271 and saa7134 to use the enum too.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/media/pci/saa7134/saa7134-cards.c |   41 +++++++++++++++--------------
 drivers/media/tuners/tda18271-fe.c        |    9 +++---
 drivers/media/tuners/tda827x.c            |   10 +++---
 drivers/media/tuners/tda827x.h            |    3 +-
 drivers/media/tuners/tda8290.c            |    3 +-
 drivers/media/tuners/tda8290.h            |    9 +++++-
 6 files changed, 43 insertions(+), 32 deletions(-)

diff --git a/drivers/media/pci/saa7134/saa7134-cards.c b/drivers/media/pci/saa7134/saa7134-cards.c
index c603064..f8069f5 100644
--- a/drivers/media/pci/saa7134/saa7134-cards.c
+++ b/drivers/media/pci/saa7134/saa7134-cards.c
@@ -2765,7 +2765,7 @@ struct saa7134_board saa7134_boards[] = {
 		.radio_type     = UNSET,
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
-		.tda829x_conf   = { .lna_cfg = 0 },
+		.tda829x_conf   = { .lna_cfg = TDA8290_LNA_OFF },
 		.mpeg           = SAA7134_MPEG_DVB,
 		.gpiomask       = 0x0200000,
 		.inputs = {{
@@ -3296,7 +3296,7 @@ struct saa7134_board saa7134_boards[] = {
 		.radio_type     = UNSET,
 		.tuner_addr     = ADDR_UNSET,
 		.radio_addr     = ADDR_UNSET,
-		.tda829x_conf   = { .lna_cfg = 1 },
+		.tda829x_conf   = { .lna_cfg = TDA8290_LNA_GP0_HIGH_ON },
 		.mpeg           = SAA7134_MPEG_DVB,
 		.gpiomask       = 0x000200000,
 		.inputs         = {{
@@ -3400,7 +3400,7 @@ struct saa7134_board saa7134_boards[] = {
 		.radio_type     = UNSET,
 		.tuner_addr     = ADDR_UNSET,
 		.radio_addr     = ADDR_UNSET,
-		.tda829x_conf   = { .lna_cfg = 1 },
+		.tda829x_conf   = { .lna_cfg = TDA8290_LNA_GP0_HIGH_ON },
 		.mpeg           = SAA7134_MPEG_DVB,
 		.gpiomask       = 0x0200100,
 		.inputs         = {{
@@ -3431,7 +3431,7 @@ struct saa7134_board saa7134_boards[] = {
 		.radio_type     = UNSET,
 		.tuner_addr     = ADDR_UNSET,
 		.radio_addr     = ADDR_UNSET,
-		.tda829x_conf   = { .lna_cfg = 3 },
+		.tda829x_conf   = { .lna_cfg = TDA8290_LNA_ON_BRIDGE },
 		.mpeg           = SAA7134_MPEG_DVB,
 		.ts_type	= SAA7134_MPEG_TS_SERIAL,
 		.ts_force_val   = 1,
@@ -3464,7 +3464,7 @@ struct saa7134_board saa7134_boards[] = {
 		.radio_type     = UNSET,
 		.tuner_addr     = ADDR_UNSET,
 		.radio_addr     = ADDR_UNSET,
-		.tda829x_conf   = { .lna_cfg = 3 },
+		.tda829x_conf   = { .lna_cfg = TDA8290_LNA_ON_BRIDGE },
 		.mpeg           = SAA7134_MPEG_DVB,
 		.ts_type	= SAA7134_MPEG_TS_SERIAL,
 		.gpiomask       = 0x0800100, /* GPIO 21 is an INPUT */
@@ -3688,7 +3688,7 @@ struct saa7134_board saa7134_boards[] = {
 		.radio_type     = UNSET,
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
-		.tda829x_conf   = { .lna_cfg = 2 },
+		.tda829x_conf   = { .lna_cfg = TDA8290_LNA_GP0_HIGH_OFF },
 		.mpeg           = SAA7134_MPEG_DVB,
 		.gpiomask       = 0x0200000,
 		.inputs = {{
@@ -3741,7 +3741,7 @@ struct saa7134_board saa7134_boards[] = {
 		.radio_type     = UNSET,
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
-		.tda829x_conf   = { .lna_cfg = 2 },
+		.tda829x_conf   = { .lna_cfg = TDA8290_LNA_GP0_HIGH_OFF },
 		.mpeg           = SAA7134_MPEG_DVB,
 		.gpiomask       = 0x0200000,
 		.inputs = {{
@@ -3759,7 +3759,7 @@ struct saa7134_board saa7134_boards[] = {
 		.radio_type     = UNSET,
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
-		.tda829x_conf   = { .lna_cfg = 2 },
+		.tda829x_conf   = { .lna_cfg = TDA8290_LNA_GP0_HIGH_OFF },
 		.gpiomask	= 1 << 21,
 		.mpeg           = SAA7134_MPEG_DVB,
 		.inputs         = {{
@@ -3892,7 +3892,7 @@ struct saa7134_board saa7134_boards[] = {
 		.radio_type     = UNSET,
 		.tuner_addr     = ADDR_UNSET,
 		.radio_addr     = ADDR_UNSET,
-		.tda829x_conf   = { .lna_cfg = 0 },
+		.tda829x_conf   = { .lna_cfg = TDA8290_LNA_OFF },
 		.mpeg           = SAA7134_MPEG_DVB,
 		.inputs = {{
 			.name   = name_tv, /* FIXME: analog tv untested */
@@ -3908,7 +3908,7 @@ struct saa7134_board saa7134_boards[] = {
 		.radio_type     = UNSET,
 		.tuner_addr     = ADDR_UNSET,
 		.radio_addr     = ADDR_UNSET,
-		.tda829x_conf   = { .lna_cfg = 2 },
+		.tda829x_conf   = { .lna_cfg = TDA8290_LNA_GP0_HIGH_OFF },
 		.gpiomask       = 0x020200000,
 		.inputs         = {{
 			.name = name_tv,
@@ -3942,7 +3942,7 @@ struct saa7134_board saa7134_boards[] = {
 		.radio_type	= UNSET,
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
-		.tda829x_conf	= { .lna_cfg = 0 },
+		.tda829x_conf	= { .lna_cfg = TDA8290_LNA_OFF },
 		.gpiomask	= 0x020200000,
 		.inputs		= {{
 			.name = name_tv,
@@ -4742,7 +4742,7 @@ struct saa7134_board saa7134_boards[] = {
 		.radio_type     = UNSET,
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
-		.tda829x_conf   = { .lna_cfg = 2 },
+		.tda829x_conf   = { .lna_cfg = TDA8290_LNA_GP0_HIGH_OFF },
 		.mpeg           = SAA7134_MPEG_DVB,
 		.gpiomask       = 0x0200000,
 		.inputs = {{
@@ -4828,7 +4828,7 @@ struct saa7134_board saa7134_boards[] = {
 		.radio_type   = UNSET,
 		.tuner_addr   = ADDR_UNSET,
 		.radio_addr   = ADDR_UNSET,
-		.tda829x_conf = { .lna_cfg = 0 },
+		.tda829x_conf = { .lna_cfg = TDA8290_LNA_OFF },
 		.mpeg         = SAA7134_MPEG_DVB,
 		.inputs       = {{
 			.name = name_tv,
@@ -4852,7 +4852,7 @@ struct saa7134_board saa7134_boards[] = {
 		.radio_type     = UNSET,
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
-		.tda829x_conf   = { .lna_cfg = 2 },
+		.tda829x_conf   = { .lna_cfg = TDA8290_LNA_GP0_HIGH_OFF },
 		.mpeg           = SAA7134_MPEG_DVB,
 		.gpiomask       = 0x0200000,
 		.inputs = { {
@@ -5062,7 +5062,7 @@ struct saa7134_board saa7134_boards[] = {
 		.radio_type     = UNSET,
 		.tuner_addr     = ADDR_UNSET,
 		.radio_addr     = ADDR_UNSET,
-		.tda829x_conf   = { .lna_cfg = 2 },
+		.tda829x_conf   = { .lna_cfg = TDA8290_LNA_GP0_HIGH_OFF },
 		.gpiomask       = 1 << 21,
 		.mpeg           = SAA7134_MPEG_DVB,
 		.inputs         = {{
@@ -5092,7 +5092,7 @@ struct saa7134_board saa7134_boards[] = {
 		.radio_type     = UNSET,
 		.tuner_addr     = ADDR_UNSET,
 		.radio_addr     = ADDR_UNSET,
-		.tda829x_conf   = { .lna_cfg = 2 },
+		.tda829x_conf   = { .lna_cfg = TDA8290_LNA_GP0_HIGH_OFF },
 		.gpiomask       = 1 << 21,
 		.mpeg           = SAA7134_MPEG_DVB,
 		.inputs         = {{
@@ -5181,7 +5181,7 @@ struct saa7134_board saa7134_boards[] = {
 		.radio_type     = UNSET,
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
-		.tda829x_conf   = { .lna_cfg = 0 },
+		.tda829x_conf   = { .lna_cfg = TDA8290_LNA_OFF },
 		.mpeg           = SAA7134_MPEG_DVB,
 		.gpiomask       = 0x0200000,
 		.inputs = { {
@@ -5411,7 +5411,7 @@ struct saa7134_board saa7134_boards[] = {
 		.radio_type     = UNSET,
 		.tuner_addr     = ADDR_UNSET,
 		.radio_addr     = ADDR_UNSET,
-		.tda829x_conf   = { .lna_cfg = 0 },
+		.tda829x_conf   = { .lna_cfg = TDA8290_LNA_OFF },
 		.mpeg           = SAA7134_MPEG_DVB,
 		.ts_type	= SAA7134_MPEG_TS_PARALLEL,
 		.inputs         = {{
@@ -5634,7 +5634,7 @@ struct saa7134_board saa7134_boards[] = {
 		.audio_clock	= 0x00187de7,
 		.tuner_type	= TUNER_PHILIPS_TDA8290,
 		.radio_type	= UNSET,
-		.tda829x_conf	= { .lna_cfg = 3 },
+		.tda829x_conf	= { .lna_cfg = TDA8290_LNA_ON_BRIDGE },
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
 		.gpiomask	= 0x02050000,
@@ -5785,7 +5785,8 @@ struct saa7134_board saa7134_boards[] = {
 		.radio_type     = UNSET,
 		.tuner_addr     = ADDR_UNSET,
 		.radio_addr     = ADDR_UNSET,
-		.tda829x_conf   = { .lna_cfg = 0, .no_i2c_gate = 1,
+		.tda829x_conf   = { .lna_cfg = TDA8290_LNA_OFF,
+				    .no_i2c_gate = 1,
 				    .tda18271_std_map = &aver_a706_std_map },
 		.gpiomask       = 1 << 11,
 		.mpeg           = SAA7134_MPEG_DVB,
diff --git a/drivers/media/tuners/tda18271-fe.c b/drivers/media/tuners/tda18271-fe.c
index 72c26fd..e3f6aa2 100644
--- a/drivers/media/tuners/tda18271-fe.c
+++ b/drivers/media/tuners/tda18271-fe.c
@@ -21,6 +21,7 @@
 #include <linux/delay.h>
 #include <linux/videodev2.h>
 #include "tda18271-priv.h"
+#include "tda8290.h"
 
 int tda18271_debug;
 module_param_named(debug, tda18271_debug, int, 0644);
@@ -867,12 +868,12 @@ static int tda18271_agc(struct dvb_frontend *fe)
 	int ret = 0;
 
 	switch (priv->config) {
-	case 0:
+	case TDA8290_LNA_OFF:
 		/* no external agc configuration required */
 		if (tda18271_debug & DBG_ADV)
 			tda_dbg("no agc configuration provided\n");
 		break;
-	case 3:
+	case TDA8290_LNA_ON_BRIDGE:
 		/* switch with GPIO of saa713x */
 		tda_dbg("invoking callback\n");
 		if (fe->callback)
@@ -881,8 +882,8 @@ static int tda18271_agc(struct dvb_frontend *fe)
 					   TDA18271_CALLBACK_CMD_AGC_ENABLE,
 					   priv->mode);
 		break;
-	case 1:
-	case 2:
+	case TDA8290_LNA_GP0_HIGH_ON:
+	case TDA8290_LNA_GP0_HIGH_OFF:
 	default:
 		/* n/a - currently not supported */
 		tda_err("unsupported configuration: %d\n", priv->config);
diff --git a/drivers/media/tuners/tda827x.c b/drivers/media/tuners/tda827x.c
index a0d1762..73453a2 100644
--- a/drivers/media/tuners/tda827x.c
+++ b/drivers/media/tuners/tda827x.c
@@ -479,10 +479,10 @@ static void tda827xa_lna_gain(struct dvb_frontend *fe, int high,
 			dprintk("setting LNA to low gain\n");
 	}
 	switch (priv->cfg->config) {
-	case 0: /* no LNA */
+	case TDA8290_LNA_OFF: /* no LNA */
 		break;
-	case 1: /* switch is GPIO 0 of tda8290 */
-	case 2:
+	case TDA8290_LNA_GP0_HIGH_ON: /* switch is GPIO 0 of tda8290 */
+	case TDA8290_LNA_GP0_HIGH_OFF:
 		if (params == NULL) {
 			gp_func = 0;
 			arg  = 0;
@@ -499,11 +499,11 @@ static void tda827xa_lna_gain(struct dvb_frontend *fe, int high,
 				     DVB_FRONTEND_COMPONENT_TUNER,
 				     gp_func, arg);
 		buf[1] = high ? 0 : 1;
-		if (priv->cfg->config == 2)
+		if (priv->cfg->config == TDA8290_LNA_GP0_HIGH_OFF)
 			buf[1] = high ? 1 : 0;
 		tuner_transfer(fe, &msg, 1);
 		break;
-	case 3: /* switch with GPIO of saa713x */
+	case TDA8290_LNA_ON_BRIDGE: /* switch with GPIO of saa713x */
 		if (fe->callback)
 			fe->callback(priv->i2c_adap->algo_data,
 				     DVB_FRONTEND_COMPONENT_TUNER, 0, high);
diff --git a/drivers/media/tuners/tda827x.h b/drivers/media/tuners/tda827x.h
index 7d72ce0..080b4bd 100644
--- a/drivers/media/tuners/tda827x.h
+++ b/drivers/media/tuners/tda827x.h
@@ -26,6 +26,7 @@
 
 #include <linux/i2c.h>
 #include "dvb_frontend.h"
+#include "tda8290.h"
 
 struct tda827x_config
 {
@@ -34,7 +35,7 @@ struct tda827x_config
 	int (*sleep) (struct dvb_frontend *fe);
 
 	/* interface to tda829x driver */
-	unsigned int config;
+	enum tda8290_lna config;
 	int 	     switch_addr;
 
 	void (*agcf)(struct dvb_frontend *fe);
diff --git a/drivers/media/tuners/tda8290.c b/drivers/media/tuners/tda8290.c
index c1ade88..20cc7da 100644
--- a/drivers/media/tuners/tda8290.c
+++ b/drivers/media/tuners/tda8290.c
@@ -496,7 +496,8 @@ static void tda8290_init_if(struct dvb_frontend *fe)
 	unsigned char set_GP00_CF[] = { 0x20, 0x01 };
 	unsigned char set_GP01_CF[] = { 0x20, 0x0B };
 
-	if ((priv->cfg.config == 1) || (priv->cfg.config == 2))
+	if ((priv->cfg.config == TDA8290_LNA_GP0_HIGH_ON) ||
+	    (priv->cfg.config == TDA8290_LNA_GP0_HIGH_OFF))
 		tuner_i2c_xfer_send(&priv->i2c_props, set_GP00_CF, 2);
 	else
 		tuner_i2c_xfer_send(&priv->i2c_props, set_GP01_CF, 2);
diff --git a/drivers/media/tuners/tda8290.h b/drivers/media/tuners/tda8290.h
index 280b70d..d3a3754 100644
--- a/drivers/media/tuners/tda8290.h
+++ b/drivers/media/tuners/tda8290.h
@@ -21,8 +21,15 @@
 #include "dvb_frontend.h"
 #include "tda18271.h"
 
+enum tda8290_lna {
+	TDA8290_LNA_OFF = 0,
+	TDA8290_LNA_GP0_HIGH_ON = 1,
+	TDA8290_LNA_GP0_HIGH_OFF = 2,
+	TDA8290_LNA_ON_BRIDGE = 3,
+};
+
 struct tda829x_config {
-	unsigned int lna_cfg;
+	enum tda8290_lna lna_cfg;
 
 	unsigned int probe_tuner:1;
 #define TDA829X_PROBE_TUNER 0
-- 
Ondrej Zary
