Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-1.atlantis.sk ([80.94.52.57]:50037 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755466Ab3AUS2f (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Jan 2013 13:28:35 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: Antti Palosaari <crope@iki.fi>
Subject: Re: [PATCH 1/4] tda8290: Allow disabling I2C gate
Date: Mon, 21 Jan 2013 19:28:05 +0100
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
References: <1358716939-2133-1-git-send-email-linux@rainbow-software.org> <201301210918.07199.linux@rainbow-software.org> <50FD04F9.5000401@iki.fi>
In-Reply-To: <50FD04F9.5000401@iki.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201301211928.06111.linux@rainbow-software.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 21 January 2013 10:06:01 Antti Palosaari wrote:
> On 01/21/2013 10:18 AM, Ondrej Zary wrote:
> > On Monday 21 January 2013, Antti Palosaari wrote:
> >> On 01/20/2013 11:22 PM, Ondrej Zary wrote:
> >>> Allow disabling I2C gate handling by external configuration.
> >>> This is required by cards that have all devices on a single I2C bus,
> >>> like AverMedia A706.
> >>
> >> My personal opinion is that I2C gate control should be disabled setting
> >> callback to NULL (same for the other unwanted callbacks too). There is
> >> checks for callback existence in DVB-core, it does not call callback if
> >> it is NULL.
> >
> > This is TDA8290 internal I2C gate which is used by tda8290 internally and
> > also by tda827x or tda18271.
>
> That sounds like there is some logical problems in the driver then, not
> split correctly?
>
> What I think, scenario is tda8290 is analog decoder, tda18271 is silicon
> tuner, which is connected (usually) to the tda8290 I2C bus. tda18271
> calls tda8290 I2C-gate control when needed. Analog or digital demod
> should not call its own I2C gate directly - and if it was done in some
> weird reason then it should call own callback conditionally, checking
> whether or not it is NULL.

Something like this? It seems to work for both cases (I2C gate control
enabled and disabled) - tested with Pinnacle PCTV 110i and this AverMedia
A706.

---
 drivers/media/tuners/tda8290.c |   49 +++++++++++++++++++++++----------------
 drivers/media/tuners/tda8290.h |    1 +
 2 files changed, 30 insertions(+), 20 deletions(-)

diff --git a/drivers/media/tuners/tda8290.c b/drivers/media/tuners/tda8290.c
index 8c48521..a2b7a9f 100644
--- a/drivers/media/tuners/tda8290.c
+++ b/drivers/media/tuners/tda8290.c
@@ -233,7 +233,8 @@ static void tda8290_set_params(struct dvb_frontend *fe,
 	}
 
 
-	tda8290_i2c_bridge(fe, 1);
+	if (fe->ops.analog_ops.i2c_gate_ctrl)
+		fe->ops.analog_ops.i2c_gate_ctrl(fe, 1);
 
 	if (fe->ops.tuner_ops.set_analog_params)
 		fe->ops.tuner_ops.set_analog_params(fe, params);
@@ -302,7 +303,8 @@ static void tda8290_set_params(struct dvb_frontend *fe,
 		}
 	}
 
-	tda8290_i2c_bridge(fe, 0);
+	if (fe->ops.analog_ops.i2c_gate_ctrl)
+		fe->ops.analog_ops.i2c_gate_ctrl(fe, 0);
 	tuner_i2c_xfer_send(&priv->i2c_props, if_agc_set, 2);
 }
 
@@ -424,7 +426,8 @@ static void tda8295_set_params(struct dvb_frontend *fe,
 	tuner_i2c_xfer_send(&priv->i2c_props, blanking_mode, 2);
 	msleep(20);
 
-	tda8295_i2c_bridge(fe, 1);
+	if (fe->ops.analog_ops.i2c_gate_ctrl)
+		fe->ops.analog_ops.i2c_gate_ctrl(fe, 1);
 
 	if (fe->ops.tuner_ops.set_analog_params)
 		fe->ops.tuner_ops.set_analog_params(fe, params);
@@ -437,7 +440,8 @@ static void tda8295_set_params(struct dvb_frontend *fe,
 	else
 		tuner_dbg("tda8295 not locked, no signal?\n");
 
-	tda8295_i2c_bridge(fe, 0);
+	if (fe->ops.analog_ops.i2c_gate_ctrl)
+		fe->ops.analog_ops.i2c_gate_ctrl(fe, 0);
 }
 
 /*---------------------------------------------------------------------*/
@@ -465,11 +469,13 @@ static void tda8290_standby(struct dvb_frontend *fe)
 	unsigned char tda8290_agc_tri[] = { 0x02, 0x20 };
 	struct i2c_msg msg = {.addr = priv->tda827x_addr, .flags=0, .buf=cb1, .len = 2};
 
-	tda8290_i2c_bridge(fe, 1);
+	if (fe->ops.analog_ops.i2c_gate_ctrl)
+		fe->ops.analog_ops.i2c_gate_ctrl(fe, 1);
 	if (priv->ver & TDA8275A)
 		cb1[1] = 0x90;
 	i2c_transfer(priv->i2c_props.adap, &msg, 1);
-	tda8290_i2c_bridge(fe, 0);
+	if (fe->ops.analog_ops.i2c_gate_ctrl)
+		fe->ops.analog_ops.i2c_gate_ctrl(fe, 0);
 	tuner_i2c_xfer_send(&priv->i2c_props, tda8290_agc_tri, 2);
 	tuner_i2c_xfer_send(&priv->i2c_props, tda8290_standby, 2);
 }
