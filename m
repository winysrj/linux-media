Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:17959 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750880Ab1BNVGe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Feb 2011 16:06:34 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p1EL6YWl027416
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 14 Feb 2011 16:06:34 -0500
Received: from pedra (vpn-239-121.phx2.redhat.com [10.3.239.121])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p1EL3TG6012908
	for <linux-media@vger.kernel.org>; Mon, 14 Feb 2011 16:06:33 -0500
Date: Mon, 14 Feb 2011 19:03:14 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 06/14] [media] tuner-core: Reorganize the functions
 internally
Message-ID: <20110214190314.566ffdc5@pedra>
In-Reply-To: <cover.1297716906.git.mchehab@redhat.com>
References: <cover.1297716906.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This is a big patch with no functional changes. It just
rearranges everything inside the driver, and prepares to
break TV and Radio into two separate fops groups.

Currently, it has an heuristics logic to determine if the
call came from radio or video. However, the caller driver
knows for sure, so tuner-core shouldn't try to guess it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/tuner-core.c b/drivers/media/video/tuner-core.c
index f497f52..5c3da21 100644
--- a/drivers/media/video/tuner-core.c
+++ b/drivers/media/video/tuner-core.c
@@ -34,6 +34,99 @@
 
 #define PREFIX t->i2c->driver->driver.name
 
+/*
+ * Driver modprobe parameters
+ */
+
+/* insmod options used at init time => read/only */
+static unsigned int addr;
+static unsigned int no_autodetect;
+static unsigned int show_i2c;
+
+module_param(addr, int, 0444);
+module_param(no_autodetect, int, 0444);
+module_param(show_i2c, int, 0444);
+
+/* insmod options used at runtime => read/write */
+static int tuner_debug;
+static unsigned int tv_range[2] = { 44, 958 };
+static unsigned int radio_range[2] = { 65, 108 };
+static char pal[] = "--";
+static char secam[] = "--";
+static char ntsc[] = "-";
+
+module_param_named(debug,tuner_debug, int, 0644);
+module_param_array(tv_range, int, NULL, 0644);
+module_param_array(radio_range, int, NULL, 0644);
+module_param_string(pal, pal, sizeof(pal), 0644);
+module_param_string(secam, secam, sizeof(secam), 0644);
+module_param_string(ntsc, ntsc, sizeof(ntsc), 0644);
+
+/*
+ * Static vars
+ */
+
+static struct xc5000_config xc5000_cfg;
+static LIST_HEAD(tuner_list);
+
+/*
+ * Debug macros
+ */
+
+#define tuner_warn(fmt, arg...) do {			\
+	printk(KERN_WARNING "%s %d-%04x: " fmt, PREFIX, \
+	       i2c_adapter_id(t->i2c->adapter),		\
+	       t->i2c->addr, ##arg);			\
+	 } while (0)
+
+#define tuner_info(fmt, arg...) do {			\
+	printk(KERN_INFO "%s %d-%04x: " fmt, PREFIX,	\
+	       i2c_adapter_id(t->i2c->adapter),		\
+	       t->i2c->addr, ##arg);			\
+	 } while (0)
+
+#define tuner_err(fmt, arg...) do {			\
+	printk(KERN_ERR "%s %d-%04x: " fmt, PREFIX,	\
+	       i2c_adapter_id(t->i2c->adapter),		\
+	       t->i2c->addr, ##arg);			\
+	 } while (0)
+
+#define tuner_dbg(fmt, arg...) do {				\
+	if (tuner_debug)					\
+		printk(KERN_DEBUG "%s %d-%04x: " fmt, PREFIX,	\
+		       i2c_adapter_id(t->i2c->adapter),		\
+		       t->i2c->addr, ##arg);			\
+	 } while (0)
+
+/*
+ * Internal struct used inside the driver
+ */
+
+struct tuner {
+	/* device */
+	struct dvb_frontend fe;
+	struct i2c_client   *i2c;
+	struct v4l2_subdev  sd;
+	struct list_head    list;
+
+	/* keep track of the current settings */
+	v4l2_std_id         std;
+	unsigned int        tv_freq;
+	unsigned int        radio_freq;
+	unsigned int        audmode;
+
+	unsigned int        mode;
+	unsigned int        mode_mask; /* Combination of allowable modes */
+
+	unsigned int        type; /* chip type id */
+	unsigned int        config;
+	const char          *name;
+};
+
+/*
+ * tuner attach/detach logic
+ */
+
 /** This macro allows us to probe dynamically, avoiding static links */
 #ifdef CONFIG_MEDIA_ATTACH
 #define tuner_symbol_probe(FUNCTION, ARGS...) ({ \
