Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45982 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755962AbaCONoJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Mar 2014 09:44:09 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [RFC PATCH 3/3] dib7000: export just one symbol
Date: Sat, 15 Mar 2014 10:43:14 -0300
Message-Id: <1394890994-29185-4-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1394890994-29185-1-git-send-email-m.chehab@samsung.com>
References: <1394890994-29185-1-git-send-email-m.chehab@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Exporting multiple symbols don't work as it causes compilation
breakages, due to the way dvb_attach() works.

This were reported several times, like:

   drivers/built-in.o: In function `cxusb_dualdig4_rev2_tuner_attach':
>> cxusb.c:(.text+0x27d4b5): undefined reference to `dib7000p_get_i2c_master'
   drivers/built-in.o: In function `dib7070_set_param_override':
   cxusb.c:(.text+0x27d5a5): undefined reference to `dib0070_wbd_offset'
>> cxusb.c:(.text+0x27d5be): undefined reference to `dib7000p_set_wbd_ref'
   drivers/built-in.o: In function `dib7070_tuner_reset':
>> cxusb.c:(.text+0x27d5f9): undefined reference to `dib7000p_set_gpio'
   drivers/built-in.o: In function `cxusb_dualdig4_rev2_frontend_attach':
>> cxusb.c:(.text+0x27df5c): undefined reference to `dib7000p_i2c_enumeration'

In this specific report:
	CONFIG_DVB_USB_CXUSB=y
	CONFIG_DVB_DIB7000P=m

But the same type of bug can happen if:
	CONFIG_DVB_DIB7000P=m
and one of the bridge drivers is compiled builtin (cxusb, cx23885-dvb
and/or dib0700).

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/dib7000p.c      |  42 ++--
 drivers/media/dvb-frontends/dib7000p.h      | 130 ++----------
 drivers/media/pci/cx23885/cx23885-dvb.c     |   7 +-
 drivers/media/usb/dvb-usb/cxusb.c           |  38 ++--
 drivers/media/usb/dvb-usb/dib0700_devices.c | 312 ++++++++++++++++++----------
 5 files changed, 280 insertions(+), 249 deletions(-)

diff --git a/drivers/media/dvb-frontends/dib7000p.c b/drivers/media/dvb-frontends/dib7000p.c
index 4b33bce3a4c6..a7b9a82d43fb 100644
--- a/drivers/media/dvb-frontends/dib7000p.c
+++ b/drivers/media/dvb-frontends/dib7000p.c
@@ -409,7 +409,6 @@ int dib7000p_set_wbd_ref(struct dvb_frontend *demod, u16 value)
 	state->wbd_ref = value;
 	return dib7000p_write_word(state, 105, (dib7000p_read_word(state, 105) & 0xf000) | value);
 }
-EXPORT_SYMBOL(dib7000p_set_wbd_ref);
 
 int dib7000p_get_agc_values(struct dvb_frontend *fe,
 		u16 *agc_global, u16 *agc1, u16 *agc2, u16 *wbd)
@@ -427,14 +426,12 @@ int dib7000p_get_agc_values(struct dvb_frontend *fe,
 
 	return 0;
 }
-EXPORT_SYMBOL(dib7000p_get_agc_values);
 
 int dib7000p_set_agc1_min(struct dvb_frontend *fe, u16 v)
 {
 	struct dib7000p_state *state = fe->demodulator_priv;
 	return dib7000p_write_word(state, 108,  v);
 }
-EXPORT_SYMBOL(dib7000p_set_agc1_min);
 
 static void dib7000p_reset_pll(struct dib7000p_state *state)
 {
@@ -513,7 +510,6 @@ int dib7000p_update_pll(struct dvb_frontend *fe, struct dibx000_bandwidth_config
 	}
 	return -EIO;
 }
-EXPORT_SYMBOL(dib7000p_update_pll);
 
 static int dib7000p_reset_gpio(struct dib7000p_state *st)
 {
@@ -551,7 +547,6 @@ int dib7000p_set_gpio(struct dvb_frontend *demod, u8 num, u8 dir, u8 val)
 	struct dib7000p_state *state = demod->demodulator_priv;
 	return dib7000p_cfg_gpio(state, num, dir, val);
 }
-EXPORT_SYMBOL(dib7000p_set_gpio);
 
 static u16 dib7000p_defaults[] = {
 	// auto search configuration
@@ -950,7 +945,6 @@ u32 dib7000p_ctrl_timf(struct dvb_frontend *fe, u8 op, u32 timf)
 	dib7000p_set_bandwidth(state, state->current_bandwidth);
 	return state->timf;
 }
-EXPORT_SYMBOL(dib7000p_ctrl_timf);
 
 static void dib7000p_set_channel(struct dib7000p_state *state,
 				 struct dtv_frontend_properties *ch, u8 seq)
@@ -1688,14 +1682,12 @@ rx_memory_error:
 	kfree(tx);
 	return ret;
 }
-EXPORT_SYMBOL(dib7000pc_detection);
 
 struct i2c_adapter *dib7000p_get_i2c_master(struct dvb_frontend *demod, enum dibx000_i2c_interface intf, int gating)
 {
 	struct dib7000p_state *st = demod->demodulator_priv;
 	return dibx000_get_i2c_adapter(&st->i2c_master, intf, gating);
 }
-EXPORT_SYMBOL(dib7000p_get_i2c_master);
 
 int dib7000p_pid_filter_ctrl(struct dvb_frontend *fe, u8 onoff)
 {
@@ -1705,7 +1697,6 @@ int dib7000p_pid_filter_ctrl(struct dvb_frontend *fe, u8 onoff)
 	dprintk("PID filter enabled %d", onoff);
 	return dib7000p_write_word(state, 235, val);
 }
-EXPORT_SYMBOL(dib7000p_pid_filter_ctrl);
 
 int dib7000p_pid_filter(struct dvb_frontend *fe, u8 id, u16 pid, u8 onoff)
 {
@@ -1713,7 +1704,6 @@ int dib7000p_pid_filter(struct dvb_frontend *fe, u8 id, u16 pid, u8 onoff)
 	dprintk("PID filter: index %x, PID %d, OnOff %d", id, pid, onoff);
 	return dib7000p_write_word(state, 241 + id, onoff ? (1 << 13) | pid : 0);
 }
-EXPORT_SYMBOL(dib7000p_pid_filter);
 
 int dib7000p_i2c_enumeration(struct i2c_adapter *i2c, int no_of_demods, u8 default_addr, struct dib7000p_config cfg[])
 {
@@ -1774,7 +1764,6 @@ int dib7000p_i2c_enumeration(struct i2c_adapter *i2c, int no_of_demods, u8 defau
 	kfree(dpst);
 	return 0;
 }
-EXPORT_SYMBOL(dib7000p_i2c_enumeration);
 
 static const s32 lut_1000ln_mant[] = {
 	6908, 6956, 7003, 7047, 7090, 7131, 7170, 7208, 7244, 7279, 7313, 7346, 7377, 7408, 7438, 7467, 7495, 7523, 7549, 7575, 7600
@@ -2037,7 +2026,6 @@ struct i2c_adapter *dib7090_get_i2c_tuner(struct dvb_frontend *fe)
 	struct dib7000p_state *st = fe->demodulator_priv;
 	return &st->dib7090_tuner_adap;
 }
-EXPORT_SYMBOL(dib7090_get_i2c_tuner);
 
 static int dib7090_host_bus_drive(struct dib7000p_state *state, u8 drive)
 {
@@ -2352,13 +2340,11 @@ int dib7090_tuner_sleep(struct dvb_frontend *fe, int onoff)
 
 	return 0;
 }
-EXPORT_SYMBOL(dib7090_tuner_sleep);
 
 int dib7090_get_adc_power(struct dvb_frontend *fe)
 {
 	return dib7000p_get_adc_power(fe);
 }
-EXPORT_SYMBOL(dib7090_get_adc_power);
 
 int dib7090_slave_reset(struct dvb_frontend *fe)
 {
@@ -2371,7 +2357,6 @@ int dib7090_slave_reset(struct dvb_frontend *fe)
 	dib7000p_write_word(state, 1032, 0xffff);
 	return 0;
 }
-EXPORT_SYMBOL(dib7090_slave_reset);
 
 static struct dvb_frontend_ops dib7000p_ops;
 struct dvb_frontend *dib7000p_init(struct i2c_adapter *i2c_adap, u8 i2c_addr, struct dib7000p_config *cfg)
@@ -2434,7 +2419,32 @@ error:
 	kfree(st);
 	return NULL;
 }
-EXPORT_SYMBOL(dib7000p_init);
+
+int dib7000p_attach(struct dib7000p_ops *ops)
+{
+	if (!ops)
+		return -EINVAL;
+
+	ops->init = dib7000p_init;
+	ops->get_i2c_master = dib7000p_get_i2c_master;
+	ops->set_gpio = dib7000p_set_gpio;
+	ops->set_wbd_ref = dib7000p_set_wbd_ref;
+	ops->dib7000pc_detection = dib7000pc_detection;
+	ops->pid_filter = dib7000p_pid_filter;
+	ops->i2c_enumeration =  dib7000p_i2c_enumeration;
+	ops->pid_filter_ctrl = dib7000p_pid_filter_ctrl;
+	ops->update_pll = dib7000p_update_pll;
+	ops->ctrl_timf = dib7000p_ctrl_timf;
+	ops->tuner_sleep = dib7090_tuner_sleep;
+	ops->get_adc_power = dib7090_get_adc_power;
+	ops->get_i2c_tuner = dib7090_get_i2c_tuner;
+	ops->slave_reset = dib7090_slave_reset;
+	ops->get_agc_values = dib7000p_get_agc_values;
+	ops->set_agc1_min = dib7000p_set_agc1_min;
+
+	return 0;
+}
+EXPORT_SYMBOL(dib7000p_attach);
 
 static struct dvb_frontend_ops dib7000p_ops = {
 	.delsys = { SYS_DVBT },
diff --git a/drivers/media/dvb-frontends/dib7000p.h b/drivers/media/dvb-frontends/dib7000p.h
index 583c94e8eca5..54a51e95c38f 100644
--- a/drivers/media/dvb-frontends/dib7000p.h
+++ b/drivers/media/dvb-frontends/dib7000p.h
@@ -44,123 +44,35 @@ struct dib7000p_config {
 	u8 enMpegOutput:1;
 };
 
+struct dib7000p_ops {
+	struct dvb_frontend *(*init)(struct i2c_adapter *i2c_adap, u8 i2c_addr, struct dib7000p_config *cfg);
+	struct i2c_adapter *(*get_i2c_master)(struct dvb_frontend *, enum dibx000_i2c_interface, int);
+	int (*set_gpio)(struct dvb_frontend *, u8 num, u8 dir, u8 val);
+	int (*set_wbd_ref)(struct dvb_frontend *, u16 value);
+	int (*dib7000pc_detection)(struct i2c_adapter *i2c_adap);
+	int (*pid_filter)(struct dvb_frontend *, u8 id, u16 pid, u8 onoff);
+	int (*i2c_enumeration)(struct i2c_adapter *i2c, int no_of_demods, u8 default_addr, struct dib7000p_config cfg[]);
+	int (*pid_filter_ctrl)(struct dvb_frontend *fe, u8 onoff);
+	int (*update_pll)(struct dvb_frontend *fe, struct dibx000_bandwidth_config *bw);
+	u32 (*ctrl_timf)(struct dvb_frontend *fe, u8 op, u32 timf);
+	int (*tuner_sleep)(struct dvb_frontend *fe, int onoff);
+	int (*get_adc_power)(struct dvb_frontend *fe);
+	struct i2c_adapter *(*get_i2c_tuner)(struct dvb_frontend *fe);
+	int (*slave_reset)(struct dvb_frontend *fe);
+	int (*get_agc_values)(struct dvb_frontend *fe,u16 *agc_global, u16 *agc1, u16 *agc2, u16 *wbd);
+	int (*set_agc1_min)(struct dvb_frontend *fe, u16 v);
+};
+
 #define DEFAULT_DIB7000P_I2C_ADDRESS 18
 
 #if IS_ENABLED(CONFIG_DVB_DIB7000P)
-extern struct dvb_frontend *dib7000p_init(struct i2c_adapter *i2c_adap, u8 i2c_addr, struct dib7000p_config *cfg);
-extern struct i2c_adapter *dib7000p_get_i2c_master(struct dvb_frontend *, enum dibx000_i2c_interface, int);
-extern int dib7000p_i2c_enumeration(struct i2c_adapter *i2c, int no_of_demods, u8 default_addr, struct dib7000p_config cfg[]);
-extern int dib7000p_set_gpio(struct dvb_frontend *, u8 num, u8 dir, u8 val);
-extern int dib7000p_set_wbd_ref(struct dvb_frontend *, u16 value);
-extern int dib7000pc_detection(struct i2c_adapter *i2c_adap);
-extern int dib7000p_pid_filter(struct dvb_frontend *, u8 id, u16 pid, u8 onoff);
-extern int dib7000p_pid_filter_ctrl(struct dvb_frontend *fe, u8 onoff);
-extern int dib7000p_update_pll(struct dvb_frontend *fe, struct dibx000_bandwidth_config *bw);
-extern u32 dib7000p_ctrl_timf(struct dvb_frontend *fe, u8 op, u32 timf);
-extern int dib7090_tuner_sleep(struct dvb_frontend *fe, int onoff);
-extern int dib7090_get_adc_power(struct dvb_frontend *fe);
-extern struct i2c_adapter *dib7090_get_i2c_tuner(struct dvb_frontend *fe);
-extern int dib7090_slave_reset(struct dvb_frontend *fe);
-extern int dib7000p_get_agc_values(struct dvb_frontend *fe,
-		u16 *agc_global, u16 *agc1, u16 *agc2, u16 *wbd);
-extern int dib7000p_set_agc1_min(struct dvb_frontend *fe, u16 v);
+extern int dib7000p_attach(struct dib7000p_ops *ops);
 #else
-static inline struct dvb_frontend *dib7000p_init(struct i2c_adapter *i2c_adap, u8 i2c_addr, struct dib7000p_config *cfg)
-{
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
-	return NULL;
-}
-
-static inline struct i2c_adapter *dib7000p_get_i2c_master(struct dvb_frontend *fe, enum dibx000_i2c_interface i, int x)
-{
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
-	return NULL;
-}
-
-static inline int dib7000p_i2c_enumeration(struct i2c_adapter *i2c, int no_of_demods, u8 default_addr, struct dib7000p_config cfg[])
-{
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
-	return -ENODEV;
-}
-
-static inline int dib7000p_set_gpio(struct dvb_frontend *fe, u8 num, u8 dir, u8 val)
-{
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
-	return -ENODEV;
-}
-
-static inline int dib7000p_set_wbd_ref(struct dvb_frontend *fe, u16 value)
-{
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
-	return -ENODEV;
-}
-
-static inline int dib7000pc_detection(struct i2c_adapter *i2c_adap)
-{
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
-	return -ENODEV;
-}
-
-static inline int dib7000p_pid_filter(struct dvb_frontend *fe, u8 id, u16 pid, u8 onoff)
-{
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
-	return -ENODEV;
-}
-
-static inline int dib7000p_pid_filter_ctrl(struct dvb_frontend *fe, uint8_t onoff)
-{
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
-	return -ENODEV;
-}
-
-static inline int dib7000p_update_pll(struct dvb_frontend *fe, struct dibx000_bandwidth_config *bw)
-{
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
-	return -ENODEV;
-}
-
-static inline u32 dib7000p_ctrl_timf(struct dvb_frontend *fe, u8 op, u32 timf)
-{
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
-	return 0;
-}
-
-static inline int dib7090_tuner_sleep(struct dvb_frontend *fe, int onoff)
-{
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
-	return -ENODEV;
-}
-
-static inline int dib7090_get_adc_power(struct dvb_frontend *fe)
-{
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
-	return -ENODEV;
-}
-
-static inline struct i2c_adapter *dib7090_get_i2c_tuner(struct dvb_frontend *fe)
+static inline int *dib7000p_attach(struct dib7000p_ops *ops);
 {
 	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
-
-static inline int dib7090_slave_reset(struct dvb_frontend *fe)
-{
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
-	return -ENODEV;
-}
-
-static inline int dib7000p_get_agc_values(struct dvb_frontend *fe,
-		u16 *agc_global, u16 *agc1, u16 *agc2, u16 *wbd)
-{
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
-	return -ENODEV;
-}
-
-static inline int dib7000p_set_agc1_min(struct dvb_frontend *fe, u16 v)
-{
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
-	return -ENODEV;
-}
 #endif
 
 #endif
diff --git a/drivers/media/pci/cx23885/cx23885-dvb.c b/drivers/media/pci/cx23885/cx23885-dvb.c
index 69e526391c12..29bf69cf1ab1 100644
--- a/drivers/media/pci/cx23885/cx23885-dvb.c
+++ b/drivers/media/pci/cx23885/cx23885-dvb.c
@@ -748,6 +748,7 @@ static int netup_altera_fpga_rw(void *device, int flag, int data, int read)
 
 static int dvb_register(struct cx23885_tsport *port)
 {
+	struct dib7000p_ops dib7000p_ops;
 	struct cx23885_dev *dev = port->dev;
 	struct cx23885_i2c *i2c_bus = NULL, *i2c_bus2 = NULL;
 	struct videobuf_dvb_frontend *fe0, *fe1 = NULL;
@@ -925,8 +926,10 @@ static int dvb_register(struct cx23885_tsport *port)
 		break;
 	case CX23885_BOARD_HAUPPAUGE_HVR1400:
 		i2c_bus = &dev->i2c_bus[0];
-		fe0->dvb.frontend = dvb_attach(dib7000p_init,
-			&i2c_bus->i2c_adap,
+
+		dvb_attach(dib7000p_attach, &dib7000p_ops);
+
+		fe0->dvb.frontend = dib7000p_ops.init(&i2c_bus->i2c_adap,
 			0x12, &hauppauge_hvr1400_dib7000_config);
 		if (fe0->dvb.frontend != NULL) {
 			struct dvb_frontend *fe;
diff --git a/drivers/media/usb/dvb-usb/cxusb.c b/drivers/media/usb/dvb-usb/cxusb.c
index e81a2fd54960..0a2bc9f31e8f 100644
--- a/drivers/media/usb/dvb-usb/cxusb.c
+++ b/drivers/media/usb/dvb-usb/cxusb.c
@@ -1070,8 +1070,15 @@ static struct dib7000p_config cxusb_dualdig4_rev2_config = {
 	.hostbus_diversity = 1,
 };
 
+struct dib0700_adapter_state {
+	int (*set_param_save) (struct dvb_frontend *);
+	struct dib7000p_ops ops;
+};
+
 static int cxusb_dualdig4_rev2_frontend_attach(struct dvb_usb_adapter *adap)
 {
+	struct dib0700_adapter_state *state = adap->priv;
+
 	if (usb_set_interface(adap->dev->udev, 0, 1) < 0)
 		err("set interface failed");
 
@@ -1079,14 +1086,16 @@ static int cxusb_dualdig4_rev2_frontend_attach(struct dvb_usb_adapter *adap)
 
 	cxusb_bluebird_gpio_pulse(adap->dev, 0x02, 1);
 
-	if (dib7000p_i2c_enumeration(&adap->dev->i2c_adap, 1, 18,
-				     &cxusb_dualdig4_rev2_config) < 0) {
+	dvb_attach(dib7000p_attach, &state->ops);
+
+	if (state->ops.i2c_enumeration(&adap->dev->i2c_adap, 1, 18,
+				       &cxusb_dualdig4_rev2_config) < 0) {
 		printk(KERN_WARNING "Unable to enumerate dib7000p\n");
 		return -ENODEV;
 	}
 
-	adap->fe_adap[0].fe = dvb_attach(dib7000p_init, &adap->dev->i2c_adap, 0x80,
-			      &cxusb_dualdig4_rev2_config);
+	adap->fe_adap[0].fe = state->ops.init(&adap->dev->i2c_adap, 0x80,
+					      &cxusb_dualdig4_rev2_config);
 	if (adap->fe_adap[0].fe == NULL)
 		return -EIO;
 
@@ -1095,7 +1104,10 @@ static int cxusb_dualdig4_rev2_frontend_attach(struct dvb_usb_adapter *adap)
 
 static int dib7070_tuner_reset(struct dvb_frontend *fe, int onoff)
 {
-	return dib7000p_set_gpio(fe, 8, 0, !onoff);
+	struct dvb_usb_adapter *adap = fe->dvb->priv;
+	struct dib0700_adapter_state *state = adap->priv;
+
+	return state->ops.set_gpio(fe, 8, 0, !onoff);
 }
 
 static int dib7070_tuner_sleep(struct dvb_frontend *fe, int onoff)
@@ -1110,10 +1122,6 @@ static struct dib0070_config dib7070p_dib0070_config = {
 	.clock_khz = 12000,
 };
 
-struct dib0700_adapter_state {
-	int (*set_param_save) (struct dvb_frontend *);
-};
-
 static int dib7070_set_param_override(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
@@ -1128,7 +1136,7 @@ static int dib7070_set_param_override(struct dvb_frontend *fe)
 	case BAND_UHF: offset = 550; break;
 	}
 
-	dib7000p_set_wbd_ref(fe, offset + dib0070_wbd_offset(fe));
+	state->ops.set_wbd_ref(fe, offset + dib0070_wbd_offset(fe));
 
 	return state->set_param_save(fe);
 }
@@ -1136,8 +1144,14 @@ static int dib7070_set_param_override(struct dvb_frontend *fe)
 static int cxusb_dualdig4_rev2_tuner_attach(struct dvb_usb_adapter *adap)
 {
 	struct dib0700_adapter_state *st = adap->priv;
-	struct i2c_adapter *tun_i2c =
-		dib7000p_get_i2c_master(adap->fe_adap[0].fe,
+	struct i2c_adapter *tun_i2c;
+
+	/*
+	 * No need to call dvb7000p_attach here, as it was called
+	 * already, as frontend_attach method is called first, and
+	 * tuner_attach is only called on sucess.
+	 */
+	tun_i2c = st->ops.get_i2c_master(adap->fe_adap[0].fe,
 					DIBX000_I2C_INTERFACE_TUNER, 1);
 
 	if (dvb_attach(dib0070_attach, adap->fe_adap[0].fe, tun_i2c,
diff --git a/drivers/media/usb/dvb-usb/dib0700_devices.c b/drivers/media/usb/dvb-usb/dib0700_devices.c
index 0b0c2215d429..8d379b9e87bb 100644
--- a/drivers/media/usb/dvb-usb/dib0700_devices.c
+++ b/drivers/media/usb/dvb-usb/dib0700_devices.c
@@ -32,6 +32,7 @@ MODULE_PARM_DESC(force_lna_activation, "force the activation of Low-Noise-Amplif
 struct dib0700_adapter_state {
 	int (*set_param_save) (struct dvb_frontend *);
 	const struct firmware *frontend_firmware;
+	struct dib7000p_ops dib7000p_ops;
 };
 
 /* Hauppauge Nova-T 500 (aka Bristol)
@@ -262,6 +263,10 @@ static struct mt2266_config stk7700d_mt2266_config[2] = {
 
 static int stk7700P2_frontend_attach(struct dvb_usb_adapter *adap)
 {
+	struct dib0700_adapter_state *state = adap->priv;
+
+	dvb_attach(dib7000p_attach, &state->dib7000p_ops);
+
 	if (adap->id == 0) {
 		dib0700_set_gpio(adap->dev, GPIO6, GPIO_OUT, 1);
 		msleep(10);
@@ -272,16 +277,16 @@ static int stk7700P2_frontend_attach(struct dvb_usb_adapter *adap)
 		msleep(10);
 		dib0700_set_gpio(adap->dev, GPIO10, GPIO_OUT, 1);
 		msleep(10);
-		if (dib7000p_i2c_enumeration(&adap->dev->i2c_adap, 1, 18,
+		if (state->dib7000p_ops.i2c_enumeration(&adap->dev->i2c_adap, 1, 18,
 					     stk7700d_dib7000p_mt2266_config)
 		    != 0) {
-			err("%s: dib7000p_i2c_enumeration failed.  Cannot continue\n", __func__);
+			err("%s: state->dib7000p_ops.i2c_enumeration failed.  Cannot continue\n", __func__);
+			dvb_dettach(dib7000p_attach);
 			return -ENODEV;
 		}
 	}
 
-	adap->fe_adap[0].fe =
-		dvb_attach(dib7000p_init, &adap->dev->i2c_adap,
+	adap->fe_adap[0].fe = state->dib7000p_ops.init(&adap->dev->i2c_adap,
 			   0x80 + (adap->id << 1),
 			   &stk7700d_dib7000p_mt2266_config[adap->id]);
 
@@ -290,6 +295,10 @@ static int stk7700P2_frontend_attach(struct dvb_usb_adapter *adap)
 
 static int stk7700d_frontend_attach(struct dvb_usb_adapter *adap)
 {
+	struct dib0700_adapter_state *state = adap->priv;
+
+	dvb_attach(dib7000p_attach, &state->dib7000p_ops);
+
 	if (adap->id == 0) {
 		dib0700_set_gpio(adap->dev, GPIO6, GPIO_OUT, 1);
 		msleep(10);
@@ -301,16 +310,16 @@ static int stk7700d_frontend_attach(struct dvb_usb_adapter *adap)
 		dib0700_set_gpio(adap->dev, GPIO10, GPIO_OUT, 1);
 		msleep(10);
 		dib0700_set_gpio(adap->dev, GPIO0, GPIO_OUT, 1);
-		if (dib7000p_i2c_enumeration(&adap->dev->i2c_adap, 2, 18,
+		if (state->dib7000p_ops.i2c_enumeration(&adap->dev->i2c_adap, 2, 18,
 					     stk7700d_dib7000p_mt2266_config)
 		    != 0) {
-			err("%s: dib7000p_i2c_enumeration failed.  Cannot continue\n", __func__);
+			err("%s: state->dib7000p_ops.i2c_enumeration failed.  Cannot continue\n", __func__);
+			dvb_dettach(dib7000p_attach);
 			return -ENODEV;
 		}
 	}
 
-	adap->fe_adap[0].fe =
-		dvb_attach(dib7000p_init, &adap->dev->i2c_adap,
+	adap->fe_adap[0].fe =state->dib7000p_ops.init(&adap->dev->i2c_adap,
 			   0x80 + (adap->id << 1),
 			   &stk7700d_dib7000p_mt2266_config[adap->id]);
 
@@ -320,7 +329,10 @@ static int stk7700d_frontend_attach(struct dvb_usb_adapter *adap)
 static int stk7700d_tuner_attach(struct dvb_usb_adapter *adap)
 {
 	struct i2c_adapter *tun_i2c;
-	tun_i2c = dib7000p_get_i2c_master(adap->fe_adap[0].fe, DIBX000_I2C_INTERFACE_TUNER, 1);
+	struct dib0700_adapter_state *state = adap->priv;
+
+	tun_i2c = state->dib7000p_ops.get_i2c_master(adap->fe_adap[0].fe,
+					    DIBX000_I2C_INTERFACE_TUNER, 1);
 	return dvb_attach(mt2266_attach, adap->fe_adap[0].fe, tun_i2c,
 		&stk7700d_mt2266_config[adap->id]) == NULL ? -ENODEV : 0;
 }
@@ -397,12 +409,14 @@ static int stk7700ph_xc3028_callback(void *ptr, int component,
 				     int command, int arg)
 {
 	struct dvb_usb_adapter *adap = ptr;
+	struct dib0700_adapter_state *state = adap->priv;
 
 	switch (command) {
 	case XC2028_TUNER_RESET:
 		/* Send the tuner in then out of reset */
-		dib7000p_set_gpio(adap->fe_adap[0].fe, 8, 0, 0); msleep(10);
-		dib7000p_set_gpio(adap->fe_adap[0].fe, 8, 0, 1);
+		state->dib7000p_ops.set_gpio(adap->fe_adap[0].fe, 8, 0, 0);
+		msleep(10);
+		state->dib7000p_ops.set_gpio(adap->fe_adap[0].fe, 8, 0, 1);
 		break;
 	case XC2028_RESET_CLK:
 		break;
@@ -428,12 +442,15 @@ static struct xc2028_config stk7700ph_xc3028_config = {
 static int stk7700ph_frontend_attach(struct dvb_usb_adapter *adap)
 {
 	struct usb_device_descriptor *desc = &adap->dev->udev->descriptor;
+	struct dib0700_adapter_state *state = adap->priv;
+
+	dvb_attach(dib7000p_attach, &state->dib7000p_ops);
 
 	if (desc->idVendor  == cpu_to_le16(USB_VID_PINNACLE) &&
 	    desc->idProduct == cpu_to_le16(USB_PID_PINNACLE_EXPRESSCARD_320CX))
-	dib0700_set_gpio(adap->dev, GPIO6, GPIO_OUT, 0);
+		dib0700_set_gpio(adap->dev, GPIO6, GPIO_OUT, 0);
 	else
-	dib0700_set_gpio(adap->dev, GPIO6, GPIO_OUT, 1);
+		dib0700_set_gpio(adap->dev, GPIO6, GPIO_OUT, 1);
 	msleep(20);
 	dib0700_set_gpio(adap->dev, GPIO9, GPIO_OUT, 1);
 	dib0700_set_gpio(adap->dev, GPIO4, GPIO_OUT, 1);
@@ -445,14 +462,15 @@ static int stk7700ph_frontend_attach(struct dvb_usb_adapter *adap)
 	dib0700_set_gpio(adap->dev, GPIO0, GPIO_OUT, 1);
 	msleep(10);
 
-	if (dib7000p_i2c_enumeration(&adap->dev->i2c_adap, 1, 18,
+	if (state->dib7000p_ops.i2c_enumeration(&adap->dev->i2c_adap, 1, 18,
 				     &stk7700ph_dib7700_xc3028_config) != 0) {
-		err("%s: dib7000p_i2c_enumeration failed.  Cannot continue\n",
+		err("%s: state->dib7000p_ops.i2c_enumeration failed.  Cannot continue\n",
 		    __func__);
+		dvb_dettach(dib7000p_attach);
 		return -ENODEV;
 	}
 
-	adap->fe_adap[0].fe = dvb_attach(dib7000p_init, &adap->dev->i2c_adap, 0x80,
+	adap->fe_adap[0].fe = state->dib7000p_ops.init(&adap->dev->i2c_adap, 0x80,
 		&stk7700ph_dib7700_xc3028_config);
 
 	return adap->fe_adap[0].fe == NULL ? -ENODEV : 0;
@@ -461,8 +479,9 @@ static int stk7700ph_frontend_attach(struct dvb_usb_adapter *adap)
 static int stk7700ph_tuner_attach(struct dvb_usb_adapter *adap)
 {
 	struct i2c_adapter *tun_i2c;
+	struct dib0700_adapter_state *state = adap->priv;
 
-	tun_i2c = dib7000p_get_i2c_master(adap->fe_adap[0].fe,
+	tun_i2c = state->dib7000p_ops.get_i2c_master(adap->fe_adap[0].fe,
 		DIBX000_I2C_INTERFACE_TUNER, 1);
 
 	stk7700ph_xc3028_config.i2c_adap = tun_i2c;
@@ -673,6 +692,10 @@ static struct dib7000p_config stk7700p_dib7000p_config = {
 static int stk7700p_frontend_attach(struct dvb_usb_adapter *adap)
 {
 	struct dib0700_state *st = adap->dev->priv;
+	struct dib0700_adapter_state *state = adap->priv;
+
+	dvb_attach(dib7000p_attach, &state->dib7000p_ops);
+
 	/* unless there is no real power management in DVB - we leave the device on GPIO6 */
 
 	dib0700_set_gpio(adap->dev, GPIO10, GPIO_OUT, 0);
@@ -689,11 +712,14 @@ static int stk7700p_frontend_attach(struct dvb_usb_adapter *adap)
 
 	st->mt2060_if1[0] = 1220;
 
-	if (dib7000pc_detection(&adap->dev->i2c_adap)) {
-		adap->fe_adap[0].fe = dvb_attach(dib7000p_init, &adap->dev->i2c_adap, 18, &stk7700p_dib7000p_config);
+	if (state->dib7000p_ops.dib7000pc_detection(&adap->dev->i2c_adap)) {
+		adap->fe_adap[0].fe = state->dib7000p_ops.init(&adap->dev->i2c_adap, 18, &stk7700p_dib7000p_config);
 		st->is_dib7000pc = 1;
-	} else
+	} else {
+		dvb_dettach(dib7000p_attach);
+		memset(&state->dib7000p_ops, 0, sizeof(state->dib7000p_ops));
 		adap->fe_adap[0].fe = dvb_attach(dib7000m_attach, &adap->dev->i2c_adap, 18, &stk7700p_dib7000m_config);
+	}
 
 	return adap->fe_adap[0].fe == NULL ? -ENODEV : 0;
 }
@@ -707,14 +733,16 @@ static int stk7700p_tuner_attach(struct dvb_usb_adapter *adap)
 	struct i2c_adapter *prim_i2c = &adap->dev->i2c_adap;
 	struct dib0700_state *st = adap->dev->priv;
 	struct i2c_adapter *tun_i2c;
+	struct dib0700_adapter_state *state = adap->priv;
 	s8 a;
 	int if1=1220;
+
 	if (adap->dev->udev->descriptor.idVendor  == cpu_to_le16(USB_VID_HAUPPAUGE) &&
 		adap->dev->udev->descriptor.idProduct == cpu_to_le16(USB_PID_HAUPPAUGE_NOVA_T_STICK)) {
 		if (!eeprom_read(prim_i2c,0x58,&a)) if1=1220+a;
 	}
 	if (st->is_dib7000pc)
-		tun_i2c = dib7000p_get_i2c_master(adap->fe_adap[0].fe, DIBX000_I2C_INTERFACE_TUNER, 1);
+		tun_i2c = state->dib7000p_ops.get_i2c_master(adap->fe_adap[0].fe, DIBX000_I2C_INTERFACE_TUNER, 1);
 	else
 		tun_i2c = dib7000m_get_i2c_master(adap->fe_adap[0].fe, DIBX000_I2C_INTERFACE_TUNER, 1);
 
@@ -767,14 +795,20 @@ static struct dibx000_agc_config dib7070_agc_config = {
 
 static int dib7070_tuner_reset(struct dvb_frontend *fe, int onoff)
 {
+	struct dvb_usb_adapter *adap = fe->dvb->priv;
+	struct dib0700_adapter_state *state = adap->priv;
+
 	deb_info("reset: %d", onoff);
-	return dib7000p_set_gpio(fe, 8, 0, !onoff);
+	return state->dib7000p_ops.set_gpio(fe, 8, 0, !onoff);
 }
 
 static int dib7070_tuner_sleep(struct dvb_frontend *fe, int onoff)
 {
+	struct dvb_usb_adapter *adap = fe->dvb->priv;
+	struct dib0700_adapter_state *state = adap->priv;
+
 	deb_info("sleep: %d", onoff);
-	return dib7000p_set_gpio(fe, 9, 0, onoff);
+	return state->dib7000p_ops.set_gpio(fe, 9, 0, onoff);
 }
 
 static struct dib0070_config dib7070p_dib0070_config[2] = {
@@ -818,7 +852,7 @@ static int dib7070_set_param_override(struct dvb_frontend *fe)
 		default: offset = 550; break;
 	}
 	deb_info("WBD for DiB7000P: %d\n", offset + dib0070_wbd_offset(fe));
-	dib7000p_set_wbd_ref(fe, offset + dib0070_wbd_offset(fe));
+	state->dib7000p_ops.set_wbd_ref(fe, offset + dib0070_wbd_offset(fe));
 	return state->set_param_save(fe);
 }
 
@@ -832,39 +866,39 @@ static int dib7770_set_param_override(struct dvb_frontend *fe)
 	 u8 band = BAND_OF_FREQUENCY(p->frequency/1000);
 	 switch (band) {
 	 case BAND_VHF:
-		  dib7000p_set_gpio(fe, 0, 0, 1);
+		  state->dib7000p_ops.set_gpio(fe, 0, 0, 1);
 		  offset = 850;
 		  break;
 	 case BAND_UHF:
 	 default:
-		  dib7000p_set_gpio(fe, 0, 0, 0);
+		  state->dib7000p_ops.set_gpio(fe, 0, 0, 0);
 		  offset = 250;
 		  break;
 	 }
 	 deb_info("WBD for DiB7000P: %d\n", offset + dib0070_wbd_offset(fe));
-	 dib7000p_set_wbd_ref(fe, offset + dib0070_wbd_offset(fe));
+	 state->dib7000p_ops.set_wbd_ref(fe, offset + dib0070_wbd_offset(fe));
 	 return state->set_param_save(fe);
 }
 
 static int dib7770p_tuner_attach(struct dvb_usb_adapter *adap)
 {
-	 struct dib0700_adapter_state *st = adap->priv;
-	 struct i2c_adapter *tun_i2c = dib7000p_get_i2c_master(adap->fe_adap[0].fe,
+	struct dib0700_adapter_state *st = adap->priv;
+	struct i2c_adapter *tun_i2c = st->dib7000p_ops.get_i2c_master(adap->fe_adap[0].fe,
 			 DIBX000_I2C_INTERFACE_TUNER, 1);
 
-	 if (dvb_attach(dib0070_attach, adap->fe_adap[0].fe, tun_i2c,
-			&dib7770p_dib0070_config) == NULL)
-		 return -ENODEV;
+	if (dvb_attach(dib0070_attach, adap->fe_adap[0].fe, tun_i2c,
+		       &dib7770p_dib0070_config) == NULL)
+		return -ENODEV;
 
-	 st->set_param_save = adap->fe_adap[0].fe->ops.tuner_ops.set_params;
-	 adap->fe_adap[0].fe->ops.tuner_ops.set_params = dib7770_set_param_override;
-	 return 0;
+	st->set_param_save = adap->fe_adap[0].fe->ops.tuner_ops.set_params;
+	adap->fe_adap[0].fe->ops.tuner_ops.set_params = dib7770_set_param_override;
+	return 0;
 }
 
 static int dib7070p_tuner_attach(struct dvb_usb_adapter *adap)
 {
 	struct dib0700_adapter_state *st = adap->priv;
-	struct i2c_adapter *tun_i2c = dib7000p_get_i2c_master(adap->fe_adap[0].fe, DIBX000_I2C_INTERFACE_TUNER, 1);
+	struct i2c_adapter *tun_i2c = st->dib7000p_ops.get_i2c_master(adap->fe_adap[0].fe, DIBX000_I2C_INTERFACE_TUNER, 1);
 
 	if (adap->id == 0) {
 		if (dvb_attach(dib0070_attach, adap->fe_adap[0].fe, tun_i2c, &dib7070p_dib0070_config[0]) == NULL)
@@ -882,28 +916,33 @@ static int dib7070p_tuner_attach(struct dvb_usb_adapter *adap)
 static int stk7700p_pid_filter(struct dvb_usb_adapter *adapter, int index,
 		u16 pid, int onoff)
 {
+	struct dib0700_adapter_state *state = adapter->priv;
 	struct dib0700_state *st = adapter->dev->priv;
+
 	if (st->is_dib7000pc)
-		return dib7000p_pid_filter(adapter->fe_adap[0].fe, index, pid, onoff);
+		return state->dib7000p_ops.pid_filter(adapter->fe_adap[0].fe, index, pid, onoff);
 	return dib7000m_pid_filter(adapter->fe_adap[0].fe, index, pid, onoff);
 }
 
 static int stk7700p_pid_filter_ctrl(struct dvb_usb_adapter *adapter, int onoff)
 {
 	struct dib0700_state *st = adapter->dev->priv;
+	struct dib0700_adapter_state *state = adapter->priv;
 	if (st->is_dib7000pc)
-		return dib7000p_pid_filter_ctrl(adapter->fe_adap[0].fe, onoff);
+		return state->dib7000p_ops.pid_filter_ctrl(adapter->fe_adap[0].fe, onoff);
 	return dib7000m_pid_filter_ctrl(adapter->fe_adap[0].fe, onoff);
 }
 
 static int stk70x0p_pid_filter(struct dvb_usb_adapter *adapter, int index, u16 pid, int onoff)
 {
-	return dib7000p_pid_filter(adapter->fe_adap[0].fe, index, pid, onoff);
+	struct dib0700_adapter_state *state = adapter->priv;
+	return state->dib7000p_ops.pid_filter(adapter->fe_adap[0].fe, index, pid, onoff);
 }
 
 static int stk70x0p_pid_filter_ctrl(struct dvb_usb_adapter *adapter, int onoff)
 {
-	return dib7000p_pid_filter_ctrl(adapter->fe_adap[0].fe, onoff);
+	struct dib0700_adapter_state *state = adapter->priv;
+	return state->dib7000p_ops.pid_filter_ctrl(adapter->fe_adap[0].fe, onoff);
 }
 
 static struct dibx000_bandwidth_config dib7070_bw_config_12_mhz = {
@@ -936,6 +975,10 @@ static struct dib7000p_config dib7070p_dib7000p_config = {
 static int stk7070p_frontend_attach(struct dvb_usb_adapter *adap)
 {
 	struct usb_device_descriptor *p = &adap->dev->udev->descriptor;
+	struct dib0700_adapter_state *state = adap->priv;
+
+	dvb_attach(dib7000p_attach, &state->dib7000p_ops);
+
 	if (p->idVendor  == cpu_to_le16(USB_VID_PINNACLE) &&
 	    p->idProduct == cpu_to_le16(USB_PID_PINNACLE_PCTV72E))
 		dib0700_set_gpio(adap->dev, GPIO6, GPIO_OUT, 0);
@@ -954,14 +997,15 @@ static int stk7070p_frontend_attach(struct dvb_usb_adapter *adap)
 	msleep(10);
 	dib0700_set_gpio(adap->dev, GPIO0, GPIO_OUT, 1);
 
-	if (dib7000p_i2c_enumeration(&adap->dev->i2c_adap, 1, 18,
+	if (state->dib7000p_ops.i2c_enumeration(&adap->dev->i2c_adap, 1, 18,
 				     &dib7070p_dib7000p_config) != 0) {
-		err("%s: dib7000p_i2c_enumeration failed.  Cannot continue\n",
+		err("%s: state->dib7000p_ops.i2c_enumeration failed.  Cannot continue\n",
 		    __func__);
+		dvb_dettach(dib7000p_attach);
 		return -ENODEV;
 	}
 
-	adap->fe_adap[0].fe = dvb_attach(dib7000p_init, &adap->dev->i2c_adap, 0x80,
+	adap->fe_adap[0].fe = state->dib7000p_ops.init(&adap->dev->i2c_adap, 0x80,
 		&dib7070p_dib7000p_config);
 	return adap->fe_adap[0].fe == NULL ? -ENODEV : 0;
 }
@@ -988,6 +1032,10 @@ static struct dib7000p_config dib7770p_dib7000p_config = {
 static int stk7770p_frontend_attach(struct dvb_usb_adapter *adap)
 {
 	struct usb_device_descriptor *p = &adap->dev->udev->descriptor;
+	struct dib0700_adapter_state *state = adap->priv;
+
+	dvb_attach(dib7000p_attach, &state->dib7000p_ops);
+
 	if (p->idVendor  == cpu_to_le16(USB_VID_PINNACLE) &&
 	    p->idProduct == cpu_to_le16(USB_PID_PINNACLE_PCTV72E))
 		dib0700_set_gpio(adap->dev, GPIO6, GPIO_OUT, 0);
@@ -1006,14 +1054,15 @@ static int stk7770p_frontend_attach(struct dvb_usb_adapter *adap)
 	msleep(10);
 	dib0700_set_gpio(adap->dev, GPIO0, GPIO_OUT, 1);
 
-	if (dib7000p_i2c_enumeration(&adap->dev->i2c_adap, 1, 18,
+	if (state->dib7000p_ops.i2c_enumeration(&adap->dev->i2c_adap, 1, 18,
 				     &dib7770p_dib7000p_config) != 0) {
-		err("%s: dib7000p_i2c_enumeration failed.  Cannot continue\n",
+		err("%s: state->dib7000p_ops.i2c_enumeration failed.  Cannot continue\n",
 		    __func__);
+		dvb_dettach(dib7000p_attach);
 		return -ENODEV;
 	}
 
-	adap->fe_adap[0].fe = dvb_attach(dib7000p_init, &adap->dev->i2c_adap, 0x80,
+	adap->fe_adap[0].fe = state->dib7000p_ops.init(&adap->dev->i2c_adap, 0x80,
 		&dib7770p_dib7000p_config);
 	return adap->fe_adap[0].fe == NULL ? -ENODEV : 0;
 }
@@ -2479,14 +2528,14 @@ static int dib7090_agc_startup(struct dvb_frontend *fe)
 	memset(&pll, 0, sizeof(struct dibx000_bandwidth_config));
 	dib0090_pwm_gain_reset(fe);
 	target = (dib0090_get_wbd_target(fe) * 8 + 1) / 2;
-	dib7000p_set_wbd_ref(fe, target);
+	state->dib7000p_ops.set_wbd_ref(fe, target);
 
 	if (dib7090p_get_best_sampling(fe, &adc) == 0) {
 		pll.pll_ratio  = adc.pll_loopdiv;
 		pll.pll_prediv = adc.pll_prediv;
 
-		dib7000p_update_pll(fe, &pll);
-		dib7000p_ctrl_timf(fe, DEMOD_TIMF_SET, adc.timf);
+		state->dib7000p_ops.update_pll(fe, &pll);
+		state->dib7000p_ops.ctrl_timf(fe, DEMOD_TIMF_SET, adc.timf);
 	}
 	return 0;
 }
@@ -2501,14 +2550,17 @@ static int dib7090_agc_restart(struct dvb_frontend *fe, u8 restart)
 
 static int tfe7790p_update_lna(struct dvb_frontend *fe, u16 agc_global)
 {
+	struct dvb_usb_adapter *adap = fe->dvb->priv;
+	struct dib0700_adapter_state *state = adap->priv;
+
 	deb_info("update LNA: agc global=%i", agc_global);
 
 	if (agc_global < 25000) {
-		dib7000p_set_gpio(fe, 8, 0, 0);
-		dib7000p_set_agc1_min(fe, 0);
+		state->dib7000p_ops.set_gpio(fe, 8, 0, 0);
+		state->dib7000p_ops.set_agc1_min(fe, 0);
 	} else {
-		dib7000p_set_gpio(fe, 8, 0, 1);
-		dib7000p_set_agc1_min(fe, 32768);
+		state->dib7000p_ops.set_gpio(fe, 8, 0, 1);
+		state->dib7000p_ops.set_agc1_min(fe, 32768);
 	}
 
 	return 0;
@@ -2644,13 +2696,16 @@ static struct dib7000p_config nim7090_dib7000p_config = {
 
 static int tfe7090p_pvr_update_lna(struct dvb_frontend *fe, u16 agc_global)
 {
+	struct dvb_usb_adapter *adap = fe->dvb->priv;
+	struct dib0700_adapter_state *state = adap->priv;
+
 	deb_info("TFE7090P-PVR update LNA: agc global=%i", agc_global);
 	if (agc_global < 25000) {
-		dib7000p_set_gpio(fe, 5, 0, 0);
-		dib7000p_set_agc1_min(fe, 0);
+		state->dib7000p_ops.set_gpio(fe, 5, 0, 0);
+		state->dib7000p_ops.set_agc1_min(fe, 0);
 	} else {
-		dib7000p_set_gpio(fe, 5, 0, 1);
-		dib7000p_set_agc1_min(fe, 32768);
+		state->dib7000p_ops.set_gpio(fe, 5, 0, 1);
+		state->dib7000p_ops.set_agc1_min(fe, 32768);
 	}
 
 	return 0;
@@ -2714,7 +2769,7 @@ static struct dib7000p_config tfe7090pvr_dib7000p_config[2] = {
 	}
 };
 
-static const struct dib0090_config nim7090_dib0090_config = {
+static struct dib0090_config nim7090_dib0090_config = {
 	.io.clock_khz = 12000,
 	.io.pll_bypass = 0,
 	.io.pll_range = 0,
@@ -2722,14 +2777,10 @@ static const struct dib0090_config nim7090_dib0090_config = {
 	.io.pll_loopdiv = 6,
 	.io.adc_clock_ratio = 0,
 	.io.pll_int_loop_filt = 0,
-	.reset = dib7090_tuner_sleep,
-	.sleep = dib7090_tuner_sleep,
 
 	.freq_offset_khz_uhf = 0,
 	.freq_offset_khz_vhf = 0,
 
-	.get_adc_power = dib7090_get_adc_power,
-
 	.clkouttobamse = 1,
 	.analog_output = 0,
 
@@ -2776,7 +2827,7 @@ static struct dib7000p_config tfe7790p_dib7000p_config = {
 	.enMpegOutput				= 1,
 };
 
-static const struct dib0090_config tfe7790p_dib0090_config = {
+static struct dib0090_config tfe7790p_dib0090_config = {
 	.io.clock_khz = 12000,
 	.io.pll_bypass = 0,
 	.io.pll_range = 0,
@@ -2784,14 +2835,10 @@ static const struct dib0090_config tfe7790p_dib0090_config = {
 	.io.pll_loopdiv = 6,
 	.io.adc_clock_ratio = 0,
 	.io.pll_int_loop_filt = 0,
-	.reset = dib7090_tuner_sleep,
-	.sleep = dib7090_tuner_sleep,
 
 	.freq_offset_khz_uhf = 0,
 	.freq_offset_khz_vhf = 0,
 
-	.get_adc_power = dib7090_get_adc_power,
-
 	.clkouttobamse = 1,
 	.analog_output = 0,
 
@@ -2813,7 +2860,7 @@ static const struct dib0090_config tfe7790p_dib0090_config = {
 	.force_crystal_mode = 1,
 };
 
-static const struct dib0090_config tfe7090pvr_dib0090_config[2] = {
+static struct dib0090_config tfe7090pvr_dib0090_config[2] = {
 	{
 		.io.clock_khz = 12000,
 		.io.pll_bypass = 0,
@@ -2822,14 +2869,10 @@ static const struct dib0090_config tfe7090pvr_dib0090_config[2] = {
 		.io.pll_loopdiv = 6,
 		.io.adc_clock_ratio = 0,
 		.io.pll_int_loop_filt = 0,
-		.reset = dib7090_tuner_sleep,
-		.sleep = dib7090_tuner_sleep,
 
 		.freq_offset_khz_uhf = 50,
 		.freq_offset_khz_vhf = 70,
 
-		.get_adc_power = dib7090_get_adc_power,
-
 		.clkouttobamse = 1,
 		.analog_output = 0,
 
@@ -2854,14 +2897,10 @@ static const struct dib0090_config tfe7090pvr_dib0090_config[2] = {
 		.io.pll_loopdiv = 6,
 		.io.adc_clock_ratio = 0,
 		.io.pll_int_loop_filt = 0,
-		.reset = dib7090_tuner_sleep,
-		.sleep = dib7090_tuner_sleep,
 
 		.freq_offset_khz_uhf = -50,
 		.freq_offset_khz_vhf = -70,
 
-		.get_adc_power = dib7090_get_adc_power,
-
 		.clkouttobamse = 1,
 		.analog_output = 0,
 
@@ -2883,6 +2922,10 @@ static const struct dib0090_config tfe7090pvr_dib0090_config[2] = {
 
 static int nim7090_frontend_attach(struct dvb_usb_adapter *adap)
 {
+	struct dib0700_adapter_state *state = adap->priv;
+
+	dvb_attach(dib7000p_attach, &state->dib7000p_ops);
+
 	dib0700_set_gpio(adap->dev, GPIO6, GPIO_OUT, 1);
 	msleep(20);
 	dib0700_set_gpio(adap->dev, GPIO9, GPIO_OUT, 1);
@@ -2895,11 +2938,12 @@ static int nim7090_frontend_attach(struct dvb_usb_adapter *adap)
 	msleep(20);
 	dib0700_set_gpio(adap->dev, GPIO0, GPIO_OUT, 1);
 
-	if (dib7000p_i2c_enumeration(&adap->dev->i2c_adap, 1, 0x10, &nim7090_dib7000p_config) != 0) {
-		err("%s: dib7000p_i2c_enumeration failed.  Cannot continue\n", __func__);
+	if (state->dib7000p_ops.i2c_enumeration(&adap->dev->i2c_adap, 1, 0x10, &nim7090_dib7000p_config) != 0) {
+		err("%s: state->dib7000p_ops.i2c_enumeration failed.  Cannot continue\n", __func__);
+		dvb_dettach(dib7000p_attach);
 		return -ENODEV;
 	}
-	adap->fe_adap[0].fe = dvb_attach(dib7000p_init, &adap->dev->i2c_adap, 0x80, &nim7090_dib7000p_config);
+	adap->fe_adap[0].fe = state->dib7000p_ops.init(&adap->dev->i2c_adap, 0x80, &nim7090_dib7000p_config);
 
 	return adap->fe_adap[0].fe == NULL ?  -ENODEV : 0;
 }
@@ -2907,12 +2951,16 @@ static int nim7090_frontend_attach(struct dvb_usb_adapter *adap)
 static int nim7090_tuner_attach(struct dvb_usb_adapter *adap)
 {
 	struct dib0700_adapter_state *st = adap->priv;
-	struct i2c_adapter *tun_i2c = dib7090_get_i2c_tuner(adap->fe_adap[0].fe);
+	struct i2c_adapter *tun_i2c = st->dib7000p_ops.get_i2c_tuner(adap->fe_adap[0].fe);
+
+	nim7090_dib0090_config.reset = st->dib7000p_ops.tuner_sleep,
+	nim7090_dib0090_config.sleep = st->dib7000p_ops.tuner_sleep,
+	nim7090_dib0090_config.get_adc_power = st->dib7000p_ops.get_adc_power;
 
 	if (dvb_attach(dib0090_register, adap->fe_adap[0].fe, tun_i2c, &nim7090_dib0090_config) == NULL)
 		return -ENODEV;
 
-	dib7000p_set_gpio(adap->fe_adap[0].fe, 8, 0, 1);
+	st->dib7000p_ops.set_gpio(adap->fe_adap[0].fe, 8, 0, 1);
 
 	st->set_param_save = adap->fe_adap[0].fe->ops.tuner_ops.set_params;
 	adap->fe_adap[0].fe->ops.tuner_ops.set_params = dib7090_agc_startup;
@@ -2922,6 +2970,9 @@ static int nim7090_tuner_attach(struct dvb_usb_adapter *adap)
 static int tfe7090pvr_frontend0_attach(struct dvb_usb_adapter *adap)
 {
 	struct dib0700_state *st = adap->dev->priv;
+	struct dib0700_adapter_state *state = adap->priv;
+
+	dvb_attach(dib7000p_attach, &state->dib7000p_ops);
 
 	/* The TFE7090 requires the dib0700 to not be in master mode */
 	st->disable_streaming_master_mode = 1;
@@ -2939,17 +2990,18 @@ static int tfe7090pvr_frontend0_attach(struct dvb_usb_adapter *adap)
 	dib0700_set_gpio(adap->dev, GPIO0, GPIO_OUT, 1);
 
 	/* initialize IC 0 */
-	if (dib7000p_i2c_enumeration(&adap->dev->i2c_adap, 1, 0x20, &tfe7090pvr_dib7000p_config[0]) != 0) {
-		err("%s: dib7000p_i2c_enumeration failed.  Cannot continue\n", __func__);
+	if (state->dib7000p_ops.i2c_enumeration(&adap->dev->i2c_adap, 1, 0x20, &tfe7090pvr_dib7000p_config[0]) != 0) {
+		err("%s: state->dib7000p_ops.i2c_enumeration failed.  Cannot continue\n", __func__);
+		dvb_dettach(dib7000p_attach);
 		return -ENODEV;
 	}
 
 	dib0700_set_i2c_speed(adap->dev, 340);
-	adap->fe_adap[0].fe = dvb_attach(dib7000p_init, &adap->dev->i2c_adap, 0x90, &tfe7090pvr_dib7000p_config[0]);
+	adap->fe_adap[0].fe = state->dib7000p_ops.init(&adap->dev->i2c_adap, 0x90, &tfe7090pvr_dib7000p_config[0]);
 	if (adap->fe_adap[0].fe == NULL)
 		return -ENODEV;
 
-	dib7090_slave_reset(adap->fe_adap[0].fe);
+	state->dib7000p_ops.slave_reset(adap->fe_adap[0].fe);
 
 	return 0;
 }
@@ -2957,19 +3009,23 @@ static int tfe7090pvr_frontend0_attach(struct dvb_usb_adapter *adap)
 static int tfe7090pvr_frontend1_attach(struct dvb_usb_adapter *adap)
 {
 	struct i2c_adapter *i2c;
+	struct dib0700_adapter_state *state = adap->priv;
 
 	if (adap->dev->adapter[0].fe_adap[0].fe == NULL) {
 		err("the master dib7090 has to be initialized first");
 		return -ENODEV; /* the master device has not been initialized */
 	}
 
-	i2c = dib7000p_get_i2c_master(adap->dev->adapter[0].fe_adap[0].fe, DIBX000_I2C_INTERFACE_GPIO_6_7, 1);
-	if (dib7000p_i2c_enumeration(i2c, 1, 0x10, &tfe7090pvr_dib7000p_config[1]) != 0) {
-		err("%s: dib7000p_i2c_enumeration failed.  Cannot continue\n", __func__);
+	dvb_attach(dib7000p_attach, &state->dib7000p_ops);
+
+	i2c = state->dib7000p_ops.get_i2c_master(adap->dev->adapter[0].fe_adap[0].fe, DIBX000_I2C_INTERFACE_GPIO_6_7, 1);
+	if (state->dib7000p_ops.i2c_enumeration(i2c, 1, 0x10, &tfe7090pvr_dib7000p_config[1]) != 0) {
+		err("%s: state->dib7000p_ops.i2c_enumeration failed.  Cannot continue\n", __func__);
+		dvb_dettach(dib7000p_attach);
 		return -ENODEV;
 	}
 
-	adap->fe_adap[0].fe = dvb_attach(dib7000p_init, i2c, 0x92, &tfe7090pvr_dib7000p_config[1]);
+	adap->fe_adap[0].fe = state->dib7000p_ops.init(i2c, 0x92, &tfe7090pvr_dib7000p_config[1]);
 	dib0700_set_i2c_speed(adap->dev, 200);
 
 	return adap->fe_adap[0].fe == NULL ? -ENODEV : 0;
@@ -2978,12 +3034,16 @@ static int tfe7090pvr_frontend1_attach(struct dvb_usb_adapter *adap)
 static int tfe7090pvr_tuner0_attach(struct dvb_usb_adapter *adap)
 {
 	struct dib0700_adapter_state *st = adap->priv;
-	struct i2c_adapter *tun_i2c = dib7090_get_i2c_tuner(adap->fe_adap[0].fe);
+	struct i2c_adapter *tun_i2c = st->dib7000p_ops.get_i2c_tuner(adap->fe_adap[0].fe);
+
+	tfe7090pvr_dib0090_config[0].reset = st->dib7000p_ops.tuner_sleep;
+	tfe7090pvr_dib0090_config[0].sleep = st->dib7000p_ops.tuner_sleep;
+	tfe7090pvr_dib0090_config[0].get_adc_power = st->dib7000p_ops.get_adc_power;
 
 	if (dvb_attach(dib0090_register, adap->fe_adap[0].fe, tun_i2c, &tfe7090pvr_dib0090_config[0]) == NULL)
 		return -ENODEV;
 
-	dib7000p_set_gpio(adap->fe_adap[0].fe, 8, 0, 1);
+	st->dib7000p_ops.set_gpio(adap->fe_adap[0].fe, 8, 0, 1);
 
 	st->set_param_save = adap->fe_adap[0].fe->ops.tuner_ops.set_params;
 	adap->fe_adap[0].fe->ops.tuner_ops.set_params = dib7090_agc_startup;
@@ -2993,12 +3053,16 @@ static int tfe7090pvr_tuner0_attach(struct dvb_usb_adapter *adap)
 static int tfe7090pvr_tuner1_attach(struct dvb_usb_adapter *adap)
 {
 	struct dib0700_adapter_state *st = adap->priv;
-	struct i2c_adapter *tun_i2c = dib7090_get_i2c_tuner(adap->fe_adap[0].fe);
+	struct i2c_adapter *tun_i2c = st->dib7000p_ops.get_i2c_tuner(adap->fe_adap[0].fe);
+
+	tfe7090pvr_dib0090_config[1].reset = st->dib7000p_ops.tuner_sleep;
+	tfe7090pvr_dib0090_config[1].sleep = st->dib7000p_ops.tuner_sleep;
+	tfe7090pvr_dib0090_config[1].get_adc_power = st->dib7000p_ops.get_adc_power;
 
 	if (dvb_attach(dib0090_register, adap->fe_adap[0].fe, tun_i2c, &tfe7090pvr_dib0090_config[1]) == NULL)
 		return -ENODEV;
 
-	dib7000p_set_gpio(adap->fe_adap[0].fe, 8, 0, 1);
+	st->dib7000p_ops.set_gpio(adap->fe_adap[0].fe, 8, 0, 1);
 
 	st->set_param_save = adap->fe_adap[0].fe->ops.tuner_ops.set_params;
 	adap->fe_adap[0].fe->ops.tuner_ops.set_params = dib7090_agc_startup;
@@ -3008,6 +3072,9 @@ static int tfe7090pvr_tuner1_attach(struct dvb_usb_adapter *adap)
 static int tfe7790p_frontend_attach(struct dvb_usb_adapter *adap)
 {
 	struct dib0700_state *st = adap->dev->priv;
+	struct dib0700_adapter_state *state = adap->priv;
+
+	dvb_attach(dib7000p_attach, &state->dib7000p_ops);
 
 	/* The TFE7790P requires the dib0700 to not be in master mode */
 	st->disable_streaming_master_mode = 1;
@@ -3024,13 +3091,14 @@ static int tfe7790p_frontend_attach(struct dvb_usb_adapter *adap)
 	msleep(20);
 	dib0700_set_gpio(adap->dev, GPIO0, GPIO_OUT, 1);
 
-	if (dib7000p_i2c_enumeration(&adap->dev->i2c_adap,
+	if (state->dib7000p_ops.i2c_enumeration(&adap->dev->i2c_adap,
 				1, 0x10, &tfe7790p_dib7000p_config) != 0) {
-		err("%s: dib7000p_i2c_enumeration failed.  Cannot continue\n",
+		err("%s: state->dib7000p_ops.i2c_enumeration failed.  Cannot continue\n",
 				__func__);
+		dvb_dettach(dib7000p_attach);
 		return -ENODEV;
 	}
-	adap->fe_adap[0].fe = dvb_attach(dib7000p_init, &adap->dev->i2c_adap,
+	adap->fe_adap[0].fe = state->dib7000p_ops.init(&adap->dev->i2c_adap,
 			0x80, &tfe7790p_dib7000p_config);
 
 	return adap->fe_adap[0].fe == NULL ?  -ENODEV : 0;
@@ -3040,13 +3108,18 @@ static int tfe7790p_tuner_attach(struct dvb_usb_adapter *adap)
 {
 	struct dib0700_adapter_state *st = adap->priv;
 	struct i2c_adapter *tun_i2c =
-		dib7090_get_i2c_tuner(adap->fe_adap[0].fe);
+		st->dib7000p_ops.get_i2c_tuner(adap->fe_adap[0].fe);
+
+
+	tfe7790p_dib0090_config.reset = st->dib7000p_ops.tuner_sleep;
+	tfe7790p_dib0090_config.sleep = st->dib7000p_ops.tuner_sleep;
+	tfe7790p_dib0090_config.get_adc_power = st->dib7000p_ops.get_adc_power;
 
 	if (dvb_attach(dib0090_register, adap->fe_adap[0].fe, tun_i2c,
 				&tfe7790p_dib0090_config) == NULL)
 		return -ENODEV;
 
-	dib7000p_set_gpio(adap->fe_adap[0].fe, 8, 0, 1);
+	st->dib7000p_ops.set_gpio(adap->fe_adap[0].fe, 8, 0, 1);
 
 	st->set_param_save = adap->fe_adap[0].fe->ops.tuner_ops.set_params;
 	adap->fe_adap[0].fe->ops.tuner_ops.set_params = dib7090_agc_startup;
@@ -3103,25 +3176,34 @@ static void stk7070pd_init(struct dvb_usb_device *dev)
 
 static int stk7070pd_frontend_attach0(struct dvb_usb_adapter *adap)
 {
+	struct dib0700_adapter_state *state = adap->priv;
+
+	dvb_attach(dib7000p_attach, &state->dib7000p_ops);
+
 	stk7070pd_init(adap->dev);
 
 	msleep(10);
 	dib0700_set_gpio(adap->dev, GPIO0, GPIO_OUT, 1);
 
-	if (dib7000p_i2c_enumeration(&adap->dev->i2c_adap, 2, 18,
+	if (state->dib7000p_ops.i2c_enumeration(&adap->dev->i2c_adap, 2, 18,
 				     stk7070pd_dib7000p_config) != 0) {
-		err("%s: dib7000p_i2c_enumeration failed.  Cannot continue\n",
+		err("%s: state->dib7000p_ops.i2c_enumeration failed.  Cannot continue\n",
 		    __func__);
+		dvb_dettach(dib7000p_attach);
 		return -ENODEV;
 	}
 
-	adap->fe_adap[0].fe = dvb_attach(dib7000p_init, &adap->dev->i2c_adap, 0x80, &stk7070pd_dib7000p_config[0]);
+	adap->fe_adap[0].fe = state->dib7000p_ops.init(&adap->dev->i2c_adap, 0x80, &stk7070pd_dib7000p_config[0]);
 	return adap->fe_adap[0].fe == NULL ? -ENODEV : 0;
 }
 
 static int stk7070pd_frontend_attach1(struct dvb_usb_adapter *adap)
 {
-	adap->fe_adap[0].fe = dvb_attach(dib7000p_init, &adap->dev->i2c_adap, 0x82, &stk7070pd_dib7000p_config[1]);
+	struct dib0700_adapter_state *state = adap->priv;
+
+	dvb_attach(dib7000p_attach, &state->dib7000p_ops);
+
+	adap->fe_adap[0].fe = state->dib7000p_ops.init(&adap->dev->i2c_adap, 0x82, &stk7070pd_dib7000p_config[1]);
 	return adap->fe_adap[0].fe == NULL ? -ENODEV : 0;
 }
 
@@ -3164,6 +3246,9 @@ static int novatd_frontend_attach(struct dvb_usb_adapter *adap)
 {
 	struct dvb_usb_device *dev = adap->dev;
 	struct dib0700_state *st = dev->priv;
+	struct dib0700_adapter_state *state = adap->priv;
+
+	dvb_attach(dib7000p_attach, &state->dib7000p_ops);
 
 	if (adap->id == 0) {
 		stk7070pd_init(dev);
@@ -3173,15 +3258,16 @@ static int novatd_frontend_attach(struct dvb_usb_adapter *adap)
 		dib0700_set_gpio(dev, GPIO1, GPIO_OUT, 0);
 		dib0700_set_gpio(dev, GPIO2, GPIO_OUT, 1);
 
-		if (dib7000p_i2c_enumeration(&dev->i2c_adap, 2, 18,
+		if (state->dib7000p_ops.i2c_enumeration(&dev->i2c_adap, 2, 18,
 					     stk7070pd_dib7000p_config) != 0) {
-			err("%s: dib7000p_i2c_enumeration failed.  Cannot continue\n",
+			err("%s: state->dib7000p_ops.i2c_enumeration failed.  Cannot continue\n",
 			    __func__);
+			dvb_dettach(dib7000p_attach);
 			return -ENODEV;
 		}
 	}
 
-	adap->fe_adap[0].fe = dvb_attach(dib7000p_init, &dev->i2c_adap,
+	adap->fe_adap[0].fe = state->dib7000p_ops.init(&dev->i2c_adap,
 			adap->id == 0 ? 0x80 : 0x82,
 			&stk7070pd_dib7000p_config[adap->id]);
 
@@ -3291,12 +3377,13 @@ static int dib0700_xc4000_tuner_callback(void *priv, int component,
 					 int command, int arg)
 {
 	struct dvb_usb_adapter *adap = priv;
+	struct dib0700_adapter_state *state = adap->priv;
 
 	if (command == XC4000_TUNER_RESET) {
 		/* Reset the tuner */
-		dib7000p_set_gpio(adap->fe_adap[0].fe, 8, 0, 0);
+		state->dib7000p_ops.set_gpio(adap->fe_adap[0].fe, 8, 0, 0);
 		msleep(10);
-		dib7000p_set_gpio(adap->fe_adap[0].fe, 8, 0, 1);
+		state->dib7000p_ops.set_gpio(adap->fe_adap[0].fe, 8, 0, 1);
 	} else {
 		err("xc4000: unknown tuner callback command: %d\n", command);
 		return -EINVAL;
@@ -3374,6 +3461,9 @@ static struct dib7000p_config pctv_340e_config = {
 static int pctv340e_frontend_attach(struct dvb_usb_adapter *adap)
 {
 	struct dib0700_state *st = adap->dev->priv;
+	struct dib0700_adapter_state *state = adap->priv;
+
+	dvb_attach(dib7000p_attach, &state->dib7000p_ops);
 
 	/* Power Supply on */
 	dib0700_set_gpio(adap->dev, GPIO6,  GPIO_OUT, 0);
@@ -3397,12 +3487,13 @@ static int pctv340e_frontend_attach(struct dvb_usb_adapter *adap)
 
 	msleep(500);
 
-	if (dib7000pc_detection(&adap->dev->i2c_adap) == 0) {
+	if (state->dib7000p_ops.dib7000pc_detection(&adap->dev->i2c_adap) == 0) {
 		/* Demodulator not found for some reason? */
+		dvb_dettach(dib7000p_attach);
 		return -ENODEV;
 	}
 
-	adap->fe_adap[0].fe = dvb_attach(dib7000p_init, &adap->dev->i2c_adap, 0x12,
+	adap->fe_adap[0].fe = state->dib7000p_ops.init(&adap->dev->i2c_adap, 0x12,
 			      &pctv_340e_config);
 	st->is_dib7000pc = 1;
 
@@ -3420,9 +3511,10 @@ static struct xc4000_config dib7000p_xc4000_tunerconfig = {
 static int xc4000_tuner_attach(struct dvb_usb_adapter *adap)
 {
 	struct i2c_adapter *tun_i2c;
+	struct dib0700_adapter_state *state = adap->priv;
 
 	/* The xc4000 is not on the main i2c bus */
-	tun_i2c = dib7000p_get_i2c_master(adap->fe_adap[0].fe,
+	tun_i2c = state->dib7000p_ops.get_i2c_master(adap->fe_adap[0].fe,
 					  DIBX000_I2C_INTERFACE_TUNER, 1);
 	if (tun_i2c == NULL) {
 		printk(KERN_ERR "Could not reach tuner i2c bus\n");
-- 
1.8.5.3