@@ -537,9 +543,11 @@ static void tda8290_init_tuner(struct dvb_frontend *fe)
 	if (priv->ver & TDA8275A)
 		msg.buf = tda8275a_init;
 
-	tda8290_i2c_bridge(fe, 1);
+	if (fe->ops.analog_ops.i2c_gate_ctrl)
+		fe->ops.analog_ops.i2c_gate_ctrl(fe, 1);
 	i2c_transfer(priv->i2c_props.adap, &msg, 1);
-	tda8290_i2c_bridge(fe, 0);
+	if (fe->ops.analog_ops.i2c_gate_ctrl)
+		fe->ops.analog_ops.i2c_gate_ctrl(fe, 0);
 }
 
 /*---------------------------------------------------------------------*/
@@ -565,19 +573,13 @@ static struct tda18271_config tda829x_tda18271_config = {
 static int tda829x_find_tuner(struct dvb_frontend *fe)
 {
 	struct tda8290_priv *priv = fe->analog_demod_priv;
-	struct analog_demod_ops *analog_ops = &fe->ops.analog_ops;
 	int i, ret, tuners_found;
 	u32 tuner_addrs;
 	u8 data;
 	struct i2c_msg msg = { .flags = I2C_M_RD, .buf = &data, .len = 1 };
 
-	if (!analog_ops->i2c_gate_ctrl) {
-		printk(KERN_ERR "tda8290: no gate control were provided!\n");
-
-		return -EINVAL;
-	}
-
-	analog_ops->i2c_gate_ctrl(fe, 1);
+	if (fe->ops.analog_ops.i2c_gate_ctrl)
+		fe->ops.analog_ops.i2c_gate_ctrl(fe, 1);
 
 	/* probe for tuner chip */
 	tuners_found = 0;
@@ -595,7 +597,8 @@ static int tda829x_find_tuner(struct dvb_frontend *fe)
 	   give a response now
 	 */
 
-	analog_ops->i2c_gate_ctrl(fe, 0);
+	if (fe->ops.analog_ops.i2c_gate_ctrl)
+		fe->ops.analog_ops.i2c_gate_ctrl(fe, 0);
 
 	if (tuners_found > 1)
 		for (i = 0; i < tuners_found; i++) {
@@ -618,12 +621,14 @@ static int tda829x_find_tuner(struct dvb_frontend *fe)
 	priv->tda827x_addr = tuner_addrs;
 	msg.addr = tuner_addrs;
 
-	analog_ops->i2c_gate_ctrl(fe, 1);
+	if (fe->ops.analog_ops.i2c_gate_ctrl)
+		fe->ops.analog_ops.i2c_gate_ctrl(fe, 1);
 	ret = i2c_transfer(priv->i2c_props.adap, &msg, 1);
 
 	if (ret != 1) {
 		tuner_warn("tuner access failed!\n");
-		analog_ops->i2c_gate_ctrl(fe, 0);
+		if (fe->ops.analog_ops.i2c_gate_ctrl)
+			fe->ops.analog_ops.i2c_gate_ctrl(fe, 0);
 		return -EREMOTEIO;
 	}
 
@@ -648,7 +653,8 @@ static int tda829x_find_tuner(struct dvb_frontend *fe)
 	if (fe->ops.tuner_ops.sleep)
 		fe->ops.tuner_ops.sleep(fe);
 
-	analog_ops->i2c_gate_ctrl(fe, 0);
+	if (fe->ops.analog_ops.i2c_gate_ctrl)
+		fe->ops.analog_ops.i2c_gate_ctrl(fe, 0);
 
 	return 0;
 }
@@ -755,6 +761,9 @@ struct dvb_frontend *tda829x_attach(struct dvb_frontend *fe,
 		       sizeof(struct analog_demod_ops));
 	}
 
+	if (cfg && cfg->no_i2c_gate)
+		fe->ops.analog_ops.i2c_gate_ctrl = NULL;
+
 	if (!(cfg) || (TDA829X_PROBE_TUNER == cfg->probe_tuner)) {
 		tda8295_power(fe, 1);
 		if (tda829x_find_tuner(fe) < 0)
diff --git a/drivers/media/tuners/tda8290.h b/drivers/media/tuners/tda8290.h
index 7e288b2..9959cc8 100644
--- a/drivers/media/tuners/tda8290.h
+++ b/drivers/media/tuners/tda8290.h
@@ -26,6 +26,7 @@ struct tda829x_config {
 	unsigned int probe_tuner:1;
 #define TDA829X_PROBE_TUNER 0
 #define TDA829X_DONT_PROBE  1
+	unsigned int no_i2c_gate:1;
 };
 
 #if defined(CONFIG_MEDIA_TUNER_TDA8290) || (defined(CONFIG_MEDIA_TUNER_TDA8290_MODULE) && defined(MODULE))
-- 
Ondrej Zary