@@ -74,91 +167,15 @@ static void tuner_detach(struct dvb_frontend *fe)
 }
 #endif
 
-struct tuner {
-	/* device */
-	struct dvb_frontend fe;
-	struct i2c_client   *i2c;
-	struct v4l2_subdev  sd;
-	struct list_head    list;
-
-	/* keep track of the current settings */
-	v4l2_std_id         std;
-	unsigned int        tv_freq;
-	unsigned int        radio_freq;
-	unsigned int        audmode;
-
-	unsigned int        mode;
-	unsigned int        mode_mask; /* Combination of allowable modes */
-
-	unsigned int        type; /* chip type id */
-	unsigned int        config;
-	const char          *name;
-};
 
 static inline struct tuner *to_tuner(struct v4l2_subdev *sd)
 {
 	return container_of(sd, struct tuner, sd);
 }
 
-
-/* insmod options used at init time => read/only */
-static unsigned int addr;
-static unsigned int no_autodetect;
-static unsigned int show_i2c;
-
-/* insmod options used at runtime => read/write */
-static int tuner_debug;
-
-#define tuner_warn(fmt, arg...) do {			\
-	printk(KERN_WARNING "%s %d-%04x: " fmt, PREFIX, \
-	       i2c_adapter_id(t->i2c->adapter),		\
-	       t->i2c->addr, ##arg);			\
-	 } while (0)
-
-#define tuner_info(fmt, arg...) do {			\
-	printk(KERN_INFO "%s %d-%04x: " fmt, PREFIX,	\
-	       i2c_adapter_id(t->i2c->adapter),		\
-	       t->i2c->addr, ##arg);			\
-	 } while (0)
-
-#define tuner_err(fmt, arg...) do {			\
-	printk(KERN_ERR "%s %d-%04x: " fmt, PREFIX,	\
-	       i2c_adapter_id(t->i2c->adapter),		\
-	       t->i2c->addr, ##arg);			\
-	 } while (0)
-
-#define tuner_dbg(fmt, arg...) do {				\
-	if (tuner_debug)					\
-		printk(KERN_DEBUG "%s %d-%04x: " fmt, PREFIX,	\
-		       i2c_adapter_id(t->i2c->adapter),		\
-		       t->i2c->addr, ##arg);			\
-	 } while (0)
-
-/* ------------------------------------------------------------------------ */
-
-static unsigned int tv_range[2] = { 44, 958 };
-static unsigned int radio_range[2] = { 65, 108 };
-
-static char pal[] = "--";
-static char secam[] = "--";
-static char ntsc[] = "-";
-
-
-module_param(addr, int, 0444);
-module_param(no_autodetect, int, 0444);
-module_param(show_i2c, int, 0444);
-module_param_named(debug,tuner_debug, int, 0644);
-module_param_string(pal, pal, sizeof(pal), 0644);
-module_param_string(secam, secam, sizeof(secam), 0644);
-module_param_string(ntsc, ntsc, sizeof(ntsc), 0644);
-module_param_array(tv_range, int, NULL, 0644);
-module_param_array(radio_range, int, NULL, 0644);
-
-MODULE_DESCRIPTION("device driver for various TV and TV+FM radio tuners");
-MODULE_AUTHOR("Ralph Metzler, Gerd Knorr, Gunther Mayer");
-MODULE_LICENSE("GPL");
-
-/* ---------------------------------------------------------------------- */
+/*
+ * struct analog_demod_ops callbacks
+ */
 
 static void fe_set_params(struct dvb_frontend *fe,
 			  struct analog_parameters *params)
@@ -214,101 +231,13 @@ static struct analog_demod_ops tuner_analog_ops = {
 	.tuner_status   = tuner_status
 };
 
