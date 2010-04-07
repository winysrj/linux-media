Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:36996 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932581Ab0DGOzO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Apr 2010 10:55:14 -0400
Received: by gyg13 with SMTP id 13so586966gyg.19
        for <linux-media@vger.kernel.org>; Wed, 07 Apr 2010 07:55:13 -0700 (PDT)
From: hiranotaka@zng.jp
Date: Wed, 07 Apr 2010 23:48:48 +0900
Message-Id: <87bpdvgvxr.fsf@wei.zng.jp>
To: linux-media@vger.kernel.org
Subject: [PATCH] pt1: Support Earthsoft PT2
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Support Earthsoft PT2.

Signed-off-by: HIRANO Takahito <hiranotaka@zng.info>
diff -r 7c0b887911cf linux/drivers/media/dvb/pt1/pt1.c
--- a/linux/drivers/media/dvb/pt1/pt1.c	Mon Apr 05 22:56:43 2010 -0400
+++ b/linux/drivers/media/dvb/pt1/pt1.c	Wed Apr 07 23:42:41 2010 +0900
@@ -1,5 +1,5 @@
 /*
- * driver for Earthsoft PT1
+ * driver for Earthsoft PT1/PT2
  *
  * Copyright (C) 2009 HIRANO Takahito <hiranotaka@zng.info>
  *
@@ -76,6 +76,10 @@
 	struct pt1_adapter *adaps[PT1_NR_ADAPS];
 	struct pt1_table *tables;
 	struct task_struct *kthread;
+
+	struct mutex lock;
+	int power;
+	int reset;
 };
 
 struct pt1_adapter {
@@ -94,6 +98,11 @@
 	struct dvb_frontend *fe;
 	int (*orig_set_voltage)(struct dvb_frontend *fe,
 				fe_sec_voltage_t voltage);
+	int (*orig_sleep)(struct dvb_frontend *fe);
+	int (*orig_init)(struct dvb_frontend *fe);
+
+	fe_sec_voltage_t voltage;
+	int sleep;
 };
 
 #define pt1_printk(level, pt1, format, arg...)	\
@@ -218,8 +227,10 @@
 static int pt1_enable_ram(struct pt1 *pt1)
 {
 	int i, ret;
+	int phase;
 	schedule_timeout_uninterruptible((HZ + 999) / 1000);
-	for (i = 0; i < 10; i++) {
+	phase = pt1->pdev->device == 0x211a ? 128 : 166;
+	for (i = 0; i < phase; i++) {
 		ret = pt1_do_enable_ram(pt1);
 		if (ret < 0)
 			return ret;
@@ -484,33 +495,47 @@
 }
 
 static void
-pt1_set_power(struct pt1 *pt1, int power, int lnb, int reset)
+pt1_update_power(struct pt1 *pt1)
 {
-	pt1_write_reg(pt1, 1, power | lnb << 1 | !reset << 3);
+	int bits;
+	int i;
+	struct pt1_adapter *adap;
+	static const int sleep_bits[] = {
+		1 << 4,
+		1 << 6 | 1 << 7,
+		1 << 5,
+		1 << 6 | 1 << 8,
+	};
+
+	bits = pt1->power | !pt1->reset << 3;
+	mutex_lock(&pt1->lock);
+	for (i = 0; i < PT1_NR_ADAPS; i++) {
+		adap = pt1->adaps[i];
+		switch (adap->voltage) {
+		case SEC_VOLTAGE_13: /* actually 11V */
+			bits |= 1 << 1;
+			break;
+		case SEC_VOLTAGE_18: /* actually 15V */
+			bits |= 1 << 1 | 1 << 2;
+			break;
+		default:
+			break;
+		}
+
+		/* XXX: The bits should be changed depending on adap->sleep. */
+		bits |= sleep_bits[i];
+	}
+	pt1_write_reg(pt1, 1, bits);
+	mutex_unlock(&pt1->lock);
 }
 
 static int pt1_set_voltage(struct dvb_frontend *fe, fe_sec_voltage_t voltage)
 {
 	struct pt1_adapter *adap;
-	int lnb;
 
 	adap = container_of(fe->dvb, struct pt1_adapter, adap);
-
-	switch (voltage) {
-	case SEC_VOLTAGE_13: /* actually 11V */
-		lnb = 2;
-		break;
-	case SEC_VOLTAGE_18: /* actually 15V */
-		lnb = 3;
-		break;
-	case SEC_VOLTAGE_OFF:
-		lnb = 0;
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	pt1_set_power(adap->pt1, 1, lnb, 0);
+	adap->voltage = voltage;
+	pt1_update_power(adap->pt1);
 
 	if (adap->orig_set_voltage)
 		return adap->orig_set_voltage(fe, voltage);
@@ -518,9 +543,37 @@
 		return 0;
 }
 
+static int pt1_sleep(struct dvb_frontend *fe)
+{
+	struct pt1_adapter *adap;
+
+	adap = container_of(fe->dvb, struct pt1_adapter, adap);
+	adap->sleep = 1;
+	pt1_update_power(adap->pt1);
+
+	if (adap->orig_sleep)
+		return adap->orig_sleep(fe);
+	else
+		return 0;
+}
+
+static int pt1_wakeup(struct dvb_frontend *fe)
+{
+	struct pt1_adapter *adap;
+
+	adap = container_of(fe->dvb, struct pt1_adapter, adap);
+	adap->sleep = 0;
+	pt1_update_power(adap->pt1);
+	schedule_timeout_uninterruptible((HZ + 999) / 1000);
+
+	if (adap->orig_init)
+		return adap->orig_init(fe);
+	else
+		return 0;
+}
+
 static void pt1_free_adapter(struct pt1_adapter *adap)
 {
-	dvb_unregister_frontend(adap->fe);
 	dvb_net_release(&adap->net);
 	adap->demux.dmx.close(&adap->demux.dmx);
 	dvb_dmxdev_release(&adap->dmxdev);
@@ -533,7 +586,7 @@
 DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
 static struct pt1_adapter *
-pt1_alloc_adapter(struct pt1 *pt1, struct dvb_frontend *fe)
+pt1_alloc_adapter(struct pt1 *pt1)
 {
 	struct pt1_adapter *adap;
 	void *buf;
@@ -550,8 +603,8 @@
 
 	adap->pt1 = pt1;
 
-	adap->orig_set_voltage = fe->ops.set_voltage;
-	fe->ops.set_voltage = pt1_set_voltage;
+	adap->voltage = SEC_VOLTAGE_OFF;
+	adap->sleep = 1;
 
 	buf = (u8 *)__get_free_page(GFP_KERNEL);
 	if (!buf) {
@@ -592,17 +645,8 @@
 
 	dvb_net_init(dvb_adap, &adap->net, &demux->dmx);
 
-	ret = dvb_register_frontend(dvb_adap, fe);
-	if (ret < 0)
-		goto err_net_release;
-	adap->fe = fe;
-
 	return adap;
 
-err_net_release:
-	dvb_net_release(&adap->net);
-	adap->demux.dmx.close(&adap->demux.dmx);
-	dvb_dmxdev_release(&adap->dmxdev);
 err_dmx_release:
 	dvb_dmx_release(demux);
 err_unregister_adapter:
@@ -622,6 +666,62 @@
 		pt1_free_adapter(pt1->adaps[i]);
 }
 
+static int pt1_init_adapters(struct pt1 *pt1)
+{
+	int i;
+	struct pt1_adapter *adap;
+	int ret;
+
+	for (i = 0; i < PT1_NR_ADAPS; i++) {
+		adap = pt1_alloc_adapter(pt1);
+		if (IS_ERR(adap)) {
+			ret = PTR_ERR(adap);
+			goto err;
+		}
+
+		adap->index = i;
+		pt1->adaps[i] = adap;
+	}
+	return 0;
+
+err:
+	while (i--)
+		pt1_free_adapter(pt1->adaps[i]);
+
+	return ret;
+}
+
+static void pt1_cleanup_frontend(struct pt1_adapter *adap)
+{
+	dvb_unregister_frontend(adap->fe);
+}
+
+static int pt1_init_frontend(struct pt1_adapter *adap, struct dvb_frontend *fe)
+{
+	int ret;
+
+	adap->orig_set_voltage = fe->ops.set_voltage;
+	adap->orig_sleep = fe->ops.sleep;
+	adap->orig_init = fe->ops.init;
+	fe->ops.set_voltage = pt1_set_voltage;
+	fe->ops.sleep = pt1_sleep;
+	fe->ops.init = pt1_wakeup;
+
+	ret = dvb_register_frontend(&adap->adap, fe);
+	if (ret < 0)
+		return ret;
+
+	adap->fe = fe;
+	return 0;
+}
+
+static void pt1_cleanup_frontends(struct pt1 *pt1)
+{
+	int i;
+	for (i = 0; i < PT1_NR_ADAPS; i++)
+		pt1_cleanup_frontend(pt1->adaps[i]);
+}
+
 struct pt1_config {
 	struct va1j5jf8007s_config va1j5jf8007s_config;
 	struct va1j5jf8007t_config va1j5jf8007t_config;
@@ -629,29 +729,63 @@
 
 static const struct pt1_config pt1_configs[2] = {
 	{
-		{ .demod_address = 0x1b },
-		{ .demod_address = 0x1a },
+		{
+			.demod_address = 0x1b,
+			.frequency = VA1J5JF8007S_20MHZ,
+		},
+		{
+			.demod_address = 0x1a,
+			.frequency = VA1J5JF8007T_20MHZ,
+		},
 	}, {
-		{ .demod_address = 0x19 },
-		{ .demod_address = 0x18 },
+		{
+			.demod_address = 0x19,
+			.frequency = VA1J5JF8007S_20MHZ,
+		},
+		{
+			.demod_address = 0x18,
+			.frequency = VA1J5JF8007T_20MHZ,
+		},
 	},
 };
 
-static int pt1_init_adapters(struct pt1 *pt1)
+static const struct pt1_config pt2_configs[2] = {
+	{
+		{
+			.demod_address = 0x1b,
+			.frequency = VA1J5JF8007S_25MHZ,
+		},
+		{
+			.demod_address = 0x1a,
+			.frequency = VA1J5JF8007T_25MHZ,
+		},
+	}, {
+		{
+			.demod_address = 0x19,
+			.frequency = VA1J5JF8007S_25MHZ,
+		},
+		{
+			.demod_address = 0x18,
+			.frequency = VA1J5JF8007T_25MHZ,
+		},
+	},
+};
+
+static int pt1_init_frontends(struct pt1 *pt1)
 {
 	int i, j;
 	struct i2c_adapter *i2c_adap;
-	const struct pt1_config *config;
+	const struct pt1_config *configs, *config;
 	struct dvb_frontend *fe[4];
-	struct pt1_adapter *adap;
 	int ret;
 
 	i = 0;
 	j = 0;
 
 	i2c_adap = &pt1->i2c_adap;
+	configs = pt1->pdev->device == 0x211a ? pt1_configs : pt2_configs;
 	do {
-		config = &pt1_configs[i / 2];
+		config = &configs[i / 2];
 
 		fe[i] = va1j5jf8007s_attach(&config->va1j5jf8007s_config,
 					    i2c_adap);
@@ -680,11 +814,9 @@
 	} while (i < 4);
 
 	do {
-		adap = pt1_alloc_adapter(pt1, fe[j]);
-		if (IS_ERR(adap))
+		ret = pt1_init_frontend(pt1->adaps[j], fe[j]);
+		if (ret < 0)
 			goto err;
-		adap->index = j;
-		pt1->adaps[j] = adap;
 	} while (++j < 4);
 
 	return 0;
@@ -694,7 +826,7 @@
 		fe[i]->ops.release(fe[i]);
 
 	while (j--)
-		pt1_free_adapter(pt1->adaps[j]);
+		dvb_unregister_frontend(fe[j]);
 
 	return ret;
 }
@@ -889,9 +1021,12 @@
 
 	kthread_stop(pt1->kthread);
 	pt1_cleanup_tables(pt1);
+	pt1_cleanup_frontends(pt1);
+	pt1_disable_ram(pt1);
+	pt1->power = 0;
+	pt1->reset = 1;
+	pt1_update_power(pt1);
 	pt1_cleanup_adapters(pt1);
-	pt1_disable_ram(pt1);
-	pt1_set_power(pt1, 0, 0, 1);
 	i2c_del_adapter(&pt1->i2c_adap);
 	pci_set_drvdata(pdev, NULL);
 	kfree(pt1);
@@ -935,10 +1070,21 @@
 		goto err_pci_iounmap;
 	}
 
+	mutex_init(&pt1->lock);
 	pt1->pdev = pdev;
 	pt1->regs = regs;
 	pci_set_drvdata(pdev, pt1);
 
+	ret = pt1_init_adapters(pt1);
+	if (ret < 0)
+		goto err_kfree;
+
+	mutex_init(&pt1->lock);
+
+	pt1->power = 0;
+	pt1->reset = 1;
+	pt1_update_power(pt1);
+
 	i2c_adap = &pt1->i2c_adap;
 	i2c_adap->class = I2C_CLASS_TV_DIGITAL;
 	i2c_adap->algo = &pt1_i2c_algo;
@@ -947,9 +1093,7 @@
 	i2c_set_adapdata(i2c_adap, pt1);
 	ret = i2c_add_adapter(i2c_adap);
 	if (ret < 0)
-		goto err_kfree;
-
-	pt1_set_power(pt1, 0, 0, 1);
+		goto err_pt1_cleanup_adapters;
 
 	pt1_i2c_init(pt1);
 	pt1_i2c_wait(pt1);
@@ -978,19 +1122,21 @@
 
 	pt1_init_streams(pt1);
 
-	pt1_set_power(pt1, 1, 0, 1);
+	pt1->power = 1;
+	pt1_update_power(pt1);
 	schedule_timeout_uninterruptible((HZ + 49) / 50);
 
-	pt1_set_power(pt1, 1, 0, 0);
+	pt1->reset = 0;
+	pt1_update_power(pt1);
 	schedule_timeout_uninterruptible((HZ + 999) / 1000);
 
-	ret = pt1_init_adapters(pt1);
+	ret = pt1_init_frontends(pt1);
 	if (ret < 0)
 		goto err_pt1_disable_ram;
 
 	ret = pt1_init_tables(pt1);
 	if (ret < 0)
-		goto err_pt1_cleanup_adapters;
+		goto err_pt1_cleanup_frontends;
 
 	kthread = kthread_run(pt1_thread, pt1, "pt1");
 	if (IS_ERR(kthread)) {
@@ -1003,11 +1149,15 @@
 
 err_pt1_cleanup_tables:
 	pt1_cleanup_tables(pt1);
+err_pt1_cleanup_frontends:
+	pt1_cleanup_frontends(pt1);
+err_pt1_disable_ram:
+	pt1_disable_ram(pt1);
+	pt1->power = 0;
+	pt1->reset = 1;
+	pt1_update_power(pt1);
 err_pt1_cleanup_adapters:
 	pt1_cleanup_adapters(pt1);
-err_pt1_disable_ram:
-	pt1_disable_ram(pt1);
-	pt1_set_power(pt1, 0, 0, 1);
 err_i2c_del_adapter:
 	i2c_del_adapter(i2c_adap);
 err_kfree:
@@ -1026,6 +1176,7 @@
 
 static struct pci_device_id pt1_id_table[] = {
 	{ PCI_DEVICE(0x10ee, 0x211a) },
+	{ PCI_DEVICE(0x10ee, 0x222a) },
 	{ },
 };
 MODULE_DEVICE_TABLE(pci, pt1_id_table);
@@ -1053,5 +1204,5 @@
 module_exit(pt1_cleanup);
 
 MODULE_AUTHOR("Takahito HIRANO <hiranotaka@zng.info>");
-MODULE_DESCRIPTION("Earthsoft PT1 Driver");
+MODULE_DESCRIPTION("Earthsoft PT1/PT2 Driver");
 MODULE_LICENSE("GPL");
diff -r 7c0b887911cf linux/drivers/media/dvb/pt1/va1j5jf8007s.c
--- a/linux/drivers/media/dvb/pt1/va1j5jf8007s.c	Mon Apr 05 22:56:43 2010 -0400
+++ b/linux/drivers/media/dvb/pt1/va1j5jf8007s.c	Wed Apr 07 23:42:41 2010 +0900
@@ -1,5 +1,5 @@
 /*
- * ISDB-S driver for VA1J5JF8007
+ * ISDB-S driver for VA1J5JF8007/VA1J5JF8011
  *
  * Copyright (C) 2009 HIRANO Takahito <hiranotaka@zng.info>
  *
@@ -580,7 +580,7 @@
 
 static struct dvb_frontend_ops va1j5jf8007s_ops = {
 	.info = {
-		.name = "VA1J5JF8007 ISDB-S",
+		.name = "VA1J5JF8007/VA1J5JF8011 ISDB-S",
 		.type = FE_QPSK,
 		.frequency_min = 950000,
 		.frequency_max = 2150000,
@@ -628,28 +628,50 @@
 	return 0;
 }
 
-static const u8 va1j5jf8007s_prepare_bufs[][2] = {
+static const u8 va1j5jf8007s_20mhz_prepare_bufs[][2] = {
 	{0x04, 0x02}, {0x0d, 0x55}, {0x11, 0x40}, {0x13, 0x80}, {0x17, 0x01},
 	{0x1c, 0x0a}, {0x1d, 0xaa}, {0x1e, 0x20}, {0x1f, 0x88}, {0x51, 0xb0},
 	{0x52, 0x89}, {0x53, 0xb3}, {0x5a, 0x2d}, {0x5b, 0xd3}, {0x85, 0x69},
 	{0x87, 0x04}, {0x8e, 0x02}, {0xa3, 0xf7}, {0xa5, 0xc0},
 };
 
+static const u8 va1j5jf8007s_25mhz_prepare_bufs[][2] = {
+	{0x04, 0x02}, {0x11, 0x40}, {0x13, 0x80}, {0x17, 0x01}, {0x1c, 0x0a},
+	{0x1d, 0xaa}, {0x1e, 0x20}, {0x1f, 0x88}, {0x51, 0xb0}, {0x52, 0x89},
+	{0x53, 0xb3}, {0x5a, 0x2d}, {0x5b, 0xd3}, {0x85, 0x69}, {0x87, 0x04},
+	{0x8e, 0x26}, {0xa3, 0xf7}, {0xa5, 0xc0},
+};
+
 static int va1j5jf8007s_prepare_2(struct va1j5jf8007s_state *state)
 {
+	const u8 (*bufs)[2];
+	int size;
 	u8 addr;
 	u8 buf[2];
 	struct i2c_msg msg;
 	int i;
 
+	switch (state->config->frequency) {
+	case VA1J5JF8007S_20MHZ:
+		bufs = va1j5jf8007s_20mhz_prepare_bufs;
+		size = ARRAY_SIZE(va1j5jf8007s_20mhz_prepare_bufs);
+		break;
+	case VA1J5JF8007S_25MHZ:
+		bufs = va1j5jf8007s_25mhz_prepare_bufs;
+		size = ARRAY_SIZE(va1j5jf8007s_25mhz_prepare_bufs);
+		break;
+	default:
+		return -EINVAL;
+	}
+
 	addr = state->config->demod_address;
 
 	msg.addr = addr;
 	msg.flags = 0;
 	msg.len = 2;
 	msg.buf = buf;
-	for (i = 0; i < ARRAY_SIZE(va1j5jf8007s_prepare_bufs); i++) {
-		memcpy(buf, va1j5jf8007s_prepare_bufs[i], sizeof(buf));
+	for (i = 0; i < size; i++) {
+		memcpy(buf, bufs[i], sizeof(buf));
 		if (i2c_transfer(state->adap, &msg, 1) != 1)
 			return -EREMOTEIO;
 	}
diff -r 7c0b887911cf linux/drivers/media/dvb/pt1/va1j5jf8007s.h
--- a/linux/drivers/media/dvb/pt1/va1j5jf8007s.h	Mon Apr 05 22:56:43 2010 -0400
+++ b/linux/drivers/media/dvb/pt1/va1j5jf8007s.h	Wed Apr 07 23:42:41 2010 +0900
@@ -1,5 +1,5 @@
 /*
- * ISDB-S driver for VA1J5JF8007
+ * ISDB-S driver for VA1J5JF8007/VA1J5JF8011
  *
  * Copyright (C) 2009 HIRANO Takahito <hiranotaka@zng.info>
  *
@@ -24,8 +24,14 @@
 #ifndef VA1J5JF8007S_H
 #define VA1J5JF8007S_H
 
+enum va1j5jf8007s_frequency {
+	VA1J5JF8007S_20MHZ,
+	VA1J5JF8007S_25MHZ,
+};
+
 struct va1j5jf8007s_config {
 	u8 demod_address;
+	enum va1j5jf8007s_frequency frequency;
 };
 
 struct i2c_adapter;
diff -r 7c0b887911cf linux/drivers/media/dvb/pt1/va1j5jf8007t.c
--- a/linux/drivers/media/dvb/pt1/va1j5jf8007t.c	Mon Apr 05 22:56:43 2010 -0400
+++ b/linux/drivers/media/dvb/pt1/va1j5jf8007t.c	Wed Apr 07 23:42:41 2010 +0900
@@ -1,5 +1,5 @@
 /*
- * ISDB-T driver for VA1J5JF8007
+ * ISDB-T driver for VA1J5JF8007/VA1J5JF8011
  *
  * Copyright (C) 2009 HIRANO Takahito <hiranotaka@zng.info>
  *
@@ -429,7 +429,7 @@
 
 static struct dvb_frontend_ops va1j5jf8007t_ops = {
 	.info = {
-		.name = "VA1J5JF8007 ISDB-T",
+		.name = "VA1J5JF8007/VA1J5JF8011 ISDB-T",
 		.type = FE_OFDM,
 		.frequency_min = 90000000,
 		.frequency_max = 770000000,
@@ -448,29 +448,50 @@
 	.release = va1j5jf8007t_release,
 };
 
-static const u8 va1j5jf8007t_prepare_bufs[][2] = {
+static const u8 va1j5jf8007t_20mhz_prepare_bufs[][2] = {
 	{0x03, 0x90}, {0x14, 0x8f}, {0x1c, 0x2a}, {0x1d, 0xa8}, {0x1e, 0xa2},
 	{0x22, 0x83}, {0x31, 0x0d}, {0x32, 0xe0}, {0x39, 0xd3}, {0x3a, 0x00},
 	{0x5c, 0x40}, {0x5f, 0x80}, {0x75, 0x02}, {0x76, 0x4e}, {0x77, 0x03},
 	{0xef, 0x01}
 };
 
+static const u8 va1j5jf8007t_25mhz_prepare_bufs[][2] = {
+	{0x03, 0x90}, {0x1c, 0x2a}, {0x1d, 0xa8}, {0x1e, 0xa2}, {0x22, 0x83},
+	{0x3a, 0x00}, {0x5c, 0x40}, {0x5f, 0x80}, {0x75, 0x0a}, {0x76, 0x4c},
+	{0x77, 0x03}, {0xef, 0x01}
+};
+
 int va1j5jf8007t_prepare(struct dvb_frontend *fe)
 {
 	struct va1j5jf8007t_state *state;
+	const u8 (*bufs)[2];
+	int size;
 	u8 buf[2];
 	struct i2c_msg msg;
 	int i;
 
 	state = fe->demodulator_priv;
 
+	switch (state->config->frequency) {
+	case VA1J5JF8007T_20MHZ:
+		bufs = va1j5jf8007t_20mhz_prepare_bufs;
+		size = ARRAY_SIZE(va1j5jf8007t_20mhz_prepare_bufs);
+		break;
+	case VA1J5JF8007T_25MHZ:
+		bufs = va1j5jf8007t_25mhz_prepare_bufs;
+		size = ARRAY_SIZE(va1j5jf8007t_25mhz_prepare_bufs);
+		break;
+	default:
+		return -EINVAL;
+	}
+
 	msg.addr = state->config->demod_address;
 	msg.flags = 0;
 	msg.len = sizeof(buf);
 	msg.buf = buf;
 
-	for (i = 0; i < ARRAY_SIZE(va1j5jf8007t_prepare_bufs); i++) {
-		memcpy(buf, va1j5jf8007t_prepare_bufs[i], sizeof(buf));
+	for (i = 0; i < size; i++) {
+		memcpy(buf, bufs[i], sizeof(buf));
 		if (i2c_transfer(state->adap, &msg, 1) != 1)
 			return -EREMOTEIO;
 	}
diff -r 7c0b887911cf linux/drivers/media/dvb/pt1/va1j5jf8007t.h
--- a/linux/drivers/media/dvb/pt1/va1j5jf8007t.h	Mon Apr 05 22:56:43 2010 -0400
+++ b/linux/drivers/media/dvb/pt1/va1j5jf8007t.h	Wed Apr 07 23:42:41 2010 +0900
@@ -1,5 +1,5 @@
 /*
- * ISDB-T driver for VA1J5JF8007
+ * ISDB-T driver for VA1J5JF8007/VA1J5JF8011
  *
  * Copyright (C) 2009 HIRANO Takahito <hiranotaka@zng.info>
  *
@@ -24,8 +24,14 @@
 #ifndef VA1J5JF8007T_H
 #define VA1J5JF8007T_H
 
+enum va1j5jf8007t_frequency {
+	VA1J5JF8007T_20MHZ,
+	VA1J5JF8007T_25MHZ,
+};
+
 struct va1j5jf8007t_config {
 	u8 demod_address;
+	enum va1j5jf8007t_frequency frequency;
 };
 
 struct i2c_adapter;
