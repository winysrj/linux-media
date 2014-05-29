Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35999 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756322AbaE2MU0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 May 2014 08:20:26 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 5/5] dib8000: export just one symbol
Date: Thu, 29 May 2014 09:20:17 -0300
Message-Id: <1401366017-19874-6-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1401366017-19874-1-git-send-email-m.chehab@samsung.com>
References: <1401366017-19874-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Exporting multiple symbols don't work as it causes compilation
breakages, due to the way dvb_attach() works.

The bug happens when:
        CONFIG_DVB_DIB8000=m
	CONFIG_DVB_USB_DIB0700=y

As a bonus, dib8000 won't be loaded anymore if the device uses
a different frontend, reducing the memory footprint.

Tested with both Pixelview PV-D231 and MyGica S870.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/dib8000.c       |  88 ++++++++--------
 drivers/media/dvb-frontends/dib8000.h       | 150 +++++-----------------------
 drivers/media/usb/dvb-usb/dib0700_devices.c | 138 ++++++++++++++++---------
 3 files changed, 164 insertions(+), 212 deletions(-)

diff --git a/drivers/media/dvb-frontends/dib8000.c b/drivers/media/dvb-frontends/dib8000.c
index c1c8c92ce498..270a58e3e837 100644
--- a/drivers/media/dvb-frontends/dib8000.c
+++ b/drivers/media/dvb-frontends/dib8000.c
@@ -656,7 +656,7 @@ static int dib8000_sad_calib(struct dib8000_state *state)
 	return 0;
 }
 
-int dib8000_set_wbd_ref(struct dvb_frontend *fe, u16 value)
+static int dib8000_set_wbd_ref(struct dvb_frontend *fe, u16 value)
 {
 	struct dib8000_state *state = fe->demodulator_priv;
 	if (value > 4095)
@@ -664,7 +664,6 @@ int dib8000_set_wbd_ref(struct dvb_frontend *fe, u16 value)
 	state->wbd_ref = value;
 	return dib8000_write_word(state, 106, value);
 }
-EXPORT_SYMBOL(dib8000_set_wbd_ref);
 
 static void dib8000_reset_pll_common(struct dib8000_state *state, const struct dibx000_bandwidth_config *bw)
 {
@@ -739,7 +738,7 @@ static void dib8000_reset_pll(struct dib8000_state *state)
 	dib8000_reset_pll_common(state, pll);
 }
 