-/* Set tuner frequency,  freq in Units of 62.5kHz = 1/16MHz */
-static void set_tv_freq(struct i2c_client *c, unsigned int freq)
-{
-	struct tuner *t = to_tuner(i2c_get_clientdata(c));
-	struct analog_demod_ops *analog_ops = &t->fe.ops.analog_ops;
+/*
+ * Functions that are common to both TV and radio
+ */
 
-	struct analog_parameters params = {
-		.mode      = t->mode,
-		.audmode   = t->audmode,
-		.std       = t->std
-	};
-
-	if (t->type == UNSET) {
-		tuner_warn ("tuner type not set\n");
-		return;
-	}
-	if (NULL == analog_ops->set_params) {
-		tuner_warn ("Tuner has no way to set tv freq\n");
-		return;
-	}
-	if (freq < tv_range[0] * 16 || freq > tv_range[1] * 16) {
-		tuner_dbg ("TV freq (%d.%02d) out of range (%d-%d)\n",
-			   freq / 16, freq % 16 * 100 / 16, tv_range[0],
-			   tv_range[1]);
-		/* V4L2 spec: if the freq is not possible then the closest
-		   possible value should be selected */
-		if (freq < tv_range[0] * 16)
-			freq = tv_range[0] * 16;
-		else
-			freq = tv_range[1] * 16;
-	}
-	params.frequency = freq;
-	tuner_dbg("tv freq set to %lu.%02lu\n",
-			freq / 16, freq % 16 * 100 / 16);
-	t->tv_freq = freq;
-
-	analog_ops->set_params(&t->fe, &params);
-}
-
-static void set_radio_freq(struct i2c_client *c, unsigned int freq)
-{
-	struct tuner *t = to_tuner(i2c_get_clientdata(c));
-	struct analog_demod_ops *analog_ops = &t->fe.ops.analog_ops;
-
-	struct analog_parameters params = {
-		.mode      = t->mode,
-		.audmode   = t->audmode,
-		.std       = t->std
-	};
-
-	if (t->type == UNSET) {
-		tuner_warn ("tuner type not set\n");
-		return;
-	}
-	if (NULL == analog_ops->set_params) {
-		tuner_warn ("tuner has no way to set radio frequency\n");
-		return;
-	}
-	if (freq < radio_range[0] * 16000 || freq > radio_range[1] * 16000) {
-		tuner_dbg ("radio freq (%d.%02d) out of range (%d-%d)\n",
-			   freq / 16000, freq % 16000 * 100 / 16000,
-			   radio_range[0], radio_range[1]);
-		/* V4L2 spec: if the freq is not possible then the closest
-		   possible value should be selected */
-		if (freq < radio_range[0] * 16000)
-			freq = radio_range[0] * 16000;
-		else
-			freq = radio_range[1] * 16000;
-	}
-	params.frequency = freq;
-	tuner_dbg("radio freq set to %lu.%02lu\n",
-			freq / 16000, freq % 16000 * 100 / 16000);
-	t->radio_freq = freq;
-
-	analog_ops->set_params(&t->fe, &params);
-}
-
-static void set_freq(struct i2c_client *c, unsigned long freq)
-{
-	struct tuner *t = to_tuner(i2c_get_clientdata(c));
-
-	switch (t->mode) {
-	case V4L2_TUNER_RADIO:
-		set_radio_freq(c, freq);
-		break;
-	case V4L2_TUNER_ANALOG_TV:
-	case V4L2_TUNER_DIGITAL_TV:
-		set_tv_freq(c, freq);
-		break;
-	default:
-		tuner_dbg("freq set: unknown mode: 0x%04x!\n",t->mode);
-	}
-}
-
-static struct xc5000_config xc5000_cfg;
+static void set_tv_freq(struct i2c_client *c, unsigned int freq);
+static void set_radio_freq(struct i2c_client *c, unsigned int freq);
+static const struct v4l2_subdev_ops tuner_ops;
 
 static void set_type(struct i2c_client *c, unsigned int type,
 		     unsigned int new_mode_mask, unsigned int new_config,
@@ -467,9 +396,12 @@ static void set_type(struct i2c_client *c, unsigned int type,
 	   FIXME: better to move set_freq to the tuner code. This is needed
 	   on analog tuners for PLL to properly work
 	 */
-	if (tune_now)
-		set_freq(c, (V4L2_TUNER_RADIO == t->mode) ?
-			    t->radio_freq : t->tv_freq);
+	if (tune_now) {
+		if (V4L2_TUNER_RADIO == t->mode)
+			set_radio_freq(c, t->radio_freq);
+		else
+			set_tv_freq(c, t->tv_freq);
+	}
 
 	tuner_dbg("%s %s I2C addr 0x%02x with type %d used for 0x%02x\n",
 		  c->adapter->name, c->driver->driver.name, c->addr << 1, type,
@@ -508,26 +440,249 @@ static void set_addr(struct i2c_client *c, struct tuner_setup *tun_setup)
 			  tun_setup->addr, tun_setup->mode_mask);
 }
 
-static inline int check_mode(struct tuner *t, char *cmd)
+static int tuner_s_type_addr(struct v4l2_subdev *sd, struct tuner_setup *type)
 {
-	if ((1 << t->mode & t->mode_mask) == 0) {
-		return -EINVAL;
+	struct tuner *t = to_tuner(sd);
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+
+	tuner_dbg("Calling set_type_addr for type=%d, addr=0x%02x, mode=0x%02x, config=0x%02x\n",
+			type->type,
+			type->addr,
+			type->mode_mask,
+			type->config);
+
+	set_addr(client, type);
+	return 0;
+}
+
+static int tuner_s_config(struct v4l2_subdev *sd, const struct v4l2_priv_tun_config *cfg)
+{
+	struct tuner *t = to_tuner(sd);
+	struct analog_demod_ops *analog_ops = &t->fe.ops.analog_ops;
+
+	if (t->type != cfg->tuner)
+		return 0;
+
+	if (analog_ops->set_config) {
+		analog_ops->set_config(&t->fe, cfg->priv);
+		return 0;
+	}
+
+	tuner_dbg("Tuner frontend module has no way to set config\n");
+	return 0;
+}
+
+/* Search for existing radio and/or TV tuners on the given I2C adapter.
+   Note that when this function is called from tuner_probe you can be
+   certain no other devices will be added/deleted at the same time, I2C
+   core protects against that. */
+static void tuner_lookup(struct i2c_adapter *adap,
+		struct tuner **radio, struct tuner **tv)
+{
+	struct tuner *pos;
+
+	*radio = NULL;
+	*tv = NULL;
+
+	list_for_each_entry(pos, &tuner_list, list) {
+		int mode_mask;
+
+		if (pos->i2c->adapter != adap ||
+		    strcmp(pos->i2c->driver->driver.name, "tuner"))
+			continue;
+
+		mode_mask = pos->mode_mask & ~T_STANDBY;
+		if (*radio == NULL && mode_mask == T_RADIO)
+			*radio = pos;
+		/* Note: currently TDA9887 is the only demod-only
+		   device. If other devices appear then we need to
+		   make this test more general. */
+		else if (*tv == NULL && pos->type != TUNER_TDA9887 &&
+			 (pos->mode_mask & (T_ANALOG_TV | T_DIGITAL_TV)))
+			*tv = pos;
 	}
+}
 
-	switch (t->mode) {
-	case V4L2_TUNER_RADIO:
-		tuner_dbg("Cmd %s accepted for radio\n", cmd);
-		break;
-	case V4L2_TUNER_ANALOG_TV:
-		tuner_dbg("Cmd %s accepted for analog TV\n", cmd);
-		break;
-	case V4L2_TUNER_DIGITAL_TV:
-		tuner_dbg("Cmd %s accepted for digital TV\n", cmd);
-		break;
+/* During client attach, set_type is called by adapter's attach_inform callback.
+   set_type must then be completed by tuner_probe.
+ */
+static int tuner_probe(struct i2c_client *client,
+		       const struct i2c_device_id *id)
+{
+	struct tuner *t;
+	struct tuner *radio;
+	struct tuner *tv;
+
+	t = kzalloc(sizeof(struct tuner), GFP_KERNEL);
+	if (NULL == t)
+		return -ENOMEM;
+	v4l2_i2c_subdev_init(&t->sd, client, &tuner_ops);
+	t->i2c = client;
+	t->name = "(tuner unset)";
+	t->type = UNSET;
+	t->audmode = V4L2_TUNER_MODE_STEREO;
+	t->mode_mask = T_UNINITIALIZED;
+
+	if (show_i2c) {
+		unsigned char buffer[16];
+		int i, rc;
+
+		memset(buffer, 0, sizeof(buffer));
+		rc = i2c_master_recv(client, buffer, sizeof(buffer));
+		tuner_info("I2C RECV = ");
+		for (i = 0; i < rc; i++)
+			printk(KERN_CONT "%02x ", buffer[i]);
+		printk("\n");
 	}
+
+	/* autodetection code based on the i2c addr */
+	if (!no_autodetect) {
+		switch (client->addr) {
+		case 0x10:
+			if (tuner_symbol_probe(tea5761_autodetection,
+					       t->i2c->adapter,
+					       t->i2c->addr) >= 0) {
+				t->type = TUNER_TEA5761;
+				t->mode_mask = T_RADIO;
+				t->mode = T_STANDBY;
+				/* Sets freq to FM range */
+				t->radio_freq = 87.5 * 16000;
+				tuner_lookup(t->i2c->adapter, &radio, &tv);
+				if (tv)
+					tv->mode_mask &= ~T_RADIO;
+
+				goto register_client;
+			}
+			kfree(t);
+			return -ENODEV;
+		case 0x42:
+		case 0x43:
+		case 0x4a:
+		case 0x4b:
+			/* If chip is not tda8290, don't register.
+			   since it can be tda9887*/
+			if (tuner_symbol_probe(tda829x_probe, t->i2c->adapter,
+					       t->i2c->addr) >= 0) {
+				tuner_dbg("tda829x detected\n");
+			} else {
+				/* Default is being tda9887 */
+				t->type = TUNER_TDA9887;
+				t->mode_mask = T_RADIO | T_ANALOG_TV |
+					       T_DIGITAL_TV;
+				t->mode = T_STANDBY;
+				goto register_client;
+			}
+			break;
+		case 0x60:
+			if (tuner_symbol_probe(tea5767_autodetection,
+					       t->i2c->adapter, t->i2c->addr)
+					>= 0) {
+				t->type = TUNER_TEA5767;
+				t->mode_mask = T_RADIO;
+				t->mode = T_STANDBY;
+				/* Sets freq to FM range */
+				t->radio_freq = 87.5 * 16000;
+				tuner_lookup(t->i2c->adapter, &radio, &tv);
+				if (tv)
+					tv->mode_mask &= ~T_RADIO;
+
+				goto register_client;
+			}
+			break;
+		}
+	}
+
+	/* Initializes only the first TV tuner on this adapter. Why only the
+	   first? Because there are some devices (notably the ones with TI
+	   tuners) that have more than one i2c address for the *same* device.
+	   Experience shows that, except for just one case, the first
+	   address is the right one. The exception is a Russian tuner
+	   (ACORP_Y878F). So, the desired behavior is just to enable the
+	   first found TV tuner. */
+	tuner_lookup(t->i2c->adapter, &radio, &tv);
+	if (tv == NULL) {
+		t->mode_mask = T_ANALOG_TV | T_DIGITAL_TV;
+		if (radio == NULL)
+			t->mode_mask |= T_RADIO;
+		tuner_dbg("Setting mode_mask to 0x%02x\n", t->mode_mask);
+		t->tv_freq = 400 * 16; /* Sets freq to VHF High */
+		t->radio_freq = 87.5 * 16000; /* Sets freq to FM range */
+	}
+
+	/* Should be just before return */
+register_client:
+	tuner_info("chip found @ 0x%x (%s)\n", client->addr << 1,
+		       client->adapter->name);
+
+	/* Sets a default mode */
+	if (t->mode_mask & T_ANALOG_TV) {
+		t->mode = V4L2_TUNER_ANALOG_TV;
+	} else  if (t->mode_mask & T_RADIO) {
+		t->mode = V4L2_TUNER_RADIO;
+	} else {
+		t->mode = V4L2_TUNER_DIGITAL_TV;
+	}
+	set_type(client, t->type, t->mode_mask, t->config, t->fe.callback);
+	list_add_tail(&t->list, &tuner_list);
 	return 0;
 }
 
+static int tuner_remove(struct i2c_client *client)
+{
+	struct tuner *t = to_tuner(i2c_get_clientdata(client));
+
+	v4l2_device_unregister_subdev(&t->sd);
+	tuner_detach(&t->fe);
+	t->fe.analog_demod_priv = NULL;
+
+	list_del(&t->list);
+	kfree(t);
+	return 0;
+}
+
+/*
+ * Functions that are specific for TV mode
+ */
+
+/* Set tuner frequency,  freq in Units of 62.5kHz = 1/16MHz */
+static void set_tv_freq(struct i2c_client *c, unsigned int freq)
+{
+	struct tuner *t = to_tuner(i2c_get_clientdata(c));
+	struct analog_demod_ops *analog_ops = &t->fe.ops.analog_ops;
+
+	struct analog_parameters params = {
+		.mode      = t->mode,
+		.audmode   = t->audmode,
+		.std       = t->std
+	};
+
+	if (t->type == UNSET) {
+		tuner_warn ("tuner type not set\n");
+		return;
+	}
+	if (NULL == analog_ops->set_params) {
+		tuner_warn ("Tuner has no way to set tv freq\n");
+		return;
+	}
+	if (freq < tv_range[0] * 16 || freq > tv_range[1] * 16) {
+		tuner_dbg ("TV freq (%d.%02d) out of range (%d-%d)\n",
+			   freq / 16, freq % 16 * 100 / 16, tv_range[0],
+			   tv_range[1]);
+		/* V4L2 spec: if the freq is not possible then the closest
+		   possible value should be selected */
+		if (freq < tv_range[0] * 16)
+			freq = tv_range[0] * 16;
+		else
+			freq = tv_range[1] * 16;
+	}
+	params.frequency = freq;
+	tuner_dbg("tv freq set to %d.%02d\n",
+			freq / 16, freq % 16 * 100 / 16);
+	t->tv_freq = freq;
+
+	analog_ops->set_params(&t->fe, &params);
+}
+
 /* get more precise norm info from insmod option */
 static int tuner_fixup_std(struct tuner *t)
 {
@@ -644,6 +799,116 @@ static int tuner_fixup_std(struct tuner *t)
 	return 0;
 }
 
+/*
+ * Functions that are specific for Radio mode
+ */
+
+static void set_radio_freq(struct i2c_client *c, unsigned int freq)
+{
+	struct tuner *t = to_tuner(i2c_get_clientdata(c));
+	struct analog_demod_ops *analog_ops = &t->fe.ops.analog_ops;
+
+	struct analog_parameters params = {
+		.mode      = t->mode,
+		.audmode   = t->audmode,
+		.std       = t->std
+	};
+
+	if (t->type == UNSET) {
+		tuner_warn ("tuner type not set\n");
+		return;
+	}
+	if (NULL == analog_ops->set_params) {
+		tuner_warn ("tuner has no way to set radio frequency\n");
+		return;
+	}
+	if (freq < radio_range[0] * 16000 || freq > radio_range[1] * 16000) {
+		tuner_dbg ("radio freq (%d.%02d) out of range (%d-%d)\n",
+			   freq / 16000, freq % 16000 * 100 / 16000,
+			   radio_range[0], radio_range[1]);
+		/* V4L2 spec: if the freq is not possible then the closest
+		   possible value should be selected */
+		if (freq < radio_range[0] * 16000)
+			freq = radio_range[0] * 16000;
+		else
+			freq = radio_range[1] * 16000;
+	}
+	params.frequency = freq;
+	tuner_dbg("radio freq set to %d.%02d\n",
+			freq / 16000, freq % 16000 * 100 / 16000);
+	t->radio_freq = freq;
+
+	analog_ops->set_params(&t->fe, &params);
+}
+
+/*
+ * Functions that should be broken into separate radio/TV functions
+ */
+
+static inline int check_mode(struct tuner *t, char *cmd)
+{
+	if ((1 << t->mode & t->mode_mask) == 0) {
+		return -EINVAL;
+	}
+
+	switch (t->mode) {
+	case V4L2_TUNER_RADIO:
+		tuner_dbg("Cmd %s accepted for radio\n", cmd);
+		break;
+	case V4L2_TUNER_ANALOG_TV:
+		tuner_dbg("Cmd %s accepted for analog TV\n", cmd);
+		break;
+	case V4L2_TUNER_DIGITAL_TV:
+		tuner_dbg("Cmd %s accepted for digital TV\n", cmd);
+		break;
+	}
+	return 0;
+}
+
+/*
+ * Switch tuner to other mode. If tuner support both tv and radio,
+ * set another frequency to some value (This is needed for some pal
+ * tuners to avoid locking). Otherwise, just put second tuner in
+ * standby mode.
+ */
+
+static inline int set_mode(struct i2c_client *client, struct tuner *t, int mode, char *cmd)
+{
+	struct analog_demod_ops *analog_ops = &t->fe.ops.analog_ops;
+
+	if (mode == t->mode)
+		return 0;
+
+	t->mode = mode;
+
+	if (check_mode(t, cmd) == -EINVAL) {
+		tuner_dbg("Tuner doesn't support this mode. "
+			  "Putting tuner to sleep\n");
+		t->mode = T_STANDBY;
+		if (analog_ops->standby)
+			analog_ops->standby(&t->fe);
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static void set_freq(struct i2c_client *c, unsigned long freq)
+{
+	struct tuner *t = to_tuner(i2c_get_clientdata(c));
+
+	switch (t->mode) {
+	case V4L2_TUNER_RADIO:
+		set_radio_freq(c, freq);
+		break;
+	case V4L2_TUNER_ANALOG_TV:
+	case V4L2_TUNER_DIGITAL_TV:
+		set_tv_freq(c, freq);
+		break;
+	default:
+		tuner_dbg("freq set: unknown mode: 0x%04x!\n",t->mode);
+	}
+}
+
 static void tuner_status(struct dvb_frontend *fe)
 {
 	struct tuner *t = fe->analog_demod_priv;
@@ -684,62 +949,6 @@ static void tuner_status(struct dvb_frontend *fe)
 			   analog_ops->has_signal(fe));
 }
 
-/* ---------------------------------------------------------------------- */
-
-/*
- * Switch tuner to other mode. If tuner support both tv and radio,
- * set another frequency to some value (This is needed for some pal
- * tuners to avoid locking). Otherwise, just put second tuner in
- * standby mode.
- */
-
-static inline int set_mode(struct i2c_client *client, struct tuner *t, int mode, char *cmd)
-{
-	struct analog_demod_ops *analog_ops = &t->fe.ops.analog_ops;
-
-	if (mode == t->mode)
-		return 0;
-
-	t->mode = mode;
-
-	if (check_mode(t, cmd) == -EINVAL) {
-		tuner_dbg("Tuner doesn't support this mode. "
-			  "Putting tuner to sleep\n");
-		t->mode = T_STANDBY;
-		if (analog_ops->standby)
-			analog_ops->standby(&t->fe);
-		return -EINVAL;
-	}
-	return 0;
-}
-
-static int tuner_s_type_addr(struct v4l2_subdev *sd, struct tuner_setup *type)
-{
-	struct tuner *t = to_tuner(sd);
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-
-	tuner_dbg("Calling set_type_addr for type=%d, addr=0x%02x, mode=0x%02x, config=0x%02x\n",
-			type->type,
-			type->addr,
-			type->mode_mask,
-			type->config);
-
-	set_addr(client, type);
-	return 0;
-}
-
-static int tuner_s_radio(struct v4l2_subdev *sd)
-{
-	struct tuner *t = to_tuner(sd);
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-
-	if (set_mode(client, t, V4L2_TUNER_RADIO, "s_radio") == -EINVAL)
-		return 0;
-	if (t->radio_freq)
-		set_freq(client, t->radio_freq);
-	return 0;
-}
-
 static int tuner_s_power(struct v4l2_subdev *sd, int on)
 {
 	struct tuner *t = to_tuner(sd);
@@ -758,20 +967,18 @@ static int tuner_s_power(struct v4l2_subdev *sd, int on)
 	return 0;
 }
 
-static int tuner_s_config(struct v4l2_subdev *sd, const struct v4l2_priv_tun_config *cfg)
+/* ---------------------------------------------------------------------- */
+
+
+static int tuner_s_radio(struct v4l2_subdev *sd)
 {
 	struct tuner *t = to_tuner(sd);
-	struct analog_demod_ops *analog_ops = &t->fe.ops.analog_ops;
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
 
-	if (t->type != cfg->tuner)
+	if (set_mode(client, t, V4L2_TUNER_RADIO, "s_radio") == -EINVAL)
 		return 0;
-
-	if (analog_ops->set_config) {
-		analog_ops->set_config(&t->fe, cfg->priv);
-		return 0;
-	}
-
-	tuner_dbg("Tuner frontend module has no way to set config\n");
+	if (t->radio_freq)
+		set_freq(client, t->radio_freq);
 	return 0;
 }
 
@@ -956,178 +1163,6 @@ static const struct v4l2_subdev_ops tuner_ops = {
 	.tuner = &tuner_tuner_ops,
 };
 
-/* ---------------------------------------------------------------------- */
-
-static LIST_HEAD(tuner_list);
-
-/* Search for existing radio and/or TV tuners on the given I2C adapter.
-   Note that when this function is called from tuner_probe you can be
-   certain no other devices will be added/deleted at the same time, I2C
-   core protects against that. */
-static void tuner_lookup(struct i2c_adapter *adap,
-		struct tuner **radio, struct tuner **tv)
-{
-	struct tuner *pos;
-
-	*radio = NULL;
-	*tv = NULL;
-
-	list_for_each_entry(pos, &tuner_list, list) {
-		int mode_mask;
-
-		if (pos->i2c->adapter != adap ||
-		    strcmp(pos->i2c->driver->driver.name, "tuner"))
-			continue;
-
-		mode_mask = pos->mode_mask & ~T_STANDBY;
-		if (*radio == NULL && mode_mask == T_RADIO)
-			*radio = pos;
-		/* Note: currently TDA9887 is the only demod-only
-		   device. If other devices appear then we need to
-		   make this test more general. */
-		else if (*tv == NULL && pos->type != TUNER_TDA9887 &&
-			 (pos->mode_mask & (T_ANALOG_TV | T_DIGITAL_TV)))
-			*tv = pos;
-	}
-}
-
-/* During client attach, set_type is called by adapter's attach_inform callback.
-   set_type must then be completed by tuner_probe.
- */
-static int tuner_probe(struct i2c_client *client,
-		       const struct i2c_device_id *id)
-{
-	struct tuner *t;
-	struct tuner *radio;
-	struct tuner *tv;
-
-	t = kzalloc(sizeof(struct tuner), GFP_KERNEL);
-	if (NULL == t)
-		return -ENOMEM;
-	v4l2_i2c_subdev_init(&t->sd, client, &tuner_ops);
-	t->i2c = client;
-	t->name = "(tuner unset)";
-	t->type = UNSET;
-	t->audmode = V4L2_TUNER_MODE_STEREO;
-	t->mode_mask = T_UNINITIALIZED;
-
-	if (show_i2c) {
-		unsigned char buffer[16];
-		int i, rc;
-
-		memset(buffer, 0, sizeof(buffer));
-		rc = i2c_master_recv(client, buffer, sizeof(buffer));
-		tuner_info("I2C RECV = ");
-		for (i = 0; i < rc; i++)
-			printk(KERN_CONT "%02x ", buffer[i]);
-		printk("\n");
-	}
-
-	/* autodetection code based on the i2c addr */
-	if (!no_autodetect) {
-		switch (client->addr) {
-		case 0x10:
-			if (tuner_symbol_probe(tea5761_autodetection,
-					       t->i2c->adapter,
-					       t->i2c->addr) >= 0) {
-				t->type = TUNER_TEA5761;
-				t->mode_mask = T_RADIO;
-				t->mode = T_STANDBY;
-				/* Sets freq to FM range */
-				t->radio_freq = 87.5 * 16000;
-				tuner_lookup(t->i2c->adapter, &radio, &tv);
-				if (tv)
-					tv->mode_mask &= ~T_RADIO;
-
-				goto register_client;
-			}
-			kfree(t);
-			return -ENODEV;
-		case 0x42:
-		case 0x43:
-		case 0x4a:
-		case 0x4b:
-			/* If chip is not tda8290, don't register.
-			   since it can be tda9887*/
-			if (tuner_symbol_probe(tda829x_probe, t->i2c->adapter,
-					       t->i2c->addr) >= 0) {
-				tuner_dbg("tda829x detected\n");
-			} else {
-				/* Default is being tda9887 */
-				t->type = TUNER_TDA9887;
-				t->mode_mask = T_RADIO | T_ANALOG_TV |
-					       T_DIGITAL_TV;
-				t->mode = T_STANDBY;
-				goto register_client;
-			}
-			break;
-		case 0x60:
-			if (tuner_symbol_probe(tea5767_autodetection,
-					       t->i2c->adapter, t->i2c->addr)
-					>= 0) {
-				t->type = TUNER_TEA5767;
-				t->mode_mask = T_RADIO;
-				t->mode = T_STANDBY;
-				/* Sets freq to FM range */
-				t->radio_freq = 87.5 * 16000;
-				tuner_lookup(t->i2c->adapter, &radio, &tv);
-				if (tv)
-					tv->mode_mask &= ~T_RADIO;
-
-				goto register_client;
-			}
-			break;
-		}
-	}
-
-	/* Initializes only the first TV tuner on this adapter. Why only the
-	   first? Because there are some devices (notably the ones with TI
-	   tuners) that have more than one i2c address for the *same* device.
-	   Experience shows that, except for just one case, the first
-	   address is the right one. The exception is a Russian tuner
-	   (ACORP_Y878F). So, the desired behavior is just to enable the
-	   first found TV tuner. */
-	tuner_lookup(t->i2c->adapter, &radio, &tv);
-	if (tv == NULL) {
-		t->mode_mask = T_ANALOG_TV | T_DIGITAL_TV;
-		if (radio == NULL)
-			t->mode_mask |= T_RADIO;
-		tuner_dbg("Setting mode_mask to 0x%02x\n", t->mode_mask);
-		t->tv_freq = 400 * 16; /* Sets freq to VHF High */
-		t->radio_freq = 87.5 * 16000; /* Sets freq to FM range */
-	}
-
-	/* Should be just before return */
-register_client:
-	tuner_info("chip found @ 0x%x (%s)\n", client->addr << 1,
-		       client->adapter->name);
-
-	/* Sets a default mode */
-	if (t->mode_mask & T_ANALOG_TV) {
-		t->mode = V4L2_TUNER_ANALOG_TV;
-	} else  if (t->mode_mask & T_RADIO) {
-		t->mode = V4L2_TUNER_RADIO;
-	} else {
-		t->mode = V4L2_TUNER_DIGITAL_TV;
-	}
-	set_type(client, t->type, t->mode_mask, t->config, t->fe.callback);
-	list_add_tail(&t->list, &tuner_list);
-	return 0;
-}
-
-static int tuner_remove(struct i2c_client *client)
-{
-	struct tuner *t = to_tuner(i2c_get_clientdata(client));
-
-	v4l2_device_unregister_subdev(&t->sd);
-	tuner_detach(&t->fe);
-	t->fe.analog_demod_priv = NULL;
-
-	list_del(&t->list);
-	kfree(t);
-	return 0;
-}
-
 /* ----------------------------------------------------------------------- */
 
 /* This driver supports many devices and the idea is to let the driver
@@ -1165,10 +1200,6 @@ static __exit void exit_tuner(void)
 module_init(init_tuner);
 module_exit(exit_tuner);
 
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-basic-offset: 8
- * End:
- */
+MODULE_DESCRIPTION("device driver for various TV and TV+FM radio tuners");
+MODULE_AUTHOR("Ralph Metzler, Gerd Knorr, Gunther Mayer");
+MODULE_LICENSE("GPL");
-- 
1.7.1


