Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:51612 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752215AbbLFPqf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 6 Dec 2015 10:46:35 -0500
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
	Maxime Coquelin <maxime.coquelin@st.com>,
	Patrice Chotard <patrice.chotard@st.com>,
	linux-arm-kernel@lists.infradead.org, kernel@stlinux.com
Subject: [PATCH] [media] constify stv6110x_devctl structure
Date: Sun,  6 Dec 2015 16:34:26 +0100
Message-Id: <1449416066-1202-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The stv6110x_devctl structure is never modified, so declare is as
const.

Done with the help of Coccinelle.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/media/dvb-frontends/stv6110x.c               |    4 ++--
 drivers/media/dvb-frontends/stv6110x.h               |    4 ++--
 drivers/media/dvb-frontends/stv6110x_priv.h          |    2 +-
 drivers/media/pci/ddbridge/ddbridge-core.c           |    2 +-
 drivers/media/pci/ngene/ngene-cards.c                |    2 +-
 drivers/media/pci/ttpci/budget.c                     |    4 ++--
 drivers/media/platform/sti/c8sectpfe/c8sectpfe-dvb.c |    2 +-
 drivers/media/usb/dvb-usb/technisat-usb2.c           |    2 +-
 8 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/media/dvb-frontends/stv6110x.c b/drivers/media/dvb-frontends/stv6110x.c
index e66154e..a62c01e 100644
--- a/drivers/media/dvb-frontends/stv6110x.c
+++ b/drivers/media/dvb-frontends/stv6110x.c
@@ -355,7 +355,7 @@ static struct dvb_tuner_ops stv6110x_ops = {
 	.release		= stv6110x_release
 };
 
