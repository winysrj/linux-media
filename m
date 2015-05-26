Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33944 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751272AbbEZPEF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 26 May 2015 11:04:05 -0400
Subject: [PATCH 1/2] TS2020: Calculate tuner gain correctly
From: David Howells <dhowells@redhat.com>
To: crope@iki.fi
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org
Date: Tue, 26 May 2015 16:04:00 +0100
Message-ID: <20150526150400.10241.25444.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The TS2020 and TS2022 tuners take an input from the demodulator indicating the
AGC setting on that component that is then used to influence the tuner's own
gain.  This should be taken into account when calculating the gain and signal
strength.

Further, the existing TS2020 driver miscalculates the signal strength as the
result of its calculations can exceed the storage capacity of the 16-bit word
used to return it to userspace.

To this end:

 (1) Add a callback function (->get_agc_pwm()) in the ts2020_config struct that
     the tuner can call to get the AGC PWM value from the demodulator.

 (2) Modify the TS2020 driver to calculate the gain according to Montage's
     specification with the adjustment that we produce a negative value and
     scale it to 0.001dB units (which is what the DVBv5 API will require):

     (a) Callback to the demodulator to retrieve the AGC PWM value and then
     	 turn that into Vagc for incorporation in the calculations.  If the
     	 callback is unset, assume a Vagc of 0.

     (b) Calculate the tuner gain from a combination of Vagc and the tuner's RF
     	 gain and baseband gain settings.

 (3) Turn this into a percentage signal strength as per Montage's
     specification for return to userspace with the DVBv3 API.

 (4) Provide a function in the M88DS3103 demodulator driver that can be used to
     get the AGC PWM value on behalf of the tuner.

 (5) The ts2020_config.get_agc_pwm function should be set by the code that
     stitches together the drivers for each card.

     For the DVBSky cards that use the M88DS3103 with the TS2020 or the TS2022,
     set the get_agc_pwm function to point to m88ds3103_get_agc_pwm.

I have tested this with a DVBSky S952 card which has an M88DS3103 and a TS2022.

Thanks to Montage for providing access to information about the workings of
these parts.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 drivers/media/dvb-frontends/m88ds3103.c |   16 ++++
 drivers/media/dvb-frontends/m88ds3103.h |    2 
 drivers/media/dvb-frontends/ts2020.c    |  138 +++++++++++++++++++++++++++----
 drivers/media/dvb-frontends/ts2020.h    |    5 +
 drivers/media/pci/cx23885/cx23885-dvb.c |    3 +
 drivers/media/usb/dvb-usb-v2/dvbsky.c   |    2 
 6 files changed, 148 insertions(+), 18 deletions(-)

diff --git a/drivers/media/dvb-frontends/m88ds3103.c b/drivers/media/dvb-frontends/m88ds3103.c
index 50ede6a..0703316 100644
--- a/drivers/media/dvb-frontends/m88ds3103.c
+++ b/drivers/media/dvb-frontends/m88ds3103.c
@@ -52,6 +52,22 @@ err:
 	return ret;
 }
 
