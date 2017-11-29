Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:58744 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752290AbdK2TIz (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Nov 2017 14:08:55 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Antti Palosaari <crope@iki.fi>, Sergey Kozlov <serjk@netup.ru>,
        Abylay Ospan <aospan@netup.ru>,
        Malcolm Priestley <tvboxspy@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Kate Stewart <kstewart@linuxfoundation.org>
Subject: [PATCH 22/22] media: dvb-frontends: complete kernel-doc markups
Date: Wed, 29 Nov 2017 14:08:40 -0500
Message-Id: <1bed85f85921c3567bd45c05e31e8cbbaeb3aacb.1511982439.git.mchehab@s-opensource.com>
In-Reply-To: <73497577f67fbb917e40ab4328104ff310a7c356.1511982439.git.mchehab@s-opensource.com>
References: <73497577f67fbb917e40ab4328104ff310a7c356.1511982439.git.mchehab@s-opensource.com>
In-Reply-To: <73497577f67fbb917e40ab4328104ff310a7c356.1511982439.git.mchehab@s-opensource.com>
References: <73497577f67fbb917e40ab4328104ff310a7c356.1511982439.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

For the dvb-frontends that are now part of the documentation,
complete the kernel-doc markups, in order for them to be
properly used at the driver's kAPI documentation.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-frontends/af9013.h       |  24 +++--
 drivers/media/dvb-frontends/ascot2e.h      |   9 ++
 drivers/media/dvb-frontends/cxd2820r.h     |  24 ++++-
 drivers/media/dvb-frontends/drxk.h         |   8 ++
 drivers/media/dvb-frontends/dvb-pll.h      |   2 +-
 drivers/media/dvb-frontends/helene.h       |  35 +++++--
 drivers/media/dvb-frontends/horus3a.h      |   9 ++
 drivers/media/dvb-frontends/ix2505v.h      |  17 ++--
 drivers/media/dvb-frontends/m88ds3103.h    | 155 ++++++++++++-----------------
 drivers/media/dvb-frontends/mb86a20s.h     |  17 ++--
 drivers/media/dvb-frontends/rtl2830.h      |   1 -
 drivers/media/dvb-frontends/rtl2832.h      |   1 -
 drivers/media/dvb-frontends/stb6000.h      |   2 +-
 drivers/media/dvb-frontends/tda10071.h     |   1 -
 drivers/media/dvb-frontends/zd1301_demod.h |   6 ++
 15 files changed, 180 insertions(+), 131 deletions(-)

diff --git a/drivers/media/dvb-frontends/af9013.h b/drivers/media/dvb-frontends/af9013.h
index 353274524f1b..a290722c04fd 100644
--- a/drivers/media/dvb-frontends/af9013.h
+++ b/drivers/media/dvb-frontends/af9013.h
@@ -38,6 +38,13 @@
  * @api_version: Firmware API version.
  * @gpio: GPIOs.
  * @get_dvb_frontend: Get DVB frontend callback.
+ *
+ * AF9013/5 GPIOs (mostly guessed):
+ *   * demod#1-gpio#0 - set demod#2 i2c-addr for dual devices
+ *   * demod#1-gpio#1 - xtal setting (?)
+ *   * demod#1-gpio#3 - tuner#1
+ *   * demod#2-gpio#0 - tuner#2
+ *   * demod#2-gpio#1 - xtal setting (?)
  */
 struct af9013_platform_data {
 	/*
@@ -89,16 +96,15 @@ struct af9013_platform_data {
 #define AF9013_TS_PARALLEL  AF9013_TS_MODE_PARALLEL
 #define AF9013_TS_SERIAL    AF9013_TS_MODE_SERIAL
 
-/*
- * AF9013/5 GPIOs (mostly guessed)
- * demod#1-gpio#0 - set demod#2 i2c-addr for dual devices
- * demod#1-gpio#1 - xtal setting (?)
- * demod#1-gpio#3 - tuner#1
- * demod#2-gpio#0 - tuner#2
- * demod#2-gpio#1 - xtal setting (?)
- */
-
 #if IS_REACHABLE(CONFIG_DVB_AF9013)
+/**
+ * Attach an af9013 demod
+ *
+ * @config: pointer to &struct af9013_config with demod configuration.
+ * @i2c: i2c adapter to use.
+ *
+ * return: FE pointer on success, NULL on failure.
+ */
 extern struct dvb_frontend *af9013_attach(const struct af9013_config *config,
 	struct i2c_adapter *i2c);
 #else
diff --git a/drivers/media/dvb-frontends/ascot2e.h b/drivers/media/dvb-frontends/ascot2e.h
index dc61bf7d1b09..418c565baf83 100644
--- a/drivers/media/dvb-frontends/ascot2e.h
+++ b/drivers/media/dvb-frontends/ascot2e.h
@@ -41,6 +41,15 @@ struct ascot2e_config {
 };
 
 #if IS_REACHABLE(CONFIG_DVB_ASCOT2E)
+/**
+ * Attach an ascot2e tuner
+ *
+ * @fe: frontend to be attached
+ * @config: pointer to &struct ascot2e_config with tuner configuration.
+ * @i2c: i2c adapter to use.
+ *
+ * return: FE pointer on success, NULL on failure.
+ */
 extern struct dvb_frontend *ascot2e_attach(struct dvb_frontend *fe,
 					const struct ascot2e_config *config,
 					struct i2c_adapter *i2c);
diff --git a/drivers/media/dvb-frontends/cxd2820r.h b/drivers/media/dvb-frontends/cxd2820r.h
index f3ff8f6eb3bb..a49400c0e28e 100644
--- a/drivers/media/dvb-frontends/cxd2820r.h
+++ b/drivers/media/dvb-frontends/cxd2820r.h
@@ -49,7 +49,6 @@
  * @gpio_chip_base: GPIO.
  * @get_dvb_frontend: Get DVB frontend.
  */
-
 struct cxd2820r_platform_data {
 	u8 ts_mode;
 	bool ts_clk_inv;
@@ -62,6 +61,17 @@ struct cxd2820r_platform_data {
 	bool attach_in_use;
 };
 
+/**
+ * struct cxd2820r_config - configuration for cxd2020r demod
+ *
+ * @i2c_address: Demodulator I2C address. Driver determines DVB-C slave I2C
+ *		 address automatically from master address.
+ *		 Default: none, must set. Values: 0x6c, 0x6d.
+ * @ts_mode:	TS output mode. Default: none, must set. Values: FIXME?
+ * @ts_clock_inv: TS clock inverted. Default: 0. Values: 0, 1.
+ * @if_agc_polarity: Default: 0. Values: 0, 1
+ * @spec_inv:	Spectrum inversion. Default: 0. Values: 0, 1.
+ */
 struct cxd2820r_config {
 	/* Demodulator I2C address.
 	 * Driver determines DVB-C slave I2C address automatically from master
@@ -98,6 +108,18 @@ struct cxd2820r_config {
 
 
 #if IS_REACHABLE(CONFIG_DVB_CXD2820R)
+/**
+ * Attach a cxd2820r demod
+ *
+ * @config: pointer to &struct cxd2820r_config with demod configuration.
+ * @i2c: i2c adapter to use.
+ * @gpio_chip_base: if zero, disables GPIO setting. Otherwise, if
+ *		    CONFIG_GPIOLIB is set dynamically allocate
+ *		    gpio base; if is not set, use its value to
+ *		    setup the GPIO pins.
+ *
+ * return: FE pointer on success, NULL on failure.
+ */
 extern struct dvb_frontend *cxd2820r_attach(
 	const struct cxd2820r_config *config,
 	struct i2c_adapter *i2c,
diff --git a/drivers/media/dvb-frontends/drxk.h b/drivers/media/dvb-frontends/drxk.h
index c936142367fb..b16fedbb53a3 100644
--- a/drivers/media/dvb-frontends/drxk.h
+++ b/drivers/media/dvb-frontends/drxk.h
@@ -53,6 +53,14 @@ struct drxk_config {
 };
 
 #if IS_REACHABLE(CONFIG_DVB_DRXK)
+/**
+ * Attach a drxk demod
+ *
+ * @config: pointer to &struct drxk_config with demod configuration.
+ * @i2c: i2c adapter to use.
+ *
+ * return: FE pointer on success, NULL on failure.
+ */
 extern struct dvb_frontend *drxk_attach(const struct drxk_config *config,
 					struct i2c_adapter *i2c);
 #else
diff --git a/drivers/media/dvb-frontends/dvb-pll.h b/drivers/media/dvb-frontends/dvb-pll.h
index 01dbcc4d9550..212e0730f154 100644
--- a/drivers/media/dvb-frontends/dvb-pll.h
+++ b/drivers/media/dvb-frontends/dvb-pll.h
@@ -30,6 +30,7 @@
 #define DVB_PLL_TDEE4		       18
 #define DVB_PLL_THOMSON_DTT7520X       19
 
+#if IS_REACHABLE(CONFIG_DVB_PLL)
 /**
  * Attach a dvb-pll to the supplied frontend structure.
  *
@@ -40,7 +41,6 @@
  *
  * return: Frontend pointer on success, NULL on failure
  */
-#if IS_REACHABLE(CONFIG_DVB_PLL)
 extern struct dvb_frontend *dvb_pll_attach(struct dvb_frontend *fe,
 					   int pll_addr,
 					   struct i2c_adapter *i2c,
diff --git a/drivers/media/dvb-frontends/helene.h b/drivers/media/dvb-frontends/helene.h
index 3f504f5d1d4f..c9fc81c7e4e7 100644
--- a/drivers/media/dvb-frontends/helene.h
+++ b/drivers/media/dvb-frontends/helene.h
@@ -49,24 +49,39 @@ struct helene_config {
 };
 
 #if IS_REACHABLE(CONFIG_DVB_HELENE)
+/**
+ * Attach a helene tuner (terrestrial and cable standards)
+ *
+ * @fe: frontend to be attached
+ * @config: pointer to &struct helene_config with tuner configuration.
+ * @i2c: i2c adapter to use.
+ *
+ * return: FE pointer on success, NULL on failure.
+ */
 extern struct dvb_frontend *helene_attach(struct dvb_frontend *fe,
 					const struct helene_config *config,
 					struct i2c_adapter *i2c);
-#else
-static inline struct dvb_frontend *helene_attach(struct dvb_frontend *fe,
-					const struct helene_config *config,
-					struct i2c_adapter *i2c)
-{
-	pr_warn("%s: driver disabled by Kconfig\n", __func__);
-	return NULL;
-}
-#endif
 
-#if IS_REACHABLE(CONFIG_DVB_HELENE)
+/**
+ * Attach a helene tuner (satellite standards)
+ *
+ * @fe: frontend to be attached
+ * @config: pointer to &struct helene_config with tuner configuration.
+ * @i2c: i2c adapter to use.
+ *
+ * return: FE pointer on success, NULL on failure.
+ */
 extern struct dvb_frontend *helene_attach_s(struct dvb_frontend *fe,
 					const struct helene_config *config,
 					struct i2c_adapter *i2c);
 #else
+static inline struct dvb_frontend *helene_attach(struct dvb_frontend *fe,
+					const struct helene_config *config,
+					struct i2c_adapter *i2c)
+{
+	pr_warn("%s: driver disabled by Kconfig\n", __func__);
+	return NULL;
+}
 static inline struct dvb_frontend *helene_attach_s(struct dvb_frontend *fe,
 					const struct helene_config *config,
 					struct i2c_adapter *i2c)
diff --git a/drivers/media/dvb-frontends/horus3a.h b/drivers/media/dvb-frontends/horus3a.h
index 672a556df71a..9157fd037e2f 100644
--- a/drivers/media/dvb-frontends/horus3a.h
+++ b/drivers/media/dvb-frontends/horus3a.h
@@ -41,6 +41,15 @@ struct horus3a_config {
 };
 
 #if IS_REACHABLE(CONFIG_DVB_HORUS3A)
+/**
+ * Attach a horus3a tuner
+ *
+ * @fe: frontend to be attached
+ * @config: pointer to &struct helene_config with tuner configuration.
+ * @i2c: i2c adapter to use.
+ *
+ * return: FE pointer on success, NULL on failure.
+ */
 extern struct dvb_frontend *horus3a_attach(struct dvb_frontend *fe,
 					const struct horus3a_config *config,
 					struct i2c_adapter *i2c);
diff --git a/drivers/media/dvb-frontends/ix2505v.h b/drivers/media/dvb-frontends/ix2505v.h
index 31ca03a7b827..49ed93e754ed 100644
--- a/drivers/media/dvb-frontends/ix2505v.h
+++ b/drivers/media/dvb-frontends/ix2505v.h
@@ -19,19 +19,20 @@
 #include <linux/i2c.h>
 #include "dvb_frontend.h"
 
+/**
+ * struct ix2505v_config - ix2505 attachment configuration
+ *
+ * @tuner_address: tuner address
+ * @tuner_gain: Baseband AMP gain control 0/1=0dB(default) 2=-2bB 3=-4dB
+ * @tuner_chargepump: Charge pump output +/- 0=120 1=260 2=555 3=1200(default)
+ * @min_delay_ms: delay after tune
+ * @tuner_write_only: disables reads
+ */
 struct ix2505v_config {
 	u8 tuner_address;
-
-	/*Baseband AMP gain control 0/1=0dB(default) 2=-2bB 3=-4dB */
 	u8 tuner_gain;
-
-	/*Charge pump output +/- 0=120 1=260 2=555 3=1200(default) */
 	u8 tuner_chargepump;
-
-	/* delay after tune */
 	int min_delay_ms;
-
-	/* disables reads*/
 	u8 tuner_write_only;
 
 };
diff --git a/drivers/media/dvb-frontends/m88ds3103.h b/drivers/media/dvb-frontends/m88ds3103.h
index 04b355a005fb..1a8964a2265d 100644
--- a/drivers/media/dvb-frontends/m88ds3103.h
+++ b/drivers/media/dvb-frontends/m88ds3103.h
@@ -24,6 +24,34 @@
  * 0x68,
  */
 
+/**
+ * enum m88ds3103_ts_mode - TS connection mode
+ * @M88DS3103_TS_SERIAL:	TS output pin D0, normal
+ * @M88DS3103_TS_SERIAL_D7:	TS output pin D7
+ * @M88DS3103_TS_PARALLEL:	TS Parallel mode
+ * @M88DS3103_TS_CI:		TS CI Mode
+ */
+enum m88ds3103_ts_mode {
+	M88DS3103_TS_SERIAL,
+	M88DS3103_TS_SERIAL_D7,
+	M88DS3103_TS_PARALLEL,
+	M88DS3103_TS_CI
+};
+
+/**
+ * enum m88ds3103_clock_out
+ * @M88DS3103_CLOCK_OUT_DISABLED:	Clock output is disabled
+ * @M88DS3103_CLOCK_OUT_ENABLED:	Clock output is enabled with crystal
+ *					clock.
+ * @M88DS3103_CLOCK_OUT_ENABLED_DIV2:	Clock output is enabled with half
+ *					crystal clock.
+ */
+enum m88ds3103_clock_out {
+	M88DS3103_CLOCK_OUT_DISABLED,
+	M88DS3103_CLOCK_OUT_ENABLED,
+	M88DS3103_CLOCK_OUT_ENABLED_DIV2
+};
+
 /**
  * struct m88ds3103_platform_data - Platform data for the m88ds3103 driver
  * @clk: Clock frequency.
@@ -44,24 +72,16 @@
  * @get_dvb_frontend: Get DVB frontend.
  * @get_i2c_adapter: Get I2C adapter.
  */
-
 struct m88ds3103_platform_data {
 	u32 clk;
 	u16 i2c_wr_max;
-#define M88DS3103_TS_SERIAL             0 /* TS output pin D0, normal */
-#define M88DS3103_TS_SERIAL_D7          1 /* TS output pin D7 */
-#define M88DS3103_TS_PARALLEL           2 /* TS Parallel mode */
-#define M88DS3103_TS_CI                 3 /* TS CI Mode */
-	u8 ts_mode:2;
+	enum m88ds3103_ts_mode ts_mode;
 	u32 ts_clk;
+	enum m88ds3103_clock_out clk_out;
 	u8 ts_clk_pol:1;
 	u8 spec_inv:1;
 	u8 agc;
 	u8 agc_inv:1;
-#define M88DS3103_CLOCK_OUT_DISABLED        0
-#define M88DS3103_CLOCK_OUT_ENABLED         1
-#define M88DS3103_CLOCK_OUT_ENABLED_DIV2    2
-	u8 clk_out:2;
 	u8 envelope_mode:1;
 	u8 lnb_hv_pol:1;
 	u8 lnb_en_pol:1;
@@ -73,105 +93,60 @@ struct m88ds3103_platform_data {
 	u8 attach_in_use:1;
 };
 
-/*
- * Do not add new m88ds3103_attach() users! Use I2C bindings instead.
+/**
+ * struct m88ds3103_config - m88ds3102 configuration
+ *
+ * @i2c_addr:	I2C address. Default: none, must set. Example: 0x68, ...
+ * @clock:	Device's clock. Default: none, must set. Example: 27000000
+ * @i2c_wr_max: Max bytes I2C provider is asked to write at once.
+ *		Default: none, must set. Example: 33, 65, ...
+ * @ts_mode:	TS output mode, as defined by &enum m88ds3103_ts_mode.
+ *		Default: M88DS3103_TS_SERIAL.
+ * @ts_clk:	TS clk in KHz. Default: 0.
+ * @ts_clk_pol:	TS clk polarity.Default: 0.
+ *		1-active at falling edge; 0-active at rising edge.
+ * @spec_inv:	Spectrum inversion. Default: 0.
+ * @agc_inv:	AGC polarity. Default: 0.
+ * @clock_out:	Clock output, as defined by &enum m88ds3103_clock_out.
+ *		Default: M88DS3103_CLOCK_OUT_DISABLED.
+ * @envelope_mode: DiSEqC envelope mode. Default: 0.
+ * @agc:	AGC configuration. Default: none, must set.
+ * @lnb_hv_pol:	LNB H/V pin polarity. Default: 0. Values:
+ *		1: pin high set to VOLTAGE_13, pin low to set VOLTAGE_18;
+ *		0: pin high set to VOLTAGE_18, pin low to set VOLTAGE_13.
+ * @lnb_en_pol:	LNB enable pin polarity. Default: 0. Values:
+ *		1: pin high to enable, pin low to disable;
+ *		0: pin high to disable, pin low to enable.
  */
 struct m88ds3103_config {
-	/*
-	 * I2C address
-	 * Default: none, must set
-	 * 0x68, ...
-	 */
 	u8 i2c_addr;
-
-	/*
-	 * clock
-	 * Default: none, must set
-	 * 27000000
-	 */
 	u32 clock;
-
-	/*
-	 * max bytes I2C provider is asked to write at once
-	 * Default: none, must set
-	 * 33, 65, ...
-	 */
 	u16 i2c_wr_max;
-
-	/*
-	 * TS output mode
-	 * Default: M88DS3103_TS_SERIAL
-	 */
-#define M88DS3103_TS_SERIAL             0 /* TS output pin D0, normal */
-#define M88DS3103_TS_SERIAL_D7          1 /* TS output pin D7 */
-#define M88DS3103_TS_PARALLEL           2 /* TS Parallel mode */
-#define M88DS3103_TS_CI                 3 /* TS CI Mode */
 	u8 ts_mode;
-
-	/*
-	 * TS clk in KHz
-	 * Default: 0.
-	 */
 	u32 ts_clk;
-
-	/*
-	 * TS clk polarity.
-	 * Default: 0. 1-active at falling edge; 0-active at rising edge.
-	 */
 	u8 ts_clk_pol:1;
-
-	/*
-	 * spectrum inversion
-	 * Default: 0
-	 */
 	u8 spec_inv:1;
-
-	/*
-	 * AGC polarity
-	 * Default: 0
-	 */
 	u8 agc_inv:1;
-
-	/*
-	 * clock output
-	 * Default: M88DS3103_CLOCK_OUT_DISABLED
-	 */
-#define M88DS3103_CLOCK_OUT_DISABLED        0
-#define M88DS3103_CLOCK_OUT_ENABLED         1
-#define M88DS3103_CLOCK_OUT_ENABLED_DIV2    2
 	u8 clock_out;
-
-	/*
-	 * DiSEqC envelope mode
-	 * Default: 0
-	 */
 	u8 envelope_mode:1;
-
-	/*
-	 * AGC configuration
-	 * Default: none, must set
-	 */
 	u8 agc;
-
-	/*
-	 * LNB H/V pin polarity
-	 * Default: 0.
-	 * 1: pin high set to VOLTAGE_13, pin low to set VOLTAGE_18.
-	 * 0: pin high set to VOLTAGE_18, pin low to set VOLTAGE_13.
-	 */
 	u8 lnb_hv_pol:1;
-
-	/*
-	 * LNB enable pin polarity
-	 * Default: 0.
-	 * 1: pin high to enable, pin low to disable.
-	 * 0: pin high to disable, pin low to enable.
-	 */
 	u8 lnb_en_pol:1;
 };
 
 #if defined(CONFIG_DVB_M88DS3103) || \
 		(defined(CONFIG_DVB_M88DS3103_MODULE) && defined(MODULE))
+/**
+ * Attach a m88ds3103 demod
+ *
+ * @config: pointer to &struct m88ds3103_config with demod configuration.
+ * @i2c: i2c adapter to use.
+ * @tuner_i2c: on success, returns the I2C adapter associated with
+ *		m88ds3103 tuner.
+ *
+ * return: FE pointer on success, NULL on failure.
+ * Note: Do not add new m88ds3103_attach() users! Use I2C bindings instead.
+ */
 extern struct dvb_frontend *m88ds3103_attach(
 		const struct m88ds3103_config *config,
 		struct i2c_adapter *i2c,
diff --git a/drivers/media/dvb-frontends/mb86a20s.h b/drivers/media/dvb-frontends/mb86a20s.h
index dfb02db2126c..05c9725d1c5f 100644
--- a/drivers/media/dvb-frontends/mb86a20s.h
+++ b/drivers/media/dvb-frontends/mb86a20s.h
@@ -26,7 +26,6 @@
  * @demod_address:	the demodulator's i2c address
  * @is_serial:		if true, TS is serial. Otherwise, TS is parallel
  */
-
 struct mb86a20s_config {
 	u32	fclk;
 	u8	demod_address;
@@ -34,9 +33,17 @@ struct mb86a20s_config {
 };
 
 #if IS_REACHABLE(CONFIG_DVB_MB86A20S)
+/**
+ * Attach a mb86a20s demod
+ *
+ * @config: pointer to &struct mb86a20s_config with demod configuration.
+ * @i2c: i2c adapter to use.
+ *
+ * return: FE pointer on success, NULL on failure.
+ */
 extern struct dvb_frontend *mb86a20s_attach(const struct mb86a20s_config *config,
 					   struct i2c_adapter *i2c);
-extern struct i2c_adapter *mb86a20s_get_tuner_i2c_adapter(struct dvb_frontend *);
+
 #else
 static inline struct dvb_frontend *mb86a20s_attach(
 	const struct mb86a20s_config *config, struct i2c_adapter *i2c)
@@ -44,12 +51,6 @@ static inline struct dvb_frontend *mb86a20s_attach(
 	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
-static inline struct i2c_adapter *
-	mb86a20s_get_tuner_i2c_adapter(struct dvb_frontend *fe)
-{
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
-	return NULL;
-}
 #endif
 
 #endif /* MB86A20S */
diff --git a/drivers/media/dvb-frontends/rtl2830.h b/drivers/media/dvb-frontends/rtl2830.h
index 0cde151e6608..458ac94e8a8b 100644
--- a/drivers/media/dvb-frontends/rtl2830.h
+++ b/drivers/media/dvb-frontends/rtl2830.h
@@ -32,7 +32,6 @@
  * @pid_filter: Set PID to PID filter.
  * @pid_filter_ctrl: Control PID filter.
  */
-
 struct rtl2830_platform_data {
 	u32 clk;
 	bool spec_inv;
diff --git a/drivers/media/dvb-frontends/rtl2832.h b/drivers/media/dvb-frontends/rtl2832.h
index 03c0de039fa9..6a124ff71c2b 100644
--- a/drivers/media/dvb-frontends/rtl2832.h
+++ b/drivers/media/dvb-frontends/rtl2832.h
@@ -35,7 +35,6 @@
  * @pid_filter: Set PID to PID filter.
  * @pid_filter_ctrl: Control PID filter.
  */
-
 struct rtl2832_platform_data {
 	u32 clk;
 	/*
diff --git a/drivers/media/dvb-frontends/stb6000.h b/drivers/media/dvb-frontends/stb6000.h
index 3c4d51dd5415..e94a3d5facf6 100644
--- a/drivers/media/dvb-frontends/stb6000.h
+++ b/drivers/media/dvb-frontends/stb6000.h
@@ -26,6 +26,7 @@
 #include <linux/i2c.h>
 #include "dvb_frontend.h"
 
+#if IS_REACHABLE(CONFIG_DVB_STB6000)
 /**
  * Attach a stb6000 tuner to the supplied frontend structure.
  *
@@ -35,7 +36,6 @@
  *
  * return: FE pointer on success, NULL on failure.
  */
-#if IS_REACHABLE(CONFIG_DVB_STB6000)
 extern struct dvb_frontend *stb6000_attach(struct dvb_frontend *fe, int addr,
 					   struct i2c_adapter *i2c);
 #else
diff --git a/drivers/media/dvb-frontends/tda10071.h b/drivers/media/dvb-frontends/tda10071.h
index 8f184026ee11..da1a87bc1603 100644
--- a/drivers/media/dvb-frontends/tda10071.h
+++ b/drivers/media/dvb-frontends/tda10071.h
@@ -38,7 +38,6 @@
  * @tuner_i2c_addr: CX24118A tuner I2C address (0x14, 0x54, ...).
  * @get_dvb_frontend: Get DVB frontend.
  */
-
 struct tda10071_platform_data {
 	u32 clk;
 	u16 i2c_wr_max;
diff --git a/drivers/media/dvb-frontends/zd1301_demod.h b/drivers/media/dvb-frontends/zd1301_demod.h
index 9496f7e8b4dd..6cd8f6f9c415 100644
--- a/drivers/media/dvb-frontends/zd1301_demod.h
+++ b/drivers/media/dvb-frontends/zd1301_demod.h
@@ -52,6 +52,12 @@ struct i2c_adapter *zd1301_demod_get_i2c_adapter(struct platform_device *pdev);
 
 #else
 
+/**
+ * zd1301_demod_get_dvb_frontend() - Attach a zd1301 frontend
+ * @dev: Pointer to platform device
+ *
+ * Return: Pointer to %struct dvb_frontend or NULL if attach fails.
+ */
 static inline struct dvb_frontend *zd1301_demod_get_dvb_frontend(struct platform_device *dev)
 {
 	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
-- 
2.14.3