-int dib8000_update_pll(struct dvb_frontend *fe,
+static int dib8000_update_pll(struct dvb_frontend *fe,
 		struct dibx000_bandwidth_config *pll, u32 bw, u8 ratio)
 {
 	struct dib8000_state *state = fe->demodulator_priv;
@@ -815,8 +814,6 @@ int dib8000_update_pll(struct dvb_frontend *fe,
 
 	return 0;
 }
-EXPORT_SYMBOL(dib8000_update_pll);
-
 
 static int dib8000_reset_gpio(struct dib8000_state *st)
 {
@@ -849,13 +846,12 @@ static int dib8000_cfg_gpio(struct dib8000_state *st, u8 num, u8 dir, u8 val)
 	return 0;
 }
 
-int dib8000_set_gpio(struct dvb_frontend *fe, u8 num, u8 dir, u8 val)
+static int dib8000_set_gpio(struct dvb_frontend *fe, u8 num, u8 dir, u8 val)
 {
 	struct dib8000_state *state = fe->demodulator_priv;
 	return dib8000_cfg_gpio(state, num, dir, val);
 }
 
-EXPORT_SYMBOL(dib8000_set_gpio);
 static const u16 dib8000_defaults[] = {
 	/* auto search configuration - lock0 by default waiting
 	 * for cpil_lock; lock1 cpil_lock; lock2 tmcc_sync_lock */
@@ -1228,13 +1224,12 @@ static int dib8000_set_agc_config(struct dib8000_state *state, u8 band)
 	return 0;
 }
 
-void dib8000_pwm_agc_reset(struct dvb_frontend *fe)
+static void dib8000_pwm_agc_reset(struct dvb_frontend *fe)
 {
 	struct dib8000_state *state = fe->demodulator_priv;
 	dib8000_set_adc_state(state, DIBX000_ADC_ON);
 	dib8000_set_agc_config(state, (unsigned char)(BAND_OF_FREQUENCY(fe->dtv_property_cache.frequency / 1000)));
 }
-EXPORT_SYMBOL(dib8000_pwm_agc_reset);
 
 static int dib8000_agc_soft_split(struct dib8000_state *state)
 {
@@ -1881,14 +1876,13 @@ static struct i2c_algorithm dib8096p_tuner_xfer_algo = {
 	.functionality = dib8096p_i2c_func,
 };
 
-struct i2c_adapter *dib8096p_get_i2c_tuner(struct dvb_frontend *fe)
+static struct i2c_adapter *dib8096p_get_i2c_tuner(struct dvb_frontend *fe)
 {
 	struct dib8000_state *st = fe->demodulator_priv;
 	return &st->dib8096p_tuner_adap;
 }
-EXPORT_SYMBOL(dib8096p_get_i2c_tuner);
 
-int dib8096p_tuner_sleep(struct dvb_frontend *fe, int onoff)
+static int dib8096p_tuner_sleep(struct dvb_frontend *fe, int onoff)
 {
 	struct dib8000_state *state = fe->demodulator_priv;
 	u16 en_cur_state;
@@ -1912,14 +1906,13 @@ int dib8096p_tuner_sleep(struct dvb_frontend *fe, int onoff)
 
 	return 0;
 }
-EXPORT_SYMBOL(dib8096p_tuner_sleep);
 
 static const s32 lut_1000ln_mant[] =
 {
 	908, 7003, 7090, 7170, 7244, 7313, 7377, 7438, 7495, 7549, 7600
 };
 
-s32 dib8000_get_adc_power(struct dvb_frontend *fe, u8 mode)
+static s32 dib8000_get_adc_power(struct dvb_frontend *fe, u8 mode)
 {
 	struct dib8000_state *state = fe->demodulator_priv;
 	u32 ix = 0, tmp_val = 0, exp = 0, mant = 0;
@@ -1937,9 +1930,8 @@ s32 dib8000_get_adc_power(struct dvb_frontend *fe, u8 mode)
 	}
 	return val;
 }
-EXPORT_SYMBOL(dib8000_get_adc_power);
 
-int dib8090p_get_dc_power(struct dvb_frontend *fe, u8 IQ)
+static int dib8090p_get_dc_power(struct dvb_frontend *fe, u8 IQ)
 {
 	struct dib8000_state *state = fe->demodulator_priv;
 	int val = 0;
@@ -1957,7 +1949,6 @@ int dib8090p_get_dc_power(struct dvb_frontend *fe, u8 IQ)
 
 	return val;
 }
-EXPORT_SYMBOL(dib8090p_get_dc_power);
 
 static void dib8000_update_timf(struct dib8000_state *state)
 {
@@ -1968,7 +1959,7 @@ static void dib8000_update_timf(struct dib8000_state *state)
 	dprintk("Updated timing frequency: %d (default: %d)", state->timf, state->timf_default);
 }
 
-u32 dib8000_ctrl_timf(struct dvb_frontend *fe, uint8_t op, uint32_t timf)
+static u32 dib8000_ctrl_timf(struct dvb_frontend *fe, uint8_t op, uint32_t timf)
 {
 	struct dib8000_state *state = fe->demodulator_priv;
 
@@ -1986,7 +1977,6 @@ u32 dib8000_ctrl_timf(struct dvb_frontend *fe, uint8_t op, uint32_t timf)
 
 	return state->timf;
 }
-EXPORT_SYMBOL(dib8000_ctrl_timf);
 
 static const u16 adc_target_16dB[11] = {
 	(1 << 13) - 825 - 117,
@@ -2870,21 +2860,19 @@ static s32 dib8000_get_status(struct dvb_frontend *fe)
 	return state->status;
 }
 
-enum frontend_tune_state dib8000_get_tune_state(struct dvb_frontend *fe)
+static enum frontend_tune_state dib8000_get_tune_state(struct dvb_frontend *fe)
 {
 	struct dib8000_state *state = fe->demodulator_priv;
 	return state->tune_state;
 }
-EXPORT_SYMBOL(dib8000_get_tune_state);
 
-int dib8000_set_tune_state(struct dvb_frontend *fe, enum frontend_tune_state tune_state)
+static int dib8000_set_tune_state(struct dvb_frontend *fe, enum frontend_tune_state tune_state)
 {
 	struct dib8000_state *state = fe->demodulator_priv;
 
 	state->tune_state = tune_state;
 	return 0;
 }
-EXPORT_SYMBOL(dib8000_set_tune_state);
 
 static int dib8000_tune_restart_from_demod(struct dvb_frontend *fe)
 {
@@ -4201,7 +4189,7 @@ static int dib8000_get_stats(struct dvb_frontend *fe, fe_status_t stat)
 	return 0;
 }
 
-int dib8000_set_slave_frontend(struct dvb_frontend *fe, struct dvb_frontend *fe_slave)
+static int dib8000_set_slave_frontend(struct dvb_frontend *fe, struct dvb_frontend *fe_slave)
 {
 	struct dib8000_state *state = fe->demodulator_priv;
 	u8 index_frontend = 1;
@@ -4217,9 +4205,8 @@ int dib8000_set_slave_frontend(struct dvb_frontend *fe, struct dvb_frontend *fe_
 	dprintk("too many slave frontend");
 	return -ENOMEM;
 }
-EXPORT_SYMBOL(dib8000_set_slave_frontend);
 
-int dib8000_remove_slave_frontend(struct dvb_frontend *fe)
+static int dib8000_remove_slave_frontend(struct dvb_frontend *fe)
 {
 	struct dib8000_state *state = fe->demodulator_priv;
 	u8 index_frontend = 1;
@@ -4235,9 +4222,8 @@ int dib8000_remove_slave_frontend(struct dvb_frontend *fe)
 	dprintk("no frontend to be removed");
 	return -ENODEV;
 }
-EXPORT_SYMBOL(dib8000_remove_slave_frontend);
 
-struct dvb_frontend *dib8000_get_slave_frontend(struct dvb_frontend *fe, int slave_index)
+static struct dvb_frontend *dib8000_get_slave_frontend(struct dvb_frontend *fe, int slave_index)
 {
 	struct dib8000_state *state = fe->demodulator_priv;
 
@@ -4245,10 +4231,8 @@ struct dvb_frontend *dib8000_get_slave_frontend(struct dvb_frontend *fe, int sla
 		return NULL;
 	return state->fe[slave_index];
 }
-EXPORT_SYMBOL(dib8000_get_slave_frontend);
-
 
-int dib8000_i2c_enumeration(struct i2c_adapter *host, int no_of_demods,
+static int dib8000_i2c_enumeration(struct i2c_adapter *host, int no_of_demods,
 		u8 default_addr, u8 first_addr, u8 is_dib8096p)
 {
 	int k = 0, ret = 0;
@@ -4325,7 +4309,6 @@ error_memory_read:
 	return ret;
 }
 
-EXPORT_SYMBOL(dib8000_i2c_enumeration);
 static int dib8000_fe_get_tune_settings(struct dvb_frontend *fe, struct dvb_frontend_tune_settings *tune)
 {
 	tune->min_delay_ms = 1000;
@@ -4348,15 +4331,13 @@ static void dib8000_release(struct dvb_frontend *fe)
 	kfree(st);
 }
 
-struct i2c_adapter *dib8000_get_i2c_master(struct dvb_frontend *fe, enum dibx000_i2c_interface intf, int gating)
+static struct i2c_adapter *dib8000_get_i2c_master(struct dvb_frontend *fe, enum dibx000_i2c_interface intf, int gating)
 {
 	struct dib8000_state *st = fe->demodulator_priv;
 	return dibx000_get_i2c_adapter(&st->i2c_master, intf, gating);
 }
 
-EXPORT_SYMBOL(dib8000_get_i2c_master);
-
-int dib8000_pid_filter_ctrl(struct dvb_frontend *fe, u8 onoff)
+static int dib8000_pid_filter_ctrl(struct dvb_frontend *fe, u8 onoff)
 {
 	struct dib8000_state *st = fe->demodulator_priv;
 	u16 val = dib8000_read_word(st, 299) & 0xffef;
@@ -4365,15 +4346,13 @@ int dib8000_pid_filter_ctrl(struct dvb_frontend *fe, u8 onoff)
 	dprintk("pid filter enabled %d", onoff);
 	return dib8000_write_word(st, 299, val);
 }
-EXPORT_SYMBOL(dib8000_pid_filter_ctrl);
 
-int dib8000_pid_filter(struct dvb_frontend *fe, u8 id, u16 pid, u8 onoff)
+static int dib8000_pid_filter(struct dvb_frontend *fe, u8 id, u16 pid, u8 onoff)
 {
 	struct dib8000_state *st = fe->demodulator_priv;
 	dprintk("Index %x, PID %d, OnOff %d", id, pid, onoff);
 	return dib8000_write_word(st, 305 + id, onoff ? (1 << 13) | pid : 0);
 }
-EXPORT_SYMBOL(dib8000_pid_filter);
 
 static const struct dvb_frontend_ops dib8000_ops = {
 	.delsys = { SYS_ISDBT },
@@ -4405,7 +4384,7 @@ static const struct dvb_frontend_ops dib8000_ops = {
 	.read_ucblocks = dib8000_read_unc_blocks,
 };
 
-struct dvb_frontend *dib8000_init(struct i2c_adapter *i2c_adap, u8 i2c_addr, struct dib8000_config *cfg)
+static struct dvb_frontend *dib8000_init(struct i2c_adapter *i2c_adap, u8 i2c_addr, struct dib8000_config *cfg)
 {
 	struct dvb_frontend *fe;
 	struct dib8000_state *state;
@@ -4467,7 +4446,34 @@ error:
 	return NULL;
 }
 
-EXPORT_SYMBOL(dib8000_init);
+void *dib8000_attach(struct dib8000_ops *ops)
+{
+	if (!ops)
+		return NULL;
+
+	ops->pwm_agc_reset = dib8000_pwm_agc_reset;
+	ops->get_dc_power = dib8090p_get_dc_power;
+	ops->set_gpio = dib8000_set_gpio;
+	ops->get_slave_frontend = dib8000_get_slave_frontend;
+	ops->set_tune_state = dib8000_set_tune_state;
+	ops->pid_filter_ctrl = dib8000_pid_filter_ctrl;
+	ops->remove_slave_frontend = dib8000_remove_slave_frontend;
+	ops->get_adc_power = dib8000_get_adc_power;
+	ops->update_pll = dib8000_update_pll;
+	ops->tuner_sleep = dib8096p_tuner_sleep;
+	ops->get_tune_state = dib8000_get_tune_state;
+	ops->get_i2c_tuner = dib8096p_get_i2c_tuner;
+	ops->set_slave_frontend = dib8000_set_slave_frontend;
+	ops->pid_filter = dib8000_pid_filter;
+	ops->ctrl_timf = dib8000_ctrl_timf;
+	ops->init = dib8000_init;
+	ops->get_i2c_master = dib8000_get_i2c_master;
+	ops->i2c_enumeration = dib8000_i2c_enumeration;
+	ops->set_wbd_ref = dib8000_set_wbd_ref;
+
+	return ops;
+}
+EXPORT_SYMBOL(dib8000_attach);
 
 MODULE_AUTHOR("Olivier Grenie <Olivier.Grenie@dibcom.fr, " "Patrick Boettcher <pboettcher@dibcom.fr>");
 MODULE_DESCRIPTION("Driver for the DiBcom 8000 ISDB-T demodulator");
diff --git a/drivers/media/dvb-frontends/dib8000.h b/drivers/media/dvb-frontends/dib8000.h
index 89962d640e4c..84cc10383dcd 100644
--- a/drivers/media/dvb-frontends/dib8000.h
+++ b/drivers/media/dvb-frontends/dib8000.h
@@ -39,134 +39,34 @@ struct dib8000_config {
 
 #define DEFAULT_DIB8000_I2C_ADDRESS 18
 
-#if IS_ENABLED(CONFIG_DVB_DIB8000)
-extern struct dvb_frontend *dib8000_init(struct i2c_adapter *i2c_adap, u8 i2c_addr, struct dib8000_config *cfg);
-extern struct i2c_adapter *dib8000_get_i2c_master(struct dvb_frontend *, enum dibx000_i2c_interface, int);
-
-extern int dib8000_i2c_enumeration(struct i2c_adapter *host, int no_of_demods,
+struct dib8000_ops {
+	int (*set_wbd_ref)(struct dvb_frontend *fe, u16 value);
+	int (*update_pll)(struct dvb_frontend *fe,
+		struct dibx000_bandwidth_config *pll, u32 bw, u8 ratio);
+	int (*set_gpio)(struct dvb_frontend *fe, u8 num, u8 dir, u8 val);
+	void (*pwm_agc_reset)(struct dvb_frontend *fe);
+	struct i2c_adapter *(*get_i2c_tuner)(struct dvb_frontend *fe);
+	int (*tuner_sleep)(struct dvb_frontend *fe, int onoff);
+	s32 (*get_adc_power)(struct dvb_frontend *fe, u8 mode);
+	int (*get_dc_power)(struct dvb_frontend *fe, u8 IQ);
+	u32 (*ctrl_timf)(struct dvb_frontend *fe, uint8_t op, uint32_t timf);
+	enum frontend_tune_state (*get_tune_state)(struct dvb_frontend *fe);
+	int (*set_tune_state)(struct dvb_frontend *fe, enum frontend_tune_state tune_state);
+	int (*set_slave_frontend)(struct dvb_frontend *fe, struct dvb_frontend *fe_slave);
+	int (*remove_slave_frontend)(struct dvb_frontend *fe);
+	struct dvb_frontend *(*get_slave_frontend)(struct dvb_frontend *fe, int slave_index);
+	int (*i2c_enumeration)(struct i2c_adapter *host, int no_of_demods,
 		u8 default_addr, u8 first_addr, u8 is_dib8096p);
+	struct i2c_adapter *(*get_i2c_master)(struct dvb_frontend *fe, enum dibx000_i2c_interface intf, int gating);
+	int (*pid_filter_ctrl)(struct dvb_frontend *fe, u8 onoff);
+	int (*pid_filter)(struct dvb_frontend *fe, u8 id, u16 pid, u8 onoff);
+	struct dvb_frontend *(*init)(struct i2c_adapter *i2c_adap, u8 i2c_addr, struct dib8000_config *cfg);
+};
 
-extern int dib8000_set_gpio(struct dvb_frontend *, u8 num, u8 dir, u8 val);
-extern int dib8000_set_wbd_ref(struct dvb_frontend *, u16 value);
-extern int dib8000_pid_filter_ctrl(struct dvb_frontend *, u8 onoff);
-extern int dib8000_pid_filter(struct dvb_frontend *, u8 id, u16 pid, u8 onoff);
-extern int dib8000_set_tune_state(struct dvb_frontend *fe, enum frontend_tune_state tune_state);
-extern enum frontend_tune_state dib8000_get_tune_state(struct dvb_frontend *fe);
-extern void dib8000_pwm_agc_reset(struct dvb_frontend *fe);
-extern s32 dib8000_get_adc_power(struct dvb_frontend *fe, u8 mode);
-extern struct i2c_adapter *dib8096p_get_i2c_tuner(struct dvb_frontend *fe);
-extern int dib8096p_tuner_sleep(struct dvb_frontend *fe, int onoff);
-extern int dib8090p_get_dc_power(struct dvb_frontend *fe, u8 IQ);
-extern u32 dib8000_ctrl_timf(struct dvb_frontend *fe,
-		uint8_t op, uint32_t timf);
-extern int dib8000_update_pll(struct dvb_frontend *fe,
-		struct dibx000_bandwidth_config *pll, u32 bw, u8 ratio);
-extern int dib8000_set_slave_frontend(struct dvb_frontend *fe, struct dvb_frontend *fe_slave);
-extern int dib8000_remove_slave_frontend(struct dvb_frontend *fe);
-extern struct dvb_frontend *dib8000_get_slave_frontend(struct dvb_frontend *fe, int slave_index);
+#if IS_ENABLED(CONFIG_DVB_DIB8000)
+void *dib8000_attach(struct dib8000_ops *ops);
 #else
-static inline struct dvb_frontend *dib8000_init(struct i2c_adapter *i2c_adap, u8 i2c_addr, struct dib8000_config *cfg)
-{
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
-	return NULL;
-}
-
-static inline struct i2c_adapter *dib8000_get_i2c_master(struct dvb_frontend *fe, enum dibx000_i2c_interface i, int x)
-{
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
-	return NULL;
-}
-
-static inline int dib8000_i2c_enumeration(struct i2c_adapter *host,
-		int no_of_demods, u8 default_addr, u8 first_addr,
-		u8 is_dib8096p)
-{
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
-	return -ENODEV;
-}
-
-static inline int dib8000_set_gpio(struct dvb_frontend *fe, u8 num, u8 dir, u8 val)
-{
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
-	return -ENODEV;
-}
-
-static inline int dib8000_set_wbd_ref(struct dvb_frontend *fe, u16 value)
-{
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
-	return -ENODEV;
-}
-
-static inline int dib8000_pid_filter_ctrl(struct dvb_frontend *fe, u8 onoff)
-{
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
-	return -ENODEV;
-}
-
-static inline int dib8000_pid_filter(struct dvb_frontend *fe, u8 id, u16 pid, u8 onoff)
-{
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
-	return -ENODEV;
-}
-static inline int dib8000_set_tune_state(struct dvb_frontend *fe, enum frontend_tune_state tune_state)
-{
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
-	return -ENODEV;
-}
-static inline enum frontend_tune_state dib8000_get_tune_state(struct dvb_frontend *fe)
-{
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
-	return CT_SHUTDOWN;
-}
-static inline void dib8000_pwm_agc_reset(struct dvb_frontend *fe)
-{
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
-}
-static inline struct i2c_adapter *dib8096p_get_i2c_tuner(struct dvb_frontend *fe)
-{
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
-	return NULL;
-}
-static inline int dib8096p_tuner_sleep(struct dvb_frontend *fe, int onoff)
-{
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
-	return 0;
-}
-static inline s32 dib8000_get_adc_power(struct dvb_frontend *fe, u8 mode)
-{
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
-	return 0;
-}
-static inline int dib8090p_get_dc_power(struct dvb_frontend *fe, u8 IQ)
-{
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
-	return 0;
-}
-static inline u32 dib8000_ctrl_timf(struct dvb_frontend *fe,
-		uint8_t op, uint32_t timf)
-{
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
-	return 0;
-}
-static inline int dib8000_update_pll(struct dvb_frontend *fe,
-		struct dibx000_bandwidth_config *pll, u32 bw, u8 ratio)
-{
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
-	return -ENODEV;
-}
-static inline int dib8000_set_slave_frontend(struct dvb_frontend *fe, struct dvb_frontend *fe_slave)
-{
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
-	return -ENODEV;
-}
-
-int dib8000_remove_slave_frontend(struct dvb_frontend *fe)
-{
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
-	return -ENODEV;
-}
-
-static inline struct dvb_frontend *dib8000_get_slave_frontend(struct dvb_frontend *fe, int slave_index)
+static inline int dib8000_attach(struct dib8000_ops *ops)
 {
 	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
diff --git a/drivers/media/usb/dvb-usb/dib0700_devices.c b/drivers/media/usb/dvb-usb/dib0700_devices.c
index 424832cb4444..3d46415cb4e0 100644
--- a/drivers/media/usb/dvb-usb/dib0700_devices.c
+++ b/drivers/media/usb/dvb-usb/dib0700_devices.c
@@ -33,6 +33,7 @@ struct dib0700_adapter_state {
 	int (*set_param_save) (struct dvb_frontend *);
 	const struct firmware *frontend_firmware;
 	struct dib7000p_ops dib7000p_ops;
+	struct dib8000_ops dib8000_ops;
 };
 
 /* Hauppauge Nova-T 500 (aka Bristol)
@@ -1216,12 +1217,18 @@ static struct dib8000_config dib807x_dib8000_config[2] = {
 
 static int dib80xx_tuner_reset(struct dvb_frontend *fe, int onoff)
 {
-	return dib8000_set_gpio(fe, 5, 0, !onoff);
+	struct dvb_usb_adapter *adap = fe->dvb->priv;
+	struct dib0700_adapter_state *state = adap->priv;
+
+	return state->dib8000_ops.set_gpio(fe, 5, 0, !onoff);
 }
 
 static int dib80xx_tuner_sleep(struct dvb_frontend *fe, int onoff)
 {
-	return dib8000_set_gpio(fe, 0, 0, onoff);
+	struct dvb_usb_adapter *adap = fe->dvb->priv;
+	struct dib0700_adapter_state *state = adap->priv;
+
+	return state->dib8000_ops.set_gpio(fe, 0, 0, onoff);
 }
 
 static const struct dib0070_wbd_gain_cfg dib8070_wbd_gain_cfg[] = {
@@ -1278,7 +1285,7 @@ static int dib807x_set_param_override(struct dvb_frontend *fe)
 		offset += 250; break;
 	}
 	deb_info("WBD for DiB8000: %d\n", offset);
-	dib8000_set_wbd_ref(fe, offset);
+	state->dib8000_ops.set_wbd_ref(fe, offset);
 
 	return state->set_param_save(fe);
 }
@@ -1286,7 +1293,7 @@ static int dib807x_set_param_override(struct dvb_frontend *fe)
 static int dib807x_tuner_attach(struct dvb_usb_adapter *adap)
 {
 	struct dib0700_adapter_state *st = adap->priv;
-	struct i2c_adapter *tun_i2c = dib8000_get_i2c_master(adap->fe_adap[0].fe,
+	struct i2c_adapter *tun_i2c = st->dib8000_ops.get_i2c_master(adap->fe_adap[0].fe,
 			DIBX000_I2C_INTERFACE_TUNER, 1);
 
 	if (adap->id == 0) {
@@ -1307,18 +1314,27 @@ static int dib807x_tuner_attach(struct dvb_usb_adapter *adap)
 static int stk80xx_pid_filter(struct dvb_usb_adapter *adapter, int index,
 	u16 pid, int onoff)
 {
-	return dib8000_pid_filter(adapter->fe_adap[0].fe, index, pid, onoff);
+	struct dib0700_adapter_state *state = adapter->priv;
+
+	return state->dib8000_ops.pid_filter(adapter->fe_adap[0].fe, index, pid, onoff);
 }
 
 static int stk80xx_pid_filter_ctrl(struct dvb_usb_adapter *adapter,
 		int onoff)
 {
-	return dib8000_pid_filter_ctrl(adapter->fe_adap[0].fe, onoff);
+	struct dib0700_adapter_state *state = adapter->priv;
+
+	return state->dib8000_ops.pid_filter_ctrl(adapter->fe_adap[0].fe, onoff);
 }
 
 /* STK807x */
 static int stk807x_frontend_attach(struct dvb_usb_adapter *adap)
 {
+	struct dib0700_adapter_state *state = adap->priv;
+
+	if (!dvb_attach(dib8000_attach, &state->dib8000_ops))
+		return -ENODEV;
+
 	dib0700_set_gpio(adap->dev, GPIO6, GPIO_OUT, 1);
 	msleep(10);
 	dib0700_set_gpio(adap->dev, GPIO9, GPIO_OUT, 1);
@@ -1334,10 +1350,10 @@ static int stk807x_frontend_attach(struct dvb_usb_adapter *adap)
 	msleep(10);
 	dib0700_set_gpio(adap->dev, GPIO0, GPIO_OUT, 1);
 
-	dib8000_i2c_enumeration(&adap->dev->i2c_adap, 1, 18,
+	state->dib8000_ops.i2c_enumeration(&adap->dev->i2c_adap, 1, 18,
 				0x80, 0);
 
-	adap->fe_adap[0].fe = dvb_attach(dib8000_init, &adap->dev->i2c_adap, 0x80,
+	adap->fe_adap[0].fe = state->dib8000_ops.init(&adap->dev->i2c_adap, 0x80,
 			      &dib807x_dib8000_config[0]);
 
 	return adap->fe_adap[0].fe == NULL ?  -ENODEV : 0;
@@ -1346,6 +1362,11 @@ static int stk807x_frontend_attach(struct dvb_usb_adapter *adap)
 /* STK807xPVR */
 static int stk807xpvr_frontend_attach0(struct dvb_usb_adapter *adap)
 {
+	struct dib0700_adapter_state *state = adap->priv;
+
+	if (!dvb_attach(dib8000_attach, &state->dib8000_ops))
+		return -ENODEV;
+
 	dib0700_set_gpio(adap->dev, GPIO6, GPIO_OUT, 0);
 	msleep(30);
 	dib0700_set_gpio(adap->dev, GPIO6, GPIO_OUT, 1);
@@ -1364,9 +1385,9 @@ static int stk807xpvr_frontend_attach0(struct dvb_usb_adapter *adap)
 	dib0700_set_gpio(adap->dev, GPIO0, GPIO_OUT, 1);
 
 	/* initialize IC 0 */
-	dib8000_i2c_enumeration(&adap->dev->i2c_adap, 1, 0x22, 0x80, 0);
+	state->dib8000_ops.i2c_enumeration(&adap->dev->i2c_adap, 1, 0x22, 0x80, 0);
 
-	adap->fe_adap[0].fe = dvb_attach(dib8000_init, &adap->dev->i2c_adap, 0x80,
+	adap->fe_adap[0].fe = state->dib8000_ops.init(&adap->dev->i2c_adap, 0x80,
 			      &dib807x_dib8000_config[0]);
 
 	return adap->fe_adap[0].fe == NULL ? -ENODEV : 0;
@@ -1374,10 +1395,15 @@ static int stk807xpvr_frontend_attach0(struct dvb_usb_adapter *adap)
 
 static int stk807xpvr_frontend_attach1(struct dvb_usb_adapter *adap)
 {
+	struct dib0700_adapter_state *state = adap->priv;
+
+	if (!dvb_attach(dib8000_attach, &state->dib8000_ops))
+		return -ENODEV;
+
 	/* initialize IC 1 */
-	dib8000_i2c_enumeration(&adap->dev->i2c_adap, 1, 0x12, 0x82, 0);
+	state->dib8000_ops.i2c_enumeration(&adap->dev->i2c_adap, 1, 0x12, 0x82, 0);
 
-	adap->fe_adap[0].fe = dvb_attach(dib8000_init, &adap->dev->i2c_adap, 0x82,
+	adap->fe_adap[0].fe = state->dib8000_ops.init(&adap->dev->i2c_adap, 0x82,
 			      &dib807x_dib8000_config[1]);
 
 	return adap->fe_adap[0].fe == NULL ? -ENODEV : 0;
@@ -1483,7 +1509,10 @@ static struct dibx000_bandwidth_config dib8090_pll_config_12mhz = {
 
 static int dib8090_get_adc_power(struct dvb_frontend *fe)
 {
-	return dib8000_get_adc_power(fe, 1);
+	struct dvb_usb_adapter *adap = fe->dvb->priv;
+	struct dib0700_adapter_state *state = adap->priv;
+
+	return state->dib8000_ops.get_adc_power(fe, 1);
 }
 
 static void dib8090_agc_control(struct dvb_frontend *fe, u8 restart)
@@ -1606,10 +1635,10 @@ static int dib8096_set_param_override(struct dvb_frontend *fe)
 	default:
 			deb_info("Warning : Rf frequency  (%iHz) is not in the supported range, using VHF switch ", fe->dtv_property_cache.frequency);
 	case BAND_VHF:
-			dib8000_set_gpio(fe, 3, 0, 1);
+			state->dib8000_ops.set_gpio(fe, 3, 0, 1);
 			break;
 	case BAND_UHF:
-			dib8000_set_gpio(fe, 3, 0, 0);
+			state->dib8000_ops.set_gpio(fe, 3, 0, 0);
 			break;
 	}
 
@@ -1623,7 +1652,7 @@ static int dib8096_set_param_override(struct dvb_frontend *fe)
 	}
 
 	/** Update PLL if needed ratio **/
-	dib8000_update_pll(fe, &dib8090_pll_config_12mhz, fe->dtv_property_cache.bandwidth_hz / 1000, 0);
+	state->dib8000_ops.update_pll(fe, &dib8090_pll_config_12mhz, fe->dtv_property_cache.bandwidth_hz / 1000, 0);
 
 	/** Get optimize PLL ratio to remove spurious **/
 	pll_ratio = dib8090_compute_pll_parameters(fe);
@@ -1637,14 +1666,14 @@ static int dib8096_set_param_override(struct dvb_frontend *fe)
 		timf = 18179756;
 
 	/** Update ratio **/
-	dib8000_update_pll(fe, &dib8090_pll_config_12mhz, fe->dtv_property_cache.bandwidth_hz / 1000, pll_ratio);
+	state->dib8000_ops.update_pll(fe, &dib8090_pll_config_12mhz, fe->dtv_property_cache.bandwidth_hz / 1000, pll_ratio);
 
-	dib8000_ctrl_timf(fe, DEMOD_TIMF_SET, timf);
+	state->dib8000_ops.ctrl_timf(fe, DEMOD_TIMF_SET, timf);
 
 	if (band != BAND_CBAND) {
 		/* dib0090_get_wbd_target is returning any possible temperature compensated wbd-target */
 		target = (dib0090_get_wbd_target(fe) * 8 * 18 / 33 + 1) / 2;
-		dib8000_set_wbd_ref(fe, target);
+		state->dib8000_ops.set_wbd_ref(fe, target);
 	}
 
 	if (band == BAND_CBAND) {
@@ -1656,18 +1685,18 @@ static int dib8096_set_param_override(struct dvb_frontend *fe)
 			msleep(ret);
 			tune_state = dib0090_get_tune_state(fe);
 			if (tune_state == CT_AGC_STEP_0)
-				dib8000_set_gpio(fe, 6, 0, 1);
+				state->dib8000_ops.set_gpio(fe, 6, 0, 1);
 			else if (tune_state == CT_AGC_STEP_1) {
 				dib0090_get_current_gain(fe, NULL, NULL, &rf_gain_limit, &ltgain);
 				if (rf_gain_limit < 2000) /* activate the external attenuator in case of very high input power */
-					dib8000_set_gpio(fe, 6, 0, 0);
+					state->dib8000_ops.set_gpio(fe, 6, 0, 0);
 			}
 		} while (tune_state < CT_AGC_STOP);
 
 		deb_info("switching to PWM AGC\n");
 		dib0090_pwm_gain_reset(fe);
-		dib8000_pwm_agc_reset(fe);
-		dib8000_set_tune_state(fe, CT_DEMOD_START);
+		state->dib8000_ops.pwm_agc_reset(fe);
+		state->dib8000_ops.set_tune_state(fe, CT_DEMOD_START);
 	} else {
 		/* for everything else than CBAND we are using standard AGC */
 		deb_info("not tuning in CBAND - standard AGC startup\n");
@@ -1680,7 +1709,7 @@ static int dib8096_set_param_override(struct dvb_frontend *fe)
 static int dib809x_tuner_attach(struct dvb_usb_adapter *adap)
 {
 	struct dib0700_adapter_state *st = adap->priv;
-	struct i2c_adapter *tun_i2c = dib8000_get_i2c_master(adap->fe_adap[0].fe, DIBX000_I2C_INTERFACE_TUNER, 1);
+	struct i2c_adapter *tun_i2c = st->dib8000_ops.get_i2c_master(adap->fe_adap[0].fe, DIBX000_I2C_INTERFACE_TUNER, 1);
 
 	if (dvb_attach(dib0090_register, adap->fe_adap[0].fe, tun_i2c, &dib809x_dib0090_config) == NULL)
 		return -ENODEV;
@@ -1692,6 +1721,11 @@ static int dib809x_tuner_attach(struct dvb_usb_adapter *adap)
 
 static int stk809x_frontend_attach(struct dvb_usb_adapter *adap)
 {
+	struct dib0700_adapter_state *state = adap->priv;
+
+	if (!dvb_attach(dib8000_attach, &state->dib8000_ops))
+		return -ENODEV;
+
 	dib0700_set_gpio(adap->dev, GPIO6, GPIO_OUT, 1);
 	msleep(10);
 	dib0700_set_gpio(adap->dev, GPIO9, GPIO_OUT, 1);
@@ -1707,9 +1741,9 @@ static int stk809x_frontend_attach(struct dvb_usb_adapter *adap)
 	msleep(10);
 	dib0700_set_gpio(adap->dev, GPIO0, GPIO_OUT, 1);
 
-	dib8000_i2c_enumeration(&adap->dev->i2c_adap, 1, 18, 0x80, 0);
+	state->dib8000_ops.i2c_enumeration(&adap->dev->i2c_adap, 1, 18, 0x80, 0);
 
-	adap->fe_adap[0].fe = dvb_attach(dib8000_init, &adap->dev->i2c_adap, 0x80, &dib809x_dib8000_config[0]);
+	adap->fe_adap[0].fe = state->dib8000_ops.init(&adap->dev->i2c_adap, 0x80, &dib809x_dib8000_config[0]);
 
 	return adap->fe_adap[0].fe == NULL ?  -ENODEV : 0;
 }
@@ -1718,16 +1752,16 @@ static int nim8096md_tuner_attach(struct dvb_usb_adapter *adap)
 {
 	struct dib0700_adapter_state *st = adap->priv;
 	struct i2c_adapter *tun_i2c;
-	struct dvb_frontend *fe_slave  = dib8000_get_slave_frontend(adap->fe_adap[0].fe, 1);
+	struct dvb_frontend *fe_slave  = st->dib8000_ops.get_slave_frontend(adap->fe_adap[0].fe, 1);
 
 	if (fe_slave) {
-		tun_i2c = dib8000_get_i2c_master(fe_slave, DIBX000_I2C_INTERFACE_TUNER, 1);
+		tun_i2c = st->dib8000_ops.get_i2c_master(fe_slave, DIBX000_I2C_INTERFACE_TUNER, 1);
 		if (dvb_attach(dib0090_register, fe_slave, tun_i2c, &dib809x_dib0090_config) == NULL)
 			return -ENODEV;
 		fe_slave->dvb = adap->fe_adap[0].fe->dvb;
 		fe_slave->ops.tuner_ops.set_params = dib8096_set_param_override;
 	}
-	tun_i2c = dib8000_get_i2c_master(adap->fe_adap[0].fe, DIBX000_I2C_INTERFACE_TUNER, 1);
+	tun_i2c = st->dib8000_ops.get_i2c_master(adap->fe_adap[0].fe, DIBX000_I2C_INTERFACE_TUNER, 1);
 	if (dvb_attach(dib0090_register, adap->fe_adap[0].fe, tun_i2c, &dib809x_dib0090_config) == NULL)
 		return -ENODEV;
 
@@ -1740,6 +1774,10 @@ static int nim8096md_tuner_attach(struct dvb_usb_adapter *adap)
 static int nim8096md_frontend_attach(struct dvb_usb_adapter *adap)
 {
 	struct dvb_frontend *fe_slave;
+	struct dib0700_adapter_state *state = adap->priv;
+
+	if (!dvb_attach(dib8000_attach, &state->dib8000_ops))
+		return -ENODEV;
 
 	dib0700_set_gpio(adap->dev, GPIO6, GPIO_OUT, 0);
 	msleep(20);
@@ -1758,14 +1796,18 @@ static int nim8096md_frontend_attach(struct dvb_usb_adapter *adap)
 	msleep(20);
 	dib0700_set_gpio(adap->dev, GPIO0, GPIO_OUT, 1);
 
-	dib8000_i2c_enumeration(&adap->dev->i2c_adap, 2, 18, 0x80, 0);
+	state->dib8000_ops.i2c_enumeration(&adap->dev->i2c_adap, 2, 18, 0x80, 0);
 
-	adap->fe_adap[0].fe = dvb_attach(dib8000_init, &adap->dev->i2c_adap, 0x80, &dib809x_dib8000_config[0]);
+	adap->fe_adap[0].fe = state->dib8000_ops.init(&adap->dev->i2c_adap, 0x80, &dib809x_dib8000_config[0]);
 	if (adap->fe_adap[0].fe == NULL)
 		return -ENODEV;
 
-	fe_slave = dvb_attach(dib8000_init, &adap->dev->i2c_adap, 0x82, &dib809x_dib8000_config[1]);
-	dib8000_set_slave_frontend(adap->fe_adap[0].fe, fe_slave);
+	/* Needed to increment refcount */
+	if (!dvb_attach(dib8000_attach, &state->dib8000_ops))
+		return -ENODEV;
+
+	fe_slave = state->dib8000_ops.init(&adap->dev->i2c_adap, 0x82, &dib809x_dib8000_config[1]);
+	state->dib8000_ops.set_slave_frontend(adap->fe_adap[0].fe, fe_slave);
 
 	return fe_slave == NULL ?  -ENODEV : 0;
 }
@@ -1900,7 +1942,7 @@ static struct dib0090_wbd_slope dib8096p_wbd_table[] = {
 	{ 0xFFFF, 0, 0, 0, 0, 0},
 };
 
-static const struct dib0090_config tfe8096p_dib0090_config = {
+static struct dib0090_config tfe8096p_dib0090_config = {
 	.io.clock_khz			= 12000,
 	.io.pll_bypass			= 0,
 	.io.pll_range			= 0,
@@ -1908,8 +1950,6 @@ static const struct dib0090_config tfe8096p_dib0090_config = {
 	.io.pll_loopdiv			= 6,
 	.io.adc_clock_ratio		= 0,
 	.io.pll_int_loop_filt	= 0,
-	.reset					= dib8096p_tuner_sleep,
-	.sleep					= dib8096p_tuner_sleep,
 
 	.freq_offset_khz_uhf	= -143,
 	.freq_offset_khz_vhf	= -143,
@@ -1926,8 +1966,6 @@ static const struct dib0090_config tfe8096p_dib0090_config = {
 
 	.fref_clock_ratio		= 1,
 
-	.wbd					= dib8096p_wbd_table,
-
 	.ls_cfg_pad_drv			= 0,
 	.data_tx_drv			= 0,
 	.low_if					= NULL,
@@ -2038,15 +2076,15 @@ static int dib8096p_agc_startup(struct dvb_frontend *fe)
 	/* dib0090_get_wbd_target is returning any possible
 	   temperature compensated wbd-target */
 	target = (dib0090_get_wbd_target(fe) * 8  + 1) / 2;
-	dib8000_set_wbd_ref(fe, target);
+	state->dib8000_ops.set_wbd_ref(fe, target);
 
 	if (dib8096p_get_best_sampling(fe, &adc) == 0) {
 		pll.pll_ratio  = adc.pll_loopdiv;
 		pll.pll_prediv = adc.pll_prediv;
 
 		dib0700_set_i2c_speed(adap->dev, 200);
-		dib8000_update_pll(fe, &pll, fe->dtv_property_cache.bandwidth_hz / 1000, 0);
-		dib8000_ctrl_timf(fe, DEMOD_TIMF_SET, adc.timf);
+		state->dib8000_ops.update_pll(fe, &pll, fe->dtv_property_cache.bandwidth_hz / 1000, 0);
+		state->dib8000_ops.ctrl_timf(fe, DEMOD_TIMF_SET, adc.timf);
 		dib0700_set_i2c_speed(adap->dev, 1000);
 	}
 	return 0;
@@ -2056,6 +2094,10 @@ static int tfe8096p_frontend_attach(struct dvb_usb_adapter *adap)
 {
 	struct dib0700_state *st = adap->dev->priv;
 	u32 fw_version;
+	struct dib0700_adapter_state *state = adap->priv;
+
+	if (!dvb_attach(dib8000_attach, &state->dib8000_ops))
+		return -ENODEV;
 
 	dib0700_get_version(adap->dev, NULL, NULL, &fw_version, NULL);
 	if (fw_version >= 0x10200)
@@ -2076,10 +2118,10 @@ static int tfe8096p_frontend_attach(struct dvb_usb_adapter *adap)
 	msleep(20);
 	dib0700_set_gpio(adap->dev, GPIO0, GPIO_OUT, 1);
 
-	dib8000_i2c_enumeration(&adap->dev->i2c_adap, 1, 0x10, 0x80, 1);
+	state->dib8000_ops.i2c_enumeration(&adap->dev->i2c_adap, 1, 0x10, 0x80, 1);
 
-	adap->fe_adap[0].fe = dvb_attach(dib8000_init,
-			&adap->dev->i2c_adap, 0x80, &tfe8096p_dib8000_config);
+	adap->fe_adap[0].fe = state->dib8000_ops.init(&adap->dev->i2c_adap,
+					     0x80, &tfe8096p_dib8000_config);
 
 	return adap->fe_adap[0].fe == NULL ?  -ENODEV : 0;
 }
@@ -2087,13 +2129,17 @@ static int tfe8096p_frontend_attach(struct dvb_usb_adapter *adap)
 static int tfe8096p_tuner_attach(struct dvb_usb_adapter *adap)
 {
 	struct dib0700_adapter_state *st = adap->priv;
-	struct i2c_adapter *tun_i2c = dib8096p_get_i2c_tuner(adap->fe_adap[0].fe);
+	struct i2c_adapter *tun_i2c = st->dib8000_ops.get_i2c_tuner(adap->fe_adap[0].fe);
+
+	tfe8096p_dib0090_config.reset = st->dib8000_ops.tuner_sleep;
+	tfe8096p_dib0090_config.sleep = st->dib8000_ops.tuner_sleep;
+	tfe8096p_dib0090_config.wbd = dib8096p_wbd_table;
 
 	if (dvb_attach(dib0090_register, adap->fe_adap[0].fe, tun_i2c,
 				&tfe8096p_dib0090_config) == NULL)
 		return -ENODEV;
 
-	dib8000_set_gpio(adap->fe_adap[0].fe, 8, 0, 1);
+	st->dib8000_ops.set_gpio(adap->fe_adap[0].fe, 8, 0, 1);
 
 	st->set_param_save = adap->fe_adap[0].fe->ops.tuner_ops.set_params;
 	adap->fe_adap[0].fe->ops.tuner_ops.set_params = dib8096p_agc_startup;
-- 
1.9.3

