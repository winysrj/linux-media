Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:56437 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804AbaKZNH4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Nov 2014 08:07:56 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	"Luis R. Rodriguez" <mcgrof@suse.com>,
	Felipe Pena <felipensp@gmail.com>,
	Michael Krufky <mkrufky@linuxtv.org>,
	CrazyCat <crazycat69@narod.ru>
Subject: [PATCH] [media] stv090x: remove export symbol for stv090x_set_gpio()
Date: Wed, 26 Nov 2014 11:07:41 -0200
Message-Id: <d659161f4d9bd96538a506a5fe728131f47b1a0b.1417007247.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Drivers that use dvb_attach can have just one exported symbol,
or they will cause compilation breakages depending on the
selected frontends.

As Jim reported:
drivers/built-in.o: In function `technisat_usb2_set_voltage':
technisat-usb2.c:(.text+0x3b4919): undefined reference to `stv090x_set_gpio'
make: *** [vmlinux] Error 1

That happens because, on his configuration, the configuration
is:

	CONFIG_DVB_USB=y
	CONFIG_DVB_STV090x=m

Luis proposed ar way to fix, but that would just force the
STV090x to be selected, even if one wants to use a device
with a different frontend.

Instead, let's do the right thing: move set_gpio to the
configuration structure and fill it during dvb_attach().

This way, the driver can still call it, and dvb_attach()
will load stv090x module only if the device really needs it.

Reported by: Jim Davis <jim.epost@gmail.com>
Cc: Luis Rodriguez <mcgrof@suse.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-frontends/stv090x.c b/drivers/media/dvb-frontends/stv090x.c
index f8050b984a8f..3489400bb08a 100644
--- a/drivers/media/dvb-frontends/stv090x.c
+++ b/drivers/media/dvb-frontends/stv090x.c
@@ -4870,8 +4870,8 @@ err:
 	return -1;
 }
 
-int stv090x_set_gpio(struct dvb_frontend *fe, u8 gpio, u8 dir, u8 value,
-		u8 xor_value)
+static int stv090x_set_gpio(struct dvb_frontend *fe, u8 gpio, u8 dir,
+			    u8 value, u8 xor_value)
 {
 	struct stv090x_state *state = fe->demodulator_priv;
 	u8 reg = 0;
@@ -4882,7 +4882,6 @@ int stv090x_set_gpio(struct dvb_frontend *fe, u8 gpio, u8 dir, u8 value,
 
 	return stv090x_write_reg(state, STV090x_GPIOxCFG(gpio), reg);
 }
-EXPORT_SYMBOL(stv090x_set_gpio);
 
 static struct dvb_frontend_ops stv090x_ops = {
 	.delsys = { SYS_DVBS, SYS_DVBS2, SYS_DSS },
@@ -4919,7 +4918,7 @@ static struct dvb_frontend_ops stv090x_ops = {
 };
 
 
-struct dvb_frontend *stv090x_attach(const struct stv090x_config *config,
+struct dvb_frontend *stv090x_attach(struct stv090x_config *config,
 				    struct i2c_adapter *i2c,
 				    enum stv090x_demodulator demod)
 {
@@ -4980,6 +4979,8 @@ struct dvb_frontend *stv090x_attach(const struct stv090x_config *config,
 	if (config->diseqc_envelope_mode)
 		stv090x_send_diseqc_burst(&state->frontend, SEC_MINI_A);
 
+	config->set_gpio = stv090x_set_gpio;
+
 	dprintk(FE_ERROR, 1, "Attaching %s demodulator(%d) Cut=0x%02x",
 	       state->device == STV0900 ? "STV0900" : "STV0903",
 	       demod,
diff --git a/drivers/media/dvb-frontends/stv090x.h b/drivers/media/dvb-frontends/stv090x.h
index 0bd6adcfee8a..ba20edc3b5c6 100644
--- a/drivers/media/dvb-frontends/stv090x.h
+++ b/drivers/media/dvb-frontends/stv090x.h
@@ -101,18 +101,18 @@ struct stv090x_config {
 	int (*tuner_set_refclk)  (struct dvb_frontend *fe, u32 refclk);
 	int (*tuner_get_status) (struct dvb_frontend *fe, u32 *status);
 	void (*tuner_i2c_lock) (struct dvb_frontend *fe, int lock);
+
+	/* dir = 0 -> output, dir = 1 -> input/open-drain */
+	int (*set_gpio) (struct dvb_frontend *fe, u8 gpio, u8 dir, u8 value,
+			 u8 xor_value);
 };
 
 #if IS_ENABLED(CONFIG_DVB_STV090x)
 
-extern struct dvb_frontend *stv090x_attach(const struct stv090x_config *config,
+extern struct dvb_frontend *stv090x_attach(struct stv090x_config *config,
 					   struct i2c_adapter *i2c,
 					   enum stv090x_demodulator demod);
 
-/* dir = 0 -> output, dir = 1 -> input/open-drain */
-extern int stv090x_set_gpio(struct dvb_frontend *fe, u8 gpio,
-		u8 dir, u8 value, u8 xor_value);
-
 #else
 
 static inline struct dvb_frontend *stv090x_attach(const struct stv090x_config *config,
@@ -123,12 +123,6 @@ static inline struct dvb_frontend *stv090x_attach(const struct stv090x_config *c
 	return NULL;
 }
 
-static inline int stv090x_set_gpio(struct dvb_frontend *fe, u8 gpio,
-		u8 opd, u8 value, u8 xor_value)
-{
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
-	return -ENODEV;
-}
 #endif /* CONFIG_DVB_STV090x */
 
 #endif /* __STV090x_H */
diff --git a/drivers/media/usb/dvb-usb/technisat-usb2.c b/drivers/media/usb/dvb-usb/technisat-usb2.c
index 6b0b8b6b9e2a..58ba02c93d29 100644
--- a/drivers/media/usb/dvb-usb/technisat-usb2.c
+++ b/drivers/media/usb/dvb-usb/technisat-usb2.c
@@ -449,6 +449,8 @@ static int technisat_usb2_read_mac_address(struct dvb_usb_device *d,
 	return 0;
 }
 
+static struct stv090x_config technisat_usb2_stv090x_config;
+
 /* frontend attach */
 static int technisat_usb2_set_voltage(struct dvb_frontend *fe,
 		fe_sec_voltage_t voltage)
@@ -472,7 +474,7 @@ static int technisat_usb2_set_voltage(struct dvb_frontend *fe,
 	}
 
 	for (i = 0; i < 3; i++)
-		if (stv090x_set_gpio(fe, i+2, 0, gpio[i], 0) != 0)
+		if (technisat_usb2_stv090x_config.set_gpio(fe, i+2, 0, gpio[i], 0) != 0)
 			return -EREMOTEIO;
 	return 0;
 }
-- 
1.9.3