+/*
+ * Get the demodulator AGC PWM voltage setting supplied to the tuner.
+ */
+int m88ds3103_get_agc_pwm(struct dvb_frontend *fe, u8 *_agc_pwm)
+{
+	struct m88ds3103_dev *dev = fe->demodulator_priv;
+	unsigned tmp;
+	int ret;
+
+	ret = regmap_read(dev->regmap, 0x3f, &tmp);
+	if (ret == 0)
+		*_agc_pwm = tmp;
+	return ret;
+}
+EXPORT_SYMBOL(m88ds3103_get_agc_pwm);
+
 static int m88ds3103_read_status(struct dvb_frontend *fe, fe_status_t *status)
 {
 	struct m88ds3103_dev *dev = fe->demodulator_priv;
diff --git a/drivers/media/dvb-frontends/m88ds3103.h b/drivers/media/dvb-frontends/m88ds3103.h
index ff03905..04b355a 100644
--- a/drivers/media/dvb-frontends/m88ds3103.h
+++ b/drivers/media/dvb-frontends/m88ds3103.h
@@ -176,6 +176,7 @@ extern struct dvb_frontend *m88ds3103_attach(
 		const struct m88ds3103_config *config,
 		struct i2c_adapter *i2c,
 		struct i2c_adapter **tuner_i2c);
+extern int m88ds3103_get_agc_pwm(struct dvb_frontend *fe, u8 *_agc_pwm);
 #else
 static inline struct dvb_frontend *m88ds3103_attach(
 		const struct m88ds3103_config *config,
@@ -185,6 +186,7 @@ static inline struct dvb_frontend *m88ds3103_attach(
 	pr_warn("%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
+#define m88ds3103_get_agc_pwm NULL
 #endif
 
 #endif
diff --git a/drivers/media/dvb-frontends/ts2020.c b/drivers/media/dvb-frontends/ts2020.c
index f674717..277e1cf 100644
--- a/drivers/media/dvb-frontends/ts2020.c
+++ b/drivers/media/dvb-frontends/ts2020.c
@@ -32,6 +32,7 @@ struct ts2020_priv {
 	struct regmap_config regmap_config;
 	struct regmap *regmap;
 	struct dvb_frontend *fe;
+	int (*get_agc_pwm)(struct dvb_frontend *fe, u8 *_agc_pwm);
 	/* i2c details */
 	int i2c_address;
 	struct i2c_adapter *i2c;
@@ -313,32 +314,132 @@ static int ts2020_get_if_frequency(struct dvb_frontend *fe, u32 *frequency)
 	return 0;
 }
 
-/* read TS2020 signal strength */
-static int ts2020_read_signal_strength(struct dvb_frontend *fe,
-						u16 *signal_strength)
+/*
+ * Get the tuner gain.
+ * @fe: The front end for which we're determining the gain
+ * @v_agc: The voltage of the AGC from the demodulator (0-2600mV)
+ * @_gain: Where to store the gain (in 0.001dB units)
+ *
+ * Returns 0 or a negative error code.
+ */
+static int ts2020_read_tuner_gain(struct dvb_frontend *fe, unsigned v_agc,
+				  __s64 *_gain)
 {
 	struct ts2020_priv *priv = fe->tuner_priv;
-	unsigned int utmp;
-	u16 sig_reading, sig_strength;
-	u8 rfgain, bbgain;
+	unsigned long gain1, gain2, gain3;
+	unsigned utmp;
+	int ret;
+
+	/* Read the RF gain */
+	ret = regmap_read(priv->regmap, 0x3d, &utmp);
+	if (ret < 0)
+		return ret;
+	gain1 = utmp & 0x1f;
+
+	/* Read the baseband gain */
+	ret = regmap_read(priv->regmap, 0x21, &utmp);
+	if (ret < 0)
+		return ret;
+	gain2 = utmp & 0x1f;
+
+	switch (priv->tuner) {
+	case TS2020_M88TS2020:
+		gain1 = clamp_t(long, gain1, 0, 15);
+		gain2 = clamp_t(long, gain2, 0, 13);
+		v_agc = clamp_t(long, v_agc, 400, 1100);
+
+		*_gain = -(gain1 * 2330 +
+			   gain2 * 3500 +
+			   v_agc * 24 / 10 * 10 +
+			   10000);
+		/* gain in range -19600 to -116850 in units of 0.001dB */
+		break;
+
+	case TS2020_M88TS2022:
+		ret = regmap_read(priv->regmap, 0x66, &utmp);
+		if (ret < 0)
+			return ret;
+		gain3 = (utmp >> 3) & 0x07;
+
+		gain1 = clamp_t(long, gain1, 0, 15);
+		gain2 = clamp_t(long, gain2, 2, 16);
+		gain3 = clamp_t(long, gain3, 0, 6);
+		v_agc = clamp_t(long, v_agc, 600, 1600);
+
+		*_gain = -(gain1 * 2650 +
+			   gain2 * 3380 +
+			   gain3 * 2850 +
+			   v_agc * 176 / 100 * 10 -
+			   30000);
+		/* gain in range -47320 to -158950 in units of 0.001dB */
+		break;
+	}
+
+	return 0;
+}
+
+/*
+ * Get the AGC information from the demodulator and use that to calculate the
+ * tuner gain.
+ */
+static int ts2020_get_tuner_gain(struct dvb_frontend *fe, __s64 *_gain)
+{
+	struct ts2020_priv *priv = fe->tuner_priv;
+	int v_agc = 0, ret;
+	u8 agc_pwm;
 
-	regmap_read(priv->regmap, 0x3d, &utmp);
-	rfgain = utmp & 0x1f;
-	regmap_read(priv->regmap, 0x21, &utmp);
-	bbgain = utmp & 0x1f;
+	/* Read the AGC PWM rate from the demodulator */
+	if (priv->get_agc_pwm) {
+		ret = priv->get_agc_pwm(fe, &agc_pwm);
+		if (ret < 0)
+			return ret;
 
-	if (rfgain > 15)
-		rfgain = 15;
-	if (bbgain > 13)
-		bbgain = 13;
+		switch (priv->tuner) {
+		case TS2020_M88TS2020:
+			v_agc = (int)agc_pwm * 20 - 1166;
+			break;
+		case TS2020_M88TS2022:
+			v_agc = (int)agc_pwm * 16 - 670;
+			break;
+		}
 
-	sig_reading = rfgain * 2 + bbgain * 3;
+		if (v_agc < 0)
+			v_agc = 0;
+	}
 
-	sig_strength = 40 + (64 - sig_reading) * 50 / 64 ;
+	return ts2020_read_tuner_gain(fe, v_agc, _gain);
+}
 
-	/* cook the value to be suitable for szap-s2 human readable output */
-	*signal_strength = sig_strength * 1000;
+/*
+ * Read TS2020 signal strength in v3 format.
+ */
+static int ts2020_read_signal_strength(struct dvb_frontend *fe,
+						u16 *signal_strength)
+{
+	unsigned strength;
+	__s64 gain;
+	int ret;
+
+	/* Determine the total gain of the tuner */
+	ret = ts2020_get_tuner_gain(fe, &gain);
+	if (ret < 0)
+		return ret;
+
+	/* Calculate the signal strength based on the total gain of the tuner */
+	if (gain < -85000)
+		/* 0%: no signal or weak signal */
+		strength = 0;
+	else if (gain < -65000)
+		/* 0% - 60%: weak signal */
+		strength = 0 + (85000 + gain) * 3 / 1000;
+	else if (gain < -45000)
+		/* 60% - 90%: normal signal */
+		strength = 60 + (65000 + gain) * 3 / 2000;
+	else
+		/* 90% - 99%: strong signal */
+		strength = 90 + (45000 + gain) / 5000;
 
+	*signal_strength = strength * 65535 / 100;
 	return 0;
 }
 
@@ -442,6 +543,7 @@ static int ts2020_probe(struct i2c_client *client,
 	dev->clk_out_div = pdata->clk_out_div;
 	dev->frequency_div = pdata->frequency_div;
 	dev->fe = fe;
+	dev->get_agc_pwm = pdata->get_agc_pwm;
 	fe->tuner_priv = dev;
 	dev->client = client;
 
diff --git a/drivers/media/dvb-frontends/ts2020.h b/drivers/media/dvb-frontends/ts2020.h
index 8247ba5..1d7c55e 100644
--- a/drivers/media/dvb-frontends/ts2020.h
+++ b/drivers/media/dvb-frontends/ts2020.h
@@ -57,6 +57,11 @@ struct ts2020_config {
 	 * driver private, do not set value
 	 */
 	u8 attach_in_use:1;
+
+	/* Operation to be called by the ts2020 driver to get the value of the
+	 * AGC PWM tuner input as theoretically output by the demodulator.
+	 */
+	int (*get_agc_pwm)(struct dvb_frontend *fe, u8 *_agc_pwm);
 };
 
 /* Do not add new ts2020_attach() users! Use I2C bindings instead. */
diff --git a/drivers/media/pci/cx23885/cx23885-dvb.c b/drivers/media/pci/cx23885/cx23885-dvb.c
index 745caab..f5e3392 100644
--- a/drivers/media/pci/cx23885/cx23885-dvb.c
+++ b/drivers/media/pci/cx23885/cx23885-dvb.c
@@ -1857,6 +1857,7 @@ static int dvb_register(struct cx23885_tsport *port)
 			/* attach tuner */
 			memset(&ts2020_config, 0, sizeof(ts2020_config));
 			ts2020_config.fe = fe0->dvb.frontend;
+			ts2020_config.get_agc_pwm = m88ds3103_get_agc_pwm;
 			memset(&info, 0, sizeof(struct i2c_board_info));
 			strlcpy(info.type, "ts2020", I2C_NAME_SIZE);
 			info.addr = 0x60;
@@ -1986,6 +1987,7 @@ static int dvb_register(struct cx23885_tsport *port)
 		/* attach tuner */
 		memset(&ts2020_config, 0, sizeof(ts2020_config));
 		ts2020_config.fe = fe0->dvb.frontend;
+		ts2020_config.get_agc_pwm = m88ds3103_get_agc_pwm;
 		memset(&info, 0, sizeof(struct i2c_board_info));
 		strlcpy(info.type, "ts2020", I2C_NAME_SIZE);
 		info.addr = 0x60;
@@ -2031,6 +2033,7 @@ static int dvb_register(struct cx23885_tsport *port)
 		/* attach tuner */
 		memset(&ts2020_config, 0, sizeof(ts2020_config));
 		ts2020_config.fe = fe0->dvb.frontend;
+		ts2020_config.get_agc_pwm = m88ds3103_get_agc_pwm;
 		memset(&info, 0, sizeof(struct i2c_board_info));
 		strlcpy(info.type, "ts2020", I2C_NAME_SIZE);
 		info.addr = 0x60;
diff --git a/drivers/media/usb/dvb-usb-v2/dvbsky.c b/drivers/media/usb/dvb-usb-v2/dvbsky.c
index cdf59bc..6b1bc24 100644
--- a/drivers/media/usb/dvb-usb-v2/dvbsky.c
+++ b/drivers/media/usb/dvb-usb-v2/dvbsky.c
@@ -331,6 +331,7 @@ static int dvbsky_s960_attach(struct dvb_usb_adapter *adap)
 
 	/* attach tuner */
 	ts2020_config.fe = adap->fe[0];
+	ts2020_config.get_agc_pwm = m88ds3103_get_agc_pwm;
 	strlcpy(info.type, "ts2020", I2C_NAME_SIZE);
 	info.addr = 0x60;
 	info.platform_data = &ts2020_config;
@@ -453,6 +454,7 @@ static int dvbsky_s960c_attach(struct dvb_usb_adapter *adap)
 
 	/* attach tuner */
 	ts2020_config.fe = adap->fe[0];
+	ts2020_config.get_agc_pwm = m88ds3103_get_agc_pwm;
 	strlcpy(info.type, "ts2020", I2C_NAME_SIZE);
 	info.addr = 0x60;
 	info.platform_data = &ts2020_config;