-static struct stv6110x_devctl stv6110x_ctl = {
+static const struct stv6110x_devctl stv6110x_ctl = {
 	.tuner_init		= stv6110x_init,
 	.tuner_sleep		= stv6110x_sleep,
 	.tuner_set_mode		= stv6110x_set_mode,
@@ -369,7 +369,7 @@ static struct stv6110x_devctl stv6110x_ctl = {
 	.tuner_get_status	= stv6110x_get_status,
 };
 
-struct stv6110x_devctl *stv6110x_attach(struct dvb_frontend *fe,
+const struct stv6110x_devctl *stv6110x_attach(struct dvb_frontend *fe,
 					const struct stv6110x_config *config,
 					struct i2c_adapter *i2c)
 {
diff --git a/drivers/media/dvb-frontends/stv6110x.h b/drivers/media/dvb-frontends/stv6110x.h
index 9f7eb25..696b6e5 100644
--- a/drivers/media/dvb-frontends/stv6110x.h
+++ b/drivers/media/dvb-frontends/stv6110x.h
@@ -55,12 +55,12 @@ struct stv6110x_devctl {
 
 #if IS_REACHABLE(CONFIG_DVB_STV6110x)
 
-extern struct stv6110x_devctl *stv6110x_attach(struct dvb_frontend *fe,
+extern const struct stv6110x_devctl *stv6110x_attach(struct dvb_frontend *fe,
 					       const struct stv6110x_config *config,
 					       struct i2c_adapter *i2c);
 
 #else
-static inline struct stv6110x_devctl *stv6110x_attach(struct dvb_frontend *fe,
+static inline const struct stv6110x_devctl *stv6110x_attach(struct dvb_frontend *fe,
 						      const struct stv6110x_config *config,
 						      struct i2c_adapter *i2c)
 {
diff --git a/drivers/media/dvb-frontends/stv6110x_priv.h b/drivers/media/dvb-frontends/stv6110x_priv.h
index 0ec936a..a993aba 100644
--- a/drivers/media/dvb-frontends/stv6110x_priv.h
+++ b/drivers/media/dvb-frontends/stv6110x_priv.h
@@ -70,7 +70,7 @@ struct stv6110x_state {
 	const struct stv6110x_config	*config;
 	u8 				regs[8];
 
-	struct stv6110x_devctl		*devctl;
+	const struct stv6110x_devctl	*devctl;
 };
 
 #endif /* __STV6110x_PRIV_H */
diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index fba5b40..17f56a8 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -690,7 +690,7 @@ static int tuner_attach_stv6110(struct ddb_input *input, int type)
 	struct stv090x_config *feconf = type ? &stv0900_aa : &stv0900;
 	struct stv6110x_config *tunerconf = (input->nr & 1) ?
 		&stv6110b : &stv6110a;
-	struct stv6110x_devctl *ctl;
+	const struct stv6110x_devctl *ctl;
 
 	ctl = dvb_attach(stv6110x_attach, input->fe, tunerconf, i2c);
 	if (!ctl) {
diff --git a/drivers/media/pci/ngene/ngene-cards.c b/drivers/media/pci/ngene/ngene-cards.c
index 039bed3..4e783a6 100644
--- a/drivers/media/pci/ngene/ngene-cards.c
+++ b/drivers/media/pci/ngene/ngene-cards.c
@@ -57,7 +57,7 @@ static int tuner_attach_stv6110(struct ngene_channel *chan)
 		chan->dev->card_info->fe_config[chan->number];
 	struct stv6110x_config *tunerconf = (struct stv6110x_config *)
 		chan->dev->card_info->tuner_config[chan->number];
-	struct stv6110x_devctl *ctl;
+	const struct stv6110x_devctl *ctl;
 
 	/* tuner 1+2: i2c adapter #0, tuner 3+4: i2c adapter #1 */
 	if (chan->number < 2)
diff --git a/drivers/media/pci/ttpci/budget.c b/drivers/media/pci/ttpci/budget.c
index 99972be..b44639c 100644
--- a/drivers/media/pci/ttpci/budget.c
+++ b/drivers/media/pci/ttpci/budget.c
@@ -644,7 +644,7 @@ static void frontend_init(struct budget *budget)
 		}
 
 	case 0x101c: { /* TT S2-1600 */
-			struct stv6110x_devctl *ctl;
+			const struct stv6110x_devctl *ctl;
 			saa7146_setgpio(budget->dev, 2, SAA7146_GPIO_OUTLO);
 			msleep(50);
 			saa7146_setgpio(budget->dev, 2, SAA7146_GPIO_OUTHI);
@@ -697,7 +697,7 @@ static void frontend_init(struct budget *budget)
 		break;
 
 	case 0x1020: { /* Omicom S2 */
-			struct stv6110x_devctl *ctl;
+			const struct stv6110x_devctl *ctl;
 			saa7146_setgpio(budget->dev, 2, SAA7146_GPIO_OUTLO);
 			msleep(50);
 			saa7146_setgpio(budget->dev, 2, SAA7146_GPIO_OUTHI);
diff --git a/drivers/media/usb/dvb-usb/technisat-usb2.c b/drivers/media/usb/dvb-usb/technisat-usb2.c
index 6c3c477..51487d2 100644
--- a/drivers/media/usb/dvb-usb/technisat-usb2.c
+++ b/drivers/media/usb/dvb-usb/technisat-usb2.c
@@ -512,7 +512,7 @@ static int technisat_usb2_frontend_attach(struct dvb_usb_adapter *a)
 			&a->dev->i2c_adap, STV090x_DEMODULATOR_0);
 
 	if (a->fe_adap[0].fe) {
-		struct stv6110x_devctl *ctl;
+		const struct stv6110x_devctl *ctl;
 
 		ctl = dvb_attach(stv6110x_attach,
 				a->fe_adap[0].fe,
diff --git a/drivers/media/platform/sti/c8sectpfe/c8sectpfe-dvb.c b/drivers/media/platform/sti/c8sectpfe/c8sectpfe-dvb.c
index 69d7fe4..2c0015b 100644
--- a/drivers/media/platform/sti/c8sectpfe/c8sectpfe-dvb.c
+++ b/drivers/media/platform/sti/c8sectpfe/c8sectpfe-dvb.c
@@ -118,7 +118,7 @@ int c8sectpfe_frontend_attach(struct dvb_frontend **fe,
 		struct channel_info *tsin, int chan_num)
 {
 	struct tda18212_config *tda18212;
-	struct stv6110x_devctl *fe2;
+	const struct stv6110x_devctl *fe2;
 	struct i2c_client *client;
 	struct i2c_board_info tda18212_info = {
 		.type = "tda18212",

